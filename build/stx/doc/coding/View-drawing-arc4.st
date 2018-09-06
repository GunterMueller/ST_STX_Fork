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





"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#DrawArcDemo4
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Drawing'
!

!DrawArcDemo4 class methodsFor:'documentation'!

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
 more on arc drawing

 [start with:]
    DrawArcDemo4 start

 [author:]
    Claus Gittinger feb 94
"


! !

!DrawArcDemo4 class methodsFor:'startup'!

start
    |aDemo|


    aDemo := self
                label:'DrawArcDemo4'
                icon:(Image fromFile:'Demo.xbm' resolution:100)
                minExtent:(50 @ 50)
                maxExtent:(1000 @ 1000).
    aDemo extent:(300 @ 300).
    aDemo open.
    ^ aDemo

    "
     DrawArcDemo4 start
    "
! !

!DrawArcDemo4 methodsFor:'redrawing'!

redraw
    |nSegment angle1 angle2 startAngle w h x y colors|

    nSegment := 5.
    angle1 := 360 / (nSegment + 1).
    angle2 := 360 / nSegment.

    colors := #('red' 'green' 'blue' 'magenta' 'cyan' 'yellow' 'black' 'white' 'brown' 'orange')
              collect:[:name | Color nameOrDither:name].

    x := 0.
    y := 0.
    w := width.
    h := height.

    1 to:10 do:[:ring |
        startAngle := 0.
        self lineWidth:(10 - ring).
        self paint:(colors at:ring).

        1 to:nSegment do:[:segment |
            self displayArcX:x y:y 
                       width:w-1 height:h-1
                        from:startAngle angle:angle1.
            startAngle := startAngle + angle2.
        ].
        x := x + (width // 10 // 2).
        y := y + (height // 10 // 2).
        w := w - (width // 10).
        h := h - (height // 10).
    ]
! !

!DrawArcDemo4 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-drawing-arc4.st,v 1.9 1997-01-03 20:28:57 cg Exp $'
! !
