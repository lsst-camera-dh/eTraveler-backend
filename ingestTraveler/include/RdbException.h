// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/rdbModel/rdbModel/RdbException.h,v 1.4 2008/01/09 00:50:43 jrb Exp $
#ifndef RDBMODEL_RDBEXCEPTION_H
#define RDBMODEL_RDBEXCEPTION_H
#include <exception>

namespace rdbModel {

  class RdbException : public std::exception {
  public:
    RdbException(const std::string& extraInfo = "", int code=0) : 
      std::exception(),
      m_name("RdbException"), m_extra(extraInfo), m_code(code) {}
    virtual ~RdbException() throw() {}
    virtual std::string getMsg() {
      std::string msg = m_name + ": " + m_extra;
      return msg;}
    virtual int getCode() const { return m_code;}
    virtual const char* what() const throw() {
      return m_extra.c_str();
    }
  protected: 
    std::string m_name;
  private:
    std::string m_extra;
    int         m_code;
  };

}
#endif
