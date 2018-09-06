"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsCharSet
	instanceVariableNames:'set negated elements'
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsCharSet comment:'-- Regular Expression Matcher v 1.1 (C) 1996, 1999 Vassili Bykov
-- See `documentation'' protocol of RxParser class for user''s guide.
--
A character set corresponds to a [...] construct in the regular expression.

Instance variables:
	elements	<OrderedCollection> An element can be one of: RxsCharacter, RxsRange, or RxsPredicate.
	negated		<Boolean>'
!

!RxsCharSet class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsCharSet methodsFor:'accessing'!

dispatchTo: aMatcher
	"Inform the matcher of the kind of the node, and it
	will do whatever it has to."

	^aMatcher syntaxCharSet: self
!

hasPredicates

	^elements contains: [:some | some isEnumerable not]
!

negated

	^negated
!

predicate
        ^ self predicateIgnoringCase:false
!

predicateIgnoringCase
        ^ self predicateIgnoringCase:true
!

predicateIgnoringCase:ignoringCase

        | predicate enumerable |
        enumerable := self enumerablePartPredicateIgnoringCase:ignoringCase.
        ^self hasPredicates
                ifFalse: [enumerable]
                ifTrue:
                        [predicate := self predicatePartPredicateIgnoringCase:ignoringCase.
                        negated
                                ifTrue: [[:char | (enumerable value: char) and: [predicate value: char]]]
                                ifFalse: [[:char | (enumerable value: char) or: [predicate value: char]]]]
!

predicates

	^(elements reject: [:some | some isEnumerable])
		collect: [:each | each predicate]
!

set

	^set
! !

!RxsCharSet methodsFor:'initialize-release'!

initializeElements: aCollection negated: aBoolean
	"See class comment for instance variables description."

	elements := aCollection.
	negated := aBoolean
!

initializeSet: aSet negated: aBoolean
	"See class comment for instance variables description."

	set := aSet.
	negated := aBoolean
! !

!RxsCharSet methodsFor:'privileged'!

enumerablePartPredicateIgnoringCase:ignoringCase
        | enumeration |
        enumeration := self optimalSet.
        ignoringCase ifTrue:[
            negated
                    ifTrue: [^[:char | (enumeration contains:[:ch | ch sameAs: char]) not]]
                    ifFalse: [^[:char | (enumeration contains:[:ch | ch sameAs: char])]]
        ].
        negated
                ifTrue: [^[:char | (enumeration includes: char) not]]
                ifFalse: [^[:char | enumeration includes: char]]
!

enumerableSet
	"Answer a collection of characters that make up the portion of me
	that can be enumerated."

	| set |
	set := Set new.
	elements do:
		[:each |
		each isEnumerable ifTrue: [each enumerateTo: set]].
	^set
!

optimalSet
        "Assuming the client with search the `set' using #includes:,
        answer a collection with the contents of `set', of the class
        that will provide the fastest lookup. Strings are faster than
        Sets for short strings."

        | set |
        set := self enumerableSet.
        ^ set.

"/ Converting to strings doesn't work with unicode characters,
"/ and String>>#include: isn't faster anyway in ST/X

"/        ^set size < 10
"/                ifTrue: [String withAll: set]
"/                ifFalse: [set]
!

predicatePartPredicateIgnoringCase:ignoringCase
        "Answer a predicate that tests all of my elements that cannot be
        enumerated."

        | predicates |
        predicates := elements reject: [:some | some isEnumerable].
        predicates isEmpty
                ifTrue: [^[:char | negated]].

        predicates size = 1
                ifTrue: [^negated
                        ifTrue: [predicates first predicateNegation]
                        ifFalse: [predicates first predicate]].

        predicates := predicates collect: [:each | each predicate].
        negated
                ifFalse:
                        [^[:char | predicates contains: [:some | some value: char]]]
                ifTrue:
                        [^[:char | (predicates contains: [:some | some value: char]) not]]
! !

!RxsCharSet methodsFor:'testing'!

isEnumerable

	elements detect: [:some | some isEnumerable not] ifNone: [^true].
	^false
!

isNegated

	^negated
! !

!RxsCharSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsCharSet.st,v 1.9 2013-01-30 13:08:40 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsCharSet.st,v 1.9 2013-01-30 13:08:40 stefan Exp $'
! !

