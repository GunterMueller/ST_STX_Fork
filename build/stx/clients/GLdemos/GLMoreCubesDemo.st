"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#GLMoreCubesDemo
	instanceVariableNames:'initialized eAngle dAngle xAngle glView glViewClass'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-OpenGL'
!

!GLMoreCubesDemo class methodsFor:'documentation'!

documentation
"
    Draw rotating cubes using display lists. The Demos uses the OpenGL interface of STX.

    [start with:]
	Demos::GLMoreCubesDemo open
"




! !

!GLMoreCubesDemo class methodsFor:'interface spec'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Diplom::Testing andSelector:#windowSpec
     Diplom::Testing new openInterface:#windowSpec
     Diplom::Testing open
    "

    <resource: #canvas>

    ^

       #(#FullSpec
	  #window: 
	   #(#WindowSpec
	      #name: 'OpenGL Examples Gallery'
	      #layout: #(#LayoutFrame 50 0 569 0 349 0 868 0)
	      #label: 'OpenGL Examples Gallery'
	      #min: #(#Point 10 10)
	      #max: #(#Point 1152 864)
	      #bounds: #(#Rectangle 50 569 350 869)
	      #usePreferredExtent: false
	  )
	  #component: 
	   #(#SpecCollection
	      #collection: #()
	  )
      )

    "Created: / 7.6.1999 / 10:20:21 / stefan"
! !

!GLMoreCubesDemo methodsFor:'hooks'!

postBuildWith:aBuilder
"create a new openGL rendering context and set its world
to myself.

<return: self>
"
    |world|

    glView := OpenGLDevice new.
    glViewClass := glView class.    
    glView world: self.
    glView origin:0.0@0.0 corner:1.0@1.0.
    self window addSubView: glView.

    self window realizeAllSubViews.

    super postBuildWith:aBuilder

    "Created: / 7.6.1999 / 10:20:47 / stefan"
    "Modified: / 7.6.1999 / 10:25:21 / stefan"
    "Modified: / 11.6.1999 / 14:45:38 / ps"
! !

!GLMoreCubesDemo methodsFor:'initialization'!

initialize
"sets default values

<return: self>
"
    initialized := false

    "Created: / 30.9.1998 / 17:52:32 / ps"
!

initializeOn
"its called when the method renderOn: inView: is called for the first time.
Setup display lists for the cubes.

<return: self>
"

    xAngle := 0.0.
    eAngle := 0.0.
    dAngle := 0.0.
    glViewClass glNewListIS: 100 modeIS: (glViewClass GL_COMPILE).
	glViewClass glPolygonModeForFaceIS: glViewClass GL_FRONT modeIS: glViewClass GL_FILL.
	glViewClass glBeginIS: glViewClass GL_TRIANGLES.
	    "/ face 1
	    glViewClass glColor3FV: #(0.0 0.7 0.1)    asFloatArray.
	    glViewClass glVertex3FV:#(-1.0  1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0  1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0 -1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0 -1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0 -1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0  1.0  1.0) asFloatArray.
	    "/ face 2
	    glViewClass glColor3FV: #(0.9 1.0 0.0)    asFloatArray.
	    glViewClass glVertex3FV:#(-1.0  1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0  1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0 -1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0 -1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0 -1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0  1.0 -1.0) asFloatArray.
	    "/ face 3
	    glViewClass glColor3FV: #(0.2 0.2 1.0)    asFloatArray.
	    glViewClass glVertex3FV:#(-1.0  1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0  1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0  1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0  1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0  1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0  1.0  1.0) asFloatArray.
	    "/ face 4
	    glViewClass glColor3FV: #(0.7 0.0 0.1) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0 -1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0 -1.0  1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0 -1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#( 1.0 -1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0 -1.0 -1.0) asFloatArray.
	    glViewClass glVertex3FV:#(-1.0 -1.0  1.0) asFloatArray.
	glViewClass glEnd.
    glViewClass glEndList.

    "Created: / 11.6.1999 / 14:47:13 / ps"
    "Modified: / 11.6.1999 / 14:48:54 / ps"
! !

!GLMoreCubesDemo methodsFor:'protocoll'!

button1Down: anSelection inView: anOpenGLView
"protocoll of the OpenGLDevice class.
If an selection occured this method will get the
selection stack from the OpenGLDevice.
In this demo application not used.

<return: self>
"
    ^ self

    "Created: / 30.9.1998 / 17:52:50 / ps"
!

criticalRender: aBlock
"protocoll of the OpenGLDevice class.
Its used to protect critical resources when rendering.
Evaluating aBlock start the rendering. Here no protection is
needed therefore evaluation of the block without any special
things set up

<return: self>"

    aBlock value
!

finalizeOn: gl
"protocoll of the OpenGLDevice class.
When setting a new world to the OpenGLDevice this method
is called to finalized the old world.

<return: self>
"
    ^ self
    "Modified: / 30.9.1998 / 17:52:36 / ps"
!

glView: gl sizeChanged: how
"handle a resize of the OpenGLDevice-View, by starting 
a redraw via theOpenGLDevice.

<retrun: self>
"

    glView doInvalidateGraph
!

renderForSelectingOn: gl inView: aView
"protocoll of the OpenGLDevice class.
Normally process picks via left-button mouse clicks here.

<return: self>
"
    ^ self
    "Created: / 30.9.1998 / 17:52:45 / ps"
!

renderOn: gl inView: aView
"protocoll of the OpenGLDevice class.
Draw the cubes only when the view is shown.
When called for first time, initialize openGL states needed by this application.

<return: Boolean>
"
    |w|

    "initialize if necessary"
    initialized ifFalse: [self initializeOn. initialized := true].
    glView shown ifFalse:[^true].

    "handel resize"
    glViewClass glViewportXIS: 0 YIS: 0 widthIS: glView width heightIS: glView height.

    glViewClass glEnableIS: glViewClass GL_DEPTH_TEST.
    glViewClass glClearIS: (glViewClass GL_DEPTH_BUFFER_BIT bitOr: glViewClass GL_COLOR_BUFFER_BIT).   

    glViewClass glMatrixModeIS: gl GL_PROJECTION.
    glViewClass glLoadIdentityMatrix.
    glViewClass gluPerspectiveForAngleDS: 40.0
                       aspectDS: 1.0
                        frontDS: 1.0
                         backDS: 100.0.

    glViewClass gluLookAtEyeForXDS: 20.0 
                   eyeYDS: 0.0 
                   eyeZDS: 20.0 
                centerXDS: 0.0
                centerYDS: 0.0
                centerZDS: 0.0
                    upXDS: 0.0 
                    upYDS: 1.0 
                    upZDS: 0.0.

    "draw cubes"
    self drawCubes.

    "update opengl view"
    glViewClass glFlush.

    "return true to start new rendering cycle"
    ^true

    "Modified: / 18.6.1999 / 12:43:00 / ps"
!

renderingAllowed
"protocoll of the OpenGLDevice class.
Indicate that all things are initialized correctly.
Espacially used when more than one process change the state
of this instance.
Nothing to be done in this demo application.

<return: Boolean>
"
    ^ true
! !

!GLMoreCubesDemo methodsFor:'rendering'!

drawCubes

    "rotation of the cubes"
    glViewClass glRotateDS: (dAngle := dAngle + 0.5) asFloat XDS: 0.0 YDS: 0.0 ZDS: 1.0.
    glViewClass glRotateDS: (eAngle := dAngle + 0.8) asFloat XDS: 0.0 YDS: 1.0 ZDS: 1.0.
    xAngle := xAngle + 7.0.

    glViewClass glMatrixModeIS: glViewClass GL_MODELVIEW.

    "draw cubes"
    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:0.0 ZDS:-8.0.
    glViewClass glRotateDS: xAngle asFloat XDS: 1.0 YDS: 0.0 ZDS: 0.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:0.0 ZDS:-4.0.
    glViewClass glRotateDS: xAngle asFloat XDS: 0.0 YDS: 0.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:0.0 ZDS: 0.0.
    glViewClass glRotateDS: xAngle asFloat XDS: 0.0 YDS: 1.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:0.0 ZDS: 4.0.
    glViewClass glRotateDS: xAngle asFloat XDS: 1.0 YDS: 0.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:0.0 ZDS: 8.0.
    glViewClass glRotateDS: xAngle asFloat XDS: 0.0 YDS: 1.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:-3.0 ZDS:-8.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 1.0 YDS: 0.0 ZDS: 0.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:-3.0 ZDS:-4.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 0.0 YDS: 0.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:-3.0 ZDS: 0.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 0.0 YDS: 1.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:-3.0 ZDS: 4.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 1.0 YDS: 0.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:-3.0 ZDS: 8.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 0.0 YDS: 1.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:3.0 ZDS:-8.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 1.0 YDS: 0.0 ZDS: 0.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:3.0 ZDS:-4.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 0.0 YDS: 0.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:3.0 ZDS: 0.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 0.0 YDS: 1.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:3.0 ZDS: 4.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 1.0 YDS: 0.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    glViewClass glLoadIdentityMatrix.
    glViewClass glTranslateXDS:0.0 YDS:3.0 ZDS: 8.0.
    glViewClass glRotateDS: (xAngle negated) asFloat XDS: 0.0 YDS: 1.0 ZDS: 1.0.
    glViewClass glCallListIS:100.

    "Created: / 11.6.1999 / 14:53:41 / ps"
    "Modified: / 11.6.1999 / 15:21:18 / ps"
! !

!GLMoreCubesDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLMoreCubesDemo.st,v 1.7 2016-01-21 18:05:42 cg Exp $'
! !

