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

DrawObject subclass:#DrawEllipse
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawEllipse class methodsFor:'documentation'!

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
    this class represents ellipses (and circles)
"
! !

!DrawEllipse class methodsFor:'DrawView interface'!

userFriendlyName
    ^ 'ellipse'

    "Created: 23.4.1997 / 12:01:23 / cg"
! !

!DrawEllipse methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |xpos ypos w h org oldStyle|

    w := corner x - origin x "+ 1".
    h := corner y - origin y "+ 1".
    org := origin + anOffset.
    xpos := org x.
    ypos := org y.

"/    (lineWidth == 1) ifTrue:[
"/        aGC lineWidth:0
"/    ] ifFalse:[
        aGC lineWidth:lineWidth.
"/    ].

    oldStyle :=  aGC lineStyle.
    (lineStyle notNil and:[lineStyle ~~ oldStyle]) ifTrue:[
        aGC lineStyle:lineStyle
    ].
    aGC maskOrigin:org.

    fillPattern notNil ifTrue:[
        self withFillPatternAsPaintIn:aGC 
            do:[ 
                aGC fillArcX:xpos y:ypos width:w height:h from:0 angle:360 
            ]
            ifTransparentDo:[ 
                aGC fillArcX:xpos+(lineWidth//2) 
                    y:ypos+(lineWidth//2)
                    width:w-lineWidth 
                    height:h-lineWidth
                    from:0 angle:360 
            ].
    ].

    linePattern notNil ifTrue:[
        self lineGC:aGC with:[
            aGC displayArcX:xpos y:ypos width:w height:h from:0 angle:360
        ]
    ].
    "leave gc in some known state"
    lineWidth > 0 ifTrue:[
        aGC lineWidth:0.
    ].
    lineStyle ~~ oldStyle ifTrue:[
        aGC lineStyle:oldStyle
    ].

    "Modified: 4.6.1996 / 19:13:19 / cg"
!

drawOutlineIn:aGC offset:anOffset
    |xpos ypos w h halfLw|

    "for slow servers, draw outline as a rectangle"
"
    super drawOutlineIn:aGC offset:anOffset.
    ^ self.
"

    aGC lineWidth:0.

    w := corner x - origin x "+ 1".
    h := corner y - origin y "+ 1".
    xpos := origin x + anOffset x.
    ypos := origin y + anOffset y.

    lineWidth > 2 ifTrue:[
        "draw twice"
        halfLw := lineWidth // 2.
        aGC displayArcX:xpos-halfLw y:ypos-halfLw 
                      width:w+lineWidth height:h+lineWidth 
                      from:0 angle:360.
        aGC displayArcX:xpos+halfLw y:ypos+halfLw 
                      width:w-lineWidth height:h-lineWidth 
                      from:0 angle:360
    ] ifFalse:[
        aGC displayArcX:xpos y:ypos width:w height:h from:0 angle:360
    ]

    "Modified: 4.6.1996 / 15:35:51 / cg"
! !

!DrawEllipse methodsFor:'inside check'!

isHitBy:hitPoint withDelta:hitDelta
    "return true, if circle/ellipse is hit by point"

    |cx cy a b lw delta
     aMin aMax bMin bMax
     aSquared bSquared
     aMinSquared aMaxSquared bMinSquared bMaxSquared
     px py xSquared ySquared x2PlusY2
     t1 t2|

    "quick boundary check"
    (super isHitBy:hitPoint withDelta:hitDelta) ifFalse:[^ false].

    lw := (lineWidth // 2) + 1.
    delta := hitDelta + lw.

    a := (corner x - origin x) // 2.
    b := (corner y - origin y) // 2.

    cx := origin x + a.
    cy := origin y + b.

    px := hitPoint x - cx.
    py := hitPoint y - cy.

    xSquared := px * px.
    ySquared := py * py.

    a == b ifTrue:[
	"its a circle"
	x2PlusY2 := xSquared + ySquared.
	fillPattern isNil ifTrue:[
	    "outline check"
	    aMin := a - delta.
	    aMinSquared := aMin * aMin.
	    x2PlusY2 < aMinSquared ifTrue:[^ false].
	    aMax := a + delta.
	    aMaxSquared := aMax * aMax.
	    x2PlusY2 > aMaxSquared ifTrue:[^ false].
	    ^ true
	] ifFalse:[
	    "area check"
	    aSquared := a * a.
	    x2PlusY2 <= aSquared ifTrue:[^ true]
	].
	^ false
    ].

    "an ellipse"
    fillPattern isNil ifTrue:[
	"outline check"
	"had to divide expression into smaller steps, since many
	 c-compilers have problems compiling complicated exprs"
	aMin := a - delta.
	aMinSquared := aMin * aMin.
	bMin := b - delta.
	bMinSquared := bMin * bMin.
	t1 := (bMinSquared * xSquared) + (aMinSquared * ySquared).
	t2 := (aMinSquared * bMinSquared).
	t1 < t2 ifTrue:[^ false].
	aMax := a + delta.
	aMaxSquared := aMax * aMax.
	bMax := b + delta.
	bMaxSquared := bMax * bMax.
	t1 := (bMaxSquared * xSquared) + (aMaxSquared * ySquared).
	t2 := (aMaxSquared * bMaxSquared).
	t1 > t2 ifTrue:[^ false].
	^ true
    ] ifFalse:[
	"area check"
	aSquared := a * a.
	bSquared := b * b.
	t1 := (bSquared * xSquared) + (aSquared * ySquared).
	t2 := (aSquared * bSquared).
	t1 <= t2 ifTrue:[^ true]
    ].
    ^ false
! !

!DrawEllipse class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawEllipse.st,v 1.16 2008-09-26 10:56:34 stefan Exp $'
! !
