"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

UninterpretedBytes variableByteSubclass:#ByteArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!ByteArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    ByteArrays store integers in the range 0..255.
    In contrast to normal arrays (which store pointers to their elements),
    byteArrays store the values in a dense & compact way. 
    ByteArrays can be used to hold the data for bitmaps, images and other bulk data.
    ByteArrays are also used to store the bytecode-instructions of an
    interpreted method and are used as superclass for Strings.

    ByteArrays can be used as literals i.e. you can enter ByteArray-constants
    as #[ element1 element2 .... elementN] and also use byteArray constants
    as elements in a constant array.
    As in: #( #[1 1 1] #[2 2 2] #[3 3 3])

    If you have to communicate structure-data (in the C-sense) with external
    programs/data-bases, see a companion class (Structure).
    It allows the definition of subclasses of ByteArray, which transparently fetch
    and store C-structure fields.

    [memory requirements:]
        OBJ-HEADER + size

    [warning:]
        read the warning about 'growing fixed size collection'
        in ArrayedCollection's documentation

    [author:]
        Claus Gittinger

    [See also:]
        Array CharacterArray String
"
! !

!ByteArray class methodsFor:'instance creation'!

uninitializedNew:anInteger
    "return a new instance of the receiver with uninitialized
     (i.e. undefined) contents. The indexed elements have any random
     value. However, any named instance variables are still nilled.
     For use, when contents will be set anyway shortly after - this
     is a bit faster than the regular basicNew:, which clears the bytes.
     Of course, it only makes a difference for very big ByteArrays, such
     as used for images/bitmaps.

     Notice: if you want to port code using uninitializedNew: to another
     smalltalk, you have to add an 'uninitializedNew: -> basicNew:'-calling
     method to the ByteArray class of the other smalltalk."

%{  /* NOCONTEXT */
    OBJ newobj;
    INT instsize, nInstVars, nindexedinstvars;
    REGISTER OBJ *op;

    if (__isSmallInteger(anInteger)) {
	nindexedinstvars = __intVal(anInteger);
	if (nindexedinstvars >= 0) {
	    if (self == ByteArray) {
		/*
		 * the most common case
		 */
		instsize = OHDR_SIZE + nindexedinstvars;
		if (__CanDoQuickNew(instsize)) {        /* OBJECT ALLOCATION */
		    __qCheckedNew(newobj, instsize);
		    __InstPtr(newobj)->o_class = self;
		    __qSTORE(newobj, self);
		    RETURN (newobj );
		}
	    } else {
		/*
		 * Take care for subclasses like TwoByteString
		 */
		switch (__smallIntegerVal(__ClassInstPtr(self)->c_flags) & ARRAYMASK) {
		case BYTEARRAY:
		    break;

		case WORDARRAY:
		case SWORDARRAY:
		    nindexedinstvars *= 2;
		    break;

		case LONGARRAY:
		case SLONGARRAY:
		    nindexedinstvars *= 4;
		    break;

		default:
		    /* don't know about this array type, delegate to super */
		    goto out;
		}
	    }
	    nInstVars = __intVal(__ClassInstPtr(self)->c_ninstvars);
	    instsize = OHDR_SIZE + __OBJS2BYTES__(nInstVars) + nindexedinstvars;
	    __PROTECT_CONTEXT__
	    __qNew(newobj, instsize);   /* OBJECT ALLOCATION */
	    __UNPROTECT_CONTEXT__
	    if (newobj != nil) {
		__InstPtr(newobj)->o_class = self;
		__qSTORE(newobj, self);
		if (nInstVars) {
		    /*
		     * still have to nil out named instvars ...
		     */
#if defined(memset4) && defined(FAST_OBJECT_MEMSET4)
		    memset4(__InstPtr(newobj)->i_instvars, nil, nInstVars);
#else
# if defined(FAST_MEMSET) && !defined(NEGATIVE_ADDRESSES)
		    /*
		     * knowing that nil is 0
		     */
		    memset(__InstPtr(newobj)->i_instvars, 0, instsize - OHDR_SIZE);
# else
		    op = __InstPtr(newobj)->i_instvars;
		    while (nInstVars--)
			*op++ = nil;
# endif
#endif
		}
		RETURN ( newobj );
	    }
	}
    }
out:;
%}.
    ^ self basicNew:anInteger
! !


!ByteArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 1 is returned"

    ^ 1

    "Created: / 15-09-2011 / 14:12:53 / cg"
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == ByteArray

    "Modified: 23.4.1996 / 15:56:25 / cg"
!

maxVal
    "the minimum value which can be stored in instances of me.
     For ByteArrays, this is 255"

    ^ 255
!

minVal
    "the minimum value which can be stored in instances of me.
     For ByteArrays, this is 0"

    ^ 0
! !

!ByteArray methodsFor:'Compatibility-Squeak'!

bitXor:aByteArray
    "return a new byteArray containing the bitWise-xor of the receiver's and the
     argument's bytes"

    |size size1|

    "size := self size min:aByteArray size"
    size := self size.
    size1 := aByteArray size.
    size1 < size ifTrue:[
        size := size1.
    ].

    ^ self copy
        bitXorBytesFrom:1 to:size with:aByteArray startingAt:1;
        yourself.

    "
     #[0 1 2 3 4] bitXor:#[0 1 2 3 4]
     #[0 1 2 3 4] bitXor:#[0 1 2 3]
    "
! !

!ByteArray methodsFor:'accessing'!

basicAt:index
    "return the indexed instance variable with index, anInteger
     - redefined here to be slighly faster than the default in Object.
     Q: is it worth the extra code ?"

%{  /* NOCONTEXT */

    REGISTER INT indx;
    REGISTER OBJ slf;
    REGISTER OBJ cls;
    REGISTER INT nIndex;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	slf = self;
	if ((cls = __qClass(slf)) != @global(ByteArray)) {
	    if (((INT)__ClassInstPtr(cls)->c_flags & __MASKSMALLINT(ARRAYMASK))
		!= __MASKSMALLINT(BYTEARRAY)) {
		goto fail;
	    }
	    if (indx < 0) goto fail;
	    indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	}
	nIndex = __byteArraySize(slf);
	if ((unsigned INT)indx < (unsigned INT)nIndex) {
	    RETURN ( __mkSmallInteger((__ByteArrayInstPtr(slf)->ba_element[indx])) );
	}
    }
  fail: ;
%}.
    ^ super basicAt:index
!

basicAt:index put:value
    "set the indexed instance variable with index, anInteger to value.
     Returns value (sigh).
     - redefined here to be slighly faster than the default in Object.
     Q: is it worth the extra code ?"

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    int val;
    REGISTER OBJ slf;
    REGISTER OBJ cls;

    if (__bothSmallInteger(index, value)) {
	val = __intVal(value);
	if ((unsigned)(val) <= 0xFF /* i.e. (val >= 0) && (val <= 255) */) {
	    indx = __intVal(index) - 1;
	    slf = self;
	    if ((cls = __qClass(slf)) != @global(ByteArray)) {
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

    "Modified: 19.4.1996 / 11:14:40 / cg"
!

bitAt:index
    "return the bit at index (1 based index) as 0 or 1"

    |byteIndex bitIndex0 byte|

%{  /* NOCONTEXT */

    REGISTER INT indx;
    REGISTER int byte;
    unsigned INT nIndex;
    REGISTER OBJ slf;
    REGISTER OBJ cls;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	slf = self;

	byte = indx / 8;
	indx = indx % 8;

	if ((cls = __qClass(slf)) != @global(ByteArray)) {
	    if (indx < 0) goto badIndex;
	    byte += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	}
	nIndex = __byteArraySize(slf);
	if ((unsigned)byte < (unsigned INT)nIndex) {
	    RETURN ( __mkSmallInteger(((__ByteArrayInstPtr(slf)->ba_element[byte] & (1 << indx)) != 0)) );
	}
    }
badIndex: ;
%}.
    byteIndex := ((index-1) // 8) + 1.
    bitIndex0 := ((index-1) \\ 8).
    byte := self at:byteIndex.
    ^  byte bitTest:(1 bitShift:bitIndex0).

   "
     #[ 1 1 1 1 ] bitAt:9
     #[ 1 1 1 1 ] bitAt:11
     #[ 2 2 2 2 ] bitAt:10
   "
!

bitClearAt:index
    "clear the bit at index (index starts with 1)"

    |byteIndex bitIndex0 byte|

%{  /* NOCONTEXT */

    REGISTER INT indx;
    REGISTER int byte;
    unsigned INT nIndex;
    REGISTER OBJ slf;
    REGISTER OBJ cls;

    if (0 /* __isSmallInteger(index) */) {
	indx = __intVal(index) - 1;
	slf = self;

	byte = indx / 8;
	indx = indx % 8;

	if ((cls = __qClass(slf)) != @global(ByteArray)) {
	    if (indx < 0) goto badIndex;
	    byte += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	}
	nIndex = __byteArraySize(slf);
	if ((unsigned)byte < (unsigned INT)nIndex) {
	    __ByteArrayInstPtr(slf)->ba_element[byte] &= ~(1 << indx);
	    RETURN (slf);
	}
    }
badIndex: ;
%}.
    byteIndex := ((index-1) // 8) + 1.
    bitIndex0 := ((index-1) \\ 8).
    byte := self at:byteIndex.
    byte := byte bitClear:(1 bitShift:bitIndex0).
    self at:byteIndex put:byte.

    "
     #[0 0 0 0] copy bitClearAt:1
     #[0 0 0 0] copy bitClearAt:7
     #[0 0 0 0] copy bitClearAt:8
     #[0 0 0 0] copy bitClearAt:9
    "
   "
     #[ 0 0 0 0 ] bitSetAt:1
     #[ 0 0 0 0 ] bitSetAt:4
     #[ 0 0 0 0 ] bitSetAt:8
     #[ 0 0 0 0 ] bitSetAt:9
     #[ 0 0 0 0 ] bitSetAt:10
     #[ 0 0 0 0 ] bitSetAt:11
   "



!

bitSetAt:index
    "set the bit at index (index starts with 1)"

    |byteIndex bitIndex0 byte|

%{  /* NOCONTEXT */

    if (__isSmallInteger(index)
     && (__qClass(self) == @global(ByteArray))) {
        int indx;

        indx = __intVal(index) - 1;
        if (indx >= 0) {
            int byteIndex;
            int bitIndex;
            unsigned INT nIndex;

            byteIndex = indx / 8;
            bitIndex = indx % 8;

            nIndex = __byteArraySize(self);
            if ((unsigned)byteIndex < (unsigned INT)nIndex) {
                __ByteArrayInstPtr(self)->ba_element[byteIndex] |= (1 << bitIndex);
                RETURN (self);
            }
        }
    }
%}.
    byteIndex := ((index-1) // 8) + 1.
    bitIndex0 := ((index-1) \\ 8).
    byte := self at:byteIndex.
    byte := byte bitOr:(1 bitShift:bitIndex0).
    self at:byteIndex put:byte.

    "
     #[0 0 0 0] copy bitSetAt:1
     #[0 0 0 0] copy bitSetAt:7
     #[0 0 0 0] copy bitSetAt:8
     #[0 0 0 0] copy bitSetAt:9
     #[0 0 0 0] copy bitSetAt:32
     #[0 0 0 0] copy bitSetAt:33
     #[0 0 0 0] copy bitSetAt:0
    "
    "
     #[ 0 0 0 0 ] bitSetAt:1
     #[ 0 0 0 0 ] bitSetAt:4
     #[ 0 0 0 0 ] bitSetAt:8
     #[ 0 0 0 0 ] bitSetAt:9
     #[ 0 0 0 0 ] bitSetAt:10
     #[ 0 0 0 0 ] bitSetAt:11
   "
! !

!ByteArray methodsFor:'accessing-bytes'!

byteAt:index
    "return the byte at index.
     For ByteArray, this is the same as basicAt:;
     however, for strings or symbols, this returns a numeric byteValue
     instead of a character."

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    REGISTER OBJ slf;
    REGISTER OBJ cls;

    if (__isSmallInteger(index)) {
	indx = __intVal(index) - 1;
	slf = self;
	if ((cls = __qClass(slf)) != @global(ByteArray)) {
	    if (indx < 0) goto badIndex;
	    indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	}
	nIndex = __byteArraySize(slf);
	if ((unsigned INT)indx < (unsigned INT)nIndex) {
	    RETURN ( __mkSmallInteger((__ByteArrayInstPtr(slf)->ba_element[indx])) );
	}
    }
badIndex: ;
%}.
    ^ (super basicAt:index) asInteger
!

byteAt:index put:value
    "set the byte at index. For ByteArray, this is the same as basicAt:put:.
     However, for Strings, this expects a byteValue to be stored."

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    int val;
    REGISTER OBJ slf;
    REGISTER OBJ cls;

    if (__bothSmallInteger(index, value)) {
        val = __intVal(value);
        if ((unsigned)(val) <= 0xFF /* i.e. (val >= 0) && (val <= 255) */) {
            indx = __intVal(index) - 1;
            slf = self;
            if ((cls = __qClass(slf)) != ByteArray) {
                if (indx < 0) goto badIndex;
                if (cls == ImmutableByteArray) goto badIndex; 
                indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
            }
            nIndex = __byteArraySize(slf);
            if ((unsigned INT)indx < (unsigned INT)nIndex) {
                __ByteArrayInstPtr(slf)->ba_element[indx] = val;
                RETURN ( value );
            }
        }
    }
badIndex: ;
%}.
    ^ super basicAt:index put:value
! !

!ByteArray methodsFor:'accessing-longs'!

unsignedInt32At:index put:value
    "set the 4-bytes starting at index from the (unsigned) Integer value.
     The value should be in the range 0 to 16rFFFFFFFF
     (for negative values, the stored value is not defined).
     The value is stored in the machine's natural byte order.
     Q: should it store signed values ? (see ByteArray signedDoubleWordAt:put:)"

    |t|

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    union {
        unsigned char u_char[4];
        unsigned int u_uint;
    } val;
    OBJ cls;
    unsigned char *byteP;

    if (__isSmallInteger(index)) {
        if (__isSmallInteger(value)) {
            val.u_uint = __intVal(value);
        } else {
            val.u_uint = __longIntVal(value);
            if (val.u_uint == 0) goto error;
        }

        indx = __intVal(index);
        if (indx > 0) {
            if ((cls = __qClass(self)) != @global(ByteArray)) {
                if (cls == ImmutableByteArray) goto error;
                indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
            }
            nIndex = __qSize(self) - OHDR_SIZE;
            if ((indx+3) <= nIndex) {
                byteP = (unsigned char *)(__ByteArrayInstPtr(self)->ba_element) + indx - 1;
#if defined(__i386__) || defined(UNALIGNED_FETCH_OK)
                ((unsigned int *)byteP)[0] = val.u_uint;
#else
                if (((unsigned INT)byteP & 3) == 0) {
                    ((unsigned int *)byteP)[0] = val.u_uint;
                } else {
                    byteP[0] = val.u_char[0];
                    byteP[1] = val.u_char[1];
                    byteP[2] = val.u_char[2];
                    byteP[3] = val.u_char[3];
                }
#endif
                RETURN ( value );
            }
        }
    }
  error: ;
%}.
    ^ super unsignedInt32At:index put:value.

    "
     |b|
     b := ByteArray new:4.
     b unsignedInt32At:1 put:16r04030201.
     b inspect
    "
!

unsignedInt32At:index put:value MSB:msb
    "set the 4-bytes starting at index from the (unsigned) Integer value.
     The value must be in the range 0 to 16rFFFFFFFF.
     The value is stored MSB-first if msb is true; LSB-first otherwise.
     question: should it store signed values ? (see ByteArray signedDoubleWordAt:put:)"

    |t|

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    int val;
    OBJ cls;
    unsigned char *byteP;

    if (__isSmallInteger(index)) {
        if (__isSmallInteger(value)) {
            val = __intVal(value);
        } else {
            val = __longIntVal(value);
            if (val == 0) goto error;
        }
        indx = __intVal(index);
        if (indx > 0) {
            if ((cls = __qClass(self)) != @global(ByteArray)) {
                if (cls == ImmutableByteArray) goto error;
                indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
            }        
            nIndex = __qSize(self) - OHDR_SIZE;
            if ((indx+3) <= nIndex) {
                byteP = (unsigned char *)(__ByteArrayInstPtr(self)->ba_element) + indx - 1;
                if (msb == true) {
                    /*
                     * most significant byte first (i.e sparc order)
                     */
#if defined(__MSBFIRST__)
                    if (((INT)byteP & 3) == 0) {
                        ((int *)byteP)[0] = val;
                    } else
#endif
                    {
                        byteP[3] = val & 0xFF;
                        val >>= 8;
                        byteP[2] = val & 0xFF;
                        val >>= 8;
                        byteP[1] = val & 0xFF;
                        val >>= 8;
                        byteP[0] = val & 0xFF;
                    }
                } else {
                    /*
                     * least significant byte first (i.e i386/alpha order)
                     */
#if defined(__i386__) || (defined(__LSBFIRST__) && defined(UNALIGNED_FETCH_OK))
                    ((int *)byteP)[0] = val;
#else
# if defined(__LSBFIRST__)
                    if (((unsigned INT)byteP & 3) == 0) {
                        ((int *)byteP)[0] = val;
                    } else
# endif
                    {
                        byteP[0] = val & 0xFF;
                        val >>= 8;
                        byteP[1] = val & 0xFF;
                        val >>= 8;
                        byteP[2] = val & 0xFF;
                        val >>= 8;
                        byteP[3] = val & 0xFF;
                    }
#endif
                }
                RETURN ( value );
            }
        }
    }
  error: ;
%}.
    ^ super unsignedInt32At:index put:value MSB:msb

    "
     |b|
     b := ByteArray new:8.
     b unsignedInt32At:1 put:16r04030201 MSB:true.
     b unsignedInt32At:5 put:16r04030201 MSB:false.
     b inspect
    "
! !

!ByteArray methodsFor:'accessing-shorts'!

unsignedInt16At:index
    "return the 2-bytes starting at index as an (unsigned) Integer.
     The value is retrieved in the machine's natural byte order
     Notice: 
        the index is a byte index; thus, this allows for unaligned access to
        words on any boundary.
     Question: should it be retrieve signed values ? (see ByteArray>>signedWordAt:)"

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    union {
        unsigned char u_char[2];
        unsigned short u_ushort;
    } val;
    unsigned char *byteP;

    if (__isSmallInteger(index)) {
        indx = __intVal(index);
        if (indx > 0) {
            if (!__isByteArrayLike(self))
                indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
            nIndex = __byteArraySize(self);
            if ((indx+1) <= nIndex) {
                byteP = (unsigned char *)(__ByteArrayInstPtr(self)->ba_element) + indx - 1;
#if defined(__i386__) || defined(UNALIGNED_FETCH_OK)
                val.u_ushort = ((unsigned short *)byteP)[0];
#else
                val.u_char[0] = byteP[0];
                val.u_char[1] = byteP[1];
#endif
                RETURN ( __mkSmallInteger((val.u_ushort)) );
            }
        }
    }
%}.
    ^ super unsignedInt16At:index
!

unsignedInt16At:index MSB:msb
    "return the 2-bytes starting at index as an (unsigned) Integer.
     The value is retrieved MSB (high 8 bits at lower index) if msb is true;
     LSB-first (i.e. low 8-bits at lower byte index) if its false.
     Notice: 
        the index is a byte index; thus, this allows for unaligned access to
        words on any boundary.
     Question: should it be retrieve signed values ? (see ByteArray>>signedWordAt:)"

%{  /* NOCONTEXT */
    REGISTER INT indx;
    unsigned INT nIndex;
    int val;
    unsigned char *byteP;

    if (__isSmallInteger(index)) {
        indx = __intVal(index);
        if (indx > 0) {
            if (!__isByteArrayLike(self))
                indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
            nIndex = __byteArraySize(self);
            if ((indx+1) <= nIndex) {
                byteP = (unsigned char *)(__ByteArrayInstPtr(self)->ba_element) + indx - 1;
                if (msb == true) {
                    /*
                     * most significant byte first (i.e sparc order)
                     */
#if defined(__MSBFIRST__)
                    /*
                     * mhmh to be measured:
                     *   the if may hurt more than the additional
                     *   memory cycles on some machines ...
                     */
                    if (((INT)byteP & 1) == 0) {
                        /* aligned */
                        val = ((unsigned short *)byteP)[0];
                    } else
#endif
                    {
                        val = byteP[0];
                        val = (val << 8) + byteP[1];
                    }
                } else {
                    /*
                     * least significant byte first (i.e i386/alpha order)
                     */
#if defined(__i386__) || (defined(__LSBFIRST__) && defined(UNALIGNED_FETCH_OK))
                    val = ((unsigned short *)byteP)[0];
#else
# if defined(__LSBFIRST__)
                    /*
                     * mhmh to be measured:
                     *   the if may hurt more than the additional
                     *   memory cycles on some machines ...
                     */
                    if (((INT)byteP & 1) == 0) {
                        /* aligned */
                        val = ((unsigned short *)byteP)[0];
                    } else
# endif
                    {
                        val = byteP[1];
                        val = (val << 8) + byteP[0];
                    }
#endif
                }
                RETURN ( __mkSmallInteger(val) );
            }
        }
    }
%}.
    ^ super unsignedInt16At:index MSB:msb
!

unsignedInt16At:index put:value
    "set the 2-bytes starting at index from the (unsigned) Integer value.
     The stored value must be in the range 0 .. 16rFFFF.
     The value is stored in the machine's natural byteorder,
     i.e. this method should only be used to fill byteArrays which are
     used internally (not passed to other machines).
     Notice: 
        the index is a byte index; thus, this allows for unaligned access to
        words on any boundary.
     Question: should it accept signed values ? (see ByteArray>>signedWordAt:put:)"

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    int v;
    union {
        unsigned char u_char[2];
        unsigned short u_ushort;
    } val;
    unsigned char *byteP;

    if (__bothSmallInteger(index, value)) {
        indx = __intVal(index);
        if (indx > 0) {
            if (!__isByteArray(self)) {
                OBJ cls = __qClass(self);
                if (cls == ImmutableByteArray) goto immutable;
                indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
            }
            nIndex = __byteArraySize(self);
            if ((indx+1) <= nIndex) {
                v = __intVal(value);
                if ((v & ~0xFFFF) == 0 /* i.e. (val >= 0) && (val <= 0xFFFF) */) {
                    byteP = (unsigned char *)(__ByteArrayInstPtr(self)->ba_element) + indx - 1;
#if defined(__i386__) || defined(UNALIGNED_FETCH_OK)
                    ((unsigned short *)byteP)[0] = v;
#else
                    /*
                     * mhmh to be measured:
                     *   the if may hurt more than the additional
                     *   memory cycles on some machines ...
                     */
                    if (((INT)byteP & 1) == 0) {
                        /* aligned */
                        ((unsigned short *)byteP)[0] = v;
                    } else {
                        val.u_ushort = v;
                        byteP[0] = val.u_char[0];
                        byteP[1] = val.u_char[1];
                    }
#endif
                    RETURN ( value );
                }
            }
        }
    }
immutable: ;
%}.
    ^ self unsignedInt16At:index put:value MSB:IsBigEndian

    "
     |b|
     b := ByteArray new:4.
     b unsignedInt16At:1 put:16r0102.
     b unsignedInt16At:3 put:16r0304.
     b inspect
    "
!

unsignedInt16At:index put:value MSB:msb
    "set the 2-bytes starting at index from the (unsigned) Integer value.
     The stored value must be in the range 0 .. 16rFFFF.
     The value is stored LSB-first (i.e. the low 8bits are stored at the
     lower index) if msb is false, MSB-first otherwise.
     Notice: 
        the index is a byte index; thus, this allows for unaligned access to
        words on any boundary.
     Question: should it accept signed values ? (see ByteArray>>signedWordAt:put:)"

%{  /* NOCONTEXT */

    REGISTER INT indx;
    unsigned INT nIndex;
    int val;
    OBJ cls;
    unsigned char *byteP;

    if (__bothSmallInteger(index, value)) {
        indx = __intVal(index);
        if (indx > 0) {
            if (!__isByteArray(self)) {
                OBJ cls = __qClass(self);
                if (cls == ImmutableByteArray) goto immutable;
                indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
            }        
            nIndex = __byteArraySize(self);
            if ((indx+1) <= nIndex) {
                val = __intVal(value);
                if ((val & ~0xFFFF) == 0 /* i.e. (val >= 0) && (val <= 0xFFFF) */) {
                    byteP = (unsigned char *)(__ByteArrayInstPtr(self)->ba_element) + indx - 1;
                    if (msb == true) {
                        /*
                         * most significant byte first (i.e sparc order)
                         */
#if defined(__MSBFIRST__)
                        /*
                         * mhmh to be measured:
                         *   the if may hurt more than the additional
                         *   memory cycles on some machines ...
                         */
                        if (((INT)byteP & 1) == 0) {
                            /* aligned */
                            ((unsigned short *)byteP)[0] = val;
                        } else
#endif
                        {
                            byteP[1] = val & 0xFF;
                            byteP[0] = (val>>8) & 0xFF;
                        }
                    } else {
                        /*
                         * least significant byte first (i.e i386/alpha order)
                         */
#if defined(__i386__) || (defined(__LSBFIRST__) && defined(UNALIGNED_FETCH_OK))
                        ((unsigned short *)byteP)[0] = val;
#else
# if defined(__LSBFIRST__)
                        /*
                         * mhmh to be measured:
                         *   the if may hurt more than the additional
                         *   memory cycles on some machines ...
                         */
                        if (((INT)byteP & 1) == 0) {
                            /* aligned */
                            ((unsigned short *)byteP)[0] = val;
                        } else
# endif
                        {
                            byteP[0] = val & 0xFF;
                            byteP[1] = (val>>8) & 0xFF;
                        }
#endif
                    }
                    RETURN ( value );
                }
            }
        }
    }
immutable: ;
%}.
    ^ super unsignedInt16At:index put:value MSB:msb

    "
     |b|
     b := ByteArray new:8.
     b unsignedInt16At:1 put:16r0102 MSB:false.
     b unsignedInt16At:3 put:16r0304 MSB:false.
     b unsignedInt16At:5 put:16r0102 MSB:true.
     b unsignedInt16At:7 put:16r0304 MSB:true.
     b inspect
    "
! !


!ByteArray methodsFor:'comparing'!

= aByteArray
    "Compare the receiver with the argument and return true if the
     receiver is equal to the argument (i.e. has the same size and elements).
     Otherwise return false."

%{  /* NOCONTEXT */

    int l1, l2;
    REGISTER OBJ s = aByteArray;
    unsigned char *cp1, *cp2;
    OBJ cls;
    OBJ myCls;
    INT addrDelta;

    if (s == self) {
	RETURN ( true );
    }
    if (! __isNonNilObject(s)) {
	RETURN ( false );
    }

    cls = __qClass(s);
    myCls = __qClass(self);

    if (cls == myCls) {
	l2 = __byteArraySize(s);
	l1 = __byteArraySize(self);
	if (l1 != l2) {
	    RETURN ( false );
	}

	cp1 = __byteArrayVal(self);
	cp2 = __byteArrayVal(s);

	/*
	 * care for instances of subclasses ...
	 */
	if (cls != ByteArray) {
	    int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

	    cp2 += n;
	    cp1 += n;
	    l1 -= n;
	}

	addrDelta = cp2 - cp1;
	while (l1 >= (sizeof(unsigned INT) * 4)) {
	    if (((unsigned INT *)cp1)[0] != ((unsigned INT *)(cp1+addrDelta))[0]) {
		RETURN (false);
	    }
	    if (((unsigned INT *)cp1)[1] != ((unsigned INT *)(cp1+addrDelta))[1]) {
		RETURN (false);
	    }
	    if (((unsigned INT *)cp1)[2] != ((unsigned INT *)(cp1+addrDelta))[2]) {
		RETURN (false);
	    }
	    if (((unsigned INT *)cp1)[3] != ((unsigned INT *)(cp1+addrDelta))[3]) {
		RETURN (false);
	    }
	    l1 -= sizeof(unsigned INT)*4;
	    cp1 += sizeof(unsigned INT)*4;
	}
	while (l1 >= sizeof(unsigned INT)) {
	    if (*((unsigned INT *)cp1) != *((unsigned INT *)(cp1+addrDelta))) {
		RETURN (false);
	    }
	    l1 -= sizeof(unsigned INT);
	    cp1 += sizeof(unsigned INT);
	}
	if (l1 >= sizeof(unsigned short)) {
	    if (*((unsigned short *)cp1) != *((unsigned short *)(cp1+addrDelta))) {
		RETURN (false);
	    }
	    l1 -= sizeof(unsigned short);
	    cp1 += sizeof(unsigned short);
	}
	while (l1) {
	    if (*cp1 != *(cp1+addrDelta)) {
		RETURN (false);
	    }
	    l1--;
	    cp1++;
	}

	RETURN (true);
    }
%}.
    ^ super = aByteArray
! !

!ByteArray methodsFor:'converting'!

asByteArray
    "return the receiver as a byteArray"

    "could be an instance of a subclass..."
    self class == ByteArray ifTrue:[
	^ self
    ].
    ^ super asByteArray

    "
     'hello world' asByteArray
     #(1 2 3 4 5 6 7) asByteArray
     #(1 2 256 4 5 6 7) asByteArray
    "
!

asImmutableByteArray
    "return a write-protected copy of myself"

    |copy|

    copy := self copy.
    copy class == ByteArray ifTrue:[
        ^ copy changeClassTo:ImmutableByteArray.
    ] ifFalse:[
        ^ self shouldNotImplement.
    ].
!

asInteger
    "convert myself to an unsigned integer - the first byte is most significant.
     This is also in Squeak."

    ^ self asIntegerMSB:true

    "
        #[ 2 ] asInteger hexPrintString
        #[ 16r1 16r2 ] asInteger hexPrintString
        #[4 0 0 0 0 0 0 0] asInteger hexPrintString
    "
!

asIntegerMSB:isMSBFirst
    "convert myself to an unsigned integer - the first byte is most significant.
     This is also in Squeak."

    ^ (LargeInteger digitBytes:self MSB:isMSBFirst) compressed

    "
        (#[ 2 ] asIntegerMSB:true) hexPrintString
        (#[ 16r1 16r2 ] asIntegerMSB:true) hexPrintString
        (#[ 16r1 16r2 ] asIntegerMSB:false) hexPrintString
        (#[4 0 0 0 0 0 0 0 0 0 0 0] asIntegerMSB:true) hexPrintString
    "
!

asPackedString
    "ST-80 compatibility: encode the receiver into an ascii String
     with 6bits encoded per character. Each group of 6 bits is encoded
     as a corresponding character (32+value) and the resulting string
     is returned. The resulting string is always a multiple of 4 (since
     24 is the lcm of 6 and 8) and the number of remaining characters is
     encoded in the last character.
     ST-80 uses this encoding for Images...
     This is a base64 encoding, very similar (but not equal) to the algorithm used in RFC1421.
     PS: I don't like it ;-)
     See also: fromPackedString: - the reverse operation"

    |outStream
     index     "{ Class:SmallInteger}"
     nextIndex "{ Class:SmallInteger}"
     stop      "{ Class:SmallInteger}"
     n         "{ Class:SmallInteger}"
     mod       "{ Class:SmallInteger}"
     cpl|

    outStream := WriteStream on:(String new:((self size + 2) * 4 // 3)).
    index := 1.
    stop := self size.

    stop > 100 ifTrue:[
	"/ cg:
	"/ initial lineBreak
	outStream cr.
    ].
    cpl := 0.

    [index <= stop] whileTrue:[
	"take 3 source bytes"
	n := (self at:index) bitShift:16.
	(index < stop) ifTrue:[
	    nextIndex := index + 1.
	    n := n bitOr:((self at:nextIndex) bitShift:8).
	    (nextIndex < stop) ifTrue:[
		n := n bitOr:(self at:(index + 2)).
	    ].
	].
	index := index + 3.

	"took me a while to find that one out ..."
	n := n bitXor:16r820820.

	outStream nextPut:(Character value:((n bitShift:-18) bitAnd:16r3F) + 32).
	outStream nextPut:(Character value:((n bitShift:-12) bitAnd:16r3F) + 32).
	outStream nextPut:(Character value:((n bitShift:-6) bitAnd:16r3F) + 32).
	outStream nextPut:(Character value:(n bitAnd:16r3F) + 32).

	"/ cg:
	"/ lineBreak after every 120 characters
	"/ fromPackedString will ignore those
	cpl := cpl + 4.
	cpl >= 120 ifTrue:[
	    outStream cr.
	    cpl := 0.
	].
    ].
    (mod := stop \\ 3) ~~ 0 ifTrue:[
	outStream backStep.
	outStream nextPut:(Character value:(mod + 96)).
    ].
    ^ outStream contents

    "
     #[ 16r00 16r01 16r02 16r04 16r08 16r10 16r20 16r40 16r80 ] asPackedString
    "

    "Modified: 12.11.1996 / 15:45:02 / cg"
!

asSignedByteArray
    "return the receiver as a signed byteArray.
     elements > 127 are converted to negative numbers."

    |cls|

    cls := self class.
    "could be an instance of a subclass..."
    (cls == ByteArray or:[cls == ImmutableByteArray]) ifTrue:[
        ^ self copy changeClassTo:SignedByteArray.
    ].
    ^ super asSignedByteArray

    "
     'hello world' asSignedByteArray
     #[1 2 3 4 5 6 7] asSignedByteArray
     #[1 2 129 4 5 6 7] asSignedByteArray
    "
!

asString
    "speed up string conversions"

    |size cls|

    cls := self class.

    (cls == ByteArray or:[cls == ImmutableByteArray]) ifTrue:[
        size := self size.
        ^ (String uninitializedNew:size) replaceBytesFrom:1 to:size with:self startingAt:1.
    ].
    ^ super asString.

    "
      #[16r41 16r42 16r43] asString
      #[16r41 16r42 16r43] asImmutableByteArray asString
    "
!

beImmutable
    "make myself write-protected"

    super beImmutable.
    self class == ByteArray ifTrue:[
        self changeClassTo:ImmutableByteArray.
    ] ifFalse:[
        self shouldNotImplement.
    ].
!

beSigned
    "make mayself signed.
     elements > 127 are converted to negative numbers."

    self class == ByteArray ifTrue:[
        self changeClassTo:SignedByteArray.
    ] ifFalse:[
        self shouldNotImplement.
    ].

    "
        #[ 1 2 3 128 255] copy beSigned
    "
!

beUnsigned
    "that's what I am (but I don't know if this is true for subclasses."

    self class == ByteArray ifTrue:[
        ^ self.
    ].
    self shouldNotImplement.

    "
        #[ 1 2 3 128 255] copy beUnsigned
    "
!

decodeAsLiteralArray
    "given a literalEncoding in the receiver,
     create & return the corresponding object.
     The inverse operation to #literalArrayEncoding."

    ^ self

!

literalArrayEncoding
    "encode myself as an array literal, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    |cls|

    ((cls := self class) == ByteArray or:[cls == ImmutableByteArray]) ifTrue:[
	^ self
    ].
    ^ super literalArrayEncoding

    "
     #[1 2 3] literalArrayEncoding
    "
! !

!ByteArray methodsFor:'copying'!

copy
    "redefined for a bit more speed"

    self class == ByteArray ifTrue:[
	^ self copyFrom:1 to:(self size)
    ].
    ^ super copy
!

copyFrom:start to:stop
    "return the subcollection starting at index start, anInteger and ending
     at stop, anInteger.
     - reimplemented here for speed"

%{  /* NOCONTEXT */

    REGISTER unsigned char *srcp;
    REGISTER unsigned char *dstp;
    REGISTER int count;
    int len, index1, index2, sz;
    OBJ newByteArray;

    if (__isByteArrayLike(self)
     && __bothSmallInteger(start, stop)) {
	len = __byteArraySize(self);
	index1 = __intVal(start);
	index2 = __intVal(stop);

	if ((index1 <= index2) && (index1 > 0)) {
	    if (index2 <= len) {
		count = index2 - index1 + 1;
		__PROTECT_CONTEXT__
		sz = OHDR_SIZE + count;
		__qNew(newByteArray, sz);       /* OBJECT ALLOCATION */
		__UNPROTECT_CONTEXT__
		if (newByteArray != nil) {
		    __InstPtr(newByteArray)->o_class = ByteArray;
		    __qSTORE(newByteArray, ByteArray);
		    dstp = __ByteArrayInstPtr(newByteArray)->ba_element;
		    srcp = __ByteArrayInstPtr(self)->ba_element + index1 - 1;

#ifdef bcopy4
		    if (((unsigned INT)srcp & 3) == ((unsigned INT)dstp & 3)) {
			int nW;

			/* copy unaligned part */
			while (count && (((unsigned INT)srcp & 3) != 0)) {
			    *dstp++ = *srcp++;
			    count--;
			}
			if (count) {
			    /* copy aligned part */
			    nW = count >> 2;
			    if (count & 3) {
				nW++;
			    }
			    bcopy4(srcp, dstp, nW);
			}
			RETURN ( newByteArray );
		    }
#endif /* bcopy4 */
#if __POINTER_SIZE__ == 8
		    if (((unsigned INT)srcp & 7) == ((unsigned INT)dstp & 7)) {
			int nW;

			/* copy unaligned part */
			while (count && (((unsigned INT)srcp & 7) != 0)) {
			    *dstp++ = *srcp++;
			    count--;
			}
			/* copy aligned part */
			while (count >= 8) {
			    ((unsigned INT *)dstp)[0] = ((unsigned INT *)srcp)[0];
			    dstp += 8;
			    srcp += 8;
			    count -= 8;
			}
			/* copy remaining part */
			while (count) {
			    *dstp++ = *srcp++;
			    count--;
			}
			RETURN ( newByteArray );
		    }
#endif /* bcopy4 */

#ifdef FAST_MEMCPY
		    bcopy(srcp, dstp, count);
#else
		    while (count--) {
			*dstp++ = *srcp++;
		    }
#endif
		    RETURN ( newByteArray );
		}
	    }
	}
    }
%}.
    "
     fall back in case of non-integer index or out-of-bound index;
     will eventually lead to an out-of-bound signal raise
    "
    ^ super copyFrom:start to:stop

    "
     #[1 2 3 4 5 6 7 8 9 10] copyFrom:1 to:10
     #[1 2 3 4 5 6 7 8 9 10] copyFrom:5 to:7

     #[1 2 3 4 5 6 7 8 9 10] copyFrom:5 to:11
     #[1 2 3 4 5 6 7 8 9 10] copyFrom:0 to:10
     #[1 2 3 4 5 6 7 8 9 10] copyFrom:0 to:9
    "
!

shallowCopy
    "redefined for a bit more speed"

    self class == ByteArray ifTrue:[
	^ self copyFrom:1 to:(self size)
    ].
    ^ super shallowCopy
!

symbolFrom:start to:stop
    "make a symbol from the characters of the subcollection starting
     at index start, anInteger and ending at stop, anInteger.
     This saves us garbage and character copying."

    |sym|

%{  /* STACK:1024 */

    REGISTER unsigned char *srcp;
    REGISTER unsigned char *endp;
    REGISTER int count;
    int len, index1, index2;
    unsigned char scratchBuffer[1024], savec;

    if (__isByteArrayLike(self) && __bothSmallInteger(start, stop)) {
	len = __byteArraySize(self);
	index1 = __intVal(start);
	index2 = __intVal(stop);

	if ((index1 <= index2) && (index1 > 0) && (index2 <= len)) {
	    count = index2 - index1 + 1;
	    srcp = __ByteArrayInstPtr(self)->ba_element + index1 - 1;
	    if (index2 < len) {
		/* temporarily stuff in a '\0' */
		endp = srcp + count + 1;
		savec = *endp;
		*endp = '\0';
		sym = __MKSYMBOL(srcp, 0);
		/* must refetch endp (in case of a GC */
		endp = __ByteArrayInstPtr(self)->ba_element + index1 + count;
		*endp = savec;
	    } else {
		/* not enough space for '\0', copy the bytes */
		if (count < sizeof(scratchBuffer)) {
		    bcopy(srcp, scratchBuffer, count);
		    scratchBuffer[count] = '\0';
		    sym = __MKSYMBOL(scratchBuffer, 0);
		}
	    }
	}
	if (sym != nil)
	    RETURN(sym);
    }
%}.
    "
     fall back in case of non-integer index or out-of-bound index
     or not enough stack-memory available;
     may eventually lead to an out-of-bound signal raise
    "
    ^ (super copyFrom:start to:stop) asString asSymbol


    "
     'abcdefghijklmnop' symbolFrom:1 to:3
     'abcdefghijklmnop' symbolFrom:3 to:16
     'abcdefghijklmnop' symbolFrom:3 to:17
    "
! !

!ByteArray methodsFor:'filling & replacing'!

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
	if ((cls = __qClass(self)) != @global(ByteArray)) {
	    int nInst;

	    nInst = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    dstp += nInst;
	    len -= nInst;
	}

	value = __intVal(aNumber);
	if (((unsigned)value <= 0xFF) /* i.e. (value >= 0) && (value <= 255) */
	 && (index1 <= index2)
	 && (index1 > 0)) {
	    if (index2 <= len) {
		count = index2 - index1 + 1;

#ifdef memset4
		if (count > 20) {
		    /* fill unaligned part */
		    while (((unsigned INT)dstp & 3) != 0) {
			*dstp++ = value;
			count--;
		    }
		    /* fill aligned part */
		    {
			int n4 = count & ~3;
			int v4, nW;

			v4 = (value << 8) | value;
			v4 = (v4 << 16) | v4;
			nW = n4>>2;
			memset4(dstp, v4, nW);
			count -= n4;
			dstp += n4;
		    }
		    while (count--) {
			*dstp++ = value;
		    }
		    RETURN (self);
		}
#endif /* memset4 */

#if (__POINTER_SIZE__ == 8)
		{
		    INT v8;

		    v8 = (value << 8) | value;
		    v8 = (v8 << 16) | v8;
		    v8 = (v8 << 32) | v8;

		    /* fill unaligned part */
		    while ((count > 0) && (((unsigned INT)dstp & 3) != 0)) {
			*dstp++ = value;
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
			*dstp = value;
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
		    dstp[4] = dstp[5] = dstp[6] = dstp[7] = value;
		    dstp += 8;
		    count -= 8;
		}
# endif /* __UNROLL_LOOPS__ */
		while (count--) {
		    *dstp++ = value;
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
     (ByteArray new:10) from:1 to:10 put:1
     (ByteArray new:20) from:10 to:20 put:1
     (ByteArray new:20) from:1 to:10 put:1
    "
! !

!ByteArray methodsFor:'image manipulation support'!

bitAndBytesFrom:dstStart to:dstEnd with:sourceBytes startingAt:sourceStart
    "replace bytes in the receiver with the result of a bitAnd operation.
     Warning: this is a destructive operation - elements in the receiver are overwritten."

    ^ self bitBlitBytesFrom:dstStart to:dstEnd with:sourceBytes startingAt:sourceStart rule:#bitAnd:

    "
     #[1 2 3 4 5 6 7 8]
	bitAndBytesFrom:1 to:8 with:#[1 2 3 4 5 6 7 8] startingAt:1
     #[1 2 3 4 5 6 7 8]
	bitAndBytesFrom:1 to:8 with:#[1 1 1 1 1 1 1 1] startingAt:1
    "

!

bitBlitBytesFrom:dstStart to:dstEnd with:sourceBytes startingAt:sourceStart rule:ruleSymbol
    "perform a special case of an aligned bitBlit operation.
     Bytes in the receiver from dstStart to dstEnd are destructively replaced by the result
     of some logical operation, as specified by the ruleSymbol.
     SourceBytes are fetched starting at sourceOffset.
     Valid rule symbols are:
	#copy    - trivial;  same as replaceBytesFrom:to:with:startingAt:
	#bitXor: - xoring;   byte[dI] = byte[dI] bitXor:(srcByte[sI])
	#bitAnd: - anding;   byte[dI] = byte[dI] bitAnd:(srcByte[sI])
	#bitOr:  - oring;    byte[dI] = byte[dI] bitOr:(srcByte[sI])
	#+       - adding;   byte[dI] = (byte[dI] + (srcByte[sI])) mod: 256
	#-       - subtract; byte[dI] = (byte[dI] - (srcByte[sI])) mod: 256
     Warning: this is a destructive operation - elements in the receiver are overwritten.
    "

    |srcIdx|

%{
    if ((__isByteArrayLike(sourceBytes))
     && (__qClass(self) == ByteArray)
     && __isSmallInteger(dstStart)
     && __isSmallInteger(dstEnd)
     && __isSmallInteger(sourceStart)) {
	unsigned char *srcP = __ByteArrayInstPtr(sourceBytes)->ba_element;
	unsigned char *dstP = __ByteArrayInstPtr(self)->ba_element;
	int srcLen = __byteArraySize(sourceBytes);
	int dstLen = __byteArraySize(self);
	int __srcStart = __intVal(sourceStart);
	int __dstStart = __intVal(dstStart);
	int count = __intVal(dstEnd) - __dstStart + 1;

	if ((__dstStart >= 1)
	 && (__srcStart >= 1)
	 && ((__dstStart + count - 1) <= dstLen)
	 && ((__srcStart + count - 1) <= srcLen)) {
	    srcP += __srcStart - 1;
	    dstP += __dstStart - 1;

#define OP_LOOP_BYTES(OP) \
    while (count >= 4) {                                             \
	(dstP[0]) OP (srcP[0]);                                      \
	(dstP[1]) OP (srcP[1]);                                      \
	(dstP[2]) OP (srcP[2]);                                      \
	(dstP[3]) OP (srcP[3]);                                      \
	srcP += 4;                                                   \
	dstP += 4;                                                   \
	count -= 4;                                                  \
    }                                                                \
    while (count > 0) {                                              \
	*dstP OP (*srcP);                                            \
	srcP++;                                                      \
	dstP++;                                                      \
	count--;                                                     \
    }

#define OP_LOOP(OP) \
    while (count >= 16) {                                            \
	((unsigned int *)dstP)[0] OP (((unsigned int *)srcP)[0]);    \
	((unsigned int *)dstP)[1] OP (((unsigned int *)srcP)[1]);    \
	((unsigned int *)dstP)[2] OP (((unsigned int *)srcP)[2]);    \
	((unsigned int *)dstP)[3] OP (((unsigned int *)srcP)[3]);    \
	srcP += 16;                                                  \
	dstP += 16;                                                  \
	count -= 16;                                                 \
    }                                                                \
    while (count >= 4) {                                             \
	((unsigned int *)dstP)[0] OP (((unsigned int *)srcP)[0]);    \
	srcP += 4;                                                   \
	dstP += 4;                                                   \
	count -= 4;                                                  \
    }                                                                \
    while (count > 0) {                                              \
	*dstP OP (*srcP);                                            \
	srcP++;                                                      \
	dstP++;                                                      \
	count--;                                                     \
    }


	    if (ruleSymbol == @symbol(bitXor:)) {
		OP_LOOP( ^= )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitXorNot:)) {
		OP_LOOP( ^=~ )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitAnd:)) {
		OP_LOOP( &= )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitAndNot:)) {
		OP_LOOP( &=~ )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitOr:)) {
		OP_LOOP( |= )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitOrNot:)) {
		OP_LOOP( |=~ )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(copy)) {
		OP_LOOP( = )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(copyNot)) {
		OP_LOOP( =~ )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(+)) {
		OP_LOOP_BYTES( += )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(-)) {
		OP_LOOP_BYTES( -= )
		RETURN (self);
	    }
	}
    }
#undef OP_LOOP_BYTES
#undef OP_LOOP

%}.
    ruleSymbol == #copy ifTrue:[
	self replaceFrom:dstStart to:dstEnd with:sourceBytes startingAt:sourceStart.
	^ self
    ].

    srcIdx := sourceStart.
    dstStart to:dstEnd do:[:dstIdx |
	self at:dstIdx put:((self at:dstIdx) perform:ruleSymbol with:(sourceBytes at:srcIdx)).
	srcIdx := srcIdx + 1.
    ].

    "
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:3 with:#[1 2 3 4 5 6 7 8] startingAt:1 rule:#bitXor:
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:8 with:#[1 2 3 4 5 6 7 8] startingAt:1 rule:#bitXor:
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:8 with:#[1 1 1 1 1 1 1 1] startingAt:1 rule:#bitAnd:
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:8 with:#[1 2 3 4 5 6 7 8] startingAt:1 rule:#+
     #[255 0 0 0 0 0 0 0]
	bitBlitBytesFrom:1 to:8 with:#[1 2 3 4 5 6 7 8] startingAt:1 rule:#+
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:4 with:#[1 1 1 1 1 1 1 1] startingAt:1 rule:#+
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:4 with:#[1 1 1 1 2 2 2 2] startingAt:5 rule:#+
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:4 with:#[1 1 1 1 2 2 2 2] startingAt:5 rule:#copyNot

     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:8 with:(1 to:8) startingAt:1 rule:#+
    "
!

bitBlitBytesFrom:dstStart to:dstEnd withConstant:sourceByte rule:ruleSymbol
    "perform a special case of an aligned bitBlit operation.
     Bytes in the receiver from dstStart to dstEnd are destructively replaced by the result
     of some logical operation, as specified by the ruleSymbol.
     Valid rule symbols are:
	#copy    - trivial;  same as from:to:put:
	#bitXor: - xoring;   byte[dI] = byte[dI] bitXor:sourceConst
	#bitAnd: - anding;   byte[dI] = byte[dI] bitAnd:sourceConst
	#bitOr:  - oring;    byte[dI] = byte[dI] bitOr:sourceConst
	#+       - adding;   byte[dI] = (byte[dI] + sourceConst) mod: 256
	#-       - subtract; byte[dI] = (byte[dI] - sourceConst) mod: 256
     Warning: this is a destructive operation - elements in the receiver are overwritten.
    "

    |srcIdx|

%{
    if ((__qClass(self) == ByteArray)
     && __isSmallInteger(dstStart)
     && __isSmallInteger(dstEnd)
     && __isSmallInteger(sourceByte)) {
	unsigned char srcByte = __intVal(sourceByte);
	unsigned srcWord;
	unsigned char *dstP = __ByteArrayInstPtr(self)->ba_element;
	int dstLen = __byteArraySize(self);
	int __dstStart = __intVal(dstStart);
	int count = __intVal(dstEnd) - __dstStart + 1;

	srcWord = (srcByte << 8) | srcByte;
	srcWord = (srcWord << 16) | srcWord;
	if ((__dstStart >= 1)
	 && ((__dstStart + count - 1) <= dstLen)) {
	    dstP += __dstStart - 1;

#define OP_LOOP_BYTES(OP) \
    while (count >= 4) {                         \
	dstP[0] OP srcByte;                      \
	dstP[1] OP srcByte;                      \
	dstP[2] OP srcByte;                      \
	dstP[3] OP srcByte;                      \
	dstP += 4;                               \
	count -= 4;                              \
    }                                            \
    while (count > 0) {                          \
	*dstP OP srcByte;                        \
	dstP++;                                  \
	count--;                                 \
    }

#define OP_LOOP_INT32(OP) \
    while (count >= 16) {                        \
	((unsigned int *)dstP)[0] OP srcWord;    \
	((unsigned int *)dstP)[1] OP srcWord;    \
	((unsigned int *)dstP)[2] OP srcWord;    \
	((unsigned int *)dstP)[3] OP srcWord;    \
	dstP += 16;                              \
	count -= 16;                             \
    }                                            \

#define OP_LOOP(OP) \
    OP_LOOP_INT32(OP)                            \
    while (count >= 4) {                         \
	((unsigned int *)dstP)[0] OP srcWord;    \
	dstP += 4;                               \
	count -= 4;                              \
    }                                            \
    while (count > 0) {                          \
	*dstP OP srcByte;                        \
	dstP++;                                  \
	count--;                                 \
    }


	    if (ruleSymbol == @symbol(bitXor:)) {
		OP_LOOP( ^= )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitXorNot:)) {
		OP_LOOP( ^=~ )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitAnd:)) {
		OP_LOOP( &= )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitAndNot:)) {
		OP_LOOP( &=~ )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitOr:)) {
		OP_LOOP( |= )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(bitOrNot:)) {
		OP_LOOP( |=~ )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(copy)) {
		OP_LOOP( = )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(copyNot)) {
		OP_LOOP( =~ )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(+)) {
		OP_LOOP_BYTES( += )
		RETURN (self);
	    }
	    if (ruleSymbol == @symbol(-)) {
		OP_LOOP_BYTES( -= )
		RETURN (self);
	    }
	}
    }
#undef OP_LOOP_BYTES
#undef OP_LOOP
%}.
    ruleSymbol == #copy ifTrue:[
	self from:dstStart to:dstEnd put:sourceByte.
	^ self
    ].

    dstStart to:dstEnd do:[:dstIdx |
	self at:dstIdx put:((self at:dstIdx) perform:ruleSymbol with:sourceByte).
    ].

    "
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:3 withConstant:1 rule:#bitXor:
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:8 withConstant:1 rule:#bitXor:
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:8 withConstant:1 rule:#bitAnd:
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:8 withConstant:1 rule:#+
     #[255 0 0 0 0 0 0 0]
	bitBlitBytesFrom:1 to:8 withConstant:1 rule:#+
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:4 withConstant:1 rule:#+
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:4 withConstant:1 rule:#-
     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:4 withConstant:1 rule:#copyNot

     #[1 2 3 4 5 6 7 8]
	bitBlitBytesFrom:1 to:8 withConstant:1 rule:#+
    "
!

bitOrBytesFrom:dstStart to:dstEnd with:sourceBytes startingAt:sourceStart
    "replace bytes in the receiver with the result of a bitOr operation.
     Warning: this is a destructive operation - elements in the receiver are overwritten."

    ^ self bitBlitBytesFrom:dstStart to:dstEnd with:sourceBytes startingAt:sourceStart rule:#bitOr:

    "
     #[1 2 3 4 5 6 7 8]
	bitOrBytesFrom:1 to:8 with:#[1 2 3 4 5 6 7 8] startingAt:1
     #[1 2 3 4 5 6 7 8]
	bitOrBytesFrom:1 to:8 with:#[1 1 1 1 1 1 1 1] startingAt:1
    "

!

bitXorBytesFrom:dstStart to:dstEnd with:sourceBytes startingAt:sourceStart
    "replace bytes in the receiver with the result of an bitXor operation.
     Warning: this is a destructive operation - elements in the receiver are overwritten."

    ^ self bitBlitBytesFrom:dstStart to:dstEnd with:sourceBytes startingAt:sourceStart rule:#bitXor:

    "
     #[1 2 3 4 5 6 7 8]
	bitXorBytesFrom:1 to:3 with:#[1 2 3 4 5 6 7 8] startingAt:1
     #[1 2 3 4 5 6 7 8]
	bitXorBytesFrom:1 to:8 with:#[1 2 3 4 5 6 7 8] startingAt:1
     #[1 2 3 4 5 6 7 8]
	bitXorBytesFrom:1 to:8 with:#[1 1 1 1 1 1 1 1] startingAt:1
    "

!

compressPixels:nBitsPerPixel width:width height:height into:aByteArray mapping:aMapByteArray
    "given the receiver with 8-bit pixels, compress them into aByteArray
     with nBitsPerPixel-depth pixels. The width/height-arguments are needed
     to allow for any padding. On the fly, the source bytes are translated
     using aMapByteArray (if non-nil).
     Notice that smalltalk indexing begins at 1; thus the map-index for a byte
     value of n is found in map at:(n + 1).
     Output bits are filled left-to right, i.e. the first byte in the input
     corresponds to the high bit(s) if the first byte in the input.
     This method can be used to convert 8-bit image data to mono, 2-bit and 4-bit
     bitmaps.
     It can also be used to compress byte-arrays into bitArrays."

%{  /* NOCONTEXT */

    REGISTER unsigned char *src, *dst;
    REGISTER int wrun;
    unsigned char *dstNext;
    unsigned char *dstEnd;
    int bytesPerRow, mask, shift0, shift;
    int w, h, hrun;
    int srcBytes, dstBytes;
    int bitsPerPixel;
    int bits;
    int ncells;
    unsigned char *map;

    if ((__qClass(self) == @global(ByteArray))
     && (__qClass(aByteArray) == @global(ByteArray))
     && __isSmallInteger(nBitsPerPixel)
     && __bothSmallInteger(height, width)) {
	if ((aMapByteArray != nil)
	 && (__Class(aMapByteArray) == @global(ByteArray))) {
	    map = __ByteArrayInstPtr(aMapByteArray)->ba_element;
	} else {
	    map = (unsigned char *)0;
	}

	bitsPerPixel = __intVal(nBitsPerPixel);
	w = __intVal(width);
	h = __intVal(height);
	src = __ByteArrayInstPtr(self)->ba_element;
	dst = __ByteArrayInstPtr(aByteArray)->ba_element;
	dstEnd = dst + __byteArraySize(aByteArray);
	switch (bitsPerPixel) {
	    case 1:
		mask = 0x01;
		break;
	    case 2:
		mask = 0x03;
		break;
	    case 4:
		mask = 0x0F;
		break;
	    case 8:
		mask = 0xFF;
		break;
	    default:
		console_printf("invalid depth in compressPixels\n");
		goto fail;
	}
	if (map) {
	    /*
	     * if a map is present, it must have entries for
	     * all possible byte-values (i.e. its size must be >= 256)
	     */
	    if ((__qSize(aMapByteArray) - OHDR_SIZE) < 256) {
		console_printf("invalid map in compressPixels\n");
		goto fail;
	    }
	}

	bytesPerRow = (w * bitsPerPixel + 7) / 8;
	dstBytes = bytesPerRow * h;
	srcBytes = w * h;

	if ((__byteArraySize(self) >= srcBytes)
	 && (__byteArraySize(aByteArray) >= dstBytes)) {
	    for (hrun=h; hrun; hrun--) {
		dstNext = dst + bytesPerRow;
		bits = 0; shift = 8;
		if (map) {
		    for (wrun=w; wrun; wrun--) {
			bits = (bits << bitsPerPixel) | (map[*src++] & mask);
			shift -= bitsPerPixel;
			if (shift == 0) {
			    if (dst == dstEnd) goto fail;
			    *dst++ = bits;
			    bits = 0; shift = 8;
			}
		    }
		} else {
		    for (wrun=w; wrun; wrun--) {
			bits = (bits << bitsPerPixel) | (*src++ & mask);
			shift -= bitsPerPixel;
			if (shift == 0) {
			    if (dst == dstEnd) goto fail;
			    *dst++ = bits;
			    bits = 0; shift = 8;
			}
		    }
		}
		if (shift != 8) {
		    if (dst == dstEnd) goto fail;
		    *dst = bits;
		}
		dst = dstNext;
	    }
	    RETURN ( self );
	}
    }
fail: ;
%}.
    self primitiveFailed

    "Example1:
     compress 1 byte-per-pixel bitmap to 1-bit-per-pixel bitmap
    "
    "
     |inBits outBits|

     inBits := #[0 0 0 0 1 1 1 1
		 0 0 1 1 0 0 1 1
		 0 1 0 1 0 1 0 1
		 1 1 1 1 0 0 0 0].
     outBits := ByteArray new:4.
     inBits compressPixels:1 width:8 height:4
		    into:outBits mapping:nil.
     outBits inspect
    "

    "Example2:
     compress byte-array into a bitArray, translating 99 to 0-bits,
     and 176 to 1-bits. (just a stupid example)
    "
    "
     |inBits outBits map|

     inBits := #[176 176 176 176 99 99 99 99 176 176 99 99 176 99 176 99].
     map := ByteArray new:256.
     map at:176+1 put:1.

     outBits := ByteArray new:2.
     inBits compressPixels:1 width:16 height:1
		    into:outBits mapping:map.
     outBits inspect
    "

    "Example3:
     compress byte-array into a bitArray, translating everything below 128 to 0-bits,
     and 128 to 255 to 1-bits.99 to 0-bits (another stupid example)
    "
    "
     |inBits outBits map|

     inBits := #[176 176 176 176 99 99 99 99 176 176 99 99 176 99 176 99].
     map := ByteArray new:256.
     map atAll:(128+1 to:255+1) put:1.

     outBits := ByteArray new:2.
     inBits compressPixels:1 width:16 height:1
		    into:outBits mapping:map.
     outBits inspect
    "
!

expandPixels:nBitsPerPixel width:width height:height into:aByteArray mapping:aMapByteArray
    "given the receiver with nBitsPerPixel-depth pixels, expand them into
     aByteArray with 8-bit pixels. The width/height-arguments are needed
     to skip any padded src-bits. On the fly, the destination pixels
     are translated using aMapByteArray (if non-nil).
     Input bits are read left-to right, i.e. the first byte in the output
     corresponds to the high bit(s) in the inputs first byte.
     This is used to display mono, 2-bit and 4-bit bitmaps on grey-scale/color
     machines. With nBitsPerPixel==8, this is a translate operation.
     Notice that smalltalk indexing begins at 1; thus the map-index for a byte
     value of n is found in map at:(n + 1).
     It can also be used to expand bit-arrays into byteArrays.
     This method is specialized for ByteArray arguments - it will not handle
     anything else."

%{  /* NOCONTEXT */

    REGISTER unsigned char *src, *dst;
    REGISTER int wrun;
    unsigned char *srcNext;
    int bytesPerRow, mask, shift0, shift;
    int w, h, hrun;
    int srcBytes, dstBytes;
    int bitsPerPixel;
    int bits;
    int ncells;
    unsigned char *map;

    if ((__qClass(self) == @global(ByteArray))
     && (__qClass(aByteArray) == @global(ByteArray))
     && __isSmallInteger(nBitsPerPixel)
     && __bothSmallInteger(height, width)) {
	if ((aMapByteArray != nil)
	 && (__Class(aMapByteArray) == @global(ByteArray))) {
	    map = __ByteArrayInstPtr(aMapByteArray)->ba_element;
	} else {
	    map = (unsigned char *)0;
	}

	bitsPerPixel = __intVal(nBitsPerPixel);
	w = __intVal(width);
	h = __intVal(height);
	src = __ByteArrayInstPtr(self)->ba_element;
	dst = __ByteArrayInstPtr(aByteArray)->ba_element;
	switch (bitsPerPixel) {
	    case 1:
		mask = 0x01;
		break;
	    case 2:
		mask = 0x03;
		break;
	    case 4:
		mask = 0x0F;
		break;
	    case 8:
		mask = 0xFF;
		break;
	    default:
		console_printf("expandPixels: invalid depth\n");
		goto fail;
	}
	ncells = mask + 1;
	if (map) {
	    /*
	     * if a map is present, it must have the correct size
	     * (i.e. 2 raisedTo:nBitsPerPixel)
	     */
	    if ((__qSize(aMapByteArray) - OHDR_SIZE) < ncells) {
		console_printf("expandPixels: invalid map\n");
		goto fail;
	    }
	}

	bytesPerRow = (w * bitsPerPixel + 7) / 8;
	shift0 = 8 - bitsPerPixel;
	srcBytes = bytesPerRow * h;
	dstBytes = w * h;

	if ((__byteArraySize(self) >= srcBytes)
	 && (__byteArraySize(aByteArray) >= dstBytes)) {
	    for (hrun=h; hrun; hrun--) {
		srcNext = src + bytesPerRow;
		shift = shift0;
		if (map) {
		    if (shift0 == 0) {
			/* translate only */
			for (wrun=w; wrun; wrun--) {
			    bits = *src++;
			    *dst++ = map[bits];
			}
		    } else {
			for (wrun=w; wrun; wrun--) {
			    if (shift == shift0) {
				bits = *src++;
			    }
			    *dst++ = map[(bits >> shift) & mask];
			    shift -= bitsPerPixel;
			    if (shift < 0) {
				shift = shift0;
			    }
			}
		    }
		} else {
		    for (wrun=w; wrun; wrun--) {
			if (shift == shift0) {
			    bits = *src++;
			}
			*dst++ = (bits >> shift) & mask;
			shift -= bitsPerPixel;
			if (shift < 0) {
			    shift = shift0;
			}
		    }
		}
		src = srcNext;
	    }
	    RETURN ( self );
	}
	console_printf("expandPixels: buffer size: self:%"_ld_" expect at least:%"_ld_"\n",
		(INT)(__byteArraySize(self)), (INT)srcBytes);
	console_printf("expandPixels: buffer size: arg:%"_ld_" expect at least:%"_ld_"\n",
		(INT)(__byteArraySize(aByteArray)), (INT)dstBytes);
    }
    console_printf("expandPixels: invalid args\n");

fail: ;
%}.
    self primitiveFailed

    "Example1:
     expand 1-bit-per-pixel bitmap into a 1byte-per-pixel byteArray
    "
    "
     |inBits outBits|

     inBits := #[2r11110000
		 2r11001100
		 2r01010101
		 2r00001111].
     outBits := ByteArray new:(8*4).
     inBits expandPixels:1 width:8 height:4
		    into:outBits mapping:nil.
     outBits inspect
    "

    "Example2:
     expand bit-array into a byteArray, translating 0-bits to 99,
     1-bits to 176. (just a stupid example)
    "
    "
     |inBits outBits|

     inBits := #[2r11110000 2r11001100].
     outBits := ByteArray new:16.
     inBits expandPixels:1 width:16 height:1
		    into:outBits mapping:#[99 176].
     outBits inspect
    "

    "This Can also be used to extract nibbles ..."
    "
     |inBits outBits|

     inBits := #[ 16r12 16r34 16r56 16r78 16r9A 16rBC 16rDE 16rF0 ].
     outBits := ByteArray new:(inBits size * 2).
     inBits expandPixels:4 width:outBits size height:1 into:outBits mapping:nil.
     outBits inspect
    "

!

invert
    "invert all bytes - used with image manipulations
     written as a primitive for speed.
     Q: is this really needed ?"

%{  /* NOCONTEXT */
    REGISTER unsigned char *dst;
    REGISTER unsigned long *ldst;
    REGISTER int cnt;

    if (__qClass(self) == @global(ByteArray)) {
	cnt = __byteArraySize(self);
	dst = __ByteArrayInstPtr(self)->ba_element;
	if (((INT)dst & (sizeof(long)-1)) == 0) { // aligned
	    ldst = (unsigned long *)dst;
	    while (cnt >= (sizeof(long))*4) {
		ldst[0] = ~(ldst[0]);
		ldst[1] = ~(ldst[1]);
		ldst[2] = ~(ldst[2]);
		ldst[3] = ~(ldst[3]);
		ldst += 4;
		cnt -= (sizeof(long))*4;
	    }
	    while (cnt >= sizeof(long)) {
		*ldst = ~(*ldst);
		ldst++;
		cnt -= sizeof(long);
	    }
	    dst = (unsigned char *)ldst;
	}
	while (cnt--) {
	    *dst = ~(*dst);
	    dst++;
	}
	RETURN ( self );
    }
%}.
    self bitBlitBytesFrom:1 to:self size withConstant:16rFF rule:#bitXor:

    "
     #[1 2 3 4 5 6 7 8 9 10] copy invert
     #[1 2 3 4 5 6 7 8 9 10] copy
	bitBlitBytesFrom:1 to:10 withConstant:16rFF rule:#bitXor:

     |l|
     l := ByteArray fromHexString:'0102030405060708090a0b0c0d0e0f1112131415161718191a1b1c1d1e1f'.
     Time millisecondsToRun:[
	1000000 timesRepeat:[ l invert ].
     ]
    "
!

reverse
    "reverse the order of my elements inplace -
     WARNING: this is a destructive operation, which modifies the receiver.
              Please use reversed (with a 'd' at the end) for a functional version.
     Written as a primitive for speed on image manipulations (mirror)"

%{  /* NOCONTEXT */

    REGISTER unsigned char *p1, *p2;
    REGISTER int cnt;
    REGISTER unsigned t;
    OBJ cls;

    if (__qClass(self) == @global(ByteArray)) {
        cnt = __byteArraySize(self);
        p1 = __ByteArrayInstPtr(self)->ba_element;
        p2 = p1 + cnt - 1;

#if defined(__BSWAP)
        /*
         * can we use the bswap instruction ?
         * notice - not all CPUs have it (the HAS_BSWAP checks this).
         */
        if (__HAS_BSWAP()
         && ((cnt & 3) == 0)) {
            unsigned int *ip1, *ip2;

            ip1 = (unsigned int *)p1;
            ip2 = (unsigned int *)(p2 - 3);

            ip2 -= 7;
            while (ip1 <= ip2) {
                int t1, t2;

                t1 = ip1[0];
                t2 = ip2[7];
                ip2[7] = __BSWAP(t1);
                ip1[0] = __BSWAP(t2);

                t1 = ip1[1];
                t2 = ip2[6];
                ip2[6] = __BSWAP(t1);
                ip1[1] = __BSWAP(t2);

                t1 = ip1[2];
                t2 = ip2[5];
                ip2[5] = __BSWAP(t1);
                ip1[2] = __BSWAP(t2);

                t1 = ip1[3];
                t2 = ip2[4];
                ip2[4] = __BSWAP(t1);
                ip1[3] = __BSWAP(t2);

                ip1 += 4;
                ip2 -= 4;
            }
            ip2 += 7;

            while (ip1 < ip2) {
                int t;

                t = __BSWAP(*ip1);
                *ip1++ = __BSWAP(*ip2);
                *ip2-- = t;
            }

            if (ip1 == ip2) {
                int t;
                t = *ip1;
                t = __BSWAP(t);
                *ip1 = t;
            }
            RETURN ( self );
        }
#endif /* __BSWAP (i.e. __i386__ && __GNUC__) */

        p2 -= 7;
        while (p1 <= p2) {
            t = p1[0];
            p1[0] = p2[7];
            p2[7] = t;

            t = p1[1];
            p1[1] = p2[6];
            p2[6] = t;

            t = p1[2];
            p1[2] = p2[5];
            p2[5] = t;

            t = p1[3];
            p1[3] = p2[4];
            p2[4] = t;

            p1 += 4;
            p2 -= 4;
        }
        p2 += 7;

        while (p1 < p2) {
            t = *p1;
            *p1++ = *p2;
            *p2-- = t;
        }
        RETURN ( self );
    }
%}.
    ^ super reverse

    "
     #[1 2 3 4 5] reverse
     #[1 2 3 4] reverse
     #[1 2 3 4 5] reverse
     #[1 2 3 4 5 6] reverse
     #[1 2 3 4 5 6 7] reverse
     #[1 2 3 4 5 6 7 8] reverse
     #[1 2 3 4 5 6 7 8 9] reverse
     #[1 2 3 4 5 6 7 8 9 10] reverse
     #[1 2 3 4 5 6 7 8 9 10 11 12] reverse
     #[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16] reverse
     #[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20] reverse
     (1 to:255) asByteArray reverse

     1 to:1024 do:[:i|
        |bytes test rBytes|

        bytes := ((1 to:i) asArray collect:[:i | i bitAnd:255]) asByteArray.
        test := ((i to:1 by:-1) asArray collect:[:i | i bitAnd:255]) asByteArray.
        rBytes := bytes copy.
        rBytes reverse ~= test ifTrue:[
            self halt
        ].
        rBytes := bytes copy.
        rBytes reverse reverse ~= bytes ifTrue:[
            self halt
        ]
     ].

     Time millisecondsToRun:[
        10000000 timesRepeat:[
            #[1 2 3 4 5 6 7 8] reverse
        ]
     ]

     |b|
     b := (0 to:255) asByteArray.
     Time millisecondsToRun:[
        10000000 timesRepeat:[
            b reverse
        ]
     ]
    "
!

swapBytes
    "swap bytes (of int16s) inplace -
     Expects that the receiver has an even number of bytes;
     if not, only the pairs excluding the last byte are swapped.
     written as a primitive for speed on image grabbing (if display order is different)."

%{  /* NOCONTEXT */

    REGISTER unsigned char *p;
    REGISTER int cnt;
    REGISTER unsigned t;

    if (__qClass(self) == @global(ByteArray)) {
        cnt = __byteArraySize(self);
        cnt = cnt & ~1; /* make it even */
        p = __ByteArrayInstPtr(self)->ba_element;

        while (cnt >= sizeof(INT)) {
            unsigned INT i = ((unsigned INT *)p)[0];

#if __POINTER_SIZE__ == 8
            i = ((i>>8) & 0x00FF00FF00FF00FF) | ((i & 0x00FF00FF00FF00FF) << 8);
#else
            i = ((i>>8) & 0x00FF00FF) | ((i & 0x00FF00FF) << 8);
#endif /* __POINTER_SIZE__ */
            ((unsigned INT *)p)[0] = i;
            p += sizeof(INT);
            cnt -= sizeof(INT);
        }
        while (cnt > 0) {
            unsigned short s;

            s = ((unsigned short *)p)[0];
            s = (s >> 8) | (s << 8);
            ((unsigned short *)p)[0] = s;
            p += 2;
            cnt -= 2;
        }
        RETURN ( self );
    }
%}.
    ^ super swapBytes "/ rubbish - there is no one currenly

    "
     #[1 2 3 4 5 6 7 8 9 10] copy swapBytes     -> #[2 1 4 3 6 5 8 7 10 9]
     #[1 2 3 4 5 6 7 8 9 10 11] copy swapBytes  -> #[2 1 4 3 6 5 8 7 10 9 11]
     #[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18] copy swapBytes
    "
!

swapIndex:i1 and:i2
   "spap the bytes with i1 and i2"

%{  /* NOCONTEXT */

    REGISTER unsigned char *p;
    unsigned int __i1, __i2;
    int sz;
    unsigned int t;

    if (__qClass(self) == @global(ByteArray) && __bothSmallInteger(i1, i2)) {
	__i1 = __intVal(i1) - 1;
	__i2 = __intVal(i2) - 1;
	sz = __byteArraySize(self);
	p = __ByteArrayInstPtr(self)->ba_element;
	if (__i1 < sz && __i2 < sz) {
	    t = p[__i1];
	    p[__i1] = p[__i2];
	    p[__i2] = t;
	}
	RETURN ( self );
    }
%}.
    ^ super swapIndex:i1 and:i2 "/ rubbish - there is no one currently

    "
     #[1 2 3 4 5 6 7 8 9 10] copy swapIndex:1 and:10
     #[1 2 3 4 5 6 7 8 9 10 11] copy swapIndex:5 and:6
    "
!

swapLongs
    "swap long bytes inplace
     - any partial longs at the end are not swapped."

    self swapLongsFrom:1 to:self size

    "
     #[1 2 3 4 5 6 7 8 9] copy swapLongs
     #[1 2 3 4 5 6 7 8 9 10] copy swapLongs
     #[1 2 3 4 5 6 7 8 9 10 11] copy swapLongs
     #[1 2 3 4 5 6 7 8 9 10 11 12] copy swapLongs
    "
!

swapLongsFrom:startIndex to:endIndex
    "swap longs (int32s) inplace
     - any partial longs at the end are not swapped.
     Swapping is from startIndex to (exclusiv) endIndex;
     indexing starts at 1."

%{  /* NOCONTEXT */

    REGISTER unsigned char *p;
    REGISTER int limit;
    REGISTER unsigned t;

    if ((__qClass(self) == @global(ByteArray))
     && __isSmallInteger(startIndex)
     && __isSmallInteger(endIndex)) {
        int __idx = __intVal(startIndex);
        int __endIdx = __intVal(endIndex);

        limit = __byteArraySize(self);
        if (__endIdx < limit) {
            limit = __endIdx;
        }
        p = __ByteArrayInstPtr(self)->ba_element;
        p = p + __idx - 1;

        limit = limit - 4 + 1;

#if defined(__BSWAP)
        /*
         * can we use the bswap instruction ?
         * notice - not all CPUs have it (the HAS_BSWAP checks this).
         */
        if (__HAS_BSWAP()
         && (((unsigned int)p & 3) == 0)) {
            unsigned int *ip;
            ip = (unsigned int *)p;

            while (__idx <= limit) {
                *ip = __BSWAP(*ip);
                ip++;
                __idx += 4;
            }
            RETURN (self);
        }
#endif /* __BSWAP */

        while (__idx <= limit) {
            t = p[0];
            p[0] = p[3];
            p[3] = t;
            t = p[1];
            p[1] = p[2];
            p[2] = t;
            p += 4;
            __idx += 4;
        }
        RETURN ( self );
    }
%}.
    ^ super swapLongsFrom:startIndex to:endIndex "/ rubbish - there is no one currenly

    "
     #[1 2 3 4 5 6 7 8 9] copy swapLongsFrom:1 to:3
     #[1 2 3 4 5 6 7 8 9] copy swapLongsFrom:1 to:4
     #[1 2 3 4 5 6 7 8 9] copy swapLongsFrom:1 to:5
     #[1 2 3 4 5 6 7 8 9] copy swapLongsFrom:1 to:6
     #[1 2 3 4 5 6 7 8 9] copy swapLongsFrom:1 to:7
     #[1 2 3 4 5 6 7 8 9] copy swapLongsFrom:1 to:8
     #[1 2 3 4 5 6 7 8 9 10] copy swapLongsFrom:1 to:11
     #[1 2 3 4 5 6 7 8 9 10 11] copy swapLongsFrom:1 to:12
     #[1 2 3 4 5 6 7 8 9 10 11 12] copy swapLongsFrom:1 to:13
     #[1 2 3 4 5 6 7 8 9] copy swapLongsFrom:5 to:10
    "
! !


!ByteArray methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "return a printed representation of the receiver for displaying"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    |cls|

    cls := self class.
    ((cls == ByteArray or:[cls == ImmutableByteArray]) and:[aGCOrStream isStream]) ifTrue:[
	self storeOn:aGCOrStream.
	^ self
    ].
    ^ super displayOn:aGCOrStream

    "Created: 25.10.1995 / 13:33:26 / cg"
    "Modified: 22.4.1996 / 12:54:06 / cg"
!

printOn:aStream
    "append a printed representation to aStream"

    |cls|

    "/ care for subclasses
    ((cls := self class) == ByteArray or:[cls == ImmutableByteArray]) ifTrue:[
	aStream nextPutAll:'#['.
	self
	    do:[:byte | byte printOn:aStream]
	    separatedBy:[aStream space].
	aStream nextPut:$].
	^ self
    ].
    ^ super printOn:aStream

    "
     #[1 2 3 4 5] printOn:Transcript


     #[1 2 3 4 5] storeString
     #[1 2 3 4 5] displayString
     #[1 2 3 4 5] printString
    "

    "Modified: / 12.9.1997 / 22:11:33 / cg"
    "Modified: / 17.3.1999 / 17:01:31 / stefan"
!

printOn:aStream base:radix
    "append a printed representation to aStream in the given number base."

    ^ self printOn:aStream base:radix showRadix:false

    "
     #[1 2 3 4 5] printOn:Transcript base:2
     'Hello World' printOn:Transcript base:2

     #[1 2 3 4 5] storeString
     #[1 2 3 4 5] displayString
     #[1 2 3 4 5] printString
    "

    "Modified: / 17.3.1999 / 17:01:31 / stefan"
    "Modified: / 31.10.2001 / 09:43:56 / cg"
!

printOn:aStream base:radix showRadix:showRadix
    "append a printed representation to aStream in the given number base."

    |cls|

    ((cls := self class) == ByteArray or:[cls == ImmutableByteArray]) ifTrue:[
	"/ care for subclasses
	aStream nextPutAll:'#['.
	self
	    do:[:byte | byte printOn:aStream base:radix showRadix:showRadix]
	    separatedBy:[aStream space].
	aStream nextPut:$].
	^ self
    ].
    ^ self printOn:aStream

    "
     #[1 2 3 4 5] printOn:Transcript base:2
     'Hello World' printOn:Transcript base:2

     #[1 2 3 4 5] storeString
     #[1 2 3 4 5] displayString
     #[1 2 3 4 5] printString
    "

    "Modified: / 12.9.1997 / 22:11:33 / cg"
    "Modified: / 17.3.1999 / 17:01:31 / stefan"
    "Created: / 31.10.2001 / 09:43:41 / cg"
!

storeOn:aStream
    "append a printed representation from which the receiver can be
     reconstructed to aStream. (reimplemented to make it look better)"

    |cls|

    ((cls := self class) == ByteArray or:[cls == ImmutableByteArray]) ifTrue:[
	"/ care for subclasses
	aStream nextPutAll:'#['.
	self
	    do:[:byte | byte storeOn:aStream]
	    separatedBy:[aStream space].
	aStream nextPutAll:']'.
	^ self
    ].
    ^ super storeOn:aStream

    "
     #[1 2 3 4 5] storeOn:Transcript

     #[1 2 3 4 5] storeString
     #[1 2 3 4 5] displayString
     #[1 2 3 4 5] printString
    "

    "Modified: 12.9.1997 / 22:11:33 / cg"
! !

!ByteArray methodsFor:'queries'!

containsNon7BitAscii
    "return true, if any byte in the receiver has the 7th bit on.
     This my look as a too specific operation to be put here,
     put it is very helpful for UTF8 string reading (Java class reader),
     to quickly determine, if UTF8 decoding is needed or not.
     As most strings in a class file are in fact only containing 7bit ascii,
     this should speedup class file reading considerably"

%{  /* NOCONTEXT */
    REGISTER unsigned char *cp;
    REGISTER unsigned char *endP;

    if (__isByteArrayLike(self)) {
	cp = &(__ByteArrayInstPtr(self)->ba_element[0]);
	endP = cp + __byteArraySize(self);
#if __POINTER_SIZE__ == 8
	while (cp+8 < endP) {
	    if ( ((unsigned INT *)cp)[0] & 0x8080808080808080) RETURN( true );
	    cp += 8;
	}
#endif
	while (cp+4 < endP) {
	    if ( ((unsigned int *)cp)[0] & 0x80808080) RETURN( true );
	    cp += 4;
	}
	while (cp < endP) {
	    if (*cp++ & 0x80) RETURN( true );
	}
	RETURN ( false );
    }
%}
.
    ^ self contains:[:b | b bitTest:16r80].

    "
     #[1 2 3 1 2 3 1 2 127 ] containsNon7BitAscii
     #[1 2 3 1 2 3 1 2 250 251 250 251 255] containsNon7BitAscii
    "
!

containsNon8BitElements
    "return true, if one of my elements is larger than a single byte.
     Per definition not."

    ^ false.
!

isValidElement:anObject
    "return true, if I can hold this kind of object"

    ^ anObject isInteger
    and:[ (anObject >= self class minVal)
    and:[ (anObject <= self class maxVal) ]]
!

max
    "return the maximum value in the receiver -
     redefined to speedup image processing and sound-player
     (which need a fast method for this on byteArrays)"

%{  /* NOCONTEXT */

    REGISTER unsigned char *cp;
    REGISTER int index, max;
    int len;

    if (__isByteArrayLike(self)) {
        max = 0;
        index = 0;
        len = __qSize(self) - OHDR_SIZE;
        cp = &(__ByteArrayInstPtr(self)->ba_element[0]);

        if (len > 0) {
            while (++index <= len) {
                unsigned int byte;

                byte = *cp;
                cp++;
                if (byte > max) {
                    max = byte;
                    if (byte == 255) break;
                }
            }
            RETURN ( __mkSmallInteger(max) );
        }
    }
%}.
    ^ super max

    "
     #[1 2 3 1 2 3 1 2 19] max
     #[] max
    "
!

startsWith:aByteOrByteArray
    "return true, if the receiver starts with something, aStringOrChar.
     If the argument is empty, true is returned.
     Notice, that this is similar to, but slightly different from VW's and Squeak's beginsWith:,
     which are both inconsistent w.r.t. an empty argument."

%{  /* NOCONTEXT */
    int len1, len2;
    REGISTER unsigned char *src1, *src2;
    unsigned char c;
    REGISTER OBJ slf = self;

    if (__qIsByteArrayLike(slf) &&__isByteArrayLike(aByteOrByteArray)) {
        src1 = __byteArrayVal(slf);
        src2 = __byteArrayVal(aByteOrByteArray);

        if (src1[0] != src2[0]) {
            if (__qSize(aByteOrByteArray) == OHDR_SIZE) {
                RETURN (true);
            }
            RETURN ( false );
        }

        len1 = __qSize(slf);
        len2 = __qSize(aByteOrByteArray);
        if (len1 < len2) {
            RETURN ( false );
        }

# ifdef UINT64
        while (len2 > (OHDR_SIZE+sizeof(UINT64))) {
            if ( ((UINT64 *)src1)[0] != ((UINT64 *)src2)[0] ) {
                RETURN (false);
            }
            len2 -= sizeof(UINT64);
            src1 += sizeof(UINT64);
            src2 += sizeof(UINT64);
        }
# else
#  ifdef __UNROLL_LOOPS__
        while (len2 > (OHDR_SIZE+sizeof(INT)*4)) {
            if ( ((unsigned INT *)src1)[0] != ((unsigned INT *)src2)[0]) {
                RETURN (false);
            }
            if ( ((unsigned INT *)src1)[1] != ((unsigned INT *)src2)[1]) {
                RETURN (false);
            }
            if ( ((unsigned INT *)src1)[2] != ((unsigned INT *)src2)[2]) {
                RETURN (false);
            }
            if ( ((unsigned INT *)src1)[3] != ((unsigned INT *)src2)[3]) {
                RETURN (false);
            }
            len2 -= sizeof(INT)*4;
            src1 += sizeof(INT)*4;
            src2 += sizeof(INT)*4;
        }
#  endif /* __UNROLL_LOOPS__ */
# endif /* UINT64 */

        while (len2 > (OHDR_SIZE+sizeof(INT))) {
            if ( ((unsigned INT *)src1)[0] != ((unsigned INT *)src2)[0]) {
                RETURN (false);
            }
            len2 -= sizeof(INT);
            src1 += sizeof(INT);
            src2 += sizeof(INT);
        }

        for ( ; len2 > OHDR_SIZE; len2--) {
            if (*src1++ != *src2++) {
                RETURN (false);
            }
        }    
        RETURN (true);
    }
    if (__isSmallInteger(aByteOrByteArray)) {
        int val = __intVal(aByteOrByteArray);
        if (__byteArraySize(slf) > 0) {
            RETURN ( (__byteArrayVal(slf)[0] == val) ? true : false);
        }
        RETURN ( false );
    }
%}.
    ^ super startsWith:aByteOrByteArray

    "
     #[1 2 3 4 5 6 7 8 9 10] startsWith:#[ 1 2 3 4 5]
     #[1 2 3 4] startsWith:#[ 1 3 4 5]
     #[1 2 3 4 5 6 7 8 9 10] startsWith:#[ 0 1 2 3 4 5]
     #[1 2 3 4 5 6 7 8 9 10] startsWith:#(1 2 3 4 5)
     #[1 2 3 4 5 6 7 8 9 10] startsWith:1
     #[1 2 3 4 5 6 7 8 9 10] startsWith:2
    "
!

usageCounts
    "return an array filled with value-counts -
     This is needed in the bitmap/image classes to get info on color usage.
     (i.e. to build up a histogram of color usage within an image)."

    |counts|

    counts := Array basicNew:256.

%{  /* STACK: 2000 */

    REGISTER unsigned char *cp;
    REGISTER int nByte;
    REGISTER int index;
    INT icounts[256];

    if (__isByteArrayLike(self) && __isArray(counts)) {
	/*
	 * zero counts
	 */
	for (index=0; index<256; index++) {
	    icounts[index] = 0;
	}

	/*
	 * count
	 */
	nByte = __qSize(self) - OHDR_SIZE;
	cp = &(__ByteArrayInstPtr(self)->ba_element[0]);
	while (nByte--) {
	    icounts[*cp++]++;
	}

	/*
	 * make it real counts
	 */
	for (index=0; index<256; index++) {
	    __ArrayInstPtr(counts)->a_element[index] = __mkSmallInteger(icounts[index]);
	}
	RETURN ( counts );
    }
%}
.
    self primitiveFailed

    "
     #[1 2 3 1 2 3 1 2 250 251 250 251 255] usageCounts
    "
!

usedValues
    "return a new ByteArray with all used values (actually a kind of Set);
     This is needed specially in the bitmap/Imageclasses to find used colors
     of an image."

%{  /* STACK: 400 */

    REGISTER unsigned char *cp;
    unsigned char *endp;
    REGISTER int len;
    OBJ result;
    union {
	unsigned char flags[256];
	int toForceAlignmentOfFlags;
    } f;

#ifdef TO_BE_MEASURED
    int coverage = 0;
#endif

    if (__isByteArrayLike(self)) {
	memset(f.flags, 0, sizeof(f.flags));
	len = __qSize(self) - OHDR_SIZE;
	cp = &(__ByteArrayInstPtr(self)->ba_element[0]);

	/* for each used byte, set flag */
	while (len > 0) {
#ifdef TO_BE_MEASURED
	    unsigned  byte;

	    byte = *cp;
	    if (! f.flags[byte]) {
		f.flags[byte] = 1;
		coverage++;
		if (coverage == 256) {
		    /* no need to scan rest */
		    break;
		}
	    }
#else
	    f.flags[*cp] = 1;
#endif
	    cp++;
	    len--;
	}

	/* count 1's */
	len = 0;
	for (cp=f.flags, endp=f.flags+256; cp < endp;) {
	    if ( *((unsigned int *)cp)) {
		if (cp[0]) len++;
		if (cp[1]) len++;
		if (cp[2]) len++;
		if (cp[3]) len++;
	    }
	    cp += 4;
	}

	/* create ByteArray of used values */
	result = __BYTEARRAY_UNINITIALIZED_NEW_INT(len);
	if (result) {
	    cp = __ByteArrayInstPtr(result)->ba_element;
	    for (len=0; len < 256; len++) {
		if (f.flags[len])
		    *cp++ = len;
	    }
	    RETURN ( result );
	}
    }
%}.
    ^ self asIdentitySet asByteArray

    "
     #[1 2 3 1 2 3 1 2 3 1 2 3 4 5 6 4 5 6] usedValues
    "
! !

!ByteArray methodsFor:'searching'!

indexOf:aByte startingAt:start
    "return the index of the first occurrence of the argument, aByte
     in the receiver starting at start, anInteger; return 0 if not found.
     - reimplemented here for speed"

%{  /* NOCONTEXT */

    REGISTER unsigned char *cp;
    REGISTER INT index;
    REGISTER int byteValue;
    REGISTER int len;
    OBJ cls;

    if (__isSmallInteger(aByte) &&__isBytes(self)) {
	byteValue = __intVal(aByte);

	if (byteValue & ~0xFF /* i.e. (byteValue < 0) || (byteValue > 255) */) {
	    /*
	     * searching for something which cannot be found
	     */
	    RETURN ( __mkSmallInteger(0) );
	}

	if (__isSmallInteger(start)) {
	    index = __intVal(start);
	    len = __byteArraySize(self);
	    cp = __ByteArrayInstPtr(self)->ba_element;
	    if ((cls = __qClass(self)) != @global(ByteArray)) {
		int nInst;

		nInst = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
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
     #[1 2 3 4 5 6 7 8 9 0 1 2 3 4 5] indexOf:0 startingAt:1
    "
! !

!ByteArray methodsFor:'testing'!

isByteArray
    "return true, if the receiver is some kind of bytearray;
     true is returned here - the method is redefined from Object."

    ^ true


!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    "/ no, simply returning true here is a mistake:
    "/ it could be a subclass of ByteArray
    "/ (of which the compiler does not know at all ...)

    ^ self class == ByteArray

    "Modified: 22.4.1996 / 12:55:30 / cg"
! !

!ByteArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

