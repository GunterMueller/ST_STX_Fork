"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserNavigator subclass:#SystemNavigator
	instanceVariableNames:'hierarchy viewCategory hierarchyClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Navigator'
!

SystemNavigator comment:'SystemNavigator is the navigator used by the browser to browse the whole system (or something that has multiple categories, classes, etc.).

Instance Variables:
	hierarchy       <SelectionInList on: Behavior>  the hierarchy list of classes
	hierarchyClass  <Behavior>      which class is the hierarchy list for, it is displayed in bold
	viewCategory    <ValueHolder on: Symbol>        are we viewing a category or hierarchy?'
!


!SystemNavigator class methodsFor:'interface specs'!

verticalWindowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        "st/x's groubBoxes are incompatible to VW"
        RBParser isSmalltalkX ifTrue:[
            ^ self verticalWindowSpecSTX
        ].
        ^ self verticalWindowSpecVW
!

verticalWindowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SystemNavigator andSelector:#verticalWindowSpec
     SystemNavigator new openInterface:#verticalWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #verticalWindowSpec
        #window: 
       #(#WindowSpec
          #label: 'Navigator'
          #name: 'Navigator'
          #bounds: #(#Rectangle 8 53 196 534)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#RadioButtonSpec
              #label: 'category'
              #name: #viewCategory
              #layout: #(#LayoutFrame 3 0 3 0 0 0.5 22 0)
              #model: #viewCategory
              #select: true
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedViewCategory
              )
            )
           #(#RadioButtonSpec
              #label: 'hierarchy'
              #name: 'RadioButton1'
              #layout: #(#LayoutFrame 2 0.5 3 0 -3 1 22 0)
              #model: #viewCategory
              #select: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedViewCategory
              )
            )
           #(#SequenceViewSpec
              #name: #hierarchy
              #layout: #(#LayoutFrame 2 0 25 0 -2 1 -25 0.5)
              #flags: 29
              #model: #hierarchy
              #menu: #hierarchyMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedClass
                #doubleClickSelector: #updateCategoryList
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doClassDrag:
                #dragOkSelector #classWantToDrag:
              )
            )
           #(#SequenceViewSpec
              #name: #categoryList
              #layout: #(#LayoutFrame 2 0 25 0 -2 1 -1 0.25)
              #model: #categoryList
              #menu: #categoryMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedCategory
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doCategoryDrag:
                #dragEnterSelector #categoryDragEnter:
                #dragOverSelector #categoryDragOver:
                #dragOkSelector #categoryWantToDrag:
                #dragExitSelector #dragLeave:
                #dropSelector #categoryDrop:
              )
            )
           #(#SequenceViewSpec
              #name: #classList
              #layout: #(#LayoutFrame 2 0 1 0.25 -2 1 -25 0.5)
              #model: #classList
              #menu: #classMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedClass
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doClassDrag:
                #dragEnterSelector #classDragEnter:
                #dragOverSelector #classDragOver:
                #dragOkSelector #classWantToDrag:
                #dragExitSelector #dragLeave:
                #dropSelector #classDrop:
              )
            )
           #(#RadioButtonSpec
              #label: 'instance'
              #name: #instance
              #layout: #(#LayoutFrame 3 0 -22 0.5 0 0.5 -1 0.5)
              #model: #meta
              #select: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedMeta
                #requestValueChangeSelector: #changeRequest
              )
            )
           #(#RadioButtonSpec
              #label: 'class'
              #name: #class
              #layout: #(#LayoutFrame 2 0.5 -22 0.5 -22 1 -1 0.5)
              #model: #meta
              #select: true
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedMeta
                #requestValueChangeSelector: #changeRequest
              )
            )
           #(#SequenceViewSpec
              #name: #protocolList
              #layout: #(#LayoutFrame 2 0 1 0.5 -2 1 -1 0.75)
              #model: #protocolList
              #menu: #protocolMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedProtocol
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doProtocolDrag:
                #dragEnterSelector #protocolDragEnter:
                #dragOverSelector #protocolDragOver:
                #dragOkSelector #protocolWantToDrag:
                #dragExitSelector #dragLeave:
                #dropSelector #protocolDrop:
              )
            )
           #(#SequenceViewSpec
              #name: #selectorList
              #layout: #(#LayoutFrame 2 0 1 0.75 -2 1 -2 1)
              #model: #selectorList
              #menu: #selectorMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedSelector
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doSelectorDrag:
                #dragOkSelector #selectorWantToDrag:
              )
            )
           #(#ActionButtonSpec
              #label: '^'
              #name: #clearToClass
              #layout: #(#LayoutFrame -22 1 -23 0.5 -2 1 -3 0.5)
              #model: #clearToClass
            )
           )
         
        )
      )
!

verticalWindowSpecVW
        "UIPainter new openOnClass: self andSelector: #verticalWindowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Navigator' 
                        #bounds: #(#Rectangle 436 380 624 861 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 3 0 3 0 0 0.5 22 0 ) 
                                        #name: #viewCategory 
                                        #model: #viewCategory 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedViewCategory ) 
                                        #label: 'category' 
                                        #select: true ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0.5 3 0 -3 1 22 0 ) 
                                        #name: #viewCategory 
                                        #model: #viewCategory 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedViewCategory ) 
                                        #label: 'hierarchy' 
                                        #select: false ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragStartSelector 
                                                #doClassDrag: #dragOkSelector 
                                                #classWantToDrag: ) 
                                        #layout: #(#LayoutFrame 2 0 25 0 -2 1 -25 0.5 ) 
                                        #name: #hierarchy 
                                        #flags: 29 
                                        #model: #hierarchy 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedClass 
                                                #doubleClickSelector: #updateCategoryList 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #hierarchyMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #categoryWantToDrag: #dragEnterSelector 
                                                #categoryDragEnter: #dragOverSelector 
                                                #categoryDragOver: #dragStartSelector 
                                                #doCategoryDrag: #dropSelector 
                                                #categoryDrop: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 2 0 25 0 -2 1 -1 0.25 ) 
                                        #name: #categoryList 
                                        #model: #categoryList 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedCategory 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #categoryMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #classWantToDrag: #dragEnterSelector 
                                                #classDragEnter: #dragOverSelector 
                                                #classDragOver: #dragStartSelector 
                                                #doClassDrag: #dropSelector 
                                                #classDrop: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 2 0 1 0.25 -2 1 -25 0.5 ) 
                                        #name: #classList 
                                        #model: #classList 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedClass 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #classMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 3 0 -22 0.5 0 0.5 -1 0.5 ) 
                                        #name: #instance 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'instance' 
                                        #select: false ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0.5 -22 0.5 -22 1 -1 0.5 ) 
                                        #name: #class 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'class' 
                                        #select: true ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #protocolWantToDrag: #dragEnterSelector 
                                                #protocolDragEnter: #dragOverSelector 
                                                #protocolDragOver: #dragStartSelector 
                                                #doProtocolDrag: #dropSelector 
                                                #protocolDrop: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 2 0 1 0.5 -2 1 -1 0.75 ) 
                                        #name: #protocolList 
                                        #model: #protocolList 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedProtocol 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #protocolMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragStartSelector 
                                                #doSelectorDrag: #dragOkSelector 
                                                #selectorWantToDrag: ) 
                                        #layout: #(#LayoutFrame 2 0 1 0.75 -2 1 -2 1 ) 
                                        #name: #selectorList 
                                        #model: #selectorList 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedSelector 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #selectorMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#GroupBoxSpec 
                                        #layout: #(#LayoutFrame 2 0 2 0 -2 1 23 0 ) ) 
                                #(#GroupBoxSpec 
                                        #layout: #(#LayoutFrame 2 0 -23 0.5 -2 1 -1 0.5 ) ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -22 1 -23 0.5 -2 1 -3 0.5 ) 
                                        #name: #clearToClass 
                                        #model: #clearToClass 
                                        #label: '^' ) ) ) )
!

windowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        "st/x's groubBoxes are incompatible to VW"
        RBParser isSmalltalkX ifTrue:[
            ^ self windowSpecSTX
        ].
        ^ self windowSpecVW
!

windowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SystemNavigator andSelector:#windowSpec
     SystemNavigator new openInterface:#windowSpec
     SystemNavigator open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'Navigator'
          #name: 'Navigator'
          #bounds: #(#Rectangle 1 65 589 216)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: #hierarchy
              #layout: #(#LayoutFrame 2 0 2 0 -1 0.5 -25 1)
              #flags: 29
              #model: #hierarchy
              #menu: #hierarchyMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedClass
                #doubleClickSelector: #updateCategoryList
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doClassDrag:
                #dragOkSelector #classWantToDrag:
              )
            )
           #(#SequenceViewSpec
              #name: #categoryList
              #layout: #(#LayoutFrame 2 0 2 0 -1 0.25 -25 1)
              #model: #categoryList
              #menu: #categoryMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedCategory
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doCategoryDrag:
                #dragEnterSelector #categoryDragEnter:
                #dragOverSelector #categoryDragOver:
                #dragOkSelector #categoryWantToDrag:
                #dragExitSelector #dragLeave:
                #dropSelector #categoryDrop:
              )
            )
           #(#RadioButtonSpec
              #label: 'category'
              #name: #viewCategory
              #layout: #(#LayoutFrame 3 0 -23 1 0 0.125 -3 1)
              #model: #viewCategory
              #select: true
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedViewCategory
              )
            )
           #(#RadioButtonSpec
              #label: 'hierarchy'
              #name: 'RadioButton1'
              #layout: #(#LayoutFrame 2 0.125 -23 1 -2 0.25 -3 1)
              #model: #viewCategory
              #select: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedViewCategory
              )
            )
           #(#SequenceViewSpec
              #name: #classList
              #layout: #(#LayoutFrame 1 0.25 2 0 -1 0.5 -25 1)
              #model: #classList
              #menu: #classMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedClass
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doClassDrag:
                #dragEnterSelector #classDragEnter:
                #dragOverSelector #classDragOver:
                #dragOkSelector #classWantToDrag:
                #dragExitSelector #dragLeave:
                #dropSelector #classDrop:
              )
            )
           #(#RadioButtonSpec
              #label: 'instance'
              #name: #instance
              #layout: #(#LayoutFrame 2 0.25 -23 1 0 0.375 -3 1)
              #model: #meta
              #select: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedMeta
                #requestValueChangeSelector: #changeRequest
              )
            )
           #(#RadioButtonSpec
              #label: 'class'
              #name: #class
              #layout: #(#LayoutFrame 2 0.375 -23 1 -22 0.5 -3 1)
              #model: #meta
              #select: true
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedMeta
                #requestValueChangeSelector: #changeRequest
              )
            )
           #(#SequenceViewSpec
              #name: #protocolList
              #layout: #(#LayoutFrame 1 0.5 2 0 -1 0.75 -2 1)
              #model: #protocolList
              #menu: #protocolMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedProtocol
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doProtocolDrag:
                #dragEnterSelector #protocolDragEnter:
                #dragOverSelector #protocolDragOver:
                #dragOkSelector #protocolWantToDrag:
                #dragExitSelector #dragLeave:
                #dropSelector #protocolDrop:
              )
            )
           #(#SequenceViewSpec
              #name: #selectorList
              #layout: #(#LayoutFrame 1 0.75 2 0 -2 1 -2 1)
              #model: #selectorList
              #menu: #selectorMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedSelector
                #requestValueChangeSelector: #changeRequest
              )
              #useModifierKeys: true
              #properties: 
             #(#PropertyListDictionary
                #dragStartSelector #doSelectorDrag:
                #dragOkSelector #selectorWantToDrag:
              )
            )
           #(#ActionButtonSpec
              #label: '^'
              #name: #clearToClass
              #layout: #(#LayoutFrame -22 0.5 -23 1 -2 0.5 -3 1)
              #model: #clearToClass
            )
           )
         
        )
      )
!

windowSpecVW
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Navigator' 
                        #bounds: #(#Rectangle 283 329 871 480 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragStartSelector 
                                                #doClassDrag: #dragOkSelector 
                                                #classWantToDrag: ) 
                                        #layout: #(#LayoutFrame 2 0 2 0 -1 0.5 -25 1 ) 
                                        #name: #hierarchy 
                                        #flags: 29 
                                        #model: #hierarchy 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedClass 
                                                #doubleClickSelector: #updateCategoryList 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #hierarchyMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#GroupBoxSpec 
                                        #layout: #(#LayoutFrame 2 0 -23 1 -1 0.25 -2 1 ) ) 
                                #(#GroupBoxSpec 
                                        #layout: #(#LayoutFrame 1 0.25 -23 1 -1 0.5 -2 1 ) ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #categoryWantToDrag: #dragEnterSelector 
                                                #categoryDragEnter: #dropSelector 
                                                #categoryDrop: #dragStartSelector 
                                                #doCategoryDrag: #dragOverSelector 
                                                #categoryDragOver: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 2 0 2 0 -1 0.25 -25 1 ) 
                                        #name: #categoryList 
                                        #model: #categoryList 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedCategory 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #categoryMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 3 0 -23 1 0 0.125 -3 1 ) 
                                        #name: #viewCategory 
                                        #model: #viewCategory 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedViewCategory ) 
                                        #label: 'category' 
                                        #select: true ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0.125 -23 1 -2 0.25 -3 1 ) 
                                        #name: #viewCategory 
                                        #model: #viewCategory 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedViewCategory ) 
                                        #label: 'hierarchy' 
                                        #select: false ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #classWantToDrag: #dragEnterSelector 
                                                #classDragEnter: #dropSelector 
                                                #classDrop: #dragStartSelector 
                                                #doClassDrag: #dragOverSelector 
                                                #classDragOver: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 1 0.25 2 0 -1 0.5 -25 1 ) 
                                        #name: #classList 
                                        #model: #classList 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedClass 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #classMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0.25 -23 1 0 0.375 -3 1 ) 
                                        #name: #instance 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'instance' 
                                        #select: false ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0.375 -23 1 -22 0.5 -3 1 ) 
                                        #name: #class 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'class' 
                                        #select: true ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #protocolWantToDrag: #dragEnterSelector 
                                                #protocolDragEnter: #dropSelector 
                                                #protocolDrop: #dragStartSelector 
                                                #doProtocolDrag: #dragOverSelector 
                                                #protocolDragOver: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 1 0.5 2 0 -1 0.75 -2 1 ) 
                                        #name: #protocolList 
                                        #model: #protocolList 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedProtocol 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #protocolMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragStartSelector 
                                                #doSelectorDrag: #dragOkSelector 
                                                #selectorWantToDrag: ) 
                                        #layout: #(#LayoutFrame 1 0.75 2 0 -2 1 -2 1 ) 
                                        #name: #selectorList 
                                        #model: #selectorList 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedSelector 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #menu: #selectorMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -22 0.5 -23 1 -2 0.5 -3 1 ) 
                                        #name: #clearToClass 
                                        #model: #clearToClass 
                                        #label: '^' ) ) ) )
! !

!SystemNavigator methodsFor:'accessing'!

beHierarchy
	self viewCategory value: false.
	self changedViewCategory
! !

!SystemNavigator methodsFor:'accessing-category'!

changedViewCategory
	self viewCategory value
		ifTrue:
			[self updateClassCategory.
			self showAll: #(#categoryList #classList).
			self hide: #hierarchy]
		ifFalse:
			[self updateHierarchy.
			self show: #hierarchy.
			self hideAll: #(#categoryList #classList)]
!

updateClassCategory
	| classes |
	hierarchyClass isNil ifTrue: [^self].
	hierarchyClass := nil.
	classes := self hierarchy selections collect: [:each | each name].
	classes isEmpty ifTrue: [^self newClassList: #()].
	self selectClasses: classes
		meta: self isMeta
		categories: #()
!

updateHierarchy
	| names |
	names := self classList selections.
	names isEmpty
		ifTrue: 
			[self updateHierarchyFor: #Object.
			self hierarchy selections: #().
			^self].
	self updateHierarchyFor: (names detect: [:each | true] ifNone: [nil])
! !

!SystemNavigator methodsFor:'accessing-class'!

classNames
	^self viewCategory value
		ifTrue: [super classNames]
		ifFalse: [self hierarchy selections collect: [:each | each name]]
!

newClassListNoUpdate: initialSelection 
	super newClassListNoUpdate: initialSelection.
	self isHierarchy ifTrue: [self updateHierarchy]
!

selectClass: aClass 
	| newClass |
	super selectClass: aClass.
	self isHierarchy ifFalse: [^self].
	newClass := aClass isMeta ifTrue: [aClass soleInstance] ifFalse: [aClass].
	self updateHierarchyFor: newClass name
! !

!SystemNavigator methodsFor:'aspects'!

hierarchy
        ^hierarchy isNil
                ifTrue: [hierarchy := RBMultiSelectionInList new]
                ifFalse: [hierarchy]
!

viewCategory
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^viewCategory isNil
		ifTrue:
			[viewCategory := nil asValue]
		ifFalse:
			[viewCategory]
! !

!SystemNavigator methodsFor:'category drag and drop'!

canAcceptDropInCategoryListFrom: aDC 
	^(super canAcceptDropInCategoryListFrom: aDC) 
		and: [self viewCategory value]
! !

!SystemNavigator methodsFor:'class drag and drop'!

canAcceptDropInClassListFrom: aDC 
	^(super canAcceptDropInClassListFrom: aDC) and: [self viewCategory value]
! !

!SystemNavigator methodsFor:'initialize-release'!

initialize
	super initialize.
	self viewCategory value: true
! !

!SystemNavigator methodsFor:'interface opening'!

postBuildWith: aBuilder 
        | block |
        super postBuildWith: aBuilder.
        self postBuildWidget: #hierarchy.
        self newCategoryList: #().
        block := 
                        [:view :index | 
                        | each string |
                        each := view sequence at: index.
                        string := each name.
                        each == hierarchyClass ifTrue: [string := string asText allBold].
                        RBParser isSmalltalkX ifTrue:[
                            LabelAndIcon new 
                                    string: string;
                                    offset: ((self numSuperclasses: each) * 10);
                                    yourself.
                        ] ifFalse:[
                            Label with: string
                                attributes: view textStyle
                                offset: ((self numSuperclasses: each) * 10) @ 0].
                        ].
        ((builder componentAt: #hierarchy) widget)
                visualBlock: (self createVisualBlockFrom: block);
                selectedVisualBlock: (self createSelectedVisualBlockFrom: block)
! !

!SystemNavigator methodsFor:'menu'!

hierarchyMenu
	^self classMenu
! !

!SystemNavigator methodsFor:'private'!

addSubclassesFor: aClass to: aList 
	(aClass subclasses asSortedCollection: [:a :b | a name < b name]) do: 
			[:each | 
			each isMeta ifFalse: 
					[aList add: each.
					self addSubclassesFor: each to: aList]]
!

getSpec: verticalBoolean 
	^verticalBoolean
		ifTrue: [self class verticalWindowSpec]
		ifFalse: [self class windowSpec]
!

numSuperclasses: aClass 
	| i class |
	i := 0.
	class := aClass.
	[(class := class superclass) isNil]
		whileFalse: [i := i + 1].
	^i
!

updateHierarchyFor: aClassName 
	| list class |
	class := Smalltalk at: aClassName ifAbsent: [Object].
	hierarchyClass := class.
	list := class withAllSuperclasses reverse.
	self addSubclassesFor: class to: list.
	(self hierarchy) list: list asList;
		selections: (Array with: class)
! !

!SystemNavigator methodsFor:'private-class'!

commonSuperclassOf: classCollection 
	classCollection isEmpty ifTrue: [^Object].
	^classCollection inject: classCollection first
		into: 
			[:root :each | 
			(self rootOf: root) == (self rootOf: each)
				ifTrue: [root commonSuperclass: each]
				ifFalse: [^nil]]
!

rootOf: aClass 
	| class |
	class := aClass.
	[class superclass isNil] whileFalse: [class := class superclass].
	^class
!

selectClasses: classNames meta: aBoolean categories: categoryNames 
	| classes rootClass |
	super selectClasses: classNames
		meta: aBoolean
		categories: categoryNames.
	self isHierarchy ifFalse: [^self].
	classes := classNames collect: [:each | Smalltalk at: each ifAbsent: [Object]].
	rootClass := self commonSuperclassOf: classes.
	rootClass isNil ifTrue: 
			[self viewCategory value: true.
			^self selectClasses: classNames
				meta: aBoolean
				categories: categoryNames].
	self meta: aBoolean.
	self updateHierarchyFor: rootClass name.
	self hierarchy selections: classes
! !

!SystemNavigator methodsFor:'testing'!

isHierarchy
	^self viewCategory value not
! !

!SystemNavigator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/SystemNavigator.st,v 1.12 2003-09-23 10:45:47 cg Exp $'
! !
