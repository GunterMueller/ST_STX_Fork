"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

RxsNode subclass:#RxsPredicate
	instanceVariableNames:'predicate negation'
	classVariableNames:'EscapedLetterSelectors NamedClassSelectors'
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsPredicate comment:'-- Regular Expression Matcher v 1.1 (C) 1996, 1999 Vassili Bykov
-- See `documentation'' protocol of RxParser class for user''s guide.
--
This represents a character that satisfies a certain predicate.

Instance Variables:

	predicate	<BlockClosure>	A one-argument block. If it evaluates to the value defined by <negated> when it is passed a character, the predicate is considered to match.
	negation	<BlockClosure>	A one-argument block that is a negation of <predicate>.'
!

!RxsPredicate class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsPredicate class methodsFor:'instance creation'!

forEscapedLetter: aCharacter

	^self new perform:
		(EscapedLetterSelectors
			at: aCharacter
			ifAbsent: [RxParser signalSyntaxException: 'bad backslash escape'])
!

forNamedClass: aString

	^self new perform:
		(NamedClassSelectors
			at: aString
			ifAbsent: [RxParser signalSyntaxException: 'bad character class name'])
! !

!RxsPredicate class methodsFor:'class initialization'!

initialize
	"self initialize"

	self
		initializeNamedClassSelectors;
		initializeEscapedLetterSelectors
!

initializeEscapedLetterSelectors
        "self initializeEscapedLetterSelectors"

        (EscapedLetterSelectors := Dictionary new)
                at: $w put: #beWordConstituent;
                at: $W put: #beNotWordConstituent;
                at: $d put: #beDigit;
                at: $D put: #beNotDigit;
                at: $s put: #beSpace;
                at: $S put: #beNotSpace
!

initializeNamedClassSelectors
        "self initializeNamedClassSelectors"

        (NamedClassSelectors := Dictionary new)
                at: 'alnum' put: #beAlphaNumeric;
                at: 'alpha' put: #beAlphabetic;
                at: 'blank' put: #beBlank;
                at: 'cntrl' put: #beControl;
                at: 'digit' put: #beDigit;
                at: 'graph' put: #beGraphics;
                at: 'lower' put: #beLowercase;
                at: 'print' put: #bePrintable;
                at: 'punct' put: #bePunctuation;
                at: 'space' put: #beSpace;
                at: 'upper' put: #beUppercase;
                at: 'xdigit' put: #beHexDigit
! !

!RxsPredicate methodsFor:'accessing'!

dispatchTo: anObject

	^anObject syntaxPredicate: self
!

negated

	^self copy negate
!

predicate

	^predicate
!

predicateIgnoringCase:dummyBoolean
        ^predicate
!

predicateNegation

	^negation
!

value: aCharacter

	^predicate value: aCharacter
! !

!RxsPredicate methodsFor:'initialize-release'!

beAlphaNumeric
        predicate := [:char | char isNationalAlphaNumeric].
        negation := [:char | char isNationalAlphaNumeric not]
!

beAlphabetic

        predicate := [:char | char isNationalLetter].
        negation := [:char | char isNationalLetter not]
!

beAny

        | cr lf |
        cr := Character return.
        lf := Character lf.
        predicate := [:char | char ~= lf and: [char ~= cr]].
        negation := [:char | char = lf or: [char = cr]]
!

beBlank

        predicate := [:char | char == Character space or:[char == Character tab]].
        negation := [:char | char ~~ Character space and:[char ~~ Character tab]]
!

beControl
        #CUmodified. "use #isControl rather than testing ASCII value against 32"
        predicate := [:char | char isControl].
        negation := [:char | char isControl not]
!

beDigit

        predicate := [:char | char isNationalDigit].
        negation := [:char | char isNationalDigit not]
!

beGraphics

	self
		beControl;
		negate
!

beHexDigit
        #CUmodified. "use #isHexDigit"
        predicate := [:char | char isHexDigit ].
        negation := [:char | char isHexDigit not]

"
        | hexLetters |
        hexLetters := 'abcdefABCDEF'.
        predicate := [:char | char isDigit or: [hexLetters includes: char]].
        negation := [:char | char isDigit not and: [(hexLetters includes: char) not]]
"
!

beLowercase

        predicate := [:char | char isLowercase].
        negation := [:char | char isLowercase not]
!

beNotDigit

	self
		beDigit;
		negate
!

beNotSpace

	self
		beSpace;
		negate
!

beNotWordConstituent

	self
		beWordConstituent;
		negate
!

bePrintable

	self
		beControl;
		negate
!

bePunctuation
        #CUmodified. "use #isPunctuation instead of test against literal list"
        predicate := [:char | char isPunctuation].
        negation := [:char | char isPunctuation not]

"original:
        | punctuationChars |
        punctuationChars := #($. $, $!! $; $: $"" $' $- $( $) $`).
        predicate := [:char | punctuationChars includes: char].
        negation := [:char | (punctuationChars includes: char) not]
"
!

beSpace

        predicate := [:char | char isSeparator].
        negation := [:char | char isSeparator not]
!

beUppercase

        predicate := [:char | char isUppercase].
        negation := [:char | char isUppercase not]
!

beWordConstituent

        predicate := [:char | char isNationalAlphaNumeric].
        negation := [:char | char isNationalAlphaNumeric not]
! !

!RxsPredicate methodsFor:'private'!

negate
        | tmp |

        tmp := predicate.
        predicate := negation.
        negation := tmp.
! !

!RxsPredicate methodsFor:'testing'!

isAtomic
	"A predicate is a single character but the character is not known in advance."

	^false
!

isEnumerable

	^false
! !

!RxsPredicate class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsPredicate.st,v 1.10 2013-01-30 13:08:39 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsPredicate.st,v 1.10 2013-01-30 13:08:39 stefan Exp $'
! !


RxsPredicate initialize!
