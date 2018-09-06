"
 COPYRIGHT (c) 2011 by Claus Gittinger
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

UninterpretedBytes subclass:#AbstractNumberVector
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!AbstractNumberVector class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by Claus Gittinger
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
    abstract superclass for all direct storing number vector classes
    (float, double, integer arrays)

    Mostly to share double dispatch code.

    [see also:]
        IntegerArray FloatArray DoubleArray
        ByteArray
        (and many others)
"
! !

!AbstractNumberVector methodsFor:'arithmetic'!

* anObject
    "return the product of the receiver and the argument.
     The argument may either be a scalar or another vector"

    ^ self clone *= anObject

    "
     #(1 2 3 4) asFloatArray * 3
     #(1 2 3 4) asFloatArray * #(1 2 3 4) asFloatArray
    "
!

+ anObject
    "return the sum of the receiver and the argument.
     The argument may either be a scalar or another vector"

    ^ self clone += anObject

    "
     #(1 2 3 4) asFloatArray + 3
     #(1 2 3 4) asFloatArray + #(1 2 3 4) asFloatArray
    "
!

- anObject
    "return the difference of the receiver and the argument.
     The argument may either be a scalar or another vector"

    ^ self clone -= anObject

    "
     #(1 2 3 4) asFloatArray - 3
     #(1 2 3 4) asFloatArray - #(1 2 3 4) asFloatArray
    "

    "Created: / 30-05-2007 / 17:41:46 / cg"
!

/ anObject
    "return the division of the receiver and the argument.
     The argument may either be a scalar or another vector"

    ^ self clone /= anObject

    "
     #(1 2 3 4) asFloatArray / 3
     #(1 2 3 4) asFloatArray / #(1 2 3 4) asFloatArray
    "

    "Created: / 30-05-2007 / 17:46:05 / cg"
!

abs
    "return a new vector containing absolute values.
     The receiver is unchanged"

    ^ self clone primAbs

    "
     #( -1 2 -3 4 -5 6 -7 8) abs.
     #( -1 2 -3 4 -5 6 -7 8) asFloatArray abs. 
    "
!

negated
    "return a new vector containing negated values. 
     The receiver is unchanged"

    ^ self clone primNegated

    "
     #( -1 2 -3 4 -5 6 -7 8) negated.     
     #( -1 2 -3 4 -5 6 -7 8) asFloatArray negated. 
    "

    "Modified: / 30-05-2007 / 17:51:47 / cg"
! !

!AbstractNumberVector methodsFor:'arithmetic destructive'!

*= anObject
    "multiply the argument into the receiver (destructive).
     The argument may either be a scalar or another vector"

    ^ anObject isNumber
	    ifTrue:[self primMulScalar: anObject asFloat]
	    ifFalse:[self primMulArray: anObject]

    "
     |f|

     f := #(1 2 3 4) asFloatArray.
     f *= 3.
     f
    "
    "
     |f|

     f := #(1 2 3 4) asFloatArray.
     f *= #(1 2 3 4) asFloatArray.
     f
    "
!

+= anObject
    "add the argument into the receiver (destructive).
     The argument may either be a scalar or another vector"

    ^ anObject isNumber
	    ifTrue:[self primAddScalar: anObject asFloat]
	    ifFalse:[self primAddArray: anObject]

    "
     |f|

     f := #(1 2 3 4) asFloatArray.
     f += 3.
     f
    "
    "
     |f|

     f := #(1 2 3 4) asFloatArray.
     f += #(1 2 3 4) asFloatArray.
     f
    "
!

-= anObject
    "subtract the argument from the receiver (destructive).
     The argument may either be a scalar or another vector"

    ^ anObject isNumber
	    ifTrue:[self primSubtractScalar: anObject asFloat]
	    ifFalse:[self primSubtractArray: anObject]

    "
     |f|

     f := #(1 2 3 4) asFloatArray.
     f -= 3.
     f
    "
    "
     |f|

     f := #(1 2 3 4) asFloatArray.
     f += #(1 2 3 4) asFloatArray.
     f
    "

    "Created: / 30-05-2007 / 17:42:13 / cg"
!

/= anObject
    "divide the argument into the receiver (destructive).
     The argument may either be a scalar or another vector"

    ^ anObject isNumber
	    ifTrue:[self primDivScalar: anObject asFloat]
	    ifFalse:[self primDivArray: anObject]

    "Modified: / 30-05-2007 / 17:45:46 / cg"
! !

!AbstractNumberVector methodsFor:'destructive arithmetic support'!

primAbs
    "low performance fall back: destructive replace each element by its absolute value.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|
    
    sz := self size.
    1 to: sz do:[:i| self at:i put: (self at:i) abs].

    "
     |f|
     f := FloatArray withAll:#(-1 2 -3 4 -5).
     Transcript showCR:f.
     Transcript showCR:f abs.

     |i|
     i := SignedIntegerArray withAll:#(-1 2 -3 4 -5).
     Transcript showCR:i.
     Transcript showCR:i abs.
    "
!

primAddArray:anArray
    "low performance fallback: destructively add the vector argument into the receiver.
     The argument must be another vector.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to:sz do:[:i| self at:i put: (self at:i) + (anArray at:i)].

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f2 := FloatArray withAll:#(2 2 2 3 3).
     f1 += f2.
     f1
    "
!

primAddScalar: aScalar
    "low performance fallback: destructively add the scalar argument into the receiver.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to:sz do:[:i| self at:i put:(self at:i) + aScalar].
!

primDivArray: floatArray
    "low performance fallback: destructively divide the vector argument into the receiver.
     The argument must be another vector.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to: sz do:[:i| self at: i put: (self at: i) / (floatArray at: i)].

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f2 := FloatArray withAll:#(2 2 2 3 3).
     f1 /= f2.
     f1
    "
!

primDivScalar: aScalar
    "low performace fallback: destructively divide each element of the receiver 
     by the scalar argument.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to: sz do:[:i| self at: i put: (self at: i) / aScalar ].
!

primMulArray: floatArray
    "low performance fallback: destructively multiply the vector argument into the receiver.
     The argument must be another vector.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to: sz do:[:i| self at: i put: (self at: i) * (floatArray at: i)].

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f2 := FloatArray withAll:#(2 2 2 3 3).
     f1 *= f2.
     f1
    "
!

primMulScalar: aScalar
    "low performace fallback: destructively multiply each element of the receiver 
     by the scalar argument.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to: sz do:[:i| self at: i put: (self at: i) * aScalar ].
!

primNegated
    "low performance fallback: destructively negative value of each element.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to: sz do:[:i| self at: i put: (self at: i) negated].

    "
     |f|

     f := FloatArray withAll:#(-1 2 -3 4 -5).
     f negated.
     f
    "
!

primSubtractArray: floatArray
    "low performance fallback: destructively subtract the vector argument into the receiver.
     The argument must be another vector.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to: sz do:[:i| self at: i put: (self at: i) - (floatArray at: i)].

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f2 := FloatArray withAll:#(2 2 2 3 3).
     f1 -= f2.
     f1
    "
!

primSubtractScalar: aScalar
    "low performace fallback: destructively subtract the scalar argument 
     from each element of the receiver.
     May be redefined in subclasses to use vector instructions"

    |sz "{ Class: SmallInteger }"|

    sz := self size.
    1 to: sz do:[:i| self at: i put: (self at: i) - aScalar ].
! !

!AbstractNumberVector methodsFor:'queries'!

absMax
    "return the largest absolute value"

    |minMax|

    minMax := self minMax.
    ^ (minMax at:1) abs max:(minMax at:2) abs

    "
     |f1|

     f1 := (1 to:1000) asFloatArray.
     Time millisecondsToRun:[ 1000 timesRepeat:[ f1 absMax ] ]
    "

    "
     |f1|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f1 absMax
    "
    "
     |f1|

     f1 := FloatArray withAll:#(5 4 3 2 1).
     f1 absMax
    "
    "
     |f1|

     f1 := FloatArray withAll:#(5 -4 3 2 1).
     f1 absMax
    "
    "
     |f1|

     f1 := FloatArray withAll:#(5 -5 3 2 1).
     f1 absMax
    "
    "
     |f1|

     f1 := FloatArray withAll:#(5 -6 3 2 1).
     f1 absMax
    "
! !

!AbstractNumberVector methodsFor:'vector arithmetic'!

length
    <resource: #obsolete>
    "Return the length of the receiver interpreted as vector
     (that is the length of the vector from 0.0 @ 0.0 @ ... @ 0.0
      to the point in the n-dimensional space represented by the receiver).
     Obsolete: the name 'length' may lead to confusion.
               therefore renamed to vectorLength"

    self obsoleteMethodWarning:'use vectorLength'.
    ^ self squaredVectorLength sqrt

    "
     #(10.0 10.0) asFloatArray vectorLength
     #(10.0 10.0 10.0) asFloatArray vectorLength
    "
!

squaredLength
    <resource: #obsolete>
    "Return the squared length of the receiver interpreted as vector.
     Obsolete: the name 'squaredLength' may lead to confusion.
               therefore renamed to squaredVectorLength"

    self obsoleteMethodWarning:'use squaredVectorLength'.
    ^ self dot: self
! !

!AbstractNumberVector class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

