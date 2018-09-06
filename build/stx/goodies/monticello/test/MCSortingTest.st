"{ Package: 'stx:goodies/monticello/test' }"

TestCase subclass:#MCSortingTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Tests'
!


!MCSortingTest methodsFor:'actions'!

sortDefinitions: aCollection
	^ aCollection asSortedCollection asArray
! !

!MCSortingTest methodsFor:'building'!

classNamed: aSymbol
	^ MCClassDefinition
		name: aSymbol
		superclassName: #Object
		category: ''
		instVarNames: #()
		comment: ''
!

methodNamed: aSymbol class: className meta: aBoolean
	^ MCMethodDefinition
		className: className
		classIsMeta: aBoolean
		selector: aSymbol
		category: ''
		timeStamp: ''
		source: ''
!

sortKeyFor: aDefinition
	^ String streamContents:
		[:s |
		aDefinition description
			do: [:ea | s nextPutAll: ea asString]
			separatedBy: [s nextPut: $.]]
! !

!MCSortingTest methodsFor:'tests'!

testConsistentSorting
	| definitions shuffledAndSorted|
	definitions _
		{self methodNamed: #a class: #A meta: false.
		self methodNamed: #a class: #A meta: true.
		self methodNamed: #a class: #B meta: false.
		self methodNamed: #b class: #A meta: false.
		self methodNamed: #b class: #B meta: false.
		self classNamed: #A.
		self classNamed: #B}.
	shuffledAndSorted _
		(1 to: 100) collect: [:ea | self sortDefinitions: definitions shuffled].
	self assert: shuffledAndSorted asSet size = 1.
!

testSortOrder
	| aA aAm aB bA bB A B cA bAm cAm |
	aA _ self methodNamed: #a class: #A meta: false.
	bA _ self methodNamed: #b class: #A meta: false.
	cA _ self methodNamed: #c class: #A meta: false.
	aAm _ self methodNamed: #a class: #A meta: true.
	bAm _ self methodNamed: #b class: #A meta: true.
	cAm _ self methodNamed: #c class: #A meta: true.
	aB _ self methodNamed: #a class: #B meta: false.
	bB _ self methodNamed: #b class: #B meta: false.
	A _ self classNamed: #A.
	B _ self classNamed: #B.
	self assert: (self sortDefinitions: {aA. aAm. cAm. aB. bAm. bA. bB. A. cA. B})
					= {A. aAm. bAm. cAm. aA. bA. cA. B. aB.  bB}
! !

!MCSortingTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/test/MCSortingTest.st,v 1.2 2013-05-29 00:02:42 vrany Exp $'
! !

