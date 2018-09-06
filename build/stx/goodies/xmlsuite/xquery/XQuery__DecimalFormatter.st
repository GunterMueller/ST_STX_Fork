"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQueryNumberFormatter subclass:#DecimalFormatter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Types'
!


!DecimalFormatter methodsFor:'number formatting'!

nonStandardCanonicalLexicalForm
    TypeError raiseErrorString: 'Non standart numbers (INF, NaN) not allowed for decimal'.

    "Created: / 16-11-2009 / 18:19:20 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 17-11-2009 / 17:39:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

standardCanonicalLexicalForm
      | format |

      (number = 0) ifTrue:
      [
        ^ '0'.
      ].

      format := '%.', self fractionDigits asString, 'f'.
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
    "Modified: / 17-11-2009 / 17:45:52 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DecimalFormatter class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
