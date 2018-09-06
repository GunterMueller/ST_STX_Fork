"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

GLObjectDemoView subclass:#GLTetraDemoView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLTetraDemoView comment:'
a simple tetrahedron.

start with:
    GLTetraDemoView open
'
!

!GLTetraDemoView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    a rotating solid tetrahedron

    [start with:]
        GLTetraDemoView open

    [author:]
        Claus Gittinger
"



! !

!GLTetraDemoView class methodsFor:'defaults'!

defaultLabel
    "used by superclass"

    ^ 'GL solid tetra'
! !

!GLTetraDemoView methodsFor:'drawing'!

drawObject

    self backFace:true.

    self color:Blue.
    self beginPolygon.  
    self v3f:(points at:3).
    self v3f:(points at:2).
    self v3f:(points at:1).
    self endPolygon. 

    self color:Green.
    self beginPolygon. 
    self v3f:(points at:1).
    self v3f:(points at:2).
    self v3f:(points at:4).
    self endPolygon. 

    self color:Red.
    self beginPolygon. 
    self v3f:(points at:2).
    self v3f:(points at:3).
    self v3f:(points at:4).
    self endPolygon. 

    self color:Yellow.
    self beginPolygon. 
    self v3f:(points at:3).
    self v3f:(points at:1).
    self v3f:(points at:4).
    self endPolygon. 
! !

!GLTetraDemoView methodsFor:'initialization'!

setupPoints 
    points := Array new:4.
    points at:1 put:(GLPoint3D x: -0.5 y: 0.866 z: -0.667).   
    points at:2 put:(GLPoint3D x: -0.5 y:-0.866 z: -0.667).   
    points at:3 put:(GLPoint3D x:  1.0 y: 0.0   z: -0.667).   
    points at:4 put:(GLPoint3D x:  0.0 y: 0.0   z: 1.334).   
! !

!GLTetraDemoView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLTetraDemo.st,v 1.8 2016-01-21 18:05:41 cg Exp $'
! !

