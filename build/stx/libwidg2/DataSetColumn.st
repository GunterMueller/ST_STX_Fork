"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
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

Object subclass:#DataSetColumn
	instanceVariableNames:'columnNumber dataSet width description buttonExtent rendererType
		backgroundColor foregroundColor rowSeparatorSelector
		showColSeparator showRowSeparator columnAlignment label
		containsText columnAdaptor descWidth descMinWidth
		longStringCompression minValue maxValue'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DataSet'
!

!DataSetColumn class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger / eXept Software AG
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
    represent one single column description of a DataSetView

    [Instance variables:]

        columnNumber    <Integer>               sequence number (into list of columns)

        dataSet         <DSVColumnView>         the view it belongs to

        width           <Integer>               width of column

        description     <DataSetColumnSpec>     the column description (a spec)

        buttonExtent    <Point>                 extent of drawable form

        rendererType    <Type>                  renderer type (cached value from
                                                the column specification).

        backgroundColor <Color or nil>          background color of all cells or nil
                                                (nil: use default background color).

        foregroundColor <Color or nil>          foreground color of all cells or nil
                                                (nil: use default foreground color).

        columnAlignment <Symbol>                align text/icon #left #right or #center
                                                in row (on default: #left).

        label           <label/icon or nil>     label resolved by the builder shown
                                                in the column description field.

        readSelector    <Symbol>                cached readSelector (from the spec)

        columnAdaptor   <nil or any>            if non-nil, that one is asked (via
                                                read-writeSelectors to extract a column
                                                from a row object.
                                                If nil, the row object is used itself.

        showColSeparator <Boolean>              true: vertical separators are enabled;
                                                separator between columns

        showRowSeparator <Boolean>              true: horizontal separators are enabled;
                                                separator between rows

        rowSeparatorSelector <Selector or nil>  access specific showRowSeparator state
                                                for a cell

    [from description:]
        fgSelector      <Selector or nil>       access specific foreground color for
                                                a cell

        bgSelector      <Selector or nil>       access specific background color for
                                                a cell

        numberOfRowsProbedForColumnSize         the number of rows which are queries
                                <Integer>       in order to compute the columns width.
                                                (for scrollBar/col width computation)
                                                Notice, if its expensive to fetch rows
                                                (dataBase apps), this should be small.
                                                Default:15


    [author:]
        Claus Atzkern

    [see also:]
        DataSetColumnSpec
        DSVColumnView
        DataSetView
"
! !

!DataSetColumn class methodsFor:'utilities'!

shortenedStringFor:aString on:aGC maxWidth:maxWidth
    "common code to shorten a string; used in both the DSV label- and column Views,  
     if the string is too long for the column"

    |widthOf3Dots wRest shortenedLabel lUsed lMin lMax|

    aString isString ifFalse:[^ aString].
    (aString widthOn:aGC) <= maxWidth ifTrue:[^ aString].

    widthOf3Dots := '...' widthOn:aGC.

    lMin := 1.
    lMax := aString size.
    [ 
        lUsed := (lMax + lMin) // 2.
        wRest := aString widthFrom:1 to:lUsed on:aGC.
        wRest > (maxWidth-widthOf3Dots) ifTrue:[
            lMax := lUsed - 1.
        ] ifFalse:[
            lMin := lUsed + 1.
        ].
        lMin < lMax
    ] whileTrue.
    shortenedLabel := aString copyFrom:1 to:lUsed.

    shortenedLabel isEmpty ifTrue:[
        ((aString first asString , '..') widthOn:aGC) < maxWidth ifTrue:[
            "/ only two dots and the first character
            ^ (aString first asString , '..')
        ]
    ].
    ^ (shortenedLabel , '...').
! !

!DataSetColumn methodsFor:'accessing'!

activeHelpText
    "get the active helpText or nil"

    |app key|

    ((key := description activeHelpKey) notEmptyOrNil 
    and:[(app := dataSet application) notNil]) ifTrue:[
        ^ app flyByHelpTextForKey:key asSymbol.
    ].
    ^ nil

    "Created: / 26-03-2007 / 13:39:11 / cg"
    "Modified: / 26-03-2007 / 17:51:15 / cg"
!

activeHelpTextForLabel
    "get the active helpText for the label or nil"

    |app key|

    ((key := description activeHelpKeyForLabel) notEmptyOrNil 
    and:[(app := dataSet application) notNil]) ifTrue:[
        ^ app flyByHelpTextForKey:key asSymbol.
    ].
    ^ nil

    "Created: / 26-03-2007 / 13:39:11 / cg"
    "Modified: / 26-03-2007 / 17:51:15 / cg"
!

activeHelpTextForRow:rowNr
    "get the active helpText or nil"

    |app key|

    ((key := description activeHelpKey) notEmptyOrNil 
    and:[(app := dataSet application) notNil]) ifTrue:[
        ^ app flyByHelpTextForKey:key asSymbol row:rowNr.
    ].
    ^ nil

    "Created: / 26-03-2007 / 13:39:11 / cg"
    "Modified: / 26-03-2007 / 17:51:15 / cg"
!

at:aRowNr
    "get the value of the cell at the row index, aRowNr"

    |row|

    row := dataSet at:aRowNr.
    ^ self extractColFromRow:row rowNr:aRowNr.
!

at:aRowNr put:something
    "set the value of the cell at the row index, aRowNr"

    |row|

    row := dataSet at:aRowNr.
    self storeCol:something inRow:row.
!

columnAdaptor
    ^ columnAdaptor
!

columnAdaptor:anAdapter
    columnAdaptor := anAdapter.
!

columnNumber
    ^ columnNumber
!

description
    "returns the column spec
    "
    ^ description
!

doubleClickedSelector
    ^ description doubleClickedSelector
!

label
    "get the label assigned to the column
    "
    ^ label


!

longStringCompression:aBoolean
    ^ longStringCompression ? true
!

rendererType
    "returns my renderer type
    "
    ^ rendererType
! !

!DataSetColumn methodsFor:'accessing-colors'!

backgroundColor
    "returns the background color or nil
    "
    ^ backgroundColor == dataSet backgroundColor ifTrue:[nil] ifFalse:[backgroundColor]
!

backgroundColor: aColor
    backgroundColor := aColor
!

backgroundColorAt:aRowNr
    "returns the background color for a row at list index a rowNr
    "
    description backgroundSelector notNil ifTrue:[
        ^ self backgroundColorFor:(dataSet at:aRowNr) at:aRowNr
    ].
    ^ backgroundColor
!

backgroundColorFor:aRow at:aRowNr     
    "return the background color for a row at list index a rowNr"

    "/ backgroundColor has already been fetched from description/dataSet (see #initialize)
    ^ self
        colorFor:aRow at:aRowNr 
        descriptionSelector:(description backgroundSelector) 
        descriptionColor:backgroundColor 
        dataSetDefaultColor:nil

    "Modified: / 26-03-2007 / 13:27:19 / cg"
!

colorFor:aRow at:aRowNr descriptionSelector:descriptionSelector descriptionColor:descriptionColor dataSetDefaultColor:dataSetColor    
    "common code for returning a color for a row at list index a rowNr, asking both description and dataSet as fallBack"

    |clr|

    descriptionSelector notNil ifTrue:[
        columnAdaptor notNil ifTrue:[
            clr := columnAdaptor perform:descriptionSelector withOptionalArgument:aRow and:aRowNr and:columnNumber and:dataSet
        ] ifFalse:[
            "/ Check if row-object responds to the color message...
            (aRow respondsTo: descriptionSelector) ifTrue:[
                clr := aRow perform:descriptionSelector withOptionalArgument:aRowNr and:columnNumber and:dataSet
            ] ifFalse:[ 
                "/ ...if not, send the message to the application model. This allows application models to
                "/ define visual aspects while data still could be extracted from the row-objects directly. 

                | app |

                app := dataSet application.
                app notNil ifTrue:[ 
                    clr := app perform:descriptionSelector withOptionalArgument:aRow and:aRowNr and:columnNumber and:dataSet
                ].
            ].
        ].
        clr notNil ifTrue:[
            (clr isColor or:[clr isImageOrForm]) ifTrue:[
                ^ clr
            ].
            self error:'unexpected color (not a color or image)'.
        ]
    ].
    ^ descriptionColor ? dataSetColor

    "Created: / 26-03-2007 / 13:05:24 / cg"
    "Modified: / 23-09-2014 / 11:35:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foregroundColor
    "returns the foreground color or nil
    "
    ^ foregroundColor == dataSet foregroundColor ifTrue:[nil] ifFalse:[foregroundColor]
!

foregroundColor: aColor
    foregroundColor := aColor
!

foregroundColorFor:aRow at:aRowNr
    "returns the foreground color for a row at list index a rowNr
    "

    "/ foregroundColor has already been fetched from description/dataSet (see #initialize)
    ^ self
        colorFor:aRow at:aRowNr 
        descriptionSelector:(description foregroundSelector) 
        descriptionColor:foregroundColor 
        dataSetDefaultColor:nil

    "Modified: / 26-03-2007 / 13:27:39 / cg"
!

selectedBackgroundColorFor:aRow at:aRowNr     
    "returns the selected background color for a row at list index a rowNr"

    ^ self
        colorFor:aRow at:aRowNr 
        descriptionSelector:(description selectedBackgroundSelector) 
        descriptionColor:(description selectedBackgroundColor) 
        dataSetDefaultColor:(dataSet selectionBackgroundColor)

    "Modified: / 26-03-2007 / 13:06:06 / cg"
!

selectedForegroundColorFor:aRow at:aRowNr     
    "returns the selected foreground color for a row at list index a rowNr"

    ^ self
        colorFor:aRow at:aRowNr 
        descriptionSelector:(description selectedForegroundSelector) 
        descriptionColor:(description selectedForegroundColor) 
        dataSetDefaultColor:(dataSet selectionForegroundColor)

    "Modified: / 26-03-2007 / 13:05:31 / cg"
!

selectedFrameColorFor:aRow at:aRowNr     
    "returns the selected frame color for a row at list index a rowNr"

    ^ self
        colorFor:aRow at:aRowNr 
        descriptionSelector:(description selectedBackgroundSelector) 
        descriptionColor:(description selectedBackgroundColor) 
        dataSetDefaultColor:(dataSet selectionFrameColor)

    "Created: / 20-01-2011 / 08:46:32 / cg"
! !

!DataSetColumn methodsFor:'accessing-dimension'!

minWidth
    "get the minimum width required by the column
    "
    descMinWidth notNil ifTrue:[
        ^ descMinWidth
    ].
    descWidth isInteger ifTrue:[
        ^ descWidth
    ].
    ^ 0.
"/   width := nil.
"/  ^ self width
!

minimumRequiredWidth
    "returns the minimum required width
    "
    |minWidth|

    descMinWidth notNil ifTrue:[
        minWidth := DSVLabelView tabSpacing max:2.
      ^ minWidth // 2 + minWidth
    ].

    minWidth := dataSet separatorSize + (2 * dataSet horizontalSpacing).
  ^ minWidth + label preferredWidth.
!

setDescWidth:aWidth
    "set a fixed width
    "
    descMinWidth := 1.
    descMinWidth := width := descWidth := self minimumRequiredWidth max:aWidth.
!

setWidth:pixels
    width := pixels
!

width
    "returns the width in pixels
     Warning:
        only the first numberOfRowsProbedForColumnSize are probed,
        in case the access is expensive (dataBase apps)
     If the descriptor defines a width, that is used, and the items
     are not probed at all."

    |max       "{ Class:SmallInteger }"
     listSize  "{ Class:SmallInteger }"|

    width notNil ifTrue:[^ width].              "/ already computed

    descMinWidth notNil ifTrue:[
        width := descMinWidth.
        ^ width
    ].

    (descWidth ~~ 0 and:[self hasRelativeWidth not "descWidth isLimitedPrecisionReal not"]) ifTrue:[
        width := descMinWidth := descWidth.
        ^ width
    ].

    width := description minWidth max:(label preferredWidth).

    self hasRelativeWidth ifTrue:[
        width := width max:(descWidth * dataSet innerWidth) rounded.
        ^ width
    ].

    containsText ifTrue:[
        "/ take maximum numberOfRowsProbedForColumnSize entries to calculate the width;
        "/ can be resized later if necessary
        listSize := dataSet size.
        max := listSize min:description numberOfRowsProbedForColumnSize.

        max ~~ 0 ifTrue:[
            1 to:max do:[:rowNr| |row|
                row := dataSet at:rowNr.
                width := width max:(self widthOfLabel:(self shownValueForRow:row rowNr:rowNr))
            ].
            width := width max:(self widthOfLabel:(self shownValueForRow:(dataSet at:listSize) rowNr:listSize))
        ].
        description editorType ~~ #None ifTrue:[
            width := width + (dataSet font widthOn:dataSet device)
        ].
    ] ifFalse:[
        max := 1
    ].
    width := width + buttonExtent x + dataSet separatorSize + (2 * dataSet horizontalSpacing).

    max ~~ 0 ifTrue:[
        descMinWidth := width.
        description usePreferredWidth ifTrue:[
            descWidth := width
        ]
    ].
    ^ width

    "Modified: / 25.2.2000 / 14:29:16 / cg"
!

width: aWidth
    self setWidth: aWidth

    "Created: / 11-04-2014 / 10:01:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DataSetColumn methodsFor:'drawing'!

drawLabel:aLabelToDraw atX:xLeft y:yTop
    "draw aLabelToDraw; handle columnAlignment"

    |drawnLabel x space prevClip mustUndoClip cachedWidth
     labelWidth leftPart leftShift indexOfFirstDigit indexOfFirstNonDigit|

    cachedWidth := self width.
    cachedWidth isNil ifTrue:[ ^ self ].

    space := dataSet horizontalSpacing.

    drawnLabel := aLabelToDraw.
    labelWidth := drawnLabel widthOn:dataSet.

    (longStringCompression ~~ false
     and:[ drawnLabel isString 
     and:[ labelWidth > cachedWidth]]) ifTrue:[
        drawnLabel := self class shortenedStringFor:drawnLabel on:dataSet maxWidth:cachedWidth-space.
        labelWidth := drawnLabel widthOn:dataSet.
    ].

    columnAlignment == #left ifTrue:[
        x  := xLeft + space.
    ] ifFalse:[
        (columnAlignment == #decimal
        or:[ columnAlignment == #decimalRight ]) ifTrue:[
            drawnLabel := drawnLabel asString.
            (drawnLabel includes:$.) ifTrue:[
                leftPart := drawnLabel upTo:$..
            ] ifFalse:[
                leftPart := drawnLabel.

                indexOfFirstDigit := drawnLabel findFirst:[:char | char isDigit].
                indexOfFirstDigit ~~ 0 ifTrue:[
                    indexOfFirstNonDigit := drawnLabel findFirst:[:char | char isDigit not] startingAt:indexOfFirstDigit+1.
                    indexOfFirstNonDigit ~~ 0 ifTrue:[
                        leftPart := drawnLabel copyTo:indexOfFirstNonDigit-1.
                    ].
                ].
            ].
            leftShift := leftPart widthOn:dataSet.
            columnAlignment == #decimalRight ifTrue:[
                "/ decimal at the right
                x := cachedWidth - ('9999' widthOn:dataSet) - leftShift.
            ] ifFalse:[
                "/ decimal at the middle
                x := (cachedWidth // 2) - leftShift.
            ].
        ] ifFalse:[
            x := cachedWidth - labelWidth.

            columnAlignment == #right ifTrue:[x := x - space]
                                     ifFalse:[x := x // 2].
        ].
    "/ cg: old code (did not right-align if string is larger than width
    "/        x := xLeft + (x max:0).

        "/ new code: always right-align.
        x := xLeft + x.

        "/ must clip left, if string is too large
        x < xLeft ifTrue:[
            "/ must clip ...
            prevClip := dataSet clippingBoundsOrNil.
            mustUndoClip := true.
            dataSet clippingBounds:(Rectangle 
                                left:xLeft top:yTop 
                                width:cachedWidth height:(drawnLabel heightOn:dataSet)).
        ].
    ].

"/    drawnLabel isImageOrForm ifTrue:[
"/        y := yTop.
"/    ] ifFalse:[
"/        y := (yTop + dataSet rowFontAscent)
"/    ].

"/    drawnLabel isString ifFalse:[
"/        y := yTop + (drawnLabel ascentOn:dataSet).
"/    ] ifTrue:[
"/        y := yTop + dataSet rowFontAscent
"/    ].
"/    drawnLabel displayOn:dataSet x:x y:y.

    dataSet displayLabel:drawnLabel x:x y:yTop.

    mustUndoClip == true ifTrue:[
        dataSet clippingBounds:prevClip    
    ].
!

drawLabelsAtX:xLeft y:yTop h:h from:start to:stop
    "redraw labels from start to stop"

    |fg y yT x hspace lblHg bg label row isSel cachedWidth lineColor|

    cachedWidth := self width.
    cachedWidth isNil ifTrue:[ ^ self ].

    yT := yTop.
    hspace := dataSet horizontalSpacing.

    start to:stop do:[:aRowNr|
        row := dataSet at:aRowNr ifAbsent:[^ self].
        y := yT.
        x := xLeft.

        "/ GET BACKGROUND AND FOREGROUND-COLOR
        "/ ===================================

        isSel := dataSet isSelected:aRowNr inColumn:columnNumber.

        (isSel and:[description showSelectionHighLighted]) ifTrue:[
            "/ SHOW SELECTED( MUST REDRAW BACKGROUND )
            "/ =======================================
            bg := self selectedBackgroundColorFor:row at:aRowNr.
            fg := self selectedForegroundColorFor:row at:aRowNr.

            dataSet paint:bg.
            dataSet fillRectangleX:x y:y width:cachedWidth height:h.

            dataSet hasRowSelection ifFalse:[
                lineColor := self selectedFrameColorFor:row at:aRowNr.
                lineColor notNil ifTrue:[
                    dataSet paint:lineColor.
                    dataSet displayRectangleX:x y:y width:cachedWidth height:h.
                ]
            ]
        ] ifFalse:[
            description backgroundSelector notNil ifTrue:[
                "/ MUST REDRAW BACKGROUND
                "/ ======================
                bg := self backgroundColorFor:row at:aRowNr.

                bg ~~ backgroundColor ifTrue:[
                    bg := dataSet colorOnDevice:bg
                ].
                dataSet paint:bg.
                dataSet fillRectangleX:x y:y width:cachedWidth height:h.
            ] ifFalse:[
                bg := backgroundColor
            ].

            fg := self foregroundColorFor:row at:aRowNr.

            fg ~~ foregroundColor ifTrue:[
                fg := dataSet colorOnDevice:fg
            ].
        ].

        "/ GET AND DRAW LABEL
        "/ ==================
        (self isRowVisible:aRowNr) ifTrue:[
            rendererType == #rowSelector ifTrue:[
                isSel ifTrue:[
                    label := dataSet rowSelectorForm.
                    x  := x + hspace.
                ] ifFalse:[
                    label := nil
                ]
            ] ifFalse:[
                (isSel and:[dataSet hasOpenEditor]) ifTrue:[
                    label := nil
                ]  ifFalse:[
                    label := self shownValueForRow:row rowNr:aRowNr
                ]
            ].
            label notNil ifTrue:[
                "/ care for a dark-colored label,
                "/ with a dark selection-bg color
                (isSel and:[label isString and:[label hasChangeOfEmphasis]]) ifTrue:[
                    "/ take away the label's own color info
                    label := label copy emphasisAllRemove:#color.
                ].

                lblHg := self heightOfLabel:label.

                lblHg ~~ 0 ifTrue:[
                    y := y + ((h - lblHg) // 2).
                    dataSet paint:fg on:bg.

                    (label isString and:[label includes:Character cr]) ifTrue:[
                        label := label asCollectionOfLines
                    ].

                    (label isNonByteCollection) ifTrue:[
                        "a collection of labels"
                        label do:[:el|
                            el notNil ifTrue:[
                                self drawLabel:el atX:x y:y.
                                y := y + (el heightOn:dataSet).
                            ]
                        ]
                    ] ifFalse:[
                        "a single label"
                        self drawLabel:label atX:x y:y
                    ].
                ]
            ].
        ].
        yT := yT + h
    ]

    "Modified: / 20-01-2011 / 08:50:18 / cg"
!

drawRendererInRow:rowNr x:xLeft y:y width:cellWidth value:cellValue
    (rendererType == #ComboBox or:[rendererType == #ComboList]) ifTrue:[
        (self hasChoices:rowNr) ifTrue:[
            dataSet drawComboButtonAtX:xLeft y:y w:cellWidth
        ].
        ^ self
    ].
    rendererType == #CheckToggle ifTrue:[
        dataSet drawCheckToggleAtX:xLeft y:y w:cellWidth state:cellValue.
        ^ self
    ].
    rendererType == #RadioButton ifTrue:[
         dataSet drawRadioButtonAtX:xLeft y:y w:cellWidth state:cellValue.
        ^ self
    ].
!

drawSeparatorsAtX:xLeft y:yTop h:h from:start to:stop
    "redraw separators for cells between start and stop
    "
    |cashedWidth is3D xL xR yB yT times|

    (showColSeparator or:[showRowSeparator]) ifFalse:[
        ^ self
    ].
    cashedWidth := self width.
    cashedWidth isNil ifTrue:[ ^ self ].

    is3D := dataSet has3Dseparators.

    is3D ifTrue:[dataSet paint:(dataSet separatorDarkColor)]
        ifFalse:[dataSet paint:(dataSet separatorOneDColor)].

    times := stop - start + 1.
    xL    := xLeft.
    xR    := xL - 1 + cashedWidth.

    showRowSeparator ifTrue:[
     "/ DRAW SEPARATORS AT BOTTOM( DARK COLOR )
     "/ =======================================
        yB := yTop - 1 + h.

        rowSeparatorSelector isNil ifTrue:[
            times timesRepeat:[
                dataSet displayLineFromX:xL y:yB toX:xR y:yB.
                yB := yB + h.
            ]
        ] ifFalse:[
            start to:stop do:[:idx|
                (self hasRowSeparatorAt:idx) ifTrue:[
                    dataSet displayLineFromX:xL y:yB toX:xR y:yB
                ].
                yB := yB + h.
            ].
        ].
    ].

    showColSeparator ifTrue:[
     "/ DRAW SEPARATORS AT RIGHT( DARK COLOR )
     "/ ======================================
        yT := yTop.

        times timesRepeat:[
            dataSet displayLineFromX:xR y:yT toX:xR y:(yT - 1 + h).
            yT := yT + h.
        ]
    ].

    is3D ifFalse:[
        ^ self
    ].

    dataSet paint:(dataSet separatorLightColor).

    (     columnNumber == 1
      or:[(dataSet columnDescriptorAt:(columnNumber - 1)) showColSeparator]
    ) ifTrue:[

     "/ DRAW SEPARATORS AT LEFT( LIGHT COLOR )
     "/ ======================================
        yT := yTop.

        times timesRepeat:[
            dataSet displayLineFromX:xL y:yT toX:xL y:(yT - 1 + h).
            yT := yT + h.
        ].
    ] ifFalse:[
        xL := xL - 1
    ].

    showRowSeparator ifTrue:[
     "/ DRAW SEPARATORS AT TOP( LIGHT COLOR )
     "/ =====================================
        yT := yTop.

        rowSeparatorSelector isNil ifTrue:[
            times timesRepeat:[
                dataSet displayLineFromX:xL y:yT toX:xR y:yT.
                yT := yT + h.
            ]
        ] ifFalse:[
         "/ CHECK WHETHER PREVIOUS ROW HAS A SEPARATOR AT BOTTOM
         "/ ====================================================
            start to:stop do:[:idx|
                (idx == 1 or:[self hasRowSeparatorAt:(idx - 1)]) ifTrue:[
                    dataSet displayLineFromX:xL y:yT toX:xR y:yT.
                ].
                yT := yT + h.
            ]
        ]
    ].
!

invalidate
    "invalidate width of column; forces a recomputation
    "
    width := nil.

!

redrawX:xLeft y:yTop h:h from:start to:stop
    "redraw all rows between start and stop"

    |rH y cashedWidth|

    cashedWidth := self width.
    cashedWidth isNil ifTrue:[ ^ self ].

    rH := dataSet rowHeight.

    description backgroundSelector isNil ifTrue:[
        dataSet paint:backgroundColor.
        dataSet fillRectangleX:xLeft y:yTop width:cashedWidth height:h
    ].

    "/ DRAW CELLS: BACKGROUND/FOREGROUND/LABEL
    "/ =======================================
    self drawLabelsAtX:xLeft y:yTop h:rH from:start to:stop.

    "/ DRAW RENDERED INDICATORS
    "/ ========================
    rendererType notNil ifTrue:[
        y := yTop.
        start to:stop do:[:rowNr|
            |state|

            (self isRowVisible:rowNr) ifTrue:[
                state := self at:rowNr.
                self drawRendererInRow:rowNr x:xLeft y:y width:cashedWidth value:state.
            ].
            y := y + rH.
        ].
    ].

    "/ DRAW SEPARATORS
    "/ ===============
    self drawSeparatorsAtX:xLeft y:yTop h:rH from:start to:stop
!

shownValueForRow:aRowOrNil rowNr:aRowNr
    |aRow selector format value type choices translatedChoices idx converter|

    rendererType == #CheckToggle ifTrue:[
        ^ nil
    ].
    rendererType == #RadioButton ifTrue:[
        ^ nil
    ].

    rendererType == #rowSelector ifTrue:[
        ^ nil
    ].

    aRow := aRowOrNil.
    aRowOrNil isNil ifTrue:[
        aRow := dataSet at:aRowNr.
    ].

    selector := description printSelector.
    selector notNil ifTrue:[
        ^ aRow 
            perform:selector 
            withOptionalArgument:dataSet and:columnNumber and:aRowNr and:dataSet.
    ].

    value := self extractColFromRow:aRow rowNr:aRowNr.
    description translatedChoices notNil ifTrue:[
        choices := self choicesFor:aRow at:aRowNr.
        idx := choices indexOf:value.
        idx ~~ 0 ifTrue:[
            translatedChoices := self translatedChoicesFor:aRow at:aRowNr.
            translatedChoices notNil ifTrue:[
                value := translatedChoices at:idx.
            ].
        ].
    ].

    selector := description formatSelector.
    selector notNil ifTrue:[
        format := aRow 
            perform:selector asSymbol
            withOptionalArgument:dataSet and:columnNumber and:aRowNr and:dataSet.
    ] ifFalse:[
        format := description formatString.
    ].
    format notNil ifTrue:[
"/ cannot remember what this was used for ...
"/        (idx := format indexOf:$.) ~~ 0 ifTrue:[
"/            idx := format size - idx
"/        ].
"/        format := '%0.', idx printString, 'f'.

        ^ value printStringFormat:format
    ].

    type := description type.
    type ~~ #string ifTrue:[
        converter := TypeConverter new perform:type.
        ^ converter getBlock value:value.
"/ cg: the code below is dangerous (tries to addDependent to Integers) !!
"/        converter model:value.
"/        ^ converter value.
    ].

    ^ value

    "Modified: / 28-07-2010 / 20:42:51 / cg"
! !

!DataSetColumn methodsFor:'editing'!

editorForRowAt:aRowNr
    "creates the editor for the row in a view and returns an editorAndModel, or nil"

    |val row|

    row := dataSet at:aRowNr ifAbsent:[^ nil].
    val := self extractColFromRow:row rowNr:aRowNr.

    val isText ifTrue:[val := val string].
    ^ description editorOn:row at:aRowNr column:self value:val usingAdaptor:columnAdaptor.

    "Modified: / 27-10-2007 / 10:26:15 / cg"
! !

!DataSetColumn methodsFor:'event handling'!

doesNotUnderstand:aMessage

    (description respondsTo:(aMessage selector)) ifTrue:[
        ^ aMessage sendTo:description
    ].
    ^ super doesNotUnderstand:aMessage

! !

!DataSetColumn methodsFor:'grow & shrink'!

growWidth:n
    "grow the width for n pixels
    "
    width := self width + n.


! !

!DataSetColumn methodsFor:'initialization'!

on:aDSVColumnView description:aDescription columnNumber:aNumber label:aLabel
    "instance creation; set attributes dependent on the description
    "
    columnNumber     := aNumber.
    dataSet          := aDSVColumnView.
    label            := aLabel.

    description      := aDescription.
    rendererType     := description rendererType.
    containsText     := (      rendererType ~~ #CheckToggle
                          and:[rendererType ~~ #RadioButton
                          and:[rendererType ~~ #rowSelector]]
                        ).
    descWidth        := description width.
    longStringCompression := description longStringCompression.

    description usePreferredWidth ifTrue:[
        descWidth := 0
    ].

    width      := nil.

    minValue := description minValue.
    maxValue := description maxValue.
    rowSeparatorSelector := description rowSeparatorSelector.

    showColSeparator := description showColSeparator.
    showRowSeparator := description showRowSeparator.
    columnAdaptor    := dataSet columnAdaptor.
    buttonExtent     := 0 @ 0.
    columnAlignment  := #left.

    (backgroundColor := description backgroundColor) isNil ifTrue:[
        backgroundColor := dataSet backgroundColor
    ] ifFalse:[
        backgroundColor := backgroundColor onDevice:dataSet device
    ].

    (foregroundColor := description foregroundColor) isNil ifTrue:[
        foregroundColor := dataSet foregroundColor
    ] ifFalse:[
        foregroundColor := foregroundColor onDevice:dataSet device
    ].

    rendererType == #CheckToggle ifTrue:[
        buttonExtent := dataSet checkToggleExtent.
        ^ self
    ].
    rendererType == #RadioButton ifTrue:[
        buttonExtent := dataSet radioButtonExtent.
        ^ self
    ].

    rendererType == #rowSelector ifTrue:[
        buttonExtent := dataSet rowSelectorExtent.
        ^ self
    ].

    (rendererType == #ComboBox or:[rendererType == #ComboList]) ifTrue:[
        buttonExtent := dataSet comboButtonExtent.
    ] ifFalse:[
        columnAlignment := description columnAlignment
    ].

    "Modified: / 25.2.2000 / 14:25:56 / cg"
! !

!DataSetColumn methodsFor:'private'!

extractColFromRow:aRow rowNr:rowNr
    |readSelector col numArgs|

    readSelector := description readSelector.
    readSelector isNil ifTrue:[^ nil].

    readSelector isBlock ifTrue:[
        "/ I don't use valueWithOptionalArgument:and:and:and: here, to make better use of inline caches...
        numArgs := readSelector numArgs.
        numArgs == 0 ifTrue:[
            ^ readSelector value
        ].
        numArgs == 1 ifTrue:[
            ^ readSelector value:aRow
        ].
        numArgs == 2 ifTrue:[
            ^ readSelector value:aRow value:columnNumber
        ].
        numArgs == 3 ifTrue:[
            ^ readSelector value:aRow value:columnNumber value:rowNr
        ].
        ^ readSelector value:aRow value:columnNumber value:rowNr value:dataSet
    ].

    columnAdaptor notNil ifTrue:[
        ^ columnAdaptor perform:readSelector withOptionalArgument:aRow and:columnNumber and:rowNr and:dataSet
    ].
    aRow isNil ifTrue:[^ nil].

    (aRow isDictionary) ifTrue:[
        col := aRow at:readSelector
    ] ifFalse:[
        col := aRow perform:readSelector withOptionalArgument:columnNumber and:rowNr and:dataSet.
    ].
    ^ col
!

storeCol:newValueArg inRow:aRow
    |writeSelector numArgs newValue|

    writeSelector := description writeSelector.
    writeSelector isNil ifTrue:[^ aRow].

    newValue := newValueArg.
    (newValue isNumber) ifTrue:[
        minValue notNil ifTrue:[
            newValue < minValue ifTrue:[
               newValue := minValue
            ]
        ].
        maxValue notNil ifTrue:[
            newValue > maxValue ifTrue:[
               newValue := maxValue
            ]
        ].
    ].

    numArgs := writeSelector numArgs.

    writeSelector isBlock ifTrue:[
        numArgs == 2 ifTrue:[
            ^ writeSelector value:newValue value:aRow
        ].
        ^ writeSelector value:newValue value:aRow value:columnNumber
    ].

    columnAdaptor notNil ifTrue:[
        numArgs == 2 ifTrue:[
            columnAdaptor perform:writeSelector with:aRow with:newValue.
            ^ self
        ].
        columnAdaptor perform:writeSelector with:aRow with:columnNumber with:newValue.
        ^ self
    ].

    (aRow isDictionary) ifTrue:[
        aRow at:writeSelector put:newValue
    ] ifFalse:[
        numArgs == 1 ifTrue:[
            aRow perform:writeSelector with:newValue
        ] ifFalse:[
            aRow perform:writeSelector with:columnNumber with:newValue
        ]
    ].
! !

!DataSetColumn methodsFor:'queries'!

canResize
    ^ containsText and:[descWidth == 0 or:[self hasRelativeWidth]]
!

canSelect:aRowNr
    "returns true if the cell in column is selectable.
     (possibly calls the selectSelector, if any)"

    |s row|

    description canSelect ifFalse:[^ false].
    s := description selectSelector.
    s isNil ifTrue:[^ true].

    row := dataSet at:aRowNr ifAbsent:[^ false].
    columnAdaptor notNil ifTrue:[
        ^ columnAdaptor perform:s withOptionalArgument:row and:columnNumber and:aRowNr and:dataSet
    ].

    ^ row perform:s withOptionalArgument:columnNumber and:aRowNr and:dataSet

    "Modified: / 27-10-2007 / 10:27:20 / cg"
!

choicesFor:aRow at:aRowNr
    |choicesSelector|

    choicesSelector := description choices.
    choicesSelector isNil ifTrue:[^ nil].

    columnAdaptor notNil ifTrue:[
        ^ columnAdaptor perform:choicesSelector withOptionalArgument:aRow and:columnNumber and:aRowNr and:dataSet
    ].
    ^ aRow perform:choicesSelector withOptionalArgument:aRowNr and:columnNumber and:dataSet
!

containsText
    "returns true if text might exist
    "
    ^ containsText
!

doubleClickOn:aRowNr
    |sel row|

    (sel := self doubleClickedSelector) notNil ifTrue:[
        row := dataSet at:aRowNr.
        columnAdaptor notNil ifTrue:[
            ^ columnAdaptor perform:sel withOptionalArgument:row and:columnNumber and:aRowNr and:dataSet
        ].
        ^ row perform:sel withOptionalArgument:columnNumber and:aRowNr and:dataSet
    ].
!

hasChoices:aRowNr
    |row|

    row := dataSet at:aRowNr.
    ^ (self choicesFor:row at:aRowNr) notNil
!

hasPotentialNonConstantBackground
    (backgroundColor notNil and:[backgroundColor isImageOrForm]) ifTrue:[^ true].
    description backgroundSelector notNil ifTrue:[^ true].
    ^ false.
!

hasRelativeWidth
    "returns true if width is relative
    "
    ^ descWidth isInteger not. "/ descWidth isLimitedPrecisionReal 
!

hasRowSeparatorAt:rowNumber
    |row bool|

    rowSeparatorSelector isNil ifTrue:[^ true ].
    row := dataSet at:rowNumber.

    columnAdaptor isNil ifTrue:[
        bool := row perform:rowSeparatorSelector.
    ] ifFalse:[
        bool := columnAdaptor perform:rowSeparatorSelector
                    withOptionalArgument:row and:columnNumber and:rowNumber and:dataSet.
    ].
    ^ bool ~~ false
!

heightOfHighestRow
    "returns the height of the highest row in pixels.
     Warning: 
        only the first numberOfRowsProbedForColumnSize are probed,
        in case the access is expensive (dataBase apps)
     If the descriptor defines a height, that is used, and the items are not probed at all.
     If the descriptor's height is -1 or #fontHeight, that is used.
     If the descriptor's height is #heightOfFirstRow, only the first columns height is probed.
    "
    |h end bE editorType row1|

    (h := description height) == 0 ifTrue:[
        containsText ifTrue:[
            "/ search first none empty drawable object
            end := description numberOfRowsProbedForColumnSize min:dataSet size.

            1 to:end do:[:rowNr| |row|
                row := dataSet at:rowNr.
                h := h max:(self heightOfLabel:(self shownValueForRow:row rowNr:rowNr))
            ]
        ]
    ] ifFalse:[
        ((h == #heightOfFirstRow) or:[ h == #askFirst]) ifTrue:[
            h := 0.
            containsText ifTrue:[
                row1 := dataSet at:1.
                row1 notNil ifTrue:[
                    h := self heightOfLabel:(self shownValueForRow:row1 rowNr:1)
                ]
            ].
        ] ifFalse:[
            (h == #fontHeight or:[ h isNumber and:[h < 0] ]) ifTrue:[
                h := dataSet font heightOn:dataSet device.
            ] ifFalse:[
                h := 0
            ].
        ].
    ].

    (bE := buttonExtent y) = 0 ifTrue:[
        editorType := description editorType.
        (editorType == #ComboList or:[ editorType  == #ComboBox]) ifTrue:[
            bE := dataSet comboButtonExtent y.
        ].
    ].
    ^ h max:bE

    "Modified: / 20-01-2011 / 18:03:45 / cg"
!

heightOfLabel:aLabel
    "returns the height of the label"

    |h font|

    aLabel isNil ifTrue:[ ^ 0 ].
    aLabel isImageOrForm ifTrue:[ 
        ^ aLabel heightOn:dataSet
    ].

    font := dataSet deviceFont.
    h := description height.
    (h == #fontHeight or:[h isNumber and:[h < 0]]) ifTrue:[
        ^ font height
    ].

    aLabel isString ifTrue:[
        "/ if multiple lines - count 'em
        (aLabel includes:Character cr) ifTrue:[
            ^ aLabel asStringCollection 
                inject:0 into:[:sumH :line | sumH + (line heightOn:dataSet)]
        ].
        ^ font heightOf:aLabel
    ].

    aLabel isSequenceable ifTrue:[
        ^ aLabel inject:0 into:[:sumH :line | sumH + (line heightOn:dataSet)].
    ].

    ^ aLabel 
            perform:#heightOn: 
            with:dataSet 
            ifNotUnderstood:[aLabel displayString heightOn:dataSet].

    "Modified: / 20-01-2011 / 18:03:38 / cg"
!

isResizeable
    "returns true if the row is resizeable
    "
    ^ description isResizeable
!

isRowVisible:rowNr
    ^ description rowIsVisible:(dataSet at:rowNr)
!

isSortable
    ^ description isSortable
!

showColSeparator
    "returns true if column separator is on
    "
    ^ showColSeparator
!

showSelectionHighLighted
    "returns true if selection is highLighted
    "
    ^ description showSelectionHighLighted ~~ false
!

translatedChoicesFor:aRow at:aRowNr
    |translatedChoicesSelector|

    translatedChoicesSelector := description translatedChoices.

    columnAdaptor notNil ifTrue:[
        ^ columnAdaptor perform:translatedChoicesSelector withOptionalArgument:aRow and:columnNumber and:aRowNr and:dataSet
    ].
    ^ aRow perform:translatedChoicesSelector withOptionalArgument:aRowNr and:columnNumber and:dataSet
!

widthOfLabel:aLabel
    "returns the width of the label"

    aLabel isNil ifTrue:[ ^ 0 ].
    (aLabel isString or:[aLabel isImageOrForm]) ifTrue:[
        ^ aLabel widthOn:dataSet
    ].

    aLabel isSequenceable ifTrue:[
        ^ aLabel inject:0 into:[:sumW :line | sumW max:(line widthOn:dataSet)].
    ].

    ^ aLabel 
        perform:#widthOn: with:dataSet 
        ifNotUnderstood:[aLabel displayString widthOn:dataSet].
! !

!DataSetColumn methodsFor:'searching'!

findRowNrStartingWithChar:aChar start:start stop:stop
    "find the first row starting at start to stop, which drawable label
     starts with the character, aChar. The index of the detected row is
     returned or if no row is found 0.
    "
    |char|

    containsText ifTrue:[
        char  := aChar asLowercase.

        start to:stop do:[:eachNr| |row lbl|
            (dataSet isRowSelectable:eachNr) ifTrue:[
                row := dataSet at:eachNr.
                lbl := self shownValueForRow:row rowNr:eachNr.

                lbl isNonByteCollection ifTrue:[
                    lbl := lbl at:1 ifAbsent:nil
                ].

                (lbl respondsTo:#string) ifTrue:[
                    lbl := lbl string.
                    (lbl size ~~ 0 and:[(lbl at:1) asLowercase == char]) ifTrue:[
                        ^ eachNr
                    ]
                ] ifFalse:[
                    lbl notNil ifTrue:[ ^ 0 ].
                ].
            ].
        ]
    ].
    ^ 0
! !

!DataSetColumn class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

