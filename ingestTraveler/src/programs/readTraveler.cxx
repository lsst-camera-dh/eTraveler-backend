/*  Read specified traveler from db, maybe just Process and ProcessEdge
    info to start; later add option to include full definition (Prerquisites,
    InputPatterns, etc.0
    Option to output to yaml?
 */
#include <cstdio>
#include <iostream>
#include "yaml-cpp/yaml.h"
#include "ProcessNode.h"
#include "Util.h"
#include "../db/MysqlConnection.h"
#include "../db/MysqlUtil.h"
main(int argc, char* argv[])  {
  if (argc < 2) {
    std::cout << "Missing required argument: traveler name" << std::endl;

    std::cout << "Call interface example: " << std::endl << std::endl;
    std::cout << "     readTraveler Sensor_T03 1 rd_lsst_camt" 
              << std::endl << std::endl;
    std::cout << "Second argument (version) defaults to 1" << std::endl;
    // Do we also need to allow for git tag as user version string?

    std::cout << "Third argument (database name) defaults to rd_lsst_cam"
              << std::endl;
    //std::cout << "Special database name 'fake' may be used to check yaml syntax"
    //          << std::endl;
    exit(1);
  }
  // Process version
  std::string processVersion("1");
  
  if (argc >=3)  {
    try {
      int intVersion = facilities::Util::atoi(std::string(argv[2]));
      processVersion = std::string(argv[2]);
    }
    catch (std::exception& err) {
      std::cerr << "Process version must be an int" << std::endl;
      exit(1);
    }
  }
  // Next arg can be used for db name; choose a sensible default
  std::string dbName ="rd_lsst_cam";
  if (argc >= 4) dbName = std::string(argv[3]);
  
  // Set up db connection
  // E.g., using form which gets info from .my.cnf

  std::string grp = dbName + "_ingest";
  rdbModel::MysqlConnection* connection = 
    new rdbModel::MysqlConnection();
  connection->init();
  //  Following causes user, pwd to be read from default file,
  //  avoiding plain text in open statement.
  connection->setOption(rdbModel::DBreadDefaultGroup, grp.c_str());
  if (!connection->open("mysql-dev01.slac.stanford.edu:3307", 
                        NULL, NULL, dbName.c_str())) {
    std::cerr << "Failed to connect to database " << dbName 
              << " host " << "mysql-dev01.slac.stanford.edu" << std::endl;
    exit(1);
  }
 
  // Look for Process entry with correct name, version; save Process.id
  std::string where(" WHERE name='");
  where += std::string(argv[1]) + "' AND version='";
  where += processVersion + std::string("' ");
  std::string processId;
  try {
    processId = rdbModel::MysqlUtil::getColumnWhere(connection, "Process",
                                          "id", where);
  }
  catch (std::exception& ex)  {
    std::cerr << "Could not find requested traveler version (" << argv[1]
              << ", " << processVersion << ") in database" << std::endl;
    exit(1);
  }

  // If not found, exit with error

  ProcessNode::setDbConnection(connection);

  // Else call  ProcessNode constructor.
  ProcessNode* topNode = new ProcessNode();

  int status = topNode->readDb(processId);
  if (status != 0) {
    std::cerr << "Failed to read traveler from db" << std::endl;
    exit(1);
  }

  // Now call a routine to write a simple text file
  topNode->printTraveler(true);
}
