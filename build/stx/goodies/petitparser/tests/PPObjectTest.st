"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPObjectTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Tests'
!


!PPObjectTest methodsFor:'parsers'!

integer
	^ PPPredicateObjectParser
		on: [ :each | each isKindOf: Integer ]
		message: 'integer expected'
!

string
	^ PPPredicateObjectParser
		on: [ :each | each isKindOf: String ]
		message: 'string expected'
! !

!PPObjectTest methodsFor:'testing'!

testInteger
	self assert: self integer parse: #(123) to: 123.
	self assert: self integer fail: #('abc')
!

testString
	self assert: self string parse: #('abc') to: 'abc'.
	self assert: self string fail: #(123)
! !

!PPObjectTest methodsFor:'testing-fancy'!

testFibonacci
	"This parser accepts fibonacci sequences with arbitrary start pairs."
	
	| parser |
	parser := ((self integer , self integer) end ==> [ :pair | pair first + pair last ])
		/ (self integer , (self integer , self integer) and >=> [ :stream :continuation |
			| result |
			result := continuation value.
			(result isPetitFailure or: [ result first + result last first ~= result last last ])
				ifFalse: [ parser parseOn: stream ]
				ifTrue: [ PPFailure message: 'invalid fibonacci sequence' context: stream ] ]).
	self assert: parser parse: #(1 1) to: 2.
	self assert: parser parse: #(1 1 2) to: 3.
	self assert: parser parse: #(1 1 2 3) to: 5.
	self assert: parser parse: #(1 1 2 3 5) to: 8.
	self assert: parser parse: #(1 1 2 3 5 8) to: 13.
	self assert: parser parse: #(1 1 2 3 5 8 13) to: 21.
	self assert: parser fail: #().
	self assert: parser fail: #(1).
	self assert: parser fail: #(1 2 3 4) end: 2
	
! !

!PPObjectTest methodsFor:'testing-operators'!

testChoice
	| parser |
	parser := self integer / self string.
	self assert: parser parse: #(123) to: 123.
	self assert: parser parse: #('abc') to: 'abc'
!

testSequence
	| parser |
	parser := self integer , self string.
	self assert: parser parse: #(123 'abc') to: #(123 'abc').
	self assert: parser fail: #(123 456).
	self assert: parser fail: #('abc' 'def').
	self assert: parser fail: #('abc' 123)
	
! !

!PPObjectTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPObjectTest.st,v 1.4 2014-03-04 14:34:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPObjectTest.st,v 1.4 2014-03-04 14:34:19 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPObjectTest.st,v 1.4 2014-03-04 14:34:19 cg Exp $'
! !

