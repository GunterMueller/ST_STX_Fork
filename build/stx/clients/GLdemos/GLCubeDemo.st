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

GLObjectDemoView subclass:#GLCubeDemoView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

!GLCubeDemoView class methodsFor:'documentation'!

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
    a concrete objectDemo class.
    Draws the cube once (during init) to define it as a GL object.
    Then, in regular intervals, the object is simply called for 
    where a rotation is performed with each animation step.
    All of this is done n the superclass.

    [start with:]
        GLCubeDemoView open

    [author:]
        Claus Gittinger
"
! !

!GLCubeDemoView class methodsFor:'defaults'!

defaultLabel
    "used by superclass"

    ^ 'GL solid cube'
! !

!GLCubeDemoView methodsFor:'drawing'!

drawObject
    "draw the cube"

    self backFace:true.

    "
            p5------p6
           /|      /|
          / |     / |
         /  |    /  |
        p1------p2  |
        |   |   |   |
        |   p8--|---p7
        |  /    |  /
        | /     | /
        |/      |/
        p4------p3
    "

    "front side"
    self color:White.
    self beginPolygon.  
    self v3f:(points at:1).
    self v3f:(points at:2).
    self v3f:(points at:3).
    self v3f:(points at:4).
    self endPolygon. 

    "back side"
    self color:Green.
    self beginPolygon. 
    self v3f:(points at:6).
    self v3f:(points at:5).
    self v3f:(points at:8).
    self v3f:(points at:7).
    self endPolygon. 

    "right side"
    self color:Red.
    self beginPolygon. 
    self v3f:(points at:2).
    self v3f:(points at:6).
    self v3f:(points at:7).
    self v3f:(points at:3).
    self endPolygon. 

    "left side"
    self color:Yellow.
    self beginPolygon. 
    self v3f:(points at:1).
    self v3f:(points at:4).
    self v3f:(points at:8).
    self v3f:(points at:5).
    self endPolygon. 

    "top side"
    self color:Magenta.
    self beginPolygon. 
    self v3f:(points at:3).
    self v3f:(points at:7).
    self v3f:(points at:8).
    self v3f:(points at:4).
    self endPolygon. 

    "bottom side"
    self color:Blue.
    self beginPolygon. 
    self v3f:(points at:1).
    self v3f:(points at:5).
    self v3f:(points at:6).
    self v3f:(points at:2).
    self endPolygon.

    "Modified: 20.5.1996 / 23:33:41 / cg"
! !

!GLCubeDemoView methodsFor:'initialization'!

setupPoints
    "setup the 8 points"

    "
            p5------p6
           /|      /|
          / |     / |
         /  |    /  |
        p1------p2  |
        |   |   |   |
        |   p8--|---p7
        |  /    |  /
        | /     | /
        |/      |/
        p4------p3
    "

    points := Array new:8.
    points at:1 put:(GLPoint3D x:-1.0 y:-1.0 z: 1.0).   "front"
    points at:2 put:(GLPoint3D x: 1.0 y:-1.0 z: 1.0).   
    points at:3 put:(GLPoint3D x: 1.0 y: 1.0 z: 1.0).   
    points at:4 put:(GLPoint3D x:-1.0 y: 1.0 z: 1.0).   
    points at:5 put:(GLPoint3D x:-1.0 y:-1.0 z:-1.0).   "rear"
    points at:6 put:(GLPoint3D x: 1.0 y:-1.0 z:-1.0).   
    points at:7 put:(GLPoint3D x: 1.0 y: 1.0 z:-1.0).   
    points at:8 put:(GLPoint3D x:-1.0 y: 1.0 z:-1.0).

    "Modified: 20.5.1996 / 23:33:27 / cg"
! !

!GLCubeDemoView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLCubeDemo.st,v 1.12 2016-01-21 18:05:04 cg Exp $'
! !

