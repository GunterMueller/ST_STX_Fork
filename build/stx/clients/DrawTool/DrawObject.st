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

DisplayObject subclass:#DrawObject
	instanceVariableNames:'origin corner fillPattern linePattern lineWidth lineStyle
		foreground background'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool'
!

!DrawObject class methodsFor:'documentation'!

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
    abstract superclass for all objects handled by DrawView

    [see also:]
        DrawView DrawTool

    [author:]
        Claus Gittinger
"
! !

!DrawObject class methodsFor:'DrawView interface'!

icon
    "take <classname>.xbm as default bitmap file"

    ^ Smalltalk imageFromFileNamed:((self name) , '.xbm') forClass:self
!

needsAllMovePoints
    "if false, objects are defined by indiviual point-input;
     if true, they are defined by just moving the pointer (free-hand draw)"

    ^ false
!

needsKeyboardInput
    "if false, objects are defined dragging;
     if true, they are defined by adding keyboard input"

    ^ false
!

needsMultiPointCreate
    "if false, objects are defined by origin-corner;
     if true, they are defined by adding points"

    ^ false
!

userFriendlyName
    ^ 'draw object'

    "Created: 23.4.1997 / 12:00:27 / cg"
! !

!DrawObject methodsFor:'accessing'!

background
    "return the background color"

    ^ background

    "Modified: 27.4.1996 / 13:37:07 / cg"
!

background:aColor
    "set the background color"

    background := aColor
!

fillPattern
    "return the fill pattern form"

    ^ fillPattern

    "Modified: 27.4.1996 / 13:37:15 / cg"
!

fillPattern:aFormOrNil
    "set the fill pattern form"

    fillPattern := aFormOrNil
!

fillPattern:newFillPattern linePattern:newLinePattern lineWidth:newLineWidth foreground:newFg background:newBg
    "set all of fill, line, lineWidth, fg and bg colors"

    fillPattern := newFillPattern.
    linePattern := newLinePattern.
    lineWidth := newLineWidth.
    foreground := newFg.
    background := newBg.
    self computeBoundingBox

!

fillPattern:newFillPattern linePattern:newLinePattern lineWidth:newLineWidth lineStyle:newStyle foreground:newFg background:newBg
    "set all of fill, line, lineWidth, fg and bg colors"

    fillPattern := newFillPattern.
    linePattern := newLinePattern.
    lineWidth := newLineWidth.
    lineStyle := newStyle.
    foreground := newFg.
    background := newBg.
    self computeBoundingBox

    "Created: 5.6.1996 / 10:54:13 / cg"
!

fontFace
    "return the font face"

    ^ nil

    "Modified: 27.4.1996 / 13:37:20 / cg"
!

fontFace:aString
    "set the font face - ignored here & reimplemented in drawObjects
     which use a font."

    ^ self

    "Modified: 3.6.1996 / 10:07:49 / cg"
!

fontFamily
    "return the font family"

    ^ nil

    "Modified: 27.4.1996 / 13:44:04 / cg"
!

fontFamily:aString
    "set the font family - ignored here & reimplemented in drawObjects
     which use a font."

    ^ self

    "Modified: 3.6.1996 / 10:07:54 / cg"
!

fontFamily:family face:face style:style size:size
    "set the font - ignored here & reimplemented in drawObjects
     which use a font."

    ^ self

    "Created: 3.6.1996 / 10:07:41 / cg"
!

fontSize
    "return the font size"

    ^ nil

    "Modified: 27.4.1996 / 13:44:10 / cg"
!

fontSize:aString
    "set the font size - ignored here & reimplemented in drawObjects
     which use a font."

    ^ self

    "Modified: 3.6.1996 / 10:07:57 / cg"
!

fontStyle
    "return the font style"

    ^ nil

    "Modified: 27.4.1996 / 13:44:15 / cg"
!

fontStyle:aString
    "set the font style"

    ^ self
!

foreground
    "return the foreground color"

    ^ foreground

    "Modified: 27.4.1996 / 13:44:20 / cg"
!

foreground:aColor
    "set the foreground color"

    foreground := aColor
!

foreground:fgColor background:bgColor
    "set foreground and background colors"

    foreground := fgColor.
    background := bgColor
!

groupedObjects
    "ungrouping me does nothing"

    ^ self
!

linePattern
    "return the line pattern form"

    ^ linePattern

    "Modified: 27.4.1996 / 13:44:26 / cg"
!

linePattern:aFormOrNil
    "set the line pattern form"

    linePattern := aFormOrNil
!

lineStyle
    "return the line style"

    ^ lineStyle

    "Modified: 27.4.1996 / 13:44:29 / cg"
!

lineStyle:aStyleSymbol 
    "set the line style"

    lineStyle := aStyleSymbol.
!

lineWidth
    "return the line width"

    ^ lineWidth

    "Modified: 27.4.1996 / 13:44:31 / cg"
!

lineWidth:aNumber
    "set the line width"

    lineWidth := aNumber.
    self computeBoundingBox
! !

!DrawObject methodsFor:'accessing-geometry'!

center
    ^ self frame center
!

corner
    ^ corner
!

origin
    ^ origin
! !

!DrawObject methodsFor:'conversion support'!

fromDrawObject:aDrawObject
    self fillPattern:aDrawObject fillPattern.
    self linePattern:aDrawObject linePattern.
    self lineWidth:aDrawObject lineWidth.
    self lineStyle:aDrawObject lineStyle.
    self foreground:aDrawObject foreground.
    self background:aDrawObject background.

! !

!DrawObject methodsFor:'converting'!

asDrawPolygon
    ^ self
!

asDrawSpline
    ^ self
!

canBeConvertedToClosedPolygon
    ^ false
!

canBeConvertedToOpenPolygon
    ^ false
!

canBeConvertedToPolygon
    ^ false
!

canBeConvertedToRectangle
    ^ false
!

canBeConvertedToRoundRectangle
    ^ false
!

canBeConvertedToSpline
    ^ self canBeConvertedToPolygon
! !

!DrawObject methodsFor:'drawing'!

drawFrameIn:aGC offset:anOffset
    "draw the outline of the receiver in a GC, at anOffset pixels
     distance from its actual position. Used with dragging."

    |halfLw nOrg nCorner|

"
    aGC paint:Color black on:Color white.
"
    aGC lineWidth:0.

    nOrg := origin + anOffset.
    nCorner := corner + anOffset.

    lineWidth > 2 ifTrue:[
        "draw twice"
        halfLw := lineWidth // 2.
        aGC displayRectangle:(Rectangle origin:(nOrg - halfLw) corner:(nCorner + halfLw)).
        aGC displayRectangle:(Rectangle origin:(nOrg + halfLw) corner:(nCorner - halfLw)).
    ] ifFalse:[
        aGC displayRectangle:(Rectangle origin:nOrg corner:nCorner)
    ]

    "Modified: 4.6.1996 / 15:37:08 / cg"
!

drawOutlineIn:aGC offset:anOffset
    "draw the outline of the receiver in a GC, at anOffset pixels
     distance from its actual position. Used with dragging."

    self drawFrameIn:aGC offset:anOffset
! !

!DrawObject methodsFor:'drawing - helpers'!

lineGC:aGC with:aBlock
    linePattern == 1 ifTrue:[
        aGC paint:foreground.
        aBlock value.
        ^ self.
    ].
    linePattern == 0 ifTrue:[
        aGC paint:background.
        aBlock value.
        ^ self.
    ].
    linePattern isColor ifTrue:[
        aGC paint:linePattern.
        aBlock value.
        ^ self.
    ].

    background isNil ifTrue:[
        "/ line-draw fg only ...
        self transparentLineGC:aGC with:aBlock.
    ] ifFalse:[
        aGC paint:foreground on:background.
        aGC withPattern:linePattern do:aBlock
    ]
!

transparentFillGC:aGC with:aBlock
    "fill fg only ..."

    aGC paint:(Color noColor) on:(Color allColor).
    aGC function:#and.
    aGC withPattern:fillPattern do:aBlock.
    aGC paint:foreground on:(Color noColor).
    aGC function:#or.
    aGC withPattern:fillPattern do:aBlock.
    aGC function:#copy.


!

transparentLineGC:aGC with:aBlock
    "fill fg only ..."

    aGC paint:(Color noColor) on:(Color allColor).
    aGC function:#and.
    aGC withPattern:linePattern do:aBlock.
    aGC paint:foreground on:(Color noColor).
    aGC function:#or.
    aGC withPattern:linePattern do:aBlock.
    aGC function:#copy.


!

withFillPatternAsPaintIn:aGC do:aBlock
    self withFillPatternAsPaintIn:aGC do:aBlock ifTransparentDo:aBlock
!

withFillPatternAsPaintIn:aGC do:block1 ifTransparentDo:block2
    fillPattern == 1 ifTrue:[
        aGC paint:foreground.
        block1 value.
        ^ self.
    ].
    fillPattern == 0 ifTrue:[
        aGC paint:background.
        block1 value.
        ^ self.
    ].
    fillPattern isColor ifTrue:[
        aGC paint:fillPattern.
        block1 value.
        ^ self.
    ].
    background isNil ifTrue:[
        "/ fill fg only ...
        self transparentFillGC:aGC with:block2.
        ^ self.
    ].
    aGC paint:foreground on:background.
    aGC withPattern:fillPattern do:block1.
! !

!DrawObject methodsFor:'frame computations'!

computeBoundingBox
    "recompute the frame - must be done after every size/position change.
     The frame may be larger than the actual real estate used 
     but NEVER smaller for correct clipping"

    |halfLineWidth|

    lineWidth even ifTrue:[
	halfLineWidth := lineWidth // 2
    ] ifFalse:[
	"must always add 1 since display cannot draw half a pixel "
	halfLineWidth := (lineWidth // 2) + 1
    ].
    frame := Rectangle origin:(origin - halfLineWidth)
		       corner:(corner + halfLineWidth)
! !

!DrawObject methodsFor:'handles'!

all8HandlesDo:aBlock
    "evaluate the argument, aBlock for every handle"

    |halfHeight halfWidth top left right bottom hCenter vCenter|

    top := origin y.
    left := origin x.
    bottom := corner y.
    right := corner x.

    aBlock value:origin.                "top-left"
    aBlock value:corner.                "bottom-right"
    aBlock value:(left @ bottom).       "bottom-left"
    aBlock value:(right @ top).         "top-right"

    halfHeight := (bottom - top) // 2.
    vCenter := top + halfHeight.
    aBlock value:(left @ vCenter).   "center left"
    aBlock value:(right @ vCenter).     "center right"

    halfWidth := (right - left) // 2.
    hCenter := left + halfWidth.
    aBlock value:(hCenter @ top).       "top-center"
    aBlock value:(hCenter @ bottom)     "bottom-center"

    "Created: 5.6.1996 / 13:20:02 / cg"
!

cornerHandlesDo:aBlock
    "evaluate the argument, aBlock for the 4 corner handles"

    |top left right bottom|

    top := origin y.
    left := origin x.
    bottom := corner y.
    right := corner x.

    aBlock value:origin.                "top-left"
    aBlock value:corner.                "bottom-right"
    aBlock value:(left @ bottom).       "bottom-left"
    aBlock value:(right @ top).         "top-right"

    "Created: 4.6.1996 / 13:19:56 / cg"
    "Modified: 5.6.1996 / 13:20:56 / cg"
!

edgeHandlesDo:aBlock
    "evaluate the argument, aBlock for every edge handle.
     For non-polygons, this is ignored."

    self handlesDo:aBlock.
!

handlesDo:aBlock
    "evaluate the argument, aBlock for every handle"

    self all8HandlesDo:aBlock

    "Modified: 5.6.1996 / 13:20:12 / cg"
!

selectorForEdgeHandle:aHandle
    "given a handlePoint of an edge-handle, return a selector to change it.
     For non-polygons, edgeHandles are the same as frameHandles"

    ^ self selectorForHandle:aHandle
!

selectorForHandle:aHandle
    "given a handlePoint, return a selector to change it"

    |halfWidth halfHeight top left bottom right hCenter vCenter hx hy|

    top := origin y.
    bottom := corner y.
    left := origin x.
    right := corner x.
    hx := aHandle x.
    hy := aHandle y.

    (hx = left) ifTrue:[
        (hy = top) ifTrue:[^ #origin:].
        (hy = bottom) ifTrue:[^ #bottomLeft:]
    ].

    (hx = right) ifTrue:[
        (hy = bottom) ifTrue:[^ #corner:].
        (hy = top) ifTrue:[^ #topRight:]
    ].

    ((hx = left) or:[hx = right]) ifTrue:[
        halfHeight := (bottom - top) // 2.
        vCenter := top + halfHeight.

        (hy = vCenter) ifTrue:[
            (hx = left) ifTrue:[^ #left:].
            ^ #right:
        ]
    ].

    ((hy = top) or:[hy = bottom]) ifTrue:[
        halfWidth := (right - left) // 2.
        hCenter := left + halfWidth.

        (hx = hCenter) ifTrue:[
            (hy = top) ifTrue:[^ #top:].
            ^ #bottom:
        ]
    ].

    ^ nil

    "Modified: 27.4.1996 / 13:41:57 / cg"
! !

!DrawObject methodsFor:'initialization'!

initialize
    "initialize internals: lineWidth, fg/bg and fillPatterns"

    lineWidth := 0.
    foreground := Color black.
    background := Color white.
    linePattern := 1.           "marks as solid"
    fillPattern := nil          "default is unfilled"

    "Modified: 27.4.1996 / 13:42:20 / cg"
! !

!DrawObject methodsFor:'moving/resizing'!

bottom:aPoint
    "set the bottom (y) coordinate 
     - leave top unchanged; i.e. change extent."

    self origin:origin
         corner:((corner x) @ (aPoint y))

    "Modified: 27.4.1996 / 13:39:16 / cg"
!

bottomLeft:aPoint
    "set the bottom left corner"

    self origin:((aPoint x) @ (origin y))
         corner:((corner x) @ (aPoint y))

    "Modified: 27.4.1996 / 13:37:56 / cg"
!

corner:aPoint
    "set new corner; argument given in pixels"

    self origin:origin corner:aPoint
!

flipHorizontal
    "ignored here (actually, this is subclassResponsibility)"

    ^ self 
!

flipVertical
    "ignored here (actually, this is subclassResponsibility)"

    ^ self 
!

left:aPoint
    "set the left (x) coordinate 
     - leave right unchanged; i.e. change extent."

    self origin:((aPoint x) @ (origin y))
         corner:corner

    "Modified: 27.4.1996 / 13:38:59 / cg"
!

mmCorner:aPoint
    "set new corner; argument given in millimeter"

    |pixPoint|

    pixPoint := (aPoint x * Display horizontalPixelPerMillimeter)
		@
		(aPoint y * Display verticalPixelPerMillimeter).
    self origin:origin corner:pixPoint
!

mmOrigin:aPoint
    "set new origin; argument given in millimeter"

    |pixPoint|

    pixPoint := (aPoint x * Display horizontalPixelPerMillimeter)
		@
		(aPoint y * Display verticalPixelPerMillimeter).
    self origin:pixPoint corner:corner
!

mmOrigin:newOrigin mmCorner:newCorner
    "set new origin/corner; arguments given in millimeter"

    |org corn|

    org := (newOrigin x * Display horizontalPixelPerMillimeter) rounded asInteger
              @
              (newOrigin y * Display verticalPixelPerMillimeter) rounded asInteger.
    corn := (newCorner x * Display horizontalPixelPerMillimeter)  rounded asInteger
              @
              (newCorner y * Display verticalPixelPerMillimeter) rounded asInteger.

    self origin:org corner:corn

    "Modified: 30.5.1996 / 17:32:33 / ca"
!

moveTo:newOrigin
    "move the receiver - extent is unchanged"

    |width height|

    width := corner x - origin x.
    height := corner y - origin y.
    self origin:newOrigin
         corner:(newOrigin x + width) @ (newOrigin y + height)

    "Modified: 27.4.1996 / 13:39:47 / cg"
!

origin:aPoint
    "set new origin; argument given in pixels"

    self origin:aPoint corner:corner
!

origin:newOrigin corner:newCorner
    "set new origin/corner; arguments given in pixels"

    (origin ~= newOrigin or:[corner ~= newCorner]) ifTrue:[
        origin := newOrigin.
        corner := newCorner.
        frame := nil.
    ].
!

right:aPoint
    "set the right (x) coordinate 
     - leave left unchanged; i.e. change extent."

    self origin:origin
         corner:((aPoint x) @ (corner y))

    "Modified: 27.4.1996 / 13:40:13 / cg"
!

rotate270 
    self rotate:270
!

rotate90 
    self rotate:90
!

rotate:degrees 
    "ignored here (actually, this is subclassResponsibility)"

    ^ self 
!

top:aPoint
    "set the top (y) coordinate 
     - leave bottom unchanged; i.e. change extent."

    self origin:((origin x) @ (aPoint y))
         corner:corner

    "Modified: 27.4.1996 / 13:40:28 / cg"
!

topRight:aPoint
    "set the top-right coordinate 
     - leave bottom-left unchanged; i.e. change extent."

    self origin:((origin x) @ (aPoint y))
         corner:((aPoint x) @ (corner y))

    "Modified: 27.4.1996 / 13:40:43 / cg"
! !

!DrawObject methodsFor:'queries'!

handlesKeyboardInput
    "return true, if this objects is interested in keyboard input"

    ^ false
!

hasFixedSize
    "return true, if object cannot be resized"

    ^ false

    "Modified: 27.4.1996 / 13:42:38 / cg"
!

isTransparent
    ^ background isNil
! !

!DrawObject methodsFor:'release'!

release
    "this is sent to drawObjects which are not going to be
     displayed in the near future (i.e. those that get copied into
     the cut-buffer. This gives them a chance to release any device
     resources, such as colors, fonts etc. and thus give others
     more chances for device resource allocation.
     This is especially needed to free colors used by images.
    "

    ^ self
! !

!DrawObject methodsFor:'storing'!

storeInstvarsOn:aStream
    "store my instance variables (in ascii) on aStream"

    |mmPoint pixelPerMmH pixelPerMmV|

    pixelPerMmH := Display horizontalPixelPerMillimeter.
    pixelPerMmV := Display verticalPixelPerMillimeter.
    mmPoint := (origin x / pixelPerMmH) @ (origin y / pixelPerMmV).
    aStream nextPutAll:'; mmOrigin:'. mmPoint storeOn:aStream.
    mmPoint := (corner x / pixelPerMmH) @ (corner y / pixelPerMmV).
    aStream nextPutAll:' mmCorner:'. mmPoint storeOn:aStream.
    aStream cr.
    self storePatternsOn:aStream.
    aStream cr.
    aStream nextPutAll:'; lineWidth:'. lineWidth storeOn:aStream.
    aStream cr.
    aStream nextPutAll:'; foreground:('. foreground storeOn:aStream.
    aStream nextPutAll:'); background:('. background storeOn:aStream.
    aStream nextPutAll:')'.
    aStream cr

    "Modified: 27.4.1996 / 13:43:16 / cg"
    "Modified: 30.5.1996 / 16:23:12 / ca"
!

storeOn:aStream
    "store the receiver (in ascii) on aStream"

    aStream nextPut:$(.
    aStream nextPutAll:(self class name).
    aStream nextPutAll:' new yourself'.
    self storeInstvarsOn:aStream.
    aStream nextPut:$)

    "Modified: 27.4.1996 / 13:43:10 / cg"
!

storePattern:aPattern on:aStream
    "store the fillPattern (as index into the patternTable) on aStream"

    |pIndex|

    aPattern isInteger ifTrue:[
        pIndex := aPattern.
    ] ifFalse:[
        pIndex := (DrawTool listOfPatterns) indexOf:aPattern.
    ].
    pIndex == 0 ifTrue:[
        (aPattern = Form black) ifTrue:[
            aStream nextPutAll:'(Form black)'.
            ^ self
        ].
        (aPattern = Form white) ifTrue:[
            aStream nextPutAll:'(Form white)'.
            ^ self
        ].
        aStream nextPutAll:'nil'
    ] ifFalse:[
        aStream nextPutAll:'(DrawTool listOfPatterns at:'.
        pIndex storeOn:aStream.
        aStream nextPutAll:')'
    ]

    "Modified: 27.4.1996 / 13:43:46 / cg"
!

storePatternsOn:aStream
    "store my pattern inst variables (in ascii) on aStream"

    aStream nextPutAll:'; fillPattern:'. 
    self storePattern:fillPattern on:aStream.
    aStream nextPutAll:'; linePattern:'. 
    self storePattern:linePattern on:aStream.
    aStream cr.

    "Created: 30.5.1996 / 16:22:55 / ca"
! !

!DrawObject methodsFor:'testing'!

isTextObject
    ^ false
! !

!DrawObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/DrawObject.st,v 1.33 2009-05-08 11:49:18 cg Exp $'
! !
