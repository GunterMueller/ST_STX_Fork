"
 COPYRIGHT (c) 1995 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ObjectView subclass:#UIObjectView
	instanceVariableNames:'saveSelection undoHistory copiedExtent copiedLayout resizeData
		clipChildren selectionHiddenLevel gridParameters
		setOfSuperViewsSizeChanged hasUndoHistoryHolder
		nPixelsForMoveSelection'
	classVariableNames:'CopiedLayout CopiedExtent'
	poolDictionaries:''
	category:'Interface-UIPainter'
!

Object subclass:#PostEventHandler
	instanceVariableNames:'onView'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UIObjectView
!

Object subclass:#ResizeData
	instanceVariableNames:'object selector checkForChangeSelector delta'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UIObjectView
!

Object subclass:#UndoHistory
	instanceVariableNames:'startIdentifier identifier painter history transaction enabled'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UIObjectView
!

Object subclass:#Transaction
	instanceVariableNames:'identifier type text actions'
	classVariableNames:''
	poolDictionaries:''
	privateIn:UIObjectView::UndoHistory
!

!UIObjectView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by eXept Software AG
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
    buildIn view used by the UIPainter; it provides all services for creating, deleting
    moving and changing layouts of painted components on a canvas.

    [see also:]
	UIBuilder
	UIPainterView

    [author:]
	Claus Atzkern
"

! !

!UIObjectView class methodsFor:'conversion'!

asLayoutFrameFromView:aView
    "convert layout from aView to a frameLayout. On success the frameLayout is
     returned otherwise nil
    "
    |lF lO rF rO tF tO bF bO type layout newLyt|

    type   := self layoutType:aView.
    layout := aView geometryLayout.

    layout isNil ifTrue:[
        type == #Extent ifTrue:[
            layout := aView bounds asLayout
        ]
    ].

    (type isNil or:[layout isNil]) ifTrue:[
        ^ nil
    ].

    type == #LayoutFrame ifTrue:[
        ^ layout copy
    ].

    layout isLayout ifFalse:[
        type == #Rectangle ifTrue:[
            lO := layout left.
            tO := layout top.
            rO := layout right.
            bO := layout bottom.
        ] ifFalse:[
            lO := layout x.
            tO := layout y.
            rO := lO + aView extent x.
            bO := tO + aView extent y.
        ].

        ^ LayoutFrame 
                leftFraction:0 offset:lO  
                rightFraction:0 offset:rO
                topFraction:0 offset:tO 
                bottomFraction:0 offset:bO
    ].

    lF := layout leftFraction.
    lO := layout leftOffset.
    tF := layout topFraction.
    tO := layout topOffset.
    bF := tF.
    bO := tO + aView extent y.
    rF := lF.
    rO := lO + aView extent x.

    newLyt := LayoutFrame 
                leftFraction:lF offset:lO  
                rightFraction:rF offset:rO
                topFraction:tF offset:tO 
                bottomFraction:bF offset:bO.

    (    (type == #AlignmentOrigin)
     and:[layout leftAlignmentFraction ~~ 0
      or:[layout topAlignmentFraction  ~~ 0]]
    ) ifTrue:[
        |svRc prBd dlta|

        svRc := aView superView viewRectangle.
        prBd := aView preferredBounds.
        dlta := (  ((layout rectangleRelativeTo:svRc preferred:prBd) corner)
                 - ((newLyt rectangleRelativeTo:svRc preferred:prBd) corner)
                ) rounded.

        newLyt 
            leftOffset:(lO + dlta x)
            rightOffset:(rO + dlta x)
            topOffset:(tO + dlta y)
            bottomOffset:(bO + dlta y).
    ].
  ^ newLyt.

    "Modified: 28.3.1997 / 19:52:48 / cg"
! !

!UIObjectView class methodsFor:'defaults'!

defaultGrid
    ^ 4 @ 4

!

gridShown
    ^ false

!

handleSize
    "size of blob drawn for handles"
    ^ 4

!

hitDelta
    ^ 4

! !

!UIObjectView class methodsFor:'handles'!

handlesOf:aViewOrComponent do:aBlock
    |type v h|

    (aViewOrComponent isKindOf:(Smalltalk classNamed:#LineSegmentMorph)) ifTrue:[
        aBlock value:(aViewOrComponent startPoint) value:#startPoint.
        aBlock value:(aViewOrComponent endPoint) value:#endPoint.
        ^ self.
    ].

    type := self layoutType:aViewOrComponent.

    (type == #LayoutFrame or:[type == #Rectangle]) ifTrue:[
        v := self isVerticalResizable:aViewOrComponent.
        h := self isHorizontalResizable:aViewOrComponent.

        h ifTrue:[  
            aBlock value:(aViewOrComponent leftCenter rounded ) value:#left.
            aBlock value:(aViewOrComponent rightCenter rounded) value:#right
        ].
        v ifTrue:[  
            aBlock value:(aViewOrComponent topCenter rounded   ) value:#top.
            aBlock value:(aViewOrComponent bottomCenter rounded) value:#bottom.
        ].

        (h and:[v]) ifTrue:[
            aBlock value:(aViewOrComponent origin    ) value:#origin.
            aBlock value:(aViewOrComponent topRight  ) value:#topRight.
            aBlock value:(aViewOrComponent bottomLeft) value:#bottomLeft.
            aBlock value:(aViewOrComponent corner    ) value:#corner.
            ^ self
        ]
    ].

    aBlock value:(aViewOrComponent origin    ) value:#view.
    aBlock value:(aViewOrComponent topRight  ) value:#view.
    aBlock value:(aViewOrComponent bottomLeft) value:#view.

    type == #Extent ifTrue:[
        v := self isVerticalResizable:aViewOrComponent.
        h := self isHorizontalResizable:aViewOrComponent.

        v ifTrue:[ aBlock value:(aViewOrComponent bottomCenter rounded) value:#bottom ].
        h ifTrue:[ aBlock value:(aViewOrComponent rightCenter rounded ) value:#right ].

        (h and:[v]) ifTrue:[
            aBlock value:(aViewOrComponent corner) value:#corner.
            ^ self
        ]
    ].
    aBlock value:(aViewOrComponent corner) value:#view.
! !

!UIObjectView class methodsFor:'queries'!

isHorizontalResizable:aComponent
    "returns true if aComponent is horizontal resizeable
    "
    (aComponent isKindOf:ScrollBar) ifTrue:[
        ^ aComponent orientation == #horizontal
    ].
    (aComponent isKindOf:Scroller) ifTrue:[
        ^ aComponent orientation == #horizontal
    ].
    (aComponent isKindOf:Slider) ifTrue:[
        ^ aComponent orientation == #horizontal
    ].
    (aComponent isKindOf:(Smalltalk classNamed:#LineSegmentMorph)) ifTrue:[
        ^ false
    ].
    ^ true
!

isVerticalResizable:aComponent
    "returns true if aComponent is vertical resizeable
    "
"/    (aComponent isKindOf:EditField) ifTrue:[
"/        ^ false
"/    ].
"/    (aComponent isKindOf:ComboBoxView) ifTrue:[
"/        ^ false
"/    ].
"/    (aComponent isKindOf:CheckBox) ifTrue:[
"/        ^ false
"/    ].
"/    (aComponent isKindOf:ScrollBar) ifTrue:[
"/        ^ aComponent orientation == #vertical
"/    ].
"/    (aComponent isKindOf:Scroller) ifTrue:[
"/        ^ aComponent orientation == #vertical
"/    ].
"/    (aComponent isKindOf:Slider) ifTrue:[
"/        ^ aComponent orientation == #vertical
"/    ].
    (aComponent isKindOf:(Smalltalk classNamed:#LineSegmentMorph)) ifTrue:[
        ^ false
    ].
    ^ true
!

layoutType:aViewOrComponent
    "returns layout type of aView or nil"

    |layout spec superView|

    aViewOrComponent isNil ifTrue:[ ^ nil ].
    (aViewOrComponent isKindOf:(Smalltalk classNamed:#LineSegmentMorph)) ifTrue:[
        ^ nil
    ].

    layout := aViewOrComponent geometryLayout.
    layout notNil ifTrue:[
        layout isLayout ifTrue:[
            layout isLayoutFrame        ifTrue:[ ^ #LayoutFrame ].
            layout isAlignmentOrigin    ifTrue:[ ^ #AlignmentOrigin ].
            layout isLayoutOrigin       ifTrue:[ ^ #LayoutOrigin ].
        ] ifFalse:[
            layout isRectangle          ifTrue:[ ^ #Rectangle ].
            layout isPoint              ifTrue:[ ^ #Point ].
        ].
    ] ifFalse:[
        (superView := aViewOrComponent superView) notNil ifTrue:[
            spec := superView specClass.
            spec canResizeSubComponents ifTrue:[
                ^ #Extent
            ]
        ]
    ].
    ^ nil

    "Modified: 28.2.1997 / 13:02:16 / cg"
! !

!UIObjectView methodsFor:'accessing'!

gridAlign
    "returns state of aligning to grid
    "
    ^ aligning

!

gridAlign:aBool
    "change state of aligning to grid
    "
    aBool ifTrue:[self alignOn]
	 ifFalse:[self alignOff]

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

     if littleStepH/V are nil, only bigSteps are drawn.
    "
    gridParameters isNil ifTrue:[
	gridParameters := #(10 10 nil nil 10 10 false)
    ].
    ^ gridParameters


!

gridParameters:newGridParameters
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

     if littleStepH/V are nil, only bigSteps are drawn.
    "
    newGridParameters size == 7 ifTrue:[
	gridParameters := newGridParameters
    ].


!

gridShown:aBool
    "change visibility of grid
    "
    aBool ifTrue:[self showGrid]
	 ifFalse:[self hideGrid]
!

hideGrid
    "hide grid
    "
    gridShown ifTrue:[
	self withSelectionHiddenDo:[super hideGrid]
    ]


!

nPixelsForMoveSelection
    ^ nPixelsForMoveSelection
!

nPixelsForMoveSelection:something
    nPixelsForMoveSelection := something.
!

showGrid
    "show grid
    "
    self withSelectionHiddenDo:[super showGrid]
! !

!UIObjectView methodsFor:'accessing-behavior'!

enableStateChanged
    "toggle the test mode
    "
    self shown ifTrue:[
        enableChannel value ifFalse:[
            saveSelection := selection.
            self hideSelection.
            selection := nil.
        ] ifTrue:[
            selection := saveSelection.
            self showSelection
        ]
    ]

    "Created: / 30.3.1999 / 16:17:24 / stefan"
!

enabled
    ^ enableChannel value
!

enabled:aState
    "set the modification / test mode
    "

    enableChannel value:aState

    "Modified: / 30.3.1999 / 16:18:12 / stefan"
!

resetModification
    "set modification state to false"

    undoHistory resetModification.
    self undoHistoryChanged.
!

testMode
    "returns true if running test
    "
    ^ enableChannel value not


!

testMode:aBoolean
    "change test mode
    "
    enableChannel value:(aBoolean not)
! !

!UIObjectView methodsFor:'aspects'!

hasUndoHistoryHolder
    hasUndoHistoryHolder isNil ifTrue:[
        hasUndoHistoryHolder := false asValue
    ].
    ^ hasUndoHistoryHolder
! !

!UIObjectView methodsFor:'blocked'!

addObject:anObject
    "add the argument, anObject to the contents - with redraw"

    self shouldNotImplement
!

addObjectWithoutRedraw:anObject
    "add the argument, anObject to the contents - with redraw"

    self shouldNotImplement
! !

!UIObjectView methodsFor:'enumerating'!

contentsDo:aBlock
    self subViews do:aBlock.
    self components do:aBlock.
! !

!UIObjectView methodsFor:'event handling'!

doublePressed:pressPoint
!

elementChangedSize:aView
    "some element has changed its size; collect them while selectionHiddenLevel is on"

    |spv|

    spv := self findContainerOfView:aView.

    aView isView ifFalse:[
"/        spv invalidate.
    ].

"/    spv := self findContainerOfView:aView.

    selectionHiddenLevel ~~ 0 ifTrue:[
        setOfSuperViewsSizeChanged add:spv
    ] ifFalse:[
        spv sizeChanged:nil
    ]
!

keyPress:key x:x y:y
    "any key pressed
    "
    <resource: #keyboard ( #CursorUp #CursorDown #CursorLeft #CursorRight
                           #Delete #BackSpace #Cut #Copy #Paste #Cmdu #Again) >

    |n sensor|

    (key == #Cut or:[key == #Delete or:[key == #BackSpace]]) ifTrue: [
        ^ self deleteSelection
    ].
    (key = #PreviousPage) ifTrue:[
        self selectNextUpInHierarchy.
    ].
    key == #Copy  ifTrue:[ ^ self copySelection].
    key == #Paste ifTrue:[ ^ self pasteBuffer].
    key == #Cmdu  ifTrue:[ ^ self undoLast ].           "/ #Undo

    ( #(CursorUp CursorDown CursorRight CursorLeft)
    includes:key) ifTrue:[
        (sensor := self sensor) isNil ifTrue:[
            n := 1
        ] ifFalse:[
            n := 1 + (sensor compressKeyPressEventsWithKey:key).
            sensor shiftDown ifTrue:[
                n := n * 10.
            ].
        ].

        key == #CursorUp ifTrue:[
            ^ self moveSelectionUp:n
        ].
        key == #CursorDown ifTrue:[
            ^ self moveSelectionDown:n
        ].
        key == #CursorRight ifTrue:[
            ^ self moveSelectionRight:n
        ].
        key == #CursorLeft ifTrue:[
            ^ self moveSelectionLeft:n
        ].
    ].
    super keyPress:key x:x y:y

    "Modified: / 6.3.1999 / 22:47:48 / cg"
!

processEvent:anEvent
    "catch expose events for components, and redraw its handles after
     the redraw when this happens.
     Return true, if I have eaten the event"

    |evView widget p|

    self testMode ifTrue:[^ false].

    anEvent isInputEvent ifFalse:[^ false].

    evView := anEvent view.
    evView isNil ifTrue:[ ^ false].

    (evView == self) ifTrue:[
        "/ new: check for a component to be hit by the event

        components notEmptyOrNil ifTrue:[
            anEvent x notNil ifTrue:[
                p := (anEvent x @ anEvent y).        
                widget := components detect:[:c | c bounds containsPoint:p ] ifNone:nil.
            ].
        ].
        widget isNil ifTrue:[
            ^ false
        ].
    ] ifFalse:[
        widget := evView.
    ].

    (widget isComponentOf:self) ifFalse:[
        ^ false
    ].

    "/ eat most of my events
    anEvent isPointerEnterLeaveEvent ifTrue:[^ true. ^ false].
    anEvent isKeyboardFocusEvent ifTrue:[^ true. ^ false].

    (anEvent isButtonEvent or:[anEvent isKeyEvent]) ifFalse:[ ^ true ].

    anEvent isButtonMotionEvent ifTrue:[
        "/ use current point - layout of underlaying view might change
        "/ and computation dependent on origin is wrong
        p := self sensor mousePoint.
        p := device translatePoint:p fromView:nil toView:self.
    ] ifFalse:[
        p := (anEvent x) @ (anEvent y).
        p := device translatePoint:p fromView:evView toView:self.
    ].

    "/ patch the event
    anEvent x:p x.
    anEvent y:p y.
    anEvent view:self.
    ^ false.
!

redrawX:nx y:ny width:nw height:nh
    |redrawFrame|

    redrawFrame := Rectangle left:nx top:ny width:nw height:nh.
    "/ self clearRectangle:redrawFrame.
    super redrawX:nx y:ny width:nw height:nh.

    self selectionDo:[:aComponent |
        |anyHandleToRedraw|

        anyHandleToRedraw := false.
        self handlesOf:aComponent do:[:hRect :typeOfHandle |
            (hRect intersects:redrawFrame) ifTrue:[        
                anyHandleToRedraw := true.
            ].
        ].
        anyHandleToRedraw ifTrue:[
            self showSelected:aComponent
        ]
    ]

    "Modified: / 16-01-2008 / 17:57:09 / cg"
!

sizeChanged:how
    "size of a view(s) changed
    "
    self withSelectionHiddenDo:[
        super sizeChanged:how.
    ].
! !

!UIObjectView methodsFor:'initialization'!

initialize
    "setup attributes
    "
    super initialize.

    setOfSuperViewsSizeChanged := IdentitySet new.
    self setDefaultActions.

    undoHistory := UndoHistory on:self.

    self enableChannel:(true asValue).
    clipChildren         := true.
    selectionHiddenLevel := 0.
    nPixelsForMoveSelection := 1.

    (self class gridShown) ifTrue:[
        super showGrid
    ].

    "Modified: / 20.7.1998 / 18:14:51 / cg"
    "Modified: / 30.3.1999 / 16:19:15 / stefan"
!

map
    "make the view visible on the screen and in case of a none empty
     selection the selection will be shown.
    "
    super map.
    self showSelection.
!

realize
    |windowGroup|

    super realize.
    windowGroup := self windowGroup.
    windowGroup  addPreEventHook:self.
    windowGroup addPostEventHook:(PostEventHandler new onView:self).
!

remap
    "make the view visible on the screen and in case of a none empty
     selection the selection will be shown"

    self shouldNotImplement
! !

!UIObjectView methodsFor:'misc'!

invertOutlineOf:something
    "invert outline of an object or collection of objects"

    ^ self.

"/ cg: nope - all done via handles now.

"/    |wasClipped|
"/
"/    (wasClipped := clipChildren) ifTrue:[
"/        self clippedByChildren:(clipChildren := false).
"/    ].
"/
"/    self xoring:[
"/        |p|
"/
"/        something isCollection ifTrue:[
"/            something do:[:v |
"/                p := v originRelativeTo:self.
"/                self displayRectangle:(p extent:v extent).
"/            ].
"/        ] ifFalse:[
"/            p := something originRelativeTo:self.
"/            self displayRectangle:(p extent:something extent).
"/        ]
"/    ].
"/
"/    wasClipped ifTrue:[
"/        self clippedByChildren:(clipChildren := true).
"/    ].
!

minClosedViewSetFor:setOfViews
    "return the minimum closure for a given set of view;
     That is the minimum set of views which contains the given set of views.
     Concrete: all subviews from setOfViews of which any superView is already in the set
               is excluded from the result"

    setOfViews isCollection ifFalse:[
        setOfViews notNil ifTrue:[^ Array with:setOfViews].
        ^ nil
    ].
    ^ setOfViews reject:[:aView| (setOfViews contains:[:v | aView isComponentOf:v]) ]
!

redrawObjectsInVisible:redrawFrame
    "my objects are views - they redraw themself.
     - no longer - all non-views MUST be redrawn."

    super redrawObjectsInVisible:redrawFrame.
    ^ self
!

setDefaultActions
    "set default actions
    "
    pressAction      := [:pressPoint | self startSelectOrMove:pressPoint].
    shiftPressAction := [:pressPoint | self startSelectMoreOrMove:pressPoint].
    ctrlPressAction  := [:pressPoint | self startSelectMoreOrMove:pressPoint].
    motionAction     := [:movePoint  | nil].
    releaseAction    := [nil].
    keyPressAction   := nil.
    doublePressAction   := [:pressPoint | self doublePressed: pressPoint].

    self cursor:Cursor normal.
! !

!UIObjectView methodsFor:'object moving'!

doObjectMove:aPoint
    "move movedOject (which is a misnomer - it's actually a collection of objects to move)"

    |anyMove|

    movedObject isEmptyOrNil ifTrue:[^ self].

    anyMove := false.
    "/ to avoid flicker, check if this really involves a move (due to align)
    movedObject keysAndValuesDo:[:i :obj|
        |newOrigin delta|

        newOrigin := (aPoint - (moveDelta at:i)).
        delta := (self alignToGrid:newOrigin) - obj computeOrigin.
        delta ~= (0@0) ifTrue:[ anyMove := true ].
    ].
    anyMove ifFalse:[^ self ].

    self hideSelection.
    self invertOutlineOf:movedObject.

    movedObject keysAndValuesDo:[:i :v|
        self moveObject:v to:(aPoint - (moveDelta at:i)).
    ].

    self invertOutlineOf:movedObject.
    self showSelection.
!

endObjectMove
    "cleanup after object(s) move
     send expose to each view - workaround....
    "
    |newSel|

    movedObject isNil ifTrue:[^ self].

    movedObject size == 1 ifTrue:[ newSel := movedObject first ]
                         ifFalse:[ newSel := movedObject ].
    movedObject := nil.

"/    self withSelectionHiddenDo:[
"/        self setSelection:newSel withRedraw:false.
"/
"/        components notEmptyOrNil ifTrue:[
"/            self invalidate.
"/        ].
"/        self allSubViewsDo:[:v|
"/            v shown ifTrue:[
"/                v fill:v viewBackground.
"/                v exposeX:0 y:0 width:v width height:v height.
"/            ].
"/        ].
"/    ].

    self setDefaultActions.
    self layoutChanged.
!

moveObject:anObject to:aPoint
    "move anObject to newOrigin, aPoint"

    |dX dY org delta|

    anObject notNil ifTrue:[
        org := anObject computeOrigin.
        org notNil ifTrue:[
            delta := aPoint - org.
            delta := (self alignToGrid:aPoint) - org.
            dX := delta x.
            dY := delta y.

            undoHistory withoutTransactionDo:[
                self shiftLayout:anObject horizontal:dX vertical:dY
            ]
        ]
    ]

    "Modified: / 25-07-2011 / 17:27:08 / cg"
!

startObjectMoveAt:aPoint
    "start object(s) move at a point"

    self startObjectMove:(self selection) at:aPoint.
    movedObject := self selection.

    movedObject isCollection ifFalse:[
        movedObject := Array with:movedObject
    ].
"/    self setSelection:nil withRedraw:true.

    moveDelta := movedObject collect:[:aView | aPoint - aView computeOrigin].

    self transaction:#move objects:movedObject do:[:v|self createUndoLayout:v].
    self invertOutlineOf:movedObject.
!

startSelectMoreOrMove:aPoint
    "add/remove to/from selection"

    |anObject|

    self enabled ifFalse:[^ self].

    anObject := self findObjectAt:aPoint.
    anObject notNil ifTrue:[
	(self isSelected:anObject) ifTrue:[
	    self removeFromSelection:anObject
	] ifFalse:[
	    self addToSelection:anObject
	]
    ]
!

startSelectOrMove:aPoint
    "a button is pressed at a point; start moving or selecting"

    |selectedView containerOfSelectedView
     clickedView viewOperatedUpon borderHandleSelector pView|

    self enabled ifFalse:[^ self].

    selectedView := self singleSelection.

"/    clickedView := self findObjectAt:aPoint.
"/    (clickedView notNil 
"/    and:[clickedView isComponentOf:selectedView]) ifTrue:[
"/        self unselect.
"/        selectedView := nil.    
"/    ].

    "/ if there is already a selection, see if user clicked onto a handle
    "/ then, this may be the start of a resize operation.
    selectedView notNil ifTrue:[
        containerOfSelectedView := self findContainerOfView:selectedView.

        containerOfSelectedView specClass canResizeSubComponents ifTrue:[
            borderHandleSelector := self whichHandleOf:selectedView isHitBy:aPoint.
            (borderHandleSelector notNil and:[borderHandleSelector ~~ #view]) ifTrue:[
                self startResizeBorder:borderHandleSelector.
                ^ self
            ]
        ].
        viewOperatedUpon := selectedView.

        pView := device translatePoint:aPoint fromView:self toView:selectedView superView.
        (selectedView bounds containsPoint:pView) ifFalse:[
            "/ clicked outside the selection
            (self sensor ctrlDown and:[self canChangeLayoutOfView:selectedView]) ifFalse:[
                viewOperatedUpon := nil
            ]
        ]
    ].

    clickedView := self findObjectAt:aPoint.
    clickedView notNil ifTrue:[
        (clickedView isComponentOf:selectedView) ifTrue:[
            "/ self unselect.
            selectedView := nil.    
            viewOperatedUpon := nil
        ] ifFalse:[
            "/ self unselect.
            selectedView := nil.    
            viewOperatedUpon := clickedView
        ].
    ].

    viewOperatedUpon isNil ifTrue:[
        clickedView isNil ifTrue:[
            "/ clicked outside - start a rectangle drag.
            self select:nil.
            self startRectangleDrag:aPoint.
            ^ self.
        ].

        (self canChangeLayoutOfView:clickedView) ifFalse:[
            self select:clickedView.
            ^ self
        ].
        viewOperatedUpon := clickedView
    ].

    (self isSelected:viewOperatedUpon) ifFalse:[
        self select:viewOperatedUpon.
    ].

    (self numberOfSelections ~~ 1) ifTrue:[
        releaseAction := 
            [
                self setDefaultActions.
                self select:viewOperatedUpon
            ]
    ] ifFalse:[
        releaseAction := [self setDefaultActions]
    ].

    "prepare move operation for an object"
    motionAction := 
        [:movePoint|
            (aPoint dist:movePoint) > 4.0 ifTrue:[
                self startObjectMoveAt:aPoint
            ]
        ].
! !

!UIObjectView methodsFor:'object resize'!

actionResize:anObject selector:aSelector
    "create and initialize action for resize"

    |delta|

    delta    := anObject container originRelativeTo:self.
    resizeData := ResizeData new
                        object:anObject 
                        selector:aSelector
                        delta:delta.

"can change cursor dependent on vertical/horizontal resizing
"
    oldCursor := cursor.
    self cursor:(Cursor leftHand).

    "Modified: / 2.2.1998 / 13:40:55 / cg"
!

doDragResize:aPoint
    "do a widget resize drag"

    |p object|

    object := resizeData object.
    p := (self alignToGrid:aPoint) - (resizeData delta).

    (self resize:object handle:(resizeData selector) to:p check:true) ifFalse:[
        ^ self  "/ no real change (due to align)
    ].

    self hideSelection.

    self invertOutlineOf:object.

    self resize:object handle:(resizeData selector) to:p check:false.

    Delay waitForSeconds:0.05.
    [self sensor hasExposeEventFor:nil] whileTrue:[
        self windowGroup processExposeEvents
    ].

   "/ object geometryLayout:(object geometryLayout).
    self invertOutlineOf:object.

    self showSelection.
!

endResize
    "cleanup after object resize"

    |object savedSelection anyLayoutWrapper anyTransparentBox|

    object := resizeData object.
    resizeData := nil.

    "/ container objects might want to rearrange their elements after a size change;
    "/ therefore, we hide the handles while this is possibly done.
    "/ however, to avoid flicker, we check for containers first.
    anyLayoutWrapper := anyTransparentBox := false.
    self forEach:object do:[:aViewOrComponent | 
        aViewOrComponent isLayoutWrapper ifTrue:[ anyLayoutWrapper := true ].
        aViewOrComponent isTransparentBox ifTrue:[ anyTransparentBox := true ].
    ].

    (anyLayoutWrapper or:[anyTransparentBox]) ifTrue:[

        self invertOutlineOf:object.

        "/ temporarily hide the selection, in order to allow the container to move the
        "/ element around...
        savedSelection := selection.
        self setSelection:nil withRedraw:true.

        "/ handle any expose events (for subcomponents) before
        "/ redrawing the handles.
        self windowGroup processExposeEvents.

        self elementChangedSize:object.

        "/ handle any expose events (for subcomponents) before
        "/ redrawing the handles.
        Delay waitForSeconds:0.05.
        [self sensor hasExposeEventFor:nil] whileTrue:[
            self windowGroup processExposeEvents
        ].

        self forEach:savedSelection do:[:aView |
            self recomputeShapeIfTransparentBox:aView.
        ].

        self setSelection:object withRedraw:true.
    ].

    self layoutChanged.
    self setDefaultActions.
!

layoutChanged
!

resize:aView bottom:aPoint
    "obsolete: resize a views bottom"

    self resize:aView handle:#bottom to:aPoint check:false.
"/    undoHistory withoutTransactionDo:[
"/        self shiftLayout:aView top:0 bottom:((aPoint y) - (aView computeCorner y))
"/    ].
!

resize:aView bottomLeft:aPoint
    "obsolete: resize a views bottom and left"

    self resize:aView handle:#bottomLeft to:aPoint check:false.
"/    undoHistory withoutTransactionDo:[
"/        self shiftLayout:aView top:0
"/                            bottom:((aPoint y) - (aView computeCorner y))
"/                              left:((aPoint x) - (aView computeOrigin x))
"/                             right:0
"/
"/    ]
!

resize:aView corner:aPoint
    "obsolete: resize a views corner"

    self resize:aView handle:#corner to:aPoint check:false.
"/    |delta|
"/
"/    delta := aPoint - aView computeCorner.
"/    undoHistory withoutTransactionDo:[
"/        self shiftLayout:aView top:0 bottom:(delta y) left:0 right:(delta x)
"/    ]
!

resize:aComponent endPoint:newEndPoint
    "obsolete: move a component's endPoint"

    self resize:aComponent handle:#endPoint to:newEndPoint check:false

"/    undoHistory 
"/        withoutTransactionDo:[
"/            self shiftLayout:aComponent startPoint:0 endPoint:(newEndPoint - (aComponent endPoint))
"/        ]
!

resize:aComponent handle:aSymbol to:aPoint check:doCheck
    "resize a views handle - if doCheck is true, only check if the handle would change
     (used to avoid flicker, when an aligned move would actually not move anything)"

    |newX newY oldBottom oldTop oldLeft oldRight 
     oldOrigin oldCorner shiftTop shiftBottom shiftLeft shiftRight|

    aSymbol == #startPoint ifTrue:[
        doCheck ifTrue:[
            ^ aPoint ~= (aComponent startPoint)
        ].
        self 
            shiftLayout:aComponent 
            startPoint:(aPoint - (aComponent startPoint)) endPoint:0.
        ^ self.
    ].
    aSymbol == #endPoint ifTrue:[
        doCheck ifTrue:[
            ^ aPoint ~= (aComponent endPoint)
        ].
        self 
            shiftLayout:aComponent 
            startPoint:0 endPoint:(aPoint - (aComponent endPoint)).
        ^ self.
    ].

    newX := aPoint x.
    newY := aPoint y.
    shiftTop := shiftBottom := shiftLeft := shiftRight := 0.

    oldOrigin := aComponent computeOrigin.
    oldCorner := aComponent computeCorner.

    oldTop := oldOrigin y.
    oldBottom := oldCorner y.
    oldLeft := oldOrigin x.
    oldRight := oldCorner x.

    aSymbol == #bottom ifTrue:[
        shiftBottom := newY - oldBottom.
    ]. 
    aSymbol == #top ifTrue:[     
        shiftTop := newY - oldTop.
    ].
    aSymbol == #left ifTrue:[
        shiftLeft := newX - oldLeft.
    ].
    aSymbol == #right ifTrue:[
        shiftRight := newX - oldRight.
    ].
    aSymbol == #origin ifTrue:[
        shiftLeft := newX - oldLeft.
        shiftTop := newY - oldTop.
    ].
    aSymbol == #topRight ifTrue:[
        shiftRight := newX - oldRight.
        shiftTop := newY - oldTop.
    ].
    aSymbol == #corner ifTrue:[
        shiftRight := newX - oldRight.
        shiftBottom := newY - oldBottom.
    ].
    aSymbol == #bottomLeft ifTrue:[
        shiftLeft := newX - oldLeft.
        shiftBottom := newY - oldBottom.
    ].

    doCheck ifTrue:[
        ^ (shiftTop ~= 0) or:[ shiftBottom ~= 0 or:[ shiftLeft ~= 0 or:[ shiftRight ~= 0 ]]]
    ].

    undoHistory withoutTransactionDo:[
        self 
            shiftLayout:aComponent 
            top:shiftTop bottom:shiftBottom 
            left:shiftLeft right:shiftRight
    ].
!

resize:aView left:aPoint
    "obsolete: resize a views left"

    self resize:aView handle:#left to:aPoint check:false.
"/    undoHistory withoutTransactionDo:[
"/        self shiftLayout:aView left:((aPoint x) - (aView computeOrigin x)) right:0
"/    ]
!

resize:aView origin:aPoint
    "obsolete: resize a views origin"

    self resize:aView handle:#origin to:aPoint check:false.
"/    |delta|
"/
"/    delta := aPoint - aView computeOrigin.
"/    undoHistory withoutTransactionDo:[
"/        self shiftLayout:aView top:(delta y) bottom:0 left:(delta x) right:0
"/    ]
!

resize:aView right:aPoint
    "obsolete: resize a views right"

    self resize:aView handle:#right to:aPoint check:false.
"/    undoHistory withoutTransactionDo:[
"/        self shiftLayout:aView left:0 right:((aPoint x) - (aView computeCorner x))
"/    ]
!

resize:aComponent startPoint:newStartPoint
    "obsolete: move a component's startPoint"

    self resize:aComponent handle:#startPoint to:newStartPoint check:false
"/    undoHistory 
"/        withoutTransactionDo:[
"/            self shiftLayout:aComponent startPoint:(newStartPoint - (aComponent startPoint)) endPoint:0
"/        ]
!

resize:aView top:aPoint
    "obsolete: resize a views top"

    self resize:aView handle:#top to:aPoint check:false.
"/    undoHistory withoutTransactionDo:[
"/        self shiftLayout:aView 
"/                top:((aPoint y) - (aView computeOrigin y)) 
"/                bottom:0
"/    ]
!

resize:aView topRight:aPoint
    "obsolete: resize a views top and right"

    self resize:aView handle:#topRight to:aPoint check:false.
"/    undoHistory withoutTransactionDo:[
"/        self shiftLayout:aView 
"/                top:((aPoint y) - (aView computeOrigin y))
"/                bottom:0
"/                left:0
"/                right:((aPoint x) - (aView computeCorner x))
"/    ]
!

startResizeBorder:borderHandleSelector
    "start resizing the selected view at the given borderHandle"

    |object|

    object := self singleSelection.
    self actionResize:object selector:borderHandleSelector.

    self 
        transaction:#resize 
        selectionDo:[:aView|
            self createUndoLayout:aView
        ].
    "/ self setSelection:nil withRedraw:true.

    motionAction  := [:movePoint | self doDragResize:movePoint].
    releaseAction := [self endResize].

    self invertOutlineOf:object
! !

!UIObjectView methodsFor:'private'!

undoHistoryChanged
    self hasUndoHistoryHolder value:(self hasUndoHistory).
! !

!UIObjectView methodsFor:'private-handles'!

handlesOf:aComponent do:aTwoArgAction
    "perform aTwoArgAction on each handle of a component"

    |dlt ext|

    dlt := (aComponent originRelativeTo:self) - aComponent origin.
    dlt := dlt - (4@4).
    ext := 8@8.

    self class 
        handlesOf:aComponent 
        do:[:pnt :wht |
            aTwoArgAction value:(pnt + dlt extent:ext) value:wht
        ]
!

whichHandleOf:aComponent isHitBy:aPoint
    "returns kind of handle or nil"

    self handlesOf:aComponent do:[:rectangle :what|
        (rectangle containsPoint:aPoint) ifTrue:[^ what]
    ].
    ^ nil
! !

!UIObjectView methodsFor:'private-resizing subviews'!

recomputeShapeIfTransparentBox:aView
    (aView notNil and:[aView isTransparentBox]) ifTrue:[
        aView computeShape.
        aView clear; redraw
    ].
! !

!UIObjectView methodsFor:'private-shift layout'!

shiftLayout:aViewOrComponent horizontal:n
    "shift layout for a view; in case of an open transaction, the undo action is registered"

    self shiftLayout:aViewOrComponent horizontal:n vertical:0
!

shiftLayout:aViewOrComponent horizontal:h vertical:v
    "shift layout for a view; in case of an open transaction, the undo action is registered"

    (self specFor:aViewOrComponent) hasLayout ifTrue:[
        self shiftLayout:aViewOrComponent top:v bottom:v left:h right:h
    ] ifFalse:[
        self shiftLayout:aViewOrComponent startPoint:(h @ v) endPoint:(h @ v)
    ].
!

shiftLayout:aView left:l right:r
    "shift layout for a view; in case of an open transaction, the undo action is registered"

    self shiftLayout:aView top:0 bottom:0 left:l right:r
!

shiftLayout:aComponent startPoint:deltaS endPoint:deltaE
    "shift coordinates; in case of an open transaction, the undo action is registered"

    self createUndoStartPointEndPoint:aComponent.
    aComponent 
        startPoint:(aComponent startPoint + deltaS)
        endPoint:(aComponent endPoint + deltaE).
!

shiftLayout:aView top:t bottom:b
    "shift layout for a view; in case of an open transaction, the undo action is registered"

    self shiftLayout:aView top:t bottom:b left:0 right:0
!

shiftLayout:aView top:t bottom:b left:l right:r
    "shift layout for a view; in case of an open transaction, the undo action is registered"

    |type layout oldExt dX dY|

    type := self class layoutType:aView.
    type isNil ifTrue:[ ^ self ].

    self createUndoLayout:aView.

    type == #Extent ifTrue:[
        oldExt := aView extent.
        dX := r-l.
        dY := b-t.
        aView extent:(oldExt + (dX @ dY)).
        ^ self 
    ].

    layout := aView geometryLayout copy.
    layout isLayout ifTrue:[
        layout leftOffset:(layout leftOffset + l)
                topOffset:(layout topOffset  + t).
                
        type == #LayoutFrame ifTrue:[
            b ~= 0 ifTrue:[
                layout bottomOffset:(layout bottomOffset + b).
            ].
            r ~= 0 ifTrue:[
                layout rightOffset:(layout rightOffset  + r).
            ].
        ]
    ] ifFalse:[
        type == #Rectangle ifTrue:[
            layout left:(layout left   + l)
                  right:(layout right  + r)
                    top:(layout top    + t)
                 bottom:(layout bottom + b).
        ] ifFalse:[     "POINT"
            layout x:(layout x + l) y:(layout y + t).
        ]
    ].
    aView geometryLayout:layout
!

shiftLayout:aViewOrComponent vertical:n
    "shift layout for a view; in case of an open transaction, the undo action is registered"

    self shiftLayout:aViewOrComponent horizontal:0 vertical:n
! !

!UIObjectView methodsFor:'searching'!

findObjectAt:aPoint
    |componentOrView|

    componentOrView := self findObjectAt:aPoint in:self.

    componentOrView == self ifTrue:[^ nil].
    ^ componentOrView.

"/ cg: old code, which I do not understand
"/    point := device translatePoint:aPoint fromView:self toView:rootView.
"/
"/    viewId := rootView id.
"/    [viewId notNil] whileTrue:[
"/        lastId := viewId.
"/        viewId := device viewIdFromPoint:point in:lastId. "/ must be rootView coordinate
"/    ].
"/
"/    view := device viewFromId:lastId.
"/    (view isNil or:[view == self]) ifTrue:[ 
"/        "/ used to return nil here;
"/        "/ now support a mix of views and components...
"/        components notEmptyOrNil ifTrue:[
"/            component := components detect:[:c | c bounds containsPoint:aPoint] ifNone:nil.
"/            ^ component
"/        ].
"/        ^ nil
"/    ].
"/    ^ view
!

findObjectAt:aPoint in:aView
    |lastHit lastRelPoint view point|

    "/ reverse search, to find covering ones first.
    aView subViews reverseDo:[:aSubView |
        |innerObject relPoint|

        ((aSubView origin extent:aSubView extent) containsPoint:aPoint) ifTrue:[
            relPoint := device translatePoint:aPoint fromView:aView toView:aSubView.
            innerObject := self findObjectAt:relPoint in:aSubView.
            innerObject notNil ifTrue:[ ^ innerObject ].
            lastHit := aSubView.
            lastRelPoint := relPoint.
        ]
    ].
    view := lastHit ? aView.
    point := lastRelPoint ? aPoint.

    view components notEmptyOrNil ifTrue:[
        view components reverseDo:[:eachComponent |
            (eachComponent frame containsPoint:point) ifTrue:[
                ^ eachComponent
            ].
        ].
    ].
    ^ view
! !

!UIObjectView methodsFor:'selections'!

hideSelection
    "hide the selection - undraw hilights - whatever that is
    "

    super hideSelection.
    self repairDamage.   
"/    self showUnselected:selection.
!

moveableSelection
    "checks whether the selection is not empty and all selected instances
     can be moved. If true the selection is returned otherwise nil
    "
    |coll|

    self hasSelection ifTrue:[
        (self canMove:(coll := self selection)) ifTrue:[
            ^ coll
        ]
    ].
    ^ nil
!

numberOfSelections
    "return the number of selected instances
    "
    |coll size|

    coll := self selection.
    size := coll size.

    (size ~~ 0 or:[coll isNil]) ifTrue:[^ size].
  ^ 1
!

resizableSelection
    "checks whether the selection is not empty and all selected instances
     can be resized. If true the selection is returned otherwise nil
    "
    |coll|

    self hasSelection ifTrue:[
        coll := self selection.        
        (self canResize:coll) ifTrue:[
            ^ coll
        ]
    ].
    ^ nil
!

selectNextUpInHierarchy
    self breakPoint:#ca.
!

selection:newSelection
    "change selection to newSelection"

    self select:newSelection
!

selectionDo:aBlock
    "apply block to every selected object
    "
    self forEach:(self selection) do:aBlock


!

showSelection
    "show the selection - draw handles"

    selectionHiddenLevel == 0 ifTrue:[
        super showSelection.
        self repairDamage.   
    ].
!

singleSelection
    "checks whether a single element is selected; in this case the element is
     returned otherwise nil"

    |sel|

    sel := self selection.
    sel isCollection ifTrue:[
        sel := sel size == 1 ifTrue:[sel first] ifFalse:[nil].
    ].
    ^ sel
!

singleSelectionDo:aBlock
    "checks whether one element is selected; in this case the block
     with argument the selected instance will be processed
    "
    |view|

    (view := self singleSelection) notNil ifTrue:[
	aBlock value:view
    ]
!

twoElementSelection
    "checks whether exactly two elements are selected; 
     in this case, return the selection collection.
     otherwise return nil
    "
    |coll|

    (coll := self selection) isCollection ifFalse:[
        ^ nil "/ single
    ].

    coll size == 2 ifTrue:[ ^ coll].
    ^ nil
!

unselect
    "clear selection
    "
    self select:nil
!

withSelectionHiddenDo:aBlock
    "apply block with selection hidden (no handles)"

    |coll|

    selectionHiddenLevel == 0 ifTrue:[
        self hideSelection.
        self flush.
    ].
    selectionHiddenLevel := selectionHiddenLevel + 1.

    aBlock 
        ensure:[
            selectionHiddenLevel == 1 ifTrue:[
                "/ careful to decrement selectionHiddenLevel AFTER the sizeChanged;
                "/ otherwise, we get endless recursion here.
                setOfSuperViewsSizeChanged notEmpty ifTrue:[
                    coll := self minClosedViewSetFor:setOfSuperViewsSizeChanged.
                    coll do:[:aView| aView sizeChanged:nil].
                    setOfSuperViewsSizeChanged := IdentitySet new
                ].
                selectionHiddenLevel := selectionHiddenLevel - 1.
                self showSelection.
            ] ifFalse:[
                selectionHiddenLevel := selectionHiddenLevel - 1.
            ].
        ]
!

withoutSelectionDo:aBlock
    "evaluate aBlock while selection is nilled
    "
    |sel|

    self hasSelection ifFalse:[
	aBlock value
    ] ifTrue:[
	sel := self selection.
	self setSelection:nil withRedraw:true.
	aBlock value.
	self setSelection:sel withRedraw:true.
    ]


! !

!UIObjectView methodsFor:'selections-basic'!

recursiveRepair:theDamages startIn:aView
    "repair all views and contained views, which intersects the damage.
     !!!! all damages repaired are removed from the list of damages !!!!
    "
    |color isRepaired relOrg damage
     bwWidth    "{ Class:SmallInteger }"
     x          "{ Class:SmallInteger }"
     y          "{ Class:SmallInteger }"
     w          "{ Class:SmallInteger }"
     h          "{ Class:SmallInteger }"
     relOrgX    "{ Class:SmallInteger }"
     relOrgY    "{ Class:SmallInteger }"
     width      "{ Class:SmallInteger }"
     height     "{ Class:SmallInteger }"
     size       "{ Class:SmallInteger }"
    |
    aView isInputOnly ifTrue:[^ self ].

    (aView shown and:[theDamages notEmpty]) ifFalse:[ ^ self ].

    aView components notEmptyOrNil ifTrue:[ 
        aView invalidate 
    ].
    aView subViews notNil ifTrue:[
        aView subViews reverseDo:[:v| self recursiveRepair:theDamages startIn:v ].
        theDamages isEmpty ifTrue:[ ^ self ].
    ].

    relOrg  := aView originRelativeTo:self.
    bwWidth := aView borderWidth.
    size    := theDamages size.

    "/ compute relative origin starting from border left@top
    relOrgX := relOrg x - bwWidth.
    relOrgY := relOrg y - bwWidth.
    width   := aView width  + bwWidth + bwWidth.
    height  := aView height + bwWidth + bwWidth.

    size to:1 by:-1 do:[:anIndex|
        damage := theDamages at:anIndex.

        "/ compute the rectangle into the view
        y := damage top  - relOrgY.
        x := damage left - relOrgX.
        w := damage width.
        h := damage height.

        isRepaired := true.

        x     < 0      ifTrue:[ w := w + x. x := 0. isRepaired := false ].
        y     < 0      ifTrue:[ h := h + y. y := 0. isRepaired := false ].
        x + w > width  ifTrue:[ w := width  - x.    isRepaired := false ].
        y + h > height ifTrue:[ h := height - y.    isRepaired := false ].

        (w > 0 and:[h > 0]) ifTrue:[
            bwWidth ~~ 0 ifTrue:[
                color isNil ifTrue:[
                    "/ must force redraw of border
                    "/ color := aView borderColor.
                    "/ aView borderColor:(Color colorId:1).  "/ kludge to force a redraw
                    "/ aView borderColor:color.
                    aView invalidate.
                ].
                w := w - bwWidth.
                h := h - bwWidth.

                (x := x - bwWidth) < 0 ifTrue:[w := w + x. x := 0].
                (y := y - bwWidth) < 0 ifTrue:[h := h + y. y := 0].

                (w > 0 and:[h > 0])  ifFalse:[w := 0].
            ].

            w > 0 ifTrue:[
                aView clearRectangleX:x y:y width:w height:h.
                aView exposeX:x y:y width:w height:h
            ].
            isRepaired ifTrue:[ theDamages removeIndex:anIndex ].
        ]
    ].
!

selection
    "returns the current selection
    "

    "/ Q to ca: why redefine the collection building???
    ^ super selection.

    ^ selection
!

setSelection:newSelection withRedraw:doRedraw
    "set a new selection without change notifications"

    | sel |

    (sel := newSelection) == self ifTrue:[
        sel := nil
    ].

    doRedraw ifTrue:[
        self hideSelection.
        selection := sel.

        self forEach:selection do:[:aView |
            |superView|

            superView := aView superView. 
            self recomputeShapeIfTransparentBox:superView.
        ].
        self showSelection.
    ] ifFalse:[
        selection := sel
    ]
!

showUnselected:something
    "show a component or list of components unselected"

    |damages oldClipped savedSelection|

    (selectionHiddenLevel ~~ 0 or:[something isNil]) ifTrue:[
        ^ self
    ].

    damages := OrderedCollection new.

    self forEach:something do:[:v|
        self handlesOf:v do:[:aDamage :wht|
            damages reverseDo:[:el|
                (el intersects:aDamage) ifTrue:[
                    damages removeIdentical:el.

                    aDamage left:(aDamage left   min:el left) floor
                           right:(aDamage right  max:el right) ceiling
                             top:(aDamage top    min:el top) floor
                          bottom:(aDamage bottom max:el bottom) ceiling
                ]
            ].                        
            damages add:aDamage
        ]
    ].

    damages do:[:el| self clearRectangle:el. ].

    (oldClipped := clipChildren) ifFalse:[
        self clippedByChildren:(clipChildren := true)
    ].
    self subViews reverseDo:[:v| self recursiveRepair:damages startIn:v].

    oldClipped ~~ clipChildren ifTrue:[
        self clippedByChildren:(clipChildren := oldClipped).
    ].

    self flush.

    savedSelection := selection.
    [
        selection := nil.
        damages do:[:el| self invalidate:el ].
        self repairDamage.
    ] ensure:[
        selection := savedSelection
    ].
! !

!UIObjectView methodsFor:'testing'!

hasSelection
    "returns true if any widget is selected
    "
    ^ self numberOfSelections ~~ 0

!

hasSingleSelection
    "returns true if one widget is selected
    "
    ^ self numberOfSelections == 1

!

hasUndoHistory
    "returns true if undos exists"

    ^ undoHistory notEmpty
!

isModified
    "returns true if painter is modified"

    ^ undoHistory isModified
!

isSelected:anObject
    "return true, if the argument, anObject is selected
    "
    anObject notNil ifTrue:[
	self selectionDo:[:el| el == anObject ifTrue:[^ true]]
    ].
  ^ false

!

object:anObject isContainedIn:aRectangle
    ^ anObject bounds isContainedIn:aRectangle
! !

!UIObjectView methodsFor:'transaction'!

createUndoLayout:aView
    "prepare undo action for a view changing its layout
    "
    self subclassResponsibility

!

transaction:aType objects:something do:aOneArgBlock
    "opens a transaction and evaluates a block within the transaction; the
     argument to the block is a view from derived from something
    "
    self subclassResponsibility


!

transaction:aType selectionDo:aOneArgBlock
    "opens a transaction and evaluates a block within the transaction; the
     argument to the block is a view from the selection
    "
    self transaction:aType objects:(self selection) do:aOneArgBlock


! !

!UIObjectView methodsFor:'user actions-dimension'!

copyExtent
    "copy the extent from the selected object"

    |object|

    object := self singleSelection.
    object notNil ifTrue:[
        CopiedExtent := object computeExtent
    ] ifFalse:[
        self warn:'Exactly one element must be selected!!'.
    ]
!

copyLayout
    "copy the layout from the selected object"

    |object|

    object := self singleSelection.
    object notNil ifTrue:[
        CopiedLayout := object geometryLayout copy
    ] ifFalse:[
        self warn:'Exactly one element must be selected!!'.
    ]
!

exchangeLayouts
    "exchange the layout of two elements 
     (useful to change the order of radiobuttons or checkBoxes)
    "
    |objects l1 l2|

    objects := self twoElementSelection.

    objects notNil ifTrue:[
        l1 := (objects at:1) geometryLayout copy.
        l2 := (objects at:2) geometryLayout copy.
        self transaction:#exchangeLayout dimensionDo:[:v|
            v == (objects at:1) ifTrue:[
                v geometryLayout:(l2 copy)
            ] ifFalse:[
                v geometryLayout:(l1 copy).
            ]
        ]    
    ] ifFalse:[    
        self warn:'exactly two elements must be selected'.
    ]



!

pasteExtent
    "paste the copied extent to all objects in the selection"

    |heightToPaste widthToPaste|

    CopiedExtent notNil ifTrue:[
        widthToPaste := CopiedExtent x.
        heightToPaste := CopiedExtent y.
    ] ifFalse:[
        CopiedLayout notNil ifTrue:[
            CopiedLayout leftFraction = CopiedLayout rightFraction ifTrue:[
                CopiedLayout topFraction = CopiedLayout bottomFraction ifTrue:[
                    widthToPaste := (CopiedLayout rightOffset - CopiedLayout leftOffset). 
                    heightToPaste := (CopiedLayout bottomOffset - CopiedLayout topOffset). 
                ]
            ]
        ].
    ].

    widthToPaste notNil ifTrue:[
        heightToPaste notNil ifTrue:[
            self transaction:#pasteExtent dimensionDo:[:v|
                self resize:v corner:(v computeOrigin + (widthToPaste@heightToPaste))
            ]    
        ]    
    ]    
!

pasteHeight
    "paste the copied extent's height to all objects in the selection"

    |heightToPaste|

    CopiedExtent notNil ifTrue:[
        heightToPaste := CopiedExtent y.
    ] ifFalse:[
        CopiedLayout notNil ifTrue:[
            CopiedLayout topFraction = CopiedLayout bottomFraction ifTrue:[
                heightToPaste := (CopiedLayout bottomOffset - CopiedLayout topOffset) 
            ]
        ].
    ].

    heightToPaste notNil ifTrue:[
        self transaction:#pasteHeight dimensionDo:[:v|
            self resize:v bottom:(v computeOrigin + heightToPaste)
        ].
    ].    
!

pasteLayout
    "paste the layout to all objects in the selection"

    CopiedLayout notNil ifTrue:[
        self transaction:#pasteLayout dimensionDo:[:v|
            v geometryLayout:(CopiedLayout copy)
        ]    
    ]    
!

pasteWidth
    "paste the copied extent's width to all objects in the selection"

    |widthToPaste|

    CopiedExtent notNil ifTrue:[
        widthToPaste := CopiedExtent x.
    ] ifFalse:[
        CopiedLayout notNil ifTrue:[
            CopiedLayout leftFraction = CopiedLayout rightFraction ifTrue:[
                widthToPaste := (CopiedLayout rightOffset - CopiedLayout leftOffset) 
            ]
        ].
    ].

    widthToPaste notNil ifTrue:[
        self transaction:#pasteWidth dimensionDo:[:v|
            self resize:v right:(v computeOrigin + widthToPaste)
        ]    
    ]    
!

setExtent:anExtent
    "change extent for all selected objects
    "
    self transaction:#extent dimensionDo:[:v|
	v geometryLayout:nil.
	v extent:anExtent.
    ].

    "Modified: 28.2.1997 / 12:49:00 / cg"
!

setLayout:aLayout
    "change layout for all selected objects
    "
    self transaction:#layout dimensionDo:[:v|
        v geometryLayout:(aLayout copy)
    ].    
!

setToDefaultExtent
    "change extent of all selected views to their default extent
    "
    self transaction:#defaultExtent dimensionDo:[:v|
	self resize:v corner:(v computeOrigin + (v preferredExtent)).
    ]    

!

setToDefaultHeight
    "change height of all selected views to their default height
    "
    self transaction:#defaultHeight dimensionDo:[:v|
	self resize:v bottom:(v computeOrigin + (v preferredExtent))
    ]    

!

setToDefaultWidth
    "change width of all selected views to their default width
    "
    self transaction:#defaultWidth dimensionDo:[:v|
	self resize:v right:(v computeOrigin + (v preferredExtent))
    ]    

!

transaction:aType dimensionDo:aOneArgBlock
    "change dimension within a transaction for the selected elements by evaluating
     the block with the argument a view.
    "
    self withSelectionHiddenDo:[
	self transaction:aType selectionDo:[:aView|
	    (self class layoutType:aView) notNil ifTrue:[
		self createUndoLayout:aView.
		aOneArgBlock value:aView.
		self elementChangedSize:aView.
	    ]
	]
    ].
    self layoutChanged

! !

!UIObjectView methodsFor:'user actions-move'!

moveDo:aOneArgBlock 
    "perform a move operation (with auto repeat)"

    |sensor tm|

    self moveableSelection isNil ifTrue:[
        ^ self
    ].
    sensor := self sensor.

    tm := ButtonController defaultInitialDelay.

    self withSelectionHiddenDo:[
        self transaction:#move selectionDo:[:aView|self createUndoLayout:aView].

        [
            self selectionDo:[:aView| aOneArgBlock value:aView ].

            sensor leftButtonPressed ifTrue:[
                self windowGroup processExposeEvents.
                Delay waitForSeconds:tm.
                self windowGroup processExposeEvents.
                tm := ButtonController defaultRepeatDelay.
                self layoutChanged.
            ].
            sensor leftButtonPressed.
        ] whileTrue.

        "/ handle any expose events (for subcomponents) before
        "/ redrawing the handles.
        Delay waitForSeconds:0.1.
        self windowGroup processExposeEvents
    ].
!

moveSelectionDown
    "move selection down
    "
    self moveSelectionDown:nPixelsForMoveSelection
!

moveSelectionDown:howMany
    "move selection down (pixelwise or aligned-grid wise)"

    |gridY n|

    gridAlign notNil ifTrue:[gridY := gridAlign y]
                    ifFalse:[gridY := 1].

    self moveDo:[:aView|
        aligning ifTrue:[
            n := ((aView computeCorner y) \\ gridY).

            n ~~ 0 ifTrue:[
                n := gridY - n + 1.
            ] ifFalse:[
                n := gridY
            ]
        ] ifFalse:[
            n := 1.
            self sensor shiftDown ifTrue:[
                n := 8.    
            ].
        ].
        n := n * howMany.
        self shiftLayout:aView vertical:n
    ]
!

moveSelectionLeft
    "move selection left
    "
    self moveSelectionLeft:nPixelsForMoveSelection
!

moveSelectionLeft:howMany
    "move selection to the left (pixelwise or aligned-grid wise)"

    |gridX n|

    gridAlign notNil ifTrue:[gridX := gridAlign x]
                    ifFalse:[gridX := 1].

    self moveDo:[:aView|
        aligning ifTrue:[
            n := ((aView computeOrigin x) \\ gridX).
            n == 0 ifTrue:[n := gridX].
        ] ifFalse:[
            n := 1.
            self sensor shiftDown ifTrue:[
                n := 8.    
            ].
        ].
        n := n * howMany.
        self shiftLayout:aView horizontal:n negated
    ]
!

moveSelectionRight
    "move the selection to the right"

    self moveSelectionRight:nPixelsForMoveSelection
!

moveSelectionRight:howMany
    "move selection to the right (pixelwise or aligned-grid wise)"

    |gridX n|

    gridAlign notNil ifTrue:[gridX := gridAlign x]
                    ifFalse:[gridX := 1].

    self moveDo:[:aView|
        aligning ifTrue:[
            n := ((aView computeCorner x) \\ gridX).
            n == 0 ifTrue:[n := gridX].
        ] ifFalse:[
            n := 1.
            self sensor shiftDown ifTrue:[
                n := 8.    
            ].
        ].
        n := n * howMany.
        self shiftLayout:aView horizontal:n
    ]
!

moveSelectionUp
    "move selection up
    "
    self moveSelectionUp:nPixelsForMoveSelection
!

moveSelectionUp:howMany
    "move selection up (pixelwise or aligned-grid wise)"

    |gridY n|

    gridAlign notNil ifTrue:[gridY := gridAlign y]
                    ifFalse:[gridY := 1].

    self moveDo:[:aView|
        aligning ifTrue:[
            n := ((aView computeOrigin y) \\ gridY).
            n == 0 ifTrue:[n := gridY].
            n := n negated.
        ] ifFalse:[
            n := -1.
            self sensor shiftDown ifTrue:[
                n := -8.    
            ].
        ].
        n := n * howMany.
        self shiftLayout:aView vertical:n
    ]
! !

!UIObjectView methodsFor:'user actions-position'!

alignResizeSelectionLeft
    "resize the selection on the left to align their left edge with the 
     of the first object in the selection; 
     in case of a single object selection, the objects left edge is aligned with the left of its superview"

    |lmost delta sel|

    (sel := self moveableSelection) notNil ifTrue:[
        self withSelectionHiddenDo:[
            self numberOfSelections > 1 ifTrue:[
                lmost := (sel first) computeOrigin x.

                self transaction:#alignResizeLeft selectionDo:[:v|
                    (delta := lmost - (v computeOrigin x)) ~~ 0 ifTrue:[
                        self shiftLayout:v left:delta right:0
                    ]
                ]
            ] ifFalse:[
                self extentToFrame:#Left do:[:aLayout|
                    aLayout leftFraction:0.0 offset:0.
                ]
            ]
        ].
        self layoutChanged
    ]
!

alignResizeSelectionRight
    "align selection to the right of the first object in the selection; 
     in case of one selection the object is aligned to the right of its superview"

    |rmost delta sel|

    (sel := self moveableSelection) notNil ifTrue:[
        self withSelectionHiddenDo:[
            self numberOfSelections > 1 ifTrue:[
                rmost := (sel first) computeCorner x.

                self transaction:#alignRight selectionDo:[:v|
                    (delta := rmost - (v computeCorner x)) ~~ 0 ifTrue:[
                        self shiftLayout:v left:0 right:delta
                    ]
                ]
            ] ifFalse:[
                self extentToFrame:#Right do:[:aLayout|
                    aLayout rightOffset:0.
                    aLayout rightFraction:1.0.
                ]
            ]
        ].
        self layoutChanged
    ]
!

alignSelectionBottom
    "align selection to the bottom of the first object in the selection; in case
     of one selection the object is aligned to the bottom of its superview
    "
    |bmost delta sel|

    (sel := self moveableSelection) notNil ifTrue:[
	self withSelectionHiddenDo:[
	    self numberOfSelections > 1 ifTrue:[
		bmost := (sel first) computeCorner y.

		self transaction:#alignBottom selectionDo:[:v|
		    (delta := bmost - (v computeCorner y)) ~~ 0 ifTrue:[
			self shiftLayout:v top:delta bottom:delta.
		    ]
		]
	    ] ifFalse:[
		self extentToFrame:#Bottom do:[:aLayout|
		    aLayout bottomOffset:0.
		    aLayout bottomFraction:1.0
		]
	    ]
	].
	self layoutChanged
    ]



!

alignSelectionCenterHor
    "align selection to the center/horizontal of the first object in the selection; in case
     of one selection the object is aligned to the center/horizontal of its superview
    "
    |view center sel|

    (sel := self moveableSelection) notNil ifTrue:[
	self withSelectionHiddenDo:[
	    view := self singleSelection.

	    view notNil ifTrue:[
                
		view   := self findContainerOfView:view.
		center := view computeExtent
	    ] ifFalse:[
		view   := sel first.
		center := view computeCorner + view computeOrigin.
	    ].
	    center := center x // 2.

	    self transaction:#alignCenterHorizontal selectionDo:[:v|
		|newX oldX delta|

		oldX  := v computeOrigin x.
		newX  := center - ((v computeCorner x - oldX) // 2).
		delta := newX - oldX.

		self shiftLayout:v left:delta right:delta
	    ]
	].
	self layoutChanged
    ]



!

alignSelectionCenterVer
    "align selection to the center/vertical of the first object in the selection; in case
     of one selection the object is aligned to the center/vertical of its superview
    "
    |view center sel|

    (sel := self moveableSelection) notNil ifTrue:[
	self withSelectionHiddenDo:[
	    view := self singleSelection.

	    view notNil ifTrue:[
		view   := self findContainerOfView:view.
		center := view computeExtent
	    ] ifFalse:[
		view   := sel first.
		center := view computeCorner + view computeOrigin.
	    ].
	    center := center y // 2.

	    self transaction:#alignCenterVertical selectionDo:[:v|
		|newY oldY delta|

		oldY  := v computeOrigin y.
		newY  := center - ((v computeCorner y - oldY) // 2).
		delta := newY - oldY.

		self shiftLayout:v top:delta bottom:delta
	    ]
	].
	self layoutChanged
    ]
!

alignSelectionLeft
    "align the selection with the left edge of the first object in the selection.
     in case of a single object selection, the object is moved to the left of its superview"

    |dominantLeft delta sel|

    (sel := self moveableSelection) notNil ifTrue:[
        self withSelectionHiddenDo:[
            dominantLeft := (sel first) computeOrigin x.
            self numberOfSelections > 1 ifTrue:[
                self transaction:#alignLeft selectionDo:[:v|
                    (delta := dominantLeft - (v computeOrigin x)) ~~ 0 ifTrue:[
                        self shiftLayout:v left:delta right:delta
                    ]
                ]
            ] ifFalse:[
                self transaction:#alignLeft selectionDo:[:v|
                    self shiftLayout:v left:dominantLeft negated right:dominantLeft negated
                ].
            ]
        ].
        self layoutChanged
    ]
!

alignSelectionLeftAndRight
    "align selection to the left/right of the first object in the selection; in case
     of one selection the object is aligned to the left/right of its superview
    "
    |lmost rmost sel|

    (sel := self resizableSelection) notNil ifTrue:[
        self withSelectionHiddenDo:[
            self numberOfSelections > 1 ifTrue:[
                lmost := (sel first) computeOrigin x.
                rmost := (sel first) computeCorner x.

                self transaction:#alignLeftRight selectionDo:[:aView|
                    |layout|

                    aView superView isLayoutWrapper ifTrue:[
                        "change size only"
                        self createUndoLayout:aView.
                        aView width:sel first width.
                        self elementChangedSize:aView
                    ] ifFalse:[
                        layout := self class asLayoutFrameFromView:aView.

                        layout notNil ifTrue:[
                            self createUndoLayout:aView.
                            aView geometryLayout:layout.

                            undoHistory withoutTransactionDo:[
                                self shiftLayout:aView left:(lmost - (aView computeOrigin x))
                                                      right:(rmost - (aView computeCorner x)).
                            ].
                            self elementChangedSize:aView
                        ].
                    ].
                ]
            ] ifFalse:[
                self extentToFrame:#LeftRight do:[:aLayout|
                    aLayout leftFraction:0.0 offset:0.
                    aLayout rightFraction:1.0 offset:0.
                ]
            ]
        ].
        self layoutChanged
    ].
!

alignSelectionRight
    "align selection to the right of the first object in the selection; in case
     of one selection the object is aligned to the right of its superview
    "
    |dominantRight delta sel|

    (sel := self moveableSelection) notNil ifTrue:[
        self withSelectionHiddenDo:[
            dominantRight := (sel first) computeCorner x.
            self numberOfSelections > 1 ifTrue:[
                self transaction:#alignRight selectionDo:[:v|
                    (delta := dominantRight - (v computeCorner x)) ~~ 0 ifTrue:[
                        self shiftLayout:v left:delta right:delta
                    ]
                ]
            ] ifFalse:[
                self transaction:#alignRight selectionDo:[:v|
                    delta := v superView width - dominantRight.
                    self shiftLayout:v left:delta right:delta
                ]
"/                self extentToFrame:#Right do:[:aLayout|
"/                    aLayout rightOffset:0.
"/                    aLayout rightFraction:1.0.
"/                ]
            ]
        ].
        self layoutChanged
    ]
!

alignSelectionTop
    "align selection to the top of the first object in the selection; in case
     of one selection the object is aligned to the top of its superview
    "
    |tmost delta sel|

    (sel := self moveableSelection) notNil ifTrue:[
	self withSelectionHiddenDo:[
	    self numberOfSelections > 1 ifTrue:[
		tmost := (sel first) computeOrigin y.

		self transaction:#alignTop selectionDo:[:v|
		    (delta := tmost - (v computeOrigin y)) ~~ 0 ifTrue:[
			self shiftLayout:v top:delta bottom:delta
		    ]
		]
	    ] ifFalse:[
		self extentToFrame:#Top do:[:aLayout|
		    aLayout topOffset:0.
		    aLayout topFraction:0.0.
		]
	    ]
	].
	self layoutChanged
    ]

!

alignSelectionTopAndBottom
    "align selection to the top/bottom of the first object in the selection; in case
     of one selection the object is aligned to the top/bottom of its superview
    "
    |tmost bmost sel|

    (sel := self resizableSelection) notNil ifTrue:[
        self withSelectionHiddenDo:[
            self numberOfSelections > 1 ifTrue:[
                tmost := (sel first) computeOrigin y.
                bmost := (sel first) computeCorner y.

                self transaction:#alignTopBottom selectionDo:[:aView|
                    |layout|
                    aView superView isLayoutWrapper ifTrue:[
                        "change size only"
                        self createUndoLayout:aView.
                        aView height:sel first height.
                        self elementChangedSize:aView
                    ] ifFalse:[
                        layout := self class asLayoutFrameFromView:aView.

                        layout notNil ifTrue:[
                            self createUndoLayout:aView.
                            aView geometryLayout:layout.

                            undoHistory withoutTransactionDo:[
                                self shiftLayout:aView top:(tmost - (aView computeOrigin y))
                                                    bottom:(bmost - (aView computeCorner y)).
                            ].
                            self elementChangedSize:aView
                        ].
                    ].
                ]
            ] ifFalse:[
                self extentToFrame:#TopBottom do:[:aLayout|
                    aLayout topOffset:0.
                    aLayout topFraction:0.0.
                    aLayout bottomOffset:0.
                    aLayout bottomFraction:1.0.
                ]
            ]
        ].
        self layoutChanged
    ]
!

centerSelection:aOneArgBlockXorY orientation:orientation
    "center selection horizontal or vertical dependant on the block result( x or y).
     The argument to the block is the point.
    "
    |superview min max delta val|

    (self moveableSelection) isNil ifTrue:[
	^ self
    ].

    self withSelectionHiddenDo:[
	max := 0.

	self selectionDo:[:aView |
	    superview isNil ifTrue:[
		superview := self findContainerOfView:aView
	    ] ifFalse:[
		(self findContainerOfView:aView) == superview ifFalse:[
		    ^ self notify:'views must have same superview'.
		]
	    ].
	    val := aOneArgBlockXorY value:(aView computeOrigin).    

	    min isNil ifTrue:[min := val]
		     ifFalse:[min := min min:val].

	    val := aOneArgBlockXorY value:(aView computeCorner).
	    max := max max:val.
	].

	val := aOneArgBlockXorY value:(superview computeExtent).
	max := (min + val - max) // 2.

	max == min ifFalse:[
	    |type|
	    (orientation == #y) ifTrue:[type := #centerVertical]
			       ifFalse:[type := #centerHorizontal].
	    delta := max - min.

	    self transaction:type selectionDo:[:v|
		orientation == #y ifTrue:[
		    self shiftLayout:v top:delta bottom:delta
		] ifFalse:[
		    self shiftLayout:v left:delta right:delta
		]
	    ]
	].
	self layoutChanged
    ]


!

centerSelectionHor
    "center selection horizontal
    "
    self centerSelection:[:aPoint| aPoint x] orientation:#x


!

centerSelectionVer
    "center selection vertical
    "
    self centerSelection:[:aPoint| aPoint y] orientation:#y
!

extentToFrame:toWhat do:aBlock
    "align to frame (Left Right ...) and perform the block on a frameLayout
    "
    |layout type|

    type := ('extent', toWhat asString) asSymbol.

    self transaction:type selectionDo:[:aView|
	layout := self class asLayoutFrameFromView:aView.

	layout notNil ifTrue:[
	    self createUndoLayout:aView.
	    aBlock value:layout.
	    aView geometryLayout:layout.
	    self elementChangedSize:aView.
	]
    ]
!

spreadSelectionHor
    "spread multiple selection horizontal
    "
    |sumWidths min max viewsInOrder topsInOrder count space sel|

    sel := self moveableSelection.

    (sel notNil and:[self numberOfSelections > 1]) ifFalse:[
	^ self
    ].

    self withSelectionHiddenDo:[
	count := 0.
	sumWidths := 0.
	max := 0.

	self selectionDo:[:aView |
	    sumWidths := sumWidths + aView width.

	    min isNil ifTrue:[min := aView left]
		     ifFalse:[min := min min:(aView left)].

	    max := max max:(aView right).
	    count := count + 1
	].
	viewsInOrder := Array withAll:sel.
	topsInOrder  := viewsInOrder collect:[:aView | aView left].
	topsInOrder sortWith:viewsInOrder.

	space := (((max - min) - sumWidths) / (count - 1)) rounded asInteger.

	self transaction:#spreadHorizontal objects:viewsInOrder do:[:aView|
	    |delta|

	    delta := min - aView computeOrigin x.
	    self shiftLayout:aView left:delta right:delta.
	    min := min + aView computeExtent x + space
	]
    ].
    self layoutChanged

!

spreadSelectionVer
    "spread multiple selection vertical
    "
    |sumHeights min max viewsInOrder topsInOrder count space sel|

    sel := self moveableSelection.

    (sel notNil and:[self numberOfSelections > 1]) ifFalse:[
	^ self
    ].

    self withSelectionHiddenDo:[
	count := 0.
	sumHeights := 0.
	max := 0.

	self selectionDo:[:aView |
	    sumHeights := sumHeights + aView height.

	    min isNil ifTrue:[min := aView top]
		     ifFalse:[min := min min:(aView top)].

	    max   := max max:(aView bottom).
	    count := count + 1
	].
	viewsInOrder := Array withAll:sel.
	topsInOrder  := viewsInOrder collect:[:aView|aView top].
	topsInOrder sortWith:viewsInOrder.

	space := (((max - min) - sumHeights) / (count - 1)) rounded asInteger.

	self transaction:#spreadVertical objects:viewsInOrder do:[:aView|
	    |delta|

	    delta := min - aView computeOrigin y.
	    self shiftLayout:aView top:delta bottom:delta.
	    min := min + aView height + space
	]
    ].
    self layoutChanged
! !

!UIObjectView methodsFor:'user actions-undo history'!

enableUndoHistory:aState
    "enable or disable undo history"

    undoHistory enabled:aState
!

openUndoMenu
    self select:nil.
    undoHistory openUndoMenu
!

removeUndoHistory
    "delete total undo history"

    undoHistory initializeFor:self.
    self undoHistoryChanged
!

undoLast
    "undo last action"

    |newSel oldSel|

    undoHistory notEmpty ifTrue:[
        self hasSelection ifTrue:[
            oldSel := OrderedCollection new.
            newSel := OrderedCollection new.

            self selectionDo:[:aView||p|
                (p := self propertyOfView:aView) notNil ifTrue:[
                    oldSel add:(p identifier)
                ]
            ].
            self setSelection:nil withRedraw:true.
        ].

        self withSelectionHiddenDo:[undoHistory undoLast:1].

        oldSel notNil ifTrue:[
            oldSel do:[:id||v|
                (v := self findViewWithId:id) notNil ifTrue:[newSel add:v]
            ].
            self select:newSel.
        ].
        self undoHistoryChanged.
    ].
! !

!UIObjectView::PostEventHandler methodsFor:'event handling'!

processEvent:anEvent
    |evView|

    anEvent isDamage ifTrue:[
        onView testMode ifFalse:[
            evView := anEvent view.

            (onView isSelected:evView) ifTrue:[
                onView showSelected:evView.
            ]
        ]
    ].
    ^ false
! !

!UIObjectView::PostEventHandler methodsFor:'instance creation'!

onView:aView
    onView := aView.
! !

!UIObjectView::ResizeData methodsFor:'accessing'!

checkForChangeSelector
    ^ checkForChangeSelector
!

delta
    ^ delta

    "Created: / 2.2.1998 / 13:40:32 / cg"
!

object
    ^ object

    "Created: / 2.2.1998 / 13:40:24 / cg"
!

object:anObject selector:selectorArg checkForChangeSelector:checkForChangeSelectorArg delta:anInteger
    object := anObject.
    selector := selectorArg.
    checkForChangeSelector := checkForChangeSelectorArg.
    delta := anInteger.

    "Created: / 2.2.1998 / 13:39:22 / cg"
!

object:anObject selector:aSymbol delta:anInteger
    object := anObject.
    selector := aSymbol.
    delta := anInteger.

    "Created: / 2.2.1998 / 13:39:22 / cg"
!

selector
    ^ selector

    "Created: / 2.2.1998 / 13:40:42 / cg"
! !

!UIObjectView::UndoHistory class methodsFor:'constants'!

maxHistorySize
    "returns maximum size of history before removing oldest
     record
    "
    ^ 100


! !

!UIObjectView::UndoHistory class methodsFor:'documentation'!

documentation
"
    undo history used by the UIPainter-Tool; to each operation, an undo block
    and some text is stored. In case of a required undo, the corresponding
    undo block will be performed.

    [see also:]
	UIObjectView
	UIPainterView

    [author:]
	Claus Atzkern
"


! !

!UIObjectView::UndoHistory class methodsFor:'instance creation'!

on:aPainter
    |history|

    history := self new.
    history initializeFor:aPainter.
    ^ history
! !

!UIObjectView::UndoHistory methodsFor:'accessing'!

addUndoSelector:aSelector withArgs:anArray
    "add a selector with arguments to the current opened transaction; in case that no
     transaction is opened or disabled the block will not be kept in the history."

    self isTransactionOpen ifTrue:[
        transaction add:(Association key:aSelector value:anArray)
    ]
! !

!UIObjectView::UndoHistory methodsFor:'accessing-behavior'!

enabled
    ^ enabled
!

enabled:aState
    enabled := aState
!

resetModification
    "set the modification state to false"

"/    startIdentifier := identifier

    identifier := startIdentifier := 0.
    history    := OrderedCollection new.
! !

!UIObjectView::UndoHistory methodsFor:'activation & deactivation'!

withinTransaction:aType text:aTextOrNil do:aBlock
    "open a transaction; perform the block; finally close the transaction"

    (enabled and:[transaction isNil]) ifTrue:[
        transaction := Transaction type:aType text:aTextOrNil.

        aBlock value.

        transaction notEmpty ifTrue:[
            identifier := identifier + 1.
            transaction identifier:identifier.
            history addLast:transaction.
            history size > (self class maxHistorySize) ifTrue:[history removeFirst].
        ].
        transaction := nil

    ] ifFalse:[
        aBlock value
    ]
!

withoutTransactionDo:aNoArgBlock
    "evaluate the block without opening a transaction or keeping changes
     within a still opened transaction"

    |oldState|

    oldState := enabled.
    enabled  := false.
    aNoArgBlock value.
    enabled  := oldState.
! !

!UIObjectView::UndoHistory methodsFor:'initialization'!

initializeFor:aPainter
    "setup for a painter and delete all existing history records"

    identifier      := 0.
    startIdentifier := 0.

    painter     := aPainter.
    history     := OrderedCollection new.
    transaction := nil.
    enabled     := true.
!

on:aPainter
    self breakPoint:#ca.
    self initializeFor:aPainter
! !

!UIObjectView::UndoHistory methodsFor:'menu'!

openUndoMenu
    |list tabs top slv hzp inset selection okButton|

    history isEmpty ifTrue:[
        ^ self
    ].

    top  := StandardSystemView new label:'undo history'; extent:250@350.
    slv  := ScrollableView for:SelectionInListView origin:0.0@0.0 corner:1.0@1.0 in:top.
    hzp  := HorizontalPanelView origin:0.0@1.0 corner:1.0@1.0 in:top.
    hzp horizontalLayout:#fitSpace.

    (Button abortButtonIn:hzp) action:[ selection := nil. top destroy ].
    okButton := Button okButtonIn:hzp.
    okButton label:'undo to end'.
    okButton action:[ top destroy ].

    inset := hzp preferredHeight.
    hzp topInset:(inset negated).
    slv   bottomInset:inset.
    slv := slv scrolledView.

    tabs := TabulatorSpecification new.
    tabs unit:#cm.
    tabs positions:#(0 5).
    tabs align:#(#left #left).

    list := history collect:[:aTrans||e|
        e := MultiColListEntry new.
        e colAt:1 put:(aTrans typeAsString).
        e colAt:2 put:(aTrans text ? '').
        e tabulatorSpecification:tabs.
        e
    ].

    slv list:list.
    slv action:[:index | selection := index ].
    top openModal.

    selection notNil ifTrue:[
        self undoLast:(history size - selection + 1).
    ]
! !

!UIObjectView::UndoHistory methodsFor:'testing'!

isEmpty
    "returns true if the undo history is empty"

    ^ history isEmpty
!

isModified
    "returns true if the history is modified"

    self isEmpty ifTrue:[
        ^ false
    ].
    ^ history last identifier ~~ startIdentifier
!

isTransactionOpen
    ^ (enabled and:[transaction notNil])
!

notEmpty
    "returns true if the undo history is not empty"

    ^ history notEmpty
! !

!UIObjectView::UndoHistory methodsFor:'undo'!

labelOfLastUndo
    "return astring describing the last undo-action (for the menu)"

    history size = 0 ifTrue:[^ '* nothing to undo *'].
    ^ history last "actions" type

    "Created: / 30.10.2001 / 13:45:28 / cg"
    "Modified: / 30.10.2001 / 13:46:33 / cg"
!

undoLast:nTransactions
    "undo the last n transactions; an open transaction will be closed;
     transactions during undo are disabled"

    |repeatTimes transaction actions|

    transaction := nil.
    enabled     := false.
    repeatTimes := nTransactions min:(history size).

    repeatTimes timesRepeat:[
        transaction := history removeLast.
        actions     := transaction actions.

        actions isCollection ifTrue:[
            actions reverseDo:[:aBlock|
                painter perform:(aBlock key) with:(aBlock value)
            ]
        ] ifFalse:[
            painter perform:(actions key) with:(actions value)
        ]
    ].
    enabled := true.
! !

!UIObjectView::UndoHistory::Transaction class methodsFor:'documentation'!

documentation
"
    represents one undo record, keeping the associated type and printable text
    and the undo action performed on an undo request

    [see also:]
	UndoHistory

    [author:]
	Claus Atzkern
"

! !

!UIObjectView::UndoHistory::Transaction class methodsFor:'instance creation'!

type:aType text:aTextOrNil
    ^ self new type:aType text:aTextOrNil


! !

!UIObjectView::UndoHistory::Transaction methodsFor:'accessing'!

actions
    "returns actions associated with transaction
    "
  ^ actions
!

identifier
    "gets my identifier
    "
  ^ identifier
!

identifier:anIdentifier
    "sets my identifier
    "
    identifier := anIdentifier
!

text
    "returns text or nil assigned to transaction
    "
    ^ text
!

type
    "returns type assigned to transaction
    "
    ^ type
!

type:aType
    "change type assigned to transaction
    "
    type := aType
!

typeAsString
    "returns type as printable string
    "
    |line name size sep|

    line := type asString.
    size := 0.
    line do:[:c| (c isUppercase) ifTrue:[size := size+1] ].
    name := String new:(line size + size).
    size := 1.
    sep  := Character space.

    line do:[:c|
	(c isUppercase) ifFalse:[
	    name at:size put:c
	] ifTrue:[
	    name at:size put:sep.
	    sep  := $&.
	    size := size + 1.
	    name at:size put:(c asLowercase)
	].
	size := size + 1
    ].
    ^ name
! !

!UIObjectView::UndoHistory::Transaction methodsFor:'adding'!

add:anUndoBlock
    "add an undo action to the current transaction
    "
    actions isNil ifTrue:[
	actions := anUndoBlock
    ] ifFalse:[
	actions isCollection ifFalse:[
	    actions := OrderedCollection with:actions
	].
	actions add:anUndoBlock.
    ]
! !

!UIObjectView::UndoHistory::Transaction methodsFor:'initialization'!

type:aType text:aTextOrNil
    "initialize transaction
    "
    type := aType.
    text := aTextOrNil.
! !

!UIObjectView::UndoHistory::Transaction methodsFor:'testing'!

isEmpty
    "returns true if no undo action is registered"

    ^ actions isNil
!

notEmpty
    "returns true if no undo action is registered"

    ^ actions notNil
! !

!UIObjectView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

