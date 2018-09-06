"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

StandardSystemView subclass:#GLTeapotDemo
	instanceVariableNames:'framedBox1 teapotView rotBox transBox scaleSlider label1
		framedBox2 pointButton lineButton splineButton solidButton
		radioButtonGroup1'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-3D'
!

GLTeapotDemo comment:'
wraps a teapotView and some controls into a nice view.
(just a demo on how to use smalltalk widgets to control a GLX view)

start with:
    GLTeapotDemo open

This file was created using an early version of the interface builder
'
!

!GLTeapotDemo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    a teapot demo
    Adds some sliders and buttons around a teapotView.
    Today (using the UIPainter), things would be done
    simpler. This is a very old demo.

    [start with:]
        GLTeapotDemo open

    [author:]
        Claus Gittinger
"

! !

!GLTeapotDemo class methodsFor:'startup'!

open
    "default open for GLX views: create a standardSystemView around,
     and open that one"

    |top v|

    (GLXView checkForGLDrawing) ifFalse:[
        ^ nil.
    ].

    super open

    "Modified: / 11.3.1999 / 21:02:02 / cg"
! !

!GLTeapotDemo methodsFor:'initialization'!

initialize
    super initialize.
    self extent:900@460.
    self minExtent:900@460.
    self maxExtent:900@460.
    self label:'3D with Smalltalk !!'.
    self setupSubViews.

    "GLTeapotDemo start"
!

setupSubViews
    "This method was created by the interface builder"

    framedBox1 := FramedBox new.
    self addSubView:framedBox1.
    framedBox1 origin:(7@7) extent:(511@401).
    framedBox1 label:'teapot'.

    teapotView := GLTeapotView new.
    framedBox1 addSubView:teapotView.
    teapotView origin:(22@42) extent:(463@338).
    teapotView level:-1.

    rotBox := SliderBox new.
    self addSubView:rotBox.
    rotBox origin:(520@7) extent:(177@346).
    rotBox label:'rotate'.

    rotBox xSlider thumbOrigin:25.
    rotBox xSlider scrollAction:[:percent | teapotView rotX:percent * 3.6].

    rotBox ySlider thumbOrigin:50.
    rotBox ySlider scrollAction:[:percent | teapotView rotY:percent * 3.6].

    rotBox zSlider thumbOrigin:0.
    rotBox zSlider scrollAction:[:percent | teapotView rotZ:percent * 3.6].

    transBox := SliderBox new.
    self addSubView:transBox.
    transBox origin:(699@7) extent:(177@346).
    transBox label:'translate'.

    transBox xSlider thumbOrigin:50.
    transBox xSlider scrollAction:[:percent | teapotView transX:percent * 3 - 150].

    transBox ySlider thumbOrigin:50.
    transBox ySlider scrollAction:[:percent | teapotView transY:percent * 3 - 150].

    transBox zSlider thumbOrigin:50.
    transBox zSlider scrollAction:[:percent | teapotView transZ:percent * 3 - 150].

    scaleSlider := HorizontalSlider new.
    self addSubView:scaleSlider.
    scaleSlider thumbOrigin:20.
    scaleSlider origin:(69@418) extent:(405@23).
    scaleSlider scrollAction:[:percent | teapotView scale:percent * 0.5].

    label1 := Label new.
    self addSubView:label1.
    label1 origin:(10@418) extent:(54@22).
    label1 label:'scale'.

    framedBox2 := FramedBox new.
    self addSubView:framedBox2.
    framedBox2 origin:(521@356) extent:(357+20"+177"@93).
    framedBox2 label:'display'.

    pointButton := RadioButton new.
    framedBox2 addSubView:pointButton.
    pointButton origin:(27@39) extent:(60@28).
    pointButton label:'Point'.
    pointButton action:[teapotView mode:#point].

    lineButton := RadioButton new.
    framedBox2 addSubView:lineButton.
    lineButton origin:(114@39) extent:(50@28).
    lineButton label:'Line'.
    lineButton action:[teapotView mode:#line].

    splineButton := RadioButton new.
    framedBox2 addSubView:splineButton.
    splineButton origin:(191@39) extent:(60@28).
    splineButton label:'Spline'.
    splineButton action:[teapotView mode:#spline].

    solidButton := RadioButton new.
    framedBox2 addSubView:solidButton.
    solidButton origin:(191+97@39) extent:(60@28).
    solidButton label:'Solid'.
    solidButton action:[teapotView mode:#solid].

    radioButtonGroup1 := RadioButtonGroup new.
    radioButtonGroup1 add:solidButton.
    radioButtonGroup1 add:pointButton.
    radioButtonGroup1 add:lineButton.
    radioButtonGroup1 add:splineButton.

    lineButton turnOn.

    "Modified: 1.7.1997 / 18:15:46 / cg"
! !

!GLTeapotDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLTeapotDemo.st,v 1.8 2016-01-21 18:05:34 cg Exp $'
! !

