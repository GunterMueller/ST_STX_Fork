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

GLXView subclass:#RubicsCubeView
	instanceVariableNames:'cube trans colors points sidePoints subPoints angleX angleY
		angleZ clickX clickY clickSide clickSubCube rotationMatrix
		skippedKeys'
	classVariableNames:'AnimateSearch MoveEyeCursor RotateCWCursor RotateCCWCursor'
	poolDictionaries:''
	category:'demos-3D'
!

!RubicsCubeView class methodsFor:'documentation'!

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
    displays and interacts with a RubicsCube

    This little goody was written for multiple purposes:

        - provide a demo/template for a simple applications
          (i.e. for you, to have something to start with ;-)

          complete with:
                a pull down menu with fancy about-item
                icon
                about box, showing revision info
                online help

        - demonstrate 3D graphics, rotations
        - combine ST/X interaction with 3D GL graphics
        - especially demonstrate how picking can be done in 3D space

    This demo works on both full GLs (i.e. SGIs) and on the stripped down
    VGL simulation.
    Notice, a move to openGL is planned for the near future ...
    ... but the GLXView/GLXWorkstation protocol will remain unchanged.

    TODO: rewrite using the GUIPainter.

    The following user interaction is provided:

    mouse:

        left-Button (& motion)     rotate the cube around its x/y axes

        middle-Button press        
           on a center-subCube     rotate that plane clockWise
                                   or counterClockWise (if shift key is pressed)

    keyboard:
        x/X                        rotate the cube around its x axis
        y/Y                        rotate the cube around its y axis
        z/Z                        rotate the cube around its z axis

        i                          cleanup (initialize) the cube

        f                          front view
        b                          back view

        space or                   same as middle-button-press
        return

        1..6                       rotate plane of side # clockWise

    [start with:]
        RubicsCubeView open
        RubicsCubeView open2

    [author:]
        Claus Gittinger

    [see also:]
        RubicsCube
        GLXView
        GLXWorkstation
"
! !

!RubicsCubeView class methodsFor:'defaults'!

defaultExtent
    "return the default extent of my instances.
     The value returned here is usually ignored, and
     the value from preferredExtent taken instead."

    ^ 350 @ 350

    "Modified: 22.4.1996 / 23:37:16 / cg"
!

defaultLabel
    "return the views default window label"

    ^ 'Rubics cube'

    "Modified: 22.4.1996 / 23:48:01 / cg"
! !

!RubicsCubeView class methodsFor:'start'!

open
    "open as full topView (with pullDownMenu)"

    |top m v cube e resources aboutImage smallImage prefIconSize 
     animateProcess stopAnimateBlock startAnimateBlock|

    self checkForGLDrawing ifFalse:[
        ^ nil
    ].

    resources := self classResources.
    aboutImage := Smalltalk imageFromFileNamed:'RCube.tiff' forClass:self.

    prefIconSize := Screen current preferredIconSize.

    top := StandardSystemView new.
    top label:'Rubics cube'.
    aboutImage notNil ifTrue:[
        top icon:((aboutImage magnifiedTo:prefIconSize)).
    ].

    m := PullDownMenu in:top.
    m origin:0.0 @ 0.0 corner:(1.0 @ m height).

    m labels:(resources array:#(
                 'About'
                 'File'
                 'Cube'
                 'Help'
              ))
      selectors:#(
                about
                file
                cube
                help
                ).

    m at:#about 
           putLabels:(resources array:#(
                                        'about ...'
                                       ))
           selectors:#(
                                        #about 
                      ).

    "
     if there is an icon, change 'about' to the cubes icon
    "
    aboutImage notNil ifTrue:[
        smallImage := aboutImage magnifiedTo:(m font height asPoint).
        m labels at:1 put:smallImage.
    ].

    m at:#file 
           putLabels:(resources array:#(
                                        'quit'
                                       ))
           selectors:#(
                                        #quit 
                      ).

    m at:#cube 
           putLabels:(resources array:#(
                                        'undo last'
                                        'undo all'
                                        '-'
                                        'reset'
                                        '-'
                                        'scramble'
                                        'random auto moves'
                                       ))
           selectors:#(
                                        #undoLast 
                                        #undoAll 
                                        nil
                                        #reset 
                                        nil
                                        #randomize 
                                        #animate 
                      ).

    m at:#help 
           putLabels:(resources array:#(
                                        'mouse & keyboard'
                                        '-'
                                        '3D GL graphics'
                                       ))
           selectors:#(
                                        #mouseAndKeyboardHelp 
                                        nil
                                        #glHelp 
                      ).

    (m subMenuAt:#about) actionAt:#about
                        put:[
                                |box|

                                box := AboutBox new.
                                box label:'About Rubics Cube ...'.
                                box title:'Rubics Cube (V' 
                                           , self revision 
                                           , ' of '
                                           , self revisionDateString
                                           , ')

an interactive 3D GL graphics demo, 

(written to provide a 3D-application template
 and especially to demonstrate 3D picking)

Have fun.
'.
                                box form:aboutImage.
                                box show
                            ].
    (m subMenuAt:#file) actionAt:#quit
                        put:[top destroy].
    (m subMenuAt:#cube) actionAt:#reset
                        put:[cube reset].
    (m subMenuAt:#cube) actionAt:#randomize
                        put:[cube randomize].
    (m subMenuAt:#cube) actionAt:#undoLast
                        put:[cube undo].
    (m subMenuAt:#cube) actionAt:#undoAll
                        put:[cube undoAll].

    stopAnimateBlock := [
                            animateProcess notNil ifTrue:[
                                animateProcess terminate.
                                animateProcess := nil.
                                (m subMenuAt:#cube) actionAt:#animate
                                                         put:startAnimateBlock.
                                (m subMenuAt:#cube) labelAt:#animate
                                                         put:'random auto moves'.
                            ]
                         ].
    startAnimateBlock := [
                            animateProcess isNil ifTrue:[
                                animateProcess := cube startRandomMoveProcessWhile:[top realized].
                                (m subMenuAt:#cube) actionAt:#animate
                                                         put:stopAnimateBlock.
                                (m subMenuAt:#cube) labelAt:#animate
                                                         put:(resources string:'stop random auto moves').
                            ]
                         ].
    (m subMenuAt:#cube) actionAt:#animate
                        put:startAnimateBlock.
    (m subMenuAt:#help) actionAt:#glHelp
                        put:[HTMLDocumentView openFullOnDocumentationFile:'programming/GL.html'].
    (m subMenuAt:#help) actionAt:#mouseAndKeyboardHelp
                        put:[HTMLDocumentView openFullOnHelpFile:'RubicsCube/mouseAndKbd.html'].

    v := self origin:0.0@0.0 corner:1.0@1.0 in:top.
    v topInset:(m height).
    v cube:(cube := RubicsCube new initialize).

    e := self defaultExtent + (0 @ m height).
    top extent:e.
    "/ top minExtent:e; maxExtent:e.

    top open.

    "
     RubicsCubeView open
    "

    "Modified: / 6.2.1998 / 03:57:04 / cg"
!

open2
    "open two simple topViews on the same cube"

    |v1 v2 cube|

    self checkForGLDrawing ifFalse:[
        ^ nil
    ].

    cube := RubicsCube new initialize.

    v1 := super open.
    v1 frontView.
    v1 cube:cube.

    v2 := super open.
    v2 backView.
    v2 cube:cube.

    "
     RubicsCubeView open2
    "
!

openPlain
    "open as simple topView"

    |v|

    self checkForGLDrawing ifFalse:[
        ^ nil
    ].

    v := super open.
    v cube:(RubicsCube new initialize)

    "
     RubicsCubeView openPlain
    "

    "Modified: 23.3.1996 / 18:35:14 / cg"
    "Created: 24.3.1996 / 18:27:47 / cg"
! !

!RubicsCubeView methodsFor:'accessing'!

cube:aRubicsCube
    "set the cube; make myself depend on it"

    cube := aRubicsCube.
    cube addDependent:self.

    "Modified: 22.4.1996 / 23:48:35 / cg"
!

flip
    "flip the viewieng perspective"

    angleX := 180.

    "Created: 23.3.1996 / 13:09:41 / cg"
    "Modified: 22.4.1996 / 23:48:45 / cg"
! !

!RubicsCubeView methodsFor:'change & update'!

update:aspect with:parameter from:changedObject
    "something changed - if it was the cube, redraw it"

    changedObject == cube ifTrue:[
        ^ self redraw
    ].
    ^ super update:aspect with:parameter from:changedObject

    "Created: 23.3.1996 / 13:04:09 / cg"
    "Modified: 22.4.1996 / 23:49:02 / cg"
! !

!RubicsCubeView methodsFor:'drawing'!

clearView
    "
     clear the drawing area
    "
    (type == #colorIndexDoubleBuffer
    or:[type == #colorIndex]) ifTrue:[
        self color:Black
    ] ifFalse:[
        self colorRed:0 green:0 blue:0.
    ].
    self clear.

    self czClearColor:0 z:100000. "/ (SmallInteger maxVal min:(device maxZValue)). 
    self zClear.

    "Created: 23.3.1996 / 10:27:19 / cg"
    "Modified: 23.3.1996 / 10:30:59 / cg"
!

drawCube
    "draw the cube.
     Full subSide size polygons are drawn in black,
     and colored ones are drawn inset by some amount
     - makes it look like the real thing"

    |sideCorners v x0 x1 y0 y1 z0 z1 
     dxH dyH dzH dxV dyV dzV x y z sub
     insXH insYH insZH insXV insYV insZV|

    self backFace:true.

    v := Array new:3.

    1 to:6 do:[:side |
        sideCorners := sidePoints at:side.

        "/
        "/ compute the subSide corners
        "/
        x0 := (sideCorners at:1) x.
        x1 := (sideCorners at:2) x.
        dxH := (x1 - x0) / 3.0.

        y0 := (sideCorners at:1) y.
        y1 := (sideCorners at:2) y.
        dyH := (y1 - y0) / 3.0.

        z0 := (sideCorners at:1) z.
        z1 := (sideCorners at:2) z.
        dzH := (z1 - z0) / 3.0.

        x0 := (sideCorners at:2) x.
        x1 := (sideCorners at:3) x.
        dxV := (x1 - x0) / 3.0.

        y0 := (sideCorners at:2) y.
        y1 := (sideCorners at:3) y.
        dyV := (y1 - y0) / 3.0.

        z0 := (sideCorners at:2) z.
        z1 := (sideCorners at:3) z.
        dzV := (z1 - z0) / 3.0.

        "/
        "/ the insets
        "/
        insXH := dxH * 0.05.
        insYH := dyH * 0.05.
        insZH := dzH * 0.05.
        insXV := dxV * 0.05.
        insYV := dyV * 0.05.
        insZV := dzV * 0.05.

        "/
        "/ draw the full side in black
        "/
        self color:Black.
        self beginPolygon.  
        self v3f:(sideCorners at:1).
        self v3f:(sideCorners at:2).
        self v3f:(sideCorners at:3).
        self v3f:(sideCorners at:1).
        self endPolygon.


        "/
        "/ draw the subSides inset by some amount
        "/
        x := (sideCorners at:1) x.
        y := (sideCorners at:1) y.
        z := (sideCorners at:1) z.

        sub := 1.
        1 to:3 do:[:sy |

            x0 := x.
            y0 := y.
            z0 := z.

            1 to:3 do:[:sz |

"/                self color:Black.
"/
"/                self beginPolygon.  
"/                v at:1 put:x.
"/                v at:2 put:y.
"/                v at:3 put:z.
"/                self v3f:v.
"/
"/                v at:1 put:x+dxH.
"/                v at:2 put:y+dyH.
"/                v at:3 put:z+dzH.
"/                self v3f:v.
"/
"/                v at:1 put:x+dxH+dxV.
"/                v at:2 put:y+dyH+dyV.
"/                v at:3 put:z+dzH+dzV.
"/                self v3f:v.
"/
"/                v at:1 put:x+dxV.
"/                v at:2 put:y+dyV.
"/                v at:3 put:z+dzV.
"/                self v3f:v.
"/
"/                self endPolygon. 
"/
                self color:(colors at:(cube side:side sub:sub)).

                self beginPolygon.  
                v at:1 put:x + insXH + insXV.
                v at:2 put:y + insYH + insYV.
                v at:3 put:z + insZH + insZV.
                self v3f:v.

                v at:1 put:x+dxH - insXH + insXV.
                v at:2 put:y+dyH - insYH + insYV.
                v at:3 put:z+dzH - insZH + insZV.
                self v3f:v.

                v at:1 put:x+dxH+dxV - insXH - insXV.
                v at:2 put:y+dyH+dyV - insYH - insYV.
                v at:3 put:z+dzH+dzV - insZH - insZV.
                self v3f:v.

                v at:1 put:x+dxV + insXH - insXV.
                v at:2 put:y+dyV + insYH - insYV.
                v at:3 put:z+dzV + insZH - insZV.
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
        ]
    ]

    "Created: 22.3.1996 / 20:06:26 / cg"
    "Modified: 24.3.1996 / 18:03:27 / cg"
!

drawSideForPick:side min:minColor max:maxColor
    "draw a single side full for picking.
     Use the subCube nr as color, if its in minColor..maxColor
     (have to do this in two passes, since there are less than 9
      standard colors, and we cannot depend on the display to be able
      to provide more -- and we dont want to map more colors, since
      other views may need them)"

    |sideCorners v x0 x1 y0 y1 z0 z1 
     dxH dyH dzH dxV dyV dzV x y z sub|

    self backBuffer.
    self clearView.
    self pushMatrix.
    self setProjection.

    self backFace:true.

    v := Array new:3.

"/    1 to:6 do:[:side |
        sideCorners := sidePoints at:side.

        x0 := (sideCorners at:1) x.
        x1 := (sideCorners at:2) x.
        dxH := (x1 - x0) / 3.0.

        y0 := (sideCorners at:1) y.
        y1 := (sideCorners at:2) y.
        dyH := (y1 - y0) / 3.0.

        z0 := (sideCorners at:1) z.
        z1 := (sideCorners at:2) z.
        dzH := (z1 - z0) / 3.0.

        x0 := (sideCorners at:2) x.
        x1 := (sideCorners at:3) x.
        dxV := (x1 - x0) / 3.0.

        y0 := (sideCorners at:2) y.
        y1 := (sideCorners at:3) y.
        dyV := (y1 - y0) / 3.0.

        z0 := (sideCorners at:2) z.
        z1 := (sideCorners at:3) z.
        dzV := (z1 - z0) / 3.0.

        x := (sideCorners at:1) x.
        y := (sideCorners at:1) y.
        z := (sideCorners at:1) z.

        sub := 1.
        1 to:3 do:[:sy |

            x0 := x.
            y0 := y.
            z0 := z.

            1 to:3 do:[:sz |

                (sub between:minColor and:maxColor) ifTrue:[
                    self color:(sub - minColor + 1).
                ] ifFalse:[
                    self color:0
                ].

                self beginPolygon.
                self v3fX:x y:y z:z.
                self v3fX:x+dxH y:y+dyH z:z+dzH.
                self v3fX:x+dxH+dxV y:y+dyH+dyV z:z+dzH+dzV.
                self v3fX:x+dxV y:y+dyV z:z+dzV.

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
!

drawSidesForPick
    "draw the cubes full sides in the backBuffer, 
     but use 1..6 as side colors.
     Used for picking"

    |sideCorners|

    self backBuffer.
    self clearView.

    "
     save current rotation/translation
    "
    self pushMatrix.

    "
     rotate/translate
    "
    self setProjection.

    self backFace:true.

    1 to:6 do:[:side |
        sideCorners := sidePoints at:side.

        self color:side.

        self beginPolygon.  
        self v3f:(sideCorners at:1).
        self v3f:(sideCorners at:2).
        self v3f:(sideCorners at:3).
        self v3f:(sideCorners at:4).
        self endPolygon. 
    ].

    "
     restore rotation/translation
    "
    self popMatrix.

    "Created: 23.3.1996 / 11:00:06 / cg"
    "Modified: 24.3.1996 / 16:59:19 / cg"
!

redraw 
    "redraw the cube"


    "/
    "/ do not draw, if iconified
    "/
    realized ifTrue:[
        "/
        "/ do not draw if covered
        "/
        shown ifTrue:[
            self redrawCube.
            "
             swap buffers for next round
            "
            self swapBuffers.
        ].
    ]

    "Modified: 22.4.1996 / 23:45:47 / cg"
!

redrawCube 
    "
     clear the drawing area
    "
    self clearView.

    "
     save current rotation/translation
    "
    self pushMatrix.

    "
     rotate/translate
    "
    self setProjection.

    "
     draw it
    "
    self drawCube.

    "
     restore rotation/translation
    "
    self popMatrix.

    "Created: 23.3.1996 / 10:41:40 / cg"
    "Modified: 23.3.1996 / 13:32:00 / cg"
!

setProjection
    "recompute the projection matrix"

    self multMatrix:rotationMatrix.

    "Modified: 22.4.1996 / 23:49:41 / cg"
! !

!RubicsCubeView methodsFor:'events'!

buttonMotion:state x:x y:y
    "handle mouse pointer motion; with button possibly pressed"

    "/ this is CPU intensive; be nice to other threads ...

    Processor activeProcess withLowerPriorityDo:[
        (state bitTest:device anyButtonStateMask) ifFalse:[
            "/ no button pressed - look if the cursor should be changed
            "/ (for center subCube)

            self showCursorForX:x y:y.
        ] ifTrue:[

            self cursor:MoveEyeCursor.

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
    "Modified: 22.4.1996 / 23:46:27 / cg"
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

        self sensor altDown ifTrue:[
            cube side:whichSide sub:whichSubCube put:10.
            self redraw.
            ^ self
        ].
        self buttonPress:button side:whichSide subCube:whichSubCube.
    ] ifFalse:[
        self cursor:MoveEyeCursor.
    ].

    "Modified: 22.4.1996 / 23:46:50 / cg"
!

buttonRelease:button x:x y:y
    "handle mouse button release"

    clickX := clickY := nil.

    self showCursorForX:x y:y.

    "Created: 22.3.1996 / 20:29:35 / cg"
    "Modified: 22.4.1996 / 23:46:56 / cg"
!

keyPress:key x:x y:y
    "handle key press"

    |deltaRot|

    deltaRot := 3.0.

"/    key == #'Control_L' ifTrue:[self swapBuffers. ^ self].

    (key == #Return 
    or:[key == Character space]) ifTrue:[
        "/ for those poor single button mosue owners,
        "/ simulate button2 with cr or space
        self buttonPress:2 x:x y:y.
        ^ self
    ].

    key == $i ifTrue:[
        cube initialize.
    ].

    key == $f ifTrue:[
        self frontView
    ].

    key == $b ifTrue:[
        self backView.
    ].

    key == $x ifTrue:[
        self rotateDX:deltaRot.
    ].
    key == $X ifTrue:[
        self rotateDX:deltaRot negated
    ].
    key == $y ifTrue:[
        self rotateDY:deltaRot.
    ].
    key == $Y ifTrue:[
        self rotateDY:deltaRot negated
    ].
    key == $z ifTrue:[
        self rotateDZ:deltaRot.
    ].
    key == $Z ifTrue:[
        self rotateDZ:deltaRot negated
    ].

    key isCharacter ifTrue:[
        (key between:$1 and:$6) ifTrue:[
            cube rotate:key digitValue n:1.
        ]
    ].

    (self sensor hasKeyPressEventFor:self) ifTrue:[
        skippedKeys isNil ifTrue:[
            skippedKeys := 1
        ] ifFalse:[
            skippedKeys := skippedKeys + 1
        ].
        skippedKeys > 10 ifTrue:[
            self redraw.
            skippedKeys := 0.
        ].
        ^ self
    ].

    skippedKeys := nil.

    (key == #Shift or:[key == #'Shift_L' or:[key == #'Shift_R']]) ifTrue:[
        self showCursorForX:x y:y.
    ] ifFalse:[
        self redraw.
    ].

    "Created: 18.3.1996 / 21:57:38 / cg"
    "Modified: 22.4.1996 / 23:47:01 / cg"
!

keyRelease:key x:x y:y
    "handle key release"


"/    key == #'Control_L' ifTrue:[self redraw. ^ self].

    skippedKeys isNil ifTrue:[
        self showCursorForX:x y:y.
    ].

    "Created: 23.3.1996 / 12:49:05 / cg"
    "Modified: 22.4.1996 / 23:47:07 / cg"
!

sizeChanged:how
    "handle sizeChange of the view"

    super sizeChanged:how.
    "/ self setupViewing.

    "Created: 24.3.1996 / 16:46:52 / cg"
    "Modified: 22.4.1996 / 23:47:14 / cg"
! !

!RubicsCubeView methodsFor:'initialize / release'!

destroy
    "closing down; remove my dependency from the cube model"

    cube removeDependent:self.
    super destroy

    "Created: 23.3.1996 / 13:12:09 / cg"
    "Modified: 22.4.1996 / 23:53:30 / cg"
!

initialize
    "initialize colors, GL buffering & perspective"

    super initialize.

    type := #colorIndexDoubleBuffer.

    "
     initial rotation and translation
    "
    angleX := angleY := angleZ := 0.0.
    trans := -5.0.

    self doubleBuffer.
    self setupPoints.

    colors := IdentityDictionary new.
    colors at:1 put:Red.
    colors at:2 put:Blue.
    colors at:3 put:Green.
    colors at:4 put:White.
    colors at:5 put:Yellow.
    colors at:6 put:Magenta.

    colors at:10 put:Cyan.

    self enableMotionEvents.
    self setupCursors.

    self frontView.

    "
     RubicsCubeView open
    "

    "Created: 18.3.1996 / 21:06:23 / cg"
    "Modified: 22.4.1996 / 23:53:53 / cg"
!

realize 
    "manually redraw when realized (GL expose problem)"

    super realize.

    self setupViewing.
    self backBuffer.
    self redrawCube.
    self swapBuffers.

    "Modified: 22.4.1996 / 23:54:15 / cg"
!

setupCursors
    "setup special cursors from bitmaps"

    MoveEyeCursor := Cursor fourWay.
    RotateCCWCursor := (Cursor
                        extent: 16@16
                        sourceArray: #(
                            2r0000000000000000
                            2r0000000000000000
                            2r0000000011000000
                            2r0000001111110000
                            2r0000011100111000
                            2r0000110000001100
                            2r0001100000000110
                            2r0001100000000110
                            2r0111111000000000
                            2r0111111000000000
                            2r0011110000000000
                            2r0001100000000000
                            2r0000000000000000
                            2r0000000000000000
                            2r0000000000000000
                            2r0000000000000000)
                        maskArray: #(
                            2r0000000000000000
                            2r0000000111100000
                            2r0000011111111000
                            2r0000111111111100
                            2r0001111111111110
                            2r0011111100111111
                            2r0011110000011111
                            2r0111111000001111
                            2r1111111100001111
                            2r1111111100000000
                            2r0111111000000000
                            2r0111110000000000
                            2r0011100000000000
                            2r0000000000000000
                            2r0000000000000000
                            2r0000000000000000)
                        offset: -3@-11).

    RotateCWCursor := (Cursor
                        extent: 16@16
                        sourceArray: #(
                            2r0000000000000000
                            2r0000000000000000
                            2r0000001100000000
                            2r0000111111000000
                            2r0001110011100000
                            2r0011000000110000
                            2r0110000000011000
                            2r0110000000011000
                            2r0000000001111110
                            2r0000000001111110
                            2r0000000000111100
                            2r0000000000011000
                            2r0000000000000000
                            2r0000000000000000
                            2r0000000000000000
                            2r0000000000000000)
                        maskArray: #(
                            2r0000000000000000
                            2r0000011110000000
                            2r0001111111100000
                            2r0011111111110000
                            2r0111111111111000
                            2r1111110011111100
                            2r1111100000111100
                            2r1111000001111110
                            2r1111000011111111
                            2r0000000011111111
                            2r0000000001111110
                            2r0000000000111110
                            2r0000000000011100
                            2r0000000000000000
                            2r0000000000000000
                            2r0000000000000000)
                        offset: -11@-11).

    "Created: 23.3.1996 / 11:48:03 / cg"
    "Modified: 22.4.1996 / 23:54:27 / cg"
!

setupPoints
    "precompute the cubes corner points,
     and a collection containing the corner points of the sides.
     The cubes coordinates are normalizes around the origin.
    "

    "
     setup the 8 corner points:


            p5------p6
           /|      /|
          / |     / |
         /  |    /  |
        p1------p2  |
        |   |   |   |
        |   p8--|---p7
        |  /    |  /
        | /     | /
        |/      |/
        p4------p3
    "

    points := Array new:8.
    points at:1 put:(GLPoint3D x:-1.0 y:-1.0 z: 1.0).   "front"
    points at:2 put:(GLPoint3D x: 1.0 y:-1.0 z: 1.0).   
    points at:3 put:(GLPoint3D x: 1.0 y: 1.0 z: 1.0).   
    points at:4 put:(GLPoint3D x:-1.0 y: 1.0 z: 1.0).   
    points at:5 put:(GLPoint3D x:-1.0 y:-1.0 z:-1.0).   "rear"
    points at:6 put:(GLPoint3D x: 1.0 y:-1.0 z:-1.0).   
    points at:7 put:(GLPoint3D x: 1.0 y: 1.0 z:-1.0).   
    points at:8 put:(GLPoint3D x:-1.0 y: 1.0 z:-1.0).

"
            p5------p6             *-------*
           /|      /|             /|  S3  /|
          / |     / |            / |     / |
         /  |    /  |           /  |S6  /  |
        p1------p2  |          *-------*   |
        |   |   |   |          | 4 |   | 2 |
        |   p8--|---p7         |S  *---|S--*
        |  /    |  /           |  /S1  |  /
        | /     | /            | /   S5| /      S1:front S2:right S3:back S4:left
        |/      |/             |/      |/       S5:top S6:bottom
        p4------p3             *-------*  
"
    sidePoints := Array new:6.
    sidePoints at:1 put:(Array with:(points at:1) with:(points at:2) with:(points at:3) with:(points at:4)).
    sidePoints at:2 put:(Array with:(points at:2) with:(points at:6) with:(points at:7) with:(points at:3)).
    sidePoints at:3 put:(Array with:(points at:6) with:(points at:5) with:(points at:8) with:(points at:7)).
    sidePoints at:4 put:(Array with:(points at:1) with:(points at:4) with:(points at:8) with:(points at:5)).
    sidePoints at:5 put:(Array with:(points at:3) with:(points at:7) with:(points at:8) with:(points at:4)).
    sidePoints at:6 put:(Array with:(points at:1) with:(points at:5) with:(points at:6) with:(points at:2)).

    "Created: 18.3.1996 / 21:08:04 / cg"
    "Modified: 22.4.1996 / 23:47:35 / cg"
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

    "Created: 18.3.1996 / 21:46:55 / cg"
    "Modified: 22.4.1996 / 23:54:43 / cg"
! !

!RubicsCubeView methodsFor:'private'!

findSideOfX:x y:y
    "given x/y, return which side that is"

    |pixel|

    "/ draw each of the cubes sides with the side nr as ``color''
    "/ into the backBuffer, see which ``color'' we find at x/y for the sideNr

    self drawSidesForPick.

    AnimateSearch == true ifTrue:[
        self swapBuffers.
        self drawSidesForPick.
        Delay waitForSeconds:0.5.    
    ].

    pixel := self pixelAtX:x y:y.

    AnimateSearch == true ifTrue:[
        self redraw.
    ].

    (pixel isNil or:[pixel == Black]) ifTrue:[
        ^ nil
    ].
    (pixel between:1 and:6) ifFalse:[
        ^ nil
    ].

    ^ pixel

    "see how this works, by setting AnimateSearch to true.

     AnimateSearch := true
     AnimateSearch := false
    "

    "Created: 22.3.1996 / 22:31:53 / cg"
    "Modified: 24.3.1996 / 18:15:06 / cg"
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
        self drawSideForPick:side min:8 max:9.

        AnimateSearch == true ifTrue:[
            self swapBuffers.
            self drawSideForPick:side min:8 max:9.
            Delay waitForSeconds:0.5.    
        ].

        pixel := self pixelAtX:x y:y.
        (pixel notNil and:[pixel ~~ Black]) ifTrue:[
            pixel := pixel + 7
        ]
    ].

    AnimateSearch == true ifTrue:[
        self redraw.
    ].

    pixel == Black ifTrue:[
        ^ nil
    ].
    ^ pixel.

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

!RubicsCubeView methodsFor:'rotating'!

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

    "/ to have the rotation direction follow the cursor,
    "/ limit the rotation here

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

    "/ to have the rotation direction follow the cursor,
    "/ limit the rotation here

    angleZ < -90 ifTrue:[angleZ := -90].
    angleZ > 90 ifTrue:[angleZ := 90].

    self pushMatrix.

    self loadIdentityMatrix.
    self rotateX:angleX y:angleY z:angleZ.
    self getMatrix:rotationMatrix.

    self popMatrix.

    "Modified: 22.4.1996 / 23:51:45 / cg"
! !

!RubicsCubeView methodsFor:'user interaction'!

buttonPress:button side:side subCube:subCube
    "clicked on some subCube - if its a centerPiece,
     rotate that plane."

    |n|

"/    'button: ' print. button printNL.
"/    'side: ' print. side printNL.
"/    'subCube: ' print. subCube printNL.

    clickSide := side.
    clickSubCube := subCube.

    "/ clicking on the middle subCube (5)
    "/ rotates ...

    subCube == 5 ifTrue:[
        self sensor shiftDown ifTrue:[
            n := 3.     "/ counterClockWise
        ] ifFalse:[
            n := 1.     "/ clockWise
        ].
        cube rotate:side n:n.
    ].

    "Created: 22.3.1996 / 20:21:32 / cg"
    "Modified: 22.4.1996 / 23:53:05 / cg"
!

showCursorForX:x y:y
    "determine where the mouse-pointer is, and change the cursor
     according the position"

    |whichSide whichSubCube|

    whichSide := self findSideOfX:x y:y.
    whichSide notNil ifTrue:[
        whichSubCube := self findSubCubeInSide:whichSide x:x y:y.

        whichSubCube == 5 ifTrue:[  "/ middle one
            self sensor shiftDown ifTrue:[
                self cursor:RotateCCWCursor
            ] ifFalse:[
                self cursor:RotateCWCursor
            ].
            ^ self
        ].
    ].
    ^ self cursor:MoveEyeCursor.

    "Created: 23.3.1996 / 11:42:20 / cg"
    "Modified: 22.4.1996 / 23:52:27 / cg"
! !

!RubicsCubeView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/RubicsCubeView.st,v 1.29 2016-01-21 18:05:59 cg Exp $'
! !

