// Intermediate base class, used by PrerequisiteNode and InputNode
// Adds some data structures they both need
#ifndef AuxNode_h
#define AuxNode_h
#include <cstring>
#include <vector>
#include <map>
#include <set>
#include "BaseNode.h"
class ProcessNode;
class ColumnDescriptor;

namespace YAML {
  class Node;
}

class AuxNode : public virtual BaseNode {
public:  
  AuxNode(ProcessNode* parent=NULL, const std::string& user="") : 
    BaseNode(), m_parent(parent), m_processId(""), m_user(user) {};
  ~AuxNode() {};

  // For now - and probably forever - YAML is only supported serialized form
  int virtual readSerialized(YAML::Node* ynode);   

  // No implementation for the first round.
  int virtual readDb(const std::string& id) {} 

protected:
  std::map<std::string, std::string> m_inputs;  // e.g. from YAML
  ProcessNode* m_parent;
  std::string m_processId;   // id of process to which we belong

  std::string m_user;

  void virtual initStatic()=0;
  bool virtual findColumn(const std::string& col)=0;

  // Verify that input (e.g. yaml file) makes sense, apart from db
  bool virtual checkInputs()=0;
};


#endif
