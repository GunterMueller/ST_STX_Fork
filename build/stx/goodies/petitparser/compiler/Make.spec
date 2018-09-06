# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_compiler.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=goodies/petitparser/compiler
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3 -inlinenot


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	PEGFsa \
	PEGFsaAbstractDeterminizator \
	PEGFsaFailure \
	PEGFsaInterpret \
	PEGFsaInterpretRecord \
	PEGFsaMinimizator \
	PEGFsaPair \
	PEGFsaState \
	PEGFsaStateInfo \
	PEGFsaTransition \
	PPCASTUtilities \
	PPCBridge \
	PPCClass \
	PPCClassBuilder \
	PPCCodeBlock \
	PPCCodeGen \
	PPCCompilationContext \
	PPCCompilationError \
	PPCCompilationOptions \
	PPCCompilationWarning \
	PPCCompiler \
	PPCContext \
	PPCContextMemento \
	PPCDistinctScanner \
	PPCGuard \
	PPCIdGenerator \
	PPCMethod \
	PPCNode \
	PPCNodeVisitor \
	PPCPass \
	PPCScanner \
	PPCScannerError \
	PPCScannerResultStrategy \
	PPCTokenGuard \
	PPCompiledParser \
	PPMappedActionParser \
	stx_goodies_petitparser_compiler \
	FooScanner \
	PEGFsaCharacterTransition \
	PEGFsaChoiceDeterminizator \
	PEGFsaDeterminizator \
	PEGFsaEpsilonTransition \
	PEGFsaParserState \
	PEGFsaPredicateTransition \
	PEGFsaSequenceDeterminizator \
	PEGFsaUncopiableState \
	PPCAbstractLiteralNode \
	PPCAbstractPredicateNode \
	PPCAnyNode \
	PPCCacheFirstFollowPass \
	PPCCharacterNode \
	PPCDelegateNode \
	PPCDistinctResultStrategy \
	PPCEndOfFileNode \
	PPCFSACodeGen \
	PPCInlinedMethod \
	PPCListNode \
	PPCNilNode \
	PPCNoResultStrategy \
	PPCPassVisitor \
	PPCPluggableNode \
	PPCProfilingContext \
	PPCScannerCodeGenerator \
	PPCTokenizingCodeGen \
	PPCUniversalCodeGen \
	PPCUniversalResultStrategy \
	PPCUnknownNode \
	PPTokenizingCompiledParser \
	PEGFsaEOFTransition \
	PEGFsaGenerator \
	PEGFsaParserTransition \
	PPCAbstractActionNode \
	PPCAndNode \
	PPCCharSetPredicateNode \
	PPCCheckingVisitor \
	PPCChoiceNode \
	PPCCodeGenerator \
	PPCEndOfInputNode \
	PPCFSAVisitor \
	PPCForwardNode \
	PPCInliningVisitor \
	PPCLiteralNode \
	PPCMessagePredicateNode \
	PPCNegateNode \
	PPCNotCharSetPredicateNode \
	PPCNotCharacterNode \
	PPCNotLiteralNode \
	PPCNotMessagePredicateNode \
	PPCNotNode \
	PPCOptionalNode \
	PPCPlusNode \
	PPCPredicateNode \
	PPCRewritingVisitor \
	PPCSentinelNode \
	PPCSequenceNode \
	PPCStarNode \
	PPCTokenCodeGenerator \
	PPCTokenConsumeNode \
	PPCTokenNode \
	PPCTokenWhitespaceNode \
	PPCTokenizingParserNode \
	PPCTrimmingTokenNode \
	PPCActionNode \
	PPCCopyVisitor \
	PPCDeterministicChoiceNode \
	PPCLL1Visitor \
	PPCMergingVisitor \
	PPCOptimizeChoices \
	PPCRecognizerComponentDetector \
	PPCRecognizerComponentVisitor \
	PPCRecognizingSequenceNode \
	PPCSpecializingVisitor \
	PPCStarAnyNode \
	PPCStarCharSetPredicateNode \
	PPCStarMessagePredicateNode \
	PPCSymbolActionNode \
	PPCTokenChoiceNode \
	PPCTokenDetector \
	PPCTokenVisitor \
	PPCTokenizingCodeGenerator \
	PPCTokenizingVisitor \
	PPCTrimNode \
	PPCTrimmingCharacterTokenNode \
	PPCUniversalCodeGenerator \
	PPCMappedActionNode \
	PPCTokenStarMessagePredicateNode \
	PPCTokenStarSeparatorNode \




COMMON_OBJS= \
    $(OUTDIR_SLASH)PEGFsa.$(O) \
    $(OUTDIR_SLASH)PEGFsaAbstractDeterminizator.$(O) \
    $(OUTDIR_SLASH)PEGFsaFailure.$(O) \
    $(OUTDIR_SLASH)PEGFsaInterpret.$(O) \
    $(OUTDIR_SLASH)PEGFsaInterpretRecord.$(O) \
    $(OUTDIR_SLASH)PEGFsaMinimizator.$(O) \
    $(OUTDIR_SLASH)PEGFsaPair.$(O) \
    $(OUTDIR_SLASH)PEGFsaState.$(O) \
    $(OUTDIR_SLASH)PEGFsaStateInfo.$(O) \
    $(OUTDIR_SLASH)PEGFsaTransition.$(O) \
    $(OUTDIR_SLASH)PPCASTUtilities.$(O) \
    $(OUTDIR_SLASH)PPCBridge.$(O) \
    $(OUTDIR_SLASH)PPCClass.$(O) \
    $(OUTDIR_SLASH)PPCClassBuilder.$(O) \
    $(OUTDIR_SLASH)PPCCodeBlock.$(O) \
    $(OUTDIR_SLASH)PPCCodeGen.$(O) \
    $(OUTDIR_SLASH)PPCCompilationContext.$(O) \
    $(OUTDIR_SLASH)PPCCompilationError.$(O) \
    $(OUTDIR_SLASH)PPCCompilationOptions.$(O) \
    $(OUTDIR_SLASH)PPCCompilationWarning.$(O) \
    $(OUTDIR_SLASH)PPCCompiler.$(O) \
    $(OUTDIR_SLASH)PPCContext.$(O) \
    $(OUTDIR_SLASH)PPCContextMemento.$(O) \
    $(OUTDIR_SLASH)PPCDistinctScanner.$(O) \
    $(OUTDIR_SLASH)PPCGuard.$(O) \
    $(OUTDIR_SLASH)PPCIdGenerator.$(O) \
    $(OUTDIR_SLASH)PPCMethod.$(O) \
    $(OUTDIR_SLASH)PPCNode.$(O) \
    $(OUTDIR_SLASH)PPCNodeVisitor.$(O) \
    $(OUTDIR_SLASH)PPCPass.$(O) \
    $(OUTDIR_SLASH)PPCScanner.$(O) \
    $(OUTDIR_SLASH)PPCScannerError.$(O) \
    $(OUTDIR_SLASH)PPCScannerResultStrategy.$(O) \
    $(OUTDIR_SLASH)PPCTokenGuard.$(O) \
    $(OUTDIR_SLASH)PPCompiledParser.$(O) \
    $(OUTDIR_SLASH)PPMappedActionParser.$(O) \
    $(OUTDIR_SLASH)stx_goodies_petitparser_compiler.$(O) \
    $(OUTDIR_SLASH)FooScanner.$(O) \
    $(OUTDIR_SLASH)PEGFsaCharacterTransition.$(O) \
    $(OUTDIR_SLASH)PEGFsaChoiceDeterminizator.$(O) \
    $(OUTDIR_SLASH)PEGFsaDeterminizator.$(O) \
    $(OUTDIR_SLASH)PEGFsaEpsilonTransition.$(O) \
    $(OUTDIR_SLASH)PEGFsaParserState.$(O) \
    $(OUTDIR_SLASH)PEGFsaPredicateTransition.$(O) \
    $(OUTDIR_SLASH)PEGFsaSequenceDeterminizator.$(O) \
    $(OUTDIR_SLASH)PEGFsaUncopiableState.$(O) \
    $(OUTDIR_SLASH)PPCAbstractLiteralNode.$(O) \
    $(OUTDIR_SLASH)PPCAbstractPredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCAnyNode.$(O) \
    $(OUTDIR_SLASH)PPCCacheFirstFollowPass.$(O) \
    $(OUTDIR_SLASH)PPCCharacterNode.$(O) \
    $(OUTDIR_SLASH)PPCDelegateNode.$(O) \
    $(OUTDIR_SLASH)PPCDistinctResultStrategy.$(O) \
    $(OUTDIR_SLASH)PPCEndOfFileNode.$(O) \
    $(OUTDIR_SLASH)PPCFSACodeGen.$(O) \
    $(OUTDIR_SLASH)PPCInlinedMethod.$(O) \
    $(OUTDIR_SLASH)PPCListNode.$(O) \
    $(OUTDIR_SLASH)PPCNilNode.$(O) \
    $(OUTDIR_SLASH)PPCNoResultStrategy.$(O) \
    $(OUTDIR_SLASH)PPCPassVisitor.$(O) \
    $(OUTDIR_SLASH)PPCPluggableNode.$(O) \
    $(OUTDIR_SLASH)PPCProfilingContext.$(O) \
    $(OUTDIR_SLASH)PPCScannerCodeGenerator.$(O) \
    $(OUTDIR_SLASH)PPCTokenizingCodeGen.$(O) \
    $(OUTDIR_SLASH)PPCUniversalCodeGen.$(O) \
    $(OUTDIR_SLASH)PPCUniversalResultStrategy.$(O) \
    $(OUTDIR_SLASH)PPCUnknownNode.$(O) \
    $(OUTDIR_SLASH)PPTokenizingCompiledParser.$(O) \
    $(OUTDIR_SLASH)PEGFsaEOFTransition.$(O) \
    $(OUTDIR_SLASH)PEGFsaGenerator.$(O) \
    $(OUTDIR_SLASH)PEGFsaParserTransition.$(O) \
    $(OUTDIR_SLASH)PPCAbstractActionNode.$(O) \
    $(OUTDIR_SLASH)PPCAndNode.$(O) \
    $(OUTDIR_SLASH)PPCCharSetPredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCCheckingVisitor.$(O) \
    $(OUTDIR_SLASH)PPCChoiceNode.$(O) \
    $(OUTDIR_SLASH)PPCCodeGenerator.$(O) \
    $(OUTDIR_SLASH)PPCEndOfInputNode.$(O) \
    $(OUTDIR_SLASH)PPCFSAVisitor.$(O) \
    $(OUTDIR_SLASH)PPCForwardNode.$(O) \
    $(OUTDIR_SLASH)PPCInliningVisitor.$(O) \
    $(OUTDIR_SLASH)PPCLiteralNode.$(O) \
    $(OUTDIR_SLASH)PPCMessagePredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCNegateNode.$(O) \
    $(OUTDIR_SLASH)PPCNotCharSetPredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCNotCharacterNode.$(O) \
    $(OUTDIR_SLASH)PPCNotLiteralNode.$(O) \
    $(OUTDIR_SLASH)PPCNotMessagePredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCNotNode.$(O) \
    $(OUTDIR_SLASH)PPCOptionalNode.$(O) \
    $(OUTDIR_SLASH)PPCPlusNode.$(O) \
    $(OUTDIR_SLASH)PPCPredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCRewritingVisitor.$(O) \
    $(OUTDIR_SLASH)PPCSentinelNode.$(O) \
    $(OUTDIR_SLASH)PPCSequenceNode.$(O) \
    $(OUTDIR_SLASH)PPCStarNode.$(O) \
    $(OUTDIR_SLASH)PPCTokenCodeGenerator.$(O) \
    $(OUTDIR_SLASH)PPCTokenConsumeNode.$(O) \
    $(OUTDIR_SLASH)PPCTokenNode.$(O) \
    $(OUTDIR_SLASH)PPCTokenWhitespaceNode.$(O) \
    $(OUTDIR_SLASH)PPCTokenizingParserNode.$(O) \
    $(OUTDIR_SLASH)PPCTrimmingTokenNode.$(O) \
    $(OUTDIR_SLASH)PPCActionNode.$(O) \
    $(OUTDIR_SLASH)PPCCopyVisitor.$(O) \
    $(OUTDIR_SLASH)PPCDeterministicChoiceNode.$(O) \
    $(OUTDIR_SLASH)PPCLL1Visitor.$(O) \
    $(OUTDIR_SLASH)PPCMergingVisitor.$(O) \
    $(OUTDIR_SLASH)PPCOptimizeChoices.$(O) \
    $(OUTDIR_SLASH)PPCRecognizerComponentDetector.$(O) \
    $(OUTDIR_SLASH)PPCRecognizerComponentVisitor.$(O) \
    $(OUTDIR_SLASH)PPCRecognizingSequenceNode.$(O) \
    $(OUTDIR_SLASH)PPCSpecializingVisitor.$(O) \
    $(OUTDIR_SLASH)PPCStarAnyNode.$(O) \
    $(OUTDIR_SLASH)PPCStarCharSetPredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCStarMessagePredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCSymbolActionNode.$(O) \
    $(OUTDIR_SLASH)PPCTokenChoiceNode.$(O) \
    $(OUTDIR_SLASH)PPCTokenDetector.$(O) \
    $(OUTDIR_SLASH)PPCTokenVisitor.$(O) \
    $(OUTDIR_SLASH)PPCTokenizingCodeGenerator.$(O) \
    $(OUTDIR_SLASH)PPCTokenizingVisitor.$(O) \
    $(OUTDIR_SLASH)PPCTrimNode.$(O) \
    $(OUTDIR_SLASH)PPCTrimmingCharacterTokenNode.$(O) \
    $(OUTDIR_SLASH)PPCUniversalCodeGenerator.$(O) \
    $(OUTDIR_SLASH)PPCMappedActionNode.$(O) \
    $(OUTDIR_SLASH)PPCTokenStarMessagePredicateNode.$(O) \
    $(OUTDIR_SLASH)PPCTokenStarSeparatorNode.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



