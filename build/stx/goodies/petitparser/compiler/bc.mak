# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_compiler.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_petitparser_compiler
MODULE_PATH=goodies\petitparser\compiler
RESFILES=compiler.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\petitparser -I$(INCLUDE_TOP)\stx\goodies\petitparser\analyzer -I$(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java -I$(INCLUDE_TOP)\stx\goodies\petitparser\parsers\smalltalk -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\parsers\smalltalk & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)PEGFsa.$(O) PEGFsa.$(H): PEGFsa.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaAbstractDeterminizator.$(O) PEGFsaAbstractDeterminizator.$(H): PEGFsaAbstractDeterminizator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaFailure.$(O) PEGFsaFailure.$(H): PEGFsaFailure.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaInterpret.$(O) PEGFsaInterpret.$(H): PEGFsaInterpret.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaInterpretRecord.$(O) PEGFsaInterpretRecord.$(H): PEGFsaInterpretRecord.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaMinimizator.$(O) PEGFsaMinimizator.$(H): PEGFsaMinimizator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaPair.$(O) PEGFsaPair.$(H): PEGFsaPair.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaState.$(O) PEGFsaState.$(H): PEGFsaState.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaStateInfo.$(O) PEGFsaStateInfo.$(H): PEGFsaStateInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaTransition.$(O) PEGFsaTransition.$(H): PEGFsaTransition.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCASTUtilities.$(O) PPCASTUtilities.$(H): PPCASTUtilities.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCBridge.$(O) PPCBridge.$(H): PPCBridge.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCClass.$(O) PPCClass.$(H): PPCClass.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCClassBuilder.$(O) PPCClassBuilder.$(H): PPCClassBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCodeBlock.$(O) PPCCodeBlock.$(H): PPCCodeBlock.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCodeGen.$(O) PPCCodeGen.$(H): PPCCodeGen.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCompilationContext.$(O) PPCCompilationContext.$(H): PPCCompilationContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCompilationError.$(O) PPCCompilationError.$(H): PPCCompilationError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCompilationOptions.$(O) PPCCompilationOptions.$(H): PPCCompilationOptions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCompilationWarning.$(O) PPCCompilationWarning.$(H): PPCCompilationWarning.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\UserNotification.$(H) $(INCLUDE_TOP)\stx\libbasic\Warning.$(H) $(STCHDR)
$(OUTDIR)PPCCompiler.$(O) PPCCompiler.$(H): PPCCompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCContext.$(O) PPCContext.$(H): PPCContext.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\PeekableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\PositionableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\ReadStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(STCHDR)
$(OUTDIR)PPCContextMemento.$(O) PPCContextMemento.$(H): PPCContextMemento.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCDistinctScanner.$(O) PPCDistinctScanner.$(H): PPCDistinctScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCGuard.$(O) PPCGuard.$(H): PPCGuard.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCIdGenerator.$(O) PPCIdGenerator.$(H): PPCIdGenerator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCMethod.$(O) PPCMethod.$(H): PPCMethod.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNode.$(O) PPCNode.$(H): PPCNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNodeVisitor.$(O) PPCNodeVisitor.$(H): PPCNodeVisitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCPass.$(O) PPCPass.$(H): PPCPass.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCScanner.$(O) PPCScanner.$(H): PPCScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCScannerError.$(O) PPCScannerError.$(H): PPCScannerError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCScannerResultStrategy.$(O) PPCScannerResultStrategy.$(H): PPCScannerResultStrategy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenGuard.$(O) PPCTokenGuard.$(H): PPCTokenGuard.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCompiledParser.$(O) PPCompiledParser.$(H): PPCompiledParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPMappedActionParser.$(O) PPMappedActionParser.$(H): PPMappedActionParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPActionParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_petitparser_compiler.$(O) stx_goodies_petitparser_compiler.$(H): stx_goodies_petitparser_compiler.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)FooScanner.$(O) FooScanner.$(H): FooScanner.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCScanner.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaCharacterTransition.$(O) PEGFsaCharacterTransition.$(H): PEGFsaCharacterTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaTransition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaChoiceDeterminizator.$(O) PEGFsaChoiceDeterminizator.$(H): PEGFsaChoiceDeterminizator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaAbstractDeterminizator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaDeterminizator.$(O) PEGFsaDeterminizator.$(H): PEGFsaDeterminizator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaAbstractDeterminizator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaEpsilonTransition.$(O) PEGFsaEpsilonTransition.$(H): PEGFsaEpsilonTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaTransition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaParserState.$(O) PEGFsaParserState.$(H): PEGFsaParserState.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaState.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaPredicateTransition.$(O) PEGFsaPredicateTransition.$(H): PEGFsaPredicateTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaTransition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaSequenceDeterminizator.$(O) PEGFsaSequenceDeterminizator.$(H): PEGFsaSequenceDeterminizator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaAbstractDeterminizator.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaUncopiableState.$(O) PEGFsaUncopiableState.$(H): PEGFsaUncopiableState.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaState.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCAbstractLiteralNode.$(O) PPCAbstractLiteralNode.$(H): PPCAbstractLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCAbstractPredicateNode.$(O) PPCAbstractPredicateNode.$(H): PPCAbstractPredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCAnyNode.$(O) PPCAnyNode.$(H): PPCAnyNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCacheFirstFollowPass.$(O) PPCCacheFirstFollowPass.$(H): PPCCacheFirstFollowPass.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPass.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCharacterNode.$(O) PPCCharacterNode.$(H): PPCCharacterNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCDelegateNode.$(O) PPCDelegateNode.$(H): PPCDelegateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCDistinctResultStrategy.$(O) PPCDistinctResultStrategy.$(H): PPCDistinctResultStrategy.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCScannerResultStrategy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCEndOfFileNode.$(O) PPCEndOfFileNode.$(H): PPCEndOfFileNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCFSACodeGen.$(O) PPCFSACodeGen.$(H): PPCFSACodeGen.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCCodeGen.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCInlinedMethod.$(O) PPCInlinedMethod.$(H): PPCInlinedMethod.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCMethod.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCListNode.$(O) PPCListNode.$(H): PPCListNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNilNode.$(O) PPCNilNode.$(H): PPCNilNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNoResultStrategy.$(O) PPCNoResultStrategy.$(H): PPCNoResultStrategy.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCScannerResultStrategy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCPassVisitor.$(O) PPCPassVisitor.$(H): PPCPassVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCPluggableNode.$(O) PPCPluggableNode.$(H): PPCPluggableNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCProfilingContext.$(O) PPCProfilingContext.$(H): PPCProfilingContext.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPStream.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCContext.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\PeekableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\PositionableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\ReadStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(STCHDR)
$(OUTDIR)PPCScannerCodeGenerator.$(O) PPCScannerCodeGenerator.$(H): PPCScannerCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPass.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenizingCodeGen.$(O) PPCTokenizingCodeGen.$(H): PPCTokenizingCodeGen.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCCodeGen.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCUniversalCodeGen.$(O) PPCUniversalCodeGen.$(H): PPCUniversalCodeGen.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCCodeGen.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCUniversalResultStrategy.$(O) PPCUniversalResultStrategy.$(H): PPCUniversalResultStrategy.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCScannerResultStrategy.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCUnknownNode.$(O) PPCUnknownNode.$(H): PPCUnknownNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPTokenizingCompiledParser.$(O) PPTokenizingCompiledParser.$(H): PPTokenizingCompiledParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCompiledParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaEOFTransition.$(O) PEGFsaEOFTransition.$(H): PEGFsaEOFTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaPredicateTransition.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaTransition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaGenerator.$(O) PEGFsaGenerator.$(H): PEGFsaGenerator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PEGFsaParserTransition.$(O) PEGFsaParserTransition.$(H): PEGFsaParserTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaPredicateTransition.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PEGFsaTransition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCAbstractActionNode.$(O) PPCAbstractActionNode.$(H): PPCAbstractActionNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCAndNode.$(O) PPCAndNode.$(H): PPCAndNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCharSetPredicateNode.$(O) PPCCharSetPredicateNode.$(H): PPCCharSetPredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractPredicateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCheckingVisitor.$(O) PPCCheckingVisitor.$(H): PPCCheckingVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCChoiceNode.$(O) PPCChoiceNode.$(H): PPCChoiceNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCodeGenerator.$(O) PPCCodeGenerator.$(H): PPCCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCEndOfInputNode.$(O) PPCEndOfInputNode.$(H): PPCEndOfInputNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCFSAVisitor.$(O) PPCFSAVisitor.$(H): PPCFSAVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCForwardNode.$(O) PPCForwardNode.$(H): PPCForwardNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCInliningVisitor.$(O) PPCInliningVisitor.$(H): PPCInliningVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLiteralNode.$(O) PPCLiteralNode.$(H): PPCLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractLiteralNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCMessagePredicateNode.$(O) PPCMessagePredicateNode.$(H): PPCMessagePredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractPredicateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNegateNode.$(O) PPCNegateNode.$(H): PPCNegateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNotCharSetPredicateNode.$(O) PPCNotCharSetPredicateNode.$(H): PPCNotCharSetPredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractPredicateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNotCharacterNode.$(O) PPCNotCharacterNode.$(H): PPCNotCharacterNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCCharacterNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNotLiteralNode.$(O) PPCNotLiteralNode.$(H): PPCNotLiteralNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractLiteralNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNotMessagePredicateNode.$(O) PPCNotMessagePredicateNode.$(H): PPCNotMessagePredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractPredicateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCNotNode.$(O) PPCNotNode.$(H): PPCNotNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCOptionalNode.$(O) PPCOptionalNode.$(H): PPCOptionalNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCPlusNode.$(O) PPCPlusNode.$(H): PPCPlusNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCPredicateNode.$(O) PPCPredicateNode.$(H): PPCPredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractPredicateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCRewritingVisitor.$(O) PPCRewritingVisitor.$(H): PPCRewritingVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCSentinelNode.$(O) PPCSentinelNode.$(H): PPCSentinelNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNilNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCSequenceNode.$(O) PPCSequenceNode.$(H): PPCSequenceNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCStarNode.$(O) PPCStarNode.$(H): PPCStarNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenCodeGenerator.$(O) PPCTokenCodeGenerator.$(H): PPCTokenCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenConsumeNode.$(O) PPCTokenConsumeNode.$(H): PPCTokenConsumeNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenNode.$(O) PPCTokenNode.$(H): PPCTokenNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenWhitespaceNode.$(O) PPCTokenWhitespaceNode.$(H): PPCTokenWhitespaceNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenizingParserNode.$(O) PPCTokenizingParserNode.$(H): PPCTokenizingParserNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTrimmingTokenNode.$(O) PPCTrimmingTokenNode.$(H): PPCTrimmingTokenNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCActionNode.$(O) PPCActionNode.$(H): PPCActionNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractActionNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCCopyVisitor.$(O) PPCCopyVisitor.$(H): PPCCopyVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCDeterministicChoiceNode.$(O) PPCDeterministicChoiceNode.$(H): PPCDeterministicChoiceNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCChoiceNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLL1Visitor.$(O) PPCLL1Visitor.$(H): PPCLL1Visitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCMergingVisitor.$(O) PPCMergingVisitor.$(H): PPCMergingVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCOptimizeChoices.$(O) PPCOptimizeChoices.$(H): PPCOptimizeChoices.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCRecognizerComponentDetector.$(O) PPCRecognizerComponentDetector.$(H): PPCRecognizerComponentDetector.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCRecognizerComponentVisitor.$(O) PPCRecognizerComponentVisitor.$(H): PPCRecognizerComponentVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCRecognizingSequenceNode.$(O) PPCRecognizingSequenceNode.$(H): PPCRecognizingSequenceNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCSequenceNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCSpecializingVisitor.$(O) PPCSpecializingVisitor.$(H): PPCSpecializingVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCStarAnyNode.$(O) PPCStarAnyNode.$(H): PPCStarAnyNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCStarNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCStarCharSetPredicateNode.$(O) PPCStarCharSetPredicateNode.$(H): PPCStarCharSetPredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCStarNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCStarMessagePredicateNode.$(O) PPCStarMessagePredicateNode.$(H): PPCStarMessagePredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCStarNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCSymbolActionNode.$(O) PPCSymbolActionNode.$(H): PPCSymbolActionNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractActionNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenChoiceNode.$(O) PPCTokenChoiceNode.$(H): PPCTokenChoiceNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCChoiceNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenDetector.$(O) PPCTokenDetector.$(H): PPCTokenDetector.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenVisitor.$(O) PPCTokenVisitor.$(H): PPCTokenVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenizingCodeGenerator.$(O) PPCTokenizingCodeGenerator.$(H): PPCTokenizingCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenizingVisitor.$(O) PPCTokenizingVisitor.$(H): PPCTokenizingVisitor.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCRewritingVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTrimNode.$(O) PPCTrimNode.$(H): PPCTrimNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCSequenceNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTrimmingCharacterTokenNode.$(O) PPCTrimmingCharacterTokenNode.$(H): PPCTrimmingCharacterTokenNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCListNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCTrimmingTokenNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCUniversalCodeGenerator.$(O) PPCUniversalCodeGenerator.$(H): PPCUniversalCodeGenerator.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCCodeGenerator.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNodeVisitor.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCPassVisitor.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCMappedActionNode.$(O) PPCMappedActionNode.$(H): PPCMappedActionNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCAbstractActionNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCActionNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenStarMessagePredicateNode.$(O) PPCTokenStarMessagePredicateNode.$(H): PPCTokenStarMessagePredicateNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCStarMessagePredicateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCStarNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCTokenStarSeparatorNode.$(O) PPCTokenStarSeparatorNode.$(H): PPCTokenStarSeparatorNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCDelegateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCStarMessagePredicateNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCStarNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\PPCTokenStarMessagePredicateNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPActionParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPAndParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPCharSetPredicate.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPChoiceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPCompositeParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPContext.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEndOfFileParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEndOfInputParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEpsilonParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPFailure.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPFlattenParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPListParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralObjectParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPNotParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPOptionalParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPluggableParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPossessiveRepeatingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateObjectParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPRepeatingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPStream.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPToken.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPTokenParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPTrimmingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\smalltalk\PPSmalltalkGrammar.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\smalltalk\PPSmalltalkTokenParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\smalltalk\PPSmalltalkWhitespaceParser.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBLiteralNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBLiteralValueNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBProgramNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBStatementNode.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser\RBValueNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Character.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\PeekableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\PositionableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\ReadStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(INCLUDE_TOP)\stx\libbasic\UndefinedObject.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_petitparser_compiler.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
