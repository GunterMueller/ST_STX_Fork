"
 COPYRIGHT (c) 2016 by eXept Sofware AG
 COPYRIGHT (c) 2018 Jan Vrany
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

ByteArray variableByteSubclass:#SignedByteArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!SignedByteArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Sofware AG
 COPYRIGHT (c) 2018 Jan Vrany
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
    Instances of this class hold signed bytes in the range -128 ... +127.

    [author:]
        Stefan Vogel

    [see also:]
        ByteArray
"
! !

!SignedByteArray class methodsFor:'queries'!

maxVal
    "the maximum value which can be stored in instances of me.
     For SignedByteArrays, this is 127 (largest 8bit signed int)"

    ^ 127
!

minVal
    "the minimum value which can be stored in instances of me.
     For SignedByteArrays, this is -128 (smallest 8bit signed int)"

    ^ -128
! !

!SignedByteArray methodsFor:'accessing'!

basicAt:index
    "return the indexed instance variable with index, anInteger
     - redefined here to return a signed interger."

%{  /* NOCONTEXT */

    REGISTER INT indx;
    REGISTER OBJ slf;
    REGISTER OBJ cls;
    REGISTER INT nIndex;

    if (__isSmallInteger(index)) {
        indx = __intVal(index) - 1;
        slf = self;
        if ((cls = __qClass(slf)) != @global(SignedByteArray)) {
            if (((INT)__ClassInstPtr(cls)->c_flags & __MASKSMALLINT(ARRAYMASK))
                != __MASKSMALLINT(BYTEARRAY)) {
                goto fail;
            }
            if (indx < 0) goto fail;
            indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
        }
        nIndex = __byteArraySize(slf);
        if ((unsigned INT)indx < (unsigned INT)nIndex) {
            int byte = ((signed char *)__ByteArrayInstPtr(slf)->ba_element)[indx];
            RETURN ( __mkSmallInteger(byte));
        }
    }
  fail: ;
%}.
    ^ super basicAt:index

    "
        #[0 1 2 3 127 128 254 255] copy changeClassTo:self
    "
!

basicAt:index put:value
    "set the indexed instance variable with index, anInteger to value.
     Returns value (sigh).
     - redefined here to allow value to be a signed integer"

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    int val;
    REGISTER OBJ slf;
    REGISTER OBJ cls;

    if (__bothSmallInteger(index, value)) {
        val = __intVal(value);
        if ((val >= -128) && (val <= 127)) {
            indx = __intVal(index) - 1;
            slf = self;
            if ((cls = __qClass(slf)) != @global(SignedByteArray)) {
                if (((INT)__ClassInstPtr(cls)->c_flags & __MASKSMALLINT(ARRAYMASK))
                    != __MASKSMALLINT(BYTEARRAY)) {
                    goto fail;
                }
                if (indx < 0) goto fail;
                indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
            }
            nIndex = __byteArraySize(slf);
            if ((unsigned INT)indx < (unsigned INT)nIndex) {
                __ByteArrayInstPtr(slf)->ba_element[indx] = val;
                RETURN ( value );
            }
        }
    }
  fail: ;
%}.
    ^ super basicAt:index put:value

    "
       (self new:5) basicAt:1 put:-1; yourself
    "

    "Modified: 19.4.1996 / 11:14:40 / cg"
! !

!SignedByteArray methodsFor:'converting'!

asSignedByteArray
    ^ self.
!

asUnsignedByteArray
    "Answer a unsigned byte array.
     elements < 0 are converted to positive numbers."

    self class == SignedByteArray ifTrue:[
        self copy changeClassTo:ByteArray.
    ] ifFalse:[
        self shouldNotImplement.
    ].

    "
        #(-1 -128 3 4) asSignedByteArray asUnsignedByteArray
    "
!

beSigned
    "that's what I am"

    ^ self.
!

beUnsigned
    "make myself unsigned.
     elements < 0 are converted to positive numbers."

    self class == SignedByteArray ifTrue:[
        self changeClassTo:ByteArray.
    ] ifFalse:[
        self shouldNotImplement.
    ].

    "
        #(-1 -128 3 4) asSignedByteArray beUnsigned
    "
! !

!SignedByteArray methodsFor:'filling & replacing'!

from:start to:stop put:aNumber
    "fill part of the receiver with aNumber.
     - reimplemented here for speed"

%{  /* NOCONTEXT */

    REGISTER unsigned char *dstp;
    REGISTER int count, value;
    int len, index1, index2;
    OBJ cls;

    if (__isSmallInteger(aNumber)
     && __bothSmallInteger(start, stop)
     && __isBytes(self)) {
        len = __byteArraySize(self);
        index1 = __intVal(start);
        index2 = __intVal(stop);

        dstp = __ByteArrayInstPtr(self)->ba_element + index1 - 1;
        if ((cls = __qClass(self)) != @global(SignedByteArray)) {
            int nInst;

            nInst = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
            dstp += nInst;
            len -= nInst;
        }

        value = __intVal(aNumber);
        if ((value >= -128) && (value <= 127)
         && (index1 <= index2)
         && (index1 > 0)) {
            if (index2 <= len) {
                count = index2 - index1 + 1;

#ifdef memset4
                if (count > 20) {
                    /* fill unaligned part */
                    while (((unsigned INT)dstp & 3) != 0) {
                        *dstp++ = (unsigned char)value;
                        count--;
                    }
                    /* fill aligned part */
                    {
                        unsigned int n4 = count & ~3;
                        unsigned int v4, nW;

                        v4 = ((unsigned char)value << 8) | (unsigned char)value;
                        v4 = (v4 << 16) | v4;
                        nW = n4>>2;
                        memset4(dstp, v4, nW);
                        count -= n4;
                        dstp += n4;
                    }
                    while (count--) {
                        *dstp++ = (unsigned char)value;
                    }
                    RETURN (self);
                }
#endif /* memset4 */

#if (__POINTER_SIZE__ == 8)
                {
                    unsigned INT v8;

                    v8 = ((unsigned char)value << 8) | (unsigned char)value;
                    v8 = (v8 << 16) | v8;
                    v8 = (v8 << 32) | v8;

                    /* fill unaligned part */
                    while ((count > 0) && (((unsigned INT)dstp & 3) != 0)) {
                        *dstp++ = (unsigned char)value;
                        count--;
                    }

                    if ((count >= 4) && (((unsigned INT)dstp & 7) != 0)) {
                        ((unsigned int *)dstp)[0] = v8;
                        dstp += 4;
                        count -= 4;
                    }

                    /* fill aligned part */
                    while (count >= 8) {
                        ((unsigned INT *)dstp)[0] = v8;
                        dstp += 8;
                        count -= 8;
                    }

                    /* fill rest */
                    if (count >= 4) {
                        ((unsigned int *)dstp)[0] = v8;
                        dstp += 4;
                        count -= 4;
                    }
                    if (count >= 2) {
                        ((unsigned short *)dstp)[0] = v8;
                        dstp += 2;
                        count -= 2;
                    }
                    if (count) {
                        *dstp = (unsigned char)value;
                    }
                    RETURN (self);
                }
#endif /* 64bit */

#ifdef FAST_MEMSET
                memset(dstp, value, count);
#else
# ifdef __UNROLL_LOOPS__
                while (count >= 8) {
                    dstp[0] = dstp[1] = dstp[2] = dstp[3] =
                    dstp[4] = dstp[5] = dstp[6] = dstp[7] = (unsigned char)value;
                    dstp += 8;
                    count -= 8;
                }
# endif /* __UNROLL_LOOPS__ */
                while (count--) {
                    *dstp++ = (unsigned char)value;
                }
#endif
                RETURN (self);
            }
        }
    }
%}.
    "
     fall back in case of non-integer index or out-of-bound index/value;
     will eventually lead to an out-of-bound signal raise
    "
    ^ super from:start to:stop put:aNumber

    "
     (self new:10) from:1 to:10 put:-5
     (self new:20) from:10 to:20 put:-5
     (self new:20) from:1 to:10 put:-5
    "
! !

!SignedByteArray methodsFor:'queries'!

max
    "return the maximum value in the receiver -
     redefined to speedup image processing and sound-player
     (which need a fast method for this on byteArrays)"

%{  /* NOCONTEXT */

    signed char *cp;
    int index, max, len;

    if (__qClass(self) == @global(SignedByteArray)) {
        max = -128;
        index = 0;
        len = __qSize(self) - OHDR_SIZE;
        if (len > 0) {
            for (cp = __ByteArrayInstPtr(self)->ba_element; ++index <= len; cp++) {
                int byte = *cp;

                if (byte > max) {
                    max = byte;
                    if (byte == 127) break;
                }
            }
            RETURN ( __mkSmallInteger(max) );
        }
    }
%}.
    ^ super max

    "
     #[1 2 3 -11 2 3 1 2 19] max
     #(-1 -2 -3 -4) asSignedByteArray max
     #() asSignedByteArray max
     #[] max   
     #() max   
    "
! !

!SignedByteArray methodsFor:'searching'!

indexOf:aByte startingAt:start
    "return the index of the first occurrence of the argument, aByte
     in the receiver starting at start, anInteger; return 0 if not found.
     - reimplemented here for speed"

%{  /* NOCONTEXT */

    char *cp;
    INT index;
    int len;
    OBJ cls;

    if (__isSmallInteger(aByte) &&__isBytes(self)) {
        int byteValue = __intVal(aByte);

        if ((byteValue < -128) || (byteValue > 127)) {
            /*
             * searching for something which cannot be found
             */
            RETURN ( __mkSmallInteger(0) );
        }

        if (__isSmallInteger(start)) {
            index = __intVal(start);
            len = __byteArraySize(self);
            cp = __ByteArrayInstPtr(self)->ba_element;
            if ((cls = __qClass(self)) != @global(SignedByteArray)) {
                int nInst = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
                cp += nInst;
                len -= nInst;
            }
            cp += index - 1;
#ifdef __UNROLL_LOOPS__
            while ((index+4) < len) {
                if (cp[0] == byteValue) { RETURN ( __mkSmallInteger(index) ); }
                if (cp[1] == byteValue) { RETURN ( __mkSmallInteger(index+1) ); }
                if (cp[2] == byteValue) { RETURN ( __mkSmallInteger(index+2) ); }
                if (cp[3] == byteValue) { RETURN ( __mkSmallInteger(index+3) ); }
                index += 4;
                cp += 4;
            }
#endif
            while (index <= len) {
                if (*cp == byteValue) {
                    RETURN ( __mkSmallInteger(index) );
                }
                index++;
                cp++;
            }
            RETURN ( __mkSmallInteger(0) );
        }
    }
%}.
    ^ super indexOf:aByte startingAt:start

    "
     #(-1 2 3 -4 5 6 7 8 9 0 1 2 3 4 5) asSignedByteArray indexOf:0 startingAt:1
     #(-1 2 3 -4 5 6 7 8 9 0 1 2 3 4 5) asSignedByteArray indexOf:-4 startingAt:1
     #() asSignedByteArray indexOf:-4 startingAt:1  
     #() indexOf:-4 startingAt:1     
    "
! !

!SignedByteArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

