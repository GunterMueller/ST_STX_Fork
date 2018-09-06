"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

Object subclass:#GraphicsContext
	instanceVariableNames:'device paint bgPaint function font lineStyle lineWidth joinStyle
		capStyle mask maskOrigin transformation clipRect
		characterEncoding'
	classVariableNames:'White Black DefaultFont DrawingOnClosedDrawableSignal'
	poolDictionaries:''
	category:'Graphics-Support'
!

!GraphicsContext class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    this is an abstract superclass for all kinds of graphic drawables -
    both windows and printed pages (i.e. printers) are inheriting from
    this class (even drawables not at all associated with any device would do so).

    Drawing is done in paint/bgPaint colors, which can be true colors (i.e.
    directly supported by the underlying hardware) or simulated colors
    (i.e. dithered colors or images).
    The paint/bgPaint instance variables are set to the logical colors,
    device specific drawable may like to keep actual colors in addition.

    The transformation instance variable is typically nil, for a 1-to-1
    coordinate mapping (i.e. x/y coordinates are pixels in the drawable).
    If nonNil, the transformation must be an  instance of WindowingTransformation
    and offers both a scale-factor and a translation.
    Also, drawing in metric- or inch-units can be done using transformations.
    (see instance creation methods of WindowingTransformation, and examples
     in 'doc/coding').

    All drawing is defined upon a few basic drawing methods, which must be
    implemented by subclasses (some subclasses also redefine the others for
    more performance)

    [Instance variables:]

	paint           <Color>         the paint used for drawing
	bgPaint         <Color>         the background used for drawing texts and bitmaps
	function        <Symbol>        the drawing function (i.e. #copy, #or, #xor ...)
					- not all Drawables support every function
					(i.e. paper only allows #copy)
	font            <Font>          the current font to be used for drawing
	lineStyle       <Symbol>        the lineStyle (i.e. #solid, #dashed, #doubleDashed)
	lineWidth       <SmallInteger>  the lineWidth (device dependent, usually pixels)
	joinStyle       <Symbol>        the style in which lines (in polygons)
					are joined (i.e. #miter, #bevel, #round)
	capStyle        <Symbol>        the style in which the last point of a line is drawn
					(i.e. #notLast, #butt, #round, #projecting)
	mask            <Form>          a mask used for drawing
					- not all Drawables support it
	maskOrigin      <Point>         the origin of the mask relative to
					the drawables origin
	transformation
			<WindowingTransformation>
					controls scale & translation of nonNil

	clipRect        <Rectangle>     a clip rectangle (device dep. usually pixels or inches)
					or nil.

    [Class variables:[

	White           <Color>         cached white color - its needed so often
	Black           <Color>         cached black color - its needed so often

	DefaultFont     <Font>          default font to use

    [author:]
	Claus Gittinger

    [see also:]
	Color Font Form Image
	Geometric
	DeviceWorkstation
"
!

examples
"
    drawing uses a paint color (which may be a dithered one) which is
    used like a `pen'.
    A few drawing operations (opaqueForm and opaqueString drawing)
    use two colors, the paint and a backgroundPaint. For example,
    normal string drawing (#displayString:...) only draws the font's
    on-pixels in the current paint, leaving off-pixels unchanged.
    In contrast, #drawOpaqueString:.. also changes these to the bgPaint color.
    The bgPaint can be changed with #backgroundPaint: or #paint:on: (which modifies both).

    lets try it in a view:
									[exBegin]
	|v|

	v := View new.
	v openAndWait.

	v paint:(Color red).
	v displayString:'hello' x:10 y:50
									[exEnd]

    the same using opaque drawing:
									[exBegin]
	|v|

	v := View new.
	v openAndWait.

	v paint:(Color red) on:(Color yellow).
	v displayOpaqueString:'hello' x:10 y:50
									[exEnd]



    Lines are drawn using the paint color (if solid) or both paint and bgPaint
    (dashed lines). The look of the line is controlled by joinStyle, capStyle,
    lineWidth and lineStyle.
    `lineStyle' can be one of #solid, #dashed, #doubleDashed
    where: #solid        - is for solid lines, drawn with the current paint color

	   #dashed       - for dashed lines, where only the on-dashes are drawn
			   with the current paint color

	   #doubleDashed - dashed lines, draws on-dashes with paint color,
			   off-dashes with bgPaint

    for example:
									[exBegin]
	|v|

	v := View new.
	v openAndWait.

	v paint:(Color red) on:(Color blue).
	v displayLineFrom:(10@10) to:(90@90).

	v lineStyle:#dashed.
	v displayLineFrom:(90@10) to:(10@90).

	v lineStyle:#doubleDashed.
	v displayRectangle:((5@5) corner:(95@95)).
									[exEnd]

    changing the line-width:
									[exBegin]
	|v|

	v := View new.
	v openAndWait.

	v paint:(Color red).
	v displayLineFrom:(20@20) to:(80@80).

	v lineWidth:5.
	v displayLineFrom:(80@20) to:(20@80).

	v lineWidth:8.
	v displayRectangle:((5@5) corner:(95@95)).
									[exEnd]

    with wide lines, the corners (of polygons or rectangles) can be
    one of the joinStyles: #miter, #bevel, #round. The default is #miter.
									[exBegin]
	|v|

	v := View new extent:200@200.
	v openAndWait.

	v lineWidth:15.
	v paint:(Color red).

	v displayRectangle:((65@65) corner:(135@135)).

	v joinStyle:#bevel.
	v displayRectangle:((45@45) corner:(155@155)).

	v joinStyle:#round.
	v displayRectangle:((25@25) corner:(175@175)).
									[exEnd]


    the endPoints look is controlled with capStyle;
    possible values are: #notLast, #butt, #round, #projecting.
    The default is #butt.
    #notLast is mostly useful when exoring (inverting): it will not draw the
    endPoint, to allow another line to join the previous line without inverting
    this point twice. (See the X manual for more info).
									[exBegin]
	|v|

	v := View new extent:200@200.
	v openAndWait.

	v lineWidth:15.
	v paint:(Color red).

	v displayLineFrom:(25@25) to:(175@25).

	v capStyle:#round.
	v displayLineFrom:(25@55) to:(175@55).

	v capStyle:#projecting.
	v displayLineFrom:(25@85) to:(175@85).
									[exEnd]


    You can use a bitmap as a point color:
    (this may be slow on some graphics devices, though)
									[exBegin]
	|v|

	v := View new extent:200@200.
	v openAndWait.

	v lineWidth:15.
	v paint:(Image fromFile:'granite_small.tiff').

	v displayLineFrom:(25@25) to:(175@25).

	v capStyle:#round.
	v displayLineFrom:(25@55) to:(175@55).

	v capStyle:#projecting.
	v displayLineFrom:(25@85) to:(175@85).
									[exEnd]

    all views support a translation and scale, so you can draw in another
    coordinate system:
									[exBegin]
	|v|

	v := View new extent:200@200.
	v openAndWait.

	v displayForm:(Image fromFile:'SBrowser.xbm') x:10 y:10.

	v scale:(2@2); translation:50.
	v displayForm:(Image fromFile:'SBrowser.xbm') x:10 y:10.

	v scale:(0.5@0.5); translation:0.
	v displayForm:(Image fromFile:'SBrowser.xbm') x:10 y:10.
									[exEnd]

    if scaling is on, it is often useful to be able to draw individual
    things unscaled - this still translates the position, but
    uses the unscaled font (for example, to draw strings in a graphic):
									[exBegin]
	|v|

	v := View new extent:200@200.
	v openAndWait.

	v displayForm:(Image fromFile:'SBrowser.xbm') x:10 y:10.
	v displayString:'hello' x:50 y:40.

	v scale:(2@4).
	v displayForm:(Image fromFile:'SBrowser.xbm') x:10 y:10.
	v displayUnscaledString:'hello' x:50 y:40.
									[exEnd]

    Filled objects are drawin using the #fillXXX methods; for example,
    displayRectangleXXX draws the outline, while fillRectangleXXX draws a
    filled one:
									[exBegin]
	|v|

	v := View new extent:200@200.
	v openAndWait.

	v displayArcIn:(20@20 corner:50@50) from:0 angle:180.
	v paint:Color yellow.
	v fillArcIn:(120@120 corner:150@150) from:0 angle:180.

	v paint:Color red.
	v displayCircle:150@50 radius:30.
	v paint:Color blue.
	v fillCircle:50@150 radius:30.
									[exEnd]

    polygons:
									[exBegin]
	|v poly1 poly2|

	poly1 := OrderedCollection new.
	poly1 add:(10 @ 10).
	poly1 add:(100 @ 50).
	poly1 add:(50 @ 50).
	poly1 add:(20 @ 100).
	poly1 add:(10 @ 100).

	poly2 := poly1 copy.
	poly2 add:(poly2 first).

	v := View new extent:200@200.
	v openAndWait.

	v scale:2.
	v paint:Color red.
	v fillPolygon:poly1.

	v scale:1.
	v paint:Color blue.
	v displayPolygon:poly2.

	v scale:0.5.
	v paint:Color yellow.
	v fillPolygon:poly1.

									[exEnd]
"
! !

!GraphicsContext class methodsFor:'initialization'!

initialize
    "setup some defaults - these are usually redefined
     during startup."

    DrawingOnClosedDrawableSignal isNil ifTrue:[
	DrawingOnClosedDrawableSignal := Signal new mayProceed:true.
	DrawingOnClosedDrawableSignal nameClass:self message:#drawingOnClosedDrawableSignal.
	DrawingOnClosedDrawableSignal notifierString:'drawing attempt on closed drawable'.
    ].

    White isNil ifTrue:[
	Color initialize.

	Display notNil ifTrue:[
	    White := Display whiteColor.
	    Black := Display blackColor.
	] ifFalse:[
	    White := Color white.
	    Black := Color black.
	].

	Font initialize.
	DefaultFont := Font family:'courier' face:'medium' style:'roman' size:12.
	Display notNil ifTrue:[
	    DefaultFont := DefaultFont onDevice:Display
	]
    ]

    "Modified: / 29.1.1998 / 12:56:18 / cg"
! !

!GraphicsContext class methodsFor:'instance creation'!

new
    "return a new instance of myself. Redefined to initialize
     the new thingy"

    ^ self basicNew initialize
! !

!GraphicsContext class methodsFor:'Signal constants'!

drawingOnClosedDrawableSignal
    "return the signal which is raised, if drawing is attempted
     on a closed drawable.
     This is especially useful, if a forked thread animates
     a view in the background, and is not properly synchronized
     with the window thread - i.e. the window gets closed by the user,
     and the background process continues to draw.
     In this case, the background thread should handle this signal
     and terminate itself in the handler."

    ^ DrawingOnClosedDrawableSignal

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

!GraphicsContext class methodsFor:'accessing-defaults'!

defaultFont
    "get the default font used for drawing"

    DefaultFont isNil ifTrue:[
	DefaultFont := Font family:'courier' face:'medium' style:'roman' size:12
    ].
    ^ DefaultFont
!

defaultFont:aFont
    "set the default font used for drawing"

    DefaultFont := aFont
! !

!GraphicsContext class methodsFor:'constants'!

capButt
    "return a constant to specify butt cap"

    ^ #butt
!

capNotLast
    "return a constant to specify not-last cap"

    ^ #notLast
!

capProjecting
    "return a constant to specify projecting cap"

    ^ #projecting
!

capRound
    "return a constant to specify round cap"

    ^ #round
!

joinBevel
    "return a constant to specify bevel join"

    ^ #bevel
!

joinMiter
    "return a constant to specify miter join"

    ^ #miter
!

joinRound
    "return a constant to specify round join"

    ^ #round
! !

!GraphicsContext methodsFor:'Compatibility-ST80'!

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

    ^ aFontDescription onDevice:device

    "Modified: 28.5.1996 / 20:22:29 / cg"
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
     drawn on the receiver's device."

    ^ (font onDevice:device) widthOf:aString

    "Modified: 28.5.1996 / 20:22:22 / cg"
!

widthOfString:aString from:start to:stop
    "given a string, return the width in pixels if
     a substring is drawn on the receiver's device."

    ^ (font onDevice:device) widthOf:aString from:start to:stop

    "Modified: 28.5.1996 / 20:22:18 / cg"
! !

!GraphicsContext methodsFor:'Compatibility-Squeak'!

fill:aRectangle fillColor:aColor
    "fill a rectangle with the given color color"

    |savedPaint|

    savedPaint := paint.
    self paint:aColor.
    self fillRectangle:aRectangle.
    self paint:savedPaint
!

fillRectangle:aRectangle color:aColor
    "fill a rectangle with the given paint color"

    |oldPaint|

    oldPaint := paint.
    self paint:aColor.
    self fillRectangle:aRectangle.
    self paint:oldPaint.
! !

!GraphicsContext methodsFor:'accessing'!

backgroundPaint
    "return the background paint color.
     (used for opaqueForms and opaqueStrings)"

    ^ bgPaint
!

backgroundPaint:aColor
    "set the background painting color (which is used for
     opaqueForms and opaqueStrings). aColor can be a dithered one."

    bgPaint := aColor

    "Modified: 12.5.1996 / 22:25:17 / cg"
!

basicFont
    "return the font for drawing"

    ^ font

    "Created: 12.5.1996 / 11:17:59 / cg"
!

blackColor
    "return the black color on this device.
     This is the same as 'Color black onDevice:self device', but much faster."

    ^ device blackColor
!

capStyle
    "return the current cap-style for line-drawing.
     possible styles are: #notLast, #butt, #round, #projecting"

    ^ capStyle
!

capStyle:aStyleSymbol
    "set the cap-style for line-drawing;
     possible styles are: #notLast, #butt, #round, #projecting"

    aStyleSymbol isNil ifTrue:[
	capStyle := #butt
    ] ifFalse:[
	capStyle := aStyleSymbol
    ]

    "Modified: 12.5.1996 / 22:24:30 / cg"
!

characterEncoding
    "returns a symbol describing how the contents is encoded internally.
     This is now obsolete, as we are always using unicode internally.
     (encoding is something like #'iso8859-5' #euc, #sjis, #jis7, #gb, #big5 or #ksc)"

    ^ characterEncoding
!

characterEncoding:encodingArg
    "define how the contents is encoded internally.
     This should normally never be required, as ST/X now assumes
     unicode (of which iso8859-1 is a subset) encoding.
     The possibility to change the characterEncoding is provided as
     a backward compatibility hook for programs which want to use
     another encoding internally.
     One such view is the CharacterSetView,
     which wants to show character as they are actually present in a font."

    |encodingSymOrNil|

    encodingSymOrNil := encodingArg isNil
			    ifTrue:[#'iso10646-1' "unicode"]
			    ifFalse:[encodingArg asSymbol].
    characterEncoding ~~ encodingSymOrNil ifTrue:[
	characterEncoding := encodingSymOrNil.
    ].

    "Modified (comment): / 25-01-2012 / 00:29:37 / cg"
!

clippingBounds
    "return the clip-rectangle for drawing (in logical coordinates).
     If there is currently no active clip, return the underlying
     medium (i.e. device) bounds. Added for ST-80 compatibility."

    |rect|

    clipRect isNil ifTrue:[
	rect := 0@0 extent:(self medium extent).
	transformation notNil ifTrue:[
	    rect := transformation applyInverseTo:rect.
	].
	^ rect
    ].
    transformation notNil ifTrue:[
	^ transformation applyInverseTo:clipRect.
    ].
    ^ clipRect

    "Modified: 28.5.1996 / 14:05:15 / cg"
!

clippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in logical coordinates);
     a nil argument turn off clipping (i.e. whole view is drawable)"

    (aRectangleOrNil notNil and:[transformation notNil]) ifTrue:[
	clipRect := transformation applyTo:aRectangleOrNil.
    ] ifFalse:[
	clipRect := aRectangleOrNil
    ].

    "Modified: 22.5.1996 / 13:12:07 / cg"
    "Created: 28.5.1996 / 14:09:27 / cg"
!

clippingBoundsOrNil
    "return the clipping bounds (a Rectangle) for drawing in logical coordinates, nil if there is none."

    clipRect isNil ifTrue:[
	^ nil
    ].
    transformation notNil ifTrue:[
	^ transformation applyInverseTo:clipRect.
    ].
    ^ clipRect

    "Created: 10.4.1996 / 14:32:02 / cg"
    "Modified: 28.5.1996 / 14:08:19 / cg"
!

dashStyle:aDashList offset:dashOffset
    "define dashes. Each element of the dashList specifies the length
     of a corresponding dash. For example, setting it to [4 4]
     defines 4on-4off dashing;
     Setting it to [1 2 4 2] defines 1on-2off-4on-2off dashes.
     The dashOffset specifies where in the dashList the dashing starts.
     Ignored here - this may not be supported by all graphics devices."

    ^ self

    "Created: 4.6.1996 / 18:59:34 / cg"
    "Modified: 4.6.1996 / 19:03:38 / cg"
!

font
    "return the current drawing font"

    ^ font
!

font:aFont
    "set the drawing font"

    ^ self subclassResponsibility
!

function
    "return the current drawing function"

    ^ function
!

function:aFunctionSymbol
    "set the drawing function"

    ^ self subclassResponsibility
!

graphicsContext
    "for ST-80 compatibility"

    ^ self
!

graphicsDevice
    "same as #device, for ST-80 compatibility"

    ^ device
!

joinStyle
    "return the current join-style for polygon-drawing.
     possible styles are: #miter, #bevel, #round"

    ^ joinStyle
!

joinStyle:aStyleSymbol
    "set the join-style of lines in polygon-drawing;
     possible styles are: #miter, #bevel, #round"

    aStyleSymbol isNil ifTrue:[
	joinStyle := #miter
    ] ifFalse:[
	joinStyle := aStyleSymbol
    ]

    "Modified: 12.5.1996 / 22:24:14 / cg"
!

lineStyle
    "return the current line-drawing-style.
     possible styles are: #solid, #dashed, #doubleDashed,
     #dotted, #dashDot or #dashDotDot."

    ^ lineStyle
!

lineStyle:aStyleSymbol
    "set the line-drawing-style;
     possible styles are: #solid, #dashed, #doubleDashed,
     #dotted, #dashDot or #dashDotDot."

    aStyleSymbol isNil ifTrue:[
	lineStyle := #solid
    ] ifFalse:[
	lineStyle := aStyleSymbol
    ]

    "Modified: 12.5.1996 / 22:19:25 / cg"
!

lineWidth
    "return the current drawing linewidth"

    ^ lineWidth
!

lineWidth:aNumber
    "set the line drawing width in pixels"

    lineWidth := aNumber
!

mask
    "return the current drawing mask"

    ^ mask
!

mask:aForm
    "set the drawing mask"

    ^ self subclassResponsibility
!

maskOrigin
    "return the origin within the mask (used to draw with patterns).
     Should be redefined in classes which support it.
     This is an alias for ST-80's #phase"

    ^ maskOrigin
!

maskOrigin:aPoint
    "set the origin within the mask (used to draw with patterns).
     Should be redefined in classes which support it.
     This is an alias for ST-80's #phase:"

    maskOrigin := aPoint.
    ^ self

    "Modified: / 26.1.1998 / 18:59:18 / cg"
!

maskOriginX:x y:y
    "set the origin within the mask (used to draw with patterns).
     Should be redefined in classes which support it.
     This is an alias for ST-80's #phase:"

    ^ self maskOrigin:(x @ y)

    "Modified: / 26.1.1998 / 18:59:56 / cg"
!

medium
    "return the destination medium i.e. the underlying graphics device"

    ^ device

    "Modified: 28.5.1996 / 14:26:03 / cg"
!

paint
    "return the current paint drawing color"

    ^ paint
!

paint:aColor
    "set the drawing painting color, aColor can be a dithered one"

    paint := aColor
!

paint:fgColor on:bgColor
    "set the paint and backgroundPaint, used for text and bitmaps.
     Both colors may be dithered colors"

    fgColor ~~ paint ifTrue:[
	self paint:fgColor.
    ].
    bgPaint := bgColor

    "Modified: 12.5.1996 / 19:40:43 / cg"
!

setDevice:aDevice
    device := aDevice
!

viewOrigin
    "return the drawables visible origin (for scrolling)"

    ^ 0@0
!

whiteColor
    "return the white color on this device.
     This is the same as 'Color white onDevice:self device', but much faster."

    ^ device whiteColor
! !

!GraphicsContext methodsFor:'accessing-transformation'!

scale
    "return the scale factor (as point) of the transformation"

    transformation isNil ifTrue:[^ 1@1].
    ^ transformation scale

    "Modified: 21.5.1996 / 21:16:47 / cg"
!

scale:aPoint
    "set the scale factor of the transformation"

    transformation isNil ifTrue:[
	aPoint = 1 ifTrue:[^ self].
	transformation := WindowingTransformation scale:aPoint translation:0
    ] ifFalse:[
	transformation scale:aPoint.
    ]

    "Modified: 27.4.1996 / 18:47:38 / cg"
!

scale:scale translation:aPoint
    transformation isNil ifTrue:[
        (aPoint = 0 and:[scale = 1]) ifTrue:[^ self].
        transformation := WindowingTransformation scale:scale translation:aPoint
    ] ifFalse:[
        transformation scale:scale translation:aPoint.
    ]
!

transformation
    "return the transformation"

    ^ transformation
!

transformation:aTransformation
    "set the transformation"

    transformation := aTransformation
!

translateBy:aPoint
    "add to the translation offset of the transformation"

    transformation isNil ifTrue:[
	aPoint = 0 ifTrue:[^ self].
	transformation := WindowingTransformation scale:1 translation:aPoint
    ] ifFalse:[
	transformation translateBy:aPoint
    ]

    "Created: 10.2.1997 / 13:50:22 / cg"
!

translation
    "return the translation factor (as point) of the transformation"

    transformation isNil ifTrue:[^ 0@0].
    ^ transformation translation

    "Created: 27.4.1996 / 18:46:41 / cg"
!

translation:aPoint
    "set the translation offset of the transformation"

    transformation isNil ifTrue:[
	aPoint = 0 ifTrue:[^ self].
	transformation := WindowingTransformation scale:1 translation:aPoint
    ] ifFalse:[
	transformation translation:aPoint.
    ]

    "Created: 27.4.1996 / 18:47:28 / cg"
! !

!GraphicsContext methodsFor:'basic drawing'!

displayArcX:x y:y width:width height:height from:startAngle angle:angle
    "draw an arc in a box
     - this could be recoded to draw using displayLine"

    ^ self subclassResponsibility

    "Created: 8.5.1996 / 08:47:06 / cg"
!

displayDottedRectangleX:x y:y width:w height:h
    "draw a dotted-line rectangle
     A general implementation is found here; deviceGC's
     may reimplement this if directly supported by the device"

    |lastX lastY x0 y0 oldStyle|

    (false "(device platformName ~= 'WIN32')"
    or:[OperatingSystem isMSWINDOWSNTlike]) ifTrue:[
	oldStyle := lineStyle.
	self lineStyle:#dotted.
	self displayRectangleX:x y:y width:w height:h.
	self lineStyle:oldStyle.
	^ self.
    ].

    1 to:w-1 by:2 do:[:o |
	lastX := x + o.
	self displayPointX:lastX y:y.
    ].
    y0 := 1.
    lastX == (x+w-1) ifTrue:[
	y0 := 0
    ].
    y0 to:h-1 by:2 do:[:o |
	lastY := y+o.
	self displayPointX:x+w-1 y:lastY.
    ].
    x0 := w-2.
    lastY == (y+h-1) ifTrue:[
	x0:= w-1
    ].
    x0 to:0 by:-2 do:[:o |
	lastX := x+o.
	self displayPointX:lastX y:y+h-1.
    ].
    y0 := h-1.
    lastX == 0 ifTrue:[
	y0 := h-1
    ].
    y0 to:0 by:-2 do:[:o |
	self displayPointX:x y:y+o.
    ].

    "Modified: / 6.11.2001 / 08:48:18 / cg"
!

displayHorizontalWavelineFromX:x0 y:y0 toX:x1
    "draw a horizontal wave-line from x0/y0 to x1/y0"

    |w h pattern form x oldClip|

"/    pattern := #[
"/                 2r00000000 2r00111100
"/                 2r00000000 2r11000011
"/                 2r11000011 2r00000000
"/                 2r00111100 2r00000000
"/                ].
"/    h := 4.
"/    w := 16.

"/    pattern := #[
"/                 2r00000000 2r01111000
"/                 2r00000000 2r10000100
"/                 2r10000001 2r00000000
"/                 2r01000010 2r00000000
"/                 2r00111100 2r00000000
"/                ].
"/    h := 5.
"/    w := 14.

"/    pattern := #[
"/                 2r00000001 2r11100000
"/                 2r00000010 2r00010000
"/                 2r10000100 2r00000000
"/                 2r01111000 2r00000000
"/                ].
"/    h := 4.
"/    w := 12.
"/
"/    pattern := #[
"/                 2r00000011
"/                 2r11001100
"/                 2r00110000
"/                ].
"/    h := 3.
"/    w := 8.

    pattern := #[
                 2r11001100 2r11001100 2r11001100 2r11001100
                 2r00110011 2r00110011 2r00110011 2r00110011
                ].
    h := 2.
    w := 32.

"/    pattern := #[
"/                 2r11000000
"/                 2r00110000
"/                ].
"/    h := 2.
"/    w := 4.

    form := Form width:w height:h fromArray:pattern.

    oldClip := self clippingBoundsOrNil.
    self clippingBounds:((x0 @ y0) corner:(x1 @ (y0+h))).

    x := x0 truncateTo:w.
    [x <= x1] whileTrue:[
        self displayForm:form x:x y:y0.
        x := x + w.
    ].
    self clippingBounds:oldClip

    "Created: / 28-10-1998 / 15:31:41 / cg"
    "Modified: / 24-07-2011 / 21:12:24 / cg"
!

displayLineFromX:x0 y:y0 toX:x1 y:y1
    "draw a line from x0/y0 to x1/y1"

    ^ self subclassResponsibility

    "Created: 28.5.1996 / 17:12:37 / cg"
!

displayOpaqueForm:aForm x:x y:y
    "draw a form at x/y; if the form has depth 1, 1's in the form are
     drawn in current fg, 0's in current bg color.
     If the form has depth ~~ 1, it is copied as is onto the receiver"

    ^ self subclassResponsibility
!

displayOpaqueString:aString from:index1 to:index2 x:x y:y
    "draw part of a string with both fg and bg at x/y in current font"

    ^ self subclassResponsibility
!

displayOpaqueString:aString from:index1 to:index2 x:x y:y maxWitdh:maxWidth
    "draw part of a string with both fg and bg at x/y in current font"

    ^ self subclassResponsibility
!

displayPolygon:aPolygon
    "draw a polygon
     - this could be recoded to draw using displayLine"

    ^ self subclassResponsibility
!

displayRectangleX:x y:y width:w height:h
    "draw a rectangle
     - this could be recoded to draw using displayLine"

    ^ self subclassResponsibility
!

displayString:aString from:index1 to:index2 x:x y:y
    "draw part of a string with fg at x/y in current font"

    ^ self subclassResponsibility
!

displayString:aString from:index1 to:index2 x:x y:y opaque:opaque
    "draw part of a string with both fg and bg at x/y in current font"

    opaque ifTrue:[
	self displayOpaqueString:aString from:index1 to:index2 x:x y:y
    ] ifFalse:[
	self displayString:aString from:index1 to:index2 x:x y:y
    ].
! !

!GraphicsContext methodsFor:'basic filling'!

fillArcX:x y:y width:w height:h from:start angle:angle
    "fill an arc with current paint color"

    ^ self subclassResponsibility

    "Created: 8.5.1996 / 08:47:44 / cg"
!

fillPolygon:points
    "fill a polygon with current paint color"

    ^ self subclassResponsibility
!

fillRectangleX:x y:y width:w height:h
    "fill a rectangle with current paint color"

    ^ self subclassResponsibility
!

fillRectangleX:x y:y width:w height:h color:aColor
    "fill a rectangle with given color"

    |oldPaint|

    oldPaint := paint.
    self paint:aColor.
    self fillRectangleX:x y:y width:w height:h.
    self paint:oldPaint.
! !

!GraphicsContext methodsFor:'drawing'!

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

    "Modified: 8.5.1996 / 08:35:00 / cg"
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

displayCircle:aPoint radius:r
    "draw a circle around a center point"

    self displayCircleX:(aPoint x) y:(aPoint y) radius:r
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

    self displayForm:aFormOrImage x:0 y:0

    "Modified: / 24.4.1997 / 16:00:11 / cg"
    "Created: / 9.11.1997 / 00:50:52 / cg"
!

displayForm:aFormOrImage at:aPoint
    "draw a form (or image)"

    self displayForm:aFormOrImage x:(aPoint x) y:(aPoint y)

    "Modified: 24.4.1997 / 16:00:11 / cg"
!

displayForm:aFormOrImage x:x y:y
    "draw a form (or image) at x/y;
     if the form has depth 1, 1's in the form are
     drawn in current paint color, 0's are ignored.
     If the form has depth ~~ 1, the current fg color setting is ignored."

    |fg bg f noColor|

    aFormOrImage depth > 1 ifTrue:[
	self displayOpaqueForm:aFormOrImage x:x y:y.
	^ self.
    ].
"/    aFormOrImage mask notNil ifTrue:[
"/self halt.
"/    ].

    fg := paint.
    bg := bgPaint.
    f := function.

    f ~~ #copy ifTrue:[
	self error:'function not supported'.
	^ self
    ].

    noColor := Color noColor.

    "
     stamp out fg-pixels
    "
    self paint:noColor on:Color allColor function:#and.
    self displayOpaqueForm:aFormOrImage x:x y:y.

    "
     or-in fg-pixels
    "
    self paint:fg on:Color noColor function:#or.
    self displayOpaqueForm:aFormOrImage x:x y:y.
    self paint:fg on:fg function:f.

    "Modified: 24.4.1997 / 16:01:43 / cg"
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

    self displayForm:aFormOrImage x:0 y:0
!

displayImage:aFormOrImage at:aPoint
    "draw an image (or form).
     Provided for ST-80 compatibilty;
     in ST/X, images are also handled by #displayForm:"

    self displayForm:aFormOrImage x:(aPoint x) y:(aPoint y)

    "Modified: 24.4.1997 / 16:02:43 / cg"
!

displayImage:aFormOrImage x:x y:y
    "draw an image (or form).
     Provided for ST-80 compatibilty;
     in ST/X, images are also handled by #displayForm:"

    self displayForm:aFormOrImage x:x y:y

    "Created: 24.4.1997 / 16:03:03 / cg"
!

displayLineFrom:point1 to:point2
    "draw a line"

    self displayLineFromX:(point1 x) y:(point1 y)
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
		     onDevice:device.
    tempForm isNil ifTrue:[^nil].
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

displayOpaqueString:aString from:start to:stop at:aPoint
    "draw part of a string - drawing both fg and bg"

    ^ self displayOpaqueString:aString from:start to:stop x:aPoint x y:aPoint y
!

displayOpaqueString:aString x:x y:y
    "draw a string with both fg and bg"

    self displayOpaqueString:aString from:1 to:(aString size) x:x y:y
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

    self
	displayString:aString x:x y:y angle:drawAngle opaque:true

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

    self displayPointX:(aPoint x) y:(aPoint y)
!

displayPointX:x y:y
    "draw a point at x/y"

    self displayLineFromX:x y:y toX:x y:y
!

displayRectangle:aRectangle
    "draw a rectangle"

    self displayRectangleX:(aRectangle left)
			 y:(aRectangle top)
		     width:(aRectangle width)
		    height:(aRectangle height)
!

displayRectangleOrigin:origin corner:corner
    "draw a rectangle"

    |top left|

    left := origin x.
    top := origin y.
    self displayRectangleX:left y:top width:(corner x - left) height:(corner y - top)

    "Modified: 13.4.1996 / 20:58:31 / cg"
!

displayRectangleOrigin:origin extent:extent
    "draw a rectangle"

    self displayRectangleX:(origin x) y:(origin y)
		     width:(extent x)
		    height:(extent y)

    "Modified: 13.4.1996 / 20:58:31 / cg"
!

displayRoundRectangleX:left y:top width:width height:height wCorner:wCorn hCorner:hCorn
    |right bottom wC hC wHalf hHalf isWin32|

    "/ BIG KLUDGE WARNING HERE: the code below looks "good" on windows displays;
    "/ (if you change anything under Unix, make it X-platform specific.
    "/ (there seem to be drawing incompatibilities between Win- and XWorkstation)

    isWin32 := device isWindowsPlatform.

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
    "draw a string - drawing fg only"

    self displayString:aString from:1 to:(aString size) x:x y:y
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

    |angle tempForm tempImage w h ascent descent a xN yN p r
     dX dY sin cos m|

    angle := drawAngle.
    angle >= 360 ifTrue:[
        angle := angle - (((angle // 360)) * 360)
    ] ifFalse:[
        angle < 0 ifTrue:[
            angle := angle - (((angle // 360)) * 360).
            angle := angle + 360.
            angle >= 360 ifTrue:[
                angle := angle - (((angle // 360)) * 360)
            ]
        ].
    ].

    angle = 0 ifTrue:[
        opaque ifTrue:[
            ^ self displayOpaqueString:aString x:x y:y
        ].
        ^ self displayString:aString x:x y:y
    ].

    font := font onDevice:device.
    ascent := font ascent.

    (aString isString and:[font isAntialiasedFont not]) ifTrue:[
        "/ a real string;
        "/ do it in a monochrome form (for speed)

        w := font widthOf:aString.
        h := font height.
        descent := h - ascent.

        tempForm := Form width:w height:h depth:1 onDevice:device.
        tempForm isNil ifTrue:[^ self].
        tempForm paint:(Color colorId:1) on:(Color colorId:0).
        tempForm clear.
        tempForm font:font.
        tempForm displayString:aString x:0 y:ascent.
    ] ifFalse:[
        "/ something weird (labelAndIcon ..)
        "/ do it in a deep form.
        "/ CAVEAT: this can only be done opaque ...

        w := aString widthOn:self.
        h := aString heightOn:self.
        descent := 0.
"/        ascent := font ascent max:(h // 2).
"/        descent := (h - font ascent) max:(h // 2).

        tempForm := Form width:w height:h depth:(device depth) onDevice:device.
        tempForm isNil ifTrue:[^ self].
        tempForm paint:bgPaint.
        tempForm fillRectangleX:0 y:0 width:w height:h.
        tempForm paint:paint on:bgPaint.
        tempForm font:font.
        aString displayOn:tempForm x:0 y:ascent opaque:true.
    ].
    tempImage := tempForm asImage rotated:angle.

    opaque ifTrue:[
        m := ImageMask width:w height:h.
        m bits:(ByteArray new:(h * m bytesPerRow) withAll:16rFF).
        m := m rotated:angle
    ].

    "/ compute final position of rotated form
    "/ adjust position for baseline.
    angle = 90 ifTrue:[
        xN := x - descent.
        yN := y.
    ] ifFalse:[
        angle = 180 ifTrue:[
            xN := x - w.
            yN := y - descent "+ h - ascent".
        ] ifFalse:[
            angle = 270 ifTrue:[
                xN := x - ascent.
                yN := y - w.
            ] ifFalse:[
                "/ sigh: since the new image has different dimensions,
                "/ the computation is somewhat more difficult here.
                "/ remember: the image has been rotated around its center,
                "/ then shifted towards the top-left origin.
                p := (w@h) / 2.
                r := p r.
                a := p theta.
                sin := angle degreesToRadians sin.
                cos := angle degreesToRadians cos.

                angle < 90 ifTrue:[
                    dX := descent * sin.
                    dY := ascent * cos.
                    xN := x - dX.
                    yN := y - dY.
                ] ifFalse:[
                    angle < 180 ifTrue:[
                        dX := ascent * sin.
                        dY := descent * cos.
                        xN := x + dX - (tempImage width).
                        yN := y + dY.
                    ] ifFalse:[
                        angle < 270 ifTrue:[
                            dX := descent * sin.
                            dY := ascent * cos.
                            xN := x - dX - (tempImage width).
                            yN := y - dY - (tempImage height)
                        ] ifFalse:[
                            dX := ascent * sin.
                            dY := descent * cos.
                            xN := x + dX.
                            yN := y + dY - (tempImage height).
                        ]
                    ]
                ].
                tempImage mask:nil.
            ]
        ].
    ].

    opaque ifTrue:[
        p := paint.
        self paint:bgPaint.
        self displayForm:m x:xN y:yN.
        self paint:p.
    ].
    self displayForm:tempImage x:xN y:yN.

    "Modified: / 29.1.1998 / 13:23:23 / cg"
! !

!GraphicsContext methodsFor:'drawing in device coordinates'!

displayDeviceLineFromX:x1 y:y1 toX:x2 y:y2
    "draw a line in device coordinates"

    |sav|

    sav := transformation.
    transformation := nil.
    self displayLineFromX:x1 y:y1 toX:x2 y:y2.
    transformation := sav
!

displayDeviceRectangleX:x y:y width:w height:h
    "draw a rectangle in device coordinates"

    |sav|

    sav := transformation.
    transformation := nil.
    self displayRectangleX:x y:y width:w height:h.
    transformation := sav
!

fillDeviceRectangleX:x y:y width:w height:h
    "fill a rectangle with current paint color (device coordinates)"

    |sav|

    sav := transformation.
    transformation := nil.
    self fillRectangleX:x y:y width:w height:h.
    transformation := sav
! !

!GraphicsContext methodsFor:'edge drawing'!

drawEdgesForX:x y:y width:w height:h level:l
    "draw 3D edges into a rectangle"
    self
	drawEdgesForX:x y:y width:w height:h level:l
	shadow:self blackColor light:self whiteColor
	halfShadow:nil halfLight:nil
	style:nil
!

drawEdgesForX:x y:y width:w height:h level:lvl
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

    count := lvl.
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
	(lvl > 1) ifTrue:[
	    edgeStyle == #softWin95 ifTrue:[
		self paint:(Color veryLightGray).
	    ] ifFalse:[
		(lvl > 2 and:[edgeStyle == #soft]) ifTrue:[
		    self paint:(device blackColor).
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
    and:[lvl > 1]) ifTrue:[
	self paint:(device blackColor) "shadowColor".
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

!GraphicsContext methodsFor:'filling'!

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

    device isWindowsPlatform ifTrue:[
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
! !

!GraphicsContext methodsFor:'initialization'!

initialize
    "set up some useful default values"

    paint isNil ifTrue:[paint := Black].
    bgPaint isNil ifTrue:[bgPaint := White].
    function := #copy.
    lineWidth := 1.
    lineStyle := #solid.
    joinStyle := #miter.
    capStyle := #butt.
    font := self class defaultFont.

    "/ this is rubbish. we are now always using unicode internaly
    characterEncoding := #'iso10646-1'. "/ aka unicode
! !

!GraphicsContext methodsFor:'misc'!

clippedTo:aRectangle do:aBlock
    |oldClip|

    oldClip := clipRect.
    self clippingBounds:aRectangle.
    aBlock ensure:[
        self clippingBounds:oldClip
    ].
!

flush
    "send all buffered drawing to the device."

    device flush

    "Modified: 28.5.1996 / 20:22:26 / cg"
!

sync
    "send all buffered drawing to the device and wait until the device responds"

    device sync
! !

!GraphicsContext methodsFor:'printing & storing'!

storeOn:aStream
    "blocked: ascii storeString not possible (recursive - view - subviews - container)"

    self shouldNotImplement.
    "if proceeded from exception..."
    self printOn:aStream.
! !

!GraphicsContext methodsFor:'queries'!

fontAscent
    "answer the ascent of the current font on the current device"

    ^ font ascentOn:device
! !

!GraphicsContext class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


GraphicsContext initialize!
