"
 COPYRIGHT (c) 1994 by AEG Industry Automation
 COPYRIGHT (c) 1994 by Claus Gittinger
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

SelectionInListView subclass:#SelectionInHierarchyView
	instanceVariableNames:'itemList showConnectingLines itemClass indent itemPrintConverter'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Trees'
!

!SelectionInHierarchyView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by AEG Industry Automation
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    [warning:]
	this class has been more or less obsoleted by
	the SelectionInTreeView and HierarchicalListView classes.
	SelectionInHierarchyView remains in the system for backward
	compatibility, but will be no longer maintained.
	New applications should use SelectionInTreeView,
	or (even better) HierarchicalListView.

    somewhat like a SelectionInListView; but specialized for hierarchical (i.e. tree-like)
    lists and adds the functions to show/hide subtrees.
    Requires SelectionInHierarchy as model and HierarchyNode (or compatible) list entries.
    See examples.

    [Author:]
	W. Olberding AEG Factory Automation

    [See also:]
	SelectionInTreeView
	SelectionInHierarchy HierarchyNode
	SelectionInListView
"
!

examples
"
    shows the tree of smalltalk classes:
									[exBegin]
      |top hierarchy hierarchyV scroller|

      hierarchy := SelectionInHierarchy new.
      hierarchy root:(HierarchyNode newAsTreeFromSmalltalkClass:Object).
      hierarchy setHideToChildren:true startingAt:hierarchy root.

      top := StandardSystemView new.
      top extent:300@300.

      hierarchyV := SelectionInHierarchyView new.
      hierarchyV model: hierarchy.
      hierarchyV action:[:nr | Transcript show:'selected:'; showCR:nr].

      top add:(ScrollableView forView:hierarchyV)
	  in:((0.0 @ 0.0 ) corner:( 1.0 @ 1.0)).
      top open.
									[exEnd]

    same, with nice connecting links:
    (sorry - this works only with some fonts - see comment in #getListFromModel)
									[exBegin]
      |top hierarchy hierarchyV scroller|

      hierarchy := SelectionInHierarchy new.
      hierarchy root:(HierarchyNode newAsTreeFromSmalltalkClass:Object).
      hierarchy setHideToChildren:true startingAt:hierarchy root.

      top := StandardSystemView new.
      top extent:300@300.

      hierarchyV := SelectionInHierarchyView new.
      hierarchyV showConnectingLines:true.
      hierarchyV model: hierarchy.
      hierarchyV action:[:nr | Transcript show:'selected:'; showCR:nr].

      top add:(ScrollableView forView:hierarchyV)
	  in:((0.0 @ 0.0 ) corner:( 1.0 @ 1.0)).
      top open.
									[exEnd]
"
! !

!SelectionInHierarchyView methodsFor:'accessing - selection'!

selectElement:anObject
    "select the element with same printString as the argument, anObject"

    |index|

    index:= 1.
    list notNil ifTrue:[
	list do:[:each|
	  ((each withoutSpaces) = (anObject printString)) ifTrue:[
	      self selection:index.
	      ^ index
	  ].
	  index:= index + 1.
	].
    ].
    ^index

    "Modified: 10.10.1994 / 16:13:39 / W.Olberding"
    "Modified: 16.4.1997 / 12:40:05 / cg"
!

selection: anIndex
	"Pass the selection along to the model."

	super selection:  anIndex.
	model selection:  anIndex.

	"Modified: 10.10.94 / 16:13:38 / W.Olberding"
!

selectionIndex: anIndex
	"Pass the selection along to the model."

	super selection:  anIndex.
	model selection:  anIndex.

	"Modified: 10.10.94 / 16:13:38 / W.Olberding"
! !

!SelectionInHierarchyView methodsFor:'event handling'!

buttonPress:button x:x y:y
    |oldSelection listLineNr|

    ((button == 1) or:[button == #select]) ifTrue:[
	enabled ifTrue:[
	    oldSelection := selection.
	    listLineNr := self visibleLineToListLine:(self visibleLineOfY:y).
	    (selectConditionBlock isNil or:[selectConditionBlock value:listLineNr]) ifTrue:[
		listLineNr notNil ifTrue: [
		    self selectWithoutScroll:listLineNr
		].
		((ignoreReselect not and:[selection notNil])
		 or:[selection ~= oldSelection]) ifTrue:[
		    "actionBlock notNil ifTrue:[actionBlock value:selection]."
		    "the ST-80 way of doing things"
		    model notNil ifTrue:[
			model perform:#selectionIndex: with:(selection)
		    ]
		].
		clickLine := listLineNr
	    ]
	]
    ] ifFalse:[
	super buttonPress:button x:x y:y
    ]

	"Modified: 10.10.94 / 17:13:38 / W.Olberding"
	"Modified: 08.11.94 / 15:38:43 / R.Sailer"
!

keyPress:key x:x y:y
    "a key was pressed - handle [-][+][*] here"

    (key == $-)    ifTrue: [^ model collapse].
    (key == $+)    ifTrue: [^ model expand].
    (key == $*)    ifTrue: [^ model expandAll].
    (key == $.)    ifTrue: [^ model collapseAll].

    super keyPress:key x:x y:y

	"Modified: 10.10.94 / 16:13:38 / W.Olberding"
! !

!SelectionInHierarchyView methodsFor:'initialization'!

initialize

    super initialize.

    showConnectingLines := true.
    indent := 2.

    self  doubleClickAction:
	  [:selection | model doubleClickSelection: selection ].
	  "this will usualy initiate a hide/show operation"

    "Modified: 10.10.1994 / 16:13:39 / W.Olberding"
    "Modified: 16.4.1997 / 12:37:38 / cg"
!

itemPrintConverter:aBlock
    "set a converter block, which returns a listEntry
     for a passed node. If left undefined, an indented string
     based upon the nodes name is generated."

    itemPrintConverter := aBlock

    "Modified: 16.4.1997 / 13:06:22 / cg"
!

showConnectingLines:aBoolean
    showConnectingLines := aBoolean
! !

!SelectionInHierarchyView methodsFor:'model access'!

getListAttributes
      "get list attributes (selectable, disabled ...) from model)"

       ^Array new: 0.

	"Modified: 10.10.94 / 16:13:38 / W.Olberding"
!

getListFromModel
    "Get list entries from model.
     Answer them as idented Text."

    |listOfNodes itemList textLine treeLevels isLastOnLevel oldLevel
     blockGraphicCharacters|

    listOfNodes := model list.
    listOfNodes isNil ifTrue:[^ #()].

    itemPrintConverter notNil ifTrue:[
	"/ externally provided node-to-listentry converter
	"/ allows hierarchyNodes to be presented in any
	"/ programmer defined way ...

	itemList := listOfNodes collect:[:aNode |
	    itemPrintConverter value:aNode
	].
    ] ifFalse:[
	showConnectingLines ifFalse:[
	    itemList := listOfNodes collect: [ :aNode |
		textLine := ReadWriteStream on: String new.
		aNode level timesRepeat: [
		    textLine spaces:indent.
		].
		textLine nextPutAll: aNode name.
		aNode isExpandable ifTrue: [
		    textLine nextPutAll: ' ...'.
		].
		textLine contents.
	    ].
	] ifTrue:[
	    "/ claus:
	    "/ mhmh - the AEG code depends on those blockGraphic
	    "/        characters being in the font.
	    "/
	    "/ how can we find out what characters there are ?
	    "/ (X maps missing chars to a space).
	    "/ we should really rewrite this to use a private bitmap font ...

	    blockGraphicCharacters := Array with:$|
					    with:$+
					    with:$+
					    with:$-.

    "/        blockGraphicCharacters := Array with:(Character value:25)
    "/                                        with:(Character value:14)
    "/                                        with:(Character value:21)
    "/                                        with:(Character value:18).

	    isLastOnLevel:=Set new.
	    treeLevels:=Set new.
	    oldLevel:=0.

	    listOfNodes reverseDo: [ :aNode |
		(treeLevels includes:(aNode level)) ifFalse:[
		    isLastOnLevel add:aNode.
		    treeLevels add:(aNode level).
		].
		aNode level < oldLevel ifTrue:[
		    treeLevels remove:oldLevel.
		].
		oldLevel:=aNode level.
	    ].

	    treeLevels:=Set new.
	    oldLevel:=0.
	    itemList := listOfNodes collect: [ :aNode |
		textLine := ReadWriteStream on: String new.

		1 to:((aNode level)-1) do: [ :l |
		    (treeLevels includes:l) ifTrue:[
			textLine space; nextPut:(blockGraphicCharacters at:1); space.
		    ]ifFalse:[
			textLine space; space; space.
		    ]
		].
		treeLevels add:(aNode level).
		oldLevel:=aNode level.

		(aNode = (listOfNodes first)) ifFalse:[
		    textLine space.
		    (isLastOnLevel includes:aNode)ifTrue:[
			 textLine nextPut:(blockGraphicCharacters at:2).
			 treeLevels remove:(aNode level).
		    ] ifFalse:[
			textLine nextPut:(blockGraphicCharacters at:3).
		    ].
		    textLine nextPut:(blockGraphicCharacters at:4).
		].
		aNode isExpandable ifTrue: [
		    textLine nextPutAll: '[+]'.
		] ifFalse:[
		    aNode isCollapsable ifTrue: [
		       textLine nextPutAll: '[-]'.
		    ] ifFalse:[
			textLine nextPut:(blockGraphicCharacters at:4).
		    ].
		].

		textLine nextPutAll:' ', aNode name.
		textLine contents.
	    ].
	]
    ].

   ^itemList

    "Modified: 10.10.1994 / 16:13:39 / W.Olberding"
    "Modified: 16.4.1997 / 12:43:20 / cg"
!

getSelectionFromModel
      "Get the current list selection from model. "

    ^  model selectionIndex

	"Modified: 10.10.94 / 16:13:39 / W.Olberding"
!

model:aModel
    super model:aModel.
    self setNewList
! !

!SelectionInHierarchyView methodsFor:'private'!

setNewList
	"Build a completely new hierarchy list."


       self setList: (self getListFromModel).
"/       self attributes: (self getListAttributes).
       self selection: (self getSelectionFromModel).

	"Modified: 10.10.94 / 17:13:38 / W.Olberding"
	"Modified: 08.11.94 / 15:28:03 / R.Sailer"
! !

!SelectionInHierarchyView methodsFor:'updating'!

update: aSymbol with:aParameter from:changedObject
      "Change my appearance according to the occurred change."

     aSymbol == #list
        ifTrue: [^self setNewList].
     aSymbol == #selection
        ifTrue: [^self selection: self getSelectionFromModel].
     aSymbol == #attributes
        ifTrue: [].

        "Modified: 10.10.94 / 16:13:38 / W.Olberding"
! !

!SelectionInHierarchyView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

