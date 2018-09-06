"
 COPYRIGHT (c) 1994 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Integer subclass:#LargeInteger
	instanceVariableNames:'sign digitByteArray'
	classVariableNames:'UseKarazuba'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!LargeInteger class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    This class provides arbitrary precision integers.
    These are represented as:
      sign (-1/0/+1) and, if sign ~~ 0
      the absolute value in a ByteArray of digits with 8 bits per element;
      least significant 8 bits at index 1...

    The implementation is not completely tuned for high performance
    (more key-methods should be rewritten as primitives), although the
    common operations have been pretty tuned for some architectures.

    LargeIntegers are usually not created explicitely, but result from
    SmallInteger arithmetic (overflowing the SmallInteger range).
    Also, results of LargeInteger operations are converted to back to
    SmallIntegers, when possible (see #compressed).

    In contrast to ST-80, there is only one class for LargeIntegers,
    which keeps the sign as an instance variable
    (ST-80 has LargePositiveInteger and LargeNegativeInteger).
    Another possible change is to use 2's complement instead of sign-magnitude
    representation, and to use the underlying CPU's native byte order (instead of LSB).
    This would allow us to use modern CPU vector/longword operations, at least for 64 and
    128 bit numbers (which make up almost all instances in practice).
    As all of these are transparent to the outside world, any of it may or may not
    change in the future.

    [author:]
	Claus Gittinger

    [see also:]
	Number
	Float Fraction FixedPoint
	SmallInteger
"
!

testing
"
   test largeInt multiplication & division
   (at least, test if they have not both errors which anull each other ;-)

   |last v|

   v := last := 1.
   2 to:3000 do:[:i |
       i printCR.
       v := v * i.
       (v / i) ~= last ifTrue:[
	   self halt
       ].
       last := v.
   ]


   test addition, subtraction:

   SmallInteger maxVal                -> 1073741823
   SmallInteger maxVal + 1            -> 1073741824
   SmallInteger maxVal + 2            -> 1073741825
   (SmallInteger maxVal + 2) - 2      -> 1073741823

   SmallInteger minVal                -> -1073741824
   SmallInteger minVal - 1            -> -1073741825
   SmallInteger minVal - 2            -> -1073741826
   (SmallInteger minVal - 2) + 2      -> -1073741824

   1234567890 + 10                    -> 1234567900
   1111111111 + 1111111111            -> 2222222222
   1111111111 - 1111111111            -> 0
   1111111111 - 2222222222            -> -1111111111

   1111111111 * 2                     -> 2222222222
   1111111111 * -2                    -> -2222222222

   1111111111 * 1111111111            -> 1234567900987654321
   1234567900987654321 // 1111111111  -> 1111111111
   1234567900987654321 \\ 1111111111  -> 0
   1234567900987654322 \\ 1111111111  -> 1
   1234567900987654421 \\ 1111111111  -> 100


   addition:
   (16rFFFFFFF0 + 1          ) hexPrintString -> 'FFFFFFF1'
   (16rFFFFFFFF + 1          ) hexPrintString -> '100000000'
   (16rFFFFFFFF + 2          ) hexPrintString -> '100000001'
   (16rFFFFFFFF + 16rFFFFFF  ) hexPrintString -> '100FFFFFE'
   (16rFFFFFFFF + 16rFFFFFFFF) hexPrintString -> '1FFFFFFFE'

   20 factorial         -> 2432902008176640000
   20 factorial + 10000 -> 2432902008176650000
   20 factorial               hexPrintString -> '21C3677C82B40000'
   (20 factorial + 16rFFFF)   hexPrintString -> '21C3677C82B4FFFF'
   (20 factorial + 16rFFFFFF) hexPrintString -> '21C3677C83B3FFFF'

   test comparison:

   -1234567890 >  -1234567890         false
   -1234567890 >= -1234567890         true
   -1234567890 <  -1234567890         false
   -1234567890 <= -1234567890         true
   -1234567890 =  -1234567890         true
   -1234567890 ~= -1234567890         false

   -1234567890 >  -1234567891         true
   -1234567890 >= -1234567891         true
   -1234567890 <  -1234567891         false
   -1234567890 <= -1234567891         false
   -1234567890 =  -1234567891         false
   -1234567890 ~= -1234567891         true

   -1234567891 >  -1234567890         false
   -1234567891 >= -1234567890         false
   -1234567891 <  -1234567890         true
   -1234567891 <= -1234567890         true
   -1234567891 =  -1234567890         false
   -1234567891 ~= -1234567890         true

    1234567890 >  -1234567890         true
    1234567890 >= -1234567890         true
    1234567890 <  -1234567890         false
    1234567890 <= -1234567890         false
    1234567890 =  -1234567890         false
    1234567890 ~= -1234567890         true

   -1234567890 >  1234567890          false
   -1234567890 >= 1234567890          false
   -1234567890 <  1234567890          true
   -1234567890 <= 1234567890          true
   -1234567890 =  1234567890          false
   -1234567890 ~= 1234567890          true

    1234567890 >  1234567890          false
    1234567890 >= 1234567890          true
    1234567890 <  1234567890          false
    1234567890 <= 1234567890          true
    1234567890 =  1234567890          true
    1234567890 ~= 1234567890          false

   -1234567890 >  -10                 false
   -1234567890 >= -10                 false
   -1234567890 <  -10                 true
   -1234567890 <= -10                 true
   -1234567890 =  -10                 false
   -1234567890 ~= -10                 true

   -1234567890 >  10                  false
   -1234567890 >= 10                  false
   -1234567890 <  10                  true
   -1234567890 <= 10                  true
   -1234567890 =  10                  false
   -1234567890 ~= 10                  true

   -10 >  -1234567890                 true
   -10 >= -1234567890                 true
   -10 <  -1234567890                 false
   -10 <= -1234567890                 false
   -10 =  -1234567890                 false
   -10 ~= -1234567890                 true

    10 >  -1234567890                 true
    10 >= -1234567890                 true
    10 <  -1234567890                 false
    10 <= -1234567890                 false
    10 =  -1234567890                 false
    10 ~= -1234567890                 true

    1234567890 >  -10                 true
    1234567890 >= -10                 true
    1234567890 <  -10                 false
    1234567890 <= -10                 false
    1234567890 =  -10                 false
    1234567890 ~= -10                 true

    1234567890 >  10                  true
    1234567890 >= 10                  true
    1234567890 <  10                  false
    1234567890 <= 10                  false
    1234567890 =  10                  false
    1234567890 ~= 10                  true

   -10 >   1234567890                 false
   -10 >=  1234567890                 false
   -10 <   1234567890                 true
   -10 <=  1234567890                 true
   -10 =   1234567890                 false
   -10 ~=  1234567890                 true

    10 >   1234567890                 false
    10 >=  1234567890                 false
    10 <   1234567890                 true
    10 <=  1234567890                 true
    10 =   1234567890                 false
    10 ~=  1234567890                 true
"
! !

!LargeInteger class methodsFor:'instance creation'!

digitBytes:aByteArrayOfDigits
    "create and return a new LargeInteger with digits (lsb-first)
     from the argument, aByteArray.
     The byteArray argument provides the unsigned magnitude in lsb-first order."

    ^ self basicNew setDigits:aByteArrayOfDigits

    "
     LargeInteger digitBytes:#[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF]
     (LargeInteger digitBytes:#[16r12 16r34 16r56 16r78 16r90]) hexPrintString
    "

    "Modified: / 8.5.1998 / 21:40:41 / cg"
!

digitBytes:aByteArrayOfDigits MSB:msb
    "create and return a new LargeInteger with digits (which may be in either msb/lsb order)
     from the argument, aByteArray.
     The byteArray argument provides the unsigned magnitude in the specified byte order."

    |digits|

    msb == false ifTrue:[
	digits := aByteArrayOfDigits
    ] ifFalse:[
	digits := aByteArrayOfDigits reversed
    ].
    ^ self basicNew setDigits:digits

    "
     (LargeInteger digitBytes:#[16r10 16r20 16r30 16r40] MSB:false) hexPrintString
     (LargeInteger digitBytes:#[16r10 16r20 16r30 16r40] MSB:true) hexPrintString
    "
!

digitBytes:aByteArrayOfDigits sign:sign
    "create and return a new sign-magnitude LargeInteger with digits (lsb-first)
     from the argument, aByteArray.
     The byteArray argument provides the unsigned magnitude in lsb-first order."

    ^ self basicNew setDigits:aByteArrayOfDigits sign:sign

    "
     LargeInteger digitBytes:#[16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF]
     (LargeInteger digitBytes:#[16r12 16r34 16r56 16r78 16r90]) hexPrintString
    "

    "Modified: / 8.5.1998 / 21:40:41 / cg"
!

new
    "catch creation message.
     LargeIntegers are only created by system code, which
     uses basicNew and cares for correct initialization."

    self error:'LargeIntegers cannot be created with new'
!

new:numberOfDigits
    "catch creation message"

    self error:'LargeIntegers cannot be created with new'
!

value:aSmallInteger
    "create and return a new LargeInteger with value taken from
     the argument, aSmallInteger.
     Notice:
	this should be only used internally, since such small
	largeIntegers do not normally occur in the system.
	(They are used by myself)
     May change/be removed without notice."

    ^ self basicNew value:aSmallInteger

    "LargeInteger value:3689"

    "Modified: / 8.5.1998 / 21:40:41 / cg"
! !

!LargeInteger class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned."

    ^ true

    "Modified: 23.4.1996 / 15:59:21 / cg"
! !

!LargeInteger methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument."

    |otherSign numberClass|

    (sign == 0) ifTrue:[^ 0].  "cannot happen if correctly normalized"

    "
     this is the common case, multiplying with SmallInteger.
     Use a special method for this case ...
    "
    ((numberClass := aNumber class) == SmallInteger) ifTrue:[
	^ self productFromInteger:aNumber
    ].

    "
     if the argument is not a largeInteger, coerce
    "
    (numberClass == self class) ifFalse:[
	^ self retry:#* coercing:aNumber
    ].

    otherSign := aNumber sign.
    (sign == otherSign) ifTrue:[^ self absMul:aNumber].
    (otherSign == 0) ifTrue:[^ 0].
    ^ (self absMul:aNumber) setSign:-1
!

+ aNumber
    "return the sum of the receiver and the argument, aNumber"

    |otherSign numberClass|

    (sign == 0) ifTrue:[^ aNumber].  "cannot happen if correctly normalized"

    "
     this is the common case, adding a SmallInteger.
     Use a special method for this case ...
    "
    ((numberClass := aNumber class) == SmallInteger) ifTrue:[
	^ self sumFromInteger:aNumber
    ].

    "
     if the argument is not a largeInteger, coerce
    "
    (numberClass == self class) ifFalse:[
	^ self retry:#+ coercing:aNumber
    ].

    otherSign := aNumber sign.
    (sign > 0) ifTrue:[
	"I am positive"
	(otherSign > 0) ifTrue:[^ self absPlus:aNumber sign:1].
	(otherSign < 0) ifTrue:[^ self absMinus:aNumber sign:1].
	^ self
    ].
    "I am negative"
    (otherSign > 0) ifTrue:[^ aNumber absMinus:self sign:1].
    (otherSign < 0) ifTrue:[^ self absPlus:aNumber sign:-1].
    ^ self

    "
     SmallInteger maxVal
     SmallInteger maxVal + 1
     SmallInteger maxVal + 2
     SmallInteger minVal
     SmallInteger minVal - 1
    "

    "Modified: / 9.1.1998 / 13:26:28 / cg"
!

- aNumber
    "return the difference of the receiver and the argument, aNumber"

    |otherSign numberClass|

    (sign == 0) ifTrue:[^ aNumber negated].     "cannot happen if correctly normalized"

    "
     this is the common case, subtracting a SmallInteger.
     Use a special method for this case ...
    "
    ((numberClass := aNumber class) == SmallInteger) ifTrue:[
	sign > 0 ifTrue:[
	    aNumber > 0 ifTrue:[
		^ self absFastMinus:aNumber sign:1
	    ].
	    ^ self absFastPlus:aNumber sign:1
	].
	aNumber > 0 ifTrue:[
	    ^ self absFastPlus:aNumber sign:-1
	].
	^ self absFastMinus:aNumber sign:-1
    ].

    "
     if the argument is not a largeInteger, coerce
    "
    (numberClass == self class) ifFalse:[
	^ self retry:#- coercing:aNumber
    ].

    otherSign := aNumber sign.
    (sign > 0) ifTrue:[
	"I am positive"
	(otherSign > 0) ifTrue:[
	    "+large - +large"
	    ^ self absMinus:aNumber sign:1
	].
	(otherSign < 0) ifTrue:[
	    "+large - -large"
	    ^ self absPlus:aNumber sign:1
	].
	"should not happen"
	^ self
    ].
    "I am negative"
    (otherSign > 0) ifTrue:[
	"-large - +large"
	^ self absPlus:aNumber sign:-1
    ].
    (otherSign < 0) ifTrue:[
	"-large - -large"
	^ self absMinus:aNumber sign:-1
    ].
    ^ self

    "
     12345678901234567890 - 0
     12345678901234567890 - 1
     12345678901234567890 - -1
     -12345678901234567890 - 1
     -12345678901234567890 - -1

     12345678901234567890 - 12345678901234567880
     12345678901234567890 - 12345000000000000000
     12345678901234567890 - -87654321098765432110
     -12345678901234567890 - 87654321098765432110
     -12345678901234567890 - -12345678901234567880
     -12345678901234567890 - -12345678901234567980
    "

    "Modified: 20.10.1996 / 18:42:16 / cg"
!

/ aNumber
    "return the quotient of the receiver and the argument, aNumber"

    aNumber isInteger ifTrue:[
	^ Fraction numerator:self denominator:aNumber
    ].
    aNumber isFraction ifTrue:[
	^ Fraction numerator:(self * aNumber denominator) denominator:(aNumber numerator)
    ].

    "this is a q&d hack - we loose lots of precision here ..."
    ^ (self asFloat / aNumber asFloat)

    "Modified: 28.7.1997 / 19:07:55 / cg"
!

// aNumber
    "return the integer part of the quotient of the receiver's value
     and the argument's value.
     The result is truncated toward negative infinity
     and will be negative, if the operands signs differ.
     The following is always true:
	(receiver // aNumber) * aNumber + (receiver \\ aNumber) = receiver

     Be careful with negative results: 9 // 4 -> 2, while -9 // 4 -> -3.
     Especially surprising (because of truncation toward negative infinity):
	-1 // 10 -> -1 (because -(1/10) is truncated towards next smaller integer, which is -1.
	-10 // 3 -> -4 (because -(10/3) is truncated towards next smaller integer, which is -4.

     See #quo: which truncates toward zero and returns -2 in the above case
     and #rem: which is the corresponding remainder."

    |nrClass divMod quo|

    nrClass := aNumber class.

    "
     this is the common case, dividing by a SmallInteger.
     Use a special method for this case ...
    "
    ((nrClass == SmallInteger) or:[ nrClass == self class]) ifFalse:[
	^ self retry:#// coercing:aNumber
    ].
    divMod := self absDivMod:aNumber.

    quo := divMod at:1.
    (sign == aNumber sign) ifFalse:[
	"/ adjust for truncation if negative and there is a remainder ...
	"/ be careful: there is one special case to care for here:
	"/ if quo is maxInt+1, the negation can be represented as a smallInt.
	quo := quo setSign:-1.
	(divMod at:2) == 0 ifFalse:[
	    ^ quo - 1
	].
"/        quo digitLength == SmallInteger maxBytes ifTrue:[
"/            ^ quo compressed
"/        ].
    ].
    ^ quo

    "
     (9000000000 // 4000000000)   =   (900 // 400)   ifFalse:[self halt].
     (-9000000000 // 4000000000)  =   (-900 // 400)  ifFalse:[self halt].
     (9000000000 // -4000000000)  =   (900 // -400)  ifFalse:[self halt].
     (-9000000000 // -4000000000) =   (-900 // -400) ifFalse:[self halt].

     16rfffffffff // 16r01ffffff  =   2048 ifFalse:[self halt].
     16rfffffffff // 16r00ffffff  =   4096 ifFalse:[self halt].
     16rfffffffff // 16r001fffff  =  32768 ifFalse:[self halt].

     900 quo: 400
     -900 quo: 400
     900 quo: -400
     -900 quo: -400

     9000000000 quo: 4000000000
     -9000000000 quo: 4000000000
     9000000000 quo: -4000000000


     0 // 40000000000000000
    "

    "Modified: / 27-04-1999 / 19:50:26 / stefan"
    "Modified: / 26-02-2016 / 22:28:27 / cg"
!

\\ aNumber
    "Answer the integer remainder m defined by division with truncation toward
     negative infinity.
     m < |aNumber| AND there is an integer k with (k * aNumber + m) = self

     The returned remainder has the same sign as aNumber.
     The following is always true:
	(receiver // aNumber) * aNumber + (receiver \\ aNumber) = receiver

     Be careful with negative results: 9 // 4 -> 2, while -9 // 4 -> -3.
     Especially surprising:
	-1 \\ 10 -> 9  (because -(1/10) is truncated towards next smaller integer, which is -1,
			and -1 multiplied by 10 gives -10, so we have to add 9 to get the original -1).
	-10 \\ 3 -> 2 (because -(10/3) is truncated towards next smaller integer, which is -4,
			and -4 * 4 gives -12, so we need to add 2 to get the original -10.

     See #rem: which is the corresponding remainder for division via #quo:.

     Redefined here for speed."

    |rem negativeDivisor nrClass|

    nrClass := aNumber class.
    ((nrClass == SmallInteger) or:[nrClass == self class]) ifFalse:[
	^ self retry:#\\ coercing:aNumber
    ].

    rem := (self absDivMod:aNumber) at:2.
    rem ~~ 0 ifTrue:[
	negativeDivisor := aNumber negative.
	negativeDivisor ifTrue:[
	    rem := rem setSign:-1
	].
	(self negative ~~ negativeDivisor) ifTrue:[
	    "different sign, so remainder would have been negative.
	     rem has been rounded toward zero, this code will simulate
	     rounding to negative infinity."

	    rem := aNumber - rem.
	].
    ].
    ^ rem

    "
     (9000000000 \\ 4000000000)   = (900 \\ 400 * 10000000)  ifFalse:[self halt].
     (-9000000000 \\ 4000000000)  = (-900 \\ 400 * 10000000) ifFalse:[self halt].
     (9000000000 \\ -4000000000)  = (900 \\ -400 * 10000000) ifFalse:[self halt].
     (-9000000000 \\ -4000000000) = (-900 \\ -400 * 10000000)ifFalse:[self halt].
     (16000000000 \\ 4000000000)  = (1600 \\ 400 * 10000000) ifFalse:[self halt].
     (-16000000000 \\ 4000000000)  = (-1600 \\ 400 * 10000000) ifFalse:[self halt].
     (16000000000 \\ -4000000000)  = (1600 \\ -400 * 10000000) ifFalse:[self halt].
     (-16000000000 \\ -4000000000)  = (-1600 \\ -400 * 10000000) ifFalse:[self halt].

     9000000000 \\ 7
     -9000000000 \\ 7
     9000000000 \\ -7
     -9000000000 \\ -7

     900 rem: 400
     -900 rem: 400
     900 rem: -400
     -900 rem: -400

     9000000000 rem: 4000000000
     -9000000000 rem: 4000000000
     9000000000 rem: -4000000000
     -9000000000 rem: -4000000000
    "

    "Modified: / 5.11.1996 / 17:10:10 / cg"
    "Modified: / 27.4.1999 / 20:03:40 / stefan"
!

abs
    "return my absolute value. redefined for speed."

    sign >= 0 ifTrue:[^ self].
    ^ self negated

    "Created: / 26.10.1999 / 21:28:06 / stefan"
!

divMod:aNumber
    "return an array filled with
	(self // aNumber) and (self \\ aNumber).
     The returned remainder has the same sign as aNumber.
     The following is always true:
	(receiver // something) * something + (receiver \\ something) = receiver

     Be careful with negative results: 9 // 4 -> 2, while -9 // 4 -> -3.
     Especially surprising:
	-1 \\ 10 -> 9  (because -(1/10) is truncated towards next smaller integer, which is -1,
			and -1 multiplied by 10 gives -10, so we have to add 9 to get the original -1).
	-10 \\ 3 -> 2 (because -(10/3) is truncated towards next smaller integer, which is -4,
			and -4 * 4 gives -12, so we need to add 2 to get the original -10.

     This is redefined here for more performance
     (as the remainder is generated as a side effect of division)"

    |nrClass|

    ((self < 0) or:[aNumber <= 0]) ifTrue:[
	"/ this is rubbish
	^ super divMod:aNumber
    ].

    "/ only handle the common case here
    nrClass := aNumber class.
    (nrClass == SmallInteger) ifFalse:[
	(nrClass == self class) ifFalse:[
	    ^ super divMod:aNumber
	].
    ].

    ^ self absDivMod:aNumber.

    "
     9000000000 // 4000000000   => 2
     9000000000 \\ 4000000000   => 1000000000

     9000000000 divMod: 4000000000   => #(2 1000000000)
     -9000000000 divMod: 4000000000   => #(-3 3000000000)
     9000000000 divMod: -4000000000   => #(-3 -3000000000)
     -9000000000 divMod: -4000000000   => #(2 -1000000000)

     9000000000000000000 absDivMod: 400000000000000   => #(22500 0)
     -9000000000000000000 absDivMod: 400000000000000   => #(22500 0)
     9000000000000000000 absDivMod: -400000000000000   => #(22500 0)
     -9000000000000000000 absDivMod: -400000000000000   => #(22500 0)

     9000000000000000000 absDivMod: 4000000000000000   => #(2250 0)
     -9000000000000000000 absDivMod: 4000000000000000   => #(2250 0)
     9000000000000000000 absDivMod: -4000000000000000   => #(2250 0)
     -9000000000000000000 absDivMod: -4000000000000000   => #(2250 0)

     9000000000000000000 absDivMod: 4000000000000000000   => #(2 1000000000000000000)
     -9000000000000000000 absDivMod: 4000000000000000000   => #(2 1000000000000000000)
     9000000000000000000 absDivMod: -4000000000000000000   => #(2 1000000000000000000)
     -9000000000000000000 absDivMod: -4000000000000000000   => #(2 1000000000000000000)
    "

    "Created: / 29.10.1996 / 21:22:05 / cg"
    "Modified: / 27.4.1999 / 19:48:58 / stefan"
!

negated
    "return an integer with value negated from the receiver's value."

    |newNumber sz|

    (sign == 0) ifTrue:[^ 0].

    "
     special case for SmallInteger minVal
    "
    sign == 1 ifTrue:[
	sz := digitByteArray size.
%{
#ifdef __SCHTEAM__
#else /* not SCHTEAM */
	int idx;
	unsigned char *bp;

	bp = (unsigned char *)(__ByteArrayInstPtr(__INST(digitByteArray))->ba_element);
	idx = __intVal(sz);

	while ((idx > 1) && (bp[idx-1] == 0)) idx--;

	if (idx == sizeof(INT)) {
# if defined(__LSBFIRST__)
#  if __POINTER_SIZE__ == 8
	    if ( ((unsigned INT *)bp)[0] == 0x4000000000000000L)
#  else
	    if ( ((unsigned INT *)bp)[0] == 0x40000000)
#  endif
# else
	    /*
	     * generic code
	     */
	    if ((bp[idx-1] == 0x40)
	     && (bp[idx-2] == 0)
	     && (bp[idx-3] == 0)
	     && (bp[idx-4] == 0)
#  if __POINTER_SIZE__ == 8
	     && (bp[idx-5] == 0)
	     && (bp[idx-6] == 0)
	     && (bp[idx-7] == 0)
	     && (bp[idx-8] == 0)
#  endif
	    )
# endif
	    {
		RETURN (__mkSmallInteger(_MIN_INT));
	    }
	}
#endif
%}.

	sz == SmallInteger maxBytes ifTrue:[
	  (digitByteArray at:1) == 0 ifTrue:[
	   (digitByteArray at:2) == 0 ifTrue:[
	    (digitByteArray at:3) == 0 ifTrue:[
		SmallInteger maxBytes == 8 ifTrue:[
		  (digitByteArray at:4) == 0 ifTrue:[
		   (digitByteArray at:5) == 0 ifTrue:[
		    (digitByteArray at:6) == 0 ifTrue:[
		     (digitByteArray at:7) == 0 ifTrue:[
		      (digitByteArray at:8) == 16r40 ifTrue:[
			^ SmallInteger minVal
		      ].
		     ]
		    ]
		   ]
		  ]
		] ifFalse:[
		  (digitByteArray at:4) == 16r40 ifTrue:[
		    ^ SmallInteger minVal
		  ].
		]
	    ]
	   ]
	  ]
	].
    ].
    "/ cg - can share the digits ...
    newNumber := self class digitBytes:digitByteArray sign:(sign negated).
    ^ newNumber
!

quo:aNumber
    "return the quotient of the receiver and the argument, aNumber.
     The result is truncated toward zero (which is different from //, which
     truncates toward negative infinity).
     The result's sign is negative if the receiver has a sign different from the arg's sign.
     The following is always true:
	(receiver quo: aNumber) * aNumber + (receiver rem: aNumber) = receiver
     For positive results, this is the same as #//,
     for negative results, the remainder is ignored.
     I.e.: '9 // 4 = 2' and '-9 // 4 = -3'
     in contrast: '9 quo: 4 = 2' and '-9 quo: 4 = -2'"

    |nrClass quo |

    nrClass := aNumber class.
    ((nrClass == SmallInteger) or:[ nrClass == self class] ) ifFalse:[
	^ self retry:#quo: coercing:aNumber
    ].

    quo := (self absDivMod:aNumber) at:1.
    (sign == aNumber sign) ifTrue:[
	^ quo
    ].
    ^ quo setSign:-1

    "
     900 // 400
     -900 // 400
     900 // -400
     -900 // -400

     9000000000 // 4000000000
     -9000000000 // 4000000000
     9000000000 // -4000000000
     -9000000000 // -4000000000

     900 quo: 400
     -900 quo: 400
     900 quo: -400
     -900 quo: -400

     9000000000 quo: 4000000000
     -9000000000 quo: 4000000000
     9000000000 quo: -4000000000
     -9000000000 quo: -4000000000
    "

    "Modified: / 5.11.1996 / 14:14:17 / cg"
    "Modified: / 27.4.1999 / 20:01:22 / stefan"
!

rem:aNumber
    "return the remainder of division of the receiver by the argument, aNumber.
     The returned remainder has the same sign as the receiver.
     The following is always true:
	(receiver quo: aNumber) * aNumber + (receiver rem: aNumber) = receiver
    "

    |nrClass rem|

    nrClass := aNumber class.
    ((nrClass == SmallInteger) or:[ nrClass == self class ]) ifFalse:[
	^ self retry:#rem coercing:aNumber
    ].
    rem := (self absDivMod:aNumber) at:2.
    rem ~~ 0 ifTrue:[
	sign < 0 ifTrue:[
	    ^ rem setSign:-1
	].
    ].
    ^ rem

    "
     900 \\ 400
     -900 \\ 400
     900 \\ -400
     -900 \\ -400

     9000000000 \\ 4000000000
     -9000000000 \\ 4000000000
     9000000000 \\ -4000000000
     -9000000000 \\ -4000000000

     900 rem: 400
     -900 rem: 400
     900 rem: -400
     -900 rem: -400

     9000000000 rem: 4000000000
     -9000000000 rem: 4000000000
     9000000000 rem: -4000000000
     -9000000000 rem: -4000000000
    "

    "Modified: / 5.11.1996 / 14:02:59 / cg"
    "Modified: / 29.4.1999 / 11:26:51 / stefan"
! !

!LargeInteger methodsFor:'bit operators'!

bitAnd:anInteger
    "return the bitwise-and of the receiver and the argument, anInteger"

%{  /* NOCONTEXT */
    if (__isSmallInteger(anInteger)) {
	INT v2 = __intVal(anInteger);
	INT v1;
#if defined(__LSBFIRST__)
	v1 = *(INT *)(__byteArrayVal(__INST(digitByteArray)));
#else
	unsigned char *digits = (unsigned char *)(__byteArrayVal(__INST(digitByteArray)));

	v1 = digits[0] & 0xFF;
	v1 = v1 | ((digits[1] & 0xFF)<<8);
	v1 = v1 | ((digits[2] & 0xFF)<<16);
	v1 = v1 | ((digits[3] & 0xFF)<<24);
# if (__POINTER_SIZE__ == 8)
	v1 = v1 | ((digits[4] & 0xFF)<<32);
	v1 = v1 | ((digits[5] & 0xFF)<<40);
	v1 = v1 | ((digits[6] & 0xFF)<<48);
	v1 = v1 | ((digits[7] & 0xFF)<<56);
 #endif
#endif
	RETURN ( __mkSmallInteger(v1 & v2) );
    }

    if (__isLargeInteger(anInteger)) {
	OBJ _myDigitByteArray = __INST(digitByteArray);
	OBJ _otherDigitByteArray = __LargeIntegerInstPtr(anInteger)->l_digits;

	if (__isByteArray(_myDigitByteArray)
	 && __isByteArray(_otherDigitByteArray)) {
	    unsigned char *pDigits1, *pDigits2;
	    int size1, size2, minSize;
	    union {
		double d;                    // force align
		unsigned char chars[2048+8];
	    } buffer;
	    unsigned char *pRslt;
	    OBJ newDigits, newLarge;

	    pDigits1 = (unsigned char *)(__byteArrayVal(_myDigitByteArray));
	    pDigits2 = (unsigned char *)(__byteArrayVal(_otherDigitByteArray));
	    pRslt = (void *)(buffer.chars);

	    size1 = __byteArraySize(_myDigitByteArray);
	    size2 = __byteArraySize(_otherDigitByteArray);
	    minSize = (size1 < size2) ? size1 : size2;
	    if (minSize <= sizeof(buffer.chars)) {
		int n = minSize;

	    /* not worth it - but a nice try and first testbed for mmx... */
#define x__USE_MMX__
#ifdef __USE_MMX__
#ifdef __VISUALC__
		if (((INT)pRslt & 7) == 0) {    // 8-byte aligned
		    if (((INT)pDigits1 & 7) == ((INT)pDigits2 & 7)) {   // same align
			while (((INT)pDigits1 & 7) && (n >= sizeof(int))) {
			    ((int *)pRslt)[0] = ((int *)pDigits1)[0] & ((int *)pDigits2)[0];
			    pRslt += sizeof(int);
			    pDigits1 += sizeof(int);
			    pDigits2 += sizeof(int);
			    pDigits2 += sizeof(int);
			    n -= sizeof(int);
			}
			for (; n >= 8; n -= 8) {
			    __asm {
				mov eax, pDigits1
				movq mm0, [eax]
				mov eax, pDigits2
				movq mm1, [eax]
				pand mm0, mm1
				mov eax, pRslt
				movq [eax], mm0
			    }
			    pDigits1 += 8;
			    pDigits2 += 8;
			    pRslt += 8;
			}
			__asm {
			    emms ; switch back to FPU state.
			}
		    }
		}
#endif /* __VISUALC__ */
#endif /* __USE_MMX__ */

		for (; n >= sizeof(INT)*4; n -= sizeof(INT)*4) {
		    ((INT *)pRslt)[0] = ((INT *)pDigits1)[0] & ((INT *)pDigits2)[0];
		    ((INT *)pRslt)[1] = ((INT *)pDigits1)[1] & ((INT *)pDigits2)[1];
		    ((INT *)pRslt)[2] = ((INT *)pDigits1)[2] & ((INT *)pDigits2)[2];
		    ((INT *)pRslt)[3] = ((INT *)pDigits1)[3] & ((INT *)pDigits2)[3];
		    pRslt += sizeof(INT)*4;
		    pDigits1 += sizeof(INT)*4;
		    pDigits2 += sizeof(INT)*4;
		}
		for (; n >= sizeof(INT); n -= sizeof(INT)) {
		    ((INT *)pRslt)[0] = ((INT *)pDigits1)[0] & ((INT *)pDigits2)[0];
		    pRslt += sizeof(INT);
		    pDigits1 += sizeof(INT);
		    pDigits2 += sizeof(INT);
		}
		for (; n > 0; n--) {
		    *pRslt = *pDigits1 & *pDigits2;
		    pRslt++;
		    pDigits1++;
		    pDigits2++;
		}
		// normalize
		while ((pRslt[-1]==0) && (pRslt > buffer.chars)) {
		    pRslt--;
		}

		// allocate result
		n = pRslt-buffer.chars;
		if (n <= sizeof(INT)) {
		    INT val = 0;

		    // make it a smallInteger / 32bitInteger
		    while (n > 0) {
			val = (val << 8) + buffer.chars[--n];
		    }
		    RETURN (__MKUINT(val));
		}
		newDigits = __MKBYTEARRAY(buffer.chars, n);
		if (newDigits) {
		    __PROTECT__(newDigits);
		    newLarge = __STX___new(sizeof(struct __LargeInteger));
		    __UNPROTECT__(newDigits);
		    if (newLarge) {
			__InstPtr(newLarge)->o_class = LargeInteger; __STORE(newLarge, LargeInteger);
			__LargeIntegerInstPtr(newLarge)->l_digits = newDigits; __STORE(newLarge, newDigits);
			__LargeIntegerInstPtr(newLarge)->l_sign = __MKSMALLINT(1);
			RETURN (newLarge);
		    }
		}
	    }
	}
    }
%}.
    ^ super bitAnd:anInteger

    "
     (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFF) hexPrintString
     (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFF) hexPrintString
     (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFF) hexPrintString
     (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFF) hexPrintString
     (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFF) hexPrintString
     (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFF) hexPrintString
     (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFFFF) hexPrintString
     (16rFFEEDDCCBBAA998877665544332211 bitAnd:16rFFFFFFFFFFFFFFFFFF) hexPrintString
    "

    "Modified: / 26.9.2001 / 17:34:03 / cg"
!

bitXor:anInteger
    "return the bitwise-or of the receiver and the argument, anInteger.
     Here, a specially tuned version for largeInteger arguments
     (to speed up some cryptographic code)"

    |len1 len2 newBytes|

    anInteger class ~~ LargeInteger ifTrue:[^ super bitXor:anInteger].

    (len1 := anInteger digitLength) > (len2 := self digitLength) ifTrue:[
	newBytes := anInteger digitBytes copy.
	newBytes bitXorBytesFrom:1 to:len2 with:digitByteArray startingAt:1
    ] ifFalse:[
	newBytes := digitByteArray copy.
	newBytes bitXorBytesFrom:1 to:len1 with:anInteger digits startingAt:1
    ].
    ^ (self class digitBytes:newBytes) compressed

    "
     (16r112233445566778899 bitXor:16rFF                ) printStringRadix:16 '112233445566778866'
     (16r112233445566778899 bitXor:16rFFFFFFFFFFFFFFFF00) printStringRadix:16 'EEDDCCBBAA99887799'
     (16r112233445566778899 bitXor:16rFF0000000000000000) printStringRadix:16 'EE2233445566778899'
     (16r112233445566778899 bitXor:16r112233445566778800) printStringRadix:16 '99'

     |bigNum1 bigNum2|

     bigNum1 := 2 raisedToInteger:512.
     bigNum2 := 2 raisedToInteger:510.
     Time millisecondsToRun:[
	1000000 timesRepeat:[
	   bigNum1 bitXor:bigNum2.
	]
     ]
    "
!

lowBit
    "return the bitIndex of the lowest bit set. The returned bitIndex
     starts at 1 for the least significant bit.
     Returns 0 if no bit is set.
     For negative numbers, the low bit of my absolute value is returned.
     Redefined here for more performance of the gcd: algorithm, which
     is used when big fractions are reduced (should we write a primitive for this ?)."

    |sz   "{ Class: SmallInteger }"
     idx0 "{ Class: SmallInteger }"
     byte|

    idx0 := 1.

%{
    OBJ __digitByteArray = __INST(digitByteArray);

    /*
     * quickly advance over full 0-words
     */
    if (__isByteArray(__digitByteArray)) {
	int __sz = __byteArraySize(__digitByteArray);
	unsigned char *__bP = __byteArrayVal(__digitByteArray);
	unsigned char *__bP0 = __bP;

	sz = __MKSMALLINT(__sz);

#ifdef __UNROLL_LOOPS__
	while (__sz > (sizeof(INT) * 4)) {
	    if (( ((INT *)__bP)[0]
		 | ((INT *)__bP)[1]
		 | ((INT *)__bP)[2]
		 | ((INT *)__bP)[3] ) != 0) break;
	    __sz -= sizeof(INT) * 4;
	    __bP += sizeof(INT) * 4;
	}
#endif
	while (__sz > sizeof(INT)) {
	    if ( ((INT *)__bP)[0] != 0 ) break;
	    __sz -= sizeof(INT);
	    __bP += sizeof(INT);
	}
	while (__sz > 0) {
	    unsigned int c;

	    if ( (c = *__bP) != 0 ) {
		int bitIdx = (__bP - __bP0) * 8;
#ifdef __BSF
		{
		    int index;
		    int t = c;

		    index = __BSF(t);
		    RETURN ( __mkSmallInteger(index + 1 + bitIdx) );
		}
#else
		if (c & 0x0F) {
		    if (c & 0x03) {
			if (c & 0x01) {
			    RETURN ( __mkSmallInteger( bitIdx + 1) );
			} else {
			    RETURN ( __mkSmallInteger( bitIdx + 2) );
			}
		    } else {
			if (c & 0x04) {
			    RETURN ( __mkSmallInteger( bitIdx + 3) );
			} else {
			    RETURN ( __mkSmallInteger( bitIdx + 4) );
			}
		    }
		} else {
		    if (c & 0x30) {
			if (c & 0x10) {
			    RETURN ( __mkSmallInteger( bitIdx + 5) );
			} else {
			    RETURN ( __mkSmallInteger( bitIdx + 6) );
			}
		    } else {
			if (c & 0x40) {
			    RETURN ( __mkSmallInteger( bitIdx + 7) );
			} else {
			    RETURN ( __mkSmallInteger( bitIdx + 8) );
			}
		    }
		}
#endif
		break;
	    }
	    __sz--;
	    __bP++;
	}
	idx0 = __mkSmallInteger( __bP - __bP0 + 1 );
    }
%}.

    "/ never actually reached
    idx0 to:sz do:[:digitIndex |
	(byte := digitByteArray at:digitIndex) ~~ 0 ifTrue:[
	    ^ (digitIndex-1)*8 + (byte lowBit)
	]
    ].
    ^ 0 "/ should not happen

    "
     (1 bitShift:0) lowBit
     (1 bitShift:10) lowBit
     (1 bitShift:20) lowBit
     (1 bitShift:30) lowBit
     (1 bitShift:30) highBit
     (1 bitShift:31) lowBit
     (1 bitShift:31) highBit
     (1 bitShift:32) lowBit
     (1 bitShift:32) highBit
     (1 bitShift:33) lowBit
     (1 bitShift:33) highBit
     (1 bitShift:64) lowBit
     (1 bitShift:64) highBit
     (1 bitShift:1000) lowBit
     (1 bitShift:1000) highBit
     ((1 bitShift:64)-1) lowBit
     ((1 bitShift:64)-1) highBit

     1 to:1000 do:[:idx |
	self assert:(( 1 bitShift:idx) lowBit = (idx+1)).
	self assert:(( 1 bitShift:idx) lowBit = ( 1 bitShift:idx) highBit).
	self assert:(( 3 bitShift:idx) lowBit = (idx+1)).
	self assert:(( 7 bitShift:idx) lowBit = (idx+1)).
	self assert:(( 15 bitShift:idx) lowBit = (idx+1)).
	self assert:(( 31 bitShift:idx) lowBit = (idx+1)).
	self assert:(( 63 bitShift:idx) lowBit = (idx+1)).
	self assert:(( 127 bitShift:idx) lowBit = (idx+1)).
	self assert:(( 255 bitShift:idx) lowBit = (idx+1)).
     ]

     |num|

     num := (1 bitShift:1000).
     Time millisecondsToRun:[
	1000000 timesRepeat:[
	    num lowBit
	]
     ]
    "

    "Modified: 14.8.1997 / 11:55:34 / cg"
! !

!LargeInteger methodsFor:'bit operators - indexed'!

bitAt:anIntegerIndex
    "return the value of the index's bit (index starts at 1) as 0 or 1.
     Notice: the result of bitAt: on negative receivers is not
	     defined in the language standard (since the implementation
	     is free to choose any internal representation for integers)"

%{  /* NOCONTEXT */
    if (__isSmallInteger(anIntegerIndex)) {
	INT idx = __smallIntegerVal(anIntegerIndex) - 1;

	if (idx >= 0) {
	    int v1;
	    int byteOffset = idx / 8;
	    int digitLen   = __byteArraySize(__INST(digitByteArray));

	    if (digitLen < byteOffset) {
		RETURN(__mkSmallInteger(0));
	    }

	    v1 = (__byteArrayVal(__INST(digitByteArray)))[byteOffset];
	    if (v1 & (1 << (idx % 8))) {
		RETURN(__mkSmallInteger(1));
	    } else {
		RETURN(__mkSmallInteger(0));
	    }
	}
    }
%}.
    ^ super bitAt:anIntegerIndex

    "
     TestCase should:[ 16rFFFFFFFFFF01 bitAt:0 ] raise:Error
     TestCase assert:( 16rFFFFFFFFFF01 bitAt:49 ) == 0
     TestCase assert:( 16rFFFFFFFFFF01 bitAt:1  ) == 1
     TestCase assert:( 16rFFFFFFFFFF01 bitAt:2  ) == 0
     TestCase assert:( 16rFFFFFFFFFF02 bitAt:2  ) == 1
     TestCase assert:( 16rFFFFFFFF01FF bitAt:8  ) == 1
     TestCase assert:( 16rFFFFFFFF01FF bitAt:9  ) == 1
     TestCase assert:( 16rFFFFFFFF01FF bitAt:10 ) == 0
    "

    "Modified: / 10-08-2010 / 12:33:04 / cg"
!

setBit:index
    "return a new integer, where the specified bit is on.
     Bits are counted from 1 starting with the least significant.
     The methods name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBitSet:"

    |myDigitLength newDigitLength newDigitBytes byteIndexOfBitToSet|

    index <= 0 ifTrue:[
	^ SubscriptOutOfBoundsSignal
		raiseRequestWith:index
		errorString:'index out of bounds'
    ].

    myDigitLength := digitByteArray size.
    byteIndexOfBitToSet := ((index-1)//8)+1.
    byteIndexOfBitToSet > myDigitLength ifTrue:[
	newDigitLength := myDigitLength max:byteIndexOfBitToSet.
	newDigitBytes := ByteArray new:newDigitLength.
	newDigitBytes replaceFrom:1 to:myDigitLength with:digitByteArray startingAt:1.
    ] ifFalse:[
	newDigitBytes := digitByteArray copy
    ].
    newDigitBytes
	at:byteIndexOfBitToSet
	put:((newDigitBytes at:byteIndexOfBitToSet) setBit:(((index-1)\\8)+1)).
    ^ self class digitBytes:newDigitBytes sign:sign

    "
     TestCase assert:( 16r80000000 setBit:3  ) = 16r80000004
     TestCase assert:( 16r80000000 setBit:33 ) = 16r180000000
    "
! !

!LargeInteger methodsFor:'bit operators-32bit'!

bitInvert32
    "return the value of the receiver with all bits inverted in 32bit signed int space
     (changes the sign)"

%{  /* NOCONTEXT */
    unsigned INT v;

    v = __unsignedLongIntVal(self);
    v = ~v;
#if __POINTER_SIZE__ == 8
    v &= 0xFFFFFFFFL;
#endif
    RETURN ( __MKUINT(v) );
%}.
    ^ self primitiveFailed

    "
     16r80000000 bitInvert32 hexPrintString
     16r7FFFFFFF bitInvert32 hexPrintString
     16rFFFFFFFF bitInvert32 hexPrintString
     0 bitInvert32 hexPrintString
    "
!

bitRotate32:shiftCount
    "return the value of the receiver rotated by shiftCount bits,
     but only within 32 bits, rotating left for positive, right for negative counts.
     Rotates through the sign bit.
     Useful for crypt algorithms, or to emulate C/Java semantics."

%{  /* NOCONTEXT */

    unsigned INT bits;
    int count;

    if (__isSmallInteger(shiftCount)) {
	count = __intVal(shiftCount);
	count = count % 32;

	bits = __unsignedLongIntVal(self);
	if (count > 0) {
	    bits = (bits << count) | (bits >> (32-count));
	} else {
	    bits = (bits >> (-count)) | (bits << (32-(-count)));
	}
#if __POINTER_SIZE__ == 8
	bits &= 0xFFFFFFFFL;
#endif
	RETURN (__MKUINT(bits));
    }
%}.
    ^ self primitiveFailed

    "
     (1 bitShift32:31) rotate32:0
     (1 bitShift32:31) rotate32:1
     (1 bitShift32:31) rotate32:-1
    "
!

bitShift32:shiftCount
    "return the value of the receiver shifted by shiftCount bits,
     but only within 32 bits, shifting into/out-of the sign bit.
     May be useful for communication interfaces, to create ST-numbers
     from a signed 32bit int value given as individual bytes,
     or to emulate C/Java semantics.
     The shift is unsigned"

%{  /* NOCONTEXT */

    unsigned INT bits;
    int count;

    if (__isSmallInteger(shiftCount)) {
	count = __intVal(shiftCount);
	if (count >= 32) {
	    RETURN (__mkSmallInteger(0));
	}

	bits = __unsignedLongIntVal(self);
	if (count > 0) {
	    bits = bits << count;
	} else {
	    bits = bits >> (-count);
	}
#if __POINTER_SIZE__ == 8
	bits &= 0xFFFFFFFFL;
#endif
	RETURN (__MKUINT(bits));
    }
%}.
    ^ self primitiveFailed

    "
     128 bitShift:24
     128 bitShift32:24

     1 bitShift:31
     1 bitShift32:31
    "
!

bitXor32:aNumber
    "return the xor of the receiver and the argument.
     The argument must be a SmallInteger or a 4-byte LargeInteger.
     If the result overflows the 32 bit range, the value modulo 16rFFFFFFFF is returned.
     This is of course not always correct, but allows for C/Java behavior to be emulated."

%{  /* NOCONTEXT */
    INT rslt;

    rslt =  __unsignedLongIntVal(self) ^ __unsignedLongIntVal(aNumber);
#if __POINTER_SIZE__ == 8
    rslt &= 0xFFFFFFFFL;
#endif
    RETURN ( __MKUINT(rslt));
%}.
    self primitiveFailed

    "
     16r7FFFFFFF bitXor: 16r80000000          4294967295
     16r7FFFFFFF bitXor32: 16r80000000
    "
! !

!LargeInteger methodsFor:'byte access'!

byteSwapped
    "lsb -> msb;
     i.e. a.b ... y.z -> z.y. ... b.a"

    ^ self class digitBytes:digitByteArray MSB:true

    "
     (LargeInteger value:16r11223344) byteSwapped hexPrintString
     (LargeInteger value:16r44332211) byteSwapped hexPrintString
     16r88776655 byteSwapped hexPrintString
     16r11223344 byteSwapped hexPrintString
    "

    "Created: / 31-01-2012 / 11:07:42 / cg"
!

byteSwapped32
    "byte swap a 32bit value; lsb -> msb;
     i.e. a.b.c.d -> d.c.b.a
     Useful for communication protocols"

%{
    unsigned INT swapped;

    swapped = ( (__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[0]) << 24)
	      | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[1]) << 16)
	      | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[2]) << 8)
	      | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[3]));
    RETURN (__MKUINT(swapped));
%}.
    ^ super byteSwapped32

    "
     (LargeInteger value:16r11223344) byteSwapped32 hexPrintString
     (LargeInteger value:16r44332211) byteSwapped32 hexPrintString
     16r88776655 byteSwapped32 hexPrintString
     16r11223344 byteSwapped32 hexPrintString
    "

    "Created: / 31-01-2012 / 11:07:42 / cg"
!

byteSwapped64
    "byte swap a 64bit value; lsb -> msb;
     i.e. a.b.c.d.e.f.g.h -> h.g.f.e.d.c.b.a
     Useful for communication protocols"

%{
    unsigned INT swappedLO = 0;
    unsigned INT swappedHI;
    unsigned INT swapped;

    swappedHI = ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[0]) << 24)
	      | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[1]) << 16)
	      | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[2]) << 8)
	      | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[3]));
    if (__byteArraySize(__INST(digitByteArray)) > 4) {
	swappedLO = ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[4]) << 24)
		  | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[5]) << 16)
		  | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[6]) << 8)
		  | ((__ByteArrayInstPtr(__INST(digitByteArray))->ba_element[7]));
    }

#if __POINTER_SIZE__ == 8
    swapped = (swappedHI<<32) | swappedLO;
    RETURN(__MKUINT( swapped ));
#else
    RETURN(__MKLARGEINT64(1, swappedLO, swappedHI));
#endif
%}.
    ^ super byteSwapped64

    "
     (LargeInteger value:16r11223344) byteSwapped64 hexPrintString
     (LargeInteger value:16r44332211) byteSwapped64 hexPrintString
     (LargeInteger value:16r1122334455667788) byteSwapped64 hexPrintString
     (LargeInteger value:16r8877665544332211) byteSwapped64 hexPrintString
     16r88776655 byteSwapped hexPrintString
     16r11223344 byteSwapped hexPrintString
    "

    "Created: / 31-01-2012 / 11:07:42 / cg"
!

digitAt:index
    "return 8 bits of value, starting at byte index"

%{
#ifdef __SCHTEAM__
    return context._RETURN( ((STLargeInteger)self).digitAt( index.intValue() ) );
#endif
%}.
    index > digitByteArray size ifTrue:[^ 0].
    ^ digitByteArray at:index
!

digitAt:index put:aByte
    "set the 8 bits, index is a byte index"

%{
#ifdef __SCHTEAM__
    ERROR("cannot modify the digits of a LargeInteger");
#endif
%}.
    digitByteArray at:index put:aByte
!

digitByteAt:index
    "return 8 bits of my signed value, starting at byte index.
     For positive receivers, this is the same as #digitAt:;
     for negative ones, the actual bit representation is returned."

    |digits|

%{
#ifdef __SCHTEAM__
    return context._RETURN( ((STLargeInteger)self).digitByteAt( index.intValue() ) );
#endif
%}.
    sign >= 0 ifTrue:[
	index > digitByteArray size ifTrue:[
	    ^ 0
	].
	^ digitByteArray at:index.
    ].

    "/ negative int - do 2's complement here
    digits := (self bitInvert + 1) digitBytes.
    index > digits size ifTrue:[
	^ 16rFF
    ].
    ^ digits at:index.

    "
     16r11111111111111111111 negated digitByteAt:1
     0 asLargeInteger digitByteAt:1
     -1 asLargeInteger digitByteAt:1
     -1 digitByteAt:1
    "

    "Created: / 25.10.1998 / 14:12:21 / cg"
!

digitBytes
    "return a byteArray filled with the receiver's bits
     (8 bits of the absolute value per element).
     Least significant byte is first!!"

%{
#ifdef __SCHTEAM__
    return context._RETURN( ((STLargeInteger)self).digitBytes() );
#endif
%}.
    ^ digitByteArray

    "Modified: / 5.5.1999 / 14:57:03 / stefan"
!

digitBytesMSB
    "return a byteArray filled with the receiver's bits
     (8 bits of the absolute value per element),
     most significant byte first"

     ^ digitByteArray copyReverse.
!

digitBytesMSB:msbFlag
    "return a byteArray filled with the receiver's bits
     (8 bits of the absolute value per element),
     if msbflag = true, most significant byte is first,
     otherwise least significant byte is first"

    msbFlag ifTrue:[
	^ digitByteArray copyReverse.
    ].
    ^ digitByteArray

    "Modified: / 5.5.1999 / 14:57:03 / stefan"
!

digitBytesSigned
    "return a byteArray filled with the receiver's bits
     (8 bits of the value (which may be negative) per element).
     Least significant byte is first!!"

    sign > 0 ifTrue:[
	^ digitByteArray
    ].

    "answer the 2's complement"
    ^ (self bitInvert + 1) digitBytes.

    "
	16r12345678901234567890 digitBytesSigned
	-16r12345678901234567890 digitBytesSigned
    "
!

digitLength
    "return the number of bytes needed for the unsigned binary representation of the receiver.
     For negative receivers, the result is not defined by the language standard.
     ST/X returns the digitLength of its absolute value."

    "
     check if there is a 0-byte ...
     this allows to ask unnormalized LargeIntegers
     for their digitLength
    "
    |l "{ Class: SmallInteger }" |

%{
#ifdef __SCHTEAM__
    return context._RETURN( STInteger._new( ((STLargeInteger)self).digitLength() ));
#endif
%}.
    l := digitByteArray size.
    [l ~~ 0 and:[(digitByteArray at:l) == 0]] whileTrue:[
	l := l - 1.
    ].
    ^ l

    "Modified: 31.7.1997 / 13:18:28 / cg"
!

digits
    "obsolete, use #digitBytes"

    <resource:#obsolete>

    ^ digitByteArray
! !

!LargeInteger methodsFor:'coercing & converting'!

asLargeInteger
    "return a LargeInteger with same value as myself - that's me"

    ^ self
!

asSigned32
    "return a 32-bit integer with my bit-pattern. Receiver must be unsigned (i.e. positive).
     May be required for bit operations on the sign-bit and/or to
     convert C/Java numbers."

%{  /* NOCONTEXT */
    int rslt;

    rslt =  (int)(__unsignedLongIntVal(self));
    RETURN ( __MKINT(rslt));
%}.
    self primitiveFailed

    "
     16r80000000 asSigned32
     16r40000000 asSigned32
    "
!

asSmallInteger
    "return a SmallInteger with same value as myself -
     the result is invalid if the receiver's value cannot
     be represented as a SmallInteger.
     Q: should we raise an exception if this happens ?"

    |value|

    value := 0.
    (sign == 0) ifFalse:[
	digitByteArray reverseDo:[:aDigit |
	    value := (value times:256) + aDigit
	].
	(sign < 0) ifTrue:[
	    value := value negated
	]
    ].
    ^ value
!

asUnsigned32
    "return a 32-bit integer with my bit-pattern. Receiver must be unsigned (i.e. positive).
     May be required for bit operations on the sign-bit and/or to
     convert C/Java numbers."

%{  /* NOCONTEXT */
    unsigned int rslt;

    rslt =  (int)(__unsignedLongIntVal(self));
    RETURN ( __MKUINT(rslt));
%}.
    self primitiveFailed

    "
     16r80000000 asUnsigned32
     16r40000000 asUnsigned32
    "
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asLargeInteger
!

compressed
    "if the receiver can be represented as a SmallInteger, return
     a SmallInteger with my value;
     otherwise remove leading zero bytes in the digitByte array
     and return the receiver"

    |index "{ Class: SmallInteger }"
     val   "{ Class: SmallInteger }"
     index0
    |

%{  /* NOCONTEXT */
    OBJ t;

    if (__INST(sign) == __mkSmallInteger(0)) {
	RETURN (__mkSmallInteger(0));
    }

    t = __INST(digitByteArray);
    if (__isByteArray(t)) {
	unsigned char *__digitBytes = __ByteArrayInstPtr(t)->ba_element;
	int _idx, _idx0;
	INT _val;

	_idx = _idx0 = __byteArraySize(t);
	while ((_idx > 0) && (__digitBytes[_idx - 1] == 0)) {
	    _idx--;
	}
#if __POINTER_SIZE__ == 8
	switch (_idx) {
	    case 8:
		_val = __digitBytes[7];
		if (_val <= 0x40) {
		    _val = (_val<<8);
		    _val = (_val + __digitBytes[6]) << 8;
		    _val = (_val + __digitBytes[5]) << 8;
		    _val = (_val + __digitBytes[4]) << 8;
		    _val = (_val + __digitBytes[3]) << 8;
		    _val = (_val + __digitBytes[2]) << 8;
		    _val = (_val + __digitBytes[1]) << 8;
		    _val += __digitBytes[0];
		    if (__INST(sign) == __mkSmallInteger(-1))
			_val = -_val;
		    if (__ISVALIDINTEGER(_val)) {
			RETURN (__mkSmallInteger(_val));
		    }
		}
		break;
	    case 7:
# if defined(__LSBFIRST__)
		_val = ((INT *)__digitBytes)[0] & 0x00FFFFFFFFFFFFFFL;
# else
		_val = (__digitBytes[6]<<8);
		_val = (_val + __digitBytes[5]) << 8;
		_val = (_val + __digitBytes[4]) << 8;
		_val = (_val + __digitBytes[3]) << 8;
		_val = (_val + __digitBytes[2]) << 8;
		_val = (_val + __digitBytes[1]) << 8;
		_val += __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    case 6:
# if defined(__LSBFIRST__)
		_val = ((INT *)__digitBytes)[0] & 0x0000FFFFFFFFFFFFL;
# else
		_val = (__digitBytes[5]<<8);
		_val = (_val + __digitBytes[4]) << 8;
		_val = (_val + __digitBytes[3]) << 8;
		_val = (_val + __digitBytes[2]) << 8;
		_val = (_val + __digitBytes[1]) << 8;
		_val += __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    case 5:
# if defined(__LSBFIRST__)
		_val = ((INT *)__digitBytes)[0] & 0x000000FFFFFFFFFFL;
# else
		_val = (__digitBytes[4]<<8);
		_val = (_val + __digitBytes[3]) << 8;
		_val = (_val + __digitBytes[2]) << 8;
		_val = (_val + __digitBytes[1]) << 8;
		_val += __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    case 4:
# if defined(__LSBFIRST__)
		_val = ((INT *)__digitBytes)[0] & 0x00000000FFFFFFFFL;
# else
		_val = (__digitBytes[3]<<8);
		_val = (_val + __digitBytes[2]) << 8;
		_val = (_val + __digitBytes[1]) << 8;
		_val += __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    case 3:
# if defined(__LSBFIRST__)
		_val = ((int *)__digitBytes)[0] & 0x00FFFFFF;
# else
		_val = (__digitBytes[2]<<8);
		_val = (_val + __digitBytes[1]) << 8;
		_val += __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    case 2:
# if defined(__LSBFIRST__)
		_val = ((int *)__digitBytes)[0] & 0x0000FFFF;
# else
		_val = (__digitBytes[1]<<8) + __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    case 1:
		_val = __digitBytes[0];
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    case 0:
		RETURN (__mkSmallInteger(0));

	}
#else
	if (_idx <= 4) {
	    if (_idx <= 2) {
		if (_idx == 0) {
		    RETURN (__mkSmallInteger(0));
		}
		if (_idx == 1) {
		    _val = __digitBytes[0];
		    if (__INST(sign) == __mkSmallInteger(-1))
			_val = -_val;
		    RETURN (__mkSmallInteger(_val));
		}
# if defined(__LSBFIRST__)
		_val = ((int *)__digitBytes)[0] & 0x0000FFFF;
# else
		_val = (__digitBytes[1]<<8) + __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    }
	    if (_idx == 3) {
# if defined(__LSBFIRST__)
		_val = ((int *)__digitBytes)[0] & 0x00FFFFFF;
# else
		_val = (((__digitBytes[2]<<8) + __digitBytes[1])<<8) + __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		RETURN (__mkSmallInteger(_val));
	    }
	    _val = __digitBytes[3];
	    if (_val <= 0x40) {
# if defined(__LSBFIRST__)
		_val = ((int *)__digitBytes)[0];
# else
		_val = (((((_val<<8) + __digitBytes[2])<<8) + __digitBytes[1])<<8) + __digitBytes[0];
# endif
		if (__INST(sign) == __mkSmallInteger(-1))
		    _val = -_val;
		if (__ISVALIDINTEGER(_val)) {
		    RETURN (__mkSmallInteger(_val));
		}
	    }
	}
#endif

	if (_idx == _idx0) {
	    RETURN (self);
	}

	/*
	 * must copy & cut off some (zero)bytes
	 */
	{
	    OBJ newDigits;
	    OBJ oldDigits;

	    /*
	     * careful - there is no context here to protect
	     * the receiver ...
	     */
	    __PROTECT__(self);
	    __PROTECT__(__INST(digitByteArray));
	    newDigits = __BYTEARRAY_UNINITIALIZED_NEW_INT(_idx);
	    __UNPROTECT__(oldDigits);
	    __UNPROTECT__(self);
	    if (newDigits) {
		bcopy(__ByteArrayInstPtr(oldDigits)->ba_element,
		      __ByteArrayInstPtr(newDigits)->ba_element,
		      _idx);
		__INST(digitByteArray) = newDigits; __STORE(self, newDigits);
		RETURN (self);
	    }
	    /*
	     * allocation failed ...
	     * ... fall through to trigger the error
	     */
	}
    }
%}.
    index0 := index := digitByteArray size.
    [(index > 0) and:[(digitByteArray at:index) == 0]] whileTrue:[
	index := index - 1
    ].
"/    ((index < SmallInteger maxBytes)
"/    or:[(index == SmallInteger maxBytes)
"/            and:[(digitByteArray at:index) < 16r20]])
"/    ifTrue:[
"/        val := 0.
"/        1 to:index do:[:i |
"/            val := val bitShift:8.
"/            val := val bitOr:(digitByteArray at:i).
"/        ].
"/        ^ val * sign
"/    ].
    (index ~~ index0) ifTrue:[
	digitByteArray := digitByteArray copyFrom:1 to:index
    ].
    ^ self
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 40
!

nilAllInstvars
    digitByteArray nilAllInstvars.
    digitByteArray := sign := nil.

    "
      100 factorial nilAllInstvars
    "
!

value:aSmallInteger
    "setup my contents to represent the same value as aSmallInteger.
     This method will fail, if the argument is not a smallInteger.
     This should only be used internally,
     since it will create an unnormalized LargeInt (by purpose) if asked for."

    |absValue
     b1 "{ Class: SmallInteger }"
     b2 "{ Class: SmallInteger }"
     b3 "{ Class: SmallInteger }"
     b4 "{ Class: SmallInteger }"
     b5 "{ Class: SmallInteger }"
     b6 "{ Class: SmallInteger }"
     b7 "{ Class: SmallInteger }"|

    "
     could have simply created a 4-byte largeinteger and normalize it.
     The code below does the normalize right away, avoiding the
     overhead of producing any intermediate byte-arrays (and the scanning)
    "
    (aSmallInteger == 0) ifTrue: [
	digitByteArray := ByteArray with:0.
	sign := 0.
	^ self
    ].

    (aSmallInteger < 0) ifTrue: [
	sign := -1.
	absValue := aSmallInteger negated
    ] ifFalse: [
	sign := 1.
	absValue := aSmallInteger
    ].

    b1 := absValue bitAnd:16rFF.
    absValue := absValue bitShift:-8.
    absValue == 0 ifTrue:[
	digitByteArray := ByteArray with:b1
    ] ifFalse:[
	b2 := absValue bitAnd:16rFF.
	absValue := absValue bitShift:-8.
	absValue == 0 ifTrue:[
	    digitByteArray := ByteArray with:b1 with:b2
	] ifFalse:[
	    b3 := absValue bitAnd:16rFF.
	    absValue := absValue bitShift:-8.
	    absValue == 0 ifTrue:[
		digitByteArray := ByteArray with:b1 with:b2 with:b3
	    ] ifFalse:[
		b4 := absValue bitAnd:16rFF.
		absValue := absValue bitShift:-8.
		absValue == 0 ifTrue:[
		    digitByteArray := ByteArray with:b1 with:b2 with:b3 with:b4
		] ifFalse:[
		    b5 := absValue bitAnd:16rFF.
		    absValue := absValue bitShift:-8.
		    absValue == 0 ifTrue:[
			digitByteArray := ByteArray new:5.
			digitByteArray at:1 put:b1.
			digitByteArray at:2 put:b2.
			digitByteArray at:3 put:b3.
			digitByteArray at:4 put:b4.
			digitByteArray at:5 put:b5.
		    ] ifFalse:[
			b6 := absValue bitAnd:16rFF.
			absValue := absValue bitShift:-8.
			absValue == 0 ifTrue:[
			    digitByteArray := ByteArray new:6.
			    digitByteArray at:1 put:b1.
			    digitByteArray at:2 put:b2.
			    digitByteArray at:3 put:b3.
			    digitByteArray at:4 put:b4.
			    digitByteArray at:5 put:b5.
			    digitByteArray at:6 put:b6.
			] ifFalse:[
			    b7 := absValue bitAnd:16rFF.
			    absValue := absValue bitShift:-8.
			    absValue == 0 ifTrue:[
				digitByteArray := ByteArray new:7.
				digitByteArray at:1 put:b1.
				digitByteArray at:2 put:b2.
				digitByteArray at:3 put:b3.
				digitByteArray at:4 put:b4.
				digitByteArray at:5 put:b5.
				digitByteArray at:6 put:b6.
				digitByteArray at:7 put:b7.
			    ] ifFalse:[
				digitByteArray := ByteArray new:8.
				digitByteArray at:1 put:b1.
				digitByteArray at:2 put:b2.
				digitByteArray at:3 put:b3.
				digitByteArray at:4 put:b4.
				digitByteArray at:5 put:b5.
				digitByteArray at:6 put:b6.
				digitByteArray at:7 put:b7.
				digitByteArray at:8 put:absValue.
			    ]
			]
		    ]
		]
	    ]
	]
    ]

    "Modified: / 26.5.1999 / 22:18:14 / cg"
! !

!LargeInteger methodsFor:'comparing'!

< aNumber
    "return true, if the argument, aNumber is greater than the receiver"

    |otherSign|

    (aNumber class == self class) ifTrue:[
	otherSign := aNumber sign.

	(sign > 0) ifTrue:[
	    "I am positive"
	    (otherSign > 0) ifTrue:[^ self absLess:aNumber].
	    ^ false "aNumber is <= 0"
	].
	"I am negative"
	(otherSign > 0) ifTrue:[^ true].
	(otherSign == 0) ifTrue:[^ true].
	^ (aNumber absLess:self)
    ].
    (aNumber class == SmallInteger) ifTrue:[
	otherSign := aNumber sign.

	(sign > 0) ifTrue:[
	    "I am positive"
	    ^ false "aNumber is <= 0"
	].
	(sign == 0) ifTrue:[
	    (otherSign > 0) ifTrue:[^ true].
	    ^ false
	].
	"I am negative"
	^ true
    ].
    "/ hack for epsilon tests
    (aNumber class == Float) ifTrue:[
	self negative ifTrue:[
	    "/ I am a large negative; so my value is definitely below SmallInteger minVal
	    aNumber >= SmallInteger minVal asFloat ifTrue:[^ true].
	] ifFalse:[
	    "/ I am a large positive; so my value is definitely above SmallInteger maxVal
	    aNumber <= SmallInteger maxVal asFloat ifTrue:[^ false].
	].
    ].

    ^ aNumber lessFromInteger:self

    "Modified: / 31.7.2002 / 10:08:19 / cg"
!

= aNumber
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise"

    "/ speed up compare to 0

    (aNumber == 0) ifTrue:[
	^ sign == 0
    ].

    (aNumber class == self class) ifFalse:[
	"/
	"/ here, we depend on the fact, that largeinteger
	"/ results are always converted to smallInts, if possible.
	"/ therefore, a largeInt in the smallInt range is not allowed (possible)
	"/
	aNumber class == SmallInteger ifTrue:[^ false ].
	^ aNumber equalFromInteger:self
    ].

    (aNumber sign == sign) ifFalse:[^ false].
    ^ digitByteArray = aNumber digitBytes "/ ^ self absEq:aNumber

    "Modified: / 13.2.1998 / 11:43:15 / stefan"
!

> aNumber
    "return true, if the argument, aNumber is less than the receiver"

    |otherSign|

    (aNumber class == self class) ifFalse:[
	^ (aNumber < self)
    ].
    otherSign := aNumber sign.

    (sign > 0) ifTrue:[
	"I am positive"
	(otherSign > 0) ifTrue:[^ aNumber absLess:self].
	^ true "aNumber is <= 0"
    ].
    (sign == 0) ifTrue:[
	"I am zero"
	(otherSign > 0) ifTrue:[^ false].
	^ true
    ].
    "I am negative"
    (otherSign > 0) ifTrue:[^ false].
    (otherSign == 0) ifTrue:[^ false].
    ^ (self absLess:aNumber)

    "Modified: / 31.7.2002 / 10:08:59 / cg"
!

hash
    "return an integer useful for hashing on large numbers"

    |sz h|

    sz := digitByteArray size.
    (sz <= SmallInteger maxBytes and:[self absLess:SmallInteger maxVal]) ifTrue:[
	"I am really an unnormalized SmallInteger, answer the same hash as for the SmallInteger"
	^ self bitAnd:SmallInteger maxVal.
    ].

    h := digitByteArray computeXorHashFrom:1 to:8.                  "/ the low 8 bytes
    sz > 8 ifTrue:[                                                 "/ the high 8 bytes
	h := h bitXor:(digitByteArray computeXorHashFrom:sz-8 to:sz).
    ].
    ^ h

    "
     16r80000000 hash
     16r-80000000 asLargeInteger hash
     16r80000008 hash
     16r8000000000008 hash

     16r8000000000000000 hash
     16r8000000000000008 hash
     16r800000000000000000008 hash
     16r-800000000000000000008 hash
    "
!

hashMultiply
    "used in some squeak code to generate an alternative hash value for integers"

    "Truncate to 28 bits and try again"
    ^(self bitAnd: 16rFFFFFFF) hashMultiply
! !

!LargeInteger methodsFor:'double dispatching'!

differenceFromInteger:anInteger
    "sent, when anInteger does not know how to subtract the receiver.
     Return the result of 'anInteger - self'. The argument must be a SmallInteger."

    anInteger > 0 ifTrue:[
	sign > 0 ifTrue:[
	    ^ self absFastMinus:anInteger sign:-1
	].
	^ self absFastPlus:anInteger sign:1
    ].
    anInteger == 0 ifTrue:[
	^ self negated
    ].
    sign > 0 ifTrue:[
	^ self absFastPlus:anInteger negated sign:-1
    ].

    self > anInteger ifTrue:[
	^ self absFastMinus:anInteger asLargeInteger sign:-1
    ] ifFalse:[
	^ anInteger asLargeInteger absFastMinus:self sign:-1
    ].

    "
     12345678901234567890
     -12345678901234567890
     12345678901234567890 differenceFromInteger:0
     12345678901234567890 differenceFromInteger:1
     12345678901234567890 differenceFromInteger:-1
     -12345678901234567890 differenceFromInteger:1
     -12345678901234567890 differenceFromInteger:-1
    "

    "Modified: 20.10.1996 / 18:41:54 / cg"
!

equalFromInteger:anInteger
    "sent when an integer does not know how to compare to the receiver, a largeInt"

    |otherClass|

    "/
    "/ here, we depend on the fact, that largeinteger
    "/ results are always converted to smallInts, if possible.
    "/ therefore, a largeInt in the smallInt range is not allowed (possible)
    "/
    otherClass := anInteger class.
    otherClass == SmallInteger ifTrue:[^ false ].
    otherClass == self class ifTrue:[
	(anInteger sign == sign) ifFalse:[^ false].
	^ self absEq:anInteger
    ].
    ^ super equalFromInteger:anInteger
!

lessFromInteger:anInteger
    "sent when an integer does not know how to compare to the receiver, a largeInt.
     Return true if anInteger < self"

    "/
    "/ here, we depend on the fact, that largeinteger
    "/ results are always converted to smallInts, if possible.
    "/ therefore, a largeInt in the smallInt range is not allowed (possible)
    "/
    (anInteger class == SmallInteger) ifTrue:[
	(sign > 0) ifTrue:[
	    "I am positive - any largeInteger is larger than any smallInteger"
	    ^ true "anInteger is <= 0"
	].
	"I am negative - any negative largeInteger is smaller than any smallInteger"
	^ false
    ].
    ^ super lessFromInteger:anInteger
!

productFromInteger:anInteger
    "sent, when anInteger does not know how to multiply the receiver.
     Return the product of the receiver and the argument, aSmallInteger"

    |num result
     resultDigitByteArray
     val     "{ Class: SmallInteger }"
     len     "{ Class: SmallInteger }"
     carry   "{ Class: SmallInteger }"
     prod    "{ Class: SmallInteger }"
     ok lResult|

    "multiplying by a small integer is done here"

    "trivial cases"
    anInteger == 0 ifTrue:[^ 0].
    anInteger == 1 ifTrue:[^ self].

    num := anInteger abs.
    SmallInteger maxBytes == 8 ifTrue:[
	(num > 16rFFFFFFFFFF) ifTrue:[
	    "if num is too big (so that multiplying by a byte could create a Large)"
	    ^ anInteger retry:#* coercing:self
	].
    ] ifFalse:[
	(num > 16r3FFFFF) ifTrue:[
	    "if num is too big (so that multiplying by a byte could create a Large)"
	    ^ anInteger retry:#* coercing:self
	].
    ].

    len := digitByteArray size.

    val := num.
    val <= 16rFF ifTrue:[
	lResult := len + 1.
    ] ifFalse:[
	val <= 16rFFFF ifTrue:[
	    lResult := len + 2
	] ifFalse:[
	    val <= 16rFFFFFF ifTrue:[
		lResult := len + 4.
	    ] ifFalse:[
		val <= 16rFFFFFFFF ifTrue:[
		    lResult := len + 6.
		] ifFalse:[
		    val <= 16rFFFFFFFFFF ifTrue:[
			lResult := len + 8.
		    ] ifFalse:[
			val <= 16rFFFFFFFFFF ifTrue:[
			    lResult := len + 10.
			] ifFalse:[
			    val <= 16rFFFFFFFFFFFF ifTrue:[
				lResult := len + 12.
			    ] ifFalse:[
				lResult := len + 14.
			    ]
			]
		    ]
		]
	    ]
	]
    ].
    resultDigitByteArray := ByteArray uninitializedNew:lResult.
    result := self class basicNew setDigits:resultDigitByteArray.

    anInteger < 0 ifTrue:[
	sign > 0 ifTrue:[
	    result setSign:-1
	].
    ] ifFalse:[
	sign < 0 ifTrue:[
	    result setSign:sign
	]
    ].

    ok := false.
%{
    OBJ __digitByteArray = __INST(digitByteArray);

    if (__isSmallInteger(len)
     && __isByteArray(__digitByteArray)
     && __isByteArray(resultDigitByteArray)) {
	INT _l = __intVal(len);
	INT _v = __intVal(val);
	unsigned INT _carry = 0;
	unsigned INT _prod;
	unsigned char *digitP = __ByteArrayInstPtr(__digitByteArray)->ba_element;
	unsigned char *resultP = __ByteArrayInstPtr(resultDigitByteArray)->ba_element;

	/*
	 * skipping zeros does not help much (a few percent) on
	 * a P5 or other CPUS with a fast multiplier.
	 * It may make more of a difference on CPUs with slower 0-multiply.
	 * Late news: it actually hurts modern x86_64 cpus.
	 * So only reenable for specific CPUs after concrete benchmarks.
	 */
#if 0
	while ((_l >= sizeof(INT)) && (((unsigned INT *)digitP)[0] == 0)) {
	    ((unsigned INT *)resultP)[0] = 0;
	    digitP += sizeof(INT);
	    resultP += sizeof(INT);
	    _l -= sizeof(INT);
	}
#endif

#if defined(__LSBFIRST__)
# if defined (__GNUC__) && defined(__i386__) && (__POINTER_SIZE__ == 4)
	/*
	 * can do it long-word-wise;
	 * 32*32 -> 64 multiplication
	 */
	while (_l > 3) {
	    unsigned __pHi, __pLow;
	    unsigned __digit;

	    /*
	     * max: 0xFFFF.FFFF * 0xFFFF.FFFF -> 0xFFFF.FFFE.0000.0001
	     * + maxCarry (0xFFFF.FFFF)  -> 0xFFFF.FFFF.0000.0000
	     */
	    __digit = ((unsigned long *)digitP)[0];
	    asm ("mull %3               \n\
		  addl %4,%%eax         \n\
		  adcl $0,%%edx"
		    : "=a"  (__pLow),
		      "=d"  (__pHi)
		    : "0"   (__digit),
		      "1"   (ASM_ULONGCAST(_v)),
		      "rm"  (ASM_ULONGCAST(_carry)) );

	    ((unsigned long *)resultP)[0] = __pLow;
	    _carry = __pHi;
	    digitP += 4;
	    resultP += 4;
	    _l -= 4;
	}
# else /* not GNU-i386 */
#  if defined(__win32__) && defined(__BORLANDC__) && defined(__x86__) && (__POINTER_SIZE__ == 4)
	/*
	 * can do it long-word-wise;
	 * 32*32 -> 64 multiplication
	 */
	while (_l > 3) {
	    unsigned __pLow;
	    unsigned digit;

	    /*
	     * max: 0xFFFF.FFFF * 0xFFFF.FFFF -> 0xFFFF.FFFE.0000.0001
	     * + maxCarry (0xFFFF.FFFF)  -> 0xFFFF.FFFF.0000.0000
	     */
/*
	    digit = ((unsigned long *)digitP)[0];
	    edx::eax = (digit * _v);
	    edx::eax += _carry;
	    ((unsigned long *)resultP)[0] = eax; -- pLow
	    _carry = edx; -- pHigh
	    digitP += 4;
	    resultP += 4;
*/
	    digit = ((unsigned long *)digitP)[0];
	    asm {
		mov   eax, digit
		mov   edx, _v
		mul   edx
		add   eax, _carry
		adc   edx, 0
		mov   __pLow, eax
		mov   _carry, edx
	    }

	    ((unsigned long *)resultP)[0] = __pLow;
	    digitP += 4;
	    resultP += 4;
	    _l -= 4;
	}
#  else /* not WIN32-i386 */
#   if defined(INT128)
	if (_v <= 0xFFFFFFFFFFFFFFFFL) {
	    /* have 128bit ints; can do it int64-wise
	     *
	     */
	    while (_l >= 8) {
		UINT64 __t1;
		UINT128 _prod128a;

		__t1 = ((UINT64 *)digitP)[0];
		_prod128a = (INT128)_v;
		_prod128a *= __t1;
		_prod128a += _carry;
		((UINT64 *)resultP)[0] = _prod128a;
		_carry = _prod128a >> 64;

		digitP += (8);
		resultP += (8);
		_l -= (8);
	    }
	    while (_l >= 4) {
		unsigned __t;
		UINT128 _prod128;

		__t = ((unsigned *)digitP)[0];
		_prod128 = (INT128)_v;
		_prod128 *= __t;
		_prod128 += _carry;
		((unsigned *)resultP)[0] = _prod128 /* & 0xFFFFFFFFL */;
		_carry = _prod128 >> 32;
		digitP += 4;
		resultP += 4;
		_l -= 4;
	    }
	    if (_l >= 2) {
		unsigned short __t;
		UINT128 _prod128;

		__t = ((unsigned short *)digitP)[0];
		_prod128 = (INT128)_v;
		_prod128 *= __t;
		_prod128 += _carry;
		((unsigned short *)resultP)[0] = _prod128 /* & 0xFFFF */;
		_carry = _prod128 >> 16;
		digitP += 2;
		resultP += 2;
		_l -= 2;
	    }
	    if (_l > 0) {
		UINT128 _prod128;
		_prod128 = *digitP++ * _v + _carry;
		*resultP++ = _prod128 /* & 0xFF */;
		_carry = _prod128 >> 8;
		_l--;
	    }
	}
#   endif

#   if defined(INT64)
	if (_v <= 0xFFFFFFFFL) {
	    /* have 64bit ints; can do it int-wise
	     *
	     * max: 0xFFFFFFFF * 0xFFFFFFFF -> 0xFFFFFFFE.0001
	     * + maxCarry (0xFFFFFFFF)  -> 0xFFFFFFFF.0000
	     */
	    while (_l >= (4+4+4+4)) {
		unsigned __t1, __t2, __t3, __t4;
		UINT64 _prod64a, _prod64b, _prod64c, _prod64d;

		__t1 = ((unsigned *)digitP)[0];
		_prod64a = (INT64)_v;
		_prod64a *= __t1;
		_prod64a += _carry;
		((unsigned *)resultP)[0] = _prod64a /* & 0xFFFFFFFFL */;
		_carry = _prod64a >> 32;

		__t2 = ((unsigned *)digitP)[1];
		_prod64b = (INT64)_v;
		_prod64b *= __t2;
		_prod64b += _carry;
		((unsigned *)resultP)[1] = _prod64b /* & 0xFFFFFFFFL */;
		_carry = _prod64b >> 32;

		__t3 = ((unsigned *)digitP)[2];
		_prod64c = (INT64)_v;
		_prod64c *= __t3;
		_prod64c += _carry;
		((unsigned *)resultP)[2] = _prod64c /* & 0xFFFFFFFFL */;
		_carry = _prod64c >> 32;

		__t4 = ((unsigned *)digitP)[3];
		_prod64d = (INT64)_v;
		_prod64d *= __t4;
		_prod64d += _carry;
		((unsigned *)resultP)[3] = _prod64d /* & 0xFFFFFFFFL */;
		_carry = _prod64d >> 32;

		digitP += (4+4+4+4);
		resultP += (4+4+4+4);
		_l -= (4+4+4+4);
	    }
	    while (_l >= 4) {
		unsigned __t;
		UINT64 _prod64;

		__t = ((unsigned *)digitP)[0];
		_prod64 = (INT64)_v;
		_prod64 *= __t;
		_prod64 += _carry;
		((unsigned *)resultP)[0] = _prod64 /* & 0xFFFFFFFFL */;
		_carry = _prod64 >> 32;
		digitP += 4;
		resultP += 4;
		_l -= 4;
	    }
	    if (_l >= 2) {
		unsigned short __t;
		UINT64 _prod64;

		__t = ((unsigned short *)digitP)[0];
		_prod64 = (INT64)_v;
		_prod64 *= __t;
		_prod64 += _carry;
		((unsigned short *)resultP)[0] = _prod64 /* & 0xFFFF */;
		_carry = _prod64 >> 16;
		digitP += 2;
		resultP += 2;
		_l -= 2;
	    }
	    if (_l > 0) {
		UINT64 _prod64;
		_prod64 = *digitP++ * _v + _carry;
		*resultP++ = _prod64 /* & 0xFF */;
		_carry = _prod64 >> 8;
		_l--;
	    }
	}
#   else /* no INT64 type */
	if (_v <= 0xFFFF) {
	    /* can do it short-wise
	     *
	     * max: 0xFFFF * 0xFFFF -> 0xFFFE.0001
	     * + maxCarry (0xFFFF)  -> 0xFFFF.0000
	     */
	    while (_l > 1) {
		_prod = ((unsigned short *)digitP)[0] * _v + _carry;
		((unsigned short *)resultP)[0] = _prod /* & 0xFFFF */;
		_carry = _prod >> 16;
		digitP += 2;
		resultP += 2;
		_l -= 2;
	    }
	}
#   endif /* no INT64 */
#  endif /* not WIN32-i386 */
# endif /* not GNU-i386 */
#else /* not LSB_FIRST */

# ifdef __mips__
#  define LOAD_WORD_WISE
   /* no, STORE_WORD_WISE makes it slower */
# endif

	if (_v <= 0xFFFF) {
	    /* can do it short-wise
	     *
	     * max: 0xFFFF * 0xFFFF -> 0xFFFE.0001
	     * + maxCarry (0xFFFF)  -> 0xFFFF.0000
	     */
	    while (_l > 1) {
		unsigned int t;

#if defined(LOAD_WORD_WISE)
		/* better fetch short-wise */
		t = ((unsigned short *)digitP)[0];
		digitP += 2;
		t = ((t >> 8) | (t << 8)) & 0xFFFF;
#else
		t = (digitP[1]<<8) + digitP[0];
		digitP += 2;
#endif
		_prod = t * _v + _carry;
		_carry = _prod >> 16;
#if defined(STORE_WORD_WISE)
		/* better store short-wise */
		_prod = ((_prod >> 8) | (_prod << 8)) & 0xFFFF;
		((unsigned short *)resultP)[0] = _prod;
#else
		resultP[0] = _prod /* & 0xFF */;
		resultP[1] = (_prod>>8) /* & 0xFF */;
#endif
		resultP += 2;
		_l -= 2;
	    }
	}

#endif /* LSB_FIRST */

	/*
	 * rest is done byte-wise
	 */
	while (_l > 0) {
	    _prod = *digitP++ * _v + _carry;
	    *resultP++ = _prod /* & 0xFF */;
	    _carry = _prod >> 8;
	    _l--;
	}

	_l = __intVal(lResult) - __intVal(len);

	/*
	 * remaining carry
	 */
	while (_carry) {
	    *resultP++ = _carry /* & 0xFF */;
	    _carry >>= 8;
	    _l--;
	}

	/*
	 * remaining zeros
	 */
	while (_l--) {
	    *resultP++ = 0;
	}

	/*
	 * need compress ?
	 */
	if (resultP[-1]) {
	    /*
	     * no
	     */
	    RETURN(result);
	}

	ok = true;
    }
%}.
    "
     fall back - normally not reached
     (could make it a primitive-failure as well)
    "
    ok ifFalse:[
	carry := 0.
	1 to:len do:[:i |
	    prod := (digitByteArray basicAt:i) * val + carry.
	    resultDigitByteArray basicAt:i put:(prod bitAnd:16rFF).
	    carry := prod bitShift:-8.
	].
	[carry ~~ 0] whileTrue:[
	    len := len + 1.
	    resultDigitByteArray basicAt:len put:(carry bitAnd:16rFF).
	    carry := carry bitShift:-8
	].
	[len < lResult] whileTrue:[
	    len := len + 1.
	    resultDigitByteArray basicAt:len put:0
	]
    ].
    ^ result compressed
!

sumFromInteger:anInteger
    "sent, when anInteger does not know how to add the receiver.
     Return the sum of the receiver and the argument, (which must be a SmallInteger)"

    anInteger > 0 ifTrue:[
	sign > 0 ifTrue:[
	    ^ self absFastPlus:anInteger sign:1
	].
	^ self absFastMinus:anInteger sign:-1
    ].
    anInteger == 0 ifTrue:[
	^ self
    ].
    sign > 0 ifTrue:[
	^ self absFastMinus:anInteger sign:1
    ].
    ^ self absFastPlus:anInteger sign:-1


    "
     12345678901234567890
     -12345678901234567890
     12345678901234567890 sumFromInteger:0
     -12345678901234567890 sumFromInteger:0
     12345678901234567890 sumFromInteger:1
     12345678901234567890 sumFromInteger:-1
     -12345678901234567890 sumFromInteger:1
     -12345678901234567890 sumFromInteger:-1
    "

    "Modified: / 9.1.1998 / 13:27:37 / cg"
! !

!LargeInteger methodsFor:'modulo arithmetic'!

plus32:aNumber
    "return the sum of the receiver and the argument, as SmallInteger.
     The argument must be another SmallInteger.
     If the result overflows the 32 bit range, the value modulo 16rFFFFFFFF is returned.
     This is of course not always correct, but allows for C/Java behavior to be emulated."

%{  /* NOCONTEXT */
    INT sum;

    sum =  __unsignedLongIntVal(self) + __unsignedLongIntVal(aNumber);
#if __POINTER_SIZE__ == 8
    sum &= 0xFFFFFFFFL;
#endif
    RETURN ( __MKUINT(sum));
%}.
    self primitiveFailed

    "
     16r7FFFFFFF + 1       ->  2147483648
     16r7FFFFFFF plus32: 1 ->  -2147483648
    "
! !

!LargeInteger methodsFor:'printing & storing'!

xxxstoreOn:aStream
    "append a representation of the receiver to aStream, which can
     be used to reconstruct the receiver."

    aStream nextPutAll:'('.
    self printOn:aStream.
    aStream nextPutAll:' asLargeInteger)'
! !

!LargeInteger methodsFor:'private'!

absDestructiveSubtract:aLargeInteger
    "private helper for division:
	destructively subtract aLargeInteger from myself
	AND return true, if the result is non-zero, false otherwise.
	(i.e. this method has both a return value and a side-effect on the receiver)
	Does not care about the signs of the receiver and argument
	The receiver must be >= the argument.
	The receiver must be a temporary scratch-number"

    |otherDigitByteArray
     len1   "{ Class: SmallInteger }"
     len2   "{ Class: SmallInteger }"
     index  "{ Class: SmallInteger }"
     borrow "{ Class: SmallInteger }"
     diff   "{ Class: SmallInteger }"
     notZero
    |

    notZero := false.
    len1 := digitByteArray size.
    otherDigitByteArray := aLargeInteger digitBytes.
    len2 := otherDigitByteArray size.
    len2 > len1 ifTrue:[
	[(otherDigitByteArray at:len2) == 0] whileTrue:[
	    len2 := len2 - 1
	].
	len2 > len1 ifTrue:[
	    self error:'operation failed' "/ may not be called that way
	].
    ].
    "/ knowing that len2 is <= len1
%{

    OBJ _digitByteArray = __INST(digitByteArray);

    if (__isByteArray(_digitByteArray)
     && __isByteArray(otherDigitByteArray)) {
	int _len1 = __intVal(len1),
	    _len2 = __intVal(len2);
	unsigned char *_myDigits, *_otherDigits;
	int _index = 1, _borrow = 0;
	INT _diff;
	int anyBitNonZero = 0;

	_otherDigits = __ByteArrayInstPtr(otherDigitByteArray)->ba_element;
	_myDigits = __ByteArrayInstPtr(_digitByteArray)->ba_element;

#if defined(__LSBFIRST__)
# if __POINTER_SIZE__ == 8
	{
	    int _len2Q;
	    /*
	     * subtract int-wise
	     */
	    _len2Q = _len2-4;
	    while (_index <= _len2Q) {
		/* do not combine the expression below (may lead to unsigned result on some machines) */
		_diff = ((unsigned int *)(_myDigits+_index-1))[0];
		_diff -= ((unsigned int *)(_otherDigits+_index-1))[0];
		_diff -= _borrow;
		if (_diff >= 0) {
		    _borrow = 0;
		} else {
		    _borrow = 1;
		    /* _diff += 0x100000000; */
		}
		((unsigned int *)(_myDigits+_index-1))[0] = _diff;
		anyBitNonZero |= (_diff & 0xFFFFFFFFL);
		_index += 4;
	    }
	}
# endif

	/*
	 * subtract short-wise
	 */
	while (_index < _len2) {
	    /* do not combine the expression below (may lead to unsigned result on some machines */
	    _diff = ((unsigned short *)(_myDigits+_index-1))[0];
	    _diff -= ((unsigned short *)(_otherDigits+_index-1))[0];
	    _diff -= _borrow;
	    if (_diff >= 0) {
		_borrow = 0;
	    } else {
		_borrow = 1;
		/* _diff += 0x10000; */
	    }
	    ((unsigned short *)(_myDigits+_index-1))[0] = _diff;
	    anyBitNonZero |= (_diff & 0xFFFF);
	    _index += 2;
	}

	if (_index <= _len2) {
	    /*
	     * cannot continue with shorts - there is an odd number of
	     * bytes in the minuent
	     */
	} else {
	    while (_index < _len1) {
		/* do not combine the expression below (may lead to unsigned result on some machines */
		_diff = ((unsigned short *)(_myDigits+_index-1))[0];
		_diff -= _borrow;
		if (_diff >= 0) {
		    /* _borrow = 0; */
		    ((unsigned short *)(_myDigits+_index-1))[0] = _diff;
		    anyBitNonZero |= (_diff & 0xFFFF);
		    _index += 2;
		    while (_index < _len1) {
			anyBitNonZero |= ((unsigned short *)(_myDigits+_index-1))[0];
			if (anyBitNonZero) {
			    RETURN (true);
			}
			_index += 2;
		    }
		    /* last odd index */
		    if (_index <= _len1) {
			anyBitNonZero |= _myDigits[_index - 1];;
			if (anyBitNonZero) {
			    RETURN (true);
			}
			_index++;
		    }
		    RETURN (anyBitNonZero ? true : false);
		}
		_borrow = 1;
		/* _diff += 0x10000; */

		((unsigned short *)(_myDigits+_index-1))[0] = _diff;
		anyBitNonZero |= (_diff & 0xFFFF);
		_index += 2;
	    }
	}
#endif
	/*
	 * subtract byte-wise
	 */
	while (_index <= _len2) {
	    /* do not combine the expression below (may lead to unsigned result on some machines */
	    _diff = _myDigits[_index - 1];
	    _diff -= _otherDigits[_index - 1];
	    _diff -= _borrow;
	    if (_diff >= 0) {
		_borrow = 0;
	    } else {
		_borrow = 1;
		/* _diff += 0x100; */
	    }
	    _myDigits[_index - 1] = _diff;
	    anyBitNonZero |= (_diff & 0xFF);
	    _index++;
	}

	while (_index <= _len1) {
	    /* do not combine the expression below (may lead to unsigned result on some machines */
	    _diff = _myDigits[_index - 1];
	    _diff -= _borrow;
	    if (_diff >= 0) {
		/* _borrow = 0; */
		_myDigits[_index - 1] = _diff;
		anyBitNonZero |= (_diff & 0xFF);
		_index++;
		while (_index <= _len1) {
		    anyBitNonZero |= _myDigits[_index - 1];
		    if (anyBitNonZero) {
			RETURN (true);
		    }
		    _index++;
		}
		break;
	    }
	    _borrow = 1;
	    /* _diff += 0x100; */

	    _myDigits[_index - 1] = _diff;
	    anyBitNonZero |= (_diff & 0xFF);
	    _index++;
	}
	RETURN (anyBitNonZero ? true : false);
    }
%}.

    index := 1.
    borrow := 0.

    [index <= len1] whileTrue:[
	diff := borrow.
	diff := diff + (digitByteArray basicAt:index).
	index <= len2 ifTrue:[
	    diff := diff - (otherDigitByteArray basicAt:index).
	].

	"/ workaround for gcc code generator bug
	(diff >= 0) ifTrue:[
	    borrow := 0
	] ifFalse:[
	    borrow := -1.
	    diff := diff + 16r100
	].
	diff ~~ 0 ifTrue:[
	    notZero := true
	].
	digitByteArray basicAt:index put:diff.
	index := index + 1
    ].

    ^ notZero

    "Created: / 5.11.1996 / 16:23:47 / cg"
    "Modified: / 5.11.1996 / 18:56:50 / cg"
    "Modified: / 27.4.1999 / 18:08:23 / stefan"
!

absDivMod:anInteger
    "return an array with two LargeIntegers representing
     abs(self) // abs(theArgument) and abs(self) \\ abs(theArgument).
     Used as a helper for \\, //, rem: and quo:.
     This method needs a rewrite."

    |dividend divisor
     quo digits
     divModOrNil
     shift "{ Class: SmallInteger }" |

    anInteger == 0 ifTrue:[
	^ ZeroDivide raiseRequestWith:thisContext
    ].

    anInteger class == SmallInteger ifTrue:[
	divisor := anInteger abs.
	divModOrNil := self absFastDivMod:divisor.
	divModOrNil notNil ifTrue:[^ divModOrNil].
	divisor := divisor asLargeInteger.
    ] ifFalse:[
	self = anInteger ifTrue:[
	    ^ Array with:1 with:0
	].
	divisor := anInteger.
    ].

    shift := self highBit - divisor highBit.
    dividend := self class digitBytes:digitByteArray copy. "/ self simpleDeepCopy sign:1.
    shift < 0 ifTrue:[
	^ Array with:0 with:dividend compressed.
    ].
    shift == 0 ifTrue:[
	divisor := self class digitBytes:(divisor digitBytes copy). "/ anInteger simpleDeepCopy.
    ] ifFalse:[
	divisor := divisor bitShift:shift.
    ].

    quo := self class basicNew numberOfDigits:((shift // 8) + 1).
    digits := quo digitBytes.

    shift := shift + 1.
    [shift > 0] whileTrue:[
	(dividend absLess:divisor) ifFalse:[
	    digits bitSetAt:shift.
	    (dividend absDestructiveSubtract: divisor) ifFalse:[ "result == 0"
		^ Array with:quo compressed with:0
	    ].
	].
	shift := shift - 1.
	divisor := divisor div2.
    ].
    ^ Array with:quo compressed with:dividend compressed

    "
     Time millisecondsToRun:[ 10000 timesRepeat:[  16000000000 absDivMod:4000000000] ]
     Time millisecondsToRun:[ 10000 timesRepeat:[  16000000000 absDivMod:3000000000] ]
     16000000000 absDivMod:4000000000
     16000000000 absDivMod:3000000000
     160000000000000000000000 absDivMod:160000000000000000000000
    "

    "Modified: / 5.11.1996 / 18:40:24 / cg"
    "Created: / 27.4.1999 / 19:45:44 / stefan"
    "Modified: / 26.7.1999 / 10:46:36 / stefan"
!

absEq:aLargeInteger
    "return true, if abs(self) = abs(theArgument)"

    |len1 "{ Class: SmallInteger }"
     len2 "{ Class: SmallInteger }"
     d1   "{ Class: SmallInteger }"
     d2   "{ Class: SmallInteger }"
     otherDigitByteArray |

%{  /* NOCONTEXT */
    if (__isLargeInteger(aLargeInteger)) {
	OBJ _digitByteArray = __INST(digitByteArray);
	OBJ _otherDigitByteArray = __LargeIntegerInstPtr(aLargeInteger)->l_digits;

	if (__isByteArray(_digitByteArray)
	 && __isByteArray(_otherDigitByteArray)) {
	    INT _myLen = __byteArraySize(_digitByteArray);
	    INT _otherLen = __byteArraySize(_otherDigitByteArray);

	    unsigned char *_otherDigits = __ByteArrayInstPtr(_otherDigitByteArray)->ba_element;
	    unsigned char *_myDigits = __ByteArrayInstPtr(_digitByteArray)->ba_element;

	    if (_myLen == _otherLen) {
tryAgain:
		while (_myLen >= (sizeof(INT)*4)) {
		    if ( ((unsigned INT *)_myDigits)[0] != ((unsigned INT *)_otherDigits)[0]) {
			RETURN(false);
		    }
		    if ( ((unsigned INT *)_myDigits)[1] != ((unsigned INT *)_otherDigits)[1]) {
			RETURN(false);
		    }
		    if ( ((unsigned INT *)_myDigits)[2] != ((unsigned INT *)_otherDigits)[2]) {
			RETURN(false);
		    }
		    if ( ((unsigned INT *)_myDigits)[3] != ((unsigned INT *)_otherDigits)[3]) {
			RETURN(false);
		    }
		    _myDigits += sizeof(INT)*4;
		    _otherDigits += sizeof(INT)*4;
		    _myLen -= sizeof(INT)*4;
		}
		while (_myLen >= (sizeof(INT))) {
		    if ( *(unsigned INT *)_myDigits != *(unsigned INT *)_otherDigits) {
			RETURN(false);
		    }
		    _myDigits += sizeof(INT);
		    _otherDigits += sizeof(INT);
		    _myLen -= sizeof(INT);
		}
		while (_myLen > 0) {
		    if ( *_myDigits != *_otherDigits) {
			RETURN(false);
		    }
		    _myDigits++;
		    _otherDigits++;
		    _myLen--;
		}
		RETURN(true);
	    }
	    /* care for unnormalized ints */
	    while ((_myLen > 0) && (_myDigits[_myLen-1] == 0)) _myLen--;
	    while ((_otherLen > 0) && (_otherDigits[_otherLen-1] == 0)) _otherLen--;
	    if (_myLen == _otherLen) goto tryAgain;
	    RETURN(false);
	}
    }
%}.

    len1 := digitByteArray size.
    otherDigitByteArray := aLargeInteger digitBytes.
    len2 := otherDigitByteArray size.

    "/ the highest digit(s) should not be zero
    "/ when properly normalized;
    "/ but we are tolerant here, to allow for unnormalized
    "/ numbers to be compared ...

    [(digitByteArray basicAt:len1) == 0] whileTrue:[
	len1 := len1 - 1
    ].
    [(otherDigitByteArray basicAt:len2) == 0] whileTrue:[
	len2 := len2 - 1
    ].
    (len1 ~~ len2) ifTrue:[^ false].
    [len1 > 0] whileTrue:[
	d1 := digitByteArray basicAt:len1.
	d2 := otherDigitByteArray basicAt:len1.
	(d1 ~~ d2) ifTrue:[^ false].
	len1 := len1 - 1
    ].
    ^ true

    "Modified: / 8.5.1999 / 18:37:02 / cg"
!

absFastDivMod:aPositiveSmallInteger
    "return an array with two LargeIntegers representing
	abs(self) // aPositiveSmallInteger and
	abs(self) \\ aPositiveSmallInteger
     or nil, if not computed by optimized code"

    |tmp1     "{ Class: SmallInteger }"
     prevRest "{ Class: SmallInteger }"
     count    "{ Class: SmallInteger }"
     newDigitByteArray result
     ok|

    aPositiveSmallInteger == 0 ifTrue:[
	^ ZeroDivide raiseRequestWith:thisContext
    ].

"This cannot happen (if always normalized)
    self < aPositiveSmallInteger ifTrue:[
	^ Array with:0 with:self
    ].
"
    count := digitByteArray size.
    result := self class basicNew numberOfDigits:count.
    newDigitByteArray := result digitBytes.
    ok := false.
%{
    OBJ __digits;

    __digits = __INST(digitByteArray);

    if (__isByteArray(__digits)
     && __isByteArray(newDigitByteArray)
     && __bothSmallInteger(count, aPositiveSmallInteger)) {
	unsigned INT rest = 0;
	int index = __intVal(count);
	int index0;
	unsigned INT divisor = __intVal(aPositiveSmallInteger);
	unsigned char *digitBytes = __ByteArrayInstPtr(__digits)->ba_element;
	unsigned char *resultBytes = __ByteArrayInstPtr(newDigitByteArray)->ba_element;

	index0 = index - 1;

	// at least one byte of value must remain when dividing
# if (__POINTER_SIZE__ == 8)
	if (divisor > 0xFFFFFFFFFFFFFF) RETURN(nil);
# else
	if (divisor > 0xFFFFFF) RETURN(nil);
# endif

# if (__POINTER_SIZE__ == 8)
	if (sizeof(int) == 4) {
	    /*
	     * divide int-wise
	     */
	    if (divisor <= 0xFFFFFFFF) {
		if ((index & 3) == 0) { /* even number of int32's */
		    while (index > 3) {
			unsigned INT t;
			unsigned INT div;

			index -= 4;
# if defined(__LSBFIRST__)
			t = *((unsigned int *)(&digitBytes[index]));
# else
			t = digitBytes[index+3];
			t = (t << 8) | digitBytes[index+2];
			t = (t << 8) | digitBytes[index+1];
			t = (t << 8) | digitBytes[index];
# endif
			t = t | (rest << 32);
			div = t / divisor;
			rest = t % divisor;
# if defined(__LSBFIRST__)
			*((unsigned int *)(&resultBytes[index])) = (div & 0xFFFFFFFF);
# else
			resultBytes[index+3] = div >> 24;
			resultBytes[index+2] = div >> 16;
			resultBytes[index+1] = div >> 8;
			resultBytes[index] = div /* & 0xFF */;
# endif
		    }
		}
	    }
	}
#endif
	/*
	 * divide short-wise
	 */
	if (divisor <= 0xFFFF) {
	    if ((index & 1) == 0) { /* even number of bytes */
		while (index > 1) {
		    unsigned INT t;
		    unsigned INT div;

		    index -= 2;
#if defined(__LSBFIRST__)
		    t = *((unsigned short *)(&digitBytes[index]));
#else
		    t = digitBytes[index+1];
		    t = (t << 8) | digitBytes[index];
#endif
		    t = t | (rest << 16);
		    div = t / divisor;
		    rest = t % divisor;
#if defined(__LSBFIRST__)
		    *((unsigned short *)(&resultBytes[index])) = (div & 0xFFFF);
#else
		    resultBytes[index+1] = div >> 8;
		    resultBytes[index] = div /* & 0xFF */;
#endif
		}
	    }
	}
	while (index > 0) {
	    unsigned INT t;

	    index--;
	    t = digitBytes[index];
	    t = t | (rest << 8);
	    resultBytes[index] = t / divisor;
	    rest = t % divisor;
	}
	prevRest = __mkSmallInteger(rest);

	/*
	 * no need to normalize ?
	 */
	index = index0;
	while ((index >= sizeof(INT)) && (resultBytes[index]==0)) {
	    index--;
	}

	if (index == index0) {
	    if (index > sizeof(INT)) {
		RETURN ( __ARRAY_WITH2(result, prevRest));
	    }
	    if ((index == sizeof(INT))
	     && resultBytes[index0] >= 0x40) {
		RETURN ( __ARRAY_WITH2(result, prevRest));
	    }
	}

	/*
	 * must compress
	 */
	ok = true;
    }
%}.
    "
     slow code - not normally reached
     (could also do a primitiveFailure here)
    "
    ok ifTrue:[
	^ Array with:(result compressed) with:prevRest
    ].
    ^ nil


    "
     16r123412341234 asLargeInteger absDivMod:(LargeInteger value:10)
     ((16r1234 asLargeInteger absFastDivMod:16rffff) at:2) printStringRadix:16
     ((16r00123456 asLargeInteger absFastDivMod:16rffffff) at:2) printStringRadix:16
     ((666666666666666666 asLargeInteger absFastDivMod:16r3))
     ((1666666666 asLargeInteger absFastDivMod:16r3))
    "

    "Modified: / 26-02-2016 / 19:27:13 / cg"
!

absFastMinus:aSmallInteger sign:newSign
    "return a LargeInteger representing abs(self) - abs(theArgument)
     with sign: newSign.
     The result is normalized.
     This is a helper for addition and subtraction - not for public use."

    |result resultDigitByteArray lastDigit ok
     len     "{ Class: SmallInteger }"
     rsltLen "{ Class: SmallInteger }"
     index   "{ Class: SmallInteger }"
     borrow  "{ Class: SmallInteger }"
     diff    "{ Class: SmallInteger }" |

    "/ the following code only works with
    "/ smallIntegers in the range _MIN_INT+255 .. _MAX_INT-255

    ((aSmallInteger < (SmallInteger minVal + 255))
    or:[aSmallInteger > (SmallInteger maxVal - 255)]) ifTrue:[
	^ self absMinus:(self class value:aSmallInteger) sign:newSign.
    ].

    len := digitByteArray size.

    rsltLen := len "+ 1".
    result := self class basicNew numberOfDigits:rsltLen sign:newSign.
    resultDigitByteArray := result digitBytes.

    borrow := aSmallInteger abs.

%{
    if (__isByteArray(__INST(digitByteArray))
     && __isByteArray(resultDigitByteArray)) {
	unsigned INT __borrow = __intVal(borrow);
	INT __diff;
	int __index = 1;
	int __len = __intVal(len);
	unsigned char *__digitP = __ByteArrayInstPtr(__INST(digitByteArray))->ba_element;
	unsigned char *__resultP = __ByteArrayInstPtr(resultDigitByteArray)->ba_element;
	int __len3;

#if defined(__LSBFIRST__)
# if (__POINTER_SIZE__ == 8)
	/*
	 * subtract int-wise
	 */
	__len3 = __len - 3;
	while (__index < __len3) {
	    /* do not make this into one expression - ask cg why */
	    __diff = ((unsigned int *)(__digitP + __index-1))[0];
	    __diff -= (__borrow & 0xFFFFFFFFL);
	    __borrow >>= 32;
	    ((unsigned int *)(__resultP+__index-1))[0] = __diff;
	    __index += 4;
	    if (__diff < 0) {
		/* __diff += 0x100000000; */
		__borrow++;
	    } else {
		if (__borrow == 0) {
		    /* nothing more to subtract .. */
		    while (__index < __len3) {
			((unsigned int *)(__resultP+__index-1))[0] = ((unsigned int *)(__digitP+__index-1))[0];
			__index += 4;
		    }
		    if (__index < __len) {
			((unsigned short *)(__resultP+__index-1))[0] = ((unsigned short *)(__digitP+__index-1))[0];
			__index += 2;
		    }
		    if (__index <= __len) {
			__resultP[__index-1] = __digitP[__index-1];
		    }
		    break;
		}
	    }
	}
# endif
	/*
	 * subtract short-wise
	 */
	while (__index < __len) {
	    /* do not make this into one expression - ask cg why */
	    __diff = ((unsigned short *)(__digitP+__index-1))[0];
	    __diff -= (__borrow & 0xFFFF);
	    __borrow >>= 16;
	    ((unsigned short *)(__resultP+__index-1))[0] = __diff;
	    __index += 2;
	    if (__diff < 0) {
		/* __diff += 0x10000; */
		__borrow++;
	    } else {
		if (__borrow == 0) {
		    /* nothing more to subtract .. */
		    while (__index < __len) {
			((unsigned short *)(__resultP+__index-1))[0] = ((unsigned short *)(__digitP+__index-1))[0];
			__index += 2;
		    }
		    if (__index <= __len) {
			__resultP[__index-1] = __digitP[__index-1];
		    }
		    break;
		}
	    }
	}
#endif
	/*
	 * subtract byte-wise
	 */
	while (__index <= __len) {
	    __diff = __digitP[__index-1];
	    __diff -= (__borrow & 0xFF);
	    __borrow >>= 8;
	    __resultP[__index-1] = __diff;
	    __index++;
	    if (__diff < 0) {
		/* __diff += 0x100; */
		__borrow++;
	    } else {
		if (__borrow == 0) {
		    /* nothing more to subtract .. */
		    while (__index <= __len) {
			__resultP[__index-1] = __digitP[__index-1];
			__index++;
		    }
		    break;
		}
	    }
	}
	lastDigit = __mkSmallInteger( __resultP[__index-1-1] );
	ok = true;
    }
%}.

    ok == true ifFalse:[        "/ cannot happen
	index := 1.
	[borrow ~~ 0] whileTrue:[
	    (index <= len) ifTrue:[
		diff := (digitByteArray basicAt:index) - (borrow bitAnd:16rFF).
		borrow := borrow bitShift:-8.
		diff < 0 ifTrue:[
		    diff := diff + 256.
		    borrow := borrow + 1.
		]
	    ] ifFalse:[
		diff := borrow bitAnd:255.
		borrow := borrow bitShift:-8.
	    ].
	    resultDigitByteArray basicAt:index put:(lastDigit := diff).
	    index := index + 1
	].
	[index <= len] whileTrue:[
	    resultDigitByteArray basicAt:index put:(lastDigit := digitByteArray basicAt:index).
	    index := index + 1
	].
	(index <= rsltLen) ifTrue:[
	    lastDigit := 0.
	]
    ].

    (lastDigit == 0 or:[rsltLen <= SmallInteger maxBytes]) ifTrue:[
	^ result compressed.
    ].
    ^ result

    "
     12345678900000000000 absFastMinus:1 sign:1
     12345678900000000000 absFastMinus:1 sign:-1
     12345678900000000000 absFastMinus:1000000 sign:1
     12345678900000000000 absFastMinus:255 sign:1
     (SmallInteger maxVal + 1) absFastMinus:1 sign:1
     (SmallInteger minVal - 1) absFastMinus:1 sign:1
    "

    "Modified: 24.3.1997 / 21:33:25 / cg"
!

absFastPlus:aSmallInteger sign:newSign
    "return a LargeInteger representing abs(self) + abs(theArgument).
     with sign: newSign.
     The result is normalized. The argument must be a smallInteger
     with byteSize one less than the integer byteSize.
     This is a helper for addition and subtraction - not for public use."

    |result resultDigitByteArray lastDigit
     ok
     len     "{ Class: SmallInteger }"
     rsltLen "{ Class: SmallInteger }"
     index "{ Class: SmallInteger }"
     carry "{ Class: SmallInteger }" |

    "/ the following code only works with
    "/ smallIntegers in the range _MIN_INT+255 .. _MAX_INT-255

    ((aSmallInteger < (SmallInteger minVal + 255))
    or:[aSmallInteger > (SmallInteger maxVal - 255)]) ifTrue:[
	^ self absPlus:(self class value:aSmallInteger) sign:newSign.
    ].

    len := rsltLen := digitByteArray size.
    "/
    "/ there can only be an overflow from the high byte,
    "/ if it is 255 (since the other number is definitely smaller)
    "/
    (digitByteArray at:len) == 16rFF ifTrue:[
	rsltLen := len + 1.
    ] ifFalse:[
	"/ or the argument has something in the high byte ..
%{
#if __POINTER_SIZE__ == 8
	if (__intVal(aSmallInteger) & 0xFF00000000000000L) {
	    rsltLen = __mkSmallInteger(__intVal(len) + 1);
	}
#else
	if (__intVal(aSmallInteger) & 0xFF000000) {
	    rsltLen = __mkSmallInteger(__intVal(len) + 1);
	}
#endif
%}
    ].

    result := self class basicNew numberOfDigits:rsltLen sign:newSign.
    resultDigitByteArray := result digitBytes.

%{
    if (__isByteArray(__INST(digitByteArray))
     && __isByteArray(resultDigitByteArray)
     && __isSmallInteger(aSmallInteger)) {
	/* carry is NOT unsigned (see negation below) */
	INT __carry = __intVal(aSmallInteger);
	int __index = 1;
	int __len = __intVal(len);
	unsigned char *__src = (unsigned char *)(__ByteArrayInstPtr(__INST(digitByteArray))->ba_element);
	unsigned char *__dst = (unsigned char *)(__ByteArrayInstPtr(resultDigitByteArray)->ba_element);
	INT __ptrDelta = __dst - __src;
	unsigned char *__srcLast = __src + __len - 1;
	int __rsltLen = __intVal(rsltLen);

	if (__carry < 0) {
	    __carry = -__carry;
	}

#if defined(__LSBFIRST__)
# if defined(__i386__) && defined(__GNUC__) && (__POINTER_SIZE__ == 4)
#  if 0 /* NOTICE - the code below is 20% slower ... - why */
	/*
	 * add long-wise
	 */
	asm("  jecxz nothingToDo                                      \n\
	       movl  %%eax, %%esi      /* __src input */              \n\
	       movl  %%ebx, %%edi      /* __dst input */              \n\
								      \n\
	       /* the first 4-byte int */                             \n\
	       lodsl                   /* fetch */                    \n\
	       addl  %%edx, %%eax      /* add */                      \n\
	       stosl                   /* store */                    \n\
	       leal  -1(%%ecx),%%ecx   /* do not clobber carry */     \n\
	       jecxz doneLoop          /* any more ? */               \n\
	       /* remaining 4-byte ints */                            \n\
	       jmp   addLoop                                          \n\
								      \n\
	       .align 8                                               \n\
	     addLoop:                                                 \n\
	       movl  0(%%esi), %%ebx   /* fetch  */                   \n\
	       jnc   copyLoop2                                        \n\
	       movl  $0, %%eax                                        \n\
	       leal  4(%%esi), %%esi                                  \n\
	       adcl  %%ebx, %%eax      /* & add carry from prev int */\n\
	       leal  8(%%edi), %%edi                                  \n\
	       movl  %%eax, -8(%%edi)  /* store */                    \n\
	       leal  -1(%%ecx),%%ecx   /* do not clobber carry */     \n\
	       jecxz doneLoop          /* any more ? */               \n\
								      \n\
	       movl  0(%%esi), %%ebx   /* fetch  */                   \n\
	       movl  $0, %%eax                                        \n\
	       leal  4(%%esi), %%esi                                  \
	       adcl  %%ebx, %%eax      /* & add carry from prev int */\n\
	       movl  %%eax, -4(%%edi)  /* store */                    \n\
								      \n\
	       loop  addLoop                                          \n\
	       jmp   doneLoop                                         \n\
								      \n\
	       .align 8                                               \n\
	     copyLoop:                                                \n\
	       movl  0(%%esi), %%ebx                                  \n\
	     copyLoop2:                                               \n\
	       add   $4, %%esi                                        \n\
	       add   $4, %%edi                                        \n\
	       movl  %%ebx, -4(%%edi)                                 \n\
	       loop  copyLoop                                         \n\
								      \n\
	     doneLoop:                                                \n\
	       movl  $0, %%edx         /* do not clobber carry (xorl clears it) */   \n\
	       adcl  $0, %%edx                                        \n\
	       movl  %%esi, %%eax      /* __src output */             \n\
	     nothingToDo:                                             \n\
	    " : "=d"  (ASM_ULONGCAST(__carry)),
		"=a"  (__src)
	      : "1"   (__src),
		"b"   (__dst),
		"c"   (__len / 4),
		"0"   (__carry)
	      : "esi", "edi");

#  else
	{
	    unsigned char *__srcLastX;

	    __srcLastX = __srcLast - 3 - 4;
	    while (__src <= __srcLastX) {
		unsigned int __sum, __sum2;
		unsigned __digit1, __digit2;

		__digit1 = ((unsigned *)__src)[0];
		__digit2 = ((unsigned *)__src)[1];
		asm ("addl %%edx,%%ecx          \n\
		      adcl $0, %%eax            \n\
		      movl $0, %%edx            \n\
		      adcl $0, %%edx"
			: "=d"  (ASM_ULONGCAST(__carry)),
			  "=c"  (ASM_ULONGCAST(__sum)),
			  "=a"  (ASM_ULONGCAST(__sum2))
			: "0"   (ASM_ULONGCAST(__carry)),
			  "1"   (__digit1),
			  "2"   (__digit2));

		((unsigned int *)(__src + __ptrDelta))[0] = __sum;
		((unsigned int *)(__src + __ptrDelta))[1] = __sum2;

		__src += 8;

		if (__carry == 0) {
		    while (__src <= __srcLastX) {
			/* copy over words */
			((unsigned int *)(__src + __ptrDelta))[0] = ((unsigned int *)__src)[0];
			((unsigned int *)(__src + __ptrDelta))[1] = ((unsigned int *)__src)[1];
			__src += 8;
		    }
		    while (__src <= __srcLast) {
			/* copy over bytes */
			__src[__ptrDelta] = __src[0];
			__src ++;
		    }
		    goto doneSource;
		}
	    }

	    __srcLastX = __srcLastX + 4;
	    if (__src <= __srcLastX) {
		unsigned int __sum, __digit;

		__digit = ((unsigned *)__src)[0];

		asm ("addl %%eax,%%edx  \n\
		      movl $0,%%eax     \n\
		      adcl $0,%%eax"
			: "=a"  (ASM_ULONGCAST(__carry)),
			  "=d"  (ASM_ULONGCAST(__sum))
			: "0"   (ASM_ULONGCAST(__carry)),
			  "1"   (__digit) );

		((unsigned int *)(__src + __ptrDelta))[0] = __sum;
		__src += 4;

		if (__carry == 0) {
		    while (__src <= __srcLast) {
			/* copy over bytes */
			__src[__ptrDelta] = __src[0];
			__src ++;
		    }
		    goto doneSource;
		}
	    }
	}
#  endif
# else /* not i386-GNUC */
#  if defined(__win32__) && defined(__BORLANDC__) && defined(__x86__) && (__POINTER_SIZE__ == 4)
	{
	    unsigned char *__srcLast4;

	    /*
	     * add long-wise
	     */
	    __srcLast4 = __srcLast - 3;
	    while (__src <= __srcLast4) {
		unsigned int __sum;

		__sum = ((unsigned int *)__src)[0];
		asm {
		      mov eax, __sum
		      add eax, __carry
		      mov edx, 0
		      adc edx, 0
		      mov __sum, eax
		      mov __carry, edx
		    }

		((unsigned int *)(__src + __ptrDelta))[0] = __sum;
		__src += 4;
		if (__carry == 0) {
		    while (__src <= __srcLast4) {
			/* copy over words */
			((unsigned int *)(__src + __ptrDelta))[0] = ((unsigned int *)__src)[0];
			__src += 4;
		    }
		    while (__src <= __srcLast) {
			/* copy over bytes */
			__src[__ptrDelta] = __src[0];
			__src ++;
		    }
		    goto doneSource;
		}
	    }
	}
#  else /* not i386-WIN32 */
#   if defined(__LSBFIRST__) && (__POINTER_SIZE__ == 8)
	{
	    unsigned char *__srcLast4;

	    /*
	     * add long-wise
	     */
	    __srcLast4 = __srcLast - 3;
	    while (__src <= __srcLast4) {
		unsigned INT __sum;

		__sum = (INT)(((unsigned int *)__src)[0]);
		__sum += __carry;
		((unsigned int *)(__src + __ptrDelta))[0] = __sum /* & 0xFFFF */;
		__src += 4;
		__carry = __sum >> 32;
		if (__carry == 0) {
		    while (__src <= __srcLast4) {
			/* copy over words */
			((unsigned int *)(__src + __ptrDelta))[0] = ((unsigned int *)__src)[0];
			__src += 4;
		    }
		    while (__src <= __srcLast) {
			/* copy over bytes */
			__src[__ptrDelta] = __src[0];
			__src ++;
		    }
		    goto doneSource;
		}
	    }
	}
#   endif /* LSB+64bit */
#  endif /* __i386__ & WIN32 */
# endif /* __i386__ & GNUC */

	/*
	 * add short-wise
	 */
	while (__src < __srcLast) {
	    __carry += ((unsigned short *)__src)[0];
	    ((unsigned short *)(__src + __ptrDelta))[0] = __carry /* & 0xFFFF */;
	    __carry >>= 16;
	    __src += 2;
	}
	/*
	 * last (odd) byte
	 */
	if (__src <= __srcLast) {
	    __carry += __src[0];
	    __src[__ptrDelta] = __carry /* & 0xFF */;
	    __carry >>= 8;
	    __src++;
	}
#else /* not __LSBFIRST__ */

	/*
	 * add byte-wise
	 */
	while (__src <= __srcLast) {
	    __carry += __src[0];
	    __src[__ptrDelta] = __carry /* & 0xFF */;
	    __src++;
	    __carry >>= 8;

	    if (__carry == 0) {
		while (__src <= __srcLast) {
		    /* copy over rest */
		    __src[__ptrDelta] = __src[0];
		    __src++;
		}
		goto doneSource;
	    }
	}
#endif /* __LSBFIRST__ */

    doneSource: ;
	/*
	 * now, at most one other byte is to be stored ...
	 */
	if (__len < __rsltLen) {
	    __src[__ptrDelta] = __carry /* & 0xFF */;
	    __src++;
	}

	if (__src[__ptrDelta-1] != 0) {      /* lastDigit */
	    RETURN (result);
	}
	// must compress
	ok = true;
    }
%}.

    ok ~~ true ifTrue:[
	index := 1.
	carry := aSmallInteger abs.

	[carry ~~ 0] whileTrue:[
	    (index <= len) ifTrue:[
		carry := (digitByteArray basicAt:index) + carry.
	    ].
	    resultDigitByteArray basicAt:index put:(lastDigit := carry bitAnd:16rFF).
	    carry := carry bitShift:-8.
	    index := index + 1
	].

	(index <= rsltLen) ifTrue:[
	    [index <= len] whileTrue:[
		resultDigitByteArray basicAt:index put:(digitByteArray basicAt:index).
		index := index + 1
	    ].
	    lastDigit := 0.
	].

	(lastDigit ~~ 0 and:[rsltLen > SmallInteger maxBytes]) ifTrue:[
	    ^ result
	].
    ].

    ^ result compressed

    "Modified: 24.3.1997 / 21:32:41 / cg"
!

absLess:aLargeInteger
    "return true, if abs(self) < abs(theArgument).
     This handles unnormalized largeIntegers."

    |myLen "{ Class: SmallInteger }"
     otherLen "{ Class: SmallInteger }"
     d1   "{ Class: SmallInteger }"
     d2   "{ Class: SmallInteger }"
     otherDigitByteArray |

%{  /* NOCONTEXT */
#if defined(__LSBFIRST__)
    if (__isByteArray(__INST(digitByteArray))
     && __isLargeInteger(aLargeInteger)) {
	OBJ _otherDigitByteArray = __LargeIntegerInstPtr(aLargeInteger)->l_digits;

	if (__isByteArray(_otherDigitByteArray)) {
	    unsigned char *_myDigits = __ByteArrayInstPtr(__INST(digitByteArray))->ba_element;
	    unsigned char *_otherDigits = __ByteArrayInstPtr(_otherDigitByteArray)->ba_element;
	    INT _myLen = __byteArraySize(__INST(digitByteArray));
	    INT _otherLen = __byteArraySize(_otherDigitByteArray);

	    if (_myLen == __POINTER_SIZE__) {
		if (_otherLen == __POINTER_SIZE__) {
		    unsigned INT _myVal = *((unsigned INT *)_myDigits);
		    unsigned INT _otherVal = *((unsigned INT *)_otherDigits);
		    RETURN( (_myVal < _otherVal) ? true : false );
		}
	    }
# if defined(UINT64) && (__POINTER_SIZE__ != 8)
	    if (_myLen == __POINTER_SIZE__) {
		if (_otherLen <= 8) {
		    UINT64 _myVal = (UINT64)(*((UINT *)_myDigits));
		    UINT64 _otherVal = *((UINT64 *)_otherDigits);
		    RETURN( (_myVal < _otherVal) ? true : false );
		}
	    } else {
		if (_myLen <= 8) {
		    if (_otherLen <= 8) {
			UINT64 _myVal = (*((UINT64 *)_myDigits));
			UINT64 _otherVal = *((UINT64 *)_otherDigits);
			RETURN( (_myVal < _otherVal) ? true : false );
		    }
		    if (_otherLen == __POINTER_SIZE__) {
			UINT64 _myVal = (*((UINT64 *)_myDigits));
			UINT64 _otherVal = (UINT64) *((UINT *)_otherDigits);
			RETURN( (_myVal < _otherVal) ? true : false );
		    }
		}
	    }
# endif /* UINT64 */
	    while ((_myLen > 0) && (_myDigits[_myLen-1] == 0)) _myLen--;
	    while ((_otherLen > 0) && (_otherDigits[_otherLen-1] == 0)) _otherLen--;
	    if (_myLen < _otherLen) { RETURN( true ); }
	    if (_myLen > _otherLen) { RETURN (false ); }
	    while (_myLen-- > 0) {
		unsigned char _d1 = _myDigits[_myLen];
		unsigned char _d2 = _otherDigits[_myLen];

		if (_d1 != _d2) {
		    if (_d1 < _d2) { RETURN( true ); }
		    RETURN (false );
		}
	    }
	    RETURN (false );
	}
    }
#endif /* LSBFIRST */
%}.

    myLen := digitByteArray size.
    otherDigitByteArray := aLargeInteger digitBytes.
    otherLen := otherDigitByteArray size.

    "/ the highest digit(s) should not be zero
    "/ when properly normalized;
    "/ but we are tolerant here, to allow for unnormalized
    "/ numbers to be compared ...

    [myLen > 0 and:[(digitByteArray basicAt:myLen) == 0]] whileTrue:[
	myLen := myLen - 1
    ].
    [otherLen > 0 and:[(otherDigitByteArray basicAt:otherLen) == 0]] whileTrue:[
	otherLen := otherLen - 1
    ].
    (myLen < otherLen) ifTrue:[^ true].
    (myLen > otherLen) ifTrue:[^ false].

    [myLen > 0] whileTrue:[
	d1 := digitByteArray basicAt:myLen.
	d2 := otherDigitByteArray basicAt:myLen.
	d1 == d2 ifFalse:[
	    (d1 < d2) ifTrue:[^ true].
	    ^ false
	].
	myLen := myLen - 1
    ].
    ^ false

    "
     |a b|

     a := 16rFEFFFFFF.
     b := 16rFFFFFFFF.
     Time millisecondsToRun:[
       10000000 timesRepeat:[ a absLess_old:b ]
     ]    1185 1233 1185

     |a b|

     a := 16rFEFFFFFF.
     b := 16rFFFFFFFF.
     Time millisecondsToRun:[
       10000000 timesRepeat:[ a absLess_n:b ]
     ] 686 655 702 702

     16rEFFFFFFF  absLess_n: 16rFFFFFFFF
     16rEFFFFFFF  absLess: 16rFFFFFFFF
    "

    "Modified: / 3.5.1999 / 08:06:28 / stefan"
    "Modified: / 8.5.1999 / 18:37:11 / cg"
!

absLessEq:aLargeInteger
    "return true, if abs(self) <= abs(theArgument).
     This handles unnormalized largeIntegers."

    |myLen "{ Class: SmallInteger }"
     otherLen "{ Class: SmallInteger }"
     d1   "{ Class: SmallInteger }"
     d2   "{ Class: SmallInteger }"
     otherDigitByteArray |

%{  /* NOCONTEXT */
#if defined(__LSBFIRST__)
    if (__isByteArray(__INST(digitByteArray))
     && __isLargeInteger(aLargeInteger)) {
	OBJ _otherDigitByteArray = __LargeIntegerInstPtr(aLargeInteger)->l_digits;

	if (__isByteArray(_otherDigitByteArray)) {
	    unsigned char *_myDigits = __ByteArrayInstPtr(__INST(digitByteArray))->ba_element;
	    unsigned char *_otherDigits = __ByteArrayInstPtr(_otherDigitByteArray)->ba_element;
	    INT _myLen = __byteArraySize(__INST(digitByteArray));

	    if (_myLen == __POINTER_SIZE__) {
		INT _otherLen = __byteArraySize(_otherDigitByteArray);

		if (_otherLen == __POINTER_SIZE__) {
		    unsigned INT _myVal = *((unsigned INT *)_myDigits);
		    unsigned INT _otherVal = *((unsigned INT *)_otherDigits);
		    RETURN( (_myVal <= _otherVal) ? true : false );
		}
	    }
# if defined(UINT64) && (__POINTER_SIZE__ != 8)
	    if (_myLen == __POINTER_SIZE__) {
		INT _otherLen = __byteArraySize(_otherDigitByteArray);

		if (_otherLen <= 8) {
		    UINT64 _myVal = (UINT64)(*((UINT *)_myDigits));
		    UINT64 _otherVal = *((UINT64 *)_otherDigits);
		    RETURN( (_myVal <= _otherVal) ? true : false );
		}
	    } else {
		if (_myLen <= 8) {
		    INT _otherLen = __byteArraySize(_otherDigitByteArray);

		    if (_otherLen <= 8) {
			UINT64 _myVal = (*((UINT64 *)_myDigits));
			UINT64 _otherVal = *((UINT64 *)_otherDigits);
			RETURN( (_myVal <= _otherVal) ? true : false );
		    }
		    if (_otherLen == __POINTER_SIZE__) {
			UINT64 _myVal = (*((UINT64 *)_myDigits));
			UINT64 _otherVal = (UINT64) *((UINT *)_otherDigits);
			RETURN( (_myVal <= _otherVal) ? true : false );
		    }
		}
	    }
# endif /* UINT64 */
	}
    }
#endif /* LSBFIRST */
%}.

    myLen := digitByteArray size.
    otherDigitByteArray := aLargeInteger digitBytes.
    otherLen := otherDigitByteArray size.

    "/ the highest digit(s) should not be zero
    "/ when properly normalized;
    "/ but we are tolerant here, to allow for unnormalized
    "/ numbers to be compared ...

    [(digitByteArray basicAt:myLen) == 0] whileTrue:[
	myLen := myLen - 1
    ].
    [(otherDigitByteArray basicAt:otherLen) == 0] whileTrue:[
	otherLen := otherLen - 1
    ].
    (myLen < otherLen) ifTrue:[^ true].
    (myLen > otherLen) ifTrue:[^ false].

    [myLen > 0] whileTrue:[
	d1 := digitByteArray basicAt:myLen.
	d2 := otherDigitByteArray basicAt:myLen.
	d1 == d2 ifFalse:[
	    (d1 < d2) ifTrue:[^ true].
	    ^ false.
	].
	myLen := myLen - 1
    ].
    ^ true

    "Created: / 13.2.1998 / 12:19:45 / stefan"
    "Modified: / 30.4.1999 / 12:46:31 / stefan"
    "Modified: / 8.5.1999 / 18:37:15 / cg"
!

absMinus:aLargeInteger sign:newSign
    "return a LargeInteger representing abs(self) - abs(theArgument)
     with sign: newSign.
     The result is normalized. The argument must be a largeInteger
     with a byteSize smaller than the receiver's byteSize.
     This is a helper for addition and subtraction - not for public use."

    |result done
     otherDigitByteArray resultDigitByteArray
     len1   "{ Class: SmallInteger }"
     len2   "{ Class: SmallInteger }"
     index  "{ Class: SmallInteger }"
     borrow "{ Class: SmallInteger }"
     diff   "{ Class: SmallInteger }"
     carry  "{ Class: SmallInteger }"
     lastDigit
     lResult ok|

    len1 := digitByteArray size.
    otherDigitByteArray := aLargeInteger digitBytes.
    len2 := otherDigitByteArray size.

    len1 > len2 ifTrue:[
	lResult := len1
    ] ifFalse:[
	lResult := (len1 max: len2) + 1.
    ].
    result := self class basicNew numberOfDigits:lResult sign:newSign.
    resultDigitByteArray := result digitBytes.

    lastDigit := 0.

%{
    OBJ _digitByteArray = __INST(digitByteArray);

    if (__isByteArray(_digitByteArray)
     && __isByteArray(otherDigitByteArray)
     && __isByteArray(resultDigitByteArray)) {
	int __len1 = __intVal(len1);
	int __len2 = __intVal(len2);
	int __minLen = __len1 < __len2 ? __len1 : __len2;
	int __index, __borrow = 0;
	INT __diff;
	unsigned char *__myDigits, *__otherDigits, *__resultDigits;

	ok = true;

	__resultDigits = __ByteArrayInstPtr(resultDigitByteArray)->ba_element;
	__otherDigits = __ByteArrayInstPtr(otherDigitByteArray)->ba_element;
	__myDigits = __ByteArrayInstPtr(_digitByteArray)->ba_element;

	__index = 1;

#if defined(__LSBFIRST__)
# if __POINTER_SIZE__ == 8
	/*
	 * subtract int-wise
	 */
	while ((__index+3) <= __minLen) {
	    /* do not make this into one expression - ask cg why */
	    __diff = ((unsigned int *)(__myDigits+__index-1))[0];
	    __diff -= ((unsigned int *)(__otherDigits+__index-1))[0];
	    __diff -= __borrow;

	    if (__diff >= 0) {
		__borrow = 0;
	    } else {
		__borrow = 1;
		/* __diff += 0x10000; */
	    }
	    ((unsigned int *)(__resultDigits+__index-1))[0] = __diff;
	    __index += 4;
	}
# endif /* 64bit */

	/*
	 * subtract short-wise
	 */
	while (__index < __minLen) {   /* i.e. index+1 <= minLen */
	    /* do not make this into one expression - ask cg why */
	    __diff = ((unsigned short *)(__myDigits+__index-1))[0];
	    __diff -= ((unsigned short *)(__otherDigits+__index-1))[0];
	    __diff -= __borrow;
	    if (__diff >= 0) {
		__borrow = 0;
	    } else {
		__borrow = 1;
		/* __diff += 0x10000; */
	    }
	    ((unsigned short *)(__resultDigits+__index-1))[0] = __diff;
	    __index += 2;
	}

	if (__index == __minLen) {
	    /* one of the operands has odd length - cannot continue short-wise */
	} else {
	    if (__len1 > __len2) {
		while (__index < __len1) {
		    /* do not make this into one expression - ask cg why */
		    __diff = ((unsigned short *)(__myDigits+__index-1))[0];
		    __diff -= __borrow;
		    if (__diff >= 0) {
			__borrow = 0;
			((unsigned short *)(__resultDigits+__index-1))[0] = __diff;
			__index += 2;

			/* copy over rest */
			while (__index < __len1) {
			    ((unsigned short *)(__resultDigits+__index-1))[0] = ((unsigned short *)(__myDigits+__index-1))[0];
			    __index+=2;
			}
			if (__index <= __len1) {
			    __resultDigits[__index-1] = __myDigits[__index-1];
			    __index++;
			}
			break;
		    }
		    __borrow = 1;
		    /* __diff += 0x10000; */
		    ((unsigned short *)(__resultDigits+__index-1))[0] = __diff;
		    __index += 2;
		}
	    } else {
		if (__len2 > __len1) {
		    while (__index < __len2) {
			/* do not make this into one expression - ask cg why */
			__diff = 0;
			__diff -= ((unsigned short *)(__otherDigits+__index-1))[0];
			__diff -= __borrow;
			if (__diff >= 0) {
			    __borrow = 0;
			} else {
			    __borrow = 1;
			    /* __diff += 0x10000; */
			}
			((unsigned short *)(__resultDigits+__index-1))[0] = __diff;
			__index += 2;
		    }
		}
	    }
	}
#endif
	/*
	 * subtract byte-wise
	 */
	while (__index <= __minLen) {
	    /* do not make this into one expression - ask cg why */
	    __diff = __myDigits[__index-1];
	    __diff -= __otherDigits[__index-1];
	    __diff -= __borrow;
	    if (__diff >= 0) {
		__borrow = 0;
	    } else {
		__borrow = 1;
		/* __diff += 0x100; */
	    }
	    __resultDigits[__index-1] = __diff;
	    __index++;
	}

	if (__len1 > __len2) {
	    while (__index <= __len1) {
		/* do not make this into one expression - ask cg why */
		__diff = __myDigits[__index-1];
		__diff -= __borrow;
		if (__diff >= 0) {
		    __borrow = 0;
		    /* copy over rest */
		    __resultDigits[__index-1] = __diff;
		    __index++;
		    while (__index <= __len1) {
			__resultDigits[__index-1] = __myDigits[__index-1];
			__index++;
		    }
		    break;
		}
		__borrow = 1;
		/* __diff += 0x100; */
		__resultDigits[__index-1] = __diff;
		__index++;
	    }
	} else {
	    if (__len2 > __len1) {
		while (__index <= __len2) {
		    /* do not make this into one expression - ask cg why */
		    __diff = 0;
		    __diff -= __otherDigits[__index-1];
		    __diff -= __borrow;
		    if (__diff >= 0) {
			__borrow = 0;
		    } else {
			__borrow = 1;
			/* __diff += 0x100; */
		    }
		    __resultDigits[__index-1] = __diff;
		    __index++;
		}
	    }
	}
	borrow = __mkSmallInteger(__borrow);
	index = __mkSmallInteger(__index);
	lastDigit = __mkSmallInteger(__resultDigits[__intVal(lResult)-1]);
    }
%}.
    ok == true ifFalse:[
	index := 1.
	borrow := 0.

	done := false.
	[done] whileFalse:[
	    diff := borrow.
	    (index <= len1) ifTrue:[
		diff := diff + (digitByteArray basicAt:index).
		(index <= len2) ifTrue:[
		    diff := diff - (otherDigitByteArray basicAt:index)
		]
	    ] ifFalse:[
		(index <= len2) ifTrue:[
		    diff := diff - (otherDigitByteArray basicAt:index)
		] ifFalse:[
		    "end reached"
		    done := true
		]
	    ].

	    "/ workaround for
	    "/ gcc code generator bug

	    (diff >= 0) ifTrue:[
		borrow := 0
	    ] ifFalse:[
		borrow := -1.
		diff := diff + 16r100
	    ].

    "/        (diff < 0) ifTrue:[
    "/            borrow := -1.
    "/            diff := diff + 16r100
    "/        ] ifFalse:[
    "/            borrow := 0
    "/        ].

	    resultDigitByteArray basicAt:index put:diff.
	    index := index + 1
	].
	lastDigit := resultDigitByteArray basicAt:lResult.
    ].

    (borrow ~~ 0) ifTrue:[
	"/ must generate 255's complement

	result sign:newSign negated.
	[index <= lResult] whileTrue:[
	    resultDigitByteArray basicAt:index put:16rFF.
	    index := index + 1.
	].
	index := lResult.
	[index > 0] whileTrue:[
	    resultDigitByteArray basicAt:index put:(255 - (resultDigitByteArray at:index)).
	    index := index - 1.
	].

	index := 1.
	carry := 1.
	[carry ~~ 0] whileTrue:[
	    (index <= lResult) ifTrue:[
		carry := (resultDigitByteArray basicAt:index) + carry.
	    ].
	    resultDigitByteArray basicAt:index put:(carry bitAnd:16rFF).
	    carry := carry bitShift:-8.
	    index := index + 1
	].
	lastDigit := resultDigitByteArray basicAt:lResult.
    ].
    (lastDigit == 0 or:[lResult <= SmallInteger maxBytes]) ifTrue:[
	^ result compressed.
    ].
    ^ result

    "Modified: 5.11.1996 / 14:09:25 / cg"
!

absMod:anInteger
    "return a LargeIntegers representing
     abs(self) \\ abs(theArgument).
     Used as a helper for \\ and rem:"


    |dividend divisor
     shift "{ Class: SmallInteger }" |

    anInteger == 0 ifTrue:[
	^ ZeroDivide raiseRequestWith:thisContext
    ].

    self = anInteger ifTrue:[
	^ 0
    ].

    shift := self highBit - anInteger highBit.
    dividend := self class digitBytes:digitByteArray copy. "/ self simpleDeepCopy sign:1.
    shift < 0 ifTrue:[
	^ dividend compressed.
    ].
    shift == 0 ifTrue:[
	divisor := LargeInteger digitBytes:(anInteger digitBytes copy). "/ anInteger simpleDeepCopy
    ] ifFalse:[
	divisor := anInteger bitShift:shift.
    ].


    shift := shift + 1.
    [shift > 0] whileTrue:[
	(dividend absLess:divisor) ifFalse:[
	    (dividend absDestructiveSubtract: divisor) ifFalse:[ "result == 0"
		^ 0
	    ].
	].
	shift := shift - 1.
	divisor div2.
    ].

    ^ dividend compressed

    "
Time millisecondsToRun:[   10000 timesRepeat:[  16000000001 absMod:4000000001] ]
Time millisecondsToRun:[   10000 timesRepeat:[  16000000001 absDivMod:4000000001] ]
     16000000000 absMod:4000000000
     16000000000 absMod:3000000000
     16000000000000000000 absMod:16000000000000000000
    "

    "Modified: / 5.11.1996 / 18:40:24 / cg"
    "Created: / 27.4.1999 / 19:45:44 / stefan"
    "Modified: / 26.7.1999 / 10:46:18 / stefan"
!

absMul:aLargeInteger
    "return a LargeInteger representing abs(self) * abs(theArgument)"

    |result otherDigitByteArray resultDigitByteArray ok
     idx      "{ Class: SmallInteger }"
     carry    "{ Class: SmallInteger }"
     len1     "{ Class: SmallInteger }"
     len2     "{ Class: SmallInteger }"
     lenRslt  "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     prod     "{ Class: SmallInteger }"
     v        "{ Class: SmallInteger }"|

    len1 := digitByteArray size.
    otherDigitByteArray := aLargeInteger digitBytes.
    len2 := otherDigitByteArray size.
    lenRslt := len1 + len2.
    UseKarazuba ~~ false ifTrue:[
	lenRslt > 400 ifTrue:[ ^ self absMulKarazuba:aLargeInteger ].
    ].

    result := self class basicNew numberOfDigits:lenRslt.
    resultDigitByteArray := result digitBytes.
    ok := false.
%{
    if (__isByteArray(__INST(digitByteArray))
     && __isByteArray(otherDigitByteArray)
     && __isByteArray(resultDigitByteArray)) {
	unsigned char *myBytes = __ByteArrayInstPtr(__INST(digitByteArray))->ba_element;
	unsigned char *otherBytes = __ByteArrayInstPtr(otherDigitByteArray)->ba_element;
	unsigned char *resultBytes = __ByteArrayInstPtr(resultDigitByteArray)->ba_element;
	unsigned char *_p1, *_pResult0, *_p1Last, *_p2Last;
	unsigned INT _v;
	int _len1 = __intVal(len1);
	int _len2 = __intVal(len2);

	_p1Last = myBytes    + _len1 - 1;  /* the last byte */
	_p2Last = otherBytes + _len2 - 1;  /* the last byte */
	_pResult0 = resultBytes;

	/*
	 *         aaa...aaa      f1[0] * f2
	 * +      bbb...bbb       f1[1] * f2
	 * +     ccc...ccc        f1[2] * f2
	 * +    ...
	 * +   xxx...xxx          f1[high] * f2
	 *
	 * start short-wise
	 * bounds: (16rFFFF * 16rFFFF) + 16rFFFF -> FFFF0000
	 */
	_p1 = myBytes;

#if defined(__LSBFIRST__) && (__POINTER_SIZE__ == 8)
	/* loop over ints of f1 */
	for (; _p1 <= (_p1Last-3); _p1 += 4, _pResult0 += 4) {
	    unsigned char *_pResult = _pResult0;
	    unsigned char *_p2;
	    unsigned INT word1 = ((unsigned int *)_p1)[0];

	    _v = 0;

	    /* loop over ints of f2 */
	    for (_p2 = otherBytes; _p2 <= (_p2Last-3); _p2 += 4) {
		_v = word1 * (unsigned INT)(((unsigned int *)_p2)[0])
		     + _v + (unsigned INT)((unsigned int *)_pResult)[0];
		((unsigned int *)_pResult)[0] = _v /* & 0xFFFFFFFF */;
		_v >>= 32; /* now _v contains the carry*/
		_pResult += 4;
	    }

	    /* possible odd up to 3 highBytes of f2 */
	    for ( ; _p2 <= _p2Last; _p2++) {
		_v = word1 * (unsigned INT)(_p2[0])
		     + _v + (unsigned INT)(_pResult[0]);

		((unsigned char *)_pResult)[0] = _v /* & 0xFFFFFFFF */;
		_v >>= 8; /* now _v contains the carry*/
		_pResult++;
	    }
	    /* distribute leftover carry byte-wise */
	    for ( ; _v; _v >>= 8, _pResult++) {
		_v += _pResult[0];
		_pResult[0] = _v /* & 0xFF */;
	    }
	}
#endif /* 64bit */

	/* possible odd high short of f1 (or shortLoop, if not 64bit) */

	for (; _p1 < _p1Last; _p1 += 2, _pResult0 += 2) {
	    unsigned char *_pResult = _pResult0;
	    unsigned char *_p2 = otherBytes;
	    unsigned int short1 = ((unsigned short *)_p1)[0];

#if !defined(__LSBFIRST__)
	    short1 = ((short1 >> 8) & 0xFF) | ((short1 & 0xFF) << 8);
#endif
	    _v = 0;

	    /* loop over shorts of f2 */
	    for ( ; _p2 < _p2Last; _p2 += 2, _pResult += 2) {
#if !defined(__LSBFIRST__)
		unsigned int _short2  = ((unsigned short *)_p2)[0];
		unsigned int _short3  = ((unsigned short *)_pResult)[0];

		_short2 = ((_short2 >> 8) /* & 0xFF */) | ((_short2 & 0xFF) << 8);
		_short3 = ((_short3 >> 8) /* & 0xFF */) | ((_short3 & 0xFF) << 8);
		_v = (short1 * _short2) + _short3 + _v;
		_pResult[0] = _v;
		_pResult[1] = _v >> 8;
#else /* __LSBFIRST__ */
		_v = (short1 * ((unsigned short *)_p2)[0]) + _v + ((unsigned short *)_pResult)[0];
		((unsigned short *)_pResult)[0] = _v /* & 0xFFFF */;
#endif /* __LSBFIRST__ */
		_v >>= 16; /* now _v contains the carry*/
	    }

	    /* possible odd highByte of f2 */
	    for ( ; _p2 <= _p2Last; _p2++, _pResult += 2) {
#if !defined(__LSBFIRST__)
		unsigned int _short3 = ((unsigned short *)_pResult)[0];

		_short3 = ((_short3 >> 8) /* & 0xFF */) | ((_short3 & 0xFF) << 8);
		_v = (short1 * _p2[0]) + _v + _short3;
		_pResult[0] = _v;
		_pResult[1] = _v >> 8;
#else /* __LSBFIRST__ */
		_v = (short1 * _p2[0]) + _v + ((unsigned short *)_pResult)[0];
		((unsigned short *)_pResult)[0] = _v /* & 0xFFFF */;
#endif /* __LSBFIRST__ */
		_v >>= 16; /* now _v contains the carry*/
	    }
	    /* distribute leftover carry byte-wise */
	    for ( ; _v; _v >>= 8, _pResult++) {
		_v += _pResult[0];
		_pResult[0] = _v /* & 0xFF */;
	    }
	}

	/* possible odd highByte of f1 (or byteLoop, if above is ever disabled) */
	for (; _p1 <= _p1Last; _p1++, _pResult0++) {
	    unsigned char *_pResult = _pResult0;
	    unsigned char *_p2 = otherBytes;
	    unsigned int byte1 = _p1[0];

	    _v = 0;

	    /* loop over shorts of f2 */
	    for ( ; _p2 < _p2Last; _p2 += 2, _pResult += 2) {
#if !defined(__LSBFIRST__)
		unsigned int _short2 = ((unsigned short *)_p2)[0];
		unsigned int _short3  = ((unsigned short *)_pResult)[0];

		_short2 = ((_short2 >> 8) /* & 0xFF */) | ((_short2 & 0xFF) << 8);
		_short3 = ((_short3 >> 8) /* & 0xFF */) | ((_short3 & 0xFF) << 8);
		_v = (byte1 * _short2) + _v +_short3;
		_pResult[0] = _v;
		_pResult[1] = _v >> 8;
#else /* __LSBFIRST__ */
		_v = (byte1 * ((unsigned short *)_p2)[0]) + _v + ((unsigned short *)_pResult)[0];
		((unsigned short *)_pResult)[0] = _v /* & 0xFFFF */;
#endif /* __LSBFIRST__ */
		_v >>= 16; /* now _v contains the carry*/
	    }

	    /* possible odd highByte of f2 (or byteLoop, if not __LSBFIRST__) */
	    for ( ; _p2 <= _p2Last; _p2++, _pResult++) {
		_v = (byte1 * _p2[0]) + _v + _pResult[0];
		_pResult[0] = _v /* & 0xFF */;
		_v >>= 8; /* now _v contains the carry*/
	    }
	    /* distribute leftover carry byte-wise */
	    for ( ; _v; _v >>= 8, _pResult++) {
		_v += _pResult[0];
		_pResult[0] = _v /* & 0xFF */;
	    }
	}
	ok = true;
    }
%}.
    ok ifFalse:[
	1 to:len1 do:[:index1 |
	    1 to:len2 do:[:index2 |
		dstIndex := index1 + index2 - 1.
		prod := (digitByteArray basicAt:index1) * (otherDigitByteArray basicAt:index2).
		prod := prod + (resultDigitByteArray basicAt:dstIndex).
		resultDigitByteArray basicAt:dstIndex put:(prod bitAnd:16rFF).
		carry := prod bitShift:-8.
		carry ~~ 0 ifTrue:[
		    idx := dstIndex + 1.
		    [carry ~~ 0] whileTrue:[
			v := (resultDigitByteArray basicAt:idx) + carry.
			resultDigitByteArray basicAt:idx put:(v bitAnd:255).
			carry := v bitShift:-8.
			idx := idx + 1
		    ]
		]
	    ]
	].
    ].
    ^ result compressed
!

absMulKarazuba:aLargeInteger
    "return a LargeInteger representing abs(self) * abs(theArgument) using the karazuba algorithm.
	a = (2^n * p) + q
	b = (2^n * r) + s
	a * b   = ((2^n * p) + q) * ((2^n * r) + s)
		= 2^(n+n)*p*r + 2^n*p*s + 2^n*q*r + q*s
		= 2^(n+n)*p*r + (p*r + q*s - (q-p)*(s-r))*2^n + q*s

	this is faster for sufficient large n1,n2
	because regular multiplication is O(n1*n2) and karazuma multiplies much smaller numbers
	(half number of bits) but does more multiplications (on smaller numbers) and req's more
	additions and subtractions (on smaller numbers).
	The break-even for when to use regular multiplication has been determined heuristically
	and is somewhere around 1600 bits (digitLength of 200).
	(see test in absMul:)

	To disable karazuba, set UseKarazuba to false.
    "

    "/ compute half-sized pi and qi...
    |l1 l2 n nh p q r s pr qs q_p s_r q_ps_r pr_raisedTo_n mdl_raisedTo_nh|

    l1 := self digitLength.
    l2 := aLargeInteger digitLength.

    n := l1 max:l2.

    nh := (n / 2) ceiling. n := nh * 2.
    p := LargeInteger digitBytes:(digitByteArray copyFrom:nh+1) sign:1. "/ high bits of nr1
    q := LargeInteger digitBytes:(digitByteArray copyToMax:nh) sign:1.   "/ low bits of nr1
    r := LargeInteger digitBytes:(aLargeInteger digitBytes copyFrom:nh+1) sign:1. "/ high bits of nr2
    s := LargeInteger digitBytes:(aLargeInteger digitBytes copyToMax:nh).           "/ low bits of nr2

    p := p compressed.
    q := q compressed.
    r := r compressed.
    s := s compressed.

    pr := p * r.
    qs := q * s.
    q_p := q - p.
    s_r := s - r.
    q_ps_r := q_p * s_r.

    pr_raisedTo_n := (pr bitShift:(n*8)).
    mdl_raisedTo_nh := ((pr + qs - q_ps_r) bitShift:(nh*8)).
    ^ pr_raisedTo_n + mdl_raisedTo_nh + qs

    "
     #(100 500 1000 2500 5000 10000 25000 50000 100000 250000 500000 1000000) do:[:exp |
	 |nr r1 r2|
	 nr := (3 raisedTo:exp) asInteger.
	 Transcript show:exp; show:' nbytes: '; showCR:nr digitLength;
	    show:'  normal: '; show:(Time microsecondsToRun:[ UseKarazuba := false. r1 := nr * nr ]); showCR:'us';
	    show:'  karazuba: '; show:(Time microsecondsToRun:[ UseKarazuba := true. r2 := nr absMulKarazuba: nr]); showCR:'us'.
	 self assert:(r1 = r2).
     ]
    "
!

absPlus:aLargeInteger sign:newSign
    "return a LargeInteger representing abs(self) + abs(theArgument)
     with sign: newSign.
     The result is normalized. The argument must be a smallInteger
     with byteSize one less than the integer byteSize.
     This is a helper for addition and subtraction - not for public use."

    |result done otherDigitByteArray resultDigitByteArray
     len1   "{ Class: SmallInteger }"
     len2   "{ Class: SmallInteger }"
     newLen "{ Class: SmallInteger }"
     index  "{ Class: SmallInteger }"
     carry  "{ Class: SmallInteger }"
     sum    "{ Class: SmallInteger }" |

    otherDigitByteArray := aLargeInteger digitBytes.

%{
    OBJ _digitByteArray = __INST(digitByteArray);

    if (__isByteArray(_digitByteArray)
     && __isByteArray(otherDigitByteArray)) {
	int _len1, _len2, _newLen;
	unsigned char *_myDigits, *_otherDigits, *_newDigits;
	int _index, _carry;
	int _comLen;

	_len1 = __byteArraySize(_digitByteArray);
	_len2 = __byteArraySize(otherDigitByteArray);

	_otherDigits = __ByteArrayInstPtr(otherDigitByteArray)->ba_element;
	_myDigits = __ByteArrayInstPtr(_digitByteArray)->ba_element;

	if (_len1 < _len2) {
	    _comLen = _len1;
	    _newLen = _len2;
	    if (_otherDigits[_len2 - 1] == 0xFF) _newLen++;
	} else if (_len2 < _len1) {
	    _comLen = _len2;
	    _newLen = _len1;
	    if (_myDigits[_len1 - 1] == 0xFF) _newLen++;
	} else {
	    /*
	     * there can only be an overflow from the high bytes,
	     * if their sum is >= 255
	     * (with sum==255, a carry could still occur from the next lower bytes)
	     */
	    _newLen = _len1;
	    if ((_otherDigits[_len2 - 1] + _myDigits[_len1 - 1]) >= 0xFF) {
		_newLen++;
	    } else {
		if (_newLen == sizeof(INT)) {
		    OBJ _uint;

		    /*
		     * two word-sized numbers, no carry - a very common case ...
		     */
#if defined(__LSBFIRST__)
		    unsigned INT _sum = *(unsigned INT *)_otherDigits + *(unsigned INT *)_myDigits;
#else
		    unsigned INT _sum = __unsignedLongIntVal(self) + __unsignedLongIntVal(aLargeInteger);
#endif /* not LSB_FIRST */
		    if (_sum <= _MAX_INT) {
			_uint = __mkSmallInteger(_sum * __intVal(newSign));
		    } else {
			_uint = __MKULARGEINT(_sum);
			__LargeIntegerInstPtr(_uint)->l_sign = newSign;
		    }
		    RETURN (_uint);
		}
	    }
	    _comLen = _len1;
	}
	resultDigitByteArray = __BYTEARRAY_UNINITIALIZED_NEW_INT(_newLen);

	/*
	 * must refetch - GC could have been invoked
	 */
	_digitByteArray = __INST(digitByteArray);

	_myDigits = __ByteArrayInstPtr(_digitByteArray)->ba_element;
	_otherDigits = __ByteArrayInstPtr(otherDigitByteArray)->ba_element;
	_newDigits = __ByteArrayInstPtr(resultDigitByteArray)->ba_element;

	/*
	 * add them ...
	 */
	_index = 1;
	_carry = 0;

#if defined(__LSBFIRST__)
# if (__POINTER_SIZE__ == 8) && defined(__GNUC__) && defined(__alpha__)
#  if 0  /* not faster (on alpha) */
	{
	    int _comLen7;

	    /*
	     * have a 64bit integers;
	     * add quad-wise
	     * accessing bytes at: [index-1][index][index+1]..[index+6]
	     */
	    _comLen7 = _comLen - 3 - 4;
	    while (_index <= _comLen7) {
		UINT64 _sum, _t1, _t2;

		asm ("addq   %5,%6,%1         /* sum */                  \n\
		      addq   %0,%1,%1         /* plus carryIn */         \n\
		      cmpult %1,%5,%2         /* was there a carry ? */  \n\
		      cmpult %1,%6,%3         /* was there a carry ? */  \n\
		      bis    %2,%3,%0         /* carryOut */             \n\
		     "
			: "=r"  (_carry),
			  "=r"  (_sum),
			  "r"   (_t1),
			  "r"   (_t2)
			: "r"   (_carry),
			  "r"   (((unsigned long *)(&(_myDigits[_index - 1])))[0]),
			  "r"   (((unsigned long *)(&(_otherDigits[_index - 1])))[0])
		    );
		/* _sum = _sum & 0xFFFFFFFF; */
		((unsigned long *)(&(_newDigits[_index - 1])))[0] = _sum;
		_index += 8;
	    }
	}
#  endif / notdef */
# endif /* 64bit alpha */

# if (__POINTER_SIZE__ == 8)
# if 0  /* not faster */
	{
	    int _comLen7;

	    /*
	     * have a 64bit integers;
	     * add quad-wise
	     * accessing bytes at: [index-1][index][index+1]..[index+6]
	     */
	    _comLen7 = _comLen - 3 - 4;
	    while (_index <= _comLen7) {
		UINT64 _sum, _t1, _t2;

		_t1 = ((UINT64 *)(&(_myDigits[_index - 1])))[0];
		_t2 = ((UINT64 *)(&(_otherDigits[_index - 1])))[0];
		_sum = _t1 + _t2 + _carry;
		((UINT64 *)(&(_newDigits[_index - 1])))[0] = _sum;
		_carry = (_sum < _t1) | (_sum < _t2);
		_index += 8;
	    }
	}
#  endif
# endif /* 64bit */

# ifdef UINT64
	{
	    int _comLen3;

	    /*
	     * have a 64bit integer type;
	     * add int-wise
	     * accessing bytes at: [index-1][index][index+1][index+2]
	     */
	    _comLen3 = _comLen - 3;
	    while (_index <= _comLen3) {
		UINT64 _sum;

		/* do not merge the 3 lines below into one -
		 * (will do sign extension then, which is wrong here)
		 */
		_sum = (unsigned)_carry;
		_sum += ((unsigned int *)(&(_myDigits[_index - 1])))[0];
		_sum += ((unsigned int *)(&(_otherDigits[_index - 1])))[0];
		_carry = _sum >> 32;
		/* _sum = _sum & 0xFFFFFFFF; */
		((unsigned int *)(&(_newDigits[_index - 1])))[0] = _sum;
		_index += 4;
	    }
	}
# else
#  if defined(__i386__) && defined(__GNUC__) && (__POINTER_SIZE__ == 4)
	{
	    int _comLen3;

	    _comLen3 = _comLen - 3 - 4;
	    while (_index <= _comLen3) {
		unsigned int _sum, _sum2;
		unsigned int __in1A, __in1B, __in2A, __in2B;

		__in1A = ((unsigned int *)(&(_myDigits[_index - 1])))[0];
		__in2A = ((unsigned int *)(&(_myDigits[_index - 1])))[1];
		__in1B = ((unsigned int *)(&(_otherDigits[_index - 1])))[0];
		__in2B = ((unsigned int *)(&(_otherDigits[_index - 1])))[1];

		asm ("addl %%edx,%%eax  \n\
		      movl $0,%%edx     \n\
		      adcl $0,%%edx     \n\
		      addl %5,%%eax     \n\
		      adcl $0,%%edx     \n\
					\n\
		      addl %%edx,%%ecx  \n\
		      movl $0,%%edx     \n\
		      adcl $0,%%edx     \n\
		      addl %7,%%ecx     \n\
		      adcl $0,%%edx     \n\
		     "
			: "=d"  (_carry),
			  "=a"  (_sum),
			  "=c"  (_sum2)
			: "0"   (_carry),
			  "1"   (__in1A),
			  "m"   (__in1B),
			  "2"   (__in2A),
			  "m"   (__in2B)
		    );

		((unsigned *)(&(_newDigits[_index - 1])))[0] = _sum;
		((unsigned *)(&(_newDigits[_index - 1])))[1] = _sum2;
		_index += 8;
	    }
	    /*
	     * add int-wise
	     * accessing bytes at: [index-1][index][index+1][index+2]
	     */
	    _comLen3 = _comLen3 + 4;
	    if (_index <= _comLen3) {
		unsigned int _sum;
		unsigned int __inA, __inB;

		__inA = ((unsigned int *)(&(_myDigits[_index - 1])))[0];
		__inB = ((unsigned int *)(&(_otherDigits[_index - 1])))[0];

		asm ("addl %%edx,%%eax      \n\
		      movl $0,%%edx         \n\
		      adcl $0,%%edx         \n\
		      addl %4,%%eax         \n\
		      adcl $0,%%edx"
			: "=d"  (_carry),
			  "=a"  (_sum)
			: "0"   (_carry),
			  "1"   (__inA),
			  "rm"  (__inB)
		    );

		((unsigned *)(&(_newDigits[_index - 1])))[0] = _sum;
		_index += 4;
	    }
	}
#  endif /* __i386__ && GNUC */
#  if defined(__win32__) && defined(__BORLANDC__) && defined(__x86__) && (__POINTER_SIZE__ == 4)
	{
	    int _comLen3;

	    /*
	     * add long-wise
	     * accessing bytes at: [index-1][index][index+1][index+2]
	     */
	    _comLen3 = _comLen - 3;
	    while (_index <= _comLen3) {
		unsigned int _sum, _v1, _v2;

		_v1 = ((unsigned int *)(&(_myDigits[_index - 1])))[0];
		_v2 = ((unsigned int *)(&(_otherDigits[_index - 1])))[0];
		asm {
		      mov eax, _v1
		      add eax, _v2
		      mov edx, 0
		      adc edx, 0
		      add eax, _carry
		      adc edx, 0
		      mov _carry, edx
		      mov _sum, eax
		    }

		((unsigned *)(&(_newDigits[_index - 1])))[0] = _sum;
		_index += 4;
	    }
	}
#  endif /* __i386__ && WIN32 */
# endif /* INT64 */
	/*
	 * add short-wise
	 * accessing bytes at: [index-1][index]
	 */
	while (_index < _comLen) {
	    unsigned int _sum;

	    _sum = _carry
		   + ((unsigned short *)(&(_myDigits[_index - 1])))[0]
		   + ((unsigned short *)(&(_otherDigits[_index - 1])))[0];
	    _carry = _sum >> 16;
	    /* _sum = _sum & 0xFFFF; */
	    *(unsigned short *)(&(_newDigits[_index - 1])) = _sum;
	    _index += 2;
	}
#else
# ifdef __sparc__
	/*
	 * add short-wise
	 * accessing bytes at: [index-1][index]
	 */
	while (_index < _comLen) {
	    unsigned int _sum;
	    unsigned short _v1, _v2;

	    _v1 = ((unsigned short *)(&(_myDigits[_index - 1])))[0];
	    _v2 = ((unsigned short *)(&(_otherDigits[_index - 1])))[0];
	    _sum = _carry + (_v1>>8) + (_v2>>8);
	    _carry = _sum >> 8;
	    _newDigits[_index - 1] = _sum;

	    _sum = _carry + (_v1 & 0xFF) + (_v2 & 0xFF);
	    _carry = _sum >> 8;
	    _newDigits[_index] = _sum;
	    _index += 2;
	}
# endif
#endif /* __LSBFIRST__ */

	/*
	 * add byte-wise
	 */
	while (_index <= _comLen) {
	    unsigned int _sum;

	    _sum = _carry
		   + _myDigits[_index - 1]
		   + _otherDigits[_index - 1];
	    _carry = _sum >> 8;
	    /* _sum = _sum & 0xFF; */
	    _newDigits[_index - 1] = _sum;
	    _index++;
	}

	/*
	 * rest
	 */
	if (_len1 > _len2) {
#if defined(__LSBFIRST__)
	    if (_index <= _len1) {
		if ((_index - 1) & 1) {
		    /* odd byte */
		    unsigned int _sum;

		    _sum = _carry + _myDigits[_index - 1];
		    _carry = _sum >> 8;
		    /* _sum = _sum & 0xFF; */
		    _newDigits[_index - 1] = _sum;
		    _index++;
		}

		while (_index < _len1) {
		    /* shorts */
		    unsigned int _sum;

		    _sum = _carry + *(unsigned short *)(&(_myDigits[_index - 1]));
		    _carry = _sum >> 16;
		    /* _sum = _sum & 0xFFFF; */
		    *(unsigned short *)(&(_newDigits[_index - 1])) = _sum;
		    _index += 2;
		}

		if (_index <= _len1) {
		    /* last byte */
		    unsigned int _sum;

		    _sum = _carry + _myDigits[_index - 1];
		    _carry = _sum >> 8;
		    /* _sum = _sum & 0xFF; */
		    _newDigits[_index - 1] = _sum;
		    _index++;
		}
	    }
#else
	    while (_index <= _len1) {
		unsigned int _sum;

		_sum = _carry + _myDigits[_index - 1];
		_carry = _sum >> 8;
		/* _sum = _sum & 0xFF; */
		_newDigits[_index - 1] = _sum;
		_index++;
	    }
#endif /* not LSB */
	} else {
	    if (_len2 > _len1) {
#if defined(__LSBFIRST__)
		if (_index <= _len2) {
		    if ((_index - 1) & 1) {
			/* odd byte */
			unsigned int _sum;

			_sum = _carry + _otherDigits[_index - 1];
			_carry = _sum >> 8;
			/* _sum = _sum & 0xFF; */
			_newDigits[_index - 1] = _sum;
			_index++;
		    }

		    while (_index < _len2) {
			/* shorts */
			unsigned int _sum;

			_sum = _carry + *(unsigned short *)(&(_otherDigits[_index - 1]));
			_carry = _sum >> 16;
			/* _sum = _sum & 0xFFFF; */
			*(unsigned short *)(&(_newDigits[_index - 1])) = _sum;
			_index += 2;
		    }

		    if (_index <= _len2) {
			/* last byte */
			unsigned int _sum;

			_sum = _carry + _otherDigits[_index - 1];
			_carry = _sum >> 8;
			/* _sum = _sum & 0xFF; */
			_newDigits[_index - 1] = _sum;
			_index++;
		    }
		}
#else
		while (_index <= _len2) {
		    unsigned int _sum;

		    _sum = _carry + _otherDigits[_index - 1];
		    _carry = _sum >> 8;
		    /* _sum = _sum & 0xFF; */
		    _newDigits[_index - 1] = _sum;
		    _index++;
		}
#endif /* not LSB */
	    }
	}

	while (_index <= _newLen) {
	    unsigned int _sum;

	    _sum = _carry;
	    _carry = _sum >> 8;
	    /* _sum = _sum & 0xFF; */
	    _newDigits[_index - 1] = _sum;
	    _index++;
	}
    }
%}.
    resultDigitByteArray notNil ifTrue:[
	result := self class basicNew.
	result setDigits:resultDigitByteArray.
	result setSign:newSign.
    ] ifFalse:[
	len1 := digitByteArray size.
	len2 := otherDigitByteArray size.

	"/ earlier versions estimated the newLength as:
	"/ (len1 max:len2) + 1
	"/ and reduced the result.
	"/ however, if one of the addends is smaller,
	"/ the result will never require another digit,
	"/ if the highest digit of the larger addent is
	"/ not equal to 255. Therefore, in most cases,
	"/ we can avoid the computation and resizing
	"/ in #reduced.

	len1 < len2 ifTrue:[
	    newLen := len2.
	    (otherDigitByteArray at:len2) == 16rFF ifTrue:[
		newLen := newLen + 1
	    ]
	] ifFalse:[
	    len2 < len1 ifTrue:[
		newLen := len1.
		(digitByteArray at:len1) == 16rFF ifTrue:[
		    newLen := newLen + 1
		]
	    ] ifFalse:[
		newLen := len1 + 1.
	    ]
	].

	result := self class basicNew numberOfDigits:newLen.
	result sign:newSign.
	resultDigitByteArray := result digitBytes.

	index := 1.
	carry := 0.

	done := false.
	[done] whileFalse:[
	    sum := carry.
	    (index <= len1) ifTrue:[
		sum := sum + (digitByteArray basicAt:index).
		(index <= len2) ifTrue:[
		    sum := sum + (otherDigitByteArray basicAt:index)
		]
	    ] ifFalse:[
		(index <= len2) ifTrue:[
		    sum := sum + (otherDigitByteArray basicAt:index)
		] ifFalse:[
		    "end reached"
		    done := true
		]
	    ].
	    (sum >= 16r100) ifTrue:[
		carry := 1.
		sum := sum - 16r100
	    ] ifFalse:[
		carry := 0
	    ].
	    resultDigitByteArray basicAt:index put:sum.
	    index := index + 1
	].
    ].

    ^ result compressed

    "Modified: 11.8.1997 / 03:23:37 / cg"
!

div2
    "private helper for division:
       destructively divide the receiver by 2.
       may leave the receiver unnormalized (i.e. with a leftover 0 high-byte)"

    |prevBit|

%{  /* NOCONTEXT */
    OBJ __digits = __INST(digitByteArray);

    if (__isByteArray(__digits)) {
	int __nBytes = __byteArraySize(__digits);
	unsigned char *__bp = __ByteArrayInstPtr(__digits)->ba_element;
	unsigned INT __this, __next;
	int __idx;

	if (__nBytes == 1) {
	    __bp[0] >>= 1;
	    RETURN (self);
	}

	__idx = 1;

#if defined(__LSBFIRST__)
# if (__POINTER_SIZE__ == 8)
	if (sizeof(unsigned INT) == 8) {
	    int __endIndex = __nBytes - 8;

	    if (__idx < __endIndex) {
		__this = ((unsigned INT *)__bp)[0];

		while (__idx < __endIndex) {
		    __next = ((unsigned INT *)__bp)[1];
		    __this = (__this >> 1) /* & 0x7FFFFFFFFFFFFFF */;
		    __this |= __next << 63;
		    ((unsigned INT *)__bp)[0] = __this;
		    __this = __next;
		    __bp += 8;
		    __idx += 8;
		}
	    }

	    if (__idx < (__nBytes - 4)) {
		__this = ((unsigned int *)__bp)[0];

		__next = ((unsigned int *)__bp)[1];
		__this = (__this >> 1) /* & 0x7FFFFFF */;
		__this |= __next << 31;
		((unsigned int *)__bp)[0] = __this;
		__this = __next;
		__bp += 4;
		__idx += 4;
	    }
	    if (__idx < (__nBytes - 2)) {
		__this = ((unsigned short *)__bp)[0];

		__next = ((unsigned short *)__bp)[1];
		__this = (__this >> 1) /* & 0x7FFFFFF */;
		__this |= __next << 15;
		((unsigned short *)__bp)[0] = __this;
		__this = __next;
		__bp += 2;
		__idx += 2;
	    }
	}
# else
	if (sizeof(unsigned int) == 4) {
	    int __endIndex = __nBytes - 4;

	    if (__idx < __endIndex) {
		__this = ((unsigned int *)__bp)[0];

		while (__idx < __endIndex) {
		    __next = ((unsigned int *)__bp)[1];
		    __this = (__this >> 1) /* & 0x7FFFFFF */;
		    __this |= __next << 31;
		    ((unsigned int *)__bp)[0] = __this;
		    __this = __next;
		    __bp += 4;
		    __idx += 4;
		}
	    }
	}
# endif
#endif

	__this = __bp[0];
	while (__idx < __nBytes) {
	    __next = __bp[1];
	    __this >>= 1;
	    __this |= __next << 7;
	    __bp[0] = __this;
	    __this = __next;
	    __bp++;
	    __idx++;
	}
	__bp[0] = __this >> 1;
	RETURN (self);
    }
%}.

    prevBit := 0.
    digitByteArray size to:1 by:-1 do:[:idx |
	|thisByte|

	thisByte := digitByteArray at:idx.
	digitByteArray at:idx put:((thisByte bitShift:-1) bitOr:prevBit).
	prevBit := (thisByte bitAnd:1) bitShift:7.
    ].

    "
     100000 asLargeInteger div2
     1000000000000000000000000000 div2
     10000000000000000000000000000000000000000000 div2
    "

    "Modified: 5.11.1996 / 16:12:56 / cg"
!

mul2
    "private helper for division:
       destructively multiply the receiver by 2."

    |nBytes "{ Class: SmallInteger }"
     b      "{ Class: SmallInteger }"
     t prevBit|

    nBytes := digitByteArray size.

    b := digitByteArray at:nBytes.
    (b bitAnd:16r80) ~~ 0 ifTrue:[
	"/ need another byte
	nBytes := nBytes + 1.
	t := ByteArray uninitializedNew:nBytes.
	t replaceFrom:1 to:nBytes-1 with:digitByteArray startingAt:1.
	t at:nBytes put:0.
	digitByteArray := t.
    ].

%{
    OBJ __digits = __INST(digitByteArray);

    if (__isByteArray(__digits)) {
	int __nBytes = __intVal(nBytes);
	unsigned char *__bp = __ByteArrayInstPtr(__digits)->ba_element;
	unsigned INT __carry = 0, __newCarry;

#if defined(__LSBFIRST__)
# if (__POINTER_SIZE__ == 8)
	if (sizeof(unsigned INT) == 8) {
	    while (__nBytes >= 8) {
		unsigned INT __this;

		__this = ((unsigned INT *)__bp)[0];
		__newCarry = (__this >> 63) /* & 1 */;
		((unsigned INT *)__bp)[0] = (__this << 1) | __carry;
		__carry = __newCarry;
		__bp += 8;
		__nBytes -= 8;
	    }
	}
# endif
	if (sizeof(unsigned int) == 4) {
	    while (__nBytes >= 4) {
		unsigned int __this;

		__this = ((unsigned int *)__bp)[0];
		__newCarry = (__this >> 31) /* & 1 */;
		((unsigned int *)__bp)[0] = (__this << 1) | __carry;
		__carry = __newCarry;
		__bp += 4;
		__nBytes -= 4;
	    }
	}
	if (__nBytes >= 2) {
	    unsigned short __this;

	    __this = ((unsigned short *)__bp)[0];
	    __newCarry = (__this >> 15) /* & 1 */;
	    ((unsigned short *)__bp)[0] = (__this << 1) | __carry;
	    __carry = __newCarry;
	    __bp += 2;
	    __nBytes -= 2;
	}
#endif /* LSBFIRST */
	while (__nBytes) {
	    unsigned char __this;

	    __this = __bp[0];
	    __newCarry = (__this >> 7) /* & 1 */;
	    __bp[0] = (__this << 1) | __carry;
	    __carry = __newCarry;
	    __bp++;
	    __nBytes--;
	}
	RETURN (self);
    }
%}.

    prevBit := 0.
    1 to:digitByteArray size do:[:idx |
	|thisByte|

	thisByte := digitByteArray at:idx.
	digitByteArray at:idx put:(((thisByte bitShift:1) bitAnd:16rFF) bitOr:prevBit).
	prevBit := (thisByte bitShift:-7) bitAnd:1.
    ].

    "
     100000 asLargeInteger mul2
     16r7FFFFFFFFFFF copy mul2 hexPrintString
     16rFFFFFFFFFFFF copy mul2 hexPrintString
     16r7FFFFFFFFFFFFF copy mul2 hexPrintString
     16rFFFFFFFFFFFFFF copy mul2 hexPrintString
     10000000000000000000000000000 mul2
    "

    "Modified: 5.11.1996 / 16:37:32 / cg"
!

mul256
    "private helper for division:
       destructively multiply the receiver by 256."

    |newDigits newSize|

    newSize := digitByteArray size + 1.
    newDigits := ByteArray uninitializedNew:newSize.
    newDigits replaceBytesFrom:2 to:newSize with:digitByteArray startingAt:1.
    newDigits at:1 put:0.
    digitByteArray := newDigits

    "Modified: / 20.5.1999 / 09:16:42 / cg"
!

numberOfDigits:nDigits
    "allocate space for nDigits bytes of magnitude"

    digitByteArray := ByteArray new:nDigits.
    sign := 1.
!

numberOfDigits:nDigits sign:newSign
    "allocate space for nDigits bytes of magnitude"

    digitByteArray := ByteArray new:nDigits.
    sign := newSign.
!

setDigits:digits
    "set the digits from the lsb-ordered digit-bytes"

    digitByteArray := digits.
    sign := 1.
!

setDigits:digits sign:newSign
    "set the digits from the lsb-ordered digit-bytes"

    digitByteArray := digits.
    sign := newSign.
!

setSign:aNumber
    "destructively change the sign of the receiver.
     Return the compressed integer (smallinteger if possible)"

    sign := aNumber.
%{
    if (aNumber == __MKSMALLINT(-1)) {
	if (__byteArraySize(__INST(digitByteArray)) == sizeof(INT)) {
	    if ( ((INT *)(__byteArrayVal(__INST(digitByteArray))))[0] == -_MIN_INT) {
		RETURN(__MKSMALLINT(_MIN_INT));
	    }
	}
    }
%}.

    "
     (LargeInteger digitBytes:#[0 0 0 64]) setSign:-1
    "

    "Modified (comment): / 26-02-2016 / 22:40:27 / cg"
!

sign:aNumber
    <resource: #obsolete>
    "destructively change the sign of the receiver"

    ^ self setSign:aNumber
! !

!LargeInteger methodsFor:'queries'!

nextPowerOf2
    "return the power of 2 at or above the receiver.
     Notice, that for a powerOf2, the receiver is returned.
     Also notice, that (because it is used for padding),
     0 is returned for zero."

    |newBytes nBytes hi|

    "/ assume I am normalized
    nBytes := digitByteArray size.
    hi := digitByteArray at:nBytes.
    self assert:(hi ~~ 0).

    newBytes := ByteArray new:(nBytes) withAll:16rFF.
    (hi isPowerOf:2) ifTrue:[
	newBytes at:nBytes put:((hi bitShift:1)- 1).
    ] ifFalse:[
	newBytes at:nBytes put:(hi nextPowerOf2 - 1).
    ].
    ^ (LargeInteger digitBytes:newBytes) + 1

    "
     100 factorial nextPowerOf2  isPowerOf:2
     1000 factorial nextPowerOf2  isPowerOf:2
     Time millisecondsToRun:[
	 |v|
	 v := 1000 factorial.
	 1000 timesRepeat:[
	    v nextPowerOf2
	 ]
     ]
    "
! !

!LargeInteger methodsFor:'testing'!

even
    "return true if the receiver is even"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( ((STLargeInteger)self).isEven() ? STObject.True : STObject.False);
#else
    OBJ digits = __INST(digitByteArray);

    if (__isByteArray(digits)){
	if (__byteArraySize(digits) > 0) {
	    unsigned char b = __ByteArrayInstPtr(digits)->ba_element[0];
	    RETURN( (b & 1) ? false : true );
	}
    }
#endif
%}.
    ^ (digitByteArray at:1) even

    "
     16r100000000000000000001 even
     16r100000000000000000001 odd
     16r100000000000000000000 even
     16r100000000000000000000 odd
    "
!

negative
    "return true, if the receiver is less than zero"

%{
#ifdef __SCHTEAM__
    return context._RETURN( ((STLargeInteger)self).largeValue.signum() < 0 ? STObject.True : STObject.False);
#endif
%}.
    ^ (sign < 0)
!

odd
    "return true if the receiver is odd"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( ((STLargeInteger)self).isEven() ? STObject.False : STObject.True);
#else
    OBJ digits = __INST(digitByteArray);

    if (__isByteArray(digits)){
	if (__byteArraySize(digits) > 0) {
	    unsigned char b = __ByteArrayInstPtr(digits)->ba_element[0];
	    RETURN( (b & 1) ? true : false );
	}
    }
#endif
%}.
    ^ (digitByteArray at:1) odd

    "Modified: 18.11.1996 / 22:19:19 / cg"
!

positive
    "return true, if the receiver is greater or equal to zero (not negative)"

%{
#ifdef __SCHTEAM__
    return context._RETURN( ((STLargeInteger)self).largeValue.signum() >= 0 ? STObject.True : STObject.False);
#endif
%}.
    ^ (sign >= 0)
!

sign
    "return the sign of the receiver (-1, 0 or 1)"

%{
#ifdef __SCHTEAM__
    return context._RETURN( STInteger._new( ((STLargeInteger)self).largeValue.signum() ));
#endif
%}.
    ^ sign
!

strictlyPositive
    "return true, if the receiver is greater than zero"

%{
#ifdef __SCHTEAM__
    return context._RETURN( ((STLargeInteger)self).largeValue.signum() > 0 ? STObject.True : STObject.False);
#endif
%}.
    ^ (sign > 0)
! !

!LargeInteger class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

