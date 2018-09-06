"{ NameSpace: TDV }"

DrawableComponent subclass:#AxisStandard
	instanceVariableNames:'displayIDs v3f v4f maxY minY x z'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Components'
!


!AxisStandard methodsFor:'initialization'!

initialize
"setup up default values

<return: self>
"    
    super initialize.
    "initialize variables"
    maxY := 0.0.
    minY := 0.0.
    x    := 0.0.
    z    := 0.0.
    displayIDs := Array new:3.


! !

!AxisStandard methodsFor:'making objects'!

makeXAxis
"draw the x, y (back) part of the axis

<return: SmallInteger | nil>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
        vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].

    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.

    "the axis x consists of one line"
    gl glBeginIS: gl GL_LINES.
        vector at:1 put:1.0.
        vector at:2 put:0.0.
        vector at:3 put:0.0.
        gl glColor3FV: vector.

        vector at:1 put:0.0.
        vector at:2 put:0.0.
        vector at:3 put:0.0.
        gl glVertex3FV:vector.
        vector at:1 put:x.
        gl glVertex3FV:vector.
    gl glEnd.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 22.10.1998 / 16:14:05 / cg"
    "Modified: / 7.6.1999 / 16:56:43 / ps"
!

makeYAxis
"draw the x, y (back) part of the axis

<return: SmallInteger | nil>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
        vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].
    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.

    gl glBeginIS: gl GL_LINES.
        vector at:1 put:1.0.
        vector at:2 put:1.0.
        vector at:3 put:0.0.
        gl glColor3FV: vector.

        vector at:1 put:0.0.
        vector at:2 put:minY.
        vector at:3 put:0.0.
        gl glVertex3FV:vector.
        vector at:2 put:maxY.
        gl glVertex3FV:vector.
    gl glEnd.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 22.10.1998 / 16:14:05 / cg"
    "Modified: / 7.6.1999 / 16:56:47 / ps"
!

makeZAxis
"draw the x, y (back) part of the axis

<return: SmallInteger | nil>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
        vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].
    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.

    gl glBeginIS: gl GL_LINES.
        vector at:1 put:0.0.
        vector at:2 put:1.0.
        vector at:3 put:1.0.
        gl glColor3FV: vector.

        vector at:1 put:0.0.
        vector at:2 put:0.0.
        vector at:3 put:z.
        gl glVertex3FV:vector.
        vector at:3 put:z negated.
        gl glVertex3FV:vector.
    gl glEnd.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 22.10.1998 / 16:14:05 / cg"
    "Modified: / 7.6.1999 / 16:56:51 / ps"
! !

!AxisStandard methodsFor:'protocol'!

copyAspects
"store an aspect identified by its symbol and its value to a local varibale

<return: self>
"   
    |aspect|
    (aspect := globalAspectsIdentDic at:#maxY ifAbsent:[nil]) notNil
	ifTrue:[maxY := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#minY ifAbsent:[nil]) notNil
	ifTrue:[minY := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#x ifAbsent:[nil]) notNil
	ifTrue:[x := aspect.initialized := false].
    (aspect := globalAspectsIdentDic at:#z ifAbsent:[nil]) notNil
	ifTrue:[z := aspect.initialized := false].
    globalAspectsIdentDic removeAll
!

draw
"draw axis

<return: self>
"   
    |id vector4F|

    (vector4F := v4f) isNil ifTrue:[
	vector4F := v4f := FloatArray new:4.
    ].

    vector4F at:1 put:0.4.
    vector4F at:2 put:0.4.
    vector4F at:3 put:0.4.
    vector4F at:4 put:1.0.
    gl glLightModelIS: gl GL_LIGHT_MODEL_AMBIENT
	     valuesFV: vector4F.

    (id := displayIDs at:1) isNil ifFalse:[gl glCallListIS:id].
    (id := displayIDs at:2) isNil ifFalse:[gl glCallListIS:id].
    (id := displayIDs at:3) isNil ifFalse:[gl glCallListIS:id]

    "Modified: / 7.2.1999 / 18:15:44 / ps"
    "Created: / 7.2.1999 / 19:05:50 / ps"

!

initBeforeDrawing
"draw axis into display lists

<return: self>
"
    |displId|

    "make axis and store it in display lists"
    (displId := self makeXAxis) isNil ifFalse:[displayIDs at:1 put: displId].
    (displId := self makeYAxis) isNil ifFalse:[displayIDs at:2 put: displId].
    (displId := self makeZAxis) isNil ifFalse:[displayIDs at:3 put: displId].
    ^ true
! !

!AxisStandard class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/AxisStandard.st,v 1.28 1999-06-07 14:59:45 ps Exp $'
! !
