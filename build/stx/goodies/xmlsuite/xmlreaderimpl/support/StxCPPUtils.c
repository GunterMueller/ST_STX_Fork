

#include "StxCPPUtils.h"

void __ADD_REFCELL_CPP(OBJ* refcell) {
  __ADD_REFCELL(refcell);
}

void __REMOVE_REFCELL_CPP(OBJ* refcell) {
  __REMOVE_REFCELL(refcell);
}

OBJ __MKEXTERNALADDRESS_CPP(void* data) {
  return __MKEXTERNALADDRESS(data);
}

OBJ  __BYTEARRAY_UNINITIALIZED_NEW_INT_CPP(int len) {
  return __BYTEARRAY_UNINITIALIZED_NEW_INT(len);
}


OBJ  __MKSYMBOL_CPP(char* sval) {
  return __MKSYMBOL(sval, 0);
}

OBJ  __MKSTRING_CPP(char* sval) {
  return __MKSTRING(sval, 0);
}


OBJ  __MKINT_CPP(int ival) {
  return __MKINT(ival);
}

OBJ __SSEND1_CPP(OBJ r, OBJ s, int i, OBJ a1) {
  return __SSEND2(r,s,i,a1);
}


OBJ __SSEND2_CPP(OBJ r, OBJ s, int i, OBJ a1, OBJ a2) {
  return __SSEND2(r,s,i,a1,a2);
}
