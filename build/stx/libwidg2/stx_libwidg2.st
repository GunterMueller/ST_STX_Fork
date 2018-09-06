"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libwidg2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libwidg2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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

    This library contains additional gui components (widgets).

    These are less often used and can (in theory) be left out of very simple end-user
    applications.
"
! !

!stx_libwidg2 class methodsFor:'description'!

additionalClassNamesAndAttributes
    ^ #(
        "/ <className> or (<className> attributes...)
    )

    "Created: / 21-08-2006 / 19:52:03 / cg"
!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:clients/Demos'    "CodingExamples_GUI::GUIDemoNoteBook - referenced by TabItem class>>test "
        #'stx:goodies'    "IdentityDictionaryWithDefault - referenced by GridBagLayoutInfo>>initialize "
        #'stx:goodies/postscript'    "PSGraphicsContext - referenced by ImageEditView>>printWithMagnification: "
        #'stx:libtool'    "FileBrowser - referenced by HierarchicalFileList::Directory>>icon "
        #'stx:libtool2'    "ImageEditor - referenced by ImageEditView class>>classResources "
        #'stx:libwidg3'    "ClockView - referenced by TabItem class>>test "
        #'stx:goodies/refactoryBrowser/parser'    "RBParser - referenced by DoWhatIMeanSupport class>>findNodeForInterval:in: "
        #'stx:libcomp'    "Parser - referenced by DoWhatIMeanSupport class>>codeCompletionForMessage:inClass:codeView: "
        #'stx:libhtml'    "HTMLDocumentView - referenced by LicenceBox>>initialize "
        #'stx:goodies/refactoryBrowser/browser'    "RefactoryTyper - referenced by DoWhatIMeanSupport>>codeCompletionForMessage:inClass:instance:context:codeView:"
        #'stx:libboss'    "ObsoleteObject - referenced by DoWhatIMeanSupport>>codeCompletionForMessage:inClass:instance:context:codeView:"
        #'stx:libbasic3'    "SourceCodeManagerError - referenced by DoWhatIMeanSupport>>addClassesOfInstVarNamed:inClass:to:"
        #'stx:libjavascript'    "JavaScriptCompletionEngine - referenced by DoWhatIMeanSupport>>codeCompletionForJavascriptMethod:orClass:context:codeView:into:"
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "ActivityNotification - superclass of ProgressNotification"
        #'stx:libbasic2'    "List - superclass of HierarchicalFileList"
        #'stx:libview'    "Controller - superclass of LinkButtonController"
        #'stx:libview2'    "ApplicationModel - superclass of AssistantApplication"
        #'stx:libwidg'    "Button - superclass of ComboBoxButton"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:libui'    "ComboBoxSpec - referenced by ComboBoxView>>specClass"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_libwidg2 class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBWIDG2_BASE
LIB_BASE=$(LIBWIDG2_BASE)
'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libwidg2 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        AbstractHierarchicalItem
        AssistantApplication
        CharacterSetView
        CheckBox
        ComboBoxButton
        ComboView
        DSVColumnView
        DSVLabelView
        DataSetColumn
        DataSetLabel
        DataSetView
        DoWhatIMeanSupport
        EnterBoxWithList
        ExtendedComboBox
        FilenameEditField
        FilenameEnterBox
        FilenameWidgetWithHistory
        GridBagConstraints
        GridBagLayoutInfo
        GridBagLayoutView
        HierarchicalDropTargetController
        HierarchicalList
        HierarchyNode
        ImageView
        LabelledEnterField
        LicenceBox
        LinkButton
        LinkButtonController
        ListEntry
        ListModelView
        MenuPanel
        MultipleItemSelectionWidget
        NoteBookView
        PrintAbortDialog
        PrintingDialog
        ProgressIndicator
        ProgressNotification
        SelectionInHierarchy
        SelectionInTree
        SelectionInTreeView
        Separator
        Slider
        SteppingSlider
        SubCanvas
        SyncedMultiColumnTextView
        TabItem
        TabSpecRuler
        TabWidget
        TabulatorSpecification
        TerminalView
        TextBox
        ThumbWheel
        TreeItem
        UpDownButton
        ViewScroller
        #'stx_libwidg2'
        ColorMenu
        ComboBoxView
        ComboListView
        CompactHierarchicalItem
        FileSelectionItem
        FileSelectionTree
        FilenameWidgetWithoutHistory
        FontMenu
        HierarchicalItem
        HorizontalSlider
        HorizontalSteppingSlider
        ImageEditView
        ModelListEntry
        MultiColListEntry
        PluggableHierarchicalList
        SelectionInListModelView
        TabView
        ThreeColumnTextView
        TreeItemWithImage
        TriggerBox
        TwoColumnTextView
        VT100TerminalView
        FilenameComboBoxView
        HierarchicalFileList
        HierarchicalItemWithLabel
        HierarchicalItemWithValue
        HierarchicalListView
        LabelAndIcon
        HierarchicalItemWithLabelAndIcon
        LabelAndTwoIcons
        HierarchicalItemWithLabelAndIconAndValue
        (ColoredListEntry autoload)
        (ComboBrowseView autoload)
        (ComboUpDownView autoload)
        (GraphColumn autoload)
        (GraphColumnView autoload)
        (GraphColumnView2D autoload)
        (GraphColumnView2DSpec autoload)
        (GraphColumnView3D autoload)
        (GraphColumnView3DSpec autoload)
        (GraphColumnViewSpec autoload)
        (HorizontalScale autoload)
        (ImageSelectionBox autoload)
        (KeyboardView autoload)
        (ListEditor autoload)
        (MenuButton autoload)
        (MotionButton autoload)
        (NoteBookFrameView autoload)
        (ParagraphSpecification autoload)
        (RoundButton autoload)
        (Ruler autoload)
        (Scale autoload)
        (SelectionInHierarchyView autoload)
        (StrokeView autoload)
        (TabControl autoload)
        (TextRuler autoload)
        (VT52TerminalView autoload)
        (VerticalRuler autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
    )
! !

!stx_libwidg2 class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:47:45 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Additional Widgets'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:19:25 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libwidg2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

