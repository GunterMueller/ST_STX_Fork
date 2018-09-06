"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsRange
	instanceVariableNames:'first last'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsRange comment:'-- Regular Expression Matcher v 1.1 (C) 1996, 1999 Vassili Bykov
-- See `documentation'' protocol of RxParser class for user''s guide.
--
I represent a range of characters as appear in character classes such as

	[a-ZA-Z0-9].

I appear in a syntax tree only as an element of RxsCharSet.

Instance Variables:

	first	<Character>
	last	<Character>'
!

!RxsRange class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsRange class methodsFor:'instance creation'!

from: aCharacter to: anotherCharacter

	^self new initializeFirst: aCharacter last: anotherCharacter
! !

!RxsRange methodsFor:'accessing'!

enumerateTo: aCollection
    "Add all of the elements I represent to the collection."

"/    first asInteger to: last asInteger do: [:charCode |
"/        aCollection add: charCode asCharacter
"/    ]
    first to: last do: [:char |
        aCollection add: char
    ]

    "Modified: / 21-06-2017 / 13:30:47 / cg"
! !

!RxsRange methodsFor:'initialize-release'!

initializeFirst: aCharacter last: anotherCharacter

	first := aCharacter.
	last := anotherCharacter
! !

!RxsRange methodsFor:'testing'!

isEnumerable

	^true
! !

!RxsRange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsRange.st,v 1.5 2017-06-21 18:52:13 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsRange.st,v 1.5 2017-06-21 18:52:13 cg Exp $'
! !

