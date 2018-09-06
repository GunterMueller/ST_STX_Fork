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

View subclass:#FormDrawView
	instanceVariableNames:'canvas'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

FormDrawView comment:'
I implement a view which does drawing onto both the screen
and a backing canvas. From this canvas we redraw (there is also
a possibility to add printing etc)
'
!

!FormDrawView class methodsFor:'documentation'!

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
 a view which remembers line drawings in a bitmap
 for redraw & scrolling.

 [author:]
        Claus Gittinger


 [see also:]
        ColorDrawDemo3
"

! !

!FormDrawView methodsFor:'accessing'!

canvas
    "return the value of the instance variable 'canvas' (automatically generated)"

    ^ canvas

    "Created: / 9.1.1998 / 23:39:43 / stefan"
!

canvas:something
    "set the value of the instance variable 'canvas' (automatically generated)"

    canvas := something.

    "Created: / 9.1.1998 / 23:47:21 / stefan"
! !

!FormDrawView methodsFor:'drawing'!

clear
    "clear myself AND the backing canvas"

    canvas paint:(Color white).
    canvas fillRectangleX:0 y:0 width:(canvas width)
                               height:(canvas height).
    super clear

    "Modified: 8.5.1996 / 22:23:42 / cg"
!

displayForm:aForm
    "draw in myself AND in the backing canvas"

    canvas displayForm:aForm.
    super displayForm:aForm
!

displayLineFromX:x1 y:y1 toX:x2 y:y2
    "draw aline in myself AND in the backing canvas"

    canvas displayLineFromX:x1 y:y1 toX:x2 y:y2.
    super displayLineFromX:x1 y:y1 toX:x2 y:y2

    "Modified: 1.4.1997 / 21:19:02 / cg"
!

displayLineFromX:x1 y:y1 toX:x2 y:y2 brush:aBrush
    "draw a line in myself AND in the backing canvas"

    canvas displayLineFromX:x1 y:y1 toX:x2 y:y2 brush:aBrush.
    super displayLineFromX:x1 y:y1 toX:x2 y:y2 brush:aBrush

    "Modified: 1.4.1997 / 21:19:13 / cg"
!

displayPointX:x y:y
    "draw a point in myself AND in the backing canvas"

    canvas displayPointX:x y:y.
    super displayPointX:x y:y

    "Modified: 3.4.1997 / 00:33:51 / cg"
!

fill:aColor
    "clear myself AND the backing canvas"

    canvas paint:aColor.
    canvas fillRectangleX:0 y:0 width:(canvas width)
                               height:(canvas height).
    super fill:aColor

    "Modified: 8.5.1996 / 22:23:42 / cg"
! !

!FormDrawView methodsFor:'events'!

redrawX:x y:y width:w height:h
    "redraw mySelf from the canvas"

    |org|

    org := self viewOrigin.
    self function:#copy.
    self copyFrom:canvas 
                x:x
                y:y
              toX:x-org x y:y-org y 
            width:(w min:(canvas width - x))
           height:(h min:(canvas height - y)).

    "Modified: 8.5.1996 / 22:24:03 / cg"
! !

!FormDrawView methodsFor:'graphic access'!

capStyle:aStyle
    "set the capStyle in myself AND in the backing canvas"

    canvas capStyle:aStyle.
    super capStyle:aStyle

    "Modified: 8.5.1996 / 22:24:14 / cg"
!

lineWidth:aNumber
    "set the lineWidth in myself AND in the backing canvas"

    canvas lineWidth:aNumber.
    super lineWidth:aNumber

    "Modified: 8.5.1996 / 22:24:22 / cg"
!

paint:aColor
    "set the paint in myself AND in the backing canvas"

    canvas paint:aColor.
    super paint:aColor

    "Modified: 8.5.1996 / 22:24:28 / cg"
! !

!FormDrawView methodsFor:'initialization'!

initialize
    "create the canvas in addition to normal initialization"

    super initialize.

    canvas := Form width:1024
                  height:768
                   depth:(Display depth).
    canvas paint:(Color white).
    canvas fillRectangleX:0 y:0 width:(canvas width) height:(canvas height)

    "Modified: / 8.5.1996 / 22:25:09 / cg"
    "Modified: / 9.1.1998 / 23:23:51 / stefan"
! !

!FormDrawView methodsFor:'queries'!

heightOfContents
    "return the height of the canvas for scrolling"

    ^ canvas height

    "Modified: 8.5.1996 / 22:24:50 / cg"
!

widthOfContents
    "return the width of the canvas for scrolling"

    ^ canvas width

    "Modified: 8.5.1996 / 22:24:46 / cg"
! !

!FormDrawView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/FormDrawView.st,v 1.12 2008-12-17 22:37:44 cg Exp $'
! !
