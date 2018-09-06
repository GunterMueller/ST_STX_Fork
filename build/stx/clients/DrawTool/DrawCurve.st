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

DrawPolygon subclass:#DrawCurve
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawCurve class methodsFor:'documentation'!

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
    this class represents free-hand polygons
"
! !

!DrawCurve class methodsFor:'interface to DrawView'!

needsAllMovePoints
    ^ true
!

needsMultiPointCreate
    ^ true
!

userFriendlyName
    ^ 'curve'

    "Created: 23.4.1997 / 12:01:14 / cg"
! !

!DrawCurve class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawCurve.st,v 1.9 2000-02-08 09:18:30 cg Exp $'
! !
