"
 COPYRIGHT (c) 1997 by Claus Gittinger
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

SimpleView subclass:#DigitalClockView
	instanceVariableNames:'lastTime timeBlock digitBitmaps colonBitmap scaledDigitBitmaps
		scaledColonBitmap showSeconds'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!DigitalClockView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger
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
   another clock replacement ...
   This is a regular view - it can also be placed into another one.

   [author:]
        Claus Gittinger

   [start with:]
        DigitalClockView new open

   [see also:]
        Clock RoundClock ClockView
        Time  
        ProcessorScheduler
        DigitalLedDisplay
"

!

examples
"
   in a topView:
                                                                [exBegin]
    |top clk prefSize|

    top := StandardSystemView new.
    top label:'ST/X clock'.

    clk := DigitalClockView in:top.
    prefSize := clk preferredExtent.
    top extent:prefSize.
    top minExtent:prefSize.
    top maxExtent:prefSize.

    top open
                                                                [exEnd]


   as a component:
                                                                [exBegin]
    |top frame clk fileList sz|

    top := StandardSystemView new.
    top extent:200@200.

    clk := DigitalClockView new.
    clk showSeconds:false.
    sz := clk preferredExtent.

    frame := View origin:1.0@0.0 corner:1.0@(sz y) in:top.
    frame leftInset:(sz x negated - 4); rightInset:4; topInset:2; bottomInset:-2.
    frame level:-1.

    clk := DigitalClockView in:frame.

    fileList := ScrollableView for:FileSelectionList in:top.
    fileList origin:0@50 corner:1.0@1.0. 

    top open
                                                                [exEnd]
"
! !

!DigitalClockView class methodsFor:'others'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/DigitalClockView.st,v 1.18 2017-01-03 13:49:06 stefan Exp $'
! !

!DigitalClockView class methodsFor:'startup'!

isVisualStartable
    "yes, I can be started via double click in the browser"

    ^ true
!

open
    "open a topView containing a digitalClock"

    |top clk prefSize|

    top := StandardSystemView new.
    top label:'ST/X clock'.
    top viewBackground:Color black.

    clk := self in:top.
    prefSize := clk preferredExtent.
    top extent:prefSize.
    top minExtent:prefSize.
    top maxExtent:prefSize.

    top open

    "
     DigitalClockView open
    "

    "Modified: / 23-10-2006 / 21:45:32 / cg"
! !

!DigitalClockView methodsFor:'accessing'!

showSeconds:something
    "set the value of the instance variable 'showSeconds' (automatically generated)"

    showSeconds := something.

    "Created: 24.1.1997 / 16:42:59 / cg"
! !

!DigitalClockView methodsFor:'drawing'!

redraw
    "update my view"

    |now hour minute second x w d1 d2|

    scaledColonBitmap isNil ifTrue:[^ self].

    now := Time now.
    x := 0.
    w := scaledColonBitmap width.

    hour := now hours.
    (lastTime isNil or:[hour ~~ lastTime hours]) ifTrue:[
        "/ show hour
        d1 := hour // 10.
        d2 := hour \\ 10.
        (scaledDigitBitmaps at:d1+1) displayOn:self at:x @ 0.
        (scaledDigitBitmaps at:d2+1) displayOn:self at:x+w @ 0.
    ].
    x := x + w + w.

    scaledColonBitmap displayOn:self at:x @ 0.
    x := x + w.

    minute := now minutes.
    (lastTime isNil or:[minute ~~ lastTime minutes]) ifTrue:[
        "/ show hour
        d1 := minute // 10.
        d2 := minute \\ 10.
        (scaledDigitBitmaps at:d1+1) displayOn:self at:x @ 0.
        (scaledDigitBitmaps at:d2+1) displayOn:self at:x+w @ 0.
    ].

    showSeconds ifTrue:[
        x := x + w + w.

        scaledColonBitmap displayOn:self at:x @ 0.
        x := x + w.

        second := now seconds.
        (lastTime isNil or:[second ~~ lastTime seconds]) ifTrue:[
            "/ show hour
            d1 := second // 10.
            d2 := second \\ 10.
            (scaledDigitBitmaps at:d1+1) displayOn:self at:x @ 0.
            (scaledDigitBitmaps at:d2+1) displayOn:self at:x+w @ 0.
        ].
    ]

    "
     DigitalClockView new open
     (DigitalClockView new showSeconds:false) open
    "

    "Modified: 22.3.1997 / 17:34:05 / cg"
!

showTime
    "executed every second (by timedBlock)"

    |now anyChange deltaT showSeconds|

    showSeconds := true.
    shown ifFalse:[^ self].

    now := Time now.
    lastTime isNil ifTrue:[
        anyChange := true
    ] ifFalse:[
        anyChange := now ~= lastTime
    ].
    anyChange ifTrue:[
        self invalidate.
    ].
    showSeconds ifTrue:[
        deltaT := 0.5
    ] ifFalse:[
        deltaT := 5
    ].
    Processor addTimedBlock:timeBlock afterSeconds:deltaT

    "Modified: 24.1.1997 / 16:46:14 / cg"
! !

!DigitalClockView methodsFor:'events'!

destroy
    "the view was destroyed - remove time-scheduled updateBlock"

    Processor removeTimedBlock:timeBlock.
    super destroy

    "Modified: 23.4.1996 / 21:14:17 / cg"
    "Created: 24.1.1997 / 16:13:36 / cg"
!

mapped
    "view was mapped - launch a time-scheduled updateBlock"

    super mapped.

    self startClock

    "Modified: 30.5.1996 / 09:37:44 / cg"
    "Created: 24.1.1997 / 16:13:57 / cg"
!

sizeChanged:how
    |sX sY pref scaled|

    pref := self preferredExtent.
    sX := self width / pref x.
    sY := self height / pref y.

    digitBitmaps notNil ifTrue:[
        1 to:10 do:[:i |
            scaled := ((digitBitmaps at:i) magnifiedBy:(sX @ sY)).
            scaledDigitBitmaps 
                at:i
                put:(scaled onDevice:device).
        ].
    ].
    colonBitmap notNil ifTrue:[
        scaledColonBitmap := (colonBitmap magnifiedBy:(sX @ sY)) onDevice:device
    ]

    "Modified: 22.3.1997 / 17:33:44 / cg"
! !

!DigitalClockView methodsFor:'initialization'!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    colonBitmap notNil ifTrue:[colonBitmap := colonBitmap onDevice:device].
    digitBitmaps notNil ifTrue:[
        1 to:10 do:[:i |
            |b|

            b := digitBitmaps at:i.
            digitBitmaps at:i put:(b onDevice:device)
        ].
    ]

    "Created: 24.1.1997 / 16:13:06 / cg"
    "Modified: 22.3.1997 / 17:33:08 / cg"
!

initialize
    super initialize.

    showSeconds := true.

    colonBitmap := ToolbarIconLibrary colonBitmap.

    digitBitmaps := Array new:10.
    0 to:9 do:[:i |
        |img|

        img := ToolbarIconLibrary perform:(('led%1' bindWith:i) asSymbol).
        digitBitmaps at:i+1 put:img
    ].

    scaledColonBitmap := nil.
    scaledDigitBitmaps := Array new:10.

    "
     DigitalClockView new open
    "
!

startClock
    "launch a time-scheduled updateBlock"

    "trigger timeout block in a second"
    timeBlock := [self showTime].
    Processor addTimedBlock:timeBlock afterSeconds:2

    "Created: 24.1.1997 / 16:14:14 / cg"
! !

!DigitalClockView methodsFor:'queries'!

preferredExtent
    |scale|

    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].
    colonBitmap isNil ifTrue:[
        ^ super preferredExtent
    ].

    showSeconds ifFalse:[
        scale := (5@1).
    ] ifTrue:[
        scale := 8@1.
    ].

    ^ colonBitmap extent * scale.

    "Modified: 22.3.1997 / 17:31:37 / cg"
! !

!DigitalClockView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/DigitalClockView.st,v 1.18 2017-01-03 13:49:06 stefan Exp $'
! !

