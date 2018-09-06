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

Button subclass:#MotionButton
	instanceVariableNames:'oldBorderWidth'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Obsolete'
!

!MotionButton class methodsFor:'documentation'!

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

    a motionButton highlights itself whenever the cursor
    walks into it ...
    ... this is no longer needed, since every button now
    supports this.
"
! !

!MotionButton methodsFor:'events'!

pointerEnter:state x:x y:y
    oldBorderWidth := self borderWidth.
    self borderWidth:(oldBorderWidth * 2)
!

pointerLeave:state
    self borderWidth:oldBorderWidth
! !

!MotionButton methodsFor:'initialization'!

initEvents
    super initEvents.
    self enableEnterLeaveEvents
! !

!MotionButton class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/MotionButton.st,v 1.7 2013-08-31 09:10:43 cg Exp $'
! !

