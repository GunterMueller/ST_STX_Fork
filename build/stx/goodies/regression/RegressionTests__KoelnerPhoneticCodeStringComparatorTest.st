"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#KoelnerPhoneticCodeStringComparatorTest
	instanceVariableNames:'sc'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Collections-Utilities'
!


!KoelnerPhoneticCodeStringComparatorTest methodsFor:'running'!

setUp
    sc := PhoneticStringUtilities::KoelnerPhoneticCodeStringComparator new
! !

!KoelnerPhoneticCodeStringComparatorTest methodsFor:'tests'!

testSomeCombinations
    |code s|

    "/ compares all 4-char combinations against
    $A to:$Z do:[:c1 |
	$A to:$Z do:[:c2 |
	    $A to:$Z do:[:c3 |
		$A to:$Z do:[:c4 |
		    s := String with:c1 with:c2 with:c3 with:c4.
		    code := (sc phoneticStringsFor:s) first.
		    self assert:( code = s asKoelnerPhoneticCode).
		].
	    ].
	].
    ].
!

testWellKnownResults
    |code koeln|

    koeln := [:w | (sc phoneticStringsFor:w) first].

    code := (sc phoneticStringsFor:'Miller') first.
    self assert:( code = 'Miller' asKoelnerPhoneticCode).

    #( 'Acton' 'Ashdown' 'Ashton' 'Astin' 'Aston' 'Austen' 'Austin' 'Austine' 'Axten')
    do:[:w |
	code := koeln value:(w).
	self assert:( code = (w asKoelnerPhoneticCode)).
    ].

    #( 'Reader' 'Reeder' 'Rider' 'Ritter' 'Rothera' 'Rothra' 'Ruder' 'Rutter' 'Ryder')
    do:[:w |
	code := koeln value:(w).
	self assert:( code = (w asKoelnerPhoneticCode)).
    ].

    #( 'Wace' 'Waugh' 'Wookey')
    do:[:w |
	code := koeln value:(w).
	self assert:( code = (w asKoelnerPhoneticCode)).
    ].

    code := koeln value:('Abbot').
    self assert:( code = 'Abbot' asKoelnerPhoneticCode).

    code := koeln value:('Abbots').
    self assert:( code = 'Abbots' asKoelnerPhoneticCode).

    code := koeln value:('Ashcroft').
    self assert:( code = 'Ashcroft' asKoelnerPhoneticCode).

    code := koeln value:('Lloyd').
    self assert:( code = 'Lloyd' asKoelnerPhoneticCode).

    code := koeln value:('Pfister').
    self assert:( code = 'Pfister' asKoelnerPhoneticCode).

    self assert: ( koeln value:( 'A' )) = ('A' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'B' )) = ('B' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'C' )) = ('C' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'D' )) = ('D' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'E' )) = ('E' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'F' )) = ('F' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'G' )) = ('G' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'H' )) = ('H' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'I' )) = ('I' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'J' )) = ('J' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'K' )) = ('K' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'L' )) = ('L' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'M' )) = ('M' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'N' )) = ('N' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'O' )) = ('O' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'P' )) = ('P' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'Q' )) = ('Q' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'R' )) = ('R' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'S' )) = ('S' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'T' )) = ('T' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'U' )) = ('U' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'V' )) = ('V' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'W' )) = ('W' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'X' )) = ('X' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'Y' )) = ('Y' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'Z' )) = ('Z' asKoelnerPhoneticCode) .

    self assert: ( koeln value:( 'AEHIOW' )) = ('AEHIOW' asKoelnerPhoneticCode) .
    self assert: ( koeln value:( 'BPFV' )) = ('BPFV' asKoelnerPhoneticCode).
    self assert: ( koeln value:( 'CGJKQSXZ' )) = ('CGJKQSXZ'  asKoelnerPhoneticCode).
    self assert: ( koeln value:( 'DT' )) = ('DT'  asKoelnerPhoneticCode).
    self assert: ( koeln value:( 'L' )) = ('L'  asKoelnerPhoneticCode).
    self assert: ( koeln value:( 'MN' )) = ('MN'  asKoelnerPhoneticCode).
    self assert: ( koeln value:( 'R' )) = ('R'  asKoelnerPhoneticCode).
! !

!KoelnerPhoneticCodeStringComparatorTest class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

