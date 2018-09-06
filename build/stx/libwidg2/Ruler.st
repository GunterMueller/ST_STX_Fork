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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#Ruler
	instanceVariableNames:'fgColor metric paperWidth paperHeight scale showUnit orientation'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!Ruler class methodsFor:'documentation'!

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

    a shows some unit scale; See example use in DrawTool.

    instance variables:

        fgColor         <Color>         color to draw text and marks with
        metric          <Symbol>        inch or mm
        paperWidth      <Number>        width of paper
        paperHeight     <Number>        height of paper
        scale           <Number>        scale factor for zoom
        showUnit        <Boolean>       if true, a unit string is displayed
"
!

examples
"
                                                                        [exBegin]
    |top ruler|

    top := StandardSystemView new.
    ruler := Ruler origin:0.0@0.0 corner:1.0@30 in:top.
    top open
                                                                        [exEnd]


  defining paperWidth:
                                                                        [exBegin]
    |top ruler|

    top := StandardSystemView new.
    ruler := Ruler origin:0.0@0.0 corner:1.0@30 in:top.
    ruler paperWidthInch:5.   
    top open
                                                                        [exEnd]


  hide unit string:
                                                                        [exBegin]
    |top ruler|

    top := StandardSystemView new.
    ruler := Ruler origin:0.0@0.0 corner:1.0@30 in:top.
    ruler showUnit:false.
    top open
                                                                        [exEnd]


  both horizontal and vertical rulers (as in DrawTool):
                                                                        [exBegin]
    |top hRuler vRuler|

    top := StandardSystemView new.
    hRuler := Ruler origin:30@0.0 corner:1.0@30 in:top.
    vRuler := VerticalRuler origin:0.0@30 corner:30@1.0 in:top.
    vRuler showUnit:false.
    top open
                                                                        [exEnd]


  with some 3D effects:
                                                                        [exBegin]
    |top hRuler vRuler|

    top := StandardSystemView new.
    hRuler := Ruler origin:30@0.0 corner:1.0@30 in:top.
    vRuler := VerticalRuler origin:0.0@30 corner:30@1.0 in:top.
    vRuler showUnit:false.
    hRuler level:1.
    vRuler level:1.
    top open
                                                                        [exEnd]

  see the DrawTool, for how to make it scroll in sync with some
  other view. 
"
! !

!Ruler methodsFor:'accessing'!

heightOfContents
    ^ (device verticalPixelPerInch * paperHeight) rounded
!

metric:aSymbol
    "set the metric. The argument may be either #inch or #mm"

    aSymbol ~~ metric ifTrue:[
        metric := aSymbol.
        self invalidate
    ]

    "Modified: 29.5.1996 / 16:42:46 / cg"
!

paperHeightInch:inches
    "set the width of the document"

    paperHeight := inches.
    shown ifTrue:[
	self redraw
    ]
!

paperHeightMM:millis
    "set the width of the document"

    paperHeight := UnitConverter millimeterToInch:millis.
    shown ifTrue:[
        self redraw
    ]

    "Modified: 31.5.1996 / 19:39:46 / cg"
!

paperWidthInch:inches
    "set the width of the document"

    paperWidth := inches.
    shown ifTrue:[
	self redraw
    ]
!

paperWidthMM:millis
    "set the width of the document"

    paperWidth := UnitConverter millimeterToInch:millis.
    shown ifTrue:[
        self redraw
    ]

    "Modified: 31.5.1996 / 19:39:32 / cg"
!

scale:aFactor
    "set the scale factor. 1 is identity."

    aFactor ~= scale ifTrue:[
        scale := aFactor.
        self invalidate
    ]

    "Modified: 29.5.1996 / 16:42:56 / cg"
!

showUnit:aBoolean
    "set/clear the showUnit flag. If false, the unit string
     (i.e. 'inch' or 'mm') is not schown. Default is true."

    showUnit := aBoolean.
!

viewOrigin:origin
    origin = self viewOrigin ifTrue:[^ self].
    super setViewOrigin:origin.
    self invalidate

    "Modified: 29.5.1996 / 16:43:03 / cg"
!

widthOfContents
    ^ (device horizontalPixelPerInch * paperWidth) rounded
! !

!Ruler methodsFor:'initialization'!

initialize
    super initialize.

    orientation isNil ifTrue:[
        orientation := #horizontal.
    ].

    viewBackground := styleSheet colorAt:#rulerBackgroundColor default:viewBackground.
    fgColor := styleSheet colorAt:#rulerForegroundColor.
    fgColor isNil ifTrue:[
        fgColor := styleSheet colorAt:#foregroundColor.
    ].
    fgColor isNil ifTrue:[
        viewBackground brightness > 0.5 ifTrue:[
            fgColor := Black.
        ] ifFalse:[
            fgColor := White
        ].
    ].
    fgColor := fgColor onDevice:device.

    bitGravity := #NorthWest.

    self height:(font height + (2 * font descent)). 

    (Smalltalk language == #english) ifTrue:[
        metric := #inch
    ] ifFalse:[
        metric := #mm
    ].
    metric := styleSheet at:#rulerMetric default:metric.

    showUnit := true.

    scale := 1.

    paperWidth := 8.5.
    paperHeight := 11.

    "
     take a smaller font
    "
    font := (Font family:(font family)
                    face:(font face)
                   style:(font style)
                    size:8) onDevice:device.

    "
     Ruler new open
    "
!

reinitialize
    super reinitialize.
    font := font on:device.
! !

!Ruler methodsFor:'metric conversions'!

inchToPixel:inches
    "convert inches to screen pixels"

    ^ inches * self horizontalPixelPerInch
!

millimeterToPixel:mm
    "convert mms to screen pixels"

    ^ mm * self horizontalPixelPerMillimeter

! !

!Ruler methodsFor:'redrawing'!

redraw
    "redraw the scale"

    |x y pixelPerMM pixelPerInch mod pos shortLen veryShortLen longLen 
     charX charY fontHeight fontAscent
     top paperHeightMM paperWidthMM paperHeightPixel paperWidthPixel 
     org xOrigin yOrigin labelRight labelBot stringRight marg|

    shown ifFalse:[^ self].

    self clear.

    org := self viewOrigin.
    xOrigin := org x.
    yOrigin := org y.

    paperWidthPixel := ((self inchToPixel:paperWidth) * scale) rounded.
    paperHeightPixel := ((self inchToPixel:paperHeight) * scale) rounded.

    paperWidthMM := UnitConverter inchToMillimeter:paperWidth.
    paperHeightMM := UnitConverter inchToMillimeter:paperHeight.
    pixelPerMM := (self millimeterToPixel:1) * scale.

    fontHeight := font height.
    fontAscent := font ascent.

    orientation == #horizontal ifTrue:[
        (xOrigin + width > paperWidthPixel) ifTrue:[
            self paint:(Color darkGrey).
            self 
                fillRectangleX:paperWidthPixel y:0
                width:(xOrigin + width - paperWidthPixel) height:height.
            self paint:fgColor.
            self 
                displayLineFromX:paperWidthPixel y:0
                toX:paperWidthPixel y:height
        ].

        self paint:fgColor.

        top := height - fontHeight - fontAscent.
        longLen := fontHeight.
        shortLen := longLen // 2.
        charY := top + fontAscent + shortLen.
        mod := 1.
        marg := 3. "character shift"

        (metric == #mm) ifTrue:[
            "centimeter - long blibs every centimeter; short ones every half"

            pos := 5.
            showUnit ifTrue:[
                labelRight := stringRight := marg + (font widthOf:'cm') + 3 + xOrigin.
            ] ifFalse:[
                labelRight := stringRight := xOrigin.
            ].

            x := (pixelPerMM * pos) rounded.
            [(x < (width+xOrigin)) and:[pos <= paperWidthMM]] whileTrue:[
                |l|

                l := shortLen.
                (mod ~~ 1) ifTrue:[
                    x < stringRight ifFalse:[
                        l := longLen
                    ].
                ].
                self displayLineFromX:x y:top
                                  toX:x y:(top + l).

                ((x < stringRight) or:[mod == 1]) ifFalse:[
                    self displayString:(pos // 10) printString
                                     x:(x + marg)
                                     y:charY.
                    stringRight := x + marg 
                                    + (font widthOf:(pos // 10) printString)
                ].
                mod := (mod + 1) \\ 2.
                pos := pos + 5.
                x := (pixelPerMM * pos) rounded 
            ].
            showUnit ifTrue:[
                self displayString:'cm ' x:marg+xOrigin y:charY.
            ]
        ].
        (metric == #inch) ifTrue:[
            "inches - long blibs every inch; short ones every half; very
             short ones every quarter"

            pixelPerInch := (self inchToPixel:1) * scale.
            pos := 0.25.
            showUnit ifTrue:[
                labelRight := marg + (font widthOf:'inch') + 3 + xOrigin.
            ] ifFalse:[
                labelRight := xOrigin
            ].

            x := (pixelPerInch * pos) rounded.
            veryShortLen := longLen // 4.
            [(x < (xOrigin+width)) and:[pos <= paperWidth]] whileTrue:[
                |l|

                l := shortLen.    
                (mod == 0) ifTrue:[
                    x < labelRight ifFalse:[
                        l := longLen
                    ]
                ] ifFalse:[
                    (mod == 2) ifFalse:[
                        l := veryShortLen
                    ]
                ].
                self displayLineFromX:x y:top
                                  toX:x y:(top + l).

                (mod == 0 and:[x >= labelRight]) ifTrue:[
                    self displayString:pos asInteger printString
                                     x:(x + marg)
                                     y:charY
                ].
                mod := (mod + 1) \\ 4.
                pos := pos + 0.25.
                x := (pixelPerInch * pos) rounded
            ].
            showUnit ifTrue:[
                self displayString:'inch ' x:marg+xOrigin y:charY.
            ]
        ].
    ] ifFalse:[
        "/ orientation == #vertical ...

        (yOrigin + height > paperHeightPixel) ifTrue:[
            self paint:(Color darkGrey).
            self fillRectangleX:0 y:paperHeightPixel
                          width:width
                          height:(yOrigin + height - paperHeightPixel).
            self paint:fgColor.
            self displayLineFromX:0 y:paperHeightPixel
                              toX:width y:paperHeightPixel
        ].

        self paint:fgColor.

        left := 0. "width - (font widthOf:'WW')"
        longLen := font widthOf:'WW'.
        shortLen := longLen // 2.
        charX := left + shortLen.
        mod := 1.
        marg := 3. "character shift"

        showUnit ifTrue:[
            labelBot := marg + fontHeight + fontAscent + yOrigin.
        ] ifFalse:[
            labelBot := yOrigin
        ].

        (metric == #mm) ifTrue:[
            "centimeter - long blibs every centimeter; short ones every half"

            pos := 5.
            y := (pixelPerMM * pos) rounded.
            [(y < (height+yOrigin)) and:[pos <= paperHeightMM]] whileTrue:[
                |l|

                l := shortLen.
                (mod ~~ 1) ifTrue:[
                    y < labelBot ifFalse:[
                        l := longLen
                    ]
                ].
                self displayLineFromX:left y:y toX:(left + l) y:y.

                (mod ~~ 1 and:[y >= labelBot]) ifTrue:[
                    self displayString:(pos // 10) printString
                                     x:charX
                                     y:(y + marg + fontHeight)
                ].
                mod := (mod + 1) \\ 2.
                pos := pos + 5.
                y := (pixelPerMM * pos) rounded 
            ].
            showUnit ifTrue:[
                self displayString:'cm ' x:charX y:marg + fontHeight + yOrigin.
            ]
        ].
        (metric == #inch) ifTrue:[
            "inches - long blibs every inch; short ones every half; very
             short ones every quarter"

            pixelPerInch := (self inchToPixel:1) * scale.
            pos := 0.25.

            y := (pixelPerInch * pos) rounded.
            veryShortLen := longLen // 4.
            [(y < (yOrigin + height)) and:[pos <= paperHeight]] whileTrue:[
                |l|

                l := shortLen.
                (mod == 0) ifTrue:[
                    y < labelBot ifFalse:[
                        l := longLen.
                    ]
                ] ifFalse:[
                    (mod == 2) ifFalse:[
                        l := veryShortLen
                    ]
                ].
                self displayLineFromX:left y:y toX:(left + l) y:y.

                (mod == 0) ifTrue:[
                    y < labelBot ifFalse:[
                        self displayString:pos asInteger printString
                                         x:charX
                                         y:(y + marg + fontHeight)
                    ]
                ].
                mod := (mod + 1) \\ 4.
                pos := pos + 0.25.
                y := (pixelPerInch * pos) rounded
            ].
            showUnit ifTrue:[
                self displayString:'inch ' x:charX y:marg + fontHeight + yOrigin.
            ]
        ].
    ].

    self redrawEdges


! !

!Ruler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/Ruler.st,v 1.28 2002-10-31 21:49:29 cg Exp $'
! !

