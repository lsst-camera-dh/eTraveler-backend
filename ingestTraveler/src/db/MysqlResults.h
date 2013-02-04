// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/rdbModel/rdbModel/Db/MysqlResults.h,v 1.5 2005/07/11 20:22:50 jrb Exp $
#ifndef Mysqlresults_h
#define Mysqlresults_h

#include "ResultHandle.h"

typedef struct st_mysql_res MYSQL_RES;

namespace rdbModel{

  class MysqlConnection;

  /** 
      Concrete implementation of ResultHandle, to accompany MysqlConnection.
  */
  class MysqlResults : virtual public ResultHandle {
    friend class MysqlConnection;

  public:
    virtual ~MysqlResults();

    /// Return number of rows in results
    virtual unsigned int getNRows() const;

    /**  
         Get array of field values for ith row of result set
    */
    virtual bool getRow(std::vector<std::string>& fields, unsigned int i = 0,
                        bool clear = true);

    /**  
         Get array of field values for ith row of result set.  If a field 
         value is NULL, return a zero ptr for that element of the array.

         --> It is the responsibility of the caller to delete the strings
             containing the field values.  See service cleanFieldPtrs
             in base class ResultHandle.
    */
    virtual bool getRowPtrs(std::vector<std::string*>& fieldPtrs, 
                            unsigned int i = 0, bool clear=true);


  private:
    // Only MysqlConnection calls constructor
    MysqlResults(MYSQL_RES* results = 0); 

    MYSQL_RES* m_myres;
  };
}
#endif
