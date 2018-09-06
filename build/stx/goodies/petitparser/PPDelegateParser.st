"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPParser subclass:#PPDelegateParser
	instanceVariableNames:'parser'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPDelegateParser class methodsFor:'instance creation'!

on: aParser
	^ self new setParser: aParser
! !




!PPDelegateParser methodsFor:'accessing'!

children
	^ Array with: parser
! !

!PPDelegateParser methodsFor:'initialization'!

setParser: aParser
	parser := aParser
! !

!PPDelegateParser methodsFor:'parsing'!

parseOn: aPPContext
	^ parser parseOn: aPPContext
! !

!PPDelegateParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPDelegateParser.st,v 1.4 2014-03-04 14:32:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPDelegateParser.st,v 1.4 2014-03-04 14:32:24 cg Exp $'
!

version_SVN
    ^ '$Id: PPDelegateParser.st,v 1.4 2014-03-04 14:32:24 cg Exp $'
! !

