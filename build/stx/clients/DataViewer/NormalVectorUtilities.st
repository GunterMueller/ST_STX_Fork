"{ NameSpace: TDV }"

TDVObject subclass:#NormalVectorUtilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Utilities'
!


!NormalVectorUtilities class methodsFor:'calculation'!

normale:vector1 arg2:vector2 arg3:vector3
"calculate and return the normal vector (normalized to lenght 1) for the input vectors

<return: Array>
"
    |array delta1x  delta1y delta1z delta2x  delta2y delta2z nx ny nz lenght|

%{  /* OPTIONAL */
    if (@global(UseCCode) != true) goto bad;

    if ( __isFloatArray(vector1)
     && (__floatArraySize(vector1) == 3)
     &&  __isFloatArray(vector2)
     && (__floatArraySize(vector2) == 3)
     &&  __isFloatArray(vector3)
     && (__floatArraySize(vector3) == 3)
    ) {
	double _delta1x, _delta1y, _delta1z;
	double _delta2x, _delta2y, _delta2z;
	double _nx, _ny, _nz, _t;
	double _length;
	extern double sqrt();
	extern OBJ __stFloatArrayFromCFloatArray();
	float _rslt[3];

	_delta1x = __FloatArrayInstPtr(vector1)->f_element[0]
		   - __FloatArrayInstPtr(vector2)->f_element[0];
	_delta1y = __FloatArrayInstPtr(vector1)->f_element[1]
		   - __FloatArrayInstPtr(vector2)->f_element[1];
	_delta1z = __FloatArrayInstPtr(vector1)->f_element[2]
		   - __FloatArrayInstPtr(vector2)->f_element[2];

	_delta2x = __FloatArrayInstPtr(vector2)->f_element[0]
		   - __FloatArrayInstPtr(vector3)->f_element[0];
	_delta2y = __FloatArrayInstPtr(vector2)->f_element[1]
		   - __FloatArrayInstPtr(vector3)->f_element[1];
	_delta2z = __FloatArrayInstPtr(vector2)->f_element[2]
		   - __FloatArrayInstPtr(vector3)->f_element[2];

	_nx = (_delta1y * _delta2z)-(_delta2y * _delta1z);
	_ny = (_delta2x * _delta1z)-(_delta1x * _delta2z);
	_nz = (_delta1x * _delta2y)-(_delta2x * _delta1y);

	_t = (_nx * _nx) + (_ny * _ny) + (_nz * _nz);
	_length = sqrt(_t);
	if (_length == 0.0) goto bad;

	_rslt[0] = _nx / _length;
	_rslt[1] = _ny / _length;
	_rslt[2] = _nz / _length;

	RETURN (__stFloatArrayFromCFloatArray(_rslt, 3));
    }
bad: ;
%}.
"/    Transcript showCR:'oops - slow normale.'.

    array := FloatArray new:3.

    delta1x := (vector1 at:1) - (vector2 at:1).
    delta1y := (vector1 at:2) - (vector2 at:2).
    delta1z := (vector1 at:3) - (vector2 at:3).

    delta2x := (vector2 at:1) - (vector3 at:1).
    delta2y := (vector2 at:2) - (vector3 at:2).
    delta2z := (vector2 at:3) - (vector3 at:3).

    nx := (delta1y * delta2z)-(delta2y * delta1z).
    ny := (delta2x * delta1z)-(delta1x * delta2z).
    nz := (delta1x * delta2y)-(delta2x * delta1y).

    lenght := ((nx * nx) + (ny * ny) + (nz * nz)) sqrt.

    nx := nx / lenght.
    ny := ny / lenght.
    nz := nz / lenght.

    array at:1 put:nx.
    array at:2 put:ny.
    array at:3 put:nz.

    ^array





!

normale:vector1 arg2:vector2 arg3: vector3 into:rslt
"add the vectors and return the normalized result; rslt should be an FoatArray
to use C-Code, at least an aribitary array with size 3.

<return: Array>"

    |delta1x  delta1y delta1z delta2x  delta2y delta2z nx ny nz lenght|

%{  /* OPTIONAL */

    if (1
     && __isFloatArray(vector1)
     && __isFloatArray(vector2)
     && __isFloatArray(vector3)
     && __isFloatArray(rslt)
     && __floatArraySize(vector1) == 3
     && __floatArraySize(vector2) == 3
     && __floatArraySize(vector3) == 3
     && __floatArraySize(rslt) == 3) {
	float _v1_1, _v1_2, _v1_3;
	float _v2_1, _v2_2, _v2_3;
	float _v3_1, _v3_2, _v3_3;
	float _d1x, _d1y, _d1z;
	float _d2x, _d2y, _d2z;
	float _nx, _ny, _nz;
	float _length;
	extern double sqrt();

	_v1_1 = __FloatArrayInstPtr(vector1)->f_element[0];
	_v1_2 = __FloatArrayInstPtr(vector1)->f_element[1];
	_v1_3 = __FloatArrayInstPtr(vector1)->f_element[2];
	_v2_1 = __FloatArrayInstPtr(vector2)->f_element[0];
	_v2_2 = __FloatArrayInstPtr(vector2)->f_element[1];
	_v2_3 = __FloatArrayInstPtr(vector2)->f_element[2];
	_v3_1 = __FloatArrayInstPtr(vector3)->f_element[0];
	_v3_2 = __FloatArrayInstPtr(vector3)->f_element[1];
	_v3_3 = __FloatArrayInstPtr(vector3)->f_element[2];
	_d1x = _v1_1 - _v2_1;
	_d1y = _v1_2 - _v2_2;
	_d1z = _v1_3 - _v2_3;
	_d2x = _v2_1 - _v3_1;
	_d2y = _v2_2 - _v3_2;
	_d2z = _v2_3 - _v3_3;
	_nx = (_d1y * _d2z)-(_d2y * _d1z);
	_ny = (_d2x * _d1z)-(_d1x * _d2z);
	_nz = (_d1x * _d2y)-(_d2x * _d1y);
	_length = sqrt((_nx * _nx) + (_ny * _ny) + (_nz * _nz));
	_nx = _nx / _length;
	_ny = _ny / _length;
	_nz = _nz / _length;
	__FloatArrayInstPtr(rslt)->f_element[0] = _nx;
	__FloatArrayInstPtr(rslt)->f_element[1] = _ny;
	__FloatArrayInstPtr(rslt)->f_element[2] = _nz;
	RETURN (rslt);
    }
%}.

    delta1x := (vector1 at:1) - (vector2 at:1).
    delta1y := (vector1 at:2) - (vector2 at:2).
    delta1z := (vector1 at:3) - (vector2 at:3).

    delta2x := (vector2 at:1) - (vector3 at:1).
    delta2y := (vector2 at:2) - (vector3 at:2).
    delta2z := (vector2 at:3) - (vector3 at:3).

    nx := (delta1y * delta2z)-(delta2y * delta1z).
    ny := (delta2x * delta1z)-(delta1x * delta2z).
    nz := (delta1x * delta2y)-(delta2x * delta1y).

    lenght := ((nx * nx) + (ny * ny) + (nz * nz)) sqrt.

    nx := nx / lenght.
    ny := ny / lenght.
    nz := nz / lenght.

    rslt at:1 put:nx.
    rslt at:2 put:ny.
    rslt at:3 put:nz.

    ^ rslt



! !

!NormalVectorUtilities class methodsFor:'normalization'!

addAndNormalize:aArray
"add the vectors (which are in aArray) and return the normalized result as 
first element of aArray; written in inline c to minimize calculation time

<return: Array | nil>
"
    |arr deltax  deltay deltaz lenght n|

%{  /* OPTIONAL */

    if (@global(UseCCode) != true) goto bad;

    if ( __Class(aArray)==Array) {
	float _deltax, _deltay, _deltaz;
	float _length, _tX, _tY, _tZ;
	double _t;
	extern double sqrt();
	extern OBJ __stFloatArrayFromCFloatArray();
	float _rslt[3];
	int i;

	int _aSz = __arraySize(aArray);                    /* aArray size */
	OBJ _el;

	if (_aSz == 0) {                                   /* aArray isEmpty -> nil */
	    RETURN (nil);
	}
	_el = __ArrayInstPtr(aArray)->a_element[0];        /* aArray at:1 */
	if (! __isFloatArray(_el))
	    goto bad;

	_deltax = __FloatArrayInstPtr(_el)->f_element[0];       /* (aArray at:1) at:1 */
	_deltay = __FloatArrayInstPtr(_el)->f_element[1];       /* (aArray at:1) at:2 */
	_deltaz = __FloatArrayInstPtr(_el)->f_element[2];       /* (aArray at:1) at:3 */

	for (i=1; i<_aSz; i++) {
	    _el = __ArrayInstPtr(aArray)->a_element[i];         /* aArray at:i */
	    if (! __isFloatArray(_el))
		goto bad;

	    _deltax += __FloatArrayInstPtr(_el)->f_element[0];       /* (aArray at:i) at:1 */
	    _deltay += __FloatArrayInstPtr(_el)->f_element[1];       /* (aArray at:i) at:2 */
	    _deltaz += __FloatArrayInstPtr(_el)->f_element[2];       /* (aArray at:i) at:3 */
	}

	_tX = _deltax * _deltax;
	_tY = _deltay * _deltay;
	_tZ = _deltaz * _deltaz;
	_t = _tX + _tY + _tZ;
	_length = (float)(sqrt(_t));

	_rslt[0] = _deltax / _length;
	_rslt[1] = _deltay / _length;
	_rslt[2] = _deltaz / _length;
	RETURN (__stFloatArrayFromCFloatArray(_rslt, 3));
    }
bad: ;
%}.
"/    Transcript showCR:'oops - slow addAndNormalize.'.

    aArray isEmpty ifFalse:[

	arr   := FloatArray new:3.

	deltax := (aArray at:1)at:1.
	deltay := (aArray at:1)at:2.
	deltaz := (aArray at:1)at:3.

	(n := aArray size) > 1 ifTrue:[
	    2 to: n do:[:i|
		|aArrayAtI|

		aArrayAtI := aArray at:i.
		deltax := deltax + (aArrayAtI at:1).
		deltay := deltay + (aArrayAtI at:2).
		deltaz := deltaz + (aArrayAtI at:3).
	    ].
	].

	lenght := ((deltax * deltax) + (deltay * deltay) + (deltaz * deltaz)) sqrt.

	deltax := deltax / lenght.
	deltay := deltay / lenght.
	deltaz := deltaz / lenght.

	arr at:1 put:deltax.
	arr at:2 put:deltay.
	arr at:3 put:deltaz.

	^arr
     ].

     ^ nil


!

addAndNormalize:vector1 arg2:vector2
"add the two vectors and return the normalized result

<return: array>
"
    |array deltax  deltay deltaz lenght|


    array := FloatArray new:3.

    deltax := (vector1 at:1) + (vector2 at:1).
    deltay := (vector1 at:2) + (vector2 at:2).
    deltaz := (vector1 at:3) + (vector2 at:3).

    lenght := ((deltax * deltax) + (deltay * deltay) + (deltaz * deltaz)) sqrt.
    lenght = 0.0 ifTrue:[lenght := 1.0].

    deltax := deltax / lenght.
    deltay := deltay / lenght.
    deltaz := deltaz / lenght.

    array at:1 put:deltax.
    array at:2 put:deltay.
    array at:3 put:deltaz.

    ^array

! !

!NormalVectorUtilities class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/NormalVectorUtilities.st,v 1.3 1999-04-23 15:22:55 cg Exp $'
! !
