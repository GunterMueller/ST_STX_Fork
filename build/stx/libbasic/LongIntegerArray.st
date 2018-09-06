"
 COPYRIGHT (c) 1998 by Claus Gittinger / eXept Software AG
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

UnboxedIntegerArray variableLongLongSubclass:#LongIntegerArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!LongIntegerArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by Claus Gittinger / eXept Software AG
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
    LongIntegerArrays store 64bit unsigned integers in the range 
    0..16rFFFFFFFFFFFFFFFF.
    In contrast to normal arrays (which store pointers to their elements),
    longIntegerArrays store the values in a dense & compact way. 
    Since the representation fits the underlying C-language systems representation
    of unsigned longlong's, this is also useful to pass bulk data to c primitive code.
    (the system makes certain, that the first longlong is aligned as required)

    [memory requirements:]
        OBJ-HEADER + (size * 8)

    [see also:]
        ByteArray BooleanArray FloatArray DoubleArray Array
        WordArray SignedWordArray IntegerArray SignedIntegerArray
        SignedLongIntegerArray

    [author:]
        Claus Gittinger
"
! !

!LongIntegerArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 8 is returned"

    ^ 8

    "Created: / 15-09-2011 / 14:11:59 / cg"
!

maxVal
    "the maximum value which can be stored in instances of me.
     For LongIntegerArrays, this is 18446744073709551615 eg. 16rFFFFFFFFFFFFFFFF 
     (largest 64bit unsigned int)"

    ^ 16rFFFFFFFFFFFFFFFF
!

minVal
    "the minimum value which can be stored in instances of me.
     For LongIntegerArrays, this is 0"

    ^ 0
! !

!LongIntegerArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

