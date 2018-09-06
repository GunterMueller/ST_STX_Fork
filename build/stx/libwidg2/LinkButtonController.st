"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

ButtonController subclass:#LinkButtonController
	instanceVariableNames:'lastX lastY'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!LinkButtonController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    see info in LinkButton
"
! !

!LinkButtonController methodsFor:'accessing'!

lastMousePoint
    lastX isNil ifTrue:[^ nil].
    ^ lastX @ lastY
! !

!LinkButtonController methodsFor:'event handling'!

buttonMotion:buttonState x:x y:y
    lastX := x.
    lastY := y.
    view invalidate.
    super buttonMotion:buttonState x:x y:y.
!

buttonPress:button x:x y:y
    |action|

    lastX := x.
    lastY := y.

    action := view actionAt:(self lastMousePoint).
    action notNil ifTrue:[
        action value.
    ].
!

buttonRelease:button x:x y:y
    lastX := x.
    lastY := y.
    super buttonRelease:button x:x y:y.
!

pointerEnter:buttonState x:x y:y
    lastX := x.
    lastY := y.
    view invalidate.
    super pointerEnter:buttonState x:x y:y.
!

pointerLeave:buttonState 
    lastX := lastY := nil.
    view invalidate.
    super pointerLeave:buttonState.
! !

!LinkButtonController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/LinkButtonController.st,v 1.4 2009-03-09 14:17:12 cg Exp $'
! !
