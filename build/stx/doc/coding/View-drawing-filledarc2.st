"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#FillArcDemo2
	instanceVariableNames:'colors'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Drawing'
!

!FillArcDemo2 class methodsFor:'documentation'!

documentation
"
 demonstrates how filled & unfilled arcs are drawn (in grey)

 [start with:]
    FillArcDemo2 start:10 
    FillArcDemo2 start:20 
    FillArcDemo2 start:40 

 [author:]
    Claus Gittinger (july 93)
"
! !

!FillArcDemo2 class methodsFor:'startup'!

start
    ^ self start:6

    "
     FillArcDemo2 start
    "
!

start:n
    |aDemo|


    aDemo := self
                label:'FillArcDemo2'
                icon:(Image fromFile:'Demo.xbm' resolution:100)
                minExtent:(50 @ 50)
                maxExtent:(1000 @ 1000).
    aDemo extent:(200 @ 200).
    aDemo getColors:n.
    aDemo open.
    ^ aDemo

    "
     FillArcDemo2 start:20
    "
! !

!FillArcDemo2 methodsFor:'initialization'!

getColors:n 
    |grey|

    colors := Array new:n.
    1 to:(colors size) do:[:segment |
	grey := 100 / (colors size) * segment.
	colors at:segment put:(Color grey:grey)
    ]
! !

!FillArcDemo2 methodsFor:'redrawing'!

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
! !

!FillArcDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-filledarc2.st,v 1.8 1997-01-03 20:29:47 cg Exp $'
! !
