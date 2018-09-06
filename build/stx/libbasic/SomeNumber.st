"
 COPYRIGHT (c) 2003 by eXept Software AG
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

MetaNumber subclass:#SomeNumber
	instanceVariableNames:'realNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!SomeNumber class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Only used internally during double dispatch, 
    when MetaNumbers (INF and NAN) are involved.

    [author:]
        Claus Gittinger

    [see also:]
        Number Infinity NotANumber
        Float ShortFloat Fraction FixedPoint Integer Complex
        FloatArray DoubleArray                                                                         
"
! !

!SomeNumber methodsFor:'arithmetic'!

* something
    "return the product of the receiver and the argument"

    ^ something productFromSomeNumber:self
!

+ something
    "return the sum of the receiver and the argument"

    ^ something sumFromSomeNumber:self
!

- something
    "return the difference of the receiver and the argument"

    ^ something differenceFromSomeNumber:self
!

/ something
    "return the quotient of the receiver and the argument"

    ^ something quotientFromSomeNumber:self
!

< something
    "return true if the receiver is less than the argument"

    ^ something lessFromSomeNumber:self
!

= something
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise."

    ^ something equalFromSomeNumber:self

    "
        Float infinity = Infinity positive
        Infinity positive = Float infinity 
        Float negativeInfinity = Infinity negative
        Infinity negative = Float negativeInfinity 
        Float negativeInfinity = Infinity positive
        Infinity positive = Float negativeInfinity 
    "
! !

!SomeNumber methodsFor:'printing'!

printOn:aStream
    realNumber printOn:aStream.
! !

!SomeNumber methodsFor:'private-accessing'!

realNumber
    ^ realNumber
!

realNumber:something
    realNumber := something.
! !

!SomeNumber methodsFor:'queries'!

isInfinite
    ^ realNumber isInfinite
!

sign
    "return the sign of the receiver (-1, 0 or 1)"

    ^ realNumber sign
! !

!SomeNumber class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

