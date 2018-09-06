"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

Button subclass:#ArrowButton
	instanceVariableNames:'arrowStyle direction'
	classVariableNames:'DownArrowForm UpArrowForm LeftArrowForm RightArrowForm
		DisabledDownArrowForm DisabledUpArrowForm DisabledLeftArrowForm
		DisabledRightArrowForm ActiveDownArrowForm ActiveUpArrowForm
		ActiveLeftArrowForm ActiveRightArrowForm EnteredDownArrowForm
		EnteredUpArrowForm EnteredLeftArrowForm EnteredRightArrowForm
		CachedStyle DefaultArrowStyle DefaultBackgroundColor
		DefaultForegroundColor DefaultActiveBackgroundColor
		DefaultActiveForegroundColor DefaultEnteredBackgroundColor
		DefaultEnteredForegroundColor DefaultDisabledForegroundColor
		DefaultArrowButtonActiveLevel DefaultArrowButtonPassiveLevel'
	poolDictionaries:''
	category:'Views-Interactors'
!

!ArrowButton class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    ArrowButtons display an arrow as their label; they are mainly
    used for scrollbars, but can be useful on their own in some applications.
    Beside the contents, their default behavior is to perform their action
    when pressed - not (as is the default for normal buttons) when released.

    Indivdual ArrowButtons can be created by sending one of:
            ArrowButton upIn:aView /downIn: / leftIn: or rightIn:
    passing the parent view as argument.

    See examples.


    [styleSheet parameters:]

        arrowButtonStyle            <Symbol>        the style of the button;
                                                    #motif, #st80 or nil (default)
        arrowButtonForegroundColor  <nil | Color>   foregroundColor 
        arrowButtonBackgroundColor  <nil | Color>   backgroundColor 

        arrowButtonActiveForegroundColor            foregroundColor when pressed
        arrowButtonActiveBackgroundColor            backgroundColor when pressed

        arrowButtonEnteredForegroundColor           foregroundColor when mouse pointer entered
        arrowButtonEnteredBackgroundColor           backgroundColor when mouse pointer entered

    [author:]
        Claus Gittinger

    [See also:]
         Button  Toggle CheckToggle CheckBox
         ScrollBar

"
!

examples 
"
    example1:
                                                                        [exBegin]
        |v p b1 b2 b3 b4|

        v := StandardSystemView extent:200@200.
        p := HorizontalPanelView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:v.
        b1 := ArrowButton upIn:p.
        b2 := ArrowButton downIn:p.
        b3 := ArrowButton leftIn:p.
        b4 := ArrowButton rightIn:p.

        b1 action:['whatEver you like here ...'].
        b2 action:['whatEver you like here ...'].
        b3 action:['whatEver you like here ...'].
        b4 action:['whatEver you like here ...'].

        v open
                                                                        [exEnd]


    example2:
                                                                        [exBegin]
        |v p b1 b2 b3 b4|

        v := StandardSystemView extent:200@200.
        p := HorizontalPanelView origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:v.
        b1 := (ArrowButton upIn:p) extent:30@30.
        b2 := (ArrowButton downIn:p) extent:30@30.
        b3 := (ArrowButton leftIn:p) extent:30@30.
        b4 := (ArrowButton rightIn:p) extent:30@30.

        b1 action:['whatEver you like here ...'].
        b2 action:['whatEver you like here ...'].
        b3 action:['whatEver you like here ...'].
        b4 action:['whatEver you like here ...'].

        v open
                                                                        [exEnd]


    example3:
                                                                        [exBegin]
        |v p b1 b2 b3 b4|

        v := StandardSystemView extent:200@200.
        p := View origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:v.
        b1 := (ArrowButton upIn:p) origin:(0.33 @ 0.0) corner:(0.67 @ 0.33).
        b3 := (ArrowButton leftIn:p) origin:(0.0 @ 0.33) corner:(0.33 @ 0.67).
        b4 := (ArrowButton rightIn:p) origin:(0.67 @ 0.33) corner:(1.0 @ 0.67).
        b2 := (ArrowButton downIn:p) origin:(0.33 @ 0.67) corner:(0.67 @ 1.0).

        b1 action:['whatEver you like here ...'].
        b2 action:['whatEver you like here ...'].
        b3 action:['whatEver you like here ...'].
        b4 action:['whatEver you like here ...'].

        v open
                                                                        [exEnd]


    example4 (not good coding style, to explicitely use a particular style,
              just a demonstration how it looks ..):
                                                                        [exBegin]
        |v p b1 b2 b3 b4 oldStyle|

        oldStyle := View defaultStyle.
        View defaultStyle:#motif.

        v := StandardSystemView extent:100@100.
        p := View origin:0.0 @ 0.0 corner:1.0 @ 1.0 in:v.

        b1 := (ArrowButton upIn:p) origin:(0.33 @ 0.0) corner:(0.67 @ 0.33).
        b3 := (ArrowButton leftIn:p) origin:(0.0 @ 0.33) corner:(0.33 @ 0.67).
        b4 := (ArrowButton rightIn:p) origin:(0.67 @ 0.33) corner:(1.0 @ 0.67).
        b2 := (ArrowButton downIn:p) origin:(0.33 @ 0.67) corner:(0.67 @ 1.0).

        b1 action:['whatEver you like here ...'].
        b2 action:['whatEver you like here ...'].
        b3 action:['whatEver you like here ...'].
        b4 action:['whatEver you like here ...'].

        View defaultStyle:oldStyle.
        v open
                                                                        [exEnd]
"
! !

!ArrowButton class methodsFor:'instance creation'!

downIn:aView
    "create and return a new down-button in aView"

    ^ (super in:aView) direction:#down

    "Modified: 22.1.1997 / 11:59:08 / cg"
!

leftIn:aView
    "create and return a new left-button in aView"

    ^ (super in:aView) direction:#left

    "Modified: 22.1.1997 / 11:59:14 / cg"
!

new
    "return a new arrowButton - direction defaults to #up"

    ^ super new direction:#up
!

rightIn:aView
    "create and return a new right-button in aView"

    ^ (super in:aView) direction:#right

    "Modified: 22.1.1997 / 11:59:21 / cg"
!

upIn:aView
    "create and return a new up-button in aView"

    ^ (super in:aView) direction:#up

    "Modified: 22.1.1997 / 11:59:27 / cg"
! !

!ArrowButton class methodsFor:'defaults'!

DownArrowForm

    ^DownArrowForm
!

LeftArrowForm

    ^LeftArrowForm
!

RightArrowForm

    ^RightArrowForm
!

UpArrowForm

    ^UpArrowForm
!

downArrowButtonForm:styleSymbol on:aDevice
    "return the form used for the scrollDown Button"

    ^ self arrowButtonFormForStyle:styleSymbol direction:#down on:aDevice
!

leftArrowButtonForm:styleSymbol on:aDevice
    "return the form used for the scrollLeft Button"

    ^ self arrowButtonFormForStyle:styleSymbol direction:#left on:aDevice
!

rightArrowButtonForm:styleSymbol on:aDevice
    "return the form used for the scrollRight Button"

    ^ self arrowButtonFormForStyle:styleSymbol direction:#right on:aDevice
!

upArrowButtonForm:styleSymbol on:aDevice
    "return the form used for the scrollUp Button"

    ^ self arrowButtonFormForStyle:styleSymbol direction:#up on:aDevice
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'arrowButton.style' 
                       #'arrowButton.activeLevel' #'arrowButton.passiveLevel'
                       #'arrowButton.backgroundColor' #'arrowButton.foregroundColor'
                       #'arrowButton.activeBackgroundColor' #'arrowButton.activeForegroundColor'
                       #'arrowButton.enteredBackgroundColor' #'arrowButton.enteredForegroundColor'
                       #'arrowButton.disabledForegroundColor' 

                       #'arrowButton.downForm'     #'arrowButton.upForm'
                       #'arrowButton.leftForm'     #'arrowButton.rightForm'

                       #'arrowButton.disabledDownForm'     #'arrowButton.disabledUpForm'
                       #'arrowButton.disabledLeftForm'     #'arrowButton.disabledRightForm'

                       #'arrowButton.activeDownForm'     #'arrowButton.activeUpForm'
                       #'arrowButton.activeLeftForm'     #'arrowButton.activeRightForm'

                       #'arrowButton.enteredDownForm'     #'arrowButton.enteredUpForm'
                       #'arrowButton.enteredLeftForm'     #'arrowButton.enteredRightForm'
                )>

    |styleSheet defaultScreen|

    styleSheet := StyleSheet.

    DefaultArrowStyle := styleSheet at:#'arrowButton.style' default:styleSheet name.
    DefaultArrowStyle := DefaultArrowStyle asSymbol.

    DefaultArrowButtonActiveLevel := styleSheet at:#'arrowButton.activeLevel'.
    DefaultArrowButtonPassiveLevel := styleSheet at:#'arrowButton.passiveLevel'.

    DefaultBackgroundColor := styleSheet colorAt:#'arrowButton.backgroundColor'.
    DefaultForegroundColor := styleSheet colorAt:#'arrowButton.foregroundColor'.
    DefaultActiveBackgroundColor := styleSheet colorAt:#'arrowButton.activeBackgroundColor'.
    DefaultActiveForegroundColor := styleSheet colorAt:#'arrowButton.activeForegroundColor'.
    DefaultEnteredBackgroundColor := styleSheet colorAt:#'arrowButton.enteredBackgroundColor'.
    DefaultEnteredForegroundColor := styleSheet colorAt:#'arrowButton.enteredForegroundColor'.
    DefaultDisabledForegroundColor := styleSheet colorAt:#'arrowButton.disabledForegroundColor'.

    DownArrowForm  := styleSheet at:#'arrowButton.downForm'.
    UpArrowForm    := styleSheet at:#'arrowButton.upForm'.
    LeftArrowForm  := styleSheet at:#'arrowButton.leftForm'.
    RightArrowForm := styleSheet at:#'arrowButton.rightForm'.

    ActiveDownArrowForm := styleSheet at:#'arrowButton.activeDownForm'.
    ActiveUpArrowForm := styleSheet at:#'arrowButton.activeUpForm'.
    ActiveLeftArrowForm := styleSheet at:#'arrowButton.activeLeftForm'.
    ActiveRightArrowForm := styleSheet at:#'arrowButton.activeRightForm'.

    EnteredDownArrowForm := styleSheet at:#'arrowButton.enteredDownForm'.
    EnteredUpArrowForm := styleSheet at:#'arrowButton.enteredUpForm'.
    EnteredLeftArrowForm := styleSheet at:#'arrowButton.enteredLeftForm'.
    EnteredRightArrowForm := styleSheet at:#'arrowButton.enteredRightForm'.

    defaultScreen := Screen default.
    DownArrowForm := UpArrowForm := LeftArrowForm := RightArrowForm := nil.
    DownArrowForm := self arrowButtonFormForStyle:DefaultArrowStyle direction:#down on:defaultScreen.
    UpArrowForm := self arrowButtonFormForStyle:DefaultArrowStyle direction:#up on:defaultScreen.
    LeftArrowForm := self arrowButtonFormForStyle:DefaultArrowStyle direction:#left on:defaultScreen.
    RightArrowForm := self arrowButtonFormForStyle:DefaultArrowStyle direction:#right on:defaultScreen.

    DisabledDownArrowForm := DisabledUpArrowForm := DisabledLeftArrowForm := DisabledRightArrowForm := nil.
    DisabledDownArrowForm := self disabledArrowButtonFormForStyle:DefaultArrowStyle direction:#down on:defaultScreen.
    DisabledUpArrowForm := self disabledArrowButtonFormForStyle:DefaultArrowStyle direction:#up on:defaultScreen.
    DisabledLeftArrowForm := self disabledArrowButtonFormForStyle:DefaultArrowStyle direction:#left on:defaultScreen.
    DisabledRightArrowForm := self disabledArrowButtonFormForStyle:DefaultArrowStyle direction:#right on:defaultScreen.

    ActiveDownArrowForm := ActiveUpArrowForm := ActiveLeftArrowForm := ActiveRightArrowForm := nil.
    ActiveDownArrowForm := self activeArrowButtonFormForStyle:DefaultArrowStyle direction:#down on:defaultScreen.
    ActiveUpArrowForm := self activeArrowButtonFormForStyle:DefaultArrowStyle direction:#up on:defaultScreen.
    ActiveLeftArrowForm := self activeArrowButtonFormForStyle:DefaultArrowStyle direction:#left on:defaultScreen.
    ActiveRightArrowForm := self activeArrowButtonFormForStyle:DefaultArrowStyle direction:#right on:defaultScreen.

    EnteredDownArrowForm := EnteredUpArrowForm := EnteredLeftArrowForm := EnteredRightArrowForm := nil.
    EnteredDownArrowForm := self enteredArrowButtonFormForStyle:DefaultArrowStyle direction:#down on:defaultScreen.
    EnteredUpArrowForm := self enteredArrowButtonFormForStyle:DefaultArrowStyle direction:#up on:defaultScreen.
    EnteredLeftArrowForm := self enteredArrowButtonFormForStyle:DefaultArrowStyle direction:#left on:defaultScreen.
    EnteredRightArrowForm := self enteredArrowButtonFormForStyle:DefaultArrowStyle direction:#right on:defaultScreen.


    "
     self updateStyleCache
    "

    "Modified: 31.8.1995 / 03:01:14 / claus"
    "Modified: 20.10.1997 / 13:50:57 / cg"
! !

!ArrowButton class methodsFor:'defaults-helpers'!

activeArrowButtonFormForStyle:styleSymbol direction:direction on:aDevice
    <resource: #style (
                       #'arrowButton.activeDownForm'
                       #'arrowButton.activeUpForm'
                       #'arrowButton.activeLeftForm'
                       #'arrowButton.activeRightForm'   

                       #'arrowButton.activeDownFormFile'
                       #'arrowButton.activeUpFormFile'
                       #'arrowButton.activeLeftFormFile'
                       #'arrowButton.activeRightFormFile'   
                      )>

    |formVariableName styleSheetName styleSheetFileName|

    direction = #left ifTrue:[
        formVariableName := #ActiveLeftArrowForm.
        styleSheetName := #'arrowButton.activeLeftForm'.
        styleSheetFileName := #'arrowButton.activeLeftFormFile'.
    ].
    direction = #right ifTrue:[
        formVariableName := #ActiveRightArrowForm.
        styleSheetName := #'arrowButton.activeRightForm'.
        styleSheetFileName := #'arrowButton.activeRightFormFile'.
    ].
    direction = #up ifTrue:[
        formVariableName := #ActiveUpArrowForm.
        styleSheetName := #'arrowButton.activeUpForm'.
        styleSheetFileName := #'arrowButton.activeUpFormFile'.
    ].
    direction = #down ifTrue:[
        formVariableName := #ActiveDownArrowForm.
        styleSheetName := #'arrowButton.activeDownForm'.
        styleSheetFileName := #'arrowButton.activeDownFormFile'.
    ].
    formVariableName isNil ifTrue:[
        self error:'invalid direction' mayProceed:true.
        ^ nil
    ].

    ^ self
        arrowButtonFormForStyle:styleSymbol 
        nameKey:styleSheetName fileNameKey:styleSheetFileName variableName:formVariableName 
        direction:direction useDefault:false on:aDevice
!

arrowButtonFormForStyle:styleSymbol direction:direction on:aDevice
    "return the form used for the scrollDown Button"

    <resource: #style (
                       #'arrowButton.downForm'
                       #'arrowButton.upForm'
                       #'arrowButton.leftForm'
                       #'arrowButton.rightForm'   

                       #'arrowButton.downFormFile'
                       #'arrowButton.upFormFile'
                       #'arrowButton.leftFormFile'
                       #'arrowButton.rightFormFile'   
                      )>

    |formVariableName styleSheetName styleSheetFileName|

    direction = #left ifTrue:[
        formVariableName := #LeftArrowForm.
        styleSheetName := #'arrowButton.leftForm'.
        styleSheetFileName := #'arrowButton.leftFormFile'.
    ].
    direction = #right ifTrue:[
        formVariableName := #RightArrowForm.
        styleSheetName := #'arrowButton.rightForm'.
        styleSheetFileName := #'arrowButton.rightFormFile'.
    ].
    direction = #up ifTrue:[
        formVariableName := #UpArrowForm.
        styleSheetName := #'arrowButton.upForm'.
        styleSheetFileName := #'arrowButton.upFormFile'.
    ].
    direction = #down ifTrue:[
        formVariableName := #DownArrowForm.
        styleSheetName := #'arrowButton.downForm'.
        styleSheetFileName := #'arrowButton.downFormFile'.
    ].
    formVariableName isNil ifTrue:[
        self error:'invalid direction' mayProceed:true.
        ^ nil
    ].

    ^ self
        arrowButtonFormForStyle:styleSymbol 
        nameKey:styleSheetName fileNameKey:styleSheetFileName variableName:formVariableName 
        direction:direction useDefault:true on:aDevice
!

arrowButtonFormForStyle:styleSymbol nameKey:styleSheetName fileNameKey:styleSheetFileName variableName:formVariableName direction:direction useDefault:useDefault on:aDevice
    "return the form used for the scrollDown Button"

    |form formFile|

    "
     use cached form, if device is appropriate
    "
    CachedStyle ~~ styleSymbol ifTrue:[
        self classVarAt:formVariableName put:nil
    ].

    form := self classVarAt:formVariableName.
    form notNil ifTrue:[
        form == #nil ifTrue:[
            ^ nil
        ].
        form device == aDevice ifTrue:[
            ^ form
        ].
    ].

    form := self styleSheet at:styleSheetName default:nil.
    form isNil ifTrue:[
        formFile := StyleSheet at:styleSheetFileName default:nil.
        formFile notNil ifTrue:[
            form := Smalltalk imageFromFileNamed:formFile forClass:self.
            form isNil ifTrue:[
                'ArrowButton [info]: no bitmapFile: ' infoPrint. formFile infoPrintCR.
            ] ifFalse:[
                form := form onDevice:aDevice.
            ]
        ].

        "
         form to use as a fallback, if no bitmap file is present
         (actually not really needed - just to show something useful, in case of a bad installation)
        "
        (form isNil and:[useDefault]) ifTrue:[
            form := self defaultArrowButtonFormForStyle:styleSymbol direction:direction onDevice:aDevice.
            form isNil ifTrue:[^ nil].
        ].
    ].

    "
     remember form for next use
    "
    CachedStyle := styleSymbol.
    self classVarAt:formVariableName put:(form ? #nil).

    ^ form

    "Modified: / 26.10.1997 / 17:01:54 / cg"
!

defaultArrowButtonFormForStyle:styleSymbol direction:direction onDevice:aDevice
    "return the default form used for the scrollUp Button 
     (if no styleSheet value is defined, and no form can be constructed)"

    styleSymbol = #st80 ifTrue:[
        ^ self defaultST80ArrowButtonFormForDirection:direction onDevice:aDevice.
    ].

    self styleSheet isWindowsStyle ifTrue:[
        ^ self defaultWIN32ArrowButtonFormForDirection:direction onDevice:aDevice
    ].

    ^ self defaultMACArrowButtonFormForDirection:direction onDevice:aDevice

    "
     self defaultArrowButtonFormForStyle:#macosx direction:#up onDevice:Screen
    "

    "Modified: / 26.3.1999 / 15:19:11 / cg"
!

defaultMACArrowButtonFormForDirection:direction onDevice:aDevice
    <resource: #programImage>

    |w h bits|

    w := h := 16.
    direction == #left ifTrue:[
        bits := #[
                 2r00000000 2r00000000
                 2r00000001 2r10000000
                 2r00000010 2r10000000
                 2r00000100 2r10000000
                 2r00001000 2r11111110
                 2r00010000 2r00000010
                 2r00100000 2r00000010
                 2r01000000 2r00000010
                 2r01000000 2r00000010
                 2r00100000 2r00000010
                 2r00010000 2r00000010
                 2r00001000 2r11111110
                 2r00000100 2r10000000
                 2r00000010 2r10000000
                 2r00000001 2r10000000
                 2r00000000 2r00000000
                ]
    ].
    direction == #right ifTrue:[
        bits := #[
                 2r00000000 2r00000000
                 2r00000001 2r10000000
                 2r00000001 2r01000000
                 2r00000001 2r00100000
                 2r01111111 2r00010000
                 2r01000000 2r00001000
                 2r01000000 2r00000100
                 2r01000000 2r00000010
                 2r01000000 2r00000010
                 2r01000000 2r00000100
                 2r01000000 2r00001000
                 2r01111111 2r00010000
                 2r00000001 2r00100000
                 2r00000001 2r01000000
                 2r00000001 2r10000000
                 2r00000000 2r00000000
                ]
    ].
    direction == #up ifTrue:[
        bits := #[
                 2r00000000 2r00000000
                 2r00000001 2r10000000
                 2r00000010 2r01000000
                 2r00000100 2r00100000
                 2r00001000 2r00010000
                 2r00010000 2r00001000
                 2r00100000 2r00000100
                 2r01000000 2r00000010
                 2r01111000 2r00011110
                 2r00001000 2r00010000
                 2r00001000 2r00010000
                 2r00001000 2r00010000
                 2r00001000 2r00010000
                 2r00001000 2r00010000
                 2r00001111 2r11110000
                 2r00000000 2r00000000
                ].
    ].
    direction == #down ifTrue:[
        bits := #[
                  2r00000000 2r00000000
                  2r00001111 2r11110000
                  2r00001000 2r00010000
                  2r00001000 2r00010000
                  2r00001000 2r00010000
                  2r00001000 2r00010000
                  2r00001000 2r00010000
                  2r01111000 2r00011110
                  2r01000000 2r00000010
                  2r00100000 2r00000100
                  2r00010000 2r00001000
                  2r00001000 2r00010000
                  2r00000100 2r00100000
                  2r00000010 2r01000000
                  2r00000001 2r10000000
                  2r00000000 2r00000000
                ]
    ].
    ^ Form 
        width:w height:h 
        fromArray:bits onDevice:aDevice
!

defaultST80ArrowButtonFormForDirection:direction onDevice:aDevice
    <resource: #programImage>

    |form|

    form := Form width:9 height:9 depth:1 onDevice:aDevice.
    form isNil ifTrue:[^ nil].
    form clear.
    form lineWidth:2.
    form capStyle:#round.
    form paint:(Color colorId:1).
    direction == #left ifTrue:[
        form displayLineFromX:6 y:0 toX:2 y:4.
        form displayLineFromX:2 y:4 toX:6 y:8.
    ] ifFalse:[
        direction == #down ifTrue:[
            form displayLineFromX:0 y:2 toX:4 y:6.
            form displayLineFromX:4 y:6 toX:8 y:2.
        ] ifFalse:[
            direction == #right ifTrue:[
                form displayLineFromX:2 y:0 toX:6 y:4.
                form displayLineFromX:6 y:4 toX:2 y:8.
            ] ifFalse:[
                form displayLineFromX:0 y:6 toX:4 y:2.
                form displayLineFromX:4 y:2 toX:8 y:6.
            ]
        ]
    ].
    form beImmediateForm.
    ^ form
!

defaultWIN32ArrowButtonFormForDirection:direction onDevice:aDevice
    <resource: #programImage>

    |w h bits|

    w := h := 11.
    direction == #left ifTrue:[
        bits := #[
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00000010 2r00000000
                 2r00000110 2r00000000
                 2r00001110 2r00000000
                 2r00011110 2r00000000
                 2r00001110 2r00000000
                 2r00000110 2r00000000
                 2r00000010 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                ]
    ].
    direction == #right ifTrue:[
        bits := #[
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00001000 2r00000000
                 2r00001100 2r00000000
                 2r00001110 2r00000000
                 2r00001111 2r00000000
                 2r00001110 2r00000000
                 2r00001100 2r00000000
                 2r00001000 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                ]
    ].
    direction == #up ifTrue:[
        bits := #[
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00000100 2r00000000
                 2r00001110 2r00000000
                 2r00011111 2r00000000
                 2r00111111 2r10000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                ]
    ].
    direction == #down ifTrue:[
        bits := #[
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00111111 2r10000000
                 2r00011111 2r00000000
                 2r00001110 2r00000000
                 2r00000100 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                 2r00000000 2r00000000
                ]
    ].
    ^ Form 
        width:w height:h 
        fromArray:bits onDevice:aDevice

    "
     self defaultWIN32ArrowButtonFormForDirection:#down onDevice:Screen current
    "
!

disabledArrowButtonFormForStyle:styleSymbol direction:direction on:aDevice
    <resource: #style (
                       #'arrowButton.disabledDownForm'
                       #'arrowButton.disabledUpForm'
                       #'arrowButton.disabledLeftForm'
                       #'arrowButton.disabledRightForm'   

                       #'arrowButton.disabledDownFormFile'
                       #'arrowButton.disabledUpFormFile'
                       #'arrowButton.disabledLeftFormFile'
                       #'arrowButton.disabledRightFormFile'   
                      )>

    |formVariableName styleSheetName styleSheetFileName|

    direction = #left ifTrue:[
        formVariableName := #DisabledLeftArrowForm.
        styleSheetName := #'arrowButton.disabledLeftForm'.
        styleSheetFileName := #'arrowButton.disabledLeftFormFile'.
    ].
    direction = #right ifTrue:[
        formVariableName := #DisabledRightArrowForm.
        styleSheetName := #'arrowButton.disabledRightForm'.
        styleSheetFileName := #'arrowButton.disabledRightFormFile'.
    ].
    direction = #up ifTrue:[
        formVariableName := #DisabledUpArrowForm.
        styleSheetName := #'arrowButton.disabledUpForm'.
        styleSheetFileName := #'arrowButton.disabledUpFormFile'.
    ].
    direction = #down ifTrue:[
        formVariableName := #DisabledDownArrowForm.
        styleSheetName := #'arrowButton.disabledDownForm'.
        styleSheetFileName := #'arrowButton.disabledDownFormFile'.
    ].
    formVariableName isNil ifTrue:[
        self error:'invalid direction' mayProceed:true.
        ^ nil
    ].

    ^ self
        arrowButtonFormForStyle:styleSymbol 
        nameKey:styleSheetName fileNameKey:styleSheetFileName variableName:formVariableName 
        direction:direction useDefault:false on:aDevice
!

enteredArrowButtonFormForStyle:styleSymbol direction:direction on:aDevice
    <resource: #style (
                       #'arrowButton.enteredDownForm'
                       #'arrowButton.enteredUpForm'
                       #'arrowButton.enteredLeftForm'
                       #'arrowButton.enteredRightForm'   

                       #'arrowButton.enteredDownFormFile'
                       #'arrowButton.enteredUpFormFile'
                       #'arrowButton.enteredLeftFormFile'
                       #'arrowButton.enteredRightFormFile'   
                      )>

    |formVariableName styleSheetName styleSheetFileName|

    direction = #left ifTrue:[
        formVariableName := #EnteredLeftArrowForm.
        styleSheetName := #'arrowButton.enteredLeftForm'.
        styleSheetFileName := #'arrowButton.enteredLeftFormFile'.
    ].
    direction = #right ifTrue:[
        formVariableName := #EnteredRightArrowForm.
        styleSheetName := #'arrowButton.enteredRightForm'.
        styleSheetFileName := #'arrowButton.enteredRightFormFile'.
    ].
    direction = #up ifTrue:[
        formVariableName := #EnteredUpArrowForm.
        styleSheetName := #'arrowButton.enteredUpForm'.
        styleSheetFileName := #'arrowButton.enteredUpFormFile'.
    ].
    direction = #down ifTrue:[
        formVariableName := #EnteredDownArrowForm.
        styleSheetName := #'arrowButton.enteredDownForm'.
        styleSheetFileName := #'arrowButton.enteredDownFormFile'.
    ].
    formVariableName isNil ifTrue:[
        self error:'invalid direction' mayProceed:true.
        ^ nil
    ].

    ^ self
        arrowButtonFormForStyle:styleSymbol 
        nameKey:styleSheetName fileNameKey:styleSheetFileName variableName:formVariableName 
        direction:direction useDefault:false on:aDevice
! !

!ArrowButton methodsFor:'accessing'!

direction
    "return the buttons direction - a symbol"

    ^ direction
!

direction:aDirectionSymbol
    "create and return a new arrow button in aView"

    |logo activeLogo enteredLogo disabledLogo graphicsDevice|

    graphicsDevice := device.

    logo := self class 
                arrowButtonFormForStyle:arrowStyle 
                direction:aDirectionSymbol 
                on:graphicsDevice.

    activeLogo := self class
                activeArrowButtonFormForStyle:arrowStyle 
                direction:aDirectionSymbol 
                on:graphicsDevice.

    disabledLogo := self class
                disabledArrowButtonFormForStyle:arrowStyle 
                direction:aDirectionSymbol 
                on:graphicsDevice.

    enteredLogo := self class
                enteredArrowButtonFormForStyle:arrowStyle 
                direction:aDirectionSymbol 
                on:graphicsDevice.

    direction := aDirectionSymbol.
    enteredLogo notNil ifTrue:[
        self enteredLogo:enteredLogo.
        self activeLogo:activeLogo.
    ].
    disabledLogo notNil ifTrue:[
        self disabledLogo:disabledLogo.
    ].
    activeLogo notNil ifTrue:[
        self activeLogo:activeLogo.
        self passiveLogo:logo.
    ].
    self label:logo.


    "Modified: 24.2.1997 / 21:19:59 / cg"
! !

!ArrowButton methodsFor:'accessing-look'!

allViewBackground:something if:condition
    (condition value:self) ifTrue:[
        super viewBackground:something.
        bgColor := activeBgColor := enteredBgColor := something
    ]
!

viewBackground:something
    super viewBackground:something.
    bgColor := activeBgColor := enteredBgColor := something
! !

!ArrowButton methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "no, do not catch the keyboard focus on button click"

    ^ false




! !

!ArrowButton methodsFor:'initialization'!

initStyle
    "setup viewStyle specifics"

    super initStyle.

    DefaultBackgroundColor notNil ifTrue:[
        bgColor := DefaultBackgroundColor onDevice:device
    ].
    DefaultForegroundColor notNil ifTrue:[
        fgColor := DefaultForegroundColor onDevice:device
    ].
    DefaultActiveForegroundColor notNil ifTrue:[
        activeFgColor := DefaultActiveForegroundColor onDevice:device
    ].
    DefaultActiveBackgroundColor notNil ifTrue:[
        activeBgColor := DefaultActiveBackgroundColor onDevice:device
    ].
    DefaultEnteredForegroundColor notNil ifTrue:[
        enteredFgColor := DefaultEnteredForegroundColor onDevice:device
    ].
    DefaultEnteredBackgroundColor notNil ifTrue:[
        enteredBgColor := DefaultEnteredBackgroundColor onDevice:device
    ].
    DefaultDisabledForegroundColor notNil ifTrue:[
        disabledFgColor := DefaultDisabledForegroundColor onDevice:device
    ].

    arrowStyle := DefaultArrowStyle.

    DefaultArrowButtonActiveLevel notNil ifTrue:[onLevel := DefaultArrowButtonActiveLevel].
    DefaultArrowButtonPassiveLevel notNil ifTrue:[offLevel := DefaultArrowButtonPassiveLevel].
    offLevel ~~ level ifTrue:[self level:offLevel].

    "Modified: 22.1.1997 / 11:57:00 / cg"
!

initialize

    super initialize.
    hSpace := vSpace := 0.
    controller beTriggerOnDown.

    "Modified: 6.3.1997 / 20:58:49 / cg"
! !

!ArrowButton methodsFor:'redrawing'!

drawWith:fg and:bg
    "this is a q&d hack for motif ..."

    |topLeft botRight isString orgX orgY r colors|

    arrowStyle ~~ #motif ifTrue:[
        ^ super drawWith:fg and:bg.
    ].

    "
     the code below does a lot of bitmap drawing, but allows
     to 3D-ify any logo (it draws it displaced by some pixels
     to the upper left in one-color and displaced to the 
     lower right in the other color). It should be rewritten to
     cache the result for later drawing operations.
    "
    logo notNil ifTrue:[
        gc paint:bg.
        gc fillRectangleX:0 y:0 width:width height:height.

        shadowColor := shadowColor onDevice:device.
        lightColor := lightColor onDevice:device.

        controller pressed ifTrue:[
            topLeft := shadowColor.
            botRight := lightColor
        ] ifFalse:[
            topLeft := lightColor.
            botRight := shadowColor
        ].

        isString := logo isString.

        isString ifFalse:[
            logo depth ~~ 1 ifTrue:[
                "/ allow for deep logos (for motif)
                "/ one catch: if the view background is a complex pixmap
                "/ we cannot use this as colorMap entry.
                "/ therefore, compute the average colors and take these
                "/ (this looks ok for buttons ...)

                r := (0@0 corner:10@10).

                colors := (Array with:(bg averageColorIn:r)
                                       with:(topLeft averageColorIn:r)
                                       with:(botRight averageColorIn:r)
                                       with:(fg averageColorIn:r)).
                colors ~= logo colorMap ifTrue:[
                    logo release.
                    logo colorMap:colors.
                ].
                logo photometric:#palette.
                logo := logo onDevice:device.

                self displayForm:logo x:labelOriginX  y:labelOriginY.
                ^ self
            ].
            logo := logo onDevice:device.
            orgX := labelOriginX.
            orgY := labelOriginY.
        ] ifTrue:[
            orgY := (height - gc font height) // 2 + gc font ascent.
            orgX := (width - labelOriginX) // 4 - 1.
        ].

        gc paint:topLeft.
        #(-1 0 -1) with:#(-1 -1 0) do:[:dX :dY |
            |x y|

            x := orgX + dX.
            y := orgY + dY.

            isString ifTrue:[
                gc displayString:logo x:x y:y.
            ] ifFalse:[
                gc displayForm:logo x:x y:y.
            ]    
        ].

        gc paint:botRight.
        #(1 1 0) with:#(0 1 1) do:[:dX :dY |
            |x y|

            x := orgX + dX.                   
            y := orgY + dY.

            isString ifTrue:[
                gc displayString:logo x:x y:y.
            ] ifFalse:[
                gc displayForm:logo x:x y:y.
            ]    
        ].

        "
         finally, the form itself
        "
        gc paint:fg.
        isString ifTrue:[
            gc displayString:logo x:orgX y:orgY.
        ] ifFalse:[
            gc displayForm:logo x:orgX y:orgY.
        ]    
    ]

    "Modified: 31.8.1995 / 03:03:12 / claus"
    "Modified: 19.3.1997 / 17:11:22 / cg"
! !

!ArrowButton class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

