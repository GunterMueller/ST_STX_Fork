/*
 * $Header: /cvs/stx/stx/libdb/libopenDBX/driver/pharo/libInit.cc,v 1.1 2013-04-15 13:15:42 cg Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_libdb_libopenDBX_driver_pharo.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libdb_libopenDBX_driver_pharo_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_libdb_libopenDBX_driver_pharo_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_libdb_libopenDBX_driver_pharo_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_driver_pharo__DFN", _libstx_libdb_libopenDBX_driver_pharo_InitDefinition, "stx:libdb/libopenDBX/driver/pharo");
_stx_137libdb_137libopenDBX_137driver_137pharo_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_libdb_libopenDBX_driver_pharo_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libdb_libopenDBX_driver_pharo", _libstx_libdb_libopenDBX_driver_pharo_Init, "stx:libdb/libopenDBX/driver/pharo");
_OpenDBXDriverPharoDialect_Init(pass,__pRT__,snd);
_PharoOpenDBX_Init(pass,__pRT__,snd);
_stx_137libdb_137libopenDBX_137driver_137pharo_Init(pass,__pRT__,snd);
_OpenDBXUnix_Init(pass,__pRT__,snd);
_OpenDBXWin32_Init(pass,__pRT__,snd);
_OpenDBXMacOSX_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
