"
 COPYRIGHT (c) 1992 by Claus Gittinger
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




"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#ShapeView1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!ShapeView1 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
 demonstrates how round views are created
 This works only, if your X-server supports the XShape
 extension - which is usually the case.

 However, the motif window manager does NOT support it
 (I dont know about the newest version though ..)

 [author:]
     Claus Gittinger (mar 94)

 [start with:]
     ShapeView1 new open
"
! !

!ShapeView1 class methodsFor:'defaults'!

defaultExtent
    ^ 200 @ 200
! !

!ShapeView1 methodsFor:'handling size changes'!

sizeChanged:how
    "must compute a new shape, when size is changed"

    self computeShape.
    super sizeChanged:how
! !

!ShapeView1 methodsFor:'initialization'!

initialize
    super initialize.
    self label:'a round view'.
    self viewBackground:Color white.
    self computeShape

    "ShapeView1 new open"
! !

!ShapeView1 methodsFor:'shape computation'!

computeShape
    "
     computes 2 forms, one for the border, the other
     for the inside area.
     The border form is borderwidth*2 pixels larger.
     Each form gets filled with an ellipse of 1-pixels,
     to define the shapes (take a look at the XShape spec,
     for more info)
    "

    |extent shapeForm borderForm bw|

    extent := self extent.
    borderForm := Form width:(extent x) height:(extent y).
    borderForm fill:(Color colorId:0).
    shapeForm := Form width:(extent x) height:(extent y).
    shapeForm fill:(Color colorId:0).

    borderForm foreground:(Color colorId:1).
    borderForm fillArcX:0 y:0 
                  width:(borderForm width)
                 height:(borderForm height)
                   from:0
                  angle:360.
    bw := 3.
    shapeForm foreground:(Color colorId:1).
    shapeForm fillArcX:bw y:bw 
                 width:(shapeForm width - (bw * 2))
                height:(shapeForm height - (bw * 2))
                  from:0
                 angle:360.
    self borderShape:borderForm.
    self viewShape:shapeForm
! !

!ShapeView1 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-border-round.st,v 1.7 1997-01-03 21:43:19 cg Exp $'
! !
