"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Controller subclass:#VariablePanelController
	instanceVariableNames:'movedHandle prevPos clickPos saveCursor startResizing resizeMode
		opaqueResizing'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!VariablePanelController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    An abstract class for variablePanel controllers;
    normally, not used directly by applications, these are created automatically
    whenever a variablePanel is created.
    Instances are responsible for tracking the mouse pointer and resize the
    views (a panel) subviews as appropriate.

    [author:]
        Claus Gittinger
"


! !

!VariablePanelController methodsFor:'event handling'!

buttonMotion:state x:bx y:by
    "mouse-button was moved while pressed;
     clear prev handleBar and draw handle bar at new position
    "
    |nextPos layout entered handle|

    state == 0 ifTrue:[
        movedHandle notNil ifTrue:[
            "/ oops - how can this happen
            self buttonRelease:1 x:bx y:bx.
            movedHandle := nil
        ].

        view snapMode isNil ifTrue:[^ self].

        handle := self detectHandleIndexAt:bx y:by.
        handle isNil ifTrue:[^ self].

        "check entering click button ...."
        layout  := view snapLayoutAt:handle.
        entered := layout notNil and:[layout containsPointX:bx y:by].

        entered ~~ (self isSnapEntered) ifTrue:[
            entered ifTrue:[
                saveCursor := view cursor.
                view cursor:(Cursor hand).
            ] ifFalse:[
                view cursor:saveCursor.
                saveCursor := nil.
            ].
            view drawSnapAt:handle
        ].
        ^ self
    ].

    (movedHandle isNil or:[resizeMode isNil]) ifTrue:[^ self].

    "/ kludge: workaround Windows bug, which sends a MOUSEMOVE
    "/ (with same coordinate as previous MOUSE_DOWN
    view orientation ~~ #vertical ifTrue:[
        clickPos == bx ifTrue:[^ self].
        prevPos == bx ifTrue:[^ self].
    ] ifFalse:[
        clickPos == by ifTrue:[^ self].
        prevPos == by ifTrue:[^ self].
    ].

    "RESIZING"

    "compute new position ...."
    nextPos := self checkedHandleMovementX:bx y:by.
"/    nextPos = prevPos ifTrue:[
"/        ^ self
"/    ].

    resizeMode == #active ifTrue:[
        "check position changed ..."
"/        nextPos > 10 ifTrue:[
"/            (prevPos - nextPos) abs < 2 ifTrue:[^ self].
"/        ].
        opaqueResizing ifFalse:[
            self doInvertHandle   "undo the last invert"
        ]
    ] ifFalse:[
"/        nextPos > 10 ifTrue:[
"/            (clickPos - nextPos) abs < 5 ifTrue:[^ self].
"/        ].
        resizeMode := #active.

        "/ restore the snap cursor
        self isSnapEntered ifTrue:[
            view grabPointerWithCursor:saveCursor.
            saveCursor := nil.
            view drawSnapAt:movedHandle.
        ]
    ].
    prevPos := nextPos.

    opaqueResizing ifFalse:[
        self doInvertHandle.
    ] ifTrue:[
        self doResize.
    ].

    "Modified: / 24.8.2001 / 15:34:57 / cg"
!

buttonPress:button x:bx y:by
    "button was pressed - setup resizing if a handle is hit
    "
    |handleView hindex isMin isMax layout|

    (button == 1) ifFalse:[
        movedHandle isNil ifTrue:[
            self pointerLeave:0.
            super buttonPress:button x:bx y:by.
        ].
        ^ self.
    ].

    view compressMotionEvents:true.
    hindex := self detectHandleIndexAt:bx y:by.

"/    movedHandle notNil ifTrue:[
"/        hindex ~~ movedHandle ifTrue:[self pointerLeave:0].     "restore the cursor"
"/    ].

    (     (movedHandle := hindex) notNil
     and:[(view canChangeExtentOfViewAt:movedHandle)]
    ) ifFalse:[
        ^ self
    ].

    view grabPointerWithCursor:(view cursor).
    handleView := view subViews at:movedHandle.

    "setup resizeing"
    resizeMode := #init.

    view orientation ~~ #vertical ifTrue:[
        clickPos := bx.
        prevPos  := handleView right.
    ] ifFalse:[
        clickPos := by.
        prevPos  := handleView bottom.
    ].
    prevPos := prevPos + (view barHeight + 1 // 2).

    "/ self pointerEnter:0 x:bx y:by.

    opaqueResizing := self sensor shiftDown or:[UserPreferences current opaqueVariablePanelResizing == true].

    self isSnapEntered ifTrue:[
        "there is a snap under the cursor; redraw selected"
        view snapMode == #both ifTrue:[
            layout := view snapLayoutAt:movedHandle.
            view orientation == #vertical ifTrue:[
                isMax := bx > (layout right - (layout width//3)).
                isMin := bx < (layout left + (layout width//3)).
            ] ifFalse:[
                isMax := by > (layout bottom - (layout height//3)).
                isMin := by < (layout top + (layout height//3)).
            ].
            handleView objectAttributeAt:#snapPart  put:(isMin ifTrue:[#left] ifFalse:[ isMax ifTrue:[#right] ifFalse:[#middle]]).
        ].
        view drawSnapAt:movedHandle.
    ] ifFalse:[
        opaqueResizing ifFalse:[
            self doInvertHandle.
            resizeMode := #active.
        ].
    ].

    "Modified: / 24.8.2001 / 15:35:27 / cg"
!

buttonRelease:button x:bx y:by
    "end bar-move"

    |layout aboveView|

    (button == 1) ifFalse:[
        movedHandle isNil ifTrue:[
            resizeMode := nil.
            super buttonRelease:button x:bx y:by
        ].
        ^ self.
    ].

    view compressMotionEvents:false.
    view ungrabPointer.
    movedHandle isNil ifTrue:[^ self].

    resizeMode notNil ifTrue:[
        resizeMode == #active ifTrue:[
            (view snapMode == #both) ifFalse:[
                aboveView := view subViews at:movedHandle.
                aboveView objectAttributeAt:#vpext put:(aboveView relativeCorner).
            ].
            opaqueResizing ifFalse:[
                self doResize
            ].
        ] ifFalse:[
            (    (layout := view snapLayoutAt:movedHandle) notNil
             and:[layout containsPointX:bx y:by]
            ) ifTrue:[
                self doSnapPressedX:bx y:by
            ].
        ].
    ].
    movedHandle := nil.
    self pointerLeave:0.
    self pointerEnter:0 x:bx y:by.      "check whether mouse on a handle"

    "Modified: / 24.8.2001 / 15:35:33 / cg"
!

pointerEnter:state x:bx y:by
    "this could be send by the KDE before a button press event;
     test whether the state == 0
    "
    |handle|

    state ~~ 0 ifTrue:[ ^ self ].

    view snapMode notNil ifTrue:[
        "/ test whether a handle is under the cursor
        handle := self detectHandleIndexAt:bx y:by.

        handle notNil ifTrue:[
            "/ there is a handel; thus we have to setup the cursor...
            self buttonMotion:state x:bx y:by
        ].
    ].
!

pointerLeave:state
    "this could be send by the KDE before a button press event;
     test whether the state == 0
    "
    state ~~ 0 ifTrue:[ ^ self ].

    "/ the view is leave and no button is pressed
    "/ restore the cursor and redraw the snap if not nil

    saveCursor notNil ifTrue:[
        "restore the cursor"
        view cursor:saveCursor.
        saveCursor := nil
    ].

    resizeMode := nil.

    movedHandle notNil ifTrue:[
        view drawSnapAt:movedHandle.
        self buttonRelease:1 x:0 y:0.
        movedHandle := nil.
    ].
! !

!VariablePanelController methodsFor:'private'!

checkedHandleMovementX:bx y:by
    "check and return valid position a handle can be placed
    "
    |max min pos subViews halfBarHeight barHeight 
     thisView nextView nextView2
     minExtentThisView|

    subViews := view subViews.
    barHeight := view barHeight.
"/    halfBarHeight := view barHeight + 1 // 2.
    halfBarHeight := barHeight // 2.

    thisView := subViews at:movedHandle. "/ the view above the handle
    nextView := subViews at:movedHandle + 1.
    nextView2 := subViews at:movedHandle + 2 ifAbsent:nil.

    minExtentThisView := thisView minExtent.
    
    view orientation == #vertical ifTrue:[
        pos := by.
        min := thisView top.
        minExtentThisView notNil ifTrue:[
            min := min + (minExtentThisView y ? 0)
        ].    
        nextView2 isNil ifTrue:[
            max := view height.
        ] ifFalse:[
            max := nextView2 top.
        ].
    ] ifFalse:[
        pos := bx.
        min := thisView left.
        minExtentThisView notNil ifTrue:[
            min := min + (minExtentThisView x ? 0)
        ].    
        nextView2 isNil ifTrue:[
            max := view width.
        ] ifFalse:[
            max := nextView2 left.
        ].
    ].

    min := min + halfBarHeight "- 1".
    barHeight odd ifTrue:[ min := min + 1 ].
    movedHandle == 1 ifTrue:[
        min := min + view margin
    ].

"/    max := max - halfBarHeight.
"/    movedHandle == (subViews size-1) ifTrue:[
"/        max := max - barHeight + 2.
"/    ] ifFalse:[
        max := max - halfBarHeight "+ 1".
        true "barHeight odd" ifTrue:[ max := max - 1 ].
"/    ].

    movedHandle == (subViews size-1) ifTrue:[
        max := max - view margin
    ].

    pos < min ifTrue:[^ min].
    pos > max ifTrue:[^ max].
    ^ pos
!

detectHandleIndexAt:x y:y
    "returns the handle index at position x@y or nil if none detected
    "
    |subViews
     size "{ Class: SmallInteger }"|

    subViews := view subViews.

    (size := subViews size) > 1 ifTrue:[
	view orientation == #vertical ifTrue:[
	    2 to:size do:[:i|
		(subViews at:i) top >= y ifTrue:[
		    ^ (subViews at:(i-1)) bottom < y ifTrue:[i-1] ifFalse:[nil]
		]
	    ]
	] ifFalse:[
	    2 to:size do:[:i|
		(subViews at:i) left >= x ifTrue:[
		    ^ (subViews at:(i-1)) right < x ifTrue:[i-1] ifFalse:[nil]
		]
	    ]
	]
    ].
    ^ nil


! !

!VariablePanelController methodsFor:'queries'!

isSnapEntered
    ^ saveCursor notNil
!

isSnapEntered:anIndex
    ^ saveCursor notNil and:[anIndex == movedHandle]

!

isSnapPressed
    ^ resizeMode notNil and:[resizeMode ~~ #active]
! !

!VariablePanelController methodsFor:'user operations'!

doInvertHandle
    "invert a handle
    "
    |pos|

    pos := prevPos - (view barHeight + 1 // 2).
    view invertHandleBarAtX:pos y:pos.
!

doResize
    "perform the resize
    "
    |aboveView belowView aboveIndex belowIndex newRelPos subViews isVertical 
     newCorner newOrigin halfBarHg aboveInvisible belowInvisible|

    "undo the last invert"
    (resizeMode == #active and:[opaqueResizing not]) ifTrue:[
        self doInvertHandle
    ].
    "check if position changed"
    prevPos == clickPos ifTrue:[^ self].

    "compute the new relative origins & corners"
    isVertical := view orientation == #vertical.
    aboveIndex := movedHandle.
    belowIndex := movedHandle + 1.
    subViews   := view subViews.
    aboveView  := subViews at:aboveIndex.
    belowView  := subViews at:belowIndex.
    halfBarHg  := (view barHeight + 1) // 2.
    aboveInvisible := belowInvisible := false.

    isVertical ifTrue:[
        "X complains badly if you try to create/resize a view with a dimension <= 0
        "
        prevPos - halfBarHg == aboveView top ifTrue:[
            prevPos := prevPos + 1.
            aboveInvisible := true.
        ].

        newRelPos := (prevPos / view height) asFloat.
        newCorner := aboveView relativeCorner x @ newRelPos.
        newOrigin := belowView relativeOrigin x @ newRelPos.
    ] ifFalse:[
        "X complains badly if you try to create/resize a view with a dimension <= 0
        "
        prevPos - halfBarHg == aboveView left ifTrue:[
            prevPos := prevPos + 1.
            aboveInvisible := true.
        ].

        newRelPos := (prevPos / view width) asFloat.
        newCorner := newRelPos @ aboveView relativeCorner y.
        newOrigin := newRelPos @ belowView relativeOrigin y.
    ].
    view lockRedraw.

    aboveView relativeCorner:newCorner.
    belowView relativeOrigin:newOrigin.
    aboveInvisible ifTrue:[
        aboveView realized ifTrue:[ aboveView unmap ].
    ] ifFalse:[
        aboveView realized ifFalse:[ aboveView map ].
    ].    

    prevPos > clickPos ifTrue:[ "above view grows"
        view resizeSubviewsFrom:aboveIndex to:belowIndex.
    ] ifFalse:[
        view resizeSubviewsFrom:belowIndex to:aboveIndex
    ].
    view unlockRedraw.

    prevPos := isVertical ifTrue:[aboveView bottom] ifFalse:[aboveView right].
    prevPos := prevPos + halfBarHg.
!

doSnapPressedX:x y:y
    "perform the snap press
    "
    |layout handle curRCorner prvRCorner isVertical newPos mode isMax isMin doRememberPosition|

    (mode := view snapMode) isNil ifTrue:[^ self].

    layout     := view snapLayoutAt:movedHandle.
    handle     := view subViews at:movedHandle.
    isVertical := view orientation == #vertical.

    curRCorner := handle relativeCorner.
    prvRCorner := handle objectAttributeAt:#vpext.

    isMax := isMin := false.
    mode == #both ifTrue:[
        isVertical ifTrue:[
            isMax := x > (layout right - (layout width//3)).
            isMin := x < (layout left + (layout width//3)).
        ] ifFalse:[
            isMin := y > (layout bottom - (layout height//3)).
            isMax := y < (layout top + (layout height//3)).
        ].
        handle objectAttributeAt:#snapPart  put:(isMin ifTrue:[#left] ifFalse:[ isMax ifTrue:[#right] ifFalse:[#middle]]).
        doRememberPosition := (isMin or:[isMax]) and:[prvRCorner isNil].
    ] ifFalse:[
        isMax := view snapAtIndexWillGrow:movedHandle.
        isMin := isMax not.
        isMax ifTrue:[
           isMax := prvRCorner isNil or:[mode ~~ #min]
        ] ifFalse:[
           isMin := prvRCorner isNil or:[mode ~~ #max]
        ].
        doRememberPosition := true.
    ].

    isMax ifTrue:[
        newPos := 99999        "set extent to max"
    ] ifFalse:[
        isMin ifTrue:[
            newPos := 0        "set extent to min"
        ] ifFalse:[
            newPos := nil      "restore previous extent"
        ]
    ].

    newPos isNil ifTrue:[
        prvRCorner isNil ifTrue:[
            "/ nothing to do
            ^ self
        ].

        "restore previous extent"
        newPos := isVertical ifTrue:[view height * prvRCorner y]
                            ifFalse:[view width  * prvRCorner x].

        newPos := self checkedHandleMovementX:newPos y:newPos.

        (prevPos - newPos) abs < 2 ifTrue:[
            "cannot resize; set extent to min or max dependent on the current extent"
            isVertical ifTrue:[
                newPos := handle height > 2 ifTrue:[0] ifFalse:[99999]
            ] ifFalse:[
                newPos := handle width  > 2 ifTrue:[0] ifFalse:[99999]
            ].
            newPos := self checkedHandleMovementX:newPos y:newPos.
        ].

        mode == #both ifTrue:[
           handle objectAttributeAt:#vpext put:nil.         "clear previous corner"
           doRememberPosition := false.
        ].

    ] ifFalse:[
        newPos := self checkedHandleMovementX:newPos y:newPos
    ].

    (newPos - prevPos) abs < 2 ifFalse:[
        doRememberPosition ifTrue:[
            handle objectAttributeAt:#vpext put:curRCorner.         "save previous corner"
        ].
        prevPos := newPos.
        self doResize.
    ]
! !

!VariablePanelController class methodsFor:'documentation'!

version
    ^ '$Header$'


! !

