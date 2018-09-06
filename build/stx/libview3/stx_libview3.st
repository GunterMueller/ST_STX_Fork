"
 COPYRIGHT (c) Claus Gittinger / 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview3' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_libview3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_libview3 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2009 by eXept Software AG
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

    This library contains additional, less frequently used and mostly experimental
    graphics-interfacing components and infrastructure. 

    Especially support for a new UI-component scheme (morphic) is found here, although it
    may not yet be in a state which is fit for end-user applications.

    [author:]
        cg

    [primary maintainer:]
        cg
"
! !

!stx_libview3 class methodsFor:'description'!

excludedFromPreRequisites
    ^ #(
        #'stx:libtool2'    "UISelectionPanel - referenced by SketchMorph>>displayInsideOn: "
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
        #'stx:libbasic'    "ProjectDefinition - superclass of stx_libview3 "
        #'stx:libui'    "NamedSpec - superclass of DisplayObjectComponentSpec "
        #'stx:libview2'    "VisualComponent - superclass of LineSegmentMorph "
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
        #'stx:libbasic2'    "Arrow - referenced by LineSegmentMorph>>computeBoundingBox "
        #'stx:libview'    "Depth1Image - referenced by ArcMorphSpec class>>iconUnfilled "
    )
! !

!stx_libview3 class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        DisplayObjectComponentSpec
        Morph
        #'stx_libview3'
        ArcMorph
        ArcMorphSpec
        LineSegmentMorph
        LineSegmentMorphSpec
        RectangleMorph
        RectangleMorphSpec
        SketchMorph
        SketchMorphSpec
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector."

    ^ #(
    )
! !

!stx_libview3 class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Claus Gittinger / eXept Software AG'

    "Modified: / 18-11-2016 / 11:47:50 / cg"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Additional Graphic Interfacing 2'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988\nCopyright eXept Software AG 2012'

    "Modified: / 18-11-2016 / 12:19:14 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_libview3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/stx_libview3.st,v 1.27 2017-02-22 15:38:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview3/stx_libview3.st,v 1.27 2017-02-22 15:38:18 cg Exp $'
! !

