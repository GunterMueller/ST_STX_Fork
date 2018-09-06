"{ Package: 'stx:goodies/petitparser/analyzer' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PPProcessor
	instanceVariableNames:'searches context'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitAnalyzer-Core'
!


!PPProcessor class methodsFor:'instance creation'!

new
	^ self basicNew initialize
! !

!PPProcessor methodsFor:'initialization'!

initialize
	super initialize.
	searches := OrderedCollection new.
	context := Dictionary new
! !

!PPProcessor methodsFor:'private'!

context
	^ context
!

performRule: aRule on: aParser
	context := Dictionary new.
	^ aRule performOn: aParser
!

performRulesOn: aParser
	| result |
	searches do: [ :rule |
		result := self performRule: rule on: aParser.
		result notNil ifTrue: [ ^ result ] ].
	^ nil
! !

!PPProcessor methodsFor:'rules'!

addRule: aGrammarRule
	searches add: (aGrammarRule setOwner: self)
! !

!PPProcessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPProcessor.st,v 1.2 2014-03-04 20:27:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/analyzer/PPProcessor.st,v 1.2 2014-03-04 20:27:44 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

