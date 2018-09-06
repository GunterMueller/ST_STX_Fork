# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_refactoryBrowser_changes.
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


# see stdHeader_bc for LIB_RB_CHANGES_BASE
LIB_BASE=$(LIB_RB_CHANGES_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_refactoryBrowser_changes
MODULE_PATH=goodies\refactoryBrowser\changes
RESFILES=changes.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\helpers -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic3
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
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)RefactoryChange.$(O) RefactoryChange.$(H): RefactoryChange.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryChangeManager.$(O) RefactoryChangeManager.$(H): RefactoryChangeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_refactoryBrowser_changes.$(O) stx_goodies_refactoryBrowser_changes.$(H): stx_goodies_refactoryBrowser_changes.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)ClassRefactoryChange.$(O) ClassRefactoryChange.$(H): ClassRefactoryChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CompositeRefactoryChange.$(O) CompositeRefactoryChange.$(H): CompositeRefactoryChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MethodRefactoryChange.$(O) MethodRefactoryChange.$(H): MethodRefactoryChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryClassChange.$(O) RefactoryClassChange.$(H): RefactoryClassChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddClassChange.$(O) AddClassChange.$(H): AddClassChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddMethodChange.$(O) AddMethodChange.$(H): AddMethodChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryClassCategoryChange.$(O) RefactoryClassCategoryChange.$(H): RefactoryClassCategoryChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryClassProjectChange.$(O) RefactoryClassProjectChange.$(H): RefactoryClassProjectChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryMethodCategoryChange.$(O) RefactoryMethodCategoryChange.$(H): RefactoryMethodCategoryChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryMethodProjectChange.$(O) RefactoryMethodProjectChange.$(H): RefactoryMethodProjectChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RefactoryVariableChange.$(O) RefactoryVariableChange.$(H): RefactoryVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveClassChange.$(O) RemoveClassChange.$(H): RemoveClassChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveMethodChange.$(O) RemoveMethodChange.$(H): RemoveMethodChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameClassChange.$(O) RenameClassChange.$(H): RenameClassChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\CompositeRefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameVariableChange.$(O) RenameVariableChange.$(H): RenameVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\CompositeRefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddClassVariableChange.$(O) AddClassVariableChange.$(H): AddClassVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryVariableChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddInstanceVariableChange.$(O) AddInstanceVariableChange.$(H): AddInstanceVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryVariableChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AddPoolVariableChange.$(O) AddPoolVariableChange.$(H): AddPoolVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryVariableChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InteractiveAddClassChange.$(O) InteractiveAddClassChange.$(H): InteractiveAddClassChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\AddClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InteractiveAddMethodChange.$(O) InteractiveAddMethodChange.$(H): InteractiveAddMethodChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\AddMethodChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveClassVariableChange.$(O) RemoveClassVariableChange.$(H): RemoveClassVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryVariableChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemoveInstanceVariableChange.$(O) RemoveInstanceVariableChange.$(H): RemoveInstanceVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryVariableChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RemovePoolVariableChange.$(O) RemovePoolVariableChange.$(H): RemovePoolVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryClassChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryVariableChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameClassVariableChange.$(O) RenameClassVariableChange.$(H): RenameClassVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\CompositeRefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RenameVariableChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RenameInstanceVariableChange.$(O) RenameInstanceVariableChange.$(H): RenameInstanceVariableChange.st $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\CompositeRefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RefactoryChange.$(H) $(INCLUDE_TOP)\stx\goodies\refactoryBrowser\changes\RenameVariableChange.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_refactoryBrowser_changes.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
