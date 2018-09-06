"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview3' }"

"{ NameSpace: Smalltalk }"

Morph subclass:#LineSegmentMorph
	instanceVariableNames:'startPoint endPoint showArrow arrowStyle arrowPosition
		startPointHolder endPointHolder showArrowHolder arrowStyleHolder
		arrowPositionHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Display Objects'
!

!LineSegmentMorph class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by Claus Gittinger
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
    I represent a lineSegment.
    Optionally, I show an arrow at some postition (0..1) along the line.
"
! !

!LineSegmentMorph methodsFor:'accessing'!

arrowPosition
    ^ arrowPosition
!

arrowPosition:something
    arrowPosition := something.
    self invalidate.
!

arrowPositionHolder:something
    arrowPositionHolder removeDependent:self.
    arrowPositionHolder := something.
    arrowPositionHolder notNil ifTrue:[ arrowPositionHolder addDependent:self ].
!

arrowStyle
    ^ arrowStyle
!

arrowStyle:something
    arrowStyle := something.
    self invalidate.
!

arrowStyleHolder:something
    arrowStyleHolder removeDependent:self.
    arrowStyleHolder := something.
    arrowStyleHolder notNil ifTrue:[ arrowStyleHolder addDependent:self ].
!

endPoint
    ^ endPoint
!

endPoint:something
    self possiblyInvalidate.

    endPoint := something.
    frame := nil.

    self possiblyInvalidate.
!

endPointHolder:something
    endPointHolder removeDependent:self.
    endPointHolder := something.
    endPointHolder notNil ifTrue:[ endPointHolder addDependent:self ].
!

showArrow
    ^ showArrow
!

showArrow:something
    showArrow := something.
    self invalidate.
!

showArrowHolder:something
    showArrowHolder removeDependent:self.
    showArrowHolder := something.
    showArrowHolder notNil ifTrue:[ showArrowHolder addDependent:self ].
!

startPoint
    ^ startPoint
!

startPoint:something
    self possiblyInvalidate.

    startPoint := something.
    frame := nil.

    self possiblyInvalidate.
!

startPoint:startPointArg endPoint:endPointArg 
    self possiblyInvalidate.

    startPoint := startPointArg.
    endPoint := endPointArg.

    frame := nil.
    self possiblyInvalidate.
!

startPointHolder:something
    startPointHolder removeDependent:self.
    startPointHolder := something.
    startPointHolder notNil ifTrue:[ startPointHolder addDependent:self ].
! !

!LineSegmentMorph methodsFor:'drawing'!

displayOn:aGC
    |isArrow arrow p1 p2|

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ old ST80 means: draw-yourself on a GC.
    (aGC isStream or:[aGC == Transcript]) ifTrue:[
        self printOn:aGC.
        ^ self
    ].

    (visibilityHolder value ? true) ifFalse:[ ^ self ].

    p1 := startPointHolder value ? startPoint.
    p1 isNil ifTrue:[^ self].
    p2 := endPointHolder value ? endPoint.
    p2 isNil ifTrue:[^ self].

    aGC paint:(lineColorHolder value ? lineColor ? Color black).

    isArrow := showArrowHolder value ? showArrow ? false.
    isArrow ifFalse:[
        aGC displayLineFrom:p1 to:p2.
    ] ifTrue:[
        arrow := Arrow from:p1 to:p2.
        arrow arrowHeadPosition:( arrowPositionHolder value ? arrowPosition ? 1.0 ).
        (fillHolder value ? fill ? false) ifTrue:[
            arrow displayFilledOn:aGC
        ] ifFalse:[
            arrow displayStrokedOn:aGC
        ].
    ].

    "Modified (format): / 22-02-2017 / 16:54:41 / cg"
! !

!LineSegmentMorph methodsFor:'geometry'!

computeBoundingBox
    |p1 p2 ext startX startY endX endY|

    p1 := originHolder value ? startPoint.
    p1 isNil ifTrue:[^ nil].

    (ext := extentHolder value) notNil ifTrue:[
        p2 := p1 + ext - (1@1).
    ].
    p2 := p2 ? endPoint.
    p2 isNil ifTrue:[^ nil].
    
    startX := p1 x.
    endX := p2 x.
    startY := p1 y.
    endY := p2 y.

    frame := (startX min:endX) @ (startY min:endY) 
                corner:((startX max:endX)+1) @ ((startY max:endY)+1).

    frame := frame insetBy:(Arrow defaultLength negated).
    ^ frame
!

geometryLayout
    ^ nil.
!

geometryLayout:newLayoutOrNil
    self halt.
! !

!LineSegmentMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/LineSegmentMorph.st,v 1.8 2017-02-22 17:58:15 cg Exp $'
! !

