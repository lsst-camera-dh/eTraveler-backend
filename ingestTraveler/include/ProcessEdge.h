// Internal representation of Process edge as inferred from yaml
// representation.  Knows how to make entries in ProcessEdge table of db
// to represent connection between a process node and its parent
// (and where it is in list of children)
#ifndef ProcessEdge_h
#define ProcessEdge_h
#include <cstring>

class ProcessNode;
class BaseNode;
namespace rdbModel {
  class Connection;
}

class ProcessEdge {
public:
  ProcessEdge(ProcessNode* parent, BaseNode* child, int step) :
    m_parent(parent), m_child(child), m_step(step),
    m_condition(""), m_edgeId(""){};
  ~ProcessEdge() {};
  int writeDb(rdbModel::Connection* connection, const std::string& user, 
              std::string& childId, std::string& cond);

private:
  ProcessNode* m_parent;
  BaseNode*    m_child;    // maybe unnecessary
  int          m_step;
  std::string  m_condition;
  std::string  m_edgeId;    // our id, once db row is made
};
#endif
