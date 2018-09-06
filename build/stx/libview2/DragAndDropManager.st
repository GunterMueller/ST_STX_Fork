"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#DragAndDropManager
	instanceVariableNames:'dropContext dragView dropAction dragOffset handler restoreBlock
		alienCursor enabledCursor disabledCursor canDrop escapePressed
		passiveAction autoScrollTask disabledFlag giveFocusToTargetWidget
		notifyEndOfDropAction savedCursor'
	classVariableNames:'DragContextQuerySignal DragOriginatorQuerySignal
		DragOffsetQuerySignal ActiveDragAndDropManagers'
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

!DragAndDropManager class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG / Claus Gittinger
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
    this class provides low-level drag & drop mechanisms.

    Easy to use interface interfaces:

    A drag is usually initiated by a view or its application model,
    when a selection is moved (for example, SelectionInListView can
    be initializd to do so). 
    There, the view creates a collection of dropObjects from its selection,
    and starts the drag operation with:

        DragAndDropManager startDrag:collectionOfDragObjects from:aView.

    This easy to use interface starts a drag and also drops the collection
    into the target view.
    While dragging, a thumbsUp cursor is shown, if the view-under-the-drag
    can handle a drop, a thumbsDown is shown if not, and a question mark
    is shown for alien views (which means: we don't know).
    Alien view drop is supported (but no 'canDrop' query).

    For rubber-band line dragging, two more easy-to-use startup methods are
    provided:

        DragAndDropManager
                startLineDragIn:aView at:position
                atEnd:aFourArgEndBlock

    and:
        DragAndDropManager
                startArrowDragIn:aView at:position
                atEnd:aFourArgEndBlock

    both of the above expect a 4-arg block to be passed, which will be
    evaluated at end-drag, with the target view, its viewID, the drop position
    on the screen and within the target view as arguments.


    Expert interface:

    More control over the dragging (i.e. the drawing procedure)
    can be optained, by passing a dragBlock and an endDrag action:
        
        aDragAndDropMgr := DragAndDropManager new.
        aDragAndDropMgr dropObjects:(self collectionOfDragObjects).
        aDragAndDropMgr 
            startOpaqueDrag:[:aPoint :aView :dropObjects | 
                                self 
                                    showDragging:dropObjects
                                    in:aView 
                                    at:aPoint - (xOffset@0)
                            ]
            offset:clickOffset
            extent:saveUnderExtent
            in:self
            at:clickPoint
            atEnd:[:v :vId :posScreen :posView | ... ]

    the arguments are:
      startOpaqueDrag:
        a 3-arg block, which is evaluated by the d&d manager whenever the
        mouse moves; it is supposed to draw the dropObjects at some position
        in the passed view.

      offset:
        a clickOffset; drawing is offset by this amount

      extent:  
        a save extent; the size of the screen area that must be saved during
        the drag operation

      in:
        initiating view

      at:
        position where d&d operation starts

      atEnd:
        a 4-arg block that is evaluated when the d&d is finished.
        It gets the target view (or nil, for alien views), the targets
        view ID (needed if its an alien view), the screen position and the
        relative position within the target view of the drop as arguments.

        For internal (ST/X) views, the dropBlock should perform
        a simple canDrop:/doDrop message.

        For alien views, the Displays d&d functions can be used.


    [author:]
        Claus Gittinger

    [see also:]
        DemoView1, DemoView2, ...
        SelectionInListView FileBrowser - for a concrete example

"
!

examples
"
  a button, which initiates dragging of a file-object
  Notice that this can be dropped into the launchers panel,
  to open a fileBrowser on that directory ...
								[exBegin]
     |o top v|

     top := StandardSystemView new.
     v := Button label:'press for drag' in:top.
     v pressAction:[
		|o|
		o := DropObject newFile:('/etc').
		DragAndDropManager startDrag:o from:v.
		v turnOff
	      ].
     top openWithExtent:200@200
								[exEnd]

  initiate a drag with some offset:
								[exBegin]
     |o top v|

     top := StandardSystemView new.
     v := Button label:'press for drag' in:top.
     v pressAction:[
		|o|
		o := DropObject newFile:('.').
		DragAndDropManager startDrag:o from:v offset:10@10.
		v turnOff
	      ].
     top openWithExtent:200@200
								[exEnd]

  initiate a line drag:
								[exBegin]
     |o top v endAction|

     endAction := [ :v :vID :sPos :vPos |
		    Transcript show:'end drag in '.
		    v isNil ifTrue:[
			Transcript show:'alien view'
		    ] ifFalse:[
			Transcript show:v
		    ].
		    Transcript show:' at screen: '; show:sPos;
			       show:' in view: '; showCR:vPos
		].
     top := StandardSystemView new.
     v := Button label:'press for drag' in:top.
     v pressAction:[
		DragAndDropManager 
		    startLineDragIn:v at:10@10 atEnd:endAction.
		v turnOff
	      ].
     top openWithExtent:200@200
								[exEnd]

   more drag & drop; offset, displayObjects, ...
								[exBegin]
    |dropObj topView pannel icon buttonAction addButton|

    topView := StandardSystemView new.
    pannel  := VerticalPanelView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:topView.
    pannel  horizontalLayout:#fit.
    pannel  verticalLayout:#fitSpace.

    icon    := Image fromFile:('xpmBitmaps/QUESTION3.xpm').
    dropObj := DropObject newFile:('.').

    addButton := [:offset :label :dispObj| |button|
	button := Button label:label in:pannel.

	button pressAction:[
	    DragAndDropManager startDrag:dropObj from:button offset:offset display:dispObj.
	    button turnOff.
	]
    ].

    addButton value:(0@-5)       value:'String'       value:'String'.
    addButton value:#topLeft     value:'String'       value:'String'.
    addButton value:#topRight    value:'Text'         value:(Text string:'hello' emphasis:#bold).
    addButton value:#bottomLeft  value:'Icon'         value:icon.
    addButton value:#bottomRight value:'LabelAndIcon' value:(LabelAndIcon icon:icon string:'Label & Icon').
    addButton value:#center      value:'Mixed'        value:(Array with:'String' with:icon).

    topView label:'Drag & Drop'.
    topView openWithExtent:200@200.
								[exEnd]
"
! !

!DragAndDropManager class methodsFor:'initialization'!

initialize
    DragOriginatorQuerySignal := QuerySignal new.
    DragOffsetQuerySignal := QuerySignal new.
    DragContextQuerySignal := QuerySignal new.
    ActiveDragAndDropManagers := IdentityDictionary new.

    "
     self initialize
    "

    "Modified: 11.8.1997 / 00:54:21 / cg"
! !

!DragAndDropManager class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!DragAndDropManager class methodsFor:'Signal constants'!

dragContextQuerySignal
    ^ DragContextQuerySignal
!

dragOffsetQuerySignal
    ^ DragOffsetQuerySignal

    "Created: 11.8.1997 / 00:54:10 / cg"
!

dragOriginatorQuerySignal
    ^ DragOriginatorQuerySignal
! !

!DragAndDropManager class methodsFor:'defaults'!

autoScrollDelayTimeMs
    "time measured in milli-seconds the autoscroll task is delayed"

    ^ 200
! !

!DragAndDropManager class methodsFor:'helpers'!

disabledFlag:aBoolean device:aDevice
    |activeManager|

    activeManager := ActiveDragAndDropManagers at:aDevice ifAbsent:nil.
    activeManager notNil ifTrue:[
        activeManager disabledFlag: aBoolean
    ].
!

postDraggingOnDevice:aDevice
    |activeManager|

    activeManager := ActiveDragAndDropManagers at:aDevice ifAbsent:nil.
    activeManager notNil ifTrue:[
        activeManager dragHandler postDragging
    ].
!

rereadSaveAreaOnDevice:aDevice
    |activeManager|

    activeManager := ActiveDragAndDropManagers at:aDevice ifAbsent:nil.
    activeManager notNil ifTrue:[
        activeManager dragHandler flushSaveArea; rereadSaveArea
    ].
!

saveDraw:aBlock device:aDevice
    |activeManager|

    activeManager := ActiveDragAndDropManagers at:aDevice ifAbsent:nil.
    activeManager isNil ifTrue:[
        aBlock value
    ] ifFalse:[
        activeManager saveDraw:aBlock
    ].
! !

!DragAndDropManager class methodsFor:'queries'!

isDragAndDropActiveOnDevice:aDevice
    ^ ActiveDragAndDropManagers includesKey:aDevice
! !

!DragAndDropManager class methodsFor:'simple start-drop source'!

startDragFrom:aView dropSource:aDropSource
    "start a drop at the current pointer position."

    ^ (self new) startDragFrom:aView dropSource:aDropSource
! !

!DragAndDropManager class methodsFor:'simple start-generic'!

startDrag:draggableObjects from:aView
    "start a drop at the current pointer position"

    ^ self startDrag:draggableObjects
                from:aView
              offset:0@0
               atEnd:nil
             display:draggableObjects

"
EXAMPLE:

    |button|

    button := (Button label:'press me').

    button pressAction:[
        DragAndDropManager startDrag:(DropObject newFile:('.')) from:button.
        button turnOff
    ].

    button openAt:100@100
"
!

startDrag:draggableObjects from:aView atEnd:aFourArgEndBlock
    "start a drop at the current pointer position
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"

    ^ self startDrag:draggableObjects
                from:aView
              offset:0@0
               atEnd:aFourArgEndBlock
             display:draggableObjects

"
EXAMPLE:

    |button|

    button := (Button label:'press me').

    button pressAction:[
        DragAndDropManager startDrag:(DropObject newFile:('.'))
                                from:button
                               atEnd:[:targetView :targetViewId :screenPoint :targetPoint|
                                        Transcript showCR:'target  view: ', targetView   printString.
                                        Transcript showCR:'target    id: ', targetViewId printString.
                                        Transcript showCR:'point screen: ', screenPoint  printString.
                                        Transcript showCR:'point target: ', targetPoint  printString.
                                     ].
        button turnOff
    ].

    button openAt:100@100
"
!

startDrag:draggableObjects from:aView atEnd:aFourArgEndBlock display:something
    "start a drop at the current pointer position
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"

    ^ self startDrag:draggableObjects
                from:aView
              offset:0@0
               atEnd:aFourArgEndBlock
             display:something

"
EXAMPLE:

    |button|

    button := (Button label:'press me').

    button pressAction:[
        DragAndDropManager startDrag:(DropObject newFile:('.'))
                                from:button
                               atEnd:[:targetView :targetViewId :screenPoint :targetPoint|
                                        Transcript showCR:'target  view: ', targetView   printString.
                                        Transcript showCR:'target    id: ', targetViewId printString.
                                        Transcript showCR:'point screen: ', screenPoint  printString.
                                        Transcript showCR:'point target: ', targetPoint  printString.
                                     ]
                             display:(Array with:'String' with:(Image fromFile:('xpmBitmaps/QUESTION3.xpm'))).
        button turnOff
    ].

    button openAt:100@100
"
!

startDrag:draggableObjects from:aView display:something
    "start a drop at the current pointer position"

    ^ self startDrag:draggableObjects
                from:aView
              offset:0@0
               atEnd:nil
             display:something

"
EXAMPLE:

    |dropObj topView pannel icon buttonAction addButton|

    topView := StandardSystemView new.
    pannel  := VerticalPanelView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:topView.
    pannel  horizontalLayout:#fit.
    pannel  verticalLayout:#fitSpace.

    icon    := Image fromFile:('xpmBitmaps/QUESTION3.xpm').
    dropObj := DropObject newFile:('.').

    addButton := [:label :dispObj| |button|
        button := Button label:label in:pannel.

        button pressAction:[
            DragAndDropManager startDrag:dropObj from:button display:dispObj.
            button turnOff.
        ]
    ].

    addButton value:'String'       value:'String'.
    addButton value:'Text'         value:(Text string:'hello' emphasis:#bold).
    addButton value:'Icon'         value:icon.
    addButton value:'LabelAndIcon' value:(LabelAndIcon icon:icon string:'Label & Icon').
    addButton value:'Mixed'        value:(Array with:'String' with:icon).

    topView label:'Drag & Drop'.
    topView openWithExtent:200@200.
"
!

startDrag:draggableObjects from:aView offset:anOffset
    "start a drop at the current pointer position"

    ^ self startDrag:draggableObjects
                from:aView
              offset:anOffset
               atEnd:nil
             display:draggableObjects

"
EXAMPLE:

    |button|

    button := (Button label:'press me').

    button pressAction:[
        DragAndDropManager startDrag:(DropObject newFile:('.')) from:button offset:(-10 @ -10).
        button turnOff
    ].

    button openAt:100@100
"
!

startDrag:draggableObjects from:aView offset:anOffset atEnd:aFourArgEndBlock
    "start a drop at the current pointer position
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"

    ^ self startDrag:draggableObjects
                from:aView
              offset:anOffset
               atEnd:aFourArgEndBlock
             display:draggableObjects

"
EXAMPLE:

    |button|

    button := (Button label:'press me').

    button pressAction:[
        DragAndDropManager startDrag:(DropObject newFile:('.'))
                                from:button
                              offset:(-10 @ -10)
                               atEnd:[:targetView :targetViewId :screenPoint :targetPoint|
                                        Transcript showCR:'target  view: ', targetView   printString.
                                        Transcript showCR:'target    id: ', targetViewId printString.
                                        Transcript showCR:'point screen: ', screenPoint  printString.
                                        Transcript showCR:'point target: ', targetPoint  printString.
                                     ].
        button turnOff
    ].

    button openAt:100@100
"
!

startDrag:draggableObjects from:aView offset:anOffset atEnd:aFourArgEndBlock display:something
    "start a drop at the current pointer position
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"

    |manager|

    manager := self new.

    manager startDrag:draggableObjects
                 from:aView
               offset:anOffset
                atEnd:aFourArgEndBlock
              display:something.

    ^ manager

"
EXAMPLE:

    |button|

    button := (Button label:'press me').

    button pressAction:[
        DragAndDropManager startDrag:(DropObject newFile:('.'))
                                from:button
                              offset:(-10 @ -10)
                               atEnd:[:targetView :targetViewId :screenPoint :targetPoint|
                                        Transcript showCR:'target  view: ', targetView   printString.
                                        Transcript showCR:'target    id: ', targetViewId printString.
                                        Transcript showCR:'point screen: ', screenPoint  printString.
                                        Transcript showCR:'point target: ', targetPoint  printString.
                                     ]
                             display:(Array with:'String' with:(Image fromFile:('xpmBitmaps/QUESTION3.xpm'))).
        button turnOff
    ].

    button openAt:100@100
"
!

startDrag:draggableObjects from:aView offset:anOffset display:something
    "start a drop at the current pointer position"

    ^ self startDrag:draggableObjects
                from:aView
              offset:anOffset
               atEnd:nil
             display:something

"
EXAMPLE:

    |dropObj topView pannel icon buttonAction addButton|

    topView := StandardSystemView new.
    pannel  := VerticalPanelView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:topView.
    pannel  horizontalLayout:#fit.
    pannel  verticalLayout:#fitSpace.

    icon    := Image fromFile:('xpmBitmaps/QUESTION3.xpm').
    dropObj := DropObject newFile:('.').

    addButton := [:offset :label :dispObj| |button|
        button := Button label:label in:pannel.

        button pressAction:[
            DragAndDropManager startDrag:dropObj from:button offset:offset display:dispObj.
            button turnOff.
        ]
    ].

    addButton value:#topLeft     value:'String'       value:'String'.
    addButton value:#topRight    value:'Text'         value:(Text string:'hello' emphasis:#bold).
    addButton value:#bottomLeft  value:'Icon'         value:icon.
    addButton value:#bottomRight value:'LabelAndIcon' value:(LabelAndIcon icon:icon string:'Label & Icon').
    addButton value:#center      value:'Mixed'        value:(Array with:'String' with:icon).

    topView label:'Drag & Drop'.
    topView openWithExtent:200@200.
"
! !

!DragAndDropManager class methodsFor:'simple start-lines'!

startArrowDragIn:aView at:dragPoint atEnd:aFourArgBlock
    "start a rubber-arrow-line dragging in aView at dragPoint.
     When finished, evaluate the fourArgBlock with targetView,
     targetID, screenPosition and targetViewPosition as arguments"

    ^ self new startArrowDragIn:aView at:dragPoint atEnd:aFourArgBlock

"
EXAMPLE:

    |button|

    button := (Button label:'press me').

    button pressAction:[
        button turnOff.

        DragAndDropManager startArrowDragIn:button 
                                         at:(button preferredExtent // 2)
                                      atEnd:[:targetView :targetViewId :screenPoint :targetPoint|
                                                targetView isNil ifTrue:[
                                                    Transcript show:'alien view'
                                                ] ifFalse:[
                                                    Transcript showCR:'target: ', targetView printString
                                                ].
                                                Transcript showCR:'point screen: ', screenPoint printString.
                                                Transcript showCR:'point target: ', targetPoint printString.
                                            ]
     ].
     button openAt:100@100
"
!

startLineDragIn:aView at:dragPoint atEnd:aFourArgBlock
    "start a rubber-line dragging in aView at dragPoint.
     When finished, evaluate the fourArgBlock with targetView,
     targetID, screenPosition and targetViewPosition as arguments"

    ^ self new startLineDragIn:aView at:dragPoint atEnd:aFourArgBlock

"
EXAMPLE:

    |button|

    button := (Button label:'press me').

    button pressAction:[
        button turnOff.

        DragAndDropManager startLineDragIn:button 
                                        at:(button preferredExtent // 2)
                                     atEnd:[:targetView :targetViewId :screenPoint :targetPoint|
                                               targetView isNil ifTrue:[
                                                   Transcript show:'alien view'
                                               ] ifFalse:[
                                                   Transcript showCR:'target: ', targetView printString
                                               ].
                                               Transcript showCR:'point screen: ', screenPoint printString.
                                               Transcript showCR:'point target: ', targetPoint printString.
                                           ]
     ].
     button openAt:100@100
"
! !

!DragAndDropManager class methodsFor:'translation'!

translatePointFromScreen:aPoint to:aView
    "translate a point from screen to view coordinates"

    |viewsDevice trans point offset|

    aView isRootView ifTrue:[^ aPoint].
    viewsDevice := aView device.
    "/
    "/ get device coordinates
    "/
    (trans := aView transformation) notNil ifTrue:[
        point := trans applyInverseTo:aPoint
    ] ifFalse:[
        point := aPoint
    ].
    "/
    "/ translate to screen
    "/
    offset := viewsDevice translatePoint:0@0 fromView:(viewsDevice rootView) toView:aView.
    ^ offset + point
!

translatePointFromScreen:aPoint toView:aView
    "translate a point from screen- to view coordinates"

    |viewsDevice trans point offset|

    viewsDevice := aView device.

    "/
    "/ translate to view
    "/
    offset := viewsDevice translatePoint:0@0 fromView:(viewsDevice rootView) toView:aView.
    point := aPoint + offset.

    "/
    "/ get device coordinates
    "/
    (trans := aView transformation) notNil ifTrue:[
        point := trans applyInverseTo:point
    ].
    ^ point
!

translatePointToScreen:aPoint from:aView
    "translate a point from view- to screen coordinates"

    |viewsDevice trans point offset|

    aView isRootView ifTrue:[^ aPoint].
    viewsDevice := aView device.
    "/
    "/ get device coordinates
    "/
    (trans := aView transformation) notNil ifTrue:[
        point := trans transformPoint:aPoint
    ] ifFalse:[
        point := aPoint
    ].
    "/
    "/ translate to screen
    "/
    offset := viewsDevice translatePoint:0@0 fromView:aView toView:(viewsDevice rootView).
    ^ offset + point
! !

!DragAndDropManager methodsFor:'accessing'!

device
    "returns the device of the source view"

    ^ dragView device
!

disabledFlag
    ^ disabledFlag ? false
!

disabledFlag:something
    disabledFlag := something.
!

dragHandler
    "returns the current active handler which is responsible for drawing ..."

    ^ handler
!

dragHandler:aNewHandler
    "set the active handler which is responsible for drawing ..."

    handler := aNewHandler.
!

dropContext
    "return the current context"

    ^ dropContext
!

dropObjects
    "return the current dropObject collection"

    ^ dropContext dropObjects

    "Modified: 19.4.1997 / 10:19:06 / cg"
!

dropObjects:aCollectionOfDropObjects
    "set the current dropObject collection"

    ^ dropContext dropObjects:aCollectionOfDropObjects
!

font
    "returns the font of the source view"

    ^ dragView font
!

giveFocusToTargetWidget:aBoolean
    giveFocusToTargetWidget := aBoolean.
!

isDisabled
    ^ disabledFlag ? false
!

notifyEndOfDropAction: aNoneArgBlock
    "the action is triggered after the drop has finished"

     notifyEndOfDropAction := aNoneArgBlock.
!

passiveAction:aBlockOrNil
    self removePassiveAction.
    aBlockOrNil notNil ifTrue:[
        passiveAction := aBlockOrNil.
        Processor addTimedBlock:aBlockOrNil afterMilliseconds:100.
    ].
!

removePassiveAction
    passiveAction notNil ifTrue:[
        Processor removeTimedBlock:passiveAction.
        passiveAction := nil.
    ].
!

sourceWidget
    ^ dragView
! !

!DragAndDropManager methodsFor:'accessing-cursor'!

alienCursor:aCursorOrImage
    "set the cursor used for an alien widget; not an ST/X view"

    aCursorOrImage isImage ifTrue:[
        alienCursor := Cursor fromImage:aCursorOrImage
    ] ifFalse:[
        (aCursorOrImage isMemberOf:Cursor) ifTrue:[
            alienCursor := aCursorOrImage
        ] ifFalse:[
            "/
            "/ use disabled cursor
            "/
            alienCursor := nil
        ]
    ]
!

disabledCursor:aCursorOrImage
    "set the cursor for an ST/X view, which can not drop the objects"

    aCursorOrImage isImage ifTrue:[
        disabledCursor := Cursor fromImage:aCursorOrImage
    ] ifFalse:[
        (aCursorOrImage isMemberOf:Cursor) ifTrue:[
            disabledCursor := aCursorOrImage
        ]
    ]
!

enabledCursor:aCursorOrImage
    "set the cursor for an ST/X view, which can drop the objects"

    aCursorOrImage isImage ifTrue:[
        enabledCursor := Cursor fromImage:aCursorOrImage
    ] ifFalse:[
        (aCursorOrImage isMemberOf:Cursor) ifTrue:[
            enabledCursor := aCursorOrImage
        ]
    ]
! !

!DragAndDropManager methodsFor:'change & update'!

contentsWillChange
    "called by the dropTarget-widget if the contents will change during a
     dragAndDrop operation"

    handler notNil ifTrue:[
        handler dropTargetWillChange
    ]
! !

!DragAndDropManager methodsFor:'dragging-drop source'!

startDragFrom:aView dropSource:aDropSource
    "start a drag at the current pointer position."

    ^ self startDragFrom:aView dropSource:aDropSource offset:#topLeft "/ #center
!

startDragFrom:aView dropSource:aDropSource offset:anOffset
    "start a drag at the current pointer position."

    dropContext dropSource:aDropSource.

    ^ self startDrag:(aDropSource dropObjects)
                from:aView
              offset:anOffset
               atEnd:nil
             display:(aDropSource displayObjects)
! !

!DragAndDropManager methodsFor:'dragging-easy startup'!

startDrag:draggableObjects from:aView 
    "start a drop at the current pointer position"
    
    ^ self 
        startDrag:draggableObjects
        from:aView
        offset:0 @ 0
!

startDrag:draggableObjects from:aView display:something 
    "start a drop at the current pointer position."
    
    ^ self 
        startDrag:draggableObjects
        from:aView
        offset:nil
        atEnd:nil
        display:something
!

startDrag:draggableObjects from:aView offset:anOffset 
    "start a drop at the current pointer position with an offset"
    
    ^ self 
        startDrag:draggableObjects
        from:aView
        offset:anOffset
        atEnd:nil
!

startDrag:draggableObjects from:aView offset:anOffset atEnd:aFourArgEndBlock 
    "start a drop at the current pointer position.
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"
    
    ^ self 
        startDrag:draggableObjects
        from:aView
        offset:anOffset
        atEnd:aFourArgEndBlock
        display:draggableObjects
!

startDrag:draggableObjects from:aView offset:anOffset atEnd:aFourArgBlock display:something
    "start a drop at the current pointer position.
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView."

    |height width fontWdt offset ascent device dispObjs list space|

    self dropObjects:draggableObjects.

    self dropObjects size == 0 ifTrue:[
        ^ self
    ].

    device   := aView device.
    space    := 1.
    height   := space negated.
    width    := 0.
    fontWdt  := aView font width.
    ascent   := aView font ascent.

    (list := something) isNil ifTrue:[
        list := self dropObjects
    ] ifFalse:[
        (list isCollection not or:[list isString]) ifTrue:[
            list := Array with:something
        ]
    ].
    dispObjs := OrderedCollection new.

    list do:[:el|
        |obj asc|

        obj    := self displayObjectFor:el on:device.
        asc    := (obj respondsTo:#string) ifTrue:[ascent] ifFalse:[0].
        height := height + space.

        dispObjs add:(Array with:obj with:(0 @ (height + asc))).
        width  := width max:(obj widthOn:aView).
        height := height + (obj heightOn:aView).
    ].

    anOffset isSymbol ifTrue:[
        offset := (0@0 extent:(width @ height)) perform:anOffset.
    ] ifFalse:[
        offset := anOffset ? (0@0).
    ].
    offset := offset rounded.

    dispObjs do:[:el| el at:2 put:((el at:2) - offset) ].

    self 
        startOpaqueDrag:
            [:p :v|
                |cursor hX hY pDraw|

                cursor := dragView cursor.
                hX := cursor hotX.
                hY := cursor hotY.
                pDraw := p "- (hX@hY) + cursor extent".
                dispObjs do:[:el| 
                    (el at:1) displayOn:v at:pDraw + (el at:2)
                ] 
            ]
        offset:offset
        extent:width @ height
        in:aView
        at:nil
        atEnd:aFourArgBlock

    "Modified: / 31.3.1998 / 11:18:04 / cg"
!

startDrag:draggableObjects from:aView offset:anOffset display:something 
    "start a drop at the current pointer position."
    
    ^ self 
        startDrag:draggableObjects
        from:aView
        offset:anOffset
        atEnd:nil
        display:something
! !

!DragAndDropManager methodsFor:'dragging-generic'!

startGenericDrag:aTwoArgDragBlock in:aView at:p atEnd:aFourArgEndBlock 
    "start a generic (caller-provided drag);
     Here, an inverting drag is initiated (i.e. the drawing is undone
     by inverting again). See startOpaqueDrag for another variant.
     the dragBlock, aTwoArgDragBlock will be called with two args
     aPoint and a drawingGC, to perform the drawing at some dragPoint.
     The drag starts in aView at point p.
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"
    
    ^ self 
        startOpaqueDrag:aTwoArgDragBlock
        offset:nil
        extent:nil
        in:aView
        at:nil
        atEnd:aFourArgEndBlock
!

startOpaqueDrag:aDragBlock offset:offs extent:anExtent in:aView at:aDummyPoint atEnd:aFourArgEndBlock
    "start an opaque or generic opaque (caller-provided drag);
     opaque drag means, that the drawing cannot be undone by two inverting
     draws, but instead, the area under the dragged object must be saved
     and restored. The areas size to be saved/restored is passed in anExtent.
     the dragBlock, aDragBlock will be called with up to three args aPoint, a
     drawingGC and the display objects, to perform the drawing at some dragPoint.
     The drag starts in aView at point p.
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"

    |handler numArgs dragBlock dobjs|

    dragOffset := offs ? (0@0).
    numArgs    := aDragBlock numArgs.

    numArgs == 3 ifTrue:[
        dobjs := self dropObjects.
        dragBlock := [:p :v| aDragBlock value:p value:v value:dobjs ]
    ] ifFalse:[
        numArgs == 1 ifTrue:[
            dragBlock := [:p :v| aDragBlock value:p ]
        ] ifFalse:[
            dragBlock := aDragBlock
        ]
    ].

    anExtent isNil ifTrue:[
        handler := DragHandler startGenericDrag:dragBlock.
    ] ifFalse:[
        handler := DragHandler startOpaqueDrag:dragBlock extent:anExtent offset:dragOffset.
    ].
    self doStart:handler for:aView atEnd:aFourArgEndBlock.

    "Modified: / 18-07-2011 / 09:38:21 / cg"
! !

!DragAndDropManager methodsFor:'dragging-lines'!

startArrowDragIn:aView at:aStartPoint atEnd:aFourArgEndBlock 
    "start a line-drag of an arrow-line.
     The drag starts in aView at point aStartPoint.
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"
    
    |p|

    p := self class translatePointToScreen:aStartPoint from:aView.
    self 
        doStart:(DragHandler startArrowDragAt:p)
        for:aView
        atEnd:aFourArgEndBlock
!

startLineDragIn:aView at:aStartPoint atEnd:aFourArgEndBlock 
    "start a line-drag of a normal line.
     The drag starts in aView at point aStartPoint.
     When finished, the endAction is called with four args:
     the targetView, the targetViews windowID (useful, if its an alien view),
     the dropPoint in root-coordinates and the dropPoint within the targetView"
    
    |p|

    p := self class translatePointToScreen:aStartPoint from:aView.
    self 
        doStart:(DragHandler startLineDragAt:p)
        for:aView
        atEnd:aFourArgEndBlock
! !

!DragAndDropManager methodsFor:'drawing'!

displayObjectFor:anObject on:aDevice
    "converts an object to a display object.
     CG (to CA): this is an ugly hack and must be fixed to be OO,
                 in sending something like #asDragAndDropDisplayObjectOn:aDevice
                 to anObject, and doing all specific optimizations there."

    |obj s1 s2|

    obj := (anObject respondsTo:#displayObject) ifTrue:[anObject displayObject]
                                               ifFalse:[anObject].

    obj isString ifTrue:[
        ^ obj
    ].

    MessageNotUnderstood 
        ignoreNotUnderstoodOf:#onDevice: 
        in:[
            obj := obj onDevice:aDevice
        ].

    obj isLabelAndIcon ifTrue:[
        ^ obj
    ].

    (obj class == MultiColListEntry) ifTrue:[
        s1 := obj colAt:1.
        s2 := obj colAt:2.

        s1 isImage ifTrue:[
            s2 isImage  ifTrue:[ ^ self displayObjectFor:(LabelAndIcon form:s1  image:s2) on:aDevice ].
            s2 isString ifTrue:[ ^ self displayObjectFor:(LabelAndIcon icon:s1 string:s2) on:aDevice ].
            ^ s1 onDevice:aDevice.
        ].

        s2 isImage ifTrue:[
            s1 isString ifTrue:[ ^ self displayObjectFor:(LabelAndIcon icon:s2 string:s1) on:aDevice ].
            ^ s2 onDevice:aDevice.
        ].

        s1 isString ifTrue:[^ s1].
        s2 isString ifTrue:[^ s2].
    ].

    ^ obj
!

showDragging:items in:aView at:p
    "helper for dragging dragObjects: draw them all"

    |offs|

    offs := 0.
    items do:[:item |
        item displayOn:aView at:p + (0@offs).
        offs := offs + (item heightOn:self)
    ]

    "Modified: 19.4.1997 / 12:41:24 / cg"
! !

!DragAndDropManager methodsFor:'event catching'!

buttonMotion:buttonAndModifierState x:x y:y view:aView
    |device screenPoint oldWidget oldId oldPoint newId newWidget oldTarget newTarget 
     isDroppable cursor|

    self isDisabled ifTrue: [ ^ self ].

    escapePressed == true ifTrue:[
        self removePassiveAction.
        ^ self
    ].

    (dragView notNil and:[dragView sensor motionEventPending]) ifTrue:[
        ^ self
    ].
    self removePassiveAction.

    device := dragView device.
    oldWidget  := dropContext targetWidget.
    oldId  := dropContext targetId.
    oldPoint  := dropContext rootPoint.

    screenPoint := self class translatePointToScreen:(x @ y) from:aView.
    dropContext rootPoint:screenPoint.

    newId := device viewIdFromPoint:screenPoint.
    newWidget := device viewFromId:newId.

    dropContext rootPoint:screenPoint.
    dropContext targetWidget:newWidget id:newId.
    handler dropContext:dropContext.
    handler isInterestedInDropTarget ifFalse:[
        "/
        "/ line or arrow handler
        "/
        handler dragTo:screenPoint.
        ^ self
    ].

    oldTarget := dropContext dropTarget.
    newTarget := self doFindDropTargetIn:newWidget at:screenPoint.

    newTarget ~= oldTarget ifTrue:[
        "/
        "/ drop target changed: handler might restore the screen
        "/
        handler dropTargetWillChange.

        oldTarget notNil ifTrue:[
            "/
            "/ setup old context
            "/
            dropContext targetWidget:oldWidget id:oldId.
            oldTarget leave:dropContext.
            dropContext targetWidget:newWidget id:newId.
        ].
        dropContext dropTarget:newTarget.
        newTarget notNil ifTrue:[ newTarget enter:dropContext ]
    ] ifFalse:[
        dropContext dropTarget:newTarget
    ].

    "/
    "/ update the cursor
    "/
    (isDroppable := dropContext canDrop) ifTrue:[
        cursor := enabledCursor
    ] ifFalse:[
        dropContext isAlienView ifTrue:[
            cursor := alienCursor.

"/            className := Screen current getWindowClassName:newId.
"/            title := Screen current getWindowText:newId.
"/            cursor := enabledCursor.
        ] ifFalse:[
            cursor := disabledCursor
        ].
    ].

    dragView cursor:cursor now:true.
    "/
    "/ test if droppable state changed
    "/
    canDrop == isDroppable ifFalse:[
        "/
        "/ droppable state changed: handler might restore the screen
        "/
        canDrop := isDroppable.
        handler dropTargetWillChange
    ].

    newTarget notNil ifTrue:[ newTarget over:dropContext ].
    handler dragTo:screenPoint.
!

buttonRelease:button x:x y:y view:aView
    |targetWidget|

    (button == 1) ifFalse:[
        ^ self
    ].
    self removePassiveAction.

    restoreBlock value.                 "/ restore context before start drag

    escapePressed == true ifTrue:[^ self].

    targetWidget := dropContext targetWidget.
    dropAction notNil ifTrue:[
        "/
        "/ initiator wants to do it himself, manually.
        "/ Thus, no feedBack operation invoked.
        "/
        dropAction value:(targetWidget)
                   value:(dropContext targetId)
                   value:(dropContext rootPoint)
                   value:(dropContext targetPoint).
    ] ifFalse:[
        dropContext doDrop
    ].

    "/ UI feels better, if the focus is assigned to the target view,
    "/ if click-for-focus is on.
    "/ CG: no - do it always
"/    UserPreferences current focusFollowsMouse == false ifTrue:[
"/        dropContext targetWidget wantsFocusWithButtonPress ifTrue:[
"/            dropContext targetWidget requestFocus    
"/        ].
"/    ].
    giveFocusToTargetWidget ifTrue:[
        (targetWidget notNil and:[targetWidget shown]) ifTrue:[
            targetWidget topView raise; activate.
            targetWidget takeFocus.    
        ].
    ].
!

escapePressed
    "handle the escape key"

    | dropTarget |

    escapePressed ~~ true ifTrue:[
        escapePressed := true.

        dragView cursor:savedCursor now:true.

        handler notNil ifTrue:[
            "/ restore handler
            dropTarget := dropContext dropTarget.
            handler postDragging.

            dropTarget notNil ifTrue:[
                "/ invoke leave operation
                dropTarget  leave:dropContext.
                dropContext dropTarget:nil.
            ].
        ].
        self triggerEndOfDropAction.
    ].
!

keyPress:aKey x:x y:y view:aView
    "stop the drag operation, when the escape key is pressed"

    <resource: #keyboard (#Escape)>

    escapePressed == true ifTrue:[ ^ self ].    "/ ignored, escaped was already pressed

    aKey == #Escape ifTrue:[
        self escapePressed.
    ].

    ((aKey == #Cmd) 
    or:[ (aKey == #Shift)
    or:[ (aKey == #Ctrl) ]]) ifTrue:[
        self updateDragKind.
        "/ invoke motion, to force a redraw (of the dropKind-indicator)
        self buttonMotion:nil x:x y:y view:aView    
    ].
!

keyRelease:aKey x:x y:y view:aView
    "redraw if shift, alt or ctrl key is released"

    <resource: #keyboard (#Escape)>

    ((aKey == #Cmd) 
    or:[ (aKey == #Shift)
    or:[ (aKey == #Ctrl) ]]) ifTrue:[
        self updateDragKind.
        "/ invoke motion, to force a redraw (of the dropKind-indicator)
        self buttonMotion:nil x:x y:y view:aView    
    ].
!

processAutoScroll
    "process an autoScroll event"

    |targetWidget targetPoint|

    self isActive ifFalse:[^ self].

    dropContext isNil ifTrue:[ ^ self ].

    targetWidget := dropContext targetWidget.
    targetWidget isNil ifTrue:[ ^ self ].
    targetWidget isRootView ifTrue:[ ^ self ].

    targetPoint := dropContext targetPoint.
    targetPoint isNil ifTrue:[ ^ self ].

    (targetWidget dragAutoScroll: dropContext) ifFalse:[
        ^ self
    ].
    self buttonMotion:256 x:(targetPoint x) y:(targetPoint y) view:targetWidget.
!

processEvent:event
    "filter keyboard events.
     Return true, if I have eaten the event"

    |evView|

    restoreBlock isNil ifTrue:[^ false].        "/ should not happen

    evView := event view.
    evView isNil ifTrue:[^ false].

    event isInputEvent ifFalse:[
        ^ false
    ].

    event isKeyPressEvent ifTrue:[
        self keyPress:(event key) x:(event x) y:(event y) view:evView.
        ^ true
    ].
    event isKeyReleaseEvent ifTrue:[
        self keyRelease:(event key) x:(event x) y:(event y) view:evView.
        ^ true
    ].
    event isButtonMotionEvent ifTrue:[
        self buttonMotion:(event state) x:(event x) y:(event y) view:evView.
        ^ true
    ].
    event isButtonReleaseEvent ifTrue:[
        self buttonRelease:(event button) x:(event x) y:(event y) view:evView.
        ^ true
    ].

    ^ true
!

triggerEndOfDropAction
    "handle the escape key"

    |action|

    action := notifyEndOfDropAction.
    action isNil ifTrue:[ ^ self ].

    notifyEndOfDropAction := nil.
    action value.
!

updateDragKind
    "stop the drag operation, when the escape key is pressed"

    |screen dragType|

    dragType := DropContext dragTypeDefault.

    screen := dragView device.
    screen ctrlDown ifTrue:[
        dragType := DropContext dragTypeCopy.
    ].
    screen metaDown ifTrue:[
        dragType := DropContext dragTypeLink.
    ].
    screen shiftDown ifTrue:[
        dragType := DropContext dragTypeMove.
    ].

    dropContext dragType:dragType.
! !

!DragAndDropManager methodsFor:'initialization'!

initialize
    super initialize.

    dragOffset     := 0 @ 0.
    dropContext    := DropContext new manager:self.
    alienCursor    := Cursor questionMark.
    enabledCursor  := Cursor thumbsUp.
    disabledCursor := Cursor thumbsDown.
    canDrop        := false.
    giveFocusToTargetWidget := true.
! !

!DragAndDropManager methodsFor:'private'!

doDrop:aContext in:aWidget
    "old drop mechanism"

    |point|

    DragContextQuerySignal answer:aContext do:[
        DragOriginatorQuerySignal answer:dragView do:[
            DragOffsetQuerySignal answer:dragOffset do:[ 
                |targetWidget targetPoint|

                targetWidget := aContext targetWidget.
                targetPoint  := aContext targetPoint.

                targetWidget == aWidget ifTrue:[
                    point := targetPoint.
                ] ifFalse:[
                    point := targetWidget originRelativeTo:aWidget.

                    point isNil ifTrue:[
                        point := 0@0.
                    ] ifFalse:[
                        point := point + targetPoint.
                    ].
                    "/
                    "/ FeedBack: set the widget which handles the drop
                    "/
                    aContext targetWidget:aWidget id:(aWidget id).
                ].
                aWidget dropObjects:(aContext dropObjects) at:point
            ]
        ].
    ].

    "Modified: / 13-10-2006 / 17:52:56 / cg"
!

doFindDropTargetIn:aView at:aPoint
    "get the drop target for a view and source at a point or nil"

    |target|

    aView isNil ifTrue:[ 
        ^ nil 
    ].
    aView isRootView ifTrue:[ 
        ^ nil 
    ].

    "new mechanism to get a dropTarget"
    target := aView dropTarget.
    target notNil ifTrue:[ 
        ^ target 
    ].

    "old mechanism to get a dropTarget"

    (SignalSet
        with:DragContextQuerySignal
        with:DragOriginatorQuerySignal
        with:DragOffsetQuerySignal)
    handle:[:ex |
        |signal|

        signal := ex creator.
        signal == DragContextQuerySignal ifTrue:[ ex proceedWith:dropContext].
        signal == DragOriginatorQuerySignal ifTrue:[ ex proceedWith:dragView].
        signal == DragOffsetQuerySignal ifTrue:[ ex proceedWith:dragOffset].
        self error:'unexpected query'.
    ] do:[
        |view app dobj|

        view := aView.
        dobj := dropContext dropObjects.
        [   
            (view canDrop:dropContext) ifTrue:[
                ^ DropTarget receiver:self argument:view dropSelector:#doDrop:in:.
            ].
            (view canDropObjects:dobj) ifTrue:[
                ^ (DropTarget receiver:view argument:nil dropSelector:#dropObjects:at:) oldDropAPI:true.
            ].
            view application ~~ app ifTrue:[
                app := view application.

                app notNil ifTrue:[
                    (app canDropObjects:dobj) ifTrue:[
                        ^ (DropTarget receiver:app argument:nil dropSelector:#dropObjects:at:) oldDropAPI:true.
                    ].
                ].
            ].
            (view := view superView) notNil
        ] whileTrue.
    ].
    ^ nil

    "Modified: / 13-10-2006 / 18:21:43 / cg"
!

doStart:aHandler for:aView atEnd:aFourArgEndBlock
    "setup a handler and a restore block"

    |viewsDevice lastActive windowGroup screenPoint|

    viewsDevice := aView device.
    lastActive := ActiveDragAndDropManagers at:viewsDevice ifAbsent:nil.

    lastActive notNil ifTrue:[
        "/ self error:'oops - two dnd managers active' mayProceed:true.

        lastActive forceGiveUp.
        'DragAndDropManager [info]: oops - two dnd managers active' infoPrintCR.
    ].
    ActiveDragAndDropManagers at:viewsDevice put:self.

    dropContext sourceWidget:aView.

    dragOffset  isNil ifTrue:[ dragOffset  := 0 @ 0 ].
    alienCursor isNil ifTrue:[ alienCursor := disabledCursor ].

    dragView      := aView.
    dropAction    := aFourArgEndBlock.
    windowGroup   := aView windowGroup.
    handler       := aHandler.
    escapePressed := false.

    dropContext dragHandler:aHandler.

    savedCursor := dragView cursor.
    windowGroup addPreEventHook:self.
    windowGroup addPostEventHook:self.

    restoreBlock := 
        [
            restoreBlock := nil.

            autoScrollTask notNil ifTrue:[
                autoScrollTask terminate.
                autoScrollTask := nil.
            ].

            ActiveDragAndDropManagers removeKey:viewsDevice ifAbsent:nil.
            escapePressed ifFalse:[ aHandler postDragging ].

            windowGroup removePreEventHook:self.
            windowGroup removePostEventHook:self.
            dragView cursor:savedCursor.

            self triggerEndOfDropAction.
        ].
    aHandler preDraggingIn:dragView.

    "/ must wait for all pending motion events to arrive, and ignore them
    viewsDevice sync.        
    dragView sensor flushMotionEventsFor:nil.

    autoScrollTask := 
        [
            [   |sensor|

                sensor := windowGroup sensor.

                [ self isActive ] whileTrue:[
                    Delay waitForMilliseconds:(self class autoScrollDelayTimeMs).

                    self isActive ifTrue:[
                        sensor pushUserEvent:#processAutoScroll for:self.
                    ].
                ].
            ]ensure:[
                autoScrollTask := nil.
            ]
         ] newProcess.

    autoScrollTask priority:(Processor userSchedulingPriority).
    autoScrollTask name:'Drag-AutoScroll'.
    autoScrollTask resume.

    "/ start with a first draw at the current mouse position
    screenPoint := viewsDevice pointerPosition.
    self buttonMotion:1 x:(screenPoint x) y:(screenPoint y) view:(viewsDevice rootView).
!

forceGiveUp
    "called if the DragAndDropManager no longer should be
     active; a second one is started"

    self escapePressed.
    self removePassiveAction.
    restoreBlock value.
!

isActive
    "returns true if a drag operation is active"

    restoreBlock isNil ifTrue:[ ^ false ].
    ^ escapePressed ~~ true
!

saveDraw:aBlock
    handler postDragging.
    aBlock value.

    escapePressed == true ifFalse:[
        "/ reread and show drag items
        handler rereadSaveArea.
        handler restoreFromSaveArea.
    ].
! !

!DragAndDropManager class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


DragAndDropManager initialize!
