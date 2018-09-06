"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

View subclass:#GraphColumnView
	instanceVariableNames:'columns listHolder references referenceHolder referenceSelector
		referenceColor showReferences zoomY zoomYHolder oldMenuMessage
		windowSize windowSizeHolder gridColor showGrid fgColor bgColor
		scrollUpdatesOriginX graphOriginX graphOriginXHolder'
	classVariableNames:'DefaultBackgroundColor DefaultGridColor DefaultForegroundColor
		DefaultReferenceColor'
	poolDictionaries:''
	category:'Views-Graphs'
!

!GraphColumnView class methodsFor:'documentation'!

documentation
"
    The class describes the common interface supported by the 2D or 3D GraphColumnView.
    This Viewclasses provide a lot of functionality for showing and manipulating graphs
    described through to a GraphColumn description. Each change in a graph description
    immediately take affect in the garph view.


    [See also:]
        GraphColumn
        GraphColumnView2D
        GraphColumnView3D

    [Author:]
        Claus Atzkern
"

! !

!GraphColumnView class methodsFor:'defaults'!

defaultMenu
    "redefined by subclass: should return the default middle button menu
    "
    ^ nil
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables
    "
    DefaultForegroundColor := Color black.
    DefaultReferenceColor  := Color darkGray.
    DefaultGridColor       := Color lightGray.
    DefaultBackgroundColor := Color veryLightGray.
"
 self updateStyleCache
"

! !

!GraphColumnView methodsFor:'accessing'!

columns
    "returns the list of column descriptions
    "
    ^ columns


!

columns:aList
    "set the list of columns descriptions
    "
    columns notNil ifTrue:[
        columns do:[:aCol| aCol removeDependent:self ]
    ].

    aList size ~~ 0 ifTrue:[
        columns := OrderedCollection new.

        aList do:[:aColumn| 
            aColumn addDependent:self.
            columns add:aColumn
        ]
    ] ifFalse:[
        columns := nil
    ].
    self doRecomputeGraph
!

graphOriginX
    "returns the logical index X of the first visible row; this number is used for
     accessing Y values from the GraphColumn description. On default, the value
     is set to 1.
    "
    ^ graphOriginX


!

graphOriginX:aNumber
    "set the logical index X of the first visible row; this number is used for
     accessing Y values from the GraphColumn description. On default, the value
     is set to 1.
     Changing the number, a scroll left or right is triggered.
    "
    |newX state|

    aNumber isNumber ifTrue:[
        newX := aNumber isInteger ifTrue:[aNumber]
                                 ifFalse:[(aNumber asFloat) rounded].   "/ no fractions

        newX ~~ graphOriginX ifTrue:[
            state := scrollUpdatesOriginX.
            scrollUpdatesOriginX := true.
            self scroll:(graphOriginX - newX).
            scrollUpdatesOriginX := state.
        ]
    ]
!

referenceSelector
    "returns the selector how to access the X value of an instance into
     the reference list. If the selector is nil (default), the entry is
     assumed to be the X value.
    "
    ^ referenceSelector
!

referenceSelector:aSelector
    "set the selector how to access the X value of an instance into the
     reference list. If the selector is nil (default), the entry is
     assumed to be the X value.
    "
    referenceSelector := (aSelector size == 0) ifTrue:[ #value ]
                                              ifFalse:[ aSelector asSymbol ]
!

references
    "returns list of references
    "
    ^ references


!

references:aListOfReferences
    "change the list of references
    "
    aListOfReferences size == 0 ifTrue:[
        references isEmpty ifTrue:[
            ^ self                      "/ nothing changed
        ].
        references := OrderedCollection new.
    ] ifFalse:[
        references := OrderedCollection new.
        aListOfReferences do:[:i| references add:i ]
    ].
    self updateReferences:#size atRelX:nil
!

scrollUpdatesOriginX
    "returns true, if the graphOriginX automatically is updated by
     any scroll action. The default is set to false.
    "
    ^ scrollUpdatesOriginX
!

scrollUpdatesOriginX:aBool
    "set to true if the graphOriginX automatically should be updated by any
     scroll action. Otherwise a scroll has no influnce to the current
     graphOriginX.
     The default is set to false.
    "
    scrollUpdatesOriginX := aBool
!

showDefaultMenu
    "returns true, if the middleButton menu is set to the default menu
     provided by the graph.
    "
    ^ self menuMessage == #defaultMenu
!

showDefaultMenu:aBool
    "enable or disable the default menu provided by the graph
    "
    |currMsg|

    currMsg := self menuMessage.

    aBool ifTrue:[
        oldMenuMessage := currMsg.
        self menuMessage:#defaultMenu
    ] ifFalse:[
        currMsg == #defaultMenu ifTrue:[
            self menuMessage:oldMenuMessage
        ]
    ].


! !

!GraphColumnView methodsFor:'accessing dimensions'!

windowSize
    "get the number of horizontal steps ( X )
    "
    ^ windowSize


!

windowSize:aValue
    "set the number of horizontal steps ( X )
    "
    |sz|

    sz := (self unsignedIntegerFrom:aValue onError:[101]) max:2.

    sz ~~ windowSize ifTrue:[
        windowSize := sz.
        self doRecomputeGraph
    ]

!

zoomY
    "returns current y-zoom factor
    "
    ^ zoomY


!

zoomY:aValue
    "set the current y-zoom factor; if the argument is nil,
     the y-zoom is set to 1.
    "
    |zY|

    (zY := self floatFrom:aValue onError:[1]) <= 0 ifTrue:[
        zY := 1
    ].

    zY = zoomY ifFalse:[
        zoomY := zY.
        self doInvalidateGraph
    ]


! !

!GraphColumnView methodsFor:'accessing look'!

backgroundColor
    "returns the current background color of the graph
    "
    ^ bgColor


!

backgroundColor:aColor
    "set the background color of the graph
    "
    (aColor isColor and:[bgColor ~= aColor]) ifTrue:[
        shown ifTrue:[
            bgColor := aColor onDevice:device.
            self doInvalidateGraph
        ] ifFalse:[
            bgColor := aColor
        ]
    ]
!

foregroundColor
    "returns the default foreground color used to draw graphs which
     has no foreground color specified.
    "
    ^ fgColor

!

foregroundColor:aColor
    "set the default foreground color used to draw graphs which
     has no foreground color specified.
    "
    (aColor isColor and:[fgColor ~= aColor]) ifTrue:[
        shown ifTrue:[ fgColor := aColor onDevice:device ]
             ifFalse:[ fgColor := aColor ].

        columns notNil ifTrue:[
            self updateColumns:#color with:nil from:nil
        ]
    ]
!

gridColor
    "returns the foreground color of the grid
    "
    ^ gridColor

!

gridColor:aColor
    "set the foreground color of the grid
    "
    (aColor isColor and:[gridColor ~= aColor]) ifTrue:[
        shown ifTrue:[ gridColor := aColor onDevice:device ]
             ifFalse:[ gridColor := aColor ].

        self updateGrid:#color
    ]
!

referenceColor
    "returns the foreground color used to draw the references
    "
    ^ referenceColor


!

referenceColor:aColor
    "set the foreground color used to draw the references
    "
    (aColor isColor and:[referenceColor ~= aColor]) ifTrue:[
        shown ifTrue:[referenceColor := aColor onDevice:device]
             ifFalse:[referenceColor := aColor].

        references notEmpty ifTrue:[
            self updateReferences:#color atRelX:nil
        ]
    ]
!

showGrid
    "returns true if the grid is enabled
    "
    ^ showGrid

!

showGrid:aBool
    "set the visibility state of the grid
    "
    |hasGrid|

    showGrid ~~ aBool ifTrue:[
        showGrid := aBool.
        self updateGrid:#state
    ]

!

showReferences
    "returns the visibility state of the references
    "
    ^ showReferences

!

showReferences:aBool
    "set the visibility state of the references
    "
    |hasGrid|

    showReferences ~~ aBool ifTrue:[
        showReferences := aBool.

        references notEmpty ifTrue:[
            self updateReferences:#state atRelX:nil
        ]
    ]
! !

!GraphColumnView methodsFor:'accessing mvc'!

graphOriginXHolder
    "returns the valueHolder, which keeps the current graphOriginX (see: #graphOriginX:)
    "
    ^ graphOriginXHolder
!

graphOriginXHolder:aHolder
    "set the valueHolder, which keeps the current graphOriginX (see: #graphOriginX:)
    "
    graphOriginXHolder == aHolder ifFalse:[
        graphOriginXHolder notNil ifTrue:[
            graphOriginXHolder removeDependent:self
        ].
        (graphOriginXHolder := aHolder) notNil ifTrue:[
            graphOriginXHolder addDependent:self
        ].
    ].
    self graphOriginX:(graphOriginXHolder value)

!

listHolder
    "returns the valueHolder, which keeps the list of column descriptions (see: #column:)
    "
    ^ listHolder


!

listHolder:aHolder
    "set the valueHolder, which keeps the list of column descriptions (see: #column:)
    "
    listHolder == aHolder ifFalse:[
        listHolder notNil ifTrue:[
            listHolder removeDependent:self
        ].
        (listHolder := aHolder) notNil ifTrue:[
            listHolder addDependent:self
        ].
    ].
    self columns:(listHolder value)

!

model:aModel
    "set the valueHolder which holds the selection and maybe the list of columnms
    "
    (model respondsTo:#list) ifTrue:[
        (model list == listHolder) ifTrue:[
            self listHolder:nil
        ]
    ].
    super model:aModel.

    aModel notNil ifTrue:[
        (aModel respondsTo:#list) ifTrue:[
            self listHolder:model list
        ]
    ]

!

referenceHolder
    "returns the valueHolder, which keeps the list of references (see: #references:)
    "
    ^ referenceHolder


!

referenceHolder:aHolder
    "set the valueHolder, which keeps the list of references (see: #references:)
    "
    referenceHolder == aHolder ifFalse:[
        referenceHolder notNil ifTrue:[
            referenceHolder removeDependent:self
        ].
        (referenceHolder := aHolder) notNil ifTrue:[
            referenceHolder addDependent:self
        ].
    ].
    self references:(referenceHolder value)

!

windowSizeHolder
    "returns the valueHolder, which keeps the windowSize (see: #windowSize:)
    "
    ^ windowSizeHolder

!

windowSizeHolder:aHolder
    "set the valueHolder, which keeps the windowSize (see: #windowSize:)
    "
    windowSizeHolder == aHolder ifFalse:[
        windowSizeHolder notNil ifTrue:[
            windowSizeHolder removeDependent:self
        ].
        (windowSizeHolder := aHolder) notNil ifTrue:[
            windowSizeHolder addDependent:self
        ].
    ].
    self windowSize:(windowSizeHolder value)

!

zoomYHolder
    "returns the valueHolder, which keeps the zoom Y factor (see: #zoomY:)
    "
    ^ zoomYHolder

!

zoomYHolder:aHolder
    "set the valueHolder, which keeps the zoom Y factor (see: #zoomY:)
    "
    zoomYHolder == aHolder ifFalse:[
        zoomYHolder notNil ifTrue:[
            zoomYHolder removeDependent:self
        ].
        (zoomYHolder := aHolder) notNil ifTrue:[
            zoomYHolder addDependent:self
        ]
    ].
    self zoomY:(zoomYHolder value).

! !

!GraphColumnView methodsFor:'add & remove columns'!

add:aColumn
    "insert a column at end; returns the inserted column
    "
    ^ self add:aColumn beforeIndex:(1 + columns size)

!

add:aColumn afterIndex:anIndex
    "add a new column after an index; returns the inserted column
    "
    ^ self add:aColumn beforeIndex:(anIndex + 1)

!

add:aColumn beforeIndex:anIndex
    "add a column before an index; returns the inserted column
    "
    aColumn isNil ifTrue:[^ nil].

    columns isNil ifTrue:[
        self columns:(Array with:aColumn).
        ^ aColumn.
    ].
    columns add:aColumn beforeIndex:anIndex.
    aColumn addDependent:self.

    aColumn shown ifTrue:[
        self updateColumns:#insert: with:nil from:aColumn.
    ].

!

addAll:aCollection beforeIndex:anIndex
    "add a collection of columns before an index
    "
    aCollection size ~~ 0 ifTrue:[
        columns size == 0 ifTrue:[
            self columns:aCollection
        ] ifFalse:[
            columns addAll:aCollection beforeIndex:anIndex.
            self doRecomputeGraph.
        ]
    ]

!

addFirst:aColumn
    "insert a column at start; returns the inserted column
    "
    ^ self add:aColumn beforeIndex:1

!

removeAll
    "remove all columns
    "
    self columns:nil

!

removeFirst
    "remove first column; returns the removed column
    "
    ^ self removeIndex:1


!

removeIndex:anIndex
    "remove column at an index; returns the removed column
    "
    |col|

    col := columns removeAtIndex:anIndex.
    col removeDependent:self.

    columns size == 0 ifTrue:[
        columns := nil
    ].
    col shown ifTrue:[
        self updateColumns:#remove: with:nil from:col
    ].
  ^ col


!

removeLast
    "remove last column; the removed column is returned
    "
    ^ self removeIndex:(columns size)

! !

!GraphColumnView methodsFor:'add & remove references'!

referenceAdd:aReference
    "add a reference to end of list
    "
    ^ self referenceAdd:aReference beforeIndex:(references size + 1)
!

referenceAdd:aReference beforeIndex:anIndex
    "add a reference before an index
    "
    references add:aReference beforeIndex:anIndex.

    self visibleReference:aReference do:[:x|
        self updateReferences:#insert: atRelX:x
    ].
    ^ aReference
!

referenceAddAll:aCollection beforeIndex:anIndex
    "add a collection of references before an index
    "
    aCollection size ~~ 0 ifTrue:[
        references size == 0 ifTrue:[
            self references:aCollection
        ] ifFalse:[
            references addAll:aCollection beforeIndex:anIndex.
            self updateReferences:#size atRelX:nil
        ]
    ]

!

referenceRemove:aReference
    "remove a reference
    "
    ^ self referenceRemoveIndex:(references identityIndexOf:aReference)

!

referenceRemoveAll
    "remove all references
    "
    self references:nil
!

referenceRemoveIndex:anIndex
    "remove the reference at an index
    "
    |aReference|

    aReference := references removeAtIndex:anIndex.

    self visibleReference:aReference do:[:x|
        self updateReferences:#remove: atRelX:x
    ].
    ^ aReference
! !

!GraphColumnView methodsFor:'change & update'!

update:what with:aPara from:chgObj
    "catch and handle a change notification of any object
    "
    |list start size stop|

    chgObj == windowSizeHolder ifTrue:[
        ^ self windowSize:(windowSizeHolder value)
    ].

    chgObj == zoomYHolder ifTrue:[
        ^ self zoomY:(zoomYHolder value)
    ].

    chgObj == graphOriginXHolder ifTrue:[
        ^ self graphOriginX:(graphOriginXHolder value)
    ].

    chgObj == referenceHolder ifTrue:[
        list := chgObj list.

        (what == #insert:) ifTrue:[
            ^ self referenceAdd:(list at:aPara) beforeIndex:aPara
        ].

        (what == #remove:) ifTrue:[
            ^ self referenceRemoveIndex:aPara
        ].

        (what == #removeFrom:) ifTrue:[
            chgObj value size == 0 ifTrue:[ ^ self references:nil ].

            start := aPara first.
            stop  := aPara last.

            (start - stop) == 0 ifTrue:[
                ^ self referenceRemoveIndex:start
            ]
        ] ifFalse:[
            (what == #insertCollection:) ifTrue:[
                start := aPara first.
                size  := aPara last.

                size == 1 ifTrue:[
                    ^ self referenceAdd:(list at:start) beforeIndex:start
                ].
                stop := start + size - 1.
                ^ self referenceAddAll:(list copyFrom:start to:stop) beforeIndex:start
            ]
        ].
        ^ self referenceHolder:chgObj
    ].

    chgObj == model ifTrue:[
        (what == #selectionIndex or:[what == #selection]) ifTrue:[
            ^ self
        ].
        what == #list ifTrue:[
            ^ self listHolder:model list
        ].
        model == listHolder ifFalse:[
            ^ self
        ].
    ].

    chgObj == listHolder ifTrue:[
        list := listHolder value.

        (what == #insert:) ifTrue:[ ^ self add:(list at:aPara) beforeIndex:aPara ].
        (what == #remove:) ifTrue:[ ^ self removeIndex:aPara ].

        (what == #insertCollection:) ifTrue:[
            start := aPara first.
            size  := aPara last.

            size ~~ 0 ifTrue:[
                size == 1 ifTrue:[
                    self add:(list at:start) beforeIndex:start
                ] ifFalse:[
                    stop := start + size - 1.
                    self addAll:(list copyFrom:start to:stop) beforeIndex:start
                ]
            ].
            ^ self
        ].

        (what == #removeFrom:) ifTrue:[
            chgObj value size == 0 ifTrue:[
                ^ self columns:nil
            ].
            start := aPara first.
            stop  := aPara last.

            (start - stop) == 0 ifTrue:[
                ^ self removeIndex:start
            ]
        ].
        ^ self listHolder:chgObj
    ].

    columns notNil ifTrue:[
        (columns includesIdentical:chgObj) ifTrue:[
            what ~~ #name ifTrue:[
                ^ self updateColumns:what with:aPara from:chgObj
            ]
        ]
    ].

    super update:what with:aPara from:chgObj

! !

!GraphColumnView methodsFor:'conversion'!

floatFrom:aValue onError:aBlock
    "converts something to a float, on error the result of the block is returned
    "
    ^ aValue isNumber ifTrue:[aValue asFloat] ifFalse:[aBlock value]
!

unsignedIntegerFrom:aValue onError:aBlock
    "converts something to an unsigned integer, on error the result of the block is returned
    "
    |v|

    aValue isNumber ifTrue:[
        v := aValue isInteger ifTrue:[aValue] ifFalse:[(aValue asFloat) rounded].       "/ no fractions

        v >= 0 ifTrue:[ ^ v ]
    ].
    ^ aBlock value
! !

!GraphColumnView methodsFor:'initialization'!

create
    "set color on device"

    super create.

    fgColor        := (fgColor        ? DefaultForegroundColor) onDevice:device.
    bgColor        := (bgColor        ? DefaultBackgroundColor) onDevice:device.
    gridColor      := (gridColor      ? DefaultGridColor)       onDevice:device.
    referenceColor := (referenceColor ? DefaultReferenceColor)  onDevice:device.
!

destroy
    "remove dependencies
    "
    super destroy.

    listHolder         removeDependent:self.
    referenceHolder    removeDependent:self.
    windowSizeHolder   removeDependent:self.
    zoomYHolder        removeDependent:self.
    graphOriginXHolder removeDependent:self.

    columns notNil ifTrue:[
        columns do:[:aCol| aCol removeDependent:self ]
    ].

!

initialize
    "setup default values
    "
    super initialize.

    DefaultGridColor isNil ifTrue:[
        self class updateStyleCache
    ].

    references     := OrderedCollection new.
    windowSize     := 101.
    showGrid       := false.
    showReferences := true.
    zoomY          := 1.
    graphOriginX   := 1.
    scrollUpdatesOriginX := false.
! !

!GraphColumnView methodsFor:'menu & submenus'!

defaultMenu
    "returns the default middle button menu provided by the graph
    "
    |menu|

    menu := self class defaultMenu decodeAsLiteralArray.

    menu notNil ifTrue:[
        menu receiver:self
    ].
    ^ menu
!

doZoomY:aValue
    "triggered by the default menu to change the current zoom Y factor;
     on change, the corresponding model (zoomYHolder) is updated.
    "
    |old|

    old := self zoomY.
    self zoomY:aValue.

    self zoomYHolder notNil ifTrue:[
        zoomYHolder value:(self zoomY)
    ]
!

subMenuZoomY
    "returns the submenu to configure the zoom Y factor
    "
    ^ GraphColumn zoomMenuSelector:#doZoomY:


! !

!GraphColumnView methodsFor:'protocol'!

doInvalidateGraph
    "called to set the graph to invalidate
    "
    self doRecomputeGraph
!

doRecomputeGraph
    "called to recompute drawable objects and to set the
     graph to invalidate
    "
!

updateColumns:what with:oldValue from:aColumn
    "called if the list of columns changed
         #size      the size of the columns
         #color:    color changed
     or a specific column:( aColumn notNil )
         #insert:   insert a new column
         #remove:   remove a column

        or a specific attribute derived from the
        changed column.
    "
    self doRecomputeGraph

!

updateGrid:what
    "called if the grid changed
     #color     the color of the grid changed
     #state     the visibility state of the grid changed
    "
    self doRecomputeGraph
!

updateOriginX:aDeltaX
    "graph origin X changed; scroll n steps left (aDeltaX < 0) or right (aDeltaX > 0)
    "
    self doRecomputeGraph
!

updateReferences:what atRelX:aRelX
    "called when the list of references changed.
        #remove:        the reference at the relative X index is removed
        #insert:        a reference is inserted at the relative X index
        #size           the list of references changed
        #state          visibility state changed
        #color          the foreground color changed
    "
    self doRecomputeGraph
! !

!GraphColumnView methodsFor:'queries'!

listOfVisibleColumns
    "returns a list of visible lines (never nil)
    "
    ^ columns notNil ifTrue:[ columns select:[:c| c shown] ] ifFalse:[ #() ]


!

listOfVisibleRefIndices
    "returns a list of visible reference line indices or an empty
     collection (nothing defined or disabled).
    "
    |list winSz x|

    (showReferences and:[references notEmpty]) ifFalse:[
        ^ #()
    ].
    winSz := self windowSize.
    list  := OrderedCollection new.

    referenceSelector isNil ifTrue:[
        references do:[:aReference|
            x := aReference - graphOriginX.
            (x >= 0 and:[x < winSz]) ifTrue:[ list add:x ]
        ]
    ] ifFalse:[        
        references do:[:aReference|
            x := (aReference perform:referenceSelector) - graphOriginX.
            (x >= 0 and:[x < winSz]) ifTrue:[ list add:x ]
        ]
    ].
    ^ list
!

visibleReference:aReference do:aOneArgBlock
    "evaluate the block with the relative visible X value; if the reference line
     is not visible, nothing will happen
    "
    |x|

    referenceSelector isNil ifTrue:[ x := aReference ]
                           ifFalse:[ x := aReference perform:referenceSelector ].

    ((x := x - graphOriginX) >= 0 and:[x < self windowSize]) ifTrue:[
        aOneArgBlock value:x
    ]
! !

!GraphColumnView methodsFor:'scrolling'!

halfWindowSizeLeft
    "scroll left half window size
    "
    self scrollLeft:(windowSize // 2)

!

halfWindowSizeRight
    "scroll right half window size
    "
    self scrollRight:(windowSize // 2)

!

scroll:nIndices
    "scroll left or right n x-steps. a positive value scrolls to the right
     a negative value to the left.
    "
    |max|

    nIndices ~~ 0 ifTrue:[
        scrollUpdatesOriginX ifTrue:[
            graphOriginX := graphOriginX - nIndices
        ].

        shown ifTrue:[
            max := 2 * (windowSize // 3).

            (nIndices abs) > max ifTrue:[
                self doRecomputeGraph           "/ full redraw
            ] ifFalse:[
                self updateOriginX:nIndices     "/ scroll
            ]
        ]
    ].
!

scrollLeft:nIndices
    "scroll n indices left
    "
    self scroll:(nIndices negated)

!

scrollRight:nIndices
    "scroll n indices right
    "
    self scroll:nIndices

!

windowSizeLeft
    "scroll left window size
    "
    self scrollLeft:windowSize

!

windowSizeRight
    "scroll right window size
    "
    self scrollRight:windowSize

! !

!GraphColumnView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

