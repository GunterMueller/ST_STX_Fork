"
 COPYRIGHT (c) 2006 by Claus Gittinger / eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libhtml
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libhtml class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by Claus Gittinger / eXept Software AG
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

    This library contains a simple HTML viewer (browser) used for the online documentation,
    and to show help dialogs.
    
    This HTML viewer uses a very old HTML parser and related support classes to
    represent html elements, which are also found here.
    Some of the stuff has been redesigned and obsoleted by the alternatives found in goodies:webServer/hatmlTree

    This package is mostly closed for new development: it is only used with the HTML tree and will
    only be maintained to remain functional for online-doc reading - not improved.

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libhtml class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
        #'stx:goodies/communication'    "FTPClient - referenced by HTMLDocumentFrame>>imageFor:now: "
        #'stx:goodies/postscript'    "PSGraphicsContext - referenced by HTMLDocumentPainter>>aEnd "
        #'stx:libbasic2'    "SharedQueue - referenced by HTMLDocumentPainter>>img "
        #'stx:libbasic3'    "HTMLDocGenerator - referenced by HTMLDocumentFrame>>pseudoDocumentStreamForManPageFile: "
        #'stx:libboss'    "BinaryObjectStorage - referenced by HTMLDocumentFrame>>appletClass:fromURL:archive: "
        #'stx:libcomp'    "Parser - referenced by HTMLDocumentFrame>>submitDoitMethod:form: "
        #'stx:libjava'    "JavaClassReader - referenced by HTMLDocumentView>>menu_settings "
        #'stx:libjavascript'    "JavaScriptParser - referenced by HTMLParser>>script_javascript: "
        #'stx:libtool'    "WorkspaceApplication - referenced by HTMLDocumentFrame>>workspaceOnExampleText "
        #'stx:libview2'    "GIFReader - referenced by HTMLDocumentFrame>>imageFor:now: "
        #'stx:libwidg2'    "CheckBox - referenced by HTMLDocumentView>>menu_settings "
        #'stx:clients/MailTool'    "SendMailTool - referenced by DidYouKnowTipViewer>>doAddTip "
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
        #'stx:libbasic'    "Query - superclass of HTMLDocumentPainter::WidgetQuery "
        #'stx:libview'    "GraphicsContext - superclass of HTMLView "
        #'stx:libwidg'    "ScrollableView - superclass of HTMLView "
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
    )
! !

!stx_libhtml class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBHTML_BASE
LIB_BASE=$(LIBHTML_BASE)
'
! !

!stx_libhtml class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        DidYouKnowTipViewer
        HTMLDocument
        HTMLDocumentFrame
        HTMLDocumentInterpreter
        HTMLDocumentViewerApplication
        HTMLElement
        HTMLFontStyle
        HTMLPageStyle
        HTMLParser
        HTMLScriptEnvironment
        HTMLTableCol
        HTMLTableRow
        HTMLView
        URL
        #'stx_libhtml'
        HTMLDocumentPainter
        HTMLDocumentView
        HTMLMarkup
        HTMLText
        HTMLAnchor
        HTMLBullet
        HTMLCRMarkupText
        HTMLForm
        HTMLList
        HTMLMarkupText
        HTMLScript
        HTMLStyle
        HTMLTable
        HTMLWidget
        HTMLApplet
        HTMLImage
        (Applet autoload)
        (HTMLDocumentPrinter autoload)
        (HTMLFilterStream autoload)
        (HTMLWriteStream autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libhtml class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:48:12 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X HTML Support and Browser'
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1999\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:18:36 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libhtml class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/stx_libhtml.st,v 1.39 2017-02-22 15:39:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/stx_libhtml.st,v 1.39 2017-02-22 15:39:58 cg Exp $'
! !

