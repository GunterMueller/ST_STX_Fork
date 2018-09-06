"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
"{ Package: 'stx:clients/LogicTool' }"

"{ NameSpace: Demos }"

ObjectView subclass:#LogicView
	instanceVariableNames:'gates connections createClass createdObject startPoint fromGate
		fromPin toPoint disconnecting warnBox simBlock simProcess
		simulating showNames showValues placeCursor connectCursor
		disconnectCursor'
	classVariableNames:'SimulationDelay'
	poolDictionaries:''
	category:'demos-LogicTool'
!

!LogicView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    a view, which holds logic objects (gates & connections)
    and animates them.

    This is a very old example - one of the first working ST/X demos.
    I would do it different today.
    Do not take this as an example for 'good' programming style.
    -----------------------------------------------------------

    [author:]
        Claus Gittinger (spring/summer 89)

    [start with:]
        LogicTool open
"
! !

!LogicView class methodsFor:'initialization'!

initialize
    SimulationDelay := self defaultSimulationDelay
! !

!LogicView class methodsFor:'defaults'!

defaultSimulationDelay
    ^ 0.1 "/ seconds
!

gridShown
    ^ false
!

hitDelta
    "when clicking an object, allow for hitDelta pixels around object;
     0 is exact; 4 is good for draw programs"
    ^ 4
! !

!LogicView methodsFor:'adding / removing'!

addObject:anObject
    "add the argument, anObject to the contents - with redraw"

    anObject notNil ifTrue:[
        (anObject isKindOf:Connection) ifTrue:[
            connections addLast:anObject
        ] ifFalse:[
            gates addLast:anObject
        ].
        anObject font:font.
        super addObject:anObject
    ]

    "Modified: 10.4.1996 / 22:55:12 / cg"
!

addObjectWithoutRedraw:anObject
    "add the argument, anObject to the contents - withOut redraw"

    anObject notNil ifTrue:[
        (anObject isKindOf:Connection) ifTrue:[
            connections addLast:anObject
        ] ifFalse:[
            gates addLast:anObject
        ].
        anObject font:font.
        super addObjectWithoutRedraw:anObject
    ]

    "Created: 10.4.1996 / 22:52:05 / cg"
    "Modified: 10.4.1996 / 22:55:07 / cg"
!

removeAll
    "remove all gates & connections"

    gates := OrderedCollection new.
    connections := OrderedCollection new.
    super removeAll
!

removeConnectionsWith:aGate
    "remove all connections from/to aGate"

    self connectionsWith:aGate do:[:aConnection |
	self removeConnection:aConnection
    ]
!

removeObject:anObject
    "remove the argument, anObject from the contents;
     if its a gate, also remove its connections"

    anObject notNil ifTrue:[
	(contents includes:anObject) ifTrue:[
	    super removeObject:anObject
	].
	(anObject isKindOf:Connection) ifTrue:[
	    (connections includes:anObject) ifTrue:[
		connections remove:anObject
	    ]
	] ifFalse:[
	    self removeConnectionsWith:anObject.
	    gates remove:anObject
	]
    ]
! !

!LogicView methodsFor:'connections'!

connectFrom:gate1 pin:pin1 to:gate2 pin:pin2
    |connection bad input output inputPin outputPin inputNr outputNr|

    "check if valid connection"

    (gate1 == gate2
    and:[pin1 = pin2]) ifTrue:[^ self].

    (gate1 isInput:pin1) ifTrue:[
	input := gate1.
	inputPin := pin1.
	(gate2 isInput:pin2) ifTrue:[
	    "connecting 2 inputs"
	    warnBox title:'cannot connect 2 inputs'.
	    warnBox showAtPointer.
	    ^ self
	].
	output := gate2.
	outputPin := pin2
    ] ifFalse:[
	output := gate1.
	outputPin := pin1.
	(gate2 isOutput:pin2) ifTrue:[
	    "connecting 2 outputs"
	    warnBox title:'cannot connect 2 outputs'.
	    warnBox showAtPointer.
	    ^ self
	].
	input := gate2.
	inputPin := pin2
    ].
    "look if the input is already connected"
    inputNr := input whichInput:inputPin.
    outputNr := output whichOutput:outputPin.
    inputNr isNil ifTrue:[
	self error:'oops - input'
    ].
    outputNr isNil ifTrue:[
	self error:'oops - output'
    ].

    bad := false.
    self connectionsWith:input do:[:aConnection |
	(aConnection dstGate == input) ifTrue:[
	    (aConnection dstPinNr == inputNr) ifTrue:[
		"input is already connected to another output"
		bad := true
	    ]
	]
    ].
    bad ifTrue:[
	warnBox title:'indirectly connects 2 outputs'.
	warnBox showAtPointer.
	^ self
    ].
    connection := Connection from:output pin:outputNr to:input pin:inputNr.
    contents add:connection.
    connections add:connection.
    connection drawIn:self.
    self simulate
!

drawConnectionFrom:point1 to:point2
    self displayLineFromX:(point1 x) y:(point1 y) toX:(point2 x) y:(point2 y)
!

removeConnection:aConnection
    contents remove:aConnection.
    connections remove:aConnection.
    self redrawObjectsIn:(aConnection frame).
    self simulate
! !

!LogicView methodsFor:'cut & paste '!

convertForPaste:anObject
    "return a converted version of anObject to be pasted, or nil if
     the object is not compatible with me.
     Notice: anObject may be a collection of to-be-pasted objects."

    |s|

    (anObject respondsTo:#asLogicObject) ifTrue:[
	^ anObject asLogicObject
    ].
    anObject size > 0 ifTrue:[
	(anObject inject:true into:[:okSoFar :element |
	    okSoFar and:[element respondsTo:#asLogicObject]
	]) ifFalse:[
	    ^ nil
	].
	^ anObject collect:[:element | element asLogicObject].
    ].
    ^ nil.
! !

!LogicView methodsFor:'events'!

keyPress:key x:x y:y
    |gate|

    key == $z ifTrue:[
	self zoomIn
    ].
    key == $Z ifTrue:[
	self zoomOut
    ].
    gate := self findGateAt:x@y.
    gate notNil ifTrue:[
	(gate isKindOf:Input) ifTrue:[
	    gate click.
	    self show:gate
	]
    ]
! !

!LogicView methodsFor:'initializing'!

destroy
    self stopSimulation.
    super destroy
!

initialize
    super initialize.

    self initializeCursors.

    disconnecting := false.
    simulating := false.
    showNames := false.
    showValues := false.
    simBlock := [self simulate].
    gates := OrderedCollection new.
    connections := OrderedCollection new.

    self setupStandardActions.

    warnBox := WarningBox title:'connects 2 inputs'.

    connectCursor isNil ifTrue:[
	self class initializeCursors
    ].
    self cursor:connectCursor
!

initializeCursors
    "a soldering iron ..."
    connectCursor := 
        Cursor
         sourceForm:(Image fromFile:'bitmaps/solder.xbm' resolution:100)
           maskForm:(Image fromFile:'bitmaps/solderM.xbm' resolution:100)
            hotSpot:(0 @ 15).

    "a cutter ..."
    disconnectCursor := 
        Cursor
         sourceForm:(Image fromFile:'bitmaps/cutter.xbm' resolution:100)
           maskForm:(Image fromFile:'bitmaps/cutterM.xbm' resolution:100)
            hotSpot:(7 @ 3).

"/    placeCursor := 
"/        Cursor
"/         sourceForm:(Form fromFile:'place.xbm' resolution:100)
"/           maskForm:(Form fromFile:'placeM.xbm' resolution:100)
"/            hotSpot:(0 @ 0)

    disconnectCursor isNil ifTrue:[
        disconnectCursor := Cursor arrow.
    ].
    connectCursor isNil ifTrue:[
        connectCursor := Cursor arrow.
    ].
    placeCursor isNil ifTrue:[
        placeCursor := Cursor fourWay.
    ].

    "Modified: 24.1.1997 / 18:00:13 / cg"
!

setupStandardActions
    pressAction := [:pressPoint | self startConnectOrMove:pressPoint].
    shiftPressAction := [:pressPoint | self startSelectMoreOrMove:pressPoint].
    motionAction := [:movePoint | self doObjectMove:movePoint].
    releaseAction := [self endObjectMove].
    doublePressAction := [:pressPoint | self clickOnObject:pressPoint]
! !

!LogicView methodsFor:'interface to LogicTool'!

connect
    disconnecting := false.
    self cursor:connectCursor
!

createObjectWithClass:aClass
    "prepare for object creation with next click.
     (sent from the element buttons in LogicTool"

    createClass := aClass.
    pressAction := [:pressPoint | self startCreate:pressPoint].
    shiftPressAction := pressAction.
    motionAction := [:movePoint | nil].
    releaseAction := [nil].
    self cursor:placeCursor
!

disconnect
    disconnecting := true.
    self cursor:disconnectCursor
!

dontShowNames
    showNames := false.
    self redraw
!

group
    |subCircuit minx miny buffer|

    subCircuit := SubCircuit createFrom:selection.
    buffer := selection.
    self unselect.
    self forEach:buffer do:[:anObject |
	(anObject isKindOf:Connection) ifFalse:[
	    minx isNil ifTrue:[
		minx := anObject origin x.
		miny := anObject origin y
	    ] ifFalse:[
		minx := minx min:(anObject origin x).
		miny := miny min:(anObject origin y)
	    ].
	    self removeObject:anObject
	]
    ].
    selection := nil.
    subCircuit origin:(minx @ miny).
    contents add:subCircuit.
    gates add:subCircuit.
    self select:subCircuit
!

showNames
    showNames := true.
    self redraw
! !

!LogicView methodsFor:'misc'!

assignIdFor:aGate
    |gateClass genName number|
    gateClass := aGate class.
    genName := gateClass genericName.
    number := 0.
    gates notNil ifTrue:[
	gates do:[:anotherGate |
	    (anotherGate class genericName = genName) ifTrue:[
		(anotherGate id > number) ifTrue:[
		    number := anotherGate id
		]
	    ]
	]
    ].
    aGate id:(number + 1).
    aGate name:(genName) , '-' , (number + 1) printString.
    aGate font:font
!

connectionsWith:aGate do:aBlock
    "evaluate aBlock for all connections from/to aGate"

    connections do:[:aConnection |
	aConnection notNil ifTrue:[
	    (aConnection srcGate == aGate) ifTrue:[
		aBlock value:aConnection
	    ] ifFalse:[
		(aConnection dstGate == aGate) ifTrue:[
		    aBlock value:aConnection
		]
	    ]
	]
    ]
!

drawValues
    gates do:[:aGate |
	self drawValuesOf:aGate
    ]
!

drawValuesOf:aGate
    |outputNr s p|

    self paint:Black.
    outputNr := 1.
    aGate outputPinsDo:[:aPinLocation |
        s := aGate displayStringFor:(aGate output:outputNr).
        p := aPinLocation.
        self displayOpaqueString:s x:(p x - font width)
                                   y:(p y - font descent).
        outputNr := outputNr + 1
    ]

    "Modified: 5.4.1997 / 17:27:31 / cg"
!

findGateNamed:aString
    |theGate|

    gates notNil ifTrue:[
        gates do:[:aGate |
            (aString = aGate name) ifTrue:[
                theGate notNil ifTrue:[
                    self error:'duplicate name'
                ].
                theGate := aGate
            ]
        ]
    ].
    ^ theGate

    "Modified: 10.4.1996 / 22:50:35 / cg"
!

nameSelection:aName
    self selectionDo:[:anObject |
	(anObject isKindOf:Connection) ifFalse:[
	    anObject name:aName.
	    anObject font:font.
	    anObject drawIn:self
	]
    ]
!

normalCursor
    disconnecting ifTrue:[
	self cursor:disconnectCursor
    ] ifFalse:[
	self cursor:connectCursor
    ].
! !

!LogicView methodsFor:'saving / restoring'!

initializeFileInObject:newObject
    "since connections are filed out with named-gates but internally have
     links to the real gates, we have to transform here"

    |srcGate dstGate|

    (newObject isKindOf:Connection) ifTrue:[
	srcGate := self findGateNamed:(newObject srcGate).
	dstGate := self findGateNamed:(newObject dstGate).
	newObject srcGate:srcGate dstGate:dstGate
    ]
!

storeContentsOn:aStream
    |excla|

    excla := aStream class chunkSeparator.
    "have to store gates first, then connections"
    self forEach:gates do:[:theObject |
	theObject storeOn:aStream.
	aStream nextPut:excla.
	aStream cr
    ].
    self forEach:connections do:[:theObject |
	theObject storeOn:aStream.
	aStream nextPut:excla.
	aStream cr
    ].
    aStream nextPut:excla
! !

!LogicView methodsFor:'select or move'!

clickOnObject:aPoint
    |aGate|

    aGate := self findGateAt:aPoint.
    aGate notNil ifTrue:[
	aGate click.
	connections do:[:aConnection |
	    aConnection propagate
	].
	aGate changedPicture ifTrue:[
	    aGate drawIn:self.
	    aGate unchangedPicture
	].
	"/ self simulate
    ]
!

doDragConnection:aPoint
    |newPoint|
	toPoint := aPoint.
super doLineDrag:aPoint.
^ self.
    newPoint := aPoint.
    newPoint x == lastButt x ifTrue:[
	newPoint y == lastButt y ifTrue:[^ self]
    ].
    fromPin notNil ifTrue:[
	toPoint isNil ifFalse:[
	    "invert prev. drag"
	    self xoring:[self drawConnectionFrom:fromPin to:toPoint]
	].
	"invert new drag"
	toPoint := newPoint.
	self xoring:[self drawConnectionFrom:fromPin to:toPoint]
    ]
!

endConnection
    |toGate toPin|

    self invertDragLine.

    motionAction := [:movePoint | nil].
    releaseAction := [nil].
    fromPin notNil ifTrue:[
	toPoint notNil ifTrue:[
	    "invert prev. drag"
"/            self xoring:[self drawConnectionFrom:fromPin to:toPoint].

	    toGate := self findGateAt:toPoint.

	    "ok, this one hits an object - look for i/o pins"
	    toGate notNil ifTrue:[
		toGate pinsDo:[:thePin |
		    (self pin:thePin isHitBy:toPoint) ifTrue:[
			toPin := thePin
		    ]
		]
	    ].
	    "if we found a pin, do the connect"

	    toPin notNil ifTrue:[
		self connectFrom:fromGate pin:fromPin to:toGate pin:toPin
	    ]
	].
	fromGate := nil.
	fromPin := nil.
	toPoint := nil
    ]
!

endCreate
    self normalCursor.
    self setupStandardActions
!

endObjectMove
    super endObjectMove.
    self normalCursor.
!

lineDragFrom:fromPoint to:toPoint
    |toGate toPin|

    fromPin notNil ifTrue:[
	toPoint notNil ifTrue:[
	    "invert prev. drag"
"/            self xoring:[self drawConnectionFrom:fromPin to:toPoint].

	    toGate := self findGateAt:toPoint.

	    "ok, this one hits an object - look for i/o pins"
	    toGate notNil ifTrue:[
		toGate pinsDo:[:thePin |
		    (self pin:thePin isHitBy:toPoint) ifTrue:[
			toPin := thePin
		    ]
		]
	    ].
	    "if we found a pin, do the connect"

	    toPin notNil ifTrue:[
		self connectFrom:fromGate pin:fromPin to:toGate pin:toPin
	    ]
	].
	fromGate := nil.
	fromPin := nil.
    ]
!

moveCreate:newOrigin
    "when creating, change the position of createdObject while the button
     is down"

    |sel oldFrame oldConnectionFrames connectionsWithGate|
    createdObject notNil ifTrue:[
	(createdObject origin = newOrigin) ifFalse:[
	    oldFrame := self frameOf:createdObject.
	    createdObject moveTo:newOrigin - (createdObject extent // 2).
	    self redrawObjectsIn:oldFrame.
	    (self isObscured:createdObject) ifFalse:[
		createdObject drawIn:self
	    ] ifTrue:[
		self redrawObjectsIn:(self frameOf:createdObject)
	    ]
	]
    ]
!

moveObject:anObject to:newOrigin
    "change the position on anObject to newOrigin, aPoint"

    |sel oldFrame oldConnectionFrames connectionsWithGate|
    anObject notNil ifTrue:[
	anObject canBeMoved ifTrue:[
	    (anObject origin = newOrigin) ifFalse:[
		oldFrame := self frameOf:anObject.
		connectionsWithGate := OrderedCollection new.
		oldConnectionFrames := OrderedCollection new.
		self connectionsWith:anObject do:[:aConnection |
		    connectionsWithGate add:aConnection.
		    oldConnectionFrames add:(aConnection frame)
		].
		anObject moveTo:newOrigin.
		self connectionsWith:anObject do:[:aConnection |
		    aConnection computeBoundingBox
		].

		self redrawObjectsIn:oldFrame.
		oldConnectionFrames do:[:aFrame |
		    aFrame notNil ifTrue:[
			self redrawObjectsIn:aFrame
		    ]
		].
		(self isObscured:anObject) ifFalse:[
		    anObject drawIn:self
		] ifTrue:[
		    self redrawObjectsIn:(self frameOf:anObject)
		].
		connectionsWithGate do:[:aConnection |
		    aConnection notNil ifTrue:[
			aConnection drawIn:self
		    ]
		]
	    ]
	]
    ]
!

startConnectFrom:aGate pin:aPin

    fromGate := aGate.
    fromPin := aPin.
    self startRootLineDrag:aPin.
"/    self startLineDrag:aPin.
    motionAction := [:movePoint | self doDragConnection:movePoint].

!

startConnectOrMove:aPoint
    |aGate aPin|

    "if connecting, do not consider connections"
    disconnecting ifTrue:[
	aGate := self findObjectAt:aPoint
    ] ifFalse:[
	aGate := self findGateAt:aPoint
    ].

    "
     clicked on a connection
    "
    (aGate isKindOf:Connection) ifTrue:[
	disconnecting ifTrue:[
	    self removeConnection:aGate
	].
	^ self
    ].

    "ok, this one hits a gate - look for i/o pins"
    aGate notNil ifTrue:[
	aGate pinsDo:[:thePin |
	    (self pin:thePin isHitBy:aPoint) ifTrue:[
		aPin := thePin
	    ]
	]
    ].

    "if we found a pin, this starts a connect"
    aPin notNil ifTrue:[
	disconnecting ifFalse:[
	    self startConnectFrom:aGate pin:aPin.
	].
	^ self
    ].

    "if we found a gate, this starts an objectMove"
    aGate notNil ifTrue:[
	self startObjectMove:aGate at:aPoint.
rootMotion := true.
	^ self
    ].
    "otherwise a multi-select"
    self startRectangleDrag:aPoint
!

startCreate:aPoint
    startPoint := aPoint "grid:grid".
    createClass notNil ifTrue:[
	self unselect.
	createdObject := createClass new.
	createdObject origin:startPoint.

	motionAction := [:movePoint | self moveCreate:movePoint].
	releaseAction := [self endCreate].

	self assignIdFor:createdObject.
	contents add:createdObject.
	gates add:createdObject.
	"
	 must set origin here, after id is assigned;
	 otherwise, object returns extent without space for the name
	"
	createdObject origin:startPoint - (createdObject extent // 2).
	createdObject drawIn:self
    ]
!

startObjectMove:something at:aPoint
    self cursor:placeCursor.
    super startObjectMove:something at:aPoint
! !

!LogicView methodsFor:'selections'!

findGateAt:aPoint
    "find the first gate (by looking from front to back) which is hit by
     the argument, aPoint"

    |hdelta|

    hdelta := self hitDelta.
    gates do:[:object |
	(object isHitBy:aPoint withDelta:hdelta) ifTrue: [
	    ^ object
	]
    ].
    ^ nil
!

pin:pinPoint isHitBy:aPoint
    ^ (self pinHandleFor:pinPoint) containsPoint:aPoint
!

pinHandleFor:aPoint
    |hsize centerX centerY|

    hsize := self hitDelta.
    centerX := aPoint x.
    centerY := aPoint y.
    ^ Rectangle left:(centerX - hsize)
		 top:(centerY - hsize)
	       right:(centerX + hsize)
	      bottom:(centerY + hsize)
! !

!LogicView methodsFor:'simulation'!

hideValues
    showValues :=  false
!

showValues 
    showValues ifFalse:[
	showValues := true.
	self drawValues
    ]
!

simulate
    gates isNil ifTrue:[^ self].
    connections do:[:aConnection |
        aConnection notNil ifTrue:[
            aConnection propagate
        ]
    ].
    gates do:[:aGate |
        aGate evaluate.
        aGate changedPicture ifTrue:[
            aGate drawIn:self.
            aGate unchangedPicture
        ].
        aGate changed ifTrue:[
            showValues ifTrue:[
                self drawValuesOf:aGate
            ].
            aGate unchanged
        ]
    ]

    "Modified: 10.9.1996 / 21:25:59 / cg"
!

startSimulation
    simulating ifFalse:[
        ProcessorScheduler isPureEventDriven ifTrue:[
            Processor addIdleBlock:simBlock.
        ] ifFalse:[
            simProcess := [
                [true] whileTrue:[
                    self simulate.
                    SimulationDelay notNil ifTrue:[
                        Delay waitForMilliseconds:SimulationDelay.
                    ]
                ]
            ] forkAt:(Processor userBackgroundPriority).
        ].
        simulating := true
    ]

    "Modified: 5.4.1997 / 17:39:19 / cg"
!

stopSimulation
    simulating ifTrue:[
	ProcessorScheduler isPureEventDriven ifTrue:[
	    Processor removeIdleBlock:simBlock.
	] ifFalse:[
	    simProcess terminate.
	    simProcess := nil
	].
	simulating := false
    ]
! !

!LogicView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/LogicTool/LogicView.st,v 1.18 2008-02-27 17:34:06 cg Exp $'
! !

LogicView initialize!
