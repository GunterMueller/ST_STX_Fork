/*
 * $Header: /cvs/stx/stx/libdb/nosql/goods/stx/libInit.cc,v 1.6 2013-04-01 17:54:57 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_nosql_goods_stx.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_nosql_goods_stx_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_nosql_goods_stx_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_nosql_goods_stx_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_goods_stx__DFN", _libstx_libdb_nosql_goods_stx_InitDefinition, "stx:libdb/nosql/goods/stx");
_stx_137libdb_137nosql_137goods_137stx_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_nosql_goods_stx_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_goods_stx", _libstx_libdb_nosql_goods_stx_Init, "stx:libdb/nosql/goods/stx");
_KKConnectError_Init(pass,__pRT__,snd);
_KKStxClassMapper_Init(pass,__pRT__,snd);
_KKStxPlatform_Init(pass,__pRT__,snd);
_KKStxTCPSocketTransport_Init(pass,__pRT__,snd);
_stx_137libdb_137nosql_137goods_137stx_Init(pass,__pRT__,snd);

_stx_137libdb_137nosql_137goods_137stx_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
