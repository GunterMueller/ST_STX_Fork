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

GLObjectDemoView subclass:#GLCubeDemoView2
	instanceVariableNames:'rotLightMatrix lightPos light lightModel material normals'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

!GLCubeDemoView2 class methodsFor:'documentation'!

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
    another rotating cube - this one requires a real GL
    (i.e. it will not run with VGL)

    [start with:]
        GLCubeDemoView2 open

    [author:]
        Claus Gittinger
"

! !

!GLCubeDemoView2 class methodsFor:'defaults'!

defaultExtent
    ^ 500 @ 500
!

defaultLabel
    "used by superclass"

    ^ 'GL solid cube & light'
! !

!GLCubeDemoView2 class methodsFor:'startup'!

open 
    "check if display has rgb features"

    |screen|

    (screen := Screen current) supportsGLDrawing ifFalse:[
        ^ self warn:'sorry, but this view requires a display capable of GL drawing'
    ].
    screen supportsLight ifFalse:[
        ^ self warn:'sorry, but this demo requires a GL with light support'
    ].
    ^ super open

    "Modified: / 13.3.1998 / 18:32:02 / cg"
! !

!GLCubeDemoView2 methodsFor:'drawing'!

defineLightAndMaterial
    self lmdef:#light      index:1 np:0 props:light.
    self lmdef:#material   index:1 np:0 props:material.
    self lmdef:#lightModel index:1 np:0 props:lightModel.
!

drawObject
    self lmbind:#material   index:1.

    self backFace:true.

    "front side"
    self beginPolygon.  
    self n3f:(normals at:1).
    self v3f:(points at:1).
    self v3f:(points at:2).
    self v3f:(points at:3).
    self v3f:(points at:4).
    self endPolygon. 

    "back side"
    self beginPolygon. 
    self n3f:(normals at:6).
    self v3f:(points at:6).
    self v3f:(points at:5).
    self v3f:(points at:8).
    self v3f:(points at:7).
    self endPolygon. 

    "right side"
    self beginPolygon. 
    self n3f:(normals at:2).
    self v3f:(points at:2).
    self v3f:(points at:6).
    self v3f:(points at:7).
    self v3f:(points at:3).
    self endPolygon. 

    "left side"
    self beginPolygon. 
    self n3f:(normals at:3).
    self v3f:(points at:1).
    self v3f:(points at:4).
    self v3f:(points at:8).
    self v3f:(points at:5).
    self endPolygon. 

    "top side"
    self beginPolygon. 
    self n3f:(normals at:5).
    self v3f:(points at:3).
    self v3f:(points at:7).
    self v3f:(points at:8).
    self v3f:(points at:4).
    self endPolygon. 

    "bottom side"
    self beginPolygon. 
    self n3f:(normals at:4).
    self v3f:(points at:1).
    self v3f:(points at:5).
    self v3f:(points at:6).
    self v3f:(points at:2).
    self endPolygon. 
!

redraw
    "/
    "/ do not draw, if unmapped
    "/
    realized ifFalse:[^ self].

    "/
    "/ do not draw, if iconified
    "/
    shown ifFalse:[^ self].

    self perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.

    self mMode:#viewing.

    self lmbind:#material   index:1.
    self lmbind:#light0     index:1.
    self lmbind:#lightModel index:1.

    self colorRed:0 green:0 blue:0.
    self clear.

"/    "rotate the light"
"/
"/    self pushMatrix.
"/    self loadMatrix:IdentityMatrix.
"/    self rotateIX:1.
"/    self rotateIY:2.
"/    self multMatrix:rotLightMatrix.
"/    self lmdef:#light index:1 np:0 props:lightPos.
"/    self getMatrix:rotLightMatrix.
"/    self popMatrix.

    "/
    "/ rotate & draw the object
    "/
    self pushMatrix.
    self translateZ:trans.
    self rotateX:angleX y:angleY z:angleZ.
    self callObject:objectId.
    self popMatrix.

    self swapBuffers.
! !

!GLCubeDemoView2 methodsFor:'initialization'!

initialize
    super initialize.
    type := #rgbDoubleBuffer.

    deltaRot := 0.75.
    deltaTrans := 0.05.
    transZ := false.

    rotLightMatrix := IdentityMatrix copy.

"/    lightPos := FloatArray withAll:#(
"/                                      102.0 "POSITION"     0.0 0.0 1.0 0.0 
"/                                        0.0 "END" 
"/                                    ).

    light :=    FloatArray withAll:#(
                                        2.0 "AMBIENT"      0.1 0.1 0.1
                                      101.0 "LCOLOR"       1.0 1.0 1.0
                                   "/   102.0 "POSITION"     90.0 90.0 -150.0 0.0
                                      102.0 "POSITION"     100.0 1000.0 -100.0 0.0
                                        0.0 "END" 
                                    ).


    lightModel :=    FloatArray withAll:#(   
                                        2.0 "AMBIENT"      1.0 1.0 1.0
                                      201.0 "LOCALVIEWER"  0.0
                                        0.0 "END" 
                                         ).

    material := FloatArray withAll:#(
                                        5.0 "SHININESS"    30.0
                                        4.0 "SPECULAR"     0.2 0.2 0.2
                                        0.0 "END" 
                                    ).
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
                        '='
                        'material'
                        'light'
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
                        nil
                        material
                        light
                 ).

    m checkToggleAt:#rotX: put:rotX.
    m checkToggleAt:#rotY: put:rotY.
    m checkToggleAt:#rotZ: put:rotZ.
    m checkToggleAt:#transZ: put:transZ.
    m checkToggleAt:#stay: put:false.
    m checkToggleAt:#fullSpeed: put:fullSpeed.

    m subMenuAt:#material
        put:(PopUpMenu
                labels:#(
                          'gold'
                          'silver'
                          'brass'
                          '-'
                          'red plastic'
                          'red rubber'
                          '-'
                          'lapis'
                        )
                selectors:#setMaterial:
                args:#(
                        material_Gold
                        material_Silver
                        material_Brass
                        nil
                        material_RedPlastic
                        material_RedRubber
                        nil
                        material_Lapis
                       )
            ).

    m subMenuAt:#light
        put:(PopUpMenu
                labels:#(
                          'white'
                          'red'
                          'green'
                          'blue'
                        )
                selectors:#setLight:
                args:#(
                        ( 1.0 1.0 1.0)
                        ( 1.0 0.0 0.0)
                        ( 0.0 1.0 0.0)
                        ( 0.0 0.0 1.0)
                       )
            ).

    "/ shadow looks ugly over animated views

    m noShadow.
    ^ m.
!

realize
    super realize.
    self defineLightAndMaterial
!

recreate
    super recreate.
    self defineLightAndMaterial
!

setLight:rgbVector
    light :=    FloatArray withAll:#(
                                        2.0 "AMBIENT"      0.1 0.1 0.1
                                      101.0 "LCOLOR"   ) , rgbVector , #(
                                      102.0 "POSITION"     90.0 90.0 -150.0 0.0
                                        0.0 "END" 
                                    ).

    self lmdef:#light      index:1 np:0 props:light.

!

setMaterial:aConstantMaterialSelector
    material := self class perform:aConstantMaterialSelector.
    self lmdef:#material   index:1 np:0 props:material.

!

setupPoints
    points := Array new:8.
    points at:1 put:(GLPoint3D x:-1.0 y:-1.0 z: 1.0).   "front bot-left"
    points at:2 put:(GLPoint3D x: 1.0 y:-1.0 z: 1.0).   "      bot-right"
    points at:3 put:(GLPoint3D x: 1.0 y: 1.0 z: 1.0).   "      top-right"
    points at:4 put:(GLPoint3D x:-1.0 y: 1.0 z: 1.0).   "      top-left"
    points at:5 put:(GLPoint3D x:-1.0 y:-1.0 z:-1.0).   "rear"
    points at:6 put:(GLPoint3D x: 1.0 y:-1.0 z:-1.0).   
    points at:7 put:(GLPoint3D x: 1.0 y: 1.0 z:-1.0).   
    points at:8 put:(GLPoint3D x:-1.0 y: 1.0 z:-1.0).  

    normals := Array new:6.
    normals at:1 put:(GLPoint3D x: 0.0 y: 0.0 z:-1.0).   "front"
    normals at:2 put:(GLPoint3D x:-1.0 y: 0.0 z: 0.0).   "right"
    normals at:3 put:(GLPoint3D x: 1.0 y: 0.0 z: 0.0).   "left"
    normals at:4 put:(GLPoint3D x: 0.0 y: 1.0 z: 0.0).   "bottom"
    normals at:5 put:(GLPoint3D x: 0.0 y:-1.0 z: 0.0).   "top"
    normals at:6 put:(GLPoint3D x: 0.0 y: 0.0 z: 1.0).   "rear"
! !

!GLCubeDemoView2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLCubeDemo2.st,v 1.16 2016-01-21 18:05:08 cg Exp $'
! !

