/*
 * $Header: /cvs/stx/stx/libdb/nosql/mongoDB/stx/libInit.cc,v 1.3 2013-04-04 22:18:30 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_nosql_mongoDB_stx.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_nosql_mongoDB_stx_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_nosql_mongoDB_stx_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_nosql_mongoDB_stx_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_mongoDB_stx__DFN", _libstx_libdb_nosql_mongoDB_stx_InitDefinition, "stx:libdb/nosql/mongoDB/stx");
_stx_137libdb_137nosql_137mongoDB_137stx_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_nosql_mongoDB_stx_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_mongoDB_stx", _libstx_libdb_nosql_mongoDB_stx_Init, "stx:libdb/nosql/mongoDB/stx");
_GratuitousIncompatibilities_Init(pass,__pRT__,snd);
_stx_137libdb_137nosql_137mongoDB_137stx_Init(pass,__pRT__,snd);

_stx_137libdb_137nosql_137mongoDB_137stx_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
