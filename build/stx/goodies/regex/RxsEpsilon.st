"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsEpsilon
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsEpsilon comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

This is an empty string.  It terminates some of the recursive constructs.'
!

!RxsEpsilon class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsEpsilon methodsFor:'building'!

dispatchTo: aBuilder
	"Inform the matcher of the kind of the node, and it
	will do whatever it has to."

	^aBuilder syntaxEpsilon
! !

!RxsEpsilon methodsFor:'testing'!

isNullable
	"See comment in the superclass."

	^true
! !

!RxsEpsilon class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsEpsilon.st,v 1.5 2009-10-01 07:06:26 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsEpsilon.st,v 1.5 2009-10-01 07:06:26 cg Exp $'
! !
