"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Navigator subclass:#BrowserNavigator
	instanceVariableNames:''
	classVariableNames:'LastMoveMethodProtocol'
	poolDictionaries:''
	category:'Refactory-Navigator'
!

BrowserNavigator comment:'BrowserNavigator is the part of the browser that selects which methods to view. It is normally at the top of the browser. From the navigator you select the categories, classes, protocols, and selectors that you want to view.

Instance variables:
	browser <RefactoringBrowser>    the browser that the navigator is in

Class Variables:
	LastMoveMethodProtocol  <String | nil>  the last move location entered by the user'
!


!BrowserNavigator class methodsFor:'instance creation'!

forEnvironment: aBrowserEnvironment 
	^(self new)
		environment: aBrowserEnvironment;
		initializeViews;
		yourself
!

on: aBrowser
	^self new on: aBrowser
! !

!BrowserNavigator class methodsFor:'class initialization'!

initialize
	"self initialize"

	LastMoveMethodProtocol := ''
! !

!BrowserNavigator class methodsFor:'interface specs'!

categoryWindowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        "st/x's groubBoxes are incompatible to VW"
        RBParser isSmalltalkX ifTrue:[
            ^ self categoryWindowSpecSTX
        ].
        ^ self categoryWindowSpecVW
!

categoryWindowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BrowserNavigator andSelector:#categoryWindowSpec
     BrowserNavigator new openInterface:#categoryWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #categoryWindowSpec
        #window: 
       #(#WindowSpec
          #label: 'Navigator'
          #name: 'Navigator'
          #bounds: #(#Rectangle 439 40 1027 191)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: #classList
              #layout: #(#LayoutFrame 2 0 27 0 -1 0.333333 -25 1)
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
           #(#SequenceViewSpec
              #name: #protocolList
              #layout: #(#LayoutFrame 1 0.333333 2 0 -1 0.666666 -2 1)
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
              #layout: #(#LayoutFrame 1 0.666666 2 0 -2 1 -2 1)
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
           #(#RadioButtonSpec
              #label: 'instance'
              #name: #instance
              #layout: #(#LayoutFrame 3 0 -23 1 0 0.166667 -3 1)
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
              #layout: #(#LayoutFrame 2 0.166667 -23 1 -22 0.333333 -3 1)
              #model: #meta
              #select: true
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedMeta
                #requestValueChangeSelector: #changeRequest
              )
            )
           #(#InputFieldSpec
              #name: #categoryHolder
              #layout: #(#LayoutFrame 2 0 2 0 -1 0.333333 25 0)
              #model: #categoryHolder
              #menu: #categoryMenu
              #isReadOnly: true
              #type: #string
              #acceptOnPointerLeave: false
            )
           #(#ActionButtonSpec
              #label: '^'
              #name: #clearToClass
              #layout: #(#LayoutFrame -22 0.333333 -23 1 -2 0.333333 -3 1)
              #model: #clearToClass
            )
           )
         
        )
      )
!

categoryWindowSpecVW
        "UIPainter new openOnClass: self andSelector: #categoryWindowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Navigator' 
                        #bounds: #(#Rectangle 237 591 825 742 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #classWantToDrag: #dragEnterSelector 
                                                #classDragEnter: #dragOverSelector 
                                                #classDragOver: #dragStartSelector 
                                                #doClassDrag: #dropSelector 
                                                #classDrop: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 2 0 27 0 -1 0.333333 -25 1 ) 
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
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #protocolWantToDrag: #dragEnterSelector 
                                                #protocolDragEnter: #dragOverSelector 
                                                #protocolDragOver: #dragStartSelector 
                                                #doProtocolDrag: #dropSelector 
                                                #protocolDrop: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 1 0.333333 2 0 -1 0.666666 -2 1 ) 
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
                                        #layout: #(#LayoutFrame 1 0.666666 2 0 -2 1 -2 1 ) 
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
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 3 0 -23 1 0 0.166667 -3 1 ) 
                                        #name: #instance 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'instance' 
                                        #select: false ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0.166667 -23 1 -22 0.333333 -3 1 ) 
                                        #name: #class 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'class' 
                                        #select: true ) 
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 2 0 2 0 -1 0.333333 25 0 ) 
                                        #name: #categoryHolder 
                                        #model: #categoryHolder 
                                        #menu: #categoryMenu 
                                        #isReadOnly: true 
                                        #type: #string ) 
                                #(#GroupBoxSpec 
                                        #layout: #(#LayoutFrame 2 0 -23 1 -1 0.333333 -2 1 ) ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -22 0.333333 -23 1 -2 0.333333 -3 1 ) 
                                        #name: #clearToClass 
                                        #model: #clearToClass 
                                        #label: '^' ) ) ) )
!

classWindowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        "st/x's groubBoxes are incompatible to VW"
        RBParser isSmalltalkX ifTrue:[
            ^ self classWindowSpecSTX
        ].
        ^ self classWindowSpecVW
!

classWindowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BrowserNavigator andSelector:#classWindowSpec
     BrowserNavigator new openInterface:#classWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #classWindowSpec
        #window: 
       #(#WindowSpec
          #label: 'Navigator'
          #name: 'Navigator'
          #bounds: #(#Rectangle 25 739 613 890)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#DividerSpec
              #name: 'Separator1'
              #layout: #(#LayoutFrame 0 0 52 0 0 1 53 0)
            )
           #(#InputFieldSpec
              #name: #categoryHolder
              #layout: #(#LayoutFrame 2 0 2 0 -1 0.5 25 0)
              #model: #categoryHolder
              #menu: #categoryMenu
              #isReadOnly: true
              #type: #string
              #acceptOnPointerLeave: false
            )
           #(#InputFieldSpec
              #name: #classHolder
              #layout: #(#LayoutFrame 1 0.5 2 0 -2 1 25 0)
              #model: #classHolder
              #menu: #classMenu
              #isReadOnly: true
              #acceptOnPointerLeave: false
            )
           #(#RadioButtonSpec
              #label: 'instance'
              #name: #instance
              #layout: #(#LayoutFrame 2 0.5 28 0 -1 0.75 49 0)
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
              #layout: #(#LayoutFrame 1 0.75 28 0 -22 1 49 0)
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
              #layout: #(#LayoutFrame 2 0 54 0 -1 0.5 -2 1)
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
              #layout: #(#LayoutFrame 1 0.5 54 0 -2 1 -2 1)
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
              #layout: #(#LayoutFrame -22 1 28 0 -2 1 49 0)
              #model: #clearToClass
            )
           )
         
        )
      )
!

classWindowSpecVW
        "UIPainter new openOnClass: self andSelector: #classWindowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Navigator' 
                        #bounds: #(#Rectangle 219 330 807 481 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#DividerSpec 
                                        #layout: #(#LayoutFrame 0 0 52 0 0 1 53 0 ) ) 
                                #(#GroupBoxSpec 
                                        #layout: #(#LayoutFrame 1 0.5 27 0 -2 1 50 0 ) ) 
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 2 0 2 0 -1 0.5 25 0 ) 
                                        #name: #categoryHolder 
                                        #model: #categoryHolder 
                                        #menu: #categoryMenu 
                                        #isReadOnly: true 
                                        #type: #string ) 
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 1 0.5 2 0 -2 1 25 0 ) 
                                        #name: #classHolder 
                                        #model: #classHolder 
                                        #menu: #classMenu 
                                        #isReadOnly: true ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0.5 28 0 -1 0.75 49 0 ) 
                                        #name: #instance 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'instance' 
                                        #select: false ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 1 0.75 28 0 -22 1 49 0 ) 
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
                                        #layout: #(#LayoutFrame 2 0 54 0 -1 0.5 -2 1 ) 
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
                                        #layout: #(#LayoutFrame 1 0.5 54 0 -2 1 -2 1 ) 
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
                                        #layout: #(#LayoutFrame -22 1 28 0 -2 1 49 0 ) 
                                        #name: #clearToClass 
                                        #model: #clearToClass 
                                        #label: '^' 
                                        #isDefault: false ) ) ) )
!

protocolWindowSpec
	"UIPainter new openOnClass: self andSelector: #protocolWindowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Navigator' 
			#bounds: #(#Rectangle 607 382 1195 533 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 2 0 -1 0.5 25 0 ) 
					#name: #categoryHolder 
					#model: #categoryHolder 
					#menu: #categoryMenu 
					#isReadOnly: true 
					#type: #string ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 27 0 -1 0.5 52 0 ) 
					#name: #classHolder 
					#model: #classNameHolder 
					#menu: #classMenu 
					#isReadOnly: true 
					#type: #object ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 54 0 -1 0.5 79 0 ) 
					#name: #protocolHolder 
					#model: #protocolHolder 
					#menu: #protocolMenu 
					#isReadOnly: true ) 
				#(#SequenceViewSpec 
					#properties: 
					#(#PropertyListDictionary #dragStartSelector 
						#doSelectorDrag: #dragOkSelector 
						#selectorWantToDrag: ) 
					#layout: #(#LayoutFrame 1 0.5 2 0 -2 1 -2 1 ) 
					#name: #selectorList 
					#model: #selectorList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedSelector 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #selectorMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) ) ) )
!

selectorWindowSpec
	"UIPainter new openOnClass: self andSelector: #selectorWindowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Navigator' 
			#bounds: #(#Rectangle 226 306 814 457 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 2 0 -2 1 -1 0.25 ) 
					#name: #categoryHolder 
					#model: #categoryHolder 
					#menu: #categoryMenu 
					#isReadOnly: true 
					#type: #string ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 1 0.25 -2 1 -1 0.5 ) 
					#name: #classHolder 
					#model: #classNameHolder 
					#menu: #classMenu 
					#isReadOnly: true 
					#type: #object ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 1 0.5 -2 1 -1 0.75 ) 
					#name: #protocolHolder 
					#model: #protocolHolder 
					#menu: #protocolMenu 
					#isReadOnly: true ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 1 0.75 -2 1 -2 1 ) 
					#name: #selectorHolder 
					#model: #selectorHolder 
					#menu: #selectorMenu 
					#isReadOnly: true ) ) ) )
!

verticalCategoryWindowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        "st/x's groubBoxes are incompatible to VW"
        RBParser isSmalltalkX ifTrue:[
            ^ self verticalCategoryWindowSpecSTX
        ].
        ^ self verticalCategoryWindowSpecVW
!

verticalCategoryWindowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BrowserNavigator andSelector:#verticalCategoryWindowSpec
     BrowserNavigator new openInterface:#verticalCategoryWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #verticalCategoryWindowSpec
        #window: 
       #(#WindowSpec
          #label: 'Navigator'
          #name: 'Navigator'
          #min: #(#Point 40 20)
          #bounds: #(#Rectangle 218 175 437 655)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: #classList
              #layout: #(#LayoutFrame 2 0 27 0 -2 1 -25 0.333333)
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
           #(#SequenceViewSpec
              #name: #protocolList
              #layout: #(#LayoutFrame 2 0 1 0.333333 -2 1 -1 0.666666)
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
              #layout: #(#LayoutFrame 2 0 1 0.666666 -2 1 -2 1)
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
           #(#RadioButtonSpec
              #label: 'instance'
              #name: #instance
              #layout: #(#LayoutFrame 3 0 -23 0.333333 0 0.5 -2 0.333333)
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
              #layout: #(#LayoutFrame 2 0.5 -23 0.333333 -22 1 -2 0.333333)
              #model: #meta
              #select: true
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #changedMeta
                #requestValueChangeSelector: #changeRequest
              )
            )
           #(#InputFieldSpec
              #name: #categoryHolder
              #layout: #(#LayoutFrame 2 0 2 0 -2 1 25 0)
              #model: #categoryHolder
              #menu: #categoryMenu
              #isReadOnly: true
              #type: #string
              #acceptOnPointerLeave: false
            )
           #(#ActionButtonSpec
              #label: '^'
              #name: #clearToClass
              #layout: #(#LayoutFrame -22 1 -23 0.333333 -2 1 -3 0.333333)
              #model: #clearToClass
            )
           )
         
        )
      )
!

verticalCategoryWindowSpecVW
        "UIPainter new openOnClass: self andSelector: #verticalCategoryWindowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Navigator' 
                        #min: #(#Point 40 20 ) 
                        #bounds: #(#Rectangle 312 318 531 798 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #classWantToDrag: #dragEnterSelector 
                                                #classDragEnter: #dragOverSelector 
                                                #classDragOver: #dragStartSelector 
                                                #doClassDrag: #dropSelector 
                                                #classDrop: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 2 0 27 0 -2 1 -25 0.333333 ) 
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
                                #(#SequenceViewSpec 
                                        #properties: 
                                        #(#PropertyListDictionary #dragOkSelector 
                                                #protocolWantToDrag: #dragEnterSelector 
                                                #protocolDragEnter: #dragOverSelector 
                                                #protocolDragOver: #dragStartSelector 
                                                #doProtocolDrag: #dropSelector 
                                                #protocolDrop: #dragExitSelector 
                                                #dragLeave: ) 
                                        #layout: #(#LayoutFrame 2 0 1 0.333333 -2 1 -1 0.666666 ) 
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
                                        #layout: #(#LayoutFrame 2 0 1 0.666666 -2 1 -2 1 ) 
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
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 3 0 -23 0.333333 0 0.5 -2 0.333333 ) 
                                        #name: #instance 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'instance' 
                                        #select: false ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0.5 -23 0.333333 -22 1 -2 0.333333 ) 
                                        #name: #class 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'class' 
                                        #select: true ) 
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 2 0 2 0 -2 1 25 0 ) 
                                        #name: #categoryHolder 
                                        #model: #categoryHolder 
                                        #menu: #categoryMenu 
                                        #isReadOnly: true 
                                        #type: #string ) 
                                #(#GroupBoxSpec 
                                        #layout: #(#LayoutFrame 2 0 -23 0.333333 -2 1 -1 0.333333 ) ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -22 1 -23 0.333333 -2 1 -3 0.333333 ) 
                                        #name: #clearToClass 
                                        #model: #clearToClass 
                                        #label: '^' ) ) ) )
!

verticalClassWindowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        "st/x's groubBoxes are incompatible to VW"
        RBParser isSmalltalkX ifTrue:[
            ^ self verticalClassWindowSpecSTX
        ].
        ^ self verticalClassWindowSpecVW
!

verticalClassWindowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:BrowserNavigator andSelector:#verticalClassWindowSpec
     BrowserNavigator new openInterface:#verticalClassWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #verticalClassWindowSpec
        #window: 
       #(#WindowSpec
          #label: 'Navigator'
          #name: 'Navigator'
          #min: #(#Point 40 20)
          #bounds: #(#Rectangle 218 175 438 655)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#InputFieldSpec
              #name: #categoryHolder
              #layout: #(#LayoutFrame 2 0 2 0 -2 1 25 0)
              #model: #categoryHolder
              #menu: #categoryMenu
              #isReadOnly: true
              #type: #string
              #acceptOnPointerLeave: false
            )
           #(#InputFieldSpec
              #name: #classHolder
              #layout: #(#LayoutFrame 2 0 27 0 -2 1 52 0)
              #model: #classHolder
              #menu: #classMenu
              #isReadOnly: true
              #acceptOnPointerLeave: false
            )
           #(#RadioButtonSpec
              #label: 'instance'
              #name: #instance
              #layout: #(#LayoutFrame 2 0 55 0 -1 0.5 77 0)
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
              #layout: #(#LayoutFrame 1 0.5 55 0 -22 1 77 0)
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
              #layout: #(#LayoutFrame 2 0 80 0 -2 1 39 0.5)
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
              #layout: #(#LayoutFrame 2 0 41 0.5 -2 1 -2 1)
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
              #layout: #(#LayoutFrame -22 1 55 0 -2 1 77 0)
              #model: #clearToClass
            )
           )
         
        )
      )
!

verticalClassWindowSpecVW
        "UIPainter new openOnClass: self andSelector: #verticalClassWindowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Navigator' 
                        #min: #(#Point 40 20 ) 
                        #bounds: #(#Rectangle 326 286 546 766 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 2 0 2 0 -2 1 25 0 ) 
                                        #name: #categoryHolder 
                                        #model: #categoryHolder 
                                        #menu: #categoryMenu 
                                        #isReadOnly: true 
                                        #type: #string ) 
                                #(#InputFieldSpec 
                                        #layout: #(#LayoutFrame 2 0 27 0 -2 1 52 0 ) 
                                        #name: #classHolder 
                                        #model: #classHolder 
                                        #menu: #classMenu 
                                        #isReadOnly: true ) 
                                #(#GroupBoxSpec 
                                        #layout: #(#LayoutFrame 2 0 54 0 -2 1 78 0 ) ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 2 0 55 0 -1 0.5 77 0 ) 
                                        #name: #instance 
                                        #model: #meta 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #changedMeta 
                                                #requestValueChangeSelector: #changeRequest ) 
                                        #label: 'instance' 
                                        #select: false ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#LayoutFrame 1 0.5 55 0 -22 1 77 0 ) 
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
                                        #layout: #(#LayoutFrame 2 0 80 0 -2 1 39 0.5 ) 
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
                                        #layout: #(#LayoutFrame 2 0 41 0.5 -2 1 -2 1 ) 
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
                                        #layout: #(#LayoutFrame -22 1 55 0 -2 1 77 0 ) 
                                        #name: #clearToClass 
                                        #model: #clearToClass 
                                        #label: '^' ) ) ) )
!

verticalProtocolWindowSpec
	"UIPainter new openOnClass: self andSelector: #verticalProtocolWindowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Navigator' 
			#min: #(#Point 40 20 ) 
			#bounds: #(#Rectangle 766 345 964 725 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 2 0 -2 1 25 0 ) 
					#name: #categoryHolder 
					#model: #categoryHolder 
					#menu: #categoryMenu 
					#isReadOnly: true 
					#type: #string ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 27 0 -2 1 52 0 ) 
					#name: #classHolder 
					#model: #classNameHolder 
					#menu: #classMenu 
					#isReadOnly: true 
					#type: #object ) 
				#(#InputFieldSpec 
					#layout: #(#LayoutFrame 2 0 54 0 -2 1 79 0 ) 
					#name: #protocolHolder 
					#model: #protocolHolder 
					#menu: #protocolMenu 
					#isReadOnly: true ) 
				#(#SequenceViewSpec 
					#properties: 
					#(#PropertyListDictionary #dragStartSelector 
						#doSelectorDrag: #dragOkSelector 
						#selectorWantToDrag: ) 
					#layout: #(#LayoutFrame 2 0 81 0 -2 1 -2 1 ) 
					#name: #selectorList 
					#model: #selectorList 
					#callbacksSpec: 
					#(#UIEventCallbackSubSpec 
						#valueChangeSelector: #changedSelector 
						#requestValueChangeSelector: #changeRequest ) 
					#menu: #selectorMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) ) ) )
!

verticalSelectorWindowSpec
	^self selectorWindowSpec
! !

!BrowserNavigator class methodsFor:'resources'!

categoryMenu
	"UIMenuEditor new openOnClass: self andSelector: #categoryMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem
				#label: 'file out as...'
				#accessCharacterPosition: 6 )
			#(#MenuItem
				#label: 'hardcopy'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'spawn'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'add...'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'rename as...'
				#accessCharacterPosition: 3 )
			#(#MenuItem
				#label: 'remove...'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'update'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'find class...'
				#accessCharacterPosition: 1 ) ) #(3 3 1 1 ) #(#fileOutCategory #hardcopyCategory #spawnCategory #addCategory #renameCategory #removeCategory #updateCategoryList #findClass ) ) decodeAsLiteralArray
!

classMenu
	"MenuEditor new openOnClass: self andSelector: #classMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'file &out as...' 
				#value: #fileOutClass ) 
			#(#MenuItem 
				#rawLabel: '&hardcopy' 
				#value: #printOutClass ) 
			#(#MenuItem 
				#rawLabel: '&spawn' 
				#value: #spawnClass ) 
			#(#MenuItem 
				#rawLabel: 'spawn &hierarchy...' 
				#value: #spawnHierarchy ) 
			#(#MenuItem 
				#rawLabel: '&class' 
				#submenu: #(#Menu #(
						#(#MenuItem 
							#rawLabel: 're&ferences...' 
							#value: #classRefs ) 
						#(#MenuItem 
							#rawLabel: '&create subclass...' 
							#value: #createSubclass ) 
						#(#MenuItem 
							#rawLabel: 're&name as...' 
							#value: #renameClass ) 
						#(#MenuItem 
							#rawLabel: '&remove...' 
							#value: #removeClass ) 
						#(#MenuItem 
							#rawLabel: '&safe remove' 
							#value: #removeClassSafe ) 
						#(#MenuItem 
							#rawLabel: '&move to...' 
							#value: #changeClassCategory ) 
						#(#MenuItem 
							#rawLabel: '&other' 
							#submenu: #(#Menu #(
									#(#MenuItem 
										#rawLabel: '&convert to sibling' 
										#nameKey: #convertToSibling 
										#value: #convertToSibling ) 
									#(#MenuItem 
										#rawLabel: '&inspect all instances...' 
										#value: #inspectAllInstances ) 
									#(#MenuItem 
										#rawLabel: 'find &reference path to an instance...' 
										#value: #findReferencePathToInstance ) 
									#(#MenuItem 
										#rawLabel: 'find all reference path&s to an instance...' 
										#value: #findAllReferencesToInstances ) 
									#(#MenuItem 
										#rawLabel: 'check &protocols...' 
										#value: #checkProtocols ) ) #(1 4 ) nil ) ) ) #(1 4 1 1 ) nil ) ) 
			#(#MenuItem 
				#rawLabel: '&instance variables' 
				#submenu: #(#Menu #(
						#(#MenuItem 
							#rawLabel: 're&ferences...' 
							#value: #instVarRefs ) 
						#(#MenuItem 
							#rawLabel: 'readers...' 
							#nameKey: #readers 
							#value: #instVarReaders ) 
						#(#MenuItem 
							#rawLabel: 'writers...' 
							#nameKey: #writers 
							#value: #instVarWriters ) 
						#(#MenuItem 
							#rawLabel: '&add...' 
							#value: #addInstVar ) 
						#(#MenuItem 
							#rawLabel: 're&name as...' 
							#value: #renameInstVar ) 
						#(#MenuItem 
							#rawLabel: '&remove...' 
							#value: #removeInstVar ) 
						#(#MenuItem 
							#rawLabel: 'push &down...' 
							#value: #pushDownInstVar ) 
						#(#MenuItem 
							#rawLabel: 'pull &up...' 
							#value: #pullUpInstVar ) 
						#(#MenuItem 
							#rawLabel: '&create accessors...' 
							#value: #createInstVarAccessors ) 
						#(#MenuItem 
							#rawLabel: 'a&bstract...' 
							#value: #abstractInstVar ) 
						#(#MenuItem 
							#rawLabel: 'protect/concrete...' 
							#value: #protectInstVar ) ) #(3 3 2 3 ) nil ) ) 
			#(#MenuItem 
				#rawLabel: 'class &variables' 
				#submenu: #(#Menu #(
						#(#MenuItem 
							#rawLabel: 're&ferences...' 
							#value: #classVarRefs ) 
						#(#MenuItem 
							#rawLabel: '&add...' 
							#value: #addClassVar ) 
						#(#MenuItem 
							#rawLabel: 're&name as...' 
							#value: #renameClassVar ) 
						#(#MenuItem 
							#rawLabel: '&remove...' 
							#value: #removeClassVar ) 
						#(#MenuItem 
							#rawLabel: 'push &down...' 
							#value: #pushDownClassVar ) 
						#(#MenuItem 
							#rawLabel: 'pull &up...' 
							#value: #pullUpClassVar ) 
						#(#MenuItem 
							#rawLabel: '&create accessors...' 
							#value: #createClassVarAccessors ) 
						#(#MenuItem 
							#rawLabel: 'a&bstract...' 
							#value: #abstractClassVar ) ) #(1 3 2 2 ) nil ) ) ) #(4 3 ) nil ) decodeAsLiteralArray
!

protocolMenu
	"UIMenuEditor new openOnClass: self andSelector: #protocolMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem
				#label: 'file out as...'
				#accessCharacterPosition: 6 )
			#(#MenuItem
				#label: 'hardcopy'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'spawn'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'add...'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'rename as...'
				#accessCharacterPosition: 3 )
			#(#MenuItem
				#label: 'remove...'
				#accessCharacterPosition: 1 )
			#(#MenuItem
				#label: 'find method...'
				#accessCharacterPosition: 1 ) ) #(3 3 1 ) #(#fileOutProtocol #printOutProtocol #spawnProtocol #addProtocol #renameProtocol #removeProtocol #findMethodAndSelectAlphabetic ) ) decodeAsLiteralArray
!

selectorMenu
	"MenuEditor new openOnClass: self andSelector: #selectorMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: '&move' 
				#submenu: #(#Menu #(
						#(#MenuItem 
							#rawLabel: 'to &protocol...' 
							#value: #moveMethod ) 
						#(#MenuItem 
							#rawLabel: 'to &component...' 
							#value: #moveMethodToOtherObject ) ) #(2 ) nil ) ) 
			#(#MenuItem 
				#rawLabel: 're&name...' 
				#value: #renameMethod ) 
			#(#MenuItem 
				#rawLabel: '&remove...' 
				#value: #removeMethod ) 
			#(#MenuItem 
				#rawLabel: 's&afe remove' 
				#value: #removeMethodSafe ) 
			#(#MenuItem 
				#rawLabel: 'other' 
				#submenu: #(#Menu #(
						#(#MenuItem 
							#rawLabel: 'file &out as...' 
							#value: #fileOutMessage ) 
						#(#MenuItem 
							#rawLabel: '&hardcopy' 
							#value: #printOutMessage ) 
						#(#MenuItem 
							#rawLabel: '&spawn' 
							#value: #spawnMethod ) 
						#(#MenuItem 
							#rawLabel: 'add parameter...' 
							#value: #addParameter ) 
						#(#MenuItem 
							#rawLabel: '&inline all self sends' 
							#value: #inlineSelfSends ) 
						#(#MenuItem 
							#rawLabel: 'push &up' 
							#nameKey: #pushUpSelector 
							#value: #pushUpSelector ) 
						#(#MenuItem 
							#rawLabel: 'push do&wn' 
							#nameKey: #pushDownSelector 
							#value: #pushDownSelector ) ) #(3 2 2 ) nil ) ) ) #(4 1 ) nil ) decodeAsLiteralArray
! !

!BrowserNavigator methodsFor:'accessing-browser'!

spec: verticalBoolean 
	^[self getSpec: verticalBoolean] ensure: [self changed]
!

windowMenuItems
	| menus |
	menus := OrderedCollection new.
	menus
		add: 'Ca&tegory' -> self categoryMenu;
		add: '&Class' -> self classMenu;
		add: '&Protocol' -> self protocolMenu;
		add: '&Selector' -> self selectorMenu.
	^menus
! !

!BrowserNavigator methodsFor:'browsing'!

browseGlobalImplementorsOf: aSelector 
	self showWaitCursorWhile: 
			[(BrowserEnvironment new implementorsOf: aSelector) openEditor]
!

browseGlobalInstVarReadersTo: instVar in: aClass 
	self showWaitCursorWhile: 
			[(BrowserEnvironment new instVarReadersTo: instVar in: aClass) openEditor]
!

browseGlobalInstVarRefsTo: instVar in: aClass 
	self showWaitCursorWhile: 
			[(BrowserEnvironment new instVarRefsTo: instVar in: aClass) openEditor]
!

browseGlobalInstVarWritersTo: instVar in: aClass 
	self showWaitCursorWhile: 
			[(BrowserEnvironment new instVarWritersTo: instVar in: aClass) openEditor]
!

browseGlobalReferencesTo: aLiteral 
	self showWaitCursorWhile: 
			[(BrowserEnvironment new referencesTo: aLiteral) openEditor]
!

browseGlobalReferencesTo: aLiteral in: aClass 
	self showWaitCursorWhile: 
			[(BrowserEnvironment new referencesTo: aLiteral in: aClass) openEditor]
!

browseImplementorsOf: aSelector 
	self
		showWaitCursorWhile: [(self environment implementorsOf: aSelector) openEditor]
!

browseInstVarReadersTo: instVar in: aClass 
	self showWaitCursorWhile: 
			[(self environment instVarReadersTo: instVar in: aClass) openEditor]
!

browseInstVarRefsTo: instVar in: aClass 
	self showWaitCursorWhile: 
			[(self environment instVarRefsTo: instVar in: aClass) openEditor]
!

browseInstVarWritersTo: instVar in: aClass 
	self showWaitCursorWhile: 
			[(self environment instVarWritersTo: instVar in: aClass) openEditor]
!

browseReferencesTo: aLiteral 
	self
		showWaitCursorWhile: [(self environment referencesTo: aLiteral) openEditor]
!

browseReferencesTo: aLiteral in: aClass 
	self showWaitCursorWhile: 
			[(self environment referencesTo: aLiteral in: aClass) openEditor]
!

spawnHierarchy: aClass 
	| classes newBrowser |
	classes := (Set new) addAll: aClass withAllSuperclasses;
				yourself.
	classes addAll: aClass class withAllSuperclasses.
	classes addAll: aClass allSubclasses.
	classes addAll: aClass class allSubclasses.
	newBrowser := (ClassEnvironment onEnvironment: BrowserEnvironment new classes: classes)
				openEditor.
	(newBrowser navigator) setState: self getState;
		changedCategory.
	newBrowser navigator beHierarchy
! !

!BrowserNavigator methodsFor:'category drag and drop'!

canAcceptDropInCategoryListFrom: aDC 
	^#(#category #class) includes: aDC key
!

categoryDragEnter: aDragContext 
	(self canAcceptDropInCategoryListFrom: aDragContext)
		ifFalse: [^#dropEffectNone].
	aDragContext dropTarget clientData: (self initialDropStateFor: #categoryList).
	^#dropEffectMove
!

categoryDragOver: aDragContext 
	^(self canAcceptDropInCategoryListFrom: aDragContext)
		ifTrue: 
			[self showDropFeedbackForList: #categoryList in: aDragContext.
			(aDragContext sourceData clientData at: #category)
				== (self dropSelection: aDragContext)
				ifTrue: [#dropEffectNone]
				ifFalse: [#dropEffectMove]]
		ifFalse: [#dropEffectNone]
!

categoryDrop: aDragContext 
        (self canAcceptDropInCategoryListFrom: aDragContext)
                ifFalse: [^#dropEffectNone].
        ^
        [| dropCategory |
        dropCategory := self dropSelection: aDragContext.
        dropCategory == (aDragContext sourceData clientData at: #category ifAbsent: [dropCategory])
                ifTrue: [#dropEffectNone]
                ifFalse: [aDragContext key == #class
                                ifTrue: [self moveClassTo: dropCategory using: aDragContext sourceData clientData]
                                ifFalse: [self moveCategoryTo: dropCategory using: aDragContext sourceData clientData]]]
                ensure: 
                        [self restoreListStateFrom: aDragContext clientData.
                        aDragContext clientData: nil.
                        self updateCategoryList]
!

categoryWantToDrag: aController 
	^self category notNil
!

doCategoryDrag: aController 
	self category isNil ifTrue: [^self].
	self doDragAndDrop: #category for: aController
!

moveCategoryTo: dropCategory using: aDictionary 
        | categoryNames |
        categoryNames := self dropCategoriesFrom: aDictionary.
        categoryNames isEmpty ifTrue: [^#dropEffectNone].
        categoryNames do: 
                        [:each | 
                        dropCategory = each
                                ifFalse: [RefactoryBrowserPlatformSupport systemOrganization addCategory: each before: dropCategory]].
        ^#dropEffectMove

    "Modified: / 3.2.2000 / 23:26:01 / cg"
!

moveClassTo: dropCategory using: aDictionary 
        | classNames |
        classNames := self dropClassNamesFrom: aDictionary.
        classNames isEmpty ifTrue: [^#dropEffectNone].
        classNames
                do: [:each | RefactoryBrowserPlatformSupport systemOrganization classify: each under: dropCategory].
        ^#dropEffectMove

    "Modified: / 3.2.2000 / 23:25:53 / cg"
! !

!BrowserNavigator methodsFor:'changes management'!

logProtocolChange: aString
        "Add aString, which is an executable account of the last protocol change (rename,
        remove, selector move) to the changes file."

        Smalltalk isSmalltalkX ifFalse:[
            SourceFileManager default logChange: aString
        ]
! !

!BrowserNavigator methodsFor:'changing'!

changeRequest
	CodeModelLockPolicy flushCache.
	^super changeRequest
!

changed: anAspectSymbol with: aParameter
	CodeModelLockPolicy flushCache.
	^super changed: anAspectSymbol with: aParameter
! !

!BrowserNavigator methodsFor:'class drag and drop'!

canAcceptDropInClassListFrom: aDC 
	^#(#protocol #selector) includes: aDC key
!

canExtract: aDragContext 
	| dropClassName |
	dropClassName := self dropSelection: aDragContext.
	^dropClassName notNil and: 
			[dropClassName
				~~ (aDragContext sourceData clientData at: #class ifAbsent: [dropClassName])
					or: 
						[(aDragContext sourceData clientData at: #meta ifAbsent: [self isMeta])
							~~ self isMeta]]
!

classDragEnter: aDragContext 
	(self canAcceptDropInClassListFrom: aDragContext)
		ifFalse: [^#dropEffectNone].
	aDragContext dropTarget clientData: (self initialDropStateFor: #classList).
	^#dropEffectCopy
!

classDragOver: aDragContext 
	^(self canAcceptDropInClassListFrom: aDragContext)
		ifTrue: 
			[self showDropFeedbackForList: #classList in: aDragContext.
			(self canExtract: aDragContext)
				ifTrue: [^#dropEffectCopy]
				ifFalse: [^#dropEffectNone]]
		ifFalse: [#dropEffectNone]
!

classDrop: aDragContext 
        (self canAcceptDropInClassListFrom: aDragContext)
                ifFalse: [^#dropEffectNone].
        ^
        [| dropClassName |
        dropClassName := self dropSelection: aDragContext.
        (self canExtract: aDragContext)
                ifTrue: [aDragContext key == #selector
                                ifTrue: [self dropSelectorIn: dropClassName using: aDragContext sourceData clientData]
                                ifFalse: [self dropProtocolIn: dropClassName using: aDragContext sourceData clientData]]
                ifFalse: [#dropEffectNone]]
                ensure: 
                        [self restoreListStateFrom: aDragContext clientData.
                        aDragContext clientData: nil.
                        self updateCategoryList]
!

classWantToDrag: aController 
	^self className notNil
!

copySelector: each from: fromClass to: class classified: protocol 
	((class includesSelector: each)
		and: [(Dialog confirm: ('Do you want to replace <1s> in <2p>' expandMacrosWith: each with: class)) not])
		ifFalse: [class
				compile: (fromClass sourceCodeAt: each)
				classified: protocol
				notifying: nil]
!

copySelector: each from: fromClass to: class classified: protocol using: aCompositeRefactoryChange 
	((class includesSelector: each) and: 
			[(Dialog 
				confirm: ('Do you want to replace <1s> in <2p>' expandMacrosWith: each
						with: class)) 
					not]) 
		ifFalse: 
			[aCompositeRefactoryChange 
				compile: (fromClass sourceCodeAt: each)
				in: class
				classified: protocol]
!

doClassDrag: aController 
	self className isNil ifTrue: [^self].
	self selectedClass isNil ifTrue: [^Dialog warn: ('Class <1s> no longer exists.' expandMacrosWith: self className)
			for: self interfaceWindow].
	self doDragAndDrop: #class for: aController
!

dropProtocolIn: dropClassName using: aDictionary 
	| protocols fromClass meta class classNames |
	class := Smalltalk at: dropClassName ifAbsent: [nil].
	protocols := self dropProtocolsFrom: aDictionary.
	classNames := self dropClassNamesFrom: aDictionary.
	(protocols isEmpty or: [classNames size ~~ 1]) ifTrue: [^#dropEffectNone].
	fromClass := Smalltalk at: classNames first ifAbsent: [nil].
	meta := self dropMetaFrom: aDictionary.
	class isNil ifTrue: [^#dropEffectNone].
	meta ifTrue: [fromClass := fromClass class].
	self isMeta ifTrue: [class := class class].
	fromClass == class ifTrue: [^#dropEffectNone].
	protocols do: 
			[:each | 
			(fromClass organization listAtCategoryNamed: each) do: 
					[:sel | 
					self copySelector: sel
						from: fromClass
						to: class
						classified: each]].
	^#dropEffectCopy
!

dropSelectorIn: dropClassName using: aDictionary 
	| selectors fromClass meta class classNames |
	class := Smalltalk at: dropClassName ifAbsent: [nil].
	selectors := self dropSelectorsFrom: aDictionary.
	classNames := self dropClassNamesFrom: aDictionary.
	(selectors isEmpty or: [classNames size ~~ 1]) ifTrue: [^#dropEffectNone].
	fromClass := Smalltalk at: classNames first ifAbsent: [nil].
	meta := self dropMetaFrom: aDictionary.
	fromClass isNil | class isNil ifTrue: [^#dropEffectNone].
	meta ifTrue: [fromClass := fromClass class].
	self isMeta ifTrue: [class := class class].
	selectors do: 
			[:each | 
			self copySelector: each
				from: fromClass
				to: class
				classified: (fromClass whichCategoryIncludesSelector: each)].
	^#dropEffectCopy
! !

!BrowserNavigator methodsFor:'drag and drop support'!

doDragAndDrop: aSymbol for: aController 
	| ds dm data |
	data := DragDropData new.
	data key: aSymbol.
	data contextWindow: self builder window.
	data contextWidget: aController view.
	data contextApplication: self.
	data clientData: IdentityDictionary new.
	data clientData at: #navigatorState put: self getState.
	data clientData at: #selector put: self selector.
	data clientData at: #class put: self className.
	data clientData at: #protocol put: self protocol.
	data clientData at: #meta put: self isMeta.
	data clientData at: #category put: self category.
	ds := DropSource new.
	dm := DragDropManager withDropSource: ds withData: data.
	dm doDragDrop
!

dragLeave: aDragContext 
	self restoreListStateFrom: aDragContext dropTarget clientData.
	aDragContext dropTarget clientData: nil.
	^#dropEffectNone
!

dropCategoriesFrom: aDictionary 
	| state categoryName |
	state := aDictionary at: #navigatorState ifAbsent: [nil].
	^state isNil
		ifTrue: 
			[categoryName := aDictionary at: #category ifAbsent: [nil].
			categoryName isNil ifTrue: [#()] ifFalse: [Array with: categoryName]]
		ifFalse: [state categories]
!

dropClassNamesFrom: aDictionary 
	| state className |
	state := aDictionary at: #navigatorState ifAbsent: [nil].
	^state isNil
		ifTrue: 
			[className := aDictionary at: #class ifAbsent: [nil].
			className isNil ifTrue: [#()] ifFalse: [Array with: className]]
		ifFalse: [state classNames]
!

dropMetaFrom: aDictionary 
	| state |
	state := aDictionary at: #navigatorState ifAbsent: [nil].
	^state isNil
		ifTrue: [aDictionary at: #meta ifAbsent: [false]]
		ifFalse: [state isMeta]
!

dropProtocolsFrom: aDictionary 
	| state protocol |
	state := aDictionary at: #navigatorState ifAbsent: [nil].
	^state isNil
		ifTrue: 
			[protocol := aDictionary at: #protocol ifAbsent: [nil].
			protocol isNil ifTrue: [#()] ifFalse: [Array with: protocol]]
		ifFalse: [state protocols]
!

dropSelection: aDragContext 
	| controller index |
	controller := aDragContext clientData at: #controller.
	index := controller view targetIndex.
	index == 0 ifTrue: [^nil].
	^controller view sequence at: index
!

dropSelectorsFrom: aDictionary 
	| state selector |
	state := aDictionary at: #navigatorState ifAbsent: [nil].
	^state isNil
		ifTrue: 
			[selector := aDictionary at: #selector ifAbsent: [nil].
			selector isNil ifTrue: [#()] ifFalse: [Array with: selector]]
		ifFalse: [state selectors]
!

initialDropStateFor: aSymbol 
	| dict controller component |
	component := self builder componentAt: aSymbol.
	component isNil ifTrue: [^nil].
	controller := component widget controller.
	dict := IdentityDictionary new.
	dict at: #controller put: controller.
	dict at: #targetIndex put: controller view targetIndex.
	dict at: #hasFocus put: controller view hasFocus.
	controller view hasFocus: true.
	^dict
!

restoreListStateFrom: aDictionary 
	| controller |
	aDictionary isNil ifTrue: [^self].
	controller := aDictionary at: #controller.
	controller view targetIndex: (aDictionary at: #targetIndex).
	controller view hasFocus: (aDictionary at: #hasFocus)
!

showDropFeedbackForList: aSymbol in: aDragContext 
	| component |
	component := self builder componentAt: aSymbol.
	component notNil ifTrue: [component widget showDropFeedbackIn: aDragContext allowScrolling: true]
! !

!BrowserNavigator methodsFor:'initialization & release'!

initializeSendersImplementorsMenu
	| groups newGroup newMenu |
	groups := selectorMenuHolder value visibleMenuItemGroups 
				asOrderedCollection.
	self environment isSystem 
		ifFalse: 
			[newGroup := OrderedCollection 
						with: ((MenuItem labeled: 'Local Senders') submenu: [self localSendersMenu])
						with: ((MenuItem labeled: 'Local Implementors') 
								submenu: [self localImplementorsMenu]).
			groups addFirst: newGroup].
	newGroup := OrderedCollection 
				with: ((MenuItem labeled: 'Senders') submenu: [self globalSendersMenu])
				with: ((MenuItem labeled: 'Implementors') 
						submenu: [self globalImplementorsMenu]).
	groups addFirst: newGroup.
	newMenu := Menu new.
	groups do: [:each | newMenu addItemGroup: each].
	selectorMenuHolder value: newMenu
!

on: aBrowser 
        self initializeSendersImplementorsMenu.
        self environment isSystem ifFalse: [self addGlobalToMenus]
!

spawnClass
	self showWaitCursorWhile: 
			[(self environment forClasses: self nonMetaClasses) openEditor]
!

spawnMethod
	self showWaitCursorWhile: 
			[(self environment forClass: self selectedClass selectors: self selectors)
				openEditor]
!

spawnProtocol
	self showWaitCursorWhile: 
			[(self environment forClass: self selectedClass protocols: self protocols)
				openEditor]
! !

!BrowserNavigator methodsFor:'initialize-release'!

initializeMenus
	self initializeSendersImplementorsMenu.
	self environment isSystem ifFalse: [self addGlobalToMenus]
!

initializeViews
	self initializeMenus
! !

!BrowserNavigator methodsFor:'menus'!

addGlobal: globalSelector local: localSelector for: aName in: aMenu 
	| newName dots item mb |
	dots := aName last == $..
	newName := dots ifTrue: [aName copyFrom: 1 to: aName size - 3] ifFalse: [aName].
	item := aMenu menuItemAt: (aMenu labels indexOf: aName).
	item label: newName.
	item value: nil.
	mb := MenuBuilder new.
	mb add: (dots ifTrue: ['&local...'] ifFalse: ['&local']) -> localSelector.
	mb add: (dots ifTrue: ['&global...'] ifFalse: ['&global']) -> globalSelector.
	item submenu: (self initializeMenu: mb menu)
!

addGlobalToMenus
	#(#('class' #(#('references...' #classRefs #globalClassRefs))) #('instance variables' #(#('references...' #instVarRefs #globalInstVarRefs) #('readers...' #instVarReaders #globalInstVarReaders) #('writers...' #instVarWriters #globalInstVarWriters))) #('class variables' #(#('references...' #classVarRefs #globalClassVarRefs))))
		do: 
			[:each | 
			| submenu |
			submenu := (classMenuHolder value menuItemAt: (classMenuHolder value labels indexOf: each first)) submenu.
			each last do: [:elmt | self
					addGlobal: elmt last
					local: (elmt at: 2)
					for: elmt first
					in: submenu]]
!

globalImplementorsMenu
	^self implementorSenderMenuFor: #browseGlobalImplementorsOf:
!

globalSendersMenu
	^self implementorSenderMenuFor: #browseGlobalReferencesTo:
!

implementorSenderMenuFor: aSymbol 
	| menuBuilder literals |
	self selector isNil ifTrue: [^Menu new].
	menuBuilder := MenuBuilder new.
	menuBuilder add: (self menuNameFor: self selector) 
				-> [self perform: aSymbol with: self selector].
	literals := self sentSelectors.
	literals isEmpty ifFalse: [menuBuilder line].
	literals size > 10 
		ifTrue: 
			[menuBuilder
				add: 'More Symbols' -> 
								[| message |
								message := self choose: 'Select a message:' from: literals.
								message notNil ifTrue: [self perform: aSymbol with: message]];
				line].
	(1 to: (literals size min: 10)) do: 
			[:i | 
			menuBuilder add: (self menuNameFor: (literals at: i)) 
						-> [self perform: aSymbol with: (literals at: i)]].
	^menuBuilder menu
!

localImplementorsMenu
	^self implementorSenderMenuFor: #browseImplementorsOf:
!

localSendersMenu
	^self implementorSenderMenuFor: #browseReferencesTo:
!

menuNameFor: aSelector 
	aSelector isEmpty ifTrue: [^'-empty symbol-'].
	aSelector isInfix ifFalse: [^super menuNameFor: aSelector].
	^aSelector asString copyReplaceAll: '&' with: '&&'
! !

!BrowserNavigator methodsFor:'private'!

checkProtocolFor: aSelector in: aClass 
	| protocol |
	protocol := aClass organization categoryOfElement: aSelector.
	^protocol isNil 
		ifTrue: 
			[(Dialog confirm: aSelector asString 
						, ' is not classified under a protocol.\Do you want to classify it?' 
								withCRs) 
				ifTrue: 
					[protocol := Dialog 
								request: 'Enter a protocol name for ' asText 
										, (aSelector asText emphasizeAllWith: #(#italic)) , ':'.
					protocol isEmpty 
						ifFalse: 
							[self 
								moveMethods: (Array with: aSelector)
								to: protocol
								in: aClass]].
			true]
		ifFalse: [false]
!

checkProtocolMatchFor: aSelector in: aClass 
        | protocol superClass superProtocol patchClass |
        protocol := aClass organization categoryOfElement: aSelector.
        protocol isNil ifTrue: [^false].
        superClass := aClass superclass whichClassIncludesSelector: aSelector.
        superClass isNil ifTrue: [^false].
        superProtocol := superClass organization categoryOfElement: aSelector.
        superProtocol == protocol ifTrue: [^false].
        superProtocol isNil ifTrue: [^false].
        RBParser isSmalltalkX ifTrue:[
            patchClass := Dialog
                                choose: (aSelector printString , ' is classified under "' , protocol , '" in '
                                                , aClass name , '\and under "' , superProtocol , '" in ' , superClass name
                                                , '. Patch?') withCRs
                                labels: (Array with:'cancel'
                                               with: aClass name asString
                                               with: superClass name asString
                                               with: 'neither')
                                values: (Array with:#cancel
                                               with: aClass
                                                with: superClass
                                                with: nil)
                                default: aClass.
            patchClass == #cancel ifTrue: [AbortSignal raise].
        ] ifFalse:[
            patchClass := Dialog
                                choose: (aSelector printString , ' is classified under "' , protocol , '" in '
                                                , aClass name , '\and under "' , superProtocol , '" in ' , superClass name
                                                , '. Patch?') withCRs
                                labels: (Array with: aClass name asString
                                               with: superClass name asString
                                               with: 'neither')
                                values: (Array with: aClass
                                                with: superClass
                                                with: nil)
                                default: aClass.
        ].
        patchClass isNil ifTrue: [^false].
        patchClass == aClass
                ifTrue: 
                        [self moveMethod: aSelector
                                to: superProtocol
                                in: aClass]
                ifFalse: 
                        [self moveMethod: aSelector
                                to: protocol
                                in: superClass].
        ^true
!

checkProtocolsFor: aClass 
	^(self environment selectorsForClass: aClass) inject: false
		into: 
			[:bool :each | 
			bool | (self checkProtocolFor: each in: aClass)
				| (self checkProtocolMatchFor: each in: aClass)]
!

choose: aString from: aCollection
	^Dialog
		choose: aString
		fromList: aCollection
		values: aCollection
		lines: 20
		cancel: [nil]
!

filterFilename: fName
	"Filter out uglyness in file names"

	^Filename defaultClass suggest: (Filename defaultClass filterSeps: fName)
!

getSpec: verticalBoolean 
	| selectors protocols category categories class nonMeta classes |
	categories := self environment categories asList.
	self categoryList list: categories.
	categories size == 1 ifFalse: 
			[^verticalBoolean
				ifTrue: [self class verticalCategoryWindowSpec]
				ifFalse: [self class categoryWindowSpec]].
	category := categories first.
	self categoryHolder value: category.
	classes := (self environment classNamesFor: category) asList.
	self classList list: classes.
	classes size == 1 ifFalse: 
			[^verticalBoolean
				ifTrue: [self class verticalCategoryWindowSpec]
				ifFalse: [self class categoryWindowSpec]].
	self classHolder value: classes first.
	class := self environment at: classes first.
	((nonMeta := self environment includesClass: class)
		and: [self environment includesClass: class class]) ifTrue: 
				[self meta value: false.
				self protocolList list: (self environment protocolsFor: class) asList.
				^verticalBoolean
					ifTrue: [self class verticalClassWindowSpec]
					ifFalse: [self class classWindowSpec]].
	protocols := (self environment
				protocolsFor: (nonMeta ifTrue: [class] ifFalse: [class class])) asList.
	self meta value: nonMeta not.
	self protocolList list: protocols.
	protocols size == 1 ifFalse: 
			[^verticalBoolean
				ifTrue: [self class verticalClassWindowSpec]
				ifFalse: [self class classWindowSpec]].
	self protocolHolder value: protocols first.
	selectors := (self environment selectorsFor: protocols first
				in: (nonMeta ifTrue: [class] ifFalse: [class class])) asList.
	self selectorList list: selectors.
	selectors size == 1 ifFalse: 
			[^verticalBoolean
				ifTrue: [self class verticalProtocolWindowSpec]
				ifFalse: [self class protocolWindowSpec]].
	self selectorHolder value: selectors first.
	^verticalBoolean
		ifTrue: [self class verticalSelectorWindowSpec]
		ifFalse: [self class selectorWindowSpec]
!

hardcopyStream: aStream
	Cursor wait showWhile: [aStream contents asText asParagraph hardcopy]
!

sentSelectors
	| method |
	method := self selectedClass compiledMethodAt: self selector
				ifAbsent: [nil].
	method isNil ifTrue: [^#()].
	^method allSymbolLiterals asSortedCollection: [:a :b | a < b]
! !

!BrowserNavigator methodsFor:'private-category'!

addCategory
	| newCategory categoryName |
	self changeRequest ifFalse: [^self].
	categoryName := Dialog
				request: 'Enter new category'
				initialAnswer: ''
				for: self interfaceWindow.
	(categoryName isNil or: [categoryName isEmpty])
		ifTrue: [^self].
	newCategory := categoryName asSymbol.
	self addCategory: newCategory before: self category.
	self newCategoryList: (Array with: newCategory).
	self changedCategory
!

addCategory: newCategory before: aCategory
        "Insert newCategory into the class organization before aCategory."

        Cursor wait
                showWhile:
                        [RefactoryBrowserPlatformSupport systemOrganization addCategory: newCategory before: aCategory.
                        ChangeSet current reorganizeSystem]

    "Modified: / 3.2.2000 / 23:26:47 / cg"
!

fileOutCategory
        | fileName fileManager |
        fileName := Dialog requestNewFileName: 'File out on' default: (self filterFilename: self category , '.st').
        fileName = '' ifTrue: [^nil].
        fileManager := SourceCodeStream on: fileName asFilename writeStream.
        [self categories do: [:each | self environment fileOutCategory: each on: fileManager]]
                ensure: [fileManager close]
!

hardcopyCategory
	"Print the category."

	| stream |
	stream := TextStream on: (String new: 1000).
	self categories do: [:each | self environment writeCategory: each on: stream].
	self hardcopyStream: stream
!

removeCategory
	| index |
	self changeRequest ifFalse: [^self].
	(self categories
		contains: [:each | (BrowserEnvironment new classNamesFor: each) isEmpty not])
			ifTrue: 
				[(Dialog
					confirm: 'Are you certain that you want to remove all classes in the selected categories?'
					for: self interfaceWindow) ifFalse: [^self]].
	index := self categoryList list indexOf: self category.
	self categories do: [:each | self removeCategory: each].
	self
		newCategoryList: (Array with: (self categoryList list
						at: (index == 1 ifTrue: [index + 1] ifFalse: [index - 1]))).
	self changedCategory
!

removeCategory: aCategory
        Cursor wait
                showWhile:
                        [| classes |
                        classes := self environment superclassOrder: aCategory.
                        classes reverseDo: [:cls | cls removeFromSystem].
                        (RefactoryBrowserPlatformSupport systemOrganization listAtCategoryNamed: aCategory) isEmpty
                                ifTrue:
                                        [RefactoryBrowserPlatformSupport systemOrganization removeCategory: aCategory.
                                        ChangeSet current reorganizeSystem]]

    "Modified: / 3.2.2000 / 23:25:39 / cg"
!

renameCategory
	| newCategory categoryName |
	self changeRequest ifFalse: [^self].
	categoryName := Dialog
				request: 'Enter new category'
				initialAnswer: self category
				for: self interfaceWindow.
	(categoryName isNil or: [categoryName isEmpty])
		ifTrue: [^self].
	newCategory := categoryName asSymbol.
	self renameCategory: self category to: newCategory.
	self newCategoryList: (Array with: newCategory)
!

renameCategory: aCategory to: newCategory
        Cursor wait showWhile: [(RefactoryBrowserPlatformSupport systemOrganization renameCategory: aCategory to: newCategory)
                        ifTrue: [ChangeSet current reorganizeSystem]]

    "Modified: / 3.2.2000 / 23:25:17 / cg"
!

spawnCategory
	Cursor wait
		showWhile: [(self environment forCategories: self categories) openEditor]
! !

!BrowserNavigator methodsFor:'private-class'!

abstractClassVar
	| classVars |
	self changeRequest ifFalse: [^self].
	classVars := self selectClassVariables.
	classVars isEmpty ifTrue: [^self].
	classVars do: 
			[:each | 
			self handleError: 
					[(AbstractClassVariableRefactoring variable: each class: self nonMetaClass) 
						execute]].
	self changedClass
!

abstractInstVar
	| instVars |
	self changeRequest ifFalse: [^self].
	instVars := self selectInstanceVariables.
	instVars isEmpty ifTrue: [^self].
	instVars do: [:each | self abstractInstVar: each in: self selectedClass].
	self changedClass
!

abstractInstVar: instVar in: class 
	self handleError: 
			[(AbstractInstanceVariableRefactoring variable: instVar class: class)
				execute]
!

addClassVar
	self changeRequest ifFalse: [^self].
	self addClassVarIn: self nonMetaClass.
	self changedClass
!

addClassVarIn: aClass 
	| newName |
	newName := self requestClassVarName: ''.
	newName isNil ifTrue: [^self].
	self handleError: 
			[(AddClassVariableRefactoring variable: newName class: aClass) execute]
!

addInstVar
	self changeRequest ifFalse: [^self].
	self addInstVarIn: self selectedClass.
	self changedClass
!

addInstVarIn: aClass 
	| newName |
	newName := self requestInstVarName: ''.
	newName isNil ifTrue: [^self].
	self handleError: 
			[(AddInstanceVariableRefactoring variable: newName class: aClass) execute]
!

changeClassCategory
	| state |
	self changeRequest ifFalse: [^self].
	state := self getState.
	self changeClassCategoryFor: self nonMetaClasses.
	self setState: state updateClasses: true.
	self changed: #category with: self category
!

changeClassCategoryFor: classCollection 
        | dialog newCategory oldCategory changeClasses |
        classCollection isEmpty ifTrue: [^self].
        oldCategory := self environment whichCategoryIncludes: classCollection first name.
        dialog := CategoryDialog new.
        dialog organizer: RefactoryBrowserPlatformSupport systemOrganization.
        dialog currentCategory: oldCategory.
        dialog open ifFalse: [^self].
        newCategory := dialog categoryName asSymbol.
        changeClasses := classCollection
                                select: [:each | (self environment whichCategoryIncludes: each name) ~= newCategory].
        changeClasses isEmpty ifTrue: [^self].
        changeClasses do: 
                        [:each | 
                        RefactoryBrowserPlatformSupport systemOrganization classify: each name under: newCategory.
                        ChangeSet current changeClass: each]

    "Modified: / 3.2.2000 / 23:26:33 / cg"
!

checkProtocols
	self changeRequest ifFalse: [^self].
	Cursor wait showWhile: 
			[(self nonMetaClasses inject: false
				into: 
					[:changed :class | 
					changed | (self checkProtocolsFor: class)
						| (self checkProtocolsFor: class class)])
					ifTrue: [self setState: self getState updateClasses: true]
					ifFalse: [Dialog warn: 'No changes made.']]
!

classRefs
	self browseReferencesTo: (self environment associationAt: self className)
!

classVarRefs
	| classVar association |
	classVar := self selectClassVarSupers: true subs: false.
	classVar isNil ifTrue: [^self].
	association := self findAssociationForClassVariable: classVar.
	self browseReferencesTo: association in: self nonMetaClass
!

convertToSibling
	| name subclasses |
	name := self request: 'Enter name for new parent class'.
	name isEmpty ifTrue: [^self].
	subclasses := self selectSubclassesOf: self nonMetaClass.
	subclasses isNil ifTrue: [^self].
	self handleError: 
			[(ChildrenToSiblingsRefactoring name: name
				class: self nonMetaClass
				subclasses: subclasses) execute.
			self selectClasses: (Array with: name asSymbol)
				meta: self isMeta
				categories: self categories]
!

createClassVarAccessors
	| classVars |
	self changeRequest ifFalse: [^self].
	classVars := self selectClassVariables.
	classVars isEmpty ifTrue: [^self].
	classVars do: 
			[:each | 
			self handleError: 
					[(CreateAccessorsForVariableRefactoring 
						variable: each
						class: self nonMetaClass
						classVariable: true) execute]].
	self changedClass
!

createInstVarAccessors
	| instVars |
	self changeRequest ifFalse: [^self].
	instVars := self selectInstanceVariables.
	instVars isEmpty ifTrue: [^self].
	instVars do: 
			[:each | 
			self handleError: 
					[(CreateAccessorsForVariableRefactoring 
						variable: each
						class: self selectedClass
						classVariable: false) execute]].
	self changedClass
!

createSubclass
	| class |
	self changeRequest ifFalse: [^self].
	class := self createSubclassOf: self nonMetaClass.
	class isNil ifTrue: [^self].
	self selectClass: class.
	self updateCategoryList
!

createSubclassOf: aClass 
        | name subclasses dialog |
        name := self requestClassName.
        name isNil ifTrue: [^nil].
        subclasses := self selectSubclassesOf: aClass.
        subclasses isNil ifTrue: [^nil].
        dialog := CategoryDialog new.
        dialog organizer: RefactoryBrowserPlatformSupport systemOrganization.
        dialog currentCategory: (self environment whichCategoryIncludes: aClass name).
        dialog open ifFalse: [^nil].
        ^self handleError: 
                        [(AddClassRefactoring addClass: name
                                superclass: aClass
                                subclasses: subclasses
                                category: dialog categoryName) execute.
                        Smalltalk at: name asSymbol ifAbsent: [nil]]

    "Modified: / 3.2.2000 / 23:26:15 / cg"
!

fileOutClass
	| fileName fileManager |
	fileName := Dialog requestNewFileName: 'File out on'
				default: (self filterFilename: self nonMetaClass name , '.st').
	fileName = '' ifTrue: [^nil].
	fileManager := SourceCodeStream on: fileName asFilename writeStream.
        
	[fileManager timeStamp.
	self nonMetaClasses do: [:each | each fileOutSourceOn: fileManager]] 
			ensure: [fileManager close]
!

findAllReferencesToInstances
	self showWaitCursorWhile: 
			[| paths |
			paths := ReferenceFinder findAllPathsToInstanceOf: self selectedClass.
			paths isEmpty 
				ifTrue: [self warn: 'No reference paths exist']
				ifFalse: [paths inspect]]
!

findAssociationForClassVariable: classVar 
	| association definingClass name |
	definingClass := self nonMetaClass.
	association := nil.
        
	[definingClass notNil and: 
			[name := definingClass classPool keys 
						detect: [:each | each asString = classVar asString]
						ifNone: [nil].
			association := definingClass classPool associationAt: name ifAbsent: [nil].
			association isNil]] 
			whileTrue: [definingClass := definingClass superclass].
	^association
!

findReferencePathToInstance
	self showWaitCursorWhile: 
			[| path |
			path := ReferenceFinder findPathToInstanceOf: self selectedClass.
			path notNil 
				ifTrue: [path inspect]
				ifFalse: [self warn: 'No reference paths exist']]
!

forClasses: aCollection showVariableMenu: generatorBlock collect: valueBlock 
        "Construct a menu of variable names supplied by the generatorBlock, 
        with lines between classes in the superclass chain. Show the menu, 
        returning the variable chosen by the user, or nil if no variable was chosen."

        | variables labels tab listW sd spec buttons |
        variables := OrderedCollection new.
        labels := SelectionInList new.
        tab := String with: Character tab.
        aCollection
                do: 
                        [:eachClass | 
                        | varList |
                        varList := generatorBlock value: eachClass.
                        varList isEmpty
                                ifFalse: 
                                        [labels list add: (Text string: eachClass name emphasis: #italic).
                                        labels selectionIndex: labels list size + 1.    "we know this will be legal"
                                        variables add: nil.
                                        (generatorBlock value: eachClass)
                                                do: 
                                                        [:var | 
                                                        labels list add: tab , (valueBlock value: var).
                                                        variables addLast: var]]].
        variables isEmpty ifTrue: [^nil].       "Nothing to choose from"
        RBParser isSmalltalkX ifTrue:[
            labels list:(labels list collect:[:each | each withTabsExpanded]).
            sd := Dialog new.
            sd addMessage: 'Select variable:' withCRs centered: false.
            sd addGap: 8.
            listW := sd
                                    addList: labels
                                    lines: (20 min: variables size + 2)
                                    validation: [labels selectionIndex > 0].
            listW widget setValidTargetIndex: labels selectionIndex.
            sd addGap: 4.
            sd addOkButton; addAbortButton.
            labels selectionIndexHolder compute: [:v | (v > 0 and: [(variables at: v) isNil])
                            ifTrue: 
                                    [labels selectionIndex: 0.
                                    ]].
            sd open.
        ] ifFalse:[
            sd := SimpleDialog new.
            spec := sd class interfaceSpecFor: #emptySpec.
            sd builder add: spec window.
            sd builder add: spec component.
            sd setInitialGap.
            sd addMessage: 'Select variable:' withCRs centered: false.
            sd addGap: 8.
            listW := sd
                                    addList: labels
                                    lines: (20 min: variables size + 2)
                                    validation: [labels selectionIndex > 0].
            listW widget setValidTargetIndex: labels selectionIndex.
            sd addGap: 4.
            buttons := sd addOK: [labels selectionIndex ~= 0].
            sd addGap: 6.
            sd bottomAlignLowerEdge: listW.
            sd bottomAlign: (Array with: buttons).
            labels selectionIndexHolder compute: [:v | (v > 0 and: [(variables at: v) isNil])
                            ifTrue: 
                                    [labels selectionIndex: 0.
                                    listW widget targetIndex: 0]].
            sd preOpen.
            sd builder openDialogWithExtent: sd builder window displayBox extent.
        ].
        ^sd accept value
                ifTrue: [variables at: labels selectionIndex]
                ifFalse: [nil]

    "Modified: / 4.2.2000 / 00:17:58 / cg"
!

globalClassRefs
	self browseGlobalReferencesTo: (self environment associationAt: self className)
!

globalClassVarRefs
	| classVar association |
	classVar := self selectClassVarSupers: true subs: false.
	classVar isNil ifTrue: [^self].
	association := self findAssociationForClassVariable: classVar.
	self browseGlobalReferencesTo: association in: self nonMetaClass
!

globalInstVarReaders
	| instVar |
	instVar := self selectInstVarSupers: true subs: false.
	instVar notNil
		ifTrue: [self browseGlobalInstVarReadersTo: instVar in: self selectedClass]
!

globalInstVarRefs
	| instVar |
	instVar := self selectInstVarSupers: true subs: false.
	instVar notNil
		ifTrue: [self browseGlobalInstVarRefsTo: instVar in: self selectedClass]
!

globalInstVarWriters
	| instVar |
	instVar := self selectInstVarSupers: true subs: false.
	instVar notNil
		ifTrue: [self browseGlobalInstVarWritersTo: instVar in: self selectedClass]
!

inspectAllInstances
	(self nonMetaClass allInstancesWeakly: true) inspect
!

instVarReaders
	| instVar |
	instVar := self selectInstVarSupers: true subs: false.
	instVar notNil
		ifTrue: [self browseInstVarReadersTo: instVar in: self selectedClass]
!

instVarRefs
	| instVar |
	instVar := self selectInstVarSupers: true subs: false.
	instVar notNil
		ifTrue: [self browseInstVarRefsTo: instVar in: self selectedClass]
!

instVarWriters
	| instVar |
	instVar := self selectInstVarSupers: true subs: false.
	instVar notNil
		ifTrue: [self browseInstVarWritersTo: instVar in: self selectedClass]
!

printOutClass
	"Print the class."

	| stream |
	stream := TextStream on: (String new: 1000).
	self nonMetaClasses do: [:each | each printOutOn: stream].
	self hardcopyStream: stream
!

protectInstVar
	| instVars |
	self changeRequest ifFalse: [^self].
	instVars := self selectInstanceVariables.
	instVars isEmpty ifTrue: [^self].
	instVars do: [:each | self protectInstVar: each in: self selectedClass].
	self changedClass
!

protectInstVar: instVar in: class 
	self handleError: 
			[(ProtectInstanceVariableRefactoring variable: instVar class: class) 
				execute]
!

pullUpClassVar
	| classVar |
	self changeRequest ifFalse: [^self].
	classVar := self selectSubclassClassVar.
	classVar isNil ifTrue: [^self].
	self handleError: 
			[(PullUpClassVariableRefactoring variable: classVar class: self nonMetaClass)
				execute.
			self changedClass]
!

pullUpInstVar
	| instVar |
	self changeRequest ifFalse: [^self].
	instVar := self selectSubclassInstVar.
	instVar isNil ifTrue: [^self].
	self handleError: 
			[(PullUpInstanceVariableRefactoring variable: instVar class: self selectedClass)
				execute.
			self changedClass]
!

pushDownClassVar
	| classVar |
	self changeRequest ifFalse: [^self].
	classVar := self selectClassVarSupers: false subs: false.
	classVar isNil ifTrue: [^self].
	self handleError: 
			[(PushDownClassVariableRefactoring variable: classVar
				class: self nonMetaClass) execute.
			self changedClass]
!

pushDownInstVar
	| instVar |
	self changeRequest ifFalse: [^self].
	instVar := self selectInstVarSupers: false subs: false.
	instVar isNil ifTrue: [^self].
	self handleError: 
			[(PushDownInstanceVariableRefactoring variable: instVar
				class: self selectedClass) execute.
			self changedClass]
!

removeClass
	| notRemoved |
	self changeRequest ifFalse: [^self].
	(self
		confirm: 'Are you certain that you want to remove all selected classes?')
			ifFalse: [^self].
	notRemoved := self nonMetaClasses reject: [:each | self removeClass: each].
	self newClassList: (notRemoved collect: [:each | each name]).
	self changedClass
!

removeClass: aClass 
	(Smalltalk includesKey: aClass name) ifFalse: [^true].
	(aClass subclasses isEmpty
		or: [self confirm: aClass name , ' has subclasses. Remove anyway?'])
			ifFalse: [^false].
	self showWaitCursorWhile: [aClass removeFromSystem].
	^true
!

removeClassSafe
	self changeRequest ifFalse: [^self].
	self removeClassesSafe: self nonMetaClasses.
	self newClassList: self classNames.
	self changedClass
!

removeClassVar
	| classVar |
	self changeRequest ifFalse: [^self].
	classVar := self selectClassVarSupers: false subs: false.
	classVar isNil ifTrue: [^self].
	self handleError: 
			[(RemoveClassVariableRefactoring variable: classVar
				class: self nonMetaClass) execute.
			self changedClass]
!

removeClassesSafe: classCollection 
	self handleError: 
			[(RemoveClassRefactoring 
				classNames: (classCollection collect: [:each | each name])) execute]
!

removeInstVar
	| instVar |
	self changeRequest ifFalse: [^self].
	instVar := self selectInstVarSupers: false subs: false.
	instVar isNil ifTrue: [^self].
	self removeInstVar: instVar fromClass: self selectedClass.
	self changedClass
!

removeInstVar: instVar fromClass: cls 
	self handleError: 
			[(RemoveInstanceVariableRefactoring variable: instVar class: cls) execute]
!

renameClass
	self changeRequest ifFalse: [^self].
	self renameClass: self nonMetaClass
!

renameClass: aClass 
	| aString newName |
	aString := self request: 'Enter new ClassName' initialAnswer: aClass name.
	aString isEmpty ifTrue: [^self].
	newName := aString asSymbol.
	self handleError: 
			[(RenameClassRefactoring rename: aClass to: newName) execute.
			self selectClasses: (Array with: aString asSymbol)
				meta: self isMeta
				categories: self categories.
			self changedClass]
!

renameClassVar
	| classVar |
	self changeRequest ifFalse: [^self].
	classVar := self selectClassVarSupers: false subs: false.
	classVar isNil ifTrue: [^self].
	self renameClassVar: classVar in: self nonMetaClass.
	self changedClass
!

renameClassVar: oldName in: aClass 
	| newName |
	newName := self requestClassVarName: oldName.
	newName isNil ifTrue: [^self].
	self handleError: 
			[(RenameClassVariableRefactoring rename: oldName
				to: newName
				in: aClass) execute]
!

renameInstVar
	| instVar |
	self changeRequest ifFalse: [^self].
	instVar := self selectInstVarSupers: false subs: false.
	instVar isNil ifTrue: [^self].
	self renameInstVar: instVar in: self selectedClass.
	self changedClass
!

renameInstVar: oldName in: aClass 
	| newName |
	newName := self requestInstVarName: oldName.
	newName isNil ifTrue: [^self].
	self handleError: 
			[(RenameInstanceVariableRefactoring rename: oldName
				to: newName
				in: aClass) execute]
!

requestClassName
	| name |
	name := self request: 'Enter a class name:'.
	^name isEmpty ifTrue: [nil] ifFalse: [name]
!

requestClassVarName: oldName 
	| name |
	name := self request: 'Enter a class variable name:' initialAnswer: oldName.
	(name isEmpty or: [oldName asString = name asString]) ifTrue: [^nil].
	^name
!

requestInstVarName: oldName 
	| name |
	name := self request: 'Enter a instance variable name:' initialAnswer: oldName.
	(name isEmpty or: [oldName = name]) ifTrue: [^nil].
	^name
!

selectClassVarSupers: superBoolean subs: subBoolean
	| classes |
	classes := OrderedCollection with: self nonMetaClass.
	superBoolean ifTrue: [classes addAllFirst: self nonMetaClass allSuperclasses reverse].
	subBoolean ifTrue: [classes addAllLast: self nonMetaClass allSubclasses].
	^self
		forClasses: classes
		showVariableMenu: [:class | class classPool keys asSortedCollection]
		collect: [:name | name]
!

selectClassVariables
        | variables |
        variables := self nonMetaClass classVarNames asSortedCollection.
        variables isEmpty ifTrue: [^#()].
        RBParser isSmalltalkX ifTrue:[
            ^Dialog 
                    chooseMultiple: 'Choose variables:'
                    fromList: variables
                    values: variables
                    buttons: #()
                    values: #()
                    lines: 8
                    cancel: [#()]
        ].
        ^SimpleDialog new 
                chooseMultiple: 'Choose variables:'
                fromList: variables
                values: variables
                buttons: #()
                values: #()
                lines: 8
                cancel: [#()]
                for: nil

    "Modified: / 3.2.2000 / 23:17:31 / cg"
!

selectInstVarSupers: superBoolean subs: subBoolean
	| classes |
	classes := OrderedCollection with: self selectedClass.
	superBoolean ifTrue: [classes addAllFirst: self selectedClass allSuperclasses reverse].
	subBoolean ifTrue: [classes addAllLast: self selectedClass allSubclasses].
	^self
		forClasses: classes
		showVariableMenu: [:class | class instVarNames]
		collect: [:cname | cname]
!

selectInstanceVariables
        | variables |
        variables := self selectedClass instVarNames asSortedCollection.
        variables isEmpty ifTrue: [^#()].
        RBParser isSmalltalkX ifTrue:[
            ^Dialog 
                    chooseMultiple: 'Choose variables:'
                    fromList: self selectedClass instVarNames
                    values: self selectedClass instVarNames
                    buttons: #()
                    values: #()
                    lines: 8
                    cancel: [#()]
        ].
        ^SimpleDialog new 
                chooseMultiple: 'Choose variables:'
                fromList: self selectedClass instVarNames
                values: self selectedClass instVarNames
                buttons: #()
                values: #()
                lines: 8
                cancel: [#()]
                for: nil

    "Modified: / 3.2.2000 / 23:17:38 / cg"
!

selectSubclassClassVar
	| varNames |
	varNames := (self selectedClass allSubclasses inject: Set new
				into: 
					[:set :each | 
					set addAll: each classVarNames;
						yourself])
					asSortedCollection.
	varNames isEmpty ifTrue: [^nil].
	^self choose: 'Select class variable:' from: varNames
!

selectSubclassInstVar
	| varNames |
	varNames := (self selectedClass allSubclasses inject: Set new
				into: 
					[:set :each | 
					set addAll: each instVarNames;
						yourself])
					asSortedCollection.
	varNames isEmpty ifTrue: [^nil].
	^self choose: 'Select instance variable:' from: varNames
!

spawnHierarchy
	self spawnHierarchy: self nonMetaClass
!

valueHolderForInstVar: aName in: aClass
	self handleError: [(ValueHolderRefactoring variable: aName class: aClass) execute]
!

valueHolderInstVar
	| instVar |
	self changeRequest ifFalse: [^self].
	instVar := self selectInstVarSupers: false subs: false.
	instVar isNil ifTrue: [^self].
	self valueHolderForInstVar: instVar in: self selectedClass.
	self changedClass
! !

!BrowserNavigator methodsFor:'private-protocol'!

addProtocol
	| newProtocol |
	self changeRequest ifFalse: [^self].
	newProtocol := Dialog
				request: 'Enter new protocol'
				initialAnswer: (LastProtocol notNil
						ifTrue: [LastProtocol]
						ifFalse: [#'new protocol name'])
				for: self interfaceWindow.
	(newProtocol isNil or: [newProtocol isEmpty])
		ifTrue: [^self].
	newProtocol := newProtocol asSymbol.
	self
		addProtocol: newProtocol
		before: self protocol
		for: self selectedClass.
	self newProtocolList: (Array with: newProtocol).
	self changedProtocol
!

addProtocol: aNewProtocol before: aSymbolOrNil for: aClass 
	Cursor wait showWhile: 
			[aClass organization addCategory: aNewProtocol before: aSymbolOrNil.
			self
				logProtocolChange: aClass name , ' organization addCategory: ' , aNewProtocol printString
						, ' before: ' , aSymbolOrNil printString.
			aClass reorganize]
!

fileOutProtocol
	| fileName fileManager |
	fileName := Dialog requestNewFileName: 'File out as'
				default: (self filterFilename: self className , '-' , self protocol , '.st').
	fileName = '' ifTrue: [^nil].
	fileManager := SourceCodeStream on: fileName asFilename writeStream.
        
	[fileManager timeStamp.
	self protocols do: 
			[:each | 
			fileManager 
				fileOutMessages: (self environment selectorsFor: each in: self selectedClass)
				for: self selectedClass]] 
			ensure: [fileManager close]
!

printOutProtocol
	"Print out protocol."

	| stream |
	stream := TextStream on: (String new: 1000).
	self protocols
		do: [:each | self selectedClass printOutCategory: each on: stream].
	self hardcopyStream: stream
!

removeProtocol
	self changeRequest ifFalse: [^self].
	(self protocols contains: 
			[:each | 
			(self selectedClass organization listAtCategoryNamed: each) isEmpty not])
		ifTrue: 
			[(Dialog
				confirm: 'Are you certain that you want to\remove the selected protocols and their methods?'
						withCRs
				for: self interfaceWindow) ifFalse: [^self]].
	self protocols
		do: [:each | self removeProtocol: each in: self selectedClass].
	self newProtocolList: #().
	self changedProtocol
!

removeProtocol: aProtocol in: aClass
        Cursor wait
                showWhile:
                        [(self environment selectorsFor: aProtocol in: aClass)
                                do: [:each | self removeMethod: each in: aClass].
                        aClass organization removeCategory: aProtocol.
                        RBParser isSmalltalkX ifFalse:[
                            self logProtocolChange: aClass name , ' organization removeCategory: ' , aProtocol storeString.
                            aClass reorganize.

                        ].
                ]

    "Modified: / 3.2.2000 / 23:52:54 / cg"
!

renameProtocol
	| newProtocol |
	self changeRequest ifFalse: [^self].
	newProtocol := Dialog request: 'Enter new protocol' initialAnswer: self protocol.
	newProtocol isEmpty ifTrue: [^self].
	newProtocol := newProtocol asSymbol.
	self renameProtocol: self protocol
		to: newProtocol
		in: self selectedClass.
	self newProtocolList: (Array with: newProtocol).
	self changedProtocol
!

renameProtocol: oldProtocol to: newProtocol in: aClass 
	Cursor wait showWhile: 
			[(aClass organization renameCategory: oldProtocol to: newProtocol) ifTrue: 
					[self
						logProtocolChange: aClass printString , ' organization renameCategory: '
								, oldProtocol printString , ' to: ' , newProtocol printString.
					aClass reorganize]]
! !

!BrowserNavigator methodsFor:'private-querying'!

selectSubclassesOf: aClass 
        | subclasses |
        subclasses := aClass subclasses asSortedCollection: [:a :b | a name < b name].
        subclasses isEmpty ifTrue: [^#()].

        RBParser isSmalltalkX ifTrue:[
            ^Dialog 
                    chooseMultiple: 'Choose subclasses:'
                    fromList: subclasses
                    values: subclasses
                    buttons: #()
                    values: #()
                    lines: 8
                    cancel: [nil]
        ].
        ^SimpleDialog new
                chooseMultiple: 'Choose subclasses:'
                fromList: subclasses
                values: subclasses
                buttons: #()
                values: #()
                lines: 8
                cancel: [nil]
                for: nil
! !

!BrowserNavigator methodsFor:'private-selector'!

addParameter
	| newSelector |
	self changeRequest ifFalse: [^self].
	newSelector := self addParameterTo: self selector in: self selectedClass.
	newSelector isNil ifTrue: [^self].
	self newSelectorList: (Array with: newSelector).
	self changedSelector
!

addParameterTo: aSelector in: aClass 
	| initializer newSelector initialAnswer |
	initialAnswer := aSelector numArgs == 0 
				ifTrue: [aSelector , ':']
				ifFalse: [aSelector].
	newSelector := self request: 'Enter new selector:'
				initialAnswer: initialAnswer.
	newSelector isEmpty ifTrue: [^nil].
	newSelector := newSelector asSymbol.
	initializer := self request: 'Enter default value for parameter:'
				initialAnswer: 'nil'.
	initializer isEmpty ifTrue: [^nil].
	^self handleError: 
			[(AddParameterRefactoring 
				addParameterToMethod: aSelector
				in: aClass
				newSelector: newSelector
				initializer: initializer) execute.
			newSelector]
!

copyMethods: selectorCollection from: aClass toProtocol: aProtocol 
	| protStart newProtocol destClassName destClass classPart changes |
	newProtocol := aProtocol.
	classPart := newProtocol copyUpTo: $>.
	destClassName := classPart copyUpTo: Character space.
	destClass := self environment at: destClassName asSymbol ifAbsent: [nil].
	destClass isBehavior ifFalse: [^self].
	classPart size = destClassName size 
		ifFalse: 
			[(classPart size - destClassName size = 6 
				and: [(classPart copyFrom: classPart size - 5 to: classPart size) = ' class']) 
					ifTrue: [destClass := destClass class]
					ifFalse: [^self]].
	protStart := classPart size + 2.
	[(newProtocol at: protStart) = $ ] whileTrue: [protStart := protStart + 1].
	newProtocol := (newProtocol copyFrom: protStart to: newProtocol size) 
				asSymbol.
	changes := CompositeRefactoryChange named: 'Copy methods'.
	destClass == aClass 
		ifFalse: 
			[selectorCollection do: 
					[:each | 
					changes 
						compile: (aClass sourceCodeAt: each)
						in: destClass
						classified: newProtocol]].
	self performChange: changes
!

fileOutMessage
	| fileName sel fileManager |
	sel := self selector isKeyword 
				ifTrue: 
					[(self selector keywords inject: (WriteStream on: (String new: 20))
						into: 
							[:sum :each | 
							sum
								nextPutAll: (each copyFrom: 1 to: each size - 1);
								yourself]) 
							contents]
				ifFalse: [self selector].
	fileName := Dialog requestNewFileName: 'File out as'
				default: (self filterFilename: self selectedClass name , '-' , sel , '.st').
	fileName = '' ifTrue: [^nil].
	fileManager := SourceCodeStream on: fileName asFilename writeStream.
        
	[fileManager timeStamp.
	fileManager fileOutMessages: self selectors for: self selectedClass] 
			ensure: [fileManager close]
!

inlineSelfSends
        self handleError: 
                        [| refactoring |
                        refactoring := InlineAllSelfSendersRefactoring sendersOf: self selector
                                                in: self selectedClass.
                        refactoring execute.
                        refactoring messagesNotReplaced > 0 
                                ifTrue: 
                                        [self warn: ('<1p> message sends were not replaced' 
                                                                expandMacrosWith: refactoring messagesNotReplaced)].
                        self newSelectorList: self selectors.
                        self changedSelector]
!

moveMethod
	| newProtocol |
	self changeRequest ifFalse: [^self].
	newProtocol := Dialog 
				request: 'Enter new protocol or\class>protocol to copy' withCRs
				initialAnswer: LastMoveMethodProtocol
				for: self interfaceWindow.
	newProtocol isEmpty ifTrue: [^self].
	LastMoveMethodProtocol := newProtocol.
	self 
		moveMethods: self selectors
		to: newProtocol
		in: self selectedClass.
	self newProtocolList: self protocols.
	self changedSelector
!

moveMethod: aSelector to: aProtocol in: aClass 
        Cursor wait showWhile: 
                        [| moved classPart destClassName destClass protStart newProtocol |
                        newProtocol := aProtocol.
                        moved := false.
                        (newProtocol includes: $>)
                                ifTrue: 
                                        ["copy to another class"

                                        classPart := newProtocol copyUpTo: $>.
                                        destClassName := classPart copyUpTo: Character space.
                                        destClass := self environment at: destClassName asSymbol ifAbsent: [nil].
                                        destClass isBehavior ifFalse: [^nil].
                                        classPart size = destClassName size ifFalse: 
                                                        [(classPart size - destClassName size = 6
                                                                and: [(classPart copyFrom: classPart size - 5 to: classPart size) = ' class'])
                                                                        ifTrue: [destClass := destClass class]
                                                                        ifFalse: [^nil]].
                                        protStart := classPart size + 2.
                                        [(newProtocol at: protStart) = $ ] whileTrue: [protStart := protStart + 1].
                                        newProtocol := (newProtocol copyFrom: protStart to: newProtocol size) asSymbol.
                                        destClass == aClass ifFalse: 
                                                        [moved := true.
                                                        destClass compile: (aClass sourceCodeAt: aSelector)
                                                                classified: newProtocol
                                                                notifying: nil]]
                                ifFalse: 
                                        ["move within this class"

                                        destClass := aClass.
                                        newProtocol := newProtocol asSymbol].
                        moved ifFalse: 
                                        [(destClass organization categories includes: newProtocol)
                                                ifFalse: [destClass organization addCategory: newProtocol].
                                        destClass organization classify: aSelector under: newProtocol.
                                        RBParser isSmalltalkX ifTrue:[
                                            destClass addChangeRecordForMethodCategory:aSelector category:newProtocol printString.
                                        ] ifFalse:[
                                            self
                                                logProtocolChange: destClass name , ' organization classify: ' , aSelector printString
                                                                , ' under: ' , newProtocol printString.
                                            destClass reorganize.
                                        ].
                                        ]]

    "Modified: / 6.2.2000 / 17:33:34 / cg"
!

moveMethodToOtherObject
	| variable |
	self changeRequest ifFalse: [^self].
	variable := self selectVariableForMoveMethod.
	variable notNil ifTrue: 
			[self handleError: 
					[(MoveMethodRefactoring selector: self selector
						class: self selectedClass
						variable: variable) execute.
					self changedSelector]]
!

moveMethods: selectorCollection to: aProtocol in: aClass 
	(aProtocol includes: $>) 
		ifTrue: 
			[self 
				copyMethods: selectorCollection
				from: aClass
				toProtocol: aProtocol]
		ifFalse: 
			[self 
				recategorizeMethods: selectorCollection
				in: aClass
				to: aProtocol]
!

printOutMessage
	"Print the method."

	| stream |
	stream := TextStream on: (String new: 1000).
	self selectors
		do: [:each | self selectedClass printMethod: each on: stream].
	self hardcopyStream: stream
!

pushDownSelector
	self changeRequest ifFalse: [^self].
	self handleError: 
			[(PushDownMethodRefactoring pushDown: self selectors from: self selectedClass)
				execute.
			self newSelectorList: self selectors.
			self changedSelector]
!

pushUpSelector
	self changeRequest ifFalse: [^self].
	self handleError: 
			[(PushUpMethodRefactoring pushUp: self selectors from: self selectedClass)
				execute.
			self newSelectorList: self selectors.
			self changedSelector]
!

recategorizeMethods: selectorCollection in: aClass to: aProtocol 
	| newProtocol destClass |
	newProtocol := aProtocol.
	destClass := aClass.
	newProtocol := newProtocol asSymbol.
	(destClass organization categories includes: newProtocol) 
		ifFalse: [destClass organization addCategory: newProtocol].
	selectorCollection do: 
			[:each | 
			destClass organization classify: each under: newProtocol.
			self 
				logProtocolChange: destClass name , ' organization classify: ' 
						, each printString , ' under: ' 
						, newProtocol printString].
	destClass reorganize
!

removeMethod
	(self changeRequest and: 
			[self confirm: 'Are you certain that you want to remove all selected methods?'])
		ifFalse: [^self].
	self selectors
		do: [:each | self removeMethod: each in: self selectedClass].
	self newSelectorList: #().
	self changedSelector
!

removeMethod: aSelector in: aClass 
	self showWaitCursorWhile: [aClass removeSelector: aSelector]
!

removeMethodSafe
	self changeRequest ifFalse: [^self].
	self removeMethodsSafe: self selectors from: self selectedClass.
	self newSelectorList: self selectors.
	self changedSelector
!

removeMethodsSafe: sels from: cls 
	self
		handleError: [(RemoveMethodRefactoring removeMethods: sels from: cls) execute]
!

renameMethod
	| newSelector |
	self changeRequest ifFalse: [^self].
	newSelector := self renameMethod: self selector in: self selectedClass.
	newSelector isNil ifTrue: [^self].
	self newSelectorList: (Array with: newSelector).
	self changedSelector
!

renameMethod: aSelector in: aClass 
	| selector tree dialog args newArgs map |
	tree := aClass parseTreeFor: aSelector.
	tree isNil 
		ifTrue: 
			[self warn: 'Could not parse the method'.
			^nil].
	args := tree argumentNames.
	dialog := MethodNameDialog methodNameFor: args initial: aSelector.
	dialog open ifFalse: [^nil].
	selector := dialog methodName.
	newArgs := dialog arguments asOrderedCollection.
	map := (1 to: args size) collect: [:i | args indexOf: (newArgs at: i)].
	^self handleError: 
			[(RenameMethodRefactoring 
				renameMethod: aSelector
				in: aClass
				to: selector
				permuation: map) execute.
			selector asSymbol]
!

selectVariableForMoveMethod
	| parseTree nameList ignoreList |
	parseTree := self selectedClass parseTreeFor: self selector.
	parseTree isNil ifTrue: [^self warn: 'Could not parse sources'].
	nameList := OrderedCollection new.
	nameList
		add: '---- Arguments ----';
		addAll: parseTree argumentNames asSortedCollection;
		add: '---- Instance Variables ----'.
	ignoreList := OrderedCollection with: 1 with: nameList size.
	nameList addAll: self selectedClass allInstVarNames asSortedCollection.
	^self 
		choose: 'Select variable to move method into:'
		fromList: nameList
		values: nameList
		ignore: ignoreList
		initialSelection: nil
		lines: 8
		cancel: [nil]
! !

!BrowserNavigator methodsFor:'protocol drag and drop'!

canAcceptDropInProtocolListFrom: aDC 
	^#(#selector #protocol) includes: aDC key
!

canDropInProtocol: aDC 
	| aDict |
	aDict := aDC sourceData clientData.
	^(aDC key == #selector and: [(aDict at: #protocol ifAbsent: [self dropSelection: aDC])
			~~ (self dropSelection: aDC) or: [(aDict at: #class ifAbsent: [self className])
				~~ self className or: [(aDict at: #meta ifAbsent: [self isMeta])
					~~ self isMeta]]])
		or: [aDC key == #protocol and: [(aDict at: #protocol ifAbsent: [self dropSelection: aDC])
					~~ (self dropSelection: aDC) and: [(aDict at: #class ifAbsent: [nil])
						== self className and: [(aDict at: #meta ifAbsent: [nil])
							== self isMeta]]]]
!

doProtocolDrag: aController 
	self protocol notNil ifTrue: [self doDragAndDrop: #protocol for: aController]
!

dropProtocolUsing: aDragContext 
	| dataProtocols protocol |
	dataProtocols := self dropProtocolsFrom: aDragContext sourceData clientData.
	protocol := self dropSelection: aDragContext.
	dataProtocols isEmpty | protocol isNil ifTrue: [^#dropEffectNone].
	dataProtocols do: 
			[:each | 
			each == protocol ifFalse: 
					[self addProtocol: each
						before: protocol
						for: self selectedClass]].
	^#dropEffectMove
!

dropSelectorUsing: aDragContext 
	| dataClass protocol dataSelectors classNames |
	dataSelectors := self dropSelectorsFrom: aDragContext sourceData clientData.
	classNames := self dropClassNamesFrom: aDragContext sourceData clientData.
	(dataSelectors isEmpty or: [classNames size ~~ 1])
		ifTrue: [^#dropEffectNone].
	dataClass := Smalltalk at: classNames first ifAbsent: [nil].
	protocol := self dropSelection: aDragContext.
	(dataClass isNil | protocol isNil or: [self changeRequest])
		ifFalse: [^#dropEffectNone].
	(self dropMetaFrom: aDragContext sourceData clientData)
		ifTrue: [dataClass := dataClass class].
	dataSelectors do: 
			[:each | 
			dataClass == self selectedClass
				ifTrue: 
					[self moveMethod: each
						to: protocol
						in: dataClass]
				ifFalse: 
					[self moveMethod: each
						to: ('<1p>><2s>' expandMacrosWith: self selectedClass with: protocol)
						in: dataClass]].
	^dataClass == self selectedClass
		ifTrue: [#dropEffectMove]
		ifFalse: [#dropEffectCopy]
!

protocolDragEnter: aDragContext 
	(self canAcceptDropInProtocolListFrom: aDragContext)
		ifFalse: [^#dropEffectNone].
	aDragContext dropTarget clientData: (self initialDropStateFor: #protocolList).
	^#dropEffectMove
!

protocolDragOver: aDragContext 
	^(self canAcceptDropInProtocolListFrom: aDragContext)
		ifTrue: 
			[self showDropFeedbackForList: #protocolList in: aDragContext.
			(self canDropInProtocol: aDragContext)
				ifTrue: 
					[((aDragContext sourceData clientData at: #class ifAbsent: [self className])
						== self className and: 
								[(aDragContext sourceData clientData at: #meta ifAbsent: [self isMeta])
									== self isMeta])
						ifTrue: [#dropEffectMove]
						ifFalse: [#dropEffectCopy]]
				ifFalse: [#dropEffectNone]]
		ifFalse: [#dropEffectNone]
!

protocolDrop: aDragContext 
        (self canAcceptDropInProtocolListFrom: aDragContext)
                ifFalse: [^#dropEffectNone].
        ^[aDragContext key == #protocol
                ifTrue: [self dropProtocolUsing: aDragContext]
                ifFalse: [self dropSelectorUsing: aDragContext]]
                ensure: 
                        [self restoreListStateFrom: aDragContext clientData.
                        aDragContext clientData: nil.
                        self updateCategoryList]
!

protocolWantToDrag: aController 
	^self protocol notNil
! !

!BrowserNavigator methodsFor:'selector drag and drop'!

doSelectorDrag: aController 
	self selector isNil ifTrue: [^self].
	(self selectedClass includesSelector: self selector)
		ifFalse: [^Dialog warn: ('Selector <1s> no longer exists.' expandMacrosWith: self selector)
				for: self interfaceWindow].
	self doDragAndDrop: #selector for: aController
!

selectorWantToDrag: aController 
	^self selector notNil
! !

!BrowserNavigator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/BrowserNavigator.st,v 1.19 2009-09-22 10:20:00 cg Exp $'
! !

BrowserNavigator initialize!
