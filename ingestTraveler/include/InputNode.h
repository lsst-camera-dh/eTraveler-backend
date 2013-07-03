// Internal representation of Input pattern.
//  Knows how to make entries in InputPattern
// linked back to correct entry in Process table
#ifndef InputNode_h
#define InputNode_h
#include <cstring>
#include <vector>
#include <map>
#include <set>
#include "AuxNode.h"

class InputNode : public virtual AuxNode {
public:  
  InputNode(ProcessNode* parent, const std::string& user="");
  ~InputNode();

  // E.g. check that referred-to types exist, etc.
  int verify(rdbModel::Connection* connect=NULL);

  // Write row in InputPattern table
  int virtual writeDb(rdbModel::Connection* connect);

private:
  std::string m_inputSemanticsId;

  bool m_isInt;
  bool m_isFloat;

  // init static structures; in particular, yamlToColumn
  // Is InputPattern table complicated enough to warrant this?
  // Map taking yaml key name to corresponding column name in Process table
  static std::map<std::string, ColumnDescriptor*> s_yamlToColumn;
  static std::vector<ColumnDescriptor> s_columns;

  void virtual initStatic();

  // Verify that input (e.g. yaml file) makes sense, apart from db
  bool checkInputs();
  // Check that limit type matches expected value type
  bool checkLimitMatch(const std::string& lim);
  bool virtual findColumn(const std::string& col);
};
#endif
