"{ Package: 'stx:goodies/petitparser' }"

PPLiteralParser subclass:#PPLiteralSequenceParser
	instanceVariableNames:'size'
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!


!PPLiteralSequenceParser methodsFor:'accessing'!

size
	"Answer the sequence size of the receiver."

	^ size
! !

!PPLiteralSequenceParser methodsFor:'initialization'!

initializeOn: anObject message: aString
	super initializeOn: anObject message: aString.
	size := literal size
! !

!PPLiteralSequenceParser methodsFor:'operators'!

caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."
	
	literal asUppercase = literal asLowercase ifTrue: [ ^ self ].
	^ PPPredicateSequenceParser on: [ :value | literal sameAs: value ] message: message size: size
! !

!PPLiteralSequenceParser methodsFor:'parsing'!

parseOn: aPPContext
	| memento result |
	memento := aPPContext remember.
	result := aPPContext next: size.
	literal = result ifTrue: [ ^ result ].
	aPPContext restore: memento.
	^ PPFailure message: message context: aPPContext
! !

!PPLiteralSequenceParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLiteralSequenceParser.st,v 1.3 2012-05-04 21:58:27 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLiteralSequenceParser.st,v 1.3 2012-05-04 21:58:27 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: PPLiteralSequenceParser.st 2 2010-12-17 18:44:23Z vranyj1 §'
! !

