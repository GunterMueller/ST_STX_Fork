"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPDelegateParser subclass:#PPConditionalParser
	instanceVariableNames:'block'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!

!PPConditionalParser class methodsFor:'as yet unclassified'!

on: aPPParser block: block
	^ (PPConditionalParser on: aPPParser)
		block: block;
		yourself
! !

!PPConditionalParser methodsFor:'accessing'!

block: aBlock
	block := aBlock
! !

!PPConditionalParser methodsFor:'parsing'!

parseOn: aPPContext
	^ (block value: aPPContext) 
		ifTrue: [ parser parseOn: aPPContext ]
		ifFalse: [ PPFailure message: block asString, ' was not evaluated to true.' context: aPPContext ]
! !

