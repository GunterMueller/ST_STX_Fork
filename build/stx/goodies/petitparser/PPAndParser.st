"{ Package: 'stx:goodies/petitparser' }"

PPDelegateParser subclass:#PPAndParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPAndParser methodsFor:'operations'!

and
	^ self
! !

!PPAndParser methodsFor:'parsing'!

parseOn: aPPContext
	| element memento |
	memento := aPPContext remember.
	element := parser parseOn: aPPContext.
	aPPContext restore: memento.
	^ element
! !

!PPAndParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPAndParser.st,v 1.3 2012-05-04 22:08:57 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPAndParser.st,v 1.3 2012-05-04 22:08:57 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: PPAndParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

