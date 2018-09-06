/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_smaCC.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_smaCC_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_smaCC_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_smaCC_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_smaCC__DFN", _libstx_goodies_smaCC_InitDefinition, "stx:goodies/smaCC");
_stx_137goodies_137smaCC_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_smaCC_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_smaCC", _libstx_goodies_smaCC_Init, "stx:goodies/smaCC");
_SmaCC__SmaCCAction_Init(pass,__pRT__,snd);
_SmaCC__SmaCCCompilationNotification_Init(pass,__pRT__,snd);
_SmaCC__SmaCCEdge_Init(pass,__pRT__,snd);
_SmaCC__SmaCCGrammar_Init(pass,__pRT__,snd);
_SmaCC__SmaCCGrammarCompiler_Init(pass,__pRT__,snd);
_SmaCC__SmaCCItemSet_Init(pass,__pRT__,snd);
_SmaCC__SmaCCLR1Item_Init(pass,__pRT__,snd);
_SmaCC__SmaCCLineNumberStream_Init(pass,__pRT__,snd);
_SmaCC__SmaCCNode_Init(pass,__pRT__,snd);
_SmaCC__SmaCCParser_Init(pass,__pRT__,snd);
_SmaCC__SmaCCParserError_Init(pass,__pRT__,snd);
_SmaCC__SmaCCParserGenerator_Init(pass,__pRT__,snd);
_SmaCC__SmaCCRHS_Init(pass,__pRT__,snd);
_SmaCC__SmaCCRegularExpressionNode_Init(pass,__pRT__,snd);
_SmaCC__SmaCCScanner_Init(pass,__pRT__,snd);
_SmaCC__SmaCCScannerCompiler_Init(pass,__pRT__,snd);
_SmaCC__SmaCCSymbol_Init(pass,__pRT__,snd);
_SmaCC__SmaCCSymbolSet_Init(pass,__pRT__,snd);
_SmaCC__SmaCCToken_Init(pass,__pRT__,snd);
_stx_137goodies_137smaCC_Init(pass,__pRT__,snd);
_SmaCC__SmaCCAcceptAction_Init(pass,__pRT__,snd);
_SmaCC__SmaCCAdvancedParser_Init(pass,__pRT__,snd);
_SmaCC__SmaCCAdvancedScanner_Init(pass,__pRT__,snd);
_SmaCC__SmaCCCharacterRENode_Init(pass,__pRT__,snd);
_SmaCC__SmaCCGrammarParser_Init(pass,__pRT__,snd);
_SmaCC__SmaCCGrammarScanner_Init(pass,__pRT__,snd);
_SmaCC__SmaCCNonTerminalSymbol_Init(pass,__pRT__,snd);
_SmaCC__SmaCCOrRENode_Init(pass,__pRT__,snd);
_SmaCC__SmaCCReduceAction_Init(pass,__pRT__,snd);
_SmaCC__SmaCCRejectAction_Init(pass,__pRT__,snd);
_SmaCC__SmaCCRepeatingRENode_Init(pass,__pRT__,snd);
_SmaCC__SmaCCScannerParser_Init(pass,__pRT__,snd);
_SmaCC__SmaCCScannerScanner_Init(pass,__pRT__,snd);
_SmaCC__SmaCCSequenceRENode_Init(pass,__pRT__,snd);
_SmaCC__SmaCCShiftAction_Init(pass,__pRT__,snd);
_SmaCC__SmaCCTerminalSymbol_Init(pass,__pRT__,snd);
_SmaCC__SmaCCStartingSymbol_Init(pass,__pRT__,snd);


__END_PACKAGE__();
}
