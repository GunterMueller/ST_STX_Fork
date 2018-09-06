/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_islands.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_islands_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_islands_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_islands_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_islands__DFN", _libstx_goodies_petitparser_islands_InitDefinition, "stx:goodies/petitparser/islands");
_stx_137goodies_137petitparser_137islands_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_islands_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_islands", _libstx_goodies_petitparser_islands_Init, "stx:goodies/petitparser/islands");
_PPInputEnds_Init(pass,__pRT__,snd);
_PPIsland_Init(pass,__pRT__,snd);
_PPNonEmptyParser_Init(pass,__pRT__,snd);
_PPWater_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_137islands_Init(pass,__pRT__,snd);
_PPMemoizingIsland_Init(pass,__pRT__,snd);

_stx_137goodies_137petitparser_137islands_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
