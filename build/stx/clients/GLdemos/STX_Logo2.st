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

GLXView subclass:#Logo3DView
	instanceVariableNames:'redrawBlock s m a l t k sl x angle'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

!Logo3DView class methodsFor:'documentation'!

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
    a rotating ST/X logo 

    [start with:]
        Logo3DView open

    [author:]
        Claus Gittinger
"





! !

!Logo3DView class methodsFor:'defaults'!

defaultExtent
    ^ 600@600

    "Logo3DView open"
! !

!Logo3DView methodsFor:'drawing'!

drawLetter:letter
    self beginClosedLine.
    letter do:[:p |
	self v3f:p.
    ].
    self endClosedLine.
!

drawModel

    self pushMatrix.

    self translateX:-5.5 y:0.0 z:0.0.

    self drawLetter:s.
    self translateX:1.6 y:0.0 z:0.0.
    self drawLetter:m.
    self translateX:1.1 y:0.0 z:0.0.
    self drawLetter:a.
    self translateX:1.1 y:0.0 z:0.0.
    self drawLetter:a.

    self translateX:1.1 y:0.0 z:0.0.
    self drawLetter:l.
    self translateX:0.7 y:0.0 z:0.0.
    self drawLetter:l.
    self translateX:0.4 y:0.0 z:0.0.
    self drawLetter:t.
    self translateX:0.8 y:0.0 z:0.0.
    self drawLetter:a.
    self translateX:1.1 y:0.0 z:0.0.
    self drawLetter:l.
    self translateX:0.8 y:0.0 z:0.0.
    self drawLetter:k.
    self translateX:0.9 y:0.0 z:0.0.
    self drawLetter:sl.
    self translateX:0.9 y:0.0 z:0.0.
    self drawLetter:x.

    self popMatrix.
!

drawXLetter:letter
    self beginPolygon.
    letter do:[:p |
	self v3f:p.
    ].
    self endPolygon.
!

redraw 
    self perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0. 
    self translateX:0.0 y:0.0 z:-5.0.
    self scaleX:0.35 y:1.0 z:1.0.
    self color:Black.
    self clear.

    self color:Red.

" "
    self rotateX:angle y:angle z:0.0.  angle := angle + 3.0.
" "
    self drawModel.

" 
    self translateX:0.0 y:0.0 z:0.1.
    self color:Green.
    self drawModel.

    self translateX:0.0 y:0.0 z:0.1.
    self color:Blue.
    self drawModel.
" 

    self swapBuffers.
" "
    Processor addTimedBlock:redrawBlock afterSeconds:0.1
" "
! !

!Logo3DView methodsFor:'initialization'!

initModel
    s := Array new:20.
    s at:1 put:(GLPoint3D x:0.1 y:  0).
    s at:2 put:(GLPoint3D x:0.7 y:  0).
    s at:3 put:(GLPoint3D x: 1 y:0.15).
    s at:4 put:(GLPoint3D x:1 y:0.39).
    s at:5 put:(GLPoint3D x:0.7 y:0.55).
    s at:6 put:(GLPoint3D x:0.4 y:0.55).
    s at:7 put:(GLPoint3D x:0.20 y:0.68).
    s at:8 put:(GLPoint3D x:0.20 y:0.82).
    s at:9 put:(GLPoint3D x:0.4 y:0.9).
    s at:10 put:(GLPoint3D x:0.9 y:0.9).
    s at:11 put:(GLPoint3D x:0.9 y:1.0).
    s at:12 put:(GLPoint3D x:0.25 y:1.0).
    s at:13 put:(GLPoint3D x:0 y:0.85).
    s at:14 put:(GLPoint3D x:0 y:0.65).
    s at:15 put:(GLPoint3D x:0.3 y:0.45).
    s at:16 put:(GLPoint3D x:0.6 y:0.45).
    s at:17 put:(GLPoint3D x:0.8 y:0.35).
    s at:18 put:(GLPoint3D x:0.8 y:0.2).
    s at:19 put:(GLPoint3D x:0.6 y:0.1).
    s at:20 put:(GLPoint3D x:0.1 y:0.1).

    l := Array new:6.
    l at:1 put:(GLPoint3D x:-0.5 y:  0).
    l at:2 put:(GLPoint3D x: 0.1 y:  0).
    l at:3 put:(GLPoint3D x: 0.1 y:0.15).
    l at:4 put:(GLPoint3D x:-0.3 y:0.15).
    l at:5 put:(GLPoint3D x:-0.3 y:1.0).
    l at:6 put:(GLPoint3D x:-0.5 y:1.0).

    t := Array new:8.
    t at:1 put:(GLPoint3D x: 0.1 y:  0).
    t at:2 put:(GLPoint3D x: 0.1 y:0.8).
    t at:3 put:(GLPoint3D x: 0.5 y:0.8).
    t at:4 put:(GLPoint3D x: 0.5 y:1.0).
    t at:5 put:(GLPoint3D x:-0.5 y:1.0).
    t at:6 put:(GLPoint3D x:-0.5 y:0.8).
    t at:7 put:(GLPoint3D x:-0.1 y:0.8).
    t at:8 put:(GLPoint3D x:-0.1 y:  0).

    a := Array new:10.
    a at:1  put:(GLPoint3D x:-0.127 y: (3/8)).
    a at:2  put:(GLPoint3D x: 0.12 y: (3/8)).
    a at:3  put:(GLPoint3D x: 0.3 y: 0).
    a at:4  put:(GLPoint3D x: 0.5 y: 0).
    a at:5  put:(GLPoint3D x:0 y: 1.0).
    a at:6  put:(GLPoint3D x:-0.5 y: 0).
    a at:7  put:(GLPoint3D x:-0.3 y: 0).
    a at:8  put:(GLPoint3D x:   0 y: 0.65).
    a at:9  put:(GLPoint3D x: 0.07 y: 0.5).
    a at:10 put:(GLPoint3D x: -0.068 y: 0.5).

    k := Array new:11.
    k at:1  put:(GLPoint3D x:-0.5 y: 0).
    k at:2  put:(GLPoint3D x:-0.3 y: 0).
    k at:3  put:(GLPoint3D x:-0.3 y: 0.3).
    k at:4  put:(GLPoint3D x: 0.3 y: 0).
    k at:5  put:(GLPoint3D x: 0.5 y: 0).
    k at:6  put:(GLPoint3D x:-0.2 y: 0.4).
    k at:7  put:(GLPoint3D x: 0.5 y: 1.0).
    k at:8  put:(GLPoint3D x: 0.3 y: 1.0).
    k at:9  put:(GLPoint3D x: -0.3 y: 0.5).
    k at:10 put:(GLPoint3D x: -0.3 y: 1.0).
    k at:11 put:(GLPoint3D x: -0.5 y: 1.0).

    m := Array new:12.
    m at:1  put:(GLPoint3D x:-0.5 y: 0).
    m at:2  put:(GLPoint3D x:-0.3 y: 0).
    m at:3  put:(GLPoint3D x:-0.3 y: 0.75).
    m at:4  put:(GLPoint3D x: 0.0 y: 0.4).
    m at:5  put:(GLPoint3D x: 0.3 y: 0.75).
    m at:6  put:(GLPoint3D x: 0.3 y: 0).
    m at:7  put:(GLPoint3D x: 0.5 y: 0).
    m at:8  put:(GLPoint3D x: 0.5 y: 1.0).
    m at:9  put:(GLPoint3D x: 0.3 y: 1.0).
    m at:10 put:(GLPoint3D x: 0.0 y: 0.6).
    m at:11 put:(GLPoint3D x: -0.3 y: 1.0).
    m at:12 put:(GLPoint3D x: -0.5 y: 1.0).

    "/"
    sl := Array new:4.
    sl at:1 put:(GLPoint3D x:-0.4 y:-0.2).
    sl at:2 put:(GLPoint3D x:-0.2 y:-0.2).
    sl at:3 put:(GLPoint3D x: 0.4 y:1.2).
    sl at:4 put:(GLPoint3D x: 0.2 y:1.2).

    x := Array new:12.
    x at:1 put:(GLPoint3D x:-0.5 y:0).
    x at:2 put:(GLPoint3D x:-0.3 y:0).
    x at:3 put:(GLPoint3D x: 0 y:0.4).
    x at:4 put:(GLPoint3D x: 0.3 y:0).
    x at:5 put:(GLPoint3D x: 0.5 y:0).
    x at:6 put:(GLPoint3D x: 0.14 y:0.5).
    x at:7 put:(GLPoint3D x: 0.5 y:1).
    x at:8 put:(GLPoint3D x: 0.3 y:1).
    x at:9 put:(GLPoint3D x: 0 y:0.6).
    x at:10 put:(GLPoint3D x: -0.3 y:1).
    x at:11 put:(GLPoint3D x: -0.5 y:1).
    x at:12 put:(GLPoint3D x: -0.14 y:0.5).
!

initialize
    super initialize.
    type := #colorIndexDoubleBuffer.
    redrawBlock := [self redraw].
    self initModel.
    angle := 0.0.
    self initModel.
!

realize
    super realize.
    Processor addTimedBlock:redrawBlock afterSeconds:0.1
!

unrealize 
    Processor removeTimedBlock:redrawBlock.
    super unrealize.
! !

!Logo3DView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/STX_Logo2.st,v 1.8 2016-01-21 18:06:02 cg Exp $'
! !

