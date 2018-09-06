"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsCharClass
	instanceVariableNames:'selector negated'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsCharClass comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

A predicate holds a selector. Any character that responds true to the selector will match.

Instance variables:
	selector                <Symbol>'
!

!RxsCharClass class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsCharClass methodsFor:'accessing'!

dispatchTo: aBuilder
	"Inform the matcher of the kind of the node, and it
	will do whatever it has to."

	^aBuilder syntaxCharClass: self
!

negated

	^negated
!

selector

	^selector
! !

!RxsCharClass methodsFor:'initialize-release'!

initializeSelector: aSelector
	"The selector must be a one-argument message understood by Character."

	selector := aSelector
!

initializeSelector: aSelector negated: aBoolean
	"The selector must be a one-argument message understood by Character."

	selector := aSelector.
	negated := aBoolean
! !

!RxsCharClass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsCharClass.st,v 1.4 2009-10-01 07:06:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsCharClass.st,v 1.4 2009-10-01 07:06:18 cg Exp $'
! !
