"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#XMLCoderTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-XML'
!

!XMLCoderTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    documentation to be added.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!XMLCoderTests methodsFor:'helpers'!

encodeAndDecode:anObject
    "test, that encoding and decoding an Object results in anObject"

    |encodedString decodedObject|

    encodedString := XMLStandardCoder new encodingOf:anObject.
    decodedObject := (XMLStandardDecoder on:encodedString readStream) next.

    self should:anObject = decodedObject.

    encodedString := XMLStandardCoder new aspect:#encodeInstanceVariables; encodingOf:anObject.
    decodedObject := (XMLStandardDecoder on:encodedString readStream) useSend:true; next.

    self should:anObject = decodedObject.

    ^ decodedObject.
! !

!XMLCoderTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing"

    super setUp
!

tearDown
    "common cleanup - invoked after testing"

    super tearDown
! !

!XMLCoderTests methodsFor:'tests'!

testArray
    "test encoding an decoding of an integer"

    |arr|

    arr := Array new:10.
    arr at:1 put:true.
    arr at:2 put:'hallo'.
    arr at:3 put:#symbol.
    arr at:4 put:nil.
"/    arr at:6 put:arr.

    self encodeAndDecode:arr

    "
     self run:#testArray
    "
!

testBytes
    "test encoding an decoding of an ByteArray"

    self encodeAndDecode:#[1].
    self encodeAndDecode:#[1 2].
    self encodeAndDecode:#[1 2 3].
    self encodeAndDecode:#[1 2 3 4].
    self encodeAndDecode:#[1 2 3 4 5].
    self encodeAndDecode:#[1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 8 9 0 12 3 4 56 7 8 9 0].

    "
     self run:#testBytes
    "
!

testCharacter
    "test encoding an decoding of a Character"

    self encodeAndDecode:$a.
    self encodeAndDecode:$.

    "
     self run:#testCharacter
    "
!

testComplex
    "test encoding an decoding of an OrderedCollection"

    |coll r decodedObject|

    coll := OrderedCollection new.
    coll add:true.
    coll add:'hallo'.
    coll add:#symbol.
    coll add:(r:= #[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23]).
    coll add:#symbol.
    coll add:r.
    coll add:coll copy.

    decodedObject := self encodeAndDecode:coll.

    self should:(decodedObject at:4) == (decodedObject at:6).

    "
     self run:#testComplex
    "
!

testDictionary
    "test encoding an decoding of an integer"

    |dict|

    dict := Dictionary new.
    dict at:true put:1234.
    dict at:#murks put:'hallo'.
    dict at:5 put:#symbol.

    self encodeAndDecode:dict

    "
     self run:#testDictionary
    "
!

testEmptyCollection
    "test encoding an decoding of an OrderedCollection"

    |set|

    set := OrderedCollection new.

    self encodeAndDecode:set

    "
     self run:#testEmptyCollection
    "
!

testFloat
    "test encoding an decoding of an integer"

    -1.0 to: 1.0 by:0.5 do:[:i|
	self encodeAndDecode:i
    ].

    "
     self run:#testFloat
    "
!

testFraction
    "test encoding an decoding of an integer"

    (-3/4) to:(3/4) by:(1/4) do:[:i|
	self encodeAndDecode:i
    ].

    "
     self run:#testFraction
    "
!

testIdentityDictionary
    "test encoding an decoding of an integer"

    |dict|

    dict := IdentityDictionary new.
    dict at:true put:1234.
    dict at:#test put:'hallo'.
    dict at:5 put:#symbol.

    self encodeAndDecode:dict

    "
     self run:#testIdentityDictionary
    "
!

testInteger
    "test encoding an decoding of an integer"

    #( 0 1 10 100 1000 10000 100000 1000000 16rFFFF 16rFFFFFF) do:[:i|
	self encodeAndDecode:i.
	self encodeAndDecode:i negated.
    ].

    "
     self run:#testInteger
    "
!

testInterval
    "test encoding an decoding of a set"

    |interval|

    interval := Interval from:1 to:100.

    self encodeAndDecode:interval

    "
     self run:#testInterval
    "
!

testLargeInteger
    "test encoding an decoding of an integer"

    #(
       16r1FFFFFFF 16r20000000
       16r3FFFFFFF 16r40000000
       16r7FFFFFFF 16r80000000
       16rFFFFFFFF 16r100000000

       16r1FFFFFFFF 16r200000000
       16r3FFFFFFFF 16r400000000
       16r7FFFFFFFF 16r800000000
       16rFFFFFFFFF 16r1000000000

       16r1FFFFFFFFF 16r2000000000
       16r3FFFFFFFFF 16r4000000000
       16r7FFFFFFFFF 16r8000000000
       16rFFFFFFFFFF 16r10000000000

       16r1FFFFFFFFFF 16r20000000000
       16r3FFFFFFFFFF 16r40000000000
       16r7FFFFFFFFFF 16r80000000000
       16rFFFFFFFFFFF 16r100000000000

       16r1FFFFFFFFFFF 16r200000000000
       16r3FFFFFFFFFFF 16r400000000000
       16r7FFFFFFFFFFF 16r800000000000
       16rFFFFFFFFFFFF 16r1000000000000

       16r1FFFFFFFFFFFFFF 16r200000000000000
       16r3FFFFFFFFFFFFFF 16r400000000000000
       16r7FFFFFFFFFFFFFF 16r800000000000000
       16rFFFFFFFFFFFFFFF 16r1000000000000000

    ) do:[:i|
	self encodeAndDecode:i.
	self encodeAndDecode:i negated.
    ].

    "
     self run:#testLargeInteger
     self basicNew testLargeInteger
    "
!

testOrderedCollection
    "test encoding an decoding of an OrderedCollection"

    |set|

    set := OrderedCollection new.
    set add:true.
    set add:'hallo'.
    set add:#symbol.

    self encodeAndDecode:set

    "
     self run:#testOrderedCollection
    "
!

testPoint
    "test encoding an decoding of a point"

    -4 to:4 do:[:x |
	-4 to:4 do:[:y |
	    self encodeAndDecode:(x @ y)
	]
    ].

    "
     self run:#testPoint
    "
!

testRecursiveArray
    |arr encodedString decodedObject|

    arr := Array new:3.
    arr at:1 put:1.
    arr at:2 put:arr.
    arr at:3 put:3.

    encodedString := XMLStandardCoder new encodingOf:arr.
    decodedObject := (XMLStandardDecoder on:encodedString readStream) next.
    self assert:(decodedObject at:1) == 1.
    self assert:(decodedObject at:3) == 3.
    self assert:(decodedObject at:2) == decodedObject.
    "
     self run:#testRecursiveArray
    "

!

testSet
    "test encoding an decoding of a set"

    |set|

    set := Set new.
    set add:true.
    set add:'hallo'.
    set add:#symbol.

    self encodeAndDecode:set

    "
     self run:#testSet
    "
!

testString
    "test encoding an decoding of a String"

    self encodeAndDecode:'hello world'.
    self encodeAndDecode:'hello world #*'.
    self encodeAndDecode:Character tab asString , 'with',
			 Character tab asString, Character tab asString, 'tabs',
			 Character tab asString.
    self encodeAndDecode:Character tab asString , '& with',
			 Character tab asString, Character tab asString, 'tabs',
			 Character tab asString.

    "
     self run:#testString
    "
!

testUUID
    "test encoding an decoding of an ByteArray"

    self encodeAndDecode:UUID genUUID.

    "
     self run:#testUUID
    "

! !

!XMLCoderTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

