"{ Package: 'stx:goodies/petitparser' }"

PPRepeatingParser subclass:#PPLimitedRepeatingParser
	instanceVariableNames:'limit'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPLimitedRepeatingParser class methodsFor:'instance creation'!

on: aParser limit: aLimitParser
	^ (self on: aParser) setLimit: aLimitParser
! !


!PPLimitedRepeatingParser methodsFor:'accessing'!

children
	^ Array with: parser with: limit
!

limit
	"Answer the parser that limits (or ends) this repetition."
	
	^ limit
! !

!PPLimitedRepeatingParser methodsFor:'initialization'!

setLimit: aParser
	limit := aParser
! !

!PPLimitedRepeatingParser methodsFor:'parsing'!

matchesLimitOn: aPPContext
	| element position |
	position := aPPContext remember.
	element := limit parseOn: aPPContext.
	aPPContext restore: position.
	^ element isPetitFailure not
! !

!PPLimitedRepeatingParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLimitedRepeatingParser.st,v 1.1 2014-03-04 14:32:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLimitedRepeatingParser.st,v 1.1 2014-03-04 14:32:55 cg Exp $'
! !

