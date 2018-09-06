"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ImageView subclass:#ImageEditView
	instanceVariableNames:'readOnly magnification imageReaderClass resourceClass
		resourceSelector mouseKeyColorMode undoImages modifiedHolder
		editMode lastPastePoint imageInfoHolder activityInfoHolder
		pickedColorHolder drawingColors drawingPixels drawingColorHolders
		drawingPixelHolders clickInfoCallBack penWidth sprayProcess
		sprayPosition spraySpot drawingAlpha'
	classVariableNames:'Clipboard ClipboardMagnified LastMagnification
		GridMagnificationLimit MaxUndos LastSaveDirectory LastSaveClass
		EditModePoint EditModeBox EditModeFilledBox EditModeFill
		EditModeCopy EditModePasteUnder EditModePaste
		EditModePasteWithMask EditModeSpecialOperation EditModeSpray
		EditModeCircle EditModeSmooth'
	poolDictionaries:''
	category:'Views-Misc'
!

!ImageEditView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    An ImageEditView is a view which can be used by applications
    like the Image Editor for editing or inspecting (bitmap-) images.

    [see also:]
        ImageEditor Image

    [author:]
        Thomas Zwick
"
! !

!ImageEditView class methodsFor:'initialization'!

initialize
    MaxUndos := 10.
    GridMagnificationLimit := 6 @ 6.

    EditModePoint := #point.
    EditModeBox := #box.
    EditModeCircle := #circle.
    EditModePaste := #paste.
    EditModePasteUnder := #pasteUnder.
    EditModePasteWithMask := #pasteWithMask.
    EditModeFilledBox := #filledBox.
    EditModeFill := #fill.
    EditModeCopy := #copy.
    EditModeSpecialOperation := #specialOperation.
    EditModeSpray := #spray.
    EditModeSmooth := #smooth.

    "
     self initialize
    "
! !

!ImageEditView class methodsFor:'accessing'!

editModeBox
    ^ EditModeBox
!

editModeCopy
    ^ EditModeCopy
!

editModeFill
    ^ EditModeFill
!

editModeFilledBox
    ^ EditModeFilledBox
!

editModePaste
    ^ EditModePaste
!

editModePasteUnder
    ^ EditModePasteUnder
!

editModePasteWithMask
    ^ EditModePasteWithMask
!

editModePoint
    ^ EditModePoint
!

editModeSmooth
    ^ EditModeSmooth
!

editModeSpecialOperation
    ^ EditModeSpecialOperation
!

gridMagnificationLimit
    ^ GridMagnificationLimit
!

gridMagnificationLimit:anInteger
    GridMagnificationLimit := anInteger
!

lastSaveDirectory
    ^ LastSaveDirectory

    "Created: / 14-12-2010 / 14:49:01 / cg"
!

lastSaveDirectory:aStringOrFilename
    LastSaveDirectory := aStringOrFilename

    "Created: / 14-12-2010 / 14:49:18 / cg"
! !

!ImageEditView class methodsFor:'helpers'!

copyImageToClipboard:copiedImage
    ClipboardMagnified := nil.
    Clipboard := copiedImage.
! !

!ImageEditView class methodsFor:'resources'!

classResources
    ^ ImageEditor classResources
! !

!ImageEditView methodsFor:'accessing'!

activityInfoHolder
    "return the value of the instance variable 'activityInfoHolder' (automatically generated)"

    ^ activityInfoHolder

    "Created: / 29.7.1998 / 18:49:39 / cg"
!

activityInfoHolder:something
    "set the value of the instance variable 'activityInfoHolder' (automatically generated)"

    activityInfoHolder := something.

    "Created: / 29.7.1998 / 18:49:39 / cg"
!

clearModified
    self modified:false
!

clickInfoCallBack:aTwoArgBlock
     clickInfoCallBack := aTwoArgBlock

    "Created: / 10.2.2000 / 23:07:14 / cg"
!

clipBoard
    |clipboardObject|
    
    clipboardObject := self getClipboardObject.
    clipboardObject isImage ifTrue:[
        ^ clipboardObject
    ].
    ^ Clipboard.
!

drawingColorHolders
    ^ drawingColorHolders
!

drawingColors
    ^ drawingColorHolders collect:[:each | each value].
!

drawingColors:anArrayTwoColors
    (drawingColorHolders at:1) value:(anArrayTwoColors at:1).
    (drawingColorHolders at:2) value:(anArrayTwoColors at:2).
!

image:anImage scroll:doScroll
    self image:anImage scroll:doScroll invalidate:true
!

image:anImage scroll:doScroll invalidate:doInvalidate
    |retVal fileName|

    anImage isImage ifTrue:[           
        true "(image isNil or: [self checkModified])" ifTrue: [
            image notNil ifTrue: [
                fileName := image fileName.
                anImage fileName isNil ifTrue: [anImage fileName: fileName].
            ].
            super image:anImage scroll:doScroll invalidate:doInvalidate.
            retVal := self.
        ].
    ] ifFalse: [
        super image:nil scroll:true invalidate:doInvalidate.
    ].

    "/ self changed:#image.
    image isNil ifTrue:[
        self clearModified.
    ] ifFalse:[
        self setModified.
    ].
    self updateImageInfo: self imageInfoString. 
    ^ retVal

    "Modified: / 10.2.2000 / 23:33:12 / cg"
!

imageInfoHolder
    ^ imageInfoHolder

    "Created: / 29.7.1998 / 18:29:50 / cg"
!

imageInfoHolder:something
    imageInfoHolder := something.

    "Created: / 29.7.1998 / 18:29:50 / cg"
!

magnification

    ^magnification

!

magnification: aPoint
    |oldOrg|

    magnification ~= aPoint
    ifTrue:
    [
	oldOrg := self viewOrigin / magnification.
	magnification := aPoint asPoint.

	self scrollTo:(oldOrg * magnification) rounded redraw:false.        
"/        self scrollToTopLeft.
	self contentsChanged.
	self invalidate.
	ClipboardMagnified := nil.
    ]

    "Modified: / 31.7.1998 / 02:38:47 / cg"
!

modified
    ^ modifiedHolder value
!

modified:aBoolean
    modifiedHolder value:aBoolean
!

modifiedHolder
    ^ modifiedHolder
!

penWidth
    ^ penWidth ? 1

    "Created: / 01-11-2007 / 23:34:49 / cg"
!

penWidth:anInteger
    penWidth := anInteger

    "Created: / 01-11-2007 / 23:34:56 / cg"
!

readOnly
    ^ readOnly
!

readOnly:aBoolean
    readOnly := aBoolean.
!

removelastUndo
    undoImages removeLast
!

resourceClass
    ^ resourceClass
!

resourceClass: aClassOrClassNameString
    "support for names will vanish - obsolete left over from tz"

    resourceClass := aClassOrClassNameString.
    resourceClass notNil ifTrue:[
        resourceClass isBehavior ifFalse: [ 
            resourceClass := Smalltalk classNamed:aClassOrClassNameString 
        ]
    ]
!

resourceClassName
    resourceClass isNil ifTrue:[^ ''].
    ^ resourceClass name
!

resourceMessage
    (resourceClass isNil or:[resourceSelector isNil]) ifTrue:[^ ''].
    ^ resourceClass name, ' ', resourceSelector
!

resourceSelector
    ^ resourceSelector
!

resourceSelector: aStringOrSymbol
    aStringOrSymbol isNil ifTrue:[
        resourceSelector := nil
    ] ifFalse:[
        resourceSelector := aStringOrSymbol asSymbol
    ]
!

selectedColor
    |clr|

    clr := (drawingColorHolders at:mouseKeyColorMode) value.
    clr isNil ifTrue:[ clr := Color black ].
    image hasAlphaChannel ifTrue:[
        ^ (TranslucentColor 
                scaledRed:clr scaledRed
                scaledGreen:clr scaledGreen
                scaledBlue:clr scaledBlue)
                alpha:(drawingAlpha ? 1.0)
    ].
    ^ clr

    "Modified: / 20-09-2010 / 11:34:07 / cg"
!

selectedColor: aColor
    (drawingColorHolders at:(mouseKeyColorMode min:drawingColorHolders size)) value:aColor
!

selectedColorIndex
    ^ (drawingPixelHolders at:mouseKeyColorMode) value
!

selectedColorIndex: aPixelIndex
    (drawingPixelHolders at:(mouseKeyColorMode min:drawingPixelHolders size)) value: aPixelIndex
!

setModified
    self modified:true
!

spraySpot
    ^ spraySpot

    "Created: / 15-02-2012 / 22:38:04 / cg"
!

spraySpot:something
    spraySpot := something.
!

undoImages
    ^ undoImages
! !

!ImageEditView methodsFor:'drawing'!

drawFrame
    "draws a black frame around the image's bounds"
    
    gc paint:self blackColor.
    gc lineWidth: (magnification x//3 min: 3).
    gc displayRectangle: ((0@0) extent:(image extent * magnification) + margin).
    gc lineWidth:1.
!

drawFramesIn: aRectangle
    "draws the pixel frame grid"

    |origin lineStartingPoint lineEndingPoint oldColor mX mY|

    magnification >= GridMagnificationLimit ifTrue: [
        mX := magnification x.
        mY := magnification y.
        
        origin := aRectangle origin - 1.
        lineStartingPoint := origin + (0 @ mY).
        lineEndingPoint   := lineStartingPoint + (aRectangle width@0).

        oldColor := gc paint.
        gc xoring:[
            gc displayLineFrom: lineStartingPoint to: lineEndingPoint.
            lineStartingPoint x to: lineStartingPoint x + aRectangle width - mX by: mX 
            do:[:x|   
                gc displayLineFrom: x@(origin y) to: x@(origin y + mY)
            ].
        ].
        gc paint: oldColor.
    ]
!

drawPasteRectangleAt: aPoint
    |currentPoint gridCorrection extent|

    magnification >= GridMagnificationLimit ifFalse: [gridCorrection := 0] ifTrue: [gridCorrection := 1].
    currentPoint := aPoint // magnification*magnification + margin. 

    self repairDamage.

    currentPoint ~= lastPastePoint ifTrue:[              
        ClipboardMagnified isNil ifTrue:[
            ClipboardMagnified := (Clipboard magnifiedBy: magnification) onDevice:device
        ].   
        extent := ClipboardMagnified extent.

        "/ currentPoint := currentPoint - self viewOrigin.

        self redraw: (((lastPastePoint ? currentPoint)"-self viewOrigin") extent: extent).
        "/ self repairDamage.

false "        (extent x > 400 or: [extent y > 400])" ifTrue:[
            self xoring: [
                self fillRectangle: (currentPoint extent: extent)
            ]   
        ] ifFalse:[
            ClipboardMagnified notNil ifTrue:[
                self displayDeviceForm: ClipboardMagnified 
                                     x: currentPoint x - self viewOrigin x 
                                     y: currentPoint y - self viewOrigin y.
            ].
            editMode == EditModePastUnder ifTrue:[
                self redrawImageX:currentPoint x y:currentPoint y width:extent x height:extent y unmaskedOnly:true
            ]
        ]  
    ]. 
    lastPastePoint := currentPoint.

    "Modified: / 20-11-2007 / 17:17:14 / cg"
!

fillFramedRectangle: aRectangle

    self fillRectangle: aRectangle.
    self drawFramesIn: aRectangle
!

redraw:aRectangle
    self 
        invalidate:(aRectangle origin "+ self viewOrigin" extent:aRectangle extent)
        repairNow:true. 

    "Modified: / 15.11.2001 / 16:43:53 / cg"
!

redrawImageX:x y:y width:w height:h
    self redrawImageX:x y:y width:w height:h unmaskedOnly:false

    "Modified: / 18.5.1999 / 20:14:03 / cg"
!

redrawImageX:x y:y width:w height:h unmaskedOnly:unmaskedOnly
    "redraw the magnified (editing) view of the image"

    self 
        redrawImageX:x y:y width:w height:h 
        unmaskedOnly:unmaskedOnly processColorsWith:[:colorIn | colorIn].

    "Created: / 18.5.1999 / 20:13:39 / cg"
    "Modified: / 18.5.1999 / 20:36:20 / cg"
!

redrawImageX:x y:y width:w height:h unmaskedOnly:unmaskedOnly processColorsWith:aColorBlock
    "redraw the magnified (editing) view of the image"

    |ih iw magX magY minX maxX minY maxY lastColor lastY runW x0 maskColor mask
     sizeOfMaskPoint useNearestColor origin|

    useNearestColor := device visualType == #PseudoColor.

    mask := image mask.
    ih := image height.
    iw := image width.
    magX := magnification x.
    magY := magnification y.

    minX := (x // magX - 1) max: 0.
    minX >= iw ifTrue:[minX := (iw - 1) max: 0].
    minY := (y // magY - 1) max: 0.
    minY >= ih ifTrue:[minY := (ih - 1) max: 0].
    maxX := (x + w) // magX + 1.
    maxX > iw ifTrue:[maxX := iw].
    maxY := (y + h) // magY + 1.
    maxY > ih ifTrue:[maxY := ih].

    lastY := -1.

    x0 := minX.
    runW := 0.
    maskColor := false.
    sizeOfMaskPoint := magnification//3.
    image 
        colorsFromX:minX y:minY toX:maxX-1 y:maxY-1 
        do:[:xx :yy :colorIn|
            |color|
            
            color := aColorBlock value:colorIn.
            
            shown ifFalse:[^ self].

            yy ~~ lastY ifTrue:[
                runW ~~ 0 ifTrue:[
                    origin := (x0 * magX + margin) @ (lastY * magY + margin).
                    (unmaskedOnly not or:[maskColor not]) ifTrue:[
                        self fillFramedRectangle: (origin extent: (runW@magY)).                    
                        maskColor ifTrue:[
                            gc xoring: [gc fillRectangle: (origin + sizeOfMaskPoint extent: sizeOfMaskPoint)]
                        ]
                    ].
                    runW := 0.
                ]. 
                x0 := xx.
                lastY := yy.
            ]. 

            color ~= lastColor ifTrue:[
                runW ~~ 0 ifTrue:[
                    origin := (x0 * magX + margin)@(yy * magY + margin).
                    (unmaskedOnly not or:[maskColor not]) ifTrue:[
                        self fillFramedRectangle: (origin extent: (runW@magY)).
                        maskColor ifTrue:[
                            gc xoring: [gc fillRectangle: (origin + sizeOfMaskPoint extent: sizeOfMaskPoint)]
                        ].
                    ].
                    runW := 0.
                ].

                lastColor := color.
                useNearestColor ifTrue:[
                    lastColor := lastColor nearestOn:device
                ].
                gc paint:lastColor.
                mask notNil ifTrue:[  
                    maskColor := false.
                    (mask pixelAtX:xx y:yy) == 0 ifTrue:[
                        unmaskedOnly ifFalse:[
                            gc paint: (lastColor := self viewBackground).
                        ].
                        maskColor := true.
                    ].
                    lastColor := nil.
                ].
                runW := 0.
                x0 := xx.
            ].  
            runW := runW + magX
        ].

    runW ~~ 0 ifTrue:[
        origin := (x0 * magX + margin)@(lastY * magY + margin).
        (unmaskedOnly not or:[maskColor not]) ifTrue:[
            self fillFramedRectangle: (origin extent: runW@magY).
            maskColor ifTrue:[
                gc xoring:[
                    gc fillRectangle: (origin + sizeOfMaskPoint extent: sizeOfMaskPoint)
                ]
            ].
        ]
    ].

    "Created: / 18.5.1999 / 20:13:39 / cg"
    "Modified: / 18.5.1999 / 20:36:20 / cg"
!

redrawX:x y:y width:w height:h

    |xI yI devImage imgWidth imgHeight mX mY magnifiedWidth magnifiedHeight|

    image isNil ifTrue:[^self].

    magnification = (1@1) ifTrue: [
        Error handle:[:ex |
            Transcript showCR:'cannot convert image: ', ex description.
        ] do:[
            devImage := image onDevice:device.
            devImage ~~ image ifTrue:[
                image := devImage.
                self changed:#image.
            ].
        ].
        image device == device ifTrue:[
            super redrawX:x y:y width:w height:h.
            self drawFrame.
            ^ self.
        ].
    ].

    "/ self clippingRectangle: (x@y extent:w@h).
    "/ draw the image itself
    self redrawImageX:x y:y width:w height:h.

    imgWidth := image width.
    imgHeight := image height.

    "/ beyond of image ?
    adjust == #center ifTrue:[
        xI := (width - imgWidth) // 2 - margin.
        yI := (height - imgHeight) // 2 - margin.
    ] ifFalse:[
        xI := yI := margin
    ].

    mX := magnification x.
    mY := magnification y.
    magnifiedWidth := mX * imgWidth.
    magnifiedHeight := mY * imgHeight.
    
    "/ draw the rest to the right and at the bottom
    (x + w - 1) > (xI + magnifiedWidth) ifTrue:[
        self 
            clearRectangleX:(xI + magnifiedWidth) y:y
            width:(x + w - magnifiedWidth - xI) height:h
    ].
    (y + h - 1) > (yI + magnifiedHeight) ifTrue:[
        self 
            clearRectangleX:margin y:(yI + magnifiedHeight)
            width:w height:(y + h - magnifiedHeight - yI)  
    ].
    self drawFrame.
    self clippingBounds: nil.

    "Modified: / 31.7.1998 / 02:22:45 / cg"
!

startSpray
    spraySpot isNil ifTrue:[
        spraySpot := 8
    ].

    sprayProcess isNil ifTrue:[
        sprayProcess := [
                |p rnd norm sprayPoint dly angle x y dist|

                rnd := Random new.
                Distributions::NormalDistribution notNil ifTrue:[
                    norm := Distributions::NormalDistribution mean:0 deviation:0.5.
                ].
                dly := Delay forMilliseconds:20.
                [true] whileTrue:[
                    10 timesRepeat:[
                        p := sprayPosition.
                        p notNil ifTrue:[
                            angle := rnd next * 359.999.    "/ the angle is uniformly ditributed
                            norm notNil ifTrue:[
                                dist := norm next * spraySpot.  "/ the distance is a normalDistribution
                            ] ifFalse:[
                                dist := (rnd nextBetween:-1 and:1) * spraySpot. 
                            ].
                            sprayPoint := (Point r:dist degrees:angle)*magnification.

                            x := p x + sprayPoint x truncated.
                            y := p y + sprayPoint y truncated.
                            self pointAt:(x@y) width:1.
                        ].
                    ].
                    dly wait.
                ].
        ] fork.
    ]

    "Modified: / 15-02-2012 / 22:44:54 / cg"
!

stopSpray
    sprayProcess notNil ifTrue:[
        sprayProcess terminate.
        sprayProcess := nil
    ].
! !

!ImageEditView methodsFor:'edit modes'!

editMode
    "is one of the edit modes:

        EditModePoint
        EditModeBox
        EditModePaste
        EditModePasteUnder
        EditModePasteWithMask 
        EditModeFilledBox
        EditModeFill 
        EditModeCopy 
        EditModeSpecialOperation 
        EditModeSpray 
        EditModeCircle 
        EditModeSmooth 
    "

    ^editMode
!

editMode: anEditModeSymbol
    "must be one of the edit modes:

        EditModePoint
        EditModeBox
        EditModePaste
        EditModePasteUnder
        EditModePasteWithMask 
        EditModeFilledBox
        EditModeFill 
        EditModeCopy 
        EditModeSpecialOperation 
        EditModeSpray 
        EditModeCircle 
        EditModeSmooth 
    "

    editMode := anEditModeSymbol
!

mouseKeyColorMode

    ^mouseKeyColorMode printString
!

mouseKeyColorMode:aMode

    mouseKeyColorMode := aMode
! !

!ImageEditView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    |p|

    (x < 0 or:[y < 0]) ifTrue:[
        ^ self
    ].
    "/ readOnly ifTrue:[^ self].

    p := x@y.

    state ~~ 0 ifTrue:[
        "/ button down

        "/ self selectedColor notNil ifTrue:[ 
        (self imageContainsPoint:p) ifTrue:[
            (editMode == EditModePoint) ifTrue:[
                self pointAt:p.
                ^ self
            ].
            (editMode == EditModeSmooth) ifTrue:[
                self smoothAt:p.
                ^ self
            ].
            sprayProcess notNil ifTrue:[
                sprayPosition := p.
               ^ self
            ].
        ].
        self drawCursorAt:p.
        ^ self
    ].

    "/ button is up (care for paste-mode, dragging the pasted image)
    self drawCursorAt:p.
    self inPasteMode ifTrue: [
        self sensor shiftDown ifTrue:[
            p := p - Clipboard extent
        ].
        ("self selectedColor notNil" true and: [self imageContainsPastePoint:p]) 
            ifTrue:[
                (self sensor hasButtonMotionEventFor:self) ifFalse:[
                    self drawPasteRectangleAt:p]]
            ifFalse: [self cursor:Cursor stop. self releasePasteDrawing]
    ]

    "Modified: / 03-05-2011 / 12:26:54 / cg"
!

buttonPress:button x:x y:y
    |p clr masked|

    p := x@y.

    self inPasteMode ifTrue:[
        self sensor shiftDown ifTrue:[
            p := p - Clipboard extent
        ]
    ].
    
    self drawCursorAt:p.

    ("self selectedColor notNil" true 
    and: [self imageContainsPoint:p])
    ifTrue:[   
        (self inPasteMode not 
        and:[self sensor shiftDown]) ifTrue:[
            (image maskAt:(p // magnification)) == 0 ifTrue:[
                masked := true.
            ] ifFalse:[
                masked := false.
                clr := image colorAt:(p // magnification).
            ].
            pickedColorHolder notNil ifTrue:[
                "/ select the color under the cursor, place it into the
                "/ pickedColorHolder/
                pickedColorHolder value:clr.
            ].
            self selectedColor:clr.
            masked ifTrue:[self selectedColorIndex:nil].
            self changed:#selectedColor with:clr.
        ] ifFalse:[
            (readOnly not 
              or:[editMode == EditModeCopy
              or:[editMode == EditModeSpecialOperation]]
            ) ifTrue:[
                (button between:1 and:2) ifTrue:[
                    mouseKeyColorMode := button.
                    self makeUndo.

                    clickInfoCallBack notNil ifTrue:[
                        "/ still a kludge, but less ugly ...
                        clickInfoCallBack value:button value:p
                    ].
                    "/ editMode is something like #point, #rectangle etc.
                    [
                        self perform: (editMode, 'At:') asSymbol with:p
                    ] on:Error do:[:ex | 
                        (Dialog confirm:('Error during operation: ', ex description,'\\Debug ?') withCRs )
                        ifTrue:[
                            ex reject
                        ].
                    ].
                ].
            ].
        ]
    ]

    "Modified: / 03-05-2011 / 12:26:06 / cg"
!

buttonRelease:button x:x y:y

    self drawCursorAt: x@y.
    readOnly ifTrue:[^ self].

    ("self selectedColor notNil" true and: [self imageContainsPoint: x@y])
    ifTrue: [
        sprayProcess notNil ifTrue:[
            self stopSpray
        ].

        image release.

"/        "/ cg: what a kludge - please change to use a valueHolder,
"/        "/ which gets the information ...
"/        masterApplication imagePreView invalidate.

        "/ cg: still a kludge - but less ugly
        self changed:#subImageIn with:(image bounds).
    ]

    "Modified: / 03-05-2011 / 12:26:31 / cg"
!

inPasteMode
    ^ (editMode notNil and:[editMode startsWith:#paste])
!

keyboardZoom:larger
    larger ifTrue:[
        self magnification: ((magnification + 1) min:63)
    ] ifFalse:[
        self magnification: ((magnification - 1) max:1)
    ].    
!

pointerLeave:state

    super pointerLeave: state.

    self updateImageInfo: self imageInfoString.
    self cursor:Cursor normal.

    self inPasteMode ifTrue: [
        self releasePasteDrawing
    ]

    "Modified: / 29.7.1998 / 18:27:42 / cg"
! !

!ImageEditView methodsFor:'image editing'!

boxAt: aPoint
    "drag a rectangular outline, 
     when released draw a rectangle with the currently selected color"

    |choosenBox imageBox clr pix|

    (clr := self selectedColor) notNil ifTrue:[
        choosenBox := self dragRectangleStartingAt: aPoint emphasis: #box.
        choosenBox notNil ifTrue:[
            imageBox := choosenBox origin//magnification extent: (choosenBox extent//magnification).
            image colorMap isNil ifTrue:[
                image drawRectangle:imageBox withColor:clr.
            ] ifFalse:[
                pix := self selectedColorIndex.
                image drawRectangle:imageBox withValue:pix.
            ].
            image restored.
            self redraw: (choosenBox expandedBy: 1).

"/        "/ cg: what a kludge - please change to use a valueHolder,
"/        "/ which gets the information ...
"/        masterApplication imagePreView redraw: (imageBox expandedBy: 1).

            "/ cg: still a kludge - but less ugly
            self changed:#subImageIn with:(imageBox expandedBy: 1).

            self setModified.
        ].
    ].

    "Modified: / 10.2.2000 / 23:42:08 / cg"
!

circleAt: aPoint
    "drag an ellipse, 
     when released draw an ellipse with the currently selected color"

    |choosenBox imageBox clr pix|

    (clr := self selectedColor) notNil ifTrue:[
        choosenBox := self dragRectangleStartingAt: aPoint emphasis: #box.
        choosenBox notNil ifTrue:[
            imageBox := choosenBox origin//magnification extent: (choosenBox extent//magnification).
            image colorMap isNil ifTrue:[
                image drawEllipse:imageBox withColor:clr.
            ] ifFalse:[
                pix := self selectedColorIndex.
                image drawEllipse:imageBox withValue:pix.
            ].
            image restored.
            self redraw: (choosenBox expandedBy: 1).

            "/ cg: still a kludge - but less ugly
            self changed:#subImageIn with:(imageBox expandedBy: 1).

            self setModified.
        ].
    ].

    "Modified: / 10.2.2000 / 23:42:08 / cg"
!

copyAt: aPoint
    "drag a filled box, 
     when released copy the selected rectangle to the clipboard"

    |choosenBox box copiedImage|

    choosenBox := self dragRectangleStartingAt: aPoint emphasis: #inverseFilledBox.
    choosenBox notNil ifTrue:[
        box := choosenBox origin // magnification extent: (choosenBox extent // magnification).
        copiedImage := image subImageIn: box.

        self class copyImageToClipboard:copiedImage.

        self redraw:(choosenBox expandedBy:1)
    ]

    "Modified: / 21.8.1998 / 20:16:41 / cg"
!

copyImageToClipboard
    self class copyImageToClipboard:image.
    self setClipboardObject:image.
!

cropLeft:doLeft right:doRight top:doTop bottom:doBottom
    |yMinNew yMaxNew xMinNew xMaxNew
     pix stillCropping xMax yMax|

    xMax := image width - 1.
    yMax := image height - 1.

    xMinNew := 0.
    doLeft ifTrue:[
        pix := image pixelAtX:xMinNew y:0.
        stillCropping := true.
        [stillCropping] whileTrue:[
            0 to:yMax do:[:y |
                (image pixelAtX:xMinNew y:y) ~~ pix ifTrue:[
                    stillCropping := false
                ]
            ].
            stillCropping ifTrue:[
                xMinNew := xMinNew + 1.
                xMinNew >= image width ifTrue:[
                    self warn:(resources string:'Image is all the same color - no crop.').
                    ^ self
                ]
            ].
        ].
    ].

    xMaxNew := xMax.
    doRight ifTrue:[
        stillCropping := true.
        pix := image pixelAtX:xMaxNew y:0.
        [stillCropping] whileTrue:[
            0 to:yMax do:[:y |
                (image pixelAtX:xMaxNew y:y) ~~ pix ifTrue:[
                    stillCropping := false
                ]
            ].
            stillCropping ifTrue:[
                xMaxNew := xMaxNew - 1.
            ].
        ].
    ].

    yMinNew := 0.
    doTop ifTrue:[
        pix := image pixelAtX:xMinNew y:yMinNew.
        stillCropping := true.
        [stillCropping] whileTrue:[
            xMinNew to:xMaxNew do:[:x |
                (image pixelAtX:x y:yMinNew) ~~ pix ifTrue:[
                    stillCropping := false
                ]
            ].
            stillCropping ifTrue:[
                yMinNew := yMinNew + 1.
            ].
        ].
    ].

    yMaxNew := yMax.
    doRight ifTrue:[
        stillCropping := true.
        pix := image pixelAtX:xMaxNew y:yMaxNew.
        [stillCropping] whileTrue:[
            xMinNew to:xMaxNew do:[:x |
                (image pixelAtX:x y:yMaxNew) ~~ pix ifTrue:[
                    stillCropping := false
                ]
            ].
            stillCropping ifTrue:[
                yMaxNew := yMaxNew - 1.
            ].
        ].
    ].

    (xMinNew == 0
    and:[xMaxNew == (image width - 1)
    and:[yMinNew == 0
    and:[yMaxNew == (image height - 1)]]]) ifTrue:[
        self warn:(resources string:'No border found - no crob.').
        ^ self
    ].

"/    self warn:'extract subImage ' 
"/              , (xMinNew @ yMinNew) printString
"/              , ' -> '
"/              , (xMaxNew @ yMaxNew) printString.

    self makeUndo.
    self 
        makeSubImageX:xMinNew y:yMinNew 
        width:(xMaxNew - xMinNew + 1)
        height:(yMaxNew - yMinNew + 1)

    "Created: / 7.9.1998 / 14:25:52 / cg"
    "Modified: / 7.9.1998 / 16:35:35 / cg"
!

fillAt: aPoint
    "perform a flood-fill with the currently selected color"

    windowGroup withExecuteCursorDo:[
        |filledPoints clr|

        (clr := self selectedColor) notNil ifTrue:[
            self updateActivity:'Flood filling - press CTRL-y to abort ...'.
            [
                |pix fillColor|

                image colorMap isNil ifTrue:[
                    image floodFillAt: aPoint//magnification withColor:clr.
                ] ifFalse:[
                    pix := self selectedColorIndex.
                    image floodFillAt:aPoint//magnification withValue:pix.
                ].
                image restored.

                self invalidate.
                self changed:#subImageIn with:(image bounds).

                self setModified.
            ] ifCurtailed:[
                self updateActivity:'Flood fill aborted.'
            ].
        ].
        self updateActivity:''
    ]

    "Modified: / 10.2.2000 / 23:40:58 / cg"
!

filledBoxAt: aPoint
    "drag a filled box, 
     when released fill a rectangular area with the currently selected color"

    |choosenBox imageBox clr pix|

    (clr := self selectedColor) notNil ifTrue:[
        choosenBox := self dragRectangleStartingAt: aPoint emphasis: #filledBox.
        choosenBox notNil ifTrue:[
            imageBox := choosenBox origin//magnification extent: (choosenBox extent//magnification).

            image colorMap isNil ifTrue:[
                image fillRectangle:imageBox withColor:clr.
            ] ifFalse:[
                pix := self selectedColorIndex.
                image fillRectangle:imageBox withValue:pix.
"/                maskVal := pix isNil ifTrue:[0] ifFalse:[1].
"/                image mask notNil ifTrue:[
"/                    image mask fillRectangle:imageBox withValue:maskVal
"/                ].
            ].
            image restored.
            self redraw: (choosenBox expandedBy: 1).

            self changed:#subImageIn with:(imageBox expandedBy: 1).
            self setModified.
        ]
    ]

    "Modified: / 10.2.2000 / 23:37:04 / cg"
!

flipSubImage:how in:imageBox
    "/ now, do it
    "/ caveat: this should go into image class

    |x0 y0 x1 y1 image t|

    self makeUndo.

    x0 := imageBox left.
    y0 := imageBox top.
    x1 := imageBox right-1.
    y1 := imageBox bottom-1.

    image := self image.

    how == #vertical ifTrue:[
        0 to:((y1-y0)//2) do:[:dy |
            x0 to:x1 do:[:x |
                t := image pixelAtX:x y:(y0+dy).
                image pixelAtX:x y:(y0+dy) put:(image pixelAtX:x y:(y1-dy)).
                image pixelAtX:x y:(y1-dy) put:t.
                image mask notNil ifTrue:[
                    t := image maskAtX:x y:(y0+dy).
                    image maskAtX:x y:(y0+dy) put:(image maskAtX:x y:(y1-dy)).
                    image maskAtX:x y:(y1-dy) put:t.
                ].
            ].
        ]
    ] ifFalse:[
        0 to:((x1-x0)//2) do:[:dx |
            y0 to:y1 do:[:y |
                t := image pixelAtX:(x0+dx) y:y.
                image pixelAtX:(x0+dx) y:y put:(image pixelAtX:(x1-dx) y:y).
                image pixelAtX:(x1-dx) y:y put:t.

                image mask notNil ifTrue:[
                    t := image maskAtX:(x0+dx) y:y.
                    image maskAtX:(x0+dx) y:y put:(image maskAtX:(x1-dx) y:y).
                    image maskAtX:(x1-dx) y:y put:t.
                ].
            ].
        ]
    ].

    self setModified.

    "Created: / 07-04-2011 / 09:34:23 / cg"
!

magnifyAntiAliasedImageTo:newSize
    self newImageWithUndo: (image hardAntiAliasedMagnifiedBy: newSize/image extent).
!

magnifyImageTo:newSize
    self newImageWithUndo: (image magnifiedBy: newSize/image extent).
!

makeNewColorMapByMapping:functionOfColor
    |xMax yMax map revMap anyChange
     newColors newColorArray newImage pixelAction|

    anyChange := false.

    xMax := image width - 1.
    yMax := image height - 1.

    newImage := image class width:image width height:image height depth:image depth.
    newImage photometric:image photometric.
    "/ newImage colorMap:(image colorMap copy).
    newImage bits:(ByteArray new:(image bits size)).
    newImage mask:(image mask copy).

    image colorMap notNil ifTrue:[
        newColors := Set new.
        newColorArray := OrderedCollection new.
        map := Array new:256.
        revMap := OrderedCollection new.

        pixelAction := 
            [:x :y |
                |pix n_pix clr n_clr|

                pix := image pixelAtX:x y:y.
                (n_pix := map at:pix+1) isNil ifTrue:[
                    clr := image colorAtX:x y:y.
                    n_clr := functionOfColor value:clr.
                    (newColors includes:n_clr) ifFalse:[
                        newColors add:n_clr.
                        newColorArray add:n_clr.
                        revMap add:pix.
                        map at:pix+1 put:(n_pix := revMap size - 1).
                    ] ifTrue:[
                        "/ mhmh - multiple pixels mapped to the same color
                        n_pix := (newColorArray indexOf:n_clr) - 1.
                        map at:pix+1 put:n_pix.
                    ]
                ].
                newImage pixelAtX:x y:y put:n_pix.
            ].
    ] ifFalse:[
        pixelAction := 
            [:x :y |

                |clr n_clr|

                clr := image colorAtX:x y:y.
                n_clr := functionOfColor value:clr.
                newImage colorAtX:x y:y put:n_clr.
            ].
    ].

    0 to:yMax do:[:y |
        0 to:xMax do:[:x |
            pixelAction value:x value:y
        ]
    ].

    image colorMap notNil ifTrue:[
        newImage colorMap:(MappedPalette withColors:newColorArray).
    ].
    self newImageWithUndo:newImage.
    ^ true
!

makeSubImageX:oldX y:oldY width:newWidth height:newHeight
    |oldWidth oldHeight newImage newMaskImage needRedraw redrawRect1 redrawRect2 |

    oldWidth := image width.
    oldHeight := image height.
    self assert:(newWidth <= oldWidth).
    self assert:(newHeight <= oldHeight).

    newImage := image class width:newWidth height:newHeight depth:image depth.
    newImage photometric:image photometric.
    newImage colorMap:image colorMap copy.
    newImage bits:(ByteArray new:(newImage bytesPerRow * newHeight)).

    image mask notNil ifTrue:[
        newMaskImage := Depth1Image width:newWidth height:newHeight.
        newMaskImage photometric: image mask photometric.
        newMaskImage colorMap: image mask colorMap copy.
        newMaskImage bits:(ByteArray new: newMaskImage bytesPerRow * newHeight).
        newImage mask: newMaskImage
    ].

    newImage copyFrom:image x:oldX y:oldY toX:0 y:0 width:newWidth height:newHeight.

    needRedraw := true.
    (oldX == 0 and:[oldY == 0]) ifTrue:[
        needRedraw := false.
        redrawRect1 := ((newWidth@0) * magnification) corner:(((oldWidth@oldHeight)+1) * magnification).
        redrawRect2 := ((0@newHeight) * magnification) corner:(((oldWidth@oldHeight)+1) * magnification).
    ].
    self image:newImage scroll:false invalidate:needRedraw.
    redrawRect1 notNil ifTrue:[
        self invalidateRectangle:redrawRect1 repairNow:false.
    ].
    redrawRect2 notNil ifTrue:[
        self invalidateRectangle:redrawRect2 repairNow:false.
    ].
    self setModified.

    "Created: / 07-09-1998 / 13:00:16 / cg"
    "Modified: / 07-09-1998 / 14:15:32 / cg"
    "Modified (format): / 16-11-2016 / 23:07:50 / cg"
!

makeUndo
    image notNil ifTrue:[       
        [undoImages size >= MaxUndos] whileTrue:[
            undoImages removeFirst.
        ].
        undoImages add:image copy
    ]

    "Modified: / 20-11-2007 / 17:26:50 / cg"
!

pasteAt: aPoint
    "paste the image in the clipboard at aPoint"

    self pasteAt:aPoint mode:nil.
!

pasteAt: aPoint mode:modeSymbol
    "paste the image in the clipboard at aPoint"

    |answer anyColorMissing choosenBox imagePoint imgX imgY copiedImage imageBox newColorMap
     existingColors newColors allColors currentColorMap newColormap anyColorAdded oldColorMap|

    Error handle:[:ex|
        ex creator == Image unrepresentableColorSignal ifFalse:[
            ex reject
        ].
        self undo.
        self warn:(resources stringWithCRs:'Paste failed !!\Increasing the images depth might help.'). 
    ] do: [   
        windowGroup withExecuteCursorDo:[
            choosenBox := self dragRectangleStartingAt: aPoint emphasis: #inverseFilledBox.
            choosenBox isNil ifTrue:[ ^ self ].

            imagePoint := choosenBox origin//magnification.

            copiedImage := Clipboard copy.
            copiedImage isNil ifTrue:[^ self].
            
            true "/ image photometric == #palette 
            ifTrue:[
                "/ for all colors in the pasted image,
                "/ check, if its in the colormap of the
                "/ target image.

                anyColorMissing := anyColorAdded := false.
                oldColorMap := image colorMap.
                oldColorMap notNil ifTrue:[
                    newColorMap := oldColorMap asOrderedCollection.
                    copiedImage usedValues do:[:pixel |
                        |pastedColor |

                        pastedColor := copiedImage colorFromValue:pixel.

                        (newColorMap includes:pastedColor) ifFalse:[
                            newColorMap size < (1 bitShift:image depth) ifTrue:[
                                "/ add to colormap
                                newColorMap add:pastedColor.
                                anyColorAdded := true.
        "/                        Transcript showCR:'adding color:' , pastedColor displayString , ' to targets colorMap'.
                            ] ifFalse:[
        "/                        Transcript showCR:'color:' , pastedColor displayString , ' not found in targets colorMap'.
"/                                copiedImage colorMap notNil ifTrue:[
"/                                    copiedImage colorMap at: pixel+1 put: Color black.
"/                                ].
                                anyColorMissing := true.
                            ]
                        ]
                    ].
                ].

                anyColorMissing ifTrue:[
                    answer := Dialog
                                confirmWithCancel:(resources stringWithCRs:'Some color(s) cannot be represented (colorMap full).\Use nearest or compute colorMap ?') 
                                labels:#( 'Cancel' 'New ColorMap' 'Use Nearest' )
                                values:#(  nil new nearest)
                                default:3.

                    answer isNil ifTrue:[^ self].

                    currentColorMap := image colorMap.
                    imgX := imagePoint x.
                    imgY := imagePoint y.

                    answer == #nearest ifTrue:[
                        0 to:copiedImage height-1 do:[:y |
                            0 to:copiedImage width-1 do:[:x |
                                |clr n_clr|

                                (copiedImage maskAtX:x y:y) == 0 ifTrue:[
                                    image mask isNil ifTrue:[
                                        image createMask.
                                    ].
                                    image maskAtX:imgX+x y:imgY+y put:0.
                                ] ifFalse:[
                                    clr := copiedImage colorAtX:x y:y.
                                    n_clr := clr nearestIn:currentColorMap.
                                    image colorAtX:imgX+x y:imgY+y put:n_clr
                                ]
                            ]
                        ].
                        image restored.
                        self redraw: (imageBox := (imagePoint * magnification extent: (Clipboard extent * magnification)) expandedBy: 1@1).
                        self setModified.
                        ^ self.
                    ].
                    answer == #new ifTrue:[
                        existingColors := image usedValues asIdentitySet.
                        newColors := copiedImage usedValues.
                        allColors := existingColors addAll:newColors.
                        allColors size > (1 bitShift:image depth) ifTrue:[
                            self warn:(resources string:'Sorry: too many colors - unimplemented function').
                            self undo.
                            ^ self.
                        ].

                        newColormap := OrderedCollection new.
                        newColormap addAll:image usedColors.
                        newColormap addAll:copiedImage usedColors.
                        "/ translate image to use new colorMap...

                        "/ translate image to use new colors ...
                        0 to:image height-1 do:[:y |
                            0 to:image width-1 do:[:x |
                                |clr n_idx|

                                (image maskAtX:x y:y) == 1 ifTrue:[
                                    clr := image colorAtX:x y:y.
                                    n_idx := newColormap indexOf:clr.
                                    image pixelAtX:x y:y put:n_idx-1.
                                ]
                            ]
                        ].
                        image colorMap:newColormap.
                        currentColorMap := newColormap.    

                        "/ paste new image...    
                        0 to:copiedImage height-1 do:[:y |
                            0 to:copiedImage width-1 do:[:x |
                                |clr idx|

                                (copiedImage maskAtX:x y:y) == 1
                                ifTrue:[
                                    clr := copiedImage colorAtX:x y:y.
                                    idx := currentColorMap indexOf:clr.
                                    idx == 0 ifTrue:[
                                        currentColorMap add:clr.
                                        idx := currentColorMap size.
                                        idx > (1 bitShift:image depth) ifTrue:[
                                            self warn:(resources string:'Sorry: too many colors').
                                            self undo.
                                            ^ self.
                                        ].
                                    ].
                                    image pixelAtX:imgX+x y:imgY+y put:idx-1.
                                    image maskAtX:imgX+x y:imgY+y put:1.
                                ]
                            ]
                        ].
                        image restored.
                        self redraw: (imageBox := (imagePoint * magnification extent: (Clipboard extent * magnification)) expandedBy: 1@1).
                        self setModified.
                        ^ self.
                    ].
                    self warn:(resources string:'Sorry: unimplemented function').
                    self undo.
                    ^ self.
                ].
                anyColorAdded ifTrue:[
                    image colorMap:(MappedPalette withColors:newColorMap).
                ].
            ].

            copiedImage := image class fromImage: copiedImage.
            (newColorMap isNil 
            and:[modeSymbol isNil
            and:[copiedImage mask isNil] ]) ifTrue:[
                "/ use images copy functionality
                "/ however, this copies the mask as well,
                "/ which is not useful here
                image copyFrom: copiedImage x:0 y:0 toX: imagePoint x y: imagePoint y width: copiedImage width height: copiedImage height.
            ] ifFalse:[
                imgX := imagePoint x.
                imgY := imagePoint y.

                0 to:copiedImage height-1 do:[:y |
                    0 to:copiedImage width-1 do:[:x |
                        |wasMasked newMasked dstX dstY oldColor|

                        dstX := imgX + x.
                        dstY := imgY + y.
                        wasMasked := (image maskAtX:dstX y:dstY) == 0.
                        newMasked := (copiedImage maskAtX:x y:y) == 0.

                        "/ with modeUnder, 
                        "/ only replace, if its either unmasked,
                        "/ or the current drawing color.
                        (modeSymbol isNil
                        or:[wasMasked
                        or:[modeSymbol == #withMask]])
                        ifTrue:[
                            newMasked ifFalse:[
                                image colorAtX:dstX y:dstY put:(copiedImage colorAtX:x y:y).
                                wasMasked ifTrue:[
                                    image maskAtX:dstX y:dstY put:1
                                ].
                            ] ifTrue:[
                                wasMasked ifFalse:[
                                    modeSymbol == #withMask ifTrue:[
                                        image maskAtX:dstX y:dstY put:0
                                    ]
                                ]
                            ].
                        ].

                    ]
                ].
            ].
            image restored.
            self redraw: (imageBox := (imagePoint * magnification extent: (Clipboard extent * magnification)) expandedBy: 1@1).
"/            masterApplication imagePreView redraw: (imageBox expandedBy: 1).
            self setModified.
        ]
   ]

    "Modified: / 18.5.1999 / 20:40:37 / cg"
!

pasteUnderAt: aPoint
    "pasteUnder the image in the clipboard at aPoint.
     In this mode, only pixels which are not equal to
     the current color or masked are pasted."

    self pasteAt:aPoint mode:#under.
!

pasteWithMaskAt: aPoint
    "paste the image in the clipboard at aPoint.
     In this mode, both the mask and the image pixel are pasted"


    self pasteAt:aPoint mode:#withMask.
!

performSpecialOperationOn:imageBox withColor:clr
    |listOfOpNames listOfOpSelectors operation x0 y0 x1 y1 pixelAction requiredColors missingColors answer hue|

    listOfOpNames := OrderedCollection new.
    listOfOpSelectors := OrderedCollection new. 
    
    listOfOpNames addAll:
        (resources array:#(
           'edit separately'
           'extract subimage'
        )).
    listOfOpSelectors addAll:
        #(
            #edit
            #editSubImage
        ).

    self readOnly ifFalse:[
        listOfOpNames addAll:
            (resources array:#(
               '-'
               'flip vertical'
               'flip horizontal'
               '-'
               'slightly brightened'
               'slightly darkened'
               'brightened'
               'darkened'
               '-'
               'make grey'
               'greyed'
               'grey pattern'
               'grey pattern (unmasked)'
               '-'
               'reversed'
               '-'
               'change hue'
               'colorize'
             )).
                 
        listOfOpSelectors addAll:
            #(nil
              flipVertical flipHorizontal nil
              slightlyBrightened slightlyDarkened brightened darkened nil 
              makeGrey greyed greyPattern unmaskedGreyPattern nil 
              reversed nil 
              changeHue colorize
            ).
    ].
    
    operation := Dialog 
           choose:(resources string:'Which Operation:')
           fromList:listOfOpNames
           values:listOfOpSelectors
           lines:10
           cancel:nil.

    self invalidate.
    self windowGroup processExposeEvents.

    operation isNil ifTrue:[^ false].

    x0 := imageBox left.
    y0 := imageBox top.
    x1 := imageBox right - 1.
    y1 := imageBox bottom -1 .

    operation == #edit ifTrue:[
        (self image subImageIn:imageBox) edit.
        ^ false.
    ].
    operation == #editSubImage ifTrue:[
        self makeUndo.
        self image:(self image subImageIn:imageBox).
        ^ false.
    ].
    operation == #flipVertical ifTrue:[
        self flipSubImage:#vertical in:imageBox.
        ^ true.
    ].
    operation == #flipHorizontal ifTrue:[
        self flipSubImage:#horizontal in:imageBox.
        ^ true.
    ].

    operation == #slightlyBrightened ifTrue:[
        pixelAction := [:x :y :clr | clr slightlyLightened].
    ].
    operation == #slightlyDarkened ifTrue:[
        pixelAction := [:x :y :clr | clr slightlyDarkened].
    ].
    operation == #brightened ifTrue:[
        pixelAction := [:x :y :clr | clr lightened].
    ].
    operation == #darkened ifTrue:[
        pixelAction := [:x :y :clr | clr darkened].
    ].
    operation == #reversed ifTrue:[
        pixelAction := [:x :y :clr | Color red:(100-clr red) green:(100-clr green) blue:(100-clr blue) ].
    ].
    operation == #makeGrey ifTrue:[
        pixelAction := [:x :y :clr | Color grey:(clr greyIntensity)].
    ].
    operation == #greyed ifTrue:[
        pixelAction := [:x :y :clr | clr blendWith:Color gray].
    ].
    operation == #greyPattern ifTrue:[
        pixelAction := [:x :y :clr | x odd == y even 
                                        ifTrue:[Color gray] 
                                        ifFalse:[clr]].
    ].
    operation == #unmaskedGreyPattern ifTrue:[
        pixelAction := [:x :y :clr | x odd == y even 
                                        ifTrue:[self image maskAtX:x y:y put:1. Color gray] 
                                        ifFalse:[clr]].
    ].

    operation == #changeHue ifTrue:[
        hue := Dialog request:'Hue (0..360)\red->yellow->green->blue->red' withCRs.
        hue := Number readFrom:hue onError:nil.
        hue isNil ifTrue:[^ false].
        pixelAction := [:x :y :clr | Color hue:(hue+(clr hue?0)) light:clr light saturation:clr saturation].
    ].
    operation == #colorize ifTrue:[
        hue := Dialog request:'Hue (0..360)\red->yellow->green->blue->red' withCRs.
        hue := Number readFrom:hue onError:nil.
        hue isNil ifTrue:[^ false].
        pixelAction := [:x :y :clr | Color hue:hue light:clr light saturation:100]
    ].

    pixelAction isNil ifTrue:[
        self halt:(resources string:'no pixelAction'). 
        ^ false
    ].

    image colorMap notNil ifTrue:[
        "/ compute required colors ...
        requiredColors := Set new.
        self image 
            colorsFromX:x0 y:y0 toX:x1 y:y1 
            do:[:x :y :clr | 
                requiredColors add:(pixelAction value:x value:y value:clr)
            ].

        missingColors := requiredColors reject:[:clr | (image colorMap includes:clr)].

        missingColors notEmpty ifTrue:[
            answer := Dialog
                        confirmWithCancel:(resources stringWithCRs:'Some color(s) cannot be represented in the images colorMap.\Use nearest or compute colorMap ?')
                        labels:#( 'Cancel' 'Add to ColorMap'  'Use Nearest')
                        values:#( nil add nearest)
                        default:3.
            answer isNil ifTrue:[^ false].
            answer == #add ifTrue:[
                missingColors size + image colorMap size > (2 raisedTo:image depth) ifTrue:[
                    self warn:(resources string:'Missing colors cannot be added to images colormap.').
                    ^ false
                ].
                missingColors do:[:eachColor |
                    image colorMap add:eachColor
                ].
                answer := #nearest.
            ].
        ].
    ].

    "/ now, do it
    self image 
        colorsFromX:x0 y:y0 toX:x1 y:y1 
        do:[:x :y :clr |
            |newClr|

            newClr := pixelAction value:x value:y value:clr.
            answer == #nearest ifTrue:[
                newClr := newClr nearestIn:image colorMap
            ].
            self image colorAtX:x y:y put:newClr
        ].

    self setModified.
    ^ true.

    "Modified: / 07-04-2011 / 09:28:20 / cg"
!

pointAt:aPoint
    "draw a single pixel with the currently selected color"

    self pointAt:aPoint width:self penWidth.

    "Modified: / 15-02-2012 / 22:47:30 / cg"
!

pointAt:aPoint width:pw
    "draw a single pixel (or dot of width pw) with the currently selected color"

    |draw imagePoint clr pix|

    imagePoint := aPoint // magnification.
    (imagePoint x between:0 and:image width-1) ifFalse:[^ self].
    (imagePoint y between:0 and:image height-1) ifFalse:[^ self].

    draw := 
        [:point |
            image colorMap isNil ifTrue:[
                clr := self selectedColor.
                image atImageAndMask:point put:clr.
            ] ifFalse:[
                pix := self selectedColorIndex.
                image atImageAndMask:point putValue:pix.
            ].             
            self invalidate:((point * magnification extent: magnification) expandedBy:1).
        ].

    draw value:imagePoint.

    pw > 1 ifTrue:[
        "/ draw with a wide pen
        (pw//2) negated to:(pw-(pw//2)-1) do:[:xOffs |
            (pw//2) negated to:(pw-(pw//2)-1) do:[:yOffs |
                imagePoint x + xOffs >= 0 ifTrue:[
                    imagePoint y + yOffs >= 0 ifTrue:[
                        draw value:(imagePoint + (xOffs@yOffs)).
                    ].
                ].
            ].
        ].
    ].
    self setModified.

    "Created: / 15-02-2012 / 22:47:08 / cg"
!

shiftImageHorizontal:shiftH vertical:shiftV
    self shiftImageHorizontal:shiftH vertical:shiftV wrap:false
!

shiftImageHorizontal:shiftH vertical:shiftV wrap:doWrap
    "shift the pixels; 
     shift<0 is left-shift/up-shift; shift>0 is right-shift/down-shift;
     doWrap controls if shifted-out pixels are to be shifted in at the opposite side.
     i.e.:
        0123456789 -> 3456789789 (shift: -3)    0123456789 -> 0120123456 (shift:3)
     or, with wrap:
        0123456789 -> 3456789012 (shift: -3)    0123456789 -> 7890123456 (shift:3)
    "

    |newImage|

    newImage := self shifted:image horizontal:shiftH vertical:shiftV wrap:doWrap.
    self image:newImage.
    self setModified.
!

shifted:image horizontal:shiftH vertical:shiftV wrap:doWrap
    "shift the pixels; 
     shift<0 is left-shift/up-shift; shift>0 is right-shift/down-shift;
     doWrap controls if shifted-out pixels are to be shifted in at the opposite side.
     i.e.:
        0123456789 -> 3456789789 (shift: -3)    0123456789 -> 0120123456 (shift:3)
     or, with wrap:
        0123456789 -> 3456789012 (shift: -3)    0123456789 -> 7890123456 (shift:3)
    "

    |w h srcX srcY dstX dstY newImage|

    doWrap ifTrue:[
        "/ if wrapping, split into two operations to make wrap-code below simpler.

        shiftH ~~ 0 ifTrue:[
            shiftV ~~ 0 ifTrue:[
                newImage := self shifted:image    horizontal:shiftH vertical:0 wrap:doWrap.
                newImage := self shifted:newImage horizontal:0      vertical:shiftV wrap:doWrap.
                ^ newImage
            ].
        ].
    ].
    (shiftV == 0 and:[shiftH == 0]) ifTrue:[
        ^ image
    ].

    w := image width.
    h := image height.

    newImage := image copy.

    srcX := srcY := dstX := dstY := 0.
    shiftH < 0 ifTrue:[
        srcX := shiftH negated
    ] ifFalse:[
        dstX := shiftH
    ].
    shiftV < 0 ifTrue:[
        srcY := shiftV negated
    ] ifFalse:[
        dstY := shiftV
    ].

    newImage copyFrom:image x:srcX y:srcY toX:dstX y:dstY width:w-shiftH abs height:h-shiftV abs.

    doWrap ifTrue:[
        srcX := srcY := dstX := dstY := 0.

        "/ already simplified - see above
        shiftH ~~ 0 ifTrue:[
            "/ shiftV known to be 0
            shiftH < 0 ifTrue:[
                dstX := w-1-shiftH negated
            ] ifFalse:[
                srcX := w-1-shiftH
            ].
            w := shiftH abs.
        ] ifFalse:[
            "/ shiftH known to be 0
            shiftV < 0 ifTrue:[
                dstY := h-1-shiftV negated
            ] ifFalse:[
                srcY := h-1-shiftV
            ].
            h := shiftV abs.
        ].
        newImage copyFrom:image x:srcX y:srcY toX:dstX y:dstY width:w height:h.
        ^ newImage
    ].

    ^ newImage.

    "Created: / 7.9.1998 / 13:00:16 / cg"
    "Modified: / 7.9.1998 / 14:15:32 / cg"
!

smoothAt:aPoint
    "smoth (average) a single pixel with pixels around"

    |draw imagePoint x y w h|

    imagePoint := aPoint // magnification.
    w := image width.
    h := image height.
    ((x := imagePoint x) between:0 and:w-1) ifFalse:[^ self].
    ((y := imagePoint y) between:0 and:h-1) ifFalse:[^ self].

    draw := 
        [:point |
            |sumRed sumGreen sumBlue newClr|

            sumRed := sumGreen := sumBlue := 0.
            -1 to:1 do:[:dx |
                -1 to:1 do:[:dy |
                    |clr|

                    ((x + dx) between:0 and:w-1) ifTrue:[
                        ((y + dy) between:0 and:h-1) ifTrue:[   
                            clr := image colorAtX:(x + dx) y:(y + dy).
                            sumRed := sumRed + clr redByte.
                            sumGreen := sumGreen + clr greenByte.
                            sumBlue := sumBlue + clr blueByte.
                        ]
                    ].
                ]
            ].
            newClr := Color 
                        redByte:(sumRed / 9) rounded
                        greenByte:(sumGreen / 9) rounded 
                        blueByte:(sumBlue / 9) rounded. 
            image colorMap isNil ifTrue:[
Transcript 
    show:(image colorAt:point);
    show:' -> ';
    showCR:newClr.
                image atImageAndMask:point put:newClr.
            ] ifFalse:[
                image atImageAndMask:point put:(image colorMap colorNearestTo:newClr).
            ].             
            self invalidate:((point * magnification extent: magnification) expandedBy:1).
        ].

    draw value:imagePoint.
    self setModified.
!

specialOperationAt: aPoint
    "special operation on a rectangular area"

    |choosenBox imageBox|

    choosenBox := self dragRectangleStartingAt: aPoint emphasis:#inverseFilledBox.
    choosenBox isNil ifTrue:[ ^ self ].

    imageBox := choosenBox origin//magnification extent: (choosenBox extent//magnification).

    (self performSpecialOperationOn:imageBox withColor:self selectedColor) ifFalse:[
        ^ self
    ].

    image restored.
    self invalidate. "/ : (choosedBox expandedBy: 1).

    "/ self redraw: (choosedBox expandedBy: 1).

"/        "/ cg: what a kludge - please change to use a valueHolder,
"/        "/ which gets the information ...
"/        masterApplication imagePreView redraw: (imageBox expandedBy: 1).

        "/ cg: still a kludge - but less ugly
    self changed:#subImageIn with:(imageBox expandedBy: 1).

    self setModified.
!

sprayAt: aPoint
    "start spraying with the currently selected color"

    |clr|

    (clr := self selectedColor) notNil ifTrue:[
        sprayPosition := aPoint.
        self startSpray.
    ].
!

text:aString at:aPoint
    "draw a character"

    |tempForm|

    tempForm := Form extent:(image extent) depth:1 onDevice:device.
    tempForm clear.
    tempForm paint:(Color colorId:1).
    tempForm displayString:aString at:aPoint.
    0 to:image extent x - 1 do:[:x |
        0 to:image extent y - 1 do:[:y |
            (tempForm valueAt:(x@y)) == 1 ifTrue:[
                self pointAt:(x@y) width:1
            ].
        ]
    ].

    "Modified: / 15-02-2012 / 22:47:44 / cg"
!

undo
    undoImages notEmpty ifTrue:[           
        windowGroup withExecuteCursorDo:[
            |oldImage newImage|
            
            oldImage := self image.
            newImage := undoImages removeLast.
            self clearModified.
            self image:newImage scroll:(newImage extent ~= oldImage extent) "false".
            "/ self changed:#image.
        ]
    ]

    "Modified: / 10.2.2000 / 23:21:24 / cg"
! !

!ImageEditView methodsFor:'image manipulation'!

brightenImage
    self newImageWithUndo: (image copy lightened).
!

darkenImage
    self newImageWithUndo: (image copy darkened).
!

flipHorizontal

    self newImageWithUndo: image copy flipHorizontal.
!

flipVertical

    self makeUndo.
    self image: image copy flipVertical.
    self setModified.
!

makeBorderedImageX:newX y:newY width:newWidth height:newHeight
    |newImage oldWidth oldHeight|

    oldWidth := image width.
    oldHeight := image height.

    newImage := image class width:newWidth height:newHeight depth:image depth.
    newImage photometric:image photometric.
    newImage colorMap:image colorMap copy.
    newImage bits:(ByteArray new:(newImage bytesPerRow * newHeight)).

    image mask notNil ifTrue:[
        |newMaskImage|

        newMaskImage := Depth1Image width:newWidth height:newHeight.
        newMaskImage photometric: image mask photometric.
        newMaskImage colorMap: image mask colorMap copy.
        newMaskImage bits:(ByteArray new: newMaskImage bytesPerRow * newHeight).
        newImage mask: newMaskImage
    ].

    newImage copyFrom:image x:0 y:0 toX:newX y:newY width:oldWidth height:oldHeight.
    self newImageWithUndo:newImage.

    "Created: / 7.9.1998 / 13:00:16 / cg"
    "Modified: / 7.9.1998 / 14:15:32 / cg"
!

makeBrighter
    ^ self makeNewColorMapByMapping:[:clr | clr lightened].
!

makeDarker
    ^ self makeNewColorMapByMapping:[:clr | clr darkened].
!

makeGrayScaleImage
    ^ self makeNewColorMapByMapping:
        [:clr | Color brightness:(clr brightness)].
!

makeInverse
    ^ self makeNewColorMapByMapping:
        [:clr | 
            Color red:(100-clr red) green:(100-clr green) blue:(100-clr blue)
        ].
!

makeSlightlyBrighter
    ^ self makeNewColorMapByMapping:
        [:clr | 
            clr brightness > Color lightGray brightness
                ifTrue:[ clr blendWith:self whiteColor ] 
                ifFalse:[ clr blendWith:Color lightGray ]
        ].

    "Created: / 24-11-2010 / 11:08:18 / cg"
!

makeSlightlyDarker
    ^ self makeNewColorMapByMapping:
        [:clr | 
            clr brightness < Color darkGray brightness
                ifTrue:[ clr blendWith:Color black ] 
                ifFalse:[ clr blendWith:Color darkGray ]
        ].

    "Created: / 24-11-2010 / 11:08:08 / cg"
!

negativeImage

    self newImageWithUndo: (image copy bits:(image bits invert)).
!

newImageWithUndo:newImage

    self makeUndo.
    self image: newImage.
    self setModified.
!

reduceColorResolutionBy:numBits
    |newImage|

    numBits > 7 ifTrue:[
        self warn:(resources string:'Max. number of bits to strip off is 7.').
        ^ false
    ].
    newImage := image withColorResolutionReducedBy:numBits.
    newImage isNil ifTrue:[
        self warn:(resources string:'Could not reduce color resolution.').
        ^ false.
    ].

    self newImageWithUndo:newImage.
    ^ true
!

resizeImageTo:newSize
    self newImageWithUndo: (self resizedImage:image to:newSize).
!

resizedImage:image to:newSize
    "helper for image resize and mask resize.
     return a resized version of image"

    |newImage newMaskImage|

    newImage := image class width: newSize x height: newSize y depth: image depth.
    newImage photometric:image photometric.
    newImage colorMap:image colorMap copy.
    newImage bits: (ByteArray new: newImage bytesPerRow * newSize y).

    image mask notNil ifTrue:[
        newMaskImage := Depth1Image width: newSize x height: newSize y.
        newMaskImage photometric: image mask photometric.
        newMaskImage colorMap: image mask colorMap copy.
        newMaskImage bits:(ByteArray new: newMaskImage bytesPerRow * newSize y).
        newImage mask: newMaskImage
    ].

    newImage copyFrom:image x:0 y:0 toX:0 y:0 width: (image width min:newSize x) height: (image height min:newSize y).
    ^ newImage.
!

rotateImageBy:rotation
    "rotate by (degrees)"

    Error handle:[:ex|
        self warn: 'Image rotation failed!!\' withCRs, 'Increasing the image depth could help.'
    ] do:[   
        self newImageWithUndo: (image hardRotated: rotation).
    ]

    "Modified: / 29.7.1998 / 18:21:14 / cg"
!

threeDProjection:dx1 and:dx2
    "3D projection"

    Error handle:[:ex|
        self warn: 'Image projection failed!!\' withCRs, 'Increasing the image depth could help.'
    ] do:[   
        self newImageWithUndo:(image threeDProjected:dx1 and:dx2)
    ]

    "Modified: / 29.7.1998 / 18:21:14 / cg"
! !

!ImageEditView methodsFor:'image-dragging & info'!

dragRectangleStartingAt:aPointIn emphasis:emphasis
    "draw a drag rectangle (filled or unfilled, depending on the emphasis arg).
     This is called by operation like 
     rectangle, filledRectangle, copy etc. 
     (i.e. any operation which operates on a box).
     emphasis is one of:
        box              - a frame is drawn
        inverseFilledBox - the dragged box is filled by the inverse color
        filledBox        - the dragged box is filled with black
        grayedBox        - the dragged box is drawn with a gray shadow
    "

    |currentPoint currentExtent firstPoint lastCurrentPoint gridCorrection 
     mp lastMp p whichQuarter scrollX scrollY aPoint sensor|

    aPoint := aPointIn.
    firstPoint := currentPoint := lastCurrentPoint :=  aPoint//magnification*magnification.
    magnification >= GridMagnificationLimit ifFalse: [gridCorrection := 0] ifTrue: [gridCorrection := 1].

    sensor := self sensor.
    [sensor anyButtonPressed] whileTrue: [                                                  
        (sensor hasKeyEventFor:nil) ifTrue:[
            self invalidate.
            ^ nil.
        ].

        mp := sensor mousePoint.
        mp = lastMp ifTrue:[
            Delay waitForSeconds:0.05
        ] ifFalse:[
            lastMp := mp.
            mp := device translatePoint:mp fromView:nil toView:self.
            "/ mp is a device coordinate here ...
            scrollX := 0.
            mp x > width ifTrue:[
                scrollX := mp x - width.
            ] ifFalse:[
                mp x < 0 ifTrue:[
                    scrollX := mp x.
                ]
            ].
            scrollY := 0.
            mp y > height ifTrue:[
                scrollY := mp y - height.
            ] ifFalse:[
                mp y < 0 ifTrue:[
                    scrollY := mp y.
                ]
            ].
            (scrollX + scrollY) ~~ 0 ifTrue:[
                self scrollTo:(self viewOrigin + (scrollX @ scrollY)).
                lastMp := nil.
            ].

            mp := mp + self viewOrigin.
            "/ mp is now a logical coordinate.

            currentPoint := (0@0) max: (image extent * magnification min: (p := mp)).
            currentPoint := currentPoint//magnification*magnification.
            currentExtent := (firstPoint - currentPoint) abs.
            whichQuarter := (firstPoint x - currentPoint x) > 0 
                 ifTrue:  [(firstPoint y - currentPoint y) > 0 ifTrue: ["4"1@1] ifFalse: ["3"1@0]]
                 ifFalse: [(firstPoint y - currentPoint y) > 0 ifTrue: ["1"0@1] ifFalse: ["2"0@0]].

            self showCursorAt: p andInformation: 
                ((firstPoint//magnification - whichQuarter + 1) printString, 
                ' to: ', 
                (currentPoint//magnification + whichQuarter) printString),
                ' (extent: ',
                (currentExtent//magnification) printString, ')'.

            currentPoint ~= lastCurrentPoint ifTrue:[

                emphasis == #grayedBox ifTrue:[
                    "/ does not yet work                
                    |org ext|

                    "/ org := (firstPoint min: lastCurrentPoint) - 1.
                    "/ ext := (firstPoint - lastCurrentPoint) abs + 2.

                    (lastCurrentPoint x > currentPoint x
                      or:[ (lastCurrentPoint y > currentPoint y) ]
                    ) ifTrue:[
                        self 
                            redrawImageX:firstPoint x"-1" y:firstPoint y"-1" 
                            width:(lastCurrentPoint x-firstPoint x"+2") height:(lastCurrentPoint y-firstPoint y"+2")
                            unmaskedOnly:false processColorsWith:[:clr | clr ].
                        "/ self drawFramesIn:(firstPoint corner:lastCurrentPoint).   
                    ].
                    
                    self 
                        redrawImageX:firstPoint x"-1" y:firstPoint y"-1 "
                        width:(currentPoint x-firstPoint x"+2") height:(currentPoint y-firstPoint y"+2") 
                        unmaskedOnly:true processColorsWith:[:clr | Color gray: clr grayIntensity / 2 ].
                ].
                
                emphasis == #inverseFilledBox ifTrue: [
                    |union invertOutside|

                    invertOutside := false.
"/                    union := (firstPoint corner:currentPoint) merge:(firstPoint corner:lastCurrentPoint).
"/                    ((lastCurrentPoint x > currentPoint x)
"/                    and:[ lastCurrentPoint y > currentPoint y ]) ifTrue:[
"/                        "/ a real shrink
"/                        invertOutside := true.
"/                        self xoring: [ 
"/                            union areasOutside:(firstPoint corner:lastCurrentPoint) do:[:r |
"/                                self fillRectangle: ((firstPoint min: currentPoint) + margin extent: currentExtent - gridCorrection) 
"/                            ]
"/                        ]
"/                    ] ifFalse:[    
"/                        ((currentPoint x > lastCurrentPoint x)
"/                        and:[ currentPoint y > lastCurrentPoint y ]) ifTrue:[
"/                            "/ a real grow
"/                            invertOutside := true.
"/                            self xoring: [ 
"/                                union areasOutside:(firstPoint corner:currentPoint) do:[:r |
"/                                    self fillRectangle: ((firstPoint min: currentPoint) + margin extent: currentExtent - gridCorrection) 
"/                                ]
"/                            ]
"/                        ].     
"/                    ].
                    invertOutside ifFalse:[    
                        self redraw: ((firstPoint min: lastCurrentPoint) - 1 extent: (firstPoint - lastCurrentPoint) abs + 2).
                        gc xoring: [ 
                            gc fillRectangle: ((firstPoint min: currentPoint) + margin extent: currentExtent - gridCorrection) 
                        ]
                    ].
                ].
                
                emphasis == #box ifTrue:[
                    |origin extent lineWidthY lineWidthX|

                    origin := (firstPoint min: lastCurrentPoint) - 1.
                    extent := (firstPoint - lastCurrentPoint) abs + 2.
                    lineWidthY := extent y min: (magnification y + 2).
                    lineWidthX := extent x min: (magnification x + 2).
                    self redraw: (origin extent: (extent x@lineWidthY)).
                    self redraw: ((origin x@(origin y + extent y - lineWidthY)) extent: (extent x@lineWidthY)).
                    self redraw: ((origin x@(origin y + lineWidthY)) extent: (lineWidthX@(0 max: (extent y - (lineWidthY * 2))))).
                    self redraw: (((origin x + extent x - lineWidthX)@(origin y + lineWidthY)) extent: (lineWidthX@(extent y - (lineWidthY * 2)))).
                    (self selectedColor ~= Color noColor)
                        ifTrue: [gc paint: self selectedColor]
                        ifFalse: [gc paint: self viewBackground]. 
                    origin := (firstPoint min: currentPoint) + margin.
                    extent := currentExtent - gridCorrection.
                    lineWidthY := extent y min: magnification y.
                    lineWidthX := extent x min: magnification x.
                    (lineWidthY > 0 and: [lineWidthX > 0]) ifTrue:[
                        gc fillRectangle: (origin extent: (extent x@lineWidthY)).
                        gc fillRectangle: ((origin x@(origin y + extent y - lineWidthY)) extent: (extent x@lineWidthY)).
                        gc fillRectangle: ((origin x@(origin y + lineWidthY)) extent: (lineWidthX@(0 max: (extent y - (lineWidthY * 2))))).
                        gc fillRectangle: (((origin x + extent x - lineWidthX)@(origin y + lineWidthY)) extent: (lineWidthX@(extent y - (lineWidthY * 2)))).
                    ]
                ].
                
                emphasis == #filledBox ifTrue:[
                    self redraw: ((firstPoint min: lastCurrentPoint) - 1 extent: (firstPoint - lastCurrentPoint) abs + 2).
                    (self selectedColor ~= Color noColor)
                        ifTrue: [gc paint: self selectedColor]
                        ifFalse: [gc paint: self viewBackground].
                    gc fillRectangle: ((firstPoint min: currentPoint) + margin extent: currentExtent - gridCorrection).
                ].
            ]. 
            lastCurrentPoint := currentPoint.
        ].                  
    ].                  

    ^((0@0) max: (firstPoint min: currentPoint)) extent: (firstPoint - currentPoint) abs

    "Created: / 21.8.1998 / 20:17:07 / cg"
    "Modified: / 10.10.2001 / 14:13:08 / cg"
!

drawCursorAt:aPoint
    |imgPoint shownCursor|

    readOnly ifTrue:[^ self].
    image isNil ifTrue: [
        self updateImageInfo: self imageInfoString. 
        self cursor:Cursor stop.
        ^ self
    ].

    imgPoint := aPoint // magnification.
    ((imgPoint x between:0 and:(image width-1)) 
      and:[imgPoint y between:0 and: (image height-1)]
    ) ifFalse:[
        self updateImageInfo:self imageInfoString. 
        shownCursor := Cursor stop.
    ] ifTrue: [
        self updateImageInfoFor:imgPoint.
        shownCursor := Cursor crossHair
    ].
    self cursor:shownCursor.

    "Modified: / 03-05-2011 / 12:27:52 / cg"
!

showCursorAt: aPoint andInformation: aLabel
    |shownCursor|
    
    readOnly ifTrue:[^ self].

    ((0@0 extent: image extent * magnification) containsPoint: aPoint)
         ifTrue: [ shownCursor := Cursor crossHair ]
         ifFalse:[ shownCursor := Cursor stop ].
    self cursor:shownCursor. 
    self updateImageInfo: aLabel.

    "Modified: / 03-05-2011 / 12:28:15 / cg"
!

updateActivity: something
    |msg|

    msg := something printString.

    activityInfoHolder notNil ifTrue:[
        activityInfoHolder value:msg.
    ].

    "Modified: / 29.7.1998 / 18:41:47 / cg"
!

updateImageInfo: something
    |msg|

    msg := something printString.

    imageInfoHolder notNil ifTrue:[
        msg ~= imageInfoHolder value ifTrue:[
            imageInfoHolder value:msg.
        ].
        ^ self
    ].

    "Modified: / 29.7.1998 / 19:00:21 / cg"
!

updateImageInfoFor:aPoint
    |clr pixel r g b a|

    clr := image colorAt:aPoint.
    pixel := image pixelAt:aPoint.

    r := clr redByte.
    g := clr greenByte.
    b := clr blueByte.
    a := clr alphaByte.

    self updateImageInfo:
        (String streamContents:[:s |
            s print:aPoint.
            s print:' (r:'; print:r.
            s print:' g:'; print:g.
            s print:' b:'; print:b.
            image depth > 24 ifTrue:[
                s print:' a:'; print:a.
            ].
            s print:' #'; print:(r hexPrintString:2); print:(g hexPrintString:2); print:(b hexPrintString:2).
            pixel <= 16rFFFF ifTrue:[
                s print:' pixel:'; print:pixel.
            ].
            s print:')'.
        ])
! !

!ImageEditView methodsFor:'initialization & release'!

destroy
    ClipboardMagnified := Clipboard := nil.
    LastMagnification      := magnification.

    super destroy
!

initialize
    super initialize.

    readOnly := false.

    self enableMotionEvents.

    undoImages        := List new: MaxUndos.

    magnification     := LastMagnification ? (8@8).
    modifiedHolder    := false asValue.
    mouseKeyColorMode := 1.
    resourceClass     := resourceSelector := nil.
    drawingColorHolders := Array with:(nil asValue) with:(nil asValue).   "/ left/right mouse colors
    drawingPixelHolders := Array with:(nil asValue) with:(nil asValue).   "/ left/right mouse colors

    spraySpot := 8.
    penWidth := 1.

    self editMode:EditModePoint.

    "Modified: / 15-02-2012 / 22:39:22 / cg"
! !

!ImageEditView methodsFor:'loading & saving'!

askForFileNameToSave:msg
    "ask for a fileName"

    |lastFn fn filters|

    filters := FileSelectionBrowser saveImageFileNameFilters.
    lastFn := self image fileName.
    lastFn isNil ifTrue:[
        fn := FileSelectionBrowser
                request: msg
                inDirectory: LastSaveDirectory
                withFileFilters: filters
    ] ifFalse:[
        fn := FileSelectionBrowser
                request: msg
                fileName: lastFn
                withFileFilters: filters
    ].

    ^ fn
!

loadFromClass
    |classAndSelector|

    classAndSelector := ResourceSelectionBrowser
            request: 'Load Image From Class'
            onSuperclass: nil
            andClass: self resourceClass
            andSelector: self resourceSelector
            withResourceTypes: #(image fileImage programImage).

    classAndSelector notNil ifTrue:[
        self loadFromClass:(classAndSelector methodClass) andSelector:(classAndSelector methodSelector) 
    ].
!

loadFromClass:aClassOrClassName andSelector: aStringOrSymbol
    "support for names will vanish - obsolete left over from tz"

    imageReaderClass := nil.
    self resourceClass: aClassOrClassName.
    self resourceSelector: aStringOrSymbol.

    resourceClass isBehavior ifFalse:[^ nil].

    (resourceClass respondsTo:resourceSelector) ifTrue:[ 
        image := resourceClass perform:resourceSelector.
    ].

    image isNil ifTrue:[^ nil].

    image := image copy.
    self releaseUndos.
    self image:image.
    self clearModified.
    ^ image
!

loadFromFile: aFileName
    |imageFromFile|

    aFileName isNil ifTrue: [^nil].

    Error handle:[:exception|
        self warn: exception errorString.
        ^ nil
    ] do:[ 
        (imageFromFile := Image fromFile: aFileName) isNil ifTrue:[
            imageFromFile := JPEGReader fromFile:aFileName
        ].
        imageFromFile notNil ifTrue:[
            self releaseUndos.
            self image: imageFromFile. 
            self clearModified.
"/            imageReaderClass := ImageReader allSubclasses
"/                detect: [:cls| cls isValidImageFile: aFileName asFilename pathName]
"/                ifNone: [self error: 'Unknown image file format!!']
        ] ifFalse:[
            aFileName asFilename isReadable ifTrue:[
                self error: 'Not an image file (or unrecognized format)'
            ] ifFalse:[  
                self error: 'File does not exist or is unreadable'
            ]
        ]
    ].
    ^ imageFromFile

    "Modified: / 29.7.1998 / 18:09:13 / cg"
!

loadFromMessage:classAndSelector
    "switch to the class and selector specified by classAndSelector."

    ^ self loadFromClass:(classAndSelector methodClass) andSelector:(classAndSelector methodSelector)
!

loadfromClass:aClassOrSymbol andSelector: aStringOrSymbol
    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self loadFromClass:aClassOrSymbol andSelector: aStringOrSymbol
!

save
    self saveImageOrMask: #image.
!

save:image imageOrMask:what
    "save the image or the mask only (if what == #mask)"

    image isNil ifTrue:[
        Dialog warn:(resources string:'No image to save!!').
        ^ self.
    ].
    self save:image imageOrMask:what as:image fileName.
!

save:image imageOrMask:what as:fileNameArg
    "save the image or the mask only (if what == #mask)"

    |fileName fileNameString|

    fileName := fileNameArg asFilename.
    LastSaveDirectory := fileName directoryName.

    Error handle:[:ex|
        |msg|

        ex creator == Image fileCreationErrorSignal ifTrue:[
            msg := resources string:'Cannot create file: ''%1''' with:fileName asFilename pathName allBold
        ] ifFalse:[
            msg := ex errorString.
        ].
        Dialog warn:msg.
    ] do:[   
        Image informationLostQuerySignal handle:[:ex|
            "/ should make those warnings visible ...
            (self confirm:(ex errorString , '\\Save anyway ?') withCRs) ifTrue:[
                ex proceed.
            ]
        ] do:[   
            windowGroup withWriteCursorDo:[
                |suff fn|

                image isNil ifTrue:[
                    ^ self error: 'No image to save!!'
                ].

                what = #mask ifTrue:[   
                    image mask isNil ifTrue: [^self error: 'No image mask to save!!'].
                ].

                fileName name size = 0 ifTrue: [^self error: 'No file name detected!!'].
                suff := fileName suffix asLowercase.
                imageReaderClass := nil.
                imageReaderClass := MIMETypes imageReaderForSuffix:suff.

                imageReaderClass isNil ifTrue: [
                    imageReaderClass := XPMReader. 
                    fileNameString := fileName name , '.xpm'.
                    fileName := fileNameString asFilename.
                    image fileName:fileNameString.
                    Dialog warn:(('Don''t know how to write ''.' , suff , '''-files\\Saving in xpm format as ''%1''.') 
                                withCRs bindWith:fileNameString allBold).
                ].
                (imageReaderClass canRepresent:image) ifFalse:[
                    imageReaderClass == XPMReader ifTrue:[
                        Dialog warn:('Saving in ''.' , suff , '''-format is not supported (or image cannot be represented in this format).\\Please try another format.') withCRs.
                        ^ self.
                    ].
                    imageReaderClass := XPMReader. 
                    fileNameString := fileName name , '.xpm'.
                    fileName := fileNameString asFilename.
                    image fileName:fileNameString.
                    (Dialog confirm:(('Saving in ''.' , suff , '''-format is not supported (or image cannot be represented in this format).\\Saving in xpm format as ''%1''.') 
                                withCRs bindWith:fileNameString allBold)) ifFalse:[
                        ^ self.
                    ].
                ].
                Transcript showCR:('saving as:' , fileName pathName).

                what = #image ifTrue: [ 
                    image saveOn:fileName using: imageReaderClass. self clearModified.
                    image fileName:fileNameString.
                ].
                what = #mask ifTrue: [
                    image mask saveOn:fileName using: imageReaderClass
                ].

                fileName exists ifFalse:[
                    Dialog warn:'Oops image save failed.'
                ]
            ]   
        ]
    ]

    "Modified: / 27-07-2012 / 09:45:49 / cg"
!

saveAs
    self saveImageFileAs
!

saveButtonImageToFileAs
    |fn|

    fn := self askForFileNameToSave:'Save Button Image to File'.
    self saveButtonImageToFileAs:fn

    "Modified: / 30.9.1998 / 23:04:11 / cg"
!

saveButtonImageToFileAs: aFileName
    "save the image as if in a button in aFileName"

    |button grabbedImage|

    aFileName isNil ifTrue: [^nil].

    image isNil ifTrue:[
        self warn:(resources string:'No image or image mask to save!!').
        ^ self.
    ].

    button := Button label:image.
    button openAt:5@5.
    button waitUntilVisible.

    grabbedImage := Image fromView:button.
    button destroy.

    self save:grabbedImage imageOrMask:#image as:aFileName

    "/ self saveImageOrMask: #mask
!

saveImageFileAs
    "ask for a fileName and save the image"

    |fn|

    fn := self askForFileNameToSave:'Save Image To File'.
    self saveImageFileAs:fn
!

saveImageFileAs: aFileName
    "save the image in aFileName"

    aFileName isNil ifTrue: [^nil].
    image notNil ifTrue:[
        self save:image imageOrMask:#image as:aFileName.
    ] ifFalse:[
        self warn:(resources string:'No image for saving!!')
    ]

    "Modified: / 30.9.1998 / 23:04:55 / cg"
!

saveImageMaskFileAs
    "ask for a fileName and save the mask only"

    |fn|

    fn := self askForFileNameToSave:'Save Image Mask To File'.
    self saveImageMaskFileAs:fn

    "Modified: / 30.9.1998 / 23:04:11 / cg"
!

saveImageMaskFileAs: aFileName
    "save the mask only in aFileName"

    aFileName isNil ifTrue: [^nil].
    (image notNil and:[image mask notNil]) ifTrue:[
        self save:image imageOrMask:#mask as:aFileName.
    ] ifFalse:[
        self warn:(resources string:'No image or image mask to save!!')
    ]

    "Modified: / 30.9.1998 / 23:06:24 / cg"
!

saveImageOrMask:what
    "save the image or the mask only (if what == #mask)"

    self save:image imageOrMask: what
!

saveMethod
    "save the image as a resource method.
     Return true if ok; false if not"

    (resourceSelector trimBlanks notEmptyOrNil and:[ resourceClass isBehavior ]) ifFalse: [
        ^ self saveMethodAs.
    ].

    windowGroup withExecuteCursorDo:[
        Error handle:[:ex|
            (self confirm:(ex errorString,'\\Debug?' withCRs)) ifTrue:[ ex reject ].
            ^ false                                 
        ] do: [   
            |img imageSaved depth bestDepth colorsUsed numColorsUsed category imageStoreStream sel mthd imageKey|

            img := self image.
            depth := bestDepth := img depth.
            colorsUsed := (img usedColorsMax:256).
            colorsUsed notNil ifTrue:[
                numColorsUsed := colorsUsed size.
                #(8 4 2 1) do:[:d |
                    depth > d ifTrue:[
                        numColorsUsed <= (1 << d) ifTrue:[
                            bestDepth := d
                        ]
                    ]
                ].
            ].
            imageSaved := img.
            bestDepth < depth ifTrue:[
                |answer|
                
                answer := Dialog 
                    confirmWithCancel:(resources stringWithCRs:'Hint:\\You can save some code space, by converting the image from a depth-%1 to a depth-%2 image first.\(only %3 colors used)\\Convert before saving?'
                                 with:depth with:bestDepth with:numColorsUsed).
                answer isNil ifTrue:[
                    "/ cancelled
                    ^ false
                ].
                answer == true ifTrue:[
                    imageSaved := (Image implementorForDepth:bestDepth) fromImage:imageSaved 
                ].    
            ].

            SmalltalkCodeGeneratorTool
                createImageSpecMethodFor:imageSaved
                comment:(ResourceSpecEditor codeGenerationCommentForClass: ImageEditor) 
                in:resourceClass class
                selector:resourceSelector.

            "/ flush cached images in the Icon class (kludge)
            Icon flushCachedIcons.
            self clearModified.

            LastSaveClass := resourceClass.
        ]
    ].
    ^ true

    "Modified: / 31-01-2011 / 18:28:06 / cg"
    "Modified (comment): / 25-11-2016 / 08:48:44 / cg"
!

saveMethodAs
    "ask for method/selector; save the image there.
     Return true if saved, false if not"

    |className classAndSelector
     previousClass previousCategory previousSelector
     previousMethod newMethod ok|

    previousSelector := self resourceSelector.
    className := self resourceClassName.
    className isEmptyOrNil ifTrue:[
        className := LastSaveClass
    ].
    (className notEmptyOrNil and:[previousSelector notNil]) ifTrue:[
        previousClass := Smalltalk classNamed:className.
        previousClass notNil ifTrue:[
            previousMethod := previousClass class compiledMethodAt:previousSelector.
            previousMethod notNil ifTrue:[
                previousCategory := previousMethod category.
            ]
        ]
    ].

    self withWaitCursorDo:[
        classAndSelector := ResourceSelectionBrowser
                request: 'Save Image In Class'
                onSuperclass: #Object
                andClass: className
                andSelector: self resourceSelector
                withResourceTypes: #(image fileImage programImage).
    ].
    classAndSelector isNil ifTrue:[^ false].

    resourceClass := classAndSelector methodClass.
    resourceSelector := classAndSelector methodSelector.

    ok := self saveMethod.
    ok ifTrue:[
        previousCategory notNil ifTrue:[
            newMethod := resourceClass class compiledMethodAt:resourceSelector asSymbol.
            newMethod notNil ifTrue:[
                newMethod category:previousCategory.
            ]
        ]
    ].
    ^ ok

    "Modified: / 25-11-2016 / 09:17:22 / cg"
! !

!ImageEditView methodsFor:'printing'!

print
    self printWithMagnification:1
!

printMagnified
    self printWithMagnification:magnification
!

printWithMagnification:magnification
    |stream|

    image isNil ifTrue:[^ self].

    Printer supportsPostscript ifFalse:[
        ^ self warn:(resources string:'No postscript printer configured !!')
    ].

    stream := Printer newNative.
    stream isNil ifTrue:[
        ^ self warn:(resources string:'Cannot open printer stream !!')
    ].

    self withWaitCursorDo:[
        |psgc|

        psgc := PSGraphicsContext on:stream.  
        psgc displayForm: (image magnifiedBy: magnification) x:0 y:0.
        psgc close
    ]
! !

!ImageEditView methodsFor:'queries'!

heightOfContents

    image isNil ifTrue:[^0].
    ^(image height * magnification y) rounded
!

imageContainsPastePoint: aPoint

    ^image notNil and: 
	[Clipboard notNil and:
	[((0@0 corner:(image extent) "- 1" - Clipboard extent) containsPoint: (((aPoint - margin + 1) / magnification) floor))]]
!

imageContainsPoint: aPoint

    ^image notNil and:
	[((0@0 corner:(image extent) - 1) containsPoint: (((aPoint - margin + 1) / magnification) floor))]
!

imageInfoString
    image isNil ifTrue: [^ 'No image loaded.']. 
    ^ String streamContents:[:s |
        s print:image width.
        s print:'x'.
        s print:image height.
        s print:' | '.

        s print:(image depth).
        s print:'bit'.
        image mask notNil ifTrue: [s print:'+mask'].

        ' [%1/%2 colors]' expandPlaceholdersWith:{image nColorsUsed. (2 raisedTo: image depth)} on:s.
    ].
!

widthOfContents

    image isNil ifTrue:[^0].
    ^(image width * magnification x) rounded
! !

!ImageEditView methodsFor:'release'!

releasePasteDrawing
    self repairDamage.
    (lastPastePoint notNil and: [ClipboardMagnified notNil]) 
    ifTrue: [ 
        self redraw: ((lastPastePoint"-self viewOrigin") extent: (ClipboardMagnified extent)). 
        "/ self repairDamage.
    ].
    lastPastePoint := ClipboardMagnified := nil
!

releaseUndos
    undoImages removeAll.
! !

!ImageEditView methodsFor:'testing'!

checkModified
    modifiedHolder value ifTrue:[
        ((YesNoBox title:(resources string:'Image was not saved. Exit anyway ?'))
            noText:(resources string:'Cancel');
            yesText:(resources string:'Exit without Saving');
            showAtPointer;
            accepted
        ) ifFalse: [^false].

        self modified:false.
    ].
    ^ true

    "Modified: / 29.7.1998 / 18:55:24 / cg"
! !

!ImageEditView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ImageEditView initialize!
