# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_libtool.
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
MODULE_DIR=libtool
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
	AboutBox \
	AbstractFileApplicationNoteBookComponent \
	AbstractFileBrowser \
	AbstractLauncherApplication \
	AbstractSettingsApplication \
	Bookmark \
	BookmarkBar \
	BookmarkEditor \
	BookmarkList \
	BookmarkListEditor \
	BookmarkVisitor \
	BookmarksEditDialog \
	BrowserView \
	ChangesBrowser \
	CodeCompletionHelpMenuView \
	CodeCompletionHelpView \
	CodeGenerator \
	CodeGeneratorTool \
	DebugView \
	Diff \
	Diff2 \
	Diff3 \
	Diff3Hunk \
	Diff3InclusiveVisitor \
	Diff3TextView \
	DiffListUtility \
	DiffTextView \
	DisplayObjectView \
	EditFieldWithCompletion \
	EditFieldWithCompletionSpec \
	EventMonitor \
	FileBrowser \
	FileBrowserV2PanelView \
	FileBrowserV2SettingsDialog \
	FileBrowserV2UISpecifications \
	FileDialog \
	FileOperation \
	FilenameEditFieldV2 \
	InspectorView \
	MemoryMonitor \
	MemoryMonitorView \
	MemoryUsageView \
	MultiViewToolApplication \
	PerforceSourceCodeManagerUtilities \
	ProcessMonitorV2 \
	RCSConflictEditTextView \
	SyntaxElement \
	SyntaxHighlighter2 \
	SystemBrowser \
	SystemStatusMonitor \
	Tools::AbstractTestRunner \
	Tools::BreakpointBrowser \
	Tools::Browslet \
	Tools::BrowsletCanvas \
	Tools::CachedTags \
	Tools::ChangeSetBrowser2 \
	Tools::ChangeSetDiffInfo \
	Tools::ChangeSetDiffTool \
	Tools::ChangeSetSelectionDialog \
	Tools::ChangeSetSpec \
	Tools::CheckinInfoDialog \
	Tools::ClassChecker \
	Tools::ClassSorter \
	Tools::CodeCompletionMenu \
	Tools::CodeCritics \
	Tools::CodeView2 \
	Tools::CodeViewService \
	Tools::DiffCodeView2 \
	Tools::HierarchicalChangesetDialog \
	Tools::InlineMessageDialog \
	Tools::Inspector2 \
	Tools::Inspector2Tab \
	Tools::LintAnnotation \
	Tools::LintHighlighter \
	Tools::LintRuleDetail \
	Tools::LintRuleEditDialog \
	Tools::LintRuleSelectionDialog \
	Tools::MethodCategoryCache \
	Tools::MethodRewriter \
	Tools::NavigationHistory \
	Tools::NavigationState \
	Tools::NavigatorModel \
	Tools::NewClassWizardDialog \
	Tools::NewSystemBrowserCodeView \
	Tools::Profiler \
	Tools::ProfilerInfoBuilder \
	Tools::ProfilerInfoItem \
	Tools::ProjectCheckerBrowser \
	Tools::ProjectLoader \
	Tools::SearchDialog \
	Tools::SmalltalkDiffTool \
	Tools::SourceCodeManagerConfigurationTestTool \
	Tools::SpecialCodeView \
	Tools::StringSearchTool \
	Tools::Tag \
	Tools::TagList \
	Tools::TagsBrowser \
	Tools::TextDiffTool \
	Tools::TextMergeInfo \
	Tools::Toolbox \
	Tools::WebBrowserPage \
	VersionDiffBrowser \
	ViewWithAcceptAndCancelBar \
	stx_libtool \
	AbstractDirectoryBrowser \
	AbstractFileFinderApplicationComponent \
	AbstractSourceCodeManagementSettingsAppl \
	BookmarkMenuBuilder \
	ChangeSetBrowser \
	ClassInspectorView \
	ContextInspectorView \
	DictionaryInspectorView \
	Diff3ExclusiveVisitor \
	DiffCodeView \
	ExternalStreamMonitor \
	FileApplicationNoteBook \
	FileBrowserV2 \
	FileBrowserV2SettingsAppl \
	FileDialogWithPreview \
	ImageInspectorView \
	NewLauncher \
	OrderedCollectionInspectorView \
	ParseTreeIndex \
	SetInspectorView \
	SettingsDialog \
	SmalltalkCodeGeneratorTool \
	SyntaxElementVariable \
	TerminalApplication \
	Tools::BackgroundSourceProcessingService \
	Tools::BreakpointService \
	Tools::BrowserList \
	Tools::CodeCompletionService \
	Tools::CodeNavigationService \
	Tools::CodeView2SettingsAppl \
	Tools::Diff2CodeView2 \
	Tools::Diff3CodeView2 \
	Tools::FontSettingsApplication \
	Tools::GenericToolbox \
	Tools::LintRuleSettingsApplication \
	Tools::LintService \
	Tools::NavigatorCanvas \
	Tools::NewSystemBrowser \
	Tools::OrganizerCanvas \
	Tools::SendersBrowslet \
	Tools::StringSearchToolForTextView \
	Tools::TestRunnerMini \
	Tools::TextDiff2Tool \
	Tools::TextDiff3Tool \
	Tools::VisualProfilerCanvas \
	WorkspaceApplication \
	BookmarkAddMenuBuilder \
	BookmarkToolbarMenuBuilder \
	CVSSourceCodeManagementSettingsAppl \
	DataBaseSourceCodeManagementSettingsAppl \
	DirectoryContentsBrowser \
	DirectoryDifferenceViewApplication \
	DirectoryTreeBrowser \
	FileBasedSourceCodeManagementSettingsAppl \
	FindFileApplication \
	GitSourceCodeManagementSettingsAppl \
	MercurialSourceCodeManagementSettingsAppl \
	PerforceSourceCodeManagementSettingsAppl \
	StoreSourceCodeManagementSettingsAppl \
	Tools::BrowserListWithFilter \
	Tools::ClassCategoryList \
	Tools::ClassGeneratorList \
	Tools::ClassList \
	Tools::CodeHighlightingService \
	Tools::LintRuleList \
	Tools::MethodCategoryList \
	Tools::MethodList \
	Tools::NamespaceList \
	Tools::ProjectList \
	Tools::SmalltalkToolbox \
	Tools::TestRunnerEmbedded \
	Tools::VariableList \
	Tools::ChangeList \
	Tools::ChangeSetDiffList \
	Tools::FullMethodCategoryList \
	Tools::HierarchicalClassCategoryList \
	Tools::HierarchicalClassList \
	Tools::HierarchicalLintRuleList \
	Tools::HierarchicalProjectList \
	Tools::ImplementingClassList \
	Tools::ImplementingMethodList \
	Tools::NamespaceFilter \
	Tools::TestRunner2 \
	Tools::HierarchicalChangeList \
	Tools::HierarchicalPackageFilterList \
	Tools::InheritanceClassList \




COMMON_OBJS= \
    $(OUTDIR_SLASH)AboutBox.$(O) \
    $(OUTDIR_SLASH)AbstractFileApplicationNoteBookComponent.$(O) \
    $(OUTDIR_SLASH)AbstractFileBrowser.$(O) \
    $(OUTDIR_SLASH)AbstractLauncherApplication.$(O) \
    $(OUTDIR_SLASH)AbstractSettingsApplication.$(O) \
    $(OUTDIR_SLASH)Bookmark.$(O) \
    $(OUTDIR_SLASH)BookmarkBar.$(O) \
    $(OUTDIR_SLASH)BookmarkEditor.$(O) \
    $(OUTDIR_SLASH)BookmarkList.$(O) \
    $(OUTDIR_SLASH)BookmarkListEditor.$(O) \
    $(OUTDIR_SLASH)BookmarkVisitor.$(O) \
    $(OUTDIR_SLASH)BookmarksEditDialog.$(O) \
    $(OUTDIR_SLASH)BrowserView.$(O) \
    $(OUTDIR_SLASH)ChangesBrowser.$(O) \
    $(OUTDIR_SLASH)CodeCompletionHelpMenuView.$(O) \
    $(OUTDIR_SLASH)CodeCompletionHelpView.$(O) \
    $(OUTDIR_SLASH)CodeGenerator.$(O) \
    $(OUTDIR_SLASH)CodeGeneratorTool.$(O) \
    $(OUTDIR_SLASH)DebugView.$(O) \
    $(OUTDIR_SLASH)Diff.$(O) \
    $(OUTDIR_SLASH)Diff2.$(O) \
    $(OUTDIR_SLASH)Diff3.$(O) \
    $(OUTDIR_SLASH)Diff3Hunk.$(O) \
    $(OUTDIR_SLASH)Diff3InclusiveVisitor.$(O) \
    $(OUTDIR_SLASH)Diff3TextView.$(O) \
    $(OUTDIR_SLASH)DiffListUtility.$(O) \
    $(OUTDIR_SLASH)DiffTextView.$(O) \
    $(OUTDIR_SLASH)DisplayObjectView.$(O) \
    $(OUTDIR_SLASH)EditFieldWithCompletion.$(O) \
    $(OUTDIR_SLASH)EditFieldWithCompletionSpec.$(O) \
    $(OUTDIR_SLASH)EventMonitor.$(O) \
    $(OUTDIR_SLASH)FileBrowser.$(O) \
    $(OUTDIR_SLASH)FileBrowserV2PanelView.$(O) \
    $(OUTDIR_SLASH)FileBrowserV2SettingsDialog.$(O) \
    $(OUTDIR_SLASH)FileBrowserV2UISpecifications.$(O) \
    $(OUTDIR_SLASH)FileDialog.$(O) \
    $(OUTDIR_SLASH)FileOperation.$(O) \
    $(OUTDIR_SLASH)FilenameEditFieldV2.$(O) \
    $(OUTDIR_SLASH)InspectorView.$(O) \
    $(OUTDIR_SLASH)MemoryMonitor.$(O) \
    $(OUTDIR_SLASH)MemoryMonitorView.$(O) \
    $(OUTDIR_SLASH)MemoryUsageView.$(O) \
    $(OUTDIR_SLASH)MultiViewToolApplication.$(O) \
    $(OUTDIR_SLASH)PerforceSourceCodeManagerUtilities.$(O) \
    $(OUTDIR_SLASH)ProcessMonitorV2.$(O) \
    $(OUTDIR_SLASH)RCSConflictEditTextView.$(O) \
    $(OUTDIR_SLASH)SyntaxElement.$(O) \
    $(OUTDIR_SLASH)SyntaxHighlighter2.$(O) \
    $(OUTDIR_SLASH)SystemBrowser.$(O) \
    $(OUTDIR_SLASH)SystemStatusMonitor.$(O) \
    $(OUTDIR_SLASH)Tools__AbstractTestRunner.$(O) \
    $(OUTDIR_SLASH)Tools__BreakpointBrowser.$(O) \
    $(OUTDIR_SLASH)Tools__Browslet.$(O) \
    $(OUTDIR_SLASH)Tools__BrowsletCanvas.$(O) \
    $(OUTDIR_SLASH)Tools__CachedTags.$(O) \
    $(OUTDIR_SLASH)Tools__ChangeSetBrowser2.$(O) \
    $(OUTDIR_SLASH)Tools__ChangeSetDiffInfo.$(O) \
    $(OUTDIR_SLASH)Tools__ChangeSetDiffTool.$(O) \
    $(OUTDIR_SLASH)Tools__ChangeSetSelectionDialog.$(O) \
    $(OUTDIR_SLASH)Tools__ChangeSetSpec.$(O) \
    $(OUTDIR_SLASH)Tools__CheckinInfoDialog.$(O) \
    $(OUTDIR_SLASH)Tools__ClassChecker.$(O) \
    $(OUTDIR_SLASH)Tools__ClassSorter.$(O) \
    $(OUTDIR_SLASH)Tools__CodeCompletionMenu.$(O) \
    $(OUTDIR_SLASH)Tools__CodeCritics.$(O) \
    $(OUTDIR_SLASH)Tools__CodeView2.$(O) \
    $(OUTDIR_SLASH)Tools__CodeViewService.$(O) \
    $(OUTDIR_SLASH)Tools__DiffCodeView2.$(O) \
    $(OUTDIR_SLASH)Tools__HierarchicalChangesetDialog.$(O) \
    $(OUTDIR_SLASH)Tools__InlineMessageDialog.$(O) \
    $(OUTDIR_SLASH)Tools__Inspector2.$(O) \
    $(OUTDIR_SLASH)Tools__Inspector2Tab.$(O) \
    $(OUTDIR_SLASH)Tools__LintAnnotation.$(O) \
    $(OUTDIR_SLASH)Tools__LintHighlighter.$(O) \
    $(OUTDIR_SLASH)Tools__LintRuleDetail.$(O) \
    $(OUTDIR_SLASH)Tools__LintRuleEditDialog.$(O) \
    $(OUTDIR_SLASH)Tools__LintRuleSelectionDialog.$(O) \
    $(OUTDIR_SLASH)Tools__MethodCategoryCache.$(O) \
    $(OUTDIR_SLASH)Tools__MethodRewriter.$(O) \
    $(OUTDIR_SLASH)Tools__NavigationHistory.$(O) \
    $(OUTDIR_SLASH)Tools__NavigationState.$(O) \
    $(OUTDIR_SLASH)Tools__NavigatorModel.$(O) \
    $(OUTDIR_SLASH)Tools__NewClassWizardDialog.$(O) \
    $(OUTDIR_SLASH)Tools__NewSystemBrowserCodeView.$(O) \
    $(OUTDIR_SLASH)Tools__Profiler.$(O) \
    $(OUTDIR_SLASH)Tools__ProfilerInfoBuilder.$(O) \
    $(OUTDIR_SLASH)Tools__ProfilerInfoItem.$(O) \
    $(OUTDIR_SLASH)Tools__ProjectCheckerBrowser.$(O) \
    $(OUTDIR_SLASH)Tools__ProjectLoader.$(O) \
    $(OUTDIR_SLASH)Tools__SearchDialog.$(O) \
    $(OUTDIR_SLASH)Tools__SmalltalkDiffTool.$(O) \
    $(OUTDIR_SLASH)Tools__SourceCodeManagerConfigurationTestTool.$(O) \
    $(OUTDIR_SLASH)Tools__SpecialCodeView.$(O) \
    $(OUTDIR_SLASH)Tools__StringSearchTool.$(O) \
    $(OUTDIR_SLASH)Tools__Tag.$(O) \
    $(OUTDIR_SLASH)Tools__TagList.$(O) \
    $(OUTDIR_SLASH)Tools__TagsBrowser.$(O) \
    $(OUTDIR_SLASH)Tools__TextDiffTool.$(O) \
    $(OUTDIR_SLASH)Tools__TextMergeInfo.$(O) \
    $(OUTDIR_SLASH)Tools__Toolbox.$(O) \
    $(OUTDIR_SLASH)Tools__WebBrowserPage.$(O) \
    $(OUTDIR_SLASH)VersionDiffBrowser.$(O) \
    $(OUTDIR_SLASH)ViewWithAcceptAndCancelBar.$(O) \
    $(OUTDIR_SLASH)stx_libtool.$(O) \
    $(OUTDIR_SLASH)AbstractDirectoryBrowser.$(O) \
    $(OUTDIR_SLASH)AbstractFileFinderApplicationComponent.$(O) \
    $(OUTDIR_SLASH)AbstractSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR_SLASH)BookmarkMenuBuilder.$(O) \
    $(OUTDIR_SLASH)ChangeSetBrowser.$(O) \
    $(OUTDIR_SLASH)ClassInspectorView.$(O) \
    $(OUTDIR_SLASH)ContextInspectorView.$(O) \
    $(OUTDIR_SLASH)DictionaryInspectorView.$(O) \
    $(OUTDIR_SLASH)Diff3ExclusiveVisitor.$(O) \
    $(OUTDIR_SLASH)DiffCodeView.$(O) \
    $(OUTDIR_SLASH)ExternalStreamMonitor.$(O) \
    $(OUTDIR_SLASH)FileApplicationNoteBook.$(O) \
    $(OUTDIR_SLASH)FileBrowserV2.$(O) \
    $(OUTDIR_SLASH)FileBrowserV2SettingsAppl.$(O) \
    $(OUTDIR_SLASH)FileDialogWithPreview.$(O) \
    $(OUTDIR_SLASH)ImageInspectorView.$(O) \
    $(OUTDIR_SLASH)NewLauncher.$(O) \
    $(OUTDIR_SLASH)OrderedCollectionInspectorView.$(O) \
    $(OUTDIR_SLASH)ParseTreeIndex.$(O) \
    $(OUTDIR_SLASH)SetInspectorView.$(O) \
    $(OUTDIR_SLASH)SettingsDialog.$(O) \
    $(OUTDIR_SLASH)SmalltalkCodeGeneratorTool.$(O) \
    $(OUTDIR_SLASH)SyntaxElementVariable.$(O) \
    $(OUTDIR_SLASH)TerminalApplication.$(O) \
    $(OUTDIR_SLASH)Tools__BackgroundSourceProcessingService.$(O) \
    $(OUTDIR_SLASH)Tools__BreakpointService.$(O) \
    $(OUTDIR_SLASH)Tools__BrowserList.$(O) \
    $(OUTDIR_SLASH)Tools__CodeCompletionService.$(O) \
    $(OUTDIR_SLASH)Tools__CodeNavigationService.$(O) \
    $(OUTDIR_SLASH)Tools__CodeView2SettingsAppl.$(O) \
    $(OUTDIR_SLASH)Tools__Diff2CodeView2.$(O) \
    $(OUTDIR_SLASH)Tools__Diff3CodeView2.$(O) \
    $(OUTDIR_SLASH)Tools__FontSettingsApplication.$(O) \
    $(OUTDIR_SLASH)Tools__GenericToolbox.$(O) \
    $(OUTDIR_SLASH)Tools__LintRuleSettingsApplication.$(O) \
    $(OUTDIR_SLASH)Tools__LintService.$(O) \
    $(OUTDIR_SLASH)Tools__NavigatorCanvas.$(O) \
    $(OUTDIR_SLASH)Tools__NewSystemBrowser.$(O) \
    $(OUTDIR_SLASH)Tools__OrganizerCanvas.$(O) \
    $(OUTDIR_SLASH)Tools__SendersBrowslet.$(O) \
    $(OUTDIR_SLASH)Tools__StringSearchToolForTextView.$(O) \
    $(OUTDIR_SLASH)Tools__TestRunnerMini.$(O) \
    $(OUTDIR_SLASH)Tools__TextDiff2Tool.$(O) \
    $(OUTDIR_SLASH)Tools__TextDiff3Tool.$(O) \
    $(OUTDIR_SLASH)Tools__VisualProfilerCanvas.$(O) \
    $(OUTDIR_SLASH)WorkspaceApplication.$(O) \
    $(OUTDIR_SLASH)BookmarkAddMenuBuilder.$(O) \
    $(OUTDIR_SLASH)BookmarkToolbarMenuBuilder.$(O) \
    $(OUTDIR_SLASH)CVSSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR_SLASH)DataBaseSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR_SLASH)DirectoryContentsBrowser.$(O) \
    $(OUTDIR_SLASH)DirectoryDifferenceViewApplication.$(O) \
    $(OUTDIR_SLASH)DirectoryTreeBrowser.$(O) \
    $(OUTDIR_SLASH)FileBasedSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR_SLASH)FindFileApplication.$(O) \
    $(OUTDIR_SLASH)GitSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR_SLASH)MercurialSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR_SLASH)PerforceSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR_SLASH)StoreSourceCodeManagementSettingsAppl.$(O) \
    $(OUTDIR_SLASH)Tools__BrowserListWithFilter.$(O) \
    $(OUTDIR_SLASH)Tools__ClassCategoryList.$(O) \
    $(OUTDIR_SLASH)Tools__ClassGeneratorList.$(O) \
    $(OUTDIR_SLASH)Tools__ClassList.$(O) \
    $(OUTDIR_SLASH)Tools__CodeHighlightingService.$(O) \
    $(OUTDIR_SLASH)Tools__LintRuleList.$(O) \
    $(OUTDIR_SLASH)Tools__MethodCategoryList.$(O) \
    $(OUTDIR_SLASH)Tools__MethodList.$(O) \
    $(OUTDIR_SLASH)Tools__NamespaceList.$(O) \
    $(OUTDIR_SLASH)Tools__ProjectList.$(O) \
    $(OUTDIR_SLASH)Tools__SmalltalkToolbox.$(O) \
    $(OUTDIR_SLASH)Tools__TestRunnerEmbedded.$(O) \
    $(OUTDIR_SLASH)Tools__VariableList.$(O) \
    $(OUTDIR_SLASH)Tools__ChangeList.$(O) \
    $(OUTDIR_SLASH)Tools__ChangeSetDiffList.$(O) \
    $(OUTDIR_SLASH)Tools__FullMethodCategoryList.$(O) \
    $(OUTDIR_SLASH)Tools__HierarchicalClassCategoryList.$(O) \
    $(OUTDIR_SLASH)Tools__HierarchicalClassList.$(O) \
    $(OUTDIR_SLASH)Tools__HierarchicalLintRuleList.$(O) \
    $(OUTDIR_SLASH)Tools__HierarchicalProjectList.$(O) \
    $(OUTDIR_SLASH)Tools__ImplementingClassList.$(O) \
    $(OUTDIR_SLASH)Tools__ImplementingMethodList.$(O) \
    $(OUTDIR_SLASH)Tools__NamespaceFilter.$(O) \
    $(OUTDIR_SLASH)Tools__TestRunner2.$(O) \
    $(OUTDIR_SLASH)Tools__HierarchicalChangeList.$(O) \
    $(OUTDIR_SLASH)Tools__HierarchicalPackageFilterList.$(O) \
    $(OUTDIR_SLASH)Tools__InheritanceClassList.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \



