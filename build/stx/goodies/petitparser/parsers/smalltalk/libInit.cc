/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_parsers_smalltalk.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_parsers_smalltalk_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_parsers_smalltalk_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_parsers_smalltalk_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_parsers_smalltalk__DFN", _libstx_goodies_petitparser_parsers_smalltalk_InitDefinition, "stx:goodies/petitparser/parsers/smalltalk");
_stx_137goodies_137petitparser_137parsers_137smalltalk_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_parsers_smalltalk_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_parsers_smalltalk", _libstx_goodies_petitparser_parsers_smalltalk_Init, "stx:goodies/petitparser/parsers/smalltalk");
_PPSmalltalkGrammar_Init(pass,__pRT__,snd);
_PPSmalltalkToken_Init(pass,__pRT__,snd);
_PPSmalltalkTokenParser_Init(pass,__pRT__,snd);
_PPSmalltalkWhitespaceParser_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_137parsers_137smalltalk_Init(pass,__pRT__,snd);
_PPSmalltalkParser_Init(pass,__pRT__,snd);

_stx_137goodies_137petitparser_137parsers_137smalltalk_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
