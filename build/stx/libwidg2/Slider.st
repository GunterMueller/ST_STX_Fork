"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

Scroller subclass:#Slider
	instanceVariableNames:'sliderHeight'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

!Slider class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    this class implements sliders - which are simply scrollers
    with a constant thumbHeight. For details on actionBlocks and
    MVC operation, see the documentation in Scroller.

    [author:]
        Claus Gittinger
"
!

examples
"
    a slider with action block (ST/X style):
                                                                        [exBegin]
        |top s|

        top := StandardSystemView new extent:200@200.
        s := Slider in:top.
        s origin:(0.0@0.0) corner:(15@1.0).
        s scrollAction:[:percent | Transcript show:'moved to: '; showCR:percent asFloat].
        top open
                                                                        [exEnd]

    same, horizontal:
                                                                        [exBegin]
        |top s|

        top := StandardSystemView new extent:200@200.
        s := HorizontalSlider in:top.
        s origin:(0.0@0.0) corner:(1.0@15).
        s scrollAction:[:percent | Transcript show:'moved to: '; showCR:percent asFloat].
        top open
                                                                        [exEnd]

    with a range other than the default:
                                                                        [exBegin]
        |top s|

        top := StandardSystemView new extent:200@200.
        s := Slider in:top.
        s origin:(0.0@0.0) corner:(20@1.0).
        s scrollAction:[:percent | Transcript show:'moved to: '; showCR:percent asFloat].
        s start:-50 stop:50.
        top open
                                                                        [exEnd]

    using a model (ST-80 style):
    (see the changing value in the inspector)
                                                                        [exBegin]
        |top s m|

        m := 0 asValue.
        m inspect.
        top := StandardSystemView new extent:200@200.
        s := Slider in:top.
        s origin:(0.0@0.0) corner:(20@1.0).
        s model:m.
        top open
                                                                        [exEnd]

    reacting to changes from the model:
    (look at and/or change value using 'self value:' in the inspector).
                                                                        [exBegin]
        |top s m|

        m := 0 asValue.
        m inspect. 
        top := StandardSystemView new extent:200@200.
        s := Slider in:top.
        s origin:(0.0@0.0) corner:(20@1.0).
        s model:m.
        top open
                                                                        [exEnd]

    using a different changeSelector:
                                                                        [exBegin]
        |top s1 s2 m|

        m := Plug new.
        m respondTo:#value1: with:[:v | Transcript show:'scroller 1 moved to: '; showCR:v].
        m respondTo:#value2: with:[:v | Transcript show:'scroller 2 moved to: '; showCR:v].

        top := StandardSystemView new extent:200@200.
        s1 := Slider in:top.
        s1 origin:(0.0@0.0) corner:(20@1.0).
        s1 thumbHeight:10.  'percent'.     
        s1 model:m; change:#value1:.

        s2 := Slider in:top.
        s2 origin:(30@0.0) corner:(50@1.0).
        s2 thumbHeight:10.  'percent'.     
        s2 model:m; change:#value2:.
        top open
                                                                        [exEnd]

    another example:
                                                                        [exBegin]
        |top redVal greenVal blueVal 
         colorVal upd s1 s2 s3 l|

        redVal := 0 asValue.
        greenVal := 0 asValue.
        blueVal := 0 asValue.

        upd := [colorVal value:(Color red:redVal value
                                      green:greenVal value
                                      blue:blueVal value)].

        colorVal := (Color red:0 green:0 blue:0) asValue.
        colorVal onChangeSend:#value to:[l backgroundColor:colorVal value].

        redVal onChangeSend:#value to:upd.
        greenVal onChangeSend:#value to:upd.
        blueVal onChangeSend:#value to:upd.

        top := StandardSystemView new extent:200@200.
        top label:'Color mixer'.

        s1 := Slider in:top.
        s1 origin:(0.0@0.0) corner:(20@1.0).
        s1 thumbHeight:10.  'percent'.     
        s1 model:redVal.

        s2 := Slider in:top.
        s2 origin:(30@0.0) corner:(50@1.0).
        s2 thumbHeight:10.  'percent'.     
        s2 model:greenVal.

        s3 := Slider in:top.
        s3 origin:(60@0.0) corner:(80@1.0).
        s3 thumbHeight:10.  'percent'.     
        s3 model:blueVal.

        l := Label in:top.
        l origin:90@0.0 corner:1.0@1.0.
        l backgroundColor:Color black.

        top open
                                                                        [exEnd]

    the same setup, using action blocks:
                                                                        [exBegin]
        |top red green blue
         colorVal upd s1 s2 s3 labelModel l|

        red := green := blue := 0.

        top := StandardSystemView new extent:200@200.
        top label:'Color mixer'.

        s1 := Slider in:top.
        s1 origin:(0.0@0.0) corner:(20@1.0).
        s1 thumbHeight:10.  'percent'.     
        s1 action:[:percent | red := percent.
                              l backgroundColor:(Color red:red green:green blue:blue)].

        s2 := Slider in:top.
        s2 origin:(30@0.0) corner:(50@1.0).
        s2 thumbHeight:10.  'percent'.     
        s2 action:[:percent | green := percent.
                              l backgroundColor:(Color red:red green:green blue:blue)].

        s3 := Slider in:top.
        s3 origin:(60@0.0) corner:(80@1.0).
        s3 thumbHeight:10.  'percent'.     
        s3 action:[:percent | blue := percent.
                              l backgroundColor:(Color red:red green:green blue:blue)].

        l := Label in:top.
        l origin:90@0.0 corner:1.0@1.0.
        l backgroundColor:Color black.

        top open
                                                                        [exEnd]
"
! !

!Slider methodsFor:'Compatibility-VW'!

beHorizontal
    "ST-80 compatibility: make the slider a horizontalSlider"

    sliderHeight := (self horizontalPixelPerMillimeter:10) rounded.
    orientation := #horizontal

    "Created: 27.1.1997 / 13:46:42 / cg"
!

beVertical
    "ST-80 compatibility: make the slider a verticalSlider"

    sliderHeight := (self verticalPixelPerMillimeter:10) rounded.
    orientation := #vertical

    "Created: 27.1.1997 / 13:47:07 / cg"
! !

!Slider methodsFor:'accessing'!

sliderHeight: numPixels

    sliderHeight := numPixels.
!

thumbHeight
    "redefined since a slider has no height - just origin"

    ^ nil
! !

!Slider methodsFor:'event handling'!

buttonPress:butt x:x y:y
    self requestFocus.
    super buttonPress:butt x:x y:y
!

keyPress:key x:x y:y
    <resource: #keyboard (#CursorRight #CursorUp #CursorLeft #CursorDown)>

    |step|

    enabled ifFalse:[^ self].

    step := keyboardStep ? ((rangeEnd - rangeStart) / 10).

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

    "Modified (format): / 16-11-2016 / 23:13:56 / cg"
! !

!Slider methodsFor:'forced scroll'!

pageDown
    "ignored - a slider has no concept of page-wise scrolling"

    ^ self
!

pageUp
    "ignored - a slider has no concept of page-wise scrolling"

    ^ self
! !

!Slider methodsFor:'initialization'!

initStyle
    "initialize style specifics"

    <resource: #style (#'slider.NTallyMarks' #'slider.tallyLevel')>

    super initStyle.

    tallyMarks := StyleSheet at:'slider.NTallyMarks' default:1.
    tallyLevel := StyleSheet at:'slider.tallyLevel' default:-1.    
    thumbActiveLevel := thumbLevel.

    "Modified: / 12.5.1998 / 21:01:43 / cg"
!

initialize
    sliderHeight := (self verticalPixelPerMillimeter:10) rounded.
    super initialize.
    thumbHeight := 0.
! !

!Slider methodsFor:'private'!

absFromPercent:percent
    "given a percentage, compute number of pixels"

    |fullSize|

    (orientation == #vertical) ifTrue:[
	fullSize := height
    ] ifFalse:[
	fullSize := width
    ].
    ^ ((percent * (fullSize - sliderHeight - (margin * 2))) / 100) rounded
!

computeThumbFrame
    "redefined, since the thumb-height stays constant"

    |nh nw ny nx sz m|

    thumbHeight := 0.
    sz := (self absFromPercent:thumbOrigin) + margin.
    m := margin + inset.
    (orientation == #vertical) ifTrue:[
	ny := sz.
	nh := sliderHeight.
	nx := m.     
	nw := width - (2 * nx).
    ] ifFalse:[
	nx := sz.
	nw := sliderHeight.
	ny := m.     
	nh := height - (2 * ny).
    ].

    "
     do not create new Rectangle if its the same anyway
    "
    thumbFrame notNil ifTrue:[
	(ny == thumbFrame top) ifTrue:[
	  (nx == thumbFrame left) ifTrue:[
	    (nh == thumbFrame height) ifTrue:[
	      (nw == thumbFrame width) ifTrue:[ ^ self]
	    ]
	  ]
	]
    ].
    thumbFrame := Rectangle left:nx top:ny width:nw height:nh
!

percentFromAbs:absValue
    "given a number of pixels, compute percentage"

    |fullSize val|

    (orientation == #vertical) ifTrue:[
        fullSize := height
    ] ifFalse:[
        fullSize := width
    ].

    absValue < 0 ifTrue:[^ rangeStart].
    absValue > fullSize ifTrue:[^ rangeEnd].

    val := absValue / (fullSize - sliderHeight - (margin * 2)) 
           * (rangeEnd - rangeStart).
    val := val + rangeStart.
    rangeStart < rangeEnd ifTrue:[
        val < rangeStart ifTrue:[^ rangeStart].
        val > rangeEnd ifTrue:[^ rangeEnd].
    ] ifFalse:[
        val > rangeStart ifTrue:[^ rangeStart].
        val < rangeEnd ifTrue:[^ rangeEnd].
    ].
    ^ val

    "Modified: / 21.1.1998 / 19:31:08 / cg"
! !

!Slider class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

