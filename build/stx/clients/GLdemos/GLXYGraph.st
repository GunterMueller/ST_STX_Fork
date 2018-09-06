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

GLXView subclass:#GLXYGraph
	instanceVariableNames:'xMin xMax yMin yMax deltaX deltaY functionBlock rotXChannel
		rotYChannel rotZChannel transXChannel transYChannel transZChannel
		scaleZChannel objectId drawNormalsChannel drawBoxChannel bgColor
		bgColorIndex gridColor gridColorIndex boxColor boxColorIndex
		normalsColor normalsColorIndex functionBlockChannel drawLock
		isAnimated'
	classVariableNames:'FunctionList'
	poolDictionaries:''
	category:'demos-3D'
!

GLXYGraph comment:'
simple GL demo - see class method #documentation
'
!

!GLXYGraph class methodsFor:'documentation'!

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
    a simple GL view to display 2D-function or data plots;
    sets up a transformation and draws a function of x/y
    as grid in 3D space.

    It can be setup to either compute the Z-values via a given function(-block)
    or by passing it a data-vector (or matrix), which contains the values.

    The viewing parameters are controlled by valueHolders - thus, it is
    very easy to connect one of them (say rotX) to a thumbWheel.

    This is only a demo - something to start with ...

    [instance variables:]
        xMin,           <Number>                range of function
        xMax,                                   (i.e. function will be evaluated
        yMin,                                   for x/y in that range)
        yMax

        deltaX,         <Number>                step for above
        deltaY

        functionBlock   <Block>                 provides the z-values;
                                                evaluated with x and y as args.

        rotXChannel     <valueImplementor>      provides the x rotation via #value
                                                (typically a valueHolder)

        rotYChannel,                            same, for y-rotation, z-rotation
        rotZChannel,                            x/y/z translation
        transXChannel,
        transYChannel,
        transZChannel

        scaleZChannel   <valueImplementor>      provides a scale factor, by which
                                                z-values are multiplied.

        drawNormalsChannel                      provides a boolean flag,
                                                controlling display of the normal vectors

        drawBoxChannel                          provides a boolean flag,
                                                controlling display of the bounding box

        isAnimated      <Boolean>               if true, changes in the viewing
                                                channels will not force a redraw
                                                (use if anumated and a redraw will
                                                 follow anyway soon)

    [author:]
        Claus Gittinger

    [start with:]
        GLXYGraph open
        CodingExamples_GUI::GLXYGraph3DDemo open
"
!

examples
"
  given a function, display it:
                                                                [exBegin]
     |graphView|

     graphView := GLXYGraph openWithControlPanel.
     graphView functionBlock:[:x :y | (x abs max: y abs) negated + 0.5].
                                                                [exEnd]


  given a list of functions, let user select & display it:
                                                                [exBegin]
     GLXYGraph openWithControlPanelFor:#(
                                                'x + y'
                                                'x * y'
                                                '(x*3) sin + y abs'
                                        )
                                                                [exEnd]

  stand-along setup (constant value 0)
                                                                [exBegin]
     |topView graphView|

     topView := StandardSystemView new.

     graphView := GLXYGraph origin:0.0@0.0 corner:1.0@1.0 in:topView.
     graphView functionBlock:[:x :y | 0 ].
     graphView transZChannel value:-7.   
     graphView rotXChannel value:115.   
     graphView rotYChannel value:0.   
     graphView rotZChannel value:45.   
     topView openWithExtent:500@500
                                                                [exEnd]


  stand-along setup (some linear value)
                                                                [exBegin]
     |topView graphView|

     topView := StandardSystemView new.

     graphView := GLXYGraph origin:0.0@0.0 corner:1.0@1.0 in:topView.
     graphView functionBlock:[:x :y | x max:y ].
     graphView transZChannel value:-7.   
     graphView rotXChannel value:115.   
     graphView rotYChannel value:0.   
     graphView rotZChannel value:45.   
     topView openWithExtent:500@500
                                                                [exEnd]


  stand-along setup (values from a 2-Dmensional array)
                                                                [exBegin]
     |rows cols rnd data topView graphView|

     rnd := Random new.   
     rows := 40. cols := 60.   
     data := TwoDimensionalArray rows:rows cols:cols.
     1 to:rows do:[:y |
        1 to:cols do:[:x |
            data atRow:y col:x put:(rnd next * (x / 10) sin abs).
        ]
     ].

     topView := StandardSystemView new.

     graphView := GLXYGraph origin:0.0@0.0 corner:1.0@1.0 in:topView.
     graphView rows:rows cols:cols access:[:row :col | data atRow:row col:col].
     graphView transZChannel value:-120.   
     graphView transYChannel value:-2.   
     graphView rotXChannel value:115.   
     graphView rotYChannel value:0.   
     graphView rotZChannel value:45.   
     graphView scaleZChannel value:5.   
     topView openWithExtent:500@500
                                                                [exEnd]


  given some data in a linear array, display it.
  Create the controlPanel as a separate step, in order to
  access its components, to modify the translation sliders value:
                                                                [exBegin]
     |rnd rows cols data topView graphView panel|

     rnd := Random new.   
     rows := 40. cols := 60.   
     data := Array new:(rows * cols).
     1 to:(rows * cols) do:[:i |
        data at:i put:(rnd next).
     ].

     topView := StandardSystemView extent:600@400.
     graphView := GLXYGraph origin:0.0@0.0 corner:1.0@1.0 in:topView.
     graphView data:data colSize:cols.

     topView open.

     panel := GLXYGraph openControlPanelFor:graphView.
     (panel componentAt:#transXSlider) start:-50 stop:50 step:5.
     (panel componentAt:#transYSlider) start:-50 stop:50 step:5.
     (panel componentAt:#transZSlider) start:-200 stop:-10 step:10.

     graphView transXChannel value:-15.
     graphView transYChannel value:20.
     graphView transZChannel value:-110.

     graphView scaleZChannel value:2.

                                                                [exEnd]
  given data in any representation,
  pass an access-method and display it.
  No controlPanel.:
                                                                [exBegin]
     |rnd rows cols data topView graphView|

     rnd := Random new.   
     rows := 40. cols := 60.   
     data := TwoDimensionalArray rows:rows cols:cols.
     1 to:rows do:[:y |
        1 to:cols do:[:x |
            data atRow:y col:x put:(rnd next).
        ]
     ].

     topView := StandardSystemView new.

     graphView := GLXYGraph origin:0.0@0.0 corner:1.0@1.0 in:topView.
     graphView rows:rows cols:cols access:[:row :col | data atRow:row col:col].
     graphView rotXChannel value:115.   
     graphView rotYChannel value:0.   
     graphView rotZChannel value:45.
     graphView transZChannel value:-150.
     graphView scaleZChannel value:5.
     topView openWithExtent:500@500
                                                                [exEnd]
"
! !

!GLXYGraph class methodsFor:'defaults'!

defaultExtent
    "used by superclasses open-method"

    ^ 480 @ 480
!

defaultFunctionList
    "just for the demo - return a list of demo functions.
     The list consists of strings, which are interpreted as block-bodies;
     i.e. evaluated as '[:x :y | <functions-string>]' "

    FunctionList isNil ifTrue:[
        FunctionList := OrderedCollection new.
        FunctionList add:'(x abs max: y abs) negated + 0.5'.
        FunctionList add:'|tX tY t| tX := x * 20. tY := y * 20. t := (tX*tX) + (tY*tY). (t sqrt sin / t sqrt) negated'.
        FunctionList add:'((x * 5) sin * (y * 5) sin) / 4'.
        FunctionList add:'((x * 2) sin * (y * 5) sin) / 4'.
        FunctionList add:'((x*x) + (y*y)) sin - 0.5'.
        FunctionList add:'(((x*x) + (y*y)) * 4) sin'.
        FunctionList add:'(((x*x) + (y*y)) sqrt * 4) sin'.

        FunctionList add:'(x * 4) truncated / 4'.

        FunctionList add:'((x * 5) sin + (y * 5) sin) / 2 '.
        FunctionList add:'(x * x exp) sin + y exp sin  - 0.5'.
    ].
    ^ FunctionList

    "Modified: 25.5.1996 / 11:08:44 / cg"
!

defaultLabel
    "used by superclasses open-method"

    ^ 'simple GL'
! !

!GLXYGraph class methodsFor:'startup'!

demo1
    "plain simple GLXYGraph view - opens the view and shows
     some function-plot there"

    |top v xRot yRot zRot|

    Screen current supportsGLDrawing ifFalse:[
        ^ self warn:'sorry, but this view requires a display capable of GL drawing'
    ].

    top := StandardSystemView new.
    top extent:400@400.

    v := self in:top.
    v origin:0.0@0.0 corner:1.0@1.0.

    top open.

    "
     GLXYGraph demo1
    "
!

demo2
    "nice GLXYGraph view - opens the view and shows
     some function-plot there. Also creates and opens a panel,
     which offers some control on what is and how it is displayed.
     (also demonstrates partner views ;-)"

    |top v panel listView list lX lY lZ f vp p slX slY slZ t|

    Screen current supportsGLDrawing ifFalse:[
        ^ self warn:'sorry, but this view requires a display capable of GL drawing'
    ].

    top := StandardSystemView new.
    top extent:(self defaultExtent).
    top label:'X/Y graph'.
    top icon:(Image fromFile:'GLX.xbm').
    top iconLabel:'X/Y graph'.

    v := self in:top.
    v origin:0.0 @ 0.0 corner:1.0 @ 1.0.

    top open.

    self openControlPanelFor:v functionList:(GLXYGraph defaultFunctionList).

    "
     GLXYGraph demo2
    "

    "Modified: 19.7.1996 / 22:19:39 / cg"
!

open
    "open a GLXYGraph view together with a panel"

    self demo2

    "
     GLXYGraph open
    "

    "Created: 25.5.1996 / 12:31:12 / cg"
    "Modified: 25.5.1996 / 12:32:28 / cg"
!

openControlPanelFor:aGraphView
    "creates and open a panel, which offers some control over aGraphView.
     Returns the panel for further control
     (also demonstrates partner views ;-)"

    ^ self openControlPanelFor:aGraphView functionList:nil

    "
     |topView graphView|

     topView := StandardSystemView extent:400@400.   
     graphView := GLXYGraph in:topView.
     topView open.

     GLXYGraph openControlPanelFor:graphView
    "

    "Modified: 25.5.1996 / 11:09:32 / cg"
!

openControlPanelFor:aGraphView functionList:functionList
    "creates and open a panel, which offers some control over aGraphView.
     Returns the panel for further control.
     If functionList is non-nil, an additional selectionList is added to the panel
     to select the displayed function."

    |panel listView lX lY lZ f vp p slX slY slZ t
     graphViewsTopView rotXChannel rotYChannel rotZChannel|

    graphViewsTopView := aGraphView topView.
    rotXChannel := aGraphView rotXChannel.
    rotYChannel := aGraphView rotYChannel.
    rotZChannel := aGraphView rotZChannel.

    panel := Dialog new.
    panel iconLabel:(graphViewsTopView iconLabel ? 'control').
    panel icon:(graphViewsTopView icon).
    panel label:'X/Y graph control'.

    slX := HorizontalSteppingSlider on:rotXChannel.
    slX upButtonLabel:'-' downButtonLabel:'+'.

    slY := HorizontalSteppingSlider on:rotYChannel.
    slY upButtonLabel:'-' downButtonLabel:'+'.

    slZ := HorizontalSteppingSlider on:rotZChannel.
    slZ upButtonLabel:'-' downButtonLabel:'+'.

    slX start:0 stop:360.  slY start:0 stop:360.  slZ start:0 stop:360.

    "/ rotation box

    f := FramedBox new.
    f label:'rotation'.
    f horizontalSpace:ViewSpacing // 2.
    vp := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:f.
    vp horizontalLayout:#fit.
    vp borderWidth:0.

    p := HorizontalPanelView new.
    p horizontalSpace:1; horizontalLayout:#leftSpaceFit; borderWidth:0.
    p add:((Label label:'x') borderWidth:0).
    p add:(lX := Label label:'000').
    lX borderWidth:0. 
    lX sizeFixed:true. 
    lX converter:(PrintConverter new initForInteger).
    lX model:rotXChannel; aspect:#value; labelMessage:#value.
    p add:slX.
    vp add:p.

    p := HorizontalPanelView new.
    p horizontalSpace:1; horizontalLayout:#leftSpaceFit; borderWidth:0.
    p add:((Label label:'y') borderWidth:0).
    p add:(lY := Label label:'000').
    lY borderWidth:0. 
    lY sizeFixed:true. 
    lY converter:(PrintConverter new initForInteger).
    lY model:rotYChannel; aspect:#value; labelMessage:#value.
    p add:slY.
    vp add:p.

    p := HorizontalPanelView new.
    p horizontalSpace:1; horizontalLayout:#leftSpaceFit; borderWidth:0.
    p add:((Label label:'z') borderWidth:0).
    p add:(lZ := Label label:'000').
    lZ borderWidth:0. 
    lZ sizeFixed:true. 
    lZ converter:(PrintConverter new initForInteger).
    lZ model:rotZChannel; aspect:#value; labelMessage:#value.
    p add:slZ.
    vp add:p.

    panel makeTabable:slX; makeTabable:slY; makeTabable:slZ.

    panel 
        name:slX as:#rotXSlider; 
        name:slY as:#rotYSlider; 
        name:slZ as:#rotZSlider.

    panel addComponent:f.


    "/ translation box

    slX := HorizontalSteppingSlider on:(aGraphView transXChannel).
    slX upButtonLabel:'-' downButtonLabel:'+'.
    slY := HorizontalSteppingSlider on:(aGraphView transYChannel).
    slY upButtonLabel:'-' downButtonLabel:'+'.
    slZ := HorizontalSteppingSlider on:(aGraphView transZChannel).
    slZ upButtonLabel:'-' downButtonLabel:'+'.

    slX start:-2  stop:2  step:0.1.
    slY start:-2  stop:2  step:0.1.
    slZ start:-10 stop:0  step:0.1.

    f := FramedBox new.
    f label:'translation'.
    f horizontalSpace:ViewSpacing // 2.
    vp := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:f.
    vp horizontalLayout:#fit.
    vp borderWidth:0.

    p := HorizontalPanelView new.
    p horizontalSpace:1; horizontalLayout:#leftSpaceFit; borderWidth:0.
    p add:((Label label:'x') borderWidth:0).
    p add:(lX := Label label:'-10.00').
    lX borderWidth:0. 
    lX sizeFixed:true. 
    lX converter:(PrintConverter new initForFloatWithPrecision:1).
    lX model:aGraphView transXChannel; aspect:#value; labelMessage:#value.
    p add:slX.
    vp add:p.

    p := HorizontalPanelView new.
    p horizontalSpace:1; horizontalLayout:#leftSpaceFit; borderWidth:0.
    p add:((Label label:'y') borderWidth:0).
    p add:(lY := Label label:'-10.00').
    lY borderWidth:0. 
    lY sizeFixed:true. 
    lY converter:(PrintConverter new initForFloatWithPrecision:1).
    lY model:aGraphView transYChannel; aspect:#value; labelMessage:#value.
    p add:slY.
    vp add:p.

    p := HorizontalPanelView new.
    p horizontalSpace:1; horizontalLayout:#leftSpaceFit; borderWidth:0.
    p add:((Label label:'z') borderWidth:0).
    p add:(lZ := Label label:'-10.00').
    lZ borderWidth:0. 
    lZ sizeFixed:true. 
    lZ converter:(PrintConverter new initForFloatWithPrecision:1).
    lZ model:aGraphView transZChannel; aspect:#value; labelMessage:#value.
    p add:slZ.
    vp add:p.

    panel makeTabable:slX; makeTabable:slY; makeTabable:slZ.

    panel 
        name:slX as:#transXSlider;
        name:slY as:#transYSlider;
        name:slZ as:#transZSlider.

    panel addComponent:f.

    "/ scale box

    slZ := HorizontalSteppingSlider on:(aGraphView scaleZChannel).
    slZ upButtonLabel:'-' downButtonLabel:'+'.
"/    slZ asynchronousOperation.

    slZ start:0 stop:10 step:0.5.

    f := FramedBox new.
    f label:'scale'.
    f horizontalSpace:ViewSpacing // 2.
    vp := VerticalPanelView origin:0.0@0.0 corner:1.0@1.0 in:f.
    vp horizontalLayout:#fit.
    vp borderWidth:0.

    p := HorizontalPanelView new.
    p horizontalSpace:1; horizontalLayout:#leftSpaceFit; borderWidth:0.
    p add:((Label label:'z') borderWidth:0).
    p add:(lZ := Label label:'10.00').
    lZ borderWidth:0. 
    lZ sizeFixed:true. 
    lZ converter:(PrintConverter new initForFloatWithPrecision:1).
    lZ model:aGraphView scaleZChannel; aspect:#value; labelMessage:#value.
    p add:slZ.
    vp add:p.

    panel makeTabable:slZ.

    panel name:slZ as:#scaleZSlider.

    panel addComponent:f.

    "/ control button box

    f := FramedBox new.
    f label:'display'.
    f horizontalSpace:ViewSpacing // 2.

    p := HorizontalPanelView origin:0.0@0.0 corner:1.0@1.0 in:f.
    p horizontalLayout:#centerMax; borderWidth:0.

    p add:(t := Toggle label:'normals').
    t model:aGraphView drawNormalsChannel.
    panel makeTabable:t.
    panel name:t as:#normalsToggle.

    p add:(t := Toggle label:'box').
    t model:aGraphView drawBoxChannel.
    panel makeTabable:t.
    panel name:t as:#boxToggle.

    panel addComponent:f.

    functionList notNil ifTrue:[
        "/ selectionInList for the functions

        listView := ScrollableView for:SelectionInListView.
        listView height:100.
        panel addComponent:listView.
        panel makeTabable:listView.
        listView list:functionList.
        listView action:[:sel | aGraphView functionString:(listView selectionValue)].
        listView corner:(1.0 @ 1.0).
        panel name:listView scrolledView as:#functionList.
    ].

    "/ want them to close, iconify and deiconify together

    (graphViewsTopView windowGroup) isNil ifTrue:[
        aGraphView topView open
    ].

    panel bePartner.
    aGraphView topView bePartner.

    "/ preset for some nice graph

    rotXChannel value:130.
    rotZChannel value:25.
    aGraphView drawNormalsChannel value:false.
    aGraphView drawBoxChannel value:true.

    "/ now, open them as partnerViews in the same windowGroup

    panel openInGroup:aGraphView topView windowGroup.

    ^ panel

    "
     |list topView graphView control|

     list := #(
                'x sin + y sin'
                '(x * 3) sin + (y * 3) sin'
                'x abs'
                'x abs + y abs'
                '(x abs * 5) truncated + (y abs * 5) truncated - 5 * 0.5'
              ).

     topView := StandardSystemView extent:400@400.   
     graphView := GLXYGraph in:topView.
     graphView scaleZChannel value:0.5.
     topView open.

     control := GLXYGraph openControlPanelFor:graphView functionList:list.

     (control componentAt:#transZSlider) start:-30 stop:2 step:1.
     (control componentAt:#functionList) selection:2
    "

    "Modified: / 29.5.1998 / 17:32:41 / cg"
!

openWithControlPanel
    "open GLXYGraph view - opens the view and also creates and opens a panel,
     which offers some control on how it is displayed.
     Returns the XY-graph view for further control (setting the data/function)
     (also demonstrates partner views ;-)"

    ^ self openWithControlPanelFor:nil

    "
     GLXYGraph openWithControlPanel

     GLXYGraph openWithControlPanel functionBlock:[:x :y | x * y]
    "

    "Modified: 25.5.1996 / 12:39:07 / cg"
!

openWithControlPanelFor:functionList
    "nice GLXYGraph view - opens the view and also creates and opens a panel,
     which offers some control on how it is displayed.
     Returns the XY-graph view for further control (setting the data/function)
     (also demonstrates partner views ;-)"

    |top v panel listView list lX lY lZ f vp p slX slY slZ t|

    top := StandardSystemView new.
    top extent:(self defaultExtent).
    top label:'X/Y graph'.

    v := self in:top.
    v origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    top iconLabel:'X/Y graph'.

    panel := self openControlPanelFor:v functionList:functionList.

    v drawNormalsChannel value:false.
    v drawBoxChannel value:true.

    "/ now, open them as partnerViews in the same windowGroup

    top open.

    ^ v

    "
     GLXYGraph openWithControlPanelFor:#(
                                                'x + y'
                                                'x * y'
                                                'ErrorSignal handle:[:ex | ex resumeWith:0] do:[(x / y / 3 min:10)max:-10]'
                                                '(x*3) sin + y abs'
                                        )
    "

    "Modified: 25.5.1996 / 12:48:28 / cg"
! !

!GLXYGraph methodsFor:'accessing'!

data:aDataVector colSize:cols
    "set the function to display the data contained in the argument;
     The data must have rows*cols elements, the number of cols is passed in
     the cols argument (rows is computed from that)."

    |rows|

    rows := aDataVector size // cols.
    rows * cols ~~ aDataVector size ifTrue:[
        self error:'bad data - rows*cols ~~ size of vector'.
        ^ self
    ].

    xMin := yMin := 0.
    xMax := cols-1.
    yMax := rows-1.
    deltaX := deltaY := 1.

    self functionBlock:[:x :y |
        aDataVector at:(y*cols + x + 1)
    ].

    "
     |rnd rows cols data topView graphView|

     rnd := Random new.   
     rows := 40. cols := 60.   
     data := Array new:(rows * cols).
     1 to:(rows * cols) do:[:i |
        data at:i put:(rnd next).
     ].

     topView := StandardSystemView new.
     topView label:'random data'.

     graphView := GLXYGraph origin:0.0@0.0 corner:1.0@1.0 in:topView.
     graphView data:data colSize:cols.
     graphView rotXChannel value:115.   
     graphView rotYChannel value:0.   
     graphView rotZChannel value:45.   
     graphView transZChannel value:-100.   
     graphView scaleZChannel value:5.   
     topView openWithExtent:500@500
    "

    "Modified: 25.5.1996 / 10:46:38 / cg"
!

deltaX
    "return deltaX"

    ^ deltaX
!

deltaX:something
    "set deltaX"

    deltaX := something.
!

deltaY
    "return deltaY"

    ^ deltaY
!

deltaY:something
    "set deltaY"

    deltaY := something.
!

functionBlock
    "return the functionBlock"

    ^ functionBlock
!

functionBlock:something
    "set the functionBlock, a two-arg block.
     The functionBlock will be called with x and y as arguments, and
     is supposed to return a z-value.
     This implies recomputing the graph."

    |wg|

    functionBlock := something.
    (wg := self windowGroup) notNil ifTrue:[
        wg withCursor:Cursor wait do:[
            self reconstructPicture
        ]
    ]

    "
     |topView graphView|

     topView := StandardSystemView new.

     graphView := GLXYGraph origin:0.0@0.0 corner:1.0@1.0 in:topView.
     graphView functionBlock:[:x :y | 0 ].
     graphView transZChannel value:-7.   
     graphView rotXChannel value:115.   
     graphView rotYChannel value:0.   
     graphView rotZChannel value:45.   
     topView openWithExtent:500@500
    "

    "Modified: / 29.5.1998 / 21:10:55 / cg"
!

functionString:aString
    "set the function from a string"

    self functionBlock:(Compiler evaluate:'[:x :y |' , aString , ']')



!

isAnimated:aBoolean
    "set/clear the flag which controls automatic redraw when
     a rot- or trans-channel is changed.
     If true, no redraw is done in these cases, since the view
     is redrawn anyway (animated) after a short time.
     The default is false."

    isAnimated := aBoolean.
    aBoolean ifFalse:[
        rotXChannel notNil ifTrue:[rotXChannel retractInterestsFor:self].
        rotYChannel notNil ifTrue:[rotYChannel retractInterestsFor:self].
        rotZChannel notNil ifTrue:[rotZChannel retractInterestsFor:self].
        transXChannel notNil ifTrue:[transXChannel retractInterestsFor:self].
        transYChannel notNil ifTrue:[transYChannel retractInterestsFor:self].
        transZChannel notNil ifTrue:[transZChannel retractInterestsFor:self].
    ].

    "Created: / 14.6.1998 / 17:17:29 / cg"
    "Modified: / 14.6.1998 / 17:30:39 / cg"
!

isDrawingBox
    ^ drawBoxChannel value

    "Modified: / 5.6.1998 / 02:36:21 / cg"
    "Created: / 5.6.1998 / 02:51:36 / cg"
!

isDrawingNormals
    ^ drawNormalsChannel value

    "Modified: / 5.6.1998 / 02:36:27 / cg"
    "Created: / 5.6.1998 / 02:52:00 / cg"
!

rotX
    "return the current X-rotation"

    ^ rotXChannel value.

    "Created: / 5.6.1998 / 02:34:48 / cg"
!

rotY
    "return the current Y-rotation"

    ^ rotYChannel value.

    "Created: / 5.6.1998 / 02:34:58 / cg"
!

rotZ
    "return the current Z-rotation"

    ^ rotZChannel value.

    "Created: / 5.6.1998 / 02:35:03 / cg"
!

rows:rows cols:cols access:accessBlock
    "set the function to display the data returned by accessBlock;
     AccessBlock is evaluated with row/col arguments, starting at 1/1."

    xMin := yMin := 1.
    xMax := cols-1.
    yMax := rows-1.
    deltaX := deltaY := 1.

    self functionBlock:[:x :y |
        accessBlock value:y value:x
    ].

    "
     |rnd rows cols data topView graphView|

     rnd := Random new.   
     rows := 40. cols := 60.   
     data := TwoDimensionalArray rows:rows cols:cols.
     1 to:rows do:[:y |
        1 to:cols do:[:x |
            data atRow:y col:x put:(rnd next).
        ]
     ].

     topView := StandardSystemView new.

     graphView := GLXYGraph origin:0.0@0.0 corner:1.0@1.0 in:topView.
     graphView rows:rows cols:cols access:[:row :col | data atRow:row col:col].
     graphView rotXChannel value:115.   
     graphView rotYChannel value:0.   
     graphView rotZChannel value:45.
     graphView transZChannel value:-150.
     graphView scaleZChannel value:5.
     topView openWithExtent:500@500
    "

    "Modified: 25.5.1996 / 10:48:05 / cg"
!

scaleZ
    "return the current Z scale"

    ^ scaleZChannel value.

    "Created: / 5.6.1998 / 02:35:38 / cg"
!

transX
    "return the current X-translation"

    ^ transXChannel value.

    "Created: / 5.6.1998 / 02:35:20 / cg"
!

transY
    "return the current Y-translation"

    ^ transYChannel value.

    "Created: / 5.6.1998 / 02:35:17 / cg"
!

transZ
    "return the current Z-translation"

    ^ transZChannel value.

    "Created: / 5.6.1998 / 02:35:09 / cg"
!

xMax
    "return xMax"

    ^ xMax
!

xMax:something
    "set xMax"

    xMax := something.
!

xMin
    "return xMin"

    ^ xMin
!

xMin:something
    "set xMin"

    xMin := something.
!

yMax
    "return yMax"

    ^ yMax
!

yMax:something
    "set yMax"

    yMax := something.
!

yMin
    "return yMin"

    ^ yMin
!

yMin:something
    "set yMin"

    yMin := something.
! !

!GLXYGraph methodsFor:'accessing - channels'!

drawBoxChannel
    "return drawBoxChannel"

    ^ drawBoxChannel
!

drawBoxChannel:something
    "set drawBoxChannel"

    drawBoxChannel notNil ifTrue:[
        drawBoxChannel retractInterestsFor:self
    ].
    drawBoxChannel := something.
    drawBoxChannel notNil ifTrue:[
        drawBoxChannel onChangeSend:#reconstructPicture to:self
    ].
    self reconstructPicture

    "Created: / 5.6.1998 / 01:42:29 / cg"
    "Modified: / 5.6.1998 / 02:45:44 / cg"
!

drawNormalsChannel 
    "return drawNormalsChannel"

    ^ drawNormalsChannel
!

drawNormalsChannel:something
    "set drawNormalsChannel"

    drawNormalsChannel notNil ifTrue:[
        drawNormalsChannel retractInterestsFor:self
    ].
    drawNormalsChannel := something.
    drawNormalsChannel notNil ifTrue:[
        drawNormalsChannel onChangeSend:#reconstructPicture to:self
    ].
    self reconstructPicture

    "Created: / 5.6.1998 / 01:42:35 / cg"
    "Modified: / 5.6.1998 / 02:45:49 / cg"
!

functionBlockChannel
    "return functionBlockChannel"

    ^ functionBlockChannel

    "Created: / 29.5.1998 / 21:07:42 / cg"
!

functionBlockChannel:something
    "set functionBlockChannel"

    functionBlockChannel notNil ifTrue:[
        functionBlockChannel retractInterestsFor:self
    ].
    functionBlockChannel := something.
    functionBlockChannel notNil ifTrue:[
        functionBlockChannel onChangeSend:#reconstructPicture to:self
    ].
    self reconstructPicture

    "Created: / 29.5.1998 / 21:07:47 / cg"
    "Modified: / 5.6.1998 / 04:09:21 / cg"
!

rotXChannel
    "return rotXChannel"

    ^ rotXChannel
!

rotXChannel:something
    "set rotXChannel"

    rotXChannel notNil ifTrue:[
        rotXChannel retractInterestsFor:self
    ].
    rotXChannel := something.
    rotXChannel notNil ifTrue:[
        rotXChannel onChangeSend:#rotationChanged to:self
    ].

    "Modified: / 14.6.1998 / 17:33:22 / cg"
!

rotYChannel
    "return rotYChannel"

    ^ rotYChannel
!

rotYChannel:something
    "set rotYChannel"

    rotYChannel notNil ifTrue:[
        rotYChannel retractInterestsFor:self
    ].
    rotYChannel := something.
    rotYChannel notNil ifTrue:[
        rotYChannel onChangeSend:#rotationChanged to:self
    ].

    "Modified: / 14.6.1998 / 17:33:32 / cg"
!

rotZChannel
    "return rotZChannel"

    ^ rotZChannel
!

rotZChannel:something
    "set rotZChannel"

    rotZChannel notNil ifTrue:[
        rotZChannel retractInterestsFor:self
    ].
    rotZChannel := something.
    rotZChannel notNil ifTrue:[
        rotZChannel onChangeSend:#rotationChanged to:self
    ].

    "Modified: / 14.6.1998 / 17:33:41 / cg"
!

scaleZChannel
    "return scaleZChannel"

    ^ scaleZChannel
!

scaleZChannel:something
    "set scaleZChannel"

    scaleZChannel notNil ifTrue:[
        scaleZChannel retractInterestsFor:self
    ].
    scaleZChannel := something.
    scaleZChannel notNil ifTrue:[
        scaleZChannel onChangeSend:#scaleChanged to:self
    ].

    "Modified: / 14.6.1998 / 17:34:15 / cg"
!

transXChannel
    "return transXChannel"

    ^ transXChannel
!

transXChannel:something
    "set transXChannel"

    transXChannel notNil ifTrue:[
        transXChannel retractInterestsFor:self
    ].
    transXChannel := something.
    transXChannel notNil ifTrue:[
        transXChannel onChangeSend:#translationChanged to:self
    ].

    "Modified: / 14.6.1998 / 17:33:54 / cg"
!

transYChannel
    "return transYChannel"

    ^ transYChannel
!

transYChannel:something
    "set transYChannel"

    transYChannel notNil ifTrue:[
        transYChannel retractInterestsFor:self
    ].
    transYChannel := something.
    transYChannel notNil ifTrue:[
        transYChannel onChangeSend:#translationChanged to:self
    ].

    "Modified: / 14.6.1998 / 17:34:02 / cg"
!

transZChannel
    "return transZChannel"

    ^ transZChannel
!

transZChannel:something
    "set transZChannel"

    transZChannel notNil ifTrue:[
        transZChannel retractInterestsFor:self
    ].
    transZChannel := something.
    transZChannel notNil ifTrue:[
        transZChannel onChangeSend:#translationChanged to:self
    ].

    "Modified: / 14.6.1998 / 17:34:10 / cg"
! !

!GLXYGraph methodsFor:'accessing - look'!

backgroundColor:aColor
    aColor isNil ifTrue:[
        bgColorIndex := Black.
    ] ifFalse:[
        super backgroundColor:aColor.

        bgColorIndex >= 8 ifTrue:[
            "/ I have previously allocated some other color.
            "/ free it.
            self class freeColorSlot:bgColorIndex
        ].
        bgColor := aColor.
        bgColorIndex := self class allocateColorSlotFor:aColor.
        bgColorIndex >= 8 ifTrue:[
            self mapColor:bgColorIndex red:(aColor redByte) green:(aColor greenByte) blue:(aColor blueByte).
        ].
    ].
    self reconstructPicture.

    "Modified: / 5.6.1998 / 14:19:07 / cg"
!

boxColor:aColor
    aColor isNil ifTrue:[
        boxColorIndex := Green.
    ] ifFalse:[
        boxColorIndex >= 8 ifTrue:[
            "/ I have previously allocated some other color.
            "/ free it.
            self class freeColorSlot:boxColorIndex
        ].
        boxColor := aColor.
        boxColorIndex := self class allocateColorSlotFor:aColor.
        boxColorIndex >= 8 ifTrue:[
            self mapColor:boxColorIndex red:(aColor redByte) green:(aColor greenByte) blue:(aColor blueByte).
        ].
    ].
    self reconstructPicture.

    "Modified: / 5.6.1998 / 14:19:18 / cg"
!

gridColor:aColor
    aColor isNil ifTrue:[
        gridColorIndex := White.
    ] ifFalse:[
        gridColorIndex >= 8 ifTrue:[
            "/ I have previously allocated some other color.
            "/ free it.
            self class freeColorSlot:gridColorIndex
        ].
        gridColor := aColor.
        gridColorIndex := self class allocateColorSlotFor:aColor.
        gridColorIndex >= 8 ifTrue:[
            self mapColor:gridColorIndex red:(aColor redByte) green:(aColor greenByte) blue:(aColor blueByte).
        ].
    ].
    self reconstructPicture.

    "Modified: / 5.6.1998 / 14:19:28 / cg"
!

normalsColor:aColor
    aColor isNil ifTrue:[
        normalsColorIndex := Red.
    ] ifFalse:[
        normalsColorIndex >= 8 ifTrue:[
            "/ I have previously allocated some other color.
            "/ free it.
            self class freeColorSlot:normalsColorIndex
        ].
        normalsColor := aColor.
        normalsColorIndex := self class allocateColorSlotFor:aColor.
        normalsColorIndex >= 8 ifTrue:[
            self mapColor:normalsColorIndex red:(aColor redByte) green:(aColor greenByte) blue:(aColor blueByte).
        ].
    ].
    self reconstructPicture.

    "Modified: / 5.6.1998 / 14:19:38 / cg"
! !

!GLXYGraph methodsFor:'drawing'!

draw 
    "draw the whole picture"

    "
     clear the drawing area
    "
    self color:bgColorIndex. "/ set current color (for clear)
    self clear.              "/clear to current color

    "
     save current transformation
    "
    self pushMatrix.

    self drawPicture.

    "
     restore transformation
    "
    self popMatrix.

    "Modified: / 5.6.1998 / 14:06:31 / cg"
!

drawBox
    "draw a cube (the box)"

    self color:boxColorIndex.

    self beginLine.
        self v3fX:xMin y:yMin z:-1.0.
        self v3fX:xMax y:yMin z:-1.0.
        self v3fX:xMax y:yMax z:-1.0.
        self v3fX:xMin y:yMax z:-1.0.
        self v3fX:xMin y:yMin z:-1.0.
    self endLine.

    self beginLine.
        self v3fX:xMin y:yMin z:1.0.
        self v3fX:xMax y:yMin z:1.0.
        self v3fX:xMax y:yMax z:1.0.
        self v3fX:xMin y:yMax z:1.0.
        self v3fX:xMin y:yMin z:1.0.
    self endLine.
    self beginLine.
        self v3fX:xMin y:yMin z:-1.0.
        self v3fX:xMin y:yMin z:1.0.
    self endLine.
    self beginLine.
        self v3fX:xMax y:yMin z:-1.0.
        self v3fX:xMax y:yMin z:1.0.
    self endLine.
    self beginLine.
        self v3fX:xMax y:yMax z:-1.0.
        self v3fX:xMax y:yMax z:1.0.
    self endLine.
    self beginLine.
        self v3fX:xMin y:yMax z:-1.0.
        self v3fX:xMin y:yMax z:1.0.
    self endLine.

    "Modified: / 5.6.1998 / 14:10:02 / cg"
!

drawGraphic
    "draw the graph"

    |scaleZ f|

    scaleZ := scaleZChannel value.

    functionBlock isBlock ifFalse:[
        f := [:x :y | functionBlock].
    ] ifTrue:[
        functionBlock numArgs == 1 ifTrue:[
            f := [:x :y | functionBlock value:x].
        ] ifFalse:[
            f := functionBlock
        ]
    ].

    "
     draw a grid, evaluating the points using f (the functionBlock),
     which gets x & y as arguments.
    "
    self color:gridColorIndex. 

    yMin to:yMax+(deltaY/2) by:deltaY do:[:y |
        |z1|

        z1 := (f value:xMin value:y) * scaleZ.

        xMin to:xMax-(deltaX/2) by:deltaX do:[:x |
            |z2 xNext|

            xNext := x+deltaX.
            z2 := (f value:xNext value:y) * scaleZ.

            self beginLine.
            self v3fX:x     y:y z:z1.
            self v3fX:xNext y:y z:z2.
            self endLine.
            z1 := z2.
        ]
    ].

    xMin to:xMax+(deltaX/2) by:deltaX do:[:x |
        |z1|

        z1 := (f value:x value:yMin) * scaleZ.

        yMin to:yMax-(deltaY/2) by:deltaY do:[:y |
            |z2 yNext|

            yNext := y+deltaY.
            z2 := (f value:x value:yNext) * scaleZ.

            self beginLine.
            self v3fX:x y:y     z:z1.
            self v3fX:x y:yNext z:z2.
            self endLine.
            z1 := z2.
        ]
    ].

    "Modified: / 5.6.1998 / 14:07:19 / cg"
!

drawNormals
    "draw the x/y/z normals"

    "/ this is somewhat complicated, since I want
    "/ x,y & z as characters to be drawn.
    "/ however, GL does not scale or transform
    "/ ascii drawn chars. Therefore, we do it as
    "/ a vector font draw.

    self color:normalsColorIndex.

    "/ x axis
    self beginLine.
        self v3fX:xMin-(deltaX*5) y:yMin-(deltaY*5) z:0.
        self v3fX:xMax+(deltaX*5) y:yMin-(deltaY*5) z:0.
    self endLine.

    "/ arrowhead
    self beginLine.
        self v3fX:xMax+(deltaX*5)-deltaX   y:yMin-(deltaY*5)-deltaY z:0.
        self v3fX:xMax+(deltaX*5)          y:yMin-(deltaY*5)        z:0.
        self v3fX:xMax+(deltaX*5)-deltaX   y:yMin-(deltaY*5)+deltaY z:0.
    self endLine.

    "/ X-character
    self beginLine.
        self v3fX:xMax+(deltaX*5)+deltaX               y:yMin-(deltaY*5)-deltaY z:0.
        self v3fX:xMax+(deltaX*5)+deltaX+deltaX+deltaX y:yMin-(deltaY*5)+deltaY z:0.
    self endLine.
    self beginLine.
        self v3fX:xMax+(deltaX*5)+deltaX               y:yMin-(deltaY*5)+deltaY z:0.
        self v3fX:xMax+(deltaX*5)+deltaX+deltaX+deltaX y:yMin-(deltaY*5)-deltaY z:0.
    self endLine.


    "/ y axis
    self beginLine.
        self v3fX:xMin-(deltaX*5) y:yMin-(deltaY*5) z:0.
        self v3fX:xMin-(deltaX*5) y:yMax+(deltaY*5) z:0.
    self endLine.

    "/ arrowhead
    self beginLine.
        self v3fX:xMin-(deltaX*5)-deltaX   y:yMax+(deltaY*5)-deltaY z:0.
        self v3fX:xMin-(deltaX*5)          y:yMax+(deltaY*5)        z:0.
        self v3fX:xMin-(deltaX*5)+deltaX   y:yMax+(deltaY*5)-deltaY z:0.
    self endLine.

    "/ Y-character
    self beginLine.
        self v3fX:xMin-(deltaX*5)-deltaX   y:yMax+(deltaY*5)+deltaY z:0.
        self v3fX:xMin-(deltaX*5)+deltaX   y:yMax+(deltaY*5)+deltaY+deltaY+deltaY        z:0.
    self endLine.
    self beginLine.
        self v3fX:xMin-(deltaX*5)-deltaX   y:yMax+(deltaY*5)+deltaY+deltaY+deltaY        z:0.
        self v3fX:xMin-(deltaX*5)          y:yMax+(deltaY*5)+deltaY+deltaY        z:0.
    self endLine.


    "/ z-axis
    self beginLine.
        self v3fX:xMin-(deltaX*5) y:yMin-(deltaY*5) z:0.
        self v3fX:xMin-(deltaX*5) y:yMin-(deltaY*5) z:-2.0.
    self endLine.

    "/ arrowhead
    self beginLine.
        self v3fX:xMin-(deltaX*5)-deltaX y:yMin-(deltaY*5) z:-2.0 + deltaY.
        self v3fX:xMin-(deltaX*5)        y:yMin-(deltaY*5) z:-2.0.
        self v3fX:xMin-(deltaX*5)+deltaX y:yMin-(deltaY*5) z:-2.0 + deltaY.
    self endLine.

    "/ Z character
    self beginLine.
        self v3fX:xMin-(deltaX*5)-deltaX y:yMin-(deltaY*5) z:-2.0-deltaY-deltaY-deltaY.
        self v3fX:xMin-(deltaX*5)+deltaX y:yMin-(deltaY*5) z:-2.0-deltaY-deltaY-deltaY.
        self v3fX:xMin-(deltaX*5)-deltaX y:yMin-(deltaY*5) z:-2.0-deltaY.
        self v3fX:xMin-(deltaX*5)+deltaX y:yMin-(deltaY*5) z:-2.0-deltaY.
    self endLine.

    "Modified: / 5.6.1998 / 14:09:43 / cg"
!

drawPicture
    "draw the picture"

    "
     the rectangle is at 0.0/0.0/-20.0
    "
    self translateX:transXChannel value
                  y:transYChannel value 
                  z:transZChannel value.

    self rotateX:rotXChannel value
               y:rotYChannel value
               z:rotZChannel value.

    objectId isNil ifTrue:[
        objectId := self newObjectId.
        self makeObject:objectId.
        self drawGraphic.
        drawBoxChannel value ifTrue:[
            self drawBox.
        ].
        drawNormalsChannel value ifTrue:[
            self drawNormals.
        ].
        self closeObject.
    ].
    self callObject:objectId.

    "Modified: / 5.6.1998 / 14:08:54 / cg"
!

reconstructPicture
    "have to clear the buffered object and
     reconstruct it, 
     whenever a (non-transformation releated) parameter changes"

    drawLock critical:[
        functionBlockChannel notNil ifTrue:[
            functionBlock := functionBlockChannel value.
        ].

        objectId notNil ifTrue:[
            self deleteObject:objectId.
            objectId := nil.
        ].
        self redraw
    ]

    "Modified: / 5.6.1998 / 04:10:25 / cg"
!

redraw 
    shown ifFalse:[^self].

    "
     define perspective-viewing
        0.0                                   200.0
    eye                                   
        near                                  far
    <)  -------------+------+-----------------+-------------------+
                     \      \                  \                   \
                      \      \                  \                   \
                       \      \                  \                   \
                        +------+                  \                   \
                                                   \                   \
                                                    \                   \
                                                     \                   \
                                                      \                   \
                                                       +-------------------+

         ---> negative z coordinates
    "

    "/ self perspectiveFovy:450 aspect:1.0 near:0.0 far:200.0. 

    drawLock critical:[
        self draw. 

        type == #colorIndexDoubleBuffer ifTrue:[
            self swapBuffers.
        ]
    ]
! !

!GLXYGraph methodsFor:'events'!

buttonPress:button x:x y:y
    button == 1 ifTrue:[
        "for debugging ..."
        self reconstructPicture
    ].
    super buttonPress:button x:x y:y
!

rotationChanged
    isAnimated ifTrue:[
        Processor yield
    ] ifFalse:[
        self redraw
    ].

    "Created: / 14.6.1998 / 17:33:01 / cg"
    "Modified: / 14.6.1998 / 17:35:04 / cg"
!

scaleChanged
    self redraw

    "Created: / 14.6.1998 / 17:34:32 / cg"
!

translationChanged
    isAnimated ifTrue:[
        Processor yield
    ] ifFalse:[
        self redraw
    ]

    "Created: / 14.6.1998 / 17:34:29 / cg"
    "Modified: / 14.6.1998 / 17:35:13 / cg"
! !

!GLXYGraph methodsFor:'initialization'!

destroy
    bgColorIndex >= 8 ifTrue:[
        "/ I have previously allocated some other color.
        "/ free it.
        self class freeColorSlot:bgColorIndex.
        bgColorIndex := Black.
    ].
    boxColorIndex >= 8 ifTrue:[
        "/ I have previously allocated some other color.
        "/ free it.
        self class freeColorSlot:boxColorIndex.
        boxColorIndex := Green.
    ].
    normalsColorIndex >= 8 ifTrue:[
        "/ I have previously allocated some other color.
        "/ free it.
        self class freeColorSlot:normalsColorIndex.
        normalsColorIndex := Red.
    ].
    gridColorIndex >= 8 ifTrue:[
        "/ I have previously allocated some other color.
        "/ free it.
        self class freeColorSlot:gridColorIndex.
        gridColorIndex := White.
    ].
    super destroy

    "Modified: / 5.6.1998 / 14:15:33 / cg"
!

initialize
    super initialize.

    "
     define the type of view;
        VGL supports #colorIndexSingleBuffer
                 and #colorIndexDoubleBuffer

        real GL additionaly supports
                     #rgbSingleBuffer
                 and #rgbDoubleBuffer
    "
    "
     this will work on any ...
    "
"/    type := #colorIndexSingleBuffer.
    type := #colorIndexDoubleBuffer.
    isAnimated := false.

    drawLock := RecursionLock new.

    rotXChannel := 0 asValue.
    rotYChannel := 0 asValue.
    rotZChannel := 0 asValue.

    transXChannel := 0.0 asValue.
    transYChannel := 0.0 asValue.
    transZChannel := -5.0 asValue.

    scaleZChannel := 1.0 asValue.

    drawNormalsChannel := true asValue.
    drawBoxChannel := false asValue.

    rotXChannel onChangeSend:#redraw to:self.
    rotYChannel onChangeSend:#redraw to:self.
    rotZChannel onChangeSend:#redraw to:self.
    transXChannel onChangeSend:#redraw to:self.
    transYChannel onChangeSend:#redraw to:self.
    transZChannel onChangeSend:#redraw to:self.

    scaleZChannel onChangeSend:#reconstructPicture to:self.

    drawNormalsChannel onChangeSend:#reconstructPicture to:self.
    drawBoxChannel onChangeSend:#reconstructPicture to:self.

    xMin := -1.0.
    xMax := 1.0.
    yMin := -1.0.
    yMax := 1.0.
    deltaX := 0.1.
    deltaY := 0.1.

    bgColor := Color black.
    bgColorIndex := Black.
    gridColor := Color white.
    gridColorIndex := White.
    boxColor := Color green.
    boxColorIndex := Green.
    normalsColor := Color red.
    normalsColorIndex := Red.

    functionBlock := [:x :y | 0].

    "Modified: / 14.6.1998 / 17:09:15 / cg"
!

realize
    super realize.
    self setupPerspecitve. 
!

reinitialize
    "when restarting from a snapshot, the GL state must be restored"

    objectId := nil.               "/ no longer valid.
    drawLock := RecursionLock new. "/ read comment in RecursionLock

    super reinitialize.

    self setupPerspecitve. 

    "/ force reallocation of GL-colors
    bgColorIndex := Black.
    gridColorIndex := White.
    boxColorIndex := Green.
    normalsColorIndex := Red.

    self backgroundColor:bgColor.
    self gridColor:gridColor.
    self boxColor:boxColor.
    self normalsColor:normalsColor.

    "Modified: / 7.6.1998 / 02:44:35 / cg"
!

setupPerspecitve
    self perspectiveFovy:450 aspect:1.0 near:0.0 far:200.0. 

    type == #colorIndexDoubleBuffer ifTrue:[
        self backBuffer
    ]
! !

!GLXYGraph methodsFor:'queries'!

specClass
    "redefined, to avoid an arbitrary spec"

    ^ GLXYGraphSpec

    "Modified: / 31.10.1997 / 19:48:48 / cg"
    "Created: / 5.6.1998 / 02:34:10 / cg"
! !

!GLXYGraph methodsFor:'release'!

unrealize
    super unrealize.
    objectId notNil ifTrue:[
	self deleteObject:objectId.
	objectId := nil
    ].

! !

!GLXYGraph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GLdemos/GLXYGraph.st,v 1.32 2016-01-21 18:05:43 cg Exp $'
! !

