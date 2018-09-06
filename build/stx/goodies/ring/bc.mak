# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_ring.
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

LIBNAME=libstx_goodies_ring
MODULE_PATH=goodies\ring
RESFILES=ring.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\parser -I$(INCLUDE_TOP)\stx\libbasic
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







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)RGDefinition.$(O) RGDefinition.$(H): RGDefinition.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_ring.$(O) stx_goodies_ring.$(H): stx_goodies_ring.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)RGAbstractContainer.$(O) RGAbstractContainer.$(H): RGAbstractContainer.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGElementDefinition.$(O) RGElementDefinition.$(H): RGElementDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGGlobalDefinition.$(O) RGGlobalDefinition.$(H): RGGlobalDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGBehaviorDefinition.$(O) RGBehaviorDefinition.$(H): RGBehaviorDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGGlobalDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGCommentDefinition.$(O) RGCommentDefinition.$(H): RGCommentDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGElementDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGContainer.$(O) RGContainer.$(H): RGContainer.st $(INCLUDE_TOP)\stx\goodies\ring\RGAbstractContainer.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGGlobalVariableDefinition.$(O) RGGlobalVariableDefinition.$(H): RGGlobalVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGGlobalDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGMethodDefinition.$(O) RGMethodDefinition.$(H): RGMethodDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGElementDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGOrganization.$(O) RGOrganization.$(H): RGOrganization.st $(INCLUDE_TOP)\stx\goodies\ring\RGAbstractContainer.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGVariableDefinition.$(O) RGVariableDefinition.$(H): RGVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGElementDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGClassDescriptionDefinition.$(O) RGClassDescriptionDefinition.$(H): RGClassDescriptionDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGBehaviorDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGGlobalDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGClassInstanceVariableDefinition.$(O) RGClassInstanceVariableDefinition.$(H): RGClassInstanceVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGElementDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGVariableDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGClassVariableDefinition.$(O) RGClassVariableDefinition.$(H): RGClassVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGElementDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGVariableDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGInstanceVariableDefinition.$(O) RGInstanceVariableDefinition.$(H): RGInstanceVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGElementDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGVariableDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGNamespace.$(O) RGNamespace.$(H): RGNamespace.st $(INCLUDE_TOP)\stx\goodies\ring\RGAbstractContainer.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGContainer.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGPackage.$(O) RGPackage.$(H): RGPackage.st $(INCLUDE_TOP)\stx\goodies\ring\RGAbstractContainer.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGContainer.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGPoolVariableDefinition.$(O) RGPoolVariableDefinition.$(H): RGPoolVariableDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGElementDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGVariableDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGSlice.$(O) RGSlice.$(H): RGSlice.st $(INCLUDE_TOP)\stx\goodies\ring\RGAbstractContainer.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGContainer.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGTraitDescriptionDefinition.$(O) RGTraitDescriptionDefinition.$(H): RGTraitDescriptionDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGBehaviorDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGGlobalDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGClassDefinition.$(O) RGClassDefinition.$(H): RGClassDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGBehaviorDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGClassDescriptionDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGGlobalDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGMetaclassDefinition.$(O) RGMetaclassDefinition.$(H): RGMetaclassDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGBehaviorDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGClassDescriptionDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGGlobalDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGMetatraitDefinition.$(O) RGMetatraitDefinition.$(H): RGMetatraitDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGBehaviorDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGGlobalDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGTraitDescriptionDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RGTraitDefinition.$(O) RGTraitDefinition.$(H): RGTraitDefinition.st $(INCLUDE_TOP)\stx\goodies\ring\RGBehaviorDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGGlobalDefinition.$(H) $(INCLUDE_TOP)\stx\goodies\ring\RGTraitDescriptionDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Behavior.$(H) $(INCLUDE_TOP)\stx\libbasic\Class.$(H) $(INCLUDE_TOP)\stx\libbasic\ClassDescription.$(H) $(INCLUDE_TOP)\stx\libbasic\CompiledCode.$(H) $(INCLUDE_TOP)\stx\libbasic\ExecutableFunction.$(H) $(INCLUDE_TOP)\stx\libbasic\Method.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_ring.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
