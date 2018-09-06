"
 COPYRIGHT (c) 1995 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:clients/GLdemos' }"

"{ NameSpace: Demos }"

GLXView subclass:#GLDemo6
	instanceVariableNames:'redrawProcess rotation tX tY tZ rX rY rZ lastX lastY lastZ'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLDemo6 comment:'
GL demo - see class method #documentation
'
!

!GLDemo6 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"


!

documentation
"
    a GL view demonstrating animation, transformations and
    mouse-event processing.

    Sets up a transformation and draws some simple animated objects.
    with every redraw, the objects are rotated a bit around.

    In addition, the eye position can be controlled with the mouse:
        press left button and:
           move left/right moves eye left/right (along x-axis),
           move forward/backward moves eye up/down (along y axis)

        press middle button and:
           move left/right moves eye left/right (along x-axis),
           move forward/backward moves eye into/out (along z axis)

        press right button and:
           move left/right rotates eye left/right (along x-axis),
           move forward/backward rotates eye into/out (along z axis)

    [start with:]
        GLDemo6 open

    [author:]
        Claus Gittinger
"
! !

!GLDemo6 class methodsFor:'defaults'!

defaultExtent
    "used by superclass"

    ^ 300 @ 300
!

defaultLabel
    "used by superclass"

    ^ 'GL transformations'
! !

!GLDemo6 methodsFor:'drawing'!

redraw 
    "redraw the picture"

    "
     define perspective-viewing as
        0.0                                   200.0

    eye                                   
        near                                  far
    <)  -------------+------+-----------------+-------------------+
    65 degrees       \      \                  \                   \
    field of view     \      \                  \                   \
                       \      \                  \                   \
                        +------+                  \                   \
                                                   \                   \
                                                    \                   \
                                                     \                   \
                                                      \                   \
                                                       +-------------------+

         ---> negative z coordinates
    "

    self perspectiveFovy:650 aspect:1.0 near:0.0 far:200.0. 

    "
     translate/rotate for eye position
    "
    self translateX:tX / 10 
                  y:tY / 10 
                  z:(tZ negated /10) - 10.

    self rotateX:rX y:rY z:rZ.

    "
     clear the drawing area
    "
    self color:Black.    
    self clear.        

    "
     axis
    "
    self pushMatrix.
"/    self translateX:0.0 y:0.0 z:-10.

    "x-axis"
    self color:Green.
    self beginLine.
    self v3f:#(0.0 0.0 0.0).
    self v3f:#(10.0 0.0 0.0).
    self endLine.
      self beginLine.              "arrowhead"
      self v3f:#(9.5 0.2 0.0).
      self v3f:#(10.0 0.0 0.0).
      self v3f:#(9.5 -0.2 0.0).
      self endLine.

      self color:Magenta.
      self beginLine.              "X-character"
      self v3f:#(10.2 0.2 0.0).
      self v3f:#(10.5 -0.2 0.0).
      self endLine.
      self beginLine.
      self v3f:#(10.5 0.2 0.0).
      self v3f:#(10.2 -0.2 0.0 ).
      self endLine.

    "y-axis"
    self color:Green.
    self beginLine.
    self v3f:#(0.0 0.0 0.0).
    self v3f:#(0.0 10.0 0.0).
    self endLine.
      self beginLine.              "arrowhead"
      self v3f:#(0.2 9.5 0.0).
      self v3f:#(0.0 10.0 0.0).
      self v3f:#(-0.2 9.5 0.0).
      self endLine.

      self color:Magenta.
      self beginLine.              "Y-character"
      self v3f:#(-0.2 10.5 0.0).
      self v3f:#(0.0 10.35 0.0).
      self endLine.
      self beginLine.
      self v3f:#(0.2 10.5 0.0).
      self v3f:#(0.0 10.35 0.0 ).
      self endLine.
      self beginLine.
      self v3f:#(0.0 10.35 0.0).
      self v3f:#(0.0 10.2 0.0 ).
      self endLine.

    "z-axis"
    self color:Green.
    self beginLine.
    self v3f:#(0.0 0.0 0.0).
    self v3f:#(0.0 0.0 -100.0).
    self endLine.
      self beginLine.              "arrowhead"
      self v3f:#(2 0.0 -80).       "z-arrowhead is bigger,"
      self v3f:#(0.0 0.0 -100.0).  "to compensate for perspective shrinking"
      self v3f:#(-2 0.0 -80).
      self endLine.

      self color:Magenta.
      self beginLine.              "Z-character"
      self v3f:#(-2 4 -120.0).
      self v3f:#(2 4 -120.0).
      self endLine.
      self beginLine.
      self v3f:#(2 4 -120.0).
      self v3f:#(-2 0 -120.0 ).
      self endLine.
      self beginLine.
      self v3f:#(-2 0 -120.0).
      self v3f:#(2 0 -120.0 ).
      self endLine.

    self popMatrix.


    "------------- white rectangle at 0/0/20 -----------------"

    "
     save current rotation/translation
    "
    self pushMatrix.

    self translateX:0.0 y:0.0 z:-20.

    "
     rotate around y-axis
    "
    self rotateX:0.0 y:rotation z:0.0.
    rotation := rotation + 3.0.

    self color:White.
    self beginClosedLine.
    self v3f:#(-1.0 -1.0 0.0).
    self v3f:#( 1.0 -1.0 0.0).
    self v3f:#( 1.0  1.0 0.0).
    self v3f:#(-1.0  1.0 0.0).
    self endClosedLine.

    self popMatrix.

    "------------- yellow rectangle at 0/0/50 -----------------"

    self pushMatrix.
    self translateX:0.0 y:0.0 z:-50.

    "
     rotate around z-axis
    "
    self rotateX:0.0 y:0.0 z:rotation.

    self color:Yellow.
    self beginClosedLine.
    self v3f:#(-1.0 -1.0 0.0).
    self v3f:#( 1.0 -1.0 0.0).
    self v3f:#( 1.0  1.0 0.0).
    self v3f:#(-1.0  1.0 0.0).
    self endClosedLine.

    self popMatrix.

    "--------------- red circle at 0/0/35----------------------"

    self pushMatrix.
    self translateX:0.0 y:0.0 z:-35.

    "
     rotate around x-axis
    "
    self rotateX:rotation y:0.0 z:0.0.

    self color:Red.
    self circleX:0.0 y:0.0 radius:1.0.

    self popMatrix.

    self swapBuffers

    "Modified: 20.5.1996 / 23:23:11 / cg"
! !

!GLDemo6 methodsFor:'events'!

buttonMotion:state x:x y:y
    state ~= 0 ifTrue:[
	"any button pressed"
	(state bitAnd:(device button1MotionMask)) ~~ 0 ifTrue:[
	    "left button pressed; translate x/y"

	    lastX notNil ifTrue:[
		tX :=  tX + (x - lastX).
	    ].
	    lastX := x.

	    lastY notNil ifTrue:[
		tY :=  tY + (y - lastY).
	    ].
	    lastY := y.
	] ifFalse:[
	    (state bitAnd:(device button2MotionMask)) ~~ 0 ifTrue:[
		"middle button pressed; translate x/z"

		lastX notNil ifTrue:[
		    tX :=  tX + (x - lastX).
		].
		lastX := x.

		lastZ notNil ifTrue:[
		    tZ :=  tZ + (y - lastZ).
		].
		lastZ := y.
	    ] ifFalse:[
		"other button pressed; rotate around z/y"

		lastX notNil ifTrue:[
		    rZ :=  rZ + (x - lastX). 
		].
		lastX := x.

		lastZ notNil ifTrue:[
		    rY :=  rY + (y - lastZ). 
		].
		lastZ := y.
	    ].
	].
    ]
!

buttonPress:state x:x y:y
    "just a hook - nothing done here"
!

buttonRelease:state x:x y:y
    lastX := lastY := lastZ := nil.
! !

!GLDemo6 methodsFor:'initialization'!

destroy
    "stop the redraw process"
    redrawProcess notNil ifTrue:[
	redrawProcess terminate.
	redrawProcess := nil
    ].
    super destroy
!

initialize
    super initialize.
    "
     define the type of view;
	VGL supports #colorIndexSingleBuffer
		 and #colorIndexDoubleBuffer

	real GL additionaly supports
		     #rgbSingleBuffer
		 and #rgbDoubleBuffer
    "
    "
     this will work on any ...
    "
    type := #colorIndexDoubleBuffer.

    rotation := 0.0.
    tX := tY := -50.0. tZ := 0.
    rX := rY := rZ := 0.
!

realize
    super realize.

    "startup a redraw process"

    redrawProcess := [
	[true] whileTrue:[
		self redraw.
		(Delay forSeconds:(1/20)) wait.
	]
    ] forkAt:4.
! !

!GLDemo6 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/Demo6.st,v 1.11 2016-01-21 18:05:15 cg Exp $'
! !

