/*
 * $Header: /cvs/stx/stx/libboss/libInit.cc,v 1.31 2009-09-16 15:15:04 cg Exp $
 *
 * DO NOT EDIT 
 * automagically generated from the projectDefinition: stx_libboss.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif 

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_libboss_Init() INIT_TEXT_SECTION;
#endif

void _libstx_libboss_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_libboss", _libstx_libboss_Init, "stx:libboss");
_BinaryIOManager_Init(pass,__pRT__,snd);
_BinaryObjectStorage_Init(pass,__pRT__,snd);
_ObsoleteObject_Init(pass,__pRT__,snd);
_stx_137libboss_Init(pass,__pRT__,snd);
_BinaryInputManager_Init(pass,__pRT__,snd);
_BinaryOutputManager_Init(pass,__pRT__,snd);

_stx_137libboss_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
