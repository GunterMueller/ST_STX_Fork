"
 COPYRIGHT (c) 1999 by eXept Software AG
 COPYRIGHT (c) 2018 Jan Vrany
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

View subclass:#ListModelView
	instanceVariableNames:'list listHolder textStartLeft textStartTop viewOrigin enabled
		fgColor bgColor lineSpacing widthOfContents computeWidthInRange
		startOfLinesY autoScroll autoScrollBlock scrollWhenUpdating
		hasConstantHeight constantHeight previousExtent listRenderer
		cachedPreferredExtent activeScrollProcess'
	classVariableNames:'DefaultForegroundColor DefaultBackgroundColor DefaultShadowColor
		DefaultLightColor StopRedrawSignal'
	poolDictionaries:''
	category:'Views-Lists'
!

Object subclass:#Renderer
	instanceVariableNames:'view'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ListModelView
!

ListModelView::Renderer subclass:#TableRenderer
	instanceVariableNames:'xSplitbars hasFixedItemWidth savedCursor dragCursor
		columnDescriptors separatorOneDColor receiver dragOperation
		requiredColumnHeight minimumRequiredColumnHeight attributes'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ListModelView
!

Object subclass:#ColumnDescriptor
	instanceVariableNames:'dataSetColumnSpec columnNumber width'
	classVariableNames:'ClipColumnQuerySignal'
	poolDictionaries:''
	privateIn:ListModelView::TableRenderer
!

!ListModelView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
 COPYRIGHT (c) 2018 Jan Vrany
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
    This widget is a new improved revision of the good-old ListView.
    In contrast to ListView, this one reacts on changes of the
    underlying list and performs optimized redraws.
    It requires a List (or alike) as list.

    This class can only passively display collections of elements.
    The class doesn't keep its own list, it works directly on
    the list ( List or HierarchicalList ).

    ATTENTION (warning by cg):
	in contrast to its inappropriate name, this class COMPLETELY ignores the model
	instance variable - all is through the list/listHolder.

    Each list item is obligated to provide 3 services:
	- heightOn:aGC
	- widthOn:aGC
	- displayOn:aGC x:x y:y

    [Instance variables:]
	list                   <List-Model>     List or HierarchicalList ...
	listHolder             <Model>          Model, which keeps a List
	textStartLeft          <Number>         left inset of text
	viewOrigin             <Point>          the current origin
	enabled                <Boolean>        widget is enabled/disabeled
	fgColor                <Color>          color to draw characters
	bgColor                <Color>          the background
	lineSpacing            <Number>         pixels between lines
	widthOfContents        <Number>         cached width of widest line
	computeWidthInRange    <Point>          used for recompute width of contents
	startOfLinesY          <Collection>     keeps all the absolute Y-start positions
						for each line in the list. The first
						entry into the list is the top Y inset.
	supportsDisplayInRange <Boolean>        set to true if the list elements
						supports the service:
						    #displayOn:x:y:h:

	hasConstantHeight      <Boolean>        true, than each line has the same height

	constantHeight         <SmallInteger>   hasConstantHeight is turned on, this
						is the used line height

    [author:]
	Claus Atzkern

    [see also:]

	SelectionInListModelView
	HierarchicalListView
	List
	HierarchicalList
"
!

examples
"
									[exBegin]
    |top list view up index|

    list := List new.

    top  := StandardSystemView new; extent:300@300.
    view := ScrollableView for:ListModelView miniScroller:true
			origin:0.0@0.0 corner:1.0@1.0 in:top.

    view list:list.
    top  openAndWait.
    up := true.

    [top shown] whileTrue:[
	Delay waitForSeconds:0.2.

	up ifTrue:[
	    index := 1 + (list size).
	    list add:('element: ', index printString).
	    up := index < 20
	] ifFalse:[
	    list removeIndex:1.
	    up := list isEmpty.
	]
    ].
									[exEnd]

"

! !

!ListModelView class methodsFor:'initialization'!

initialize
    "setup the signals
    "
    StopRedrawSignal isNil ifTrue:[
        StopRedrawSignal := Notification newSignalMayProceed:true.
        StopRedrawSignal nameClass:self message:#stopRedrawSignal.
    ].
! !

!ListModelView class methodsFor:'Signal constants'!

stopRedrawSignal
    ^ StopRedrawSignal
! !

!ListModelView class methodsFor:'defaults'!

defaultRenderer
    ^ Renderer
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style   (
                        #'text.backgroundColor'  #'text.foregroundColor'
                        #'selection.shadowColor' #'selection.lightColor'
                        #'text.font'
                        )>

    DefaultForegroundColor         := StyleSheet colorAt:'text.foregroundColor' default:Color black.
    DefaultBackgroundColor         := StyleSheet colorAt:'text.backgroundColor'.
    DefaultShadowColor             := StyleSheet colorAt:'selection.shadowColor'.
    DefaultLightColor              := StyleSheet colorAt:'selection.lightColor'.
    "/ DefaultFont                    := StyleSheet  fontAt:'text.font'.

    "
     self updateStyleCache
    "

    "Modified: / 14-08-2010 / 12:23:35 / cg"
! !

!ListModelView methodsFor:'accessing'!

list
    "get the list of items
    "
    ^ list


!

list:aList
    "set the list of items
    "
    |negatedOrg|

    listRenderer listWillChange.

    list ~~ aList ifTrue:[
        list removeDependent:self.
        list := aList.
        list isNil ifTrue:[list := self newDefaultList ].
        list addDependent:self
    ].
"/    preferredExtent := nil.
    cachedPreferredExtent := nil.
    widthOfContents := nil.

    self recomputeHeightOfContents.

    scrollWhenUpdating == #beginOfText ifTrue:[
        viewOrigin = (0@0) ifFalse:[
            self originWillChange.
            negatedOrg := viewOrigin negated.
            viewOrigin := (0@0).
            self originChanged:negatedOrg.
        ].
    ] ifFalse:[
        scrollWhenUpdating == #endOfText ifTrue:[
            self scrollTo:(0 @ self heightOfContents - self innerHeight) redraw:false
        ]
    ].
    self invalidate.
    self contentsChanged
!

listRenderer
    "returns the used listrenderer
    "
    ^ listRenderer
!

listRenderer:aRendererOrRendererClass
    "change the used listRenderer
    "
    aRendererOrRendererClass isNil ifTrue:[^ self].

    listRenderer == aRendererOrRendererClass ifTrue:[^ self].
    listRenderer notNil ifTrue:[listRenderer release].

    aRendererOrRendererClass isBehavior ifTrue:[
	listRenderer := aRendererOrRendererClass basicNew initialize.
    ] ifFalse:[
	listRenderer := aRendererOrRendererClass.
    ].
    listRenderer forView:self.
!

renderer
    <resource: #obsolete>
    self obsoleteMethodWarning:'naming conflict renderer vs. listRenderer'.
    ^ self listRenderer
!

renderer:aTableRenderer
    <resource: #obsolete>
    self obsoleteMethodWarning:'naming conflict renderer vs. listRenderer'.
    self listRenderer:aTableRenderer
!

setupTableRenderer
    "creates a renderer with columns based on a DataSetColumnSpec
     answer the new renderer"

    self listRenderer:TableRenderer.
    ^ listRenderer
! !

!ListModelView methodsFor:'accessing-behavior'!

autoScroll
    "returns true if auto scrolling is enabled
    "
    ^ autoScroll
!

autoScroll:aBool
    "returns true if auto scrolling is enabled
    "
    autoScroll := aBool ? true.
!

enabled
   "returns the enabled state
   "
   ^ enabled


!

enabled:aBoolean
   "set the enabled state
   "
   enabled := aBoolean


!

hasConstantHeight
    "user configured; true if each line has the same lineHeight.
     Optimizes scroll and redraw operations
    "

    ^ hasConstantHeight
!

hasConstantHeight:aBool
    "user configured; true if each line has the same lineHeight.
     Optimizes scrolling and redraw.
    "

    aBool == hasConstantHeight ifTrue:[
	^ self
    ].
    constantHeight    := nil.
    hasConstantHeight := aBool.

    self lostSynchronisation.
!

scrollWhenUpdating:aSymbolOrNil
    "define how to scroll, when I get a new text
     (via the model or the #contents/#list)
     Allowed arguments are:
	#keep / nil     -> no change
	#endOfText      -> scroll to the end
	#beginOfText    -> scroll to the top
     The default is #beginOfText.
     This may be useful for fields which get new values assigned from
     the program (i.e. not from the user)
    "

    scrollWhenUpdating := aSymbolOrNil


! !

!ListModelView methodsFor:'accessing-items'!

at:anIndex
    "return the list element at an index
    "
    ^ list at:anIndex
!

at:anIndex ifAbsent:exceptionBlock
    "return the list element at an index if valid.
     If the index is invalid, return the result of evaluating
     the exceptionblock.
    "
    ^ list at:anIndex ifAbsent:exceptionBlock
!

findLast:aOneArgBlock
    "find the last list entry, for which evaluation of the argument, aOneArgBlock
     returns true; return its index or 0 if none detected.
    "
    ^ list findLast:aOneArgBlock
!

identityIndexOf:anElement
    "returns the index of an element or nil
    "
    ^ list identityIndexOf:anElement
!

last
    "returns the last list entry
    "
    ^ list last
! !

!ListModelView methodsFor:'accessing-look'!

backgroundColor
    "get the background color
    "
    ^ bgColor


!

font:aFont
    "set a new font
    "
    |oldWidth oldHeight newFont|

    (aFont isNil or:[aFont = gc font]) ifFalse:[
        oldWidth  := gc font width.
        oldHeight := gc font height.

        super font:aFont.
        newFont := gc deviceFont.

        newFont width ~~ oldWidth ifTrue:[       "/ force a recomputation
"/            preferredExtent := nil.
            cachedPreferredExtent := nil.
            widthOfContents := nil.
        ].
        realized ifTrue:[
            oldHeight ~~ newFont height ifTrue:[
                self recomputeHeightOfContents.
                self contentsChanged.
            ].
            self invalidate
        ].
    ].
!

foregroundColor
    "get the foreground color
    "
    ^ fgColor

!

foregroundColor:aColor
    "set the foreground color
    "
    (aColor notNil and:[fgColor ~~ aColor]) ifTrue:[
        self realized ifTrue:[
            fgColor := aColor onDevice:device.
            self invalidate
        ] ifFalse:[
            fgColor := aColor
        ]
    ]
!

lineSpacing
    "get the lineSpacing - that's an additional number of pixels,
     by which lines are vertically separated.
    "
    ^ lineSpacing
!

lineSpacing:aNumber
    "set the lineSpacing - that's an additional number of pixels,
     by which lines are vertically separated.
    "
    lineSpacing ~= aNumber ifTrue:[
        lineSpacing := aNumber.

        realized ifTrue:[
            self recomputeHeightOfContents.
            self invalidate
        ].
        self contentsChanged.
    ]
!

viewBackground:aColor
    "set the background color
    "
    (aColor notNil and:[bgColor ~~ aColor]) ifTrue:[
        bgColor := aColor.
        super viewBackground:bgColor.

        self realized ifTrue:[
            bgColor := bgColor onDevice:device.
            self invalidate
        ].
    ].
! !

!ListModelView methodsFor:'accessing-mvc'!

listHolder
    "returns the listHolder or nil
    "
    ^ listHolder
!

listHolder:aListHolder
    "set a new listHolder
    "
    listHolder removeDependent:self.

    (listHolder := aListHolder) notNil ifTrue:[
	listHolder addDependent:self.
    ].
    self list:(listHolder value).
! !

!ListModelView methodsFor:'change & update'!

lineChangedAt:aLnNr with:arg
    "line changed at position; check whether line height changed"

    |cache
     oldHeight "{ Class:SmallInteger }"
     deltaHeight "{ Class:SmallInteger }" |

    (arg == #icon or:[arg == #hierarchy]) ifTrue:[
	^ self
    ].
    hasConstantHeight ifTrue:[
	self invalidateLineAt:aLnNr.
	^ self
    ].

    oldHeight := (self yVisibleOfLine:(aLnNr + 1)) - (self yVisibleOfLine:aLnNr).
    deltaHeight := (self heightOfLineAt:aLnNr) - oldHeight.

    deltaHeight == 0 ifTrue:[
	self invalidateLineAt:aLnNr.
	^ self
    ].
    cache := self startOfLinesY.

    aLnNr + 1 to:cache size do:[:i|
	cache at:i put:((cache at:i) + deltaHeight)
    ].
    self contentsChanged.
    self invalidate.
!

listChangedInsert:start nItems:nLines
    "list changed; items are added"

    |newLines
     run    "{ Class: SmallInteger }"
     newSz  "{ Class: SmallInteger }"
     cpyHg  "{ Class: SmallInteger }"
     absY0  "{ Class: SmallInteger }"
     absY1  "{ Class: SmallInteger }"
     visY0  "{ Class: SmallInteger }"
     visY1  "{ Class: SmallInteger }"
     orgY   "{ Class: SmallInteger }"
     dltY   "{ Class: SmallInteger }"
     maxHg  "{ Class: SmallInteger }"
   |

    nLines == 0 ifTrue:[^ self ].
    self listSizeChanged:start nLines:nLines.

    newSz := startOfLinesY size + nLines.

    (newSz - 1) ~~ self size ifTrue:[
        "/
        "/ no longer synchronized
        "/
        self lostSynchronisation.
        ^ self
    ].
    newLines := startOfLinesY. "/ copy.
    newLines addAll:(Array new:nLines) beforeIndex:start + 1.
    absY0 := newLines at:start.
    absY1 := absY0.
    run   := start.

    nLines timesRepeat:[
        absY1 := absY1 + (self heightOfLineAt:run).
        run   := run + 1.
        newLines at:run put:absY1.
    ].
    dltY := absY1 - absY0.

    run + 1 to:newSz do:[:i||v|
        newLines at:i put:((newLines at:i) + dltY)
    ].
    startOfLinesY := newLines.

    orgY  := viewOrigin y.
    absY1 := absY0 + dltY.
    visY0 := absY0 - orgY.
    visY1 := absY1 - orgY.
    maxHg := height - margin.

    absY0 < orgY ifTrue:[
        self originWillChange.
        viewOrigin y:(dltY + orgY).
        self originChanged:(0 @ dltY).
    ].

    (visY0 >= maxHg or:[visY1 <= margin]) ifTrue:[
        self contentsChanged.
        ^ self
    ].
    visY0 := visY0 max:margin.
    visY1 := visY1 min:maxHg.

    self hasDamage ifTrue:[
        self invalidate:(Rectangle left:0
                                    top:visY0
                                  width:width
                                 height:height - visY0).

        self contentsChanged.
        ^ self
    ].

    (start == self size or:[(cpyHg := maxHg - visY1) < 20]) ifTrue:[
        visY1 := maxHg
    ] ifFalse:[
        shown ifTrue:[
            self catchExpose.
            self copyFrom:self x:0 y:visY0
                             toX:0 y:visY1
                           width:width height:cpyHg async:true.
            self waitForExpose.
        ].
    ].

    self invalidateX:margin
                   y:visY0
               width:width - margin - margin
              height:(visY1 - visY0).

    self contentsChanged.
!

listChangedRemove:aStart toIndex:aStop
    "list changed; items are removed"

    |doRedraw newLines
     size  "{ Class: SmallInteger }"
     absY0 "{ Class: SmallInteger }"
     absY1 "{ Class: SmallInteger }"
     visY0 "{ Class: SmallInteger }"
     visY1 "{ Class: SmallInteger }"
     orgY  "{ Class: SmallInteger }"
     orgX  "{ Class: SmallInteger }"
     dltY  "{ Class: SmallInteger }"
     cpyHg "{ Class: SmallInteger }"
     maxHg "{ Class: SmallInteger }"
     stop  "{ Class: SmallInteger }"
     start "{ Class: SmallInteger }"
     newSz "{ Class: SmallInteger }"
    |
    stop  := aStop.
    start := aStart.

    (size := stop - start + 1) == 0 ifTrue:[
        ^ self
    ].

    self listSizeChanged:start nLines:(size negated).

    newSz := startOfLinesY size - size.

    (newSz - 1) ~~ self size ifTrue:[
        "/
        "/ no longer synchrounous
        "/
        ^ self lostSynchronisation
    ].

    absY0 := self yAbsoluteOfLine:start.
    absY1 := self yAbsoluteOfLine:stop + 1.
    dltY  := absY1 - absY0.

    newLines := startOfLinesY. "/ copy.
    newLines removeFromIndex:(start + 1) toIndex:(stop + 1).

    (start + 1) to:newSz do:[:i|
        absY0 := newLines at:i.
        newLines at:i put:(absY0 - dltY).
    ].
    startOfLinesY := newLines.

    orgY  := viewOrigin y.
    orgX  := viewOrigin x.

    absY0 := self yAbsoluteOfLine:start.
    absY1 := absY0 + dltY.
    visY0 := absY0 - orgY.
    visY1 := absY1 - orgY.
    maxHg := height - margin.

    (self size == 0 or:[(orgY ~~ 0 and:[self maxViewOriginY == 0])]) ifTrue:[
        (orgX ~~ 0 or:[orgY ~~ 0]) ifTrue:[
            self originWillChange.
            viewOrigin := 0@0.
            self originChanged:((orgX @ orgY) negated).
        ].
        self invalidate.
        ^ self contentsChanged
    ].

    visY0 < margin ifTrue:[
        doRedraw := visY1 > margin.
        doRedraw ifTrue:[dltY := visY0] ifFalse:[dltY := dltY negated].

        self originWillChange.
        viewOrigin := viewOrigin x @ (dltY + orgY).
        self originChanged:(0 @ dltY).
    ] ifFalse:[
        doRedraw := visY0 < maxHg
    ].
    visY0 := visY0 max:margin.

    self hasDamage ifTrue:[
        self invalidate:(Rectangle left:0
                                    top:visY0
                                  width:width
                                 height:height - visY0).

        doRedraw := false.
    ].

    (shown and:[doRedraw]) ifTrue:[
        cpyHg := maxHg - visY1.

        cpyHg > 20 ifTrue:[
            self catchExpose.
            self copyFrom:self x:0 y:visY1 toX:0 y:visY0
                    width:width height:cpyHg async:true.
            self waitForExpose.
            visY0 := visY0 + cpyHg.
        ].

        self invalidateX:margin
                       y:visY0
                   width:width - margin - margin
                  height:(maxHg - visY0).
    ].
    self contentsChanged.
!

update:what with:aPara from:chgObj
    "catch and handle any notification raised from the list model
     or list holder"

    chgObj == self listHolder ifTrue:[
	self list:chgObj value.
	^ self.
    ].

    chgObj == self list ifTrue:[
	listRenderer withinUpdateFromListDo:[
	    self updateFromList:what with:aPara.
	].
	^ self.
    ].

    super update:what with:aPara from:chgObj
!

updateFromList:what with:aParameter
    "called if the list changed"

    |arg1 arg2|

    aParameter isCollection ifFalse:[
	what == #at:     ifTrue:[self lineChangedAt:aParameter        with:nil.   ^ self].
	what == #insert: ifTrue:[self listChangedInsert:aParameter  nItems:1.     ^ self].
	what == #remove: ifTrue:[self listChangedRemove:aParameter toIndex:aParameter. ^ self].

	self list:(self list).  "/ reload list
	^ self.
    ].

    arg1 := aParameter at:1.
    arg2 := aParameter at:2.

    (arg1 == 1 and:[arg2 == self size]) ifTrue:[
	self list:(self list).  "/ reload list
	^ self
    ].

    what == #at:               ifTrue:[self lineChangedAt:arg1        with:arg2. ^ self].
    what == #insertCollection: ifTrue:[self listChangedInsert:arg1  nItems:arg2. ^ self].
    what == #removeFrom:       ifTrue:[self listChangedRemove:arg1 toIndex:arg2. ^ self].

    what == #replace: ifTrue:[
	arg1 to:arg2 do:[:i|self lineChangedAt:i with:nil].
	^ self
    ].
    self halt:'oops - general change'.
    self list:(self list).  "/ reload list
! !

!ListModelView methodsFor:'drawing'!

drawElementsFrom:start to:stop x:x y:y w:w
    "draw lines from start to stop.
     clipping and clearing the background is already done
    "
    |item
     y0 "{ Class:SmallInteger }"
     y1 "{ Class:SmallInteger }"
     x0 "{ Class:SmallInteger }"
    |
    self paint:fgColor on:bgColor.

    x0 := textStartLeft - viewOrigin x.
    y1 := y.

    start to:stop do:[:i|
	item := self at:i ifAbsent:self.        "/ list changed during draw
	item == self ifTrue:[^ self].

	y0 := y1.
	y1 := self yVisibleOfLine:(i + 1).

	item notNil ifTrue:[
	    listRenderer display:item atX:x0 y:y0 lineHeight:(y1 - y0).
	]
    ]
!

drawFrom:start to:stop x:xLft y:yTop w:aWidth 
    "draw lines from start to stop. Test whether a new clip
     must be setup."
    
    |maxX w|

    maxX := listRenderer maxItemWidthOrNil.
    w := aWidth.
    maxX notNil ifTrue:[
        |clip|

        maxX := maxX - viewOrigin x.
        maxX > xLft ifFalse:[
            ^ self.
        ].
        w := maxX - xLft min:aWidth.
        clip := self clippingBoundsOrNil.
        clip notNil ifTrue:[
            clip := clip copy.
            clip width:w
        ] ifFalse:[
            clip := Rectangle 
                        left:xLft
                        top:yTop
                        width:w
                        height:(height - yTop - margin).
        ].
        self clippingBounds:clip.
    ].
    self 
        drawElementsFrom:start
        to:stop
        x:xLft
        y:yTop
        w:w.
!

drawSelectionFrameFrom:start to:stop x:x y:y w:w
    "What to do here?"

    "Created: / 24-04-2013 / 14:07:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidateLineAt:aLineNr
    "add a damage to redraw a line specified by its line number to the
     input event queue.
    "
    ^ self invalidateLineAt:aLineNr fromX:0.
!

invalidateLineAt:aLineNr fromX:x
    "add a damage to redraw a line specified by its line number to the
     input event queue.
    "
    |y0 "{ Class:SmallInteger }"
     y1 "{ Class:SmallInteger }"
     yB "{ Class:SmallInteger }"
     x0 "{ Class:SmallInteger }"
     xR "{ Class:SmallInteger }"
    |

    (shown and:[aLineNr notNil and:[aLineNr > 0]]) ifFalse:[
	^ self
    ].

    xR := width - margin.
    x0 := x max:margin.
    x0 < xR ifFalse:[ ^ self].

    yB := height - margin.
    y0 := (self yVisibleOfLine:aLineNr) max:margin.

    y0 < yB ifTrue:[
	y1 := (self yVisibleOfLine:(aLineNr + 1)) min:yB.

	y1 > y0 ifTrue:[
	    self invalidateX:x0 y:y0 width:(xR - x0) height:(y1 - y0) repairNow:false.
	]
    ].
!

redraw
    "redraw complete view
    "
    self redrawX:0 y:0 width:width height:height.


!

redrawX:x y:y width:w height:h
    "redraw part of myself immediately, given logical coordinates
    "
    |start stop yAbs yStart|

    shown ifFalse:[^ self].

    (self startOfLinesY size) == (self size + 1) ifFalse:[
        "oops, recompute the height of the contents (the first time after creation).
        "
        self recomputeHeightOfContents.

        self startOfLinesY size > 1 ifTrue:[
            "oops, the contents height changed
            "
            self invalidate.
            self contentsChanged.
            ^ self
        ].
    ].
"/    widthOfContents isNil ifTrue:[
"/        self preferredExtent
"/    ].
    yStart := y.
    start  := self yVisibleToLineNr:y.

    start notNil ifTrue:[
        yAbs := y + h.
        stop := self yVisibleToLineNr:yAbs.

        stop isNil ifTrue:[
            stop := list size.
        ] ifFalse:[ |y0|
            stop := stop min:list size.
            y0 := self startOfLinesY at:stop ifAbsent:nil.
            y0 isNil ifTrue:[^ self].   "/ oops, lines differ (will be changed)

            yAbs == y0 ifTrue:[
                stop := (stop - 1) max:start
            ].
        ].

        start > stop ifTrue:[
            start := stop := nil.
        ] ifFalse:[
            (listRenderer validateDrawableItemsFrom:start to:stop) ifFalse:[
                self invalidate.
                ^ self.
            ].
            yStart := self yVisibleOfLine:start.
        ].
    ].
    gc paint:bgColor.
    gc fillRectangleX:x y:y width:w height:h.

    StopRedrawSignal handle:[:ex|
        "/ an item changed its dimension during drawing, draw is aborted
        self invalidate
    ] do:[
        start notNil ifTrue:[
            listRenderer showItemInAdditionToColumns ifTrue:[
                self drawFrom:start to:stop x:x y:yStart w:w.
            ] ifFalse:[
                self drawSelectionFrameFrom:start to:stop x:x y:yStart w:w.
            ].
        ].
        listRenderer postRedrawX:x y:yStart w:w from:start to:stop.
    ].

    "Modified: / 24-11-2010 / 19:03:56 / cg"
    "Modified: / 24-04-2013 / 14:07:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListModelView methodsFor:'enumerating'!

visibleLinesAndItemsDo:aTwoArgBlock
    "enumerate over each visible item"

    |lineNr item|

    shown ifFalse:[^ self].

    lineNr := self yVisibleToLineNr:1.
    lineNr isNil ifTrue:[ ^ self ].

    [   item := list at:lineNr ifAbsent:[ ^ self ].
	aTwoArgBlock value:lineNr value:item.
	lineNr := lineNr + 1.
	(self yVisibleOfLine:lineNr) < height
    ] whileTrue.
! !

!ListModelView methodsFor:'event handling'!

keyPress:aKey x:x y:y
    "a key was pressed - handle page-keys here"

    <resource: #keyboard( #PreviousPage #NextPage  #HalfPageUp #HalfPageDown
			  #BeginOfText  #EndOfText #ScrollUp   #ScrollDown
			)>

    |n|

    self size ~~ 0 ifTrue:[
	(aKey == #PreviousPage) ifTrue:[^ self pageUp].
	(aKey == #NextPage)     ifTrue:[^ self pageDown].
	(aKey == #HalfPageUp)   ifTrue:[^ self halfPageUp].
	(aKey == #HalfPageDown) ifTrue:[^ self halfPageDown].
	(aKey == #BeginOfText)  ifTrue:[^ self scrollToTop].
	(aKey == #EndOfText)    ifTrue:[^ self scrollToBottom].

	(aKey == #ScrollUp or:[aKey == #ScrollDown]) ifTrue:[
	    n := 1 + (self sensor compressKeyPressEventsWithKey:aKey).
	    n := n * self verticalScrollStep.

	    aKey == #ScrollUp ifTrue:[self scrollUp:n]
			     ifFalse:[self scrollDown:n].
	    ^ self
	].
    ].
    super keyPress:aKey x:x y:y
!

keyboardZoom:larger
    "CTRL+/- zoom action"

    self fontLargerOrSmaller:larger
!

sizeChanged:how
    previousExtent := self extent.
    listRenderer sizeChanged:how.
    super sizeChanged:how.

    "Modified: / 17-04-2013 / 11:41:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListModelView methodsFor:'event simulation'!

syncronizeEvents
    <resource:#obsolete>
    self obsoleteMethodWarning:'no longer supported'.
    ^ false
!

syncronizeEvents:aBoolean
    <resource:#obsolete>
    self obsoleteMethodWarning:'no longer supported'.
! !

!ListModelView methodsFor:'fetch resources'!

colorOnDevice:aColor
    "fetch a device colors
    "
    ^ aColor notNil ifTrue:[aColor onDevice:device] ifFalse:[nil]
!

imageOnMyDevice:anImage
    "associate image to device and returns the new image."

    anImage isNil ifTrue:[^ nil].
    ^ anImage onDevice:device.
! !

!ListModelView methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "catch the keyboard focus on button click
    "
    ^  true


!

wantsFocusWithPointerEnter
    "views which like to take the keyboard focus
     when the pointer enters can do so by redefining this
     to return true"

    ^ true

! !

!ListModelView methodsFor:'initialization & release'!

create
    "fetch device dependent resources
    "
    super create.
    self fetchResources.
!

initStyle
    "setup viewStyle specifics
    "
    super initStyle.

    DefaultBackgroundColor notNil ifTrue:[
        viewBackground := DefaultBackgroundColor
    ].
    lineSpacing   := 2.
    textStartLeft := 2.
    textStartTop  := 2.
    fgColor       := DefaultForegroundColor.
    bgColor       := viewBackground.
    startOfLinesY := OrderedCollection new.

    self font:SelectionInListView defaultFont. 

    startOfLinesY add:(textStartTop + margin). "/ top inset of first line

    DefaultShadowColor notNil ifTrue:[
        shadowColor := DefaultShadowColor
    ].

    DefaultLightColor notNil ifTrue:[
        lightColor := DefaultLightColor
    ].

    "Modified: / 14-08-2010 / 12:24:02 / cg"
!

initialize
    "setup default attributes
    "
    super initialize.

    viewOrigin         := 0@0.
    bitGravity         := #NorthWest.
    enabled            := true.
    autoScroll         := true.
    scrollWhenUpdating := #beginOfText.
    hasConstantHeight  := false.

    listRenderer isNil ifTrue:[
        listRenderer := self class defaultRenderer forView:self.
    ].
    self list:(self newDefaultList).
!

mapped
    "recompute list
    "
    "/ shown ifFalse:[
"/        self recomputeHeightOfContents.
"/        self contentsChanged.     "/ is computeEditorLayout what you want ?
    "/ ].
    listRenderer mapped.
    super mapped

!

recreate
    "sent after a snapin or a migration, reinit for new device"

    super recreate.
    self fetchResources.
!

reinitialize
    "reinit after snapIn (font geometry might be different)
    "
    super reinitialize.
    self recomputeHeightOfContents.
    self contentsChanged.

!

release
    "remove dependencies
    "
    listRenderer release.

    self listHolder removeDependent:self.
    self list       removeDependent:self.

    super release
! !

!ListModelView methodsFor:'private'!

hasDamage
    "return true, if any damage events (i.e. expose or resize) are pending"

    ^ self sensor hasDamageFor:self
!

startOfLinesY
    "returns a collection of absolute Y-positions per line.
     The first entry is the top Y inset.
     The size of the list is one more than the lists size,
     providing the Y-position of the line below the contents as its last entry."

    ^ startOfLinesY
!

xAbsoluteOfItem:anItem
    "returns the absolute x of the labeled text
    "
    ^ (self xVisibleOfItem:anItem) + viewOrigin x.
!

xVisibleOfItem:anItem
    "returns the visible x of the labeled text
    "
    ^ textStartLeft - viewOrigin x
!

yAbsoluteOfLine:aLineNr
    "given a lineNr, return y-coordinate absolute
    "
    |y y2 y1 cache|

    cache := self startOfLinesY.

    (y := cache at:aLineNr ifAbsent:nil) notNil ifTrue:[
        ^ y
    ].

    "/ recompute a y position
    y1 := cache at:1 ifAbsent:textStartTop.
    y2 := cache at:2 ifAbsent:(textStartTop + 16).
    ^ aLineNr * (y2 - y1) + y1
!

yAbsoluteToLineNr:yAbsolute
    "returns the line number for a given physical y coordinate
     or nil if beyond of list.
    "

    |cache yCache
     yAbs       "{ Class: SmallInteger}"
     size       "{ Class: SmallInteger}"
     ictr       "{ Class: SmallInteger}"
     yRun       "{ Class: SmallInteger}"
    |

    yAbs := yAbsolute.
    cache := self startOfLinesY.

    (size := cache size) < 2 ifTrue:[
        "/ empty list
        (yAbs between:textStartTop and:textStartTop+16) ifTrue:[^ 1].
        ^ nil
    ].

    yCache := cache at:size ifAbsent:nil.
    yCache isNil ifTrue:[ ^ nil ].    "/ out of list

    yRun := yCache.

    yAbs >= yRun ifTrue:[
        yAbs == yRun ifTrue:[ ^ size - 1].
        ^ nil   "/ out of list
    ].

    constantHeight notNil ifTrue:[
        yAbs := yAbs - (cache at:1).
        yAbs < constantHeight ifTrue:[ ^ 1 ].
        ^ yAbs // constantHeight + 1
    ].

    ictr := yAbs // (cache at:2).
    ictr < 1 ifTrue:[ ictr := 1 ]
            ifFalse:[ ictr := ictr min:size ].

    yRun := cache at:ictr.

    yRun > yAbs ifTrue:[
        [(ictr := ictr - 1) > 0 ] whileTrue:[
            yRun := cache at:ictr.
            yRun <= yAbs ifTrue:[ ^ ictr ].
        ].
        ^ 1
    ].

    [ yRun ~~ yAbs ] whileTrue:[
        ictr := ictr + 1.
        yRun := cache at:ictr.
        yRun > yAbs ifTrue:[ ^ ictr - 1 ].
    ].
    ^ ictr

    "Created: / 18-04-2013 / 10:03:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

yAbsoluteToRowNr:yVisible
    "for protocol compatibility with DSVColumnView"

    ^ self yAbsoluteToLineNr:yVisible

    "Created: / 18-04-2013 / 10:05:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

yVisibleOfLine:aLineNr
    "given a lineNr, return y-coordinate in view
    "
    ^ (self yAbsoluteOfLine:aLineNr) - viewOrigin y


!

yVisibleToLineNr:yVisible
    "returns the line number for a given physical y coordinate
     or nil if beyond of list.
    "
    ^self yAbsoluteToLineNr: yVisible + viewOrigin y.

    "Modified: / 18-04-2013 / 10:04:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

yVisibleToRowNr:yVisible
    "for protocol compatibility with DSVColumnView"

    ^ self yVisibleToLineNr:yVisible
! !

!ListModelView methodsFor:'protocol'!

fetchResources
    "fetch device colors and ..., to avoid reallocation at redraw time;
     *** called after a create or snapin to fetch all device resources
    "
    fgColor    := self colorOnDevice:fgColor.
    bgColor    := self colorOnDevice:bgColor.
!

heightForLines:numberOfLines
    |h|

    h := self lineHeightFor:'Yg'.
    ^ h * numberOfLines
!

lineHeightFor:anItem
    "returns the computed line height for an item
    "
    ^ lineSpacing + (listRenderer heightFor:anItem)
!

listSizeChanged:anIndex nLines:noLines
    "list size changed; information is stored to recompute the
     width if required( preferredExtent, horizontal scroller ... ).
     see: widthOfContents
     *** if nLines is negative, lines are removed otherwise added.
    "
    |start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"
     size  "{ Class:SmallInteger }"
    |
"/    preferredExtent := nil.

    cachedPreferredExtent := nil.
    widthOfContents isNil ifTrue:[      "/ recompute whole list
	^ self
    ].

    (noLines < 0 or:[(size := self size) <= noLines]) ifTrue:[
	widthOfContents := nil.         "/ force recompute whole list
	^ self
    ].

    stop  := anIndex + noLines - 1.     "/ recompute a range
    start := anIndex.

    computeWidthInRange notNil ifTrue:[
	start := computeWidthInRange y.
	stop  <  start ifTrue:[stop := start min:size].
	start := (computeWidthInRange x) min:anIndex.
    ].
    computeWidthInRange := start@stop
!

lostSynchronisation
    "called when the changes derived from the model are faster than the handling
    "

    self recomputeHeightOfContents.
    self invalidate.
    self contentsChanged
!

newDefaultList
    "creates and returns a new default list class, on default a List
    "
    ^ List new
!

widthOfWidestLineBetween:firstLine and:lastLine
    "return the width in pixels of the widest line in a range
     - used to optimize scrolling, by limiting the scrolled area;
       not for scrollbar or other width related stuff which should be exact."

    |item width|

    width := listRenderer widthOfWidestLineBetween:firstLine and:lastLine.
    width notNil ifTrue:[^ width].

    width := textStartLeft.

    firstLine to:lastLine do:[:anIndex|
        item := self at:anIndex ifAbsent:nil.

        item isNil ifTrue:[^ width + textStartLeft].

        width := (listRenderer widthFor:item) max:width
    ].
    ^ width + textStartLeft
! !

!ListModelView methodsFor:'queries'!

isLineVisible:aLineNr
    "returns true if the line is visible"

    ^ self isLineVisible:aLineNr in:self extent
!

isLineVisible:aLineNr in:anExtentPoint
    "returns true if the line is visible"

    |y|
    y := self yVisibleOfLine:aLineNr.

  ^ (y between:margin and:(anExtentPoint y - margin))
!

lineIsFullyVisible:aLineNr
    "returns true if the line is fully visible"

    |y|

    shown ifFalse:[^ false].

    y := self yVisibleOfLine:aLineNr.

    (y between:0 and:height) ifTrue:[
	y := self yVisibleOfLine:(aLineNr + 1).
	y <= height ifTrue:[^ true ].
    ].
    ^ false
!

size
    "returns the number of list entries
    "
    ^ self list size
! !

!ListModelView methodsFor:'recomputation'!

preferredExtent
    "returns the preferred extent"

    |x y|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
	^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
	^ preferredExtent
    ].
    cachedPreferredExtent isNil ifTrue:[
	y := self heightOfContents.
	x := self widthOfContents.
	cachedPreferredExtent := x@y
    ].
    ^ cachedPreferredExtent
!

recomputeHeightOfContents
    "recompute all the y positions
    "
    |newList
     yAbs "{ Class: SmallInteger }"
     size "{ Class: SmallInteger }"|

    yAbs    := (textStartTop + margin).   "/ top inset of first line
    size    := self size.
    newList := OrderedCollection new:(size + 1).
    newList add:yAbs.

    size ~~ 0 ifTrue:[
        1 to:size do:[:anIndex|
            yAbs := yAbs + (self heightOfLineAt:anIndex).
            newList add:yAbs
        ].
    ].
    startOfLinesY := newList.
    cachedPreferredExtent := nil.
! !

!ListModelView methodsFor:'scroller interface'!

getWidthOfContents
    ^ widthOfContents
!

heightOfAnyNonNilItem
    "returns the height of a line at an index (including lineSpacing...)"

    |item|

    item := list
        detect:[:i | i notNil]
        ifNone:[ ^ lineSpacing + gc font height ]. "arbitrary"

    ^ self lineHeightFor:item.
!

heightOfContents
    "return the height of the contents in pixels"

    ^ self startOfLinesY last ? 0
!

heightOfLineAt:aLineNr
    "returns the height of a line at an index (including lineSpacing...)"

    hasConstantHeight ifTrue:[
	constantHeight isNil ifTrue:[
	    constantHeight := self heightOfAnyNonNilItem.
	].
	^ constantHeight
    ].
    ^ self realHeightOfLineAt:aLineNr
!

innerHeight
    "returns the inner height of the contents shown
    "
    ^ height - margin - margin

!

innerWidth
    "returns the inner width of the contents shown
    "
    ^ width - margin - margin

!

maxViewOriginY
    "returns the maximum possible y of the view origin
    "
    ^ (self heightOfContents - self innerHeight) max:0


!

realHeightOfLineAt:aLineNr
    "returns the real (uncached) height of a line at an index"

    |item|

    item := self at:aLineNr ifAbsent:nil.
    item notNil ifTrue:[
        ^ self lineHeightFor:item
    ].
    ^ lineSpacing + gc font height "arbitrary"
!

setWidthOfContents: aWidth
    widthOfContents := aWidth.
!

verticalScrollStep
    "return the amount to scroll when stepping up/down (also used for mouseWheel)."

    ^ 10
!

viewOrigin
    "return the viewOrigin; that's the coordinate of the contents
     which is shown topLeft in the view.
    "
    ^ viewOrigin
!

widthOfContents
    "return the width of the contents in pixels
    "
    |range
     size  "{ Class:SmallInteger }"
     start "{ Class:SmallInteger }"
     stop  "{ Class:SmallInteger }"
    |
    (widthOfContents notNil and:[computeWidthInRange isNil]) ifTrue:[
        ^ widthOfContents + textStartLeft
    ].
    range               := computeWidthInRange.
    computeWidthInRange := nil.
"/    preferredExtent     := nil.
"/    cachedPreferredExtent := nil.

    size := self size.

    size == 0 ifTrue:[
        widthOfContents := 20.
    ] ifFalse:[
        widthOfContents isNil ifTrue:[
            widthOfContents := self widthOfWidestLineBetween:1 and:size
        ] ifFalse:[
            start := range x.
            stop  := range y min:size.

            start > stop ifFalse:[
                size := self widthOfWidestLineBetween:start and:stop.

                widthOfContents < size ifTrue:[
                    widthOfContents := size
                ]
            ]
        ]
    ].
    ^ widthOfContents + textStartLeft
!

xOriginOfContents
    "return the horizontal origin of the contents in pixels
    "
    ^ viewOrigin x

!

yOriginOfContents
    "return the vertical origin of the contents in pixels
    "
    ^ viewOrigin y

! !

!ListModelView methodsFor:'scrolling'!

basicScrollTo:anOrigin redraw:doRedraw
    "change origin to have newOrigin be visible at the top-left.
    "
    |newOrg dltOrg winGrp
     innerWT    "{ Class:SmallInteger }"
     innerHG    "{ Class:SmallInteger }"
     h          "{ Class:SmallInteger }"
     x          "{ Class:SmallInteger }"
     x0         "{ Class:SmallInteger }"
     x1         "{ Class:SmallInteger }"
     y          "{ Class:SmallInteger }"
     w          "{ Class:SmallInteger }"
     y0         "{ Class:SmallInteger }"
     y1         "{ Class:SmallInteger }"
     dX         "{ Class:SmallInteger }"
     dY         "{ Class:SmallInteger }"
    |

    innerWT := self innerWidth.
    innerHG := self innerHeight.

    h := viewOrigin y.

    (y := anOrigin y) > h ifTrue:[              "/ end of contents
        y > (dY := self maxViewOriginY) ifTrue:[
            y := dY max:h                  
        ]
    ] ifFalse:[
        y := y max:0.
    ].

    (x := anOrigin x) > 0 ifTrue:[
        x := x min:(self widthOfContents - innerWT).
    ].
    x      := x max:0.
    newOrg := (x @ y).
    dltOrg := newOrg - viewOrigin.
    dX     := dltOrg x.
    dY     := dltOrg y.

    (dX == 0 and:[dY == 0]) ifTrue:[
        ^ self
    ].

    dY := dY abs.
    dX := dX abs.

    (   shown not                                        "/ check if we are shown
     or:[(dX ~~ 0 and:[dY ~~ 0])                         "/ scroll vertical & horizontal
     or:[(innerHG - dY < 20 or:[innerWT - dX < 20])]]    "/ faster to invalidate screen
    ) ifTrue:[
        viewOrigin := newOrg.
        self originChanged:dltOrg.
        shown ifTrue:[ self invalidate ].
        ^ self
    ].

    (winGrp := self windowGroup) notNil ifTrue:[
        winGrp processRealExposeEventsFor:self.
    ].

    self originWillChange.

    (doRedraw and:[shown]) ifFalse:[
        viewOrigin := newOrg.
        self originChanged:dltOrg.
        ^ self
    ].

    self catchExpose.
    viewOrigin := newOrg.

    dY ~~ 0 ifTrue:[                            "/ SCROLL VERTICAL
        y0 := y1 := margin + dY.
        h  := innerHG - dY.

        dltOrg y < 0 ifTrue:[y0 := margin. y := y0]
                    ifFalse:[y1 := margin. y := y1 + h].

        self copyFrom:self x:margin y:y0 toX:margin y:y1 width:innerWT height:h async:true.
        self invalidateX:margin y:y width:innerWT height:(innerHG - h).

    ] ifFalse:[                                 "/ SCROLL HORIZONTAL
        x0 := x1 := dX + margin.
        w  := innerWT - dX.

        dltOrg x < 0 ifTrue:[x0 := x := margin ]
                    ifFalse:[x1 := margin. x := w].

        self copyFrom:self x:x0 y:margin toX:x1 y:margin width:w height:innerHG async:true.
        self invalidateX:x y:margin width:(width - w) height:innerHG.
    ].
    self originChanged:dltOrg.
    self waitForExpose.

    winGrp notNil ifTrue:[
        winGrp processRealExposeEventsFor:self.
    ].
!

halfPageDown
    "scroll down half a page
    "
    self scrollDown:(height // 2).

!

halfPageUp
    "scroll up half a page
    "
    self scrollUp:(height // 2).

!

makeLineVisible:aLnNr
    "make the line visible
    "
    aLnNr notNil ifTrue:[
	self scrollToLine:aLnNr
    ].
!

scrollTo:anOrigin redraw:doRedraw
    "change origin to have newOrigin be visible at the top-left.
    "
    |process|

    "/ check if we are still in scrolling due to async. processes

    ((process := activeScrollProcess) notNil and:[process isDead]) ifTrue:[
        activeScrollProcess := nil.
    ].
    activeScrollProcess notNil ifTrue:[^ self].
    activeScrollProcess := Processor activeProcess.
    self basicScrollTo:anOrigin redraw:doRedraw.
    activeScrollProcess := nil.
!

scrollToLine:aLineNumber
    "make line visible"

    |inHg "{ Class:SmallInteger }"
     yTop "{ Class:SmallInteger }"
     orgY "{ Class:SmallInteger }"
     yBot "{ Class:SmallInteger }"|

    (aLineNumber notNil and:[aLineNumber between:1 and:(self size)]) ifFalse:[
        ^ self
    ].

    yTop := self yAbsoluteOfLine:aLineNumber.
    inHg := self innerHeight.
    orgY := viewOrigin y.

    yTop > orgY ifTrue:[
        yBot := self yAbsoluteOfLine:(aLineNumber + 1).

        yBot <= (orgY + inHg) ifTrue:[
            ^ self
        ].
    ].
    yTop := (yTop - (inHg // 2)) max:0.
    self scrollTo:(viewOrigin x @ yTop).
! !

!ListModelView methodsFor:'scrolling auto'!

startAutoScroll:aSelectorOrBlock distance:aDistance
    "setup for auto-scroll (when button-press-moving below/above view);
     - timeDelta for scroll is computed from distance
    "
    |timeDelta scrollBlock|

    autoScroll ifFalse:[
	self stopAutoScroll.
	^ self
    ].

    autoScrollBlock notNil ifTrue:[
	Processor removeTimedBlock:autoScrollBlock.
    ] ifFalse:[
	self compressMotionEvents:false.
    ].

    timeDelta := 0.5 / (aDistance abs).

    scrollBlock :=
	[
	    aSelectorOrBlock isSymbol ifTrue:[
		self perform:aSelectorOrBlock.
	    ] ifFalse:[
		aSelectorOrBlock value
	    ].
	    autoScrollBlock notNil ifTrue:[
		Processor addTimedBlock:autoScrollBlock afterSeconds:timeDelta.
	    ]
	].

    autoScrollBlock := [self sensor pushUserEvent:#value for:scrollBlock].
    Processor addTimedBlock:autoScrollBlock afterSeconds:timeDelta.
!

stopAutoScroll
    "stop any autoScroll
    "
    autoScrollBlock notNil ifTrue:[
	Processor removeTimedBlock:autoScrollBlock.
	autoScrollBlock := nil.
	self compressMotionEvents:true.
    ].
! !

!ListModelView methodsFor:'selection'!

hasSelection
    "on default false is returned
    "
    ^ false
! !

!ListModelView::Renderer class methodsFor:'documentation'!

documentation
"
    prepared for ListItemRenderer
    .... SelectionItemRenderer ...

    goal:
	allow the user to redefine the display operation and the dimesion queries
"
! !

!ListModelView::Renderer class methodsFor:'instance creation'!

forView:aView
    |renderer|

    renderer := self basicNew initialize.
    renderer forView:aView.
    ^ renderer
! !

!ListModelView::Renderer methodsFor:'accessing-look'!

showItemInAdditionToColumns
    "raise an error: must be redefined in concrete subclass(es)"

    ^ true "/There are no columns!!"

    "Modified: / 24-04-2013 / 13:27:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListModelView::Renderer methodsFor:'change & update'!

listWillChange
    "called before the list changed, clear caches etc.
     here nothing is done
    "
!

sizeChanged:how
    "Called when size of the corresponding view has changed."

    "Created: / 17-04-2013 / 11:42:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withinUpdateFromListDo:aBlock
    "handle an update from the list
    "
    aBlock value
! !

!ListModelView::Renderer methodsFor:'displaying'!

display:anItem atX:xLeft y:yTop lineHeight:h
    "display the item on the view"

    "/ obsolete - for backward compatibility
    self display:anItem atX:xLeft y:yTop lineHeight:h isHighlightedAsSelected:false
!

display:anItem atX:xLeft y:yTop lineHeight:h isHighlightedAsSelected:isHighlightedAsSelected
    "display the item on the view
    "
    |x0 y0 label labelShown|

    x0 := xLeft.
    y0 := yTop.

    anItem isHierarchicalItem ifTrue:[
        (anItem class whichClassIncludesSelector:#displayOn:x:y:h:) ~~ AbstractHierarchicalItem ifTrue:[
            "/ it has a redefined displayOn method.
            Transcript showCR:'please define #displayOn:x:y:h:isHighlightedAsSelected: in ',anItem class name.
            anItem displayOn:view x:x0 y:y0 h:h 
        ] ifFalse:[        
            anItem displayOn:view x:x0 y:y0 h:h isHighlightedAsSelected:isHighlightedAsSelected
        ].
    ] ifFalse:[
        anItem isNil ifTrue:[^ self].

        y0    := y0 - (((self heightFor:anItem) + 1 - h) // 2).
        label := anItem.

        label isImageOrForm ifFalse:[
            label isNumber ifTrue:[
                label := label printString
            ].
            y0 := y0 + view font ascent
        ].
        labelShown := label.
        label isText ifTrue:[
            isHighlightedAsSelected ifTrue:[
                (label hasChangeOfEmphasis) ifTrue:[
                    labelShown := Text string:label string emphasisCollection:label emphasis asArray.
                    labelShown emphasisAllRemove:#color.
                ].
            ].
        ].
        labelShown displayOn:view x:x0 y:y0
    ].
!

postRedrawX:damageX y:yStartOrYDamage w:damageWidth from:startOrNil to:stopOrNil
    "called after redraw of the items in range from start to stop is done;
     if no items are damaged, start and stop is set to nil.
    "
!

validateDrawableItemsFrom:start to:stop
    "called before drawing items from start to stop; if the method returns false
     nothing will be drawn and a invalidate is pushed on the event queue.
     On default true is returned.
    "
    ^ true
! !

!ListModelView::Renderer methodsFor:'instance creation'!

forView:aView
    view := aView.
    view shown ifTrue:[ self mapped ].
!

mapped
    "called if the view is mapped; can be redefined by subclass
    "
!

release
    "called if the view is gone; can be redefined by subclass
    "
! !

!ListModelView::Renderer methodsFor:'queries-dimensions'!

heightFor:anItem
    "returns the height of an item on the view
    "
    ^ anItem heightOn:view
!

maxItemWidthOrNil
    "returns the maximum item width for drawing or nil
     if unspecified (the default); used for cliping
    "
    ^ nil
!

widthFor:anItem
    "returns the width of an item on the view
    "
    ^ anItem widthOn:view
!

widthOfWidestLineBetween:firstLine and:lastLine
    "returns the width of the longest line in pixels in a range; if the rendere
     cannot compute the width, nil is returned (the default).
    "
    ^ nil
! !

!ListModelView::TableRenderer class methodsFor:'defaults'!

dragCursor
    "returns the cursor used to highliggt the drag can start operation
    "
    ^ Cursor leftRightArrow
!

separatorOneDColor
    "answer the color used for drawing separators"

    ^ Color lightGray
! !

!ListModelView::TableRenderer methodsFor:'accessing'!

columnDescriptors
    ^ columnDescriptors

    "Created: / 30-07-2018 / 15:44:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-08-2018 / 13:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

columnDescriptors:aSeqOfColumnSpecs
    "setup column descriptions for a sequence of DataSetColumnSpec's but still keep
     the receiver which provides the selectors called by the DataSetColumnSpec.

     If the receiver is nil, the item into the list is invoked"

    self columnDescriptors:aSeqOfColumnSpecs receiver:receiver.
!

columnDescriptors:aSeqOfColumnSpecs receiver:aReceiver
    "setup column descriptions for a sequence of DataSetColumnSpec's and the
     receiver which provides the selectors called by the DataSetColumnSpec.

     If the receiver is nil, the item into the list is invoked"

    receiver := aReceiver.

    minimumRequiredColumnHeight := 0.

    aSeqOfColumnSpecs size == 0 ifTrue:[
        columnDescriptors := #().
    ] ifFalse:[
        columnDescriptors := aSeqOfColumnSpecs collect:[:aColumnSpec|
            ColumnDescriptor dataSetColumnSpec:aColumnSpec
        ].
        columnDescriptors keysAndValuesDo:[:colNr :spec|
            spec columnNumber:colNr.

            minimumRequiredColumnHeight :=
                    minimumRequiredColumnHeight max:(spec minimumRequiredColumnHeight).
        ].
    ].
    hasFixedItemWidth := attributes at:#hasFixedItemWidth ifAbsent:[false].

    self initializeSplitbars.
    self splitbarsChanged

    "Modified: / 24-04-2013 / 13:32:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numberOfColumns
    "answer the numbers of columns excluding the items row"

    ^ columnDescriptors size
!

xSplitbars
    ^ xSplitbars
! !

!ListModelView::TableRenderer methodsFor:'accessing-look'!

defaultWidthForItem
    "answer the default witdth of the item before the first column"

    ^ attributes at:#defaultWidthForItem ifAbsent:[ 100 ].
!

defaultWidthForItem:anIntegerOrFloat
    "Set the default witdth of the item before the first column.
     If `anIntegerOrFloat` is 
        - an integer then the width is absolute width in pixels
        - a float in <0.0, 1,1> then the width is percentage
          of view's width
    "
    anIntegerOrFloat isFloat ifTrue:[
        self assert: (anIntegerOrFloat between: 0.0 and: 1.0)
    ].
    ^ attributes at:#defaultWidthForItem put:anIntegerOrFloat.

    "Modified: / 12-08-2013 / 12:20:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultWidthForItemInPixels
    "Answer the default witdth of the item before the first column in pixels"

    | w |

    w := self defaultWidthForItem.
    w isFloat ifTrue:[
        w := (view width * w) rounded.
    ].
    ^ w

    "Created: / 12-08-2013 / 12:16:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

noAutoResizeForRowOfItems
    "the first row which keeps the items are not automaticaly resized
     when width of items changed"

    hasFixedItemWidth := true.
    attributes at:#hasFixedItemWidth put:true.
!

separatorOneDColor
    "answer the color used for drawing separators"

    separatorOneDColor isNil ifTrue:[
	separatorOneDColor := self class separatorOneDColor.

	(view notNil and:[view realized]) ifTrue:[
	    separatorOneDColor := separatorOneDColor onDevice:(view device).
	].
    ].
    ^ separatorOneDColor
!

showHorizontalSeparators
    "answer true if horizontal separators are drawn"

    ^ attributes at:#showHorizontalSeparators ifAbsent:[ true ].
!

showHorizontalSeparators:aBoolean
    "set true if horizontal separators are drawn"

    attributes at:#showHorizontalSeparators put:aBoolean.
!

showHorizontalSeparatorsForItem
    "answer true if horizontal separators is drawn for the item row"

    ^ attributes at:#showHorizontalSeparatorsForItem ifAbsent:[ true ].
!

showHorizontalSeparatorsForItem:aBoolean
    "set true if horizontal separators is drawn for the item row"

    attributes at:#showHorizontalSeparatorsForItem put:aBoolean.
!

showItemInAdditionToColumns
    "Return, whether the item itseld should be shown in addition to 
     columns (default)"

    ^attributes at:#showVerticalSplitbarsBelowContents ifAbsent:[ true ]

    "Created: / 24-04-2013 / 13:26:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showItemInAdditionToColumns:aBoolean
    "If set to troe, the implicit forst column is shown (old behaviour).
     When false, only column are shown"

    | old |

    old := self showItemInAdditionToColumns.
    old == self ifTrue:[ ^ self ].
    attributes at:#showVerticalSplitbarsBelowContents put:aBoolean.

    "Created: / 24-04-2013 / 13:24:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showVerticalSplitbars
    "answer true if vertical separators are drawn"

    ^ attributes at:#showVerticalSplitbars ifAbsent:[ true ].
!

showVerticalSplitbars:aBoolean
    "set true if vertical separators are drawn"

    attributes at:#showVerticalSplitbars put:aBoolean.
!

showVerticalSplitbarsBelowContents
    "answer true if the vertical separators are drawn below last row"

    ^ attributes at:#showVerticalSplitbarsBelowContents ifAbsent:[ false ].
!

showVerticalSplitbarsBelowContents:aBoolean
    "set true if the vertical separators are drawn below last row"

    attributes at:#showVerticalSplitbarsBelowContents put:aBoolean.
!

splitbarInset
    "returns the horizontal left and right inset of the splitbar"

    ^ 2
!

textStartLeft
    "used when drawing the last separator;
     workaround when drawing the selection frame"

    ^ 2
! !

!ListModelView::TableRenderer methodsFor:'actions'!

moveSplitbarAt:aSepIndex toAbsoluteX:x
    "move the position of the separator at an index to absolute position x;
     used to drag splitbars"

    |xOld xNew xPrv deltaX xAbsoluteOfFirstSplitbar|

    aSepIndex == 1 ifTrue:[
        hasFixedItemWidth := true.
        xPrv := view margin.
    ] ifFalse:[
        xPrv := xSplitbars at:(aSepIndex - 1).
    ].

    aSepIndex == 1 ifTrue:[
        hasFixedItemWidth := true.
        xPrv := view margin.
    ] ifFalse:[
        xPrv := xSplitbars at:(aSepIndex - 1).
    ].
    xOld := xSplitbars at:aSepIndex.
    xNew := x max:xPrv.

    deltaX := xNew - xOld.
    deltaX = 0 ifTrue:[ ^ self ].

    xAbsoluteOfFirstSplitbar := xSplitbars at:1.

    xSplitbars from:aSepIndex keysAndValuesDo:[:sepIdx :sepX|
        xSplitbars at:sepIdx put:(sepX + deltaX).
    ].
    aSepIndex ~~ 1 ifTrue:[
        (columnDescriptors at: aSepIndex - 1) width: (xSplitbars at: aSepIndex) - (xSplitbars at: aSepIndex - 1) - (self splitbarInset * 2).
    ].

    view setWidthOfContents:(xSplitbars last).

    view shown ifTrue:[
        |damage width height orgX|

        view windowGroup processRealExposeEventsFor:self.

        width  := view width.
        height := view height.
        orgX   := view viewOrigin x.

        xNew := ((xNew - orgX) max:0) min:width.
        xOld := ((xOld - orgX) max:0) min:width.
        xPrv := ((xPrv - orgX) max:0) min:width.

        xOld > xNew ifTrue:[                                    "/ <- copy to left
            deltaX := xOld - xNew.

            view copyFrom:view x:xOld y:0 toX:xNew y:0
                    width:(width - xOld) height:height.

            damage := Rectangle left:(width - deltaX) top:0 width:deltaX height:height.
            view invalidateDeviceRectangle:damage repairNow:false.
        ] ifFalse:[
            xOld < xNew ifTrue:[                                "/ -> copy to right
                view copyFrom:view x:xOld y:0 toX:xNew y:0
                        width:(width - xNew) height:height.
            ].
        ].
        xNew > xPrv ifTrue:[
            "/ should not invalidate the items display range..."

            xAbsoluteOfFirstSplitbar := xAbsoluteOfFirstSplitbar - self splitbarInset.
            xPrv := (xPrv max:xAbsoluteOfFirstSplitbar).

            xNew > xPrv ifTrue:[
                damage := Rectangle left:xPrv top:0 width:(xNew -xPrv) height:height.
                view invalidateDeviceRectangle:damage repairNow:false.
            ].
        ].
    ].
    view contentsChanged.

    "Modified: / 07-05-2013 / 20:55:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListModelView::TableRenderer methodsFor:'change & update'!

sizeChanged:how
    view sensor pushUserEvent:#sizeChangedDelayed: for:self withArgument:how

    "Created: / 07-05-2013 / 18:32:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sizeChangedDelayed:how
    self initializeSplitbars.
    self splitbarsChanged.

    "Created: / 07-05-2013 / 18:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

splitbarsChanged
    "called if the splitbars has changed; recompute the width of contents"

    view notNil ifTrue:[
	|newWidth oldWidth|

	oldWidth := view getWidthOfContents.

	oldWidth notNil ifTrue:[
	    newWidth := xSplitbars last.

	    newWidth ~= oldWidth ifTrue:[
		view setWidthOfContents:newWidth.
		view contentsChanged.
	    ].
	    view invalidate.
	].
    ].
!

withinUpdateFromListDo:aBlock
    "handle an change & update within the view"

    |xAbs|

    xAbs := xSplitbars last.
    super withinUpdateFromListDo:aBlock.

    xAbs ~~ xSplitbars last ifTrue:[
	self splitbarsChanged
    ].
! !

!ListModelView::TableRenderer methodsFor:'displaying'!

drawColumnsFrom:start to:stop x:xDmg y:yStart w:wDmg
    "draw columns from start to stop.
     if the start/stop index is nil, than no row is affected by the damage."

    |xNxt xMax xTrs clip y0 y1 x0 x1 hgFgColor hgBgColor fgColor bgColor colInset
    shownSelected numSplitbars|

    start isNil ifTrue:[^ self].
    numSplitbars := xSplitbars size.
    numSplitbars > 1 ifFalse:[^ self].

    xTrs := view viewOrigin x.
    xMax := xDmg + wDmg.
    xNxt := xSplitbars first - xTrs.

    xNxt >= xMax ifTrue:[^ self].

    view hasSelection ifTrue:[
        hgFgColor := view hilightForegroundColor.
        hgBgColor := view hilightBackgroundColor.
    ].
    fgColor := view foregroundColor.
    bgColor := view backgroundColor.
    clip    := view clippingBoundsOrNil.

    clip isNil ifTrue:[
        clip := Rectangle left:xDmg top:yStart width:wDmg height:(view height - yStart).
    ].
    colInset := self splitbarInset.

    2 to:numSplitbars do:[:anIndex|
        |clipLft clipRgt colWdth colDesc|

        xNxt < xMax ifFalse:[^ self].

        x0   := xNxt.
        xNxt := (xSplitbars at:anIndex) - xTrs.
        x1   := xNxt.

        "/ workaround due to drawing the selection frame
        anIndex == numSplitbars ifTrue:[ x1 := x1 + self textStartLeft ].

        colDesc := columnDescriptors at:(anIndex - 1) ifAbsent:[ ^ self ].    "/ can give up...
        clipLft := x0 max:xDmg.
        clipRgt := x1 min:xMax.
        colWdth := x1 - x0.

        (colWdth > 2 and:[clipLft < clipRgt]) ifTrue:[
            clip := clip copy.
            clip setLeft:clipLft.
            clip right:clipRgt.
            view clippingBounds:clip.
            y1 := yStart.

            start to:stop do:[:aRowNr| 
                |recv|

                y0   := y1.
                y1   := view yVisibleOfLine:(aRowNr + 1).

                recv := receiver.
                recv isNil ifTrue:[ recv := view at:aRowNr ifAbsent:nil ].

                recv notNil ifTrue:[
                    (hgFgColor notNil and:[view isInSelection:aRowNr]) ifTrue:[
                        shownSelected := true.
                        view paint:hgFgColor on:hgBgColor
                    ] ifFalse:[
                        shownSelected := false.
                        view paint:fgColor on:bgColor.
                    ].
                    colDesc
                        drawRowAt:aRowNr
                        shownSelected:shownSelected
                        receiver:recv
                        x:x0 + colInset
                        y:y0
                        w:colWdth - colInset - colInset
                        h:(y1 - y0) on:view.
                ].
            ].
        ].
    ].

    "Modified: / 16-06-2010 / 16:34:32 / cg"
!

drawHorizontalSeparatorsX:x y:y w:w from:start to:stop
    "draw horizontal seperators from start to stop.
     if the start/stop index is nil, than no row is affected by the damage."

    |x1 ySep clipRec x0|

    start isNil ifTrue:[ ^ self ].

    "/ workaround due to drawing the selection frame
    x1 := self xVisibleOfLastSplitbar + self textStartLeft.

    x1 := x1 min:(x + w).
    x1 <= x ifTrue:[^ self].

    x0 := x.

    self showHorizontalSeparatorsForItem ifFalse:[
        x0 := x0 max:(self xVisibleOfSplitbarAt:1).
        x1 <= x0 ifTrue:[^ self].
    ].
    clipRec := Rectangle left:x0 top:0 right:x1 bottom:(view height).

    view clippingBounds:clipRec.
    view paint:(self separatorOneDColor).

    start to:stop do:[:aRowNr|
        ySep := (view yVisibleOfLine:(aRowNr + 1)) - 1.
        view displayLineFromX:x0 y:ySep toX:x1 y:ySep.
    ].
!

drawVerticalSplitbarsX:x0 y:y0 w:w from:start to:stop
    "draw vertical splitbars"

    |x x1 vX y1 clipRec nrOfSep|

    nrOfSep := xSplitbars size.
    nrOfSep == 0 ifTrue:[^ self].

    "/ workaround for textStartTop

    y1 := view height.

    self showVerticalSplitbarsBelowContents ifFalse:[
        stop isNil ifTrue:[^ self].

        y1 := y1 min:(view yVisibleOfLine:(stop + 1)).
        y1 <= y0 ifTrue:[ ^ self ].
    ].
    x1 := x0 + w.
    vX := view viewOrigin x.

    xSplitbars keysAndValuesDo:[:anIndex :physY|
        (self showVerticalSplitbarAt:anIndex) ifTrue:[
            x := physY - vX.
            x > x1 ifTrue:[^ self]. "/ can giveup - behind max x1

            anIndex == nrOfSep ifTrue:[
                "/ workaround due to drawing the selection frame
                x := x + self textStartLeft
            ].
            x >= x0  ifTrue:[
                clipRec isNil ifTrue:[
                    "/ first time to setup clipping and colors

                    clipRec := Rectangle left:x0 top:y0 right:x1 bottom:y1.
                    view clippingBounds:clipRec.
                    view paint:(self separatorOneDColor).
                ].
                view displayLineFromX:x y:y0 toX:x y:y1.
            ].
        ].
    ].
!

postRedrawX:x y:y w:w from:start to:stop
    "draw columns and than the splitbars"

    self drawColumnsFrom:start to:stop x:x y:y w:w.

    self showHorizontalSeparators ifTrue:[
	self drawHorizontalSeparatorsX:x y:y w:w from:start to:stop.
    ].
    self showVerticalSplitbars ifTrue:[
	self drawVerticalSplitbarsX:x y:y w:w from:start to:stop.
    ].
!

validateDrawableItemsFrom:start to:stop
    "called before drawing the items in range from start to stop; the
     renderer can perform some tests whether the draw operation might
     fail; width, ... might change during draw.
     If a test failed, the renderer should repair the failed test and
     return false. In this case a full redraw is done.
     On default true is returned."

    |xLastOld xLastNew|

    xLastOld := xSplitbars last.
    xLastNew := self widthOfWidestLineBetween:start and:stop.

    xLastNew == xLastOld ifTrue:[^ true].

    self splitbarsChanged.
    ^ false
! !

!ListModelView::TableRenderer methodsFor:'enumerating'!

columnDescriptorsDo:aOneArgBlock
    columnDescriptors size > 0 ifTrue:[
	columnDescriptors do:aOneArgBlock.
    ].
!

columnDescriptorsKeysAndValuesDo:aTwoArgBlock

    columnDescriptors size > 0 ifTrue:[
	columnDescriptors keysAndValuesDo:aTwoArgBlock.
    ].
!

xSplitbarsDo:aOneArgblock
    "evaluate a block on each x splitbar position
    "
    ^ xSplitbars do:aOneArgblock.
!

xSplitbarsKeysAndValuesDo:aTwoArgblock
    "evaluate a block on each x splitbar index and position
    "
    ^ xSplitbars keysAndValuesDo:aTwoArgblock.
! !

!ListModelView::TableRenderer methodsFor:'event processing'!

addEventHook
    "add event hook to window group"

    |winGrp|

    view notNil ifTrue:[
	winGrp := view windowGroup.

	winGrp notNil ifTrue:[
	    view enableMotionEvents.
	    winGrp addPreEventHook:self.
	].
    ].
!

processEvent:ev
    "only handled if drag splitbar is enabled"

    <resource: #keyboard (#Escape )>

    ev isInputEvent ifFalse:[^ false].

    dragOperation notNil ifTrue:[
        dragOperation value:ev.
        ^ true
    ].

    (view shown
    and:[ev view == view
    and:[(ev isButtonPressEvent or:[ev isButtonMotionEvent])
    and:[((ev button ~= 2) and:[ev button ~= #menu])]]]) ifTrue:[
        |splitBarColIndex colIndex phyX colX descr|

        splitBarColIndex := self xVisibleToSplitbar:(ev x).

        (splitBarColIndex > 0 and:[self showVerticalSplitbarsBelowContents not]) ifTrue:[
            "/ test whether y is below contents....
            ev y > (view heightOfContents - view viewOrigin y) ifTrue:[
                splitBarColIndex := 0
            ].
        ].

        ev isButtonPressEvent ifTrue:[
            splitBarColIndex < 1 ifTrue:[
                "/ see if a title-column has been clicked on...
                colIndex := self xAbsoluteToColumnIndex:(ev x). 
                (colIndex > 0 and:[colIndex <= columnDescriptors size]) ifTrue:[
                    descr := columnDescriptors at:colIndex.
                    descr := descr dataSetColumnSpec.
                    descr isSortable ifTrue:[
                        "/ see if clicked in the top-row; sort as appropriate...
self breakPoint:#todo.
                    ].
                ].
                ^ false
            ].

            colX := self xAbsoluteOfSplitbarAt:splitBarColIndex.
            phyX := ev x.

            dragOperation := [:event|
                event isKeyEvent ifTrue:[
                    event rawKey == #Escape ifTrue:[
                        dragOperation := nil.
                        self moveSplitbarAt:splitBarColIndex toAbsoluteX:colX.
                    ].
                ] ifFalse:[
                    event isButtonPressEvent ifTrue:[
                        dragOperation := nil.
                        self moveSplitbarAt:splitBarColIndex toAbsoluteX:colX.
                    ].
                    event isButtonReleaseEvent ifTrue:[
                        dragOperation := nil.
                    ].
                    event isButtonMotionEvent ifTrue:[
                        (view sensor hasExposeEventFor:nil) ifFalse:[
                            self
                                moveSplitbarAt:splitBarColIndex
                                toAbsoluteX:(colX + (event x) - phyX).
                        ].
                    ].
                ].
            ].
            ^ true
        ].

        splitBarColIndex == 0 ifTrue:[
            savedCursor notNil ifTrue:[
                view cursor:savedCursor.
                savedCursor := nil.
            ].
        ] ifFalse:[
            savedCursor isNil ifTrue:[
                savedCursor := view cursor.
                view cursor:dragCursor.
            ].
        ].
    ].
    ^ false

    "Modified: / 16-06-2010 / 16:35:41 / cg"
!

removeEventHook
    "release my event hook"

    |winGrp|

    view notNil ifTrue:[
	winGrp := view windowGroup.
	winGrp notNil ifTrue:[ winGrp removePreEventHook:self ].
    ].
! !

!ListModelView::TableRenderer methodsFor:'initialization'!

initializeSplitbars
    | xInset numCols xOffset widths |

    xInset      := 2 * self splitbarInset.
    numCols     := columnDescriptors size.
    xOffset     := self showItemInAdditionToColumns ifTrue:[self defaultWidthForItemInPixels] ifFalse:[0].

    xSplitbars  := Array new:(numCols + 1).
    xSplitbars at:1 put:xOffset.

    widths := self computeColumnWidthsWithXOffset: xOffset .

    1 to:numCols do:[:aColNr|
        xOffset := xOffset + xInset + (widths at: aColNr).
        xSplitbars at:(aColNr + 1) put:xOffset.
    ].

    "Created: / 24-04-2013 / 13:32:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-08-2013 / 12:16:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListModelView::TableRenderer methodsFor:'instance creation'!

forView:aView
    "setup instance for a view;
     setup my default columnDescription"

    attributes isNil ifTrue:[
	attributes := IdentityDictionary new.
    ].
    self columnDescriptors:nil.
    super forView:aView.
!

mapped
    "install event hook and enable motion events
    "
    view notNil ifTrue:[
	dragCursor isNil ifTrue:[
	    dragCursor := self class dragCursor onDevice:(view device).
	].
	separatorOneDColor notNil ifTrue:[
	    separatorOneDColor := separatorOneDColor onDevice:(view device).
	].
	self isDragEnabled ifTrue:[ self addEventHook ].
    ].
!

release
    "release event hook
    "
    self removeEventHook.
    super release.
! !

!ListModelView::TableRenderer methodsFor:'private'!

computeColumnWidthsWithXOffset: xoffset
    | done widthsFixed widths viewW remainingW nCols flexSum flexUnit |

    done := false.
    nCols := columnDescriptors size.
    nCols == 0 ifTrue:[ ^#() ].
    widthsFixed := Array new: nCols.
    widths := Array new: nCols.
    viewW := view width - 
             (xoffset) -
             (self splitbarInset * nCols * 2) -
             (nCols) "splitbar width".


    [ done ] whileFalse:[
        done := true.
        1 to: nCols do:[:c | 
            widths at: c put: (widthsFixed at: c) ? ((columnDescriptors at: c) width ? (columnDescriptors at: c) widthSpec)
        ].
        remainingW := viewW.
        flexSum := 0.0.
        1 to: nCols do:[:c | | ws |
            (ws := widths at: c) isInteger ifTrue:[
                remainingW := remainingW - ws.
                widthsFixed at: c put:ws.
            ] ifFalse:[
                ws isFloat ifTrue:[
                    flexSum := flexSum + ws.
                ]
            ].
        ].
        remainingW := remainingW max: 0.
        "/ Now, distribute remaining space to columns according their flex widths

        flexSum > 0 ifTrue:[
            flexUnit := remainingW / flexSum.

            1 to: nCols do:[:c | | wflex wmin w |
                (wflex := widths at: c) isFloat ifTrue:[
                    w := (flexUnit * wflex) floor.
                    wmin := (columnDescriptors at:c) widthMin.
                    w < wmin ifTrue:[
                        widthsFixed at: c put: wmin.
                        done := false.
                    ] ifFalse:[
                        widths at: c put: w.
                    ]
                ]
            ].
        ].
    ].
    ^widths

    "Created: / 12-08-2013 / 12:14:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListModelView::TableRenderer methodsFor:'private accessing'!

columnAlignmentAt:aColNr
    ^ (columnDescriptors at:aColNr) alignment
!

defaultColumnWidthAt:aColIndex
    ^ (columnDescriptors at:aColIndex) defaultColumnWidth
!

showVerticalSplitbarAt:aColIndex
    aColIndex > 1 ifTrue:[
	^ (columnDescriptors at:(aColIndex - 1)) showVerticalSplitbar
    ].
    ^ true
! !

!ListModelView::TableRenderer methodsFor:'queries-behavior'!

isDragEnabled
    "answer true if drag of separators is enabled"

    ^ attributes at:#isDragEnabled ifAbsent:[ true ].
!

isDragEnabled:aBoolean
    "answer true if drag of separators is enabled"

    attributes at:#isDragEnabled put:aBoolean.

    aBoolean ifTrue:[ self addEventHook ]
	    ifFalse:[ self removeEventHook ].
! !

!ListModelView::TableRenderer methodsFor:'queries-dimensions'!

boundingBoxForCellAtXAbsolute:x yAbsolute:y

    |xNxt xTrs y0 y1 x0 x1 colInset colNr rowNr numSplitbars|

    numSplitbars := xSplitbars size.
    numSplitbars > 1 ifFalse:[^ nil].
    colNr := self xAbsoluteToColumnIndex: x. 
    colNr == 0 ifTrue:[^nil].
    rowNr := view yAbsoluteToLineNr: y.


    xTrs := view viewOrigin x.
    xNxt := xSplitbars first - xTrs.
    colInset := self splitbarInset.

    colNr ~~ 1 ifTrue:[x0 := (xSplitbars at:colNr - 1)] ifFalse:[x0 := 0].       
    x1 := (xSplitbars at:colNr) " - xTrs".

    "/ workaround due to drawing the selection frame
    colNr == numSplitbars ifTrue:[ x1 := x1 + self textStartLeft ].


    y0   := view yAbsoluteOfLine:(rowNr).
    y1   := view yAbsoluteOfLine:(rowNr + 1).

    ^ Rectangle 
        left: x0 + colInset - (view viewOrigin x)
        top: y0 - (view viewOrigin y)
        width: x1 - x0 - colInset - colInset
        height: y1 - y0 - 1 "/Separator line"

    "Created: / 17-04-2013 / 16:28:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-04-2013 / 10:12:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

boundingBoxForCellAtXVisible:x yVisible:y
    ^self boundingBoxForCellAtXAbsolute: x + view viewOrigin x yAbsolute: y + view viewOrigin y

    "Created: / 18-04-2013 / 10:15:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

heightFor:anItem
    "returns the height of an item on the view
    "
    |h|

    h := (anItem heightOn:view) max:minimumRequiredColumnHeight.

    "/ add some space for the horizontal separator
    h := h + self splitbarInset.

    h odd ifTrue:[ ^ h + 1 ].
    ^ h
!

maxItemWidthOrNil
    "returns the maximum item width for drawing; the
     offset to the first splitbar minus an inset.
    "
    ^ xSplitbars first - self splitbarInset.
!

widthFor:anItem
    "returns the width of an item on the view including the columns
     but extracting the hierarchical tree inset.
    "
    |xStart xStop xDiff inset|

    self showItemInAdditionToColumns ifFalse:[ ^ 0 ].

    xStart := view xAbsoluteOfItem:anItem.

    hasFixedItemWidth ifFalse:[
        inset := self splitbarInset.
        xStop := (anItem widthOn:view) + xStart + inset + inset.
        xDiff := xStop - xSplitbars first.

        xDiff > 0 ifTrue:[
            xDiff := xDiff + 10.        "/ add more to have less computation
            xSplitbars := xSplitbars collect:[:xSep| xSep + xDiff ].
        ].
    ].
    ^ xSplitbars last - xStart

    "Modified: / 24-04-2013 / 13:56:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

widthOfColumn:aColumn
    "answer the width of a column or nil"

    |index x0 x1|

    index := columnDescriptors identityIndexOf:aColumn.

    index > 0 ifTrue:[
	(     (x0 := xSplitbars at:index       ifAbsent:nil) notNil
	 and:[(x1 := xSplitbars at:(index + 1) ifAbsent:nil) notNil])
	ifTrue:[
	    ^ (x1 - x0 - (2 * (self splitbarInset))) max:0
	].
    ].
    ^ nil
!

widthOfItemColumn
    "answer the current width of the column which holds the hierarchical
     item label."

    ^ xSplitbars at:1.
!

widthOfWidestLineBetween:firstLine and:lastLine
    "returns the width of the longest line in pixels in a range
     - used to optimize scrolling, by limiting the scrolled area;
       not for scrollbar or other width related stuff which should be exact."

    |item|

    hasFixedItemWidth ifFalse:[
        firstLine to:lastLine do:[:i|
            item := view at:i ifAbsent:nil.
            item notNil ifTrue:[self widthFor:item].
        ].
    ].
    ^ xSplitbars last
!

xAbsoluteOfSplitbarAt:anIndex
    "returns the physical x of the splitbar at an index
    "
    ^ xSplitbars at:anIndex
!

xAbsoluteToColumnIndex:absX
    "returns the column index for position x or 0 if not detected"

    |nextX|

    nextX := nil.

    "/ must walk reverse because a column could have a zero width
    xSplitbars keysAndValuesReverseDo:[:index :x|
        nextX notNil ifTrue:[
            x <= absX ifTrue:[
                nextX >= absX ifTrue:[^ index + 1].
            ].
        ].
        nextX := x.
    ].
    nextX notNil ifTrue:[
        nextX >= absX ifTrue:[^ 1].
    ].
    ^ 0

    "Created: / 16-06-2010 / 16:25:33 / cg"
!

xAbsoluteToSplitbar:absX
    "returns the splitbar index at the position x or 0 if not detected"

    |minX maxX|

    minX  := absX - 2.
    maxX  := absX + 2.

    "/ must walk reverse because a column could have a zero width
    xSplitbars keysAndValuesReverseDo:[:index :x|
        (x between:minX and:maxX) ifTrue:[^ index].
    ].
    ^ 0

    "Modified: / 16-06-2010 / 16:23:12 / cg"
!

xVisibleOfLastSplitbar
    "answer the visible x position of the last splitBar"

    ^ self xVisibleOfSplitbarAt:(xSplitbars size).
!

xVisibleOfSplitbarAt:anIndex
    "returns the visible x of the splitbar at an index
    "
    |x|

    x := xSplitbars at:anIndex.
    ^ x - (view viewOrigin x)
!

xVisibleToColumnIndex:relX
    "returns the column index for visible position x or 0 if not detected"
    ^ self xAbsoluteToColumnIndex: relX + view viewOrigin x

    "Created: / 18-04-2013 / 10:15:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xVisibleToSplitbar:visX
    "returns the splitbar index at the position x or 0 if not detected"

    ^ self xAbsoluteToSplitbar:(visX + view viewOrigin x).

    "Modified: / 16-06-2010 / 16:22:56 / cg"
! !

!ListModelView::TableRenderer::ColumnDescriptor class methodsFor:'instance creation'!

dataSetColumnSpec:aDataSetColumnSpec
    ^ self new dataSetColumnSpec:aDataSetColumnSpec
!

new
    ClipColumnQuerySignal isNil ifTrue:[
	ClipColumnQuerySignal := QuerySignal new.
    ].
    ^ self basicNew initialize
! !

!ListModelView::TableRenderer::ColumnDescriptor methodsFor:'accessing'!

alignment
    "returns the aligmnent of the contents of the underlaying cell"

    |alignment|

    alignment := dataSetColumnSpec columnAlignment.
    ^ alignment ? #left
!

dataSetColumnSpec
    ^ dataSetColumnSpec
!

dataSetColumnSpec:aDataSetColumnSpec

    aDataSetColumnSpec isSequenceable ifTrue:[
	dataSetColumnSpec := DataSetColumnSpec decodeFromLiteralArray:aDataSetColumnSpec.
    ] ifFalse:[
	dataSetColumnSpec := aDataSetColumnSpec.
    ].
!

defaultColumnWidth
    |width|

    width := (dataSetColumnSpec width ? 0) max:(dataSetColumnSpec minWidth ? 0).
    width > 0 ifTrue:[^ width ].

    ^ 70
!

minimumRequiredColumnHeight

    "Kludge because of CG's change...sigh."
    dataSetColumnSpec height isNumber ifFalse:[ ^ 0 ].
    ^ dataSetColumnSpec height ? 0

    "Modified: / 23-08-2013 / 17:59:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showVerticalSplitbar
    "answer true if the verical splitbar is shown"

    ^ dataSetColumnSpec showColSeparator ? true.
!

width
    "Return 
      - width in px if the column (if explicit) 
      - nil if the width should be computed dynamically
        based on view's width
    "
    ^width

    "Modified (comment): / 07-05-2013 / 17:56:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

width:anInteger
    width := anInteger.
!

widthMin
    "Return the minimal required width in px."

    ^dataSetColumnSpec minWidth

    "Created: / 07-05-2013 / 17:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

widthSpec
    "Return either
      - width in px as Integer or
      - relative width as Float"

    | w |
    w := dataSetColumnSpec width.
    w isFloat ifTrue:[ ^ w ].
    w := w max: dataSetColumnSpec minWidth.
    w > 0 ifFalse:[
        w := 70
    ].
    ^w

    "Created: / 07-05-2013 / 17:58:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListModelView::TableRenderer::ColumnDescriptor methodsFor:'displaying'!

drawRowAt:aRowNr shownSelected:isShownSelected receiver:aReceiver x:x y:y w:w h:h on:aGC
    "display a column for a specific row"

    |oldClippingRectangle paint savedPaint label drawSelector |

    isShownSelected ifFalse:[
        "/ draw the background color if required by spec..
        paint := self extractBackgroundColorFrom:aReceiver rowNr:aRowNr on:aGC.

        paint notNil ifTrue:[
            savedPaint := aGC paint.
            aGC paint:paint.
            "/ splitbarInset - draw from 0 to width of aGC (is clipped)
            aGC fillRectangleX:0 y:y width:(aGC width) height:h.
        ].
    ].
    w < 5 ifTrue:[ ^ self ].    "/ makes no sense to draw the label

    label := self extractColumnFrom:aReceiver rowNr:aRowNr on:aGC.
    label isEmptyOrNil ifTrue:[^ self].

    (drawSelector := dataSetColumnSpec drawSelector) notNil ifTrue:[
        "/ Set clip rect to make sure nobody can draw outside the cell
        oldClippingRectangle := aGC clippingRectangleOrNil.
        aGC clippingBounds:(Rectangle left:x top:y width:w height:h).
        drawSelector numArgs == 5 ifTrue:[
            aReceiver perform:  drawSelector with: aGC with: x with: y with: w with: h.
        ] ifFalse:[
            drawSelector numArgs == 6 ifTrue:[
                aReceiver perform:  drawSelector with: aGC with: x with: y with: w with: h with: columnNumber
            ] ifFalse:[
                self error: 'Invalid draw selector'
            ]
        ].
        aGC clippingBounds:oldClippingRectangle.
    ].

    drawSelector notNil ifTrue:[ ^ self ].

    ClipColumnQuerySignal handle:[:ex|
        oldClippingRectangle isNil ifTrue:[
            oldClippingRectangle := aGC clippingBoundsOrNil.
            aGC clippingBounds:(Rectangle left:x top:y width:w height:h).
        ].
        ex proceedWith:true.
    ] do:[
        isShownSelected ifFalse:[
            paint := self extractForegroundColorFrom:aReceiver rowNr:aRowNr on:aGC.

            paint notNil ifTrue:[
                aGC paint:paint.
            ] ifFalse:[
                savedPaint notNil ifTrue:[ aGC paint:savedPaint ].
            ].
        ].
        self drawObject:label x:x y:y w:w h:h on:aGC.
    ].
    oldClippingRectangle notNil ifTrue:[
        aGC clippingBounds:oldClippingRectangle.
    ].

    "Modified: / 17-04-2013 / 13:05:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ListModelView::TableRenderer::ColumnDescriptor methodsFor:'extract values'!

extractBackgroundColorFrom:aReceiver rowNr:aRowNr on:aView
    |color selector|

    aReceiver notNil ifTrue:[
	selector := dataSetColumnSpec backgroundSelector.

	selector notNil ifTrue:[
	    color := aReceiver perform:selector withOptionalArgument:columnNumber and:aRowNr and:aView.
	    color notNil ifTrue:[ ^ color ].
	].
    ].
    ^ dataSetColumnSpec backgroundColor.
!

extractColumnFrom:aReceiver rowNr:aRowNr on:aView
    |selector|

    aReceiver notNil ifTrue:[
        selector := dataSetColumnSpec printSelector ? dataSetColumnSpec readSelector.

        selector notNil ifTrue:[
            ^ aReceiver perform:selector withOptionalArgument:columnNumber and:aRowNr and:aView
        ].
    ].
    ^ nil

    "Modified: / 22-04-2013 / 14:04:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extractForegroundColorFrom:aReceiver rowNr:aRowNr on:aView
    |color selector|

    aReceiver notNil ifTrue:[
	selector := dataSetColumnSpec foregroundSelector.

	selector notNil ifTrue:[
	    color := aReceiver perform:selector withOptionalArgument:columnNumber and:aRowNr and:aView.
	    color notNil ifTrue:[ ^ color ].
	].
    ].
    ^ dataSetColumnSpec foregroundColor.
! !

!ListModelView::TableRenderer::ColumnDescriptor methodsFor:'instance creation'!

columnNumber:aNumber
    columnNumber := aNumber.
! !

!ListModelView::TableRenderer::ColumnDescriptor methodsFor:'private displaying'!

alignAndDisplay:anObject x:x y:y w:w on:aGC
    "display an object on aGC; care for alignment"

    |x0 width align|

    x0    := x.
    align := self alignment.

    align ~~ #left ifTrue:[
	width := anObject widthOn:aGC.

	width < w ifTrue:[
	    align == #right ifTrue:[
		x0 := x0 + w - width
	    ] ifFalse:[
		x0 := x0 + ((w - width) // 2)
	    ].
	].
    ].
    anObject displayOn:aGC x:x0 y:y.
!

displayImage:anImage x:x y:y w:w h:h on:aGC
    "display an image on aGC; answer the height used...."

    |height|

    height := anImage heightOn:aGC.

    height > h ifTrue:[
	(self queryForClipColumnWithAvailableHeight:h) ifFalse:[
	    ^ height
	].
    ].
    self alignAndDisplay:anImage x:x y:y w:w on:aGC.
    ^ height
!

displayLabelAndIcon:aLabelAndIcon x:x y:y w:w h:h on:aGC
    "display an image on aGC; answer the height used...."

    |height|

    height := aLabelAndIcon heightOn:aGC.

    height > h ifTrue:[
	(self queryForClipColumnWithAvailableHeight:h) ifFalse:[
	    ^ height
	].
    ].

    self alignAndDisplay:aLabelAndIcon x:x y:(y + aGC font ascent) w:w on:aGC.
    ^ height
!

displayString:aString x:x y:y w:w h:h on:aGC
    "display a string on aGC; answer the height used...."

    | hMargin hMargin2x shortWidth font shortedLabel fontHeight |

    font       := aGC font.
    hMargin := font ascent.
    hMargin2x := hMargin * 2.
    fontHeight := font height.

    aString isEmptyOrNil ifTrue:[ ^ fontHeight ].

    (self queryForClipColumnWithAvailableHeight:h) ifFalse:[
        ^ fontHeight
    ].
    dataSetColumnSpec longStringCompression ifTrue:[
        shortWidth := hMargin2x + (font widthOf:aString).

        shortWidth <= w ifTrue:[
            shortedLabel := aString.
        ] ifFalse:[
            |dottedString dottedWidth index|

            dottedString := '...'.
            dottedWidth  := font widthOf:dottedString.

            w < dottedWidth ifTrue:[ ^ fontHeight ].   "/ give up

            index := aString size // 2.

            [   index := index - 1.

                index > 0 ifTrue:[
                    shortedLabel := (aString copyFirst:index), '...', (aString copyLast:index).
                    shortWidth   := hMargin2x + (font widthOf:shortedLabel).
                ] ifFalse:[
                    shortedLabel := dottedString.
                    shortWidth   := dottedWidth.
                ].
                shortWidth > w
            ] whileTrue.
        ].
    ] ifFalse:[
        shortedLabel := aString                        
    ].

    shortedLabel notNil ifTrue:[
        self alignAndDisplay:shortedLabel x:hMargin + x y:(y + ((h - aGC font height) // 2) + aGC font ascent) w:w on:aGC.
    ].
    ^ fontHeight.

    "Modified: / 27-01-2018 / 00:54:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawObject:anObject x:x y:y w:w h:h on:aGC
    "display any object (sequence of objects) on aGC; answer the height used...."

    |totalHeight usedHeight|

    h < 4 ifTrue:[ ^ h ].

    anObject isEmptyOrNil ifTrue:[ ^ 2 ]. "/ nothing to draw; add 2 pixels

    anObject isImage ifTrue:[
	^ self displayImage:anObject x:x y:y w:w h:h on:aGC.
    ].
    anObject isString ifTrue:[
	^ self displayString:anObject x:x y:y w:w h:h on:aGC.
    ].
    anObject isSequenceable ifFalse:[
	"/ not yet handled....
	anObject class == LabelAndIcon ifTrue:[
	    ^ self displayLabelAndIcon:anObject x:x y:y w:w h:h on:aGC
	].

	^ self displayString:(anObject printString) x:x y:y w:w h:h on:aGC
    ].

    totalHeight := 0.

    anObject do:[:aSubObj|
	totalHeight < h ifTrue:[
	    usedHeight := self
		    drawObject:aSubObj
		    x:x
		    y:(y + totalHeight)
		    w:w
		    h:(h - totalHeight)
		    on:aGC.

	    totalHeight := totalHeight + usedHeight.
	].
    ].
    ^ (h - totalHeight)
!

queryForClipColumnWithAvailableHeight:anAvailableHeight

    anAvailableHeight > 8 ifTrue:[
	^ (ClipColumnQuerySignal query) == true
    ].
    ^ false.
! !

!ListModelView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


ListModelView initialize!
