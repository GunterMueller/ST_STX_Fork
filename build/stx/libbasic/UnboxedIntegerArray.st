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

AbstractNumberVector subclass:#UnboxedIntegerArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!UnboxedIntegerArray class methodsFor:'documentation'!

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
    An abstract superclass for all unboxed integer classes.
    In contrast to normal arrays (which store pointers to their elements),
    unboxedIntegerArrays store the values in a dense & compact way. 
    Since the representation fits corresponding underlying C-language representations,
    these are also useful to pass bulk data to c primitive code.

    [see also:]
        ByteArray WordArray BooleanArray FloatArray DoubleArray Array
        IntegerArray LongIntegerArray SignedLongIntegerArray

    [author:]
        Claus Gittinger
"
! !

!UnboxedIntegerArray class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned for UnboxedIntegerArray here; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == UnboxedIntegerArray
!

maxVal
    "the maximum value which can be stored in instances of me"
    
    ^ self subclassResponsibility.
!

minVal
    "the minimum value which can be stored in instances of me"
    
    ^ self subclassResponsibility.
! !

!UnboxedIntegerArray methodsFor:'printing'!

printOn:aStream base:radix showRadix:showRadix
    "append a printed representation to aStream in the given number base."

    (self class == WordArray or:[self class == LongIntegerArray]) 
    ifTrue:[    "/ care for subclasses
        aStream nextPutAll:'#('.
        self 
            do:[:word | word printOn:aStream base:radix showRadix:showRadix]
            separatedBy:[aStream space].
        aStream nextPut:$).
        ^ self
    ].
    ^ self printOn:aStream
! !

!UnboxedIntegerArray methodsFor:'queries'!

defaultElement
    ^ 0
!

isValidElement:anObject
    "return true, if I can hold this kind of object"

    ^ anObject isInteger
    and:[ (anObject >= self class minVal)
    and:[ (anObject <= self class maxVal) ]]
! !

!UnboxedIntegerArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

