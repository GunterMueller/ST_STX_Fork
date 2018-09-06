/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_analyzer_tests.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_analyzer_tests_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_analyzer_tests_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_analyzer_tests_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_analyzer_tests__DFN", _libstx_goodies_petitparser_analyzer_tests_InitDefinition, "stx:goodies/petitparser/analyzer/tests");
_stx_137goodies_137petitparser_137analyzer_137tests_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_analyzer_tests_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_analyzer_tests", _libstx_goodies_petitparser_analyzer_tests_Init, "stx:goodies/petitparser/analyzer/tests");
_PPAnalyzerTest_Init(pass,__pRT__,snd);
_PPRewriterTest_Init(pass,__pRT__,snd);
_PPSearcherTest_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_137analyzer_137tests_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
