# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_smaCC.
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
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_smaCC
MODULE_PATH=goodies\smaCC
RESFILES=smaCC.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libhtml -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)SmaCC__SmaCCAction.$(O) SmaCC__SmaCCAction.$(H): SmaCC__SmaCCAction.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCCompilationNotification.$(O) SmaCC__SmaCCCompilationNotification.$(H): SmaCC__SmaCCCompilationNotification.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCEdge.$(O) SmaCC__SmaCCEdge.$(H): SmaCC__SmaCCEdge.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCGrammar.$(O) SmaCC__SmaCCGrammar.$(H): SmaCC__SmaCCGrammar.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCGrammarCompiler.$(O) SmaCC__SmaCCGrammarCompiler.$(H): SmaCC__SmaCCGrammarCompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCItemSet.$(O) SmaCC__SmaCCItemSet.$(H): SmaCC__SmaCCItemSet.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCLR1Item.$(O) SmaCC__SmaCCLR1Item.$(H): SmaCC__SmaCCLR1Item.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCLineNumberStream.$(O) SmaCC__SmaCCLineNumberStream.$(H): SmaCC__SmaCCLineNumberStream.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\PeekableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCNode.$(O) SmaCC__SmaCCNode.$(H): SmaCC__SmaCCNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCParser.$(O) SmaCC__SmaCCParser.$(H): SmaCC__SmaCCParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCParserError.$(O) SmaCC__SmaCCParserError.$(H): SmaCC__SmaCCParserError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCParserGenerator.$(O) SmaCC__SmaCCParserGenerator.$(H): SmaCC__SmaCCParserGenerator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCRHS.$(O) SmaCC__SmaCCRHS.$(H): SmaCC__SmaCCRHS.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCRegularExpressionNode.$(O) SmaCC__SmaCCRegularExpressionNode.$(H): SmaCC__SmaCCRegularExpressionNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCScanner.$(O) SmaCC__SmaCCScanner.$(H): SmaCC__SmaCCScanner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCScannerCompiler.$(O) SmaCC__SmaCCScannerCompiler.$(H): SmaCC__SmaCCScannerCompiler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCSymbol.$(O) SmaCC__SmaCCSymbol.$(H): SmaCC__SmaCCSymbol.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCSymbolSet.$(O) SmaCC__SmaCCSymbolSet.$(H): SmaCC__SmaCCSymbolSet.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCToken.$(O) SmaCC__SmaCCToken.$(H): SmaCC__SmaCCToken.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_smaCC.$(O) stx_goodies_smaCC.$(H): stx_goodies_smaCC.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCAcceptAction.$(O) SmaCC__SmaCCAcceptAction.$(H): SmaCC__SmaCCAcceptAction.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCAction.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCAdvancedParser.$(O) SmaCC__SmaCCAdvancedParser.$(H): SmaCC__SmaCCAdvancedParser.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCAdvancedScanner.$(O) SmaCC__SmaCCAdvancedScanner.$(H): SmaCC__SmaCCAdvancedScanner.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCScanner.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCCharacterRENode.$(O) SmaCC__SmaCCCharacterRENode.$(H): SmaCC__SmaCCCharacterRENode.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCRegularExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCGrammarParser.$(O) SmaCC__SmaCCGrammarParser.$(H): SmaCC__SmaCCGrammarParser.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCGrammarScanner.$(O) SmaCC__SmaCCGrammarScanner.$(H): SmaCC__SmaCCGrammarScanner.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCScanner.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCNonTerminalSymbol.$(O) SmaCC__SmaCCNonTerminalSymbol.$(H): SmaCC__SmaCCNonTerminalSymbol.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCSymbol.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCOrRENode.$(O) SmaCC__SmaCCOrRENode.$(H): SmaCC__SmaCCOrRENode.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCRegularExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCReduceAction.$(O) SmaCC__SmaCCReduceAction.$(H): SmaCC__SmaCCReduceAction.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCAction.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCRejectAction.$(O) SmaCC__SmaCCRejectAction.$(H): SmaCC__SmaCCRejectAction.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCAction.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCRepeatingRENode.$(O) SmaCC__SmaCCRepeatingRENode.$(H): SmaCC__SmaCCRepeatingRENode.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCRegularExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCScannerParser.$(O) SmaCC__SmaCCScannerParser.$(H): SmaCC__SmaCCScannerParser.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCScannerScanner.$(O) SmaCC__SmaCCScannerScanner.$(H): SmaCC__SmaCCScannerScanner.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCScanner.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCSequenceRENode.$(O) SmaCC__SmaCCSequenceRENode.$(H): SmaCC__SmaCCSequenceRENode.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCRegularExpressionNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCShiftAction.$(O) SmaCC__SmaCCShiftAction.$(H): SmaCC__SmaCCShiftAction.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCAction.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCTerminalSymbol.$(O) SmaCC__SmaCCTerminalSymbol.$(H): SmaCC__SmaCCTerminalSymbol.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCSymbol.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmaCC__SmaCCStartingSymbol.$(O) SmaCC__SmaCCStartingSymbol.$(H): SmaCC__SmaCCStartingSymbol.st $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCNonTerminalSymbol.$(H) $(INCLUDE_TOP)\stx\goodies\smaCC\SmaCC__SmaCCSymbol.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
