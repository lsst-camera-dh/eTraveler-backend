#include "ProcessNode.h"
#include "ProcessEdge.h"
#include "PrerequisiteNode.h"
#include <cstdio>
#include <iostream>
#include "Util.h"


std::map<std::string, ColumnDescriptor*> ProcessNode::s_yamlToColumn;
std::vector<ColumnDescriptor> ProcessNode::s_columns;
std::set<std::string> ProcessNode::s_relationTypes;
std::string BaseNode::s_user;
std::map<std::string, ProcessNode*> ProcessNode::s_processes;

//  ColumnDescriptor class moved to BaseNode.h

// stepNumber < 0 indicates we're an option, not a child
ProcessNode::ProcessNode(ProcessNode* parent, int stepNumber) :
  BaseNode(), m_parent(parent), m_sequenceCount(0), 
  m_optionCount(0), m_name(""),  m_hardwareId(""), 
  m_hardwareRelationshipTypeId(""), m_processId(""),
  m_version(""), m_userVersionString(""), m_description(""), 
  m_maxIteration(""), m_substeps(""), m_isOption(false), 
  m_originalId(""), m_travelerActionMask(0),
  m_parentEdge(0)
{
  if (s_yamlToColumn.size() == 0) ProcessNode::initStatic();

  if (stepNumber < 0) m_isOption = true;
  // If we have a parent, make edge leading back to it
  if (parent != NULL) {
    m_parentEdge = new ProcessEdge(parent, this, stepNumber);
  }
  m_children.clear();
  m_prerequisites.clear();
}

ProcessNode::~ProcessNode() {
  while (!m_children.empty()) {
    BaseNode* child = m_children[m_children.size() -1];
    m_children.pop_back();
    if (child != NULL) delete child;
  }
  while (!m_prerequisites.empty()) {
    PrerequisiteNode* prereq = m_prerequisites[m_prerequisites.size() -1];
    m_prerequisites.pop_back();
    if (prereq != NULL) delete prereq;
  }
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
    m_version = v;
  }
  //   Name must be present
  if (m_inputs.find("Name") == m_inputs.end()) {
    if (m_inputs.find("Clone") == m_inputs.end()) {
        std::cerr << "Every Process must have a Name or be a Clone! " << std::endl;
        return false;
    }   else  {
      std::cerr << "Found Clone input in ProcessNode::checkInputs -- tilt!" << std::endl;
    }
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

/**
 Initialize 
 s_columns: array of ColumnDescriptor, used to form sql INSERT INTO Process 
 s_yamlToColumn: maps yaml key to corresponding ColumnDescriptor
 */
void ProcessNode::initStatic() {
  if (s_yamlToColumn.size()  > 0 ) return;
  s_relationTypes.clear();

  // ColumnDescriptor(string name, string dflt, bool noDefault=true,
  //    bool system=false, string joinTable="", string joinColumn="")
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

  s_columns.push_back(ColumnDescriptor("userVersionString", "", false, false));
  s_yamlToColumn["UserVersionString"] = &s_columns.back();
  
  s_columns.push_back(ColumnDescriptor("description", "", false, false));
  s_yamlToColumn["Description"] = &s_columns.back();
  
  s_columns.push_back(ColumnDescriptor("instructionsURL", "", false, false));
  s_yamlToColumn["InstructionsURL"] = &s_columns.back();
  s_columns.push_back(ColumnDescriptor("travelerActionMask", "0", 
                                       false, false));
  s_columns.push_back(ColumnDescriptor("substeps", "NONE", false, false));
  s_columns.push_back(ColumnDescriptor("cond", "", false, false));
  s_yamlToColumn["Condition"] = &s_columns.back();

  // originalId should be set to id if version = 1.  Otherwise need to
  // look up id of version 1.  Since auto-increment value is not available
  // until after row has been created, if version is one, originalId
  // must be set in a separate UPDATE command
  s_columns.push_back(ColumnDescriptor("originalId", "", true, true));

  // Just need Clone to be recognizable; doesn't correspond to a column, though
  s_yamlToColumn["Clone"] = NULL;

  s_columns.push_back(ColumnDescriptor("createdBy", "", false, true));
  s_columns.push_back(ColumnDescriptor("creationTS", "", false, true));
  BaseNode::s_user = std::string("$(USER)");
  int nsub = facilities::Util::expandEnvVar(&s_user);
}

static int indentLevel = 0;
static std::string indentString = "  ";

int ProcessNode::printTraveler(bool fromDb) {
  indentLevel += 1;
  std::string indent;
  for (int i=0; i < indentLevel; i++) indent += indentString;
  std::cout << indent << "Process name: " << m_name << std::endl;
  std::cout << indent << "Version: " << m_version << std::endl;
  std::cout << indent << "User version string: " << m_userVersionString 
            << std::endl;
  std::cout << indent << "Hardware id: " << m_hardwareId << std::endl;
  std::cout << indent << "Description: " << m_description << std::endl;
  std::cout << indent << "Max iteration: " << m_maxIteration << std::endl;
  std::cout << indent << "Process id: " << m_processId << std::endl;
  std::cout << indent << "Original id: " << m_originalId << std::endl;
  std::cout << indent << "Traveler action mask : " << std::hex 
            << m_travelerActionMask << std::dec << std::endl;
  if (m_substeps == "NONE") {
    indentLevel -= 1;
    return 0;
  } 
  std::cout << indent << m_substeps << std::endl;
  std::vector<BaseNode* >::iterator it = m_children.begin();
  while (it != m_children.end()) {
    ProcessNode* child = dynamic_cast<ProcessNode* >(*it++);
    if (child == NULL) {
      std::cerr << "Whoops! Dynamic cast failed" << std::endl;
      continue;
    }
    child->printTraveler(fromDb);
    std::cout << std::endl;
  }
  indentLevel-=1;
  return 0;
}
