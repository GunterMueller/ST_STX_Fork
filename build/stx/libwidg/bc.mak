# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libwidg.
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


# see stdHeader_bc for LIBWIDG_BASE
LIB_BASE=$(LIBWIDG_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libwidg
MODULE_PATH=libwidg
RESFILES=stx_libwidgWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\regex -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\stx\libui -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2
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







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)ButtonController.$(O) ButtonController.$(C) ButtonController.$(H): ButtonController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(STCHDR)
$(OUTDIR)CodeViewTheme.$(O) CodeViewTheme.$(C) CodeViewTheme.$(H): CodeViewTheme.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DialogBox.$(O) DialogBox.$(C) DialogBox.$(H): DialogBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)EditTextViewCompletionSupport.$(O) EditTextViewCompletionSupport.$(C) EditTextViewCompletionSupport.$(H): EditTextViewCompletionSupport.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)EnterFieldGroup.$(O) EnterFieldGroup.$(C) EnterFieldGroup.$(H): EnterFieldGroup.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)FramedBox.$(O) FramedBox.$(C) FramedBox.$(H): FramedBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)GenericToolbarIconLibrary.$(O) GenericToolbarIconLibrary.$(C) GenericToolbarIconLibrary.$(H): GenericToolbarIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Label.$(O) Label.$(C) Label.$(H): Label.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ListView.$(O) ListView.$(C) ListView.$(H): ListView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ListViewController.$(O) ListViewController.$(C) ListViewController.$(H): ListViewController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(STCHDR)
$(OUTDIR)MenuEvent.$(O) MenuEvent.$(C) MenuEvent.$(H): MenuEvent.st $(INCLUDE_TOP)\stx\libbasic\Message.$(H) $(INCLUDE_TOP)\stx\libbasic\MessageSend.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Event.$(H) $(INCLUDE_TOP)\stx\libview\WidgetEvent.$(H) $(INCLUDE_TOP)\stx\libview\WindowEvent.$(H) $(STCHDR)
$(OUTDIR)ObjectView.$(O) ObjectView.$(C) ObjectView.$(H): ObjectView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)PanelView.$(O) PanelView.$(C) PanelView.$(H): PanelView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)PopUpMenu.$(O) PopUpMenu.$(C) PopUpMenu.$(H): PopUpMenu.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\PopUpView.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)PullDownMenu.$(O) PullDownMenu.$(C) PullDownMenu.$(H): PullDownMenu.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)RadioButtonGroup.$(O) RadioButtonGroup.$(C) RadioButtonGroup.$(H): RadioButtonGroup.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)ScrollBar.$(O) ScrollBar.$(C) ScrollBar.$(H): ScrollBar.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)ScrollableView.$(O) ScrollableView.$(C) ScrollableView.$(H): ScrollableView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)Scroller.$(O) Scroller.$(C) Scroller.$(H): Scroller.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)SelectionInList.$(O) SelectionInList.$(C) SelectionInList.$(H): SelectionInList.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(STCHDR)
$(OUTDIR)VariablePanel.$(O) VariablePanel.$(C) VariablePanel.$(H): VariablePanel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)VariablePanelController.$(O) VariablePanelController.$(C) VariablePanelController.$(H): VariablePanelController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(STCHDR)
$(OUTDIR)stx_libwidg.$(O) stx_libwidg.$(C) stx_libwidg.$(H): stx_libwidg.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Button.$(O) Button.$(C) Button.$(H): Button.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(STCHDR)
$(OUTDIR)CheckLabel.$(O) CheckLabel.$(C) CheckLabel.$(H): CheckLabel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(STCHDR)
$(OUTDIR)DragRectangleController.$(O) DragRectangleController.$(C) DragRectangleController.$(H): DragRectangleController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(INCLUDE_TOP)\stx\libwidg\ButtonController.$(H) $(STCHDR)
$(OUTDIR)EnterBox.$(O) EnterBox.$(C) EnterBox.$(H): EnterBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(STCHDR)
$(OUTDIR)FontPanel.$(O) FontPanel.$(C) FontPanel.$(H): FontPanel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(STCHDR)
$(OUTDIR)HVScrollableView.$(O) HVScrollableView.$(C) HVScrollableView.$(H): HVScrollableView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\ScrollableView.$(H) $(STCHDR)
$(OUTDIR)HorizontalPanelView.$(O) HorizontalPanelView.$(C) HorizontalPanelView.$(H): HorizontalPanelView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\PanelView.$(H) $(STCHDR)
$(OUTDIR)HorizontalScrollBar.$(O) HorizontalScrollBar.$(C) HorizontalScrollBar.$(H): HorizontalScrollBar.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\ScrollBar.$(H) $(STCHDR)
$(OUTDIR)HorizontalScroller.$(O) HorizontalScroller.$(C) HorizontalScroller.$(H): HorizontalScroller.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Scroller.$(H) $(STCHDR)
$(OUTDIR)InfoBox.$(O) InfoBox.$(C) InfoBox.$(H): InfoBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(STCHDR)
$(OUTDIR)MiniScroller.$(O) MiniScroller.$(C) MiniScroller.$(H): MiniScroller.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Scroller.$(H) $(STCHDR)
$(OUTDIR)MultiColumnPanelView.$(O) MultiColumnPanelView.$(C) MultiColumnPanelView.$(H): MultiColumnPanelView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\PanelView.$(H) $(STCHDR)
$(OUTDIR)MultiSelectionInList.$(O) MultiSelectionInList.$(C) MultiSelectionInList.$(H): MultiSelectionInList.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ValueHolder.$(H) $(INCLUDE_TOP)\stx\libview2\ValueModel.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInList.$(H) $(STCHDR)
$(OUTDIR)OptionBox.$(O) OptionBox.$(C) OptionBox.$(H): OptionBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(STCHDR)
$(OUTDIR)PopUpListController.$(O) PopUpListController.$(C) PopUpListController.$(H): PopUpListController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(INCLUDE_TOP)\stx\libwidg\ButtonController.$(H) $(STCHDR)
$(OUTDIR)SelectionInListView.$(O) SelectionInListView.$(C) SelectionInListView.$(H): SelectionInListView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(STCHDR)
$(OUTDIR)SequenceView.$(O) SequenceView.$(C) SequenceView.$(H): SequenceView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\ScrollableView.$(H) $(STCHDR)
$(OUTDIR)TextView.$(O) TextView.$(C) TextView.$(H): TextView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(STCHDR)
$(OUTDIR)ToggleController.$(O) ToggleController.$(C) ToggleController.$(H): ToggleController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(INCLUDE_TOP)\stx\libwidg\ButtonController.$(H) $(STCHDR)
$(OUTDIR)VariableHorizontalPanel.$(O) VariableHorizontalPanel.$(C) VariableHorizontalPanel.$(H): VariableHorizontalPanel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\VariablePanel.$(H) $(STCHDR)
$(OUTDIR)VariableHorizontalPanelController.$(O) VariableHorizontalPanelController.$(C) VariableHorizontalPanelController.$(H): VariableHorizontalPanelController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(INCLUDE_TOP)\stx\libwidg\VariablePanelController.$(H) $(STCHDR)
$(OUTDIR)VariableVerticalPanel.$(O) VariableVerticalPanel.$(C) VariableVerticalPanel.$(H): VariableVerticalPanel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\VariablePanel.$(H) $(STCHDR)
$(OUTDIR)VariableVerticalPanelController.$(O) VariableVerticalPanelController.$(C) VariableVerticalPanelController.$(H): VariableVerticalPanelController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(INCLUDE_TOP)\stx\libwidg\VariablePanelController.$(H) $(STCHDR)
$(OUTDIR)VerticalPanelView.$(O) VerticalPanelView.$(C) VerticalPanelView.$(H): VerticalPanelView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\PanelView.$(H) $(STCHDR)
$(OUTDIR)WorkspaceCompletionSupport.$(O) WorkspaceCompletionSupport.$(C) WorkspaceCompletionSupport.$(H): WorkspaceCompletionSupport.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextViewCompletionSupport.$(H) $(STCHDR)
$(OUTDIR)XPToolbarIconLibrary.$(O) XPToolbarIconLibrary.$(C) XPToolbarIconLibrary.$(H): XPToolbarIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg\GenericToolbarIconLibrary.$(H) $(STCHDR)
$(OUTDIR)ArrowButton.$(O) ArrowButton.$(C) ArrowButton.$(H): ArrowButton.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Button.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(STCHDR)
$(OUTDIR)EditTextView.$(O) EditTextView.$(C) EditTextView.$(H): EditTextView.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(STCHDR)
$(OUTDIR)EnterBox2.$(O) EnterBox2.$(C) EnterBox2.$(H): EnterBox2.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\EnterBox.$(H) $(STCHDR)
$(OUTDIR)FileSelectionList.$(O) FileSelectionList.$(C) FileSelectionList.$(H): FileSelectionList.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInListView.$(H) $(STCHDR)
$(OUTDIR)HorizontalMiniScroller.$(O) HorizontalMiniScroller.$(C) HorizontalMiniScroller.$(H): HorizontalMiniScroller.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\MiniScroller.$(H) $(INCLUDE_TOP)\stx\libwidg\Scroller.$(H) $(STCHDR)
$(OUTDIR)ListSelectionBox.$(O) ListSelectionBox.$(C) ListSelectionBox.$(H): ListSelectionBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\EnterBox.$(H) $(STCHDR)
$(OUTDIR)MacOSXToolbarIconLibrary.$(O) MacOSXToolbarIconLibrary.$(C) MacOSXToolbarIconLibrary.$(H): MacOSXToolbarIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg\GenericToolbarIconLibrary.$(H) $(INCLUDE_TOP)\stx\libwidg\XPToolbarIconLibrary.$(H) $(STCHDR)
$(OUTDIR)MenuView.$(O) MenuView.$(C) MenuView.$(H): MenuView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInListView.$(H) $(STCHDR)
$(OUTDIR)PopUpList.$(O) PopUpList.$(C) PopUpList.$(H): PopUpList.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Button.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(STCHDR)
$(OUTDIR)RadioButtonController.$(O) RadioButtonController.$(C) RadioButtonController.$(H): RadioButtonController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(INCLUDE_TOP)\stx\libwidg\ButtonController.$(H) $(INCLUDE_TOP)\stx\libwidg\ToggleController.$(H) $(STCHDR)
$(OUTDIR)Toggle.$(O) Toggle.$(C) Toggle.$(H): Toggle.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Button.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(STCHDR)
$(OUTDIR)VistaToolbarIconLibrary.$(O) VistaToolbarIconLibrary.$(C) VistaToolbarIconLibrary.$(H): VistaToolbarIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg\GenericToolbarIconLibrary.$(H) $(INCLUDE_TOP)\stx\libwidg\XPToolbarIconLibrary.$(H) $(STCHDR)
$(OUTDIR)WarningBox.$(O) WarningBox.$(C) WarningBox.$(H): WarningBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\InfoBox.$(H) $(STCHDR)
$(OUTDIR)AdwaitaToolbarIconLibrary.$(O) AdwaitaToolbarIconLibrary.$(C) AdwaitaToolbarIconLibrary.$(H): AdwaitaToolbarIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg\GenericToolbarIconLibrary.$(H) $(INCLUDE_TOP)\stx\libwidg\VistaToolbarIconLibrary.$(H) $(INCLUDE_TOP)\stx\libwidg\XPToolbarIconLibrary.$(H) $(STCHDR)
$(OUTDIR)CheckToggle.$(O) CheckToggle.$(C) CheckToggle.$(H): CheckToggle.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Button.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(INCLUDE_TOP)\stx\libwidg\Toggle.$(H) $(STCHDR)
$(OUTDIR)ClickMenuView.$(O) ClickMenuView.$(C) ClickMenuView.$(H): ClickMenuView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\MenuView.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInListView.$(H) $(STCHDR)
$(OUTDIR)EditField.$(O) EditField.$(C) EditField.$(H): EditField.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(STCHDR)
$(OUTDIR)FileSelectionBox.$(O) FileSelectionBox.$(C) FileSelectionBox.$(H): FileSelectionBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\EnterBox.$(H) $(INCLUDE_TOP)\stx\libwidg\ListSelectionBox.$(H) $(STCHDR)
$(OUTDIR)MacOSX2ToolbarIconLibrary.$(O) MacOSX2ToolbarIconLibrary.$(C) MacOSX2ToolbarIconLibrary.$(H): MacOSX2ToolbarIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg\GenericToolbarIconLibrary.$(H) $(INCLUDE_TOP)\stx\libwidg\MacOSXToolbarIconLibrary.$(H) $(INCLUDE_TOP)\stx\libwidg\XPToolbarIconLibrary.$(H) $(STCHDR)
$(OUTDIR)RadioButton.$(O) RadioButton.$(C) RadioButton.$(H): RadioButton.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Button.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(INCLUDE_TOP)\stx\libwidg\Toggle.$(H) $(STCHDR)
$(OUTDIR)TextCollector.$(O) TextCollector.$(C) TextCollector.$(H): TextCollector.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(STCHDR)
$(OUTDIR)Windows8ToolbarIconLibrary.$(O) Windows8ToolbarIconLibrary.$(C) Windows8ToolbarIconLibrary.$(H): Windows8ToolbarIconLibrary.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg\GenericToolbarIconLibrary.$(H) $(INCLUDE_TOP)\stx\libwidg\VistaToolbarIconLibrary.$(H) $(INCLUDE_TOP)\stx\libwidg\XPToolbarIconLibrary.$(H) $(STCHDR)
$(OUTDIR)YesNoBox.$(O) YesNoBox.$(C) YesNoBox.$(H): YesNoBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\InfoBox.$(H) $(INCLUDE_TOP)\stx\libwidg\WarningBox.$(H) $(STCHDR)
$(OUTDIR)FileSaveBox.$(O) FileSaveBox.$(C) FileSaveBox.$(H): FileSaveBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\EnterBox.$(H) $(INCLUDE_TOP)\stx\libwidg\FileSelectionBox.$(H) $(INCLUDE_TOP)\stx\libwidg\ListSelectionBox.$(H) $(STCHDR)
$(OUTDIR)Workspace.$(O) Workspace.$(C) Workspace.$(H): Workspace.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextCollector.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(STCHDR)
$(OUTDIR)CodeView.$(O) CodeView.$(C) CodeView.$(H): CodeView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextCollector.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(INCLUDE_TOP)\stx\libwidg\Workspace.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Dictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\IdentityDictionary.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Set.$(H) $(INCLUDE_TOP)\stx\libbasic\UserPreferences.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libwidg.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
