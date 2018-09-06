"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

Button subclass:#Toggle
	instanceVariableNames:'showLamp lampColor lampWidth lampHeight'
	classVariableNames:'DefaultShowLamp DefaultLampColor LampInset'
	poolDictionaries:''
	category:'Views-Interactors'
!

!Toggle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    this button changes state whenever clicked upon and stays down (pressed) 
    until clicked again. All the main action is in Button and the controller
    (ToggleController).

    The toggle may optionally display a little kind-of-lamp (or LED), which
    is turned on when the toggle is pressed. (i.e. as in the Interviews toolkit).

    whenever the Toggle changes its change, it will evaluate one of
    pressAction or releaseAction.

    For ST-80 compatibility, if the model is nonNil, this one gets a new
    value and is sent a changed message. Also, the toggle will follow changes 
    in the model and update its display as appropriate.
    If nonNil, the model is supposed to be a ValueHolder holding true or false.


    [instance variables:]
        showLamp          <Boolean>     true if a lamp should be displayed
        lampColor         <Color>       color of the lamp
        lampWidth         <Integer>     width of the lamp in pixel
        lampHeight        <Integer>     height of the lamp in pixel

    [styleSheet values:]
        toggleShowLamp    <Boolean>     if true, a lamp is shown; default:false.
        toggleLampColor   <Color>       lamps color; default:yellow.

    [author:]
        Claus Gittinger

    [see also:]
        Button RadioButton
        ( introduction to view programming :html: programming/viewintro.html#INTER_TOGGLES )
        
        
"
!

examples
"
    Examples:
    Try all, to see what is possible.
        (notice, that these examples are meant to show what can be done;
         usually, all style-related stuff is preinitialized - you should not
         normally play around with onLevel, offLevel, showLamp: etc)


      simple:
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'press here' in:v.
        t origin:10 @ 10.
        t action:[:value | Transcript show:'toggle state: '; showCR:value.].
        v open
                                                                        [exEnd]


      separate press/release actions:
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'press here' in:v.
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'toggle pressed'.].
        t releaseAction:[Transcript showCR:'toggle released'.].
        v open
                                                                        [exEnd]


      changing logo:
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'eat me' in:v.
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'smaller'. t label:'drink me'].
        t releaseAction:[Transcript showCR:'larger'. t label:'eat me'].
        v open
                                                                        [exEnd]


      changing logo:
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle in:v.
        t logo:(Form width:16 height:14 fromArray:#(
                                                        2r00000000 2r00000000
                                                        2r00000000 2r00000000
                                                        2r00000000 2r00000000
                                                        2r00000111 2r11100000
                                                        2r00001100 2r00000000
                                                        2r00011000 2r00000000
                                                        2r00011000 2r00000000
                                                        2r00011000 2r00000000
                                                        2r00011000 2r00000000
                                                        2r00001100 2r00000000
                                                        2r00000111 2r11100000
                                                        2r00000000 2r00000000
                                                        2r00000000 2r00000000
                                                        2r00000000 2r00000000)).
        t origin:10 @ 10.
        v open
                                                                        [exEnd]


      uhh - changing logos and getting bg-colors from the image:
                                                                        [exBegin]
        |v t i|

        v := StandardSystemView new extent:200@200.
        t := Toggle in:v.
        t origin:10 @ 10.
        t showLamp:false.
        t activeLogo:(i := Image fromFile:'red-ball.gif').
        t passiveLogo:(Image fromFile:'green-ball.gif').
        t backgroundColor:(i at:0@0).
        t enteredBackgroundColor:(t backgroundColor).
        t activeBackgroundColor:(t backgroundColor).
        v open
                                                                        [exEnd]


      changing logo and freezing size (looks better):
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        'create with large logo; freeze; change to small logo'.
        t := Toggle label:'drink me' in:v. 
        t sizeFixed:true.
        t label:'eat me'.

        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'smaller'. t label:'drink me'].
        t releaseAction:[Transcript showCR:'larger'. t label:'eat me'].
        v open
                                                                        [exEnd]


      adding a lamp (in some view styles, this is the default anyway):
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'off' in:v.
        t showLamp:true.
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'on'. t label:'on'].
        t releaseAction:[Transcript showCR:'off'. t label:'off'].
        v open
                                                                        [exEnd]


      changing lamps color:
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'off' in:v.
        t showLamp:true.
        t lampColor:Color red.
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'on'. t label:'on'.].
        t releaseAction:[Transcript showCR:'off'. t label:'off'.].
        v open
                                                                        [exEnd]


      lamp only - no '3D going-in' (this is the default with IRIS style)
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'off' in:v.
        t showLamp:true.
        t onLevel:(t offLevel).
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'on'. t label:'on'].
        t releaseAction:[Transcript showCR:'off'. t label:'off'].
        v open
                                                                        [exEnd]


      lamp and freezing size of the label (looks better):
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'off' in:v.
        t showLamp:true.
        t sizeFixed:true.
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'on'. t label:'on'].
        t releaseAction:[Transcript showCR:'off'. t label:'off'].
        v open
                                                                        [exEnd]


      another variation:
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'off' in:v.
        t showLamp:true.
        t sizeFixed:true.
        t onLevel:(t offLevel).
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'on'. t label:'on'].
        t releaseAction:[Transcript showCR:'off'. t label:'off'].
        v open
                                                                        [exEnd]


      and another one:
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'off' in:v.
        t showLamp:true.
        t sizeFixed:true.

        t showLamp:false.
        t offLevel:3.
        t onLevel:3.
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'on'. t showLamp:true. t label:'on'].
        t releaseAction:[Transcript showCR:'off'. t showLamp:false. t label:'off'].
        v open
                                                                        [exEnd]


      another font:
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'off' in:v.
        t font:(Font family:'times' face:'bold' style:'roman' size:24).
        t label:'hello'.
        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'on'.].
        t releaseAction:[Transcript showCR:'off'.].
        v open
                                                                        [exEnd]


      another font (no, I don't know what it means :-):
                                                                        [exBegin]
        |v t|

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'off' in:v.
        t font:(Font family:'k14' face:nil style:nil size:nil).
        t label:(TwoByteString with:(Character value:16r3021)).

        t origin:10 @ 10.
        t pressAction:[Transcript showCR:'on'.].
        t releaseAction:[Transcript showCR:'off'.].
        v open
                                                                        [exEnd]


    using a model (look at 'value' in the inspector):
                                                                        [exBegin]
        |m v t|

        m := ValueHolder newBoolean.
        m inspect.

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'press here to change value' in:v.
        t origin:10 @ 10.
        t model:m.
        v open
                                                                        [exEnd]


    using a model with different changeSelector:
                                                                        [exBegin]
        |m v t|

        m := Plug new.
        m respondTo:#setValue1: with:[:value | Transcript show:'value 1 changed to: '; showCR:value].
        m respondTo:#setValue2: with:[:value | Transcript show:'value 2 changed to: '; showCR:value].

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'press here for value1' in:v.
        t origin:10 @ 10.
        t model:m; change:#setValue1:.
        t := Toggle label:'press here for value2' in:v.
        t origin:10 @ 50.
        t model:m; change:#setValue2:.
        v open
                                                                        [exEnd]


    two toggles on the same model:
                                                                        [exBegin]
        |m v t|

        m := true asValue.

        v := StandardSystemView new extent:200@200.
        t := Toggle label:'press here' in:v.
        t origin:10 @ 10.
        t model:m.

        t := Toggle label:'or here' in:v.
        t origin:10 @ 50.
        t model:m.
        v open
                                                                        [exEnd]
"
! !

!Toggle class methodsFor:'defaults'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'toggle.showLamp'
                       #'toggle.lampColor')>

    DefaultShowLamp := StyleSheet at:#'toggle.showLamp' default:false.
    DefaultLampColor := StyleSheet colorAt:#'toggle.lampColor' default:Color yellow.
    LampInset := 1 "2".

    "Modified: / 3.11.1997 / 11:42:19 / cg"
! !

!Toggle methodsFor:'accessing-look'!

lampColor
    "returns the color of the toggle-lamp"

    ^ lampColor
!

lampColor:aColor
    "change the color of the toggle-lamp"

    lampColor := aColor.
    shown ifTrue:[
        (showLamp and:[controller pressed]) ifTrue:[
            self invalidateRepairNow:true
        ]
    ]

    "Modified: / 6.6.1998 / 19:32:50 / cg"
!

lampHeight
    ^ lampHeight
!

lampHeight:something
    lampHeight := something.
!

lampWidth
    ^ lampWidth 
!

lampWidth: something
    lampWidth := something
!

showLamp
    "return true, if I show a lamp"

    ^ showLamp
!

showLamp:aBoolean
    "enable/disable drawing of the lamp"

    showLamp ~~ aBoolean ifTrue:[
	showLamp := aBoolean.
	self computeLabelSize.
	fixSize ifFalse:[
	    self resize
	]
    ]
! !

!Toggle methodsFor:'accessing-mvc'!

model:aModel
    super model:aModel.
    self getValueFromModel.

    "Modified: 28.2.1997 / 19:09:58 / cg"
! !

!Toggle methodsFor:'change & update'!

update:something with:parameter from:changedObject
    something == aspectMsg ifTrue:[
        self getValueFromModel.
    ].
    super update:something with:parameter from:changedObject
! !

!Toggle methodsFor:'initialization'!

defaultControllerClass
    ^ ToggleController
!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    lampColor notNil ifTrue:[lampColor := lampColor onDevice:device].

    "Created: 13.1.1997 / 23:46:31 / cg"
!

initStyle
    "setup viewStyle specifics"

    <resource: #style (#'toggle.lampWidthMM' 
                       #'toggle.lampHeightMM'
                       #'toggle.activeLevel'
                       #'toggle.passiveLevel'
                       #'toggle.activeForegroundColor'
                       #'toggle.activeBackgroundColor'
                       #'toggle.foregroundColor'
                       #'toggle.backgroundColor'
                      )>

    |mm fg bg|

    super initStyle.

    showLamp := DefaultShowLamp.
    showLamp ifTrue:[
        onLevel := offLevel.

        "don't know, if I like this ..."
        "
        activeBgColor := bgColor
        "
    ].

    lampColor := DefaultLampColor.
    mm := styleSheet at:#'toggle.lampWidthMM' default:1.5.
    lampWidth := (device horizontalPixelPerMillimeter * mm) rounded.
    mm := styleSheet at:#'toggle.lampHeightMM' default:3.0.
    lampHeight := (device verticalPixelPerMillimeter * mm) rounded.

    onLevel := styleSheet at:#'toggle.activeLevel' default:onLevel.
    offLevel := styleSheet at:#'toggle.passiveLevel' default:offLevel.

    fg := styleSheet colorAt:#'toggle.activeForegroundColor'.
    fg notNil ifTrue:[
        activeFgColor := fg.
    ].
    bg := styleSheet colorAt:#'toggle.activeBackgroundColor'.
    bg notNil ifTrue:[
        activeBgColor := bg.
    ].

    fg := styleSheet colorAt:#'toggle.foregroundColor'.
    fg notNil ifTrue:[
        self foregroundColor:fg.
    ].

    bg := styleSheet colorAt:#'toggle.backgroundColor'.
    bg notNil ifTrue:[
        self backgroundColor:bg.
        shadowColor := (bg averageColorIn:(0@0 corner:7@7)) darkened onDevice:device.
        lightColor := (bg averageColorIn:(0@0 corner:7@7)) lightened onDevice:device.
    ].

    "Modified: / 3.11.1997 / 02:22:02 / cg"
! !

!Toggle methodsFor:'private'!

computeLabelOrigin
    "compute the origin of the form/text.
     redefined to move label to the right if there is a lamp."

    super computeLabelOrigin.
    showLamp ifTrue:[
        labelOriginX := labelOriginX + hSpace + (self lampImageWidth) + hSpace.
    ]

    "Modified: / 3.11.1997 / 14:27:03 / cg"
!

getValueFromModel
    "fetch my boolean value from the model (if there is a model around)
     by sending it the aspectMessage, and update my look as required" 

    |val|

    (model notNil and:[aspectMsg notNil]) ifTrue:[
        aspectMsg == #value ifTrue:[
            val := model value   "/ faster call
        ] ifFalse:[
            val := model perform:aspectMsg withOptionalArgument:self.
        ].
        (val ? false) ifTrue:[  "allowing nil - treat as false"
            self turnOn
        ] ifFalse:[
            self turnOff
        ].
    ].

    "Created: / 14.11.1995 / 21:08:43 / cg"
    "Modified: / 1.3.2000 / 15:14:49 / cg"
!

lampImageHeight
    ^ lampHeight

    "Created: / 3.11.1997 / 14:24:47 / cg"
!

lampImageWidth
    ^ lampWidth

    "Created: / 3.11.1997 / 14:25:35 / cg"
!

rawLabelSizeOf:aLogo
    "compute the extent needed to hold the label plus the lamp"

    |ext|

    ext := super rawLabelSizeOf:aLogo.
    showLamp ifTrue:[
        ^ (ext x + hSpace + (self lampImageWidth) + hSpace)
          @
          (ext y max: self lampImageHeight)
    ].
    ^ ext

    "Modified: / 3.11.1997 / 14:26:54 / cg"
! !

!Toggle methodsFor:'redrawing'!

drawToggleImage
    "drawing of the lamp is done here."

    |x y clr l2|

    showLamp ifTrue:[
        x := hSpace + margin.
        y := (height - self lampImageHeight) // 2.
        self 
            drawEdgesForX:x y:y 
            width:(self lampImageWidth) 
            height:(self lampImageHeight)
            level:-1.
        controller pressed ifTrue:[
            clr := lampColor.
        ] ifFalse:[
            clr := bgColor.
        ].
        gc paint:clr.
        l2 := LampInset*2.
        gc
            fillRectangleX:x+LampInset y:y+LampInset 
            width:(self lampImageWidth) - l2 
            height:(self lampImageHeight) - l2
    ]

    "Created: / 3.11.1997 / 12:12:07 / cg"
    "Modified: / 3.11.1997 / 14:26:33 / cg"
!

drawWith:fg and:bg
    "redraw myself with fg/bg. Use super to draw the label, 
     drawing of the lamp is done here."

    shown ifFalse:[^ self].
    
    super drawWith:fg and:bg.   "this draws the text"

    self drawToggleImage.

    "Modified: / 3.11.1997 / 13:19:32 / cg"
! !

!Toggle class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

