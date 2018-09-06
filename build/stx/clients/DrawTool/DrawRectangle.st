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
"{ Package: 'stx:clients/DrawTool' }"

DrawObject subclass:#DrawRectangle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawRectangle class methodsFor:'documentation'!

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
    I represent rectangles
"
! !

!DrawRectangle class methodsFor:'interface to DrawView'!

userFriendlyName
    ^ 'rectangle'

    "Created: 23.4.1997 / 12:02:21 / cg"
! !

!DrawRectangle methodsFor:'converting'!

asDrawPolygon
    "return a polygon, representing me"

    ^ DrawPolygon new fromDrawRectangle:self.


!

asDrawRoundRectangle
    "return a rounded rectangle, representing my bounds"

    ^ DrawRoundRectangle new origin:(self origin) corner:(self corner).
!

asDrawSpline
    "return a spline, representing me"

    ^ DrawSpline new fromDrawRectangle:self.


!

canBeConvertedToPolygon
    ^ true
!

canBeConvertedToRoundRectangle
    ^ true
! !

!DrawRectangle methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |r org oldStyle|

    org := origin + anOffset.
    r := Rectangle origin:org corner:(corner + anOffset).

"/    (lineWidth == 1) ifTrue:[
"/        aGC lineWidth:0
"/    ] ifFalse:[
        aGC lineWidth:lineWidth.
"/    ].
    aGC maskOrigin:org.

    oldStyle :=  aGC lineStyle.
    (lineStyle notNil and:[lineStyle ~~ oldStyle]) ifTrue:[
        aGC lineStyle:lineStyle
    ].

    fillPattern notNil ifTrue:[
        self withFillPatternAsPaintIn:aGC 
            do:[ aGC fillRectangle:r ]
            ifTransparentDo:[ aGC fillRectangle:(r insetBy:(lineWidth//2)) ].
    ].

    linePattern notNil ifTrue:[
        self lineGC:aGC with:[aGC displayRectangle:r]
    ].
    "leave gc in some known state"
    lineWidth > 0 ifTrue:[
        aGC lineWidth:0.
    ].
    lineStyle ~~ oldStyle ifTrue:[
        aGC lineStyle:oldStyle
    ].

    "Modified: 4.6.1996 / 19:11:40 / cg"
! !

!DrawRectangle methodsFor:'rotating'!

rotate90 
    |center|

    center := self center.
    "/ self origin:(center
! !

!DrawRectangle methodsFor:'testing'!

isHitBy:hitPoint withDelta:hitDelta
    "return true, if rectangle is hit by point"

    |lw delta top bottom left right dLeft dRight dTop dBot|

    (super isHitBy:hitPoint withDelta:hitDelta) ifFalse:[^ false].

    "if I have a fillpattern, we have a hit"
    fillPattern notNil ifTrue:[^ true].

    lw := (lineWidth // 2) + 1.
    delta := hitDelta + lw.

    "otherwise, check the 4 outlines"

    left := origin x.
    right := corner x.
    top := origin y.
    bottom := corner y.

    dLeft := left - delta.
    dRight := right + delta.
    dTop := top - delta.
    dBot := bottom + delta.

    "check area around top edge"
    ((Rectangle left:dLeft right:dRight
		 top:dTop bottom:(top + delta)) containsPoint:hitPoint)
	ifTrue:[^ true].

    "check area around bottom edge"
    ((Rectangle left:dLeft right:dRight
		 top:(bottom - delta) bottom:dBot) containsPoint:hitPoint)
	ifTrue:[^ true].

    "check area around left edge"
    ((Rectangle left:dLeft right:(left + delta)
		 top:dTop bottom:dBot) containsPoint:hitPoint)
	ifTrue:[^ true].

    "check area around right edge"
    ^ (Rectangle left:(right - delta) right:dRight
		  top:dTop bottom:dBot) containsPoint:hitPoint
! !

!DrawRectangle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawRectangle.st,v 1.17 2008-07-09 15:39:40 stefan Exp $'
! !
