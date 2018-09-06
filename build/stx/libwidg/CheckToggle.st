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
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

Toggle subclass:#CheckToggle
	instanceVariableNames:'isFlat'
	classVariableNames:'DefaultCheckForm DefaultCheckColor DefaultActiveFGColor
		DefaultActiveBGColor DefaultFGColor DefaultBGColor
		DefaultActiveLevel DefaultPassiveLevel DefaultBorderWidth
		LabelOverMargin DefaultActiveImage DefaultPassiveImage
		DefaultDisabledImage DefaultDisabledActiveImage
		DefaultDisabledPassiveImage DefaultEnteredActiveImage
		DefaultEnteredPassiveImage'
	poolDictionaries:''
	category:'Views-Interactors'
!

!CheckToggle class methodsFor:'documentation'!

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
    CheckButtons are like Toggles in toggling their state when pressed.
    However, they show an ok-marker if on; nothing if off.
    CheckButtons are mostly used as part of a checkBox (since normally,
    you want to have some label along the check) and often grouped for
    many-in-many or one-in-many setups.

    [StyleSheet values:]

        checkToggleCheckColor   <Color>         color to draw check-image with.
                                                defaults to value of #buttonActiveForegroundColor.

        checkToggleActiveBackgroundColor        background color to draw active checki-image with
        checkToggleForegroundColor              foreground color to use if off
        checkToggleBackgroundColor              background color to use if off

        checkToggleBitmapFile   <String>        name of bitmap file for check-image

        checkToggleStyle        <Symbol>        default checkForm style.
                                                used if above is nil or file not readable
                                                can be #cross or #check; defaults to #check 

        checkToggleAvtiveLevel  <Number>        active level - defaults to value of #buttonPassiveLevel
        checkTogglePassiveLevel <Number>        active level - defaults to value of #buttonPassiveLevel
        checkToggleBorderWidth  <Number>        borderWidth - defaults buttons default

        checkToggleActiveImage  <Image>         image to draw when active; if non-nil,
                                                this overwrites activeColor & bitmapFile above.

        checkTogglePassiveImage <Image>         image to draw when passive; if non-nil,
                                                this overwrites passiveColor & bitmapFile above.

    (if not set in the styleSheet, Toggle values are taken)

    See examples.

    [author:]
        Claus Gittinger

    [see also:]
        CheckBox RadioButton RadioButtonGroup Toggle Button
        Dialog
        ValueHolder TriggerValue
        Block
"
!

examples 
"
    checkToggle alone:
                                                                        [exBegin]
        |top check|

        top := StandardSystemView new.
        top extent:100@100.

        check := CheckToggle in:top.
        check origin:10@10.

        top open
                                                                        [exEnd]


    give it an action:
                                                                        [exBegin]
        |top check|

        top := StandardSystemView new.
        top extent:100@100.

        check := CheckToggle in:top.
        check origin:10@10.
        check action:[:value | Transcript showCR:'changed to: ' , value printString].

        top open
                                                                        [exEnd]


    give it a model:
                                                                        [exBegin]
        |top check model|

        model := false asValue.

        top := StandardSystemView new.
        top extent:100@100.

        check := CheckToggle in:top.
        check origin:10@10.
        check model:model.

        top openModal.

        Transcript showCR:'value after closing box: ' , model value printString
                                                                        [exEnd]


    enableChannel & model:
                                                                        [exBegin]
        |top check1 check2 enableHolder model|

        enableHolder := false asValue.
        model := false asValue.

        top := StandardSystemView new.
        top extent:200@100.

        check1 := CheckToggle in:top.
        check1 origin:10@10.
        check1 model:enableHolder.
        (Label label:'Enable' in:top) origin:30@10.

        check2 := CheckToggle in:top.
        check2 origin:10@30.
        check2 model:model.
        check2 enableChannel:enableHolder.
        (Label label:'Model' in:top) origin:30@30.

        top open.
                                                                        [exEnd]


    multiple checks on a single model (with different change selectors):
    (using a checkBox here, for the demonstration ...)
    (this is a typical many-in-many setup)
                                                                        [exBegin]
        |top model panel ext1 ext2
         readFlag writeFlag executeFlag|

        readFlag := writeFlag := true.
        executeFlag := false.

        model := Plug new.
        model respondTo:#read with:[readFlag].
        model respondTo:#write with:[writeFlag].
        model respondTo:#execute with:[executeFlag].
        model respondTo:#read: with:[:val | readFlag := val].
        model respondTo:#write: with:[:val | writeFlag := val].
        model respondTo:#execute: with:[:val | executeFlag := val].

        top := StandardSystemView new.
        top extent:200@200.
        top label:'File permissions:'.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
        panel horizontalLayout:#leftSpace.

        #(read write execute) do:[:sym |
            |check|

            check := CheckBox in:panel.
            check label:sym.
            check model:model; aspect:sym; changeMessage:(sym , ':') asSymbol.
        ].

        top openModal.

        Transcript showCR:'settings after closing box:'.
        Transcript showCR:'  read -> ' , readFlag printString.
        Transcript showCR:'  write -> ' , writeFlag printString.
        Transcript showCR:'  execute -> ' , executeFlag printString.
                                                                        [exEnd]


    checkToggles in a group - now, they have RadioButton behavior.
    (this is a typical one-in-many setup)
                                                                        [exBegin]
        |top panel check1 check2 check3 grp|

        top := StandardSystemView new.
        top extent:200@300.

        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        check1 := CheckToggle in:panel.
        check2 := CheckToggle in:panel.
        check3 := CheckToggle in:panel.

        grp := RadioButtonGroup new.
        grp add:check1.
        grp add:check2.
        grp add:check3.

        top open
                                                                        [exEnd]


     Channel operation 
     -----------------

       enabling other toggles via a toggle
                                                                        [exBegin]
        |top panel t enableChannel|

        top := StandardSystemView new.
        top extent:(400 @ 200).

        panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.

        enableChannel := false asValue.

        1 to:10 do:[:i |
            t := CheckToggle in:panel.
            t enableChannel:enableChannel.
        ].

        t := Toggle in:panel.
        t activeLogo:'enabled'; passiveLogo:'disabled'.
        t pressChannel:enableChannel.

        top open
                                                                        [exEnd]
"
! !

!CheckToggle class methodsFor:'defaults'!

checkBitsForStyle:aStyleSymbol
    "helper & public access to useful checkToggle images"

    aStyleSymbol == #cross ifTrue:[
        ^ #[2r10000000 2r00000001
            2r01000000 2r00000010
            2r00100000 2r00000100
            2r00010000 2r00001000
            2r00001000 2r00010000
            2r00000100 2r00100000
            2r00000010 2r01000000
            2r00000001 2r10000000
            2r00000001 2r10000000
            2r00000010 2r01000000
            2r00000100 2r00100000
            2r00001000 2r00010000
            2r00010000 2r00001000
            2r00100000 2r00000100
            2r01000000 2r00000010
            2r10000000 2r00000001]
    ].
    aStyleSymbol == #borderedCross ifTrue:[
        ^ #[2r11111111 2r11111111
            2r11000000 2r00000011
            2r10100000 2r00000101
            2r10010000 2r00001001
            2r10001000 2r00010001
            2r10000100 2r00100001
            2r10000010 2r01000001
            2r10000001 2r10000001
            2r10000001 2r10000001
            2r10000010 2r01000001
            2r10000100 2r00100001
            2r10001000 2r00010001
            2r10010000 2r00001001
            2r10100000 2r00000101
            2r11000000 2r00000011
            2r11111111 2r11111111]
    ].
    aStyleSymbol == #fatcross ifTrue:[
        ^ #[2r11000000 2r00000011
            2r11100000 2r00000111
            2r01110000 2r00001110
            2r00111000 2r00011100
            2r00011100 2r00111000
            2r00001110 2r01110000
            2r00000111 2r11100000
            2r00000011 2r11000000
            2r00000011 2r11000000
            2r00000111 2r11100000
            2r00001110 2r01110000
            2r00011100 2r00111000
            2r00111000 2r00011100
            2r01110000 2r00001110
            2r11100000 2r00000111
            2r11000000 2r00000011]
    ].
    aStyleSymbol == #borderedFatcross ifTrue:[
        ^ #[2r11111111 2r11111111
            2r11100000 2r00000111
            2r11110000 2r00001111
            2r10111000 2r00011101
            2r10011100 2r00111001
            2r10001110 2r01110001
            2r10000111 2r11100001
            2r10000011 2r11000001
            2r10000011 2r11000001
            2r10000111 2r11100001
            2r10001110 2r01110001
            2r10011100 2r00111001
            2r10111000 2r00011101
            2r11110000 2r00001111
            2r11100000 2r00000111
            2r11111111 2r11111111]
    ].
    aStyleSymbol == #border ifTrue:[
        ^ #[2r11111111 2r11111111
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r10000000 2r00000001
            2r11111111 2r11111111]
    ].
    ^ #[2r00000000 2r00000000
        2r00000000 2r00000010
        2r00000000 2r00000010
        2r00000000 2r00000100
        2r00000000 2r00000100
        2r00000000 2r00001000
        2r00000000 2r00001000
        2r00000000 2r00010000
        2r01000000 2r00110000
        2r00100000 2r01100000
        2r00011000 2r01100000
        2r00001110 2r11000000
        2r00000111 2r11000000
        2r00000011 2r10000000
        2r00000001 2r10000000
        2r00000000 2r00000000]

    "
     self checkBitsForStyle:#cross
     self checkBitsForStyle:#fatcross
     self checkBitsForStyle:#borderedCross
     self checkBitsForStyle:#borderedFatcross
    "

    "Modified: 7.3.1997 / 21:15:13 / cg"
!

checkFormOn:aDevice
    "return the form used when checkToggle is turned on.
     Provided as public entry, to allow other views
     to share the same check-image."

    ^ DefaultCheckForm onDevice:aDevice.

    "
     CheckToggle checkFormOn:Display
    "
!

checkImageForStyle:aStyleSymbol
    "helper & public access to useful checkToggle images"

    |bits|

    bits := self checkBitsForStyle:aStyleSymbol.
    ^ Form width:16 height:16 fromArray:bits onDevice:Display                                           

    "
     self checkImageForStyle:#cross
     self checkImageForStyle:#fatcross
     self checkImageForStyle:#borderedCross
     self checkImageForStyle:#borderedFatcross
    "
!

smallCheckBitsForStyle:aStyleSymbol
    "helper & public access to useful checkToggle images"

    aStyleSymbol == #cross ifTrue:[
        ^ #[
            2r10000000 2r00010000
            2r01000000 2r00100000
            2r00100000 2r01000000
            2r00010000 2r10000000
            2r00001001 2r00000000
            2r00000110 2r00000000
            2r00000110 2r00000000
            2r00001001 2r00000000
            2r00010000 2r10000000
            2r00100000 2r01000000
            2r01000000 2r00100000
            2r10000000 2r00010000
           ]
    ].
    aStyleSymbol == #fatcross ifTrue:[
        ^ #[
            2r11000000 2r00110000
            2r01100000 2r01100000
            2r00110000 2r11000000
            2r00011001 2r10000000
            2r00001111 2r00000000
            2r00000110 2r00000000
            2r00000110 2r00000000
            2r00001111 2r00000000
            2r00011001 2r10000000
            2r00110000 2r11000000
            2r01100000 2r01100000
            2r11000000 2r00110000
           ]
    ].
    aStyleSymbol == #borderedCross ifTrue:[
        ^ #[
            2r11111111 2r11110000
            2r11000000 2r00110000
            2r10100000 2r01010000
            2r10010000 2r10010000
            2r10001001 2r00010000
            2r10000110 2r00010000
            2r10000110 2r00010000
            2r10001001 2r00010000
            2r10010000 2r10010000
            2r10100000 2r01010000
            2r11000000 2r00110000
            2r11111111 2r11110000
           ]
    ].
    aStyleSymbol == #borderedFatcross ifTrue:[
        ^ #[
            2r11111111 2r11110000
            2r11100000 2r01110000
            2r10110000 2r11010000
            2r10011001 2r10010000
            2r10001111 2r00010000
            2r10000110 2r00010000
            2r10000110 2r00010000
            2r10001111 2r00010000
            2r10011001 2r10010000
            2r10110000 2r11010000
            2r11100000 2r01110000
            2r11111111 2r11110000
           ]
    ].
    aStyleSymbol == #border ifTrue:[
        ^ #[
            2r11111111 2r11110000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r10000000 2r00010000
            2r11111111 2r11110000
           ]
    ].
    ^ #[
        2r00000000 2r00000000
        2r00000000 2r00001000
        2r00000000 2r00001000
        2r00000000 2r00010000
        2r01000000 2r00110000
        2r00100000 2r01100000
        2r00011000 2r01100000
        2r00001110 2r11000000
        2r00000111 2r11000000
        2r00000011 2r10000000
        2r00000001 2r10000000
        2r00000000 2r00000000
       ]

    "
     self smallCheckBitsForStyle:#cross
     self smallCheckBitsForStyle:#fatcross
     self smallCheckBitsForStyle:#borderedCross
     self smallCheckBitsForStyle:#borderedFatcross
    "

    "Modified: 7.3.1997 / 21:15:13 / cg"
!

smallCheckImageForStyle:aStyleSymbol
    "helper & public access to useful checkToggle images"

    |bits|

    bits := self smallCheckBitsForStyle:aStyleSymbol.
    ^ Form width:12 height:12 fromArray:bits onDevice:Display                                           

    "
     self smallCheckImageForStyle:#cross
     self smallCheckImageForStyle:#fatcross
     self smallCheckImageForStyle:#borderedCross
     self smallCheckImageForStyle:#borderedFatcross
    "
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'checkToggle.checkColor'
                       #'checkToggle.backgroundColor' #'checkToggle.foregroundColor'
                       #'checkToggle.activeBackgroundColor' #'checkToggle.activeForegroundColor'
                       #'checkToggle.activeLevel' #'checkToggle.passiveLevel'
                       #'checkToggle.activeImage' #'checkToggle.passiveImage'
                       #'checkToggle.disabledActiveImage' #'checkToggle.disabledPassiveImage'
                       #'checkToggle.enteredActiveImage' #'checkToggle.enteredPassiveImage'
                       #'checkToggle.borderWidth' 
                       #'checkToggle.bitmapFile'
                       #'checkToggle.labelOverMargin' 
                       #'checkToggle.style')>

    |checkFileName checkStyle|

    DefaultCheckColor    := StyleSheet colorAt:#'checkToggle.checkColor'.
    DefaultFGColor       := StyleSheet colorAt:#'checkToggle.foregroundColor'.
    DefaultBGColor       := StyleSheet colorAt:#'checkToggle.backgroundColor'.
    DefaultActiveFGColor := StyleSheet colorAt:#'checkToggle.activeForegroundColor'.
    DefaultActiveBGColor := StyleSheet colorAt:#'checkToggle.activeBackgroundColor'.
    DefaultActiveLevel   := StyleSheet at:#'checkToggle.activeLevel'.
    DefaultPassiveLevel  := StyleSheet at:#'checkToggle.passiveLevel'.
    DefaultBorderWidth   := StyleSheet at:#'checkToggle.borderWidth'.
    LabelOverMargin      := StyleSheet at:#'checkToggle.labelOverMargin' default:false.

    DefaultCheckForm := nil.
    checkFileName := StyleSheet at:#'checkToggle.bitmapFile' default:'CheckOn.xbm'.
    checkFileName notNil ifTrue:[
        DefaultCheckForm := Smalltalk imageFromFileNamed:checkFileName forClass:self.
    ].
    DefaultCheckForm isNil ifTrue:[
        checkStyle := StyleSheet at:#'checkToggle.style' default:#check.
        DefaultCheckForm := self checkImageForStyle:checkStyle
    ].
    StyleSheet name == #os2 ifTrue: [
        DefaultCheckForm := DefaultCheckForm subImageIn: (0@0 extent: 15@15)
    ].
    DefaultCheckForm := DefaultCheckForm onDevice:Display.

    DefaultActiveImage := StyleSheet at:#'checkToggle.activeImage'.
    DefaultPassiveImage := StyleSheet at:#'checkToggle.passiveImage'.
    DefaultDisabledActiveImage := StyleSheet at:#'checkToggle.disabledActiveImage'.
    DefaultDisabledPassiveImage := StyleSheet at:#'checkToggle.disabledPassiveImage'.
    DefaultEnteredActiveImage := StyleSheet at:#'checkToggle.enteredActiveImage'.
    DefaultEnteredPassiveImage := StyleSheet at:#'checkToggle.enteredPassiveImage'.

    "
     self updateStyleCache
    "

    "Modified: / 6.9.1998 / 21:24:48 / cg"
! !

!CheckToggle methodsFor:'accessing'!

isFlat
    isFlat isNil ifTrue:[
        isFlat := false
    ].
    ^ isFlat
!

isFlat:something
    isFlat := something.
! !

!CheckToggle methodsFor:'accessing-look'!

allViewBackground:something if:condition
    (condition value:self) ifTrue:[
        (activeLogo notNil 
        and:[activeLogo depth > 1
        and:[styleSheet name ~~ #iris
        and:[styleSheet name ~~ #winXP]]]) ifTrue:[
            self viewBackground:something.
            self backgroundColor:something.
            enteredBgColor := activeBgColor := something.
        ]
    ]
! !

!CheckToggle methodsFor:'initialization'!

initStyle
    "setup viewStyle specifics"

    <resource: #style (#'checkToggle.disabledForegroundColor'
                       #'checkToggle.enabledBackgroundColor' 
                       )>

    |enabledBgColor graphicsDevice|

    super initStyle.
    graphicsDevice := device.

    onLevel := offLevel.
    DefaultActiveLevel notNil ifTrue:[onLevel := DefaultActiveLevel].
    DefaultPassiveLevel notNil ifTrue:[offLevel := DefaultPassiveLevel].

    activeLogo := DefaultCheckForm onDevice:graphicsDevice.
    passiveLogo := nil.

    DefaultActiveImage notNil ifTrue:[
        activeLogo := DefaultActiveImage onDevice:graphicsDevice.
    ].
    DefaultPassiveImage notNil ifTrue:[
        passiveLogo := DefaultPassiveImage onDevice:graphicsDevice.
    ].

    disabledFgColor := styleSheet at:#'checkToggle.disabledForegroundColor' default:disabledFgColor.

    DefaultActiveFGColor notNil ifTrue:[
        self activeForegroundColor:DefaultActiveFGColor
    ].
    DefaultCheckColor notNil ifTrue:[
        self activeForegroundColor:DefaultCheckColor
    ].
    DefaultActiveBGColor notNil ifTrue:[
        self activeBackgroundColor:DefaultActiveBGColor
    ].
    DefaultFGColor notNil ifTrue:[
        self foregroundColor:DefaultFGColor
    ].
    DefaultBGColor notNil ifTrue:[
        self backgroundColor:DefaultBGColor.
        self viewBackground:DefaultBGColor.
    ].

    showLamp := false.

    DefaultBorderWidth notNil ifTrue:[self borderWidth:DefaultBorderWidth].

    offLevel ~~ level ifTrue:[self level:offLevel].

"/    enabledBgColor := styleSheet at:#'checkToggle.enabledBackgroundColor' default:nil.
"/    enabledBgColor notNil ifTrue:[
"/        bgColor := enabledBgColor.
"/    ].

    "Modified: / 19.5.1998 / 15:50:29 / cg"
!

initialize
    super initialize.
    passiveLogo := DefaultPassiveImage.
    self label:activeLogo. "/ to let me compute some defaultExtent

    "Modified: / 19.5.1998 / 15:51:49 / cg"
! !

!CheckToggle methodsFor:'queries'!

label: something

    something isString ifFalse: [super label: something]
!

preferredExtent
    |pref|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].
    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].
    "/ If I have a frozen extent value...
    fixSize ifTrue:[
        ^ self extent
    ].

    pref := super preferredExtent.
    LabelOverMargin ifTrue:[
        pref := pref - (margin*2)
    ].

    ^ pref

    "Modified: 7.3.1997 / 17:52:53 / cg"
! !

!CheckToggle methodsFor:'redrawing'!

drawEdges

    self isFlat ifTrue:[
        gc paint:self blackColor.
        gc displayRectangleX:0 y:0 width:width height:height.
        ^ self.
    ].
    LabelOverMargin ifTrue:[
        (logo isNil or:[logo isImageOrForm not]) ifTrue:[
            gc deviceClippingBounds:nil.
            self clearRectangleX:0 y:0 width:width height:height.
        ].
    ].
    super drawEdges.
!

drawWith:fg and:bg
    |bgColorUsed|

    bgColorUsed := bg.
    logo := self logoToDisplay.

    self enabled ifFalse:[
        bgColorUsed := View defaultViewBackgroundColor. "/ viewBackground.
    ] ifTrue:[
        controller pressed ifTrue:[
            self isFlat ifTrue:[
                bgColorUsed := bgColor.
            ] ifFalse:[
                bgColorUsed := activeBgColor
            ].
        ] ifFalse:[
            bgColorUsed := bgColor.
        ].

        (controller entered 
        and:[enteredBgColor notNil]) ifTrue:[
            bgColorUsed := enteredBgColor
        ] ifFalse:[
    "/        bgColorUsed := bgColor 
        ].
    ].

    super drawWith:fg and:bgColorUsed 

    "Modified: 22.9.1995 / 15:45:02 / claus"
    "Modified: 1.4.1997 / 13:35:48 / cg"
!

edgeDrawn:which
    "redraw my logo if it overlaps the edge"

    LabelOverMargin ifTrue:[
        (logo notNil and:[logo isImageOrForm]) ifTrue:[
            self paint:fgColor on:bgColor.
            self clippingBounds:nil.
            self displayForm:logo x:labelOriginX y:labelOriginY.
            self deviceClippingBounds:innerClipRect
       ]
    ].

    "Modified: / 25.5.1999 / 16:10:10 / cg"
!

logoToDisplay                        
    |graphicsDevice|

    graphicsDevice := device.
    controller enabled ifFalse:[       
        (controller pressed) ifTrue:[
            DefaultDisabledActiveImage notNil ifTrue:[
                activeLogo := enteredLogo := DefaultDisabledActiveImage onDevice:graphicsDevice.
                ^ activeLogo.
            ].
        ] ifFalse:[
            DefaultDisabledPassiveImage notNil ifTrue:[
                passiveLogo := enteredLogo := DefaultDisabledPassiveImage onDevice:graphicsDevice.
                ^ passiveLogo.
            ].
        ].
    ] ifTrue:[
        controller entered ifTrue:[
            (controller pressed) ifTrue:[
                DefaultEnteredActiveImage notNil ifTrue:[
                    activeLogo := enteredLogo := DefaultEnteredActiveImage onDevice:graphicsDevice.
                    ^ activeLogo.
                ].
            ] ifFalse:[
                DefaultEnteredPassiveImage notNil ifTrue:[
                    passiveLogo := enteredLogo := DefaultEnteredPassiveImage onDevice:graphicsDevice.
                    ^ passiveLogo.
                ].
            ].
        ] ifFalse:[
            (controller pressed) ifTrue:[
                DefaultActiveImage notNil ifTrue:[
                    activeLogo := enteredLogo := DefaultActiveImage onDevice:graphicsDevice.
                    ^ activeLogo.
                ].
            ] ifFalse:[
                DefaultPassiveImage notNil ifTrue:[
                    passiveLogo := enteredLogo := DefaultPassiveImage onDevice:graphicsDevice.
                    ^ passiveLogo.
                ].
            ].
        ].
    ].

    controller pressed ifTrue:[
        ^ activeLogo.
    ].
    ^ passiveLogo.
! !

!CheckToggle class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

