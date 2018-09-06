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

GLXView subclass:#GLPlaneDemoView1
	instanceVariableNames:'angle deltaT redrawBlock v1 v2 v3 v4'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLPlaneDemoView1 comment:'
rotating plane - without double buffer.
corresponds to a demo (in c) found in examples

start with:
    GLPlaneDemoView1 open
'
!

!GLPlaneDemoView1 class methodsFor:'documentation'!

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
    a rotating plane as simple GL demo;

    [start with:]
        GLPlaneDemoView1 open

    [author:]
        Claus Gittinger
"

! !

!GLPlaneDemoView1 class methodsFor:'defaults'!

defaultExtent
    ^ 300 @ 300
!

defaultLabel
    "used by superclass"

    ^ 'GL plane'
! !

!GLPlaneDemoView1 methodsFor:'drawing'!

redraw 
    self color:Black.
    self clear.

    self pushMatrix.

    self rotateX:angle.
    self rotateY:angle+1.

    self scaleX:45 y:45 z:0.

    self color:Red.
    self beginPolygon.
    self v3f:v1.
    self v3f:v2.
    self v3f:v3.
    self v3f:v4.
    self endPolygon.

    self popMatrix.

    Processor addTimedBlock:redrawBlock afterSeconds:deltaT
! !

!GLPlaneDemoView1 methodsFor:'initialization'!

initialize
    super initialize.
    type := #colorIndexSingleBuffer.
    angle := 0.0.
    deltaT := 0.05.
    redrawBlock := [angle := angle + 3.0. self redraw].

    v1 := FloatArray withAll:#(-1.0 -1.0 0.0).
    v2 := FloatArray withAll:#( 1.0 -1.0 0.0).
    v3 := FloatArray withAll:#( 1.0  1.0 0.0).
    v4 := FloatArray withAll:#(-1.0  1.0 0.0).

    "GLPlaneDemoView1 new inspect"
!

realize
    super realize.
    self perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0. 
    self translateX:0 y:0 z:-150.

    Processor addTimedBlock:redrawBlock afterSeconds:deltaT
!

unrealize 
    Processor removeTimedBlock:redrawBlock.
    super unrealize.
! !

!GLPlaneDemoView1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLPlaneDemo1.st,v 1.7 2016-01-21 18:05:29 cg Exp $'
! !

