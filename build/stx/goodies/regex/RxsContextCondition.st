"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsContextCondition
	instanceVariableNames:'kind'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsContextCondition comment:'-- Regular Expression Matcher v 1.1 (C) 1996, 1999 Vassili Bykov
-- See `documentation'' protocol of RxParser class for user''s guide.
--
One of a few special nodes more often representing special state of the match rather than a predicate on a character.  The ugly exception is the #any condition which *is* a predicate on a character.

Instance variables:
	kind		<Selector>'
!

!RxsContextCondition class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsContextCondition methodsFor:'accessing'!

dispatchTo: aBuilder

	^aBuilder perform: kind
! !

!RxsContextCondition methodsFor:'initialize-release'!

beAny
	"Matches anything but a newline."

	kind := #syntaxAny
!

beBeginningOfLine
	"Matches empty string at the beginning of a line."

	kind := #syntaxBeginningOfLine
!

beBeginningOfWord
	"Matches empty string at the beginning of a word."

	kind := #syntaxBeginningOfWord
!

beEndOfLine
	"Matches empty string at the end of a line."

	kind := #syntaxEndOfLine
!

beEndOfWord
	"Matches empty string at the end of a word."

	kind := #syntaxEndOfWord
!

beNonWordBoundary
	"Analog of \B."

	kind := #syntaxNonWordBoundary
!

beWordBoundary
	"Analog of \w (alphanumeric plus _)."

	kind := #syntaxWordBoundary
! !

!RxsContextCondition methodsFor:'testing'!

isNullable

	^#syntaxAny ~~ kind
! !

!RxsContextCondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsContextCondition.st,v 1.4 2009-10-01 07:05:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsContextCondition.st,v 1.4 2009-10-01 07:05:51 cg Exp $'
! !
