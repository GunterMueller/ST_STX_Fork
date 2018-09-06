"
 COPYRIGHT (c) 1999 by Claus Gittinger
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

Object subclass:#LSystemsDemo
	instanceVariableNames:'drawView stack depth axiom productions actions x y phi delta h
		hScale scale offset'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!LSystemsDemo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by Claus Gittinger
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
    draws fractal patterns using L-Systems.
    The algorithms & parameters are described (among elsewhere)
    in:
       Algortihms for fractals & chaos
       by Dietmar Herrmann
       Addison Wesley ISBN 3-89319-633-1
       Chapter 14.

    Claus:
       Maybe someone makes a nice interactive application 
       (with sliders for hScale, phi etc.) for this ...

    [see also:]
        FractalPatternsDemo
        FractalPlantsDemo

    [start with:]
        LSystemsDemo open

    [author:]
        Claus Gittinger
"



! !

!LSystemsDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:35:49 / cg"

!

open
    ^ self new open


! !

!LSystemsDemo methodsFor:'drawing'!

doLindenmayer
    "draw a Lindenmayer plant"

    Processor activeProcess withPriority:4 do:[
        drawView clear.
        drawView topView withWaitCursorDo:[
            self lindenmayer.
        ]
    ]
!

lindenmayer
    "draw a Lindenmayer plant, defined by
     axiom, productions, start, phi, delta, h
     See Algorithms for Fractals and Chaos Pg. 198
    "

    self produce:axiom level:depth.
!

produce:rule level:lvl
    "expand a rule
    "

    rule do:[:token |
        |action expansion|

        lvl == 0 ifTrue:[
            (actions at:token) value
        ] ifFalse:[
            expansion := productions at:token ifAbsent:nil.
            expansion notNil ifTrue:[
                self produce:expansion level:lvl-1
            ] ifFalse:[
                (actions at:token) value
            ]
        ]
    ].
! !

!LSystemsDemo methodsFor:'drawing - patterns'!

dragon
    "draw a Lindenmayer dragon-curve;
     See Algorithms for Fractals and Chaos Pg. 198
    "

    self setupStandardParameters.

    axiom := 'F'.
    productions at:$F put:'F+G+'.
    productions at:$G put:'-F-G'.
    actions at:$G put:(actions at:$F).

    x := 0.
    y := -2.5.
    phi := 0 degreesToRadians.
    delta := 90 degreesToRadians.
    h := 0.04.
    depth := 12.
    scale := 100 @ -100.
    offset := 400 @ 30.

    self doLindenmayer.

    "Modified: 16.8.1996 / 12:18:38 / cg"


!

gosper
    "draw a Lindenmayer gosper-curve;
     See Algorithms for Fractals and Chaos Pg. 198
    "

    self setupStandardParameters.

    axiom := 'F'.
    productions at:$F put:'F+G++G-F--FF-G+'.
    productions at:$G put:'-F+GG++G+F--F-G'.
    actions at:$G put:(actions at:$F).

    x := 0.
    y := -2.5.
    phi := 0 degreesToRadians.
    delta := 60 degreesToRadians.
    h := 0.06.
    depth := 4.
    scale := 100 @ -100.
    offset := 360 @ 150.

    self doLindenmayer.

    "Modified: 16.8.1996 / 12:18:38 / cg"


!

hilbert
    "draw a Lindenmayer hilbert-curve;
     See Algorithms for Fractals and Chaos Pg. 198
    "

    self setupStandardParameters.

    axiom := 'X'.
    productions at:$X put:'-YF+XFX+FY-'.
    productions at:$Y put:'+XF-YFY-FX+'.
    productions at:$F put:'F'.
"/    actions at:$X put:(actions at:$F).
"/    actions at:$Y put:(actions at:$F).
    actions at:$X put:[].
    actions at:$Y put:[].

    x := 0.
    y := -2.5.
    phi := 0 degreesToRadians.
    delta := 90 degreesToRadians.
    h := 0.06.
    depth := 6.
    scale := 100 @ -100.
    offset := 120 @ -200.

    self doLindenmayer.

    "Modified: 16.8.1996 / 12:18:38 / cg"


!

koch
    "draw a Lindenmayer koch-curve;
     See Algorithms for Fractals and Chaos Pg. 198
    "

    self setupStandardParameters.

    axiom := 'F'.
    productions at:$F put:'F+F--F+F'.
    x := 0.
    y := -2.5.
    phi := 0 degreesToRadians.
    delta := 60 degreesToRadians.
    h := 0.04.
    depth := 5.
    scale := 60 @ -60.
    offset := 10 @ 100.

    self doLindenmayer.

    "Modified: 16.8.1996 / 12:18:38 / cg"


!

sierpinski
    "draw a Lindenmayer sierpinski-curve;
     See Algorithms for Fractals and Chaos Pg. 198
    "

    self setupStandardParameters.

    axiom := 'G'.
    productions at:$F put:'G+F+G'.
    productions at:$G put:'F-G-F'.
    actions at:$G put:(actions at:$F).

    x := 0.
    y := -2.5.
    phi := 0 degreesToRadians.
    delta := 60 degreesToRadians.
    h := 0.05.
    depth := 6.
    scale := 100 @ -100.
    offset := 150 @ 100.

    self doLindenmayer.

    "Modified: 16.8.1996 / 12:18:38 / cg"


! !

!LSystemsDemo methodsFor:'drawing - plants'!

plant1
    "draw a Lindenmayer plant;
     See Algorithms for Fractals and Chaos Pg. 198

     axiom:             F
     production:        F -> FF-[-F+F+F]+[+F-F-F]
     start:             0 @ -2.5
     phi:               pi / 2
     delta:             pi / 7
     h:                 0.04
     recursionDepth:    4
    "

    self plant1Definition.
    self doLindenmayer.

    "Modified: 16.8.1996 / 12:18:38 / cg"


!

plant1Definition
    "setup for a Lindenmayer plant;
     See Algorithms for Fractals and Chaos Pg. 198

     axiom:             F
     production:        F -> F[+F]F[-F][F]
     start:             0 @ -2.5
     phi:               pi / 2
     delta:             20 degrees
     h:                 0.04
     recursionDepth:    4
    "

    self setupStandardParameters.

    axiom := 'F'.
    productions at:$F put:'FF-[-F+F+F]+[+F-F-F]'.
    x := 0.
    y := -2.5.
    phi := Float pi / 2.
    delta := Float pi / 7.
    h := 0.04.
    depth := 4.
    scale := 200 @ -180.
    offset := 280 @ -10.


!

plant2
    "draw a Lindenmayer plant;
     See Algorithms for Fractals and Chaos Pg. 198

     same as plant1, but
     recursionDepth:    4
    "

    self plant1Definition.
    depth := 4.
    h := 0.05.
    hScale := 1.2.
"/    offset := offset + (0@200).
    productions at:$F put:'FF-[/-F+F+F]+[/+F-F-F]'.

    self doLindenmayer
!

plant3
    "draw a Lindenmayer plant;
     See Algorithms for Fractals and Chaos Pg. 198

     axiom:             F
     production:        F -> F-[+F]F[F]F
     start:             0 @ -2.5
     phi:               20 degrees
     delta:             pi / 7
     h:                 0.04
     recursionDepth:    4
    "

    self plant3Definition.
    self doLindenmayer.

    "Modified: 16.8.1996 / 12:18:38 / cg"


!

plant3Definition
    "setup for a Lindenmayer plant;
     See Algorithms for Fractals and Chaos Pg. 198

     axiom:             F
     production:        F -> F[+F]F[-F][F]
     start:             0 @ -2.5
     phi:               pi / 2
     delta:             20 degrees
     h:                 0.04
     recursionDepth:    4
    "

    self setupStandardParameters.

    axiom := 'F'.
    productions at:$F put:'F[+F]F[-F][F]'.
    x := 0.
    y := -2.5.
    phi := Float pi / 2.
    delta := 20 degreesToRadians.
    h := 0.04.
    depth := 5.
    scale := 200 @ -160.
    offset := 280 @ 20.


!

plant4
    "draw a Lindenmayer plant;
     See Algorithms for Fractals and Chaos Pg. 198

     axiom:             F
     production:        F -> F-[+F]F[F]F
     start:             0 @ -2.5
     phi:               20 degrees
     delta:             pi / 7
     h:                 0.04
     recursionDepth:    4
    "

    self plant4Definition.
    self doLindenmayer.

    "Modified: 16.8.1996 / 12:18:38 / cg"


!

plant4Definition
    "setup for a Lindenmayer plant;
     See Algorithms for Fractals and Chaos Pg. 198

     axiom:             F
     production:        F -> F[+F]F[-F][F]
     start:             0 @ -2.5
     phi:               pi / 2
     delta:             25.7 degrees
     h:                 0.04
     recursionDepth:    5
    "

    self setupStandardParameters.

    axiom := 'F'.
    productions at:$F put:'F[+F]F[-F][F]'.
    x := 0.
    y := -2.5.
    phi := Float pi / 2.
    delta := 25.7 degreesToRadians.
    h := 0.04.
    depth := 5.
    scale := 200 @ -160.
    offset := 280 @ 40.


! !

!LSystemsDemo methodsFor:'helpers'!

popState
    |state|

    state := stack removeLast.
    x := state at:1.
    y := state at:2.
    phi := state at:3.
    h := state at:4.

!

pushState
    stack addLast:(Array with:x with:y with:phi with:h)
! !

!LSystemsDemo methodsFor:'setup'!

setupStandardParameters
    productions := IdentityDictionary new.
    actions := IdentityDictionary new.

    axiom := 'F'.
    x := 0.
    y := 0.
    hScale := 0.
    scale := 200 @ -200.
    offset := 280 @ 0.

    "/
    "/ standard actions
    "/
    actions at:$- put:[phi := phi - delta].
    actions at:$+ put:[phi := phi + delta].
    actions at:$/ put:[h := h / hScale].
    actions at:$* put:[h := h * hScale].
    actions at:$[ put:[self pushState].
    actions at:$] put:[self popState].
    actions at:$F put:[|nextX nextY|
                       nextX := x + (h * phi cos).
                       nextY := y + (h * phi sin).
                       drawView 
                            displayLineFromX:(x * scale x) + offset x
                            y:(y * scale y) + offset y
                            toX:(nextX * scale x) + offset x
                            y:(nextY * scale y) + offset y.
                       x := nextX.
                       y := nextY.
                      ].

    stack := OrderedCollection new.

! !

!LSystemsDemo methodsFor:'startup'!

open 
    |topView panel speedToggle nibToggle |

    topView := StandardSystemView
                    label:'Lindenmayer-Systems'
                    icon:(Image fromFile:'bitmaps/Plants.xbm').

    topView extent:(600 @ 450).
    topView minExtent:(600 @ 450).

    panel := PanelView origin:(0 @ 0) extent:(1.0 @ 1.0) in:topView.

    drawView := panel.

    Button label:'plant1'     action:[self plant1] in:panel.
    Button label:'plant2'     action:[self plant2] in:panel.
    Button label:'plant3'     action:[self plant3] in:panel.
    Button label:'plant4'     action:[self plant4] in:panel.
    Button label:'koch'       action:[self koch] in:panel.
    Button label:'dragon'     action:[self dragon] in:panel.
    Button label:'sierpinski' action:[self sierpinski] in:panel.
    Button label:'gosper'     action:[self gosper] in:panel.
    Button label:'hilbert'    action:[self hilbert] in:panel.
    Button label:'quit'       action:[topView destroy]  in:panel.

    topView open

    "
     LSystemsDemo new open
    "

    "Modified: 16.8.1996 / 12:42:13 / cg"


! !

!LSystemsDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/LSystemsDemo.st,v 1.1 1999-09-22 11:45:55 cg Exp $'
! !
