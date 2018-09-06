"
 COPYRIGHT (c) 1997 eXept Software AG
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

UnboxedIntegerArray variableSignedWordSubclass:#SignedWordArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!SignedWordArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 eXept Software AG
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
    SignedWordArrays store 16bit signed integers in the range -16r8000..16r7FFF.
    They are much like WordArrays, but the values stored are signed.
    In contrast to normal arrays (which store pointers to their elements),
    signedWordArrays store the values in a dense & compact way. 
    Since the representation fits the underlying C-language systems representation
    of signed int16's, this is also useful to pass bulk data to c primitive code.

    Therefore, SignedWordArrays can be used to hold bulk data in a more compact way.
        For example:
            Array new:100000 withAll:1
        requires 400k of object memory;

        in contrast,
            SignedWordArray new:100000 withAll:1
        only requires half of it.

    [memory requirements:]
        OBJ-HEADER + (size * 2)

    [see also:]
        ByteArray WordArray BooleanArray FloatArray DoubleArray Array
        IntegerArray LongIntegerArray SignedLongIntegerArray

    [author:]
        Claus Gittinger
"
! !

!SignedWordArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 2 is returned"

    ^ 2

    "Created: / 15-09-2011 / 14:11:18 / cg"
!

maxVal
    "the maximum value which can be stored in instances of me.
     For SignedWordArrays, this is 16r7FFF (largest 16bit signed int)"

    ^ 16r7FFF
!

minVal
    "the minimum value which can be stored in instances of me.
     For SignedWordArrays, this is -16r8000 (smallest 16bit signed int)"

    ^ -16r8000
! !

!SignedWordArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

