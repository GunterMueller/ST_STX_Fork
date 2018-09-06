"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoNewHierarchicalTree3
	instanceVariableNames:'list'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!

HierarchicalItem subclass:#Item
	instanceVariableNames:'label'
	classVariableNames:''
	poolDictionaries:''
	privateIn:GUIDemoNewHierarchicalTree3
!

!GUIDemoNewHierarchicalTree3 class methodsFor:'documentation'!

documentation
"
    simple hierarchical list

    on doubleClich the selected item will change or
    children are created.

    There exists also a middleButton menu derived from the item itself
"
! !

!GUIDemoNewHierarchicalTree3 class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoNewHierarchicalTree3 andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoNewHierarchicalTree3 new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoNewHierarchicalTree3 open
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
	  #bounds: #(#Rectangle 12 22 312 322)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#HierarchicalListViewSpec
	      #name: 'HierarchicalListView1'
	      #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
	      #tabable: true
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #miniScrollerHorizontal: true
	      #miniScrollerVertical: true
	      #listModel: #list
	      #highlightMode: #label
	      #doubleClickSelector: #doubleClickedPressed:
	      #indicatorSelector: #indicatorPressed:
	    )
	   )
         
	)
      )
! !

!GUIDemoNewHierarchicalTree3 methodsFor:'actions'!

doubleClickedPressed:anIndex
    |item|

    item := self list at:anIndex ifAbsent:nil.

    item notNil ifTrue:[
	item handleDoubleClick
    ].        
!

indicatorPressed:anIndex
    |item|

    item := self list at:anIndex ifAbsent:nil.

    item notNil ifTrue:[
	item toggleExpand
    ].
! !

!GUIDemoNewHierarchicalTree3 methodsFor:'aspects'!

list
    list isNil ifTrue:[
	list := HierarchicalList new.
	list root:(Item new).
    ].
    ^ list
! !

!GUIDemoNewHierarchicalTree3::Item methodsFor:'actions'!

handleDoubleClick
    "called by my application to handle the double click
    "
    children isNil ifTrue:[
	children := OrderedCollection new.
	label    := 'before children creation'.
	self changed.
    ] ifFalse:[
	children isEmpty ifTrue:[
	    label      := 'children creation'.
	    isExpanded := true.
	    self changed.
	].
	self add:(self class new).
    ].
! !

!GUIDemoNewHierarchicalTree3::Item methodsFor:'initialization'!

initialize
    super initialize.
    label := 'Change Icon'
! !

!GUIDemoNewHierarchicalTree3::Item methodsFor:'protocol accessing'!

children
    "returns my children or nil
       -> see HierarchicalItem category protocol
    "
    ^ children
!

icon
    "returns my icon dependent on the current state of children
       -> see HierarchicalItem category protocol
    "
    children isNil   ifTrue:[ ^ Icon newIcon ].
    children isEmpty ifTrue:[ ^ Icon copyIcon ].
  ^ Icon pasteIcon
!

label
    "returns my printable label
       -> see HierarchicalItem category protocol
    "
    ^ label
!

middleButtonMenu
    "returns my middlebutton menu
       -> see HierarchicalItem category protocol
    "
    |menu item|

    item := MenuItem label:'Delete' value:[ self remove ].

    "/ should not delete the root item
    self isRootItem ifTrue:[ item enabled:false ].

    menu := Menu new.
    menu addItem:item.
  ^ menu
! !

!GUIDemoNewHierarchicalTree3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoNewHierarchicalTree3.st,v 1.1 2002-10-19 11:41:20 ca Exp $'
! !
