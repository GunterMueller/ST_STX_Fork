"{ Package: 'stx:goodies/petitparser' }"

PPRepeatingParser subclass:#PPPossessiveRepeatingParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPPossessiveRepeatingParser methodsFor:'parsing'!

parseOn: aPPContext
	| memento element elements |
	memento := aPPContext remember.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aPPContext) isPetitFailure ifTrue: [
			aPPContext restore: memento.
			^ element ].
		elements addLast: element ].
	[ elements size < max ] whileTrue: [
	 	(element := parser parseOn: aPPContext) isPetitFailure
			ifTrue: [ ^ elements asArray ].
		elements addLast: element ].
	^ elements asArray
! !

!PPPossessiveRepeatingParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPossessiveRepeatingParser.st,v 1.1 2014-03-04 14:33:19 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPPossessiveRepeatingParser.st,v 1.1 2014-03-04 14:33:19 cg Exp $'
! !

