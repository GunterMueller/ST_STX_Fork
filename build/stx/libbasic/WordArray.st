"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

UnboxedIntegerArray variableWordSubclass:#WordArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!WordArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    WordArrays store integers in the range 0..16rFFFF.
    In contrast to normal arrays (which store pointers to their elements),
    wordArrays store the values in a dense & compact way. 
    Since the representation fits the underlying C-language systems representation
    of unsigned int16's, this is also useful to pass bulk data to c primitive code.

    WordArrays can be used to hold bulk integer data in a more compact way.
        For example:
            Array new:100000 withAll:1
        requires 400k of object memory;

        in contrast,
            WordArray new:100000 withAll:1
        only requires half of it.

    [memory requirements:]
        OBJ-HEADER + (size * 2)

    [see also:]
        ByteArray BooleanArray FloatArray DoubleArray Array
        SignedWordArray

    [author:]
        Claus Gittinger
"
! !

!WordArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 2 is returned"

    ^ 2

    "Created: / 15-09-2011 / 14:10:54 / cg"
!

maxVal
    "the maximum value which can be stored in instances of me.
     For WordArrays, this is 16rFFFF (largest 16bit unsigned int)"

    ^ 16rFFFF
!

minVal
    "the minimum value which can be stored in instances of me.
     For WordArrays, this is 0"

    ^ 0
! !

!WordArray methodsFor:'accessing'!

unsignedInt16At:index MSB:msb
    "return the 2-bytes starting at index as an (unsigned) Integer.
     The index is a smalltalk index (i.e. 1-based).
     The value is retrieved MSB (high 8 bits at lower index) if msb is true;
     LSB-first (i.e. low 8-bits at lower byte index) if its false.
     Notice: 
        the index is a byte index; thus, this allows for unaligned access to
        words on any boundary"

    |w|
    
    index odd ifTrue:[
        "/ aligned fetch
        w := self at:(index // 2) + 1.
        (msb ~~ UninterpretedBytes isBigEndian) ifTrue:[
            w := w swapBytes
        ].    
        ^ w
    ].
    ^ super unsignedInt16At:index MSB:msb

    "
     #(16r0201 16r0403 16r0605) asWordArray wordAt:1 MSB:false
     #(16r0201 16r0403 16r0605) asWordArray wordAt:3 MSB:false
     #(16r0201 16r0403 16r0605) asWordArray wordAt:5 MSB:false

     #(16r0201 16r0403 16r0605) asWordArray wordAt:2 MSB:false
     #(16r0201 16r0403 16r0605) asWordArray wordAt:4 MSB:false

     #(16rFFEE 16r0403 16r0605) asWordArray wordAt:1 MSB:false
     #(16rFFEE 16r0403 16r0605) asWordArray wordAt:1 MSB:true
    "
! !

!WordArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

