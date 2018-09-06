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

GLObjectDemoView subclass:#GLOctaHedronDemoView
	instanceVariableNames:'colors'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

!GLOctaHedronDemoView class methodsFor:'documentation'!

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
    This code is an adaption of an example provided by SGI.
    It requires rgb and zBuffer support - therefore, it will not run
    in VGL configurations (i.e. requires full GL).

    [start with:]
        GLOctaHedronDemoView open

    [author:]
        Claus Gittinger
"
! !

!GLOctaHedronDemoView class methodsFor:'defaults'!

defaultLabel
    ^ 'GL coloured octahedron'
! !

!GLOctaHedronDemoView class methodsFor:'startup'!

open 
    "check if display has rgb and zBuffer features"

    |display|

    (display := Screen current) supportsGLDrawing ifFalse:[
        ^ self warn:'sorry, but this view requires a display capable of GL drawing'
    ].
    (display supportsRGB not
    or:[display supportsZBuffer not
    or:[display supportsDoubleBuffer not]]) ifTrue:[
        ^ self warn:'sorry, but this demo requires SGI hardware'
    ].
    ^ super open

    "
     GLOctaHedronDemoView open
    "

    "Modified: / 6.9.1998 / 16:06:09 / cg"
! !

!GLOctaHedronDemoView methodsFor:'drawing'!

drawObject
    self czClearColor:0 z:100000. "/ (SmallInteger maxVal min:(device maxZValue)). 
    self zClear.

    self beginTriangleMesh.
    self vertex:1.
    self vertex:2.
    self swapTriangleMesh.
    self vertex:3.
    self swapTriangleMesh.
    self vertex:5.
    self swapTriangleMesh.
    self vertex:6.
    self swapTriangleMesh.
    self vertex:2.
    self vertex:4.
    self vertex:3.
    self swapTriangleMesh.
    self vertex:5.
    self swapTriangleMesh.
    self vertex:6.
    self swapTriangleMesh.
    self vertex:2.
    self endTriangleMesh
!

vertex:index
    |clr|

    clr := colors at:index.
    self colorRed:(clr at:1) green:(clr at:2) blue:(clr at:3) alpha:255.
    self v3f:(points at:index)
! !

!GLOctaHedronDemoView methodsFor:'initialization'!

initialize
    super initialize.

    type := #rgbDoubleBuffer.
    self setupColors.

    transZ := false.
    rotY := true.
    rotX := false.
    rotZ := false.
!

realize
    super realize.

    self zBuffer:true.
!

setupColors
    "
     setup the 6 colors:
    "

    colors := Array new:6.
    colors at:1 put:#(255   0   0).  
    colors at:2 put:#(  0 255   0).   
    colors at:3 put:#(  0   0 255).   
    colors at:4 put:#(255   0 255).   
    colors at:5 put:#(255 255   0).  
    colors at:6 put:#(255 255 255).   
!

setupPoints
    "
     setup the 6 points:
    "

    points := Array new:6.
    points at:1 put:(GLPoint3D x: 1.0 y: 0.0 z: 0.0).  
    points at:2 put:(GLPoint3D x: 0.0 y: 1.0 z: 0.0).   
    points at:3 put:(GLPoint3D x: 0.0 y: 0.0 z: 1.0).   
    points at:4 put:(GLPoint3D x:-1.0 y: 0.0 z: 0.0).   
    points at:5 put:(GLPoint3D x: 0.0 y:-1.0 z: 0.0).  
    points at:6 put:(GLPoint3D x: 0.0 y: 0.0 z:-1.0).   
! !

!GLOctaHedronDemoView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLOctaHedronDemoView.st,v 1.8 2016-01-21 18:05:38 cg Exp $'
! !

