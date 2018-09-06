"{ NameSpace: TDV }"

DataViewer subclass:#DataViewer3D
	instanceVariableNames:'eyeStepX eyeStepY eyeStepZ angleX angleY  scaleX scaleY scaleZ'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-Renderer'
!


!DataViewer3D methodsFor:'accessing look'!

resetViewing
"set eye coordinates to default values
"
    glGraph resetViewing.
! !

!DataViewer3D methodsFor:'change & update'!

update:what with:aPara from:chgObj
    "catch and handle a change notification of any object
    "
    self halt.
"/    what == #zoomZ  ifTrue:[self zoomZ:aPara].
"/    what == #scaleX  ifTrue:[self scaleX:aPara].
"/    what == #scaleY  ifTrue:[self scaleY:aPara].
"/    what == #scaleZ  ifTrue:[self scaleZ:aPara].
"/    what == #angleX ifTrue:[chgObj value:(self angleX:aPara)].
"/    what == #angleY ifTrue:[self angleY:aPara].

    super update:what with:aPara from:chgObj

    "Modified: / 1.10.1998 / 12:32:39 / ps"
! !

!DataViewer3D methodsFor:'initialization'!

XsetupDefaultValues
"setup default values
"
    eyeStepX := 1.0.
    eyeStepY := 1.0.
    eyeStepZ := 1.0.

    angleX := 0.0.
    angleY := 0.0.
    scaleX := 1.0.
    scaleY := 1.0.
    scaleZ := 1.0.


    "Modified: / 1.10.1998 / 12:44:25 / ps"
!

disableRendering
"setup default values"

    glGraph disableRendering

    "Created: / 23.9.1998 / 17:34:15 / ps"
    "Modified: / 23.9.1998 / 17:45:43 / ps"
!

enableRendering
"setup default values"

    glGraph enableRendering

    "Created: / 23.9.1998 / 17:34:15 / ps"
    "Modified: / 23.9.1998 / 17:45:43 / ps"
!

initialize
"setup default values
"
    |glView|

    super initialize.
    self initializeRenderer.
"/    self setupDefaultValues

    "Modified: / 13.10.1998 / 16:39:14 / ps"
!

initializeRenderer
"setup default values
"
    glGraph := DataRenderer3D newOn:self.

    "Created: / 13.10.1998 / 16:40:53 / ps"

!

reinitialize
"new setup of default values
"
"/    self setupDefaultValues.
    glGraph reinitialize.
!

reinitializeTransformation
"calculate new transformation vectors to set a new
graph in the middle of the views point
"

    glGraph reinitializeTransformation.

    "Created: / 18.6.1999 / 16:11:37 / ps"
! !

!DataViewer3D methodsFor:'navigation'!

moveEye:aDirection moveFactor:aMultiplikator
"move the eye position in a specfic direction
"
    glGraph moveEye:aDirection moveFactor:aMultiplikator
! !

!DataViewer3D methodsFor:'protocol'!

doInvalidateGraph
"restart redrawing of the graph

<return: self>
"
    glGraph doInvalidateGraph.
!

doReinitData
"set graph to invalidate
"       self halt.
    glGraph reinitColumns.
! !

!DataViewer3D methodsFor:'queries'!

glExtensions
"return opengl's extensions
"
    ^glGraph glExtensions

!

glRenderer
"return opengl's renderer
"
    ^glGraph glRenderer
!

glVendor
"return opengl's vendor
"
    ^glGraph glVendor
!

glVersion
"return opengl's versionGL
"
    ^glGraph glVersion
!

gluVersion
"return opengl's versionGLU
"
    ^glGraph gluVersion
! !

!DataViewer3D methodsFor:'release'!

destroy
"shut down view
"
    glGraph terminateRedrawProcess.

    ^super destroy


! !

!DataViewer3D class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/DataViewer3D.st,v 1.27 2004-11-23 21:06:25 cg Exp $'
! !
