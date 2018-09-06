/*
 * $Header$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: stx_goodies_petitparser_compiler.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _libstx_goodies_petitparser_compiler_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _libstx_goodies_petitparser_compiler_InitDefinition() INIT_TEXT_SECTION;
#endif

void _libstx_goodies_petitparser_compiler_InitDefinition(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_compiler__DFN", _libstx_goodies_petitparser_compiler_InitDefinition, "stx:goodies/petitparser/compiler");
_stx_137goodies_137petitparser_137compiler_Init(pass,__pRT__,snd);

__END_PACKAGE__();
}

void _libstx_goodies_petitparser_compiler_Init(pass, __pRT__, snd)
OBJ snd; struct __vmData__ *__pRT__; {
__BEGIN_PACKAGE2__("libstx_goodies_petitparser_compiler", _libstx_goodies_petitparser_compiler_Init, "stx:goodies/petitparser/compiler");
_PEGFsa_Init(pass,__pRT__,snd);
_PEGFsaAbstractDeterminizator_Init(pass,__pRT__,snd);
_PEGFsaFailure_Init(pass,__pRT__,snd);
_PEGFsaInterpret_Init(pass,__pRT__,snd);
_PEGFsaInterpretRecord_Init(pass,__pRT__,snd);
_PEGFsaMinimizator_Init(pass,__pRT__,snd);
_PEGFsaPair_Init(pass,__pRT__,snd);
_PEGFsaState_Init(pass,__pRT__,snd);
_PEGFsaStateInfo_Init(pass,__pRT__,snd);
_PEGFsaTransition_Init(pass,__pRT__,snd);
_PPCASTUtilities_Init(pass,__pRT__,snd);
_PPCBridge_Init(pass,__pRT__,snd);
_PPCClass_Init(pass,__pRT__,snd);
_PPCClassBuilder_Init(pass,__pRT__,snd);
_PPCCodeBlock_Init(pass,__pRT__,snd);
_PPCCodeGen_Init(pass,__pRT__,snd);
_PPCCompilationContext_Init(pass,__pRT__,snd);
_PPCCompilationError_Init(pass,__pRT__,snd);
_PPCCompilationOptions_Init(pass,__pRT__,snd);
_PPCCompilationWarning_Init(pass,__pRT__,snd);
_PPCCompiler_Init(pass,__pRT__,snd);
_PPCContext_Init(pass,__pRT__,snd);
_PPCContextMemento_Init(pass,__pRT__,snd);
_PPCDistinctScanner_Init(pass,__pRT__,snd);
_PPCGuard_Init(pass,__pRT__,snd);
_PPCIdGenerator_Init(pass,__pRT__,snd);
_PPCMethod_Init(pass,__pRT__,snd);
_PPCNode_Init(pass,__pRT__,snd);
_PPCNodeVisitor_Init(pass,__pRT__,snd);
_PPCPass_Init(pass,__pRT__,snd);
_PPCScanner_Init(pass,__pRT__,snd);
_PPCScannerError_Init(pass,__pRT__,snd);
_PPCScannerResultStrategy_Init(pass,__pRT__,snd);
_PPCTokenGuard_Init(pass,__pRT__,snd);
_PPCompiledParser_Init(pass,__pRT__,snd);
_PPMappedActionParser_Init(pass,__pRT__,snd);
_stx_137goodies_137petitparser_137compiler_Init(pass,__pRT__,snd);
_FooScanner_Init(pass,__pRT__,snd);
_PEGFsaCharacterTransition_Init(pass,__pRT__,snd);
_PEGFsaChoiceDeterminizator_Init(pass,__pRT__,snd);
_PEGFsaDeterminizator_Init(pass,__pRT__,snd);
_PEGFsaEpsilonTransition_Init(pass,__pRT__,snd);
_PEGFsaParserState_Init(pass,__pRT__,snd);
_PEGFsaPredicateTransition_Init(pass,__pRT__,snd);
_PEGFsaSequenceDeterminizator_Init(pass,__pRT__,snd);
_PEGFsaUncopiableState_Init(pass,__pRT__,snd);
_PPCAbstractLiteralNode_Init(pass,__pRT__,snd);
_PPCAbstractPredicateNode_Init(pass,__pRT__,snd);
_PPCAnyNode_Init(pass,__pRT__,snd);
_PPCCacheFirstFollowPass_Init(pass,__pRT__,snd);
_PPCCharacterNode_Init(pass,__pRT__,snd);
_PPCDelegateNode_Init(pass,__pRT__,snd);
_PPCDistinctResultStrategy_Init(pass,__pRT__,snd);
_PPCEndOfFileNode_Init(pass,__pRT__,snd);
_PPCFSACodeGen_Init(pass,__pRT__,snd);
_PPCInlinedMethod_Init(pass,__pRT__,snd);
_PPCListNode_Init(pass,__pRT__,snd);
_PPCNilNode_Init(pass,__pRT__,snd);
_PPCNoResultStrategy_Init(pass,__pRT__,snd);
_PPCPassVisitor_Init(pass,__pRT__,snd);
_PPCPluggableNode_Init(pass,__pRT__,snd);
_PPCProfilingContext_Init(pass,__pRT__,snd);
_PPCScannerCodeGenerator_Init(pass,__pRT__,snd);
_PPCTokenizingCodeGen_Init(pass,__pRT__,snd);
_PPCUniversalCodeGen_Init(pass,__pRT__,snd);
_PPCUniversalResultStrategy_Init(pass,__pRT__,snd);
_PPCUnknownNode_Init(pass,__pRT__,snd);
_PPTokenizingCompiledParser_Init(pass,__pRT__,snd);
_PEGFsaEOFTransition_Init(pass,__pRT__,snd);
_PEGFsaGenerator_Init(pass,__pRT__,snd);
_PEGFsaParserTransition_Init(pass,__pRT__,snd);
_PPCAbstractActionNode_Init(pass,__pRT__,snd);
_PPCAndNode_Init(pass,__pRT__,snd);
_PPCCharSetPredicateNode_Init(pass,__pRT__,snd);
_PPCCheckingVisitor_Init(pass,__pRT__,snd);
_PPCChoiceNode_Init(pass,__pRT__,snd);
_PPCCodeGenerator_Init(pass,__pRT__,snd);
_PPCEndOfInputNode_Init(pass,__pRT__,snd);
_PPCFSAVisitor_Init(pass,__pRT__,snd);
_PPCForwardNode_Init(pass,__pRT__,snd);
_PPCInliningVisitor_Init(pass,__pRT__,snd);
_PPCLiteralNode_Init(pass,__pRT__,snd);
_PPCMessagePredicateNode_Init(pass,__pRT__,snd);
_PPCNegateNode_Init(pass,__pRT__,snd);
_PPCNotCharSetPredicateNode_Init(pass,__pRT__,snd);
_PPCNotCharacterNode_Init(pass,__pRT__,snd);
_PPCNotLiteralNode_Init(pass,__pRT__,snd);
_PPCNotMessagePredicateNode_Init(pass,__pRT__,snd);
_PPCNotNode_Init(pass,__pRT__,snd);
_PPCOptionalNode_Init(pass,__pRT__,snd);
_PPCPlusNode_Init(pass,__pRT__,snd);
_PPCPredicateNode_Init(pass,__pRT__,snd);
_PPCRewritingVisitor_Init(pass,__pRT__,snd);
_PPCSentinelNode_Init(pass,__pRT__,snd);
_PPCSequenceNode_Init(pass,__pRT__,snd);
_PPCStarNode_Init(pass,__pRT__,snd);
_PPCTokenCodeGenerator_Init(pass,__pRT__,snd);
_PPCTokenConsumeNode_Init(pass,__pRT__,snd);
_PPCTokenNode_Init(pass,__pRT__,snd);
_PPCTokenWhitespaceNode_Init(pass,__pRT__,snd);
_PPCTokenizingParserNode_Init(pass,__pRT__,snd);
_PPCTrimmingTokenNode_Init(pass,__pRT__,snd);
_PPCActionNode_Init(pass,__pRT__,snd);
_PPCCopyVisitor_Init(pass,__pRT__,snd);
_PPCDeterministicChoiceNode_Init(pass,__pRT__,snd);
_PPCLL1Visitor_Init(pass,__pRT__,snd);
_PPCMergingVisitor_Init(pass,__pRT__,snd);
_PPCOptimizeChoices_Init(pass,__pRT__,snd);
_PPCRecognizerComponentDetector_Init(pass,__pRT__,snd);
_PPCRecognizerComponentVisitor_Init(pass,__pRT__,snd);
_PPCRecognizingSequenceNode_Init(pass,__pRT__,snd);
_PPCSpecializingVisitor_Init(pass,__pRT__,snd);
_PPCStarAnyNode_Init(pass,__pRT__,snd);
_PPCStarCharSetPredicateNode_Init(pass,__pRT__,snd);
_PPCStarMessagePredicateNode_Init(pass,__pRT__,snd);
_PPCSymbolActionNode_Init(pass,__pRT__,snd);
_PPCTokenChoiceNode_Init(pass,__pRT__,snd);
_PPCTokenDetector_Init(pass,__pRT__,snd);
_PPCTokenVisitor_Init(pass,__pRT__,snd);
_PPCTokenizingCodeGenerator_Init(pass,__pRT__,snd);
_PPCTokenizingVisitor_Init(pass,__pRT__,snd);
_PPCTrimNode_Init(pass,__pRT__,snd);
_PPCTrimmingCharacterTokenNode_Init(pass,__pRT__,snd);
_PPCUniversalCodeGenerator_Init(pass,__pRT__,snd);
_PPCMappedActionNode_Init(pass,__pRT__,snd);
_PPCTokenStarMessagePredicateNode_Init(pass,__pRT__,snd);
_PPCTokenStarSeparatorNode_Init(pass,__pRT__,snd);

_stx_137goodies_137petitparser_137compiler_extensions_Init(pass,__pRT__,snd);
__END_PACKAGE__();
}
