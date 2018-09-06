"
 The above file is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help 
"

"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

Object subclass:#Fractal
	instanceVariableNames:'matrix'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

Point subclass:#Point3D
	instanceVariableNames:'z'
	classVariableNames:'RandomSource'
	poolDictionaries:''
	privateIn:Fractal
!

!Fractal class methodsFor:'documentation'!

copyright
"
 The above file is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help 
"
!

documentation
"
	NAME            fractal
	AUTHOR          unknown
	FUNCTION        Fractals
	ST-VERSION      
	PREREQUISITES   
	CONFLICTS       
	DISTRIBUTION    world
	VERSION         1
	DATE     1991
	SUMMARY

    a Demo displaying a fractal mountain (on the root-window).

    [start with:]
	Fractal example5
"
! !

!Fractal class methodsFor:'examples'!

example1
        | f v |
        Cursor execute showWhile:
                [ f _ self new.
                f firstLevel.
                3 timesRepeat: [ f nextLevel ] ].
        v := DisplayRootView new.
        v clippedByChildren:true.
        v white.
        f displayOn:v.

        "/ Warning: not all window managers allow drawing into the root window.
        
        "Fractal example1"
!

example2
        | f v |
        Cursor execute showWhile:
                [ f _ self new.
                f firstLevel.
                4 timesRepeat: [ f nextLevel ] ].
        v := DisplayRootView new.
        v clippedByChildren:true.
        v white.
        f displayOn:v.

        "/ Warning: not all window managers allow drawing into the root window.

        "Fractal example2"
!

example3
        | f v |
        Cursor execute showWhile:
                [ f _ self new.
                f firstLevel.
                5 timesRepeat: [ f nextLevel ] ].
        v := DisplayRootView new.
        v clippedByChildren:true.
        v white.
        f displayOn:v.

        "/ Warning: not all window managers allow drawing into the root window.

        "Fractal example3"
!

example4
        | f v |
        Cursor execute showWhile:
                [ f _ self new.
                f firstLevel.
                6 timesRepeat: [ f nextLevel ] ].
        v := DisplayRootView new.
        v clippedByChildren:true.
        v white.
        f displayOn:v.

        "/ Warning: not all window managers allow drawing into the root window.

        "Fractal example4"
!

example5
	| f v b|

	v := StandardSystemView new extent:500@400.
	b := Button 
		      label:'generate'
		      action:[|f|
			      v cursor:(Cursor execute).
			      f _ self new.
			      f firstLevel.
			      5 timesRepeat: [ f nextLevel ].
			      v white.
			      f displayOn:v.
			      v cursor:(Cursor normal)
			     ]
		      in:v.
	v open

	"Fractal example5"
! !

!Fractal methodsFor:'displaying'!

displayOn: aDisplayMedium
	| size |
	size _ matrix size.

	aDisplayMedium paint:(Color black).
	1 to: size do: [ :m |
	    1 to: m do: [ :n |
		(m < size) ifTrue:[
		    aDisplayMedium displayLineFrom: ((matrix at: m) at: n) asProjectedPoint
						to: ((matrix at: m + 1) at: n) asProjectedPoint.
		    aDisplayMedium displayLineFrom: ((matrix at: m) at: n) asProjectedPoint
						to: ((matrix at: m + 1) at: n + 1) asProjectedPoint. 
		].
		(n < m) ifTrue:[
		    aDisplayMedium displayLineFrom: ((matrix at: m) at: n) asProjectedPoint
						to: ((matrix at: m) at: n + 1) asProjectedPoint. 
		] 
	    ] 
	].
! !

!Fractal methodsFor:'generating'!

firstLevel
	matrix _ Array
		with: (Array with: (Point3D x:256 y:20 z:0))
		with: (Array with: (Point3D x:56 y:280 z:0)
			     with: (Point3D x:456 y:280 z:0)).
!

nextLevel
	| newMatrix oldSize newSize l1 l2 l3 |
	oldSize _ matrix size.
	newSize _ oldSize * 2 - 1.
	l1 _ 200.4 / oldSize.
	l2 _ l1.
	l3 _ 241.7 / oldSize.

	newMatrix _ Array new: newSize.
	1 to: newSize do: [ :i |
		newMatrix at: i put: (Array new: i) ].

	oldSize to: 1 by: -1 do: [ :m |
		m to: 1 by: -1 do: [ :n |
			(newMatrix at: m * 2 - 1) at: n * 2 - 1 put: ((matrix at: m) at: n) ] ].

	3 to: newSize by: 2 do: [ :m |
		1 to: m - 2 by: 2 do: [ :n |
			(newMatrix at: m) at: n + 1 put:
				(((newMatrix at: m) at: n) middle: ((newMatrix at: m) at: n + 2)
					displaced: l3) ] ].

	1 to: newSize - 2 by: 2 do: [ :m |
		1 to: m by: 2 do: [ :n |
			(newMatrix at: m + 1) at: n put:
				(((newMatrix at: m) at: n) middle: ((newMatrix at: m + 2) at: n)
					displaced: l1).
			(newMatrix at: m + 1) at: n + 1  put:
				(((newMatrix at: m) at: n) middle: ((newMatrix at: m + 2) at: n + 2)
					displaced: l2) ] ].

	matrix _ newMatrix.
! !

!Fractal::Point3D class methodsFor:'documentation'!

documentation
"
 a helper class for Fractal
"
! !

!Fractal::Point3D class methodsFor:'instance creation'!

x: xValue y: yValue z: zValue
	"Answer an instance of me with coordinates xValue, yValue, and zValue."

	^self new setX: xValue setY: yValue setZ: zValue
! !

!Fractal::Point3D methodsFor:'accessing'!

z
	^ z
!

z: value
	^ z _ value
! !

!Fractal::Point3D methodsFor:'converting'!

asProjectedPoint
	"Translate to 2D (integral) coordinates with some rotation.
	Answer integer coordinates cause bitblt likes it that way."

	| newX newY|
	newX _ x.
	newY _ y - (1.125 * z) truncated.
	^ newX @ newY
!

middle: otherPoint displaced: range
        "Answer a point in the middle, randomly displaced.
        Keep coordinates integral for speed only."

        | newX newY newZ |
        RandomSource isNil ifTrue:[
            RandomSource := Random new
        ].
        newX _ (x + otherPoint x) // 2.
        newY _ (y + otherPoint y) // 2.
        newZ _ (z + otherPoint z) // 2.
        newZ _ newZ + (RandomSource next - 0.5 * range) truncated.
        ^ self class x: newX y: newY z: newZ
! !

!Fractal::Point3D methodsFor:'printing'!

printOn: aStream 
	"The receiver prints on aStream in terms of infix notation."

	x printOn: aStream.
	aStream nextPut: $@.
	y printOn: aStream.
	aStream nextPut: $@.
	z printOn: aStream
! !

!Fractal::Point3D methodsFor:'private'!

setX: xValue setY: yValue setZ: zValue

	x _ xValue.
	y _ yValue.
	z _ zValue
! !

!Fractal class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Fractal-Fractal.st,v 1.8 2002-10-30 13:29:55 cg Exp $'
! !
