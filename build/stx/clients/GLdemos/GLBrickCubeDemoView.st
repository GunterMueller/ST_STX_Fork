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

GLCubeDemoView2 subclass:#GLBrickCubeDemoView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLBrickCubeDemoView comment:'
a solid cube with a texture.

start with:
    GLBrickCubeDemoView open
'
!

!GLBrickCubeDemoView class methodsFor:'documentation'!

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


! !

!GLBrickCubeDemoView class methodsFor:'defaults'!

defaultLabel
    ^ 'GL textured cube'
! !

!GLBrickCubeDemoView class methodsFor:'startup'!

open 
    "check if display has rgb features"

    Screen current supportsGLDrawing ifFalse:[
        ^ self warn:'sorry, but this view requires a display capable of GL drawing'
    ].
    Screen current supportsTextures ifFalse:[
        ^ self warn:'sorry, but this demo requires a GL with texture support'
    ].
    ^ super open

    "Modified: / 6.9.1998 / 16:03:38 / cg"
! !

!GLBrickCubeDemoView methodsFor:'drawing'!

drawObject
    self lmbind:#material index:1.

    self backFace:true.

    "front side"
    self beginPolygon.  
    self n3f:(normals at:1).
    self t2f:(FloatArray withAll:#(0.0 0.0)).
    self v3f:(points at:1).
    self t2f:(FloatArray withAll:#(16.0 0.0)).
    self v3f:(points at:2).
    self t2f:(FloatArray withAll:#(16.0 32.0)).
    self v3f:(points at:3).
    self t2f:(FloatArray withAll:#(0.0 32.0)).
    self v3f:(points at:4).
    self endPolygon. 

    "back side"
    self beginPolygon. 
    self n3f:(normals at:6).
    self t2f:(FloatArray withAll:#(0.0 0.0)).
    self v3f:(points at:6).
    self t2f:(FloatArray withAll:#(16.0 0.0)).
    self v3f:(points at:5).
    self t2f:(FloatArray withAll:#(16.0 32.0)).
    self v3f:(points at:8).
    self t2f:(FloatArray withAll:#(0.0 32.0)).
    self v3f:(points at:7).
    self endPolygon. 

    "right side"
    self beginPolygon. 
    self n3f:(normals at:2).
    self t2f:(FloatArray withAll:#(0.0 0.0)).
    self v3f:(points at:2).
    self t2f:(FloatArray withAll:#(16.0 0.0)).
    self v3f:(points at:6).
    self t2f:(FloatArray withAll:#(16.0 32.0)).
    self v3f:(points at:7).
    self t2f:(FloatArray withAll:#(0.0 32.0)).
    self v3f:(points at:3).
    self endPolygon. 

    "left side"
    self beginPolygon. 
    self n3f:(normals at:3).
    self t2f:(FloatArray withAll:#(0.0 0.0)).
    self v3f:(points at:1).
    self t2f:(FloatArray withAll:#(16.0 0.0)).
    self v3f:(points at:4).
    self t2f:(FloatArray withAll:#(16.0 32.0)).
    self v3f:(points at:8).
    self t2f:(FloatArray withAll:#(0.0 32.0)).
    self v3f:(points at:5).
    self endPolygon. 

    "top side"
    self beginPolygon. 
    self n3f:(normals at:5).
    self t2f:(FloatArray withAll:#(0.0 0.0)).
    self v3f:(points at:3).
    self t2f:(FloatArray withAll:#(16.0 0.0)).
    self v3f:(points at:7).
    self t2f:(FloatArray withAll:#(16.0 32.0)).
    self v3f:(points at:8).
    self t2f:(FloatArray withAll:#(0.0 32.0)).
    self v3f:(points at:4).
    self endPolygon. 

    "bottom side"
    self beginPolygon. 
    self n3f:(normals at:4).
    self t2f:(FloatArray withAll:#(0.0 0.0)).
    self v3f:(points at:1).
    self t2f:(FloatArray withAll:#(16.0 0.0)).
    self v3f:(points at:5).
    self t2f:(FloatArray withAll:#(16.0 32.0)).
    self v3f:(points at:6).
    self t2f:(FloatArray withAll:#(0.0 32.0)).
    self v3f:(points at:2).
    self endPolygon. 

!

redraw
    realized ifFalse:[^ self].

    "
     do not draw, if iconified
    "
    shown ifTrue:[
	self perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0.
	self mMode:#viewing.

	self lmbind:#material   index:1.
	self lmbind:#light0     index:1.
	self lmbind:#lightModel index:1.

	self colorRed:0 green:0 blue:0.
	self clear.

	"rotate the light"

"
	self pushMatrix.
	self loadMatrix:IdentityMatrix.
	self rotateI:1 axis:#x.
	self rotateI:2 axis:#y.
	self multMatrix:rotLightMatrix.
	self lmdef:#light index:1 np:0 props:lightPos.
	self getMatrix:rotLightMatrix.
	self popMatrix.
 "

	"
	 rotate & draw the object
	"
	self pushMatrix.
	self translateZ:trans.
	self rotateX:angleX y:angleY z:angleZ.
	self callObject:objectId.
	self popMatrix.

	self swapBuffers.
    ].

    "
     on systems without processes, install a timed-block
     for the next frame.
    "
    redrawBlock notNil ifTrue:[
	Processor addTimedBlock:redrawBlock afterSeconds:deltaT
    ]


! !

!GLBrickCubeDemoView methodsFor:'initialization'!

defineLightAndMaterial 
    |textureBits textureProps texenvProps|

    super defineLightAndMaterial.

    textureBits := #[16r00 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
		     16r00 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
		     16r00 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF 16rFF
		     16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00
		     16rFF 16rFF 16rFF 16rFF 16r00 16rFF 16rFF 16rFF
		     16rFF 16rFF 16rFF 16rFF 16r00 16rFF 16rFF 16rFF
		     16rFF 16rFF 16rFF 16rFF 16r00 16rFF 16rFF 16rFF
		     16r00 16r00 16r00 16r00 16r00 16r00 16r00 16r00].

    textureProps := FloatArray withAll:
		    #(16r100.0     "TX_MINFILTER"
		      16r110.0     "TX_POINT"
		      16r200.0     "TX_MAGFILTER"
		      16r110.0     "TX_POINT"
		      16r300.0     "TX_WRAP"
		      16r301.0     "TX_REPEAT"
			0.0     "TX_NULL"
		     ).

    texenvProps := FloatArray withAll:
		    #(16r200.0     "TV_COLOR"
			  0.75 0.13 0.06 1.0
		      16r102.0     "TV_BLEND"
		      0.0       "TV_NULL").

    self texdef2d:1 
	       nc:1
	    width:8
	   height:8
	     bits:textureBits
	       np:0 
	    props:textureProps.
    self tevdef:1 np:0 props:texenvProps.
    self texbind:#texture0 index:1.
    self tevbind:#env0 index:1.




! !

!GLBrickCubeDemoView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLBrickCubeDemoView.st,v 1.7 2016-01-21 18:05:03 cg Exp $'
! !

