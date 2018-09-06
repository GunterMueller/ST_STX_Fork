"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQueryNumberFormatter subclass:#FloatFormatter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!FloatFormatter methodsFor:'number formatting'!

nonStandardCanonicalLexicalForm
    (number isNaN) ifTrue: 
    [
        ^ 'NaN'
    ].

    (number isPositiveInfinity) ifTrue:
    [
        ^ 'INF'
    ].

    (number isNegativeInfinity) ifTrue:
    [
        ^ '-INF'
    ].

    (number isNaN) ifTrue:
    [
        ^ 'NaN'
    ].

    self shouldNeverBeReached.

    "Created: / 16-11-2009 / 18:19:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

standardCanonicalLexicalForm
    | aMantissa anExponent |
    aMantissa := self mantissa.
    anExponent := self exponent.

    (anExponent > 0) ifTrue:
    [
        (anExponent >= 6) ifTrue:
        [
            ^ aMantissa printString, 'E', anExponent printString.
        ] 
        ifFalse:
        [
            | fractionDigits |
            fractionDigits := self fractionDigits.
            ^ self number printStringFormat: '%.', fractionDigits storeString, 'f'
        ].
    ]
    ifFalse:
    [
        (anExponent < -6) ifTrue:
        [
            ^ aMantissa printString, 'E', anExponent printString.
        ]
        ifFalse:
        [
            | format |
            format := '%.', self fractionDigits asString, 'f'.
            ^ number printStringFormat: format.
        ].
    ]

    "Created: / 16-11-2009 / 18:19:11 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 17:25:58 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!FloatFormatter class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
