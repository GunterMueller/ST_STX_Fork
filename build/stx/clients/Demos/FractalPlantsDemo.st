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

Object subclass:#FractalPlantsDemo
	instanceVariableNames:'drawView'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!FractalPlantsDemo class methodsFor:'documentation'!

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
 draws fractal plants.
 The algorithms & parameters are described (among elsewhere)
 in:
    Algortihms for fractals & chaos
    by Dietmar Herrmann
    Addison Wesley ISBN 3-89319-633-1

 and:
    Fractals Everywhere
    by Michael Barnsley
    Academic Press, San Diego, p.91

 [see also:]
     FractalPatternsDemo

 [start with:]
     FractalPlantsDemo open
     FractalPlantsDemo recompileForSpeed; open

 [author:]
     Claus Gittinger
"


! !

!FractalPlantsDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:35:11 / cg"
!

open
    ^ self new open
! !

!FractalPlantsDemo class methodsFor:'tuning'!

recompileForSpeed
     "for best performance, compile the working methods
      to machine code (if your systems supports this)."

    self recompileForSpeed:#paintPlant2:iterations:offsetX:y:scaleX:y:.
    self recompileForSpeed:#paintPlant:iterations:offsetX:y:scaleX:y:.


! !

!FractalPlantsDemo methodsFor:'drawing'!

fern1
    "draw a Barnsley-fern"

    |projections|

    projections := Array new:4.

    "/
    "/ ( x' )    ( a  b )   ( x )   ( e )
    "/ (    ) =  (      ) x (   ) + (   )
    "/ ( y' )    ( c  d )   ( y )   ( f )
    "/
    "/                       a      b      c      d      e     f    p
    projections at:1 put:#( 0.0    0.0    0.0    0.16   0.0   0.0   0.03).
    projections at:2 put:#( 0.197 -0.226  0.226  0.197  0.0   1.6   0.14).
    projections at:3 put:#(-0.155  0.283  0.26   0.237  0.0   0.44  0.27).
    projections at:4 put:#( 0.849  0.037 -0.037  0.849  0.0   1.6   1.0).

    Processor activeProcess withPriority:4 do:[
        drawView clear.
"/        drawView paint:Color green darkened.
        drawView topView withWaitCursorDo:[
            self paintPlant:projections iterations:50000 offsetX:300 y:420 scaleX:50 y:40
        ]
    ]

    "Modified: 16.8.1996 / 12:18:38 / cg"
!

fern2
    |projections|

    projections := Array new:4.

    "/
    "/ ( x' )    ( a  b )   ( x )   ( e )
    "/ (    ) =  (      ) x (   ) + (   )
    "/ ( y' )    ( c  d )   ( y )   ( f )
    "/
    "/                       a      b      c      d      e     f    p
    projections at:1 put:#( 0.0    0.0    0.0    0.2    0.0   0.0   0.03).
    projections at:2 put:#( 0.2   -0.3    0.23  -0.05   0.0   0.5   0.14).
    projections at:3 put:#(-0.05   0.23  -0.3   -0.2    0.0   0.5   0.27).
    projections at:4 put:#( 0.85   0.0    0.0    0.85   0.0   0.7   1.0).

    Processor activeProcess withPriority:4 do:[
        drawView clear.
"/        drawView paint:Color green darkened.
        drawView topView withWaitCursorDo:[
            self paintPlant:projections iterations:30000 offsetX:300 y:400 scaleX:100 y:80
        ]
    ]
!

fern3
    |projections|

    projections := Array new:4.

    "/
    "/ ( x' )    ( a  b )   ( x )   ( e )
    "/ (    ) =  (      ) x (   ) + (   )
    "/ ( y' )    ( c  d )   ( y )   ( f )
    "/
    "/                       a      b      c      d      e     f    p
    projections at:1 put:#( 0.0    0.0    0.0    0.16   0.0   0.0   0.03).
    projections at:2 put:#( 0.2   -0.26   0.0    0.22   0.0   1.6   0.14).
    projections at:3 put:#( 0.15   0.28   0.0    0.24   0.0   0.44  0.27).
    projections at:4 put:#( 0.85   0.04   0.0    0.85   0.0   1.6   1.0).

    Processor activeProcess withPriority:4 do:[
        drawView clear.
"/        drawView paint:Color green darkened.
        drawView topView withWaitCursorDo:[
            self paintPlant:projections iterations:30000 offsetX:300 y:420 scaleX:50 y:40
        ]
    ]
!

oakTree
    |projections|

    projections := Array new:5.

    "/
    "/ ( x' )    ( a  b )   ( x )   ( e )
    "/ (    ) =  (      ) x (   ) + (   )
    "/ ( y' )    ( c  d )   ( y )   ( f )
    "/
    "/                       a      b      c      d      e      f        p
    projections at:1 put:#( 0.195 -0.488  0.344  0.433  0.4431 0.2452   0.03).
    projections at:2 put:#( 0.462  0.414 -0.252  0.361  0.2511 0.5692   0.14).
    projections at:3 put:#(-0.058 -0.07   0.453 -0.111  0.5976 0.0969   0.27).
    projections at:4 put:#(-0.035  0.07  -0.469 -0.022  0.4884 0.5069   0.5).
    projections at:5 put:#(-0.637  0.0    0.0    0.501  0.8562 0.2513   1.0).

    Processor activeProcess withPriority:4 do:[
	drawView clear.
"/        drawView paint:Color green darkened.
	drawView topView withWaitCursorDo:[
	    self paintPlant:projections iterations:80000 offsetX:100 y:450 scaleX:400 y:500 
	]
    ]
!

paintPlant2:projections iterations:numPoints offsetX:ox y:oy scaleX:_sx y:_sy
    |x y rand 
     nProjections "{ Class: SmallInteger }"
     n            "{ Class: SmallInteger }" 
     index        "{ Class: SmallInteger }"
     sx           "{ Class: Float }"
     sy           "{ Class: Float }"|

    sx := _sx asFloat.
    sy := _sy asFloat.

    rand := Random new.
    x := y := 0.0.
    nProjections := projections size.

    projections do:[:p |
        |clrSpec|

        clrSpec := (p at:8).
        p at:8 put:(Color red:(clrSpec at:1)
                          green:(clrSpec at:2)
                          blue:(clrSpec at:3))
    ].

    n := numPoints.
    n timesRepeat:[
        |projectionArray p
         a "{ Class: Float }"
         b "{ Class: Float }"
         c "{ Class: Float }"
         d "{ Class: Float }"
         e "{ Class: Float }"
         f "{ Class: Float }"
         xn "{ Class: Float }"
         yn "{ Class: Float }"|

        "/ 'randomly' choose a projection 

        p := rand next.
        index := 1.

        [(index <= nProjections) 
        and:[p > ((projectionArray := projections at:index) at:7)]]
            whileTrue:[index := index + 1].

        "/ apply it

        a := (projectionArray at:1) asFloat.
        b := (projectionArray at:2) asFloat.
        c := (projectionArray at:3) asFloat.
        d := (projectionArray at:4) asFloat.
        e := (projectionArray at:5) asFloat.
        f := (projectionArray at:6) asFloat.

        xn := (a * x) + (b * y) + e.
        yn := (c * x) + (d * y) + f.
        drawView foreground:(projectionArray at:8).
        drawView displayPointX:xn*sx+ox y:oy-(yn*sy).
        x := xn.
        y := yn
    ].

    "Modified: 16.8.1996 / 12:38:47 / cg"
!

paintPlant:projections iterations:numPoints offsetX:ox y:oy scaleX:sx y:sy
    "{ Pragma: +optmath }"

    |x            "{ Class: Float }"
     y            "{ Class: Float }"
     rand 
     nProjections "{ Class: SmallInteger }"|

    drawView paint:Color black.

    rand := Random new.
    x := y := 0.0.
    nProjections := projections size.

    numPoints timesRepeat:[
        |projection p
         index "{ Class: SmallInteger }"
         a "{ Class: Float }"
         b "{ Class: Float }"
         c "{ Class: Float }"
         d "{ Class: Float }"
         e "{ Class: Float }"
         f "{ Class: Float }"
         xn "{ Class: Float }"
         yn "{ Class: Float }"|

        "/ 'randomly' choose a projection 

        p := rand next.
        index := 1.

        [(index <= nProjections) 
        and:[p > ((projection := projections at:index) at:7)]]
            whileTrue:[index := index + 1].

        "/ apply it

        a := projection at:1.
        b := projection at:2.
        c := projection at:3.
        d := projection at:4.
        e := projection at:5.
        f := projection at:6.

        xn := (a * x) + (b * y) + e.
        yn := (c * x) + (d * y) + f.
        drawView displayPointX:xn*sx+ox y:oy-(yn*sy).
        x := xn.
        y := yn
    ].

    "Modified: 16.8.1996 / 12:41:45 / cg"
!

tree1
    |projections|

    projections := Array new:4.

    "/
    "/ ( x' )    ( a  b )   ( x )   ( e )
    "/ (    ) =  (      ) x (   ) + (   )
    "/ ( y' )    ( c  d )   ( y )   ( f )
    "/
    "/                       a      b      c      d      e     f    p
    projections at:1 put:#( 0.75   0.0    0.0    0.6    0.0   0.25  0.2).
    projections at:2 put:#( 0.33   0.3   -0.3    0.3    0.0   0.2   0.3).
    projections at:3 put:#( 0.33  -0.2    0.5    0.2    0.0   0.2   0.8).
    projections at:4 put:#( 0.0    0.0    0.0    0.3    0.0   0.0   1.0).

    Processor activeProcess withPriority:4 do:[
        drawView clear.
"/        drawView paint:Color green darkened.
        drawView topView withWaitCursorDo:[
            self paintPlant:projections iterations:100000 offsetX:300 y:420 scaleX:800 y:600
        ]
    ]

    "Modified: 16.8.1996 / 12:29:19 / cg"
!

tree2
    |projections|

    projections := Array new:4.

    "/
    "/ ( x' )    ( a  b )   ( x )   ( e )
    "/ (    ) =  (      ) x (   ) + (   )
    "/ ( y' )    ( c  d )   ( y )   ( f )
    "/
    "/                       a      b      c      d      e     f    p
    projections at:1 put:#(-0.04   0.0   -0.23  -0.65  -0.08  0.26  0.3).
    projections at:2 put:#( 0.61   0.0    0.0    0.31   0.07  2.5   0.5).
    projections at:3 put:#( 0.65   0.29  -0.3    0.48   0.54  0.39  0.8).
    projections at:4 put:#( 0.64  -0.3    0.16   0.56  -0.56  0.4   1.0).

    Processor activeProcess withPriority:4 do:[
	drawView clear.
	drawView topView withWaitCursorDo:[
	    self paintPlant:projections 
		 iterations:100000 offsetX:300 y:280 scaleX:80 y:60
	]
    ]
!

tree3
    |projections|

    projections := Array new:8.

    "/
    "/ ( x' )    ( a  b )   ( x )   ( e )
    "/ (    ) =  (      ) x (   ) + (   )
    "/ ( y' )    ( c  d )   ( y )   ( f )
    "/
    "/                       a        b        c        d       e        f        p
    projections at:1 put:#( 0.008574 -0.12698  0.00535  0.20347 0.52394  0.16848  0.1  (  0   0   0) ).
    projections at:2 put:#( 0.4481    0.52868 -0.21712  0.53388 0.293427 0.49045  0.2  (100   0   0) ).
    projections at:3 put:#( 0.0118   -0.00223  0.00007  0.37293 0.51142  0.01948  0.3  (  0 100   0) ).
    projections at:4 put:#(-0.04474  -0.41931  0.43653 -0.04297 0.48088  0.09414  0.4  (  0   0 100) ).
    projections at:5 put:#( 0.63136  -0.13708  0.13026  0.66438 0.10622  0.23675  0.5  (100 100   0) ).
    projections at:6 put:#( 0.27107   0.34582 -0.2493   0.37607 0.36307  0.35753  0.7  (100   0 100) ).
    projections at:7 put:#(-0.11509   0.29652 -0.21926 -0.1556  0.62457  0.43811  0.9  (100 100 100) ).
    projections at:8 put:#( 0.01649   0        0        0.06127 0.50875  0.00221  1.0  (  0 100   0) ).

    Processor activeProcess withPriority:4 do:[
        drawView clear.
        drawView topView withWaitCursorDo:[
            self paintPlant:projections
                 iterations:200000 offsetX:100 y:400 scaleX:400 y:400
        ]
    ]

    "Created: 16.8.1996 / 12:25:43 / cg"
    "Modified: 16.8.1996 / 12:41:07 / cg"
!

tree3Colored
    |projections|

    projections := Array new:8.

    "/
    "/ ( x' )    ( a  b )   ( x )   ( e )
    "/ (    ) =  (      ) x (   ) + (   )
    "/ ( y' )    ( c  d )   ( y )   ( f )
    "/
    "/                       a        b        c        d       e        f        p
    projections at:1 put:#( 0.008574 -0.12698  0.00535  0.20347 0.52394  0.16848  0.1  (  0   0   0) ).
    projections at:2 put:#( 0.4481    0.52868 -0.21712  0.53388 0.293427 0.49045  0.2  (100   0   0) ).
    projections at:3 put:#( 0.0118   -0.00223  0.00007  0.37293 0.51142  0.01948  0.3  (  0 100   0) ).
    projections at:4 put:#(-0.04474  -0.41931  0.43653 -0.04297 0.48088  0.09414  0.4  (  0   0 100) ).
    projections at:5 put:#( 0.63136  -0.13708  0.13026  0.66438 0.10622  0.23675  0.5  (100 100   0) ).
    projections at:6 put:#( 0.27107   0.34582 -0.2493   0.37607 0.36307  0.35753  0.7  (100   0 100) ).
    projections at:7 put:#(-0.11509   0.29652 -0.21926 -0.1556  0.62457  0.43811  0.9  (100 100 100) ).
    projections at:8 put:#( 0.01649   0        0        0.06127 0.50875  0.00221  1.0  (  0 100   0) ).

    Processor activeProcess withPriority:4 do:[
        drawView clear.
        drawView topView withWaitCursorDo:[
            self paintPlant2:projections deepCopy
                 iterations:200000 offsetX:100 y:400 scaleX:400 y:400
        ]
    ]

    "Modified: 16.8.1996 / 12:39:20 / cg"
    "Created: 16.8.1996 / 12:41:01 / cg"
! !

!FractalPlantsDemo methodsFor:'startup'!

open 
    |topView panel speedToggle nibToggle |

    topView := StandardSystemView
                    label:'FractalPlants (iterated function systems)'
                    icon:(Image fromFile:'bitmaps/Plants.xbm').

    topView extent:(600 @ 450).
    topView minExtent:(600 @ 450).

    panel := PanelView origin:(0 @ 0) extent:(1.0 @ 1.0) in:topView.

    drawView := panel.

    Button label:'fern1'     action:[self fern1] in:panel.
    Button label:'fern2'     action:[self fern2] in:panel.
    Button label:'fern3'     action:[self fern3] in:panel.
    Button label:'tree1'     action:[self tree1] in:panel.
    Button label:'tree2'     action:[self tree2] in:panel.
    Button label:'tree3'     action:[self tree3] in:panel.
    Button label:'tree3-clr' action:[self tree3Colored] in:panel.
    Button label:'old tree'  action:[self oakTree] in:panel.
    Button label:'quit'      action:[topView destroy]  in:panel.

    topView open

    "
     FractalPlantsDemo new open
    "

    "Modified: 16.8.1996 / 12:42:13 / cg"
! !

!FractalPlantsDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/FractalPlantsDemo.st,v 1.13 1998-07-09 08:08:43 cg Exp $'
! !
