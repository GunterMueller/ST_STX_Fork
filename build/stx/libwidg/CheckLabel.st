"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

Label subclass:#CheckLabel
	instanceVariableNames:'hasFocus'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!CheckLabel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    used for labels in checkBoxes;
    the only added functionality is the focus-frame
    drawn around.
    This is used with win95 styles only.
"
! !

!CheckLabel methodsFor:'accessing'!

hasFocus:something
    "set the value of the instance variable 'hasFocus' (automatically generated)"

    hasFocus := something.

    "Created: / 17.9.1998 / 14:17:51 / cg"
! !

!CheckLabel methodsFor:'queries'!

hasFocus
    "return the value of the instance variable 'hasFocus' (automatically generated)"

    ^ hasFocus

    "Created: / 17.9.1998 / 14:17:51 / cg"
! !

!CheckLabel methodsFor:'redrawing'!

drawWith:fg and:bg
    super drawWith:fg and:bg.
    hasFocus == true ifTrue:[ self drawFocusFrame ].

    "Created: / 17.9.1998 / 14:16:07 / cg"
    "Modified: / 17.9.1998 / 14:17:40 / cg"
! !

!CheckLabel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/CheckLabel.st,v 1.5 2014-12-02 18:19:38 cg Exp $'
! !

