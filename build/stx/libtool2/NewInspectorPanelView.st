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
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Tools }"

SimpleView subclass:#NewInspectorPanelView
	instanceVariableNames:'frames labelViews listViews scrollBar maxDepth leftHistory
		rightHistory hzpView actionBlock valueChangedAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-NewInspector'
!

!NewInspectorPanelView class methodsFor:'documentation'!

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

examples
"
    example 1
    =========

									[exBegin]
    |top slv|

    top := StandardSystemView new extent:600@400.
    slv := Tools::NewInspectorPanelView origin:0.0@0.0 corner:1.0@1.0 in:top.
    slv inspect:top.
    slv action:[:el|Transcript showCR:el].
    top open.
									[exEnd]


    example 2
    =========
									[exBegin]
    |top slv edt a vvp|

    a := Array new:5.
    a at:4 put:(Array new:6).

    top := StandardSystemView new extent:600@400.
    vvp := VariableVerticalPanel origin:0.0@0.0  corner:1.0@1.0 in:top.

    slv := Tools::NewInspectorPanelView origin:0.0@0.0 corner:1.0@0.5 in:vvp.
    edt := Workspace origin:0.0 @ 0.5 corner:1.0 @ 1.0 in:vvp.
    edt acceptAction:[:theText|slv accept:theText notifying:edt].
    edt   doItAction:[:theCode|slv doIt:theCode   notifying:edt].

    slv action:[:el| Transcript showCR:(el printString)].
    slv inspect:a.

    top open.
									[exEnd]
"
! !

!NewInspectorPanelView class methodsFor:'constants'!

minDepth
    "returns the minimum of views assigned to a panel
    "
    ^ 4
! !

!NewInspectorPanelView methodsFor:'accessing'!

depth
    "returns number of listViews
    "
  ^ listViews size
!

depth:aDepth
    "change the number of existing listViews
    "
    |sz min|

    min := self class minDepth.

    aDepth > min ifTrue:[
	sz := aDepth min:maxDepth.

	sz < listViews size ifTrue:[
	    sz := listViews size
	]
    ] ifFalse:[
	sz := min
    ].

    listViews size == sz ifTrue:[
	sz == aDepth ifFalse:[self moveContentsLeft:1].
    ] ifFalse:[
	[self createViewWithoutRedraw. listViews size ~~ sz] whileTrue.
	self computeExtentOfFrames.

	(self topView shown) ifTrue:[
	    hzpView sizeChanged:nil.
	    hzpView realizeAllSubViews.
	]
    ]
!

maxDepth
    ^ maxDepth
!

maxDepth:aNumber
    "change max depth for instance
    "
    aNumber > listViews size ifTrue:[
	aNumber >= (self class minDepth) ifTrue:[
	    maxDepth := aNumber.

	    maxDepth < listViews size ifTrue:[
		self depth:maxDepth
	    ]
	]
    ]
! !

!NewInspectorPanelView methodsFor:'accessing actions'!

action:aOneArgBlock
    "set the single click action block.
     If non-nil, that one is evaluated on single click, passing the
     selected instance as argument
    "
    actionBlock := aOneArgBlock


!

valueChangedAction:aOneArgBlock
    "evaluated if an instnace changed its value; passing
     the instance as argument
    "
    valueChangedAction := aOneArgBlock
! !

!NewInspectorPanelView methodsFor:'accessing selections'!

inspectedObject
    "returns the current inspected object
    "
    ^ self findLastValidListWithSelection inspectedObject
!

selectedInstanceVar
    "returns the current selected instance var
    "
    ^ self findLastValidListWithSelection selectedInstanceVar
! !

!NewInspectorPanelView methodsFor:'actions'!

accept:aText notifying:aView
    "evaluating aText on the last selected instance var. on success the views
     are updated.
    "
    self doItOrAccept:[:aList|aList accept:aText notifying:aView]
!

doIt:aCode notifying:aView
    "evaluating aCode on the selected instance var; on success the views
     are updated.
    "
    ^ self doItOrAccept:[:aList|aList doIt:aCode notifying:aView]
!

inspect:anObject
    "change the inspected object and all views
    "
    |view|

    view := listViews first.
    leftHistory  removeAll.
    rightHistory removeAll.

    view inspect:anObject.
    listViews from:2 do:[:v|v inspect:nil].
    self update.
! !

!NewInspectorPanelView methodsFor:'event handling'!

handlesKeyPress:key inView:someView
    "all keys are handled by this instance itself
    "
    ^ true

!

keyPress:key x:x y:y view:someView
    "handle some special keys
    "
    key == #CursorLeft  ifTrue:[^ self moveContentsRight:1].
    key == #CursorRight ifTrue:[^ self moveContentsLeft:1 ].

    someView keyPress:key x:x y:y.

!

singleClickAt:anIndex
    "the view at an index changed its selection caused by a single click
    "
    |view start sivar|

    rightHistory removeAll.

    view  := listViews at:anIndex.
    start := anIndex + 1.
    sivar := view selectedInstanceVar.

    start > listViews size ifTrue:[
	start >= maxDepth ifTrue:[
	    self moveContentsLeft:1.
	  ^ actionBlock value:sivar.
	].
    ].

    (view selectedInstanceType) == #directory ifTrue:[
	(listViews at:start) setSelection:nil.
	(listViews at:start) inspect:sivar.

	start := start + 1.
    ].

    listViews from:start do:[:v|v inspect:nil].
    self update.
    actionBlock value:sivar.
! !

!NewInspectorPanelView methodsFor:'initializing'!

initialize
    "initialize instance
    "
    super initialize.

    frames       := OrderedCollection new.
    listViews    := OrderedCollection new.
    labelViews   := OrderedCollection new.
    leftHistory  := OrderedCollection new.
    rightHistory := OrderedCollection new.
    maxDepth     := self class minDepth.

    actionBlock := [:el| ].

    hzpView    := VariableHorizontalPanel origin:0.0@0.0 corner:1.0@1.0 in:self.
    scrollBar  := HorizontalScrollBar origin:0.0@1.0 corner:1.0@1.0 in:self.
    "/ scrollBar asynchronousOperation.

    hzpView bottomInset:(scrollBar preferredExtent y).

    scrollBar topInset:(scrollBar preferredExtent y) negated.
    scrollBar thumbHeight:100.
    scrollBar scrollAction:[:percent | self scrollTo:percent].
    scrollBar scrollRightAction:[self moveContentsLeft:1].
    scrollBar scrollLeftAction:[self moveContentsRight:1].

    self depth:maxDepth.
! !

!NewInspectorPanelView methodsFor:'menu - labels & actions'!

browse:anIndex
    self classAtLabel:anIndex do:[:cls| cls browserClass openInClass:cls selector:nil ]

!

browseClassHierarchy:anIndex
    self classAtLabel:anIndex do:[:cls| cls browserClass browseClassHierarchy:cls ]

!

browseFullClassProtocol:anIndex
    self classAtLabel:anIndex do:[:cls| cls browserClass browseFullClassProtocol:cls ]

!

classAtLabel:anIndex do:anAction
    "evaluate action on class assigned to label
    "
    |cls|

    anIndex <= labelViews size ifTrue:[
	(cls := Smalltalk classNamed:((labelViews at:anIndex) label)) notNil ifTrue:[
	    anAction value:cls
	]
    ]

!

labelMenu
    "popup menu required by any label. Delegate the request to the corresponding label
    "
    |sqNr view|

    view := (WindowGroup lastEventQuerySignal query) view.
    sqNr := labelViews findFirst:[:v| v == view].

    sqNr ~~ 0 ifTrue:[
	view := labelViews at:sqNr.

	view label notEmpty ifTrue:[
	    ^ self labelMenu:sqNr
	]
    ].
    ^ nil
!

labelMenu:anIndex
    "popup menu required for a label identified by its sequence number
    "
    |menu|

    menu := PopUpMenu labels:#(
			      'browse'
			      'browse class hierarchy'
			      'browse full class protocol'
			      )
		   selectors:#(
			      browse:
			      browseClassHierarchy:
			      browseFullClassProtocol:
			      )
		    receiver:self.

   menu args:(Array new:(menu labels size) withAll:anIndex).
 ^ menu

! !

!NewInspectorPanelView methodsFor:'menu - views & actions'!

doTrace:anInstance
    "place a trace on messages sent to the instance
    "
    |selectors|

    selectors := self messageMenu:anInstance.

    selectors notNil ifTrue:[
	self topView withWaitCursorDo:[MessageTracer trace:anInstance selectors:selectors]
    ].

!

doTraceAll:anInstance
    "place a trace on all messages sent to the instance
    "
    self topView withWaitCursorDo:[MessageTracer traceAll:anInstance]
!

doTrap:anInstance
    "place a trap on a message sent to the instance
    "
    |selectors|

    selectors := self messageMenu:anInstance.

    selectors notNil ifTrue:[
	self topView withWaitCursorDo:[MessageTracer trap:anInstance selectors:selectors]
    ]
!

doTrapAll:anInstance
    "place a trap on all messages sent to the instance
    "
    self topView withWaitCursorDo:[MessageTracer trapAll:anInstance]

!

doUntrace:anInstance
    "remove all traps and traces to the instance
    "
    self topView withWaitCursorDo:[MessageTracer untrace:anInstance].

!

messageMenu:anInstance
    "open menu to select messages; on accepted a list of messages is returned
    "
    |sll acl lst inset top hzp slv acv dblClcAct btp b1 b2 accepted viewSpacing|

    top := StandardSystemView new.
    top extent:500 @ 400.
    top label:(anInstance printString).

    (Label origin:(0.0 @  0.0) corner:(0.5 @ 20) in:top) label:'messages'.
    (Label origin:(0.5 @  0.0) corner:(1.0 @ 20) in:top) label:'selected'.
    hzp := VariableHorizontalPanel origin:(0.0 @ 20) corner:(1.0 @ 1.0) in:top.
    btp := HorizontalPanelView origin:(0.0 @1.0) corner:(1.0 @ 1.0) in:top.

    b1 := Button abortButtonIn:btp.
    b2 := Button okButtonIn:btp.
    accepted := false.

    b1 action:[accepted := false. top destroy].
    b2 action:[accepted := true.  top destroy].

    btp horizontalLayout:#fitSpace.
    viewSpacing := top class viewSpacing.
    inset       := (b2 preferredExtent y) + viewSpacing.
    viewSpacing := viewSpacing // 2.

    hzp bottomInset:inset.
    btp topInset:((inset - viewSpacing) negated).
    btp bottomInset:viewSpacing.

    slv := ScrollableView for:SelectionInListView
		miniScrollerV:true
		       origin:(0.0 @ 0.0)
		       corner:(0.5 @ 1.0)
			   in:hzp.

    acv := ScrollableView for:SelectionInListView
		miniScrollerV:true
		       origin:(0.5 @ 0.0)
		       corner:(1.0 @ 1.0)
			   in:hzp.

    slv := slv scrolledView.
    acv := acv scrolledView.

    sll := (MessageTracer realClassOf:anInstance) selectors.
    acl := OrderedCollection new.

    (MessageTracer wrappedSelectorsOf:anInstance) do:[:el|
	el notNil ifTrue:[
	    acl add:el.
	    sll remove:el ifAbsent:nil
	]
    ].

    slv list:(sll copy).
    acv list:(acl copy).

    dblClcAct := [:from :to|
	to add:(from selectionValue).
	from removeIndex:(from selection).
	from redraw.
    ].

    slv doubleClickAction:[:index| dblClcAct value:slv value:acv].
    acv doubleClickAction:[:index| dblClcAct value:acv value:slv].

    top openModal.

    accepted ifFalse:[
	^ nil
    ].
    lst := acv list.

"undo existing traps            HACK: removes traps and traces"

    acl notEmpty ifTrue:[
	MessageTracer untrace:anInstance
    ].

    lst notEmpty ifTrue:[^ lst]
		ifFalse:[^ nil]
!

viewMenu
    "popup menu required by any view. Delegate the request to the corresponding view
    "
    |sqNr view|

    view := (WindowGroup lastEventQuerySignal query) view.
    sqNr := listViews findFirst:[:v| v == view].

    sqNr notNil ifTrue:[^ self viewMenu:sqNr]
	       ifFalse:[^ nil]
!

viewMenu:anIndex
    "popup menu required for a view identified by its sequence number
    "
    |view menu inst args lbls|

    view := listViews at:anIndex.
    view hasSelection ifFalse:[^ nil].
    inst := view selectedInstanceVar.

    menu := PopUpMenu labels:#( 'update' )
		   selectors:#( #update  )
		    receiver:self.

    menu actionAt:#update put:[
	view update.

	listViews from:(anIndex + 1) do:[:v|
	    (view selectedInstanceType) ~~ #directory ifTrue:[
		v inspect:nil
	    ] ifFalse:[
		v inspect:(view selectedInstanceVar).
		view := v.
	    ]
	].
	self update
    ].

    (NewInspectorList isTraceable:inst) ifFalse:[
	^ menu
    ].

    menu  addLabels:#(
		      '-'
		      'trace'
		      'trap'
		      'untrace / untrap'
		     )
	  selectors:#(
		      nil
		      trace
		      trap
		      untrace
		     ).

    menu actionAt:#untrace put:[self doUntrace:inst].

    args := Array new:2 withAll:inst.
    lbls := Array with:'message'
		  with:((Text string:' all ' emphasis:#underline), ' messages').

    menu subMenuAt:#trace put:(
	PopUpMenu labels:lbls selectors:#(doTrace: doTraceAll:) args:args
    ).

    menu subMenuAt:#trap put:(
	PopUpMenu labels:lbls selectors:#(doTrap: doTrapAll:) args:args
    ).

  ^ menu


! !

!NewInspectorPanelView methodsFor:'private'!

doItOrAccept:aBlock
    "handle a doIt or accept action; on success all the folloed views are
     updated
    "
    |index list result instVar|

    list    := self findLastValidListWithSelection.
    result  := aBlock value:list.
    instVar := list selectedInstanceVar.
    index   := listViews findLast:[:v|v == list].

    (index ~~ 0 and:[index ~~ listViews size]) ifTrue:[
	index := index + 1.
	(list selectedInstanceType) == #directory ifTrue:[
	    (listViews at:index) inspect:instVar
	] ifFalse:[
	    (listViews at:index) inspect:nil
	].
	self update
    ].
    valueChangedAction notNil ifTrue:[
	valueChangedAction value:instVar
    ].
    ^ result
!

findLastValidListWithSelection
    "returns last valid list with a selection; if no selection exists in any
     view, the list assigned to the inspected object is returned
    "
    |index|

    rightHistory notEmpty ifTrue:[
	^ rightHistory first
    ].
    index := listViews findLast:[:v| v hasSelection ].

    index ~~ 0 ifTrue:[
	^ listViews at:index
    ].

    leftHistory notEmpty ifTrue:[^ leftHistory last]
			ifFalse:[^ listViews at:1]
!

update
    "update labels and scrollbar
    "
    |pview cview stop index ispObj label|

"UPDATE LABELS
"
    index := 1.
    stop  := listViews size.

    [   cview  := listViews at:index.
	ispObj := cview inspectedObject.
	label  := labelViews at:index.
	index  := index + 1.

	ispObj notNil ifTrue:[
	    label label:(ispObj class name asString).
	    pview := cview.
	] ifFalse:[
	    [index <= stop] whileTrue:[
		(labelViews at:index) label:''.
		index := index + 1
	    ].

	    (pview isNil or:[pview selectedInstanceType == #normal]) ifTrue:[
		pview notNil ifTrue:[ispObj := pview selectedInstanceVar].
		label label:ispObj class name asString
	    ] ifFalse:[
		label label:''
	    ]
	].
	index > stop

    ] whileFalse.

"UPDATE SCROLLBARS
"
    index := listViews size + leftHistory size + rightHistory size.

    (listViews last) selectedInstanceType notNil ifTrue:[
	index := index + 1
    ].
    scrollBar thumbHeight:(stop / index) * 100.
    scrollBar thumbOrigin:(100  / index * leftHistory size).

! !

!NewInspectorPanelView methodsFor:'private frames'!

computeExtentOfFrames
    "compute the extent of all frames (origin/corner)
    "
    |orig corn offset newX|

    orig := ( 0.0 @ 0.0 ).
    corn := ( 0.0 @ 1.0 ).

    offset := 1.0 / (frames size).
    newX   := 0.0.

    frames do:[:frame|
	(newX := newX + offset) > 1.0 ifTrue:[ newX := 1.0 ].
	corn  := newX @ corn y.
	frame origin:orig corner:corn.
	orig  := newX @ orig y.
    ].


!

createViewWithoutRedraw
    "add a new view at end of the panel
    "
    |view frame label index|

    frame := SimpleView in:hzpView.

    label := Label origin:0.0@0.0 corner:1.0@20 in:frame.
    label  leftInset:15.
    label rightInset:2.

    view  := ScrollableView for:NewInspectorListView miniScroller:true origin:0.0@20
			 corner:1.0@1.0 in:frame.

    view := view scrolledView.

    frames add:frame.
    labelViews add:label.
    listViews  add:view.

    index := listViews size.

    index == 1 ifTrue:[
	view includesSelf:true
    ].

    label adjust:#left.
    label label:''.
    label level:1.
    label menuHolder:self; menuMessage:#labelMenu; menuPerformer:self.

    view action:[:el|self singleClickAt:index].

    view delegate:self.
    view menuHolder:self; menuMessage:#viewMenu; menuPerformer:self.

! !

!NewInspectorPanelView methodsFor:'scrolling-basic'!

moveContentsLeft:nTimes
    "move the contents of all views one position left
    "
    |fView stop pView index|

    (nTimes < 1 or:[listViews last isEmpty]) ifTrue:[
	^ self
    ].

    index := nTimes.
    stop  := (listViews size) - 1.
    fView := listViews first.
    pView := listViews at:stop.


    [   leftHistory add:(fView list).

	1 to:stop do:[:i|
	    (listViews at:i) list:(listViews at:(i+1))
	].

	rightHistory notEmpty ifTrue:[
	    (listViews last) list:(rightHistory removeLast)
	] ifFalse:[
	    (listViews last) inspect:(pView selectedInstanceVar)
	].
	((index := index - 1) == 0 or:[listViews last isEmpty])

    ] whileFalse.

    self update.



!

moveContentsRight:nTimes
    "move the contents of all views one position right
    "
    |size index lView fView|

    size := leftHistory size.

    (nTimes > 0 and:[size ~~ 0]) ifTrue:[
	nTimes > size ifFalse:[index := nTimes]
		       ifTrue:[index := size].

	size  := listViews size.
	lView := listViews last.
	fView := listViews first.

	1 to:index do:[:i|
	    lView hasSelection ifTrue:[
		rightHistory add:(lView list)
	    ].
	    size to:2 by:-1 do:[:i|
		(listViews at:i) list:(listViews at:(i-1))
	    ].
	    fView list:(leftHistory removeLast)
	].
	self update
    ]

!

scrollTo:nPercent
    "set views and contents dependant on scroll bar
    "
    |dY no noScr pR|

    noScr := listViews size + leftHistory size + rightHistory size.

    (listViews last) selectedInstanceType notNil ifTrue:[
	noScr := noScr + 1
    ].
    dY := 100 / noScr.
    pR := nPercent roundTo:dY.

    no := ((dY * leftHistory size) - pR) / dY.

    no == 0 ifTrue:[
	(nPercent - pR) > 0 ifTrue:[no := -1]
			   ifFalse:[no :=  1]
    ].
    no < 0 ifTrue:[self moveContentsLeft:(no negated)]
	  ifFalse:[self moveContentsRight:no]
! !

!NewInspectorPanelView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
