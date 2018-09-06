"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libui
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libui class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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

    This library contains UI interface spec classes used with the UI-Builder framework.

    Applications which were created with the UI-painter will need this package
    (i.e. programs which do not build the UI programmatically).

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libui class methodsFor:'description'!

excludedFromPreRequisites
    "avoid preRequisite cycles"

    ^ #(
        #'stx:libbasic2'    "Text - referenced by SelectionInListModelViewSpec>>setAttributesIn:with: "
        #'stx:libcompat'    "TextAttributes - referenced by UISpecification>>setStyle:in:with: "
        #'stx:libtool2'    "ResourceSelectionBrowser - referenced by SelectionInListModelViewSpec>>setAttributesIn:with: "
        #'stx:libwidg'    "SelectionInList - referenced by SequenceViewSpec>>defaultModelClassFor: "
        #'stx:libwidg2'
        #'stx:libview2'    "VisualRegion - referenced by RegionSpec>>viewClass "
    )
!

mandatoryPreRequisites
    "list all required mandatory packages.
     Packages are mandatory, if they contain superclasses of the package's classes
     or classes which are extended by this package.
     This list can be maintained manually or (better) generated and
     updated by scanning the superclass hierarchies
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libbasic'    "IdentityDictionary - superclass of UISpecification::UIBindingsIdentityDictionary "
    )
!

referencedPreRequisites
    "list all packages containing classes referenced by the packages's members.
     This list can be maintained manually or (better) generated and
     updated by looking for global variable accesses
     (the browser has a menu function for that)
     However, often too much is found, and you may want to explicitely
     exclude individual packages in the #excludedFromPreRequisites method."

    ^ #(
        #'stx:libview'    "Depth1Image - referenced by MenuPanelSpec class>>icon "
    )
! !

!stx_libui class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBUI_BASE
LIB_BASE=$(LIBUI_BASE)
'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libui class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        DataSetColumnSpec
        SubChannelInfoSpec
        UIPalette
        UISpecVisitor
        UISpecification
        #'stx_libui'
        ComponentSpec
        DividerSpec
        NoteBookSpec
        RegionSpec
        UIEventCallbackSubSpec
        UnknownSpec
        CompositeSpec
        CompositeSpecCollection
        NamedSpec
        SeparatorSpec
        SpecCollection
        TabControlSpec
        UISubSpecification
        ViewWithLabelSpec
        ViewWithSubcomponentsSpec
        WindowSpec
        ColorMenuSpec
        FontMenuSpec
        FullSpec
        LabelSpec
        MenuComponentSpec
        ProgressIndicatorSpec
        ScrollableViewSpec
        ScrollerSpec
        ViewSpec
        ViewWithLabelAndModelSpec
        WidgetSpec
        ActionButtonSpec
        CheckBoxSpec
        ComboListSpec
        ExtendedComboBoxSpec
        FramedBoxSpec
        InputFieldSpec
        MenuPanelSpec
        PanelViewSpec
        PopUpListSpec
        RoundProgressIndicatorSpec
        ScrollBarSpec
        SliderSpec
        TabViewSpec
        TableViewSpec
        TransparentBoxSpec
        UpDownButtonSpec
        VariablePanelSpec
        ViewWithScrollerSpec
        ArbitraryComponentSpec
        ArrowButtonSpec
        ButtonSpec
        ComboBoxSpec
        DataSetSpec
        FilenameInputFieldSpec
        GridBagLayoutViewSpec
        GroupBoxSpec
        HTMLViewSpec
        HorizontalPanelViewSpec
        LinkButtonSpec
        ListModelViewSpec
        MenuButtonSpec
        MultiColumnPanelViewSpec
        NoteBookViewSpec
        SelectionInTreeViewSpec
        SequenceViewSpec
        SteppingSliderSpec
        SubCanvasSpec
        TextEditorSpec
        ThumbWheelSpec
        ToggleSpec
        VariableHorizontalPanelSpec
        VariableVerticalPanelSpec
        VerticalPanelViewSpec
        CheckToggleSpec
        FileSelectionTreeSpec
        NonScrollableArbitraryComponentSpec
        RadioButtonSpec
        SelectionInListModelViewSpec
        TextCollectorSpec
        UIGalleryViewSpec
        WorkspaceSpec
        CodeViewSpec
        HierarchicalListViewSpec
        AssistantPageSpec
        TriggerBoxSpec
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libui class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:47:57 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X UI Specifications'
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1999\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:19:02 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libui class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/stx_libui.st,v 1.44 2017-11-25 12:35:28 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libui/stx_libui.st,v 1.44 2017-11-25 12:35:28 cg Exp $'
! !

