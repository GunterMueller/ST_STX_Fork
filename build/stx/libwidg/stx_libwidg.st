"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libwidg
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libwidg class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
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
    Package Documentation

    This library contains elementary GUI components (widgets), such as Buttons, InputFields,
    TextEditors, Scrollbars etc.

    All of these widgets are written in 100% pure Smalltalk. 
    They do not depend upon any particular underlying graphic system (by the operating system). 
    Instead, they build upon the abstraction layer as provided by libview.
    Arguably, this has both advantages and disadvantages:
    for one, the ST/X widgets may not look&feel 100% like their native counterparts, especially
    on systems which constantly change (i.e. Windows).
    On the other hand, this frees us completely from any development there, 
    and gets us rid of big problems when looks, feels or even APIs change.

    Just consider the following historic fact:
        when motif was modern, people asked for a native motif style...
        ... a few years later for qt, then gnome, and what next?
        We'd be constantly adapting to new frameworks and not get any work done,
        if we were depending on native widgets

    Also, this might even make problems, if widget frameorks on different systems 
    (i.e. X vs. Windows vs. Cocoa) provide different levels of functionality.
"
! !

!stx_libwidg class methodsFor:'accessing - hg - settings'!

hgEnsureCopyrightMethod
    "If true, then #copyright method is automatically compiled in each class
     (but iff project definition defines it)

     Default is true (compile such method) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to not compile them
     to keep changes against CVS minimal"

    ^false

    "Created: / 09-10-2013 / 15:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgEnsureVersion_HGMethod
    "If true, then #version_HG method is automatically compiled in each class.

     Default is true (compile such method) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to not compile them
     to keep changes against CVS minimal. 

     If false, version_HG is compiled only in classes that has been modified
     and commited.

     Note that Mercurial can live without them
     just fine"

    ^false

    "Created: / 09-10-2013 / 15:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hgRemoveContainesForDeletedClasses
    "If true, then containers for removed classes are __AUTOMATICALLY__ removed from the
     repositoru. If false, obsolete containes are kept.

     Default is true (remove obsolete containers) but if the repository is mirror of CVS and
     you want to merge back to CVS at some point, you may want to return false to avoid deletions
     of obsolete files. Usefull when branching off an old CVS repo with loads of mess."

    ^false

    "Created: / 09-10-2013 / 15:39:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libwidg class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
        #'stx:libjavascript'    "JavaScriptParser - referenced by Workspace>>browseImplementorsOfIt "
        #'stx:goodies/communication'    "HTTPInterface - referenced by EditTextView>>editMenu "
        #'stx:goodies/soap'    "SOAP::SoapImplError - referenced by EditTextView>>googleSpellingSuggestion "
        #'stx:goodies/soap/examples'    "SOAP::BabelFishClient - referenced by EditTextView>>babelFishTranslate: "
        #'stx:libcomp'    "Parser - referenced by EditTextView>>executeKeyboardMacro: "
        #'stx:libhtml'    "HTMLDocumentView - referenced by DialogBox>>addHelpButtonFor: "
        #'stx:libtool'    "SystemBrowser - referenced by Workspace>>browseImplementorsOfIt "
        #'stx:libwidg2'    "FilenameEditField - referenced by DialogBox>>addFilenameInputFieldOn:in:tabable: "
    )
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
        #'stx:libbasic'    "Collection - extended"
        #'stx:libview'    "Controller - superclass of ButtonController"
        #'stx:libview2'    "Model - superclass of MultiSelectionInList"
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
        #'stx:goodies/regex'    "Regex::RxMatcher - referenced by TextView>>openSearchBoxAndSearch"
        #'stx:libbasic2'    "ActorStream - referenced by TextCollector>>initialize"
        #'stx:libbasic3'    "MessageTally - referenced by Workspace>>spyOnIt"
        #'stx:libui'    "ActionButtonSpec - referenced by Button>>specClass"
    )

    "Modified: / 26-06-2018 / 09:30:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_libwidg class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBWIDG_BASE
LIB_BASE=$(LIBWIDG_BASE)
'
!

stcOptimizationOptions
    ^ '+optinline'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libwidg class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        ButtonController
        CodeViewTheme
        DialogBox
        EditTextViewCompletionSupport
        EnterFieldGroup
        FramedBox
        GenericToolbarIconLibrary
        Label
        ListView
        ListViewController
        MenuEvent
        ObjectView
        PanelView
        PopUpMenu
        PullDownMenu
        RadioButtonGroup
        ScrollBar
        ScrollableView
        Scroller
        SelectionInList
        VariablePanel
        VariablePanelController
        #'stx_libwidg'
        Button
        CheckLabel
        DragRectangleController
        EnterBox
        FontPanel
        HVScrollableView
        HorizontalPanelView
        HorizontalScrollBar
        HorizontalScroller
        InfoBox
        MiniScroller
        MultiColumnPanelView
        MultiSelectionInList
        OptionBox
        PopUpListController
        SelectionInListView
        SequenceView
        TextView
        ToggleController
        VariableHorizontalPanel
        VariableHorizontalPanelController
        VariableVerticalPanel
        VariableVerticalPanelController
        VerticalPanelView
        WorkspaceCompletionSupport
        XPToolbarIconLibrary
        ArrowButton
        EditTextView
        EnterBox2
        FileSelectionList
        HorizontalMiniScroller
        ListSelectionBox
        MacOSXToolbarIconLibrary
        MenuView
        PopUpList
        RadioButtonController
        Toggle
        VistaToolbarIconLibrary
        WarningBox
        AdwaitaToolbarIconLibrary
        CheckToggle
        ClickMenuView
        EditField
        FileSelectionBox
        MacOSX2ToolbarIconLibrary
        RadioButton
        TextCollector
        Windows8ToolbarIconLibrary
        YesNoBox
        FileSaveBox
        Workspace
        CodeView
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        UserPreferences codeViewTheme
        UserPreferences codeViewTheme:
        UserPreferences assignmentHighlightEmphasis
        UserPreferences selectorHighlightEmphasis
        UserPreferences variableHighlightEmphasis
    )
! !

!stx_libwidg class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:47:47 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Elementary Widgets'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:19:22 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libwidg class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

