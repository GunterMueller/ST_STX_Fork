"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#StreamUpToTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Streams'
!

!StreamUpToTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	ca

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!StreamUpToTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!StreamUpToTests methodsFor:'tests'!

test1_Array

    self assert:( #( ) readStream upTo:$c  ) = #().
    self assert:( #( ) readStream upTo:$c; position  ) = 0          .

    self assert:( #( $a $b ) readStream next; next; upTo:$c  ) = #().
    self assert:( #( $a $b ) readStream next; next; upTo:$c; position  ) = 2          .

    self assert:( #( $a $b $c $d ) readStream upTo:$c  ) = #($a "16r61" $b "16r62").
    self assert:( #( $a $b $c $d ) readStream upTo:$c; position  ) = 3          .
    self assert:( #( $a $b $c $d ) readStream upTo:$1  ) = #($a "16r61" $b "16r62" $c "16r63" $d "16r64")    .
    self assert:( #( $a $b $c $d ) readStream upTo:$1; position  ) = 4          .

    self assert:( #( $a $b $c $d ) readStream upTo:$a  ) = #().
    self assert:( #( $a $b $c $d ) readStream upTo:$a; position  ) = 1.

    self assert:( #( $a $b $c $d ) readStream next; upTo:$c  ) = #($b "16r62")  .
    self assert:( #( $a $b $c $d ) readStream next; upTo:$c; position  ) = 3    .
    self assert:( #( $a $b $c $d ) readStream next; upTo:$1  ) = #($b "16r62" $c "16r63" $d "16r64") .
    self assert:( #( $a $b $c $d ) readStream next; upTo:$1; position  ) = 4    .

    self assert:( #( $a $b $c $d $a $b $c $d ) readStream next:3; upTo:$c  ) = #( $d $a $b)  .
    self assert:( #( $a $b $c $d $a $b $c $d ) readStream next:3; upTo:$c; position  ) = 7.

    self assert:( #( $a $b $c $d $e $f) readStream readLimit:5; upTo:$c  ) = #($a "16r61" $b "16r62") .
    self assert:( #( $a $b $c $d $e $f) readStream readLimit:5; upTo:$c; position  ) = 3             .
    self assert:( #( $a $b $c $d $e $f) readStream readLimit:5; upTo:$1  ) = #($a "16r61" $b "16r62" $c  "16r63" $d "16r64" $e "16r65").
    self assert:( #( $a $b $c $d $e $f) readStream readLimit:5; upTo:$1; position  ) = 5   .
!

test1_String

    self assert:( 'ab' readStream next; next; upTo:$c  ) = ''.
    self assert:( 'ab' readStream next; next; upTo:$c; position  ) = 2          .

    self assert:( 'abcd' readStream upTo:$c  ) = 'ab'.
    self assert:( 'abcd' readStream upTo:$c; position  ) = 3.
    self assert:( 'abcd' readStream upTo:$1  ) = 'abcd'.
    self assert:( 'abcd' readStream upTo:$1; position  ) = 4.

    self assert:( 'abcd' readStream upTo:$a  ) = ''.
    self assert:( 'abcd' readStream upTo:$a; position  ) = 1.


    self assert:( 'abcd' readStream next; upTo:$c  ) = 'b'  .
    self assert:( 'abcd' readStream next; upTo:$c; position  ) = 3.
    self assert:( 'abcd' readStream next; upTo:$1  ) = 'bcd' .
    self assert:( 'abcd' readStream next; upTo:$1; position  ) = 4.

    self assert:( 'abcdabcd' readStream next:3; upTo:$c  ) = 'dab'  .
    self assert:( 'abcdabcd' readStream next:3; upTo:$c; position  ) = 7.

    self assert:( 'abcdef' readStream readLimit:5; upTo:$c  ) = 'ab' .
    self assert:( 'abcdef' readStream readLimit:5; upTo:$c; position  ) = 3.
    self assert:( 'abcdef' readStream readLimit:5; upTo:$1  ) = 'abcde'.
    self assert:( 'abcdef' readStream readLimit:5; upTo:$1; position  ) = 5.
! !

!StreamUpToTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

