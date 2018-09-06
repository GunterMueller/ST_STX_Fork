/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: jv_vdb_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libjv_vdb_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libjv_vdb_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _jv_137vdb_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);



void _libjv_vdb_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libjv_vdb_tests__DFN", _libjv_vdb_tests_InitDefinition, "jv:vdb/tests");
    _jv_137vdb_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libjv_vdb_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libjv_vdb_tests", _libjv_vdb_tests_Init, "jv:vdb/tests");
    _jv_137vdb_137tests_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
