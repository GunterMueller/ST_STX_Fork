"{ Package: 'stx:goodies/petitparser' }"

PPFlattenParser subclass:#PPTokenParser
	instanceVariableNames:'tokenClass'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPTokenParser methodsFor:'*petitanalyzer-matching'!

match: aParser inContext: aDictionary seen: anIdentitySet
	^ (super match: aParser inContext: aDictionary seen: anIdentitySet) and: [ self tokenClass = aParser tokenClass ]
! !

!PPTokenParser methodsFor:'accessing'!

tokenClass
	^ tokenClass
!

tokenClass: aTokenClass
	tokenClass := aTokenClass
! !

!PPTokenParser methodsFor:'initialization'!

initialize
	tokenClass := self defaultTokenClass
	
! !

!PPTokenParser methodsFor:'private'!

create: aCollection start: aStartInteger stop: aStopInteger
	^ self tokenClass on: aCollection start: aStartInteger stop: aStopInteger
!

defaultTokenClass
	^ PPToken
!

on: aCollection start: aStartInteger stop: aStopInteger value: anObject
	^ self tokenClass on: aCollection start: aStartInteger stop: aStopInteger value: anObject
! !

!PPTokenParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPTokenParser.st,v 1.4 2014-03-04 14:33:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPTokenParser.st,v 1.4 2014-03-04 14:33:27 cg Exp $'
!

version_SVN
    ^ '$Id: PPTokenParser.st,v 1.4 2014-03-04 14:33:27 cg Exp $'
! !

