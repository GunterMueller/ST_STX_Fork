"
 COPYRIGHT (c) 1990 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/DrawTool' }"

DrawRectangle subclass:#DrawRoundRectangle
	instanceVariableNames:'ovalWidth ovalHeight'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool-Objects'
!

!DrawRoundRectangle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    I represent rectangles with round corners
"
! !

!DrawRoundRectangle class methodsFor:'instance creation'!

new
    ^ super new ovalWidth:(self defaultOvalWidth)
	       ovalHeight:(self defaultOvalHeight)
! !

!DrawRoundRectangle class methodsFor:'defaults'!

defaultOvalHeight
    ^ 0.25
!

defaultOvalWidth
    ^ 0.25
! !

!DrawRoundRectangle class methodsFor:'interface to DrawView'!

userFriendlyName
    ^ 'rounded rectangle'

    "Created: 23.4.1997 / 12:02:39 / cg"
! !

!DrawRoundRectangle methodsFor:'converting'!

asDrawRectangle
    "return a rectangle, representing my bounds"

    ^ DrawRectangle new origin:(self origin) corner:(self corner).
!

canBeConvertedToPolygon
    ^ false
!

canBeConvertedToRectangle
    ^ true
!

canBeConvertedToRoundRectangle
    ^ false
! !

!DrawRoundRectangle methodsFor:'drawing'!

drawIn:aGC offset:anOffset
    |org corn w h wCorn hCorn top left right bottom oldStyle|

    org := origin + anOffset.
    corn := corner + anOffset.
    left := org x.
    top := org y.
    right := corn x.
    bottom := corn y.
    w := right - left.
    h := bottom - top.
    wCorn := (w * ovalWidth).
    hCorn := (h * ovalHeight).

    aGC lineWidth:lineWidth.
    oldStyle :=  aGC lineStyle.
    (lineStyle notNil and:[lineStyle ~~ oldStyle]) ifTrue:[
        aGC lineStyle:lineStyle
    ].

    aGC maskOrigin:org.

    fillPattern notNil ifTrue:[
        self withFillPatternAsPaintIn:aGC 
            do:[ 
                self fillLeft:left top:top width:w height:h 
                      wCorner:wCorn hCorner:hCorn in:aGC
            ]
            ifTransparentDo:[ 
                self fillLeft:left+(lineWidth//2)
                     top:top+(lineWidth//2)
                     width:w-lineWidth
                     height:h-lineWidth 
                     wCorner:wCorn hCorner:hCorn in:aGC
            ].
    ].
    linePattern notNil ifTrue:[
        self lineGC:aGC with:[
            self drawLeft:left
                 top:top
                 right:right
                 bottom:bottom
                 wCorner:wCorn hCorner:hCorn in:aGC
        ]
    ].
    "leave gc in some known state"
    lineWidth > 0 ifTrue:[
        aGC lineWidth:0.
    ].
    lineStyle ~~ oldStyle ifTrue:[
        aGC lineStyle:oldStyle
    ].

    "Modified: 4.6.1996 / 19:12:20 / cg"
!

drawLeft:left top:top right:right bottom:bottom wCorner:wCorn hCorner:hCorn in:aGC
    |wC hC wHalf hHalf|

    wC := wCorn.
    hC := hCorn.

    aGC device drawingResolution = aGC device resolution ifTrue:[
        "/ no subpixel addressing is possible ...
        "/ ... must care for rounding errors, when calculating
        "/ halfs.

        wC := (aGC scale x * wC) rounded / aGC scale x.
        hC := (aGC scale y * hC) rounded / aGC scale y.
    ].
    wHalf := wC / 2.
    hHalf := hC / 2.

    "top line"
    aGC displayLineFromX:(left + wHalf - 1) y:top
                     toX:(right - wHalf) y:top.

    "top left arc"
    aGC displayArcX:left 
                  y:top 
              width:wC 
             height:hC 
               from:90 
              angle:90.

    "left line"
    aGC displayLineFromX:left y:(top + hHalf - 1)
                     toX:left y:(bottom - hHalf).

    "top right arc"
    aGC displayArcX:(right - wC) 
                  y:top 
              width:wC 
             height:hC 
               from:0 angle:90.

    "bottom line"
    aGC displayLineFromX:(left + wHalf - 1) y:bottom
                     toX:(right - wHalf) y:bottom.

    "bottom right arc"
    aGC displayArcX:(right - wC) 
                  y:(bottom - hC) 
              width:wC 
             height:hC
               from:270 angle:90.

    "right line"
    aGC displayLineFromX:right y:(top + hHalf - 1)
                     toX:right y:(bottom - hHalf).

    "bottom left arc"
    aGC displayArcX:left 
                  y:(bottom - hC) 
              width:wC 
             height:hC 
               from:180 angle:90

    "Modified: 4.6.1996 / 17:34:36 / cg"
!

drawOutlineIn:aGC offset:anOffset
    |savedLineWidth savedFillPattern savedLinePattern savedLineStyle
     savedOrigin savedCorner savedFg savedBg halfLineWidth|

    savedLineWidth := lineWidth.
    savedFillPattern := fillPattern.
    savedLinePattern := linePattern.
    savedLineStyle := lineStyle.
    savedFg := foreground.
    savedBg := background.

    foreground := aGC foreground.
    background := aGC background.

    lineWidth := 0.
    fillPattern := nil.
    linePattern := 1.
    lineStyle := aGC lineStyle.

    lineWidth <= 3 ifTrue:[
        self drawIn:aGC offset:anOffset.
    ] ifFalse:[
        savedOrigin := origin.
        savedCorner := corner.
        halfLineWidth := savedLineWidth / 2.
        origin := (origin - halfLineWidth) rounded.
        corner := (corner + halfLineWidth) rounded.
        self drawIn:aGC offset:anOffset.
        origin := (savedOrigin + halfLineWidth) rounded.
        corner := (savedCorner - halfLineWidth) rounded.
        self drawIn:aGC offset:anOffset.
        origin := savedOrigin.
        corner := savedCorner.
    ].
    lineWidth := savedLineWidth.
    fillPattern := savedFillPattern.
    linePattern := savedLinePattern.
    lineStyle := savedLineStyle.
    foreground := savedFg.
    background := savedBg

    "Modified: 28.3.1997 / 16:38:07 / cg"
!

fillLeft:left top:top width:w height:h wCorner:wCorn hCorner:hCorn in:aGC
    |right bot wC hC wHalf hHalf|

    right := left + w.
    bot := top + h.

    wC := wCorn.
    hC := hCorn.

    aGC device drawingResolution = aGC device resolution ifTrue:[
        "/ no subpixel addressing is possible ...
        "/ ... must care for rounding errors, when calculating
        "/ halfs.

        wC := (aGC scale x * wC) rounded / aGC scale x.
        hC := (aGC scale y * hC) rounded / aGC scale y.
    ].
    wHalf := wC / 2.
    hHalf := hC / 2.

    aGC fillArcX:left 
               y:top
           width:wC 
          height:hC
            from:90 angle:90.

    "top rect"
    aGC fillRectangleX:(left + wHalf)
                     y:top
                 width:(w - wC)
                height:hHalf.

    "top right arc"
    aGC fillArcX:(right - wC) 
               y:top
           width:wC height:hC
            from:0 angle:90.

    "big middle rect"
    aGC fillRectangleX:left
                     y:(top + hHalf)
                 width:w
                height:(h - hC).

    "bottom left arc"
    aGC fillArcX:left 
               y:(bot - hC)
           width:wC height:hC
            from:180 angle:90.

    "bottom rect"
    aGC fillRectangleX:(left + wHalf)
                     y:(bot - hHalf)
                 width:(w - wC)
                height:hHalf.

    "bottom right arc"
    aGC fillArcX:(right - wC) 
               y:(bot - hC)
           width:wC height:hC
            from:270 angle:90

    "Modified: 4.6.1996 / 17:41:23 / cg"
! !

!DrawRoundRectangle methodsFor:'inside check'!

isHitBy:hitPoint withDelta:hitDelta
    "return true, if round rectangle is hit by point"

    (super isHitBy:hitPoint withDelta:hitDelta) ifFalse:[^ false].

    "should check for arcs here - maybe later"

    ^ true
! !

!DrawRoundRectangle methodsFor:'private'!

ovalWidth:w ovalHeight:h
    ovalWidth := w.
    ovalHeight := h
! !

!DrawRoundRectangle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawRoundRectangle.st,v 1.20 2008-09-26 10:56:46 stefan Exp $'
! !
