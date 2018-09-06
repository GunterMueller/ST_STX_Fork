"{ Package: 'stx:goodies/petitparser' }"

PPLimitedRepeatingParser subclass:#PPLazyRepeatingParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPLazyRepeatingParser methodsFor:'parsing'!

parseOn: aPPContext
	| memento element elements |
	memento := aPPContext remember.
	elements := OrderedCollection new.
	[ elements size < min ] whileTrue: [
		(element := parser parseOn: aPPContext) isPetitFailure ifTrue: [
			aPPContext restore: memento.
			^ element ].
		elements addLast: element ].
	[ self matchesLimitOn: aPPContext ] whileFalse: [
		elements size < max ifFalse: [
			aPPContext restore: memento.
			^ PPFailure message: 'overflow' context: aPPContext at: memento position ].
		element := parser parseOn: aPPContext.
		element isPetitFailure ifTrue: [
			aPPContext restore: memento.
			^ element ].
		elements addLast: element ].
	^ elements asArray
! !

!PPLazyRepeatingParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLazyRepeatingParser.st,v 1.1 2014-03-04 14:32:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLazyRepeatingParser.st,v 1.1 2014-03-04 14:32:47 cg Exp $'
! !

