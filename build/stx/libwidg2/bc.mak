# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libwidg2.
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


# see stdHeader_bc for LIBWIDG2_BASE
LIB_BASE=$(LIBWIDG2_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_libwidg2
MODULE_PATH=libwidg2
RESFILES=stx_libwidg2WINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\goodies\refactoryBrowser\browser -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libui -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg
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







test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)

clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)AbstractHierarchicalItem.$(O) AbstractHierarchicalItem.$(C) AbstractHierarchicalItem.$(H): AbstractHierarchicalItem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AssistantApplication.$(O) AssistantApplication.$(C) AssistantApplication.$(H): AssistantApplication.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libview2\ToolApplicationModel.$(H) $(STCHDR)
$(OUTDIR)CharacterSetView.$(O) CharacterSetView.$(C) CharacterSetView.$(H): CharacterSetView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)CheckBox.$(O) CheckBox.$(C) CheckBox.$(H): CheckBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\HorizontalPanelView.$(H) $(INCLUDE_TOP)\stx\libwidg\PanelView.$(H) $(STCHDR)
$(OUTDIR)ComboBoxButton.$(O) ComboBoxButton.$(C) ComboBoxButton.$(H): ComboBoxButton.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Button.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(INCLUDE_TOP)\stx\libwidg\Toggle.$(H) $(STCHDR)
$(OUTDIR)ComboView.$(O) ComboView.$(C) ComboView.$(H): ComboView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)DSVColumnView.$(O) DSVColumnView.$(C) DSVColumnView.$(H): DSVColumnView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)DSVLabelView.$(O) DSVLabelView.$(C) DSVLabelView.$(H): DSVLabelView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)DataSetColumn.$(O) DataSetColumn.$(C) DataSetColumn.$(H): DataSetColumn.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DataSetLabel.$(O) DataSetLabel.$(C) DataSetLabel.$(H): DataSetLabel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DataSetView.$(O) DataSetView.$(C) DataSetView.$(H): DataSetView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\ScrollableView.$(H) $(STCHDR)
$(OUTDIR)DoWhatIMeanSupport.$(O) DoWhatIMeanSupport.$(C) DoWhatIMeanSupport.$(H): DoWhatIMeanSupport.st $(INCLUDE_TOP)\stx\libbasic\Array.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)EnterBoxWithList.$(O) EnterBoxWithList.$(C) EnterBoxWithList.$(H): EnterBoxWithList.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\EnterBox.$(H) $(STCHDR)
$(OUTDIR)ExtendedComboBox.$(O) ExtendedComboBox.$(C) ExtendedComboBox.$(H): ExtendedComboBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\PopUpView.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)FilenameEditField.$(O) FilenameEditField.$(C) FilenameEditField.$(H): FilenameEditField.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\EditField.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(STCHDR)
$(OUTDIR)FilenameEnterBox.$(O) FilenameEnterBox.$(C) FilenameEnterBox.$(H): FilenameEnterBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\EnterBox.$(H) $(STCHDR)
$(OUTDIR)FilenameWidgetWithHistory.$(O) FilenameWidgetWithHistory.$(C) FilenameWidgetWithHistory.$(H): FilenameWidgetWithHistory.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)GridBagConstraints.$(O) GridBagConstraints.$(C) GridBagConstraints.$(H): GridBagConstraints.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GridBagLayoutInfo.$(O) GridBagLayoutInfo.$(C) GridBagLayoutInfo.$(H): GridBagLayoutInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GridBagLayoutView.$(O) GridBagLayoutView.$(C) GridBagLayoutView.$(H): GridBagLayoutView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\PanelView.$(H) $(STCHDR)
$(OUTDIR)HierarchicalDropTargetController.$(O) HierarchicalDropTargetController.$(C) HierarchicalDropTargetController.$(H): HierarchicalDropTargetController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)HierarchicalList.$(O) HierarchicalList.$(C) HierarchicalList.$(H): HierarchicalList.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic2\List.$(H) $(STCHDR)
$(OUTDIR)HierarchyNode.$(O) HierarchyNode.$(C) HierarchyNode.$(H): HierarchyNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ImageView.$(O) ImageView.$(C) ImageView.$(H): ImageView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)LabelledEnterField.$(O) LabelledEnterField.$(C) LabelledEnterField.$(H): LabelledEnterField.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)LinkButton.$(O) LinkButton.$(C) LinkButton.$(H): LinkButton.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Button.$(H) $(INCLUDE_TOP)\stx\libwidg\Label.$(H) $(STCHDR)
$(OUTDIR)LinkButtonController.$(O) LinkButtonController.$(C) LinkButtonController.$(H): LinkButtonController.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\Controller.$(H) $(INCLUDE_TOP)\stx\libwidg\ButtonController.$(H) $(STCHDR)
$(OUTDIR)ListEntry.$(O) ListEntry.$(C) ListEntry.$(H): ListEntry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ListModelView.$(O) ListModelView.$(C) ListModelView.$(H): ListModelView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)MenuPanel.$(O) MenuPanel.$(C) MenuPanel.$(H): MenuPanel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)MultipleItemSelectionWidget.$(O) MultipleItemSelectionWidget.$(C) MultipleItemSelectionWidget.$(H): MultipleItemSelectionWidget.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)NoteBookView.$(O) NoteBookView.$(C) NoteBookView.$(H): NoteBookView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)PrintAbortDialog.$(O) PrintAbortDialog.$(C) PrintAbortDialog.$(H): PrintAbortDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)PrintingDialog.$(O) PrintingDialog.$(C) PrintingDialog.$(H): PrintingDialog.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)ProgressIndicator.$(O) ProgressIndicator.$(C) ProgressIndicator.$(H): ProgressIndicator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ProgressNotification.$(O) ProgressNotification.$(C) ProgressNotification.$(H): ProgressNotification.st $(INCLUDE_TOP)\stx\libbasic\ActivityNotification.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\UserNotification.$(H) $(STCHDR)
$(OUTDIR)SelectionInHierarchy.$(O) SelectionInHierarchy.$(C) SelectionInHierarchy.$(H): SelectionInHierarchy.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)SelectionInTree.$(O) SelectionInTree.$(C) SelectionInTree.$(H): SelectionInTree.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)SelectionInTreeView.$(O) SelectionInTreeView.$(C) SelectionInTreeView.$(H): SelectionInTreeView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInListView.$(H) $(STCHDR)
$(OUTDIR)Separator.$(O) Separator.$(C) Separator.$(H): Separator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)Slider.$(O) Slider.$(C) Slider.$(H): Slider.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Scroller.$(H) $(STCHDR)
$(OUTDIR)SteppingSlider.$(O) SteppingSlider.$(C) SteppingSlider.$(H): SteppingSlider.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\ScrollBar.$(H) $(STCHDR)
$(OUTDIR)SubCanvas.$(O) SubCanvas.$(C) SubCanvas.$(H): SubCanvas.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\ScrollableView.$(H) $(STCHDR)
$(OUTDIR)SyncedMultiColumnTextView.$(O) SyncedMultiColumnTextView.$(C) SyncedMultiColumnTextView.$(H): SyncedMultiColumnTextView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)TabItem.$(O) TabItem.$(C) TabItem.$(H): TabItem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)TabSpecRuler.$(O) TabSpecRuler.$(C) TabSpecRuler.$(H): TabSpecRuler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)TabWidget.$(O) TabWidget.$(C) TabWidget.$(H): TabWidget.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TabulatorSpecification.$(O) TabulatorSpecification.$(C) TabulatorSpecification.$(H): TabulatorSpecification.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(STCHDR)
$(OUTDIR)TerminalView.$(O) TerminalView.$(C) TerminalView.$(H): TerminalView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextCollector.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(STCHDR)
$(OUTDIR)TextBox.$(O) TextBox.$(C) TextBox.$(H): TextBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(INCLUDE_TOP)\stx\libwidg\EnterBox.$(H) $(STCHDR)
$(OUTDIR)ThumbWheel.$(O) ThumbWheel.$(C) ThumbWheel.$(H): ThumbWheel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)TreeItem.$(O) TreeItem.$(C) TreeItem.$(H): TreeItem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)UpDownButton.$(O) UpDownButton.$(C) UpDownButton.$(H): UpDownButton.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(STCHDR)
$(OUTDIR)ViewScroller.$(O) ViewScroller.$(C) ViewScroller.$(H): ViewScroller.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(STCHDR)
$(OUTDIR)stx_libwidg2.$(O) stx_libwidg2.$(C) stx_libwidg2.$(H): stx_libwidg2.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)ColorMenu.$(O) ColorMenu.$(C) ColorMenu.$(H): ColorMenu.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\MenuPanel.$(H) $(STCHDR)
$(OUTDIR)ComboBoxView.$(O) ComboBoxView.$(C) ComboBoxView.$(H): ComboBoxView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\ComboView.$(H) $(STCHDR)
$(OUTDIR)ComboListView.$(O) ComboListView.$(C) ComboListView.$(H): ComboListView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\ComboView.$(H) $(STCHDR)
$(OUTDIR)CompactHierarchicalItem.$(O) CompactHierarchicalItem.$(C) CompactHierarchicalItem.$(H): CompactHierarchicalItem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)FileSelectionItem.$(O) FileSelectionItem.$(C) FileSelectionItem.$(H): FileSelectionItem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\TreeItem.$(H) $(STCHDR)
$(OUTDIR)FileSelectionTree.$(O) FileSelectionTree.$(C) FileSelectionTree.$(H): FileSelectionTree.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\SelectionInListView.$(H) $(INCLUDE_TOP)\stx\libwidg2\SelectionInTreeView.$(H) $(STCHDR)
$(OUTDIR)FilenameWidgetWithoutHistory.$(O) FilenameWidgetWithoutHistory.$(C) FilenameWidgetWithoutHistory.$(H): FilenameWidgetWithoutHistory.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg2\FilenameWidgetWithHistory.$(H) $(STCHDR)
$(OUTDIR)FontMenu.$(O) FontMenu.$(C) FontMenu.$(H): FontMenu.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\MenuPanel.$(H) $(STCHDR)
$(OUTDIR)HierarchicalItem.$(O) HierarchicalItem.$(C) HierarchicalItem.$(H): HierarchicalItem.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)HorizontalSlider.$(O) HorizontalSlider.$(C) HorizontalSlider.$(H): HorizontalSlider.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\Scroller.$(H) $(INCLUDE_TOP)\stx\libwidg2\Slider.$(H) $(STCHDR)
$(OUTDIR)HorizontalSteppingSlider.$(O) HorizontalSteppingSlider.$(C) HorizontalSteppingSlider.$(H): HorizontalSteppingSlider.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\ScrollBar.$(H) $(INCLUDE_TOP)\stx\libwidg2\SteppingSlider.$(H) $(STCHDR)
$(OUTDIR)ImageEditView.$(O) ImageEditView.$(C) ImageEditView.$(H): ImageEditView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\ImageView.$(H) $(STCHDR)
$(OUTDIR)ModelListEntry.$(O) ModelListEntry.$(C) ModelListEntry.$(H): ModelListEntry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\ListEntry.$(H) $(STCHDR)
$(OUTDIR)MultiColListEntry.$(O) MultiColListEntry.$(C) MultiColListEntry.$(H): MultiColListEntry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\ListEntry.$(H) $(STCHDR)
$(OUTDIR)SelectionInListModelView.$(O) SelectionInListModelView.$(C) SelectionInListModelView.$(H): SelectionInListModelView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\ListModelView.$(H) $(STCHDR)
$(OUTDIR)TabView.$(O) TabView.$(C) TabView.$(H): TabView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\NoteBookView.$(H) $(STCHDR)
$(OUTDIR)ThreeColumnTextView.$(O) ThreeColumnTextView.$(C) ThreeColumnTextView.$(H): ThreeColumnTextView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg2\SyncedMultiColumnTextView.$(H) $(STCHDR)
$(OUTDIR)TreeItemWithImage.$(O) TreeItemWithImage.$(C) TreeItemWithImage.$(H): TreeItemWithImage.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\TreeItem.$(H) $(STCHDR)
$(OUTDIR)TriggerBox.$(O) TriggerBox.$(C) TriggerBox.$(H): TriggerBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg\HorizontalPanelView.$(H) $(INCLUDE_TOP)\stx\libwidg\PanelView.$(H) $(INCLUDE_TOP)\stx\libwidg2\CheckBox.$(H) $(STCHDR)
$(OUTDIR)TwoColumnTextView.$(O) TwoColumnTextView.$(C) TwoColumnTextView.$(H): TwoColumnTextView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libwidg2\SyncedMultiColumnTextView.$(H) $(STCHDR)
$(OUTDIR)VT100TerminalView.$(O) VT100TerminalView.$(C) VT100TerminalView.$(H): VT100TerminalView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\EditTextView.$(H) $(INCLUDE_TOP)\stx\libwidg\ListView.$(H) $(INCLUDE_TOP)\stx\libwidg\TextCollector.$(H) $(INCLUDE_TOP)\stx\libwidg\TextView.$(H) $(INCLUDE_TOP)\stx\libwidg2\TerminalView.$(H) $(STCHDR)
$(OUTDIR)FilenameComboBoxView.$(O) FilenameComboBoxView.$(C) FilenameComboBoxView.$(H): FilenameComboBoxView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\ComboBoxView.$(H) $(INCLUDE_TOP)\stx\libwidg2\ComboView.$(H) $(STCHDR)
$(OUTDIR)HierarchicalFileList.$(O) HierarchicalFileList.$(C) HierarchicalFileList.$(H): HierarchicalFileList.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic2\List.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalList.$(H) $(STCHDR)
$(OUTDIR)HierarchicalItemWithLabel.$(O) HierarchicalItemWithLabel.$(C) HierarchicalItemWithLabel.$(H): HierarchicalItemWithLabel.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)HierarchicalItemWithValue.$(O) HierarchicalItemWithValue.$(C) HierarchicalItemWithValue.$(H): HierarchicalItemWithValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)HierarchicalListView.$(O) HierarchicalListView.$(C) HierarchicalListView.$(H): HierarchicalListView.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg2\ListModelView.$(H) $(INCLUDE_TOP)\stx\libwidg2\SelectionInListModelView.$(H) $(STCHDR)
$(OUTDIR)LabelAndIcon.$(O) LabelAndIcon.$(C) LabelAndIcon.$(H): LabelAndIcon.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\ListEntry.$(H) $(INCLUDE_TOP)\stx\libwidg2\ModelListEntry.$(H) $(STCHDR)
$(OUTDIR)HierarchicalItemWithLabelAndIcon.$(O) HierarchicalItemWithLabelAndIcon.$(C) HierarchicalItemWithLabelAndIcon.$(H): HierarchicalItemWithLabelAndIcon.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItemWithLabel.$(H) $(STCHDR)
$(OUTDIR)LabelAndTwoIcons.$(O) LabelAndTwoIcons.$(C) LabelAndTwoIcons.$(H): LabelAndTwoIcons.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\LabelAndIcon.$(H) $(INCLUDE_TOP)\stx\libwidg2\ListEntry.$(H) $(INCLUDE_TOP)\stx\libwidg2\ModelListEntry.$(H) $(STCHDR)
$(OUTDIR)HierarchicalItemWithLabelAndIconAndValue.$(O) HierarchicalItemWithLabelAndIconAndValue.$(C) HierarchicalItemWithLabelAndIconAndValue.$(H): HierarchicalItemWithLabelAndIconAndValue.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItemWithLabel.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItemWithLabelAndIcon.$(H) $(STCHDR)
$(OUTDIR)LicenceBox.$(O) LicenceBox.$(C) LicenceBox.$(H): LicenceBox.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview\DisplaySurface.$(H) $(INCLUDE_TOP)\stx\libview\GraphicsMedium.$(H) $(INCLUDE_TOP)\stx\libview\ModalBox.$(H) $(INCLUDE_TOP)\stx\libview\SimpleView.$(H) $(INCLUDE_TOP)\stx\libview\StandardSystemView.$(H) $(INCLUDE_TOP)\stx\libview\TopView.$(H) $(INCLUDE_TOP)\stx\libview\View.$(H) $(INCLUDE_TOP)\stx\libwidg\DialogBox.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_libwidg2.$(O): $(HGROOT)\.hg\dirstate
!ENDIF
