"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Object subclass:#GraphicsMedium
	instanceVariableNames:'gc device width height realized'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!GraphicsMedium class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2016 Jan Vrany
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
    this is an abstract superclass for all kinds of drawables which
    have a physical representation (i.e. have an extent). 
    Don't use messages from here - it will vanish soon.

    [Instance variables:]

        width           <SmallInteger>  the width (device dependent, usually pixels or inches)
        height          <SmallInteger>  the height (device dependent, usually pixels or inches)

    [author:]
        Claus Gittinger
"
! !

!GraphicsMedium class methodsFor:'instance creation'!

new
    "create a new drawable - take the current display as
     its device (for now, this may be changed until the view is
     physically created)"

"
    'Warning: DeviceGraphicsContext (' print. self name print. ') should not be created with new' printNL.
"
    |device|

    device := Screen current.
    device isNil ifTrue:[
        "/ there seems to be no current screen; open one.
        Smalltalk openDisplay.
        device := Screen current.
    ].
    
    ^ self onDevice:device.
!

on:aDevice
    "create a new drawable on aDevice"

    <resource:#obsolete>

    "/ send out a warning: #on: is typically used to create a view
    "/ operating on a model.
    "/ Please use #onDevice: to avoid confusion.

    self obsoleteMethodWarning:'use #onDevice:'.
    ^ self onDevice:aDevice

    "Modified: 5.6.1997 / 21:04:16 / cg"
!

onDevice:aDevice
    "create a new drawable on aDevice"

    ^ self basicNew initializeForDevice:aDevice.
! !

!GraphicsMedium class methodsFor:'Signal constants'!

drawingOnClosedDrawableSignal
    "return the signal which is raised, if drawing is attempted
     on a closed drawable.
     This is especially useful, if a forked thread animates
     a view in the background, and is not properly synchronized
     with the window thread - i.e. the window gets closed by the user,
     and the background process continues to draw.
     In this case, the background thread should handle this signal
     and terminate itself in the handler."

    ^ GraphicsContext drawingOnClosedDrawableSignal

    "demonstration1: (error if closed by the windowManager):

     |v|

     v := StandardSystemView new openAndWait.
     [
	[true] whileTrue:[
	    |x y|

	    x := Random nextIntegerBetween:0 and:(v width).
	    y := Random nextIntegerBetween:0 and:(v height).
	    v displayString:'hello' x:x y:y.
	    Delay waitForSeconds:0.5.
	]
     ] fork.
    "
    "demonstration2: (no error if closed by the windowManager):

     |v|

     v := StandardSystemView new openAndWait.
     [
	v class drawingOnClosedDrawableSignal handle:[:ex |
	    ex return
	] do:[
	    [true] whileTrue:[
		|x y|

		x := Random nextIntegerBetween:0 and:(v width).
		y := Random nextIntegerBetween:0 and:(v height).
		v displayString:'hello' x:x y:y.
		Delay waitForSeconds:0.5.
	    ]
	]
     ] fork.
    "

    "Created: / 29.1.1998 / 13:10:41 / cg"
    "Modified: / 29.1.1998 / 13:11:14 / cg"
! !

!GraphicsMedium class methodsFor:'accessing-defaults'!

defaultFont
    "get the default font used for drawing"

    ^ GraphicsContext defaultFont
!

defaultFont:aFont
    "set the default font used for drawing"

    GraphicsContext defaultFont:aFont
! !

!GraphicsMedium methodsFor:'Compatibility-ST80'!

displayArc:origin radius:radius from:startAngle angle:angle
    "draw an arc around a point"

    self
	displayArcX:(origin x - radius)
		  y:(origin y - radius)
	      width:(radius * 2)
	     height:(radius * 2)
	       from:startAngle
	      angle:angle

    "Modified: 8.5.1996 / 08:34:43 / cg"
!

displayArcBoundedBy:boundingBox startAngle:startAngle sweepAngle:sweepAngle
   "draw an arc/circle/ellipse - ST-80 compatibility"

   ^ self displayArcX:(boundingBox left)
		    y:(boundingBox top)
		width:(boundingBox width)
	       height:(boundingBox height)
		 from:startAngle
		angle:sweepAngle

    "Created: / 14.11.1997 / 21:04:19 / cg"
!

displayArcBoundedBy:boundingBox startAngle:startAngle sweepAngle:sweepAngle at:origin
   "draw an arc/circle/ellipse - ST-80 compatibility"

   ^ self displayArcX:(boundingBox left + origin x)
		    y:(boundingBox top + origin y)
		width:(boundingBox width)
	       height:(boundingBox height)
		 from:startAngle
		angle:sweepAngle
!

displayLineFrom:startPoint to:endPoint translateBy:anOffset
    "draw a line - ST-80 compatibility"

    self displayLineFrom:(startPoint + anOffset)
		      to:(endPoint + anOffset)
!

displayPolyline:aPolygon
    "draw a polygon - ST-80 compatibility"

    ^ self displayPolygon:aPolygon
!

displayRectangularBorder:aRectangle
    "draw a rectangle - ST-80 compatibility"

    self displayRectangle:aRectangle
!

displayRectangularBorder:aRectangle at:aPoint
    "draw a rectangle - ST-80 compatibility"

    self displayRectangle:(aRectangle translateBy:aPoint)
!

displayWedgeBoundedBy:boundingBox startAngle:startAngle sweepAngle:sweepAngle
   "fill an arc/circle/ellipse - ST-80 compatibility"

   ^ self fillArcX:(boundingBox left)
		 y:(boundingBox top)
	     width:(boundingBox width)
	    height:(boundingBox height)
	      from:startAngle
	     angle:sweepAngle

    "Created: 27.1.1997 / 15:50:14 / cg"
!

displayWedgeBoundedBy:boundingBox startAngle:startAngle sweepAngle:sweepAngle at:origin
   "fill an arc/circle/ellipse - ST-80 compatibility"

   ^ self fillArcX:(boundingBox left + origin x)
		 y:(boundingBox top + origin y)
	     width:(boundingBox width)
	    height:(boundingBox height)
	      from:startAngle
	     angle:sweepAngle
!

findFont:aFontDescription
    "given a fontDescription, return a device font for it
     on my device."

    ^ aFontDescription onDevice:self device

    "Modified: 28.5.1996 / 20:22:29 / cg"
!

key
    ^ self drawableId
!

phase
    "return the origin within the mask (used to draw with patterns).
     This is an alias for ST/X's #maskOrigin"

    ^ self maskOrigin
!

phase:aPoint
    "set the origin within the mask (used to draw with patterns).
     This is an alias for ST/X's #maskOrigin:"

    ^ self maskOrigin:aPoint
!

setDevicePattern:aColorOrMask
    "ST/X can paint in any color or image"

    self paint:aColorOrMask
!

tilePhase
    "return the origin within the mask (used to draw with patterns).
     This is an alias for ST/X's #maskOrigin"

    ^ self maskOrigin

    "Created: 4.6.1996 / 15:26:39 / cg"
!

tilePhase:aPoint
    "set the origin within the mask (used to draw with patterns).
     This is an alias for ST/X's #maskOrigin"

    ^ self maskOrigin:aPoint

    "Created: 4.6.1996 / 15:26:49 / cg"
!

widthOfString:aString
    "given a string, return its width in pixels if
     drawn on the receivers device."

    ^ gc widthOfString:aString.

    "Modified: 28.5.1996 / 20:22:22 / cg"
!

widthOfString:aString from:start to:stop
    "given a string, return the width in pixels if
     a substring is drawn on the receivers device."

    ^ gc widthOfString:aString from:start to:stop.

    "Modified: 28.5.1996 / 20:22:18 / cg"
! !

!GraphicsMedium methodsFor:'Compatibility-Squeak'!

copyBits:aRectangle from:aForm at:srcOrigin clippingBox:clippingBox rule:rule fillColor:fillColor
    |f oldClip oldFunction|

    (f := rule) isInteger ifTrue:[
        "/ ST-80 compatibility: numeric rule
        f := #(clear and andReverse  copy andInverted noop xor or nor equiv invert orInverted copyInverted
               orReverse nand set) at:(rule + 1).
    ].

    oldFunction := gc function.
    oldClip := gc clippingBoundsOrNil.

    gc clippingBounds:clippingBox.
    gc function:f.

    gc
        copyFrom:aForm
        x:srcOrigin x y:srcOrigin y
        toX:aRectangle left y:aRectangle top
        width:aRectangle width height:aRectangle height.

    gc clippingBounds:oldClip.
    gc function:oldFunction.

    "
      |dst src|

      dst := Form width:8 height:8 fromArray:#[
                                              2r00000000
                                              2r00000000
                                              2r00000000
                                              2r00000000
                                              2r11111111
                                              2r11111111
                                              2r11111111
                                              2r11111111
                                             ].
      src := Form width:8 height:8 fromArray:#[
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                             ].

    dst copyBits:(0@0 corner:8@8) from:src at:0@0 clippingBox:(0@0 corner:8@8) rule:15 fillColor:Color black.
    dst inspect

    "

    "Modified: / 23.10.2000 / 16:50:44 / martin"

    "
      |dst src|

      dst := Form width:8 height:8 fromArray:#[
                                              2r00000000
                                              2r00000000
                                              2r00000000
                                              2r00000000
                                              2r11111111
                                              2r11111111
                                              2r11111111
                                              2r11111111
                                             ].
      src := Form width:8 height:8 fromArray:#[
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                              2r00001111
                                             ].

    dst copyBits:(0@0 corner:8@8) from:src at:0@0 clippingBox:(0@0 corner:8@8) rule:15 fillColor:Color black.
    dst inspect

    "

    "Modified: / 23.10.2000 / 16:50:44 / martin"
!

fill:aRectangle fillColor:aColor
    "fill the rectangular area specified by aRectangle with the black color"

    gc fill:aRectangle fillColor:aColor
!

fillBlack:aRectangle
    "fill the rectangular area specified by aRectangle with the black color"

    self fill:aRectangle fillColor:self blackColor
!

fillColor:something
    "fill the receiver with something;
     something may be a Form, Color or colorIndex"

    self fill:something
!

fillRectangle:aRectangle color:aColor
    "fill a rectangle with the given paint color"

    gc fillRectangle:aRectangle color:aColor
!

fillWhite
    "fill all of the receiver with the white color"

    self fill:self whiteColor
!

fillWhite:aRectangle
    "fill the rectangular area specified by aRectangle with the white color"

    self fill:aRectangle fillColor:self whiteColor
! !

!GraphicsMedium methodsFor:'Compatibility-VW'!

displayBackgroundIfNeededOn: aGraphicsContext
    aGraphicsContext clearView.
!

inactiveForegroundColor
    "a dummy method to support VW widgets"

    ^ self foregroundColor
!

selectionBackgroundColor
    "a dummy method to support VW widgets"

    ^ self foregroundColor
!

selectionForegroundColor
    "a dummy method to support VW widgets"

    ^ self backgroundColor
!

separatorColor
    "a dummy method to support VW widgets"

    ^ self foregroundColor
! !

!GraphicsMedium methodsFor:'accessing'!

at:aPoint
    "return the pixel at the coordinate given by aPoint"

    ^ self atX:aPoint x y:aPoint y

    "Modified: / 29.1.2000 / 12:17:42 / cg"
!

at:aPoint put:aPixelColor
    "set a pixel"

    ^ self atX:aPoint x y:aPoint y put:aPixelColor

    "
     Display rootView at:(0@0) put:(Color red).
     Display rootView at:(1@1) put:(Color red).
     Display rootView at:(2@2) put:(Color red).
     Display rootView at:(3@3) put:(Color red).
     Display rootView at:(4@4) put:(Color red).
     Display rootView at:(5@5) put:(Color red).
    "
!

atX:x y:y
    "return the pixel at the coordinate given by x/y"

    ^ gc atX:x y:y
!

atX:x y:y put:aPixelColor
    "set a pixel"

    gc atX:x y:y put:aPixelColor.
!

backgroundPaint
    "return the background paint color.
     (used for opaqueForms and opaqueStrings)"

    ^ gc backgroundPaint
!

backgroundPaint:aColor
    "set the background-paint color; this is used in opaque-draw
     operations"

    gc backgroundPaint:aColor
!

basicFont
    "return the font for drawing"

    ^ gc basicFont
!

basicFont:aFont
    "set the font for drawing if it has changed.
     This is a low level entry, which is not to be redefined
     (i.e. it must not imply a redraw operation)"

    gc font:aFont
!

blackColor
    gc isNil ifTrue:[
        ^ Color black.
    ].
    ^ gc blackColor
!

bottomCenter
    "return the topCenter point"

    ^ (self left + (width//2) - 1) @ (self top + height - 1)
!

bottomLeft
    "return the bottomLeft point"

    ^ (self left) @ (self top + height - 1)
!

boundingBox
    ^ Rectangle
	origin: 0 @ 0
	corner: width @ height

!

capStyle
    "return the current cap-style for line-drawing.
     possible styles are: #notLast, #butt, #round, #projecting"

    ^ gc capStyle
!

capStyle:aStyleSymbol
    "set the cap-style for line-drawing;
     possible styles are: #notLast, #butt, #round, #projecting"

    gc capStyle:aStyleSymbol

    "Modified: 12.5.1996 / 22:24:30 / cg"
!

center
    "return the point at the center of the receiver"

    ^ (self left + (width // 2)) @ (self top + (height // 2))
!

characterEncoding
    "returns a symbol describing how the contents is encoded internally.
     For now, this should be the same encoding as my fonts encoding (otherwise, mappings would
     occur when drawing).
     This is (currently) only passed down from the fileBrowser,
     and required when japanese/chinese/korean text is edited.
     (encoding is something like #'iso8859-5' #euc, #sjis, #jis7, #gb, #big5 or #ksc)"

    ^ gc characterEncoding
!

characterEncoding:encodingArg
    "define how the contents is encoded internally.
     This should normally never be required, as ST/X now assumes
     unicode (of which iso8859-1 is a subset) encoding.
     The possibility to change the characterEncoding is provided as
     a backward compatibility hook for programs which want to use
     another encoding internally. One such view is the CharacterSetView,
     which wants to show character as they are actually present in a font."

    gc characterEncoding:encodingArg
!

clipByChildren
    "drawing shall be done into my view only (default)"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #clippedByChildren:true'.
    ^ self clippedByChildren:true

    "Created: 17.7.1996 / 13:25:55 / cg"
!

clipRect
    "return the clip-rectangle for drawing.
     If there is currently no active clip, return the underlying
     displaySurfaces (i.e. views) bounds. Added for ST-80 compatibility."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #clippingBounds'.
    ^ self clippingBounds.

    "Modified: 28.5.1996 / 14:14:53 / cg"
!

clipRect:aRectangle
    "set the drawing clip-rectangle"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #deviceClippingBounds:'.
    ^ gc deviceClippingBounds:aRectangle

    "Modified: 28.5.1996 / 14:13:09 / cg"
!

clippedByChildren:aBoolean
    "turn on/off drawing over children.
     If on, a superview may draw 'over' its children.
     If off (the default), drawing is 'under' its children.
     Only useful for the rootView, to draw over any visible views.
     (for example, when dragging a rubber-line)"

    gc clippedByChildren:aBoolean.

    "Created: 17.7.1996 / 13:25:16 / cg"
    "Modified: 29.4.1997 / 15:33:55 / dq"
!

clippingBounds
    "return the clipping rectangle for drawing, nil if there is none."

    ^ gc clippingBounds
!

clippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in logical coordinates);
     a nil argument turn off clipping (i.e. whole view is drawable)"

    gc clippingBounds:aRectangleOrNil
!

clippingBoundsOrNil
    "return the clipping rectangle for drawing, nil if there is none."

    ^ gc clippingBoundsOrNil
!

clippingRectangle:aRectangleOrNil
    "set the clipping rectangle for drawing (in logical coordinates);
     a nil argument turn off clipping (i.e. whole view is drawable)"

    <resource: #obsolete>

    self clippingBounds:aRectangleOrNil
!

clippingRectangleOrNil
    "return the clipping rectangle for drawing, nil if there is none."

    <resource: #obsolete>

    ^ self clippingBoundsOrNil
!

colorAt:aPoint
    "return the color of the pixel at the coordinate given by x@y"

    ^ self colorAtX:(aPoint x) y:(aPoint y)

    "Modified: 1.8.1997 / 20:01:58 / cg"
!

colorAtX:x y:y
    "return the color of the pixel at the coordinate given by aPoint"

    ^ gc colorAtX:x y:y
!

container
    "return my container - for protocol compatibility"

    ^ nil
!

corner
    "return the corner point i.e. the bottom-right point"

    ^ (self left + width - 1) @ (self top + height - 1)
!

corner:aPoint
    "set the corner point i.e. change extent so that corner will be
     aPoint while leaving the origin unchanging "

    self extent:(aPoint x - self left + 1)
		@
		(aPoint y - self top + 1)
!

dashStyle:aDashList offset:dashOffset
    "define dashes. Each element of the dashList specifies the length
     of a corresponding dash. For example, setting it to [4 4]
     defines 4on-4off dashing;
     Setting it to [1 2 4 2] defines 1on-2off-4on-2off dashes.
     The dashOffset specifies where in the dashList the dashing starts.
     Ignored here - this may not be supported by all graphics devices."

    ^ gc dashStyle:aDashList offset:dashOffset
!

depth
    ^ self subclassResponsibility
!

device
    "return the device, the receiver is associated with"

    ^ device
!

device:aDevice
    "set the device"

    (aDevice isNil or:[device == aDevice]) ifTrue:[
        ^ self.
    ].

    gc isNil ifTrue:[
        self initializeForDevice:aDevice.
        ^ self.
    ].

    device := aDevice.
    gc device:aDevice
!

deviceClippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in device coordinates);
     a nil argument turns off clipping (i.e. whole view is drawable - incl. margins)"

    gc deviceClippingBounds:aRectangleOrNil
!

deviceClippingBoundsOrNil
    "return the clipping rectangle as physical coordinated for drawing, nil if there is none."

    ^ gc deviceClippingBoundsOrNil
!

deviceClippingRectangle:aRectangleOrNil
    <resource: #obsolete>
    "set the clipping rectangle for drawing (in device coordinates);
     a nil argument turns off clipping (i.e. whole view is drawable - incl. margins)"

    gc deviceClippingBounds:aRectangleOrNil
!

deviceFont
    "return the current drawing font as a device font"

    ^ self font onDevice:device.
!

drawableId
    "return the id of the drawable on the device"

    gc isNil ifTrue:[
        ^ nil.
    ].
    ^ gc drawableId
!

extent
    "return the extent i.e. a point with width as x, height as y
     coordinate"

    ^ width @ height
!

extent:extent
    "set the extent"

    width := extent x.
    height := extent y
!

font
    "return the current drawing font"

    ^ gc font
!

font:aFont
    "set the font for drawing if it has changed.
     This should be redefined in some widget to perform an automatic
     redraw. See also: #basicFont:"

    gc font:aFont.
    self changed:#font.
!

function
    "return the current drawing function"

    ^ gc function
!

function:aSymbol
    "set the drawing function if it has changed"

    gc function:aSymbol
!

gcId
    "return the receivers graphic context id on the device"

    gc isNil ifTrue:[
        ^ nil.
    ].
    ^ gc gcId.
!

graphicsContext
    ^ gc
!

graphicsContext:newGc
    "set the graphics context"

    gc == newGc ifTrue:[
        ^ self.
    ].
    gc := newGc.
    device := newGc device.
!

graphicsDevice
    "same as #device, for ST-80 compatibility"

    ^ device
!

height
    "return the height of the receiver"

    ^ height
!

height:anInteger
    "set the height of the receiver"

    height := anInteger
!

id
    "return the id of the drawable on the device"

    ^ self drawableId
!

joinStyle
    "return the current join-style for polygon-drawing.
     possible styles are: #miter, #bevel, #round"

    ^ gc joinStyle
!

joinStyle:aStyleSymbol
    "set the join-style of lines in polygon-drawing;
     possible styles are: #miter, #bevel, #round"

    gc joinStyle:aStyleSymbol
!

left
    "return the left i.e. x-coordinate of top-left of the receiver"

    ^ 0
!

leftCenter
    "return the leftCenter point"

    ^ (self left) @ (self top + (height // 2) - 1)
!

lineStyle
    "return the current line-drawing-style.
     possible styles are: #solid, #dashed, #doubleDashed,
     #dotted, #dashDot or #dashDotDot."

    ^ gc lineStyle
!

lineStyle:aStyleSymbol
    "set the line-drawing-style;
     possible styles are: #solid, #dashed, #doubleDashed,
     #dotted, #dashDot or #dashDotDot."

    gc lineStyle:aStyleSymbol
!

lineWidth
    "return the current drawing linewidth"

    ^ gc lineWidth
!

lineWidth:aNumber
    "set the line drawing width in pixels"

    gc lineWidth:aNumber
!

mask
    "return the current drawing mask"

    ^ gc mask
!

mask:aForm
    "set the drawing mask"

    gc mask:aForm
!

maskOrigin
    "return the origin within the mask (used to draw with patterns).
     Should be redefined in classes which support it.
     This is an alias for ST-80's #phase"

    ^ gc maskOrigin
!

maskOrigin:aPoint
    "set the origin within the mask (used to draw with patterns).
     Should be redefined in classes which support it.
     This is an alias for ST-80's #phase:"

    gc maskOrigin:aPoint
!

maskOriginX:x y:y
    "set the origin within the mask (used to draw with patterns).
     Should be redefined in classes which support it.
     This is an alias for ST-80's #phase:"

    self maskOrigin:(x @ y)
!

medium
    "return the destination medium i.e. the underlying graphics device"

    ^ gc graphicsDevice
!

noClipByChildren
    "drawing shall also be done into subviews"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #clippedByChildren:false'.
    ^ self clippedByChildren:false

    "Created: 17.7.1996 / 14:15:54 / cg"
!

origin
    "return the origin i.e. coordinate of top-left of the receiver"

    ^ 0 @ 0
!

paint
    "return the current paint drawing color"

    ^ gc paint
!

paint:aColor
    "set the drawing painting color, aColor can be a dithered one"

    gc paint:aColor
!

paint:fgColor on:bgColor
    "set the paint and backgroundPaint, used for text and bitmaps.
     Both colors may be dithered colors"

    gc paint:fgColor on:bgColor
!

paint:fgColor on:bgColor function:f
    "set paint, background-paint and function"

    self paint:fgColor on:bgColor.
    self function:f

    "Modified: 16.5.1996 / 15:36:35 / cg"
!

realized
    "return true, if the receiver is realized.
     The receiver may still be unmapped, if the container is unrealized.
     Use reallyRealized to make certain that I am really mapped."

    ^ realized
!

reallyRealized
    "return true, if the receiver is realized and all containers
     are realized."

    ^ self realized

!

rightCenter
    "return the leftCenter point"

    ^ (self left + width - 1) @ (self top + (height // 2) - 1)
!

setClippingBounds:aRectangleOrNil
    gc setClippingBounds:aRectangleOrNil
!

setDevice:aDevice
    "set the device"

    device := aDevice.
    gc setDevice:aDevice
!

setGraphicsExposures:aBoolean
    "want to if aBoolean is true - or don't want to be notified
     of graphics exposures"

    gc setGraphicsExposures:aBoolean
!

setMaskOrigin:aPoint
    <resource: #obsolete>
    "set the origin within the mask (used to draw with patterns).
     OBSOLETE: use #maskOrigin: or #phase:"

    self obsoleteMethodWarning:'use #maskOrigin:'.
    ^ self maskOriginX:aPoint x y:aPoint y

    "Modified: / 26.1.1998 / 18:54:14 / cg"
!

setMaskOriginX:x y:y
    <resource: #obsolete>
    "set the origin within the mask (used to draw with patterns).
     OBSOLETE: use #maskOriginX:y: or #phase:"

    self obsoleteMethodWarning:'use #maskOriginX:y:'.
    ^ self maskOriginX:x y:y
!

setWidth:w height:h
    "set both width and height - not to be redefined"

    width := w.
    height := h
!

top
    "return the top i.e. y-coordinate of top-left of the receiver"

    ^ 0
!

topCenter
    "return the topCenter point"

    ^ (self left + (width//2) - 1) @ (self top)
!

topRight
    "return the topRight point"

    ^ (self left + width - 1) @ (self top)
!

viewBackground
    "for protocol compatibility with view; return my background paint color here"

    ^ self backgroundPaint
!

viewOrigin
    "return the drawables visible origin (for scrolling)"

    ^ 0@0
!

whiteColor
    gc isNil ifTrue:[
        ^ Color white.
    ].
    ^ gc whiteColor
!

width
    "return the width of the receiver"

    ^ width
!

width:anInteger
    "set the width of the receiver"

    width := anInteger
!

width:w height:h
    "set both width and height of the receiver"

    width := w.
    height := h
! !

!GraphicsMedium methodsFor:'accessing-internals'!

background
    <resource: #obsolete>
    "return the current background drawing color.
     OBSOLETE: use #paint: / #backgroundPaint: / #paint:on:"

    ^ gc background

    "Modified: 12.5.1996 / 22:28:09 / cg"
!

background:aColor
    <resource: #obsolete>
    "set the internal background color for drawing - aColor must be a real color.
     OBSOLETE: this method will vanish; use #paint: / #backgroundPaint: / #paint:on:"

    gc background:aColor
!

foreground
    <resource: #obsolete>
    "return the current foreground drawing color.
     OBSOLETE: use #paint: / #paint:on:"

    ^ gc foreground
!

foreground:aColor
    <resource: #obsolete>
    "set the internal foreground color for drawing - aColor must be a real color.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    gc foreground:aColor
!

foreground:fgColor background:bgColor
    <resource: #obsolete>
    "set both internal foreground and internal background colors
     - these must be real colors.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    gc foreground:fgColor background:bgColor
!

foreground:fgColor background:bgColor function:fun
    <resource: #obsolete>
    "set foreground, background colors and function.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    gc foreground:fgColor background:bgColor.
    gc function:fun

    "Modified: 12.5.1996 / 22:28:34 / cg"
!

foreground:aColor function:fun
    <resource: #obsolete>
    "set the foreground color and function for drawing.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    gc foreground:aColor function:fun
!

setRealized:aBoolean
    "low level special interface to manipulate the realized state.
     Non-public interface, only to be used by experts.
     (use to pretend a view has been realized - for example with alien views)"

    realized := aBoolean
! !

!GraphicsMedium methodsFor:'accessing-transformation'!

scale
    "return the scale factor (as point) of the transformation"

    ^ gc scale
!

scale:aPoint
    "set the scale factor of the transformation"

    ^ gc scale:aPoint
!

transformation
    "return the transformation"

    ^ gc transformation
!

transformation:aTransformation
    "set the transformation"

    ^ gc transformation:aTransformation
!

translateBy:aPoint
    "add to the translation offset of the transformation"

    ^ gc translateBy:aPoint
!

translation
    "return the translation factor (as point) of the transformation"

    ^ gc translation
!

translation:aPoint
    "set the translation offset of the transformation"

    ^ gc translation:aPoint
! !

!GraphicsMedium methodsFor:'basic drawing'!

displayArcX:x y:y width:width height:height from:startAngle angle:angle
    "draw an arc in a box
     - this could be recoded to draw using displayLine"

    gc displayArcX:x y:y width:width height:height from:startAngle angle:angle
!

displayDottedRectangleX:x y:y width:w height:h
    "draw a dotted-line rectangle
     A general implementation is found here; deviceGC's
     may reimplement this if directly supported by the device"

    gc displayDottedRectangleX:x y:y width:w height:h
!

displayHorizontalWavelineFromX:x0 y:y0 toX:x1
    "draw a horizontal wave-line from x0/y0 to x1/y0"

    gc displayHorizontalWavelineFromX:x0 y:y0 toX:x1
!

displayLineFromX:x0 y:y0 toX:x1 y:y1
    "draw a line from x0/y0 to x1/y1"

    gc displayLineFromX:x0 y:y0 toX:x1 y:y1
!

displayOpaqueForm:aForm x:x y:y
    "draw a form at x/y; if the form has depth 1, 1's in the form are
     drawn in current fg, 0's in current bg color.
     If the form has depth ~~ 1, it is copied as is onto the receiver"

    gc displayOpaqueForm:aForm x:x y:y
!

displayOpaqueString:aString from:index1 to:index2 x:x y:y
    "draw part of a string with both fg and bg at x/y in current font"

    gc displayString:aString from:index1 to:index2 x:x y:y opaque:true maxWidth:self width
!

displayPolygon:aPolygon
    "draw a polygon
     - this could be recoded to draw using displayLine"

    gc displayPolygon:aPolygon
!

displayRectangleX:x y:y width:w height:h
    "draw a rectangle
     - this could be recoded to draw using displayLine"

    gc displayRectangleX:x y:y width:w height:h
!

displayString:aString from:index1 to:index2 x:x y:y
    "draw part of a string with fg at x/y in current font"

    gc displayString:aString from:index1 to:index2 x:x y:y opaque:false maxWidth:self width
!

displayString:aString from:index1 to:index2 x:x y:y opaque:opaque
    "draw part of a string with both fg and bg at x/y in current font"

    self displayString:aString from:index1 to:index2 x:x y:y opaque:opaque maxWidth:self width.
!

displayString:aString from:index1 to:index2 x:x y:y opaque:opaque maxWidth:maxWidth
    "draw part of a string with both fg and bg at x/y in current font"

    gc displayString:aString from:index1 to:index2 x:x y:y opaque:opaque maxWidth:maxWidth
! !

!GraphicsMedium methodsFor:'basic filling'!

fillArcX:x y:y width:w height:h from:start angle:angle
    "fill an arc with current paint color"

    gc fillArcX:x y:y width:w height:h from:start angle:angle
!

fillPolygon:points
    "fill a polygon with current paint color"

    gc fillPolygon:points
!

fillRectangleX:x y:y width:w height:h
    "fill a rectangle with current paint color"

    gc fillRectangleX:x y:y width:w height:h
!

fillRectangleX:x y:y width:w height:h color:aColor
    "fill a rectangle with given color"

    gc fillRectangleX:x y:y width:w height:h color:aColor
! !

!GraphicsMedium methodsFor:'bit blitting'!

copyBitsFrom:aByteArray bitsPerPixel:bpp depth:depth padding:pad width:srcW height:srcH x:srcX y:srcY toX:dstX y:dstY
    "copy bits from a smalltalk byteArray.
     The bits found there are supposed to be in the devices native format (i.e.
     translated to allocated color indices on pseudoColor devices and padded as required.
     The byteOrder is MSB and will be converted as appropriate by the underlying devices
     method to whatever the device needs."

    gc copyBitsFrom:aByteArray bitsPerPixel:bpp depth:depth padding:pad width:srcW height:srcH x:srcX y:srcY toX:dstX y:dstY
!

copyFrom:aGC toX:dstX y:dstY
    "copy from a drawable - maybe self"

    self copyFrom:aGC x:0 y:0 toX:dstX y:dstY width:aGC width height:aGC height async:false
!

copyFrom:aGC x:srcX y:srcY toX:dstX y:dstY width:w height:h
    "copy from a drawable - maybe self"

    self copyFrom:aGC x:srcX y:srcY toX:dstX y:dstY width:w height:h async:false
!

copyFrom:aDrawable x:srcX y:srcY toX:dstX y:dstY width:w height:h async:async
    "copy from aDrawable into the receiver;
     the source may be the receiver as well - in this case its a scroll.
     All coordinates are in device coordinates.
     If the receiver is a view AND async is true, the call returns immediately
     - otherwise, it returns when the scroll operation is finished.
     (not all devices care for this).
     If the receiver is a pixmap, the call always returns immediately."

    |deviceDrawable mustWait sourceDepth|

    ((aDrawable graphicsDevice ~~ device)
     or:[aDrawable isImage]) ifTrue:[
        deviceDrawable := aDrawable asFormOn:device.
    ] ifFalse:[
        deviceDrawable := aDrawable
    ].
    sourceDepth := deviceDrawable depth.
    mustWait := async not 
                    and:[deviceDrawable isView 
                    and:[(sourceDepth ~~ 1) or:[device depth == 1]]].
    mustWait ifTrue:[
        mustWait := self catchExpose.
    ].
    gc copyFrom:deviceDrawable graphicsContext x:srcX y:srcY toX:dstX y:dstY width:w height:h depth:sourceDepth.
    mustWait ifTrue:[
        self waitForExpose
    ]
!

copyFrom:aGC x:dstX y:dstY width:w height:h
    "copy from a drawable - maybe self"

    self copyFrom:aGC x:0 y:0 toX:dstX y:dstY width:w height:h async:false
!

copyPlaneFrom:aDrawable x:srcX y:srcY toX:dstX y:dstY width:w height:h
    "copy one plane from aDrawable into the receiver. 0's are drawn in
     background, while 1's are drawn with foreground color.
     The depth of aDrawable must (should) be 1.
     The drawable must have been allocated on the same device.
     All coordinates are in device coordinates."

    |deviceDrawable|

    ((aDrawable graphicsDevice ~~ device)
    or:[aDrawable isImage]) ifTrue:[
        deviceDrawable := aDrawable asFormOn:device.
    ] ifFalse:[
        deviceDrawable := aDrawable
    ].

    gc copyPlaneFrom:deviceDrawable graphicsContext x:srcX y:srcY toX:dstX y:dstY width:w height:h
! !

!GraphicsMedium methodsFor:'copying'!

postCopy
    "this may not be enough to allow copying of views ..."

    super postCopy.
    realized := false.
!

postDeepCopy
    super postDeepCopy.
    realized := false.
! !

!GraphicsMedium methodsFor:'drawing'!

display:someObject at:aPoint
    "draw someObject - this must understand the #displayOn:at: message"

    someObject displayOn:self at:aPoint

    "Created: 28.5.1996 / 14:22:57 / cg"
!

displayArcIn:aRectangle from:startAngle angle:angle
    "draw an arc in a box"

    self
	displayArcX:(aRectangle left)
		  y:(aRectangle top)
	      width:(aRectangle width)
	     height:(aRectangle height)
	       from:startAngle
	      angle:angle
!

displayArcOrigin:origin corner:corner from:startAngle angle:angle
    "draw an arc in a box"

    |left top right bot|

    left := origin x.
    top := origin y.
    right := corner x.
    bot := corner y.
    self
	displayArcX:left
		  y:top
	      width:(right - left + 1)
	     height:(bot - top + 1)
	       from:startAngle
	      angle:angle

    "Modified: 8.5.1996 / 08:35:25 / cg"
!

displayArcX:x y:y w:w h:h from:startAngle angle:angle
    "draw an arc; apply transformation if nonNil"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #displayArcX:y:width:height:from:angle:'.
    self displayArcX:x y:y width:w height:h from:startAngle angle:angle

    "Modified: 8.5.1996 / 08:46:56 / cg"
!

displayCircle:aPoint radius:r
    "draw a circle around a center point"

    gc displayCircleX:(aPoint x) y:(aPoint y) radius:r
!

displayCircleIn:aRectangle
    "draw a circle in a box"

    self
	displayArcX:(aRectangle left)
		  y:(aRectangle top)
	      width:(aRectangle width)
	     height:(aRectangle height)
	       from:0
	      angle:360

    "Modified: 8.5.1996 / 08:35:40 / cg"
!

displayCircleX:x y:y radius:r
    "draw a circle around a center point"

    |d|
    d := 2 * r.
    self
	displayArcX:(x - r)
		  y:(y - r)
	      width:d
	     height:d
	       from:0
	      angle:360

    "Modified: 8.5.1996 / 08:36:03 / cg"
!

displayForm:aFormOrImage
    "draw a form (or image) at the origin"

    gc displayForm:aFormOrImage x:0 y:0

    "Modified: / 24.4.1997 / 16:00:11 / cg"
    "Created: / 9.11.1997 / 00:50:52 / cg"
!

displayForm:aFormOrImage at:aPoint
    "draw a form (or image)"

    gc displayForm:aFormOrImage x:(aPoint x) y:(aPoint y)

    "Modified: 24.4.1997 / 16:00:11 / cg"
!

displayForm:formToDraw x:x y:y
    "draw a form or image non opaque;
     if its a 1-plane bitmap, 1-bits are drawn in the
     current paint-color, leaving pixels with 0-bits unchanged
     (i.e. only 1-bits are drawn from the form).
     If its a deep form (i.e. a pixmap) the current paint
     settings are ignored and the form is drawn as-is.
     Care must be taken, that the paint color is correctly allocated
     (by sending #on: to the color) before doing so.
     Using functions other than #copy only makes sense if you are
     certain, that the colors are real colors (actually, only for
     noColor or allColor)."

    gc displayForm:formToDraw x:x y:y
!

displayForm:aFormOrImage x:x y:y opaque:opaque
    "draw a form (or image) at x/y;
     if the form has depth 1, 1's in the form are
     drawn in current paint color, 0's are ignored.
     If the form has depth ~~ 1, the current fg color setting is ignored."

    opaque ifTrue:[
	self displayOpaqueForm:aFormOrImage x:x y:y
    ] ifFalse:[
	self displayForm:aFormOrImage x:x y:y
    ].
!

displayImage:aFormOrImage
    "draw an image (or form).
     Provided for ST-80 compatibilty;
     in ST/X, images are also handled by #displayForm:"

    gc displayForm:aFormOrImage x:0 y:0
!

displayImage:aFormOrImage at:aPoint
    "draw an image (or form).
     Provided for ST-80 compatibilty;
     in ST/X, images are also handled by #displayForm:"

    gc displayForm:aFormOrImage x:(aPoint x) y:(aPoint y)

    "Modified: 24.4.1997 / 16:02:43 / cg"
!

displayImage:aFormOrImage x:x y:y
    "draw an image (or form).
     Provided for ST-80 compatibilty;
     in ST/X, images are also handled by #displayForm:"

    gc displayForm:aFormOrImage x:x y:y

    "Created: 24.4.1997 / 16:03:03 / cg"
!

displayLineFrom:point1 to:point2
    "draw a line"

    gc displayLineFromX:(point1 x) y:(point1 y)
                      toX:(point2 x) y:(point2 y)
!

displayLineFromX:xStart y:yStart toX:xEnd y:yEnd brush:aForm
    "draw a line using a brush.
     Here, a slow fallback is used, drawing into a
     temporary bitmap first, which is then displayed"

    |deltaX deltaY dx dy px py destX destY p tempForm
     xMin xMax yMin yMax x1 x2 y1 y2|

    xStart < xEnd ifTrue:[
	xMin := xStart.
	xMax := xEnd.
    ] ifFalse:[
	xMin := xEnd.
	xMax := xStart
    ].
    yStart < yEnd ifTrue:[
	yMin := yStart.
	yMax := yEnd.
    ] ifFalse:[
	yMin := yEnd.
	yMax := yStart
    ].

    tempForm := Form width:(xMax-xMin+1+aForm width)
		     height:(yMax-yMin+1+aForm height)
		     depth:aForm depth
		     onDevice:self graphicsDevice.
    tempForm clear.
    tempForm paint:(Color colorId:1) on:(Color colorId:0).
    tempForm function:#or.

    ((yStart = yEnd and:[xStart < xEnd])
    or: [yStart < yEnd]) ifTrue:[
	x1 := xStart. y1 := yStart.
	x2 := xEnd. y2 := yEnd.
    ] ifFalse:[
	x1 := xEnd. y1 := yEnd.
	x2 := xStart. y2 := yStart.
    ].

    x1 := x1 - xMin.  x2 := x2 - xMin.
    y1 := y1 - yMin.  y2 := y2 - yMin.

    destX := x1.
    destY := y1.

    "/ bresenham ...

    deltaX := x2 - x1.
    deltaY := y2 - y1.

    dx := deltaX sign.
    dy := deltaY sign.
    px := deltaY abs.
    py := deltaX abs.

    tempForm displayForm:aForm x:destX y:destY.

    py > px ifTrue:[
	"horizontal"
	p := py // 2.
	py timesRepeat:[
	    destX := destX + dx.
	    (p := p - px) < 0 ifTrue:[
		destY := destY + dy.
		p := p + py
	    ].
	    tempForm displayForm:aForm x:destX y:destY.
	]
    ] ifFalse:[
	"vertical"
	p := px // 2.
	px timesRepeat:[
	    destY := destY + dy.
	    (p := p - py) < 0 ifTrue:[
		destX := destX + dx.
		p := p + px
	    ].
	    tempForm displayForm:aForm x:destX y:destY
	]
    ].
    self displayForm:tempForm
		   x:xMin-aForm offset x
		   y:yMin-aForm offset y.
    tempForm close

    "Modified: 1.4.1997 / 21:29:06 / cg"
!

displayOpaqueString:aString at:aPoint
    "draw a string with both fg and bg"

    gc displayOpaqueString:aString x:(aPoint x) y:(aPoint y)
!

displayOpaqueString:aString from:start to:stop at:aPoint
    "draw part of a string - drawing both fg and bg"

    gc displayString:aString from:start to:stop x:aPoint x y:aPoint x opaque:true maxWidth:self width.
!

displayOpaqueString:aString x:x y:y
    "draw a string at the coordinate x/y - draw foreground pixels in paint-color,
     background pixels in bgPaint color. If the transformation involves scaling,
     the fonts point-size is scaled as appropriate.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors or images."

    gc displayOpaqueString:aString x:x y:y
!

displayOpaqueString:aString x:x y:y angle:drawAngle
    "draw a string along a (possibly non-horizontal) line,
     drawing both fg and bg pixels.
     The angle is in degrees, clock-wise, starting with 0 for
     a horizontal draw.
     Drawing is done by first drawing the string into a temporary bitmap,
     which is rotated and finally drawn as usual.
     NOTICE: due to the rotation of the temporary bitmap, this is a slow
             operation - not to be used with cillions of strings ..."

    gc displayString:aString x:x y:y angle:drawAngle opaque:true

    "
     |v|

     v := View new.
     v extent:300@200.
     v openAndWait.
     0 to:360 by:45 do:[:a |
         v paint:Color black on:Color red.
         v displayOpaqueString:'hello world' x:100 y:100 angle:a.
     ].
    "

    "in contrast to non-opaque draw:
     |v|

     v := View new.
     v extent:300@200.
     v openAndWait.
     0 to:360 by:45 do:[:a |
         v paint:Color black on:Color red.
         v displayString:'hello world' x:100 y:100 angle:a.
     ].
    "

    "Modified: 23.4.1997 / 17:50:23 / cg"
!

displayPoint:aPoint
    "draw a pixel"

    gc displayPointX:(aPoint x) y:(aPoint y)
!

displayPointX:x y:y
    "draw a point (with current paint-color); apply transformation if nonNil"

    gc displayPointX:x y:y
!

displayRectangle:aRectangle
    "draw a rectangle"

    gc displayRectangleX:(aRectangle left) y:(aRectangle top)
       width:(aRectangle width) height:(aRectangle height)
!

displayRectangleOrigin:origin corner:corner
    "draw a rectangle"

    |top left|

    left := origin x.
    top := origin y.
    self displayRectangleX:left y:top width:(corner x - left) height:(corner y - top)
!

displayRectangleOrigin:origin extent:extent
    "draw a rectangle"

    self displayRectangleX:(origin x) y:(origin y)
		     width:(extent x)
		    height:(extent y)
!

displayRoundRectangleX:left y:top width:width height:height wCorner:wCorn hCorner:hCorn
    |right bottom wC hC wHalf hHalf isWin32|

    "/ BIG KLUDGE WARNING HERE: the code below looks "good" on windows displays;
    "/ (if you change anything under Unix, make it X-platform specific.
    "/ (there seem to be drawing incompatibilities between Win- and XWorkstation)

    isWin32 := self device isWindowsPlatform.

    right := left + width-1.
    bottom := top + height-1.

    wC := wCorn.
    hC := hCorn.

    self scale = 1 ifTrue:[
	wHalf := wC // 2.
	hHalf := hC // 2.
    ] ifFalse:[
	wHalf := wC / 2.
	hHalf := hC / 2.
    ].

    "top left arc"
    self displayArcX:left y:top width:wC height:hC from:90 angle:90.

    "top right arc"
    self displayArcX:(right - wC) y:top width:wC height:hC from:0 angle:90.

    "bottom right arc"
    (isWin32 and:[self scale = 1]) ifTrue:[
	self displayArcX:(right - wC+1) y:(bottom - hC+1) width:wC height:hC from:270 angle:90.
    ] ifFalse:[
	self displayArcX:(right - wC) y:(bottom - hC) width:wC height:hC from:270 angle:90.
    ].

    "bottom left arc"
    self displayArcX:left y:(bottom - hC) width:wC height:hC from:180 angle:90.

    "top line"
    self displayLineFromX:(left + wHalf) y:top toX:(right - wHalf-1) y:top.

    "left line"
    self displayLineFromX:left y:(top + hHalf - 1) toX:left y:(bottom - hHalf - 2).

    "bottom line"
    self displayLineFromX:(left + wHalf-1) y:bottom
		      toX:(right - wHalf ) y:bottom.

    "right line"
    self displayLineFromX:right y:(top + hHalf) toX:right y:(bottom - hHalf).


    "
     |v|

     (v := View new) extent:200@200; openAndWait.
     v displayRoundRectangleX:10 y:10 width:100 height:100 wCorner:20 hCorner:20
    "
!

displayString:aString at:aPoint
    "draw a string - drawing fg only"

    self displayString:aString x:aPoint x y:aPoint y
!

displayString:aString centeredAt:aPoint
    "draw a string - drawing fg only"

    self displayString:aString centeredAtX:aPoint x y:aPoint y
!

displayString:aString centeredAtX:x y:y
    "draw a string - drawing fg only"

    |w h|

    w := aString widthOn:self.
    h := aString heightOn:self.
    self displayString:aString x:x-(w/2) y:y-(h/2)
!

displayString:aString from:start to:stop at:aPoint
    "draw part of a string - drawing fg only"

    ^ self displayString:aString from:start to:stop x:aPoint x y:aPoint y
!

displayString:aString x:x y:y
    "draw a string at the coordinate x/y -
     draw foreground-pixels only (in current paint-color),
     leaving background as-is. If the transformation involves scaling,
     the fonts point-size is scaled as appropriate."

    self displayString:aString from:1 to:aString size x:x y:y opaque:false maxWidth:self width.
!

displayString:aString x:x y:y angle:drawAngle
    "draw a string along a (possibly non-horizontal) line - drawing fg only.
     The angle is in degrees, clock-wise, starting with 0 for
     a horizontal draw.
     Drawing is done by first drawing the string into a temporary bitmap,
     which is rotated and finally drawn as usual.
     NOTICE: due to the rotation of the temporary bitmap, this is a slow
	     operation - not to be used with cillions of strings ..."

    self
	displayString:aString x:x y:y angle:drawAngle opaque:false

    "
     |v|

     v := View new.
     v extent:300@200.
     v openAndWait.
     0 to:360 by:90 do:[:a |
	 v paint:Color black.
	 v displayString:'hello world' x:100 y:100 angle:a.
     ].
    "
    "
     |v|

     v := View new.
     v extent:400@400.
     v openAndWait.
     0 to:360 by:5 do:[:a |
	 v paint:Color black.
	 v displayString:'.........hello' x:200 y:200 angle:a.
     ].
    "
    "
     |v|

     v := View new.
     v extent:200@100.
     v openAndWait.
     v displayString:' hello' x:90 y:50 angle:0.
     v displayString:' hello' x:90 y:50 angle:45.
     v displayString:' hello' x:90 y:50 angle:90.
     v displayString:' hello' x:90 y:50 angle:180.
     v displayString:' hello' x:90 y:50 angle:270.
    "
    "
     |v|

     v := View new.
     v extent:200@100.
     v openAndWait.
     v displayString:'hello' x:50 y:50 angle:0.
     v displayString:'hello' x:50 y:50 angle:45.
     v displayString:'hello' x:50 y:50 angle:90.
     v displayString:'hello' x:50 y:50 angle:135.
     v displayString:'hello' x:50 y:50 angle:180.
     v displayString:'hello' x:50 y:50 angle:225.
     v displayString:'hello' x:50 y:50 angle:270.
     v displayString:'hello' x:50 y:50 angle:315.
    "

    "Modified: 24.4.1997 / 12:51:25 / cg"
!

displayString:aString x:x y:y angle:drawAngle opaque:opaque
    "common code to draw a string along a (possibly non-horizontal) line.
     The angle is in degrees, clock-wise, starting with 0 for
     a horizontal draw.
     Drawing is done by first drawing the string into a temporary bitmap,
     which is rotated and finally drawn as usual.
     NOTICE: due to the rotation of the temporary bitmap, this is a slow
             operation - not to be used with cillions of strings ...
     CAVEAT: if the string is not a real string (i.e. a LabelAndIcon),
             this can (currently) only be done opaque"

    gc displayString:aString x:x y:y angle:drawAngle opaque:opaque
!

displayUnscaledForm:formToDraw x:x y:y
    "draw a form or image non opaque and unscaled;
     if its a 1-plane bitmap, 1-bits are drawn in the
     current paint-color, leaving pixels with 0-bits unchanged
     (i.e. only 1-bits are drawn from the form).
     If its a deep form (i.e. a pixmap) the current paint
     settings are ignored and the form is drawn as-is.
     Care must be taken, that the paint color is correctly allocated
     (by sending #on: to the color) before doing so.
     Using functions other than #copy only makes sense if you are
     certain, that the colors are real colors (actually, only for
     noColor or allColor).
     The origins coordinate is transformed, but the image itself is unscaled."

    gc displayUnscaledForm:formToDraw x:x y:y
!

displayUnscaledOpaqueForm:formToDraw x:x y:y
    "draw a form or image opaque and unscaled;
     if its a 1-plane bitmap, 1-bits are drawn in the
     current paint-color, 0 bits in background color.
     If its a deep form (i.e. a pixmap) the current paint
     settings are ignored and the form is drawn as-is (opaque).
     The origins coordinate is transformed, but the image itself is unscaled."

    gc displayUnscaledOpaqueForm:formToDraw x:x y:y
!

displayUnscaledOpaqueString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the transformed coordinate x/y but do not scale the font.
     Draw foreground pixels in paint-color, background pixels in bgPaint color."

    gc displayUnscaledOpaqueString:aString from:index1 to:index2 x:x y:y
!

displayUnscaledOpaqueString:aString x:x y:y
    "draw a string at the transformed coordinate x/y but do not scale the font.
     Draw foreground pixels in paint-color, background pixels in bgPaint color."

    gc displayUnscaledOpaqueString:aString x:x y:y
!

displayUnscaledString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the transformed coordinate x/y but do not scale the font.
     draw foreground-pixels only (in current paint-color), leaving background as-is."

    gc displayUnscaledString:aString from:index1 to:index2 x:x y:y
!

displayUnscaledString:aString x:x y:y
    "draw a string at the transformed coordinate x/y but do not scale the font.
     draw foreground-pixels only (in current paint-color), leaving background as-is."

    gc displayUnscaledString:aString x:x y:y
! !

!GraphicsMedium methodsFor:'drawing in device coordinates'!

displayDeviceForm:aForm x:x y:y
    "draw a form or image non opaque (i.e. only foreground color is drawn);
     If its a 1-plane bitmap, 1-bits are drawn in the
     current paint-color, leaving pixels with 0-bits unchanged
     (i.e. only 1-bits are drawn from the form).
     If its a deep form (i.e. a pixmap) the current paint
     settings are ignored and the form is drawn as-is;
     however, the mask is applied if present.

     The form should must have been allocated on the same device,
     otherwise its converted here, which slows down the draw.
     No transformation or scaling is done.
     Care must be taken, that the paint color is correctly allocated
     (by sending #on: to the color) before doing so.
     Using functions other than #copy only makes sense if you are
     certain, that the colors are real colors (actually, only for
     noColor or allColor)."

    gc displayDeviceForm:aForm x:x y:y
!

displayDeviceLineFromX:x1 y:y1 toX:x2 y:y2
    "draw a line in device coordinates"

    gc displayDeviceLineFromX:x1 y:y1 toX:x2 y:y2
!

displayDeviceOpaqueForm:aForm x:x y:y
    "draw a form or image opaque (i.e. both fg and bg is drawn);
     If its a 1-plane bitmap, 1-bits are drawn in the
     current paint-color and 0-bits in the bgPaint color.
     If its a deep form (i.e. a pixmap) the current paint/bgPaint
     settings are ignored and the form drawn as-is.
     Any mask is ignored.
     In the 1-plane case, special care must be taken if paint and/or bgPaint
     dithered colors or patterns, since are that the colors are correctly allocated (by sending #on:
     to the colors) before doing so.
     The form should have been allocated on the same device; otherwise,
     its converted here, which slows down the draw.
     Drawing is in device coordinates; no scaling is done."

    gc displayDeviceOpaqueForm:aForm x:x y:y
!

displayDeviceOpaqueString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the coordinate x/y - draw foreground pixels in
     paint-color and background pixels in bgPaint-color.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors.
     No translation or scaling is done."

    self displayDeviceOpaqueString:aString from:index1 to:index2 in:self font x:x y:y
!

displayDeviceOpaqueString:aString x:x y:y
    "draw a string at the coordinate x/y - draw foreground pixels in
     paint-color and background pixels in bgPaint-color.
     No translation or scaling is done"

    self displayDeviceOpaqueString:aString from:1 to:(aString size) in:self font x:x y:y
!

displayDeviceRectangleX:x y:y width:w height:h
    "draw a rectangle in device coordinates"

    gc displayDeviceRectangleX:x y:y width:w height:h
!

displayDeviceString:aString from:index1 to:index2 in:font x:x y:y
    "draw a substring at the coordinate x/y -
     draw foreground-pixels only (in current paint-color), leaving background as-is.
     No translation or scaling is done"

    gc displayDeviceString:aString from:index1 to:index2 in:font x:x y:y
!

displayDeviceString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the coordinate x/y -
     draw foreground-pixels only (in current paint-color), leaving background as-is.
     No translation or scaling is done"

    self displayDeviceString:aString from:index1 to:index2 in:self font x:x y:y
!

displayDeviceString:aString x:x y:y
    "draw a string at the coordinate x/y -
     draw foreground-pixels only (in current paint-color), leaving background as-is.
     No translation or scaling is done"

    self displayDeviceString:aString from:1 to:(aString size) in:self font x:x y:y
!

fillDeviceRectangleX:x y:y width:w height:h
    "fill a rectangle with current paint color (device coordinates)"

    gc fillDeviceRectangleX:x y:y width:w height:h
! !

!GraphicsMedium methodsFor:'edge drawing'!

drawEdgesForX:x y:y width:w height:h level:l
    "draw 3D edges into a rectangle"
    self
	drawEdgesForX:x y:y width:w height:h level:l
	shadow:self blackColor light:self whiteColor
	halfShadow:nil halfLight:nil
	style:nil
!

drawEdgesForX:x y:y width:w height:h level:l
		shadow:shadowColor light:lightColor
		halfShadow:halfShadowColor halfLight:halfLightColor
		style:edgeStyle

    "draw 3D edges into a rectangle"

    |topLeftFg botRightFg topLeftHalfFg botRightHalfFg
     count "{ Class: SmallInteger }"
     r
     b
     xi    "{ Class: SmallInteger }"
     yi    "{ Class: SmallInteger }"
     run paint|

    count := l.
    (count < 0) ifTrue:[
	topLeftFg := shadowColor.
	botRightFg := lightColor.
	topLeftHalfFg := halfShadowColor.
	botRightHalfFg := halfLightColor.
	count := count negated
    ] ifFalse:[
	topLeftFg := lightColor.
	botRightFg := shadowColor.
	topLeftHalfFg := halfLightColor.
	botRightHalfFg := halfShadowColor.
    ].
    topLeftHalfFg isNil ifTrue:[
	topLeftHalfFg := topLeftFg
    ].
    botRightHalfFg isNil ifTrue:[
	botRightHalfFg := botRightFg
    ].

    r := x + w - 1. "right"
    b := y + h - 1. "bottom"

    self lineWidth:0.

    "top and left edges"
    ((edgeStyle == #soft or:[edgeStyle == #softWin95]) and:["l" count > 0]) ifTrue:[
	paint := topLeftHalfFg
    ] ifFalse:[
	paint := topLeftFg
    ].
    self paint:paint.

    0 to:(count - 1) do:[:i |
	run := y + i.
	run < b ifTrue:[
	    self displayDeviceLineFromX:x y:run toX:r y:run. "top"
	].
	run := x + i.
	self displayDeviceLineFromX:run y:y toX:run y:b  "left"
    ].
    (edgeStyle == #soft or:[edgeStyle == #softWin95]) ifTrue:[
"
	self paint:topLeftFg.
	self displayDeviceLineFromX:x y:y toX:r y:y.
	self displayDeviceLineFromX:x y:y toX:x y:b
"
	(l > 1) ifTrue:[
	    edgeStyle == #softWin95 ifTrue:[
		self paint:(Color veryLightGrey).
	    ] ifFalse:[
		(l > 2 and:[edgeStyle == #soft]) ifTrue:[
		    self paint:(self device blackColor).
		] ifFalse:[
		    self paint:halfLightColor.
		]
	    ].
	    self displayDeviceLineFromX:x y:y toX:r y:y.
	    self displayDeviceLineFromX:x y:y toX:x y:b.
	]
    ].

    xi := x + 1.
    yi := y + 1.

"/ does not look good
"/ style == #st80 iftrue:[
"/  yi := yi + 1
"/ ].

    "bottom and right edges"
    ((edgeStyle == #soft or:[edgeStyle == #softWin95])
    "new:" and:[count > 1]) ifTrue:[
	paint := botRightHalfFg
    ] ifFalse:[
	paint := botRightFg
    ].

    self paint:paint.
    0 to:(count - 1) do:[:i |
	run := b - i.
	run > y ifTrue:[
	    self displayDeviceLineFromX:xi-1 y:run toX:r y:run. "bottom"
	].
	run := r - i.
	self displayDeviceLineFromX:run y:yi-1 toX:run y:b.  "right"
	xi := xi + 1.
	yi := yi + 1
    ].
    ((edgeStyle == #soft or:[edgeStyle == #softWin95])
    and:[l > 1]) ifTrue:[
	self paint:(self device blackColor) "shadowColor".
	self displayDeviceLineFromX:x y:b toX:r y:b.
	self displayDeviceLineFromX:r y:y toX:r y:b
    ].

    self edgeDrawn:#all

    "Modified: / 24.8.1998 / 18:23:02 / cg"
!

edgeDrawn:whichOne
    "a redefinable hook for views which like to draw
     over their edges (some checkToggles do).
     Nothing done here."

    "Created: 7.3.1997 / 17:59:07 / cg"
! !

!GraphicsMedium methodsFor:'evaluating in another context'!

reverseDo:aBlock
    "evaluate aBlock with foreground and background interchanged.
     This can be reimplemented here in a faster way."

    gc reverseDo:aBlock
!

withBackground:fgColor do:aBlock
    "evaluate aBlock with changed background."

    gc withBackground:fgColor do:aBlock
!

withForeground:fgColor background:bgColor do:aBlock
    "evaluate aBlock with changed foreground and background."

    gc withForeground:fgColor background:bgColor do:aBlock
!

withForeground:fgColor background:bgColor function:aFunction do:aBlock
    "evaluate aBlock with foreground, background and function"

    gc withForeground:fgColor background:bgColor function:aFunction do:aBlock
!

withForeground:fgColor background:bgColor mask:aMask do:aBlock
    "evaluate aBlock with foreground, background and mask"

    gc withForeground:fgColor background:bgColor mask:aMask do:aBlock
!

withForeground:fgColor do:aBlock
    "evaluate aBlock with changed foreground."

    gc withForeground:fgColor do:aBlock
!

withForeground:fgColor function:aFunction do:aBlock
    "evaluate aBlock with changed foreground and function."

    gc withForeground:fgColor function:aFunction do:aBlock
!

withPaint:aColor do:aBlock
    "evaluate aBlock with changed paint color."

    gc withPaint:aColor do:aBlock
!

xoring:aBlock
    "evaluate aBlock with function xoring"

    gc xoring:aBlock
! !

!GraphicsMedium methodsFor:'event handling'!

catchExpose
    "expose event handling is only required for views."

    ^ false.
!

waitForExpose
    "expose event handling is only required for views."

    ^ self.
! !

!GraphicsMedium methodsFor:'filling'!

black
    "fill the receiver with black"

    self fill:self blackColor
!

clear
    "clear the receiver with background"

    self clearView.
!

clearDeviceRectangleX:x y:y width:w height:h
    "clear a rectangular area to background"

    gc clearDeviceRectangleX:x y:y width:w height:h.
!

clearInside
    "clear the receiver with background - ST-80 compatibility"

    ^ self clear
!

clearRectangle:aRectangle
    "clear the rectangular area in the receiver to background"

    self clearRectangleX:(aRectangle left)
		       y:(aRectangle top)
		   width:(aRectangle width)
		  height:(aRectangle height)
!

clearRectangleX:x y:y width:w height:h
    gc clearRectangleX:x y:y width:w height:h.
!

clearView
    "clear the receiver with background"

"/    "currently need this kludge for form ..."
"/    gc transformation isNil ifTrue:[
"/        self clearRectangleX:0 y:0 width:width height:height
"/    ] ifFalse:[
        self clearDeviceRectangleX:0 y:0 width:width height:height
"/    ]
!

fill:something
    "fill the receiver with something;
     something may be a Form, Color or colorIndex"

    gc fillRectangle:(self boundingBox) color:something
!

fillArc:origin radius:r from:startAngle angle:angle
    "draw a filled arc around a point"

    |d|
    d := 2 * r.
    self
	fillArcX:(origin x - r)
	       y:(origin y - r)
	   width:d
	  height:d
	    from:startAngle
	   angle:angle

    "Modified: 8.5.1996 / 08:41:54 / cg"
!

fillArcIn:aRectangle from:startAngle angle:angle
    "draw a filled arc in a box"

    self
	fillArcX:(aRectangle left)
	       y:(aRectangle top)
	   width:(aRectangle width)
	  height:(aRectangle height)
	    from:startAngle
	   angle:angle

    "Created: 13.4.1996 / 20:56:03 / cg"
    "Modified: 8.5.1996 / 08:42:13 / cg"
!

fillArcOrigin:origin corner:corner from:startAngle angle:angle
    "draw a filled arc in a box"

    |left top right bot|

    left := origin x.
    top := origin y.
    right := corner x.
    bot := corner y.
    self
	fillArcX:left
	y:top
	width:(right - left + 1)
	height:(bot - top + 1)
	from:startAngle
	angle:angle

    "Created: 13.4.1996 / 20:56:56 / cg"
    "Modified: 8.5.1996 / 08:42:23 / cg"
!

fillArcX:x y:y w:w h:h from:startAngle angle:angle
    "draw a filled arc; apply transformation if nonNil"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #fillArcX:y:width:height:from:angle:'.
    self fillArcX:x y:y width:w height:h from:startAngle angle:angle

    "Modified: 8.5.1996 / 08:47:52 / cg"
!

fillArcX:x y:y width:w height:h from:startAngle to:endAngle
    "draw a filled arc in a box, given startAngle and endAngle."

    self
	fillArcX:x
	       y:y
	   width:w
	  height:h
	    from:startAngle
	   angle:(endAngle - startAngle)

    "Created: 8.5.1996 / 08:52:41 / cg"
!

fillCircle:aPoint radius:aNumber
    "draw a filled circle around aPoint"

    self fillCircleX:(aPoint x) y:(aPoint y) radius:aNumber
!

fillCircleIn:aRectangle
    "draw a filled circle in a box"

    self
	fillArcX:(aRectangle left)
	       y:(aRectangle top)
	   width:(aRectangle width)
	  height:(aRectangle height)
	    from:0
	   angle:360

    "Created: 13.4.1996 / 20:57:41 / cg"
    "Modified: 8.5.1996 / 08:42:38 / cg"
!

fillCircleX:x y:y radius:r
    "draw a filled circle around x@y"

    |d|

    d := 2 * r.
    self
	fillArcX:(x - r)
	y:(y - r)
	width:d
	height:d
	from:0
	angle:360

    "Modified: 8.5.1996 / 08:43:02 / cg"
!

fillRectangle:aRectangle
    "fill a rectangle with current paint color"

    self fillRectangleX:(aRectangle left)
		      y:(aRectangle top)
		  width:(aRectangle width)
		 height:(aRectangle height)
!

fillRectangleLeft:left top:top right:cornerX bottom:cornerY
    "draw a filled rectangle.
     Notice: the cornerPoint itself is NOT included"

    self fillRectangleX:left y:top width:(cornerX - left) height:(cornerY - top)
!

fillRectangleOrigin:origin corner:corner
    "draw a filled rectangle.
     Notice: the cornerPoint itself is NOT included"

    |top left|

    left := origin x.
    top := origin y.
    self fillRectangleX:left y:top width:(corner x - left) height:(corner y - top)

    "Created: 13.4.1996 / 20:58:16 / cg"
!

fillRectangleOrigin:origin extent:extent
    "draw a filled rectangle.
     Notice: the cornerPoint itself is NOT included"

    self fillRectangleX:(origin x) y:(origin y) width:(extent x) height:(extent y)
!

fillRoundRectangleX:left y:top width:width height:height wCorner:wCorn hCorner:hCorn
    |right bottom wC hC wHalf hHalf|

    right := left + width.
    bottom := top + height.

    wC := wCorn.
    hC := hCorn.

    wHalf := wC / 2.
    hHalf := hC / 2.

    self device isWindowsPlatform ifTrue:[
	"/ bug workaround
	"top left arc"
	self fillArcX:left y:top width:wC height:hC from:90 angle:90.
	"top right arc"
	self fillArcX:(right - wC - 1) y:top width:wC height:hC from:0 angle:90.
	"bottom right arc"
	self fillArcX:(right - wC - 1) y:(bottom - hC - 1) width:wC height:hC from:270 angle:90.
	"bottom left arc"
	self fillArcX:left y:(bottom - hC) width:wC height:hC-1 from:180 angle:90.

	"center rectangle"
	self fillRectangleX:(left + wHalf) y:top width:(width - wHalf - wHalf+1) height:height-1.
	"left partial rectangle"
	self fillRectangleX:left y:top+hHalf width:wHalf height:(height-hHalf-hHalf).
	"right partial rectangle"
	self fillRectangleX:right-wHalf y:top+hHalf width:wHalf-1 height:(height-hHalf-hHalf).
    ] ifFalse:[
	"top left arc"
	self fillArcX:left y:top width:wC height:hC from:90 angle:90.
	"top right arc"
	self fillArcX:(right - wC) y:top width:wC height:hC from:0 angle:90.
	"bottom right arc"
	self fillArcX:(right - wC - 1) y:(bottom - hC) width:wC height:hC from:270 angle:90.
	"bottom left arc"
	self fillArcX:left y:(bottom - hC) width:wC height:hC from:180 angle:90.

	"center rectangle"
	self fillRectangleX:(left + wHalf) y:top width:(width - wHalf - wHalf+1) height:height.
	"left partial rectangle"
	self fillRectangleX:left y:top+hHalf width:wHalf height:(height-hHalf-hHalf).
	"right partial rectangle"
	self fillRectangleX:right-wHalf y:top+hHalf width:wHalf height:(height-hHalf-hHalf).
    ].


    "
     |v|

     (v := View new) extent:200@200; openAndWait.
     v fillRoundRectangleX:10 y:10 width:100 height:100 wCorner:20 hCorner:20
    "
!

invertRectangle:aRectangle
    "invert a rectangle in the receiver"

    self xoring:[
	self fillRectangle:aRectangle
    ]
!

white
    "fill the receiver with white"

    self fill:self whiteColor
! !

!GraphicsMedium methodsFor:'initialization & release'!

close
    "same as destroy - for ST-80 compatibility"

    self destroy

    "Created: 2.4.1997 / 19:31:27 / cg"
!

destroy
    "destroy a medium - here the gc is completely destroyed"

    gc notNil ifTrue:[
        gc destroy.
    ].
    "keep device, maybe we want to re-open the view later"
"/    device := nil.
    realized := false.
!

initGC
    "since we do not need a gc-object for the drawable until something is
     really drawn, none is created.
     This method is sent, when the first drawing happens"

    ^ gc initGC
!

initialize
    super initialize.

    width := 0.
    height := 0.
    realized := false.
!

initializeForDevice:aDevice
    "allocate a GraphicsContext for a device"

    aDevice notNil ifTrue:[
        device := aDevice.
        gc := aDevice newGraphicsContextFor:self.
        gc font:self class defaultFont.
    ].

    self initialize.
!

recreate
    "reacreate a medium after snapIn"

    gc notNil ifTrue:[
	gc recreate.
    ].
!

releaseGC
    "destroy the associated device GC resource - can be done to be nice to the
     display if you know that you are done with a drawable."

    gc notNil ifTrue:[
        gc releaseGC.
    ].
! !

!GraphicsMedium methodsFor:'misc'!

clippedTo:aRectangle do:aBlock
    |oldClip|

    oldClip := gc deviceClippingBoundsOrNil.
    gc clippingBounds:aRectangle.

    aBlock
	ensure:[
	    gc deviceClippingBounds:oldClip
	]
!

flush
    "send all buffered drawing to the device."

    gc flush
!

setDevice:aDevice id:aDrawbleId gcId:aGCId
    "private"

    device := aDevice.
    gc notNil ifTrue:[
        gc setDevice:aDevice id:aDrawbleId gcId:aGCId
    ].
!

setPaint:fgColor on:bgColor
    "set the paint and background-paint color.
     The bg-paint is used in opaque-draw operations.
     Only set the variables, but do not send it to the device,
     Used on initialization."

    gc setPaint:fgColor on:bgColor
!

sync
    "send all buffered drawing to the device and wait until the device responds"

    gc sync
! !

!GraphicsMedium methodsFor:'printing & storing'!

storeOn:aStream
    "blocked: ascii storeString not possible (recursive - view - subviews - container)"

    self shouldNotImplement.
    "if proceeded from exception..."
    self printOn:aStream.
! !

!GraphicsMedium methodsFor:'queries'!

fontAscent
    "answer the ascent of the current font on the current device"

    ^ gc fontAscent
!

horizontalIntegerPixelPerMillimeter
    "return the (rounded) number of pixels per millimeter"

    ^ self horizontalPixelPerMillimeter asInteger
!

horizontalPixelPerInch
    "return the number of horizontal pixels per inch of the display"

    ^ self horizontalPixelPerMillimeter * 25.4
!

horizontalPixelPerMillimeter
    "return the number of pixels per millimeter (not rounded)"

    ^ gc horizontalPixelPerMillimeter
!

horizontalPixelPerMillimeter:millis
    "return the number of pixels (not rounded) for millis millimeter"

    ^ self horizontalPixelPerMillimeter * millis
!

resolution
    "return a point consisting of pixel-per-inch horizontally and vertically."

    ^ gc resolution
!

verticalIntegerPixelPerMillimeter
    "return the (rounded) number of pixels per millimeter"

    ^ self verticalPixelPerMillimeter rounded
!

verticalPixelPerInch
    "return the number of vertical pixels per inch of the display"

    ^ self verticalPixelPerMillimeter * 25.4
!

verticalPixelPerMillimeter
    "return the number of pixels per millimeter (not rounded)"

    ^ gc verticalPixelPerMillimeter
!

verticalPixelPerMillimeter:millis
    "return the number of pixels (not rounded) for millis millimeter"

    ^ self verticalPixelPerMillimeter * millis
! !

!GraphicsMedium methodsFor:'view creation'!

createBitmapFromArray:data width:width height:height
    "create a bitmap from data and set the drawableId"

    gc createBitmapFromArray:data width:width height:height
!

createPixmapWidth:w height:h depth:d
    "create a pixmap and set the drawableId"

    gc createPixmapWidth:w height:h depth:d
!

createRootWindow
    gc createRootWindowFor:self
!

createWindowFor:aView type:typeSymbol origin:org extent:ext minExtent:minE maxExtent:maxE borderWidth:bw subViewOf:sv style:styleSymbol inputOnly:inp label:label owner:owner icon:icn iconMask:icnM iconView:icnV
    "create a window and set the drawableId"

    gc createWindowFor:aView type:typeSymbol origin:org extent:ext minExtent:minE maxExtent:maxE borderWidth:bw subViewOf:sv style:styleSymbol inputOnly:inp label:label owner:owner icon:icn iconMask:icnM iconView:icnV
! !

!GraphicsMedium class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

