"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: Smalltalk }"

FloatArray variableFloatSubclass:#GLPoint3D
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-3D-Support'
!

!GLPoint3D class methodsFor:'documentation'!

documentation
"
    since the GL graphics library performs better if coordinates
    are passed as a 3-element float array (in C), this class
    provides the required smalltalk class.
    Thus, coordinates can be passed to GL without any need for data conversion.

    Instances are used as dataHolders for GL only - 
    there is no semantic whatsoever in this class.

    [See also:]
        GLXView GLXWorkstation

"
! !

!GLPoint3D class methodsFor:'instance creation'!

new
    "return a new uninitialized instance"

    ^ self basicNew:3
!

x:x y:y
    "return a new instance initialized to (x @ y @ 0.0)"

    ^ (self new) x:x y:y z:0.0
!

x:x y:y z:z
    "return a new instance initialized to (x @ y @ z)"

    ^ (self new) x:x y:y z:z
! !

!GLPoint3D methodsFor:'accessing'!

x
    "return the x coordinate"

    ^ self basicAt:1
!

x:aFloat
    "set the x coordinate"

    ^ self basicAt:1 put:aFloat asFloat
!

x:x y:y z:z
    "set all 3 coordinates"

    self basicAt:1 put:x asFloat.
    self basicAt:2 put:y asFloat.
    self basicAt:3 put:z asFloat.
!

y
    "return the y coordinate"

    ^ self basicAt:2
!

y:aFloat
    "set the y coordinate"

    ^ self basicAt:2 put:aFloat asFloat
!

z
    "return the z coordinate"

    ^ self basicAt:3
!

z:aFloat
    "set the z coordinate"

    ^ self basicAt:3 put:aFloat asFloat
! !

!GLPoint3D class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLPoint3D.st,v 1.7 2016-01-21 18:06:00 cg Exp $'
! !

