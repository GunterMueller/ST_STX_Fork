/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_analyzer.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_analyzer_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_analyzer_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_analyzer_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_analyzer__DFN", _libstx_goodies_petitparser_analyzer_InitDefinition, "stx:goodies/petitparser/analyzer");
_stx_137goodies_137petitparser_137analyzer_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_analyzer_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_analyzer", _libstx_goodies_petitparser_analyzer_Init, "stx:goodies/petitparser/analyzer");
_PPPattern_Init(pass,__pRT__,snd);
_PPProcessor_Init(pass,__pRT__,snd);
_PPRule_Init(pass,__pRT__,snd);
_PPSentinel_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_137analyzer_Init(pass,__pRT__,snd);
_PPListPattern_Init(pass,__pRT__,snd);
_PPReplaceRule_Init(pass,__pRT__,snd);
_PPRewriter_Init(pass,__pRT__,snd);
_PPSearchRule_Init(pass,__pRT__,snd);
_PPSearcher_Init(pass,__pRT__,snd);
_PPBlockReplaceRule_Init(pass,__pRT__,snd);
_PPParserReplaceRule_Init(pass,__pRT__,snd);

_stx_137goodies_137petitparser_137analyzer_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
