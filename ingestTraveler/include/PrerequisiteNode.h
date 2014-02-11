// Internal representation of Prerequisite pattern.
// representation.  Knows how to make entries in PrerequisitePattern
// linked back to correct entry in Process table
#ifndef PrerequisiteNode_h
#define PrerequisiteNode_h
#include <cstring>
#include <vector>
#include <map>
#include <set>
#include "AuxNode.h"
class ProcessNode;
class ColumnDescriptor;

namespace YAML {
  class Node;
}

class PrerequisiteNode : public virtual AuxNode {
public:  
  PrerequisiteNode(ProcessNode* parent=NULL, const std::string& user="");

  /** Use this constructor when component-type prerequisite has to be
      generated for process having hardware relationship type. */
  PrerequisiteNode(ProcessNode* parent, const std::string& user,
                   const std::string& component, const std::string& componentId,
                   const std::string& prereqTypeId);

  ~PrerequisiteNode();

  // E.g. check that referred to hardware types exist, etc.
  int verify(rdbModel::Connection* connect=NULL);

  // Write row in PrerequisitePattern table
  int virtual writeDb(rdbModel::Connection* connect);

  std::string getComponent() const {return m_component;}
  std::string getPrereqId() const {return m_prereqId;}

private:
  std::string m_processName;  // if prereq is PROCESS_STEP
  std::string m_component;    // if prereq is COMPONENT
  std::string m_name;         // may be identical to one of above

  std::string m_prereqId;    // used for COMPONENT or PROCESS_STEP
  std::string m_prereqTypeId;
  std::string m_version;
  bool        m_userVersionString;

  // init static structures; in particular, yamlToColumn
  // Is PrerequisitePattern table complicated enough to warrant this?
  // Map taking yaml key name to corresponding column name in Process table
  static std::map<std::string, ColumnDescriptor*> s_yamlToColumn;
  static std::vector<ColumnDescriptor> s_columns;

  void virtual initStatic();

  // Verify that input (e.g. yaml file) makes sense, apart from db
  bool checkInputs();
  bool virtual findColumn(const std::string& col);
};
#endif
