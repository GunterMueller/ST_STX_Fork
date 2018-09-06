"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxmLink subclass:#RxmSubstring
	instanceVariableNames:'sample compare'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Matcher'
!

RxmSubstring comment:'-- Regular Expression Matcher v 1.1 (C) 1996, 1999 Vassili Bykov
-- See `documentation'' protocol of RxParser class for user''s guide.
--
Instance holds onto a string and matches exactly this string, and exactly once.

Instance variables:
	string 	<String>'
!

!RxmSubstring class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxmSubstring methodsFor:'initialize-release'!

beCaseInsensitive

	compare := [:char1 :char2 | char1 sameAs: char2]
!

beCaseSensitive

	compare := [:char1 :char2 | char1 = char2]
!

character: aCharacter
        "Match exactly this character."

        sample := aCharacter asString
!

character: aCharacter ignoreCase: aBoolean
        "Match exactly this character."

        sample := aCharacter asString.
        aBoolean ifTrue: [self beCaseInsensitive]
!

initialize

	super initialize.
	self beCaseSensitive
!

substring: aString
	"Match exactly this string."

	sample := aString
!

substring: aString ignoreCase: aBoolean
	"Match exactly this string."

	sample := aString.
	aBoolean ifTrue: [self beCaseInsensitive]
! !

!RxmSubstring methodsFor:'matching'!

matchAgainst: aMatcher
	"Match if my sample stream is exactly the current prefix
	of the matcher stream's contents."

	| originalState sampleStream mismatch |
	originalState := aMatcher currentState.
	sampleStream := self sampleStream.
	mismatch := false.
	[sampleStream atEnd
		or: [aMatcher atEnd
		or: [mismatch := (compare value: sampleStream next value: aMatcher next) not]]] whileFalse.
	(mismatch not and: [sampleStream atEnd and: [next matchAgainst: aMatcher]])
		ifTrue: [^true]
		ifFalse: 
			[aMatcher restoreState: originalState.
			^false]
! !

!RxmSubstring methodsFor:'private'!

sampleStream

	^sample readStream
! !

!RxmSubstring class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmSubstring.st,v 1.6 2013-01-30 13:08:22 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmSubstring.st,v 1.6 2013-01-30 13:08:22 stefan Exp $'
! !

