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



"{ NameSpace: Demos }"

Object subclass:#FractalPatternsDemo
	instanceVariableNames:'drawView'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!FractalPatternsDemo class methodsFor:'documentation'!

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
 draws fractal patterns

 The algorithms & parameters are described (among elsewhere)
 in:
    Algortihms for fractals & chaos
    by Dietmar Herrmann
    Addison Wesley ISBN 3-89319-633-1

 [see also:]
     FractalPlantsDemo

 [start with:]
     FractalPatternsDemo open
     FractalPatternsDemo recompileForSpeed; open

 [author:]
     Claus Gittinger
"


! !

!FractalPatternsDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:35:49 / cg"
!

open
    "open a new pattern demo view"

    ^ self new open
! !

!FractalPatternsDemo class methodsFor:'tuning'!

recompileForSpeed
     "for best performance, compile the method:
        #snailWithAlpha:c:numberOfIterations:sx:sy:ox:oy:
      to machine code (if your systems supports this)."

    self recompileForSpeed:#snailWithAlpha:c:numberOfIterations:sx:sy:ox:oy:
! !

!FractalPatternsDemo methodsFor:'drawing'!

snail:fraction
    "draw a snail pattern"

    drawView clear; paint:Color black.
    Processor activeProcess withPriority:4 do:[
        drawView topView withWaitCursorDo:[
            self snailWithAlpha:(Float pi / fraction) c:0.9
                 numberOfIterations:50000 sx:150 sy:150 ox:30 oy:250
        ]
    ]
!

snailWithAlpha:alpha c:c numberOfIterations:numPoints sx:sx sy:sy ox:ox oy:oy
    "{ Pragma: +optmath }"

    "generate the picture - the actual snail work horse"

    "with type hints and stc-compilation,
     this is about 2.5 times faster compared to just-in-time compiled"

    |x   "{ Class: Float }"
     y   "{ Class: Float }"
     a   "{ Class: Float }"
     b   "{ Class: Float }" 
     a2  "{ Class: Float }"
     b2  "{ Class: Float }" 
     fsx "{ Class: Float }"
     fsy "{ Class: Float }" 
     fox "{ Class: Float }"
     foy "{ Class: Float }" 
     rand 
     x1  "{ Class: Float }"
     u   "{ Class: Float }"
     n   "{ Class: SmallInteger }"|

    x := 2.0.
    y := 0.0.
    fsx := sx asFloat.
    fsy := sy asFloat.
    fox := ox asFloat.
    foy := oy asFloat. 

    a := c * alpha cos.
    b := c * alpha sin.
    a2 := 2 - (2 * a).
    b2 := 2 * b.
    rand := Random new.

    n := numPoints.
    n timesRepeat:[
        rand next < 0.8 ifTrue:[
            x1 := x.
            x := (a * x) - (b * y) + a2.
            y := (b * x1) + (a * y) - b2.
        ] ifFalse:[
            u := (x * x) + (y * y).
            x := x / u.
            y := y / u
        ].
        drawView displayPointX:x*fsx+fox y:y*fsy+foy.
    ].
! !

!FractalPatternsDemo methodsFor:'startup'!

open 
    "create a topView, some buttons and open it"

    |topView panel speedToggle nibToggle |

    topView := StandardSystemView
                    label:'Fractal patterns'
                    icon:(Image fromFile:'bitmaps/FractalPattern.xbm').

    topView extent:(600 @ 450).
    topView minExtent:(600 @ 450).

    panel := PanelView origin:(0 @ 0) extent:(1.0 @ 1.0) in:topView.

    drawView := panel.

    Button label:'0.6' action:[self snail:0.6] in:panel.
    Button label:'0.7' action:[self snail:0.7] in:panel.
    Button label:'0.8' action:[self snail:0.8] in:panel.
    Button label:'0.9' action:[self snail:0.9] in:panel.
    Button label:'1.1' action:[self snail:1.1] in:panel.
    Button label:'1.2' action:[self snail:1.2] in:panel.
    Button label:'1.5' action:[self snail:1.5] in:panel.
    Button label:'1.75' action:[self snail:1.75] in:panel.
    Button label:'2' action:[self snail:2] in:panel.
    Button label:'3' action:[self snail:3] in:panel.
    Button label:'4' action:[self snail:4] in:panel.
    Button label:'5' action:[self snail:5] in:panel.
    Button label:'6' action:[self snail:6] in:panel.
    Button label:'8' action:[self snail:8] in:panel.
    Button label:'20' action:[self snail:20] in:panel.
    Button label:'50' action:[self snail:50] in:panel.
    Button label:'quit'  action:[topView destroy]  in:panel.

    topView open

    "
     FractalPatternsDemo new open
    "
! !

!FractalPatternsDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/FractalPatternsDemo.st,v 1.11 1998-07-09 08:08:53 cg Exp $'
! !
