"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

MADescriptionTest subclass:#MAContainerTest
	instanceVariableNames:'child1 child2 child3'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Description'
!


!MAContainerTest class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAContainerTest methodsFor:'accessing'!

child1
	^ child1 ifNil: 
		[ child1 := MAStringDescription new
			accessor: #child1;
			label: 'child1';
			priority: 1;
			yourself ]
!

child2
	^ child2 ifNil: 
		[ child2 := MAStringDescription new
			accessor: #child2;
			label: 'child2';
			priority: 2;
			yourself ]
!

child3
	^ child3 ifNil: 
		[ child3 := MAStringDescription new
			accessor: #child3;
			label: 'child3';
			priority: 3;
			yourself ]
! !

!MAContainerTest methodsFor:'private'!

actualClass
	^ MAContainer
!

exampleInstance
	^ MACachedMemento new
		setDescription: self description;
		setCache: (Dictionary new
			at: self child1 put: nil;
			at: self child2 put: nil;
			at: self child3 put: nil;
			yourself);
		yourself
! !

!MAContainerTest methodsFor:'testing-accessing'!

testChildren
	self assert: self description children isCollection.
	self assert: self description children isEmpty
!

testSize
	self assert: self description size isZero.
	self description add: self child1.
	self assert: self description size = 1.
	self description add: self child2.
	self assert: self description size = 2.
	self description add: self child3.
	self assert: self description size = 3
! !

!MAContainerTest methodsFor:'testing-adding'!

testAdd
	self description add: self child1.
	self assert: (self description size = 1).
	self assert: (self description includes: self child1).

	self description add: self child2.
	self assert: (self description size = 2).
	self assert: (self description includes: self child1).
	self assert: (self description includes: self child2)
!

testAddAll
	self description
		addAll: (Array with: self child1 with: self child2).

	self assert: (self description size = 2).
	self assert: (self description includes: self child1).
	self assert: (self description includes: self child2)
! !

!MAContainerTest methodsFor:'testing-converting'!

testAsContainer
	self assert: self description asContainer = self description.
	self assert: self description asContainer == self description
! !

!MAContainerTest methodsFor:'testing-copying'!

testCopy
	self description add: self child1; add: self child2.
	super testCopy.

	self deny: self description copy children == self description children.
	self assert: self description copy children first = self description children first.
	self assert: self description copy children second = self description children second
!

testCopyEmpty
	self description add: self child1; add: self child2.
	self assert: self description copyEmpty isEmpty
!

testCopyFromTo
	| copied |
	self description add: self child1; add: self child2; add: self child3.
	copied := self description copyFrom: 2 to: 3.

	self assert: copied ~= self description.

	self assert: copied size = 2.
	self assert: copied children first = self child2.
	self assert: copied children second = self child3
!

testCopyWithout
	| copied |
	self description add: self child1; add: self child2; add: self child3.
	copied := self description copyWithout: self child1.

	self assert: copied ~= self description.

	self assert: copied size = 2.
	self assert: copied children first = self child2.
	self assert: copied children second = self child3
!

testCopyWithoutAll
	| copied |
	self description add: self child1; add: self child2; add: self child3.
	copied := self description copyWithoutAll: (Array with: self child1 with: self child3).

	self assert: copied ~= self description.

	self assert: copied size = 1.
	self assert: copied children first = self child2
! !

!MAContainerTest methodsFor:'testing-enumerating'!

testAllSatisfy
	self description add: self child1; add: self child2.
	self assert: (self description allSatisfy: [ :each | each = self child1 or: [ each = self child2 ] ]).
	self deny: (self description allSatisfy: [ :each | each = self child1 ])
!

testAnySatisfy
	self description add: self child1; add: self child2.
	self assert: (self description anySatisfy: [ :each | each = self child2 ]).
	self deny: (self description anySatisfy: [ :each | each isNil ])
!

testAt
	self description add: self child1; add: self child2.
	self assert: (self description at: 1) = self child1.
	self assert: (self description at: 2) = self child2.
	self should: [ self description at: 3 ] raise: Error
!

testAtIfAbsent
	self description add: self child1; add: self child2.
	self assert: (self description at: 1 ifAbsent: [ 'not' ]) = self child1.
	self assert: (self description at: 2 ifAbsent: [ 'not' ]) = self child2.
	self assert: (self description at: 3 ifAbsent: [ 'not' ]) = 'not'
!

testCollect
	| collected |
	self description add: self child1; add: self child2.
	collected := self description collect: [ :each | each ].
	self assert: self description = collected.
	self deny: self description == collected.

	collected := self description collect: [ :each | each copy ].
	self assert: self description = collected.
	self deny: self description == collected.

	collected := self description collect: [ :each |
		each copy
			accessor: (MASelectorAccessor selector: #foo);
			yourself ].
	self deny: self description = collected.
	self deny: self description == collected
!

testDetect
	self description add: self child1.
	self assert: (self description
		detect: [ :each | self child1 = each ]) = self child1.
	self should: [ self description
		detect: [ :each | self child2 = each ] ] raise: Error
!

testDetectIfNone
	self description add: self child1.
	self assert: (self description
		detect: [ :each | self child1 = each ]
		ifNone: [ 123 ]) = self child1.
	self assert: (self description
		detect: [ :each | self child2 = each ]
		ifNone: [ 123 ]) = 123
!

testDo
	| collection |
	collection := self description class defaultCollection.
	self description add: self child1; add: self child2.
	self description do: [ :each | collection add: each ].
	self assert: (self description children hasEqualElements: collection)
!

testDoSepratedBy
	| collection |
	collection := OrderedCollection new.
	self description add: self child1; add: self child2.
	self description
		do: [ :each | collection add: each ]
		separatedBy: [ collection add: nil ].
	self assert: collection size = 3.
	self assert: collection first = self child1.
	self assert: collection second isNil.
	self assert: collection third = self child2
!

testInjectInto
	self description add: self child1; add: self child2.
	self assert: (self description
		inject: 'start'
		into: [ :result :each | result , ' ' , each label ]) = 'start child1 child2'
!

testKeysAndValuesDo
	self description
		add: self child1;
		add: self child2.
	self description keysAndValuesDo: 
		[ :index :each | 
		index = 1 
			ifTrue: [ self assert: self child1 = each ]
			ifFalse: 
				[ index = 2 
					ifTrue: [ self assert: self child2 = each ]
					ifFalse: [ self assert: false ] ] ]
!

testNoneSatisfy
	self description add: self child1; add: self child2.
	self assert: (self description noneSatisfy: [ :each | each isNil ])
!

testReject
	| rejected |
	self description add: self child1; add: self child2.

	rejected := self description reject: [ :each | false ].
	self assert: self description = rejected.

	rejected := self description reject: [ :each | true ].
	self assert: rejected isEmpty
!

testSelect
	| selected |
	self description add: self child1; add: self child2.

	selected := self description select: [ :each | true ].
	self assert: self description = selected.

	selected := self description select: [ :each | false ].
	self assert: selected isEmpty
!

testWithDo
	self description add: self child1; add: self child2.
	self description with: self description children
		do: [ :first :second | self assert: first = second ]
! !

!MAContainerTest methodsFor:'testing-moving'!

testMoveDown
	self description add: self child1; add: self child2.
	self assert: self description children first = self child1.
	self assert: self description children second = self child2.

	self description moveDown: self child1.
	self assert: self description children first = self child2.
	self assert: self description children second = self child1.

	self description moveDown: self child1.
	self assert: self description children first = self child2.
	self assert: self description children second = self child1
!

testMoveUp
	self description add: self child1; add: self child2.
	self assert: self description children first = self child1.
	self assert: self description children second = self child2.

	self description moveUp: self child2.
	self assert: self description children first = self child2.
	self assert: self description children second = self child1.

	self description moveUp: self child2.
	self assert: self description children first = self child2.
	self assert: self description children second = self child1
! !

!MAContainerTest methodsFor:'testing-operators'!

testConcatenate
	| concatenate |
	concatenate := self child1 , self child2.
	self assert: concatenate size = 2.
	self assert: concatenate children first = self child1.
	self assert: concatenate children second = self child2.

	concatenate := self child1 , self child2 , self child3.
	self assert: concatenate size = 3.
	self assert: concatenate children first = self child1.
	self assert: concatenate children second = self child2.
	self assert: concatenate children third = self child3
!

testIntersection
	| a b union |
	a := self child1 , self child2.
	b := self child2 , self child3.
	union := a intersection: b.

	self assert: (union size) = 1.
	self deny: (union includes: self child1).
	self assert: (union includes: self child2).
	self deny: (union includes: self child3)
!

testUnion
	| a b union |
	a := self child1 , self child2.
	b := self child2 , self child3.
	union := a union: b.

	self assert: (union size) = 3.
	self assert: (union includes: self child1).
	self assert: (union includes: self child2).
	self assert: (union includes: self child3)
! !

!MAContainerTest methodsFor:'testing-removing'!

testRemove
	self description add: self child1; add: self child2.

	self description remove: self child1.
	self assert: self description size = 1.
	self deny: (self description includes: self child1).
	self assert: (self description includes: self child2).

	self description remove: self child2.
	self assert: self description isEmpty
!

testRemoveAll
	self description add: self child1; add: self child2.

	self description removeAll.
	self assert: self description isEmpty
! !

!MAContainerTest methodsFor:'testing-testing'!

testEmpty
	self assert: self description isEmpty.
	self description add: self child1.
	self deny: self description isEmpty
!

testHasChildren
	super testHasChildren.
	self description add: self child1.
	self assert: self description hasChildren
!

testIncludes
	self deny: (self description includes: self child1).
	self description add: self child1.
	self assert: (self description includes: self child1)
!

testIsContainer
	self assert: self description isContainer
!

testNotEmpty
	self deny: self description notEmpty.
	self description add: self child1.
	self assert: self description notEmpty
! !

!MAContainerTest methodsFor:'testing-validating'!

testNoFailingValidation
	| example |
	self description
		add: self child1;
		add: self child2.
	example := self exampleInstance.
	self
		shouldnt: [ example validate ]
		raise: MAValidationError
!

testOneFailingValidation
	| example |
	self description
		add: self child1;
		add: (self child2
			addCondition: [ :v | self fail ];
			beRequired;
			yourself).
	example := self exampleInstance.

	self
		should: [ example validate ]
		raise: MAValidationError.
	[ example validate ]
		on: MAValidationError
		do: [ :err |
			self assert: err class = MARequiredError.
			self assert: err tag = self child2.
			self assert: err isResumable.
			err resume ]
!

testTwoFailingValidation
	| example step |
	self description
		add: (self child1
			addCondition: [ :v | self fail ];
			beRequired;
			yourself);
		add: (self child2
			addCondition: [ :v | self fail ];
			beRequired;
			yourself).
	example := self exampleInstance.
	step := 1.

	self
		should: [ example validate ]
		raise: MAValidationError.
	[ example validate ]
		on: MAValidationError
		do: [ :err |
			self assert: err class = MARequiredError.
			self assert: err isResumable.
			step = 1
				ifTrue: [ self assert: err tag = self child1 ].
			step = 2
				ifTrue: [ self assert: err tag = self child2 ].
			step = 3
				ifTrue: [ self fail ].
			step := step + 1.
			err resume ]
! !

!MAContainerTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAContainerTest.st,v 1.1 2009-07-29 15:20:36 cg Exp $'
! !
