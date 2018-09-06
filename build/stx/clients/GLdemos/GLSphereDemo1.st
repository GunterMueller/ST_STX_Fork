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

GLXView subclass:#GLSphereDemoView1
	instanceVariableNames:'angle redrawBlock deltaT rotLightMatrix sphere lightPos light
		lightModel material'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLSphereDemoView1 comment:'
a sphere and a light rotating around - without double buffer.
corresponds to a demo (in c) found in examples

start with:
    GLSphereDemoView1 open
'
!

!GLSphereDemoView1 class methodsFor:'documentation'!

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
    a rotating shpere as simple GL demo;

    [start with:]
        GLSphereDemoView1 open

    [author:]
        Claus Gittinger
"



! !

!GLSphereDemoView1 class methodsFor:'defaults'!

defaultExtent
    ^ 200 @ 200
!

defaultLabel
    "used by superclass"

    ^ 'GL sphere'
! !

!GLSphereDemoView1 class methodsFor:'startup'!

open 
    "check if display has rgb features"

    Screen current supportsGLDrawing ifFalse:[
        ^ self warn:'sorry, but this view requires a display capable of GL drawing'
    ].
    Screen current supportsLight ifFalse:[
        ^ self warn:'sorry, but this demo requires a GL with light support'
    ].
    ^ super open

    "Modified: / 6.9.1998 / 16:05:04 / cg"
! !

!GLSphereDemoView1 methodsFor:'drawing'!

redraw 
    self lmdef:#light      index:1 np:0 props:light.
    self lmdef:#material   index:1 np:0 props:material.
    self lmdef:#lightModel index:1 np:0 props:lightModel.

    self mMode:#viewing.

    self perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.

    self lmbind:#material   index:1.
    self lmbind:#light0     index:1.
    self lmbind:#lightModel index:1.

    self colorRed:0 green:0 blue:0.
    self clear.

    self pushMatrix.
    self loadMatrix:IdentityMatrix.
    self rotateIX:6.
    self rotateIY:8.
    self multMatrix:rotLightMatrix.
    self lmdef:#light index:1 np:0 props:lightPos.
    self getMatrix:rotLightMatrix.
    self popMatrix.

    self pushMatrix.
    self translateX:0 y:0 z:-150.
    self colorRed:255 green:255 blue:255.
    self sphDraw:sphere.

    self popMatrix.

    Processor addTimedBlock:redrawBlock afterSeconds:deltaT

! !

!GLSphereDemoView1 methodsFor:'initialization'!

initialize
    super initialize.
    type := #rgbSingleBuffer.
    redrawBlock := [angle := angle + 3.0. self redraw].

    angle := 0.0.
    sphere := FloatArray with:0.0 with:0.0 with:0.0 with:50.0.
    deltaT := 0.05.
    rotLightMatrix := IdentityMatrix copy.

    lightPos := FloatArray withAll:#( 102.0 "POSITION"     0.0 0.0 1.0 0.0 
					0.0 "END" ).

    light :=    FloatArray withAll:#(   2.0 "AMBIENT"      0.1 0.1 0.1
				      101.0 "LCOLOR"       0.5 1.0 1.0
				      102.0 "POSITION"     90.0 90.0 150.0 0.0
					0.0 "END" ).


    lightModel :=    FloatArray withAll:#(   2.0 "AMBIENT"      1.0 1.0 1.0
				      201.0 "LOCALVIEWER"  0.0
					0.0 "END" ).

    material := FloatArray withAll:#(   5.0 "SHININESS"    30.0
					4.0 "SPECULAR"     0.2 0.2 0.2
					0.0 "END" ).

!

mapped 
    super mapped.
    Processor addTimedBlock:redrawBlock afterSeconds:deltaT
!

unmapped 
    Processor removeTimedBlock:redrawBlock.
    super unmapped.
! !

!GLSphereDemoView1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLSphereDemo1.st,v 1.11 2016-01-21 18:05:39 cg Exp $'
! !

