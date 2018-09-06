# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_helpers.
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


# see stdHeader_bc for LIB_RB_HELPERS_BASE
LIB_BASE=$(LIB_RB_HELPERS_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_refactoryBrowser_helpers
MODULE_PATH=goodies\refactoryBrowser\helpers
RESFILES=stx_goodies_refactoryBrowser_helpersWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libcompat
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







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)BrowserEnvironment.$(O) BrowserEnvironment.$(C) BrowserEnvironment.$(H): BrowserEnvironment.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBAbstractClass.$(O) RBAbstractClass.$(C) RBAbstractClass.$(H): RBAbstractClass.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMethod.$(O) RBMethod.$(C) RBMethod.$(H): RBMethod.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMethodName.$(O) RBMethodName.$(C) RBMethodName.$(H): RBMethodName.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBNamespace.$(O) RBNamespace.$(C) RBNamespace.$(H): RBNamespace.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_refactoryBrowser_helpers.$(O) stx_goodies_refactoryBrowser_helpers.$(C) stx_goodies_refactoryBrowser_helpers.$(H): stx_goodies_refactoryBrowser_helpers.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)RBClass.$(O) RBClass.$(C) RBClass.$(H): RBClass.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\RBAbstractClass.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RBMetaclass.$(O) RBMetaclass.$(C) RBMetaclass.$(H): RBMetaclass.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers\RBAbstractClass.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_refactoryBrowser_helpers.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
