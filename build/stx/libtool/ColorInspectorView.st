"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

InspectorView subclass:#ColorInspectorView
	instanceVariableNames:'colorView'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!ColorInspectorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ColorInspectorView class methodsFor:'menu specs'!

colorMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:ColorInspectorView andSelector:#colorMenu
     (Menu new fromLiteralArrayEncoding:(ColorInspectorView colorMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Color Editor'
            itemValue: openColorEditor
            translateLabel: true
          )
         )
        nil
        nil
      )

    "Modified: / 27-01-2011 / 11:49:22 / cg"
! !

!ColorInspectorView methodsFor:'accessing'!

inspect:anObject
    super inspect:anObject.

    colorView viewBackground:anObject.
    realized ifFalse:[^ self].
    colorView clear

    "Modified: / 05-07-2011 / 14:03:48 / cg"
! !

!ColorInspectorView methodsFor:'initialization'!

initialize
    |newPanel sub|

    super initialize.

    newPanel := VariableVerticalPanel in:self.
    newPanel origin:0.0 @ 0.0 corner:1.0 @ 1.0.

    sub := subViews first.
    self removeSubView:sub.
    sub origin:0.0@0.0 corner:1.0@0.8.
    newPanel addSubView:sub.

    colorView := View in:newPanel.
    colorView origin:(0.0 @ 0.8) corner:(1.0 @ 1.0).
    colorView 
        menuHolder:(self class colorMenu);
        menuPerformer:self

    "
     ColorInspectorView inspect:(Color yellow)
     ColorInspectorView inspect:(Color name:'brown') lightened)
    "
! !

!ColorInspectorView methodsFor:'menu'!

optionalToolItems
    "inserted after inspect/browse"

    ^ #(
        ('Color Editor'             #openColorEditor)
      ).

    "Modified: / 27-01-2011 / 11:51:53 / cg"
! !

!ColorInspectorView methodsFor:'user actions'!

openColorEditor
    ColorEditDialog openOn:inspectedObject
! !

!ColorInspectorView class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/ColorInspectorView.st,v 1.14 2011/07/05 12:04:32 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: ColorInspectorView.st 7944 2012-03-19 15:32:45Z vranyj1 $'
! !

