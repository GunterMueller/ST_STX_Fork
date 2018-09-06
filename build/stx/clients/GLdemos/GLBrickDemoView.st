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

GLObjectDemoView subclass:#GLBrickDemoView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

!GLBrickDemoView class methodsFor:'documentation'!

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
    this is an adaption of an SGI example (in chapter18 of the manual).
    Draws a plane with brick-pattern as texture.

	GLBrickDemoView open
"
! !

!GLBrickDemoView class methodsFor:'defaults'!

defaultLabel
    ^ 'GL textured plane'
! !

!GLBrickDemoView class methodsFor:'start'!

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
     GLBrickDemoView open
    "

    "Modified: / 6.9.1998 / 16:06:09 / cg"


! !

!GLBrickDemoView methodsFor:'drawing'!

drawFrame
    self colorRed:16rCC green:16rCC blue:16rCC alpha:16rFF.

    self beginPolygon.

    self t2f:(FloatArray withAll:#(0.0 0.0)).
    self v3f:(FloatArray withAll:#(-2.0 -4.0 0.0)).

    self t2f:(FloatArray withAll:#(16.0 0.0)).
    self v3f:(FloatArray withAll:#( 2.0 -4.0 0.0)).

    self t2f:(FloatArray withAll:#(16.0 32.0)).
    self v3f:(FloatArray withAll:#( 2.0  4.0 0.0)).

    self t2f:(FloatArray withAll:#(0.0 32.0)).
    self v3f:(FloatArray withAll:#(-2.0  4.0 0.0)).

    self endPolygon.

! !

!GLBrickDemoView methodsFor:'initialization'!

drawObject 
    ^ self
!

initialize
    super initialize.
    type := #rgbDoubleBuffer.

!

mapped 
    |textureBits textureProps texenvProps|

    super mapped .

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


!

setupPoints
    ^ self
!

setupViewing
    self perspectiveFovy:600 aspect:1.0 near:1.0 far:100.0.


! !

!GLBrickDemoView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLBrickDemoView.st,v 1.8 2016-01-21 18:05:09 cg Exp $'
! !

