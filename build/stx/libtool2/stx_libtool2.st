"
 COPYRIGHT (c) 1988 by Claus Gitinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libtool2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libtool2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gitinger / 2006 by eXept Software AG
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

    This library contains additional advanced ST/X development tools.
    This includes new improved browser, additional analysis, monitoring and profiling tools, 
    UI builders etc.

    Typically, these tools are not needed in end-user (standAlone) applications.    
"
! !

!stx_libtool2 class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:clients/Demos'    "WindowTreeView - referenced by FlyByWindowInformation>>keyPress:x:y:view: "
        #'stx:goodies/webServer'    "HTTPServer - referenced by UIPainter>>doInstallAsWebPage "
        #'exept:httpPortal'    "WebApplicationModel - referenced by UIPainter>>canInstallAsWebPage "
        #'stx:goodies/communication'    "HTTPInterface - referenced by ImageEditor>>doLoadFromURL "
        #'stx:libview3'    "LineSegmentMorph - referenced by UIObjectView class>>isHorizontalResizable: "
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
        #'stx:libbasic'    "Array - superclass of DataSetBuilder::Row "
        #'stx:libview'    "GraphicsContext - superclass of UIGalleryView::Palette "
        #'stx:libview2'    "ResourceSpecEditor - superclass of TabListEditor "
        #'stx:libwidg'    "ListView - superclass of UIPainter::TreeView "
        #'stx:libwidg2'    "HierarchicalItem - superclass of MenuEditor::RegularMenuItem "
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
        #'stx:libbasic2'    "TextStream - referenced by Tools::ProjectBuilder>>build "
        #'stx:libbasic3'    "CVSSourceCodeManager - referenced by Tools::ObjectModuleInformation>>showInfoForClassLib: "
        #'stx:libcomp'    "ObjectFileLoader - referenced by Tools::ObjectModuleInformation>>postBuildWith: "
        #'stx:libhtml'    "HTMLDocumentView - referenced by MethodFinderWindow>>openHTMLDocumentation "
        #'stx:libtool'    "SmalltalkCodeGeneratorTool - referenced by MenuEditor>>doGenerateAspectMethods "
        #'stx:libui'    "HorizontalPanelViewSpec - referenced by UIPainterView>>groupSelectionWithLayout: "
    )
! !

!stx_libtool2 class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBTOOL2_BASE
LIB_BASE=$(LIBTOOL2_BASE)
'
!

stcWarningOptions
    ^ '-warnNonStandard -warnUnused'
! !

!stx_libtool2 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        ColorEditDialog
        DataSetBuilder
        DirectoryView
        FlyByWindowInformation
        (HierarchicalListEditor autoload)
        ImageEditor
        MenuEditor
        MethodFinderWindow
        (MethodSelectionBrowser autoload)
        (ProjectBrowser autoload)
        (STXInstaller autoload)
        SelectionBrowser
        (ShellView autoload)
        (SnapShotImage autoload)
        (SnapShotImageMemory autoload)
        TabListEditor
        (#'Tools::InternationalLanguageTranslationEditor' autoload)
        (#'Tools::NewInspectorList' autoload)
        (#'Tools::NewInspectorListView' autoload)
        (#'Tools::NewInspectorPanelView' autoload)
        (#'Tools::NewInspectorView' autoload)
        #'Tools::ObjectModuleInformation'
        #'Tools::ProjectBuilder'
        #'Tools::ProjectBuilderAssistantApplication'
        (#'Tools::ProjectDefinitionEditor' autoload)
        (#'Tools::ViewTreeInspectorApplication' autoload)
        UIGalleryView
        UIHelpTool
        UILayoutTool
        UIListEditor
        UIObjectView
        UIPainter
        UISelectionPanel
        UISpecificationTool
        #'stx_libtool2'
        FileSelectionBrowser
        ResourceSelectionBrowser
        UIPainterView
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are pairwise elements, consisting of class-name and selector."

    ^ #(
        Image edit
    )
! !

!stx_libtool2 class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:00 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Additional Tools'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:18:55 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libtool2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

