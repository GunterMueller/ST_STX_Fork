/*
 * $Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/libInit.cc,v 1.2 2013-04-17 23:47:36 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_sandstoneDb_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_nosql_sandstoneDb_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_nosql_sandstoneDb_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_nosql_sandstoneDb_tests_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_sandstoneDb_tests__DFN", _libstx_libdb_nosql_sandstoneDb_tests_InitDefinition, "stx:libdb/nosql/sandstoneDb/tests");
_stx_137libdb_137nosql_137sandstoneDb_137tests_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_nosql_sandstoneDb_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_sandstoneDb_tests", _libstx_libdb_nosql_sandstoneDb_tests_Init, "stx:libdb/nosql/sandstoneDb/tests");
_SDFooObject_Init(pass,__pRT__,snd);
_SDPersonMock_Init(pass,__pRT__,snd);
_stx_137libdb_137nosql_137sandstoneDb_137tests_Init(pass,__pRT__,snd);
_SDManMock_Init(pass,__pRT__,snd);
_SDWomanMock_Init(pass,__pRT__,snd);
_SDChildMock_Init(pass,__pRT__,snd);
_SDGrandChildMock_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
