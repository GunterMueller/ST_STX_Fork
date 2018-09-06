"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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

AbstractNumberVector variableDoubleSubclass:#DoubleArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Arrayed'
!

!DoubleArray class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
    DoubleArrays store doubleFloat values (and nothing else).
    They have been added to support heavy duty number crunching and
    data exchange with openGL frameworks and other mass data libraries
    somewhat better than other smalltalks do. 
    Storing Floats & Doubles in these objects (instead of Arrays)
    has some benefits:

    1) since the values are stored directly (instead of pointers to them)
       both access overhead and garbage collect overhead is minimized.

    2) they can be much faster passed to c functions (such as graphics 
       libraries or heavy duty math packages), since the double values
       come packed and can be used in C by using a (double *) or double[].
       There is no need to loop over the array extracting doubles.      

    3) they could (in theory) be much more easily be processed by things like
       vector and array processors

    Be aware however, that Float- and DoubleArrays are not supported in other
    smalltalks - your program will thus become somewhat less portable.
    (since their protocol is the same as normal arrays filled with floats,
     they can of course be easily simulated - a bit slower though)

    However, they could be simulated by a ByteArray, using doubleAt: and 
    doubleAtPut: messages to access the elements, but that seems a bit
    clumsy and unelegant. Also, the stc-compiler may learn how to deal
    with Float- and DoubleArrays, making accesses very fast in the future.
    Hint: if you use doubleArrays in your application and must port it
    to some other smalltalk, define a DoubleArray class there, which is derived
    from ByteArray, and add access methods.

    Of course, DoubleArray can be subclassed,
    and named instance variables can be added there.

    See example uses in the GLX interface and GLDemos.

    [memory requirements:]
        OBJ-HEADER + (size * double-size)

    [See also:]
        FloatArray Array

    [author:]
        Claus Gittinger
"
! !



!DoubleArray class methodsFor:'queries'!

elementByteSize
    "for bit-like containers, return the number of bytes stored per element.
     Here, 8 is returned"

    ^ 8

    "Created: / 15-09-2011 / 14:12:46 / cg"
! !


!DoubleArray methodsFor:'queries'!

defaultElement
    ^ Float zero
!

isValidElement:anObject
    "return true, if I can hold this kind of object"

    ^ anObject isNumber
!

max
    "return the largest element;
     redefined for speed"
%{  /* NOCONTEXT */
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz = __doubleArraySize(self);

        if (_sz > 0) {
            double *_p = __DoubleArrayInstPtr(self)->d_element;
            double _max;

            _max = _p[0];
            if (_sz > 1) {
                INT _i;
                double _prev, _this;

                /* how about inline-mmx-asm for this ... */
                _this = _p[1];
                for (_i=2; _i<_sz; _i++) {
                    _prev = _this;
                    _this = _p[_i];
                    if (_prev > _max) _max = _prev;
                }
                if (_this > _max) _max = _this;
            }
            RETURN (__MKFLOAT(_max));
        }
    }
%}.
    ^ super max

    "
     |f1|

     f1 := (1 to:10000) asDoubleArray.
     Time millisecondsToRun:[ 1000 timesRepeat:[ f1 max ] ]
    "
    "
     |a1|

     a1 := (1 to:10000) asArray collect:#asFloat.
     Time millisecondsToRun:[ 1000 timesRepeat:[ a1 max ] ]
    "
    "
     |f1|

     f1 := DoubleArray withAll:#(1 2 3 4 5).
     f1 max
    "
    "
     |f1|

     f1 := DoubleArray withAll:#(5 4 3 2 1).
     f1 max
    "
!

min
    "return the smallest element;
     redefined for speed"
%{  /* NOCONTEXT */
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz = __doubleArraySize(self);

        if (_sz > 0) {
            double *_p = __DoubleArrayInstPtr(self)->d_element;
            double _min;

            _min = _p[0];
            if (_sz > 1) {
                INT _i;
                double _prev, _this;

                /* how about inline-mmx-asm for this ... */
                _this = _p[1];
                for (_i=2; _i<_sz; _i++) {
                    _prev = _this;
                    _this = _p[_i];
                    if (_prev < _min) _min = _prev;
                }
                if (_this < _min) _min = _this;
            }
            RETURN (__MKFLOAT(_min));
        }
    }
%}.
    ^ super min

    "
     |f1|

     f1 := (1 to:10000) asDoubleArray.
     Time millisecondsToRun:[ 1000 timesRepeat:[ f1 min ] ]
    "
    "
     |a1|

     a1 := (1 to:10000) asArray collect:#asFloat.
     Time millisecondsToRun:[ 1000 timesRepeat:[ a1 min ] ]
    "
    "
     |f1|

     f1 := DoubleArray withAll:#(1 2 3 4 5).
     f1 min
    "
    "
     |f1|

     f1 := DoubleArray withAll:#(5 4 3 2 1).
     f1 min
    "
!

minMax
    "return a Tuple holding the smallest and largest element;
     redefined for speed"

    |min max empty|

%{  
    if (__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0)) {
        INT _sz = __doubleArraySize(self);

        if (_sz > 0) {
            INT _i;
            double *_p = __DoubleArrayInstPtr(self)->d_element;
            double _min, _max;
            OBJ ret;
            
            _min = _max = _p[0];
            for (_i=_sz-1; _i>0; _i-=2) {
                double _v1 = _p[_i];
                double _v2 = _p[_i-1];
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
    "/ fallback if no primitive code
    ^ super minMax

    "
     |f1|

     f1 := (1 to:10000) asDoubleArray.
     Time millisecondsToRun:[ 1000 timesRepeat:[ f1 minMax ] ]
    "
    "
     |f1|

     f1 := (1 to:10000) asDoubleArray.
     Time millisecondsToRun:[ 1000 timesRepeat:[ f1 min ] ]
    "
    "
     |f1|

     f1 := DoubleArray withAll:#(1 2 3 4 5).
     f1 minMax
    "
    "
     |f1|

     f1 := DoubleArray withAll:#(5 4 3 2 1).
     f1 minMax
    "
! !

!DoubleArray methodsFor:'vector arithmetic'!

dot: aFloatVector
    "Return the dot product of the receiver and the argument.
     Raises an error, if the argument is not of the same size as the receiver."

    | mySize result |

%{
    if ((__ClassInstPtr(__qClass(self))->c_ninstvars == __mkSmallInteger(0))
     && (__ClassInstPtr(__qClass(aFloatVector))->c_ninstvars == __mkSmallInteger(0))) {
        INT __mySize = __doubleArraySize(self);
        double __result = 0.0;
        double *__p1 = __DoubleArrayInstPtr(self)->d_element;

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
        INT __mySize = __doubleArraySize(self);
        double *__elements = __DoubleArrayInstPtr(self)->d_element;
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
     v := #(2.0 3.0 4.0) asDoubleArray.
     v  hornerMultiplyAndAdd:10.
    
     |v|
     v := Array new:100 withAll:2.0.
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


!DoubleArray class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

