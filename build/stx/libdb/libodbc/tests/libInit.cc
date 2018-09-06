/*
 * $Header: /cvs/stx/stx/libdb/libodbc/tests/libInit.cc,v 1.1 2016-09-02 11:37:29 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libodbc_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libodbc_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libodbc_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

extern void _stx_137libdb_137libodbc_137tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd);


void _libstx_libdb_libodbc_tests_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libdb_libodbc_tests__DFN", _libstx_libdb_libodbc_tests_InitDefinition, "stx:libdb/libodbc/tests");
    _stx_137libdb_137libodbc_137tests_Init(pass,__pRT__,snd);

  __END_PACKAGE__();
}

void _libstx_libdb_libodbc_tests_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("libstx_libdb_libodbc_tests", _libstx_libdb_libodbc_tests_Init, "stx:libdb/libodbc/tests");
    _stx_137libdb_137libodbc_137tests_Init(pass,__pRT__,snd);


  __END_PACKAGE__();
}
