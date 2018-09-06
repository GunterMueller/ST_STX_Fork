"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

Number subclass:#Fraction
	instanceVariableNames:'numerator denominator'
	classVariableNames:'FractionOne FractionZero PrintWholeNumbers PI_1000'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!Fraction class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    Instances of Fraction represent fractional numbers consisting of
    a numerator and denominator. Both are themselfes arbitrary precision
    integers.
    Fractions are usually created by dividing Integers using / (for exact division).
    Notice, that all operations on fractions reduce their result; this means, that
    the result of a fraction-operation may return an integer.
    Aka:
	(1 / 7) * 7   ->  1  (not 0.99999999...)

    Mixed mode arithmetic:
	fraction op fraction    -> fraction/integer
	fraction op fix         -> fix; scale is fix's scale
	fraction op integer     -> fraction/integer
	fraction op float       -> float


    [classVariables:]
	PrintWholeNumbers       Booolean        experimental:
						controls how fractions which are greater than 1 are printed.
						if true, print them as a sum of an integral and the fractional part.
						(Large ones are easier to read this way)
						     (17/3) printString  -> '(5+(2/3))'
						for now, the default is false, for backward compatibility

    [author:]
	Claus Gittinger

    [see also:]
	Number
	FixedPoint Float ShortFloat LongFloat Integer Complex
"
! !

!Fraction class methodsFor:'instance creation'!

new
    "create and return a new fraction with value 0"

    ^ self numerator:0 denominator:1
!

numerator:num denominator:den
    "create and return a new fraction with numerator num and denominator den.
     Notice: stc inlines this message if sent to the global named Fraction."

    |newFraction|

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (self == Fraction.Class) {
	return context._RETURN(new STFraction(num, den));
    }
#else
    /* this check allows subclassing .. */
    if (self == Fraction) {
	if (__bothSmallInteger(num, den)) {
	    if (den != __mkSmallInteger(0)) {
		if (__CanDoQuickNew(sizeof(struct __Fraction))) {    /* OBJECT ALLOCATION */
		    OBJ newFraction;
		    INT iDen;
		    INT iNum;

		    __qCheckedNew(newFraction, sizeof(struct __Fraction));
		    __InstPtr(newFraction)->o_class = self;
		    __qSTORE(newFraction, self);

		    iDen = __intVal(den);
		    iNum = __intVal(num);

		    if (iDen < 0) {
			iNum = -iNum;
			iDen = -iDen;
		    }
		    while ( (((iNum | iDen) & 1) == 0) && ( iNum != 0) && ( iDen != 0)) {
			/* both even and non-zero */
			iNum = iNum >> 1;
			iDen = iDen >> 1;
		    }
		    if (iNum >= _MAX_INT) {
			__FractionInstPtr(newFraction)->f_numerator = __MKINT(iNum);
		    } else {
			__FractionInstPtr(newFraction)->f_numerator = __MKSMALLINT(iNum);
		    }
		    if (iDen >= _MAX_INT) {
			__FractionInstPtr(newFraction)->f_denominator = __MKINT(iDen);
		    } else {
			__FractionInstPtr(newFraction)->f_denominator = __MKSMALLINT(iDen);
		    }
		    if (iNum == 1) {
			/* no need to reduce */
			RETURN ( newFraction );
		    }
		}
	    }
	}
    }
#endif /* not __SCHTEAM__ */
%}.
    den = 0 ifTrue:[
	^ ZeroDivide raiseRequestWith:thisContext.
    ].
    newFraction isNil ifTrue:[
	newFraction := self basicNew setNumerator:num denominator:den.
    ].
    ^ newFraction reduced

    "
     Fraction numerator:1 denominator:3
     Fraction numerator:2 denominator:3
     Fraction numerator:2 denominator:6

     Fraction numerator:1 denominator:0  -> error
     Fraction numerator:2 denominator:0  -> error

     Fraction numerator:5 denominator:10
     Fraction numerator:50 denominator:100
     Fraction numerator:8 denominator:16
    "

    "Modified: / 27-02-2016 / 00:25:47 / cg"
!

readDecimalFractionFrom:aStringOrStream onError:exceptionBlock
    "Read an arbitrary number (>0) of digits representing a decimal fraction."

    |anyDigit factor fraction s ch|

    s := aStringOrStream isStream ifTrue:[aStringOrStream] ifFalse:[aStringOrStream readStream].

    factor := (1 / 10).
    fraction := 0.
    anyDigit := false.

    [
	ch := s peekOrNil.
	ch notNil and:[ch isDigit].
    ] whileTrue: [
	s next.
	anyDigit := true.
	fraction := (ch digitValue) * factor + fraction.
	factor := (factor / 10).
    ].

    anyDigit ifFalse: [^ exceptionBlock valueWithOptionalArgument: 'Missing digits in fraction'].
    ^ fraction

    "
     Fraction readDecimalFractionFrom:'1'   onError:[nil]     -> 0.1
     Fraction readDecimalFractionFrom:'123' onError:[nil]     -> 0.123
     Fraction readDecimalFractionFrom:'5'   onError:[nil]     -> 0.5
     Fraction readDecimalFractionFrom:'005' onError:[nil]     -> 0.005
     Fraction readDecimalFractionFrom:''    onError:[nil]     -> nil
     Fraction readDecimalFractionFrom:'aa'  onError:[nil]     -> nil
    "
!

readFrom:aStringOrStream onError:exceptionBlock
    |s numerator denominator|

    "/ sigh - care for subclasses...
    self == Fraction ifFalse:[
	^ super readFrom:aStringOrStream onError:exceptionBlock
    ].

    s := aStringOrStream readStream.
    s skipSeparators.
    s peekOrNil == $( ifTrue:[
	s next.
    ].

    numerator := super readFrom:s onError:[^ exceptionBlock value].
    numerator isInteger ifTrue:[
	s skipSeparators.
	(s peekOrNil == $/) ifTrue:[
	    s next.
	    denominator := Integer readFrom:s onError:[^ exceptionBlock value].
	    ^ self numerator:numerator denominator:denominator
	].
	^ numerator
    ].
    ^ numerator asFraction

    "
     Fraction readFrom:'1'
     Fraction readFrom:'2'
     Fraction readFrom:'1.5'
     Fraction readFrom:'1/5'
    "
! !

!Fraction class methodsFor:'class initialization'!

initialize
    FractionZero isNil ifTrue:[
	FractionZero := self numerator:0 denominator:1.
	FractionOne := self numerator:1 denominator:1
    ]
! !

!Fraction class methodsFor:'constants'!

pi
    "return an approximation of the constant pi as Fraction.
     The approx. returned here has an error smaller than representable by float instances"

    ^ self
	numerator:314159265358979323846264343
	denominator:100000000000000000000000000

"
    ^ self
	numerator:  314159265358979323846264338327950288419716939937510582097494459
	denominator:100000000000000000000000000000000000000000000000000000000000000
"

    "
     Fraction pi
     Fraction pi asFloat - Float pi
     Fraction pi asLongFloat - LongFloat pi
     Float pi
    "

    "Modified: / 03-05-2011 / 11:08:46 / cg"
!

pi1000
    "return an approximation of the constant pi as Fraction (1024 decimal digits)."

    PI_1000 isNil ifTrue:[
	PI_1000 := self
			numerator:31415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989380952572010654858632788
			denominator:(10 raisedTo:1024).
    ].
    ^ PI_1000

"
    ^ self
	numerator:  314159265358979323846264338327950288419716939937510582097494459
	denominator:100000000000000000000000000000000000000000000000000000000000000
"

    "
     PI_1000 := nil.
     Fraction pi1000
     Fraction pi1000 asLongFloat - LongFloat pi
     LongFloat pi
    "

    "Modified: / 03-05-2011 / 11:08:46 / cg"
!

pi_approximation
    "return an approximation of the constant pi as Fraction.
     The approx. returned is good for 6 valid digits and has an error of less than -2.67-07.
     The value might be useful to avoid floating point numbers in graphic rendering code,
     where 6 digits of precision are usually good enough."

    ^ self
	numerator:355
	denominator:113

    "
     Fraction pi
     Fraction pi asFloat
     Float pi - Fraction pi_approximation asFloat
    "
!

unity
    "return the neutral element for multiplication (1 / 1)"

    ^ FractionOne

    "Modified: 18.7.1996 / 12:26:06 / cg"
!

zero
    "return the neutral element for addition (0 / 1)"

    ^ FractionZero

    "Modified: 18.7.1996 / 12:26:12 / cg"
! !

!Fraction class methodsFor:'queries'!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Fraction

    "Modified: 23.4.1996 / 15:59:10 / cg"
! !

!Fraction methodsFor:'accessing'!

denominator
    "return the denominator"

    ^ denominator
!

numerator
    "return the numerator"

    ^ numerator
! !

!Fraction methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument."

    "/ notice:
    "/ the following code handles some common cases,
    "/ and exists as an optimization, to speed up those cases.
    "/ also notice, that checks for those cases must be inlinable without
    "/ a message send; otherwise double-dispatch is just as fast.
    "/
    "/ Conceptionally, (and for most other argument types),
    "/ mixed arithmetic is implemented by double dispatching
    "/ (see the message send at the bottom)

    (aNumber isMemberOf:SmallInteger) ifTrue:[
	^ self class
		numerator:(numerator * aNumber)
		denominator:denominator
    ].
    (aNumber isMemberOf:Float) ifTrue:[
	^ (numerator * aNumber) / denominator
    ].

    ^ aNumber productFromFraction:self

    "Modified: 28.7.1997 / 19:09:23 / cg"
!

+ aNumber
    "return the sum of the receiver and the argument, aNumber"

    "/ notice:
    "/ the following code handles some common cases,
    "/ and exists as an optimization, to speed up those cases.
    "/ also notice, that checks for those cases must be inlinable without
    "/ a message send; otherwise double-dispatch is just as fast.
    "/
    "/ Conceptionally, (and for most other argument types),
    "/ mixed arithmetic is implemented by double dispatching
    "/ (see the message send at the bottom)

    (aNumber isMemberOf:SmallInteger) ifTrue:[
	^ self class
	    numerator:(numerator + (denominator * aNumber))
	    denominator:denominator
    ].
    (aNumber isMemberOf:Float) ifTrue:[
	^ (numerator asFloat / denominator asFloat) + aNumber
    ].

    ^ aNumber sumFromFraction:self

    "Modified: 28.7.1997 / 19:09:16 / cg"
!

- aNumber
    "return the difference of the receiver and the argument, aNumber"

    "/ notice:
    "/ the following code handles some common cases,
    "/ and exists as an optimization, to speed up those cases.
    "/ also notice, that checks for those cases must be inlinable without
    "/ a message send; otherwise double-dispatch is just as fast.
    "/
    "/ Conceptionally, (and for most other argument types),
    "/ mixed arithmetic is implemented by double dispatching
    "/ (see the message send at the bottom)

    (aNumber isMemberOf:SmallInteger) ifTrue:[
	^ self class
		numerator:(numerator - (denominator * aNumber))
		denominator:denominator
    ].
    (aNumber isMemberOf:Float) ifTrue:[
	^ (numerator asFloat / denominator asFloat) - aNumber
    ].

    ^ aNumber differenceFromFraction:self

    "
     (1/3) - (1/9)
     (1/9) - (1/3)
     (999/1000) - (1/1000)
     (999/1000) - (1/1000000)
     (999000/1000000) - (1/1000000)
    "

    "Modified: 28.7.1997 / 19:09:11 / cg"
!

/ aNumber
    "return the quotient of the receiver and the argument, aNumber"

    "/ notice:
    "/ the following code handles some common cases,
    "/ and exists as an optimization, to speed up those cases.
    "/ also notice, that checks for those cases must be inlinable without
    "/ a message send; otherwise double-dispatch is just as fast.
    "/
    "/ Conceptionally, (and for most other argument types),
    "/ mixed arithmetic is implemented by double dispatching
    "/ (see the message send at the bottom)

    (aNumber isMemberOf:SmallInteger) ifTrue:[
	^ self class
		numerator:numerator
		denominator:(denominator * aNumber)
    ].
    (aNumber isMemberOf:Float) ifTrue:[
	^ numerator / (denominator * aNumber)
    ].

    ^ aNumber quotientFromFraction:self

    "Modified: 28.7.1997 / 19:09:06 / cg"
!

// aNumber
    "return the integer quotient of dividing the receiver by aNumber with
     truncation towards negative infinity."

    ^ (numerator * aNumber denominator) // (denominator * aNumber numerator)

    "
     0.5 // 1
     -0.5 // 1
     (1/2) // 1  = 0 ifFalse:[self halt].
     (-1/2) // 1 = -1 ifFalse:[self halt].
    "

    "Modified: / 5.11.1996 / 11:47:14 / cg"
    "Modified: / 13.2.1998 / 09:15:35 / stefan"
!

negated
    "optional - could use inherited method ..."

    "/ no need to reduce - I am already
    ^ self class basicNew
	setNumerator:(numerator negated)
	denominator:denominator

    "Modified: 5.11.1996 / 10:29:11 / cg"
!

reciprocal
    "optional - could use inherited method ..."

    numerator == 1 ifTrue:[^ denominator].
    "/ no need to reduce - I am already
    ^ self class basicNew
	setNumerator:denominator
	denominator:numerator

    "Modified: 5.11.1996 / 10:29:22 / cg"
! !

!Fraction methodsFor:'coercing & converting'!

asFixedPoint
    "return the receiver as fixedPoint number.
     Q: what should the scale be here ?"

    ^ FixedPoint numerator:numerator denominator:denominator scale:2

    "
     (1/2) asFixedPoint
    "

    "Created: 5.11.1996 / 15:15:54 / cg"
!

asFixedPoint:scale
    "return the receiver as fixedPoint number, with the given number
     of post-decimal-point digits."

    ^ FixedPoint numerator:numerator denominator:denominator scale:scale

    "
     (1/2) asFixedPoint:2
     (1/3) asFixedPoint:2
     (1/3) asFixedPoint:5
     (2/3) asFixedPoint:2
     (2/3) asFixedPoint:5
    "

    "Created: 5.11.1996 / 15:15:54 / cg"
    "Modified: 10.1.1997 / 19:54:50 / cg"
!

asFloat
    "return a float with (approximately) my value.
     Since floats have a limited precision, you usually loose bits when doing this."

    |num den numShift denShift bits rslt|

    (numerator class == SmallInteger and:[denominator class == SmallInteger]) ifTrue:[
	^ (numerator asFloat) / (denominator asFloat)
    ].

    "Do it the hard way: reduce magnitude and undo reduction on the quotient"

    bits := Float precision * 2.    "number of bits to preserve (conservative)"
    num := numerator abs.
    numShift := bits - num highBit. "(num highBit - bits) negated"
    numShift < 0 ifTrue:[num := num bitShift:numShift] ifFalse:[numShift := 0].

    den :=  denominator.
    denShift := bits - den highBit. "(den highBit - bits) negated"
    denShift < 0 ifTrue:[den := den bitShift:denShift] ifFalse:[denShift := 0].

    rslt := (num asFloat / den asFloat) * (2 raisedToInteger:denShift-numShift).
    numerator negative ifTrue:[ ^ rslt negated ].
    ^ rslt.

    "
      (5/9) asFloat
      (-5/9) asFloat
      (500000000000/900000000000) asFloat
      (-500000000000/900000000000) asFloat
      (500000000000/9) asFloat
      (5/900000000000) asFloat
      89012345678901234567 asFloat / 123456789123456789 asFloat
      (89012345678901234567 / 123456789123456789) asFloat

      (
       180338700661043257034670206806167960222709397862806840937993331366591676308781197477183367018067356365812757479444845320188679437752013593674158587947149815441890236037219685250845721864713487208757788709113534916165172927384095182655935222723385253851776639985379367854545495930551624041981995105743408203125
	/
       180331613628627651967947866455016278082980736719853750685591387625058011528928110602436691256100991596843001549483950600930062886280582766771424470965440873615557144641435276844465734361353086032476712374317224249252177316815544331763696909434844464464323192083930469387098582956241443753242492675781250
      ) asFloat

      180338700661043257034670206806167960222709397862806840937993331366591676308781197477183367018067356365812757479444845320188679437752013593674158587947149815441890236037219685250845721864713487208757788709113534916165172927384095182655935222723385253851776639985379367854545495930551624041981995105743408203125
	 asFloat /
      180331613628627651967947866455016278082980736719853750685591387625058011528928110602436691256100991596843001549483950600930062886280582766771424470965440873615557144641435276844465734361353086032476712374317224249252177316815544331763696909434844464464323192083930469387098582956241443753242492675781250
	 asFloat
    "
!

asFraction
    "return the receiver as fraction - that's the receiver itself"

    ^ self
!

asInteger
    "return an integer with my value - will usually truncate"

    ^ numerator // denominator
!

asLargeFloat
    "return a large float with (approximately) my value"

    ^ (numerator asLargeFloat) / (denominator asLargeFloat)

    "
      (5/9) asLargeFloat
      (500000000000/900000000000) asLargeFloat
      (500000000000/9) asLargeFloat
    "
!

asLargeInteger
    "return an integer with my value - will usually truncate"

    ^ self asInteger asLargeInteger
!

asLongFloat
    "return a long float with (approximately) my value.
     Since floats have a limited precision, you usually loose bits when doing this."

    |num den numShift denShift numBits rslt|

    (numerator class == SmallInteger and:[denominator class == SmallInteger]) ifTrue:[
	^ (numerator asLongFloat) / (denominator asLongFloat)
    ].

    "Do it the hard way: reduce magnitude and undo reduction on the quotient"

    numBits := LongFloat precision * 2.    "number of bits to preserve (conservative)"
    num := numerator abs.
    numShift := numBits - num highBit. "(num highBit - bits) negated"
    numShift < 0 ifTrue:[num := num bitShift:numShift] ifFalse:[ numShift := 0].

    den :=  denominator.
    denShift := numBits - den highBit. "(den highBit - bits) negated"
    denShift < 0 ifTrue:[den := den bitShift:denShift] ifFalse:[denShift := 0].

    rslt := (num asLongFloat / den asLongFloat) * (2 raisedToInteger:denShift-numShift).
    numerator negative ifTrue:[ ^ rslt negated ].
    ^ rslt.

    "
      (5/9) asLongFloat
      (-5/9) asLongFloat
      (Fraction basicNew setNumerator:500000000000 denominator:900000000000) asLongFloat = (5/9) asLongFloat
      (Fraction basicNew setNumerator:500000000001 denominator:900000000000) asLongFloat = (5/9) asLongFloat
      (500000000001/900000000000) asLongFloat
      (-500000000001/900000000000) asLongFloat
      (500000000001/900000000000) asLongFloat = (5/9) asLongFloat

      (500000000000/9) asLongFloat
      (5/900000000000) asLongFloat
      89012345678901234567 asFloat / 123456789123456789 asLongFloat
      (89012345678901234567 / 123456789123456789) asLongFloat
      (-89012345678901234567 / 123456789123456789) asLongFloat

      (
       180338700661043257034670206806167960222709397862806840937993331366591676308781197477183367018067356365812757479444845320188679437752013593674158587947149815441890236037219685250845721864713487208757788709113534916165172927384095182655935222723385253851776639985379367854545495930551624041981995105743408203125
	/
       180331613628627651967947866455016278082980736719853750685591387625058011528928110602436691256100991596843001549483950600930062886280582766771424470965440873615557144641435276844465734361353086032476712374317224249252177316815544331763696909434844464464323192083930469387098582956241443753242492675781250
      ) asLongFloat

      180338700661043257034670206806167960222709397862806840937993331366591676308781197477183367018067356365812757479444845320188679437752013593674158587947149815441890236037219685250845721864713487208757788709113534916165172927384095182655935222723385253851776639985379367854545495930551624041981995105743408203125
	 asLongFloat /
      180331613628627651967947866455016278082980736719853750685591387625058011528928110602436691256100991596843001549483950600930062886280582766771424470965440873615557144641435276844465734361353086032476712374317224249252177316815544331763696909434844464464323192083930469387098582956241443753242492675781250
	 asLongFloat
    "
!

asShortFloat
    "return a short float with (approximately) my value"

    (numerator class == SmallInteger and:[denominator class == SmallInteger]) ifTrue:[
	^ (numerator asShortFloat) / (denominator asShortFloat)
    ].

    ^ self asFloat asShortFloat

    "
      (5/9) asShortFloat
      (500000000000/900000000000) asShortFloat
      (500000000000/9) asShortFloat
    "
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asFraction
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 60
! !

!Fraction methodsFor:'comparing'!

< aNumber
    "return true if the receiver is less
     than aNumber, false otherwise."

    (aNumber isMemberOf:SmallInteger) ifTrue:[
	^ numerator < (denominator * aNumber)
    ].
    ^ aNumber lessFromFraction:self

    "Modified: 5.11.1996 / 10:30:52 / cg"
!

= aNumber
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise"

    (aNumber isMemberOf:SmallInteger) ifTrue:[
	(denominator == 1) ifFalse:[
	    ^ numerator = (aNumber * denominator)
	].
	^ numerator = aNumber
    ].
    ^ aNumber equalFromFraction:self

    "Modified: / 7.7.1998 / 17:17:07 / cg"
!

> aNumber
    "return true if the receiver is greater
     than aNumber, false otherwise."
    "optional - could use inherited method ..."

    (aNumber isMemberOf:SmallInteger) ifTrue:[
	^ numerator > (denominator * aNumber)
    ].
    ^ aNumber < self
!

hash
    "return a number for hashing; redefined, since fractions compare
     by numeric value (i.e. (1/2) = 0.5), hash values must be the same"

    (denominator == 1) ifTrue:[^ numerator hash].
    (denominator == -1) ifTrue:[^ numerator hash negated].
    ^ self asFloat hash

    "
     3 hash
     (9/3) hash
     3.0 hash
     (1/2) hash
     (1/4) hash
     0.0 hash
     0.5 hash
     0.25 hash
     0.4 hash

     0.25 hash
     -0.25 hash
     (1/4) hash
     (-1/4) hash
    "
!

sameFractionValueAs:aNumber
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise"

    |rSelf rNum|

    rSelf := self reduced.
    rNum := aNumber reduced.
    rSelf denominator = rNum denominator ifTrue:[
	^ rSelf numerator = rNum numerator
    ].
    ^ false
! !

!Fraction methodsFor:'double dispatching'!

differenceFromFixedPoint:aFixedPoint
    |n d otherDenominator otherNumerator|

    otherDenominator := aFixedPoint denominator.
    otherNumerator := aFixedPoint numerator.

    "save a multiplication if possible"
    otherDenominator == denominator ifTrue:[
	n := otherNumerator - numerator.
	d := otherDenominator.
    ] ifFalse:[
	n := (otherNumerator * denominator) - (numerator * otherDenominator).
	d := otherDenominator * denominator.
    ].
    ^ aFixedPoint class
	numerator:n
	denominator:d
	scale:(aFixedPoint scale)

    "
     ((1/3) asFixedPoint:2) - (1/3)
     ((1/3) asFixedPoint:2) - (2/3)
    "
!

differenceFromFloat:aFloat
    "sent when a float does not know how to subtract the receiver, a fraction"

    ^ (aFloat * denominator - numerator) / denominator
!

differenceFromFraction:aFraction
    |n d otherDenominator otherNumerator|

    otherDenominator := aFraction denominator.
    otherNumerator := aFraction numerator.

    "save a multiplication if possible"
    otherDenominator == denominator ifTrue:[
	n := otherNumerator - numerator.
	d := otherDenominator.
    ] ifFalse:[
	n := (otherNumerator * denominator) - (numerator * otherDenominator).
	d := otherDenominator * denominator.
    ].
    ^ aFraction class
	numerator:n
	denominator:d

    "
     ((1/3) asFixedPoint:2) - (1/3)
     ((1/3) asFixedPoint:2) - (2/3)
    "
!

differenceFromInteger:anInteger
    "sent when an integer does not know how to subtract the receiver, a fraction"

    ^ self class
	numerator:((anInteger * denominator) - numerator)
	denominator:denominator

    "Modified: 28.7.1997 / 19:08:53 / cg"
!

equalFromFraction:aFraction
    denominator = aFraction denominator ifFalse:[
	^ false   " must always be reduced "
	"/ ^ (numerator * aFraction denominator) = (aFraction numerator * denominator)
    ].
    ^ numerator = aFraction numerator
!

equalFromInteger:anInteger
    "sent when an integer does not know how to compare to the receiver, a fraction"

    "as I am always reduced, this test should not be required.
     However, it is here for subclasses and to allow comparing unnormalized fractions,
     which might be encountered internally"

    denominator = 1 ifFalse:[
	^ numerator = (anInteger * denominator)
    ].
    ^ numerator = anInteger

    "
     1 = (1 asFixedPoint:1)
     (1 asFixedPoint:1) = 1
    "
!

lessEqFromInteger:anInteger
    "sent when an integer does not know how to compare to the receiver, a fraction"

    ^ (denominator * anInteger) <= numerator
!

lessFromFraction:aFraction
    "sent when a fraction does not know how to compare to the receiver.
     Return true if aFraction < self."

    |n d|

    d := aFraction denominator.
    n := aFraction numerator.

    "/ save a multiplication if possible
    d == denominator ifTrue:[
	^ n < numerator
    ].
    ^ (denominator * n) < (numerator * d)
!

lessFromInteger:anInteger
    "sent when an integer does not know how to compare to the receiver, a fraction.
     Return true if anInteger < self."

    ^ (denominator * anInteger) < numerator
!

productFromFixedPoint:aFixedPoint
    ^ aFixedPoint class
	numerator:(aFixedPoint numerator * numerator)
	denominator:(aFixedPoint denominator * denominator)
	scale:(aFixedPoint scale)

    "
     ((1/3) asFixedPoint:2) * 2
     ((1/3) asFixedPoint:2) * (1/2)
     ((1/3) asFixedPoint:2) * (3/2)
    "
!

productFromFloat:aFloat
    "sent when a float does not know how to multiply the receiver, a fraction"

    ^ aFloat * numerator / denominator
!

productFromFraction:aFraction
    ^ aFraction class
	numerator:(aFraction numerator * numerator)
	denominator:(aFraction denominator * denominator)

    "
     ((1/3) asFixedPoint:2) * 2
     ((1/3) asFixedPoint:2) * (1/2)
     ((1/3) asFixedPoint:2) * (3/2)
    "
!

productFromInteger:anInteger
    "sent when an integer does not know how to multiply the receiver, a fraction"

    ^ self class
	numerator:(anInteger * numerator)
	denominator:denominator

    "Modified: 28.7.1997 / 19:06:22 / cg"
!

quotientFromFixedPoint:aFixedPoint
    "Return the quotient of the argument, aFixedPoint and the receiver.
     Sent when aFixedPoint does not know how to divide by the receiver."

    ^ aFixedPoint class
	numerator:(aFixedPoint numerator * denominator)
	denominator:(aFixedPoint denominator * numerator)
	scale:(aFixedPoint scale)

    "
     ((1/3) asFixedPoint:2) / 2
     ((1/3) asFixedPoint:2) / (1/2)
    "
!

quotientFromFloat:aFloat
    "Return the quotient of the argument, aFloat and the receiver.
     Sent when aFloat does not know how to divide by the receiver."

    ^ (aFloat * denominator) / numerator
!

quotientFromFraction:aFraction
    "Return the quotient of the argument, aFraction and the receiver.
     Sent when aFraction does not know how to divide by the receiver."

    ^ aFraction class
	numerator:(aFraction numerator * denominator)
	denominator:(aFraction denominator * numerator)

    "
     (1/3) / (1/2)
     (1/3) / (3/2)
    "
!

quotientFromInteger:anInteger
    "Return the quotient of the argument, anInteger and the receiver.
     Sent when anInteger does not know how to divide by the receiver."

    ^ self class
	numerator:(anInteger * denominator)
	denominator:numerator

    "Modified: 28.7.1997 / 19:08:46 / cg"
!

sumFromFixedPoint:aFixedPoint
    |n d otherDenominator otherNumerator|

    otherDenominator := aFixedPoint denominator.
    otherNumerator := aFixedPoint numerator.

    "save a multiplication if possible"
    otherDenominator == denominator ifTrue:[
	n := otherNumerator + numerator.
	d := otherDenominator.
    ] ifFalse:[
	n := (otherNumerator * denominator) + (numerator * otherDenominator).
	d := otherDenominator * denominator.
    ].
    ^ aFixedPoint class
	numerator:n
	denominator:d
	scale:(aFixedPoint scale)

    "
     ((1/3) asFixedPoint:2) + (1/3)
     ((1/3) asFixedPoint:2) + (2/3)
    "
!

sumFromFloat:aFloat
    "sent when a float does not know how to add the receiver, a fraction"

    ^ (aFloat * denominator + numerator) / denominator
!

sumFromFraction:aFraction
    |n d otherDenominator otherNumerator|

    otherDenominator := aFraction denominator.
    otherNumerator := aFraction numerator.

    "save a multiplication if possible"
    otherDenominator == denominator ifTrue:[
	n := otherNumerator + numerator.
	d := otherDenominator.
    ] ifFalse:[
	n := (otherNumerator * denominator) + (numerator * otherDenominator).
	d := otherDenominator * denominator.
    ].
    ^ aFraction class
	numerator:n
	denominator:d

    "
     (1/3) + (1/3)
     (1/3) + (2/3)
    "
!

sumFromInteger:anInteger
    "sent when an integer does not know how to add the receiver, a fraction"

    ^ self class
	numerator:(numerator + (anInteger * denominator))
	denominator:denominator

    "Modified: 28.7.1997 / 19:08:40 / cg"
! !

!Fraction methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the
     argument, aStream"

    |t|

    PrintWholeNumbers == true ifTrue:[
	"/ experimental: print fractions which are greater than 1 as a sum of
	"/ an integral and the fractional part. They are easier to read this way.
	numerator > denominator ifTrue:[
	    aStream nextPut:$(.
	    t := numerator // denominator.
	    t printOn:aStream.
	    aStream nextPutAll:'+('.
	    (numerator - (t*denominator)) printOn:aStream.
	    aStream nextPut:$/.
	    denominator printOn:aStream.
	    aStream nextPutAll:'))'.
	    ^ self
	].
    ].

    aStream nextPut:$(.
    numerator printOn:aStream.
    aStream nextPut:$/.
    denominator printOn:aStream.
    aStream nextPut:$)

    "Modified: / 31.7.2002 / 09:56:41 / cg"
! !

!Fraction methodsFor:'private'!

reduced
    "reduce the receiver; divide the numerator and denominator by their
     greatest common divisor; if the result is integral, return an Integer.
     Otherwise, return the normalized receiver.
     CAVEAT: bad name; should be called reduce, as it has a side effect
     (i.e. this is destructive wrt. the instance values)."

    |gcd den|

    den := denominator.
    den < 0 ifTrue:[
	numerator := numerator negated.
	den := denominator := den negated.
    ].

    den == 1 ifTrue:[^ numerator].
    numerator == 1 ifTrue:[^ self].
    numerator == 0 ifTrue:[^ 0].

    gcd := numerator gcd:den.
    (gcd ~~ 1) ifTrue:[
	gcd < 0 ifTrue:[
	     gcd := gcd negated.
	].
	numerator := numerator // gcd.
	denominator := den := den // gcd.
	(den == 1) ifTrue:[^ numerator].
    ].
    ^ self
!

setNumerator:num denominator:den
    "set both numerator and denominator"

    numerator := num.
    denominator := den
! !

!Fraction methodsFor:'testing'!

isFraction
    "return true, if the receiver is some kind of fraction;
     true is returned here - the method is redefined from Object."

    ^ true
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    ^ true

!

negative
    "return true if the receiver is less than zero"

    (numerator < 0) ifTrue:[
	^ (denominator < 0) not
    ].
    ^ (denominator < 0)
! !

!Fraction methodsFor:'truncation & rounding'!

fractionPart
    "extract the after-decimal fraction part,
     such that (self truncated + self fractionPart) = self"

    numerator abs < denominator abs ifTrue:[
	^ self
    ].
    ^ (numerator rem: denominator) / denominator

    "
     (3/2) fractionPart + (3/2) truncated
     (-3/2) fractionPart + (-3/2) truncated

     (3/2) fractionPart
     (-3/2) fractionPart
     (3/2) asFloat fractionPart
     (-3/2) asFloat fractionPart
     (2/3) fractionPart
     ((3/2)*(15/4)) fractionPart
     ((2/3)*(4/15)) fractionPart
    "

    "Modified: / 5.11.2001 / 17:55:25 / cg"
!

integerPart
    "extract the pre-decimal integer part."

    numerator abs < denominator abs ifTrue:[
	^ 0
    ].
    ^ super integerPart

    "
     (3/2) integerPart
     (-3/2) integerPart
     (2/3) integerPart
     ((3/2)*(15/4)) integerPart
     ((2/3)*(4/15)) integerPart
    "

    "Modified: / 5.11.2001 / 17:55:01 / cg"
!

rounded
    "return the receiver rounded to the nearest integer as integer"

    "/ mhmh - what about -(1/2)

    |t|

    self negative ifTrue:[
	t := self - (1/2)
    ] ifFalse:[
	t := self + (1/2)
    ].
    ^ t truncated.

    "
     (1/3) rounded
     (1/3) negated rounded
     (1/2) rounded
     (1/2) negated rounded
     0.5 rounded
     -0.5 rounded
     (2/3) rounded
     (2/3) negated rounded
    "

    "Modified: 5.11.1996 / 11:32:32 / cg"
!

truncated
    "return the receiver truncated towards zero as Integer"

    ^ numerator quo: denominator

    "
     (3/2) truncated
     (3/2) negated truncated
    "

    "Modified: 5.11.1996 / 12:18:46 / cg"
! !

!Fraction methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitFraction:with: to aVisitor"

    ^ aVisitor visitFraction:self with:aParameter
! !

!Fraction class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Fraction initialize!
