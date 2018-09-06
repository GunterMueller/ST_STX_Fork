"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#MySQLSoundexStringComparatorTest
	instanceVariableNames:'mc'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections-Utilities'
!


!MySQLSoundexStringComparatorTest methodsFor:'running'!

setUp
    mc := PhoneticStringUtilities::MySQLSoundexStringComparator new.
! !

!MySQLSoundexStringComparatorTest methodsFor:'tests'!

testWellKnownResults
    |code msoundex|

    msoundex := [:w | (mc phoneticStringsFor:w) first].

    self assert: ( msoundex value:( 'Swhgler' )) = 'S460' .  "/ DIFFERENT from simple soundex

    code := msoundex value:('Miller').
    self assert:( code = 'M460').

    #( 'Acton' 'Ashdown' 'Ashton' 'Astin' 'Aston' 'Austen' 'Austin' 'Austine' 'Axten')
    do:[:w |
	code := msoundex value:(w).
	self assert:( code = 'A235').
    ].

    #( 'Reader' 'Reeder' 'Rider' 'Ritter' 'Rothera' 'Rothra' 'Ruder' 'Rutter' 'Ryder')
    do:[:w |
	code := msoundex value:(w).
	self assert:( code = 'R360').
    ].

    #( 'Wace' 'Waugh' 'Wookey')
    do:[:w |
	code := msoundex value:(w).
	self assert:( code = 'W200').
    ].

    code := msoundex value:('Abbot').
    self assert:( code = 'A130' ).

    code := msoundex value:('Abbots').
    self assert:( code = 'A132' ).

    "/ DIFFERENT from soundex !!
    code := msoundex value:('Ashcroft').
    self assert:( code = 'A2613' ).

    code := msoundex value:('Lloyd').
    self assert:( code = 'L300' ).

    code := msoundex value:('Pfister').
    self assert:( code = 'P236' ).

    self assert: ( msoundex value:( 'A' )) = 'A000' .
    self assert: ( msoundex value:( 'B' )) = 'B000' .
    self assert: ( msoundex value:( 'C' )) = 'C000' .
    self assert: ( msoundex value:( 'D' )) = 'D000' .
    self assert: ( msoundex value:( 'E' )) = 'E000' .
    self assert: ( msoundex value:( 'F' )) = 'F000' .
    self assert: ( msoundex value:( 'G' )) = 'G000' .
    self assert: ( msoundex value:( 'H' )) = 'H000' .
    self assert: ( msoundex value:( 'I' )) = 'I000' .
    self assert: ( msoundex value:( 'J' )) = 'J000' .
    self assert: ( msoundex value:( 'K' )) = 'K000' .
    self assert: ( msoundex value:( 'L' )) = 'L000' .
    self assert: ( msoundex value:( 'M' )) = 'M000' .
    self assert: ( msoundex value:( 'N' )) = 'N000' .
    self assert: ( msoundex value:( 'O' )) = 'O000' .
    self assert: ( msoundex value:( 'P' )) = 'P000' .
    self assert: ( msoundex value:( 'Q' )) = 'Q000' .
    self assert: ( msoundex value:( 'R' )) = 'R000' .
    self assert: ( msoundex value:( 'S' )) = 'S000' .
    self assert: ( msoundex value:( 'T' )) = 'T000' .
    self assert: ( msoundex value:( 'U' )) = 'U000' .
    self assert: ( msoundex value:( 'V' )) = 'V000' .
    self assert: ( msoundex value:( 'W' )) = 'W000' .
    self assert: ( msoundex value:( 'X' )) = 'X000' .
    self assert: ( msoundex value:( 'Y' )) = 'Y000' .
    self assert: ( msoundex value:( 'Z' )) = 'Z000' .

    self assert: ( msoundex value:( 'AEHIOW' )) = 'A000' .
    self assert: ( msoundex value:( 'BPFV' )) = 'B000' .
    self assert: ( msoundex value:( 'CGJKQSXZ' )) = 'C000' .
    self assert: ( msoundex value:( 'DT' )) = 'D000' .
    self assert: ( msoundex value:( 'L' )) = 'L000' .
    self assert: ( msoundex value:( 'MN' )) = 'M000' .
    self assert: ( msoundex value:( 'R' )) = 'R000' .

    self assert: ( msoundex value:( 'ADAD' )) = 'A300' .   "/ DIFFERENT from simple soundex and american soundex
    self assert: ( msoundex value:( 'ADHD' )) = 'A300' .   "/ DIFFERENT from simple soundex
    self assert: ( msoundex value:( 'ADWD' )) = 'A300' .   "/ DIFFERENT from simple soundex

    self assert: ( msoundex value:( 'Ashcroft' )) = 'A2613' .
    self assert: ( msoundex value:( 'Tymczak' )) = 'T520' .
    self assert: ( msoundex value:( 'Jackson' )) = 'J500' .
    self assert: ( msoundex value:( 'Pfister' )) = 'P236' .
    self assert: ( msoundex value:( 'Gutierrez' )) = 'G362' .
    self assert: ( msoundex value:( 'Lee' )) = 'L000' .
    self assert: ( msoundex value:( 'Washington' )) = 'W25235' .

    self assert: ( msoundex value:( 'Williams' )) = 'W452' .
    self assert: ( msoundex value:( 'Baragwanath' )) = 'B6253' .
    self assert: ( msoundex value:( 'Donnell' )) = 'D540' .
    self assert: ( msoundex value:( 'Lloyd' )) = 'L300' .
    self assert: ( msoundex value:( 'Woolcock' )) = 'W420' .
! !

!MySQLSoundexStringComparatorTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

