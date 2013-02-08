#include "ProcessNode.h"
#include "ProcessEdge.h"
#include <cstdio>
#include <iostream>
#include "Util.h"


std::map<std::string, ColumnDescriptor*> ProcessNode::s_yamlToColumn;
std::vector<ColumnDescriptor> ProcessNode::s_columns;
std::set<std::string> ProcessNode::s_relationTypes;
std::string ProcessNode::s_user;
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

// Special value siblingCount = -1 indicates we're an option, not a child
ProcessNode::ProcessNode(ProcessNode* parent, int siblingCount) :
  m_parent(parent), m_childCount(0), m_optionCount(0), 
  m_hardwareId(""), m_processId(""),
  m_parentEdge(0), m_isOption(false)
{
  if (s_yamlToColumn.size() == 0) ProcessNode::initStatic();

  if (siblingCount < 0) m_isOption = true;
  // If we have a parent, make edge leading back to it
  if (parent != NULL) {
    m_parentEdge = new ProcessEdge(parent, this, siblingCount);
  }
  m_children.clear();
}

ProcessNode::~ProcessNode() {
  //if (m_childCount > 0) {
  while (!m_children.empty()) {
    ProcessNode* child = m_children[m_children.size() -1];
    m_children.pop_back();
    if (child != NULL) delete child;
    //  m_childCount--;
  }
  // }
  //  if (m_optionCount > 0) {
  //    while (!m_options.empty()) {
  //      ProcessNode* option = m_options[m_options.size() -1];
  //      m_options.pop_back();
  //      if (option != NULL) delete option;
  //      m_optionCount--;
  //    }
  //}
  if (m_parentEdge) delete m_parentEdge;
}



bool ProcessNode::checkInputs() {
  //    Version, if present, must be positive int
  if (m_inputs.find("Version") != m_inputs.end()) { // must be int > 0
    std::string v = m_inputs["Version"];
    
    try {
      int i = facilities::Util::stringToInt(v);
      if (i <= 0) {
        std::cerr << "Version must be positive integer" << std::endl;
        return false;
      }  
    } catch (facilities::WrongType ex)  {
        std::cerr << "Version must be positive integer" << std::endl;
        return false;
    }
  }
  //   Name must be present
  if (m_inputs.find("Name") == m_inputs.end()) {
    std::cerr << "Every Process must have a Name! " << std::endl;
    return false;
  }
  // If we're an option, Condition must be present
  if (m_isOption) {
    if (m_inputs.find("Condition") == m_inputs.end()) {
      std::cerr << "Every Process in a Selection must have a Condition! " 
                << std::endl;
      return false;
    }
  }

  if (m_inputs.find("HardwareType") == m_inputs.end()) {
    if (m_parent == 0) {
      std::cerr << "HardwareType required for top-level process" << std::endl;
      return false;
    }
  } else {
    if (m_parent != 0) {
      std::cerr << "WARNING: specification of hardware type for child process will be ignored" << std::endl;
    }
  }
  // Save values for HardwareRelationshipType in a set to check against
  // db at later stage.
  if (m_inputs.find("HardwareRelationshipType") != m_inputs.end()) {
    s_relationTypes.insert(m_inputs["HardwareRelationshipType"]);
  }
  return true;
}


void ProcessNode::initStatic() {
  if (s_yamlToColumn.size()  > 0 ) return;

  s_columns.push_back(ColumnDescriptor("name", "", true, false));
  s_yamlToColumn["Name"] = &s_columns.back();    //  &s_columns[0];

  s_columns.push_back(ColumnDescriptor("hardwareTypeId", "", true, false,
                                       "HardwareType", "name"));
  s_yamlToColumn["HardwareType"] = &s_columns.back(); // &s_column[1];

  s_columns.push_back(ColumnDescriptor("hardwareRelationshipTypeId", "",false,
                                       false, "HardwareRelationshipType",
                                       "name"));
  s_yamlToColumn["HardwareRelationshipType"] = &s_columns.back();//&s_column[2];
  
  s_columns.push_back(ColumnDescriptor("version", "", false, false));
  s_yamlToColumn["Version"] = &s_columns.back();
  
  s_columns.push_back(ColumnDescriptor("description", "", false, false));
  s_yamlToColumn["Description"] = &s_columns.back();
  
  s_columns.push_back(ColumnDescriptor("instructionsURL", "", false, false));
  s_yamlToColumn["InstructionsURL"] = &s_columns.back();
  s_columns.push_back(ColumnDescriptor("navigation", "LEAF", false, false));
  s_columns.push_back(ColumnDescriptor("cond", "", false, false));
  s_yamlToColumn["Condition"] = &s_columns.back();

  s_columns.push_back(ColumnDescriptor("createdBy", "", false, true));
  s_columns.push_back(ColumnDescriptor("creationTS", "", false, true));
  s_user = std::string("$(USER)");
  int nsub = facilities::Util::expandEnvVar(&s_user);

}

