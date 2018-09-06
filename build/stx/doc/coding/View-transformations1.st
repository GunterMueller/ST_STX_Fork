"{ NameSpace: CodingExamples_GUI }"

View subclass:#TransformationDemo1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Drawing'
!

!TransformationDemo1 class methodsFor:'documentation'!

documentation
"
 how to work with translations - demonstrates scale and translation.
 Sets up a view which draws some geometric patterns and
 two enterfields which allow change of scale and translation.

 [start with:]
    TransformationDemo1 start

 [author:]
    Claus Gittinger (july 93)
"
! !

!TransformationDemo1 class methodsFor:'startup'!

start
    |top aDemo f1 f2 panel|


    top := StandardSystemView
                label:'TransformationDemo1'
                icon:(Image fromFile:'Demo.xbm' resolution:100)
                minExtent:(50 @ 50)
                maxExtent:(1000 @ 1000).
    top extent:(400 @ 300).

    aDemo := self origin:(0.0 @ 0.0)
                  corner:(1.0 @ 1.0)
                      in:top.

    panel := HorizontalPanelView origin:(0.0 @ 1.0)
                                 corner:(1.0 @ 1.0)
                                     in:top.
    panel horizontalSpace:0.
    Label label:'scale:' in:panel.
    f1 := EditField in:panel.
    (View in:panel) width:20. 
    Label label:'translation:' in:panel.
    f2 := EditField in:panel.

    panel height:(f1 height).
    panel topInset:(f1 height negated).
    aDemo bottomInset:(panel height).

    f1 model:aDemo.
    f1 aspectMessage:#changeScale.
    f1 changeMessage:#changeScale:.
    f2 model:aDemo.
    f2 aspectMessage:#changeTranslation.
    f2 changeMessage:#changeTranslation:.

    top open.
    ^ aDemo

    "
     TransformationDemo1 start
    "
! !

!TransformationDemo1 methodsFor:'changes'!

changeScale
    ^ self transformation scale printString
!

changeScale:input
    |aScale|

    aScale := Object readFromString:input.
    (aScale isNumber or:[aScale isPoint]) ifTrue:[
	transformation scale:aScale.
	self redraw.
    ]
!

changeTranslation
    ^ self transformation translation printString
!

changeTranslation:input
    |aTranslation|

    aTranslation := Object readFromString:input.
    (aTranslation isNumber or:[aTranslation isPoint]) ifTrue:[
	transformation translation:aTranslation.
	self redraw.
    ]
! !

!TransformationDemo1 methodsFor:'initialization'!

initialize
    super initialize.

    transformation := WindowingTransformation 
                        scale:1 
                        translation:100.
! !

!TransformationDemo1 methodsFor:'redrawing'!

redraw
    |nSegment angle startAngle grey|

    self clear.

    "
     draw axes
    "
    self paint:Black.
    self displayLineFromX:-100 y:0 toX:100 y:0.
    self displayLineFromX:0 y:-100 toX:0 y:100.
    -100 to:100 by:10 do:[:x |
	self displayLineFromX:x y:0 toX:x y:5 
    ].
    -100 to:100 by:10 do:[:y |
	self displayLineFromX:0 y:y toX:5 y:y 
    ].

    "
     draw a circle with radius 30 around 0 @ 0
    "
    self displayCircle:(0 @ 0) radius:30.

    "
     draw rectangles for circle above (inside and outside)
    "
    self displayRectangleX:-30 / 2 sqrt y:-30 / 2 sqrt 
		     width:60 / 2 sqrt height:60 / 2 sqrt.
    self displayRectangleX:-30 y:-30 width:60 height:60.

    "
     draw a circle with radius 100 around 0 @ 0
    "
    self displayArc:(0 @ 0) radius:100 from:0 angle:360.

    "
     draw 4 circles filled with arc-segments
    "
    #(-50 50 -50 50)
    with:#(-50 -50 50 50) do:[:x :y |
	nSegment := 12.
	angle := 360.0 / nSegment.
	startAngle := 0.0 .
	1 to:nSegment do:[:segment |
	    grey := 100 / (nSegment - 1) * (segment - 1).
	    self paint:(Color grey:grey).
	    self fillArc:(x @ y) radius:20 from:startAngle angle:angle.
	    startAngle := startAngle + angle.
	]
    ].

    "
     draw diagonals
    "
    self paint:Black.
    self displayLineFromX:-100 y:-100 toX:100 y:100.
    self displayLineFromX:-100 y:100 toX:100 y:-100.

! !

!TransformationDemo1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-transformations1.st,v 1.9 1997-01-03 20:31:39 cg Exp $'
! !
