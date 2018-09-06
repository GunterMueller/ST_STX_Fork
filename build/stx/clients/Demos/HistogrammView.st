"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

View subclass:#HistogrammView
	instanceVariableNames:'labels values colors sep framed usedHeight showLabels
		labelPosition showValues'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!HistogrammView class methodsFor:'documentation'!

documentation
"
  this is a simple demo of a histogramView,
  displaying a bar-chart figure.
  This is a non MVC example - should be rewritten,
  to ask a model for its values ...

  see examples.


  [author:]
        Claus Gittinger
"
!

examples
"
  with numeric value above bars:
                                                                [exBegin]
    |v top|

    v := HistogrammView new.
    v labels:#(1992 1993 1994).
    v values:#(50 75 25).
    v colors:(Array with:Color red with:Color green with:Color blue).

    top := StandardSystemView label:'chewing gum sales'.
    top extent:400@400.
    top addSubView:v in:(0.0 @ 0.0 corner:1.0 @ 1.0) borderWidth:0.
    top open
                                                                [exEnd]
  no numeric value above bars:
                                                                [exBegin]
    |v top|

    v := HistogrammView new.
    v labels:#(1992 1993 1994).
    v values:#(50 75 25).
    v colors:(Array with:Color red with:Color green with:Color blue).
    v showValues:false.

    top := StandardSystemView label:'dentists income '.
    top addSubView:v in:(0.0 @ 0.0 corner:1.0 @ 1.0) borderWidth:0.
    top extent:400@400.
    top open
                                                                [exEnd]
  labels at bottom:
                                                                [exBegin]
    |v top|
    v := HistogrammView new.
    v labels:#('50''s' '60''s' '70''s' '80''s' '90''s ').
    v values:#(10 16 23 18 27).
    v labelPosition:#bottom.
    v showValues:true.

    top := StandardSystemView label:'chocolade sales (1000s)'.
    top addSubView:v in:(0.0 @ 0.0 corner:1.0 @ 1.0) borderWidth:0.
    top extent:400@400.
    top open
                                                                [exEnd]
"
! !

!HistogrammView methodsFor:'accessing'!

colors:aColorArray
    "set the bar colors; the argument must be a collection containing
     a color per bar"

    colors := aColorArray
!

framed:aBoolean
    "turn framing on/off"

    framed := aBoolean
!

labelPosition:aSymbol
    "set the labelPosition; the argument must be one of #top or #bottom"

    labelPosition := aSymbol
!

labels:aLabelArray
    "set the bar labels; the argument must be a collection containing
     a string per bar"

    labels := aLabelArray
!

separatingSpace:mm
    "set the bar interspacing in millimeters"

    sep := mm
!

showValues:aBoolean
    "turn valueDisplay on/off"

    showValues := aBoolean
!

values:aValueArray
    "set the values - for each value, a bar is drawn"

    values := aValueArray
! !

!HistogrammView methodsFor:'drawing'!

redraw
    "draw the bar-chart"

    |nRect rectWidth max x oneSpace allSpace|

    "get number of histogramm rectangles"

    nRect := values size.

    "actual width per rectangle"
    oneSpace := device horizontalPixelPerMillimeter * sep.
    allSpace := oneSpace * (nRect + 1).
    rectWidth := (width - allSpace) // nRect.

    "find max. value"
    max := values inject:0 into:[:currentMax :current | current max:currentMax].

    self fill:Color white.
    x := oneSpace.
    values keysAndValuesDo:[:index :value |
        |rH color|

        rH := (height * usedHeight * (value / max)) rounded.
        (colors notNil and:[(colors at:index) notNil]) ifTrue:[
            color := (colors at:index)
        ] ifFalse:[
            color := Color grey.
        ].
        self paint:color.
        self fillRectangleX:x rounded y:(height - rH) width:rectWidth rounded height:rH.
        framed ifTrue:[
            self paint:Color black.
            self displayRectangleX:x rounded y:(height - rH) width:rectWidth rounded height:rH
        ].
        (labels notNil and:[(labels at:index) notNil]) ifTrue:[
            showLabels ifTrue:[
                |l xOffset xPosition yPosition|

                l := (labels at:index) printString.
                xOffset := (rectWidth - (font widthOf:l)) / 2.
                xPosition := (x + xOffset) rounded.

                labelPosition == #top ifTrue:[
                    yPosition := font ascent.
                    self paint:Color black
                ] ifFalse:[
                    yPosition := height - (font descent * 2).
                    color brightness < 0.5 ifTrue:[
                        self paint:Color white
                    ] ifFalse:[
                        self paint:Color black
                    ].
                ].
                self displayString:l
                                 x:xPosition
                                 y:yPosition.
            ].
        ].
        showValues ifTrue:[
            |l xOffset xPosition yPosition|

            l := value printString.
            xOffset := (rectWidth - (font widthOf:l)) / 2.
            xPosition := (x + xOffset) rounded.
            yPosition := height - rH - (font descent * 2).
            self paint:color.
            self displayString:l
                             x:xPosition
                             y:yPosition.
        ].
        x := x + rectWidth + oneSpace
    ]
!

sizeChanged:how
    super sizeChanged:how.
    self redraw
! !

!HistogrammView methodsFor:'initialization'!

initialize
    super initialize.
    framed := true.
    sep := 1.
    usedHeight := 0.75.
    showLabels := true.
    labelPosition := #top.
    showValues := true.
! !

!HistogrammView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/HistogrammView.st,v 1.7 2008-12-17 16:05:12 cg Exp $'
! !
