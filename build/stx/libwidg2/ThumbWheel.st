"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

View subclass:#ThumbWheel
	instanceVariableNames:'orientation synchronousOperation thumbPosition thumbColor
		thumbShadowColor thumbLightColor thumbEnteredColor tallyLevel
		tallyAngle rangeStart rangeEnd rangeStep angleRange
		unitsPerRotation entered press pressPos scrollAction
		endlessRotation startMoveAction endMoveAction keyboardStep'
	classVariableNames:'DefaultViewBackground DefaultThumbColor DefaultThumbShadowColor
		DefaultThumbLightColor DefaultTallyMarks DefaultTallyLevel
		DefaultLevel DefaultBorderWidth'
	poolDictionaries:''
	category:'Views-Interactors'
!

!ThumbWheel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
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
    A thumbWheel is like a slider, but looks different ...
    ThumbWheels are useful with 3D applications, to control
    things like rotation, translation and magnification.

    [author:]
	Claus Gittinger

    [see also:]
	Slider ScrollBar StepSlider
"
!

examples
"
  basic setup:
							[exBegin]
    |top wheel|

    top := StandardSystemView new.
    top extent:200@200.

    wheel := ThumbWheel in:top.
    wheel orientation:#vertical.
    wheel level:1.

    wheel origin:0.0@0.0; extent:(wheel preferredExtent).

    top open.
							[exEnd]

  two of them:
							[exBegin]
    |top wheel1 wheel2|

    top := StandardSystemView new.
    top extent:200@200.

    wheel1 := ThumbWheel in:top.
    wheel1 orientation:#vertical.
    wheel1 level:1.

    wheel1 origin:0.0@0.0; extent:(wheel1 preferredExtent).

    wheel2 := ThumbWheel in:top.
    wheel2 orientation:#horizontal.
    wheel2 level:1.

    wheel2 origin:0.0@1.0; extent:(wheel2 preferredExtent).
    wheel2 topInset:(wheel2 preferredExtent y negated).
    wheel2 bottomInset:(wheel2 preferredExtent y).
    top open.
							[exEnd]

  performing an action:
							[exBegin]
    |top wheel|

    top := StandardSystemView new.
    top extent:200@200.

    wheel := ThumbWheel in:top.
    wheel orientation:#vertical.
    wheel level:1.

    wheel origin:0.0@0.0; extent:(wheel preferredExtent).
    wheel scrollAction:[:value | Transcript showCR:value rounded].
    top open.
							[exEnd]
  operating on a model:
							[exBegin]
    |top wheel model|

    model := ValueHolder new.
    model
	onChangeSend:#value
	to:[Transcript show:'value now: '; showCR:model value rounded].

    top := StandardSystemView new.
    top extent:200@200.

    wheel := ThumbWheel in:top.
    wheel orientation:#vertical.
    wheel level:1.

    wheel origin:0.0@0.0; extent:(wheel preferredExtent).
    wheel model:model.
    top open.
							[exEnd]
  endless rotation:
							[exBegin]
    |top wheel model|

    model := ValueHolder new.
    model
	onChangeSend:#value
	to:[Transcript show:'value now: '; showCR:model value rounded].

    top := StandardSystemView new.
    top extent:200@200.

    wheel := ThumbWheel in:top.
    wheel orientation:#vertical.
    wheel level:1.
    wheel endlessRotation:true.

    wheel origin:0.0@0.0; extent:(wheel preferredExtent).
    wheel model:model.
    top open.
							[exEnd]
  concrete example:
							[exBegin]
    |top wheel1 wheel2 image magX magY hHolder vHolder imageView|

    magX := magY := 1.

    hHolder := ValueHolder new.
    hHolder
	onChangeSend:#value
	to:[
	    magX := hHolder value * 2 / 360.
	    magX = 0 ifTrue:[magX := 0.01].
	    Transcript show:'magX now '; showCR:magX.
	    imageView clear.
	    imageView magnification:magX@magY].

    vHolder := ValueHolder new.
    vHolder
	onChangeSend:#value
	to:[
	    magY := vHolder value * 2 / 360.
	    magY = 0 ifTrue:[magY := 0.01].
	    Transcript show:'magY now '; showCR:magY.
	    imageView clear.
	    imageView magnification:magX@magY].

    top := StandardSystemView new.
    top extent:200@200.

    wheel1 := ThumbWheel in:top.
    wheel1 orientation:#vertical.
    wheel1 level:1.
    wheel1 origin:0.0@0.0; extent:(wheel1 preferredExtent).
    wheel1 model:vHolder.

    wheel2 := ThumbWheel in:top.
    wheel2 orientation:#horizontal.
    wheel2 level:1.
    wheel2 origin:0.0@1.0; extent:(wheel2 preferredExtent).
    wheel2 topInset:(wheel2 preferredExtent y negated).
    wheel2 bottomInset:(wheel2 preferredExtent y).
    wheel2 model:hHolder.

    imageView := ImageEditView in:top.
    imageView level:1.
    imageView origin:0.0@0.0 corner:1.0@1.0.
    imageView leftInset:(wheel1 preferredExtent x).
    imageView bottomInset:(wheel2 preferredExtent y).
    imageView image:(Image fromFile:'bitmaps/garfield.gif').
    top open.
							[exEnd]

"
! !

!ThumbWheel methodsFor:'accessing'!

keyboardStep
    "return the scrollers keyboard step. If non-nil,
     that's the stepping value used with cursorUp/cursorDown keys.
     (not used with Scrollers, but provided for subclasses)"

    ^ keyboardStep
!

keyboardStep:aNumber
    "set the scrollers keyboard step. If non-nil,
     that's the stepping value used with cursorUp/cursorDown keys.
     (not used with Scrollers, but provided for subclasses)"

    keyboardStep := aNumber
!

start
    "return the wheels range minimum."

    ^ rangeStart

    "Created: 1.4.1997 / 12:30:04 / cg"
    "Modified: 1.4.1997 / 12:52:31 / cg"
!

start:aNumber
    "set the wheels range minimum."

    rangeStart := aNumber

    "Created: 1.4.1997 / 12:30:54 / cg"
    "Modified: 1.4.1997 / 12:52:36 / cg"
!

start:start stop:stop
    "set the wheels range minimum."

    rangeStart := start.
    rangeEnd := stop.

    "Modified: / 1.4.1997 / 12:52:36 / cg"
    "Created: / 23.1.1998 / 15:06:04 / cg"
!

step
    "return the wheels range step."

    ^ rangeStep

    "Created: 1.4.1997 / 12:30:15 / cg"
    "Modified: 1.4.1997 / 12:53:05 / cg"
!

step:aNumber
    "set the wheels range step."

    rangeStep := aNumber

    "Created: 1.4.1997 / 12:30:32 / cg"
    "Modified: 1.4.1997 / 12:52:49 / cg"
!

stop
    "return the wheels range end."

    ^ rangeEnd

    "Created: 1.4.1997 / 12:30:09 / cg"
    "Modified: 1.4.1997 / 12:52:59 / cg"
!

stop:aNumber
    "set the wheels range end."

    rangeEnd := aNumber

    "Created: 1.4.1997 / 12:30:47 / cg"
    "Modified: 1.4.1997 / 12:52:54 / cg"
!

thumbOrigin:pos
    "same as thumbPosition (for protocol compatibility with sliders)"

    self thumbPosition:pos

    "Created: / 21.4.1998 / 20:57:20 / cg"
    "Modified: / 21.4.1998 / 20:58:43 / cg"
!

thumbPosition
    "sreturn the position"

    ^ thumbPosition

    "Created: / 21.4.1998 / 20:58:15 / cg"
!

thumbPosition:pos
    "set the wheels position; the argument should be in the start..stop
     interval."

    |newPos delta|

    delta := (rangeEnd-rangeStart).

    newPos := pos.
    endlessRotation ifTrue:[
	[newPos < rangeStart] whileTrue:[
	    newPos := newPos + delta
	].
	[newPos > rangeEnd] whileTrue:[
	    newPos := newPos - delta
	].
    ].
    newPos := (newPos max:rangeStart) min:rangeEnd.

    rangeStep notNil ifTrue:[
	newPos := newPos roundTo:rangeStep.
	rangeStep isInteger ifTrue:[
	    newPos := newPos asInteger
	]
    ].

    newPos ~= thumbPosition ifTrue:[
	thumbPosition := newPos.
	shown ifTrue:[
	    self invalidate.
	]
    ].

    "Created: / 27.9.1996 / 18:10:57 / cg"
    "Modified: / 6.6.1998 / 23:29:28 / cg"
! !

!ThumbWheel methodsFor:'accessing-behavior'!

endMoveAction
    "set the endMoveAction, a block which is evaluated when the wheel
     stops to move (i.e. the user releases the mouse).
     The default is nil (i.e. no action)"

    ^ endMoveAction

    "Created: / 18.8.1998 / 16:29:40 / cg"
    "Modified: / 18.8.1998 / 16:31:41 / cg"
!

endMoveAction:aBlock
    "set the endMoveAction, a block which is evaluated when the wheel
     stops to move (i.e. the user releases the mouse)."

    endMoveAction := aBlock.

    "Created: / 18.8.1998 / 16:30:40 / cg"
!

endlessRotation:aBoolean
    "if true, rotation wraps and endless rotation is permitted.
     If false (the default), rotation ends at rangeStart/rangeEnd."

    endlessRotation := aBoolean

    "Created: / 5.2.1998 / 22:20:28 / cg"
!

scrollAction
    "return the scrollAction, a block which is evaluated when the wheel
     is turned (i.e. for every change)."

    ^ scrollAction

    "Modified: / 18.8.1998 / 16:31:59 / cg"
!

scrollAction:aBlock
    "set the scrollAction, a block which is evaluated when the wheel
     is turned (i.e. for every change)."

    scrollAction := aBlock.

    "Modified: / 18.8.1998 / 16:31:52 / cg"
!

startMoveAction
    "return the startMoveAction, a block which is evaluated when the wheel
     starts to turn (i.e. the user clicks on it).
     The default is nil (i.e. no action)"

    ^ startMoveAction

    "Created: / 18.8.1998 / 16:29:36 / cg"
    "Modified: / 18.8.1998 / 16:31:16 / cg"
!

startMoveAction:aBlock
    "set the startMoveAction, a block which is evaluated when the wheel
     starts to turn (i.e. the user clicks on it)."

    startMoveAction := aBlock.

    "Modified: / 18.8.1998 / 16:30:53 / cg"
! !

!ThumbWheel methodsFor:'accessing-look'!

orientation
    "return the wheels orientation; #horizontal or #vertical"

    ^ orientation

    "Created: 1.4.1997 / 12:29:46 / cg"
!

orientation:aSymbol
    "set the wheels orientation; the argument may be one of
     #horizontal or #vertical"

    orientation := aSymbol.
    shown ifTrue:[
	self invalidate
    ]

    "Created: 27.9.1996 / 16:02:14 / cg"
    "Modified: 1.4.1997 / 12:50:22 / cg"
! !

!ThumbWheel methodsFor:'drawing'!

redrawX:x y:y width:w height:h
    "redraw the thumbWheel.
     Q: is it worth the effort - or should we simply use some bitmap ?"

    |halfHeight y0 y1 halfWidth x0 x1 thumbColor|

    halfHeight := height // 2.
    halfWidth := width // 2.
    y0 := 4.
    y1 := height - 4.
    x0 := 4.
    x1 := width - 4.

    gc paint:viewBackground. "/ View defaultViewBackgroundColor.
    gc fillRectangleX:x y:y width:w height:h.

    thumbColor := View defaultViewBackgroundColor.
    thumbColor ~= viewBackground ifTrue:[
        gc paint:thumbColor.
        orientation == #vertical ifTrue:[
            gc fillRectangleX:3 y:y0 width:width-6 height:height-8.
        ] ifFalse:[
            gc fillRectangleX:x0 y:3 width:width-8 height:height-6.
        ]
    ].

    ((thumbPosition truncateTo:tallyAngle))
    to:((thumbPosition + angleRange truncateTo:tallyAngle)+tallyAngle) by:tallyAngle do:[:a |
        |yT pA xT d|

        pA := a - thumbPosition.
        d := (pA degreesToRadians cos).
        yT := halfHeight + (d * (halfHeight - 4)) - 1.
        xT := halfWidth + (d * (halfWidth - 4)) - 1.

        xT := xT min:x1.
        yT := yT min:y1.

        (pA > (angleRange * 7 // 8)) ifTrue:[
            gc paint:shadowColor
        ] ifFalse:[
            gc paint:self blackColor.
        ].

        orientation == #vertical ifTrue:[
            gc displayLineFromX:3 y:yT toX:width-4 y:yT.
        ] ifFalse:[
            gc displayLineFromX:xT y:3 toX:xT y:height-4.
        ].

        (pA between:(angleRange * 4 // 8) and:(angleRange * 7 // 8)) ifTrue:[
            gc paint:self whiteColor.
            orientation == #vertical ifTrue:[
                gc displayLineFromX:3 y:yT-1 toX:width-5 y:yT-1.
            ] ifFalse:[
                gc displayLineFromX:xT-1 y:3 toX:xT-1 y:height-5.
            ].

            (pA between:(angleRange * 4 // 8) and:(angleRange * 6 // 8)) ifTrue:[
                gc paint:self whiteColor.
                orientation == #vertical ifTrue:[
                    gc displayLineFromX:3 y:yT-2 toX:width-5 y:yT-2.
                ] ifFalse:[
                    gc displayLineFromX:xT-2 y:3 toX:xT-2 y:height-5.
                ]
            ]
        ]
    ].

    gc paint:self whiteColor. "/lightColor.
    orientation == #vertical ifTrue:[
        gc displayLineFromX:2 y:y0 toX:2 y:y1.
    ] ifFalse:[
        gc displayLineFromX:x0 y:2 toX:x1 y:2.
    ].

    gc paint:shadowColor.
    orientation == #vertical ifTrue:[
        gc displayLineFromX:width-4 y:y0 toX:width-4 y:y1.
    ] ifFalse:[
        gc displayLineFromX:x0 y:height-4 toX:x1 y:height-4.
    ].
    gc displayLineFromX:width-4 y:y0-1 toX:width-4 y:y1+1.

    orientation == #vertical ifTrue:[
        gc displayLineFromX:width-4 y:y0 toX:width-4 y:y1.
    ] ifFalse:[
        gc displayLineFromX:x0 y:height-4 toX:x1 y:height-4.
    ].

    "Created: / 27.9.1996 / 16:04:49 / cg"
    "Modified: / 6.6.1998 / 23:30:38 / cg"
! !

!ThumbWheel methodsFor:'events'!

buttonMotion:state x:x y:y
    |deltaY deltaX d oldPos newPos|

    (state == 0 or:[press isNil]) ifTrue:[
	^ self
    ].
    deltaY := y - press y.
    deltaX := x - press x.

    "/scale acc. to angleRange
    orientation == #vertical ifTrue:[
	d := deltaY / height * angleRange.
    ] ifFalse:[
	d := deltaX / width * angleRange
    ].
    rangeStep notNil ifTrue:[
	d := d * (rangeStep * 3)
    ].

    oldPos := thumbPosition.
    newPos := pressPos + d.

"/    newPos > rangeEnd ifTrue:[
"/        newPos := rangeEnd
"/    ].
"/    newPos < rangeStart ifTrue:[
"/        newPos := rangeStart
"/    ].

    newPos ~= oldPos ifTrue:[
	self thumbPosition:newPos.
	self repairDamage.

	synchronousOperation ifTrue: [
	    self tellOthers.
	].
    ].

    "Created: / 27.9.1996 / 17:38:57 / cg"
    "Modified: / 16.6.1998 / 10:24:40 / cg"
!

buttonPress:button x:x y:y
    press := x@y.

    "/ fetch the current value; to avoid a jump.
    model notNil ifTrue:[
	thumbPosition := (model value ? 0).
    ].
    pressPos := thumbPosition.
    startMoveAction notNil ifTrue:[
	startMoveAction value
    ].

    "Created: / 27.9.1996 / 17:37:57 / cg"
    "Modified: / 18.8.1998 / 16:32:21 / cg"
!

buttonRelease:button x:x y:y
    synchronousOperation ifFalse: [
	self tellOthers.
    ].
    endMoveAction notNil ifTrue:[
	endMoveAction value
    ].

    "Created: / 27.9.1996 / 18:13:35 / cg"
    "Modified: / 18.8.1998 / 16:32:30 / cg"
!

keyPress:key x:x y:y
    <resource: #keyboard (#CursorRight #CursorUp #CursorLeft #CursorDown #+ #-)>

    |step|

    step := self verticalScrollStep.

    (key == #CursorRight
    or:[key == #CursorDown
    or:[key == $+]]) ifTrue:[
	self scrollStep:step.
	^ self
    ].

    (key == #CursorLeft
    or:[key == #CursorUp
    or:[key == $-]]) ifTrue:[
	self scrollStep:step negated.
	^ self
    ].

    super keyPress:key x:x y:y

    "Modified: / 21.4.1998 / 20:49:32 / cg"
    "Created: / 21.4.1998 / 20:55:29 / cg"
!

sizeChanged:how
    super sizeChanged:how.
    shown ifTrue:[
	self invalidate
    ]

    "Created: / 18.4.1998 / 02:36:04 / cg"
    "Modified: / 18.4.1998 / 14:10:16 / cg"
!

update:something with:aParameter from:changedObject
    "handle update from a model (if any)"

    (changedObject == model
    "and:[something == aspectMsg]") ifTrue:[
	self thumbPosition:(model value ? 0).
	^ self
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 16.6.1998 / 10:25:42 / cg"
! !

!ThumbWheel methodsFor:'forced scroll'!

scrollDown:amountToScroll
    "compatibility with SimpleView. This allows mouse wheel actions on Scrollers
     Note: this is used for horizontal scrollers, too (scrollRight)"

    self scrollStep:amountToScroll
!

scrollStep:delta
    "step by some delta"

    |oldOrg newOrg|

    oldOrg := thumbPosition.
    newOrg := ((oldOrg + delta) max:rangeStart) min:rangeEnd.
    oldOrg ~= newOrg ifTrue:[
	self thumbOrigin:newOrg.
	self tellOthers.
    ]

    "Created: / 21.4.1998 / 20:56:15 / cg"
    "Modified: / 21.4.1998 / 20:59:25 / cg"
!

scrollUp:amountToScroll
    "compatibility with SimpleView. This allows mouse wheel actions on Scrollers
     Note: this is used for horizontal scrollers, too (scrollLeft)"

    self scrollStep:amountToScroll negated
! !

!ThumbWheel methodsFor:'initialization'!

initialize
    "initialize - setup instvars from defaults"

    super initialize.

    orientation isNil ifTrue:[orientation := #vertical].

    entered := false.
    synchronousOperation := true.
    endlessRotation := false.

    thumbPosition := 0.

    rangeStart := 0.
    rangeEnd := 360.
    rangeStep := nil.   "/ meaning: arbitrary precision

    angleRange := 150.  "/ 180 degrees are visible
    tallyAngle := 10.   "/ tally every 10 degrees
    unitsPerRotation := 360.

    "Modified: / 5.2.1998 / 22:20:39 / cg"
! !

!ThumbWheel methodsFor:'private'!

tellOthers
    "notify others of a change"

    "
     the ST/X way of notifying scrolls
    "
    scrollAction notNil ifTrue:[
        scrollAction value:thumbPosition
    ].
    "
     the ST-80 way of notifying scrolls
    "
    self sendChangeMessageWith:thumbPosition.
    dependents notNil ifTrue:[ self changed:#scrollerPosition ].

    "Created: 27.9.1996 / 18:14:02 / cg"
    "Modified: 28.5.1997 / 16:04:16 / cg"
! !

!ThumbWheel methodsFor:'queries'!

preferredExtent
    "return a useful default extent"

    |ppmm|

    preferredExtent isNil ifTrue:[
        ppmm := device pixelPerMillimeter.
        orientation == #vertical ifTrue:[
            preferredExtent := (ppmm * (5 @ 30)) rounded
        ] ifFalse:[
            preferredExtent := (ppmm * (30 @ 5)) rounded
        ].
    ].

    ^ preferredExtent

    "Modified: 28.5.1997 / 16:03:55 / cg"
!

verticalScrollStep
    "mouse wheel: scroll step
     Note: this is used for horizontal scrollers, too"

    ^ keyboardStep ? (rangeEnd - rangeStart / 10)
! !

!ThumbWheel class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

