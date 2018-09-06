"
 COPYRIGHT (c) 1997 by eXept Software AG
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

UnboxedIntegerArray variableSignedLongSubclass:#SignedIntegerArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!SignedIntegerArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    SignedIntegerArrays store 32bit signed integers in the range -16r80000000..16r7FFFFFFF.
    In contrast to normal arrays (which store pointers to their elements),
    signedIntegerArrays store the values in a dense & compact way. 
    Since the representation fits the underlying C-language systems representation
    of signed int32's, this is also useful to pass bulk data to c primitive code.

    [memory requirements:]
        OBJ-HEADER + (size * 4)

    [see also:]
        ByteArray BooleanArray FloatArray DoubleArray Array
        SignedWordArray WordArray IntegerArray LongIntegerArray
        SignedLongIntegerArray

    [author:]
        Claus Gittinger
"
! !

!SignedIntegerArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 4 is returned"

    ^ 4

    "Created: / 15-09-2011 / 14:11:46 / cg"
!

maxVal
    "the maximum value which can be stored in instances of me.
     For SignedIntegerArrays, this is 2147483647, eg. 16r7FFFFFFF (largest 32bit signed int)"

    ^ 16r7FFFFFFF
!

minVal
    "the minimum value which can be stored in instances of me.
     For SignedIntegerArrays, this is -2147483648 eg. -16r80000000 (smallest 32bit signed int)"

    ^ -16r80000000
! !

!SignedIntegerArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

