// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/rdbModel/rdbModel/Db/ResultHandle.h,v 1.3 2005/07/11 20:22:50 jrb Exp $
#ifndef Resulthandle_h
#define Resulthandle_h
#include <vector>
#include <string>


namespace rdbModel{

  /** 
      Pure virtual class representing results of a query.  Each concrete 
      implementation of Connection will have an associated concrete
      implementation of ResultHandle
  */
  class ResultHandle {
  public:
    ResultHandle() {};
    virtual ~ResultHandle() {};

    /// Return number of rows in results
    virtual unsigned int getNRows() const = 0;

    /**  
         Get array of field values for ith row of result set
    */
    virtual bool getRow(std::vector<std::string>& fields, unsigned int i = 0,
                        bool clear = true) =0;

    
    /**  
         Get array of field values for ith row of result set.  If a field 
         value is NULL, return a zero ptr for that element of the array

         --> It is the responsibility of the caller to delete the strings
             containing the field values.  See service cleanFieldPtrs.
    */
    virtual bool getRowPtrs(std::vector<std::string*>& fields, 
                            unsigned int i = 0, bool clear=true) = 0;

    static void cleanFieldPtrs(std::vector<std::string*>& fields);
  };
}
#endif
