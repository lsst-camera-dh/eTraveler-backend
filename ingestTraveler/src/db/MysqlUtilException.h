// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/mootCore/mootCore/DbUtilException.h,v 1.2 2007/10/02 00:08:09 jrb Exp $
#ifndef MysqlUtilException_h
#define MysqlUtilException_h
#include <exception>

namespace rdbModel {

  class MysqlUtilException : public std::exception {
  public:
    MysqlUtilException(const std::string& extraInfo = "", int code=0) : 
      std::exception(),
      m_name("MysqlUtilException"), m_extra(extraInfo), m_code(code) {}
    virtual ~MysqlUtilException() throw() {}
    virtual std::string getMsg() {
      std::string msg = m_name + ": " + m_extra;
      return msg;}
    virtual int getCode() const { return m_code;}
    virtual const char* what() {
      return m_extra.c_str();
    }
  protected: 
    std::string m_name;
  private:
    std::string m_extra;
    int         m_code;
  };

  class MysqlUtilNoDataException : public MysqlUtilException {
  public:
    MysqlUtilNoDataException(const std::string& extraInfo = "", int code=0) : 
      MysqlUtilException(extraInfo, code)  { 
      m_name = std::string("MysqlUtilNoDataException");
    }
    virtual ~MysqlUtilNoDataException() throw()  {}
  };

  class MysqlUtilNotUniqueException : public MysqlUtilException {
  public:
    MysqlUtilNotUniqueException(const std::string& extraInfo = "", int code=0) : 
      MysqlUtilException(extraInfo, code) {
      m_name = std::string("MysqlUtilNotUniqueException");
    }
    virtual ~MysqlUtilNotUniqueException() throw() {}
  };

}
#endif
