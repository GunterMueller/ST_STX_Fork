"{ NameSpace: TDV }"

DrawableComponent subclass:#FrameStandard
	instanceVariableNames:'displayIDs v3f maxY minY x z'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Components'
!


!FrameStandard methodsFor:'initialization'!

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

!FrameStandard methodsFor:'making objects'!

makeBack
"draw the x, y (back) part of the frame

<return: SmallInteger | nil>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
        vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].
    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    "frame for back plane"
    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.
"/                         modeIS: gl GL_DIFFUSE.
    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK 
                       modeIS: gl GL_LINE.

    vector at:1 put:0.0.
    vector at:2 put:0.0.
    vector at:3 put:0.0.
    gl glColor3FV: vector.

    gl glBeginIS: gl GL_QUADS.        
        vector at:1 put:0.0.                 
        vector at:2 put:minY.
        vector at:3 put:z negated.
        gl glVertex3FV:vector.

        vector at:1 put:x.
        gl glVertex3FV:vector.

        vector at:2 put:maxY.
        gl glVertex3FV:vector.

        vector at:1 put:0.
        gl glVertex3FV:vector.
    gl glEnd.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 22.10.1998 / 16:17:37 / cg"
    "Modified: / 25.6.1999 / 16:01:37 / ps"
!

makeBottom
"draw the y, z (bottom) part of the frame

<return: SmallInteger | nil>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
        vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].
    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    "frame bottom plane"
    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.
"/                         modeIS: gl GL_DIFFUSE.
    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK 
                       modeIS: gl GL_LINE.
    gl glBeginIS: gl GL_QUADS.
        vector at:1 put:0.0.
        vector at:2 put:0.0.
        vector at:3 put:0.0.
        gl glColor3FV: vector.

        vector at:1 put:0.             
        vector at:2 put:minY.
        vector at:3 put:z.
        gl glVertex3FV:vector.

        vector at:1 put:x.
        gl glVertex3FV:vector.

        vector at:3 put:z negated.
        gl glVertex3FV:vector.

        vector at:1 put:0.
        gl glVertex3FV:vector.
    gl glEnd.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 22.10.1998 / 16:17:46 / cg"
    "Modified: / 7.6.1999 / 16:55:34 / ps"
!

makeSide
"draw the z, y (side) part of the frame

<return: SmallInteger | nil>
"
    |vector displId|

    (vector := v3f) isNil ifTrue:[
        vector := v3f := FloatArray new:3.
    ].

    displId := DisplayListUtilities newDisplayIdForRenderingContext:gl.
    displId == 0 ifTrue:[^ nil].
    DisplayListUtilities openDisplayList:displId forRenderingContext:gl.

    "frame the side plane"
    gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
                         modeIS: gl GL_AMBIENT_AND_DIFFUSE.
"/                         modeIS: gl GL_DIFFUSE.
    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK 
                       modeIS: gl GL_LINE.
    gl glBeginIS: gl GL_QUADS.
        vector at:1 put:0.0.
        vector at:2 put:0.0.
        vector at:3 put:0.0.
        gl glColor3FV: vector.

        vector at:1 put:x.
        vector at:2 put:minY.
        vector at:3 put:z.
        gl glVertex3FV:vector.

        vector at:2 put:maxY.
        gl glVertex3FV:vector.

        vector at:2 put:maxY.
        vector at:3 put:z negated.
        gl glVertex3FV:vector.

        vector at:2 put:minY.
        vector at:3 put:z negated.   
        gl glVertex3FV:vector.
    gl glEnd.

    DisplayListUtilities closeDisplayListForRenderingContext:gl.
    ^ displId

    "Modified: / 22.10.1998 / 16:11:51 / cg"
    "Modified: / 7.6.1999 / 16:55:38 / ps"
! !

!FrameStandard methodsFor:'protocol'!

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
"draw frame

<return: self>
"   
    |id|
    (id := displayIDs at:1) isNil ifFalse:[gl glCallListIS:id].
    (id := displayIDs at:2) isNil ifFalse:[gl glCallListIS:id].
    (id := displayIDs at:3) isNil ifFalse:[gl glCallListIS:id].

    "Modified: / 7.2.1999 / 19:07:46 / ps"
!

initBeforeDrawing
"draw frame into display lists

<return: self>
"
    |displId|

    "make frame without grid and axis"
    (displId := self makeBottom) isNil ifFalse:[displayIDs at:1 put: displId].
    (displId := self makeBack)   isNil ifFalse:[displayIDs at:2 put: displId].
    (displId := self makeSide)   isNil ifFalse:[displayIDs at:3 put: displId].
    ^ true


! !

!FrameStandard class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/FrameStandard.st,v 1.19 1999-06-25 14:06:34 ps Exp $'
! !
