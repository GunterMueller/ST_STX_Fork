#ifndef XERCESUTIL_H_
#define XERCESUTIL_H_


#ifdef __cplusplus 
# define EXTERN_C extern "C"
#else
# define EXTERN_C 
#endif

#ifdef __cplusplus 
extern "C" {
#endif

# include <stdio.h>
# include <stc.h>
  void __ADD_REFCELL_CPP(OBJ* refcell);
  void __REMOVE_REFCELL_CPP(OBJ* refcell);

  OBJ  __MKEXTERNALADDRESS_CPP(void* data);
  OBJ  __MKSYMBOL_CPP(char* sval);
  OBJ  __MKSTRING_CPP(char* sval);
  OBJ  __MKINT_CPP(int ival);
  OBJ  __BYTEARRAY_UNINITIALIZED_NEW_INT_CPP(int len);


  OBJ  __SSEND1_CPP(OBJ r, OBJ s, int i, OBJ a1);
  OBJ  __SSEND2_CPP(OBJ r, OBJ s, int i, OBJ a1, OBJ a2);

#ifdef __cplusplus 
} // extern "C"
#endif

  

#undef true
#undef false


#endif
