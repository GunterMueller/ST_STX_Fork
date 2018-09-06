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

ScrollBar subclass:#HorizontalScrollBar
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!HorizontalScrollBar class methodsFor:'documentation'!

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
    this class implements horizontal scrollbars with scroller and
    2 step-scroll buttons. When moved or stepped, it performs a
    predefined action.

    [author:]
        Claus Gittinger
"
! !

!HorizontalScrollBar methodsFor:'initialization'!

initialize
    orientation := #horizontal.
    super initialize

! !

!HorizontalScrollBar class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/HorizontalScrollBar.st,v 1.29 1999-07-07 18:53:37 cg Exp $'
! !
