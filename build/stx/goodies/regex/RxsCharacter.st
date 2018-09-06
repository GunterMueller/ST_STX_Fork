"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsCharacter
	instanceVariableNames:'character'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsCharacter comment:'-- Regular Expression Matcher v 1.1 (C) 1996, 1999 Vassili Bykov
-- See `documentation'''' protocol of RxParser class for user''''s guide.

A character is a literal character.

Instance variables:
        character               <Character>
'
!

!RxsCharacter class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsCharacter class methodsFor:'instance creation'!

with: aCharacter

	^self new initializeCharacter: aCharacter
! !

!RxsCharacter methodsFor:'accessing'!

character

	^character
!

dispatchTo: aMatcher
	"Inform the matcher of the kind of the node, and it
	will do whatever it has to."

	^aMatcher syntaxCharacter: self
!

enumerateTo: aCollection

	aCollection add: character
! !

!RxsCharacter methodsFor:'initialize-release'!

initializeCharacter: aCharacter
	"See class comment for instance variable description."

	character := aCharacter
! !

!RxsCharacter methodsFor:'testing'!

isAtomic
	"A character is always atomic."

	^true
!

isEnumerable

	^true
!

isNullable

	^false
! !

!RxsCharacter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsCharacter.st,v 1.5 2009-10-01 07:05:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsCharacter.st,v 1.5 2009-10-01 07:05:14 cg Exp $'
! !
