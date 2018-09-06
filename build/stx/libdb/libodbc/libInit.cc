/*
 * $Header: /cvs/stx/stx/libdb/libodbc/libInit.cc,v 1.36 2016-03-01 16:19:21 stefan Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libodbc.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libodbc_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libodbc_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libodbc_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libodbc__DFN", _libstx_libdb_libodbc_InitDefinition, "stx:libdb/libodbc");
_stx_137libdb_137libodbc_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libodbc_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libodbc", _libstx_libdb_libodbc_Init, "stx:libdb/libodbc");
_SQL__ODBCColumnDescription_Init(pass,__pRT__,snd);
_SQL__ODBCCursor_Init(pass,__pRT__,snd);
_SQL__ODBCEnvironment_Init(pass,__pRT__,snd);
_SQL__ODBCError_Init(pass,__pRT__,snd);
_SQL__ODBCHandle_Init(pass,__pRT__,snd);
_SQL__ODBCKeyDescription_Init(pass,__pRT__,snd);
_SQL__ODBCSession_Init(pass,__pRT__,snd);
_SQL__ODBCStatement_Init(pass,__pRT__,snd);
_SQL__ODBCTableDescription_Init(pass,__pRT__,snd);
_stx_137libdb_137libodbc_Init(pass,__pRT__,snd);
_SQL__ODBCConnectionError_Init(pass,__pRT__,snd);
_SQL__ODBCSchemaColumnDescription_Init(pass,__pRT__,snd);

_stx_137libdb_137libodbc_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
