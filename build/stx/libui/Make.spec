# $Header: /cvs/stx/stx/libui/Make.spec,v 1.26 2018-07-05 10:59:04 lukas Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libui.
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
MODULE_DIR=libui
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
	AssistantPageSpec \
	DataSetColumnSpec \
	SubChannelInfoSpec \
	UIPalette \
	UISpecVisitor \
	UISpecification \
	stx_libui \
	ComponentSpec \
	NoteBookSpec \
	UIEventCallbackSubSpec \
	UnknownSpec \
	CompositeSpec \
	CompositeSpecCollection \
	DividerSpec \
	NamedSpec \
	RegionSpec \
	SpecCollection \
	TabControlSpec \
	UISubSpecification \
	ViewWithLabelSpec \
	ViewWithSubcomponentsSpec \
	WindowSpec \
	ColorMenuSpec \
	FontMenuSpec \
	FullSpec \
	LabelSpec \
	MenuComponentSpec \
	ProgressIndicatorSpec \
	ScrollableViewSpec \
	ScrollerSpec \
	SeparatorSpec \
	ViewSpec \
	ViewWithLabelAndModelSpec \
	WidgetSpec \
	ActionButtonSpec \
	CheckBoxSpec \
	ComboListSpec \
	ExtendedComboBoxSpec \
	FramedBoxSpec \
	InputFieldSpec \
	MenuPanelSpec \
	PanelViewSpec \
	PopUpListSpec \
	RoundProgressIndicatorSpec \
	ScrollBarSpec \
	SliderSpec \
	TabViewSpec \
	TableViewSpec \
	TransparentBoxSpec \
	UpDownButtonSpec \
	VariablePanelSpec \
	ViewWithScrollerSpec \
	ArbitraryComponentSpec \
	ArrowButtonSpec \
	ButtonSpec \
	ComboBoxSpec \
	DataSetSpec \
	FilenameInputFieldSpec \
	GridBagLayoutViewSpec \
	GroupBoxSpec \
	HTMLViewSpec \
	HorizontalPanelViewSpec \
	LinkButtonSpec \
	ListModelViewSpec \
	MenuButtonSpec \
	MultiColumnPanelViewSpec \
	NoteBookViewSpec \
	SelectionInTreeViewSpec \
	SequenceViewSpec \
	SteppingSliderSpec \
	SubCanvasSpec \
	TextEditorSpec \
	ThumbWheelSpec \
	ToggleSpec \
	TriggerBoxSpec \
	VariableHorizontalPanelSpec \
	VariableVerticalPanelSpec \
	VerticalPanelViewSpec \
	CheckToggleSpec \
	FileSelectionTreeSpec \
	NonScrollableArbitraryComponentSpec \
	RadioButtonSpec \
	SelectionInListModelViewSpec \
	TextCollectorSpec \
	UIGalleryViewSpec \
	WorkspaceSpec \
	CodeViewSpec \
	HierarchicalListViewSpec \




COMMON_OBJS= \
    $(OUTDIR)AssistantPageSpec.$(O) \
    $(OUTDIR)DataSetColumnSpec.$(O) \
    $(OUTDIR)SubChannelInfoSpec.$(O) \
    $(OUTDIR)UIPalette.$(O) \
    $(OUTDIR)UISpecVisitor.$(O) \
    $(OUTDIR)UISpecification.$(O) \
    $(OUTDIR)stx_libui.$(O) \
    $(OUTDIR)ComponentSpec.$(O) \
    $(OUTDIR)NoteBookSpec.$(O) \
    $(OUTDIR)UIEventCallbackSubSpec.$(O) \
    $(OUTDIR)UnknownSpec.$(O) \
    $(OUTDIR)CompositeSpec.$(O) \
    $(OUTDIR)CompositeSpecCollection.$(O) \
    $(OUTDIR)DividerSpec.$(O) \
    $(OUTDIR)NamedSpec.$(O) \
    $(OUTDIR)RegionSpec.$(O) \
    $(OUTDIR)SpecCollection.$(O) \
    $(OUTDIR)TabControlSpec.$(O) \
    $(OUTDIR)UISubSpecification.$(O) \
    $(OUTDIR)ViewWithLabelSpec.$(O) \
    $(OUTDIR)ViewWithSubcomponentsSpec.$(O) \
    $(OUTDIR)WindowSpec.$(O) \
    $(OUTDIR)ColorMenuSpec.$(O) \
    $(OUTDIR)FontMenuSpec.$(O) \
    $(OUTDIR)FullSpec.$(O) \
    $(OUTDIR)LabelSpec.$(O) \
    $(OUTDIR)MenuComponentSpec.$(O) \
    $(OUTDIR)ProgressIndicatorSpec.$(O) \
    $(OUTDIR)ScrollableViewSpec.$(O) \
    $(OUTDIR)ScrollerSpec.$(O) \
    $(OUTDIR)SeparatorSpec.$(O) \
    $(OUTDIR)ViewSpec.$(O) \
    $(OUTDIR)ViewWithLabelAndModelSpec.$(O) \
    $(OUTDIR)WidgetSpec.$(O) \
    $(OUTDIR)ActionButtonSpec.$(O) \
    $(OUTDIR)CheckBoxSpec.$(O) \
    $(OUTDIR)ComboListSpec.$(O) \
    $(OUTDIR)ExtendedComboBoxSpec.$(O) \
    $(OUTDIR)FramedBoxSpec.$(O) \
    $(OUTDIR)InputFieldSpec.$(O) \
    $(OUTDIR)MenuPanelSpec.$(O) \
    $(OUTDIR)PanelViewSpec.$(O) \
    $(OUTDIR)PopUpListSpec.$(O) \
    $(OUTDIR)RoundProgressIndicatorSpec.$(O) \
    $(OUTDIR)ScrollBarSpec.$(O) \
    $(OUTDIR)SliderSpec.$(O) \
    $(OUTDIR)TabViewSpec.$(O) \
    $(OUTDIR)TableViewSpec.$(O) \
    $(OUTDIR)TransparentBoxSpec.$(O) \
    $(OUTDIR)UpDownButtonSpec.$(O) \
    $(OUTDIR)VariablePanelSpec.$(O) \
    $(OUTDIR)ViewWithScrollerSpec.$(O) \
    $(OUTDIR)ArbitraryComponentSpec.$(O) \
    $(OUTDIR)ArrowButtonSpec.$(O) \
    $(OUTDIR)ButtonSpec.$(O) \
    $(OUTDIR)ComboBoxSpec.$(O) \
    $(OUTDIR)DataSetSpec.$(O) \
    $(OUTDIR)FilenameInputFieldSpec.$(O) \
    $(OUTDIR)GridBagLayoutViewSpec.$(O) \
    $(OUTDIR)GroupBoxSpec.$(O) \
    $(OUTDIR)HTMLViewSpec.$(O) \
    $(OUTDIR)HorizontalPanelViewSpec.$(O) \
    $(OUTDIR)LinkButtonSpec.$(O) \
    $(OUTDIR)ListModelViewSpec.$(O) \
    $(OUTDIR)MenuButtonSpec.$(O) \
    $(OUTDIR)MultiColumnPanelViewSpec.$(O) \
    $(OUTDIR)NoteBookViewSpec.$(O) \
    $(OUTDIR)SelectionInTreeViewSpec.$(O) \
    $(OUTDIR)SequenceViewSpec.$(O) \
    $(OUTDIR)SteppingSliderSpec.$(O) \
    $(OUTDIR)SubCanvasSpec.$(O) \
    $(OUTDIR)TextEditorSpec.$(O) \
    $(OUTDIR)ThumbWheelSpec.$(O) \
    $(OUTDIR)ToggleSpec.$(O) \
    $(OUTDIR)TriggerBoxSpec.$(O) \
    $(OUTDIR)VariableHorizontalPanelSpec.$(O) \
    $(OUTDIR)VariableVerticalPanelSpec.$(O) \
    $(OUTDIR)VerticalPanelViewSpec.$(O) \
    $(OUTDIR)CheckToggleSpec.$(O) \
    $(OUTDIR)FileSelectionTreeSpec.$(O) \
    $(OUTDIR)NonScrollableArbitraryComponentSpec.$(O) \
    $(OUTDIR)RadioButtonSpec.$(O) \
    $(OUTDIR)SelectionInListModelViewSpec.$(O) \
    $(OUTDIR)TextCollectorSpec.$(O) \
    $(OUTDIR)UIGalleryViewSpec.$(O) \
    $(OUTDIR)WorkspaceSpec.$(O) \
    $(OUTDIR)CodeViewSpec.$(O) \
    $(OUTDIR)HierarchicalListViewSpec.$(O) \



