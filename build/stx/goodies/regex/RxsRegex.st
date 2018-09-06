"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsRegex
	instanceVariableNames:'branch regex'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsRegex comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

The body of a parenthesized thing, or a top-level expression, also an atom.  

Instance variables:
	branch          <RxsBranch>
	regex           <RxsRegex | RxsEpsilon>'
!

!RxsRegex class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsRegex methodsFor:'accessing'!

branch

	^branch
!

dispatchTo: aMatcher
	"Inform the matcher of the kind of the node, and it
	will do whatever it has to."

	^aMatcher syntaxRegex: self
!

regex
	^regex
! !

!RxsRegex methodsFor:'initialize-release'!

initializeBranch: aBranch regex: aRegex
	"See class comment for instance variable description."

	branch := aBranch.
	regex := aRegex
! !

!RxsRegex methodsFor:'testing'!

isNullable

	^branch isNullable or: [regex notNil and: [regex isNullable]]
! !

!RxsRegex class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsRegex.st,v 1.5 2009-10-01 07:05:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsRegex.st,v 1.5 2009-10-01 07:05:33 cg Exp $'
! !
