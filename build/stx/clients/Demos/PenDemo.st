"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

Object subclass:#PenDemo
	instanceVariableNames:'drawView bic'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

PenDemo comment:'
 play around with a pen - this example shows how widgets can be used
 from other classes.

 start with:
     PenDemo open

 written spring 89 by claus
'
!

!PenDemo class methodsFor:'documentation'!

documentation
"
    a little demo showing pen turtle graphics.
    The Pen class is described in Smalltalk-80, the language & implementation.
    Also, the use of buttons and panels is demonstrated somewhat.

    [author:]
        Claus Gittinger

    [see also:]
        CommanderDemo Commander Pen
        GraphicsContext

    [start with:]
        PenDemo open
"

! !

!PenDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:34:46 / cg"
!

open
    "open a new penDemo"

    Pen isNil ifTrue:[
        Smalltalk loadPackage:'stx:goodies' 
    ].
    self new open

    "
     PenDemo open 
    "
! !

!PenDemo methodsFor:'geometric patterns'!

cCurve
    "draw a c-pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. 
            bic up.
            bic west. bic go:(drawView width // 5).
            bic north. bic go:(drawView height // 5).
            bic down.
            bic east. bic cCurve:10 side:8
        ]
    ].

    Transcript showCR:'cCurve: time to draw: ' , t printString , ' ms'
!

dragon
    "draw a dragon pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. 
            bic up; north; go:100; down.
            bic east.
            bic dragon:10
        ]
    ].

    Transcript showCR:'dragon: time to draw: ' , t printString , ' ms'
!

fastSpiralAnimation
    "draw multiple spirals in myself - full speed"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            200 to:359 by:2 do:[:angle |
                self spiral:angle.
            ].
            359 to:200 by:-2 do:[:angle |
                self spiral:angle.
            ].
        ]
    ].

    Transcript showCR:'fastSpiral: time to draw: ' , t printString , ' ms'

    "Modified: 30.8.1996 / 20:35:49 / cg"
    "Created: 17.1.1997 / 17:04:56 / cg"
!

hilbert
    "draw a hilbert pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home.
            bic up.
            bic west. bic go:(drawView width // 5).
            bic north. bic go:(drawView height // 5).
            bic down.
            bic east. bic hilbert:5 side:8
        ]
    ].

    Transcript showCR:'hilbert: time to draw: ' , t printString , ' ms'
!

koch
    "draw a koch pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home.
            bic up.
            bic west. bic go:(drawView width // 4).
            bic north. bic go:(drawView height // 5).
            bic down.
            bic east.
            bic koch:4 side:2.
            bic turn:120.
            bic koch:4 side:2.
            bic turn:120.
            bic koch:4 side:2
        ]
    ].

    Transcript showCR:'koch: time to draw: ' , t printString , ' ms'
!

mandala
    "draw a mandala in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. bic east. bic mandala:10 radius:200
        ]
    ].

    Transcript showCR:'mandala: time to draw: ' , t printString , ' ms'
!

mandala2
    "draw a mandala in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. bic east. bic mandala:20 radius:200
        ]
    ].

    Transcript showCR:'mandala: time to draw: ' , t printString , ' ms'
!

pythagoras
    "draw a pythagoras pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home.
            bic south; up; go:200.
            bic west; go:50.
            bic north; down.
            bic pythagoras:12 side:100
        ]
    ].

    Transcript showCR:'pythagoras: time to draw: ' , t printString , ' ms'

    "Modified: / 3.8.1998 / 16:58:21 / cg"
!

pythagorasBuffered
    "draw a pythagoras pattern in myself,
     using a buffering pen (i.e. first record all drawing,
     then draw it all).
     This is an experiment, added since I wondered where the time goes;
     Now, I know, that most is spent in the X-lib/Xserver)"

    self drawAction:[
        |bic|

        bic := RecordingPen in:drawView.

        bic clear.
        bic home.
        bic south; up; go:200.
        bic west; go:50.
        bic north; down.
        bic pythagoras:12 side:100.

        bic replay.
    ]

    "Modified: / 3.8.1998 / 16:58:49 / cg"
    "Created: / 3.8.1998 / 16:59:01 / cg"
!

rosetta
    "draw a c-pattern in myself"

    |t|

    self drawAction:[
        t := Time millisecondsToRun:[
            bic clear.
            bic home. 
            10 timesRepeat:[
                bic turn:36.
                5 timesRepeat:[
                    bic go:54.
                    bic turn:72
                ]
            ]    
        ]
    ].

    Transcript showCR:'rosetta: time to draw: ' , t printString , ' ms'
!

spiral:angle
    "draw a spiral pattern in myself"

    self drawAction:[
        bic clear.
        bic home. bic east. bic spiral:400 angle:angle
    ]
!

spiralAnimation
    "draw multiple spirals in myself"

    self drawAction:[
        bic clear.
        200 to:359 by:2 do:[:angle |
            self spiral:angle.
            Delay waitForSeconds:0.05
        ].
        359 to:200 by:-2 do:[:angle |
            self spiral:angle.
            Delay waitForSeconds:0.05
        ].
    ]

    "Modified: 17.1.1997 / 17:04:45 / cg"
!

spiralAnimation:angle count:count
    "draw multiple spirals in myself"

    self drawAction:[
        bic clear.
        count timesRepeat:[
            drawView paint:(Color black).
            bic home. bic east. bic spiral:400 angle:angle.
            drawView paint:(Color white).
            bic home. bic east. bic spiral:400 angle:angle
        ].
        drawView paint:(Color black)
    ]
!

spiralGreying:angle
    "draw multiple spirals in myself"

    self drawAction:[
        bic clear.
        0 to:100 by:10 do:[:grey |
            drawView paint:(Color grey:grey).
            bic home. bic east. bic spiral:400 angle:angle
        ].
        drawView paint:(Color black)
    ]
! !

!PenDemo methodsFor:'helpers'!

drawAction:aBlock
    drawView topView withExecuteCursorDo:aBlock.
    bic destForm ~~ drawView ifTrue:[
        self refreshMyself
    ].
!

refreshMyself
    drawView withAllSubViewsDo:[:v | v invalidate]
!

refreshScreen
    |v|

    v := PopUpView new.
    v origin:0@0 extent:drawView device extent.
    v realize.
    v destroy.
! !

!PenDemo methodsFor:'startup'!

open 
    "setup the topView, some buttons and a pen"

    |topView panel nibToggle rootToggle|

    topView := StandardSystemView
                    label:'PenDemo'
                    icon:(Image fromFile:'bitmaps/PenDemo.xbm').

    topView extent:(600 @ 400).
    topView minExtent:(600 @ 400).

    panel := PanelView origin:(0 @ 0) extent:(1.0 @ 1.0) in:topView.

    drawView := panel.

    bic := Pen in:drawView.

    Button label:'spiral 89' action:[self spiral:89] in:panel.
    Button label:'spiral 121' action:[self spiral:121] in:panel.
    Button label:'spiral 151' action:[self spiral:151] in:panel.
    Button label:'spiral 59' action:[self spiral:59] in:panel.
    Button label:'spiral anim' action:[self spiralAnimation] in:panel.
    Button label:'fast spiral' action:[self fastSpiralAnimation] in:panel.
    Button label:'dragon' action:[self dragon] in:panel.
    Button label:'hilbert' action:[self hilbert] in:panel.
    Button label:'koch' action:[self koch] in:panel.
    Button label:'mandala' action:[self mandala] in:panel.
    Button label:'mandala2' action:[self mandala2] in:panel.
    Button label:'c-curve' action:[self cCurve] in:panel.
    Button label:'pythagoras' action:[self pythagoras] in:panel.
    Button label:'rosetta' action:[self rosetta] in:panel.
"/    Button label:'pythagoras2' action:[self pythagorasBuffered] in:panel.

"/    speedToggle := Toggle label:'slow' in: panel.
"/    speedToggle pressAction:[Display unBuffered].
"/    speedToggle releaseAction:[Display buffered].

    nibToggle := Toggle label:'nib 1' in: panel.
    nibToggle pressAction:[bic defaultNib:5. nibToggle label:'nib 5'].
    nibToggle releaseAction:[bic defaultNib:1. nibToggle label:'nib 1'].
    nibToggle sizeFixed:true.

    rootToggle := Toggle label:'   In View    ' in: panel.
    rootToggle pressAction:[self refreshScreen. bic destForm:drawView device rootView. rootToggle label:'On Desktop'].
    rootToggle releaseAction:[self refreshScreen. bic destForm:drawView. rootToggle label:'In View'].
    rootToggle sizeFixed:true.

    Button label:'Refresh Screen'  action:[self refreshScreen]  in:panel.

    Button label:'Quit'  action:[topView destroy]  in:panel.

    topView open

    "Modified: / 3.8.1998 / 16:59:10 / cg"
! !

!PenDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/PenDemo.st,v 1.23 2016-05-30 07:41:32 cg Exp $'
! !

