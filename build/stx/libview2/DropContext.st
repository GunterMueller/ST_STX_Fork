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

Object subclass:#DropContext
	instanceVariableNames:'dropObjects rootPoint dropSource sourceWidget dropTarget
		targetWidget targetId hasDropped dragHandler manager dropInfo
		dragType'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

Object subclass:#DragType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropContext
!

DropContext::DragType subclass:#DragTypeCopy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropContext
!

DropContext::DragType subclass:#DragTypeLink
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropContext
!

DropContext::DragType subclass:#DragTypeMove
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DropContext
!

!DropContext class methodsFor:'documentation'!

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
    instance, which keeps information about the current drag & drop operation.

    dropObjects         <Collection>    collection of dropObjects.
    rootPoint           <Point>         the current mouse position on the screen (root view).

    [see also:]
        DragAndDropManager
        DropObject
        DropSource
        DropTarget

    [author:]
        Claus Atzkern
"
! !

!DropContext class methodsFor:'constants'!

dragTypeCopy
    ^ DragTypeCopy
!

dragTypeDefault
    ^ DragTypeMove
!

dragTypeLink
    ^ DragTypeLink
!

dragTypeMove
    ^ DragTypeMove
! !

!DropContext methodsFor:'accessing'!

dragHandler
    ^ dragHandler

!

dragHandler:aHandler
    dragHandler := aHandler
!

dragType
    "the type of drag - modified by pressing one of Shift, Ctrl or Alt"

    ^ dragType ? DragTypeMove
!

dragType:aSymbol
    "the type of drag - modified by pressing one of Shift, Ctrl or Alt"

    dragType := aSymbol
!

dropInfo
    "a hook for additional info"

    dropInfo isNil ifTrue:[
        dropInfo := IdentityDictionary new
    ].
    ^ dropInfo
!

dropObjects
    "returns the collection of dropobjects"

    ^ dropObjects ? #()
!

manager:something
    manager := something.
!

rootPoint
    "returns the absolute point on the screen (rootPoint)"

    ^ rootPoint
! !

!DropContext methodsFor:'accessing-source'!

dropSource
    "returns the drop source or nil"

    ^ dropSource
!

sourceWidget
    "returns the source widget the drag is started from"

    ^ sourceWidget
! !

!DropContext methodsFor:'accessing-target'!

dropTarget
    "returns the drop target or nil"

    ^ dropTarget
!

targetId
    "returns the id of the target widget"

    ^ targetId
!

targetPoint
    "returns the relative point on the target widget (in DEVICE coordinates)"

    |trn org pnt dev|

    rootPoint isNil ifTrue:[^ nil].

    dev := sourceWidget device.
    pnt := dev translatePoint:rootPoint from:(dev rootWindowId) to:targetId.

    (pnt notNil and:[targetWidget notNil]) ifTrue:[
        (trn := targetWidget transformation) notNil ifTrue:[
            ^ trn applyInverseTo:pnt.
        ].
        "/ ca: do not translate here - drop is in device coordinates EVERYWHERE
        "/ (org := targetWidget viewOrigin) notNil ifTrue:[
        "/     ^ pnt + org.
        "/ ].
    ].
    ^ pnt
!

targetWidget
    "returns the widget assigned to the current dropTarget"

    ^ targetWidget
! !

!DropContext methodsFor:'actions'!

doDrop
    "evaluate the drop operation; set the feedBack"

    hasDropped := self canDrop.

    self isAlienView ifFalse:[
        hasDropped ifTrue:[
            dropTarget drop:self
        ] ifFalse:[
            "/
            "/ called to restore the widget in
            "/ case that something has changed
            "/
            dropTarget notNil ifTrue:[
                dropTarget leave:self
            ]
        ]
    ] ifTrue:[
        "/
        "/ not one of my views
        "/ external clipboard mechanism via display
        "/
        "/ ??  FEEDBACK  ??  hasDropped  ??
        "/
        sourceWidget device 
            drop:dropObjects
            inWindowID:targetId
            position:(self targetPoint)
            rootPosition:rootPoint.
    ].

    dropSource notNil ifTrue:[
        hasDropped ifTrue:[     "/ could have been cleared in drop-code
            dropSource dropFeedBackFrom:self
        ]
    ].
!

exchangeDragHandler:aHandler 
    "make the new handler to the active handler"
    
    (aHandler notNil and:[ aHandler ~~ dragHandler ]) ifTrue:[
        dragHandler postDragging.
        dragHandler := aHandler.
        manager dragHandler:dragHandler.
    ].
!

passiveAction:aBlock
    manager passiveAction:aBlock
!

saveDraw:aBlock
    "evaluate aBlock with the drag temporarily being undrawn 
     (i.e. restore original picture, evaluate the block, and draw dragged objects again).
     Return blocks value."

    ^  manager saveDraw:aBlock
! !

!DropContext methodsFor:'change & update'!

contentsWillChange
    "called by the dropTarget-widget if the contents will change during a
     dragAndDrop operation"

    dragHandler notNil ifTrue:[
        dragHandler dropTargetWillChange
    ]
! !

!DropContext methodsFor:'drag & drop manager interface'!

dropObjects:something
    "set the collection of dropobjects"

    something notNil ifTrue:[
        dropObjects := something isCollection ifTrue:[something]
                                             ifFalse:[Array with:something]
    ]
!

dropSource:aDropSource
    "set the dropSource"

    dropSource := aDropSource.
!

dropTarget:aDropTargetOrNil
    "set a new drop target"

    dropTarget := aDropTargetOrNil.
!

rootPoint:something
    "set the absolute point on the screen (rootPoint); 
     called by the drag and drop manager"

    rootPoint := something.
!

sourceWidget:aView
    "set the source widget the drag is started from"

    sourceWidget := aView.
!

targetWidget:aViewOrNil id:anId
    "set a new drop widget"

    targetWidget := aViewOrNil.
    targetId     := anId.
! !

!DropContext methodsFor:'queries'!

canDrop
    "returns true if the current dropTarget can drop the objects"

    ^ dropTarget notNil and:[dropTarget canDrop:self]

    "Modified: / 13-10-2006 / 15:48:02 / cg"
!

clearHasDroppedFlagToSuppressFeedBack
    "can be used from within a targets drop code,
     to signal that no feedBack should be send to the
     dropSource (because the drop did not happen)"

    hasDropped := false
!

hasDropped
    ^ hasDropped ? false
!

isAlienView
    "returns true if current dropTarget is not an ST/X view"

    ^ targetWidget isNil
!

isRootView
    "returns true if the current target widget is the root view (screen)"

    ^ targetWidget isNil 
        ifTrue:[false]
        ifFalse:[targetWidget isRootView]
! !

!DropContext::DragType class methodsFor:'testing'!

isDragTypeCopy
    ^ false
!

isDragTypeLink
    ^ false
!

isDragTypeMove
    ^ false
! !

!DropContext::DragTypeCopy class methodsFor:'testing'!

isDragTypeCopy
    ^ true
! !

!DropContext::DragTypeLink class methodsFor:'testing'!

isDragTypeLink
    ^ true
! !

!DropContext::DragTypeMove class methodsFor:'testing'!

isDragTypeMove
    ^ true
! !

!DropContext class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/DropContext.st,v 1.17 2009-05-01 17:36:53 cg Exp $'
! !
