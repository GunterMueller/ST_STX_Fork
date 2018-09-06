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

RxmLink subclass:#RxmPredicate
	instanceVariableNames:'predicate'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Matcher'
!

RxmPredicate comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

Instance holds onto a one-argument block and matches exactly one character if the block evaluates to true when passed the character as the argument.

Instance variables:
	predicate               <BlockClosure>'
!

!RxmPredicate class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxmPredicate class methodsFor:'instance creation'!

with: unaryBlock

	^self new predicate: unaryBlock
! !

!RxmPredicate methodsFor:'initialize-release'!

beAny
	"Analog of `.' in a regex: match any character except whitespace."

	self predicate: [:char | char isSeparator not]
!

beCharacter: aCharacter
	"Match the specific character."

	self predicate: [:char | char = aCharacter]
!

beCharacterSet: characters
	"Match any character in a <characters>, which is anything
	able to respond to #includes:." 

	self predicate: [:char | characters includes: char]
!

beNotCharacterSet: characters
	"Match anything not in the <characters>, which is
	anything responding reasonably to #includes:."

	self predicate: [:char | (characters includes: char) not]
!

bePerform: aSelector
	"Match any single character that answers true  to this message."

	self predicate: 
		[:char | 
		RxParser doHandlingMessageNotUnderstood: [char perform: aSelector]]
!

bePerformNot: aSelector
	"Match any single character that answers false to this message."

	self predicate: 
		[:char | 
		RxParser doHandlingMessageNotUnderstood: [(char perform: aSelector) not]]
!

predicate: aBlock
        "This link will match any single character for which <aBlock>
        evaluates to true."

        aBlock argumentCount ~= 1 ifTrue: [self error: 'bad predicate block'].
        predicate := aBlock.
        ^self
! !

!RxmPredicate methodsFor:'matching'!

matchAgainst: aMatcher
        "Match if the predicate block evaluates to true when given the
        current stream character as the argument."

        | original |

        "/ cg: the following change makes matching almost twice as
        "/ as fast.

        aMatcher atEnd ifTrue:[^ false].
        (predicate value:(aMatcher peek)) ifFalse:[^ false].
        original := aMatcher currentState.
        aMatcher next.
        (next matchAgainst: aMatcher) ifTrue:[^ true].
        aMatcher restoreState: original.
        ^ false.
"/
"/        original := aMatcher currentState.
"/        (aMatcher atEnd not 
"/                and: [(predicate value: aMatcher next)
"/                        and: [next matchAgainst: aMatcher]])
"/                ifTrue: [^true]
"/                ifFalse:
"/                        [aMatcher restoreState: original.
"/                        ^false]
! !

!RxmPredicate class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmPredicate.st,v 1.7 2015-06-19 05:20:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxmPredicate.st,v 1.7 2015-06-19 05:20:59 cg Exp $'
! !

