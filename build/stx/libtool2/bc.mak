# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libtool2.
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
TOP=..
INCLUDE_TOP=$(TOP)\..


# see stdHeader_bc for LIBTOOL2_BASE
LIB_BASE=$(LIBTOOL2_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libtool2
MODULE_PATH=libtool2
RESFILES=libtool2.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\stx\libcomp -I$(INCLUDE_TOP)\stx\libhtml -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libui -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) $(COMMONSYMBOLS) -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)

clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)ColorEditDialog.$(O) ColorEditDialog.$(C) ColorEditDialog.$(H): ColorEditDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)DataSetBuilder.$(O) DataSetBuilder.$(C) DataSetBuilder.$(H): DataSetBuilder.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ResourceSpecEditor.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(STCHDR)
$(OUTDIR)DirectoryView.$(O) DirectoryView.$(C) DirectoryView.$(H): DirectoryView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)FlyByWindowInformation.$(O) FlyByWindowInformation.$(C) FlyByWindowInformation.$(H): FlyByWindowInformation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ActiveHelp.$(H) $(INCLUDE_TOP)\stx\libview2\EventListener.$(H) $(INCLUDE_TOP)\stx\libview2\FlyByHelp.$(H) $(STCHDR)
$(OUTDIR)ImageEditor.$(O) ImageEditor.$(C) ImageEditor.$(H): ImageEditor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ResourceSpecEditor.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(STCHDR)
$(OUTDIR)MenuEditor.$(O) MenuEditor.$(C) MenuEditor.$(H): MenuEditor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ResourceSpecEditor.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)MethodFinderWindow.$(O) MethodFinderWindow.$(C) MethodFinderWindow.$(H): MethodFinderWindow.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)SelectionBrowser.$(O) SelectionBrowser.$(C) SelectionBrowser.$(H): SelectionBrowser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)TabListEditor.$(O) TabListEditor.$(C) TabListEditor.$(H): TabListEditor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ResourceSpecEditor.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(STCHDR)
$(OUTDIR)Tools__ObjectModuleInformation.$(O) Tools__ObjectModuleInformation.$(C) Tools__ObjectModuleInformation.$(H): Tools__ObjectModuleInformation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(STCHDR)
$(OUTDIR)ProjectBuilder.$(O) ProjectBuilder.$(C) ProjectBuilder.$(H): ProjectBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Tools__ProjectBuilderAssistantApplication.$(O) Tools__ProjectBuilderAssistantApplication.$(C) Tools__ProjectBuilderAssistantApplication.$(H): Tools__ProjectBuilderAssistantApplication.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(INCLUDE_TOP)\stx\libwidg2\AssistantApplication.$(H) $(STCHDR)
$(OUTDIR)UIGalleryView.$(O) UIGalleryView.$(C) UIGalleryView.$(H): UIGalleryView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libview2\DropObject.$(H) $(INCLUDE_TOP)\stx\libwidg2\NoteBookView.$(H) $(STCHDR)
$(OUTDIR)UIHelpTool.$(O) UIHelpTool.$(C) UIHelpTool.$(H): UIHelpTool.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ResourceSpecEditor.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)UILayoutTool.$(O) UILayoutTool.$(C) UILayoutTool.$(H): UILayoutTool.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)UIListEditor.$(O) UIListEditor.$(C) UIListEditor.$(H): UIListEditor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)UIObjectView.$(O) UIObjectView.$(C) UIObjectView.$(H): UIObjectView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ObjectView.$(H) $(STCHDR)
$(OUTDIR)UIPainter.$(O) UIPainter.$(C) UIPainter.$(H): UIPainter.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ResourceSpecEditor.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInListView.$(H) $(INCLUDE_TOP)\stx\libwidg2\SelectionInTreeView.$(H) $(STCHDR)
$(OUTDIR)UISelectionPanel.$(O) UISelectionPanel.$(C) UISelectionPanel.$(H): UISelectionPanel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)UISpecificationTool.$(O) UISpecificationTool.$(C) UISpecificationTool.$(H): UISpecificationTool.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libwidg2\ViewScroller.$(H) $(STCHDR)
$(OUTDIR)stx_libtool2.$(O) stx_libtool2.$(C) stx_libtool2.$(H): stx_libtool2.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)FileSelectionBrowser.$(O) FileSelectionBrowser.$(C) FileSelectionBrowser.$(H): FileSelectionBrowser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool2\SelectionBrowser.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)ResourceSelectionBrowser.$(O) ResourceSelectionBrowser.$(C) ResourceSelectionBrowser.$(H): ResourceSelectionBrowser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool2\SelectionBrowser.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\SimpleDialog.$(H) $(STCHDR)
$(OUTDIR)UIPainterView.$(O) UIPainterView.$(C) UIPainterView.$(H): UIPainterView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libtool2\UIObjectView.$(H) $(INCLUDE_TOP)\stx\libview\DeviceGraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsContext.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ObjectView.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Image.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line
