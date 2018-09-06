"
 COPYRIGHT (c) 1988 by Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libtool
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libtool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2015-2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Package documentation:

    This library contains ST/X development tools, 
    such as browsers for classes, files, changes, the debugger etc.

    Some tools have been obsoleted by modernized replacement versions
    For example, the old FileBrowser, SystemBrowser and Inspector classes have
    mostly been replaced by modernized versions with better UI and more functioality.

    Because some ST/X customers have based their own tools around and on top of some
    older classes here, these will remain and will still be deployed in future versions.
    However, for some, no active development is ongoing 
    (i.e. the old SystemBrowser may not support new features, such as multiple programming languages, 
    refactorings, highlighting, breakpoints etc.)
"
! !

!stx_libtool class methodsFor:'accessing - hg'!

hgRemoveContainesForDeletedClasses
    "If true, then containers for removed classes are __AUTOMATICALLY__ removed from the
     repositoru. If false, obsolete containes are kept.

     Default is true (remove obsolete containers) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to return false to avoid deletions
     of obsolete files. Usefull when branching off an old CVS repo with loads of mess."

    ^false "default"

    "Created: / 02-09-2013 / 09:47:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libtool class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'exept:expecco'    "Expecco::ExpeccoNetAPI - referenced by AbstractLauncherApplication>>bugReporterAvailable "
        #'exept:httpPortal'    "WebApplicationModel - referenced by Tools::NewSystemBrowser>>classMenuNewWebApplication "
        #'exept:osi/asn1'    "OSI::ASN1Browser - referenced by FileBrowser>>openASN1Browser "
        #'exept:technologyBridge/dotNetBridge'    "DOTNET::DotNet - referenced by AbstractSettingsApplication::MiscCommunicationSettingsAppl>>closeAllDotNetConnections "
        #'exept:vncViewer'    "VNCAuthenticationFailure - referenced by FileApplicationNoteBook::XViewApplication>>startVNCserver "
        #'exept:CC'    "CBrowser::Browser - referenced by AbstractFileBrowser>>openCBrowser "
        #'exept:xml/inspector'    "XML::XMLInspector - referenced by AbstractFileBrowser>>inspectXmlFile "
        #'stx:libwebkit'    "WebKitView - referenced by Tools::WebBrowserPage>>webKitView "
        #'stx:libsvn'
        #'stx:clients/Demos'    "ClassTreeGraphView - referenced by Tools::NewSystemBrowser>>updateSpecialCodeEditorVisibilityForClass:method: "
        #'stx:clients/MailTool'    "SendMailTool - referenced by Tools::NewSystemBrowser>>sendFileViaEmail:subject: "
        #'stx:clients/Tools'    "ZipTool - referenced by AbstractFileBrowser>>openZipTool "
        #'stx:goodies/communication'    "SmalltalkShareClient - referenced by AbstractLauncherApplication>>remoteImageBrowserAvailable "
        #'stx:goodies/monticello'    "MCInteractiveLoadingQuery - referenced by Tools::ChangeSetBrowser2>>changeMenuApplyChange: "
        #'stx:goodies/rdoit'    "RDoItServer - referenced by AbstractLauncherApplication::LauncherDialogs class>>communicationsSettings "
        #'stx:goodies/refactoryBrowser/browser'    "CategoryEnvironment - referenced by Tools::NewSystemBrowser>>selectedCategoriesAsEnvironment "
        #'stx:goodies/refactoryBrowser/changes'    "RefactoryChangeManager - referenced by Tools::NewSystemBrowser>>hasUndoableOperations "
        #'stx:goodies/refactoryBrowser/helpers'    "BrowserEnvironment - referenced by Tools::NewSystemBrowser>>selectedSelectorsAsEnvironment "
        #'stx:goodies/refactoryBrowser/lint'    "SmalllintChecker - referenced by Tools::NewSystemBrowser>>smalllintRunRule:onEnvironment: "
        #'stx:goodies/refactoryBrowser/refactoring'    "InlineMethodRefactoring - referenced by Tools::NewSystemBrowser>>codeMenuInlineMessage "
        #'stx:goodies/sif'    "SmalltalkInterchangeSTXFileOutManager - referenced by Tools::NewSystemBrowser>>projectMenuFileOutAsWithFormat: "
        #'stx:goodies/simpleServices'    "STXScriptingServer - referenced by AbstractSettingsApplication::RDoItServerSettingsAppl>>scriptingServerPortOrPath "
        #'stx:goodies/soap'    "SOAP::SoapHttpModule - referenced by AbstractLauncherApplication::LauncherDialogs class>>communicationsSettings "
        #'stx:goodies/soap/examples'    "SOAP::BabelFishClient - referenced by WorkspaceApplication>>babelFishTranslate: "
        #'stx:goodies/sunit'    "TestCase - referenced by Tools::NewSystemBrowser>>classTemplateFor:in:asNamespace:private:metaClassUsed: "
        #'stx:goodies/webServer'    "FCGIServer - referenced by AbstractSettingsApplication::HTTPStartServerSettingsApplication>>createFcgiServer "
        #'stx:goodies/webServer/ui'    "HTTPServerSettingsAppl - referenced by AbstractSettingsApplication::HTTPStartServerSettingsApplication>>createServerApplicationFor: "
        #'stx:goodies/xml/stx'    "XMLCoder - referenced by Tools::NewSystemBrowser>>selectorMenuFileOutXMLAs "
        #'stx:goodies/xml/vw'    "XML::XMLParser - referenced by ChangesBrowser class>>readXMLChangesFrom:inBackground: "
        #'stx:libdb'    "SQL::SQLError - referenced by StoreSourceCodeManagementSettingsAppl>>tryToConnectTo: "
        #'stx:libhtml'    "DidYouKnowTipViewer - referenced by AbstractLauncherApplication>>showTipOfTheDay "
        #'stx:libjava'    "JavaClassReader - referenced by AbstractFileBrowser>>singleFileFileIn:lazy: "
        #'stx:libjava/experiments'    "JavaCompiler - referenced by BrowserView>>setAcceptActionForNewJavaClass "
        #'stx:libjavascript'    "STXJavaScriptLanguage - referenced by Tools::NewSystemBrowser>>classOtherClassNewSlice "
        #'stx:libtool2'    "HierarchicalListEditor - referenced by SystemBrowser class>>resourceEditorClassFor: "
        #'stx:libboss'    "BinaryOutputManager - referenced by Tools::Profiler>>storeStatisticsOn: "
        #'exept:osi/services'    "OSI::ACSE - referenced by AbstractLauncherApplication::LauncherDialogs class>>communicationsSettings"
        #'stx:goodies/smallsense'    "SmallSense::SmalltalkLintService - referenced by Tools::CodeView2>>lintService"
    )

    "Modified: / 06-07-2011 / 16:16:13 / jv"
    "Modified: / 26-07-2011 / 10:59:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:goodies/refactoryBrowser/parser'    "RBProgramNodeVisitor - superclass of CodeGenerator"
        #'stx:libbasic'    "AbstractTime - extended"
        #'stx:libbasic2'    "Iterator - extended"
        #'stx:libbasic3'    "Change - extended"
        #'stx:libcomp'    "AbstractSyntaxHighlighter - extended"
        #'stx:libui'    "ComponentSpec - superclass of EditFieldWithCompletionSpec"
        #'stx:libview'    "AbstractBackground - superclass of DiffTextView::DiffTextScrollerBackground"
        #'stx:libview2'    "ApplicationModel - extended"
        #'stx:libwidg'    "Button - superclass of ViewWithAcceptAndCancelBar::AcceptAndCancelBar::ButtonWithHelpText"
        #'stx:libwidg2'    "AbstractHierarchicalItem - superclass of AbstractLauncherApplication::PackageLoadDialog::MyHierarchicalItem"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:goodies/smallsense'    "SmallSense::SmalltalkLintService - referenced by Tools::CodeView2>>lintService"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_libtool class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBTOOL_BASE
LIB_BASE=$(LIBTOOL_BASE)
'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libtool class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        AboutBox
        AbstractFileApplicationNoteBookComponent
        AbstractFileBrowser
        AbstractLauncherApplication
        AbstractSettingsApplication
        Bookmark
        BookmarkBar
        BookmarkEditor
        BookmarkList
        BookmarkListEditor
        BookmarkVisitor
        BookmarksEditDialog
        BrowserView
        ChangesBrowser
        CodeCompletionHelpMenuView
        CodeCompletionHelpView
        CodeGenerator
        CodeGeneratorTool
        DebugView
        Diff
        Diff2
        Diff3
        Diff3Hunk
        Diff3InclusiveVisitor
        Diff3TextView
        DiffListUtility
        DiffTextView
        DisplayObjectView
        EditFieldWithCompletion
        EditFieldWithCompletionSpec
        EventMonitor
        FileBrowser
        FileBrowserV2PanelView
        FileBrowserV2SettingsDialog
        FileBrowserV2UISpecifications
        FileDialog
        FileOperation
        FilenameEditFieldV2
        InspectorView
        MemoryMonitor
        MemoryMonitorView
        MemoryUsageView
        MultiViewToolApplication
        (NewChangesBrowser autoload)
        PerforceSourceCodeManagerUtilities
        ProcessMonitorV2
        RCSConflictEditTextView
        SyntaxElement
        SyntaxHighlighter2
        SystemBrowser
        SystemStatusMonitor
        #'Tools::AbstractTestRunner'
        #'Tools::BreakpointBrowser'
        #'Tools::Browslet'
        #'Tools::BrowsletCanvas'
        #'Tools::CachedTags'
        #'Tools::ChangeSetBrowser2'
        #'Tools::ChangeSetDiffInfo'
        #'Tools::ChangeSetDiffTool'
        #'Tools::ChangeSetSelectionDialog'
        #'Tools::ChangeSetSpec'
        #'Tools::CheckinInfoDialog'
        #'Tools::ClassChecker'
        #'Tools::ClassSorter'
        #'Tools::CodeCompletionMenu'
        #'Tools::CodeCritics'
        #'Tools::CodeView2'
        #'Tools::CodeViewService'
        #'Tools::DiffCodeView2'
        #'Tools::HierarchicalChangesetDialog'
        #'Tools::InlineMessageDialog'
        #'Tools::Inspector2'
        #'Tools::Inspector2Tab'
        #'Tools::LintAnnotation'
        #'Tools::LintHighlighter'
        #'Tools::LintRuleDetail'
        #'Tools::LintRuleEditDialog'
        #'Tools::LintRuleSelectionDialog'
        #'Tools::MethodCategoryCache'
        #'Tools::MethodRewriter'
        #'Tools::NavigationHistory'
        #'Tools::NavigationState'
        #'Tools::NavigatorModel'
        #'Tools::NewClassWizardDialog'
        #'Tools::NewSystemBrowserCodeView'
        #'Tools::Profiler'
        #'Tools::ProfilerInfoBuilder'
        #'Tools::ProfilerInfoItem'
        #'Tools::ProjectCheckerBrowser'
        #'Tools::ProjectLoader'
        #'Tools::SearchDialog'
        #'Tools::SmalltalkDiffTool'
        #'Tools::SourceCodeManagerConfigurationTestTool'
        #'Tools::SpecialCodeView'
        #'Tools::StringSearchTool'
        #'Tools::Tag'
        #'Tools::TagList'
        #'Tools::TagsBrowser'
        #'Tools::TextDiffTool'
        #'Tools::TextMergeInfo'
        #'Tools::Toolbox'
        #'Tools::WebBrowserPage'
        VersionDiffBrowser
        ViewWithAcceptAndCancelBar
        #'stx_libtool'
        AbstractDirectoryBrowser
        AbstractFileFinderApplicationComponent
        AbstractSourceCodeManagementSettingsAppl
        BookmarkMenuBuilder
        ChangeSetBrowser
        ClassInspectorView
        ContextInspectorView
        DictionaryInspectorView
        Diff3ExclusiveVisitor
        DiffCodeView
        ExternalStreamMonitor
        FileApplicationNoteBook
        FileBrowserV2
        FileBrowserV2SettingsAppl
        FileDialogWithPreview
        ImageInspectorView
        NewLauncher
        OrderedCollectionInspectorView
        ParseTreeIndex
        SetInspectorView
        SettingsDialog
        SmalltalkCodeGeneratorTool
        SyntaxElementVariable
        TerminalApplication
        #'Tools::BackgroundSourceProcessingService'
        #'Tools::BreakpointService'
        #'Tools::BrowserList'
        #'Tools::CodeCompletionService'
        #'Tools::CodeNavigationService'
        #'Tools::CodeView2SettingsAppl'
        #'Tools::Diff2CodeView2'
        #'Tools::Diff3CodeView2'
        #'Tools::FontSettingsApplication'
        #'Tools::GenericToolbox'
        #'Tools::LintRuleSettingsApplication'
        #'Tools::LintService'
        #'Tools::NavigatorCanvas'
        #'Tools::NewSystemBrowser'
        #'Tools::OrganizerCanvas'
        #'Tools::SendersBrowslet'
        #'Tools::StringSearchToolForTextView'
        #'Tools::TestRunnerMini'
        #'Tools::TextDiff2Tool'
        #'Tools::TextDiff3Tool'
        #'Tools::VisualProfilerCanvas'
        WorkspaceApplication
        BookmarkAddMenuBuilder
        BookmarkToolbarMenuBuilder
        CVSSourceCodeManagementSettingsAppl
        DataBaseSourceCodeManagementSettingsAppl
        DirectoryContentsBrowser
        DirectoryDifferenceViewApplication
        DirectoryTreeBrowser
        FileBasedSourceCodeManagementSettingsAppl
        FindFileApplication
        GitSourceCodeManagementSettingsAppl
        MercurialSourceCodeManagementSettingsAppl
        PerforceSourceCodeManagementSettingsAppl
        StoreSourceCodeManagementSettingsAppl
        #'Tools::BrowserListWithFilter'
        #'Tools::ClassCategoryList'
        #'Tools::ClassGeneratorList'
        #'Tools::ClassList'
        #'Tools::CodeHighlightingService'
        #'Tools::LintRuleList'
        #'Tools::MethodCategoryList'
        #'Tools::MethodList'
        #'Tools::NamespaceList'
        #'Tools::ProjectList'
        #'Tools::SmalltalkToolbox'
        #'Tools::TestRunnerEmbedded'
        #'Tools::VariableList'
        #'Tools::ChangeList'
        #'Tools::ChangeSetDiffList'
        #'Tools::FullMethodCategoryList'
        #'Tools::HierarchicalClassCategoryList'
        #'Tools::HierarchicalClassList'
        #'Tools::HierarchicalLintRuleList'
        #'Tools::HierarchicalProjectList'
        #'Tools::ImplementingClassList'
        #'Tools::ImplementingMethodList'
        #'Tools::NamespaceFilter'
        #'Tools::TestRunner2'
        #'Tools::HierarchicalChangeList'
        #'Tools::HierarchicalPackageFilterList'
        #'Tools::InheritanceClassList'
        (AbstractRevisionItem autoload)
        (AbstractVersionDiffBrowserItem autoload)
        (ApplicationBuilder autoload)
        (ClassItem autoload)
        (ClassItemRoot autoload)
        (ClassItemRootForRevision autoload)
        (ClassNameItem autoload)
        (ClassRevisionTree autoload)
        (CodeGeneratorTests autoload)
        (ColorInspectorView autoload)
        (EWorldIconLibrary autoload)
        (ExpandableRevisionItem autoload)
        (FileBrowserV2Tests autoload)
        (FileDialogV2 autoload)
        (HierarchicalClassRevisionList autoload)
        (HierarchicalVersionDiffBrowser autoload)
        (Launcher autoload)
        (LibraryBuilder autoload)
        (OldLauncher autoload)
        (ProcessMonitor autoload)
        (ProjectView autoload)
        (SemaphoreMonitor autoload)
        (SmalltalkInspectorView autoload)
        (ClassVariablesInspectorView autoload)
        (SourceRevisionItem autoload)
        (TextDiffTests autoload)
        (#'Tools::CodeView2DemoApp' autoload)
        (#'Tools::CompilerWarningToDoListEntry' autoload)
        (#'Tools::DiffCodeView2DemoApp' autoload)
        (#'Tools::NavigationHistoryTests' autoload)
        (#'Tools::SmalltalkMergeTool' autoload)
        (#'Tools::ToDoList' autoload)
        (#'Tools::ToDoListBrowser' autoload)
        (#'Tools::ToDoListEntry' autoload)
        (#'Tools::ToDoNotification' autoload)
        (VersionRevisionItem autoload)
        (XTermView autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        ApplicationModel inspectorExtraAttributes
        Array inspectorValueStringInListFor:
        ArrayedCollection inspector2TabForHexDump
        Bag inspectorExtraAttributes
        Behavior iconInBrowserSymbol
        Behavior inspectorExtraAttributes
        Behavior inspectorValueStringInListFor:
        Behavior methodsCount
        Block inspectorExtraAttributes
        Boolean inspectorValueStringInListFor:
        Breakpoint icon
        BreakpointDescription icon
        ByteArray inspectorExtraAttributes
        Change flattenOnto:
        Change flattenedChanges
        Change removed
        Change removed:
        ChangeSet condenseChangesForRemoved
        ChangeSet flattenOnto:
        ChangeSet flattenedChanges
        ChangeSet inspector2TabBrowser
        ChangeSet inspector2Tabs
        Character inspectorExtraAttributes
        Character inspectorValueStringInListFor:
        CharacterArray inspector2TabBytes
        CharacterArray inspector2TabDiff
        CharacterArray inspector2TabHTML
        CharacterArray inspector2TabText
        CharacterArray inspector2TabXMLTree
        CharacterArray inspector2Tabs
        CharacterArray inspectorExtraAttributes
        CharacterArray inspectorValueStringInListFor:
        Class inspectorClass
        ClassDescription iconInBrowserForVariableNamed:
        Collection inspectorValueStringInListFor:
        Color inspectorClass
        Color inspectorExtraAttributes
        Color inspectorValueStringInListFor:
        CompositeChange condenseChangesForRemoved
        CompositeChange flattenOnto:
        CompositeChange removed
        CompositeChange removed:
        Date inspectorExtraAttributes
        Date inspectorValueStringInListFor:
        Dictionary inspector2TabLabel
        Dictionary inspectorClass
        EditTextView absoluteXOfPosition:
        EditTextView absoluteYOfCursor
        EditTextView xOfPosition:
        EditTextView yOfCursor
        EditTextView yOfPosition:
        ExecutableFunction printStringForBrowserWithSelector:
        ExternalLibraryFunction inspectorExtraAttributes
        FileStream inspectorExtraMenuOperations
        Filename inspector2TabContentsView
        Form inspectorClass
        Image inspector2TabImage
        Image inspector2Tabs
        Image inspectorClass
        Image inspectorExtraAttributes
        Image inspectorExtraMenuOperations
        ImmutableArray inspectorValueStringInListFor:
        Integer inspectorExtraAttributes
        Interval inspectorValueStringInListFor:
        Iterator inspectorValueStringInListFor:
        LimitedPrecisionReal inspectorExtraAttributes
        MenuView shortKeys
        Method inspectorExtraAttributes
        Method printStringForBrowserWithSelector:inClass:
        Method selectorPrintStringInBrowserFor:
        Method selectorPrintStringInBrowserFor:class:
        MethodDictionary inspectorClass
        MultiImage inspectorClass
        NonPositionableExternalStream inspectorExtraMenuOperations
        Object inspector2TabClass
        Object inspector2TabCommon
        Object inspector2TabDisplayObject
        Object inspector2TabForBasicInspect
        Object inspector2TabForInspectorClass
        Object inspector2TabLabel
        Object inspector2Tabs
        Object inspectorExtraAttributes
        Object inspectorValueStringInListFor:
        Object isTestCaseLike
        Object newInspector2Tab
        OrderedCollection inspectorClass
        Point inspectorValueStringInListFor:
        PopUpMenu asMenu
        ProfileTree method
        ProfileTree package
        ProgrammingLanguage displayString
        ProgrammingLanguage toolbox
        ProgrammingLanguage toolboxClass
        Rectangle inspectorValueStringInListFor:
        RunArray inspectorClass
        SelectionInListModelView textStartLeft
        SelectionInListModelView textStartLeft:
        Set inspectorClass
        SimpleView inspectorExtraAttributes
        SimpleView isCodeView2
        SmallInteger inspectorExtraAttributes
        SmalltalkLanguage compilerClassForInteractiveTools
        SocketAddress inspectorValueStringInListFor:
        StringCollection inspector2TabText
        StringCollection inspector2Tabs
        Symbol formattedCode
        Symbol inspectorValueStringInListFor:
        Text inspector2TabText
        Text inspectorExtraAttributes
        Time inspectorValueStringInListFor:
        Timestamp inspectorExtraAttributes
        Timestamp inspectorValueStringInListFor:
        UUID inspectorValueStringInListFor:
        UndefinedObject inspectorValueStringInListFor:
        UninterpretedBytes inspector2Tabs
        UserPreferences alwaysOpenNewTabWhenCtrlClick
        UserPreferences alwaysOpenNewTabWhenCtrlClick:
        UserPreferences changesBrowserClassName
        UserPreferences codeView2AutoIndent
        UserPreferences codeView2AutoIndent:
        UserPreferences codeView2ShowAcceptCancel
        UserPreferences codeView2ShowAcceptCancel:
        UserPreferences confirmRefactorings
        UserPreferences confirmRefactorings:
        UserPreferences fileBrowserClass
        UserPreferences fileBrowserClass:
        UserPreferences fileBrowserClassName
        UserPreferences showBookmarkBar
        UserPreferences showBookmarkBar:
        UserPreferences showEmbeddedTestRunnerInBrowser
        UserPreferences showEmbeddedTestRunnerInBrowser:
        UserPreferences showGlobalHistory
        UserPreferences showGlobalHistory:
        UserPreferences showLocalHistory
        UserPreferences showLocalHistory:
        UserPreferences showMethodTemplate
        UserPreferences showMethodTemplate:
        UserPreferences sortAndIndentClassesByInheritance
        UserPreferences sortAndIndentClassesByInheritance:
        UserPreferences sourceCodeManagementMenuLayout
        UserPreferences sourceCodeManagementMenuLayout:
        UserPreferences useCodeView2In:
        UserPreferences useCodeView2InBrowser
        UserPreferences useCodeView2InBrowser:
        UserPreferences useCodeView2InDebugger
        UserPreferences useCodeView2InDebugger:
        UserPreferences useCodeView2InTools
        UserPreferences useCodeView2InTools:
        UserPreferences useCodeView2InWorkspace
        UserPreferences useCodeView2InWorkspace:
        UserPreferences useInPlaceSearchInBrowserLists
        UserPreferences useInPlaceSearchInBrowserLists:
        UserPreferences webBrowserLikeLayout
        UserPreferences webBrowserLikeLayout:
        'AbstractSyntaxHighlighter class' formatExpression:in:elementsInto:
        'AbstractSyntaxHighlighter class' formatMethod:in:using:elementsInto:
        'AbstractTime class' iconInBrowserSymbol
        'Autoload class' inspectorExtraAttributes
        'Collection class' iconInBrowserSymbol
        'Date class' iconInBrowserSymbol
        'Error class' iconInBrowserSymbol
        'GenericException class' iconInBrowserSymbol
        'GenericToolbarIconLibrary class' bookmarks22x22
        'GenericToolbarIconLibrary class' bug16x16Icon
        'GenericToolbarIconLibrary class' bug24x24Icon
        'GenericToolbarIconLibrary class' bug32x32Icon
        'GenericToolbarIconLibrary class' lint16x16Icon
        'GenericToolbarIconLibrary class' lint24x24Icon
        'GenericToolbarIconLibrary class' lint32x32Icon
        'GenericToolbarIconLibrary class' smalllintWarning16x16
        'GenericToolbarIconLibrary class' versionMerged24x24
        'LibraryDefinition class' iconInBrowserSymbol
        'NameSpace class' inspectorClass
        'Notification class' iconInBrowserSymbol
        'ProjectDefinition class' iconInBrowserSymbol
        'Query class' iconInBrowserSymbol
        'SharedPool class' iconInBrowserSymbol
        'SimpleView class' iconInBrowserSymbol
        'Smalltalk class' inspectorClass
        'StandaloneStartup class' iconInBrowserSymbol
        'Warning class' iconInBrowserSymbol
        'AbstractSyntaxHighlighter class' formatStatements:in:elementsInto:
        Image inspector2TabImageCreatorClass
    )
! !

!stx_libtool class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:02 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Tools'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:18:51 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libtool class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "

    ^ '$URL:: https://vranyj1@swing.fit.cvut.cz/svn/stx/libtool/branches/jv/stx_libtool.st                                           $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'8088            '"$"
! !

!stx_libtool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

