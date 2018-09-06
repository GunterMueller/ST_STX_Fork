"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIBuffer subclass:#OCINumberBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Buffers'
!


!OCINumberBuffer class methodsFor:'constants'!

elementSize
    "the internal representation of number values is 21 bytes"

    ^ 21
! !

!OCINumberBuffer class methodsFor:'conversion'!

numberFromOciBytes:bytes
    "get a number from the internal oracle 8 number format.
     The length of the byte array bytes must be 1 to 21 bytes.

     Oracle uses a special format to make the bytes representation sortable
     and to avoid 0 - bytes (this is for historical reasons).

    <return: Number>"

    |exponent mantissa offset b|

    "second byte is exponent byte"
    exponent := bytes byteAt:1.
    exponent > 127 ifTrue:[
	"a positive number"
	offset := 1.
	exponent := exponent - 193.      "exponent - 128 - 65"
    ] ifFalse:[
	"a negative number"
	offset := 101.
	exponent := 62 - exponent.
    ].
    mantissa := 0.
    2 to:bytes size do:[:i|
	b := bytes at:i.
	(b == 0 or:[b > 101]) ifTrue:[
	    (b == 102 and:[offset == 101]) ifTrue:[
		"102 is end of negative number indicator and ignored here"
	    ] ifFalse:[
		OCIError raiseErrorString:' - bad conversion'.
	    ]
	] ifFalse:[
	    mantissa := mantissa * 100 + (b - offset).
	    exponent := exponent - 1.
	].
    ].
    ^ mantissa * (100 raisedToInteger:exponent+1)                   

    "
      (self numberFromOciBytes:#[128]) = 0
      (self numberFromOciBytes:#[193 6]) = 5
      (self numberFromOciBytes:#[62 96 102]) = -5
      (self numberFromOciBytes:#[194 28 68]) = 2767
      (self numberFromOciBytes:#[61 74 34 102]) = -2767
      (self numberFromOciBytes:#[195 11]) = 100000
      (self numberFromOciBytes:#[196 2 24 46 68]) = 1234567
      (self numberFromOciBytes:#[192 11]) = 0.1
    "
!

ociNumber:aNumber
    "convert aNumber to the internal oracle 8 number format.

     Oracle uses a special format to make the bytes representation sortable
     and to avoid 0 - bytes (this is for historical reasons).
     A ByteArray with length 1..21 is returned, the first byte containing the exponent
     and sign, and the rest containing the mantissa (38 valid decimal digits)

     <return: ByteArray>"

    |negative exponent mantissaBytes bytes byte offset num index end|

    aNumber == 0 ifTrue:[
	"value 0"
	^ #[128]
    ].

    aNumber isInteger ifTrue:[
	num := aNumber.
	exponent := 192.   "128 + 64"
    ] ifFalse:[
	"convert aNumber to integer an adjust the exponent accordingly.
	 Should compute the number of relevant digits to avoid LargeInteger
	 computations"

	|twoDigits|
	"can represent max 38 digits in 19 bytes"
	aNumber isLimitedPrecisionReal ifTrue:[
	    "precision of Float is usually less then 38"
	    twoDigits := ((aNumber class decimalPrecision) // 2) min:19.
	] ifFalse:[
	    "fractions have a virtually unlimited precision"
	    twoDigits := 19.
	].
	exponent := (aNumber abs floorLog:100)-twoDigits.
	num := (aNumber * (100 raisedToInteger:exponent negated)) truncated.
	exponent := 192 + exponent.
    ].

    (negative := aNumber negative) ifTrue:[
	"number is negative"
	offset := 101.                                               
    ] ifFalse:[
	"number is positive"
	offset := 1.
    ].

    "fill manissaBytes from the end"
    mantissaBytes := ByteArray new:21.
    index := 21.
    [
	exponent := exponent + 1.
	byte := num rem:100.
	num := num quo:100.
	"skip trailing 0-bytes"
	(index ~~ 21 or:[byte ~~ 0]) ifTrue:[
	    index := index - 1.
	    mantissaBytes at:index put:byte+offset.
	].
    ] doWhile:[num ~~ 0].

    (exponent > 255 or:[exponent < 129]) ifTrue:[
	OCIError raiseErrorString:' - number out of range'.
    ].

    end := 22 - index.
    negative ifTrue:[
	"invert exponent"
	exponent := 255 - exponent.
	index > 1 ifTrue:[
	    "pad negative numbers with 102, if space available,
	     to make them byte-sortable"
	    end := end + 1.
	    mantissaBytes at:21 put:102.
	].
    ].

    bytes := ByteArray new:end.
    bytes at:1 put:exponent.
    bytes replaceBytesFrom:2 to:end with:mantissaBytes startingAt:index.

    ^ bytes.

    "
     self ociNumber:1
     self ociNumber:-1
     self ociNumber:-1.1
     self ociNumber:0.1
     self ociNumber:(3/4)
     self ociNumber:(1/3)
     self ociNumber:(-1/3)
     self ociNumber:5
     self ociNumber:-5
     self ociNumber:2767
     self ociNumber:-2767
     self ociNumber:100000
     self ociNumber:1000000000000000
     self ociNumber:1234567
     self ociNumber:10e80
     self ociNumber:10e-80
     self ociNumber:-10e-80
     self ociNumber:LongFloat pi

     -59999 to:59999 do:[:i|
	(self numberFromOciBytes:(self ociNumber:i)) ~= i ifTrue:[
	    self halt.
	]
     ]

     (-1/4) to:(1/4) by:(1/1024) do:[:i|
	(self numberFromOciBytes:(self ociNumber:i)) ~= i ifTrue:[
	    self halt.
	]
     ]
    "
! !

!OCINumberBuffer class methodsFor:'queries'!

ociDataType

     ^ OCI8Handle numericValueForCDataType:#'SQLT_NUM' 
! !

!OCINumberBuffer methodsFor:'decoding'!

at:index
    "decode the contents of the buffer an return a Number"

    |len startIndex bytes|

    (self indicatorAt:index) == -1 ifTrue:[
	^ nil
    ].

    len := self alenAt:index.
    startIndex := ((index-1)*maxElementLen)+1.
    bytes := buffer copyFrom:startIndex to:startIndex+len-1.
    ^ self class numberFromOciBytes:bytes.

    "
      |buf|

      buf := self new:3.
      buf at:1 put:4711.
      buf at:2 put:314159/10000.
      buf at:3 put:LongFloat pi.
      buf at:1.
      buf at:2.
      buf at:3.
   "
! !

!OCINumberBuffer methodsFor:'encoding'!

visitNumber:aNumber with:index

    |startIndex numberBytes size|

    numberBytes := self class ociNumber:aNumber.
    startIndex := ((index-1)*maxElementLen)+1.
    size := numberBytes size.
    buffer replaceBytesFrom:startIndex to:startIndex+size-1 with:numberBytes startingAt:1.
    self alenAt:index put:size.
! !

!OCINumberBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCINumberBuffer.st,v 1.4 2004-06-11 21:58:14 stefan Exp $'
! !
