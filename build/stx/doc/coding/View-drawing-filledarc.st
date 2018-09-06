"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#FillArcDemo1
	instanceVariableNames:'colors'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Drawing'
!

!FillArcDemo1 class methodsFor:'documentation'!

documentation
"
 demonstrates how filled arcs are drawn (in grey)

 [start with:]
    FillArcDemo1 start:10 
    FillArcDemo1 start:20 
    FillArcDemo1 start:40 

 [author:]
    Claus Gittinger (july 93)
"
! !

!FillArcDemo1 class methodsFor:'startup'!

start:n
    |aDemo|


    aDemo := self
                label:'FillArcDemo1'
                icon:(Image fromFile:'Demo.xbm' resolution:100)
                minExtent:(50 @ 50)
                maxExtent:(1000 @ 1000).
    aDemo nColors:n.
    aDemo extent:(100 @ 100).
    aDemo open.
    ^ aDemo

    "
     FillArcDemo1 start:12
    "
! !

!FillArcDemo1 methodsFor:'initialization'!

nColors:numColors 
    |grey|

    super initialize.

    colors := Array new:numColors.
    0 to:numColors-1 do:[:segment |
	grey := 100 / (numColors - 1) * segment.
	colors at:(segment + 1) put:(Color grey:grey)
    ]
! !

!FillArcDemo1 methodsFor:'redrawing'!

redraw
    |nSegment angle startAngle|

    self clear.
    nSegment := colors size.
    angle := 360.0 / nSegment.
    startAngle := 0.0 .
    1 to:nSegment do:[:segment |
        self paint:(colors at:segment).
        self fillArcX:0 y:0
                width:width-1 height:height-1
                 from:startAngle angle:angle.
        startAngle := startAngle + angle.
    ]
! !

!FillArcDemo1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-filledarc.st,v 1.9 1997-01-03 20:29:18 cg Exp $'
! !
