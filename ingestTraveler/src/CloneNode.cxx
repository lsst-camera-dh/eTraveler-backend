#include "CloneNode.h"
#include "ProcessNode.h"
#include "ProcessEdge.h"

CloneNode::CloneNode(ProcessNode* parent, std::string& name, 
                     int stepNumber=0) : 
  BaseNode(parent, stepNumber), m_parent(parent), m_parentEdge(0),
  m_name(name), m_model(0),  m_condition("") {
  m_isOption = (stepNumber < 0);
  if (parent != NULL) {
    m_parentEdge = new ProcessEdge(parent, this, stepNumber);
  }
}

CloneNode::~CloneNode() {
  if (m_parentEdge) delete m_parentEdge;
}
