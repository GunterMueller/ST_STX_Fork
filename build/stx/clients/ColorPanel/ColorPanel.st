View subclass:#ColorPanel
	instanceVariableNames:'rgbPanel hlsPanel wheel myColor labelView labelColor'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

ColorPanel comment:'
 color mixer

ColorPanel new realize
 $Header: /cvs/stx/stx/clients/ColorPanel/ColorPanel.st,v 1.9 1996-08-16 12:46:12 cg Exp $
 written june 93 by claus

ColorPanel new open

'!


!ColorPanel  class methodsFor:'defaults'!

defaultExtent
    ^ 600 @ 150
! !

!ColorPanel methodsFor:'actions'!

setColor:clr
    self setLabelColor:clr.
    hlsPanel setFrom:clr.
    rgbPanel setFrom:clr.
    wheel color:clr
!

setColorFromWheel:clr
    |c|

    c := clr.
    myColor light ~= 50 ifTrue:[
        clr hue notNil ifTrue:[
            "/ could use 'myColor light' instead of lightSliders
            "/ value here; but that can lead to rounding errors which
            "/ results in a floating light slider ...

            c := Color hue:clr hue
                       light:(hlsPanel lightSlider thumbOrigin)
                       saturation:clr saturation
        ]
    ].

    self setLabelColor:c.
    hlsPanel setFrom:c.
    rgbPanel setFrom:c.
!

setHue:h light:l saturation:s
"
    'hls: ' print. h print. ' ' print. l print. ' ' print. s printNewline.
"
    |clr|

    clr := Color hue:h light:l saturation:s.
    self setLabelColor:clr.
    rgbPanel setFrom:clr.
    wheel color:clr
!

setLabelColor:aColor
    |clr sameColor h|

    myColor writable ifTrue:[
        myColor red:aColor red
                green:aColor green
                blue:aColor blue.
    ] ifFalse:[
        myColor := aColor.
    ].

    myColor writable ifFalse:[
        "/ see if the new color is represented like
        "/ the old one on that display.
        "/ if so, suppress redrawing the label
        clr := aColor.

        sameColor := (clr = labelColor).
        sameColor ifFalse:[
            clr := aColor on:device.
            sameColor := (clr colorId == labelColor colorId).
            sameColor ifTrue:[
                clr colorId isNil ifTrue:[
                    sameColor := (clr ditherForm == labelColor ditherForm).
                ]
            ]
        ].
        sameColor ifFalse:[
            labelColor := clr.
            myColor writable ifFalse:[
                labelView backgroundColor:aColor.
                labelView invalidate.
            ].
        ].
    ].

    hlsPanel saturationSlider color:aColor

    "Modified: 15.6.1996 / 12:06:02 / cg"
!

setRed:r green:g blue:b
"
    'rgb: ' print. r print. ' ' print. g print. ' ' print. b printNewline.
"
    |clr|

    clr := Color red:r green:g blue:b.

    self setLabelColor:clr.
    hlsPanel setFrom:clr.
    wheel color:clr
! !

!ColorPanel methodsFor:'initialization'!

initialize
    |l h sep r helper wl|

    super initialize.

    device visualType == #PseudoColor
    ifTrue:[
        myColor := Color variableColorOn:device.
        myColor isNil ifTrue:[
            ObjectMemory garbageCollect.
            myColor := Color variableColorOn:device.
        ].
        myColor notNil ifTrue:[
            myColor writable ifFalse:[
                myColor := nil
            ] ifTrue:[
                myColor red:0 green:0 blue:0
            ]
        ]
    ].

    "just to have a spare color"
    myColor isNil ifTrue:[
        myColor := (Color red:70 green:20 blue:90) on:device.
    ].

    myColor writable ifTrue:[
        labelColor := myColor
    ] ifFalse:[
        labelColor := Black.
    ].

    sep := View viewSpacing rounded.

    rgbPanel := RGBPanel origin:0.3 @ 0.0 corner:0.8 @ 0.5 in:self.
    rgbPanel verticalInset:sep.
    rgbPanel horizontalInset:sep.
    rgbPanel action:[:r :g :b | self setRed:r green:g blue:b].

    hlsPanel := HLSPanel origin:0.3 @ 0.5 corner:0.8 @ 1.0 in:self.
    hlsPanel verticalInset:sep.
    hlsPanel horizontalInset:sep.
    hlsPanel action:[:h :l :s | self setHue:h light:l saturation:s].

    wheel := ColorWheel origin:0.0 @ 0.0 corner:0.3 @ 1.0 in:self.
    wheel borderWidth:0.
    wheel verticalInset:sep.
    wheel horizontalInset:sep.
    wheel action:[:color | self setColorFromWheel:color].

    labelView := Label origin:0.8 @ 0.0 corner:1.0 @ 1.0 in:self.
    labelView verticalInset:sep.
    labelView horizontalInset:sep.
    labelView viewBackground:labelColor.
    labelView backgroundColor:labelColor.
    styleSheet is3D ifTrue:[
        labelView level:-1; borderWidth:0.
    ] ifFalse:[
        labelView level:0; borderWidth:1.
    ]

    "Modified: 15.6.1996 / 12:16:52 / cg"
! !

!ColorPanel  class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/ColorPanel/ColorPanel.st,v 1.9 1996-08-16 12:46:12 cg Exp $'
! !
