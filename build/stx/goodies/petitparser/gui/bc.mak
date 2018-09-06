# $Header: /cvs/stx/stx/goodies/petitparser/gui/bc.mak,v 1.1 2014-03-04 21:20:23 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_gui.
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

LIBNAME=libstx_goodies_petitparser_gui
RESFILES=gui.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\petitparser -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring -I$(INCLUDE_TOP)\stx\libbasic
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
	pushd ..\..\refactoryBrowser\refactoring & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)GLMCompositePresentation.$(O) GLMCompositePresentation.$(H): GLMCompositePresentation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPAddParserRefactoring.$(O) PPAddParserRefactoring.$(H): PPAddParserRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPBrowserStream.$(O) PPBrowserStream.$(H): PPBrowserStream.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\PeekableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\PositionableStream.$(H) $(INCLUDE_TOP)\stx\libbasic\ReadStream.$(H) $(INCLUDE_TOP)\stx\libbasic\Stream.$(H) $(STCHDR)
$(OUTDIR)PPDefineProdcutionRefactoring.$(O) PPDefineProdcutionRefactoring.$(H): PPDefineProdcutionRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPDrabBrowser.$(O) PPDrabBrowser.$(H): PPDrabBrowser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPExtractProdcutionRefactoring.$(O) PPExtractProdcutionRefactoring.$(H): PPExtractProdcutionRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\ExtractMethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\MethodRefactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPParserDebuggerResult.$(O) PPParserDebuggerResult.$(H): PPParserDebuggerResult.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPRefactoringUtils.$(O) PPRefactoringUtils.$(H): PPRefactoringUtils.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPRemoveParserRefactoring.$(O) PPRemoveParserRefactoring.$(H): PPRemoveParserRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\RemoveClassRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPRenameProdcutionRefactoring.$(O) PPRenameProdcutionRefactoring.$(H): PPRenameProdcutionRefactoring.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPTextHighlighter.$(O) PPTextHighlighter.$(H): PPTextHighlighter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBRefactoring.$(O) RBRefactoring.$(H): RBRefactoring.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBRemoveClassRefactoring.$(O) RBRemoveClassRefactoring.$(H): RBRemoveClassRefactoring.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_petitparser_gui.$(O) stx_goodies_petitparser_gui.$(H): stx_goodies_petitparser_gui.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)PPBrowser.$(O) PPBrowser.$(H): PPBrowser.st $(INCLUDE_TOP)\stx\goodies\petitparser\gui\GLMCompositePresentation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPParserBrowser.$(O) PPParserBrowser.$(H): PPParserBrowser.st $(INCLUDE_TOP)\stx\goodies\petitparser\gui\GLMCompositePresentation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPParserInspector.$(O) PPParserInspector.$(H): PPParserInspector.st $(INCLUDE_TOP)\stx\goodies\petitparser\gui\GLMCompositePresentation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPRemoveProdcutionRefactoring.$(O) PPRemoveProdcutionRefactoring.$(H): PPRemoveProdcutionRefactoring.st $(INCLUDE_TOP)\stx\goodies\petitparser\gui\RBRefactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPAndParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPChoiceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEndOfInputParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPEpsilonParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPFailingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPListParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPLiteralSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPNotParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPluggableParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPPredicateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPRepeatingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPSequenceParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPTrimmingParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPUnresolvedParser.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring\Refactoring.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
