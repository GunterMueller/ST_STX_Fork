"
 COPYRIGHT (c) 1999 by eXept Software AG
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

ListModelView subclass:#SelectionInListModelView
	instanceVariableNames:'selection multipleSelectOk actionBlock doubleClickActionBlock
		selectConditionBlock buttonMotionAction buttonReleaseAction
		highlightMode useIndex ignoreReselect toggleSelect hilightFgColor
		hilightBgColor hilightFgColorNoFocus hilightBgColorNoFocus
		hilightLevel hilightFrameColor hilightStyle dropSource editorView
		openEditorAction closeEditorAction highlightEnterItem enterItem
		cursorItem lineMask keyActionStyle returnKeyActionStyle strikeOut
		modelChangedDuringButtonPress selectOnButtonPress
		selectOnMenuButton minimumEditorHeight extraSpaceAtBottomForDrop'
	classVariableNames:'DefaultHilightStyle DefaultHilightBackgroundColor
		DefaultHilightForegroundColor DefaultHilightLevel
		DefaultHilightFrameColor DefaultHilightBackgroundColorNoFocus
		DefaultHilightForegroundColorNoFocus'
	poolDictionaries:''
	category:'Views-Lists'
!

!SelectionInListModelView class methodsFor:'documentation'!

claus
"
self claus
"
    |top list view|

    list := List new.

    1 to:100 do:[:i| list add:('element: ', i printString) ].

    top  := StandardSystemView extent:300@300.
    view := ScrollableView for:SelectionInListModelView miniScroller:true
                        origin:0.0@0.0 corner:1.0@1.0 in:top.

    view minimumEditorHeight:100.
    view openEditorAction:[:ln :aGC| |f|
        f := SimpleView in:aGC.
        f viewBackground:(Color red).
        f
    ].
    view list:list.
    top  open.
!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    SelectionInListModelView is mostly like SelectionInListView,
    but derives from the ListModelView and thus the list is kept
    in the list.

    [Instance variables:]

        selection               <misc>       the current selection. nil, a number or collection of numbers
        multipleSelectOk        <Boolean>    allow/disallow multiple selections( default:false )
        selectMenuButton        <Boolean>    enable/disable selection will change on menu pressed

        buttonReleaseAction     <Action>     called if the mouse button is released
        buttonMotionAction      <Action>     called during mouse motion with one argument the point
                                             under the mouse.

        actionBlock             <Block>      action evaluated on single click (0/1/2 arguments)
        doubleClickActionBlock  <Block>      action evaluated on double click (0/1/2 arguments)
        selectConditionBlock    <Block>      action evaluated before selection changed (0/1/2 arguments)

        keyActionStyle          <Symbol>     controls how to respond to keyboard selects
        returnKeyActionStyle    <Symbol>     controls how to respond to return key

        useIndex                <Boolean>    representation of the model selection

        ignoreReselect          <Boolean>    if set, a click on an already selected entry is ignored
        toggleSelect            <Boolean>    a click on an entry unselects it and vice versa

        highlightMode           <Symbol>     how to draw the selection
        hilightFgColor          <Color>      foregroundColor of highlighted items
        hilightBgColor          <Color>      backgroundColor of highlighted items
        hilightLevel            <Integer>    level to draw selections (i.e. for 3D effect)
        hilightFrameColor       <Color>      rectangle around highlighted items
        hilightStyle            <Boolean>    actions on widget are enabled/disabled
        strikeOut               <Boolean>    turn on/off strikeOut mode

        dropTarget              <DropTarget> keeps information about the drop operation
        dropSource              <DropSource> keeps information about the drag operation

        editorView              <View>       editor on current selected item
        openEditorAction        <Action>     action to get an editor on the current selection from user
        closeEditorAction       <Action>     action invoked before the editor is closed.

        enterItem               <Item/nil>   item over which the mouse pointer is located
                                             or nil
        highlightEnterItem      <Boolean>    enable or disable highlight of enterItem

    [author:]
        Claus Atzkern

    [see also:]

        ListModelView
        HierarchicalListView
"
!

examples
"
									[exBegin]
    |top list view|

    list := List new.

    1 to:100 do:[:i| list add:('element: ', i printString) ].
    top  := StandardSystemView new; extent:300@300.
    view := ScrollableView for:SelectionInListModelView miniScroller:true
			origin:0.0@0.0 corner:1.0@1.0 in:top.
    view list:list.
    top  open.
									[exEnd]


									[exBegin]
    |top list view|

    list := List new.

    1 to:100 do:[:i| list add:('element: ', i printString) ].
    top  := StandardSystemView new; extent:300@300.
    view := ScrollableView for:SelectionInListModelView miniScroller:true
			origin:0.0@0.0 corner:1.0@1.0 in:top.
    view list:list.

    view openEditorAction:[:ln :aGC| |field|
	field := EditField new.
	field level:0.
	field acceptOnLostFocus:true.
	field acceptAction:[:x| list at:ln put:(field contents) ].
	field font:(aGC font).
	field contents:(list at:ln).
	field
    ].
    top open.
									[exEnd]

									[exBegin]
    |top list view item|

    list := HierarchicalList new.
    item := HierarchicalItem::Example labeled:'Test'.
    item expand.
    list showRoot:false.
    list root:item.

    top  := StandardSystemView new; extent:300@300.
    view := ScrollableView for:SelectionInListModelView miniScroller:true
			origin:0.0@0.0 corner:1.0@1.0 in:top.

    view list:list.
    view doubleClickAction:[:i| (list at:i) toggleExpand ].
    top  open.
									[exEnd]

"
! !

!SelectionInListModelView class methodsFor:'defaults'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style   (
                        #'selection.hilightForegroundColor' #'selection.hilightBackgroundColor'
                        #'selection.hilightForegroundColorNoFocus' #'selection.hilightBackgroundColorNoFocus'
                        #'selection.hilightFrameColor'      #'selection.hilightLevel'
                        #'selection.foregroundColor'        #'selection.backgroundColor'
                        #'selection.shadowColor'            #'selection.lightColor'
                        #'selection.font'                   #'selection.hilightStyle'
                        #'text.foregroundColor'
                        )>

    DefaultHilightForegroundColor  := StyleSheet colorAt:'selection.hilightForegroundColor'.
    DefaultHilightBackgroundColor  := StyleSheet colorAt:'selection.hilightBackgroundColor'.
    DefaultHilightForegroundColorNoFocus  := StyleSheet colorAt:'selection.hilightForegroundColorNoFocus'.
    DefaultHilightBackgroundColorNoFocus  := StyleSheet colorAt:'selection.hilightBackgroundColorNoFocus'.
    DefaultHilightFrameColor       := StyleSheet colorAt:'selection.hilightFrameColor'.
    DefaultHilightLevel            := StyleSheet at:'selection.hilightLevel' default:0.
    DefaultHilightStyle            := StyleSheet at:'selection.hilightStyle' default:(StyleSheet name).
    DefaultForegroundColor         := StyleSheet colorAt:'selection.foregroundColor'.
    DefaultBackgroundColor         := StyleSheet colorAt:'selection.backgroundColor'.
    DefaultShadowColor             := StyleSheet colorAt:'selection.shadowColor'.
    DefaultLightColor              := StyleSheet colorAt:'selection.lightColor'.

    DefaultForegroundColor isNil ifTrue:[
        DefaultForegroundColor := StyleSheet colorAt:'text.foregroundColor' default:Color black
    ].

    DefaultFont := SelectionInListView defaultFont. 

    "
     self updateStyleCache
    "

    "Modified: / 14-08-2010 / 11:55:20 / cg"
! !

!SelectionInListModelView methodsFor:'accessing'!

cursorLine
    "returns the index of the cursor line or 0
    "
    |index|

    cursorItem isNil ifTrue:[^ 0 ].

    index := self identityIndexOf:cursorItem.
    index == 0 ifTrue:[ cursorItem := nil ].
    ^ index
!

list:aList
    self deselectWithoutRedraw.
    ^ super list:aList
! !

!SelectionInListModelView methodsFor:'accessing-actions'!

action
    "get the action block to be performed on select

     The arguments to the block are:
	- no argument
	-  1 argument     index or item
	-  2 argument     index or item, self
    "
    ^ actionBlock
!

action:anUpToTwoArgBlock
    "set the action block to be performed on select

     The arguments to the block are:
        - no argument
        -  1 argument     index or item
        -  2 argument     index or item, self
    "
    actionBlock := anUpToTwoArgBlock
!

doubleClickAction
    "get the action block to be performed on doubleclick.

     The arguments to the block are:
	- no argument
	-  1 argument     selectedIndex
	-  2 argument     selectedIndex, self
    "
    ^ doubleClickActionBlock
!

doubleClickAction:anUpToTwoArgBlock
    "set the action block to be performed on doubleclick.

     The arguments to the block are:
        - no argument
        -  1 argument     selectedIndex
        -  2 argument     selectedIndex, self
    "
    doubleClickActionBlock := anUpToTwoArgBlock
!

keyActionStyle
    "defines how the view should respond to alpha-keys pressed.
     Possible values are:
	#select               -> will select next entry starting with that
				 character and perform the click-action

	#selectAndDoubleclick -> will select next & perform double-click action

	#pass                 -> will pass key to superclass (i.e. no special treatment)

	nil                   -> will ignore key

     the default (set in #initialize) is #select
    "
    ^ keyActionStyle
!

keyActionStyle:aSymbol
    "defines how the view should respond to alpha-keys pressed.
     Possible values are:
	#select               -> will select next entry starting with that
				 character and perform the click-action

	#selectAndDoubleclick -> will select next & perform double-click action

	#pass                 -> will pass key to superclass (i.e. no special treatment)

	nil                   -> will ignore key

     the default (set in #initialize) is #select
    "
    keyActionStyle := aSymbol
!

returnKeyActionStyle
    "defines how the view should respond to a return key pressed.
     Possible values are:
	#doubleClick          -> perform double-click action

	#pass                 -> will pass key to superclass (i.e. no special treatment)

	nil                   -> will ignore key

     the default (set in #initialize) is #doubleClick
    "
    ^ returnKeyActionStyle
!

returnKeyActionStyle:aSymbol
    "defines how the view should respond to a return key pressed.
     Possible values are:
	#doubleClick          -> perform double-click action

	#pass                 -> will pass key to superclass (i.e. no special treatment)

	nil                   -> will ignore key

     the default (set in #initialize) is #doubleClick
    "
    returnKeyActionStyle := aSymbol
!

selectConditionBlock
    "set the conditionBlock; this block is evaluated before a selection
     change is performed; the change will not be done, if the evaluation
     returns false

     The arguments to the block are:
	- no argument
	-  1 argument     index
	-  2 argument     index, isForAdd
    "
    ^ selectConditionBlock
!

selectConditionBlock:anUpToTwoArgBlock
    "set the conditionBlock; this block is evaluated before a selection
     change is performed; the change will not be done, if the evaluation
     returns false.

     The arguments to the block are:
        - no argument
        -  1 argument     index
        -  2 argument     index, isForAdd
    "
    selectConditionBlock := anUpToTwoArgBlock.
! !

!SelectionInListModelView methodsFor:'accessing-attributes'!

highlightEnterItem
    "enable or disable to highlight the item over which the mouse pointer is located
    "
    ^ highlightEnterItem
!

highlightEnterItem:aBool
    "enable or disable to highlight the item over which the mouse pointer is located
    "
    highlightEnterItem ~~ aBool ifTrue:[
	highlightEnterItem := aBool.
	self pointerEntersItem:nil.

	highlightEnterItem ifTrue:[
	    self enableMotionEvents
	].
    ].
!

highlightMode
    "get the mode how to draw a selected line:
	#line           draw whole line selected
	#label          draw label selected
	#dropMode       set during drop
    "
    ^ highlightMode
!

highlightMode:aMode
    "set the mode how to draw a selected line:
	#line           draw whole line selected
	#label          draw label selected
	#dropMode       set during drop
    "
    highlightMode ~~ aMode ifTrue:[
	highlightMode := aMode.
	self invalidateSelection.
    ].
!

highlightWithUnderline
    ^ false
!

hilightBackgroundColor
    "returns the color used for the hilighted background
    "
    ^ hilightBgColor
!

hilightForegroundColor
    "returns the color used for the hilighted foreground
    "
    ^ hilightFgColor
!

strikeout
    "turn on/off strikeOut mode
    "
    ^ strikeOut
!

strikeout:aBoolean
    "turn on/off strikeOut mode
    "
    strikeOut ~~ aBoolean ifTrue:[
	strikeOut := aBoolean.
	self invalidateSelection.
    ].
! !

!SelectionInListModelView methodsFor:'accessing-behavior'!

ignoreReselect
    "get the ignoreReselect flag - see method #ignoreReselect: for more details
    "
    ^ ignoreReselect
!

ignoreReselect:aBoolean
    "set/clear the ignoreReselect flag -
     if set, a click on an already selected entry is ignored.
     Otherwise the notification is done, even if no
     change in the selection occurs.
     (for example, in browser to update a method).
     Setting ignoreReselect to false makes sense if data is shown
     which may change by itself (i.e. without the user doing anything)
     For example, the inspector uses this, and redisplays the value,
     if the selection is the same.
     The default is true, meaning that a click on an already selected
     does not lead to a notification via the actionBlock/change mechanism.
    "
    ignoreReselect := aBoolean

!

multipleSelectOk
    "return true if multiple selections are allowed; the default is false"

    ^ multipleSelectOk
!

multipleSelectOk:aBoolean
    "allow/disallow multiple selections. If enabled, the
     user may select multiple entries in the list, and the program
     always gets a collection of selected items (indexes if useIndex is true,
     values otherwise). The default is false, for single selections."

    |state|

    state := aBoolean ? false.

    multipleSelectOk == state ifTrue:[ ^ self ].

    selection isNil ifTrue:[
        multipleSelectOk := state.
        ^ self.
    ].

    multipleSelectOk ifFalse:[
        selection := Array with:selection.
        multipleSelectOk := true.
        ^ self
    ].

    selection size == 1 ifTrue:[
        selection := selection first.
    ] ifFalse:[
        self selection:nil
    ].
    multipleSelectOk := false.
!

selectOnButtonMenu
    <resource: #obsolete>
    self obsoleteMethodWarning:'use selectOnMenuButton'.
    ^ self selectOnMenuButton
!

selectOnButtonMenu:aBoolean
    <resource: #obsolete>
    self obsoleteMethodWarning:'use selectOnMenuButton:'.
    self selectOnMenuButton:aBoolean.
!

selectOnButtonPress
    "get the selectOnButtonPress flag - see method #selectOnButtonPress: for more details
    "
    ^ selectOnButtonPress ? true
!

selectOnButtonPress:aBoolean
    "set/clear the selectOnButtonPress flag -
     if set (default), the selection changed on button press. This was the
     behaviour until now.
     if cleared, the selection is changed on button release. This new behaviour allows to start
     a drag without changing the real selection. The selection is changed during the
     drag and restored after the drop.
    "
    selectOnButtonPress := aBoolean
!

selectOnMenuButton
    "define the button-menu-press behavior; if true the line under the mouse
     will be selected before the menu is opened. Otherwise the menu is opened
     on the current selection."

    selectOnMenuButton isNil ifTrue:[
	^ UserPreferences current selectOnRightClick
    ].
    ^ selectOnMenuButton
!

selectOnMenuButton:aBoolean
    "define the button-menu-press behavior; if true the line under the mouse
     will be selected before the menu is opened. Otherwise the menu is opened
     on the current selection."

    selectOnMenuButton := aBoolean.
!

toggleSelect
    "get the toggleSelect flag - see method #toggleSelect: for more details
    "
    ^ toggleSelect
!

toggleSelect:aBoolean
    "turn on/off toggle select. If true, clicking on a selected entry
     unselects it and vice versa. The default is false, which means
     that clicking on an already selected entry does not change its
     select status (see also ignoreReselect:).
    "
    toggleSelect := aBoolean.


!

useIndex
    "set/clear the useIndex flag.
     the selection writen to the model are the indices into the list
     or the elements selected.
    "
    ^ useIndex


!

useIndex:aBoolean
    "set/clear the useIndex flag.
     the selection writen to the model are the indices into the list
     or the elements selected.
    "
    useIndex := aBoolean ? true


! !

!SelectionInListModelView methodsFor:'accessing-editor'!

closeEditor
    "close the current editor
    "
    |editor action|

    (editor := editorView) notNil ifTrue:[
"/        editorView := nil.
	action := self closeEditorAction.
	action notNil ifTrue:[action value:editor.].
	editor destroy.
	editorView := nil.
    ].
!

closeEditorAction
    "get the block which is evaluated before the editor is closed; the argument
     to the action is the editor.
    "
    ^ closeEditorAction
!

closeEditorAction:anOneArgAction
    "get the block which is evaluated before the editor is closed; the argument
     to the action is the editor.
    "
    closeEditorAction := anOneArgAction.
!

hasOpenEditor

    ^ editorView notNil
!

minimumEditorHeight
    "answer the minumium height of the editor or nil.
     If the height is nil the height of the line is used"

    ^ minimumEditorHeight
!

minimumEditorHeight:aHeightOrNil
    "set the minumium height of the editor or nil.
     If the height is nil the height of the line is used"

    minimumEditorHeight := aHeightOrNil.
!

openEditor
    "opens the editor on the current selection;
     returns the editorView or nil if no openEditorAction is defined
     or no single selection exists ...
    "
    |lnNr action|

    self closeEditor.
    shown ifFalse:[^ nil].

    action := self openEditorAction.
    action isNil ifTrue:[^ nil].

    lnNr := self selectedIndex.
    lnNr == 0 ifTrue:[^ nil].

    self makeSelectionVisible.

    editorView := action valueWithOptionalArgument:lnNr and:self.
    editorView isNil ifTrue:[^ nil].

    editorView superView isNil ifTrue:[
	self addSubView:editorView
    ].
    self computeEditorLayout.
    editorView realize.
    self windowGroup focusView:editorView.
    ^ editorView
!

openEditorAction
    "get the block which is evaluated to get the editor which is set for the
     line; the arguments to the block is the line number and the widget itself
    "
    ^ openEditorAction

!

openEditorAction:aTwoArgAction
    "set the block which is evaluated to get the editor which is set for the
     line; the arguments to the block is the line number and the widget itself
    "
    openEditorAction := aTwoArgAction.
! !

!SelectionInListModelView methodsFor:'change & update'!

argForChangeMessage
    "return the argument for a selectionChange;
     depending on the setting of useIndex, this is either the numeric
     index of the selection or the value (i.e. the string)
    "
    useIndex         ifFalse:[ ^ self selectionValue ].
    multipleSelectOk ifFalse:[ ^ selection ? 0 ].
    ^ selection ? #()
!

contentsChanged
    "this one is sent, whenever contents changes its size"

    super contentsChanged.
    self computeEditorLayout.
!

lineChangedAt:aLnNr with:arg
    super lineChangedAt:aLnNr with:arg.

    (editorView notNil and:[aLnNr == self selectedIndex]) ifTrue:[
	self computeEditorLayout.
    ]
!

listSizeChanged:aLnNr nLines:aDeltaLines
    |changed cnts|

    super listSizeChanged:aLnNr nLines:aDeltaLines.

    selection isNil ifTrue:[^ self].

    self size == 0 ifTrue:[
	selection := nil.
	^ self selectionChanged
    ].

    multipleSelectOk ifFalse:[
	selection < aLnNr ifTrue:[^ self].

	selection := selection + aDeltaLines.

	(aDeltaLines < 0 and:[selection < aLnNr]) ifTrue:[
	    selection := nil.
	    ^ self selectionChanged
	]
    ] ifTrue:[
	changed := false.

	aDeltaLines < 0  ifFalse:[
	    selection keysAndValuesDo:[:i :ln|
		ln >= aLnNr ifTrue:[
		    changed := true.
		    selection at:i put:(ln + aDeltaLines)
		]
	    ]
	] ifTrue:[
	    cnts := 0.

	    selection keysAndValuesDo:[:i :ln||new|
		ln >= aLnNr ifTrue:[
		    changed := true.

		    (new := ln + aDeltaLines) < aLnNr ifTrue:[
			cnts := cnts + 1.
			new  := nil
		    ].
		    selection at:i put:new
		]
	    ].
	    cnts ~~ 0 ifTrue:[
		cnts == selection size ifTrue:[
		    selection := nil
		] ifFalse:[
		    selection := selection select:[:ln| ln notNil]
		].
		^ self selectionChanged.
	    ].
	].
	changed ifFalse:[^ self].
    ].

    (useIndex and:[model notNil]) ifTrue:[
	model setValue:(self argForChangeMessage)
    ].
!

originChanged:delta
    "setup the origin of the editing view
    "
    self computeEditorLayout.
    super originChanged:delta.


!

selectionChanged
    "selection has changed. Call actionblock and/or send changeMessage if defined
    "
    |arg|

    self closeEditor.

    (model isNil and:[actionBlock isNil]) ifTrue:[
	^ self
    ].

    arg := self argForChangeMessage.

    model notNil ifTrue:[
	model removeDependent:self.
	"/ change models value to force a change notification: reselect mode
	arg = model value ifTrue:[
	    model setValue:(arg isNil ifTrue:[0] ifFalse:[nil]).
	].
	self sendChangeMessage:#value: with:arg.
	model notNil ifTrue:[  "/ argggh could be nilled
	    model addDependent:self.
	    self updateFromModel. "/ care for possibly lost change notification, due to #removeDependent
	]
    ].

    actionBlock notNil ifTrue:[
	actionBlock valueWithOptionalArgument:arg and:self
    ].
!

updateFromModel
    "update selection from the model
    "
    |value newSelection|

    model isNil ifTrue:[
        ^ self
    ].

    buttonMotionAction notNil ifTrue:[
        "running in button motion; discard change notification
        "
        ^ self
    ].

    value := model value.

    (useIndex or:[value isNil or:[value isNumber]]) ifFalse:[
        multipleSelectOk ifFalse:[
            newSelection := self identityIndexOf:value
        ] ifTrue:[
            value size == 0 ifTrue:[
                newSelection := nil
            ] ifFalse:[
                newSelection := OrderedCollection new.

                value do:[:e||index|
                    index := self identityIndexOf:e.
                    index ~~ 0 ifTrue:[ newSelection add:index ].
                ].
                newSelection := newSelection asNilIfEmpty.
            ]
        ].
    ] ifTrue:[
        newSelection := value copy
    ].
    self setSelection:newSelection.
! !

!SelectionInListModelView methodsFor:'drag & drop'!

canDrag
    "returns true if dragging is enabled"

    ^ dropSource notNil

    "Modified: / 18-07-2010 / 09:07:20 / cg"
!

dragAutoScroll:aContext
    "called by the DragAndDropManager to scroll during a drag/drop operation
     if necassery (decided by the widget itself); If a scroll is done return
     true otherwise false (used to restore the background)"

    |scrollUp targetY deltaY pixels|

    targetY  := aContext targetPoint y.
    scrollUp := (targetY < (height // 2)).

    scrollUp ifTrue:[
        self yOriginOfContents = 0 ifTrue:[ ^ false].
        deltaY := targetY.
    ] ifFalse:[
        deltaY := height - targetY.
        self yOriginOfContents < self maxViewOriginY ifFalse:[ ^ false ].
    ].
    pixels := 24 min:(height // 4).
    deltaY > pixels ifTrue:[^ false].

    deltaY <= (pixels // 2) ifTrue:[
        deltaY <= (pixels // 4)
            ifTrue:[ pixels := pixels * 3]
            ifFalse:[ pixels := pixels * 2 ].            
    ].
    aContext contentsWillChange.

    scrollUp 
        ifTrue:[ self scrollUp:pixels ]
        ifFalse:[ self scrollDown:pixels ].

    ^ true

    "Modified: / 18-07-2010 / 09:08:29 / cg"
!

dropSource
    "returns the dropSource or nil"

    ^ dropSource
!

dropSource:aDropSourceOrNil
    "set the dropSource or nil"

    dropSource := aDropSourceOrNil.
!

startDragAt:aPoint
    "start drag at a point"

    buttonMotionAction := buttonReleaseAction := nil.

    dropSource notNil ifTrue:[
        dropSource startDragSelector notNil ifTrue:[
            ^ dropSource startDragIn:self at:aPoint
        ] ifFalse:[
            ^ DragAndDropManager new
                startDragFrom:self dropSource:dropSource offset:#center
        ]
    ].
    ^ nil

    "Modified: / 18-07-2010 / 09:07:26 / cg"
! !

!SelectionInListModelView methodsFor:'drawing'!

drawElementsFrom:start to:stop x:x y:y w:w
    "draw the items between start to stop without clearing the background
    "
    |y0 "{ Class:SmallInteger }"
     y1 "{ Class:SmallInteger }"
     x0 "{ Class:SmallInteger }"
    |
    x0 := textStartLeft - viewOrigin x.
    y1 := y.

    start to:stop do:[:i|
	y0 := y1.
	y1 := self yVisibleOfLine:(i + 1).
	self drawLabelAt:i x:x0 y:y0 h:(y1 - y0)
    ].


!

drawFrom:start to:stop x:x y:y w:w
    "draw the lines between start to stop without clearing the background
    "
    highlightMode notNil ifTrue:[
	self selectionDo:[:lnNr|
	    (lnNr between:start and:stop) ifTrue:[
		self drawSelectionFrameAt:lnNr x:x w:w
	    ]
	]
    ].
    super drawFrom:start to:stop x:x y:y w:w.
!

drawLabelAt:anIndex x:xI y:y h:h
    "draw the label at position x/y without clearing the background
    "
    |item y0 x1 x w drawStrikeOut xOut0 xOut1 isHighlightedAsSelected|

    x := xI + 1.
    editorView notNil ifTrue:[
        "/ there is an open editor for the line; thus no redraw for the label (hidden by editor)
        self selectedIndex == anIndex ifTrue:[^ self].
    ].

    item := self at:anIndex ifAbsent:nil.
    item isNil ifTrue:[^ self].

    drawStrikeOut := false.
    isHighlightedAsSelected := false.

    (highlightMode notNil and:[self isInSelection:anIndex]) ifTrue:[
        strikeOut ifTrue:[
            drawStrikeOut := true.
            gc paint:fgColor on:bgColor
        ] ifFalse:[
            (highlightMode == #dropMode or:[self hasFocus not]) ifTrue:[
                gc paint:hilightFgColorNoFocus on:hilightBgColorNoFocus.
            ] ifFalse:[
                gc paint:hilightFgColor on:hilightBgColor
            ].
            isHighlightedAsSelected := true.
        ]
    ] ifFalse:[
        enterItem == item ifTrue:[
            gc paint:hilightBgColor on:bgColor.
        ] ifFalse:[
            gc paint:fgColor on:bgColor.
        ].
    ].
    listRenderer display:item atX:x y:y lineHeight:h isHighlightedAsSelected:isHighlightedAsSelected.

    drawStrikeOut ifTrue:[
        xOut0 := self xVisibleOfItem:item.
        highlightMode == #label ifTrue:[
            xOut1 := xOut0 + (listRenderer widthFor:item).
        ] ifFalse:[
            xOut1 := width - margin.
        ].
        y0 := y + (h // 2).
        gc displayLineFromX:xOut0 y:y0 toX:xOut1 y:y0.
        y0 := y0 - 1.
        gc displayLineFromX:xOut0 y:y0 toX:xOut1 y:y0.
    ].

    cursorItem == item ifTrue:[
        "/ textStartLeft
        gc maskOrigin:((self viewOrigin + (0 @ 1)) \\ (lineMask extent)).
        gc mask:lineMask.
        w := listRenderer widthFor:item.
        gc displayRectangleX:x -1 y:(y+2) width:w+2 height:(h - 4).
        gc mask:nil.
    ] ifFalse:[
        enterItem == item ifTrue:[
            self highlightWithUnderline ifTrue:[
                "/ underline the hilite...
                y0 := y + h - 2.
                x1 := x + (listRenderer widthFor:item).

                gc displayLineFromX:x y:y0 toX:x1 y:y0.
            ]
        ].
    ].
!

drawSelectionFrameAt:lnNr x:x w:w
    "draw the background and foreground of the selection frame
     at a lineNr.
    "
    |item xMax xLftDmg xRgtDmg x0 x1 y0 y1 hL wL|

    (strikeOut or:[highlightMode isNil]) ifTrue:[
        ^ self
    ].
    editorView notNil ifTrue:[
        "/ there is an open editor; do not redraw selected
        ^ self
    ].

    (    highlightMode == #line
     or:[highlightMode == #label
     or:[highlightMode == #dropMode]]
    ) ifFalse:[
        "/ highlightMode not supported
        ^ self
    ].
    (item := self at:lnNr ifAbsent:nil) isNil ifTrue:[
        "/ list might change during drawing; item no longer visible
        ^ self
    ].
    xMax := x + w.

    "/ CLEAR THE BACKGROUND

    y0 := self yVisibleOfLine:lnNr.
    y1 := self yVisibleOfLine:(lnNr + 1).
    hL := y1 - y0.

    highlightMode == #line ifTrue:[
        x0 := x.
        x1 := xMax.
    ] ifFalse:[ "/ is #label or #rectangle
        x0 := (self xVisibleOfItem:item) - (textStartLeft // 2).
        x0 >= xMax ifTrue:[ ^ self ].

        x1 := x0 + (listRenderer widthFor:item) + textStartLeft + 1.
        x1 < x ifTrue:[ ^ self ].
    ].
    xLftDmg := x0 max:x.
    xRgtDmg := x1 min:xMax.
    xRgtDmg > xLftDmg ifFalse:[^ self].

    (highlightMode == #dropMode or:[self hasFocus not]) ifTrue:[
        gc paint:hilightBgColorNoFocus.
    ] ifFalse:[
        gc paint:hilightBgColor.
    ].
    gc fillRectangleX:xLftDmg y:y0 width:(xRgtDmg - xLftDmg) height:hL.
    wL := x1 - x0.

    "/ DRAW THE FRAME

    hilightFrameColor notNil ifTrue:[
        hilightLevel == 0 ifTrue:[
            gc paint:hilightFrameColor.

            highlightMode == #line ifTrue:[
                gc displayLineFromX:x0 y:y0 toX:x1 y:y0.
                y1 := y0 + hL - 1.
                gc displayLineFromX:x0 y:y1 toX:x1 y:y1.
            ] ifFalse:[
                gc displayRectangleX:x0 y:y0 width:wL height:hL
            ].
            ^ self.
        ]
    ] ifFalse:[
        hilightStyle == #motif ifTrue:[
            gc paint:bgColor.
            y1 := y0 + 1.
            highlightMode == #line ifTrue:[
                gc displayLineFromX:x0 y:y1 toX:x1 y:y1.
                y1 := y0 + hL - 2.
                gc displayLineFromX:x0 y:y1 toX:x1 y:y1.
            ] ifFalse:[
                gc displayRectangleX:x0 + 1 y:y1 width:wL - 2 height:hL - 2
            ]
        ].
        hilightLevel == 0 ifTrue:[ ^ self ].
    ].

    "/ draw edge
    highlightMode == #line ifTrue:[
        x0 := margin.
        wL := width - margin - margin.
    ].
    self drawEdgesForX:x0 y:y0 width:wL height:hL level:hilightLevel.
!

drawSelectionFrameFrom:start to:stop x:x y:y w:w
    "draw the selection frame between start to stop without clearing the background
    "
    highlightMode notNil ifTrue:[
        self selectionDo:[:lnNr|
            (lnNr between:start and:stop) ifTrue:[
                self drawSelectionFrameAt:lnNr x:x w:w
            ]
        ]
    ].

    "Created: / 24-04-2013 / 14:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidateSelection
    "invalidate (force async redraw) the current selection
    "
    shown ifTrue:[
        self selectionDo:[:aLnNr| self invalidateLineAt:aLnNr].
    ].
!

invalidateSelectionAt:aLineNr
    "redraw a line which changed its selection status.
     optimized when drawing only the label.
    "
    |item x|

    editorView notNil ifTrue:[
	"/ there is an open editor; do not redraw selected
	^ self
    ].

    (shown and:[aLineNr notNil and:[highlightMode notNil]]) ifFalse:[
	^ self
    ].

    highlightMode == #label ifTrue:[
	item := self at:aLineNr ifAbsent:nil.

	item isNil ifTrue:[
	    ^ self
	].
	x := (self xVisibleOfItem:item) - (textStartLeft // 2)
    ] ifFalse:[
	x := 0.
    ].
    self invalidateLineAt:aLineNr fromX:x
! !

!SelectionInListModelView methodsFor:'event handling'!

activateMenu
    |item menu appl|

    enabled ifFalse:[^ self].

    item := self selectedElement.
    item notNil ifTrue:[
        menu := item perform:#middleButtonMenu ifNotUnderstood:nil.
        menu notNil ifTrue:[
            menu isCollection ifTrue:[
                menu := Menu decodeFromLiteralArray:menu.
                appl := self application.

                appl notNil ifTrue:[
                    menu findGuiResourcesIn:appl.
                    "/ menu receiver:appl  -- now done in findGuiResources ...
                ] ifFalse:[
                    menu receiver:item
                ]
            ].
            self startUpMenu:menu.
            ^ self
        ].
    ].
    super activateMenu
!

buttonControlPressAtLine:lineNr x:x y:y
    "handle a button control press
    "
    |isInSelection prvLine chgSet doAdd|

    isInSelection := self isInSelection:lineNr.

    multipleSelectOk ifFalse:[
	isInSelection ifTrue:[
	    self deselect
	]ifFalse:[
	    (self canSelectIndex:lineNr forAdd:false) ifTrue:[
		self buttonPressOrReleaseAtLine:lineNr x:x y:y.
	    ].
	].
	^ self
    ].
    isInSelection ifTrue:[
	self removeFromSelection:lineNr
    ] ifFalse:[
	self addToSelection:lineNr.

	(self isInSelection:lineNr) ifFalse:[
	    "/ cannot add to selection
	    ^ self
	].
    ].

    prvLine := lineNr.
    chgSet  := IdentitySet new.
    doAdd   := isInSelection not.

    buttonMotionAction := [:p| |rowNr mustRestore step f|
	rowNr := self yVisibleToLineNr:(p y).

	(rowNr notNil and:[rowNr ~~ prvLine]) ifTrue:[
	    rowNr == lineNr ifTrue:[
		mustRestore := true
	    ] ifFalse:[
		rowNr > lineNr ifTrue:[ mustRestore := (rowNr < prvLine) ]
			      ifFalse:[ mustRestore := (rowNr > prvLine) ].
	    ].
	    prvLine > rowNr ifTrue:[ step := -1 ]
			  ifFalse:[ step :=  1 ].
	    mustRestore ifTrue:[
		[ prvLine ~~ rowNr ] whileTrue:[
		    (chgSet removeIdentical:prvLine ifAbsent:nil) notNil ifTrue:[
			doAdd ifFalse:[ self addToSelection:prvLine ]
			       ifTrue:[ self removeFromSelection:prvLine ].
		    ].
		    prvLine := prvLine + step.
		].
	    ] ifFalse:[
		[ prvLine ~~ rowNr ] whileTrue:[
		    prvLine := prvLine + step.

		    doAdd ~~ (self isInSelection:rowNr) ifTrue:[
			chgSet add:prvLine.

			doAdd ifTrue:[ self addToSelection:prvLine ]
			     ifFalse:[ self removeFromSelection:prvLine ].
		    ]
		].
	    ].
	].
    ].
!

buttonMotion:buttonMask x:x y:y
    "mouse-move while button was pressed - handle selection changes
    "
    |lnNr item|

    self stopAutoScroll.

    (buttonMask ~~ 0 and:[buttonMotionAction notNil]) ifTrue:[
	buttonMotionAction value:(x@y).

	(autoScroll and:[buttonMotionAction notNil]) ifTrue:[
	    "/ if moved outside of view, start autoscroll
	    (y between:0 and:height) ifFalse:[
		y < 0 ifTrue:[ self startAutoScroll:#scrollUp distance:y ]
		     ifFalse:[ self startAutoScroll:#scrollDown distance:(y - height) ].
	    ].
	].
	^ self
    ].

    (enabled and:[highlightEnterItem]) ifTrue:[
	self sensor anyButtonPressed ifFalse:[
	    lnNr := self yVisibleToLineNr:y.

	    lnNr notNil ifTrue:[ item := self at:lnNr ifAbsent:nil ]
		       ifFalse:[ item := nil ].

	    self pointerEntersItem:item.
	]
    ].
!

buttonMultiPress:button x:x y:y
    "button was pressed multiple - handle a doubleClick action"

    |lnNr|

    buttonMotionAction := buttonReleaseAction := nil.

    enabled ifFalse:[^ self].

    button == 1 ifTrue:[
        (     (lnNr := self yVisibleToLineNr:y)   notNil
         and:[(self at:lnNr ifAbsent:nil) notNil]
        ) ifTrue:[
            self selectedIndex ~~ lnNr ifTrue:[
                self breakPoint:#ca
            ].
            self doubleClicked.
        ].
        ^ self.
    ].

    super buttonMultiPress:button x:x y:y

    "Modified: / 30-06-2011 / 20:04:28 / cg"
!

buttonPress:button x:x y:y
    "a button was pressed - handle selection here
    "
    |sensor item menu appl isSelected lineNr startLine dragDistance|

    modelChangedDuringButtonPress := buttonMotionAction := buttonReleaseAction := nil.

    self pointerEntersItem:nil.
    self cursorEntersItem:nil.
    self closeEditor.

    enabled ifFalse:[^ self].

    sensor := self sensor.
    lineNr := self yVisibleToLineNr:y.

    (button == 2) ifTrue:[
        (self selectOnMenuButton and:[self numberOfSelections <= 1]) ifTrue:[
            (     lineNr notNil
             and:[self canSelectIndex:lineNr forAdd:false ]
            ) ifTrue:[
                (lineNr ~~ self selectedIndex) ifTrue: [
                    (self selectWithoutScroll:lineNr redraw:true) ifTrue:[
                        self selectionChanged
                    ].
                ].
            ]
        ].
        item := self selectedElement.
        item notNil ifTrue:[
            self makeSelectionVisible.
"/ now in activateMenu...
"/            menu := item perform:#middleButtonMenu ifNotUnderstood:nil.
"/            menu notNil ifTrue:[
"/                menu isCollection ifTrue:[
"/                    menu := Menu decodeFromLiteralArray:menu.
"/                    appl := self application.
"/
"/                    appl notNil ifTrue:[
"/                        menu findGuiResourcesIn:appl.
"/                        "/ menu receiver:appl  -- now done in findGuiResources ...
"/                    ] ifFalse:[
"/                        menu receiver:item
"/                    ]
"/                ].
"/                self startUpMenu:menu.
"/                ^ self
"/            ].
        ].
        super buttonPress:button x:x y:y.
        ^ self
    ].

    lineNr isNil ifTrue:[ ^ self ].
    modelChangedDuringButtonPress := false.

    sensor ctrlDown ifTrue:[
        self buttonControlPressAtLine:lineNr x:x y:y.
        ^ self
    ].

    isSelected  := self isInSelection:lineNr.

    (self canDrag and:[sensor shiftDown not]) ifTrue:[
        dragDistance := UserPreferences current motionDistanceToStartDrag.

        isSelected ifTrue:[
            buttonMotionAction :=
                [:p|
                    ((x@y) dist:p) > dragDistance ifTrue:[
                        self startDragAt:p.
                    ]
                ].
            buttonReleaseAction := [ self buttonPressOrReleaseAtLine:lineNr x:x y:y ].
            ^ self.
        ].

        self selectOnButtonPress ifFalse: [
            |oldSelection|

            "/ set selection to line;
            "/ set the model without change notification (objects to drag)

            oldSelection := selection copy.
            self selectAndUpdateModelWithoutChangeNotification: lineNr.
            self windowGroup processExposeEvents.

            buttonMotionAction :=
                [:p|
                    ((x@y) dist:p) > dragDistance ifTrue:[
                        |handler|

                        handler := self startDragAt:p.
                        handler contentsWillChange.
                        "/ restore old selection
                        self selectAndUpdateModelWithoutChangeNotification: oldSelection.
                        self windowGroup processExposeEvents.
                    ].
                ].

            buttonReleaseAction := [
                (self canSelectIndex:lineNr forAdd:false) ifTrue:[
                    "/ notify selection change
                    self selectionChanged.
                ] ifFalse:[
                    "/ restore old selection
                    self selectAndUpdateModelWithoutChangeNotification: oldSelection.
                ].
            ].
            ^ self
        ].
    ].

    multipleSelectOk ifFalse:[
        (isSelected or:[self canSelectIndex:lineNr forAdd:false]) ifTrue:[
            self buttonPressOrReleaseAtLine:lineNr x:x y:y.

            (dragDistance notNil and:[self isInSelection:lineNr]) ifTrue:[
                buttonMotionAction :=
                    [:p|
                        ((x@y) dist:p) > dragDistance ifTrue:[
                            self startDragAt:p.
                        ].
                    ].
            ].
        ].
        ^ self
    ].
    startLine := lineNr.

    sensor shiftDown ifTrue:[ |min max|
        (isSelected or:[self canSelectIndex:lineNr forAdd:true]) ifFalse:[
            ^ self
        ].

        multipleSelectOk ifTrue:[
            startLine := self firstInSelection.
            startLine isNil ifTrue:[ startLine := lineNr ].

            startLine <= lineNr ifTrue:[
                self selectFrom:startLine to:lineNr.
            ] ifFalse:[
                startLine := self lastInSelection.
                self selectFrom:lineNr to:startLine.
            ].
        ]
    ] ifFalse:[
        (isSelected or:[self canSelectIndex:lineNr forAdd:false]) ifFalse:[
            ^ self
        ].
        self buttonPressOrReleaseAtLine:lineNr x:x y:y.
    ].

    multipleSelectOk ifTrue:[
        buttonMotionAction :=
            [:p| 
                (p y between:0 and:height) ifTrue:[ |ln|
                    ln := self yVisibleToLineNr:p y.
                    ln isNil ifTrue:[ln := self size].

                    (ln ~~ self lastInSelection and:[ln ~~ self firstInSelection]) ifTrue:[
                        self selectFrom:startLine to:ln.
                        dragDistance := nil.   "/ selection changed - no longer dragable
                    ]
                ].

                (dragDistance notNil and:[(x dist:p x) > dragDistance]) ifTrue:[
                    self startDragAt:p.
                ].
            ].
    ].

    "Modified: / 27-03-2007 / 08:43:58 / cg"
!

buttonPressOrReleaseAtLine:aLnNr x:x y:y
    "handle a button press or release at a line
    "
    aLnNr == self selectedIndex ifTrue:[
	editorView notNil ifTrue:[^ self].

	self openEditorAction notNil ifTrue:[
	    self openEditorAtX:x y:y.
	    editorView notNil ifTrue:[^ self].
	].

	ignoreReselect ifFalse:[
	    (toggleSelect and:[self sensor ctrlDown]) ifTrue:[
		self selection:nil
	    ] ifFalse:[
		self selectionChanged
	    ].
	].
    ] ifFalse:[
	(self selectWithoutScroll:aLnNr redraw:true) ifTrue:[
	    self selectionChanged
	]
    ].
!

buttonRelease:button x:x y:y
    "a button was released"

    |makeSelectionVisible|

    button == 1 ifTrue:[
        makeSelectionVisible := modelChangedDuringButtonPress.
        buttonMotionAction   := modelChangedDuringButtonPress := nil.

        buttonReleaseAction notNil ifTrue:[
            buttonReleaseAction value.
            buttonReleaseAction := nil.
        ].

        self cursorEntersItem:nil.
    ].
    self stopAutoScroll.

    (makeSelectionVisible == true and:[self hasSelection]) ifTrue:[
        self makeSelectionVisible
    ].

    super buttonRelease:button x:x y:y
!

characterPress:aKey x:x y:y
    " a character is pressed - lookup and change selection
    "
    |lnNr size idx stp to1 fr2|

    size := self size.
    size > 1 ifFalse:[^ self].

    lnNr := self firstInSelection.
    lnNr isNil ifTrue:[lnNr := 0].

    self sensor shiftDown ifTrue:[
	stp := -1.              "/ search backward
	to1 :=  1.
	fr2 := size.
    ] ifFalse:[
	stp := 1.               "/ search forward
	to1 := size.
	fr2 := 1.
    ].

    idx := self findLineFrom:lnNr+stp to:to1 by:stp startingWithCharacter:aKey.

    idx == 0 ifTrue:[
	idx := self findLineFrom:fr2 to:lnNr-stp by:stp startingWithCharacter:aKey.
	idx == 0 ifTrue:[^ self].
    ].

    self selection:idx.

    keyActionStyle == #selectAndDoubleClick ifTrue:[
	self doubleClicked
    ].
!

characterSearchItemStringAt:anIndex
    "for first-character search:
     return a lines item-string.
     For multi-col items, this may be different from the actual string
    "
    |item s|

    item := self at:anIndex ifAbsent:nil.

    item isHierarchicalItem ifTrue:[
	item := item string
    ].
    item isNil ifTrue:[^ nil].

    (Error catch:[
	s := item asString
    ]) ifTrue:[
	s := item displayString
    ].
    ^ s
!

containerChangedSize
    "/ stupid kludge for motif-style (which draws a frame at the right-edge)
    "/ cg: I think it should not (see normal SelectionInListView, which does only
    "/     draw the frame at the top and bottom, but NOT at the left and right

    self hasSelection ifTrue:[
	(hilightFrameColor notNil
	or:[hilightStyle == #motif
	or:[hilightLevel ~~ 0]]) ifTrue:[
	   "/ invalidate the right-edge
	    self invalidate:(((width-3) @ 0) corner:((width-1) @ (height-1))).
	]
    ].

    super containerChangedSize.
!

cursorEntersItem:anItemOrNil
    "the cursor enters an item or nil
    "
    |lnNr x|

    (shown and:[self size ~~ 0]) ifFalse:[
	cursorItem := nil.
	^ self.
    ].

    anItemOrNil == cursorItem ifTrue:[ ^ self ].

    2 timesRepeat:[
	cursorItem notNil ifTrue:[
	    lnNr := self identityIndexOf:cursorItem.
	    lnNr notNil ifTrue:[
		x := self xVisibleOfItem:cursorItem.
		self invalidateLineAt:lnNr fromX:x
	    ].
	].
	"/ set the new item
	cursorItem := anItemOrNil.
    ].
    cursorItem notNil ifTrue:[
	self makeLineVisible:lnNr
    ].
!

doubleClicked
    "handle a double click
    "
    |arg|

    doubleClickActionBlock notNil ifTrue:[
	arg := self selectedIndex.

	arg ~~ 0 ifTrue:[
	    doubleClickActionBlock valueWithOptionalArgument:arg and:self.
	]
    ].
!

findLineFrom:aStart to:aStop by:aStep startingWithCharacter:aCharacter
    "find a line starting with a character
    "
    |char lbl cmp
     size     "{ Class:SmallInteger }"
     start    "{ Class:SmallInteger }"
     stop     "{ Class:SmallInteger }"
    |
    (size := self size) ~~ 0 ifTrue:[
	aStep > 0 ifTrue:[
	    aStart > aStop ifTrue:[^ 0].
	] ifFalse:[
	    (aStep == 0 or:[aStop > aStart]) ifTrue:[^ 0]
	].

	start := aStart < 0 ifTrue:[1] ifFalse:[aStart min:size].
	stop  := aStop  < 0 ifTrue:[1] ifFalse:[aStop  min:size].
	char  := aCharacter asUppercase.

	start to:stop by:aStep do:[:anIndex|
	    lbl := self characterSearchItemStringAt:anIndex.
	    lbl notNil ifTrue:[
		cmp := lbl string at:1 ifAbsent:nil.

		cmp notNil ifTrue:[
		    (char == cmp or:[char == cmp asUppercase]) ifTrue:[
			(self canSelectIndex:anIndex forAdd:false) ifTrue:[
			    ^ anIndex
			].
			^ 0
		    ]
		]
	    ]
	]
    ].
    ^ 0

    "Modified: / 15-09-2006 / 11:26:29 / User"
!

invalidateLineOfItem:anItem
    |lnNr x|

    lnNr := self identityIndexOf:enterItem.
    lnNr notNil ifTrue:[
	x := self xVisibleOfItem:enterItem.
	self invalidateLineAt:lnNr fromX:x
    ].
!

keyPress:aKey x:x y:y
    "a key was pressed - handle page-keys here
    "
    <resource: #keyboard( #CursorUp #CursorDown #EndOfText #EndOfLine
                          #BeginOfText #BeginOfLine #Return
                          #CmdReturn #CmdCursorUp #CmdCursorDown #SelectAll)>

    |lineNr listSize shifted newSel step start|

    enabled ifFalse:[ ^ self ].

    listSize := self size.
    listSize == 0 ifTrue:[^ self].

    aKey isCharacter ifTrue:[
        keyActionStyle notNil ifTrue:[
            keyActionStyle == #pass ifTrue:[
                super keyPress:aKey x:x y:y
            ] ifFalse:[
                self characterPress:aKey x:x y:y.
            ].
        ].
        ^ self
    ].

    aKey == #Escape ifTrue:[
        cursorItem notNil ifTrue:[
            self cursorEntersItem:nil.
            self makeSelectionVisible.
        ].
        super keyPress:aKey x:x y:y.
        ^ self
    ].

    ((aKey == #BeginOfText) or:[aKey == #BeginOfLine]) ifTrue:[
        self cursorEntersItem:nil.

        1 to:listSize do:[:i|
            (self canSelectIndex:i forAdd:false) ifTrue:[
                self selection:i.
                ^ self
            ].
        ].
        ^ self
    ].

    ((aKey == #EndOfText) or:[aKey == #EndOfLine]) ifTrue:[
        self cursorEntersItem:nil.

        listSize to:1 by:-1 do:[:i|
            (self canSelectIndex:i forAdd:false) ifTrue:[
                self selection:i.
                ^ self
            ].
        ].
        ^ self
    ].
    lineNr := self cursorLine.

    aKey == #Return ifTrue:[
        returnKeyActionStyle == #pass ifTrue:[
            super keyPress:aKey x:x y:y
        ] ifFalse:[
            lineNr ~~ 0 ifTrue:[
                self cursorEntersItem:nil.

                (self canSelectIndex:lineNr forAdd:false) ifTrue:[
                    self selection:lineNr
                ].
            ].

            returnKeyActionStyle == #doubleClick ifTrue:[
                self doubleClicked
            ].
        ].
        ^ self
    ].

    aKey == #SelectAll ifTrue:[
        self selectAll.
        ^ self
    ].

    (lineNr == 0 and:[selection notNil]) ifTrue:[
        multipleSelectOk ifFalse:[lineNr := selection]
                          ifTrue:[lineNr := selection last].
    ].

    aKey == #CmdReturn ifTrue:[
        "/ toggle selection of the item
        lineNr ~~ 0 ifTrue:[
            (self isInSelection:lineNr) ifTrue:[ self removeFromSelection:lineNr ]
                                       ifFalse:[ self addToSelection:lineNr ].

            self cursorEntersItem:(self at:lineNr).
        ].
        ^ self
    ].

    (aKey == #CmdCursorDown or:[aKey == #CmdCursorUp]) ifTrue:[
        aKey == #CmdCursorDown ifTrue:[
            lineNr := lineNr + 1.
            lineNr > listSize ifTrue:[lineNr := 1].
        ] ifFalse:[
            lineNr := lineNr - 1.
            lineNr < 1 ifTrue:[lineNr := listSize].
        ].
        self cursorEntersItem:(self at:lineNr).
        ^ self
    ].

    (aKey == #CursorUp or:[aKey == #CursorDown]) ifFalse:[
        super keyPress:aKey x:x y:y.
        ^ self
    ].
    shifted := (multipleSelectOk and:[self sensor shiftDown]).
    self cursorEntersItem:nil.

    aKey == #CursorDown ifTrue:[ step :=  1.]
                       ifFalse:[ step := -1.].

    shifted ifFalse:[ |compressed|
        compressed := self sensor compressKeyPressEventsWithKey:aKey.

        compressed ~~ 0 ifTrue:[
            aKey == #CursorDown ifTrue:[
                lineNr := lineNr + compressed.
                lineNr > listSize ifTrue:[lineNr := 1].
            ] ifFalse:[
                lineNr := lineNr - compressed.
                lineNr < 1 ifTrue:[lineNr := listSize].
            ].
        ].
    ].
    start  := lineNr.
    lineNr := lineNr + step.

    [ lineNr ~~ start ] whileTrue:[
        (lineNr between:1 and:listSize) ifFalse:[
            lineNr < 1 ifTrue:[ lineNr := listSize ]
                      ifFalse:[ lineNr := 1 ].
        ] ifTrue:[
            (self canSelectIndex:lineNr forAdd:shifted) ifTrue:[
                shifted ifFalse:[
                    self selection:lineNr.
                    ^ self
                ].
                (self isInSelection:lineNr) ifFalse:[
                    selection isNil ifTrue:[ newSel := Array with:lineNr ]
                                   ifFalse:[ newSel := selection copyWith:lineNr ].
                ] ifTrue:[
                    (start ~~ 0 and:[selection size > 1]) ifFalse:[
                        ^ self
                    ].
                    newSel := selection copyWithout:start.
                ].
                self selection:newSel.
"/                self selectWithoutScroll:newSel redraw:true.
"/                self makeLineVisible:lineNr.
"/                self selectionChanged.
                ^ self
            ].
            lineNr := lineNr + step.
        ]
    ].
!

pointerEntersItem:anItemOrNil
    "the pointer moves over an item or nil"

    (shown and:[self size ~~ 0]) ifFalse:[
        enterItem := nil.
        ^ self.
    ].

    anItemOrNil == enterItem ifTrue:[ ^ self ].

    enterItem notNil ifTrue:[ self invalidateLineOfItem:enterItem ].
    enterItem := anItemOrNil.
    enterItem notNil ifTrue:[ self invalidateLineOfItem:enterItem ].
!

pointerLeave:state
    self pointerEntersItem:nil.
    super pointerLeave:state.
!

sizeChanged:how
    |selectionWasVisible|

    selectionWasVisible := false.

    "/ stupid kludge for motif-style (which draws a frame at the right-edge)
    "/ cg: I think it should not (see normal SelectionInListView, which does only
    "/     draw the frame at the top and bottom, but NOT at the left and right

    self hasSelection ifTrue:[
	selectionWasVisible := self isSelectionVisibleIn:(previousExtent ? self extent).

	(hilightFrameColor notNil
	or:[hilightStyle == #motif
	or:[hilightLevel ~~ 0]]) ifTrue:[
	   "/ invalidate the right-edge
	    self invalidate:(((width-3) @ 0) corner:((width-1) @ (height-1))).
	].
    ].
    super sizeChanged:how.

    selectionWasVisible ifTrue:[
	self makeSelectionVisible
    ].
! !

!SelectionInListModelView methodsFor:'focus handling'!

showFocus:explicit
    self invalidateSelection.
    super showFocus:explicit
!

showNoFocus:explicit
    self invalidateSelection.
    super showNoFocus:explicit
!

wantsFocusWithPointerEnter
    "return true, if I want the focus when
     the mouse pointer enters"

    (editorView notNil and:[editorView realized]) ifTrue:[
	^ false
    ].

    (UserPreferences current focusFollowsMouse ~~ false
    and:[(styleSheet at:#'selection.requestFocusOnPointerEnter' default:true)
    ]) ifTrue:[
	self size > 0 ifTrue:[
	    ^ true
	]
    ].
    ^ false
! !

!SelectionInListModelView methodsFor:'help'!

flyByHelpTextAt:aPoint
    "for lines which are clipped, provide the full line as a tooltip
     (as in other list views)"
     
    |lineNr len line text text2|

    lineNr := self yVisibleToLineNr:aPoint y.
    lineNr isNil ifTrue:[ ^ nil ].

    line := self at:lineNr ifAbsent:nil.

    len := self widthOfWidestLineBetween:lineNr and:lineNr.
    len > width ifTrue:[
        line notNil ifTrue:[
            text := line displayString string 
                        collect:[:ch | ch isSeparator ifTrue:[$ ] ifFalse:[ch]].
        ].    
    ].
    
    "/ a hack; maybe we'll find a better solution...
    (line respondsTo:#helpText) ifTrue:[
        (text2 := line helpText) notEmptyOrNil ifTrue:[
            text2 := text2 withCRs.
            text isEmptyOrNil ifTrue:[
                text := text2
            ] ifFalse:[
                text := text , Character cr , text2.
            ].    
        ]
    ].    

    ^ text
! !

!SelectionInListModelView methodsFor:'initialization & release'!

fetchResources
    "fetch device colors and ..., to avoid reallocation at redraw time;
     *** called after a create or snapin to fetch all device resources
    "

    super fetchResources.

    hilightFgColor    := self colorOnDevice:hilightFgColor.
    hilightBgColor    := self colorOnDevice:hilightBgColor.
    hilightFrameColor := self colorOnDevice:hilightFrameColor.
    lineMask          := lineMask  onDevice:device.

    hilightFgColorNoFocus := self colorOnDevice:hilightFgColorNoFocus.
    hilightBgColorNoFocus := self colorOnDevice:hilightBgColorNoFocus.
!

initStyle
    "setup viewStyle specifics
    "
    <resource: #style (#'selection.selectOnMenuButton'
                       #'selection.font')>
    super initStyle.

    lineMask isNil ifTrue:[
        lineMask := Form width:2 height:2 fromArray:#[16rAA 16r55].
    ].

    hilightFrameColor   := nil.
    hilightStyle        := DefaultHilightStyle.
    highlightMode       := #label.
    textStartLeft       := 4.
    selectOnMenuButton  := styleSheet at:#'selection.selectOnMenuButton' default:nil.
    selectOnMenuButton isNil ifTrue:[
        selectOnMenuButton := UserPreferences current selectOnRightClick
    ].

    self font:(SelectionInListView defaultFont).

    device hasGrayscales ifTrue:[
        "
         must get rid of these hard codings
        "
        (hilightStyle == #next) ifTrue:[
            hilightFgColor := fgColor.
            hilightBgColor := self whiteColor.
            hilightFrameColor := fgColor
        ] ifFalse:[
            (hilightStyle == #motif) ifTrue:[
                fgColor := self whiteColor.
                bgColor := Grey.
                viewBackground := bgColor.
                hilightFgColor := bgColor.
                hilightBgColor := fgColor.
            ] ifFalse:[
                (hilightStyle == #openwin) ifTrue:[
                    hilightFgColor := fgColor.
                    hilightBgColor := Color gray.
                ]
            ]
        ]
    ].

    hilightFgColor isNil ifTrue:[
        hilightFgColor := bgColor.
    ].
    hilightBgColor isNil ifTrue:[
        hilightBgColor := fgColor.
    ].
    DefaultForegroundColor notNil ifTrue:[
        fgColor := DefaultForegroundColor
    ].
    DefaultBackgroundColor notNil ifTrue:[
        bgColor := viewBackground := DefaultBackgroundColor
    ].

    DefaultHilightForegroundColor notNil ifTrue:[
        hilightFgColor := DefaultHilightForegroundColor
    ].
    DefaultHilightBackgroundColor notNil ifTrue:[
        hilightBgColor := DefaultHilightBackgroundColor
    ].
    DefaultHilightFrameColor notNil ifTrue:[
        hilightFrameColor := DefaultHilightFrameColor
    ].

    hilightLevel := DefaultHilightLevel ? 0.
    lineSpacing := gc font descent.
    lineSpacing := lineSpacing + ((hilightLevel abs > 0) ifTrue:[1] ifFalse:[0]).

    hilightFgColor isNil ifTrue:[
        hilightFgColor := bgColor.
        hilightBgColor := fgColor.
    ].

    hilightFgColorNoFocus isNil ifTrue:[
        hilightFgColorNoFocus := DefaultHilightForegroundColorNoFocus.
        hilightFgColorNoFocus isNil ifTrue:[
            hilightFgColorNoFocus := hilightFgColor slightlyLightened.
        ]
    ].
    hilightBgColorNoFocus isNil ifTrue:[
        hilightBgColorNoFocus := DefaultHilightBackgroundColorNoFocus.
        hilightBgColorNoFocus isNil ifTrue:[ 
            hilightBgColorNoFocus := hilightBgColor slightlyLightened.
        ].
    ].

    "Modified: / 14-08-2010 / 12:23:09 / cg"
!

initialize
    "setup default attributes/behavior
    "
    multipleSelectOk     := false.
    useIndex             := true.
    ignoreReselect       := true.
    toggleSelect         := false.
    highlightEnterItem   := false.
    strikeOut            := false.

    keyActionStyle       := #select.
    returnKeyActionStyle := #doubleClick.

    extraSpaceAtBottomForDrop := 20.

    super initialize.

    "Modified: / 03-11-2010 / 01:34:54 / cg"
!

mapped
    "get selection from model; scroll to selection
    "
    super mapped.
    self makeSelectionVisible.
!

realize
    "get selection from model; scroll to selection
    "
    self updateFromModel.
    super realize.
! !

!SelectionInListModelView methodsFor:'private-editor'!

computeEditorLayout
    "update the layout of the editor
    "
    |lnNr item y0 x0 y1|

    editorView isNil ifTrue:[
	^ self
    ].

    (    (lnNr := self selectedIndex) == 0
     or:[(item := self at:lnNr ifAbsent:nil) isNil]
    ) ifTrue:[
	"/ there is no more single selection; thus close the editor
	^ self closeEditor
    ].

    x0 := (self xVisibleOfItem:item) - (textStartLeft // 2).
    y0 := self yVisibleOfLine:lnNr.
    y1 := self yVisibleOfLine:(lnNr + 1).

    minimumEditorHeight notNil ifTrue:[
	y1 := y0 + ((y1 - y0) max:minimumEditorHeight).
    ].
    "/ Changed by cg:
    "/ editorView layout:( Rectangle left:x top:y right:(width - 1 - margin) bottom:(h + 2 "- 1") ).
    editorView layout:( Rectangle left:x0 top:y0-2 right:(width - 1 - margin) bottom:y1 ).
!

openEditorAtX:x y:y
    "opens an editor on the current single selection
    "
    |item lnNr x0 y0 editor|

    self closeEditor.
    shown ifFalse:[^ self ].
    self openEditorAction isNil ifTrue:[^ self].

    lnNr := self selectedIndex.
    lnNr == 0 ifTrue:[^ self].

    item := self at:lnNr ifAbsent:nil.
    item isNil ifTrue:[^ self].

    x < (self xVisibleOfItem:item) ifTrue:[
        "/ not part of the selection frame; ignorre
        ^ self
    ].
    editor := self openEditor.
    editor isNil ifTrue:[^ self].

    y0 := (y - editor origin y) max:0.
    x0 := (x - editor origin x) max:0.

    "/ simulate clicking into the editor

    "/ Changed by cg:
    "/ but only if there was no initial selection
    editor isInputField ifTrue:[
        editor hasSelection ifFalse:[
            self sensor
                pushEvent:(WindowEvent buttonPress:1 x:x0 y:y0 view:editor);
                pushEvent:(WindowEvent buttonRelease:1 x:x0 y:y0 view:editor).
        ]
    ].

    "/ to clear the selection
    self invalidateLineAt:lnNr.
! !

!SelectionInListModelView methodsFor:'protocol'!

lostSynchronisation
    "called when the changes derived from the model are faster than the handling
    "
    self deselectWithoutRedraw.
    super lostSynchronisation.
! !

!SelectionInListModelView methodsFor:'queries'!

elementsForWhich:aBlock
    |result|

    result := OrderedCollection new.
    1 to:self size do:[:idx |
        |el|

        el := self at:idx.
        (aBlock value:el) ifTrue:[ result add:el].
    ].
    ^ result
!

isCursorKeyConsumer
    "return true, if the receiver can be controlled by cursor keys;
     i.e. it can handle some keyboard input,
     isCursorKeyConsumer are potential candidates for getting the keyboard
     focus initially within dialogBoxes, or when the focus-follows-pointer
     mode is off."

    ^ true
! !

!SelectionInListModelView methodsFor:'scroller interface'!

heightOfContents
    "answer the height of the contents in pixels.
     If the minimumEditorHeight and the openEditorAction is defined,
     we have to involve the minimumEditorHeight in the computation,
     to allow opening the editor fullyvisible at the last line."

    |cachedLinesY cachedMaxIdx y0 y1|

    cachedLinesY := self startOfLinesY.
    cachedMaxIdx := cachedLinesY size.
    cachedMaxIdx == 0 ifTrue:[ ^ 0 ].

    "/ !!!! cachedLinesY at:cachedMaxIdx might return nil (async reorg)
    y1 := cachedLinesY at:cachedMaxIdx ifAbsent:nil.
    y1 isNil ifTrue:[^ 0 ]. "/ is under construction due ro async. events

    (minimumEditorHeight notNil and:[openEditorAction notNil]) ifTrue:[
        y0 := cachedLinesY at:(cachedMaxIdx - 1) ifAbsent:0.
        y1 := y0 + ((y1 - y0) max:minimumEditorHeight).
    ].
    ^ y1 + extraSpaceAtBottomForDrop.

    "Modified: / 03-11-2010 / 01:35:05 / cg"
! !

!SelectionInListModelView methodsFor:'selection'!

addToSelection:lineNr
    "add line to selection without scrolling but raise a change notification
    "
    |oldSelect forAdd|

    (self isInSelection:lineNr) ifTrue:[
	^ self
    ].

    multipleSelectOk ifTrue:[ forAdd := selection notNil ]
		    ifFalse:[ forAdd := false ].

    (self canSelectIndex:lineNr forAdd:forAdd) ifFalse:[
	^ self
    ].

    self closeEditor.
    self cursorEntersItem:nil.

    multipleSelectOk ifFalse:[
	oldSelect := selection.
	selection := lineNr.
	oldSelect notNil ifTrue:[ self invalidateSelectionAt:oldSelect ].
    ] ifTrue:[
	selection notNil ifTrue:[ selection := selection copyWith:lineNr ]
			ifFalse:[ selection := OrderedCollection with:lineNr ].
    ].
    self invalidateSelectionAt:lineNr.
    self selectionChanged.
!

deselect
    "clear selection
    "
    self selection:nil

!

firstInSelection
    "returns the minimum index of selected indices or nil if nothing is selected
    "
    |min|

    multipleSelectOk   ifFalse:[ ^ selection ].
    selection size == 0 ifTrue:[ ^ nil ].

    min := selection at:1.
    selection do:[:aNumber| min := min min:aNumber ].
    ^ min
!

hasSelection
    "returns true if a selection exists
    "
    ^ selection notNil

!

isInSelection:aNumber
    "return true, if line, aNumber is in the selection
    "
    multipleSelectOk ifFalse:[
	^ (aNumber == selection)
    ].
    selection notNil ifTrue:[
	^ selection includesIdentical:aNumber
    ].
    ^ false
!

isSelectionVisible
    "returns true if any selected element is visible"

    ^ self isSelectionVisibleIn:(self extent)
!

isSelectionVisibleIn:anExtentPoint
    "returns true if any selected element is visible"

    self selectionDo:[:aLineNr|
	(self isLineVisible:aLineNr in:anExtentPoint) ifTrue:[^ true].
    ].
    ^ false
!

lastInSelection
    "returns the maximum index of selected indices or nil if nothing is selected
    "
    |max|

    multipleSelectOk   ifFalse:[ ^ selection ].
    selection size == 0 ifTrue:[ ^ nil ].

    max := 1.
    selection do:[:aNumber| max := max max:aNumber ].
    ^ max
!

makeSelectionVisible
    "scroll to make the selection line visible
     don't scroll, if any in the selection isVisible
    "
    |firstLine|

    modelChangedDuringButtonPress notNil ifTrue:[^ self].

    firstLine := self firstInSelection.
    (firstLine isNil or:[firstLine == 0]) ifTrue:[^ self].

    self selectionDo:[:aLnNr|
        (self lineIsFullyVisible:aLnNr) ifTrue:[^ self].
    ].
    self makeLineVisible:(self firstInSelection).
!

nextAfterSelection
    "return the index of the next selectable entry after the selection.
     Wrap at end."

    ^ self nextSelectableAfter:selection
!

nextSelectableAfter:indexOrIndexCollection
    "return the index of the next selectable entry after the indexOrIndexCollection.
     Wrap at end."

    |next sz|

    indexOrIndexCollection isNil ifTrue:[
        next := 1
    ] ifFalse:[
        indexOrIndexCollection isCollection ifTrue:[
            indexOrIndexCollection size == 0 ifTrue:[
                next := 1
            ] ifFalse:[
                next := indexOrIndexCollection max + 1
            ]
        ] ifFalse:[
            next := indexOrIndexCollection + 1
        ].
    ].

    (self canSelectIndex:next) ifFalse:[
        sz := self size.
        next > sz ifTrue:[
            next := 1.
        ] ifFalse:[
            [next <= sz
             and:[(self canSelectIndex:next) not ]] whileTrue:[
                next := next + 1
            ].
        ].
    ].

    (self canSelectIndex:next) ifFalse:[
        next := nil
    ].
    ^ next

    "Modified: / 08-08-1998 / 03:36:55 / cg"
    "Modified: / 22-04-2014 / 12:15:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numberOfSelections
    "return the number of selected items
    "
    selection isNil   ifTrue:[ ^ 0 ].
    multipleSelectOk ifFalse:[ ^ 1 ].
  ^ selection size
!

previousBeforeSelection
    "return the index of the previous selectable entry before the selection.
     Wrap at beginning."

    ^ self previousSelectableBefore:selection

!

previousSelectableBefore:indexOrIndexCollection
    "return the index of the previous selectable entry before the indexOrIndexCollection.
     Wrap at beginning."

    |prev|

    indexOrIndexCollection isNil ifTrue:[
        prev := list size 
    ] ifFalse:[
        indexOrIndexCollection isCollection ifTrue:[
            indexOrIndexCollection size == 0 ifTrue:[
                prev := list size
            ] ifFalse:[
                prev := indexOrIndexCollection min - 1
            ]
        ] ifFalse:[
            prev := indexOrIndexCollection - 1
        ].
    ].
    (self canSelectIndex:prev) ifFalse:[
        prev < 1 ifTrue:[
            prev := self size.
        ] ifFalse:[
            [prev >= 1
             and:[(self canSelectIndex:prev) not]] whileTrue:[
                prev := prev - 1
            ].
        ].
    ].
    (self canSelectIndex:prev) ifFalse:[
        prev := nil
    ].
    ^ prev

    "Modified: / 22-04-2014 / 12:16:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeFromSelection:lineNr
    "remove line from selection without scrolling but raise a change notification
    "
    (self isInSelection:lineNr) ifFalse:[
	^ self
    ].
    self closeEditor.
    self cursorEntersItem:nil.

    (multipleSelectOk and:[self numberOfSelections > 1]) ifTrue:[
	selection := selection copyWithout:lineNr.
    ] ifFalse:[
	selection := nil
    ].
    self invalidateSelectionAt:lineNr.
    self selectionChanged.
!

selectAll
    "select all entries.
     Model and/or actionBlock notification IS done."

    self selectFrom:1 to:self size.
!

selectElement:anElement
    "select the element. Scroll to make the new selection visible.
     Model and/or actionBlock notification IS done.
    "
    self selectElement:anElement ifAbsent:[self deselect]
!

selectElement:anElement ifAbsent:exceptionalValue
    |idx|

    idx := self identityIndexOf:anElement.
    idx == 0 ifTrue:[
	^ exceptionalValue value
    ].
    self selection:idx
!

selectElementForWhich:aBlock ifAbsent:exceptionalValue
    1 to:self size do:[:idx |
        (aBlock value:(self at:idx)) ifTrue:[
            self selection:idx.
            ^ self
        ].
    ].
    ^ exceptionalValue value

    "Created: / 06-10-2011 / 13:32:28 / cg"
!

selectFirst
    "select the first selectable element.
     Model and/or actionBlock notification IS done."

    self selection:(self nextSelectableAfter:0)
!

selectFirstVisibleLine
    "select the first visible selectable element.
     Model and/or actionBlock notification IS done."

    |firstLineShown|
    
    firstLineShown := self yVisibleToLineNr:1.
    self selection:(self nextSelectableAfter:firstLineShown-1)
!

selectFrom:aStart to:aStop
    "select lines between start and stop
    "
    |start stop step nsel|

    multipleSelectOk ifFalse:[^ self].

    start := aStart.
    stop  := aStop.

    aStart < aStop ifTrue:[
	start := aStart max:1.
	stop  := aStop  min:(self size).
	step  := 1.
	start > stop ifTrue:[^ self].

    ] ifFalse:[
	start := aStart min:(self size).
	stop  := aStop  max:1.
	step  := -1.
	start < stop ifTrue:[^ self].
    ].
    nsel := OrderedCollection new.

    start to:stop by:step do:[:i|
	(self canSelectIndex:i forAdd:true) ifTrue:[
	    nsel add:i.
	].
    ].

    (self selectWithoutScroll:nsel redraw:true) ifTrue:[
	self selectionChanged
    ].
!

selectLast
    "select the last selectable element.
     Model and/or actionBlock notification IS done."

    self selection:(self previousSelectableBefore:list size + 1)
!

selectNext
    "select next line or first visible if there is currrently no selection.
     Wrap at end. 
     Model and/or actionBlock notification IS done."

    self selection:(self nextAfterSelection)

    "Modified: 15.11.1996 / 17:01:27 / cg"
!

selectPrevious
    "select previous line or previous visible if there is currently no selection.
     Wrap at beginning. 
     Model and/or actionBlock notification IS done."

    self selection:(self previousBeforeSelection).

    "Modified: 26.9.1995 / 09:41:16 / stefan"
    "Modified: 15.11.1996 / 17:01:34 / cg"
!

selectedElement
    "return the single selected item or nil
    "
    |index|

    (index := self selectedIndex) ~~ 0 ifTrue:[
	^ self at:index ifAbsent:nil
    ].
    ^ nil
!

selectedIndex
    "returns the index of the selected line or 0. If more
     lines are selected, 0 is returned
    "
    selection notNil ifTrue:[
	multipleSelectOk ifFalse:[ ^ selection ].

	selection size == 1 ifTrue:[
	    ^ selection at:1
	]
    ].
    ^ 0
!

selection
    "return the selection index or collection of indices
     in case of multiple selection enabled
    "
    ^ selection

!

selection:something
    "select something or deselect if the argument is nil;
     scroll to make the selected line visible.
     The model and/or actionBlock IS notified."

    (self selectWithoutScroll:something redraw:true) ifTrue:[
        self makeSelectionVisible.
        self selectionChanged
    ].
!

selectionAsCollection
    "return the selection as a collection of line numbers.
     This allows users of this class to enumerate independent of
     the multipleSelect style.
    "
    selection isNil  ifTrue:[ ^ #() ].
    multipleSelectOk ifTrue:[ ^ selection ].

  ^ OrderedCollection with:selection
!

selectionDo:aBlock
    "perform aBlock for each nr in the selection.
     For single selection, it is called once for the items nr.
     For multiple selections, it is called for each.
    "
    selection notNil ifTrue:[
	multipleSelectOk ifTrue:[
	    selection do:aBlock
	] ifFalse:[
	    aBlock value:selection
	].
    ].


!

selectionValue
    "return the selection value i.e. the text in the selected line.
     For multiple selections a collection containing the entries is returned.
    "
    multipleSelectOk ifTrue:[
	selection isNil ifTrue:[^ #()].
	^ selection collect:[:nr| self at:nr ]
    ].
    selection isNil ifTrue:[^ nil].
    ^ self at:selection ifAbsent:nil.
!

selectionValueAsCollection
    "return the selection values as a collection - allows selectionValues to
     be enumerated independent of the multiSelect settings
    "
    |value|

    value := self selectionValue.
    multipleSelectOk ifTrue:[^ value].

    value notNil ifTrue:[^ Array with:value ].
  ^ #()
!

setSelection:something
    "select something or deselect if the argument is nil;
     scroll to make the selected line visible.
     *** No model and/or actionBlock notification is done here.
    "
    (self selectWithoutScroll:something redraw:true) ifTrue:[
	self makeSelectionVisible
    ]

! !

!SelectionInListModelView methodsFor:'selection private'!

canSelectIndex:anIndex
    "return true, if the object identified by its index is selectable
    "
    ^ self canSelectIndex:anIndex forAdd:false
!

canSelectIndex:anIndex forAdd:isForAdd
    "return true, if the object identified by its index is selectable
    "
    |item isOk|

    selectConditionBlock notNil ifTrue:[
	isOk := selectConditionBlock valueWithOptionalArgument:anIndex and:isForAdd.

	isOk ifFalse:[
	    ^ false
	]
    ].

    item := self at:anIndex ifAbsent:nil.
    item isNil ifTrue:[^ false].

    item isHierarchicalItem ifTrue:[
	^ item isSelectable
    ].
    ^ true
!

deselectWithoutRedraw
    "clear the selection without redraw and scrolling;
     the model and/or actionBlock is notified
    "
    (self selectWithoutScroll:nil redraw:false) ifTrue:[
	self selectionChanged
    ]
!

selectAndUpdateModelWithoutChangeNotification: aLineNo
    |arg|

    self selectWithoutScroll:aLineNo redraw:true.
    modelChangedDuringButtonPress := false.
    model isNil ifTrue:[ ^ self ].
    arg := self argForChangeMessage.
    self sendChangeMessage:#setValue: with:arg.
!

selectWithoutScroll:something redraw:doRedraw
    "change selection to something; returns true if selection changed
    "
    |oldSelect size|

    selection = something ifTrue:[^ false].

    oldSelect := selection.
    selection := nil.   "/reset selection
    size := self size.

    ( size > 0 and:[ something notNil ] ) ifTrue:[
        something isNumber ifTrue:[
            (something between:1 and:size) ifTrue:[
                selection := multipleSelectOk ifTrue:[Array with:something]
                                             ifFalse:[something]
            ]
        ] ifFalse:[
            something size > 0 ifTrue:[
                selection := OrderedCollection new.
                something do:[:each|
                    each isNumber ifTrue:[
                        (each between:1 and:size) ifTrue:[
                            selection add: each.
                        ]
                    ]
                ].
                selection isEmpty ifTrue:[
                    selection := nil.
                ] ifFalse:[
                    multipleSelectOk ifFalse:[ selection := selection first ].
                ].
            ].
        ].
    ].
    selection = oldSelect ifTrue:[^ false].

    modelChangedDuringButtonPress notNil ifTrue:[
        modelChangedDuringButtonPress := true.
    ].

    self closeEditor.
    self cursorEntersItem:nil.


    (doRedraw and:[shown]) ifFalse:[
        ^ true
    ].

    multipleSelectOk ifFalse:[
        oldSelect notNil ifTrue:[self invalidateSelectionAt:oldSelect].
        selection notNil ifTrue:[self invalidateSelectionAt:selection].
    ] ifTrue:[
        (selection notNil and:[oldSelect notNil]) ifTrue:[
            selection do:[:i|(oldSelect includesIdentical:i) ifFalse:[self invalidateSelectionAt:i]].
            oldSelect do:[:i|(selection includesIdentical:i) ifFalse:[self invalidateSelectionAt:i]].
        ] ifFalse:[
            oldSelect isNil ifTrue:[oldSelect := selection].
            oldSelect do:[:i|self invalidateSelectionAt:i]
        ]
    ].
    ^ true
! !

!SelectionInListModelView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

