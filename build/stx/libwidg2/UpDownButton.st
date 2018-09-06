"
 COPYRIGHT (c) 1997 eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"



"{ Package: 'stx:libwidg2' }"

View subclass:#UpDownButton
	instanceVariableNames:'orientation upButton downButton'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!UpDownButton class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 eXept Software AG
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
    an up/down button - simply two buttons in one view.
    This is also called SpinButton.

    [author:]
        Claus Gittinger

    [see also:]
        ArrowButton
        ComboUpDownView
"
!

examples
"
                                                                [exBegin]
     |top ud|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     ud := UpDownButton in:top.
     ud origin:(10 @ 10).

     ud upAction:[Transcript showCR:'up'].
     ud downAction:[Transcript showCR:'down'].
     top open.
                                                                [exEnd]

                                                                [exBegin]
     |top ud|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     ud := UpDownButton in:top.
     ud origin:(10 @ 10).
     ud model:[:arg| Transcript showCR:arg].
     top open.
                                                                [exEnd]

                                                                [exBegin]
     |top ud|

     top := StandardSystemView new.
     top extent:(300 @ 200).

     ud := UpDownButton in:top.
     ud orientation:#horizontal.
     ud origin:(10 @ 10).

     ud upAction:[Transcript showCR:'up'].
     ud downAction:[Transcript showCR:'down'].
     top open.
                                                                [exEnd]
"

! !

!UpDownButton methodsFor:'accessing-behavior'!

downAction:aBlock
    "set the down-action"

    downButton action:aBlock
!

enabled

    ^ upButton enabled.

    "Created: / 30.3.1999 / 17:01:43 / stefan"
!

enabled:aBoolean

    upButton enabled:aBoolean.
    downButton enabled:aBoolean.

    "Created: / 30.3.1999 / 15:47:11 / stefan"
!

upAction:aBlock
    "set the up-action"

    upButton action:aBlock
! !

!UpDownButton methodsFor:'accessing-channels'!

backgroundChannel
    "return a valueHolder for the background color"

    ^ upButton backgroundChannel
!

backgroundChannel: aValueHolder
    "set a valueHolder for the background color"

    upButton backgroundChannel: aValueHolder.
    downButton backgroundChannel: aValueHolder
!

enableChannel
    "return a valueHolder for the enabled-state"

    ^ upButton enableChannel

    "Modified: / 30.3.1999 / 16:56:32 / stefan"
!

enableChannel: aValueHolder
    "set a valueHolder for the enabled-state"

    upButton enableChannel: aValueHolder.
    downButton enableChannel: aValueHolder
!

foregroundChannel
    "return a valueHolder for the foreground color"

    ^ upButton foregroundChannel
!

foregroundChannel: aValueHolder
    "set a valueHolder for the foreground color"

    upButton foregroundChannel: aValueHolder.
    downButton foregroundChannel: aValueHolder
!

model:aModel

    |m|

    aModel notNil ifTrue:[
        m := self.
        upButton changeMessage:#changeUp:.
        downButton changeMessage:#changeDown:.
    ].
    upButton model:m.
    downButton model:m.
    ^ super model:aModel

    "Modified: / 30.3.1999 / 17:45:59 / stefan"
! !

!UpDownButton methodsFor:'accessing-colors'!

backgroundColor
    "return the backgroundColor"

    ^upButton backgroundColor

!

backgroundColor:aColor
    "set the backgroundColor"

    aColor ~~ upButton backgroundColor ifTrue:[
        upButton backgroundColor:aColor.
        downButton backgroundColor:aColor.
        self invalidateRepairNow:true
    ]

    "Modified: / 6.6.1998 / 19:53:50 / cg"
!

foregroundColor
    "return the foregroundColor"

    ^upButton foregroundColor

!

foregroundColor:aColor
    "set the foregroundColor"

    aColor ~~ upButton foregroundColor ifTrue:[
        upButton foregroundColor:aColor.
        downButton foregroundColor:aColor.
        self invalidateRepairNow:true
    ]

    "Modified: / 6.6.1998 / 19:53:44 / cg"
!

viewBackground:aColor
    upButton viewBackground:aColor.
    downButton viewBackground:aColor.
    super viewBackground:aColor.
! !

!UpDownButton methodsFor:'accessing-components'!

downButton
    "return the downButton"

    ^ downButton
!

upButton
    "return the upButton"

    ^ upButton
! !

!UpDownButton methodsFor:'accessing-look'!

orientation
    "return the orientation (a symbol)"

    ^ orientation
!

orientation:aSymbol
    "set the orientation (#horizontal or #vertical)"

    orientation := aSymbol.

    self initializeButtonDimensions.
    self initializeButtonForms
! !

!UpDownButton methodsFor:'change & update'!

sizeChanged:how

    super sizeChanged:how.

    self initializeButtonDimensions
! !

!UpDownButton methodsFor:'event handling'!

changeDown:aValue
    "down button was pressed, send to my model"

    self sendChangeMessageWith:#down

    "Modified: / 30.3.1999 / 17:28:50 / stefan"
!

changeUp:aValue
    "up button was pressed, send to my model"

    self sendChangeMessageWith:#up

    "Created: / 30.3.1999 / 17:28:26 / stefan"
!

keyPress:aKey x:x y:y
    "simulate a buttonPress/release"

    <resource: #keyboard (#CursorRight #CursorUp #CursorLeft #CursorDown)>

   |theButton theController|

    ((aKey == #CursorUp)
    or:[aKey == #CursorRight
    or:[aKey == $+]]) ifTrue:[
        theButton := upButton
    ] ifFalse:[
        ((aKey == #CursorDown)
        or:[aKey == #CursorLeft 
        or:[aKey == $-]]) ifTrue:[
            theButton := downButton
        ].
    ].
    theButton notNil ifTrue:[
        theController := theButton controller.
        theController pressed:true.
        theController pressed:false.
        ^ self
    ].
    ^ super keyPress:aKey x:x y:y

    "Created: / 21.4.1998 / 19:48:28 / cg"
    "Modified: / 21.4.1998 / 19:56:28 / cg"
! !

!UpDownButton methodsFor:'focus handling'!

showFocus:explicit 
    "display myself as having-focus"

    (upButton enabled or:[downButton enabled]) ifTrue: [
        super showFocus:explicit
    ]
! !

!UpDownButton methodsFor:'initialization'!

initialize

    orientation := #vertical.

    super initialize.
    self initializeButtons
!

initializeButtonDimensions
    |upOrigin downOrigin upCorner downCorner|

    orientation == #vertical ifTrue:[
        upOrigin := 0@0.
        upCorner := (width - 1) @ (height // 2).
        downOrigin := 0 @ (height // 2 + 1).
        downCorner := (width - 1) @ (height - 1)
    ] ifFalse:[
        downOrigin := 0@0.
        downCorner := (width // 2) @ (height - 1).
        upOrigin := (width // 2 + 1) @ 0.
        upCorner := (width - 1) @ (height - 1)
    ].

    upButton   origin:upOrigin.
    upButton   corner:upCorner.
    downButton origin:downOrigin.
    downButton corner:downCorner.

!

initializeButtonForms
    |upLabel downLabel upPref downPref prefW prefH|

    orientation == #vertical ifTrue:[
        upLabel := ArrowButton defaultWIN32ArrowButtonFormForDirection:#up onDevice:nil. 
        downLabel := ArrowButton defaultWIN32ArrowButtonFormForDirection:#down onDevice:nil.
    ] ifFalse:[
        downLabel := ArrowButton defaultWIN32ArrowButtonFormForDirection:#left onDevice:nil.
        upLabel := ArrowButton defaultWIN32ArrowButtonFormForDirection:#right onDevice:nil.
    ].
    upButton label:upLabel.
    downButton label:downLabel.

    upPref := upButton preferredExtent.
    downPref := downButton preferredExtent.

    orientation == #vertical ifTrue:[
        prefW := upPref x max:(downPref x).
        prefH := upPref y + (downPref y).
    ] ifFalse:[
        prefW := upPref x + (downPref x).
        prefH := upPref y max: (downPref y).
    ].

    self preferredExtent:prefW@prefH.
!

initializeButtons
    upButton := Button in:self "ArrowButton upIn:self".
    upButton autoRepeat:true.

    downButton := Button in:self "ArrowButton downIn:self".
    downButton autoRepeat:true.

    self initializeButtonDimensions.
    self initializeButtonForms
! !

!UpDownButton class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/UpDownButton.st,v 1.22 2004-10-26 10:52:24 cg Exp $'
! !
