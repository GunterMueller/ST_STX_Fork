"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2015-2017 Jan Vrany
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

GraphicsContext subclass:#DeviceGraphicsContext
	instanceVariableNames:'drawableId gcId deviceFont foreground background drawableType
		parentId'
	classVariableNames:'CachedScaledForms CachedScales'
	poolDictionaries:''
	category:'Graphics-Support'
!

DeviceHandle subclass:#DevicePixmapGCHandle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:DeviceGraphicsContext
!

DeviceHandle subclass:#DeviceWindowGCHandle
	instanceVariableNames:'parentId'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DeviceGraphicsContext
!

!DeviceGraphicsContext class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
 COPYRIGHT (c) 2015-2017 Jan Vrany
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
    I provide the common protocol for a graphicsContext which is associated with a particular
    device (i.e. Bitmaps, Pixmaps, RootWindow and Windows in Xs world, but also postscript
    printer pages or fax pages).

    My instance variables are mainly caching device-related stuff (such as font- and color-Ids)
    to avoid needless message traffic. 
    All real work is done by my device, which is accessed via the device instance variable.
    Most drawing requests are simply forwarded to it, others are simulated by using more basic
    drawing functions (see GraphicsContext drawing vs. basic drawing category).

    The added variables foreground/background are the drawing colors actually
    used; these are the real (i.e. non dithered) colors supported by the device.
    Direct access to fg/bg is discouraged, since in the future, these may be
    totally replaced by paint/bgPaint
    (there are some operations and special cases, for which a direct access to
     fg/bg makes sense)

    [Instance variables:]

        drawableId      <SmallInteger>  my drawableId on the device (a device handle)

        gcId            <SmallInteger>  my gc's ID on the device (a device handle)

        deviceFont      <Font>          the actual font, currently set in the device

        foreground      <Color>         the device foreground color used for drawing

        background      <Color>         the device background color used for drawing

    [see also:]
        DeviceWorkstation
        Color Font Cursor

    [author:]
        Claus Gittinger

"
! !

!DeviceGraphicsContext class methodsFor:'instance creation'!

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
        device := Display.
        device isNil ifTrue:[
            (self class name,' [warning]: no Display') infoPrintCR.
            Smalltalk lateOpenDisplay.

            device := Screen current ? Display.
            device isNil ifTrue:[ self error:'no screen device' ]
        ].
    ].
    ^ self onDevice:device
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

    |newDrawable|

    newDrawable := self basicNew.

    "
     set display before its initialized
     - so it can do something useful (i.e. get font sizes etc.) in its
     intitialize method(s)
    "
    newDrawable device:aDevice.
    newDrawable initialize.
    ^ newDrawable

    "Modified: 2.4.1997 / 19:19:35 / cg"
! !

!DeviceGraphicsContext class methodsFor:'cleanup'!

lowSpaceCleanup
    CachedScaledForms := CachedScales := nil
! !

!DeviceGraphicsContext methodsFor:'accessing'!

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

    ^ device getPixelX:x y:y from:drawableId with:gcId

    "Modified: / 22.5.1999 / 01:40:23 / cg"
!

atX:x y:y put:aPixelColor
    "set a pixel"

    |oldFg|

    oldFg := foreground.
    self foreground:aPixelColor.
    self displayPointX:x y:y.
    self foreground:oldFg
!

backgroundPaint:aColor
    "set the background-paint color; this is used in opaque-draw
     operations"

    (aColor ~~ bgPaint) ifTrue:[
	aColor notNil ifTrue:[
	    bgPaint := aColor.
	    gcId notNil ifTrue:[
		bgPaint isColor ifTrue:[
		    bgPaint := aColor onDevice:device.
		    bgPaint colorId notNil ifTrue:[
			background := bgPaint.
			gcId notNil ifTrue:[
			    device setBackground:(bgPaint colorId) in:gcId.
			].
			^ self
		    ]
		].
		self paint:paint on:aColor
	    ]
	]
    ].
!

basicFont:aFont
    "set the font for drawing if it has changed.
     This is a low level entry, which is not to be redefined
     (i.e. it must not imply a redraw operation)"

    |id|

    (aFont notNil and:[aFont ~~ font]) ifTrue:[
        font := aFont.
        device notNil ifTrue:[
            font := font onDevice:device.
            gcId notNil ifTrue:[
                id := font fontId.
                id notNil ifTrue:[
                    deviceFont := font.
                    device setFont:id in:gcId
                ]
            ]
        ]
    ]

    "Created: / 23-02-1996 / 17:16:51 / cg"
    "Modified: / 22-10-2006 / 14:11:37 / cg"
!

capStyle:aSymbol
    "set the style in which the endpoints of lines
     are drawn - aSymbol may be #notLast, #butt, #round, #projecting"

    |s|

    (s := aSymbol) isNil ifTrue:[
	s := #butt.

    ].
    (s ~~ capStyle) ifTrue:[
	capStyle := s.
	gcId notNil ifTrue:[
	    device setLineWidth:lineWidth
			  style:lineStyle
			    cap:s
			   join:joinStyle
			     in:gcId
	]
    ]

    "Modified: 12.5.1996 / 22:23:03 / cg"
!

clippedByChildren:aBoolean
    "turn on/off drawing over children.
     If on, a superview may draw 'over' its children.
     If off (the default), drawing is 'under' its children.
     Only useful for the rootView, to draw over any visible views.
     (for example, when dragging a rubber-line)"

    gcId isNil ifTrue:[
	self initGC
    ].
    device noClipIn:drawableId gc:gcId.
    device setClipByChildren:aBoolean in:drawableId gc:gcId.

    "Created: 17.7.1996 / 13:25:16 / cg"
    "Modified: 29.4.1997 / 15:33:55 / dq"
!

clippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in logical coordinates);
     a nil argument turn off clipping (i.e. whole view is drawable)"

    |x y w h newBounds|

    aRectangleOrNil isNil ifTrue:[
	clipRect isNil ifTrue:[^ self].
	gcId notNil ifTrue:[
	    device noClipIn:drawableId gc:gcId
	].
	clipRect := nil.
	^ self.
    ].

    x := aRectangleOrNil left.
    y := aRectangleOrNil top.
    w := aRectangleOrNil width.
    h := aRectangleOrNil height.
    transformation notNil ifTrue:[
	x := transformation applyToX:x.
	y := transformation applyToY:y.
	w := transformation applyScaleX:w.
	h := transformation applyScaleY:h.
    ].
    (x class == SmallInteger) ifFalse:[
	w := w + (x - x truncated).
	x := x truncated
    ].
    (y class == SmallInteger) ifFalse:[
	h := h + (y - y truncated).
	y := y truncated
    ].
    (w class == SmallInteger) ifFalse:[
	w := w truncated + 1
    ].
    (h class == SmallInteger) ifFalse:[
	h := h truncated + 1
    ].
    w := w max:0.
    h := h max:0.

    newBounds := Rectangle left:x top:y width:w height:h.
    (clipRect notNil and:[clipRect = newBounds]) ifTrue:[
	^ self
    ].
    clipRect := newBounds.
    gcId notNil ifTrue:[
	device setClipX:x y:y width:w height:h in:drawableId gc:gcId.
    ].

    "Created: / 28.5.1996 / 19:40:20 / cg"
    "Modified: / 16.5.1999 / 19:40:37 / cg"
!

colorAt:aPoint
    "return the color of the pixel at the coordinate given by x@y"

    ^ self colorAtX:(aPoint x) y:(aPoint y)

    "Modified: 1.8.1997 / 20:01:58 / cg"
!

colorAtX:x y:y
    "return the color of the pixel at the coordinate given by aPoint"

    |pixel|

    pixel := self atX:x y:y.
    device getScaledRGBFrom:pixel into:[:r :g :b |
	^ Color scaledRed:r scaledGreen:g scaledBlue:b
    ].

    "Created: 1.8.1997 / 20:01:32 / cg"
!

container
    "return my container - for protocol compatibility"

    ^ nil
!

dashStyle:aDashList offset:dashOffset
    "define dashes. Each element of the dashList specifies the length
     of a corresponding dash. For example, setting it to [4 4]
     defines 4on-4off dashing;
     Setting it to [1 2 4 2] defines 1on-2off-4on-2off dashes.
     The dashOffset specifies where in the dashList the dashing starts.
     This may not be supported by all graphics devices."

    gcId notNil ifTrue:[
	device setDashes:(ByteArray withAll:aDashList)
	      dashOffset:dashOffset
		      in:gcId
    ]

    "Modified: 4.6.1996 / 19:03:06 / cg"
!

device
    "return the device, the receiver is associated with"

    ^ device
!

device:aDevice
    "set the device"

    device == aDevice ifTrue:[
        ^ self.
    ].
    device notNil ifTrue:[
        "change of device of an already existing GraphicsContext"
        drawableId notNil ifTrue:[
            device unregisterGraphicsContext:self.
        ].
        device := aDevice.
        self recreate.
        ^ self.
    ].

    "set device of a new GraphicsContext"
    device := aDevice
!

deviceClippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in device coordinates);
     a nil argument turns off clipping (i.e. whole view is drawable - incl. margins)"

    clipRect = aRectangleOrNil ifTrue:[
	^ self
    ].
    clipRect := aRectangleOrNil.

    gcId isNil ifTrue:[
	^ self.
    ].

    aRectangleOrNil isNil ifTrue:[
	device noClipIn:drawableId gc:gcId
    ] ifFalse:[
	device setClipX:aRectangleOrNil left
		    y:aRectangleOrNil top
		    width:aRectangleOrNil width
		    height:aRectangleOrNil height
		    in:drawableId
		    gc:gcId
    ].

    "Modified: / 22.5.1996 / 13:12:07 / cg"
    "Created: / 14.9.1998 / 18:50:31 / cg"
!

deviceClippingBoundsOrNil
    "get the clipping rectangle for drawing (in device coordinates);
     a nil clipping rectangle means: no clipping (i.e. whole view is drawable - incl. margins)"

    ^ clipRect
!

deviceFont
    "return the font for drawing - here, a device font is returned if
     the GC is realized."

    (device notNil and:[font notNil]) ifTrue:[
        font := font onDevice:device
    ].
    ^ font
!

drawableId
    ^ drawableId

    "Created: / 10-07-2008 / 10:20:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 26-04-2016 / 07:11:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

font
    "return the font for drawing - here, a device font is returned if
     the GC is realized."

    (device notNil and:[font notNil]) ifTrue:[
	font := font onDevice:device
    ].
    ^ font
!

font:aFont
    "set the font for drawing if it has changed."

    (aFont ~~ font) ifTrue:[
	self basicFont:aFont.
    ]

    "Modified: 6.3.1996 / 18:17:40 / cg"
!

function:aSymbol
    "set the drawing function if it has changed"

    (aSymbol ~~ function) ifTrue:[
	function := aSymbol.
	gcId notNil ifTrue:[
	    device setFunction:aSymbol in:gcId
	]
    ]
!

gcId
    "return the receiver's graphic context id on the device"

    ^ gcId
!

id
    "return the id of the drawable on the device"

    ^ drawableId
!

joinStyle:aSymbol
    "set the style in which 2 lines are connected in polygons -
     aSymbol may be #miter, #bevel, #round"

    |s|

    (s := aSymbol) isNil ifTrue:[
	s := #miter
    ].
    (s ~~ joinStyle) ifTrue:[
	joinStyle := s.

	gcId notNil ifTrue:[
	    device setLineWidth:lineWidth
			  style:lineStyle
			    cap:capStyle
			   join:s
			     in:gcId
	]
    ]

    "Modified: 12.5.1996 / 22:20:43 / cg"
!

lineStyle:aSymbol
    "set the style in which lines are drawn -
     aSymbol may be #solid, #dashed, #doubleDashed,
     #dotted, #dashDot or #dashDotDot."

    |s|

    (s := aSymbol) isNil ifTrue:[
	s := #solid
    ].
    (s ~~ lineStyle) ifTrue:[
	lineStyle := s.
	gcId notNil ifTrue:[
	    device setLineWidth:lineWidth
			  style:s
			    cap:capStyle
			   join:joinStyle
			     in:gcId
	]
    ]

    "Modified: 12.5.1996 / 22:21:25 / cg"
!

lineWidth:aNumber
    "set the line width for drawing if it has changed"

    |n|

    (aNumber ~~ lineWidth) ifTrue:[
	lineWidth := aNumber.
	transformation isNil ifTrue:[
	    n := aNumber.
	] ifFalse:[
	    n := transformation applyScaleX:aNumber.
	    n := n rounded
	].
	gcId notNil ifTrue:[
	    device setLineWidth:n style:lineStyle cap:capStyle join:joinStyle in:gcId
	]
    ]
!

mask:aForm
    "set the mask form for drawing"

    |id|

    (aForm ~~ mask) ifTrue:[
        mask := aForm.
        gcId notNil ifTrue:[
            mask isNil ifTrue:[
                device setBitmapMask:nil in:gcId
            ] ifFalse:[
                mask := mask asFormOn:device.
                id := mask drawableId.
                (mask depth == 1) ifTrue:[
                    device setBitmapMask:id in:gcId
                ] ifFalse:[
                    device setPixmapMask:id in:gcId
                ]
            ]
        ]
    ]
!

maskOrigin:aPoint
    "set the origin of the mask-pattern"

    |x y pO|

    x := aPoint x.
    y := aPoint y.

    (maskOrigin isNil or:[
     ((x ~= maskOrigin x) or:[y ~= maskOrigin y]) ]) ifTrue:[

        maskOrigin := aPoint.

        transformation notNil ifTrue:[
            pO := transformation transformPoint:aPoint.
            x:= pO x.
            y := pO y.
        ].

        gcId notNil ifTrue:[
            device setMaskOriginX:x rounded y:y rounded in:gcId
        ]
    ]

    "Created: / 26.1.1998 / 19:03:02 / cg"
!

maskOriginX:orgX y:orgY
    "set the origin of the pattern"

    self maskOrigin:(orgX @ orgY)
!

paint:aColor
    "set the drawing color, which may be a real color, a dithered one
     or even an image."

    (aColor ~~ paint) ifTrue:[
	aColor notNil ifTrue:[
	    paint := aColor.
	    self setGCForPaint.
	]
    ]

    "Modified: 16.5.1996 / 15:35:57 / cg"
!

paint:fgColor on:bgColor
    "set the paint and background-paint color.
     The bg-paint is used in opaque-draw operations"

    |fgId bgId|

    ((fgColor ~~ paint) or:[bgColor ~~ bgPaint]) ifTrue:[
	fgColor notNil ifTrue:[
	    paint := fgColor
	].
	bgColor notNil ifTrue:[
	    bgPaint := bgColor
	].
	gcId notNil ifTrue:[
	    paint isColor ifTrue:[
		paint := paint onDevice:device.
	    ].
	    paint isColor ifTrue:[
		fgId := paint colorId.
		fgId notNil ifTrue:[
		    mask notNil ifTrue:[
			mask := nil.
			device setBitmapMask:nil in:gcId
		    ].
		    bgPaint isColor ifTrue:[
			bgPaint := bgPaint onDevice:device.
		    ].
		    bgPaint isColor ifTrue:[
			bgId := bgPaint colorId.
			bgId notNil ifTrue:[
			    "the common case, both are real colors"
			    (paint ~~ foreground) ifTrue:[
				foreground := paint.
				(bgPaint ~~ background) ifTrue:[
				    background := bgPaint.
				    device setForeground:fgId background:bgId in:gcId.
				    ^ self
				].
				device setForeground:fgId in:gcId.
				^ self
			    ].
			    (bgPaint ~~ background) ifTrue:[
				background := bgPaint.
				device setBackground:bgId in:gcId.
			    ].
			    ^ self
			].
			"bgPaint is dithered, setup paint here, leave bgPaint
			 till next opaque draw comes around."

			(paint ~~ foreground) ifTrue:[
			    foreground := paint.
			    device setForeground:fgId in:gcId
			].
			^ self
		    ]
		]
	    ].
	    "either paint or bgPaint (or both) are dithered colors,
	     setup for paint, leave bg-problem till next opaque draw
	     comes around.
	    "
	    self setGCForPaint.
	]
    ]

    "Modified: / 31-08-2007 / 10:56:49 / cg"
!

paint:fgColor on:bgColor function:f
    "set paint, background-paint and function"

    self paint:fgColor on:bgColor.
    self function:f

    "Modified: 16.5.1996 / 15:36:35 / cg"
!

setClippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in physical coordinates.
     Only set the variable, do not change the gc"

    clipRect := aRectangleOrNil
!

setDeviceMaskOriginX:x y:y
    "set the origin of the mask-pattern"

    gcId notNil ifTrue:[
        device setMaskOriginX:x rounded y:y rounded in:gcId
    ].
!

setGraphicsExposures:aBoolean
    "want to if aBoolean is true - or don't want to be notified
     of graphics exposures"

    gcId notNil ifTrue:[
        device setGraphicsExposures:aBoolean in:gcId
    ]
!

setPaint:fgColor on:bgColor
    "set the paint and background-paint color.
     The bg-paint is used in opaque-draw operations.
     Only set the variables, but do not send it to the device,
     Used on initialization."

    fgColor notNil ifTrue:[
	foreground := paint := fgColor
    ].
    bgColor notNil ifTrue:[
	background := bgPaint := bgColor
    ].
! !

!DeviceGraphicsContext methodsFor:'accessing-internals'!

background
    <resource: #obsolete>
    "return the current background drawing color.
     OBSOLETE: use #paint: / #backgroundPaint: / #paint:on:"

    ^ background

    "Modified: 12.5.1996 / 22:28:09 / cg"
!

background:aColor
    <resource: #obsolete>
    "set the internal background color for drawing - aColor must be a real color.
     OBSOLETE: this method will vanish; use #paint: / #backgroundPaint: / #paint:on:"

    |bgId|

    (aColor ~~ background) ifTrue:[
	aColor notNil ifTrue:[
	    background := aColor.
	    gcId notNil ifTrue:[
		background := background onDevice:device.
		bgId := background colorId.

		"
		 mhmh the following is a kludge ....
		"
		bgId isNil ifTrue:[
		    (background grayIntensity >= 50) ifTrue:[
			bgId := device whitepixel
		    ] ifFalse:[
			bgId := device blackpixel
		    ]
		].
		device setBackground:bgId in:gcId
	    ]
	]
    ]

    "Modified: 28.5.1996 / 20:44:55 / cg"
!

foreground
    <resource: #obsolete>
    "return the current foreground drawing color.
     OBSOLETE: use #paint: / #paint:on:"

    ^ foreground

    "Modified: 12.5.1996 / 22:28:03 / cg"
!

foreground:aColor
    <resource: #obsolete>
    "set the internal foreground color for drawing - aColor must be a real color.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    |fgId|

    (aColor ~~ foreground) ifTrue:[
	aColor notNil ifTrue:[
	    foreground := aColor.
	    gcId notNil ifTrue:[
		(foreground class == SmallInteger) ifTrue:[
		    fgId := foreground
		] ifFalse:[
		    foreground := foreground onDevice:device.
		    fgId := foreground colorId.
		].

		"mhmh the following is a kludge ...."
		fgId isNil ifTrue:[
		    (foreground grayIntensity >= 50) ifTrue:[
			fgId := device whitepixel
		    ] ifFalse:[
			fgId := device blackpixel
		    ]
		].
		device setForeground:fgId in:gcId.
		paint := foreground
	    ]
	]
    ]

    "Modified: 28.5.1996 / 20:45:02 / cg"
!

foreground:fgColor background:bgColor
    <resource: #obsolete>
    "set both internal foreground and internal background colors
     - these must be real colors.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    |fgPixel bgPixel|

    ((fgColor ~~ foreground) or:[bgColor ~~ background]) ifTrue:[
	fgColor notNil ifTrue:[
	    foreground := fgColor
	].
	bgColor notNil ifTrue:[
	    background := bgColor
	].
	gcId notNil ifTrue:[
	    foreground := foreground onDevice:device.
	    background := background onDevice:device.
	    fgPixel := foreground colorId.
	    bgPixel := background colorId.

	    "mhmh the following is a kludge ...."
	    fgPixel isNil ifTrue:[
		(foreground grayIntensity >= 50) ifTrue:[
		    fgPixel := device whitepixel
		] ifFalse:[
		    fgPixel := device blackpixel
		]
	    ].
	    bgPixel isNil ifTrue:[
		(background grayIntensity >= 50) ifTrue:[
		    bgPixel := device whitepixel
		] ifFalse:[
		    bgPixel := device blackpixel
		]
	    ].
	    device setForeground:fgPixel background:bgPixel in:gcId.
	    paint := foreground
	]
    ]

    "Modified: 28.5.1996 / 20:45:27 / cg"
!

foreground:aColor function:fun
    <resource: #obsolete>
    "set the foreground color and function for drawing.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    |fgPixel|

    ((aColor ~~ foreground) or:[fun ~~ function]) ifTrue:[
	foreground := aColor.
	function := fun.
	gcId notNil ifTrue:[
	    foreground := foreground onDevice:device.
	    fgPixel := foreground colorId.

	    "mhmh the following is a kludge ...."
	    fgPixel isNil ifTrue:[
		(foreground grayIntensity >= 50) ifTrue:[
		    fgPixel := device whitepixel
		] ifFalse:[
		    fgPixel := device blackpixel
		]
	    ].
	    device setForeground:fgPixel in:gcId.
	    device setFunction:fun in:gcId.
	    paint := foreground
	]
    ]

    "Modified: 28.5.1996 / 20:45:09 / cg"
! !

!DeviceGraphicsContext methodsFor:'bit blitting'!

copyBitsFrom:aByteArray bitsPerPixel:bpp depth:depth padding:pad width:srcW height:srcH x:srcX y:srcY toX:dstX y:dstY
    "copy bits from a smalltalk byteArray.
     The bits found there are supposed to be in the devices native format (i.e.
     translated to allocated color indices on pseudoColor devices and padded as required.
     The byteOrder is MSB and will be converted as appropriate by the underlying devices
     method to whatever the device needs."

    device
	drawBits:aByteArray
	bitsPerPixel:bpp
	depth:depth
	padding:pad
	width:srcW height:srcH
	x:srcX y:srcY
	into:drawableId
	x:dstX y:dstY
	width:srcW height:srcH       "all senders set srcW/srcH to self width / self height"
	with:gcId.
!

copyFrom:aGC x:srcX y:srcY toX:dstX y:dstY width:w height:h depth:depth
    "copy from aDrawable into the receiver;
     the source may be the receiver as well - in this case its a scroll.
     All coordinates are in device coordinates."

    |srcGCId srcDrawableId|

    gcId isNil ifTrue:[
        self initGC
    ].

    srcGCId := aGC initGC.
    srcDrawableId := aGC drawableId.

    ((depth == 1) and:[device depth ~~ 1]) ifTrue:[
        aGC isPixmap ifTrue:[
            device
                copyPlaneFromPixmapId:srcDrawableId
                x:srcX
                y:srcY
                gc:srcGCId
                to:drawableId
                x:dstX
                y:dstY
                gc:gcId
                width:w
                height:h
        ] ifFalse:[
            device
                copyPlaneFromId:srcDrawableId
                x:srcX
                y:srcY
                gc:srcGCId
                to:drawableId
                x:dstX
                y:dstY
                gc:gcId
                width:w
                height:h
        ]
    ] ifFalse:[
        aGC isPixmap ifTrue:[
            device
                copyFromPixmapId:srcDrawableId
                x:srcX
                y:srcY
                gc:srcGCId
                to:drawableId
                x:dstX
                y:dstY
                gc:gcId
                width:w
                height:h
        ] ifFalse:[
            device
                copyFromId:srcDrawableId
                x:srcX
                y:srcY
                gc:srcGCId
                to:drawableId
                x:dstX
                y:dstY
                gc:gcId
                width:w
                height:h.
        ]
    ].
!

copyPlaneFrom:aGC x:srcX y:srcY toX:dstX y:dstY width:w height:h
    "copy one plane from aDrawable into the receiver. 0's are drawn in
     background, while 1's are drawn with foreground color.
     The depth of aDrawable must (should) be 1.
     The drawable must have been allocated on the same device.
     All coordinates are in device coordinates."

    |srcGCId srcDrawableId|

    gcId isNil ifTrue:[
        self initGC
    ].

    srcGCId := aGC initGC.
    srcDrawableId := aGC drawableId.

    aGC isPixmap ifTrue:[
        device
            copyPlaneFromPixmapId:srcDrawableId
            x:srcX
            y:srcY
            gc:srcGCId
            to:drawableId
            x:dstX
            y:dstY
            gc:gcId
            width:w
            height:h
    ] ifFalse:[
        device
            copyPlaneFromId:srcDrawableId
            x:srcX
            y:srcY
            gc:srcGCId
            to:drawableId
            x:dstX
            y:dstY
            gc:gcId
            width:w
            height:h
    ]

    "Modified: / 22.8.1998 / 15:15:52 / cg"
! !

!DeviceGraphicsContext methodsFor:'copying'!

postCopy
    "this may not be enough to allow copying of views ..."

    super postCopy.
    device := drawableId := gcId := nil.
    self recreate
!

postDeepCopy
    device := drawableId := gcId := nil.
! !

!DeviceGraphicsContext methodsFor:'drawing'!

displayArcX:x y:y width:w height:h from:startAngle angle:angle
    "draw an arc; apply transformation if nonNil"

    |pX pY nW nH sA a pO pC|

    gcId isNil ifTrue:[
	self initGC
    ].
    transformation notNil ifTrue:[
	pO := transformation transformPoint:x@y.
	pC := transformation transformPoint:(x+w-1)@(y+h-1).
	pX := pO x.
	pY := pO y.
	nW := pC x - pX + 1.
	nH := pC y - pY + 1.

	nW < 0 ifTrue:[
	      nW := nW abs.
	      pX := pX - nW.
	].
	nH < 0 ifTrue:[
	      nH := nH abs.
	      pY := pY - nH.
	].
    ] ifFalse:[
	pX := x.
	pY := y.
	nW := w.
	nH := h.
    ].

    pX := pX rounded.
    pY := pY rounded.
    nW := nW rounded.
    nH := nH rounded.

    sA := startAngle.
    sA isInteger ifFalse:[sA := sA asFloat].
    a := angle.
    a isInteger ifFalse:[a := a asFloat].

    device
	  displayArcX:pX
		    y:pY
		width:nW
	       height:nH
		 from:sA
		angle:a
		   in:drawableId
		 with:gcId

    "Created: 8.5.1996 / 08:31:30 / cg"
    "Modified: 4.6.1996 / 17:59:28 / cg"
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

    |realForm pX pY w h nW nH pO pC|

    realForm := formToDraw.

    transformation notNil ifTrue:[
	pO := transformation transformPoint:x@y.
	pX := pO x.
	pY := pO y.

	transformation isNoScale ifFalse:[
	    w := formToDraw width.
	    h := formToDraw height.
	    pC := transformation applyTo:(x+w-1)@(y+h-1).
	    nW := pC x - pX + 1.
	    nH := pC y - pY + 1.
	    "/ nW := (transformation applyScaleX:w) rounded.
	    "/ nH := (transformation applyScaleY:h) rounded.

	    ((nW ~= w) or:[nH ~= h]) ifTrue:[
		"/
		"/ hard case - someone is drawing forms with scaling in effect
		"/ look if we have a scaled version in our pocket ...
		"/
		realForm := nil.
		CachedScaledForms notNil ifTrue:[
		    (CachedScales at:formToDraw ifAbsent:nil) = transformation scale ifTrue:[
			realForm := CachedScaledForms at:formToDraw ifAbsent:nil.
		    ]
		].
		realForm isNil ifTrue:[
		    "/
		    "/ nope - must do the work ...
		    "/
		    realForm := formToDraw magnifiedBy:(nW / w) @ (nH / h).
		    CachedScaledForms isNil ifTrue:[
			CachedScaledForms := WeakIdentityDictionary new.
			CachedScales := WeakIdentityDictionary new.
		    ].
		    CachedScaledForms at:formToDraw put:realForm.
		    CachedScales at:formToDraw put:transformation scale.
		]
	    ]
	]
    ] ifFalse:[
	pX := x.
	pY := y.
    ].

    self displayDeviceForm:realForm x:pX y:pY

    "Modified: 12.4.1997 / 12:47:29 / cg"
!

displayLineFrom:p0 to:p1
    "draw a line (with current paint-color); apply transformation if nonNil"

    |pX0 pY0 pX1 pY1 easy fgId bgId tp0 tp1|

    gcId isNil ifTrue:[
	self initGC
    ].

    lineStyle == #doubleDashed ifTrue:[
	"
	 if bgPaint or paint is not a real color, we have to do it the hard way ...
	"
	easy := true.
	paint isColor ifFalse:[
	    easy := false
	] ifTrue:[
	    fgId := paint colorId.
	    fgId isNil ifTrue:[
		easy := false
	    ]
	].
	bgPaint isColor ifFalse:[
	    easy := false
	] ifTrue:[
	    bgId := bgPaint colorId.
	    bgId isNil ifTrue:[
		easy := false
	    ]
	].

	easy ifTrue:[
	    ((foreground ~~ paint) or:[background ~~ bgPaint]) ifTrue:[
		device setForeground:fgId background:bgId in:gcId.
		foreground := paint.
		background := bgPaint.
	    ].
	] ifFalse:[
	    'DeviceGraphicsContext [warning]: cannot draw dashes with dithered colors' errorPrintCR
	].
    ].

    transformation notNil ifTrue:[
	tp0 := transformation transformPoint:p0.
	tp1 := transformation transformPoint:p1.
	pX0 := tp0 x.
	pY0 := tp0 y.
	pX1 := tp1 x.
	pY1 := tp1 y.
    ] ifFalse:[
	pX0 := p0 x.
	pY0 := p0 y.
	pX1 := p1 x.
	pY1 := p1 y
    ].

    pX0 := pX0 rounded.
    pY0 := pY0 rounded.
    pX1 := pX1 rounded.
    pY1 := pY1 rounded.

    device displayLineFromX:pX0 y:pY0 toX:pX1 y:pY1 in:drawableId with:gcId
!

displayLineFromX:x0 y:y0 toX:x1 y:y1
    "draw a line (with current paint-color); apply transformation if nonNil"

    |pX0 pY0 pX1 pY1 easy fgId bgId p0 p1|

    gcId isNil ifTrue:[
	self initGC
    ].

    lineStyle == #doubleDashed ifTrue:[
	"
	 if bgPaint or paint is not a real color, we have to do it the hard way ...
	"
	easy := true.
	paint isColor ifFalse:[
	    easy := false
	] ifTrue:[
	    fgId := paint colorId.
	    fgId isNil ifTrue:[
		easy := false
	    ]
	].
	bgPaint isColor ifFalse:[
	    easy := false
	] ifTrue:[
	    bgId := bgPaint colorId.
	    bgId isNil ifTrue:[
		easy := false
	    ]
	].

	easy ifTrue:[
	    ((foreground ~~ paint) or:[background ~~ bgPaint]) ifTrue:[
		device setForeground:fgId background:bgId in:gcId.
		foreground := paint.
		background := bgPaint.
	    ].
	] ifFalse:[
	    'DeviceGraphicsContext [warning]: cannot draw dashes with dithered colors' errorPrintCR
	].
    ].

    transformation notNil ifTrue:[
	p0 := transformation transformPoint:x0@y0.
	p1 := transformation transformPoint:x1@y1.
	pX0 := p0 x.
	pY0 := p0 y.
	pX1 := p1 x.
	pY1 := p1 y.
    ] ifFalse:[
	pX0 := x0.
	pY0 := y0.
	pX1 := x1.
	pY1 := y1
    ].

    pX0 := pX0 rounded.
    pY0 := pY0 rounded.
    pX1 := pX1 rounded.
    pY1 := pY1 rounded.

    device displayLineFromX:pX0 y:pY0 toX:pX1 y:pY1 in:drawableId with:gcId

    "Modified: 10.1.1997 / 17:46:32 / cg"
!

displayOpaqueForm:formToDraw x:x y:y
    "draw a form or image opaque;
     if its a 1-plane bitmap, 1-bits are drawn in the
     current paint-color and 0-bits in the bgPaint color.
     If its a deep form (i.e. a pixmap) the current paint/bgPaint
     settings are ignored and the form drawn as-is.
     In the 1-plane case, special care must be taken if paint and/or bgPaint
     dithered colors or patterns, since are that the colors are correctly allocated
     (by sending #on: to the colors) before doing so.
     If there is a transformation, the image is scaled as appropiate."

    |w h realForm pX pY nW nH pO pC|

    bgPaint isNil ifTrue:[
	"/
	"/ actually not an opaque draw
	"/
	self displayForm:formToDraw x:x y:y.
	^ self
    ].

    realForm := formToDraw.

    transformation notNil ifTrue:[
	pO := transformation transformPoint:x@y.
	pX := pO x.
	pY := pO y.
	"/ pX := transformation applyToX:x.
	"/ pY := transformation applyToY:y.

	transformation isNoScale ifFalse:[
	    w := formToDraw width.
	    h := formToDraw height.
	    pC := transformation applyTo:(x+w-1)@(y+h-1).
	    nW := pX - x + 1.
	    nH := pY - y + 1.
	    "/ nW := (transformation applyScaleX:w) rounded.
	    "/ nH := (transformation applyScaleY:h) rounded.

	    ((nW ~= w) or:[nH ~= h]) ifTrue:[
		"/
		"/ hard case - someone is drawing forms with scaling in effect
		"/ look if we have a scaled version in our pocket ...
		"/
		realForm := nil.
		CachedScaledForms notNil ifTrue:[
		    (CachedScales at:formToDraw ifAbsent:nil) = transformation scale ifTrue:[
			realForm := CachedScaledForms at:formToDraw ifAbsent:nil.
		    ]
		].
		realForm isNil ifTrue:[
		    "/
		    "/ nope - must do the work ...
		    "/
		    realForm := formToDraw magnifiedBy:(nW / w) @ (nH / h).
		    CachedScaledForms isNil ifTrue:[
			CachedScaledForms := WeakIdentityDictionary new.
			CachedScales := WeakIdentityDictionary new.
		    ].
		    CachedScaledForms at:formToDraw put:realForm.
		    CachedScales at:formToDraw put:transformation scale.
		]
	    ]
	]
    ] ifFalse:[
	pX := x.
	pY := y.
    ].

    self displayDeviceOpaqueForm:realForm x:pX y:pY

    "Modified: 12.4.1997 / 12:49:02 / cg"
!

displayOpaqueString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the coordinate x/y - draw foreground pixels in
     paint-color and background pixels in bgPaint-color.
     If the transformation involves scaling,
     the font's point-size is scaled as appropriate.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors"

    self displayString:aString from:index1 to:index2 x:x y:y opaque:true maxWidth:nil
!

displayOpaqueString:aString x:x y:y
    "draw a string at the coordinate x/y - draw foreground pixels in paint-color,
     background pixels in bgPaint color. If the transformation involves scaling,
     the font's point-size is scaled as appropriate.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors or images."

    aString isPlainString ifFalse:[
	"
	 hook for non-strings (i.e. attributed text)
	 that 'thing' should know how to display itself ...
	"
	aString displayOpaqueOn:self x:x y:y.
	^ self
    ].

    self displayOpaqueString:aString from:1 to:(aString size) x:x y:y
!

displayPointX:x y:y
    "draw a point (with current paint-color); apply transformation if nonNil"

    |pX pY pO|

    gcId isNil ifTrue:[
	self initGC
    ].
    transformation notNil ifTrue:[
	pO := transformation transformPoint:x@y.
	pX := pO x.
	pY := pO y.
    ] ifFalse:[
	pX := x.
	pY := y
    ].
    pX := pX rounded.
    pY := pY rounded.

    device displayPointX:pX y:pY in:drawableId with:gcId
!

displayPolygon:aPolygon
    "draw (the outline of) a polygon (with current paint-color).
     Apply transformation if nonNil"

    |newPolygon|

    gcId isNil ifTrue:[
	self initGC
    ].
    transformation notNil ifTrue:[
	newPolygon := aPolygon collect:[:point | transformation transformPoint:point].
    ] ifFalse:[
	newPolygon := aPolygon
    ].
    (newPolygon contains:[:p |
	(p isPoint not
	or:[(p x class ~~ SmallInteger)
	or:[(p y class ~~ SmallInteger)]])
     ]) ifTrue:[
	newPolygon := newPolygon collect:[:p | p asPoint rounded]
    ].

    device displayPolygon:newPolygon in:drawableId with:gcId
!

displayRectangleX:x y:y width:w height:h
    "draw a rectangle (with current paint-color).
     If transformation is nonNil, drawing is in logical coordinates."

    |pX pY nW nH easy fgId bgId pO pC|

    gcId isNil ifTrue:[
	self initGC
    ].

    lineStyle == #doubleDashed ifTrue:[
	"
	 if bgPaint or paint is not a real color, we have to do it the hard way ...
	"
	easy := true.
	paint isColor ifFalse:[
	    easy := false
	] ifTrue:[
	    fgId := paint colorId.
	    fgId isNil ifTrue:[
		easy := false
	    ]
	].
	bgPaint isColor ifFalse:[
	    easy := false
	] ifTrue:[
	    bgId := bgPaint colorId.
	    bgId isNil ifTrue:[
		easy := false
	    ]
	].

	easy ifTrue:[
	    ((foreground ~~ paint) or:[background ~~ bgPaint]) ifTrue:[
		device setForeground:fgId background:bgId in:gcId.
		foreground := paint.
		background := bgPaint.
	    ].
	] ifFalse:[
	    'DeviceGraphicsContext [warning]: cannot draw dashes with dithered colors' errorPrintCR
	].
    ].

    transformation notNil ifTrue:[
	pO := transformation transformPoint:x@y.
	pC := transformation transformPoint:(x+w-1)@(y+h-1).
	pX := pO x.
	pY := pO y.
	nW := pC x - pX + 1.
	nH := pC y - pY + 1.
"/        pX := transformation applyToX:x.
"/        pY := transformation applyToY:y.
"/        nW := transformation applyScaleX:w.
"/        nH := transformation applyScaleY:h.
	nW < 0 ifTrue:[
	      nW := nW abs.
	      pX := pX - nW.
	].
	nH < 0 ifTrue:[
	      nH := nH abs.
	      pY := pY - nH.
	].
    ] ifFalse:[
	pX := x.
	pY := y.
	nW := w.
	nH := h
    ].

    pX := pX rounded.
    pY := pY rounded.
    nW := nW rounded.
    nH := nH rounded.

    "I asked myself many times if we should draw w/h or (w-1)/(h-1) bits -
     this one seems mathematically incorrect but allows to draw and fill
     a rectangle using the same extents.
     I'm not certain if is the right thing to do ...
    "
    device displayRectangleX:pX
			   y:pY
		       width:(nW - 1)
		      height:(nH - 1)
			  in:drawableId with:gcId

    "Modified: 10.1.1997 / 17:46:41 / cg"
!

displayString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the coordinate x/y -
     draw foreground-pixels only (in current paint-color),
     leaving background as-is. If the transformation involves scaling,
     the font's point-size is scaled as appropriate."

    self displayString:aString from:index1 to:index2 x:x y:y opaque:false maxWidth:nil.
!

displayString:aString from:index1 to:index2 x:x y:y opaque:opaque
    "draw part of a string with both fg and bg at x/y in current font"

    ^ self displayString:aString from:index1 to:index2 x:x y:y opaque:opaque maxWidth:nil
!

displayString:aStringArg from:index1Arg to:index2Arg x:x y:y opaque:opaqueArg maxWidth:maxWidth
    "draw a substring at the coordinate x/y - draw foreground pixels in
     paint-color and (if opaque is true), background pixels in bgPaint-color.
     If the transformation involves scaling, the font's point-size is scaled as appropriate.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors.
     maxWidth is the maximum width of the string in pixels or nil if unknown."

    |opaque index1 index2 easy w h savedPaint fgId bgId pX pY fontUsed fontsEncoding sz aString
     nSkipLeft nChars wString wSkipLeft index2Guess|

    index1 := index1Arg.
    index2 := index2Arg.
    opaque := opaqueArg.

    "
     if backgroundPaint color is nil, we assume
     this is a non-opaque draw
    "
    bgPaint isNil ifTrue:[
        opaque := false.
    ].

    gcId isNil ifTrue:[
        self initGC
    ].

    aStringArg isPlainString ifFalse:[
        "
         hook for non-strings (i.e. attributed text)
         that 'thing' should know how to display itself ...
        "
        aStringArg displayOn:self x:x y:y from:index1 to:index2 opaque:opaque.
        ^ self
    ].

    "/ transcode the string into the fonts encoding...
    aString := aStringArg.
    fontsEncoding := font encoding.
    (characterEncoding ~~ fontsEncoding) ifTrue:[
        [
            aString := CharacterEncoder encodeString:aString from:characterEncoding into:fontsEncoding.
        ] on:CharacterEncoderError do:[:ex|
            "substitute a default value for codes that cannot be represented
             in the new character set"
            ex proceedWith:ex defaultValue.
        ].
    ].

    fontUsed := font.
    transformation notNil ifTrue:[
        pX := transformation applyToX:x.
        pY := transformation applyToY:y.
        transformation noScale ifFalse:[
            sz := font size.
            sz notNil ifTrue:[
                fontUsed := font asSize:(transformation applyScaleY:sz) rounded.
            ]
        ]
    ] ifFalse:[
        pX := x.
        pY := y.
    ].

    fontUsed isAlienFont ifTrue:[
        "
         hook for alien fonts
         that 'font' should know how to display the string...
        "
        fontUsed displayString:aString from:index1 to:index2 x:x rounded y:y rounded in:self opaque:opaque maxWidth:maxWidth.
        ^ self
    ].

    pX := pX rounded.
    pY := pY rounded.

    fontUsed := fontUsed onDevice:device.
    deviceFont ~~ fontUsed ifTrue:[
        (fontUsed installInDeviceForGCId:gcId) isNil ifTrue:[
            "error - no such font"
            ^ self.
        ].
        deviceFont := fontUsed.
    ].

    "
     if bgPaint or paint is not a real Color (aka a pattern), we have to do it the hard way ...
    "
    paint isColor ifTrue:[
        easy := true.
        fgId := paint colorId.
        fgId isNil ifTrue:[
            easy := false
        ]
    ] ifFalse:[
        easy := false
    ].
    opaque ifTrue:[
        bgPaint isColor ifTrue:[
            bgId := bgPaint colorId.
            bgId isNil ifTrue:[
                easy := false
            ]
        ] ifFalse:[
            easy := false
        ].
    ].

    pX := pX rounded.
    pY := pY rounded.

    "/ check if this string is too long and cut it into a managable size.
    "/ this is due to win32 limitations which seems to be unable to handle strings
    "/ which are drawn longer than 32k pixels.
    nChars := 500.
    (maxWidth notNil and:[(index2 - index1) > nChars]) ifTrue:[
        nSkipLeft := wSkipLeft := 0.

        "/ if the draw starts to the left of the window start,
        "/ skip some characters at the beginning...
        pX < 0 ifTrue:[
"/ ('x=%d wMax=%d l=%d i1=%d i2=%d' printfWith:x with:maxWidth with:aString size with:index1 with:index2) printCR.
            nSkipLeft := (pX negated // font width) min:index2.                         "/ estimate
            wSkipLeft := fontUsed widthOf:aString from:index1 to:index1+nSkipLeft-1.    "/ actual number of pixels
            [ ((pX+wSkipLeft) > 0) and:[nSkipLeft > 0]] whileTrue:[                      "/ too many
                nSkipLeft := (nSkipLeft * 0.9) rounded.
                wSkipLeft := fontUsed widthOf:aString from:index1 to:index1+nSkipLeft-1.
            ].
            index1 := index1 + nSkipLeft.
            pX := pX + wSkipLeft.
"/ ('skip %d w=%d x=%d' printfWith:nSkipLeft with:wSkipLeft with:x) printCR.
        ].

"/ ('n=%d w=%d' printfWith:nChars with:wString) printCR.
        [
            index2Guess := (index1+nChars-1) min:index2.
            wString := fontUsed widthOf:aString from:index1 to:index2Guess.
            ((pX+wString) < maxWidth) and:[ index2Guess < index2]
        ] whileTrue:[  "/ not enough...
            nChars := (nChars * 1.1) rounded.
        ].
"/ ('n=%d w=%d' printfWith:nChars with:wString) printCR.
        index2 := index2Guess.
    ].

    easy ifTrue:[
        opaque ifTrue:[
            device setForeground:fgId background:bgId in:gcId.
            background := bgPaint.
        ] ifFalse:[
            device setForeground:fgId in:gcId.
        ].
        foreground := paint.
        self displayDeviceString:aString from:index1 to:index2 x:pX y:pY opaque:opaque.
        ^ self
    ].

    "/
    "/ do it the hard way - either forground or background is not a plain color,
    "/ but dithered or a pattern
    "/
    w := fontUsed widthOf:aString from:index1 to:index2.
    h := fontUsed height.

    (fgId notNil and:[function == #copy]) ifTrue:[
        "
         only bg is dithered or a pattern; fill with bg first ...
        "
        savedPaint := paint.
        self paint:bgPaint.
        self fillDeviceRectangleX:pX y:(pY - fontUsed ascent) width:w height:h.
        self paint:savedPaint.

        "
         then draw using fgPaint (which is a real color)
        "
        self displayDeviceString:aString from:index1 to:index2 x:pX y:pY opaque:false.
        ^ self
    ].

    "/ the very hard case (fg-dither)

    self displayDeviceOpaqueString:aString from:index1 to:index2 in:fontUsed x:pX y:pY.

    "Modified: / 30-06-1997 / 15:06:15 / cg"
    "Modified: / 14-04-2011 / 11:11:00 / Stefan Vogel <sv@exept.de>"
!

displayString:aString x:x y:y
    "draw a string at the coordinate x/y -
     draw foreground-pixels only (in current paint-color),
     leaving background as-is. If the transformation involves scaling,
     the font's point-size is scaled as appropriate."

    self displayString:aString from:1 to:aString size x:x y:y opaque:false maxWidth:nil.
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

    |pX pY pO|

    transformation notNil ifTrue:[
	pO := transformation transformPoint:(x@y).
	pX := pO x.
	pY := pO y.
    ] ifFalse:[
	pX := x.
	pY := y.
    ].

    self displayDeviceForm:formToDraw x:pX y:pY

    "Modified: 12.4.1997 / 12:48:04 / cg"
!

displayUnscaledOpaqueForm:formToDraw x:x y:y
    "draw a form or image opaque and unscaled;
     if its a 1-plane bitmap, 1-bits are drawn in the
     current paint-color, 0 bits in background color.
     If its a deep form (i.e. a pixmap) the current paint
     settings are ignored and the form is drawn as-is (opaque).
     The origins coordinate is transformed, but the image itself is unscaled."

    |pX pY pO|

    transformation notNil ifTrue:[
	pO := transformation transformPoint:(x@y).
	pX := pO x.
	pY := pO y.
    ] ifFalse:[
	pX := x.
	pY := y.
    ].

    self displayDeviceOpaqueForm:formToDraw x:pX y:pY

    "Modified: 12.4.1997 / 12:49:21 / cg"
!

displayUnscaledOpaqueString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the transformed coordinate x/y but do not scale the font.
     Draw foreground pixels in paint-color, background pixels in bgPaint color."

    |pX pY pO|

    transformation notNil ifTrue:[
	pO := transformation transformPoint:(x@y).
	pX := pO x.
	pY := pO y.
    ] ifFalse:[
	pX := x.
	pY := y.
    ].
    self displayDeviceOpaqueString:aString from:index1 to:index2 in:font x:pX y:pY
!

displayUnscaledOpaqueString:aString x:x y:y
    "draw a string at the transformed coordinate x/y but do not scale the font.
     Draw foreground pixels in paint-color, background pixels in bgPaint color."

    |pX pY pO|

    transformation notNil ifTrue:[
	pO := transformation transformPoint:(x@y).
	pX := pO x.
	pY := pO y.
    ] ifFalse:[
	pX := x.
	pY := y.
    ].
    self displayDeviceOpaqueString:aString from:1 to:(aString size) in:font x:pX y:pY
!

displayUnscaledString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the transformed coordinate x/y but do not scale the font.
     draw foreground-pixels only (in current paint-color), leaving background as-is."

    |pX pY pO|

    transformation notNil ifTrue:[
	pO := transformation transformPoint:(x@y).
	pX := pO x.
	pY := pO y.
    ] ifFalse:[
	pX := x.
	pY := y.
    ].
    self displayDeviceString:aString from:index1 to:index2 in:font x:pX y:pY
!

displayUnscaledString:aString x:x y:y
    "draw a string at the transformed coordinate x/y but do not scale the font.
     draw foreground-pixels only (in current paint-color), leaving background as-is."

    |pX pY pO|

    transformation notNil ifTrue:[
	pO := transformation transformPoint:(x@y).
	pX := pO x.
	pY := pO y.
    ] ifFalse:[
	pX := x.
	pY := y.
    ].
    self displayDeviceString:aString from:1 to:(aString size) in:font x:pX y:pY
! !

!DeviceGraphicsContext methodsFor:'drawing in device coordinates'!

displayDeviceForm:aForm x:x y:y
    "draw a form or image non opaque (i.e. only foreground color is drawn);
     If its a 1-plane bitmap, 1-bits are drawn in the
     current paint-color, leaving pixels with 0-bits unchanged
     (i.e. only 1-bits are drawn from the form).
     If its a deep form (i.e. a pixmap) the current paint
     settings are ignored and the form is drawn as-is;
     however, the mask is applied if present.

     The form should have been allocated on the same device,
     otherwise its converted here, which slows down the draw.
     No transformation or scaling is done.
     Care must be taken, that the paint color is correctly allocated
     (by sending #on: to the color) before doing so.
     Using functions other than #copy only makes sense if you are
     certain, that the colors are real colors (actually, only for
     noColor or allColor)."

    |id w h easy paintDither depth tmpForm tmpId tmpGCId
     fgId noColor allColor allBits pX pY
     mask maskId deviceForm deviceFormGCId deviceMask deviceMaskGcId colorMap|

    w := aForm width.
    h := aForm height.
    (w = 0 or:[h = 0]) ifTrue:[^ self].

    pX := x rounded.
    pY := y rounded.

    deviceForm := aForm asFormOn:device.
    deviceForm isNil ifTrue:[
        Logger warning:'cannot create device-form'.
        ^self
    ].
    id := deviceForm drawableId.
    "temporary ... what the heck is this??"
    (id isNil
     or:[aForm graphicsDevice ~~ device]) ifTrue:[
        deviceForm := deviceForm asFormOn:device.
        id := deviceForm drawableId.
        id isNil ifTrue:[
            Logger warning:'invalid form draw - ignored'.
            ^ self
        ].
    ].

    gcId isNil ifTrue:[
        self initGC
    ].
    "/ device needGCForBitmapSource  - i.e. WIN32
    device isWindowsPlatform ifTrue:[
        deviceFormGCId := deviceForm initGC.
    ].

    "
     a deep form ignores paint/bgPaint settings
    "
    mask := aForm mask.
    depth := aForm depth.

    (mask notNil or:[depth ~~ 1]) ifTrue:[
        mask notNil ifTrue:[
            mask depth ~~ 1 ifTrue:[
                'DEVGC: alpha channel not yet supported' errorPrintCR.
            ] ifFalse:[
                deviceMask := mask asFormOn:device.
                deviceMask isNil ifTrue:[
                    'DeviceGraphicsContext [warning]: cannot create device-mask' errorPrintCR.
                    ^self
                ].
                maskId := deviceMask drawableId.
                maskId notNil ifTrue:[
                    deviceMaskGcId := deviceMask initGC.
                    allColor := Color allColor.
                    allBits := allColor colorId.

                    (aForm maskedPixelsAre0
                     and:[depth == 1 or:[deviceForm depth == device depth]]) ifTrue:[
                        "/ can do it without a temporary pixmap:
                        "/   or-in the form into the inverse stamped-out area
                        "/   of the destination.
                        "/   Oring is of course only possible if we know that
                        "/   masked pixels are already zero in the form.

                        "/ stamp out using mask
                        device
                            setForeground:0 background:allBits in:gcId;
                            setFunction:#and in:gcId;
                            copyPlaneFromPixmapId:maskId
                                x:0
                                y:0
                                gc:deviceMaskGcId
                                to:drawableId
                                x:pX
                                y:pY
                                gc:gcId
                                width:w
                                height:h.

                        "/ or-in the form
                        device setFunction:#or in:gcId.
                        depth == 1 ifTrue:[
                            (colorMap := deviceForm colorMap) notNil ifTrue:[
                                colorMap size < 2 ifTrue:[
                                    device
                                        setForegroundColor:(colorMap at:1)
                                        backgroundColor:(Color noColor)
                                        in:gcId.
                                ] ifFalse:[
                                    device
                                        setForegroundColor:(colorMap at:2)
                                        backgroundColor:(colorMap at:1)
                                        in:gcId.
                                ]
                            ].
                            device
                                copyPlaneFromPixmapId:id
                                x:0
                                y:0
                                gc:deviceFormGCId
                                to:drawableId
                                x:pX
                                y:pY
                                gc:gcId
                                width:w
                                height:h.
                        ] ifFalse:[
                            device
                                copyFromPixmapId:id
                                x:0
                                y:0
                                gc:deviceFormGCId
                                to:drawableId
                                x:pX
                                y:pY
                                gc:gcId
                                width:w
                                height:h.
                        ].
                    ] ifFalse:[
                        "/ must do it slow, using a temporary form ..

                        "
                         create temp-form;
                        "
                        tmpForm := Form width:w height:h depth:device depth onDevice:device.
                        tmpForm isNil ifTrue:[
                            'DeviceGraphicsContext [warning]: cannot create temp form' errorPrintCR.
                            ^ self
                        ].
                        tmpId := tmpForm drawableId.
                        tmpGCId := tmpForm initGC.

                        "
                         fill tempform with image
                        "
                        depth == 1 ifTrue:[
                            (colorMap := deviceForm colorMap) notNil ifTrue:[
                                colorMap size < 2 ifTrue:[
                                    device
                                        setForegroundColor:(colorMap at:1)
                                        in:tmpGCId.
                                ] ifFalse:[
                                    device
                                        setForegroundColor:(colorMap at:2)
                                        backgroundColor:(colorMap at:1)
                                        in:tmpGCId.
                                ]
                            ].
                            device
                                copyPlaneFromPixmapId:id
                                x:0
                                y:0
                                gc:deviceFormGCId
                                to:tmpId
                                x:0
                                y:0
                                gc:tmpGCId
                                width:w
                                height:h.
                        ] ifFalse:[
                            device
                                copyFromPixmapId:id
                                x:0
                                y:0
                                gc:deviceFormGCId
                                to:tmpId
                                x:0
                                y:0
                                gc:tmpGCId
                                width:w
                                height:h.
                        ].

                        "
                         stamp out mask in temp form
                         set unmasked pixels to allBits and masked pixels to 0
                        "
                        device
                            setForeground:allBits background:0 in:tmpGCId;
                            setFunction:#and in:tmpGCId;
                            copyPlaneFromPixmapId:maskId
                                x:0
                                y:0
                                gc:deviceMaskGcId
                                to:tmpId
                                x:0
                                y:0
                                gc:tmpGCId
                                width:w
                                height:h.
"/Debug = 1 ifTrue:[
"/    Debug := 0.
"/    tmpForm asImage inspect.
"/    deviceForm inspect.
"/].

                        "
                         stamp out mask in destination
                         set unmasked pixels to 0 and masked pixels to allBits
                        "
                        device
                            setForeground:0 background:allBits in:gcId;
                            setFunction:#and in:gcId;
                            copyPlaneFromPixmapId:maskId
                                x:0
                                y:0
                                gc:deviceMaskGcId
                                to:drawableId
                                x:pX
                                y:pY
                                gc:gcId
                                width:w
                                height:h.

                        "
                         or-in tempform-bits ...
                        "
                        device
                            setForeground:0 background:0 in:gcId;
                            setFunction:#or in:gcId;
                            copyFromPixmapId:tmpId
                                x:0
                                y:0
                                gc:tmpGCId
                                to:drawableId
                                x:pX
                                y:pY
                                gc:gcId
                                width:w
                                height:h.

                        "
                         release tempForm immediately
                         (although GC will eventually do it,
                          this creates less stress to the Xserver in the meanwhile ...)
                        "
                        tmpForm destroy.
                    ].

                    "/ restore GC
                    foreground notNil ifTrue:[
                        device setForegroundColor:foreground in:gcId.
                    ].
                    background notNil ifTrue:[
                        device setBackgroundColor:background in:gcId
                    ].
                    device setFunction:function in:gcId.
                    ^ self
                ]
            ]
        ].

        device
            copyFromPixmapId:id
            x:0
            y:0
            gc:deviceFormGCId
            to:drawableId
            x:pX
            y:pY
            gc:gcId
            width:w
            height:h.
        ^ self
    ].

    "
     the following code is somewhat complicated, since it has to deal
     with dithered paint colors, which cannot be done directly on most
     devices (actually, a test for the devices capabilities has to be added here)
     (just assume drawing a bitmap with dithered paint color ... sigh)
    "

    easy := (function == #copy).

    "
     if paint is not a real color, we have to do it the hard way ...
    "
    easy ifTrue:[
        paint isColor ifTrue:[
            paintDither := paint ditherForm.
            paintDither notNil ifTrue:[
                easy := false.
            ]
        ] ifFalse:[
            paintDither := paint.
            easy := false
        ].
    ].

    allColor := Color allColor.
    allBits := allColor colorId.

    easy ifTrue:[
        "
         paint is a real color
        "

        "
         if paint color is all-0 or all-1's, we can do it in one
         operation ...
        "
        fgId := paint colorId.

        ((fgId ~~ ((1 bitShift:device depth)-1))
        and:[fgId ~~ allBits]) ifTrue:[
            "
             clear fg-bits ...
            "
            device setForeground:0 background:allBits in:gcId.
            device setFunction:#and in:gcId.
            device
                copyPlaneFromPixmapId:id
                x:0
                y:0
                gc:deviceFormGCId
                to:drawableId
                x:pX
                y:pY
                gc:gcId
                width:w
                height:h.
        ].

        fgId ~~ 0 ifTrue:[
            "
             or-in fg-bits ...
            "
            device setForeground:fgId background:0 in:gcId.
            device setFunction:#or in:gcId.
            device
                copyPlaneFromPixmapId:id
                x:0
                y:0
                gc:deviceFormGCId
                to:drawableId
                x:pX
                y:pY
                gc:gcId
                width:w
                height:h
        ].
        "
         flush foreground/background cache
        "
        foreground := nil.
        background := nil.
        device setFunction:function in:gcId.
        ^ self
    ].

    function == #or ifTrue:[
        easy := paint notNil
                and:[paint isColor
                and:[paint ditherForm isNil]].
        easy ifTrue:[
            easy := bgPaint isNil
                        or:[bgPaint isColor
                            and:[bgPaint colorId == 0]]
        ].
        easy ifTrue:[
            fgId := paint colorId.

            fgId ~~ 0 ifTrue:[
                "
                 or-in fg-bits ...
                "
                device setForeground:fgId background:0 in:gcId.
                device
                    copyPlaneFromPixmapId:id
                    x:0
                    y:0
                    gc:deviceFormGCId
                    to:drawableId
                    x:pX
                    y:pY
                    gc:gcId
                    width:w
                    height:h
            ].
            "
             flush foreground/background cache
            "
            foreground := nil.
            background := nil.
            ^ self
        ].
    ].

    "
     hard case; paint is a dithered color
    "

    noColor := Color noColor.

    "
     create temp-form;
    "
    tmpForm := Form width:w height:h depth:device depth onDevice:device.
    tmpForm isNil ifTrue:[
        'DeviceGraphicsContext [warning]: cannot create temp form' errorPrintCR.
        ^self
    ].
    "
     fill tempform
    "
    tmpForm paint:paint.
    tmpForm fillRectangleX:0 y:0 width:w height:h.
    "
     stamp out background
    "
    tmpForm paint:allColor on:noColor.
    tmpForm function:#and.
    tmpForm displayOpaqueForm:deviceForm x:0 y:0.
    "
     stamp out foreground from destination
    "
    device setForeground:0 background:allBits in:gcId.
    device setFunction:#and in:gcId.
    device
        copyPlaneFromPixmapId:id
        x:0
        y:0
        gc:deviceFormGCId
        to:drawableId
        x:pX
        y:pY
        gc:gcId
        width:w
        height:h.
    "
     or-in temp into destination
    "
    device setForeground:allBits background:0 in:gcId.
    device setFunction:#or in:gcId.

    device
        copyFromPixmapId:tmpForm drawableId
        x:0
        y:0
        gc:tmpForm gcId
        to:drawableId
        x:pX
        y:pY
        gc:gcId
        width:w
        height:h.

    "
     release tempForm immediately
     (although GC will eventually do it,
      this creates less stress to the Xserver in the meanwhile ...)
    "

    tmpForm destroy.
    "
     flush foreground/background cache
    "
    foreground := nil.
    background := nil.
    device setFunction:function in:gcId.

    "Modified: / 27-05-2007 / 12:45:10 / cg"
!

displayDeviceLineFromX:x0 y:y0 toX:x1 y:y1
    "draw a line (with current paint-color) in device coordinate space.
     This ignores any transformations. The coordinates must be integers."

    gcId isNil ifTrue:[
	self initGC
    ].
    device displayLineFromX:x0 y:y0 toX:x1 y:y1 in:drawableId with:gcId
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

    |id w h easy savedPaint bgForm fgForm tmpForm
     fgId bgId noColor allColor allBits dx dy
     pX pY deviceDepth deviceForm deviceFormGCId map|

    deviceForm := aForm asFormOn:device.
    id := deviceForm drawableId.

    "temporary ..."
    (id isNil
     or:[aForm graphicsDevice ~~ device]) ifTrue:[
        deviceForm := deviceForm asFormOn:device.
        id := deviceForm drawableId.
        id isNil ifTrue:[
            Logger warning:'invalid form draw (opaque) - ignored'.
            ^ self
        ].
    ].

    gcId isNil ifTrue:[
        self initGC
    ].
    deviceFormGCId := deviceForm initGC.

    w := aForm width.
    h := aForm height.

    pX := x rounded.
    pY := y rounded.

    "
     a deep form ignores paint/bgPaint settings
     and is always drawn opaque.
    "
    (aForm depth ~~ 1) ifTrue:[
        device
            copyFromPixmapId:id
            x:0
            y:0
            gc:deviceFormGCId
            to:drawableId
            x:pX
            y:pY
            gc:gcId
            width:w
            height:h.
        ^ self
    ].
    map := aForm colorMap.
    map notNil ifTrue:[
        paint := map at:2.
        bgPaint := map at:1.
    ].

    "/ if no bgPaint is set, this is a non-opaque draw

    bgPaint isNil ifTrue:[
        self displayDeviceForm:aForm x:x y:y.
        ^ self
    ].

    "the following code is somewhat complicated, since it has to deal
     with dithered fg/bg colors, which cannot be done directly on most
     devices (actually, a test for the devices capabilities has to be added here)
     (just assume drawing a bitmap with dithered fg/bg colors ... sigh)
    "

    "
     if bgPaint or paint is not a real color, we have to do it the hard way ...
    "
    easy := true.
    paint isColor ifFalse:[
        easy := false
    ] ifTrue:[
        fgId := paint colorId.
        fgId isNil ifTrue:[
            easy := false
        ]
    ].
    bgPaint isColor ifFalse:[
        easy := false
    ] ifTrue:[
        bgId := bgPaint colorId.
        bgId isNil ifTrue:[
            easy := false
        ]
    ].

    easy ifTrue:[
        "
         easy: both paint and bgPaint are real colors
        "
        ((foreground ~~ paint) or:[background ~~ bgPaint]) ifTrue:[
            device setForeground:fgId background:bgId in:gcId.
            foreground := paint.
            background := bgPaint.
        ].
        device
            copyPlaneFromPixmapId:id
            x:0
            y:0
            gc:deviceFormGCId
            to:drawableId
            x:pX
            y:pY
            gc:gcId
            width:w
            height:h.
        ^ self
    ].

    "
     hard case: paint and/or bgPaint are dithered or patterns
    "
    allColor := Color allColor.
    allBits := allColor colorId.
    deviceDepth := device depth.

    (fgId notNil and:[function == #copy]) ifTrue:[
        "
         only bg is dithered; fill with bg first ...
        "
        savedPaint := paint.
        self paint:bgPaint.
        self fillDeviceRectangleX:pX y:pY width:w height:h.
        self paint:savedPaint.

        "
         if paint color is all-0 or all-1's, we can do it in one
         operation ...
        "
        ((fgId ~~ ((1 bitShift:deviceDepth)-1))
        and:[fgId ~~ allBits]) ifTrue:[
            "
             clear fg-bits ...
            "
            device setForeground:0 background:allBits in:gcId.
            device setFunction:#and in:gcId.
            device
                copyPlaneFromPixmapId:id
                x:0
                y:0
                gc:deviceFormGCId
                to:drawableId
                x:pX
                y:pY
                gc:gcId
                width:w
                height:h
        ].

        fgId ~~ 0 ifTrue:[
            "
             or-in fg-bits ...
            "
            device setForeground:fgId background:0 in:gcId.
            device setFunction:#or in:gcId.
            device
                copyPlaneFromPixmapId:id
                x:0
                y:0
                gc:deviceFormGCId
                to:drawableId
                x:pX
                y:pY
                gc:gcId
                width:w
                height:h
        ].
        "
         flush foreground/background cache
        "
        foreground := nil.
        background := nil.
        device setFunction:function in:gcId.
        ^ self
    ].

    (bgId notNil and:[function == #copy]) ifTrue:[
        "
         only fg is dithered; fill with fg first ...
        "
        self fillDeviceRectangleX:pX y:pY width:w height:h.

        "
         if paint color is all-0 or all-1's, we can do it in one
         operation ...
        "
        ((bgId ~~ ((1 bitShift:deviceDepth)-1))
        and:[bgId ~~ allBits]) ifTrue:[
            "
             clear bg-bits ...
            "
            device setForeground:allBits background:0 in:gcId.
            device setFunction:#and in:gcId.
            device
                copyPlaneFromPixmapId:id
                x:0
                y:0
                gc:deviceFormGCId
                to:drawableId
                x:pX
                y:pY
                gc:gcId
                width:w
                height:h
        ].

        "
         or-in bg-bits ...
        "
        bgId ~~ 0 ifTrue:[
            device setForeground:0 background:bgId in:gcId.
            device setFunction:#or in:gcId.
            device
                copyPlaneFromPixmapId:id
                x:0
                y:0
                gc:deviceFormGCId
                to:drawableId
                x:pX
                y:pY
                gc:gcId
                width:w
                height:h
        ].
        "
         flush foreground/background cache
        "
        foreground := nil.
        background := nil.
        device setFunction:function in:gcId.
        ^ self
    ].

    "
     very hard case; both fg and bg are dithered colors
    "
    noColor := Color noColor.

    "
     create temp-forms;
    "
    bgForm := Form width:w height:h depth:deviceDepth onDevice:device.
    fgForm := Form width:w height:h depth:deviceDepth onDevice:device.
    tmpForm := Form width:w height:h depth:deviceDepth onDevice:device.

    "
     fill
    "
    dx := dy := 0.
    maskOrigin notNil ifTrue:[
        dx := maskOrigin x.
        dy := maskOrigin y
    ].

    bgForm paint:bgPaint.
    bgForm maskOriginX:(x negated + dx) y:(y negated + dy).
    bgForm fillRectangleX:0 y:0 width:w height:h.
    fgForm paint:paint.
    fgForm maskOriginX:(x negated + dx) y:(y negated + dy).
    fgForm fillRectangleX:0 y:0 width:w height:h.

    "
     stamp-out background
    "
    bgForm paint:noColor on:allColor.
    bgForm function:#and.
    bgForm displayOpaqueForm:deviceForm x:0 y:0.

    "
     stamp-out foreground
    "
    fgForm paint:allColor on:noColor.
    fgForm function:#and.
    fgForm displayOpaqueForm:deviceForm x:0 y:0.

    "
     clear tempform
    "
    tmpForm paint:noColor.
    tmpForm fillRectangleX:0 y:0 width:w height:h.

    "
     merge fg-temp and bg-temp into tmp
    "
    tmpForm function:#or.
    tmpForm paint:noColor on:allColor.
    tmpForm copyFrom:fgForm x:0 y:0 toX:0 y:0 width:w height:h.
    tmpForm copyFrom:bgForm x:0 y:0 toX:0 y:0 width:w height:h.

    "
     finally, draw it
    "
    device setForeground:0 background:allBits in:gcId.
    device
        copyFromPixmapId:tmpForm drawableId
        x:0
        y:0
        gc:tmpForm gcId
        to:drawableId
        x:pX
        y:pY
        gc:gcId
        width:w
        height:h.

    "
     release tempForms immediately
     (although GC will eventually do it,
      this creates less stress to the Xserver in the meanwhile ...)
    "
    fgForm destroy.
    bgForm destroy.
    tmpForm destroy.

    "
     flush foreground/background cache
    "
    foreground := nil.
    background := nil.

    "Modified: 22.4.1997 / 21:44:10 / cg"
!

displayDeviceOpaqueString:aStringArg from:index1 to:index2 in:fontArg x:x y:y
    "draw a substring at the coordinate x/y - draw foreground pixels in
     paint-color and background pixels in bgPaint-color.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors.
     No translation or scaling is done."

    |easy w h savedPaint fgId bgId allColor allBits noColor bgForm fgForm tmpForm maskForm dx dy pX pY fontUsed aString
     deviceDepth fontsEncoding ascent|

    "
     if backgroundPaint color is nil, we assume
     this is a non-opaque draw
    "
    bgPaint isNil ifTrue:[
        self displayDeviceString:aString from:index1 to:index2 in:font x:x y:y.
        ^ self
    ].

    gcId isNil ifTrue:[
        self initGC
    ].

    fontUsed := fontArg onDevice:device.
    deviceFont ~~ fontUsed ifTrue:[
        (fontUsed installInDeviceForGCId:gcId) isNil ifTrue:[
            "error - no such font"
            ^ self.
        ].
        deviceFont := fontUsed.
    ].

    (aString notNil 
    and:[aString isPlainString not]) ifTrue:[
        "
         hook for non-strings (i.e. attributed text)
         that 'thing' should know how to display itself ...
        "
        aString displayOpaqueOn:self x:x y:y from:index1 to:index2.
        ^ self
    ].

    pX := x rounded.
    pY := y rounded.

    aString := aStringArg.

    fontsEncoding := fontUsed encoding.
    "/ This is now obsolete, as we are always using unicode internally.
    "/ so the next line should be changed to fontsEncoding ~~ #unicode
    (characterEncoding ~~ fontsEncoding) ifTrue:[
        [
            aString := CharacterEncoder encodeString:aString from:characterEncoding into:fontsEncoding.
        ] on:CharacterEncoderError do:[:ex|
            "substitute a default value for codes that cannot be represented
             in the new character set"
            ex proceedWith:ex defaultValue.
        ].
    ].

    fontUsed isAlienFont ifTrue:[
        "
         hook for alien fonts
         that 'font' should know how to display the string ...
        "
        fontUsed displayOpaqueString:aString from:index1 to:index2 x:pX y:pY in:self.
        ^ self
    ].

    "
     if bgPaint or paint is not a real Color, we have to do it the hard way ...
    "
    easy := true.
    paint isColor ifFalse:[
        easy := false
    ] ifTrue:[
        fgId := paint colorId.
        fgId isNil ifTrue:[
            easy := false
        ]
    ].
    bgPaint isColor ifFalse:[
        easy := false
    ] ifTrue:[
        bgId := bgPaint colorId.
        bgId isNil ifTrue:[
            easy := false
        ]
    ].

    easy ifTrue:[
        device setForeground:fgId background:bgId in:gcId.
        foreground := paint.
        background := bgPaint.
        self displayDeviceString:aString from:index1 to:index2 x:pX y:pY opaque:true.
        ^ self
    ].

    w := fontUsed widthOf:aString from:index1 to:index2.
    h := fontUsed height.
    ascent := fontUsed ascent.

    (fgId notNil and:[function == #copy]) ifTrue:[
        "
         only bg is dithered; fill with bg first ...
        "
        savedPaint := paint.
        self paint:bgPaint.
        self fillRectangleX:pX y:(pY - ascent) width:w height:h.
        self paint:savedPaint.

        "
         then draw using fgPaint (which is a real color)
        "
        self displayDeviceString:aString from:index1 to:index2 x:pX y:pY opaque:false.
        ^ self
    ].

    allColor := Color allColor.
    allBits := allColor colorId.

    deviceDepth := device depth.

    "
     the code below is correct, but some (all?) implementations of the
     X Window system seem to not support ALU-functions when drawing opaque strings.
     Therefore we use the slower code below.
    "

"/    (bgId notNil and:[function == #copy]) ifTrue:[
"/      "
"/       only fg is dithered; fill with fg first ...
"/      "
"/      self fillRectangleX:pX y:(pY - fontUsed ascent) width:w height:h.
"/
"/      "
"/       if bgPaint color is all-0 or all-1's, we can do it in one
"/       operation ...
"/      "
"/      ((bgId ~~ ((1 bitShift:deviceDepth)-1))
"/      and:[bgId ~~ allBits]) ifTrue:[
"/          "
"/           clear bg bits ...
"/          "
"/          device setForeground:allBits background:0 in:gcId.
"/          device setFunction:#and in:gcId.
"/          device displayOpaqueString:s
"/                                from:index1 to:index2
"/                                   x:pX y:pY
"/                                  in:drawableId with:gcId.
"/      ].
"/
"/      "
"/       or-in bg bits ...
"/      "
"/      bgId ~~ 0 ifTrue:[
"/          device setForeground:0 background:bgId in:gcId.
"/          device setFunction:#or in:gcId.
"/          device displayOpaqueString:s
"/                                from:index1 to:index2
"/                                   x:pX y:pY
"/                                  in:drawableId with:gcId.
"/      ].
"/      "
"/       flush foreground/background cache
"/      "
"/      foreground := nil.
"/      background := nil.
"/      device setFunction:function in:gcId.
"/      ^ self
"/  ].

    (bgId notNil and:[function == #copy]) ifTrue:[
        "
         only fg is dithered; fill with bg first ...
        "
        device setForeground:bgId in:gcId.
        device setFunction:#copy in:gcId.
        device setBitmapMask:nil in:gcId.
        self fillRectangleX:pX y:(pY - ascent) width:w height:h.

        mask notNil ifTrue:[
            "/ draw fg dithered
            (mask depth == 1) ifTrue:[
                device setBitmapMask:mask drawableId in:gcId.
                device setForegroundColor:foreground backgroundColor:background in:gcId.
            ] ifFalse:[
                device setPixmapMask:mask drawableId in:gcId
            ].
        ].

        self displayString:aString from:index1 to:index2 x:pX y:pY opaque:false.
        ^ self.
    ].

    "
     very hard case, both fg and bg are dithered colors/images
    "
    noColor := Color noColor.

    "
     create temp-forms;
    "
    bgForm := Form width:w height:h depth:deviceDepth onDevice:device.
    fgForm := Form width:w height:h depth:deviceDepth onDevice:device.
    tmpForm := Form width:w height:h depth:deviceDepth onDevice:device.
    maskForm := Form width:w height:h depth:deviceDepth onDevice:device.

    "
     fill
    "
    dx := 0.
    dy := ascent.
    maskOrigin notNil ifTrue:[
        dx := maskOrigin x.
        dy := dy + maskOrigin y
    ].

    bgForm paint:bgPaint.
    bgForm maskOriginX:(pX negated + dx) y:(pY negated + dy).
    bgForm fillRectangleX:0 y:0 width:w height:h.

    fgForm paint:paint.
    fgForm maskOriginX:(pX negated + dx) y:(pY negated + dy).
    fgForm fillRectangleX:0 y:0 width:w height:h.

    "
     stamp-out background (have now bg-bits with fg=0 in bgForm)
    "
    bgForm font:fontUsed.
    bgForm paint:noColor on:allColor.
    bgForm function:#and.
    bgForm displayString:aString from:index1 to:index2 x:0 y:ascent.

    "
     stamp-out foreground
    "
    maskForm font:fontUsed.
    maskForm paint:allColor on:noColor.
    maskForm displayString:aString from:index1 to:index2 x:0 y:ascent opaque:true.

    fgForm function:#and.
    fgForm copyFrom:maskForm x:0 y:0 toX:0 y:0 width:w height:h.

    "
     clear tempform
    "
    tmpForm paint:noColor.
    tmpForm fillRectangleX:0 y:0 width:w height:h.

    "
     merge fg-temp and bg-temp into tmp
    "
    tmpForm function:#or.
    tmpForm paint:noColor on:allColor.
    tmpForm copyFrom:fgForm x:0 y:0 toX:0 y:0 width:w height:h.
    tmpForm copyFrom:bgForm x:0 y:0 toX:0 y:0 width:w height:h.
    "
     finally, draw it
    "
    device setForeground:0 background:allBits in:gcId.
    device
        copyFromId:tmpForm drawableId
        x:0 y:0 gc:tmpForm gcId
        to:drawableId
        x:pX y:(pY-ascent) gc:gcId
        width:w height:h.

    "
     release tempForms immediately
     (although GC will eventually do it,
      this creates less stress to the Xserver in the meanwhile ...)
    "
    tmpForm destroy.
    fgForm destroy.
    bgForm destroy.
    maskForm destroy.

    "
     flush foreground/background cache
    "
    foreground := nil.
    background := nil.

    "Modified: 1.7.1997 / 17:08:46 / cg"
!

displayDeviceOpaqueString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the coordinate x/y - draw foreground pixels in
     paint-color and background pixels in bgPaint-color.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors.
     No translation or scaling is done."

    self displayDeviceOpaqueString:aString from:index1 to:index2 in:font x:x y:y
!

displayDeviceOpaqueString:aString x:x y:y
    "draw a string at the coordinate x/y - draw foreground pixels in
     paint-color and background pixels in bgPaint-color.
     No translation or scaling is done"

    self displayDeviceOpaqueString:aString from:1 to:(aString size) in:font x:x y:y
!

displayDeviceString:aStringArg from:index1 to:index2 in:fontArg x:x y:y
    "draw a substring at the coordinate x/y -
     draw foreground-pixels only (in current paint-color), leaving background as-is.
     No translation or scaling is done"

    |fontUsed aString fontsEncoding|

    "
     hook for non-strings (i.e. attributed text)
    "
    aString isPlainString ifFalse:[
        ^ aString displayOn:self x:x y:y from:index1 to:index2
    ].

    gcId isNil ifTrue:[
        self initGC
    ].

    fontUsed := fontArg onDevice:device.
    deviceFont ~~ fontUsed ifTrue:[
        (fontUsed installInDeviceForGCId:gcId) isNil ifTrue:[
            "error - no such font"
            ^ self.
        ].
        deviceFont := fontUsed.
    ].

    aString := aStringArg.

    fontsEncoding := fontUsed encoding.
    (characterEncoding ~~ fontsEncoding) ifTrue:[
        [
            aString := CharacterEncoder encodeString:aString from:characterEncoding into:fontsEncoding.
        ] on:CharacterEncoderError do:[:ex|
            "substitute a default value for codes that cannot be represented
             in the new character set"
            ex proceedWith:ex defaultValue.
        ].
    ].
    fontUsed isAlienFont ifTrue:[
        "
         hook for alien fonts
         that 'font' should know how to display the string ...
        "
        fontUsed displayString:aString from:index1 to:index2 x:x rounded y:y rounded in:self.
        ^ self
    ].

    self displayDeviceString:aString from:index1 to:index2 x:x y:y opaque:false.

    "Modified: 1.7.1997 / 17:08:48 / cg"
!

displayDeviceString:aString from:index1 to:index2 x:x y:y
    "draw a substring at the coordinate x/y -
     draw foreground-pixels only (in current paint-color), leaving background as-is.
     No translation or scaling is done"

    self displayDeviceString:aString from:index1 to:index2 in:font x:x y:y
!

displayDeviceString:aString from:index1 to:index2 x:x y:y opaque:opaque
    "draw a substring at the coordinate x/y -
     draw foreground-pixels only (in current paint-color), leaving background as-is.
     No translation or scaling is done"

    gcId isNil ifTrue:[
        self initGC
    ].

    device displayString:aString from:index1 to:index2 x:x rounded y:y rounded in:drawableId with:gcId opaque:opaque.
!

displayDeviceString:aString x:x y:y
    "draw a string at the coordinate x/y -
     draw foreground-pixels only (in current paint-color), leaving background as-is.
     No translation or scaling is done"

    self displayDeviceString:aString from:1 to:(aString size) in:font x:x y:y
!

fillDeviceRectangleX:x y:y width:w height:h
    "draw a filled rectangle in device coordinate space.
     This ignores any transformations. The coordinates must be integers."

    gcId isNil ifTrue:[
        self initGC
    ].
    device
        fillRectangleX:x y:y
        width:w height:h
        in:drawableId with:gcId
! !

!DeviceGraphicsContext methodsFor:'evaluating in another context'!

reverseDo:aBlock
    "evaluate aBlock with foreground and background interchanged.
     This can be reimplemented here in a faster way."

    |oldFg oldBg|

    oldFg := foreground.
    oldBg := background.
    self foreground:background background:foreground.
    aBlock value.
    self foreground:oldFg background:oldBg
!

withBackground:fgColor do:aBlock
    "evaluate aBlock with changed background."

    |oldBg|

    oldBg := background.
    self background:fgColor.
    aBlock value.
    self background:oldBg
!

withForeground:fgColor background:bgColor do:aBlock
    "evaluate aBlock with changed foreground and background."

    |oldFg oldBg|

    oldFg := foreground.
    oldBg := background.
    self foreground:fgColor background:bgColor.
    aBlock value.
    self foreground:oldFg background:oldBg
!

withForeground:fgColor background:bgColor function:aFunction do:aBlock
    "evaluate aBlock with foreground, background and function"

    |oldFg oldBg oldFun|

    oldFg := foreground.
    oldBg := background.
    oldFun := function.
    self foreground:fgColor background:bgColor function:aFunction.
    aBlock value.
    self foreground:oldFg background:oldBg function:oldFun
!

withForeground:fgColor background:bgColor mask:aMask do:aBlock
    "evaluate aBlock with foreground, background and mask"

    |oldFg oldBg oldMask|

    oldFg := foreground.
    oldBg := background.
    oldMask := mask.
    self foreground:fgColor background:bgColor.
    self mask:aMask.
    aBlock value.
    self foreground:oldFg background:oldBg.
    self mask:oldMask
!

withForeground:fgColor do:aBlock
    "evaluate aBlock with changed foreground."

    |oldFg|

    oldFg := foreground.
    self foreground:fgColor.
    aBlock value.
    self foreground:oldFg
!

withForeground:fgColor function:aFunction do:aBlock
    "evaluate aBlock with changed foreground and function."

    |oldFg oldFun|

    oldFg := foreground.
    oldFun := function.
    self foreground:fgColor background:background function:aFunction.
    aBlock value.
    self foreground:oldFg background:background function:oldFun
!

withPaint:aColor do:aBlock
    "evaluate aBlock with changed paint color."

    |oldPaint|

    oldPaint := paint.
    self paint:aColor.
    aBlock value.
    self paint:oldPaint
!

xoring:aBlock
    "evaluate aBlock with function xoring"

    |fgPixel bgPixel oldFunction|

    fgPixel := device blackpixel.
    bgPixel := device whitepixel.

    gcId isNil ifTrue:[
	self initGC
    ].
    oldFunction := function.
    device setForeground:(fgPixel bitXor:bgPixel)
	      background:bgPixel
		      in:gcId.
    device setFunction:#xor in:gcId.
    aBlock value.

    paint := bgPaint := nil.        "invalidate"
    foreground := device blackColor.
    background := device whiteColor.
    device setForeground:fgPixel background:bgPixel in:gcId.
    device setFunction:oldFunction in:gcId.
    function := oldFunction

    "Modified: / 10.9.1998 / 12:17:39 / cg"
! !

!DeviceGraphicsContext methodsFor:'filling'!

clearDeviceRectangleX:x y:y width:w height:h
    "clear a rectangular area to background"

    |oldPaint|

    oldPaint := paint.
    self paint:bgPaint.
    self fillDeviceRectangleX:x y:y width:w height:h.
    self paint:oldPaint
!

clearRectangleX:left y:top width:w height:h
    "clear the rectangular area in the receiver to background"

    |oldPaint|

    oldPaint := paint.
    self paint:bgPaint.
    self fillRectangleX:left y:top width:w height:h.
    self paint:oldPaint
!

fillArcX:x y:y width:w height:h from:startAngle angle:angle
    "draw a filled arc; apply transformation if nonNil"

    |pX pY nW nH sA a pO pC|

    gcId isNil ifTrue:[
	self initGC
    ].
    transformation notNil ifTrue:[
	pO := transformation transformPoint:x@y.
	pC := transformation transformPoint:(x+w-1)@(y+h-1).
	pX := pO x.
	pY := pO y.
	nW := pC x - pX + 1.
	nH := pC y - pY + 1.
	nW < 0 ifTrue:[
	      nW := nW abs.
	      pX := pX - nW.
	].
	nH < 0 ifTrue:[
	      nH := nH abs.
	      pY := pY - nH.
	].
    ] ifFalse:[
	pX := x.
	pY := y.
	nW := w.
	nH := h.
    ].

    pX := pX rounded.
    pY := pY rounded.
    nW := nW rounded.
    nH := nH rounded.

    sA := startAngle.
    sA isInteger ifFalse:[sA := sA asFloat].
    a := angle.
    a isInteger ifFalse:[a := a asFloat].

    device
	  fillArcX:pX
		 y:pY
	     width:nW
	    height:nH
	      from:sA
	     angle:a
		in:drawableId
	      with:gcId

    "Created: 8.5.1996 / 08:29:45 / cg"
    "Modified: 4.6.1996 / 17:58:21 / cg"
!

fillPolygon:aPolygon
    "draw a filled polygon; apply transformation if nonNil"

    |newPolygon|

    gcId isNil ifTrue:[
	self initGC
    ].
    transformation notNil ifTrue:[
	newPolygon := aPolygon collect:[:point | transformation transformPoint:point].
    ] ifFalse:[
	newPolygon := aPolygon
    ].
    (newPolygon contains:[:p |
	(p isPoint not
	or:[(p x class ~~ SmallInteger)
	or:[(p y class ~~ SmallInteger)]])
     ]) ifTrue:[
	newPolygon := newPolygon collect:[:p | p asPoint rounded]
    ].
    device
	fillPolygon:newPolygon
		 in:drawableId
	       with:gcId
!

fillRectangleX:x y:y width:w height:h
    "draw a filled rectangle; apply transformation if nonNil"

    |pX pY nW nH pO pC|

    gcId isNil ifTrue:[
	self initGC
    ].
    transformation notNil ifTrue:[
	pO := transformation transformPoint:x@y.
	pC := transformation transformPoint:(x+w-1)@(y+h-1).
	pX := pO x.
	pY := pO y.
	nW := pC x - pX + 1.
	nH := pC y - pY + 1.

	nW < 0 ifTrue:[
	      nW := nW abs.
	      pX := pX - nW.
	].
	nH < 0 ifTrue:[
	      nH := nH abs.
	      pY := pY - nH.
	].
    ] ifFalse:[
	pX := x.
	pY := y.
	nW := w.
	nH := h.
    ].
    pX := pX rounded.
    pY := pY rounded.
    nW := nW rounded.
    nH := nH rounded.

    device
	fillRectangleX:pX
		     y:pY
		 width:nW
		height:nH
		    in:drawableId with:gcId

    "Modified: 4.6.1996 / 17:58:49 / cg"
! !

!DeviceGraphicsContext methodsFor:'finalization'!

executor
    drawableType == #window ifTrue:[
        ^ DeviceWindowGCHandle basicNew
            setDevice:device id:drawableId gcId:gcId parentId:parentId.
    ] ifFalse:[
        ^ DevicePixmapGCHandle basicNew
            setDevice:device id:drawableId gcId:gcId.
    ].
!

finalizationLobby
    "answer the registry used for finalization.
     DeviceGraphicContexts have their own Registry"

    ^ device graphicsContexts
!

registerChange
    "register a change with the finalizationLobby"

    self finalizationLobby registerChange:self.

    "Modified: / 06-01-2017 / 23:51:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DeviceGraphicsContext methodsFor:'initialization & release'!

close
    "same as destroy - for ST-80 compatibility"

    self destroy

    "Created: 2.4.1997 / 19:31:27 / cg"
!

createGC
    "physically create a device GC.
     Since we do not need a gc-object for the drawable until something is
     really drawn, none is created up to the first draw.
     This method is sent, when the first drawing happens"

    drawableType == #pixmap ifTrue:[
        gcId := device gcForBitmap:drawableId.
    ] ifFalse:[
        gcId := device gcFor:drawableId.
    ].
    device registerGraphicsContext:self.    "this is a registerChange:"

    "Modified: 19.3.1997 / 11:07:52 / cg"
!

destroy
    |id|

    
    self destroyGC .
    id := drawableId.
    id notNil ifTrue:[
        self changed:#aboutToDestroy.
        drawableId := nil.
        drawableType == #window ifTrue:[
            device destroyView:nil withId:id.
        ] ifFalse:[
            device destroyPixmap:id.
        ].
        device unregisterGraphicsContext:self.    
    ].
!

destroyGC
    |id|

    id := gcId.
    id notNil ifTrue:[
        gcId := nil.
        device destroyGC:id.
    ].
!

initGC
    "since we do not need a gc-object for the drawable until something is
     really drawn, none is created.
     This method is sent, when the first drawing happens.
     Answer the gcId."

    |fgId bgId p fontId|

    gcId notNil ifTrue:[
        "already initialized"
        ^ gcId
    ].
    drawableId isNil ifTrue:[
        "/
        "/ the drawable has been closed (or was never open)
        "/ no drawing is possible.
        "/
        ^ DrawingOnClosedDrawableSignal raiseRequest
    ].
    self createGC.

    foreground isNil ifTrue:[foreground := device blackColor].
    background isNil ifTrue:[background := device whiteColor].

    foreground isColor ifTrue:[
        "get device colors from the device indep. colors"
        foreground := foreground onDevice:device.
        fgId := foreground colorId.
        fgId isNil ifTrue:[
            (foreground grayIntensity >= 50) ifTrue:[
                fgId := device whitepixel
            ] ifFalse:[
                fgId := device blackpixel
            ]
        ].
    ] ifFalse:[
        fgId := device blackpixel.
    ].

    background isColor ifTrue:[
        background := background onDevice:device.
        bgId := background colorId.
        bgId isNil ifTrue:[
            (background grayIntensity >= 50) ifTrue:[
                bgId := device whitepixel
            ] ifFalse:[
                bgId := device blackpixel
            ]
        ].
    ] ifFalse:[
        bgId := device whitepixel
    ].

    "now, this is something the device can work with ..."
    device setForeground:fgId background:bgId in:gcId.

    "switch to paint"
    p := paint.
    paint := nil.
    self paint:p.

    ((lineWidth ~~ 0)
    or:[(lineStyle ~~ #solid)
    or:[(capStyle ~~ #butt)
    or:[joinStyle ~~ #miter]]]) ifTrue:[
        device setLineWidth:lineWidth
                      style:lineStyle
                        cap:capStyle
                       join:joinStyle
                         in:gcId
    ].

    mask notNil ifTrue:[
        (mask depth == 1) ifTrue:[
            device setBitmapMask:(mask drawableId) in:gcId
        ] ifFalse:[
            device setPixmapMask:(mask drawableId) in:gcId
        ].
        maskOrigin notNil ifTrue:[
            device setMaskOriginX:maskOrigin x y:maskOrigin y in:gcId
        ]
    ].
    (function ~~ #copy) ifTrue:[device setFunction:function in:gcId].

    "defer the getting of a device font
     - this is now done when the first drawstring occurs,
     since many views (layout-views) will never draw strings and
     therefore, the overhead of acquiring a font can be avoided.
    "
"/    font := font on:device.
"/    id := font fontId.
"/    id notNil ifTrue:[
"/        device setFont:id in:gcId
"/    ]

    (font notNil 
      and:[font graphicsDevice == device 
      and:[(fontId := font fontId) notNil]]) ifTrue:[
        deviceFont := font.
        device setFont:fontId in:gcId
    ].
    ^ gcId.

    "Modified: / 22-10-2006 / 14:10:53 / cg"
!

initialize
    "setup everything for later use; actual work is done in
     initColors and initFont, which are usually redefined."

    super initialize.

    "/ just in case, someone redefined new without setting device
    (device isNil and:[Screen notNil]) ifTrue:[device := Screen current].

    foreground isNil ifTrue:[foreground := self blackColor].
    background isNil ifTrue:[background := self whiteColor].

    "Modified: 10.1.1997 / 17:46:51 / cg"
!

prepareForReinit
    "kludge - clear drawableId and gcId
     needed after snapin"

    gcId := nil.
    drawableId := parentId := nil.
    deviceFont := nil
!

recreate
    "sent after a snapin or a migration, reinit draw stuff for new device"

    gcId := nil.
    drawableId := parentId := nil.
    foreground notNil ifTrue:[
        foreground := foreground onDevice:device
    ].
    background notNil ifTrue:[
        background := background onDevice:device
    ].
    paint notNil ifTrue:[
        paint := paint onDevice:device
    ].
    bgPaint notNil ifTrue:[
        bgPaint := bgPaint onDevice:device
    ].
    font notNil ifTrue:[
        font := deviceFont := font onDevice:device
    ]

    "Modified: 28.10.1996 / 13:25:02 / cg"
!

releaseGC
    "destroy the associated device GC resource - can be done to be nice to the
     display if you know that you are done with a drawable."

    |id|

    foreground := background := paint := bgPaint := nil.

    id := gcId.
    id notNil ifTrue:[
        gcId := nil.
        device destroyGC:id.
        device unregisterGraphicsContext:self.
    ].

    "Created: 11.6.1996 / 22:07:30 / cg"
    "Modified: 2.4.1997 / 19:36:30 / cg"
! !

!DeviceGraphicsContext methodsFor:'private'!

setDevice:aDevice id:aDrawbleId gcId:aGCId
    "private"

    self device:aDevice.
    drawableId := aDrawbleId.
    gcId := aGCId.
    (aDrawbleId notNil and:[aDevice notNil]) ifTrue:[
        aDevice registerGraphicsContext:self.
    ].
!

setGCForPaint
    "private; given a complex color (i.e. a pixmap or dithered color,
     setup the GC to draw in this color.
     A helper for paint and paint:on:"

    |dither map pixelId p fg bg vOrg ditherDepth deviceDepth|

    gcId notNil ifTrue:[
        paint isSymbol ifTrue:[
            "map symbols to colors"
            paint := Color perform:paint ifNotUnderstood:[Color yellow].
        ].
        p := paint.

        p isColor ifTrue:[
            paint := p := p onDevice:device.
            pixelId := p colorId.
            pixelId notNil ifTrue:[
                "
                 a real (undithered) color
                "
                mask notNil ifTrue:[
                    mask := nil.
                    device setBitmapMask:nil in:gcId
                ].
                (p ~~ foreground) ifTrue:[
                    foreground := paint.
                    device setForeground:pixelId in:gcId
                ].
                ^ self
            ].
            "a dithered color"
            dither := paint ditherForm.
        ] ifFalse:[
            "mhmh - seems to be some kind of form ..."
            paint := paint onDevice:device.
            dither := paint.
        ].
        "
         a dithered color or image
        "
        (ditherDepth := dither depth) == 1 ifTrue:[
            "a simple 0/1 bitmap"
            map := dither colorMap.
            "temporary (kludgy) fix for destroyed paint"
            p := paint.
            map isNil ifTrue:[
                fg := self blackColor.
                bg := self whiteColor.
            ] ifFalse:[
                fg := map at:2.
                bg := map at:1.
            ].
            self foreground:fg background:bg.
            paint := p
        ] ifFalse:[
            deviceDepth := device depth.
            (ditherDepth ~~ deviceDepth) ifTrue:[
                dither := dither asFormOn:device.
                ditherDepth := dither depth.
                (dither isNil or:[ditherDepth ~~ deviceDepth]) ifTrue:[
                    self error:'bad dither'.
                    ^ self
                ]
            ]
        ].
        self mask:dither.
        vOrg := self viewOrigin.
        self maskOriginX:vOrg x negated y:vOrg y negated.
    ]

    "Created: 16.5.1996 / 15:35:51 / cg"
    "Modified: 6.6.1997 / 12:55:38 / cg"
!

setId:aDrawableId
    "private"

    drawableId := aDrawableId

    "Created: / 6.2.1998 / 12:44:45 / cg"
!

subViewChangedSizeOrOrigin
    "Internal. Called whenever one of the owner's
     subview changes size or origin (i.e., when moved)    
     See SimpleView>>pixelOrigin:extent:.
     Can be used to adjust internal state."

    "/ Nothing by default

    "Created: / 02-04-2016 / 15:35:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

width: width height: height
    "Internal. Called by SimpleView when resized. 
     See SimpleView>>pixelOrigin:extent:.
     Can be used to adjust internal state."

    "/ Nothing by default

    "Created: / 02-04-2016 / 14:34:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DeviceGraphicsContext methodsFor:'queries'!

horizontalIntegerPixelPerMillimeter
    "return the (rounded) number of pixels per millimeter"

    ^ device horizontalPixelPerMillimeter rounded
!

horizontalPixelPerInch
    "return the number of horizontal pixels per inch of the display"

    ^ device horizontalPixelPerMillimeter * 25.4
!

horizontalPixelPerMillimeter
    "return the number of pixels per millimeter (not rounded)"

    ^ device horizontalPixelPerMillimeter
!

horizontalPixelPerMillimeter:millis
    "return the number of pixels (not rounded) for millis millimeter"

    ^ device horizontalPixelPerMillimeter * millis
!

resolution
    "return a point consisting of pixel-per-inch horizontally and vertically."

    ^ device resolution

    "Created: 4.6.1996 / 15:23:55 / cg"
!

verticalIntegerPixelPerMillimeter
    "return the (rounded) number of pixels per millimeter"

    ^ device verticalPixelPerMillimeter rounded
!

verticalPixelPerInch
    "return the number of vertical pixels per inch of the display"

    ^ device verticalPixelPerMillimeter * 25.4
!

verticalPixelPerMillimeter
    "return the number of pixels per millimeter (not rounded)"

    ^ device verticalPixelPerMillimeter
!

verticalPixelPerMillimeter:millis
    "return the number of pixels (not rounded) for millis millimeter"

    ^ device verticalPixelPerMillimeter * millis
! !

!DeviceGraphicsContext methodsFor:'testing'!

isPixmap
    ^ drawableType == #pixmap
!

isWindow
    ^ drawableType == #window
! !

!DeviceGraphicsContext methodsFor:'view creation'!

createBitmapFromArray:data width:width height:height
    "create a bitmap from data and set the drawableId"

    drawableType := #pixmap.
    drawableId := device createBitmapFromArray:data width:width height:height.
    device registerGraphicsContext:self.    "this is a registerChange:"
!

createPixmapWidth:w height:h depth:d
    "create a pixmap and set the drawableId"

    drawableId := device createPixmapWidth:w height:h depth:d.
    drawableId isNil ifTrue:[
        "/ creation failed
        Logger warning: 'pixmap creation failed: ' with: ((OperatingSystem lastErrorString) ? 'unknown error').
        ^ GraphicsDevice::GraphicResourceAllocationFailure query
    ].
    drawableType := #pixmap.
    device registerGraphicsContext:self.    "this is a registerChange:"
!

createRootWindowFor:aView
    drawableId := device rootWindowFor:aView.
    drawableType := #window.
!

createWindowFor:aView type:typeSymbol origin:org extent:ext minExtent:minE maxExtent:maxE borderWidth:bw subViewOf:sv style:styleSymbol inputOnly:inp label:label owner:owner icon:icn iconMask:icnM iconView:icnV
    "create a window and set the drawableId"

    |container|

    drawableId := device
            createWindowFor:aView
            type:typeSymbol
            origin:org
            extent:ext
            minExtent:minE
            maxExtent:maxE
            borderWidth:bw
            subViewOf:sv
            style:styleSymbol
            inputOnly:inp
            label:label
            owner:owner
            icon:icn
            iconMask:icnM
            iconView:icnV.

    drawableType := #window.
    container := aView container.
    container notNil ifTrue:[ parentId := container drawableId].
    device registerGraphicsContext:self.    "this is a registerChange:"
! !

!DeviceGraphicsContext methodsFor:'view properties'!

backingStore:how
    "turn on/off backingStore (saving my pixels)
     how may true/false, but also #always, #whenMapped or #never."

    drawableId notNil ifTrue:[
	device setBackingStore:how in:drawableId
    ]
!

bitGravity:gravity
    "set the bitGravity 
     - that's the direction where the contents will move when the view is resized."

    drawableId notNil ifTrue:[
        device setBitGravity:gravity in:drawableId
    ]
!

saveUnder:aBoolean
    "turn on/off saveUnder (saving pixels under myself)
     - used for temporary views (i.e. PopUps and ModalBoxes)"

    drawableId notNil ifTrue:[
	device setSaveUnder:aBoolean in:drawableId
    ]
!

setCursorId:id
    drawableId notNil ifTrue:[
	device setCursor:id in:drawableId.
    ]
!

setWindowPid: pid
    "Sets the _NET_WM_PID property for the window.
     This may be used by the window manager to group windows.
     If anIntegerOrNil is nil, then PID of currently running
     Smalltalk is used"

    drawableId notNil ifTrue:[
	device setWindowPid:pid in:drawableId.
    ].
!

viewGravity:gravity
    "set the viewGravity 
     - that's the direction where the view will move when the superView is resized."

    drawableId notNil ifTrue:[
        device setWindowGravity:gravity in:drawableId
    ].
!

windowBorderShape:aForm
    "set the windows border shape"

    drawableId notNil ifTrue:[
        device setWindowBorderShape:(aForm drawableId) in:drawableId
    ].
!

windowClass:windowClassNameString name:nameString
    "define class and name of a window.
     This may be used by the window manager to
     select client specific resources."

    drawableId notNil ifTrue:[
	device setWindowClass:windowClassNameString name:nameString in:drawableId.
    ].
!

windowName:aString
    "define the view's name in the window's title area."

    drawableId notNil ifTrue: [
        device setWindowName:aString in:drawableId.
    ]
!

windowShape:aForm
    "set the windows shape.
     Returns false, if the display does not support the
     X shape extension."

    drawableId notNil ifTrue:[
        ^ device setWindowShape:(aForm drawableId) in:drawableId
    ].
    ^ false.
! !

!DeviceGraphicsContext::DevicePixmapGCHandle methodsFor:'accessing'!

parentId
    "pixmaps do not have a parent"

    ^ nil
! !

!DeviceGraphicsContext::DevicePixmapGCHandle methodsFor:'finalization'!

finalize
    "the Form for which I am a handle has been collected - tell it to the x-server"

    |id|

    drawableId notNil ifTrue:[
	(id := gcId) notNil ifTrue:[
	    gcId := nil.
	    device destroyGC:id.
	].
	id := drawableId.
	drawableId := nil.
	device destroyPixmap:id.
    ]
! !

!DeviceGraphicsContext::DeviceWindowGCHandle methodsFor:'accessing'!

parentId
    ^ parentId
! !

!DeviceGraphicsContext::DeviceWindowGCHandle methodsFor:'finalization'!

finalize
    "the view for which I am a handle was collected
     - release system resources"

    drawableId notNil ifTrue:[
        [
            (device viewIdKnown:drawableId) ifTrue:[
"/ 'Display [info]: recycled view (' infoPrint. v infoPrint. ') not destroyed: ' infoPrint.
"/ drawableId displayString infoPrintCR.
                drawableId := nil.
            ] ifFalse:[
                |id|

                (id := gcId) notNil ifTrue:[
                    gcId := nil.
                    device deviceIOErrorSignal handle:[:ex |
                    ] do:[
                        device destroyGC:id.
                    ]
                ].

                id := drawableId.
                drawableId := nil.
                device deviceIOErrorSignal handle:[:ex |
                ] do:[
                    device destroyView:nil withId:id.
                ].

                "When a window ist destroyed, all its subwindows are also destroyed.
                 Unregister all the subwindows, to avoid destroying of reused windowIds
                 later."
                device cleanupLobbyForChildrenOfViewWithId:id.
            ]
        ] valueUninterruptably.
    ].

    "Created: / 25.9.1997 / 10:01:46 / stefan"
    "Modified: / 15.11.2001 / 14:17:12 / cg"
! !

!DeviceGraphicsContext::DeviceWindowGCHandle methodsFor:'private-accessing'!

setDevice:aDevice id:aDrawableId gcId:aGCId parentId:parentIdArg
    "set the handles contents"

    device := aDevice.
    drawableId := aDrawableId.
    gcId := aGCId.
    parentId := parentIdArg.
! !

!DeviceGraphicsContext class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

