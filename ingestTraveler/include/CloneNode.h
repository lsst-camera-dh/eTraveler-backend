#ifndef CloneNode_h
#define CloneNode_h

#include <cstring>
#include "BaseNode.h"

class ProcessNode;
class ProcessEdge;

class CloneNode : public virtual BaseNode {
public:
  CloneNode(ProcessNode* parent, std::string& name, int stepNumber);

  virtual ~CloneNode();

  int virtual  readSerialized(YAML::Node* ynode);

  int verify(rdbModel::Connection* connect=NULL) { return 0;}

  int virtual writeDb(rdbModel::Connection* connect=NULL);

  // readDb isn't exactly applicable to CloneNodes.
  int virtual readDb(const std::string& id, 
                     rdbModel::Connection* connect=NULL)  {}
  
private:
  ProcessNode* m_parent;
  ProcessEdge* m_parentEdge;
  std::string  m_name;   // not sure we need this
  ProcessNode* m_model;    // node we're a clone of
  bool         m_isOption;
  std::string  m_condition;
};
#endif
