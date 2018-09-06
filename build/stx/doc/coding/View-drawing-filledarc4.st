"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#FillArcDemo4
	instanceVariableNames:'colors'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Drawing'
!

!FillArcDemo4 class methodsFor:'documentation'!

documentation
"
 how to draw arcs, lines & filled arcs (colors with varying hue)

 [start with:]
    FillArcDemo3 start:10 
    FillArcDemo3 start:20 
    FillArcDemo3 start:40 

 [author:]
    Claus Gittinger (july 93)
"




! !

!FillArcDemo4 class methodsFor:'startup'!

start
    ^ self start:6

    "
     FillArcDemo4 start
    "
!

start:n
    |aDemo|


    aDemo := self
                label:'FillArcDemo4'
                icon:(Image fromFile:'Demo.xbm' resolution:100)
                minExtent:(50 @ 50)
                maxExtent:(1000 @ 1000).
    aDemo extent:(200 @ 200).
    aDemo getColors:n.
    aDemo open.
    ^ aDemo

    "
     FillArcDemo4 start:20
    "
! !

!FillArcDemo4 methodsFor:'initialization'!

getColors:n 
    |angle|

    colors := Array new:n.
    1 to:(colors size) do:[:segment |
	angle := 360 / (colors size) * segment.
	colors at:segment put:(Color hue:angle light:50 saturation:100)
    ]
! !

!FillArcDemo4 methodsFor:'redrawing'!

redraw
    |nSegment angle startAngle center off p2|

    nSegment := colors size.
    angle := 360 / nSegment.
    center := ((width - 1) @ (height - 1)) / 2.

    startAngle := 0.
    1 to:nSegment do:[:segment |
        self paint:(colors at:segment).
        self fillArcX:0 y:0
                width:width-1 height:height-1
                 from:startAngle angle:angle.
        startAngle := startAngle + angle.
    ].

    self paint:Black.
    startAngle := 0.
    nSegment <= 60 ifTrue:[
        1 to:nSegment do:[:segment |
            self displayArcX:0 y:0
                       width:width-1 height:height-1
                        from:startAngle angle:angle.
            off := ((width - 1) * (startAngle degreesToRadians cos))
                   @
                   ((height - 1) * (startAngle degreesToRadians sin)).
            off := (off / 2).
            p2 := center + off.
            self displayLineFrom:center rounded to:p2 rounded.
            startAngle := startAngle + angle.
        ]
    ]
! !

!FillArcDemo4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-filledarc4.st,v 1.8 1997-01-03 20:30:10 cg Exp $'
! !
