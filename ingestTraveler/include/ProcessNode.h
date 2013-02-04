// Internal representation of Process step as inferred from yaml
// representation.  Knows how to make entries in Process table of db
// to represent process step and its children, grandchildren, etc.
#ifndef ProcessNode_h
#define ProcessNode_h
// #include "yaml-cpp/yaml.h"
#include <cstring>
#include <vector>
#include <map>
#include <set>
#include "Connection.h"
class ProcessEdge;
class ColumnDescriptor;

namespace YAML {
  class Node;
}

class ProcessNode {
public:  
  ProcessNode(ProcessNode* parent=NULL, int siblingCount=0);
  ~ProcessNode();
  static void setDbConnection(rdbModel::Connection* c);
  static void clearDbConnection();
  int getChildCount() const {return m_childCount;}
  std::string getProcessId() const {return m_processId;}
  void setHardwareId(std::string& hid) {m_hardwareId = hid;}

  // For now - and probably forever - YAML is only supported serialized form
  int readSerialized(YAML::Node* ynode);   

  // E.g. check that referred to hardware types exist, etc.
  int verify(rdbModel::Connection* connect=NULL);

  // 
  int writeDb(rdbModel::Connection* connect=NULL, bool recurse=true);

private:
  ProcessNode* m_parent;
  int          m_childCount;
  //std::string  m_name;
  //std::string  m_version;
  //std::string  m_description;
  //std::string  m_instructionURL;
  //std::string  m_hardware;   // hardware type of main interest
  //std::string  m_hardwareRelation; // non-null if proc involves, e.g. assembly
  std::map<std::string, std::string> m_inputs;  // e.g. from YAML
  std::vector<ProcessNode* > m_children;
  std::string m_hardwareId;  // set only for top node initially
  std::string m_processId;   // set when we write ourselves to db
  ProcessEdge* m_parentEdge;
  static rdbModel::Connection* s_connection; 

  // Map taking yaml key name to corresponding column name in Process table
  static std::map<std::string, ColumnDescriptor*> s_yamlToColumn;
  static std::vector<ColumnDescriptor> s_columns;
  static std::set<std::string> s_relationTypes;
  static std::string s_user;
  // init static structures; in particular, yamlToColumn
  static void initStatic();

  // Verify that input (e.g. yaml file) makes sense, apart from db
  bool checkInputs();
};


#endif
