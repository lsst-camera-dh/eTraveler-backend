// $Header: /nfs/slac/g/glast/ground/cvs/GlastRelease-scons/rdbModel/src/Db/ResultHandle.cxx,v 1.2 2005/07/11 23:49:40 jrb Exp $

#include "ResultHandle.h"

namespace rdbModel {

  void ResultHandle::cleanFieldPtrs(std::vector<std::string*>& fields) {
    for (unsigned i = 0; i < fields.size(); i++) {
      if (fields[i] != 0) delete fields[i];
    }
    fields.resize(0);
  }

}
