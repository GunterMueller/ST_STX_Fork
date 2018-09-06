"{ Package: 'stx:goodies/petitparser' }"

PPDelegateParser subclass:#PPOptionalParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!



!PPOptionalParser methodsFor:'parsing'!

parseOn: aPPContext
	| element |
	element := parser parseOn: aPPContext.
	^ element isPetitFailure ifFalse: [ element ]
! !

!PPOptionalParser class methodsFor:'documentation'!

version_SVN
    ^ '$Id: PPOptionalParser.st,v 1.4 2014-03-04 14:33:10 cg Exp $'
! !

