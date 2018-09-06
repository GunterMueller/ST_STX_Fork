"{ Package: 'stx:goodies/petitparser' }"

PPDelegateParser subclass:#PPEndOfInputParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPEndOfInputParser methodsFor:'operations'!

end
	^ self
! !

!PPEndOfInputParser methodsFor:'parsing'!

parseOn: aPPContext
	| memento result |
	memento := aPPContext remember.
	result := parser parseOn: aPPContext.
	(result isPetitFailure or: [ aPPContext stream atEnd ])
		ifTrue: [ ^ result ].
	result := PPFailure
		message: 'end of input expected'
		context: aPPContext.
	aPPContext restore: memento.
	^ result
! !

!PPEndOfInputParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPEndOfInputParser.st,v 1.3 2012-05-04 22:02:18 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPEndOfInputParser.st,v 1.3 2012-05-04 22:02:18 vrany Exp $'
!

version_SVN
    ^ '§Id: PPEndOfInputParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

