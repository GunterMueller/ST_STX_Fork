"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

Object subclass:#RxmTerminator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Matcher'
!

RxmTerminator comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

Instances of this class are used to terminate matcher''s chains. When a match reaches this (an instance receives #matchAgainst: message), the match is considered to succeed. Instances also support building protocol of RxmLinks, with some restrictions.'
!

!RxmTerminator class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxmTerminator methodsFor:'building'!

pointTailTo: anRxmLink
	"Branch tails are never redirected by the build algorithm.
	Healthy terminators should never receive this."

	RxParser signalCompilationException:
		'internal matcher build error - redirecting terminator tail'
!

terminateWith: aTerminator
	"Branch terminators are never supposed to change.
	Make sure this is the case."

	aTerminator ~~ self
		ifTrue: [RxParser signalCompilationException:
				'internal matcher build error - wrong terminator']
! !

!RxmTerminator methodsFor:'matching'!

matchAgainst: aStream
	"If got here, the match is successful."

	^true
! !

!RxmTerminator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmTerminator.st,v 1.5 2009-10-01 07:56:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmTerminator.st,v 1.5 2009-10-01 07:56:00 cg Exp $'
! !
