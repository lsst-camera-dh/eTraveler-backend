// Internal representation of Process step as inferred from yaml
// representation.  Knows how to make entries in Process table of db
// to represent process step and its children, grandchildren, etc.
#ifndef ProcessNode_h
#define ProcessNode_h
#include <cstring>
#include <vector>
#include <map>
#include <set>
#include "BaseNode.h"
class ProcessEdge;
class ColumnDescriptor;

namespace YAML {
  class Node;
}

class ProcessNode : public virtual BaseNode {
public:  
  ProcessNode(ProcessNode* parent=NULL, int siblingCount=0);
  ~ProcessNode();
  int getChildCount() const {return m_children.size();}
  std::string getProcessId() const {return m_processId;}
  void setHardwareId(std::string& hid) {m_hardwareId = hid;}

  // For now - and probably forever - YAML is only supported serialized form
  int virtual readSerialized(YAML::Node* ynode);   

  // E.g. check that referred to hardware types exist, etc.
  int verify(rdbModel::Connection* connect=NULL);

  // Write row in Process table and, if needed ProcessEdge table
  int virtual writeDb(rdbModel::Connection* connect=NULL);

  // See if we already have a node with this name
  static ProcessNode* findProcess(std::string& name);
  

private:
  ProcessNode* m_parent;
  int          m_sequenceCount;
  int          m_optionCount;
  std::map<std::string, std::string> m_inputs;  // e.g. from YAML
  std::vector<BaseNode* > m_children;
  std::string m_hardwareId;  // set only for top node initially
  std::string m_processId;   // set when we write ourselves to db
  bool         m_isOption;

  // Map taking yaml key name to corresponding column name in Process table
  static std::map<std::string, ColumnDescriptor*> s_yamlToColumn;
  static std::vector<ColumnDescriptor> s_columns;
  static std::set<std::string> s_relationTypes;
  // Save all process nodes seen so far so that Clone can retrieve match
  static std::map<std::string, ProcessNode*> s_processes;
  // init static structures; in particular, yamlToColumn
  static void initStatic();

  // Verify that input (e.g. yaml file) makes sense, apart from db
  bool checkInputs();
};


#endif
