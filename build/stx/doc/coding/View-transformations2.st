"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#TransformationDemo2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Drawing'
!

!TransformationDemo2 class methodsFor:'documentation'!

documentation
"
 how to work with translations - demonstrates unit trasnformation.
 Sets up a view with a unit-transformation for cm (== 1/100th of a meter).
 and draws some geometric patterns in centimeters.
 (Of course, this requires that the correct resolution of the display
  is known - if required, adjust things in the launchers settings-display menu)

 [start with:]
    TransformationDemo2 start

 [author:]
    Claus Gittinger (july 93)
"
! !

!TransformationDemo2 class methodsFor:'startup'!

start
    |aDemo|


    aDemo := self
                label:'TransformationDemo2'
                icon:(Image fromFile:'Demo.xbm' resolution:100)
                minExtent:(150 @ 150)
                maxExtent:(1000 @ 1000).
    aDemo extent:(400 @ 400).
    aDemo open.
    ^ aDemo

    "
     TransformationDemo2 start
    "
! !

!TransformationDemo2 methodsFor:'initialization'!

initialize
    super initialize.

    "want units of 1 cm"
    transformation := WindowingTransformation unit:#cm on:device.

    "want origin to be offset by 5mm in each direction"
    transformation translateBy:0.5 @ 0.5.
! !

!TransformationDemo2 methodsFor:'redrawing'!

redraw
    |nSegment angle startAngle grey|

    self clear.
    self paint:Black.
    self displayLineFromX:-10 y:0 toX:10 y:0.
    self displayLineFromX:0 y:-10 toX:0 y:10.
    0 to:10 do:[:cm |
	self displayLineFromX:cm y:-0.1 toX:cm y:0 
    ].
    0 to:10 do:[:cm |
	self displayLineFromX:-0.1 y:cm toX:0 y:cm
    ].

    "
     draw a circle with radius 3cm around 5 @ 5
    "
    self displayCircle:(5 @ 5) radius:3.

    "
     draw a rectangle 
    "
    self displayRectangleX:5 y:5 width:2 height:1.

    "
     draw a circle with radius 1cm around 2 @ 2
    "
    self displayArc:(2 @ 2) radius:1 from:0 angle:360.

    nSegment := 12.
    angle := 360.0 / nSegment.
    startAngle := 0.0 .
    1 to:nSegment do:[:segment |
	grey := 100 / (nSegment - 1) * (segment - 1).
	self paint:(Color grey:grey).
	self fillArc:(2 @ 2) radius:1 from:startAngle angle:angle.
	startAngle := startAngle + angle.
    ]
! !

!TransformationDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-transformations2.st,v 1.8 1997-01-03 20:31:32 cg Exp $'
! !
