# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libwidg2.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=libwidg2
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard -warnUnused

COMMON_CLASSES= \
	AbstractHierarchicalItem \
	AssistantApplication \
	CharacterSetView \
	CheckBox \
	ComboBoxButton \
	ComboView \
	DSVColumnView \
	DSVLabelView \
	DataSetColumn \
	DataSetLabel \
	DataSetView \
	DoWhatIMeanSupport \
	EnterBoxWithList \
	ExtendedComboBox \
	FilenameEditField \
	FilenameEnterBox \
	FilenameWidgetWithHistory \
	GridBagConstraints \
	GridBagLayoutInfo \
	GridBagLayoutView \
	HierarchicalDropTargetController \
	HierarchicalList \
	HierarchyNode \
	ImageView \
	LabelledEnterField \
	LicenceBox \
	LinkButton \
	LinkButtonController \
	ListEntry \
	ListModelView \
	MenuPanel \
	MultipleItemSelectionWidget \
	NoteBookView \
	PrintAbortDialog \
	PrintingDialog \
	ProgressIndicator \
	ProgressNotification \
	SelectionInHierarchy \
	SelectionInTree \
	SelectionInTreeView \
	Separator \
	Slider \
	SteppingSlider \
	SubCanvas \
	SyncedMultiColumnTextView \
	TabItem \
	TabSpecRuler \
	TabWidget \
	TabulatorSpecification \
	TerminalView \
	TextBox \
	ThumbWheel \
	TreeItem \
	UpDownButton \
	ViewScroller \
	stx_libwidg2 \
	ColorMenu \
	ComboBoxView \
	ComboListView \
	CompactHierarchicalItem \
	FileSelectionItem \
	FileSelectionTree \
	FilenameWidgetWithoutHistory \
	FontMenu \
	HierarchicalItem \
	HorizontalSlider \
	HorizontalSteppingSlider \
	ImageEditView \
	ModelListEntry \
	MultiColListEntry \
	PluggableHierarchicalList \
	SelectionInListModelView \
	TabView \
	ThreeColumnTextView \
	TreeItemWithImage \
	TriggerBox \
	TwoColumnTextView \
	VT100TerminalView \
	FilenameComboBoxView \
	HierarchicalFileList \
	HierarchicalItemWithLabel \
	HierarchicalItemWithValue \
	HierarchicalListView \
	LabelAndIcon \
	HierarchicalItemWithLabelAndIcon \
	LabelAndTwoIcons \
	HierarchicalItemWithLabelAndIconAndValue \




COMMON_OBJS= \
    $(OUTDIR_SLASH)AbstractHierarchicalItem.$(O) \
    $(OUTDIR_SLASH)AssistantApplication.$(O) \
    $(OUTDIR_SLASH)CharacterSetView.$(O) \
    $(OUTDIR_SLASH)CheckBox.$(O) \
    $(OUTDIR_SLASH)ComboBoxButton.$(O) \
    $(OUTDIR_SLASH)ComboView.$(O) \
    $(OUTDIR_SLASH)DSVColumnView.$(O) \
    $(OUTDIR_SLASH)DSVLabelView.$(O) \
    $(OUTDIR_SLASH)DataSetColumn.$(O) \
    $(OUTDIR_SLASH)DataSetLabel.$(O) \
    $(OUTDIR_SLASH)DataSetView.$(O) \
    $(OUTDIR_SLASH)DoWhatIMeanSupport.$(O) \
    $(OUTDIR_SLASH)EnterBoxWithList.$(O) \
    $(OUTDIR_SLASH)ExtendedComboBox.$(O) \
    $(OUTDIR_SLASH)FilenameEditField.$(O) \
    $(OUTDIR_SLASH)FilenameEnterBox.$(O) \
    $(OUTDIR_SLASH)FilenameWidgetWithHistory.$(O) \
    $(OUTDIR_SLASH)GridBagConstraints.$(O) \
    $(OUTDIR_SLASH)GridBagLayoutInfo.$(O) \
    $(OUTDIR_SLASH)GridBagLayoutView.$(O) \
    $(OUTDIR_SLASH)HierarchicalDropTargetController.$(O) \
    $(OUTDIR_SLASH)HierarchicalList.$(O) \
    $(OUTDIR_SLASH)HierarchyNode.$(O) \
    $(OUTDIR_SLASH)ImageView.$(O) \
    $(OUTDIR_SLASH)LabelledEnterField.$(O) \
    $(OUTDIR_SLASH)LicenceBox.$(O) \
    $(OUTDIR_SLASH)LinkButton.$(O) \
    $(OUTDIR_SLASH)LinkButtonController.$(O) \
    $(OUTDIR_SLASH)ListEntry.$(O) \
    $(OUTDIR_SLASH)ListModelView.$(O) \
    $(OUTDIR_SLASH)MenuPanel.$(O) \
    $(OUTDIR_SLASH)MultipleItemSelectionWidget.$(O) \
    $(OUTDIR_SLASH)NoteBookView.$(O) \
    $(OUTDIR_SLASH)PrintAbortDialog.$(O) \
    $(OUTDIR_SLASH)PrintingDialog.$(O) \
    $(OUTDIR_SLASH)ProgressIndicator.$(O) \
    $(OUTDIR_SLASH)ProgressNotification.$(O) \
    $(OUTDIR_SLASH)SelectionInHierarchy.$(O) \
    $(OUTDIR_SLASH)SelectionInTree.$(O) \
    $(OUTDIR_SLASH)SelectionInTreeView.$(O) \
    $(OUTDIR_SLASH)Separator.$(O) \
    $(OUTDIR_SLASH)Slider.$(O) \
    $(OUTDIR_SLASH)SteppingSlider.$(O) \
    $(OUTDIR_SLASH)SubCanvas.$(O) \
    $(OUTDIR_SLASH)SyncedMultiColumnTextView.$(O) \
    $(OUTDIR_SLASH)TabItem.$(O) \
    $(OUTDIR_SLASH)TabSpecRuler.$(O) \
    $(OUTDIR_SLASH)TabWidget.$(O) \
    $(OUTDIR_SLASH)TabulatorSpecification.$(O) \
    $(OUTDIR_SLASH)TerminalView.$(O) \
    $(OUTDIR_SLASH)TextBox.$(O) \
    $(OUTDIR_SLASH)ThumbWheel.$(O) \
    $(OUTDIR_SLASH)TreeItem.$(O) \
    $(OUTDIR_SLASH)UpDownButton.$(O) \
    $(OUTDIR_SLASH)ViewScroller.$(O) \
    $(OUTDIR_SLASH)stx_libwidg2.$(O) \
    $(OUTDIR_SLASH)ColorMenu.$(O) \
    $(OUTDIR_SLASH)ComboBoxView.$(O) \
    $(OUTDIR_SLASH)ComboListView.$(O) \
    $(OUTDIR_SLASH)CompactHierarchicalItem.$(O) \
    $(OUTDIR_SLASH)FileSelectionItem.$(O) \
    $(OUTDIR_SLASH)FileSelectionTree.$(O) \
    $(OUTDIR_SLASH)FilenameWidgetWithoutHistory.$(O) \
    $(OUTDIR_SLASH)FontMenu.$(O) \
    $(OUTDIR_SLASH)HierarchicalItem.$(O) \
    $(OUTDIR_SLASH)HorizontalSlider.$(O) \
    $(OUTDIR_SLASH)HorizontalSteppingSlider.$(O) \
    $(OUTDIR_SLASH)ImageEditView.$(O) \
    $(OUTDIR_SLASH)ModelListEntry.$(O) \
    $(OUTDIR_SLASH)MultiColListEntry.$(O) \
    $(OUTDIR_SLASH)PluggableHierarchicalList.$(O) \
    $(OUTDIR_SLASH)SelectionInListModelView.$(O) \
    $(OUTDIR_SLASH)TabView.$(O) \
    $(OUTDIR_SLASH)ThreeColumnTextView.$(O) \
    $(OUTDIR_SLASH)TreeItemWithImage.$(O) \
    $(OUTDIR_SLASH)TriggerBox.$(O) \
    $(OUTDIR_SLASH)TwoColumnTextView.$(O) \
    $(OUTDIR_SLASH)VT100TerminalView.$(O) \
    $(OUTDIR_SLASH)FilenameComboBoxView.$(O) \
    $(OUTDIR_SLASH)HierarchicalFileList.$(O) \
    $(OUTDIR_SLASH)HierarchicalItemWithLabel.$(O) \
    $(OUTDIR_SLASH)HierarchicalItemWithValue.$(O) \
    $(OUTDIR_SLASH)HierarchicalListView.$(O) \
    $(OUTDIR_SLASH)LabelAndIcon.$(O) \
    $(OUTDIR_SLASH)HierarchicalItemWithLabelAndIcon.$(O) \
    $(OUTDIR_SLASH)LabelAndTwoIcons.$(O) \
    $(OUTDIR_SLASH)HierarchicalItemWithLabelAndIconAndValue.$(O) \



