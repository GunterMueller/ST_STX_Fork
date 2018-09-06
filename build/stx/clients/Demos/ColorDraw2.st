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

ColorDrawDemo subclass:#ColorDrawDemo2
	instanceVariableNames:'brushPanel brushCursors brushPatterns selectedBrushIndexHolder
		selectedOpIndexHolder brushActions'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

ColorDrawDemo2 comment:'
To demonstrate, how easy it is to add features in subclasses,
this class adds brushes to the DrawDemo.

 start with:
       ColorDrawDemo2 open

'
!

!ColorDrawDemo2 class methodsFor:'documentation'!

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
 This demo adds some more functionality (brushes) to the basic
 ColorDrawDemo.

 [author:]
        Claus Gittinger

 [start with:]
        ColorDrawDemo2 open

 [see also:]
        ColorDrawDemo ColorDrawDemo3
        DrawTool
"



! !

!ColorDrawDemo2 methodsFor:'startup'!

addBrushButtonWithBrush:aBrushForm
    "add a brushButton for a brush"

    |button sz crsr action|

    crsr := Cursor 
                sourceForm:aBrushForm 
                maskForm:aBrushForm 
                hotSpot:aBrushForm center.

"/    sz := aBrushForm width max:(aBrushForm height).
"/    sz := sz + 2.
    sz := 24. "/ (topView device horizontalPixelPerMillimeter * 7) truncated.

    button := Toggle "RadioButton" in:brushPanel.
    button showLamp:false; onLevel:-2.
    button form:aBrushForm.
    button extent:sz @ sz.

    button action:(action := [self selectBrush:aBrushForm cursor:crsr]).
    brushActions add:action.

    ^ button

    "Created: / 1.4.1997 / 19:19:47 / cg"
    "Modified: / 28.9.1998 / 11:30:01 / cg"
!

addBrushButtonWithRoundBrush:width
    "add a brushButton for a width-pixel-brush"

    |form button sz crsr action|

    sz := 24. "/ (topView device horizontalPixelPerMillimeter * 7) truncated.
    form := Form width:sz height:sz.
    form paint:(Color colorId:0).
form fillRectangleX:0 y:0 width:sz height:sz.
"/    form clear.
    form paint:(Color colorId:1).
    form fillCircle:(form center) radius:(width // 2).

    crsr := Cursor 
                sourceForm:form 
                maskForm:form 
                hotSpot:form center.

    button := Toggle "RadioButton" in:brushPanel.
    button showLamp:false; onLevel:-2.
    button form:form.
    button extent:sz @ sz.
    button action:(action := [self selectRoundBrushWidth:width cursor:crsr]).
    brushActions add:action.
    ^ button

    "Created: / 1.4.1997 / 21:01:35 / cg"
    "Modified: / 28.9.1998 / 11:29:39 / cg"
!

brushPatterns
    ^ #(
            (
              2r0000000000000000
              2r0000000000000110
              2r0000000000001110
              2r0000000000011100
              2r0000000000111000
              2r0000000001110000
              2r0000000011100000
              2r0000000111000000
              2r0000001110000000
              2r0000011100000000
              2r0000111000000000
              2r0001110000000000
              2r0011100000000000
              2r0111000000000000
              2r0110000000000000
              2r0000000000000000
            )

            (
              2r0000000000000000
              2r0110000000000000
              2r0111000000000000
              2r0011100000000000
              2r0001110000000000
              2r0000111000000000
              2r0000011100000000
              2r0000001110000000
              2r0000000111000000
              2r0000000011100000
              2r0000000001110000
              2r0000000000111000
              2r0000000000011100
              2r0000000000001110
              2r0000000000000110
              2r0000000000000000
            )

            (
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r1111111111111111
              2r1111111111111111
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
            )

            (
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
              2r0000000110000000
            )

            (
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000001111000000
              2r0000001111000000
              2r0000001111000000
              2r0000001111000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
            )

            (
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000111111110000
              2r0000111111110000
              2r0000111111110000
              2r0000111111110000
              2r0000111111110000
              2r0000111111110000
              2r0000111111110000
              2r0000111111110000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
            )

            (
              2r0000000000000000
              2r0000000000000000
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0011111111111100
              2r0000000000000000
              2r0000000000000000
            )

            (
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
            )

            (
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000010000000
              2r0000000111000000
              2r0000001111100000
              2r0000011111110000
              2r0000111111111000
              2r0001111111111100
              2r0011111111111110
              2r0111111111111111
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
              2r0000000000000000
            )

       )

    "Created: 1.4.1997 / 20:59:39 / cg"
    "Modified: 3.4.1997 / 00:17:02 / cg"
!

eraserCursorPattern
    ^ 
            #(
              2r1111111111111111
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1000000000000001
              2r1111111111111111
            )

    "Created: 10.4.1997 / 15:33:06 / cg"
!

fillCursor
    ^ #(
            #(
              2r0000000000000000
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0111111111111110
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0000000100000000
              2r0000000000000000
            )

            #(
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
              2r1111111111111111
              2r1111111111111111
              2r1111111111111111
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
              2r0000001110000000
            )
        )

    "Created: 10.4.1997 / 15:33:06 / cg"
!

setupViews
    "setup the drawing area and create brush buttons"

    |f t szToggle cursorForm sprayPanel sprayCursor eraserBrush eraserMask 
     fillBrush fillMask opPanel
     selectedSprayGroup t1 t2|

    super setupViews.

    "otherwise things wont look too good"
    drawView capStyle:#round.

    opPanel := PanelView
                        origin:(0.0 @ 0.0)
                        extent:(0.2 @ 0.1)
                            in:topView.
    opPanel borderWidth:0.
    colorPanel origin:(0.0 @ 0.1).

    brushPanel := PanelView
                        origin:(0.0 @ 0.5)
                        extent:(0.2 @ 0.4)
                            in:topView.
    brushPanel borderWidth:0.
    brushActions := OrderedCollection new.

    sprayPanel := PanelView
                        origin:(0.0 @ 0.5)
                        extent:(0.2 @ 0.4)
                            in:topView.
    sprayPanel borderWidth:0.

    selectedBrushIndexHolder := RadioButtonGroup new.
    2 to:16 by:2 do:[:i |
        selectedBrushIndexHolder add:(self addBrushButtonWithRoundBrush:i).
    ].

    self brushPatterns do:[:aBrushPattern |
        f := Form 
                width:16 
                height:16
                fromArray:aBrushPattern.
        f offset:(f extent // 2).

        selectedBrushIndexHolder add:(self addBrushButtonWithBrush:f).
    ].


    selectedOpIndexHolder := RadioButtonGroup new.

    t := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/pencil_yellow_masked.xpm' 
                                 inPackage:'stx:goodies/bitmaps') 
                action:[:val | |selectedBrushIndex|

                               val ifTrue:[
                                   selectedBrushIndex := selectedBrushIndexHolder value.
                                   selectedBrushIndex isNil ifTrue:[
                                        selectedBrushIndex := 1.
                                        selectedBrushIndexHolder value:1.
                                   ].
                                   (brushActions at:selectedBrushIndex) value.
                                   paintColor := currentColor.
                                   spray := fill := false.
                                   sprayPanel beInvisible.
                                   colorPanel beVisible.
                                   brushPanel beVisible.
                                   brushPanel raise.     
                               ] 
                       ]
                in:opPanel.

    szToggle := (topView device horizontalPixelPerMillimeter * 12) truncated.
    t showLamp:false; onLevel:-2.
    t extent:szToggle@szToggle.
    selectedOpIndexHolder add:t. 

    cursorForm := Form width:16 height:16.
    cursorForm clear.
    cursorForm paint:(Color colorId:1).
    cursorForm fillCircle:(cursorForm center) radius:(8 // 2).
    sprayCursor := Cursor sourceForm:cursorForm 
                          maskForm:cursorForm 
                          hotSpot:cursorForm center.
    t := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/sprayOpRed.xpm' inPackage:'stx:goodies/bitmaps')  
                action:[:val | val ifTrue:[
                                   drawView cursor:sprayCursor
                               ] ifFalse:[
                                   drawView cursor:Cursor normal
                               ].
                               paintColor := currentColor.
                               spraySpot isNil ifTrue:[
                                   spraySpot := 16.
                                   selectedSprayGroup value:2.
                               ].
                               spray := true.
                               fill := false.
                               brushPanel beInvisible. 
                               colorPanel beVisible.
                               sprayPanel beVisible.
                               sprayPanel raise.
                       ]
                in:opPanel.

    t showLamp:false; onLevel:-2.
    t extent:szToggle@szToggle.
    selectedOpIndexHolder add:t. 

    selectedSprayGroup := RadioButtonGroup new.

    t := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/sprayOpRedThin.xpm' inPackage:'stx:goodies/bitmaps') 
                action:[:val | val ifTrue:[
                                   drawView cursor:sprayCursor
                               ] ifFalse:[
                                   drawView cursor:Cursor normal
                               ].
                               paintColor := currentColor.
                               spray := true.
                               fill := false.
                               spraySpot := 8.
                       ]
                in:sprayPanel.

    t showLamp:false; onLevel:-2.
    t extent:szToggle@szToggle.
    selectedSprayGroup add:t. 

    t := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/sprayOpRed.xpm' inPackage:'stx:goodies/bitmaps')  
                action:[:val | val ifTrue:[
                                   drawView cursor:sprayCursor
                               ] ifFalse:[
                                   drawView cursor:Cursor normal
                               ].
                               paintColor := currentColor.
                               spraySpot := 16.
                               spray := true.
                               fill := false.
                       ]
                in:sprayPanel.

    t showLamp:false; onLevel:-2.
    t extent:szToggle@szToggle.
    selectedSprayGroup add:t. 


    t := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/sprayOpRedWide.xpm' inPackage:'stx:goodies/bitmaps') 
                action:[:val | val ifTrue:[
                                   drawView cursor:sprayCursor
                               ] ifFalse:[
                                   drawView cursor:Cursor normal
                               ].
                               paintColor := currentColor.
                               spray := true.
                               fill := false.
                               spraySpot := 32.
                       ]
                in:sprayPanel.

    t showLamp:false; onLevel:-2.
    t extent:szToggle@szToggle.
    selectedSprayGroup add:t. 

    t1 := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/sprayOpUniform.xpm' inPackage:'stx:goodies/bitmaps') 
                action:[:val | val ifTrue:[sprayDistribution := Distributions::UniformDistribution.
                                           t2 turnOff]]
                in:sprayPanel.

    t1 showLamp:false; onLevel:-2.
    t1 extent:szToggle@szToggle.

    t2 := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/sprayOpNormal.xpm' inPackage:'stx:goodies/bitmaps') 
                action:[:val | val ifTrue:[sprayDistribution := Distributions::NormalDistribution.
                                           t1 turnOff]]
                in:sprayPanel.

    t2 showLamp:false; onLevel:-2.
    t2 extent:szToggle@szToggle.

    eraserBrush := Form 
            extent:16@16
            fromArray:(self eraserCursorPattern)
            onDevice:topView device.
    eraserBrush offset:8@8.
    eraserMask := Form extent:16@16 onDevice:topView device.
    eraserMask fill:(Color colorId:1).

    t := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/eraser.xpm' inPackage:'stx:goodies/bitmaps') 
                action:[:val | val ifTrue:[
                                   drawView cursor:(Cursor 
                                                        sourceForm:eraserBrush
                                                        maskForm:eraserMask 
                                                        hotSpot:eraserBrush center).        
                                   self brush:eraserBrush.
                                   paintColor := Color white.
                               ] ifFalse:[
                                   paintColor := currentColor
                               ].
                               drawView paint:paintColor.
                               spray := fill := false.
                               sprayPanel beInvisible.
                               colorPanel beInvisible.
                               brushPanel beInvisible.
                       ]
                in:opPanel.

    t showLamp:false; onLevel:-2.
    t extent:szToggle@szToggle.
    selectedOpIndexHolder add:t. 

    fillBrush := Form 
            extent:16@16
            fromArray:(self fillCursor first)
            onDevice:topView device.
    fillBrush offset:8@8.
    fillMask := Form extent:16@16 fromArray:(self fillCursor second) onDevice:topView device.
    fillMask fill:(Color colorId:1).

    t := Toggle "RadioButton" 
                label:(Smalltalk imageFromFileNamed:'xpmBitmaps/misc_tools/fillOp.xpm' 
                                 inPackage:'stx:goodies/bitmaps') 
                action:[:val | 
                               val ifTrue:[
                                   drawView cursor:(Cursor 
                                                        sourceForm:fillBrush
                                                        maskForm:fillMask 
                                                        hotSpot:fillBrush center).        
                                   "(brushActions at:selectedBrushIndex) value."
                                   paintColor := currentColor.
                                   spray := false.
                                   fill := true.
                                   sprayPanel beInvisible.
                                   colorPanel beVisible.
                                   brushPanel beInvisible.
                               ] 
                       ]
                in:opPanel.

    szToggle := (topView device horizontalPixelPerMillimeter * 12) truncated.
    t showLamp:false; onLevel:-2.
    t extent:szToggle@szToggle.
    selectedOpIndexHolder add:t. 

    selectedOpIndexHolder value:nil.
    sprayPanel beInvisible.
    colorPanel beInvisible.
    brushPanel beInvisible.

    "
     ColorDrawDemo2 open
    "

    "Modified: / 28.9.1998 / 11:24:56 / cg"
    "Modified: / 3.8.1999 / 10:18:46 / stefan"
! !

!ColorDrawDemo2 methodsFor:'user actions'!

selectBrush:aBrush cursor:aCursor
    drawView cursor:aCursor.

    paintColor := currentColor.
    spray := false.
    self brush:aBrush.

    "Created: 10.4.1997 / 15:12:33 / cg"
    "Modified: 10.4.1997 / 15:16:34 / cg"
!

selectRoundBrushWidth:width cursor:aCursor
    drawView cursor:aCursor.

    currentLineWidth := width.
    currentBrush := nil.
    paintColor := currentColor.
    spray := false.
    drawView lineWidth:width

    "Created: 10.4.1997 / 15:14:30 / cg"
! !

!ColorDrawDemo2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ColorDraw2.st,v 1.26 2013-07-09 21:15:18 cg Exp $'
! !

