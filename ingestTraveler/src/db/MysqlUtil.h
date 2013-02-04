// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/mootCore/mootCore/DbUtil.h,v 1.5 2007/11/29 22:17:15 jrb Exp $
// Handles registering a single file into Parameters table.  
// Might also handle other parts of building a config; TBD.
#ifndef MysqlUtil_h
#define MysqlUtil_h

#include <string>

/** @file MysqlUtil.h
    @author J. Bogart
  
    Declare the class MysqlUtil. Includes services for
    common low-level query operations.
    Stolen from GlastRelease mootCore class DbUtil
*/
namespace rdbModel {
  class Connection;
  class ResultHandle;

  class MysqlUtil   {
  public:
    static int checkResults(rdbModel::ResultHandle* res,
                            const std::string& errMsgPrefix, 
                            int expected);

    /// Utility to get a single column value, given table name and key
    /// Optionally declare intent to update
    static std::string getColumnValue(rdbModel::Connection* con, 
                                      const std::string& table, 
                                      const std::string& col,
                                      const std::string& keyCol,
                                      const std::string& key,
                                      bool forUpdate=false);
    /// Utility to get a single column value, given table name and 
    /// valid 'where' clause (should start " WHERE.." )
    /// If 'onlyOne' is true (default), complain if more - or less-
    ///  are found
    /// Else just return first one.
    static std::string getColumnWhere(rdbModel::Connection* con, 
                                      const std::string& table, 
                                      const std::string& col,
                                      const std::string& where, 
                                      bool onlyOne=true,
                                      bool forUpdate=false);

    /// Utility to get a single column value (ascending order) 
    /// from possibly multiple
    /// rows.   Return value is number of rows found, or -1 for error.
    /// This function will append results to vals vector
    static int getAllWhere(rdbModel::Connection* con,
                            const std::string& table,
                            const std::string& col,
                            const std::string& where,
                            std::vector<std::string>& vals,
                            bool atLeastOne = false);

    /**
       return keys (up to value of limit if limit > 0)  for all 
       rows satisfying condition in where.  By default return in descending
       order, so newest is always returned. May specify ascending, 
       however.
       @a keys is not cleared initially; keys are appended 
       @return number of keys satisfying the condition
     */
    static unsigned getKeys(std::vector<unsigned>& keys,
                            rdbModel::Connection* con, const std::string& table,
                            const std::string& keyCol, 
                            const std::string& where, unsigned limit=0,
                            bool ascend=false);
                            

  private:

  };
}

#endif
