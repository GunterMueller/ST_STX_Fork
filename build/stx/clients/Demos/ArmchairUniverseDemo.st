"{ NameSpace: Demos }"

Object subclass:#ArmchairUniverseDemo
	instanceVariableNames:'drawView'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!ArmchairUniverseDemo class methodsFor:'documentation'!

documentation
"
 draws geometric patterns

 The algorithms & parameters are described (among elsewhere)
 in:
    The Armchair Universe
    (Computer recreations from Scientific American)
    by A.K. Dewdney
    Freeman & Company ISBN 0-716-71938-X

 [see also:]
     FractalPatternsDemo FractalPlantsDemo

 [start with:]
     ArmchairUniverseDemo open
     ArmchairUniverseDemo recompileForSpeed; open

 [author:]
     Claus Gittinger
"



! !

!ArmchairUniverseDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:40:02 / cg"
!

open
    "open a new demo view"

    ^ self new open

    "Created: 8.1.1997 / 11:54:45 / cg"
! !

!ArmchairUniverseDemo class methodsFor:'tuning'!

recompileForSpeed
     "for best performance, compile the method:
        #doHopalongWithX:y:a:b:c:sX:sY:oX:oY:numberOfIterations:
      to machine code (if your systems supports this)."

    self recompileForSpeed:#doHopalongWithX:y:a:b:c:sX:sY:oX:oY:numberOfIterations:

! !

!ArmchairUniverseDemo methodsFor:'drawing'!

doHopalongWithX:x0 y:y0 a:_a b:_b c:c sX:_sX sY:_sY oX:_oX oY:_oY numberOfIterations:count
    "{ Pragma: +optMath2 +inlineMath2  }"

    "actual working horse for hopalong.
     taken from the 'wallpaper for the mind' chapter"

    "/ give stc something to optimize ...

    |x  "{ Class: Float }"
     y  "{ Class: Float }"
     a  "{ Class: Float }"
     b  "{ Class: Float }"
     t  "{ Class: Float }"
     sX "{ Class: Float }"
     sY "{ Class: Float }"
     oX "{ Class: Float }"
     oY "{ Class: Float }"
     xx "{ Class: Float }"
     yy "{ Class: Float }"
     n  "{ Class: SmallInteger }"|

    x := x0 asFloat.
    y := y0 asFloat.
    a := _a asFloat.
    b := _b asFloat.

    sX := _sX asFloat.
    sY := _sY asFloat.
    oX := _oX asFloat.
    oY := _oY asFloat.

    n := count.

    n timesRepeat:[
        drawView displayPointX:(x*sX+oX) rounded y:(y*sY+oY) rounded.

        t := (b * x - c).

        t < 0 ifTrue:[
            t := t negated
        ].
        t := t sqrt.

        "/ xx := y - (x sign * t).
        x < 0.0 ifTrue:[
            xx := y + t.
        ] ifFalse:[
            x > 0.0 ifTrue:[
                xx := y - t.    
            ] ifFalse:[
                xx := y
            ]
        ].
        yy := a - x.
        x := xx.
        y := yy.
    ].

    "Created: 8.1.1997 / 12:07:32 / cg"
    "Modified: 1.2.1997 / 18:31:46 / cg"
!

hopalong1
    "generate a hopalong pattern
     taken from the 'wallpaper for the mind' chapter"

    drawView clear; paint:Color black.
    Processor activeProcess withPriority:4 do:[
        drawView topView withWaitCursorDo:[
            self doHopalongWithX:0 y:0 a:-3.14 b:0.3 c:0.3
                 sX:20 sY:20 oX:300 oY:250
                 numberOfIterations:50000
        ]
    ]

    "Modified: 8.1.1997 / 12:04:07 / cg"
    "Created: 8.1.1997 / 12:08:53 / cg"
!

hopalong2
    "generate a hopalong pattern
     taken from the 'wallpaper for the mind' chapter"

    drawView clear; paint:Color black.
    Processor activeProcess withPriority:4 do:[
        drawView topView withWaitCursorDo:[
            self doHopalongWithX:0 y:0 a:-200 b:0.1 c:-80
                 sX:1.7 sY:1.7 oX:450 oY:400
                 numberOfIterations:50000
        ]
    ]

    "Created: 8.1.1997 / 12:08:53 / cg"
    "Modified: 8.1.1997 / 12:11:06 / cg"
!

hopalong3
    "generate a hopalong pattern
     taken from the 'wallpaper for the mind' chapter"

    drawView clear; paint:Color black.
    Processor activeProcess withPriority:4 do:[
        drawView topView withWaitCursorDo:[
            self doHopalongWithX:0 y:0 a:-200 b:0.1 c:-80
                 sX:10 sY:10 oX:450 oY:400
                 numberOfIterations:100000
        ]
    ]

    "Created: 8.1.1997 / 12:11:17 / cg"
    "Modified: 8.1.1997 / 12:11:54 / cg"
! !

!ArmchairUniverseDemo methodsFor:'startup'!

open 
    "create a topView, some buttons and open it"

    |topView panel speedToggle nibToggle |

    topView := StandardSystemView
                    label:'The Armchair Universe'
                    icon:(Image fromFile:'bitmaps/Armchair.xbm').

    topView extent:(600 @ 450).
    topView minExtent:(600 @ 450).

    panel := PanelView origin:(0 @ 0) extent:(1.0 @ 1.0) in:topView.

    drawView := panel.

    Button label:'hopalong1' action:[self hopalong1] in:panel.
    Button label:'hopalong2' action:[self hopalong2] in:panel.
    Button label:'hopalong3' action:[self hopalong3] in:panel.
    Button label:'quit'  action:[topView destroy]  in:panel.

    topView open

    "
     ArmchairUniverseDemo new open
    "

    "Created: 8.1.1997 / 11:54:20 / cg"
    "Modified: 8.1.1997 / 12:14:01 / cg"
! !

!ArmchairUniverseDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ArmchairUniverseDemo.st,v 1.6 1998-07-09 08:10:00 cg Exp $'
! !
