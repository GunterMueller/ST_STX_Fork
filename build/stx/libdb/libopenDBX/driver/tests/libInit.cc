/*
 * $Header: /cvs/stx/stx/libdb/libopenDBX/driver/tests/libInit.cc,v 1.1 2013-04-15 13:19:22 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libopenDBX_driver_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libopenDBX_driver_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libopenDBX_driver_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libopenDBX_driver_tests_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_driver_tests__DFN", _libstx_libdb_libopenDBX_driver_tests_InitDefinition, "stx:libdb/libopenDBX/driver/tests");
_stx_137libdb_137libopenDBX_137driver_137tests_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libopenDBX_driver_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_driver_tests", _libstx_libdb_libopenDBX_driver_tests_Init, "stx:libdb/libopenDBX/driver/tests");
_DBXBackendFacility_Init(pass,__pRT__,snd);
_DBXTestObject_Init(pass,__pRT__,snd);
_DBXTranscript_Init(pass,__pRT__,snd);
_stx_137libdb_137libopenDBX_137driver_137tests_Init(pass,__pRT__,snd);
_DBXFirebirdFacility_Init(pass,__pRT__,snd);
_DBXMsSQLFacility_Init(pass,__pRT__,snd);
_DBXMySQLFacility_Init(pass,__pRT__,snd);
_DBXOdbcMSSQLFacility_Init(pass,__pRT__,snd);
_DBXOdbcPostgreFacility_Init(pass,__pRT__,snd);
_DBXOracleFacility_Init(pass,__pRT__,snd);
_DBXPostgreFacility_Init(pass,__pRT__,snd);
_DBXSqliteFacility_Init(pass,__pRT__,snd);
_DBXMySQL4Facility_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
