#include "db/MysqlConnection.h"
#include "db/MysqlResults.h"
#include "ProcessNode.h"
#include "ProcessEdge.h"
#include <cstdio>
#include <iostream>
#include <algorithm>
#include "Util.h"
#include "Timestamp.h"
#include "db/MysqlUtil.h"
#include "db/MysqlUtilException.h"

rdbModel::Connection* ProcessNode::s_connection=NULL;


// static routines
void ProcessNode::setDbConnection(rdbModel::Connection* c) {
  if (s_connection != NULL) s_connection->close();
  s_connection = c;
}

void ProcessNode::clearDbConnection() {
  if (s_connection != NULL) {
    delete s_connection;
    s_connection = NULL;
  }
}

int ProcessNode::verify(rdbModel::Connection* connect) {
  // Check that hardware type and any hardware relationship types mentioned
  // exist in db
  int ret = 0;
  if (m_parent != NULL) return ret;
  if (s_connection == NULL) {
    std::cerr << "Cannot verify input without db connection" << std::endl;
    return 1;
  }
  std::vector<std::string> getCols;
  std::string where = " where name = '";
  where += m_inputs["HardwareType"];
  where += "'";
  getCols.push_back("id");
  rdbModel::ResultHandle* results = 
    s_connection->select("HardwareType", getCols, getCols, where);
  if (results == NULL) {
    std::cerr << "Query to find hardware type failed " << std::endl;
    return 2;
  }
  if (results->getNRows() != 1) {
    std::cerr << "Hardware type " << m_inputs["HardwareType"] << " not found"
              << std::endl;
    delete results;
    return 3;
  }  else  {
    std::vector<std::string> fields;
    results->getRow(fields);
    m_hardwareId = fields[0];
  }
  delete results;
  // Now look for hardware relationship types
  if (s_relationTypes.size() == 0)  return 0;

  getCols[0] = "name";
  results = s_connection->select("HardwareRelationshipType", getCols, 
                                 getCols, "");
  int nRows = results->getNRows();
  std::vector<std::string> fields;
  std::set<std::string> dbvals;
  for (int i=0; i < nRows; i++) {
    results->getRow(fields, i);
    dbvals.insert(fields[0]);
  }
  delete results;
  std::set<std::string>::iterator dbvalsBegin, dbvalsEnd;
  dbvalsBegin = dbvals.begin();
  dbvalsEnd = dbvals.end();
  std::set<std::string>::iterator relationsBegin, relationsEnd;
  relationsBegin = s_relationTypes.begin();
  relationsEnd = s_relationTypes.end();
  if (!std::includes(dbvalsBegin, dbvalsEnd, relationsBegin, relationsEnd) )
  {
    std::cerr << "One or more unknown hardware relation types" << std::cout;
    return 4;
  }
  // Should perhaps also check that (process name, hardware type)
  // is not already in db for each process.

  return ret;
}

int ProcessNode::writeDb(rdbModel::Connection* connect, bool recurse) {
  // write a Process row for ourselves

  bool ok;
  std::vector<std::string> cols;
  std::vector<std::string> nullCols;
  std::vector<std::string> vals;

  cols.push_back("name");
  vals.push_back(m_inputs["Name"]);
  cols.push_back("hardwareTypeId");
  vals.push_back(m_hardwareId);
  cols.push_back("version");
  vals.push_back("1");               // TEMPORARY
  if (m_inputs.find("HardwareRelationshipType") != m_inputs.end()) {
    // find assoc. id and fill it in
    std::string hrtId;
    try {
      hrtId =
        rdbModel::MysqlUtil::getColumnValue(s_connection, 
                                            "HardwareRelationshipType",
                                            "id", "name", 
                                            m_inputs["HardwareRelationshipType"]);
    }
    catch (rdbModel::MysqlUtilException ex) {
      std::cerr << ex.what() << std::endl;
      return 1;
    }
    cols.push_back("hardwareRelationshipTypeId");
    vals.push_back(hrtId);
  } else nullCols.push_back("hardwareRelationshipTypeId");
  if (m_inputs.find("Description") != m_inputs.end()) {
    cols.push_back("description");
    vals.push_back(m_inputs["Description"]);
  }
  else nullCols.push_back("description");
  if (m_inputs.find("InstructionsURL") != m_inputs.end()) {
    cols.push_back("instructionsURL");
    vals.push_back(m_inputs["InstructionsURL"]);
  }
  else nullCols.push_back("instructionsURL");
  cols.push_back("createdBy");
  vals.push_back(s_user);
  cols.push_back("creationTS");
  facilities::Timestamp curTime;
  vals.push_back(curTime.getString());
  
  int newId;
  ok = s_connection->insertRow("Process", cols, vals, &newId, &nullCols);
  
  facilities::Util::itoa(newId, m_processId);
  if (m_parentEdge != NULL) {
    m_parentEdge->writeDb(s_connection, s_user, m_processId);
  }
    
  if (recurse) {
    for (int i = 0; i < m_children.size(); i++) {
      m_children[i]->setHardwareId(m_hardwareId);
      m_children[i]->writeDb();
    }
  }
  return 0;
}


int ProcessEdge::writeDb(rdbModel::Connection* connection, std::string user,
                         std::string childId) {
  std::vector<std::string> cols;
  std::vector<std::string> vals;
  cols.push_back("parent");
  vals.push_back(m_parent->getProcessId());
  cols.push_back("child");
  vals.push_back(childId);
  cols.push_back("step");
  std::string stepstring;
  facilities::Util::itoa(m_childCount, stepstring);
  vals.push_back(stepstring);
  cols.push_back("createdBy");
  vals.push_back(user);
  cols.push_back("creationTS");
  facilities::Timestamp curTime;
  vals.push_back(curTime.getString());

  int newId;
  bool ok = connection->insertRow("ProcessEdge", cols, vals, &newId);
  facilities::Util::itoa(newId, m_edgeId);
}
