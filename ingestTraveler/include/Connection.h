// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/rdbModel/rdbModel/Db/Connection.h,v 1.26 2008/04/21 20:41:45 jrb Exp $
#ifndef Connection_h
#define Connection_h

#include <vector>
#include <string>
#include <ostream>


namespace rdbModel{


  // Add more if they become interesting
  enum DBOPTIONS {
    DBreadDefaultFile,   
    DBreadDefaultGroup
  };

  enum SELECTOPTIONS {
    SELECTnone=0,
    SELECTdesc=1,       /* sort descending, rather than default ascending */
    SELECTforUpdate=2,  /* SELECT .... FOR UPDATE */
    SELECTshareLock=4   /* SELECT ... LOCK IN SHARE MODE */
  };

  class ResultHandle;
  class Datatype;
  class Rdb;
  /** 
      Class to handle connection to an SQL database, or something very like
      it.  It should be able to
        - initiate connection
        - make queries, including making returned data from queries available
        - issue SQL statements such as INSERT and UPDATE which have no
          returned data other than status
        - close down connection.
      Someday it might also have a method to create a database

      Maybe make it pure virtual?  And make a MySQL implementation
      derived from it.  

      Initial design will just use host, password, userid passed in.
      Will be up to caller to insure that the userid has the right
      privilages for the operations caller intends to do.
  */
  typedef std::vector<std::string>  StringVector;

  class Connection {
    /** Open a connection 
        Allowed operations will depend on userid, etc., specified 
        return true if successful
    */
  public:
    Connection(std::ostream* out=0, std::ostream* errOut=0);
    virtual ~Connection() {}

    /**
       Call init explicitly in order to set options.  Otherwise, open
       will take care of it
    */
    virtual bool init() = 0;
    virtual bool setOption(DBOPTIONS option, const char* value) = 0;
    virtual bool open(const std::string& host, const std::string& userid,
                      const std::string& password,
                      const std::string& dbName) = 0;

    virtual bool open(const std::string& host, const char* userid,
                      const char* password,
                      const char* dbName) = 0;

    virtual bool open(const char* host, int port, const char* userid,
                      const char* password,
                      const char* dbName) = 0;

                      //,                      unsigned int       port) = 0;
    /** Close the current open connection , if any.  Return true if there
     was a connection to close and it was closed successfully */
    virtual bool close() = 0;

    /** Parameter is normally path for an xml file descrbing the 
        connection parameters */
    /// virtual bool open(const std::string& parms) = 0;

    /// Return true iff open has been done with no matching close
    virtual bool isConnected() = 0;

    virtual std::ostream* getOut() const = 0;
    virtual std::ostream* getErrOut() const = 0;


    /**
       Format a field string into a new string suited to be sent to
       the DB, escaping any special character if needed.
     */
    virtual std::string formatField(std::string const& value) const =0;


    /** Typical derived class will form a syntactically correct 
        INSERT statement from the input arguments and issue it to
        the dbms. Return true if row was inserted successfully
	
	@note: the values are EXPECTED to be valid, ie already escaped
	correctly and having a valid size. See Table::insertRow() or
	formatField() to do this.

        Might also want to add a routine for INSERT ... SELECT
    */
    virtual bool insertRow(const std::string& tableName, 
                           const StringVector& colNames, 
                           const StringVector& values,
                           int* auto_value=0,
                           const StringVector* nullCols = 0,
                           unsigned int* u_auto_value=0) = 0;



    /**
      Generic UPDATE. Return value is number of rows changed.

      @note: the values are EXPECTED to be valid, ie already escaped
      correctly and having a valid size. See Table::updateRow() or
      formatField() to do this.

      @note: Should not normally be called by application code. See
            instead Rdb::updateRows, which knows about fields which
            should be handled automatically.

    */
    virtual unsigned int update(const std::string& tableName, 
                                const StringVector& colNames, 
                                const StringVector& values,
                                const std::string& where="",
                                const StringVector* nullCols = 0) = 0;

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
                                 SELECTOPTIONS flags = rdbModel::SELECTnone,
                                 int   rowLimit=0)=0;


    /**
      Turn insert and update into no-ops: output SQL string for
      debugging but don't change db 
    */
    virtual void disableModify(bool disable)=0;

    /** 
      Transmit raw request of any form to database.  If it is a request
      that returns results, those results will be stored in a newly-
      allocated ResultHandle and dbRequest will return a pointer to
      it. Otherwise dbRequest will return a null pointer.
      Throw an exception if request fails for any reason.
    */
    virtual ResultHandle* dbRequest(const std::string& request)=0;


    virtual unsigned getLastError( ) const = 0;

    // Return true iff last operation was an insert violating
    // uniqueness constraint
    virtual bool duplicateError() const = 0;

  protected:
    std::ostream* m_out;
    std::ostream* m_err;
  };

}  // end namespace rdbModel
#endif
