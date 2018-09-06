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

View subclass:#Scroller
	instanceVariableNames:'thumbOrigin thumbHeight thumbColor thumbFrameColor scrollAction
		orientation thumbFrame thumbLevel scrolling pressOffset
		synchronousOperation shadowForm lightForm inset thumbShadowColor
		thumbLightColor thumbEdgeStyle thumbHalfShadowColor
		thumbHalfLightColor thumbEnteredColor thumbFrameSizeDifference
		tallyLevel tallyMarks fixThumbHeight frameBeforeMove ghostColor
		ghostFrameColor ghostLevel rangeStart rangeEnd rangeStep entered
		thumbActiveLevel originBeforeMove thumbImage enabled keyboardStep
		autoRepeat repeatBlock initialRepeatDelay repeatDelay
		lastMousePosition thumbActiveColor'
	classVariableNames:'HandleShadowForm HandleLightForm DefaultViewBackground
		DefaultShadowColor DefaultLightColor DefaultThumbColor
		DefaultThumbShadowColor DefaultThumbLightColor
		DefaultThumbHalfShadowColor DefaultThumbHalfLightColor
		DefaultHalfShadowColor DefaultHalfLightColor DefaultTallyMarks
		DefaultTallyLevel DefaultLevel DefaultBorderWidth
		DefaultThumbLevel DefaultInset DefaultThumbFrameColor
		DefaultGhostColor DefaultGhostFrameColor DefaultGhostLevel
		DefaultFixThumbHeight DefaultEdgeStyle DefaultFullViewBackground
		DefaultThumbEnteredColor DefaultThumbActiveColor
		DefaultThumbActiveLevel SnapBackDistance DefaultMiddleButtonJump
		NewCursors DefaultThumbImage HandleImage DefaultHScrollerHeight
		DefaultVScrollerWidth DefaultStopPagerAtThumb DefaultTallyInset
		MinThumbSize DefaultTallyDistance DefaultVerticalThumbFrameImage
		DefaultHorizontalThumbFrameImage'
	poolDictionaries:''
	category:'Views-Interactors'
!

!Scroller class methodsFor:'documentation'!

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
    this class implements the scroller for scrollbars.
    it can also be used by itself for scrollbars without step-buttons.
    When moved, either a predefined action is performed (scrollAction),
    or a model is informed via the changeMsg (which is #value: by default).

    The scroller can work synchronous (i.e. every move leads to an immediate evaluation
    of the action, or asynchronous (i.e. perform action on end-of move).
    By default, scrollers are synchronous. Asynchronous operation makes sense, 
    if the scroll operation (redraw) is expensive and takes a long time.

    This class is used both for concrete instances (vertical scrollers)
    and as an abstract superclass for horizontalScrollers, sliders and
    miniScrollers.

  range:
    the value passed to the model or via the action blocks is scaled according
    to the min/maxRange instance variables.
    These default to 0..100 for percentage values.
    It does not make sense to change the range for scrollbar-scrollers,
    but may be useful with Sliders or in special applications.

  style stuff:

    Beside the obvious 3D rectangle, a scroller may draw a know-form
    (as in NeXT) or little tally marks (as on SGI) in itself.
    These are controlled by the shadowForm, lightForm, tallyLevel and tallyMarks
    instance variables. All of this is initialized from the styleSheet.

  [Instance variables:]

    thumbOrigin                 <Number>        origin of thumb (in percent)
    thumbHeight                 <Number>        height of thumb (in percent)
    thumbColor                  <Color>         color of thumb
    thumbFrameColor             <Color>         color of the frame around the thumb
    scrollAction                <Block>         1 arg block to be evaluated when scrolled
                                                (arg is position in percent)
    orientation                 <Symbol>        #horizontal or #vertical
    thumbFrame                  <Rectangle>     frame of thumb in pixels (cached)
    thumbLevel                  <Number>        level of thumb if 3d
    scrolling                   <Boolean>       true during scroll
    pressOffset                 <Number>        temporary (offset into frame when move started)
    synchronousOperation        <Boolean>       true if synchronous (i.e. don't wait till release
                                                to perform action)
    shadowForm                  <Form>          bitmap of knob if any (shadow part)
    lightForm                   <Form>          bitmap of knob if any (light part)
    inset                       <Integer>       number of pixels to inset thumb from view borders
    thumbShadowColor            <Color>         color do draw dark parts of thumb
    thumblightColor             <Color>         color to draw light parts of thumb
    thumbEdgeStyle              <SymbolOrNil>   #soft or nil
    thumbHalfShadowColor        <Color>         used to draw smooth edges
    thumbHalfLightColor         <Color>         used to draw smooth edges
    thumbFrameSizeDifference    <Integer>       number of pixels the thumb is larger than 
                                                it should be (can be negative for mswin-style)
    tallyLevel                  <Integer>       if not zero, specifies if tally-marks should
                                                go into or out of the display (actually only <0/>0 is checked)
                                                I dont know of a better word for these ...
    tallyMarks                  <Integer>       number of tally marks
    fixThumbHeight              <Boolean>       perform 'wrong' height computation a la mswindows
    rangeStart                  <Number>        the range of the scroller
    rangeEnd                                    (defaults to 0..100)
    rangeStep                                   not currently implemented

  [style settings:]

    scrollerLevel               <Integer>       the level of the scroller w.r.t. its enclosing view
    scrollerBorderWidth         <Integer>       the borderWidth (ignored for 3D styles)

    scrollerViewBackground      <Color>         the viewBackground (color or image)
    scrollerShadowColor         <Color>         the color of 3D shadowed edges (ignored in 2D styles)
    scrollerLightColor          <Color>         the color of 3D lighted edges (ignored in 2D styles)

    scrollerThumbColor          <Color>         the thumbs color (color or image)
    scrollerThumbShadowColor    <Color>         the color of the thumbs shadowed edges (ignored in 2D styles)
    scrollerThumbLightColor     <Color>         the color of the thumbs shadowed edges (ignored in 2D styles)
    scrollerThumbEdgeStyle      <Symbol>        the edge style for the thumb (#soft or nil)
    scrollerThumbLevel          <Integer>       the 3D height of the thumb
    scrollerThumbHalfShadowColor<Color>         the halfShadow for soft edged thumbs
    scrollerThumbHalfLightColor <Color>         the halfLight for soft edged thumbs
    scrollerThumbFrameColor     <Color>         if non-nil, a rectangle is drawn around the thumb is this color
    scrollerThumbInset          <Integer>       inset of thumb from the scrollers boundary
    scrollerThumbFixHeight      <Boolean>       if true, use a fix thumb height (as in mswindows)
    scrollerGhostColor          <Color>         the color in which a ghost-rectangle is drawn
    scrollerGhostFrameColor     <Color>         if non-nil, a rectangle is drawn around the ghost is this color
    scrollerGhostLevel          <Color>         the 3D level of the ghost rectangle
    scrollerNTallyMarks         <Integer>       number of tally-marks to draw on the thumb
    scrollerTallyLevel          <Integer>       the 3D level of any tally marks
    scrollerSnapBack            <Boolean>       win95 behavior: snap back to original position if scrollers view
                                                is left by mouse (with some distance)
    scrollerMiddleButtonJump    <Boolean>       xterm behavior: middle button has shift-click behavior
                                                (positions absolute to click position)

    notice: for mswindows style, we force a WRONG thumb-frame
    computation, to make the thumb have constant size; 
    if you dont like that (I do not :-), 
    set scrollerThumbFixHeight to false (in the StyleSheet).

    [author:]
        Claus Gittinger

    [see also:]
        ScrollBar
        ScrollableView HVScrollableView
"
!

examples
"
    basic scroller setup:
									[exBegin]
	|top s|

	top := StandardSystemView new extent:200@200.
	s := Scroller in:top.
	s origin:(0.0@0.0) corner:(20@1.0).
	s thumbHeight:10.  'percent'.     
	top open
									[exEnd]

    setting its thumb-height:
									[exBegin]
	|top s|

	top := StandardSystemView new extent:200@200.
	s := Scroller in:top.
	s origin:(0.0@0.0) corner:(20@1.0).
	s thumbHeight:50.  'percent'.     
	top open
									[exEnd]

    setting its thumb-origin:
									[exBegin]
	|top s|

	top := StandardSystemView new extent:200@200.
	s := Scroller in:top.
	s origin:(0.0@0.0) corner:(20@1.0).
	s thumbHeight:10.  'percent'.     
	s thumbOrigin:30.  'percent'.     
	top open
									[exEnd]

    a scroller with action block (ST/X style):
									[exBegin]
	|top s|

	top := StandardSystemView new extent:200@200.
	s := Scroller in:top.
	s origin:(0.0@0.0) corner:(20@1.0).
	s thumbHeight:10.  'percent'.     
	s scrollAction:[:percent | Transcript show:'moved to: '; showCR:percent asFloat].
	top open
									[exEnd]

    setting its range:
									[exBegin]
	|top s|

	top := StandardSystemView new extent:200@200.
	s := Scroller in:top.
	s origin:(0.0@0.0) corner:(20@1.0).
	s thumbHeight:10.  'percent'.     
	s scrollAction:[:percent | Transcript show:'moved to: '; showCR:percent asFloat].
	s start:0 stop:1.
	top open
									[exEnd]

    create a scroller in its default extent and have it positioned
    at the side; beside another view:
									[exBegin]
	|top s v|

	top := StandardSystemView new extent:200@200.
	s := Scroller in:top.
	s origin:(0.0@0.0) corner:(0.0@1.0).
	s rightInset:(s preferredExtent x negated).
	s thumbHeight:10.
	s level:1.

	v := View in:top.
	v origin:0.0@0.0 corner:1.0@1.0.
	v leftInset:(s preferredExtent x).
	v viewBackground:Color red.
	v level:2.

	top open
									[exEnd]

    using a model (ST-80 style):
									[exBegin]
	|top s m|

	m := 0 asValue.
	InspectorView openOn:m monitor:'value'.  'look at value'.

	top := StandardSystemView new extent:200@200.
	s := Scroller in:top.
	s origin:(0.0@0.0) corner:(20@1.0).
	s thumbHeight:10.  'percent'.     
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
	s1 := Scroller in:top.
	s1 origin:(0.0@0.0) corner:(20@1.0).
	s1 thumbHeight:10.  'percent'.     
	s1 model:m; change:#value1:.

	s2 := Scroller in:top.
	s2 origin:(30@0.0) corner:(50@1.0).
	s2 thumbHeight:10.  'percent'.     
	s2 model:m; change:#value2:.
	top open
									[exEnd]
"
! !

!Scroller class methodsFor:'defaults'!

handleLightFormOn:aDisplay
    "answer the form used for the handles light area;
     cache the one for Display for the next round"

    |f|

    ((aDisplay == Display) and:[HandleLightForm notNil]) ifTrue:[
        ^ HandleLightForm
    ].
    f := Smalltalk imageFromFileNamed:'HandleLight.xbm' forClass:self.
    f notNil ifTrue:[
        f := f onDevice:aDisplay
    ] ifFalse:[
        f := Form width:8 height:8 fromArray:#[2r00000000
                                               2r00000010
                                               2r00000011
                                               2r00000011
                                               2r00000011
                                               2r00000011
                                               2r00000110
                                               2r00111100]
                                              onDevice:aDisplay
    ].
    (aDisplay == Display) ifTrue:[
        HandleLightForm := f
    ].
    ^ f

    "Modified: 23.10.2031 / 01:00:00 / cg"
!

handleShadowFormOn:aDisplay
    "answer the form used for the handles shadow area;
     cache the one for Display for the next round"

    |f|

    ((aDisplay == Display) and:[HandleShadowForm notNil]) ifTrue:[
        ^ HandleShadowForm
    ].
    f := Smalltalk imageFromFileNamed:'HandleShadow.xbm' forClass:self.
    f notNil ifTrue:[
        f := f onDevice:aDisplay
    ] ifFalse:[
        f := Form width:8 height:8 fromArray:#[2r00111100
                                               2r01100000
                                               2r11000000
                                               2r11000000
                                               2r11000000
                                               2r11000000
                                               2r01000000
                                               2r00000000]
                                           onDevice:aDisplay
    ].
    (aDisplay == Display) ifTrue:[
        HandleShadowForm := f
    ].
    ^ f

    "Modified: 19.12.1996 / 01:00:00 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'scroller.viewBackground' #'scroller.fullViewBackground'
                       #'scroller.thumbColor' 
                       #'scroller.shadowColor' #'scroller.lightColor'
                       #'scroller.thumbShadowColor' #'scroller.thumbLightColor'
                       #'scroller.thumbHalfShadowColor' #'scroller.thumbHalfLightColor'
                       #'scroller.thumbFrameColor' #'scroller.ghostColor'
                       #'scroller.ghostLevel'  #'scroller.ghostFrameColor'
                       #'scroller.NTallyMarks' #'scroller.tallyLevel' #'scroller.tallyInset'
                       #'scroller.level' #'scroller.borderWidth'
                       #'scroller.thumbLevel' #'scroller.thumbInset'
                       #'scroller.thumbFixHeight' #'scroller.thumbEdgeStyle'
                       #'scroller.thumbEnteredColor' #'scroller.thumbActiveLevel'
                       #'scroller.thumbActiveColor' 
                       #'scroller.middleButtonJump' 
                       #'scroller.newCursors' 
                       #'scroller.thumbImage' #'scroller.handleImage'
                       #'scroller.vScrollerWidth' #'scroller.hScrollerHeight'
                       #'scroller.stopPagerAtThumb'
                       #'scroller.verticalThumbFrameImage' #'scroller.horizontalThumbFrameImage' 
                     )>

    DefaultViewBackground := StyleSheet colorAt:#'scroller.viewBackground'.
    DefaultFullViewBackground := StyleSheet colorAt:#'scroller.fullViewBackground'.
    DefaultThumbColor := StyleSheet colorAt:#'scroller.thumbColor'.
    DefaultThumbEnteredColor := StyleSheet colorAt:#'scroller.thumbEnteredColor'.
    DefaultThumbActiveColor := StyleSheet colorAt:#'scroller.thumbActiveColor'.
    DefaultShadowColor := StyleSheet colorAt:#'scroller.shadowColor'.
    DefaultLightColor := StyleSheet colorAt:#'scroller.lightColor'.
    DefaultThumbShadowColor := StyleSheet colorAt:#'scroller.thumbShadowColor'.
    DefaultThumbLightColor := StyleSheet colorAt:#'scroller.thumbLightColor'.
    DefaultThumbHalfShadowColor := StyleSheet colorAt:#'scroller.thumbHalfShadowColor'.
    DefaultThumbHalfLightColor := StyleSheet colorAt:#'scroller.thumbHalfLightColor'.
    DefaultThumbFrameColor := StyleSheet colorAt:#'scroller.thumbFrameColor'.
    DefaultGhostColor := StyleSheet colorAt:#'scroller.ghostColor' default:nil.
    DefaultGhostFrameColor := StyleSheet colorAt:#'scroller.ghostFrameColor' default:nil.
    DefaultGhostLevel := StyleSheet at:#'scroller.ghostLevel' default:0.
    DefaultTallyMarks := StyleSheet at:#'scroller.NTallyMarks' default:0.

    DefaultTallyLevel := DefaultTallyInset := 0.
    DefaultTallyMarks ~~ 0 ifTrue:[
        DefaultTallyLevel := StyleSheet at:#'scroller.tallyLevel' default:1.
        DefaultTallyInset := StyleSheet at:#'scroller.tallyInset' default:0.
        DefaultTallyDistance := StyleSheet at:#'scroller.tallyDistance'.
    ].
    DefaultLevel := StyleSheet at:#'scroller.level' default:0.
    DefaultBorderWidth := StyleSheet at:#'scroller.borderWidth' default:(StyleSheet at:#'borderWidth').
    DefaultThumbLevel := StyleSheet at:#'scroller.thumbLevel' default:0.
    DefaultThumbActiveLevel := StyleSheet at:#'scroller.thumbActiveLevel' default:DefaultThumbLevel.
    DefaultInset := StyleSheet at:#'scroller.thumbInset' default:0.
    DefaultFixThumbHeight := StyleSheet at:#'scroller.thumbFixHeight' default:false.
    DefaultEdgeStyle := StyleSheet at:#'scroller.thumbEdgeStyle'.
    DefaultMiddleButtonJump := StyleSheet at:#'scroller.middleButtonJump' default:false.
    NewCursors := StyleSheet at:#'scroller.newCursors' default:true.
    DefaultThumbImage := StyleSheet at:#'scroller.thumbImage'.
    HandleImage := StyleSheet at:#'scroller.handleImage'.
    DefaultVerticalThumbFrameImage := StyleSheet at:#'scroller.verticalThumbFrameImage'.
    DefaultHorizontalThumbFrameImage := StyleSheet at:#'scroller.horizontalThumbFrameImage'.

    DefaultVScrollerWidth  := StyleSheet at:#'scroller.vScrollerWidth' default:nil.
    DefaultHScrollerHeight := StyleSheet at:#'scroller.hScrollerHeight' default:nil.

    StyleSheet fileReadFailed ifTrue:[
        DefaultViewBackground := Grey.
        DefaultThumbColor := Color white.
        DefaultThumbFrameColor := Color black.
        DefaultInset := 1.
    ].

    DefaultStopPagerAtThumb := StyleSheet at:#'scroller.stopPagerAtThumb' default:true.

    SnapBackDistance := StyleSheet at:#'scroller.snapBackDistance' default:30.
    MinThumbSize := StyleSheet at:#'scroller.minThumbSize' default:8.

    "
     self updateStyleCache
    "

    "Modified: / 28.4.1999 / 19:23:24 / cg"
! !

!Scroller methodsFor:'accessing'!

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
    "return the scrollers range min.
     (not used with Scrollers, but provided for subclasses)"

    ^ rangeStart
!

start:start
    "set the scrollers range min.
     (not used with Scrollers, but provided for subclasses)"

    self start:start stop:rangeEnd.

    "Modified: 25.5.1996 / 11:28:22 / cg"
!

start:start stop:stop
    "set the range.
     (not used with Scrollers, but provided for subclasses)"

    |org|

    org := self thumbOrigin.

    rangeStart := start.
    rangeEnd := stop.

    rangeStart = rangeEnd ifTrue:[
        self error:'invalid slider range (start = stop)' mayProceed:true.
        rangeEnd := rangeStart + (rangeStep ? 1).
    ].

    org < rangeStart ifTrue:[
        org := rangeStart
    ] ifFalse:[
        org > rangeEnd ifTrue:[
            org := rangeEnd
        ]
    ].
    self thumbOrigin:org.

    "Modified: / 21.1.1998 / 19:22:07 / cg"
!

start:start stop:stop step:step
    "set the range.
     (not used with Scrollers, but provided for subclasses)"

    self start:start stop:stop.
    rangeStep := step.

    "Created: 25.5.1996 / 11:24:09 / cg"
    "Modified: 25.5.1996 / 11:27:43 / cg"
!

step
    "return the scrollers range step.
     (not used with Scrollers, but provided for subclasses)"

    ^ rangeStep
!

step:step
    "set the scrollers range step.
     (not used with Scrollers, but provided for subclasses)"

    rangeStep := step
!

stop
    "return the scrollers range max.
     (not used with Scrollers, but provided for subclasses)"

    ^ rangeEnd
!

stop:stop
    "set the scrollers range max.
     (not used with Scrollers, but provided for subclasses)"

    self start:rangeStart stop:stop.

    "Modified: 25.5.1996 / 11:28:35 / cg"
!

thumbFrame
    "return the area used by the thumbFrame (in device coordinates).
     Allows access to the thumbs physical screen position, for
     example to position a label below (see Slider-Examples)"

    thumbFrame isNil ifTrue:[ self computeThumbFrame].
    ^ thumbFrame
!

thumbHeight
    "answer the thumbs height (in percent by default)"

    ^ thumbHeight * (rangeEnd - rangeStart) abs / 100

    "Modified: / 21.1.1998 / 19:25:33 / cg"
!

thumbHeight:aNumber 
    "set the thumbs height (in percent by default)"

    |newHeight realNewHeight oldFrame nBg|

    newHeight := aNumber / ((rangeEnd - rangeStart) abs / 100).

    (newHeight > 100) ifTrue:[
        realNewHeight := 100
    ] ifFalse:[
        realNewHeight := newHeight
    ].
    ((realNewHeight ~= thumbHeight) or:[thumbFrame isNil]) ifTrue:[
        thumbHeight := realNewHeight.

        (DefaultFullViewBackground notNil
        and:[DefaultViewBackground notNil
        and:[DefaultFullViewBackground ~~ DefaultViewBackground]]) ifTrue:[
            realNewHeight >= 100 ifTrue:[
                nBg := DefaultFullViewBackground.
            ] ifFalse:[
                nBg := DefaultViewBackground
            ].
            nBg := nBg onDevice:device.
            nBg ~~ viewBackground ifTrue:[
                self viewBackground:nBg.
                self invalidate.
            ]
        ].

        shown ifTrue:[
            oldFrame := thumbFrame.
            self computeThumbFrame.
            oldFrame ~= thumbFrame ifTrue:[
                self invalidate.
            ]
        ] ifFalse:[
            thumbFrame := nil.
            self invalidate.
        ].
    ]

    "Modified: / 21.10.1998 / 22:35:31 / cg"
!

thumbOrigin
    "answer the thumbs origin (in percent by default)"

    |org|

    org := thumbOrigin * (rangeEnd - rangeStart) / 100 + rangeStart.
    rangeStep notNil ifTrue:[
	org := org roundTo:rangeStep.
	rangeStep isInteger ifTrue:[
	    org := org asInteger
	]
    ].
    ^ org

    "Modified: / 21.1.1998 / 19:13:48 / cg"
!

thumbOrigin:aNumber 
    "set the thumbs origin (in percent by default)"

    |org newOrigin realNewOrigin 
     oldFrame oldTop oldBot oldLeft oldRight
     thumbTop thumbBot thumbLeft thumbRight
     tH "{ Class: SmallInteger }"
     tW "{ Class: SmallInteger }"
     delta needFullDraw 
     bgLeft bgTop bgWidth bgHeight|

    aNumber isNil ifTrue:[
        newOrigin := 0
    ] ifFalse:[
        org := aNumber.
        rangeStep notNil ifTrue:[
            org := org roundTo:rangeStep.
            rangeStep isInteger ifTrue:[
                org := org asInteger
            ]
        ].
        newOrigin := (org - rangeStart) asFloat / (rangeEnd - rangeStart / 100).
    ].

    ((newOrigin + thumbHeight) > 100) ifTrue:[
        realNewOrigin := 100 - thumbHeight
    ] ifFalse: [
        realNewOrigin := newOrigin
    ].
    (realNewOrigin > 100) ifTrue:[
        realNewOrigin := 100
    ] ifFalse: [
        (realNewOrigin < 0) ifTrue:[
            realNewOrigin := 0
        ]
    ].
    ((realNewOrigin ~= thumbOrigin) or:[thumbFrame isNil]) ifTrue:[
        thumbOrigin := realNewOrigin.

        shown ifTrue:[
            oldFrame := thumbFrame.
            self computeThumbFrame.
            (thumbHeight = 100) ifTrue:[
                "/ full: don't draw
                ^ self
            ].

            (thumbFrame ~= oldFrame) ifTrue:[
                oldFrame isNil ifTrue:[
                    self invalidate.
                    ^ self
                ].
                tH := thumbFrame height.
                tW := thumbFrame width.

                oldTop := oldFrame top.
                oldBot := oldTop + tH.
                oldLeft := oldFrame left.
                oldRight := oldLeft + tW.

                thumbTop := thumbFrame top.
                thumbBot := thumbTop + tH.
                thumbLeft := thumbFrame left.
                thumbRight := thumbLeft + tW.

                needFullDraw := self exposeEventPending
                                or:[((orientation == #vertical) and:[oldBot >= height])
                                or:[((orientation ~~ #vertical) and:[oldRight >= width])]].

                needFullDraw ifTrue:[
                    "
                     cannot copy since thumb was below the end
                     or may be not available for the copy
                    "
                    self invalidate.
                    ^ self
                ].

                self catchExpose.
                "
                 copy the thumbs pixels
                "
                (orientation == #vertical) ifTrue:[
                    self 
                        copyFrom:self 
                        x:thumbLeft y:oldTop
                        toX:thumbLeft y:thumbTop
                        width:tW height:tH
                        async:true.
                ] ifFalse:[
                    self 
                        copyFrom:self 
                        x:oldLeft y:thumbTop
                        toX:thumbLeft y:thumbTop
                        width:tW height:tH
                        async:true.
                ].

                "
                 clear some of the previous thumbs area to background
                "
                (orientation == #vertical) ifTrue:[
                    bgLeft := thumbLeft.
                    bgWidth := tW.
                    oldTop > thumbTop ifTrue:[
                        delta := oldTop - thumbTop.
                        oldTop > thumbBot ifTrue:[
                            bgTop := oldTop.
                            bgHeight := tH + 1
                        ] ifFalse:[
                            bgTop := thumbBot.
                            bgHeight := delta
                        ]
                    ] ifFalse:[
                        delta := thumbTop - oldTop.
                        oldBot < thumbTop ifTrue:[
                            bgTop := oldTop.
                            bgHeight := tH + 1
                        ] ifFalse:[
                            bgTop := oldTop.
                            bgHeight := delta
                        ]
                    ].
                ] ifFalse:[
                    bgTop := thumbTop.
                    bgHeight := tH.
                    oldLeft > thumbLeft ifTrue:[
                        delta := oldLeft - thumbLeft.
                        oldLeft > thumbRight ifTrue:[
                            bgLeft := oldLeft.
                            bgWidth := tW + 1.
                        ] ifFalse:[
                            bgLeft := thumbRight.
                            bgWidth := delta.
                        ]
                    ] ifFalse:[
                        delta := thumbLeft - oldLeft.
                        oldRight < thumbLeft ifTrue:[
                            bgLeft := oldLeft.
                            bgWidth := tW + 1.
                        ] ifFalse:[
                            bgLeft := oldLeft.
                            bgWidth := delta.
                        ]
                    ].
                ].
                self drawThumbBackgroundInX:bgLeft y:bgTop width:bgWidth height:bgHeight.
                self waitForExpose
            ]
        ] ifFalse:[
            thumbFrame := nil
        ]
    ]

    "Modified: / 4.5.1999 / 18:57:28 / cg"
!

thumbOrigin:originNumber thumbHeight:heightNumber
    "set both thumbs height and origin (in percent by default)"

    |newHeight newOrigin realNewOrigin realNewHeight old new changed 
     nBg range|

    range := rangeEnd - rangeStart.

    newOrigin := (originNumber - rangeStart) / (range / 100).
    newHeight := heightNumber / (range abs / 100).

    (newHeight > 100) ifTrue:[
        realNewHeight := 100
    ] ifFalse:[
        realNewHeight := newHeight
    ].
    ((newOrigin + realNewHeight) > 100) ifTrue:[
        realNewOrigin := 100 - realNewHeight
    ] ifFalse: [
        realNewOrigin := newOrigin
    ].
    (realNewOrigin < 0) ifTrue: [
        realNewOrigin := 0
    ].

    changed := (realNewHeight ~= thumbHeight) or:[realNewOrigin ~= thumbOrigin].
    (changed or:[thumbFrame isNil]) ifTrue:[
        old := self absFromPercent:thumbOrigin.
        new := self absFromPercent:realNewOrigin.
        changed := old ~~ new.
        changed ifFalse:[
            old := self absFromPercent:thumbHeight.
            new := self absFromPercent:realNewHeight.
            changed := (old ~~ new)
        ].
        (changed or:[thumbFrame isNil]) ifTrue:[
            thumbOrigin := realNewOrigin.
            thumbHeight := realNewHeight.

            (DefaultFullViewBackground notNil
            and:[DefaultViewBackground notNil
            and:[DefaultFullViewBackground ~~ DefaultViewBackground]]) ifTrue:[
                realNewHeight >= 100 ifTrue:[
                    nBg := DefaultFullViewBackground.
                ] ifFalse:[
                    nBg := DefaultViewBackground
                ].
                nBg := nBg onDevice:device.
                nBg ~~ viewBackground ifTrue:[
                    self viewBackground:nBg.
                ]
            ].

            thumbFrame := nil.
            self invalidate.
        ]
    ]

    "Modified: / 21.1.1998 / 19:32:41 / cg"
! !

!Scroller methodsFor:'accessing-behavior'!

action:aBlock
    "for protocol compatibility; same as scrollAction:"

    self scrollAction:aBlock
!

asynchronousOperation
    <resource:#obsolete>
    self obsoleteMethodWarning:'use #beAsynchronous'.
    self beAsynchronous
!

beAsynchronous
    "set scroll-mode to be asynchronous - scroll action is only performed after
     scrolling, when mouse-button is finally released (no tracking)."
     
    synchronousOperation := false
!

beSynchronous
    "set scroll-mode to be synchronous - scroll action is performed for 
     every movement of thumb (tracking)."
     
    synchronousOperation := true
!

enabled
    "return enable/disable state of the scoller"

    ^ enabled

    "Created: / 30.3.1999 / 15:24:50 / stefan"
!

enabled:aBoolean
    "enable/disable the scoller"

    enabled ~~ aBoolean ifTrue:[
	enabled := aBoolean.
	self updateBackground.
	aBoolean ifFalse:[
	    self cursor: Cursor normal
	]
    ]

    "Created: / 30.3.1999 / 15:23:14 / stefan"
!

isSynchronous
    "return true if the scroll-mode is synchronous.
     If true, the scroll action is performed for every movement of the thumb (tracking).
     If false, the scroll action is only performed at the end."

    ^ synchronousOperation
!

scrollAction
    "answer the scroll action block"

    ^ scrollAction
!

scrollAction:aBlock
    "set the scroll action, aBlock which is evaluated when scrolled"

    scrollAction := aBlock
!

scrollDownAction:aBlock
    "ignored -
     but implemented, so that scroller can be used in place of a scrollbar"
!

scrollLeftAction:aBlock
    "ignored -
     but implemented, so that scroller can be used in place of a scrollbar"
!

scrollRightAction:aBlock
    "ignored -
     but implemented, so that scroller can be used in place of a scrollbar"
!

scrollUpAction:aBlock
    "ignored -
     but implemented, so that scroller can be used in place of a scrollbar"
!

synchronousOperation
    <resource:#obsolete>
    self obsoleteMethodWarning:'use #beSynchronous'.
    self beSynchronous
! !

!Scroller methodsFor:'accessing-bg & border'!

allViewBackground:something if:condition
    "ignore here for all scrollers (I want my own background)"

    "/ ^ super allViewBackground:something
! !

!Scroller methodsFor:'accessing-look'!

is3D
    "return true, if I use a 3D style"

    <resource: #style (#name)>

    styleSheet name = #mswindows ifTrue:[^ true].
    ^ super is3D

    "Modified: 17.1.1997 / 23:21:42 / cg"
!

orientation 
    "return the scrollers orientation (#vertical or #horizontal)"

    ^ orientation
!

orientation:aSymbol 
    "set the scrollers orientation (#vertical or #horizontal)"

    |oldFrame|

    orientation := aSymbol.
    preferredExtent := nil.

    shown ifTrue:[
	oldFrame := thumbFrame.
	self computeThumbFrame.

	oldFrame ~= thumbFrame ifTrue:[
	    self invalidate.
	]
    ]

    "Created: 1.4.1997 / 12:18:32 / cg"
    "Modified: 1.4.1997 / 12:20:46 / cg"
!

thumb
    "for compatibility with scrollBars, return the receiver"

    ^ self

    "Created: 26.5.1996 / 12:21:12 / cg"
!

thumbColor
    "return the thumbs color"

    ^ thumbColor
!

thumbColor:aColor
    "change the color of the thumb"

    <resource: #style (#name)>

    |avgColor graphicsDevice|

    graphicsDevice := device.
    thumbColor := aColor onDevice:graphicsDevice.
    (styleSheet name ~~ #normal) ifTrue:[
        avgColor := aColor averageColorIn:(0@0 corner:7@7).
        thumbShadowColor := avgColor darkened onDevice:graphicsDevice.
        thumbLightColor := avgColor lightened onDevice:graphicsDevice.
        thumbHalfShadowColor := thumbShadowColor darkened onDevice:graphicsDevice.
        thumbHalfLightColor := thumbLightColor lightened onDevice:graphicsDevice.
    ].
    self invalidate

    "Modified: 8.2.1997 / 15:15:58 / cg"
! !

!Scroller methodsFor:'autoRepeat'!

installRepeat
    self installRepeat:repeatDelay.
!

installRepeat:repeatDelay
    |repeatBlockCopy|

    "protect against races"
    repeatBlockCopy := repeatBlock.
    repeatBlockCopy notNil ifTrue:[
        self repairDamage.
        Processor addTimedBlock:repeatBlockCopy afterSeconds:repeatDelay
    ]
!

pagedAbovePointer
    lastMousePosition notNil ifTrue:[
        orientation == #horizontal ifTrue:[
            ^ lastMousePosition x > thumbFrame center x 
        ] ifFalse:[
            ^ lastMousePosition y > thumbFrame center y 
        ].
    ].
    ^ false.
!

pagedBelowPointer
    lastMousePosition notNil ifTrue:[
        thumbFrame isNil ifTrue:[
            self computeThumbFrame.
            thumbFrame isNil ifTrue:[^ false].
        ].
        orientation == #horizontal ifTrue:[
            ^ lastMousePosition x < thumbFrame center x 
        ] ifFalse:[
            ^ lastMousePosition y < thumbFrame center y 
        ].
    ].
    ^ false.
!

repeatPageDown
    repeatBlock notNil ifTrue:[
        "stop scroll"
        (DefaultStopPagerAtThumb and:[self pagedBelowPointer]) ifTrue:[^ self].
        self repairDamage.
        self pageDown.
        self installRepeat.
    ]
!

repeatPageUp
    repeatBlock notNil ifTrue:[
        "stop scroll"
        (DefaultStopPagerAtThumb and:[self pagedAbovePointer]) ifTrue:[^ self].
        self repairDamage.
        self pageUp.
        self installRepeat.
    ]
! !

!Scroller methodsFor:'drawing'!

drawEdgedLineFrom:x1 y:y1 toX:x2 y:y2 level:lvl lightColor:lightColor shadowColor:shadowColor
    |color1 color2 x y dl|

    "iris style - draw tallys"

    lvl > 0 ifTrue:[
        color1 := lightColor.
        color2 := shadowColor.
    ] ifFalse:[
        color1 := shadowColor.
        color2 := lightColor.
    ].

    dl := 1.

    self paint:color1.
    x1 = x2 ifTrue:[
        "/ vertical
        gc displayLineFromX:x1 y:y1-dl toX:x2 y:y2-dl.
        gc paint:color2.
        x := x1 + 1.
        gc displayLineFromX:x y:y1 toX:x y:y2.
    ] ifFalse:[
        "/ horizontal
        gc displayLineFromX:x1-dl y:y1 toX:x2-dl y:y2.
        gc paint:color2.
        y := y1 + 1.
        gc displayLineFromX:x1 y:y toX:x2 y:y.
    ].
!

drawHandleFormAtX:x y:y
    "styles with a handle in the middle (NeXT) use this"

    thumbShadowColor := thumbShadowColor onDevice:device.

    gc paint:thumbShadowColor.
    gc displayForm:shadowForm x:x y:y.
    lightForm notNil ifTrue:[
        thumbLightColor := thumbLightColor onDevice:device.
        gc paint:thumbLightColor.
        gc displayForm:lightForm x:x y:y.
    ].

    "Modified: / 19.5.1998 / 16:26:49 / cg"
!

drawTallyMarks
    "draw the thumb"

    |color1 color2 
     lvl "{ Class: SmallInteger }"
     t "{ Class: SmallInteger }"
     l "{ Class: SmallInteger }"
     w "{ Class: SmallInteger }"
     h "{ Class: SmallInteger }"
     x "{ Class: SmallInteger }"
     y "{ Class: SmallInteger }"
     xL xR yT yB dist yTop yBot xLeft xRight
     light shadow|

    "iris style - draw tallys"

    lvl := thumbLevel.
    scrolling ifTrue:[
        lvl := thumbActiveLevel
    ].

    thumbFrame isNil ifTrue:[^ self].
    w := thumbFrame width.
    h := thumbFrame height.
    l := thumbFrame left.
    t := thumbFrame top.

    light := thumbLightColor.
    shadow := thumbShadowColor.
    (styleSheet at:#'scroller.vista3DStyle' default:false) "styleSheet name == #winVista" ifTrue:[
        light := (entered ifTrue:[thumbEnteredColor] ifFalse:[thumbColor]) lightened.
        shadow := (entered ifTrue:[thumbEnteredColor] ifFalse:[thumbColor]) darkened.
    ].

    tallyLevel > 0 ifTrue:[
        color1 := light.
        color2 := shadow.
    ] ifFalse:[
        color1 := shadow.
        color2 := light.
    ].

    "draw tally marks"

    (orientation == #vertical) ifTrue:[
        y := t + (h // 2) - 1.
        xL := l + lvl - 1 + DefaultTallyInset.
        xR := l + w - lvl + 1 - DefaultTallyInset.

        dist := DefaultTallyDistance ? device verticalPixelPerMillimeter rounded.

        tallyMarks even ifTrue:[
            yTop := y - (dist // 2).   
            yBot := y + (dist - (dist // 2)).
            self drawEdgedLineFrom:xL y:yTop toX:xR y:yTop level:tallyLevel lightColor:light shadowColor:shadow.
            self drawEdgedLineFrom:xL y:yBot toX:xR y:yBot level:tallyLevel lightColor:light shadowColor:shadow.
        ] ifFalse:[
            self drawEdgedLineFrom:xL y:y toX:xR y:y level:tallyLevel lightColor:light shadowColor:shadow.
            yTop := yBot := y.   
        ].

        tallyMarks > 1 ifTrue:[
            "don't draw other marks if there is not enough space"

            h > (dist * (tallyMarks * 2)) ifTrue:[
                self drawEdgedLineFrom:xL y:(yTop - dist) toX:xR y:(yTop - dist) level:tallyLevel lightColor:light shadowColor:shadow.
                self drawEdgedLineFrom:xL y:(yBot + dist) toX:xR y:(yBot + dist) level:tallyLevel lightColor:light shadowColor:shadow.
            ]
        ]
    ] ifFalse:[
        x := l + (w // 2) - 1.
        yT := t + lvl - 1 + DefaultTallyInset.
        yB := t + h - lvl + 1 - DefaultTallyInset.

        dist := DefaultTallyDistance ? device horizontalPixelPerMillimeter rounded.

        tallyMarks even ifTrue:[
            xLeft := x - (dist // 2).   
            xRight := x + (dist - (dist // 2)).
            self drawEdgedLineFrom:xLeft y:yT toX:xLeft y:yB level:tallyLevel lightColor:light shadowColor:shadow.
            self drawEdgedLineFrom:xRight y:yT toX:xRight y:yB level:tallyLevel lightColor:light shadowColor:shadow.
        ] ifFalse:[
            self drawEdgedLineFrom:x y:yT toX:x y:yB level:tallyLevel lightColor:light shadowColor:shadow.
            xLeft := xRight := x.   
        ].
        tallyMarks > 1 ifTrue:[
            "don't draw other marks if there is not enough space"

            w > (dist * (tallyMarks * 2)) ifTrue:[
                self drawEdgedLineFrom:(xLeft - dist) y:yT toX:(xLeft - dist) y:yB level:tallyLevel lightColor:light shadowColor:shadow.
                self drawEdgedLineFrom:(xRight + dist) y:yT toX:(xRight + dist) y:yB level:tallyLevel lightColor:light shadowColor:shadow.
            ]
        ]
    ]

    "Modified: / 29.4.1999 / 09:35:52 / cg"
!

drawThumb
    "draw the thumb"

    |handleX handleY l t lvl
     w "{ Class: SmallInteger }"
     h "{ Class: SmallInteger }"
     clr clr2 styleName xpStyle vistaStyle n frameImageOrNil frameImage|

    (thumbHeight >= 100) ifTrue:[^ self].
    thumbFrame isNil ifTrue:[^ self].

    styleName := styleSheet name.
    xpStyle := styleName == #winXP.
    vistaStyle := styleSheet at:#'scroller.vista3DStyle' default:false. "/ styleName == #winVista.

    w := thumbFrame width.
    h := thumbFrame height.
    l := thumbFrame left.
    t := thumbFrame top.

    (scrolling and:[thumbActiveColor notNil]) ifTrue:[
        clr := thumbActiveColor
    ] ifFalse:[
        clr := entered 
            ifTrue:[thumbEnteredColor] 
            ifFalse:[thumbColor].
    ].

    clr notNil ifTrue:[
        (styleSheet at:#'scroller.vista3DStyle' default:false) ifTrue:[
            "/ color gradient drawing
            "/ with colors rougly smilar to the vista colors, which are:
            "/ 243 242 240 236 234 233 215 211 207 205 200 192 206
            clr2 := styleSheet colorAt:#'scroller.vista3DStyleLightColor' default:self whiteColor.
            
            (orientation == #vertical) ifTrue:[
                n := w
            ] ifFalse:[
                n := h
            ].
            1 to:n-1 do:[:i |
                |m|

                i == (n-1) ifTrue:[
                    m := 0.4.
                ] ifFalse:[
                    i <= (n//2) ifTrue:[
                        i <= (n//4) ifTrue:[
                            m := 3.
                        ] ifFalse:[
                            i <= (n//3) ifTrue:[
                                m := 2.5.
                            ] ifFalse:[
                                m := 2.
                            ].
                        ].
                    ] ifFalse:[
                        i > (n*3//4) ifTrue:[
                            i > (n*4//5) ifTrue:[
                                m := 0.
                            ] ifFalse:[
                                m := 0.2.
                            ]
                        ] ifFalse:[
                            i > (n*2//3) ifTrue:[
                                m := 0.4
                            ] ifFalse:[
                                m := 0.8.
                            ].
                        ].
                    ].
                ].
                gc paint:(clr2 mixed:m with:clr).
                (orientation == #vertical) ifTrue:[
                    gc displayLineFromX:(l+i-1) y:t+1 toX:(l+i-1) y:(t+h-2)
                ] ifFalse:[
                    gc displayLineFromX:(l+1) y:(t+i-1) toX:(l+w-2) y:(t+i-1)
                ].
            ].
        ] ifFalse:[
            gc paint:clr.
            (xpStyle and:[self isMiniScroller not]) ifTrue:[
                "/ hack for xp
                (orientation == #vertical) ifTrue:[
                    gc fillRectangleX:l y:t+1 width:w-2 height:h-4.
                ] ifFalse:[
                    gc fillRectangleX:l+1 y:t width:w-4 height:h-2.
                ]
            ] ifFalse:[
                (styleSheet at:#'scroller.roundStyle' default:false) ifTrue:[
                    "/ hack for osx
                    (orientation == #vertical) ifTrue:[
                        1 to:3 do:[:i |
                            |yLine left right|

                            left := l+i-1.
                            right := l+w-i+1.
                            yLine := t+3-i.
                            gc displayLineFromX:left y:yLine toX:right y:yLine.    
                            yLine := t+h-3-1+i. 
                            gc displayLineFromX:left y:yLine toX:right y:yLine.    
                        ].
                        gc fillRectangleX:l y:t+3 width:w height:h-6.
                    ] ifFalse:[
                        1 to:3 do:[:i |
                            |xLine top bot|

                            top := t+i-1.
                            bot := t+h-i+1.
                            xLine := l+3-i.
                            gc displayLineFromX:xLine y:top toX:xLine y:bot.    
                            xLine := l+w-3-1+i. 
                            gc displayLineFromX:xLine y:top toX:xLine y:bot.    
                        ].
                        gc fillRectangleX:l+3 y:t width:w-6 height:h.
                    ].
                ] ifFalse:[
                    gc fillRectangleX:l y:t width:w height:h.
                ].
            ].
        ].
    ].
    lvl := thumbLevel.
    scrolling ifTrue:[
        lvl := thumbActiveLevel
    ].

    lvl ~~ 0 ifTrue:[
        self drawEdgesForX:l y:t width:w height:h level:lvl
                    shadow:thumbShadowColor light:thumbLightColor
                    halfShadow:thumbHalfShadowColor halfLight:thumbHalfLightColor
                    style:thumbEdgeStyle.
    ].
    frameImageOrNil := (orientation == #vertical) 
                        ifTrue:[ DefaultVerticalThumbFrameImage ]
                        ifFalse:[ DefaultHorizontalThumbFrameImage ].
    frameImageOrNil notNil ifTrue:[
        frameImage  := frameImageOrNil magnifiedTo:(w @ h).
        frameImage displayOn:self x:l y:t
    ].

    self isMiniScroller ifTrue:[^ self].

    thumbFrameColor notNil ifTrue:[
        clr2 := styleSheet colorAt:#'scroller.thumbFrameColor2'.
        clr2 notNil ifTrue:[
            gc paint:clr2.
            (orientation == #vertical) ifTrue:[
                gc displayLineFromX:l+w-2 y:t+1 toX:l+w-2 y:t+h-3.
                gc displayLineFromX:l y:t+h-3 toX:l+w-2 y:t+h-3.
            ] ifFalse:[
                gc displayLineFromX:l+2 y:t+h-2 toX:l+w-3 y:t+h-2.
                gc displayLineFromX:l+w-3 y:t toX:l+w-3 y:t+h-2. 
            ].
        ].

        vistaStyle ifTrue:[
            gc paint:clr slightlyDarkened.
        ] ifFalse:[
            gc paint:thumbFrameColor.
        ].
        xpStyle ifTrue:[
            (orientation == #vertical) ifTrue:[
                gc displayLineFromX:l+w-1 y:t+1 toX:l+w-1 y:t+h-3.
                gc displayLineFromX:l+1 y:t+h-2 toX:l+w-2 y:t+h-2.
                gc displayLineFromX:l+w-2 y:t+h-3 toX:l+w-2 y:t+h-3.
                "/ self displayLineFromX:l-2 y:t+h-3 toX:l-2 y:t+h-3.
            ] ifFalse:[
                gc displayLineFromX:l+2 y:t+h-1 toX:l+w-3 y:t+h-1.
                gc displayLineFromX:l+w-2 y:t+1 toX:l+w-2 y:t+h-2. 
                gc displayLineFromX:l+w-3 y:t+h-2 toX:l+w-3 y:t+h-2.
            ].
        ] ifFalse:[
            h := h - 1.
            gc displayRectangleX:l y:t width:w height:h.
        ].
        vistaStyle ifTrue:[
            gc paint:clr lightened.
            gc displayPointX:l y:t.
            gc displayPointX:l+w-1 y:t.
            gc displayPointX:l y:t+h-1.
            gc displayPointX:l+w-1 y:t+h-1.
        ].
    ].

    thumbImage notNil ifTrue:[
        thumbImage displayOn:self x:l y:t
    ].

    (false "tallyLevel == 0" or:[tallyMarks == 0]) ifTrue:[
        shadowForm notNil ifTrue:[
            "next style - draw tally bitmap"
            handleX := l + ((w - 8) // 2).
            handleY := t + ((h - 8) // 2).
            self drawHandleFormAtX:handleX y:handleY
        ].
        ^ self
    ].

    "iris style - draw tallys"
    self drawTallyMarks.

    "Modified: / 29-11-2011 / 11:55:24 / cg"
!

drawThumbBackgroundInX:x y:y width:w height:h
    "draw part of the thumbs background; defined as a separate
     method, to allow drawing of arbitrary patterns under thumb 
     (see ColorSlider)."

    |oldClip gX gY gW gH|

    shown ifTrue:[
        oldClip := self clippingBoundsOrNil.
        self clippingBounds:(Rectangle left:x top:y width:w height:h).
        gc clearDeviceRectangleX:x y:y width:w height:h.

        styleSheet name == #winVista ifTrue:[
            gc paint:(Color greyByte:16rE3).
            (orientation == #vertical) ifTrue:[
                gc displayLineFromX:0 y:0 toX:0 y:height-1.
                gc displayLineFromX:1 y:0 toX:1 y:height-1.
            ] ifFalse:[
                gc displayLineFromX:0 y:0 toX:width-1 y:0.
                gc displayLineFromX:0 y:1 toX:width-1 y:1.
            ].
        ].

        frameBeforeMove notNil ifTrue:[
            (ghostColor notNil 
            or:[ghostFrameColor notNil
            or:[ghostLevel ~~ 0]]) ifTrue:[
                (frameBeforeMove intersects:(x@y extent:w@h)) ifTrue:[
                    gX := frameBeforeMove left.
                    gY := frameBeforeMove top.
                    gW := frameBeforeMove width.
                    gH := frameBeforeMove height.
                
                    ghostColor notNil ifTrue:[
                        gc paint:ghostColor.
                        gc fillRectangle:frameBeforeMove.
                    ].
                    (ghostLevel ~~ 0) ifTrue:[
                        self drawEdgesForX:gX y:gY width:gW height:gH level:ghostLevel
                    ].
                    ghostFrameColor notNil ifTrue:[
                        gc paint:ghostFrameColor.
                        gc displayRectangleX:gX y:gY width:gW height:gH
                    ].
                ]
            ]
        ].
        self clippingBounds:oldClip
    ]

    "Modified: / 4.5.1999 / 18:51:53 / cg"
! !

!Scroller methodsFor:'event handling'!

buttonControlPress:button x:x y:y
    "mouse-click with control - jump to top/bottom"

    |curr limit1 limit2|

    thumbFrame isNil ifTrue:[
        self computeThumbFrame.
        thumbFrame isNil ifTrue:[
            ^ self.
        ]
    ].
    (orientation == #vertical) ifTrue:[
        curr := y.
        limit1 := thumbFrame top.
        limit2 := thumbFrame bottom
    ] ifFalse:[
        curr := x.
        limit1 := thumbFrame left.
        limit2 := thumbFrame right
    ].

    (curr < limit1) ifTrue:[
        "to top"
        self thumbOrigin:0.
        self tellOthers
    ] ifFalse:[
        (curr > limit2) ifTrue:[
            "to bottom"
            self thumbOrigin:100.
            self tellOthers
        ]
    ].
!

buttonMotion:state x:x y:y
    "mouse-button was moved while pressed;
     redraw thumb at its new position and, if scroll-mode is asynchronous, 
     the scroll action is performed"

    <resource: #style (#name 
                       #'scroller.snapBack')>

    |pos curr limit prevOrigin newOrigin snap|

    lastMousePosition := x@y.

    (self sensor hasButtonMotionEventFor:self) ifTrue:[
        ^ self.
    ].

    enabled ifFalse:[^ self].

    scrolling ifFalse: [
        thumbFrame notNil ifTrue:[
            self highlightThumbForPointerX:x y:y.
        ].
        ^ self              
    ].              

    entered := true.
    frameBeforeMove isNil ifTrue:[
        self startMove.
    ].

    (orientation == #vertical) ifTrue:[
        curr := y.
        limit := height.
        snap := (x < SnapBackDistance negated) or:[x > (width + SnapBackDistance)].
    ] ifFalse:[
        curr := x.
        limit := width.
        snap := (y < SnapBackDistance negated) or:[y > (height + SnapBackDistance)].
    ].

    (curr < 0) ifTrue:[                        "check against limits"
        pos := 0
    ] ifFalse:[
        (curr > limit) ifTrue:[
            pos := limit
        ] ifFalse:[
            pos := curr
        ]
    ].

    prevOrigin := self thumbOrigin.
    newOrigin := self percentFromAbs:(pos - pressOffset).

    snap ifTrue:[
        (styleSheet at:#'scroller.snapBack' default:false) ifTrue:[
            newOrigin := originBeforeMove.
        ]
    ].

    prevOrigin ~= newOrigin ifTrue:[
        self thumbOrigin:newOrigin.

        synchronousOperation ifTrue: [
            self tellOthers.
        ]
    ]

    "Modified: / 14.4.1998 / 18:37:34 / cg"
!

buttonPress:button x:x y:y
    "button was pressed - if above thumb, page up; if below thumb, page down;
     otherwise start scrolling.
     If either shift is pressed, or the 'scrollerMiddleButtonJump' styleSheet
     value is true and its the middle button, do a jump to the clicked position."

    |curr limit1 limit2 sensor|

    enabled ifFalse:[^ self].
    shown ifFalse:[^ self].
    scrolling ifTrue:[^ self].

    sensor := self sensor.
    (sensor shiftDown
     or:[DefaultMiddleButtonJump and:[button ~~ 1]]) ifTrue:[
        ^ self buttonShiftPress:button x:x y:y
    ].
    sensor ctrlDown ifTrue:[
        ^ self buttonControlPress:button x:x y:y
    ].
    (button ~~ #select and:[button ~~ 1]) ifTrue:[
        ^ self
    ].

    thumbFrame isNil ifTrue:[
        self computeThumbFrame.
        thumbFrame isNil ifTrue:[^ self].
    ].

    (orientation == #vertical) ifTrue:[
        curr := y.
        limit1 := thumbFrame top.
        limit2 := thumbFrame bottom
    ] ifFalse:[
        curr := x.
        limit1 := thumbFrame left.
        limit2 := thumbFrame right
    ].

    self highlightThumbForPointerX:x y:y.
    self changeCursorFor:(x@y).

    (curr < limit1) ifTrue:[
        "page up/left"
        self pageUp.
        autoRepeat ifTrue:[
            repeatBlock notNil ifTrue:[
                Processor removeTimedBlock:repeatBlock.
            ].
            repeatBlock := [self sensor pushUserEvent:#repeatPageUp for:self].
            sensor pushUserEvent:#installRepeat: for:self withArgument:initialRepeatDelay.
        ]
    ] ifFalse:[
        (curr > limit2) ifTrue:[
            "page down/right"
            self pageDown.
            autoRepeat ifTrue:[
                repeatBlock notNil ifTrue:[
                    Processor removeTimedBlock:repeatBlock.
                ].
                repeatBlock := [self sensor pushUserEvent:#repeatPageDown for:self].
                sensor pushUserEvent:#installRepeat: for:self withArgument:initialRepeatDelay.
            ]
        ] ifFalse:[
            pressOffset := curr - limit1.
            scrolling := true.
            (thumbActiveColor notNil and:[thumbColor ~~ thumbActiveColor]) ifTrue:[
                self drawThumb
            ]
        ]
    ].

    "Modified: / 02-02-1998 / 23:30:26 / stefan"
    "Modified: / 15-12-2010 / 10:13:10 / cg"
!

buttonRelease:button x:x y:y
    "mouse-button was released - if scroll-mode is asynchronous, the scroll
     action is now performed"

    |rect mustDrawThumb|

    lastMousePosition := nil.

    repeatBlock notNil ifTrue:[
        repeatBlock := nil.
        Processor removeTimedBlock:repeatBlock.
        repeatBlock := nil
    ].

    (button == 1 or:[DefaultMiddleButtonJump])
    ifFalse:[
        ^ super buttonRelease:button x:x y:y
    ].

    scrolling ifTrue:[
        scrolling := false.
        thumbFrame notNil ifTrue:[
            mustDrawThumb := false.

            frameBeforeMove notNil ifTrue:[
                rect := frameBeforeMove.
                frameBeforeMove := nil.
                self drawThumbBackgroundInX:rect left
                                          y:rect top
                                      width:rect width 
                                     height:rect height.

                (rect intersects:thumbFrame) ifTrue:[
                    mustDrawThumb := true.
                ]
            ].
            thumbLevel ~~ thumbActiveLevel ifTrue:[
                mustDrawThumb := true
            ].
            (thumbActiveColor notNil and:[thumbColor ~~ thumbActiveColor]) ifTrue:[
                mustDrawThumb := true
            ].
            mustDrawThumb ifTrue:[
                self drawThumb
            ].    

"/            scrolling := false.
            synchronousOperation ifFalse: [
                self tellOthers.
            ]
        ]
    ].
    self changeCursorFor:(x@y)

    "Modified: / 19.1.1998 / 13:45:59 / cg"
    "Modified: / 2.2.1998 / 23:37:27 / stefan"
!

buttonShiftPress:button x:x y:y
    "mouse-click with shift - jump to position"

    |pos curr curr2 limit1 limit2|

    thumbFrame isNil ifTrue:[
        self computeThumbFrame.
        thumbFrame isNil ifTrue:[
            ^ self.
        ]
    ].
    (orientation == #vertical) ifTrue:[
        curr := y.
        curr2 := y - (thumbFrame height // 2).
        limit1 := height.
        limit2 := thumbFrame top
    ] ifFalse:[
        curr := x.
        curr2 := x - (thumbFrame width // 2).
        limit1 := width.
        limit2 := thumbFrame left
    ].

    (curr2 < 0) ifTrue:[                        "check against limits"
        pos := 0
    ] ifFalse:[
        (curr2 > limit1) ifTrue:[
            pos := limit1
        ] ifFalse:[
            pos := curr2
        ]
    ].

    self startMove.

    self thumbOrigin:(self percentFromAbs:pos).
    self tellOthers.

    (orientation == #vertical) ifTrue:[
        limit2 := thumbFrame top
    ] ifFalse:[
        limit2 := thumbFrame left
    ].
    pressOffset := curr - limit2.
    scrolling := true.

    self changeCursorFor:(x@y).


    "Modified: / 19.3.1997 / 11:29:08 / cg"
    "Modified: / 2.2.1998 / 23:35:18 / stefan"
!

changeCursorFor:p
    "update the mouse cursor"

    |frm sensor which|

    enabled ifFalse:[
        self cursor:Cursor normal.
        ^ self
    ].
    NewCursors ifFalse:[^ self].

    frm := self thumbFrame.
    frm isNil ifTrue:[^ self].

    thumbHeight = 100 ifTrue:[
        which := #normal.
    ] ifFalse:[
        sensor := self sensor.

        (((frm containsPoint:p) and:[sensor leftButtonPressed])
         "or:[sensor shiftDown]") ifTrue:[ 
            orientation == #horizontal ifTrue:[
                which := #xMarker
            ] ifFalse:[
                which := #marker
            ].
        ] ifFalse:[
            orientation == #horizontal ifTrue:[
                p x > frm right ifTrue:[
                    which := #right
                ] ifFalse:[
                    p x < frm left ifTrue:[
                        which := #left
                    ] ifFalse:[
                        which := #hand
                    ]
                ]
            ] ifFalse:[
                p y > frm bottom ifTrue:[
                    which := #down
                ] ifFalse:[
                    p y < frm top ifTrue:[
                        which := #up
                    ] ifFalse:[
                        which := #hand
                    ]
                ]
            ]
        ]
    ].
    self cursor:(Cursor perform:which).

    "Created: / 23.10.1997 / 03:55:24 / cg"
    "Modified: / 7.5.1998 / 02:06:10 / cg"
!

highlightThumbForPointerX:x y:y
    "if x/y is within the thumb frame, highlight it"

    |frm in|

    in := (frm := self thumbFrame) containsPoint:(x@y).
    (in ~~ entered 
    or:[thumbLevel ~~ thumbActiveLevel]) ifTrue:[
        entered := in.
        (thumbColor ~~ thumbEnteredColor 
        or:[thumbLevel ~~ thumbActiveLevel]) ifTrue: [
            self drawThumb
        ].
    ].

    self changeCursorFor:(x@y)

    "Created: 6.3.1996 / 17:35:07 / cg"
    "Modified: 23.10.1997 / 03:56:31 / cg"
!

keyPress:key x:x y:y
    "/ stupid - due to delegation, this is never invoked ...
    enabled ifFalse:[^ self].

    self changeCursorFor:(x@y).
    super keyPress:key x:x y:y

    "Created: 23.10.1997 / 03:57:34 / cg"
!

keyRelease:key x:x y:y
    "/ stupid - due to delegation, this is never invoked ...
    self changeCursorFor:(x@y).
    super keyRelease:key x:x y:y

    "Created: 23.10.1997 / 03:58:25 / cg"
!

pointerEnter:state x:x y:y
    "mouse-button left view
     redraw thumb if enteredColor ~~ thumbColor"

    scrolling ifTrue:[
        (state bitAnd:(device anyButtonMotionMask)) == 0 ifTrue: [
            self buttonRelease:1 x:x y:y
        ].
    ].
    super pointerEnter:state x:x y:y

    "Modified: / 14.10.1998 / 15:40:51 / cg"
!

pointerLeave:state
    "mouse-button left view
     redraw thumb if enteredColor ~~ thumbColor"

    (entered and:[(state bitAnd:(device anyButtonMotionMask)) == 0]) ifTrue: [
        entered := false.
        thumbEnteredColor ~= thumbColor ifTrue:[
            self invalidate.
            "/ self drawThumb
        ]
    ].

    "Created: / 6.3.1996 / 17:31:16 / cg"
    "Modified: / 11.9.1998 / 00:13:53 / cg"
!

redraw
    "redraw"

    self redrawX:0 y:0 width:width height:height.
    self redrawEdges
!

redrawX:x y:y width:w height:h
    shown ifFalse:[
        ^ self.
    ].

    thumbFrame isNil ifTrue:[
        self computeThumbFrame
    ].
    self drawThumbBackgroundInX:x y:y width:w height:h.
    thumbFrame isNil ifTrue:[
        "/ thumb hidden
        ^ self 
    ].

    orientation == #vertical ifTrue:[
        (y > thumbFrame bottom) ifTrue:[
            ^ self
        ].
        ((y + h) < thumbFrame top) ifTrue:[
            ^ self
        ].
    ] ifFalse:[
        (x > thumbFrame right) ifTrue:[
            ^ self
        ].
        ((x + w) < thumbFrame left) ifTrue:[
            ^ self
        ].
    ].

    self drawThumb

    "Modified: / 29.10.1997 / 15:48:48 / cg"
!

sizeChanged:how
    "size of scroller changed - recompute thumbs frame and redraw it"

    |oldThumbFrame oldTop oldBot newTop newBot oldLeft oldRight newLeft newRight|

    super sizeChanged:how.

    oldThumbFrame := thumbFrame.
    thumbFrame := nil.
    shown ifFalse:[
        thumbFrame := nil.
        self invalidate.
        ^ self.
    ].
    self computeThumbFrame.

    "/ any change ?
    thumbFrame = oldThumbFrame ifTrue:[
        ^ self
    ].
    thumbFrame isNil ifTrue:[
        self invalidate.
        ^ self
    ].
    oldThumbFrame isNil ifTrue:[
        self invalidate:thumbFrame.
        ^ self.
    ].

    "/ try to redraw as little as possible

    oldTop := oldThumbFrame top.
    oldBot := oldThumbFrame bottom.
    newTop := thumbFrame top.
    newBot := thumbFrame bottom.
    oldLeft := oldThumbFrame left.
    oldRight := oldThumbFrame right.
    newLeft := thumbFrame left.
    newRight := thumbFrame right.

    (orientation == #vertical
    and:[oldLeft == newLeft
    and:[oldRight == newRight]]) ifTrue:[
        (oldTop == newTop) ifTrue:[
            oldBot < newBot ifTrue:[
                "/ thumb became larger, but origin remains
                "/ (view became smaller)
                self invalidate:(Rectangle 
                                    left:newLeft top:oldBot-thumbLevel
                                    right:newRight bottom:newBot).
                ^ self.
            ].
            oldBot > newBot ifTrue:[
                "/ thumb became smaller, but origin remains
                "/ (view became larger)
                self invalidate:(Rectangle 
                                    left:newLeft top:newBot-thumbLevel
                                    right:newRight bottom:oldBot).
                ^ self.
            ].
        ].
        (oldBot == newBot) ifTrue:[
            newTop < oldTop ifTrue:[
                "/ thumb became larger, but corner remains
                "/ (view became smaller)
                self invalidate:(Rectangle 
                                    left:newLeft top:newTop
                                    right:newRight bottom:oldTop+thumbLevel).
                ^ self.
            ].
            newTop > oldTop ifTrue:[
                "/ thumb became smaller, but corner remains
                "/ (view became larger)
                self invalidate:(Rectangle 
                                    left:newLeft top:oldTop
                                    right:newRight bottom:newTop+thumbLevel).
                ^ self.
            ]
        ].
    ].

    (orientation == #horizontal
    and:[oldTop == newTop
    and:[oldBot == newBot]]) ifTrue:[
        (oldLeft == newLeft) ifTrue:[
            oldRight < newRight ifTrue:[
                "/ thumb became larger, but origin remains
                "/ (view became smaller)
                self invalidate:(Rectangle 
                                    left:oldRight-thumbLevel top:newTop
                                    right:newRight bottom:newBot).
                ^ self.
            ].
            oldRight > newRight ifTrue:[
                "/ thumb became smaller, but origin remains
                "/ (view became larger)
                self invalidate:(Rectangle 
                                    left:newRight-thumbLevel top:newTop
                                    right:oldRight bottom:newBot).
                ^ self.
            ].
        ].
    ].

    self invalidate:(oldThumbFrame merge: thumbFrame).

    "Modified: / 23.5.1999 / 13:50:41 / cg"
!

update:something with:aParameter from:changedObject
    "handle update from a model (if any)"

    (changedObject == model 
    "and:[something == aspectMsg]") ifTrue:[
        self thumbOrigin:(model value).
        "/ self tellOthers.
        ^ self
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 30.3.1999 / 14:26:28 / stefan"
! !

!Scroller methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "no, do not catch the keyboard focus on button click"

    ^ false


! !

!Scroller methodsFor:'forced scroll'!

pageDown
    "page down/right"

    self thumbOrigin:(thumbOrigin + thumbHeight).
    self tellOthers
!

pageUp
    "page up/left"

    self thumbOrigin:(thumbOrigin - thumbHeight).
    self tellOthers
!

scrollDown:amountToScroll
    "compatibility with SimpleView. This allows mouse wheel actions on Scrollers
     Note: this is used for horizontal scrollers, too (scrollRight)"

    self scrollStep:amountToScroll
!

scrollStep:delta
    "step by some delta"

    |oldOrg newOrg|

    oldOrg := self thumbOrigin.
    newOrg := ((oldOrg + delta) max:rangeStart) min:rangeEnd.
    oldOrg ~= newOrg ifTrue:[
	self thumbOrigin:newOrg.
	self tellOthers.
    ]

    "Created: / 21.4.1998 / 20:51:57 / cg"
    "Modified: / 21.4.1998 / 20:52:22 / cg"
!

scrollToBeginning
    "scroll to the beginning"

    self thumbOrigin:rangeStart.
    self tellOthers

    "Created: 6.3.1996 / 17:55:13 / cg"
!

scrollToEnd
    "scroll to the end"

    self thumbOrigin:rangeEnd.
    self tellOthers

    "Created: 6.3.1996 / 17:55:25 / cg"
!

scrollUp:amountToScroll
    "compatibility with SimpleView. This allows mouse wheel actions on Scrollers
     Note: this is used for horizontal scrollers, too (scrollLeft)"

    self scrollStep:amountToScroll negated
! !

!Scroller methodsFor:'forwarding changed origin'!

tellOthers
    |org|

    org := self thumbOrigin.

    "
     the ST-80 way of notifying scrolls
    "
    self sendChangeMessageWith:org.

    "
     the ST/X way of notifying scrolls
    "
    scrollAction notNil ifTrue:[
        scrollAction value:org 
    ].

    "/
    "/ this will vanish - the scroller should share
    "/ a valueHolder with the scrolledView.
    "/
    dependents notNil ifTrue:[ self changed:#scrollerPosition ].

    "Modified: / 21.1.1998 / 19:12:55 / cg"
! !

!Scroller methodsFor:'initialization'!

defaultExtent
    "compute my extent from sub-components"

    ^ self preferredExtent

    "Modified: 22.4.1996 / 23:37:53 / cg"
!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    |graphicsDevice|

    super fetchDeviceResources.
    graphicsDevice := device.

    thumbShadowColor notNil ifTrue:[thumbShadowColor := thumbShadowColor onDevice:graphicsDevice].
    thumbLightColor notNil ifTrue:[thumbLightColor := thumbLightColor onDevice:graphicsDevice].
    thumbHalfShadowColor notNil ifTrue:[thumbHalfShadowColor := thumbHalfShadowColor onDevice:graphicsDevice].
    thumbHalfLightColor notNil ifTrue:[thumbHalfLightColor := thumbHalfLightColor onDevice:graphicsDevice].

    thumbEnteredColor notNil ifTrue:[thumbEnteredColor := thumbEnteredColor onDevice:graphicsDevice].
    ghostColor notNil ifTrue:[ghostColor := ghostColor onDevice:graphicsDevice].
    ghostFrameColor notNil ifTrue:[ghostFrameColor := ghostFrameColor onDevice:graphicsDevice].

    "Modified: 13.1.1997 / 21:56:38 / cg"
!

initCursor
    "set the cursor - a hand"

    cursor := Cursor hand
!

initStyle
    "initialize style dep. stuff"

    <resource: #style (#name 
                       #'scroller.autoRepeat'
                       #'scroller.initialRepeatDelay'
                       #'scroller.repeatDelay')>

    |nm graphicsDevice|

    super initStyle.
    graphicsDevice := device.

    DefaultViewBackground notNil ifTrue:[
        viewBackground := DefaultViewBackground onDevice:graphicsDevice.
    ].
    DefaultShadowColor notNil ifTrue:[
        shadowColor := DefaultShadowColor onDevice:graphicsDevice.
    ].
    DefaultLightColor notNil ifTrue:[
        lightColor := DefaultLightColor onDevice:graphicsDevice.
    ].

    tallyMarks := DefaultTallyMarks.
    tallyLevel := DefaultTallyLevel.
    DefaultLevel ~~ level ifTrue:[
        self level:DefaultLevel.
    ].
    DefaultBorderWidth ~~ self borderWidth ifTrue:[
        self borderWidth:DefaultBorderWidth.
    ].
    thumbLevel := DefaultThumbLevel.
    thumbActiveLevel := DefaultThumbActiveLevel.
    thumbActiveColor := DefaultThumbActiveColor.
    inset := DefaultInset.
    fixThumbHeight := DefaultFixThumbHeight.
    thumbEdgeStyle := DefaultEdgeStyle.

    DefaultGhostColor notNil ifTrue:[
        ghostColor := DefaultGhostColor onDevice:graphicsDevice.
    ].
    DefaultGhostFrameColor notNil ifTrue:[
        ghostFrameColor := DefaultGhostFrameColor onDevice:graphicsDevice.
    ].
    ghostLevel := DefaultGhostLevel.

    DefaultThumbFrameColor notNil ifTrue:[
        thumbFrameColor := DefaultThumbFrameColor onDevice:graphicsDevice.
    ].
    DefaultThumbShadowColor notNil ifTrue:[
        thumbShadowColor := DefaultThumbShadowColor
    ] ifFalse:[
        thumbShadowColor := shadowColor.
    ].
    DefaultThumbLightColor notNil ifTrue:[
        thumbLightColor := DefaultThumbLightColor
    ] ifFalse:[
        thumbLightColor := lightColor.
    ].

    thumbEdgeStyle notNil ifTrue:[
        DefaultThumbHalfShadowColor notNil ifTrue:[
            thumbHalfShadowColor := DefaultThumbHalfShadowColor
        ].

        DefaultThumbHalfLightColor notNil ifTrue:[
            thumbHalfLightColor := DefaultThumbHalfLightColor
        ].
    ].

    nm := styleSheet name.

    graphicsDevice hasGrayscales ifFalse:[
        thumbEdgeStyle notNil ifTrue:[
            thumbHalfShadowColor := Color darkGray.
            thumbHalfLightColor := self whiteColor
        ].

        thumbShadowColor := self blackColor.
"/        thumbLightColor := White.

        nm = #motif ifTrue:[
            DefaultThumbColor isNil ifTrue:[
                thumbColor := self whiteColor.
            ].
        ]
    ].

    DefaultThumbColor notNil ifTrue:[
        thumbColor := DefaultThumbColor onDevice:graphicsDevice
    ] ifFalse:[
        nm ~= #napkin ifTrue:[
            thumbColor := self whiteColor.
            nm ~= #normal ifTrue:[
                graphicsDevice hasGrayscales ifFalse:[
                    thumbColor := Color gray
                ].
            ].
        ].
    ].
    thumbColor notNil ifTrue:[  
        thumbColor := thumbColor onDevice:graphicsDevice.
    ].

    thumbShadowColor notNil ifTrue:[
        thumbShadowColor := thumbShadowColor onDevice:graphicsDevice.
    ].
    thumbLightColor notNil ifTrue:[
        thumbLightColor := thumbLightColor onDevice:graphicsDevice.
    ].
    thumbHalfShadowColor notNil ifTrue:[
        thumbHalfShadowColor := thumbHalfShadowColor onDevice:graphicsDevice.
    ].
    thumbHalfLightColor notNil ifTrue:[
        thumbHalfLightColor := thumbHalfLightColor onDevice:graphicsDevice.
    ].
    thumbEdgeStyle notNil ifTrue:[
        thumbHalfShadowColor isNil ifTrue:[
            thumbHalfShadowColor := thumbShadowColor lightened onDevice:graphicsDevice
        ]
    ].

    DefaultThumbEnteredColor notNil ifTrue:[
        thumbEnteredColor := DefaultThumbEnteredColor onDevice:graphicsDevice.
    ] ifFalse:[
        thumbEnteredColor := thumbColor.
    ].

    (DefaultThumbEnteredColor notNil or:[NewCursors]) ifTrue:[
        self enableMotionEvents.
        self enableEnterLeaveEvents.
    ].

    DefaultThumbImage notNil ifTrue:[
        thumbImage := DefaultThumbImage onDevice:graphicsDevice.
        fixThumbHeight := true.
    ].

    HandleImage notNil ifTrue:[
        shadowForm := HandleImage onDevice:graphicsDevice.
    ] ifFalse:[
        nm = #next ifTrue:[
            shadowForm := self class handleShadowFormOn:graphicsDevice.
            lightForm := self class handleLightFormOn:graphicsDevice
        ] ifFalse:[
            shadowForm := lightForm := nil
        ].
    ].
    self drawableId notNil ifTrue:[
        self computeThumbFrame
    ].

    autoRepeat := styleSheet at:#'scroller.autoRepeat' default:true.
    initialRepeatDelay := styleSheet at:#'scroller.initialRepeatDelay' default:0.3.
    repeatDelay := styleSheet at:#'scroller.repeatDelay' default:0.15.

    "Modified: / 5.9.1998 / 20:21:41 / cg"
!

initialize
    "initialize - setup instvars from defaults"

    orientation isNil ifTrue:[orientation := #vertical].

    super initialize.

    scrolling := entered              := false.
    enabled   := synchronousOperation := true.

    thumbOrigin := 0.
    thumbHeight := 100.
    thumbFrameSizeDifference := 0.

    rangeStart := 0.
    rangeEnd := 100.
    rangeStep := nil.   "/ meaning: arbitrary precision
"/    inset := 1.

"/    self computeThumbFrame

    "Modified: / 7.3.1999 / 00:07:32 / cg"
!

realize
    super realize.
    model notNil ifTrue:[
	self thumbOrigin:(model value).
    ].
! !

!Scroller methodsFor:'private'!

absFromPercent:percent
    "given a percentage, compute number of pixels"

    |fullSize|

    (orientation == #vertical) ifTrue:[
	fullSize := height 
    ] ifFalse:[
	fullSize := width
    ].

    "/ avoid hitting the boundary if no frame and no level (i.e. st80 style)
    (thumbLevel == 0 and:[thumbFrameColor isNil]) ifTrue:[
	fullSize := fullSize - 1
    ].

    ^ ((percent * (fullSize - thumbFrameSizeDifference - (margin * 2))) / 100) rounded

    "Modified: 7.3.1997 / 16:05:57 / cg"
!

computeThumbFrame
    "compute the thumbs frame (a rectangle) whenever thumb is moved, 
     changed height or the scrollers size has changed.
     We take care, that the thumb will not become too small (i.e.
     invisible or uncatchable).
     Also, for mswindows style, its height/width is constant."

    |newPos1 newPos2 newSize1 newSize2 nh nw ny nx 
     computedSize minSz sz1 sz2 nb nr|

    thumbHeight >= 100 ifTrue:[
        self thumbOrigin ~= 0.0 ifTrue:[
            self thumbOrigin:0
        ].

        thumbFrame := nil.
        ^ self
    ].

    "compute position & size"
    newPos1 := (self absFromPercent:thumbOrigin) + margin.
    newSize1 := computedSize := self absFromPercent:thumbHeight.
    (orientation == #vertical) ifTrue:[
        sz1 := height.
        sz2 := width
    ] ifFalse:[
        sz1 := width.
        sz2 := height
    ].

    "
     do we have to adjust the computed size ?
    "
    newPos2 := margin + inset.     
    newSize2 := sz2 - (2 * newPos2).

"/    (style ~~ #normal) ifTrue:[
    thumbLevel ~~ 0 ifTrue:[
        "
         do not make thumb too small (for handle & to be catchable)
        "
        minSz := MinThumbSize "10" + (2 * thumbLevel)
    ] ifFalse:[
        "
         do not make thumb too small (uncatchable)
        "
        minSz := MinThumbSize "4"
    ].

    (newSize1 < minSz) ifTrue:[
        newSize1 := minSz.
        thumbFrameSizeDifference := newSize1 - computedSize
    ] ifFalse:[
        thumbFrameSizeDifference := 0.
    ].

    fixThumbHeight ifTrue:[
        "have a fix-size thumb (i.e. mswindows style)"

        newSize1 := sz2 - (2 * inset).   "make it square"
        thumbImage notNil ifTrue:[
            newSize1 := (newSize1 max:(thumbImage height)) max:(thumbImage width)
        ].
        thumbFrameSizeDifference := newSize1 - computedSize.
    ].

    "
     oops - if height does not reflect real visibible area, we have to adjust the origin
    "
    (thumbFrameSizeDifference == 0) ifFalse:[
        newPos1 := (self absFromPercent:thumbOrigin) + margin.
"/        newPos1 := ((thumbOrigin * (sz1 - thumbFrameSizeDifference - (margin * 2))) / 100) rounded + margin
    ].

    (orientation == #vertical) ifTrue:[
        ny := newPos1 max:margin.
        nx := newPos2.
        nh := newSize1.
        nw := newSize2 max:2.
        ny + nh >= (height - margin) ifTrue:[
            ny := (height - 1 - margin - nh) max:margin.
        ].
        (nx+nw) >= width ifTrue:[
            nx := ((width - nw) // 2) max:0.
        ].

        nb := ny + nh - 1.
        nb >= (height - margin) ifTrue:[
            ny <= margin ifTrue:[
                thumbFrame := nil.
                ^ self
            ]
        ].
    ] ifFalse:[
        nx := newPos1 max:margin.
        ny := newPos2.
        nw := newSize1.
        nh := newSize2 max:2.
        nx + nw >= (width - margin) ifTrue:[
            nx := (width - 1 - margin - nw) max:margin.
        ].
        (ny+nh) >= height ifTrue:[
            ny := ((height - nh) // 2) max:0.
        ].
        nr := nx + nw - 1.
        nr >= (width - margin) ifTrue:[
            nx <= margin ifTrue:[
                thumbFrame := nil.
                ^ self
            ]
        ].
    ].
    (((styleSheet name == #winXP) or:[styleSheet name == #winVista]) 
    and:[self isMiniScroller not]) ifTrue:[
        nw := nw + 1.
        nh := nh + 1.
    ].

    "
     do not create a new Rectangle if its the same anyway
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

    thumbFrame := Rectangle left:nx top:ny width:nw height:nh.

    "Modified: / 12.5.1998 / 20:58:51 / cg"
!

percentFromAbs:absValue
    "given a number of pixels, compute percentage"

    |fullSize val t|

    (orientation == #vertical) ifTrue:[
	fullSize := height
    ] ifFalse:[
	fullSize := width
    ].

    absValue < 0 ifTrue:[^ rangeStart].
    absValue > fullSize ifTrue:[^ rangeEnd].

    t := fullSize - thumbFrameSizeDifference - (margin * 2).
    t = 0 ifTrue:[
	"/ in rare cases, this happens ...
	val := 0
    ] ifFalse:[
	val := absValue / t * (rangeEnd - rangeStart).
    ].
    val := val + rangeStart.

    rangeStart < rangeEnd ifTrue:[
	val < rangeStart ifTrue:[^ rangeStart].
	val > rangeEnd ifTrue:[^ rangeEnd].
    ] ifFalse:[
	val > rangeStart ifTrue:[^ rangeStart].
	val < rangeEnd ifTrue:[^ rangeEnd].
    ].
    ^ val

    "Modified: / 21.1.1998 / 19:31:15 / cg"
!

startMove
    originBeforeMove := self thumbOrigin.

    (ghostColor notNil 
    or:[ghostFrameColor notNil
    or:[ghostLevel ~~ 0]]) ifTrue:[
	thumbFrame isNil ifTrue:[
	    self computeThumbFrame.
	].
	frameBeforeMove := thumbFrame insetBy:1@1
    ].

!

updateBackground
    "make my background grey, whenever either readOnly or disable"

    |bg|

    enabled ifTrue:[
        bg := DefaultViewBackground.
    ].
    bg isNil ifTrue:[
        bg := View defaultViewBackgroundColor.
    ].

    bg ~= viewBackground ifTrue:[
        self backgroundColor:bg.
        self invalidate
    ]

! !

!Scroller methodsFor:'private-scrollbar & scrollview interface'!

setThumbFor:aView
    "get contents and size info from aView and adjust thumb"

    |percentSize percentOrigin contentsSize contentsPosition viewsSize t|

    scrolling ifTrue:[self invalidate].

    "
     get the content's size
    "
    aView isNil ifTrue:[
        contentsSize := 0
    ] ifFalse:[
        orientation == #vertical ifTrue:[
            contentsSize := aView heightOfContents.
            (t := aView transformation) notNil ifTrue:[
                contentsSize := t applyScaleY:contentsSize.
            ].
        ] ifFalse:[
            contentsSize := aView widthOfContents.
            (t := aView transformation) notNil ifTrue:[
                contentsSize := t applyScaleX:contentsSize.
            ].
        ]
    ].

    (contentsSize = 0) ifTrue:[
        percentSize := 100.
        percentOrigin := 100
    ] ifFalse:[
        (orientation == #vertical) ifTrue:[
            viewsSize := aView innerHeight.
            contentsPosition := aView yOriginOfContents.
        ] ifFalse:[
            viewsSize := aView innerWidth.
            contentsPosition := aView xOriginOfContents
        ].

        percentSize := viewsSize * 100.0 / contentsSize.
        percentOrigin := contentsPosition * 100.0 / contentsSize.
        percentOrigin + percentSize > 100.0 ifTrue:[
            "actually showing stuff below contents of view"
"
            contentsSize := contentsPosition + aView innerHeight.
            percentSize := viewsSize * 100.0 / contentsSize.
            percentOrigin := contentsPosition * 100.0 / contentsSize
"
        ]
    ].
    (percentSize = thumbHeight) ifTrue:[
        self thumbOrigin:percentOrigin
    ] ifFalse:[
        (percentOrigin = thumbOrigin) ifTrue:[
            self thumbHeight:percentSize
        ] ifFalse:[
            self thumbOrigin:percentOrigin thumbHeight:percentSize
        ]
    ].
!

setThumbHeightFor:aView
    "get contents and size info from aView and adjust thumb height"

    |percent total viewsSize|

    scrolling ifTrue:[self invalidate].

    (orientation == #vertical) ifTrue:[
	total := aView heightOfContents.
	aView transformation notNil ifTrue:[
	    total := aView transformation applyScaleY:total.
	].
    ] ifFalse:[
	total := aView widthOfContents.
	aView transformation notNil ifTrue:[
	    total := aView transformation applyScaleX:total.
	].
    ].
    (total = 0) ifTrue:[
	percent := 100
    ] ifFalse:[
	viewsSize := (orientation == #vertical) ifTrue:[aView innerHeight]
					   ifFalse:[aView innerWidth].
	percent := viewsSize * 100.0 / total
    ].
    self thumbHeight:percent
!

setThumbOriginFor:aView
    "get contents and size info from aView and adjust thumb origin"

    |percent total contentsPosition|

    scrolling ifTrue:[self invalidate].

    (orientation == #vertical) ifTrue:[
        total := aView heightOfContents.
        aView transformation notNil ifTrue:[
            total := aView transformation applyScaleY:total.
        ].
    ] ifFalse:[
        total := aView widthOfContents.
        aView transformation notNil ifTrue:[
            total := aView transformation applyScaleX:total.
        ].
    ].
    (total = 0) ifTrue:[
        percent := 100
    ] ifFalse:[
        contentsPosition := (orientation == #vertical) ifTrue:[aView yOriginOfContents]
                                                  ifFalse:[aView xOriginOfContents].
        percent := contentsPosition * 100.0 / total
    ].
    self thumbOrigin:percent.
! !

!Scroller methodsFor:'queries'!

isMiniScroller
    ^ false
!

isScrolling
    "true, if thumb is being moved (by user)"

    ^ scrolling
!

preferredExtent
    "return my preferredExtent"

    |defExt w h|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    defExt := self class defaultExtent.

    orientation == #vertical ifTrue:[
        h := defExt y.
        (w := DefaultVScrollerWidth) isNil ifTrue:[
            w := (device horizontalPixelPerMillimeter asFloat * 5) rounded
        ]
    ] ifFalse:[
        w := defExt x.
        (h := DefaultHScrollerHeight) isNil ifTrue:[
            h := (device verticalPixelPerMillimeter asFloat * 5) rounded
        ]
    ].

    preferredExtent := w @ h.
    ^ preferredExtent.

    "Modified: / 28.4.1999 / 18:28:19 / cg"
!

thumbVisible
    "return true, if the thumb is usable i.e. its visible & movable.
     Can be used by the scrollBar to decide if it should hide the scroller."

    |m2|

    (thumbHeight >= 100) ifTrue:[^ false].
    self computeThumbFrame.
    thumbFrame isNil ifTrue:[^ false].

    m2 := margin * 2.
    orientation == #vertical ifTrue:[
	thumbFrame height >= (height - m2) ifTrue:[^ false].
    ] ifFalse:[
	thumbFrame width >= (width - m2) ifTrue:[^ false].
    ].
    ^ true

    "Created: / 7.3.1997 / 21:10:23 / cg"
    "Modified: / 12.5.1998 / 20:21:00 / cg"
!

verticalScrollStep
    "mouse wheel: scroll by keyboardStep or a quarter of a page
     Note: this is used for horizontal scrollers, too"

    ^ (keyboardStep ? (thumbHeight / 4)) max:1
! !

!Scroller class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

