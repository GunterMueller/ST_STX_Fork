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

DrawLine subclass:#DrawVLine
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawVLine class methodsFor:'documentation'!

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
    this class represents vertical only line segments
"
! !

!DrawVLine class methodsFor:'DrawView interface'!

userFriendlyName
    ^ 'vertical line'

    "Created: 23.4.1997 / 12:03:10 / cg"
! !

!DrawVLine methodsFor:'accessing'!

firstPoint:aPoint
    p1 := p1 x @ aPoint y.
    self computeBoundingBox


!

origin:origin corner:corner
    p1 := origin.
    p2 := origin x @ corner y.
    self computeBoundingBox


!

secondPoint:aPoint
    p2 := origin x @ aPoint y.
    self computeBoundingBox


! !

!DrawVLine class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawVLine.st,v 1.4 1997-04-23 11:46:39 cg Exp $'
! !
