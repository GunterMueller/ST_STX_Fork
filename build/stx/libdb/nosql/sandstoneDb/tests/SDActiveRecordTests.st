"{ Package: 'stx:libdb/nosql/sandstoneDb/tests' }"

TestCase subclass:#SDActiveRecordTests
	instanceVariableNames:'mom kid store'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SandstoneDb-Tests'
!


!SDActiveRecordTests class methodsFor:'testing'!

isAbstract
	^ true
! !

!SDActiveRecordTests methodsFor:'actions'!

flushAndReload
	self personClass
		coolDown ;
		warmUp
! !

!SDActiveRecordTests methodsFor:'factory'!

childClass
	^ SDChildMock
!

defaultStore
	self subclassResponsibility
!

grandChildClass
	^ SDGrandChildMock
!

manClass
	^ SDManMock
!

personClass
	^ SDPersonMock
!

womanClass
	^ SDWomanMock
! !

!SDActiveRecordTests methodsFor:'running'!

setUp
	store := self defaultStore.
	SDActiveRecord setStore: store.
	"only want to warm up test models, not anything else that might be in this image"
	SDFooObject warmUp.
	self personClass withAllSubclasses do: [ :each | each warmUp ].

	mom := self personClass testPerson.
	kid := self personClass testPerson.
!

tearDown
	self personClass do: [ :each | [each delete] on: Error do: [] ].
	self personClass coolDown.
	SDFooObject do: [:each | [each delete] on: Error do: [] ].
	self personClass allSubclassesDo: [ :each | each coolDown ].
	Smalltalk garbageCollectMost
! !

!SDActiveRecordTests methodsFor:'testing'!

testAbort
	kid name: 'Joe'.
	kid save.
	kid name: 'Mary'.
	self assert: kid name = 'Mary'.
	kid abortChanges.
	self assert: kid name = 'Joe'
!

testArraySerialization
	kid save.
	mom children: {  kid  }.
	mom save.
	self flushAndReload.
	self assert: (mom refreshed children includes: kid refreshed)
!

testAtIdSubclasses
	| man woman |
	man := self manClass testPerson save.
	woman := self womanClass testPerson save.
	mom save.
	self assert: (self personClass atId: mom id) = mom.
	self assert: (self personClass atId: man id) = man.
	self assert: (self personClass atId: woman id) = woman.
	man delete.
	woman delete
!

testBagSerialization
	kid save.
	mom children: (Bag with: kid).
	mom save.
	self flushAndReload.
	self assert: (mom refreshed children includes: kid refreshed)
!

testBigSave
	| commitTime people deleteTime lookupTime |
	people := (1 to: 200) collect: [ :it | self personClass testPerson ] .
	commitTime := [ people do: [ :each | each save ]  ] timeToRun milliSeconds.
	lookupTime := [ people do: [ :each | self personClass atId: each id ] ] timeToRun
		milliSeconds.
	deleteTime := [ people do: [ :each | each delete ] ] timeToRun milliSeconds.
	Transcript
		show: commitTime;
		cr;
		show: lookupTime;
		cr;
		show: deleteTime;
		cr;
		cr.
	self assert: commitTime < 3 seconds.
	self assert: deleteTime < 1 seconds
!

testClassSerialization
	mom children: self womanClass .
	self should: [ mom save ] raise: SDCommitError
!

testCollectionSerialization
	kid save.
	mom children: (OrderedCollection with: kid).
	mom save.
	self flushAndReload.
	self assert: (mom refreshed children includes: kid refreshed)
!

testCopying
	| copy |
	copy := mom copy.
	self deny: copy = mom.
	self deny: copy id = mom id.
	self assert: copy isNew
!

testCreatedOn
	kid save.
	self assert: kid createdOn <= DateAndTime now
!

testDeepCopy
	"sandstoneDeepCopy works just like deepCopy until it hits another active record
	at which point the copying stops, and the actual references is returned."
	| copy obj |
	kid save.
	mom save.
	kid buddy: #not -> (#deeper -> mom).
	obj := Object new.
	kid father: obj.
	copy := kid sandstoneDeepCopy.
	self assert: copy buddy value value == mom.
	self deny: copy father == obj
!

testDefaultStore
	self assert: (SDActiveRecord defaultStore isKindOf: SDAbstractStore)
!

testDelete
	kid save.
	self deny: kid isNew.
	self assert: kid version equals: 1.
	kid delete.
	self assert: kid isNew.
	self assert: kid version equals: 0.
	self assert: (self personClass find: [ :each | each id = kid id ]) isNil.
	self flushAndReload.
	self assert: (self personClass find: [ :each | each id = kid id ]) isNil.
	kid delete "should not do anything"
!

testDeleteAll
	50 timesRepeat: [ self personClass testPerson save ].
	self personClass do: #delete.
	self assert: self personClass findAll size = 0
!

testDeleteAndFind
	kid name: 'zorgle'.
	kid save.
	self deny: kid isNew.
	kid delete.
	self assert: (self personClass find: [:e | e name = 'zorgle']) isNil.
!

testDeleteSubclass
	kid := self manClass testPerson save.
	self deny: kid isNew.
	self assert: kid version equals: 1.
	kid delete.
	self assert: kid isNew.
	self assert: kid version equals: 0.
	self flushAndReload.
	self assert: (self manClass find: [ :each | each id = kid id ]) isNil.
!

testDictionaryKeys
	| dad |
	dad := self manClass testPerson save.
	kid save.
	mom children: (Dictionary with: dad -> kid).
	mom save.
	self flushAndReload.
	self
		assert: (mom refreshed children at: dad refreshed )
		equals: kid refreshed
!

testDictionarySerialization
	kid save.
	mom children: (Dictionary with: #son -> kid).
	mom save.
	self flushAndReload.
	self
		assert: (mom refreshed children at: #son)
		equals: kid refreshed
!

testDictionaryWithArrays
	| foo fooCopy |
	kid save.
	3 timesRepeat: [ self manClass new save ].
	foo := SDFooObject new
		dict: (Dictionary with: kid -> self manClass findAll);
		yourself.
	fooCopy := foo sandstoneDeepCopy.
	self deny: foo == fooCopy.
	self deny: fooCopy dict == foo dict.
	"Works fine before saving the object"
	foo dict keysAndValuesDo:
		[ :key :value |
		self assert: (key isKindOf: self personClass).
		value do: [ :each | self assert: (each isKindOf: self manClass) ] ].
	fooCopy sandstoneMarkReferences.
	"should still work, otherwise save is somehow modifying original object instead of deepCopy of it"
	foo dict keysAndValuesDo:
		[ :key :value |
		self assert: (key isKindOf: self personClass).
		value do: [ :each | self assert: (each isKindOf: self manClass) ] ]
!

testDo
	kid save.
	self flushAndReload.
	self assert: 1 equals: self personClass findAll size.
	self personClass do: [ :e | self assert: e = kid ]
!

testEquality
	mom save.
	kid mother: mom.
	kid save.
	self flushAndReload .
	self assert: kid refreshed mother equals: mom refreshed
!

testFind
	kid save.
	self flushAndReload.
	self deny: (self personClass find: [ :each | each id = kid id ]) isNil.
	self assert: (self personClass find: [ :each | each id = 'not' ]) isNil
!

testFindAll
	kid save.
	self flushAndReload.
	self assert: (self personClass findAll class = Array).
	self assert: (self personClass findAll: [ :each | each id = 'not' ]) class = Array
!

testFindAllSubclasses
	| man woman child grandchild |
	man := self manClass testPerson save.
	woman := self womanClass testPerson save.
	child := self childClass testPerson save.
	grandchild := self grandChildClass testPerson save.
	mom save.
	self
		assert: 5
		equals: self personClass findAll size.
	self assert: (self personClass findAll contains: [ :e | e class = self manClass ]).
	self
		assert: 1
		equals: self manClass findAll size.
	self
		assert: 3
		equals: self womanClass findAll size.
	self
		assert: 2
		equals: self childClass findAll size.
	self
		assert: 1
		equals: self grandChildClass findAll size.
	man delete.
	woman delete.
	child delete.
	grandchild delete
!

testFindById
	kid save.
	self deny: (self personClass atId: kid id) isNil
!

testFindIdentity
	mom save.
	self flushAndReload.
	self assert: (self personClass atId: mom id) = (self personClass atId: mom id)
!

testFindIfPresent
	| found |
	found := false.
	kid save.
	self flushAndReload.
	self personClass find: [ :each | each id = kid id ] ifPresent: [:it | found := true ].
	self assert: found
!

testFindSubclasses
	| man woman child grandchild |
	man := self manClass testPerson save.
	woman := self womanClass testPerson save.
	child := self childClass testPerson save.
	grandchild := self grandChildClass testPerson save.
	self assert: man = (self personClass find: [:e | e id = man id]).
	self assert: woman = (self personClass find: [:e | e id = woman id]).
	self assert: child = (self personClass find: [:e | e id = child id]).
	self assert: grandchild = (self personClass find: [:e | e id = grandchild id]).
	man delete.
	woman delete.
	child delete.
	grandchild delete
!

testIdentity
	mom save.
	kid mother: mom.
	kid save.
	self flushAndReload.
	self assert: kid refreshed mother == mom refreshed
!

testIsNew
	self assert: kid isNew.
	kid save.
	self deny: kid isNew.
	kid delete.
	self assert: kid isNew.
!

testMarkReferences
	kid mother: mom.
	mom save.
	kid sandstoneMarkReferences.
	self assert: (kid mother isKindOf: SDRecordMarker).
	self assert: mom id = kid mother id.
	self assert: kid mother className = mom className
!

testMarkReferencesCopies
	kid save.
	mom children: { kid }.
	mom save.
	self assert: mom children first == kid
!

testMarkReferencesRecursive
	kid buddy: #not -> mom.
	mom save.
	kid sandstoneMarkReferences.
	self assert: (kid buddy value isKindOf: SDRecordMarker)
!

testMarkReferencesRecursiveDeeper
	kid buddy: #not -> (#deeper -> mom).
	mom save.
	kid sandstoneMarkReferences.
	self assert: (kid buddy value value isKindOf: SDRecordMarker)
!

testMarkReferencesRecursiveDeeperInCollection
	kid buddy: #not -> {  (#deeper -> mom)  }.
	mom save.
	kid sandstoneMarkReferences.
	self assert: (kid buddy value first value isKindOf: SDRecordMarker)
!

testMarkReferencesRecursiveDeeperInDictionary
	kid buddy: #not -> { (Dictionary with: #deeper -> mom) }.
	mom save.
	kid sandstoneMarkReferences.
	self assert: ((kid buddy value first at: #deeper) isKindOf: SDRecordMarker)
!

testMarkReferencesRecursiveDeeperNestedList
	kid buddy: #not -> (Array with: (Array with: mom)).
	mom save.
	kid sandstoneMarkReferences.
	self assert: (kid buddy value first first isKindOf: SDRecordMarker)
!

testMarkReferencesRecursiveDeeperNotTouchedInOrig
	| otherKid |
	kid buddy: #not -> (#deeper -> mom).
	otherKid := kid sandstoneDeepCopy.
	otherKid buddy value value save.
	otherKid sandstoneMarkReferences.
	self assert: (kid buddy value value isKindOf: mom class)
!

testMarkReferencesStops
	| other |
	other := self manClass testPerson save.
	mom father: other.
	kid buddy: #some -> (#time -> mom).
	mom save.
	kid sandstoneMarkReferences.
	self assert: (mom father == other)
!

testMatrixSerialization
	| man woman |
	man := self manClass testPerson save.
	woman := self womanClass testPerson save.       kid save.
	mom children: (Matrix rows: 4 columns: 4).
	mom children at: 1 at: 1 put: kid.
	mom children at: 2 at: 1 put: man.
	mom children at: 1 at: 2 put: woman.
	mom save.
	self flushAndReload.
	self assert: (mom refreshed children at: 1 at: 1) equals: kid refreshed.
	self assert: (mom refreshed children at: 2 at: 1) equals: man refreshed.
	self assert: (mom refreshed children at: 1 at: 2) equals: woman refreshed
!

testPeerIdentity
	mom save.
	kid mother: mom.
	kid save.
	self flushAndReload.
	self assert: kid refreshed mother = mom refreshed
!

testResolveReferences
	mom save.
	kid mother: mom asReferenceMarker.
	kid sandstoneResolveReferences.
	self assert: (kid mother isKindOf: SDActiveRecord)
!

testResolveReferencesRecursive
	mom save.
	kid buddy: #not -> mom asReferenceMarker.
	kid sandstoneResolveReferences.
	self assert: (kid buddy value isKindOf: SDActiveRecord)
!

testResolveReferencesRecursiveDeeperNestedList
	mom save.
	kid buddy: #not -> (Array with: (Array with: mom asReferenceMarker)).
	kid sandstoneResolveReferences.
	self assert: (kid buddy value first first isKindOf: SDActiveRecord)
!

testSaveInBlock
	kid save: [ self assert: kid isNew ].
	self deny: kid isNew
!

testSemaphorSerialization
	mom children: Semaphore new.
	self should: [ mom save ] raise: SDCommitError
!

testSetSerialization
	kid save.
	mom children: (Set with: kid).
	mom save.
	self flushAndReload.
	self assert: (mom refreshed children includes: kid refreshed)
!

testTypes
	| values |
	values := {nil. true. 1. $d. 'test'}.
	kid buddy: values.
	kid save.
	self flushAndReload.
	self assert: kid refreshed buddy = values
!

testUpdatedOn
	kid save.
	self assert: kid updatedOn <= DateAndTime now
!

testVersion
	self assert: kid version equals: 0.
	kid save.
	self assert: kid version equals: 1.
	kid save.
	self assert: kid version equals: 2
! !

!SDActiveRecordTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/SDActiveRecordTests.st,v 1.4 2013-04-17 23:47:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/sandstoneDb/tests/SDActiveRecordTests.st,v 1.4 2013-04-17 23:47:36 cg Exp $'
! !

