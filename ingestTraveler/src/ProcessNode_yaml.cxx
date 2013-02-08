#include "ProcessNode.h"
#include "ProcessEdge.h"
#include <cstdio>
#include <iostream>
#include "yaml-cpp/yaml.h"


int ProcessNode::readSerialized(YAML::Node* ynode) {
  // A process node is a map with optional 'child' key whose value is a list
  // check that it is in fact a map
  if (! ynode->IsMap())  {
    std::cerr << "YAML input does not describe a process" << std::endl;
    return 1;
  }
  bool hasSequence = false;
  bool hasOptions = false;
  for (YAML::const_iterator it=ynode->begin(); it != ynode->end(); ++it) {
    if (! it->first.IsScalar()) {
      std::cerr << "Improper input:  all map keys must be scalars" << std::endl;
      return 2;
    }
    std::string key=it->first.as<std::string>();
    if ((key != std::string("Sequence")) && (key != std::string("Selection"))) {
      // read all value keys except for those introducing children; set instance variables

      if (it->second.IsNull()) continue;    // ignore it

      if (!it->second.IsScalar()) {
        std::cerr << "Bad YAML input. Key " << key 
                  << " must have scalar value " << std::endl;
        return 3;
      }
    
      if (s_yamlToColumn.find(key) == s_yamlToColumn.end()) {
        std::cerr << "Unknown key " << key << std::endl;
        return 4;
      }  else {   // store it
        std::string val=it->second.as<std::string>();
        m_inputs[key.c_str()] = val;
      }

      // Special

    }   else if ((key == std::string("Selection") && !hasSequence)) {
      hasOptions = true;
    }    else if ((key == std::string("Sequence") && !hasOptions)) {
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
      ProcessNode* child = new ProcessNode(this, i);
      m_children.push_back(child);
      YAML::Node ychild = ((*ynode)["Sequence"])[i];
      child->readSerialized(&ychild);
    }
  }

  if (hasOptions) {   
    if (!((*ynode)["Selection"]).IsSequence()) {
      std::cerr << "Improper value for 'Selection' key" << std::endl;
      return 7;
    }
    for (int i=0; i <  ((*ynode)["Selection"]).size(); i++) {
      m_optionCount++;
      ProcessNode* option = new ProcessNode(this, -m_optionCount);
      m_children.push_back(option);
      YAML::Node ychild = ((*ynode)["Selection"])[i];
      option->readSerialized(&ychild);
    }
  }

  return 0;
}

