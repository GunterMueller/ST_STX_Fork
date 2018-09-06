"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:clients/DrawTool' }"

ObjectView subclass:#DrawView
	instanceVariableNames:'createFillPattern createLinePattern createLineWidth
		createLineStyle createFontFamily createFontFace createFontStyle
		createFontSize createForeground createBackground pressAction2
		releaseAction2 resizedObject resizeSelector movedHandle
		createdObject createClass firstDrag startPoint prevPoint
		handlePositionBeforeMove frameBeforeHandleMove fontPanel
		endCreateSelector infoMessageHolder polygonEdgeMode'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool'
!

!DrawView class methodsFor:'documentation'!

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
"
!

documentation
"
    a little draw program - this is only a demo; not an application
    fit for any professional use.

    Its main reason for existance is to show how the framework
    provided by the ObjectView / DisplayObject classes can be used
    to create all kinds of graphic editors.

    [author:]
        Claus Gittinger

    [start with:]
        DrawTool open

    [see also:]
        DrawTool DrawObject
        ObjectView
        LogicTool WindowTreeView
"
! !

!DrawView class methodsFor:'defaults'!

hitDelta
    "region around edges and handles which snaps onto it when clicked upon"

    ^ (Display horizontalPixelPerMillimeter * 0.5) rounded asInteger
! !

!DrawView methodsFor:'accessing - behavior'!

setupStandardActions
    "set actions for pointing"

    pressAction := [:pressPoint | self startSelectOrMove:pressPoint].
    shiftPressAction := [:pressPoint | self startSelectMoreOrMove:pressPoint].
    motionAction := nil.
    releaseAction := nil.
    keyPressAction := [:key | self doKeyInput:key].
    pressAction2 := nil.
    releaseAction2 := nil

    "Modified: 30.5.1996 / 18:12:00 / cg"
! !

!DrawView methodsFor:'cut & paste'!

paste:something
    "redefined to shift the pasted object a bit"

    |s delta griddedNewOrigin|

    self unselect.
    s := self convertForPaste:something .     
    s isNil ifTrue:[
        self warn:'selection not convertable'.
        ^ self
    ].

    delta := 10@10.

    (s isKindOf:Collection) ifFalse:[
        s := OrderedCollection with:s.
    ].

    s := s collect:[:anObject |
        |newObject|

        newObject := nil.
        anObject notNil ifTrue:[
            newObject := anObject copy.
            newObject canBeMoved ifTrue:[
                griddedNewOrigin := self alignToGrid:(newObject origin + delta).
                newObject moveTo:griddedNewOrigin.
            ]
        ]
    ].

    self addSelected:s

    "Created: 5.6.1996 / 16:37:49 / cg"
    "Modified: 5.6.1996 / 16:42:42 / cg"
! !

!DrawView methodsFor:'draw-object initialization'!

setupCreatedObject
    createdObject 
        fillPattern:createFillPattern
        linePattern:createLinePattern
        lineWidth:createLineWidth
        lineStyle:createLineStyle
        foreground:createForeground
        background:createBackground

    "Modified: 5.6.1996 / 10:55:20 / cg"
! !

!DrawView methodsFor:'drawing'!

invertOutlineOf:anObject
    self xoring:[anObject drawDragIn:self]
!

redraw
    "have to redefine this here because of handles"

    self hideSelection.
    super redraw.
    self showSelection
!

redrawObjectsIn:aRectangle
    "have to redefine this here because of handles"

    self hideSelection.
    super redrawObjectsIn:aRectangle.
    self showSelection
!

redrawObjectsInVisible:aRectangle
    "have to redefine this here because of handles"

"/    self hideSelection.
    super redrawObjectsInVisible:aRectangle.
    self showSelection
! !

!DrawView methodsFor:'events'!

buttonPress:button x:x y:y
    (button == 2 or:[button == #menu]) ifTrue:[
	pressAction2 notNil ifTrue:[
	    lastButt := x @ y.
	    pressAction2 value:lastButt.
	    ^ self
	]
    ].
    super buttonPress:button x:x y:y
!

buttonRelease:button x:x y:y
    (button == 2 or:[button == #menu]) ifTrue: [
	releaseAction2 notNil ifTrue:[
	    releaseAction2 value.
	    ^ self
	]
    ].
    super buttonRelease:button x:x y:y
!

keyPress:key x:x y:y
    |sel|

    ((key == #Delete) 
    or:[key == #Cut
    or:[key == #BackSpace]]) ifTrue: [
        selection notNil ifTrue:[
            self deleteSelection
        ] ifFalse:[
            keyPressAction notNil ifTrue:[
                prevPoint := x@y.
                keyPressAction value:key.
            ]
        ].
        ^ self
    ].
    (key == #Copy) ifTrue: [
        selection notNil ifTrue:[
            self copySelection
        ].
        ^ self
    ].
    (key == #Paste) ifTrue: [
        self pasteBuffer.
        ^ self
    ].

    keyPressAction notNil ifTrue:[
        (selection notNil 
        and:[selection isCollection not]) ifTrue:[
            (selection handlesKeyboardInput) ifTrue:[
                (key isMemberOf:Character) ifFalse:[
                    ^ self                              "discard key; should be a character"
                ].
                sel := selection.
                self unselect.
                contents remove:sel.
                startPoint       := sel origin.
                pressAction      := [:pressPoint | self startSelectOrMove:pressPoint ].
                shiftPressAction := pressAction.
                motionAction     := [:movePoint | true].
                releaseAction    := [true].
                keyPressAction   := [:key | self doKeyInputCreate:key].
                oldCursor        := cursor.
                self cursor:Cursor text.
                endCreateSelector := #endKeyInputCreate.
                createdObject     := sel.
                self invertOutlineOf:createdObject.
                createdObject drawTextIn:self x:(startPoint x) y:(startPoint y) opaque:false.
            ]
        ].

        prevPoint := x@y.
        keyPressAction value:key.
        ^ self
    ].

    super keyPress:key x:x y:y

    "Modified: 5.6.1996 / 16:16:29 / cg"
! !

!DrawView methodsFor:'initialization'!

destroy
    fontPanel notNil ifTrue:[fontPanel destroy. fontPanel := nil].
    contents := nil.
    super destroy
!

initialize
    super initialize.

    createFillPattern := nil.
    createLinePattern := Form black "fromFile:'black.xbm'" .
    createLineWidth := 1.
    createLineStyle := #solid.
    createForeground := Black.
    createBackground := White.

    createFontFamily := 'times'.
    createFontFace := 'medium'.
    createFontStyle := 'roman'.
    createFontSize := 14.

    self setupStandardActions.

    "Modified: 5.6.1996 / 10:45:22 / cg"
! !

!DrawView methodsFor:'interface to DrawTool'!

createObjectWithClass:objectClass
    |infoMsg nm|

    "/ finish any outstanding create
    createdObject notNil ifTrue:[
        endCreateSelector notNil ifTrue:[
            self perform:endCreateSelector
        ]
    ].

    self unselect.
    createClass := objectClass.

    objectClass needsKeyboardInput ifTrue:[
        "create text-like objects"
        pressAction := [:pressPoint | self startKeyInputCreate:pressPoint].
        infoMsg := 'Click left for origin; type the text; click again to finish.'
    ] ifFalse: [
        objectClass needsMultiPointCreate ifTrue:[
            objectClass needsAllMovePoints ifTrue:[
                "create free-hand drawings"
                pressAction := [:pressPoint | 
                                self startFreeHandCreate:pressPoint].
                infoMsg := 'Click & drag.'
            ] ifFalse:[
                "create multi-point objects"
                pressAction := [:pressPoint | 
                                self startMultiPointCreate:pressPoint].
                infoMsg := 'Click left for points; click right for final point.'
            ]
        ] ifFalse: [
            "create standard (origin-corner) objects"
            pressAction := [:pressPoint | self startCreate:pressPoint].
            infoMsg := 'Click left for origin; drag corner.'
        ]
    ].
    shiftPressAction := pressAction.

    infoMessageHolder notNil ifTrue:[
        (objectClass respondsTo:#userFriendlyName) ifTrue:[
            nm := objectClass userFriendlyName.
        ] ifFalse:[
            nm := objectClass name
        ].
        infoMsg := 'Add %1. ' , infoMsg.
        infoMessageHolder value:(resources string:infoMsg with:nm)
    ]

    "Modified: 23.4.1997 / 12:07:31 / cg"
!

infoMessageHolder:aValueHolder
    infoMessageHolder := aValueHolder

    "Created: 23.4.1997 / 11:33:05 / cg"
!

noCreate
    "/ finish any outstanding create
    createdObject notNil ifTrue:[
        endCreateSelector notNil ifTrue:[
            self perform:endCreateSelector
        ]
    ].
    createClass := nil.
    self setupStandardActions.

    infoMessageHolder notNil ifTrue:[
        infoMessageHolder value:(resources string:'Click on an object to select or move it; click on handle to resize it.').
    ].

    "Modified: 23.4.1997 / 11:53:03 / cg"
!

polygonEdgeMode
    ^ polygonEdgeMode ? false
!

polygonEdgeMode:aBoolean
    self hideSelection.
    polygonEdgeMode := aBoolean.
    self showSelection.
    self changed:#polygonEdgeMode.
!

setPolygonEdgeMode
    self polygonEdgeMode:true.
!

setPolygonFrameMode
    self polygonEdgeMode:false.
! !

!DrawView methodsFor:'manipulating objects'!

boldFont
    selection notNil ifTrue:[
	self performSelection:#boldFont:
    ] ifFalse:[
	createFontFace := 'bold'.
	createFontStyle := 'normal'
    ]

!

boldFont:anObject
    self with:anObject doFrameChangingBlock:[:object | 
	object fontFace:'bold'.
	object fontStyle:'roman'
    ]
!

boldItalicFont
    selection notNil ifTrue:[
	self performSelection:#boldItalicFont:
    ] ifFalse:[
	createFontFace := 'bold'.
	createFontStyle := 'italic'
    ]
!

boldItalicFont:anObject
    self with:anObject doFrameChangingBlock:[:object | 
	object fontFace:'bold'.
	object fontStyle:'italic'
    ]
!

changeBackground:aColor
    "if anything is selected, change background of selection to be
     aColor; otherwise set the default background color for newly created
     objects"

    selection notNil ifTrue:[
	self performSelection:#changeBackgroundOf:to: with:aColor
    ] ifFalse:[
	createBackground := aColor
    ]
!

changeBackgroundOf:anObject to:aColor

    "no change ?"
    aColor == anObject background ifTrue:[^ self].

    anObject background:aColor.

    anObject isTransparent ifTrue:[
        self redrawObjectsIn:(anObject frame)
    ].

    "if object is not covered, we must only redraw it"

    (self isObscured:anObject) ifFalse:[
        anObject drawIn:self.
        ^ self
    ].

    "must redraw the object, and everything above it"

    anObject drawIn:self.
    self redrawObjectsAbove:anObject in:(anObject frame)
!

changeFillPattern:aForm
    "if anything is selected, change fillpattern of selection to be
     aColor; otherwise set the default fillpattern for newly created
     objects"

    selection notNil ifTrue:[
	self performSelection:#changeFillPatternOf:to: with:aForm
    ] ifFalse:[
	createFillPattern := aForm
    ]
!

changeFillPatternOf:anObject to:aForm
    |oldFrame newFrame|

    "no change ?"
    aForm == (anObject fillPattern) ifTrue:[^ self].

    oldFrame := anObject frame.
    anObject fillPattern:aForm.
    newFrame := anObject frame.

    "if object had a fill pattern - and is now going to loose it
     we must redraw everything under it.
     Also, if the frame changed (which happens with splines ...)
    "

    (aForm isNil 
    or:[newFrame ~= oldFrame
    or:[anObject isTransparent]]) ifTrue:[
        self redrawObjectsIn:(oldFrame merge:newFrame).
        ^ self
    ].

    "if object is not covered, we must only redraw it"

    (self isObscured:anObject) ifFalse:[
        anObject drawIn:self.
        ^ self
    ].

    "must redraw the object, and everything above it"

    anObject drawIn:self.
    self redrawObjectsAbove:anObject in:oldFrame

    "Modified: 5.6.1996 / 16:14:57 / cg"
!

changeFontFace:aFaceName
    selection notNil ifTrue:[
	self performSelection:#changeFontFaceOf:to: with:aFaceName
    ] ifFalse:[
	createFontFace := aFaceName
    ]
!

changeFontFaceOf:anObject to:aFontFace
    self with:anObject doFrameChangingBlock:[:object | 
	object fontFace:aFontFace
    ]
!

changeFontFamily:aFontName
    "if anything is selected, change font family of selection to be
     aColor; otherwise set the default font family for newly created
     objects"

    selection notNil ifTrue:[
	self performSelection:#changeFontFamilyOf:to: with:aFontName
    ] ifFalse:[
	createFontFamily := aFontName
    ]
!

changeFontFamily:family face:face style:style size:size of:anObject
    self with:anObject doFrameChangingBlock:[:object | 
	object fontFamily:family face:face style:style size:size
    ]
!

changeFontFamilyOf:anObject to:aFontFamily
    self with:anObject doFrameChangingBlock:[:object | 
	object fontFamily:aFontFamily
    ]
!

changeFontSize:aFontSize
    selection notNil ifTrue:[
	self performSelection:#changeFontSizeOf:to: with:aFontSize
    ] ifFalse:[
	createFontSize := aFontSize
    ]
!

changeFontSizeOf:anObject to:aFontSize
    self with:anObject doFrameChangingBlock:[:object | 
	object fontSize:aFontSize
    ]
!

changeFontStyle:aFontStyle
    selection notNil ifTrue:[
	self performSelection:#changeFontStyleOf:to: with:aFontStyle
    ] ifFalse:[
	createFontStyle := aFontStyle
    ]
!

changeFontStyleOf:anObject to:aFontStyle
    self with:anObject doFrameChangingBlock:[:object | 
	object fontStyle:aFontStyle
    ]
!

changeForeground:aColor
    "if anything is selected, change foreground of selection to be
     aColor; otherwise set the default foreground color for newly created
     objects"

    selection notNil ifTrue:[
	self performSelection:#changeForegroundOf:to: with:aColor
    ] ifFalse:[
	createForeground := aColor
    ]
!

changeForegroundOf:anObject to:aColor
    "change the foreground of anObject to aColor"

    "no change ?"
    aColor == anObject foreground ifTrue:[^ self].

    anObject foreground:aColor.

    "if object is not covered, we must only redraw it"

    (self isObscured:anObject) ifFalse:[
	anObject drawIn:self.
	^ self
    ].

    "must redraw the object, and everything above it"

    anObject drawIn:self.
    self redrawObjectsAbove:anObject in:(anObject frame)
!

changeLinePattern:aForm
    "if anything is selected, change linepattern of selection to be
     aColor; otherwise set the default linepattern for newly created
     objects"

    selection notNil ifTrue:[
	self performSelection:#changeLinePatternOf:to: with:aForm
    ] ifFalse:[
	createLinePattern := aForm
    ]
!

changeLinePatternOf:anObject to:aForm
    |oldFrame|

    "no change ?"
    aForm == (anObject linePattern) ifTrue:[^ self].

    oldFrame := anObject frame.
    anObject linePattern:aForm.

    "if object had a line pattern - and is now going to loose it
     we must redraw everything under it"

    (aForm isNil 
    or:[anObject isTransparent]) ifTrue:[
        self redrawObjectsIn:oldFrame.
        ^ self
    ].

    "if object is not covered, we must only redraw it"

    (self isObscured:anObject) ifFalse:[
        anObject drawIn:self.
        ^ self
    ].

    "must redraw the object, and everything above it"

    anObject drawIn:self.
    self redrawObjectsAbove:anObject in:oldFrame
!

changeLineStyle:aStyleSymbol
    "if anything is selected, change linestyle of selection to be
     aStyleSymbol; otherwise set the default linestyle for newly created
     objects"

    selection notNil ifTrue:[
        self performSelection:#changeLineStyleOf:to: with:aStyleSymbol
    ] ifFalse:[
        createLineStyle := aStyleSymbol
    ]

    "Created: 5.6.1996 / 10:46:03 / cg"
!

changeLineStyleOf:anObject to:aStyleSymbol

    "no change ?"
    aStyleSymbol == anObject lineStyle ifTrue:[^ self].

    anObject lineStyle:aStyleSymbol.
    anObject linePattern isNil ifTrue:[^ self].

    "if new style is not solid, we must redraw everything under it"

    (aStyleSymbol ~~ #solid) ifTrue:[
        self redrawObjectsIn:(anObject frame).
        ^ self
    ].

    "if object is not covered, we must only redraw it"

    (self isObscured:anObject) ifFalse:[
        anObject drawIn:self.
        ^ self
    ].

    "must redraw the object, and everything above it"

    anObject drawIn:self.
    self redrawObjectsAbove:anObject in:(anObject frame)

    "Created: 5.6.1996 / 10:53:12 / cg"
!

changeLineWidth:aNumber
    "if anything is selected, change linewidth of selection to be
     aColor; otherwise set the default linewidth for newly created
     objects"

    selection notNil ifTrue:[
	self performSelection:#changeLineWidthOf:to: with:aNumber
    ] ifFalse:[
	createLineWidth := aNumber
    ]
!

changeLineWidthOf:anObject to:aNumber
    |oldFrame oldLineWidth|

    oldLineWidth := anObject lineWidth.

    "no change ?"
    aNumber == oldLineWidth ifTrue:[^ self].

    oldFrame := anObject frame.

    anObject lineWidth:aNumber.
    anObject linePattern isNil ifTrue:[^ self].

    "if new lineWidth is smaller, new frame is <= oldFrame
     we must redraw everything under it"

    (oldLineWidth > aNumber) ifTrue:[
	self redrawObjectsIn:oldFrame.
	^ self
    ].

    "if object is not covered, we must only redraw it"

    (self isObscured:anObject) ifFalse:[
	anObject drawIn:self.
	^ self
    ].

    "must redraw the object, and everything above it"

    anObject drawIn:self.
    self redrawObjectsAbove:anObject in:(anObject frame) "oldFrame"
!

doWithRedraw:aBlock to:anObject
    "helper method for font-change operations"

    |oldFrame|

    oldFrame := anObject frame.

    aBlock value:anObject.

    "if new frame is smaller, we must redraw everything under it"

    ((oldFrame width > anObject frame width)
    or:[oldFrame height > anObject frame height]) ifTrue:[
	self redrawObjectsIn:oldFrame.
	^ self
    ].

    "if object is not covered, and we have a fillPattern,
     we must only redraw it"

    (self isObscured:anObject) ifFalse:[
	anObject fillPattern notNil ifTrue:[
	    anObject drawIn:self.
	    ^ self
	]
    ].

    "must redraw everything in new frame"

    anObject drawIn:self.
    self redrawObjectsAbove:anObject in:(anObject frame)
!

flipHorizontal
    "flip all selected objects vertical"

    self withCursor:Cursor wait 
        do:[
            self performSelection:#flipObjectHorizontal:.
        ]
!

flipObjectHorizontal:anObject
    "flip the object horizontally"

    self 
        with:anObject 
        doFrameChangingBlock:[:object | object flipHorizontal]
!

flipObjectVertical:anObject
    "flip the object vertically"

    self 
        with:anObject 
        doFrameChangingBlock:[:object | object flipVertical]
!

flipVertical
    "flip all selected objects horizontal"

    self withCursor:Cursor wait 
        do:[
            self performSelection:#flipObjectVertical:.
        ]
!

group
    "make selection a group-object"

    |oldCollection newObject|

    selection notNil ifTrue:[
	(selection isKindOf:Collection) ifTrue:[
	    oldCollection := selection.
	    self unselect.
	    self removeWithoutRedraw:oldCollection.
	    newObject := DrawGroup new.
	    self forEach:oldCollection do:[:theObject |
		newObject add:theObject
	    ].
	    self addWithoutRedraw:newObject.
	    self select:newObject
	]
    ]
!

italicFont
    selection notNil ifTrue:[
	self performSelection:#italicFont:
    ] ifFalse:[
	createFontFace := 'medium'.
	createFontStyle := 'italic'
    ]
!

italicFont:anObject
    self with:anObject doFrameChangingBlock:[:object | 
	object fontFace:'medium'.
	object fontStyle:'italic'
    ]
!

largerFont
    selection notNil ifTrue:[
	self performSelection:#largerFont:
    ] ifFalse:[
	createFontSize := createFontSize + 1
    ]

!

largerFont:anObject
    self with:anObject doFrameChangingBlock:[:object | 
        |fs|

        fs := object fontSize.
        fs notNil ifTrue:[
            object fontSize:(fs + 1)
        ]
    ]

    "Modified: 3.6.1996 / 10:05:42 / cg"
!

makeClosedPolygon
    self makeInto:#asClosedDrawPolygon
!

makeInto:conversionSelector
    "make each of the selection another object"

    |oldCollection newSel areaToRedraw|

    selection notNil ifTrue:[
        oldCollection := selection.
        newSel := OrderedCollection new.
        self unselect.
        self removeWithoutRedraw:oldCollection.
        self forEach:oldCollection do:[:theObject |
            |newObject|

            areaToRedraw isNil ifTrue:[
                areaToRedraw := theObject frame
            ].
            newObject := theObject perform:conversionSelector.
            newSel add:newObject.
            self addWithoutRedraw:newObject.
            areaToRedraw := areaToRedraw quickMerge:newObject frame
        ].
        newSel size == 1 ifTrue:[
            newSel := newSel first
        ].
        areaToRedraw notNil ifTrue:[
            self redrawObjectsIn:areaToRedraw.
        ].
        self select:newSel
    ]
!

makeOpenPolygon
    self makeInto:#asOpenDrawPolygon
!

makePolygon
    "make each of the selection a polygon-object"

    self makeInto:#asDrawPolygon

!

makeRectangle
    "make each of the selection a rectangle-object"

    self makeInto:#asDrawRectangle
!

makeRoundRectangle
    "make each of the selection a rounded rectangle-object"

    self makeInto:#asDrawRoundRectangle
!

makeSpline
    "make each of the selection a spline-object"

    self makeInto:#asDrawSpline
!

move:something by:delta
    "move an object or a collection of objects by some delta.
     have to redefine this because of handles"

    self withSelectionHiddenDo:[
       super move:something by:delta
    ]

!

normalFont
    selection notNil ifTrue:[
	self performSelection:#normalFont:
    ] ifFalse:[
	createFontFace := 'medium'.
	createFontStyle := 'normal'
    ]

!

normalFont:anObject
    self with:anObject doFrameChangingBlock:[:object | 
	object fontFace:'medium'.
	object fontStyle:'roman'
    ]
!

performSelection:aSelector 
    "for every object in the selection, send a message to self
     with the object as argument
     - a helper for manipulation methods"

    |objectsToChange|

    selection notNil ifTrue:[
	objectsToChange := selection.
	self withSelectionHiddenDo:[
	    self forEach:objectsToChange do:[:object |
		self perform:aSelector with:object
	    ]
	]
    ]

!

performSelection:aSelector with:anArgument
    "for every object in the selection, send a message to self
     with the object and anArgument as arguments
     - a helper for manipulation methods"

    |objectsToChange|

    selection notNil ifTrue:[
	objectsToChange := selection.
	self withSelectionHiddenDo:[
	    self forEach:objectsToChange do:[:object |
		self perform:aSelector with:object with:anArgument
	    ]
	]
    ]

!

performSelection:aSelector with:a1 with:a2 with:a3 with:a4
    "for every object in the selection, send a message to self
     with the object and anArgument as arguments
     - a helper for manipulation methods"

    |objectsToChange args|

    selection notNil ifTrue:[
	args := Array new:5.
	args at:1 put:a1.
	args at:2 put:a2.
	args at:3 put:a3.
	args at:4 put:a4.
	objectsToChange := selection.
	self withSelectionHiddenDo:[
	    self forEach:objectsToChange do:[:object |
		args at:5 put:object.
		self perform:aSelector withArguments:args
	    ]
	]
    ]
!

rotate270
    "rotate all selected objects by 90 degrees counter clockwise"

    self withCursor:Cursor wait
        do:[
            self performSelection:#rotate270Object:.
        ]
!

rotate270Object:anObject
    "rotate the object by 90 degrees counter clockwise"

    self 
        with:anObject 
        doFrameChangingBlock:[:object | object rotate270]
!

rotate90
    "rotate all selected objects by 90 degrees clockwise"

    self withCursor:Cursor wait
        do:[
            self performSelection:#rotate90Object:.
        ]
!

rotate90Object:anObject
    "rotate the object by 90 degrees clockwise"

    self 
        with:anObject 
        doFrameChangingBlock:[:object | object rotate90]
!

showFontPanel
    |action|

    fontPanel isNil ifTrue:[
        fontPanel := FontPanel new 
    ].

    selection notNil ifTrue:[
        action := [:font |
                       self performSelection:#changeFontFamily:face:style:size:of:
                                        with:font family
                                        with:font face
                                        with:font style
                                        with:font size
                  ]
    ] ifFalse:[
        action := [:font | 
                       createFontFamily := font family.
                       createFontFace := font face.
                       createFontStyle := font style.
                       createFontSize := font size
                  ]
    ].

    fontPanel action:action.
    fontPanel showAtPointer
!

smallerFont
    selection notNil ifTrue:[
	self performSelection:#smallerFont:
    ] ifFalse:[
	createFontSize := createFontSize - 1
    ]

!

smallerFont:anObject
    self with:anObject doFrameChangingBlock:[:object | 
        |fs|

        fs := object fontSize.
        fs notNil ifTrue:[
            object fontSize:(fs - 1)
        ]
    ]

    "Modified: 3.6.1996 / 10:06:14 / cg"
!

ungroup
    "ungroup selection into individual objects"

    |objectsToUngroup objectsInThisGroup newSelection|

    selection notNil ifTrue:[
	newSelection := OrderedCollection new.
	objectsToUngroup := selection.
	self unselect.
	self removeWithoutRedraw:objectsToUngroup.
	self forEach:objectsToUngroup do:[:theObject |
	    objectsInThisGroup := theObject groupedObjects.
	    self forEach:objectsInThisGroup do:[:o |
		newSelection add:o
	    ]
	].
	self addWithoutRedraw:newSelection.
	self select:newSelection
    ]
!

with:anObject doFrameChangingBlock:aBlock
    "evaluate the block, aBlock for anObject and redraw what is needed"

    |oldFrame|

    oldFrame := self frameOf:anObject.
    aBlock value:anObject.
    self redrawObjectsIn:oldFrame.
    (self isObscured:anObject) ifFalse:[
	anObject drawIn:self
    ] ifTrue:[
	self redrawObjectsIn:(self frameOf:anObject)
    ]
! !

!DrawView methodsFor:'misc'!

convertForPaste:anObject
    "return a converted version of anObject to be pasted, or nil if
     the object is not compatible with me.
     Notice: anObject may be a collection of to-be-pasted objects."

    (anObject respondsTo:#asDisplayObject) ifTrue:[
        ^ anObject asDisplayObject
    ].
    (anObject isString or:[anObject isMemberOf:StringCollection]) ifTrue:[
    ].
    anObject size > 0 ifTrue:[
        (anObject inject:true into:[:okSoFar :element |
            okSoFar and:[element respondsTo:#asDisplayObject]
        ]) ifFalse:[
            self warn:'selection not convertable to DisplayObject'.
            ^ nil
        ].
        ^ anObject collect:[:element | element asDisplayObject].
    ].
    ^ nil.
!

deleteSelection
    "delete the selection.
     Since the old object is put into the buffer, cutting a
     bitmap will not release the colors. Therefore, we manually
     release the device image - this may help to get all colors
     for the next image."

    |tmp|

    tmp := selection.
    super deleteSelection.
    self forEach:tmp do:[:aDrawObject |
        aDrawObject release.
    ].
!

rectangleForScroll
    "find the area occupied by objects - use to minimize scroll area;
     has to be redefined since ObjectView does not know anything about handles which
     have to be included in the area"

    |rect hs t|

    rect := super rectangleForScroll.
    rect notNil ifTrue:[
	hs := self class handleSize // 2 + 1.
	t := rect left - hs.
	(t < 0) ifTrue:[t := 0].
	rect left:t.

	t := rect right + hs.
	(t > width) ifTrue:[t := width].
	rect right:t.

	t := rect top - hs.
	(t < 0) ifTrue:[t := 0].
	rect top:t.

	t := rect bottom + hs.
	(t > width) ifTrue:[t := height].
	rect bottom:t
    ].
    ^ rect
! !

!DrawView methodsFor:'object creation'!

doDragCreate:aPoint
    createdObject notNil ifTrue:[
        createdObject hasFixedSize ifFalse:[
            self invertOutlineOf:createdObject.
            createdObject origin:startPoint
                          corner:(self alignToGrid:aPoint).
            self invertOutlineOf:createdObject
        ]
    ]
!

doDragFreeHandCreate:movePoint
    createdObject notNil ifTrue:[
	self paint:Black.
	self displayLineFrom:prevPoint to:movePoint.
	createdObject addPoint:movePoint.
	prevPoint := movePoint
    ]
!

doDragLastMultiPoint:movePoint
    |p|

    createdObject notNil ifTrue:[
	self invertOutlineOf:createdObject.
	p := self alignToGrid:movePoint.
	createdObject lastPointAt:p.
	self invertOutlineOf:createdObject
    ]

!

doKeyInputCreate:aKey
    createdObject notNil ifTrue:[
        self invertOutlineOf:createdObject.
        createdObject keyInput:aKey.
        self invertOutlineOf:createdObject
    ]
!

doMultiPointCreate:aPoint
    |p|

    createdObject notNil ifTrue:[
	p := self alignToGrid:aPoint.
	self invertOutlineOf:createdObject.
	createdObject lastPointAt:p.
	createdObject addPoint:p.
	self invertOutlineOf:createdObject
    ]

!

endCreate
    |newObject|

    createdObject notNil ifTrue:[
        self invertOutlineOf:createdObject.
        self setupCreatedObject.
        newObject := createdObject.
        createdObject := nil.
        contents add:newObject.
        newObject drawIn:self.
        self changed:#createObject with:newObject.
        self select:newObject.
"
        self setupStandardActions
"
    ]
!

endFreeHandCreate
    |newObject|

    device compressMotionEvents:true.
    windowGroup sensor compressMotionEvents:true.
    createdObject notNil ifTrue:[
        self invertOutlineOf:createdObject.
        createdObject finishCreate.
        self setupCreatedObject.
        contents add:createdObject.
        createdObject drawIn:self.
        self select:createdObject.
        newObject := createdObject.
        createdObject := nil.
        self changed:#createFreeHandObject with:newObject.
    ]

    "Modified: 23.4.1997 / 11:13:17 / cg"
!

endKeyInputCreate
    |newObject|

    createdObject notNil ifTrue:[
        self invertOutlineOf:createdObject.
        self setupCreatedObject.
        contents add:createdObject.
        createdObject drawIn:self.
        self select:createdObject.
        self cursor:oldCursor.
        newObject := createdObject.
        createdObject := nil.
        self changed:#createKeyInputObject with:newObject.
"
        self setupStandardActions
"
    ]
!

endMultiPointCreate
    ^ self endMultiPointCreate:prevPoint

    "Created: 30.5.1996 / 18:09:55 / cg"
!

endMultiPointCreate:aPoint
    |p newObject|

    createdObject notNil ifTrue:[
        self disableMotionEvents.
        self invertOutlineOf:createdObject.
        aPoint notNil ifTrue:[
            p := self alignToGrid:aPoint.
            createdObject finalPoint:p.
            self setupCreatedObject.
            contents add:createdObject.
            createdObject drawIn:self.
            self select:createdObject.
            createClass notNil ifTrue:[
                pressAction := [:pressPoint | 
                                self startMultiPointCreate:pressPoint]
            ].
            newObject := createdObject.
            createdObject := nil.
            self changed:#createMultiPointObject with:newObject.
        ].
        createdObject := nil.
    ]
"
    self setupStandardActions
"

    "Modified: 5.6.1996 / 13:09:38 / cg"
!

startCreate:aPoint
    createClass notNil ifTrue:[
        startPoint := self alignToGrid:aPoint.
        self unselect.
        createdObject := createClass new.
        createdObject hasFixedSize ifTrue:[
            createdObject origin:startPoint 
        ] ifFalse:[
            createdObject origin:startPoint corner:startPoint 
        ].
        self invertOutlineOf:createdObject.
        motionAction := [:movePoint | self doDragCreate:movePoint].
        releaseAction := [self endCreate].
        endCreateSelector := #endCreate.
    ] ifFalse:[
        createdObject := nil
    ]

    "Modified: 30.5.1996 / 18:09:30 / cg"
!

startFreeHandCreate:aPoint
    startPoint := self alignToGrid:aPoint.
    createClass notNil ifTrue:[
        self unselect.
        createdObject := createClass new.
        createdObject firstPoint:aPoint.
        prevPoint := startPoint.
        device compressMotionEvents:false.
        windowGroup sensor compressMotionEvents:false.
        releaseAction := [self endFreeHandCreate].
        motionAction := [:movePoint | self doDragFreeHandCreate:movePoint].
        endCreateSelector := #endFreeHandCreate.
    ] ifFalse:[
        createdObject := nil
    ]

    "Modified: 30.5.1996 / 18:09:36 / cg"
!

startKeyInputCreate:aPoint
    startPoint := self alignToGrid:aPoint.
    createClass notNil ifTrue:[
        pressAction := [:pressPoint | self startSelectOrMove:pressPoint "endKeyInputCreate"].
        shiftPressAction := pressAction.
        motionAction := [:movePoint | true].
        releaseAction := [true].
        keyPressAction := [:key | self doKeyInputCreate:key].
        oldCursor := cursor.
        self cursor:Cursor text.
        self unselect.
        createdObject := createClass family:createFontFamily
                                       face:createFontFace
                                      style:createFontStyle
                                       size:createFontSize.
        createdObject origin:aPoint.
        endCreateSelector := #endKeyInputCreate.
    ] ifFalse:[
        createdObject := nil
    ]

    "Modified: 30.5.1996 / 18:10:48 / cg"
!

startMultiPointCreate:aPoint
    |p|

    startPoint := self alignToGrid:aPoint.
    createClass notNil ifTrue:[
        self unselect.
        self enableMotionEvents.
        p := startPoint.
        createdObject := createClass new.
        createdObject firstPoint:p.
        createdObject addPoint:p.
        createdObject lastPointAt:p.
        pressAction := [:pressPoint | self doMultiPointCreate:pressPoint].
        shiftPressAction := pressAction.
        motionAction := [:movePoint | self doDragLastMultiPoint:movePoint].
        releaseAction := [true].
        pressAction2 := [:pressPoint | self endMultiPointCreate:pressPoint].
        self invertOutlineOf:createdObject.
        endCreateSelector := #endMultiPointCreate.
    ] ifFalse:[
        createdObject := nil
    ]

    "Modified: 30.5.1996 / 18:10:05 / cg"
! !

!DrawView methodsFor:'select or move'!

doHandleMove:aPoint
    "handle move to aPoint. The object affected is
     resizedObject; the handle is movedHandle; the access selector
     is resizeSelector."

    |np|

    movedHandle notNil ifTrue:[
        np := self alignToGrid:aPoint.
        resizedObject isNil ifTrue:[
            resizedObject := selection.
            self unselect.
            self invertHandle:movedHandle
        ] ifFalse:[
            np = lastButt ifTrue:[^ self].
            "invert previous drag"
            self invertOutlineOf:resizedObject
        ].
        np := self alignToGrid:aPoint.
        resizeSelector isArray ifTrue:[
            resizedObject perform:(resizeSelector at:1) with:(resizeSelector at:2) with:np.
        ] ifFalse:[
            resizedObject perform:resizeSelector with:np.
        ].
        self invertHandle:movedHandle.
        movedHandle x:(np x) 
                    y:(np y).
        self invertHandle:movedHandle.
        self invertOutlineOf:resizedObject.
        lastButt := np
    ]

    "Modified: 5.6.1996 / 13:14:37 / cg"
!

doKeyInput:key
    "keyboard input to the selected object"

    |theObject oldFrame|

    selection notNil ifTrue:[
        (selection isKindOf:Collection) ifFalse:[
            theObject := selection.
            theObject handlesKeyboardInput ifTrue:[
                oldFrame := self frameOf:theObject.

                theObject keyInput:key.

                self redrawObjectsIn:oldFrame.
                (self isObscured:theObject) ifFalse:[
                    theObject drawIn:self
                ] ifTrue:[
                    self redrawObjectsIn:(self frameOf:theObject)
                ]
            ]
        ]
    ]

    "Modified: 5.6.1996 / 13:18:13 / cg"
!

endHandleMove
    "end handle move. 
     The object affected is resizedObject; the handle is movedHandle."

    |frameAfterHandleMove|

    movedHandle notNil ifTrue:[
        resizedObject notNil ifTrue:[
            self invertHandle:movedHandle.
            self invertOutlineOf:resizedObject 
        ].

        (movedHandle = handlePositionBeforeMove) ifFalse:[
            frameAfterHandleMove := self frameOf:resizedObject.
            (frameBeforeHandleMove isContainedIn:frameAfterHandleMove) ifFalse:[
                (frameAfterHandleMove isContainedIn:frameBeforeHandleMove) ifFalse:[
                    self redrawObjectsIn:(frameBeforeHandleMove merge:frameAfterHandleMove)
                ] ifTrue:[
                    "object became smaller"
                    self redrawObjectsIn:frameBeforeHandleMove.
                ]
            ] ifTrue:[
                "object became bigger"
                self redrawObjectsIn:frameAfterHandleMove
            ]
        ].
        self select:resizedObject.
        self setDefaultActions.
        movedHandle := nil.
        resizedObject := nil.
        self changed:#objectLayout.

    ]

    "Modified: / 4.7.1999 / 17:40:25 / cg"
!

startHandleMove:aHandle handleObject:anObject
    "start a handle move operation on aHandle of anObject"

    aHandle notNil ifTrue:[
        "/ get the access selector for that handle
        polygonEdgeMode == true ifTrue:[
            resizeSelector := anObject selectorForEdgeHandle:aHandle.
        ] ifFalse:[
            resizeSelector := anObject selectorForHandle:aHandle.
        ].
        resizeSelector notNil ifTrue:[
            motionAction := [:movePoint | self doHandleMove:movePoint].
            releaseAction := [self endHandleMove].
            movedHandle := aHandle.
            frameBeforeHandleMove := self frameOf:anObject.
            handlePositionBeforeMove := (movedHandle x) @ (movedHandle y).
            endCreateSelector := #endHandleMove.
         ]
    ]

    "Modified: 5.6.1996 / 13:13:33 / cg"
!

startSelectOrMove:aPoint
    |anObject aHandle|

    createdObject notNil ifTrue:[
        endCreateSelector notNil ifTrue:[
            self perform:endCreateSelector
        ]
    ].

    "if there is already a selection, look at handles first"
    selection notNil ifTrue:[
        self selectionHandlesDo:[:handleObject :handlePoint |
            (self handle:handlePoint isHitBy:aPoint) ifTrue:[
                anObject := handleObject.
                aHandle := handlePoint
            ]
        ].
        "if we found a handle, this starts a handleMove"
        aHandle notNil ifTrue:[
            (selection isKindOf:Collection) ifFalse:[
                selection hasFixedSize ifFalse:[
                    self startHandleMove:aHandle handleObject:anObject
                ]
            ].
"
            ((selection isKindOf:Collection)
             or:[selection hasFixedSize not]) ifTrue:[
                self startHandleMove:aHandle handleObject:anObject
            ].
"
            ^ self
        ]
    ].
    "otherwise, this starts an objectSelect or objectMove"
    super startSelectOrMove:aPoint

    "Modified: 30.5.1996 / 18:12:23 / cg"
! !

!DrawView methodsFor:'selection & handles'!

handlesOf:anObject do:aBlock
    polygonEdgeMode == true ifTrue:[
        anObject edgeHandlesDo:aBlock
    ] ifFalse:[
        anObject handlesDo:aBlock
    ]
!

hideSelection
    self invertHandlesOf:selection.
!

show:anObject
    "since objectView's show goes either to showSelected or showUnselected,
     we have to redefine this here to draw every object normal; then
     when draw operation is finished, show handles"

    anObject drawIn:self
!

showSelected:anObject
    self invertHandlesOf:anObject
!

showSelection
    self invertHandlesOf:selection
!

showUnselected:anObject
    anObject drawIn:self
! !

!DrawView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawView.st,v 1.39 2009-02-12 15:56:32 cg Exp $'
! !
