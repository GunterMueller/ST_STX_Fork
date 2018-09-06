View subclass:#ColorWheel
	instanceVariableNames:'nSegment nRing colors action position markColor saveUnderMark'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

ColorWheel comment:'
 for color choosing. try:
	ColorWheel open

 $Header: /cvs/stx/stx/clients/ColorPanel/ColorWheel.st,v 1.12 2016-09-14 08:27:02 mawalch Exp $
 written summer 93 by claus
'!

!ColorWheel  class methodsFor:'documentation'!

documentation
"
    view to display & interact with a color wheel.

    Caveat:
        with PseudoColor displays, this may have trouble
        to display a nice view of the colors, since the colorDither
        code is less than perfect.
        (it allocates dithered colors and fills the arc segment with
         those)
        A much better result could be optained, by filling a Depth24Image
        with the desired colors, and dither this as-a-whole.
        (which allowed errors to be distributed much better).
        This may be added in the future.

    With TrueColor displays, the output is ok.
"
! !

!ColorWheel methodsFor:'accessing'!

action:aBlock
    "set the actionblock to be evaluated with the choosen
     color"

    action := aBlock
!

color:aColor
    aColor brightness > 0.45 ifTrue:[
        markColor := Black
    ] ifFalse:[
        markColor := White
    ].
    self position:(self positionFromColor:aColor)

    "Modified: 15.6.1996 / 10:33:12 / cg"
!

colors
    "return the collection of colors used in this wheel"

    ^ colors
!

numberOfSegments:nseg numberOfRings:nring
    "allocate the colors for nseg segments in nring rings and
     keep refs to those in colors."

    |delta percent clr hue saturation otherColors|

    nRing := nring.
    nSegment := nseg.
    colors := Array new:nRing.
    1 to:nRing do:[:r |
        colors at:r put:(Array new:nSegment)
    ].

    hue := 0.
    1 to:nSegment do:[:segment |
        saturation := 0.
        1 to:nRing do:[:ring |
            clr := (Color hue:hue
                          light:50
                          saturation:saturation).

"/            clr := clr on:device.
            (colors at:ring) at:segment put:clr.
            saturation := saturation + (100 / (nRing - 1)).
        ].
        hue := hue + (360 / nSegment)
    ].
!

position:aPoint
    |oldPos x y w h|

    aPoint = position ifTrue:[^ self].

    shown ifFalse:[
        position := aPoint.
        ^ self
    ] .

    position notNil ifTrue:[
        oldPos := position.
        position := nil.
        x := oldPos x * width + width // 2 - 6.
        y := oldPos y * height + height // 2 - 6.
        w := 12.
        h := 12.
        saveUnderMark notNil ifTrue:[
            self foreground:(Color colorId:1) background:(Color colorId:0).
            self copyFrom:saveUnderMark x:0 y:0 toX:x y:y width:12 height:12
        ] ifFalse:[
            self clearRectangleX:x y:y width:w height:h.
            self redrawX:x y:y width:w height:h.
        ]
    ].

    position := aPoint.
    x := position x * width + width // 2 - 5.
    y := position y * height + height // 2 - 5.

    saveUnderMark := Form width:12 height:12 depth:(device depth) on:device.
    saveUnderMark foreground:(Color colorId:1) background:(Color colorId:0).
    saveUnderMark copyFrom:self x:x-1 y:y-1 toX:0 y:0 width:12 height:12.

    self paint:markColor.
    self displayArcX:x y:y width:10 height:10 from:0 angle:360

    "Modified: 15.6.1996 / 10:30:20 / cg"
! !

!ColorWheel methodsFor:'drawing'!

redraw
    |angle startAngle center off p2 w h cx cy 
     wEach hEach ringColors|

    angle := 360 / nSegment.
    cx := ((width - 1) / 2) rounded.
    cy := ((height - 1) / 2) rounded.

    wEach := (width - 1) asFloat / nRing.
    hEach := (height - 1) asFloat / nRing.

    nRing to:1 by:-1 do:[:ring |
        startAngle := 0.

        w := (wEach * ring) rounded.
        h := (hEach * ring) rounded.
        ringColors := colors at:ring.

        1 to:nSegment do:[:segment |
            self paint:(ringColors at:segment).

            self fillArcX:cx-(w // 2) y:cy-(h // 2)
                    width:w height:h
                     from:startAngle angle:angle.
            startAngle := startAngle + angle.
        ]
    ].

    "one circle around that thing"
    self paint:Black.
    startAngle := 0.
    self displayArcX:0 y:0
               width:width-1 height:height-1
                from:0 angle:360.

    position notNil ifTrue:[
        self paint:markColor.
        self displayArcX:position x * width + width // 2 - 5
                       y:position y * height + height // 2 - 5
                       width:10 height:10 from:0 angle:360
    ]

    "Modified: 15.6.1996 / 12:15:51 / cg"
! !

!ColorWheel methodsFor:'events'!

buttonMotion:button x:x y:y
    |color|

    self buttonPress:1 x:x y:y
!

buttonPress:button x:x y:y
    |color|

    (button == 1 or:[button == #select])  ifFalse:[
	^ super buttonPress:button x:x y:y
    ].
    color := self colorFromX:x y:y.
    action notNil ifTrue:[
	action value:color
    ].
    self color:(self colorFromX:x y:y)
!

buttonRelease:button x:x y:y
"
    self color:(self colorFromX:x y:y)
"
!

sizeChanged:how
    super sizeChanged:how.
    saveUnderMark := nil
! !

!ColorWheel methodsFor:'initialization'!

getDitherColors
    "this is run in the background, to acquire
     dithered colors (which takes some time)"

    'get dithered colors ...' printNL.
!

initEvents
"/    self enableButtonEvents.
    self enableButtonMotionEvents

    "Modified: 15.6.1996 / 10:28:19 / cg"
!

initialize
    super initialize.
    action := [:color | color printNewline].
    nSegment := 90.  
    nRing := 15.
    position := nil
! !

!ColorWheel methodsFor:'private'!

colorFromX:x y:y
    "given an x/y position, return corresponding color"

    |angle cx cy pX pY a b dist t|

    "translate to center-origin"

    a := (width - 1 - 2) / 2.0.
    b := (height - 1 - 2) / 2.0.

    cx := a rounded.
    cy := b rounded.

    pX := x - cx.
    pY := (y - cy) negated.

    "scale to 0..1"

    pX := pX / a.
    pY := pY / b.

    "get distance"

    pX := (pX min:1) max:-1.
    pY := (pY min:1) max:-1.

    dist := (pX squared + pY squared) sqrt.
    dist := dist min:1.

" uncommenting this will threshhold saturation values ...
dist := (dist * nRing) rounded / nRing.
"

    pX = 0 ifTrue:[
	angle := pY > 0 ifTrue:[90] ifFalse:[270].
    ] ifFalse:[
	angle := (pY / pX) arcTan radiansToDegrees.
	pX < 0 ifTrue:[
	    angle := angle + 180
	] ifFalse:[
	    pY < 0 ifTrue:[
		angle := angle + 360
	    ]
	]
    ].

    ^ Color hue:angle light:50 saturation:(dist * 100.0)
!

positionFromColor:aColor
    "given a color, return corresponding x/y position (normalized)"

    |angle cx cy pX pY a b dist t h|


    "translate to center-origin"

    a := (width - 1 - 2) / 2.0.
    b := (height - 1 - 2) / 2.0.

    cx := a rounded.
    cy := b rounded.  "center"

    "distance (0..1) from saturation"

    dist := aColor saturation / 100.0.

    h := aColor hue.
    h isNil ifTrue:[
	"achromatic - center"
	^ 0@0
    ].
    h := h degreesToRadians.

    pX := h cos.
    pY := h sin negated.

    pX := pX * dist.
    pY := pY * dist.

    ^ pX @ pY
! !

!ColorWheel methodsFor:'realization'!

create
    |clr visual|

    super create.

    ((visual := device visualType) ~~ #TrueColor
    and:[visual ~~ #StaticGray]) ifTrue:[
        nSegment := 60.
        nRing := 5
    ] ifFalse:[
        nSegment := 90.  
        nRing := 15.
    ].

    colors isNil ifTrue:[
        self numberOfSegments:nSegment numberOfRings:nRing
    ].

    device visualType == #PseudoColor ifTrue:[
        1 to:nRing do:[:ring |
            1 to:nSegment do:[:segment |
                clr := (colors at:ring) at:segment.
"/                clr := clr nearestOn:device.
                (colors at:ring) at:segment put:clr
            ]
        ]
    ]

    "Modified: 15.6.1996 / 10:35:45 / cg"
! !

!ColorWheel  class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/ColorWheel.st,v 1.12 2016-09-14 08:27:02 mawalch Exp $'
! !
