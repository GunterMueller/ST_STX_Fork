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

"{ Package: 'stx:libwidg' }"

Scroller subclass:#HorizontalScroller
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!HorizontalScroller class methodsFor:'documentation'!

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
    Actually simply a scroller which preinitializes itself to have
    a horizontal orientation.

    [author:]
        Claus Gittinger
"
! !

!HorizontalScroller methodsFor:'initialization'!

initialize
    orientation := #horizontal. 
    super initialize.

    "Modified: / 7.3.1999 / 00:01:08 / cg"
! !

!HorizontalScroller class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/HorizontalScroller.st,v 1.17 2005-05-11 16:36:28 stefan Exp $'
! !
