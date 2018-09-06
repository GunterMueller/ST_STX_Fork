/*
 * $Header: /cvs/stx/stx/libdb/libsqlite/libInit.cc,v 1.11 2014-11-24 14:31:31 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libsqlite.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libsqlite_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libsqlite_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libsqlite_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libsqlite__DFN", _libstx_libdb_libsqlite_InitDefinition, "stx:libdb/libsqlite");
_stx_137libdb_137libsqlite_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libsqlite_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libsqlite", _libstx_libdb_libsqlite_Init, "stx:libdb/libsqlite");
_SQLiteConnection_Init(pass,__pRT__,snd);
_SQLiteCursor_Init(pass,__pRT__,snd);
_SQLiteStatement_Init(pass,__pRT__,snd);
_SqliteError_Init(pass,__pRT__,snd);
_SqliteErrorHolder_Init(pass,__pRT__,snd);
_SqliteReference_Init(pass,__pRT__,snd);
_SqliteResult_Init(pass,__pRT__,snd);
_SqliteResultBuffer_Init(pass,__pRT__,snd);
_SqliteResultCodes_Init(pass,__pRT__,snd);
_stx_137libdb_137libsqlite_Init(pass,__pRT__,snd);
_SQLiteColumnDescription_Init(pass,__pRT__,snd);
_SqliteLibrary_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
