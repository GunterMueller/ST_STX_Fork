"{ Package: 'stx:goodies/petitparser/tests' }"

"{ NameSpace: Smalltalk }"

PPAbstractParserTest subclass:#PPConditionalParserTests
	instanceVariableNames:'context'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitTests-Tests'
!


!PPConditionalParserTests methodsFor:'as yet unclassified'!

context
	^ context
!

setUp
	super setUp.
	context := PPContext new
!

testConditionCtxAccess
	| parser |

	parser := ('a' asParser if: [ :ctx | (ctx propertyAt: #foo) = #bar ]).
	
	context propertyAt: #foo put: #bar.
	self assert: parser parse: 'a' .


	context propertyAt: #foo put: #zorg.
	self assert: parser fail: 'a' .
!

testConditionFalse
	| parser |
	parser := ('a' asParser if: [ :ctx | false ]).
	
	self assert: parser fail: 'a'.
	self assert: parser fail: 'b'.
!

testConditionTrue
	| parser |
	parser := ('a' asParser if: [ :ctx | true ]).
	
	self assert: parser parse: 'a'.
	self assert: parser fail: 'b'.
! !

!PPConditionalParserTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

