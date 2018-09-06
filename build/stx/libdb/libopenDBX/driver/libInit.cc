/*
 * $Header: /cvs/stx/stx/libdb/libopenDBX/driver/libInit.cc,v 1.1 2013-04-15 13:12:15 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libopenDBX_driver.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libopenDBX_driver_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libopenDBX_driver_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libopenDBX_driver_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_driver__DFN", _libstx_libdb_libopenDBX_driver_InitDefinition, "stx:libdb/libopenDBX/driver");
_stx_137libdb_137libopenDBX_137driver_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libopenDBX_driver_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_driver", _libstx_libdb_libopenDBX_driver_Init, "stx:libdb/libopenDBX/driver");
_DBXAuthenticationMethod_Init(pass,__pRT__,snd);
_DBXBackend_Init(pass,__pRT__,snd);
_DBXBaseResult_Init(pass,__pRT__,snd);
_DBXColumnDescription_Init(pass,__pRT__,snd);
_DBXConnection_Init(pass,__pRT__,snd);
_DBXConnectionSettings_Init(pass,__pRT__,snd);
_DBXEncodingStrategy_Init(pass,__pRT__,snd);
_DBXEncryptionValues_Init(pass,__pRT__,snd);
_DBXError_Init(pass,__pRT__,snd);
_DBXErrorSeverity_Init(pass,__pRT__,snd);
_DBXLogger_Init(pass,__pRT__,snd);
_DBXNotification_Init(pass,__pRT__,snd);
_DBXQuerySettings_Init(pass,__pRT__,snd);
_DBXQueryTimeout_Init(pass,__pRT__,snd);
_DBXResultDescription_Init(pass,__pRT__,snd);
_DBXResultSetDescription_Init(pass,__pRT__,snd);
_DBXRow_Init(pass,__pRT__,snd);
_DBXSpecialOptions_Init(pass,__pRT__,snd);
_DBXTimeSpec_Init(pass,__pRT__,snd);
_DBXTypeNotSupported_Init(pass,__pRT__,snd);
_OpenDBX_Init(pass,__pRT__,snd);
_OpenDBXDriverSmalltalkDialect_Init(pass,__pRT__,snd);
_TextConverter_Init(pass,__pRT__,snd);
_stx_137libdb_137libopenDBX_137driver_Init(pass,__pRT__,snd);
_DBXAutomaticEncoding_Init(pass,__pRT__,snd);
_DBXFirebirdBackend_Init(pass,__pRT__,snd);
_DBXMSSQLBackend_Init(pass,__pRT__,snd);
_DBXMultiStatementResultSetIterator_Init(pass,__pRT__,snd);
_DBXMySQLBackend_Init(pass,__pRT__,snd);
_DBXNoEncoding_Init(pass,__pRT__,snd);
_DBXNullTextConverter_Init(pass,__pRT__,snd);
_DBXOdbcBackend_Init(pass,__pRT__,snd);
_DBXOracleBackend_Init(pass,__pRT__,snd);
_DBXPostgresBackend_Init(pass,__pRT__,snd);
_DBXResult_Init(pass,__pRT__,snd);
_DBXResultSet_Init(pass,__pRT__,snd);
_DBXSqliteBackend_Init(pass,__pRT__,snd);
_DBXStaticEncoding_Init(pass,__pRT__,snd);
_OpenDBXDriverError_Init(pass,__pRT__,snd);
_OpenDBXError_Init(pass,__pRT__,snd);
_DBXFatalError_Init(pass,__pRT__,snd);
_DBXMySQL4Backend_Init(pass,__pRT__,snd);
_DBXRecoverableError_Init(pass,__pRT__,snd);

_stx_137libdb_137libopenDBX_137driver_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
