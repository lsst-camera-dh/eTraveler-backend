// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/rdbModel/src/Db/MysqlConnection.cxx,v 1.65 2012/07/06 19:18:27 jrb Exp $
#ifdef  WIN32
#include <windows.h>
#endif

#include "MysqlConnection.h"
//#include "rdbModel/Rdb.h"
//#include "rdbModel/Tables/Table.h"
//#include "rdbModel/Tables/Column.h"
//#include "rdbModel/Tables/Datatype.h"
#include "MysqlResults.h"
#include "RdbException.h"
#include "Util.h"

#include "mysql/mysql.h"
#include "mysql/errmsg.h"
#include "mysql/mysqld_error.h"
#include <iostream>
#include <cerrno>
#include <cstdlib>
#include <cstdio>
#include <ctime>

namespace {

  // Size specification is of form (m) or (m,d)  If no size specification 
  // return 0; else return value of m.  Also handle TEXT and BLOB types.
  int extractSize(const std::string& sqlString) {
    if ((sqlString == "tinytext") || (sqlString == "tinyblob")) return 255;
    if ((sqlString == "text") || (sqlString == "blob")) return (1 << 16) -1 ;
    if ((sqlString == "mediumtext") || (sqlString == "mediumblob"))
      return (1 << 24) -1;
    if ((sqlString == "longtext") || (sqlString == "longblob"))
      return 0x7fffffff;
    //unsigned leftLoc = sqlString.find("(");
    std::string::size_type leftLoc = sqlString.find("(");
    if (leftLoc == std::string::npos) return 0;
    leftLoc++;           // now is at start of m
    //unsigned rightLoc = sqlString.find(",");
    std::string::size_type rightLoc = sqlString.find(",");
    if (rightLoc == std::string::npos) {
      rightLoc = sqlString.find(")");
    }
    std::string numString = 
      sqlString.substr(leftLoc, rightLoc - leftLoc);
    return facilities::Util::stringToInt(numString);
  }

void addArg(bool literal, const std::string arg, std::string& sqlString) {
    if (literal) sqlString += '"';
    sqlString += arg;
    if (literal) sqlString += '"';
    return;
  }

  std::string getMysqlError(MYSQL* my, unsigned* myErrno) {
    if ((*myErrno = mysql_errno(my)) ) {
      const char* errstring = mysql_error(my);
      std::string report("MySQL error code "), code;
      facilities::Util::utoa(*myErrno, code);
      report += code + std::string(": ") + std::string(errstring);
      return report;
    }
    return std::string("");
  }
  unsigned 
  int realQuery(MYSQL* my, std::string const& qstring) {
    unsigned long sz = qstring.size();
    const char* str = qstring.c_str();
    return mysql_real_query(my, str, sz);
  }
  std::string mysqlEscape(MYSQL* my, std::string const& s)
  {
    char * asciiz = new char[s.size()*2+1];
    unsigned sz = (unsigned) 
      mysql_real_escape_string(my, asciiz, s.c_str(), s.size());
    std::string result(asciiz, sz);
    delete [] asciiz;
    return result;
  }
}
    
namespace rdbModel {

  MysqlConnection::MysqlConnection(std::ostream* out,
                                   std::ostream* errOut) :
    Connection(out, errOut),
    m_mysql(0), m_connected(0), m_host(""), m_port(-1),
    m_user(""), m_pw(""), m_dbName(""),
    m_writeDisabled(false), m_maxRetry(2), m_avgWait(10000),
    m_maxOpenTry(3)
  {
    // Seed random number generator with a random thing
    srand(time(0));
  }

  bool MysqlConnection::close() {
    if (m_tempRes) {
      mysql_free_result(m_tempRes);
      m_tempRes = 0;
    }
    mysql_close(m_mysql);
    m_mysql = 0;
    m_connected = false;
    return true;
  }

  MysqlConnection::~MysqlConnection() {
    close();
    delete m_mysql;
    return;
  }

  bool MysqlConnection::open(const std::string& host, 
                             const std::string& user,
                             const std::string& password,
                             const std::string& dbName) {
    return open(host, user.c_str(), password.c_str(), dbName.c_str());
  }


  bool MysqlConnection::init() {
    m_mysql = new MYSQL;
    if (!m_mysql) return false;
    mysql_init(m_mysql);
    return true;
  }
  
  bool MysqlConnection::setOption(DBOPTIONS option, const char* value)
  {
    if (!m_mysql) return false;
    mysql_option myOpt;
    if (option == DBreadDefaultFile) myOpt = MYSQL_READ_DEFAULT_FILE;
    else if (option == DBreadDefaultGroup) myOpt = MYSQL_READ_DEFAULT_GROUP;
    else return false;
    int ret =  mysql_options(m_mysql, myOpt, value);
    return (ret == 0);
  }

  bool MysqlConnection::open(const std::string& host, 
                             const char* user,
                             const char* password,
                             const char* dbName) {
                             //     , unsigned int       port) {
    if (dbName == 0) {
      (*m_err) << 
        "rdbModel::MysqlConnection::open : null db name not allowed!" <<
        std::endl;
      m_err->flush();
      return false;
    } 

    if (!m_mysql) {
      bool ok = init();
      if (!ok) return false;
    }
    // 'host' argument is of the form hostname[:port]
    //  That is, port section is optional.  If not supplied, use
    // default port.
    std::string hostOnly;
    int port = 0;
    //unsigned int colonLoc = host.find(":");
    std::string::size_type colonLoc = host.find(":");
    if (colonLoc == std::string::npos) {
      hostOnly = host;
    }
    else {
      hostOnly = host.substr(0, colonLoc);
      std::string portString = host.substr(colonLoc+1);
      try {
        port = facilities::Util::stringToInt(portString);
      }
      catch (facilities::WrongType ex) {
        (*m_err) << "From MysqlConnection::connect.  Bad port: "
                 << ex.getMsg() << std::endl;
        m_err->flush();
        return false;
      }

    }

    return open(hostOnly.c_str(), port, user, password, dbName);
  }
  
  bool MysqlConnection::open(const char* host, 
                             int         port,
                             const char* user,
                             const char* password,
                             const char* dbName) {
  
    if (!m_mysql) {
      bool ok = init();
      if (!ok) return false;
    }

    unsigned retriesRemaining = m_maxOpenTry;
    
    do {
      retriesRemaining--;
      MYSQL *connected = mysql_real_connect(m_mysql, host,
                                            user,
                                            password, dbName,
                                            port, NULL, 0);

      if (connected != 0) {  // Everything is fine.  Put out an info message
        (*m_out) << "Successfully connected to MySQL host " 
                 << ((host != 0) ? host : "from init file" )
                 << ", database " << dbName << std::endl;
        m_out->flush();
        m_connected = true;
        if (host) m_host = std::string(host);
        else m_host = std::string("");
        m_port = port;
        if (user) m_user = std::string(user);
        else m_user = std::string("");
        if (password) m_pw = std::string(password);
        else m_pw = std::string("");
        m_dbName = dbName;
        return connected;
      }
      else {
        (*m_err) <<  "Failed to connect to MySQL host " << host <<
          "with error " << mysql_error(m_mysql) << std::endl;
        (*m_err) << "Retries remaining: " << retriesRemaining;
        m_err->flush();
        m_connected = false;
        if (retriesRemaining > 0) {
          unsigned maxRnd = 0xfff;
          unsigned wait = m_avgWait;
          if (wait < maxRnd/2) wait += maxRnd/2;

          unsigned rnd = rand() & maxRnd;  // just use last 12 bits
          wait += (rnd - maxRnd/2);
          facilities::Util::gsleep(wait);
        }
      }
    } while (retriesRemaining > 0);
    return m_connected;
  }

  std::string MysqlConnection::formatField(std::string const& value) const
  {
    return mysqlEscape(m_mysql, value);
  }


  bool MysqlConnection::duplicateError() const {
    return (getLastError() == ER_DUP_ENTRY);
  }

  unsigned MysqlConnection::getLastError( ) const {
    unsigned errcode;
    if (m_mysql) {
      
      getMysqlError(m_mysql, &errcode);
    }
    return errcode;
  }

  bool MysqlConnection::insertRow(const std::string& tableName, 
                                  const StringVector& colNames, 
                                  const StringVector& values,
                                  int* auto_value,
                                  const StringVector* nullCols,
                                  unsigned int* u_auto_value) {
    std::string ins;
    if (auto_value) *auto_value = 0;

    // check that sizes of vectors match
    unsigned  nCol = colNames.size();    
    if (!nCol || (nCol != values.size()  ) ) {
      (*m_err) << " MysqlConnection::insertRow: vector lengths incompatible"
                << std::endl;
      m_err->flush();
      return false;
    }

    // caller should already have checked for validity and should
    // have supplied all necessary columns

    ins += "insert into " + tableName;
    ins += " set " + colNames[0] + "='" + values[0] + "' ";
    for (unsigned iCol = 1; iCol < nCol; iCol++) {
      ins += ", " + colNames[iCol] + "='" + values[iCol] + "' ";
    }
    if (nullCols) {
      if (nullCols->size() > 0) {
        unsigned nNull = nullCols->size();
        for (unsigned iNull = 0; iNull < nNull; iNull++) {
          ins += ", " + (*nullCols)[iNull] + "= NULL ";
        }
      }
    }

    (*m_out) << std::endl << "# INSERT string is:" << std::endl;
    (*m_out) << ins << std::endl;
    m_out->flush();

    if (m_writeDisabled) {
      (*m_out) << "write to Db previously disabled; INSERT not sent"
               << std::endl;
      m_out->flush();
      return true;
    }

    // For the time being, no retries for code which writes to db
    int mysqlRet = realQuery(m_mysql, ins);

    if (mysqlRet) {
      unsigned errcode;
      (*m_err) << "MySQL error during INSERT"  << std::endl;
      (*m_err) << getMysqlError(m_mysql, &errcode) << std::endl;
      m_err->flush();
      return false;
    }
    if ((auto_value) || (u_auto_value)) {
      my_ulonglong id = mysql_insert_id(m_mysql);
      if (auto_value) *auto_value = id;
      if (u_auto_value) *u_auto_value = id;
    }
    return true;
  }

  unsigned int MysqlConnection::update(const std::string& tableName, 
                                       const StringVector& colNames, 
                                       const StringVector& values,
                                       const std::string& where,
                                       const StringVector* nullCols) {

    unsigned int nCol = colNames.size();
    if (nCol != values.size()) {
      (*m_err) << "rdbModel::mysqlConnection::update: ";
      (*m_err) << "Incompatible vector arguments " << std::endl;
      m_err->flush();
      throw RdbException(std::string("Incompatible vector arg lens"));
      return 0;
    }
    std::string sqlString = "UPDATE " + tableName + " SET ";
    sqlString += colNames[0] + " = '" + values[0] + "'";
    for (unsigned int iCol = 1; iCol < nCol; iCol++) {
      sqlString += "," + colNames[iCol] + " = '" + values[iCol] + "'";
    }
    if (nullCols) {
      unsigned nNull = nullCols->size();
      for (unsigned iNull = 0; iNull < nNull; iNull++) {
        sqlString += ", " + (*nullCols)[iNull] + "= NULL ";
      }
    }

    sqlString += where;

    (*m_out) << std::endl << "#  UPDATE to be issued:" << std::endl;
    (*m_out) << sqlString << std::endl;
    m_out->flush();
    if (m_writeDisabled) {
      (*m_out) << "write to Db previously disabled; UPDATE not sent"
               << std::endl;
      m_out->flush();
      return 0;
    }
    // No retries for code which modifies db
    int mysqlRet = realQuery(m_mysql, sqlString);

    if (mysqlRet) {
      unsigned errcode;
      (*m_err) << "rdbModel::MysqlConnection::update: ";
      (*m_err) << "MySQL error during UPDATE" << std::endl;
      (*m_err) << getMysqlError(m_mysql, &errcode) << std::endl;
      m_err->flush();
      throw RdbException("MySQL error during UPDATE", errcode);
      return 0;
    }
    my_ulonglong nModLong = mysql_affected_rows(m_mysql);
    // Not much chance that we'll change more rows than will fit in just long
    unsigned nMod = nModLong;
    return nMod;
  }

  ResultHandle* MysqlConnection::select(const std::string& tableName,
                                        const StringVector& getCols,
                                        const StringVector& orderCols,
                                        const std::string& where,
                                        SELECTOPTIONS flags,
                                        int   rowLimit) {
    std::string sqlString = "SELECT ";
    unsigned nGet = getCols.size();
    unsigned nOrder = orderCols.size();

    sqlString += getCols[0];
    for (unsigned iGet = 1; iGet < nGet; iGet++) {
      sqlString += ",";
      sqlString += getCols[iGet];
    }
    sqlString +=  " FROM " + tableName +  " ";
    if (where.size() >  0) {
      sqlString += where + " ";
    }
    if (nOrder > 0 ) {
      sqlString += " ORDER BY " + orderCols[0]; 
      for (unsigned iOrder = 1; iOrder < nOrder; iOrder++) {
        sqlString += ",";
        sqlString += orderCols[iOrder];
      }
      if (flags & SELECTdesc) {
        sqlString += " DESC ";
      }
    }
    if (rowLimit > 0) {
      sqlString += " LIMIT ";
      std::string limitStr;
      limitStr.clear();
      facilities::Util::itoa(rowLimit, limitStr);
      sqlString += limitStr;
    }

    if (flags & SELECTforUpdate) {
      sqlString += " FOR UPDATE ";
    }
    else if (flags & SELECTshareLock) {
      sqlString += " LOCK IN SHARE MODE ";
    }

    (*m_out) << std::endl << "# About to issue SELECT:" << std::endl;
    (*m_out) << sqlString << std::endl;
    m_out->flush();
    
    int mysqlRet;
    if (flags & (SELECTforUpdate | SELECTshareLock)) { // no retry
      mysqlRet = realQuery(m_mysql, sqlString);
    }
    else mysqlRet = realQueryRetry(sqlString);
    if (mysqlRet) {
      unsigned errcode;
      std::string msg = 
        "rdbModel::MysqlConnection::select. ";
      msg += getMysqlError(m_mysql, &errcode);
      (*m_err) << std::endl << msg << std::endl;
      m_err->flush();
      throw RdbException(msg, mysqlRet);
      return 0;
    }

    MYSQL_RES *myres = mysql_store_result(m_mysql);
    MysqlResults* results = new MysqlResults(myres);
    return results;

  }



  ResultHandle* MysqlConnection::dbRequest(const std::string& request) {

    (*m_out) << std::endl << "# About to issue SQL request:" << std::endl;
    (*m_out) << request << std::endl;
    m_out->flush();
    
    // no retries for totally arbitrary request
    int mysqlRet = realQuery(m_mysql, request);
    if (mysqlRet) {
      unsigned errcode;
      std::string msg = 
        "rdbModel::MysqlConnection::dbRequest. ";
      msg += getMysqlError(m_mysql, &errcode);
      (*m_err) << std::endl << msg << std::endl;
      m_err->flush();
      throw RdbException(msg, mysqlRet);
      return 0;
    }

    MYSQL_RES *myres = mysql_store_result(m_mysql);
    if (!myres) {
      // Was it supposed to return data?
      if (mysql_field_count(m_mysql) == 0) { // no data expected
        return 0;
      }
      else {
        std::string msg =
          "rdbModel::MysqlConnection::dbRequest: expected data; none returned";
        (*m_err) << std::endl << msg << std::endl;
        m_err->flush();
        throw RdbException(msg);
        return 0;
      }
    }
    return new MysqlResults(myres);
  }



  /**
     Retry up to retry count if query fails with retriable error
  */
  int MysqlConnection::realQueryRetry(const std::string& qstring) {
    unsigned remain = m_maxRetry;
    int mysqlRet = realQuery(m_mysql, qstring);
    while (remain) {
      --remain;
      switch (mysqlRet) {
        // retriable errors
      case CR_SERVER_GONE_ERROR:
      case CR_SERVER_LOST:
      case CR_UNKNOWN_ERROR: {
        close();        // close old connection
        // calculate sleep time, sleep
        // rand returns a value in the range 0 - MAX_RAND.  The latter
        // is OS-dependent, but must be at least 32767 = 0x7fff
        unsigned maxRnd = 0xfff;
        unsigned wait = m_avgWait;
        if (wait < maxRnd/2) wait += maxRnd/2;

        unsigned rnd = rand() & maxRnd;  // just use last 12 bits
        wait += (rnd - maxRnd/2);
        facilities::Util::gsleep(wait);
        // open new connection, retry
        const char* host =0;
        const char* user = 0;
        const char* pw = 0;
        if (m_host.size()) host = m_host.c_str();
        if (m_user.size()) user = m_user.c_str();
        if (m_pw.size()) pw = m_pw.c_str();
        bool ok = open(host, m_port, user, pw, m_dbName.c_str());
        if (!ok) continue;  // on to next retry

        mysqlRet = realQuery(m_mysql, qstring);
        break;
      }
        // For other errors or success just return
      default:
        return mysqlRet;
      }
    }
    return mysqlRet;

  }

} // end namespace rdbModel
