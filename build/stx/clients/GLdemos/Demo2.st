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

GLXView subclass:#GLDemo2
	instanceVariableNames:'redrawProcess rotation'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLDemo2 comment:'
simple GL demo - see class method #documentation
'
!

!GLDemo2 class methodsFor:'documentation'!

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
    sets up a transformation and draws a simple 2D figure.
    with every redraw, one object is rotated a bit around the z-axis

    [start with:]
        GLDemo2 open

    [author:]
        Claus Gittinger
"
! !

!GLDemo2 class methodsFor:'defaults'!

defaultExtent
    "used by superclass"

    ^ 300 @ 300
!

defaultLabel
    "used by superclasses open-method"

    ^ 'GL: rotation around z'
! !

!GLDemo2 methodsFor:'drawing'!

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
     clear the drawing area
    "
    self color:Black.    "Black is a class variable in GLXView"
    self clear.          "clear to current color"


    "------------------ white rectangle ---------------"

    "
     save current rotation/translation
    "
    self pushMatrix.

    "
     the rectangle is at 0/0/-20
    "
    self translateX:0 y:0 z:-20.0.

    "
     rotate around z-axis
    "
    self rotateX:0.0 y:0.0 z:rotation.
    rotation := rotation + 3.0.

    "
     draw a rectangle
    "
    self color:White.
    self beginClosedLine.
    self v3f:#(-1.0 -1.0 0.0).
    self v3f:#( 1.0 -1.0 0.0).
    self v3f:#( 1.0  1.0 0.0).
    self v3f:#(-1.0  1.0 0.0).
    self endClosedLine.

    "
     restore transformation
    "
    self popMatrix.



    "------------------ yellow rectangle ---------------"


    self pushMatrix.

    "
     the other rectangle is at 0/0/-50
    "
    self translateX:0 y:0 z:-50.0.

    "
     draw another rectangle
    "
    self color:Yellow.
    self beginClosedLine.
    self v3f:#(-1.0 -1.0 0.0).
    self v3f:#( 1.0 -1.0 0.0).
    self v3f:#( 1.0  1.0 0.0).
    self v3f:#(-1.0  1.0 0.0).
    self endClosedLine.

    self popMatrix.

    "Modified: 20.5.1996 / 23:23:28 / cg"
! !

!GLDemo2 methodsFor:'initialization'!

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
    type := #colorIndexSingleBuffer.

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

!GLDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/Demo2.st,v 1.9 2016-01-21 18:05:10 cg Exp $'
! !

