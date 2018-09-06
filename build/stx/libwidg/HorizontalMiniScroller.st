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

"{ Package: 'stx:libwidg' }"

MiniScroller subclass:#HorizontalMiniScroller
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!HorizontalMiniScroller class methodsFor:'documentation'!

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
    like a scroller, but taking less screen space.

    [author:]
        Claus Gittinger
"
! !

!HorizontalMiniScroller methodsFor:'initialization'!

initialize
    orientation := #horizontal.
    super initialize.

    "Created: 17.4.1996 / 14:01:26 / cg"
! !

!HorizontalMiniScroller class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/HorizontalMiniScroller.st,v 1.10 2005-05-11 16:36:04 stefan Exp $'
! !
