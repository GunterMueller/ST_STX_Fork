# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_sunit.
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

LIBNAME=libstx_goodies_sunit
MODULE_PATH=goodies\sunit
RESFILES=stx_goodies_sunitWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2
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
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)MetricsReporter.$(O) MetricsReporter.$(C) MetricsReporter.$(H): MetricsReporter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SUnitDelay.$(O) SUnitDelay.$(C) SUnitDelay.$(H): SUnitDelay.st $(INCLUDE_TOP)\stx\libbasic\Delay.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SUnitNameResolver.$(O) SUnitNameResolver.$(C) SUnitNameResolver.$(H): SUnitNameResolver.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestAsserter.$(O) TestAsserter.$(C) TestAsserter.$(H): TestAsserter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestCaseOutcome.$(O) TestCaseOutcome.$(C) TestCaseOutcome.$(H): TestCaseOutcome.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestCoverageReporter.$(O) TestCoverageReporter.$(C) TestCoverageReporter.$(H): TestCoverageReporter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestFailure.$(O) TestFailure.$(C) TestFailure.$(H): TestFailure.st $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestResult.$(O) TestResult.$(C) TestResult.$(H): TestResult.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestResultReporter.$(O) TestResultReporter.$(C) TestResultReporter.$(H): TestResultReporter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestRunner.$(O) TestRunner.$(C) TestRunner.$(H): TestRunner.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)TestSuite.$(O) TestSuite.$(C) TestSuite.$(H): TestSuite.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestSuitesScripter.$(O) TestSuitesScripter.$(C) TestSuitesScripter.$(H): TestSuitesScripter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_sunit.$(O) stx_goodies_sunit.$(C) stx_goodies_sunit.$(H): stx_goodies_sunit.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)ResumableTestFailure.$(O) ResumableTestFailure.$(C) ResumableTestFailure.$(H): ResumableTestFailure.st $(INCLUDE_TOP)\stx\goodies\sunit\TestFailure.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestCase.$(O) TestCase.$(C) TestCase.$(H): TestCase.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestResource.$(O) TestResource.$(C) TestResource.$(H): TestResource.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestResultStX.$(O) TestResultStX.$(C) TestResultStX.$(H): TestResultStX.st $(INCLUDE_TOP)\stx\goodies\sunit\TestResult.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestSkipped.$(O) TestSkipped.$(C) TestSkipped.$(H): TestSkipped.st $(INCLUDE_TOP)\stx\goodies\sunit\TestFailure.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestCaseWithArguments.$(O) TestCaseWithArguments.$(C) TestCaseWithArguments.$(H): TestCaseWithArguments.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TestResultForRunWithDebug.$(O) TestResultForRunWithDebug.$(C) TestResultForRunWithDebug.$(H): TestResultForRunWithDebug.st $(INCLUDE_TOP)\stx\goodies\sunit\TestResult.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestResultStX.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Block.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\String.$(H) $(INCLUDE_TOP)\stx\libbasic\Symbol.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_sunit.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
