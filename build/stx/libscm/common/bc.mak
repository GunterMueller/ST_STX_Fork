# Hack to make it compilable under Smalltalk/X 6.2.2 (which does not have RES variable defined)
!ifndef RES
RES=res
!endif

# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libscm_common.
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

LIBNAME=libstx_libscm_common
MODULE_PATH=libscm\common
RESFILES=common.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\stx\libjava -I$(INCLUDE_TOP)\stx\libscm\mercurial -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libwidg2
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
	pushd ..\..\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)SCMAbstractDialog.$(O) SCMAbstractDialog.$(H): SCMAbstractDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractPackageModel.$(O) SCMAbstractPackageModel.$(H): SCMAbstractPackageModel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractPackageWorkingCopyRegistry.$(O) SCMAbstractPackageWorkingCopyRegistry.$(H): SCMAbstractPackageWorkingCopyRegistry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractRevisionInfo.$(O) SCMAbstractRevisionInfo.$(H): SCMAbstractRevisionInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractSourceCodeManager.$(O) SCMAbstractSourceCodeManager.$(H): SCMAbstractSourceCodeManager.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\AbstractSourceCodeManager.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractTask.$(O) SCMAbstractTask.$(H): SCMAbstractTask.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SCMCodeMonitor.$(O) SCMCodeMonitor.$(H): SCMCodeMonitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SCMCommonPackageModelGroup.$(O) SCMCommonPackageModelGroup.$(H): SCMCommonPackageModelGroup.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SCMCommonSourceCodeManagerUtilities.$(O) SCMCommonSourceCodeManagerUtilities.$(H): SCMCommonSourceCodeManagerUtilities.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic3\SourceCodeManagerUtilities.$(H) $(STCHDR)
$(OUTDIR)SCMCompatModeQuery.$(O) SCMCompatModeQuery.$(H): SCMCompatModeQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)SCMError.$(O) SCMError.$(H): SCMError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SCMWarning.$(O) SCMWarning.$(H): SCMWarning.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_libscm_common.$(O) stx_libscm_common.$(H): stx_libscm_common.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractCommitDialog.$(O) SCMAbstractCommitDialog.$(H): SCMAbstractCommitDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractDialog.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractFileoutLikeTask.$(O) SCMAbstractFileoutLikeTask.$(H): SCMAbstractFileoutLikeTask.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractTask.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractPackageRevision.$(O) SCMAbstractPackageRevision.$(H): SCMAbstractPackageRevision.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageModel.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractPackageWorkingCopy.$(O) SCMAbstractPackageWorkingCopy.$(H): SCMAbstractPackageWorkingCopy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractPackageModel.$(H) $(STCHDR)
$(OUTDIR)SCMPackageModelError.$(O) SCMPackageModelError.$(H): SCMPackageModelError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMError.$(H) $(STCHDR)
$(OUTDIR)SCMPackageModelWarning.$(O) SCMPackageModelWarning.$(H): SCMPackageModelWarning.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMWarning.$(H) $(STCHDR)
$(OUTDIR)SCMAbstractCommitTask.$(O) SCMAbstractCommitTask.$(H): SCMAbstractCommitTask.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractFileoutLikeTask.$(H) $(INCLUDE_TOP)\stx\libscm\common\SCMAbstractTask.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic3\ChangeSet.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libscm_common.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
