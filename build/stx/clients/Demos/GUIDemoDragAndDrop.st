"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoDragAndDrop
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

!GUIDemoDragAndDrop class methodsFor:'documentation'!

documentation
"
    The class demonstrates how to use the Drag & Drop mechanism.

    [author:]
        Claus Atzkern

    [start with:]
        GUIDemoDragAndDrop open
        GUIDemo open
"


! !

!GUIDemoDragAndDrop class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:GUIDragAndDrop andSelector:#windowSpec
     GUIDragAndDrop new openInterface:#windowSpec
     GUIDragAndDrop open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'unnamed canvas'
              #layout: #(#LayoutFrame 157 0 140 0 456 0 439 0)
              #label: 'unnamed canvas'
              #min: #(#Point 10 10)
              #max: #(#Point 1280 1024)
              #bounds: #(#Rectangle 157 140 457 440)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#SequenceViewSpec
                    #name: 'SequenceView1'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 0.5)
                    #model: #selection1
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #miniScrollerHorizontal: true
                    #miniScrollerVertical: true
                    #isMultiSelect: true
                    #useIndex: false
                    #sequenceList: #list1
                    #properties: 
                     #(#PropertyListDictionary
                        #dropObjectSelector: #getDropObjects:
                        #dropArgument: 1
                        #startDragSelector: #doStartDrag:in:
                        #dragArgument: 1
                        #displayObjectSelector: #getDisplayObjects:
                        #feedBackSelector: #dragAndDropFeedBack:
                        #dropSelector: #doDrop:argument:
                        #canDropSelector: #canDrop:argument:
                    )
                )
                 #(#SequenceViewSpec
                    #name: 'SequenceView2'
                    #layout: #(#LayoutFrame 0 0.0 0 0.5 0 1.0 0 1.0)
                    #model: #selection2
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #miniScrollerHorizontal: true
                    #miniScrollerVertical: true
                    #isMultiSelect: true
                    #useIndex: false
                    #sequenceList: #list2
                    #properties: 
                     #(#PropertyListDictionary
                        #dropObjectSelector: #getDropObjects:
                        #dropArgument: 2
                        #startDragSelector: #doStartDrag:in:
                        #dragArgument: 2
                        #displayObjectSelector: #getDisplayObjects:
                        #feedBackSelector: #dragAndDropFeedBack:
                        #canDropSelector: #canDrop:argument:
                        #dropSelector: #doDrop:argument:
                    )
                )
              )
          )
      )
! !

!GUIDemoDragAndDrop methodsFor:'aspects'!

list1
    |list|

    (list := builder bindingAt:#list1) isNil ifTrue:[
        builder aspectAt:#list1 put:(list :=  List new).
        list add:'foo 1'.
        list add:'bar 1'.
        list add:'baz 1'.
    ].
    ^ list
!

list2
    |list|

    (list := builder bindingAt:#list2) isNil ifTrue:[
        builder aspectAt:#list2 put:(list :=  List new).
        list add:'foo 2'.
        list add:'bar 2'.
        list add:'baz 2'.
    ].
    ^ list
!

selection1
    |holder|

    (holder := builder bindingAt:#selection1) isNil ifTrue:[
        builder aspectAt:#selection1 put:(holder :=  ValueHolder new).
    ].
    ^ holder
!

selection2
    |holder|

    (holder := builder bindingAt:#selection2) isNil ifTrue:[
        builder aspectAt:#selection2 put:(holder :=  ValueHolder new).
    ].
    ^ holder
! !

!GUIDemoDragAndDrop methodsFor:'drag'!

doStartDrag:aDropSource in:aView
    "set the cursors before starting the drag & drop operation
    "
    |hdl|

    self showCR:'Source: start a Drag Operation on my own.'.
    self showCR:'        Thus, I can set the cursor and the cursor position'.

    hdl := DragAndDropManager new.

    hdl disabledCursor:(Image fromFile:'xpmBitmaps/cursors/no_entry.xpm').
    hdl enabledCursor:(Image fromFile:'xpmBitmaps/cursors/double_crossHair.xpm').
    hdl alienCursor:nil.

    hdl startDragFrom:aView dropSource:aDropSource offset:#topLeft

!

dragAndDropFeedBack:aContext
    "feed back from the drag & drop operation
    "
    |sel lst arg|

    self showCR:'Source: Feedback from the Drag & Drop Operation:'.

    aContext hasDropped ifTrue:[
        self showCR:'        -> drop ok: remove elements from list'.
        arg := aContext dropSource argument.
        lst := self listAssignedToArgument:arg.
        sel := self selectionAssignedToArgument:arg.

        sel do:[:el| lst remove:el ]
    ] ifFalse:[
        self showCR:'        -> no drop'
    ].
    self showCR:'-----------------------------------------------------------------'
!

getDisplayObjects:aDropSource
    |objects fnName string size|

    objects := self selectionAssignedToArgument:(aDropSource argument).
    size    := objects size.

    size == 1 ifTrue:[
        fnName := 'ui_menuitem.xpm'.
        string := objects first printString.
    ] ifFalse:[
        fnName := 'ui_submenu_open.xpm'.
        string := 'Collection of:  ', size printString, '  Elements'.
        
    ].

    ^ Array with:(LabelAndIcon icon:(Image fromFile:fnName)
                             string:(Text string:string emphasis:#bold)
                 )
!

getDropObjects:aDropSource
    |sel|

    sel := self selectionAssignedToArgument:(aDropSource argument).
    ^ sel collect:[:el| DropObject newText:el ]
! !

!GUIDemoDragAndDrop methodsFor:'drop'!

canDrop:aContext argument:anId
    |source|

    source := aContext dropSource.

    source notNil ifTrue:[
        ^ source argument ~~ anId
    ].
    ^ false

!

doDrop:aContext argument:anId
    |list|

    self showCR:'Target: drop objects into list'.

    list := self listAssignedToArgument:anId.

    aContext dropObjects do:[:obj|
        list add:(obj theObject printString).
    ].
! !

!GUIDemoDragAndDrop methodsFor:'queries'!

listAssignedToArgument:anArgument

    ^ anArgument == 1 ifTrue:[self list1]
                     ifFalse:[self list2]
!

selectionAssignedToArgument:anArgument

    ^ anArgument == 1 ifTrue:[self selection1 value]
                     ifFalse:[self selection2 value]
! !

!GUIDemoDragAndDrop class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoDragAndDrop.st,v 1.2 1999-12-08 16:38:42 ca Exp $'
! !
