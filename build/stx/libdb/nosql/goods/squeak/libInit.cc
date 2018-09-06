/*
 * $Header: /cvs/stx/stx/libdb/nosql/goods/squeak/libInit.cc,v 1.5 2013-03-28 11:32:05 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_l_goodibdb_nosqls_squeak.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_nosql_goods_squeak_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_nosql_goods_squeak_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_nosql_goods_squeak_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_goods_squeak__DFN", _libstx_libdb_nosql_goods_squeak_InitDefinition, "stx:libdb/nosql/goods/squeak");
_stx_137libdb_nosql_137goods_137squeak_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_nosql_goods_squeak_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_nosql_goods_squeak", _libstx_libdb_nosql_goods_squeak_Init, "stx:libdb/nosql/goods/squeak");
_KKPackageExporter_Init(pass,__pRT__,snd);
_KKSqueakClassMapper_Init(pass,__pRT__,snd);
_KKSqueakPlatform_Init(pass,__pRT__,snd);
_KKSqueakTCPSocketTransport_Init(pass,__pRT__,snd);
_stx_137libdb_nosql_137goods_137squeak_Init(pass,__pRT__,snd);

_stx_137libdb_nosql_137goods_137squeak_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
