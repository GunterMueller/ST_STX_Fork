"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

ArithmeticValue subclass:#Number
	instanceVariableNames:''
	classVariableNames:'DecimalPointCharacterForPrinting DecimalPointCharactersForReading
		DefaultDisplayRadix'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!Number class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    abstract superclass for all kinds of numbers

    [class variables:]
	DecimalPointCharacterForPrinting          <Character>                     used when printing
	DecimalPointCharactersForReading          <Collection of Character>       accepted as decimalPointChars when reading

	DefaultDisplayRadix     the radix in which integers present their
				displayString (which is used in inspectors)
				If you are to look at many hex numbers, bitmasks
				etc. you may set this to 2 or 16.
				(avoids typing printStringRadix:.. all the time
				 - I know - I am lazy ;-). Default is 10.

    [author:]
	Claus Gittinger

    [see also:]
	Integer LargeInteger SmallInteger
	LimitedPrecisionReal Float ShortFloat
	Fraction FixedPoint
"
! !

!Number class methodsFor:'instance creation'!

fastFromString:aString
    "return the next Float, Integer or ShortFloat from the string.
     No spaces are skipped.

     This is a specially tuned entry (using a low-level C-call), which
     returns garbage if the argument string is not a valid float number.
     It has been added to allow high speed string decomposition into numbers,
     especially for mass-data."

    ^ self fastFromString:aString at:1

    "
     Float fromString:'12345.0'
     Float fastFromString:'12345.0'

     Integer fromString:'12345'
     Integer fastFromString:'12345'

     should be roughly 10times faster than the general method:

     Time millisecondsToRun:[
	100000 timesRepeat:[ Float fromString:'12345.0' ]
     ].
     Time millisecondsToRun:[
	100000 timesRepeat:[ Float fastFromString:'12345.0' ]
     ].

     Time millisecondsToRun:[
	100000 timesRepeat:[ Integer fromString:'12345' ]
     ].
     Time millisecondsToRun:[
	100000 timesRepeat:[ Integer fastFromString:'12345' ]
     ].
    "
!

fromString:aString
    "return a number by reading from aString.
     In contrast to readFrom:, no garbage is allowed after the number.
     I.e. the string must contain exactly one valid number (with optional separators around)"

    ^ self
	fromString:aString
	decimalPointCharacters:(self decimalPointCharactersForReading)

    "
     Number fromString:'12345'
     Number fromString:'abc'
     Number fromString:'1abc'   -> raises an error
     Number readFrom:'1abc'     -> reads a 1
     Number readFrom:'10/2'     -> reads a 10
     Number fromString:'10/2'   -> raises an error
     Number fromString:'(1/2)'  -> reads a fraction
     Number readFrom:'(1/2)'    -> reads a fraction
     Number readFrom:'(10/2)'   -> reads a 5
     '12345' asNumber
    "

    "Modified: / 3.8.1998 / 20:05:11 / cg"
!

fromString:aString decimalPointCharacters:decimalPointCharacters
    "return a number by reading from aString.
     In contrast to readFrom:, no garbage is allowed after the number.
     I.e. the string must contain exactly one valid number (with optional separators around)"

    |s num|

    s := aString readStream.
    num := self readFrom:s decimalPointCharacters:decimalPointCharacters onError:[^ ConversionError raiseRequestErrorString:' - invalid number'].
    s atEnd ifFalse:[
	s skipSeparators.
	s atEnd ifFalse:[
	    ^ ConversionError raiseRequestErrorString:' - garbage at end of number'
	].
    ].
    ^ num.

    "
     Number fromString:'12345'
     Number fromString:'abc'
     Number fromString:'1abc'
     '12345' asNumber
    "

    "Modified: / 3.8.1998 / 20:05:11 / cg"
!

fromString:aString decimalPointCharacters:decimalPointCharacters onError:exceptionBlock
    "return a number by reading from aString.
     In contrast to readFrom:, no garbage is allowed after the number.
     I.e. the string must contain exactly one valid number (with optional separators around)"

    |s num|

    s := aString readStream.
    num := self readFrom:s decimalPointCharacters:decimalPointCharacters onError:[^ exceptionBlock value].
    s atEnd ifFalse:[
        s skipSeparators.
        s atEnd ifFalse:[
            ^ exceptionBlock value "/ - garbage at end of number'
        ].
    ].
    ^ num.

    "
     Number fromString:'12345' onError:0
     Number fromString:'12,345' decimalPointCharacters:',' onError:0
     Number fromString:'12,345' decimalPointCharacters:',' onError:0
     Number fromString:'fooBarBaz' onError:0
     Number fromString:'123fooBarBaz' onError:0
     Number fromString:'123,fooBarBaz' decimalPointCharacters:',' onError:0
    "

    "Modified: / 3.8.1998 / 20:05:34 / cg"
!

fromString:aString onError:exceptionBlock
    "return a number by reading from aString.
     In contrast to readFrom:, no garbage is allowed after the number.
     I.e. the string must contain exactly one valid number (with optional separators around)"

    ^ self fromString:aString decimalPointCharacters:(self decimalPointCharactersForReading) onError:exceptionBlock

    "
     Number fromString:'12345' onError:0
     Number fromString:'fooBarBaz' onError:0
     Number fromString:'123fooBarBaz' onError:0
    "

    "Modified: / 3.8.1998 / 20:05:34 / cg"
!

readFrom:aStringOrStream decimalPointCharacters:decimalPointCharacters
    "return the next Number from the (character-)stream aStream;
     skipping all whitespace first.
     Return the value of exceptionBlock, if no number can be read.
     This method is less strict than the smalltalk number reader; it
     allows for prefixed + and also allows missing fractional part after eE.
     It also allows garbage after the number - i.e. it reads what it can.
     See #fromString: , which is more strict and does not allow garbage at the end."

    ^ self
	readFrom:aStringOrStream
	decimalPointCharacters:decimalPointCharacters
	onError:[self error:'conversion error for: ' , self name]

    "
     Number readFrom:'123.456' decimalPointCharacters:'.'
     Number readFrom:'123,456' decimalPointCharacters:'.,'
     Number readFrom:'123,456' decimalPointCharacters:'.'
    "
!

readFrom:aStringOrStream decimalPointCharacters:decimalPointCharacters onError:exceptionBlock
    "return the next Number from the (character-)stream aStream;
     skipping all whitespace first.
     Return the value of exceptionBlock, if no number can be read.
     This method is less strict than the smalltalk number reader; it
     allows for prefixed + and also allows missing fractional part after eE.
     It also allows garbage after the number - i.e. it reads what it can.
     See #fromString: , which is more strict and does not allow garbage at the end."

    ^ [
	|value intValue mantissaAndScale scale decimalMantissa str
	 nextChar radix sign signExp exp numerator denom|

	str := aStringOrStream readStream.

	nextChar := str skipSeparators.
	nextChar isNil ifTrue:[^ exceptionBlock value].

	(nextChar == $-) ifTrue:[
	    sign := -1.
	    str next.
	    nextChar := str peekOrNil
	] ifFalse:[
	    sign := 1.
	    (nextChar == $+) ifTrue:[
		str next.
		nextChar := str peekOrNil
	    ]
	].
	nextChar == $( ifTrue:[
	    "maybe a Fraction e.g. (1/3)"
	    str next.
	    numerator := Integer readFrom:str onError:[^ exceptionBlock value].
	    str skipSeparators.
	    nextChar := str peekOrNil.
	    nextChar == $/ ifTrue:[
		str next.
		denom := Integer readFrom:str onError:[^ exceptionBlock value].
		str skipSeparators.
		nextChar := str peekOrNil.
	    ].
	    nextChar == $) ifFalse:[^ exceptionBlock value].
	    str next.
	    value := Fraction numerator:numerator denominator:denom.
	    ^ value * sign
	].
	nextChar isNil ifTrue:[^ exceptionBlock value].
	(nextChar isDigit or:[(decimalPointCharacters includes:nextChar)]) ifFalse:[
	    ^ exceptionBlock value.
"/          value := super readFrom:str.
"/          sign == -1 ifTrue:[value := value negated].
"/          ^ value
	].
	(decimalPointCharacters includes:nextChar) ifTrue:[
	    radix := 10.
	    value := 0.0.
	    intValue := 0.
	] ifFalse:[
	    value := Integer readFrom:str radix:10.
	    nextChar := str peekOrNil.
	    ((nextChar == $r) or:[ nextChar == $R]) ifTrue:[
		str next.
		radix := value.
		value := Integer readFrom:str radix:radix.
	    ] ifFalse:[
		radix := 10
	    ].
	    intValue := value.
	].

	(self == Integer or:[self inheritsFrom:Integer]) ifFalse:[
	    (decimalPointCharacters includes:nextChar) ifTrue:[
		str next.
		nextChar := str peekOrNil.
		decimalMantissa := 0.
		(nextChar notNil and:[nextChar isDigitRadix:radix]) ifTrue:[
		    |mantissa|
		    mantissaAndScale := self readMantissaAndScaleFrom:str radix:radix.
		    mantissa := mantissaAndScale first.
		    value := (mantissa coerce:value) + mantissa.
		    nextChar := str peekOrNil.
		]
	    ].
	    ('eEdDqQ' includes:nextChar) ifTrue:[
		str next.
		nextChar := str peekOrNil.
		signExp := 1.
		(nextChar == $+) ifTrue:[
		    str next.
		    nextChar := str peekOrNil.
		] ifFalse:[
		    (nextChar == $-) ifTrue:[
			str next.
			nextChar := str peekOrNil.
			signExp := -1
		    ]
		].
		('qQ' includes:nextChar) ifTrue:[
		    value := value asLongFloat.
		] ifFalse:[
		    value := value asFloat.
"/ future: (for now, always create Doubles for Dolphin,Squeak etc. compatibility)
"/                ('eE' includes:nextChar) ifTrue:[
"/                    value := value asShortFloat
"/                ]
		].
		(nextChar notNil and:[(nextChar isDigitRadix:radix)]) ifTrue:[
		    exp := (Integer readFrom:str radix:radix) * signExp.
		    value := value * ((value class unity * 10.0) raisedToInteger:exp)
		]
	    ] ifFalse:[
		('sS' includes:nextChar) ifTrue:[
		    str next.

		    nextChar := str peekOrNil.
		    (nextChar notNil and:[ nextChar isDigit]) ifTrue:[
			scale := (Integer readFrom:str).
		    ].

		    mantissaAndScale isNil ifTrue:[
			value := intValue asFixedPoint:(scale ? 0).
		    ] ifFalse:[
			denom := 10 raisedTo:mantissaAndScale last.
			value := FixedPoint
				    numerator:(intValue * denom) + (mantissaAndScale second)
				    denominator:denom
				    scale:(scale ? mantissaAndScale third).
		    ].
		] ifFalse:[
		    (self inheritsFrom:LimitedPrecisionReal) ifTrue:[
			"when requesting a specific Float instance, coerce it.
			 otherwise return a value without loosing precision"
			value := self coerce:value.
		    ].
		].
	    ].
	].
	sign == -1 ifTrue:[
	    value := value negated
	].
	value.
    ] on:Error do:exceptionBlock

    "
     Number readFrom:(ReadStream on:'54.32e-01')
     Number readFrom:(ReadStream on:'12345678901234567890')
     Number readFrom:(ReadStream on:'12345678901234567890.0')
     Number readFrom:(ReadStream on:'12345678901234567890.012345678901234567890')
     Number readFrom:(ReadStream on:'16rAAAAFFFFAAAAFFFF')
     Number readFrom:'16rAAAAFFFFAAAAFFFF'
     Number readFrom:'0.000001'
     '+00000123.45' asNumber
     Number readFrom:'(1/3)'
     Number readFrom:'(-1/3)'
     Number readFrom:'(1/-3)'
     Number readFrom:'-(1/3)'
     Number readFrom:'-(-1/3)'
     Number readFrom:'(-1/3'
     Number readFrom:'99s'
     Number readFrom:'99.00s'
     Number readFrom:'99.0000000s'
     Number readFrom:'.0000000s'
     Number readFrom:'.0000000q'
     Number readFrom:'.0000000f'
     Number readFrom:'.0000000e'
     Number readFrom:'.0000000s1'
     Number readFrom:'.0000000q1'
     Number readFrom:'.0000000f1'
     Number readFrom:'.0000000e1'
     LongFloat readFrom:'.00000001'
     Number readFrom:'.00000000000001'
     Number readFrom:'.001'
     ShortFloat readFrom:'.001'
     Number readFrom:'123garbage'      -> returns 123
     Number fromString:'123garbage'    -> raises an error

     DecimalPointCharactersForReading := #( $. $, ).
     Number readFrom:'99,00'

     DecimalPointCharactersForReading := #( $. ).
     Number readFrom:'99,00'
    "

    "Modified: / 14.4.1998 / 19:22:50 / cg"
!

readFrom:aStringOrStream onError:exceptionBlock
    "return the next Number from the (character-)stream aStream;
     skipping all whitespace first; return the value of exceptionBlock,
     if no number can be read.
     This method is less strict than the smalltalk number reader; it
     allows for prefixed + and also allows missing fractional part after eE.
     It also allows garbage after the number - i.e. it reads what it can.
     See #fromString: , which is more strict and does not allow garbage at the end."

    ^ self
	readFrom:aStringOrStream
	decimalPointCharacters:(self decimalPointCharactersForReading)
	onError:exceptionBlock

    "
     Number readFrom:(ReadStream on:'54.32e-01')
     Number readFrom:(ReadStream on:'12345678901234567890')
     Number readFrom:(ReadStream on:'12345678901234567890.0')
     Number readFrom:(ReadStream on:'12345678901234567890.012345678901234567890')
     Number readFrom:(ReadStream on:'16rAAAAFFFFAAAAFFFF')
     Number readFrom:'16rAAAAFFFFAAAAFFFF'
     Number readFrom:'0.000001'
     '+00000123.45' asNumber
     Number readFrom:'99s'
     Number readFrom:'99.00s'
     Number readFrom:'99.0000000s'
     Number readFrom:'.0000000s'
     Number readFrom:'.0000000q'
     Number readFrom:'.0000000f'
     Number readFrom:'.0000000e'
     Number readFrom:'.0000000s1'
     Number readFrom:'.0000000q1'
     Number readFrom:'.0000000f1'
     Number readFrom:'.0000000e1'

     DecimalPointCharactersForReading := #( $. $, ).
     Number readFrom:'99,00'

     DecimalPointCharactersForReading := #( $. ).
     Number readFrom:'99,00'
    "
!

readSmalltalkSyntaxFrom:aStream
    "ST-80 compatibility (thanks to a note from alpha testers)
     read and return the next Number in smalltalk syntax from the
     (character-) aStream.
     Returns nil if aStream contains no valid number."

    ^ self readSmalltalkSyntaxFrom:aStream onError:nil.

    "
     Number readSmalltalkSyntaxFrom:'99d'
     Number readSmalltalkSyntaxFrom:'99.00d'
     Number readSmalltalkSyntaxFrom:'54.32e-01'
     Number readSmalltalkSyntaxFrom:'12345678901234567890'
     Number readSmalltalkSyntaxFrom:'16rAAAAFFFFAAAAFFFF'
     Number readSmalltalkSyntaxFrom:'foobar'
     Number readSmalltalkSyntaxFrom:'(1/10)'

     Number readSmalltalkSyntaxFrom:'(1/0)'

     Number readFrom:'(1/3)'
     Number readFrom:'(-1/3)'
     Number readFrom:'-(1/3)'
     Number readFrom:'(1/-3)'
     Number readFrom:'(-1/-3)'
     Number readFrom:'-(-1/-3)'
     Number readSmalltalkSyntaxFrom:'+00000123.45'
     Number readFrom:'+00000123.45'

     |s|
     s := ReadStream on:'2.'.
     Number readSmalltalkSyntaxFrom:s.
     s next

     |s|
     s := ReadStream on:'2.0.'.
     Number readSmalltalkSyntaxFrom:s.
     s next
    "

    "Modified: / 19.11.1999 / 18:26:47 / cg"
!

readSmalltalkSyntaxFrom:aStream onError:errorValue
    "ST-80 compatibility (thanks to a note from alpha testers)
     read and return the next Number in smalltalk syntax from the
     (character-) aStream.
     Returns nil if aStream contains no valid number."

    |n|

    [
	n := Scanner scanNumberFrom:aStream.
    ] on:Error do:[:ex|
	n := nil
    ].
    n isNil ifTrue:[^ errorValue value].
    ^ n

    "
     Number readSmalltalkSyntaxFrom:'foo' onError:123
    "
! !

!Number class methodsFor:'Compatibility-VW'!

readIntegerFrom:aStream radix:radix
    "for VisualWorks compatibiity"

    ^ Integer readFrom:aStream radix:radix
! !


!Number class methodsFor:'constants'!

decimalPointCharacter
    "printed"

    <resource: #obsolete>

    ^ self decimalPointCharacterForPrinting
!

decimalPointCharacter:aCharacter
    "printed"

    <resource: #obsolete>

    self decimalPointCharacterForPrinting:aCharacter

    "
     1.5 printString

     Number decimalPointCharacter:$,.
     1.5 printString
     Number decimalPointCharacter:$..
    "
!

decimalPointCharacterForPrinting
    "printed"

    ^ DecimalPointCharacterForPrinting ? $.
!

decimalPointCharacterForPrinting:aCharacter
    "printed"

    DecimalPointCharacterForPrinting := aCharacter

    "
     1.5 printString

     Number decimalPointCharacterForPrinting:$,.
     1.5 printString
     Number decimalPointCharacterForPrinting:$..
    "
!

decimalPointCharacters
    "accepted when converting from a string"

    <resource: #obsolete>

    ^ self decimalPointCharactersForReading

    "
     1.5 printString

     Number decimalPointCharacters:#( $. $,) .
     Number fromString:'1.5'.
     Number fromString:'1,5'.
     Number decimalPointCharacters:#( $. ).
    "
!

decimalPointCharacters:aCollectionOfCharacters
    "accepted when converting from a string"

    <resource: #obsolete>

    self decimalPointCharactersForReading:aCollectionOfCharacters

    "
     Number decimalPointCharacters:#( $. $,) .
     Number fromString:'1.5'.
     Number fromString:'1,5'.
     Number decimalPointCharacters:#( $. ).
    "
!

decimalPointCharactersForReading
    "default when converting from a string"

    "/ cg: changing the default leads to trouble in some
    "/ language processors (PrologScanner...)
    "/ PLEASE DO ONLY CHANGE THE DEFAULT BELOW FOR END-USER APPLICATIONS (if at all).
    "/ BETTER: pass the DecimalPointCharacterSet explicitly
    DecimalPointCharactersForReading isNil ifTrue:[
	^ #( $. )
    ].
    ^ DecimalPointCharactersForReading

    "
     1.5 printString

     Number decimalPointCharactersForReading:#( $. $,) .
     Number fromString:'1.5'.
     Number fromString:'1,5'.
     Number decimalPointCharactersForReading:#( $. ).
    "
!

decimalPointCharactersForReading:aCollectionOfCharacters
    "accepted when converting from a string"

    DecimalPointCharactersForReading := aCollectionOfCharacters

    "
     Number decimalPointCharactersForReading:#( $. $,) .
     Number fromString:'1.5'.
     Number fromString:'1,5'.
     Number decimalPointCharactersForReading:#( $. ).
    "
!

epsilon
    "return the maximum relative spacing of instances of mySelf
     (i.e. the value-delta of the least significant bit)"

     ^ self subclassResponsibility
!

epsilonForCloseTo
    "return the epsilon used in the closeTo: comparison.
     (useful would be something like self epsilon or epsilon*10,
      but for Squeak compatibility.... - sigh)"

    ^ 0.0001

    "
     Float epsilon
     ShortFloat epsilon
     Float epsilon10
     ShortFloat epsilon10
    "
!

pi
    "return Pi in my representation (and accuracy)."

     ^ self subclassResponsibility
! !

!Number class methodsFor:'error reporting'!

raise:aSignalSymbolOrErrorClass receiver:someNumber selector:sel arg:arg errorString:text
    "ST-80 compatible signal raising. Provided for PD numeric classes"

    <context: #return>

    ^ self
	raise:aSignalSymbolOrErrorClass
	receiver:someNumber
	selector:sel
	arguments:(Array with:arg)
	errorString:text

    "
     Number
	raise:#domainErrorSignal
	receiver:1.0
	selector:#sin
	arg:nil
	errorString:'foo bar test'
    "

    "Modified: / 16.11.2001 / 14:12:50 / cg"
!

raise:aSignalSymbolOrErrorClass receiver:someNumber selector:sel errorString:text
    "ST-80 compatible signal raising. Provided for PD numeric classes.
     aSignalSymbolOrErrorClass is either an Error-subclass, or
     the selector which is sent to myself, to retrieve the Exception class / Signal."

    <context: #return>

    ^ self
	raise:aSignalSymbolOrErrorClass
	receiver:someNumber
	selector:sel
	arguments:#()
	errorString:text

    "
     Number
	raise:#domainErrorSignal
	receiver:1.0
	selector:#foo
	errorString:'foo bar test'
    "

    "Modified: / 16.11.2001 / 14:13:16 / cg"
! !

!Number class methodsFor:'misc'!

displayRadix:aNumber
    "being tired of always sending #printStringRadix: in the inspectors,
     this allows you to change the default print radix for the displayString
     method."

    DefaultDisplayRadix := aNumber

    "
     Integer displayRadix:16. 123456 inspect
     Integer displayRadix:10. 123456 inspect
    "
! !


!Number class methodsFor:'private'!

readMantissaAndScaleFrom:aStream radix:radix
    "helper for readFrom: -
     return the mantissa (post-decimal-point digits) from the (character-)stream aStream;
     In addition, the scale (number of postDecimalPoint digits) is returned
     (to support reading fixedPoint numbers).
     No whitespace is skipped.
     Errs if no number is available on aStream."

    |nextChar value factor intMantissa scale digit|

    value := 0.0.
    factor := 1.0 / radix.
    scale := 0.
    intMantissa := 0.
    nextChar := aStream peekOrNil.
    [nextChar notNil and:[nextChar isDigitRadix:radix]] whileTrue:[
	digit := nextChar digitValue.
	value := value + (digit * factor).
	intMantissa := (intMantissa * radix) + digit.
	factor := factor / radix.
	scale := scale + 1.
	scale > 6 ifTrue:[
	    factor := factor asLongFloat.
	    value := value asLongFloat.
	].
	aStream next.
	nextChar := aStream peekOrNil
    ].

    ^ (Array with:value with:intMantissa with:scale).

    "
     Number readMantissaAndScaleFrom:'234'    readStream radix:10.
     Number readMantissaAndScaleFrom:'2'      readStream radix:10.
     Number readMantissaAndScaleFrom:'234567' readStream radix:10.
     Number readMantissaAndScaleFrom:'234000' readStream radix:10.
     Number readMantissaAndScaleFrom:'234'    readStream radix:10.

     Number readMantissaAndScaleFrom:'12345678901234567890' readStream radix:10.
    "

    "Modified: / 14.4.1998 / 18:47:47 / cg"
!

readMantissaFrom:aStream radix:radix
    "helper for readFrom: -
     return the mantissa (post-decimal-point digits)
     from the (character-)stream aStream;
     No whitespace is skipped.
     Errs if no number available."

    ^ (self readMantissaAndScaleFrom:aStream radix:radix) first

    "
     Number readMantissaFrom:'234'    readStream radix:10.
     Number readMantissaFrom:'2'      readStream radix:10.
     Number readMantissaFrom:'234567' readStream radix:10.
    "

    "Modified: / 14.4.1998 / 18:47:47 / cg"
! !

!Number class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for Number here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == Number
! !


!Number methodsFor:'Compatibility-Squeak'!

asSmallAngleDegrees
    "Return the receiver normalized to lie within the range (-180, 180)"

    | pos |

    pos := self \\ 360.
    pos > 180 ifTrue: [pos := pos - 360].
    ^ pos

    "
     #(-500 -300 -150 -5 0 5 150 300 500 1200)
	collect: [:n | n asSmallAngleDegrees]
    "
!

closeFrom:aNumber
    "are these two numbers close?"

    ^ self closeFrom:aNumber withEpsilon:(self class epsilonForCloseTo)

    "
     9.0 closeTo: 8.9999
     9.9 closeTo: 9
     (9/3) closeTo: 2.9999
     1 closeTo: 0.9999
     1 closeTo: 1.0001
     1 closeTo: 1.001
     1 closeTo: 0.999

     0.9999 closeTo: 1
     1.0001 closeTo: 1
     1.001 closeTo: 1
     0.999 closeTo: 1
     Float NaN closeTo:Float NaN
     Float infinity closeTo:Float infinity
    "
!

closeFrom:aNumber withEpsilon:eps
    "are these two numbers close?"

    | fuzz |

    self isNaN == aNumber isNaN ifFalse: [^ false].
    self isInfinite == aNumber isInfinite ifFalse: [^ false].

    fuzz := (self abs max:aNumber abs) * eps.
    ^ (self - aNumber) abs <= fuzz

    "
     9.0 closeTo: 8.9999
     9.9 closeTo: 9
     (9/3) closeTo: 2.9999
     1 closeTo: 0.9999
     1 closeTo: 1.0001
     1 closeTo: 1.001
     1 closeTo: 0.999

     0.9999 closeTo: 1
     1.0001 closeTo: 1
     1.001 closeTo: 1
     0.999 closeTo: 1
     Float NaN closeTo:Float NaN
     Float infinity closeTo:Float infinity
    "
!

closeTo:num
    "are these two numbers close to each other?"

    ^ self closeTo:num withEpsilon:(self class epsilonForCloseTo)

    "
     1 closeTo:1.0000000001
     1 closeTo:1.001
     1 closeTo:1.001 withEpsilon:0.001
    "

    "Created: / 5.11.2001 / 18:07:26 / cg"
!

closeTo:num withEpsilon:eps
    "are these two numbers close to each other?"

    num isNumber ifFalse:[^false].
    ^ num closeFrom:self withEpsilon:eps

    "
     1 closeTo:1.0000000001
     1 closeTo:1.001

     1 closeTo:1.001 withEpsilon:0.1
     1 closeTo:1.201 withEpsilon:0.1

     3.14 closeTo:(3.14 asFixedPoint:2)
     (3.14 asFixedPoint:2) closeTo:3.14
    "

    "Created: / 05-11-2001 / 18:07:26 / cg"
    "Modified: / 02-08-2010 / 13:27:22 / cg"
!

degreeCos
    "Return the cosine of the receiver taken as an angle in degrees."

    ^ self degreesToRadians cos
!

degreeSin
    "Return the sine of the receiver taken as an angle in degrees."

    ^ self degreesToRadians sin
!

degreeTan
    "Return the cosine of the receiver taken as an angle in degrees."

    ^ self degreesToRadians tan
!

isEqual: aNumber within: accuracy
	^(self - aNumber) abs < accuracy
!

rounded:n
    "Answer the float rounded with n digits of precision"

    | mult |

    mult := 10 raisedTo: n.
    ^ (((self * mult) rounded) asFloat / mult).

    "
     7 rounded:2
     7.1 rounded:2
     7.2345 rounded:2
     7.2385 rounded:2
     7.2341 rounded:3
     7.2345 rounded:3
     7.2348 rounded:3
    "
!

stringForReadout
    ^ self rounded printString
! !


!Number methodsFor:'coercing & converting'!

i
    "return a complex number, with the receiver as imaginary part, 0 as real part"

    ^ Complex
	real:0
	imaginary:self

    "
     3i
     (1+1i)
    "
! !

!Number methodsFor:'comparing'!

isAlmostEqualTo:aNumber nEpsilon:nE
    "return true, if the argument, aNumber represents almost the same numeric value
     as the receiver, false otherwise.

     nE is the number of minimal float distances, that the numbers may differ and
     still be considered equal. See documentation in LimitedPrecisionReal for more detail.

     For background information why floats need this
     read: http://randomascii.wordpress.com/2012/02/25/comparing-floating-point-numbers-2012-edition/
    "

    |f1 f2 diff scaledEpsilon largest|

    diff := (self - aNumber) abs.

    scaledEpsilon := nE * diff class epsilon.

    diff <= scaledEpsilon ifTrue:[
	"compare for really close values near 0"
	^ true.
    ] ifFalse:[
	"scaled comparison for larger values"
	f1 := self abs.
	f2 := aNumber abs.
	largest := f1 > f2 ifTrue:[f1] ifFalse:[f2].
	^ (diff <= (scaledEpsilon * largest)).
    ].
! !

!Number methodsFor:'converting'!

% aNumber
    "Return a complex number with the receiver as the real part and
     aNumber as the imaginary part"

    ^ Complex real:self imaginary:aNumber

    "Modified: / 9.7.1998 / 10:18:12 / cg"
!

+/- anError
    "return a MeasurementValue with a given error."

    ^ MeasurementValue value:self minValue:(self-anError) maxValue:(self+anError)

    "
     (100 +/- 5) * 2
     (100 +/- 5) * (100 +/- 10)
     (100 +/- 5) + (100 +/- 10)
     (100 +/- 5) - (100 +/- 10)
    "

    "Modified (comment): / 14-02-2012 / 14:17:36 / cg"
!

@ aNumber
    "return a Point with the receiver as x-coordinate and the argument
     as y-coordinate"

%{  /* NOCONTEXT */

    /*
     * I cannot tell if this special code is worth anything
     */
    if (__CanDoQuickNew(sizeof(struct __Point))) {      /* OBJECT ALLOCATION */
	OBJ newPoint;
	int spc;

	__qCheckedNew(newPoint, sizeof(struct __Point));
	__InstPtr(newPoint)->o_class = @global(Point);
	__qSTORE(newPoint, @global(Point));
	__PointInstPtr(newPoint)->p_x = self;
	__PointInstPtr(newPoint)->p_y = aNumber;
	if (! __bothSmallInteger(self, aNumber)) {
	    spc = __qSpace(newPoint);
	    __STORE_SPC(newPoint, aNumber, spc);
	    __STORE_SPC(newPoint, self, spc);
	}
	RETURN ( newPoint );
    }
%}
.
    ^ Point x:self y:aNumber
!

asComplex
    "Return a complex number with the receiver as the real part and
     zero as the imaginary part"

    ^ Complex real:self

    "Modified: / 9.7.1998 / 10:18:16 / cg"
!

asMetaNumber
    ^ SomeNumber new realNumber:self
!

asNumber
    "I am a number, so return myself"

    ^ self.
!

asPercentFrom:fullAmount
    "what is the percentage
     taking the receiver's value from the argument"

    ^ (self / fullAmount) * 100.

    "
     20 asPercentFrom:100
     (10 asPercentFrom:156) asFixedPoint:2
     (15.6 asPercentFrom:156) asFixedPoint:2
    "
!

asPoint
    "return a new Point with the receiver as all coordinates;
     often used to supply the same value in two dimensions, as with
     symmetrical gridding or scaling."

%{  /* NOCONTEXT */

    if (__CanDoQuickNew(sizeof(struct __Point))) {      /* OBJECT ALLOCATION */
	OBJ newPoint;

	__qCheckedNew(newPoint, sizeof(struct __Point));
	__InstPtr(newPoint)->o_class = @global(Point);
	__qSTORE(newPoint, @global(Point));
	__PointInstPtr(newPoint)->p_x = self;
	__PointInstPtr(newPoint)->p_y = self;
	__STORE(newPoint, self);
	RETURN ( newPoint );
    }
%}.
    ^ Point x:self y:self
!

asTimeDuration
    "return an TimeDuration object from the receiver, taking the receiver
     as number of seconds"

    ^ TimeDuration seconds:self

    "
     5 asTimeDuration
     50.25 asTimeDuration
     3600 asTimeDuration
    "

    "Created: / 08-01-2012 / 19:04:04 / cg"
!

degreesToRadians
    "interpreting the receiver as degrees, return the radians"

    ^ self * (Float pi / 180.0)

    "
     180 degreesToRadians
     Float pi radiansToDegrees
    "
!

literalArrayEncoding
    "encode myself as an array literal, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    ^ self

    "Modified: 1.9.1995 / 02:25:26 / claus"
    "Modified: 22.4.1996 / 13:00:27 / cg"
!

percentOf:hundredPercent
    "how many is self-percent from the argument"

    ^ (hundredPercent / 100 * self)

    "
     20 percentOf:100
     (10 percentOf:156) asFixedPoint:2
     (105 percentOf:156) asFixedPoint:2
    "
!

radiansToDegrees
    "interpreting the receiver as radians, return the degrees"

    ^ self * (180.0 / Float pi)

    "
     180 degreesToRadians
     Float pi radiansToDegrees
    "
!

withScale:newScale
    "return a fixedPoint number representing the same value as the receiver,
     with newScale number of post-decimal digits"

    ^ self asFixedPoint:newScale

    "
     1234 withScale:2
     1234.1 withScale:2
     1234.12 withScale:2
     1234.123 withScale:2
     (1/7) withScale:2
    "
! !

!Number methodsFor:'converting-times'!

days
    "return a TimeDuration representing this number of days"

    ^ TimeDuration days:self

    "
     1000 milliseconds
     10 seconds
     10 minutes
     1 days
    "
!

hours
    "return a TimeDuration representing this number of hours"

    ^ TimeDuration hours:self

    "
     1000 milliseconds
     10 seconds
     10 minutes
    "
!

milliseconds
    "return a TimeDuration representing this number of milliseconds"

    ^ TimeDuration fromMilliseconds:self

    "
     1000 milliseconds
    "
!

minutes
    "return a TimeDuration representing this number of minutes"

    ^ TimeDuration minutes:self

    "
     1000 milliseconds
     10 seconds
     10 minutes
    "
!

seconds
    "return a TimeDuration representing this number of seconds"

    ^ TimeDuration seconds:self

    "
     1000 milliseconds
     10 seconds
     10 minutes
    "
!

weeks
    "return a TimeDuration representing this number of weeks"

    ^ TimeDuration weeks:self

    "
     1000 milliseconds
     10 seconds
     10 minutes
     1 days
     1 weeks
    "

    "Created: / 05-09-2011 / 11:17:59 / cg"
! !

!Number methodsFor:'double dispatching'!

differenceFromTimestamp:aTimestamp
    "I am to be interpreted as seconds, return the timestamp this number of seconds
     before aTimestamp"

    ^ aTimestamp subtractMilliseconds:(self * 1000) truncated.

    "
     100.0 differenceFromTimestamp:Timestamp now

     |t1 t2|
     t1 := Timestamp now.
     t2 := 1.5 differenceFromTimestamp:t1.
     t1 inspect. t2 inspect.
    "
! !

!Number methodsFor:'intervals'!

downTo:stop
    "return an interval from receiver down to the argument, incrementing by -1"

    ^ self to:stop by:-1

    "
     (10 downTo:1) do:[:i | Transcript showCR:i].
    "
!

downTo:stop by:step
    "return an interval from receiver down to the argument, decrementing by step"

    ^ self to:stop by:step negated

    "
     (10 downTo:1 by:0.5) do:[:i | Transcript showCR:i].
    "

    "Created: / 01-08-2013 / 14:36:56 / cg"
!

to:stop
    "return an interval from receiver up to the argument, incrementing by 1"

    ^ Interval from:self to:stop
!

to:stop by:step
    "return an interval from receiver up to the argument, incrementing by step"

    ^ Interval from:self to:stop by:step
!

to:stop byFactor:factor
    "return a geometric series from receiver up to the argument;
     elements have a constant factor in between"

    ^ GeometricSeries from:self to:stop byFactor:factor

    "
     (1 to:256 byFactor:2)
     (256 to:1 byFactor:1/2)
    "
! !

!Number methodsFor:'iteration'!

timesRepeat:aBlock
    "evaluate the argument, aBlock self times"

    |count|

    count := self.
    [count > 0] whileTrue:[
	aBlock value.
	count := count - 1
    ]
! !

!Number methodsFor:'mathematical functions'!

cbrt
    "return the cubic root of the receiver"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat cbrt.
    ].
    "/ very slow fallback
    ^ self cbrt_withAccuracy:self epsilon
!

conjugated
    "Return the complex conjugate of this Number."

    ^ self

    "Modified: / 9.7.1998 / 10:17:31 / cg"
!

exp
    "compute e**x of the receiver"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat exp.
    ].
    "/ very slow fallback
    ^ self exp_withAccuracy:self epsilon
!

floorLog:radix
    "return the logarithm truncated as an integer"

    ^ (self log:radix) floor
!

imaginary
    "Return the imaginary part of this Number."

    ^ 0

    "Modified: / 9.7.1998 / 10:17:24 / cg"
!

ln
    "return the natural logarithm of myself.
     Raises an exception, if the receiver is less or equal to zero."

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asLongFloat ln.
    ].
    "/ very slow fallback
    ^ self ln_withAccuracy:self epsilon

    "
	(10 raisedTo:1000) ln
    "
!

log
    "return log base 10 of the receiver.
     Alias for log:10."

    ^ self log10
!

log10
    "return log base 10 of the receiver"

    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asLongFloat log10.
    ].
    ^ self log:10

    "
	(10 raisedTo:1000) log10
    "
!

log:aNumber
    "return log base aNumber of the receiver.
     This will usually return a float value"

    ^ self ln / aNumber ln

    "
      1000 log:10
      9 log:3
      (1000 log:10) floor
      (10 raisedTo:1000) log:10
    "
!

raisedTo:aNumber
    "return the receiver raised to aNumber"

    aNumber = 0 ifTrue:[^ 1].
    aNumber = 1 ifTrue:[^ self].
    aNumber isInteger ifTrue:[
	^ self raisedToInteger:aNumber
    ].
    aNumber isNumber ifFalse:[
	^ aNumber raisedFromNumber:self.
    ].
    ^ self asFloat raisedTo:aNumber

    "
     2 raisedTo: 4
     -2 raisedTo: 4
     4 raisedTo: 1/2
     -4 raisedTo: 1/2
     8 raisedTo: 1/3
     -8 raisedTo: 1/3
     10 raisedTo: 4
     10 raisedTo: -4
    "
!

real
    "Return the real part of this Number."

    ^ self

    "Modified: / 9.7.1998 / 10:17:17 / cg"
!

sqrt
    "return the square root of the receiver"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat sqrt.
    ].
    "/ very slow fallback
    ^ self sqrt_withAccuracy:self epsilon
!

sqrtWithErrorLessThan:epsilon
    "compute the square root, using the Newton method.
     The approximated return value has an error less than the given epsilon."

    |y yN|

    yN := self / 2.
    [
       y := yN.
       yN := ( y + (self / y) ) / 2.
    ] doUntil:[ (yN - y) abs < epsilon ].
    ^ yN.

    "
     (2 asFixedPoint:4) sqrtWithErrorLessThan:0.001
    "
!

timesTwoPower:anInteger
    "Return the receiver multiplied by 2 raised to the power of the argument.
     For protocol completeness wrt. Squeak and ST80."

    anInteger >= 0 ifTrue:[
	^ self * (1 bitShift:anInteger)
    ].
    ^ self / (1 bitShift:anInteger negated)

    "
     123 timesTwoPower:0   -> 123
     123 timesTwoPower:1   -> 246
     123 timesTwoPower:2   -> 492
     123 timesTwoPower:3   -> 984

     (2 timesTwoPower: -150) timesTwoPower: 150  -> 2
    "
! !

!Number methodsFor:'measurement values'!

maxValue
    "the maximum possible value taking me as a measurement with possible error;
     as I am exact, that's myself"

    ^ self
!

minValue
    "the minimum possible value taking me as a measurement with possible error;
     as I am exact, that's myself"

    ^ self
! !

!Number methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "return a string to display the receiver.
     The output radix is usually 10, but can be changed by setting
     DefaultDisplayRadix (see Integer>>displayRadix:)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
	^ super displayOn:aGCOrStream
    ].

    (DefaultDisplayRadix isNil or:[DefaultDisplayRadix == 10]) ifTrue:[
	self printOn:aGCOrStream
    ] ifFalse:[
	self printOn:aGCOrStream base:DefaultDisplayRadix showRadix:true.
    ].

    "
     Integer displayRadix:16. 12345
     Integer displayRadix:2.  12345
     Integer displayRadix:10. 12345
    "
!

printOn:aStream
    "append a printed description of the receiver to aStream"

    self printOn:aStream base:10

    "Modified: / 20.1.1998 / 14:10:45 / stefan"
!

printOn:aStream base:b
    "return a string representation of the receiver in the specified
     radix (without the initial XXr)"

    ^ self printOn:aStream base:b showRadix:false

    "
     10 printOn:Transcript base:3
     31 printOn:Transcript base:3
     -20 printOn:Transcript base:16
     -20 printOn:Transcript base:10
     3000 factorial printOn:Transcript base:10
    "

    "Modified: / 20.1.1998 / 18:05:02 / stefan"
    "Modified: / 7.9.2001 / 13:52:17 / cg"
!

printOn:aStream base:b showRadix:showRadix
    "the central print method for integer.
     Must be defined in concrete classes"

    self subclassResponsibility
!

printOn:aStream paddedWith:padCharacter to:size base:radix
    |s|

    radix == 10 ifTrue:[
	s := self printString.
    ] ifFalse:[
	s := self printStringRadix:radix.
    ].
    s printOn: aStream leftPaddedTo:size with: padCharacter

    "
     100 printOn:Transcript paddedWith:$0 to:10 base:10.     Transcript cr.
     100 printOn:Transcript paddedWith:$0 to:10 base:16.     Transcript cr.
     100 printOn:Transcript paddedWith:(Character space) to:10 base:16.     Transcript cr.
     100 printOn:Transcript paddedWith:(Character space) to:10 base:2.     Transcript cr.
    "
!

printOn:aStream thousandsSeparator:thousandsSeparator
    "print the receiver as business number with thousands separator to aStream.
     thousandsSeparator is locale specific and is usualy a single quote ('), a comma or period."

    |rest|

    self >= 1000 ifTrue:[
	(self // 1000) printOn:aStream thousandsSeparator:thousandsSeparator.
	thousandsSeparator printOn:aStream.
	rest := self \\ 1000.
	rest < 100 ifTrue:[
	    aStream nextPut:$0.
	    rest < 10 ifTrue:[
		aStream nextPut:$0.
	    ].
	].
	rest printOn:aStream.
	^ self.
    ].
    self printOn:aStream.

    "
     swiss style:
     1000000 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     12345678 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     1234567 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     123456 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     123056 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     12345 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     1234 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     123 printOn:Transcript thousandsSeparator:$'.     Transcript cr.

     (12345678.12 asFixedPoint:2) printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     1234567.12 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     123456.12 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     123056.12 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     12345.12 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     1234.12 printOn:Transcript thousandsSeparator:$'.     Transcript cr.
     123.12 printOn:Transcript thousandsSeparator:$'.     Transcript cr.

     us style:
     1000000 printOn:Transcript thousandsSeparator:$,.     Transcript cr.
     12345678 printOn:Transcript thousandsSeparator:$,.     Transcript cr.
     1234567 printOn:Transcript thousandsSeparator:$,.     Transcript cr.
     123456 printOn:Transcript thousandsSeparator:$,.     Transcript cr.
     12345 printOn:Transcript thousandsSeparator:$,.     Transcript cr.
     1234 printOn:Transcript thousandsSeparator:$,.     Transcript cr.
     123 printOn:Transcript thousandsSeparator:$,.     Transcript cr.

     german (european ?) style
     1000000 printOn:Transcript thousandsSeparator:$..     Transcript cr.
     12345678 printOn:Transcript thousandsSeparator:$..     Transcript cr.
     1234567 printOn:Transcript thousandsSeparator:$..     Transcript cr.
     123456 printOn:Transcript thousandsSeparator:$..     Transcript cr.
     12345 printOn:Transcript thousandsSeparator:$..     Transcript cr.
     1234 printOn:Transcript thousandsSeparator:$..     Transcript cr.
     123 printOn:Transcript thousandsSeparator:$..     Transcript cr.
    "
!

printStringFormat:formatString
    ^ self printfPrintString:formatString
!

printStringRadix:base
    "return a string representation of the receiver in the specified
     base; does NOT prepend XXr to the string.
     See also: radixPrintStringRadix:
               printOn:base:showRadix:"

    ^ self printStringRadix:base showRadix:false

    "
     10000000000000000000000000000000000000000000 printStringRadix:16    
     -10000000000000000000000000000000000000000000 printStringRadix:16   
    "
!

printStringRadix:base showRadix:showRadixBoolean
    "return a string representation of the receiver in the specified
     base; does NOT prepend XXr to the string.
     See also: radixPrintStringRadix:
	       printOn:base:showRadix:"

    |s|

    s := WriteStream on:(String basicNew:20).
    self printOn:s base:base showRadix:showRadixBoolean.
    ^ s contents

    "
     10000000000000000000000000000000000000000000 printStringRadix:16 showRadix:false
     10000000000000000000000000000000000000000000 printStringRadix:16 showRadix:true
    "


    "Created: / 23-09-2011 / 13:59:19 / cg"
!

printStringWithThousandsSeparator
    "print the receiver as swiss business number with thousands separator to aStream.
     Caveat: Should use the separator from the locale here"

    ^ self printStringWithThousandsSeparator:(UserPreferences current thousandsSeparatorCharacter).

    "
     1000000 printStringWithThousandsSeparator
     12345678 printStringWithThousandsSeparator
     1234567 printStringWithThousandsSeparator
     123456 printStringWithThousandsSeparator
     12345 printStringWithThousandsSeparator
     1234 printStringWithThousandsSeparator
     123 printStringWithThousandsSeparator

     1000000 asFixedPoint printStringWithThousandsSeparator
     12345678 asFixedPoint printStringWithThousandsSeparator
     1234567 asFixedPoint printStringWithThousandsSeparator
     123456 asFixedPoint printStringWithThousandsSeparator
     12345 asFixedPoint printStringWithThousandsSeparator
     1234 asFixedPoint printStringWithThousandsSeparator
     123 asFixedPoint printStringWithThousandsSeparator
     ((9999999//10000) asFixedPoint:9) printStringWithThousandsSeparator
     ((99999999//10000) asFixedPoint:9) printStringWithThousandsSeparator
    "
!

printStringWithThousandsSeparator:thousandsSeparator
    "print the receiver as business number with a thousands separator to aStream.
     Notice:
	americans use comma
	germans (europeans ?) use a dot
	swiss people (business people ?) use a single quote

     Caveat: Should use the separator from the locale here"

    ^ String streamContents:[:s | self printOn:s thousandsSeparator:thousandsSeparator].

    "
     Transcript showCR:(1000000 printStringWithThousandsSeparator:$').
     Transcript showCR:(12345678 printStringWithThousandsSeparator:$').
     Transcript showCR:(1234567 printStringWithThousandsSeparator:$').
     Transcript showCR:(123456 printStringWithThousandsSeparator:$').
     Transcript showCR:(12345 printStringWithThousandsSeparator:$').
     Transcript showCR:(1234 printStringWithThousandsSeparator:$').
     Transcript showCR:(123 printStringWithThousandsSeparator:$').

     Transcript showCR:(1000000 printStringWithThousandsSeparator:$,).
     Transcript showCR:(12345678 printStringWithThousandsSeparator:$,).
     Transcript showCR:(1234567 printStringWithThousandsSeparator:$,).
     Transcript showCR:(123456 printStringWithThousandsSeparator:$,).
     Transcript showCR:(12345 printStringWithThousandsSeparator:$,).
     Transcript showCR:(1234 printStringWithThousandsSeparator:$,).
     Transcript showCR:(123 printStringWithThousandsSeparator:$,).

     Transcript showCR:((1000000 asFixedPoint:2) printStringWithThousandsSeparator:$,).
     Transcript showCR:((12345678 asFixedPoint:2) printStringWithThousandsSeparator:$,).
     Transcript showCR:((1234567 asFixedPoint:2) printStringWithThousandsSeparator:$,).
     Transcript showCR:((123456 asFixedPoint:2) printStringWithThousandsSeparator:$,).
     Transcript showCR:((12345 asFixedPoint:2) printStringWithThousandsSeparator:$,).
     Transcript showCR:((1234 asFixedPoint:2) printStringWithThousandsSeparator:$,).
     Transcript showCR:((123 asFixedPoint:2) printStringWithThousandsSeparator:$,).
    "
!

radixPrintStringRadix:radix
    "return a string representation of the receiver in the specified
     base; prepend XXr to the string"

    ^ self printStringRadix:radix showRadix:true

    "
     31 radixPrintStringRadix:2
     31 radixPrintStringRadix:3
     31 radixPrintStringRadix:10
     31 radixPrintStringRadix:16
     31 radixPrintStringRadix:36
    "

    "Created: / 19-01-1998 / 17:38:00 / stefan"
    "Modified: / 20-01-1998 / 14:11:03 / stefan"
    "Modified: / 23-09-2011 / 14:00:02 / cg"
!

storeOn:aStream
    "append a string for storing the receiver onto the argument, aStream
     - since numbers are literals,they store as they print."

    ^ self printOn:aStream
!

storeString
    "return a string for storing
     - since numbers are literals, they store as they print."

    ^ self printString
! !

!Number methodsFor:'taylor series'!

arcSin_withAccuracy:epsilon
    "compute the arcSine of the receiver using a taylor series approx."

    "/ uses taylor series:
    "/                 1*x^3   1*3 * x^5
    "/    arcSin = x + ----- + ---------- + ...
    "/                 2* 3    2*4 *  5

    |x2 num numf den denf approx delta|

    ((self < -1) or:[self > 1]) ifTrue:[
	^ self class
	    raise:#domainErrorSignal
	    receiver:self
	    selector:#arcSin
	    arguments:#()
	    errorString:'bad receiver in arcSin'
    ].

    x2 := self * self.
    num := x2 * self.
    approx := self + (num / 6).

    numf := 3.
    denf := 4.
    den := 2.

    [
	num := (num * x2) * numf.   numf := numf + 2.
	den := den * denf.          denf := denf + 2.

	delta := num / (den * numf).
	approx := approx + delta.
    ] doUntil:[delta abs <= epsilon].
    ^ approx

    "
     0.5 arcSin                                    0.523599
     0.5q arcSin                        0.523598776

     0.5q arcSin_withAccuracy:1         0.520833333
     0.5q arcSin_withAccuracy:0.1       0.520833333
     0.5q arcSin_withAccuracy:0.01      0.523177083
     0.5q arcSin_withAccuracy:0.001     0.523525856

     0.5q arcSin_withAccuracy:1e-20     0.523598776

     0.5 asLargeFloat arcSin_withAccuracy:1e-30    -- not yet


     0.1 arcSin                                    0.100167
     0.1q arcSin                        0.100167421

     0.1q arcSin_withAccuracy:1         0.100166667
     0.1q arcSin_withAccuracy:0.1       0.100166667
     0.1q arcSin_withAccuracy:0.01      0.100166667
     0.1q arcSin_withAccuracy:0.001     0.100166667

     0.1q arcSin_withAccuracy:1e-20     0.100167421

     0.1 asLargeFloat arcSin_withAccuracy:1e-30    -- not yet
    "
!

arcTan_withAccuracy:epsilon
    "compute the arcTangent of the receiver using a taylor series approx."

    "/ uses taylor series:
    "/                 x^3   x^5   x^7
    "/ arcTan(x) = x - --- + --- - --- ...
    "/                  3     5    7

    |x2 num den approx delta|

    x2 := self * self.

    num := (x2 * self) negated.
    den := 3.
    approx := self + (num / den).

    [
	den := den + 2.
	num := (num * x2) negated.

	delta := num / den.
	approx := approx + delta.
    ] doUntil:[delta abs <= epsilon].
    ^ approx

    "
     1.0 arcTan                       0.785398
     1q arcTan                        0.785398163

     1q arcTan_withAccuracy:1         0.666666667
     1q arcTan_withAccuracy:0.1       0.744011544
     1q arcTan_withAccuracy:0.01      0.790299653
     1q arcTan_withAccuracy:0.001     0.785897165

     1q arcTan_withAccuracy:1e-8      0.785398168
     1q arcTan_withAccuracy:1e-20     -- not yet, converges very slow


     0.5 arcTan                         0.463648
     0.5q arcTan                        0.463647609

     0.5q arcTan_withAccuracy:1         0.458333333
     0.5q arcTan_withAccuracy:0.1       0.458333333
     0.5q arcTan_withAccuracy:0.01      0.464583333
     0.5q arcTan_withAccuracy:0.001     0.463684276

     0.5q arcTan_withAccuracy:1e-20     0.463647609
     0.5 asLargeFloat arcTan_withAccuracy:1e-30    -- not yet
    "
!

cbrt_withAccuracy:epsilon
    "compute cubic root of the receiver using a newton approx."

    "
      Use Newton's method:

		 2*x_n + (a / x_n^2)
	x_n+1 =  ---------------
		      3

	cbrt(a) = x_n
    "

    |approx|

    self = 0 ifTrue:[
	^ self
    ].

    approx := 1.
    [
	|lastApprox|

	lastApprox := approx.
	approx := ((approx * 2) + (self / approx / approx)) / 3.
	(approx - lastApprox) abs > epsilon
    ] whileTrue.
    ^ approx

    "
     8q cbrt                                 2.0
     8q cbrt_withAccuracy:0.01               2.000004911675504018
     8q cbrt_withAccuracy:0.0001             2.000000000012062239
     8q cbrt_withAccuracy:0.0000001          2.0
     8q cbrt_withAccuracy:0.0000000001       2.0
     8q cbrt_withAccuracy:0.000000000001     2.0
     8q cbrt_withAccuracy:LongFloat epsilon  2.0

     27q cbrt_withAccuracy:0.01              3.000000541064176501
     27q cbrt_withAccuracy:LongFloat epsilon  3.0
     -27q cbrt_withAccuracy:LongFloat epsilon -3.0

     MessageTally spyOn:[ |arg|
	arg := 2 asLongFloat.
	1000000 timesRepeat:[
	     arg cbrt_withAccuracy:0.000000000001
	]
     ]
     Time millisecondsToRun:[ |arg|
	arg := 2 asLongFloat.
	1000000 timesRepeat:[
	     arg cbrt_withAccuracy:0.000000000001
	]
     ]
    "
!

cos_withAccuracy:epsilon
    "compute the cosine of the receiver using a taylor series approx."

    "/ uses taylor series:
    "/               x^2   x^4   x^6
    "/  cos(x) = 1 - --- + --- - --- ...
    "/                2!!    4!!    6!!

    |x2 facN num den approx lastApprox|

    x2 := self * self.

    num := x2 negated.
    den := 2.
    facN := 2.
    approx := 1 + (num / den).
    lastApprox := 1.

    [ (lastApprox - approx) abs > epsilon ] whileTrue:[
	facN := facN + 2.
	den := den * (facN - 1) * facN.
	num := (num * x2) negated.
	lastApprox := approx.
	approx := approx + (num / den).
    ].
    ^ approx

    "
     1.0 cos                                    0.540302
     1.0 asLongFloat cos_withAccuracy:1         0.5
     1.0 asLongFloat cos_withAccuracy:0.1       0.541666667
     1.0 asLongFloat cos_withAccuracy:0.01      0.540277778
     1.0 asLongFloat cos_withAccuracy:0.001     0.540302579

     1.0 asLongFloat cos_withAccuracy:1e-40     0.540302306
    "
!

cosh_withAccuracy:epsilon
    "compute the hyperbolic cosine of the receiver using a taylor series approx."

    "/ uses taylor series:
    "/               x^2   x^4   x^6
    "/    cosh = x + --- + --- + --- ...
    "/                2!!    4!!    6!!

    |x2 facN num den approx delta|

    x2 := self * self.

    num := x2.
    den := 2.
    facN := 2.
    approx := self + (num / den).

    [
	facN := facN + 2.
	den := den * (facN - 1) * facN.
	num := num * x2.

	delta := num / den.
	approx := approx + delta.
    ] doUntil:[delta <= epsilon].
    ^ approx

    "
     1.0 cosh                                    1.54308
     1.0q cosh_withAccuracy:1         1.5
     1.0q cosh_withAccuracy:0.1       1.54308
     1.0q cosh_withAccuracy:0.01      1.54308
     1.0q cosh_withAccuracy:0.001     1.54308

     1.0q cosh_withAccuracy:1e-40   -> 1.543080
    "
!

epsilon
    "return the maximum relative spacing of instances of mySelf
     (i.e. the value-delta of the least significant bit)"

    ^ self class epsilon
!

exp_withAccuracy:epsilon
    "compute e**x of the receiver using a taylor series approx."

    "/ uses taylor series:
    "/             x    x^2   x^3
    "/  e^x = 1 + --- + --- + --- ...
    "/             1!!    2!!    3!!

    |x2 facN num den approx delta|

    x2 := self * self.

    num := x2.
    den := 2.
    facN := 2.
    approx := self + 1 + (num / den).

    [
	facN := facN + 1.
	den := den * facN.
	num := num * self.

	delta := num / den.
	approx := approx + delta.
    ] doUntil:[delta abs <= epsilon].

    ^ approx

    "
     -1 exp
     1.0 exp                                    2.71828
     1q exp                                     2.71828183
     2q exp                                     7.3890561

     1q exp_withAccuracy:1                      2.66666667
     1q exp_withAccuracy:0.1                    2.70833333
     1q exp_withAccuracy:0.01                   2.71666667
     1q exp_withAccuracy:0.001                  2.71825397

     2q exp_withAccuracy:LongFloat epsilon      7.3890561

     1.0 asLongFloat exp_withAccuracy:1e-40     2.71828183

     5 exp_withAccuracy:1e-40
     (1 exp_withAccuracy:1e-100) asFixedPoint:100
    "
!

ln_withAccuracy:epsilon
    "compute ln of the receiver using a taylor series approx."

    "uses taylor series:
		 u^2   u^3
	ln = u - --- + --- ...
		  2    3
      where:
	     u = x - 1    and: x < 1

     Now we use modified taylor, which converges faster:

		   1+y        1   1       1
	ln(x) = ln --- = 2y ( - + - y^2 + - y^4 + ....)
		   1-y        1   3       5

	where y = (x-1) / (x+1)  and x > 0
    "

    |denominator approx y y2 exp delta|

    self <= 0 ifTrue:[
	^ self class
	    raise:#domainErrorSignal
	    receiver:self
	    selector:#ln
	    arguments:#()
	    errorString:'bad receiver in ln'
    ].


    y := (self - 1)/(self + 1).
    exp := y2 := y * y.

    approx := 1.
    denominator := 3.

    [
	delta := exp / denominator.
	approx := approx + delta.
	exp := exp * y2.
	denominator := denominator + 2.
    ] doUntil:[delta <= epsilon].

    ^ y * 2 * approx.


    "
     2.0 ln                         0.693147
     2.0q ln                        0.693147181

     2.0q ln_withAccuracy:1         0.691358025
     2.0q ln_withAccuracy:0.1       0.691358025
     2.0q ln_withAccuracy:0.01      0.693004115
     2.0q ln_withAccuracy:0.0000001 0.69314718

     2.0q ln_withAccuracy:1e-10
     2.0q ln_withAccuracy:1e-20
     2.0q ln_withAccuracy:1e-40     0.693147181

     2 ln_withAccuracy:1e-40
     0 ln_withAccuracy:1e-40

     (2 ln_withAccuracy:1e-100) asFixedPoint:100
    "
!

sin_withAccuracy:epsilon
    "compute the sine of the receiver using a taylor series approx."

    "/ uses taylor series:
    "/               x^3   x^5   x^7
    "/  sin(x) = x - --- + --- - --- ...
    "/                3!!    5!!    7!!

    |x2 facN num den approx delta|

    x2 := self * self.

    num := (x2 * self) negated.
    den := 2*3.
    facN := 3.
    approx := self + (num / den).

    [
	facN := facN + 2.
	den := den * (facN - 1) * facN.
	num := (num * x2) negated.

	delta := num / den.
	approx := approx + delta.
    ] doUntil:[delta abs <= epsilon].
    ^ approx

    "
     1.0 sin                                    0.841471
     1.0q sin                        0.841470985

     1.0q sin_withAccuracy:1         0.833333333
     1.0q sin_withAccuracy:0.1       0.841666667
     1.0q sin_withAccuracy:0.01      0.841666667
     1.0q sin_withAccuracy:0.001     0.841468254

     1.0q sin_withAccuracy:1e-40     0.841470985
    "
!

sinh_withAccuracy:epsilon
    "compute the hyperbolic sine of the receiver using a taylor series approx."

    "/ uses taylor series:
    "/               x^3   x^5   x^7
    "/ sinh(x) = x + --- + --- + --- ...
    "/                3!!    5!!    7!!

    |x2 facN num den approx delta|

    x2 := self * self.

    num := x2 * self.
    den := 2*3.
    facN := 3.
    approx := self + (num / den).

    [
	facN := facN + 2.
	den := den * (facN - 1) * facN.
	num := num * x2.

	delta := num / den.
	approx := approx + delta.
    ] doUntil:[delta abs <= epsilon].
    ^ approx

    "
     1.0 sinh                                    1.1752
     1q sinh                        1.17520119

     1q sinh_withAccuracy:1         1.16666667
     1q sinh_withAccuracy:0.1       1.175
     1q sinh_withAccuracy:0.01      1.175
     1q sinh_withAccuracy:0.001     1.17519841

     1q sinh_withAccuracy:1e-40     1.17520119
    "
!

sqrt_withAccuracy:epsilon
    "compute square root of the receiver using newtom/heron algorithm"
    "
      Use the Heron algorithm:

		 x_n + (a / x_n)
	x_n+1 =  ---------------
		      2

	sqrt(a) = x_n
    "

    |approx|

    self <= 0 ifTrue:[
	self = 0 ifTrue:[
	    ^ self
	].
	^ self class
	    raise:#imaginaryResultSignal
	    receiver:self
	    selector:#sqrt
	    arguments:#()
	    errorString:'bad (negative) receiver in sqrt'
    ].

    approx := 1.
    [
	|lastApprox|

	lastApprox := approx.
	approx := ((self / approx) + approx) / 2.
	(approx - lastApprox) abs > epsilon
    ] whileTrue.
    ^ approx

    "
     2 sqrt                                  1.4142135623731
     2q sqrt                                 1.414213562373095049
     2q sqrt_withAccuracy:0.01               1.414215686274509804
     2q sqrt_withAccuracy:0.0001             1.414213562374689911
     2q sqrt_withAccuracy:0.0000001          1.414213562373095049
     2q sqrt_withAccuracy:0.0000000001       1.414213562373095049
     2q sqrt_withAccuracy:0.000000000001     1.414213562373095049
     2q sqrt_withAccuracy:LongFloat epsilon  1.414213562373095049

     (4 sqrt_withAccuracy:Integer epsilon) asFloat

     MessageTally spyOn:[ |arg|
	arg := 2 asLongFloat.
	1000000 timesRepeat:[
	     arg sqrt_withAccuracy:0.000000000001
	]
     ]
     Time millisecondsToRun:[ |arg|
	arg := 2 asLongFloat.
	1000000 timesRepeat:[
	     arg sqrt_withAccuracy:0.000000000001
	]
     ]
    "
!

tan_withAccuracy:epsilon
    "compute the tangens of the receiver using a taylor series approx."

    "/ uses taylor series:
    "/                x^3     x^5      x^7      x^9     2^2n * ( 2^2n - 1) * B2n * x^(2n-1)
    "/    tan = x + 1*--- + 2*--- + 17*--- + 62*----... ----------------------------------...
    "/                 3       15      315      2835                 (2n)!!
    "/ where Bi is the ith bernoulli number.

    |factors idx x2 num t approx lastApprox delta|

    "/    (1 to:20) collect:[:n| |num den|
    "/        num := (2 raisedTo:(2*n)) * ((2 raisedTo:(2*n))-1) * ((n*2) bernoulli).
    "/        den := (2*n) factorial.
    "/        num / den
    "/    ]
   factors := #(
	(1 3)
	(2 15)
	(17 315)
	(62 2835)
	(1382 155925)
	(21844 6081075)
	(929569 638512875)
	(6404582 10854718875)
	(443861162 1856156927625)
	(18888466084 194896477400625)
	(113927491862 2900518163668125)
	(58870668456604 3698160658676859375)
	(8374643517010684 1298054391195577640625)
	(689005380505609448 263505041412702261046875)
	(129848163681107301953 122529844256906551386796875)
	(1736640792209901647222 4043484860477916195764296875)
	(418781231495293038913922 2405873491984360136479756640625)
	(56518638202982204522669764 801155872830791925447758961328125)
	(32207686319158956594455462 1126482925555250126673224649609375)).

    x2 := self * self.

    num := x2 * self.               "/ =  x^3
    approx := self + (num / 3).     "/ do the first iteration
    lastApprox := self.
    idx := 2.
    [
	t := factors at:idx ifAbsent:[].
	t isNil ifTrue:[
	    self error:'too many iterations'.
"/ Not enough bernoulli numbers for now...
"/            |tempNum tempDen|
"/            tempNum := 2 raisedTo:(2*idx).
"/            tempNum := tempNum * (tempNum-1) * ((2*idx) bernoulli).
"/            tempDen := (2*idx) factorial.
"/            t := Array with:tempNum with:tempDen.
	].
	idx := idx + 1.
	num := num * x2.

	delta := num * t first / t second.
	approx := approx + delta.
    ] doUntil:[delta abs <= epsilon].
    ^ approx

    "
     0.5 tan                         0.546302
     0.5q tan                        0.54630249

     0.5q tan_withAccuracy:1         0.541666667
     0.5q tan_withAccuracy:0.1       0.541666667
     0.5q tan_withAccuracy:0.01      0.545833333
     0.5q tan_withAccuracy:0.001     0.54625496
     0.5q tan_withAccuracy:1e-15     0.54630249

     0.5q tan_withAccuracy:1e-40     -- too many iterations
    "
! !

!Number methodsFor:'testing'!

even
    "return true if the receiver is divisible by 2."

    self fractionPart = 0 ifTrue:[
	^ (self / 2) fractionPart = 0
    ].

    "this will raise an error"
    ^ super even

    "
	2 even
	2.0 even
	3.0 even
	2.4 even
	(5/3) even
	2 asFraction even
    "
!

isDivisibleBy:aNumber
    "return true, if the receiver can be divided by the argument, aNumber without a remainder.
     Notice, that the result is only worth trusting, if the receiver is an integer."

    aNumber = 0 ifTrue: [^ false].
    aNumber isInteger ifFalse: [^ false].
    ^ (self \\ aNumber) = 0

    "
     3 isDivisibleBy:2
     4 isDivisibleBy:2
     4.0 isDivisibleBy:2
     4.5 isDivisibleBy:4.5
     4.5 isDivisibleBy:1.0
    "
!

isNaN
    "return true, if the receiver is an invalid float (NaN - not a number)."

    ^ false

    "Created: / 5.11.2001 / 18:07:26 / cg"
!

isNumber
    "return true, if the receiver is a kind of number"

    ^ true
!

isPerfectSquare
    "return true if I am a perfect square.
     That is a number for which the square root is an integer."

    self truncated = self ifFalse:[^ false].
    ^ self asInteger isPerfectSquare

    "
     0 isPerfectSquare
     0.0 isPerfectSquare
     3 isPerfectSquare
     3.0 isPerfectSquare
     4 isPerfectSquare
     4.0 isPerfectSquare
     9 isPerfectSquare
     9.0 isPerfectSquare
    "
!

isReal
    "return true, if the receiver is some kind of real number (as opposed to a complex);
     true is returned here - the method is redefined from Object."

    ^ true
!

isZero
    "return true, if the receiver is zero"

    ^ self = 0

    "Modified: 18.7.1996 / 12:40:49 / cg"
! !

!Number methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceNumber:self level:level from:referrer


! !

!Number methodsFor:'trigonometric'!

arcCos
    "return the arccosine of the receiver (in radians)"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcCos.
    ].
    "/ slow fallback
    ^ (self class pi / 2) - self arcSin
!

arcCosech
    "return the inverse hyperbolic cosecant of the receiver."
    "caveat: misnomer; should be called aCosech or arCosech"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcCosech.
    ].
    "/ slow fallback
    ^ ((1 + ((self*self)+1) sqrt) / self) ln
!

arcCosh
    "return the inverse hyperbolic cosine of the receiver."
    "caveat: misnomer; should be called aCosh or arCosh"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcCosh.
    ].
    "/ slow fallback
    ^ (self + (self*self-1) sqrt) ln.
!

arcCoth
    "return the inverse hyperbolic cotangent of the receiver."
    "caveat: misnomer; should be called aCoth or arCoth"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcCoth.
    ].
    "/ slow fallback
    ^ ((self+1) / (self-1)) ln / 2
!

arcSech
    "return the inverse hyperbolic secant of the receiver."
    "caveat: misnomer; should be called aSech or arSech"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcSech.
    ].
    "/ slow fallback
    ^ ((1 + (1-(self*self)) sqrt) / self) ln
!

arcSin
    "return the arcsine of the receiver (in radians)"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcSin.
    ].
    "/ very slow fallback
    ^ self arcSin_withAccuracy:self epsilon
!

arcSinh
    "return the inverse hyperbolic sine of the receiver."
    "caveat: misnomer; should be called aSinh or arSinh"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcSinh.
    ].
    "/ slow fallback
    ^ ( self + (self*self+1) sqrt ) ln
"/    ^ self arcSinh_withAccuracy:self epsilon
!

arcTan
    "return the arctangent of the receiver (as radians)"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcTan.
    ].
    "/ very slow fallback
    ^ self arcTan_withAccuracy:self epsilon
!

arcTan2:x
    "return atan2(self,x) (as radians)"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcTan2:x.
    ].
    "/ very slow fallback
    ^ self arcTan2_withAccuracy:self epsilon x:x
!

arcTanh
    "return the inverse hyperbolic tangent of the receiver."
    "caveat: misnomer; should be called aTanh or arTanh"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat arcTanh.
    ].
    "/ slow fallback
    ^ ((1 + self) / (1 - self)) ln / 2
    "/ s^ ((1 + self) ln / 2) - ((1 - self) ln / 2)
!

cos
    "return the cosine of the receiver (interpreted as radians)"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat cos.
    ].
    "/ very slow fallback
    ^ self cos_withAccuracy:self epsilon
!

cosh
    "return the hyperbolic cosine of the receiver"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat cosh.
    ].
    "/ very slow fallback
    ^ self cosh_withAccuracy:self epsilon
!

cot
    "return the cotangent of the receiver"

    ^ 1 / self tan
!

sin
    "return the sine of the receiver (interpreted as radians)"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat sin.
    ].
    ^ self sin_withAccuracy:self epsilon
!

sinh
    "return the hyperbolic sine of the receiver"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat sinh.
    ].
    ^ self sinh_withAccuracy:self epsilon
!

tan
    "return the tangens of the receiver (interpreted as radians)"

    "/ slow fallback
    ^ self sin / self cos
!

tanh
    "return the hyperbolic tangens of the receiver"

    "/ if I am not a Float (or a less general lpReal),
    "/ retry after converting to float
    (self isLimitedPrecisionReal not
    or:[self generality < 1.0 generality]) ifTrue:[
	^ self asFloat tanh.
    ].
    "/ very slow fallback
    ^ self tanh_withAccuracy:self epsilon

"/ If a fast exp is available, the following might be better...
"/
"/    |exp nexp|
"/
"/    "/ tanh is:
"/    "/      sinh(x)
"/    "/      -------
"/    "/      cosh(x)
"/    "/
"/    "/ which is:
"/    "/      (exp(x) - exp(-x)) / 2
"/    "/      ----------------------
"/    "/      (exp(x) + exp(-x)) / 2
"/
"/    exp := self exp.
"/    nexp := self negated exp.
"/
"/    ^ (exp - nexp) / (exp + nexp)
! !

!Number methodsFor:'truncation & rounding'!

detentBy: detent atMultiplesOf: grid snap: snap
    "Map all values that are within detent/2 of any multiple of grid
     to that multiple.
     Otherwise, if snap is true, return self, meaning that the values
     in the dead zone will never be returned.
     If snap is false, then expand the range between dead zones
     so that it covers the range between multiples of the grid,
     and scale the value by that factor."

    | r1 r2 |

    r1 := self roundTo: grid.                    "Nearest multiple of grid"
    (self roundTo: detent) = r1 ifTrue: [^ r1].  "Snap to that multiple..."
    snap ifTrue: [^ self].                       "...or return self"

    r2 := self < r1                               "Nearest end of dead zone"
	    ifTrue: [r1 - (detent asFloat/2)]
	    ifFalse: [r1 + (detent asFloat/2)].

    "Scale values between dead zones to fill range between multiples"
    ^ r1 + ((self - r2) * grid asFloat / (grid - detent))

    "
     (170 to: 190 by: 2) collect: [:a | a detentBy: 10 atMultiplesOf: 90 snap: true]
     (170 to: 190 by: 2) collect: [:a | a detentBy: 10 atMultiplesOf: 90 snap: false]
     (3.9 to: 4.1 by: 0.02) collect: [:a | a detentBy: 0.1 atMultiplesOf: 1.0 snap: true]
     (-3.9 to: -4.1 by: -0.02) collect: [:a | a detentBy: 0.1 atMultiplesOf: 1.0 snap: false]
    "
!

fractionPart
    "return a float with value from digits after the decimal point.
     i.e. the receiver minus its truncated value,
     such that (self truncated + self fractionPart) = self"

    ^ self - self truncated

    "
     1234.56789 fractionPart
     1.2345e6 fractionPart

     1.6 asLongFloat fractionPart + 1.6 asLongFloat truncated
     -1.6 asLongFloat fractionPart + -1.6 asLongFloat truncated
    "

    "Modified: / 4.11.1996 / 20:26:54 / cg"
    "Created: / 28.10.1998 / 17:14:40 / cg"
!

integerPart
    "return a float with value from digits before the decimal point
     (i.e. the truncated value)"

    ^ self truncated asFloat

    "
     1234.56789 integerPart
     1.2345e6 integerPart
     12.5 integerPart
     -12.5 integerPart
     (5/3) integerPart
     (-5/3) integerPart
     (5/3) truncated
     (-5/3) truncated
    "

    "Created: / 28.10.1998 / 17:14:56 / cg"
    "Modified: / 5.11.2001 / 17:54:22 / cg"
! !


!Number class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

