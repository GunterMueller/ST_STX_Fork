"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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

SelectionInListView subclass:#SelectionInTreeView
	instanceVariableNames:'validateDoubleClickBlock selectionHolder rootHolder imageWidth
		showLines showLinesForRoot listOfNodes imageInset textInset
		labelOffsetY lineMask itemClass lineColor computeResources
		showRoot showDirectoryIndicator closeIndicator openIndicator
		showDirectoryIndicatorForRoot imageOpened imageClosed imageItem
		discardMotionEvents registeredImages supportsExpandAll
		buildInArray drawVLinesFromLevel highlightMode editorWidget
		editorIndex editValueFgColor validateExpandabilityBlock'
	classVariableNames:'DefaultHilightMode SelectionInset'
	poolDictionaries:''
	category:'Views-Trees'
!

!SelectionInTreeView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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
    somewhat like a SelectionInListView; but specialized for hierarchical (i.e. tree-like)
    lists and adds the functions to show/hide subtrees. 
    Requires SelectionInTree as model and TreeItem (or compatible) list entries.

    Notice: 
        This class obsoletes SelectionInHierarchyView, which is no longer
        maintained but kept for backward compatibility.

    Notice2: 
        Even for this class, an improved replacement now exists:
        HierarchicalListView.
        Please consider using that one.
        (however, this class is kept for backward compatibility).

    [see also:]
        SelectionInTree
        TreeItem
        SelectionInListView
        FileSelectionTree

    [author:]
        Claus Atzkern
"
!

examples
"
    shows the tree of smalltalk classes:
                                                                        [exBegin]
      |top sel|

      top := StandardSystemView new; extent:300@300.
      sel := SelectionInTreeView new.
      sel root:(TreeItem newAsTreeFromSmalltalkClass:Object).
      sel action:[:nr | Transcript show:'selected:'; showCR:nr].
      top add:(ScrollableView forView:sel) in:((0.0 @ 0.0 ) corner:( 1.0 @ 1.0)).
      top open.
                                                                        [exEnd]



    same, including nil-subclasses (i.e. really all classes):
                                                                        [exBegin]
      |top sel|

      top := StandardSystemView new; extent:300@300.
      sel := SelectionInTreeView new.
      sel root:(TreeItem newAsTreeFromSmalltalkClass:nil).
      sel action:[:nr | Transcript show:'selected:'; showCR:nr].
      sel lineColor:(Color red).
      top add:(ScrollableView forView:sel) in:((0.0 @ 0.0 ) corner:( 1.0 @ 1.0)).
      top open.
                                                                        [exEnd]



    shows the tree of smalltalk classes; show directory indication and no
    lines.
                                                                        [exBegin]
      |top sel|

      top := StandardSystemView new; extent:300@300.
      sel := SelectionInTreeView new.
      sel showLines:false.
      sel showDirectoryIndicator:true.
      sel root:(TreeItem newAsTreeFromSmalltalkClass:Object).
      sel action:[:nr | Transcript show:'selected:'; showCR:nr].
      top add:(ScrollableView forView:sel) in:((0.0 @ 0.0 ) corner:( 1.0 @ 1.0)).
      top open.
                                                                        [exEnd]
"


! !

!SelectionInTreeView class methodsFor:'constants'!

minImageInset
    "returns minimum inset from directory indication to image
    "
  ^ 6


! !

!SelectionInTreeView class methodsFor:'defaults'!

defaultModelClass
    "returns the default model
    "
    ^ SelectionInTree
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'selection.highlightMode')>

    SelectionInset     := 4.
    DefaultHilightMode := StyleSheet at:'selection.highlightMode' default:#line.
    "
     self updateStyleCache
    "


! !

!SelectionInTreeView class methodsFor:'resources'!

closeIndicator
    "returns a little [+] bitmap"

    ^ HierarchicalListView closeIndicator






!

imageClosed
    "returns a closed file-directory bitmap"

    ^ HierarchicalListView collapsedIcon

!

imageItem
    "returns a regular file bitmap"

    ^ HierarchicalListView emptyIcon





!

imageOpened
    "returns an opened file-directory bitmap"

    ^ HierarchicalListView expandedIcon

!

openIndicator
    "returns a little [-] bitmap"

    ^ HierarchicalListView openIndicator


! !

!SelectionInTreeView methodsFor:'accessing'!

highlightMode
    "get the mode how to draw a selected line:
        #line           draw whole line selected
        #label          draw label selected
    "
    ^ highlightMode
!

highlightMode:aMode
    "set the mode how to draw a selected line:
        #line           draw whole line selected
        #label          draw label selected
    "
    |mode|

    (mode := aMode) == #label ifFalse:[
        mode := #line
    ].

    mode ~~ highlightMode ifTrue:[
        highlightMode := mode.
        self invalidate
    ]
!

itemClass
    "returns current itemClass used
    "
    ^ itemClass


!

itemClass:anItemClass
    "set itemClass to be used
    "

    (anItemClass notNil and:[anItemClass ~~ itemClass]) ifTrue:[
        itemClass := anItemClass.
        computeResources := true.
        self refetchDeviceResources.
    ].

!

lineColor
    "returns user configured line color or nil
    "
    ^ lineColor

!

lineColor:aColor
    "returns user configured line color or nil
    "
    |col|

    col := aColor = fgColor ifTrue:[nil] ifFalse:[aColor].

    col = lineColor ifFalse:[
        lineColor := col.
        lineColor notNil ifTrue:[lineColor := lineColor onDevice:device].
        self invalidate
    ]
!

nodeAtIndex:anIndex
    "returns node at an index or nil
    "
    (anIndex notNil and:[anIndex between:1 and:listOfNodes size]) ifTrue:[
        ^ listOfNodes at:anIndex
    ].
  ^ nil
!

root
    "gets the root of the model; the first item into list.
    "
    ^ self nodeAtIndex:1
!

root:aRoot
    "sets the root of the model; the first item into list.
    "
    aRoot notNil ifTrue:[aRoot expand].
    model root:aRoot
!

textInset
    "get the left inset of the text label
    "
    ^ textInset
!

textInset:anInset
    "set the left inset of the text label
    "
    anInset ~~ textInset ifTrue:[
        anInset >= 0 ifTrue:[
            textInset := anInset.
            self invalidate
        ] ifFalse:[
            self error
        ]
    ].
! !

!SelectionInTreeView methodsFor:'accessing-behavior'!

drawVLinesFromLevel
    "returns the level vertical lines are drawn from;
     starting at 1 up to n
    "
    ^ drawVLinesFromLevel
!

drawVLinesFromLevel:aLevel
    "set the level vertical lines are drawn from;
     starting at 1 up to n
    "
    |lv|

    lv := (aLevel ? 1) max:1.

    lv ~~ drawVLinesFromLevel ifTrue:[
        drawVLinesFromLevel := lv.
        self invalidate
    ]
!

supportsExpandAll
    ^ supportsExpandAll
!

supportsExpandAll:aBool

    supportsExpandAll := aBool
!

validateDoubleClickBlock
    "return the conditionBlock; this block is evaluated before a doubleClick action
     on a node will be performed. In case of returning false, the doubleClick will
     not be handled.
   "
   ^ validateDoubleClickBlock


!

validateDoubleClickBlock:aOneArgBlock
    "set the conditionBlock; this block is evaluated before a doubleClick action
     on a node will be performed. In case of returning false, the doubleClick will
     not be handled.
   "
   validateDoubleClickBlock := aOneArgBlock


!

validateExpandabilityBlock
    "return the expand conditionBlock; this block is evaluated before an expand due to
     a doubleClick on a node will be performed. In case of returning false, 
     the node will not be expanded.
   "
   ^ validateExpandabilityBlock


!

validateExpandabilityBlock:aOneArgBlock
    "set the expand conditionBlock; this block is evaluated before an expand due to
     a doubleClick on a node will be performed. In case of returning false, 
     the node will not be expanded.
   "
   validateExpandabilityBlock := aOneArgBlock


! !

!SelectionInTreeView methodsFor:'accessing-channels'!

rootHolder
    "get the holder which keeps the hierarchical list entry or nil
    "
    ^ rootHolder
!

rootHolder:aValueHolder
    "set the holder which keeps the hierarchical list entry or nil
    "
    rootHolder notNil ifTrue:[
        rootHolder removeDependent:self
    ].

    (rootHolder := aValueHolder) notNil ifTrue:[
        rootHolder addDependent:self.
        self rootFromModel.
    ].
!

selectionHolder
    "get the holder which keeps a list of selected items or nil
    "
    ^ selectionHolder

!

selectionHolder:aHolder
    "set the holder which keeps a list of selected items or nil
    "
    selectionHolder notNil ifTrue:[
        selectionHolder removeDependent:self
    ].

    (selectionHolder := aHolder) notNil ifTrue:[
        selectionHolder addDependent:self.
        self selectionFromModel
    ].

! !

!SelectionInTreeView methodsFor:'accessing-images'!

imageClosed
    "return the value of the instance variable 'imageClosed'.
     That's the (default) bitmap image shown for closed folders
     (initialized to a file-directory bitmap)"

    ^ imageClosed

    "Created: 3.7.1997 / 12:34:31 / cg"
!

imageItem
    "return the value of the instance variable 'imageItem'.
     That's the (default) bitmap image shown for regular items
     (initialized to a plain-file bitmap)"

    ^ imageItem

    "Created: 3.7.1997 / 12:34:34 / cg"
!

imageOnMyDevice:anImage
    "associate image to device and returns the new image."

    anImage isNil ifTrue:[^ nil].
    ^ anImage onDevice:device.

    "Modified: / 12.8.1998 / 12:46:38 / cg"
!

imageOpened
    "return the value of the instance variable 'imageOpened'.
     That's the (default) bitmap image shown for opened folders
     (initialized to an open file-directory bitmap)"

    ^ imageOpened

    "Created: 3.7.1997 / 12:34:28 / cg"
! !

!SelectionInTreeView methodsFor:'accessing-look'!

showDirectoryIndicator
    "returns true if directories has an open/closed indicator
    "
  ^ showDirectoryIndicator
!

showDirectoryIndicator:aState
    "set or clear open/closed indicator for directories
    "
    "show or hide lines
    "
    aState ~~ showDirectoryIndicator ifTrue:[
        showDirectoryIndicator := aState.
        self recomputeDirectoryIndicator.
        self invalidate
    ].
!

showDirectoryIndicatorForRoot
    "returns true if root directory has an open/closed indicator if
     the common showDirectoryIndicator is enabled
    "
    ^ showDirectoryIndicatorForRoot
!

showDirectoryIndicatorForRoot:aState
    "true if root directory has an open/closed indicator if
     the common showDirectoryIndicator is enabled
    "
    aState ~~ showDirectoryIndicatorForRoot ifTrue:[
        showDirectoryIndicatorForRoot := aState.
        self recomputeDirectoryIndicator.
        self invalidate
    ].
!

showLines
    "returns true if lines are shown
    "
  ^ showLines
!

showLines:aState
    "show or hide lines
    "
    aState ~~ showLines ifTrue:[
        showLines := aState.
        self invalidate
    ].
!

showLinesForRoot
    "returns true if root-lines are shown
    "
  ^ showLinesForRoot
!

showLinesForRoot:aState
    "show or hide lines for root(s)
    "
    aState ~~ showLinesForRoot ifTrue:[
        showLinesForRoot := aState.
        self invalidate
    ].
!

showRoot
    "list with or without root
    "
  ^ showRoot
!

showRoot:aState
    "list with or without root
    "
    showRoot ~~ aState ifTrue:[
        model showRoot:(showRoot := aState).
    ].
! !

!SelectionInTreeView methodsFor:'change & update'!

modelChanged:what with:aPara
    "hierarchical list changed"

    |start size visLn h y0 y1 cY parent pvLv ndLv|

    aPara isNil ifTrue:[
        what == #list ifTrue:[ self getListFromModel ]
                     ifFalse:[ super update:what with:aPara from:model ].
        ^ self
    ].

    (what == #insertCollection: or:[what == #removeFrom:]) ifFalse:[
        what == #at:     ifTrue:[ ^ self redrawLine:aPara ].
        what == #replace ifTrue:[ ^ self invalidateRepairNow:true ].

        ^ super update:what with:aPara from:model.
    ].
    list := self listFromModel.

    shown ifFalse:[
        ^ self contentsChanged
    ].
    (self sensor hasExposeEventFor:self) ifTrue:[       
        "/ outstanding expose events
        self invalidateRepairNow:true.
        ^ self contentsChanged
    ].

    start  := aPara at:1.
    size   := aPara at:2.
    parent := aPara at:3.

    what == #removeFrom: ifTrue:[
        size := size - start + 1
    ].

    start > 1 ifTrue:[
        pvLv  := (list at:start - 1) level.
        ndLv  := parent level + 1.

        ndLv < pvLv ifTrue:[
            what == #insertCollection: ifTrue:[
                visLn := start + size.
            ] ifFalse:[
                visLn := start.
            ].

            (visLn > list size or:[(list at:visLn) level ~~ ndLv]) ifTrue:[
                [(start := start - 1) ~~ 1] whileTrue:[
                    (list at:start) level <= ndLv ifTrue:[
                        self redrawFromLine:start.
                      ^ self contentsChanged.
                    ]
                ].
                self invalidateRepairNow:true.
              ^ self contentsChanged
            ]
        ].
        self redrawIconAndIndicatorAt:(start - 1)
    ].
    (visLn := self listLineToVisibleLine:start) isNil ifTrue:[
        ^ self contentsChanged
    ].

    h  := size * fontHeight.
    y0 := self yOfVisibleLine:visLn.
    y1 := y0 + h.
    cY := height - y1 - 1.

    cY < 40 ifTrue:[
        self redrawFromLine:start.
    ] ifFalse:[
        self catchExpose.

        what == #insertCollection: ifTrue:[
            self copyFrom:self x:0 y:y0 toX:0 y:y1 width:width height:cY async:true.
        ] ifFalse:[
            self copyFrom:self x:0 y:y1 toX:0 y:y0 width:width height:cY async:true.
            y0 := y0 + cY.
            h  := height - y0.
        ].
        self redrawX:0 y:y0 width:width height:h.
        self waitForExpose.
    ].
    self flush.
    self contentsChanged.
!

update:something with:aParameter from:aModel
    "one of my models changed its value
    "
    |idx|

    aModel == rootHolder ifTrue:[
        ^ self rootFromModel
    ].

    aModel == selectionHolder ifTrue:[
        ^ self selectionFromModel   
    ].

    aModel == model ifTrue:[
        ^ self modelChanged:something with:aParameter
    ].

    (aModel isKindOf:TreeItem) ifTrue:[
        (something == #size or:[something == #children]) ifTrue:[
            model recomputeList.
            ^ self
        ].

        (idx := self indexOfNode:aModel) ~~ 0 ifTrue:[
            something == #value ifTrue:[  
                ^ self redrawLine:idx.
            ].

            something == #indication ifTrue:[
                ^ self redrawIndicatorLine:idx.
            ].
            "/ assume that the nodes string has changed
            ^ self redrawLine:idx.
        ].
        ^ self
    ].
    super update:something with:aParameter from:aModel.

! !

!SelectionInTreeView methodsFor:'drawing'!

drawLine:line atX:atX inVisible:visLineNr with:fg and:bg
    self drawFromVisibleLine:visLineNr to:visLineNr with:fg and:bg

!

drawLine:line fromX:x inVisible:visLineNr with:fg and:bg
    self drawFromVisibleLine:visLineNr to:visLineNr with:fg and:bg

!

drawLine:line inVisible:visLineNr with:fg and:bg
    self drawFromVisibleLine:visLineNr to:visLineNr with:fg and:bg

!

drawVisibleLine:visLineNr col:col with:fg and:bg
    self drawFromVisibleLine:visLineNr to:visLineNr with:fg and:bg

!

drawVisibleLine:visLineNr from:startCol to:endCol with:fg and:bg
    self drawFromVisibleLine:visLineNr to:visLineNr with:fg and:bg

!

drawVisibleLine:visLineNr from:startCol with:fg and:bg
    self drawFromVisibleLine:visLineNr to:visLineNr with:fg and:bg

!

redrawFromVisibleLine:startVisLineNr to:endVisLineNr
    self redrawX:0 y:(self yOfVisibleLine:startVisLineNr)
         width:width height:(endVisLineNr - startVisLineNr + 1 * fontHeight)
!

redrawIconAndIndicatorAt:aLnNr
    |visLineNr x0 x1 lv|

    shown ifTrue:[
        visLineNr := self listLineToVisibleLine:aLnNr.
        visLineNr notNil ifTrue:[
            lv := (listOfNodes at:aLnNr) level.
            x1 := (imageWidth + (self xOfFigureLevel:lv)) min:width.
            x0 := (self xOfFigureLevel:(lv - 1)) max:0.

            (x0 > width or:[x1 < 0]) ifFalse:[
                self redrawX:x0 y:(self yOfVisibleLine:visLineNr)
                     width:(x1 - x0) height:fontHeight
            ]
        ]
    ].
!

redrawIndicatorLine:aLineNr
    "redraw the directory indicator for a line
    "
    |node ext img visLn
     x  "{ Class:SmallInteger }"
     y  "{ Class:SmallInteger }"
     dX "{ Class:SmallInteger }"
    |

    (     shown
     and:[showDirectoryIndicator
     and:[(visLn := self listLineToVisibleLine:aLineNr) notNil]]
    ) ifFalse:[
        ^ self
    ].

    node := listOfNodes at:aLineNr.

    (node parent notNil or:[showDirectoryIndicatorForRoot]) ifFalse:[
        ^ self
    ].

    x := imageWidth // 2.
    x := x + (self xOfFigureLevel:(node level - 1)).

    "/ draw directory indicator

    img := node isCollapsable ifTrue:[openIndicator] ifFalse:[closeIndicator].
    img notNil ifTrue:[
        ext := img extent // 2.
        dX  := ext x.

        (x + dX > 0 and:[(x := x - dX) < (width - margin)]) ifTrue:[
            self paintOnIsSelected:(self isInSelection:aLineNr).

            y := (self yOfVisibleLine:visLn) + (fontHeight // 2) - 1.
            self displayForm:img x:x y:(y - ext y)
        ].
    ].
!

redrawVisibleLine:visLineNr
    self drawFromVisibleLine:visLineNr to:visLineNr with:fgColor and:bgColor
!

redrawVisibleLine:visLineNr from:startCol to:endCol
    self drawFromVisibleLine:visLineNr to:visLineNr with:fgColor and:bgColor
! !

!SelectionInTreeView methodsFor:'drawing basics'!

drawFromVisibleLine:startVisLineNr to:endVisLineNr with:fg and:bg
    "redraw a visible line range with clearing the background
    "
    |y h|

    y := self yOfVisibleLine:startVisLineNr.
    h := endVisLineNr - startVisLineNr + 1 * fontHeight.

    y + h > height ifTrue:[
        h := height - y
    ].
    self redrawX:0 y:y width:width height:h.
!

drawVHLinesX:x0 y:y0 toX:x1 start:start stop:stop
    "redraw from line to line without clearing the background
    "
    |node prevNode parent p1 p2 showVLines showHLine lv nxtPrnt
     showRootNot isFirst

     x        "{ Class:SmallInteger }"
     y        "{ Class:SmallInteger }"

     yTop     "{ Class:SmallInteger }"
     yBot     "{ Class:SmallInteger }"
     yCtr     "{ Class:SmallInteger }"

     begHLnY  "{ Class:SmallInteger }"
     begHLnX  "{ Class:SmallInteger }"
     endHLnX  "{ Class:SmallInteger }"

     widthLvl "{ Class:SmallInteger }"
     offsHLnX "{ Class:SmallInteger }"

     level    "{ Class:SmallInteger }"
     startLvI "{ Class:SmallInteger }"
     startLvX "{ Class:SmallInteger }"
     limitLvI "{ Class:SmallInteger }"
     limitLvX "{ Class:SmallInteger }"
     xIcon
    |

    yBot     := y0.
    yCtr     := yBot - (fontHeight // 2).
    widthLvl := imageInset + imageWidth.
    offsHLnX := (imageWidth // 2) + (self xOfFigureLevel:-1).
    xIcon := imageWidth // 2.

    parent   := 4711.                           "/ to force a recompute
    prevNode := 4711.                           "/ to force a recomputation of the level

    gc maskOrigin:(self viewOrigin + (0 @ 1) \\ (lineMask extent)).
    gc paint:lineColor on:bgColor.
    gc mask:lineMask.
    begHLnY  := y0.
    startLvI := self smallestLevelOfNodesBetween:start and:stop.
    startLvX := self xOfFigureLevel:startLvI.
    limitLvI := drawVLinesFromLevel + 1.
    limitLvX := limitLvI * widthLvl + offsHLnX.

    buildInArray atAllPut:0.

    start == 1 ifTrue:[
        begHLnY := yCtr + fontHeight.
    ].
    showRootNot := showRoot not.

    start to:stop do:[:anIndex|
        node := listOfNodes at:anIndex.
        yTop := yBot - 1.
        yBot := yBot + fontHeight.
        yCtr := yCtr + fontHeight.

        (nxtPrnt := node parent) ~~ parent ifTrue:[
            parent := nxtPrnt.

            prevNode == parent ifTrue:[
                level := level + 1.
                begHLnX := endHLnX.
            ] ifFalse:[
                level   := node level.
                begHLnX := level * widthLvl + offsHLnX.
            ].

            isFirst    := parent isNil or:[(showRootNot and:[level == 2])].
            endHLnX    := begHLnX + widthLvl.
            showVLines := begHLnX >= x0 and:[level > drawVLinesFromLevel].
            showHLine  := x0 < endHLnX and:[x1 > begHLnX].

            (showHLine and:[isFirst]) ifTrue:[
                showHLine := showDirectoryIndicatorForRoot and:[showDirectoryIndicator]
            ]
        ].

        showHLine ifTrue:[
            gc displayLineFromX:begHLnX y:yCtr toX:endHLnX-xIcon y:yCtr
        ].

        showVLines ifTrue:[
            y  := (parent basicLastChild == node) ifTrue:[yCtr] ifFalse:[yBot].
            x  := begHLnX.
            p2 := parent.
            lv := level - 1.
            gc displayLineFromX:x y:begHLnY toX:x y:y.

            [((p1 := p2 parent) notNil and:[(x := x - widthLvl) >= limitLvX])] whileTrue:[
                (p1 basicLastChild ~~ p2 and:[x <= x1]) ifTrue:[
                    x >= startLvX ifTrue:[
                        (isFirst not or:[showLinesForRoot]) ifTrue:[
                            gc displayLineFromX:x y:yTop toX:x y:yBot
                        ]
                    ] ifFalse:[
                        buildInArray at:lv put:yBot
                    ].
                ].
                lv := lv - 1.
                p2 := p1
            ]
        ].
        prevNode := node.
        begHLnY  := yCtr.
    ].

    "/
    "/ draw outstanding verical lines to left
    "/
    x := limitLvX.
    y := (start ~~ 1) ifTrue:[y0] ifFalse:[y0 + (fontHeight // 2)].

    limitLvI to:startLvI do:[:i|
        (yBot := buildInArray at:i) ~~ 0 ifTrue:[
            gc displayLineFromX:x y:y toX:x y:yBot
        ].
        x := x + widthLvl.
    ].
    gc mask:nil.
!

drawVisibleLineSelected:visLineNr with:fg and:bg
    "redraw a single line as selected."

    (self visibleLineToListLine:visLineNr) isNil ifTrue:[
        ^ super drawVisibleLine:visLineNr with:fg and:bg
    ].
    self redrawX:0 y:(self yOfVisibleLine:visLineNr)
         width:width height:fontHeight
!

paintOnIsSelected:isSelected
    isSelected ifTrue:[
        self hasFocus ifTrue:[
            gc paint:hilightFgColor on:hilightBgColor
        ] ifFalse:[
            gc paint:hilightFgColorNoFocus on:hilightBgColorNoFocus
        ]
    ] ifFalse:[
        gc paint:fgColor on:bgColor.
    ].
!

redrawElement:anIndex

    |vln x0 xT y|

    shown ifTrue:[
        (     highlightMode ~~ #label
          or:[(vln := self listLineToVisibleLine:anIndex) isNil
          or:[anIndex > listOfNodes size]]
        ) ifTrue:[
            super redrawElement:anIndex
        ] ifFalse:[
            y := self yOfVisibleLine:vln.
            xT := self xOfStringLevel:((listOfNodes at:anIndex) level).
            x0 := xT - textInset.
            gc paint:bgColor.
            gc fillRectangleX:x0 y:y width:(width - x0) height:fontHeight.
            self redrawLabelAt:xT y:y index:anIndex
        ]
    ]
!

redrawLabelAt:x y:yTop index:anIndex
    |isSel y0 x0 w label node value xV wV|

    node  := listOfNodes at:anIndex.
    label := node name.
    isSel := self isInSelection:anIndex.
    xV    := 0.
    wV    := 0.
    y0    := yTop + (fontHeight // 2) + labelOffsetY.

    (value := node printableEditValue) notNil ifTrue:[
        xV := (self xOfValueNode:node) - SelectionInset
    ].

    highlightMode == #label ifTrue:[
        x0 := x + 4.

        isSel ifTrue:[
            w  := (label notNil ifTrue:[label widthOn:self] ifFalse:[60]) + 8.

            self hasFocus ifTrue:[
                gc paint:hilightBgColor.
            ] ifFalse:[
                gc paint:hilightBgColorNoFocus.
            ].                
            gc fillRectangleX:x y:yTop width:w height:fontHeight.

            (value notNil and:[(editorWidget isNil or:[editorIndex ~~ anIndex])]) ifTrue:[
                wV := SelectionInset + SelectionInset + (value widthOn:self).
                gc fillRectangleX:xV y:yTop width:wV height:fontHeight.
            ]
        ]
    ] ifFalse:[
        x0 := x
    ].

    label notNil ifTrue:[
        self paintOnIsSelected:isSel.
        gc displayOpaqueString:label x:x0 y:y0.

        value notNil ifTrue:[
            isSel ifFalse:[
                gc paint:editValueFgColor on:bgColor
            ].
            gc displayOpaqueString:value x:(xV + SelectionInset) y:y0
        ].

    ].

    (isSel and:[highlightMode == #label]) ifTrue:[
        self redrawSelFrameAtX:x y:yTop toX:(x + w).

        wV ~~ 0 ifTrue:[
            self redrawSelFrameAtX:xV y:yTop toX:(xV + wV)
        ].
    ].
!

redrawLinesX:x0 y:y0 toX:x1 start:start stop:stop
    "redraw from line to line without clearing the background
    "
    |node prevNode parent icon showIndc showIcon showText nxtPrnt

     end      "{ Class:SmallInteger }"

     yBot     "{ Class:SmallInteger }"
     yCtr     "{ Class:SmallInteger }"

     xIndc    "{ Class:SmallInteger }"
     xIcon    "{ Class:SmallInteger }"
     xText    "{ Class:SmallInteger }"

     widthLvl "{ Class:SmallInteger }"
     insetTxt "{ Class:SmallInteger }"

     offIndcX "{ Class:SmallInteger }"
     offIndcY "{ Class:SmallInteger }"
     offIconX "{ Class:SmallInteger }"
    |
    (end := stop min:(listOfNodes size)) < start ifTrue:[
        ^ self
    ].
    yBot     := y0.
    yCtr     := yBot - (fontHeight // 2).
    widthLvl := imageInset + imageWidth.
    insetTxt := imageWidth + textInset.
    offIconX := self xOfFigureLevel:0.
    showIndc := false.

    showDirectoryIndicator ifTrue:[
        offIndcX := imageWidth // 2 - widthLvl.
        offIndcY := 0.
        openIndicator notNil ifTrue:[
            icon     := openIndicator extent // 2.
            offIndcX := offIndcX - icon x.
            offIndcY := icon y.
        ]
    ].

    showLines ifTrue:[
        self drawVHLinesX:x0 y:y0 toX:x1 start:start stop:end
    ].

    parent   := 4711.                           "/ to force a recompute
    prevNode := 4711.                           "/ to force a recomputation of the level

    start to:end do:[:anIndex|
        node := listOfNodes at:anIndex.
        yBot := yBot + fontHeight.
        yCtr := yCtr + fontHeight.

        (nxtPrnt := node parent) ~~ parent ifTrue:[
            parent := nxtPrnt.
            xIcon  := prevNode == parent ifTrue:[xIcon + widthLvl]
                                        ifFalse:[node level * widthLvl + offIconX].

            xText    := xIcon + insetTxt.
            showIcon := xIcon < x1 and:[xText > x0].
            showText := xText < x1.

            showDirectoryIndicator ifTrue:[
                xIndc := xIcon + offIndcX.

                showIndc := (      (parent notNil or:[showDirectoryIndicatorForRoot])
                              and:[(xIcon > x0 and:[xIndc < x1])]
                            )
            ]
        ].

        (showIcon and:[(icon := self figureFor:node) notNil]) ifTrue:[
            gc displayForm:icon x:xIcon y:(yCtr - (icon height // 2))
        ].

        showText ifTrue:[
            self redrawLabelAt:xText y:(yBot - fontHeight) index:anIndex
        ].
        (showIndc and:[node showIndicator]) ifTrue:[
            icon := node isCollapsable ifTrue:[openIndicator] ifFalse:[closeIndicator].
            icon notNil ifTrue:[
                gc displayForm:icon x:xIndc y:(yCtr - offIndcY)
            ]
        ].
        prevNode := node.
    ]

    "Modified: / 22.8.1998 / 12:56:50 / cg"
!

redrawSelFrameAtX:x0 y:y0 toX:x1
    "redraw selection frame for a line
    "
    |
     w   "{ Class: SmallInteger }"
     y   "{ Class: SmallInteger }" 
     x   "{ Class: SmallInteger }" 
    |

    hilightFrameColor notNil ifTrue:[
        hilightLevel == 0 ifTrue:[
            gc paint:hilightFrameColor.

            highlightMode == #line ifTrue:[
                gc displayLineFromX:x0 y:y0 toX:x1 y:y0.
                y := y0 + fontHeight - 1.
                gc displayLineFromX:x0 y:y toX:x1 y:y.
            ] ifFalse:[
                gc displayRectangleX:x0 y:y0 width:x1 - x0 height:fontHeight.
            ].
            ^ self
        ].
    ] ifFalse:[
        hilightStyle == #motif ifTrue:[
            gc paint:bgColor.
            y := y0 + 1.
            highlightMode == #line ifTrue:[
                gc displayLineFromX:x0 y:y toX:x1 y:y.
                y := y0 + fontHeight - 2.
                gc displayLineFromX:x0 y:y toX:x1 y:y.
            ] ifFalse:[
                gc displayRectangleX:x0 + 1 y:y width:x1 - x0 - 2 height:fontHeight - 2
            ]
        ]
    ].

    hilightLevel ~~ 0 ifTrue:[
        "/ draw edge

        highlightMode == #line ifTrue:[
            w := ((width - (2 * margin)) max:(self widthOfContents)) + viewOrigin x.
            x := margin - viewOrigin x.
        ] ifFalse:[
            w := x1 - x0.
            x := x0.
        ].
        self drawEdgesForX:x y:y0 width:w height:fontHeight level:hilightLevel.
    ]
!

redrawX:x y:y width:w height:h
    "a region must be redrawn"

    |savClip startLn sel
     y0       "{ Class:SmallInteger }"
     y1       "{ Class:SmallInteger }"
     visStart "{ Class:SmallInteger }"
     visEnd   "{ Class:SmallInteger }"
     stopLn   "{ Class:SmallInteger }"
     maxY     "{ Class:SmallInteger }"
     maxX     "{ Class:SmallInteger }"
     dltLine  "{ Class:SmallInteger }"
     startY   "{ Class:SmallInteger }"|

    shown ifFalse:[^ self].

    visStart := self visibleLineOfY:(y + 1).
    startLn  := self visibleLineToAbsoluteLine:visStart.

    gc paint:bgColor.
    gc fillRectangleX:x y:y width:w height:h.
    startLn isNil ifTrue:[ ^ self ].

    sel     := nil.
    maxX    := x + w.
    maxY    := y + h.
    visEnd  := self visibleLineOfY:maxY.
    startY  := self yOfVisibleLine:visStart.
    dltLine := startLn - visStart.
    stopLn  := dltLine + visEnd.
    
    savClip := self clippingBoundsOrNil.
    self clippingBounds:(Rectangle left:x top:y width:w height:h).

    (highlightMode == #line and:[self hasSelection]) ifTrue:[
        "/ redraw the background for all selected lines in the invalid range

        self selectionDo:[:lnNr|
            (lnNr between:startLn and:stopLn) ifTrue:[
                sel isNil ifTrue:[
                    sel := OrderedCollection new.
                    gc paint:(self hasFocus ifTrue:[hilightBgColor] ifFalse:[hilightBgColorNoFocus]).
                ].
                sel add:(y0 := self yOfVisibleLine:(lnNr - dltLine)).
                y1 := y0 + fontHeight min:maxY.
                y0 := y0 max:y.
                gc fillRectangleX:x y:y0 width:w height:y1 - y0.
            ]
        ]
    ].
    self redrawLinesX:x y:startY toX:maxX start:startLn stop:stopLn.

    "/ draw selection frames
    sel notNil ifTrue:[
        sel do:[:y0| self redrawSelFrameAtX:x y:y0 toX:maxX]
    ].

    self clippingBounds:savClip.
! !

!SelectionInTreeView methodsFor:'enumerating'!

detectNode:aOneArgBlock
    "evaluate the argument, aBlock for each node in the list until
     the block returns true; in this case return the node which caused
     the true evaluation. If none node is detected, nil is returned.
    "
  ^ listOfNodes detect:aOneArgBlock ifNone:nil
!

selectedNodesDo:aOneArgBlock
    "evaluate the block on each node selected
    "
    self selectionDo:[:i| aOneArgBlock value:(listOfNodes at:i) ]
! !

!SelectionInTreeView methodsFor:'event handling'!

activateMenu
    |node menu|

    node := self selectedNode.
    node notNil ifTrue:[
        menu := node middleButtonMenu.
        menu notNil ifTrue:[
            menu isCollection ifTrue:[
                |appl|

                menu := Menu decodeFromLiteralArray:menu.

                (appl := self application) notNil ifTrue:[
                    menu findGuiResourcesIn:appl
                ].
                "/ menu receiver:appl. -- now done in findGuiResources ...
            ].
            self startUpMenu:menu.
            ^ self.
        ].
    ].
    super activateMenu
!

buttonMotion:buttonMask x:x y:y
    "mouse-move while button was pressed - handle selection changes"

    discardMotionEvents ifFalse:[
        super buttonMotion:buttonMask x:x y:y
    ]


!

buttonMultiPress:button x:x y:y

    (self indicatiorLineForButton:button atX:x y:y) == 0 ifTrue:[
        ^ super buttonMultiPress:button x:x y:y
    ].
    "/ discard doubleClick on indicator
!

buttonPress:button x:x y:y
    "handle button press event"

    |node|

    (button == 1) ifTrue:[
        self handleSelectButtonAtX:x y:y.

        (editorWidget isNil
         and:[(node := self selectedNode) notNil
         and:[node canEdit
         and:[x >= (self xOfValueNode:node)]]]
        ) ifTrue:[
            self openEditor
        ].
        ^ self.
    ].
    super buttonPress:button x:x y:y
!

buttonRelease:button x:x y:y
    "stop any autoscroll"

    discardMotionEvents ifTrue:[
        clickPosition := nil.
        discardMotionEvents := false.
    ].
    super buttonRelease:button x:x y:y

!

doubleClicked
    "handle a double click; collapse or expand selected entry
     in case of having children
    "
    |node |

    (node := self selectedNode) notNil ifTrue:[
        (validateDoubleClickBlock isNil
         or:[(validateDoubleClickBlock value:node) ~~ false]) ifTrue:[
            (validateExpandabilityBlock isNil
             or:[(validateExpandabilityBlock value:node) ~~ false]) ifTrue:[
                self selectedNodeExpand:(node isExpandable).
            ].
            node hasChildren ifFalse:[
                super doubleClicked
            ]
        ]
    ]

!

handleSelectButtonAtX:x y:y
    "handle a select button click
    "
    |node lineNr sensor isExpd|

    lineNr := self indicatiorLineForButton:#select atX:x y:y.

    lineNr == 0 ifTrue:[
        ^ super buttonPress:1 x:x y:y
    ].
    node := listOfNodes at:lineNr.

    discardMotionEvents := true.
    dragIsActive  := false.
    clickPosition := nil.

    self hasSelection ifTrue:[
        (selectConditionBlock isNil or:[selectConditionBlock value:lineNr]) ifTrue:[
            self selection:lineNr
        ] ifFalse:[
            self selection:nil
        ]
    ].

    isExpd := node isExpandable.

    (supportsExpandAll
     and:[(sensor := self sensor) ctrlDown or:[sensor shiftDown]]
    ) ifTrue:[
        isExpd ifTrue:[model doExpandAll:node]
              ifFalse:[model doCollapseAll:node]
    ] ifFalse:[
        isExpd ifTrue:[model doExpand:node]
              ifFalse:[model doCollapse:node].
    ].
!

indicatiorLineForButton:aButton atX:x y:y
    "returns linenumber assigned to indicator at x/y or 0
    "
    |nr x0 node|

    (     enabled
     and:[showDirectoryIndicator
     and:[aButton == 1 or:[aButton == #select]]]
    ) ifTrue:[
        nr := self lineAtY:y. "/ self visibleLineToListLine:(self visibleLineOfY:y).

        nr notNil ifTrue:[
            node := listOfNodes at:nr.
            node hasChildren ifTrue:[
                x0   := self xOfFigureLevel:(node level - 1).

                (x > x0 and:[(x0 + imageWidth) > x and:[node children notEmpty]]) ifTrue:[
                    ^ nr
                ]
            ]
        ]
    ].            
    ^ 0
!

isCtrlMetaAltOrShiftPressed
    "returns true if CTRL, META, ALT or SHIFT is pressed"

    ^ self sensor anyModifierKeyDown.
!

key:key select:index x:x y:y
    "select an entry by a keyboard action. This is treated like a doubleClick
     on that entry.
     Add on: In case that the entry is not selectable, scroll to the entry
    "
    (enabled and:[keyActionStyle notNil]) ifFalse:[
        ^ self
    ].

    (selectConditionBlock isNil or:[selectConditionBlock value:index]) ifTrue:[
        ^ super keyPress:key x:x y:y
        "/ ^ super key:key select:index x:x y:y
    ].

    keyActionStyle == #pass ifTrue:[
        ^ self
    ].

    self gotoLine:index
!

keyPress:key x:x y:y
    "handle keyboard input"

    <resource: #keyboard ( #CursorLeft #CursorRight ) >

    |node|     

    enabled ifFalse:[
        ^ self
    ].

    "/ cg: its nicer to expand/collaps on these keys
    key == #CursorRight ifTrue:[
        (node := self selectedNode) notNil ifTrue:[
            model doExpand:node.
            ^ self.
        ].
    ].
    key == #CursorLeft ifTrue:[
        (node := self selectedNode) notNil ifTrue:[
            model doCollapse:node.
            ^ self.
        ].
    ].

    "/ search fwd/bwd for a node with children

"/    (key == #CursorLeft or:[key == #CursorRight]) ifTrue:[
"/        (idx := self selectedIndex) == 0 ifTrue:[ ^ self ].
"/
"/        (key == #CursorLeft) ifTrue:[ inc := -1. end := 0 ]
"/                            ifFalse:[ inc :=  1. end := 1 + listOfNodes size ].
"/
"/        [(idx := idx + inc) ~~ end] whileTrue:[
"/            node := listOfNodes at:idx.
"/            node hasChildren ifTrue:[
"/                ^ self key:key select:idx x:x y:y
"/            ]
"/        ].
"/        ^ self
"/    ].
    ^ super keyPress:key x:x y:y
! !

!SelectionInTreeView methodsFor:'initialization & release'!

create
    super create.
    lineMask := lineMask onDevice:device.

    lineColor := lineColor isNil ifTrue:[fgColor]
                                ifFalse:[lineColor onDevice:device].

    editValueFgColor := editValueFgColor onDevice:device.
!

fetchDefaultImages
    "returns a directory with default keys and images; could be
     redefined by subclass.
    "
    ^ itemClass notNil ifTrue:[itemClass keysAndIcons]
                      ifFalse:[nil]
!

fetchDeviceResources
    "initialize heavily used device resources - to avoid rendering
     images again and again later"

    super fetchDeviceResources.
    self refetchDeviceResources
!

fetchImageResources
    "initialize heavily used device resources - to avoid rendering
     images again and again later; returns maximum extent of the images used.
     Could be redefined by subclass
    "
    |img x y keysAndIcons|

    x := y := 0.
    imageOpened isNil ifTrue:[
        imageOpened := self imageOnMyDevice:(self class imageOpened)
    ].
    imageOpened notNil ifTrue:[
        x := x max:(imageOpened width).
        y := y max:(imageOpened height).
    ].

    imageClosed isNil ifTrue:[
        imageClosed := self imageOnMyDevice:(self class imageClosed)
    ].
    imageClosed notNil ifTrue:[
        x := x max:(imageClosed width).
        y := y max:(imageClosed height).
    ].

    imageItem isNil ifTrue:[
        imageItem := self imageOnMyDevice:(self class imageItem)
    ].
    imageItem notNil ifTrue:[
        x := x max:(imageItem width).
        y := y max:(imageItem height).
    ].

    (keysAndIcons := self fetchDefaultImages) notNil ifTrue:[
        keysAndIcons keysAndValuesDo:[:aKey :anIcon|
            (anIcon isImage and:[aKey notNil]) ifTrue:[
                registeredImages at:aKey put:(self imageOnMyDevice:anIcon)
            ]
        ]
    ].
    registeredImages keysAndValuesDo:[:k :img|
        x := (img width)  max:x.
        y := (img height) max:y.
    ].

    (listOfNodes size > 0 and:[(img := listOfNodes first icon) isImage]) ifTrue:[
        x := (img width)  max:x.
        y := (img height) max:y.
    ].
    ^ x @ y

    "Modified: / 12.8.1998 / 12:45:53 / cg"
!

getFontParameters
    "save old computed height derived from images
    "
    |lineHeight|

    lineHeight := fontHeight ? 0.
    super getFontParameters.
    labelOffsetY := fontAscent - (fontHeight - lineSpacing // 2).

    lineHeight > fontHeight ifTrue:[
        fontHeight := lineHeight
    ].
    fontHeight odd ifTrue:[
        fontHeight := fontHeight + 1
    ]
!

initStyle
    "setup viewStyle specifics"

    super initStyle.
    highlightMode := DefaultHilightMode ? #label.

!

initialize
    "setup instance attributes
    "
    super initialize.

    itemClass isNil ifTrue:[
        itemClass := TreeItem
    ].

    supportsExpandAll := true.
    self bitGravity:#NorthWest.
    showRoot := showDirectoryIndicatorForRoot      := showLines := computeResources := true.
    showDirectoryIndicator := discardMotionEvents := showLinesForRoot := false.
    leftMargin := 2.
    lineMask   := Form width:2 height:2 fromArray:#[16rAA 16r55].
    registeredImages := IdentityDictionary new.
    drawVLinesFromLevel := 1.
    textInset  := 4.
    imageInset := 0.    "/ set during indication enabled
    imageWidth := 8.    "/ default: will change during startup

    buildInArray := Array new:50.       "/ used for temporary calculation
                                        "/ suppress garbage collection

    self model:nil.     "/ creates a default model.
    highlightMode := #label.
    editValueFgColor := Color blue.
!

realize
    super realize.
    self  refetchDeviceResources.
!

recomputeDirectoryIndicator
    "setup attributes used by directory indicator
    "
    |x w|

    imageInset := 0.

    (showDirectoryIndicator and:[computeResources not]) ifFalse:[
        ^ self
    ].

    x := 0.
    openIndicator isNil ifTrue:[
        openIndicator  := self imageOnMyDevice:(self class openIndicator)
    ].
    openIndicator notNil ifTrue:[
        x := openIndicator width
    ].

    closeIndicator isNil ifTrue:[
        closeIndicator := self imageOnMyDevice:(self class closeIndicator)
    ].
    closeIndicator notNil ifTrue:[
        x := x max:(closeIndicator width)
    ].

    x := x // 2.
    w := imageWidth // 2.

    (x := x + self class minImageInset) > w ifTrue:[
        imageInset := x - w.
    ].

    "Modified: / 13.8.1998 / 12:02:04 / cg"
!

refetchDeviceResources
    "reinitialize heavily used device resources - to avoid rendering
     images again and again later
    "
    |extent|

    (realized and:[computeResources and:[listOfNodes size ~~ 0]]) ifTrue:[
        computeResources := false.
        extent := self fetchImageResources.

        extent y >= fontHeight ifTrue:[
            fontHeight := 1 + extent y.
        ].
        fontHeight odd ifTrue:[
            fontHeight := fontHeight + 1
        ].
        "/ round and not odd: because of line drawing

        imageWidth := (extent x) // 2.
        imageWidth odd ifTrue:[imageWidth := imageWidth + 1].
        imageWidth := imageWidth * 2.

        self recomputeDirectoryIndicator.
        self computeNumberOfLinesShown.
    ]
!

release
    "remove dependencies
    "
    rootHolder removeDependent:self.
    selectionHolder removeDependent:self.

    model notNil ifTrue:[
        model stopRunningTasks
    ].
    super release.
! !

!SelectionInTreeView methodsFor:'model'!

getListFromModel
    "if I have a model, get my list from it using the listMessage.
     If listMessage is nil, try aspectMessage for backward compatibilty.
    "
    super list:(self listFromModel) keepSelection:true
!

listFromModel
    "get list from model and return the new list.
     If listMessage is nil, try aspectMessage for backward compatibilty.
    "
    |msg|

    widthOfWidestLine := nil.
    list := listOfNodes := (msg := listMsg ? aspectMsg) notNil ifTrue:[model perform:msg] ifFalse:[#()].
    self refetchDeviceResources.
  ^ listOfNodes
!

model:aModel
    "check whether model is nil; than a default model is created
    "
    |model root|

    model notNil ifTrue:[
        model stopRunningTasks
    ].

    model := aModel ? (self class defaultModelClass new).
    self itemClass:(model class defaultItemClass).
    root  := model root.

    model showRoot:showRoot.

    root notNil ifTrue:[
        root expand
    ].
    super model:model.
    self getListFromModel

!

rootFromModel
    "update hierarchical list from root model; 'rootHolder'
    "
    |root|

    root := rootHolder root.

    self root == root ifFalse:[
        self selection:nil.
        self root:root.
    ].
!

selectionFromModel
    "set the selection derived from the selectionHolder
    "
    |coll value size idx|

    (value := selectionHolder value) notNil ifTrue:[
        (multipleSelectOk and:[value isCollection]) ifFalse:[
            ^ self selectNode:value withNotify:false.
        ].

        (size := value size) ~~ 0 ifTrue:[
            size == 1 ifTrue:[
                ^ self selectNode:(value at:1) withNotify:false
            ].

            model doMakeVisible:value.

            coll := OrderedCollection new:size.

            value do:[:el|
                idx := el isNumber ifTrue:[el] ifFalse:[self indexOfNode:el].

                idx ~~ 0 ifTrue:[
                    coll add:idx
                ].
            ].

            coll := coll asNilIfEmpty.
        ].
    ].
    self setSelection:coll
!

selectionToModel
    "write selection to selection holder
    "
    |newSel oldSel|

    oldSel := selectionHolder value.

    multipleSelectOk ifFalse:[
        (newSel := self selectedNode) ~~ oldSel ifTrue:[
            selectionHolder value:newSel
        ]
    ] ifTrue:[
        selection size == 0 ifTrue:[
            oldSel notNil ifTrue:[
                selectionHolder value:nil
            ]
        ] ifFalse:[
            newSel := selection collect:[:i| listOfNodes at:i].

            newSel size ~~ oldSel size ifTrue:[
                selectionHolder value:newSel.
            ] ifFalse:[
                newSel do:[:aNode|
                    (oldSel includesIdentical:aNode) ifFalse:[
                        ^ selectionHolder value:newSel
                    ]
                ]
            ]
        ]
    ]
! !

!SelectionInTreeView methodsFor:'private'!

closeEditor
    "close the editor
    "
    editorWidget notNil ifTrue:[
        editorWidget destroy.
        editorIndex  := 0.
        editorWidget := nil.
    ].

!

list:aList keepSelection:keepSelection
    "setup new list; keep selection dependent on the boolean state
     keepSelection
    "
    |list|

    list := (aList size == 0) ifTrue:[#()] ifFalse:[aList].
    super list:list keepSelection:keepSelection.
    self refetchDeviceResources.

!

openEditor
    "open an editor on selection
    "
    |node x0 x1 y0|

    editorWidget notNil ifTrue:[
        ^ self
    ].
    editorIndex := self selectedIndex.

    (    (node         := listOfNodes at:editorIndex ifAbsent:nil) isNil
     or:[(y0           := self listLineToVisibleLine:editorIndex) isNil
     or:[(editorWidget := node editor) isNil]]
    ) ifTrue:[   
        ^ self
    ].
    editorWidget withAllSubViewsDo:[:v| v font:gc font ].

    y0 := self yOfVisibleLine:y0.
    x0 := self xOfValueNode:node.
    x1 := (editorWidget preferredWidth) max:50.
    x1 := (x0 + x1) min:(self width - 5).

    editorWidget geometryLayout:(Rectangle left:x0 right:x1 top:y0 bottom:y0 + fontHeight).

    self addComponent:editorWidget.
    editorWidget realize.
    gc paint:bgColor.

    gc fillRectangleX:(x0 - SelectionInset) y:y0
       width:SelectionInset + SelectionInset + (x1 - x0)
       height:fontHeight.
! !

!SelectionInTreeView methodsFor:'private-drag and drop'!

collectionOfDragObjects
    "returns collection of dragable objects assigned to selection
     Here, by default, a collection of text-dragObjects is generated;
     however, if a dragObjectConverter is defined, that one gets a chance
     to convert as appropriate."

    |collection converted selection dLbl dObj node|

    selection  := self selectionAsCollection.

    collection := selection collect:[:nr|
        node := listOfNodes at:nr.
        dObj := self dragObjectForNode:node.
        dObj theObject:(node contents).
        dLbl := LabelAndIcon icon:(self figureFor:node) string:(node name).
        dObj displayObject:dLbl.
        dObj
    ].

    dragObjectConverter notNil ifTrue:[
        converted := OrderedCollection new.
        collection keysAndValuesDo:[:nr :obj | 
            (dObj := dragObjectConverter value:obj) notNil ifTrue:[
                node := listOfNodes at:nr.
                dLbl := LabelAndIcon icon:(self figureFor:node) string:(node name).
                converted displayObject:dLbl.
                converted add:dObj
            ]
        ].
        collection := converted
    ].
    ^ collection.



!

dragObjectForNode:aNode
    "returns the dragable object for a node; could be redefined in subclass
    "
    ^ DropObject new:aNode.


!

startDragX:x y:y
    "start drag
    "
    dragIsActive := true.

    DragAndDropManager startDrag:(self collectionOfDragObjects)
                            from:self
                           atEnd:endDragAction


! !

!SelectionInTreeView methodsFor:'private-queries'!

lengthOfLongestLineBetween:firstLine and:lastLine
    "return the length (in characters) of the longest line in a line-range
    "
    ^ self widthOfContents // fontWidth + 1
!

smallestLevelOfNodesBetween:start and:stop
    "returns the smallest level of the nodes in a line range
    "
    |prevNode currParent nextParent

     lvl "{ Class:SmallInteger }"
     min "{ Class:SmallInteger }"
     end "{ Class:SmallInteger }"
     beg "{ Class:SmallInteger }"
    |

    (end := stop min:(listOfNodes size)) < start ifTrue:[
        ^ 0
    ].

    prevNode   := listOfNodes at:start.
    currParent := prevNode parent.

    currParent isNil ifTrue:[
        ^ 1
    ].

    (min := prevNode level) == 2 ifTrue:[
        ^ min
    ].
    beg := start + 1.

    listOfNodes from:beg to:end do:[:currNode|
        (nextParent := currNode parent) == currParent ifFalse:[
            (currParent := nextParent) == prevNode ifFalse:[
                (lvl := currNode level) == 2 ifTrue:[
                    ^ 2
                ].
                min := min min:lvl
            ]
        ].
        prevNode := currNode
    ].
    ^ min




!

widthOfContents
    "return the width of the contents in pixels
     - used for scrollbar interface"

    listOfNodes isNil ifTrue:[^ 0].

    (widthOfWidestLine isNil or:[widthOfWidestLine == 0]) ifTrue:[
        widthOfWidestLine := self widthOfLongestLine
    ].
  ^ widthOfWidestLine + (leftMargin * 2)

!

widthOfLongestLine
    "return the width of the longest line in pixels
    "
    |parent pItem p
     startX   "{ Class: SmallInteger }"
     deltaX   "{ Class: SmallInteger }"
     level    "{ Class: SmallInteger }"
     width    "{ Class: SmallInteger }"
     maxSz    "{ Class: SmallInteger }"|

    buildInArray atAllPut:0.
    parent := nil.
    maxSz  := 1.
    level  := 1.

    listOfNodes do:[:anItem|
        (p := anItem parent) ~~ parent ifTrue:[
            buildInArray at:level put:maxSz.

            (parent := p) == pItem ifTrue:[level := level + 1]
                                  ifFalse:[level := anItem level].

            maxSz := buildInArray at:level.
        ].
        pItem := anItem.
        maxSz := maxSz max:(anItem name size).
    ].
    buildInArray at:level put:maxSz.

    startX := self xOfStringLevel:1.
    deltaX := imageInset + imageWidth.
    width  := '1' widthOn:self.
    maxSz  := 0.

    buildInArray do:[:el|
        el == 0 ifTrue:[ ^ maxSz + viewOrigin x ].
        maxSz  := maxSz max:(el * width + startX).
        startX := startX + deltaX.
    ].
! !

!SelectionInTreeView methodsFor:'private-redefinitions'!

expandTabs
    "nothing to do
    "


!

list:aCollection expandTabs:expand scanForNonStrings:scan

    includesNonStrings := false.
    self list:aCollection expandTabs:false scanForNonStrings:false includesNonStrings:nil
!

withoutRedrawAt:anIndex put:aString
    "change a line without redisplay and WITHOUT any sizeChange notifications.
     Somewhat dangerous, since scrollBars will not be informed about contents-changes.
     Use only if multiple lines are to be changed, and a sizeChanged is invoked by some other
     means at the end."

    |width|

    width := widthOfWidestLine.
    widthOfWidestLine := nil.
    super withoutRedrawAt:anIndex put:aString.
    widthOfWidestLine := width.

    (widthOfWidestLine notNil and:[aString size ~~ 0]) ifTrue:[
        width := self xOfStringNode:(listOfNodes at:anIndex)
               + (aString widthOn:self)
               + viewOrigin x.

        widthOfWidestLine := widthOfWidestLine max:width.
    ].
! !

!SelectionInTreeView methodsFor:'queries'!

figureFor:aNode
    "return a (bitmap) figure for a node"

    |icon img|

    "/ the item may provide an icon
    "/ (it knows for itself if its open or closed)

    (icon := aNode icon) notNil ifTrue:[
        img := registeredImages at:icon ifAbsent:nil.
        img notNil ifTrue:[
            ^ img
        ].
        icon isImage ifTrue:[
            img := self imageOnMyDevice:icon.
            registeredImages at:icon put:img.
            ^ img
        ]
    ].

    "/ ok, node did not return an icon - use default.

    aNode hasChildren ifFalse:[
        "/ regular
        ^ imageItem 
    ].
    "/ folder
    ^ aNode hidden ifTrue:[imageClosed] ifFalse:[imageOpened]
!

indexOfNode:aNode
    "returns index of a node
    "
    ^ listOfNodes identityIndexOf:aNode
!

xOfFigureLevel:aLevel
    "origin x where to draw the icon
    "
    |l "{ Class:SmallInteger }"|

    l := showRoot ifTrue:[aLevel] ifFalse:[aLevel - 1].

    showDirectoryIndicator ifFalse:[
        l := l - 1
    ] ifTrue:[
        showDirectoryIndicatorForRoot ifFalse:[
            l := l - 1
        ]
    ].
  ^ (l * (imageInset + imageWidth)) + imageInset - viewOrigin x + leftMargin
!

xOfFigureNode:aNode
    "origin x where to draw the icon
    "
    ^ self xOfFigureLevel:(aNode level)
!

xOfStringLevel:aLevel
    "origin x where to draw the text( label )
    "
    ^ (self xOfFigureLevel:aLevel) + imageWidth + textInset

!

xOfStringNode:aNode
    "origin x where to draw the text( label )
    "
    ^ self xOfStringLevel:(aNode level)

!

xOfValueNode:aNode
    "returns the left x position of the start of the value
    "
    |p x|

    p := aNode parent.

    x := p notNil ifTrue:[30 + (p childrenWidthOn:self)]
                 ifFalse:[0].

    ^ x + (self xOfStringNode:aNode)

! !

!SelectionInTreeView methodsFor:'scrolling'!

needScrollToMakeLine:aListLineNr
    "redefined to scroll whenever line is not in top half"

    (aListLineNr >= firstLineShown) ifTrue:[
        (aListLineNr < (firstLineShown + nFullLinesShown)) ifTrue:[
            ^ false
        ]
    ].
    ^ true

!

originChanged:delta
    "sent after scrolling - have to update origin of editor
    "
    super originChanged:delta.

    editorWidget notNil ifTrue:[
        editorWidget origin:(editorWidget origin - delta)
    ]

! !

!SelectionInTreeView methodsFor:'selection'!

selectNode:aNode
    "change selection to a node
    "
    ^ self selectNode:aNode withNotify:true.
!

selectNode:aNode withNotify:withNotify
    "change selection to a node
    "
    |index|

    (index := aNode) notNil ifTrue:[
        index isNumber ifFalse:[
            (index := self indexOfNode:aNode) == 0 ifTrue:[
                model doMakeVisible:aNode.
                index := self indexOfNode:aNode.
            ]
        ].
        index == 0 ifTrue:[
            index := nil
        ]
    ].
    withNotify ifFalse:[
        self setSelection:index
    ] ifTrue:[
        self selection:index 
    ].
!

selectNodes:aCollectionOfNodes
    ^ self selectNodes:aCollectionOfNodes withNotify:true.
!

selectNodes:aCollectionOfNodes withNotify:withNotify
    |selIndexCollection|

    selIndexCollection := aCollectionOfNodes collect:[:eachNode | listOfNodes identityIndexOf:eachNode].
    selIndexCollection := selIndexCollection reject:[:eachIndex | eachIndex == 0].

    withNotify ifTrue:[
        self selection:selIndexCollection.
    ] ifFalse:[
        self setSelection:selIndexCollection.
    ].

"/    first := true.
"/    aCollectionOfNodes do:[:eachNode |
"/        first ifTrue:[
"/            self selectNode:eachNode.
"/            first := false.
"/        ] ifFalse:[
"/            self selectedNodeAdd:eachNode
"/        ]
"/    ].
"/
!

selectedIndex
    "get single selected index or 0
    "
    selection size == 1 ifTrue:[^ selection first].
    selection isNumber  ifTrue:[^ selection].
  ^ 0
!

selectedNode
    "get the single selected node or nil
    "
    |idx|

    (idx := self selectedIndex) ~~ 0 ifTrue:[
        ^ listOfNodes at:idx ifAbsent:nil
    ].
    ^ nil

    "Modified: / 19-01-2011 / 18:41:02 / cg"
!

selectedNodes
    "get a collection of selected nodes
    "
    |selIndexCollection|

    (selIndexCollection := self selection) size == 0 ifTrue:[^ #() ].
    ^ selIndexCollection collect:[:eachIndex | listOfNodes at:eachIndex].
!

selectionChangedFrom:oldSelection
    "update selectionHolder if not nil
    "
    self closeEditor.

    "/ first change my selectionHolders value ...
    selectionHolder notNil ifTrue:[
        self selectionToModel.
    ].

    "/ ... then make notifications.
    super selectionChangedFrom:oldSelection.


!

setSelection:aSelection
    "if no selection exists, close the editor
    "
    (aSelection isNil or:[aSelection == 0]) ifTrue:[
        self closeEditor
    ].
    super setSelection:aSelection


! !

!SelectionInTreeView methodsFor:'selection actions'!

selectedNodeAdd:something
    "add a node or collection of nodes after selected node
    "
    |node|

    something notNil ifTrue:[
        (node := self selectedNode) notNil ifTrue:[
            node parent notNil ifTrue:[
                node isCollapsable ifTrue:[
                    model add:something beforeIndex:1 below:node
                ] ifFalse:[
                    model add:something after:node
                ]
            ] ifFalse:[
                model add:something beforeIndex:1 below:(self root)
            ]
        ]
    ]

!

selectedNodeBecomeChildOfNext
    "make the selected node a child of the next node
    "
    |idx node cprt nprt|

    ((node := self selectedNode) isNil or:[(cprt := node parent) isNil]) ifFalse:[
        idx := cprt indexOfChild:node.

        idx == cprt children size ifFalse:[
            nprt := cprt childAt:(idx + 1).

            nprt notNil ifTrue:[
                self  setSelection:nil.
                model remove:node.
                model add:node beforeIndex:1 below:nprt.
                self selectNode:node.
            ]
        ]
    ]
!

selectedNodeBecomeChildOfPrevious
    "make the selected node a child of the previous node"

    |idx node cprt nprt|

    ((node := self selectedNode) isNil or:[(cprt := node parent) isNil]) ifFalse:[
        idx := cprt indexOfChild:node.

        idx == cprt children size ifFalse:[
            nprt := cprt childAt:(idx - 1).

            nprt notNil ifTrue:[
                self  setSelection:nil.
                model remove:node.
                model add:node below:nprt.
                self selectNode:node.
            ]
        ]
    ]
!

selectedNodeBecomeSisterOfParent
    "become node a sister of its current parent
    "
    |node cprt nprt|

    (    (node := self selectedNode) isNil
     or:[(cprt := node parent) isNil
     or:[(nprt := cprt parent) isNil]]
    ) ifFalse:[
        self  setSelection:nil.
        model remove:node.
        model add:node afterIndex:(nprt indexOfChild:cprt) below:nprt.
        self  selectNode:node.
    ]

!

selectedNodeChangeSequenceOrder:anOffset
    "move child 'anOffset' forward or backward in list of children"

    |idx node size parent|

    (      (node   := self selectedNode) notNil
      and:[(parent := node parent) notNil
      and:[(size   := parent children size) > 1]]
    ) ifTrue:[
        idx := parent indexOfChild:node.
        self setSelection:nil.
        model remove:node.

        (idx := idx + anOffset) < 1 ifTrue:[
            idx := size
        ] ifFalse:[
            idx > size ifTrue:[idx := 1]
        ].
        model add:node beforeIndex:idx below:parent.
        self selectNode:node.
    ]
!

selectedNodeExpand:doExpand
    "collapse or expand selected node
    "
    |node|

    (node := self selectedNode) notNil ifTrue:[
        doExpand ifTrue:[model doExpand:node]
                ifFalse:[model doCollapse:node]
    ]
!

selectedNodesBecomeChildrenOfNext
    "make the selected nodes children of the next node"

    |indices maxIndex nodes newParent|

    nodes := self selectedNodes.
    nodes size == 0 ifTrue:[^ self].

    indices := nodes collect:[:eachNode | listOfNodes identityIndexOf:eachNode].
    maxIndex := indices max.

    newParent := listOfNodes at:(maxIndex + 1) ifAbsent:nil.
    newParent isNil ifTrue:[^ self].

    indices sortWith:nodes.

    nodes reverseDo:[:eachNodeToMove |
        model remove:eachNodeToMove.
        model add:eachNodeToMove beforeIndex:1 below:newParent.
    ].
    self selectNodes:nodes.
!

selectedNodesBecomeSistersOfParent
    "move selected nodes up (out of their parent to their grandparent).
     I.e. nodes become sisters of their current parent
    "
    |nodes parent grandParent indices|

    nodes := self selectedNodes.
    nodes size == 0 ifTrue:[^ self].

    "/ common parent ?
    parent := nodes first parent.
    (nodes conform:[:eachNode | eachNode parent == parent]) ifFalse:[^ self].

    "/ is there a grandparent ?
    grandParent := parent parent.
    grandParent isNil ifTrue:[^ self].

    self  setSelection:nil.
    indices := nodes collect:[:eachNode | listOfNodes identityIndexOf:eachNode].
    indices sortWith:nodes.

    nodes reverseDo:[:eachNodeToMove |
        model remove:eachNodeToMove.
        model add:eachNodeToMove afterIndex:(grandParent indexOfChild:parent) below:grandParent.
    ].
    self selectNodes:nodes.
!

selectedNodesRemove
    "remove selected nodes
    "
    |selection|

    selection := self selection.
    self selection:nil.
    model remove:selection.
! !

!SelectionInTreeView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

