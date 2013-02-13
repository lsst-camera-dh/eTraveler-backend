#include "BaseNode.h"
#include "ProcessEdge.h"
BaseNode::BaseNode(ProcessNode* parent, int siblingCount) : m_parent(parent), m_parentEdge(NULL) {
  if (siblingCount < 0) m_isOption = true;
  if (parent != NULL) {
    BaseNode::m_parentEdge = 
      new ProcessEdge::ProcessEdge(parent, this, siblingCount);
  }
}

BaseNode::~BaseNode() {
  if (m_parentEdge) delete m_parentEdge;
}
