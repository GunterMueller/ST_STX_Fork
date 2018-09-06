"
    COPYRIGHT (c) 1997 by eXept Software AG
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





"{ Package: 'stx:clients/TicTacToe3D' }"

"{ NameSpace: Games }"

GLXView subclass:#D3TicTacToe
	instanceVariableNames:'trans angleX angleY angleZ clickX clickY angle deltaT redrawBlock
		points sidePoints rotationMatrix oColor xColor winColor player
		expectInput isSlaveView'
	classVariableNames:'AnimateSearch'
	poolDictionaries:''
	category:'games-3DTicTacToe'
!

!D3TicTacToe class methodsFor:'documentation'!

copyright
"
    COPYRIGHT (c) 1997 by eXept Software AG
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
    3D TicTacToe

    [start with:]
        Games::D3TicTacToeGame open

    [author:]
        David Queeney
"
! !

!D3TicTacToe class methodsFor:'defaults'!

defaultExtent
    ^ 500 @ 500
!

defaultLabel
    "used by superclass"

    ^ 'GL plane'
! !

!D3TicTacToe methodsFor:'accessing'!

beSlaveView
    isSlaveView := true

    "Created 10.10.1996 / David Queeney"


!

playing:XorO 
    player := XorO

    "Created 10.10.1996 / David Queeney"



! !

!D3TicTacToe methodsFor:'drawing'!

drawFace:face color:color

    "draw the plane.
     Full plane size polygons are drawn in farbe,
     and black ones are drawn inset by some amount
     - makes it look like the real thing"

"/ subPoints contains the deviation points, horizontal and vertical.
"/ nullPoint contains the null point.
"/ workingPoint is used to draw.

        |v subPoints nullPoint workingPoint pointIndex who|

        pointIndex := ( ( face - 1 ) * 4 ).

        "/
        "/ compute the subSide corners
        "/

        subPoints := self getSubSideCorners:face corners:points.

        "/
        "/ draw the full side in black
        "/

        self color:color.
        self beginPolygon.  
        self v3f:(points at:(pointIndex + 1)).
        self v3f:(points at:(pointIndex + 2)).
        self v3f:(points at:(pointIndex + 3)).
        self v3f:(points at:(pointIndex + 4)).
        self endPolygon.

        "/
        "/ draw the subSides inset by some amount
        "/

        workingPoint := GLPoint3D x:((points at:(pointIndex + 1)) x) 
                                  y:((points at:(pointIndex + 1)) y)
                                  z:((points at:(pointIndex + 1)) z).

        nullPoint := GLPoint3D new.

        1 to:4 do:[:sy |

            nullPoint x:(workingPoint x) y:(workingPoint y) z:(workingPoint z).

            1 to:4 do:[:sz |

                self color:Black.
                self drawSquare:subPoints workPoint:workingPoint edge:0.05.

"/ level = face
"/ sy = column
"/ sz = row
"/                who := model boardAtRow:sz col:sy lev:face.
"/                who notNil ifTrue:[ drawSymbol ] ifFalse:[ drawSpace ]
"/
                self color:color.
                who := model boardAtRow:sz col:sy lev:face.
                who notNil ifTrue:[ 
                    self drawSymbol:who corners:subPoints workPoint:workingPoint edge:0.1.
                ] ifFalse:[
                    self drawSquare:subPoints workPoint:workingPoint edge:0.1.
                ].
                workingPoint x:((workingPoint x) + ((subPoints at:1) x)).
                workingPoint y:((workingPoint y) + ((subPoints at:1) y)).
                workingPoint z:((workingPoint z) + ((subPoints at:1) z)).

            ].

            workingPoint x:((nullPoint x) + ((subPoints at:2) x)).
            workingPoint y:((nullPoint y) + ((subPoints at:2) y)).
            workingPoint z:((nullPoint z) + ((subPoints at:2) z)).
        ]

    "Created: 16.10.1996 / david queeney"
!

drawOIn:subPoints workPoint:workingPoint edge:edge
        "draw an O"

        |v insXH insYH insZH insXV insYV insZV|

        v := Array new:3.

        insXH := ((subPoints at:1) x) * edge.
        insYH := ((subPoints at:1) y) * edge.
        insZH := ((subPoints at:1) z) * edge.
        insXV := ((subPoints at:2) x) * edge.
        insYV := ((subPoints at:2) y) * edge.
        insZV := ((subPoints at:2) z) * edge.

        self beginLine.
        v at:1 put:(workingPoint x) + (((subPoints at:1) x) / 2) + insXV.
        v at:2 put:(workingPoint y) + (((subPoints at:1) y) / 2) + insYV.
        v at:3 put:(workingPoint z) + (((subPoints at:1) z) / 2) + insZV.
        self v3f:v.

        v at:1 put:(workingPoint x) + ((subPoints at:1) x) + (((subPoints at:2) x) / 2) - insXH.
        v at:2 put:(workingPoint y) + ((subPoints at:1) y) + (((subPoints at:2) y) / 2) - insYH.
        v at:3 put:(workingPoint z) + ((subPoints at:1) z) + (((subPoints at:2) z) / 2) - insZH.
        self v3f:v.
        self endLine.

        self beginLine.
        v at:1 put:(workingPoint x) + ((subPoints at:1) x) + (((subPoints at:2) x) / 2) - insXH.
        v at:2 put:(workingPoint y) + ((subPoints at:1) y) + (((subPoints at:2) y) / 2) - insYH.
        v at:3 put:(workingPoint z) + ((subPoints at:1) z) + (((subPoints at:2) z) / 2) - insZH.
        self v3f:v.

        v at:1 put:(workingPoint x) + (((subPoints at:1) x) / 2) + ((subPoints at:2) x) - insXV.
        v at:2 put:(workingPoint y) + (((subPoints at:1) y) / 2) + ((subPoints at:2) y) - insYV.
        v at:3 put:(workingPoint z) + (((subPoints at:1) z) / 2) + ((subPoints at:2) z) - insZV.
        self v3f:v.
        self endLine.

        self beginLine.
        v at:1 put:(workingPoint x) + (((subPoints at:1) x) / 2) + ((subPoints at:2) x) - insXV.
        v at:2 put:(workingPoint y) + (((subPoints at:1) y) / 2) + ((subPoints at:2) y) - insYV.
        v at:3 put:(workingPoint z) + (((subPoints at:1) z) / 2) + ((subPoints at:2) z) - insZV.
        self v3f:v.

        v at:1 put:(workingPoint x) + (((subPoints at:2) x) / 2) + insXH.
        v at:2 put:(workingPoint y) + (((subPoints at:2) y) / 2) + insYH.
        v at:3 put:(workingPoint z) + (((subPoints at:2) z) / 2) + insZH.
        self v3f:v.
        self endLine.

        self beginLine.
        v at:1 put:(workingPoint x) + (((subPoints at:2) x) / 2) + insXH.
        v at:2 put:(workingPoint y) + (((subPoints at:2) y) / 2) + insYH.
        v at:3 put:(workingPoint z) + (((subPoints at:2) z) / 2) + insZH.
        self v3f:v.

        v at:1 put:(workingPoint x) + (((subPoints at:1) x) / 2) + insXV.
        v at:2 put:(workingPoint y) + (((subPoints at:1) y) / 2) + insYV.
        v at:3 put:(workingPoint z) + (((subPoints at:1) z) / 2) + insZV.
        self v3f:v.
        self endLine.

    "Created: 17.10.1996 / David Queeney"
!

drawSideForPick:side min:minColor max:maxColor
    "draw a single side full for picking.
     Use the subCube nr as color, if its in minColor..maxColor
     (have to do this in two passes, since there are less than 9
      standard colors, and we cannot depend on the display to be able
      to provide more -- and we dont want to map more colors, since
      other views may need them)"

       |v x0 x1 y0 y1 z0 z1 
        dxH dyH dzH dxV dyV dzV x y z sub
        insXH insYH insZH insXV insYV insZV
        pointIndex|

        self backBuffer.
"/        self clearView.
        self pushMatrix.
        self setProjection.

"/        self backFace:true.

        self scaleX:45 y:45 z:30.

        v := Array new:3.
        pointIndex := ( ( side - 1 ) * 4 ).

        x0 := (points at:(pointIndex + 1)) x.
        x1 := (points at:(pointIndex + 2)) x.
        dxH := (x1 - x0) / 4.0.

        y0 := (points at:(pointIndex + 1)) y.
        y1 := (points at:(pointIndex + 2)) y.
        dyH := (y1 - y0) / 4.0.

        z0 := (points at:(pointIndex + 1)) z.
        z1 := (points at:(pointIndex + 2)) z.
        dzH := (z1 - z0) / 4.0.

        x0 := (points at:(pointIndex + 2)) x.
        x1 := (points at:(pointIndex + 3)) x.
        dxV := (x1 - x0) / 4.0.

        y0 := (points at:(pointIndex + 2)) y.
        y1 := (points at:(pointIndex + 3)) y.
        dyV := (y1 - y0) / 4.0.

        z0 := (points at:(pointIndex + 2)) z.
        z1 := (points at:(pointIndex + 3)) z.
        dzV := (z1 - z0) / 4.0.

        x := (points at:(pointIndex + 1)) x.
        y := (points at:(pointIndex + 1)) y.
        z := (points at:(pointIndex + 1)) z.

        sub := 1.
        1 to:4 do:[:sy |

            x0 := x.
            y0 := y.
            z0 := z.

            1 to:4 do:[:sz |

                (sub between:minColor and:maxColor) ifTrue:[
                    self color:(sub - minColor + 1).
                ] ifFalse:[
                    self color:0
                ].

                insXH := dxH * 0.05.
                insYH := dyH * 0.05.
                insZH := dzH * 0.05.
                insXV := dxV * 0.05.
                insYV := dyV * 0.05.
                insZV := dzV * 0.05.

                self beginPolygon.  
                v at:1 put:x + insXH + insXV.
                v at:2 put:y + insYH + insYV.
                v at:3 put:z + insZH + insZV.
                self v3f:v.

                v at:1 put:x + dxH - insXH + insXV.
                v at:2 put:y + dyH - insYH + insYV.
                v at:3 put:z + dzH - insZH + insZV.
                self v3f:v.

                v at:1 put:x + dxH + dxV - insXH - insXV.
                v at:2 put:y + dyH + dyV - insYH - insYV.
                v at:3 put:z + dzH + dzV - insZH - insZV.
                self v3f:v.

                v at:1 put:x + dxV + insXH - insXV.
                v at:2 put:y + dyV + insYH - insYV.
                v at:3 put:z + dzV + insZH - insZV.
                self v3f:v.

                self endPolygon. 

                x := x + dxH.
                y := y + dyH.
                z := z + dzH.

                sub := sub + 1
            ].

            x := x0 + dxV.
            y := y0 + dyV.
            z := z0 + dzV.
        ].
"/    ].

    self popMatrix.

    "Created: 23.3.1996 / 19:10:03 / cg"
    "Modified: 24.3.1996 / 16:59:14 / cg"
    "Modified: 16.10.1996 / David Queeney"
!

drawSquare:subPoints workPoint:workingPoint edge:edge

        |v insXH insYH insZH insXV insYV insZV|

        "/subPoints
        v := Array new:3.

        insXH := ((subPoints at:1) x) * edge.
        insYH := ((subPoints at:1) y) * edge.
        insZH := ((subPoints at:1) z) * edge.
        insXV := ((subPoints at:2) x) * edge.
        insYV := ((subPoints at:2) y) * edge.
        insZV := ((subPoints at:2) z) * edge.

        self beginPolygon.  
        v at:1 put:(workingPoint x) + insXH + insXV.
        v at:2 put:(workingPoint y) + insYH + insYV.
        v at:3 put:(workingPoint z) + insZH + insZV.
        self v3f:v.

        v at:1 put:(workingPoint x) + ((subPoints at:1) x) - insXH + insXV.
        v at:2 put:(workingPoint y) + ((subPoints at:1) y) - insYH + insYV.
        v at:3 put:(workingPoint z) + ((subPoints at:1) z) - insZH + insZV.
        self v3f:v.

        v at:1 put:(workingPoint x) + ((subPoints at:1) x) + ((subPoints at:2) x) - insXH - insXV.
        v at:2 put:(workingPoint y) + ((subPoints at:1) y) + ((subPoints at:2) y) - insYH - insYV.
        v at:3 put:(workingPoint z) + ((subPoints at:1) z) + ((subPoints at:2) z) - insZH - insZV.
        self v3f:v.

        v at:1 put:(workingPoint x) + ((subPoints at:2) x) + insXH - insXV.
        v at:2 put:(workingPoint y) + ((subPoints at:2) y) + insYH - insYV.
        v at:3 put:(workingPoint z) + ((subPoints at:2) z) + insZH - insZV.
        self v3f:v.

        self endPolygon. 

!

drawSymbol:who corners:subPoints workPoint:workingPoint edge:edge
"draw the symbol"

        self color:White.

        (who == #O) ifTrue:[
            self drawOIn:subPoints workPoint:workingPoint edge:edge
        ] ifFalse:[
            (who == #X) ifTrue:[
                self drawXIn:subPoints workPoint:workingPoint edge:edge
            ] ifFalse:[
                (who == #o) ifTrue:[
                    self color:Cyan.
                    self drawSquare:subPoints workPoint:workingPoint edge:0.05.
                    self color:White.
                    self drawOIn:subPoints workPoint:workingPoint edge:edge
                ] ifFalse:[
                    (who == #x) ifTrue:[
                        self color:Cyan.
                        self drawSquare:subPoints workPoint:workingPoint edge:0.05.
                        self color:White.
                        self drawXIn:subPoints workPoint:workingPoint edge:edge
                    ]
                ]
            ]
        ]

        "Created 17.10.96 / David Queeney"

!

drawXIn:subPoints workPoint:workingPoint edge:edge
    "draw an X"

        |v insXH insYH insZH insXV insYV insZV|

        v := Array new:3.

        insXH := ((subPoints at:1) x) * edge.
        insYH := ((subPoints at:1) y) * edge.
        insZH := ((subPoints at:1) z) * edge.
        insXV := ((subPoints at:2) x) * edge.
        insYV := ((subPoints at:2) y) * edge.
        insZV := ((subPoints at:2) z) * edge.

        self beginLine.

        v at:1 put:(workingPoint x) + insXH + insXV.
        v at:2 put:(workingPoint y) + insYH + insYV.
        v at:3 put:(workingPoint z) + insZH + insZV.
        self v3f:v.

        v at:1 put:(workingPoint x) + ((subPoints at:1) x) + ((subPoints at:2) x) - insXH - insXV.
        v at:2 put:(workingPoint y) + ((subPoints at:1) y) + ((subPoints at:2) y) - insYH - insYV.
        v at:3 put:(workingPoint z) + ((subPoints at:1) z) + ((subPoints at:2) z) - insZH - insZV.
        self v3f:v.

        self endLine.
        self beginLine.
        v at:1 put:(workingPoint x) + ((subPoints at:1) x) - insXH + insXV.
        v at:2 put:(workingPoint y) + ((subPoints at:1) y) - insYH + insYV.
        v at:3 put:(workingPoint z) + ((subPoints at:1) z) - insZH + insZV.
        self v3f:v.

        v at:1 put:(workingPoint x) + ((subPoints at:2) x) + insXH - insXV.
        v at:2 put:(workingPoint y) + ((subPoints at:2) y) + insYH - insYV.
        v at:3 put:(workingPoint z) + ((subPoints at:2) z) + insZH - insZV.
        self v3f:v.

        self endLine.

    "Created: 17.10.1996 / David Queeney"



!

getSubSideCorners:face corners:points


        |x0 x1 y0 y1 z0 z1 dxH dyH dzH dxV dyV dzV pointIndex dHpoint dVpoint|

        pointIndex := ( ( face - 1 ) * 4 ).

        "/
        "/ compute the subSide corners
        "/
        x0 := (points at:(pointIndex + 1)) x.
        x1 := (points at:(pointIndex + 2)) x.
        dxH := (x1 - x0) / 4.0.

        y0 := (points at:(pointIndex + 1)) y.
        y1 := (points at:(pointIndex + 2)) y.
        dyH := (y1 - y0) / 4.0.

        z0 := (points at:(pointIndex + 1)) z.
        z1 := (points at:(pointIndex + 2)) z.
        dzH := (z1 - z0) / 4.0.

        x0 := (points at:(pointIndex + 2)) x.
        x1 := (points at:(pointIndex + 3)) x.
        dxV := (x1 - x0) / 4.0.

        y0 := (points at:(pointIndex + 2)) y.
        y1 := (points at:(pointIndex + 3)) y.
        dyV := (y1 - y0) / 4.0.

        z0 := (points at:(pointIndex + 2)) z.
        z1 := (points at:(pointIndex + 3)) z.
        dzV := (z1 - z0) / 4.0.

        dHpoint := GLPoint3D x:dxH y:dyH z:dzH.
        dVpoint := GLPoint3D x:dxV y:dyV z:dzV.

        ^(Array with:dHpoint with:dVpoint).

        "getSubSideCorners"
        "Created 16.10.96 / David Queeney"
!

redraw 

    |xSpace ySpace|
    self color:Black.
    self clear.

    self pushMatrix.

    self rotateX:angleX.
    self rotateY:angleY.
    self rotateZ:angleZ.

    self scaleX:45 y:45 z:30.

    self drawFace:1 color:Red.
    self drawFace:2 color:Green.
    self drawFace:3 color:Yellow.
    self drawFace:4 color:Blue.

    self popMatrix.
    self swapBuffers.
!

setProjection
    "recompute the projection matrix"

    self multMatrix:rotationMatrix.

    "Modified: 22.4.1996 / 23:49:41 / cg"


! !

!D3TicTacToe methodsFor:'events'!

buttonMotion:state x:x y:y
    "handle mouse pointer motion; with button possibly pressed"

    "/ this is CPU intensive; be nice to other threads ...

    Processor activeProcess withLowerPriorityDo:[
        (state bitTest:device anyButtonStateMask) ifFalse:[
            "/ no button pressed - look if the cursor should be changed
            "/ (for center subCube)

        ] ifTrue:[

            clickX notNil ifTrue:[
                y < clickY ifTrue:[
                    self rotateDX:(clickY - y) negated.
                    clickY := y
                ].

                y > clickY ifTrue:[
                    self rotateDX:(y - clickY). 
                    clickY := y
                ].

                x < clickX ifTrue:[
                    self rotateDY:(clickX - x) negated. 
                    clickX := x
                ].

                x > clickX ifTrue:[
                    self rotateDY:(x - clickX). 
                    clickX := x
                ].

                self redraw.
            ]
        ]
    ]

    "Created: 22.3.1996 / 20:26:04 / cg"
!

buttonPress:button x:x y:y
    "handle mouse button press"

    |whichSide whichSubCube|

    clickX := x.
    clickY := y.

    button ~~ 1 ifTrue:[
        whichSide := self findSideOfX:x y:y.
        whichSide isNil ifTrue:[
            'click outside cube' printNL.
            ^ self
        ].

        whichSubCube := self findSubCubeInSide:whichSide x:x y:y.
        whichSubCube isNil ifTrue:[
            'cannot determine subCube' printNL.
            ^ self
        ].

        self redraw.
        self sensor altDown ifTrue:[
            self redraw.
            ^ self
        ].
        model userPlay:player row:(1 + ((whichSubCube - 1) \\ 4)) col:(1 + ((whichSubCube - 1) // 4))  lev:whichSide.
        self redraw.
    ].
!

buttonRelease:button x:x y:y
    "handle mouse button release"

    clickX := clickY := nil.

    "Created: 22.3.1996 / 20:29:35 / cg"
    "Modified: 22.4.1996 / 23:46:56 / cg"
!

sizeChanged:how
    "handle sizeChange of the view"

    super sizeChanged:how.
    self setupViewing.

    "Created: 24.3.1996 / 16:46:52 / cg"
    "Modified: 22.4.1996 / 23:47:14 / cg"
!

update:something with:aParameter from:changedObject
    |l|

    something == #player ifTrue:[
        model currentPlayer == player ifTrue:[
            self cursor:Cursor normal.
            expectInput := true.
            self label:'TicTacToe: your turn'.
        ] ifFalse:[
            self cursor:Cursor stop.
            expectInput := false.
            self label:'TicTacToe: others turn'.
        ].
        ^ self
    ].

    shown ifFalse:[^ self].

    something == #board ifTrue:[
        self clear.
        self redraw.
        ^ self
    ].
    something == #field: ifTrue:[
        self redraw.
        ^ self
    ].
    something == #gameOver ifTrue:[
        self sensor pushUserEvent:#showGameOver for:self.
        ^ self
    ].
    something == #gameFinished ifTrue:[
        self sensor pushUserEvent:#showGameFinished for:self.
        ^ self
    ].
    something == #winner ifTrue:[
"
        l := model winningLine.
        self showWinningLine:l.
"
        self redraw.
        ^ self
    ].

    "Created: 10.10.1996 / David Queeney"

! !

!D3TicTacToe methodsFor:'initialization'!

destroy
    model removeDependent:self.
    model gameFinished:true.
    super destroy.

    "Created 10.10.1996 / David Queeney"


!

initialize
    super initialize.
    type := #colorIndexDoubleBuffer.
    angleX := angleY := angleZ := 0.0.
    angleX := -85.0.

    device hasColors ifTrue:[
        oColor := Color cyan.
        xColor := Color orange.
        winColor := Color red:50 green:50 blue:50.
    ] ifFalse:[
        oColor := xColor := Color black.
        winColor := Color veryLightGrey.
    ].
    oColor := oColor onDevice:device.
    xColor := xColor onDevice:device.
    winColor := winColor onDevice:device.

    trans := -5.0.

    self doubleBuffer.

    points := Array new:16.
    points at:1  put:(GLPoint3D x:-1.0 y:-1.0 z:-1.0).   
    points at:2  put:(GLPoint3D x: 1.0 y:-1.0 z:-1.0).   
    points at:3  put:(GLPoint3D x: 1.0 y: 1.0 z:-1.0).   
    points at:4  put:(GLPoint3D x:-1.0 y: 1.0 z:-1.0).   
    points at:5  put:(GLPoint3D x:-1.0 y:-1.0 z:-0.33).
    points at:6  put:(GLPoint3D x: 1.0 y:-1.0 z:-0.33).   
    points at:7  put:(GLPoint3D x: 1.0 y: 1.0 z:-0.33).   
    points at:8  put:(GLPoint3D x:-1.0 y: 1.0 z:-0.33).
    points at:9  put:(GLPoint3D x:-1.0 y:-1.0 z: 0.33).
    points at:10 put:(GLPoint3D x: 1.0 y:-1.0 z: 0.33).   
    points at:11 put:(GLPoint3D x: 1.0 y: 1.0 z: 0.33).   
    points at:12 put:(GLPoint3D x:-1.0 y: 1.0 z: 0.33).   
    points at:13 put:(GLPoint3D x:-1.0 y:-1.0 z: 1.0).
    points at:14 put:(GLPoint3D x: 1.0 y:-1.0 z: 1.0).   
    points at:15 put:(GLPoint3D x: 1.0 y: 1.0 z: 1.0).   
    points at:16 put:(GLPoint3D x:-1.0 y: 1.0 z: 1.0).

    self enableMotionEvents.
    self frontView.

    "GLPlaneDemoView1 new inspect"
!

realize
    super realize.
    self perspectiveFovy:450 aspect:1.0 near:1.0 far:200.0. 
    self translateZ:-150.
!

setupViewing
    "setup the viewing parameters"

    |angle zoom|

    "wide angle lens"
    angle := 450.
    zoom := 5.

    "zoom lens"
    angle := 200.
    zoom := 10.

    "
     define perspective (see GL manual)
        0.0                                   200.0

    eye                                   
        near                                  far
    <)  -------------+------+-----------------+-------------------+
    degrees          \      \                  \                   \
    field of view     \      \                  \                   \
                       \      \                  \                   \
                        +------+                  \                   \
                                                   \                   \
                                                    \                   \
                                                     \                   \
                                                      \                   \
                                                       +-------------------+

         ---> negative z coordinates
    "
    self perspectiveFovy:angle aspect:1.0 near:0.0 far:200.0.

    "
     translate for eye position at 0/0/zoom
    "
    self translateX:0 
                  y:0 
                  z:(zoom negated).

    "
     looking straight into the picture
    "
"/    self rotateX:0 y:0 z:0.

    self pushMatrix.
    rotationMatrix := FloatArray new:16.
    self loadIdentityMatrix.
    self rotateX:angleX y:angleY z:angleZ.
    self getMatrix:rotationMatrix.
    self popMatrix.
!

unrealize 
    super unrealize.
! !

!D3TicTacToe methodsFor:'misc'!

showGameFinished
    |box|

    model gameFinished ifTrue:[
        box := InfoBox onDevice:device.
        box title:'game finished by other player'.
        box showAtPointerNotCovering:self.
        self destroy.
        ^ self
    ].

    "Created 10.10.1996 / David Queeney"
!

showGameOver
    |s box winner|

    model gameOver ifTrue:[

        winner := model winner.
        winner isNil ifTrue:[
            s := 'no winner !!\another game ?'
        ] ifFalse:[
            winner == player ifTrue:[
                s := 'You win !!\another game ?'
            ] ifFalse:[
                s := 'You loose !!\another game ?'
            ]
        ].

        box := YesNoBox onDevice:self device.
        box title:s withCRs.
        box yesAction:[model gameFinished ifTrue:[
                            self showGameFinished
                       ] ifFalse:[
                            model newGame
                       ]
                      ]
             noAction:[self topView destroy].
        box showAtPointerNotCovering:self.

    ]

    "Created 10.10.1996 / David Queeney"
! !

!D3TicTacToe methodsFor:'private'!

findSideOfX:x y:y
    "given x/y, return which side that is"

    |pixel|

    "/ draw each of the cubes sides with the side nr as ``color''
    "/ into the backBuffer, see which ``color'' we find at x/y for the sideNr

    pixel := self pixelAtX:x y:y.

    (pixel isNil or:[pixel == Black]) ifTrue:[
        ^ nil
    ].
    (pixel between:1 and:4) ifFalse:[
        ^ nil
    ].

    ^ pixel

    "Created: 16.10.1996 / David Queeney"
!

findSubCubeInSide:side x:x y:y
    |clr pixel|

    "/ redraw each subCube of that side using the subCube index as ``color'',
    "/ all others black, and see which ``color'' we get at x/y for the subCube index

    self drawSideForPick:side min:1 max:7.

    AnimateSearch == true ifTrue:[
        self swapBuffers.
        self drawSideForPick:side min:1 max:7.
        Delay waitForSeconds:0.5.    
    ].

    pixel := self pixelAtX:x y:y.
    (pixel isNil or:[pixel == Black]) ifTrue:[
        self drawSideForPick:side min:8 max:14.

        AnimateSearch == true ifTrue:[
            self swapBuffers.
            self drawSideForPick:side min:8 max:14.
            Delay waitForSeconds:0.5.    
        ].

        pixel := self pixelAtX:x y:y.
        (pixel notNil and:[pixel ~~ Black]) ifTrue:[
            pixel := pixel + 7
        ]
                                            ifFalse:[
            self drawSideForPick:side min:15 max:16.
            AnimateSearch == true ifTrue:[
                self swapBuffers.
                self drawSideForPick:side min:15 max:16.
                Delay waitForSeconds:0.5.    
            ].
            pixel := self pixelAtX:x y:y.
            (pixel notNil and:[pixel ~~ Black]) ifTrue:[
                pixel := pixel + 14
            ]
        ]
    ].

    AnimateSearch == true ifTrue:[
        self redraw.
    ].

    pixel == Black ifTrue:[
        ^ nil
    ].
    ^ pixel

    "see how this works, by setting AnimateSearch to true.

     AnimateSearch := true
     AnimateSearch := false
    "

    "Created: 22.3.1996 / 22:39:14 / cg"
    "Modified: 23.3.1996 / 19:37:54 / cg"
!

pixelAtX:x y:y
    "fetch a pixel and return it"

    |data n pixel clr|

    (x between:0 and:width-1) ifTrue:[
        (y between:0 and:height-1) ifTrue:[
            "/ fetch the pixel

            data := Array new:1.

            device glxReadsource:#auto in:drawableId.
            n := device glxRectreadX1:x y1:y x2:x y2:y h:height to:data in:drawableId.
            n < 1 ifTrue:[
                'oops - read failed' printNL.
            ] ifFalse:[
                pixel := data at:1.
            ]
        ]
    ].

    ^ pixel

    "Created: 23.3.1996 / 10:19:34 / cg"
    "Modified: 23.3.1996 / 13:56:47 / cg"
! !

!D3TicTacToe methodsFor:'rotating'!

backView
    "change perspective to see the views backside"

    angleX := -30.
    angleY := 180-30.
    angleZ := 0.

    self pushMatrix.

    self loadIdentityMatrix.
    self rotateX:angleX y:angleY z:0.
    self getMatrix:rotationMatrix.

    self popMatrix.

    "Created: 23.3.1996 / 15:23:38 / cg"
    "Modified: 22.4.1996 / 23:50:41 / cg"
!

frontView
    "change perspective to see the cubes frontside"

    angleX := 30.
    angleY := -30.
    angleZ := 0.

    self pushMatrix.

    self loadIdentityMatrix.
    self rotateX:angleX y:angleY z:0.
    self getMatrix:rotationMatrix.

    self popMatrix.

    "Created: 23.3.1996 / 15:22:43 / cg"
    "Modified: 22.4.1996 / 23:50:32 / cg"
!

rotateDX:deltaX
    "rotate around x-axis by deltaX"

    angleX := angleX + deltaX.

    angleX < -90 ifTrue:[angleX := -90].
    angleX > 90 ifTrue:[angleX := 90].

    self pushMatrix.

    self loadIdentityMatrix.
    self rotateX:angleX y:angleY z:angleZ.
    self getMatrix:rotationMatrix.

    self popMatrix.

    "Modified: 22.4.1996 / 23:51:30 / cg"
!

rotateDY:deltaY
    "rotate around y-axis by deltaY"

    angleY := angleY + deltaY.

"/    angleY < -90 ifTrue:[angleY := -90].
"/    angleY > 90 ifTrue:[angleY := 90].

    self pushMatrix.

    self loadIdentityMatrix.
    self rotateX:angleX y:angleY z:angleZ.
    self getMatrix:rotationMatrix.

    self popMatrix.

    "Modified: 22.4.1996 / 23:51:21 / cg"
!

rotateDZ:deltaZ
    "rotate around z-axis by deltaZ"

    angleZ := angleZ + deltaZ.

    angleZ < -90 ifTrue:[angleZ := -90].
    angleZ > 90 ifTrue:[angleZ := 90].

    self pushMatrix.

    self loadIdentityMatrix.
    self rotateX:angleX y:angleY z:angleZ.
    self getMatrix:rotationMatrix.

    self popMatrix.

    "Modified: 22.4.1996 / 23:51:45 / cg"
! !

!D3TicTacToe class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/TicTacToe3D/D3TicTacToe.st,v 1.4 2004-03-08 18:19:43 stefan Exp $'
! !
