"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

ScrollBar subclass:#SteppingSlider
	instanceVariableNames:'stepIncrement'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!SteppingSlider class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    SteppingSliders are like Sliders, but add step-up and step-down
    buttons (which increment/decrement the value).
    (you can also think of them as a ScrollBar with a slider instead of
     a scroller as component)
"
!

examples 
"
    non model operation:
                                                                [exBegin]
      |top sl|

      top := StandardSystemView extent:200@200.
      sl := SteppingSlider in:top.
      sl origin:(0.0@0.0) corner:(sl width@1.0).
      sl scrollAction:[:pos | Transcript showCR:pos].    
      top open
                                                                [exEnd]


    change the step:
                                                                [exBegin]
      |top sl|

      top := StandardSystemView extent:200@200.
      sl := SteppingSlider in:top.
      sl origin:(0.0@0.0) corner:(sl width@1.0).
      sl scrollAction:[:pos | Transcript showCR:pos].    
      sl stepIncrement:10.
      top open
                                                                [exEnd]


    model operation (watch the value):
                                                                [exBegin]
      |model top sl fld|

      model := 0 asValue.

      top := StandardSystemView extent:200@200.
      top label:'slider on model'.
      sl := SteppingSlider in:top.
      sl origin:(0.0@0.0) corner:(sl width@1.0).
      sl model:model.
      top open.

      top := StandardSystemView extent:200@200.
      top label:'inputField on model'.
      fld := EditField in:top.
      fld origin:(0.0@0.0) corner:(1.0 @ fld height).
      fld converter:(PrintConverter new initForNumber); model:model.
      top open
                                                                [exEnd]


    two views on the same model:
                                                                [exBegin]
      |model top sl fld|

      model := 0 asValue.

      top := StandardSystemView extent:200@200.
      top label:'slider on model'.
      sl := SteppingSlider in:top.
      sl origin:(0.0@0.0) corner:(sl width@1.0).
      sl model:model.
      top open.

      top := StandardSystemView extent:200@200.
      top label:'slider on model'.
      sl := ThumbWheel in:top.
      sl origin:(0.0@0.0) corner:(20@1.0).
      sl model:model.
      top open.
                                                                [exEnd]
"
! !

!SteppingSlider methodsFor:'accessing'!

model:aModel
    "set the model - forwarded to the thumb.
     if nonNil, this will get the thumbs origin
     via #value: messages"

    thumb model:aModel

    "Modified: 28.5.1997 / 15:07:55 / cg"
!

start:start stop:stop step:step
    "set start (min), stop (max) and step increment.
     The increment is used when clicking on a step button"

    thumb start:start stop:stop.
    stepIncrement := step

    "Modified: 28.5.1997 / 15:03:56 / cg"
!

step
    "return the step increment.
     The increment is used when clicking on a step button"

    ^ stepIncrement

    "Modified: 28.5.1997 / 15:04:01 / cg"
!

step:aNumber
    "same as stepIncrement;
     set the value used for stepping (defaults to 1)"

    stepIncrement := aNumber
!

stepIncrement:aNumber 
    "set the value used for stepping (defaults to 1).
     Same as #step: for compatibility."

    stepIncrement := aNumber

    "Modified: 28.5.1997 / 15:04:25 / cg"
! !

!SteppingSlider methodsFor:'event handling'!

keyPress:key x:x y:y
    <resource: #keyboard (#CursorRight #CursorUp #CursorLeft #CursorDown #+ #-)>

    |step|
"/    enabled ifFalse:[^ self].

    step := thumb keyboardStep ? stepIncrement.

    (key == #CursorLeft
    or:[key == #CursorUp
    or:[key == $-]]) ifTrue:[
        self scrollStep:step negated.
        ^ self
    ].

    (key == #CursorRight
    or:[key == #CursorDown
    or:[key == $+]]) ifTrue:[
        self scrollStep:step.
        ^ self
    ].

    super keyPress:key x:x y:y
! !

!SteppingSlider methodsFor:'initialization'!

createElements
    "create the scroller and the two step buttons"

    self orientation == #horizontal ifTrue:[
        button1 := ArrowButton leftIn:self.
        button1 name:'LeftButton'.
        button2 := ArrowButton rightIn:self.
        button2 name:'RightButton'.
        thumb := HorizontalSlider in:self.
    ] ifFalse:[
        button1 := ArrowButton upIn:self.
        button1 name:'UpButton'.
        button2 := ArrowButton downIn:self.
        button2 name:'DownButton'.
        thumb := Slider in:self.
    ].

    "Modified: 28.5.1997 / 15:09:50 / cg"
!

initialize
    "initialize; the increment is set to 1 (one)"

    super initialize.

    stepIncrement := 1.
    buttonLayout := #around.

    self scrollDownAction:[self scrollStepDown].
    self scrollUpAction:[self scrollStepUp].

    "Modified: 28.5.1997 / 16:12:04 / cg"
! !

!SteppingSlider methodsFor:'misc'!

doesNotUnderstand:aMessage
    "forward any unimplemented message to the scroller"

    ^ aMessage sendTo:thumb

    "Modified: 28.5.1997 / 15:05:37 / cg"
! !

!SteppingSlider methodsFor:'private'!

scrollStep:delta
    "step by some delta"

    thumb scrollStep:delta

    "Modified: / 21.4.1998 / 20:52:49 / cg"
!

scrollStepDown
    "sent when the step-down button is pressd"

    self scrollStep:stepIncrement

    "Modified: 28.5.1997 / 15:11:02 / cg"
!

scrollStepUp
    "sent when the step-up button is pressd"

    self scrollStep:stepIncrement negated

    "Modified: 28.5.1997 / 15:11:08 / cg"
! !

!SteppingSlider class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/SteppingSlider.st,v 1.14 2011-02-05 17:37:29 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg2/SteppingSlider.st,v 1.14 2011-02-05 17:37:29 stefan Exp $'
! !
