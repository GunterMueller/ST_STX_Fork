"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2014 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

AbstractNumberVector variableWordSubclass:#HalfFloatArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!HalfFloatArray primitiveFunctions!
%{
typedef unsigned short halffloat;
typedef unsigned short uint16;
typedef unsigned int   uint32;

//
// convert a halffloat (16-bit float) to a float
//
float
__STX_halffloat_to_float(halffloat h) {
	int e;
	uint16 hs, he, hm;
	uint32 xs, xe, xm;
	int32 xes;
	union {
	    uint32 u32;
	    float f32;
	} u;

	if( (h & 0x7FFFu) == 0 ) {  // Signed zero
	    u.u32 = ((uint32) h) << 16;  // Return the signed zero
	} else { // Not zero
	    hs = h & 0x8000u;  // Pick off sign bit
	    he = h & 0x7C00u;  // Pick off exponent bits
	    hm = h & 0x03FFu;  // Pick off mantissa bits
	    if( he == 0 ) {  // Denormal will convert to normalized
		e = -1; // The following loop figures out how much extra to adjust the exponent
		do {
		    e++;
		    hm <<= 1;
		} while( (hm & 0x0400u) == 0 ); // Shift until leading bit overflows into exponent bit
		xs = ((uint32) hs) << 16; // Sign bit
		xes = ((uint32) (he >> 10)) - 15 + 127 - e; // Exponent unbias the halfp, then bias the single
		xe = (uint32) (xes << 23); // Exponent
		xm = ((uint32) (hm & 0x03FFu)) << 13; // Mantissa
		u.u32 = (xs | xe | xm); // Combine sign bit, exponent bits, and mantissa bits
	    } else if( he == 0x7C00u ) {  // Inf or NaN (all the exponent bits are set)
		if( hm == 0 ) { // If mantissa is zero ...
		    u.u32 = (((uint32) hs) << 16) | ((uint32) 0x7F800000u); // Signed Inf
		} else {
		    u.u32 = (uint32) 0xFFC00000u; // NaN, only 1st mantissa bit set
		}
	    } else { // Normalized number
		xs = ((uint32) hs) << 16; // Sign bit
		xes = ((uint32) (he >> 10)) - 15 + 127; // Exponent unbias the halfp, then bias the single
		xe = (uint32) (xes << 23); // Exponent
		xm = ((uint32) hm) << 13; // Mantissa
		u.u32 = (xs | xe | xm); // Combine sign bit, exponent bits, and mantissa bits
	    }
	}
	return u.f32;
}

//
// convert a float to a halffloat (16-bit float)
//
halffloat
__STX_float_to_halffloat(float f32) {
	uint16    hs, he, hm;
	uint32 x, xs, xe, xm;
	int hes;
	union {
	    uint32 u32;
	    float f32;
	} u;
	halffloat h;

	u.f32 = f32;
	x = u.u32;
	if( (x & 0x7FFFFFFFu) == 0 ) {  // Signed zero
	    h = (uint16) (x >> 16);  // Return the signed zero
	} else { // Not zero
	    xs = x & 0x80000000u;  // Pick off sign bit
	    xe = x & 0x7F800000u;  // Pick off exponent bits
	    xm = x & 0x007FFFFFu;  // Pick off mantissa bits
	    if( xe == 0 ) {  // Denormal will underflow, return a signed zero
		h = (uint16) (xs >> 16);
	    } else if( xe == 0x7F800000u ) {  // Inf or NaN (all the exponent bits are set)
		if( xm == 0 ) { // If mantissa is zero ...
		    h = (uint16) ((xs >> 16) | 0x7C00u); // Signed Inf
		} else {
		    h = (uint16) 0xFE00u; // NaN, only 1st mantissa bit set
		}
	    } else { // Normalized number
		hs = (uint16) (xs >> 16); // Sign bit
		hes = ((int)(xe >> 23)) - 127 + 15; // Exponent unbias the single, then bias the halfp
		if( hes >= 0x1F ) {  // Overflow
		    h = (uint16) ((xs >> 16) | 0x7C00u); // Signed Inf
		} else if( hes <= 0 ) {  // Underflow
		    if( (14 - hes) > 24 ) {  // Mantissa shifted all the way off & no rounding possibility
			hm = (uint16) 0u;  // Set mantissa to zero
		    } else {
			xm |= 0x00800000u;  // Add the hidden leading bit
			hm = (uint16) (xm >> (14 - hes)); // Mantissa
			if( (xm >> (13 - hes)) & 0x00000001u ) // Check for rounding
			    hm += (uint16) 1u; // Round, might overflow into exp bit, but this is OK
		    }
		    h = (hs | hm); // Combine sign bit and mantissa bits, biased exponent is zero
		} else {
		    he = (uint16) (hes << 10); // Exponent
		    hm = (uint16) (xm >> 13); // Mantissa
		    if( xm & 0x00001000u ) // Check for rounding
			h = (hs | he | hm) + (uint16) 1u; // Round, might overflow to inf, this is OK
		    else
			h = (hs | he | hm);  // No rounding
		}
	    }
	}
	return h;
}

%}
! !

!HalfFloatArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by Claus Gittinger
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
    HalfFloatArrays store half precision (16bit) floats (and nothing else).
    HalfFloats were traditionally seldom used, but seem to become more popular
    these days, as some 3D graphics accelerators and game engines use them
    for very dense and compact storage of texture and vertex data.

    Notice, that HalfFloats are not supported as first class objects by the ST/X system;
    i.e. outside of a HalfFloatArray, these values are represented as floats
    or doubles. When accessing a HalfFloatArray's element via getters/setters,
    shortFloat (i.e. single precision 32bit floats) are exchanged.

    Be aware that the numeric range of a half-float is very very limited.

    [memory requirements:]
        OBJ-HEADER + (size * 2)

    [See also:]
        FloatArray DoubleArray Array
        http://www.opengl.org/wiki/Small_Float_Formats

    [author:]
        Claus Gittinger
"
! !

!HalfFloatArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 2 is returned"

    ^ 2
! !

!HalfFloatArray methodsFor:'accessing'!

at:index
%{  /* NOCONTEXT */
    if (__isSmallInteger(index)) {
	int i = __intVal(index);
	int n = __wordArraySize(self);

	if ((unsigned)i <= n) {
	    unsigned short h;
	    OBJ newFloat;
	    float f;

	    h = __WordArrayInstPtr(self)->s_element[i-1];

	    f = __STX_halffloat_to_float(h);
	    __qMKSFLOAT(newFloat, f);
	    RETURN ( newFloat );
	}
    }
%}.
    self primitiveFailed
!

at:index put:aFloat
%{
    if (__isSmallInteger(index)) {
	int i = __intVal(index);
	int n = __wordArraySize(self);

	if ((unsigned)i <= n) {
	    unsigned short h;
	    float f;

	    if (__isFloat(aFloat)) {
		f = (float)(__floatVal(aFloat));
	    } else if (__isShortFloat(aFloat)) {
		f = __shortFloatVal(aFloat);
	    } else if (__isSmallInteger(aFloat)) {
		f = (float)(__intVal(aFloat));
	    } else
		goto error;

	    h = __STX_float_to_halffloat(f);
	    __WordArrayInstPtr(self)->s_element[i-1] = h;
	    RETURN (aFloat);
	}
    }
  error: ;
%}.
    self primitiveFailed
! !

!HalfFloatArray methodsFor:'queries'!

defaultElement
    ^ ShortFloat zero
!

isValidElement:anObject
    "return true, if I can hold this kind of object"

    ^ anObject isNumber
!

numFloats
    ^ self size
! !

!HalfFloatArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

