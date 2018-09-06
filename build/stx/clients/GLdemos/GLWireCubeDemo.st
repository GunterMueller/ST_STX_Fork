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

GLCubeDemoView subclass:#GLWireCubeDemoView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

!GLWireCubeDemoView class methodsFor:'documentation'!

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
    a concrete objectDemo class.
    Draws the cube once (during init) to define it as a GL object.
    Then, in regular intervals, the object is simply called for 
    where a rotation is performed with each animation step.
    All of this is done n the superclass.

    [start with:]
        GLWireCubeDemoView open

    [author:]
        Claus Gittinger
"

! !

!GLWireCubeDemoView class methodsFor:'defaults'!

defaultLabel
    "used by superclass"

    ^ 'GL wireframe cube'
! !

!GLWireCubeDemoView methodsFor:'drawing'!

drawObject
    "draw the cube"

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

    "front edges"
    self color:White.
    self beginClosedLine.  
    self v3f:(points at:1).
    self v3f:(points at:2).
    self v3f:(points at:3).
    self v3f:(points at:4).
    self endClosedLine. 

    "back edges"
    self color:Green.
    self beginClosedLine. 
    self v3f:(points at:6).
    self v3f:(points at:5).
    self v3f:(points at:8).
    self v3f:(points at:7).
    self endClosedLine. 

    "right edges"
    self color:Red.
    self beginLine. 
    self v3f:(points at:2).
    self v3f:(points at:6).
    self endLine.
    self beginLine.
    self v3f:(points at:7).
    self v3f:(points at:3).
    self endLine. 

    "left edges"
    self color:Yellow.
    self beginLine. 
    self v3f:(points at:1).
    self v3f:(points at:5).
    self endLine.
    self beginLine.
    self v3f:(points at:4).
    self v3f:(points at:8).
    self endLine. 
! !

!GLWireCubeDemoView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLWireCubeDemo.st,v 1.8 2016-01-21 18:05:36 cg Exp $'
! !

