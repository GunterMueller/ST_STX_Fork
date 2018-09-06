/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_sunit_ext_ui.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_sunit_ext_ui_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_sunit_ext_ui_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_sunit_ext_ui_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_sunit_ext_ui__DFN", _libstx_goodies_sunit_ext_ui_InitDefinition, "stx:goodies/sunit/ext/ui");
_stx_137goodies_137sunit_137ext_137ui_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_sunit_ext_ui_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_sunit_ext_ui", _libstx_goodies_sunit_ext_ui_Init, "stx:goodies/sunit/ext/ui");
_SimpleViewInteractor_Init(pass,__pRT__,snd);
_stx_137goodies_137sunit_137ext_137ui_Init(pass,__pRT__,snd);

_stx_137goodies_137sunit_137ext_137ui_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
