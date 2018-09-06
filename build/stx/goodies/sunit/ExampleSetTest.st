"{ Package: 'stx:goodies/sunit' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#ExampleSetTest
	instanceVariableNames:'full empty'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Tests'
!


!ExampleSetTest methodsFor:'running'!

setUp
	empty := Set new.
	full := Set with: 5 with: #abc
! !

!ExampleSetTest methodsFor:'testing'!

testAdd
	empty add: 5.
	self assert: (empty includes: 5)
!

testGrow
	empty addAll: (1 to: 100).
	self assert: empty size = 100
!

testIllegal
	self
		should: [empty at: 5]
		raise: TestResult error.
	self
		should: [empty at: 5 put: #abc]
		raise: TestResult error
!

testIncludes
	self assert: (full includes: 5).
	self assert: (full includes: #abc)
!

testOccurrences
	self assert: (empty occurrencesOf: 0) = 0.
	self assert: (full occurrencesOf: 5) = 1.
	full add: 5.
	self assert: (full occurrencesOf: 5) = 1
!

testRemove
	full remove: 5.
	self assert: (full includes: #abc).
	self deny: (full includes: 5)
! !

!ExampleSetTest class methodsFor:'documentation'!

version_SVN
    ^ '§Id: ExampleSetTest.st 214 2011-03-14 12:22:21Z vranyj1 §'
! !

