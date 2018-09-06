"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQueryNumberFormatter subclass:#IntegerFormatter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!IntegerFormatter methodsFor:'number formatting'!

nonStandardCanonicalLexicalForm
    TypeError raiseErrorString: 'Non standart numbers (INF, NaN) not allowed for integer'.

    "Created: / 16-11-2009 / 18:19:20 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:19:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

standardCanonicalLexicalForm
    | format |

    self assert: (self fractionDigits = 0) message: 'fraction part not allowed for xs:integer'.
    format := '%d'.
    ^ number printStringFormat: format.

"/    | aMantissa anExponent |
"/    aMantissa := self mantissa.
"/    anExponent := self exponent.
"/
"/    (anExponent > 0) ifTrue:
"/    [
"/        (anExponent >= 6) ifTrue:
"/        [
"/            ^ aMantissa printString, 'E', anExponent printString.
"/        ] 
"/        ifFalse:
"/        [
"/            | fractionDigits |
"/            fractionDigits := self fractionDigits.
"/            ^ self number printStringFormat: '%.', fractionDigits storeString, 'f'
"/        ].
"/    ]
"/    ifFalse:
"/    [
"/        (anExponent < -6) ifTrue:
"/        [
"/            ^ aMantissa printString, 'E', anExponent printString.
"/        ]
"/        ifFalse:
"/        [
"/            | format |
"/            format := '%.', self fractionDigits asString, 'f'.
"/            ^ number printStringFormat: format.
"/        ].
"/    ]

    "Created: / 16-11-2009 / 18:19:11 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 18:26:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!IntegerFormatter class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
