"{ Package: 'stx:goodies/petitparser' }"

PPParser subclass:#PPPluggableParser
	instanceVariableNames:'block'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPPluggableParser class methodsFor:'instance creation'!

on: aBlock
	^ self new initializeOn: aBlock
! !



!PPPluggableParser methodsFor:'accessing'!

block
	"Answer the pluggable block."

	^ block
! !

!PPPluggableParser methodsFor:'initialization'!

initializeOn: aBlock
	block := aBlock
! !

!PPPluggableParser methodsFor:'parsing'!

acceptsEpsilon
	^ false
!

parseOn: aPPContext
	| memento result |
	memento := aPPContext remember.
	result := block value: aPPContext.
	result isPetitFailure
		ifTrue: [ aPPContext restore: memento ].
	^ result
! !

!PPPluggableParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPluggableParser.st,v 1.4 2014-03-04 14:33:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPluggableParser.st,v 1.4 2014-03-04 14:33:12 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPPluggableParser.st,v 1.4 2014-03-04 14:33:12 cg Exp $'
! !

