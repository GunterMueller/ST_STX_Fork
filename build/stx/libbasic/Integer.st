"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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

Number subclass:#Integer
	instanceVariableNames:''
	classVariableNames:'BCDConversionErrorSignal PrimeCache'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

Object subclass:#ModuloNumber
	instanceVariableNames:'modulus reciprocal shift'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Integer
!

!Integer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    abstract superclass for all integer numbers.
    See details in concrete subclasses LargeInteger and SmallInteger.

    Mixed mode arithmetic:
        int op int         -> int
        int op fix         -> fix; scale is fix's scale
        int op fraction    -> fraction
        int op float       -> float

    [author:]
        Claus Gittinger

    [see also:]
        Number
        LargeInteger SmallInteger
        Float ShortFloat Fraction FixedPoint
"
! !

!Integer class methodsFor:'instance creation'!

byte1:b1 byte2:b2 byte3:b3 byte4:b4
    "Squeak compatibility:
     Return an Integer given four value bytes.
     The returned integer is either a Small- or a LargeInteger
     (on 32bit systems - on 64bit systems, it will be always a SmallInteger)"

    |t|

    t := b4.
    t := (t bitShift:8) + b3.
    t := (t bitShift:8) + b2.
    ^ (t bitShift:8) + b1.

    "
     (Integer byte1:16r10 byte2:16r32 byte3:16r54 byte4:16r76) hexPrintString
     (Integer byte1:16r00 byte2:16r11 byte3:16r22 byte4:16r33) hexPrintString
    "

    "Created: 19.10.1997 / 18:08:52 / cg"
    "Modified: 19.10.1997 / 18:09:04 / cg"
!

fastFromString:aString at:startIndex
    "return the next unsigned Integer from the string
     as a decimal number, starting at startIndex.
     The number must be in the native machine's int range
     (i.e. 63bit on alpha / 31 on all others);
     However, for portability, only use it for 31bit numbers.
     No spaces are skipped.

     This is a specially tuned entry (using a low-level C-call), which
     returns garbage if the argument string is not a small integer number.
     It has been added to allow high speed string decomposition into numbers,
     especially for mass-data."

%{   /* NOCONTEXT */
    if (__isStringLike(aString) && __isSmallInteger(startIndex)) {
        char *cp = (char *)(__stringVal(aString));
        int idx = __intVal(startIndex) - 1;
        unsigned INT val;

        if ((unsigned)idx < __stringSize(aString)) {
	    extern int atoi();
	    extern long atol();

            val = atol(cp + idx);
            if (val <= _MAX_INT) {
                RETURN(__mkSmallInteger(val));
            }
            RETURN (__MKUINT(val));
        }
    }
%}.
    self primitiveFailed.

    "
     Integer fastFromString:'12345' at:1
     Integer fastFromString:'12345' at:2
     Integer fastFromString:'12345' at:3
     Integer fastFromString:'12345' at:4
     Integer fastFromString:'12345' at:5
     Integer fastFromString:'1234512345' at:1
     Integer fastFromString:'2147483647' at:1

     Integer fastFromString:'4294967295' at:1
     Integer fastFromString:'12345' at:6
     Integer fastFromString:'12345' at:0

     Time millisecondsToRun:[
        100000 timesRepeat:[
            Integer readFrom:'12345'
        ]
     ]
    "

    "
     Time millisecondsToRun:[
        100000 timesRepeat:[
            Integer fastFromString:'12345' at:1
        ]
     ]
    "
!

fromBCDBytes:aByteArray
    "given a byteArray in BCD format, return an appropriate integer.
     The byteArray must contain the BCD encoded decimal string,
     starting with the most significant digits.
     This conversion is useful for some communication protocols,
     or control systems, which represent big numbers this way...
    "

    |val|

    val := 0.
    aByteArray do:[:twoDigits |
        |hi lo|

        hi := (twoDigits bitShift:-4) bitAnd:16r0F.
        lo := twoDigits bitAnd:16r0F.
        val := (val * 100) + (hi * 10) + lo
    ].
    ^ val

    "
     Integer fromBCDBytes:#[16r12 16r34 16r56]
     Integer fromBCDBytes:#[16r12 16r34 16r56 16r78]
     Integer fromBCDBytes:#[16r12 16r34 16r56 16r78 16r90]
     Integer fromBCDBytes:#[16r98 16r76 16r54]
     Integer fromBCDBytes:#[16r98 16r76 16r54 16r32]
     Integer fromBCDBytes:#[16r98 16r76 16r54 16r32 16r10]
     Integer fromBCDBytes:#[16r12 16r34 16r56 16r78 16r90 16r12 16r34 16r56 16r78 16r90]
    "
!

fromSwappedBCDBytes:aByteArray
    "given a byteArray in BCD format, return an appropriate integer.
     The byteArray must contain the BCD encoded decimal string,
     starting with the LEAST significant digits.
     This conversion is useful for some communication protocols,
     or control systems (e.g. SMC), which represent big numbers this way...
    "

    |val|

    val := 0.
    aByteArray do:[:twoDigits |
        |hi lo|

        lo := (twoDigits bitShift:-4) bitAnd:16r0F.
        hi := twoDigits bitAnd:16r0F.
        lo <= 9 ifTrue:[
            val := (val * 100) + (hi * 10) + lo
        ] ifFalse:[
            "16rF is used to encode an odd number of digits"
            val := (val * 10) + hi.
        ].
    ].
    ^ val

    "
     Integer fromSwappedBCDBytes:#[16r12 16r34 16r56]
     Integer fromSwappedBCDBytes:#[16r12 16r34 16rF6]
     Integer fromSwappedBCDBytes:#[16r12 16r34 16r56 16r78]
     Integer fromSwappedBCDBytes:#[16r12 16r34 16r56 16r78 16r90]
     Integer fromSwappedBCDBytes:#[16r98 16r76 16r54]
     Integer fromSwappedBCDBytes:#[16r98 16r76 16r54 16r32]
     Integer fromSwappedBCDBytes:#[16r98 16r76 16r54 16r32 16r10]
     Integer fromSwappedBCDBytes:#[16r12 16r34 16r56 16r78 16r90 16r12 16r34 16r56 16r78 16r90]
    "
!

new:numberOfBytes neg:negative
    "for ST-80 compatibility:
     Return an empty Integer (uninitialized value) with space for
     numberOfBytes bytes (= digitLength). The additional argument
     negative specifies if the result should be a negative number.
     The digits can be stored byte-wise into the result, using digitAt:put:"

    ^ LargeInteger basicNew
            numberOfDigits:numberOfBytes
            sign:(negative ifTrue:[-1] ifFalse:[1])
!

readFrom:aStringOrStream
    "return the next Integer from the (character-)stream aStream
     as decimal number.

     NOTICE:
       This behaves different from the default readFrom:, in returning
       0 (instead of raising an error) in case no number can be read.
       It is unclear, if this is the correct behavior (ST-80 does this)
       - depending on the upcoming ANSI standard, this may change."

    ^ self readFrom:aStringOrStream onError:0

    "
     Integer readFrom:(ReadStream on:'foobar')
     Integer readFrom:(ReadStream on:'foobar') onError:nil
    "
!

readFrom:aStringOrStream onError:exceptionBlock
    "return the next Integer from the (character-)stream aStream,
     handling initial XXr for arbitrary radix numbers and initial sign.
     Also, all initial whitespace is skipped.
     If the string does not represent a valid integer number,
     return the value of exceptionBlock."

    |value|

    Error handle:[:ex |
        ^ exceptionBlock value
    ] do:[
        |str nextChar negative|

        str := aStringOrStream readStream.

        nextChar := str skipSeparators.
        (nextChar == $-) ifTrue:[
            negative := true.
            str next.
            nextChar := str peekOrNil
        ] ifFalse:[
            negative := false
        ].
        (nextChar isNil or:[nextChar isDigit not]) ifTrue:[
            "
             the string does not represent an integer
            "
            ^ exceptionBlock value
        ].
        value := self readFrom:str radix:10.
        nextChar := str peekOrNil.
        ((nextChar == $r) or:[ nextChar == $R]) ifTrue:[
            "-xxr<number> is invalid; should be xxr-<val>"

            negative ifTrue:[
                'Integer [warning]: invalid (negative) radix; please use xxr-<val> instead of -xxr<number>' errorPrintCR.
                "/ negative := false
            ].
            str next.
            nextChar := str peekOrNil.
            nextChar == $- ifTrue:[
                negative ifTrue:[
                    'Integer [warning]: invalid double sign; please use xxr-<val> instead of -xxr<number>' errorPrintCR.
                ].
                negative := true.
                str next.
            ].
            value := self readFrom:str radix:value
        ].
        negative ifTrue:[
            value := value negated
        ].
    ].
    ^ value

    "
     Integer readFrom:'12345'      onError:['wrong']
     Integer readFrom:'-12345'     onError:['wrong']
     Integer readFrom:'+12345'     onError:['wrong']
     Integer readFrom:'16rFFFF'    onError:['wrong']
     Integer readFrom:'12345.1234' onError:['wrong']
     Integer readFrom:'foo'        onError:['wrong']
     Integer readFrom:'foo'
    "

    "Created: / 16.11.1995 / 22:48:59 / cg"
    "Modified: / 14.4.1998 / 19:17:28 / cg"
!

readFrom:aStringOrStream radix:radix
    "return the next UNSIGNED Integer from the (character-)stream aStream in radix; 
     (assumes that the initial XXr has already been read).
     No whitespace-skipping is done.
     Returns 0 if no number available.

     NOTICE:
       This behaves different from the default readFrom:, in returning
       0 (instead of raising an error) in case no number can be read.
       It is unclear, if this is the correct behavior (ST-80 does this)
       - depending on the upcoming ANSI standard, this may change."

    ^ self readFrom:aStringOrStream radix:radix onError:0
!

readFrom:aStringOrStream radix:radix onError:exceptionBlock
    "return the next UNSIGNED Integer from the (character-)stream aStream in radix; 
     (assumes that the initial XXr has already been read).
     No whitespace-skipping is done.
     Returns the value of exceptionBlock, if no number is available."

    |str nextChar value
     r     "{ Class: SmallInteger }"
     r2    "{ Class: SmallInteger }"
     r3    "{ Class: SmallInteger }"
     r4    "{ Class: SmallInteger }"
     digit1 digit2 digit3 digit4 |

    str := aStringOrStream readStream.

    nextChar := str peekOrNil.
    (nextChar isNil or:[(value := nextChar digitValueRadix:radix) isNil]) ifTrue:[
        ^ exceptionBlock value
    ].

"/ OLD code
"/    [nextChar notNil and:[nextChar isDigitRadix:radix]] whileTrue:[
"/        str next.
"/        value := value * radix + nextChar digitValue.
"/        nextChar := str peekOrNil.
"/    ].
"/    ^ value.

    "/ the code below does the same, but is much faster, if the
    "/ converted number is large
    "/ (requires only half as many LargeInt multiplications and additions)
    "/ It should not be slower for smallIntegers.

    r := radix.
    r2 := r * r.
    r4 := r2 * r2.

    [
        nextChar := str nextPeekOrNil.
        nextChar notNil and:[(digit1 := nextChar digitValueRadix:r) notNil]
    ] whileTrue:[
        "/ read 4 chars and pre-compute their value to avoid largeInt operations.

        nextChar := str nextPeekOrNil.
        (nextChar isNil or:[(digit2 := nextChar digitValueRadix:r) isNil]) ifTrue:[
            ^ (value * r) + digit1.
        ].

        nextChar := str nextPeekOrNil.
        (nextChar isNil or:[(digit3 := nextChar digitValueRadix:r) isNil]) ifTrue:[
            ^ (value * r2) + ((digit1*r) + digit2) .
        ].

        nextChar := str nextPeekOrNil.
        (nextChar isNil or:[ (digit4 := nextChar digitValueRadix:r) isNil]) ifTrue:[
            r3 := r2 * r.
            ^ (value * r3) + ((((digit1*r) + digit2)*r) + digit3).
        ].

        value := (value * r4) + ((((((digit1*r) + digit2)*r) + digit3)*r) + digit4).
    ].
    ^ value

    "
     Integer readFrom:(ReadStream on:'12345') radix:10
     Integer readFrom:(ReadStream on:'FFFF') radix:16
     Integer readFrom:(ReadStream on:'1010') radix:2
     Integer readFrom:(ReadStream on:'foobar') radix:10
     Integer readFrom:(ReadStream on:'foobar') radix:10 onError:nil
     Integer readFrom:'gg' radix:10 onError:0
     Integer readFrom:'' radix:10 onError:'wrong'

     |s|
     s := String new:1000 withAll:$1.
     Time millisecondsToRun:[
        1000 timesRepeat:[
            s asInteger
        ]
     ]
    "

    "Modified: / 14.4.1998 / 19:16:46 / cg"
!

readFromRomanString:aStringOrStream
    "convert a string or stream containing a roman representation into an integer.
     Raises a RomanNumberFormatError, if the inputs format is completely wrong.
     Raises BadRomanNumberFormatError if its wrong, but could be parsed.
     Notifies via NaiveRomanNumberFormatNotification, if its a bit wrong (naive format).
     Will read both real and naive roman numbers (see printRomanOn: vs. printRomanOn:naive:),
     however, a notification is raised for naive numbers (catch it if you are interested in it)."

    |romanValues s c val digitVal prevDigitVal countSame delta
     stopOnSeparator finish|

    romanValues := Dictionary
                    withKeys:'MDCLXVI' "/ #($M $D $C $L $X $V $I)
                    andValues:#(1000 500 100 50 10 5 1).

    (stopOnSeparator := aStringOrStream isStream) ifFalse:[
        s := aStringOrStream readStream.
    ].
    s atEnd ifTrue:[
        ^ RomanNumberFormatError raiseErrorString:'empty string'
    ].
    val := 0.
    prevDigitVal := 99999.
    countSame := 1.
    finish := false.

    [s atEnd or:[finish]] whileFalse:[
        c := s next asUppercase.
        c isSeparator ifTrue:[
            stopOnSeparator ifFalse:[
                ^ RomanNumberFormatError raiseErrorString:'garbage at the end'
            ].
            finish := true.
        ] ifFalse:[
            digitVal := romanValues at:c ifAbsent:nil.
            digitVal isNil ifTrue:[
                ^ RomanNumberFormatError raiseErrorString:'invalid character'
            ].

            digitVal = prevDigitVal ifTrue:[
                ( #( 1 10 100 1000) includes:digitVal) ifFalse:[
                    ^ RomanNumberFormatError raiseErrorString:'character may not be repeated'
                ].
                val := val + digitVal.
                countSame := countSame + 1.
                countSame >= 4 ifTrue:[
                    digitVal ~= 1000 ifTrue:[
                        countSame > 4 ifTrue:[
                            "/ this is a bad roman number (such as MCCCCCCCCXXXXXXII);
                            "/ Its not correct, but sometimes encountered on buildings.
                            "/ If you do not want to be too picky,
                            "/ provide a proceeding handler in order to proceed the conversion.
                            BadRomanNumberFormatError raiseRequestErrorString:'more than 4 occurrences of same character'
                        ] ifFalse:[
                            "/ this is a naive roman number (such as VIIII);
                            "/ Its not correct, but very often encountered (especially as page numbers).
                            "/ The notification below normally goes unnoticed, unless some input validator
                            "/ wants to be very picky, and treat this as an error.
                            "/ To do so, provide a handler for NaiveRomanNumberFormatNotification.
                            NaiveRomanNumberFormatNotification raiseRequestErrorString:'more than 3 occurrences of same character'.
                        ]
                    ]
                ].
            ] ifFalse:[
                digitVal < prevDigitVal ifTrue:[
                    val := val + digitVal.
                ] ifFalse:[
                    countSame == 1 ifFalse:[
                        ^ RomanNumberFormatError raiseErrorString:'invalid character combination'
                    ].
                    delta := digitVal - prevDigitVal.
                    ( #( 4 9 40 90 400 900) includes:delta) ifFalse:[
                        ^ RomanNumberFormatError raiseErrorString:'invalid character combination'
                    ].
                    val := val - prevDigitVal.
                    val := val + delta.
                    digitVal := prevDigitVal - 0.1.  "/ trick: prevent prevDigit from arriving again.
                ].
                countSame := 1.
            ].
            prevDigitVal := digitVal.
        ].
    ].
"/    val > 5000 ifTrue:[
"/        ^ RomanNumberFormatError raiseErrorString:'number out of range (1..5000)'
"/    ].
    ^ val.

    "
     Integer readFromRomanString:'I'
     Integer readFromRomanString:'II'
     Integer readFromRomanString:'III'
     Integer readFromRomanString:'IV'
     Integer readFromRomanString:'clix'
     Integer readFromRomanString:'MIX'
     Integer readFromRomanString:'MCMXCIX'

   Naive cases (which are accepted):
     Integer readFromRomanString:'IIII'
     Integer readFromRomanString:'VIIII'
     Integer readFromRomanString:'CLXXXXVIIII'

    Error case (not proceedable):
     Integer readFromRomanString:'LC'

    Error case (proceedable):
     Integer readFromRomanString:'MCCCCCCCCXXXXXXIIIIII'

     BadRomanNumberFormatError ignoreIn:[
         Integer readFromRomanString:'MCCCCCCCCXXXXXXIIIIII'
     ]
    "


    "naive cases:
     #(
        'MCMXCIX'           1999
        'MCMXCVIIII'        1999
        'MCMLXXXXIX'        1999
        'MDCCCCXCIX'        1999
        'MDCCCCXCVIIII'     1999
        'MDCCCCLXXXXIX'     1999
        'MDCCCCLXXXXVIIII'  1999
     ) pairWiseDo:[:goodString :expectedValue |
        (Integer readFromRomanString:goodString onError:nil) ~= expectedValue ifTrue:[self halt].
     ]
    "


    "error cases:
      #(
        'XIIX'
        'VV'
        'VVV'
        'XXL'
        'XLX'
        'LC'
        'LL'
        'DD'
     ) do:[:badString |
        (Integer readFromRomanString:badString onError:nil) notNil ifTrue:[self halt].
     ]
    "

    "good cases:
     #( 'I'     1
        'II'    2
        'III'   3
        'IV'    4
        'V'     5
        'VI'    6
        'VII'   7
        'VIII'  8
        'IX'    9
        'X'     10
        'XI'    11
        'XII'   12
        'XIII'  13
        'XIV'   14
        'XV'    15
        'XVI'   16
        'XVII'  17
        'XVIII' 18
        'XIX'   19
        'XX'    20
        'XXX'   30
        'L'     50
        'XL'    40
        'LX'    60
        'LXX'   70
        'LXXX'  80
        'CXL'   140
        'CL'    150
        'CLX'   160
        'MMM'                   3000
        'MMMM'                  4000
        'MMMMCMXCIX'            4999
        'MMMMMMMMMCMXCIX'       9999
     ) pairWiseDo:[:goodString :expectedValue |
        (Integer readFromRomanString:goodString onError:nil) ~= expectedValue ifTrue:[self halt].
     ]
    "

    "
      1 to:9999 do:[:n |
        |romanString|

        romanString := String streamContents:[:stream | n printRomanOn:stream].
        (Integer readFromRomanString:romanString onError:nil) ~= n ifTrue:[self halt].
     ]
    "
!

readFromRomanString:aStringOrStream onError:exceptionalValue
    "convert a string or stream containing a roman representation into an integer.
     Raises an exception, if the inputs format is wrong.
     Does allow reading of naive (more than 3 in a row) and
     bad (not using L and D) roman numbers.
     (Such numbers can be seen on some medevial buildings. "

    |val|

    RomanNumberFormatError
        handle:[:ex |
            val := exceptionalValue value
        ]
        do:[
            val := self readFromRomanString:aStringOrStream
        ].
    ^ val


    "
     Integer readFromRomanString:'I'    onError:nil
     Integer readFromRomanString:'II'   onError:nil
     Integer readFromRomanString:'III'  onError:nil
     Integer readFromRomanString:'IV'   onError:nil
     Integer readFromRomanString:'clix' onError:nil
     Integer readFromRomanString:'MCMXCIX' onError:nil

   Naive cases (which are accepted):
     Integer readFromRomanString:'IIII' onError:nil
     Integer readFromRomanString:'VIIII' onError:nil
     Integer readFromRomanString:'CLXXXXVIIII' onError:nil

   Error cases:
\     Integer readFromRomanString:'LC'   onError:nil
    "

    "error cases:
      #(
        'XIIX'
        'VV'
        'VVV'
        'XXL'
        'XLX'
        'LC'
        'LL'
        'DD'
     ) do:[:badString |
        (Integer readFromRomanString:badString onError:nil) notNil ifTrue:[self halt].
     ]
    "

    "naive (but handled) cases:
      #(
        'IIII'   4
        'VIIII'  9
        'XIIII'  14
        'XVIIII' 19
     ) pairWiseDo:[:goodString :expectedValue |
        (Integer readFromRomanString:goodString onError:nil) ~= expectedValue ifTrue:[self halt].
     ]
    "

    "good cases:
     #( 'I'     1
        'II'    2
        'III'   3
        'IV'    4
        'V'     5
        'VI'    6
        'VII'   7
        'VIII'  8
        'IX'    9
        'X'     10
        'XI'    11
        'XII'   12
        'XIII'  13
        'XIV'   14
        'XV'    15
        'XVI'   16
        'XVII'  17
        'XVIII' 18
        'XIX'   19
        'XX'    20
        'XXX'   30
        'L'     50
        'XL'    40
        'LX'    60
        'LXX'   70
        'LXXX'  80
        'CXL'   140
        'CL'    150
        'CLX'   160
        'MMM'                   3000
        'MMMM'                  4000
        'MMMMCMXCIX'            4999
        'MMMMMMMMMCMXCIX'       9999
     ) pairWiseDo:[:goodString :expectedValue |
        (Integer readFromRomanString:goodString onError:nil) ~= expectedValue ifTrue:[self halt].
     ]
    "

    "
      1 to:9999 do:[:n |
        |romanString|

        romanString := String streamContents:[:stream | n printRomanOn:stream].
        (Integer readFromRomanString:romanString onError:nil) ~= n ifTrue:[self halt].
     ]
    "

    "reading naive numbers:

      1 to:9999 do:[:n |
        |romanString|

        romanString := String streamContents:[:stream | n printRomanOn:stream naive:true].
        (Integer readFromRomanString:romanString onError:nil) ~= n ifTrue:[self halt].
     ]
    "
!

readFromString:aString radix:base onError:exceptionBlock
    "return the next UNSIGNED Integer from the (character-)aString in radix; 
     (assumes that the initial XXr has already been read).
     No whitespace-skipping is done.
     Expects that NO garbage is at the end of the string.
     Returns the value from exceptionBlock, if no valid integer is in the string."

    |str val|

    str := ReadStream on:aString.
    val := self readFrom:str radix:base onError:[^ exceptionBlock value].
    str atEnd ifFalse:[ ^ exceptionBlock value].
    ^ val

    "
     Integer readFromString:'1234' radix:10 onError:[nil] 
     Integer readFromString:'-1234' radix:10 onError:[nil]  - I only read unsigned numbers
     Integer readFromString:' 1234' radix:10 onError:[nil]  - I do not skip whitespace
     Integer readFromString:'1234 ' radix:10 onError:[nil]  - I do not accept anything after the number

    "
! !

!Integer class methodsFor:'Compatibility-Squeak'!

readFrom:aStringOrStream base:aBase
    "for squeak compatibility"

    ^ self readFrom:aStringOrStream radix:aBase
! !

!Integer class methodsFor:'Signal constants'!

bcdConversionErrorSignal
    "return the signal which is raised when bcd conversion fails
     (i.e. when trying to decode an invalid BCD number)"

    ^ BCDConversionErrorSignal

    "Modified: / 15.11.1999 / 20:35:20 / cg"
! !

!Integer class methodsFor:'class initialization'!

initialize
    BCDConversionErrorSignal isNil ifTrue:[
        BCDConversionErrorSignal := ConversionError newSignal.
        BCDConversionErrorSignal nameClass:self message:#bcdConversionErrorSignal.
        BCDConversionErrorSignal notifierString:'bcd conversion error'.
    ].

    "Modified: / 15.11.1999 / 20:36:04 / cg"
! !

!Integer class methodsFor:'constants'!

epsilon
    "return the maximum relative spacing"

    "don't know, what to really return here.
     Returning 1 gives stupid values when doing some taylor series approximations
     (although it is correct)"

    ^ Float epsilon.

    "
     2 sqrt_withAccuracy:(Integer epsilon)
     2 sqrt_withAccuracy:1
    "
!

unity
    "return the neutral element for multiplication (1)"

    ^ 1

    "Modified: 18.7.1996 / 12:26:43 / cg"
!

zero
    "return the neutral element for addition (0)"

    ^ 0

    "Modified: 18.7.1996 / 12:26:38 / cg"
! !


!Integer class methodsFor:'prime numbers'!

flushPrimeCache
    "cleanup after using a primeCache.
     See comment in initializePrimeCacheUpTo:limit"

    PrimeCache := nil.

    "
     Integer initializePrimeCacheUpTo:1000000
     Integer flushPrimeCache.
    "
!

initializePrimeCacheUpTo:limit
    "if many operations are to be done using primes, we can keep them around...
     You will need n/8/2 bytes to keep fast info about primes up to n
     (i.e. 100Mb is good for primes up to 1.6*10^9)"

    |bits|

    PrimeCache := nil.
    bits := BooleanArray new:limit//2.
    self primesUpTo:limit do:[:p |
        bits at:p//2 put:true
    ].
    PrimeCache := bits.

    "
     Integer initializePrimeCacheUpTo:1000000.
     Integer initializePrimeCacheUpTo:10000000.
     Integer initializePrimeCacheUpTo:100000000.
     Integer initializePrimeCacheUpTo:1000000000.
     Integer flushPrimeCache.
    "

    "
     Integer flushPrimeCache.
     Transcript showCR:(
        Time millisecondsToRun:[ 1 to:100000 do:[:n | n isPrime] ]
     ).
     Integer initializePrimeCacheUpTo:100000.
     Transcript showCR:(
        Time millisecondsToRun:[ 1 to:100000 do:[:n | n isPrime] ]
     ).
     Integer flushPrimeCache.
    "
!

largePrimesUpTo: max do: aBlock
    "Evaluate aBlock with all primes up and including maxValue.
     The Algorithm is adapted from http://www.rsok.com/~jrm/printprimes.html
     It encodes prime numbers much more compactly than #primesUpTo:
     38.5 integer per byte (2310 numbers per 60 byte) allow for some fun large primes.
     (all primes up to SmallInteger maxVal can be computed within ~27MB of memory;
     the regular #primesUpTo: would require 4 *GIGA*bytes).
     Note: The algorithm could be re-written to produce the first primes (which require
     the longest time to sieve) faster but only at the cost of clarity."

    | limit flags maskBitIndex bitIndex maskBit byteIndex index primesUpTo2310 indexLimit |

    limit := max asInteger.
    indexLimit := max sqrt truncated + 1.
    "Create the array of flags."
    flags := ByteArray new: (limit + 2309) // 2310 * 60 + 60.
    flags atAllPut: 16rFF. "set all to true"

    "Compute the primes up to 2310"
    primesUpTo2310 := self primesUpTo: 2310.

    "Create a mapping from 2310 integers to 480 bits (60 byte)"
    maskBitIndex := Array new: 2310.
    bitIndex := -1. "for pre-increment"
    maskBitIndex at: 1 put: (bitIndex := bitIndex + 1).
    maskBitIndex at: 2 put: (bitIndex := bitIndex + 1).

    1 to: 5 do:[:i| aBlock value: (primesUpTo2310 at: i)].

    index := 6.
    2 to: 2309 do:[:n|
        [(primesUpTo2310 at: index) < n]
            whileTrue:[index := index + 1].
        n = (primesUpTo2310 at: index) ifTrue:[
            maskBitIndex at: n+1 put: (bitIndex := bitIndex + 1).
        ] ifFalse:[
            "if modulo any of the prime factors of 2310, then could not be prime"
            (n \\ 2 = 0 or:[n \\ 3 = 0 or:[n \\ 5 = 0 or:[n \\ 7 = 0 or:[n \\ 11 = 0]]]])
                    ifTrue:[maskBitIndex at: n+1 put: 0]
                    ifFalse:[maskBitIndex at: n+1 put: (bitIndex := bitIndex + 1)].
        ].
    ].

    "Now the real work begins...
    Start with 13 since multiples of 2,3,5,7,11 are handled by the storage method;
    increment by 2 for odd numbers only."
    13 to: limit by: 2 do:[:n|
        (maskBit := maskBitIndex at: (n \\ 2310 + 1)) = 0 ifFalse:["not a multiple of 2,3,5,7,11"
            byteIndex := n // 2310 * 60 + (maskBit-1 bitShift: -3) + 1.
            bitIndex := 1 bitShift: (maskBit bitAnd: 7).
            ((flags at: byteIndex) bitAnd: bitIndex) = 0 ifFalse:["not marked -- n is prime"
                aBlock value: n.
                "Start with n*n since any integer < n has already been sieved
                (e.g., any multiple of n with a number k < n has been cleared
                when k was sieved); add 2 * i to avoid even numbers and
                mark all multiples of this prime. Note: n < indexLimit below
                limits running into LargeInts -- nothing more."
                n < indexLimit ifTrue:[
                    index := n * n.
                    (index bitAnd: 1) = 0 ifTrue:[index := index + n].
                    [index <= limit] whileTrue:[
                        (maskBit := maskBitIndex at: (index \\ 2310 + 1)) = 0 ifFalse:[
                            byteIndex := (index // 2310 * 60) + (maskBit-1 bitShift: -3) + 1.
                            maskBit := 255 - (1 bitShift: (maskBit bitAnd: 7)).
                            flags at: byteIndex put: ((flags at: byteIndex) bitAnd: maskBit).
                        ].
                        index := index + (2 * n)].
                ].
            ].
        ].
    ].

    "
     Integer largePrimesUpTo:1000000 do:[:i | i > 900000 ifTrue:[self halt] ]
     (Integer primesUpTo:1000000) inspect
    "
!

primeCacheSize
    "see comment in initializePrimeCacheUpTo:limit"

    ^ PrimeCache size * 2

    "
     Integer initializePrimeCacheUpTo:1000.
     Integer initializePrimeCacheUpTo:1000000.
     Integer initializePrimeCacheUpTo:1000000000.
     Integer flushPrimeCache.
    "

    "
     Integer flushPrimeCache.
     Transcript showCR:(
        Time millisecondsToRun:[ 1 to:100000 do:[:n | n isPrime] ]
     ).
     Integer initializePrimeCacheUpTo:100000.
     Transcript showCR:(
        Time millisecondsToRun:[ 1 to:100000 do:[:n | n isPrime] ]
     ).
     Integer flushPrimeCache.
    "
!

primesUpTo5000
    "return a table of primes up to 5000.
     Primes are heavily used to compute good container sizes in Set and Dictionary,
     and in some cryprographic algorithms."

    ^ #(
            2 3   5   7  11  13  17  19  23  29  31  37  41  43  47  53  59  61  67  71
             73  79  83  89  97 101 103 107 109 113 127 131 137 139 149 151 157 163 167
            173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271
            277 281 283 293 307 311 313 317 331 337 347 349 353 359 367 373 379 383 389
            397 401 409 419 421 431 433 439 443 449 457 461 463 467 479 487 491 499 503
            509 521 523 541 547 557 563 569 571 577 587 593 599 601 607 613 617 619 631
            641 643 647 653 659 661 673 677 683 691 701 709 719 727 733 739 743 751 757
            761 769 773 787 797 809 811 821 823 827 829 839 853 857 859 863 877 881 883
            887 907 911 919 929 937 941 947 953 967 971 977 983 991 997

            1009 1013 1019 1021 1031 1033 1039 1049 1051 1061 1063 1069 1087 1091 1093
            1097 1103 1109 1117 1123 1129 1151 1153 1163 1171 1181 1187 1193 1201 1213
            1217 1223 1229 1231 1237 1249 1259 1277 1279 1283 1289 1291 1297 1301 1303
            1307 1319 1321 1327 1361 1367 1373 1381 1399 1409 1423 1427 1429 1433 1439
            1447 1451 1453 1459 1471 1481 1483 1487 1489 1493 1499 1511 1523 1531 1543
            1549 1553 1559 1567 1571 1579 1583 1597 1601 1607 1609 1613 1619 1621 1627
            1637 1657 1663 1667 1669 1693 1697 1699 1709 1721 1723 1733 1741 1747 1753
            1759 1777 1783 1787 1789 1801 1811 1823 1831 1847 1861 1867 1871 1873 1877
            1879 1889 1901 1907 1913 1931 1933 1949 1951 1973 1979 1987 1993 1997 1999
            
            2003 2011 2017 2027 2029 2039 2053 2063 2069 2081 2083 2087 2089 2099 2111 
            2113 2129 2131 2137 2141 2143 2153 2161 2179 2203 2207 2213 2221 2237 2239 
            2243 2251 2267 2269 2273 2281 2287 2293 2297 2309 2311 2333 2339 2341 2347 
            2351 2357 2371 2377 2381 2383 2389 2393 2399 2411 2417 2423 2437 2441 2447 
            2459 2467 2473 2477 2503 2521 2531 2539 2543 2549 2551 2557 2579 2591 2593 
            2609 2617 2621 2633 2647 2657 2659 2663 2671 2677 2683 2687 2689 2693 2699 
            2707 2711 2713 2719 2729 2731 2741 2749 2753 2767 2777 2789 2791 2797 2801 
            2803 2819 2833 2837 2843 2851 2857 2861 2879 2887 2897 2903 2909 2917 2927 
            2939 2953 2957 2963 2969 2971 2999 

            3001 3011 3019 3023 3037 3041 3049 3061 3067 3079 3083 3089 3109 3119 3121 
            3137 3163 3167 3169 3181 3187 3191 3203 3209 3217 3221 3229 3251 3253 3257 
            3259 3271 3299 3301 3307 3313 3319 3323 3329 3331 3343 3347 3359 3361 3371 
            3373 3389 3391 3407 3413 3433 3449 3457 3461 3463 3467 3469 3491 3499 3511 
            3517 3527 3529 3533 3539 3541 3547 3557 3559 3571 3581 3583 3593 3607 3613 
            3617 3623 3631 3637 3643 3659 3671 3673 3677 3691 3697 3701 3709 3719 3727 
            3733 3739 3761 3767 3769 3779 3793 3797 3803 3821 3823 3833 3847 3851 3853 
            3863 3877 3881 3889 3907 3911 3917 3919 3923 3929 3931 3943 3947 3967 3989 

            4001 4003 4007 4013 4019 4021 4027 4049 4051 4057 4073 4079 4091 4093 4099 
            4111 4127 4129 4133 4139 4153 4157 4159 4177 4201 4211 4217 4219 4229 4231 
            4241 4243 4253 4259 4261 4271 4273 4283 4289 4297 4327 4337 4339 4349 4357 
            4363 4373 4391 4397 4409 4421 4423 4441 4447 4451 4457 4463 4481 4483 4493 
            4507 4513 4517 4519 4523 4547 4549 4561 4567 4583 4591 4597 4603 4621 4637 
            4639 4643 4649 4651 4657 4663 4673 4679 4691 4703 4721 4723 4729 4733 4751 
            4759 4783 4787 4789 4793 4799 4801 4813 4817 4831 4861 4871 4877 4889 4903 
            4909 4919 4931 4933 4937 4943 4951 4957 4967 4969 4973 4987 4993 4999
        ).
!

primesUpTo: max
    "Return a list of prime integers up to and including the given integer."

    |cls|

    "/ sigh: IntegerArray is in libbasic2...
    (IntegerArray notNil 
    and:[ max < IntegerArray maxVal]) ifTrue:[
        cls := IntegerArray.
    ] ifFalse:[
        cls := Array.
    ].

    ^ cls streamContents:[:s| self primesUpTo: max do:[:prime| s nextPut: prime]]

    "
     Integer primesUpTo: 100
     Integer primesUpTo: 13
     (Integer primesUpTo: 100) select:[:p | p between:10 and:99]
    "

    "
     |p N a b|

     N := 1000.
     p := 1.
     a := (1 to:1000)
         collect:[:i | p := p nextPrime. p ]
         thenSelect:[:p | p <= N].
     b := Integer primesUpTo:N.
     self assert:(a = b)
    "
    "
     |p N a b|

     N := 1000 nextPrime.
     p := 1.
     a := (1 to:1000)
         collect:[:i | p := p nextPrime. p ]
         thenSelect:[:p | p <= N].
     b := Integer primesUpTo:N.
     self assert:(a = b)
    "
    "
     |p N a b|

     N := 1000 nextPrime-1.
     p := 1.
     a := (1 to:1000)
         collect:[:i | p := p nextPrime. p ]
         thenSelect:[:p | p <= N].
     b := Integer primesUpTo:N.
     self assert:(a = b)
    "
    "
     |p N a b|

     N := 100000.
     p := 1.
     a := (1 to:N)
         collect:[:i | p := p nextPrime. p ]
         thenSelect:[:p | p <= N].
     b := Integer primesUpTo:N.
     self assert:(a = b)
    "
    "
     |p N a b|

     N := 100000 nextPrime.
     p := 1.
     a := (1 to:N)
         collect:[:i | p := p nextPrime. p ]
         thenSelect:[:p | p <= N].
     b := Integer primesUpTo:N.
     self assert:(a = b)
    "
    "
     |p N a b|

     N := 100000 nextPrime-1.
     p := 1.
     a := (1 to:N)
         collect:[:i | p := p nextPrime. p ]
         thenSelect:[:p | p <= N].
     b := Integer primesUpTo:N.
     self assert:(a = b)
    "
!

primesUpTo: max do: aBlock
    "Compute aBlock with all prime integers up to and including the given integer.
     See comment in initializePrimeCacheUpTo:limit"

    | limit 
      iLimit "{ Class: SmallInteger }"
      flags 
      prime "{ Class: SmallInteger }"
      k "{ Class: SmallInteger }"
      wellKnownPrimes|

    wellKnownPrimes := self primesUpTo5000.  
    max <= (wellKnownPrimes last+1) ifTrue:[
        wellKnownPrimes do:[:p |
            p > max ifTrue:[^ self].
            aBlock value:p.
        ].
        ^ self.
    ].
    
    max <= self primeCacheSize ifTrue:[
        aBlock value:2.
        3 to:max by:2 do:[:p |
            (PrimeCache at:p//2) ifTrue:[
                aBlock value:p
            ].
        ].
        ^ self.
    ].

    limit := max asInteger - 1.
    "Fall back into #largePrimesUpTo:do: if we'd require more than 100k of memory;
    the alternative will only requre 1/154th of the amount we need here and is almost as fast."
    limit > 25000 ifTrue:[^ self largePrimesUpTo: max do: aBlock].

    iLimit := limit.
    
    "/ sieve, on the fly
    flags := ByteArray new: iLimit.
    aBlock value: 2.
    
    2 to: iLimit by:2 do: [:i |
        (flags at: i) == 0 ifTrue: [
            prime := i + 1.
            k := i + prime.
            [k <= iLimit] whileTrue: [
                flags at: k put: 1.
                k := k + prime
            ].
            aBlock value: prime
        ]
    ].

    "
     Integer primesUpTo: 100
     Integer primesUpTo:20000 do:[:p | ]
    "
! !

!Integer class methodsFor:'queries'!

hasSharedInstances
    "return true if this class has shared instances, that is, instances
     with the same value are identical.
     Although not always shared (LargeIntegers), these should be treated
     so, to be independent of the number of bits in a SmallInt"

    ^ true


!

isAbstract
    "Return if this class is an abstract class.
     True is returned for Integer here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == Integer
! !


!Integer methodsFor:'Compatibility-Dolphin'!

highWord
    "return the high 16 bits of a 32 bit value"

    ^ self bitShift:-16

    "
     (16r12345678 highWord) hexPrintString
     (16r12345678 lowWord) hexPrintString
    "
!

lowWord
    "return the low 16 bits of a 32 bit value"

    ^ self bitAnd:16rFFFF

    "
     (16r12345678 lowWord) hexPrintString
     (16r12345678 highWord) hexPrintString
    "
!

mask:integerMask set:aBoolean
    "Answer the result of setting/resetting the specified mask in the receiver."

    ^ aBoolean
            ifTrue:  [self bitOr:integerMask]
            ifFalse: [self bitClear:integerMask]

    "turn on the 1-bit:
         |v|

         v := 2r0100.
         v mask:1 set:true

     turn off the 1-bit:
         |v|

         v := 2r0101.
         v mask:1 set:false
    "
!

maskClear:aMaskInteger
    "return an integer with all bits cleared which are set in aMaskInteger.
     An alias for bitClear: for compatibility."

    ^ self bitClear:aMaskInteger

    "
     3 maskClear:1
    "
!

maskSet:aMaskInteger
    "return an integer with all bits set which are set in aMaskInteger.
     An alias for bitSet: for compatibility."

    ^ self bitOr:aMaskInteger
!

printStringRadix:aRadix padTo:sz
    "return a printed representation of the receiver in a given radix,
     padded with zeros (at the left) up to size.
     If the printString is longer than size,
     it is returned unchanged (i.e. not truncated).
     See also printStringRadix:size:fill:"

    ^ self printStringRadix:aRadix size:sz fill:$0

    "
     1024 printStringRadix:16 padTo:4
     16rABCD printStringRadix:16 padTo:3
     1024 printStringRadix:2 padTo:16
     1024 printStringRadix:16 padTo:8
    "
!

| aNumber
    "return the bitwise-or of the receiver and the argument, anInteger.
     Same as bitOr: - added for compatibility with Dolphin Smalltalk.
     Notice:
        PLEASE DO NOT USE | for integers in new code; it makes the code harder
        to understand, as it may be not obvious, whether a boolean-or a bitWise-or is intended.
        For integers, use bitOr: to make the intention explicit.
        Also, consider using or: for booleans, which is does not evaluate the right part if the left is true."

    ^ self bitOr:aNumber

    "
     14 | 1
     9 & 8
    "
! !

!Integer methodsFor:'Compatibility-Squeak'!

asByteArray
    "return my hexBytes in MSB.
     Do not use:
        This is a very stupid squeak-compatibility method,
        as normally, you'd expect the bytes to be ordered in the machine's natve order"

    ^ self digitBytesMSB
!

asByteArrayOfSize:size
    "return my hexBytes in MSB, optionally padded at the left with zeros"

    "(((
        | repeats number |
        repeats := 1000000.
        number := 123456789123456789123456789123456789123456789123456789.
         [repeats timesRepeat: (number asByteArrayOfSize: 1024) ] timeToRun.
     )))"

    | bytes bytesSize|

    bytes := self digitBytesMSB.
    bytesSize := bytes size.
    size < bytesSize ifTrue: [
        ^ ConversionError raiseRequestWith:self errorString:'number too big for ', size asString
    ].
    ^ (ByteArray new:size)
            replaceFrom:size-bytesSize+1 to:size with:bytes startingAt:1.

    "
     123 asByteArrayOfSize:1 #[123]
     123 asByteArrayOfSize:2 #[0 123]
     123 asByteArrayOfSize:4 #[0 0 0 123]

     255 asByteArrayOfSize:1 #[255]

     256 asByteArrayOfSize:1
     256 asByteArrayOfSize:2
     256 asByteArrayOfSize:4
    "
!

atRandom
    "return a random number between 1 amd myself"

    ^ self atRandom:Random.

    "
     100 atRandom
     1000 atRandom
    "
!

atRandom:aRandomGenerator
    "return a random number between 1 and myself"

    self < 1 ifTrue:[^ self].
    ^ aRandomGenerator nextIntegerBetween:1 and:self

    "
     100 atRandom:(Random new)
     1000 atRandom:(Random new)
    "
!

printLeftPaddedWith:padChar to:size base:base
    "prints left-padded"

    ^ (self printStringRadix:base) leftPaddedTo:size with:padChar

    "
     1234 printPaddedWith:$0 to:4 base:16
     1234 printLeftPaddedWith:$0 to:4 base:16
     128 printLeftPaddedWith:$0 to:2 base:16
    "
!

printPaddedWith:padChar to:size base:base
    "attention: prints right-padded; see printLeftPadded."

    ^ (self printStringRadix:base) paddedTo:size with:padChar

    "
     1234 printPaddedWith:$0 to:4 base:16
    "
!

printStringBase:base
    "return my printString in a base;
     same as printStringRadix:"

    ^ self printStringRadix:base

    "
     1234 printStringBase:16
    "
!

printStringHex
    "return my printString in base 16;
     same as printStringRadix:"

    ^ self printStringRadix:16

    "
     4096 printStringHex
    "
!

printStringRoman
    "return my roman printString;
     almost the same as romanPrintString:"

    "funny - although the romans did not have negative numbers - squeak has"
    self negative ifTrue:[
        ^ '-' , self negated romanPrintString
    ].
    ^ self romanPrintString
!

raisedTo:exp modulo:mod
    ^ self raisedTo:exp mod:mod
! !

!Integer methodsFor:'Compatibility-V''Age'!

<< aNumber
    "V'Age compatibility: left shift"

    ^ self bitShift:aNumber

    "
     1 << 5
     64 << -5
    "
!

>> aNumber
    "V'Age compatibility: right shift"

    ^ self bitShift:(aNumber negated)

    "
     1 >> -5
     64 >> 5
    "
! !



!Integer methodsFor:'bcd conversion'!

decodeFromBCD
    "return a number representing the value of the BCD encoded receiver."

    |v rslt multiplier nibble|

    v := self.
    rslt := 0.
    multiplier := 1.
    [v > 0] whileTrue:[
        nibble := v bitAnd:16r0F.
        nibble > 9 ifTrue:[
            ^ BCDConversionErrorSignal
                    raiseRequestWith:self
                    errorString:'bad BCD coded value'
        ].
        rslt := rslt + (nibble * multiplier).
        multiplier := multiplier * 10.
        v := v bitShift:-4.
    ].
    ^ rslt

    "
     16r1234567890123 decodeFromBCD
     16r1073741823 decodeFromBCD
     16r1073741824 decodeFromBCD
     16r1073741825 decodeFromBCD

     16r55 decodeFromBCD
     16r127 decodeFromBCD
     16r800000 decodeFromBCD
     16r8000000 decodeFromBCD
     16r80000000 decodeFromBCD
     16r800000000 decodeFromBCD
     16r127567890 decodeFromBCD
     16r1234567890 decodeFromBCD

     16r5A decodeFromBCD
     16rFF decodeFromBCD
    "

    "Modified: / 15.11.1999 / 20:37:20 / cg"
!

encodeAsBCD
    "return a BCD encoded number representing the same value as the
     receiver."

    |v rslt shift|

    v := self.
    rslt := shift := 0.
    [v > 0] whileTrue:[
        rslt := rslt + ((v \\ 10) bitShift:shift).
        shift := shift + 4.
        v := v // 10.
    ].
    ^ rslt

    "
     55 encodeAsBCD hexPrintString
     127 encodeAsBCD hexPrintString
     127 encodeAsBCD hexPrintString
     8912345 encodeAsBCD hexPrintString
     89123456 encodeAsBCD hexPrintString
     891234567 encodeAsBCD hexPrintString
     900000000 encodeAsBCD hexPrintString
     1073741823 encodeAsBCD hexPrintString
     1073741824 encodeAsBCD hexPrintString
     1073741825 encodeAsBCD hexPrintString
     1891234567 encodeAsBCD hexPrintString
     8912345678 encodeAsBCD hexPrintString
     1234567890 encodeAsBCD hexPrintString
    "

! !

!Integer methodsFor:'bit operators'!

allMask:aMaskInteger
    "return true if all 1-bits in aMaskInteger are also 1 in the receiver"

    ^ (self bitAnd:aMaskInteger) == aMaskInteger

    "2r00001111 allMask:2r00000001"
    "2r00001111 allMask:2r00011110"
    "2r00001111 allMask:2r00000000"
!

anyMask:aMaskInteger
    "return true if any 1-bits in anInteger is also 1 in the receiver.
     (somewhat incorrect, if the mask is zero)"

    ^ (self bitAnd:aMaskInteger) ~~ 0

    "2r00001111 anyMask:2r00000001"
    "2r00001111 anyMask:2r11110000"
!

bitAnd:aMaskInteger
    "return the bitwise-and of the receiver and the argument, anInteger.
     This is a general and slow implementation, walking over the bytes of
     the receiver and the argument."

    |n "{ Class: SmallInteger }"
     result byte|

    aMaskInteger isInteger ifFalse:[
        ^ aMaskInteger bitAndFromInteger:self.
    ].

    n := (aMaskInteger digitLength) min:(self digitLength).
    result := self class basicNew numberOfDigits:n.

    1 to:n do:[:index |
        byte := (aMaskInteger digitAt:index) bitAnd:(self digitAt:index).
        result digitAt:index put:byte.
    ].
    (byte == 0 or:[n <= SmallInteger maxBytes]) ifTrue:[
        ^ result compressed
    ].
    ^ result

    "
     (16r112233445566778899 bitAnd:16rFF                ) printStringRadix:16
     (16r112233445566778899 bitAnd:16rFFFFFFFFFFFFFFFF00) printStringRadix:16
     (16r112233445566778899 bitAnd:16rFF0000000000000000) printStringRadix:16
     (16r112233445566778899 bitAnd:16r00000000000000FFFF) printStringRadix:16
    "

    "Modified: 5.11.1996 / 14:06:26 / cg"
!

bitClear:aMaskInteger
    "return the bitwise-and of the receiver and the complement of the argument, anInteger,
     returning the receiver with bits of the argument cleared.
     (i.e. the same as self bitAnd:aMaskInteger bitInvert).
     This is a general and slow implementation, walking over the bytes of
     the receiver and the argument."

    |n "{ Class: SmallInteger }"
     result byte|

    n := (aMaskInteger digitLength) max:(self digitLength).
    result := self class basicNew numberOfDigits:n.

    1 to:n do:[:index |
        byte :=  (self digitAt:index) bitClear:(aMaskInteger digitAt:index).
        result digitAt:index put:byte.
    ].
    (byte == 0 or:[n <= SmallInteger maxBytes]) ifTrue:[
        ^ result compressed
    ].
    ^ result
!

bitCount
    "return the number of 1-bits in the receiver"

    |n "{ Class: SmallInteger }"
     cnt byte|

    n := self digitLength.
    cnt := 0.

    1 to:n do:[:index |
        byte := self digitAt:index.
        cnt := cnt + (byte bitCount)
    ].
    ^ cnt

     "
      2r100000000000000000000000000000000000000000000000000000000001 bitCount
      2r111111111111111111111111111111111111111111111111111111111111111111 bitCount
      100 factorial bitCount -> 207
      1000 factorial bitCount -> 3788
     "

    "Modified (comment): / 09-01-2012 / 19:51:00 / cg"
!

bitInvert
    "return a new integer, where all bits are complemented.
     This does not really make sense for negative largeIntegers,
     since the digits are stored as absolute value.
     Q: is this specified in a language standard ?"

"/    ^ -1 - self

    |n      "{ Class: SmallInteger }"
     byte   "{ Class: SmallInteger }"
     result|

    n := self digitLength.
    result := self class basicNew numberOfDigits:n.

    1 to:n do:[:index |
        byte := self digitAt:index.
        byte := byte bitInvert bitAnd:16rFF.
        result digitAt:index put:byte.
    ].
    (byte == 0 or:[n <= SmallInteger maxBytes]) ifTrue:[
        "if last byte is zero we can normalize"
        ^ result compressed
    ].
    ^ result

    "
     16rff bitInvert bitAnd:16rff
     16rffffffff bitInvert
     16rff00ff00 bitInvert hexPrintString
    "
!

bitInvertByte
    "return a new integer, where the low 8 bits are masked and complemented.
     This returns an unsigned version of what bitInvert would return.
     (i.e. same as self bitInvert bitAnd:16rFF)"

    ^ (self digitAt:1) bitInvert bitAnd:16rFF
    
    "
     16rff bitInvert
     16rff bitInvertByte
    "
!

bitOr:aMaskInteger
    "return the bitwise-or of the receiver and the argument, anInteger.
     This is a general and slow implementation, walking over the bytes of
     the receiver and the argument."

    |n "{ Class: SmallInteger }"
     result byte|

    aMaskInteger isInteger ifFalse:[
        ^ aMaskInteger bitOrFromInteger:self.
    ].

    n := (aMaskInteger digitLength) max:(self digitLength).
    result := self class basicNew numberOfDigits:n.

    1 to:n do:[:index |
        byte := (aMaskInteger digitAt:index) bitOr:(self digitAt:index).
        result digitAt:index put:byte.
    ].
"/ no need to normalize - if the operands were correct
"/    byte == 0 ifTrue:[
"/        ^ result normalize
"/    ].
    ^ result
!

bitShift:shiftCount
    "return the value of the receiver shifted by shiftCount bits;
     leftShift if shiftCount > 0; rightShift otherwise.

     Notice: the result of bitShift: on negative receivers is not
             defined in the language standard (since the implementation
             is free to choose any internal representation for integers)
             However, ST/X preserves the sign."

    |result
     prev       "{ Class: SmallInteger }"
     next       "{ Class: SmallInteger }"
     byte       "{ Class: SmallInteger }"
     byte2      "{ Class: SmallInteger }"
     bitShift   "{ Class: SmallInteger }"
     revShift   "{ Class: SmallInteger }"
     digitShift "{ Class: SmallInteger }"
     nn         "{ Class: SmallInteger }"
     nDigits    "{ Class: SmallInteger }" |

    shiftCount isInteger ifFalse:[
        ^ shiftCount bitShiftFromInteger:self.
    ].

    shiftCount > 0 ifTrue:[
        "left shift"

        nDigits := self digitLength.
        digitShift := shiftCount // 8.
        bitShift := shiftCount \\ 8.

        "
         modulo 8 shifts can be done faster ...
        "
        bitShift == 0 ifTrue:[
            nn := nDigits + digitShift.
            result := self class basicNew numberOfDigits:nn sign:self sign.
            result digitBytes replaceFrom:(digitShift + 1) to:nn with:self digitBytes.
            "
             no normalize needed, since receiver was already normalized
            "
            ^ result
        ].

        "
         less-than-8 shifts can be done faster ...
        "
        digitShift == 0 ifTrue:[
            nn := nDigits+1.
            result := self class basicNew numberOfDigits:nn sign:self sign.
            prev := 0.
            1 to:nDigits do:[:index |
                byte := self digitAt:index.
                byte := (byte bitShift:bitShift) bitOr:prev.
                result digitAt:index put:(byte bitAnd:16rFF).
                prev := byte bitShift:-8.
            ].
            result digitAt:nn put:prev.
            "
             might have stored a 0-byte ...
            "
            prev == 0 ifTrue:[
                ^ result compressed
            ].
            ^ result.
        ].

        "
         slow case ...
        "
        nn := nDigits + digitShift + 1.
        result := self class basicNew numberOfDigits:nn sign:self sign.
        byte := self digitAt:1.
        byte := (byte bitShift:bitShift) bitAnd:16rFF.
        result digitAt:(digitShift + 1) put:byte.
        revShift := -8 + bitShift.
        2 to:nDigits do:[:index |
            byte := self digitAt:index.
            byte2 := self digitAt:index-1.
            byte := byte bitShift:bitShift.
            byte2 := byte2 bitShift:revShift.
            byte := (byte bitOr:byte2) bitAnd:16rFF.
            result digitAt:(index + digitShift) put:byte.
        ].
        byte2 := self digitAt:nDigits.
        byte2 := (byte2 bitShift:revShift) bitAnd:16rFF.
        result digitAt:(nDigits + digitShift + 1) put:byte2.
        "
         might have stored a 0-byte ...
        "
        byte2 == 0 ifTrue:[
            ^ result compressed
        ].
        ^ result
    ].

    shiftCount < 0 ifTrue:[
        "right shift"

        nDigits := self digitLength.
        digitShift := shiftCount negated // 8.
        bitShift := shiftCount negated \\ 8.

        digitShift >= nDigits ifTrue:[
            ^ 0
        ].

        "
         modulo 8 shifts can be done faster ...
        "
        bitShift == 0 ifTrue:[
            nn := nDigits-digitShift.
            result := self class basicNew numberOfDigits:nn sign:self sign.
            result digitBytes replaceFrom:1 to:nn with:self digitBytes startingAt:(digitShift + 1) .
            nn <= SmallInteger maxBytes ifTrue:[
                ^ result compressed
            ].
            ^ result
        ].

        "
         less-than-8 shifts can be done faster ...
        "
        digitShift == 0 ifTrue:[
            result := self class basicNew numberOfDigits:nDigits sign:self sign.
            prev := 0.
            bitShift := bitShift negated.
            revShift := 8 + bitShift.
            nDigits to:1 by:-1 do:[:index |
                byte := self digitAt:index.
                next := (byte bitShift:revShift) bitAnd:16rFF.
                byte := (byte bitShift:bitShift) bitOr:prev.
                result digitAt:index put:(byte bitAnd:16rFF).
                prev := next.
            ].
            ^ result compressed
        ].

        "
         slow case ...
        "
        nn := nDigits-digitShift.
        result := self class basicNew numberOfDigits:nn sign:self sign.

        prev := 0.
        bitShift := bitShift negated.
        revShift := 8 + bitShift.
        nn := digitShift + 1.
        nDigits to:nn by:-1 do:[:index |
            byte := self digitAt:index.
            next := (byte bitShift:revShift) bitAnd:16rFF.
            byte := (byte bitShift:bitShift) bitOr:prev.
            result digitAt:(index - digitShift) put:byte.
            prev := next.
        ].
        "the last stored byte ..."
        ^ result compressed
    ].

    ^ self "no shift"

    "Modified: / 8.7.1998 / 12:45:24 / cg"
    "Modified: / 5.5.1999 / 16:05:05 / stefan"
!

bitTest:aMaskInteger
    "return true, if any bit from aMask is set in the receiver.
     I.e. true, if the bitwise-AND of the receiver and the argument, anInteger
     is non-0, false otherwise.
     This is a general and slow implementation, walking over the bytes of
     the receiver and the argument."

    |n "{ Class: SmallInteger }"
     byte|

    n := (aMaskInteger digitLength) min:(self digitLength).

    1 to:n do:[:index |
        byte := (aMaskInteger digitAt:index) bitAnd:(self digitAt:index).
        byte ~~ 0 ifTrue:[^ true].
    ].
    ^ false

    "
     16r112233445566778899 bitTest:16rFF
     16r112233445566778800 bitTest:16rFF
     16r112233445566778899 bitTest:16rFFFFFFFFFFFFFFFF00
     16r112233445566778899 bitTest:16rFF0000000000000000
     16r112233445566778899 bitTest:16r00000000000000FFFF
     16r1234567800000000 bitTest:16r8000000000000000
     16r8765432100000000 bitTest:16r8000000000000000
     16r12345678 bitTest:16r80000000
     16r87654321 bitTest:16r80000000
    "

    "Modified: / 6.6.1999 / 15:10:33 / cg"
!

bitXor:anInteger
    "return the bitwise-or of the receiver and the argument, anInteger.
     This is a general and slow implementation, walking over the bytes of
     the receiver and the argument."

    |n "{ Class: SmallInteger }"
     result byte|

    anInteger isInteger ifFalse:[
        ^ anInteger bitXorFromInteger:self.
    ].

    n := (anInteger digitLength) max:(self digitLength).
    result := self class basicNew numberOfDigits:n.

    1 to:n do:[:index |
        byte := (anInteger digitAt:index) bitXor:(self digitAt:index).
        result digitAt:index put:byte.
    ].
    (byte == 0 or:[n <= SmallInteger maxBytes]) ifTrue:[
        ^ result compressed
    ].
    ^ result

    "
     (16r112233445566778899 bitXor:16rFF                ) printStringRadix:16 '112233445566778866'
     (16r112233445566778899 bitXor:16rFFFFFFFFFFFFFFFF00) printStringRadix:16 'EEDDCCBBAA99887799'
     (16r112233445566778899 bitXor:16rFF0000000000000000) printStringRadix:16 'EE2233445566778899'
     (16r112233445566778899 bitXor:16r112233445566778800) printStringRadix:16
    "

    "Modified: 5.11.1996 / 14:06:40 / cg"
!

changeMask:mask to:aBooleanOrNumber
    "return a new number where the specified mask-bit is on or off,
     depending on aBooleanOrNumber.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withMask:changedTo:"

    (aBooleanOrNumber == 0 or:[aBooleanOrNumber == false]) ifTrue:[
        ^ self bitClear:mask
    ].
    ^ self bitOr:mask

    "
     (16r3fffffff changeMask:16r80 to:0) hexPrintString
     (16r3fff0000 changeMask:16r80 to:1) hexPrintString
    "
!

even
    "return true if the receiver is even"

    ^ (self bitAt:1) == 0

    "
     16r112233445566778899 even
     16r112233445566778800 even
     1 even
     2 even
    "

    "Created: / 6.6.1999 / 15:00:40 / cg"
!

highBit
    "return the bitIndex of the highest bit set. 
     The returned bitIndex starts at 1 for the least significant bit.
     Returns 0 if no bit is set."

    |byteNr highByte|

    byteNr := self digitLength.
    byteNr == 0 ifTrue:[
        ^ 0
    ].
    highByte := self digitAt:byteNr.
    ^ (byteNr - 1) * 8 + highByte highBit

    "
     0 highBit
     -1 highBit
     (1 bitShift:1) highBit
     (1 bitShift:30) highBit
     (1 bitShift:31) highBit
     (1 bitShift:32) highBit
     (1 bitShift:33) highBit
     (1 bitShift:64) highBit
     (1 bitShift:1000) highBit
     (1 bitShift:1000) negated highBit
     ((1 bitShift:64)-1) highBit
    "

    "Modified: / 3.5.1999 / 09:20:57 / stefan"
!

leftShift:shiftCount
    "return the value of the receiver shifted left by shiftCount bits;
     leftShift if shiftCount > 0; rightShift otherwise.

     Notice: the result of bitShift: on negative receivers is not
             defined in the language standard (since the implementation
             is free to choose any internal representation for integers)
             However, ST/X preserves the sign."

    ^ self bitShift:shiftCount

    "
     16r100000000 leftShift:1
     16r100000000 negated leftShift:1
    "
!

lowBit
    "return the bitIndex of the lowest bit set. The returned bitIndex
     starts at 1 for the least significant bit.
     Returns 0 if no bit is set."

    |maxBytes "{ Class: SmallInteger }"
     byte|

    maxBytes := self digitLength.
    1 to:maxBytes do:[:byteIndex |
        byte := self digitAt:byteIndex.
        byte ~~ 0 ifTrue:[
            ^ (byteIndex-1)*8 + (byte lowBit)
        ].
    ].
    ^ 0 "/ should not happen

    "
     0 lowBit
     1 lowBit
     (1 bitShift:1) lowBit
     (1 bitShift:1) highBit
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
    "

    "Modified: 1.3.1997 / 16:54:23 / cg"
!

noMask:aMaskInteger
    "return true if no 1-bit in anInteger is 1 in the receiver"

    ^ (self bitAnd:aMaskInteger) == 0

    "
     2r00001111 noMask:2r00000001
     2r00001111 noMask:2r11110000
    "
!

odd
    "return true if the receiver is odd"

    ^ (self bitAt:1) == 1

    "
     16r112233445566778899 odd
     16r112233445566778800 odd
     1 odd
     2 odd
    "

    "Created: / 6.6.1999 / 15:00:55 / cg"
!

rightShift:shiftCount
    "return the value of the receiver shifted right by shiftCount bits;
     rightShift if shiftCount > 0; leftShift otherwise.

     Notice: the result of bitShift: on negative receivers is not
             defined in the language standard (since the implementation
             is free to choose any internal representation for integers)
             However, ST/X preserves the sign."

    ^ self bitShift:(shiftCount negated)

    "
     16r100000000 rightShift:1
     16r100000000 negated rightShift:1

     16r100000000 rightShift:2
     16r100000000 negated rightShift:2

     16r100000000 rightShift:3
     16r100000000 negated rightShift:3

     ((16r100000000 rightShift:1) rightShift:1) rightShift:1
     ((16r100000000 negated rightShift:1) rightShift:1) rightShift:1
    "
! !

!Integer methodsFor:'bit operators - indexed'!

bitAt:index
    "return the value of the index's bit (index starts at 1) as 0 or 1.
     Notice: the result of bitAt: on negative receivers is not
             defined in the language standard (since the implementation
             is free to choose any internal representation for integers)"

    |i "{Class: SmallInteger}"|

    i := index - 1.
    i < 0 ifTrue:[
        ^ SubscriptOutOfBoundsError
                raiseRequestWith:index
                errorString:'index out of bounds'
    ].
    ^ (self digitAt:(i // 8 + 1)) bitAt:(i \\ 8 + 1)

    "
     1 bitAt:1                     => 1
     1 bitAt:2                     => 0
     1 bitAt:0                     index error
     2r1000100010001000100010001000100010001000100010001000 bitAt:48 => 1
     2r1000100010001000100010001000100010001000100010001000 bitAt:47 => 0

     (1 bitShift:1000) bitAt:1000  => 0
     (1 bitShift:1000) bitAt:1001  => 1
     (1 bitShift:1000) bitAt:1002  => 0

     (1 bitShift:30) bitAt:30
     (1 bitShift:30) bitAt:31
     (1 bitShift:30) bitAt:32
     (1 bitShift:31) bitAt:31
     (1 bitShift:31) bitAt:32
     (1 bitShift:31) bitAt:33
     (1 bitShift:32) bitAt:32
     (1 bitShift:32) bitAt:33
     (1 bitShift:32) bitAt:34
     (1 bitShift:64) bitAt:64
     (1 bitShift:64) bitAt:65
     (1 bitShift:64) bitAt:66
    "
!

bitIndicesOfOneBitsDo:aBlock
    "evaluate aBlock for all indices of a 1-bit, starting with the index of the lowest bit.
     The index for the least significant bit is 1."

    1 to:self digitLength do:[:i8 |
        |byte|

        byte := self digitAt:i8.
        byte ~~ 0 ifTrue:[
            1 to:8 do:[:i |
                (byte bitAt:i) == 1 ifTrue:[
                    aBlock value:(((i8-1)*8) + i).
                ].
            ].
        ]
    ].

    "
     1 bitIndicesOfOneBitsDo:[:i | Transcript showCR:i].
     2 bitIndicesOfOneBitsDo:[:i | Transcript showCR:i]
     4 bitIndicesOfOneBitsDo:[:i | Transcript showCR:i]
     12 bitIndicesOfOneBitsDo:[:i | Transcript showCR:i]
     127 bitIndicesOfOneBitsDo:[:i | Transcript showCR:i]
    "
!

bitIndicesOfOneBitsReverseDo:aBlock
    "evaluate aBlock for all indices of a 1-bit, starting with the index of the highest
     and ending with the lowest bit.
     The index for the least significant bit is 1."

    self digitLength downTo:1 do:[:i8 |
        |byte|

        byte := self digitAt:i8.
        byte ~~ 0 ifTrue:[
            8 downTo:1 do:[:i |
                (byte bitAt:i) == 1 ifTrue:[
                    aBlock value:(((i8-1)*8) + i).
                ].
            ].
        ]
    ].

    "
     1 bitIndicesOfOneBitsReverseDo:[:i | Transcript showCR:i].
     2 bitIndicesOfOneBitsReverseDo:[:i | Transcript showCR:i]
     4 bitIndicesOfOneBitsReverseDo:[:i | Transcript showCR:i]
     12 bitIndicesOfOneBitsReverseDo:[:i | Transcript showCR:i]
     127 bitIndicesOfOneBitsReverseDo:[:i | Transcript showCR:i]
    "
!

changeBit:index to:aBooleanOrNumber
    "return a new number where the specified bit is on or off,
     depending on aBooleanOrNumber.
     Bits are counted from 1 starting with the least significant.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBit:changedTo:"

    (aBooleanOrNumber == 0 or:[aBooleanOrNumber == false]) ifTrue:[
        ^ self clearBit:index
    ].
    ^ self setBit:index

    "
     (16r3fffffff changeBit:31 to:1) hexPrintString
     (16r3fffffff asLargeInteger setBit:31) hexPrintString
    "
!

clearBit:index
    "return a new integer where the specified bit is off.
     Bits are counted from 1 starting with the least significant.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBitCleared:"

    |n         "{ Class: SmallInteger }"
     byteIndex "{ Class: SmallInteger }"
     bitIndex  "{ Class: SmallInteger }"
     result byte|

    index <= 0 ifTrue:[
        ^ SubscriptOutOfBoundsSignal
                raiseRequestWith:index
                errorString:'bit index out of bounds'
    ].
    byteIndex := ((index - 1) // 8) + 1.
    n := self digitLength.
    byteIndex > n ifTrue:[
        ^ self
    ].

    result := self simpleDeepCopy.
    bitIndex := ((index - 1) \\ 8) + 1.
    byte := (result digitAt:byteIndex) clearBit:bitIndex.
    result digitAt:byteIndex put:byte.
    (byte == 0 or:[n == byteIndex and:[n <= SmallInteger maxBytes]]) ifTrue:[
        ^ result compressed
    ].
    ^ result

    "
     3111111111 clearBit:1
    "

    "Modified: / 28.7.1998 / 18:35:50 / cg"
!

invertBit:index
    "return a new number where the specified bit is inverted.
     Bits are counted from 1 starting with the least significant.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBitInverted:"

    index <= 0 ifTrue:[
        ^ SubscriptOutOfBoundsSignal
                raiseRequestWith:index
                errorString:'index out of bounds'
    ].
    ^ self bitXor:(1 bitShift:index-1)

    "
     0 invertBit:3         => 4 (2r100)
     0 invertBit:48        => 140737488355328 (2r1000.....000)
     ((0 invertBit:99) invertBit:100) printStringRadix:2
    "
!

isBitClear:index
    "return true if the index' bit is clear; false otherwise.
     Bits are counted from 1 starting with the least significant."

    ^ (self bitAt:index) == 0

    "
     5 isBitClear:1       => false
     5 isBitClear:2       => true
     5 isBitClear:3       => false
     5 isBitClear:4       => true
     5 isBitClear:10000   => true
     2r0101 isBitClear:2  => true
     2r0101 isBitClear:1  => false
     2r0101 isBitClear:0  index error
    "
!

isBitSet:index
    "return true if the index' bit is set; false otherwise.
     Bits are counted from 1 starting with the least significant."

    ^ (self bitAt:index) ~~ 0

    "
     5 isBitSet:3       => true
     2r0101 isBitSet:2  => false
     2r0101 isBitSet:1  => true
     2r0101 isBitSet:0  index error
    "
!

setBit:index
    "return a new integer, where the specified bit is on.
     Bits are counted from 1 starting with the least significant.
     The method's name may be misleading: the receiver is not changed,
     but a new number is returned. Should be named #withBitSet:"

    index <= 0 ifTrue:[
        ^ SubscriptOutOfBoundsSignal
                raiseRequestWith:index
                errorString:'index out of bounds'
    ].
    ^ self bitOr:(1 bitShift:index-1)

    "
     0 setBit:3         => 4 (2r100)
     0 setBit:48        => 140737488355328 (2r1000.....000)
     ((0 setBit:99) setBit:100) printStringRadix:2
    "
! !

!Integer methodsFor:'byte access'!

byteAt:anIndex
    "compatibility with ByteArrays etc."

    ^ self digitAt:anIndex

    "
        12345678 byteAt:2
        12345678 digitBytes at:2

        -12345678 byteAt:2
        -12345678 digitBytes at:2
    "
!

byteSwapped32
    "a fallback, in case unimplemented in concrete classes.
     Not actually used"
    
    ^ ((self digitAt:1) bitShift:24)
    + ((self digitAt:2) bitShift:16)
    + ((self digitAt:3) bitShift:8)
    + (self digitAt:4)

    "
     16r12345678901234567890 byteSwapped32
    "
!

byteSwapped64
    "a fallback, in case unimplemented in concrete classes.
     Not actually used"
    
    ^ ((self digitAt:1) bitShift:56)
    + ((self digitAt:2) bitShift:48)
    + ((self digitAt:3) bitShift:40)
    + ((self digitAt:4) bitShift:32)
    + ((self digitAt:5) bitShift:24)
    + ((self digitAt:6) bitShift:16)
    + ((self digitAt:7) bitShift:8)
    + (self digitAt:8)

    "
     16r1234567890123456789 byteSwapped64 hexPrintString
    "
!

digitByteLength
    <resource: #obsolete>
    "return the number bytes required for a 2's complement
     binary representation of this Integer."

    self obsoleteMethodWarning:'use signedDigitLength - attention: return value fixed'.
    ^ self signedDigitLength

    "
     -127 digitByteLength
     -128 digitByteLength
     -129 digitByteLength
     -32769 digitByteLength
     32768 digitByteLength
    "
!

digitBytes
    "return a byteArray filled with the receiver's bits
     (8 bits of the absolute value per element),
     least significant byte is first"

    ^ self subclassResponsibility
!

digitBytesMSB
    "return a byteArray filled with the receiver's bits
     (8 bits of the absolute value per element),
     most significant byte is first"

    ^ self subclassResponsibility
!

digitBytesMSB:msbFlag
    "return a byteArray filled with the receiver's bits
     (8 bits of the absolute value per element),
     if msbflag = true, most significant byte is first,
     otherwise least significant byte is first"

    msbFlag ifTrue:[
        ^ self digitBytesMSB.
    ].
    ^ self digitBytes

    "
      16r12 digitBytesMSB:true
      16r1234 digitBytesMSB:true
      16r1234 digitBytesMSB:false
      16r12345678 digitBytesMSB:true
      16r12345678 digitBytesMSB:false
    "
!

signedDigitLength
    "return the number bytes required for a 2's complement
     binary representation of this Integer.
     I.e. the number of bytes from which we have to sign extent the highest bit"    

    |absLen "{ Class: SmallInteger }" |

    self >= 0 ifTrue:[
        absLen := self digitLength.
        (self digitByteAt:absLen) >= 16r80 ifTrue:[
            ^ absLen + 1.
        ].
        ^ absLen.
    ].

    absLen := self negated digitLength.
    (self digitByteAt:absLen) < 16r80 ifTrue:[
            ^ absLen + 1
    ].
    ^ absLen

    "
     0 signedDigitLength
     1 signedDigitLength
     126 signedDigitLength
     127 signedDigitLength
     128 signedDigitLength

     255 signedDigitLength
     256 signedDigitLength
     257 signedDigitLength

     32767 signedDigitLength    
     32768 signedDigitLength    

     -1 signedDigitLength
     -127 signedDigitLength
     -128 signedDigitLength
     -129 signedDigitLength

     -32767 signedDigitLength    
     -32768 signedDigitLength    
     -32769 signedDigitLength    
    "
!

swapBytes
    "swap bytes pair-wise in a positive integer
     i.e. a.b.c.d -> b.a.d.c
     Swapping of negative integers is undefined and therefore not supported."

    |digitBytes|

    self negative ifTrue:[
        RangeError raiseWith:self errorString:'negative numbers are not supported in #swapBytes'.
    ].
    digitBytes := self digitBytes.
    digitBytes size odd ifTrue:[
        "ByteArray<<#swapBytes needs even number of bytes.
         Add 0 to the most significant position (the end)"
        digitBytes := digitBytes copyWith:0.

    ].
    ^ (LargeInteger digitBytes:digitBytes swapBytes) compressed

    "
        16rFFEE2211 swapBytes hexPrintString
        16rFFEEAA2211 swapBytes hexPrintString
        16r2211 swapBytes hexPrintString
        16rFF3FFFFF swapBytes
        self assert:(SmallInteger maxVal swapBytes swapBytes == SmallInteger maxVal)
    "
! !

!Integer methodsFor:'coercing & converting'!

asFixedPoint
    "return the receiver as a fixedPoint number"

    ^ FixedPoint basicNew
        setNumerator:self denominator:1 scale:1

    "
     100 asFixedPoint
     100 asFixedPoint + 0.1 asFixedPoint
    "

    "Modified: 5.11.1996 / 15:13:17 / cg"
!

asFixedPoint:scale
    "return the receiver as fixedPoint number, with the given number
     of post-decimal-point digits."

    ^ FixedPoint basicNew
        setNumerator:self denominator:1 scale:scale

    "
     100 asFixedPoint:2
     100 asFixedPoint + (0.1 asFixedPoint:2)
    "

    "Modified: 10.1.1997 / 20:00:08 / cg"
!

asFloat
    "return a Float with same value as myself.
     Since floats have a limited precision, you usually loose bits when doing this."

    ^ Float fromInteger:self

    "
     1234567890 asFloat
     1234567890 asFloat asInteger
     12345678901234567890 asFloat
     12345678901234567890 asFloat asInteger
    "
!

asFraction
    "return a Fraction with same value as receiver"

    ^ Fraction basicNew setNumerator:self denominator:1

    "Modified: 28.7.1997 / 19:26:06 / cg"
!

asInteger
    "return the receiver truncated towards zero -
     for integers this is self"

    ^ self
!

asLargeFloat
    "return a LargeFloat with same value as myself.
     Since largeFloats have a limited precision, you usually loose bits when
     doing this."

    ^ LargeFloat fromInteger:self

    "
     1234567890 asLargeFloat
     1234567890 asLargeFloat asInteger
     12345678901234567890 asLargeFloat
     12345678901234567890 asLargeFloat asInteger
    "
!

asLongFloat
    "return a LongFloat with same value as myself.
     Since longFloats have a limited precision, you usually loose bits when
     doing this."

    ^ LongFloat fromInteger:self

    "
     1234567890 asFloat
     1234567890 asFloat asInteger
     12345678901234567890 asFloat
     12345678901234567890 asFloat asInteger
    "
!

asModuloNumber
    "return a precomputed modulo number"

    ^ ModuloNumber modulus:self.

    "Created: / 3.5.1999 / 14:48:03 / stefan"
!

asShortFloat
    "return a ShortFloat with same value as receiver"

    ^ ShortFloat fromInteger:self
!

signExtended24BitValue
    "return an integer from sign-extending the 24'th bit.
     i.e. interprets the lowest 24 bits as a signed integer,
     ignoring higher bits.
     This may be useful for communication interfaces"

    ^ (self bitAnd:16rFFFFFF) signExtended24BitValue

    "
     16r800000 signExtended24BitValue
     16r7FFFFF signExtended24BitValue
     16rFFFFFF signExtended24BitValue
    "

    "Modified: / 07-05-1996 / 09:31:57 / cg"
    "Created: / 05-03-2012 / 14:37:55 / cg"
    "Modified (comment): / 26-02-2016 / 19:39:52 / cg"
!

signExtendedByteValue
    "return an integer from sign-extending the 8'th bit.
     i.e. interprets the lowest 8 bits as a signed integer,
     ignoring higher bits.
     This may be useful for communication interfaces"

    ^ (self bitAnd:16rFF) signExtendedByteValue

    "
     16r80 signExtendedByteValue
     16r7F signExtendedByteValue
     16rFF signExtendedByteValue
    "

    "Created: / 07-05-1996 / 09:31:52 / cg"
    "Modified (comment): / 26-02-2016 / 19:39:46 / cg"
!

signExtendedFromBit:bitNr
    "return an integer from sign-extending the n'th bit.
     i.e. interprets the lowest n bits as a signed integer,
     ignoring higher bits.
     The bit numbering is 1-based (i.e. the lowest bit has bitNr 1)    
     This may be useful for communication interfaces"

    |masked|

    masked := self bitAnd:((1 bitShift:bitNr)-1).
    (self isBitSet:bitNr) ifTrue:[
        ^ masked - (1 bitShift:bitNr)
    ].
    ^ masked

    "
     16r800008 signExtendedFromBit:4  
     16r7FFF07 signExtendedFromBit:4  
     16r7FFF0F signExtendedFromBit:4 

     16rFFFFFF signExtendedFromBit:8
     16rFFFF7F signExtendedFromBit:8
    "

    "Modified (comment): / 26-02-2016 / 19:42:18 / cg"
!

signExtendedLongLongValue
    "return an integer from sign-extending the 64'th bit.
     i.e. interprets the lowest 64 bits as a signed integer,
     ignoring higher bits.
     This may be useful for communication interfaces"

    (self bitTest:16r8000000000000000) ifTrue:[
        ^ (self bitAnd:16rFFFFFFFFFFFFFFFF) - 16r10000000000000000
    ].
    ^ (self bitAnd:16r7FFFFFFFFFFFFFFF)

    "
     16r1238000000000000000 signExtendedLongLongValue
     16r1237FFFFFFFFFFFFFFF signExtendedLongLongValue
     16r123FFFFFFFFFFFFFFFF signExtendedLongLongValue
    "

    "Modified (comment): / 26-02-2016 / 19:38:55 / cg"
!

signExtendedLongValue
    "return an integer from sign-extending the 32'th bit.
     i.e. interprets the lowest 32 bits as a signed integer,
     ignoring higher bits.
     This may be useful for communication interfaces"

    (self bitTest:16r80000000) ifTrue:[
        ^ (self bitAnd:16rFFFFFFFF) - 16r100000000
    ].
    ^ (self bitAnd:16r7FFFFFFF)

    "
     16r80000000 signExtendedLongValue
     16r7FFFFFFF signExtendedLongValue
     16rFFFFFFFF signExtendedLongValue
    "

    "Modified (comment): / 26-02-2016 / 19:39:09 / cg"
!

signExtendedShortValue
    "return an integer from sign-extending the 16'th bit.
     i.e. interprets the lowest 16 bits as a signed integer,
     ignoring higher bits.
     This may be useful for communication interfaces"

    ^ (self bitAnd:16rFFFF) signExtendedShortValue

    "
     16r8000 signExtendedShortValue
     16r7FFF signExtendedShortValue
     16rFFFF signExtendedShortValue

     16r1238000 signExtendedShortValue
     16r1237FFF signExtendedShortValue
     16r123FFFF signExtendedShortValue
    "

    "Modified: / 07-05-1996 / 09:31:57 / cg"
    "Modified (comment): / 26-02-2016 / 19:39:37 / cg"
! !

!Integer methodsFor:'comparing'!

hash
    "redefined to return smallInteger hashValues"

    ^ self bitAnd:SmallInteger maxVal.

    "
        -20000000000000 hash
         20000000000000 hash
    "

    "Created: / 14.11.1996 / 12:12:27 / cg"
    "Modified: / 24.2.1998 / 10:07:29 / stefan"
! !


!Integer methodsFor:'dependents access'!

addDependent:anObject
    Transcript show:'*** trying to make dependent on an integer: '.
    thisContext sender printOn:Transcript. Transcript cr.

    "Created: / 28-07-2010 / 20:29:00 / cg"
! !

!Integer methodsFor:'double dispatching'!

differenceFromFraction:aFraction
    "sent when a fraction does not know how to subtract the receiver, an integer"

    |d|

    d := aFraction denominator.
    ^ aFraction class
        numerator:(aFraction numerator - (self * d))
        denominator:d

    "Modified: 28.7.1997 / 19:08:30 / cg"
!

differenceFromTimestamp:aTimestamp
    "I am to be interpreted as seconds, return the timestamp this number of seconds
     before aTimestamp"

    ^ aTimestamp subtractSeconds:self.

    "
     Timestamp now subtractSeconds:100
     100 differenceFromTimestamp:Timestamp now
    "
!

equalFromFraction:aFraction
    "that should never be invoked, as fractions are always normalized to integers
     if resulting from an arithmetic operation.
     However, this implementation is for subclasses (i.e. fixed point) and also
     allows comparing unnormalized fractions as might appear within the fraction class"

    |denominator numerator|

    denominator := aFraction denominator.
    numerator := aFraction numerator.
    (denominator == 1) ifFalse:[
        ^ numerator = (self * denominator)
    ].
    ^ numerator = self
!

productFromFraction:aFraction
    "sent when a fraction does not know how to multiply the receiver, an integer"

    ^ aFraction class
        numerator:(self * aFraction numerator)
        denominator:aFraction denominator

    "Modified: 28.7.1997 / 19:08:27 / cg"
!

quotientFromFraction:aFraction
    "Return the quotient of the argument, aFraction and the receiver.
     Sent when aFraction does not know how to divide by the receiver."

    ^ aFraction class
        numerator:aFraction numerator
        denominator:(self * aFraction denominator)

    "Modified: 28.7.1997 / 19:08:23 / cg"
!

sumFromFraction:aFraction
    "sent when a fraction does not know how to add the receiver, an integer"

    |d|

    d := aFraction denominator.
    ^ aFraction class
        numerator:(aFraction numerator + (self * d))
        denominator:d

    "Modified: 28.7.1997 / 19:08:11 / cg"
!

sumFromTimestamp:aTimestamp
    "I am to be interpreted as seconds, return the timestamp this number of seconds
     after aTimestamp"

    ^ aTimestamp addSeconds:self.

    "
     Timestamp now addSeconds:100
     100 sumFromTimestamp:Timestamp now
    "
! !

!Integer methodsFor:'helpers'!

gcd_helper:anInteger
    "a helper for the greatest common divisor of the receiver and anInteger.
     Knuth's algorithm for large positive integers, with receiver being
     larger than the arg."

    | a b aLowBit bLowBit shift t |

    a := self.
    b := anInteger.

    aLowBit := a lowBit - 1.
    bLowBit := b lowBit - 1.
    shift := aLowBit min:bLowBit.
    b := b bitShift:(bLowBit negated).
    [a = 0] whileFalse:[
        a := a bitShift:(aLowBit negated).
        a < b ifTrue:[
            t := a. a := b. b := t
        ].
        a := a - b.
        aLowBit := a lowBit - 1.
    ].
    ^ b bitShift:shift

    "Created: 1.3.1997 / 16:38:17 / cg"
    "Modified: 1.3.1997 / 16:45:17 / cg"
! !


!Integer methodsFor:'iteration'!

to:stop collect:aBlock
    "syntactic sugar; same as (self to:stop) collect:aBlock"

    |n a|

    n := stop - self + 1.
    a := Array new:n.
    self to:stop do:[:i |
        a at:(i-self+1) put:(aBlock value:i).
    ].
    ^ a.

    "
     1 to:10 collect:[:i | i squared]
     10 to:20 collect:[:i | i squared]
     (10 to:20) collect:[:i | i squared]
    "
! !

!Integer methodsFor:'misc math'!

acker:n
    "return the value of acker(self, n).
     ;-) Do not try with receivers > 3"

    (self == 0) ifTrue:[^ n + 1].
    (n == 0) ifTrue:[^ (self - 1) acker: 1].
    ^ (self - 1) acker:(self acker:(n - 1))

    "
     3 acker:2
     3 acker:7
    "

    "Modified: 18.7.1996 / 13:08:16 / cg"
!

binco:kIn
    "an alternative name for the binomial coefficient for squeak compatibility"

    ^ self binomialCoefficient:kIn

    "Modified: / 17-08-2010 / 17:29:07 / cg"
!

binomialCoefficient:k
    "The binomial coefficient (n over k)

      / n \     with self being n, and 0 <= k <= n.
      \ k /

     is the number of ways of picking k unordered outcomes from n possibilities,
     also known as a combination or combinatorial number.
     Sometimes also called C(n,k) (for choose k from n)

     binCo is defined as:
        n!!
     ----------
     k!! (n-k)!!

     but there is a faster, recursive formula:

      / n \  = / n - 1 \  + / n - 1 \
      \ k /    \ k - 1 /    \   k   /

     with:

      / n \  = / n \  =  1
      \ 0 /    \ n /
    "

    |kRun acc|

    k > self ifTrue:[^ 0].

    kRun := k.
    kRun > (self / 2) ifTrue:[
        "/ symmetry
        kRun := self - kRun.
    ].

    acc := 1.
    1 to:kRun do:[:i |
        acc := acc * (self - kRun + i) / i.
    ].
    ^ acc

    "
     (7 binomialCoefficient:3)
     (10 binomialCoefficient:5)
     (100 binomialCoefficient:5)
     (1000 binomialCoefficient:5)

     TestCase assert: (10 binomialCoefficient:5) = (10 factorial / (5 factorial * 5 factorial))
     TestCase assert: (100 binomialCoefficient:78) = (100 factorial / (78 factorial * (100-78) factorial))
     TestCase assert: (1000 binomialCoefficient:5) = (1000 factorial / (5 factorial * (1000-5) factorial))
     TestCase assert: (10000 binomialCoefficient:78) = (10000 factorial / (78 factorial * (10000-78) factorial))

     Time millisecondsToRun:[ (10000 binomialCoefficient:78) ]                            -> 0
     Time millisecondsToRun:[ (10000 factorial / (78 factorial * (10000-78) factorial)) ] -> 130

    "
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

     This may be redefined in some integer classes for
     more performance (where the remainder is generated as a side effect of division)"

    ^ Array
        with:(self // aNumber)
        with:(self \\ aNumber)

    "
     10 divMod:3       -> #(3 1)   because 3*3 + 1 = 10
     10 divMod:-3      -> #(-4 -2) because -4*-3 + (-2) = 10
     -10 divMod:3      -> #(-4 2) because -4*-3 + 2 = -10
     -10 divMod:-3     -> #(3 -1)  because -3*3 + (-1) = -10

     1000000000000000000000 divMod:3   -> #(333333333333333333333 1)
     1000000000000000000000 divMod:-3  -> #(-333333333333333333334 -2)
     -1000000000000000000000 divMod:3  -> #(-333333333333333333334 2)
     -1000000000000000000000 divMod:-3 -> #(333333333333333333333 -1)
     100 factorial divMod:103
    "

    "Modified: 29.10.1996 / 21:18:58 / cg"
!

extendedEuclid:tb
    "return the solution of 'ax + by = gcd(a,b)'.
     An array containing x, y and gcd(a,b) is returned."

    |a b gcd gcd1 u u1 v v1 tmp t swap shift "{SmallInteger}"|

    self < tb ifTrue:[
        a := self.
        b := tb.
        swap := false.
    ] ifFalse:[
        a := tb.
        b := self.
        swap := true.
    ].

    shift := ((a lowBit) min:(b lowBit))-1.
    shift > 0 ifTrue:[
        tmp := shift negated.
        a := a bitShift:tmp.
        b := b bitShift:tmp.
    ].

    gcd  := a.
    gcd1 := b.
    u := 1.
    u1 := 0.
    v := 0.
    v1 := 1.

    [
        "/      The following condition is true:
        "/        (a * u1) + (b * v1) ~= gcd1 ifTrue:[self halt].
        t := gcd1 divMod:gcd.
        gcd1 := gcd.
        gcd := t at:2.
        t := t at:1.
        tmp := v.
        "/ v1 - (v * t) - v1 + (v * t) ~= 0 ifTrue:[self halt].
        v := v1 - (v * t).
        v1 := tmp.
        tmp := u.
        "/ u1 - (u * t) - u1 + (u * t) ~= 0 ifTrue:[self halt].
        u := u1 - (u * t).
        u1 := tmp.
    gcd > 0] whileTrue.

    shift > 0 ifTrue:[
        gcd1 := gcd1 bitShift:shift.
    ].

    swap ifTrue:[
        ^ Array with:v1 with:u1 with:gcd1.
    ].
    ^ Array with:u1 with:v1 with:gcd1.


    "
     14 extendedEuclid:5
     14 extendedEuclid:2
     25 extendedEuclid:15
    "

    "Created: / 27.4.1999 / 15:19:22 / stefan"
    "Modified: / 18.11.1999 / 16:19:24 / stefan"
!

factorial
    "return fac(self) (i.e. 1*2*3...*self).
     This chooses a good algorithm, based on the receiver.
     Some heuristics here, which has to do with the speed of largeInteger arithmetic."

    (self <= 20) ifTrue:[
        self < 0 ifTrue:[
            "/
            "/ requested factorial of a negative number
            "/
            ^ self class
                raise:#domainErrorSignal
                receiver:self
                selector:#factorial
                arguments:#()
                errorString:'factorial of negative number'
        ].
        ^ #(1 1 2 6 24 120 720 5040 40320 362880 3628800 39916800
          479001600 6227020800 87178291200 1307674368000 20922789888000 
          355687428096000 6402373705728000 121645100408832000
          2432902008176640000) at:self+1
    ].
    
"/    self < 80000 ifTrue:[
"/        ^ self factorialHalf
"/    ].    
    ^ self factorialEvenOdd

    "
     10 factorial
     100 factorial
     1000 factorial
     10000 factorial
     100000 factorial
     200000 factorial
     300000 factorial
     1000000 factorial

     Time millisecondsToRun:[10000 factorial]40
     Time millisecondsToRun:[100000 factorial]3220
     Time millisecondsToRun:[1000000 factorial]357120

    #(factorialIter factorialHalf factorialEvenOdd factorial)
    do:[:sel |
      #( (10000 10) 
         (20000 10)
         (50000 10)
         (70000 10)
         (100000 5)
         (200000 3)
         (300000 3)
         (400000 3)) pairsDo:[:n :repeat |
         |times|
        times := (1 to:repeat) collect:[:i |
                Time millisecondsToRun:[ n perform:sel]
               ].

        Transcript printf:'%12s %6d: %5d\n' with:sel with:n with:times min 
      ]
    ].

    factorialIter  10000:    30
    factorialIter  20000:   130
    factorialIter  50000:   790
    factorialIter  70000:  1710
    factorialIter 100000:  4880
    factorialIter 200000: 24980
    factorialIter 300000: 60060
    factorialIter 400000: 112310
    factorialHalf  10000:    20
    factorialHalf  20000:   100
    factorialHalf  50000:   690
    factorialHalf  70000:  1430
    factorialHalf 100000:  3220
    factorialHalf 200000: 28340
    factorialHalf 300000: 68740
    factorialHalf 400000: 127490
    factorialEvenOdd  10000:    10
    factorialEvenOdd  20000:    60
    factorialEvenOdd  50000:   390
    factorialEvenOdd  70000:   810
    factorialEvenOdd 100000:  2020
    factorialEvenOdd 200000:  9960
    factorialEvenOdd 300000: 24480
    factorialEvenOdd 400000: 45340
    factorial  10000:    20
    factorial  20000:   100
    factorial  50000:   680
    factorial  70000:  1400
    factorial 100000:  2040
    factorial 200000: 10130
    factorial 300000: 24670
    "
!

factorialEvenOdd
    "a recursive odd-even algorithm, which processes smaller largeInts in the loop."

    |pO i s2 t stop|

    (self <= 20) ifTrue:[
        ^ #(1 1 2 6 24 120 720 5040 40320 362880 3628800 39916800
          479001600 6227020800 87178291200 1307674368000 20922789888000 
          355687428096000 6402373705728000 121645100408832000
          2432902008176640000) at:self+1
    ].

    "/
    "/ 3 * 4 * 5 * 6 *7 * 8 .... * n
    "/ odd numbers:
    "/   3 5 7 9 ... n
    "/ even numbers:
    "/   2 4 6 8 ... n
    "/   1 2 3 4 ... n//2
    "/ is (n/2)!! << n-1
                 
    pO := 1.
    i := 3.
 
    "/ odds only in pairs as
    "/      i * (i + 2)
    "/ to get to the next pair,
    "/      (i+4)(i+6)
    "/ we add: 8i + 24
    "/ (i+4)(i+6)-(i*(i+2))
    "/ i^2 + 10i + 24 - i^2 - 2i
    "/ 8i + 24
    stop := self-2.
    t := i*(i+2).
    [i <= stop] whileTrue:[
        "/ odd*next odd
        pO := pO * t.
        t := t + ((i*8) + 24).
        i := i + 4.
    ].
    
    [i <= self] whileTrue:[
        "/ odd
        pO := pO * i.
        i := i + 2.
    ].

    "/ the factorial of the evens...
    s2 := (self//2).
    ^ (s2 factorialEvenOdd * pO) << s2.

    "
     (6 to:2000) conform:[:i | i factorialIter = i factorialEvenOdd]
     
     Time millisecondsToRun:[20000 factorialIter]
     Time millisecondsToRun:[50000 factorialIter]
     Time millisecondsToRun:[70000 factorialIter]
     Time millisecondsToRun:[100000 factorialIter]
     Time millisecondsToRun:[200000 factorialIter] 

     Time millisecondsToRun:[20000 factorialEvenOdd]
     Time millisecondsToRun:[50000 factorialEvenOdd]
     Time millisecondsToRun:[70000 factorialEvenOdd]
     Time millisecondsToRun:[100000 factorialEvenOdd]
     Time millisecondsToRun:[200000 factorialEvenOdd]
    "
!

factorialHalf
    "an algorithm, which does it with half the number of multiplications.
     this is faster than factorialPM to roughly 60000."

    |p i d|

    i := self.
    self odd ifTrue:[
        i := i - 1.
    ].

    p := i.
    d := i - 2.
    [d >= 2] whileTrue:[
        i := i + d.
        p := p * i.
        d := d - 2.
    ].
    self odd ifTrue:[
        p := p * self
    ].
    ^ p

    "
     10 factorial 3628800
     10 factorialHalf 3628800

     11 factorial 39916800
     11 factorialHalf 39916800

     12 factorial 479001600
     12 factorialHalf 479001600

     10000 factorial = 10000 factorialHalf

     (6 to:2000) conform:[:i | i factorialIter = i factorialHalf]

     Time microsecondsToRun:[30 factorialIter]
     Time microsecondsToRun:[30 factorialHalf]
     Time microsecondsToRun:[50 factorialIter]
     Time microsecondsToRun:[50 factorialHalf]
     Time microsecondsToRun:[75 factorialIter]
     Time microsecondsToRun:[75 factorialHalf]
     Time microsecondsToRun:[100 factorialIter]
     Time microsecondsToRun:[100 factorialHalf]
     Time microsecondsToRun:[500 factorialIter]
     Time microsecondsToRun:[500 factorialHalf]
     Time microsecondsToRun:[1000 factorialIter]
     Time microsecondsToRun:[1000 factorialHalf]
     Time microsecondsToRun:[2000 factorialIter]
     Time microsecondsToRun:[2000 factorialHalf]

     Time microsecondsToRun:[500 factorial]118 120 120
     Time microsecondsToRun:[1000 factorial]339 355 406
     Time microsecondsToRun:[5000 factorial]15703 13669 7715
     Time millisecondsToRun:[10000 factorial]40 30 50
     Time millisecondsToRun:[20000 factorial]140 150 150
     Time millisecondsToRun:[40000 factorial]600 570 560 570
     Time millisecondsToRun:[60000 factorial]1220 1240 1340
     Time millisecondsToRun:[80000 factorial]2600 2580 2540
     Time millisecondsToRun:[100000 factorial]4680 4810 5280
     Time millisecondsToRun:[120000 factorial]8100 8010 7920
     Time millisecondsToRun:[150000 factorial]13830 14040 13360
     Time millisecondsToRun:[200000 factorial]23880 23740

     Time microsecondsToRun:[500 factorialHalf]150 142 192
     Time microsecondsToRun:[1000 factorialHalf]383 527 684
     Time microsecondsToRun:[5000 factorialHalf]6654 9221 4629
     Time millisecondsToRun:[10000 factorialHalf]20 30 20
     Time millisecondsToRun:[20000 factorialHalf]110 110 110
     Time millisecondsToRun:[40000 factorialHalf]490 490 490
     Time millisecondsToRun:[60000 factorialHalf]1100 1090 1070
     Time millisecondsToRun:[80000 factorialHalf]1920 1920 1880
     Time millisecondsToRun:[100000 factorialHalf]3030 3010 3000
     Time millisecondsToRun:[120000 factorialHalf]4830 4770 4760
     Time millisecondsToRun:[150000 factorialHalf]14510 13940 13900
     Time millisecondsToRun:[200000 factorialHalf]28730 28160
    "
!

factorialIter
    "return fac(self) (i.e. 1*2*3...*self) using an iterative algorithm.
     This is slightly faster than the recursive algorithm, and does not
     suffer from stack overflow problems (with big receivers)"

    |p i|

    p := 2.
    i := 3.
    [i <= self] whileTrue:[
        p := p * i.
        i := i + 1.
    ].
    ^ p

    "
     10 factorial
     1000 factorial
     10000 factorial
     10000 factorialR

     Time millisecondsToRun:[2000 factorial]
     Time millisecondsToRun:[2000 factorialR]
     -1 factorial
    "

    "Modified: / 04-10-2006 / 14:31:12 / cg"
!

factorialR
    "return fac(self) (i.e. 1*2*3...*self) using a recursive algorithm.

     This is included to demonstration purposes - if you really need
     factorial numbers, use the tuned #factorial, which is
     faster and does not suffer from stack overflow problems (with big receivers)."

    (self >= 2) ifTrue:[
        ^ self * (self - 1) factorialR
    ].
    ^ 1

    "
     10 factorialR
     1000 factorialR
     Time millisecondsToRun:[10000 factorial]
    "

    "Created: / 18.7.1996 / 12:48:36 / cg"
    "Modified: / 8.5.1999 / 18:40:13 / cg"
!

fib
    "compute the fibionacci number for the receiver.
        fib(0) := 0
        fib(1) := 1
        fib(n) := fib(n-1) + fib(n-2)"

    self <= 0 ifTrue:[
        self == 0 ifTrue:[^ 0].
    ].
    ^ self fib_helper

    "
     30 fib
     60 fib
     1000 fib
    "
!

fib_helper
    "compute the fibionacci number for the receiver.

        Fib(n) = Fib(n-1) + Fib(n-2)

     Knuth:
        Fib(n+m) = Fib(m) * Fib(n+1) + Fib(m-1) * Fib(n)

     This is about 3 times faster than fib_iterative.
    "

    |fibUsingDict dict|

    dict := Dictionary new:100.

    fibUsingDict := [:x |
        |n fib fibN fibNp1 fibNm1 fibXm1 fibXm2 fibXp1|

        x <= 30 ifTrue:[
                "/ 0 1 2 3 4 5 6  7  8  9 10 11  12  13  14  15  16   17   18   19   20    21    22    23    24    25     26     27     28     29     30
            fib := #(1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765 10946 17711 28657 46368 75025 121393 196418 317811 514229 832040
                     ) at:x
        ] ifFalse:[
            fib := dict at:x ifAbsent:nil.
            fib isNil ifTrue:[
                fibXm1 := dict at:(x-1) ifAbsent:nil.
                fibXm1 notNil ifTrue:[
                    fibXm2 := dict at:(x-2) ifAbsent:nil.
                    fibXm2 notNil ifTrue:[
                        fib := fibXm1 + fibXm2.
                    ] ifFalse:[
                        fibXp1 := dict at:(x+1) ifAbsent:nil.
                        fibXp1 notNil ifTrue:[
                            fib := fibXp1 - fibXm1.
                        ]
                    ]
                ].

                fib isNil ifTrue:[
                    n := x // 2.
                    x odd ifTrue:[
                        "/ m is set to n+1; therefore:
                        "/ Fib(x) = Fib(n+n+1)      ; x odd; setting n = (x-1)/2
                        "/ using Knuth:
                        "/ Fib(n+n+1) = Fib(n+1) * Fib(n+1) + Fib(n+1-1) * Fib(n)
                        "/            = (Fib(n+1) ^ 2) + (Fib(n) ^ 2)
                        fibN   := fibUsingDict value:n.
                        fibNp1 := fibUsingDict value:(n+1).
                        fib := fibN squared + fibNp1 squared
                    ] ifFalse:[
                        "/ as
                        "/    Fib(n+1) = Fib(n) + Fib(n-1)
                        "/ therefore:
                        "/    Fib(n) = Fib(n+1) - Fib(n-1)
                        "/ and, since n is even, n+1 and n-1 are odd, and can be computed as above.
                        "/ This gives us:
                        "/    Fib(x) = Fib(x+1) - Fib(x-1)      ; x even; setting n = x/2
                        "/           = Fib(n+n+1) - Fib(n+n-1)
                        "/           = Fib(n+n+1) - Fib((n-1)+(n-1)+1)
                        "/           = ((Fib(n+1)^2) + (Fib(n)^2)) - ((Fib((n-1)+1)^2) + (Fib((n-1))^2))
                        "/           = (Fib(n+1)^2) + (Fib(n)^2) - (Fib(n)^2) - (Fib((n-1))^2)
                        "/           = (Fib(n+1)^2) - (Fib((n-1))^2)
                        fibNm1 := fibUsingDict value:(n-1).
                        fibNp1 := fibUsingDict value:(n+1).
                        fib := fibNp1 squared - fibNm1 squared
                    ].
                ].
                dict at:x put:fib.
            ]
        ].
        fib
    ].

    ^ fibUsingDict value:self

    "the running time is mostly dictated by the LargeInteger multiplication performance...
     (therefore, we get O(n) execution times, even for a linear number of multiplications)

     Time millisecondsToRun:[50000 fib_iterative]  312    (DUO 1.7Ghz CPU)
     Time millisecondsToRun:[50000 fib_helper]     109

     Time millisecondsToRun:[100000 fib_iterative] 1248
     Time millisecondsToRun:[100000 fib_helper]    374

     Time millisecondsToRun:[200000 fib_iterative] 4758
     Time millisecondsToRun:[200000 fib_helper]    1544

     Time millisecondsToRun:[400000 fib_iterative] 18892
     Time millisecondsToRun:[400000 fib_helper]    6084

     1 to:100 do:[:i | self assert:(i fib_iterative = i fib_helper) ]
     1 to:100 do:[:i | self assert:(i fib_iterative = i fib) ]
    "

    "Modified: / 17-08-2010 / 17:29:34 / cg"
!

gcd:anInteger
    "return the greatest common divisor of the receiver and anInteger.
     Euclids & Knuths algorithm."

    |a b t|

    a := self abs.
    b := anInteger abs.

    a < b ifTrue:[
        t := a.
        a := b.
        b := t.
    ].

    b = 0 ifTrue: [^ a].
    a := a \\ b.
    a = 0 ifTrue:[^ b].
    ^ b gcd_helper:a

    "
     3141589999999999 gcd:1000000000000000

     Time millisecondsToRun:[
        10000 timesRepeat:[
           123456789012345678901234567890 gcd: 9876543210987654321
        ]
     ]
    "

    "Modified: / 25.10.1997 / 16:08:45 / cg"
!

integerLog2
    "return the floor of log2 of the receiver.
     This is the same as (self log:2) floor."

    self <= 0 ifTrue:[
        ^ self class
            raise:#domainErrorSignal
            receiver:self
            selector:#integerLog2
            arguments:#()
            errorString:'logarithm of negative integer'
    ].
    ^ self highBit - 1.

    "
      2  log:2
      2  integerLog2

      3  log:2
      3  integerLog2

      4  log:2
      4  integerLog2

      64  integerLog2
      100 integerLog2
      100 log:2
      999 integerLog2
      999 log:2
      120000 integerLog2
      120000 log:2
      -1 integerLog2
      50 factorial integerLog2
      50 factorial log:2
      1000 factorial integerLog2
      1000 factorial log:2       -- float error!!
    "
!

integerReciprocal
    "return an integer representing 1/self * 2**n.
     Where an integer is one bit longer than self.
     This is a helper for modulu numbers"

    |b "{Class: SmallInteger}" rem result digitBytes|

    b := self highBit.
    rem := 1 bitShift:b.
    result := LargeInteger basicNew numberOfDigits:(b // 8)+1.
    digitBytes := result digitBytes.
    b+1 to:1 by:-1 do:[:idx|
        rem >= self ifTrue:[
            rem := rem - self.
            digitBytes bitSetAt:idx.
        ].
        rem := rem mul2.
    ].
    ^ result compressed.

    "
     333 integerReciprocal                (2 raisedTo:18) // 333
     393 integerReciprocal
     8 integerReciprocal
     15 integerReciprocal
     15112233445566 integerReciprocal
     10239552311579 integerReciprocal
   "

    "Modified: / 03-05-1999 / 14:27:18 / stefan"
    "Modified: / 17-08-2010 / 17:30:22 / cg"
!

integerSqrt
    "return the largest integer which is less or equal to the
     receiver's square root.
     This might be needed for some number theoretic problems with large numbers
     (and also in cryptography). Uses Newton's method"

    |guess prevGuess guessSquared|

    self negative ifTrue:[
        ^ self class
            raise:#imaginaryResultSignal
            receiver:self
            selector:#integerSqrt
            arguments:#()
            errorString:'bad (negative) receiver in sqrt'
    ].
    self == 0 ifTrue:[^ 0].

    guess := (1 bitShift:(self highBit // 2)).

    [
        prevGuess ~= guess
        and:[ ((guessSquared := guess squared) - self) abs >= guess ]
    ] whileTrue:[
        prevGuess := guess.
        guess := (guess + (self / guess)) // 2.
    ].
    guessSquared > self ifTrue:[
        guess := guess - 1.
    ].
    "/ self assert:(guess squared <= self).
    "/ self assert:((guess + 1) squared > self).

    ^ guess.

    "
     333 integerSqrt
     325 integerSqrt
     324 integerSqrt
     323 integerSqrt
     10239552311579 integerSqrt
     5397346292805549782720214077673687806275517530364350655459511599582614290 integerSqrt
     1000 factorial integerSqrt

     1000 factorial - 1000 factorial integerSqrt squared
     1000 factorial - (1000 factorial integerSqrt + 1) squared
   "
!

inverseMod:n
    "find the modular inverse for myself to n.
     This is defined as the solution of: '1 = (self * x) mod n.
     This is a helper for modulu numbers"

    |e ret|

    "the following expression returns #(x y (self gcd:n)), the solution of the equation
     (self * x) + (n * y) = self gcd:n"

    e := self extendedEuclid:n.

    (e at:3) == 1 ifTrue:[
        ret := e at:1.
        ret negative ifTrue:[
            ^ ret + n
        ].
        ^ ret.
    ].

    ^ 0

    "
     14 inverseMod:5      -> 4
     5 inverseMod:14      -> 3
     14 inverseMod:11     -> 4                (4 * 14) \\ 11
     11 inverseMod:14     -> 9                (9 * 11) \\ 14
     79 inverseMod:3220   -> 1019
     3220 inverseMod:79   -> 54               (54 * 3220) \\ 79
     1234567891 inverseMod:1111111111119
                          -> 148726663534     (148726663534*1234567891) \\ 1111111111119


     14 extendedEuclid:11
     5 extendedEuclid:14
     14 extendedEuclid:2
     3220 extendedEuclid:79
    "

    "Created: / 27.4.1999 / 15:19:22 / stefan"
    "Modified: / 18.11.1999 / 16:21:37 / stefan"
!

lcm:anInteger
    "return the least common multiple (using gcd:)"

    ^ (self * anInteger) abs // (self gcd: anInteger)

    "
     65 lcm:15
     3 lcm:15
    "
!

primeFactors
    "return a collection of prime factors of the receiver.
     For prime numbers, an empty collection is returned.
     Can take a long time for big numbers"

    ^ self primeFactorsUpTo:nil

    "
     2 to:10000 do:[:n |
        self assert:((n isPrime and:[ n primeFactors isEmpty])
                    or:[ n isPrime not and:[n primeFactors product = n]])
     ]
     3 to:10000 do:[:n |
        self assert:(n factorial primeFactors product = n factorial)
     ]

     13195 primeFactors
     12 primeFactors
     2 primeFactors
     3 primeFactors
     5 primeFactors
     14 primeFactors
     13423453625634765 primeFactors
     13423453625634765 isPrime
     13423453625634765 gcd:(3 * 5 * 19 * 29)
     13423453625634765 / 8265
     1624132320101 isPrime
     1624132320101 gcd: 8265

     1000000 primeFactors
     100000000 primeFactors
     1000000000 primeFactors

     Time millisecondsToRun:[
        1000 timesRepeat:[
            10000000000000000000000000000000000000 primeFactors
        ]
     ]   421
    "

    "Modified: / 17-08-2010 / 17:27:33 / cg"
!

primeFactorsUpTo:limitArgOrNil
    "return a collection of prime factors of the receiver.
     For prime numbers, an empty collection is returned.
     Can take a long time for big numbers
     (win a nobel price, if you find something quick (*)

     (*):which does not mean that the code below is optimal - far from it !!"

    "See comment in initializePrimeCacheUpTo:limit"

    |rest n factors limit wellKnownPrimes lastPrime checkThisFactor nextTry|

    factors := Bag new.
    rest := self.
    limit := (rest // 2).
    limitArgOrNil notNil ifTrue:[
        limit := limit min:limitArgOrNil.
    ].

    "/ try to get the number down fast:
    n := rest lowBit.
    n ~~ 1 ifTrue:[
        self == 2 ifTrue:[^ #() ].
        factors add:2 withOccurrences:(n-1).
        rest := rest rightShift:(n-1).
    ].

    checkThisFactor :=
        [:prime |
            (prime*prime) > rest ifTrue:[
                (rest ~~ 1 and:[factors notEmpty]) ifTrue:[ factors add:rest ].
                ^ factors.
            ].

            [rest \\ prime == 0] whileTrue:[
                factors add:prime.
                rest := rest // prime.
                rest == 1 ifTrue:[^ factors].
            ].
            lastPrime := prime.
        ].

    wellKnownPrimes := Integer primesUpTo5000.
    limit <= (wellKnownPrimes last+1) ifTrue:[
        wellKnownPrimes do:checkThisFactor.
        ^ factors
    ].

    "/ actually, all of the code is duplicated; once for primes from a table,
    "/ and then primes as generated on the fly. The prime generation involves a prime-test,
    "/ which may slow things down quite a bit.
    "/ (the primesUpTo uses a faster sieve, but can only represent primes to upTo (say)
    "/ a few millions).

    Integer primesUpTo:(limit min:(1000000 max:Integer primeCacheSize)) do:checkThisFactor.

    nextTry := lastPrime + 2.
    [ nextTry <= limit ] whileTrue:[
        "/ now, we are beyond the list of pre-generated primes.
        "/ change our strategy to: see if it divides an odd number;
        "/ if so, add the divisor's prime factors.
        (nextTry*nextTry) > rest ifTrue:[
            (rest ~~ 1 and:[factors notEmpty]) ifTrue:[ factors add:rest ].
            ^ factors.
        ].
        [(rest \\ nextTry) == 0] whileTrue:[
            "/ can only happen relatively late after the last prime,
            "/ because otherwise, the primeFactors of nextTry would already have
            "/ been found as divisors.
            "/ first chance is: (lastPrime + 2) squared
            nextTry < lastPrime squared ifTrue:[
                "/ nextTry is a prime !!
                factors add:nextTry
            ] ifFalse:[
                factors addAll:(nextTry primeFactors).
            ].
            rest := rest // nextTry.
        ].
        nextTry := nextTry + 2.
    ].
    ^ factors

    "
     2 to:10000 do:[:n |
        self assert:((n isPrime and:[ n primeFactors isEmpty])
                    or:[ n isPrime not and:[n primeFactors product = n]])
     ]
     3 to:10000 do:[:n |
        self assert:(n factorial primeFactors product = n factorial)
     ]

     13195 primeFactors
     12 primeFactors
     2 primeFactors
     3 primeFactors
     5 primeFactors
     14 primeFactors
     13423453625634765 primeFactors
     13423453625634765 isPrime
     13423453625634765 gcd:(3 * 5 * 19 * 29)
     13423453625634765 / 8265
     1624132320101 isPrime
     1624132320101 gcd: 8265

     1000000 primeFactors
     100000000 primeFactors
     1000000000 primeFactors

     Time millisecondsToRun:[
        1000 timesRepeat:[
            10000000000000000000000000000000000000 primeFactors
        ]
     ]   421
    "

    "Modified: / 17-08-2010 / 17:28:05 / cg"
!

raisedTo:exp mod:mod
    "return the modulo (remainder) of
     the receiver raised to exp (an Integer) and mod (another Integer)"

    |result m t
     eI   "{Class: SmallInteger}"
     bits "{Class: SmallInteger}"|

    "use the addition chaining algorithm"

    exp == 0 ifTrue:[
        ^ 1
    ].
    exp == 1 ifTrue:[
        mod isNumber ifTrue:[
            ^ self \\ mod.
        ]
    ].
    exp negative ifTrue:[
        ^ self class
            raise:#domainErrorSignal
            receiver:self
            selector:#raisedTo:mod:
            arguments:(Array with:exp with:mod)
            errorString:'modulo arithmethic with negative exponent'
    ].

    m := mod asModuloNumber.

    result := 1.
    t := m modulusOf:self.

    (exp class == SmallInteger) ifTrue:[
        eI := exp.
        [eI ~~ 0] whileTrue:[
            (eI bitAnd:1) == 1 ifTrue:[
                result := m modulusOf:(result * t).
            ].
            eI := eI bitShift:-1.
            eI ~~ 0 ifTrue:[
                t := m modulusOf:(t * t).
            ].
        ].
        ^ result.
    ].

    bits := exp highBit.

    1 to:bits-1 do:[:i|
        (exp bitAt:i) == 1 ifTrue:[
            result := m modulusOf:(result * t).
        ].
        t := m modulusOf:(t * t).
    ].
    result := m modulusOf:(result * t).

    ^ result

    "
     2 raisedTo:2 mod:3
      20000000000000 raisedTo:200 mod:190  ->  30
     (20000000000000 raisedTo:200) \\ 190

      Time millisecondsToRun:[10000 timesRepeat:[
                                200000000000000000000000 raisedTo:65537 mod:1900000000000000000000000
                              ]
                             ]

     Time millisecondsToRun:[1000 timesRepeat:[
                                (200000000000000000000000 raisedTo:65537) \\ 1900000000000000000000000
                             ]
                            ]
    "

    "Created: / 27.4.1999 / 15:19:22 / stefan"
    "Modified: / 5.5.1999 / 11:18:20 / stefan"
    "Modified: / 16.11.2001 / 14:15:21 / cg"
!

raisedToCrtModP:p q:q ep:ep eq:eq u:u
    "Application of the Chinese Remainder Theorem (CRT).

     This is a faster modexp for moduli with a known factorisation into two
     relatively prime factors p and q, and an input relatively prime to the
     modulus, the Chinese Remainder Theorem to do the computation mod p and
     mod q, and then combine the results.  This relies on a number of
     precomputed values, but does not actually require the modulus n or the
     exponent e.

     expout = expin ^ e mod (p*q).
     We form this by evaluating
     p2 = (expin ^ e) mod p and
     q2 = (expin ^ e) mod q
     and then combining the two by the CRT.

     Two optimisations of this are possible.  First, we can reduce expin
     modulo p and q before starting.

     Second, since we know the factorisation of p and q (trivially derived
     from the factorisation of n = p*q), and expin is relatively prime to
     both p and q, we can use Euler's theorem, expin^phi(m) = 1 (mod m),
     to throw away multiples of phi(p) or phi(q) in e.
     Letting ep = e mod phi(p) and
              eq = e mod phi(q)
     then combining these two speedups, we only need to evaluate
     p2 = ((expin mod p) ^ ep) mod p and
     q2 = ((expin mod q) ^ eq) mod q.

     Now we need to apply the CRT.  Starting with
     expout = p2 (mod p) and
     expout = q2 (mod q)
     we can say that expout = p2 + p * k, and if we assume that 0 <= p2 < p,
     then 0 <= expout < p*q for some 0 <= k < q.  Since we want expout = q2
     (mod q), then p*k = q2-p2 (mod q).  Since p and q are relatively prime,
     p has a multiplicative inverse u mod q.  In other words, u = 1/p (mod q).

     Multiplying by u on both sides gives k = u*(q2-p2) (mod q).
     Since we want 0 <= k < q, we can thus find k as
     k = (u * (q2-p2)) mod q.

     Once we have k, evaluating p2 + p * k is easy, and
     that gives us the result
    "

    |result t mp mq|

    mp := p asModuloNumber.
    result := self raisedTo:ep mod:mp.

    mq := q asModuloNumber.
    t := self raisedTo:eq mod:mq.

    "now p2 is in result, q2 in t"

    t := t - result.
    t negative ifTrue:[
        t := t + q.
    ].
    t := t * u.
    t := mq modulusOf:t.
    t := t * p.
    result := result + t.

    ^ result.

    "Created: / 30.4.1999 / 15:53:15 / stefan"
    "Modified: / 5.5.1999 / 11:01:15 / stefan"
! !

!Integer methodsFor:'printing & storing'!

asBCD
    "return an integer which represents the BCD encoded value of the receiver;
     that is: each digit of its decimal representation is placed into a nibble
     of the result. (aka 162 -> 0x162).
     This conversion is useful for some communication protocols,
     or control systems, which represent numbers this way...
     This fallback code is not particularily tuned or optimized for speed."

    |rest twoDigits hi lo shift out|

    out := 0. shift := 0.
    rest := self.
    [rest > 0] whileTrue:[
        twoDigits := rest \\ 100.
        rest := rest // 100.
        hi := twoDigits // 10.
        lo := twoDigits \\ 10.
        out := out bitOr:(((hi bitShift:4)+lo) bitShift:shift).
        shift := shift + 8.
    ].

    ^ out

    "
     (100 factorial) asBCD
     999999999 asBCD
     100000000 asBCD
     123456789 asBCD
     99999999 asBCD
     12345678 asBCD
     12345678 asBCD
     12345678 asBCD hexPrintString
     12345678901234567890 asBCD
    "
!

asBCDBytes
    "return a byteArray containing the receiver in BCD encoding.
     The byteArray will contain the BCD encoded decimal string,
     starting with the most significant digits first.
     This conversion is useful for some communication protocols,
     or control systems, which represent big numbers this way...
     This is not particularily tuned or optimized for speed."

    |s rest twoDigits hi lo|

    self == 0 ifTrue:[
        ^ #[ 16r00 ]
    ].

    "/ a very rough estimate on the final size ...
    s := (ByteArray new:(self digitLength * 2)) writeStream.

    rest := self.
    [rest > 0] whileTrue:[
        twoDigits := rest \\ 100.
        rest := rest // 100.
        hi := twoDigits \\ 10.
        lo := twoDigits // 10.
        s nextPut:(lo bitShift:4)+hi
    ].

    ^ s contents reverse

    "
     12345678 asBCDBytes
     12345678 asBCDBytes hexPrintString
     12345678901234567890 asBCDBytes
    "
!

errorPrintHex
    "print the receiver as a hex number on the standard error stream"

     (self printStringRadix:16) errorPrint
!

hexPrintString
    "return a hex string representation of the receiver"

    ^ self printStringRadix:16

    "
     127 hexPrintString
     -1 hexPrintString
    "

    "Modified: / 11.10.1998 / 01:15:43 / cg"
!

hexPrintString:size
    "return a hex string representation of the receiver,
     padded to size characters"

"/    ^ (self printStringRadix:16) leftPaddedTo:size with:$0
    ^ self printStringRadix:16 size:size fill:$0

    "
     12345 hexPrintString:4
     123 hexPrintString:4
    "

    "Created: 18.2.1997 / 13:32:33 / cg"
!

printHex
    "print the receiver as a hex number on the standard output stream"

     (self printStringRadix:16) print
!

printOn:aStream base:base showRadix:showRadix
    "append a string representation of the receiver in the specified numberBase to aStream
     (if showRadix is true, with initial XXr)
     The base argument should be between 2 and 36.
     If it is negative, digits > 9 are printed as lowecase a-z."

    |absBase num s divMod mod r r2 r4 nD numN string|

    (base isInteger and:[absBase := base abs. absBase between:2 and:36]) ifFalse:[
        ConversionError raiseRequestWith:self errorString:' - invalid base: ', absBase printString.
        absBase := 10.
    ].

    showRadix ifTrue:[
        absBase printOn:aStream.
        aStream nextPut:$r.
    ].

    (self = 0) ifTrue:[aStream nextPut:$0. ^ self].
    self negative ifTrue:[
        aStream nextPut:$- .
        num := self negated.
    ] ifFalse:[
        num := self.
    ].

    "
     claus: changed it from a recursive algorithm;
     (it used to trigger stack-overflow exceptions when printing 3000 factorial ...)
    "
    "/    leftPart := num // base.
    "/    (leftPart ~= 0) ifTrue:[
    "/        leftPart printOn:aStream base:base.
    "/        aStream nextPut:(Character digitValue:(num \\ base).
    "/        ^ self
    "/    ].
    "/    aStream nextPut:(Character digitValue:num).

    "/ instead of computing the quotient and remainder
    "/ against radix, do it in junks of 5 or 6 digits.
    "/ This reduces the number of LargeInt-divisions
    "/ by that factor (turning them into smallInt divisions
    "/ within that junk) and speeds up the conversions noticably.

    r2 := absBase*absBase.   "/ radix^2
    r4 := r2*r2.        "/ radix^4
    absBase <= 10 ifTrue:[
        r := r4*r2.     "/ radix^6 (chunks of 6 digits)
        nD := 6.
    ] ifFalse:[
        r := r4*absBase.    "/ radix^5 (chunks of 5 digits)
        nD := 5.
    ].
    SmallInteger maxBits >= 63 ifTrue:[
        r := r*r2.    "/ radix^7 (chunks of 6 digits)
        nD := nD + 2.
    ].

    "get a Stream with space for the digits we are going to print.
     We need ((num log:base) ceiling) digits, which is equivalent
     to ((num log:2)/(base log:2) ceiling)
    "
    s := WriteStream on:(String new:10).

    [num >= r] whileTrue:[
        "/
        "/ chop off nD digits.
        "/
        divMod := num divMod:r.
        num := divMod at:1.
        numN := divMod at:2.

        "/ process them
        nD timesRepeat:[
            divMod := numN divMod:absBase.
            numN := divMod at:1.
            mod := divMod at:2.
            s nextPut:(Character digitValue:mod).
        ].
    ].

    [num ~~ 0] whileTrue:[
        divMod := num divMod:absBase.
        num := divMod at:1.
        mod := divMod at:2.
        s nextPut:(Character digitValue:mod).
    ].
    string := s contents reverse.
    base < 0 ifTrue:[
        string := string asLowercase.
    ].
    aStream nextPutAll:string.

    "
        3000 factorial printOn:Transcript base:10
        10 printOn:Transcript base:3
        31 printOn:Transcript base:3
        10 printOn:Transcript base:2
        31 printOn:Transcript base:2
        -28  printOn:Transcript base:16
        -28  printOn:Transcript base:-16
        -20  printOn:Transcript base:10
        Time millisecondsToRun:[10000 factorial printString]
        '%012d' printf:{  (2 raisedTo:20) }
    "

    "Modified: / 20-01-1998 / 18:05:02 / stefan"
    "Created: / 07-09-2001 / 13:51:33 / cg"
    "Modified: / 02-08-2010 / 12:24:14 / cg"
    "Modified (comment): / 28-12-2015 / 08:23:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream base:baseInteger size:sz
    "print a string representation of the receiver in the specified
     base. The string is padded on the left with fillCharacter to make
     its size as specified in sz."

    self printOn:aStream base:baseInteger size:sz fill:$0

    "
     1024 printOn:Transcript base:16 size:4.
     1024 printOn:Transcript base:2 size:16.
     1024 printOn:Transcript base:16 size:8.
    "
!

printOn:aStream base:baseInteger size:sz fill:fillCharacter
    "print a string representation of the receiver in the specified
     base. The string is padded on the left with fillCharacter to make
     its size as specified in sz."

    |string actualSize|

    string := self printStringRadix:baseInteger.
    actualSize := string size.
    actualSize < sz ifTrue:[
        aStream next:sz-actualSize put:fillCharacter.
    ].
    aStream nextPutAll:string.

    "
     1024 printOn:Transcript base:16 size:4 fill:$0.
     1024 printOn:Transcript base:2 size:16 fill:$.
     1024 printOn:Transcript base:16 size:8 fill:Character space.
    "
!

printOn:aStream radix:base
    "append a printed description of the receiver to aStream.
     The receiver is printed in radix base (instead of the default, 10).
     This method is obsoleted by #printOn:base:, which is ST-80 & ANSI compatible."

    <resource: #obsolete>

    self printOn:aStream base:base

    "Modified: / 20.1.1998 / 14:10:45 / stefan"
    "Modified: / 7.9.2001 / 13:58:29 / cg"
!

printRomanOn:aStream
    "print the receiver as roman number to the receiver, aStream.
     This converts correct (i.e. prefix notation for 4,9,40,90, etc.)."

    ^ self printRomanOn:aStream naive:false

    "
     1 to:10 do:[:i | i printRomanOn:Transcript. Transcript cr.].
     1999 printRomanOn:Transcript. Transcript cr.
     Date today year printRomanOn:Transcript. Transcript cr.
    "

    "test all between 1 and 9999:
      1 to:9999 do:[:n |
        |romanString|

        romanString := String streamContents:[:stream | n printRomanOn:stream].
        (Integer readFromRomanString:romanString onError:nil) ~= n ifTrue:[self halt].
     ]
    "
!

printRomanOn:aStream naive:naive
    "print the receiver as roman number to the receiver, aStream.
     The naive argument controls if the conversion is
     correct (i.e. subtracting prefix notation for 4,9,40,90, etc.),
     or naive (i.e. print 4 as IIII and 9 as VIIII); also called simple.
     The naive version is often used for page numbers in documents."

    |restValue spec|

    restValue := self.
    restValue > 0 ifFalse:[self error:'negative roman'].

    naive ifTrue:[
        spec := #(
                " value string repeat "
                   1000 'M'    true
                    500 'D'    false
                    100 'C'    true
                     50 'L'    false
                     10 'X'    true
                      5 'V'    false
                      1 'I'    true
                 ).
    ] ifFalse:[
        spec := #(
                " value string repeat "
                   1000 'M'    true
                    900 'CM'   false
                    500 'D'    false
                    400 'CD'   false
                    100 'C'    true
                     90 'XC'   false
                     50 'L'    false
                     40 'XL'   false
                     10 'X'    true
                      9 'IX'   false
                      5 'V'    false
                      4 'IV'   false
                      1 'I'    true
                 ).
    ].

    spec
        inGroupsOf:3
        do:[:rValue :rString :repeatFlag |

            [
                (restValue >= rValue) ifTrue:[
                    aStream nextPutAll:rString.
                    restValue := restValue - rValue.
                ].
            ] doWhile:[ repeatFlag and:[ restValue >= rValue] ].
        ].

    "
     1 to:10 do:[:i | i printRomanOn:Transcript naive:false. Transcript cr.].
     1 to:10 do:[:i | i printRomanOn:Transcript naive:true. Transcript cr.].

     1999 printRomanOn:Transcript. Transcript cr.
     Date today year printRomanOn:Transcript. Transcript cr.
    "

    "test all between 1 and 9999:
      1 to:9999 do:[:n |
        |romanString|

        romanString := String streamContents:[:stream | n printRomanOn:stream naive:false].
        (Integer readFromRomanString:romanString onError:nil) ~= n ifTrue:[self halt].
     ]
    "

    "test naive all between 1 and 9999:
      1 to:9999 do:[:n |
        |romanString|

        romanString := String streamContents:[:stream | n printRomanOn:stream naive:true].
        (Integer readFromRomanString:romanString onError:nil) ~= n ifTrue:[self halt].
     ]
    "
!

printStringRadix:aRadix size:sz fill:fillCharacter
    "return a string representation of the receiver in the specified
     radix. The string is padded on the left with fillCharacter to make
     its size as specified in sz."

    |s actualSize|

    s := self printStringRadix:aRadix.
    actualSize := s size.
    actualSize < sz ifTrue:[
        s := ((String new:(sz - actualSize)) atAllPut:fillCharacter) , s
    ].
    ^ s

    "
     1024 printStringRadix:16 size:4 fill:$0.
     1024 printStringRadix:2 size:16 fill:$.
     1024 printStringRadix:16 size:8 fill:(Character space)
    "
!

romanPrintString
    "return a roman number representation of the receiver as a string"

    ^ String streamContents:[:stream | self printRomanOn:stream].

    "
     1999 romanPrintString.
     Date today year romanPrintString.
    "
! !

!Integer methodsFor:'queries'!

digitAt:n
    "return the n-th byte of the binary representation."

    self subclassResponsibility

    "This is a very stupid implementation, and should be redefined in
     concrete subclasses."

"/    |num count|
"/
"/    num := self.
"/    count := n.
"/    [count > 1] whileTrue:[
"/        num := num // 256.
"/        count := count - 1
"/    ].
"/    ^ num \\ 256

    "
     16r44332211 digitAt:1
     16r44332211 digitAt:2
     16r44332211 digitAt:3
     16r44332211 digitAt:4
     16r44332211 digitAt:5
     16r00332211 digitAt:4
     16r00332211 digitAt:5
    "

    "Modified: / 26.9.2001 / 21:21:21 / cg"
!

digitByteAt:n
    "return 8 bits of my signed value, starting at byte index.
     For positive receivers, this is the same as #digitAt:;
     for negative ones, the actual bit representation is returned."

    self subclassResponsibility

    "Created: / 26.9.2001 / 21:18:43 / cg"
    "Modified: / 26.9.2001 / 21:20:19 / cg"
!

digitLength
    "return the number of bytes needed for the unsigned binary representation of the receiver.
     For negative receivers, the result is not defined by the language standard.
     This method is redefined in concrete classes
     - the fallback here is actually never used."

    ^ (self log:256) ceiling asInteger

    "Modified: 31.7.1997 / 13:19:06 / cg"
!

exponent
    "return what would be the normalized float's exponent if I were a float.
     This is not for general use - it has been added for dolphin (soap) compatibility.
     This assumes that the mantissa is normalized to
     0.5 .. 1.0 and the number's value is: mantissa * 2^exp"

    ^ self abs highBit

    "
     self assert:( 1.0 exponent = 1 exponent ).
     self assert:( 2.0 exponent = 2 exponent ).
     self assert:( 3.0 exponent = 3 exponent ).
     self assert:( 4.0 exponent = 4 exponent ).
     self assert:( 12345.0 exponent = 12345 exponent ).
     self assert:( 0.0 exponent = 0 exponent ).

     self assert:( -1.0 exponent = -1 exponent ).
     self assert:( -2.0 exponent = -2 exponent ).
     self assert:( -3.0 exponent = -3 exponent ).
     self assert:( -4.0 exponent = -4 exponent ).
     self assert:( -12345.0 exponent = -12345 exponent ).
    "
!

isInteger
    "return true, if the receiver is some kind of integer number"

    ^ true
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    ^ true
!

isPerfectSquare
    "return true if I am a perfect square.
     That is a number for which the square root is an integer."

    |intSqrt realSqrt|

    self strictlyPositive ifFalse:[
        self == 0 ifTrue:[^ true].
        "/ should we raise a domain error for negative receivers?
        ^ false
    ].

    "/ q&d check for common small squares
    self < 400 ifTrue:[
        ^ #(1 4 9 16 25 36 49 64 81 100 121 144 169 196 225 256 289 324 361 ) includes:self.
    ].
    self < 1024 ifTrue:[
        ^ #(400 441 484 529 576 625 676 729 784 841 900 961) includes:self.
    ].

    "/ try powers of 2
    self isPowerOfTwo ifTrue:[
        ^ self lowBit odd
    ].

    "/ guess
    realSqrt := self sqrt.
    realSqrt isFinite ifTrue:[
        realSqrt = realSqrt truncated ifTrue:[
            "/ still have to check due to rounding errors.
            intSqrt := realSqrt truncated asInteger.
            ^ intSqrt squared = self
        ].
    ].

    "/ slow code
    intSqrt := self integerSqrt.
    ^ intSqrt squared = self

    "
     0 isPerfectSquare
     3 isPerfectSquare
     4 isPerfectSquare
     9 isPerfectSquare
     (1 to:1000000) count:[:n | n isPerfectSquare] 1000
     12345678987654321234567 isPerfectSquare
     123123123432 squared isPerfectSquare
     (123123123432 raisedTo:7) isPerfectSquare
     ((123456789123456789 raisedTo:7)) isPerfectSquare
     ((123456789123456789 raisedTo:7)-1) isPerfectSquare
     Time microsecondsToRun:[12345678987654321234567 isPerfectSquare]
    "
!

isPowerOf:p
    "return true, if the receiver is a power of p"

    p == 2 ifTrue:[ ^ self isPowerOfTwo].

    "/ the following is a q&d hack, using existing code.
    ^ (Integer
        readFromString:(self printStringRadix:p)
        radix:2
        onError:-1) isPowerOfTwo

    "
     0 isPowerOf:2
     1 isPowerOf:2

     16r0000000000000000 isPowerOf:2
     16r0000004000000000 isPowerOf:2
     16r0000004000000001 isPowerOf:2

     16r0000000000000001 isPowerOf:2
     16r0000000000000002 isPowerOf:2
     16r0000000000000004 isPowerOf:2
     16r0000000000000008 isPowerOf:2

     16r0000000000000001 isPowerOf:4
     16r0000000000000002 isPowerOf:4
     16r0000000000000004 isPowerOf:4
     16r0000000000000008 isPowerOf:4
     16r0000000000000010 isPowerOf:4
     16r0000000000000020 isPowerOf:4

     3r0000000000000001 isPowerOf:3
     3r0000000000000010 isPowerOf:3
     3r0000000000000100 isPowerOf:3
     3r0000000000001000 isPowerOf:3
     3r0000000000001001 isPowerOf:3
     3r0000000000002000 isPowerOf:3

     10 isPowerOf:10
     20 isPowerOf:10
     100 isPowerOf:10
     110 isPowerOf:10
     200 isPowerOf:10
     1000 isPowerOf:10
     10000 isPowerOf:10
     100000 isPowerOf:10
     100001 isPowerOf:10
 "
!

isPowerOfTwo
    "return true, if the receiver is a power of 2"

    "redefined, because the hacker's algorithm in smallInt is much slower for large numbers"

    |maxBytes "{ Class: SmallInteger }"|

    maxBytes := self digitLength.
    (self digitAt:maxBytes) isPowerOfTwo ifFalse:[^ false].
    1 to:maxBytes-1 do:[:byteIndex |
        (self digitAt:byteIndex) ~~ 0 ifTrue:[^ false].
    ].
    ^ true

    "
     10000 factorial isPowerOfTwo
     |n| n := 10000 factorial. Time millisecondsToRun:[1000 timesRepeat:[ n isPowerOfTwo]]
    "
    "
     (2 raisedTo:10000) isPowerOfTwo
     |n| n := (2 raisedTo:10000). Time millisecondsToRun:[1000 timesRepeat:[ n isPowerOfTwo]]
    "

    "Modified: / 20-06-2011 / 12:43:05 / cg"
!

isPrime
    "return true if I am a prime Number.
     This is a q&d hack, which may need optimization if heavily used."

    |limit firstFewPrimes|

    self even ifTrue:[^ self == 2 ].
    self == 1 ifTrue:[^ false ].

    "/ See comment in initializePrimeCacheUpTo:limit
    "/      Integer initializePrimeCacheUpTo:(10 raisedTo:7)
    "/      Integer flushPrimeCache
    "/
    "/ by default, no primeCache is used.
    "/ if you do lots of number-stuff with primes, you may want to enable it with
    "/      Integer initializePrimeCacheUpTo:1000000
    "/ and when done, cleanup with flushPrimeCache
    PrimeCache notNil ifTrue:[
        self <= (PrimeCache size*2) ifTrue:[
            ^ PrimeCache at:self//2.
        ].
    ].

    firstFewPrimes := self class primesUpTo5000.
    limit := firstFewPrimes last + 1.
    self < (limit*limit) ifTrue:[
        limit := self sqrt asInteger.
    ].
    firstFewPrimes do:[:p |
        p > limit ifTrue:[^ true].
        (self \\ p) == 0 ifTrue:[ ^ false ].
    ].

    PrimeNumberGenerator notNil ifTrue:[    "from exept:libcrypt"
        "speed up a lot for large primes"
        ^ PrimeNumberGenerator isPrime:self.
    ].

    (firstFewPrimes last+2) to:limit by:2 do:[:i |
        (self \\ i) == 0 ifTrue:[ ^ false ].
    ].
    ^ true

    "
     Integer primesUpTo:1000
     (1 to:1000000) count:[:n | n isPrime] 78498
     Time millisecondsToRun:[ (1 to:1000000) count:[:n | n isPrime]] 1295   w.o firstFewPrimes
     Time millisecondsToRun:[ (1 to:1000000) count:[:n | n isPrime]] 936    with firstFewPrimes (less tests)
     Time millisecondsToRun:[ (1 to:1000000) count:[:n | n isPrime]] 343    with primeCache
    "
!

nextMultipleOf: n
    "return the multiple of n at or above the receiver.
     Useful for padding, aligning or rounding,
     expecially when reading aligned binary data."

    |rest|

    rest := self \\ n.
    rest == 0 ifTrue:[ ^ self ].
    ^ self + (n - rest)

    "
     0 nextMultipleOf: 4 -> 0
     1 nextMultipleOf: 4 -> 4
     2 nextMultipleOf: 4 -> 4 
     3 nextMultipleOf: 4 -> 4
     4 nextMultipleOf: 4 -> 4
     5 nextMultipleOf: 4 -> 8

     22 nextMultipleOf: 4
     100 factorial nextMultipleOf: 4
    "
!

nextPowerOf2
    "return the power of 2 at or above the receiver.
     Useful for padding.
     Notice, that for a powerOf2, the receiver is returned.
     Also notice, that (because it is used for padding),
     0 is returned for zero."

    |x t sh|

    x := self - 1.
    x := x bitOr: (x bitShift: -1).
    x := x bitOr: (x bitShift: -2).
    x := x bitOr: (x bitShift: -4).
    x := x bitOr: (x bitShift: -8).
    x := x bitOr: (t := x bitShift: -16).
    t == 0 ifFalse:[
        sh := -32.
        [
            x := x bitOr: (t := x bitShift: sh).
            sh := sh + sh.
        ] doWhile: [t ~~ 0]
    ].
    ^ x + 1

    "
     0 nextPowerOf2
     1 nextPowerOf2
     2 nextPowerOf2
     3 nextPowerOf2
     4 nextPowerOf2
     5 nextPowerOf2
     6 nextPowerOf2
     7 nextPowerOf2
     8 nextPowerOf2

     22 nextPowerOf2
     12 factorial nextPowerOf2  isPowerOf:2
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
!

nextPrime
    "return the next prime after the receiver"

    |num|

    num := self + 1.
    num <= 2 ifTrue:[^ 2].
    num even ifTrue:[
        num := num + 1
    ].
    [num isPrime] whileFalse:[
        num := num + 2
    ].
    ^ num

    "
     0 nextPrime
     1 nextPrime
     2 nextPrime
     22 nextPrime
     37 nextPrime
     36 nextPrime
     3456737 nextPrime
     1000 factorial nextPrime
    "
!

parityOdd
    "return true, if an odd number of bits are set in the receiver, false otherwise.
     (i.e. true for odd parity)
     Undefined for negative values (smalltalk does not require the machine to use 2's complement)"

    ^ self bitCount odd

    "
     0 parityOdd
     1 parityOdd
     2 parityOdd
     4 parityOdd
     5 parityOdd
     7 parityOdd
     33 parityOdd
     6 parityOdd

     1 to:1000000 do:[:n |
        self assert:(n parityOdd = ((n printStringRadix:2) occurrencesOf:$1) odd).
     ]

     0 to:255 do:[:n |
        |p|

        p :=
            (((((((((n rightShift: 7)
            bitXor: (n rightShift: 6))
                bitXor: (n rightShift: 5))
                    bitXor: (n rightShift: 4))
                        bitXor: (n rightShift: 3))
                            bitXor: (n rightShift: 2))
                                bitXor: (n rightShift: 1))
                                    bitXor: n) bitAnd:1) == 1.
        self assert:(n parityOdd = p).
     ]
    "

    "Created: / 09-01-2012 / 17:18:06 / cg"
! !


!Integer methodsFor:'special modulo arithmetic'!

add_32:anInteger
    "return a C-semantic 32bit sum of the receiver and the argument.
     Both must be either Small- or LargeIntegers.
     Returns a signed 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     modulu operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 + val2;
    RETURN(__MKINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

add_32u:anInteger
    "return a C-semantic 32bit unsigned sum of the receiver and the argument.
     Both must be either Small- or LargeIntegers.
     Returns an unsigned 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     modulu operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 + val2;
    RETURN(__MKUINT((unsigned)rslt));

  bad: ;
%}.
    self primitiveFailed.
!

mul_32:anInteger
    "return a C-semantic 32bit product of the receiver and the argument.
     Both must be either Small- or LargeIntegers.
     Returns a signed 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     modulu operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 * val2;
    RETURN(__MKINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

mul_32u:anInteger
    "return a C-semantic 32bit unsigned product of the receiver and the argument.
     Both must be either Small- or LargeIntegers.
     Returns an unsigned 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     modulu operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 * val2;
    RETURN(__MKUINT((unsigned)rslt));

  bad: ;
%}.
    self primitiveFailed.
!

sub_32:anInteger
    "return a C-semantic 32bit difference of the receiver and the argument.
     Both must be either Small- or LargeIntegers.
     Returns a signed 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     modulu operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 - val2;
    RETURN(__MKINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

sub_32u:anInteger
    "return a C-semantic 32bit unsigned difference of the receiver and the argument.
     Both must be either Small- or LargeIntegers.
     Returns an unsigned 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     modulu operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 - val2;
    RETURN(__MKUINT((unsigned)rslt));

  bad: ;
%}.
    self primitiveFailed.
! !

!Integer methodsFor:'special modulo bit operators'!

asSigned32
    "return a 32-bit integer with my bit-pattern. For protocol completeness."

    ^ self
!

asUnsigned32
    "return a 32-bit integer with my bit-pattern, but positive.
     May be required for bit operations on the sign-bit and/or to
     convert C/Java numbers."

    self < 0 ifTrue:[
        ^ 16r100000000 + self
    ].
    ^ self

    "
     (-1 asUnsigned32) hexPrintString
     1 asUnsigned32
     (SmallInteger minVal asUnsigned32) hexPrintString
     (SmallInteger maxVal asUnsigned32) hexPrintString
    "
!

asUnsigned64
    "return a 64-bit integer with my bit-pattern, but positive.
     May be required for bit operations on the sign-bit and/or to
     convert C/Java numbers."

    self < 0 ifTrue:[
        ^ 16r10000000000000000 + self
    ].
    ^ self

    "
     (-1 asUnsigned64) hexPrintString
     1 asUnsigned64
     (SmallInteger minVal asUnsigned64) hexPrintString
     (SmallInteger maxVal asUnsigned64) hexPrintString
    "

    "Created: / 26-07-2013 / 13:45:11 / cg"
!

bitAnd_32:anInteger
    "return a C-semantic 32bit locical-and of the receiver and
     the argument. Both must be either Small- or LargeIntegers.
     Returns a signed 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     bit operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 & val2;
    RETURN(__MKINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

bitAnd_32u:anInteger
    "return a C-semantic 32bit locical-and of the receiver and
     the argument. Both must be either Small- or LargeIntegers.
     Returns an unsigned 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     bit operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 & val2;
    RETURN(__MKUINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

bitInvert_32
    "return a C-semantic 32bit complement of the receiver,
     which must be either Small- or LargeIntegers.
     Returns a signed 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     bit operations with C semantics."

%{  /* NOCONTEXT */
    int val, rslt;

    if (__isSmallInteger(self)) {
        val = __intVal(self);
    } else {
        val = __longIntVal(self);
        if (!val) goto bad;
    }
    rslt = ~val;
    RETURN(__MKINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

bitInvert_32u
    "return a C-semantic 32bit complement of the receiver,
     which must be either Small- or LargeIntegers.
     Returns an unsigned 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     bit operations with C semantics."

%{  /* NOCONTEXT */
    int val, rslt;

    if (__isSmallInteger(self)) {
        val = __intVal(self);
    } else {
        val = __longIntVal(self);
        if (!val) goto bad;
    }
    rslt = ~val;
    RETURN(__MKUINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

bitOr_32:anInteger
    "return a C-semantic 32bit locical-or of the receiver and
     the argument. Both must be either Small- or LargeIntegers.
     Returns a signed 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     bit operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 | val2;
    RETURN(__MKINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

bitOr_32u:anInteger
    "return a C-semantic 32bit locical-or of the receiver and
     the argument. Both must be either Small- or LargeIntegers.
     Returns an unsigned 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     bit operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 | val2;
    RETURN(__MKUINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

bitXor_32:anInteger
    "return a C-semantic 32bit locical-xor of the receiver and
     the argument. Both must be either Small- or LargeIntegers.
     Returns a signed 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     bit operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 ^ val2;
    RETURN(__MKINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
!

bitXor_32u:anInteger
    "return a C-semantic 32bit locical-xor of the receiver and
     the argument. Both must be either Small- or LargeIntegers.
     Returns an unsigned 32bit number.
     This (nonstandard) specialized method is provided to allow simulation of
     bit operations with C semantics."

%{  /* NOCONTEXT */
    int val1, val2, rslt;

    if (__isSmallInteger(self)) {
        val1 = __intVal(self);
    } else {
        val1 = __longIntVal(self);
        if (!val1) goto bad;
    }
    if (__isSmallInteger(anInteger)) {
        val2 = __intVal(anInteger);
    } else {
        val2 = __longIntVal(anInteger);
        if (!val2) goto bad;
    }
    rslt = val1 ^ val2;
    RETURN(__MKUINT(rslt));

  bad: ;
%}.
    self primitiveFailed.
! !

!Integer methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceInteger:self level:level from:referrer


! !

!Integer methodsFor:'truncation & rounding'!

ceiling
    "return the smallest integer which is larger or equal to the receiver.
     For integers, this is the receiver itself."

    ^ self

    "Modified: 18.7.1996 / 12:44:06 / cg"
!

compressed
    "if the receiver can be represented as a SmallInteger, return
     a SmallInteger with my value; otherwise return self with leading
     zeros removed. This method is redefined in LargeInteger."

    ^ self

    "Modified: 5.11.1996 / 14:07:41 / cg"
!

floor
    "return the largest integer which is smaller or equal to the receiver.
     For integers, this is the receiver itself."

    ^ self

    "Modified: 18.7.1996 / 12:44:00 / cg"
!

fractionPart
    "return a number with value from digits after the decimal point.
     (i.e. the receiver minus its truncated value)
     Since integers have no fraction, return 0 here."

    ^ 0

    "
     1234.56789 fractionPart
     1.2345e6 fractionPart
     1000 fractionPart
     10000000000000000 fractionPart
    "

    "Modified: 4.11.1996 / 20:27:44 / cg"
!

integerPart
    "return a number with value from digits before the decimal point.
     (i.e. the receiver's truncated value)
     Since integers have no fraction, return the receiver here."

    ^ self

    "
     1234.56789 integerPart
     1.2345e6 integerPart
     1000 integerPart
     10000000000000000 integerPart
    "

    "Modified: 4.11.1996 / 20:28:22 / cg"
!

normalize
    "if the receiver can be represented as a SmallInteger, return
     a SmallInteger with my value; otherwise return self with leading
     zeros removed.
     This method is left for backward compatibility - it has been
     renamed to #compressed for ST-80 compatibility."

    <resource: #obsolete>

    ^ self compressed

    "Modified: 5.11.1996 / 14:08:24 / cg"
!

rounded
    "return the receiver rounded toward the next Integer -
     for integers this is the receiver itself."

    ^ self

    "Modified: 18.7.1996 / 12:44:24 / cg"
!

truncated
    "return the receiver truncated towards zero as Integer
     for integers this is the receiver itself."

    ^ self

    "Modified: 18.7.1996 / 12:44:33 / cg"
! !

!Integer methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitInteger:with: to aVisitor"

    ^ aVisitor visitInteger:self with:aParameter
! !

!Integer::ModuloNumber class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    This is a helper class to perform fast computation of the modulus.
    (with big numbers, this does make a difference)

    WARNING: this does only work with numbers which have no common
             divisor (which is true for cryptographic applications).
             So, use this only if you know what you are doing ...

    [author:]
        Stefan Vogel

    [see also:]
        Integer SmallInteger LargeInsteger

    [instance variables:]
        modulus       the modulus
        reciprocal    reciprocal of the modulus
        shift         shift count to cut off some bits
"
!

examples
"
                                                                [exBegin]
        17 asModuloNumber modulusOf:38
                                                                [exEnd]

                                                                [exBegin]
        38 \\ 17
                                                                [exEnd]
"
! !

!Integer::ModuloNumber class methodsFor:'instance creation'!

modulus:anInteger

    ^ self new modulus:anInteger

    "Created: / 3.5.1999 / 11:13:15 / stefan"
    "Modified: / 3.5.1999 / 11:18:37 / stefan"
! !

!Integer::ModuloNumber methodsFor:'accessing'!

modulus
    "return the modulus"

    ^ modulus
!

modulus:n
    "set the modulus"

    modulus := n.
    reciprocal := n integerReciprocal.
    shift := n highBit negated.

    "Created: / 3.5.1999 / 10:02:39 / stefan"
    "Modified: / 3.5.1999 / 14:30:49 / stefan"
! !

!Integer::ModuloNumber methodsFor:'arithmetic'!

modulusOf:dividend
    "compute the aNumber modulo myself.
     The shortcut works only, if dividend is < modulo * modulo
     (When doing arithmethic modulo something).
     Otherwise do it the long way"

    |e t cnt abs isNegative|

    isNegative := dividend negative.
    isNegative ifTrue:[
        abs := dividend negated.
    ] ifFalse:[
        abs := dividend.
    ].
    abs < modulus ifTrue:[
        ^ abs.
    ].

"/    self assert:dividend < (modulus * modulus)

    "throw off low nbits(modulus)"

    e := (abs bitShift:shift) * reciprocal.
    e := (e bitShift:shift) * modulus.
    e := abs - e.

    "this subtract is done max 2 times"
    cnt := 2.
    [(t := e - modulus) >= 0] whileTrue:[
        e := t.
        cnt == 0 ifTrue:[
            "shortcut didn't work, do it the long way"
            ^ e \\ modulus.
        ].
        cnt := cnt - 1.
    ].
    isNegative ifTrue:[
        ^ modulus - e.
    ].
    ^ e.

    "
     |m|

     m := self new modulus:7.
     m modulusOf:55.
    "

    "Shortcut does not work: (size of divisor vs. dividend):
     |m|

     m := self new modulus:7.
     m modulusOf:123456789901398721398721931729371293712943794254034548369328469438562948623498659238469234659823469823658423659823658.
    "

    "SLOW (using standard \\ operation):
     |m|

     m := 123456789901398721398721931729371293712943794254034548369328469438562948623498659238469234659823469823658423659823658.
     Time millisecondsToRun:[
        100000 timesRepeat:[
            874928459437598375937451931729371293712943794254034548369328469438562948623498659238469234659823469823658423659823658 \\ m
        ]
     ]
    "

    "fast (using moduloNumber with almost same-sized dividend and divisor):
     |m|

     m := self new modulus:123456789901398721398721931729371293712943794254034548369328469438562948623498659238469234659823469823658423659823658.
     Time millisecondsToRun:[
        100000 timesRepeat:[
            m modulusOf:874928459437598375937451931729371293712943794254034548369328469438562948623498659238469234659823469823658423659823658.
        ]
    ].

10730930127807326146398409623772237722337234475792709784029183368622308259008044569184592041059181058049458041058052 
    "

    "Modified: / 3.5.1999 / 14:30:32 / stefan"
! !

!Integer::ModuloNumber methodsFor:'converting'!

asInteger
    "return the modulus"

    ^ modulus
!

asModuloNumber

    ^ self

    "Created: / 3.5.1999 / 14:48:27 / stefan"
! !

!Integer class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Integer initialize!
