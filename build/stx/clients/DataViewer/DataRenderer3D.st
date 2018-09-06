"{ NameSpace: TDV }"

DataRenderer subclass:#DataRenderer3D
	instanceVariableNames:'rotationStarted eyeDX eyeDY eyeDZ eyeSX eyeSY eyeSZ
		distanceForEye angleForXRot angleForYRot alpha graphLenght
		graphHeight graphWidth glInitialized translateX translateY
		factorS sizeForTextOnXAxis sizeForTextOnYAxis sizeForTextOnZAxis
		distMatrixProj distMatrixModel'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Renderer'
!


!DataRenderer3D class methodsFor:'instance creation'!

new
"you must use newOn:aDataViewer3D"

    self error:'you must use newOn:aDataViewer3D'.




!

newOn:aDataViewer3D
"generates an instance of SimulationDataViewer3D and calls the instances newOn: method"

    ^super new newOn:aDataViewer3D

! !

!DataRenderer3D methodsFor:'accessing'!

angleForXRot
"return value for rotation around the x axis:
default x rotation angleForXRot is calculated in initilaizeOn method,
angleX is the user defined rotation value which is held in a DataViewer3D

<return: Float>
"
    ^ angleForXRot + self aspectsForRendering:#angleX


!

angleForYRot
"return value for rotation around the y axis:
default y rotation angleForYRot is calculated in initilaizeOn method,
angleY is the user defined rotation value which is held in a DataViewer3D
"
    ^ angleForYRot + self aspectsForRendering:#angleY

!

graphHeight
"return height of the graph
"
    ^graphHeight

    "Created: / 2.10.1998 / 10:34:07 / ps"

!

graphLenght
"return lenght of the graph
"
    ^graphLenght

!

graphWidth
"return width of the graph
"
    ^graphWidth

    "Created: / 2.10.1998 / 10:34:07 / ps"

!

resetViewing
"set eye coordinates to default values
"
    eyeDX := 0.0.
    eyeDY := 0.0.
    eyeDZ := 0.0.



!

rotateValueFrom:aValue
"convert a value to a valid rotation value; call invokes a DataViewer3D rotateValueFrom: method
"
    ^glView rotateValueFrom:aValue


!

rotationStarted
"return the value of the instance variable 'rotationStarted'
"
    ^rotationStarted

!

translateX
"return the value of the instance variable 'translateX'
"
    ^translateX


!

translateX:aCoordinate
"set the value of the instance variable 'translateX'
"
    translateX := aCoordinate.

!

translateY
"return the value of the instance variable 'translateY'
"
    ^translateY

!

translateY:aCoordinate
"set the value of the instance variable 'translateY'
"
    translateY := aCoordinate.

! !

!DataRenderer3D methodsFor:'initialization'!

initialize

    aspectsForRendering at:#lightsOn put:true.
    aspectsForRendering at:#angleX put:0.0.
    aspectsForRendering at:#angleY put:0.0.
    aspectsForRendering at:#scaleX put:1.0.
    aspectsForRendering at:#scaleY put:1.0.
    aspectsForRendering at:#scaleZ put:1.0.
    aspectsForRendering at:#eyeStepX put:0.0.
    aspectsForRendering at:#eyeStepY put:0.0.
    aspectsForRendering at:#eyeStepZ put:0.0.



!

newOn:aDataViewer3D

    |tmpObject|

    super newOn:aDataViewer3D.

    glInitialized := false.

    self setupDefaultValues.
    "Created: / 13.10.1998 / 17:41:43 / ps"
    "Modified: / 30.12.1998 / 11:49:14 / ps"


!

reinitializeTransformation


  self setupDrawFunction

    "Modified: / 18.6.1999 / 16:12:13 / ps"
!

setupDefaultValues
"setup default values
"
    eyeDX := 0.0.
    eyeDY := 0.0.
    eyeDZ := 0.0.
    alpha := 45.0.
    rotationStarted := false.

    "Modified: / 24.9.1998 / 16:53:29 / ps"


!

setupDrawFunction
"setup draw function and variables"

    |
     newGraphLenght newGraphWidth
     deltaX1 deltaX2 deltaZ1 deltaZ2
     width height
     visX visY sZ
     factorX factorX1 factorX2 factorY gamma xdiff zdiff
     maxY minY graphLenght graphHeight graphWidth|

	width  := glView width.
	height := glView height.
	xdiff := self aspectAt:#xdiff.
	zdiff := self aspectAt:#zdiff.
	maxY  := self aspectAt:#maxY.
	minY  := self aspectAt:#minY.
	graphLenght := self aspectAt:#graphLenght.
	graphHeight := self aspectAt:#graphHeight.
	graphWidth  := self aspectAt:#graphWidth.

	graphHeight = 0.0 ifTrue:[
	    self halt.
	    graphHeight := 1.0.
	].
	graphLenght = 0.0 ifTrue:[
	    self halt.
	    graphLenght := 1.0.
	].
	graphWidth = 0.0 ifTrue:[
	    self halt.
	    graphWidth := zdiff.
	].

	distanceForEye := width*1.5.
	sZ := distanceForEye.

	"calculate transformation matrix"
	"determine the field of view (openGL coordinates)"
	visX := 2 * sZ * ((alpha/2.0) degreesToRadians tan).
	visY := visX.

	"translation factor to translate the middle of the object to (0/0/0)"
	"calculate translateX"
	translateX := graphLenght / -2.
	"calculate translateY"
	minY < 0 ifTrue:[
	    maxY < 0 ifTrue:[
		translateY := (maxY+((maxY abs - minY abs)/2)) negated.
	    ]ifFalse:[
		translateY := (maxY-((maxY + minY abs)/2)) negated.
	    ].
	]ifFalse:[
	    translateY := (maxY-((maxY - minY)/2)) negated.
	].

    "/    deltaX1 := (graphLenght * (0.0 degreesToRadians cos)) abs.
	deltaX1 := graphLenght.
    "/    deltaX2 := (graphWidth * ((90.0-beta) degreesToRadians cos)) abs.
	deltaX2 := 0.0.
	newGraphLenght := deltaX1 + deltaX2.

    "/    deltaZ1 := (graphWidth * ((90.0-beta) degreesToRadians sin)) abs.
	deltaZ1 := graphWidth.
    "/    deltaZ2 := (graphLenght * (beta degreesToRadians sin)) abs.
	deltaZ2 := 0.0.
	newGraphWidth := deltaZ1 + deltaZ2.

	factorX1 := visX/newGraphLenght.
	factorX2 := visX/graphWidth.
	factorX1 < factorX2 ifTrue:[
	    factorX := factorX1.
	]ifFalse:[
	    factorX := factorX2.
	].

	factorY := visY/graphHeight.
	factorX < factorY ifTrue:[
	    factorS := factorX.
	]ifFalse:[
	    factorS := factorY.
	].

	"calculate default rotation value"
	gamma := (graphHeight/newGraphWidth) arcTan.
    "/    angleForXRot := gamma radiansToDegrees.
	angleForXRot := 0.0.
	angleForYRot := 90.0.
"/    ].

    "Created: / 23.9.1998 / 17:45:18 / ps"
    "Modified: / 13.10.1998 / 13:28:49 / ps"

! !

!DataRenderer3D methodsFor:'initialize light'!

initDirectionalLights
"setup all things for directional light sources
"
    |light vector|

    (light := self aspectAt:#lightsOn) isNil
	ifFalse:[
	    light == true
		ifTrue:[
		    gl glEnableIS: gl GL_LIGHT0.

		    vector := FloatArray new:4.
	    "/
		    vector at:1 put:0.3.
		    vector at:2 put:0.3.
		    vector at:3 put:0.3.
		    vector at:4 put:1.0.
		    gl glLightIS: gl GL_LIGHT0
			  typeIS: gl GL_DIFFUSE
			valuesFV: vector.
	    "/
	    "/        vector at:1 put:0.2.
	    "/        vector at:2 put:0.2.
	    "/        vector at:3 put:0.2.
	    "/        vector at:4 put:0.0.
	    "/        gl glLightIS: gl GL_LIGHT0
	    "/              typeIS: gl GL_AMBIENT
	    "/            valuesFV: vector.

		    vector at:1 put:0.0.
		    vector at:2 put:-1.0.
		    vector at:3 put:0.0.
		    vector at:4 put:0.
		    gl glLightIS: gl GL_LIGHT0
			  typeIS: gl GL_POSITION
			valuesFV: vector.
	       ]].

    "Modified: / 23.9.1998 / 15:26:47 / ps"


!

initPointLights
"setup all things for positional light sources

<return: self>
"
    |light vector|

    (light := self aspectAt:#lightsOn) isNil
	ifFalse:[
	    light == true
		ifTrue:[
		    gl glEnableIS: gl GL_LIGHT3.

		    vector := FloatArray new:4.

		    vector at:1 put:0.2.
		    vector at:2 put:0.2.
		    vector at:3 put:0.2.
		    vector at:4 put:1.0.
		    gl glLightIS: gl GL_LIGHT3
			  typeIS: gl GL_DIFFUSE
			valuesFV: vector.

		    vector at:1 put:0.1.
		    vector at:2 put:0.1.
		    vector at:3 put:0.1.
		    vector at:4 put:1.0.
		    gl glLightIS: gl GL_LIGHT3
			  typeIS: gl GL_AMBIENT
			valuesFV: vector.

	    "/        vector at:1 put:0.0.
	    "/        vector at:2 put:-1.0.
	    "/        vector at:3 put:0.0.
	    "/        vector at:4 put:0.0.
	    "/        gl glLightIS: gl GL_LIGHT3
	    "/              typeIS: gl GL_SPOT_DIRECTION
	    "/            valuesFV: vector.

	    "/        vector at:1 put:90.0.
	    "/        vector at:2 put:0.0.
	    "/        vector at:3 put:0.0.
	    "/        vector at:4 put:0.0.
	    "/        gl glLightIS: gl GL_LIGHT3
	    "/              typeIS: gl GL_SPOT_CUTOFF
	    "/            valuesFV: vector.


	    "/        gl glRasterPositionXDS:graphLenght / 2 asFloat
	    "/                           YDS:glView columns maxY * 1.5
	    "/                           ZDS:0.0.
	    "/        (self glContextInstance) displayText:'Loooooooooooooooooooooo' printString.

		    vector at:1 put:((self aspectAt:#graphLenght) / 2) asFloat.
		    vector at:2 put:((self aspectAt:#maxY) * 1.5).
		    vector at:3 put:0.0.
		    vector at:4 put:1.
	    "/        vector at:1 put:graphLenght / 2 asFloat.
	    "/        vector at:2 put:glView columns maxY * 1.5.
	    "/        vector at:3 put:0.0.
	    "/        vector at:4 put:1.
		    gl glLightIS: gl GL_LIGHT3
			  typeIS: gl GL_POSITION
			valuesFV: vector.
		]].

    "Modified: / 23.9.1998 / 15:27:00 / ps"

! !

!DataRenderer3D methodsFor:'navigation'!

checkRotationForX:aValue
"check if rotation around x axis is allowed;
here: only rotations between 0...90 and 0...-90 (270...360) degress are allowed

<return: Float>
"
    |actualRot|

    actualRot := self rotateValueFrom:(angleForXRot + aValue).

    (actualRot >= 0.0 and:[actualRot <= 90.0]) ifTrue:[
	^aValue asFloat
    ].

    (actualRot >= 270.0 and:[actualRot <= 360.0]) ifTrue:[
	^aValue asFloat
    ].

    ^(self aspectsForRendering:#angleX).

    "Modified: / 9.10.1998 / 15:16:47 / ps"

!

checkRotationForY:aValue
"check if rotation around y axis is allowed;
dummy, every rotation around the y axis is allowed
"
    ^aValue


!

endRotation
"indicate that a rotation of any axis ended
"
    rotationStarted := false.

    "Created: / 13.10.1998 / 17:44:45 / ps"
!

moveEye:aDirection moveFactor:aMultiplikator
"move the viewers eye in a direction indicated by aDirection;
possible values of aDirection are: #left, #right, #up, #down, #forward, #back
"
    |dir|

    dir := aDirection asSymbol.
    dir = #left ifTrue:[
	^eyeDX := eyeDX + ((self aspectAt:#eyeStepX) * aMultiplikator).
    ].

    dir = #right ifTrue:[
	^eyeDX := eyeDX - ((self aspectAt:#eyeStepX) * aMultiplikator).
    ].

    dir = #up ifTrue:[
	^eyeDY := eyeDY - ((self aspectAt:#eyeStepY) * aMultiplikator).
    ].

    dir = #down ifTrue:[
	^eyeDY := eyeDY + ((self aspectAt:#eyeStepY) * aMultiplikator).
    ].

    dir = #forward ifTrue:[
	^eyeDZ := eyeDZ + ((self aspectAt:#eyeStepZ) * aMultiplikator).
    ].

    dir = #back ifTrue:[
	^eyeDZ := eyeDZ - ((self aspectAt:#eyeStepZ) * aMultiplikator).
    ].

    "Modified: / 13.10.1998 / 17:46:15 / ps"
!

startRotation
"indicate that a rotation of any axis started
"
    rotationStarted := true.

    "Created: / 13.10.1998 / 17:44:56 / ps"
! !

!DataRenderer3D methodsFor:'protocoll'!

glViewPreRedraw:glView
"about to redraw a glView.

<return: void>
"
    self doInvalidateGraph

    "Created: / 15.10.1999 / 18:11:47 / ps"
    "Modified: / 15.10.1999 / 18:12:05 / ps"
! !

!DataRenderer3D methodsFor:'redraw'!

disableRendering
"
<return: self>
"
    lockRendering critical:[self renderingAllowed: false]

!

doInvalidateGraph
"start redrawing process if it isn´t running and signal redraw request
"
    renderingAllowed ifTrue:[
	"signal redrawing"
	redrawTrigger signalOnce.
    ].

    "Modified: / 2.10.1998 / 18:02:32 / ps"
!

enableRendering
"
<return: self>
"
    lockRendering critical:[self renderingAllowed: true]

! !

!DataRenderer3D methodsFor:'render utilities'!

calcEyeCoordinates
"calculate the eye coordinates; angleForYRot and angleForXRot are default values and
determined by the initial view calculation

<return: self>
"
    |gamma lenght vector|

    "distance from the origin (distanceForEye) and two angles for rotation around
     y and x axis are needed for the calculation                                 "
    gamma := (angleForXRot + (self aspectAt:#angleX)) degreesToRadians.
    eyeSY := distanceForEye * gamma sin.
    lenght := distanceForEye * gamma cos.
    gamma := (360.0 - (angleForYRot + (self aspectAt:#angleY))) degreesToRadians.
    eyeSZ := lenght * gamma cos.
    eyeSX := lenght * gamma sin.

    "Modified: / 9.10.1998 / 15:20:38 / ps"


!

checkDistance
"draw column descriptions
"

    sizeForTextOnXAxis := self checkDistanceForXAxis.
    sizeForTextOnYAxis := self checkDistanceForYAxis.
    sizeForTextOnZAxis := self checkDistanceForZAxis.

!

checkDistanceForXAxis
"draw column descriptions
"
    |"modelMatrix projMatrix" viewport
     winX1 winY1 winZ1 winX2 winY2 winZ2 "distance"|

    winX1 := DoubleArray new:1.
    winY1 := DoubleArray new:1.
    winZ1 := DoubleArray new:1.
    winX2 := DoubleArray new:1.
    winY2 := DoubleArray new:1.
    winZ2 := DoubleArray new:1.

"/    modelMatrix := DoubleArray new:16 withAll:0.0.
"/    modelMatrix at:1 put:1.0.
"/    modelMatrix at:6 put:1.0.
"/    modelMatrix at:11 put:1.0.
"/    modelMatrix at:16 put:1.0.
"/    modelMatrix := DoubleArray new:16.
"/    gl glGetDoubleForIS: gl GL_MODELVIEW_MATRIX
"/               valuesDV: modelMatrix.

"/    projMatrix := DoubleArray new:16 withAll:0.0.
"/    projMatrix at:1 put:1.0.
"/    projMatrix at:6 put:1.0.
"/    projMatrix at:11 put:1.0.
"/    projMatrix at:16 put:1.0.
"/    projMatrix := DoubleArray new:16.
"/    gl glGetDoubleForIS: gl GL_PROJECTION_MATRIX
"/               valuesDV: projMatrix.


    viewport := SignedIntegerArray new:4.
    gl glGetIntegerForIS: gl GL_VIEWPORT
		valuesIV: viewport.

    gl gluProjectObjXDS: 0.0
		 objYDS: 0.0
		 objZDS: 0.0
	modelMatrix16DV: distMatrixModel
	 projMatrix16DV: distMatrixProj
	    viewport4IV: viewport
		winX1DV: winX1
		winY1DV: winY1
		winZ1DV: winZ1.

    gl gluProjectObjXDS: 10.0
		 objYDS: 0.0
		 objZDS: 0.0
	modelMatrix16DV: distMatrixModel
	 projMatrix16DV: distMatrixProj
	    viewport4IV: viewport
		winX1DV: winX2
		winY1DV: winY2
		winZ1DV: winZ2.

"/              distance := ((((winX1 at:1)-(winX2 at:1))*((winX1 at:1)-(winX2 at:1)))+
"/             (((winY1 at:1)-(winY2 at:1))*((winY1 at:1)-(winY2 at:1)))) sqrt.
"/              Transcript showCR:distance.

    ^ ((((winX1 at:1)-(winX2 at:1))*((winX1 at:1)-(winX2 at:1)))+
		    (((winY1 at:1)-(winY2 at:1))*((winY1 at:1)-(winY2 at:1)))) sqrt


!

checkDistanceForYAxis
"draw column descriptions
"
    |"modelMatrix projMatrix" viewport
     winX1 winY1 winZ1 winX2 winY2 winZ2 "distance"|

    winX1 := DoubleArray new:1.
    winY1 := DoubleArray new:1.
    winZ1 := DoubleArray new:1.
    winX2 := DoubleArray new:1.
    winY2 := DoubleArray new:1.
    winZ2 := DoubleArray new:1.

"/    modelMatrix := DoubleArray new:16 withAll:0.0.
"/    modelMatrix at:1 put:1.0.
"/    modelMatrix at:6 put:1.0.
"/    modelMatrix at:11 put:1.0.
"/    modelMatrix at:16 put:1.0.
"/    modelMatrix := DoubleArray new:16.
"/    gl glGetDoubleForIS: gl GL_MODELVIEW_MATRIX
"/               valuesDV: modelMatrix.

"/    projMatrix := DoubleArray new:16 withAll:0.0.
"/    projMatrix at:1 put:1.0.
"/    projMatrix at:6 put:1.0.
"/    projMatrix at:11 put:1.0.
"/    projMatrix at:16 put:1.0.
"/    projMatrix := DoubleArray new:16.
"/    gl glGetDoubleForIS: gl GL_PROJECTION_MATRIX
"/               valuesDV: projMatrix.


    viewport := SignedIntegerArray new:4.
    gl glGetIntegerForIS: gl GL_VIEWPORT
		valuesIV: viewport.

    gl gluProjectObjXDS: 0.0
		 objYDS: 0.0
		 objZDS: 0.0
	modelMatrix16DV: distMatrixModel
	 projMatrix16DV: distMatrixProj
	    viewport4IV: viewport
		winX1DV: winX1
		winY1DV: winY1
		winZ1DV: winZ1.

    gl gluProjectObjXDS: 0.0
		 objYDS: 10.0
		 objZDS: 0.0
	modelMatrix16DV: distMatrixModel
	 projMatrix16DV: distMatrixProj
	    viewport4IV: viewport
		winX1DV: winX2
		winY1DV: winY2
		winZ1DV: winZ2.

"/              distance := ((((winX1 at:1)-(winX2 at:1))*((winX1 at:1)-(winX2 at:1)))+
"/             (((winY1 at:1)-(winY2 at:1))*((winY1 at:1)-(winY2 at:1)))) sqrt.
"/              Transcript showCR:distance.

    ^ ((((winX1 at:1)-(winX2 at:1))*((winX1 at:1)-(winX2 at:1)))+
		    (((winY1 at:1)-(winY2 at:1))*((winY1 at:1)-(winY2 at:1)))) sqrt


!

checkDistanceForZAxis
"draw column descriptions
"
    |"modelMatrix projMatrix" viewport
     winX1 winY1 winZ1 winX2 winY2 winZ2 "distance"|

    winX1 := DoubleArray new:1.
    winY1 := DoubleArray new:1.
    winZ1 := DoubleArray new:1.
    winX2 := DoubleArray new:1.
    winY2 := DoubleArray new:1.
    winZ2 := DoubleArray new:1.

"/    modelMatrix := DoubleArray new:16 withAll:0.0.
"/    modelMatrix at:1 put:1.0.
"/    modelMatrix at:6 put:1.0.
"/    modelMatrix at:11 put:1.0.
"/    modelMatrix at:16 put:1.0.
"/    modelMatrix := DoubleArray new:16.
"/    gl glGetDoubleForIS: gl GL_MODELVIEW_MATRIX
"/               valuesDV: modelMatrix.

"/    projMatrix := DoubleArray new:16 withAll:0.0.
"/    projMatrix at:1 put:1.0.
"/    projMatrix at:6 put:1.0.
"/    projMatrix at:11 put:1.0.
"/    projMatrix at:16 put:1.0.
"/    projMatrix := DoubleArray new:16.
"/    gl glGetDoubleForIS: gl GL_PROJECTION_MATRIX
"/               valuesDV: projMatrix.


    viewport := SignedIntegerArray new:4.
    gl glGetIntegerForIS: gl GL_VIEWPORT
		valuesIV: viewport.

    gl gluProjectObjXDS: 0.0
		 objYDS: 0.0
		 objZDS: 0.0
	modelMatrix16DV: distMatrixModel
	 projMatrix16DV: distMatrixProj
	    viewport4IV: viewport
		winX1DV: winX1
		winY1DV: winY1
		winZ1DV: winZ1.

    gl gluProjectObjXDS: 0.0
		 objYDS: 0.0
		 objZDS: 10.0
	modelMatrix16DV: distMatrixModel
	 projMatrix16DV: distMatrixProj
	    viewport4IV: viewport
		winX1DV: winX2
		winY1DV: winY2
		winZ1DV: winZ2.

"/              distance := ((((winX1 at:1)-(winX2 at:1))*((winX1 at:1)-(winX2 at:1)))+
"/             (((winY1 at:1)-(winY2 at:1))*((winY1 at:1)-(winY2 at:1)))) sqrt.
"/              Transcript showCR:distance.

    ^ ((((winX1 at:1)-(winX2 at:1))*((winX1 at:1)-(winX2 at:1)))+
		    (((winY1 at:1)-(winY2 at:1))*((winY1 at:1)-(winY2 at:1)))) sqrt


!

initializeLights
"call methods for setting directional and point lights
"
    gl glEnableIS: gl GL_LIGHTING.
    self initDirectionalLights.
    self initPointLights

    "Modified: / 23.9.1998 / 17:05:18 / ps"

!

initializeModelMatrix
"set up the openGL modelling matrix and position of clipping planes
"
    |equation yTranslation middleY middleX scaleX scaleY scaleZ|

    equation := DoubleArray new:4.
    gl glMatrixModeIS: gl GL_MODELVIEW.
    gl glLoadIdentityMatrix.

    "translate the middle of the graph to (0,0,0) (in projection coordinates)"
    scaleX := self aspectAt:#scaleX.
    scaleY := self aspectAt:#scaleY.
    scaleZ := self aspectAt:#scaleZ.

    gl glTranslateXDS:translateX*factorS*scaleX YDS:0.0 ZDS:0.0.
    gl glTranslateXDS:0.0 YDS:translateY*factorS*scaleY ZDS:0.0.

    "scale the graph: first calculated factor: factorS
		      second userdefined factors: scaleX, scaleY, scaleZ"
    gl glScaleXDS:factorS YDS:factorS ZDS:factorS.
    gl glScaleXDS:scaleX YDS:scaleY ZDS:scaleZ.

    "set clipping planes"
"/    equation at:1 put:1.0.
"/    equation at:2 put:0.0.
"/    equation at:3 put:0.0.
"/    equation at:4 put:0.0.
"/    gl glClipPlaneIS: gl GL_CLIP_PLANE0
"/         equation4DV: equation.

"/    equation at:1 put:-1.0.
"/    equation at:2 put:0.0.
"/    equation at:3 put:0.0.
"/    equation at:4 put:(self aspectAt:#graphLenght).
"/    gl glClipPlaneIS: gl GL_CLIP_PLANE1
"/         equation4DV: equation.

    distMatrixModel := DoubleArray new:16.
    gl glGetDoubleForIS: gl GL_MODELVIEW_MATRIX
	       valuesDV: distMatrixModel.

    "Modified: / 18.6.1999 / 12:59:34 / ps"
!

initializeProjectionMatrix: aRenderMode
"set up the openGL projection matrix
"
    |x y z dist deltaDist front graphBoundingBoxMaxSize deltaSum|


    gl glClearIS: (gl GL_COLOR_BUFFER_BIT   bitOr: gl GL_DEPTH_BUFFER_BIT).
    gl glViewportXIS: 0 YIS: 0 widthIS: glGraph width heightIS: glGraph height.

    gl glMatrixModeIS: gl GL_PROJECTION.
    aRenderMode ~~ #picking ifTrue:[
	gl glLoadIdentityMatrix.
    ].

    x := eyeSX*1.5.
    y := eyeSY*1.5.
    z := eyeSZ*1.5.

    deltaDist := ((eyeDX*eyeDX)+(eyeDY*eyeDY)+(eyeDZ*eyeDZ)) sqrt.
    eyeDZ > 0.0 ifTrue:[
	deltaDist := deltaDist negated.
    ].
    dist := ((x*x)+(y*y)+(z*z)) sqrt.
    front := dist/2+deltaDist.
    front < 100.0 ifTrue:[
	front := 100.0.
    ].

    "the front and back plane for the view volume are the front and back plane
     of the bounding box of the graph; be careful they must be in projection coodinates "

    graphBoundingBoxMaxSize := ((self aspectAt:#graphWidth) max:(self aspectAt:#graphLenght)).
    deltaSum := deltaDist+dist.
    gl gluPerspectiveForAngleDS: alpha
			 aspectDS: 1.0
			  frontDS: (10.0 max:deltaSum-graphBoundingBoxMaxSize)
			   backDS: deltaSum+graphBoundingBoxMaxSize.

"/    Transcript show:' distanceForEye '; showCR: distanceForEye.
"/    Transcript show:' dist '; showCR: dist.
"/    Transcript show:' graphLenght '; showCR: (self aspectAt:#graphLenght).
"/    Transcript show:' deltaDist '; showCR: deltaDist.
"/    Transcript show:' graphWidth '; showCR: (self aspectAt:#graphWidth).
"/    Transcript showCR:''.


    "set the user defined view"
    gl glTranslateXDS:eyeDX YDS:eyeDY ZDS:eyeDZ.

    gl glPushMatrix.
    gl gluLookAtEyeForXDS: distanceForEye * -1.5
		   eyeYDS: 0.0
		   eyeZDS: 0.0
		centerXDS: 0.0
		centerYDS: 0.0
		centerZDS: 0.0
		    upXDS: 0.0
		    upYDS: 1.0
		    upZDS: 0.0.
    distMatrixProj := DoubleArray new:16.
    gl glGetDoubleForIS: gl GL_PROJECTION_MATRIX
	       valuesDV: distMatrixProj.
    gl glPopMatrix.

    gl gluLookAtEyeForXDS: x
		   eyeYDS: y
		   eyeZDS: z
		centerXDS: 0.0
		centerYDS: 0.0
		centerZDS: 0.0
		    upXDS: 0.0
		    upYDS: 1.0
		    upZDS: 0.0.

    "Created: / 25.12.1998 / 17:27:37 / ps"
    "Modified: / 18.6.1999 / 12:56:00 / ps"
!

renderForSelectingOn: gl inView: aView
"render for selection modus: set projection and modelling matrix,
call the routines to draw the peak texts
"
    glInitialized ifTrue:[
	self calcEyeCoordinates.
	self initializeProjectionMatrix:#picking.
	self initializeModelMatrix.
	self renderForSelectingOn: gl.
    ].

    "Created: / 23.9.1998 / 16:46:50 / ps"
    "Modified: / 30.12.1998 / 12:31:43 / ps"

!

renderOn: gl inView: aView
"

<return: Boolean>
"
    glInitialized
	ifFalse:[self initializeOn:gl.
		glInitialized := true].

    glInitialized
	ifTrue:["calculate new eye point"
		self calcEyeCoordinates.
		self initializeProjectionMatrix:#drawing.
		"set translations and clipping planes for all objects"
		self initializeModelMatrix.
		self checkDistance.
		self initializeLights.
		self renderOn:gl.
		gl glFlush].
    ^false

    "Modified: / 7.2.1999 / 18:25:40 / ps"

!

renderingAllowed
"returns a value which is used by different processes.
Therefore it is a critical resource.

<return: Boolean>
"
    ^renderingAllowed

!

renderingAllowed: aBoolean
"returns a value which is used by different processes.
Therefore it is a critical resource.

<return: self>
"
    renderingAllowed := aBoolean

!

sizeForTextOnXAxis
"
"
    sizeForTextOnXAxis isNil ifTrue:[^0.0]
		     ifFalse:[^sizeForTextOnXAxis]

!

sizeForTextOnYAxis
"
"
    sizeForTextOnYAxis isNil ifTrue:[^0.0]
		     ifFalse:[^sizeForTextOnYAxis]

!

sizeForTextOnZAxis
"
"
    sizeForTextOnZAxis isNil ifTrue:[^0.0]
		     ifFalse:[^sizeForTextOnZAxis]

! !

!DataRenderer3D methodsFor:'rendering'!

glView: gl sizeChanged: how
"handle a resize of the openGL view

<return: self>
"

    self doInvalidateGraph

!

initializeOn: gl
"set up variables and initialize the openGL state machine with nessecary values;
call making routines for the grid, axis and planes
"
    self setupDefaultValues.

    self setupDrawFunction.

	gl glClearColorRedDS: 0.6
		     greenDS: 0.6
		      blueDS: 0.6
		     alphaDS: 1.0.
	gl glShadeModelIS: gl GL_SMOOTH.
"/        gl glShadeModelIS: gl GL_FLAT.
"/        gl glLightModelIS: gl GL_LIGHT_MODEL_TWO_SIDE
"/                  valueIS: gl GL_TRUE.

	gl glEnableIS: gl GL_DEPTH_TEST.
    "/    gl glDepthFunctionIS: gl GL_LESS.
"/        gl glColorMaterialForFaceIS: gl GL_FRONT_AND_BACK
"/                             modeIS: gl GL_AMBIENT_AND_DIFFUSE.
"/                             modeIS: gl GL_DIFFUSE.
	gl glEnableIS: gl GL_COLOR_MATERIAL.
    "/    gl glFrontFaceIS: gl GL_CW.
	gl glEnableIS: gl GL_CULL_FACE.
    "/    gl glCullFaceIS: gl GL_BACK.
"/        gl glEnableIS: gl GL_BLEND.
"/        gl glBlendFunctionForSourceFactorIS:gl GL_SRC_ALPHA destinationFactorIS: gl GL_DST_COLOR.



    "Modified: / 30.12.1998 / 11:44:43 / ps"


!

myRedrawRoutine
"update all resources and invalidate glGraph if realized
"
    glGraph realized ifTrue:[
	^glGraph doInvalidateGraph.
    ].

    "Modified: / 30.12.1998 / 11:40:18 / ps"


!

renderForSelectingOn: gl
"render for selection modus: set projection and modelling matrix,
call the routines to draw the peak texts
"

    components keysAndValuesDo:[:eachComp :eachCompID|
	gl glPushNameIS: eachCompID.
	eachComp pick.
	gl glPopName]

    "Created: / 23.9.1998 / 16:46:50 / ps"
    "Modified: / 9.3.1999 / 19:29:00 / ps"

!

renderOn: gl
"call methods to set projection and modelling matrix,
call the make method routine for the graph and
call the routines to draw the grid, axis and graph
"
    |vector|


    vector   := FloatArray new:4.

    "is lighting set"
"/    (self aspectAt:#lightsOn) ifTrue:[
"/        vector at:1 put:0.4.
"/        vector at:2 put:0.4.
"/        vector at:3 put:0.4.
"/        vector at:4 put:1.0.
"/        gl glLightModelIS: gl GL_LIGHT_MODEL_AMBIENT
"/                 valuesFV: vector.
"/        gl glEnableIS: gl GL_LIGHTING.
"/    ]ifFalse:[
"/        gl glDisableIS: gl GL_LIGHTING.
"/    ].

"/    (self aspectsForRendering:#lightsOn) ifTrue:[
"/        gl glEnableIS: gl GL_LIGHTING.
"/        vector at:1 put:0.3.
"/        vector at:2 put:0.3.
"/        vector at:3 put:0.3.
"/        vector at:4 put:1.0.
"/        gl glLightModelIS: gl GL_LIGHT_MODEL_AMBIENT
"/                 valuesFV: vector.
"/    ].

     "do predrawing initialization"
    lockCriticalResource critical:
	[components keysDo:[:each| each preDrawingInit]].
    "draw all components"
    components keysDo:[:each| each drawComponent].

    "Modified: / 25.6.1999 / 15:26:58 / ps"
! !

!DataRenderer3D methodsFor:'user interaction & notifications'!

button1Down: anSelection inView: anOpenGLView

    (anSelection notNil and:[anSelection notEmpty])
	ifTrue:[|theComponent|
		(theComponent := components keyAtValue:(anSelection at:1)) notNil
		    ifTrue:[theComponent pickWith:(anSelection removeFirst;yourself)]].
    "Modified: / 25.12.1998 / 17:20:03 / ps"


!

mouseWheelMotion:buttonState x:x y:y amount:amount deltaTime:dTime inView: anOpenGLView

    "Modified: / 28.5.1999 / 11:03:58 / ps"
! !

!DataRenderer3D class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/DataRenderer3D.st,v 1.25 2004-11-23 21:06:25 cg Exp $'
! !
