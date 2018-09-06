"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserNavigator subclass:#ClassSelectorNavigator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Navigator'
!

ClassSelectorNavigator comment:'ClassSelectorNavigator is a navigator that displays classes and selectors in list widgets, while the other two (application/category and protocol) are displayed in text widgets.'
!


!ClassSelectorNavigator class methodsFor:'interface specs'!

verticalWindowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ClassSelectorNavigator andSelector:#verticalWindowSpec
     ClassSelectorNavigator new openInterface:#verticalWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #verticalWindowSpec
	#window: 
       #(#WindowSpec
	  #label: 'Navigator'
	  #name: 'Navigator'
	  #min: #(#Point 40 20)
	  #bounds: #(#Rectangle 12 22 227 431)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#InputFieldSpec
	      #name: #categoryHolder
	      #layout: #(#LayoutFrame 2 0 2 0 -2 1 27 0)
	      #model: #categoryHolder
	      #menu: #categoryMenu
	      #isReadOnly: true
	      #acceptOnPointerLeave: false
	    )
	   #(#SequenceViewSpec
	      #name: #classList
	      #layout: #(#LayoutFrame 2 0 29 0 -2 1 -25 0.5)
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
	   #(#GroupBoxSpec
	      #name: 'GroupBox1'
	      #layout: #(#LayoutFrame 2 0 -23 0.5 -2 1 -1 0.5)
	    )
	   #(#RadioButtonSpec
	      #label: 'instance'
	      #name: #instance
	      #layout: #(#LayoutFrame 3 0 -22 0.5 0 0.5 -3 0.5)
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
	      #layout: #(#LayoutFrame 2 0.5 -22 0.5 -22 1 -3 0.5)
	      #model: #meta
	      #select: true
	      #callbacksSpec: 
	     #(#UIEventCallbackSubSpec
		#valueChangeSelector: #changedMeta
		#requestValueChangeSelector: #changeRequest
	      )
	    )
	   #(#InputFieldSpec
	      #name: #protocolHolder
	      #layout: #(#LayoutFrame 2 0 1 0.5 -2 1 26 0.5)
	      #model: #protocolHolder
	      #menu: #protocolMenu
	      #isReadOnly: true
	      #acceptOnPointerLeave: false
	    )
	   #(#SequenceViewSpec
	      #name: #selectorList
	      #layout: #(#LayoutFrame 2 0 28 0.5 -2 1 -2 1)
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

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ClassSelectorNavigator andSelector:#windowSpec
     ClassSelectorNavigator new openInterface:#windowSpec
     ClassSelectorNavigator open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
	#name: #windowSpec
	#window: 
       #(#WindowSpec
	  #label: 'Navigator'
	  #name: 'Navigator'
	  #bounds: #(#Rectangle 218 175 806 326)
	)
	#component: 
       #(#SpecCollection
	  #collection: #(
	   #(#InputFieldSpec
	      #name: #categoryHolder
	      #layout: #(#LayoutFrame 2 0 2 0 -1 0.5 27 0)
	      #model: #categoryHolder
	      #menu: #categoryMenu
	      #isReadOnly: true
	      #acceptOnPointerLeave: false
	    )
	   #(#SequenceViewSpec
	      #name: #classList
	      #layout: #(#LayoutFrame 2 0 29 0 -1 0.5 -25 1)
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
	   #(#GroupBoxSpec
	      #name: 'GroupBox1'
	      #layout: #(#LayoutFrame 2 0 -23 1 -1 0.5 -2 1)
	    )
	   #(#RadioButtonSpec
	      #label: 'instance'
	      #name: #instance
	      #layout: #(#LayoutFrame 3 0 -22 1 0 0.25 -3 1)
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
	      #layout: #(#LayoutFrame 2 0.25 -22 1 -22 0.5 -3 1)
	      #model: #meta
	      #select: true
	      #callbacksSpec: 
	     #(#UIEventCallbackSubSpec
		#valueChangeSelector: #changedMeta
		#requestValueChangeSelector: #changeRequest
	      )
	    )
	   #(#InputFieldSpec
	      #name: #protocolHolder
	      #layout: #(#LayoutFrame 1 0.5 2 0 -2 1 27 0)
	      #model: #protocolHolder
	      #menu: #protocolMenu
	      #isReadOnly: true
	      #acceptOnPointerLeave: false
	    )
	   #(#SequenceViewSpec
	      #name: #selectorList
	      #layout: #(#LayoutFrame 1 0.5 29 0 -2 1 -2 1)
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
! !

!ClassSelectorNavigator methodsFor:'accessing-browser'!

spec: verticalBoolean 
	self categoryList list: self environment categories asList.
	^verticalBoolean
		ifTrue: [self class verticalWindowSpec]
		ifFalse: [self class windowSpec]
! !

!ClassSelectorNavigator methodsFor:'accessing-category'!

newCategoryList: initialSelection
	self changedCategory
! !

!ClassSelectorNavigator methodsFor:'accessing-class'!

changedClass
	self updateLabels.
	super changedClass.
!

newClassListNoUpdate: initialSelections 
	| newList |
	newList := (List withAll: self environment classNames) sort;
				yourself.
	classList list: newList.
	classList selections: initialSelections.
	self updateClassMenu
! !

!ClassSelectorNavigator methodsFor:'accessing-class/inst switch'!

changedMeta
	self updateLabels.
	super changedMeta
! !

!ClassSelectorNavigator methodsFor:'accessing-protocol'!

newProtocolList: aProtocol 
	^self updateSelectorList
! !

!ClassSelectorNavigator methodsFor:'accessing-selector'!

changedSelector
	self updateLabels.
	super changedSelector
!

newSelectorList: initialSelections 
	selectorList list: (self classNames size == 1
				ifTrue: 
					[(List withAll: (self environment selectorsForClass: self selectedClass))
						sort;
						yourself]
				ifFalse: [List new]).
	selectorList selections: initialSelections.
	self updateSelectorMenu
! !

!ClassSelectorNavigator methodsFor:'initialize-release'!

initializeViews
	super initializeViews.
	self meta: false.
	self updateLabels.
	self changedCategory
!

on: aBrowser
	super on: aBrowser.
"       self categoryHolder value: nil.
	self protocolHolder value: nil."
	self meta: false.
	self updateLabels.
	self changedCategory
! !

!ClassSelectorNavigator methodsFor:'private'!

getSpec: verticalBoolean 
	^verticalBoolean
		ifTrue: [self class verticalWindowSpec]
		ifFalse: [self class windowSpec]
!

setState: aNavigatorState updateClasses: aBoolean 
	super setState: aNavigatorState updateClasses: aBoolean.
	aNavigatorState selectedClass notNil
		ifTrue: [self newSelectorList: aNavigatorState selectors].
	self updateLabels
!

updateLabels
	| class |
	class := self selectedClass.
	class notNil
		ifTrue: 
			[self protocolList list: (self environment protocolsFor: class) asList.
			self protocolHolder value: (self environment whichProtocolIncludes: self selector in: class)]
		ifFalse: [self protocolHolder value: nil].
	self categoryHolder value: (class isNil
			ifTrue: [nil]
			ifFalse: [self environment whichCategoryIncludes: self className]).
	self updateCategoryMenu.
	self updateProtocolMenu
! !

!ClassSelectorNavigator methodsFor:'private-class'!

clearToClass
	self changeRequest ifFalse: [^self].
	self newSelectorList: #().
	self changedSelector
! !

!ClassSelectorNavigator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/ClassSelectorNavigator.st,v 1.7 2003-09-23 10:46:59 cg Exp $'
! !
