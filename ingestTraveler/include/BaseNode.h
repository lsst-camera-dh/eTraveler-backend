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
  //static int getMajorVersion();   // Major db version required for compat
  //static int getMinorVersion();  // db minor version must be >= this
  virtual bool dbIsCompatible(bool test=false); 

protected:
  ProcessNode* m_parent;
  ProcessEdge* m_parentEdge;
  bool         m_isOption;
  static rdbModel::Connection* s_connection; 
  static std::string s_user;

private:
  static int   s_major;
  static int   s_minor;
};

// Used by ProcessNode and PrerequisiteNode
class ColumnDescriptor {
public:
  ColumnDescriptor(std::string name="", std::string dflt="", 
                   bool noDefault=true, bool system=false, 
                   std::string joinTable="", std::string joinColumn="") : 
    m_name(name), m_dflt(dflt), m_noDefault(noDefault), m_system(system),
    m_joinTable(joinTable), m_joinColumn(joinColumn) {}
  ~ColumnDescriptor() {}

  std::string m_name;
  std::string m_dflt;
  bool        m_noDefault;   // user must supply a value
  bool        m_system;      // we figure it out
  std::string m_joinTable;    // non-empty if we need to translate name to id
  std::string m_joinColumn;
};

#endif
