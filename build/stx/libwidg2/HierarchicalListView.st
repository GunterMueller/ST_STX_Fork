"
 COPYRIGHT (c) 1999 by eXept Software AG
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

SelectionInListModelView subclass:#HierarchicalListView
	instanceVariableNames:'imageInset imageWidth lineColor showRoot showLines
		useDefaultIcons icons openIndicator closeIndicator indicatorWidth
		indicatorHeight alignTextRight iconAlignment alignTextRightX
		maxWidthOfText minLineHeight levelOfLastItem expandOnSelect
		autoScrollHorizontal showIndicators showLeftIndicators
		indicatorAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Trees'
!

!HierarchicalListView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    This class implements a hierarchical list view based on a
    hierachical list.
    It provides functionality similar to SelectionInTreeView, but optimizes
    redraws, and operates directly on the model 
    (in contrast to SelectionInTreeView, which generates a list internally).

    [Instance variables:]
        textStartLeft       <Integer>              inset between icon and text
        imageInset          <Integer>              inset between left side and icon
        imageWidth          <Integer>              width of widest icon
        minLineHeight       <Integer>              minimum required line height
                                                   including open/close indication ...
        indicatorWidth      <Integer>              max. width  of indicator
        indicatorHeight     <Integer>              max. height of indicator

        lineMask            <Form>                 line mask
        lineColor           <Color>                line color
        showRoot            <Boolean>              root element is shown or hidden
                                                   derives from the hierachical list.
        showLines           <Boolean>              show or hide lines
        showIndicators      <Boolean>              show or hide indicators
        useDefaultIcons     <Boolean>              use the default icons if no icon
                                                   for an item is specified
        icons               <IdentityDictionary>   list of registered icons;
                                                   identifier := <key> value := <icon>
        showLeftIndicators  <Boolean>              show or hide indicator for most left items
        indicatorAction     <Block>                action evaluated if indicator is pressed (0/1/2 arguments)
        openIndicator       <Icon, Image or Form>  expanded indicator
        closeIndicator      <Icon, Image or Form>  collapsed indicator

        alignTextRight      <Boolean>              enable disable of align the text right
                                                   icon            text
                                                        icon       text of child
                                                   should be set after creation of the widget!!
        alignTextRightX     <Integer>              left x position of aligned right text
        maxWidthOfText      <Integer>              keeps the maximum width of a text label

        levelOfLastItem     <Integer>              keeps the level of the last item;
                                                   in case of a delete last items from list
                                                   we know were to redraw lines from

        autoScrollHorizontal <Boolean>             true, than automatically scroll horizontal upto
                                                   the text label of the current selected line.

        expandOnSelect      <Boolean>              true, than the item selected by a buttonPress
                                                   event will be immediately expanded.

    [author:]
        Claus Atzkern

    [see also:]
        ListModelView
        SelectionInListModelView
        HierarchicalList
        HierarchicalItem
"
!

examples
"
    show a hierarchical list
									[exBegin]
    |top sel list item|

    list := HierarchicalList new.
    item := HierarchicalItem::Example labeled:'Root Item'.

    item expand.
    list showRoot:false.
    list root:item.

    top := StandardSystemView new; extent:300@300.
    sel := ScrollableView for:HierarchicalListView miniScrollerH:true
		       origin:0.0@0.0 corner:1.0@1.0 in:top.

    sel list:list.
    sel multipleSelectOk:true.

    sel doubleClickAction:[:i| (list at:i) toggleExpand ].
    sel   indicatorAction:[:i| (list at:i) toggleExpand ].

    top open.
									[exEnd]


    show a hierarchical list; open an editor on reselect a
    line with label is a string.

									[exBegin]
    |top sel list item|

    list := HierarchicalList new.
    item := HierarchicalItem::Example labeled:'Root Item'.

    item expand.
    list showRoot:false.
    list root:item.

    top := StandardSystemView new; extent:300@300.
    sel := ScrollableView for:HierarchicalListView miniScrollerH:true
		       origin:0.0@0.0 corner:1.0@1.0 in:top.

    sel list:list.

    sel openEditorAction:[:ln :aGC| |field item|
	item  := list at:ln.

	item label isString ifFalse:[
	    field := nil
	] ifTrue:[
	    field := EditField new.
	    field level:0.
	    field acceptOnLostFocus:true.
	    field acceptAction:[:x| item label:(field contents) ].
	    field font:(aGC font).
	    field contents:(item label).
	].
	field
    ].

    sel multipleSelectOk:true.

    sel doubleClickAction:[:i| (list at:i) toggleExpand ].
    sel   indicatorAction:[:i| (list at:i) toggleExpand ].

    top open.
									[exEnd]

									[exBegin]
    |top sel list item|

    list := HierarchicalList new.
    item := HierarchicalItem::Example labeled:'Root Item'.

    item expand.
    list showRoot:false.
    list root:item.

    top := StandardSystemView new; extent:300@300.
    sel := ScrollableView for:HierarchicalListView miniScrollerH:true
		       origin:0.0@0.0 corner:1.0@1.0 in:top.

    sel openIndicator:(ToolbarIconLibrary down22x22Icon).
    sel closeIndicator:(ToolbarIconLibrary downRight22x22Icon).
    sel showLines:false.

    sel list:list.
    sel multipleSelectOk:true.
    sel alignTextRight:true.
    sel doubleClickAction:[:i| (list at:i) toggleExpand ].
    sel   indicatorAction:[:i| (list at:i) toggleExpand ].

    top open.
									[exBegin]


"
!

test
    |top sel list item|

    list := HierarchicalList new.
    item := HierarchicalItem::Example labeled:'Root Item'.

    item expand.
    list showRoot:false.
    list root:item.

    top := StandardSystemView extent:300@300.
    sel := ScrollableView for:HierarchicalListView miniScrollerH:true
                       origin:0.0@0.0 corner:1.0@1.0 in:top.

    sel useDefaultIcons:false.
    sel list:list.
    sel multipleSelectOk:true.
    sel showLines:false.

    sel doubleClickAction:[:i| (list at:i) toggleExpand ].
    sel   indicatorAction:[:i| (list at:i) toggleExpand ].

    top open.
! !

!HierarchicalListView class methodsFor:'resources'!

closeIndicator
     ^ ToolbarIconLibrary closeIndicatorInTree

    "Modified: / 19-12-2010 / 09:05:57 / cg"
!

collapsedIcon
    ^ ToolbarIconLibrary collapsedIconInTree
!

emptyIcon
    ^ ToolbarIconLibrary emptyIconInTree.
!

expandedIcon
    ^ ToolbarIconLibrary expandedIconInTree.
!

openIndicator
     ^ ToolbarIconLibrary openIndicatorInTree

    "Modified: / 19-12-2010 / 09:06:14 / cg"
! !

!HierarchicalListView methodsFor:'accessing'!

font:aFont
    "set a new font; if the font changed, all my items
     have to clear their cached width and height."

    |root|

    (aFont notNil and:[aFont ~= gc font]) ifTrue:[
        root := self root.
        root notNil ifTrue:[root fontChanged].
        super font:aFont
    ].
!

list:aList
    aList notNil ifTrue:[
	aList isHierarchicalItem ifTrue:[
	    self list root:aList.
	    aList expand.
	    ^ self
	].
	showRoot := aList showRoot.
    ].
    super list:aList
!

newDefaultList
    "creates and returns a new default list class, on default a HierarchicalList
    "
    |list|

    list := HierarchicalList new.
    list showRoot:(showRoot ? true).
    ^ list
!

root
    "return the anchor of the list or nil"

    |myList|

    myList := self list.
    ^ myList isNil ifTrue:[nil] ifFalse:[myList root]
! !

!HierarchicalListView methodsFor:'accessing-behavior'!

autoScrollHorizontal
    "returns true if automatic horizontal scrolling
     (upto the text label of the selected line)
     is allowed (the default is as specified in the styleSheet)."

    ^ autoScrollHorizontal == true
!

autoScrollHorizontal:aBoolean
    "true, than automatically scroll horizontal upto the text label
     of the current selected line."

    autoScrollHorizontal := aBoolean.
!

expandOnSelect
    "true, than the item selected by a buttonPress event will
     be immediately expanded.
    "
    ^ expandOnSelect
!

expandOnSelect:aBoolean
    "true, than the item selected by a buttonPress event will
     be immediately expanded.
    "
    expandOnSelect := aBoolean.
! !

!HierarchicalListView methodsFor:'accessing-colors'!

lineColor
    "get the color of the horizontal and vertical lines
    "
    ^ lineColor
!

lineColor:aColor
    "set the color of the horizontal and vertical lines
    "
    (aColor notNil and:[aColor ~= lineColor]) ifTrue:[
        lineColor := aColor.

        shown ifTrue:[
            lineColor := lineColor onDevice:device.
            showLines ifTrue:[ self invalidate ]
        ]
    ].
! !

!HierarchicalListView methodsFor:'accessing-look'!

alignTextRight
    "align the text right
    "
    ^ alignTextRight
!

alignTextRight:aBool
    "align the text right
    "
    alignTextRight := aBool ? false.
!

alignTextRightX
    "returns the minimum used text inset, if text is aligned right.
    "
    ^ alignTextRightX
!

alignTextRightX:aNumber
    "set the minimum used text inset, if text is aligned right.
    "
    aNumber > 0 ifTrue:[
	alignTextRightX := aNumber.

	(alignTextRight and:[widthOfContents notNil]) ifTrue:[
	    widthOfContents := alignTextRightX + maxWidthOfText.

	    shown ifTrue:[
		self invalidate.
		self contentsChanged.
	    ]
	]
    ].
!

closeIndicator:anIconOrNil
    closeIndicator ~= anIconOrNil ifTrue:[
	closeIndicator := self imageOnMyDevice:anIconOrNil.
	self indicatorIconChanged.
    ].
!

iconAlignment:aSymbol
    "alignment of the icons
	#left       align icons left
	#right      align icons right
	#center     align icons center between left and right
    "
    aSymbol ~~ iconAlignment ifTrue:[
	iconAlignment := aSymbol.
	self invalidate.
    ].
!

iconAt:aKey ifAbsentPut:aBlock
    "return the icon stored under a key; if not present,the
     result of the block if not nil is stored under the key
     and returned.
    "
    |icon|

    icon := icons at:aKey ifAbsent:nil.
    icon notNil ifTrue:[^ icon].

    icon := aBlock value.
    icon isNil ifTrue:[^ nil].

    realized ifTrue:[
	icon := self imageOnMyDevice:icon
    ].
    icons at:aKey put:icon.
    ^ icon
!

openIndicator
    ^ openIndicator
!

openIndicator:anIconOrNil
    openIndicator ~= anIconOrNil ifTrue:[
	openIndicator := self imageOnMyDevice:anIconOrNil.
	self indicatorIconChanged.
    ].
!

registerKeysAndIcons:aDictionary
    "register icons by key and value derived from a directory
    "
    |image|

    (aDictionary isEmptyOrNil) ifTrue:[
	^ self
    ].

    aDictionary keysAndValuesDo:[:aKey :anImage|
	(image := self imageOnMyDevice:anImage) notNil ifTrue:[
	    icons at:aKey put:image
	] ifFalse:[
	    icons removeKey:aKey ifAbsent:nil
	]
    ]
!

selectedVisualBlock
    "/ To be polymorph with SelectionInListView

    ^nil

    "Created: / 10-04-2014 / 11:53:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedVisualBlock: aBlockOrNil
    "/ To be polymorph with SelectionInListView

    "Created: / 10-04-2014 / 11:53:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showIndicators
    "returns true if indicators are shown
    "
    ^ showIndicators
!

showIndicators:aBoolean
    "true if indicators are shown
    "
    showIndicators ~~ aBoolean ifTrue:[
	showIndicators := aBoolean.
	self invalidate.
    ].
!

showLeftIndicators
    "show or hide the indicators for the most left items
    "
    ^ showLeftIndicators

!

showLeftIndicators:aBoolean
    "show or hide the indicators for the most left items
    "
    |oldInset newInset|

    aBoolean == showLeftIndicators ifTrue:[ ^ self ].

    (widthOfContents isNil or:[self size == 0]) ifTrue:[
	showLeftIndicators := aBoolean.
	^ self
    ].

    oldInset := self xVisibleOfIconAtLevel:3.
    showLeftIndicators := aBoolean.
    newInset := self xVisibleOfIconAtLevel:3.

    newInset ~~ oldInset ifTrue:[
	widthOfContents := widthOfContents + (newInset - oldInset).
    ].

    self invalidate.

    newInset ~~ oldInset ifTrue:[
	self contentsChanged
    ].
!

showLines
    "returns true if lines are shown
    "
    ^ showLines
!

showLines:aBoolean
    "show or hide lines
    "
    aBoolean ~~ showLines ifTrue:[
	showLines := aBoolean.
	self invalidate.
    ].
!

showRoot
    "true if the root is shown
    "
    ^ showRoot
!

showRoot:aBoolean
    "controls if the root is to be shown
    "
    showRoot ~~ aBoolean ifTrue:[
        showRoot := aBoolean.
        self list showRoot:showRoot.
        self invalidate
    ].
!

useDefaultIcons
    "use the default icons if no icon for an item is specified;
     ** default: true
    "
    ^ useDefaultIcons
!

useDefaultIcons:aBoolean
    "use the default icons if no icon for an item is specified;
     ** default: true
    "
    useDefaultIcons ~~ aBoolean ifTrue:[
	useDefaultIcons := aBoolean.
	self invalidate.
    ]
!

visualBlock
    "/ To be polymorph with SelectionInListView

    ^nil

    "Created: / 10-04-2014 / 11:51:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visualBlock: aBlockOrNil
    "/ To be polymorph with SelectionInListView

    "Created: / 10-04-2014 / 11:53:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HierarchicalListView methodsFor:'actions'!

indicatorAction
    "the action evaluated if an indicator is pressed; otherwise
     if indicators are shown a default action is performed (toggle expand item).

     The arguments to the block are:
	- no argument
	-  1 argument     index
	-  2 argument     index, self
    "
    ^ indicatorAction
!

indicatorAction:anAction
    "the action evaluated if an indicator is pressed; otherwise
     if indicators are shown a default action is performed (toggle expand item).

     The arguments to the block are:
	- no argument
	-  1 argument     index
	-  2 argument     index, self
    "
    indicatorAction := anAction.
! !

!HierarchicalListView methodsFor:'change & update'!

indicatorIconChanged
    |w h|

    w := h := 9.

    openIndicator notNil ifTrue:[
	w := w max:(openIndicator width).
	h := h max:(openIndicator height).
    ].
    closeIndicator notNil ifTrue:[
	w := w max:(closeIndicator width).
	h := h max:(closeIndicator height).
    ].

    (w == indicatorWidth and:[h == indicatorHeight]) ifTrue:[
	self invalidate.
    ] ifFalse:[
	indicatorWidth  := w.
	indicatorHeight := h.

	self lostSynchronisation.   "/ must recompute all
    ].
!

indicatorPressedAt:aLnNr
    "handle indicator pressed action;
     if the item changed expanded, we try to show all
     new visible children"

    |item expanded dl sensor|

    showIndicators ifFalse:[^ self].

    item := self at:aLnNr ifAbsent:nil.
    item isNil ifTrue:[^ self].

    item hasIndicator ifFalse:[^ self].

    expanded := item isExpanded.

    indicatorAction notNil ifTrue:[
        indicatorAction valueWithOptionalArgument:aLnNr and:self.
    ] ifFalse:[
        sensor := self sensor.
        (sensor ctrlDown or:[sensor shiftDown]) ifTrue:[
            item recursiveToggleExpand
        ] ifFalse:[
            item toggleExpand
        ].
    ].

    (expanded or:[item isExpanded not]) ifTrue:[^ self].

    (self yVisibleOfLine:aLnNr+1) > self height ifTrue:[
        dl := (self yVisibleOfLine:aLnNr+1) - (self yVisibleOfLine:aLnNr).
        self scrollTo:(viewOrigin x @ (viewOrigin y + dl)).
    ].

"/    numChildren := item numberOfVisibleChildren.
"/    numChildren == 0 ifTrue:[
"/        ^ self
"/    ].

"/    idx    := aLnNr + numChildren.
"/    vwOrgY := viewOrigin y.
"/    availY := (self yVisibleOfLine:aLnNr) - (self yVisibleOfLine:1).
"/
"/    availY > margin ifTrue:[
"/        usedY := (self yVisibleOfLine:(idx + 1)) - (height - margin - margin).
"/
"/        usedY > 1 ifTrue:[
"/            vwOrgY := vwOrgY + (usedY min:availY).
"/        ].
"/    ].
"/    vwOrgX := self computeViewOriginXat:aLnNr.
"/    self scrollTo:(vwOrgX @ vwOrgY).

    "Modified: / 19-09-2007 / 08:48:15 / cg"
!

lineChangedAt:aLnNr with:arg
    "line changed at position; check whether line height changed
    "
    |item
     level "{ Class:SmallInteger }"
     x0 "{ Class:SmallInteger }"
     x1 "{ Class:SmallInteger }"
     y0 "{ Class:SmallInteger }"
     y1 "{ Class:SmallInteger }"
     yB "{ Class:SmallInteger }"
    |

    item := self at:aLnNr ifAbsent:nil.
    item isNil ifTrue:[^ self].

    (arg == #icon or:[arg == #hierarchy]) ifFalse:[
	super lineChangedAt:aLnNr with:arg.

	(arg ~~ #redraw and:[widthOfContents notNil]) ifTrue:[
	    x0 := (self xVisibleOfTextAtLevel:(item level))
		+ (listRenderer widthFor:item)
		+ (viewOrigin x).

	    x0 > widthOfContents ifTrue:[
		widthOfContents := x0.
		self contentsChanged.
	    ]
	].
	^ self
    ].
    level := item level.

    (alignTextRight and:[arg == #hierarchy]) ifTrue:[
	"/ must test whether alignTextRightX is enough
	(item isExpanded and:[item hasChildren]) ifTrue:[
	    x0 := self xVisibleOfIconAtLevel:(level + 2).

	    alignTextRightX < x0 ifTrue:[
		alignTextRightX := x0.
		self invalidate.

		widthOfContents notNil ifTrue:[
		    widthOfContents := alignTextRightX + maxWidthOfText.
		    self contentsChanged.
		].
		^ self.
	    ]
	]
    ].
    shown ifFalse:[^ self].

    yB := height - margin.
    y0 := (self yVisibleOfLine:aLnNr) max:margin.
    y0 < yB ifFalse:[ ^ self ].

    y1 := (self yVisibleOfLine:(aLnNr + 1)) min:yB.
    y1 > y0 ifFalse:[^ self].

    x1 := (self xVisibleOfTextAtLevel:level) - 1.
    x1 > margin ifFalse:[^ self].

    x0 := (self xVisibleOfIndicatorAtLevel:level) max:margin.
    x1 := x1 min:(width - margin).

    x0 < x1 ifTrue:[
	self invalidate:(Rectangle left:x0 top:y0 width:(x1 - x0) height:(y1 - y0))
	      repairNow:false.
    ].
!

listChangedInsert:firstAddedIndex nItems:nLines
    "must draw vertical lines above the added items
    "
    |item level yTop yBot xLft start maxY|

    super listChangedInsert:firstAddedIndex nItems:nLines.

    item := self last.
    levelOfLastItem := item level.

    (     shown
     and:[showLines
     and:[firstAddedIndex > 1
     and:[nLines ~~ 0
     and:[(item := self at:firstAddedIndex ifAbsent:nil) notNil
     and:[(level := item level) > 1]]]]]
    ) ifFalse:[
	^ self.
    ].
    xLft := self xVisibleOfVerticalLineAt:level.

    (xLft > margin and:[xLft < (width - margin)]) ifFalse:[
	^ self
    ].
    start := firstAddedIndex - 1.

    start to:1 by:-1 do:[:i| |el|
	el := self at:i.

	el level <= level ifTrue:[
	    i == start ifTrue:[^ self].

	    yTop := (self yVisibleOfLine:i + 1) max:margin.
	    maxY := height - margin.

	    yTop < maxY ifTrue:[
		yBot := (self yVisibleOfLine:firstAddedIndex) - 1 min:maxY.
		self invalidate:(Rectangle left:xLft top:yTop width:2 height:(yBot - yTop))
	    ].
	    ^ self
	]
    ].
!

listChangedRemove:aStart toIndex:aStop
    "test whether last items are deleted;
     than we have to redraw lines because of different levels
    "
    |listSize index y0 searchLevel|

    listSize    := self size.
    searchLevel := levelOfLastItem.

    listSize == 0 ifTrue:[ levelOfLastItem := 1 ]
		 ifFalse:[ levelOfLastItem := self last level ].

    (shown and:[showLines and:[listSize ~~ 0 and:[aStart > listSize]]]) ifTrue:[
	index := self findLast:[:el| el level <= searchLevel ].

	(index ~~ 0 and:[index < listSize]) ifTrue:[
	    y0 := (self yVisibleOfLine:index) max:margin.
	    self invalidateX:0 y:y0 width:width height:(height - margin - y0).
	]
    ].
    ^ super listChangedRemove:aStart toIndex:aStop
!

updateFromList:what with:aPara
    "get the status of <showRoot> from the list
    "
    |newState|

    newState := self list showRoot.

    showRoot ~~ newState ifTrue:[
	showRoot := newState.
	self invalidate.
    ].
    super updateFromList:what with:aPara.
! !

!HierarchicalListView methodsFor:'drawing basics'!

drawElementsFrom:start to:stop x:xLeft y:yT w:w
    "draw the items between start to stop without clearing the background
    "
    |item prevParent icon showIndc showIcon showText
     yTop yCtr yBot level xIndc xIcon yIcon xText xL xR height offIndcY icnWdt x|

    xL := xLeft.
    xR := xL + w.

    showIndicators ifTrue:[
	offIndcY := indicatorWidth // 2.
    ].

    showLines ifTrue:[
	self drawLinesFrom:start to:stop x:xL y:yT toX:xR
    ].
    prevParent := #NIL.         "/ to force a recompute
    yBot       := yT.
    showIndc   := false.

    start to:stop do:[:anIndex|
	(item := self at:anIndex ifAbsent:nil) isNil ifTrue:[
	    ^ self      "/ list changed
	].
	yTop   := yBot.
	yBot   := self yVisibleOfLine:(anIndex + 1).
	height := yBot - yTop.
	yCtr   := yTop + (height // 2).

	item parent ~~ prevParent ifTrue:[
	    prevParent  := item parent.
	    level       := item level.
	    xIcon       := self xVisibleOfIconAtLevel:level.
	    xText       := self xVisibleOfTextAtLevel:level.
	    showText    := (xText < xR).
	    showIcon    := (xIcon < xR and:[xText > xL]).

	    showIndicators ifTrue:[
		xIndc  := self xVisibleOfIndicatorAtLevel:level.
		showIndc := (xIcon > xL and:[xIndc < xR]).

		showIndc ifTrue:[
		    showIndc := prevParent notNil or:[showLeftIndicators]
		]
	    ]
	].

	(showIcon and:[(icon := self validateDrawableIconFor:item) notNil]) ifTrue:[
	    icnWdt := icon width.

	    (xIcon + icnWdt) > xL ifTrue:[
		iconAlignment == #left ifTrue:[
		    x := xIcon.
		] ifFalse:[
		    x := xText - textStartLeft.

		    iconAlignment == #center ifTrue:[
			x := (x + xIcon - icnWdt) // 2.
		    ] ifFalse:[
			x := x - icnWdt.
		    ].
		].
		yIcon := yCtr - (icon height // 2).
		item displayIcon:icon atX:x y:yIcon on:self.
	    ]
	].

	showText ifTrue:[
	    self drawLabelAt:anIndex x:xText y:yTop h:height
	].
	(showIndc and:[item hasIndicator]) ifTrue:[
	    item isExpanded ifTrue:[icon := openIndicator ]
			   ifFalse:[icon := closeIndicator].

	    icon notNil ifTrue:[
		icon displayOn:self x:xIndc y:(yCtr - offIndcY).
	    ].
	].
    ].

    "Modified: / 23-06-2006 / 12:49:26 / fm"
!

drawLinesFrom:start to:stop x:xL y:yT toX:xR
    "draw the lines between start to stop without clearing the background"

    |item yNext|

    UserPreferences current showDottedLinesInTree ifFalse:[^ self].

    item := list at:start ifAbsent:nil.
    item isNil ifTrue:[^ nil].
    
    self paint:lineColor on:bgColor.

    OperatingSystem isMSWINDOWSlike ifTrue:[
        self mask:nil.
        self lineStyle:#dotted.
    ] ifFalse:[
        self maskOrigin:( (self viewOrigin + (0 @ 1)) \\ (lineMask extent)).
        self mask:lineMask.
    ].

    "/ draw all vertical lines
    list from:start to:stop do:[:eachItem|
        self drawVericalLineForElement:eachItem minX:xL maxX:xR.
    ].
    item notNil ifTrue:[
        [ (item := item parent) notNil ] whileTrue:[
            self drawVericalLineForElement:item minX:xL maxX:xR.
        ].
    ].
    
    "/ draw all the horizontal lines
    yNext := self yVisibleOfLine:start.

    start to:stop do:[:anIndex|
        |y0 index x0 x1 itemLevel|

        item := list at:anIndex ifAbsent:nil.
        item isNil ifTrue:[
            self lineStyle:#solid.
            self mask:nil.
            ^ self
        ].

        y0    := yNext.
        yNext := self yVisibleOfLine:anIndex + 1.

        item parent isNil ifTrue:[
            index := showRoot ifTrue:[0] ifFalse:[-1].
        ] ifFalse:[
            index := list identityIndexOf:(item parent).
        ].
        index == 0 ifTrue:[
            (showLeftIndicators and:[item hasIndicator]) ifTrue:[
                index := 1.
            ]
        ].

        index > 0 ifTrue:[
            itemLevel := item level.

            x0 := self xVisibleOfVerticalLineAt:itemLevel.

            item drawHorizontalLineUpToText ifTrue:[
                x1 := (self xVisibleOfTextAtLevel:itemLevel) - textStartLeft.
            ] ifFalse:[
                x1 := self xVisibleOfVerticalLineAt:(itemLevel + 1).
            ].                
            y0 := (y0 + yNext ) // 2.
            self displayLineFromX:x0 y:y0 toX:x1 y:y0.
        ].
    ].

    self lineStyle:#solid.
    self mask:nil.

    "Modified: / 03-12-2010 / 19:28:23 / cg"
!

drawVericalLineForElement:item minX:xL maxX:xR
    "draw the vertical line my children are connected to"

    |itemLevel y0 y1 x0|

    (item notNil and:[item isExpanded and:[item hasChildren]]) ifTrue:[
        itemLevel := item level.
        
        itemLevel == 1 ifTrue:[
            showRoot ifFalse:[^ self].
        ].
        x0 := self xVisibleOfVerticalLineAt:(itemLevel + 1).

        (x0 between:xL and:xR) ifTrue:[
            y0 := self yVisibleOfIndicatorForItem:item.
            y1 := self yVisibleOfIndicatorForItem:(item last).

            y1 > y0 ifTrue:[
                self displayLineFromX:x0 y:y0 toX:x0 y:y1.
            ].
        ].
    ].
!

validateDrawableIconFor:anItem
    "returns the icon to be drawn for an item or nil
     test the extent of the icon; on error an exception is raised
    "
    |width needMore icon maxLevel startOfText oldX newX|

    Error handle:[:ex |
        Transcript showCR:'HierachicalListView: error in redraw'.
        ^ nil.
    ] do:[
        icon := self iconFor:anItem.
    ].
    icon isNil ifTrue:[^ nil].

    width := icon width.

    (constantHeight notNil and:[icon height > constantHeight]) ifTrue:[
        constantHeight := icon height + lineSpacing.
        self recomputeHeightOfContents.

        width <= imageWidth ifTrue:[
            self contentsChanged.
            StopRedrawSignal raiseRequest
        ].
    ] ifFalse:[
        width <= imageWidth ifTrue:[ ^ icon ].
    ].

    maxLevel := 1.

    self list criticalDo:[
        self list do:[:el| maxLevel := maxLevel max:(el level) ].
    ].

    needMore        := (width - imageWidth) max:2.
    oldX            := self xVisibleOfIconAtLevel:(maxLevel + 1).
    imageWidth      := imageWidth + needMore.
    newX            := self xVisibleOfIconAtLevel:(maxLevel + 1).
    alignTextRightX := alignTextRightX max:newX.

    widthOfContents notNil ifTrue:[
        alignTextRight ifTrue:[
            widthOfContents := alignTextRightX + maxWidthOfText
        ] ifFalse:[
            widthOfContents := widthOfContents + (newX - oldX)
        ].
        width           := listRenderer widthFor:anItem.
        startOfText     := self xVisibleOfTextAtLevel:(anItem level).
        widthOfContents := widthOfContents max:(startOfText + width).

        width > maxWidthOfText ifTrue:[
            maxWidthOfText := width
        ].
    ].
    self contentsChanged.
    StopRedrawSignal raiseRequest.
    ^ icon

    "Modified: / 05-11-2013 / 12:32:32 / cg"
! !

!HierarchicalListView methodsFor:'event handling'!

buttonPress:button x:x y:y
    "handle a button press event"

    |line item xIcon xLabel yItem x0|

    modelChangedDuringButtonPress := nil.

    enabled ifFalse:[^ self].
    self closeEditor.

    line := self yVisibleToLineNr:y.
    line notNil ifTrue:[
        item := self at:line ifAbsent:nil.
        item notNil ifTrue:[
            "/ translate the coordinate relative to the items origin
            (item processButtonPress:button visibleX:x visibleY: y on: self) ifTrue:[
                ^self
            ].
        
            xIcon := self xVisibleOfIconAtLevel:(item level).
            x >= xIcon ifTrue:[
                xLabel := self xVisibleOfTextAtLevel:(item level).
                yItem := self yVisibleOfLine:line.

                x >= xLabel ifTrue:[
                    (item processButtonPress:button x:(x - xLabel) y:(y - yItem) on:self) == true ifTrue:[
                        ^ self
                    ]
                ].
                (item processButtonPressOnIcon:button on:self) == true ifTrue:[
                    ^ self
                ]
            ].
        ]
    ] ifFalse:[
        item := nil
    ].

    showIndicators ifTrue:[
        (button == 1) ifTrue:[
            (item notNil and:[item hasIndicator]) ifTrue:[
                x0 := self xVisibleOfIndicatorAtLevel:(item level).

                (x between:x0 and:(x0 + indicatorWidth)) ifTrue:[
                    (item isExpanded and:[item canCollapse not]) ifTrue:[
                        "/ a special one (like a non-collapsable root)
                    ] ifFalse:[
                        self indicatorPressedAt:line.
                        ^ self
                    ].
                ].
            ].
        ].
    ].

    super buttonPress:button x:x y:y.

    "Modified: / 18-04-2013 / 09:56:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buttonPressOrReleaseAtLine:aLnNr x:x y:y
    "handle a button press or release at a line
    "
    |oldIdx newIdx newItem|

    oldIdx := self selectedIndex.
    super buttonPressOrReleaseAtLine:aLnNr x:x y:y.
    newIdx := self selectedIndex.

    (newIdx ~~ oldIdx and:[newIdx ~~ 0]) ifTrue:[
	expandOnSelect ifTrue:[
	    newItem := self at:newIdx ifAbsent:nil.
	    newItem isNil ifTrue:[^ self].
	    newItem expand
	].
	"/ done in buttonRelease
"/        self makeLineVisible:newIdx.
    ].
!

keyPress:aKey x:x y:y
    "a key was pressed - handle page-keys here
    "
    <resource: #keyboard( #CursorLeft #CursorRight )>

    |item lineNr isCursorLeft|

    enabled ifFalse:[^ self].

    (    aKey == Character space
     or:[aKey == #CursorRight
     or:[aKey == #CursorLeft]]
    ) ifFalse:[
	super keyPress:aKey x:x y:y.
	^ self
    ].

    lineNr := self cursorLine.

    lineNr ~~ 0 ifTrue:[
	item := cursorItem
    ] ifFalse:[
	lineNr := self selectedIndex.
	lineNr == 0 ifTrue:[^ self].

	item := self at:lineNr ifAbsent:nil.
	item isNil ifTrue:[^ self].
    ].

    aKey == Character space ifTrue:[
	item toggleExpand.
	^ self
    ].
    isCursorLeft := (aKey == #CursorLeft).

    item isExpanded == isCursorLeft ifTrue:[
	(self sensor ctrlDown or:[self sensor shiftDown]) ifTrue:[
	    item recursiveToggleExpand.
	] ifFalse:[
	    item toggleExpand.
	].
	^ self
    ].
    isCursorLeft ifTrue:[
	(item := item parent) isNil ifTrue:[^ self].
	lineNr := self identityIndexOf:item.
    ] ifFalse:[
	item hasChildren ifFalse:[^ self].
	lineNr := lineNr + 1.
    ].

    item := self at:lineNr ifAbsent:nil.
    item isNil ifTrue:[^ self].

    (self canSelectIndex:lineNr forAdd:false) ifTrue:[
	self selection:lineNr
    ].

    "Modified: / 18-09-2007 / 23:02:09 / cg"
! !

!HierarchicalListView methodsFor:'fetch resources'!

fetchResources
    "fetch device colors and ..., to avoid reallocation at redraw time;
     *** called after a create or snapin to fetch all device resources
    "
    |image defaultWidth|

    super fetchResources.

    lineColor      := lineColor onDevice:device.
    openIndicator  := self imageOnMyDevice:openIndicator.
    closeIndicator := self imageOnMyDevice:closeIndicator.
    defaultWidth   := imageWidth.

    icons keysAndValuesDo:[:aKey :anImage|
        anImage isNil ifTrue:[
            ('HierachicalListView [warning]: missing image: ' , aKey) errorPrintCR.
        ] ifFalse:[
            image := self imageOnMyDevice:anImage.
            icons at:aKey put:image.
            imageWidth := image width max:imageWidth.
        ]
    ].
    imageWidth      := ((imageWidth + 1) // 2 * 2) max:defaultWidth.
    alignTextRightX := imageWidth + 20 max:alignTextRightX.
! !

!HierarchicalListView methodsFor:'initialization & release'!

initStyle
    "setup viewStyle specifics
    "
    <resource: #style (#'selection.highlightEnterItem'
		       #'selection.expandOnSelect'
		       #'selection.autoScrollHorizontal'
		       )>

    |cls|

    super initStyle.

    cls   := self class.
    icons := Dictionary new.

    openIndicator      := self class openIndicator.
    closeIndicator     := self class closeIndicator.
    indicatorHeight    := (openIndicator height) max:(closeIndicator height).
    indicatorWidth     := (openIndicator width) max:(closeIndicator width).

    lineColor          := fgColor.
    highlightMode      := #label.
    showRoot           := true.
    showLeftIndicators := true.
    useDefaultIcons    := true.
    showLines          := true.
    imageInset         := 4.
    imageWidth         := 0.
    alignTextRight     := false.
    alignTextRightX    := 8.
    maxWidthOfText     := 0.

    self highlightEnterItem:(styleSheet at:#'selection.highlightEnterItem' default:false).

    expandOnSelect       := styleSheet at:#'selection.expandOnSelect' default:false.
    autoScrollHorizontal := styleSheet at:#'selection.autoScrollHorizontal' default:nil.
!

initialize
    super initialize.
    levelOfLastItem := 1.
    autoScrollHorizontal := true.
    iconAlignment        := #left.

    self showIndicators:true.
! !

!HierarchicalListView methodsFor:'private'!

iconFor:anItem
    "returns an icon or image for the item or nil if the item
     provides no image and useDefaultIcons is switched off,
     or if anItem returns #none from the icon query.
    "
    |iconOrKey image|

    "/ get the icon or access key from the item
    iconOrKey := anItem icon.

    iconOrKey notNil ifTrue:[
        iconOrKey isImageOrForm ifTrue:[
            "/ got an image; have to register the image on my device

            iconOrKey device == device ifTrue:[
                ^ iconOrKey
            ].
            ^ icons at:iconOrKey ifAbsentPut:[ self imageOnMyDevice:iconOrKey ].
        ].
        iconOrKey == #none ifTrue:[^ nil].

        image := icons at:iconOrKey ifAbsent:nil.
        image notNil ifTrue:[ ^ image ].
    ].

    "/ test whether a default image should be returned
    useDefaultIcons ifFalse:[
        ^ nil
    ].

    anItem hasChildren ifFalse:[
        anItem isDirectoryItem ifFalse:[
            ^ icons at:#empty ifAbsentPut:[ self imageOnMyDevice:(self class emptyIcon) ]
        ].
        ^ icons at:#collapsed ifAbsentPut:[ self imageOnMyDevice:(self class collapsedIcon) ].
    ].

    anItem isExpanded ifTrue:[
        ^ icons at:#expanded ifAbsentPut:[ self imageOnMyDevice:(self class expandedIcon) ].
    ].
    ^ icons at:#collapsed ifAbsentPut:[ self imageOnMyDevice:(self class collapsedIcon) ].

    "Modified: / 23-06-2006 / 12:47:33 / fm"
!

lineHeightFor:anItem
    "returns the computed line height for an item
    "
    |image height|

    height := listRenderer heightFor:anItem.
    image := self iconFor:anItem.

    image notNil ifTrue:[
        height := image height max:height.
    ].

    hasConstantHeight ifTrue:[
        icons size ~~ 0 ifTrue:[
            icons do:[:anIcon| height := anIcon height max:height ]
        ] ifFalse:[
            image isNil ifTrue:[ height := height max:16 ]
       ]
    ].
    height := height + lineSpacing.
    ^ height max:indicatorHeight
!

smallestLevelBetween:start and:stop
    "returns the smallest level of all items in a range
    "
    |prevItem currParent nextParent item

     lvl "{ Class:SmallInteger }"
     min "{ Class:SmallInteger }"
     beg "{ Class:SmallInteger }"
    |

    prevItem := self at:start ifAbsent:nil.

    (prevItem isNil or:[(currParent := prevItem parent) isNil]) ifTrue:[
	^ 1
    ].

    (min := prevItem level) == 2 ifTrue:[
	^ min
    ].
    beg := start + 1.

    beg to:stop do:[:i|
	item := self at:i ifAbsent:nil.
	item isNil ifTrue:[^ min].

	(nextParent := item parent) == currParent ifFalse:[
	    (currParent := nextParent) == prevItem ifFalse:[
		(lvl := item level) == 2 ifTrue:[
		    ^ 2
		].
		min := min min:lvl
	    ]
	].
	prevItem := item
    ].
    ^ min
!

widthOfWidestLineBetween:firstLine and:lastLine
    "returns the width of the longest line in pixels in a range
     - used to optimize scrolling, by limiting the scrolled area;
       not for scrollbar or other width related stuff which should be exact."
    
    |parent item textX level width widthOfLabel|

    width := listRenderer widthOfWidestLineBetween:firstLine and:lastLine.
    width notNil ifTrue:[^ width].

    width := 20.

    alignTextRight ifTrue:[
        parent := nil.
        level  := 1.

        firstLine to:lastLine do:[:idx|
            item := self at:idx ifAbsent:nil.

            item notNil ifTrue:[
                width := (listRenderer widthFor:item) max:width.

                item parent ~~ parent ifTrue:[
                    level  := item level max:level.
                    parent := item parent.
                ].
            ].
        ].
        maxWidthOfText := maxWidthOfText max:width.
        textX := self xVisibleOfIconAtLevel:(level + 1).

        alignTextRightX < textX ifTrue:[
            alignTextRightX := textX.
            self invalidate.
        ].
        ^ alignTextRightX + width
    ].

    parent := 4711.  "/ force a computation

    firstLine to:lastLine do:[:idx|
        item := self at:idx ifAbsent:nil.

        item notNil ifTrue:[
            item parent ~~ parent ifTrue:[
                textX  := self xVisibleOfTextAtLevel:(item level).
                parent := item parent.
            ].
            widthOfLabel   := listRenderer widthFor:item.
            maxWidthOfText := maxWidthOfText max:widthOfLabel.
            width          := widthOfLabel + textX max:width
        ].
    ].
    ^ width + viewOrigin x.
!

xVisibleOfIconAtLevel:aLevel
    "returns the visible origin x of the icon at a level.
    "
    |x|

    x := self xVisibleOfVerticalLineAt:aLevel.

    (showRoot and:[aLevel == 1]) ifTrue:[
	showLeftIndicators ifFalse:[
	    ^ x - (imageWidth // 2)
	].
    ].
    ^ x + (indicatorWidth // 2) + imageInset
!

xVisibleOfIndicatorAtLevel:aLevel
    "returns the visible origin x of the vertical line at a level.
    "
    |x|

    x := self xVisibleOfVerticalLineAt:aLevel.
    x := x - (indicatorWidth // 2).
    ^ x
!

xVisibleOfItem:anItem
    "returns the visible origin x of the item's label.
    "
    ^ self xVisibleOfTextAtLevel:(anItem level)
!

xVisibleOfTextAtLevel:aLevel
    "returns the visible origin x of the text label at a level.
    "
    alignTextRight ifTrue:[
	^ alignTextRightX - (viewOrigin x)
    ].
    ^ (self xVisibleOfIconAtLevel:aLevel) + imageWidth + textStartLeft
!

xVisibleOfVerticalLineAt:aLevel
    "returns the visible origin x of the vertical line assigned to a level.
    "
    |xOffset opWidth2 igWidth2 firstLevel|

    opWidth2 := indicatorWidth // 2.
    igWidth2 := imageWidth // 2.
    xOffset  := igWidth2 + opWidth2 + imageInset.

    showRoot ifTrue:[ firstLevel := 1 ]
	    ifFalse:[ firstLevel := 2 ].

    showLeftIndicators ifTrue:[
	aLevel < firstLevel ifTrue:[
	    xOffset := opWidth2 - (firstLevel * xOffset)
	] ifFalse:[
	    xOffset := opWidth2 + ((aLevel - firstLevel) * xOffset)
	]
    ] ifFalse:[
	aLevel < 2 ifTrue:[
	    xOffset := igWidth2 - ((aLevel - firstLevel) * xOffset)
	] ifFalse:[
	    xOffset := igWidth2 + ((aLevel - firstLevel - 1) * xOffset)
	].
    ].
    "/ 2 := a left margin
    ^ xOffset + 2 - (viewOrigin x)
!

yVisibleOfIndicatorForItem:anItem
    |index y0 y1|

    index := list identityIndexOf:anItem.
    index > 0 ifTrue:[
        y0 := self yVisibleOfLine:index.
        y1 := self yVisibleOfLine:(index + 1).

        ^ (y0 + y1) // 2.
    ].
    ^ 0
! !

!HierarchicalListView methodsFor:'scrolling'!

computeViewOriginXat:aLnrNr
    "returns the viewOrigin x to make the item at a line visisble
    "
    |item xLft xRgt level vwOrgX useX|

    vwOrgX := viewOrigin x.

    self autoScrollHorizontal ifFalse:[^ vwOrgX ].

    alignTextRight ifTrue:[ ^ vwOrgX ].
    aLnrNr == 1    ifTrue:[ ^ 0 ].

    item := self at:aLnrNr ifAbsent:nil.
    item isNil ifTrue:[ ^ vwOrgX ].

    level := item level.
    level == 1 ifTrue:[ ^ 0 ].                                  "/ is root item

    level == 2 ifTrue:[                                         "/ parent is root
	(showRoot and:[showLeftIndicators]) ifFalse:[ ^ 0 ].
    ].

    xLft := self xVisibleOfIconAtLevel:(level - 1).
    xLft > 0 ifFalse:[ ^ vwOrgX + xLft max:0 ].

    xRgt := (self xVisibleOfTextAtLevel:level) + (listRenderer widthFor:item).
    useX := xRgt - width.

    useX > 0 ifFalse:[ ^ vwOrgX ].
    useX := useX + 16 min:xLft.
    ^ vwOrgX + useX.
!

makeItemVisible:anItem withMinimumLines:aNumber
    "handle indicator pressed action;
     if the item changed expanded, we try to show all
     new visible children
    "
    |availY usedY vwOrgX vwOrgY lineNr numLines|

    lineNr := list identityIndexOf:anItem.
    lineNr == 0 ifTrue:[ ^ self].

    numLines := anItem numberOfVisibleChildren.
    numLines := numLines max:(aNumber ? 5).
    numLines := lineNr + numLines min:(list size).

    vwOrgY := viewOrigin y.
    availY := (self yVisibleOfLine:lineNr) - (self yVisibleOfLine:1).

    availY > margin ifTrue:[
	usedY := (self yVisibleOfLine:(numLines + 1)) - (height - margin - margin).

	usedY > 1 ifTrue:[
	    vwOrgY := vwOrgY + (usedY min:availY).
	].
    ].
    vwOrgX := self computeViewOriginXat:lineNr.

    self scrollTo:(vwOrgX @ vwOrgY).
!

makeLineVisible:aLineNumber
    "make the line horizontally and vertically visible"

    |newY item y0 oldX newX wLine|

    "/ alignTextRight ifTrue:[^ self].
    aLineNumber < 1 ifTrue:[
        ^ self
    ].

    newX := oldX := viewOrigin x.

    aLineNumber == 1 ifTrue:[
        newX := self computeViewOriginXat:1.
        newY := 0.
    ] ifFalse:[
        item := self at:aLineNumber ifAbsent:nil.
        item isNil ifTrue:[^ self].

        y0 := self yVisibleOfLine:aLineNumber.

        (     y0 < margin
         or:[(y0 + (listRenderer heightFor:item)) > (height - margin)]
        ) ifTrue:[
            newY := ((self yAbsoluteOfLine:aLineNumber) - (height // 2)) max:0.
        ] ifFalse:[
            newY := viewOrigin y.
        ].

        self autoScrollHorizontal ifTrue:[
            wLine := self widthOfWidestLineBetween:aLineNumber and:aLineNumber.
            (wLine < self innerWidth) ifTrue:[
                (oldX == 0) ifTrue:[
                    newX := self computeViewOriginXat:aLineNumber.
                ] ifFalse:[
                    newX := 0
                ].
            ] ifFalse:[
                newX := self computeViewOriginXat:aLineNumber.
            ].
        ].
    ].
    self scrollTo:(newX @ newY).
! !

!HierarchicalListView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

