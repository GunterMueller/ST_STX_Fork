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

SimpleView subclass:#DSVLabelView
	instanceVariableNames:'dataSet lineDrag columns selection enabled preferredHeight
		handleCursor tabSpacing opaqueColumnResize verticalLabelSpacing
		indexOfSortColumn reverseSort'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-DataSet'
!

Object subclass:#LineDrag
	instanceVariableNames:'topX topY botY column minX startX transX topView color'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DSVLabelView
!

!DSVLabelView class methodsFor:'documentation'!

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
    shows the labels assigned to the column descriptions. 
    Used as the title-part of a DataSetView.

    [Instance variables:]

        dataSet         <DSVColumnView>         column view which shows the columns

        selection       <Integer or nil>        current selected index or nil.

        enabled         <Boolean>               if a press action exists on a column
                                                entry, this action could be enabled or
                                                disabled.

        preferredHeight <Integer>               the preferred height of the labelView


    [author:]
        Claus Atzkern

    [see also:]
        DSVColumnView
        DataSetColumnSpec
        DataSetColumn
        DataSetView
"
! !

!DSVLabelView class methodsFor:'accessing'!

tabSpacing
    "returns the tab spacing
    "
    ^ 2
! !

!DSVLabelView class methodsFor:'defaults'!

defaultFont
    ^ DSVColumnView defaultFont
! !

!DSVLabelView methodsFor:'accessing'!

columns:aListOfColumns
    "the list of columns changed"

    aListOfColumns = columns ifTrue:[^ self].

    columns         := aListOfColumns.
    preferredHeight := nil.
    selection       := nil.

    self changed:#columnLayout.
!

dataSet
    ^ dataSet
!

indexOfSortColumn
    ^ indexOfSortColumn
!

opaqueColumnResize
    ^ opaqueColumnResize
!

opaqueColumnResize:aBoolean
    opaqueColumnResize := aBoolean
!

reverseSort
    ^ reverseSort
! !

!DSVLabelView methodsFor:'drawing'!

invalidate
    (shown) ifTrue:[
        super invalidate
    ]
!

invalidateItemAt:anIndex
    "invalidate rectangle assigned to an item at an index
    "
    |cL xL xR hg|

    (shown) ifTrue:[
        cL := columns at:anIndex ifAbsent:[^ nil].
        xL := self xVisibleOfColNr:anIndex.
        xR := xL + cL width.

        (xL < width and:[xR > 0]) ifTrue:[
            xL := xL max:0.
            xR := xR min:width.
            hg := height - margin - margin.

            self invalidate:(Rectangle left:xL top:margin width:(xR - xL) height:hg)
        ]
    ]
!

redrawColumnsInX:x y:y width:w height:h
    "redraw a rectangle"

    |bg fg fgColor bgColor
     inset  "{ Class:SmallInteger }"
     maxX   "{ Class:SmallInteger }"
     lblH  "{ Class:SmallInteger }"
     wt     "{ Class:SmallInteger }"
     x1     "{ Class:SmallInteger }"
     x0     "{ Class:SmallInteger }"
     item|

    (shown) ifFalse:[^ self].

    bgColor := dataSet labelBackgroundColor.
    gc paint:bgColor.
    gc fillRectangleX:x y:y width:w height:h.

    columns isEmpty ifTrue:[^ self].

    fgColor := dataSet labelForegroundColor.
    inset   := dataSet horizontalSpacing + 1.
    maxX    := (x + w) min:(width - margin).
    lblH    := height - margin - margin.

    x1 := self xVisibleOfColNr:1.

    columns keysAndValuesDo:[:eachKey :eachCol| 
        item := eachCol label.

        wt := eachCol width.
        x0 := x1.
        x1 := x1 + wt.

        (x1 > x and:[x0 < maxX]) ifTrue:[
            |left right rect|

            left  := x0 max:x.
            right := x1 min:maxX.
            rect  := Rectangle left:left top:y width:(right - left) height:h.

"/            clipRect := nil.
            self clippingBounds:rect.

            fg := (item foregroundColor) ? fgColor.

            (bg := item backgroundColor) notNil ifTrue:[
                bg ~= bgColor ifTrue:[
                    gc paint:bg.
                    gc fillRectangleX:x0 y:margin width:wt height:lblH.
                ]
            ] ifFalse:[
                bg := bgColor
            ].

            gc paint:fg on:bg.            
            item redrawX:x0 w:wt h:height inset:inset on:self.
        ]
    ].
!

redrawEdgesX:x y:yTop width:aWidth height:aHeight
    "redraw the edges in the range
    "
    |desc startOfTabX endOfTabX lastColumn has3Dseparators separatorOneDColor
     maxX "{ Class:SmallInteger }"
     h    "{ Class:SmallInteger }"
     x1   "{ Class:SmallInteger }"
     x0   "{ Class:SmallInteger }"
     y0   "{ Class:SmallInteger }"
     absLabelLevel
    |


    maxX := (x + aWidth) min:(width - margin).
    absLabelLevel := 1.
    x1   := self xVisibleOfColNr:1.

    y0 := margin.
    h  := height - margin - margin.

    has3Dseparators    := dataSet has3Dseparators.
    separatorOneDColor := dataSet separatorOneDColor.
    lastColumn         := columns last.

    columns keysAndValuesDo:[:aKey :aCol|
        desc := aCol description.
        x0   := x1.
        x1   := x1 + aCol width.

        endOfTabX := nil.

        aKey == selection ifTrue:[
            startOfTabX notNil ifTrue:[ endOfTabX := x0 ].

            (x1 > x and:[x0 < maxX]) ifTrue:[
                dataSet drawEdgesAtX:x0 y:y0 width:(x1 - x0) height:h level:-1 on:self.
            ].

        ] ifFalse:[
            desc labelHasButtonLayout ifTrue:[
                startOfTabX isNil ifTrue:[ startOfTabX := x0 ].

                (desc== lastColumn or:[desc labelIsPartOfGroup not]) ifTrue:[
                    endOfTabX := x1.
                ]
            ] ifFalse:[
                startOfTabX notNil ifTrue:[
                    endOfTabX := x0.
                ].
            ].
        ].
        endOfTabX notNil ifTrue:[
            startOfTabX isNil ifTrue:[ startOfTabX := x0 ].

            startOfTabX < endOfTabX ifTrue:[
                (endOfTabX > x and:[startOfTabX < maxX]) ifTrue:[
                    has3Dseparators ifTrue:[
                        dataSet drawEdgesAtX:startOfTabX y:y0 width:(endOfTabX - startOfTabX) height:h level:absLabelLevel on:self.
                    ] ifFalse:[
                        gc paint:separatorOneDColor.
                        gc displayLineFromX:endOfTabX-1 y:0 toX:endOfTabX-1 y:h.
                    ].
                ].
            ].
            startOfTabX := nil.
        ].
    ].

    has3Dseparators ifTrue:[
        x1 < (maxX - absLabelLevel - absLabelLevel - 3) ifTrue:[
            dataSet
                drawEdgesAtX:x1 y:y0
                width:(width"-margin"-x1"-absLabelLevel") height:h
                level:absLabelLevel on:self
        ].
    ] ifFalse:[
        h := h - 1.
        gc paint:separatorOneDColor.
        gc displayLineFromX:x y:h toX:(x + aWidth) y:h.
    ].
!

redrawX:xArg y:y width:wArg height:h
    |savClip x w |

    shown ifFalse:[^ self].

    x := xArg.
    w := wArg.

    self redrawColumnsInX:x y:y width:w height:h.
    columns size == 0 ifTrue:[ ^ self ].

    savClip := gc clippingBoundsOrNil.

    dataSet has3Dseparators ifTrue:[ | eoXlastCol |
        eoXlastCol := self xVisibleOfColNr:( columns size + 1).
        x >= eoXlastCol ifTrue:[
            w := w +( x - eoXlastCol ).
            x := eoXlastCol.
        ].
    ].
    self clippingBounds:(Rectangle left:x top:margin width:w height:height-margin-margin).
        
    xArg > x ifTrue:[
        gc paint:(dataSet backgroundColor).
        gc fillRectangleX:x y:y width:w height:h.
    ].    
    self redrawEdgesX:x y:y width:w height:h.
    self clippingBounds:savClip.
! !

!DSVLabelView methodsFor:'enumerating columns'!

columnsDo:aOneArgBlock 
    "evaluate the argument, aOneArgBlock for every column"

    columns do:aOneArgBlock
! !

!DSVLabelView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    "mouse-button was moved;
     redraw thumb at its new position and, if scroll-mode is asynchronous, 
     the scroll action is performed
    "
    |colNr x1 col|

    state = 0 ifTrue:[
        lineDrag := nil.
    ].

    lineDrag notNil ifTrue:[
        (opaqueColumnResize ? (UserPreferences current opaqueTableColumnResizing == true)) ifTrue:[
            lineDrag moveToX:x.      
            dataSet changeWidthOfColumn:lineDrag column deltaX:lineDrag deltaX.
            lineDrag resetDeltaX.    
        ] ifFalse:[
            lineDrag invertLinesMovingToX:x.
        ].
        ^ self.
    ].

    "/ in the resize area ?
    colNr := self xVisibleToColNr:(x-tabSpacing).
    colNr notNil ifTrue:[
        col := columns at:colNr.

        (col notNil and:[col isResizeable]) ifTrue:[
            x1 := self xVisibleOfColNr:(colNr + 1).
            (x between:(x1-tabSpacing) and:(x1+tabSpacing))
            "/ x + tabSpacing > x1 
            ifTrue:[
                self cursor:handleCursor.
                ^ self
            ].
        ].
    ].
    self cursor:(Cursor normal)

    "Modified: / 26-03-2007 / 15:20:27 / cg"
!

buttonPress:button x:x y:y
    "handle a button press event; checks whether the item under the mouse
     is selectable. If true, the selection is set to the item.
    "
    |x1 colNr col|

    (enabled and:[shown]) ifFalse:[
        ^ self
    ].

    "/ in the resize area ?
    colNr := self xVisibleToColNr:(x-tabSpacing).
    colNr notNil ifTrue:[
        col := columns at:colNr.
        col isResizeable ifTrue:[
            x1 := self xVisibleOfColNr:(colNr + 1).
            (x between:(x1-tabSpacing) and:(x1+tabSpacing)) ifTrue:[
                col := columns at:colNr ifAbsent:nil.
                self cursor:handleCursor.

                lineDrag := LineDrag new.
                lineDrag column:col
                              x:x
                              y:margin
                              h:(self height + dataSet height)
                           minX:(x1 - col width + col minimumRequiredWidth)
                             on:self.
                (opaqueColumnResize ? (UserPreferences current opaqueTableColumnResizing == true)) ifFalse:[
                    lineDrag invertLine.
                ].
                ^ self
            ]
        ]
    ].

    colNr := self xVisibleToColNr:x.
    colNr notNil ifTrue:[
        col := columns at:colNr.
        col label isSelectable ifTrue:[
            self invalidateItemAt:(selection := colNr)
        ].
    ].
    self cursor:(Cursor normal).

    "Modified: / 26-03-2007 / 15:21:00 / cg"
!

buttonRelease:button x:x y:y
    "handle a button press event; checks whether the item under the mouse
     is the selected item. If true, the application is informed.
    "
    |selected column deltaX colNr|

    self cursor:(Cursor normal).

    selection isNil ifTrue:[
        lineDrag notNil ifTrue:[
            (opaqueColumnResize ? (UserPreferences current opaqueTableColumnResizing == true)) ifFalse:[
                lineDrag invertLine.
                column   := lineDrag column.
                deltaX   := lineDrag deltaX.

                deltaX abs > 0 "2" ifTrue:[
                    dataSet changeWidthOfColumn:column deltaX:deltaX
                ]
            ].
            lineDrag := nil.
            ^ self.
        ].

        ((colNr := dataSet xVisibleToColNr:x) notNil
        and:[ (column := columns at:colNr) notNil
        and:[ column label isSortable ]]) ifTrue:[
            indexOfSortColumn == colNr ifTrue:[
                reverseSort := (reverseSort ? false) not
            ] ifFalse:[
                reverseSort := false.
                indexOfSortColumn := colNr.
            ].
            self invalidateItemAt:colNr.
            dataSet updateList.
        ].
        ^ self.
    ].

    colNr := self xVisibleToSelectionIndex:x.
    selected  := (colNr == selection).
    colNr     := selection.
    selection := nil.

    self invalidateItemAt:colNr.

    selected ifTrue:[
        self sendClickMsgForColumnNr:colNr
    ]
!

pointerLeave:state
    "mouse left view - restore cursor.
    "
    self sensor anyButtonPressed ifFalse:[
        self cursor:(Cursor normal)
    ].



!

sendClickMsgForColumnNr:colNr
    "inform the receiver of a button release notification"

    |receiver col description labelActionSelector|

    receiver := self application.
    receiver isNil ifTrue:[^ self].

    col := columns at:colNr.
    description := col description.

    (labelActionSelector := description labelActionSelector) notNil ifTrue:[
        receiver perform:labelActionSelector withOptionalArgument:(description labelActionArgument) and:colNr
    ].
!

xVisibleToColNr:x
    "returns the column number for a physical x position.
     Returns nil if x is beyond the last column."

    |x0 x1|

    x1 := self xVisibleOfColNr:1.

    columns keysAndValuesDo:[:index :aCol|
        x0 := x1.
        x1 := x0 + aCol width.

        (x1 > x and:[x0 < x]) ifTrue:[
            ^ index
        ]
    ].
    ^ nil

    "Modified: / 26-03-2007 / 15:21:37 / cg"
! !

!DSVLabelView methodsFor:'focus handling'!

canTab
    ^ false
!

wantsFocusWithButtonPress
    "never wants the focus - view which keeps the labels
    "
    ^ false
! !

!DSVLabelView methodsFor:'help'!

flyByHelpTextAt:aPoint
    "return the helpText for aPoint (i.e. when mouse-pointer is moved over an item)."

    |colNr col|

    columns isEmpty ifTrue:[^ nil].
    colNr := self xVisibleToColNr:aPoint x.
    colNr notNil ifTrue:[
        col := columns at:colNr.
        ^ col activeHelpTextForLabel.
    ].
    ^ nil

    "Created: / 26-03-2007 / 13:43:20 / cg"
    "Modified: / 26-03-2007 / 15:21:07 / cg"
! !

!DSVLabelView methodsFor:'initialization'!

initStyle
    <resource: #style (#'dataSet.labelView.level'
                       #'dataSet.labelView.verticalSpace' 
                       )>

    super initStyle.

    handleCursor := (VariablePanel cursorForOrientation:#horizontal onDevice: device) onDevice: device.
    gc font:self class defaultFont.
    "/ self level:0.
    self level:(styleSheet at:#'dataSet.labelView.level' default:-1).
    verticalLabelSpacing := (styleSheet at:#'dataSet.labelView.verticalSpace' default:2).
!

initialize
    super initialize.
    "/ super level:(self defaultLevel).

    enabled    := true.
    columns    := #().
    tabSpacing := self class tabSpacing.

    self enableMotionEvents.
! !

!DSVLabelView methodsFor:'instance creation'!

for:aColumnView
    "initialization
    "
    dataSet   := aColumnView.
"/    self level:(dataSet level).
"/    self borderWidth:(dataSet borderWidth).
!

realize
    "recompute contents and fit columns to view
    "
    self  bitGravity:#NorthWest.
    super realize.
! !

!DSVLabelView methodsFor:'queries'!

columnIndexOfDescription:aColumnDescription
    ^ columns findFirst:[:col | col description == aColumnDescription]
!

enabled
    "true, if widget is enabled
    "
    ^ enabled
!

enabled:aState
    "true, if widget is enabled
    "
    enabled := aState.
!

indexOfLabel:aLabel
    ^ columns findFirst:[:col | col label == aLabel].
!

preferredExtent

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    ^ 100 @ self preferredHeight
!

preferredHeight
    |maxLabelHeight|

    preferredHeight notNil ifTrue:[
        ^ preferredHeight
    ].

    maxLabelHeight :=
        columns inject:0 into:[:maxSoFar :col | (col label preferredHeight) max:maxSoFar ].

    ^ ((self margin + verticalLabelSpacing) * 2) + maxLabelHeight 
!

xVisibleOfColNr:colNr
    "/ must adjust, because dataset includes its own margin, which might be different from ours

    ^ (dataSet xVisibleOfColNr:colNr) - dataSet margin + margin
!

xVisibleToSelectionIndex:x
    "returns the column number assigned to a physical x or nil. If
     the column exists but is not selectable nil is returned.
    "

    |colNr column|

    (shown and:[enabled]) ifTrue:[
        ((colNr  := dataSet xVisibleToColNr:x)  notNil
         and:[(column := columns at:colNr) notNil
         and:[column label isSelectable]]
        ) ifTrue:[
            ^ colNr
        ]
    ].
    ^ nil

    "Modified: / 26-03-2007 / 15:21:27 / cg"
! !

!DSVLabelView methodsFor:'scrolling'!

copyFromX:x0 y:y0 toX:x1 y:y1 width:w invalidateX:leftX

    (shown) ifFalse:[^ self].

    (self sensor hasDamageFor:self) ifTrue:[
        self invalidate
    ] ifFalse:[
        self   copyFrom:self x:x0 y:y0 toX:x1 y:y1 width:w height:height async:false.
        self invalidate:(Rectangle left:leftX top:0 width:(width - w) height:height)
              repairNow:true
    ]
! !

!DSVLabelView::LineDrag methodsFor:'accessing'!

column
    "return the value of the instance variable 'column' (automatically generated)"

    ^ column
!

deltaX
    "returns the distance x between the start and end action
    "
    ^ topX - startX
!

resetDeltaX
    startX := topX
! !

!DSVLabelView::LineDrag methodsFor:'dragging'!

invertLine
    "invert current line
    "
    self invertLinesMovingToX:nil.
!

invertLinesMovingToX:viewX
    "invert current line
     if x notNil than change x position and invert new line"

    topView clippedByChildren:false.

    topView xoring:[
        topView paint:color.
        topView lineWidth:2.
        topView displayLineFromX:topX y:topY toX:topX y:botY.

        viewX notNil ifTrue:[
            self moveToX:viewX.
            topView displayLineFromX:topX y:topY toX:topX y:botY.
        ].
        topView flush
    ].
    topView clippedByChildren:true.
!

moveToX:viewX
    topX := (minX max:viewX) + transX.
! !

!DSVLabelView::LineDrag methodsFor:'setup'!

column:aColumn x:x y:y h:h minX:aMinX on:aView
    |device point|

    column  := aColumn.
    topView := aView topView.
    device  := topView device.
    color   := Color colorId:(device blackpixel bitXor:device whitepixel).
    point   := device translatePoint:(x@y) fromView:aView toView:topView.

    topX     := point x.
    topY     := point y.
    botY     := topY + h.
    minX     := aMinX.
    startX   := topX.
    transX   := topX - x.
! !

!DSVLabelView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

