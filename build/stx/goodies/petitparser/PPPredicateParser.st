"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPPredicateParser
	instanceVariableNames:'predicate predicateMessage negated negatedMessage'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPPredicateParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self block = aParser block and: [ self message = aParser message ] ]
! !

!PPPredicateParser methodsFor:'accessing'!

block
	"Answer the predicate block of the receiver."
	
	^ predicate
!

message
	"Answer the failure message."
	
	^ predicateMessage
! !

!PPPredicateParser methodsFor:'printing'!

printNameOn: aStream
	super printNameOn: aStream.
	aStream nextPutAll: ', '; print: predicateMessage
! !

!PPPredicateParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPredicateParser.st,v 1.4 2014-03-04 14:33:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPredicateParser.st,v 1.4 2014-03-04 14:33:21 cg Exp $'
!

version_SVN
    ^ '$Id: PPPredicateParser.st,v 1.4 2014-03-04 14:33:21 cg Exp $'
! !

