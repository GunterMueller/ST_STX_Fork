"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XQueryNumberFormatter
	instanceVariableNames:'number exponent mantissa fractionDigits'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!XQueryNumberFormatter class methodsFor:'instance creation'!

withValue: value
    ^ (self new)
        number: value;
        yourself.

    "Created: / 10-11-2009 / 17:12:17 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryNumberFormatter class methodsFor:'number formatting'!

toCanonicalLexicalForm: value
    ^ (self withValue: value) toCanonicalLexicalForm.

    "Created: / 17-11-2009 / 18:25:50 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryNumberFormatter methodsFor:'accessing'!

exponent
    exponent ifNil:
    [
        self setExponentAndMantissa.
    ].

    ^ exponent.

    "Created: / 10-11-2009 / 17:02:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

fractionDigits
    | num digits |

    num := number abs.
    digits := 0.

    [ (num fractionPart < 0.000001)] whileFalse:
    [
        digits := digits + 1.
        num := number abs * (10 raisedTo: digits).
    ].

    ^ digits.

    "Created: / 10-11-2009 / 17:06:23 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 19:08:10 / Jan Kurs <kursj1@fel.cvut.cz>"
!

mantissa
    mantissa ifNil:
    [
        self setExponentAndMantissa.
"/        | scientificNotation expPosition |
"/        "TODO: this is ugly and dirty solution - should be rewritten"
"/        scientificNotation := number printStringFormat: '%E'.
"/        expPosition := scientificNotation findFirst: [:char | char = $E ].
"/
"/        ^ (scientificNotation copyFrom: 1 to: (expPosition - 1)) asNumber.
    ].

    ^ mantissa.

    "Created: / 10-11-2009 / 17:03:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

number
    ^ number
!

number:something
    number := something.
! !

!XQueryNumberFormatter methodsFor:'accessing - private'!

setExponentAndMantissa
    | exp inc num |
    num := number.
    exp := 0.

    (number abs < 1) ifTrue: [
        inc := -1.
    ] ifFalse: [
        inc := 1.
    ].

    (number = 0.0) ifFalse:
    [
        [num abs >= 1 and: [num abs < 10]] whileFalse:
        [
            num := num * (10 raisedTo: (0 - inc)).
            exp := exp + inc.
        ].
    ].

    mantissa := num.
    exponent := exp.

    "Created: / 10-11-2009 / 17:18:28 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:54:51 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryNumberFormatter methodsFor:'number formatting'!

isStandardNumber
    ^ ((number isNil) or: [number isNaN] or: [number isInfinite]) not.

    "Created: / 16-11-2009 / 18:18:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

nonStandardCanonicalLexicalForm
    self subclassResponsibility.

    "Created: / 16-11-2009 / 18:19:20 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 17:36:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

standardCanonicalLexicalForm
    self subclassResponsibility.

    "Created: / 16-11-2009 / 18:19:11 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 17:36:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

toCanonicalLexicalForm
    self isStandardNumber ifTrue:
    [
        ^ self standardCanonicalLexicalForm.
    ]
    ifFalse:
    [
        ^ self nonStandardCanonicalLexicalForm.
    ]

    "Created: / 17-11-2009 / 18:18:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryNumberFormatter class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
