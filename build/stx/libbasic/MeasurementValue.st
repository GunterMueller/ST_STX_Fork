"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2007 by eXept Software AG
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

Number subclass:#MeasurementValue
	instanceVariableNames:'value minValue maxValue'
	classVariableNames:'MeasurementValueZero'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!MeasurementValue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    A MeasurementValue is a numeric value with an error, such as returned
    by measurement devices (Volt-Meter). For example, if a measurement-device has
    an error of 10%, a measured value of 20 could be any value between 18 and 22.

    Arithmetic operations keep track of the error; if any operand is a MeasurementValue,
    the operation returns a MeasurementValue as result.

    This class is possibly unfinished and needs more arithmetic methods.
    For now, the stuff found here represents our needs and more might be added in the future.

    Also notice, that instances do not keep the error as a fraction, but instead a min. and maxValue.
    That means, that we can handle the case where the error is different in
    the positive and negative directions.
    I am not sure if this is more flexibility than needed in the long run.

    [author:]
        Claus Gittinger

    [see also:]
        Number
        Float ShortFloat Fraction FixedPoint Integer Complex
        FloatArray DoubleArray
"
!

examples
"
    Notice, how the errors accumulate...
                                                                        [exBegin]
    |voltage current power|

    voltage := MeasurementValue value:10 error:0.05.
    current := MeasurementValue value:2 error:0.1.
    power := voltage * current.
    power.                   
    power minValue.
    power maxValue.
                                                                        [exEnd]

                                                                        [exBegin]
    |voltage current power|

    voltage := MeasurementValue value:10 error:0.05.
    current := 2.
    power := voltage * current.
    power
                                                                        [exEnd]

                                                                        [exBegin]
    |voltage doubleVoltage|

    voltage := MeasurementValue value:10 error:0.1.
    doubleVoltage := 2 * voltage.
    doubleVoltage
                                                                        [exEnd]
"
! !

!MeasurementValue class methodsFor:'instance creation'!

value:valueArg error:errorArg
    "return a new measurementValue with a given value and an error (fraction)"

    ^ self new value:valueArg error:errorArg

    "10 with an error of 20%:

     MeasurementValue value:10 error:0.2 
    "
!

value:valueArg minValue:minArg maxValue:maxArg
    "return a new measurementValue with a given value and an error given as min-max values.
     Use this, if the error is not the same in both directions"

    ^ self new value:valueArg minValue:minArg maxValue:maxArg

    "an order of magnitude error:

     MeasurementValue value:5 minValue:1 maxValue:10   
    "
! !

!MeasurementValue class methodsFor:'constants'!

unity
    "return the neutral element for multiplication"

    ^ 1

    "
     self unity
    "
!

zero
    "return the neutral element for addition (0 +/- 0)"

    MeasurementValueZero isNil ifTrue:[
        MeasurementValueZero := self value:0 minValue:0 maxValue:0
    ].
    ^ MeasurementValueZero

    "
     self zero
    "
! !

!MeasurementValue methodsFor:'accessing'!

maxValue
    "the maximum possible value, considerung what has been measured and what the measurement error is"

    ^ maxValue
!

minValue
    "the minimum possible value, considerung what has been measured and what the measurement error is"

    ^ minValue
!

value
    "the measured value"

    ^ value
! !

!MeasurementValue methodsFor:'arithmetic'!

* aNumber
    "return the product of the receiver and the argument.
     Care for the error to propagate into the result."

    ^ MeasurementValue new
        value:(value * aNumber value)
        minValue:((minValue * aNumber minValue) min:(maxValue * aNumber minValue))
        maxValue:((maxValue * aNumber maxValue) max:(minValue * aNumber maxValue))

    "
     (MeasurementValue value:-10 error:0.2) * (MeasurementValue value:-10 error:0.2) 
     (MeasurementValue value:-10 error:0.2) * 2 
    "
!

+ aNumber
    "return the sum of the receiver and the argument.
     Care for the error to propagate into the result."

    ^ MeasurementValue new
        value:(value + aNumber value)
        minValue:(minValue + aNumber minValue)
        maxValue:(maxValue + aNumber maxValue)

    "
     (MeasurementValue value:-10 error:0.2) + (MeasurementValue value:-10 error:0.2) 
     (MeasurementValue value:-10 error:0.2) + 2  
    "
!

- aNumber
    "return the difference of the receiver and the argument.
     Care for the error to propagate into the result."

    ^ MeasurementValue new
        value:(value - aNumber value)
        minValue:(minValue - aNumber maxValue)
        maxValue:(maxValue - aNumber minValue)

    "
     (MeasurementValue value:-10 error:0.2) - (MeasurementValue value:-10 error:0.2) 
     (MeasurementValue value:-10 error:0.2) - 10                                     
     (MeasurementValue value:10 error:0.2) - 10                                     
    "
!

/ aNumber
    "return the quotient of the receiver and the argument.
     Care for the error to propagate into the result."

    ^ MeasurementValue new
        value:(value / aNumber value)
        minValue:(minValue / aNumber maxValue)
        maxValue:(maxValue / aNumber minValue)
! !

!MeasurementValue methodsFor:'coercing & converting'!

+/- error
    "return a MeasurementValue with a given error."

    "/ what should I do here - take the new error,
    "/ or multiply them ????
    self error.

    minValue := value - error.
    maxValue := value + error.

    "Modified (comment): / 14-02-2012 / 14:17:39 / cg"
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ MeasurementValue value:aNumber minValue:aNumber maxValue:aNumber
!

generality
    "return the generality value - see ArithmeticValue>>retry:coercing:"

    "/ adding 1 to the value's generality has the subtle side effect of enforcing 
    "/ a call to coerce: for mixed type operations (i.e. Int * MeasurementValue).
    "/ try it.

    ^ value generality + 1 
! !

!MeasurementValue methodsFor:'comparing'!

< aNumber
    "return true, if the argument is greater than the receiver.
     Care for the error - i.e. compare against my maximum-value"

    ^ maxValue < aNumber
!

= aNumber
    "hard to tell, what we want here...
     How about: aNumber between:minValue and:maxValue ???"

    ^ value = aNumber value
    and:[ minValue = aNumber minValue
    and:[ maxValue = aNumber maxValue ]]
!

hash
    ^ value hash
!

lessFromFloat:aFloat
    "aFloat < self ?"

    ^ aFloat < minValue
!

lessFromInteger:anInteger
    "anInteger < self ?"

    ^ anInteger < minValue
! !

!MeasurementValue methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:'('.
    (maxValue-value) = (value-minValue) ifTrue:[
        value storeOn:aStream.
        aStream nextPutAll:' +/- '.
        (maxValue-value) abs storeOn:aStream
    ] ifFalse:[
        aStream nextPutAll:'MeasurementValue value:'.
        value storeOn:aStream.
        aStream nextPutAll:' minValue:'.
        minValue storeOn:aStream.
        aStream nextPutAll:' maxValue:'.
        maxValue storeOn:aStream.
    ].
    ')' printOn:aStream.

    "
     (5 +/- 1) storeString 
     (MeasurementValue value:5 minValue:3 maxValue:8) storeString 
    "
! !

!MeasurementValue methodsFor:'private accessing'!

value:valueArg error:errorFraction 
    self 
        value:valueArg
        minValue:(valueArg * (1-errorFraction))
        maxValue:(valueArg * (1+errorFraction)). 
!

value:valueArg minValue:minValueArg maxValue:maxValueArg 
    value := valueArg.
    minValue := minValueArg.
    maxValue := maxValueArg.
! !

!MeasurementValue methodsFor:'queries'!

error
    "the relative error.
     If the error is different in the min/max direction, the larger error is returned here"

    ^ self errorHigh max:(self errorLow)

    "
     (MeasurementValue value:10 error:0.2) errorLow 
     (MeasurementValue value:10 error:0.2) errorHigh 
     (MeasurementValue value:10 error:0.2) error 
    "
!

errorHigh
    "the relative error on the max side"

    ^ (value - maxValue) abs / value

    "
     (MeasurementValue value:10 error:0.2) errorLow  
     (MeasurementValue value:10 error:0.2) errorHigh 
     (MeasurementValue value:10 error:0.2) error     
     (MeasurementValue value:20 error:0.2) errorLow   
     (MeasurementValue value:20 minValue:1 maxValue:100) errorLow   
     (MeasurementValue value:20 minValue:1 maxValue:100) errorHigh  
     (MeasurementValue value:20 minValue:1 maxValue:100) error  
    "
!

errorLow
    "the relative error on the min side"

    ^ (value - minValue) abs / value

    "
     (MeasurementValue value:10 error:0.2) errorLow  
     (MeasurementValue value:10 error:0.2) errorHigh 
     (MeasurementValue value:10 error:0.2) error     
     (MeasurementValue value:20 error:0.2) errorLow   
     (MeasurementValue value:20 minValue:1 maxValue:100) errorLow   
     (MeasurementValue value:20 minValue:1 maxValue:100) errorHigh  
     (MeasurementValue value:20 minValue:1 maxValue:100) error  
    "
! !

!MeasurementValue methodsFor:'testing'!

between:min and:max
    minValue < min ifTrue:[^ false].
    maxValue > max ifTrue:[^ false].
    ^ true
! !

!MeasurementValue class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

