"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Navigator subclass:#EnvironmentEditor
	instanceVariableNames:'selectedEnvironment'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

EnvironmentEditor comment:'EnvironmentEditor is an interface for selecting classes to perform some action on (e.g., rewrite tool, browsing, etc.).

Instance Variables:
	environment     <BrowserEnvironment>    the environment from which selections are made
	selectedEnvironment     <LimitedEnvironment>    the environment that was selected by the user'
!


!EnvironmentEditor class methodsFor:'interface specs'!

classWindowSpec
    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX ]) ifTrue:[
        ^ self classWindowSpecForSTX
    ].
    ^ self classWindowSpecForVW
!

classWindowSpecForSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:EnvironmentEditor andSelector:#classWindowSpec
     EnvironmentEditor new openInterface:#classWindowSpec
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #classWindowSpec
        #window: 
       #(#WindowSpec
          #label: 'Environment Editor'
          #name: 'Environment Editor'
          #bounds: #(#Rectangle 12 22 650 502)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#SequenceViewSpec
              #name: #categoryList
              #layout: #(#LayoutFrame 10 0 25 0 -5 0.5 0 0.5)
              #model: #categoryList
              #menu: #categoryMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #useModifierKeys: true
            )
           #(#SequenceViewSpec
              #name: #classList
              #layout: #(#LayoutFrame 0 0.5 25 0 -10 1 0 0.5)
              #model: #classList
              #menu: #classMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #useModifierKeys: true
            )
           #(#SequenceViewSpec
              #name: #protocolList
              #layout: #(#LayoutFrame 10 0 5 0.5 -5 0.5 -10 1)
              #flags: 29
              #model: #protocolList
              #menu: #protocolMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #useModifierKeys: true
            )
           #(#SequenceViewSpec
              #name: #selectorList
              #layout: #(#LayoutFrame 0 0.5 5 0.5 -10 1 -35 1)
              #flags: 29
              #model: #selectorList
              #menu: #selectorMenu
              #hasHorizontalScrollBar: true
              #hasVerticalScrollBar: true
              #miniScrollerHorizontal: true
              #isMultiSelect: true
              #useIndex: false
              #useModifierKeys: true
            )
           #(#LabelSpec
              #label: 'Category:'
              #name: 'Label1'
              #layout: #(#Point 10 0)
            )
           #(#LabelSpec
              #label: 'Class:'
              #name: 'Label2'
              #layout: #(#LayoutOrigin 5 0.5 0 0)
            )
           #(#RadioButtonSpec
              #label: 'instance'
              #name: 'RadioButton1'
              #layout: #(#AlignmentOrigin 5 0.5 -10 1 0 1)
              #model: #meta
              #select: false
            )
           #(#RadioButtonSpec
              #label: 'class'
              #name: 'RadioButton2'
              #layout: #(#AlignmentOrigin 0 0.75 -10 1 0 1)
              #model: #meta
              #select: true
            )
           )
         
        )
      )
!

classWindowSpecForVW
        "UIPainter new openOnClass: self andSelector: #classWindowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Environment Editor' 
                        #bounds: #(#Rectangle 267 482 905 962 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#SequenceViewSpec 
                                        #layout: #(#LayoutFrame 10 0 25 0 -5 0.5 -10 1 ) 
                                        #name: #categoryList 
                                        #model: #categoryList 
                                        #menu: #categoryMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#SequenceViewSpec 
                                        #layout: #(#LayoutFrame 5 0.5 25 0 -10 1 -35 1 ) 
                                        #name: #classList 
                                        #model: #classList 
                                        #menu: #classMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#SequenceViewSpec 
                                        #layout: #(#LayoutFrame 10 0 25 0.5 -5 0.5 -10 1 ) 
                                        #name: #protocolList 
                                        #flags: 29 
                                        #model: #protocolList 
                                        #menu: #protocolMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#SequenceViewSpec 
                                        #layout: #(#LayoutFrame 5 0.5 25 0.5 -10 1 -10 1 ) 
                                        #name: #selectorList 
                                        #flags: 29 
                                        #model: #selectorList 
                                        #menu: #selectorMenu 
                                        #multipleSelections: true 
                                        #useModifierKeys: true 
                                        #selectionType: #highlight ) 
                                #(#LabelSpec 
                                        #layout: #(#Point 10 0 ) 
                                        #label: 'Category:' ) 
                                #(#LabelSpec 
                                        #layout: #(#LayoutOrigin 5 0.5 0 0 ) 
                                        #label: 'Class:' ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#AlignmentOrigin 5 0.5 -10 1 0 1 ) 
                                        #model: #meta 
                                        #label: 'instance' 
                                        #select: false ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#AlignmentOrigin 0 0.75 -10 1 0 1 ) 
                                        #model: #meta 
                                        #label: 'class' 
                                        #select: true ) ) ) )
!

windowSpec
	"UIPainter new openOnClass: self andSelector: #windowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Environment Editor' 
			#bounds: #(#Rectangle 156 214 794 694 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 10 0 25 0 -5 0.5 -5 0.5 ) 
					#name: #categoryList 
					#model: #categoryList 
					#menu: #categoryMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 5 0.5 25 0 -10 1 -30 0.5 ) 
					#name: #classList 
					#model: #classList 
					#menu: #classMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 10 0 25 0.5 -5 0.5 -10 1 ) 
					#name: #protocolList 
					#model: #protocolList 
					#menu: #protocolMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#SequenceViewSpec 
					#layout: #(#LayoutFrame 5 0.5 25 0.5 -10 1 -10 1 ) 
					#name: #selectorList 
					#model: #selectorList 
					#menu: #selectorMenu 
					#multipleSelections: true 
					#useModifierKeys: true 
					#selectionType: #highlight ) 
				#(#LabelSpec 
					#layout: #(#Point 10 0 ) 
					#label: 'Category:' ) 
				#(#LabelSpec 
					#layout: #(#LayoutOrigin 5 0.5 0 0 ) 
					#label: 'Class:' ) 
				#(#LabelSpec 
					#layout: #(#LayoutOrigin 10 0 0 0.5 ) 
					#label: 'Protocol:' ) 
				#(#LabelSpec 
					#layout: #(#LayoutOrigin 5 0.5 0 0.5 ) 
					#label: 'Selector:' ) 
				#(#RadioButtonSpec 
					#layout: #(#AlignmentOrigin 5 0.5 -5 0.5 0 1 ) 
					#model: #meta 
					#label: 'instance' 
					#select: false ) 
				#(#RadioButtonSpec 
					#layout: #(#AlignmentOrigin 0 0.75 -5 0.5 0 1 ) 
					#model: #meta 
					#label: 'class' 
					#select: true ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame -30 1 -25 0.5 -10 1 -5 0.5 ) 
					#name: #clearToClass 
					#model: #clearToClass 
					#label: '^' ) ) ) )
! !

!EnvironmentEditor class methodsFor:'resources'!

categoryMenu
	"MenuEditor new openOnClass: self andSelector: #categoryMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'add' 
				#nameKey: #checkCategory 
				#value: #checkCategory ) 
			#(#MenuItem 
				#rawLabel: 'remove' 
				#nameKey: #uncheckCategory 
				#value: #uncheckCategory ) 
			#(#MenuItem 
				#rawLabel: 'add all...' 
				#nameKey: #checkAllCategories 
				#value: #checkAllCategories ) 
			#(#MenuItem 
				#rawLabel: 'remove all...' 
				#nameKey: #uncheckAllCategories 
				#value: #uncheckAllCategories ) 
			#(#MenuItem 
				#rawLabel: 'add from change set' 
				#value: #checkChangeSet ) 
			#(#MenuItem 
				#rawLabel: 'find class...' 
				#nameKey: #findClass 
				#value: #findClass ) ) #(2 2 1 1 ) nil ) decodeAsLiteralArray
!

classMenu
	"MenuEditor new openOnClass: self andSelector: #classMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'add' 
				#nameKey: #checkClass 
				#value: #checkClass ) 
			#(#MenuItem 
				#rawLabel: 'remove' 
				#nameKey: #uncheckClass 
				#value: #uncheckClass ) 
			#(#MenuItem 
				#rawLabel: 'add all...' 
				#nameKey: #checkAllClasses 
				#value: #checkAllClasses ) 
			#(#MenuItem 
				#rawLabel: 'remove all...' 
				#nameKey: #uncheckAllClasses 
				#value: #uncheckAllClasses ) 
			#(#MenuItem 
				#rawLabel: 'add superclasses' 
				#nameKey: #checkSuperclasses 
				#value: #checkSuperclasses ) 
			#(#MenuItem 
				#rawLabel: 'remove superclasses' 
				#nameKey: #uncheckSuperclasses 
				#value: #uncheckSuperclasses ) 
			#(#MenuItem 
				#rawLabel: 'add subclasses' 
				#nameKey: #checkSubclasses 
				#value: #checkSubclasses ) 
			#(#MenuItem 
				#rawLabel: 'remove subclasses' 
				#nameKey: #uncheckSubclasses 
				#value: #uncheckSubclasses ) ) #(2 2 2 2 ) nil ) decodeAsLiteralArray
!

protocolMenu
	"MenuEditor new openOnClass: self andSelector: #protocolMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'add' 
				#nameKey: #checkProtocol 
				#value: #checkProtocol ) 
			#(#MenuItem 
				#rawLabel: 'remove' 
				#nameKey: #uncheckProtocol 
				#value: #uncheckProtocol ) 
			#(#MenuItem 
				#rawLabel: 'add all...' 
				#nameKey: #checkAllProtocols 
				#value: #checkAllProtocols ) 
			#(#MenuItem 
				#rawLabel: 'remove all...' 
				#nameKey: #uncheckAllProtocols 
				#value: #uncheckAllProtocols ) 
			#(#MenuItem 
				#rawLabel: 'find method...' 
				#nameKey: #findMethod 
				#value: #findMethodAndSelectAlphabetic ) ) #(2 2 1 ) nil ) decodeAsLiteralArray
!

selectorMenu
	"MenuEditor new openOnClass: self andSelector: #selectorMenu"

	<resource: #menu>
	^#(#Menu #(
			#(#MenuItem 
				#rawLabel: 'add' 
				#nameKey: #checkSelector 
				#value: #checkSelector ) 
			#(#MenuItem 
				#rawLabel: 'remove' 
				#nameKey: #uncheckSelector 
				#value: #uncheckSelector ) 
			#(#MenuItem 
				#rawLabel: 'add all...' 
				#nameKey: #checkAllSelectors 
				#value: #checkAllSelectors ) 
			#(#MenuItem 
				#rawLabel: 'remove all...' 
				#nameKey: #uncheckAllSelectors 
				#value: #uncheckAllSelectors ) 
			#(#MenuItem 
				#rawLabel: 'add all implementors' 
				#nameKey: #checkImplementors 
				#value: #checkImplementors ) 
			#(#MenuItem 
				#rawLabel: 'remove all implementors' 
				#nameKey: #uncheckImplementors 
				#value: #uncheckImplementors ) 
			#(#MenuItem 
				#rawLabel: 'add senders' 
				#nameKey: #checkSenders 
				#value: #checkSenders ) 
			#(#MenuItem 
				#rawLabel: 'remove senders' 
				#nameKey: #uncheckSenders 
				#value: #uncheckSenders ) ) #(2 2 2 2 ) nil ) decodeAsLiteralArray
! !

!EnvironmentEditor methodsFor:'accessing'!

environment
	^environment
!

menu
	^
	[| menu |
	menu := Menu new.
	(builder componentAt: #categoryList) isVisible ifTrue: 
			[menu addItem: ((MenuItem labeled: 'Ca&tegory')
						submenu: [self initializeMenu: categoryMenuHolder value])].
	(builder componentAt: #classList) isVisible ifTrue: 
			[menu addItem: ((MenuItem labeled: '&Class')
						submenu: [self initializeMenu: classMenuHolder value])].
	(builder componentAt: #protocolList) isVisible ifTrue: 
			[menu addItem: ((MenuItem labeled: '&Protocol')
						submenu: [self initializeMenu: protocolMenuHolder value])].
	(builder componentAt: #selectorList) isVisible ifTrue: 
			[menu addItem: ((MenuItem labeled: '&Selector')
						submenu: [self initializeMenu: selectorMenuHolder value])].
	menu]
!

selectedEnvironment
	^selectedEnvironment
! !

!EnvironmentEditor methodsFor:'actions'!

checkAllCategories
	| categoryMatch |
	categoryMatch := Dialog request: 'Select categories matching:' initialAnswer: ''.
	categoryMatch isEmpty ifTrue: [^self].
	self updateDisplayAfter: [Cursor wait showWhile: [self categoryList list do: [:each | (categoryMatch match: each)
					ifTrue: [self checkCategory: each]]]]
!

checkAllClasses
	| classMatch |
	classMatch := Dialog request: 'Select classes matching:' initialAnswer: ''.
	classMatch isEmpty ifTrue: [^self].
	self updateDisplayAfter: 
			[Cursor wait showWhile: 
					[self classList list
						do: [:each | (classMatch match: each) ifTrue: [self checkClass: each]]]]
!

checkAllProtocols
	| protocolMatch |
	protocolMatch := Dialog request: 'Select protocols matching:' initialAnswer: ''.
	protocolMatch isEmpty ifTrue: [^self].
	self updateDisplayAfter: 
			[Cursor wait showWhile: 
					[self protocolList list
						do: [:each | (protocolMatch match: each) ifTrue: [self checkProtocol: each]]]]
!

checkAllSelectors
	| selectorMatch |
	selectorMatch := Dialog request: 'Select selectors matching:' initialAnswer: ''.
	selectorMatch isEmpty ifTrue: [^self].
	self updateDisplayAfter: 
			[Cursor wait showWhile: 
					[self selectorList list do: 
							[:each | 
							(selectorMatch match: each)
								ifTrue: [selectedEnvironment addClass: self selectedClass selector: each]]]]
!

checkCategory
	self updateDisplayAfter: [self categories do: [:each | self checkCategory: each]]
!

checkChangeSet
	self updateDisplayAfter: 
			[Cursor wait showWhile: 
					[ChangeSet current changedClasses do: 
							[:each | 
							each isMeta
								ifTrue: [selectedEnvironment addClass: each]
								ifFalse: 
									[selectedEnvironment addClass: each;
										addClass: each class]]]]
!

checkClass
	self updateDisplayAfter: 
			[self selectedClasses do: [:each | selectedEnvironment addClass: each]]
!

checkImplementors
	self updateDisplayAfter: 
			[environment classesDo: 
					[:class | 
					self selectors do: 
							[:selector | 
							(environment includesSelector: selector in: class)
								ifTrue: [selectedEnvironment addClass: class selector: selector]]]]
!

checkProtocol
	self updateDisplayAfter: 
			[| class |
			class := self selectedClass.
			self protocols do: 
					[:each | 
					(environment selectorsFor: each in: class)
						do: [:sel | selectedEnvironment addClass: class selector: sel]]]
!

checkSelector
	self updateDisplayAfter: 
			[| class |
			class := self selectedClass.
			self selectors
				do: [:each | selectedEnvironment addClass: class selector: each]]
!

checkSenders
	self updateDisplayAfter: 
			[environment classesDo: 
					[:class | 
					self selectors do: 
							[:selector | 
							(environment selectorsForClass: class) do: 
									[:each | 
									((class compiledMethodAt: each) refersToLiteral: selector)
										ifTrue: [selectedEnvironment addClass: class selector: each]]]]]
!

checkSubclasses
	self updateDisplayAfter: 
			[self selectedClasses
				do: [:each | each allSubclasses do: [:sub | selectedEnvironment addClass: sub]]]
!

checkSuperclasses
	self updateDisplayAfter: 
			[self selectedClasses
				do: [:each | each allSuperclasses do: [:sup | selectedEnvironment addClass: sup]]]
!

uncheckAllCategories
	| categoryMatch |
	categoryMatch := Dialog request: 'Deselect categories matching:' initialAnswer: ''.
	categoryMatch isEmpty ifTrue: [^self].
	self updateDisplayAfter: [Cursor wait showWhile: [self categoryList list do: [:each | (categoryMatch match: each)
					ifTrue: [self uncheckCategory: each]]]]
!

uncheckAllClasses
	| classMatch |
	classMatch := Dialog request: 'Deselect classes matching:' initialAnswer: ''.
	classMatch isEmpty ifTrue: [^self].
	self updateDisplayAfter: 
			[Cursor wait showWhile: 
					[self classList list
						do: [:each | (classMatch match: each) ifTrue: [self uncheckClass: each]]]]
!

uncheckAllProtocols
	| protocolMatch |
	protocolMatch := Dialog request: 'Deselect protocols matching:' initialAnswer: ''.
	protocolMatch isEmpty ifTrue: [^self].
	self updateDisplayAfter: 
			[Cursor wait showWhile: 
					[self protocolList list
						do: [:each | (protocolMatch match: each) ifTrue: [self uncheckProtocol: each]]]]
!

uncheckAllSelectors
	| selectorMatch |
	selectorMatch := Dialog request: 'Deselect selectors matching:' initialAnswer: ''.
	selectorMatch isEmpty ifTrue: [^self].
	self updateDisplayAfter: 
			[Cursor wait showWhile: 
					[self selectorList list do: 
							[:each | 
							(selectorMatch match: each)
								ifTrue: [selectedEnvironment removeClass: self selectedClass selector: each]]]]
!

uncheckCategory
	self updateDisplayAfter: [self categories do: [:each | self uncheckCategory: each]]
!

uncheckClass
	self updateDisplayAfter: 
			[self selectedClasses do: [:each | selectedEnvironment removeClass: each]]
!

uncheckImplementors
	self updateDisplayAfter: 
			[environment classesDo: 
					[:class | 
					self selectors do: 
							[:selector | 
							(environment includesSelector: selector in: class)
								ifTrue: [selectedEnvironment removeClass: class selector: selector]]]]
!

uncheckProtocol
	self updateDisplayAfter: 
			[| class |
			class := self selectedClass.
			self protocols do: 
					[:each | 
					(environment selectorsFor: each in: class)
						do: [:sel | selectedEnvironment removeClass: class selector: sel]]]
!

uncheckSelector
	self updateDisplayAfter: 
			[| class |
			class := self selectedClass.
			self selectors
				do: [:each | selectedEnvironment removeClass: class selector: each]]
!

uncheckSenders
	self updateDisplayAfter: 
			[environment classesDo: 
					[:class | 
					self selectors do: 
							[:selector | 
							(environment selectorsForClass: class) do: 
									[:each | 
									((class compiledMethodAt: each) refersToLiteral: selector)
										ifTrue: [selectedEnvironment removeClass: class selector: each]]]]]
!

uncheckSubclasses
	self updateDisplayAfter: 
			[self selectedClasses
				do: [:class | class allSubclasses do: [:each | selectedEnvironment removeClass: each]]]
!

uncheckSuperclasses
	self updateDisplayAfter: 
			[self selectedClasses do: 
					[:class | 
					class allSuperclasses do: [:each | selectedEnvironment removeClass: each]]]
! !

!EnvironmentEditor methodsFor:'changing'!

changedMeta
	super changedMeta.
	self invalidateComponent: #classList
! !

!EnvironmentEditor methodsFor:'initialize-release'!

environment: anEnvironment 
	self updateDisplayAfter: [selectedEnvironment := anEnvironment]
!

initialize
	super initialize.
	environment := BrowserEnvironment new.
	selectedEnvironment := SelectorEnvironment new.
	self categoryList selectionIndexHolder onChangeSend: #changedCategory
		to: self.
	self classList selectionIndexHolder onChangeSend: #changedClass to: self.
	self protocolList selectionIndexHolder onChangeSend: #changedProtocol
		to: self.
	self selectorList selectionIndexHolder onChangeSend: #updateSelectorMenu
		to: self.
	self meta onChangeSend: #changedMeta to: self
!

selectedEnvironment: anEnvironment 
	self updateDisplayAfter: [selectedEnvironment := anEnvironment]
! !

!EnvironmentEditor methodsFor:'interface opening'!

postBuildCategoryList: aBuilder 
        | visualBlock |

        RBParser isSmalltalkX ifTrue:[
            visualBlock := [:v :i | |item|

                            item := (v sequence at: i).

                            (selectedEnvironment includesCategory: item)
                            ifTrue:[
                                (LabelAndIcon string:item) beCheckMark
                            ] ifFalse:[
                                item
                            ].
                           ].

            ((aBuilder componentAt: #categoryList) widget)
                    visualBlock: visualBlock; 
                    selectedVisualBlock:visualBlock.
            ^ self
        ].
        visualBlock := 
                        [:v :i | 
                        (selectedEnvironment includesCategory: (v sequence at: i))
                                ifTrue: 
                                        [(LabelAndIcon with: (v displayStringAt: i) attributes: v textStyle)
                                                beCheckMark]
                                ifFalse: 
                                        [Label with: (v displayStringAt: i)
                                                attributes: v textStyle
                                                offset: 16 @ 0]].
        ((aBuilder componentAt: #categoryList) widget)
                visualBlock: (self createVisualBlockFrom: visualBlock);
                selectedVisualBlock: (self createSelectedVisualBlockFrom: visualBlock)

    "Modified: / 4.2.2000 / 10:09:24 / cg"
!

postBuildClassList: aBuilder 
        | visualBlock |

        RBParser isSmalltalkX ifTrue:[
            visualBlock := [:v :i | |item class|

                            item := (v sequence at: i).

                            class := selectedEnvironment at:item ifAbsent: [nil].

                            (class notNil 
                            and:[self meta value
                                    ifTrue: [selectedEnvironment includesClass: class class]
                                    ifFalse: [selectedEnvironment includesClass: class]])
                            ifTrue:[
                                (LabelAndIcon string:item) beCheckMark
                            ] ifFalse:[
                                item
                            ].
                           ].

            ((aBuilder componentAt: #classList) widget)
                    visualBlock: visualBlock; 
                    selectedVisualBlock:visualBlock.
            ^ self
        ].

        visualBlock := 
                        [:v :i | 
                        | class |
                        class := selectedEnvironment at: (v sequence at: i) ifAbsent: [nil].
                        (class notNil and: 
                                        [self meta value
                                                ifTrue: [selectedEnvironment includesClass: class class]
                                                ifFalse: [selectedEnvironment includesClass: class]])
                                ifTrue: 
                                        [(LabelAndIcon with: (v displayStringAt: i) attributes: v textStyle)
                                                beCheckMark]
                                ifFalse: 
                                        [Label with: (v displayStringAt: i)
                                                attributes: v textStyle
                                                offset: 16 @ 0]].
        ((aBuilder componentAt: #classList) widget)
                visualBlock: (self createVisualBlockFrom: visualBlock);
                selectedVisualBlock: (self createSelectedVisualBlockFrom: visualBlock)

    "Modified: / 4.2.2000 / 11:13:48 / cg"
!

postBuildProtocolList: aBuilder 
        | visualBlock |

        RBParser isSmalltalkX ifTrue:[
            visualBlock := [:v :i | |item|
                            item := (v sequence at: i).

                            (selectedEnvironment 
                                includesProtocol:item
                                in: self selectedClass)
                            ifTrue:[
                                (LabelAndIcon string:item) beCheckMark
                            ] ifFalse:[
                                item
                            ].
                           ].

            ((aBuilder componentAt: #protocolList) widget)
                    visualBlock: visualBlock; 
                    selectedVisualBlock:visualBlock.
            ^ self
        ].

        visualBlock := 
                        [:v :i | 
                        (selectedEnvironment includesProtocol: (v sequence at: i)
                                in: self selectedClass)
                                        ifTrue: 
                                                [(LabelAndIcon with: (v displayStringAt: i) attributes: v textStyle)
                                                        beCheckMark]
                                        ifFalse: 
                                                [Label with: (v displayStringAt: i)
                                                        attributes: v textStyle
                                                        offset: 16 @ 0]].
        ((aBuilder componentAt: #protocolList) widget)
                visualBlock: (self createVisualBlockFrom: visualBlock);
                selectedVisualBlock: (self createSelectedVisualBlockFrom: visualBlock)

    "Modified: / 4.2.2000 / 11:14:57 / cg"
!

postBuildSelectorList: aBuilder 
        | visualBlock selectedVisualBlock |

        RBParser isSmalltalkX ifTrue:[
            visualBlock := [:v :i | |item|
                            item := (v sequence at: i).

                            (selectedEnvironment 
                                includesSelector: item
                                in: self selectedClass)
                            ifTrue:[
                                (LabelAndIcon string:item) beCheckMark
                            ] ifFalse:[
                                item
                            ].
                           ].

            ((aBuilder componentAt: #selectorList) widget)
                    visualBlock: visualBlock; 
                    selectedVisualBlock:visualBlock.
            ^ self
        ].

        visualBlock := 
                        [:v :i | 
                        (selectedEnvironment includesSelector: (v sequence at: i)
                                in: self selectedClass)
                                        ifTrue: 
                                                [(LabelAndIcon with: (v displayStringAt: i) attributes: v textStyle)
                                                        beCheckMark]
                                        ifFalse: 
                                                [Label with: (v displayStringAt: i)
                                                        attributes: v textStyle
                                                        offset: 16 @ 0]].
        ((aBuilder componentAt: #selectorList) widget)
                visualBlock: (self createVisualBlockFrom: visualBlock);
                selectedVisualBlock: (self createSelectedVisualBlockFrom: visualBlock)

    "Modified: / 4.2.2000 / 11:15:41 / cg"
!

postBuildWith: aBuilder 
	super postBuildWith: aBuilder.
	self postBuildCategoryList: aBuilder.
	self postBuildClassList: aBuilder.
	self postBuildProtocolList: aBuilder.
	self postBuildSelectorList: aBuilder.
	self categoryList list: (List withAll: environment categories)
! !

!EnvironmentEditor methodsFor:'menus'!

updateCategoryMenu
	self category isNil
		ifTrue: [self disableMenu: categoryMenuHolder value except: #('add all...' 'remove all...' 'add from change set' 'find class...')]
		ifFalse: [self enableMenu: categoryMenuHolder value]
!

updateClassMenu
	self category isNil
		ifTrue: [self disableMenu: classMenuHolder value]
		ifFalse: [self selectedClass isNil
				ifTrue: [self disableMenu: classMenuHolder value except: #('add all...' 'remove all...')]
				ifFalse: [self enableMenu: classMenuHolder value]]
!

updateProtocolMenu
	self selectedClass isNil
		ifTrue: [self disableMenu: protocolMenuHolder value]
		ifFalse: [self protocol isNil
				ifTrue: [self disableMenu: protocolMenuHolder value except: #('add all...' 'remove all...' 'find method...')]
				ifFalse: [self enableMenu: protocolMenuHolder value]]
!

updateSelectorMenu
	self protocol isNil
		ifTrue: [self disableMenu: selectorMenuHolder value]
		ifFalse: [self selector isNil
				ifTrue: [self disableMenu: selectorMenuHolder value except: #('add all...' 'remove all...')]
				ifFalse: [self enableMenu: selectorMenuHolder value]]
! !

!EnvironmentEditor methodsFor:'private'!

checkCategory: aCategory 
	(environment classNamesFor: aCategory)
		do: 
			[:each | 
			| class |
			class := environment at: each ifAbsent: [nil].
			class notNil ifTrue: [selectedEnvironment addClass: class; addClass: class class]]
!

checkClass: aName 
	| class |
	class := self classForName: aName.
	class isNil ifTrue: [^self].
	self isMeta ifTrue: [class := class class].
	selectedEnvironment addClass: class
!

checkProtocol: aProtocol 
	| class |
	class := self selectedClass.
	(environment selectorsFor: aProtocol in: class)
		do: [:each | selectedEnvironment addClass: class selector: each]
!

uncheckCategory: aCategory 
	(environment classNamesFor: aCategory)
		do: 
			[:each | 
			| class |
			class := environment at: each ifAbsent: [nil].
			class notNil ifTrue: [selectedEnvironment removeClass: class; removeClass: class class]]
!

uncheckClass: aName 
	| class |
	class := self classForName: aName.
	class isNil ifTrue: [^self].
	self isMeta ifTrue: [class := class class].
	selectedEnvironment removeClass: class
!

uncheckProtocol: aProtocol 
	| class |
	class := self selectedClass.
	(environment selectorsFor: aProtocol in: class)
		do: [:each | selectedEnvironment removeClass: class selector: each]
!

updateDisplayAfter: aBlock 
	aBlock value.
	builder isNil ifTrue: [^self].
	#(#categoryList #classList #protocolList #selectorList)
		do: [:each | self invalidateComponent: each]
! !

!EnvironmentEditor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/EnvironmentEditor.st,v 1.12 2003-09-23 10:47:56 cg Exp $'
! !
