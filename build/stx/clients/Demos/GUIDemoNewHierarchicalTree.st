"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoNewHierarchicalTree
	instanceVariableNames:'list selectionHolder enabledHolder visibleHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

HierarchicalItem subclass:#Item
	instanceVariableNames:'label'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoNewHierarchicalTree
!


!GUIDemoNewHierarchicalTree class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoNewHierarchicalTree andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoNewHierarchicalTree new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoNewHierarchicalTree open
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
          #bounds: #(#Rectangle 1064 412 1364 712)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#HierarchicalListViewSpec
              #name: 'HierarchicalListView1'
              #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              #visibilityChannel: #visibleHolder
              #enableChannel: #enabledHolder
              #tabable: true
              #model: #selectionHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #miniScrollerVertical: true
              #listModel: #list
              #useIndex: false
              #highlightMode: #label
              #doubleClickSelector: #doubleClickedPressed:
              #indicatorSelector: #indicatorPressed:
              #postBuildCallback: #postBuildTree:
              #properties: 
             #(#PropertyListDictionary
                #dragArgument: nil
                #dropObjectSelector: #dropObjects:
                #dropArgument: nil
                #canDropSelector: #canDrop:
                #dropSelector: #drop:
              )
            )
           )
         
        )
      )
! !

!GUIDemoNewHierarchicalTree methodsFor:'actions'!

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

!GUIDemoNewHierarchicalTree methodsFor:'aspects'!

enabledHolder
    enabledHolder isNil ifTrue:[
        enabledHolder := true asValue.
    ].
    ^ enabledHolder.
!

list
    |root|

    list isNil ifTrue:[
        list := HierarchicalList new.
        root := Item new.
        root expand.
        list root:root.
    ].
    ^ list
!

selectionHolder
    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
    ].
    ^ selectionHolder.
!

visibleHolder
    visibleHolder isNil ifTrue:[
        visibleHolder := true asValue.
    ].
    ^ visibleHolder.
! !

!GUIDemoNewHierarchicalTree methodsFor:'drag & drop'!

canDrop:aDropContext
    "returns true if the objects are dropable
    "
    |targetItem|

    targetItem := self dropTargetItemFor:aDropContext.
  ^ targetItem notNil
!

drop:aDropContext
    "drop objects
    "
    |targetItem newItem targetPrnt|

    self showCR:'#drop:'.

    targetItem := self dropTargetItemFor:aDropContext.
    targetItem isNil ifTrue:[^ false].

    newItem := Item new.
    newItem setLabel:(aDropContext dropObjects first theObject).

    (   (targetPrnt := targetItem parent) isNil
     or:[targetItem isExpanded and:[targetItem hasChildren]]
    ) ifTrue:[
        targetItem addFirst:newItem.
        targetItem expand.
    ] ifFalse:[
        targetPrnt add:newItem after:targetItem
    ].
    self selectionHolder value:newItem.
  ^ true
!

dropObjects:DropSource
    "returns my drop objects
    "
    |item|

    self showCR:'#dropObjects:'.

    item := self selectionHolder value.
    item isNil ifTrue:[ ^ nil ].

    ^ Array with:(DropObject newText:item label)
!

dropTargetItemFor:aDropContext
    "returns the target item wheree to drop or nil
    "
    |lnNr view dropObjects|

    "/ test whether i'am enabled.
    self enabledHolder value ifFalse:[^ nil].

    dropObjects := aDropContext dropObjects.
    dropObjects size == 1          ifFalse:[^ nil].
    dropObjects first isTextObject ifFalse:[^ nil].

    "/ get the item under the mouse from the target view.

    view := aDropContext targetWidget.
    lnNr := view yVisibleToLineNr:(aDropContext targetPoint y).
    lnNr isNil ifTrue:[ ^ nil ].

  ^ self list at:lnNr ifAbsent:nil.
! !

!GUIDemoNewHierarchicalTree methodsFor:'startup & release'!

postBuildTree:aView
    self showCR:'#postBuildTree:'.
! !

!GUIDemoNewHierarchicalTree::Item methodsFor:'accessing'!

setLabel:aLabel
    "change the label without a notification
    "
    label := aLabel.
! !

!GUIDemoNewHierarchicalTree::Item methodsFor:'protocol accessing'!

children
    "auto creation of children if not yet initizlized (children == nil)
       -> see HierarchicalItem category protocol
    "
    |level|

    children isNil ifTrue:[
        level := self level.

        level == 4 ifTrue:[
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

!GUIDemoNewHierarchicalTree class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoNewHierarchicalTree.st,v 1.4 2002-10-19 11:41:30 ca Exp $'
! !
