"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

Object subclass:#RxmLink
	instanceVariableNames:'next'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Matcher'
!

RxmLink comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

A matcher is built of a number of links interconnected into some intricate structure. Regardless of fancy stuff, any link (except for the terminator) has the next one. Any link can match against a stream of characters, recursively propagating the match to the next link. Any link supports a number of matcher-building messages. This superclass does all of the above. 

The class is not necessarily abstract. It may double as an empty string matcher: it recursively propagates the match to the next link, thus always matching nothing successfully.

Principal method:
	matchAgainst: aMatcher
		Any subclass will reimplement this to test the state of the matcher, most
		probably reading one or more characters from the matcher''s stream, and
		either decide it has matched and answer true, leaving matcher stream
		positioned at the end of match, or answer false and restore the matcher
		stream position to whatever it was before the matching attempt.

Instance variables:
	next            <RxmLink | RxmTerminator> The next link in the structure.'
!

!RxmLink class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxmLink class methodsFor:'instance creation'!

new

        ^self basicNew initialize
! !

!RxmLink methodsFor:'building'!

pointTailTo: anRxmLink
	"Propagate this message along the chain of links.
	Point `next' reference of the last link to <anRxmLink>.
	If the chain is already terminated, blow up."

	next == nil
		ifTrue: [next := anRxmLink]
		ifFalse: [next pointTailTo: anRxmLink]
!

terminateWith: aTerminator
	"Propagate this message along the chain of links, and
	make aTerminator the `next' link of the last link in the chain.
	If the chain is already reminated with the same terminator, 
	do not blow up."

	next == nil
		ifTrue: [next := aTerminator]
		ifFalse: [next terminateWith: aTerminator]
! !

!RxmLink methodsFor:'initialize-release'!

initialize
	"Subclasses may want to initialize."
!

next: aLink
	"Set the next link, either an RxmLink or an RxmTerminator."

	next := aLink
! !

!RxmLink methodsFor:'matching'!

matchAgainst: aMatcher
	"If a link does not match the contents of the matcher's stream,
	answer false. Otherwise, let the next matcher in the chain match."

	^next matchAgainst: aMatcher
!

next
        
	^next
! !

!RxmLink class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmLink.st,v 1.6 2010-06-14 10:53:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmLink.st,v 1.6 2010-06-14 10:53:55 cg Exp $'
! !
