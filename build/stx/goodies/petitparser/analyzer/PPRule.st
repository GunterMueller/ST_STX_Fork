"{ Package: 'stx:goodies/petitparser/analyzer' }"

Object subclass:#PPRule
	instanceVariableNames:'owner search'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPRule class methodsFor:'instance creation'!

new
	^ self basicNew initialize
!

searchFor: aParser
	^ self new setSearch: aParser
! !

!PPRule methodsFor:'initialization'!

initialize
!

setOwner: aGrammarSearcher
	owner := aGrammarSearcher
!

setSearch: aParser
	search := aParser
! !

!PPRule methodsFor:'matching'!

canMatch: aParser 
	^ true
!

foundMatchFor: aParser 
	self subclassResponsibility
!

performOn: aParser
	(search match: aParser inContext: owner context)
		ifFalse: [ ^ nil ].
	(self canMatch: aParser)
		ifFalse: [ ^ nil ].
	^ self foundMatchFor: aParser
! !

!PPRule class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPRule.st,v 1.2 2014-03-04 20:27:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPRule.st,v 1.2 2014-03-04 20:27:51 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

