"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#GLBlendingDemo
	instanceVariableNames:'glView glViewClass'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-OpenGL'
!


!GLBlendingDemo class methodsFor:'interface spec'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Demos::GLBlendingDemo andSelector:#windowSpec
     Demos::GLBlendingDemo new openInterface:#windowSpec
     Demos::GLBlendingDemo open
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

    "Created: / 7.6.1999 / 10:51:36 / stefan"
! !

!GLBlendingDemo methodsFor:'hooks'!

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

    "Modified: / 7.6.1999 / 10:48:56 / stefan"
    "Modified: / 11.6.1999 / 13:46:49 / ps"
! !

!GLBlendingDemo methodsFor:'protocoll'!

button1Down: anSelection inView: anOpenGLView
"protocoll of the OpenGLDevice class.
If an selection occured this method will get the
selection stack from the OpenGLDevice.
In this demo application not used.

<return: self>
"
    ^ self

    "Created: / 7.6.1999 / 10:50:52 / stefan"
!

criticalRender: aBlock
"protocoll of the OpenGLDevice class.
Its used to protect critical resources when rendering.
Evaluating aBlock start the rendering. Here no protection is
needed therefore evaluation of the block without any special
things set up

<return: self>"

    aBlock value

    "Created: / 7.6.1999 / 10:49:19 / stefan"
!

finalizeOn: gl
"protocoll of the OpenGLDevice class.
When setting a new world to the OpenGLDevice this method
is called to finalized the old world.

<return: self>
"
    ^ self

    "Created: / 7.6.1999 / 10:49:28 / stefan"
!

glView: gl sizeChanged: how
"handle a resize of the OpenGLDevice-View, by starting 
a redraw via theOpenGLDevice.

<retrun: self>
"

    glView doInvalidateGraph

    "Created: / 7.6.1999 / 10:49:37 / stefan"
!

glViewPreRedraw:glView
"about to redraw a glView.

<return: void>
"

    glView doInvalidateGraph

    "Created: / 15.10.1999 / 10:02:35 / cg"
!

renderForSelectingOn: gl inView: aView
"protocoll of the OpenGLDevice class.
Normally process picks via left-button mouse clicks here.

<return: self>
"
    ^ self

    "Created: / 7.6.1999 / 10:49:46 / stefan"
!

renderOn: gl inView: aView
"protocoll of the OpenGLDevice class.
Draw the cubes only when the view is shown.
When called for first time, set some openGL states.

<return: Boolean>
"
    |w|

    "initialize if necessary"
    glView shown ifFalse:[^true].

    "handel resize"
    gl glViewportXIS: 0 YIS: 0 widthIS: glView width heightIS: glView height.

    gl glEnableIS: gl GL_DEPTH_TEST.
    gl glClearIS: (gl GL_DEPTH_BUFFER_BIT bitOr: gl GL_COLOR_BUFFER_BIT).   

    gl glMatrixModeIS: gl GL_PROJECTION.
    gl glLoadIdentityMatrix.
    gl gluPerspectiveForAngleDS: 45.0
                       aspectDS: 1.0
                        frontDS: 1.0
                         backDS: 20.0.

    gl gluLookAtEyeForXDS: 0.0 
                   eyeYDS: 0.0 
                   eyeZDS: 15.0 
                centerXDS: 0.0
                centerYDS: 0.0
                centerZDS: 0.0
                    upXDS: 0.0 
                    upYDS: 1.0 
                    upZDS: 0.0.

    gl glMatrixModeIS: gl GL_MODELVIEW.

    "draw rectangles"
    gl glLoadIdentityMatrix.
    self drawRectangles: gl.

    gl glFlush.
    "return true to start new rendering cycle"
    ^false

    "Created: / 7.6.1999 / 10:50:33 / stefan"
    "Modified: / 7.6.1999 / 10:55:05 / stefan"
    "Modified: / 18.6.1999 / 12:42:24 / ps"
    "Modified: / 15.10.1999 / 16:18:35 / cg"
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

    "Created: / 7.6.1999 / 10:50:43 / stefan"
! !

!GLBlendingDemo methodsFor:'rendering'!

drawOneRectangleWithColorVector4F: aColorVector4F andTranslationVector3F: aTranslationVector3F


    |vector3f size offset|

    vector3f := FloatArray new:3.

    size := 2.0.
    offset := 2.0.    

    glViewClass glPushMatrix.

    glViewClass glTranslateXDS: (aTranslationVector3F at:1) 
			     YDS: (aTranslationVector3F at:2)
			     ZDS: (aTranslationVector3F at:3).

    glViewClass glColor4FV: aColorVector4F.

    glViewClass glBeginIS: glViewClass GL_TRIANGLES.
	"plane"
	"1"
	vector3f at:1 put:offset.
	vector3f at:2 put:offset.
	vector3f at:3 put:-0.5.
	glViewClass glVertex3FV:vector3f.

	"2"
	vector3f at:2 put:size negated.
	glViewClass glVertex3FV:vector3f.

	"3"
	vector3f at:1 put:size negated.
	glViewClass glVertex3FV:vector3f.

	"3"
	glViewClass glVertex3FV:vector3f.

	"2"
	vector3f at:1 put:size negated.
	vector3f at:2 put:offset.            
	glViewClass glVertex3FV:vector3f.

	"4"
	vector3f at:1 put:offset.
	glViewClass glVertex3FV:vector3f.
    glViewClass glEnd.

    glViewClass glPopMatrix.

    "Created: / 11.6.1999 / 13:52:32 / ps"
    "Modified: / 11.6.1999 / 14:13:29 / ps"
!

drawRectangleBlue

    | color4f translate3f |

    color4f:= FloatArray new:4.
    translate3f:= FloatArray new:3.

    translate3f at:1 put:-2.0.
    translate3f at:2 put:0.2.
    translate3f at:3 put:-1.5.

    color4f at:1 put:0.0.
    color4f at:2 put:0.0.
    color4f at:3 put:1.0.
    color4f at:4 put:0.4.

    self drawOneRectangleWithColorVector4F: color4f 
		     andTranslationVector3F: translate3f

    "Created: / 11.6.1999 / 14:00:09 / ps"
    "Modified: / 11.6.1999 / 14:15:01 / ps"
!

drawRectangleOne

    | color4f translate3f |

    color4f:= FloatArray new:4.
    translate3f:= FloatArray new:3.

    translate3f at:1 put:0.0.
    translate3f at:2 put:0.5.
    translate3f at:3 put:0.0.

    color4f at:1 put:0.6.
    color4f at:2 put:0.7.
    color4f at:3 put:0.6.
    color4f at:4 put:1.0.

    self drawOneRectangleWithColorVector4F: color4f 
		     andTranslationVector3F: translate3f

    "Created: / 11.6.1999 / 13:28:26 / ps"
    "Modified: / 11.6.1999 / 14:09:15 / ps"
!

drawRectangleThree

    | color4f translate3f |

    color4f:= FloatArray new:4.
    translate3f:= FloatArray new:3.

    translate3f at:1 put:-3.0.
    translate3f at:2 put:1.5.
    translate3f at:3 put:-2.0.

    color4f at:1 put:0.6.
    color4f at:2 put:0.2.
    color4f at:3 put:0.0.
    color4f at:4 put:1.0.

    self drawOneRectangleWithColorVector4F: color4f 
		     andTranslationVector3F: translate3f

    "Created: / 11.6.1999 / 13:58:19 / ps"
    "Modified: / 11.6.1999 / 14:14:07 / ps"
!

drawRectangleTwo

    | color4f translate3f |

    color4f:= FloatArray new:4.
    translate3f:= FloatArray new:3.

    translate3f at:1 put:2.0.
    translate3f at:2 put:-1.5.
    translate3f at:3 put:3.0.

    color4f at:1 put:0.2.
    color4f at:2 put:0.4.
    color4f at:3 put:0.0.
    color4f at:4 put:1.0.

    self drawOneRectangleWithColorVector4F: color4f 
		     andTranslationVector3F: translate3f

    "Created: / 11.6.1999 / 13:57:31 / ps"
    "Modified: / 11.6.1999 / 14:13:53 / ps"
!

drawRectangleYellow

    | color4f translate3f |

    color4f:= FloatArray new:4.
    translate3f:= FloatArray new:3.

    translate3f at:1 put:-0.6.
    translate3f at:2 put:-0.4.
    translate3f at:3 put:1.5.

    color4f at:1 put:1.0.
    color4f at:2 put:1.0.
    color4f at:3 put:0.0.
    color4f at:4 put:0.3.

    self drawOneRectangleWithColorVector4F: color4f 
		     andTranslationVector3F: translate3f

    "Created: / 11.6.1999 / 14:00:09 / ps"
    "Modified: / 11.6.1999 / 14:14:22 / ps"
!

drawRectangles: gl

    self drawRectangleOne.
    self drawRectangleTwo.
    self drawRectangleThree.

    glViewClass glBlendFunctionForSourceFactorIS: glViewClass GL_SRC_ALPHA 
		    destinationFactorIS: glViewClass GL_ONE_MINUS_SRC_ALPHA.

    glViewClass glEnableIS: glViewClass GL_BLEND.
    glViewClass glDepthMaskIS: glViewClass GL_FALSE.

    self drawRectangleBlue.
    self drawRectangleYellow.

    glViewClass glDisableIS: glViewClass GL_BLEND.
    glViewClass glDepthMaskIS: glViewClass GL_TRUE.

    "Created: / 7.6.1999 / 10:54:48 / stefan"
    "Modified: / 11.6.1999 / 14:12:27 / ps"
! !

!GLBlendingDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLBlendingDemo.st,v 1.6 2016-01-21 18:05:07 cg Exp $'
! !

