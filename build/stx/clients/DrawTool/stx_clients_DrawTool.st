"{ Package: 'stx:clients/DrawTool' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_clients_DrawTool
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_clients_DrawTool class methodsFor:'documentation'!

documentation
"
    Package documentation:

    This was one of the very first demo programs in ST/X.
    A macDraw-like structured drawing program and model classes.
    By today's standards, this looks minimalistic and ugly.
    But then (mid 80s), this was a cool thing.
    The model classes are still used as superclass for a few leftover
    graphic utilities (for example, the OOM package).
    But over time, these will probably vanish.
"
! !

!stx_clients_DrawTool class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
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
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_clients_DrawTool "
        #'stx:libview'    "DeviceGraphicsContext - superclass of DrawView "
        #'stx:libview2'    "DisplayObject - superclass of DrawArrow "
        #'stx:libwidg'    "ListView - superclass of LineMenu "
    )
!

preRequisites
    ^ #(
'stx:goodies/postscript'
'stx:libbasic'
'stx:libbasic2'
'stx:libtool'
'stx:libview'
'stx:libview2'
'stx:libwidg'
'stx:libwidg2'
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
        #'stx:goodies/postscript'    "PSGraphicsContext - referenced by DrawTool>>doPreview "
        #'stx:libbasic2'    "Arrow - referenced by DrawLine>>arrowFor:in: "
        #'stx:libtool'    "AboutBox - referenced by DrawTool>>initMenu "
        #'stx:libwidg2'    "ImageSelectionBox - referenced by DrawTool>>doImport "
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

!stx_clients_DrawTool class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        DrawObject
        DrawTool
        DrawView
        PatternMenu
        #'stx_clients_DrawTool'
        DrawEllipse
        DrawGroup
        DrawLine
        DrawPolygon
        DrawRectangle
        DrawText
        LineMenu
        RectangularDrawObject
        DrawArrow
        DrawCircle
        DrawCurve
        DrawHLine
        DrawImage
        DrawRectangle3D
        DrawRoundRectangle
        DrawSpline
        DrawVLine
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_clients_DrawTool class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2006\nCopyright eXept Software AG 1998-2006'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_clients_DrawTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/stx_clients_DrawTool.st,v 1.9 2016-03-09 18:50:28 cg Exp $'
! !

