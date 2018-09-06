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

Toggle subclass:#RadioButton
	instanceVariableNames:'buttonStyle buttonOnLevel buttonOffLevel offImage onImage
		buttonOffImage buttonOnImage disabledOnImage disabledOffImage
		enteredOnImage enteredOffImage'
	classVariableNames:'DefaultButtonStyle DefaultBorderWidth DefaultActiveLevel
		DefaultPassiveLevel DefaultForegroundColor DefaultBackgroundColor
		DefaultActiveForegroundColor DefaultActiveBackgroundColor
		MotifCheckBotForm MotifCheckTopForm MotifCheckInnerForm
		Round3DCheckBotForm Round3DCheckTopForm Round3DCheckInnerForm
		RoundHalfLightForm RoundOffForm RoundOnForm PassiveForm
		ActiveForm EnteredPassiveForm EnteredActiveForm
		DisabledActiveForm DisabledPassiveForm'
	poolDictionaries:''
	category:'Views-Interactors'
!

!RadioButton class methodsFor:'documentation'!

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
    like a Toggle, but do not turn off when pressed again, instead only
    turn off when another RadioButton is pressed (see RadioButtonGroup).

    written fall 91 by claus

    [author:]
        Claus Gittinger
"
!

examples 
"
  See more examples in RadioButtonGroup class>>examples

  example1: one on behavior (using RadioButtons)
                                                                        [exBegin]
    |top panel b group|

    top := StandardSystemView new.
    top extent:200@200.

    panel := HorizontalPanelView
                origin:0.0@0.0
                corner:1.0@1.0
                    in:top.

    group := RadioButtonGroup new.

    b := RadioButton label:'am' in:panel.
    group add:b.

    b := RadioButton label:'fm' in:panel.
    group add:b.

    b := RadioButton label:'off' in:panel.
    group add:b.
    b enabled:false.

    group value:1.
    top open
                                                                        [exEnd]


  example2: zero or one on behavior (using Toggles)
                                                                        [exBegin]
    |top panel b group|

    top := StandardSystemView new.
    top extent:200@200.

    panel := HorizontalPanelView
                origin:0.0@0.0
                corner:1.0@1.0
                    in:top.

    group := RadioButtonGroup new.

    b := Toggle label:'am' in:panel.
    group add:b.

    b := Toggle label:'fm' in:panel.
    group add:b.

    b := Toggle label:'off' in:panel.
    group add:b.

    group value:1.
    top open
                                                                        [exEnd]


  a selectionInListView and a group displaying the same value:
                                                                        [exBegin]
    |top top2 panel b sv group selectionInList|

    top := StandardSystemView extent:200@200.

    panel := HorizontalPanelView
                origin:0.0@0.0 corner:1.0@1.0 in:top.

    group := RadioButtonGroup new.
    selectionInList := SelectionInList new.
    selectionInList list:#('am' 'fm' 'off').
    selectionInList selectionIndexHolder:group.

    b := Toggle label:'am' in:panel.
    group add:b.

    b := Toggle label:'fm' in:panel.
    group add:b.

    b := Toggle label:'off' in:panel.
    group add:b.

    group value:1.
    top open.

    top2 := StandardSystemView extent:200@200.
    sv := SelectionInListView in:top2.
    sv model:selectionInList.
    sv origin:0.0@0.0 corner:1.0@1.0.
    top2 open.

                                                                        [exEnd]
"
! !

!RadioButton class methodsFor:'defaults'!

activeForm
    ActiveForm isNil ifTrue:[
        self updateStyleCache.
    ].
    ^ ActiveForm

    "
     ActiveForm := nil. 
     self updateStyleCache
    "
!

disabledActiveForm
    DisabledActiveForm isNil ifTrue:[
        self updateStyleCache.
    ].
    ^ DisabledActiveForm

    "
     DisabledActiveForm := nil. 
     self updateStyleCache
    "
!

disabledPassiveForm
    DisabledPassiveForm isNil ifTrue:[
        self updateStyleCache.
    ].
    ^ DisabledPassiveForm

    "
     DisabledPassiveForm := nil. 
     self updateStyleCache
    "
!

enteredActiveForm
    EnteredActiveForm isNil ifTrue:[
        self updateStyleCache.
    ].
    ^ EnteredActiveForm

    "
     EnteredActiveForm := nil. 
     self updateStyleCache
    "
!

enteredPassiveForm
    EnteredPassiveForm isNil ifTrue:[
        self updateStyleCache.
    ].
    ^ EnteredPassiveForm

    "
     EnteredPassiveForm := nil. 
     self updateStyleCache
    "
!

motifCheckBotForm
    MotifCheckBotForm isNil ifTrue:[
        MotifCheckBotForm := Form 
                                width:15 
                                height:15 
                                fromArray:#[2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00001110
                                            2r01110000 2r00011100
                                            2r00111000 2r00111000
                                            2r00011100 2r01110000
                                            2r00001110 2r11100000
                                            2r00000111 2r11000000
                                            2r00000011 2r10000000
                                            2r00000001 2r00000000
                                           ].
        MotifCheckBotForm := MotifCheckBotForm onDevice:Display.
    ].
    ^ MotifCheckBotForm

    "Created: / 3.11.1997 / 12:06:45 / cg"
    "Modified: / 30.7.1998 / 21:27:53 / cg"
!

motifCheckInnerForm
    MotifCheckInnerForm isNil ifTrue:[
        MotifCheckInnerForm := Form 
                                width:15 
                                height:15 
                                fromArray:#[2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000001 2r00000000
                                            2r00000011 2r10000000
                                            2r00000111 2r11000000
                                            2r00001111 2r11100000
                                            2r00011111 2r11110000
                                            2r00001111 2r11100000
                                            2r00000111 2r11000000
                                            2r00000011 2r10000000
                                            2r00000001 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                           ].
        MotifCheckInnerForm := MotifCheckInnerForm onDevice:Display
    ].
    ^ MotifCheckInnerForm

    "Created: / 3.11.1997 / 12:06:45 / cg"
    "Modified: / 30.7.1998 / 21:28:45 / cg"
!

motifCheckTopForm
    MotifCheckTopForm isNil ifTrue:[
        MotifCheckTopForm := Form 
                                width:15 
                                height:15 
                                fromArray:#[2r00000001 2r00000000
                                            2r00000011 2r10000000
                                            2r00000111 2r11000000
                                            2r00001110 2r11100000
                                            2r00011100 2r01110000
                                            2r00111000 2r00111000
                                            2r01110000 2r00011100
                                            2r11100000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                           ].
        MotifCheckTopForm := MotifCheckTopForm onDevice:Display
    ].
    ^ MotifCheckTopForm

    "Created: / 3.11.1997 / 12:06:45 / cg"
    "Modified: / 30.7.1998 / 21:28:45 / cg"
!

passiveForm
    PassiveForm isNil ifTrue:[
        self updateStyleCache.
    ].
    ^ PassiveForm

    "
     PassiveForm := nil. 
     self updateStyleCache
    "
!

round3DCheckBotForm
    Round3DCheckBotForm isNil ifTrue:[
        Round3DCheckBotForm := Form 
                                width:15 
                                height:15 
                                fromArray:#[2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000010
                                            2r00000000 2r00000010
                                            2r00000000 2r00000110
                                            2r00000000 2r00000110
                                            2r00000000 2r00000110
                                            2r00000000 2r00001110
                                            2r01110000 2r00011100
                                            2r01111000 2r00111100
                                            2r00111111 2r11111000
                                            2r00001111 2r11100000
                                           ].
        Round3DCheckBotForm := Round3DCheckBotForm onDevice:Display.
    ].
    ^ Round3DCheckBotForm

    "Created: / 3.11.1997 / 14:29:37 / cg"
    "Modified: / 30.7.1998 / 21:29:57 / cg"
!

round3DCheckInnerForm
    Round3DCheckInnerForm isNil ifTrue:[
        Round3DCheckInnerForm := Form 
                                width:15 
                                height:15 
                                fromArray:#[2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000111 2r11000000
                                            2r00001111 2r11100000
                                            2r00011111 2r11110000
                                            2r00111111 2r11111000
                                            2r00111111 2r11111000
                                            2r00111111 2r11111000
                                            2r00111111 2r11111000
                                            2r00111111 2r11111000
                                            2r00011111 2r11110000
                                            2r00001111 2r11100000
                                            2r00000111 2r11000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                           ].

        Round3DCheckInnerForm := Round3DCheckInnerForm onDevice:Display.
    ].
    ^ Round3DCheckInnerForm

    "Created: / 3.11.1997 / 14:29:45 / cg"
    "Modified: / 30.7.1998 / 21:30:47 / cg"
!

round3DCheckTopForm
    Round3DCheckTopForm isNil ifTrue:[
        Round3DCheckTopForm := Form 
                                width:15 
                                height:15 
                                fromArray:#[2r00000011 2r10000000
                                            2r00011110 2r11110000
                                            2r00111000 2r00011000
                                            2r01110000 2r00001100
                                            2r01100000 2r00001100
                                            2r11000000 2r00000100
                                            2r11000000 2r00000100
                                            2r11000000 2r00000000
                                            2r11000000 2r00000000
                                            2r11000000 2r00000000
                                            2r01100000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                            2r00000000 2r00000000
                                           ].
"/        fromArray:#[2r00000111 2r11000000
"/                    2r00011110 2r11110000
"/                    2r00111000 2r00111000
"/                    2r01110000 2r00011100
"/                    2r01100000 2r00001100
"/                    2r11000000 2r00000100
"/                    2r11000000 2r00000000
"/                    2r11000000 2r00000000
"/                    2r11000000 2r00000000
"/                    2r11000000 2r00000000
"/                    2r01100000 2r00000000
"/                    2r00000000 2r00000000
"/                    2r00000000 2r00000000
"/                    2r00000000 2r00000000
"/                    2r00000000 2r00000000
"/                   ]

        Round3DCheckTopForm := Round3DCheckTopForm onDevice:Display.
    ].
    ^ Round3DCheckTopForm

    "Created: / 3.11.1997 / 14:29:45 / cg"
    "Modified: / 30.7.1998 / 21:30:47 / cg"
!

roundHalfLightForm
    RoundHalfLightForm isNil ifTrue:[
        RoundHalfLightForm := Form
                                width:15 
                                height:15 
                                fromArray:#[2r00001100 2r01100000
                                            2r00110000 2r00010000
                                            2r01100000 2r00001000
                                            2r01000000 2r00000100
                                            2r11000000 2r00000100
                                            2r10000000 2r00000000
                                            2r10000000 2r00000000
                                            2r10000000 2r00000100
                                            2r10000000 2r00000100
                                            2r10000000 2r00000100
                                            2r11000000 2r00001000
                                            2r00110000 2r00010000
                                            2r00011000 2r00110000
                                            2r00000111 2r11000000
                                            2r00000000 2r00000000
                                           ].

"/        fromArray:#[2r00000000 2r00000000
"/                    2r00000011 2r10000000
"/                    2r00001000 2r00100000
"/                    2r00010000 2r00010000
"/                    2r00100000 2r00001000
"/                    2r00000000 2r00000100
"/                    2r01000000 2r00000100
"/                    2r01000000 2r00000100
"/                    2r01000000 2r00000100
"/                    2r00000000 2r00000100
"/                    2r00100000 2r00001000
"/                    2r00010000 2r00010000
"/                    2r00001000 2r00100000
"/                    2r00000011 2r10000000
"/                    2r00000000 2r00000000
"/                   ]

        RoundHalfLightForm := RoundHalfLightForm onDevice:Display.
    ].
    ^ RoundHalfLightForm

    "Created: / 3.11.1997 / 18:26:40 / cg"
    "Modified: / 30.7.1998 / 21:31:55 / cg"
!

roundOffForm
    RoundOffForm isNil ifTrue:[
        "DSVColumnView>>updateStyleCache calls us before our style
         cache has been initialized"
        self updateStyleCache.
    ].
    ^ RoundOffForm
!

roundOffForm_old
    ^ Form 
        width:16 
        height:16 
        fromArray:#[
            2r00000011 2r10000000
            2r00001100 2r01100000
            2r00010000 2r00010000
            2r00100000 2r00001000
            2r01000000 2r00000100
            2r01000000 2r00000100
            2r10000000 2r00000010
            2r10000000 2r00000010
            2r10000000 2r00000010
            2r01000000 2r00000100
            2r01000000 2r00000100
            2r00100000 2r00001000
            2r00010000 2r00010000
            2r00001100 2r01100000
            2r00000011 2r10000000
            2r00000000 2r00000000
        ].
!

roundOnForm
    RoundOnForm isNil ifTrue:[
        "DSVColumnView>>updateStyleCache calls us before our style
         cache has been initialized"
        self updateStyleCache.
    ].
    ^ RoundOnForm

    "
     RoundOnForm := nil. 
     self updateStyleCache
    "
!

roundOnForm_old
    ^ Form 
        width:16 
        height:16 
        fromArray:#[
            2r00000000 2r00000000
            2r00000000 2r00000000
            2r00000000 2r00000000
            2r00000000 2r00000000
            2r00000011 2r10000000
            2r00000111 2r11000000
            2r00001111 2r11100000
            2r00001111 2r11100000
            2r00001111 2r11100000
            2r00000111 2r11000000
            2r00000011 2r10000000
            2r00000000 2r00000000
            2r00000000 2r00000000
            2r00000000 2r00000000
            2r00000000 2r00000000
            2r00000000 2r00000000
       ].
!

updateStyleCache
    <resource: #style (#'radioButton.style' 
                       #'radioButton.activeLevel'
                       #'radioButton.passiveLevel'
                       #'radioButton.activeImageFile'
                       #'radioButton.activeImage'
                       #'radioButton.enteredActiveImageFile'
                       #'radioButton.enteredActiveImage'
                       #'radioButton.passiveImageFile'
                       #'radioButton.passiveImage'
                       #'radioButton.enteredPassiveImageFile'
                       #'radioButton.enteredPassiveImage'
                       #'radioButton.foregroundColor'
                       #'radioButton.backgroundColor'
                       #'radioButton.activeForegroundColor'
                       #'radioButton.activeBackgroundColor'
                       #'radioButton.borderWidth'
                      )>

    |l fetchImage|

    DefaultBorderWidth := StyleSheet at:#'radioButton.borderWidth'.

    DefaultFont := StyleSheet fontAt:'label.font'.                   
    DefaultButtonStyle := StyleSheet at:#'radioButton.style'.
    l := -1.
    DefaultButtonStyle == #round2D ifTrue:[l := 0].
    DefaultActiveLevel := StyleSheet at:#'radioButton.activeLevel' default:l.
    DefaultButtonStyle == #motif ifTrue:[l := 1].
    DefaultPassiveLevel := StyleSheet at:#'radioButton.passiveLevel' default:l.

    DefaultForegroundColor := StyleSheet at:#'radioButton.foregroundColor'.
    DefaultBackgroundColor := StyleSheet at:#'radioButton.backgroundColor'.

    DefaultActiveForegroundColor := StyleSheet at:#'radioButton.activeForegroundColor'.
    DefaultActiveBackgroundColor := StyleSheet at:#'radioButton.activeBackgroundColor'.

    RoundOnForm := RoundOffForm := nil.
    ActiveForm := EnteredActiveForm := nil.
    PassiveForm := EnteredPassiveForm := nil.

    fetchImage := 
        [:fileNameKey :imageKey :defaultW95 :defaultXP :defaultVista |
            |f|

            f := StyleSheet at:imageKey.
            f notNil 
                ifTrue:[ 
                    f := f value ]
                ifFalse:[
                    f := StyleSheet at:fileNameKey.
                    f notNil 
                        ifTrue:[
                            f := Smalltalk imageFromFileNamed:f forClass:self.]
                        ifFalse:[
                            f := (StyleSheet isWindowsVistaStyle)
                                ifTrue:defaultVista
                                ifFalse:[
                                    StyleSheet isWindowsXPStyle
                                        ifTrue:defaultXP
                                        ifFalse:defaultW95].
                        ]
                ].
            f notNil ifTrue:[
                f := f onDevice:Display
            ].
            f
        ].

    ActiveForm := RoundOnForm := fetchImage 
            value:#'radioButton.activeImageFile'
            value:#'radioButton.activeImage'
            value:[ self radioOnIcon_w95 ]
            value:[ self radioOnIcon_xp ]
            value:[ self radioOnIcon_vista ].

    PassiveForm := RoundOffForm := fetchImage 
            value:#'radioButton.passiveImageFile'
            value:#'radioButton.passiveImage'
            value:[ self radioOffIcon_w95 ]
            value:[ self radioOffIcon_xp ]
            value:[ self radioOffIcon_vista ].

    EnteredActiveForm := fetchImage 
            value:#'radioButton.enteredActiveImageFile'
            value:#'radioButton.enteredActiveImage'
            value:[ self radioOnEnteredIcon_w95 ]
            value:[ self radioOnEnteredIcon_xp ]
            value:[ self radioOnEnteredIcon_vista ].

    EnteredPassiveForm := fetchImage 
            value:#'radioButton.enteredPassiveImageFile'
            value:#'radioButton.enteredPassiveImage'
            value:[ self radioOffEnteredIcon_w95 ]
            value:[ self radioOffEnteredIcon_xp ]
            value:[ self radioOffEnteredIcon_vista ].

    DisabledActiveForm := fetchImage 
            value:#'radioButton.disabledActiveImageFile'
            value:#'radioButton.disabledActiveImage'
            value:[ self radioOnDisabledIcon_w95 ]
            value:[ self radioOnDisabledIcon_xp ]
            value:[ self radioOnDisabledIcon_vista ].

    DisabledPassiveForm := fetchImage 
            value:#'radioButton.disabledPassiveImageFile'
            value:#'radioButton.disabledPassiveImage'
            value:[ self radioOffDisabledIcon_w95 ]
            value:[ self radioOffDisabledIcon_xp ]
            value:[ self radioOffDisabledIcon_vista ].

    "
     self updateStyleCache
    "

    "Modified: / 28.4.1999 / 13:59:00 / cg"
! !

!RadioButton class methodsFor:'image specs'!

radioOffDisabledIcon_vista
    ^ VistaToolbarIconLibrary radioOffDisabled12x12Icon
!

radioOffDisabledIcon_w95
    ^ self radioOffIcon_w95
!

radioOffDisabledIcon_xp
    ^ self radioOffIcon_xp
!

radioOffEnteredIcon_vista
    ^ VistaToolbarIconLibrary radioOffEntered12x12Icon
!

radioOffEnteredIcon_w95
    ^ self radioOffIcon_w95
!

radioOffEnteredIcon_xp
    ^ self radioOffIcon_xp
!

radioOffIcon_vista
    ^ VistaToolbarIconLibrary radioOff12x12Icon
!

radioOffIcon_w95
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOffIcon_w95 inspect
     ImageEditor openOnClass:self andSelector:#radioOffIcon_w95
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'RadioButton class radioOffIcon_w95'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A@PDA@DA@PDDA@PDA@PA@P@@@@@A@PPDA@D@@@LC@0L@@@LDA@D@@0LC@0LC@ LD@P@C@0LC@0LC@0HC@P@C@0LC@0LC@0HC@P@C@0LC@0LC@0HC@P@C@0LC
@0LC@0HCA@D@@0LC@0LC@ LDA@DB@ LC@0LB@ LDA@PC@0HB@ HC@0PDA@PDA@LC@0LDA@PD') ; colorMapFromArray:#[0 0 0 128 128 128 223 223 223 255 255 255 0 0 0]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C0@?0G? _>C?<O?0??C?<G? _>@?0@<@') ; yourself); yourself]
!

radioOffIcon_xp
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOffIcon_xp inspect
     ImageEditor openOnClass:self andSelector:#radioOffIcon_xp
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'RadioButton class radioOffIcon_xp'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
KB0,A T''G"\EA"0,KB0,B1,OH14%DQ,KKB0,B1 P@BPTE1$&J@,,D1,P@BPTE1$\CB$[D0TO@BPTE1$\C@4+E T''H2PTE1$\C@4+@Q<JG!!4TE1$\C@4+@PL*
G (%E1$\C@4+@PLHHB\UDQ$\C@4+@PLHA0$ED1,&C@4+@PLHA0P[H"0KJB$+@PLHA0PNB20,KA([E!!<*H@$[B20,KB0,HQT''G (R@"0,K@@a') ; colorMapFromArray:#[224 224 219 247 247 246 221 226 229 249 249 248 188 204 217 164 183 198 222 228 229 253 253 252 251 251 250 112 145 175 90 128 159 180 195 206 241 241 239 243 243 241 96 133 166 100 134 161 166 181 191 104 137 166 164 182 198 222 227 229 229 229 226 164 183 197 110 143 172 232 232 229 85 122 154 236 236 233 179 195 206 33 85 130 239 239 236 218 220 218 36 87 131 185 200 213 188 203 216 222 226 229 222 227 228 167 183 193 226 226 222 171 186 198 178 193 205 90 128 160 91 129 161 181 196 208 242 244 245 245 245 244 0 0 0]; mask:((ImageMask new) width: 13; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'G<@?8G?0??#?>O?8??#?>O?8??!!?<C? G<@b') ; yourself); yourself]
!

radioOnDisabledIcon_vista
    ^ VistaToolbarIconLibrary radioOnDisabled12x12Icon
!

radioOnDisabledIcon_w95
    ^ self radioOnIcon_w95
!

radioOnDisabledIcon_xp
    ^ self radioOnIcon_xp
!

radioOnEnteredIcon_vista
    ^ VistaToolbarIconLibrary radioOnEntered12x12Icon
!

radioOnEnteredIcon_w95
    ^ self radioOnIcon_w95
!

radioOnEnteredIcon_xp
    ^ self radioOnIcon_xp
!

radioOnIcon_vista
    ^ VistaToolbarIconLibrary radioOn12x12Icon
!

radioOnIcon_w95
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOnIcon_w95 inspect
     ImageEditor openOnClass:self andSelector:#radioOnIcon_w95
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'RadioButton class radioOnIcon_w95'
        ifAbsentPut:[(Depth8Image new) width: 12; height: 12; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
A@PDA@DA@PDDA@PDA@PA@P@@@@@A@PPDA@D@@@LC@0L@@@LDA@D@@0LC@0LC@ LD@P@C@0L@@@LC@0HC@P@C@0@@@@@C@0HC@P@C@0@@@@@C@0HC@P@C@0L@
@@LC@0HCA@D@@0LC@0LC@ LDA@DB@ LC@0LB@ LDA@PC@0HB@ HC@0PDA@PDA@LC@0LDA@PD') ; colorMapFromArray:#[0 0 0 128 128 128 223 223 223 255 255 255 0 0 0]; mask:((ImageMask new) width: 12; height: 12; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'C0@?0G? _>C?<O?0??C?<G? _>@?0@<@') ; yourself); yourself]
!

radioOnIcon_xp
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self radioOnIcon_xp inspect
     ImageEditor openOnClass:self andSelector:#radioOnIcon_xp
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'RadioButton class radioOnIcon_xp'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 13; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
Q4]GC18MK04^C4]GQ4]GL0T<JD@1PPT3Q4]GL2ABA2(9BQ@AO3MGE UBOQ<7DBMCIA(EE!!8<A1<HL#86K@IDJQ8MJB(7L XQC (&I!!,UK4@9DC8WJ3UE@0LR
K1T1BRL6Q"8TLC(-M@4"PQACK@(DI1L\C@@^E TAI@H&@3(\B2TEFT\3O1)DI L-CBT;L4]GQ3 EJQ,RM@@EL4]GQ4]GFBHMK1T!!GT]GQ0@a') ; colorMapFromArray:#[112 145 175 178 193 205 245 245 243 249 249 248 36 150 36 33 85 130 85 213 81 224 224 219 226 232 222 232 232 229 154 204 152 253 253 253 253 253 252 90 128 160 41 168 38 222 228 229 236 236 233 67 195 63 242 244 245 238 243 237 19 146 16 90 128 159 222 227 229 66 195 63 222 226 229 222 227 228 181 196 208 185 200 213 252 252 251 221 226 229 164 183 198 231 231 227 85 122 154 164 182 198 164 183 197 239 239 236 243 243 241 188 204 217 247 247 246 152 201 151 167 183 193 110 143 172 226 226 222 56 185 53 232 238 230 251 251 250 34 162 32 36 87 131 152 200 151 171 186 198 169 220 166 180 195 206 188 203 216 33 161 33 160 210 158 234 234 230 179 195 206 229 229 226 250 250 249 96 133 166 100 134 161 229 229 225 77 191 74 91 129 161 218 220 218 104 137 166 166 181 191 241 241 239 245 245 244 38 150 35 42 168 39 0 0 0]; mask:((ImageMask new) width: 13; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'G<@?8G?0??#?>O?8??#?>O?8??!!?<C? G<@b') ; yourself); yourself]
! !

!RadioButton methodsFor:'accessing'!

allViewBackground:something if:condition
    (condition value:self) ifTrue:[
        self backgroundColor:something.

        (buttonStyle == #motif 
        or:[buttonStyle == #round3D
        or:[buttonStyle == #image
        or:[buttonStyle == #round2D]]]) ifTrue:[
            enteredBgColor := something.
            activeBgColor := something.
        ]
    ]
!

forceRadioButtonStyle
    "force the radioButton to be displayed as round/motif radio button -
     even if the styleSheet defaults differently.
     (as in IRIS style)"

    buttonStyle isNil ifTrue:[
        styleSheet is3D ifTrue:[
            buttonStyle := #round3D.
            activeBgColor := bgColor. 
            activeFgColor := fgColor.
        ] ifFalse:[
            buttonStyle := #round2D.
                activeFgColor := fgColor.
                activeBgColor := bgColor.
        ].
        buttonOnLevel := DefaultActiveLevel.
        buttonOffLevel := DefaultPassiveLevel.
        onLevel := offLevel := 0.
        self level:0
    ]

    "Modified: / 18.6.1998 / 21:19:01 / cg"
    "Created: / 18.6.1998 / 21:23:58 / cg"
! !

!RadioButton methodsFor:'changing state'!

turnOff
    |id|

    super turnOff.
    id := gc drawableId.
    id notNil ifTrue:[
        self isNativeWidget ifTrue:[
            device changeButtonState:false in:id.
        ].
    ].
!

turnOn
    |id|

    super turnOn.
    id := gc drawableId.
    id notNil ifTrue:[
        self isNativeWidget ifTrue:[
            device changeButtonState:true in:id.
        ].
    ].
! !

!RadioButton methodsFor:'drawing'!

drawToggleImage
    "drawing of the radio image is done here."

    |x y img clrTop clrBot imgTop imgBot imgInside imgH imgOn threeD lvl
     isActive isEntered isEnabled imgTopHeight graphicsDevice|

    buttonStyle isNil ifTrue:[
        ^ super drawToggleImage
    ].

    isActive := controller pressed.
    isEnabled := controller enabled.
    isEnabled ifFalse:[
        img := isActive ifTrue: [disabledOnImage] ifFalse: [disabledOffImage].
    ] ifTrue:[
        isEntered := controller entered.
        isEntered ifTrue:[        
            img := isActive ifTrue: [enteredOnImage] ifFalse: [enteredOffImage].
        ] ifFalse:[
            img := isActive ifTrue:[onImage] ifFalse: [offImage].
        ]
    ].

    img notNil ifTrue:[
        x := hSpace + margin.
        y := (height - img height) // 2.
        self displayForm:img x:x y:y.
        ^ self.
    ].

    threeD := true.
    buttonStyle == #motif ifTrue:[
        "/ square rotated by 45 degrees ...
        imgTop := self class motifCheckTopForm.
        imgBot := self class motifCheckBotForm.
        imgInside := self class motifCheckInnerForm.
    ] ifFalse:[
        buttonStyle == #round3D ifTrue:[
            "/ round 3D button ...
            imgTop := self class round3DCheckTopForm.
            imgBot := self class round3DCheckBotForm.
            imgInside := self class round3DCheckInnerForm.
            imgH := self class roundHalfLightForm.
            buttonOnLevel == buttonOffLevel ifTrue:[
                isActive ifTrue:[
                    imgOn := self class roundOnForm.
                ]
            ].
        ] ifFalse:[
            buttonStyle == #image ifTrue:[
                "/ bitmap images ...
                imgTop := buttonOffImage.
                isActive ifTrue:[
                    imgOn := buttonOnImage.
                ].
            ] ifFalse:[    
                "/ round 2D ...
                imgTop := self class roundOffForm.
                isActive ifTrue:[
                    imgOn := self class roundOnForm.
                ].
            ].
            threeD := false.
        ]
    ].

    imgTopHeight := 0.
    graphicsDevice := device.

    imgTop notNil ifTrue:[imgTop := imgTop onDevice:graphicsDevice. imgTopHeight := imgTop height].
    imgBot notNil ifTrue:[imgBot := imgBot onDevice:graphicsDevice].
    imgInside notNil ifTrue:[imgInside := imgInside onDevice:graphicsDevice].
    imgH notNil ifTrue:[imgH := imgH onDevice:graphicsDevice].
    imgOn notNil ifTrue:[imgOn := imgOn onDevice:graphicsDevice].

    x := hSpace + margin.
    y := (height - imgTopHeight) // 2.

    threeD ifFalse:[
        imgTop notNil ifTrue:[
            self paint:fgColor.
            self displayForm:imgTop x:x y:y.
        ].
        (isActive and:[imgOn notNil]) ifTrue:[
            self paint:(lampColor ? activeFgColor).
            self displayForm:imgOn x:x y:y
        ]
    ] ifTrue:[
        lvl := isActive ifTrue:[buttonOnLevel]
                        ifFalse:[buttonOffLevel].
        lvl < 0 ifTrue:[
            clrTop := shadowColor.
            clrBot := lightColor.
        ] ifFalse:[
            clrTop := lightColor.
            clrBot := shadowColor.
        ].
        self paint:clrTop.
        self displayForm:imgTop x:x y:y.
        self paint:clrBot.
        self displayForm:imgBot x:x y:y.

        (imgH notNil and:[halfShadowColor notNil]) ifTrue:[
            self paint:halfShadowColor.
            self displayForm:imgH x:x y:y
        ].

        imgInside notNil ifTrue:[
            self paint:(View defaultViewBackgroundColor).
            self displayForm:imgInside x:x y:y
        ].
        (isActive and:[imgOn notNil]) ifTrue:[
            self paint:lampColor.
            self displayForm:imgOn x:x y:y
        ]
    ]

    "Created: / 3.11.1997 / 12:16:30 / cg"
    "Modified: / 28.4.1999 / 14:02:00 / cg"
!

drawWin95FocusFrame
    "redefined to draw the focus frame around the string-only"

    |x y m1|

    x := labelOriginX. " margin + 1. "
    y := labelOriginY. " margin + 1. "
    m1 := margin + 1.
    self
        displayDottedRectangleX:x
        y:y
        width:(width - x - m1)
        height:(height - y - m1).

    "Created: / 17.9.1998 / 14:16:46 / cg"
    "Modified: / 29.4.1999 / 21:51:00 / cg"
! !

!RadioButton methodsFor:'initialization'!

defaultControllerClass
    ^ RadioButtonController
!

initStyle
    "setup viewStyle specifics"

    <resource: #style (#'radioButton.showLamp')>

    buttonStyle isNil ifTrue:[
        buttonStyle := DefaultButtonStyle.
    ].

    super initStyle.

    DefaultBorderWidth notNil ifTrue:[self borderWidth: DefaultBorderWidth].
    fgColor := DefaultForegroundColor ? fgColor.
    bgColor := DefaultBackgroundColor ? bgColor.
    activeBgColor := DefaultActiveBackgroundColor ? activeBgColor.
    enteredBgColor := bgColor.

    buttonStyle isNil ifTrue:[
        showLamp := styleSheet at:#'radioButton.showLamp' default:showLamp.
        ^ self
    ].

    adjust := #left.
    showLamp := true.
    lampColor := Color black.
    buttonOnLevel := DefaultActiveLevel.
    buttonOffLevel := DefaultPassiveLevel.
    onLevel := offLevel := 0.

    self level:0.

    (buttonStyle == #motif 
    or:[buttonStyle == #round3D
    or:[buttonStyle == #image]]) ifTrue:[
        activeBgColor := bgColor. 
        activeFgColor := fgColor.

        buttonStyle == #image ifTrue:[
            |graphicsDevice|

            self isNativeWidget ifFalse:[
                graphicsDevice := device.
                buttonOnImage := self class roundOnForm.
                buttonOnImage notNil ifTrue:[ buttonOnImage := buttonOnImage onDevice:graphicsDevice].
                buttonOffImage := self class roundOffForm.
                buttonOffImage notNil ifTrue:[ buttonOffImage := buttonOffImage onDevice:graphicsDevice].

                onImage := self class activeForm.
                onImage notNil ifTrue:[ onImage := onImage onDevice:graphicsDevice].
                offImage := self class passiveForm.
                offImage notNil ifTrue:[ offImage := offImage onDevice:graphicsDevice].
                disabledOnImage := self class disabledActiveForm.
                disabledOnImage notNil ifTrue:[ disabledOnImage := disabledOnImage onDevice:graphicsDevice].
                disabledOffImage := self class disabledPassiveForm.
                disabledOffImage notNil ifTrue:[ disabledOffImage := disabledOffImage onDevice:graphicsDevice].
                enteredOnImage := self class enteredActiveForm.
                enteredOnImage notNil ifTrue:[ enteredOnImage := enteredOnImage onDevice:graphicsDevice].
                enteredOffImage := self class enteredPassiveForm.
                enteredOffImage notNil ifTrue:[ enteredOffImage := enteredOffImage onDevice:graphicsDevice].
            ]
        ]
    ] ifFalse:[
        buttonStyle == #round2D ifTrue:[
            activeFgColor := fgColor.
            activeBgColor := bgColor.
        ]
    ].

    "Modified: / 25-08-2010 / 22:57:37 / cg"
! !

!RadioButton methodsFor:'native widget support'!

nativeWindowType
    "return a symbol describing my native window type 
     (may be used internally by the device as a native window creation hint,
      if the device supports native windows)"

    self class == RadioButton ifTrue:[
        ^ #RadioButton
    ].
    ^ nil
! !

!RadioButton methodsFor:'private'!

computeLabelOrigin
    super computeLabelOrigin.
    buttonStyle notNil ifTrue:[    
        labelOriginX := hSpace + 15 + hSpace  
    ]

    "Modified: / 3.11.1997 / 18:17:58 / cg"
!

lampImageHeight
    buttonStyle isNil ifTrue:[^ super lampImageHeight].
    ^ 15

    "Created: / 3.11.1997 / 14:27:27 / cg"
    "Modified: / 3.11.1997 / 18:10:39 / cg"
!

lampImageWidth
    buttonStyle isNil ifTrue:[^ super lampImageWidth].
    ^ 15

    "Created: / 3.11.1997 / 14:27:23 / cg"
    "Modified: / 3.11.1997 / 18:10:50 / cg"
!

rawLabelSizeOf:aLogo
    "compute the extent needed to hold the label plus the lamp"

    |ext|

    ext := super rawLabelSizeOf:aLogo.
    buttonStyle notNil ifTrue:[
        ^ ext + (15 @ 0)
    ].
    ^ ext
! !

!RadioButton methodsFor:'queries'!

is3D
    buttonStyle == #round2D ifTrue:[^ false.].
    ^ super is3D

    "Created: / 3.11.1997 / 14:39:36 / cg"
! !

!RadioButton class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

