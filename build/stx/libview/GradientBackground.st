"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

AbstractBackground subclass:#GradientBackground
	instanceVariableNames:'colors direction cachedForm usedLength'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!GradientBackground class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
"
  demonstrates the various options, which control gradient the effect:
                                                                    [exBegin]
    |bg t c1 c2 c3 v1 v2 v3 v4 v5 v6 v7 v8 l1 l2 l3 l4 l5 l6 l7 l8|

    c1 := Color yellow.
    c2 := Color red.
    c3 := Color blue.
    
    t := TopView new.
    t width:800.
    t maxExtent:800@Display height.
    t minExtent:800@50.
    
    l1 := Label origin:0@0   extent:100@30 in:t.
    l2 := Label origin:100@0 extent:100@30 in:t.
    l3 := Label origin:200@0 extent:100@30 in:t.
    l4 := Label origin:300@0 extent:100@30 in:t.
    l5 := Label origin:400@0 extent:100@30 in:t.
    l6 := Label origin:500@0 extent:100@30 in:t.
    l7 := Label origin:600@0 extent:100@30 in:t.
    l8 := Label origin:700@0 extent:100@30 in:t.

    v1 := View origin:0@30 extent:100@1.0 in:t.
    v2 := View origin:100@30 extent:100@1.0 in:t.
    v3 := View origin:200@30 extent:100@1.0 in:t.
    v4 := View origin:300@30 extent:100@1.0 in:t.
    v5 := View origin:400@30 extent:100@1.0 in:t.
    v6 := View origin:500@30 extent:100@1.0 in:t.
    v7 := View origin:600@30 extent:100@1.0 in:t.
    v8 := View origin:700@30 extent:100@1.0 in:t.
    
    l1 label:'screen'; adjust:#center.
    bg := GradientBackground new color1:c1 color2:c2.
    v1 viewBackground:bg.

    l2 label:'100'; adjust:#center.
    bg := GradientBackground new color1:c1 color2:c2.
    bg usedLength:100.
    v2 viewBackground:bg.

    l3 label:'300'; adjust:#center.
    bg := GradientBackground new color1:c1 color2:c2.
    bg usedLength:300.
    v3 viewBackground:bg.

    l4 label:'view'; adjust:#center.
    bg := GradientBackground new color1:c1 color2:c2.
    bg usedLength:#view.
    v4 viewBackground:bg.

    l5 label:'screen'; adjust:#center.
    bg := GradientBackground new color1:c1 color2:c2 color3:c3.
    v5 viewBackground:bg.

    l6 label:'100'; adjust:#center.
    bg := GradientBackground new color1:c1 color2:c2 color3:c3.
    bg usedLength:100.
    v6 viewBackground:bg.

    l7 label:'300'; adjust:#center.
    bg := GradientBackground new color1:c1 color2:c2 color3:c3.
    bg usedLength:300.
    v7 viewBackground:bg.

    l8 label:'view'; adjust:#center.
    bg := GradientBackground new color1:c1 color2:c2 color3:c3.
    bg usedLength:#view.
    v8 viewBackground:bg.

    t open.
                                                                    [exEnd]
                                                                    
                                                                    [exBegin]
    |bg v|

    bg := GradientBackground new colors:{ Color red . Color green . Color blue . Color red }.
    v := View new extent:300@300.
    v viewBackground:bg.
    v open.
                                                                    [exEnd]
                                                                    [exBegin]
    |bg v|

    bg := GradientBackground new colors:{ Color red . Color green . Color blue . Color red }.
    bg usedLength:#view.
    v := View new extent:300@300.
    v viewBackground:bg.
    v open.
                                                                    [exEnd]
                                                                    [exBegin]
    |bg v|

    bg := GradientBackground new color1:Color red color2:Color yellow.
    v := View new extent:300@300.
    v viewBackground:bg.
    v open.
                                                                    [exEnd]

                                                                    [exBegin]
    |bg v|

    bg := GradientBackground new color1:Color red color2:Color yellow.
    bg usedLength:100.
    v := View new extent:300@300.
    v viewBackground:bg.
    v open.
                                                                    [exEnd]

                                                                    [exBegin]
    |bg v|

    bg := GradientBackground new color1:Color red color2:Color yellow.
    bg usedLength:#view.
    v := View new extent:300@300.
    v viewBackground:bg.
    v open.
                                                                    [exEnd]

                                                                    [exBegin]
    |bg v|

    bg := GradientBackground new color1:Color red color2:Color yellow.
    bg color3:Color green.
    v := View new extent:300@300.
    v viewBackground:bg.
    v open.
                                                                    [exEnd]
                                                                    [exBegin]
    |bg v|

    bg := GradientBackground new color1:Color red color2:Color yellow.
    bg color3:Color green.
    bg usedLength:100.
    v := View new extent:300@300.
    v viewBackground:bg.
    v open.
                                                                    [exEnd]
                                                                    [exBegin]
    |bg v|

    bg := GradientBackground new color1:Color red color2:Color yellow.
    bg color3:Color green.
    bg usedLength:#view.
    v := View new extent:300@300.
    v viewBackground:bg.
    v open.
                                                                    [exEnd]

"
! !

!GradientBackground class methodsFor:'instance creation'!

horizontal:color1 to:color2
    ^ self new 
        direction:#eastWest;
        color1:color1 color2:color2

    "
     |bg v|

     bg := GradientBackground horizontal:Color red to:Color yellow.
     v := View new extent:300@300.
     v viewBackground:bg.
     v open.
    "
    "
     |bg v|

     bg := GradientBackground horizontal:Color red to:Color yellow.
     v := View new extent:300@300.
     v viewBackground:bg.
     v open.
    "
!

vertical:color1 to:color2
    ^ self new 
        direction:#northSouth;
        color1:color1 color2:color2

    "
     |bg v|

     bg := GradientBackground vertical:Color red to:Color yellow.
     v := View new extent:300@300.
     v viewBackground:bg.
     v open.
    "
! !

!GradientBackground class methodsFor:'queries'!

possibleDirections 
    ^ #(#'northSouth' #'eastWest' )
! !

!GradientBackground methodsFor:'accessing'!

color1
    ^ colors at:1

    "Created: / 23-01-2011 / 02:01:29 / cg"
!

color1:aColor
    colors isNil ifTrue:[
        colors := Array new:2.
    ].    
    colors at:1 put:aColor.
    cachedForm := nil.

    "Created: / 23-01-2011 / 02:01:50 / cg"
    "Modified: / 03-02-2011 / 19:49:18 / cg"
!

color1:aColor1 color2:aColor2
    colors isNil ifTrue:[
        colors := Array new:2
    ].    
    colors at:1 put:aColor1.
    colors at:2 put:aColor2.
    cachedForm := nil.

    "Created: / 03-02-2011 / 19:52:59 / cg"
!

color1:aColor1 color2:aColor2 color3:aColor3
    colors isNil ifTrue:[
        colors := Array new:3
    ].    
    colors at:1 put:aColor1.
    colors at:2 put:aColor2.
    colors at:3 put:aColor3.
    cachedForm := nil.

    "Created: / 03-02-2011 / 19:52:59 / cg"
!

color2
    ^ colors at:2

    "Created: / 23-01-2011 / 02:01:32 / cg"
!

color2:aColor
    colors isNil ifTrue:[
        colors := Array new:2.
    ].    
    colors at:2 put:aColor.
    cachedForm := nil.

    "Created: / 23-01-2011 / 02:01:50 / cg"
    "Modified: / 03-02-2011 / 19:49:18 / cg"
!

color3
    ^ colors at:3 ifAbsent:[nil]
!

color3:aColor
    colors isNil ifTrue:[
        colors := Array new:3.
    ] ifFalse:[
        colors size < 3 ifTrue:[
            colors := (Array new:3) replaceFrom:1 with:colors; yourself
        ].    
    ].    
    colors at:3 put:aColor.
    cachedForm := nil.

    "Created: / 23-01-2011 / 02:01:50 / cg"
    "Modified: / 03-02-2011 / 19:49:18 / cg"
!

colors:aColorVector
    colors := aColorVector.
    cachedForm := nil.
!

direction
    "possible values:
        #northSouth
        #eastWest

     others are not yet supported
    "

    (direction == #eastWest or:[direction == #horizontal]) ifTrue:[^ #eastWest].
    ^ #northSouth

    "Modified: / 23-01-2011 / 14:36:36 / cg"
!

direction:something
    "possible values:
        #northSouth
        #eastWest

     others are not yet supported
    "

    direction ~= something ifTrue:[
        direction := something.
        cachedForm := nil.
    ]

    "Modified: / 03-02-2011 / 19:49:41 / cg"
!

usedLength
    ^ usedLength
!

usedLength:nilOrSymbolOrNumber
    "specify:
        nil: use the screen height and interpolate gradient along that
        #view: use the view's height and interpolate gradient along that
        <integer>: interpolate from 0..n, with color2 above that.
        See examples on how each looks"
        
    nilOrSymbolOrNumber == #full ifTrue:[
        "/ backw. compat.
        usedLength := #view
    ] ifFalse:[    
        usedLength := nilOrSymbolOrNumber.
    ]
! !

!GradientBackground methodsFor:'converting'!

asFormOn:aDevice
    |h w len|

"/    usedLength == #view ifTrue:[
"/        self halt:'unsupported'. 
"/        ^ nil
"/    ].

    cachedForm isNil ifTrue:[
        (len := usedLength) == #view ifTrue:[
            len := nil
        ].
        (self direction == #northSouth) ifTrue:[
            h := len ? (aDevice height). "/ aView height.
            w := 8.
        ] ifFalse:[
            h := 8.
            w := len ? (aDevice width).  "/ aView width.
        ].
        cachedForm := Form width:w height:h depth:aDevice depth onDevice:aDevice.
        cachedForm isNil ifTrue:[^nil].
        "/ cachedForm clear.
        self fillRectangleX:0 y:0 width:w height:h in:cachedForm
    ].

    ^ cachedForm

    "Created: / 03-02-2011 / 20:05:30 / cg"
!

onDevice:device
    ^ self asFormOn:device.

    "Created: / 03-02-2011 / 19:56:06 / cg"
! !

!GradientBackground methodsFor:'drawing'!

fillRectangleX:x y:y width:w height:h in:aGC
    "this is a first (very inefficient) try"

    |hHalf wHalf h1 h2 w1 w2 usedHeight usedWidth scaleStartX scaleStartY x2 y2
     usedHeight2 usedWidth2 scaleStartX2 scaleStartY2 direction numSegs 
     usedHeightRange usedWidthRange usedRange startPos endPos
     partRange segOffset segNr pos
     r1 r2 g1 g2 b1 b2 minR maxR minG maxG minB maxB color1 color2
     dR dG dB r g b lastR lastG lastB endPart posRect szRun restSize|
    
    direction := self direction.
    
    usedLength isNil ifTrue:[
        "/ use screen's height; so the gradient changes when the bounds are moved
        usedHeightRange := aGC device height. "/ aView height.
        usedWidthRange := aGC device width.  "/ aView width.
    ] ifFalse:[
        usedLength == #view ifTrue:[
            usedHeightRange := aGC height.
            usedWidthRange := aGC width.
        ] ifFalse:[
            usedHeightRange := usedLength.
            usedWidthRange := usedLength.
        ].
    ].
    direction == #northSouth ifTrue:[
        usedRange := usedHeightRange.
        startPos := y.
        endPos := y+h.
    ] ifFalse:[
        usedRange := usedWidthRange.
        startPos := x.
        endPos := x+w.
    ].
    
    "/ each part
    numSegs := colors size - 1.
    partRange := (usedRange / numSegs) asFloat.

    "/ where is the start?
    segOffset := startPos \\ partRange.
    segNr := startPos // partRange + 1.
    
    pos := startPos.
    [pos < endPos] whileTrue:[
        segNr > numSegs ifTrue:[
            restSize := endPos - pos.
            aGC paint:(colors last).
            
            direction == #northSouth ifTrue:[
                aGC fillRectangleX:x y:pos width:w height:restSize.
            ] ifFalse:[    
                aGC fillRectangleX:pos y:y width:restSize height:h.
            ].    
            ^ self
        ].
        
        "/ we have to interpolate between those two colors
        color1 := colors at:segNr.
        color2 := colors at:segNr+1.
        
        r1 := color1 redByte.   r2 := color2 redByte.
        g1 := color1 greenByte. g2 := color2 greenByte.
        b1 := color1 blueByte.  b2 := color2 blueByte.

        minR := r1 min:r2. maxR := r1 max:r2.
        minG := g1 min:g2. maxG := g1 max:g2.
        minB := b1 min:b2. maxB := b1 max:b2.

        dR := (r2 - r1) / partRange. dG := (g2 - g1) / partRange. dB := (b2 - b1) / partRange.
        r := r1 + (dR * segOffset). 
        g := g1 + (dG * segOffset). 
        b := b1 + (dB * segOffset).

        r := (r max:minR) min:maxR. 
        g := (g max:minG) min:maxG.
        b := (b max:minB) min:maxB.

        lastR := r asInteger. lastG := g asInteger. lastB := b asInteger.
        
        "/ now draw
        endPart := (startPos + partRange) truncated min:endPos.
        posRect := pos.
        szRun := 0.
        pos to:endPart-1 do:[:p |
            |rC gC bC|
            
            rC := r asInteger. gC := g asInteger. bC := b asInteger.
            (rC ~~ lastR or:[gC ~~ lastG or:[bC ~~ lastB]]) ifTrue:[
                aGC paint:(Color redByte:lastR greenByte:lastG blueByte:lastB).
                direction == #northSouth ifTrue:[
                    aGC fillRectangleX:x y:posRect width:w height:szRun.
                ] ifFalse:[    
                    aGC fillRectangleX:posRect y:y width:szRun height:h.
                ].    
                posRect := p. szRun := 0.
                lastR := rC. lastG := gC. lastB := bC.
            ].
            szRun := szRun + 1.
            r := ((r + dR) max:minR) min:maxR. 
            g := ((g + dG) max:minG) min:maxG.
            b := ((b + dB) max:minB) min:maxB.
        ].
        szRun ~~ 0 ifTrue:[
            aGC paint:(Color redByte:lastR greenByte:lastG blueByte:lastB).
            direction == #northSouth ifTrue:[
                aGC fillRectangleX:x y:posRect width:w height:szRun.
            ] ifFalse:[    
                aGC fillRectangleX:posRect y:y width:szRun height:h.
            ].    
        ].
        "/ self halt.
        "/ drawn one segment's gradient
        segOffset := 0.
        pos := startPos := endPart.
        segNr := segNr + 1.
    ].
! !

!GradientBackground methodsFor:'queries'!

needsFullRedrawOnChangeOfHeight
    ^ usedLength == #view and:[self direction == #northSouth]
!

needsFullRedrawOnChangeOfWidth
    ^ usedLength == #view and:[direction == #eastWest]
! !

!GradientBackground class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

