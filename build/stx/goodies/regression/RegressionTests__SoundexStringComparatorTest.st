"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#SoundexStringComparatorTest
	instanceVariableNames:'sc'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections-Utilities'
!


!SoundexStringComparatorTest methodsFor:'running'!

setUp
    sc := PhoneticStringUtilities::SoundexStringComparator new
! !

!SoundexStringComparatorTest methodsFor:'tests'!

testSomeCombinations
    |code s|

    "/ compares all 4-char combinations against
    $A to:$Z do:[:c1 |
	$A to:$Z do:[:c2 |
	    $A to:$Z do:[:c3 |
		$A to:$Z do:[:c4 |
		    s := String with:c1 with:c2 with:c3 with:c4.
		    code := (sc phoneticStringsFor:s) first.
		    self assert:( code = s asSoundexCode).
		].
	    ].
	].
    ].
!

testWellKnownResults
    |code soundex|

    soundex := [:w | (sc phoneticStringsFor:w) first].

    self assert: ( soundex value:( 'Swhgler' )) = 'S246' .  "/ DIFFERENT from miracode (american) soundex

    code := (sc phoneticStringsFor:'Miller') first.
    self assert:( code = 'Miller' asSoundexCode).

    #( 'Acton' 'Ashdown' 'Ashton' 'Astin' 'Aston' 'Austen' 'Austin' 'Austine' 'Axten')
    do:[:w |
	code := soundex value:(w).
	self assert:( code = 'A235').
    ].

    #( 'Reader' 'Reeder' 'Rider' 'Ritter' 'Rothera' 'Rothra' 'Ruder' 'Rutter' 'Ryder')
    do:[:w |
	code := soundex value:(w).
	self assert:( code = 'R360').
    ].

    #( 'Wace' 'Waugh' 'Wookey')
    do:[:w |
	code := soundex value:(w).
	self assert:( code = 'W200').
    ].

    code := soundex value:('Abbot').
    self assert:( code = 'Abbot' asSoundexCode).
    self assert:( code = 'A130' ).

    code := soundex value:('Abbots').
    self assert:( code = 'Abbots' asSoundexCode).
    self assert:( code = 'A132' ).

    code := soundex value:('Ashcroft').
    self assert:( code = 'Ashcroft' asSoundexCode).
    self assert:( code = 'A226' ).

    code := soundex value:('Lloyd').
    self assert:( code = 'Lloyd' asSoundexCode).
    self assert:( code = 'L300' ).

    code := soundex value:('Pfister').
    self assert:( code = 'Pfister' asSoundexCode).
    self assert:( code = 'P236' ).

    self assert: ( soundex value:( 'A' )) = 'A000' .
    self assert: ( soundex value:( 'B' )) = 'B000' .
    self assert: ( soundex value:( 'C' )) = 'C000' .
    self assert: ( soundex value:( 'D' )) = 'D000' .
    self assert: ( soundex value:( 'E' )) = 'E000' .
    self assert: ( soundex value:( 'F' )) = 'F000' .
    self assert: ( soundex value:( 'G' )) = 'G000' .
    self assert: ( soundex value:( 'H' )) = 'H000' .
    self assert: ( soundex value:( 'I' )) = 'I000' .
    self assert: ( soundex value:( 'J' )) = 'J000' .
    self assert: ( soundex value:( 'K' )) = 'K000' .
    self assert: ( soundex value:( 'L' )) = 'L000' .
    self assert: ( soundex value:( 'M' )) = 'M000' .
    self assert: ( soundex value:( 'N' )) = 'N000' .
    self assert: ( soundex value:( 'O' )) = 'O000' .
    self assert: ( soundex value:( 'P' )) = 'P000' .
    self assert: ( soundex value:( 'Q' )) = 'Q000' .
    self assert: ( soundex value:( 'R' )) = 'R000' .
    self assert: ( soundex value:( 'S' )) = 'S000' .
    self assert: ( soundex value:( 'T' )) = 'T000' .
    self assert: ( soundex value:( 'U' )) = 'U000' .
    self assert: ( soundex value:( 'V' )) = 'V000' .
    self assert: ( soundex value:( 'W' )) = 'W000' .
    self assert: ( soundex value:( 'X' )) = 'X000' .
    self assert: ( soundex value:( 'Y' )) = 'Y000' .
    self assert: ( soundex value:( 'Z' )) = 'Z000' .

    self assert: ( soundex value:( 'AEHIOW' )) = 'A000' .
    self assert: ( soundex value:( 'BPFV' )) = 'B000' .
    self assert: ( soundex value:( 'CGJKQSXZ' )) = 'C000' .
    self assert: ( soundex value:( 'DT' )) = 'D000' .
    self assert: ( soundex value:( 'L' )) = 'L000' .
    self assert: ( soundex value:( 'MN' )) = 'M000' .
    self assert: ( soundex value:( 'R' )) = 'R000' .

    self assert: ( soundex value:( 'ADAD' )) = 'A330' .
    self assert: ( soundex value:( 'ADHD' )) = 'A330' .  "/ DIFFERENT from miracode (american) soundex
    self assert: ( soundex value:( 'ADWD' )) = 'A330' .  "/ DIFFERENT from miracode (american) soundex

    "/ self assert: ( soundex value:( 'Ashcroft' )) = 'A22613' .
    self assert: ( soundex value:( 'Ashcroft' )) = 'A226' .
    self assert: ( soundex value:( 'Tymczak' )) = 'T522' .
    self assert: ( soundex value:( 'Jackson' )) = 'J250' .
    self assert: ( soundex value:( 'Pfister' )) = 'P236' .
    self assert: ( soundex value:( 'Gutierrez' )) = 'G362' .
    self assert: ( soundex value:( 'Lee' )) = 'L000' .
    "/ self assert: ( soundex value:( 'Washington' )) = 'W25235' .
    self assert: ( soundex value:( 'Washington' )) = 'W252' .

    self assert: ( soundex value:( 'Williams' )) = 'W452' .
    "/ self assert: ( soundex value:( 'Baragwanath' )) = 'B6253' .
    self assert: ( soundex value:( 'Baragwanath' )) = 'B625' .
    self assert: ( soundex value:( 'Donnell' )) = 'D540' .
    self assert: ( soundex value:( 'Lloyd' )) = 'L300' .
    self assert: ( soundex value:( 'Woolcock' )) = 'W422' .

    self assert: ( soundex value:( 'Cook' )) = 'C200' .

    self assert: ( soundex value:( 'Allricht' )) = 'A462' .
    self assert: ( soundex value:( 'Eberhard' )) = 'E166' .
    self assert: ( soundex value:( 'Engebrethson' )) = 'E521' .
    self assert: ( soundex value:( 'Heimbach' )) = 'H512' .
    self assert: ( soundex value:( 'Hanselmann' )) = 'H524' .
    self assert: ( soundex value:( 'Henzelmann' )) = 'H524' .
    self assert: ( soundex value:( 'Hildebrand' )) = 'H431' .
    self assert: ( soundex value:( 'Kavanagh' )) = 'K152' .
    "/ self assert: ( soundex value:( 'Lind, Van' )) = 'L530' .
    self assert: ( soundex value:( 'Lind' )) = 'L530' .
    self assert: ( soundex value:( 'Lukaschowsky' )) = 'L222' .
    self assert: ( soundex value:( 'McDonnell' )) = 'M235' .
    self assert: ( soundex value:( 'McGee' )) = 'M200' .
    self assert: ( soundex value:( 'O''Brien' )) = 'O165' .
    self assert: ( soundex value:( 'Opnian' )) = 'O155' .
    self assert: ( soundex value:( 'Oppenheimer' )) = 'O155' .
    self assert: ( soundex value:( 'Swhgler' )) = 'S246' .    "/ DIFFERENT from miracode (american) soundex
    self assert: ( soundex value:( 'Riedemanas' )) = 'R355' .
    self assert: ( soundex value:( 'Zita' )) = 'Z300' .
    self assert: ( soundex value:( 'Zitzmeinn' )) = 'Z325' .
! !

!SoundexStringComparatorTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

