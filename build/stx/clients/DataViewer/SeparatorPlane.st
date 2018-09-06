"{ NameSpace: TDV }"

DrawableComponent subclass:#SeparatorPlane
	instanceVariableNames:'vf3 vf4 x y z intensity'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Components'
!


!SeparatorPlane methodsFor:'initialization'!

initialize
"setup up default values

<return: self>
"    
    super initialize.
    "initialize variables"
    x    := 0.0.
    y    := 0.0.
    z    := 0.0.
    intensity := 0.0.



! !

!SeparatorPlane methodsFor:'protocol'!

copyAspects
"store an aspect identified by its symbol and its value to a local varibale

<return: self>
"   
    |aspect|
    (aspect := globalAspectsIdentDic at:#x ifAbsent:[nil]) notNil
	ifTrue:[x := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#y ifAbsent:[nil]) notNil
	ifTrue:[y := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#z ifAbsent:[nil]) notNil
	ifTrue:[z := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#intensity ifAbsent:[nil]) notNil
	ifTrue:[intensity := aspect.initialized := false].
    globalAspectsIdentDic removeAll

!

draw

    |zN vector vector4f color|

"/    gl glEnableIS: gl GL_POLYGON_OFFSET_FILL.
"/    gl glPolygonOffsetForFactorFS:2.0
"/                          unitsFS:0.0.


    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.

    vector4f:= FloatArray new:4.

    vector4f at:1 put:1.0.
    vector4f at:2 put:1.0.
    vector4f at:3 put:1.0.
    vector4f at:4 put:1.0.
    gl glLightModelIS: gl GL_LIGHT_MODEL_AMBIENT
             valuesFV: vector4f.


    gl glEnableIS: gl GL_BLEND.
    gl glDepthMaskIS: gl GL_FALSE.

    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK
                       modeIS: gl GL_FILL.

    gl glBlendFunctionForSourceFactorIS:gl GL_SRC_ALPHA 
                    destinationFactorIS: gl GL_ONE.


    zN := z negated.

    (vector := vf3) isNil ifTrue:[
        vector := vf3 := FloatArray new:3.
    ].
    (color := vf4) isNil ifTrue:[
        color := vf4 := FloatArray new:4.
    ].

    vector at:1 put:0.0.       
    vector at:2 put:1.0.
    vector at:3 put:0.0.
    gl glNormal3FV: vector.

    color at:1 put:1.0.
    color at:2 put:1.0.
    color at:3 put:1.0.
    color at:4 put:intensity.
    gl glColor4FV: color.
    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK 
                       modeIS: gl GL_FILL.

    gl glBeginIS: gl GL_TRIANGLES.
        "plane"
        "1"
        vector at:1 put:0.0.
        vector at:2 put:y.
        vector at:3 put:z.
        gl glVertex3FV:vector.

        "2"
        vector at:1 put:x.
"/      vector at:2 put:y.             "/ cg: already in vector
"/      vector at:3 put:z.             "/ cg: already in vector
        gl glVertex3FV:vector.

        "3"
"/      vector at:1 put:x.             "/ cg: already in vector
"/      vector at:2 put:y.             "/ cg: already in vector
        vector at:3 put:zN.
        gl glVertex3FV:vector.

        "1"
        vector at:1 put:0.0.
"/      vector at:2 put:y.             "/ cg: already in vector
        vector at:3 put:z.
        gl glVertex3FV:vector.

        "3"
        vector at:1 put:x.
"/      vector at:2 put:y.             "/ cg: already in vector
        vector at:3 put:zN.
        gl glVertex3FV:vector.

        "4"
        vector at:1 put:0.0.
"/      vector at:2 put:y.             "/ cg: already in vector
"/      vector at:3 put:zN.            "/ cg: already in vector
        gl glVertex3FV:vector.
    gl glEnd.

    gl glDisableIS: gl GL_BLEND.
    gl glDepthMaskIS: gl GL_TRUE.

    "Created: / 2.10.1998 / 10:12:09 / ps"
    "Modified: / 22.10.1998 / 16:19:27 / cg"
    "Modified: / 7.6.1999 / 17:10:19 / ps"
!

initBeforeDrawing
"draw axis into display lists

<return: self>
"
    ^ true



! !

!SeparatorPlane class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/SeparatorPlane.st,v 1.10 1999-06-07 15:14:14 ps Exp $'
! !
