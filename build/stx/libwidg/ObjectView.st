"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

View subclass:#ObjectView
	instanceVariableNames:'contents sorted lastButt pressAction releaseAction
		shiftPressAction ctrlPressAction doublePressAction motionAction
		keyPressAction selection gridShown gridPixmap scaleMetric
		dragObject leftHandCursor oldCursor movedObject moveStartPoint
		moveDelta documentFormat canDragOutOfView rootMotion rootView
		aligning gridAlign aligningMove inMotion buttonPressTime'
	classVariableNames:'MIN_DELTA_FOR_MOVE TIME_DELTA_FOR_MOVE'
	poolDictionaries:''
	category:'Views-Basic'
!

!ObjectView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    a View which can hold DisplayObjects, can make selections, move them around etc.
    ObjectView is an abstract class providing common mechanisms 
    (i.e. a whiteBox framework, to be used by concrete subclasses).
    Actual instances are DrawView, DirectoryView, LogicView or DocumentView.

    If you want to use this class, have a special look at the pluggable behavior, especially,
    pressAction, releaseAction etc.:

    [Instance variables:]

        contents        <Collection>            the objects. The order in which
                                                these are in that collection defines
                                                their appearance in the z-plane:
                                                an object located after another one
                                                here will be drawn ABOVE the other.

        sorted          <Boolean>               if set, redraw and picking methods
                                                assume that the objects are sorted by 
                                                >= y-coordinates. These operations are
                                                a bit faster then, since a binary search
                                                can be done. (use with care).

        lastButt        <Point>                 last pointer press position
                                                (internal)

        pressAction     <Block>                 action to perform when mouse pointer
                                                is pressed. Can be set to something like
                                                [self startCreate], [self startSelectOrMove]
                                                etc.

        releaseAction   <Block>                 action to perform when mouse pointer is
                                                released. Typically set in one of the
                                                startXXX methods.

        shiftPressAction        <Block>         like pressAction, if shift key is
                                                pressed.

        doublePressAction       <Block>         same for double-clicks

        motionAction            <Block>         action to perform on mouse-pointer
                                                motion.

        keyPressAction          <Block>         action for keyboard events

        selection               <any>           the current selection; either a single
                                                object or a collection of objects.

        gridShown               <Boolean>       internal

        gridPixmap              <Form>          internal

        scaleMetric             <Symbol>        either #mm or #inch; used to
                                                decide how the grid is defined

        dragObject                              internal

        leftHandCursor                          cursor shown while dragging a rectangle

        oldCursor                               saved original cursor while dragging a rectangle

        movedObject                             internal
        moveStartPoint                          internal
        moveDelta                               internal

        documentFormat          <Symbol>        defines the size and layout of the
                                                document. Can be any of
                                                #letter, #a4, #a3 etc.

        canDragOutOfView        <Boolean>       if true, objects can be dragged out of the
                                                view. If false, dragging is restricted to within
                                                this view.

        rootMotion                              internal
        rootView                                internal

        aligning                <Boolean>       if true, pointer positions are
                                                aligned (snapped) to the point
                                                specified in gridAlign

        gridAlign               <Point>         if aligning is true, this point
                                                defines the snapping. For example,
                                                12@12 defines snap to the nearest
                                                12-point grid.

    written spring/summer 89 by claus

    [author:]
        Claus Gittinger

    [see also:]
        DrawTool LogicTool
        DrawObject
        DisplayObject
"
!

examples
"
    typically, ObjectViews are not used on their own, but instead
    subclassed and thereby provide the common functionality for
    views which show (possibly overlapping) objects.
    The methods here provide all mechanisms to handle redraws, picking
    (i.e. finding an object by position), gridding, moving objects with
    minimum redraw etc.
    Also, zooming and scrolling is handled.
    All objects which respond to the DisplayObject protocol can be handled
    by ObjectView - therefore, you can add almost any object and have it
    displayed and handled here. (as an example, try to copy a LogicGate
    from a LogicView and paste it into a DrawTool - it will work).

    Reminder: ObjectViews are not to be used as below, but instead to be
    subclassed. Therefore, the examples below are somewhat untypical.

    simple example:
                                                                        [exBegin]
        |v o|

        v := ObjectView new.
        v extent:200@200.

        o := DrawRectangle new.
        o origin:10@10 corner:100@100.
        v add:o.

        o := DrawText new.
        o text:'hello there'; origin:50@50; foreground:Color red.
        v add:o.

        v open
                                                                        [exEnd]

    add scrolling:
                                                                        [exBegin]
        |v top o|

        top := HVScrollableView for:ObjectView.
        top extent:200@200.
        v := top scrolledView.

        o := DrawRectangle new.
        o origin:10@10 corner:100@100.
        v add:o.

        o := DrawText new.
        o text:'hello there'; origin:50@50; foreground:Color red.
        v add:o.

        top open
                                                                        [exEnd]

    or, using miniscrollers:
                                                                        [exBegin]
        |v top o|

        top := HVScrollableView for:ObjectView 
                                miniScrollerH:true miniScrollerV:true.
        top extent:200@200.
        v := top scrolledView.

        o := DrawRectangle new.
        o origin:10@10 corner:100@100.
        v add:o.

        o := DrawText new.
        o text:'hello there'; origin:50@50; foreground:Color red.
        v add:o.

        top open
                                                                        [exEnd]

    mix views and displayObjects:
                                                                        [exBegin]
        |v top o|

        top := HVScrollableView for:ObjectView.
        top extent:200@200.
        v := top scrolledView.

        o := DrawLine new.
        o origin:10@10 corner:50@50.
        v add:o.

        o := ClockView in:top.
        o origin:50@50 corner:100@100.
        v add:o.

        top open
                                                                        [exEnd]

    grid:
                                                                        [exBegin]
        |v top o|

        top := HVScrollableView for:ObjectView 
                                miniScrollerH:true miniScrollerV:true.
        top extent:200@200.
        v := top scrolledView.
        v showGrid.

        o := DrawRectangle new.
        o origin:10@10 corner:100@100.
        v add:o.

        o := DrawText new.
        o text:'hello there'; origin:50@50; foreground:Color red.
        v add:o.

        top open
                                                                        [exEnd]

    zoom:
                                                                        [exBegin]
        |v top o|

        top := HVScrollableView for:ObjectView 
                                miniScrollerH:true miniScrollerV:true.
        top extent:200@200.
        v := top scrolledView.
        v showGrid.

        o := DrawRectangle new.
        o origin:10@10 corner:100@100.
        v add:o.

        o := DrawText new.
        o text:'hello there'; origin:50@50; foreground:Color red.
        v add:o.

        top open.

        Delay waitForSeconds:5.
        v zoom:2.

        Delay waitForSeconds:5.
        v zoom:0.35.

        Delay waitForSeconds:5.
        v zoom:1.
                                                                        [exEnd]

   private benchmark: display 10000 objects ...
                                                                        [exBegin]
        |v top o rnd|

        top := HVScrollableView for:ObjectView 
                                miniScrollerH:true miniScrollerV:true.
        top extent:200@200.
        v := top scrolledView.

        rnd := Random new.
        10000 timesRepeat:[
            o := DrawLine new.
            o origin:(rnd nextIntegerBetween:0 and:700) @ (rnd nextIntegerBetween:0 and:700)
              corner:(rnd nextIntegerBetween:0 and:700) @ (rnd nextIntegerBetween:0 and:700).
            v add:o.
        ].

        top openAndWait.

        Transcript showCR:(
            Time millisecondsToRun:[
                v redraw              
            ])
                                                                        [exEnd]
"
! !

!ObjectView class methodsFor:'defaults'!

handleSize
    "size of blob drawn for handles"

    ^ (Screen current horizontalPixelPerMillimeter * 1.2) rounded asInteger
!

hitDelta
    "when clicking an object, allow for hitDelta pixels around object;
     0 is exact; 1*pixelPerMillimeter is good for draw programs"

    ^ 0
!

mouseMotionDeltaForMove
    ^ MIN_DELTA_FOR_MOVE ? 10
!

mouseMotionTimeDeltaForMove
    ^ TIME_DELTA_FOR_MOVE ? 500
! !

!ObjectView methodsFor:'accessing'!

aligning
    ^ aligning
!

aligningMove
    ^ aligningMove
!

aligningMove:aBoolean

    aligningMove == aBoolean ifTrue:[ ^ self ].
    aBoolean ifTrue:[
        aligning == true ifFalse:[ ^ self ].
        gridAlign isNil ifTrue:[ ^ self ].
    ].

    aligningMove := aBoolean
!

contents
    ^ contents

    "Created: / 4.7.1999 / 15:15:15 / cg"
!

gridShown
    ^ gridShown
! !

!ObjectView methodsFor:'accessing-behavior'!

ctrlPressAction:aBlock
    ctrlPressAction := aBlock

    "Created: / 27-10-2006 / 14:06:41 / cg"
!

doublePressAction:aBlock
    doublePressAction := aBlock

    "Created: / 27-10-2006 / 14:06:49 / cg"
!

keyPressAction:aBlock
    keyPressAction := aBlock
!

motionAction:aBlock
    motionAction := aBlock
!

pressAction:aBlock
    pressAction := aBlock

    "Modified: / 27-10-2006 / 14:06:34 / cg"
!

releaseAction:aBlock
    releaseAction := aBlock
!

setDefaultActions
    "setup actions for default behavior (do - nothing)"

    movedObject := nil.
    inMotion := false.
    motionAction := [:movePoint | nil].
    releaseAction := [nil]

    "Modified: / 4.7.1999 / 18:55:01 / cg"
!

shiftPressAction:aBlock
    shiftPressAction := aBlock

    "Created: / 27-10-2006 / 14:06:30 / cg"
! !

!ObjectView methodsFor:'adding & removing'!

add:something
    "add something, anObject or a collection of objects to the contents
     with redraw"

    self forEach:something do:[:anObject |
	self addObject:anObject
    ]
!

addObject:anObject
    "add the argument, anObject to the contents - with redraw"

    anObject notNil ifTrue:[
        contents addLast:anObject.
        self changed:#addObject with:anObject.
        "its on top - only draw this one"
        shown "realized" ifTrue:[
            self showUnselected:anObject
        ]
    ]

    "Modified: / 4.7.1999 / 16:50:24 / cg"
!

addObjectFirst:anObject
    "add the argument, anObject to the beginning of the contents - with redraw"

    anObject notNil ifTrue:[
        contents addFirst:anObject.
        self changed:#addObject.
        "its on top - only draw this one"
        shown "realized" ifTrue:[
            self showUnselected:anObject
        ]
    ]

    "Modified: / 4.7.1999 / 16:50:22 / cg"
!

addObjectFirstWithoutRedraw:anObject
    "add the argument, anObject to the start of the contents - no redraw"

    anObject notNil ifTrue:[
        contents addFirst:anObject.
        self changed:#addObject.
    ]

    "Modified: / 4.7.1999 / 16:50:19 / cg"
!

addObjectWithoutRedraw:anObject
    "add the argument, anObject to the contents - no redraw"

    anObject notNil ifTrue:[
        contents addLast:anObject.
        self changed:#addObject.
    ]

    "Modified: / 4.7.1999 / 16:50:16 / cg"
!

addSelected:something
    "add something, anObject or a collection of objects to the contents
     and select it"

    self add:something.
    self select:something
!

addWithoutRedraw:something
    "add something, anObject or a collection of objects to the contents
     do not redraw"

    self forEach:something do:[:anObject |
	self addObjectWithoutRedraw:anObject
    ]
!

contents:aCollectionOfObjects
    contents := aCollectionOfObjects.
    self invalidate.
!

remove:something
    "remove something, anObject or a collection of objects from the contents
     do redraw"

    something size > (contents size / 4) ifTrue:[
        "
         better to remove first, then redraw rest
        "
        self forEach:something do:[:anObject |
            self removeFromSelection:anObject.
            contents remove:anObject.
            self changed:#removeObject with:anObject.
        ].
        self invalidate.
        ^ self
    ].

    self forEach:something do:[:anObject |
        self removeObject:anObject
    ]

    "Modified: / 4.7.1999 / 16:50:09 / cg"
!

removeAll
    "remove all - redraw"

    self removeAllWithoutRedraw.
    self invalidate

    "Modified: 29.5.1996 / 16:20:28 / cg"
!

removeAllWithoutRedraw
    "remove all - no redraw"

    contents := OrderedCollection new.
    self changed:#removeObject.
    selection notNil ifTrue:[
        selection := nil.
        self changed:#selection.
    ].

    "Modified: / 4.7.1999 / 16:50:43 / cg"
!

removeObject:anObject
    "remove the argument, anObject from the contents - no redraw"

    anObject notNil ifTrue:[
        self removeFromSelection:anObject.
        contents remove:anObject.
        shown "realized" ifTrue:[
            self redrawObjectsIn:(anObject frame)
        ].
        self changed:#removeObject with:anObject.
    ]

    "Modified: / 4.7.1999 / 16:50:49 / cg"
!

removeObjectWithoutRedraw:anObject
    "remove the argument, anObject from the contents - no redraw"

    anObject notNil ifTrue:[
        self removeFromSelection:anObject.
        contents remove:anObject.
        self changed:#removeObject.
    ]

    "Modified: / 4.7.1999 / 16:50:58 / cg"
!

removeWithoutRedraw:something
    "remove something, anObject or a collection of objects from the contents
     do not redraw"

    self forEach:something do:[:anObject |
	self removeObjectWithoutRedraw:anObject
    ]
! !

!ObjectView methodsFor:'cut & paste'!

convertForPaste:anObject
    "return a converted version of anObject to be pasted, or nil if
     the object is not compatible with me.
     Return nil here; concrete subclasses should try to convert.
     Notice: anObject may be a collection of to-be-pasted objects."

    "in concrete subclasses, you can use:"
"
    |s|

    (anObject respondsTo:#asDisplayObject) ifTrue:[
	^ anObject asDisplayObject
    ].
    (anObject isString or:[anObject isMemberOf:Text]) ifTrue:[
    ].
    anObject size > 0 ifTrue:[
	(anObject inject:true into:[:okSoFar :element |
	    okSoFar and:[element respondsTo:#asDisplayObject]
	]) ifFalse:[
	    self warn:'selection not convertable to DisplayObject'.
	    ^ nil
	].
	^ anObject collect:[:element | element asDisplayObject].
    ].
"
    ^ nil.
!

copySelection
    "copy the selection into the cut&paste-buffer"

    |tmp|

    tmp := OrderedCollection new.
    self selectionDo:[:object |
        tmp add:(object copy)
    ].
"/    self forEach:tmp do:[:anObject |
"/        anObject moveTo:(anObject origin + (8 @ 8))
"/    ].
    self setClipboardObject:tmp
!

cutSelection
    "cut the selection into the cut&paste buffer"

    |tmp|

    tmp := selection.
    tmp notNil ifTrue:[
        self unselect.
        self remove:tmp.
        self setClipboardObject:tmp
    ]

    "Created: / 4.7.1999 / 15:07:59 / cg"
    "Modified: / 4.7.1999 / 15:29:50 / cg"
!

deleteSelection
    "delete the selection"

    |tmp|

    tmp := selection.
    tmp notNil ifTrue:[
        self unselect.
        self remove:tmp.
    ].

    ^ tmp
!

paste:something
    "add the objects in the cut&paste-buffer"

    |s|

    s := self convertForPaste:something .
    s isNil ifTrue:[
        self warn:(resources string:'selection not convertable').
        ^ self
    ].
    self unselect.
    self addSelected:s 
!

pasteBuffer
    "add the objects in the paste-buffer"

    |sel|

    sel := self getClipboardObject.
    ((device isX11Platform)
     or:[(device getSelectionOwnerOf:#CLIPBOARD) == self drawableId])
    ifTrue:[
        "
         a local selection - paste with some offset
        "
        sel size > 0 ifTrue:[
            sel := sel collect:[:element |
                element copy moveTo:(element origin + (8 @ 8))
            ]
        ] ifFalse:[
            sel := sel copy moveTo:(sel origin + (8 @ 8))
        ]
    ].
    self paste:sel

    "Modified: / 4.7.1999 / 15:10:46 / cg"
! !

!ObjectView methodsFor:'dragging-line'!

doLineDrag:aPoint
    "do drag a line"

    self invertDragLine.
    dragObject corner:aPoint.
    self invertDragLine.
!

endLineDrag
    "cleanup after line drag; select them. Find the origin and destination
     views and relative offsets, then dispatch to one of the endLineDrag methods.
     These can be redefined in subclasses to allow connect between views."

    |rootPoint viewId offs transformation2
     lastViewId destinationId destinationView destinationPoint 
     inMySelf dragOrigin|

    self invertDragLine.

    self cursor:oldCursor.

    "check if line drag is into another view"
    rootMotion ifTrue:[
        |currentTransformation|

        rootPoint := lastButt.
        "
         get device coordinates
        "
        currentTransformation := gc transformation.
        currentTransformation notNil ifTrue:[
            rootPoint := currentTransformation transformPoint:rootPoint.
        ].

        "
         translate to screen
        "
        offs := device translatePoint:0@0 fromView:self toView:rootView.
        rootPoint := rootPoint + offs.

        "search view the drop is in"
        viewId := rootView id.
        [viewId notNil] whileTrue:[
            destinationId := device viewIdFromPoint:rootPoint in:viewId.
            lastViewId := viewId.
            viewId := destinationId
        ].
        destinationView := device viewFromId:lastViewId.
        destinationId := lastViewId.
        inMySelf := (destinationView == self).
        rootMotion := false
    ] ifFalse:[
        inMySelf := true
    ].

    dragObject isNil ifTrue:[^ self].

    dragOrigin := dragObject origin.
    inMySelf ifTrue:[
        "a simple line within myself"
        self lineDragFrom:dragOrigin to:dragObject corner
    ] ifFalse:[
        "into another one"
        destinationView notNil ifTrue:[
            destinationPoint := device translatePoint:rootPoint fromView:rootView toView:destinationView.
            (transformation2 := destinationView transformation) notNil ifTrue:[
                destinationPoint := transformation2 applyInverseTo:destinationPoint
            ].
            "
             move into another smalltalk view
            "
            self lineDragFrom:dragOrigin to:destinationPoint in:destinationView
        ] ifFalse:[
            "
             not one of my views
            "
            self lineDragFrom:dragOrigin to:destinationPoint inAlienViewId:destinationId
        ] 
    ].
    self setDefaultActions.
    dragObject := nil

    "Modified: / 10.10.2001 / 14:41:52 / cg"
!

invertDragLine
    "helper for line dragging - invert the dragged line.
     Extracted for easier redefinition in subclasses
     (different line width etc.)"

    |dragger offs p1 p2|

    dragObject isNil ifTrue:[^ self].

    p1 := dragObject origin.
    p2 := dragObject corner.
    rootMotion ifTrue:[
        |currentTransformation|

        dragger := rootView.
        "
         get device coordinates
        "
        currentTransformation := gc transformation.
        currentTransformation notNil ifTrue:[
            p1 := currentTransformation transformPoint:p1.
            p2 := currentTransformation transformPoint:p2.
        ].
        "
         translate to screen
        "
        offs := device translatePoint:0@0 fromView:self toView:rootView.
        p1 := p1 + offs.
        p2 := p2 + offs.
    ] ifFalse:[
        dragger := self.
    ].

    dragger xoring:[
        dragger lineWidth:0. 
        dragger displayLineFrom:p1 to:p2.
        dragger flush
    ].

    "Modified: / 10.10.2001 / 13:59:05 / cg"
!

lineDragFrom:startPoint to:endPoint
    "this is called after a line-drag. Nothing is done here.
     - should be redefined in subclasses"

    ^ self
!

lineDragFrom:startPoint to:endPoint in:destinationView
    "this is called after a line-drag crossing view boundaries.
     - should be redefined in subclasses"

    ^ self notify:'don''t know how to connect to external views'
!

lineDragFrom:startPoint to:endPoint inAlienViewId:destinationId
    "this is called after a line-drag with rootmotion set
     to true, IFF the endpoint is in an alien view
     - should be redefined in subclasses"

    self notify:'cannot connect object in alien view'
!

setLineDragActions
    "setup to drag a line. Call this (for example) from your buttonPress
     method, to make the view start to drag a line.
     See startLineDrag and startRootLineDrag."

    motionAction := [:movePoint | self doLineDrag:movePoint].
    releaseAction := [self endLineDrag]
!

startLineDrag:startPoint
    "start a line drag within the view"

    self setLineDragActions.
    dragObject := Rectangle origin:startPoint corner:startPoint.
    self invertDragLine.
    oldCursor := cursor.
    self cursor:leftHandCursor
!

startRootLineDrag:startPoint
    "start a line drag possibly crossing my view boundaries"

    self setLineDragActions.
    rootMotion := true.
    dragObject := Rectangle origin:startPoint corner:startPoint.
    self invertDragLine.
    oldCursor := cursor.
    self cursor:leftHandCursor
! !

!ObjectView methodsFor:'dragging-object'!

doObjectMove:aPoint
    "do an object move - this is called for every motion
     when moving objects."

    |d org nOrg|

    movedObject isNil ifTrue:[
        movedObject := selection.
        "
         draw first outline
        "
        movedObject notNil ifTrue:[
            moveDelta := 0@0.

            "tricky, the moved object may not currently be aligned.
             if so, simulate a frame move of the delta"

            aligningMove ifTrue:[
                org := movedObject origin.
                d := org - (self alignToGrid:(org)).
                moveDelta := d negated.
            ].
            self invertDragObject:movedObject delta:moveDelta    
        ]
    ].
    moveStartPoint notNil ifTrue:[
        movedObject notNil ifTrue:[
            d := aPoint - moveStartPoint.
            aligningMove ifTrue:[
                org := movedObject origin.
                nOrg := org + d.
                d :=  (self alignToGrid:(nOrg)) - org.
            ].
            d ~= moveDelta ifTrue:[
                "
                 clear prev outline,
                 draw new outline
                "
                self invertDragObject:movedObject delta:moveDelta.    
                moveDelta :=  d.
                self invertDragObject:movedObject delta:moveDelta    
            ]
        ]
    ].
!

endObjectMove
    "cleanup after object move - called when the object move ends.
     Find the destination view and position and dispatch to
     one of the moveObjectXXX-methods which should do the real move. 
     These can be redefined in subclasses."

    |inMySelf rootPoint destinationPoint p transformation2
     viewId destinationView destinationId lastViewId|

    movedObject notNil ifTrue:[
        self invertDragObject:movedObject delta:moveDelta.    

        "check if object is to be put into another view"
        rootMotion ifTrue:[
            |currentTransformation|

            p := lastButt.
            "
             get device coordinates
            "
            currentTransformation := gc transformation.
            currentTransformation notNil ifTrue:[
                p := currentTransformation transformPoint:p.
            ].
            "
             translate to screen
            "
            rootPoint := p + (device translatePoint:0@0 fromView:self toView:rootView).

            "search view the drop is in"
            viewId := rootView id.
            [viewId notNil] whileTrue:[
                destinationId := device viewIdFromPoint:rootPoint in:viewId.
                lastViewId := viewId.
                viewId := destinationId
            ].
            destinationView := device viewFromId:lastViewId.
            destinationId := lastViewId.
            inMySelf := (destinationView == self).
            rootMotion := false
        ] ifFalse:[
            inMySelf := true
        ].

        inMySelf ifTrue:[
            "simple move"
            self move:movedObject by:moveDelta
        ] ifFalse:[
            destinationPoint := device translatePoint:rootPoint        "/ use id here - could be alian view
                                                 from:(rootView id) 
                                                   to:destinationId.
            destinationView notNil ifTrue:[
                (transformation2 := destinationView transformation) notNil ifTrue:[
                    destinationPoint := transformation2 applyInverseTo:destinationPoint
                ].
                "
                 move into another smalltalk view
                "
                self move:movedObject to:destinationPoint in:destinationView
            ] ifFalse:[
                "
                 not one of my views
                "
                self move:movedObject to:destinationPoint inAlienViewId:destinationId
            ] 
        ].
        self setDefaultActions.
        movedObject := nil.
    ]

    "Modified: / 10.10.2001 / 14:43:09 / cg"
!

invertDragObject:movedObject delta:moveDelta
    "draw inverting for an object move"

    |dragger offs p d scale oldTrans|

    rootMotion ifTrue:[
        |currentTransformation|
        p := movedObject origin + moveDelta.
        dragger := rootView.
        "
         get device coordinates
        "
        currentTransformation := gc transformation.
        currentTransformation notNil ifTrue:[
            scale := currentTransformation scale.
            p := currentTransformation transformPoint:p.
        ].
        "
         translate to screen
        "
        offs := device translatePoint:0@0 fromView:self toView:rootView.
        p := p + offs.
        "
         p is where we want it ...
         have to adust slightly, since showDragging shows the object
         at its origin plus some offset; here we want it to be drawn
         at absolute p.
         To do so, we set the draggers translation to p and
         draw the object scaled at 0@0 (by setting offset to its negative org)
        "

        oldTrans := dragger transformation.
        dragger transformation:(WindowingTransformation 
                                        scale:scale
                                        translation:p).
        d := movedObject origin negated.

        dragger xoring:[
            self showDragging:movedObject offset:d.
        ].

        dragger transformation:oldTrans.
        dragger flush.
    ] ifFalse:[
        self xoring:[
            self showDragging:movedObject offset:moveDelta.
        ].
        self flush
    ].

    "Modified: / 10.10.2001 / 13:59:19 / cg"
!

setMoveActions
    "setup to drag an object. Call this (for example) from your buttonPress
     method, to make the view start to drag some object.
     See startObjectMove and startRootObjectMove."

    |didStartMove|

    didStartMove := false.
    motionAction := [:movePoint | 
                        didStartMove := true. 
                        self doObjectMove:movePoint
                    ].
    releaseAction := [ didStartMove 
                        ifTrue:[ self endObjectMove ] 
                        ifFalse:[self setDefaultActions]
                     ]
!

startObjectMove:something at:aPoint
    "start an object move"

    self startObjectMove:something at:aPoint inRoot:canDragOutOfView 
!

startObjectMove:something at:aPoint inRoot:inRoot
    "start an object move; if inRoot is true, view
     boundaries may be crossed."

    something notNil ifTrue:[
        (self canSelect:something) ifTrue:[
            self select:something.
            (self canMove:something) ifTrue:[
                self setMoveActions.
                moveStartPoint := aPoint.
                rootMotion := inRoot.
            ] ifFalse:[
                self setDefaultActions
            ]
        ] ifFalse:[
            self setDefaultActions
        ]
    ]

    "Modified: / 27-10-2006 / 14:32:12 / cg"
!

startRootObjectMove:something at:aPoint
    "start an object move, possibly crossing view boundaries"

    self startObjectMove:something at:aPoint inRoot:true 
! !

!ObjectView methodsFor:'dragging-rectangle'!

doRectangleDrag:aPoint
    "do drag a rectangle"

    self invertDragRectangle.
    dragObject corner:aPoint.
    self invertDragRectangle.
!

endRectangleDrag
    "cleanup after rectangle drag; select them"

    self invertDragRectangle.
    self cursor:oldCursor.
    dragObject width < 0 ifTrue:[
        dragObject 
                origin:(dragObject origin + (dragObject width@0))
                corner:(dragObject corner - (dragObject width@0))
    ].
    dragObject height < 0 ifTrue:[
        dragObject 
                origin:(dragObject origin + (0@dragObject height))
                corner:(dragObject corner - (0@dragObject height))
    ].
    self selectAllIn:dragObject.

    releaseAction := nil.

    "Modified: / 27-10-2006 / 14:21:11 / cg"
!

invertDragRectangle
    "helper for rectangle drag - invert the dragRectangle.
     Extracted into a separate method to allow easier redefinition
     (different lineWidth etc)"

    gc clippedByChildren:false.

    gc xoring:[
        gc lineWidth:0. 
"/        self lineStyle:#dashed.
        gc displayRectangle:dragObject.
"/        self lineStyle:#solid.
    ].

    gc clippedByChildren:true.

    "Modified: 3.6.1996 / 10:02:22 / cg"
!

setRectangleDragActions
    "setup to drag a rectangle. Call this (for example) from your buttonPress
     method, to make the view start the drag.
     See startRectangleDrag:."

    motionAction := [:movePoint | self doRectangleDrag:movePoint].
    releaseAction := [self endRectangleDrag]
!

startRectangleDrag:startPoint
    "start a rectangle drag"

    lastButt := startPoint.
    self setRectangleDragActions.
    dragObject := Rectangle origin:startPoint corner:startPoint.
    self invertDragRectangle.
    oldCursor := cursor.
    self cursor:leftHandCursor
! !

!ObjectView methodsFor:'drawing'!

redraw
    "redraw complete View"

    shown ifTrue:[
        self clearView.
        self redrawObjects
    ]
!

redrawObjects
    "redraw all objects"

    self redrawObjectsOn:self
!

redrawObjectsAbove:anObject in:aRectangle
    "redraw all objects which have part of themselfes in aRectangle
     and are above (in front of) anObject.
     draw only in (i.e. clip output to) aRectangle"

    |vis oldClip|

    shown ifTrue:[
        vis := aRectangle.
        oldClip := self clippingBoundsOrNil.
        oldClip notNil ifTrue:[
            vis := vis intersect:oldClip
        ].
        self clippingBounds:vis.

        self redrawObjectsAbove:anObject intersecting:vis.

        self clippingBounds:oldClip
    ]

    "Modified: 28.5.1996 / 19:57:06 / cg"
!

redrawObjectsAbove:anObject inVisible:aRectangle
    "redraw all objects which have part of themselfes in a vis rectangle
     and are above (in front of) anObject.
     draw only in (i.e. clip output to) aRectangle"

    |vis oldClip|

    shown ifTrue:[
        vis := aRectangle.
        oldClip := self clippingBoundsOrNil.
        oldClip notNil ifTrue:[
            vis := vis intersect:oldClip
        ].
        self clippingBounds:vis.

        self redrawObjectsAbove:anObject intersectingVisible:vis.

        self clippingBounds:oldClip
    ]

    "Modified: 28.5.1996 / 19:56:44 / cg"
!

redrawObjectsAbove:anObject intersecting:aRectangle
    "redraw all objects which have part of themself in aRectangle
     and are above (in front of) anObject"

    self objectsAbove:anObject intersecting:aRectangle do:[:theObject |
	self show:theObject
    ]
!

redrawObjectsAbove:anObject intersectingVisible:aRectangle
    "redraw all objects which have part of themself in a vis rectangle
     and are above (in front of) anObject"

    self objectsAbove:anObject intersectingVisible:aRectangle do:[:theObject |
	self show:theObject
    ]
!

redrawObjectsIn:aRectangle
    "redraw all objects which have part of themselfes in aRectangle
     draw only in (i.e. clip output to) aRectangle"

    |visRect oldClip|

    shown ifTrue:[
        visRect := Rectangle origin:(aRectangle origin)
                             extent:(aRectangle extent).
"/        transformation notNil ifTrue:[
            visRect := visRect origin truncated
                       corner:(visRect corner + (1@1)) truncated.
"/        ].
        oldClip := self clippingBoundsOrNil.
        oldClip notNil ifTrue:[
            visRect := visRect intersect:oldClip
        ].
        self clippingBounds:visRect.

        self clearRectangle:visRect.
        self redrawObjectsIntersecting:visRect.

        self clippingBounds:oldClip
    ]

    "Modified: 28.5.1996 / 19:56:20 / cg"
!

redrawObjectsInVisible:visRect
    "redraw all objects which have part of themselfes in a vis rectangle
     draw only in (i.e. clip output to) aRectangle"

    |vis oldClip|

    shown ifTrue:[
        vis := visRect.
        oldClip := self clippingBoundsOrNil.
        oldClip notNil ifTrue:[
            vis := vis intersect:oldClip
        ].

        gc transformation notNil ifTrue:[
"/            gc transformation scale ~~ 1 ifTrue:[
                vis := vis origin truncated
                           corner:(vis corner + (1@1)) truncated.
"/            ]
        ].

        self clippingBounds:vis.

        "/ no clear background; already done in redrawX:y:width:height:
        "/ self clearRectangle:vis.

        self redrawObjectsIntersecting:vis.

        self clippingBounds:oldClip
    ]

    "Modified: 28.5.1996 / 19:55:47 / cg"
!

redrawObjectsIntersecting:aRectangle
    "redraw all objects which have part of themself in aRectangle"

    self objectsIntersecting:aRectangle do:[:theObject |
	self show:theObject
    ]
!

redrawObjectsIntersectingVisible:aRectangle
    "redraw all objects which have part of themself in a vis rectangle
     This is a leftOver from times when scrolling was not transparent.
     Please use redrawObjectsIntersecting:, since this will vanish."

    self redrawObjectsIntersecting:aRectangle
!

redrawObjectsOn:aGC
    "redraw all objects on a graphic context"

    |vFrame|

    (aGC == self) ifTrue:[
        |currentTransformation|

        shown ifFalse:[^ self].
        vFrame := Rectangle left:0 top:0 width:width height:height.

        currentTransformation := gc transformation.
        currentTransformation notNil ifTrue:[
            vFrame := currentTransformation applyInverseTo:vFrame.
        ].
        self redrawObjectsIntersecting:vFrame
    ] ifFalse:[
        "should loop over pages"

        vFrame := Rectangle left:0 top:0 width:9999 height:9999.

        self objectsIntersecting:vFrame do:[:theObject |
            theObject drawIn:aGC
        ]
    ]

    "Modified: 8.5.1996 / 21:01:27 / cg"
!

redrawScale
    "redraw the scales"

    self redrawHorizontalScale.
    self redrawVerticalScale
!

show:anObject
    "show the object, either selected or not"

    (self isSelected:anObject) ifTrue:[
	self showSelected:anObject
    ] ifFalse:[
	self showUnselected:anObject
    ]
!

showDragging:something offset:anOffset
    "show an object while dragging"

    |drawer|

    rootMotion ifTrue:[
	"drag in root-window"

	drawer := rootView
    ] ifFalse:[
	drawer := self
    ].
    self forEach:something do:[:anObject |
	anObject drawDragIn:drawer offset:anOffset
    ]
!

showSelected:anObject
    "show an object as selected"

    anObject drawSelectedIn:self
!

showUnselected:anObject
    "show an object as unselected"

    anObject isView ifFalse:[
        anObject drawIn:self
    ]
! !

!ObjectView methodsFor:'enumerating'!

contentsDo:aBlock
    contents do:aBlock
! !

!ObjectView methodsFor:'event handling'!

buttonCtrlPress:button x:x y:y
    "user pressed left button with ctrl"

    ctrlPressAction notNil ifTrue:[
        ctrlPressAction value:lastButt.
    ]
!

buttonMotion:buttonState x:buttX y:buttY
    "user moved mouse while button pressed"

    |xpos ypos movePoint limitW limitH minDeltaForMotion currentTransformation|

    "is it the select or 1-button ?"
    buttonState == 0 ifTrue:[^ self].
    self sensor leftButtonPressed ifFalse:[^ self].

    lastButt notNil ifTrue:[
        xpos := buttX.
        ypos := buttY.

        "check against visible limits if move outside is not allowed"
        rootMotion ifFalse:[
            limitW := width.
            limitH := height.
            currentTransformation := gc transformation.
            currentTransformation notNil ifTrue:[
                limitW := currentTransformation applyInverseToX:width.
                limitH := currentTransformation applyInverseToY:height.
            ].

            (xpos < 0) ifTrue:[                    
                xpos := 0
            ] ifFalse: [
                (xpos > limitW) ifTrue:[xpos := limitW]
            ].
            (ypos < 0) ifTrue:[                    
                ypos := 0
            ] ifFalse: [
                (ypos > limitH) ifTrue:[ypos := limitH]
            ]
        ].

        movePoint := xpos @ ypos.

        "/ if the motion is more than mouseMotionDeltaForMove
        "/ or the time-delta is longer than timeDeltaForMove
        buttonPressTime notNil ifTrue:[
            (Timestamp now millisecondDeltaFrom:buttonPressTime) > self class mouseMotionTimeDeltaForMove ifFalse:[
                inMotion == true ifTrue:[
                    minDeltaForMotion := 1
                ] ifFalse:[
                    minDeltaForMotion := self class mouseMotionDeltaForMove
                ].
                currentTransformation := gc transformation.
                currentTransformation notNil ifTrue:[
                    minDeltaForMotion := currentTransformation applyInverseToX:minDeltaForMotion.
                ].
                ((xpos - (lastButt x)) abs < minDeltaForMotion
                and:[ (ypos - (lastButt y)) abs < minDeltaForMotion]) ifTrue:[
                    ^ self      "no (ignored) move"
                ].
            ].
        ].

        motionAction notNil ifTrue:[
            self sensor motionEventPending ifFalse:[
                inMotion := true.
                motionAction value:movePoint.
                lastButt := movePoint.
            ].
            ^ self
        ].
        lastButt := movePoint
    ].
    super buttonMotion:buttonState x:buttX y:buttY

    "Modified: / 28.7.1998 / 16:01:31 / cg"
!

buttonMultiPress:button x:x y:y
    "user pressed left button twice (or more)"

    (button == 1) ifTrue:[
        doublePressAction notNil ifTrue:[
            doublePressAction value:(x @ y).
            ^ self
        ]
    ].
    super buttonMultiPress:button x:x y:y

    "Modified: 30.5.1996 / 17:57:36 / cg"
!

buttonPress:button x:x y:y
    "user pressed left button"

    |sensor|

    (button == 1) ifTrue:[
        lastButt := x @ y.
        buttonPressTime := Timestamp now.
        sensor := self sensor.
        sensor shiftDown ifTrue:[
            ^ self buttonShiftPress:button x:x y:y
        ].
        sensor ctrlDown ifTrue:[
            ^ self buttonCtrlPress:button x:x y:y
        ].

        pressAction notNil ifTrue:[
            pressAction value:lastButt.
            ^ self
        ]
    ].
    super buttonPress:button x:x y:y

    "Modified: 1.8.1996 / 19:13:01 / cg"
!

buttonRelease:button x:x y:y
    inMotion := false.

    (button == 1) ifTrue:[
        releaseAction notNil ifTrue:[
            releaseAction value.
            ^ self
        ]
    ].
    super buttonRelease:button x:x y:y

    "Modified: 30.5.1996 / 17:57:13 / cg"
!

buttonShiftPress:button x:x y:y
    "user pressed left button with shift"

    shiftPressAction notNil ifTrue:[
        shiftPressAction value:lastButt.
    ]

    "Modified: 1.8.1996 / 19:13:19 / cg"
!

keyPress:key x:x y:y
    keyPressAction notNil ifTrue:[
        selection notNil ifTrue:[
            self selectionDo: [:obj |
                obj keyInput:key .
            ]
        ].
        ^ self.
    ].
    super keyPress:key x:x y:y

    "Modified: 30.5.1996 / 17:57:54 / cg"
!

redrawX:x y:y width:w height:h
    |redrawFrame |

"/    self clearRectangle:redrawFrame.
    super redrawX:x y:y width:w height:h.

    ((contents size ~~ 0) or:[gridShown]) ifTrue:[
        redrawFrame := Rectangle left:x top:y width:w height:h.
        self redrawObjectsInVisible:redrawFrame
    ]

    "Modified: 5.6.1996 / 10:42:19 / cg"
! !

!ObjectView methodsFor:'focus control'!

wantsFocusWithPointerEnter
    ^ UserPreferences current focusFollowsMouse ~~ false


! !

!ObjectView methodsFor:'grid manipulation'!

alignOff
    "do no align point to grid"

    aligning := false
!

alignOn
    "align points to grid"

    aligning := true.
    self getAlignParameters
!

defineGrid
    "define the grid pattern - this creates the gridPixmap, which is
     used as viewBackground when a grid is to be shown.
     The grid is specified by the value returned from gridParameters,
     which can be redefined in subclasses. See the comment there on how
     the numbers are interpreted."

    |mmH mmV params showDocumentBoundary gridW gridH 
     bigStepH bigStepV littleStepH littleStepV hires 
     devPixmap colorMap fg bg currentTransformation|

    mmH := self horizontalPixelPerMillimeter.
    mmV := self verticalPixelPerMillimeter.
    hires := self horizontalPixelPerInch > 120.

    params := self gridParameters.

    bigStepH := params at:1.
    bigStepV := params at:2.
    littleStepH := params at:3.
    littleStepV := params at:4.
    showDocumentBoundary := params at:7.
    fg := self blackColor.
    bg := self whiteColor.
    params size >= 8 ifTrue:[
        bg := params at:8.
        params size >= 9 ifTrue:[
            fg := params at:9.
        ].
    ].

    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
        mmH := mmH * currentTransformation scale x.
        mmV := mmV * currentTransformation scale y.
        bigStepH := bigStepH * currentTransformation scale x.
        bigStepV := bigStepV * currentTransformation scale y.
        littleStepH notNil ifTrue:[
            littleStepH := littleStepH * currentTransformation scale x.
        ].
        littleStepV notNil ifTrue:[
            littleStepV := littleStepV * currentTransformation scale y.
        ].
    ].

    bigStepH isNil ifTrue:[^ self].

    gridW := (self widthOfContentsInMM * mmH).
    gridH := (self heightOfContentsInMM * mmV).

    self withWaitCursorDo:[
        |xp yp y x|

        (bigStepH isInteger 
            and:[ (littleStepH isNil or:[littleStepH isInteger])
            and:[ bigStepV isInteger 
            and:[ littleStepV isNil or:[littleStepV isInteger]]]]
        ) ifTrue:[
            gridW := bigStepH.
            littleStepH notNil ifTrue:[gridW := gridW max:littleStepH].
            gridH := bigStepV.
            littleStepV notNil ifTrue:[gridH := gridH max:littleStepV].
        ] ifFalse:[

            "
             up to next full unit
            "
            gridW := (((gridW // bigStepH) + 1) * bigStepH) asInteger.
            gridH := (((gridH // bigStepV) + 1) * bigStepV) asInteger.
        ].

        gridPixmap := Form width:gridW height:gridH depth:1.
        gridPixmap colorMap:(Array with:bg with:fg).
        gridPixmap clear.
        gridPixmap paint:(Color colorId:1).

        "draw first row point-by-point"
        yp := 0.0.
        xp := 0.0.
        y := yp asInteger.
        [xp <= gridW] whileTrue:[
            x := xp rounded.
            hires ifTrue:[
                gridPixmap displayPointX:(x + 1) y:y.
                gridPixmap displayPointX:(x + 2) y:y
            ].
            gridPixmap displayPointX:x y:y.
            littleStepH notNil ifTrue:[
                xp := xp + littleStepH
            ] ifFalse:[
                xp := xp + bigStepH
            ]
        ].

        "copy rest from what has been drawn already"
        yp := yp + bigStepV.
        [yp <= gridH] whileTrue:[
            y := yp rounded.
            hires ifTrue:[
                gridPixmap copyFrom:gridPixmap x:0 y:0 
                                             toX:0 y:(y + 1)
                                           width:gridW height:1.
                gridPixmap copyFrom:gridPixmap x:0 y:0 
                                             toX:0 y:(y + 2)
                                           width:gridW height:1
            ].
            gridPixmap copyFrom:gridPixmap x:0 y:0 
                                         toX:0 y:y
                                       width:gridW height:1.
            yp := yp + bigStepV
        ].

        "draw first col point-by-point"
        xp := 0.0.
        yp := 0.0.
        x := xp asInteger.
        [yp <= gridH] whileTrue:[
            y := yp rounded.
            hires ifTrue:[
                gridPixmap displayPointX:x y:(y + 1).
                gridPixmap displayPointX:x y:(y + 2)
            ].
            gridPixmap displayPointX:x y:y.
            littleStepV notNil ifTrue:[
                yp := yp + littleStepV
            ] ifFalse:[
                yp := yp + bigStepV
            ]
        ].

        "copy rest from what has been drawn already"
        xp := xp + bigStepH.
        [xp <= gridW] whileTrue:[
            x := xp rounded.
            hires ifTrue:[
                gridPixmap copyFrom:gridPixmap x:0 y:0 
                                             toX:(x + 1) y:0
                                           width:1 height:gridH.
                gridPixmap copyFrom:gridPixmap x:0 y:0 
                                             toX:(x + 2) y:0
                                           width:1 height:gridH
            ].
            gridPixmap copyFrom:gridPixmap x:0 y:0 
                                         toX:x y:0
                                       width:1 height:gridH.
            xp := xp + bigStepH
        ].

        showDocumentBoundary ifTrue:[
             "
             mark the right-end and bottom of the document
            "
            gridPixmap displayLineFromX:gridW-1 y:0 toX:gridW-1 y:gridH-1.
            gridPixmap displayLineFromX:0 y:gridH-1 toX:gridW-1 y:gridH-1.
        ].

        device isWindowsPlatform ifTrue:[
            "/ kludge - needs a deep form
            colorMap := gridPixmap colorMap.
            devPixmap := Form width:gridW height:gridH depth:device depth onDevice:device.
            devPixmap notNil ifTrue:[
                devPixmap paint:(colorMap at:1).
                devPixmap fillRectangleX:0 y:0 width:gridW height:gridH.
                devPixmap foreground:(colorMap at:2) background:(colorMap at:1).
                devPixmap copyPlaneFrom:gridPixmap x:0 y:0 toX:0 y:0 width:gridW height:gridH.
                gridPixmap := devPixmap.
            ]
        ].
    ]

    "Modified: / 6.6.1999 / 01:00:16 / cg"
!

getAlignParameters
    |params|

    params := self gridParameters.
    gridAlign := (params at:5) @ (params at:6)
!

gridParameters
    "used by defineGrid, and in a separate method for
     easier redefinition in subclasses. 
     Returns the grid parameters in an array of 7 elements,
     which control the appearance of the grid-pattern.
     the elements are:

        bigStepH        number of pixels horizontally between 2 major steps
        bigStepV        number of pixels vertically between 2 major steps
        littleStepH     number of pixels horizontally between 2 minor steps
        littleStepV     number of pixels vertically between 2 minor steps
        gridAlignH      number of pixels for horizontal grid align (pointer snap)
        gridAlignV      number of pixels for vertical grid align (pointer snap)
        docBounds       true, if document boundary should be shown
        bgColor         grid bg-color [optional]
        fgColor         grid fg-color [optional]

     if littleStepH/V are nil, only bigSteps are drawn.
    "

    |mmH mmV bigStepH bigStepV littleStepH littleStepV arr currentTransformation|

    "example: 12grid & 12snapIn"
"/    ^ #(12 12 nil nil 12 12 false).

    "example: 12grid & 24snapIn"
"/    ^ #(12 12 nil nil 24 24 false).

    "default: cm/mm grid & mm snapIn for metric,
     1inch , 1/8inch grid & 1/8 inch snapIn"

    mmH := self horizontalPixelPerMillimeter.
    mmV := self verticalPixelPerMillimeter.
    currentTransformation := gc transformation.

    "
     metric grid: small steps every millimeter, big step every
     centimeter. If the transformation is shrinking, turn off little
     steps.
    "
    (scaleMetric == #mm) ifTrue:[
        "dots every mm; lines every cm"
        bigStepH := mmH * 10.0.
        bigStepV := mmV * 10.0.
        (currentTransformation notNil
        and:[currentTransformation scale <= 0.5]) ifFalse:[
            littleStepH := mmH.
            littleStepV := mmV
        ]
    ].
    "
     inch grid: small steps every 1/8th inch, big step every half inch
     If the transformation is shrinking, change little steps to 1/th inch
     or even turn them off completely.
    "
    (scaleMetric == #inch) ifTrue:[
        "dots every eights inch; lines every half inch"
        bigStepH := mmH * (25.4 / 2).
        bigStepV := mmV * (25.4 / 2).
        (currentTransformation notNil
        and:[currentTransformation scale <= 0.5]) ifTrue:[
            currentTransformation scale > 0.2 ifTrue:[
                littleStepH := mmH * (25.4 / 4).
                littleStepV := mmV * (25.4 / 4)
            ]
        ] ifFalse:[
            littleStepH := mmH * (25.4 / 8).
            littleStepV := mmV * (25.4 / 8)
        ]
    ].

    arr := Array new:9.
    arr at:1 put:bigStepH.
    arr at:2 put:bigStepV.
    arr at:3 put:littleStepH.
    arr at:4 put:littleStepV.
    arr at:5 put:littleStepH.
    arr at:6 put:littleStepV.
    arr at:7 put:false.
    arr at:8 put:self whiteColor.
    arr at:9 put:self blackColor.

    ^ arr
!

hideGrid
    "hide the grid"

    gridShown := false.
    self newGrid
!

newGrid
    "define a new grid - this is a private helper which has to be
     called after any change in the grid. It (re)creates the gridPixmap,
     clears the view and redraws all visible objects."

    |params bg|

    gridPixmap := nil.
    shown ifTrue:[
        params := self gridParameters.
        bg := self whiteColor.
        params size >= 8 ifTrue:[
            bg := params at:8.
        ].

        self viewBackground:bg.
        self clearView.
    ].

    gridShown ifTrue:[
        self defineGrid.
        self viewBackground:gridPixmap.
    ].

    self invalidate

    "Modified: 29.5.1996 / 16:20:11 / cg"
!

showGrid
    "show the grid. The grid is defined by the return value of
     gridParameters, which can be redefined in concrete subclasses."

    gridShown := true.
    self newGrid
! !

!ObjectView methodsFor:'initialization'!

initEvents
"/    self backingStore:true.
!

initialize
    super initialize.

    viewBackground := self whiteColor.

    bitGravity := #NorthWest.
    contents := OrderedCollection new.
    gridShown := false.

    canDragOutOfView := false.
    rootView := device rootView.
    rootView clippedByChildren:false.
    rootMotion := false.
    self setInitialDocumentFormat.

    leftHandCursor := Cursor leftHand.
    sorted := false.
    aligning := false.
    aligningMove := false.
    inMotion := false.

    "Modified: 20.1.1997 / 20:41:10 / cg"
!

setInitialDocumentFormat
    (UserPreferences current languageTerritory == #us) ifTrue:[
        documentFormat := 'letter'.
        scaleMetric := #inch
    ] ifFalse:[
        documentFormat := 'a4'.
        scaleMetric := #mm
    ].
! !

!ObjectView methodsFor:'layout manipulation'!

alignBottom:something
    |botMost|

    botMost := -999999.
    self forEach:something do:[:anObject |
	botMost := botMost max:(anObject frame bottom)
    ].
    self withSelectionHiddenDo:[
	self forEach:something do:[:anObject |
	    self moveObject:anObject to:(anObject frame left)
					@
					(botMost - (anObject frame height))
	]
    ]
!

alignHorizontal:something
    "align selection along their center horizontally"

    |topMost bottomMost h|

    topMost := 999999.
    bottomMost := -999999.
    self forEach:something do:[:anObject |
        |f|
        f := anObject frame.
        topMost := topMost min:(f top).
        bottomMost := bottomMost max:(f bottom).
    ].
    h := bottomMost - topMost.

    self withSelectionHiddenDo:[
        self forEach:something do:[:anObject |
            self moveObject:anObject 
                         to:(anObject frame left)
                            @
                            (topMost + ((h - anObject frame height) // 2))
        ]
    ]

    "Created: 4.6.1996 / 20:01:19 / cg"
    "Modified: 4.6.1996 / 21:19:48 / cg"
!

alignLeft:something
    |leftMost|

    leftMost := 999999.
    self forEach:something do:[:anObject |
	leftMost := leftMost min:(anObject frame left)
    ].
    self withSelectionHiddenDo:[
	self forEach:something do:[:anObject |
	    self moveObject:anObject to:(leftMost @ (anObject frame top))
	]
    ]
!

alignRight:something
    |rightMost|

    rightMost := -999999.
    self forEach:something do:[:anObject |
	rightMost := rightMost max:(anObject frame right)
    ].
    self withSelectionHiddenDo:[
	self forEach:something do:[:anObject |
	    self moveObject:anObject to:(rightMost - (anObject frame width))
					 @ (anObject frame top)
	]
    ]
!

alignTop:something
    |topMost|

    topMost := 999999.
    self forEach:something do:[:anObject |
	topMost := topMost min:(anObject frame top)
    ].
    self withSelectionHiddenDo:[
	self forEach:something do:[:anObject |
	    self moveObject:anObject to:((anObject frame left) @ topMost)
	]
    ]
!

alignVertical:something
    "align selection along their center vertically"

    |leftMost rightMost w|

    leftMost := 999999.
    rightMost := -999999.
    self forEach:something do:[:anObject |
        |f|
        f := anObject frame.
        rightMost := rightMost max:(f right).
        leftMost := leftMost min:(f left).
    ].
    w := rightMost - leftMost.

    self withSelectionHiddenDo:[
        self forEach:something do:[:anObject |
            self moveObject:anObject 
                         to:(leftMost + ((w - anObject frame width) // 2))
                            @
                            (anObject frame top)
        ]
    ]

    "Created: 4.6.1996 / 19:59:16 / cg"
    "Modified: 4.6.1996 / 21:19:58 / cg"
!

move:something by:delta
    "change the position of something, an Object or Collection 
     by delta, aPoint"

    (delta x == 0) ifTrue:[
	(delta y == 0) ifTrue:[^ self]
    ].

    self forEach:something do:[:anObject |
	self moveObject:anObject by:delta
    ]
!

move:something to:aPoint in:aView
    "can only happen when dragOutOfView is true
     - should be redefined in subclasses"

    self notify:'cannot move object(s) out of view'
!

move:something to:aPoint inAlienViewId:aViewId
    "can only happen when dragOutOfView is true
     - should be redefined in subclasses"

    self notify:'cannot move object(s) to alien views'
!

moveObject:anObject by:delta
    "change the position of anObject by delta, aPoint"

    self moveObject:anObject to:(anObject origin + delta)
!

moveObject:anObject to:newOrigin
    "move anObject to newOrigin, aPoint"

    |oldOrigin oldFrame newFrame 
     objectsIntersectingOldFrame objectsIntersectingNewFrame 
     wasObscured isObscured intersects
     oldLeft oldTop w h newLeft newTop griddedNewOrigin clip|

    anObject isNil ifTrue:[^ self].
    anObject canBeMoved ifFalse:[^ self].

    griddedNewOrigin := self alignToGrid:newOrigin.
    oldOrigin := anObject origin.
    (oldOrigin = griddedNewOrigin) ifTrue:[^ self].

    oldFrame := self frameOf:anObject.
    objectsIntersectingOldFrame := self objectsIntersecting:oldFrame.
    wasObscured := self isObscured:anObject.

    anObject moveTo:griddedNewOrigin.
    self changed:#objectLayout.
    shown ifFalse:[^ self].

    newFrame := self frameOf:anObject.
    objectsIntersectingNewFrame := self objectsIntersecting:newFrame.

    "try to redraw the minimum possible"

    "if no other object intersects both frames we can do a copy:"

    intersects := oldFrame intersects:newFrame.
    intersects ifFalse:[
        self hasSolidBackground ifTrue:[
            gc transformation isNil ifTrue:[
                (objectsIntersectingOldFrame size == 1) ifTrue:[
                    (objectsIntersectingNewFrame size == 1) ifTrue:[
                        clip := self clippingRectangleOrNil.
                        (clip isNil or:[oldFrame isContainedIn:clip]) ifTrue:[
                            oldLeft := oldFrame left.
                            oldTop := oldFrame top.
                            newLeft := newFrame left.
                            newTop := newFrame top.
                            w := oldFrame width.
                            h := oldFrame height.
                            ((newLeft < width) and:[newTop < height]) ifTrue:[
                                ((newLeft >= 0) and:[newTop >= 0]) ifTrue:[
                                    self catchExpose.
                                    self 
                                        copyFrom:self 
                                        x:oldLeft y:oldTop
                                        toX:newLeft y:newTop
                                        width:w height:h
                                        async:true.
                                    self waitForExpose
                                ]
                            ].
                            ((oldLeft < width) and:[oldTop < height]) ifTrue:[
                                ((oldLeft >= 0) and:[oldTop >= 0]) ifTrue:[
                                  self clearRectangleX:oldLeft y:oldTop width:w height:h.

"/                                self fillRectangleX:oldLeft y:oldTop width:w height:h
"/                                               with:viewBackground
                                ]
                            ].
                            ^ self
                        ]
                    ]
                ]
            ]
        ]
    ].
    isObscured := self isObscured:anObject.
    (oldFrame intersects:newFrame) ifTrue:[
        isObscured ifFalse:[
            self redrawObjectsIn:oldFrame.
            self show: anObject
        ] ifTrue:[
            self redrawObjectsIn:(oldFrame merge:newFrame)
        ]
    ] ifFalse:[
        self redrawObjectsIn:oldFrame.
        isObscured ifFalse:[
            self show: anObject
        ] ifTrue:[
            self redrawObjectsIn:newFrame
        ]
    ]

    "Modified: / 4.7.1999 / 16:52:17 / cg"
!

objectToBack:anObject
    "bring the argument, anObject to back"

    anObject notNil ifTrue:[
        contents remove:anObject.
        contents addFirst:anObject.
        (self isObscured:anObject) ifTrue:[
            self redrawObjectsIn:(anObject frame)
        ].
        self changed:#objectLayout.
    ]

    "Modified: / 4.7.1999 / 16:52:39 / cg"
!

objectToFront:anObject
    "bring the argument, anObject to front"

    |wasObscured|

    anObject notNil ifTrue:[
        wasObscured := self isObscured:anObject.
        contents remove:anObject.
        contents addLast:anObject.
        wasObscured ifTrue:[
"old:
            self redrawObjectsIn:(anObject frame)
"
            self hideSelection.
            self show:anObject.
            self showSelection
        ].
        self changed:#objectLayout.
    ]

    "Modified: / 4.7.1999 / 16:52:49 / cg"
!

selectionAlignBottom
    "align selected objects at bottom"

    self alignBottom:selection
!

selectionAlignHorizontal
    "align selected objects horizontally"

    self alignHorizontal:selection

    "Created: 4.6.1996 / 19:58:46 / cg"
    "Modified: 4.6.1996 / 19:59:10 / cg"
!

selectionAlignLeft
    "align selected objects left"

    self alignLeft:selection
!

selectionAlignRight
    "align selected objects right"

    self alignRight:selection
!

selectionAlignTop
    "align selected objects at top"

    self alignTop:selection
!

selectionAlignVertical
    "align selected objects vertically"

    self alignVertical:selection

    "Created: 4.6.1996 / 19:59:00 / cg"
!

selectionToBack
    "bring the selection to back"

    self toBack:selection
!

selectionToFront
    "bring the selection to front"

    self toFront:selection
!

toBack:something
    "bring the argument, anObject or a collection of objects to back"

    self forEach:something do:[:anObject |
	self objectToBack:anObject
    ]
!

toFront:something
    "bring the argument, anObject or a collection of objects to front"

    self forEach:something do:[:anObject |
	self objectToFront:anObject
    ]
! !

!ObjectView methodsFor:'misc'!

documentFormat:aFormatString
    "set the document format (mostly used by scrollbars).
     The argument should be a string such as 'a4', 'a5'
     or 'letter'. 
     See the UnitConverter class for supported formats."

    aFormatString ~= documentFormat ifTrue:[
        documentFormat := aFormatString.
        self contentsChanged.
        self defineGrid.
        gridShown ifTrue:[
            self invalidate "/ clear; redraw
        ]
    ]

    "Modified: 31.5.1996 / 19:44:08 / cg"
!

forEach:aCollection do:aBlock
    "apply block to every object in a collectioni;
     (adds a check for non-collection)"

    aCollection isNil ifTrue:[^self].
    aCollection isCollection ifTrue:[
	aCollection do:[:object |
	    object notNil ifTrue:[
		aBlock value:object
	    ]
	]
    ] ifFalse: [
	aBlock value:aCollection
    ]
!

hitDelta
    "when clicking an object, allow for hitDelta pixels around object.
     We compensate for any scaling here, to get a constant physical
     hitDelta (i.e. the value returned here is inverse scaled)."

    |delta currentTransformation|

    delta := self class hitDelta.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
        delta := delta / currentTransformation scale x
    ].
    ^ delta
!

numberOfObjectsIntersecting:aRectangle
    "answer the number of objects intersecting the argument, aRectangle"

    |tally|

    tally := 0.
    contents do:[:theObject |
	(theObject frame intersects:aRectangle) ifTrue:[
	    tally := tally + 1
	]
    ].
    ^ tally
!

numberOfObjectsIntersectingVisible:aRectangle
    "answer the number of objects intersecting the argument, aRectangle.
     This is a leftOver from times when scrolling was not transparent.
     Please use numberOfObjectsIntersecting:, since this will vanish."

    ^ self numberOfObjectsIntersecting:aRectangle
!

object:anObject isContainedIn:aRectangle
    "true, if anObject is completely inside aRectangle (for rectangle drag)"

    ^ anObject isContainedIn:aRectangle
!

objectsAbove:objectToBeTested do:aBlock
    "do something to every object above objectToBeTested
     (does not mean obscured - simply above in hierarchy)"

    |startIndex|

    startIndex := contents identityIndexOf:objectToBeTested
                                  ifAbsent:[self error:'nonexisting object'].
    contents from:startIndex to:(contents size) do:aBlock
!

objectsAbove:anObject intersecting:aRectangle do:aBlock
    "do something to every object above objectToBeTested
     and intersecting aRectangle"

    self objectsAbove:anObject do:[:theObject |
	(theObject frame intersects:aRectangle) ifTrue:[
	    aBlock value:theObject
	]
    ]
!

objectsBelow:objectToBeTested do:aBlock
    "do something to every object below objectToBeTested
     (does not mean obscured by - simply below in hierarchy)"

    |endIndex|

    endIndex := contents identityIndexOf:objectToBeTested ifAbsent:[self error:'nonexisting object'].
    contents from:1 to:(endIndex - 1) do:aBlock
!

objectsIn:aRectangle do:aBlock
    "do something to every object which is completely in a rectangle"

    |bot|

    sorted ifTrue:[
        bot := aRectangle bottom.
        self contentsDo:[:theObject |
            (self object:theObject isContainedIn:aRectangle) ifTrue:[
                aBlock value:theObject
            ] ifFalse:[
                theObject frame top > bot ifTrue:[^ self]
            ]
        ].
        ^ self
    ].

    self contentsDo:[:theObject |
        (self object:theObject isContainedIn:aRectangle) ifTrue:[
            aBlock value:theObject
        ]
    ]
!

objectsInVisible:aRectangle do:aBlock
    "do something to every object which is completely in a 
     visible rectangle.
     This is a leftOver from times when scrolling was not transparent.
     Please use objectsIn:do:, since this will vanish."

    self objectsIn:aRectangle do:aBlock
!

objectsIntersecting:aRectangle
    "answer a Collection of objects intersecting the argument, aRectangle"

    |newCollection|

    newCollection := OrderedCollection new.
    self objectsIntersecting:aRectangle do:[:theObject |
	newCollection add:theObject
    ].
    (newCollection size == 0) ifTrue:[^ nil].
    ^ newCollection
!

objectsIntersecting:aRectangle do:aBlock
    "do something to every object which intersects a rectangle"

    |f top bot
     firstIndex "{ Class: SmallInteger }"
     delta      "{ Class: SmallInteger }"
     theObject 
     nObjects   "{ Class: SmallInteger }"|

    nObjects := contents size.
    (nObjects == 0) ifTrue:[^ self].

    sorted ifFalse:[
	"
	 have to check every object
	"
	contents do:[:theObject |
	    (theObject frame intersects:aRectangle) ifTrue:[
		aBlock value:theObject
	    ]
	].
	^ self
    ].

    "
     contents is sorted by y; can do a fast (binary) search for the first
     object which intersects aRectangle and 
     break from the draw loop, when the 1st object below aRectangle is reached.
    "
    bot := aRectangle bottom.
    top := aRectangle top.

    "
     binary search for an object in aRectangle ...
    "
    delta := nObjects // 2.
    firstIndex := delta.
    (firstIndex == 0) ifTrue:[
       firstIndex := 1
    ].
    theObject := contents at:firstIndex.
    (theObject frame bottom < top) ifTrue:[
	[theObject frame bottom < top and:[delta > 1]] whileTrue:[
	    delta := delta // 2.
	    firstIndex := firstIndex + delta.
	    theObject := contents at:firstIndex
	]
    ] ifFalse:[
	[theObject frame top > bot and:[delta > 1]] whileTrue:[
	    delta := delta // 2.
	    firstIndex := firstIndex - delta.
	    theObject := contents at:firstIndex
	]
    ].

    "
     now, theObject at:firstIndex is in aRectangle; go backward to the object
     following first non-visible
    "
    [theObject frame bottom > top and:[firstIndex > 1]] whileTrue:[
	firstIndex := firstIndex - 1.
	theObject := contents at:firstIndex
    ].

    firstIndex to:nObjects do:[:index |
	theObject := contents at:index.
	f := theObject frame.
	(f intersects:aRectangle) ifTrue:[
	    aBlock value:theObject
	] ifFalse:[
	    (f top > bot) ifTrue:[^ self]
	]
    ]
!

objectsIntersectingVisible:aRectangle
    "answer a Collection of objects intersecting a visible aRectangle.
     This is a leftOver from times when scrolling was not transparent.
     Please use objectsIntersecting:, since this will vanish."

    ^ self objectsIntersecting:aRectangle
!

objectsIntersectingVisible:aRectangle do:aBlock
    "do something to every object which intersects a visible rectangle.
     This is a leftOver from times when scrolling was not transparent.
     Please use objectsIntersecting:do:, since this will vanish."

    self objectsIntersecting:aRectangle do:aBlock
!

rectangleForScroll
    "find the area occupied by visible objects"

    |left right top bottom frame oLeft oRight oTop oBottom|

    left := 9999.
    right := 0.
    top := 9999.
    bottom := 0.
    self visibleObjectsDo:[:anObject |
	frame := anObject frame.
	oLeft := frame left.
	oRight := frame right.
	oTop := frame top.
	oBottom := frame bottom.
	(oLeft < left) ifTrue:[left := oLeft].
	(oRight > right) ifTrue:[right := oRight].
	(oTop < top) ifTrue:[top := oTop].
	(oBottom > bottom) ifTrue:[bottom := oBottom]
    ].
    (left < margin) ifTrue:[left := margin].
    (top < margin) ifTrue:[top := margin].
    (right > (width - margin)) ifTrue:[right := width - margin].
    (bottom > (height - margin)) ifTrue:[bottom := height - margin].

    ((left > right) or:[top > bottom]) ifTrue:[^ nil].

    ^ Rectangle left:left right:right top:top bottom:bottom
!

visibleObjectsDo:aBlock
    "do something to every visible object"

    |absRect|

    absRect := Rectangle left:0 top:0 width:width height:height.
    self objectsIntersecting:absRect do:aBlock
! !

!ObjectView methodsFor:'queries'!

hasSolidBackground
    "return true, if I have a solid color background, which can be pixel-copied
     for optimized redraw in moveObject."

    ^ gridShown not
!

heightOfContents
    "answer the height of the document in pixels"

    |h|

    h := self heightOfContentsInMM * (self verticalPixelPerMillimeter:1).
    ^ h rounded
!

heightOfContentsInMM
    "answer the height of the document in millimeters"

    |unit value|

    "landscape"
    unit := (documentFormat , 'H') asSymbolIfInterned.
    unit isNil ifTrue:[
        "/ certainly unknown
    ] ifFalse:[
        value := UnitConverter convert:1 from:unit to:#millimeter
    ].
    value isNil ifTrue:[
        "/ assuming window size is document size
        value := (height / self verticalPixelPerMillimeter:1) asInteger
    ].
    ^ value

    "Modified: 31.5.1996 / 19:38:51 / cg"
!

widthOfContents
    "answer the width of the document in pixels"

    |w|

    w := self widthOfContentsInMM * (self horizontalPixelPerMillimeter:1).
    ^ w rounded
!

widthOfContentsInMM
    "answer the width of the document in millimeters"

    |unit value|

    "landscape"
    unit := (documentFormat , 'W') asSymbolIfInterned.
    unit isNil ifTrue:[
        "/ certainly unknown
    ] ifFalse:[
        value := UnitConverter convert:1 from:unit to:#millimeter
    ].
    value isNil ifTrue:[
        "/ assuming window size is document size
        value := (width / self horizontalPixelPerMillimeter:1) asInteger
    ].
    ^ value

    "Modified: 31.5.1996 / 19:38:22 / cg"
! !

!ObjectView methodsFor:'saving & restoring'!

fileInContentsFrom:aStream
    "remove all objects, load new contents from aStream and redraw"

    self fileInContentsFrom:aStream redraw:true new:true binary:false
!

fileInContentsFrom:aStream redraw:redraw
    "remove all objects, load new contents from aStream 
     and redraw if the redraw argument is true"

    self fileInContentsFrom:aStream redraw:redraw new:true binary:false
!

fileInContentsFrom:aStream redraw:redraw new:new 
    "remove all objects, load new contents from aStream 
     and redraw if the redraw argument is true"

    self fileInContentsFrom:aStream redraw:redraw new:new binary:false
!

fileInContentsFrom:aStream redraw:redraw new:new binary:binary
    "if the new argument is true, remove all objects.
     Then load objects from aStream. If redraw is false, no redraw
     is done
     (allows fileIn of multiple files doing a single redraw at the end)."

    binary ifTrue:[
        aStream binary
    ].
    self topView withReadCursorDo:[
        |newObject chunk individualRedraw|

        self unselect.
        individualRedraw := redraw.
        new ifTrue:[
            self removeAll.
            individualRedraw := false.
        ].
        [aStream atEnd] whileFalse:[
            binary ifTrue:[
                newObject := Object readBinaryFrom:aStream
            ] ifFalse:[
                chunk := aStream nextChunk.
                (chunk size > 0) ifTrue:[
                    newObject := Compiler evaluate:chunk compile:false.
                ] ifFalse:[
                    newObject := nil
                ]
            ].
            newObject notNil ifTrue:[
                self initializeFileInObject:newObject.
                individualRedraw ifFalse:[
                    self addObjectWithoutRedraw:newObject
                ] ifTrue:[
                    self addObject:newObject
                ]
            ]
        ].
        (new and:[redraw]) ifTrue:[
            self invalidate
        ]
    ]

    "Modified: / 30.1.1998 / 01:02:16 / cg"
!

initializeFileInObject:anObject
    "each object may be processed here after its being filed-in
     - subclasses may do whatever they want here ...
     (see LogicView for example)"

    ^ self
!

storeBinaryContentsOn:aStream
    "store the contents in binary representation on aStream."

    aStream binary.
    self topView withWriteCursorDo:[
        self forEach:contents do:[:theObject |
            theObject storeBinaryOn:aStream.
        ].
    ]

    "Modified: / 27-07-2012 / 09:45:31 / cg"
!

storeContentsOn:aStream
    "store the contents in textual representation on aStream.
     Notice, that for huge objects (such as DrawImages) this ascii output
     can become quite large, and the time to save and reload can become
     long."

    |excla|

    self topView withWriteCursorDo:[
        excla := aStream class chunkSeparator.
        self forEach:contents do:[:theObject |
            theObject storeOn:aStream.
            aStream nextPut:excla.
            aStream cr
        ].
        aStream nextPut:excla
    ]

    "Modified: / 27-07-2012 / 09:45:23 / cg"
!

withoutRedrawFileInContentsFrom:aStream
    "remove all objects, load new contents from aStream without any redraw"

    self fileInContentsFrom:aStream redraw:false new:true binary:false
! !

!ObjectView methodsFor:'scrolling'!

horizontalScrollStep
    "return the amount to scroll when stepping left/right.
     Redefined to scroll by inches or centimeters."

    scaleMetric == #inch ifTrue:[
        ^ (device horizontalPixelPerInch * (1/2)) asInteger
    ].
    ^ (device horizontalPixelPerMillimeter * 20) asInteger
!

verticalScrollStep
    "return the amount to scroll when stepping left/right.
     Redefined to scroll by inches or centimeters."

    scaleMetric == #inch ifTrue:[
        ^ (device verticalPixelPerInch * (1/2)) asInteger
    ].
    ^ (device verticalPixelPerMillimeter * 20) asInteger
! !

!ObjectView methodsFor:'selection & handles'!

drawHandle:aPoint
    |hsize halfSize|

    hsize := self handleSize.
    halfSize := hsize // 2.
    gc fillRectangleX:(aPoint x - halfSize) y:(aPoint y - halfSize)
       width:hsize height:hsize
!

drawHandlesFor:anObject
    |hsize halfSize|

    hsize := self handleSize.
    halfSize := hsize // 2.
    self handlesOf:anObject do:[:handlePoint |
        gc fillRectangleX:(handlePoint x - halfSize) y:(handlePoint y - halfSize)
           width:hsize height:hsize
    ]
!

findAllObjectsHandleAt:aPoint

    ^ contents select:[:object|
        (self object:object hasHandleAt:aPoint) 
    ] 
!

findAllObjectsHandleAt:aPoint suchThat:aBlock

    ^ contents select:[:object|
        (aBlock value:object) 
        and:[(self object:object hasHandleAt:aPoint)]
    ] 
!

findLastObjectHandleAt:aPoint

    ^ contents detectLast:[:object|
        (self object:object hasHandleAt:aPoint) 
    ] ifNone:nil
!

findLastObjectHandleAt:aPoint suchThat:aBlock

    contents reverseDo:[:object |
        (self object:object hasHandleAt:aPoint) ifTrue:[
            (aBlock value:object) ifTrue:[ ^ object ]
        ]
    ].
    ^ nil
!

findObjectHandleAt:aPoint
    |objectFound|
    contents do:[:object |
        (self object:object hasHandleAt:aPoint) ifTrue:[
            objectFound := object
        ]
    ].
    ^ objectFound
!

handle:handlePoint isHitBy:aPoint
    ^ (self handleFor:handlePoint) containsPoint:aPoint
!

handleFor:aPoint
    "return the handle-rectangle for a handle at aPoint"

    |hsize centerX centerY|

    hsize := self handleSize.
    centerX := aPoint x.
    centerY := aPoint y.
    ^ Rectangle left:(centerX - hsize)
		 top:(centerY - hsize)
	       right:(centerX + hsize)
	      bottom:(centerY + hsize)
!

handleSize
    "return the size of the handles - since handles should be
     the same size regardless of scaling, inverse-scale from
     what the default is."

    |hs currentTransformation|

    hs := self class handleSize.
    currentTransformation := gc transformation.
    currentTransformation notNil ifTrue:[
        ^ currentTransformation applyInverseScaleX:hs
    ].
    ^ hs
!

handlesOf:anObject do:aBlock
    anObject handlesDo:aBlock
!

invertHandle:aHandle
    self xoring:[self drawHandle:aHandle]
!

invertHandlesOf:aSelection
    aSelection notNil ifTrue:[
        self clippedTo:nil do:[
            self xoring:[
                self forEach:aSelection do:[:anObject |
                    (anObject respondsTo:#handlesDo:) ifTrue:[
                        self drawHandlesFor:anObject
                    ] ifFalse:[
                        anObject drawOutlineIn:self
                    ]
                ]
            ]
        ]
    ]
!

object:anObject hasHandleAt:aPoint
    |found|

    found := false.
    self handlesOf:anObject do:[:handlePoint |
        (self handle:handlePoint isHitBy:aPoint) ifTrue:[
            found := true
        ]
    ].
    ^ found
!

selectionHandlesDo:aBlock
    self forEach:selection do:[:theObject |
        (theObject respondsTo:#handlesDo:) ifTrue:[
            self handlesOf:theObject do:[:handlePoint |
                aBlock value:theObject value:handlePoint
            ]
        ]
    ]
! !

!ObjectView methodsFor:'selections'!

addToSelection:anObject
    "add anObject to the selection; redraw it selected"

    selection isCollection ifFalse:[
        selection isNil ifTrue:[
            selection := OrderedCollection new
        ] ifFalse:[
            selection := OrderedCollection with:selection
        ]
    ].

    (selection includes:anObject) ifFalse:[
        (self frameIncludesSelectionHandlesOn:anObject) ifFalse:[
            self hideSelection.
            selection add:anObject.
            self showSelection.
        ] ifTrue:[
            selection add:anObject.
            self showSelected:anObject
        ].
        self changed:#selection with:selection.
    ].

    "Modified: / 27-10-2006 / 14:16:04 / cg"
!

hideSelection
    "hide the selection - undraw hilights - whatever that is"

    shown ifFalse:[^ self].

    self selectionDo:[:object |
        self showUnselected:object
    ]
!

removeFromSelection:anObject
    "remove anObject from the selection"

    |wasSelected didHide|

    didHide := false.
    wasSelected := true.

    (self frameIncludesSelectionHandlesOn:anObject) ifFalse:[
        "/ must hide any selection-handles first
        self hideSelection.
        didHide := true.
    ].

    selection isCollection ifTrue:[
        (selection remove:anObject ifAbsent:[nil]) isNil ifTrue:[
            wasSelected := false
        ].
        (selection size == 1) ifTrue:[
            selection := selection first
        ] ifFalse:[
            selection := selection asNilIfEmpty
        ]
    ] ifFalse:[
        (selection == anObject) ifTrue:[
            selection := nil
        ] ifFalse:[
            wasSelected := false
        ]
    ].

    didHide ifTrue:[
        self showSelection.
    ] ifFalse:[
        wasSelected ifTrue:[
            self showUnselected:anObject
        ].
    ].

    self changed:#selection with:selection.

    "Modified: / 4.7.1999 / 15:22:28 / cg"
!

select:something
    "select something - hide previous selection, set to something and hilight"

    |newSelection|

    newSelection :=
        (something isCollection and:[something size == 0]) 
            ifTrue:[ nil ]
            ifFalse:[ something ].

    (selection = newSelection) ifFalse:[
        self hideSelection.
        selection := newSelection.
        self showSelection.
        self changed:#selection with:selection.
    ]

    "Modified: / 4.7.1999 / 15:22:39 / cg"
!

selectAll
    "select all objects"

    self select:contents copy.
!

selectAllIn:aRectangle
    "select all objects which are fully contained in aRectangle"

    |newSelection|

    newSelection := OrderedCollection new.
    self 
        objectsIn:aRectangle 
        do:[:theObject |
            newSelection add:theObject
        ].
    self select:newSelection.
!

selectAllIntersecting:aRectangle
    "select all objects which are touched by aRectangle"

    |newSelection|

    newSelection := OrderedCollection new.
    self objectsIntersecting:aRectangle do:[:theObject |
        newSelection add:theObject
    ].
    self select:newSelection.
!

selection
    "return the selection as a collection or nil"

    selection isNil ifTrue:[^ nil].
    selection isCollection ifTrue:[^ selection].
    ^ Array with:selection

    "Created: / 4.7.1999 / 14:33:16 / cg"
    "Modified: / 4.7.1999 / 14:34:20 / cg"
!

selectionDo:aBlock
    "apply block to every object in selection"

    self forEach:selection do:aBlock
!

showSelection
    "show the selection - draw hilights - whatever that is"

    shown ifFalse:[^ self].

    self selectionDo:[:object |
        self showSelected:object
    ]
!

unselect
    "unselect - hide selection; clear selection"

    selection notNil ifTrue:[
        self select:nil.
    ]

    "Modified: / 4.7.1999 / 15:30:36 / cg"
!

withSelectionHiddenDo:aBlock
    "evaluate aBlock while selection is hidden"

    |sel|

    sel := selection.
    sel notNil ifTrue:[self unselect].
    aBlock value.
    sel notNil ifTrue:[self select:sel]
! !

!ObjectView methodsFor:'testing objects'!

allObjectsHitAt:aPoint do:aBlock
    "for all objects (by enumerating from back to front) which are hit by
     the argument, aPoint, evaluate aBlock"

    self allObjectsHitAt:aPoint withDelta:(self hitDelta / self scale x) do:aBlock
!

allObjectsHitAt:aPoint withDelta:hDelta do:aBlock
    "for all objects (by enumerating from back to front) which are hit by
     the argument, aPoint, evaluate aBlock"

    contents notEmptyOrNil ifTrue:[
        contents reverseDo:[:object |
            (object isHitBy:aPoint withDelta:hDelta) ifTrue:[
                aBlock value:object
            ]
        ]
    ].
    ^ nil

    "Created: / 27-10-2006 / 16:58:34 / cg"
!

canMove:something
    "return true, if the argument, anObject or a collection can be moved"

    something isCollection ifTrue:[
        self forEach:something do:[:theObject |
            (theObject perform:#canBeMoved ifNotUnderstood:true) ifFalse:[^ false]
        ].
        ^ true
    ].
    ^ something perform:#canBeMoved ifNotUnderstood:true
!

canSelect:something
    "return true, if the argument, anObject or a collection can be selected"

    something isCollection ifTrue:[
        self forEach:something do:[:theObject |
            theObject isView ifFalse:[
                (theObject perform:#canBeSelected ifNotUnderstood:true) ifFalse:[^ false]
            ]
        ].
        ^ true
    ].
    something isView ifTrue:[^ true].
    ^ something perform:#canBeSelected ifNotUnderstood:true

    "Created: / 4.7.1999 / 18:51:29 / cg"
!

findNearestObjectAt:aPoint
    "find the nearest object (by looking from back to front) which is hit by
     the argument, aPoint - this is the topmost object hit"

    0 to:(self hitDelta) by:(1 / 2) do:[:hdelta |
        self allObjectsHitAt:aPoint withDelta:(hdelta " / self scale x") do:[:object | ^ object].
    ].
    ^ nil

    "Modified: / 27-10-2006 / 16:58:54 / cg"
!

findObjectAt:aPoint
    "find the last object (by looking from back to front) which is hit by
     the argument, aPoint - this is the topmost object hit"

    self allObjectsHitAt:aPoint do:[:object | ^ object].
    ^ nil

    "Modified: / 27-10-2006 / 16:58:54 / cg"
!

findObjectAt:aPoint forWhich:aBlock
    "find the last object (by looking from back to front) which is hit by
     the argument, aPoint - this is the topmost object hit"

    self allObjectsHitAt:aPoint do:[:object | (aBlock value:object) ifTrue:[^ object]].
    ^ nil

    "Modified: / 27-10-2006 / 16:59:26 / cg"
!

findObjectAt:aPoint suchThat:aBlock
    <resource: #obsolete>
    "find the last object (back to front ) which is hit by
     the argument, aPoint and for which the testBlock, aBlock evaluates to true.
     This is a leftOver from times when scrolling was not transparent.
     Please use findObjectAt:forWhich:, since this will vanish."

    self obsoleteMethodWarning:'use findObjectAt:forWhich:'.
    ^ self findObjectAt:aPoint forWhich:aBlock

    "Modified: / 27-10-2006 / 17:01:42 / cg"
!

findObjectAtVisible:aPoint
    <resource: #obsolete>
    "find the last object (by looking from back to front) which is hit by
     a visible point - this is the topmost object hit.
     This is a leftOver from times when scrolling was not transparent.
     Please use findObjectAt:, since this will vanish."

    self obsoleteMethodWarning:'use findObjectAt:'.
    ^ self findObjectAt:aPoint

    "Modified: / 27-10-2006 / 17:02:08 / cg"
!

findObjectAtVisible:aPoint suchThat:aBlock
    <resource: #obsolete>
    "find the last object (back to front ) which is hit by
     the argument, aPoint and for which the testBlock, aBlock evaluates to
     true.
     This is a leftOver from times when scrolling was not transparent.
     Please use findObjectAt:forWhich:, since this will vanish."

    self obsoleteMethodWarning:'use findObjectAt:forWhich:'.
    ^ self findObjectAt:aPoint suchThat:aBlock

    "Modified: / 27-10-2006 / 17:01:47 / cg"
!

findObjectForSelectAt:aPoint
    "find the object for a select"

    ^ self findObjectAt:aPoint
!

frameIncludesSelectionHandlesOn:anObject
    "return true, if anObjects frame includes any selection
     handles, false if not or if we do not know.
     This can be used to optimize the redraw, in removeObjectFromSelection.
     Subclasses which know how selections are highlighted may redefine this."

    ^ false     "/ i.e. don't know.

    "Created: 1.10.1996 / 12:06:51 / cg"
!

frameOf:anObjectOrCollection
    "answer the maximum extent defined by the argument, anObject or a
     collection of objects"

    |first frameAll|

    anObjectOrCollection isNil ifTrue:[^ nil ].

    first := true.
    self forEach:anObjectOrCollection do:[:theObject |
        first ifTrue:[
            frameAll := theObject frame.
            first := false
        ] ifFalse:[
            frameAll := frameAll merge:(theObject frame)
        ]
    ].
    ^ frameAll

    "Modified: / 27-10-2006 / 17:02:16 / cg"
!

isObscured:something
    "return true, if the argument something, anObject or a collection of
     objects is obscured (partially or whole) by any other object"

    self forEach:something do:[:anObject |
	(self objectIsObscured:anObject) ifTrue:[
	    ^ true
	]
    ].
    ^ false
!

isSelected:anObject
    "return true, if the argument, anObject is in the selection"

    selection isNil ifTrue:[^ false].
    (selection == anObject) ifTrue:[^ true].
    selection isCollection ifTrue:[
	^ (selection identityIndexOf:anObject startingAt:1) ~~ 0
    ].
    ^ false
!

objectIsObscured:objectToBeTested
    "return true, if the argument, anObject is obscured (partially or whole)
     by any other object"

    |frameToBeTested frameleft frameright frametop framebot
     objectsFrame startIndex|

    (objectToBeTested == (contents last)) ifTrue:[
        "quick return if object is on top"
        ^ false
    ].

    frameToBeTested := self frameOf:objectToBeTested.
    frameleft := frameToBeTested left.
    frameright := frameToBeTested right.
    frametop := frameToBeTested top.
    framebot := frameToBeTested bottom.

    "check objects after the one to check"

    startIndex := contents identityIndexOf:objectToBeTested ifAbsent:[self error:'nonexisting object'].
    contents from:(startIndex + 1) to:(contents size) do:[:object |
        objectsFrame := self frameOf:object.
        (objectsFrame right < frameleft) ifFalse:[
            (objectsFrame left > frameright) ifFalse:[
                (objectsFrame bottom < frametop) ifFalse:[
                    (objectsFrame top > framebot) ifFalse:[
                        ^ true
                    ]
                ]
            ]
        ]
    ].
    ^ false
! !

!ObjectView methodsFor:'user interface'!

alignToGrid:aPoint
    "round aPoint to the next nearest point on the grid"

    aligning ifFalse:[
        ^ aPoint
    ].

    ^ (aPoint grid:gridAlign) rounded
!

selectMore:aPoint
    "add/remove an object from the selection"

    |anObject|

    anObject := self findObjectAt:aPoint.
    anObject notNil ifTrue:[
        (self isSelected:anObject) ifTrue:[
            "remove from selection"
            self removeFromSelection:anObject
        ] ifFalse:[
            "add to selection"
            (self canSelect:anObject) ifTrue:[
                self addToSelection:anObject
            ]
        ]
    ].
    ^ self

    "Modified: / 4.7.1999 / 18:52:13 / cg"
!

startSelectMoreOrMove:aPoint
    "add/remove object hit by aPoint, then start a rectangleDrag or move 
     - if aPoint hits an object, a move is started, otherwise a rectangleDrag.
     This is typically the button shiftPressAction."

    |anObject|

    anObject := self findObjectAt:aPoint.
    anObject notNil ifTrue:[
        (self isSelected:anObject) ifTrue:[
            "remove from selection"
            self removeFromSelection:anObject
        ] ifFalse:[
            "add to selection"
            (self canSelect:anObject) ifTrue:[
                self addToSelection:anObject
            ]
        ].
        self startObjectMove:selection at:aPoint.
        ^ self
    ].
"/    self unselect.
"/    self startRectangleDrag:aPoint

    "Modified: / 4.7.1999 / 18:51:52 / cg"
!

startSelectOrMove:aPoint
    "start a rectangleDrag or objectMove - if aPoint hits an object,
     an object move is started, otherwise a rectangleDrag.
     This is typically the button pressAction."

    |anObject|

    anObject := self findObjectForSelectAt:aPoint.
    anObject notNil ifTrue:[
        (self isSelected:anObject) ifFalse:[
            self unselect.
            self startObjectMove:anObject at:aPoint.
        ] ifTrue:[
            self startObjectMove:selection at:aPoint.
        ].
        ^ self
    ].
    "nothing was hit by this click - this starts a group select"
    self unselect.
    self startRectangleDrag:aPoint
! !

!ObjectView methodsFor:'view manipulation'!

inchMetric
    (scaleMetric ~~ #inch) ifTrue:[
	scaleMetric := #inch.
	self newGrid
    ]
!

millimeterMetric
    (scaleMetric ~~ #mm) ifTrue:[
	scaleMetric := #mm.
	self newGrid
    ]
!

zoom:factor
    "set a zoom factor; smaller than 1 is shrink; larger than 1 is magnify. 
     I.e. 1 is identity; 2 is magnify by 2; 0.5 is shrink by 2"

    |currentScale currentTranslation newScale|

    currentScale := self scale.
    currentTranslation := self translation.

    newScale := factor.
    newScale isNil ifTrue:[
        newScale := 1 @ 1
    ].
    newScale := newScale asPoint.

    newScale = currentScale ifTrue:[
        ^ self
    ].

    (newScale = 1) ifTrue:[
        gc transformation:nil
    ] ifFalse:[
        gc transformation:(WindowingTransformation 
                            scale:newScale 
                            translation:(currentTranslation / currentScale x * newScale x ) rounded).
    ].
    self contentsChanged.
    self setInnerClip.
    gridShown ifTrue:[
        self newGrid
    ].
    self invalidate 

    "Modified: 29.5.1996 / 16:20:41 / cg"
!

zoomIn
    "zoom in - multiply the zoom factor by 1.5"

    self zoomIn:1.5

    "Modified: / 10.2.2000 / 21:14:41 / cg"
!

zoomIn:factor
    "zoom in by multiplying the zoom factor by the argument"

    |currentTransformation|

    currentTransformation := gc transformation.
    currentTransformation isNil ifTrue:[
        currentTransformation := WindowingTransformation scale:1 translation:0
    ].
    gc transformation:(WindowingTransformation 
                        scale:(currentTransformation scale * factor)
                        translation:(currentTransformation translation * factor) rounded).
    self contentsChanged.
    self setInnerClip.
    self invalidate.

    "Created: / 27.4.1996 / 10:08:39 / cg"
    "Modified: / 10.2.2000 / 21:11:11 / cg"
!

zoomOut
    "zoom in - divide the zoom factor by 1.5"

    self zoomOut:1.5

    "Modified: / 10.2.2000 / 21:14:46 / cg"
!

zoomOut:factor
    "zoom out by dividing the zoom factor by the argument"

    self zoomIn:(1.0 / factor)

    "Created: / 27.4.1996 / 10:09:19 / cg"
    "Modified: / 10.2.2000 / 21:10:52 / cg"
! !

!ObjectView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

