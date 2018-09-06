/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_compiler_tests_extras.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_compiler_tests_extras_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_compiler_tests_extras_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_compiler_tests_extras_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_compiler_tests_extras__DFN", _libstx_goodies_petitparser_compiler_tests_extras_InitDefinition, "stx:goodies/petitparser/compiler/tests/extras");
_stx_137goodies_137petitparser_137compiler_137tests_137extras_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_compiler_tests_extras_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_compiler_tests_extras", _libstx_goodies_petitparser_compiler_tests_extras_Init, "stx:goodies/petitparser/compiler/tests/extras");
_PPCLRPNode_Init(pass,__pRT__,snd);
_PPCLRPParser_Init(pass,__pRT__,snd);
_PPCLRPParserSmokeTest_Init(pass,__pRT__,snd);
_PPCLRPSourcesResource_Init(pass,__pRT__,snd);
_PPCLRPAction_Init(pass,__pRT__,snd);
_PPCLRPCompiledParserSmokeTest_Init(pass,__pRT__,snd);
_PPCLRPContainedElement_Init(pass,__pRT__,snd);
_PPCLRPSpawn_Init(pass,__pRT__,snd);
_PPCLRPComment_Init(pass,__pRT__,snd);
_PPCLRPCompiledParserSmokeTest_137Universal_Init(pass,__pRT__,snd);
_PPCLRPErrorNode_Init(pass,__pRT__,snd);
_PPCLRPEvent_Init(pass,__pRT__,snd);
_PPCLRPMachine_Init(pass,__pRT__,snd);
_PPCLRPOnEntry_Init(pass,__pRT__,snd);
_PPCLRPOnExit_Init(pass,__pRT__,snd);
_PPCLRPRunning_Init(pass,__pRT__,snd);
_PPCLRPState_Init(pass,__pRT__,snd);
_PPCLRPTransition_Init(pass,__pRT__,snd);
_PPCLRPVariable_Init(pass,__pRT__,snd);
_PPCLRPEpsilonTransition_Init(pass,__pRT__,snd);
_PPCLRPTimeoutTransition_Init(pass,__pRT__,snd);
_PPCLRPWildcardTransition_Init(pass,__pRT__,snd);

_stx_137goodies_137petitparser_137compiler_137tests_137extras_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
