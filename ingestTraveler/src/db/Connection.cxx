// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/rdbModel/src/Db/Connection.cxx,v 1.1 2007/01/06 00:43:30 decot Exp $
#ifdef  WIN32
#include <windows.h>
#endif

#include "Connection.h"
//#include "rdbModel/Rdb.h"
//#include "rdbModel/Tables/Table.h"
//#include "rdbModel/Tables/Assertion.h"
//#include "rdbModel/Tables/Column.h"
//#include "rdbModel/Tables/Datatype.h"
#include "MysqlResults.h"
#include "RdbException.h"

#include <iostream>
#include <cerrno>
#include "Util.h"


namespace rdbModel {

  Connection::Connection(std::ostream* out, std::ostream* errOut)
     : m_out(out), m_err(errOut)
  {
    if (m_out == 0) m_out = &std::cout;
    if (m_err == 0) m_err = &std::cerr;
  }
};
