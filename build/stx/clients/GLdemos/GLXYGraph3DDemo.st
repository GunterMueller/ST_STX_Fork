"
 COPYRIGHT (c) 1998 by eXept Software AG
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

"{ NameSpace: CodingExamples_GUI }"

ApplicationModel subclass:#GLXYGraph3DDemo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-GUI-3D'
!

!GLXYGraph3DDemo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    A simple example, showing how the GLXYGraph widget can be
    incorporated into a GUI-Builder application.
    Especially, have a look at how all of the parameters and
    look is controlled by channels (i.e. valueHolders).

    [author:]
        Claus Gittinger

    [see also:]
        Demos::GLXYGraph
        Demos::GLXYGraphSpec
"
! !

!GLXYGraph3DDemo class methodsFor:'image specs'!

boxIconSpec
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self boxImageSpec inspect
     ImageEditor openOnClass:self andSelector:#boxImageSpec
    "

    <resource: #image>

    ^Icon
        constantNamed:#'CodingExamples_GUI::GLXYGraph3DDemo boxImageSpec'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'**)UUZ@@%UVIUVUU!!%UYUXVUT%VEYUVU!!U%UYXUV**"UU$@HX@HUVD!!FQU!!BU%EXPIYTVEP&UQ!!UR%UHUUJ**@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0 0 255 0]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'?0C@ JC@$JBH$HRH (RA?/>BPTH!!H!!DRBP(EA LB@_8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
!

normalsIconSpec
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self normalsIconSpec inspect
     ImageEditor openOnClass:self andSelector:#normalsIconSpec
    "

    <resource: #image>

    ^Icon
        constantNamed:#'CodingExamples_GUI::GLXYGraph3DDemo normalsIconSpec'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'******@@EZ&IUPV%!!%T@%XVU@EVEYQDU!!U$PQXUV@@B@@H@@ @@ THADRAB@EEH@* QT * @UR*%PEU*%U@@* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; colorMapFromArray:#[0 0 0 128 0 0 0 128 0 0 255 0]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1 )); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'???@C*@L$@"H@HP@  BA@HB@ DB@HH@P<@'' A<@G @<@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@a') ; yourself); yourself]
! !

!GLXYGraph3DDemo class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:CodingExamples_GUI::GLXYGraph3DDemo andSelector:#windowSpec
     CodingExamples_GUI::GLXYGraph3DDemo new openInterface:#windowSpec
     CodingExamples_GUI::GLXYGraph3DDemo open
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpec
        #window: 
       #(#WindowSpec
          #label: 'GLXYGraph Application'
          #name: 'GLXYGraph Application'
          #min: #(#Point 10 10)
          #max: #(#Point 1280 1024)
          #bounds: #(#Rectangle 6 29 456 479)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#'Demos::GLXYGraphSpec'
              #name: 'graphView'
              #layout: #(#LayoutFrame 20 0.0 0 0.0 0 1.0 -20 1)
              #level: -3
              #model: #graphHolder
              #menu: #graphMenu
              #xMin: -2
              #xMax: 2
              #yMin: -2
              #yMax: 2
              #deltaX: 0.1
              #deltaY: 0.1
              #rotX: #xRot
              #rotY: #yRot
              #rotZ: #zRot
              #transY: -0.5
              #transZ: #zTrans
              #drawNormals: #showNormals
              #drawBox: #showBox
              #boxColor: #(#Color 49.9992 100.0 49.9992)
            )
           #(#ThumbWheelSpec
              #name: 'xThumbWheel'
              #layout: #(#LayoutFrame 2 0 -120 1.0 20 0 -20 1.0)
              #model: #xRot
              #step: 1
              #endlessRotation: true
            )
           #(#ThumbWheelSpec
              #name: 'yThumbWheel'
              #layout: #(#LayoutFrame 37 0 -20 1.0 137 0 0 1.0)
              #model: #yRot
              #orientation: #horizontal
              #step: 1
              #endlessRotation: true
            )
           #(#ThumbWheelSpec
              #name: 'zThumbWheel'
              #layout: #(#LayoutFrame -100 1 -20 1 0 1 0 1)
              #model: #zRot
              #orientation: #horizontal
              #step: 1
              #endlessRotation: true
            )
           #(#LabelSpec
              #label: 'x'
              #name: 'xLabel'
              #layout: #(#LayoutFrame 5 0 -140 1.0 19 0 -120 1.0)
              #translateLabel: true
              #resizeForLabel: true
              #adjust: #left
            )
           #(#LabelSpec
              #label: 'y'
              #name: 'yLabel'
              #layout: #(#LayoutFrame 21 0 -20 1.0 35 0 0 1.0)
              #translateLabel: true
              #resizeForLabel: true
              #adjust: #left
            )
           #(#LabelSpec
              #label: 'z'
              #name: 'zLabel'
              #layout: #(#LayoutFrame -120 1 -20 1 -100 1 0 1)
              #translateLabel: true
              #resizeForLabel: true
              #adjust: #left
            )
           #(#LabelSpec
              #label: 'boxIconSpec'
              #name: 'boxLabel'
              #layout: #(#LayoutFrame 0 0 3 0 20 0 21 0)
              #hasCharacterOrientedLabel: false
            )
           #(#CheckToggleSpec
              #name: 'boxToggle'
              #layout: #(#LayoutFrame 1 0 23 0 19 0 41 0)
              #model: #showBox
              #isTriggerOnDown: true
              #showLamp: false
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#LabelSpec
              #label: 'normalsIconSpec'
              #name: 'normalsLabel'
              #layout: #(#LayoutFrame 0 0 49 0 20 0 67 0)
              #hasCharacterOrientedLabel: false
            )
           #(#CheckToggleSpec
              #name: 'normalsToggle'
              #layout: #(#LayoutFrame 1 0 69 0 19 0 87 0)
              #model: #showNormals
              #isTriggerOnDown: true
              #showLamp: false
              #lampColor: #(#Color 100.0 100.0 0.0)
            )
           #(#SliderSpec
              #name: 'zTransSlider'
              #layout: #(#LayoutFrame 3 0 89 0 17 0 -145 1)
              #model: #zTrans
              #start: -10
              #stop: 1
            )
           )
         
        )
      )
! !

!GLXYGraph3DDemo class methodsFor:'menu specs'!

graphMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:CodingExamples_GUI::GLXYGraph3DDemo andSelector:#graphMenu
     (Menu new fromLiteralArrayEncoding:(CodingExamples_GUI::GLXYGraph3DDemo graphMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(#Menu
        #(
         #(#MenuItem
            #label: 'sin(x) * sin(y)'
            #translateLabel: true
            #value: #defineGraph:
            #argument: #('x sin * y sin' -2 2 -2 2)
          )
         #(#MenuItem
            #label: 'sin(x*y)'
            #translateLabel: true
            #value: #defineGraph:
            #argument: #('(x*y) sin' -2 2 -2 2)
          )
         )
        nil
        nil
      )
! !

!GLXYGraph3DDemo methodsFor:'aspects'!

function 
    ^ [:x :y | x sin * y sin].

    "Created: / 5.6.1998 / 04:23:49 / cg"
!

graph
    ^ self graphHolder
!

graphHolder
    |holder|

    (holder := builder bindingAt:#graph) isNil ifTrue:[
        builder aspectAt:#graph put:(holder := self function asValue).
    ].
    ^ holder

    "Created: / 5.6.1998 / 04:07:25 / cg"
    "Modified: / 5.6.1998 / 04:23:58 / cg"
!

showBox
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#showBox) isNil ifTrue:[
        builder aspectAt:#showBox put:(holder :=  true asValue).
    ].
    ^ holder

    "Created: / 5.6.1998 / 01:48:03 / cg"
!

showNormals
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#showNormals) isNil ifTrue:[
        builder aspectAt:#showNormals put:(holder :=  true asValue).
    ].
    ^ holder

    "Created: / 5.6.1998 / 01:48:03 / cg"
!

xRot
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#xRot) isNil ifTrue:[
        builder aspectAt:#xRot put:(holder :=  115 asValue).
    ].
    ^ holder

    "Created: / 5.6.1998 / 02:44:05 / cg"
!

yRot
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#yRot) isNil ifTrue:[
        builder aspectAt:#yRot put:(holder :=  0.0 asValue).
    ].
    ^ holder

    "Created: / 5.6.1998 / 02:44:05 / cg"
!

zRot
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#zRot) isNil ifTrue:[
        builder aspectAt:#zRot put:(holder :=  45 asValue).
    ].
    ^ holder

    "Created: / 5.6.1998 / 02:44:05 / cg"
!

zTrans
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    |holder|

    (holder := builder bindingAt:#zTrans) isNil ifTrue:[
        builder aspectAt:#zTrans put:(holder :=  -8.0 asValue).
    ].
    ^ holder

    "Created: / 5.6.1998 / 02:44:05 / cg"
! !

!GLXYGraph3DDemo methodsFor:'menu actions'!

defineGraph:parameters
    |graphView expr xMin xMax yMin yMax src oldResX oldResY|

    graphView := self builder componentAt:#graphView.
    graphView := graphView subViews first.

    oldResX := (graphView xMax - graphView xMin) / graphView deltaX.
    oldResY := (graphView yMax - graphView yMin) / graphView deltaY.

    expr := parameters at:1.
    xMin := parameters at:2.
    xMax := parameters at:3.
    yMin := parameters at:4.
    yMax := parameters at:5.

    src := '[:x :y | ' , expr , ']'.

    graphView xMin:xMin.
    graphView xMax:xMax.
    graphView yMin:yMin.
    graphView yMax:yMax.
    graphView deltaX:(xMax - xMin / oldResX).
    graphView deltaY:(yMax - yMin / oldResY).
    self graphHolder value:(Block readFrom:src).

! !

!GLXYGraph3DDemo methodsFor:'startup'!

openInterface:anInterface
    Screen current supportsGLDrawing ifFalse:[
        ^ self warn:'sorry, but this view requires a display capable of GL drawing'
    ].

    ^ super openInterface:anInterface

    "Created: / 6.9.1998 / 16:02:23 / cg"
!

postBuildWith:aBuilder
    |l|

    super postBuildWith:aBuilder.

    l := ScrollBar styleSheet at:'scrollBar.level'.
    l notNil ifTrue:[
        (aBuilder componentAt:#zTransSlider) level:l
    ].
! !

!GLXYGraph3DDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLXYGraph3DDemo.st,v 1.16 2016-01-21 18:05:02 cg Exp $'
! !

