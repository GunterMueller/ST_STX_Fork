"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#TransformationDemo3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Drawing'
!

!TransformationDemo3 class methodsFor:'documentation'!

documentation
"
 how to work with transformations. 
 This demo sets up a view which is 10cm wide and 10cm high.
 The transformation is defined as unit transformation in mm (== 1/1000 of a meter)
 and an origin shifted to the bottom-right by 5cm.
 (Of course, this requires that the correct resolution of the display
  is known - if required, adjust things in the launchers settings-display menu)

 [start with:]
    TransformationDemo3 start

 [author:]
    Claus Gittinger (july 93)
"

! !

!TransformationDemo3 class methodsFor:'startup'!

start
    |aDemo mm ext|

    mm := Display pixelPerMillimeter.
    ext := (mm * 100) rounded.

    aDemo := self
                label:'TransformationDemo3'
                icon:(Image fromFile:'Demo.xbm' resolution:100)
                minExtent:ext
                maxExtent:ext.
    aDemo extent:ext.
    aDemo open.
    ^ aDemo

    "
     TransformationDemo3 start
    "
! !

!TransformationDemo3 methodsFor:'initialization'!

initialize
    super initialize.

    "want units of 1 mm"
    transformation := WindowingTransformation unit:#mm on:device.

    "want origin to be offset by 50mm in each direction;
     now, the origin 0@0 is 5cm to the bottom-right."
    transformation translateBy:50 @ 50.
! !

!TransformationDemo3 methodsFor:'redrawing'!

redraw
    |nSegment angle startAngle grey|

    self clear.
    self paint:Black.
    self displayLineFromX:-60 y:0 toX:60 y:0.
    self displayLineFromX:0 y:-60 toX:0 y:60.

    -50 to:50 by:10 do:[:mm |
        self displayLineFromX:mm y:-1 toX:mm y:0 
    ].
    -50 to:50 by:10 do:[:mm |
        self displayLineFromX:-1 y:mm toX:0 y:mm
    ].

    "
     rectangles
    "
    self paint:Color red.
    self displayRectangle:(-10 @ -10 corner:20 @ 10).

    self paint:Color green.
    self displayRectangle:(-10 @ -10 corner:-20 @ -20).

    self paint:Color blue.
    self displayRectangle:(-40 @ 40 corner:40 @ -40).

    "
     draw a circle with radius 10mm around 10mm @ 10mm
    "
    self paint:Black.
    self displayArcIn:(0 @ 0 corner:10 @ 10) from:0 angle:360.

    nSegment := 12.
    angle := 360.0 / nSegment.
    startAngle := 0.0 .
    1 to:nSegment do:[:segment |
        grey := 100 / (nSegment - 1) * (segment - 1).
        self paint:(Color grey:grey).
        self fillArcX:0 y:0 width:10 height:10 from:startAngle angle:angle.
        startAngle := startAngle + angle.
    ].

    "
     draw a circle with radius 10mm around 20mm @ -20mm
    "
    self displayArc:(20 @ -20) radius:10 from:0 angle:360.

    nSegment := 12.
    angle := 360.0 / nSegment.
    startAngle := 0.0 .
    1 to:nSegment do:[:segment |
        grey := 100 / (nSegment - 1) * (segment - 1).
        self paint:(Color grey:grey).
        self fillArc:(20 @ -20) radius:10 from:startAngle angle:angle.
        startAngle := startAngle + angle.
    ]
! !

!TransformationDemo3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-transformations3.st,v 1.8 1997-01-03 20:30:58 cg Exp $'
! !
