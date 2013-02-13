#ifndef BaseNode_h
#define BaseNode_h
// Base class for nodes we might encounter in YAML input.  For now there
// are just two:  "regular" process nodes and clones, which must reference
// a previously-parsed node

#include "Connection.h"

namespace YAML {
  class Node;
}

namespace rdbModel {
  class Connection;
}

class ProcessNode;
class ProcessEdge;

class BaseNode  {
public:
  BaseNode(ProcessNode* parent=NULL, int siblingCount=0);
  virtual ~BaseNode();
  virtual int readSerialized(YAML::Node* ynode)=0;
  virtual int writeDb(rdbModel::Connection* connect=NULL)=0;

  static void setDbConnection(rdbModel::Connection* c);
  static void clearDbConnection();

protected:
  ProcessNode* m_parent;
  ProcessEdge* m_parentEdge;
  bool         m_isOption;
  static rdbModel::Connection* s_connection; 
  static std::string s_user;
};

#endif
