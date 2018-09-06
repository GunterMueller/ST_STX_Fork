"{ NameSpace: TDV }"

DrawableComponent subclass:#PlaneStandard
	instanceVariableNames:'displayIDs v3f maxY minY x z'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Components'
!


!PlaneStandard methodsFor:'initialization'!

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

!PlaneStandard methodsFor:'making objects'!

makeBack
"draw the x, y (back) part of the axis

<return: SmallInteger>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
	vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].
    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    vector at:1 put:0.0.
    vector at:2 put:0.0.
    vector at:3 put:1.0.
    gl glNormal3FV: vector.

"/    gl glDepthFunctionIS: gl GL_ALWAYS.

    "the back plane consists of one filled quad"
    gl glEnableIS: gl GL_CULL_FACE.
    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
			 modeIS: gl GL_AMBIENT_AND_DIFFUSE.
"/                         modeIS: gl GL_DIFFUSE.
    gl glPolygonModeForFaceIS: gl GL_FRONT 
		       modeIS: gl GL_FILL.
    gl glBeginIS: gl GL_TRIANGLES.
	vector at:1 put:0.0.
	vector at:2 put:0.4.
	vector at:3 put:0.8.
	gl glColor3FV: vector.

	"1"
	vector at:1 put:0.0.
	vector at:2 put:minY.
	vector at:3 put:z negated.
	gl glVertex3FV:vector.
	"2"
	vector at:1 put:x.
"/      vector at:2 put:minY.
"/      vector at:3 put:z.
	gl glVertex3FV:vector.
	"3"
"/      vector at:1 put:x.
	vector at:2 put:maxY.
"/      vector at:3 put:z.
	gl glVertex3FV:vector.
	"1"
	vector at:1 put:0.0.
	vector at:2 put:minY.
"/      vector at:3 put:z.
	gl glVertex3FV:vector.
	"3"
	vector at:1 put:x.
	vector at:2 put:maxY.
"/      vector at:3 put:z.
	gl glVertex3FV:vector.
	"4"
	vector at:1 put:0.
"/      vector at:2 put:maxY.
"/      vector at:3 put:z.
	gl glVertex3FV:vector.
    gl glEnd.

    gl glDisableIS: gl GL_CULL_FACE.
"/    gl glDepthFunctionIS: gl GL_LESS.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 13.10.1998 / 14:25:50 / ps"
    "Modified: / 22.10.1998 / 16:14:05 / cg"
!

makeBottom
"draw the y, z (bottom) part of the axis

<return: SmallInteger>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
	vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].
    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    vector at:1 put:0.
    vector at:2 put:1.
    vector at:3 put:0.
    gl glNormal3FV: vector.

"/    gl glDepthFunctionIS: gl GL_ALWAYS.

    "the bottom plane consists of one filled quad"
    gl glEnableIS: gl GL_CULL_FACE.
    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
			 modeIS: gl GL_AMBIENT_AND_DIFFUSE.
"/                         modeIS: gl GL_DIFFUSE.
    gl glPolygonModeForFaceIS: gl GL_FRONT 
				 modeIS: gl GL_FILL.
    gl glBeginIS: gl GL_TRIANGLES.
	vector at:1 put:0.0.
	vector at:2 put:0.4.
	vector at:3 put:0.8.
	gl glColor3FV: vector.

	vector at:1 put:0.
	vector at:2 put:minY.
	vector at:3 put:z.
	gl glVertex3FV:vector.

	vector at:1 put:x.
"/      vector at:2 put:minY.
"/      vector at:3 put:z.
	gl glVertex3FV:vector.

"/      vector at:1 put:x.
"/      vector at:2 put:minY.
	vector at:3 put:z negated.
	gl glVertex3FV:vector.

	vector at:1 put:0.
"/      vector at:2 put:minY.
	vector at:3 put:z.
	gl glVertex3FV:vector.

	vector at:1 put:x.
"/      vector at:2 put:minY.
	vector at:3 put:z negated.
	gl glVertex3FV:vector.

	vector at:1 put:0.
"/      vector at:2 put:minY.
"/      vector at:3 put:z negated.
	gl glVertex3FV:vector.
    gl glEnd.

    gl glDisableIS: gl GL_CULL_FACE.
"/    gl glDepthFunctionIS: gl GL_LESS.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 13.10.1998 / 14:26:21 / ps"
    "Modified: / 22.10.1998 / 16:15:30 / cg"
!

makeSide
"draw the z, y (side) part of the axis

<return: SmallInteger>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
	vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].
    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    vector at:1 put:-1.0.
    vector at:2 put:0.0.
    vector at:3 put:0.0.
    gl glNormal3FV: vector.

"/    gl glDepthFunctionIS: gl GL_ALWAYS.

    "the side plane consists of one filled quad"
    gl glEnableIS: gl GL_CULL_FACE.
    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
			 modeIS: gl GL_AMBIENT_AND_DIFFUSE.
"/                         modeIS: gl GL_DIFFUSE.
    gl glPolygonModeForFaceIS: gl GL_FRONT
		       modeIS: gl GL_FILL.
    gl glBeginIS: gl GL_TRIANGLES.
	vector at:1 put:0.0.
	vector at:2 put:0.4.
	vector at:3 put:0.8.
	gl glColor3FV: vector.

	"1"
	vector at:1 put:x.
	vector at:2 put:minY.
	vector at:3 put:z.
	gl glVertex3FV:vector.
	"2"
"/      vector at:1 put:x.
	vector at:2 put:maxY.
"/      vector at:3 put:z.
	gl glVertex3FV:vector.
	"3"
"/      vector at:1 put:x.
"/      vector at:2 put:maxY.
	vector at:3 put:z negated.
	gl glVertex3FV:vector.
	"1"
"/      vector at:1 put:x.
	vector at:2 put:minY.
	vector at:3 put:z.
	gl glVertex3FV:vector.
	"3"
"/      vector at:1 put:x.
	vector at:2 put:maxY.
	vector at:3 put:z negated.
	gl glVertex3FV:vector.
	"4"
"/      vector at:1 put:x.
	vector at:2 put:minY.
"/      vector at:3 put:z negated.
	gl glVertex3FV:vector.
    gl glEnd.

    gl glDisableIS: gl GL_CULL_FACE.
"/    gl glDepthFunctionIS: gl GL_LESS.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 13.10.1998 / 14:26:37 / ps"
    "Modified: / 22.10.1998 / 16:16:35 / cg"
! !

!PlaneStandard methodsFor:'protocol'!

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
"draw plane

<return: self>
"   
    |id vector|

    vector := FloatArray new:4.
    vector at:1 put:0.2.
    vector at:2 put:0.2.
    vector at:3 put:0.2.
    vector at:4 put:1.0.
    gl glLightModelIS: gl GL_LIGHT_MODEL_AMBIENT
	     valuesFV: vector.

    gl glEnableIS: gl GL_POLYGON_OFFSET_FILL.
    gl glPolygonOffsetForFactorFS:1.0
			  unitsFS:10.0.
    (id := displayIDs at:1) isNil ifFalse:[gl glCallListIS:id].
    (id := displayIDs at:2) isNil ifFalse:[gl glCallListIS:id].
    (id := displayIDs at:3) isNil ifFalse:[gl glCallListIS:id].
    gl glDisableIS: gl GL_POLYGON_OFFSET_FILL

    "Modified: / 7.2.1999 / 18:15:44 / ps"
    "Created: / 7.2.1999 / 19:05:50 / ps"
!

initBeforeDrawing
"draw plane into display lists

<return: self>
"
    |displId|

    "make plane"
    (displId := self makeBottom) isNil ifFalse:[displayIDs at:1 put: displId].
    (displId := self makeBack)   isNil ifFalse:[displayIDs at:2 put: displId].
    (displId := self makeSide)   isNil ifFalse:[displayIDs at:3 put: displId].
    ^ true


! !

!PlaneStandard class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/PlaneStandard.st,v 1.17 1999-04-23 15:22:56 cg Exp $'
! !
