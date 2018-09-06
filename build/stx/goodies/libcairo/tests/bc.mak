# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_libcairo_tests.
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

LIBNAME=libstx_goodies_libcairo_tests
MODULE_PATH=goodies\libcairo\tests
RESFILES=stx_goodies_libcairo_testsWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\libcairo -I$(INCLUDE_TOP)\stx\goodies\sunit -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg
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
	pushd .. & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\sunit & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)Cairo__GraphicsContextTests.$(O) Cairo__GraphicsContextTests.$(C) Cairo__GraphicsContextTests.$(H): Cairo__GraphicsContextTests.st $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__FontSlant.$(H) $(INCLUDE_TOP)\stx\goodies\libcairo\Cairo__FontWeight.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Cairo__PatternTests.$(O) Cairo__PatternTests.$(C) Cairo__PatternTests.$(H): Cairo__PatternTests.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CairoGraphicsContextTests.$(O) CairoGraphicsContextTests.$(C) CairoGraphicsContextTests.$(H): CairoGraphicsContextTests.st $(INCLUDE_TOP)\stx\goodies\sunit\TestAsserter.$(H) $(INCLUDE_TOP)\stx\goodies\sunit\TestCase.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_libcairo_tests.$(O) stx_goodies_libcairo_tests.$(C) stx_goodies_libcairo_tests.$(H): stx_goodies_libcairo_tests.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_libcairo_tests.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
