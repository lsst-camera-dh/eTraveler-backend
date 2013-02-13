#ifndef CloneNode_h
#define CloneNode_h

#include "BaseNode.h"

class ProcessNode;
class ProcessEdge;

class CloneNode : public virtual BaseNode {
public:
  CloneNode(ProcessNode* parent, std::string& name, int siblingCount=0) : 
    BaseNode(parent, siblingCount), m_name(name), m_model(0), m_condition("") {
    m_isOption = (siblingCount < 0);
  }
  virtual ~CloneNode() {};

  int virtual  readSerialized(YAML::Node* ynode);

  int verify(rdbModel::Connection* connect=NULL) { return 0;}

  int virtual writeDb(rdbModel::Connection* connect=NULL);
  
private:
  ProcessNode* m_parent;
  std::string  m_name;   // not sure we need this
  ProcessNode* m_model;    // node we're a clone of
  bool         m_isOption;
  std::string  m_condition;
};
#endif
