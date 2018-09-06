"
 COPYRIGHT (c) 1997 by eXept Software AG
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

Object subclass:#TabWidget
	instanceVariableNames:'model tabView label disabledLabel printableLabel anchor extent
		lineNr fgColor labelType'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Interactors'
!

TabWidget subclass:#Mac
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TabWidget
!

TabWidget subclass:#Window
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TabWidget
!

!TabWidget class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    instances represent (& draw) the tabs of a tabWidget.

    [author:]
        Claus Atzkern

    [see also:]
        TabView
"
! !

!TabWidget class methodsFor:'instance creation'!

labels:aList for:aTabView
    "create tabs based on labels for a tabview
    "
    |list maxX maxY lftIns topIns level style|

    maxX   := 0.
    maxY   := 0.
    style  := aTabView style.
    lftIns := style at:#labelLeftInset.
    topIns := style at:#labelTopInset.
    level  := style at:#tabLevel.

    aTabView device isNil ifTrue:[
        self error:'Tabview has no device'
    ].

    list := aList collect:[:anEntry||y x tab lbl|
        tab := self new label:anEntry for:aTabView.
        lbl := tab printableLabel.

        (y := lbl heightOn:aTabView) > maxY ifTrue:[maxY := y].
        (x := lbl  widthOn:aTabView) > maxX ifTrue:[maxX := x].

        tab
    ].

    style at:#labelMaxX put:maxX.
    style at:#labelMaxY put:maxY.

    maxY  := maxY + topIns
                  + (style at:#labelBottomInset)
                  + (2 * level).

    maxX := maxX + lftIns + (style at:#labelRightInset).

    style at:#maxX put:maxX.
    style at:#maxY put:maxY.
    style at:#labelAnchor put:( lftIns @ (topIns +level) ).

    self validateDimensions:style.
    maxY := style at:#maxY.
    maxX := style at:#maxX.

 "/ caused by vertical layout for images
    maxX < maxY ifTrue:[style at:#maxX put:maxY].
  ^ list

    "Modified: / 4.5.1999 / 02:15:33 / cg"
!

validateDimensions:aStyle
    "validate dimensions for a style; could be redifined
    "
! !

!TabWidget class methodsFor:'accessing'!

computeColorsOn:aView style:aStyle
    "set colors dependent on selection color
    "
    |viewsDevice unselectedColor selectedColor avgSelectedColor avgUnSelectedColor|

    viewsDevice := aView device.

    selectedColor   := aView viewBackground.
    unselectedColor := selectedColor lightened.
    avgSelectedColor := selectedColor averageColorIn:(0@0 corner:7@7).
    avgUnSelectedColor := unselectedColor averageColorIn:(0@0 corner:7@7).

    aStyle at:#shadowColorSelected put:(avgSelectedColor darkened onDevice:viewsDevice).
    aStyle at:#lightColorSelected put:(avgSelectedColor lightened onDevice:viewsDevice).
    aStyle at:#shadowColorUnselected put:(avgUnSelectedColor darkened onDevice:viewsDevice).
    aStyle at:#lightColorUnselected put:(avgUnSelectedColor lightened onDevice:viewsDevice).

    aStyle at:#unselectedColor    put:unselectedColor.
    aStyle at:#selectedColor      put:selectedColor.
    aStyle at:#labelColor         put:Color black.

    "Modified: / 4.5.1999 / 02:16:32 / cg"
!

computeColorsOn:aView style:aStyle selectionColor:aSelectedColor
    "set colors dependent on selection color
    "
    |viewsDevice unselectedColor selectedColor avgSelectedColor avgUnSelectedColor|

    "/ CG: this seems to be no longer needed ...

    viewsDevice := aView device.

    unselectedColor := aView viewBackground.
    selectedColor   := unselectedColor lightened.

    avgSelectedColor := selectedColor averageColorIn:(0@0 corner:7@7).
    avgUnSelectedColor := unselectedColor averageColorIn:(0@0 corner:7@7).

    aStyle at:#shadowColorSelected put:(avgSelectedColor darkened onDevice:viewsDevice).
    aStyle at:#lightColorSelected put:(avgSelectedColor lightened onDevice:viewsDevice).
    aStyle at:#shadowColorUnselected put:(avgUnSelectedColor darkened onDevice:viewsDevice).
    aStyle at:#lightColorUnselected put:(avgUnSelectedColor lightened onDevice:viewsDevice).

    aStyle at:#unselectedColor    put:unselectedColor.
    aStyle at:#selectedColor      put:selectedColor.
    aStyle at:#labelColor         put:Color black.
!

tabStyleOn:aView
    "returns default tab style
    "
    |style|

    style := IdentityDictionary new.

    style at:#widget put:self.
    self computeColorsOn:aView style:style.

    style at:#expandSelection    put:0@0.    "/ expand selection extent x y when raised
    style at:#tabLevel           put:0.      "/ level
    style at:#labelTopInset      put:4.      "/ additional top label inset
    style at:#labelBottomInset   put:4.      "/ additional bottom inset
    style at:#labelLeftInset     put:4.      "/ label left  inset
    style at:#labelRightInset    put:4.      "/ label right inset
    style at:#rightCovered       put:0.      "/ covers right tab for n pixels

  ^ style

    "Modified: / 4.5.1999 / 02:15:50 / cg"
!

widgetClass:aWidget
    |wdgt name|

    name := aWidget asString.
    wdgt := Smalltalk classNamed:( self name asString, '::', name ).

    wdgt notNil ifTrue:[
        ^ wdgt
    ].
    ^ Smalltalk classNamed:name
! !

!TabWidget methodsFor:'accessing'!

label
    ^ label
!

lineNr
    "returns line number
    "
    ^ lineNr
!

lineNr:aLineNr
    "change line number
    "
    lineNr := aLineNr
!

printableLabel

    |lbl dev|

    printableLabel notNil ifTrue:[
        ^ printableLabel
    ].

    model isNil ifTrue:[
        lbl := label
    ] ifFalse:[
        lbl := model rawLabel
    ].

    dev := tabView device.

    lbl isImage ifTrue:[
        labelType := #image.
        printableLabel := lbl onDevice:dev.
        disabledLabel  := printableLabel lightened onDevice:dev. 
    ] ifFalse:[
        labelType := #string.

        printableLabel := lbl ? ''.
        disabledLabel  := printableLabel copy.

        lbl class == LabelAndIcon ifTrue:[
            lbl := printableLabel icon onDevice:dev.
            printableLabel icon:lbl.
            disabledLabel  icon:(lbl lightened onDevice:dev). 
        ]
    ].
  ^ printableLabel
! !

!TabWidget methodsFor:'accessing-dimensions'!

anchor
    "returns the tab origin
    "
    ^ anchor

!

anchor:anAnchor
    "change the tab anchor; no redraw
    "
    anchor := anAnchor

!

anchor:anAnchor extent:anExtent
    "change anchor and extent; no redraw
    "
    anchor := anAnchor.
    extent := anExtent.


!

extent
    "return the tab extent
    "
    ^ extent
!

extent:anExtent
    "change the tab extent; no redraw
    "
    extent := anExtent
!

preferredExtentX
    "returns my preferred extent x
    "
    ^    (tabView styleAt:#maxX)
       - (tabView styleAt:#labelMaxX)
       + (self printableLabel widthOn:tabView).
!

preferredExtentY
    "returns my preferred extent y
    "
    ^    (tabView styleAt:#maxY)
       - (tabView styleAt:#labelMaxY)
       + (self printableLabel heightOn:tabView).
! !

!TabWidget methodsFor:'basic drawing'!

redrawAtBottom:isSelected
    "redraw tab at bottom of view
    "
    ^ self subclassResponsibility
!

redrawAtLeft:isSelected
    "redraw tab at left of view
    "
    ^ self subclassResponsibility
!

redrawAtRight:isSelected
    "redraw tab at right of view
    "
    ^ self subclassResponsibility
!

redrawAtTop:isSelected
    "redraw tab at top of view
    "
    ^ self subclassResponsibility
! !

!TabWidget methodsFor:'change & update'!

labelChanged
    printableLabel := nil
! !

!TabWidget methodsFor:'drawing'!

redraw:isSelected
    "redraw the receiver tab"

    |direction|

    direction := tabView direction.

    direction == #top ifTrue:[
        self redrawAtTop:isSelected
    ] ifFalse:[
        direction == #bottom ifTrue:[
            self redrawAtBottom:isSelected
        ] ifFalse:[
            direction == #right ifTrue:[ self redrawAtRight:isSelected ]
                               ifFalse:[ self redrawAtLeft:isSelected ]
        ]
    ].
    self redrawLabel
!

redrawLabel
    "redraw label only
    "
    |fg direction origin originX originY anchor anchorX anchorY x y label|

    label     := self printableLabel.
    direction := tabView direction.
    anchor    := tabView styleAt:#labelAnchor.
    anchorX := anchor x.
    anchorY := anchor y.
    origin    := self computeOrigin.
    originX := origin x.
    originY := origin y.

 "/ set label color

    self printableLabel.

    self isEnabled ifTrue:[
        label := printableLabel.
        (model notNil and:[(fg := model foregroundColor) notNil]) ifTrue:[
            fgColor = fg ifFalse:[
                fgColor := fg onDevice:(tabView device)
            ].
            tabView paint:fgColor
        ] ifFalse:[
            tabView paintColor:#labelColor
        ]
    ] ifFalse:[
        label := disabledLabel.
        tabView paintColor:#shadowColorUnselected.
    ].

    (direction == #top or:[direction == #bottom]) ifTrue:[
        y := originY.
        x := originX + anchorX.

        direction == #top ifTrue:[
            y := y + anchorY.
        ] ifFalse:[
            y := y - anchorY - (label heightOn:tabView).
        ].
        labelType == #string ifTrue:[
            y := y + tabView fontAscent
        ].
    ] ifFalse:[
        direction == #right ifTrue:[
            x := originX - anchorY - (label heightOn:tabView).
        ] ifFalse:[
            x := originX + anchorY.
        ].
        y := originY + anchorX.

        labelType == #string ifTrue:[
            x := x + tabView fontDescent.
            "/ workaround for a bug in display-with-angle,
            "/ iff displayed string is a labelAndIcon.
            "/ (In this case, display is always opaque, and the current
            "/  backgroundPaint color is used to fill the underlying rectangle)
            "/
            tabView backgroundPaint:(tabView getBackgroundPaintForTab:self).
            tabView displayString:label x:x y:y angle:90.
          ^ self.
        ].
    ].
    label displayOn:tabView x:x y:y.
! !

!TabWidget methodsFor:'initialization'!

label:aLabel for:aTabView
    "initialize attributes
    "
    tabView := aTabView.
    label   := aLabel.
    model   := (label isKindOf:TabItem) ifTrue:[label] ifFalse:[nil]
        
! !

!TabWidget methodsFor:'private'!

computeCorner
    "compute corner"

    |d c|

    c := anchor + extent.
    d := tabView direction.

    d == #top    ifTrue:[^ ( c x @ (tabView extent y) )].
    d == #left   ifTrue:[^ ( (tabView extent x) @ c y ) ].
    d == #right  ifTrue:[^ ( 0 @ c y )].
    d == #bottom ifTrue:[^ ( c x @ 0 )].

    self error:'unknown direction'.
!

computeOrigin
    "compute origin"

    |d|

    d := tabView direction.

    d == #top    ifTrue:[ ^ anchor x @ ((tabView extent y) - anchor y) ].
    d == #left   ifTrue:[ ^ ((tabView extent x) - anchor x) @ anchor y ].
    d == #right  ifTrue:[ ^ anchor ].
    d == #bottom ifTrue:[ ^ anchor ].

    self error:'unknown direction'.
! !

!TabWidget methodsFor:'queries'!

containsPoint:aPoint
    "return true, if a point is contained in the tab
    "
    |d origin 
     originX "{ Class: SmallInteger }"
     originY "{ Class: SmallInteger }"
     w       "{ Class: SmallInteger }"
     h       "{ Class: SmallInteger }"
     x       "{ Class: SmallInteger }"
     y       "{ Class: SmallInteger }"|

    d := tabView direction.
    x := aPoint x.
    y := aPoint y.

    origin := self computeOrigin.
    originX := origin x.
    originY := origin y.
    w := extent x.
    h := extent y.

    (d == #top or:[d == #bottom]) ifTrue:[
        ((x >= originX) and:[x <= (originX + w)]) ifTrue:[
            d == #top ifTrue:[
                ^ ((y >=  originY) and:[y <= (originY + h)])
            ].
            ^ ((y <=  originY) and:[y >= (originY - h)])
        ]
    ] ifFalse:[
        ((y >= originY) and:[y <= (originY + h)]) ifTrue:[
            d == #right ifTrue:[
                ^ ((x <= originX) and:[x >= (originX - w)])
            ].
            ^ ((x >= originX) and:[x <= (originX + w)])
        ]
    ].
    ^ false
!

intersects:aRectangle
    "return true, if the intersection between the tab widget and
     the argument, aRectangle is not empty
    "
    |origin corner direction irect|

    origin := self computeOrigin.
    corner := self computeCorner.

    direction := tabView direction.

    direction == #top ifTrue:[
        irect := (Rectangle origin:origin corner:corner)
    ] ifFalse:[
        direction == #bottom ifTrue:[
            irect := (Rectangle origin:(origin x @ corner y) corner:(corner x @ origin y))
        ] ifFalse:[
            direction == #right ifTrue:[
                irect := (Rectangle origin:(corner x @ origin y) corner:(origin x @ corner y))
            ] ifFalse:[
                irect := (Rectangle origin:origin corner:corner)
	    ]
	]
    ].

    ^ aRectangle intersects:irect
!

isEnabled

    ^ (tabView isEnabled and:[(model isNil or:[model isEnabled])])

!

model
    ^ model

! !

!TabWidget::Mac class methodsFor:'accessing'!

tabStyleOn:aView
    |style|

    style := super tabStyleOn:aView.
    style at:#tabLevel put:2.
  ^ style.
! !

!TabWidget::Mac class methodsFor:'calculate dimensions'!

validateDimensions:aStyle
    "validate dimensions for a style; could be redifined
    "
    |maxY maxX anchor lftIns|

    maxY   := aStyle at:#maxY.
    maxX   := (aStyle at:#maxX) - (aStyle at:#labelLeftInset).
    anchor := aStyle at:#labelAnchor.
    lftIns := maxY // 2.

    anchor x:lftIns.

    aStyle at:#maxX         put:(maxX + lftIns + maxY).
    aStyle at:#rightCovered put:(maxY // 2).
! !

!TabWidget::Mac methodsFor:'drawing'!

redrawAtBottom:isSelected
    "redraw tab at bottom of view
    "
    |origin corner level polygon x y x1 eX eY shadowColor lightColor|

    isSelected ifFalse:[
        lightColor  := tabView styleAt:#lightColorUnselected.
        shadowColor := tabView styleAt:#shadowColorUnselected.
        tabView paint:(tabView styleAt:#unselectedColor).
    ] ifTrue:[
        lightColor  := tabView styleAt:#lightColorSelected.
        shadowColor := tabView styleAt:#shadowColorSelected.
        tabView paint:(tabView styleAt:#selectedColor).
    ].
    polygon := Array new:5.
    origin  := self computeOrigin.
    corner  := self computeCorner.
    level   := tabView styleAt:#tabLevel.

    x  := origin x.
    y  := origin y.
    eX := corner x.
    eY := corner y.
    x1 := eX - (tabView styleAt:#maxY).

    polygon at:1 put:(Point x:x  y:eY).
    polygon at:2 put:(Point x:x  y:y).
    polygon at:3 put:(Point x:x1 y:y).
    polygon at:4 put:(Point x:eX y:(y-extent y)).
    polygon at:5 put:(Point x:eX y:eY).

    tabView fillPolygon:polygon.
    tabView paint:lightColor.

    1 to:level do:[:i|
        "/ removed: cg
"/        tabView displayLineFromX:x+1 y:y-i toX:x1+i y:y-i.
        tabView displayLineFromX:x+i y:y-1 toX:x+i  y:1.
    ].
    tabView paint:shadowColor.

    "/ added: cg
    1 to:(level-2) do:[:i|
        tabView displayLineFromX:x+1 y:y-i toX:x1+i y:y-i.
    ].
    tabView displayPolygon:polygon.

    isSelected ifFalse:[
        tabView displayLineFromX:x y:eY toX:eX y:eY.
    ]

    "Modified: / 21.5.1998 / 01:16:32 / cg"
!

redrawAtLeft:isSelected
    "redraw tab at left of view
    "
    |origin corner polygon level x y y1 eX eY shadowColor lightColor|

    isSelected ifFalse:[
        lightColor  := tabView styleAt:#lightColorUnselected.
        shadowColor := tabView styleAt:#shadowColorUnselected.
        tabView paint:(tabView styleAt:#unselectedColor).
    ] ifTrue:[
        lightColor  := tabView styleAt:#lightColorSelected.
        shadowColor := tabView styleAt:#shadowColorSelected.
        tabView paint:(tabView styleAt:#selectedColor).
    ].
    polygon := Array new:5.
    origin  := self computeOrigin.
    corner  := self computeCorner.
    level   := tabView styleAt:#tabLevel.

    x  := origin x.
    y  := origin y.
    eX := corner x.
    eY := corner y.
    y1 := eY - (tabView styleAt:#maxY).

    polygon at:1 put:(Point x:eX           y:y).
    polygon at:2 put:(Point x:x            y:y).
    polygon at:3 put:(Point x:x            y:y1).
    polygon at:4 put:(Point x:(x+extent x) y:eY).
    polygon at:5 put:(Point x:eX           y:eY).

    tabView fillPolygon:polygon.
    tabView paint:lightColor.

    1 to:level do:[:i|
        tabView displayLineFromX:eX  y:y+i toX:x+2  y:y+i.
        tabView displayLineFromX:x+i y:y+1 toX:x+i  y:y1+i.
    ].
    tabView paint:shadowColor.
    tabView displayPolygon:polygon.

    isSelected ifFalse:[
        tabView displayLineFromX:eX-1 y:y toX:eX-1 y:eY.
    ]
!

redrawAtRight:isSelected
    "redraw tab at right of view
    "
    |origin corner level polygon x y y1 eY shadowColor lightColor|

    isSelected ifFalse:[
        lightColor  := tabView styleAt:#lightColorUnselected.
        shadowColor := tabView styleAt:#shadowColorUnselected.
        tabView paint:(tabView styleAt:#unselectedColor).
    ] ifTrue:[
        lightColor  := tabView styleAt:#lightColorSelected.
        shadowColor := tabView styleAt:#shadowColorSelected.
        tabView paint:(tabView styleAt:#selectedColor).
    ].
    polygon := Array new:5.
    origin  := self computeOrigin.
    corner  := self computeCorner.
    level   := tabView styleAt:#tabLevel.

    x  := origin x.
    y  := origin y.
    eY := corner y.
    y1 := eY - (tabView styleAt:#maxY).

    polygon at:1 put:(Point x:0            y:y).
    polygon at:2 put:(Point x:x            y:y).
    polygon at:3 put:(Point x:x            y:y1).
    polygon at:4 put:(Point x:(x-extent x) y:eY).
    polygon at:5 put:(Point x:0            y:eY).

    tabView fillPolygon:polygon.
    tabView paint:lightColor.

    1 to:level do:[:i|
        tabView displayLineFromX:0   y:y+i toX:x-1  y:y+i.
        "/ removed: cg
"/        tabView displayLineFromX:x-i y:y+1 toX:x-i  y:y1+i.
    ].
    tabView paint:shadowColor.
    tabView displayPolygon:polygon.

    "/ added: cg
    1 to:level-2 do:[:i|
        tabView displayLineFromX:x-i y:y+1 toX:x-i  y:y1+i.
    ].

    isSelected ifFalse:[
        tabView displayLineFromX:0 y:y toX:0 y:eY.
    ]

    "Modified: / 21.5.1998 / 01:16:24 / cg"
!

redrawAtTop:isSelected
    "redraw tab at top of view
    "
    |origin corner level polygon x y x1 eX eY shadowColor lightColor|

    isSelected ifFalse:[
        lightColor  := tabView styleAt:#lightColorUnselected.
        shadowColor := tabView styleAt:#shadowColorUnselected.
        tabView paint:(tabView styleAt:#unselectedColor).
    ] ifTrue:[
        lightColor  := tabView styleAt:#lightColorSelected.
        shadowColor := tabView styleAt:#shadowColorSelected.
        tabView paint:(tabView styleAt:#selectedColor).
    ].
    polygon := Array new:5.
    origin  := self computeOrigin.
    corner  := self computeCorner.
    level   := tabView styleAt:#tabLevel.

    x  := origin x.
    y  := origin y.
    eX := corner x - 1.
    eY := corner y.
    x1 := eX - (tabView styleAt:#maxY).

    polygon at:1 put:(Point x:x  y:eY).
    polygon at:2 put:(Point x:x  y:y).
    polygon at:3 put:(Point x:x1 y:y).
    polygon at:4 put:(Point x:eX y:(y+extent y)).
    polygon at:5 put:(Point x:eX y:eY).

    tabView fillPolygon:polygon.
    tabView paint:lightColor.

    1 to:level do:[:i|
        tabView displayLineFromX:x+i y:eY  toX:x+i  y:y+1.
        tabView displayLineFromX:x+1 y:y+i toX:x1+i y:y+i.
    ].
    tabView paint:shadowColor.
    tabView displayPolygon:polygon.

    isSelected ifFalse:[
        tabView displayLineFromX:x y:eY-1 toX:eX y:eY-1.
    ]


! !

!TabWidget::Window class methodsFor:'accessing'!

tabStyleOn:aView
    |style|

    style := super tabStyleOn:aView.

    style at:#expandSelection    put:4@4.
    style at:#tabLevel           put:2.
    style at:#labelTopInset      put:0.
    style at:#labelBottomInset   put:0.
    style at:#roundedEdges       put:true.
  ^ style

    "Modified: / 20.5.1999 / 19:18:04 / cg"
! !

!TabWidget::Window class methodsFor:'calculate dimensions'!

validateDimensions:aStyle
    "validate dimensions for a style; could be redifined
    "
    |maxY anchor|

    (aStyle at:#roundedEdges) ifTrue:[
        maxY := aStyle at:#maxY.
        aStyle at:#maxY put:(maxY + 3).
        anchor := aStyle at:#labelAnchor.
        anchor y:(anchor y + 1).
        aStyle at:#labelAnchor put:anchor.
    ]





! !

!TabWidget::Window methodsFor:'drawing'!

redrawAtBottom:isSelected
    "redraw tab at bottom of view
    "
    |origin corner y x xR yB tabLevel roundedEdges shadowColor lightColor|

    origin := self computeOrigin.
    corner := self computeCorner.
    x   := origin x.
    y   := origin y.
    xR  := corner x - 1.
    yB  := 0.

    roundedEdges := tabView styleAt:#roundedEdges.
    tabLevel     := (tabView styleAt:#tabLevel) - 1.

    isSelected ifFalse:[
        tabView paint:(tabView styleAt:#unselectedColor).
        shadowColor := tabView styleAt:#shadowColorUnselected.
        lightColor  := tabView styleAt:#lightColorUnselected.
    ] ifTrue:[
        tabView paint:(tabView styleAt:#selectedColor).
        shadowColor := tabView styleAt:#shadowColorSelected.
        lightColor  := tabView styleAt:#lightColorSelected.
    ].

    roundedEdges ifTrue:[y := y - 2].
    tabView fillRectangle:(Rectangle left:x top:yB extent:(extent x @ y)).

    roundedEdges ifTrue:[
        tabView displayLineFromX:x-1 y:y toX:xR y:y.
        y := y - 1.

        tabView paint:lightColor.
        tabView displayPointX:x   y:y+1.
        tabView displayPointX:x+1 y:y+1.

        tabView paint:shadowColor.
        tabView displayLineFromX:x+1 y:y+2 toX:xR-1 y:y+2.
        tabView displayLineFromX:x+2 y:y+3 toX:xR-2 y:y+3.

        0 to:tabLevel do:[:i |
            tabView displayPointX:xR-i   y:y.
            tabView displayPointX:xR-i   y:y+1.
            tabView displayPointX:xR-1-i y:y+2.
        ].
        tabView displayPointX:xR-2 y:y+3.
        tabView displayPointX:xR-3 y:y+3.
    ].

    tabView paint:lightColor.

    0 to:tabLevel do:[:i |
        roundedEdges ifFalse:[
            tabView displayLineFromX:x y:y-i toX:xR y:y-i   "/ upper edge
        ].
        tabView displayLineFromX:x+i y:y+1 toX:x+i y:yB.    "/ left edge
    ].
    y := y + 1.
    tabView paint:shadowColor.

    0 to:tabLevel do:[:i |
        tabView displayLineFromX:xR-i y:y-i toX:xR-i y:yB.  "/ right edge
    ].

    "Modified: / 21.5.1998 / 01:07:01 / cg"
!

redrawAtLeft:isSelected
    "redraw tab at left of view
    "
    |origin corner y x xR yB tabLevel roundedEdges shadowColor lightColor|

    origin := self computeOrigin.
    corner := self computeCorner.
    x   := origin x.
    y   := origin y.
    xR  := corner x.
    yB  := corner y.

    roundedEdges := tabView styleAt:#roundedEdges.
    tabLevel     := (tabView styleAt:#tabLevel) - 1.

    isSelected ifFalse:[
        tabView paint:(tabView styleAt:#unselectedColor).
        shadowColor := tabView styleAt:#shadowColorUnselected.
        lightColor  := tabView styleAt:#lightColorUnselected.
    ] ifTrue:[
        tabView paint:(tabView styleAt:#selectedColor).
        shadowColor := tabView styleAt:#shadowColorSelected.
        lightColor  := tabView styleAt:#lightColorSelected.
    ].
    tabView fillRectangle:(Rectangle left:x top:y extent:(xR @ extent y)).

    roundedEdges ifTrue:[
        tabView displayLineFromX:x y:y toX:x y:yB.

        tabView paint:lightColor.
        tabView displayPointX:x y:y+1.
        tabView displayPointX:x y:y+2.
        tabView displayLineFromX:x-1 y:y+2 toX:x-1 y:yB-1.
        tabView displayLineFromX:x-2 y:y+3 toX:x-2 y:yB-1.

        tabView paint:shadowColor.

        0 to:tabLevel do:[:i |
            tabView displayPointX:x   y:yB-i.
            tabView displayPointX:x-1 y:yB-i-1.
            tabView displayPointX:x-2 y:yB-i-2.
        ].
    ].
    tabView paint:lightColor.

    0 to:tabLevel do:[:i |
        roundedEdges ifFalse:[
            tabView displayLineFromX:x+i y:y+i toX:x+i y:yB.    "/ upper edge
        ].
        tabView displayLineFromX:x y:y+i toX:xR y:y+i.          "/ left edge
    ].
    tabView paint:shadowColor.

    0 to:tabLevel do:[:i |
        tabView displayLineFromX:x+i y:yB-i toX:xR y:yB-i.       
    ].

!

redrawAtRight:isSelected
    "redraw tab at right of view
    "
    |origin corner y x xR yB tabLevel roundedEdges shadowColor lightColor|

    origin := self computeOrigin.
    corner := self computeCorner.
    x   := origin x.
    y   := origin y.
    xR  := corner x - 1.
    yB  := corner y.

    roundedEdges := tabView styleAt:#roundedEdges.
    tabLevel     := (tabView styleAt:#tabLevel) - 1.

    isSelected ifFalse:[
        tabView paint:(tabView styleAt:#unselectedColor).
        shadowColor := tabView styleAt:#shadowColorUnselected.
        lightColor  := tabView styleAt:#lightColorUnselected.
    ] ifTrue:[
        tabView paint:(tabView styleAt:#selectedColor).
        shadowColor := tabView styleAt:#shadowColorSelected.
        lightColor  := tabView styleAt:#lightColorSelected.
    ].
    tabView fillRectangle:(Rectangle left:0 top:y extent:(x @ extent y)).

    roundedEdges ifTrue:[
        tabView displayLineFromX:x y:y toX:x y:yB.

        tabView paint:lightColor.
        tabView displayPointX:x y:y+1.
        tabView displayPointX:x y:y+2.

        tabView paint:shadowColor.
        tabView displayLineFromX:x+1 y:y+2 toX:x+1 y:yB-1.
        tabView displayLineFromX:x+2 y:y+3 toX:x+2 y:yB-1.

        0 to:tabLevel do:[:i |
            tabView displayPointX:x   y:yB-i.
            tabView displayPointX:x+1 y:yB-i-1.
            tabView displayPointX:x+2 y:yB-i-2.
        ].
    ].
    tabView paint:lightColor.

    0 to:tabLevel do:[:i |
        roundedEdges ifFalse:[
            tabView displayLineFromX:x-i y:y+i toX:x-i y:yB.    "/ upper edge
        ].
        tabView displayLineFromX:x y:y+i+1 toX:0 y:y+i+1.       "/ left edge
    ].
    tabView paint:shadowColor.

    0 to:tabLevel do:[:i |
        tabView displayLineFromX:x-i+1 y:yB-i toX:1 y:yB-i.       
    ].

    "Modified: / 21.5.1998 / 01:04:41 / cg"
!

redrawAtTop:isSelected
    "redraw tab at top of view
    "
    |origin corner y x xR yB tabLevel roundedEdges shadowColor lightColor|

    origin := self computeOrigin.
    corner := self computeCorner.
    x   := origin x.
    y   := origin y.
    xR  := corner x - 1.
    yB  := corner y.

    roundedEdges := tabView styleAt:#roundedEdges.
    tabLevel     := (tabView styleAt:#tabLevel) - 1.

    isSelected ifFalse:[
        tabView paint:(tabView styleAt:#unselectedColor).
        shadowColor := tabView styleAt:#shadowColorUnselected.
        lightColor  := tabView styleAt:#lightColorUnselected.
    ] ifTrue:[
        tabView paint:(tabView styleAt:#selectedColor).
        shadowColor := tabView styleAt:#shadowColorSelected.
        lightColor  := tabView styleAt:#lightColorSelected.
    ].

    roundedEdges ifTrue:[ y :=  y + 2].
    tabView fillRectangle:(Rectangle left:x top:y extent:((extent x) @ yB)).

    roundedEdges ifTrue:[
        y :=  y + 1.
        tabView displayLineFromX:x y:y-1   toX:xR y:y-1.          
        tabView displayLineFromX:x+1 y:y-2 toX:xR-1 y:y-2.
        tabView displayLineFromX:x+2 y:y-3 toX:xR-2 y:y-3.
        
        tabView paint:lightColor.

        0 to:tabLevel do:[:i |
            tabView displayPointX:x+i y:y-1.
            tabView displayPointX:x+1+i y:y-1-1.
            tabView displayLineFromX:x+2+i y:y-3-i toX:xR-1-i y:y-3-i.  "/ top
        ].

        tabView paint:shadowColor.
        0 to:tabLevel do:[:i |
            tabView displayPointX:xR-i y:y.
            tabView displayPointX:xR-i y:y-1.
            tabView displayPointX:xR-1-i y:y-1-1.
        ].
        tabView displayPointX:xR-2 y:y-1-1-1.
        tabView displayPointX:xR-3 y:y-1-1-1.
    ].

    tabView paint:lightColor.
    0 to:tabLevel do:[:i |
        roundedEdges ifFalse:[
            tabView displayLineFromX:x y:y+i toX:xR y:y+i.    "/ upper edge
        ].
        tabView displayLineFromX:x+i y:y toX:x+i y:yB.    "/ left edge
    ].
    tabView paint:shadowColor.
    0 to:tabLevel do:[:i |
        tabView displayLineFromX:xR-i y:y+i toX:xR-i y:yB.  "/ right edge
    ].
! !

!TabWidget class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

