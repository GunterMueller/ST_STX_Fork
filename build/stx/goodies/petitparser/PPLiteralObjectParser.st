"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

PPLiteralParser subclass:#PPLiteralObjectParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitParser-Parsers'
!



!PPLiteralObjectParser methodsFor:'operators'!

caseInsensitive
	"Answer a parser that can parse the receiver case-insensitive."
	
	literal asUppercase = literal asLowercase ifTrue: [ ^ self ].
	^ PPPredicateObjectParser on: [ :value | literal sameAs: value ] message: message
!

negate
	^ (PPPredicateObjectParser expect: literal message: message) negate
! !

!PPLiteralObjectParser methodsFor:'parsing'!

parseOn: aPPContext
	^ (aPPContext stream atEnd not and: [ literal = aPPContext stream uncheckedPeek ])
		ifFalse: [ PPFailure message: message context: aPPContext ]
		ifTrue: [ aPPContext stream next ]
! !

!PPLiteralObjectParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLiteralObjectParser.st,v 1.4 2014-03-04 14:33:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/PPLiteralObjectParser.st,v 1.4 2014-03-04 14:33:00 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: PPLiteralObjectParser.st,v 1.4 2014-03-04 14:33:00 cg Exp $'
! !

