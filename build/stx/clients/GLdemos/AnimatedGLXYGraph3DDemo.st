"
 COPYRIGHT (c) 1998 by eXept Software AG
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

"{ NameSpace: CodingExamples_GUI }"

GLXYGraph3DDemo subclass:#AnimatedGLXYGraph3DDemo
	instanceVariableNames:'animationProcess scale1 scale2 quo'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-3D'
!

!AnimatedGLXYGraph3DDemo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    An animated example, showing how the GLXYGraph widget can be
    incorporated into a GUI-Builder application.
    Especially, have a look at how all of the parameters and
    look is controlled by channels (i.e. valueHolders).
    Here, we make use of the fact that the widget redraws its picture,
    when the functionBlockHolder gets a new value; thus all
    we have to do for animation is to put a new functionBlock
    value into that valueHolder every 20th of a second
    (actually, the same block is stuffed in again - but that
     has the same effect ...)

    [author:]
        Claus Gittinger

    [see also:]
        Demos::GLXYGraph
        Demos::GLXYGraphSpec
"

! !

!AnimatedGLXYGraph3DDemo methodsFor:'animation'!

animate
    scale1 := scale1 * quo.
    scale2 := scale2 * quo.
    scale1 > 5 ifTrue:[
        quo := 1 / quo
    ] ifFalse:[
        scale1 < 0.5 ifTrue:[
            quo := 1 / quo.
quo := 1.05.
        ]
    ].

    "/ simply storing the function again will force a redraw
    self graphHolder value:(self function)

    "Created: / 5.6.1998 / 04:25:57 / cg"
    "Modified: / 5.6.1998 / 04:35:47 / cg"
!

animationFrameDelta
    "millisecond delta between animation frames"

    ^ 50

    "Modified: / 6.6.1998 / 23:32:52 / cg"
!

animationProcess
    ^ [
            [
                |now next|

                now := Timestamp now.
                [true] whileTrue:[
                    next := now addMilliseconds:(self animationFrameDelta).

                    self animate.

                    now := Timestamp now.
                    Delay waitForMilliseconds:(next millisecondDeltaFrom:now).
                    now := next.
                ]
            ] ifCurtailed:[
                animationProcess := nil
            ]
       ] newProcess

    "Created: / 6.6.1998 / 23:23:58 / cg"
    "Modified: / 14.6.1998 / 17:37:02 / cg"
! !

!AnimatedGLXYGraph3DDemo methodsFor:'aspects'!

function 
    ^ [:x :y | (x * scale1) sin * (y * scale2) sin].

    "Created: / 5.6.1998 / 04:24:10 / cg"
    "Modified: / 5.6.1998 / 04:32:52 / cg"
! !

!AnimatedGLXYGraph3DDemo methodsFor:'hooks'!

closeRequest
    animationProcess notNil ifTrue:[
        animationProcess terminate
    ].
    super closeRequest

    "Created: / 6.6.1998 / 23:28:13 / cg"
!

postOpenWith:aBuilder
    "start the animation process"

    animationProcess isNil ifTrue:[
        ((builder componentAt:#graphView) subViews first) isAnimated:true.

        animationProcess := self animationProcess.
        animationProcess restartable:true.
        "/ animationProcess priority:9.
        animationProcess resume.
    ]

    "Created: / 6.6.1998 / 23:24:25 / cg"
    "Modified: / 14.6.1998 / 17:30:31 / cg"
! !

!AnimatedGLXYGraph3DDemo methodsFor:'initialization'!

initialize
    scale1 := scale2 := 1.
    quo := 1.1.
    super initialize

    "Created: / 5.6.1998 / 04:27:26 / cg"
    "Modified: / 5.6.1998 / 04:28:43 / cg"
! !

!AnimatedGLXYGraph3DDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/AnimatedGLXYGraph3DDemo.st,v 1.8 2016-01-21 18:04:32 cg Exp $'
! !

