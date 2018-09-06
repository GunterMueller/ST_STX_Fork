"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

GraphColumnView subclass:#GraphColumnView2D
	instanceVariableNames:'colorMap gridXoffset gridX gridY actionBlock doubleClickBlock
		buttonReleaseBlock menuAccessBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Graphs'
!

!GraphColumnView2D class methodsFor:'documentation'!

documentation
"
    The class provides all the functionality for showing, scrolling and manipulating graphs
    described through to a GraphColumn description. Each change in a graph description
    immediately take affect.


    [See also:]
	GraphColumn
	GraphColumnView
	GraphColumnView3D

    [Author:]
	Claus Atzkern
"


! !

!GraphColumnView2D class methodsFor:'defaults'!

gridStep
    ^ 8
! !

!GraphColumnView2D class methodsFor:'examples'!

test0
    "testing references and actions

     start with:
         self test0
    "
    |top col view x|

    top  := StandardSystemView extent:800 @ 400.
    view := GraphColumnView2D origin:0@0 extent:1.0@1.0 in:top.

    top label:'2D-View'.

    col := GraphColumn name:' sqrt(x) '.
    col relativeXaxis:0.5.
    col lineStyle:#solid.

    col hLineStyle:#dashed.
    col hLineList:#( 0 ).
    col scaleY:40.

    col functionYblock:[:start :array|
        x := 0.001.
        1 to:(array size) do:[:i| array at:i put:(x ln - (0.1*x)). x := x + 0.1 ].
        array
    ].

    view showDefaultMenu:true.
    view showGrid:true.
    view columns:{ col }.
    top openAndWait.
!

test1
    "testing references and actions

     start with:
	 self test1
    "
    |top list view x|

    top  := StandardSystemView extent:800 @ 400.
    view := GraphColumnView2D origin:0@0 extent:1.0@1.0 in:top.
    list := OrderedCollection new.

    top label:'2D-View'.

    #( 0.25 0.5 0.75 ) keysAndValuesDo:[:aKey :xAxis||aCol|
	aCol := GraphColumn name:aKey.
	aCol relativeXaxis:xAxis.

	xAxis ~= 0.5 ifTrue:[
	    xAxis < 0.5 ifTrue:[
		aCol foregroundColor:(Color red).
	    ] ifFalse:[
		aCol foregroundColor:(Color blue).
		aCol lineStyle:#dashed
	    ]
	].
	aCol hLineStyle:#dashed.
	aCol hLineList:#( 0 ).
	aCol scaleY:40.

	aCol functionYblock:[:start :array|
	    x := (start - 1) * 0.2.
	    1 to:(array size) do:[:i| array at:i put:(x sin). x := x + 0.2 ].
	    array
	].
	list add:aCol.
    ].

    view action:[:column :indexX :deltaY|
	Transcript showCR:'SINGLE CLICK:'.

	Transcript showCR:' column: ', column printString,
			  ' indexX: ', indexX printString,
			  ' deltaY: ', deltaY printString.

	view referenceAdd:indexX
    ].

    view doubleClickAction:[:column :indexX :deltaY|
	Transcript showCR:'DOUBLE CLICK:'.

	Transcript showCR:' column: ', column printString,
			  ' indexX: ', indexX printString,
			  ' deltaY: ', deltaY printString.
    ].
    view showDefaultMenu:true.
    view showGrid:true.
    view columns:list.
    top openAndWait.



!

test2
    "testing models and change notifications

     start with:
	 self test2
    "
    |top list cols listView graph red blue yellow sav pause time
     label butAct button b1 b2|

    top      := StandardSystemView extent:950 @ 400.
    listView := ListView origin:0.0@20 corner:150@1.0 in:top.
    graph    := GraphColumnView2D origin:150@0 corner:1.0@1.0 in:top.
    listView level:1.
    (Label origin:2@2 in:top) label:'Delay:'.

    time   := 0.1.
    label  := Label origin:82@1 corner:128@19 in:top.
    label sizeFixed:true.
    label label:(time printString).
    label level:1.

    butAct := [:dT| time := (time + dT) max:0.0. label label:(time printString) ].

    button := (ArrowButton leftIn:top)  origin:60@0  extent:20@20.
    button action:[butAct value:-0.05].
    button autoRepeat:true.
    button := (ArrowButton rightIn:top) origin:130@0 extent:20@20.
    button action:[butAct value:0.05].
    button autoRepeat:true.


    cols     := OrderedCollection new.
    list     := List new.

    top label:'Testing 2D-View: Models & Style'.

    listView list:OrderedCollection new.
    graph showGrid:true.
    graph listHolder:list.
    top openAndWait.

    #( 0.2 0.8 ) keysAndValuesDo:[:aKey :xAxis||aCol x|
	aCol := GraphColumn name:'Column <', aKey printString, '>'.
	aCol relativeXaxis:xAxis.
	aCol hLineFgColor:(Color blue).
	aCol scaleY:40.
	aCol hLineStyle:#dashed.

	aCol functionYblock:[:start :array|
	    x := (start - 1) * 0.2.
	    1 to:(array size) do:[:i| array at:i put:(x sin). x := x + 0.2 ].
	    array
	].
	cols add:aCol.
    ].

    red    := Color red.
    blue   := Color blue.
    yellow := Color yellow lightened.

    pause  := [ |l|
	l := listView list.
	l size > 500 ifTrue:[l removeFromIndex:1 toIndex:400. listView list:l].
	listView scrollToBottom.

	(top realized and:[time > 0]) ifTrue:[Delay waitForSeconds:time] ].

    [   [top realized] whileTrue:[
	    listView add:'ADD COLUMNS'.
	    cols do:[:el|
		listView add:( '    ', el printString ).
		list add:el.
		pause value
	    ].

	    listView add:( 'GRAPH' ).
	    listView add:( '    Background' ).
	    sav := graph backgroundColor.
	    graph backgroundColor:yellow.
	    pause value.
	    graph backgroundColor:sav.
	    sav := graph foregroundColor.
	    listView add:( '    Foreground' ).
	    graph foregroundColor:blue.
	    pause value.
	    graph foregroundColor:sav.

	    listView add:( 'GRID' ).
	    listView add:( '    Grid X' ).
	    graph gridExtent:(4 @ 0).
	    pause value.
	    listView add:( '    Grid Y' ).
	    graph gridExtent:(0 @ 4).
	    pause value.
	    listView add:( '    Grid X/Y' ).
	    graph gridExtent:(8 @ 8).
	    pause value.
	    listView add:( '    Color' ).
	    sav := graph gridColor.
	    graph gridColor:yellow.
	    pause value.
	    graph gridColor:sav.
	    listView add:( '    Off' ).
	    graph showGrid:false.
	    pause value.
	    listView add:( '    On' ).
	    graph showGrid:true.

	    listView add:( 'REFERENCES' ).
	    listView add:( '    Add' ).
	    #( 7  15  43  90 ) do:[:i| graph referenceAdd:i. pause value].
	    top realized ifTrue:[Delay waitForSeconds:time].
	    sav := graph referenceColor.
	    listView add:( '    Color' ).
	    graph referenceColor:blue.
	    pause value.
	    graph referenceColor:sav.
	    listView add:( '    Remove' ).
	    #( 7  15  43  90 ) do:[:i| graph referenceRemove:i. pause value ].
	    pause value.

	    listView add:'REMOVE COLUMNS'.
	    [list notEmpty] whileTrue:[
		listView add:( '    ', list removeFirst printString ).
		pause value
	    ].
	].

    ] forkAt:1.


!

test3
    "testing models and change notifications

     start with:
	 self test3
    "
    |top list slices index view graph column actLbl tmOut button bAction tmLbl title pause toggle auto next|

    top   := StandardSystemView extent:800 @ 400.
    view  := View origin:0@0  corner:1.0@28  in:top.
    graph := GraphColumnView2D origin:0@28 corner:1.0@1.0 in:top.
    list  := OrderedCollection new.
    top label:'Testing 2D-View: Model-Column'.

    slices := #( ( foregroundColor       #color )
		 ( lineStyle             #dashed )
		 ( lineWidth             4 )

		 ( hLineFgColor          #color )
		 ( hLineStyle            #dashed )
		 ( hLineWidth            4 )
		 ( hLineList             #( -0.8  -0.5  0  0.5  0.8 ) )

		 ( shown                 false )
		 ( scaleY                10 )
		 ( transY                20 )
		 ( relativeXaxis         0.2 )
	       ).


    column := GraphColumn name:'test'.
    column relativeXaxis:0.5.
    column scaleY:40.
    column hLineList:#( -1   1 ).
    column functionYblock:[:start :array||x|
	x := (start - 1) * 0.2.
	1 to:(array size) do:[:i| array at:i put:(x sin). x := x + 0.2 ].
	array
    ].
    tmOut := 1.0.
    auto  := true.
    index := 1.
    next  := false.

    view level:1.

    toggle := CheckBox origin:0@0.0 corner:100@1.0 in:view.
    toggle label:'Auto/Step'.
    toggle turnOn.
    toggle action:[:aState|
	(next := auto := aState) ifTrue:[
	    title label:'Time: '.
	    tmLbl label:(tmOut printString).
	] ifFalse:[
	    title label:'Step: '.
	    tmLbl label:(index printString).
	]
    ].

    title := Label origin:100@0.0 corner:160@1.0 in:view.
    title adjust:#right.
    title sizeFixed:true.
    title label:'Time: '.

    bAction := [:add|
	auto ifTrue:[
	    tmOut := (tmOut + (add ifTrue:[0.1] ifFalse:[-0.1])) max:0.1.
	    tmLbl label:(tmOut printString).
	] ifFalse:[
	    add ifTrue:[
		(index := index + 1) > slices size ifTrue:[index := 1]
	    ] ifFalse:[
		(index := index - 1) < 1 ifTrue:[index := slices size]
	    ].
	    tmLbl label:(index printString).
	    next := true.
	]
    ].

    button := ArrowButton leftIn:view.
    button origin:160@0.0 corner:180@1.0.
    button autoRepeat:true.
    button pressAction:[ bAction value:false ].

    button := ArrowButton rightIn:view.
    button origin:181@0.0 corner:201@1.0.
    button autoRepeat:true.
    button pressAction:[ bAction value:true ].

    tmLbl := Label origin:202 @0.0 corner:230@1.0 in:view.
    tmLbl adjust:#center.
    tmLbl sizeFixed:true.
    tmLbl label:(tmOut printString).

    actLbl := Label origin:230 @0.0 corner:290@1.0 in:view.
    actLbl sizeFixed:true.
    actLbl adjust:#right.
    actLbl label:'Action: '.

    actLbl := Label origin:290 @0.0 corner:1.0@1.0 in:view.
    actLbl adjust:#left.
    view subViews do:[:v| v verticalInset:2 ].

    graph gridExtent:( 4 @ 4 ).
    graph showDefaultMenu:true.
    graph listHolder:(Array with:column).
    top   openAndWait.

    pause := [
	auto ifTrue:[
	    top realized ifTrue:[Delay waitForSeconds:tmOut]
	] ifFalse:[
	    next := false.

	    [(next not and:[top realized])] whileTrue:[
		Delay waitForSeconds:0.2
	    ]
	]
    ].

    [   |sav rsl wsl arg dsc|

	[top realized] whileTrue:[

	    dsc := slices at:index.

	    auto ifTrue:[
		(index := index + 1) > slices size ifTrue:[
		    index := 1
		]
	    ].
	    rsl := dsc at:1.
	    wsl := (rsl, ':') asSymbol.
	    (arg := dsc at:2) == #color ifTrue:[arg := Color red].
	    sav := column perform:rsl.

	    actLbl label:wsl printString, ' ', arg printString.
	    column perform:wsl with:arg.
	    pause value.
	    column perform:wsl with:sav.
	]

    ] forkAt:1.


!

testRun
    "running view

     start with:
	 self testRun
    "
    |top list view step x offs time lblX lblT lblC cbox halt xOrigin|

    halt := false.
    top  := StandardSystemView extent:800 @ 400.
    view := GraphColumnView2D origin:0@20 extent:1.0@1.0 in:top.
    cbox := CheckBox origin:0@0.0 corner:50@20 in:top.
    cbox label:'Stop'.
    cbox action:[:v| halt := v].
    xOrigin := 1 asValue.

    lblX := Label origin:100@0.0 corner:0.4@20 in:top.
    lblT := Label origin:0.4@0.0 corner:0.7@20 in:top.
    lblC := Label origin:0.7@0.0 corner:1.0@20 in:top.
    lblX level:1. lblX adjust:#left.
    lblT level:1. lblT adjust:#left.
    lblC level:1. lblC adjust:#left.
    offs := 0.
    step := 2.
    list := OrderedCollection new.

    top label:'Testing 2D-View: Performance Test'.

    #( 0.25 0.5 0.75 ) do:[:xAxis||aCol|
	aCol := GraphColumn new.
	aCol relativeXaxis:xAxis.
	xAxis ~= 0.5 ifTrue:[
	    xAxis < 0.5 ifTrue:[aCol foregroundColor:(Color red)]
		       ifFalse:[aCol foregroundColor:(Color blue)]
	].
	aCol hLineStyle:#dashed.
	aCol hLineList:#( 0 ).
	aCol scaleY:40.

	aCol functionYblock:[:start :array|
	    x := start * 0.2.
	    1 to:(array size) do:[:i| array at:i put:(x sin). x := x + 0.2 ].
	    array
	].
	list add:aCol.
    ].
    view showGrid:true.
    view gridExtent:(4 @ 4).
    view columns:list.
    view windowSize:50.
    view scrollUpdatesOriginX:true.
    view graphOriginXHolder:xOrigin.

    top openAndWait.

    [   |tm total inc|
	inc := 0.
	total := 0.

	[top realized] whileTrue:[
	    halt ifFalse:[
		lblX label:('X-Offset:    ', view graphOriginX printString).
		lblT label:('Total Time:    ', (total // 1000) printString, '::', (total \\ 1000) printString ).
		lblC label:('Runs:    ', inc printString).

		tm := Time millisecondsToRun:[
		    xOrigin value:(xOrigin value + step)
		].
		inc := inc + 1.
		total := total + tm.
	   ] ifTrue:[
		Delay waitForSeconds:0.2
	   ]
	]

    ] forkAt:1.
! !

!GraphColumnView2D class methodsFor:'menu'!

defaultMenu
    "this window spec was automatically generated by the ST/X MenuEditor"

    "do not manually edit this - the builder may not be able to
     handle the specification if its corrupted."

    "
     MenuEditor new openOnClass:GraphColumnView2D andSelector:#defaultMenu
     (Menu new fromLiteralArrayEncoding:(GraphColumnView2D defaultMenu)) startUp
    "

    <resource: #menu>

    ^

       #(#Menu

	   #(
	     #(#MenuItem
		#label: 'Show Grid'
		#indication: #showGrid:
	    )
	     #(#MenuItem
		#label: 'Show References'
		#indication: #showReferences:
	    )
	     #(#MenuItem
		#label: 'Grid Extent'
		#enabled: #showGrid
		#submenu:
		 #(#Menu

		     #(
		       #(#MenuItem
			  #label: 'Extent'
			  #submenu:
			   #(#Menu

			       #(
				 #(#MenuItem
				    #label: 'larger'
				    #value: #doGridExtent:
				    #argument: #larger
				)
				 #(#MenuItem
				    #label: 'smaller'
				    #value: #doGridExtent:
				    #argument: #smaller
				)
			      ) nil
			      nil
			  )
		      )
		       #(#MenuItem
			  #label: 'X-Step'
			  #argument: #doGridStepX:
			  #submenuChannel: #gridStepMenuSelector:
		      )
		       #(#MenuItem
			  #label: 'Y-Step'
			  #argument: #doGridStepY:
			  #submenuChannel: #gridStepMenuSelector:
		      )
		    ) nil
		    nil
		)
	    )
	     #(#MenuItem
		#label: 'Zoom Y'
		#submenuChannel: #subMenuZoomY
	    )
	     #(#MenuItem
		#label: 'Print'
		#value: #doPrint
	    )
	  ) nil
	  nil
      )


!

gridStepMenuSelector:aSelector
    |menu width height item bitmap|

    menu   := Menu new.
    width  := 40.
    height := 10.

    #( off 1 2 4 8 ) do:[:aNumberOrSymbol|
	item := MenuItem labeled:(aNumberOrSymbol printString).
	item value:aSelector.
	item argument:aNumberOrSymbol.
	menu addItem:item.
    ].
  ^ menu

"
(self styleMenuSelector:#lineStyle) startUp
"


! !

!GraphColumnView2D methodsFor:'accessing actions'!

action
    "action block which is performed on a single button click.
     Number of arguments to the block can be 0 upto 4.

     argument 1: nearest column to the click point
     argument 2: the logical index (X)
     argument 3: the distance y from the click point to the columns's graph
     argument 4: physical y value
    "
    ^ actionBlock
!

action:aBlockUpTo4Args
    "action block which is performed on a single button click.
     Number of arguments to the block can be 0 upto 4.

     argument 1: nearest column to the click point
     argument 2: the logical index (X)
     argument 3: the distance y from the click point to the columns's graph
     argument 4: physical y value
    "
    actionBlock := aBlockUpTo4Args
!

buttonReleaseBlock
    "action block which is performed if the button is released; the number
     of arguments to the block can be 0 upto 3.

     argument 1: physical x value
     argument 2: physical y value
     argument 3: the logical index (X)
    "
    ^ buttonReleaseBlock
!

buttonReleaseBlock:aThreeArgAction
    "action block which is performed if the button is released; the number
     of arguments to the block can be 0 upto 3.

     argument 1: physical x value
     argument 2: physical x value
     argument 3: the logical index (X)
    "
    buttonReleaseBlock := aThreeArgAction
!

doubleClickAction
    "action block which is performed on a double button click.
     Number of arguments to the block can be 0 upto 4.

     argument 1: nearest column to the click point
     argument 2: the logical index (X)
     argument 3: the distance y from the click point to the columns's graph
     argument 4: physical y value
    "
    ^ doubleClickBlock
!

doubleClickAction:aBlockUpTo4Args
    "action block which is performed on a double button click.
     Number of arguments to the block can be 0 upto 4.

     argument 1: nearest column to the click point
     argument 2: the logical index (X)
     argument 3: the distance y from the click point to the columns's graph
     argument 4: physical y value
    "
    doubleClickBlock := aBlockUpTo4Args
!

menuAccessBlock
    "action block which is performed if a menu is required; if the block returns
     nil, the default middlebutton menu is evaluated.

     Number of arguments to the block can be 0 upto 4.

     argument 1: nearest column to the click point
     argument 2: the logical index (X)
     argument 3: the distance y from the click point to the columns's graph
     argument 4: physical y value
    "
    ^ menuAccessBlock
!

menuAccessBlock:aBlockUpTo4Args
    "action block which is performed if a menu is required; if the block returns
     nil, the default middlebutton menu is evaluated.

     Number of arguments to the block can be 0 upto 4.

     argument 1: nearest column to the click point
     argument 2: the logical index (X)
     argument 3: the distance y from the click point to the columns's graph
     argument 4: physical y value
    "
    menuAccessBlock:= aBlockUpTo4Args
! !

!GraphColumnView2D methodsFor:'accessing dimensions'!

gridExtent
    "returns the x/y extent of the grid
    "
    ^ gridX @ gridY
!

gridExtent:anExtent
    "set the x/y extent of the grid
    "
    |gX gY|

    anExtent isNil ifTrue:[
	gX := gY := 0
    ] ifFalse:[
	gX := (anExtent x) max:0.
	gY := (anExtent y) max:0.
    ].

    gridX == gX ifTrue:[
	self gridY:gY
    ] ifFalse:[
	gridY := gY.
	self gridX:gX
    ]
!

gridX
    "returns the horizontal size of the grid or 0 if the horizontal grid is disabled
    "
    ^ gridX
!

gridX:aValue
    "set the horizontal size of the grid or 0 if the horizontal grid should be invisible
    "
    |x|

    x := self unsignedIntegerFrom:aValue onError:[gridX].

    x ~~ gridX ifTrue:[
	gridX := x.
	self doRecomputeGraph.
    ]
!

gridY
    "returns the vertical size of the grid or 0 if the vertical grid is disabled
    "
    ^ gridY
!

gridY:aValue
    "set the vertical size of the grid or 0 if the vertical grid should be invisible
    "
    |y|

    y := self unsignedIntegerFrom:aValue onError:[gridY].

    y ~~ gridY ifTrue:[
	gridY := y.
	self doRecomputeGraph
    ]


! !

!GraphColumnView2D methodsFor:'change & update'!

changedGraphIn:aColumn what:what from:oldValue
    "the graph assigned to the column description changed
    "
    |widthC scaleY transY dataY stepX|

    widthC := aColumn lineWidth.
    scaleY := self scaleYofColumn:aColumn.
    transY := self transYofColumn:aColumn.
    stepX  := self stepX.
    dataY  := self yDataForColumn:aColumn.

    what == #lineWidth ifTrue:[
	widthC < oldValue ifTrue:[widthC := oldValue]
			 ifFalse:[widthC := nil]
    ] ifFalse:[
	(what ~~ #lineStyle or:[aColumn lineStyle == #solid]) ifTrue:[
	    widthC := nil
	]
    ].

    widthC notNil ifTrue:[
	self drawGRX:0
		step:stepX
	      scaleY:scaleY
	      transY:transY
	       ydata:dataY
		with:bgColor
	       style:#solid
	       width:widthC.

	what == #lineWidth ifTrue:[
	    ^ self drawX:0 y:0 width:width height:height
	]
    ].

    self drawGRC:aColumn
	       x:0
	    step:stepX
	  scaleY:scaleY
	  transY:transY
	   ydata:dataY.













!

changedHLineIn:aColumn what:what from:oldValue
    "the horizontal lines assigned to the column description changed
    "
    |widthC scaleY transY list|

    widthC := aColumn hLineWidth.
    scaleY := self scaleYofColumn:aColumn.
    transY := self transYofColumn:aColumn.

    what == #hLineList ifTrue:[
	oldValue notNil ifTrue:[list   := oldValue]
		       ifFalse:[widthC := nil].
    ] ifFalse:[
	(list := aColumn hLineList) isNil ifTrue:[
	    ^ self
	].

	what == #hLineWidth ifTrue:[
	    widthC < oldValue ifTrue:[widthC := oldValue]
			     ifFalse:[widthC := nil]
	] ifFalse:[
	    (what ~~ #hLineStyle or:[aColumn hLineStyle == #solid]) ifTrue:[
		widthC := nil
	    ]
	].
    ].

    widthC notNil ifTrue:[
	self drawHLN:list
		   x:0
		   y:0
		 toX:width
		   y:height
	      scaleY:scaleY
	      transY:transY
		with:bgColor
	       style:#solid
	       width:widthC.

	what ~~ #hLineStyle ifTrue:[
	    ^ self drawX:0 y:0 width:width height:height
	]
    ].

    self drawHLC:aColumn
	       x:0
	       y:0
	     toX:width
	       y:height
	  scaleY:scaleY
	  transY:transY.

! !

!GraphColumnView2D methodsFor:'displaying'!

displayOn:aGC
    "ST-80 Compatibility
     display the receiver in a graphicsContext at 0@0
     - this method allows for any object to be displayed in some view
       or on a printer
     (although the fallBack is to display its printString ...)
    "
    self displayOn:aGC x:0 y:0

!

displayOn:aGC at:aPoint
    "ST-80 Compatibility
     display the receiver in a graphicsContext - this method allows
     for any object to be displayed on a Printer - for example.
    "
    self displayOn:aGC x:(aPoint x) y:(aPoint y)

!

displayOn:aGC x:x y:y
    "ST-80 Compatibility
     display the receiver in a graphicsContext - this method allows
     for any object to be displayed on a Printer - for example.
    "
    |w h|

    w := aGC width  - x.
    h := aGC height - y.

    (w > 0 and:[h > 0]) ifTrue:[
	self displayOn:aGC x:x y:y w:w h:(h min:height)
    ] ifFalse:[
	self halt
    ]

!

displayOn:aGC x:x y:y w:w h:h
    |n s sX tY list yData maxX maxY oldClip oldTrans|

    oldClip  := aGC clippingRectangleOrNil.
    oldTrans := aGC transformation.

    sX := (w / (windowSize - 1)) asFloat.
    aGC transformation:(WindowingTransformation scale:1 translation:(x  @ y)).
    aGC clippingRectangle:(Rectangle left:0 top:0 width:w height:h).

    showGrid ifTrue:[
	aGC viewBackground ~= gridColor ifTrue:[
	    aGC paint:gridColor.
	] ifFalse:[
	    aGC paint:(Color green lightened)
	].

	gridX ~~ 0 ifTrue:[
	    s := gridX * self class gridStep.
	    n := 0.
	    [ n < w ] whileTrue:[ aGC displayLineFromX:n y:0 toX:n y:h. n := n + s ]
	].
	gridY > 0 ifTrue:[
	    s := gridY * self class gridStep.
	    n := 0.
	    [ n < h ] whileTrue:[ aGC displayLineFromX:0 y:n toX:w y:n. n := n + s ]
	]
    ].

    (list := self listOfVisibleRefIndices) isEmpty ifFalse:[
	aGC paint:referenceColor.

	list do:[:i||rX|
	    ((rX := (i * sX) rounded) >= 0 and:[rX <= w]) ifTrue:[
		aGC displayLineFromX:rX y:0 toX:rX y:h
	    ]
	]
    ].
    yData := Array new:((w // sX + 2) min:windowSize).
    aGC paint:fgColor.

    self listOfVisibleColumns do:[:aCol|
	tY := zoomY  * aCol zoomY.
	tY := h * (aCol relativeXaxis) / tY + (aCol transY) * tY.

	aGC transformation:(WindowingTransformation scale:(sX @ (self scaleYofColumn:aCol))
					      translation:(x  @ (y + tY))).

	(list := aCol hLineList) size ~~ 0 ifTrue:[
	    list do:[:y|
		aGC paint:(aCol hLineFgColor ? fgColor).
		aGC lineStyle:aCol hLineStyle.
		aGC lineWidth:(aCol hLineWidth).
		aGC displayLineFromX:0 y:y toX:(windowSize - 1) y:y.
	    ]
	].

	(aCol yValuesStartAt:graphOriginX into:yData) keysAndValuesDo:[:i :y|
	    yData at:i put:(i - 1 @ y)
	].
	aGC paint:(aCol foregroundColor ? fgColor).
	aGC lineStyle:aCol lineStyle.
	aGC lineWidth:(aCol lineWidth).
	aGC displayPolygon:yData.
    ].
    aGC transformation:oldTrans.
    aGC clippingRectangle:oldClip.
    aGC lineStyle:#solid.
    aGC lineWidth:0.
    aGC paint:fgColor.
    aGC displayRectangleX:x y:y width:w height:h



!

doPrint
    "print the current visible contents on the printer
    "
    |printer w h|

    (printer := Printer new) isNil ifTrue:[
	self error:'cannot open printer'.
      ^ self
    ].

    self withWaitCursorDo:[
	Printer writeErrorSignal handle:[:ex |
	    self warn:('error while printing:\\'
			, ex errorString
			, '\\(printing with: ' , (Printer printCommand) , ')') withCRs
	] do:[
	    printer setNative:true.
	    printer nextPutAll:'OriginalState setgstate'; cr.
	    printer := PSGraphicsContext on:printer origin:(0 @ 0) corner:( 1.0 @ 1.0 ).
	    w := printer width - printer rightMargin - printer leftMargin.
	    h := printer height min:height.
	    self displayOn:printer x:0 y:0 w:w h:h.
	].
	printer close
    ].



! !

!GraphColumnView2D methodsFor:'drawing'!

clearColumnAndRedraw:aColumn
    "undraw a column and redraw the view without clearing the background
    "
    shown ifTrue:[
	(self sensor hasDamageFor:self) ifTrue:[
	    self invalidate
	] ifFalse:[
	    self undrawColumn:aColumn
		       scaleY:(self scaleYofColumn:aColumn)
		       transY:(self transYofColumn:aColumn)
	]
    ]
!

redrawColumn:aColumn
    "redraw a column including the horizontal lines
     and the graph of the column
    "
    |transY scaleY stepX values|

    (shown and:[aColumn shown]) ifTrue:[
	scaleY := self scaleYofColumn:aColumn.
	transY := self transYofColumn:aColumn.
	stepX  := self stepX.

	self drawHLC:aColumn
		   x:0
		   y:0
		 toX:width
		   y:height
	      scaleY:scaleY
	      transY:transY.

	self drawGRC:aColumn
		   x:0
		step:stepX
	      scaleY:scaleY
	      transY:transY
	       ydata:(self yDataForColumn:aColumn)
    ]


!

redrawColumnAt:anIndex
    "redraw a column at an index including the horizontal lines
     and the graph of the column
    "
    self redrawColumn:(columns at:anIndex)
!

redrawX:x y:y width:w height:h
    "clear and redraw
    "
    shown ifTrue:[
	self paint:bgColor.
	self fillRectangleX:x y:y width:w height:h.
	self drawX:x y:y width:w height:h.
    ].
! !

!GraphColumnView2D methodsFor:'drawing basics'!

drawGRC:aColumn x:xStart step:xStep scaleY:yScale transY:yTrans ydata:yData
    "draw a graph
    "
    self drawGRX:xStart
	    step:xStep
	  scaleY:yScale
	  transY:yTrans
	   ydata:yData
	    with:(self mapColor:(aColumn foregroundColor))
	   style:(aColumn lineStyle)
	   width:(aColumn lineWidth)
!

drawGRX:xStart step:xStep scaleY:yScale transY:yTrans ydata:ydata with:aColor style:aStyle width:aWidth
    "draw a graph
    "
"
         self test1
"
    |xNext xLast yLast yNext|

    ydata size == 0 ifTrue:[^ self].

    self paint:aColor.
    self lineStyle:aStyle.
    self lineWidth:aWidth.

    ydata size == 0 ifTrue:[^ self].

    xLast := xStart.
    yLast := (ydata at:1) * yScale + yTrans.

    ydata from:2 do:[:y |
        xNext := xLast + xStep.
        yNext := y * yScale + yTrans.
        self displayLineFromX:xLast rounded y:yLast rounded toX:xNext rounded y:yNext rounded.
        xLast := xNext.
        yLast := yNext.
    ].
!

drawHLC:aColumn x:x y:y toX:xMax y:yMax scaleY:yScale transY:yTrans
    "draw horizontal lines derrived from column
    "
    |list|

    (list := aColumn hLineList) notNil ifTrue:[
	self drawHLN:list
		   x:x
		   y:y
		 toX:xMax
		   y:yMax
	      scaleY:yScale
	      transY:yTrans
		with:(self mapColor:(aColumn hLineFgColor))
	       style:(aColumn hLineStyle)
	       width:(aColumn hLineWidth)
    ].


!

drawHLN:aList x:x y:y toX:xMax y:yMax scaleY:yScale transY:yTrans with:aColor style:aStyle width:aWidth
    "draw horizontal lines derrived from list
    "
    self paint:aColor.
    self lineStyle:aStyle.
    self lineWidth:aWidth.

    aList do:[:hY||dY|
	dY := (hY * yScale + yTrans) rounded.

	(dY < y or:[dY > yMax]) ifFalse:[
	    self displayLineFromX:x y:dY toX:xMax y:dY.
	]
    ].
    aStyle ~~ #solid ifTrue:[self lineStyle:#solid].
    aWidth ~~ 1      ifTrue:[self lineWidth:1].


!

drawReferencesFromX:x0 y:y0 to:x1 y:y1
    "redraw visible references
    "
    |x stepX refLines|

    refLines := self listOfVisibleRefIndices.

    refLines notEmpty ifTrue:[
	stepX := self stepX.

	self paint:referenceColor.

	refLines do:[:anIndex|
	    x := (anIndex * stepX) rounded.

	    (x >= x0 and:[x <= x1]) ifTrue:[
		self displayLineFromX:x y:y0 toX:x y:y1
	    ]
	]
    ].
!

drawX:x y:y width:w height:h
    "redraw without clearing the background
    "
    |saveClip yValues xStep xStart yScale yTrans
     xIndex "{ Class:SmallInteger }"
     x0     "{ Class:SmallInteger }"
     y0     "{ Class:SmallInteger }"
     xMax   "{ Class:SmallInteger }"
     yMax   "{ Class:SmallInteger }"
     step   "{ Class:SmallInteger }"
     gstep  "{ Class:SmallInteger }"
     start  "{ Class:SmallInteger }"
     stop   "{ Class:SmallInteger }"
    |
    xStep := self stepX.
    xMax  := x + w.
    yMax  := y + h.
    x0    := x // xStep.
    start := x0 + 1.
    stop  := (xMax // xStep + 2) min:windowSize.

    start < stop ifFalse:[^ self].

    saveClip := clipRect.
    self clippingRectangle:(Rectangle left:x top:y width:w height:h).

    showGrid ifTrue:[
	self paint:gridColor.
	gstep := self class gridStep.

"/ X-Grid
	gridX ~~ 0 ifTrue:[
	    step := gridX * gstep.
	    x0 := (x // step) * step + gridXoffset.

	    [ x0 < xMax ] whileTrue:[
		self displayLineFromX:x0 y:y toX:x0 y:yMax.
		x0 := x0 + step.
	    ]
	].

"/ Y-Grid
	gridY > 0 ifTrue:[
	    step := gridY * gstep.

	    y0 := (y // step) * step.

	    [ y0 < yMax ] whileTrue:[
		self displayLineFromX:x y:y0 toX:xMax y:y0.
		y0 := y0 + step
	    ]
	]
    ].

    columns notNil ifTrue:[
	xStart  := start - 1 * xStep.
	xIndex  := start - 1 + graphOriginX.
	yValues := Array new:(stop - start + 1).

"/ Column
	columns do:[:aCol|
	    aCol shown ifTrue:[
		yScale := self scaleYofColumn:aCol.
		yTrans := self transYofColumn:aCol.

		self drawHLC:aCol x:x y:y toX:xMax y:yMax scaleY:yScale transY:yTrans.

		self drawGRC:aCol x:xStart step:xStep scaleY:yScale transY:yTrans
		       ydata:(aCol yValuesStartAt:xIndex into:yValues)
	    ]
	].

"/ V-Lines
	self drawReferencesFromX:x y:y to:xMax y:yMax.
    ].

    self clippingRectangle:saveClip.
!

undrawColumn:aColumn scaleY:scaleY transY:transY
    "undraw a column, than redraw all without clearing the background
    "
    |stepX hlines|

    stepX := self stepX.

    (hlines := aColumn hLineList) notNil ifTrue:[
	self drawHLN:hlines
		   x:0
		   y:0
		 toX:width
		   y:height
	      scaleY:scaleY
	      transY:transY
		with:bgColor
	       style:#solid
	       width:(aColumn hLineWidth)
    ].

    self drawGRX:0
	    step:stepX
	  scaleY:scaleY
	  transY:transY
	   ydata:(self yDataForColumn:aColumn)
	    with:bgColor
	   style:#solid
	   width:(aColumn lineWidth).

    self drawX:0 y:0 width:width height:height
! !

!GraphColumnView2D methodsFor:'event handling'!

buttonMultiPress:button x:x y:y
    "handle a button double click event
    "
    ((button == 1) or:[button == #select]) ifFalse:[
	^ super buttonMultiPress:button x:x y:y
    ].
    self buttonPressBlock:doubleClickBlock x:x y:y
!

buttonPress:button x:x y:y
    "handle a button press event
    "
    |menu|

    ((button == 2) or:[button == #menu]) ifTrue:[
	menu := self buttonPressBlock:menuAccessBlock x:x y:y.

	menu notNil ifTrue:[
	    ^ menu startUp
	]
    ] ifFalse:[
	((button == 1) or:[button == #select]) ifTrue:[
	    ^ self buttonPressBlock:actionBlock x:x y:y
	]
    ].

    super buttonPress:button x:x y:y
!

buttonPressBlock:aBlock x:x y:y
    "evaluate the user defined block if not nil dependent on its required
     arguments; the result of the block is returned
    "
    |numArgs desc index|

    aBlock isNil ifTrue:[
	^ nil
    ].
    (numArgs := aBlock numArgs) == 0 ifTrue:[
	^ aBlock value
    ].

    (desc := self nearestColumnAtX:x y:y) isNil ifTrue:[
	^ nil
    ].
    index := self absoluteIndexOfX:x.

    numArgs == 1 ifTrue:[ ^ aBlock value:(desc key) ].
    numArgs == 2 ifTrue:[ ^ aBlock value:(desc key) value:index ].
    numArgs == 3 ifTrue:[ ^ aBlock value:(desc key) value:index value:(desc value) ].

    ^ aBlock value:(desc key) value:index value:(desc value) value:y

!

buttonRelease:button x:x y:y
    "handle a button release event
    "
    |numArgs|

    buttonReleaseBlock isNil ifTrue:[
	^ super buttonRelease:button x:x y:y
    ].
    numArgs := buttonReleaseBlock numArgs.

    numArgs == 0 ifTrue:[ ^ buttonReleaseBlock value ].
    numArgs == 1 ifTrue:[ ^ buttonReleaseBlock value:x ].
    numArgs == 2 ifTrue:[ ^ buttonReleaseBlock value:x value:y ].

    buttonReleaseBlock value:x value:y value:(self absoluteIndexOfX:x)
! !

!GraphColumnView2D methodsFor:'initialize'!

initialize
    "setup default values
    "
    super initialize.

    gridXoffset  := 0.
    colorMap     := Dictionary new.
    gridX        := 2.
    gridY        := 2.
!

unrealize
    "clear colorMap
    "
    super unrealize.
    colorMap := Dictionary new.

! !

!GraphColumnView2D methodsFor:'private'!

mapColor:aColor
    "get the same color on the device. If the argument is
     nil, the foreground color is returned.
    "
    |fg|

    aColor isNil ifTrue:[
        ^ fgColor
    ].
    (fg := colorMap at:aColor ifAbsent:nil) isNil ifTrue:[
        colorMap at:aColor put:(fg := aColor onDevice:device)
    ].
    ^ fg
!

yDataForColumn:aColumn
    "returns collection of visible Y-data for a column
    "
    ^ aColumn yValuesStartAt:graphOriginX into:(Array new:windowSize)


! !

!GraphColumnView2D methodsFor:'protocol'!

doRecomputeGraph
    "called to recompute drawable objects and to set the graph to invalidate
    "
    gridXoffset := 0.

    shown ifTrue:[
	self invalidate.
    ]

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
    |colSY colZY colTY colRX|

    shown ifFalse:[
	^ self
    ].

    (what == nil or:[self sensor hasDamageFor:self]) ifTrue:[
	^ self invalidate
    ].

    aColumn isNil ifTrue:[
	^ self doRecomputeGraph
    ].

    what == #insert: ifTrue:[ ^ self redrawColumn:aColumn ].
    what == #remove: ifTrue:[ ^ self clearColumnAndRedraw:aColumn ].

    what == #shown ifTrue:[
	aColumn shown ifTrue:[self redrawColumn:aColumn]
		     ifFalse:[self clearColumnAndRedraw:aColumn].

	^ self
    ].

    aColumn shown ifFalse:[ ^ self ].

    (    what == #lineStyle
     or:[what == #foregroundColor
     or:[what == #lineWidth]]
    ) ifTrue:[
	^ self changedGraphIn:aColumn what:what from:oldValue
    ].

    (    what == #hLineStyle
     or:[what == #hLineFgColor
     or:[what == #hLineWidth
     or:[what == #hLineList ]]]
    ) ifTrue:[
	^ self changedHLineIn:aColumn what:what from:oldValue
    ].
    colSY := aColumn scaleY.
    colZY := aColumn zoomY.
    colTY := aColumn transY.
    colRX := aColumn relativeXaxis.

    what == #scaleY        ifTrue:[ colSY := oldValue ] ifFalse:[
    what == #transY        ifTrue:[ colTY := oldValue ] ifFalse:[
    what == #relativeXaxis ifTrue:[ colRX := oldValue ] ifFalse:[
    what == #zoomY         ifTrue:[ colZY := oldValue ] ifFalse:[ ^ self doRecomputeGraph ]]]].

    self undrawColumn:aColumn
	       scaleY:(self absScaleY:colSY zoomY:colZY)
	       transY:(self absTransY:colTY
			   relativeTo:colRX
				zoomY:colZY
		     ).



!

updateOriginX:nIndices
    "scroll left or right n x-steps. A positive value scrolls to the right
     a negative value to the left.
    "
    |
     x "{ Class:SmallInteger }"
     w "{ Class:SmallInteger }"
     gridDeltaX "{ Class:SmallInteger }"
    |

    x := (nIndices * self stepX) rounded.
    w := width - (x abs).

 "/ update offset X for the grid

    (showGrid and:[gridX ~~ 0]) ifTrue:[
	gridDeltaX  := gridXoffset + x.
	gridXoffset := gridDeltaX \\ (gridX * self class gridStep).

	gridDeltaX < 0 ifTrue:[
	    gridXoffset := gridXoffset negated
	].
    ].

 "/ scrolling & redraw

    x := x abs.

    self catchExpose.

    nIndices < 0 ifTrue:[       "/ scroll left

	self copyFrom:self x:x  y:0 toX:0 y:0 width:w height:height async:true.
	self redrawX:w y:0 width:x height:height.

    ] ifFalse:[                 "/ scroll right

	self copyFrom:self x:0  y:0 toX:x y:0 width:w height:height async:true.
	self redrawX:0 y:0 width:x height:height.
    ].
    self waitForExpose.
!

updateReferences:what atRelX:relX
    "called when the list of references changed.
	#remove:        the reference at the relative X index is removed
	#insert:        a reference is inserted at the relative X index
	#size           the list of references changed
	#state          visibility state changed
	#color          the foreground color changed
    "
    |x|

    shown ifTrue:[
	showReferences ifFalse:[
	    what == #state ifTrue:[
		self doRecomputeGraph
	    ]
	] ifTrue:[
	    (what == #color or:[what == #state]) ifTrue:[
		self drawReferencesFromX:0 y:0 to:width y:height
	    ] ifFalse:[
		(what == #insert: or:[what == #remove:]) ifTrue:[
		    x := (relX * self stepX) rounded.

		    what == #insert: ifTrue:[
			self paint:referenceColor.
			self displayLineFromX:x y:0 toX:x y:height
		    ] ifFalse:[
			self redrawX:x y:0 width:1 height:height
		    ]
		] ifFalse:[
		    self doRecomputeGraph
		]
	    ]
	]
    ]
! !

!GraphColumnView2D methodsFor:'queries'!

absoluteIndexOfX:x
    "returns the absolute X value for a visible x
    "
    ^ (x // self stepX) + graphOriginX

!

nearestColumnAtX:x y:y
    "returns an association containing the nearest column as key and the absolute y-distance
     to the point x/y. If no columns exists nil is returned
    "
    |sX dX dtY data col
     i0   "{ Class:SmallInteger }"
    |

    columns size == 0 ifTrue:[^ nil ].

    col := nil.
    sX  := self stepX.
    i0  := x // sX.

    sX > 1 ifFalse:[
	dX := 0
    ] ifTrue:[
	(dX := x - (i0 * sX)) > 0.5 ifTrue:[dX := dX / sX]
				   ifFalse:[dX := 0]
    ].
    i0 := (i0 + 1) min:windowSize.

    (i0 < windowSize and:[dX ~= 0]) ifTrue:[data := Array new:2]
				   ifFalse:[data := Array new:1].

    i0 := i0 + graphOriginX.

    columns do:[:aCol||vlY scY trY yL yR|
	aCol shown ifTrue:[
	    vlY := aCol yValuesStartAt:i0 into:data.
	    scY := self scaleYofColumn:aCol.
	    trY := self transYofColumn:aCol.
	    yL  := vlY first * scY.
	    yR  := vlY last  * scY.
	    yL  := (yL + trY + (yR - yL * dX)) rounded.
	    yR  := (y - yL) abs.

	    (col isNil or:[dtY > yR]) ifTrue:[
		dtY := yR.
		col := aCol.
	    ]
	]
    ].

    ^ col notNil ifTrue:[Association key:col value:dtY] ifFalse:[nil]

! !

!GraphColumnView2D methodsFor:'transformations'!

absScaleY:aNumber zoomY:aZoomY
    "returns y-scale for a scale Y and a zoom factor
    "
    ^ (aNumber negated) * zoomY * aZoomY
!

absTransY:aNumber relativeTo:xAxis zoomY:aZoomY
    "returns absolute transition Y for a number relative
     to a x-axis
    "
    |zY|

    zY := zoomY  * aZoomY.
  ^ height * xAxis / zY + aNumber * zY



!

scaleYofColumn:aColumn
    "returns current y-scale of a column on my view
    "
    ^ (aColumn scaleY negated) * zoomY * (aColumn zoomY)
!

stepX
    "returns width of X measured in pixels; no fraction returned
    "
    |x|

    x := width / (windowSize - 1).
  ^ x isInteger ifTrue:[x] ifFalse:[x asFloat]
!

transYofColumn:aColumn
    "returns current y-transition of a column on my view
    "
    ^ self absTransY:(aColumn transY)
	  relativeTo:(aColumn relativeXaxis)
	       zoomY:(aColumn zoomY)
! !

!GraphColumnView2D methodsFor:'user interaction & notifications'!

doGridExtent:what
    "change the grid extent factorial 2 (larger or smaller)
    "
    |ext|

    ext := self gridExtent.

    what == #larger ifTrue:[
	ext := ext * 2
    ] ifFalse:[
	what == #smaller ifFalse:[
	^ self
	].
	ext := ext // 2.
	(ext x == 0) ifTrue:[gridX ~~ 0 ifTrue:[ext x:1]].
	(ext y == 0) ifTrue:[gridY ~~ 0 ifTrue:[ext y:1]].
    ].
    self gridExtent:ext.

!

doGridStepX:aNumberOrSymbol
    "change the grid step X
    "
    self gridX:(aNumberOrSymbol == #off ifFalse:[aNumberOrSymbol] ifTrue:[0])
!

doGridStepY:aNumberOrSymbol
    "change the grid step Y
    "
    self gridY:(aNumberOrSymbol == #off ifFalse:[aNumberOrSymbol] ifTrue:[0])
! !

!GraphColumnView2D class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

