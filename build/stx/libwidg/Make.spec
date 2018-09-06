# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libwidg.
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
MODULE_DIR=libwidg
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
STCLOCALOPTIMIZATIONS=+optinline


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
	ButtonController \
	CodeViewTheme \
	DialogBox \
	EditTextViewCompletionSupport \
	EnterFieldGroup \
	FramedBox \
	GenericToolbarIconLibrary \
	Label \
	ListView \
	ListViewController \
	MenuEvent \
	ObjectView \
	PanelView \
	PopUpMenu \
	PullDownMenu \
	RadioButtonGroup \
	ScrollBar \
	ScrollableView \
	Scroller \
	SelectionInList \
	VariablePanel \
	VariablePanelController \
	stx_libwidg \
	Button \
	CheckLabel \
	DragRectangleController \
	EnterBox \
	FontPanel \
	HVScrollableView \
	HorizontalPanelView \
	HorizontalScrollBar \
	HorizontalScroller \
	InfoBox \
	MiniScroller \
	MultiColumnPanelView \
	MultiSelectionInList \
	OptionBox \
	PopUpListController \
	SelectionInListView \
	SequenceView \
	TextView \
	ToggleController \
	VariableHorizontalPanel \
	VariableHorizontalPanelController \
	VariableVerticalPanel \
	VariableVerticalPanelController \
	VerticalPanelView \
	WorkspaceCompletionSupport \
	XPToolbarIconLibrary \
	ArrowButton \
	EditTextView \
	EnterBox2 \
	FileSelectionList \
	HorizontalMiniScroller \
	ListSelectionBox \
	MacOSXToolbarIconLibrary \
	MenuView \
	PopUpList \
	RadioButtonController \
	Toggle \
	VistaToolbarIconLibrary \
	WarningBox \
	AdwaitaToolbarIconLibrary \
	CheckToggle \
	ClickMenuView \
	EditField \
	FileSelectionBox \
	MacOSX2ToolbarIconLibrary \
	RadioButton \
	TextCollector \
	Windows8ToolbarIconLibrary \
	YesNoBox \
	FileSaveBox \
	Workspace \
	CodeView \




COMMON_OBJS= \
    $(OUTDIR)ButtonController.$(O) \
    $(OUTDIR)CodeViewTheme.$(O) \
    $(OUTDIR)DialogBox.$(O) \
    $(OUTDIR)EditTextViewCompletionSupport.$(O) \
    $(OUTDIR)EnterFieldGroup.$(O) \
    $(OUTDIR)FramedBox.$(O) \
    $(OUTDIR)GenericToolbarIconLibrary.$(O) \
    $(OUTDIR)Label.$(O) \
    $(OUTDIR)ListView.$(O) \
    $(OUTDIR)ListViewController.$(O) \
    $(OUTDIR)MenuEvent.$(O) \
    $(OUTDIR)ObjectView.$(O) \
    $(OUTDIR)PanelView.$(O) \
    $(OUTDIR)PopUpMenu.$(O) \
    $(OUTDIR)PullDownMenu.$(O) \
    $(OUTDIR)RadioButtonGroup.$(O) \
    $(OUTDIR)ScrollBar.$(O) \
    $(OUTDIR)ScrollableView.$(O) \
    $(OUTDIR)Scroller.$(O) \
    $(OUTDIR)SelectionInList.$(O) \
    $(OUTDIR)VariablePanel.$(O) \
    $(OUTDIR)VariablePanelController.$(O) \
    $(OUTDIR)stx_libwidg.$(O) \
    $(OUTDIR)Button.$(O) \
    $(OUTDIR)CheckLabel.$(O) \
    $(OUTDIR)DragRectangleController.$(O) \
    $(OUTDIR)EnterBox.$(O) \
    $(OUTDIR)FontPanel.$(O) \
    $(OUTDIR)HVScrollableView.$(O) \
    $(OUTDIR)HorizontalPanelView.$(O) \
    $(OUTDIR)HorizontalScrollBar.$(O) \
    $(OUTDIR)HorizontalScroller.$(O) \
    $(OUTDIR)InfoBox.$(O) \
    $(OUTDIR)MiniScroller.$(O) \
    $(OUTDIR)MultiColumnPanelView.$(O) \
    $(OUTDIR)MultiSelectionInList.$(O) \
    $(OUTDIR)OptionBox.$(O) \
    $(OUTDIR)PopUpListController.$(O) \
    $(OUTDIR)SelectionInListView.$(O) \
    $(OUTDIR)SequenceView.$(O) \
    $(OUTDIR)TextView.$(O) \
    $(OUTDIR)ToggleController.$(O) \
    $(OUTDIR)VariableHorizontalPanel.$(O) \
    $(OUTDIR)VariableHorizontalPanelController.$(O) \
    $(OUTDIR)VariableVerticalPanel.$(O) \
    $(OUTDIR)VariableVerticalPanelController.$(O) \
    $(OUTDIR)VerticalPanelView.$(O) \
    $(OUTDIR)WorkspaceCompletionSupport.$(O) \
    $(OUTDIR)XPToolbarIconLibrary.$(O) \
    $(OUTDIR)ArrowButton.$(O) \
    $(OUTDIR)EditTextView.$(O) \
    $(OUTDIR)EnterBox2.$(O) \
    $(OUTDIR)FileSelectionList.$(O) \
    $(OUTDIR)HorizontalMiniScroller.$(O) \
    $(OUTDIR)ListSelectionBox.$(O) \
    $(OUTDIR)MacOSXToolbarIconLibrary.$(O) \
    $(OUTDIR)MenuView.$(O) \
    $(OUTDIR)PopUpList.$(O) \
    $(OUTDIR)RadioButtonController.$(O) \
    $(OUTDIR)Toggle.$(O) \
    $(OUTDIR)VistaToolbarIconLibrary.$(O) \
    $(OUTDIR)WarningBox.$(O) \
    $(OUTDIR)AdwaitaToolbarIconLibrary.$(O) \
    $(OUTDIR)CheckToggle.$(O) \
    $(OUTDIR)ClickMenuView.$(O) \
    $(OUTDIR)EditField.$(O) \
    $(OUTDIR)FileSelectionBox.$(O) \
    $(OUTDIR)MacOSX2ToolbarIconLibrary.$(O) \
    $(OUTDIR)RadioButton.$(O) \
    $(OUTDIR)TextCollector.$(O) \
    $(OUTDIR)Windows8ToolbarIconLibrary.$(O) \
    $(OUTDIR)YesNoBox.$(O) \
    $(OUTDIR)FileSaveBox.$(O) \
    $(OUTDIR)Workspace.$(O) \
    $(OUTDIR)CodeView.$(O) \
    $(OUTDIR)extensions.$(O) \



