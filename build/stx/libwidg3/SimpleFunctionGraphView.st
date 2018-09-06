"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

View subclass:#SimpleFunctionGraphView
	instanceVariableNames:'minXHolder maxXHolder minYHolder maxYHolder showUnitsXHolder
		showUnitsYHolder functionHolder showGridHolder gridColorHolder
		graphColorHolder unitColorHolder invalidColorHolder
		bufferedValues displayModeHolder markInvalidHolder gridX gridY'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!SimpleFunctionGraphView class methodsFor:'documentation'!

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
"

!

documentation
"
    UNDER CONSTRUCTION

    displays the graph of a function.
    TODO: grid & scale drawing.

    [author:]
        Claus Gittinger
"
!

examples
"
                                                [exBegin]
        |top graphView|

        top := StandardSystemView extent:300@300.
        graphView := SimpleFunctionGraphView origin:0.0@0.0 corner:1.0@1.0 in:top.

        graphView minXHolder:(-5 asValue).
        graphView maxXHolder:(5 asValue).
        graphView minYHolder:(-2 asValue).
        graphView maxYHolder:(2 asValue).

        graphView function:[:x | x sin].

        top open.
                                                [exEnd]
                                                [exBegin]
        |top graphView|

        top := StandardSystemView extent:300@300.
        graphView := SimpleFunctionGraphView origin:0.0@0.0 corner:1.0@1.0 in:top.

        graphView graphColorHolder:(Color white).
        graphView backgroundColor:Color black.
        graphView minXHolder:(-5 asValue).
        graphView maxXHolder:(5 asValue).
        graphView minYHolder:(-2 asValue).
        graphView maxYHolder:(2 asValue).

        graphView function:[:x | x sin].

        top open.
                                                [exEnd]
                                                [exBegin]
        |top graphView minX maxX|

        top := StandardSystemView extent:300@300.
        graphView := SimpleFunctionGraphView origin:0.0@0.0 corner:1.0@1.0 in:top.

        graphView graphColorHolder:(Color white).
        graphView backgroundColor:Color black.
        graphView minXHolder:(minX := -5 asValue).
        graphView maxXHolder:(maxX := 5 asValue).
        graphView minYHolder:(-2 asValue).
        graphView maxYHolder:(2 asValue).

        graphView function:[:x | x sin].

        top openAndWait.

        [
            [top realized] whileTrue:[
                Delay waitForSeconds:0.05.
                minX value:(minX value + 0.1).
                maxX value:(maxX value + 0.1).
            ]
        ] fork
                
                                                [exEnd]
                                                [exBegin]
        |top graphView functionList|

        functionList := OrderedCollection new.
        functionList add:[:x | x].
        functionList add:[:x | x * x].
        functionList add:[:x | x sqrt].
        functionList add:[:x | x sin].
        functionList add:[:x | x cos].
        functionList add:[:x | x tan].
        functionList add:[:x | x log].
        functionList add:[:x | 0].

        top := StandardSystemView extent:300@300.
        graphView := SimpleFunctionGraphView origin:0.0@0.0 corner:1.0@1.0 in:top.

        graphView graphColorHolder:(Color white).
        graphView backgroundColor:Color black.
        graphView minXHolder:(-5 asValue).
        graphView maxXHolder:(5 asValue).
        graphView minYHolder:(-2 asValue).
        graphView maxYHolder:(2 asValue).
        graphView displayModeHolder:(#lineMode asValue).

        graphView function:(functionList last).

        top openAndWait.

        [
            [top realized] whileTrue:[
                functionList do:[:funcBlock |
                    Delay waitForSeconds:1.
                    graphView displayModeHolder value:#dotMode.
                    Delay waitForSeconds:1.
                    graphView displayModeHolder value:#lineMode.
                    Delay waitForSeconds:1.
                    graphView displayModeHolder value:#dotMode.

                    Delay waitForSeconds:1.
                    graphView displayModeHolder value:#lineMode.
                    graphView functionHolder value:funcBlock.
                ]
            ]
        ] fork

                                                [exEnd]
"
! !

!SimpleFunctionGraphView methodsFor:'accessing'!

displayModeHolder
    "return the value of the instance variable 'displayModeHolder' (automatically generated)"

    ^ displayModeHolder

    "Created: / 28.10.1997 / 17:03:22 / cg"
!

displayModeHolder:something
    "set the value of the instance variable 'displayModeHolder' (automatically generated)"

    displayModeHolder notNil ifTrue:[displayModeHolder removeDependent:self].
    displayModeHolder := something.
    displayModeHolder notNil ifTrue:[displayModeHolder addDependent:self].

    "Modified: / 28.10.1997 / 15:55:53 / cg"
    "Created: / 28.10.1997 / 17:03:39 / cg"
!

function:aBlock
    self functionHolder:(aBlock asValue)

    "Created: / 28.10.1997 / 16:08:11 / cg"
    "Modified: / 28.10.1997 / 16:53:56 / cg"
!

functionHolder
    "return the value of the instance variable 'functionHolder' (automatically generated)"

    ^ functionHolder

    "Created: / 28.10.1997 / 16:53:35 / cg"
!

functionHolder:something
    "set the value of the instance variable 'functionHolder' (automatically generated)"

    functionHolder notNil ifTrue:[functionHolder removeDependent:self].
    functionHolder := something.
    functionHolder notNil ifTrue:[functionHolder addDependent:self].

    "Modified: / 28.10.1997 / 15:55:29 / cg"
    "Created: / 28.10.1997 / 16:53:47 / cg"
!

graphColorHolder
    "return the value of the instance variable 'graphColorHolder' (automatically generated)"

    ^ graphColorHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

graphColorHolder:something
    "set the value of the instance variable 'graphColorHolder' (automatically generated)"

    graphColorHolder notNil ifTrue:[graphColorHolder removeDependent:self].
    graphColorHolder := something.
    graphColorHolder notNil ifTrue:[graphColorHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:55:53 / cg"
!

gridColorHolder
    "return the value of the instance variable 'gridColorHolder' (automatically generated)"

    ^ gridColorHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

gridColorHolder:something
    "set the value of the instance variable 'gridColorHolder' (automatically generated)"

    gridColorHolder notNil ifTrue:[gridColorHolder removeDependent:self].
    gridColorHolder := something.
    gridColorHolder notNil ifTrue:[gridColorHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:56:16 / cg"
!

invalidColorHolder
    "return the value of the instance variable 'invalidColorHolder' (automatically generated)"

    ^ invalidColorHolder

    "Created: / 28.10.1997 / 17:30:38 / cg"
!

invalidColorHolder:something
    "set the value of the instance variable 'invalidColorHolder' (automatically generated)"

    invalidColorHolder notNil ifTrue:[invalidColorHolder removeDependent:self].
    invalidColorHolder := something.
    invalidColorHolder notNil ifTrue:[invalidColorHolder addDependent:self].

    "Modified: / 28.10.1997 / 15:55:53 / cg"
    "Created: / 28.10.1997 / 17:30:49 / cg"
!

markInvalidHolder
    "return the value of the instance variable 'markInvalidHolder' (automatically generated)"

    ^ markInvalidHolder

    "Created: / 28.10.1997 / 17:29:51 / cg"
!

markInvalidHolder:something
    "set the value of the instance variable 'markInvalidHolder' (automatically generated)"

    markInvalidHolder notNil ifTrue:[markInvalidHolder removeDependent:self].
    markInvalidHolder := something.
    markInvalidHolder notNil ifTrue:[markInvalidHolder addDependent:self].

    "Modified: / 28.10.1997 / 15:55:53 / cg"
    "Created: / 28.10.1997 / 17:30:10 / cg"
!

maxXHolder
    "return the value of the instance variable 'maxXHolder' (automatically generated)"

    ^ maxXHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

maxXHolder:something
    "set the value of the instance variable 'maxXHolder' (automatically generated)"

    maxXHolder notNil ifTrue:[maxXHolder removeDependent:self].
    maxXHolder := something.
    maxXHolder notNil ifTrue:[maxXHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:56:37 / cg"
!

maxYHolder
    "return the value of the instance variable 'maxYHolder' (automatically generated)"

    ^ maxYHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

maxYHolder:something
    "set the value of the instance variable 'maxYHolder' (automatically generated)"

    maxYHolder notNil ifTrue:[maxYHolder removeDependent:self].
    maxYHolder := something.
    maxYHolder notNil ifTrue:[maxYHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:56:54 / cg"
!

minXHolder
    "return the value of the instance variable 'minXHolder' (automatically generated)"

    ^ minXHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

minXHolder:something
    "set the value of the instance variable 'minXHolder' (automatically generated)"

    minXHolder notNil ifTrue:[minXHolder removeDependent:self].
    minXHolder := something.
    minXHolder notNil ifTrue:[minXHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:57:19 / cg"
!

minYHolder
    "return the value of the instance variable 'minYHolder' (automatically generated)"

    ^ minYHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

minYHolder:something
    "set the value of the instance variable 'minYHolder' (automatically generated)"

    minYHolder notNil ifTrue:[minYHolder removeDependent:self].
    minYHolder := something.
    minYHolder notNil ifTrue:[minYHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:57:06 / cg"
!

showGridHolder
    "return the value of the instance variable 'showGridHolder' (automatically generated)"

    ^ showGridHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

showGridHolder:something
    "set the value of the instance variable 'showGridHolder' (automatically generated)"

    showGridHolder notNil ifTrue:[showGridHolder removeDependent:self].
    showGridHolder := something.
    showGridHolder notNil ifTrue:[showGridHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:57:41 / cg"
!

showUnitsXHolder
    "return the value of the instance variable 'showUnitsXHolder' (automatically generated)"

    ^ showUnitsXHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

showUnitsXHolder:something
    "set the value of the instance variable 'showUnitsXHolder' (automatically generated)"

    showUnitsXHolder notNil ifTrue:[showUnitsXHolder removeDependent:self].
    showUnitsXHolder := something.
    showUnitsXHolder notNil ifTrue:[showUnitsXHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:57:59 / cg"
!

showUnitsYHolder
    "return the value of the instance variable 'showUnitsYHolder' (automatically generated)"

    ^ showUnitsYHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

showUnitsYHolder:something
    "set the value of the instance variable 'showUnitsYHolder' (automatically generated)"

    showUnitsYHolder notNil ifTrue:[showUnitsYHolder removeDependent:self].
    showUnitsYHolder := something.
    showUnitsYHolder notNil ifTrue:[showUnitsYHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:58:14 / cg"
!

unitColorHolder
    "return the value of the instance variable 'unitColorHolder' (automatically generated)"

    ^ unitColorHolder

    "Created: / 28.10.1997 / 15:54:02 / cg"
!

unitColorHolder:something
    "set the value of the instance variable 'unitColorHolder' (automatically generated)"

    unitColorHolder notNil ifTrue:[unitColorHolder removeDependent:self].
    unitColorHolder := something.
    unitColorHolder notNil ifTrue:[unitColorHolder addDependent:self].

    "Created: / 28.10.1997 / 15:54:02 / cg"
    "Modified: / 28.10.1997 / 15:58:35 / cg"
! !

!SimpleFunctionGraphView methodsFor:'change & update'!

sizeChanged:how
    bufferedValues := nil.
    self chooseGrid.
    self invalidate.
    super sizeChanged:how.

    "Created: / 28.10.1997 / 16:38:19 / cg"
    "Modified: / 28.10.1997 / 17:51:41 / cg"
!

update:something with:someArgument from:changedObject
    "something changed - for now, do a full redraw"

    |needFlush|

    "/ for some, there is no need to flush the buffered values ...

    needFlush := true.
    changedObject == displayModeHolder ifTrue:[
        needFlush := false.
    ].
    changedObject == showUnitsXHolder ifTrue:[
        needFlush := false.
    ].
    changedObject == showUnitsYHolder ifTrue:[
        needFlush := false.
    ].
    changedObject == showGridHolder ifTrue:[
        needFlush := false.
    ].
    changedObject == gridColorHolder ifTrue:[
        needFlush := false.
    ].
    changedObject == graphColorHolder ifTrue:[
        needFlush := false.
    ].
    changedObject == unitColorHolder ifTrue:[
        needFlush := false.
    ].

    "/ could move bufferedValues, if minX/maxX changes
    "/ and only recompute part of it ...

    (changedObject == minXHolder
    or:[changedObject == maxXHolder
    or:[changedObject == minYHolder
    or:[changedObject == maxYHolder]]]) ifTrue:[
        self chooseGrid
    ].

    "/ could simply rescale bufferedValues, in maxX/maxY changes ...

    needFlush ifTrue:[
        bufferedValues := nil.
    ].
    self invalidate

    "Created: / 28.10.1997 / 16:43:12 / cg"
    "Modified: / 28.10.1997 / 17:52:48 / cg"
! !

!SimpleFunctionGraphView methodsFor:'drawing'!

chooseGrid
    |yRange xRange nY nX|

    yRange := maxYHolder value - maxXHolder value.
    xRange := maxXHolder value - maxXHolder value.

    "/ for every centimeter on the display ...
    nY := 1 + (self innerHeight // (self verticalPixelPerMillimeter:10)).
    nX := 1 + (self innerWidth // (self horizontalPixelPerMillimeter:10)).

    "/ start in the center

    "Created: / 28.10.1997 / 17:51:23 / cg"
    "Modified: / 28.10.1997 / 17:56:45 / cg"
!

computeGraph
    "compute the graph"

    |nSteps minX maxX minY maxY 
     rangeY scaleY stepX function 
     xV|

    nSteps := self innerWidth.

    xV := self margin.

    bufferedValues := Array new:nSteps.

    function := functionHolder value.
    minX := minXHolder value.
    maxX := maxXHolder value.
    minY := minYHolder value.
    maxY := maxYHolder value.
    rangeY := (maxY - minY).
    scaleY := (self innerHeight / rangeY).
    stepX := (maxX - minX) / nSteps.

    "/ dont add up stepX, to avoid accumulating rounding errors.

    1 to:nSteps do:[:step |
        |x fx y|

        x := minX + ((step - 1) * stepX).

        Number arithmeticSignal handle:[:ex |
            y := nil
        ] do:[
            fx := function value:x.

            "/ scale into my y-range
            y := (fx - minY) * scaleY.
            y := (height - y) rounded.
        ].
        bufferedValues at:step put:y.

        xV := xV + 1.
    ].

    "Created: / 28.10.1997 / 16:35:36 / cg"
    "Modified: / 28.10.1997 / 17:00:41 / cg"
!

redrawX:x y:y width:w height:h
    "redraw the graph"

    |nSteps lastY xV markInvalid invalidColor|

    shown ifFalse:[^ self].

    bufferedValues isNil ifTrue:[
        self computeGraph
    ].

    nSteps := self innerWidth min:w.

    self clippingBounds:(x@y extent:w@h).

    self clear.
    self paint:(graphColorHolder value ? self blackColor).

    xV := self margin.

    markInvalid := markInvalidHolder value ? true.
    invalidColor := invalidColorHolder value ? (Color red darkened).

    (displayModeHolder value ? #lineMode) == #lineMode ifTrue:[
        "/ display graph by connecting lines

        lastY := bufferedValues at:1.
        2 to:nSteps do:[:step |
            |y|

            y := bufferedValues at:step.
            y notNil ifTrue:[
                lastY notNil ifTrue:[
                    self displayLineFromX:(xV - 1) y:lastY toX:xV y:y.
                ]
            ] ifFalse:[
                markInvalid ifTrue:[
                    self paint:invalidColor.
                    self displayLineFromX:xV y:margin toX:xV y:(height-margin-1).
                    self paint:(graphColorHolder value ? self blackColor)
                ]
            ].
            lastY := y.
            xV := xV + 1.
        ].
        ^ self
    ].

    "/ display graph as dots

    1 to:nSteps do:[:step |
        |y|

        y := bufferedValues at:step.
        y notNil ifTrue:[
            self displayPointX:xV y:y.
        ] ifFalse:[
            markInvalid ifTrue:[
                self paint:invalidColor.
                self displayLineFromX:xV y:margin toX:xV y:(height-margin-1).
                self paint:(graphColorHolder value ? self blackColor)
            ]
        ].
        xV := xV + 1.
    ].

    "Created: / 28.10.1997 / 18:06:51 / cg"
    "Modified: / 28.10.1997 / 18:12:00 / cg"
!

test:arg
    "redraw the graph"

    |lastY bufferedValues nSteps xV|

    nSteps := 3.
    xV := 0.
    bufferedValues := Array with:1 with:2 with:3.

    (arg value ? #lineMode) == #lineMode ifTrue:[
        lastY := bufferedValues at:1.
        2 to:nSteps do:[:step |
            |y|

            y := bufferedValues at:step.
            y isNumber ifFalse:[self halt].
            lastY isNumber ifFalse:[self halt].
            lastY := y.
            xV := xV + 1.
        ].
    ].

    "
     self basicNew test:nil
    "

    "Created: / 28.10.1997 / 18:04:32 / cg"
    "Modified: / 28.10.1997 / 18:05:50 / cg"
! !

!SimpleFunctionGraphView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/SimpleFunctionGraphView.st,v 1.4 2017-01-20 17:53:18 cg Exp $'
! !

