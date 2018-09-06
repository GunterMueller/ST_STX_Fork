"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsMessagePredicate
	instanceVariableNames:'selector negated'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsMessagePredicate comment:'-- Regular Expression Matcher v 1.1 (C) 1996, 1999 Vassili Bykov
-- See `documentation'' protocol of RxParser class for user''s guide.
--
A message predicate represents a condition on a character that is tested (at the match time) by sending a unary message to the character expecting a Boolean answer.

Instance variables:
	selector		<Symbol>'
!

!RxsMessagePredicate class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsMessagePredicate methodsFor:'accessing'!

dispatchTo: aBuilder
	"Inform the matcher of the kind of the node, and it
	will do whatever it has to."

	^aBuilder syntaxMessagePredicate: self
!

negated

	^negated
!

selector

	^selector
! !

!RxsMessagePredicate methodsFor:'initialize-release'!

initializeSelector: aSelector
	"The selector must be a one-argument message understood by Character."

	selector := aSelector
!

initializeSelector: aSelector negated: aBoolean
	"The selector must be a one-argument message understood by Character."

	selector := aSelector.
	negated := aBoolean
! !

!RxsMessagePredicate class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsMessagePredicate.st,v 1.4 2009-10-01 07:04:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsMessagePredicate.st,v 1.4 2009-10-01 07:04:48 cg Exp $'
! !
