"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsSpecial
	instanceVariableNames:'kind'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsSpecial comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

One of a few special nodes:
	- any
	- beginning-of-line
	- end-of-line

Instance variables:
	kind    <#any | #bol | #eol>'
!

!RxsSpecial class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsSpecial methodsFor:'accessing'!

dispatchTo: aBuilder

	kind == #any ifTrue: [^aBuilder syntaxAny].
	kind == #bol ifTrue: [^aBuilder syntaxBeginningOfLine].
	kind == #eol ifTrue: [^aBuilder syntaxEndOfLine].
	self error: 'bad special node'
! !

!RxsSpecial methodsFor:'initialize-release'!

beAny
	"Dot, matches any non-whitespace character."

	kind := #any
!

beBeginningOfLine
	"Matches empty string at the beginning of a line."

	kind := #bol
!

beEndOfLine
	"Matches empty string at the end of a line."

	kind := #eol
! !

!RxsSpecial methodsFor:'testing'!

isNullable
	"Beginning-of-line and end-of-line conditions are nullable,
	any-character is not."

	^kind ~= #any
! !

!RxsSpecial class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsSpecial.st,v 1.5 2009-10-01 07:06:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsSpecial.st,v 1.5 2009-10-01 07:06:09 cg Exp $'
! !
