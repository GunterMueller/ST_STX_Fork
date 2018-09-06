"
 COPYRIGHT (c) 1998 by eXept Software AG / Claus Gittinger
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

Object subclass:#DragHandler
	instanceVariableNames:'rootView lastRootPoint dropContext'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

DragHandler subclass:#Generic
	instanceVariableNames:'prevPoint lastPoint dragBlock'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DragHandler
!

DragHandler subclass:#Line
	instanceVariableNames:'startPoint endPoint lineMode'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DragHandler
!

DragHandler subclass:#Opaque
	instanceVariableNames:'dragSize dragBlock dragOffset saveUnder saveArea tmpForm'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DragHandler
!

!DragHandler class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG / Claus Gittinger
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
    this abstract class describes the protocol common to any DragHandler.
    The DragAndDropManger creates one instance responsible to show the
    dragging objects on the screen.

    [author:]
        Claus Gittinger

    [see also:]
        DragAndDropManager
"



! !

!DragHandler class methodsFor:'instance creation'!

startArrowDragAt:aStartPoint
    "creates and returns the drag handler which is responsible
     for an arrow drag."

    ^ Line new startPoint:aStartPoint mode:#arrow
!

startGenericDrag:aTwoArgDragBlock
    "creates and returns the drag handler which is responsible
     for a generic drag."

    ^ Generic new dragBlock:aTwoArgDragBlock
!

startLineDragAt:aStartPoint
    "creates and returns the drag handler which is responsible
     for a line drag."

    ^ Line new startPoint:aStartPoint mode:nil
!

startOpaqueDrag:aTwoArgDragBlock extent:anExtent offset:anOffset
    "creates and returns the drag handler which is responsible
     for a generic opaque drag."

    ^ Opaque new dragSize:anExtent dragOffset:anOffset dragBlock:aTwoArgDragBlock
! !

!DragHandler methodsFor:'accessing'!

dropContext
    ^ dropContext
!

dropContext:something
    dropContext := something.
!

targetView
    dropContext isNil ifTrue:[^ nil].
    ^ dropContext targetView
! !

!DragHandler methodsFor:'event dropTarget'!

dropTargetWillChange
    "called before the drop target or widget changed.
     restore root view ... (optional)"
!

isInterestedInDropTarget
    "returns true, if the handler is interested in the underlying
     drop target and the target should be tested to be able to drop
     the objects."

    ^ true
! !

!DragHandler methodsFor:'protocol'!

dragTo:aRootPoint
    "drag to a root point"

    self subclassResponsibility
!

flushSaveArea
!

postDragging
    "after dragging; restore root view ..."

    self subclassResponsibility
!

preDraggingIn:aSourceWidget
    "called before starting the drag & drop operation"

    rootView := aSourceWidget device rootView.
!

rereadSaveArea
! !

!DragHandler::Generic class methodsFor:'documentation'!

documentation
"
    this class handles a generic drag on the screen. It is not visible to
    the user and is created automatically by the DragAndDropManger.

    [author:]
        Claus Gittinger

    [see also:]
        DragAndDropManager
"


! !

!DragHandler::Generic methodsFor:'instance creation'!

dragBlock:aTwoArgBlock
    "the dragBlock will be called with two arguments, aPoint and the drawing GC,
     to perform the drawing at some dragPoint."

    dragBlock := aTwoArgBlock
! !

!DragHandler::Generic methodsFor:'protocol'!

dragTo:aRootPoint
    "drag to a root point"

    prevPoint notNil ifTrue:[
        self postDragging
    ].
    lastPoint := nil.
    prevPoint := lastRootPoint := aRootPoint.
    self postDragging
!

postDragging
    lastPoint isNil ifTrue:[
        lastPoint := prevPoint.
    ].
    rootView clippedByChildren:false.

    rootView xoring:[
        rootView lineWidth:0.
        dragBlock value:lastPoint value:rootView.
        rootView flush
    ]
! !

!DragHandler::Line class methodsFor:'documentation'!

documentation
"
    this class handles a line or arrow drag on the screen. It is not visible to
    the user and is created automatically by the DragAndDropManger.

    [author:]
        Claus Gittinger

    [see also:]
        DragAndDropManager
"


! !

!DragHandler::Line methodsFor:'event dropTarget'!

isInterestedInDropTarget
    ^ false


! !

!DragHandler::Line methodsFor:'instance creation'!

startPoint:aPoint mode:aMode

    lineMode   := aMode.
    startPoint := aPoint.


! !

!DragHandler::Line methodsFor:'protocol'!

dragTo:aRootPoint
    "do a line or arrow drag"

    self postDragging.
    endPoint := lastRootPoint := aRootPoint.
    self postDragging.
!

postDragging
    "invert for a line or arrow drag"

    |arrow|

    endPoint isNil ifTrue:[
        ^ self
    ].
    rootView clippedByChildren:false.

    rootView xoring:[
        rootView lineWidth:0. 

        lineMode == #arrow ifTrue:[
            arrow := Arrow from:startPoint to:endPoint.
            arrow arrowHeadLength:(rootView device horizontalPixelPerMillimeter * 4) rounded.
            arrow displayFilledOn:rootView.
        ] ifFalse:[
            rootView displayLineFrom:startPoint to:endPoint.
        ].
        rootView flush
    ]
! !

!DragHandler::Opaque class methodsFor:'constants'!

additionalSaveSize
    ^ 50 @ 50


! !

!DragHandler::Opaque class methodsFor:'documentation'!

documentation
"
    this class handles an generic opaque drag on the screen. It is not visible
    to the user and is created automatically by the DragAndDropManger.

    [author:]
        Claus Gittinger

    [see also:]
        DragAndDropManager
"


! !

!DragHandler::Opaque methodsFor:'instance creation'!

dragSize:anExtent dragOffset:anOffset dragBlock:aTwoArgBlock
    "the dragBlock will be called with two arguments, aPoint and the drawing GC,
     to perform the drawing at some dragPoint.
    "
    dragSize   := anExtent.
    dragOffset := anOffset.
    dragBlock  := aTwoArgBlock
! !

!DragHandler::Opaque methodsFor:'protocol'!

dragTo:aRootPoint
    "drag to a root point"

    |p point area|

    (saveArea notNil and:[lastRootPoint notNil]) ifTrue:[
        (lastRootPoint = aRootPoint) ifTrue:[
            "/ nothing changed
            ^ self
        ].
    ].

    lastRootPoint := aRootPoint.
    "/
    "/ copy from screen to saveUnder
    "/
    rootView clippedByChildren:false.
    point  := aRootPoint - dragOffset.

    saveArea notNil ifTrue:[
        (     (saveArea left   <= point x)
         and:[(saveArea top    <= point y)
         and:[(saveArea right  >= (point x + dragSize x))
         and:[(saveArea bottom >= (point y + dragSize y))]]]
        ) ifFalse:[
            "/
            "/ draggable objects no longer contained in saved area;
            "/ thus we have to restore the saved area on the screen.
            "/
            self postDragging.
        ]
    ].

    saveArea isNil ifTrue:[
        "/
        "/ screen not yet saved; thus we have to save the area
        "/
        p := point  - (self class additionalSaveSize).
        saveUnder copyFrom:rootView 
                         x:p x
                         y:p y
                       toX:0 
                         y:0 
                     width:saveUnder width
                    height:saveUnder height.
        saveArea := p extent:saveUnder extent.
    ].
    area := saveArea.

    "/
    "/ draw into the form using the dragAction block
    "/
    tmpForm copyFrom:saveUnder toX:0 y:0. 
    tmpForm paint:Color black.

    dragBlock value:(point  - saveArea origin + dragOffset) value:tmpForm.

    "if saveArea changed during dragBlock; lock operation"
    area == saveArea ifTrue:[
        rootView copyFrom:tmpForm toX:area left y:area top. 
    ].
!

dropTargetWillChange
    "restore old saveArea"

    self postDragging
!

flushSaveArea
    saveArea := nil
!

postDragging
    "restore from saveUnder for a generic opaque drag"

    |area|

    saveArea isNil ifTrue:[ ^ self ].
    area := saveArea.
    saveArea := nil.

    rootView clippedByChildren:false.
    "/ restore screen from saveUnder
    rootView copyFrom:saveUnder
                   x:0
                   y:0
                  toX:area left
                    y:area top
                width:saveUnder width
                height:saveUnder height
                async:false.

    "Call #D1894600 - redraw artefakte bei drag im tree
     work around copy again back 
        - doesn't help for linux
        - but helps for windows (native, not needed for windows running in VM)"
    saveUnder copyFrom:rootView
                     x: area left
                     y: area top
                 width: 1
                height: 1.
!

preDraggingIn:aSourceWidget
    "setup my default values"

    |depth extent widgetsDevice|

    super preDraggingIn:aSourceWidget.

    widgetsDevice    := aSourceWidget device.
    depth     := rootView device depth.
    extent    := dragSize + (2 * (self class additionalSaveSize)).
    saveUnder := Form extent:extent depth:depth onDevice:widgetsDevice.
    tmpForm   := Form extent:extent depth:depth onDevice:widgetsDevice.

    saveUnder clippedByChildren:false.
    tmpForm initGC.
    tmpForm font:(aSourceWidget font).

    "Modified: / 27-05-2007 / 12:48:28 / cg"
!

rereadSaveArea
    saveArea notNil ifTrue:[
        rootView clippedByChildren:false.
        saveUnder copyFrom:rootView 
                         x:saveArea left 
                         y:saveArea top
                       toX:0
                         y:0
                     width:saveArea width  
                    height:saveArea height.
    ].
!

restoreFromSaveArea
    lastRootPoint notNil ifTrue:[
        self dragTo:lastRootPoint
    ].
! !

!DragHandler class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

