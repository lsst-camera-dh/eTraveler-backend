#include "ProcessNode.h"
#include "InputNode.h"
#include <cstdio>
#include <iostream>
#include "Util.h"

std::map<std::string, ColumnDescriptor*> InputNode::s_yamlToColumn;
std::vector<ColumnDescriptor> InputNode::s_columns;

InputNode::InputNode(ProcessNode* parent, 
                     const std::string& user) :
  AuxNode(parent, user),
  m_inputSemanticsId(""), m_isInt(false), m_isFloat(false)
{
  if (s_yamlToColumn.size() == 0) InputNode::initStatic();

}

InputNode::~InputNode() {
}

bool InputNode::checkInputs() {
  using facilities::Util;

  //   InputSemantics must be present
  if (m_inputs.find("InputSemantics") == m_inputs.end()) {
    std::cerr << "Every input definition must have InputSemantics field! " 
              << std::endl;
    return false;
  } else {
    std::string semantics = m_inputs["InputSemantics"];
    m_isInt =  (semantics.substr(0, 3) == std::string("int"));
    m_isFloat = (semantics == "float");
  }

  //   Label must be present
  if (m_inputs.find("Label") == m_inputs.end()) {
    std::cerr << "Every input description must have a Label! " << std::endl;
    return false;
  }

  // Units only make sense for int or float.  Required for float
  if (m_inputs.find("Units") == m_inputs.end()) {  // no Units key
    if (m_isFloat) {
      std::cerr << "Float input value must have units! " << std::endl;
      return false;
    }
  }   else  if ((!m_isInt) && (!m_isFloat)) {
    std::cerr << "WARNING: units ignored for non-numeric inputs" 
              << std::endl;
  }

  // MinValue and MaxValue only make sense for int or float
  if (m_inputs.find("MinValue") != m_inputs.end()) {
    if (!checkLimitMatch(m_inputs["MinValue"])) return false;
  }
  if (m_inputs.find("MaxValue") != m_inputs.end()) {
    if (!checkLimitMatch(m_inputs["MaxValue"])) return false;
    else if (m_inputs.find("MinValue") != m_inputs.end() ) { // check min < max
      if  (Util::stringToDouble(m_inputs["MinValue"]) >= 
           Util::stringToDouble(m_inputs["MaxValue"]) )  {
        std::cerr << "Min must be less than Max for input labeled "
                  << m_inputs["Label"] << std::endl;
        return false;
      }
    }
  }
  return true;
}

bool InputNode::checkLimitMatch(const std::string& lim) {
  if (m_isInt) {
    if (!facilities::Util::isInt(lim)) {
      std::cerr << "Limit must match input semantics (int)" << std::endl;
      return false;
    } 
  }  else if (m_isFloat) {
    if (!facilities::Util::isDouble(lim))  {
      std::cerr << "Limit must match input semantics (float)" << std::endl;
      return false;
    }
  } else {
    std::cerr << "WARNING: limit will be ignored for non-numeric input"
              << std::endl;
  }
  return true;
}

void InputNode::initStatic() {
  if (s_yamlToColumn.size()  > 0 ) return;

  s_columns.push_back(ColumnDescriptor("inputSemanticsId", "", true, false,
                                       "InputSemantics", "name"));
  s_yamlToColumn["InputSemantics"] = &s_columns.back(); // &s_column[0];

  s_columns.push_back(ColumnDescriptor("description", "", false, false));
  s_yamlToColumn["Description"] = &s_columns.back();  // &s_column[1];
  

  s_columns.push_back(ColumnDescriptor("label", "", true, false));
  s_yamlToColumn["Label"] = &s_columns.back();    //  &s_columns[ ];

  s_columns.push_back(ColumnDescriptor("units", "", true, false));
  s_yamlToColumn["Units"] = &s_columns.back();

  s_columns.push_back(ColumnDescriptor("minV", "", true, false));
  s_yamlToColumn["MinValue"] = &s_columns.back();

  s_columns.push_back(ColumnDescriptor("maxV", "", true, false));
  s_yamlToColumn["MaxValue"] = &s_columns.back();

  s_columns.push_back(ColumnDescriptor("processId", "", false, false));

  s_columns.push_back(ColumnDescriptor("createdBy", "", false, true));
  s_columns.push_back(ColumnDescriptor("creationTS", "", false, true));
}

bool  InputNode::findColumn(const std::string& col)  {
  return (s_yamlToColumn.find(col) != s_yamlToColumn.end());
}

