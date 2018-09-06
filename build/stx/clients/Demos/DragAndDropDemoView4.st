"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#DragAndDropDemoView4
	instanceVariableNames:'dropSource draggableObjects displayObjects
		canDropCounter dropThreshold bgActiveColor bgPassiveColor bgColor
		infoView'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

!DragAndDropDemoView4 class methodsFor:'documentation'!

documentation
"
    demonstrates the use of a DropSource and DropTarget; this is the way
    used by the GUI Builder.

    [author:]
	Claus Atzkern

    [start with:]
	CodingExamples_GUI::DragAndDropDemoView4 new open
"


! !

!DragAndDropDemoView4 methodsFor:'drag & drop - source'!

displayObjects
    "returns list of display objects
    "
    ^ displayObjects


!

draggableObjects
    "returns list of draggable objects
    "
    ^ draggableObjects

!

feedBack:aDropContext
    "called after a drop operation to have some feedback
    "
    |msg|

    aDropContext isAlienView ifTrue:[
	msg := 'Alien View'
    ] ifFalse:[
	msg := aDropContext hasDropped ifTrue:['Drop OK']
				      ifFalse:['DROP FAILED']
    ].
    self showSource:'FeedBack( ', msg, ' )'.
!

startDragFrom:aView display:something
    "start drag at center of display objects
    "
    |hdl|

    self showSource:'Start Drag'.

    canDropCounter := 0.
    hdl := DragAndDropManager new.

    hdl disabledCursor:(Image fromFile:'xpmBitmaps/cursors/no_entry.xpm').
    hdl enabledCursor:(Image fromFile:'xpmBitmaps/cursors/double_crossHair.xpm').
    "/
    "/ use same cursor as the disabled cursor
    "/
    hdl alienCursor:nil.
    "/
    "/ prepare and start the drag
    "/
    displayObjects   := something.
    draggableObjects := OrderedCollection new.

    (something isCollection not or:[something isString]) ifTrue:[
	draggableObjects add:(DropObject newText:(something printString))
    ] ifFalse:[
	something do:[:el| draggableObjects add:(DropObject newText:(el printString)) ]
    ].
    hdl startDragFrom:aView dropSource:dropSource.


! !

!DragAndDropDemoView4 methodsFor:'drag & drop - target'!

drop:aDropContext
    "drop: restore the background and perform the drop action
    "
    self setViewBackground:bgColor.
    self showTarget:'Drop'.
!

dropCanDrop:aContext
    "query from DragAndDropManager if context could be dropped
    "
    canDropCounter := canDropCounter + 1.

    ^ canDropCounter between:0 and:dropThreshold
!

dropEnter:aDropContext
    "send the first time, when entering the widget
    "
    self setViewBackground:bgActiveColor.

    aDropContext notNil ifTrue:[
	"/
	"/ otherwise the method is invoked by #dropOver:aDropContext
	"/
	self showTarget:'Enter'.
    ].
!

dropLeave:aDropContext
    "send the last time, when leaving the widget
    "
    self setViewBackground:bgColor.
    self showTarget:'Leave'.
!

dropOver:aDropContext
    "send all the time, when moveing the mouse over the widget
    "
    |msg|

    canDropCounter == 1 ifTrue:[
	self setViewBackground:bgActiveColor.
	msg := 'Enable'.
    ] ifFalse:[
	canDropCounter ~~ (dropThreshold + 1) ifTrue:[
	    canDropCounter > (2 * dropThreshold) ifTrue:[
		"/
		"/ make droppable the next #canDrop: query
		"/
		canDropCounter := 0
	    ].
	    ^ self
	].
	self setViewBackground:bgPassiveColor.
	msg := 'Disable'.
    ].
    self showTarget:'Over( ', msg, ' )'.

!

dropTarget
    "returns my drop target
    "
    ^ dropTarget
! !

!DragAndDropDemoView4 methodsFor:'initialization'!

initialize
    "setup default values
    "
    |panel|

    super initialize.
    self label:'Drag & Drop Example'.
    self extent:500 @ 500.

    infoView := EditTextView      origin:(0.0 @ 0.0) corner:(0.5 @ 0.5) in:self.
    panel    := VerticalPanelView origin:(0.5 @ 0.0) corner:(1.0 @ 0.5) in:self.

    canDropCounter := 0.
    dropThreshold  := 15.

    bgColor        := Color green lightened.
    bgActiveColor  := Color blue lightened.
    bgPassiveColor := Color yellow.

    self viewBackground:bgColor.

    dropSource := DropSource new.
    dropSource receiver:self.
    dropSource feedBackSelector:#feedBack:.
    dropSource displayObjectSelector:#displayObjects.
    dropSource dropObjectSelector:#draggableObjects.

    dropTarget := DropTarget receiver:self.
    dropTarget enterSelector:#dropEnter:.
    dropTarget  overSelector:#dropOver:.
    dropTarget leaveSelector:#dropLeave:.
    dropTarget  dropSelector:#drop:.
    dropTarget  canDropSelector:#dropCanDrop:.

    panel horizontalLayout:#fitSpace.
    panel verticalLayout:#fitSpace.

    self addDropSourcesIn:panel.
! !

!DragAndDropDemoView4 methodsFor:'private'!

addDropSourcesIn:aPanel
    "add drop sources into panel
    "
    |icon1 icon2 buttonAction addButton|

    icon1   := Image fromFile:('xpmBitmaps/QUESTION3.xpm').
    icon2   := Image fromFile:('xpmBitmaps/INFO.xpm').

    addButton := [:aLabel :displayObjects| |button|
	button := Button label:aLabel in:aPanel.
	button adjust:#left.

	button pressAction:[
	    self startDragFrom:button display:displayObjects.
	    button turnOff.
	]
    ].

    addButton value:'SINGLE   String'         value:'String'.
    addButton value:'SINGLE   Text'           value:(Text string:'Text' emphasis:#bold).
    addButton value:'SINGLE   Icon'           value:icon1.
    addButton value:'SINGLE   LabelAndIcon'   value:(LabelAndIcon icon:icon1 string:'Label & Icon').


    addButton value:'MULTI    String'         value:(Array with:'String 1'
							   with:'String 2'
						    ).

    addButton value:'MULTI    Text'           value:(Array with:(Text string:'Text 1' emphasis:#bold)
							   with:(Text string:'Text 2' emphasis:#bold)
						    ).

    addButton value:'MULTI    Icon'           value:(Array with:icon1
							   with:icon2
						    ).

    addButton value:'MULTI    LabelAndIcon'   value:(Array with:(LabelAndIcon icon:icon1 string:'Label & Icon 1')
							   with:(LabelAndIcon icon:icon2 string:'Label & Icon 2')
						    ).

    addButton value:'MIXED    Labels & Icons' value:(Array with:'String'
							   with:(Text string:'Text' emphasis:#bold)
							   with:icon1
							   with:(LabelAndIcon icon:icon2 string:'Label & Icon')
						    ).


!

setViewBackground:aColor
    "change the viewBackground to a color
    "
    self viewBackground:aColor.
    self clear.

! !

!DragAndDropDemoView4 methodsFor:'transcript'!

showCR:aMessage
    "write message to status line
    "
    infoView hideCursor.
    infoView cursorToEnd.
    infoView insertStringAtCursor:aMessage.
    infoView cursorReturn.



!

showSource:aMessage
    "write message to status line
    "
    self showCR:'>> ', aMessage, ' <<'.
!

showTarget:aMessage
    "write message to status line
    "
    self showCR:(Text string:'Target: ' emphasis:#bold), aMessage

! !

!DragAndDropDemoView4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/DragAndDropDemoView4.st,v 1.2 2006-03-21 12:28:22 cg Exp $'
! !
