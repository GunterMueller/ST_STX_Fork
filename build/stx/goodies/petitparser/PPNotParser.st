"{ Package: 'stx:goodies/petitparser' }"

PPDelegateParser subclass:#PPNotParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!




!PPNotParser methodsFor:'parsing'!

parseOn: aPPContext
	| element memento |
	memento := aPPContext remember.
	element := parser parseOn: aPPContext.
	aPPContext restore: memento.
	^ element isPetitFailure
		ifFalse: [ PPFailure message: '' context: aPPContext ]
! !

!PPNotParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPNotParser.st,v 1.3 2012-05-04 22:06:22 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPNotParser.st,v 1.3 2012-05-04 22:06:22 vrany Exp $'
!

version_SVN
    ^ '§Id: PPNotParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

