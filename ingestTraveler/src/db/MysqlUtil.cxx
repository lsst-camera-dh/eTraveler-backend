// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/mootCore/src/DbUtil.cxx,v 1.7 2008/04/28 18:25:33 jrb Exp $

#include <cstdio>
// #include <cstdlib>
#include <iostream>
#include "Util.h"
//#include "rdbModel/Rdb.h"
#include "MysqlConnection.h"
#include "ResultHandle.h"
//#include "rdbModel/Tables/Table.h"
//#include "rdbModel/Tables/Column.h"
//#include "rdbModel/Tables/Assertion.h"
#include "RdbException.h"
#include "MysqlUtil.h"
#include "MysqlUtilException.h"

/*
namespace {
  bool connected(rdbModel::Connection* rdb) {
    if (!rdb) {
      std::cerr << "DbUtil:  need Rdb object" 
                << std::endl;
      std::cerr.flush();
      return false;
    }
    if (!rdb->getConnection()) {
      std::cerr << "DbUtil: need connection to db"
                << std::endl;
      std::cerr.flush();
      return false;
    }
    return true;
  }
}
*/
namespace rdbModel {
  /** 
      Check that SELECT completed ok. If so return # rows. Else return -1
      If 'expected' > 0, check #rows actually returned = expected.
      If 'expected' < 0, check # rows returned >= (-expected)
      If 'expected = 0, don't check.
  */
  int MysqlUtil::checkResults(rdbModel::ResultHandle* res, 
                           const std::string& errMsgPrefix, int expected) {
    if (!res) {
      return -1;
      //      std::cerr << errMsgPrefix << " bad query" << std::endl;
      //      std::cerr.flush();
      //      return 0;
    }
    int got = res->getNRows();
    if (expected > 0 ) {
      if (expected != got) {
        std::cerr << errMsgPrefix << " expected " << expected 
                  << " rows; got " << got << std::endl;
        std::cerr.flush();
      }
    }
    else if (expected < 0) {
      expected = -expected;
      if (got < expected) {
        std::cerr << errMsgPrefix << " expected at least" << expected 
                  << " rows; got " << got << std::endl;
        std::cerr.flush();
      }
    }
    return got;
  }

  std::string MysqlUtil::getColumnValue(rdbModel::Connection* conn,
                                     const std::string& table, 
                                     const std::string& col,
                                     const std::string& keyCol,
                                     const std::string& key,
                                     bool forUpdate) {

    if (conn == NULL) {
      throw rdbModel::RdbException("MysqlUtil::getColumnValue: bad connection");
    }
    std::string where(" WHERE ");
    where += keyCol + std::string("= '") + key + std::string("'");
    return getColumnWhere(conn, table, col, where, true, forUpdate);
  }

  std::string MysqlUtil::getColumnWhere(rdbModel::Connection* conn,
                                     const std::string& table, 
                                     const std::string& col,
                                     const std::string& where, 
                                     bool onlyOne,
                                     bool forUpdate) {

    if (conn == NULL)  {
      throw rdbModel::RdbException("MysqlUtil::getColumnValue: bad connection");
    }

    std::string myWhere(where);
    rdbModel::StringVector getCols;
    getCols.push_back(col);
    rdbModel::StringVector noCols;
    bool useNoCols = false;
    if (forUpdate) {
      myWhere += " FOR UPDATE ";
      useNoCols = true;
    }
    if (myWhere.find("ORDER BY") < myWhere.size()) useNoCols = true;
    rdbModel::ResultHandle* res = 0;
    try {
      if (useNoCols) {// prevent MysqlConnection::select from adding ORDER BY
        res = conn->select(table, getCols, noCols, myWhere);
      } else {
        res = conn->select(table, getCols, getCols, myWhere);
      }
    }
    catch (std::exception ex) {
      std::cerr << "MysqlUtil::getColumnWhere " << ex.what() << std::endl;
      std::cerr.flush();
      if (res) delete res;
      throw ex;
      //      return std::string("");
    }
    int nRows = checkResults(res, "MysqlUtil::getColumnValue ", 0);
    if (nRows == 0) {
      if (!onlyOne) return std::string("");
      else throw MysqlUtilNoDataException("MysqlUtil::getcolumnWhere: no data ");
    }
    else if (nRows < 0) 
    {
      throw MysqlUtilException("MysqlUtil::getColumnWhere:  query failed ");
    }
    if ((nRows > 1) && onlyOne ) {
      std::cerr << "MysqlUtil::getColumnWhere: too many rows satisfy "
                << myWhere << std::endl;
      std::cerr.flush();
      delete res;
      //      return std::string("");
      throw MysqlUtilNotUniqueException("MysqlUtil::getColumnWhere: too many found");
    }
    std::vector<std::string>selFields;

    res->getRow(selFields);
    std::string val = selFields[0];
    delete res;
    return val;
  }

  int MysqlUtil::getAllWhere(rdbModel::Connection* conn,
                          const std::string& table,
                          const std::string& col,
                          const std::string& where,
                          std::vector<std::string>& vals,
                          bool atLeastOne) {
    if (conn == NULL) return -1;

    rdbModel::StringVector getCols;
    getCols.push_back(col);

    rdbModel::ResultHandle* res = 0;
    try {
      res = conn->select(table, getCols, getCols, where);
    }
    catch (std::exception ex) {
      std::cerr << "MsyqlUtil::getAllWhere " << ex.what() << std::endl;
      std::cerr.flush();
      if (res) delete res;
      return -1;
    }

    unsigned nRows = res->getNRows();
    int nFetched = 0;

    for (unsigned ix = 0; ix < nRows; ix++) {
      if (res->getRow(vals, ix, false)) {
        nFetched++;
      }
    }
    delete res;

    if (( res <= 0) && atLeastOne)
      throw MysqlUtilException("MysqlUtil::getColumnValue: no valid match");

    return nFetched;
  }

  unsigned MysqlUtil::getKeys(std::vector<unsigned>& keys,
                           rdbModel::Connection* conn, const std::string& table,
                           const std::string& keyCol, 
                           const std::string& where, unsigned limit,
                           bool ascend) {
    std::vector<std::string> getCols;
    getCols.push_back(keyCol);
    rdbModel::SELECTOPTIONS ordering = (ascend) ? rdbModel::SELECTnone 
      : rdbModel::SELECTdesc;
    rdbModel::ResultHandle* res = 
      conn->select(table, getCols, getCols, where, ordering, limit);

    unsigned nRows = res->getNRows();
    std::vector<std::string> fields;
    for (unsigned iRow = 0; iRow < nRows; iRow++) {
      res->getRow(fields, iRow);
      keys.push_back(facilities::Util::stringToUnsigned(fields[0]));
    }
    delete res;
    return nRows;
  }
}

