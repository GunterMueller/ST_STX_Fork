# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: jv_vdb.
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
TOP=..\..\stx
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libjv_vdb
MODULE_PATH=vdb
RESFILES=jv_vdbWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\jv\libgdbs -I$(INCLUDE_TOP)\stx\goodies\announcements -I$(INCLUDE_TOP)\stx\goodies\xml\vw -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libtool2 -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\stx\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\goodies\announcements & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\goodies\refactoryBrowser\parser & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libbasic3 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libcomp & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libui & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\goodies\magritte & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libgdbs & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\stx\libtool & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)RR.$(O) RR.$(C) RR.$(H): RR.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RREvent.$(O) RREvent.$(C) RREvent.$(H): RREvent.st $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VDBAbstractApplication.$(O) VDBAbstractApplication.$(C) VDBAbstractApplication.$(H): VDBAbstractApplication.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBAbstractPresenter.$(O) VDBAbstractPresenter.$(C) VDBAbstractPresenter.$(H): VDBAbstractPresenter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)VDBEvaluator.$(O) VDBEvaluator.$(C) VDBEvaluator.$(H): VDBEvaluator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VDBIconLibrary.$(O) VDBIconLibrary.$(C) VDBIconLibrary.$(H): VDBIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VDBInstructionBasicBlock.$(O) VDBInstructionBasicBlock.$(C) VDBInstructionBasicBlock.$(H): VDBInstructionBasicBlock.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VDBSettingsApplication.$(O) VDBSettingsApplication.$(C) VDBSettingsApplication.$(H): VDBSettingsApplication.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool\AbstractSettingsApplication.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBVirtualMemoryMap.$(O) VDBVirtualMemoryMap.$(C) VDBVirtualMemoryMap.$(H): VDBVirtualMemoryMap.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VDBVirtualMemoryRegion.$(O) VDBVirtualMemoryRegion.$(C) VDBVirtualMemoryRegion.$(H): VDBVirtualMemoryRegion.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VDBWindowsDebuggerConsoleView.$(O) VDBWindowsDebuggerConsoleView.$(C) VDBWindowsDebuggerConsoleView.$(H): VDBWindowsDebuggerConsoleView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextCollector.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(INCLUDE_TOP)\stx\libwidg2\TerminalView.$(H) $(STCHDR)
$(OUTDIR)jv_vdb.$(O) jv_vdb.$(C) jv_vdb.$(H): jv_vdb.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)RRExitEvent.$(O) RRExitEvent.$(C) RRExitEvent.$(H): RRExitEvent.st $(INCLUDE_TOP)\jv\vdb\RREvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RRStartEvent.$(O) RRStartEvent.$(C) RRStartEvent.$(H): RRStartEvent.st $(INCLUDE_TOP)\jv\vdb\RREvent.$(H) $(INCLUDE_TOP)\stx\goodies\announcements\Announcement.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)VDBAbstractContainer.$(O) VDBAbstractContainer.$(C) VDBAbstractContainer.$(H): VDBAbstractContainer.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBAbstractListApplication.$(O) VDBAbstractListApplication.$(C) VDBAbstractListApplication.$(H): VDBAbstractListApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBAbstractUnixConsoleApplication.$(O) VDBAbstractUnixConsoleApplication.$(C) VDBAbstractUnixConsoleApplication.$(H): VDBAbstractUnixConsoleApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBBreakpointApplication.$(O) VDBBreakpointApplication.$(C) VDBBreakpointApplication.$(H): VDBBreakpointApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBBreakpointPresenter.$(O) VDBBreakpointPresenter.$(C) VDBBreakpointPresenter.$(H): VDBBreakpointPresenter.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)VDBDebuggerApplication.$(O) VDBDebuggerApplication.$(C) VDBDebuggerApplication.$(H): VDBDebuggerApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBEventLogApplication.$(O) VDBEventLogApplication.$(C) VDBEventLogApplication.$(H): VDBEventLogApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBFrameApplication.$(O) VDBFrameApplication.$(C) VDBFrameApplication.$(H): VDBFrameApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBFramePresenter.$(O) VDBFramePresenter.$(C) VDBFramePresenter.$(H): VDBFramePresenter.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)VDBInstructionPresenter.$(O) VDBInstructionPresenter.$(C) VDBInstructionPresenter.$(H): VDBInstructionPresenter.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)VDBInstructionsAndSourcePresenter.$(O) VDBInstructionsAndSourcePresenter.$(C) VDBInstructionsAndSourcePresenter.$(H): VDBInstructionsAndSourcePresenter.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)VDBMemoryApplication.$(O) VDBMemoryApplication.$(C) VDBMemoryApplication.$(H): VDBMemoryApplication.st $(INCLUDE_TOP)\jv\libgdbs\GDBOutputFormats.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBSourceApplication.$(O) VDBSourceApplication.$(C) VDBSourceApplication.$(H): VDBSourceApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBThreadGroupPresenter.$(O) VDBThreadGroupPresenter.$(C) VDBThreadGroupPresenter.$(H): VDBThreadGroupPresenter.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)VDBThreadPresenter.$(O) VDBThreadPresenter.$(C) VDBThreadPresenter.$(H): VDBThreadPresenter.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)VDBVariableObjectPresenter.$(O) VDBVariableObjectPresenter.$(C) VDBVariableObjectPresenter.$(H): VDBVariableObjectPresenter.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractPresenter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)VDBWindowsDebuggerConsoleApplication.$(O) VDBWindowsDebuggerConsoleApplication.$(C) VDBWindowsDebuggerConsoleApplication.$(H): VDBWindowsDebuggerConsoleApplication.st $(INCLUDE_TOP)\jv\libgdbs\GDBCommandStatus.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBAbstractTreeApplication.$(O) VDBAbstractTreeApplication.$(C) VDBAbstractTreeApplication.$(H): VDBAbstractTreeApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractListApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBBreakpointListApplication.$(O) VDBBreakpointListApplication.$(C) VDBBreakpointListApplication.$(H): VDBBreakpointListApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractListApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBTabbingContainer.$(O) VDBTabbingContainer.$(C) VDBTabbingContainer.$(H): VDBTabbingContainer.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractContainer.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBUnixDebuggerConsoleApplication.$(O) VDBUnixDebuggerConsoleApplication.$(C) VDBUnixDebuggerConsoleApplication.$(H): VDBUnixDebuggerConsoleApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractUnixConsoleApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBUnixInferiorConsoleApplication.$(O) VDBUnixInferiorConsoleApplication.$(C) VDBUnixInferiorConsoleApplication.$(H): VDBUnixInferiorConsoleApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractUnixConsoleApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBUnixReplayServerConsoleApplication.$(O) VDBUnixReplayServerConsoleApplication.$(C) VDBUnixReplayServerConsoleApplication.$(H): VDBUnixReplayServerConsoleApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractUnixConsoleApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBInstructionListApplication.$(O) VDBInstructionListApplication.$(C) VDBInstructionListApplication.$(H): VDBInstructionListApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractListApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractTreeApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBStackApplication.$(O) VDBStackApplication.$(C) VDBStackApplication.$(H): VDBStackApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractListApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractTreeApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)VDBVariableObjectListApplication.$(O) VDBVariableObjectListApplication.$(C) VDBVariableObjectListApplication.$(H): VDBVariableObjectListApplication.st $(INCLUDE_TOP)\jv\vdb\VDBAbstractApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractListApplication.$(H) $(INCLUDE_TOP)\jv\vdb\VDBAbstractTreeApplication.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\jv\libgdbs\GDBDebugger.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBDebuggerObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBObject.$(H) $(INCLUDE_TOP)\jv\libgdbs\GDBVariableObject.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\UserPreferences.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)jv_vdb.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
