"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/DrawTool' }"

DrawRectangle subclass:#DrawRectangle3D
	instanceVariableNames:'level'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawRectangle3D class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    I represent rectangles with an edge
"

! !

!DrawRectangle3D methodsFor:'accessing'!

level
    "return the value of the instance variable 'level' (automatically generated)"

    ^ level
!

level:something
    "set the value of the instance variable 'level' (automatically generated)"

    level := something.
! !

!DrawRectangle3D methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |r org t|

    org := origin + anOffset.
    r := Rectangle origin:org corner:(corner + anOffset).

    aGC maskOrigin:org. 
    fillPattern notNil ifTrue:[
        self withFillPatternAsPaintIn:aGC 
            do:[ aGC fillRectangle:r ].
    ].

    "/ sigh - drawEdges does it in device coordinates
    (t := aGC transformation) notNil ifTrue:[
        r := t applyTo:r.
    ].

    aGC
        drawEdgesForX:r left rounded y:r top rounded width:r width rounded height:r height rounded 
        level:(level ? 1)
        shadow:(Color black) 
        light:(Color white)
        halfShadow:(Color black) 
        halfLight:(Color white)
        style:nil .
! !

!DrawRectangle3D class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawRectangle3D.st,v 1.6 2008-07-09 15:38:47 stefan Exp $'
! !
