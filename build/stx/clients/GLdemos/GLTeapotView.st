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

GLXView subclass:#GLTeapotView
	instanceVariableNames:'points patches scaleX scaleY scaleZ rotX rotY rotZ transX transY
		transZ drawMode lightMatrix lightPos light lightModel material t'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLTeapotView comment:'
after I got a file containing the coordinates of the teapot:
here is a little (very simple) program - dont expect too much of it.
But: it brings 3D to smalltalk - and on an SGI, the output looks pretty good 

start with:
    GLTeapotView open

HELP: if anyone knows more about the GL library: please send me the
code to do real solids, lights and materials. I have no longer access to
an SGI ... (and the day I had it here was not enough time to finish it)

'
!

!GLTeapotView class methodsFor:'documentation'!

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
    display a teapot

    [start with:]
        GLTeapotDemo open

    [author:]
        Claus Gittinger
"


! !

!GLTeapotView class methodsFor:'defaults'!

defaultExtent
    ^ 400@400
! !

!GLTeapotView methodsFor:'accessing'!

lightX:lX 
     lightPos at:2 put:lX.
     self redraw
!

lightY:lY 
     lightPos at:3 put:lY.
     self redraw
!

lightZ:lZ 
     lightPos at:4 put:lZ.
     self redraw
!

mode:aSymbol
     drawMode := aSymbol.
     self redraw
!

rotX:degrees
     rotX := (degrees * 10) rounded.
     self redraw
!

rotY:degrees
     rotY := (degrees * 10) rounded.
     self redraw
!

rotZ:degrees
     rotZ := (degrees * 10) rounded.
     self redraw
!

scale:p
     scaleX := scaleY := scaleZ := p.
     self redraw
!

scaleX:p
     scaleX := p rounded.
     self redraw
!

scaleY:p
     scaleY := p rounded.
     self redraw
!

scaleZ:p
     scaleZ := p rounded.
     self redraw
!

transX:delta
     transX := (delta) rounded.
     self redraw
!

transY:delta 
     transY := (delta) rounded.
     self redraw
!

transZ:delta 
     transZ := (delta - 150) rounded.
     self redraw
! !

!GLTeapotView methodsFor:'drawing'!

redraw 
    realized ifFalse:[^ self].
    points isNil ifTrue:[
	self color:Black.

	self clear.
	^ self
    ].

    drawMode == #point ifTrue:[self redrawAsPoints].
    drawMode == #line ifTrue:[self redrawAsLines].
    drawMode == #spline ifTrue:[self redrawAsSpline].
    drawMode == #solid ifTrue:[self redrawAsSolid].
    drawMode == #solidLighted ifTrue:[self redrawAsSolidLighted].

    self swapBuffers
!

redrawAsLines
    self zBuffer:false.

    self loadMatrix:IdentityMatrix.
    self perspectiveFovy:450 aspect:1.0 near:1.0 far:400.0. 

    type == #rgbDoubleBuffer ifTrue:[
	self colorRed:0 green:0 blue:0.
    ] ifFalse:[
	self color:Black
    ].
    self clear.

    self translateX:transX y:transY z:transZ.
    self rotateIX:rotX y:rotY z:rotZ.
    self scaleX:scaleX y:scaleY z:scaleZ.

    type == #rgbDoubleBuffer ifTrue:[
	self colorRed:255 green:255 blue:0.
    ] ifFalse:[
	self color:Yellow
    ].

    patches do:[:row |
	"vertical edges"
	self beginLine.
	self v3f:(points at:(row at:1)).
	self v3f:(points at:(row at:5)).
	self v3f:(points at:(row at:9)).
	self v3f:(points at:(row at:13)).
	self endLine.

	self beginLine.
	self v3f:(points at:(row at:1+1)).
	self v3f:(points at:(row at:5+1)).
	self v3f:(points at:(row at:9+1)).
	self v3f:(points at:(row at:13+1)).
	self endLine.

	self beginLine.
	self v3f:(points at:(row at:1+2)).
	self v3f:(points at:(row at:5+2)).
	self v3f:(points at:(row at:9+2)).
	self v3f:(points at:(row at:13+2)).
	self endLine.

	self beginLine.
	self v3f:(points at:(row at:1+3)).
	self v3f:(points at:(row at:5+3)).
	self v3f:(points at:(row at:9+3)).
	self v3f:(points at:(row at:13+3)).
	self endLine.

	"horizontal edges"
	self beginLine.
	self v3f:(points at:(row at:1)).
	self v3f:(points at:(row at:1+1)).
	self v3f:(points at:(row at:1+2)).
	self v3f:(points at:(row at:1+3)).
	self endLine.

	self beginLine.
	self v3f:(points at:(row at:5)).
	self v3f:(points at:(row at:5+1)).
	self v3f:(points at:(row at:5+2)).
	self v3f:(points at:(row at:5+3)).
	self endLine.

	self beginLine.
	self v3f:(points at:(row at:9)).
	self v3f:(points at:(row at:9+1)).
	self v3f:(points at:(row at:9+2)).
	self v3f:(points at:(row at:9+3)).
	self endLine.

	self beginLine.
	self v3f:(points at:(row at:13)).
	self v3f:(points at:(row at:13+1)).
	self v3f:(points at:(row at:13+2)).
	self v3f:(points at:(row at:13+3)).
	self endLine.
    ].
!

redrawAsPoints 
    self zBuffer:false.

    self loadMatrix:IdentityMatrix.
    self perspectiveFovy:450 aspect:1.0 near:1.0 far:400.0. 

    type == #rgbDoubleBuffer ifTrue:[
	self colorRed:0 green:0 blue:0.
    ] ifFalse:[
	self color:Black
    ].
    self clear.

    self translateX:transX y:transY z:transZ.
    self rotateIX:rotX y:rotY z:rotZ.
    self scaleX:scaleX y:scaleY z:scaleZ.

    type == #rgbDoubleBuffer ifTrue:[
       self colorRed:255 green:0 blue:0.
    ] ifFalse:[
	self color:Red
    ].
    self beginPoint.
    points do:[:p |
	self v3f:p.
    ].
    self endPoint.
!

redrawAsSolid
    self zBuffer:false.
    self loadMatrix:IdentityMatrix.
    self perspectiveFovy:450 aspect:1.0 near:1.0 far:400.0. 

    type == #rgbDoubleBuffer ifTrue:[
	self colorRed:0 green:0 blue:0.
    ] ifFalse:[
	self color:Black 
    ].
    self clear.

    self translateX:transX y:transY z:transZ.
    self rotateIX:rotX y:rotY z:rotZ.
    self scaleX:scaleX y:scaleY z:scaleZ.

    type == #rgbDoubleBuffer ifTrue:[
	self colorRed:255 green:0 blue:0.
    ] ifFalse:[
	self color:Red
    ].

    patches do:[:row |
	#(1 2 3 5 6 7 9 10 11) do:[:p |
	    self beginPolygon.
	    self v3f:(points at:(row at:p)).
	    self v3f:(points at:(row at:p+1)).
	    self v3f:(points at:(row at:p+5)).
	    self v3f:(points at:(row at:p+4)).
	    self endPolygon
	]
    ].
!

redrawAsSolidLighted 
    "not finished - please fix ...."

    |tX tY tZ bezier|

    type ~~ #rgbDoubleBuffer ifTrue:[
        ^ self
    ].

    self zBuffer:true.
    self mMode:#viewing.

    self loadMatrix:IdentityMatrix.

    self lmdef:#light      index:1 np:0 props:light.
    self lmdef:#material   index:1 np:0 props:material.
    self lmdef:#lightModel index:1 np:0 props:lightModel.

    self perspectiveFovy:450 aspect:1.0 near:0.0 far:400.0. 

    self zClear.      
    self colorRed:0 green:0 blue:0.
    self clear.

    self lmbind:#material   index:1.
    self lmbind:#light0     index:1.
    self lmbind:#lightModel index:1.

" "
    self lmdef:#light      index:1 np:0 props:lightPos.
" "
    self pushMatrix.

    self nMode:#normalize.
    self translateX:transX y:transY z:transZ.
    self scaleX:scaleX y:scaleY z:scaleZ.
    self rotateIX:rotX y:rotY z:rotY.

    self colorRed:255 green:0 blue:0.

    patches do:[:row |
        #(1 2 3 5 6 7 9 10 11) do:[:p |
            self beginPolygon.
self n3f:(FloatArray with:0.0 
                     with:(points at:(row at:p))y
                     with:(points at:(row at:p))z ).

            self v3f:(points at:(row at:p)).
self n3f:(FloatArray with:0.0 
                     with:(points at:(row at:p+1))y
                     with:(points at:(row at:p+1))z ).
            self v3f:(points at:(row at:p+1)).
self n3f:(FloatArray with:0.0 
                     with:(points at:(row at:p+5))y
                     with:(points at:(row at:p+5))z ).
            self v3f:(points at:(row at:p+5)).
self n3f:(FloatArray with:0.0 
                     with:(points at:(row at:p+4))y
                     with:(points at:(row at:p+4))z ).
            self v3f:(points at:(row at:p+4)).
            self endPolygon
        ]
      ].
    self popMatrix.
!

redrawAsSpline 
    |tX tY tZ bezier|

    self zBuffer:false.
    self loadMatrix:IdentityMatrix.
    self perspectiveFovy:450 aspect:1.0 near:0.0 far:400.0. 

    type == #rgbDoubleBuffer ifTrue:[
	self colorRed:0 green:0 blue:0.
    ] ifFalse:[
	self color:Black
    ].
    self clear.

    self translateX:transX y:transY z:transZ.
    self rotateIX:rotX y:rotY z:rotZ.
    self scaleX:scaleX y:scaleY z:scaleZ.

    type == #rgbDoubleBuffer ifTrue:[
	self colorRed:255 green:0 blue:0.
    ] ifFalse:[
	self color:Red
    ].

    tX := FloatArray new:16.
    tY := FloatArray new:16.
    tZ := FloatArray new:16.

    bezier := FloatArray withAll:#(
	-1.0  3.0    -3.0   1.0
	3.0   -6.0   3.0    0.0
	-3.0  3.0    0.0    0.0
	1.0   0.0    0.0    0.0 
    ).
    self patchCurvesU:4 v:4.
    self patchPrecisionU:6 v:6.
    self defBasis:1 mat:bezier.
    self patchBasisU:1 v:1.

    patches do:[:row |
	1 to:16 do:[:pI |
	    |p|

	    p := points at:(row at:pI).

	    tX at:pI put:p x.
	    tY at:pI put:p y.
	    tZ at:pI put:p z.
	].

	self patchX:tX y:tY z:tZ
      ].
! !

!GLTeapotView methodsFor:'initialization'!

initialize
    super initialize.

    "check if running on a real hardware"
    device supportsRGB ifTrue:[
        type := #rgbDoubleBuffer.
    ] ifFalse:[
        type := #colorIndexDoubleBuffer
    ].

    scaleX := 10.
    scaleY := 10.
    scaleZ := 10.

    rotX := 90 * 10.
    rotY := 180 * 10.
    rotZ := 0.

    transX := 0.
    transY := 0.
    transZ := -150.

    drawMode := #line.

    self setupLightAndMaterial.
    self readModel.

    "GLTeapotView new inspect"

    "Modified: 1.7.1997 / 18:15:13 / cg"
!

readModel
    |s string|

    s := Smalltalk systemFileStreamFor:'examples/3D/Pot.data'.
    s isNil ifTrue:[
	s := '../clients/IRIS-specials/Pot.data' asFilename readStream.
	s isNil ifTrue:[
	    self warn:'missing model data: ''examples/3D/Pot.data'''.
	    ^ self
	].
    ].
    string := s contents asString.
    s close.
    s := ReadStream on:string.
    points:= Array readFrom:s.
    patches := Array readFrom:s.
    s close.

    points keysAndValuesDo:[:idx :v |
	points at:idx put:(GLPoint3D x:(v at:1) y:(v at:2) z:(v at:3))
    ]
!

setupLightAndMaterial
    lightMatrix := IdentityMatrix copy.

    lightPos := FloatArray withAll:#( 102.0 "POSITION"     0.0 0.0 -1.0 0.0).

    light :=    FloatArray withAll:#(   2.0 "AMBIENT"      0.1 0.1 0.1
                                      101.0 "LCOLOR"       0.5 1.0 1.0
                                      102.0 "POSITION"     0.0 0.0 -1.0 "90.0 90.0 200.0" 0.0
                                        0.0 "END" ).


    lightModel :=    FloatArray withAll:#(   2.0 "AMBIENT"      1.0 1.0 1.0
                                      201.0 "LOCALVIEWER"  0.0
                                        0.0 "END" ).

    material := FloatArray withAll:#(   5.0 "SHININESS"    30.0
                                        4.0 "SPECULAR"     0.2 0.2 0.2
                                        0.0 "END" ).
! !

!GLTeapotView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLTeapotView.st,v 1.10 2016-01-21 18:05:35 cg Exp $'
! !

