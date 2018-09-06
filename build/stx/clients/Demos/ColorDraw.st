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

Object subclass:#ColorDrawDemo
	instanceVariableNames:'topView drawView colorPanel buttonPanel2 lastPoint currentColor
		currentLineWidth currentBrush spray spraySpot sprayProcess
		sprayDistribution paintColor selectedColorIndexHolder fill'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!ColorDrawDemo class methodsFor:'documentation'!

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
 This demo was inspired by a similar demonstration program from
 a motif manual.

 Notice, that we could have defined a subclass of View to do the drawing.

 However, for didactic reasons, this example uses event delegation: 
    every event to the drawView (which is some generic, dump view) 
    is forwarded to myself and I do the actual drawing in the view.

 I could have been defined as a subclass of ApplicationModel, (and a real app
 would be) - however, this is not a must.
 See subclass ColorDrawDemo3, which is in heavy use by my doughter ...

 [author:]
        Claus Gittinger

 [start with:]
        ColorDrawDemo open

 [see also:]
        ColorDrawDemo2 ColorDrawDemo3
        DrawTool
"
! !

!ColorDrawDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:39:10 / cg"
!

open
    "create an instance and open the view"

    self new open

    "
     ColorDrawDemo open
    "

    "Modified: 10.4.1997 / 15:23:45 / cg"
! !

!ColorDrawDemo methodsFor:'accessing'!

brush:aForm
    currentBrush := aForm

    "Created: 1.4.1997 / 19:27:18 / cg"
! !

!ColorDrawDemo methodsFor:'drawView events'!

buttonMotion:buttonState x:x y:y view:aView
    "buttonMotion delegated from the drawView"

    buttonState ~~ 0 ifTrue:[
        (spray not and:[fill not]) ifTrue:[
            lastPoint notNil ifTrue:[
                drawView paint:paintColor.
                currentBrush notNil ifTrue:[
                    drawView displayLineFromX:lastPoint x y:lastPoint y
                                          toX:x y:y
                                       brush:currentBrush
                ] ifFalse:[
                    drawView displayLineFromX:lastPoint x y:lastPoint y
                                          toX:x y:y
                ]
            ].
        ].
        lastPoint := x @ y
    ].

    "Modified: 4.4.1997 / 20:30:30 / cg"
!

buttonPress:button x:x y:y view:aView
    "buttonPress delegated from the drawView"

    lastPoint := x @ y.
    drawView paint:paintColor.
    spray ifTrue:[
        self startSpray.
    ] ifFalse:[
        fill ifTrue:[
            self doFill
        ] ifFalse:[
            "/ action when moving
        ]
    ]

    "Modified: 4.4.1997 / 20:30:35 / cg"
!

buttonRelease:button x:x y:y view:aView
    "buttonRelease stops spray, if any"

    spray ifTrue:[
        self stopSpray.
    ]

    "Created: 1.4.1997 / 21:58:19 / cg"
!

delegatesTo:someView
    ^ false

    "Created: / 5.8.1999 / 13:27:29 / cg"
!

doFill
    |img|

    img := drawView canvas asImage.
    drawView withWaitCursorDo:[
        img floodFillAt:lastPoint withColor:paintColor.
        drawView displayForm:img.
    ].
!

handlesButtonMotion:state inView:aView
    "yes - I handle buttonMotion events"

    ^ true

    "Modified: 8.5.1996 / 22:28:07 / cg"
!

handlesButtonPress:button inView:aView
    "yes - I handle buttonPress events"

    ^ true

    "Modified: 8.5.1996 / 22:28:04 / cg"
!

handlesButtonRelease:button inView:aView
    "yes - I handle buttonRelease events"

    ^ true

    "Modified: 8.5.1996 / 22:28:04 / cg"
    "Created: 1.4.1997 / 22:00:06 / cg"
!

startNormalDistributedSpray
    |norm|

    "/ the distance is a normalDistribution
    norm := Distributions::NormalDistribution mean:0 deviation:0.5.
    self startSpray:norm
!

startSpray
    sprayDistribution == Distributions::UniformDistribution ifTrue:[
        self startUniformDistributedSpray
    ] ifFalse:[
        self startNormalDistributedSpray
    ]
!

startSpray:distanceDistribution
    spraySpot isNil ifTrue:[
        spraySpot := 16
    ].

    sprayProcess isNil ifTrue:[
        sprayProcess := [
                |p rnd sprayPoint dly angle x y dist|

                rnd := Random new.
                dly := Delay forMilliseconds:5.
                [true] whileTrue:[
                    10 timesRepeat:[
                        p := lastPoint.
                        p notNil ifTrue:[
                            angle := rnd next * 359.999.    "/ the angle is uniformly ditributed
                            dist := distanceDistribution next * spraySpot.  
                            sprayPoint := Point r:dist degrees:angle.

                            x := p x + sprayPoint x truncated.
                            y := p y + sprayPoint y truncated.
                            drawView displayPointX:x y:y.
                        ].
                    ].
                    dly wait.
                ].
        ] fork.
    ]

    "Modified: 10.4.1997 / 15:21:24 / cg"
!

startUniformDistributedSpray
    |uniform|

    "/ the distance is a normalDistribution
    uniform := Distributions::UniformDistribution from:-1 to:1.
    self startSpray:uniform
!

stopSpray
    sprayProcess notNil ifTrue:[
        sprayProcess terminate.
        sprayProcess := nil
    ].

    "Created: 1.4.1997 / 22:04:16 / cg"
! !

!ColorDrawDemo methodsFor:'startup'!

addColorButtonFor:colorName to:aPanel
    "add a button to change the color"

    |butt form sz thisColor|

    sz := (aPanel horizontalPixelPerMillimeter:5) truncated.
    butt := Toggle "RadioButton" in:aPanel.
    butt showLamp:false.
    form := Form width:sz height:sz depth:(aPanel device depth).
    thisColor := (Color name:colorName).
    form paint:thisColor.
    form fillRectangleX:0 y:0 width:sz height:sz.
    butt form:form.
    butt offLevel:2; onLevel:-2.
    butt extent:((sz + 8) @ (sz + 8)).
    butt action:[currentColor := paintColor := thisColor. drawView paint:thisColor].
    ^ butt

    "Modified: / 26.9.1998 / 02:25:57 / cg"
!

open
    "open my topView"

    self setupViews.
    topView open.

    "Modified: 8.5.1996 / 22:27:16 / cg"
!

setupViews
    "setup the color-button panel, the action buttons and the drawing subview"

    |quitButton clearButton infoButton|

    Distributions::NormalDistribution isNil ifTrue:[
        Smalltalk loadPackage:'stx:goodies/math/distributions' asAutoloaded:true
    ].

    spray := fill := false.
    Distributions::NormalDistribution autoload.
    Distributions::UniformDistribution autoload.

    topView := StandardSystemView new.
    topView label:'ColorDrawDemo'.

    colorPanel := PanelView
                        origin:(0.0 @ 0.0) 
                        extent:(0.2 @ 0.8) 
                        in:topView.
    colorPanel borderWidth:0.

    buttonPanel2 := PanelView
                        origin:(0.0 @ 0.9) 
                        extent:(1.0 @ 0.1) 
                        in:topView.

    drawView := View 
                    origin:0.2 @ 0.0 
                    corner:1.0 @ 1.0 
                    in:topView.
    drawView viewBackground:(Color white).

    "catch its events ..."
    drawView delegate:self.
    drawView level:-1.

    colorPanel space:4.

    selectedColorIndexHolder := RadioButtonGroup new.

    #('Black' 'Red' 'Green' 'Blue' 'White' 'Navy' 'Orange'
      'Yellow' 'Pink' 'Magenta' 'Cyan' 'Brown' 'Grey' 
    ) keysAndValuesDo:[:idx :colorName |
        selectedColorIndexHolder add:(self addColorButtonFor:colorName to:colorPanel).
    ].

    infoButton := Button label:'info' 
                         action:[self showAbout]
                             in:buttonPanel2.

    quitButton := Button label:'quit' 
                        action:[topView destroy]
                            in:buttonPanel2.

    clearButton := Button label:'clear' 
                         action:[drawView fill:Color white]
                             in:buttonPanel2.

    ^ self

    "Modified: / 01-08-2013 / 14:03:38 / cg"
!

showAbout
    |box|

    box := AboutBox new.
    box label:'About ColorDrawDemo ...'.
    box title:'ColorDrawDemo 

A little drawing program which I wrote for my daughter,
1994 when she was 2 years old (aka: a long time ago).

Notice: this is another application which was written very early
for and with Smalltalk/X. Its UI is kept very simply by purpose,
as it was written for a kid - not for programmers.

Have fun.
'.
        box show

    "Created: / 01-08-2013 / 14:10:01 / cg"
! !

!ColorDrawDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ColorDraw.st,v 1.27 2013-08-01 12:19:19 cg Exp $'
! !

