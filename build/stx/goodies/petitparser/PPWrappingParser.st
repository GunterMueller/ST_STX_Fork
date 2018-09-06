"{ Package: 'stx:goodies/petitparser' }"

PPActionParser subclass:#PPWrappingParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPWrappingParser methodsFor:'parsing'!

parseOn: aPPContext
	^ block value: aPPContext value: [ parser parseOn: aPPContext ]
! !

!PPWrappingParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPWrappingParser.st,v 1.3 2012-05-04 22:09:40 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPWrappingParser.st,v 1.3 2012-05-04 22:09:40 vrany Exp $'
!

version_SVN
    ^ '§Id: PPWrappingParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

