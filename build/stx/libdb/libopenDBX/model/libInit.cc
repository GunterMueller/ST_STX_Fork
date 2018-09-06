/*
 * $Header: /cvs/stx/stx/libdb/libopenDBX/model/libInit.cc,v 1.1 2013-04-15 13:33:16 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libopenDBX_model.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libopenDBX_model_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libopenDBX_model_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libopenDBX_model_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_model__DFN", _libstx_libdb_libopenDBX_model_InitDefinition, "stx:libdb/libopenDBX/model");
_stx_137libdb_137libopenDBX_137model_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libopenDBX_model_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_model", _libstx_libdb_libopenDBX_model_Init, "stx:libdb/libopenDBX/model");
_DBXColumn_Init(pass,__pRT__,snd);
_DBXColumnCluster_Init(pass,__pRT__,snd);
_DBXColumnType_Init(pass,__pRT__,snd);
_DBXForeignKey_Init(pass,__pRT__,snd);
_DBXSchema_Init(pass,__pRT__,snd);
_DBXTable_Init(pass,__pRT__,snd);
_stx_137libdb_137libopenDBX_137model_Init(pass,__pRT__,snd);
_DBXPrimaryKey_Init(pass,__pRT__,snd);
_DBXUnique_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
