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



"{ NameSpace: Tools }"

SelectionInListView subclass:#NewInspectorListView
	instanceVariableNames:'actionHolder inspectorList includesSelf'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-NewInspector'
!

!NewInspectorListView class methodsFor:'documentation'!

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
	open a list view on an instance
									[exBegin]
	|top slv a|

	a := OrderedCollection new.
	a add:1.

	top := StandardSystemView new
		label:'select';
		extent:200@200.

	slv := ScrollableView for:self in:top.
	slv origin:0.0@0.0 corner:1.0@1.0.
	slv := slv scrolledView.
	slv inspect:top.
	slv action:[:el|Transcript showCR:(el printString)].
	top open
									[exEnd]
"
! !

!NewInspectorListView methodsFor:'accessing'!

includesSelf:aBool
    includesSelf := aBool
!

list
    ^ inspectorList
!

list:aList
    "set the lists contents from another list
    "
    aList notNil ifTrue:[inspectorList := aList list]
		ifFalse:[inspectorList := NewInspectorList new].

    inspectorList includesSelf:includesSelf.
    super list:(inspectorList instanceNames).
!

update
    "update the current list
    "
    inspectorList update.
    super list:(inspectorList instanceNames).

! !

!NewInspectorListView methodsFor:'accessing actions'!

action:aOneArgAction
    "set the single click action block. If non-nil, that one is evaluated on single
     click, passing the selected instance as argument
    "
    actionHolder := aOneArgAction
! !

!NewInspectorListView methodsFor:'drawing'!

drawVisibleLineSelected:visLineNr with:fg and:bg
    "redraw a single line as selected.
    "
    |nr|

    (nr := self visibleLineToListLine:visLineNr) notNil ifTrue:[
	^ self drawVisibleLine:visLineNr with:fg and:bg.
    ].
    ^ super drawVisibleLine:visLineNr with:fg and:bg

!

redrawArrowVisibleLine:visLineNr
    "draw a right arrow for visible line
    "
    |nr|

    nr := self visibleLineToListLine:visLineNr.

    (inspectorList instanceTypeAt:nr) == #directory ifTrue:[
	self drawRightArrowInVisibleLine:visLineNr
    ]


!

redrawFromVisibleLine:startVisLineNr to:endVisLineNr
    "redefined to look for directory in every line
    "
    super redrawFromVisibleLine:startVisLineNr to:endVisLineNr.

    startVisLineNr to:endVisLineNr do:[:visLineNr|
	self redrawArrowVisibleLine:visLineNr
    ]
!

redrawVisibleLine:visLineNr
    "if the line is one for a directory, draw a right arrow
    "
    super redrawVisibleLine:visLineNr.
    self  redrawArrowVisibleLine:visLineNr.
!

visibleLineNeedsSpecialCare:visLineNr
    "returns true if the visible line needs special care
    "
    |nr|

    nr := self visibleLineToListLine:visLineNr.

    (inspectorList instanceTypeAt:nr) == #directory ifTrue:[
	^ true
    ].
    ^ super visibleLineNeedsSpecialCare:visLineNr

!

widthForScrollBetween:firstLine and:lastLine
    "return the width in pixels for a scroll between firstLine and lastLine
     - return full width here since there might be directory marks
    "
    ^ (width - margin - margin)


! !

!NewInspectorListView methodsFor:'event handling'!

sizeChanged:how
    "redraw marks
    "
    super sizeChanged:how.
    shown ifTrue:[self invalidate]

! !

!NewInspectorListView methodsFor:'initialization'!

initialize
    "initialization
    "
    super initialize.

    ignoreReselect := false.
    includesSelf   := false.
    actionHolder   := [:el|].
    inspectorList  := NewInspectorList new.

    actionBlock := [:dummy|
	self setSelection:selection.
	actionHolder value:(self selectedInstanceVar)
    ].
! !

!NewInspectorListView methodsFor:'private'!

doesNotUnderstand:aMessage
    "forward a message to the inspectorList
    "
    (inspectorList respondsTo:(aMessage selector)) ifTrue:[
	^ aMessage sendTo:inspectorList
    ].
    ^ super doesNotUnderstand:aMessage


!

list:aCollection keepSelection:aBoolean
    "set the list - redefined, since setting the list implies unselecting
     and clearing attributes."

    "somewhat of a kludge: if selection is first line,
     we have to remove the highlight frame by hand here"

    (shown and:[hilightLevel ~~ 0]) ifTrue:[
	selection == firstLineShown ifTrue:[
	   self paint:bgColor.
	   self fillRectangleX:margin y:margin
			  width:(width - (margin * 2))
			 height:(hilightLevel abs).
	].
    ].
    listAttributes := nil.
    super list:aCollection expandTabs:false.
    super setSelection:(inspectorList selection).




! !

!NewInspectorListView methodsFor:'selections'!

setSelection:aNumberOrNil
    "select line, aNumber or deselect if argument is nil
    "
    |oldSize|

    oldSize := inspectorList size.
    inspectorList setSelection:aNumberOrNil.
    oldSize == inspectorList size ifTrue:[super setSelection:(inspectorList selection)]
				 ifFalse:[super list:(inspectorList instanceNames)].
! !

!NewInspectorListView methodsFor:'user interaction'!

accept:aText notifying:aView
    "evaluating aText on the selected instance var; if an error occurs #Error
     is returned otherwise the inspected object instance. On success the list
     will be updated.
    "
    |res|

    res := inspectorList accept:aText notifying:aView.

    res ~~ #Error ifTrue:[
	super list:(inspectorList instanceNames)
    ].
    ^ res
!

doIt:aCode notifying:aView
    "evaluating aCode on the selected instance var; if an error occurs #Error
     is returned otherwise the result returned from the evaluator. On success
     the list will be updated.
    "
    |res|

    res := inspectorList doIt:aCode notifying:aView.

    res ~~ #Error ifTrue:[
	super list:(inspectorList instanceNames)
    ].
    ^ res

!

inspect:anObject
    "inspect a new instance; update contents
    "
    (inspectorList inspectedObject) == anObject ifTrue:[
	^ self update
    ].
    inspectorList := NewInspectorList for:anObject.
    inspectorList includesSelf:includesSelf.

    super list:(inspectorList instanceNames).
! !

!NewInspectorListView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
