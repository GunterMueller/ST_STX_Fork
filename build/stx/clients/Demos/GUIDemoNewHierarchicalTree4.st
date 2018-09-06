"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoNewHierarchicalTree4
	instanceVariableNames:'list selectionHolder dropOverLine'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

HierarchicalItem subclass:#Item
	instanceVariableNames:'label'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoNewHierarchicalTree4
!


!GUIDemoNewHierarchicalTree4 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoNewHierarchicalTree4 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoNewHierarchicalTree4 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoNewHierarchicalTree4 open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'New-HierarchicalTree'
          #name: 'New-HierarchicalTree'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 350 309 650 609)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#HierarchicalListViewSpec
              #name: 'HierarchicalListView1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #tabable: true
              #model: #selectionHolder
              #menu: #middleButtonMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #miniScrollerVertical: true
              #listModel: #list
              #multipleSelectOk: true
              #useIndex: false
              #highlightMode: #label
              #doubleClickSelector: #doubleClickedPressed:
              #indicatorSelector: #indicatorPressed:
              #properties: 
             #(#PropertyListDictionary
                #dropSelector: #drop:
                #dragArgument: nil
                #dropObjectSelector: #dropObjects:
                #dropArgument: nil
                #canDropSelector: #canDrop:
                #leaveSelector: #dropLeave:
                #overSelector: #dropOver:
                #enterSelector: #dropEnter:
              )
            )
           )
         
        )
      )
! !

!GUIDemoNewHierarchicalTree4 class methodsFor:'menu specs'!

middleButtonMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GUIDemoNewHierarchicalTree4 andSelector:#middleButtonMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GUIDemoNewHierarchicalTree4 middleButtonMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'Delete'
            #value: #doDelete
          )
         #(#MenuItem
            #label: 'Create'
            #value: #doCreate
          )
         )
        nil
        nil
      )
! !

!GUIDemoNewHierarchicalTree4 methodsFor:'actions'!

doubleClickedPressed:anIndex
    |item|

    self showCR:('#doubleClickedPressed: ', anIndex printString).

    item := self list at:anIndex ifAbsent:nil.

    item notNil ifTrue:[
	item toggleExpand
    ].        
!

indicatorPressed:anIndex
    |item|

    self showCR:('#indicatorPressed: ', anIndex printString).

    item := self list at:anIndex ifAbsent:nil.

    item notNil ifTrue:[
	item toggleExpand
    ].        
! !

!GUIDemoNewHierarchicalTree4 methodsFor:'aspects'!

list
    ^ list
!

selectionHolder
    ^ selectionHolder.
! !

!GUIDemoNewHierarchicalTree4 methodsFor:'drag & drop'!

canDrop:aDropContext
    "returns true if the objects are dropable
    "
    ^ dropOverLine notNil and:[ dropOverLine ~~ 0 ]
!

changeDropLineTo:aLineOrNil in:aDropContext
    "the over dropLine changed; redraw drop indication stuff
    "
    |x0 x1 y0 view|

    aLineOrNil == dropOverLine ifTrue:[
        ^ self. "/ nothing changed
    ].
    view := aDropContext targetWidget.
    x0   := view margin + 2.
    x1   := view width - x0.

    "/ inform the DragAndDrop handler that the draw contents will change
    aDropContext contentsWillChange.

    (dropOverLine notNil and:[dropOverLine ~~ 0]) ifTrue:[
        "/ restore old draw
        y0 := view yVisibleOfLine:(dropOverLine + 1).
        y0 := y0 - 3.

        view invalidate:(Rectangle left:x0 top:y0 width:(x1-x0+1) height:2)
              repairNow:true.
    ].

    dropOverLine := aLineOrNil.

    (dropOverLine notNil and:[dropOverLine ~~ 0]) ifTrue:[
        "/ highlight new drop target
        y0 := view yVisibleOfLine:(dropOverLine + 1).
        y0 := y0 - 3.

        view paint:(Color white).
        view displayLineFromX:x0 y:y0 toX:x1 y:y0.
        y0 := y0 + 1.
        view paint:(Color black).
        view displayLineFromX:x0 y:y0 toX:x1 y:y0.
    ].
!

drop:aDropContext
    "drop objects
    "
    |targetItem targetPrnt listIndex newItems index|

    self showCR:'#drop:'.

    listIndex := dropOverLine.
    self changeDropLineTo:nil in:aDropContext.

    listIndex isNil ifTrue:[^ false].
    targetItem := list at:listIndex ifAbsent:nil.
    targetItem  isNil ifTrue:[^ false].

    newItems := OrderedCollection new.

    aDropContext dropObjects do:[:el| |item|
        item := Item new.
        item setLabel:(el theObject).
        newItems add:item.
    ].

    (   (targetPrnt := targetItem parent) isNil
     or:[targetItem isExpanded and:[targetItem hasChildren]]
    ) ifTrue:[
        targetItem addAll:newItems beforeIndex:1.
    ] ifFalse:[
        index := targetPrnt identityIndexOf:targetItem.
        targetPrnt addAll:newItems beforeIndex:(index + 1)
    ].
    self selectionHolder value:newItems.
  ^ true
!

dropEnter:aDropContext
    "a drop operation enters my widget; validate dropable objects.
     If the objects are not dropable, dropOverLine is set to nil,
     otherwise to 0 (can drop the contents but not).
    "
    |dropObjects|

    self showCR:'#dropEnters: test if objects are droppable'.

    dropOverLine := nil.                        "/ set to not dropable

    dropObjects  := aDropContext dropObjects.
    dropObjects size == 0 ifTrue:[^ false].     "/ not dropable

    dropObjects do:[:el|
        el isTextObject ifFalse:[^ false].      "/ not dropable
    ].

    "/ dropable but we do not know the target item yet
    "/ handled in #dropOver:
    dropOverLine := 0.                          "/ is dropable
  ^ true
!

dropLeave:aDropContext
    "the widget is leaved; restore drop indications drawn ...
    "
    self showCR:'#dropLeave:'.
    self changeDropLineTo:nil in:aDropContext.
!

dropObjects:DropSource
    "returns my drop objects
    "
    |selection|

    self showCR:'#dropObjects:'.

    selection := selectionHolder value.
    selection size == 0 ifTrue:[^ nil].

  ^ selection collect:[:el| DropObject newText:el label ].
!

dropOver:aDropContext
    "called during drag & drop over the widget
     compute new drop target source
    "
    |lnNr item view|

    dropOverLine ifNil:[^ self ].       "/ context not valid to me ...

    view := aDropContext targetWidget.
    lnNr := view yVisibleToLineNr:(aDropContext targetPoint y).
    item := nil.

    lnNr notNil ifTrue:[
        item := list at:lnNr ifAbsent:nil.
    ].
    item ifNil:[ lnNr := 0 ].   "/ not dropable for item

    "/ redraw drop indication
    self changeDropLineTo:lnNr in:aDropContext.
! !

!GUIDemoNewHierarchicalTree4 methodsFor:'initialization'!

initialize
    |root|

    super initialize.

    list := HierarchicalList new.
    root := Item new.
    root expand.
    list root:root.

    selectionHolder := ValueHolder new.
! !

!GUIDemoNewHierarchicalTree4 methodsFor:'startup & release'!

postBuildTree:aView
    self showCR:'#postBuildTree:'.
! !

!GUIDemoNewHierarchicalTree4 methodsFor:'user operations'!

doCreate

    |selection|

    self showCR:'#doCreate'.

    selection := selectionHolder value.

    selection size ~~ 1 ifTrue:[
        self showCR:'   >> cannot create child, do not no where'.
      ^ self
    ].
    selection first add:(Item new).            
!

doDelete
    |selection size root superItems|

    self showCR:'#doDelete'.

    selection := selectionHolder value.

    size := selection size.
    size == 0 ifTrue:[
        self showCR:'   >> nothing selected'.
      ^ self
    ].

    root := list root.

    (selection includesIdentical:root) ifTrue:[
        self showCR:'   >> cannot remove the root'.
      ^ self
    ].

    size == 1 ifTrue:[
        selection first remove.
      ^ self
    ].

    "/ first remove items already included in other items to be deleted

    superItems := OrderedCollection new.

    selection do:[:anItem|
        anItem parentsDetect:[:el| selection includesIdentical:el ]
                      ifNone:[ superItems add:anItem ].
    ].
    superItems do:[:el| el remove ].
! !

!GUIDemoNewHierarchicalTree4::Item methodsFor:'accessing'!

setLabel:aLabel
    "change the label without a notification
    "
    label := aLabel.
    children isNil ifTrue:[children := #() ].
! !

!GUIDemoNewHierarchicalTree4::Item methodsFor:'protocol accessing'!

children
    "auto creation of children if not yet initizlized (children == nil)
       -> see HierarchicalItem category protocol
    "
    |level|

    children isNil ifTrue:[
        level := self level.

        level >= 4 ifTrue:[
            children := #().
        ] ifFalse:[
            children := OrderedCollection new.
            3 timesRepeat:[ children add:(self class parent:self) ].
       ]
    ].
    ^ children.
!

icon
    "returns my icon dependant on my level
       -> see HierarchicalItem category protocol
    "
    |level|

    level := self level.
    level == 1 ifTrue:[ ^ ToolbarIconLibrary search16x16Icon ]. "/ root item
    level == 2 ifTrue:[ ^ ToolbarIconLibrary searchPrev16x16Icon  ].
    level == 3 ifTrue:[ ^ ToolbarIconLibrary copy16x16Icon ].
  ^ ToolbarIconLibrary fileNew16x16Icon
!

label
    "returns my printable label
       -> see HierarchicalItem category protocol
    "
    label notNil ifTrue:[
	^ label
    ].
    "/ auto generate my label

    parent isHierarchicalItem ifTrue:[
	parent isRootItem ifTrue:[ label := 'Item-' ]
			 ifFalse:[ label := parent label, '.' ].

	label := label, (parent identityIndexOf:self) printString.
    ] ifFalse:[
	label := 'Root'
    ].
    ^ label
! !

!GUIDemoNewHierarchicalTree4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoNewHierarchicalTree4.st,v 1.2 2004-11-30 11:03:58 cg Exp $'
! !
