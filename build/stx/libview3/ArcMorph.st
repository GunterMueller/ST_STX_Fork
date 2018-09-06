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

Morph subclass:#ArcMorph
	instanceVariableNames:'startAngle sweepAngle closePath pie startAngleHolder
		sweepAngleHolder closePathHolder pieHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Display Objects'
!

!ArcMorph class methodsFor:'documentation'!

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
    I represent a filled or unfilled arc/circle or pie.
"
! !

!ArcMorph methodsFor:'accessing'!

closePath
    ^ closePathHolder value ? closePath ? false
!

closePath:aBoolean
    closePath := aBoolean.
    self invalidate.
!

closePathHolder
    ^ closePathHolder
!

closePathHolder:something
    closePathHolder removeDependent:self.
    closePathHolder := something.
    closePathHolder notNil ifTrue:[ closePathHolder addDependent:self].
!

pie
    ^ pieHolder value ? pie ? false
!

pie:aBoolean
    pie := aBoolean.
    self invalidate.
!

pieHolder
    ^ pieHolder
!

pieHolder:something
    pieHolder removeDependent:self.
    pieHolder := something.
    pieHolder notNil ifTrue:[ pieHolder addDependent:self].
!

startAngle
    ^ startAngleHolder value ? startAngle ? 0
!

startAngle:something
    startAngle := something.
    self invalidate.
!

startAngleHolder
    ^ startAngleHolder
!

startAngleHolder:something
    startAngleHolder removeDependent:self.
    startAngleHolder := something.
    startAngleHolder notNil ifTrue:[ startAngleHolder addDependent:self].
!

sweepAngle
    ^ sweepAngleHolder value ? sweepAngle ? 360
!

sweepAngle:something
    sweepAngle := something.
    self invalidate.
!

sweepAngleHolder
    ^ sweepAngleHolder
!

sweepAngleHolder:something
    sweepAngleHolder removeDependent:self.
    sweepAngleHolder := something.
    sweepAngleHolder notNil ifTrue:[ sweepAngleHolder addDependent:self].
! !

!ArcMorph methodsFor:'drawing'!

displayInsideOn:aGC 
    |fg start angle p center p1 p2|

    (fillHolder value ? fill ? false) ifTrue:[
        fg := foregroundColorHolder value ? foregroundColor.
        fg notNil ifTrue:[
            start := startAngleHolder value ? startAngle ? 0.
            angle := sweepAngleHolder value ? sweepAngle ? 360.

            aGC paint:fg.
            aGC fillArcIn:frame from:start angle:angle.

            p := pieHolder value ? pie ? false.
            p ifFalse:[
                center := frame center.
                p1 := Point r:1 degrees:start negated.
                p2 := Point r:1 degrees:(start + angle) negated.
                p1 := center + (p1 * (frame extent) * 0.5).
                p2 := center + (p2 * (frame extent) * 0.5).

                aGC fillPolygon:{ p1. center. p2 }.

                aGC lineWidth:2.
                aGC displayLineFrom:p1 to:center.
                aGC displayLineFrom:center to:p2.
                aGC lineWidth:0.
            ].
        ].
    ].
!

displayOn:aGC
    |view|

    view := self view.
    view notNil ifTrue:[    
        view 
            clippedTo:(self bounds)
            do:[
                super displayOn:aGC
            ]
    ].
!

displayOutsideOn:aGC
    |lc start angle lw p1 p2 center c p|

    (lineHolder value ? line ? false) ifTrue:[
        lc := lineColorHolder value ? lineColor.
        lc notNil ifTrue:[
            angle := sweepAngleHolder value ? sweepAngle ? 360.

            start := startAngleHolder value ? startAngle ? 0.

            lw := lineWidthHolder value ? lineWidth ? 0.

            aGC paint:lc.
            aGC lineWidth:lw.
            aGC displayArcIn:(frame insetBy:lw // 2) from:start angle:angle.

            angle >= 360 ifTrue:[^ self].

            c := closePathHolder value ? closePath ? false.
            p := pieHolder value ? pie ? false.
            (c or:[p]) ifTrue:[
                center := frame center.
                p1 := Point r:1 degrees:start negated.
                p2 := Point r:1 degrees:(start + angle) negated.
                p1 := center + (p1 * (frame extent) * 0.5).
                p2 := center + (p2 * (frame extent) * 0.5).

                p ifTrue:[
                    aGC displayLineFrom:p1 to:center.
                    aGC displayLineFrom:center to:p2.
                ] ifFalse:[
                    aGC displayLineFrom:p1 to:p2.
                ].
            ].
        ].
    ].
! !

!ArcMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview3/ArcMorph.st,v 1.12 2009-09-29 11:27:51 sr Exp $'
! !
