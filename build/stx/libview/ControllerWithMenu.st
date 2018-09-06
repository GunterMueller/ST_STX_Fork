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
"{ Package: 'stx:libview' }"

Controller subclass:#ControllerWithMenu
	instanceVariableNames:'menuHolder performer'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!ControllerWithMenu class methodsFor:'documentation'!

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
!

documentation
"
    ControllerWithMenus is a very simple controller for a view with
    a middleButtonMenu.
    This class currently exists for ST-80 compatibility only.
"
! !

!ControllerWithMenu methodsFor:'accessing'!

menu
    "can be redefined in subclasses"

    menuHolder notNil ifTrue:[
	^ menuHolder value
    ].
    ^ nil
!

menuHolder
    ^ menuHolder
!

menuHolder:aValueHolder
    menuHolder := aValueHolder
!

performer 
    ^ performer 
!

performer:anObject
    performer  := anObject
! !

!ControllerWithMenu methodsFor:'events'!

yellowButtonActivity
    |m selection|

    (m := self menu) notNil ifTrue:[
        selection := m startUp.
        (selection notNil and: [selection ~~ 0]) ifTrue:[
            performer perform:selection
        ]
    ]
! !

!ControllerWithMenu methodsFor:'initialization'!

initialize
    "I am the default menu performer"

    performer := self.
    menuHolder := nil asValue
! !

!ControllerWithMenu class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/ControllerWithMenu.st,v 1.9 2005-04-18 16:29:58 cg Exp $'
! !

