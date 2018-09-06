"{ Package: 'stx:goodies/petitparser' }"

PPDelegateParser subclass:#PPTrimmingParser
	instanceVariableNames:'trimmer'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPTrimmingParser class methodsFor:'instance creation'!

on: aParser trimmer: aTrimParser
	^ self new
		setParser: aParser;
		setTrimmer: aTrimParser;
		yourself
! !


!PPTrimmingParser methodsFor:'initialization'!

setTrimmer: aParser
	trimmer := aParser
! !

!PPTrimmingParser methodsFor:'parsing'!

parseOn: aPPContext
	| memento element |
	memento := aPPContext remember.
	[ (trimmer parseOn: aPPContext) isPetitFailure ]
		whileFalse.
	element := parser parseOn: aPPContext.
	element isPetitFailure ifTrue: [
		aPPContext restore: memento.
		^ element ].
	[ (trimmer parseOn: aPPContext) isPetitFailure ]
		whileFalse.
	^ element
! !

!PPTrimmingParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPTrimmingParser.st,v 1.3 2012-05-04 22:05:38 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPTrimmingParser.st,v 1.3 2012-05-04 22:05:38 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: PPTrimmingParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

