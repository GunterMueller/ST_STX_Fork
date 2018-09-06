"{ Namespace: 'CodingExamples' }"

"
For a good time, file the following class definition into VisualWorks 1.0 
(or your favorite Smalltalk) and try it out, viz: BlockTester new runBlock.
I'd be interested to hear (1) plausible explanations of why it does what it 
does in PPST, (2) discussion of what it should do, and (3) descriptions of 
what it does in other dialects.
"

'From Objectworks\Smalltalk(R), Release 4.1 of 15 April 1992
ENVY/Developer R1.41 of 1 February 1993 on 28 September 1994 at 9:55:48 am'!

Object subclass: #BlockTester
	instanceVariableNames: 'testBlock answerFoo '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'examples-WDG'!


!BlockTester methodsFor: 'accessing'!

answerFoo
	^answerFoo!

answerFoo: aBoolean 
	^answerFoo := aBoolean!

testBlock
	^testBlock!

testBlock: aBlock
	^testBlock := aBlock! !

!BlockTester methodsFor: 'blocks'!

initBlock
	"Locality of foo doesn't affect behavior.
	Put it here so we can see it on debug."
	| foo |
	self
		testBlock: 
			[foo := 'hi there'.
			self answerFoo ifTrue: [^foo].
			false].
	^self!

runBlock
	^self testBlock value.! !

!BlockTester methodsFor: 'initialize-release'!

initialize
	self answerFoo: true.
	self initBlock.
	^self! !
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

BlockTester class
	instanceVariableNames: ''!


!BlockTester class methodsFor: 'instance creation'!

new
	^super new initialize! !

