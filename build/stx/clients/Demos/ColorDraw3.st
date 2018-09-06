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

"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

ColorDrawDemo2 subclass:#ColorDrawDemo3
	instanceVariableNames:'savedCanvas undoButton'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

ColorDrawDemo3 comment:'
This class adds backing to the Draw-demos - every draw is
done both on the screen and in a canvas - so redraw works ...
To do this, we need a view which does this (FormDrawView).
(you have to fileIn FormDrawView.st)

 start with:
       ColorDrawDemo3 open

'
!

!ColorDrawDemo3 class methodsFor:'documentation'!

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
 This demo adds scrolling & redraw capabilities ...
 ... my doughter loves it ;-)

 [author:]
        Claus Gittinger

 [start with:]
        ColorDrawDemo3 open

 [see also:]
        FormDrawView
        ColorDrawDemo ColorDrawDemo2
        DrawTool
"
! !

!ColorDrawDemo3 methodsFor:'saving'!

saveDialog
    "open a dialog to save the drawing"

    |fileName|

    fileName := Dialog
                    requestFileName:'save to:'
                    default:''
                    ok:'save' 
                    abort:'cancel' 
                    pattern:'*.gif'.

   fileName notNil ifTrue:[
       GIFReader new save:drawView canvas asImage onFile:fileName.
   ].

    "Created: / 9.1.1998 / 23:39:02 / stefan"
    "Modified: / 9.1.1998 / 23:40:55 / stefan"
! !

!ColorDrawDemo3 methodsFor:'startup'!

setupViews
    "setup the drawing area as a FormDrawView"

    |v|

    super setupViews.

    drawView destroy.

    v := HVScrollableView for:FormDrawView in:topView.
    v origin:(0.2 @ 0.0)
      corner:(1.0 @ 1.0).

    drawView := v scrolledView.
    drawView viewBackground:(Color white).
    drawView delegate:self.
    drawView capStyle:#round.

    undoButton := Button label:'undo' 
        action:[self restoreCanvas]
            in:buttonPanel2.

    Button label:'save...' 
        action:[self saveDialog]
            in:buttonPanel2.

    "ColorDrawDemo3 open"

    "Modified: / 10.4.1997 / 15:49:02 / cg"
    "Modified: / 9.1.1998 / 23:28:11 / stefan"
! !

!ColorDrawDemo3 methodsFor:'user actions'!

buttonPress:button x:x y:y view:aView
    self saveCanvas.
    super buttonPress:button x:x y:y view:aView
!

restoreCanvas
    |canvas|

    canvas := drawView canvas.
    canvas copyFrom:savedCanvas x:0 y:0 toX:0 y:0 width:canvas width height:canvas height.
    drawView copyFrom:savedCanvas x:0 y:0 toX:0 y:0 width:canvas width height:canvas height.
    undoButton disable.
!

saveCanvas
    |canvas|

    canvas := drawView canvas.
    (savedCanvas isNil or:[savedCanvas extent ~= canvas extent]) ifTrue:[
        savedCanvas notNil ifTrue:[ savedCanvas destroy ].
        savedCanvas := Form width:canvas width height:canvas height depth:canvas depth onDevice:canvas device.
    ].
    savedCanvas copyFrom:canvas x:0 y:0 toX:0 y:0 width:canvas width height:canvas height.
    undoButton enable.
! !

!ColorDrawDemo3 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ColorDraw3.st,v 1.12 2001-07-20 16:22:31 cg Exp $'
! !
