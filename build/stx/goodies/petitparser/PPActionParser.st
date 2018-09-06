"{ Package: 'stx:goodies/petitparser' }"

PPDelegateParser subclass:#PPActionParser
	instanceVariableNames:'block'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPActionParser class methodsFor:'instance creation'!

on: aParser block: aBlock
	^ (self on: aParser) setBlock: aBlock
! !


!PPActionParser methodsFor:'accessing'!

block
	"Answer the action block of the receiver."

	^ block
! !

!PPActionParser methodsFor:'initialization'!

setBlock: aBlock
	block := aBlock
! !

!PPActionParser methodsFor:'parsing'!

parseOn: aPPContext
	| element |
	^ (element := parser parseOn: aPPContext) isPetitFailure
		ifFalse: [ block value: element ]
		ifTrue: [ element ]
! !

!PPActionParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPActionParser.st,v 1.4 2014-03-04 14:32:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPActionParser.st,v 1.4 2014-03-04 14:32:21 cg Exp $'
!

version_SVN
    ^ '$Id: PPActionParser.st,v 1.4 2014-03-04 14:32:21 cg Exp $'
! !

