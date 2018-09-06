"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: CodingExamples_GUI }"

GUIDemoApplication subclass:#GUIDemoSelectionInListModelView
	instanceVariableNames:'list isEnabledHolder isVisibleHolder selectionHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI'
!


!GUIDemoSelectionInListModelView class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GUIDemoSelectionInListModelView andSelector:#windowSpec
     CodingExamples_GUI::GUIDemoSelectionInListModelView new openInterface:#windowSpec
     CodingExamples_GUI::GUIDemoSelectionInListModelView open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Sequenceable List'
          #name: 'Sequenceable List'
          #min: #(#Point 10 10)
          #max: #(#Point 1024 768)
          #bounds: #(#Rectangle 214 254 551 540)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#LabelSpec
              #name: 'Label1'
              #layout: #(#LayoutFrame 0 0.0 0 0 133 0 22 0)
              #level: 1
              #translateLabel: true
              #labelChannel: #selectionHolder
            )
           #(#SelectionInListModelViewSpec
              #name: 'SelectionInListModelView1'
              #layout: #(#LayoutFrame 0 0.0 22 0.0 133 0 0 1.0)
              #visibilityChannel: #isVisibleHolder
              #enableChannel: #isEnabledHolder
              #model: #selectionHolder
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #miniScrollerVertical: false
              #listModel: #list
              #useIndex: false
              #highlightMode: #line
              #doubleClickSelector: #doubleClickedPressed:
              #valueChangeSelector: #selectionChanged:
              #selectConditionSelector: #isSelectable:
              #postBuildCallback: #postBuildList:
              #properties: 
             #(#PropertyListDictionary
                #dragArgument: nil
                #dropObjectSelector: #dropObjects:
                #dropArgument: nil
                #canDropSelector: #canDrop:
                #dropSelector: #drop:
              )
            )
           #(#CheckBoxSpec
              #label: 'Enabled'
              #name: 'CheckBox2'
              #layout: #(#Point 136 9)
              #model: #isEnabledHolder
              #translateLabel: true
            )
           #(#CheckBoxSpec
              #label: 'Visible'
              #name: 'CheckBox1'
              #layout: #(#Point 136 41)
              #model: #isVisibleHolder
              #translateLabel: true
            )
           )
         
        )
      )
! !

!GUIDemoSelectionInListModelView methodsFor:'actions'!

doubleClickedPressed:anIndex
    self showCR:'#doubleClickedPressed: ', anIndex printString.
!

selectionChanged:anIndex
    self showCR:'#selectionChanged: ', anIndex printString.
! !

!GUIDemoSelectionInListModelView methodsFor:'aspects'!

isEnabledHolder
    isEnabledHolder isNil ifTrue:[
        isEnabledHolder := true asValue.
    ].
    ^ isEnabledHolder.
!

isVisibleHolder
    isVisibleHolder isNil ifTrue:[
        isVisibleHolder := true asValue.
    ].
    ^ isVisibleHolder.
!

list
    list isNil ifTrue:[
        list := #( foo bar baz ) asList
    ].
    ^ list
!

selectionHolder
    selectionHolder isNil ifTrue:[
        selectionHolder := nil asValue.
    ].
    ^ selectionHolder.
! !

!GUIDemoSelectionInListModelView methodsFor:'drag & drop'!

canDrop:aDropContext
    "returns true if the objects are dropable
    "
    aDropContext dropObjects do:[:el|
        el isTextObject ifFalse:[ ^ false ]
    ].
    ^ true
!

drop:aDropContext
    "drop objects
    "
    self showCR:'#drop:'.

    aDropContext dropObjects do:[:el|
        self list add:(el theObject).
    ].
    ^ true
!

dropObjects:DropSource
    "drop objects
    "
    |object|

    self showCR:'#dropObjects:'.

    object := self selectionHolder value.

    object isNil ifTrue:[
        ^ nil
    ].
    ^ Array with:(DropObject newText:object)
! !

!GUIDemoSelectionInListModelView methodsFor:'queries'!

isSelectable:anIndex
    self showCR:'#isSelectable: ', anIndex printString.
  ^ true
! !

!GUIDemoSelectionInListModelView methodsFor:'startup & release'!

postBuildList:aView
    self showCR:'#postBuildList:'.
! !

!GUIDemoSelectionInListModelView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/GUIDemoSelectionInListModelView.st,v 1.3 2002-10-19 08:34:28 ca Exp $'
! !
