// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/rdbModel/rdbModel/Db/MysqlConnection.h,v 1.28 2008/12/04 20:23:10 jrb Exp $
#ifndef Mysqlconnection_h
#define Mysqlconnection_h

#include "Connection.h"
#include <map>

typedef struct st_mysql MYSQL;
typedef struct st_mysql_res MYSQL_RES;

namespace rdbModel{

  class MysqlResults;
  class Datatype;                  // ??
  /** 
      Class to handle connection to a MySQL database

        - initiate connection
        - make queries, including making returned data from queries available
        - issue SQL statements such as INSERT and UPDATE which have no
          returned data other than status
        - close down connection.

      Initial design will just use host, password, userid passed in.
      Will be up to caller to insure that the userid has the right
      privilages for the operations caller intends to do.
  */
  class MysqlConnection : public virtual Connection {
  public:
    /** Open a connection 
        Allowed operations will depend on userid, etc., specified 
        return true if successful
    */
    MysqlConnection(std::ostream* out=0, std::ostream* errOut=0);
    virtual ~MysqlConnection();

    /**
       Call init explicitly in order to set options.  Otherwise, open
       will take care of it
    */
    virtual bool init();
    virtual bool setOption(DBOPTIONS option, const char* value);

    virtual bool open(const std::string& host, const std::string& userid,
                      const std::string& password,
                      const std::string& dbName);

    /**
       Alternate form of open allows NULL arguments, so that
       values may be taken from my.cnf 
     */
    virtual bool open(const std::string& host, const char* userid,
                      const char* password,
                      const char* dbName);
                      //                      ,unsigned int       port=0);

    virtual bool open(const char* host, int port, const char* userid,
                      const char* password,
                      const char* dbName);


    /** Close the current open connection , if any.  Return true if there
     was a connection to close and it was closed successfully */
    virtual bool close();

    /// Return true iff open has been done with no matching close
    virtual bool isConnected() {return m_connected;}

    std::ostream* getOut() const {return m_out;}
    std::ostream* getErrOut() const {return m_err;}

    unsigned getMaxRetry() const {return m_maxRetry;}
    void setMaxRetry(unsigned maxRetry) { m_maxRetry = maxRetry;}

    unsigned getMaxOpenTry() const {return m_maxOpenTry;}
    void setMaxOpenTry(unsigned maxOpenTry) { m_maxOpenTry = maxOpenTry;}

    /** Get/set avg wait in milliseconds between retries 
     */
    unsigned getAvgWait() const {return m_avgWait;}
    void setAvgWait(unsigned avgWait) { m_avgWait = avgWait;}
    /**
       Check to what degree local schema definition is compatible with
       remote db accessed via this connection.  By default check db names
       match, but this may be disabled.

       If match is successful, may also want to cache information about
       some things; for example, rows for which agent = "service"
    */


    /**
       Format a field string into a new string suited to be sent to
       the DB, escaping any special character if needed.
       THROW an RdbException if the value does not match the
       constraints of the datatype representation on the actual DB
       implementation.
     */
    //virtual std::string formatField(Datatype const* dtype,
    //			    std::string const& value) const;
    // Just deal with escaping; don't try to be too smart
    virtual std::string formatField(std::string const& value) const;


    /** Typical derived class will form a syntactically correct 
        INSERT statement from the input arguments and issue it to
        the dbms. Return true if row was inserted successfully
        If @a auto_value is non-zero and the table has an auto-increment
        column, its value will be returned.
        If @a nullCols is non-zero, insertRow will treat each string
        in the vector as a column name whose value should be set to
        NULL

        Might also want to add a routine for INSERT ... SELECT
    */

    virtual bool insertRow(const std::string& tableName, 
                           const StringVector& colNames, 
                           const StringVector& values,
                           int* auto_value=0,
                           const StringVector* nullCols = 0,
                           unsigned int* u_auto_value=0);


    /**
      Generic UPDATE. Return value is number of rows changed.
      @note: Should not normally be called by application code. See
            instead Rdb::updateRows, which knows about fields which
            should be handled automatically.
    */
    virtual unsigned int update(const std::string& tableName, 
                                const StringVector& colNames, 
                                const StringVector& values,
                                const std::string& where="",
                                const StringVector* nullCols = 0);

    /**
      Support only for relatively simple SELECT, involving just
      one table.  
      @param tableName
      @param getCols   vector of columns to be retrieved
      @param orderCols
      @param flags     See SELECTOPTIONS above for possibilities
      @param where     string containing "where" clause,  Should be
                       empty or elese start with "Where"
      If quoting is necessary in the string, use ' rather than " .

      @return If the SELECT succeeds, a pointer to an object which 
       manages the returned data; else 0.  Caller is responsible for
       deleting the ResultHandle object.
    */
    virtual ResultHandle* select(const std::string& tableName,
                                 const StringVector& getCols,
                                 const StringVector& orderCols,
                                 const std::string& where,
                                 SELECTOPTIONS flags=rdbModel::SELECTnone,
                                 int   rowLimit=0);


    /** 
      Transmit raw request of any form to our other end.  If it is a 
      request that returns results, those results will be stored in a 
      newly-allocated ResultHandle and dbRequest will return a pointer 
      to it. Otherwise dbRequest will return a null pointer.
      Throw an exception if request fails for any reason.
    */
    virtual ResultHandle* dbRequest(const std::string& request);


    // Return true iff last operation was an insert violating
    // uniqueness constraint
    virtual bool duplicateError() const;

    virtual unsigned  getLastError( ) const;

    /**
      Turn select and update into no-ops: output SQL string for
      debugging but don't change db 
    */
    virtual void disableModify(bool disable) {m_writeDisabled=disable;}

  private:

    MYSQL* m_mysql;
    bool   m_connected;

    // cache all connection parameters in case we have to reconnect
    std::string m_host;
    int m_port;
    std::string m_user;
    std::string m_pw;
    std::string m_dbName;
    // Following collection of data members is only of interest while 
    // visit is in progress.

    ///// bool    m_matchDbName;

    /// Keep track of status during matching process
    /////MATCH   m_matchReturn;


    /// Also save list of columns we ("service") are responsible for
    /// Could organize this by table, or just use Column::getTableName()
    ///// std::vector<Column* >  m_ourCols;

    /// For query results while visiting.
    MYSQL_RES* m_tempRes;

    /// Index by colname; data is row number with "SHOW COLUMNS.." result set
    //std::map<std::string, unsigned int> m_colIx;

    //std::string m_primColName;

    bool          m_writeDisabled;

    unsigned      m_maxRetry;
    unsigned      m_avgWait;   // milliseconds
    unsigned      m_maxOpenTry;   // 1 means no retries


    /**
       Retry query up to maxRetry times if it fails.
     */
    int realQueryRetry(const std::string& qstring);


  };

}  // end namespace rdbModel
#endif
