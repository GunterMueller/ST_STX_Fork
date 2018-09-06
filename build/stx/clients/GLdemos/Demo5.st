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

GLXView subclass:#GLDemo5
	instanceVariableNames:'redrawProcess rotation'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLDemo5 comment:'
simple GL demo - see class method #documentation
'
!

!GLDemo5 class methodsFor:'documentation'!

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
    a very simple GL view;
    sets up a transformation and draws some simple objects.
    with every redraw, objects are rotated a bit around different axes

    [start with:]
        GLDemo5 open

    [author:]
        Claus Gittinger
"
! !

!GLDemo5 class methodsFor:'defaults'!

defaultExtent
    "used by superclass"

    ^ 300 @ 300
!

defaultLabel
    "used by superclasses open-method"

    ^ 'GL: rotations'
! !

!GLDemo5 methodsFor:'drawing'!

redraw 
    "redraw the picture"

    "
     define perspective-viewing
        0.0                                   200.0
    eye                                   
        near                                  far
    <)  -------------+------+-----------------+-------------------+
                     \      \                  \                   \
                      \      \                  \                   \
                       \      \                  \                   \
                        +------+                  \                   \
                                                   \                   \
                                                    \                   \
                                                     \                   \
                                                      \                   \
                                                       +-------------------+

         ---> negative z coordinates
    "

    self perspectiveFovy:450 aspect:1.0 near:0.0 far:200.0. 

    "
     zoom into z
    "
    self translateX:0 y:0 z:5.0.

    "
     clear the drawing area
    "
    self color:Black.    
    self clear.        


    "------------- white rectangle -----------------"

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

    "------------- yellow rectangle -----------------"

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

    "--------------- red circle ----------------------"

    self pushMatrix.
    self translateX:0.0 y:0.0 z:-20.

    "
     rotate around x-axis
    "
    self rotateX:rotation y:0.0 z:0.0.

    self color:Red.
    self circleX:0.0 y:0.0 radius:1.0.

    self popMatrix.

    self swapBuffers

    "Modified: 20.5.1996 / 23:23:17 / cg"
! !

!GLDemo5 methodsFor:'initialization'!

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

    rotation := 0.0
!

realize
    super realize.

    "startup a redraw process"

    redrawProcess := [
	[true] whileTrue:[
		self redraw.
		(Delay forSeconds:(1/10)) wait.
	]
    ] forkAt:4
! !

!GLDemo5 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/Demo5.st,v 1.9 2016-01-21 18:05:12 cg Exp $'
! !

