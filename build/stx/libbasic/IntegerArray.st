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

UnboxedIntegerArray variableLongSubclass:#IntegerArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!IntegerArray class methodsFor:'documentation'!

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
    IntegerArrays store integers in the range 0..16rFFFFFFFF.
    In contrast to normal arrays (which store pointers to their elements),
    integerArrays store the values in a dense & compact way. 
    Since the representation fits the underlying C-language systems representation
    of unsigned int32's, this is also useful to pass bulk data to c primitive code.

    [memory requirements:]
        OBJ-HEADER + (size * 4)

    [see also:]
        ByteArray BooleanArray FloatArray DoubleArray Array
        SignedWordArray WordArray

    [author:]
        Claus Gittinger
"
! !

!IntegerArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 4 is returned"

    ^ 4

    "Created: / 15-09-2011 / 14:12:15 / cg"
!

maxVal
    "the maximum value which can be stored in instances of me"

    ^ 16rFFFFFFFF
!

minVal
    "the minimum value which can be stored in instances of me"

    ^ 0
! !

!IntegerArray methodsFor:'accessing'!

unsignedInt32At:index MSB:msb
    "return the 4-bytes starting at index as an (unsigned) Integer.
     The index is a smalltalk index (i.e. 1-based).
     The value is retrieved MSB (high 8 bits at lower index) if msb is true;
     LSB-first (i.e. low 8-bits at lower byte index) if its false.
     Notice: 
        the index is a byte index; thus, this allows for unaligned access to
        words on any boundary.
     Question: should it be retrieve signed values ? (see ByteArray>>signedWordAt:)"

    |w|

    (index bitAnd: 16r03) == 1 ifTrue:[
        "/ aligned fetch
        w := self at:(index // 4) + 1.
        (msb ~~ UninterpretedBytes isBigEndian) ifTrue:[
            w := w swapBytes
        ].    
        ^ w
    ].
    ^ super unsignedInt32At:index MSB:msb

    "
     #(16r0201 16r0403 16r0605) asIntegerArray unsignedInt32At:1 MSB:false 
     #(16r0201 16r0403 16r0605) asIntegerArray unsignedInt32At:5 MSB:false
     #(16r0201 16r0403 16r0605) asIntegerArray unsignedInt32At:9 MSB:false

     #(16r0201 16r0403 16r0605) asIntegerArray unsignedInt32At:2 MSB:false
     #(16r0201 16r0403 16r0605) asIntegerArray unsignedInt32At:3 MSB:false
     #(16r0201 16r0403 16r0605) asIntegerArray unsignedInt32At:4 MSB:false

     #(16rFFEE 16r0403 16r0605) asIntegerArray unsignedInt32At:1 MSB:false
     #(16rFFEE 16r0403 16r0605) asIntegerArray unsignedInt32At:1 MSB:true
    "
! !

!IntegerArray methodsFor:'comparing'!

< anIntegerArray
    "Compare the receiver with the argument and return true if the
     receiver is greater than the argument. Otherwise return false.

     Redefined for speed (xpath handling)"

%{  /* NOCONTEXT */

    int len1, len2, min, i;
    REGISTER OBJ s = anIntegerArray;
    unsigned int *ip1, *ip2;
    OBJ cls;
    OBJ myCls;

    if (__isNonNilObject(s)) {
        cls = __qClass(s);
        myCls = __qClass(self);

        if ((cls == IntegerArray) || (cls == myCls)) {
            ip2 = __integerArrayVal(s);
            len2 = __integerArraySize(s);
            /*
             * care for instances of subclasses ...
             */
            if (cls != IntegerArray) {
                int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars)) / sizeof(__integerArrayVal(s));

                ip2 += n;
                len2 -= n;
            }

            ip1 = __integerArrayVal(self);
            len1 = __integerArraySize(self);
            /*
             * care for instances of subclasses ...
             */
            if (myCls != IntegerArray) {
                int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(myCls)->c_ninstvars)) / sizeof(__integerArrayVal(s));

                ip1 += n;
                len1 -= n;
            }

            if (len1 <= len2)
                min = len1;
            else
                min = len2;

            for (i = 0; i < min; i++) {
                if (ip1[i] < ip2[i]) {
                    RETURN(true)
                }
                if (ip1[i] > ip2[i]) {
                    RETURN(false)
                }
            }

            if (len1 < len2) {
                RETURN ( true );
            }
            RETURN ( false );
        }
    }
%}.
    ^ super < anIntegerArray


    "
        (IntegerArray newFrom:#[1 2 3 4 5]) < (IntegerArray newFrom:#[1 2 3 4 5])
        (IntegerArray newFrom:#[1 2 3 4 5]) < (IntegerArray newFrom:#[1 2 3 4])
        (IntegerArray newFrom:#[1 2 3 4]) < (IntegerArray newFrom:#[1 2 3 4 5])
        (IntegerArray newFrom:#[1 2 3 4 5]) < (IntegerArray newFrom:#[1 2 3 4 6])
        (IntegerArray newFrom:#[]) < (IntegerArray newFrom:#[1 2 3 4 6])
    "
! !

!IntegerArray methodsFor:'converting'!

asIntegerArray
    "return a new IntegerArray with the collection's elements.
     That's the receiver itself here"

    ^ self.
! !

!IntegerArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

