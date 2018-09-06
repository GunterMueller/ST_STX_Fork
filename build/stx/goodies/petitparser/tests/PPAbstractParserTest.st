"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#PPAbstractParserTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Core'
!


!PPAbstractParserTest class methodsFor:'accessing'!

packageNamesUnderTest
	^ #('PetitParser' 'PetitTests')
! !

!PPAbstractParserTest class methodsFor:'testing'!

isAbstract
	^ self name = #PPAbstractParserTest
! !

!PPAbstractParserTest methodsFor:'context'!

context
	^ PPContext new
! !

!PPAbstractParserTest methodsFor:'utilities'!

assert: aParser fail: aCollection
	^ self assert: aParser fail: aCollection end: 0
!

assert: aParser fail: aCollection end: anInteger
	| stream result context |
	self 
		assert: aParser isPetitParser
		description: 'Parser invalid'.
	stream := aCollection asPetitStream.
	context := self context.
	
	
	result := aParser parse: stream withContext: context.
	self 
		assert: result isPetitFailure
		description: 'Parser did not fail'.
	self
		assert: context position = anInteger
		description: 'Parser failed at wrong position'.
	^ result
!

assert: string1 includesSubstring: string2
	"Support portability by using ANSI search method"

	self assert: (string1 notEmpty and: [string2 notEmpty and: [0 < (string1 indexOfSubCollection: string2 startingAt: 1)]])
!

assert: aParser parse: aCollection
	^ self assert: aParser parse: aCollection to: nil end: aCollection size 
!

assert: aParser parse: aCollection end: anInteger
	^ self assert: aParser parse: aCollection to: nil end: anInteger
!

assert: aParser parse: aCollection to: anObject
	^ self assert: aParser parse: aCollection to: anObject end: aCollection size 
!

assert: aParser parse: aCollection to: aTargetObject end: anInteger
	| stream result context |

	self assert: aParser isPetitParser description: 'Parser invalid'.
	stream := aCollection asPetitStream.
	context := self context.
	
	result := aParser parse: stream withContext: context.
	aTargetObject isNil
		ifTrue: [ self deny: result isPetitFailure ]
		ifFalse: [ self assert: result equals: aTargetObject ].
	self assert: context position = anInteger description: 'Parser accepted at wrong position'.
	^ result
!

assert: aParser parse: aCollection toToken: aStartInteger stop: aStopInteger
	^ self assert: aParser parse: aCollection toToken: aStartInteger stop: aStopInteger end: aCollection size
!

assert: aParser parse: aParserObject toToken: aStartInteger stop: aStopInteger end: anEndInteger
	| token |
	token := self
		assert: aParser
		parse: aParserObject
		to: nil
		end: anEndInteger.
	self assert: (token isKindOf: PPToken).
	self assert: token start equals: aStartInteger.
	self assert: token stop equals: aStopInteger.
	^ token
! !

!PPAbstractParserTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/tests/PPAbstractParserTest.st,v 1.2 2014-03-04 20:31:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/tests/PPAbstractParserTest.st,v 1.2 2014-03-04 20:31:52 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

