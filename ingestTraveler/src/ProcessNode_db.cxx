#include "db/MysqlConnection.h"
#include "db/MysqlResults.h"
#include "ProcessNode.h"
#include "ProcessEdge.h"
#include "PrerequisiteNode.h"
#include "InputNode.h"
#include "CloneNode.h"
#include <cstdio>
#include <iostream>
#include <algorithm>
#include "Util.h"
#include "Timestamp.h"
#include "db/MysqlUtil.h"
#include "db/MysqlUtilException.h"

rdbModel::Connection* BaseNode::s_connection=NULL;
int                   BaseNode::s_major=0;
int                   BaseNode::s_minor=1;

//                  **  BaseNode  **
// static routines 
void BaseNode::setDbConnection(rdbModel::Connection* c) {
  if (s_connection != NULL) s_connection->close();
  s_connection = c;
}

void BaseNode::clearDbConnection() {
  if (s_connection != NULL) {
    delete s_connection;
    s_connection = NULL;
  }
}

/**
   Map hardware relationship type names to ids
 */
static std::map<std::string, std::string> relationshipTypes;

// Regular member routines 

// Return true iff major versions match and db minor version is >= s_minor
// If test is false (default) look only for row with status = 'CURRENT'
bool BaseNode::dbIsCompatible(bool test) {
  if (s_connection == NULL) return false;

  // Make query to db 
  // SELECT major, minor from DbRelease where status = 'CURRENT'
  // if not found and test = true
  //    SELECT major, minor from DbRelease where status = 'TEST'
  // else return false;
  // Check for compatibility against BaseNode::s_major, BaseNode::s_minor
  return true;
}


//               **  ProcessNode **

int ProcessNode::verify(rdbModel::Connection* connect) {
  // Check that hdwr type, hdwr relationship types mentioned exist in db
  using rdbModel::MysqlUtil;
  int ret = 0;

  if (s_connection == NULL) {
    std::cerr << "Cannot verify input without db connection" << std::endl;
    return 1;
  }

  // Certain things only need to be checked for root node
  if (m_parent == NULL) {
    relationshipTypes.clear();
    try {
      m_hardwareId = 
        MysqlUtil::getColumnValue(s_connection, "HardwareType",
                                  "id", "name", m_inputs["HardwareType"]);
    }  catch (rdbModel::MysqlUtilException ex) {
      std::cerr << "Specified hardware type not found in db" << std::endl;
      std::cerr << ex.what() << std::endl;
      return 2;
    }

    // Now look for hardware relationship types if any are used 
    if (s_relationTypes.size() > 0)  {

      std::vector<std::string> getCols;
      getCols.push_back("name");
      getCols.push_back("id");
      rdbModel::ResultHandle* results = 
        s_connection->select("HardwareRelationshipType", getCols, getCols, "");
      int nRows = results->getNRows();
      std::vector<std::string> fields;
      std::set<std::string> dbvals;
      for (int i=0; i < nRows; i++) {
        results->getRow(fields, i);
        dbvals.insert(fields[0]);
        relationshipTypes[fields[0]] = fields[1];
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
    }    // end hardware relationship types
  }    // end of root-only processing

  // Should perhaps also check that (process name, hardware type)
  // is not already in db for each process.
  
  // Check prerequisites
  for (int i = 0; i < m_prerequisites.size(); i++) {
    ret = m_prerequisites[i]->verify(s_connection);
    if (ret != 0) return ret;
  }

  // Check input nodes
  for (int i = 0; i < m_inputNodes.size(); i++) {
    ret = m_inputNodes[i]->verify(s_connection);
    if (ret != 0) return ret;
  }

  // Recurse   (but can skip clones)
  for (int i = 0; i < m_children.size(); i++) {
    ProcessNode* childProc = dynamic_cast<ProcessNode* >(m_children[i]);
    if (childProc != NULL) {
      ret = childProc->verify(s_connection);
      if (ret != 0) return ret;
    }
  }
  return ret;
}

int ProcessNode::writeDb(rdbModel::Connection* connect) {
  // write a Process row for ourselves
  using rdbModel::MysqlUtil;

  bool ok;
  std::vector<std::string> cols;
  std::vector<std::string> nullCols;
  std::vector<std::string> vals;

  cols.push_back("name");
  vals.push_back(m_inputs["Name"]);
  cols.push_back("hardwareTypeId");
  vals.push_back(m_hardwareId);
  cols.push_back("version");
  ///    vals.push_back("1");               // TEMPORARY
  if (m_version.size() == 0) m_version = "1";
  vals.push_back(m_version);

  // If version is not 1, verify stage should have done do 
  // SELECT id from Process where name=<our name> and
  // hardwareTypeId = <our type id> and version=1 and saved
  // result (if any) as m_originalId.  If the query doesn't
  // return anything, we fail verify step 
  cols.push_back("substeps");
  if (m_sequenceCount > 0) vals.push_back("SEQUENCE");
  else if (m_optionCount > 0) vals.push_back("SELECTION");
  else vals.push_back("NONE");
  if (m_inputs.find("HardwareRelationshipType") != m_inputs.end()) {
    // find assoc. id and fill it in
    std::string hrtId = relationshipTypes[m_inputs["HardwareRelationshipType"]];
    cols.push_back("hardwareRelationshipTypeId");
    vals.push_back(hrtId);
    if ((m_travelerActionMask & ACTIONBIT_BREAK_HARDWARE_RELATIONSHIP) == 0){
      m_travelerActionMask |= ACTIONBIT_MAKE_HARDWARE_RELATIONSHIP;
    }
    //  Find out what components are needed for this relationship type.
    // Add new prerequisites if they weren't already in the yaml

    //  BUT ONLY if relationship is a 'MAKE', not a 'BREAK' **** <--
    if ((m_travelerActionMask & ACTIONBIT_MAKE_HARDWARE_RELATIONSHIP) != 0) {
      std::string component1id;
      std::string component2id;
      try {
        component1id = 
          MysqlUtil::getColumnValue(s_connection, "HardwareRelationshipType",
                                    "hardwareTypeId", "id", hrtId);
        component2id = 
          MysqlUtil::getColumnValue(s_connection, "HardwareRelationshipType",
                                    "componentTypeId", "id", hrtId);
      } catch (rdbModel::MysqlUtilException ex) {
        std::cerr << ex.what() << std::endl;
        return 1;
      }
      if (component1id != m_hardwareId) { // might need another prereq
        addComponentPrerequisite(component1id);
      }
      if (component2id != m_hardwareId) { // might need another prereq
        addComponentPrerequisite(component2id);
      }
    }

  } else nullCols.push_back("hardwareRelationshipTypeId");
  if (m_inputs.find("Description") != m_inputs.end()) {
    cols.push_back("description");
    vals.push_back(m_inputs["Description"]);
  }
  else nullCols.push_back("description");

  if (m_inputs.find("UserVersionString") != m_inputs.end()) {
    cols.push_back("userVersionString");
    vals.push_back(m_inputs["UserVersionString"]);
  }
  else nullCols.push_back("userVersionString");

  if (m_inputs.find("InstructionsURL") != m_inputs.end()) {
    cols.push_back("instructionsURL");
    vals.push_back(m_inputs["InstructionsURL"]);
  }
  else nullCols.push_back("instructionsURL");

  if (m_travelerActionMask != 0) {
    cols.push_back("travelerActionMask");
    std::string actionVal;
    facilities::Util::utoa(m_travelerActionMask, actionVal);
    vals.push_back(actionVal);
  }
  cols.push_back("createdBy");
  vals.push_back(s_user);
  cols.push_back("creationTS");
  facilities::Timestamp curTime;
  vals.push_back(curTime.getString());
  
  int newId;
  ok = s_connection->insertRow("Process", cols, vals, &newId, &nullCols);
  if (!ok) {
    std::cerr << "Unable to write to db for process step " << m_inputs["Name"]
              << std::endl;
    return 1;
  }
  facilities::Util::itoa(newId, m_processId);
  if (m_parentEdge != NULL) {
    std::string cond;
    if (m_isOption) m_parentEdge->setCondition(m_inputs["Condition"]);
    int edgeStatus = m_parentEdge->writeDb(s_connection, s_user, m_processId);
    if (edgeStatus != 0) return edgeStatus;
  }
  // Update originalId field
  {
    rdbModel::StringVector updateCol;
    rdbModel::StringVector updateVal;

    updateCol.push_back("originalId");
    updateVal.push_back(m_processId);
    std::string updateWhere(" where id='");
    updateWhere += m_processId;
    updateWhere += std::string("'");
    
    unsigned int nUpdated = 
      s_connection->update("Process", updateCol, updateVal, updateWhere);
    if (nUpdated != 1) {
      std::cerr << "Unable to update originalId field for process step "
                << m_inputs["Name"] << std::endl;
      return 1;
    }
  } 
  // Write prerequisites, if any
  for (int i = 0; i < m_prerequisites.size(); i++) {
    int prereqStatus = m_prerequisites[i]->writeDb(s_connection);
    if (prereqStatus != 0) return prereqStatus;
  }

  // Write input patterns, if any
  for (int i = 0; i < m_inputNodes.size(); i++) {
    int inputNodesStatus = m_inputNodes[i]->writeDb(s_connection);
    if (inputNodesStatus != 0) return inputNodesStatus;
  }

  for (int i = 0; i < m_children.size(); i++) {
    ProcessNode* childProc = dynamic_cast<ProcessNode* >(m_children[i]);
    if (childProc != NULL) childProc->setHardwareId(m_hardwareId);
    int childStatus = m_children[i]->writeDb(connect);
    if (childStatus != 0) return childStatus;
  }
  return 0;
}

void ProcessNode::addComponentPrerequisite(const std::string& componentId) {
  static std::string prereqTypeId = "";
  // Check existing prerequisites to see if any have this component id
  for (int ip = 0; ip < m_prerequisites.size(); ip++) {
    if ((m_prerequisites[ip]->getComponent().size() > 0 ) &&
        (m_prerequisites[ip]->getPrereqId() == componentId)) return;
  }
  std::string name;
  using rdbModel::MysqlUtil;

  try {
    name = MysqlUtil::getColumnValue(s_connection, "HardwareType",
                                     "name", "id", componentId);
  } catch (rdbModel::MysqlUtilException ex) {
    std::cerr << "Hardware type with id " << componentId << " not found"
              << std::endl;
    std::cerr << ex.what() << std::endl;
    exit(1);
  }
  if (prereqTypeId == "") {
    try {
      prereqTypeId = 
        MysqlUtil::getColumnValue(s_connection, "PrerequisiteType", "id",
                                  "name", "COMPONENT");
    } catch (rdbModel::MysqlUtilException ex) {
      std::cerr << "Prerequisite type COMPONENT not found in db" << std::endl;
      std::cerr << ex.what() << std::endl;
      exit(1);
    }
  }
  PrerequisiteNode* newNode = 
    new PrerequisiteNode::PrerequisiteNode(this, s_user, name, componentId,
                                   prereqTypeId);
  m_prerequisites.push_back(newNode);

}

//                   ** ProcessEdge **

int ProcessEdge::writeDb(rdbModel::Connection* connection, 
                         const std::string& user,
                         std::string& childId) {
  std::vector<std::string> cols;
  std::vector<std::string> vals;
  cols.push_back("parent");
  vals.push_back(m_parent->getProcessId());
  cols.push_back("child");
  vals.push_back(childId);
  cols.push_back("step");
  std::string stepstring;
  facilities::Util::itoa(m_step, stepstring);
  vals.push_back(stepstring);
  cols.push_back("cond");
  vals.push_back(m_condition);
  cols.push_back("createdBy");
  vals.push_back(user);
  cols.push_back("creationTS");
  facilities::Timestamp curTime;
  vals.push_back(curTime.getString());

  int newId;
  bool ok = connection->insertRow("ProcessEdge", cols, vals, &newId);
  if (!ok) {
    std::cerr << "Failed to write ProcessEdge row" << std::endl;
    return 1;
  }
  facilities::Util::itoa(newId, m_edgeId);
  return 0;
}

//         *** CloneNode ***
int CloneNode::writeDb(rdbModel::Connection* connection) {
  // All we need to do is write a new edge

  std::string modelId = m_model->getProcessId();
  m_parentEdge->setCondition(m_condition);
  return m_parentEdge->writeDb(s_connection, s_user, modelId);// m_condition);
}

//        **** PrerequisiteNode ****
int PrerequisiteNode::verify(rdbModel::Connection* connect) {
  using rdbModel::MysqlUtil;
  int ret = 0;

  if (connect == NULL) {
    std::cerr << "Cannot verify input without db connection" << std::endl;
    return 1;
  }

  // Check that PrerequisiteType value is valid and find id
  try {
    m_prereqTypeId = 
      MysqlUtil::getColumnValue(s_connection, "PrerequisiteType", "id",
                                "name", m_inputs["PrerequisiteType"]);
  } catch (rdbModel::MysqlUtilException ex) {
    std::cerr << ex.what() << std::endl;
    return 1;
  }

  // If type is COMPONENT, check that name matches HardwareType.name 
  //    cache corresponding HardwareType.id
  std::string where;
  if (m_component != "") {
    where = std::string(" where name = '") + m_component +  "'";

    try {
      m_prereqId = MysqlUtil::getColumnWhere(s_connection, "HardwareType",
                                             "id", where);
    } catch (rdbModel::MysqlUtilException ex) {
      std::cerr << "Unable to find hardware type " << m_component << std::endl;
      std::cerr << ex.what() << std::endl;
      return 1;
    }
  }
  return 0;
}

int PrerequisiteNode::writeDb(rdbModel::Connection* connect) {
  using rdbModel::MysqlUtil;

  std::vector<std::string> cols;
  std::vector<std::string> nullCols;
  std::vector<std::string> vals;

  // name = m_inputs["Name"]
  cols.push_back("name");
  vals.push_back(m_name);

  // prerequisiteTypeId = m_prereqTypeId
  cols.push_back("prerequisiteTypeId");
  vals.push_back(m_prereqTypeId);

  // processId = m_processId
  cols.push_back("processId");
  vals.push_back(m_parent->getProcessId());

  // prereqProcessId = m_prereqId  - if appropriate
  if (m_processName != "") {
    // If type is PROCESS_STEP, check that (name, version) or 
    // (name, userVersionString) matches entry in Process; cache Process.id
    std::string where;
    where = std::string(" where name ='") + m_processName + 
      std::string("' and ");
    if (m_version != "") where += std::string("version = '") + m_version;
    else {
      where += std::string("userVersionString = '") +
        m_inputs["UserVersionString"];
    }
    where += std::string("' and hardwareTypeId = '") 
      + m_parent->getHardwareId() + "'";

    try {
      m_prereqId = MysqlUtil::getColumnWhere(s_connection, "Process",
                                             "id", where);
    } catch (rdbModel::MysqlUtilException ex) {
      std::cerr << "Unable to find specified Process version" << std::endl;
      std::cerr << ex.what() << std::endl;
      return 1;
    }

    //
    cols.push_back("prereqProcessId");
    vals.push_back(m_prereqId);
  } else if (m_component != "") {
    // hardwareTypeId = m_prereqId  - if appropriate
    cols.push_back("hardwareTypeId");
    vals.push_back(m_prereqId);
  }

  // description = m_inputs["Description"]    - if exists
  if (m_inputs.find("Description") != m_inputs.end()) {
    cols.push_back("description");
    vals.push_back(m_inputs["Description"]);
  }
  else nullCols.push_back("description");

  // quantity = m_inputs["Quantity"]       - if exists
  if (m_inputs.find("Quantity") != m_inputs.end()) {
    cols.push_back("quantity");
    vals.push_back(m_inputs["Quantity"]);
  }
  cols.push_back("createdBy");
  vals.push_back(m_user);
  cols.push_back("creationTS");
  facilities::Timestamp curTime;
  vals.push_back(curTime.getString());

  int newId;
  bool ok = s_connection->insertRow("PrerequisitePattern", cols, vals, 
                                    &newId, &nullCols);
  if (ok) return 0;

  std::cerr << "Failed to write to db for prerequisite " << m_inputs["Name"]
            << std::endl;
  return 1;
}
  //                *** InputNode ***
int InputNode::verify(rdbModel::Connection* connect) {
  using rdbModel::MysqlUtil;
  int ret = 0;

  if (connect == NULL) {
    std::cerr << "Cannot verify input without db connection" << std::endl;
    return 1;
  }

  // Check that InputSemantics value is valid and find id
  try {
    m_inputSemanticsId = 
      MysqlUtil::getColumnValue(s_connection, "InputSemantics", "id",
                                "name", m_inputs["InputSemantics"]);
  } catch (rdbModel::MysqlUtilException ex) {
    std::cerr << "Unable to find InputSemantics value " << 
      m_inputs["InputSemantics"] << " in database" << std::endl;
    std::cerr << ex.what() << std::endl;
    return 1;
  }
  return 0;
}

int InputNode::writeDb(rdbModel::Connection* connect) {
  using rdbModel::MysqlUtil;

  std::vector<std::string> cols;
  std::vector<std::string> nullCols;
  std::vector<std::string> vals;

  // label = m_inputs["Label"]
  cols.push_back("label");
  vals.push_back(m_inputs["Label"]);

  // inputSemanticsId = m_inputSemanticsId
  cols.push_back("inputSemanticsId");
  vals.push_back(m_inputSemanticsId);

  // processId = m_processId
  cols.push_back("processId");
  vals.push_back(m_parent->getProcessId());

  // description, units, minV, maxV are all optional
  if (m_inputs.find("Description") != m_inputs.end()) {
    cols.push_back("description");
    vals.push_back(m_inputs["Description"]);
  }
  else nullCols.push_back("description");

  if (m_inputs.find("Units") != m_inputs.end()) {
    cols.push_back("units");
    vals.push_back(m_inputs["Units"]);
  }
  else nullCols.push_back("units");

  if (m_inputs.find("MinValue") != m_inputs.end()) {
    cols.push_back("minV");
    vals.push_back(m_inputs["MinValue"]);
  }
  else nullCols.push_back("minV");

  if (m_inputs.find("MaxValue") != m_inputs.end()) {
    cols.push_back("maxV");
    vals.push_back(m_inputs["MaxValue"]);
  }
  else nullCols.push_back("maxV");

  cols.push_back("createdBy");
  vals.push_back(m_user);
  cols.push_back("creationTS");
  facilities::Timestamp curTime;
  vals.push_back(curTime.getString());

  int newId;
  bool ok = s_connection->insertRow("InputPattern", cols, vals, 
                                    &newId, &nullCols);
  if (ok) return 0;

  std::cerr << "Failed to write to db for input pattern " << m_inputs["Label"]
            << std::endl;
  return 1;
}


int ProcessNode::readDb(const std::string& id, const std::string& edgeId) {

  using rdbModel::StringVector;
  // If parent is NULL, must have non-empty id.  Else will have 
  // non-empty edgeId.
  if (edgeId != std::string("") ) {
    // SELECT  child, step, cond from ProcessEdge where id = edgeId
    std::string where = std::string(" WHERE id=") + edgeId;
    rdbModel::ResultHandle* handle = 0;
    
    StringVector getCols;
    getCols.push_back("child");
    //getCols.push_back("step");
    getCols.push_back("cond");
    handle = s_connection->select("ProcessEdge", getCols, getCols, where);
    if (handle == NULL) {
      std::cerr << "Cannot find edge with id= " << edgeId << std::endl;
      exit(1);
    }
    if (handle->getNRows() != 1) {
      std::cerr << "Cannot find edge with id= " << edgeId << std::endl;
      delete handle;
      exit(1);
    }
    std::vector<std::string> fields;
    handle->getRow(fields);
    m_processId = fields[0];   // child
    m_parentEdge->setCondition(fields[1]);
    m_parentEdge->setId(edgeId);
    delete handle;
  } else {
     // check id arg is not ""
    m_processId = id;  
  }
  // SELECT pile of stuff from Process where id = m_processId
  std::string where = std::string(" WHERE id=") + m_processId;
  rdbModel::ResultHandle* handle = 0;
  StringVector getCols;
  getCols.push_back("name");
  getCols.push_back("originalId");
  getCols.push_back("hardwareTypeId");
  getCols.push_back("version");
  getCols.push_back("userVersionString");
  getCols.push_back("description");
  getCols.push_back("maxIteration");
  getCols.push_back("substeps");
  getCols.push_back("travelerActionMask");

  handle = s_connection->select("Process", getCols, getCols, where);
  if (handle == NULL) {
    std::cerr << "Cannot find process with id= " << m_processId << std::endl;
    exit(1);
  }
  if (handle->getNRows() != 1) {
    std::cerr << "Cannot find process with id= " << m_processId << std::endl;
    delete handle;
    exit(1);
  }
  std::vector<std::string> fields;
  handle->getRow(fields);
  delete handle;
  handle = 0;

  std::vector<std::string>::const_iterator it = fields.begin();
  m_name = *it++;
  m_originalId = *it++;
  m_hardwareId = *it++;
  m_version = *it++;
  m_userVersionString =*it++;
  m_description = *it++;
  m_maxIteration = *it++;
  m_substeps = *it++;
  try {
    m_travelerActionMask = facilities::Util::stringToUnsigned(*it++);
  }
  catch (std::exception ex) {
    std::cerr << "Improper Process.travelerActionMask" << std::endl;
    exit(1);
  }
  if (m_substeps == "NONE") return 0;   // all done

  where = std::string(" where parent=")+m_processId +  
    std::string(" ORDER BY ABS(step) ");
  std::vector<std::string> orderCols;   // empty
  getCols.clear();
  getCols.push_back("step");
  getCols.push_back("id");

  handle = s_connection->select("ProcessEdge", getCols, orderCols, where);
  if (handle == NULL) {
    std::cerr << "Failed query to find edges for " << m_processId << std::endl;
    exit(1);
  }

  int nChildren = handle->getNRows();
  for (int i = 0; i < nChildren; i++) {
    fields.clear();
    handle->getRow(fields, i);
    int step = facilities::Util::stringToInt(fields[0]);
    ProcessNode* child = new ProcessNode(this, step);
    child->readDb("", fields[1]);
    m_children.push_back(child);
  }
  if (m_substeps == "SEQUENCE") m_sequenceCount = nChildren;
  else {
    m_optionCount = nChildren;
    m_isOption = true;
  }
  delete handle;
  return 0;
}
