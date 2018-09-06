"
 COPYRIGHT (c) 1996 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/DrawTool' }"

DrawLine subclass:#DrawArrow
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawArrow class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG
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
    this class represents arrows.

    CAVEAT: wide-line arrows look ugly
"

! !

!DrawArrow class methodsFor:'interface to DrawView'!

userFriendlyName
    ^ 'arrow'

    "Created: 23.4.1997 / 12:00:49 / cg"
! !

!DrawArrow methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    self drawArrowIn:aGC offset:anOffset
!

drawOutlineIn:aGC offset:anOffset
    self drawArrowOutlineIn:aGC offset:anOffset
! !

!DrawArrow methodsFor:'frame computations'!

computeBoundingBox
    super computeBoundingBox.
    self computeArrowBoundingBox
! !

!DrawArrow class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawArrow.st,v 1.11 2010-05-03 21:16:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawArrow.st,v 1.11 2010-05-03 21:16:24 cg Exp $'
! !
