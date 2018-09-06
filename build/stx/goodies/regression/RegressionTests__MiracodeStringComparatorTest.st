"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#MiracodeStringComparatorTest
	instanceVariableNames:'sc mc'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections-Utilities'
!


!MiracodeStringComparatorTest methodsFor:'running'!

setUp
    sc := PhoneticStringUtilities::SoundexStringComparator new.
    mc := PhoneticStringUtilities::MiracodeStringComparator new.
! !

!MiracodeStringComparatorTest methodsFor:'tests'!

testWellKnownResults
    |code mcode soundex miracode|

    soundex := [:w | (sc phoneticStringsFor:w) first].
    miracode := [:w | (mc phoneticStringsFor:w) first].

    self assert: ( miracode value:( 'Swhgler' )) = 'S460' .  "/ DIFFERENT from simple soundex

    code := soundex value:('Miller').
    mcode := miracode value:('Miller').
    self assert:( code = mcode).
    self assert:( code = 'Miller' asSoundexCode).

    #( 'Acton' 'Ashdown' 'Ashton' 'Astin' 'Aston' 'Austen' 'Austin' 'Austine' 'Axten')
    do:[:w |
	code := soundex value:(w).
	self assert:( code = 'A235').
	mcode := miracode value:(w).
	self assert:( mcode = 'A235').
    ].

    #( 'Reader' 'Reeder' 'Rider' 'Ritter' 'Rothera' 'Rothra' 'Ruder' 'Rutter' 'Ryder')
    do:[:w |
	code := soundex value:(w).
	self assert:( code = 'R360').
	mcode := miracode value:(w).
	self assert:( mcode = 'R360').
    ].

    #( 'Wace' 'Waugh' 'Wookey')
    do:[:w |
	code := soundex value:(w).
	self assert:( code = 'W200').
	mcode := miracode value:(w).
	self assert:( mcode = 'W200').
    ].

    code := soundex value:('Abbot').
    mcode := miracode value:('Abbot').
    self assert:( code = 'Abbot' asSoundexCode).
    self assert:( code = 'A130' ).
    self assert:( mcode = 'A130' ).

    code := soundex value:('Abbots').
    mcode := miracode value:('Abbots').
    self assert:( code = 'Abbots' asSoundexCode).
    self assert:( code = 'A132' ).
    self assert:( mcode = 'A132' ).

    "/ DIFFERENT from soundex !!
    code := soundex value:('Ashcroft').
    mcode := miracode value:('Ashcroft').
    self assert:( code = 'Ashcroft' asSoundexCode).
    self assert:( code = 'A226' ).
    self assert:( mcode = 'A261' ).

    code := soundex value:('Lloyd').
    mcode := miracode value:('Lloyd').
    self assert:( code = 'Lloyd' asSoundexCode).
    self assert:( code = 'L300' ).
    self assert:( mcode = 'L300' ).

    code := soundex value:('Pfister').
    mcode := miracode value:('Pfister').
    self assert:( code = 'Pfister' asSoundexCode).
    self assert:( code = 'P236' ).
    self assert:( mcode = 'P236' ).

    self assert: ( miracode value:( 'A' )) = 'A000' .
    self assert: ( miracode value:( 'B' )) = 'B000' .
    self assert: ( miracode value:( 'C' )) = 'C000' .
    self assert: ( miracode value:( 'D' )) = 'D000' .
    self assert: ( miracode value:( 'E' )) = 'E000' .
    self assert: ( miracode value:( 'F' )) = 'F000' .
    self assert: ( miracode value:( 'G' )) = 'G000' .
    self assert: ( miracode value:( 'H' )) = 'H000' .
    self assert: ( miracode value:( 'I' )) = 'I000' .
    self assert: ( miracode value:( 'J' )) = 'J000' .
    self assert: ( miracode value:( 'K' )) = 'K000' .
    self assert: ( miracode value:( 'L' )) = 'L000' .
    self assert: ( miracode value:( 'M' )) = 'M000' .
    self assert: ( miracode value:( 'N' )) = 'N000' .
    self assert: ( miracode value:( 'O' )) = 'O000' .
    self assert: ( miracode value:( 'P' )) = 'P000' .
    self assert: ( miracode value:( 'Q' )) = 'Q000' .
    self assert: ( miracode value:( 'R' )) = 'R000' .
    self assert: ( miracode value:( 'S' )) = 'S000' .
    self assert: ( miracode value:( 'T' )) = 'T000' .
    self assert: ( miracode value:( 'U' )) = 'U000' .
    self assert: ( miracode value:( 'V' )) = 'V000' .
    self assert: ( miracode value:( 'W' )) = 'W000' .
    self assert: ( miracode value:( 'X' )) = 'X000' .
    self assert: ( miracode value:( 'Y' )) = 'Y000' .
    self assert: ( miracode value:( 'Z' )) = 'Z000' .

    self assert: ( miracode value:( 'AEHIOW' )) = 'A000' .
    self assert: ( miracode value:( 'BPFV' )) = 'B000' .
    self assert: ( miracode value:( 'CGJKQSXZ' )) = 'C000' .
    self assert: ( miracode value:( 'DT' )) = 'D000' .
    self assert: ( miracode value:( 'L' )) = 'L000' .
    self assert: ( miracode value:( 'MN' )) = 'M000' .
    self assert: ( miracode value:( 'R' )) = 'R000' .

    self assert: ( miracode value:( 'ADAD' )) = 'A330' .
    self assert: ( miracode value:( 'ADAD' )) = 'A330' .
    self assert: ( miracode value:( 'ADHD' )) = 'A300' .   "/ DIFFERENT from simple soundex
    self assert: ( miracode value:( 'ADWD' )) = 'A300' .   "/ DIFFERENT from simple soundex

    "/ self assert: ( miracode value:( 'Ashcroft' )) = 'A22613' .
    self assert: ( miracode value:( 'Ashcroft' )) = 'A261' .
    self assert: ( miracode value:( 'Tymczak' )) = 'T522' .
    self assert: ( miracode value:( 'Jackson' )) = 'J250' .
    self assert: ( miracode value:( 'Pfister' )) = 'P236' .
    self assert: ( miracode value:( 'Gutierrez' )) = 'G362' .
    self assert: ( miracode value:( 'Lee' )) = 'L000' .
    "/ self assert: ( miracode value:( 'Washington' )) = 'W25235' .
    self assert: ( miracode value:( 'Washington' )) = 'W252' .

    self assert: ( miracode value:( 'Williams' )) = 'W452' .
    "/ self assert: ( miracode value:( 'Baragwanath' )) = 'B6253' .
    self assert: ( miracode value:( 'Baragwanath' )) = 'B625' .
    self assert: ( miracode value:( 'Donnell' )) = 'D540' .
    self assert: ( miracode value:( 'Lloyd' )) = 'L300' .
    self assert: ( miracode value:( 'Woolcock' )) = 'W422' .
! !

!MiracodeStringComparatorTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

