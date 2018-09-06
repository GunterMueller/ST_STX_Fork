"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxmLink subclass:#RxmBranch
	instanceVariableNames:'loopback alternative'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Matcher'
!

RxmBranch comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

This is a branch of a matching process. Either `next'' chain should match, or `alternative'', if not nil, should match. Since this is also used to build loopbacks to match repetitions, a `loopback'' variable controls whether the instance is a loopback: it affects the matcher-building operations.

Instance variables
	alternative             <RxmLink> to match if `next'' fails to match.
	loopback                <Boolean>'
!

!RxmBranch class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxmBranch methodsFor:'building'!

pointTailTo: aNode
	"See superclass for explanations."

	loopback
		ifTrue: [alternative == nil
			ifTrue: [alternative := aNode]
			ifFalse: [alternative pointTailTo: aNode]]
		ifFalse: [super pointTailTo: aNode]
!

terminateWith: aNode
	"See superclass for explanations."

	loopback
		ifTrue: [alternative == nil
			ifTrue: [alternative := aNode]
			ifFalse: [alternative terminateWith: aNode]]
		ifFalse: [super terminateWith: aNode]
! !

!RxmBranch methodsFor:'initialize-release'!

alternative: aBranch
	"See class comment for instance variable description."

	alternative := aBranch
!

beLoopback
	"See class comment for instance variable description."

	loopback := true
!

initialize
	"See class comment for instance variable description."

	loopback := false
! !

!RxmBranch methodsFor:'matching'!

matchAgainst: aMatcher
	"Match either `next' or `alternative'. Fail if the alternative is nil."

	^(next matchAgainst: aMatcher)
		or: [alternative notNil
			and: [alternative matchAgainst: aMatcher]]
! !

!RxmBranch class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmBranch.st,v 1.5 2009-10-01 07:55:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmBranch.st,v 1.5 2009-10-01 07:55:53 cg Exp $'
! !
