"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#ClockView
	instanceVariableNames:'lastTime timeBlock xTable yTable showSeconds showMinutes
		showHours fgColor isStopWatch startTime stopTime'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Fun'
!

!ClockView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
   xclock replacement

   :-) not that I thought this clock is any better than xclock
       or that the world needs clocks ...

   its showing how easy it is to program in Smalltalk - 
   this took less than an hour to program - compare with xclock code ....

   Since this is a subclass of view, you can use it as a widget in
   more complex views.


   Implementation note:
        this class was written long before multiple threads came to ST/X;
        therefore, it uses the Processors timedBlock facilities.
        Today, things would be written differently.
        As an excercise, you may rewrite it using an update process which 
        runs in the background.

   [author:]
        Claus Gittinger (spring 91)

   [start with:]
        Clock start

   [see also:]
        Clock RoundClock Time  
        ProcessorScheduler
"
!

examples
"
   in a topView:
                                                                [exBegin]
    |top clk|

    top := StandardSystemView new.
    top label:'ST/X clock'.
    top extent:200@200.

    clk := ClockView origin:0.0@0.0 corner:1.0@1.0 in:top.

    top open
                                                                [exEnd]


   a stopWatch (click to start/stop):
                                                                [exBegin]
    |top clk|

    top := StandardSystemView new.
    top label:'ST/X clock'.
    top extent:200@200.

    clk := ClockView origin:0.0@0.0 corner:1.0@1.0 in:top.
    clk beStopWatch.
    top open
                                                                [exEnd]


   as a component:
                                                                [exBegin]
    |top frame clk fileList|

    top := StandardSystemView new.
    top extent:200@200.

    frame := View origin:1.0@0.0 corner:1.0@50 in:top.
    frame leftInset:-50; rightInset:4; topInset:2; bottomInset:2.
    frame level:-1.

    clk := ClockView origin:0.0@0.0 corner:1.0@1.0 in:frame.
    clk showSeconds:false.

    fileList := ScrollableView for:FileSelectionList in:top.
    fileList origin:0@50 corner:1.0@1.0. 

    top open
                                                                [exEnd]
"
! !

!ClockView methodsFor:'accessing'!

beStopWatch
    isStopWatch := true.
!

startMeasure
    self beStopWatch.
    startTime := Timestamp now.
    stopTime := nil.
! !

!ClockView methodsFor:'drawing'!

displayCenteredString:aString
    gc displayString:aString 
         x:(width - (self font widthOf:aString))//2
         y:(height//2 + (self font heightOf:aString))
!

drawArm:tick width:w len:l
    "draw an arm of the clock; argument tick specifies minute (0..59); 
     width is width in pixel, len is relative len - 1.0 is full"

    |index p1x p1y p2x p2y|

    index := tick.
    (index == 0) ifTrue:[
        index := 60
    ].
    p1x := (width - w) // 2.
    p1y := height // 2.
    p2x := p1x + (((width / 2) * (xTable at:index)) * l) + 0.5.
    p2y := p1y + (((height / 2) * (yTable at:index)) * l) + 0.5.

    (self width min: self height) < 40 ifTrue:[
        gc lineWidth:1.
    ] ifFalse:[
        gc lineWidth:w.
    ].
    gc displayLineFromX:p1x y:p1y
                    toX:(p2x asInteger) y:(p2y asInteger)
!

drawArmsFor:aTime
    "draw arms for a given time in current paint"

    |sec min hr hrTick|

    aTime isNil ifTrue:[^ self].
    hr := aTime hours.
    min := aTime minutes.
    sec := aTime seconds.

    (hr >= 12) ifTrue:[
	hr := hr - 12
    ].
    "
     adjust hour for minute value ...
    "
    hrTick := hr * 5.
    hrTick := hrTick + (min * 5 / 60) asInteger.

    showHours ifTrue:[
	self drawArm:hrTick width:3 len:0.5.
    ].
    showMinutes ifTrue:[
	self drawArm:min width:3 len:0.8.
    ].
    showSeconds ifTrue:[
	self drawArm:sec width:1 len:0.8
    ]
!

redraw
    "redraw everything"

    lastTime isNil ifTrue:[
        lastTime := self timeShown
    ].
    isStopWatch ifTrue:[
        self redrawTimeFraction.
    ].

    self clear.
    self redrawTicks.
    self redrawArms.

    isStopWatch ifTrue:[
        self redrawStopWatchInfo
    ].
!

redrawArms
    "redraw the arms"

    self drawArmsFor:lastTime
!

redrawStopWatchInfo
    startTime isNil ifTrue:[
        self displayCenteredString:'Click/Key to Start'. 
    ] ifFalse:[
        stopTime isNil ifTrue:[
            self displayCenteredString:'Running - Click/Key to Stop'. 
        ] ifFalse:[
            self displayCenteredString:'Stopped - Click/Key to Reset'. 
        ].
    ].

    "Modified: / 10-07-2010 / 09:27:40 / cg"
!

redrawTicks
    "redraw the ticks"

    |cx cy p1x p1y p2x p2y nx ny long veryLong drawShorts drawFives tickStart|

    gc lineWidth:0.
    gc paint:fgColor.

    cx := width // 2.
    cy := height // 2.
    drawShorts := (width >= 100) and:[height >= 100].
    drawFives := (width >= 40) and:[height >= 40].

    1 to:60 do:[:tick |
        |drawIt|

        "is it a long tick ?"

        veryLong := (tick \\ 15) == 0.
        long := (tick \\ 5) == 0.

        drawIt := veryLong.
        drawIt := drawIt or:[ drawFives and:[ long ]].
        drawIt := drawIt or:[ drawShorts ].

        drawIt ifTrue:[

            "get normalized x/y of tick-end"

            nx := (width / 2) * (xTable at:tick).
            ny := (height / 2) * (yTable at:tick).

            "if long, tick goes from 0.85 to 0.95;
             otherwise from 0.90 to 0.95"
            veryLong ifTrue:[
                tickStart := 0.80
            ] ifFalse:[
                long ifTrue:[
                    tickStart := 0.85
                ] ifFalse:[
                    tickStart := 0.9
                ].
            ].

            p1x := cx + (nx * tickStart).
            p1y := cy + (ny * tickStart).
            p2x := cx + (nx * 0.95).
            p2y := cy + (ny * 0.95).
            gc displayLineFromX:(p1x rounded asInteger) y:(p1y rounded asInteger)
                            toX:(p2x rounded asInteger) y:(p2y rounded asInteger)
        ]
    ].
!

redrawTimeFraction
!

showTime
    "executed every second (by timedBlock)"

    |now anyChange deltaT|

    shown ifFalse:[^ self].

    now := self timeShown.
    lastTime isNil ifTrue:[
        anyChange := true
    ] ifFalse:[
        showSeconds ifTrue:[
            anyChange := now ~= lastTime
        ] ifFalse:[
            anyChange := now hours ~= lastTime hours.
            anyChange ifFalse:[
                anyChange := now minutes ~= lastTime minutes
            ]
        ]
    ].
    anyChange ifTrue:[
        self updateArmsFor:now.
        self flush
    ].
    showSeconds ifTrue:[
        deltaT := 1
    ] ifFalse:[
        deltaT := 30
    ].
    Processor addTimedBlock:timeBlock afterSeconds:deltaT
!

timeShown
    |t dt|

    isStopWatch ifTrue:[
        startTime isNil ifTrue:[
            dt := TimeDuration zero.
        ] ifFalse:[
            stopTime isNil ifTrue:[    
                dt := Timestamp now deltaFrom: startTime.
            ] ifFalse:[
                dt := stopTime deltaFrom: startTime.
            ].
        ].
        t := dt asTime.   
    ] ifFalse:[
        t := Time now
    ].

    ^ t.

    "Modified: / 22-02-2011 / 12:11:23 / cg"
!

updateArms
    "clear previous arms - draw new arms"

    self updateArmsFor:(Time now)
!

updateArmsFor:aTime
    "clear previous arms - draw new arms"

    |hr min sec lastSec lastHr lastMin tm ts th|

    lastTime notNil ifTrue:[
        "a little optimization - avoid redrawing minute-
         and hour arms if second-arms distance is big enough"

        showSeconds ifTrue:[
            lastHr := lastTime hours.
            lastMin := lastTime minutes.
            lastSec := lastTime seconds.

            hr := aTime hours.
            min := aTime minutes.
            sec := aTime seconds.

            ((min == lastMin) and:[hr == lastHr]) ifTrue:[
                "only second has not changed"
                (hr >= 12) ifTrue:[
                    hr := hr - 12
                ].
                hr := hr * 5.
                hr := hr + (min * 5 / 60) asInteger.

                min < 30 ifTrue:[
                    tm := min + 60
                ] ifFalse:[
                    tm := min
                ].
                sec < 30 ifTrue:[
                    ts := sec + 60
                ] ifFalse:[
                    ts := sec
                ].
                hr < 30 ifTrue:[
                    th := hr + 60
                ] ifFalse:[
                    th := hr
                ].

                (((tm - ts) abs > 5) and:[(th - ts) abs > 5]) ifTrue:[
                    "second is more than 5 ticks away from others -
                     no need to draw other arms"

                    lastMin < 30 ifTrue:[
                        tm := lastMin + 60
                    ] ifFalse:[
                        tm := lastMin
                    ].
                    lastSec < 30 ifTrue:[
                        ts := lastSec + 60
                    ] ifFalse:[
                        ts := lastSec
                    ].
                    lastHr < 30 ifTrue:[
                        th := lastHr + 60
                    ] ifFalse:[
                        th := lastHr
                    ].
                    "if lastsecond was more than 5 away from others,
                     just draw seconds-arm"
                    (((tm - ts) abs > 5) and:[(th - ts) abs > 5]) ifTrue:[
                        gc paint:viewBackground. "/ bgColor.
                        self drawArm:lastSec width:1 len:0.8.
                        lastTime := aTime.
                        gc paint:fgColor.
                        self drawArm:sec width:1 len:0.8.

                        isStopWatch ifTrue:[
                            self redrawStopWatchInfo
                        ].
                        ^ self
                    ]
                ]
            ]
        ].

        gc paint:viewBackground. "/ bgColor.
        self drawArmsFor:lastTime
    ].
    lastTime := aTime.
    gc paint:fgColor.
    self drawArmsFor:lastTime.

    isStopWatch ifTrue:[
        self redrawStopWatchInfo
    ].

    "Modified: 5.6.1996 / 02:17:26 / cg"
! !

!ClockView methodsFor:'events'!

buttonPress:button x:x y:y
    isStopWatch ifTrue:[
        button == 1 ifTrue:[
            self toggleStopWatch.
            ^ self
        ].
    ].
    super buttonPress:button x:x y:y
!

keyPress:key x:x y:y
    isStopWatch ifTrue:[
        self toggleStopWatch.
        ^ self
    ].
    super keyPress:key x:x y:y
!

mapped
    "view was mapped - launch a time-scheduled updateBlock"

    super mapped.

    self startClock

    "Modified: 30.5.1996 / 09:37:44 / cg"
!

sizeChanged:how
    "my size has changed - have to clear & redraw"

    super sizeChanged:how.
    self clear.
    self redraw

    "Created: 23.4.1996 / 21:12:43 / cg"
!

startClock
    "launch a time-scheduled updateBlock"

    "trigger timeout block in a second"
    timeBlock := [self sensor pushUserEvent:#showTime for:self].
    Processor addTimedBlock:timeBlock afterSeconds:2
!

toggleStopWatch
    startTime isNil ifTrue:[
        startTime := Timestamp now.
        stopTime := nil.
    ] ifFalse:[
        stopTime isNil ifTrue:[
            stopTime := Timestamp now.
        ] ifFalse:[
            startTime := stopTime := nil.
        ].
    ].
    lastTime := nil.    
"/    self updateArmsFor:(self timeShown).
    self invalidate.
! !

!ClockView methodsFor:'initialization'!

initialize
    "initialize the view & precompute the tick-position-table"

    |angle ta|

    super initialize.

    isStopWatch := false.
    fgColor := self blackColor.
    self viewBackground:self whiteColor.

    showSeconds := showMinutes := showHours := true.

    "initialize table of (normalized) x/y coordinates of ticks"
    xTable := Array new:60.
    yTable := Array new:60.
    angle := 0.
    1 to:60 do:[:index |
        angle := angle + 6. "360 / 60"
        ta := (360 - angle) + 90.
        xTable at:index put:((ta degreesToRadians) cos).
        yTable at:index put:((ta degreesToRadians) sin negated)
    ]

    "Modified: 5.6.1996 / 02:18:11 / cg"
!

middleButtonMenu
    |items m|

    items :=  #(
                ('Seconds'  toggleSeconds )
               ).

    isStopWatch ifTrue:[
        items :=  
                #(
                    ('Copy Time Duration'  copyTimeDuration )
                    ('-'  nil )
                ) ,
                items ,
                #(
                    ('-'  nil )
                    ('Reset'  resetStopWatch )
                ).
    ].

    m := PopUpMenu
        itemList:items
        resources:resources
        receiver:self
        for:self.

    isStopWatch ifTrue: [
        (startTime isNil or:[ stopTime isNil ]) ifTrue:[
            m disable:#copyTimeDuration.
        ].
    ].
    ^ m

    "Modified: / 10-07-2010 / 09:32:48 / cg"
! !

!ClockView methodsFor:'misc'!

showSeconds:aBoolean
    "toggle (and possibly redraw) the show-seconds flag"

    showSeconds := aBoolean.
    shown ifTrue:[
	Processor removeTimedBlock:timeBlock.
	lastTime := nil.
	self clear.
	self redraw.
	Processor addTimedBlock:timeBlock afterSeconds:1
    ]
!

toggleSeconds
    "user wants to toggle the show-seconds flag"

    showSeconds := showSeconds not.
    Processor removeTimedBlock:timeBlock.
    lastTime := nil.
    self clear.
    self redraw.
    Processor addTimedBlock:timeBlock afterSeconds:1
! !

!ClockView methodsFor:'user actions'!

copyTimeDuration
    |td|

    (startTime notNil and:[ stopTime notNil ]) ifFalse:[^ self ].

    td := (stopTime deltaFrom: startTime).
    self setClipboardText:(td printString).

    "Created: / 10-07-2010 / 09:30:48 / cg"
!

destroy
    "the view was destroyed - remove time-scheduled updateBlock"

    Processor removeTimedBlock:timeBlock.
    super destroy

    "Modified: 23.4.1996 / 21:14:17 / cg"
!

resetStopWatch
    startTime := stopTime := nil.
    self updateArmsFor:(self timeShown).
! !

!ClockView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/ClockView.st,v 1.37 2016-07-20 09:35:21 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/ClockView.st,v 1.37 2016-07-20 09:35:21 stefan Exp $'
! !

