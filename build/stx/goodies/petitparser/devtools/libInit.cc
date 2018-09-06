/*
 * $Header: /cvs/stx/stx/goodies/petitparser/devtools/libInit.cc,v 1.3 2013-01-10 13:26:42 vrany Exp $
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_devtools.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_devtools_Init() INIT_TEXT_SECTION;
// DLL_EXPORT void _libstx_goodies_petitparser_devtools_InitDefinition() INIT_TEXT_SECTION;
#endif

// void _libstx_goodies_petitparser_devtools_InitDefinition(pass, __pRT__, snd)
// OBJ snd; struct __vmData__ *__pRT__; {
// __BEGIN_PACKAGE2__("libstx_goodies_petitparser_devtools__DFN", _libstx_goodies_petitparser_devtools_InitDefinition, "stx:goodies/petitparser/devtools");
// _stx_137goodies_137petitparser_137devtools_Init(pass,__pRT__,snd);

// __END_PACKAGE__();
// }

void _libstx_goodies_petitparser_devtools_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_devtools", _libstx_goodies_petitparser_devtools_Init, "stx:goodies/petitparser/devtools");
_PPDebugger_Init(pass,__pRT__,snd);
_PPDebuggingParser_Init(pass,__pRT__,snd);
_XBGFParser_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_137devtools_Init(pass,__pRT__,snd);

_stx_137goodies_137petitparser_137devtools_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
