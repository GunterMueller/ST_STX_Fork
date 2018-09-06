"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

AbstractNumberVector variableFloatSubclass:#FloatArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!FloatArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    FloatArrays store floats (and nothing else).
    They have been added to support heavy duty number crunching and
    data exchange with openGL frameworks and other mass data libraries.
    See documentation in DoubleArray for more information.

    [memory requirements:]
        OBJ-HEADER + (size * float-size)

    [See also:]
        DoubleArray Array

    [author:]
        Claus Gittinger
"
! !



!FloatArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 4 is returned"

    ^ 4

    "Created: / 15-09-2011 / 14:12:39 / cg"
! !


!FloatArray methodsFor:'copying'!

clone
    "return a copy of the receiver"

    |newArr|

    newArr := self class new:(self size).
%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz = __floatArraySize(self);

        bcopy(__FloatArrayInstPtr(self)->f_element,
              __FloatArrayInstPtr(newArr)->f_element,
              sizeof(float) * _sz);

        RETURN (newArr);
    }
%}.
    newArr replaceFrom:1 to:self size with:self startingAt:1.
    ^ newArr

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f1 clone
    "
!

copyFrom:start to:stop
    "return a partial copy of the receiver"

%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        if (__bothSmallInteger(start, stop)) {
            INT __start = __intVal(start) - 1;
            INT __stop = __intVal(stop) - 1 ;

            if (__stop >= __start) {
                INT __sz = __floatArraySize(self);
                // printf("o_size=%d floatArraySize=%d\n", __qSize(self), __sz);

                if (((unsigned INT)__start < __sz)
                 && ((unsigned INT)__stop < __sz)) {
                    INT __n = __stop - __start + 1;
                    OBJ __nObj;
                    int nBytes;

                    // don't do this; sizeof returns the padded size!
                    // nBytes = sizeof(struct __FloatArray) + (__n - 1) * sizeof(float);
                    nBytes = OHDR_SIZE + (__n * sizeof(float));

                    // printf("__n=%d nBytes=%d\n", __n, nBytes);
                    __nObj = __STX___new(nBytes);
                    if (__nObj != nil) {
                        __objPtr(__nObj)->o_class = __qClass(self);
                        __STORE(__nObj, __qClass(self));
                        bcopy(__FloatArrayInstPtr(self)->f_element + __start,
                              __FloatArrayInstPtr(__nObj)->f_element,
                              sizeof(float) * __n);
                        RETURN(__nObj);
                    }
                }
            }
        }
    }
%}.
    ^ super copyFrom:start to:stop

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5 6).
     f2 := f1 copyFrom:2 to:4.
     f2
    "
!

replaceFrom:start to:stop with:aCollection startingAt:replStart
%{
    if ((__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0))
         && __isFloats(aCollection)
         && (__ClassInstPtr(__qClass(aCollection))->c_ninstvars == __mkSmallInteger(0))
         && __bothSmallInteger(start, stop)
         && __isSmallInteger(replStart)
    ) {
        INT __start = __intVal(start) - 1;
        INT __stop = __intVal(stop) - 1 ;
        INT __replStart = __intVal(replStart) - 1 ;

        if (__stop >= __start) {
            INT __sz = __floatArraySize(self);
            INT __otherSz = __floatArraySize(aCollection);
            INT __replStop = __replStart + (__stop-__start);

            if (((unsigned INT)__start < __sz)
             && ((unsigned INT)__stop < __sz)
             && ((unsigned INT)__replStart < __otherSz)
             && ((unsigned INT)__replStop < __otherSz)) {
                INT __n = __stop - __start + 1;

                if (aCollection == self) {
                    memmove(&(__FloatArrayInstPtr(self)->f_element[__start]),
                            &(__FloatArrayInstPtr(aCollection)->f_element[__replStart]),
                            sizeof(float) * __n);
                } else {
                    memcpy(&(__FloatArrayInstPtr(self)->f_element[__start]),
                           &(__FloatArrayInstPtr(aCollection)->f_element[__replStart]),
                           sizeof(float) * __n);
                }
                RETURN(self);
            }
        }
    }
%}.
    ^ super replaceFrom:start to:stop with:aCollection startingAt:replStart

    "
     |f1 f2|

     f1 := (1 to:5) asFloatArray.
     f2 := #(10 9 8 7 6) asFloatArray.
     f1 replaceFrom:1 to:3 with:f2 startingAt:3
    "
! !

!FloatArray methodsFor:'destructive arithmetic support'!

primAbs
    "destructive absolute value of each element"

%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz = __floatArraySize(self);
        INT i;
        float *_p = __FloatArrayInstPtr(self)->f_element;
        float prev_p;

        if (_sz > 0) {
            /* how about inline-mmx-asm for this ... */
            prev_p = _p[0];
            for (i=1; i<_sz; i++) {
                float next_p = _p[i];

                if (prev_p < 0) {
                    _p[i-1] = -prev_p;
                }
                prev_p = next_p;
            }
            if (prev_p < 0) {
                _p[i-1] = -prev_p;
            }
        }
        RETURN (self);
    }
%}.
    super primAbs

    "
     |f|

     f := FloatArray withAll:#(-1 2 -3 4 -5).
     f abs.
     f
    "

    "Created: / 30-05-2007 / 17:50:17 / cg"
!

primAddArray: floatArray
    "add the vector argument into the receiver (destructive).
     The argument must be another vector"

%{
    if ((__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0))
     && __isFloats(floatArray)
     && (__ClassInstPtr(__qClass(floatArray))->c_ninstvars == __mkSmallInteger(0))) {
        INT _sz1 = __floatArraySize(self);
        INT _sz2 = __floatArraySize(floatArray);
        INT i;
        float *_p1 = __FloatArrayInstPtr(self)->f_element;
        float *_p2 = __FloatArrayInstPtr(floatArray)->f_element;

        if (_sz1 > 0) {
            if (_sz2 >= _sz1) {
                /* how about inline-mmx-asm for this ... */
                float prev_p1 = _p1[0];
                float prev_p2 = _p2[0];

                for (i=1; i<_sz1; i++) {
                    float next_p1 = _p1[i];
                    float next_p2 = _p2[i];
                    _p1[i-1] = prev_p1 + prev_p2;
                    prev_p1 = next_p1;
                    prev_p2 = next_p2;
                }
                _p1[i-1] = prev_p1 + prev_p2;
            }
        }
        RETURN (self);
    }
%}.
    super primAddArray:floatArray

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f2 := FloatArray withAll:#(2 2 2 3 3).
     f1 += f2.
     f1
    "
!

primAddScalar: aScalar
    "add the scalar argument into the receiver (destructive)."

%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz1 = __floatArraySize(self);
        INT i;
        float *_p1 = __FloatArrayInstPtr(self)->f_element;
        float v;
        float prev_p1;

        if (_sz1 > 0) {
            if (__isFloat(aScalar)) {
                v = (float)(__floatVal(aScalar));
            } else  if (__isShortFloat(aScalar)) {
                v = __shortFloatVal(aScalar);
            } else if (__isSmallInteger(aScalar)) {
                v = (float)(__intVal(aScalar));
            } else
                goto badArg;

            /* how about inline-mmx-asm for this ... */
            prev_p1 = _p1[0];
            for (i=1; i<_sz1; i++) {
                float next_p1 = _p1[i];
                _p1[i-1] = prev_p1 + v;
                prev_p1 = next_p1;
            }
            _p1[i-1] = prev_p1 + v;
        }
        RETURN (self);
    }
    badArg: ;
%}.
    super primAddScalar:aScalar

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f1 += 2.0.
     Transcript showCR:f1.
     f1 += 2.0 asShortFloat.
     Transcript showCR:f1.
     f1 += 2.
     Transcript showCR:f1.
    "
!

primDivArray: floatArray
    "divide the vector argument into the receiver (destructive).
     The argument must be another vector"

%{
    if ((__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0))
     && __isFloats(floatArray)
     && (__ClassInstPtr(__qClass(floatArray))->c_ninstvars == __mkSmallInteger(0))) {
        INT _sz1 = __floatArraySize(self);
        INT _sz2 = __floatArraySize(floatArray);
        INT i;
        float *_p1 = __FloatArrayInstPtr(self)->f_element;
        float *_p2 = __FloatArrayInstPtr(floatArray)->f_element;

        if (_sz1 > 0) {
            if (_sz2 >= _sz1) {
                /* how about inline-mmx-asm for this ... */
                float prev_p1 = _p1[0];
                float prev_p2 = _p2[0];

                for (i=1; i<_sz1; i++) {
                    float next_p1 = _p1[i];
                    float next_p2 = _p2[i];
                    _p1[i-1] = prev_p1 / prev_p2;
                    prev_p1 = next_p1;
                    prev_p2 = next_p2;
                }
                _p1[i-1] = prev_p1 / prev_p2;
            }
        }
        RETURN (self);
    }
%}.
    super primDivArray: floatArray

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f2 := FloatArray withAll:#(2 2 2 3 3).
     f1 /= f2.
     f1
    "

    "Modified: / 29-05-2007 / 16:01:34 / cg"
!

primDivScalar: aScalar
    "divide the scalar argument into the receiver (destructive)."

%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz1 = __floatArraySize(self);
        INT i;
        float *_p1 = __FloatArrayInstPtr(self)->f_element;
        float v;
        float prev_p1;

        if (_sz1 > 0) {
            if (__isFloat(aScalar)) {
                v = (float)(__floatVal(aScalar));
            } else  if (__isShortFloat(aScalar)) {
                v = __shortFloatVal(aScalar);
            } else if (__isSmallInteger(aScalar)) {
                v = (float)(__intVal(aScalar));
            } else
                goto badArg;

            /* how about inline-mmx-asm for this ... */
            prev_p1 = _p1[0];
            for (i=1; i<_sz1; i++) {
                float next_p1 = _p1[i];
                _p1[i-1] = prev_p1 / v;
                prev_p1 = next_p1;
            }
            _p1[i-1] = prev_p1 / v;
        }
        RETURN (self);
    }
    badArg: ;
%}.
    super primDivScalar:aScalar

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f1 /= 2.0.
     Transcript showCR:f1.
     f1 /= 2.0 asShortFloat.
     Transcript showCR:f1.
     f1 /= 2.
     Transcript showCR:f1.
    "

    "Modified: / 29-05-2007 / 16:01:39 / cg"
!

primMulArray: floatArray
    "multiply the vector argument into the receiver (destructive).
     The argument must be another vector"

%{
    if ((__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0))
     && __isFloats(floatArray)
     && (__ClassInstPtr(__qClass(floatArray))->c_ninstvars == __mkSmallInteger(0))) {
        INT _sz1 = __floatArraySize(self);
        INT _sz2 = __floatArraySize(floatArray);
        INT i;
        float *_p1 = __FloatArrayInstPtr(self)->f_element;
        float *_p2 = __FloatArrayInstPtr(floatArray)->f_element;

        if (_sz1 > 0) {
            if (_sz2 >= _sz1) {
                float prev_p1 = _p1[0];
                float prev_p2 = _p2[0];

                for (i=1; i<_sz1; i++) {
                    float next_p1 = _p1[i];
                    float next_p2 = _p2[i];
                    _p1[i-1] = prev_p1 * prev_p2;
                    prev_p1 = next_p1;
                    prev_p2 = next_p2;
                }
                _p1[i-1] = prev_p1 * prev_p2;
            }
        }
        RETURN (self);
    }
%}.
    super primMulArray: floatArray

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f2 := FloatArray withAll:#(2 2 2 3 3).
     f1 *= f2.
     f1
    "
!

primMulScalar: aScalar
    "multiply the scalar argument into the receiver (destructive)."

%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz1 = __floatArraySize(self);
        INT i;
        float *_p1 = __FloatArrayInstPtr(self)->f_element;
        float v;
        float prev_p1;

        if (_sz1 > 0) {
            if (__isFloat(aScalar)) {
                v = (float)(__floatVal(aScalar));
            } else  if (__isShortFloat(aScalar)) {
                v = __shortFloatVal(aScalar);
            } else if (__isSmallInteger(aScalar)) {
                v = (float)(__intVal(aScalar));
            } else
                goto badArg;

            /* how about inline-mmx-asm for this ... */
            prev_p1 = _p1[0];
            for (i=1; i<_sz1; i++) {
                float next_p1 = _p1[i];
                _p1[i-1] = prev_p1 * v;
                prev_p1 = next_p1;
            }
            _p1[i-1] = prev_p1 * v;
        }
        RETURN (self);
    }
    badArg: ;
%}.
    super primMulScalar:aScalar

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f1 *= 2.0.
     Transcript showCR:f1.
     f1 *= 2.0 asShortFloat.
     Transcript showCR:f1.
     f1 *= 2.
     Transcript showCR:f1.
    "
!

primNegated
    "destructive negative value of each element"

%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz = __floatArraySize(self);
        INT i;
        float *_p = __FloatArrayInstPtr(self)->f_element;
        float prev_p;

        if (_sz > 0) {
            /* how about inline-mmx-asm for this ... */
            prev_p = _p[0];
            for (i=1; i<_sz; i++) {
                float next_p = _p[i];

                _p[i-1] = -prev_p;
                prev_p = next_p;
            }
            _p[i-1] = -prev_p;
        }
        RETURN (self);
    }
%}.
    super primNegated

    "
     |f|

     f := FloatArray withAll:#(-1 2 -3 4 -5).
     f negated.
     f
    "

    "Created: / 30-05-2007 / 17:51:29 / cg"
!

primSubtractArray: floatArray
    "subtract the vector argument from the receiver (destructive).
     The argument must be another vector"

%{
    if ((__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0))
     && __isFloats(floatArray)
     && (__ClassInstPtr(__qClass(floatArray))->c_ninstvars == __mkSmallInteger(0))) {
        INT _sz1 = __floatArraySize(self);
        INT _sz2 = __floatArraySize(floatArray);
        INT i;
        float *_p1 = __FloatArrayInstPtr(self)->f_element;
        float *_p2 = __FloatArrayInstPtr(floatArray)->f_element;

        if (_sz1 > 0) {
            if (_sz2 >= _sz1) {
                float prev_p1 = _p1[0];
                float prev_p2 = _p2[0];

                for (i=1; i<_sz1; i++) {
                    float next_p1 = _p1[i];
                    float next_p2 = _p2[i];
                    _p1[i-1] = prev_p1 - prev_p2;
                    prev_p1 = next_p1;
                    prev_p2 = next_p2;
                }
                _p1[i-1] = prev_p1 - prev_p2;
            }
        }
        RETURN (self);
    }
%}.
    super primSubtractArray: floatArray

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f2 := FloatArray withAll:#(2 2 2 3 3).
     f1 -= f2.
     f1
    "

    "Created: / 30-05-2007 / 17:42:41 / cg"
!

primSubtractScalar: aScalar
    "subtract the scalar argument from the receiver (destructive)."

%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz1 = __floatArraySize(self);
        INT i;
        float *_p1 = __FloatArrayInstPtr(self)->f_element;
        float v;
        float prev_p1;

        if (_sz1 > 0) {
            if (__isFloat(aScalar)) {
                v = (float)(__floatVal(aScalar));
            } else  if (__isShortFloat(aScalar)) {
                v = __shortFloatVal(aScalar);
            } else if (__isSmallInteger(aScalar)) {
                v = (float)(__intVal(aScalar));
            } else
                goto badArg;

            /* how about inline-mmx-asm for this... ? */
            prev_p1 = _p1[0];
            for (i=1; i<_sz1; i++) {
                float next_p1 = _p1[i];
                _p1[i-1] = prev_p1 - v;
                prev_p1 = next_p1;
            }
            _p1[i-1] = prev_p1 - v;
        }
        RETURN (self);
    }
    badArg: ;
%}.
    super primSubtractScalar:aScalar

    "
     |f1 f2|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f1 -= 2.0.
     Transcript showCR:f1.
     f1 -= 2.0 asShortFloat.
     Transcript showCR:f1.
     f1 -= 2.
     Transcript showCR:f1.
    "

    "Created: / 30-05-2007 / 17:43:06 / cg"
! !

!FloatArray methodsFor:'queries'!

defaultElement
    ^ ShortFloat zero
!

isValidElement:anObject
    "return true, if I can hold this kind of object"

    ^ anObject isNumber
!

minMax
    "return a Tuple holding the smallest and largest element;
     redefined for speed"

    |min max empty|

%{
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz = __floatArraySize(self);
        
        if (_sz > 0) {
            INT _i;
            float *_p = __FloatArrayInstPtr(self)->f_element;
            float _min, _max;
            OBJ retVal;
            
            _min = _max = _p[0];
            for (_i=_sz-1; _i>0; _i-=2) {
                float _v1 = _p[_i];
                float _v2 = _p[_i-1];
                if (_v1 < _v2) {
                    if (_v1 < _min) _min = _v1;
                    if (_v2 > _max) _max = _v2;
                } else {
                    if (_v2 < _min) _min = _v2;
                    if (_v1 > _max) _max = _v1;
                }
            }

            min = __MKFLOAT(_min);
            __PROTECT__(min);
            max = __MKFLOAT(_max);
            __UNPROTECT__(min);
            RETURN (__ARRAY_WITH2(min, max));
        }
        empty = true;
    }
%}.
    empty == true ifTrue:[
        ^ self emptyCollectionError.
    ].
    ^ Array with:(self min) with:(self max)

    "
     |f1|

     f1 := (1 to:10000) asFloatArray.
     Time millisecondsToRun:[ 1000 timesRepeat:[ f1 minMax ] ]
    "
    "
     |f1|

     f1 := FloatArray withAll:#(1 2 3 4 5).
     f1 minMax
    "
    "
     |f1|

     f1 := FloatArray withAll:#(1 2 3 4).
     f1 minMax
    "
    "
     |f1|

     f1 := FloatArray withAll:#(5 4 3 2 1).
     f1 minMax
    "

    "Modified (comment): / 07-10-2011 / 13:03:30 / cg"
!

numFloats
    ^ self size
! !

!FloatArray methodsFor:'vector arithmetic'!

dot: aFloatVector
    "Return the dot product of the receiver and the argument.
     Raises an error, if the argument is not of the same size as the receiver."

    | mySize result |

"/    <primitive:'primitiveDotProduct' module: 'FloatArrayPlugin'>
%{
    if ((__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0))
     && (__ClassInstPtr(__qClass(aFloatVector))->c_ninstvars == __mkSmallInteger(0))) {
        INT __mySize = __floatArraySize(self);
        double __result = 0.0;
        float *__p1 = __FloatArrayInstPtr(self)->f_element;

        if (__mySize > 0) {
            if (__isFloats(aFloatVector)) {
                INT __otherSize = __floatArraySize(aFloatVector);

                if (__mySize == __otherSize) {
                    float *__p2 = __FloatArrayInstPtr(aFloatVector)->f_element;
                    INT __i;
                    /* how about inline-mmx-asm for this ... */
                    for (__i=0; __i<__mySize; __i++) {
                        __result += (__p1[__i] * __p2[__i]);
                    }
                    RETURN (__MKFLOAT(__result));
                }
            } else if (__isDoubles(aFloatVector)) {
                INT __otherSize = __doubleArraySize(aFloatVector);

                if (__mySize == __otherSize) {
                    double *__p2 = __DoubleArrayInstPtr(aFloatVector)->d_element;
                    INT __i;
                    /* how about inline-mmx-asm for this ... */
                    for (__i=0; __i<__mySize; __i++) {
                        __result += (__p1[__i] * __p2[__i]);
                    }
                    RETURN (__MKFLOAT(__result));
                }
            }
        }
    }
%}.
    ^ super dot:aFloatVector

    "
     |v|
     v := #(2.0 2.0 1.0) asFloatArray.
     v dot:v.

     |v|
     v := #(2.0 2.0 1.0) asDoubleArray.
     v dot:v.

     |v|
     v := #(2.0 2.0 1.0).
     v dot:v.

     |v1 v2|
     v1 := #(2.0 2.0 1.0) asFloatArray.
     v2 := #(2.0 2.0 1.0) asDoubleArray.
     v1 dot:v2.

     |v1 v2|
     v1 := #(2.0 2.0 1.0) asDoubleArray.
     v2 := #(2.0 2.0 1.0) asFloatArray.
     v1 dot:v2.

     |v1 v2|
     v1 := #(2.0 2.0 1.0).
     v2 := #(2.0 2.0 1.0) asFloatArray.
     v1 dot:v2.

     |v1 v2|
     v1 := #(2.0 2.0 1.0) asFloatArray.
     v2 := #(2.0 2.0 1.0).
     v1 dot:v2.

     |v1 v2|
     v1 := #(2.0 2.0 1.0).
     v2 := #(2.0 2.0 1.0) asDoubleArray.
     v1 dot:v2.

     |v1 v2|
     v1 := #(2.0 2.0 1.0) asDoubleArray.
     v2 := #(2.0 2.0 1.0).
     v1 dot:v2.
    "

    "
     |v1 v2|

     v1 := Array new:10000 withAll:2.
     v2 := Array new:10000 withAll:3.
     Time millisecondsToRun:[
        10000 timesRepeat:[
          v1 dot:v2.
        ]
     ]
    "
    "
     |v1 v2|

     v1 := FloatArray new:10000 withAll:2.
     v2 := FloatArray new:10000 withAll:3.
     Time millisecondsToRun:[
        10000 timesRepeat:[
          v1 dot:v2.
        ]
     ]
    "

    "
     |v1 v2|
     v1 := #(2.0 2.0 1.0) asFloatArray.
     v2 := #(2.0 2.0 1.0 0.0) asDoubleArray.
     v1 dot:v2.
    "


    "Created: / 29-05-2007 / 13:13:39 / cg"
!

hornerMultiplyAndAdd:x
    "primitive support for horner's-method computation of polynomials.
     The vector is interpreted as providing the factors for a polynomial,
        an*x^n + (an-1)*x^(n-1) + ... + a2(x) + a1
     where the ai are the elements of the Array.
     The highest rank factor is at the first position, the 0-rank constant at last.
     This is inlined c-code, which may get compiled to fast machine code,
     using multiply-and-add or vector instructions, if the CPU/Compiler support them."

    | mySize result |

%{
    double __x;

    if (__isFloat(x)) {
        __x = __floatVal(x);
    } else if (__isShortFloat(x)) {
        __x = (double)__shortFloatVal(x);
    } else if (__isSmallInteger(x)) {
        __x = (double)(__intVal(x));
    } else {
        goto getOutOfHere;
    }

    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT __mySize = __floatArraySize(self);
        float *__elements = __FloatArrayInstPtr(self)->f_element;
        double __result = __elements[0];

        if (__mySize > 1) {
            INT __i;
            /* how about inline-mmx-asm for this ... */
            for (__i=1; __i<__mySize; __i++) {
                __result = (__result * __x) + __elements[__i];
            }
        }
        RETURN (__MKFLOAT(__result));
    }
getOutOfHere: ;
%}.
    ^ super hornerMultiplyAndAdd:x

    "
     |v|
     v := #(2.0 3.0 4.0) asFloatArray.
     v  hornerMultiplyAndAdd:10.

     |v|
     v := Array new:100 withAll:2.0.
     v hornerMultiplyAndAdd:10

     |v|
     v := FloatArray new:100 withAll:2.0.
     v hornerMultiplyAndAdd:10

     |v|
     v := Array new:100 withAll:2.0.
     Time millisecondsToRun:[
        10000 timesRepeat:[ v hornerMultiplyAndAdd:10]
     ]

     |v|
     v := FloatArray new:100 withAll:2.
     Time millisecondsToRun:[
        10000 timesRepeat:[ v hornerMultiplyAndAdd:10]
     ]

     |v|
     v := DoubleArray new:100 withAll:2.
     Time millisecondsToRun:[
        10000 timesRepeat:[ v hornerMultiplyAndAdd:10]
     ]
    "
! !


!FloatArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

