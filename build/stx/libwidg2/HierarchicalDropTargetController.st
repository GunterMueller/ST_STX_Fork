"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HierarchicalDropTargetController
	instanceVariableNames:'expandBlock highlightMode receiver dropOverLine dropSelector
		canDropSelector canExpandSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

!HierarchicalDropTargetController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!HierarchicalDropTargetController class methodsFor:'instance creation'!

receiver:aReceiver argument:anArgument dropSelector:aDropSelector canDropSelector:aCanDropSelector

    ^ self 
        receiver:aReceiver 
        argument:anArgument 
        dropSelector:aDropSelector
        canDropSelector:aCanDropSelector 
        canExpandSelector:nil
!

receiver:aReceiver argument:anArgument dropSelector:aDropSelector canDropSelector:aCanDropSelector canExpandSelector: aCanExpandSelector
    |target|

    target := self new.

    ^ target
        receiver:aReceiver 
        argument:anArgument 
        dropSelector:aDropSelector 
        canDropSelector:aCanDropSelector 
        canExpandSelector:aCanExpandSelector
!

receiver:aReceiver dropSelector:aDropSelector canDropSelector:aCanDropSelector

    ^ self
        receiver:aReceiver 
        argument:nil 
        dropSelector:aDropSelector
        canDropSelector:aCanDropSelector
        canExpandSelector:nil
!

receiver:aReceiver dropSelector:aDropSelector canDropSelector:aCanDropSelector canExpandSelector:aCanExpandSelector

    ^ self
        receiver:aReceiver 
        argument:nil 
        dropSelector:aDropSelector
        canDropSelector:aCanDropSelector
        canExpandSelector:aCanExpandSelector
! !

!HierarchicalDropTargetController class methodsFor:'constants'!

delayMilliSecondsBeforeExpand
    ^ 1000
! !

!HierarchicalDropTargetController methodsFor:'drop actions'!

canDrop:aDropContext
    "return true, if the DropContext can be dropped into the list of items"

    dropOverLine isNil ifTrue:[ ^ false ].      "/ never setup by dropEnter:
    canDropSelector isNil ifTrue:[ ^ false ].

    ^ receiver 
        perform:canDropSelector 
        withOptionalArgument:aDropContext and:dropOverLine
!

drop:aDropContext
    "drop the dropContext into the hierachical list of items
    "
    |lnNr|

    (self canDrop:aDropContext) ifFalse:[
        self dropLeave:aDropContext.
        ^ false.
    ].
    lnNr := dropOverLine.
    lnNr isNil ifTrue:[^ false ].      "/ never setup by dropEnter:

    self dropLeave:aDropContext.

    dropSelector isNil ifTrue:[ ^ false ].

    ^ receiver 
        perform:dropSelector 
        withOptionalArgument:aDropContext and:lnNr
!

dropEnter:aDropContext
    "a drop operation enters my widget; set the highlightMode in the target widget"

    |widget|

    dropOverLine := 0.

    widget := aDropContext targetWidget.
    highlightMode := widget highlightMode.

    highlightMode notNil ifTrue:[
        aDropContext saveDraw:[
            widget highlightMode: #dropMode.
            widget windowGroup processExposeEvents.
        ].
    ].
!

dropLeave:aDropContext
    "restore drop indications drawn..."

    self changeDropLineTo:nil in:aDropContext.
!

dropOver:aDropContext
    |target lineNr|

    dropOverLine isNil ifTrue:[^ self ].       "/ never setup by dropEnter:

    target := aDropContext targetWidget.
    lineNr := target yVisibleToLineNr:(aDropContext targetPoint y).

    lineNr isNil ifTrue:[ lineNr := 0. ].

    lineNr > target size ifTrue:[
        lineNr := 0.
    ].
    self changeDropLineTo:lineNr in:aDropContext.
! !

!HierarchicalDropTargetController methodsFor:'instance creation'!

receiver:aReceiver argument:anArgument dropSelector:aDropSelector canDropSelector:aCanDropSelector canExpandSelector:aCanExpandSelector
    |target|

    receiver        := aReceiver.
    dropSelector    := aDropSelector.
    canDropSelector := aCanDropSelector.
    canExpandSelector := aCanExpandSelector.

    target := DropTarget
        receiver:self
        argument:anArgument
        dropSelector:#drop:
        canDropSelector:#canDrop:.

    target enterSelector:#dropEnter:.
    target leaveSelector:#dropLeave:.
    target overSelector:#dropOver:.

    ^ target
! !

!HierarchicalDropTargetController methodsFor:'private'!

changeDropLineTo:aLineOrNil in:aDropContext
    |x0 y0 y1 view item bgColor fgColor processEvents|

    aLineOrNil == dropOverLine ifTrue:[ ^ self ]. "/ nothing changed

    view := aDropContext targetWidget.

    expandBlock notNil ifTrue:[
        Processor removeTimedBlock:expandBlock.
        expandBlock := nil.
    ].
    processEvents := aLineOrNil isNil.
    aDropContext contentsWillChange.

    (aLineOrNil isNil and:[highlightMode notNil]) ifTrue:[
        "/ resore the selection mode
        view highlightMode: highlightMode.
        highlightMode := nil.
        processEvents := true.
    ].
    (dropOverLine notNil and:[dropOverLine ~~ 0]) ifTrue:[
        "/ invalidate old line
        view invalidateLineAt:dropOverLine.
        processEvents := true.
    ].
    processEvents ifTrue:[
        view windowGroup processExposeEvents.
    ].

    dropOverLine := aLineOrNil.

    (dropOverLine isNil or:[dropOverLine == 0]) ifTrue:[
        ^ self
    ].
    item := view at:dropOverLine ifAbsent:nil.
    item isNil ifTrue:[ ^ self ].

    y0 := view yVisibleOfLine:dropOverLine.
    y1 := view yVisibleOfLine:(dropOverLine + 1).
    x0 := view xVisibleOfTextAtLevel:item level.

    bgColor := view hilightBackgroundColor.
    fgColor := view hilightForegroundColor.

    view paint: bgColor.
    view fillRectangle:(Rectangle left:(x0 - 2) top:y0 width:(item widthOn:view) + 4 height:(y1 - y0)).

    view paint:fgColor on:bgColor.
    item displayOn:view x:x0 y:y0 h:(y1 - y0) isHighlightedAsSelected:false.

    view device isX11Platform ifTrue:[
        "work around X11 draw problems"
        Delay waitForMilliseconds:20.
    ].

    item isExpanded ifTrue:[ ^ self ].
    item canExpand ifFalse:[ ^ self ].

    canExpandSelector notNil ifTrue:[
        (receiver 
            perform:canExpandSelector 
            withOptionalArgument:aDropContext and:dropOverLine) 
        ifFalse:[
            ^ self
        ].
    ].
    expandBlock := [self expandForDrop:aDropContext at:aLineOrNil].
    Processor 
        addTimedBlock:expandBlock
        afterMilliseconds:(self class delayMilliSecondsBeforeExpand).
!

expandForDrop:aDropContext at:aLnNr
    |item view|

    expandBlock := nil.
    aLnNr == dropOverLine ifFalse:[ ^ self].

    view := aDropContext targetWidget.
    item := view at:aLnNr ifAbsent:nil.
    item isNil ifTrue:[^ self].

    aDropContext saveDraw:[
        item expand.
        view windowGroup processExposeEvents.
        view device isX11Platform ifTrue:[
            "work around X11 draw problems"
            Delay waitForMilliseconds:20.
        ].
    ].
! !

!HierarchicalDropTargetController class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

