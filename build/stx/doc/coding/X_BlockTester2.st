"{ Namespace: 'CodingExamples' }"

"
This seems to have fixed the problem...
"

'From VisualWorks(R), Beta Release 2.0  of 23 April 1994
ENVY/Developer Beta 1.43 of 1 June 1994 on 28 September 1994 at 1:16:23 pm'!

Object subclass: #BlockTester2
	instanceVariableNames: 'testBlock answerFoo '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'examples-WDG'!


!BlockTester2 publicMethodsFor: 'accessing'!

answerFoo
	^answerFoo!

answerFoo: aBoolean 
	^answerFoo := aBoolean!

testBlock
	^testBlock!

testBlock: aBlock
	^testBlock := aBlock! !

!BlockTester2 publicMethodsFor: 'blocks'!

initBlock
	"Locality of foo doesn't affect behavior.
	Put it here so we can see it on debug."
	| foo |
	self
		testBlock: 
			[foo := 'hi there'.
			self answerFoo ifTrue: [ foo ] ifFalse: [ false ] ].!

runBlock
	^self testBlock value.! !

!BlockTester2 publicMethodsFor: 'initialize-release'!

initialize
	self answerFoo: true.
	self initBlock.
	^self! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!




!BlockTester2 class publicMethodsFor: 'instance creation'!

new
	^super new initialize! !




