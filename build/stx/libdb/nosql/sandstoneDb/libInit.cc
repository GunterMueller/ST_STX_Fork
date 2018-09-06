/*
 * $Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/libInit.cc,v 1.5 2013-04-17 23:18:47 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_sandstoneDb.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_nosql_sandstoneDb_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_nosql_sandstoneDb_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_nosql_sandstoneDb_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_sandstoneDb__DFN", _libstx_libdb_nosql_sandstoneDb_InitDefinition, "stx:libdb/nosql/sandstoneDb");
_stx_137libdb_137nosql_137sandstoneDb_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_nosql_sandstoneDb_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_sandstoneDb", _libstx_libdb_nosql_sandstoneDb_Init, "stx:libdb/nosql/sandstoneDb");
_SDAbstractStore_Init(pass,__pRT__,snd);
_SDActiveRecord_Init(pass,__pRT__,snd);
_SDCheckPointer_Init(pass,__pRT__,snd);
_SDConcurrentDictionary_Init(pass,__pRT__,snd);
_SDError_Init(pass,__pRT__,snd);
_SDRecordMarker_Init(pass,__pRT__,snd);
_SDSerializer_Init(pass,__pRT__,snd);
_stx_137libdb_137nosql_137sandstoneDb_Init(pass,__pRT__,snd);
_SDBOSSSerializer_Init(pass,__pRT__,snd);
_SDCachedStore_Init(pass,__pRT__,snd);
_SDCommitError_Init(pass,__pRT__,snd);
_SDFuelSerializer_Init(pass,__pRT__,snd);
_SDLoadError_Init(pass,__pRT__,snd);
_SDSmartRefStreamSerializer_Init(pass,__pRT__,snd);
_SDFileStore_Init(pass,__pRT__,snd);
_SDMemoryStore_Init(pass,__pRT__,snd);

_stx_137libdb_137nosql_137sandstoneDb_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
