"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

Button subclass:#MenuButton
	instanceVariableNames:'enterAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Obsolete'
!

!MenuButton class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    this is obsolete

    these objects implement the special buttons used for pull-down-menu-bars.
    they highlight on enter events (while pressed) and perform their
    action on release.
    This is no longer needed, since every button (& buttonController)
    now supports this behavior.
"
! !

!MenuButton methodsFor:'accessing'!

enterAction:aBlock
    enterAction := aBlock
! !

!MenuButton methodsFor:'events'!

pointerEnter:state x:x y:y
    (state bitTest:(device bitButton1)) ifTrue:[
	self turnOn.
	enterAction notNil ifTrue:[enterAction value]
    ]
! !

!MenuButton methodsFor:'initialization'!

initEvents
    super initEvents.
    self enableEnterEvents
! !

!MenuButton class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/MenuButton.st,v 1.7 2013-08-31 09:10:41 cg Exp $'
! !

