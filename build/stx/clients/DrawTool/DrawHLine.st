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

DrawLine subclass:#DrawHLine
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawHLine class methodsFor:'documentation'!

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
    this class represents horizontal only line segments
"
! !

!DrawHLine class methodsFor:'DrawView interface'!

userFriendlyName
    ^ 'horizontal line'

    "Created: 23.4.1997 / 12:01:39 / cg"
! !

!DrawHLine methodsFor:'accessing'!

firstPoint:aPoint
    p1 := aPoint x @ p2 y.
    self computeBoundingBox


!

origin:origin corner:corner
    p1 := origin.
    p2 := corner x @ origin y.
    self computeBoundingBox


!

secondPoint:aPoint
    p2 := aPoint x @ origin y.
    self computeBoundingBox


! !

!DrawHLine class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawHLine.st,v 1.4 1997-04-23 11:46:32 cg Exp $'
! !
