#include <cstdio>
#include <iostream>
#include "yaml-cpp/yaml.h"
#include "ProcessNode.h"
#include "db/MysqlConnection.h"
main(int argc, char* argv[])  {
  if (argc < 2) {
    std::cout << "Missing required argument: path to yaml input" << std::endl;

    std::cout << "Call interface example: " << std::endl << std::endl;
    std::cout << "     ingestTraveler myTravelerDefinition.yaml rd_lsst_camt" 
              << std::endl << std::endl;
    std::cout << "second argument (database name) defaults to rd_lsst_cam"
              << std::endl;
    exit(1);
  }
  // Next arg can be used for db name; choose a sensible default
  std::string dbName ="rd_lsst_cam";
  if (argc >= 3) dbName = std::string(argv[2]);
  
  // Let some special value signify local fake db, say "fake"

  YAML::Node yamlRoot = YAML::LoadFile(argv[1]);

  // Alternately could define ProcessNode constructor taking YAML::Node,
  // or even one taking file spec
  ProcessNode* root = new ProcessNode();

  // Convert from YAML nodes to our style.  Includes some verification
  int status = root->readSerialized(&yamlRoot);

  if (status != 0) {
    std::cerr << "Failed to parse yaml input" << std::endl;
    exit(status);
  }
  // Set up db connection  (or fake internal db?).
  // E.g., using form which gets info from .my.cnf
  //rdbModel::Connection* connection;
  if (dbName != "fake") {
    //std::string grp = dbName + "_u";
    std::string grp = dbName + "_ingest";
    rdbModel::MysqlConnection* connection = 
      new rdbModel::MysqlConnection::MysqlConnection();
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
    ProcessNode::setDbConnection(connection);
    if (!root->dbIsCompatible()) {
      connection->close();
      std::cout << "Incompatible db version" << std::endl;
      exit(1);
    }
  }   else {
    std::cout << "Fake database NYI" << std::endl;
    exit(1);
  }

  // (Maybe) Pass connection via ProcessNode::setDbConnection
  // Or it can be argument below

  // More verification now that we have a db we can read
  status = root->verify();

  if (status == 0) status = root->writeDb();

}
