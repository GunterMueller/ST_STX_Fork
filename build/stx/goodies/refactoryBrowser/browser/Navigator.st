"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserApplicationModel subclass:#Navigator
	instanceVariableNames:'categoryList categoryMenuHolder classList classMenuHolder
		selectorMenuHolder protocolMenuHolder selectorList metaHolder
		protocolList environment'
	classVariableNames:'LastProtocol SortProtocols'
	poolDictionaries:''
	category:'Refactory-Navigator'
!

Navigator comment:'Navigator is an abstract class that defines the interface that displays the classes/methods of an BrowserEnvironment. Its subclasses define what actions can be taken for the different selections.

Instance Variables:
	categoryList    <SelectionInList on: Symbol>    the list of categories shown
	categoryMenuHolder      <ValueHolder on: Menu>  the category menu
	classList       <SelectionInList on: Symbol>    the list of class names shown
	classMenuHolder <ValueHolder on: Menu>  the class menu
	metaHolder      <ValueHolder on: Boolean>       are we looking at the metaclass?
	protocolList    <SelectionInList on: Symbol>    the list of protocols shown
	protocolMenuHolder      <ValueHolder on: Menu>  the protocol menu
	selectorList    <SelectionInList on: Symbol>    the list of selectors shown
	selectorMenuHolder      <ValueHolder on: Menu>  the selector menu
	environment     <BrowserEnvironment>    the classes the navigator is looking at

Class Variables:
	LastProtocol    <Symbol | nil>  the last protocol selected by the user
	SortProtocols   <Boolean>       should we sort the protocols?'
!


!Navigator class methodsFor:'class initialization'!

initialize
	"self initialize"

	LastProtocol := ''.
	SortProtocols := false
! !

!Navigator methodsFor:'accessing'!

beHierarchy
!

environment
	^environment
!

environment: aBrowserEnvironment
	environment := aBrowserEnvironment
!

getState
	| state |
	state := self navigatorStateClass new.
	state categories: self categories.
	state selectedClasses: self selectedClasses.
	state protocols: self protocols.
	state selectors: self selectors.
	^state
!

navigatorStateClass
	^NavigatorState
!

setState: aNavigatorState 
	self setState: aNavigatorState updateClasses: false
! !

!Navigator methodsFor:'accessing-category'!

categories
	^self categoryList selections
!

category
	^self categories detect: [:each | true]
		ifNone: [nil]
!

changedCategory
	self updateClassList.
	self updateCategoryMenu.
	self changed: #category with: self category
!

newCategoryList: initialSelections 
	self newCategoryListNoUpdate: initialSelections.
	self updateClassList
!

newCategoryListNoUpdate: initialSelections 
	self categoryList list: (List withAll: self environment categories).
	self categoryList selections: initialSelections.
	self updateCategoryMenu
! !

!Navigator methodsFor:'accessing-class'!

changedClass
	self updateProtocolList.
	self updateClassMenu.
	self changed: #class with: self selectedClass
!

classForName: className 
	| class |
	className isNil ifTrue: [^nil].
	class := Smalltalk at: className ifAbsent: [nil].
	class isBehavior ifFalse: [^nil].
	^class
!

className
	^self classNames detect: [:each | true]
		ifNone: [nil]
!

classNames
	^self classList selections
!

newClassList: initialSelections 
	self newClassListNoUpdate: initialSelections.
	self updateProtocolList
!

newClassListNoUpdate: initialSelections 
	| newList |
	newList := Set new.
	self categories do: [:each | newList addAll: (self environment classNamesFor: each)].
	self classList list: newList asSortedCollection asList.
	self classList selections: initialSelections.
	self updateClassMenu
!

nonMetaClass
	^self classForName: self className
!

nonMetaClasses
	| names classes |
	names := self classNames.
	classes := OrderedCollection new: names size.
	names
		do: 
			[:each | 
			| class |
			class := self classForName: each.
			class notNil ifTrue: [classes add: class]].
	^classes
!

selectedClass
	| class |
	class := self nonMetaClass.
	^(class notNil and: [self isMeta]) ifTrue: [class class] ifFalse: [class]
!

selectedClasses
	| nonMetaClasses |
	nonMetaClasses := self nonMetaClasses.
	^self isMeta
		ifTrue: [nonMetaClasses collect: [:each | each class]]
		ifFalse: [nonMetaClasses]
!

updateClassList
	self newClassList: self classNames
! !

!Navigator methodsFor:'accessing-class/inst switch'!

changedMeta
	self updateProtocolList.
	self changed: #meta with: self isMeta
!

isMeta
	^self meta value
!

meta: aBoolean
	self meta value: aBoolean
! !

!Navigator methodsFor:'accessing-protocol'!

changedProtocol
	| protocol |
	protocol := self protocol.
	protocol notNil ifTrue: [LastProtocol := protocol].
	self updateSelectorList.
	self updateProtocolMenu.
	self changed: #protocol with: protocol
!

newProtocolList: initialSelections 
	self newProtocolListNoUpdate: initialSelections.
	self updateSelectorList
!

newProtocolListNoUpdate: initialSelections 
	| class protocols |
	class := self selectedClass.
	protocols := (class notNil 
				and: [self category notNil and: [self classNames size = 1]]) 
					ifTrue: [self environment protocolsFor: class]
					ifFalse: [#()].
	SortProtocols ifTrue: [protocols := protocols asSortedCollection].
	protocolList list: protocols asList.
	protocolList selections: initialSelections.
	self updateProtocolMenu
!

protocol
	^self protocols detect: [:each | true]
		ifNone: [nil]
!

protocols
	^self protocolList selections
!

updateProtocolList
	self newProtocolList: self protocols
! !

!Navigator methodsFor:'accessing-selector'!

changedSelector
	self updateSelectorMenu.
	self changed: #selector with: self selector
!

newSelectorList: initialSelections 
	| protocols class selectors |
	class := self selectedClass.
	class isNil
		ifTrue: [selectors := #()]
		ifFalse: 
			[selectors := Set new.
			protocols := self protocols.
			protocols do: [:each | selectors addAll: (self environment selectorsFor: each in: class)]].
	selectorList list: selectors asSortedCollection asList.
	selectorList selections: initialSelections.
	self updateSelectorMenu
!

selector
	^self selectors detect: [:each | true]
		ifNone: [nil]
!

selectors
	^self selectorList selections
!

updateSelectorList
	self newSelectorList: self selectors
! !

!Navigator methodsFor:'aspects'!

categoryHolder
	^self pluggableAdaptorFor: self categoryList
!

categoryList
        ^categoryList isNil
                ifTrue: [categoryList := RBMultiSelectionInList new]
                ifFalse: [categoryList]
!

categoryMenu
	^categoryMenuHolder
!

classHolder
	^self pluggableAdaptorFor: self classList
!

classList
        ^classList isNil
                ifTrue: [classList := RBMultiSelectionInList new]
                ifFalse: [classList]
!

classMenu
	^classMenuHolder
!

classNameHolder
	^BlockValue block: [:class :meta | class notNil
			ifTrue: [meta
					ifTrue: [class , ' class']
					ifFalse: [class]]
			ifFalse: ['']]
		arguments: (Array with: self classHolder with: self meta)
!

meta
	"This method was generated by UIDefiner. Any edits made here 
	may be lost whenever methods are automatically defined. The 
	initialization provided below may have been preempted by an 
	initialize method."

	^metaHolder isNil
		ifTrue: [metaHolder := nil asValue]
		ifFalse: [metaHolder]
!

pluggableAdaptorFor: aModel 
	^(PluggableAdaptor on: aModel)
		getBlock: [:model | model selections detect: [:each | true]
				ifNone: [nil]]
		putBlock: [:model :value | model selections: (Array with: value)]
		updateBlock: [:m :a :p | true]
!

protocolHolder
	^self pluggableAdaptorFor: self protocolList
!

protocolList
        ^protocolList isNil
                ifTrue: [protocolList := RBMultiSelectionInList new]
                ifFalse: [protocolList]
!

protocolMenu
	^protocolMenuHolder
!

selectorHolder
	^self pluggableAdaptorFor: self selectorList
!

selectorList
        ^selectorList isNil
                ifTrue: [selectorList := RBMultiSelectionInList new]
                ifFalse: [selectorList]
!

selectorMenu
	^selectorMenuHolder
! !

!Navigator methodsFor:'events'!

closed
	self changed: #closed
!

noticeOfWindowClose: aWindow
	self closed.
	^super noticeOfWindowClose: aWindow
! !

!Navigator methodsFor:'initialize-release'!

initialize
	super initialize.
	categoryMenuHolder := (self initializeMenu: self class categoryMenu) asValue.
	classMenuHolder := (self initializeMenu: self class classMenu) asValue.
	protocolMenuHolder := (self initializeMenu: self class protocolMenu) asValue.
	selectorMenuHolder := (self initializeMenu: self class selectorMenu) asValue.
	self meta value: false
! !

!Navigator methodsFor:'interface opening'!

postBuildWidget: aSymbol 
        | specWrapper |
        specWrapper := builder componentAt: aSymbol.
        specWrapper isNil ifTrue: [^self].
        Smalltalk isSmalltalkX ifTrue:[
            specWrapper changeClassToThatOf: RBMultiSelectionView basicNew
        ] ifFalse:[
            specWrapper widget changeClassToThatOf: RBMultiSelectionView basicNew
        ]
!

postBuildWith: aBuilder 
	super postBuildWith: aBuilder.
	#(#categoryList #classList #protocolList #selectorList) do: [:each | self postBuildWidget: each].
	self updateMenus
! !

!Navigator methodsFor:'menus'!

updateCategoryMenu
	self category isNil
		ifTrue: [self disableMenu: categoryMenuHolder value except: #('add...' 'update' 'find class...')]
		ifFalse: [self enableMenu: categoryMenuHolder value]
!

updateClassMenu
	self className isNil
		ifTrue: [self disableMenu: classMenuHolder value]
		ifFalse: [self enableMenu: classMenuHolder value]
!

updateProtocolMenu
	self className isNil
		ifTrue: [self disableMenu: protocolMenuHolder value]
		ifFalse: [self protocol isNil
				ifTrue: [self disableMenu: protocolMenuHolder value except: #('add...' 'find method...')]
				ifFalse: [self enableMenu: protocolMenuHolder value]]
!

updateSelectorMenu
	self selector isNil
		ifTrue: [self disableMenu: selectorMenuHolder value]
		ifFalse: [self enableMenu: selectorMenuHolder value]
! !

!Navigator methodsFor:'private'!

setState: aNavigatorState updateClasses: aBoolean 
	"Set the current selections to be that of aNavigatorState. If aBoolean is true then update the 
	application and class lists, otherwise only update them if their values have changed."

	aNavigatorState classNames isEmpty
		ifTrue: 
			[self newCategoryListNoUpdate: aNavigatorState categories.
			self newClassList: #()]
		ifFalse: 
			[(aBoolean not and: 
					[self isMeta == aNavigatorState isMeta and: 
							[aNavigatorState classNames = self classNames
								and: [aNavigatorState categories = self categories]]])
				ifFalse: 
					[self selectClasses: aNavigatorState classNames
						meta: aNavigatorState isMeta
						categories: aNavigatorState categories].
			self setSelectors: aNavigatorState selectors in: aNavigatorState protocols]
! !

!Navigator methodsFor:'private-category'!

findClass
	"Prompt for a class and position myself there."

	| testClass |
	self changeRequest ifFalse: [^self].

	[testClass := self pickAClass: 'Find class'.
	testClass = '' ifTrue: [^self].
	testClass isNil and: [(Dialog confirm: 'No matching class, try again?')
			ifFalse: [^self]
			ifTrue: [true]]] whileTrue.
	testClass isBehavior ifFalse: [testClass := testClass class].
	testClass isMeta ifTrue: [testClass := testClass soleInstance].
	self isMeta ifTrue: [testClass := testClass class].
	self selectClass: testClass.
	self changedClass
!

pickAClass: prompt 
	| destClassName destClass classes |
	destClassName := Dialog request: prompt for: self interfaceWindow.
	destClassName = '' ifTrue: [^''].
	classes := Cursor execute showWhile: 
					[(self environment classNames select: [:cn | destClassName match: cn])
						asSortedCollection].
	(classes isNil or: [classes isEmpty])
		ifTrue: 
			[classes := (self environment keys select: [:cn | destClassName match: cn])
						asSortedCollection.
			classes isEmpty ifTrue: [^nil].
			(Dialog
				confirm: 'There are no matching class names.\Do you want to browse matching globals?'
						withCRs
				for: self interfaceWindow) ifFalse: [^nil].
			destClassName := Dialog choose: 'Browse the class of which global?'
						fromList: classes
						values: (classes collect: [:glob | (self environment at: glob) class name])
						lines: 10
						cancel: [^'']
						for: self interfaceWindow]
		ifFalse: 
			[destClassName := classes size = 1
						ifTrue: [classes first]
						ifFalse: 
							[Dialog choose: 'Choose a class'
								fromList: classes
								values: classes
								lines: 10
								cancel: [^'']
								for: self interfaceWindow]].
	destClass := self environment at: destClassName asSymbol ifAbsent: [^nil].
	self isMeta ifTrue: [destClass := destClass class].
	^destClass
! !

!Navigator methodsFor:'private-class'!

clearToClass
	self changeRequest ifFalse: [^self].
	self newProtocolList: #().
	self changedProtocol
!

selectClass: aClass 
	| names meta |
	aClass isNil
		ifTrue: 
			[names := #().
			meta := self isMeta]
		ifFalse: 
			[meta := aClass isMeta.
			names := Array with: (meta ifTrue: [aClass soleInstance] ifFalse: [aClass]) name].
	self selectClasses: names
		meta: meta
		categories: #().
	self updateProtocolList
!

selectClasses: classNames meta: aBoolean categories: categoryNames 
	| categories |
	self meta: aBoolean.
	categories := Set withAll: categoryNames.
	classNames do: [:each | categories add: (self environment whichCategoryIncludes: each)].
	self newCategoryListNoUpdate: categories asList.
	self newClassListNoUpdate: classNames
! !

!Navigator methodsFor:'private-protocol'!

findMethodAndSelectAlphabetic
	| chosenSelector selectorCollection selector |
	self changeRequest ifFalse: [^self].
	selector := Dialog request: 'Find selector:'.
	selector isEmpty ifTrue: [^self].
	selectorCollection := ((self environment selectorsForClass: self selectedClass)
				select: [:each | selector match: each]) asSortedCollection.
	selectorCollection isEmpty ifTrue: 
			[^(Dialog confirm: 'No selectors found.<n>Search again?' expandMacros)
				ifTrue: [self findMethodAndSelectAlphabetic]].
	chosenSelector := selectorCollection size == 1
				ifTrue: [selectorCollection first]
				ifFalse: 
					[Dialog choose: 'Find which selector?'
						fromList: selectorCollection
						values: selectorCollection
						lines: 10
						cancel: [nil]].
	chosenSelector isNil ifTrue: [^self].
	self setSelector: chosenSelector.
	LastProtocol := self protocol.
	self changedSelector
!

setSelector: aSelector 
	aSelector isNil ifTrue: [^self].
	self setSelectors: (Array with: aSelector)
		in: (Array with: (self environment whichProtocolIncludes: aSelector in: self selectedClass))
!

setSelectors: selectorCollection in: protocolCollection 
	| protocols class selectors |
	class := self selectedClass.
	class isNil
		ifTrue: [selectors := (protocols := #())]
		ifFalse: 
			[selectors := selectorCollection.
			protocols := protocolCollection asOrderedCollection.
			selectorCollection do: 
					[:each | 
					| protocol |
					protocol := self environment whichProtocolIncludes: each in: class.
					(protocols includes: protocol) ifFalse: [protocols add: protocol]]].
	self newProtocolListNoUpdate: protocols.
	self newSelectorList: selectors
! !

!Navigator methodsFor:'testing'!

isHierarchy
	^false
! !

!Navigator methodsFor:'updating'!

updateCategoryList
	self changeRequest ifFalse: [^self].
	self setState: self getState updateClasses: true.
	self changed: #category with: self category
!

updateMenus
	self updateCategoryMenu.
	self updateClassMenu.
	self updateProtocolMenu.
	self updateSelectorMenu
! !

!Navigator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/Navigator.st,v 1.10 2003-09-23 10:44:56 cg Exp $'
! !

Navigator initialize!
