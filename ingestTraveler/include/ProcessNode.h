// Internal representation of Process step as inferred from yaml
// representation.  Knows how to make entries in Process table of db
// to represent process step and its children, grandchildren, etc.
#ifndef ProcessNode_h
#define ProcessNode_h
#include <cstring>
#include <vector>
#include <map>
#include <set>
#include "BaseNode.h"
class ProcessEdge;
class ColumnDescriptor;
class PrerequisiteNode;
class InputNode;

namespace YAML {
  class Node;
}

class ProcessNode : public virtual BaseNode {
public:  
  ProcessNode(ProcessNode* parent=NULL, int stepNumber=0);
  ~ProcessNode();
  int getChildCount() const {return m_children.size();}
  std::string getProcessId() const {return m_processId;}
  void setHardwareId(std::string& hid) {m_hardwareId = hid;}
  std::string getHardwareId() const {return m_hardwareId;}

  // For now - and probably forever - YAML is only supported serialized form
  int virtual readSerialized(YAML::Node* ynode);   

  // E.g. check that referred to hardware types exist, etc.
  int verify(rdbModel::Connection* connect=NULL);

  // Write row in Process table and, if needed ProcessEdge table
  int virtual writeDb(rdbModel::Connection* connect=NULL);

  // If node has a parent, pass in connecting edge id.  In this case,
  // value of id can be "" (since information is in edge)
  virtual int readDb(const std::string& id, const std::string& edgeId="");

  virtual int printTraveler(bool fromDb=true);

  // See if we already have a node with this name
  static ProcessNode* findProcess(std::string& name);
  

private:
  ProcessNode* m_parent;
  int          m_sequenceCount;
  int          m_optionCount;
  std::map<std::string, std::string> m_inputs;  // e.g. from YAML
  std::vector<BaseNode* > m_children;
  std::vector<PrerequisiteNode* > m_prerequisites;
  std::vector<InputNode* > m_inputNodes;
  std::string m_name;
  std::string m_hardwareId;  // set only for top node initially
  std::string m_processId;   // set when we write ourselves to db
  std::string m_version;
  std::string m_userVersionString;
  std::string m_description;
  std::string  m_maxIteration;
  std::string m_substeps;
  bool         m_isOption;
  std::string m_originalId;   // Used when version > 1
  unsigned int m_travelerActionMask;
  ProcessEdge*  m_parentEdge;

  // Handling of Prerequisites and RequiredInputs is identical
  // up to a point.  Return status of processing
  template<class T> int readAuxNodes(std::vector<T*>& auxVector, 
                                     YAML::Node* ynode, 
                                     const std::string& auxName);

  // Map taking yaml key name to corresponding column name in Process table
  static std::map<std::string, ColumnDescriptor*> s_yamlToColumn;
  static std::vector<ColumnDescriptor> s_columns;
  static std::set<std::string> s_relationTypes;
  // Save all process nodes seen so far so that Clone can retrieve match
  static std::map<std::string, ProcessNode*> s_processes;
  // init static structures; in particular, yamlToColumn
  static void initStatic();

  // Verify that input (e.g. yaml file) makes sense, apart from db
  bool checkInputs();

  // Parse TravelerActions
  int parseTravelerActions(YAML::Node* val);
};
#endif
