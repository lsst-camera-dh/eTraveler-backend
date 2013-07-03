#include "ProcessNode.h"
#include "ProcessEdge.h"
#include "PrerequisiteNode.h"
#include "InputNode.h"
#include "CloneNode.h"
#include <cstdio>
#include <iostream>
#include "yaml-cpp/yaml.h"

namespace {

  // Every ProcessNode is a map and the keys must all be scalars.
  // getKeys checks that they really are scalars and stores them
  // as strings in the caller-supplied vector.
  int getKeys(YAML::Node* ynode, std::vector<std::string>& keys) {
    for (YAML::const_iterator it=ynode->begin(); it != ynode->end(); ++it) {
      if (! it->first.IsScalar()) {
        std::cerr << "Improper input:  all map keys must be scalars" 
                  << std::endl;
        return 1;
      }
      keys.push_back(it->first.as<std::string>());
    }
    return 0;
  }

  bool findKey(const std::string& thisKey, std::vector<std::string>& keys) {
    for (int i=0; i < keys.size(); i++) {
      if (keys[i] == thisKey) return true;
    }
    return false;
  }
}

template<class T> int ProcessNode::readAuxNodes(std::vector<T*>& auxVector,
                                                YAML::Node* ynode, 
                                                const std::string& auxName) {
  if (!((*ynode)[auxName]).IsSequence()) {
    std::cerr << "ERROR: Value for '" << auxName << "' key must be a sequence" 
              << std::endl;
    return 8;
  }
  for (int i=0; i <  ((*ynode)[auxName]).size(); i++) {
    YAML::Node ychild = ((*ynode)[auxName])[i];
    T* child = new T(this, s_user);
    auxVector.push_back(child);
    int status = auxVector.back()->readSerialized(&ychild);
    if (status != 0) return status;
  }
}

// Transform serialized YAML input into objects of type
// ProcessNode and ProcessEdge
int ProcessNode::readSerialized(YAML::Node* ynode) {
  // A process node is a map with optional 'Sequence', 'Selection',
  // 'Prerequisite' and 'RequiredInputs' keys whose values are lists
  if (! ynode->IsMap())  {
    std::cerr << "YAML input does not describe a process" << std::endl;
    return 1;
  }
  bool hasSequence = false;
  bool hasOptions = false;
  bool hasPrerequisites = false;
  bool hasInputNodes = false;
  std::vector<std::string> keys;
  int status = getKeys(ynode, keys);
  if (status != 0) return status;

  for (int i = 0; i < keys.size(); i++) {
    std::string key = keys[i];
    if ((key != std::string("Sequence")) && 
        (key != std::string("Selection")) &&
        (key != std::string("Prerequisites")) &&
        (key != std::string("RequiredInputs")) ) {
      // read values for all keys except for those introducing children; set instance variables
      YAML::Node val = (*ynode)[key];
      if (val.IsNull()) continue;    // ignore it

      if (!val.IsScalar()) {
        std::cerr << "Bad YAML input. Key " << key 
                  << " must have scalar value " << std::endl;
        return 3;
      }
    
      if (s_yamlToColumn.find(key) == s_yamlToColumn.end()) {
        std::cerr << "Unknown key " << key << std::endl;
        return 4;
      }  else {   // store it.  A little extra work for "Name"
        std::string val=(*ynode)[key].as<std::string>();
        if (key == std::string("Name")) {
          if ((findProcess(val) != NULL))  {
            std::cerr << "Duplicate Process name " << std::endl;
            std::cerr << "Did you mean to clone?" << std::endl;
            return 5;
          } else s_processes[val] = this;
        }
        m_inputs[key.c_str()] = val;
      }

      // Special
    }   else if ( key == std::string("Prerequisites") ) {
        hasPrerequisites = true;
    }   else if ( key == std::string("RequiredInputs") ) {
        hasInputNodes = true;
    }
    else if ((key == std::string("Selection")) && !hasSequence) {
      hasOptions = true;
    }    else if ((key == std::string("Sequence")) && !hasOptions) {
      hasSequence = true;
    }  else  {
      std::cerr << "Process may not have both Sequence and Selection"
                << std::endl;
      return 5;
    }
  }
  if (!checkInputs()) return 6;
  if (hasSequence) {   
    if (!((*ynode)["Sequence"]).IsSequence()) {
      std::cerr << "Improper value for 'Sequence' key" << std::endl;
      return 6;
    }
    for (int i=0; i <  ((*ynode)["Sequence"]).size(); i++) {
      m_sequenceCount++;
      YAML::Node ychild = ((*ynode)["Sequence"])[i];
      // Determine if it's a clone or a regular Process node
      std::vector<std::string> childKeys;
      getKeys(&ychild, childKeys);
      if (findKey(std::string("Clone"), childKeys))  {
        std::string modelName = ychild["Clone"].as<std::string>();
        CloneNode* child = 
          new CloneNode(this, modelName, i);
        m_children.push_back(child);
      }
      else {
        ProcessNode* child = new ProcessNode(this, i);        
        m_children.push_back(child);
      }
      int status = m_children.back()->readSerialized(&ychild);
      if (status != 0) return status;
    }
  }

  if (hasOptions) {   
    if (!((*ynode)["Selection"]).IsSequence()) {
      std::cerr << "Improper value for 'Selection' key" << std::endl;
      return 7;
    }
    for (int i=0; i <  ((*ynode)["Selection"]).size(); i++) {
      m_optionCount++;
      YAML::Node ychild = ((*ynode)["Selection"])[i];
      // Determine if it's a clone or a regular Process node
      std::vector<std::string> childKeys;
      getKeys(&ychild, childKeys);
      if (findKey(std::string("Clone"), childKeys))  {
        std::string modelName = ychild["Clone"].as<std::string>();
        CloneNode* child =
          new CloneNode(this, modelName, -m_optionCount);
        // CloneNode* child = new CloneNode(this, -m_optionCount);
        m_children.push_back(child);
      }
      else {
        ProcessNode* child = new ProcessNode(this, -m_optionCount);        
        m_children.push_back(child);
      }
      ychild = ((*ynode)["Selection"])[i];
      int status = m_children.back()->readSerialized(&ychild);
      if (status != 0) return status;
    }
  }

  if (hasPrerequisites) {
    int status = this->readAuxNodes(m_prerequisites, ynode, "Prerequisites");
    if (status != 0) return status;
  }
  if (hasInputNodes) {
    int status = this->readAuxNodes(m_inputNodes, ynode, "RequiredInputs");
    if (status != 0) return status;
  }
  return 0;
}


ProcessNode* ProcessNode::findProcess(std::string& name) {
  if (s_processes.find(name) != s_processes.end()) return s_processes[name];
  else return NULL;
}

// Clone nodes must have a "Clone" field and may optionally have a
//  "Condition" field; nothing else is allowed.
//  Value for Clone field must match the name of an already-encountered 
// ProcessNode.
int CloneNode::readSerialized(YAML::Node* ynode) {
  if (! ynode->IsMap())  {
    std::cerr << "YAML input does not describe a process" << std::endl;
    return 1;
  }
  for (YAML::const_iterator it=ynode->begin(); it != ynode->end(); ++it) {
    if (! it->first.IsScalar()) {
      std::cerr << "Improper input:  all map keys must be scalars" << std::endl;
      return 2;
    }
    std::string key=it->first.as<std::string>();
    if (key == std::string("Clone")) {
      m_name = it->second.as<std::string>();
    }  else if (key == std::string("Conditiion")) {
      m_condition = it->second.as<std::string>();
    } else {
      std::cerr << "WARNING: Unknown key " << key << " will be ignored" 
                << std::endl;
    }
  }
  m_model = ProcessNode::findProcess(m_name);
  if (m_model == NULL) {
    std::cerr << "No model" << m_name <<  " found for Clone" << std::endl;
    return 4;
  }
  // Must have Condition field if we're an option
  if (m_isOption) {
    if (m_condition == "") {
      std::cerr 
        << "Option (child node of Selection) must have associated condition"  
        << std::endl;
      return 5;
    }
  } else if (m_condition != "") {
    std::cerr << "WARNING:  Condition unused for processes in a Sequence"
              << std::endl;
    m_condition = std::string("");
  }
  return 0;
}


int AuxNode::readSerialized(YAML::Node* ynode) {
  if (! ynode->IsMap())  {
    std::cerr << "YAML input does not describe a process" << std::endl;
    return 1;
  }

  std::vector<std::string> keys;
  int status = getKeys(ynode, keys);
  if (status != 0) return status;

  for (int i = 0; i < keys.size(); i++) {
    std::string key = keys[i];
    YAML::Node val = (*ynode)[key];
    if (!val.IsScalar()) {
      std::cerr << "Bad YAML input. Key " << key 
                << " must have scalar value " << std::endl;
      return 3;
    }
    
    if (!findColumn(key)) {
      std::cerr << "Unknown key " << key << std::endl;
      return 4;
    }  else {  // store it
      m_inputs[key.c_str()] = (*ynode)[key].as<std::string>();
    }
  }
  // checkInputs checks for required fields and so forth
  if (!checkInputs()) return 6;
  else return 0;
}
