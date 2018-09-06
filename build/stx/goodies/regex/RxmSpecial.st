"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxmLink subclass:#RxmSpecial
	instanceVariableNames:'condition matchSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Matcher'
!

RxmSpecial comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

A special node that matches a specific matcher state rather than any input character.
The state is either at-beginning-of-line or at-end-of-line.'
!

!RxmSpecial class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxmSpecial methodsFor:'initialize-release'!

beBeginningOfLine

	matchSelector := #atBeginningOfLine
!

beBeginningOfWord

	matchSelector := #atBeginningOfWord
!

beEndOfLine

	matchSelector := #atEndOfLine
!

beEndOfWord

	matchSelector := #atEndOfWord
!

beNotWordBoundary

	matchSelector := #notAtWordBoundary
!

beWordBoundary

	matchSelector := #atWordBoundary
! !

!RxmSpecial methodsFor:'matching'!

matchAgainst: aMatcher
	"Match without consuming any input, if the matcher is
	in appropriate state."

	^(aMatcher perform: matchSelector)
		and: [next matchAgainst: aMatcher]
! !

!RxmSpecial class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmSpecial.st,v 1.5 2009-10-01 07:55:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmSpecial.st,v 1.5 2009-10-01 07:55:18 cg Exp $'
! !
