# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_tests.
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

LIBNAME=libstx_goodies_refactoryBrowser_tests
MODULE_PATH=goodies\refactoryBrowser\tests
RESFILES=stx_goodies_refactoryBrowser_testsWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\lint -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\refactoring -I$(INCLUDE_TOP)\stx\goodies\sunit -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libcomp
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
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)CodeDuplicationTest.$(O) CodeDuplicationTest.$(C) CodeDuplicationTest.$(H): CodeDuplicationTest.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)LintRuleTest.$(O) LintRuleTest.$(C) LintRuleTest.$(H): LintRuleTest.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParseTreeSourceRewriterTests.$(O) ParseTreeSourceRewriterTests.$(C) ParseTreeSourceRewriterTests.$(H): ParseTreeSourceRewriterTests.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoringBrowserTest.$(O) RefactoringBrowserTest.$(C) RefactoringBrowserTest.$(H): RefactoringBrowserTest.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoringFormatterTest.$(O) RefactoringFormatterTest.$(C) RefactoringFormatterTest.$(H): RefactoringFormatterTest.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryTestDataApp.$(O) RefactoryTestDataApp.$(C) RefactoryTestDataApp.$(H): RefactoryTestDataApp.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SentNotImplementedTestCase.$(O) SentNotImplementedTestCase.$(C) SentNotImplementedTestCase.$(H): SentNotImplementedTestCase.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_refactoryBrowser_tests.$(O) stx_goodies_refactoryBrowser_tests.$(C) stx_goodies_refactoryBrowser_tests.$(H): stx_goodies_refactoryBrowser_tests.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)BasicLintRuleTest.$(O) BasicLintRuleTest.$(C) BasicLintRuleTest.$(H): BasicLintRuleTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\LintRuleTest.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)BrowserEnvironmentTest.$(O) BrowserEnvironmentTest.$(C) BrowserEnvironmentTest.$(H): BrowserEnvironmentTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CompositeLintRuleTest.$(O) CompositeLintRuleTest.$(C) CompositeLintRuleTest.$(H): CompositeLintRuleTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\LintRuleTest.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExtraParsingAndFormattingTests.$(O) ExtraParsingAndFormattingTests.$(C) ExtraParsingAndFormattingTests.$(H): ExtraParsingAndFormattingTests.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)FooLintRuleTest.$(O) FooLintRuleTest.$(C) FooLintRuleTest.$(H): FooLintRuleTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\LintRuleTest.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBClassTest.$(O) RBClassTest.$(C) RBClassTest.$(H): RBClassTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBNamespaceTest.$(O) RBNamespaceTest.$(C) RBNamespaceTest.$(H): RBNamespaceTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBParserTest.$(O) RBParserTest.$(C) RBParserTest.$(H): RBParserTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoringTest.$(O) RefactoringTest.$(C) RefactoringTest.$(H): RefactoringTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ReferenceFinderTest.$(O) ReferenceFinderTest.$(C) ReferenceFinderTest.$(H): ReferenceFinderTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SmalllintTest.$(O) SmalllintTest.$(C) SmalllintTest.$(H): SmalllintTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VariableTypeTest.$(O) VariableTypeTest.$(C) VariableTypeTest.$(H): VariableTypeTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AbstractClassVariableTest.$(O) AbstractClassVariableTest.$(C) AbstractClassVariableTest.$(H): AbstractClassVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AbstractInstanceVariableTest.$(O) AbstractInstanceVariableTest.$(C) AbstractInstanceVariableTest.$(H): AbstractInstanceVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddClassTest.$(O) AddClassTest.$(C) AddClassTest.$(H): AddClassTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddClassVariableTest.$(O) AddClassVariableTest.$(C) AddClassVariableTest.$(H): AddClassVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddInstanceVariableTest.$(O) AddInstanceVariableTest.$(C) AddInstanceVariableTest.$(H): AddInstanceVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddMethodTest.$(O) AddMethodTest.$(C) AddMethodTest.$(H): AddMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddParameterTest.$(O) AddParameterTest.$(C) AddParameterTest.$(H): AddParameterTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ChildrenToSiblingsTest.$(O) ChildrenToSiblingsTest.$(C) ChildrenToSiblingsTest.$(H): ChildrenToSiblingsTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CreateAccessorsForVariableTest.$(O) CreateAccessorsForVariableTest.$(C) CreateAccessorsForVariableTest.$(H): CreateAccessorsForVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExtractMethodTest.$(O) ExtractMethodTest.$(C) ExtractMethodTest.$(H): ExtractMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExtractMethodToComponentTest.$(O) ExtractMethodToComponentTest.$(C) ExtractMethodToComponentTest.$(H): ExtractMethodToComponentTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ExtractToTemporaryTest.$(O) ExtractToTemporaryTest.$(C) ExtractToTemporaryTest.$(H): ExtractToTemporaryTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineAllMethodTest.$(O) InlineAllMethodTest.$(C) InlineAllMethodTest.$(H): InlineAllMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineMethodFromComponentTest.$(O) InlineMethodFromComponentTest.$(C) InlineMethodFromComponentTest.$(H): InlineMethodFromComponentTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineMethodTest.$(O) InlineMethodTest.$(C) InlineMethodTest.$(H): InlineMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineParameterTest.$(O) InlineParameterTest.$(C) InlineParameterTest.$(H): InlineParameterTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InlineTemporaryTest.$(O) InlineTemporaryTest.$(C) InlineTemporaryTest.$(H): InlineTemporaryTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MoveMethodTest.$(O) MoveMethodTest.$(C) MoveMethodTest.$(H): MoveMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MoveVariableDefinitionTest.$(O) MoveVariableDefinitionTest.$(C) MoveVariableDefinitionTest.$(H): MoveVariableDefinitionTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ProtectInstanceVariableTest.$(O) ProtectInstanceVariableTest.$(C) ProtectInstanceVariableTest.$(H): ProtectInstanceVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PullUpClassVariableTest.$(O) PullUpClassVariableTest.$(C) PullUpClassVariableTest.$(H): PullUpClassVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushDownClassVariableTest.$(O) PushDownClassVariableTest.$(C) PushDownClassVariableTest.$(H): PushDownClassVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushDownInstanceVariableTest.$(O) PushDownInstanceVariableTest.$(C) PushDownInstanceVariableTest.$(H): PushDownInstanceVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushDownMethodTest.$(O) PushDownMethodTest.$(C) PushDownMethodTest.$(H): PushDownMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushUpInstanceVariableTest.$(O) PushUpInstanceVariableTest.$(C) PushUpInstanceVariableTest.$(H): PushUpInstanceVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PushUpMethodTest.$(O) PushUpMethodTest.$(C) PushUpMethodTest.$(H): PushUpMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveClassTest.$(O) RemoveClassTest.$(C) RemoveClassTest.$(H): RemoveClassTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveClassVariableTest.$(O) RemoveClassVariableTest.$(C) RemoveClassVariableTest.$(H): RemoveClassVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveInstanceVariableTest.$(O) RemoveInstanceVariableTest.$(C) RemoveInstanceVariableTest.$(H): RemoveInstanceVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveMethodTest.$(O) RemoveMethodTest.$(C) RemoveMethodTest.$(H): RemoveMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveParameterTest.$(O) RemoveParameterTest.$(C) RemoveParameterTest.$(H): RemoveParameterTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameClassTest.$(O) RenameClassTest.$(C) RenameClassTest.$(H): RenameClassTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameClassVariableTest.$(O) RenameClassVariableTest.$(C) RenameClassVariableTest.$(H): RenameClassVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameInstanceVariableTest.$(O) RenameInstanceVariableTest.$(C) RenameInstanceVariableTest.$(H): RenameInstanceVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameMethodTest.$(O) RenameMethodTest.$(C) RenameMethodTest.$(H): RenameMethodTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameTemporaryTest.$(O) RenameTemporaryTest.$(C) RenameTemporaryTest.$(H): RenameTemporaryTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TemporaryToInstanceVariableTest.$(O) TemporaryToInstanceVariableTest.$(C) TemporaryToInstanceVariableTest.$(H): TemporaryToInstanceVariableTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TransformationRuleTest.$(O) TransformationRuleTest.$(C) TransformationRuleTest.$(H): TransformationRuleTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\FooLintRuleTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\LintRuleTest.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VariableEnvironmentTest.$(O) VariableEnvironmentTest.$(C) VariableEnvironmentTest.$(H): VariableEnvironmentTest.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\BrowserEnvironmentTest.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\tests\RefactoringBrowserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
