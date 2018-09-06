"{ NameSpace: TDV }"

Presentation subclass:#SeparatorPlane
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'TDV'
!


!SeparatorPlane methodsFor:'making objects'!

make
"/    |displId x z vector color maxY minY|
"/
"/    maxY := glCDV3D maxY.
"/    minY := glCDV3D minY.
"/    x := glCDV3D graphLenght.
"/    z := glCDV3D graphWidth * 0.5.
"/
"/    vector := FloatArray new:3.
"/    color := FloatArray new:4.
"/   displId := self newDisplayId.
"/    displId == 0 ifTrue:[self halt].
"/    self makeDisplayList:displId.
"/
"/    vector at:1 put:0.0.
"/    vector at:2 put:1.0.
"/    vector at:3 put:0.0.
"/    gl glNormal3FV: vector.
"/
"/    color at:1 put:1.0.
"/    color at:2 put:1.0.
"/    color at:3 put:1.0.
"/    color at:4 put:0.5.
"/    gl glColor3FV: color.
"/
"/"/    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK 
"/"/                       modeIS: gl GL_FILL.
"/
"/    gl glBeginIS: gl GL_QUADS.
"/        "plane"
"/        vector at:1 put:0.0.
"/        vector at:2 put:maxY/2.
"/        vector at:3 put:z.
"/        gl glVertex3FV:vector.
"/        vector at:1 put:x.
"/        vector at:2 put:maxY/2.
"/        vector at:3 put:z.
"/        gl glVertex3FV:vector.
"/        vector at:1 put:x.
"/        vector at:2 put:maxY/2.
"/        vector at:3 put:z negated.
"/        gl glVertex3FV:vector.
"/        vector at:1 put:0.0.
"/        vector at:2 put:maxY/2.
"/        vector at:3 put:z negated.
"/        gl glVertex3FV:vector.
"/    gl glEnd.
"/    self closeDisplayList.
"/
"/    displayIDs at:1 put: displId.

    "Created: / 2.10.1998 / 10:11:43 / ps"
    "Modified: / 2.10.1998 / 14:40:45 / ps"
! !

!SeparatorPlane methodsFor:'rendering'!

draw

    |x z vector color maxY minY y i|

    gl glEnableIS: gl GL_BLEND.
    gl glBlendFunctionForSourceFactorIS:gl GL_SRC_ALPHA 
                    destinationFactorIS: gl GL_ONE.


    maxY := glXDV3D columns maxY.
    minY := glXDV3D columns minY.
    x := glXDV3D graphLenght.
    z := glXDV3D graphWidth * 0.5.
    y := glXDV3D separatorPlaneYValue.
    i := glXDV3D separatorPlaneIntensity.

    vector := FloatArray new:3.
    color := FloatArray new:4.

    vector at:1 put:0.0.
    vector at:2 put:1.0.
    vector at:3 put:0.0.
    gl glNormal3FV: vector.

    color at:1 put:1.0.
    color at:2 put:1.0.
    color at:3 put:1.0.
    color at:4 put:i.
    gl glColor4FV: color.
"/    gl glPolygonModeForFaceIS: gl GL_FRONT_AND_BACK 
"/                       modeIS: gl GL_FILL.

    gl glBeginIS: gl GL_TRIANGLES.
        "plane"
        "1"
        vector at:1 put:0.0.
        vector at:2 put:y.
        vector at:3 put:z.
        gl glVertex3FV:vector.
        "2"
        vector at:1 put:x.
        vector at:2 put:y.
        vector at:3 put:z.
        gl glVertex3FV:vector.
        "3"
        vector at:1 put:x.
        vector at:2 put:y.
        vector at:3 put:z negated.
        gl glVertex3FV:vector.
        "1"
        vector at:1 put:0.0.
        vector at:2 put:y.
        vector at:3 put:z.
        gl glVertex3FV:vector.
        "3"
        vector at:1 put:x.
        vector at:2 put:y.
        vector at:3 put:z negated.
        gl glVertex3FV:vector.
        "4"
        vector at:1 put:0.0.
        vector at:2 put:y.
        vector at:3 put:z negated.
        gl glVertex3FV:vector.
    gl glEnd.

    gl glDisableIS: gl GL_BLEND.

    "Created: / 2.10.1998 / 10:12:09 / ps"
    "Modified: / 13.10.1998 / 14:25:18 / ps"
! !

!SeparatorPlane class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/obsolete/SeparatorPlane.st,v 1.1 1998-10-26 18:21:03 cg Exp $'
! !
