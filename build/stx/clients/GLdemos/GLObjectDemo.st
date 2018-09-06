"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

GLXView subclass:#GLObjectDemoView
	instanceVariableNames:'trans angleX angleY angleZ deltaTrans deltaRot minTrans maxTrans
		points rotX rotY rotZ transZ objectId redrawBlock myProcess
		deltaT fullSpeed redrawLock'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLObjectDemoView comment:'
COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved
'
!

!GLObjectDemoView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    abstract class for rotating objects animation demos.
    The object is drawn once (during init) and thereby defined
    as a GL object. Then, in regular intervals, the object is
    simply called for (i.e. drawing is done completely in GL).

    Concrete subclasses should redefine #drawObject and #setupPoints.

    start with:
	GLWireCubeDemoView open
	GLCubeDemoView open
	GLTetraDemoView open

    Notice: for ST/X configurations without multiple processes
	    (i.e. pureEventDriven systems) this demo installs
	    a timeout-block to do the animation.

	    For normal systems, the animation is done by a
	    low-priority background process, sending #animate
	    in regular intervals.
"
! !

!GLObjectDemoView class methodsFor:'defaults'!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    ^ 300 @ 300

    "Modified: 22.4.1996 / 23:36:22 / cg"
! !

!GLObjectDemoView class methodsFor:'queries'!

isVisualStartable
    ^ self ~~ GLObjectDemoView
! !

!GLObjectDemoView methodsFor:'drawing'!

animate
    "rotate and/or translate; then redraw"

    rotX ifTrue:[angleX := angleX + deltaRot].
    rotY ifTrue:[angleY := angleY + deltaRot].
    rotZ ifTrue:[angleZ := angleZ + deltaRot].
    transZ ifTrue:[
        trans := trans + deltaTrans.
        ((trans > maxTrans) or:[trans < minTrans]) ifTrue:[
            deltaTrans := deltaTrans negated
        ].
    ].
    self sensor flushExposeEvents.
    self redraw.

    "Modified: / 12.4.1998 / 12:56:56 / cg"
!

drawFrame
    "
     let GL draw the previously defined object
    "
    self callObject:objectId.
!

drawObject
    "this should be redefined in concrete subclasses,
     to draw the object (using GL functions only)."

    self subclassResponsibility
!

redraw 
    device supportsGLDrawing ifFalse:[^self].

    realized ifTrue:[

        "
         do not draw, if iconified
        "
        shown ifTrue:[
            redrawLock critical:[
                "
                 clear the drawing area
                "
                (type == #colorIndexDoubleBuffer
                or:[type == #colorIndex]) ifTrue:[
                    self color:Black
                ] ifFalse:[
                    self colorRed:0 green:0 blue:0.
                ].
                self clear.

                "
                 save current rotation/translation
                "
                self pushMatrix.

                "
                 rotate/translate
                "
                self translateZ:trans.
                self rotateX:angleX y:angleY z:angleZ.

                self drawFrame.

                "
                 restore rotation/translation
                "
                self popMatrix.
                "
                 swap buffers for next round
                "
                self swapBuffers.
            ]
        ].
        "
         on systems without processes, install a timed-block
         for the next frame.
        "
        redrawBlock notNil ifTrue:[
            Processor addTimedBlock:redrawBlock afterSeconds:deltaT
        ]
    ]

    "Modified: / 27.7.1998 / 20:11:57 / cg"
!

setupPoints
    "this should be redefined in concrete subclasses,
     to setup the points of the animated object."

    self subclassResponsibility
! !

!GLObjectDemoView methodsFor:'initialization'!

destroy 
    device supportsGLDrawing ifTrue:[
        redrawLock notNil ifTrue:[
            redrawLock critical:[
                redrawBlock notNil ifTrue:[
                    Processor removeTimedBlock:redrawBlock.
                    redrawBlock := nil.
                ] ifFalse:[
                    myProcess notNil ifTrue:[
                        myProcess terminate.
                        myProcess := nil
                    ]
                ].
            ].
        ].
        objectId notNil ifTrue:[
            self deleteObject:objectId.
            objectId := nil.
        ].
    ].
    super destroy

    "Modified: / 27.7.1998 / 20:12:06 / cg"
!

initialize
    super initialize.

    self menuMessage:#middleButtonMenu.

    type := #colorIndexDoubleBuffer.

    ProcessorScheduler isPureEventDriven ifTrue:[
        redrawBlock := [self animate].
    ].

    "
     time delta between frames
    "
    fullSpeed := false.
    deltaT := 1/60.

    "
     initial rotation and translation
    "
    angleX := angleY := angleZ := 0.0.
    trans := -5.0.
    "
     delta-rotation/translation for each frame
    "
    deltaRot := 3.0.
    deltaTrans := 0.2.
    "
     bounds for translation
    "
    minTrans := -20.0.
    maxTrans := -3.0.

    "
     yes, we rotate and translate
    "
    rotX := true.
    rotY := true.
    rotZ := true.
    transZ := true.

    self setupPoints

    "Modified: 6.3.1996 / 16:38:01 / cg"
!

middleButtonMenu
    |m|

    m := PopUpMenu 
                labels:#(
                        '\c rotate x'
                        '\c rotate y'
                        '\c rotate z'
                        '-'
                        '\c translate Z'
                        '-'
                        'faster'
                        'slower'
"/                        '\c full speed'
                 )
                 selectors:#(
                        rotX: 
                        rotY: 
                        rotZ: 
                        nil 
                        transZ: 
                        nil 
                        faster 
                        slower
"/                        fullSpeed:
                 ).

    m checkToggleAt:#rotX: put:rotX.
    m checkToggleAt:#rotY: put:rotY.
    m checkToggleAt:#rotZ: put:rotZ.
    m checkToggleAt:#transZ: put:transZ.
    m checkToggleAt:#stay: put:false.
    m checkToggleAt:#fullSpeed: put:fullSpeed.

    "/ shadow looks ugly over animated views

    m noShadow.
    ^ m.
!

realize 
    super realize.
    device supportsGLDrawing ifFalse:[^ self].

    redrawLock isNil ifTrue:[
	"/ not already initialized

	redrawLock := Semaphore forMutualExclusion.

	self setupViewing. 
	self backBuffer.

	"
	 define a new GL object
	"
	objectId := self newObjectId.
	self makeObject:objectId.
	self drawObject.
	self closeObject.

	"
	 on pure event driven systems (redrawBlock notNil)
	 install it via the timeout mechanism.
	 On normal systems, start a low-prio thread to do
	 the animation.
	"
	redrawBlock notNil ifTrue:[
	    Processor addTimedBlock:redrawBlock afterSeconds:deltaT
	] ifFalse:[
	    myProcess := [
		|d|

		[true] whileTrue:[
		    shown ifTrue:[
			fullSpeed ifFalse:[
			    Delay waitForSeconds:deltaT.
			].
			self animate
		    ] ifFalse:[
			"
			 delay a bit longer if iconified
			"
			Delay waitForSeconds:deltaT * 4.
		    ]
		]
	    ] forkAt:4.
	    myProcess name:'GL animation'
	]
    ]

    "Modified: / 27.7.1998 / 20:11:31 / cg"
!

reinitialize
    super reinitialize.
    redrawLock := nil.
    self realize. 
!

setupViewing
    "
     define perspective (see GL manual)
    "
    self perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0. 
!

unrealize 
    redrawLock critical:[
        redrawBlock notNil ifTrue:[
            Processor removeTimedBlock:redrawBlock.
            redrawBlock := nil.
        ] ifFalse:[
            myProcess notNil ifTrue:[
                myProcess terminate.
                myProcess := nil
            ]
        ].
    ].
    super unrealize.
    objectId notNil ifTrue:[
        self deleteObject:objectId.
        objectId := nil.
    ]

    "Modified: 6.3.1996 / 16:29:01 / cg"
! !

!GLObjectDemoView methodsFor:'menu actions'!

faster
    "faster - make delta-rotation a bit bigger"

    deltaRot := deltaRot * 2.
    deltaTrans := deltaTrans * 2
!

fullSpeed:aBoolean
    "turn on/off delays"

    fullSpeed := aBoolean.
!

rotX:aBoolean
    "turn on/off x-rotation"

    rotX := aBoolean.
!

rotY:aBoolean
    "turn on/off y-rotation"

    rotY := aBoolean.
!

rotZ:aBoolean
    "turn on/off z-rotation"

    rotZ := aBoolean.
!

slower 
    "slower - make delta-rotation a bit smaller"

    deltaRot := deltaRot / 2.
    deltaTrans := deltaTrans / 2
!

stay:aBoolean
    "stop - turn on/off all rotations/translations"

    rotX := rotY := rotZ := transZ := aBoolean not.
!

transZ:aBoolean
    "turn on/off z-translation"

    transZ := aBoolean.
! !

!GLObjectDemoView methodsFor:'queries'!

redrawsFull
    ^ true

    "Created: 4.3.1996 / 14:17:44 / cg"
! !

!GLObjectDemoView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLObjectDemo.st,v 1.28 2016-01-21 18:05:33 cg Exp $'
! !

