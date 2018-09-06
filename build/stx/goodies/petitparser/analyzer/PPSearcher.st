"{ Package: 'stx:goodies/petitparser/analyzer' }"

PPProcessor subclass:#PPSearcher
	instanceVariableNames:'answer'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPSearcher methodsFor:'initialization'!

setAnswer: anObject
	answer := anObject
! !

!PPSearcher methodsFor:'private'!

answer
	^ answer
! !

!PPSearcher methodsFor:'public'!

execute: aParser
	"Perform the search rules of the receiver on aParser. Answer the result of the search."

	^ self execute: aParser initialAnswer: nil
!

execute: aParser initialAnswer: anObject
	"Perform the search rules of the receiver on aParser. Inject anObject into the matches and answer the result."

	| previous |
	previous := context.
	answer := anObject.
	context := Dictionary new.
	aParser allParsersDo: [ :each | 
		self performRulesOn: each ].
	context := previous.
	^ answer
! !

!PPSearcher methodsFor:'rules'!

matches: aParser do: anAnswerBlock
	"Add a search expression aParser, evaluate anAnswerBlock with the matched node and the previous answer."

	self addRule: (PPSearchRule searchFor: aParser thenDo: anAnswerBlock)
!

matchesAnyOf: aCollectionOfParsers do: anAnswerBlock
	"Add a collection of search expressions aCollectionOfParsers, evaluate anAnswerBlock with the matched node and the previous answer."
	
	aCollectionOfParsers
		do: [ :each | self matches: each do: anAnswerBlock ]
! !

!PPSearcher class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPSearcher.st,v 1.2 2014-03-04 20:27:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPSearcher.st,v 1.2 2014-03-04 20:27:52 cg Exp $'
! !

