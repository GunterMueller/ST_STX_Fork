"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringBrowserTest subclass:#BrowserEnvironmentTest
	instanceVariableNames:'browser universalEnvironment'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!BrowserEnvironmentTest methodsFor:'set up'!

setUp
	super setUp.
	universalEnvironment := BrowserEnvironment new
! !

!BrowserEnvironmentTest methodsFor:'tests-AndEnvironment'!

testAndEnvironment
	| originalEnvironment objectPrintStringEnvironment andEnvironment |
	originalEnvironment := universalEnvironment referencesTo: #printOn:.
	objectPrintStringEnvironment := universalEnvironment forClass: Object
				selectors: #(#printString).
	andEnvironment := objectPrintStringEnvironment & originalEnvironment.
	self universalTestFor: andEnvironment.
	self assert: andEnvironment numberSelectors = 1.
	self assert: andEnvironment classNames asArray = #(#Object).
	self assert: (andEnvironment protocolsFor: Object) size = 1.
	andEnvironment := originalEnvironment 
				& (universalEnvironment referencesTo: #printString).
	self assert: andEnvironment numberSelectors 
				= (originalEnvironment referencesTo: #printString) numberSelectors.
	self assert: andEnvironment classNames asSortedCollection 
				= (originalEnvironment referencesTo: #printString) classNames 
						asSortedCollection
! !

!BrowserEnvironmentTest methodsFor:'tests-BrowserEnvironment'!

classNamesFor: anEnvironment 
	| classNames |
	classNames := (anEnvironment classNames asSet)
				addAll: anEnvironment not classNames;
				yourself.
	self assert: classNames asSortedCollection 
				= BrowserEnvironment new classNames asSortedCollection.
	self assert: (anEnvironment & anEnvironment not) classNames isEmpty.
	self 
		assert: (anEnvironment | anEnvironment not) classNames asSortedCollection 
				= BrowserEnvironment new classNames asSortedCollection
!

classesFor: aBrowserEnvironment 
	| allClasses |
	allClasses := aBrowserEnvironment classes asSet.
	allClasses addAll: aBrowserEnvironment not classes.
	BrowserEnvironment new classesDo: [:each | allClasses remove: each].
	self assert: allClasses isEmpty
!

testAllClassesDo
	| allClasses aBrowserEnvironment |
	aBrowserEnvironment := BrowserEnvironment new.
	allClasses := Set new.
	aBrowserEnvironment classesDo: [:each | allClasses add: each].
	Smalltalk allBehaviorsDo: [:each | allClasses remove: each].
	self assert: allClasses isEmpty
!

testBrowserEnvironment
	self universalTestFor: BrowserEnvironment new
!

testCategoryEnvironment
	| aCategoryEnvironment nExpected |
	aCategoryEnvironment := CategoryEnvironment 
				onEnvironment: BrowserEnvironment new
				categories: #(#'Kernel-Objects').
	self universalTestFor: aCategoryEnvironment.
	nExpected := 1.
	((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
	    nExpected := 4
	].
	self assert: (aCategoryEnvironment implementorsOf: #printString) numberSelectors = nExpected
!

testClassEnvironment
	| aClassEnvironment |
	aClassEnvironment := ClassEnvironment 
				onEnvironment: BrowserEnvironment new
				classes: (Array with: Object with: Object class).
	self universalTestFor: aClassEnvironment.
	self assert: (aClassEnvironment implementorsOf: #printString) numberSelectors = 1
!

testConstructedClassEnvironment
	| environment |
	environment := ClassEnvironment new.
	environment
		addClass: Object;
		addClass: OrderedCollection;
		addClass: Collection.
	self assert: (environment includesClass: Object).
	self assert: (environment includesClass: OrderedCollection).
	self assert: (environment includesClass: Collection).
	self deny: (environment includesClass: Object class).
	environment removeClass: Collection.
	self assert: (environment includesClass: Object).
	self assert: (environment includesClass: OrderedCollection).
	self deny: (environment includesClass: Collection).
	self assert: environment numberClasses = 2.
	environment addClass: Object class.
	self assert: environment numberClasses = 2.
	self assert: (environment includesClass: Object class).
	environment removeClass: self class.
	self assert: environment numberClasses = 2
!

testConstructedSelectorEnvironment
	| environment newEnvironment |
	environment := SelectorEnvironment new.
	environment
		addClass: Object selector: #printString;
		addClass: OrderedCollection selector: #add:;
		addClass: Collection.
	self assert: (environment includesClass: Object).
	self assert: (environment selectorsForClass: Object) size = 1.
	self assert: (environment includesClass: OrderedCollection).
	self assert: (environment selectorsForClass: OrderedCollection) size = 1.
	self assert: (environment includesClass: Collection).
	self assert: (environment selectorsForClass: Collection) size 
				= Collection selectors size.
	self deny: (environment includesClass: Object class).
	newEnvironment := environment copy.
	newEnvironment
		removeClass: OrderedCollection;
		addClass: Object selector: #printOn:;
		removeClass: Object selector: #printString.
	self assert: (newEnvironment includesClass: Object).
	self deny: (newEnvironment includesSelector: #printString in: Object).
	self deny: (newEnvironment includesClass: OrderedCollection).
	self assert: (newEnvironment includesClass: Collection).
	self assert: newEnvironment numberClasses = 2.
	self 
		assert: newEnvironment numberSelectors + 1 = environment numberSelectors.
	newEnvironment addClass: Object class.
	self assert: newEnvironment numberClasses = 2.
	self assert: (newEnvironment includesClass: Object class).
	newEnvironment removeClass: self class.
	self assert: newEnvironment numberClasses = 2
!

testEnvironmentWrapper
	| printString wrapper |
	printString := BrowserEnvironment new referencesTo: #printString.
	wrapper := BrowserEnvironmentWrapper onEnvironment: printString.
	self assert: wrapper numberSelectors = printString numberSelectors.
	self assert: wrapper numberClasses = printString numberClasses.
	self assert: wrapper environment == printString
!

testImplementorsMatching
	| print |
	print := BrowserEnvironment new implementorsMatching: '*print*'.
	self universalTestFor: print.
	self assert: (print implementorsOf: #printString) numberSelectors 
				= (BrowserEnvironment new implementorsOf: #printString) numberSelectors.
	print 
		classesAndSelectorsDo: [:class :sel | self assert: ('*print*' match: sel)]
!

testMatches
	| envEnvironment environmentEnvironment |
	envEnvironment := BrowserEnvironment new matches: '*env*'.
	environmentEnvironment := BrowserEnvironment new 
				referencesTo: #environment.
	self assert: (envEnvironment referencesTo: #environment) numberSelectors 
				= environmentEnvironment numberSelectors
!

testProtocolEnvironment
	| aProtocolEnvironment size |
	aProtocolEnvironment := ProtocolEnvironment 
				onEnvironment: BrowserEnvironment new
				class: Object
				protocols: #(#printing #testing #'printing & storing' "for ST/X").
	self universalTestFor: aProtocolEnvironment.
	self 
		assert: (aProtocolEnvironment implementorsOf: #printString) numberSelectors 
				= 1.
	size := 0.
	aProtocolEnvironment classesDo: [:each | size := size + 1].
	self assert: size = 1.
	aProtocolEnvironment selectorsForClass: Object
		do: 
			[:each | 
			self assert: (#(#printing #testing #'printing & storing' "for ST/X") 
						includes: (BrowserEnvironment new whichProtocolIncludes: each in: Object))]
!

testRemoveSelectorByAndAndNot
	| aBrowserEnvironment objectPrintString |
	aBrowserEnvironment := BrowserEnvironment new.
	objectPrintString := SelectorEnvironment 
				onEnvironment: aBrowserEnvironment.
	objectPrintString addClass: Object selector: #printString.
	self assert: aBrowserEnvironment numberSelectors - 1 
				= (aBrowserEnvironment & objectPrintString not) numberSelectors.
	self universalTestFor: aBrowserEnvironment & objectPrintString not
!

testSelectMethods
	| environment |
	environment := BrowserEnvironment new selectMethods: [:each | false].
	self assert: environment numberSelectors = 0.
	self assert: environment numberClasses = 0.
	environment := BrowserEnvironment new selectMethods: [:each | true].
	self assert: environment numberSelectors 
				= BrowserEnvironment new numberSelectors.
	environment := BrowserEnvironment new 
				selectMethods: [:each | each refersToLiteral: #environment].
	self assert: environment numberSelectors 
				= (BrowserEnvironment new referencesTo: #environment) numberSelectors
!

testSelectorEnvironment
	| printString |
	printString := BrowserEnvironment new referencesTo: #printString.
	self universalTestFor: printString.
	self assert: printString numberSelectors 
				= (printString referencesTo: #printString) numberSelectors.
	self assert: printString numberClasses 
				= (printString referencesTo: #printString) numberClasses
! !

!BrowserEnvironmentTest methodsFor:'tests-NotEnvironment'!

testNotEnvironment
	| notPrintStringEnvironment printStringEnvironment |
	printStringEnvironment := universalEnvironment referencesTo: #printString.
	notPrintStringEnvironment := printStringEnvironment not.
	self universalTestFor: notPrintStringEnvironment.
	self 
		assert: (notPrintStringEnvironment referencesTo: #printString) isEmpty.
	self assert: (notPrintStringEnvironment not includesClass: self class).
	self assert: (notPrintStringEnvironment not 
				includesSelector: #testNotEnvironment
				in: self class)
! !

!BrowserEnvironmentTest methodsFor:'tests-OrEnvironment'!

testOrEnvironment
	| env1 env2 orEnvironment |
	self needsWork. "the following line is temporary, to help a SUnit test pass.  Literal strings withing literal arrays don't show up as references for some reason."
	env2 := #printOn:.
	env2 := universalEnvironment forClass: Object selectors: #(#printString).
	env1 := universalEnvironment forClass: Object selectors: #(#printOn:).
	self assert: (env1 | env2) numberSelectors = 2.
	self assert: (env2 | env1) numberSelectors = 2.
	self universalTestFor: env1 | env2.
	self assert: (env1 | env1) numberSelectors = 1.
	orEnvironment := env1 | env1 not.
	self universalTestFor: orEnvironment.
	self assert: orEnvironment numberSelectors 
				= universalEnvironment numberSelectors.
	self assert: orEnvironment classNames asSortedCollection 
				= universalEnvironment classNames asSortedCollection.
	self assert: (orEnvironment protocolsFor: Object) 
				= (universalEnvironment protocolsFor: Object)
! !

!BrowserEnvironmentTest methodsFor:'universal tests'!

categoriesFor: anEnvironment 
	| allCategories |
	allCategories := Set withAll: BrowserEnvironment new categories.
	allCategories removeAll: anEnvironment categories.
	anEnvironment not categories 
		do: [:each | allCategories remove: each ifAbsent: []].
	allCategories 
		do: [:each | self assert: (BrowserEnvironment new classNamesFor: each) isEmpty]
!

copyFor: aBrowserEnvironment 
	| newEnvironment |
	newEnvironment := aBrowserEnvironment copy.
	self assert: newEnvironment numberSelectors 
				= aBrowserEnvironment numberSelectors.
	self 
		assert: (newEnvironment not & aBrowserEnvironment) numberSelectors = 0
!

keysFor: aBrowserEnvironment 
	| allKeys |
	allKeys := Set withAll: aBrowserEnvironment keys.
	allKeys addAll: aBrowserEnvironment not keys.
	allKeys removeAll: Smalltalk keys.
	self assert: allKeys isEmpty
!

numberSelectorsFor: aBrowserEnvironment 
	self 
		assert: aBrowserEnvironment numberSelectors 
				+ aBrowserEnvironment not numberSelectors 
					= BrowserEnvironment new numberSelectors.
	self 
		assert: (aBrowserEnvironment & aBrowserEnvironment not) numberSelectors = 0.
	self assert: (universalEnvironment & aBrowserEnvironment) numberSelectors 
				= aBrowserEnvironment numberSelectors.
	self assert: (aBrowserEnvironment & universalEnvironment) numberSelectors 
				= aBrowserEnvironment numberSelectors
!

storeStringFor: aBrowserEnvironment
	| newEnvironment |

	newEnvironment := Compiler evaluate: aBrowserEnvironment storeString.

        
	newEnvironment classesDo:[:eachClass |
	    self assert:(aBrowserEnvironment includesClass:eachClass).
	    newEnvironment selectorsForClass:eachClass do:[:eachSelector |
		self assert:(aBrowserEnvironment includesSelector:eachSelector in:eachClass).
	    ]        
	].
	aBrowserEnvironment classesDo:[:eachClass |
	    self assert:(newEnvironment includesClass:eachClass).
	    aBrowserEnvironment selectorsForClass:eachClass do:[:eachSelector |
		self assert:(newEnvironment includesSelector:eachSelector in:eachClass).
	    ]        
	].

	self assert: newEnvironment numberSelectors = aBrowserEnvironment numberSelectors.
	self assert: (newEnvironment not & aBrowserEnvironment) numberSelectors = 0
        
!

uniqueClassesIn: aBrowserEnvironment 
	| allClasses |
	allClasses := Set new.
	aBrowserEnvironment 
		classesDo: [:each | self deny: (allClasses includes: each)]
!

universalTestFor: aBrowserEnvironment 
	self uniqueClassesIn: aBrowserEnvironment.
	self numberSelectorsFor: aBrowserEnvironment.
	self storeStringFor: aBrowserEnvironment.
	self classNamesFor: aBrowserEnvironment.
	self copyFor: aBrowserEnvironment.
	self categoriesFor: aBrowserEnvironment.
	self classesFor: aBrowserEnvironment.
	self keysFor: aBrowserEnvironment.
	self 
		assert: aBrowserEnvironment problemCount = 0 = aBrowserEnvironment isEmpty
! !

!BrowserEnvironmentTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/BrowserEnvironmentTest.st,v 1.5 2003-10-06 14:39:33 cg Exp $'
! !
