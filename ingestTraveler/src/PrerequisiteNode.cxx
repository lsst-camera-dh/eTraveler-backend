#include "ProcessNode.h"
#include "PrerequisiteNode.h"
#include <cstdio>
#include <iostream>
#include "Util.h"

std::map<std::string, ColumnDescriptor*> PrerequisiteNode::s_yamlToColumn;
std::vector<ColumnDescriptor> PrerequisiteNode::s_columns;

PrerequisiteNode::PrerequisiteNode(ProcessNode* parent, 
                                   const std::string& user) :
  BaseNode(parent, 0), m_parent(parent), m_processId(""),
  m_processName(""), m_component(""), m_prereqId(""), m_prereqTypeId(""),
  m_version(""), m_userVersionString(false), m_user(user)
{
  if (s_yamlToColumn.size() == 0) PrerequisiteNode::initStatic();

}

PrerequisiteNode::~PrerequisiteNode() {
}

bool PrerequisiteNode::checkInputs() {
  //   PrerequisiteType must be present
  if (m_inputs.find("PrerequisiteType") == m_inputs.end()) {
    std::cerr << "Every Prerequisite must have a PrerequisiteType! " 
              << std::endl;
    return false;
  }

  //   Name must be present
  if (m_inputs.find("Name") == m_inputs.end()) {
    std::cerr << "Every Prerequisite must have a Name! " << std::endl;
    return false;
  }

  if (m_inputs["PrerequisiteType"] != std::string("PROCESS_STEP") ) {
    if ((m_inputs.find("Version") != m_inputs.end()) ||
        (m_inputs.find("UserVersionString") != m_inputs.end() ) ) {
      std::cerr << 
        "Warning: version information only relevant for prerequisites ";
        std::cerr << "of type PROCESS_STEP" << std::endl;
    }
    if (m_inputs["PrerequisiteType"] == std::string("COMPONENT") ) {
      m_component = m_inputs["Name"];
    }
  }  else {      // handle process step prereq
    m_processName = m_inputs["Name"];
    if (m_inputs.find("UserVersionString") != m_inputs.end()) { // use it
      m_userVersionString = true;
    } else if (m_inputs.find("Version") != m_inputs.end()) { // must be int > 0
      std::string v = m_inputs["Version"];
    
      try {
        int i = facilities::Util::stringToInt(v);
        if (i <= 0) {
          std::cerr << "Version must be positive integer" << std::endl;
          return false;
        }  
        // Save it
        m_version = m_inputs["Version"];
      } catch (facilities::WrongType ex)  {
        std::cerr << "Version must be positive integer" << std::endl;
        return false;
      }
    }  else { // defaults to 1
      m_version = "1";
    }
  }
  //    Quantity, if present, must be positive int
  if (m_inputs.find("Quantity") != m_inputs.end()) { // must be int > 0
    std::string q = m_inputs["Quantity"];
    
    try {
      int i = facilities::Util::stringToInt(q);
      if (i <= 0) {
        std::cerr << "Version must be positive integer" << std::endl;
        return false;
      }  
    } catch (facilities::WrongType ex)  {
      std::cerr << "Version must be positive integer" << std::endl;
      return false;
    }
  } 
  return true;
}

void PrerequisiteNode::initStatic() {
  if (s_yamlToColumn.size()  > 0 ) return;

  s_columns.push_back(ColumnDescriptor("prerequisiteTypeId", "", true, false,
                                       "PrerequisiteType", "name"));
  s_yamlToColumn["PrerequisiteType"] = &s_columns.back(); // &s_column[0];

  s_columns.push_back(ColumnDescriptor("description", "", false, false));
  s_yamlToColumn["Description"] = &s_columns.back();  // &s_column[1];
  

  s_columns.push_back(ColumnDescriptor("name", "", true, false));
  s_yamlToColumn["Name"] = &s_columns.back();    //  &s_columns[ ];

  s_columns.push_back(ColumnDescriptor("quantity", "", false, false));
  s_yamlToColumn["Quantity"] = &s_columns.back();

  // One or the other of version, userVersionString   
  s_columns.push_back(ColumnDescriptor("version", "", false, false));
  // ??  s_yamlToColumn["Version"] = &s_columns.back();

  s_columns.push_back(ColumnDescriptor("userVersionString", "", false, false));
  // ?? s_yamlToColumn["UserVersionString"] = &s_columns.back();
  
  s_columns.push_back(ColumnDescriptor("processId", "", false, false));
  s_columns.push_back(ColumnDescriptor("prereqProcessId", "", false, false));
  s_columns.push_back(ColumnDescriptor("hardwareTypeId", "", false, false));

  // Just need these to be recognizable; don't correspond to a column, though
  s_yamlToColumn["Version"] = NULL;
  s_yamlToColumn["UserVersionString"] = NULL;

  s_columns.push_back(ColumnDescriptor("createdBy", "", false, true));
  s_columns.push_back(ColumnDescriptor("creationTS", "", false, true));
}

