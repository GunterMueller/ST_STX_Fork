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

SimpleView subclass:#FramedBox
	instanceVariableNames:'label labelChannel labelPosition fgColor showFrame frame3D
		frameMacRounded horizontalSpace verticalSpace
		innerHorizontalSpace innerVerticalSpace frameColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!FramedBox class methodsFor:'documentation'!

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
    a frame around something. The frame may have a label, whose position
    is controlled by the labelPosition variable, a symbol which may be one of:
    [#topCenter #topLeft #topRight #bottomLeft #bottomCenter #bottomRight #hidden]

    The default labelPosition is controlled by the styleSheet variable:
    'framedBoxLabelPosition' (usually, #topCenter).

    Its also possible, to not show the frame but only the label, by setting
    showFrame to false.

    The distance from the outer viewBorder to the frame is controlled by
    horizontalSpace / verticalSpace. The default is the font's height.

    The distance from the frame to the interior area is controlled by
    innerHorizontalSpace / innerVerticalSpace. The default is 0.

    [author:]
        Claus Gittinger

    [see also:]
        PanelView Separator
"
!

examples 
"
    simple:
                                                                        [exBegin]
        |top frame1 frame2 frame3|

        top := StandardSystemView new.
        top extent:300@200.

        frame1 := FramedBox origin:0.0@0.0 corner:0.5@0.5 in:top.
        frame1 label:'frame1'.

        frame2 := FramedBox origin:0.5@0.0 corner:1.0@0.5 in:top.
        frame2 label:'frame2'.

        frame3 := FramedBox origin:0.0@0.5 corner:1.0@1.0 in:top.
        frame3 label:'frame3'.

        top open
                                                                        [exEnd]


    non-string label:
                                                                        [exBegin]
        |top frame|

        top := StandardSystemView new.
        top extent:300@200.

        frame := FramedBox origin:0.0@0.0 corner:1.0@1.0 in:top.
        frame label:(Image fromFile:'bitmaps/SBrowser.xbm').

        top open
                                                                        [exEnd]


    placing something inside:
                                                                        [exBegin]
        |top frame1 frame2 frame3 v1 v2 v3|

        top := StandardSystemView new.
        top extent:300@200.

        frame1 := FramedBox origin:0.0@0.0 corner:0.5@0.5 in:top.
        frame1 label:'frame1'.
        v1 := View origin:0.0@0.0 corner:1.0@1.0 in:frame1.
        v1 viewBackground:(Color yellow);
           level:1.

        frame2 := FramedBox origin:0.5@0.0 corner:1.0@0.5 in:top.
        frame2 label:'frame2'.
        v2 := View origin:0.0@0.0 corner:1.0@1.0 in:frame2.
        v2 viewBackground:(Color red);
           level:1.

        frame3 := FramedBox origin:0.0@0.5 corner:1.0@1.0 in:top.
        frame3 label:'frame3'.
        v3 := View origin:0.0@0.0 corner:1.0@1.0 in:frame3.
        v3 viewBackground:(Color green);
           level:1.

        top open
                                                                        [exEnd]


    placing something inside a frame in a dialog:
                                                                        [exBegin]
        |box panel frame1 frame2 frame3 v1 v1b v2 v3|

        box := Dialog new.

        frame1 := FramedBox label:'frame1'.
        panel := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:frame1.
        v1 := View extent:100@100 in:panel.
        v1 viewBackground:(Color red);
           level:1.
        v1b := View extent:100@100 in:panel.
        v1b viewBackground:(Color yellow);
            level:1.

        box addComponent:frame1.

        frame2 := FramedBox label:'frame2'.
        v2 := View origin:0.0@0.0 corner:1.0@1.0 in:frame2.
        v2 viewBackground:(Color green);
           level:1.
        box addComponent:frame2.

        frame3 := FramedBox label:'frame3'.
        v3 := View origin:0.0@0.0 corner:1.0@1.0 in:frame3.
        v3 viewBackground:(Color blue);
           level:1.
        box addComponent:frame3.

        box addOkButton.
        box stickAtBottomWithVariableHeight:frame3.
        box open
                                                                        [exEnd]


    placing something inside a frame in a dialog:
                                                                        [exBegin]
        |box panel frame1 frame2 frame3 v1 v1b v2 v3|

        box := Dialog new.

        frame1 := FramedBox label:'frame1'.
        panel := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:frame1.
        v1 := View extent:100@100 in:panel.
        v1 viewBackground:(Color red);
           level:1.
        v1b := View extent:100@100 in:panel.
        v1b viewBackground:(Color yellow);
            level:1.

        box addComponent:frame1.

        frame2 := FramedBox label:'frame2'.
        v2 := View origin:0.0@0.0 corner:1.0@1.0 in:frame2.
        v2 viewBackground:(Color green);
           level:1.
        box addComponent:frame2.

        frame3 := FramedBox label:'frame3'.
        v3 := View origin:0.0@0.0 corner:1.0@1.0 in:frame3.
        v3 viewBackground:(Color blue);
           level:1.
        box addComponent:frame3.

        box addOkButton.
        box stickAtBottomWithVariableHeight:frame3.
        box open
                                                                        [exEnd]


    simple again, default spacings:
                                                                        [exBegin]
        |top frame v|

        top := StandardSystemView new.
        top extent:300@200.

        frame := FramedBox origin:0.0@0.0 corner:0.5@0.5 in:top.
        frame label:'frame'.

        v := View origin:0.0@0.0 corner:1.0@1.0 in:frame.
        v viewBackground:(Color yellow); level:1.

        top open
                                                                        [exEnd]


    changing spacings:
                                                                        [exBegin]
        |top frame v|

        top := StandardSystemView new.
        top extent:300@200.

        frame := FramedBox origin:0.0@0.0 corner:0.5@0.5 in:top.
        frame label:'frame'.
        frame horizontalSpace:30.
        frame verticalSpace:20.

        v := View origin:0.0@0.0 corner:1.0@1.0 in:frame.
        v viewBackground:(Color yellow); level:1.

        top open
                                                                        [exEnd]


    changing inner spacings:
                                                                        [exBegin]
        |top frame v|

        top := StandardSystemView new.
        top extent:300@200.

        frame := FramedBox origin:0.0@0.0 corner:0.5@0.5 in:top.
        frame label:'frame'.
        frame innerHorizontalSpace:30.
        frame innerVerticalSpace:20.

        v := View origin:0.0@0.0 corner:1.0@1.0 in:frame.
        v viewBackground:(Color yellow); level:1.

        top open
                                                                        [exEnd]


     label only (no frame around):
                                                                        [exBegin]
        |top frame v|

        top := StandardSystemView new.
        top extent:300@200.

        frame := FramedBox origin:0.0@0.0 corner:0.5@0.5 in:top.
        frame label:'frame'.
        frame showFrame:false.

        v := View origin:0.0@0.0 corner:1.0@1.0 in:frame.
        v viewBackground:(Color yellow); level:1.

        top open
                                                                        [exEnd]
"
! !

!FramedBox methodsFor:'accessing'!

font:aFont
    "set the frame labelstrings font.
     CAVEAT: with the addition of Text objects,
             this method is going to be obsoleted by a textStyle
             method, which allows specific control over
             normalFont/boldFont/italicFont parameters."

    (self font ~= aFont) ifTrue:[
        super font:aFont.
        self invalidate
    ]

    "Modified: / 6.6.1998 / 20:05:05 / cg"
!

foregroundColor
    "return the label's foreground color"

    ^ fgColor
!

foregroundColor:aColor
    "set the frame label's foreground color"

    aColor ~= fgColor ifTrue:[
        fgColor := aColor.
        self invalidateRepairNow:true
    ]

    "Modified: / 6.6.1998 / 19:23:14 / cg"
!

frameColor
    "return the frame's color"

    ^ frameColor
!

frameColor:aColor
    "set the frame's foreground color"

    aColor ~= frameColor ifTrue:[
        frameColor := aColor.
        self invalidateRepairNow:true
    ]
!

frameShown
    "return true, if frame is shown;
     if false, only the label is shown.
     OBSOLETE; use #showFrame."

    ^ self showFrame
!

horizontalSpace
    "return the number of pixels by which the frame is inset horizontally.
     The default, nil, lets the box compute the horizontal inset from the
     labels font height."

    ^ horizontalSpace

    "Modified: 5.9.1995 / 17:24:21 / claus"
!

horizontalSpace:aNumber 
    "set the number of pixels by which the frame is inset horizontally.
     The default, nil, lets the box compute the horizontal inset from the
     labels font height."

    horizontalSpace := aNumber
!

innerHorizontalSpace:aNumber 
    "set the number of pixels by which the interior is inset horizontally from the frame.
     The default is 0"

    innerHorizontalSpace := aNumber

    "Created: 10.1.1996 / 14:39:20 / cg"
!

innerVerticalSpace:aNumber 
    "set the number of pixels by which the interior is inset vertically from the frame.
     The default is 0"

    innerVerticalSpace := aNumber

    "Created: 10.1.1996 / 14:39:35 / cg"
!

label
    "return the frames labelstring"

    ^ label
!

label:aStringOrImage
    "set the frames labelstring or labelImage"

    (label ~= aStringOrImage
    "/ sr - update also when get a #Text (only when before was a #Strins)
    or:[(label isKindOf:Text) ~~ (aStringOrImage isKindOf:Text)]) ifTrue:[
        (aStringOrImage isString 
        and:[aStringOrImage isEmpty]) ifTrue:[
            label := nil
        ] ifFalse:[
            label := aStringOrImage.
        ].
        self invalidateRepairNow:true
    ]

    "Modified: / 5.9.1995 / 17:20:05 / claus"
    "Modified: / 6.6.1998 / 19:23:17 / cg"
!

labelPosition
    "return the labelPosition, which is a symbol describing
     the labels position."

    ^ labelPosition
!

labelPosition:aSymbol
    "define the position of the label;
     aSymbol may be one of: 
        #topLeft, #topCenter, #topRight;
        #bottomLeft, #bottomCenter or #bottomRight
        #hidden"

    labelPosition ~~ aSymbol ifTrue:[
        labelPosition := aSymbol.
        self invalidate
    ]

    "Modified: / 6.6.1998 / 20:04:22 / cg"
!

layout:something
    "OBSOLETE compatibility interface. Will vanish.
     In the meantime, try to figure out what is meant ... a kludge"

    <resource:#obsolete>

    (something isNil or:[something isLayout]) ifTrue:[^ super layout:something].

    self obsoleteMethodWarning:'use #labelPosition:'.
    ^ self labelPosition:something

    "Modified: 31.8.1995 / 23:07:00 / claus"
!

setLabel:anImage
    "set the frames label.
     same as #label: for ST-80 GroupBox compatibility"

    ^ self label:anImage

    "Created: 17.2.1997 / 11:03:04 / cg"
    "Modified: 17.2.1997 / 11:03:24 / cg"
!

setLabelString:anImage
    "set the frames label.
     same as #label: for ST-80 GroupBox compatibility"

    ^ self label:anImage

    "Modified: 17.2.1997 / 11:03:19 / cg"
!

showFrame
    "return if the view shows its frame.
     If false, only the label is drawn"

    ^ showFrame

    "Modified: 5.9.1995 / 17:21:37 / claus"
!

showFrame:aBoolean
    "turn on/off showing of the frame -
     without a frame, only the label is shown at its position.
     (unless the label is nil or #hidden)"

    aBoolean ~~ showFrame ifTrue:[
        showFrame := aBoolean.
        self invalidate
    ]

    "Modified: / 6.6.1998 / 20:03:50 / cg"
!

verticalSpace
    "return the number of pixels by which the frame is inset vertically.
     The default, nil, lets the box compute the vertical inset from the
     labels font height."

    ^ verticalSpace

    "Modified: 5.9.1995 / 17:24:21 / claus"
    "Created: 10.1.1996 / 14:38:21 / cg"
!

verticalSpace:aNumber 
    "set the number of pixels by which the frame is inset vertically.
     The default, nil, lets the box compute the vertical inset from the
     labels font height."

    verticalSpace := aNumber.

    "Created: / 10.1.1996 / 14:38:31 / cg"
    "Modified: / 6.6.1998 / 20:04:39 / cg"
! !

!FramedBox methodsFor:'accessing-channels'!

labelChannel
    "return the labelChannel - or nil.
     If not nil, it should provide the actual label via #value
     (and may send out change notifications).
     If nil, the static label is used."

    ^ labelChannel.
!

labelChannel:aValueHolder
    "set the labelChannel - a valueHolder holding a string
     which is shown as my logo.
     If not nil, it should provide the actual label via #value
     (and may send out change notifications).
     If nil, the static label is used."
    
    labelChannel notNil ifTrue:[
        labelChannel removeDependent:self.
    ].

    (labelChannel := aValueHolder) notNil ifTrue:[
        labelChannel addDependent:self.
        self label:(labelChannel value).
    ].
! !

!FramedBox methodsFor:'change & update'!

update:what with:aPara from:aModel
    "the MVC way of changing the label ...
    "
    aModel == labelChannel ifTrue:[
        self label:(aModel value).
        ^ self
    ].
    ^ super update:what with:aPara from:aModel
! !

!FramedBox methodsFor:'drawing'!

drawFrame
    "redraw the frame"

    |halfSepX halfSepY w h|

    "
     if there is no label, give more real estate to the inside
    "
    label isNil ifTrue:[
        halfSepX := halfSepY := 2
    ] ifFalse:[
        halfSepX := halfSepY := (label heightOn:self) // 2.
    ].

    horizontalSpace notNil ifTrue:[
        halfSepX := horizontalSpace.
    ].
    verticalSpace notNil ifTrue:[
        halfSepY := verticalSpace.
    ].

    halfSepX := halfSepX + margin.
    halfSepY := halfSepY + margin.

    w := width - halfSepX - halfSepX.
    h := height - halfSepY - halfSepY.

    frameMacRounded ifTrue:[
        ^ self.
    ].
    
    frame3D ifFalse:[
        frameColor ~= fgColor ifTrue:[
            gc paint:frameColor
        ].    
        gc displayRectangleX:halfSepX y:halfSepY width:w height:h.
        ^ self
    ].

    w := w + 1.
    h := h + 1.

    gc paint:lightColor.
    gc displayRectangleX:halfSepX y:halfSepY width:w height:h.

    gc paint:shadowColor.
    gc displayRectangleX:halfSepX-1 y:halfSepY-1 width:w height:h.

    "Modified: 17.2.1997 / 11:04:34 / cg"
!

redraw
    "redraw the frame and name if present"

    |labelLen l x y|

    self clear.

    (label isNil or:[ labelPosition == #hidden]) ifTrue:[
        labelLen := 0
    ] ifFalse:[
        label isString ifTrue:[
            l := ' ' , label , ' '.
        ] ifFalse:[
            l := label
        ].
        labelLen := l widthOn:self
    ].

    showFrame ifTrue:[
        self drawFrame.
    ].

    labelLen > 0 ifTrue:[
        labelLen < width ifTrue:[
            (labelPosition == #topLeft 
            or:[labelPosition == #topCenter
            or:[labelPosition == #topRight]]) ifTrue:[
                "
                 label at top
                "
                y := gc font ascent + margin.
            ] ifFalse:[
                "
                 label at bottom
                "
                y := height - margin - gc font descent.
            ].
            (labelPosition == #topLeft
            or:[labelPosition == #bottomLeft]) ifTrue:[
                "
                 label at left
                "
                x := gc font height + margin
            ] ifFalse:[
                (labelPosition == #topRight
                or:[labelPosition == #bottomRight]) ifTrue:[
                    "
                     label at right
                    "
                    x := width - margin - labelLen - gc font height
                ] ifFalse:[
                    "
                     label at center
                    "
                    x := (width - margin - labelLen) // 2
                ]
            ].
            self paint:fgColor on:viewBackground.
            label isString ifTrue:[
                self displayOpaqueString:l x:x y:y
            ] ifFalse:[
                l displayOpaqueOn:self x:x y:y - gc font ascent
            ]
        ]
    ]

    "Modified: 28.2.1997 / 21:28:09 / cg"
! !

!FramedBox methodsFor:'event handling'!

sizeChanged:how
    self invalidate.
    super sizeChanged:how

    "Modified: 8.2.1997 / 15:19:52 / cg"
! !

!FramedBox methodsFor:'initialization'!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    super fetchDeviceResources.

    fgColor := fgColor onDevice:device.
    frameColor := frameColor onDevice:device.   
    
    "Created: 15.2.1997 / 16:57:56 / cg"
!

initStyle
    "setup style specifics.
     The default position is top-center, except for ms-windows, where
     the text is positioned at top-left"

    <resource: #style (#'framedBox.foregroundColor' 
                       #'framedBox.labelPosition'
                       #'framedBox.frameColor'
                       #'framedBox.font'
                       #'framedBox.MacRoundFrame'
                       #'framedBox.3DFrame')>

    super initStyle.

    fgColor := StyleSheet at:'framedBox.foregroundColor' default:self blackColor.
    frameColor := StyleSheet at:'framedBox.frameColor' default:fgColor.
    labelPosition := StyleSheet at:'framedBox.labelPosition' default:#topCenter.
    frame3D := StyleSheet at:'framedBox.3DFrame' default:true.
    frameMacRounded := StyleSheet at:'framedBox.MacRoundFrame' default:false. 
    self basicFont:(StyleSheet at:'framedBox.font' default:(StyleSheet at:'label.font' default:self font)).
    self borderWidth:0.

    "Modified: / 26.10.1997 / 17:00:57 / cg"
!

initialize
    innerHorizontalSpace := innerVerticalSpace := 0.
    super initialize.
    showFrame := true

    "Modified: 10.1.1996 / 14:38:40 / cg"
!

release

    labelChannel notNil ifTrue:[
        labelChannel removeDependent:self.
        labelChannel := nil.
    ].
    super release
! !

!FramedBox methodsFor:'queries'!

preferredExtent
    "compute the boxes preferredExtent from the components' sizes.
     Redefined to add space for the frame to the default extent" 

    |sep sep2|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    sep := gc font heightOn:device.
    sep2 := sep + sep.

    true "showFrame" ifFalse:[
        ^ super preferredExtent + (0 @ sep2)
    ].
    ^ super preferredExtent + (sep2 @ sep2)

    "Modified: 3.1.1997 / 22:02:56 / cg"
!

viewRectangle
    "return the inside area 
     - redefined to save frame from relative computations."

    |mH mV sepH sepV imH imV lw|

    sepH := sepV := gc font heightOn:device.
    horizontalSpace notNil ifTrue:[
        sepH := horizontalSpace
    ].
    verticalSpace notNil ifTrue:[
        sepV := verticalSpace
    ].

    mH := sepH * 2.
    mV := sepV * 2.
    imH := innerHorizontalSpace * 2.
    imV := innerVerticalSpace * 2.

    true "showFrame" ifFalse:[
        sepH := mH := lw := 0.
    ] ifTrue:[
        lw := 2.
    ].

    ^ ((sepH + innerHorizontalSpace + lw) @ (innerVerticalSpace + sepV + lw)) 
        extent:((width - imH - mH - lw - lw) @ (height - imV - mV - lw - lw))

"/    |m2 sepH sepV|
"/
"/    sepV := font height.
"/
"/    showFrame ifFalse:[
"/        ^ (0 @ sepV) extent:(width @ (height - sepV - sepV))
"/    ].
"/    sepH := sepV // 2.
"/    ^ (sepH @ sepH) extent:((width - sepH - sepH) @ (height - sepV - sepV))

    "Modified: 3.1.1997 / 22:03:08 / cg"
! !

!FramedBox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

