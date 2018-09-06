"
     This is public domain code, not covered by the ST/X copyright.
     Code is provided 'as is', as a goody, without any warranty.

     this comes from:

     Jan Steinman, Bytesmiths
     2002 Parkside Court, West Linn, OR 97068-2767 USA, +1 503 657 7703
     Friedlistrasse 19, CH-3006, Bern, Switzerland, +41 31 999 3946

     this code was published in comp.lang.smalltalk; 
     added here as an example ...
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Fraction subclass:#FixedPoint
	instanceVariableNames:'scale'
	classVariableNames:'PrintTruncated'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

FixedPoint comment:'
Description: This class implements infinite precision fixed-point numbers. 
It doesn''t really do anything too interesting except creating instances, converting, and printing, 
since its superclass Fraction does all the work.

Test: "''123456789012345678901234567890.123456789'' asFixed * 1000000000 = 123456789012345678901234567890123456789"

Notes: 1) The current implementation does not convert arbitrarily-based String representations, 
          which shouldn''t be too much a problem for financial types.'
!

!FixedPoint class methodsFor:'documentation'!

copyright
"
     This is public domain code, not covered by the ST/X copyright.
     Code is provided 'as is', as a goody, without any warranty.

     this comes from:

     Jan Steinman, Bytesmiths
     2002 Parkside Court, West Linn, OR 97068-2767 USA, +1 503 657 7703
     Friedlistrasse 19, CH-3006, Bern, Switzerland, +41 31 999 3946

     this code was published in comp.lang.smalltalk; 
     added here as an example ...
"
!

documentation
"
    This class implements infinite precision fixed-point numbers,
    which internally hold exact (fractional) results, but print themself with
    a limited number of digits after the decimal point (rounded). 

    NOTICE:
        it seems that squeak prints these truncated,
        whereas ST/X prints them rounded.
        This behavior should probably be controllable by providing      
        a subclass (RoundedFixedPoint ?) which redefines the printOn: method.
        (it is now controlled by a classVar, which is of course not a thread-safe
        solution).

    These can be used in computation, where rounding errors should not accumulate,
    but only a limited precision is required for the final result.
    (i.e. business applications)

    It doesn't really do anything too interesting except creating instances, 
    converting, and printing, since its superclass Fraction does all the work.

    Test: 
        '123456789012345678901234567890.123456789' asFixedPoint * 1000000000
        -> 123456789012345678901234567890123456789'

    Notes: 1) The current implementation does not convert arbitrarily-based 
              String representations, which shouldn't be too much a problem 
              for financial types.

           2) the implementation is a hack - it has not been optimized for speed
              in particular.

    Mixed mode arithmetic:
        fix op fix       -> fix, scale is max. of operands
        fix op fraction  -> fix; scale is fix's scale
        fix op integer   -> fix; scale is fix's scale
        fix op float     -> float

    [author:]
        Jan Steinman, Bytesmiths
        adapted, modified & enhanced by Claus Gittinger

    [see also:]
        Number Fraction Integer Float ShortFloat LongFloat Complex
"
!

examples
"
                                                                [exBegin]
     |a b r|

     a := (FixedPoint fromString:'123.456').
     b := '1.10' asFixedPoint.
     r := a + b.
     Transcript showCR:r.
     Transcript showCR:(r withScale:2).
     Transcript showCR:(r withScale:1).
     Transcript showCR:(r rounded).
                                                                [exEnd]

                                                                [exBegin]
     |a b r|

     a := (FixedPoint fromString:'0.9999999').
     b := 0.0000001 asFixedPoint. 
     r := a + b.
     Transcript showCR:r.
     Transcript showCR:(r withScale:2).
     Transcript showCR:(r withScale:1).
     Transcript showCR:(r rounded).
                                                                [exEnd]

                                                                [exBegin]
     |a b r|

     a := (FixedPoint fromString:'0.9999998').
     b := (FixedPoint fromString:'0.0000001').
     r := a + b.
     Transcript showCR:r.
     Transcript showCR:(r withScale:2).
     Transcript showCR:(r withScale:1).
     Transcript showCR:(r rounded).
                                                                [exEnd]

                                                                [exBegin]
     |a b r|

     a := (FixedPoint fromString:'1.0').
     b := (FixedPoint fromString:'0.0000001').
     r := a + b.
     Transcript showCR:r.
     Transcript showCR:(r withScale:2).
     Transcript showCR:(r withScale:1).
     Transcript showCR:(r rounded).
                                                                [exEnd]

                                                                [exBegin]
     |a b r|

     a := (FixedPoint fromString:'0.99').
     b := (FixedPoint fromString:'0.0000001').
     r := a + b.
     Transcript showCR:r.
     Transcript showCR:(r withScale:2).
     Transcript showCR:(r withScale:1).
     Transcript showCR:(r rounded).
                                                                [exEnd]

"
! !

!FixedPoint class methodsFor:'instance creation'!

numerator:n denominator:d
    "redefined to block the inherited instance creation method from fraction.
     Raises an error - you must give a scale"

    self shouldNotImplement. "use #numerator:denominator:scale"
    "/ ^ self numerator:n denominator:d scale:(d log max:n log) ceiling

    "
     self numerator:123 denominator:100    
    "
!

numerator:n denominator:d scale:s
    "create and return a new fixedPoint instances with the given scale
     (post decimal digits when printed). Assume its already reduced."

    ^ self basicNew
        setNumerator:n denominator:d scale:s
!

readFrom:aStringOrStream 
    "return the next FixedPoint from the (character-)stream aStream. 

     NOTICE:   
       This behaves different from the default readFrom:, in returning
       0 (instead of raising an error) in case no number can be read.
       It is unclear, if this is the correct behavior (ST-80 does this)
       - depending on the upcoming ANSI standard, this may change."

    ^ self readFrom:aStringOrStream onError:0

    "
     FixedPoint readFrom:'.456'  
     FixedPoint readFrom:'123.456'  
     FixedPoint readFrom:'3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989380952572010654858632788'
     FixedPoint readFrom:(ReadStream on:'foobar')     
     FixedPoint readFrom:(ReadStream on:'foobar') onError:nil  

     FixedPoint readFrom:'1'      
     FixedPoint readFrom:'2'      
     FixedPoint readFrom:'1.5'    
    "

    "Modified: / 23-11-2010 / 14:39:29 / cg"
!

readFrom:aStringOrStream decimalPointCharacters:decimalPointCharacters onError:exceptionBlock
    "return an instance of me as described on the string or stream, aStringOrStream.
     If an error occurs during conversion, return the result
     from evaluating exceptionBlock"

    | aStream sign integerPart fractionStream char fractionPart scale nextChar |

    aStream := aStringOrStream readStream.

    aStream peekOrNil == $- ifTrue:[
        sign := -1.
        aStream next.
    ] ifFalse:[
        sign := 1
    ].

    nextChar := aStream peekOrNil.
    (nextChar isNil or:[nextChar isLetter]) ifTrue: [^ exceptionBlock value].
    (decimalPointCharacters includes:nextChar) ifTrue:[
        "/ no integer part
        integerPart := 0.
        aStream next.
    ] ifFalse:[
        integerPart := Integer readFrom:(aStream upToAny:decimalPointCharacters) onError:[^ exceptionBlock value].
    ].
    nextChar := aStream peekOrNil.
    (nextChar isNil or:[nextChar isDigit not]) ifTrue: [
"/        ^ integerPart * sign.
        ^ self basicNew 
            setNumerator:integerPart * sign
            denominator:1
            scale:0
    ] ifFalse:[
        fractionStream := ReadWriteStream on:(String new:10).
        [
            char := aStream nextOrNil.
            char notNil and:[char isDigit]
        ] whileTrue:[
            fractionStream nextPut:char
        ].

        scale := fractionStream position.
        fractionStream reset.
        fractionPart := Integer readFrom:fractionStream onError:[^ exceptionBlock value]. 
    ].

    ^ self basicNew 
        setNumerator:(integerPart * (10 raisedTo:scale) + fractionPart) * sign 
        scale:scale

    "
     FixedPoint readFrom:'1.00'    
     FixedPoint readFrom:'123.456'  
     FixedPoint readFrom:'123,456' decimalPointCharacters:',' 
     FixedPoint readFrom:'-123.456'     
     FixedPoint readFrom:'123'          
     FixedPoint readFrom:'-123' 

     FixedPoint readFromString:'-123.abcd' onError:[47.5]  
     FixedPoint readFromString:'-1a.bcd' onError:[47.5]  
     FixedPoint readFromString:'foot' onError:['bad fixedpoint'] 

     FixedPoint readFrom:'-123.abcd' onError:[47.5]  
     FixedPoint readFrom:'-1a.bcd' onError:[47.5] 
     FixedPoint readFrom:'foot' onError:['bad fixedpoint'] 
    "

    "Created: / 25-10-1997 / 15:28:59 / cg"
    "Modified: / 23-11-2010 / 14:38:12 / cg"
! !

!FixedPoint class methodsFor:'constants'!

pi
    "pi with 1000 valid digits..."

    ^ self pi1000

    "
     self pi squared    
     self pi reciprocal 
     1 / self pi 
     self pi * 1000000000000000000000000000000000000000000    
    "
!

pi1000
    "pi with 1000 valid digits..."

    PI_1000 isNil ifTrue:[
        PI_1000 := super pi1000 asFixedPoint:1024
    ].
    ^ PI_1000.

    "
     self pi squared    
     self pi reciprocal 
     1 / self pi 
     self pi * 1000000000000000000000000000000000000000000    
    "
! !

!FixedPoint class methodsFor:'printing control'!

printTruncated
    "return the PrintTruncated flag, which controls printing.
     See the description in the documentation for details"

    ^ PrintTruncated ? false.
!

printTruncated:aBoolean
    "set the PrintTruncated flag, which controls printing.
     See the description in the documentation for details"

    PrintTruncated := aBoolean.
! !

!FixedPoint class methodsFor:'queries'!

exponentCharacter
    "return the character used to print between mantissa an exponent.
     Also used by the scanner when reading numbers."

    ^ $s
! !

!FixedPoint methodsFor:'accessing'!

scale
    "return the number of places of significance that is carried by the receiver."

    ^ scale

    "Modified: 12.4.1997 / 11:21:05 / cg"
! !

!FixedPoint methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument.
     Redefined to care for the scale if the argument is another fixPoint number.
     The result's scale is the maximum of the receiver's scale and the argument's scale."

    "/ notice:
    "/ the following code handles some common cases,
    "/ and exists as an optimization, to speed up those cases.
    "/ also notice, that checks for those cases must be inlinable without
    "/ a message send; otherwise double-dispatch is just as fast.

    (aNumber isMemberOf:SmallInteger) ifTrue:[
        ^ self class 
                numerator:(numerator * aNumber)
                denominator:denominator
                scale:scale
    ].
    ^ aNumber productFromFixedPoint:self

    "                       
     |a r|

     a := (FixedPoint fromString:'123.456').
     r := a * 5.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
    "

    "                       
     |a b r|

     a := (FixedPoint fromString:'123.456').
     b := (FixedPoint fromString:'1.10').
     r := a * b.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
    "

    "                       
     |a b r|

     a := (FixedPoint fromString:'123.456').
     b := (FixedPoint fromString:'-1.10').
     r := a * b.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
    "

    "
     |a b r|

     a := (FixedPoint fromString:'0.9999999').
     b := (FixedPoint fromString:'0.9999999').
     r := a * b.    
     Transcript show:'fixed (exact)  : '; showCR:r.    
     Transcript show:'fixed (scale2) : '; showCR:(r withScale:2).

     Transcript show:'float (inexact): '; showCR:(0.9999999 * 0.9999999).
    "

    "
     |a b r|

     a := 1.
     b := (FixedPoint fromString:'0.9999999').
     r := a * b.    
     Transcript show:'fixed (exact)  : '; showCR:r.    
     Transcript show:'fixed (scale2) : '; showCR:(r withScale:2).

     Transcript show:'float (inexact): '; showCR:(0.9999999 * 0.9999999).
    "

    "                       
     |a r|

     a := (FixedPoint fromString:'123.456').
     r := a * 5.0.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
    "

    "                       
     |a r|

     a := (FixedPoint fromString:'123.456').
     r := 5.0 * a.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
    "
!

+ aNumber
    "return the sum of the receiver and the argument, aNumber.
     Redefined to care for the scale if the argument is another fixPoint number.
     The result's scale will be the maximum of the receiver's and the argument's scale."

    |n|

    "/ notice:
    "/ the following code handles some common cases,
    "/ and exists as an optimization, to speed up those cases.
    "/ also notice, that checks for those cases must be inlinable without
    "/ a message send; otherwise double-dispatch is just as fast.

    (aNumber isMemberOf:SmallInteger) ifTrue:[
        "save a multiplication if possible"
        denominator == 1 ifTrue:[
            n := numerator + aNumber.
        ] ifFalse:[
            n := numerator + (aNumber * denominator).
        ].
        ^ self class 
            numerator:n 
            denominator:denominator
            scale:scale
    ].
    ^ aNumber sumFromFixedPoint:self

    "
     ((1/3) asFixedPoint:2) + 1    
     ((1/3) asFixedPoint:2) + (1/3)
    "
    "
     |a b|

     a := (FixedPoint fromString:'123.456').
     b := (FixedPoint fromString:'1.10').
     a + b
    "
    "
     |a b|

     a := (FixedPoint fromString:'0.9999999').
     b := (FixedPoint fromString:'0.0000001').
     a + b                   
    "

    "
     |a b|

     a := (FixedPoint fromString:'0.99').
     b := (FixedPoint fromString:'0.0000001').
     a + b                             
    "

    "
     |a b|

     a := (FixedPoint fromString:'0.99').
     b := (FixedPoint fromString:'0.0000001').
     (a + b) withScale:2  
    "

    "
     |a b|

     a := (FixedPoint fromString:'0.99').
     b := (FixedPoint fromString:'0.0000001').
     (a + b) withScale:1  
    "

    "
     |a b|

     a := 1.
     b := (FixedPoint fromString:'0.0000001').
     Transcript showCR:((a + b) withScale:1).
     Transcript showCR:(a + b)
    "
!

- aNumber
    "return the difference of the receiver and the argument, aNumber.
     Redefined to care for the scale if the argument is another fixPoint number.
     The result's scale is the maximum of the receiver's scale and the argument's scale."

    |n|

    "/ notice:
    "/ the following code handles some common cases,
    "/ and exists as an optimization, to speed up those cases.
    "/ also notice, that checks for those cases must be inlinable without
    "/ a message send; otherwise double-dispatch is just as fast.

    (aNumber isMemberOf:SmallInteger) ifTrue:[
        "save a multiplication if possible"
        denominator == 1 ifTrue:[
            n := numerator - aNumber.
        ] ifFalse:[
            n := numerator - (aNumber * denominator).
        ].
        ^ self class 
            numerator:n 
            denominator:denominator
            scale:scale
    ].
    ^ aNumber differenceFromFixedPoint:self

    "
     |a b|

     a := (FixedPoint fromString:'123.456').
     b := (FixedPoint fromString:'1.10').
     a - b     
    "

    "
     |a b|

     a := (FixedPoint fromString:'0.9999999').
     b := (FixedPoint fromString:'0.0000009').
     a - b                   
    "

    "
     |a b|

     a := (FixedPoint fromString:'0.99').
     b := (FixedPoint fromString:'0.0000001').
     a - b                          
    "

    "
     |a b|

     a := (FixedPoint fromString:'0.99').
     b := (FixedPoint fromString:'0.0000001').
     (a - b) withScale:2  
    "

    "
     |a b|

     a := (FixedPoint fromString:'0.99').
     b := (FixedPoint fromString:'0.0000001').
     (a - b) withScale:1  
    "

    "
     |a b|

     a := (FixedPoint fromString:'0.0000001').
     b := (FixedPoint fromString:'0.99').
     (a - b) withScale:2   
    "

    "
     |a b|

     a := 1.
     b := (FixedPoint fromString:'0.0000001').
     Transcript showCR:((a - b) withScale:1).
     Transcript showCR:(a - b)
    "
!

/ aNumber
    "return the quotient of the receiver and the argument, aNumber.
     Redefined to care for the scale if the argument is another fixPoint number.
     The result's scale is the maximum of the receiver's scale and the argument's scale."

    "/ notice:
    "/ the following code handles some common cases,
    "/ and exists as an optimization, to speed up those cases.
    "/ also notice, that checks for those cases must be inlinable without
    "/ a message send; otherwise double-dispatch is just as fast.

    (aNumber isMemberOf:SmallInteger) ifTrue:[
        ^ self class 
                numerator:numerator
                denominator:(denominator * aNumber)
                scale:scale
    ].

    ^ aNumber quotientFromFixedPoint:self

    "                       
     |a r|                     

     a := (FixedPoint fromString:'123.456').
     r := a / 5.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
     Transcript showCR:(r withScale:9).
    "

    "                       
     |a b r|

     a := (FixedPoint fromString:'123.456').
     b := (FixedPoint fromString:'1.10').
     r := a / b.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
    "

    "                       
     |a b r|

     a := (FixedPoint fromString:'-123.456').
     b := (FixedPoint fromString:'-1.10').
     r := a / b.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
    "

    "                       
     |a b r|

     a := (FixedPoint fromString:'123.456').
     b := (FixedPoint fromString:'-1.10').
     r := a / b.    
     Transcript showCR:r.    
     Transcript showCR:(r withScale:2).
    "

    "
     |a b r|

     a := 1.
     b := (FixedPoint fromString:'0.9999999').
     r := a / b.    
     Transcript show:'fixed (exact)  : '; showCR:r.    
     Transcript show:'fixed (scale2) : '; showCR:(r withScale:2).

     Transcript show:'float (inexact): '; showCR:(1 / 0.9999999).
    "
!

negated
    "redefined from Fraction to preserve scale"

    ^ self class 
        numerator:(numerator negated)
        denominator:denominator
        scale:scale
!

reciprocal
    "redefined from Fraction to preserve scale"

    numerator == 1 ifTrue:[^ denominator].
    ^ self class 
        numerator:denominator
        denominator:numerator
        scale:scale
! !

!FixedPoint methodsFor:'coercing & converting'!

asFixedPoint
    "return the receiver as a fixedPoint number - that's the receiver itself"

    ^ self

    "Modified: 10.1.1997 / 19:53:14 / cg"
!

asFixedPoint:newScale
    "return a fixedPoint with the same value as the receiver, 
     and newScale number of post-decimal digits"

    |minRequiredDenominator factor|

    newScale == scale ifTrue:[^ self].

    minRequiredDenominator := 10 raisedTo:newScale.
    denominator < minRequiredDenominator ifTrue:[
        factor := minRequiredDenominator / denominator.

        ^ self class
            numerator:(numerator * factor)
            denominator:minRequiredDenominator
            scale:newScale
    ].
    ^ self class
        numerator:numerator
        denominator:denominator
        scale:newScale

    "
     '12345.12345' asFixedPoint:2   
     (FixedPoint fromString:'12345.12345') asFixedPoint:2 

     ((FixedPoint fromString:'0.33333333')
      + 
      (FixedPoint fromString:'0.33333333')
     ) asFixedPoint:2   
    "

    "Modified: 12.4.1997 / 11:20:37 / cg"
!

asFraction
    "return the receiver as a fraction"

    ^ Fraction
        numerator:numerator
        denominator:denominator

    "
     (FixedPoint fromString:'0.2')           
     (FixedPoint fromString:'0.2') asFraction
     (FixedPoint fromString:'0.2') asFloat
     (FixedPoint fromString:'0.2') asShortFloat
     (FixedPoint fromString:'0.2') asInteger
    "
!

asIntegerIfPossible
    (scale == 0 and:[denominator == 1]) ifTrue:[
        ^ numerator
    ].
    ^ self
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asFixedPoint
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    ^ 65

    "
     (FixedPoint fromString:'1.001') + 1      
     (FixedPoint fromString:'1.001') + 1.0    
     (FixedPoint fromString:'1.001') + (1/2)   
     (FixedPoint fromString:'1.001') + 1.0 asShortFloat 
     (FixedPoint fromString:'1.001') + 1 asLargeInteger 

     1 + (FixedPoint fromString:'1.001') 
     1.0 + (FixedPoint fromString:'1.001')      
     (1/2) + (FixedPoint fromString:'1.001')    
     1.0 asShortFloat + (FixedPoint fromString:'1.001')
     1 asLargeInteger + (FixedPoint fromString:'1.001')
    "
! !

!FixedPoint methodsFor:'double dispatching'!

differenceFromFixedPoint:aFixedPoint
    "sent when a fixedPoint is asked to subtract the receiver.
     The result has the higher scale of the two operands.
     Redefined here to compute the scale."

    |n d otherNumerator otherDenominator|

    otherNumerator := aFixedPoint numerator.
    otherDenominator := aFixedPoint denominator.

    "save a multiplication if possible"
    denominator = otherDenominator ifTrue:[
        n := otherNumerator - numerator.
        d := otherDenominator.
    ] ifFalse:[
        n := (otherNumerator * denominator) - (numerator * otherDenominator).
        d := denominator * otherDenominator.
    ].
    ^ self class 
            numerator:n 
            denominator:d
            scale:(scale max:aFixedPoint scale)

    "
     ((1/3) asFixedPoint:2) - ((1/3) asFixedPoint:2)        
     ((1/3) asFixedPoint:2) - ((2/3) asFixedPoint:2)     
     (1/3) - ((2/3) asFixedPoint:2)     

     ((1/3) asFixedPoint:2) - ((1/3) asFixedPoint:4)        
     ((1/3) asFixedPoint:2) - ((2/3) asFixedPoint:4)        
    "
!

differenceFromFraction:aFraction
    "sent when a fraction is asked to subtract the receiver.
     The result has my scale.
     Redefined here to preserve the scale."

    |n d otherNumerator otherDenominator|

    otherNumerator := aFraction numerator.
    otherDenominator := aFraction denominator.

    "save a multiplication if possible"
    denominator = otherDenominator ifTrue:[
        n := otherNumerator - numerator.
        d := otherDenominator.
    ] ifFalse:[
        n := (otherNumerator * denominator) - (numerator * otherDenominator).
        d := denominator * otherDenominator.
    ].
    ^ self class 
            numerator:n 
            denominator:d
            scale:scale

    "
     (1/3) - ((2/3) asFixedPoint:2)     
    "
!

differenceFromInteger:anInteger
    "sent when an integer does not know how to subtract the receiver.
     The result has my scale.
     Redefined here to preserve the scale."

    ^ self class 
        numerator:((anInteger * denominator) - numerator)
        denominator:denominator
        scale:scale
!

productFromFixedPoint:aFixedPoint
    "sent when a fixedPoint is asked to multiply the receiver.
     The result has the higher scale of the two operands.
     Redefined here to compute the scale."

    ^ aFixedPoint class 
        numerator:(aFixedPoint numerator * numerator) 
        denominator:(aFixedPoint denominator * denominator)
        scale:(scale max:aFixedPoint scale)

    "
     ((1/3) asFixedPoint:2) * ((1/3) asFixedPoint:4)
     (1/3) * ((1/3) asFixedPoint:4)
    "
!

productFromFraction:aFraction
    "sent when a fraction is asked to multiply the receiver.
     The result has my scale.
     Redefined here to preserve the scale."

    ^ self class 
        numerator:(aFraction numerator * numerator) 
        denominator:(aFraction denominator * denominator)
        scale:scale

    "
     (1/3) * ((1/3) asFixedPoint:4) 
    "
!

productFromInteger:anInteger
    "sent when an integer does not know how to multiply the receiver.
     Redefined here to preserve the scale."

    ^ self class 
        numerator:(anInteger * numerator)
        denominator:denominator
        scale:scale

    "Modified: 5.11.1996 / 10:32:28 / cg"
!

quotientFromFixedPoint:aFixedPoint
    "sent when a fixedPoint is asked to divide by the receiver.
     The result has the higher scale of the two operands.
     Redefined here to compute the scale."

    ^ aFixedPoint class 
        numerator:(aFixedPoint numerator * denominator) 
        denominator:(aFixedPoint denominator * numerator)
        scale:(scale max:aFixedPoint scale)

    "
     ((1/3) asFixedPoint:2) / ((1/3) asFixedPoint:2) 
     ((1/3) asFixedPoint:2) / ((1/3) asFixedPoint:4) 
    "
!

quotientFromFraction:aFraction
    "Return the quotient of the argument, aFraction and the receiver.
     Sent when aFraction does not know how to divide by the receiver.
     Redefined here to preserve the scale."

    ^ aFraction class 
        numerator:(aFraction numerator * denominator) 
        denominator:(aFraction denominator * numerator)
        scale:scale

    "
     ((1/3) asFixedPoint:2) / ((1/3) asFixedPoint:2)  
     ((1/3) asFixedPoint:2) / ((1/3) asFixedPoint:4)  
    "
!

quotientFromInteger:anInteger
    "Return the quotient of the argument, anInteger and the receiver.
     Sent when anInteger does not know how to divide by the receiver.
     Redefined here to preserve the scale."

    ^ self class 
        numerator:(anInteger * denominator)
        denominator:numerator
        scale:scale

    "Modified: 5.11.1996 / 10:32:35 / cg"
!

sumFromFixedPoint:aFixedPoint
    "sent when a fixedPoint is asked to add by the receiver.
     The result has the higher scale of the two operands.
     Redefined here to compute the scale."

    |n d otherNumerator otherDenominator|

    otherNumerator := aFixedPoint numerator.
    otherDenominator := aFixedPoint denominator.

    "save a multiplication if possible"
    denominator = otherDenominator ifTrue:[
        n := numerator + otherNumerator.
        d := otherDenominator.
    ] ifFalse:[
        n := (numerator * otherDenominator) + (otherNumerator * denominator).
        d := denominator * otherDenominator.
    ].
    ^ self class 
            numerator:n 
            denominator:d
            scale:(scale max:aFixedPoint scale)

    "
     ((1/3) asFixedPoint:2) + ((1/3) asFixedPoint:2)        
     ((1/3) asFixedPoint:2) + ((2/3) asFixedPoint:2)     

     ((1/3) asFixedPoint:2) + ((1/3) asFixedPoint:4)        
    "
!

sumFromFraction:aFraction
    "sent when a fraction is asked to add the receiver.
     The result has my scale.
     Redefined here to preserve the scale."

    |n d otherNumerator otherDenominator|

    otherNumerator := aFraction numerator.
    otherDenominator := aFraction denominator.

    "save a multiplication if possible"
    denominator = otherDenominator ifTrue:[
        n := numerator + otherNumerator.
        d := otherDenominator.
    ] ifFalse:[
        n := (numerator * otherDenominator) + (otherNumerator * denominator).
        d := denominator * otherDenominator.
    ].
    ^ self class 
            numerator:n 
            denominator:d
            scale:scale

    "
     (1/3) + ((1/3) asFixedPoint:2)        
    "
!

sumFromInteger:anInteger
    "sent when an integer does not know how to add the receiver.
     The result has my scale.
     Redefined here to preserve the scale."

    ^ self class 
        numerator:(numerator + (anInteger * denominator))
        denominator:denominator
        scale:scale

    "Modified: 5.11.1996 / 10:32:43 / cg"
! !

!FixedPoint methodsFor:'mathematical functions'!

sqrt
    "compute the square root, using the Newton method.
     The approximated return value has an error less than 
     the receiver's last digit, as specified in the scale."

    ^ self
        sqrtWithErrorLessThan:(1 / (10 raisedTo:scale+1)) asFixedPoint

    "
     (2 asFixedPoint:4) sqrt   
     (2 asFixedPoint:100) sqrt   
     (2 asFixedPoint:1000) sqrt   
     (10 asFixedPoint:100) sqrt   
     (100 asFixedPoint:100) sqrt   
    "
! !

!FixedPoint methodsFor:'printing & storing'!

printDecimalOn:aStream roundToScale:roundToScale truncateToScale:truncateToScale
    "common helper for printing (with round or truncate)
     and storing (neither rounding, nor truncating)"

    |e integerPart fractionPart negative num rest|

    numerator < 0 ifTrue:[
        negative := true.
        num := numerator negated.
    ] ifFalse:[
        negative := false.
        num := numerator.
    ].
    integerPart := (num // denominator).
    fractionPart := (num \\ denominator).
    (roundToScale or:[truncateToScale]) ifTrue:[    
        e := 10 raisedTo:scale.
    ] ifFalse:[
        (denominator isPowerOf:10) ifTrue:[
            e := denominator.
        ] ifFalse:[
            e := 10 raisedTo:(denominator log:10) asInteger + scale + 2.
        ].
    ].

    "/ the most common case is a denominator fitting the scale
    "/ (fixedPoint numbers are created this way)
    e = denominator ifFalse:[
        fractionPart := fractionPart * (e * 10) // denominator.
        roundToScale ifTrue:[
            fractionPart := (fractionPart roundTo:10) // 10.
        ] ifFalse:[
            fractionPart := fractionPart // 10.
        ].
        fractionPart >= e ifTrue:[
            integerPart := integerPart + 1.
            fractionPart := 0.
        ]
    ].

    "/
    "/ add a 1000..., so we can (mis-)use integer-printString ...
    "/ the highest-1 will be cutoff after padding.
    "/
    fractionPart := e + fractionPart.

    negative ifTrue:[
        aStream nextPut:$-
    ].
    integerPart printOn:aStream.
    (roundToScale or:[truncateToScale]) ifTrue:[
        scale > 0 ifTrue:[
            aStream nextPut: $..
            ((fractionPart printStringPaddedTo:scale with:$0) copyFrom:2) printOn:aStream
        ].
    ] ifFalse:[
        rest := ((fractionPart printString) copyFrom:2).
        scale > 0 ifTrue:[
            aStream nextPut: $..
            (rest paddedTo:scale with:$0) printOn:aStream
        ] ifFalse:[
            rest notEmpty ifTrue:[
                aStream nextPut: $..
                rest printOn:aStream
            ]
        ]
    ].

    "
    ((FixedPoint fromString:'0.66666666') withScale:2)
        printDecimalOn:Transcript roundToScale:false truncateToScale:false

    ((FixedPoint fromString:'0.66666666') withScale:2)
        printDecimalOn:Transcript roundToScale:true truncateToScale:false

    ((FixedPoint fromString:'0.66666666') withScale:2)
        printDecimalOn:Transcript roundToScale:false truncateToScale:true
    "
!

printOn:aStream 
    "append to the argument, aStream, a printed representation of the receiver.
     For printout, only scale post-decimal digits are printed
     (By default, the printout is rounded to that many digits)"

    PrintTruncated == true ifTrue:[
        self printTruncatedOn:aStream
    ] ifFalse:[
        self printRoundedOn:aStream
    ].

    "
     (FixedPoint fromString:'0.66666666')               
     (FixedPoint fromString:'0.66666666') withScale:2   
     (FixedPoint fromString:'0.99999999')               
     (FixedPoint fromString:'0.99999999') withScale:2   
     (FixedPoint fromString:'1.00000001')               
     (FixedPoint fromString:'1.00000001') withScale:2   
     (FixedPoint fromString:'1.005')                    
     (FixedPoint fromString:'1.005') withScale:2        
     (FixedPoint fromString:'1.005') withScale:1        
     (FixedPoint fromString:'1.5')                    
     (FixedPoint fromString:'1.5') withScale:2        
     (FixedPoint fromString:'1.5') withScale:1        
     (FixedPoint fromString:'1.5') withScale:0        

     (FixedPoint fromString:'-0.66666666')              
     (FixedPoint fromString:'-0.66666666') withScale:2   
     (FixedPoint fromString:'-0.99999999')              
     (FixedPoint fromString:'-0.99999999') withScale:2   
     (FixedPoint fromString:'-1.00000001')              
     (FixedPoint fromString:'-1.00000001') withScale:2   
     (FixedPoint fromString:'-1.005')                   
     (FixedPoint fromString:'-1.005') withScale:2       
     (FixedPoint fromString:'-1.005') withScale:1       
     (FixedPoint fromString:'-1.05')                    
     (FixedPoint fromString:'-1.05') withScale:2      
     (FixedPoint fromString:'-1.05') withScale:1      
     (FixedPoint fromString:'-1.04')                  
     (FixedPoint fromString:'-1.04') withScale:2      
     (FixedPoint fromString:'-1.04') withScale:1      
    "

    "
     |a b r|

     a := (FixedPoint fromString:'0.66666666') withScale:2.
     b := (FixedPoint fromString:'0.33333333').
     r := (a + b) withScale:4.
     Transcript show:'printout with scale of 4 :'; showCR:r.
     Transcript show:'more precise value       :'; showCR:(r withScale:8)
    "

    "Modified: 12.4.1997 / 11:20:51 / cg"
!

printRoundedOn:aStream 
    "append to the argument, aStream, a printed representation of the receiver.
     For printout, only scale post-decimal digits are printed,
     the printout is rounded to that many digits"

    self printDecimalOn:aStream roundToScale:true truncateToScale:false

    "
     ((FixedPoint fromString:'0.66666666') withScale:2) printRoundedOn:Transcript   
     ((FixedPoint fromString:'0.66666666') withScale:2) printTruncatedOn:Transcript   
    "

    "Modified: 12.4.1997 / 11:20:51 / cg"
!

printTruncatedOn:aStream 
    "append to the argument, aStream, a printed representation of the receiver.
     For printout, only scale post-decimal digits are printed,
     the printout is truncated to that many digits"

    self printDecimalOn:aStream roundToScale:false truncateToScale:true

    "
     ((FixedPoint fromString:'0.66666666') withScale:2) printRoundedOn:Transcript   
     ((FixedPoint fromString:'0.66666666') withScale:2) printTruncatedOn:Transcript   
    "

    "Modified: 12.4.1997 / 11:20:51 / cg"
!

storeOn:aStream
    "notice: we MUST preserve the full internal precision when storing/reloading"

    self printDecimalOn:aStream roundToScale:false truncateToScale:false.
    aStream nextPut:$s.
    scale storeOn:aStream.

    "
     ((FixedPoint fromString:'0.66666666')              ) storeString 
     ((FixedPoint fromString:'0.66666666') withScale:2  ) storeString  
     ((FixedPoint fromString:'1.5')                     ) storeString 
     ((FixedPoint fromString:'1.5') withScale:2         ) storeString 
     ((FixedPoint fromString:'1.5') withScale:1         ) storeString 
     ((FixedPoint fromString:'1.5') withScale:0         ) storeString 
    "
!

storeString 
    ^ String streamContents:[:s | self storeOn:s]

    "
     ((FixedPoint fromString:'0.66666666')             ) storeString 
     ((FixedPoint fromString:'0.66666666') withScale:2 ) storeString  
     ((FixedPoint fromString:'1.5')                     ) storeString 
     ((FixedPoint fromString:'1.5') withScale:2         ) storeString 
     ((FixedPoint fromString:'1.5') withScale:1         ) storeString 
     ((FixedPoint fromString:'1.5') withScale:0         ) storeString 
    "
! !

!FixedPoint methodsFor:'private'!

reduced
    "reduce the receiver; divide the numerator and denominator by their
     greatest common divisor; if the result is integral, return an Integer.
     Otherwise, return the normalized receiver.
     CAVEAT: bad name; should be called reduce, as it has a side effect
     (i.e. this is destructive wrt. the instance values)."

    |gc|

    scale isNil ifTrue:[
        "/ to catch inherited Fraction reduce calls
        self error:'should not happen'.
        scale := 3
    ].

    (denominator < 0) ifTrue:[
        numerator := numerator negated.
        denominator := denominator negated
    ].

    denominator == 1 ifTrue:[^ numerator].
    numerator == 1 ifTrue:[^ self].
    numerator == 0 ifTrue:[^ 0].

    gc := numerator gcd:denominator.
    gc < 0 ifTrue:[
        gc := gc negated
    ].
    gc := gc gcd:(10 raisedToInteger:scale).

    (gc ~~ 1) ifTrue:[
        numerator := numerator // gc.
        denominator := denominator // gc.
        denominator == 1 ifTrue:[^ numerator].
    ].

    ^ self
!

scale:newScale 
    "set the scale."

    scale := newScale.

    "Modified: / 12.4.1997 / 11:22:02 / cg"
    "Created: / 5.8.1998 / 13:28:49 / cg"
!

setNumerator:nInteger denominator:d scale:s 
    "initialize the instance variables.
     Assumes that the fraction as specified by numerator and denominator
     is already reduced."

    scale := s.
    numerator := nInteger.
    denominator := d
!

setNumerator:nInteger scale:s 
    "initialize the instance variables.
     Assumes that the fraction as specified by numerator and denominator
     is already reduced."

    scale := s.
    numerator := nInteger.
    denominator := (10 raisedTo:s)
!

setScale:newScale 
    "initialize the scale instance variables."

    scale := newScale.

    "Modified: 12.4.1997 / 11:22:02 / cg"
! !

!FixedPoint methodsFor:'testing'!

isFixedPoint
    "return true, if the receiver is some kind of fixedPoint number;
     true is returned here - the method is redefined from Object."

    ^ true


! !

!FixedPoint methodsFor:'truncation & rounding'!

roundedToScale
    "return the receiver rounded to my scale 
     (i.e. return a number which has the value which is shown when printing)"

    |n scale10|

    scale10 := 10 raisedToInteger:scale.
    n := ((numerator * scale10) + (denominator bitShift:-1)) // denominator.
    ^ self class
        numerator:n
        denominator:scale10
        scale:scale.

    "
     ((2/3) asFixedPoint:2)                     
     ((2/3) asFixedPoint:2) rounded          
     ((2/3) asFixedPoint:2) roundedToScale     
    "

    "Modified: 5.11.1996 / 12:18:46 / cg"
!

truncatedToScale
    "return the receiver truncated towards zero to my scale"

    |n scale10|

    scale10 := 10 raisedToInteger:scale.
    n := (numerator * scale10) quo:denominator.
    ^ self class
        numerator:n
        denominator:scale10
        scale:scale.

    "
     ((2/3) asFixedPoint:2)                     
     ((2/3) asFixedPoint:2) truncated          
     ((2/3) asFixedPoint:2) truncatedToScale     
    "

    "Modified: 5.11.1996 / 12:18:46 / cg"
! !

!FixedPoint class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

