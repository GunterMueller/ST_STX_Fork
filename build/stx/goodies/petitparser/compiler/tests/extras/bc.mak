# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_petitparser_compiler_tests_extras.
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
TOP=..\..\..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_petitparser_compiler_tests_extras
MODULE_PATH=goodies\petitparser\compiler\tests\extras
RESFILES=extras.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\petitparser -I$(INCLUDE_TOP)\stx\goodies\petitparser\compiler -I$(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java -I$(INCLUDE_TOP)\stx\goodies\petitparser\parsers\smalltalk -I$(INCLUDE_TOP)\stx\goodies\petitparser\parsers\smalltalk\tests -I$(INCLUDE_TOP)\stx\goodies\petitparser\tests -I$(INCLUDE_TOP)\stx\goodies\sunit -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\.. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\tests & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\parsers\java & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\parsers\smalltalk\tests & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)PPCLRPNode.$(O) PPCLRPNode.$(H): PPCLRPNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPParser.$(O) PPCLRPParser.$(H): PPCLRPParser.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPCompositeParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPDelegateParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPParserSmokeTest.$(O) PPCLRPParserSmokeTest.$(H): PPCLRPParserSmokeTest.st $(INCLUDE_TOP)\stx\goodies\petitparser\tests\PPAbstractParserTest.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\tests\PPCompositeParserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPSourcesResource.$(O) PPCLRPSourcesResource.$(H): PPCLRPSourcesResource.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestResource.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPAction.$(O) PPCLRPAction.$(H): PPCLRPAction.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPCompiledParserSmokeTest.$(O) PPCLRPCompiledParserSmokeTest.$(H): PPCLRPCompiledParserSmokeTest.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPParserSmokeTest.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\tests\PPAbstractParserTest.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\tests\PPCompositeParserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPContainedElement.$(O) PPCLRPContainedElement.$(H): PPCLRPContainedElement.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPSpawn.$(O) PPCLRPSpawn.$(H): PPCLRPSpawn.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPComment.$(O) PPCLRPComment.$(H): PPCLRPComment.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPCompiledParserSmokeTest_Universal.$(O) PPCLRPCompiledParserSmokeTest_Universal.$(H): PPCLRPCompiledParserSmokeTest_Universal.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPCompiledParserSmokeTest.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPParserSmokeTest.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\tests\PPAbstractParserTest.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\tests\PPCompositeParserTest.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPErrorNode.$(O) PPCLRPErrorNode.$(H): PPCLRPErrorNode.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPEvent.$(O) PPCLRPEvent.$(H): PPCLRPEvent.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPMachine.$(O) PPCLRPMachine.$(H): PPCLRPMachine.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPOnEntry.$(O) PPCLRPOnEntry.$(H): PPCLRPOnEntry.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPAction.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPOnExit.$(O) PPCLRPOnExit.$(H): PPCLRPOnExit.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPAction.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPRunning.$(O) PPCLRPRunning.$(H): PPCLRPRunning.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPAction.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPState.$(O) PPCLRPState.$(H): PPCLRPState.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPTransition.$(O) PPCLRPTransition.$(H): PPCLRPTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPVariable.$(O) PPCLRPVariable.$(H): PPCLRPVariable.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPEpsilonTransition.$(O) PPCLRPEpsilonTransition.$(H): PPCLRPEpsilonTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPTransition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPTimeoutTransition.$(O) PPCLRPTimeoutTransition.$(H): PPCLRPTimeoutTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPTransition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PPCLRPWildcardTransition.$(O) PPCLRPWildcardTransition.$(H): PPCLRPWildcardTransition.st $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPContainedElement.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPNode.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\compiler\tests\extras\PPCLRPTransition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\goodies\petitparser\PPParser.$(H) $(INCLUDE_TOP)\stx\goodies\petitparser\parsers\java\PPJavaWhitespaceParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_petitparser_compiler_tests_extras.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
