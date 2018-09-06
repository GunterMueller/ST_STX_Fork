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

UnboxedIntegerArray variableSignedLongLongSubclass:#SignedLongIntegerArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!SignedLongIntegerArray class methodsFor:'documentation'!

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
    SignedLongIntegerArrays store 64bit signed integers in the range 
    -16r8000000000000000..16r7FFFFFFFFFFFFFFF.
    In contrast to normal arrays (which store pointers to their elements),
    signedLongIntegerArrays store the values in a dense & compact way. 
    Since the representation fits the underlying C-language systems representation
    of signed longlong's, this is also useful to pass bulk data to c primitive code.
    (the system makes certain, that the first longlong is aligned as required)

    [memory requirements:]
        OBJ-HEADER + (size * 8)

    [see also:]
        ByteArray BooleanArray FloatArray DoubleArray Array
        WordArray SignedWordArray IntegerArray SignedIntegerArray
        LongIntegerArray

    [author:]
        Claus Gittinger
"
! !

!SignedLongIntegerArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 8 is returned"

    ^ 8

    "Created: / 15-09-2011 / 14:11:31 / cg"
!

maxVal
    "the maximum value which can be stored in instances of me.
     For SignedLongIntegerArrays, this is 9223372036854775807 eg. 16r7FFFFFFFFFFFFFFF 
     (largest 64bit signed int)"

    ^ 16r7FFFFFFFFFFFFFFF
!

minVal
    "the minimum value which can be stored in instances of me.
     For SignedLongIntegerArrays, this is -9223372036854775808 eg. -16r8000000000000000 
     (smallest 64bit signed int)"

    ^ -16r8000000000000000
! !

!SignedLongIntegerArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

