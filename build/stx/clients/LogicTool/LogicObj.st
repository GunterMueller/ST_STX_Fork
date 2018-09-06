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

DisplayObject subclass:#LogicObject
	instanceVariableNames:'origin inputValues outputValues oldOutputValues changed
		changedPicture name font id delay'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-LogicTool-Objects'
!

LogicObject class instanceVariableNames:'Icon'

"
 No other class instance variables are inherited by this class.
"
!

!LogicObject class methodsFor:'documentation'!

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
    any gate

    abstract superclass for all circuit elements; since all are gates
    with a little picture (icon) for it this is all done here.
    They only differ in how they evaluate their outputValues from the input
    values and where their pins are in the picture - these methods are
    defined in the specific subclasses (AndGate, OrGate etc.)

    [author:]
        Claus Gittinger (summer 89)
"





! !

!LogicObject class methodsFor:'specification'!

delay
    ^ 10        "pico-seconds"
!

dragOutline
    "if true, dragging is done by drawing outline only;
     if false, dragging is done by full draw (fast servers only)
     - can be redefined in subclasses"
    ^ true
!

flushIcon
    Icon := nil
!

flushIcons
    self withAllSubclassesDo:[:eachClass |
        eachClass flushIcon
    ].

    "
     self flushIcons
    "
!

genericName
    ^ self name
!

icon
    Icon isNil ifTrue:[
        Icon := self iconForFilename:self iconFileName.
    ].
    ^ Icon

    "
     self flushIcons
    "
!

iconExtent
    ^ 64 @ 64
!

iconFileName
    ^ self nameWithoutPrefix , '.64.xbm'

    "Modified: 24.1.1997 / 17:56:32 / cg"
!

iconForFilename:iconFileName
    |fn icon|

    fn := 'bitmaps/' , iconFileName.
    icon := Image fromFile:fn resolution:100.
    icon isNil ifTrue:[
        icon := Smalltalk imageFromFileNamed:fn forClass:self.
    ].
    "/ icon := icon magnifiedTo:40@40.
    ^ icon
!

new
    |newGate|

    newGate := super new.
    newGate numberOfInputs:(self numberOfInputs).
    newGate numberOfOutputs:(self numberOfOutputs).
    newGate initialize.
    ^ newGate
!

numberOfInputs
    self subclassResponsibility
!

numberOfOutputs
    self subclassResponsibility
! !

!LogicObject methodsFor:'accessing'!

changed
    ^ changed
!

changedPicture
    ^ changedPicture
!

computeBoundingBox
    |icon iconWidth iconHeight textWidth textHeight myWidth myHeight|

    icon := self class icon.
    icon isNil ifTrue:[
        iconWidth := 16. "/ self width.
        iconHeight := 16. "/ self height
    ] ifFalse:[
        iconWidth := icon width.
        iconHeight := icon height
    ].
    textWidth := 0.
    textHeight := 0.
    font notNil ifTrue:[
        name isNil ifFalse:[
            textWidth := font widthOf:name.
            textHeight := font height
        ]
    ].
    myWidth := iconWidth max:textWidth.
    myHeight := iconHeight + 2 + textHeight.
    frame := Rectangle origin:origin extent:(myWidth @ myHeight)

    "Modified: / 15.9.1998 / 22:49:33 / cg"
!

font:aFont
    font := aFont.
    self computeBoundingBox
!

hasFixedSize
    ^ true
!

icon
    ^ self class icon
!

id
    ^ id
!

id:aNumber
    id := aNumber
!

input:pin value:logicValue
    inputValues at:pin put:logicValue
!

inputPinLocation:inputNr
    "answer the x/y coordinate as point of an input"

    |delta|

    delta := self pictureHeight // (self numberOfInputs + 1).
    ^ (origin x) @ (origin y + (delta * inputNr))
!

inputPinsDo:aBlock
    "this code assumes, that all inputs are at the left of the picture,
     in height/(nInput+1) pixels space"

    |xpos ypos delta i n|

    delta := self pictureHeight // (self numberOfInputs + 1).
    xpos := origin x.
    ypos := origin y + delta.
    i := 1.
    n := self numberOfInputs.
    [i <= n] whileTrue:[
	aBlock value:(xpos @ ypos).
	ypos := ypos + delta.
	i := i + 1
    ]
!

isInput:aPoint
    "answer true, if aPoint is an input pin"

    ^ (self whichInput:aPoint) notNil
!

isOutput:aPoint
    "answer true, if aPoint is an output pin"

    ^ (self whichOutput:aPoint) notNil
!

moveTo:newOrigin
    origin := newOrigin.
    self computeBoundingBox
!

name
    ^ name
!

name:aString
    name := aString.
    self computeBoundingBox
!

numberOfInputs
    ^ inputValues size
!

numberOfOutputs
    ^ outputValues size
!

origin
    ^ origin
!

origin:aPoint
    origin := aPoint.
    self computeBoundingBox
!

output:pin
    ^ outputValues at:pin
!

outputPinLocation:inputNr
    "answer the x/y coordinate as point of an output"

    |delta|

    delta := self pictureHeight // (self numberOfOutputs + 1).
    ^ (origin x + self width - 1) @ (origin y + (delta * inputNr))
!

outputPinsDo:aBlock
    "this code assumes, that all outputs are at the right of the picture,
     in height/(nOutput+1) pixels space"

    |xpos ypos delta i n|

    delta := self pictureHeight // (self numberOfOutputs + 1).
    xpos := origin x + self width - 1.
    ypos := origin y + delta.
    i := 1.
    n := self numberOfOutputs.
    [i <= n] whileTrue:[
	aBlock value:(xpos @ ypos).
	ypos := ypos + delta.
	i := i + 1
    ]
!

pictureHeight
    |icon|

    icon := self class icon.
    icon isNil ifTrue:[
	^ self height
    ].
    ^ icon height
!

pinsDo:aBlock
    "evaluate aBlock for each pin"

    self inputPinsDo:aBlock.
    self outputPinsDo:aBlock
!

unchanged
    changed := false
!

unchangedPicture
    changedPicture := false
!

whichInput:aPoint
    "this code assumes, that all inputs are at the left of the picture,
     in height/(nInput+1) pixels space"

    |xpos ypos delta i n|

    delta := self pictureHeight // (self numberOfInputs + 1).
    xpos := origin x.
    ypos := origin y + delta.
    i := 1.
    n := self numberOfInputs.
    [i <= n] whileTrue:[
	(xpos = aPoint x) ifTrue:[
	    (ypos = aPoint y) ifTrue:[
		^ i
	    ]
	].
	ypos := ypos + delta.
	i := i + 1
    ].
    ^ nil
!

whichOutput:aPoint
    "this code assumes, that all outputs are at the right of the picture,
     in height/(nInput+1) pixels space"

    |xpos ypos delta i n|

    delta := self pictureHeight // (self numberOfOutputs + 1).
    xpos := origin x + self width - 1.
    ypos := origin y + delta.
    i := 1.
    n := self numberOfOutputs.
    [i <= n] whileTrue:[
	(xpos = aPoint x) ifTrue:[
	    (ypos = aPoint y) ifTrue:[
		^ i
	    ]
	].
	ypos := ypos + delta.
	i := i + 1
    ].
    ^ nil
! !

!LogicObject methodsFor:'converting'!

asLogicObject
    ^ self
! !

!LogicObject methodsFor:'defaults'!

defaultOutputValue
    ^ false

    "Created: 5.4.1997 / 17:24:00 / cg"
!

unconnectedInputValue
    ^ true

    "Created: 5.4.1997 / 17:23:51 / cg"
! !

!LogicObject methodsFor:'drawing'!

displayStringFor:value
    ^ value ifTrue:['1'] ifFalse:['0'].

    "Created: 5.4.1997 / 17:26:46 / cg"
!

doDrawIn:aGC offset:anOffset
    |icon x y w h|

    icon := self icon.
    x := origin x + anOffset x.
    y := origin y + anOffset y.
    aGC clearRectangleX:x y:y width:(frame width) height:(frame height).
    icon isNil ifTrue:[
        aGC displayRectangle:frame.
        w := frame width.
        h := frame height.
    ] ifFalse:[
        aGC displayOpaqueForm:icon x:x y:y.
        w := icon width.
        h := icon height.
    ].
    name notNil ifTrue:[
        font isNil ifTrue:[
            font := aGC font
        ].
        font := font onDevice:aGC device.
        aGC displayOpaqueString:name x:x
                                     y:(y + h + font ascent)
    ]

    "Modified: / 27.7.1998 / 20:13:11 / cg"
!

drawIn:aGC
    self drawIn:aGC offset:0@0
!

drawIn:aGC offset:anOffset
    aGC paint:(Color black) on:(Color white).
    self doDrawIn:aGC offset:anOffset
!

drawSelectedIn:aGC
    self drawSelectedIn:aGC offset:0@0
!

drawSelectedIn:aGC offset:anOffset
    "draw the receiver highlighted - this is usually redefined"

    aGC device hasColors ifTrue:[
	aGC paint:(Color red:100 green:0 blue:0).
	self doDrawIn:aGC offset:anOffset
    ] ifFalse:[
	self drawIn:aGC offset:anOffset.
	self drawOutlineIn:aGC offset:anOffset
    ]
! !

!LogicObject methodsFor:'initializing'!

initialize
    super initialize.
    changedPicture := false.
    changed := false
!

numberOfInputs:aNumber
    inputValues := Array new:aNumber.
    inputValues atAllPut:(self unconnectedInputValue)

    "Modified: 5.4.1997 / 17:23:41 / cg"
!

numberOfOutputs:aNumber
    outputValues := Array new:aNumber.
    outputValues atAllPut:(self defaultOutputValue).
    oldOutputValues := Array new:aNumber

    "Modified: 5.4.1997 / 17:24:09 / cg"
! !

!LogicObject methodsFor:'simulation'!

click
    ^ self
!

evaluate
    self subclassResponsibility
!

freeze
    1 to:(self numberOfOutputs) do:[:index |
	oldOutputValues at:index put:(outputValues at:index)
    ]
! !

!LogicObject methodsFor:'storing'!

storeOn:aStream
    aStream nextPut:$(.
    aStream nextPutAll:(self class name).
    aStream nextPutAll:' new origin:'.  origin storeOn:aStream.
    aStream nextPutAll:'; name:'.  name storeOn:aStream.
    aStream nextPutAll:'; id:'.  id storeOn:aStream.
    aStream nextPutAll:'; yourself'.
    aStream nextPut:$)
! !

!LogicObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/LogicTool/LogicObj.st,v 1.14 2006-05-11 15:37:21 mb Exp $'
! !
