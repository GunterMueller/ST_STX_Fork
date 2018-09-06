# $Header: /cvs/stx/stx/goodies/monticello/test/bc.mak,v 1.3 2013-05-29 00:03:32 vrany Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_monticello_test.
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

LIBNAME=libstx_goodies_monticello_test
RESFILES=test.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\goodies\sunit
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
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)MCDependencySorterTest.$(O) MCDependencySorterTest.$(H): MCDependencySorterTest.st $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSnapshotResource.$(O) MCSnapshotResource.$(H): MCSnapshotResource.st $(INCLUDE_TOP)\stx\goodies\sunit\TestResource.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSortingTest.$(O) MCSortingTest.$(H): MCSortingTest.st $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCTestCase.$(O) MCTestCase.$(H): MCTestCase.st $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_monticello_test.$(O) stx_goodies_monticello_test.$(H): stx_goodies_monticello_test.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCAncestryTest.$(O) MCAncestryTest.$(H): MCAncestryTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCChangeNotificationTest.$(O) MCChangeNotificationTest.$(H): MCChangeNotificationTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCClassDefinitionTest.$(O) MCClassDefinitionTest.$(H): MCClassDefinitionTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCFileInTest.$(O) MCFileInTest.$(H): MCFileInTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCInitializationTest.$(O) MCInitializationTest.$(H): MCInitializationTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMczInstallerTest.$(O) MCMczInstallerTest.$(H): MCMczInstallerTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMergingTest.$(O) MCMergingTest.$(H): MCMergingTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCMethodDefinitionTest.$(O) MCMethodDefinitionTest.$(H): MCMethodDefinitionTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCOrganizationTest.$(O) MCOrganizationTest.$(H): MCOrganizationTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPackageTest.$(O) MCPackageTest.$(H): MCPackageTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCPatchTest.$(O) MCPatchTest.$(H): MCPatchTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCRepositoryTest.$(O) MCRepositoryTest.$(H): MCRepositoryTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCScannerTest.$(O) MCScannerTest.$(H): MCScannerTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSerializationTest.$(O) MCSerializationTest.$(H): MCSerializationTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSnapshotBrowserTest.$(O) MCSnapshotBrowserTest.$(H): MCSnapshotBrowserTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCSnapshotTest.$(O) MCSnapshotTest.$(H): MCSnapshotTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStReaderTest.$(O) MCStReaderTest.$(H): MCStReaderTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCStWriterTest.$(O) MCStWriterTest.$(H): MCStWriterTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCVersionTest.$(O) MCVersionTest.$(H): MCVersionTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCWorkingCopyTest.$(O) MCWorkingCopyTest.$(H): MCWorkingCopyTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCDictionaryRepositoryTest.$(O) MCDictionaryRepositoryTest.$(H): MCDictionaryRepositoryTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCRepositoryTest.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MCDirectoryRepositoryTest.$(O) MCDirectoryRepositoryTest.$(H): MCDirectoryRepositoryTest.st $(INCLUDE_TOP)\stx\goodies\monticello\test\MCRepositoryTest.$(H) $(INCLUDE_TOP)\stx\goodies\monticello\test\MCTestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
