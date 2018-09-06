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

MetaNumber subclass:#NotANumber
	instanceVariableNames:''
	classVariableNames:'NaN'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!NotANumber class methodsFor:'documentation'!

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
    Represents the two metaNumbers +INF and -INF for non-float classes.

    [author:]
        Claus Gittinger

    [see also:]
        Number Infinity NotANumber
        Float ShortFloat Fraction FixedPoint Integer Complex
        FloatArray DoubleArray                                                                         
"
! !

!NotANumber class methodsFor:'instance creation'!

new
    ^ NaN
! !

!NotANumber class methodsFor:'class initialization'!

initialize
    NaN := self basicNew

    "
     self initialize
    "
! !

!NotANumber methodsFor:'arithmetic'!

* aNumber
    "Multiply the receiver and the argument and answer with the result."

    ^ self
!

+ aNumber
    "Add the receiver and the argument and answer with the result."

    ^ self
!

- aNumber
    "Subtract the argument from the receiver and answer with the result."

    ^ self
!

/ aNumber
    "Divide the receiver by the argument and answer with the result."

    ^ self
! !

!NotANumber methodsFor:'comparing'!

= something
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise."

    something respondsToArithmetic ifTrue:[ ^ something isNaN ].
    ^ false.
! !

!NotANumber methodsFor:'double dispatching'!

differenceFromSomeNumber:aNumber
    "sent from aNumber-self, if aNumber does not know how to handle this"

    ^ self
!

lessFromSomeNumber:aNumber
    "sent from aNumber < self, if aNumber does not know how to handle this"

    ^ Number
        raise: #undefinedResultSignal
        receiver: self
        selector: #lessFromSomeNumber:
        errorString: 'Cannot compare against NaN'
!

productFromSomeNumber:aNumber
    "sent from aNumber*self, if aNumber does not know how to handle this"

    ^ self
!

quotientFromSomeNumber:aNumber
    "Return the quotient of the argument, aNumber and the receiver.
     Sent when aNumber does not know how to divide by the receiver."

    ^ self
!

sumFromSomeNumber:aNumber
    "sent from aNumber+self, if aNumber does not know how to handle this"

    ^ self
! !

!NotANumber methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'NAN'
! !

!NotANumber methodsFor:'testing'!

isFinite
    ^ false
!

isNaN
    ^ true
! !

!NotANumber class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/NotANumber.st,v 1.2 2003/07/02 09:52:32 cg Exp $'
! !

NotANumber initialize!



