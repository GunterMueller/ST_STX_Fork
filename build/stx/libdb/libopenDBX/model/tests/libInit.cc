/*
 * $Header: /cvs/stx/stx/libdb/libopenDBX/model/tests/libInit.cc,v 1.1 2013-04-15 13:34:18 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libopenDBX_model_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libopenDBX_model_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libopenDBX_model_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libopenDBX_model_tests_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_model_tests__DFN", _libstx_libdb_libopenDBX_model_tests_InitDefinition, "stx:libdb/libopenDBX/model/tests");
_stx_137libdb_137libopenDBX_137model_137tests_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libopenDBX_model_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_model_tests", _libstx_libdb_libopenDBX_model_tests_Init, "stx:libdb/libopenDBX/model/tests");
_TestDomain_Init(pass,__pRT__,snd);
_stx_137libdb_137libopenDBX_137model_137tests_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
