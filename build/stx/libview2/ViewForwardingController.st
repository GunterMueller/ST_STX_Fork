"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Controller subclass:#ViewForwardingController
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!ViewForwardingController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    ViewForwardingControllers are dummy controllers, which forward their events
    to the view.

    These can be used in places where a controller is wanted, but the
    view does all user interaction - for example, to be able to interact
    with ST-80 models, which expect the view to have a controller,
    and access this via: view controller ...

    These are not used by ST/X.

    [author:]
        Claus Gittinger
"

! !

!ViewForwardingController methodsFor:'event handling'!

buttonMultiPress:button x:x y:y
    "button was pressed again quickly"

    ^ view buttonMultiPress:button x:x y:y

    "Created: 17.1.1997 / 22:47:49 / cg"
    "Modified: 17.1.1997 / 22:49:22 / cg"
!

buttonPress:button x:x y:y
    "button was pressed"

    ^ view buttonPress:button x:x y:y

    "Created: 17.1.1997 / 22:48:31 / cg"
    "Modified: 17.1.1997 / 22:49:08 / cg"
!

buttonRelease:button x:x y:y
    "button was released"

    ^ view buttonRelease:button x:x y:y

    "Modified: 17.1.1997 / 22:49:02 / cg"
!

keyPress:key x:x y:y
    "key was pressed"

    ^ view keyPress:key x:x y:y

    "Created: 17.1.1997 / 22:49:47 / cg"
!

keyRelease:key x:x y:y
    "key was released"

    ^ view keyRelease:key x:x y:y

    "Created: 17.1.1997 / 22:49:59 / cg"
!

pointerEnter:state x:x y:y
    "mouse pointer entered my view"

    ^ view pointerEnter:state x:x y:y

    "Created: 17.1.1997 / 22:50:14 / cg"
!

pointerLeave:state
    "mouse pointer left my view"

    ^ view pointerLeave:state

    "Created: 17.1.1997 / 22:50:32 / cg"
! !

!ViewForwardingController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ViewForwardingController.st,v 1.2 1997-01-17 21:54:35 cg Exp $'
! !

