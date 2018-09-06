"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsPiece
	instanceVariableNames:'atom min max'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsPiece comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

A piece is an atom, possibly optional or repeated a number of times.

Instance variables:
	atom    <RxsCharacter|RxsCharSet|RxsPredicate|RxsRegex|RxsSpecial>
	min             <Integer>
	max     <Integer|nil> nil means infinity'
!

!RxsPiece class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsPiece methodsFor:'accessing'!

atom

	^atom
!

character
	"If this node is atomic, answer the character it
	represents. It is the caller's responsibility to make sure this
	node is indeed atomic before using this."

	^atom character
!

dispatchTo: aMatcher
	"Inform the matcher of the kind of the node, and it
	will do whatever it has to."

	^aMatcher syntaxPiece: self
!

max
	"The value answered may be nil, indicating infinity."

	^max
!

min

	^min
! !

!RxsPiece methodsFor:'initialize-release'!

initializeAtom: anAtom
	"This piece is exactly one occurrence of the specified RxsAtom."

	self initializeAtom: anAtom min: 1 max: 1
!

initializeAtom: anAtom min: minOccurrences max: maxOccurrences
	"This piece is from <minOccurrences> to <maxOccurrences> 
	occurrences of the specified RxsAtom."

	atom := anAtom.
	min := minOccurrences.
	max := maxOccurrences
!

initializeOptionalAtom: anAtom
	"This piece is 0 or 1 occurrences of the specified RxsAtom."

	self initializeAtom: anAtom min: 0 max: 1
!

initializePlusAtom: anAtom
	"This piece is one or more occurrences of the specified RxsAtom."

	self initializeAtom: anAtom min: 1 max: nil
!

initializeStarAtom: anAtom
	"This piece is any number of occurrences of the atom."

	self initializeAtom: anAtom min: 0 max: nil
! !

!RxsPiece methodsFor:'testing'!

isAtomic
	"A piece is atomic if only it contains exactly one atom
	which is atomic (sic)."

	^self isSingular and: [atom isAtomic]
!

isNullable
	"A piece is nullable if it allows 0 matches. 
	This is often handy to know for optimization."

	^min = 0 or: [atom isNullable]
!

isOptional

	^min = 0 and: [max = 1]
!

isPlus

	^min = 1 and: [max == nil]
!

isRepetition
    ^ min > 1 or:[max notNil and:[max > 1]]
!

isSingular
	"A piece with a range is 1 to 1 needs can be compiled
	as a simple match."

	^min = 1 and: [max = 1]
!

isStar

	^min = 0 and: [max == nil]
! !

!RxsPiece class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsPiece.st,v 1.7 2013-01-30 17:12:53 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsPiece.st,v 1.7 2013-01-30 17:12:53 stefan Exp $'
! !

