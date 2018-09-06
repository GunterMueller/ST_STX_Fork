"{ Encoding: utf8 }"

"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxmLink subclass:#RxmMarker
	instanceVariableNames:'index'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Matcher'
!

RxmMarker comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

A marker is used to remember positions of match of certain points of a regular expression. The marker receives an identifying key from the Matcher and uses that key to report positions of successful matches to the Matcher.

Instance variables:
	index   <Object> Something that makes sense for the Matcher. Received from the latter during initalization and later passed to it to identify the receiver.'
!

!RxmMarker class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxmMarker methodsFor:'initialize-release'!

index: anIndex
	"An index is a key that makes sense for the matcher.
	This key can be passed to marker position getters and
	setters to access position for this marker in the current
	matching session."

	index := anIndex
! !

!RxmMarker methodsFor:'matching'!

matchAgainst: aMatcher
        "If the rest of the link chain matches successfully, report the
        position of the stream *before* the match started to the matcher."

        | startPosition |

        startPosition := aMatcher position.
        next isNil ifTrue:[^ true].
        (next matchAgainst: aMatcher)
                ifTrue:
                        [aMatcher markerPositionAt: index maybePut: startPosition.
                        ^true].
        ^false
! !

!RxmMarker class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmMarker.st,v 1.7 2015-06-21 19:48:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmMarker.st,v 1.7 2015-06-21 19:48:31 cg Exp $'
! !

