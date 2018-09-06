"{ Package: 'stx:goodies/petitparser' }"

PPListParser subclass:#PPChoiceParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPChoiceParser methodsFor:'operations'!

/ aRule 
	^ self copyWith: aRule
! !

!PPChoiceParser methodsFor:'parsing'!

parseOn: aPPContext
	"This is optimized code that avoids unnecessary block activations, do not change. When all choices fail, the last failure is answered."

	| element |
	1 to: parsers size do: [ :index |
		element := (parsers at: index)
			parseOn: aPPContext.
		element isPetitFailure
			ifFalse: [ ^ element ] ].
	^ element
! !

!PPChoiceParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPChoiceParser.st,v 1.3 2012-05-04 22:05:05 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPChoiceParser.st,v 1.3 2012-05-04 22:05:05 vrany Exp $'
!

version_SVN
    ^ '§Id: PPChoiceParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

