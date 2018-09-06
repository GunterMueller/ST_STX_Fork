/*
 * $Header: /cvs/stx/stx/goodies/libdbase/libInit.cc,v 1.7 2013-04-22 14:29:31 vrany Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_libdbase.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_libdbase_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_libdbase_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_libdbase_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_libdbase__DFN", _libstx_goodies_libdbase_InitDefinition, "stx:goodies/libdbase");
_stx_137goodies_137libdbase_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_libdbase_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_libdbase", _libstx_goodies_libdbase_Init, "stx:goodies/libdbase");
_DBFile_Init(pass,__pRT__,snd);
_PersistencyManager_Init(pass,__pRT__,snd);
_stx_137goodies_137libdbase_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
