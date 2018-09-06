"
 COPYRIGHT (c) 1992 by Claus Gittinger
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

Object subclass:#Color
	instanceVariableNames:'red green blue device colorId ditherForm replacementColor
		writable'
	classVariableNames:'MaxValue Cells Black White LightGrey Grey DarkGrey Pseudo0
		Pseudo1 PseudoAll Red Green Blue Yellow Orange RetryAllocation
		DitherBits ColorErrorSignal ColorAllocationFailSignal
		InvalidColorNameSignal StandardColorValues Transparent'
	poolDictionaries:''
	category:'Graphics-Support'
!

Object subclass:#DeviceColorHandle
	instanceVariableNames:'device colorId'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Color
!

!Color class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    Color represents colors in a device independent manner.
    The main info I keep in mySelf are the red, green and blue components scaled into 0 .. MaxValue.
    
    A device specific color can be acquired by sending a color the 'onDevice:aDevice' message,
    which will return a color with the same r/g/b values as the receiver but with a specific
    colorID for that device (which may or may not imply a colormap slot allocation on that device).
    A device-specific color index (i.e. palette-ID) is then found in the newly allocated color's colorID slot.
    
    Most of the device dependent coding was to support limited graphics devices (non truecolor, eg. palette)
    in a transparent way. This was required at that time (late 80's, early 90's),
    but is now almost obsolete, as these days, virtually any graphic systems supports true colors.
    It is arguably, if that stuff should remain here, or if we should simply give up support
    for old VGA-like displays 
    (actually, there are still such limited displays around, for example in the embedded area.
     So we will leave that support in for another few years ;-) ).

    On such limited devices, colors can be pure or dithered, depending on the capabilities of the device.
    For plain colors, the colorId-instvar is a handle (usually lookup-table entry) for that
    device. For dithered colors, the colorId is nil and ditherForm specifies the form
    used to dither that color. The ditherForm can be either a depth-1 bitmap or a pixmap
    with the devices depth. The plain colors needed by the ditherForm are found in its
    colormap (as usual for bitmaps).

    The default algorithm for color allocation is to ask the display for colors as
    new colors are created. When running out of colors, dithered colors will be used,
    using existing nearest colors and a dither pattern to approximate the color.
    There could be situations, where no good colors are available for the dither, leading
    to ugly looking dither colors.
    This can be avoided by preallocating a set of colors over the complete range, which
    makes certain that appropriate colors are later available for the dither process.
    To do so, add a statement like: 'Color getColors5x5x5' to the startup.rc file.
    (beside 5x5x5, there are various other size combinations available).
    However, doing so may make things worse when displaying bitmap images, since this
    preallocated table may steal colors from the image ...

    [Instance variables:]

      red             <Integer>       the red component (0..MaxValue)
      green           <Integer>       the green component (0..MaxValue)
      blue            <Integer>       the blue component (0..MaxValue)

      device          <Device>        the device I am on, or nil
      colorId         <Object>        some device dependent identifier (or nil if dithered)
      ditherForm      <Form>          the Form to dither this color (if non-nil)
      writable        <Boolean>       true if this is for a writable color cell

    [Class variables:]

      MaxValue        <Integer>       r/g/b components are scaled relative to this maximum

      Lobby           <Registry>      all colors in use - keeps track of already allocated
                                      colors for reuse and finalization.
                                      (don't use it: this will be moved to the device)

      Cells           <Registry>      keeps track of allocated writable color cells
                                      (don't use it: this will be moved to the device)

      FixColors       <Array>         preallocated colors for dithering on Display
      NumRedFix       <Integer>       number of distinct red values in FixColors
      NumGreenFix     <Integer>       number of distinct green values in FixColors
      NumBlueFix      <Integer>       number of distinct blue values in FixColors

      Black           <Color>         for fast return of black
      White           <Color>         for fast return of white
      Grey            <Color>         for fast return of grey
      LightGrey       <Color>         for fast return of lightGrey
      DarkGrey        <Color>         for fast return of darkGrey

      Pseudo0         <Color>         a color with 0 as handle (for forms and bitblit)
      Pseudo1         <Color>         a color with 1 as handle (for forms)
      PseudoAll       <Color>         a color with allPlanes as handle (for bitblit)

      Red             <Color>         red, needed for dithering
      Green           <Color>         green, for dithering
      Blue            <Color>         blue, for dithering

      DitherColors    <Collection>    some preallocated colors for dithering
                                      (kept, so they are available when needed)

      RetryAllocation <Boolean>       this flag controls how a request for a
                                      color should be handled which failed previously.
                                      I.e. a color is asked for, which was dithered
                                      the last time. Since it could happen, that in
                                      the meantime more colors became free, the request
                                      might succeed this time - however, your screen may
                                      look a bit funny, due to having both dithered and
                                      undithered versions around.
                                      The default is true, which means: do retry

    compatibility issues:

        ST-80 seems to represent colors internally with scaled smallInteger
        components (this can be guessed from uses of
        scaledRed:scaledGreen:scaledBlue:). The main instance creation method is
        via 'ColorValue red:green:blue:', passing components in 0..1.
        In ST/X, component are internally represented as percent.
        For more compatibility (when subclassing color), these internals may
        change in the near future. For migration, a compatibility subclass
        called ColorValue is provided.
        After the change, Color will be renamed to ColorValue and Color
        be made a subclass of ColorValue (offering the 0..100 interface for
        backward compatibility).

    [see also:]
        DeviceWorkstation
        GraphicsContext DeviceDrawable Form Image Colormap
        Font Cursor

    [author:]
        Claus Gittinger
"
! !

!Color class methodsFor:'initialization'!

allocateColorsIn:aColorVector on:aDevice
    "{ Pragma: +optSpace }"

    "preallocates a nR x nG x nB colorMap for later use in dithering.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    |clr round
     devClr|

    round := 0.
    1 to:aColorVector size do:[:dstIndex |
	clr := aColorVector at:dstIndex.
	devClr := clr exactOn:aDevice.
	devClr isNil ifTrue:[
	    round == 0 ifTrue:[
		'Color [info]: scavenge to reclaim colors' infoPrintCR.
		ObjectMemory scavenge.
		round := 1.
		devClr := clr exactOn:aDevice.
	    ].
	].
	devClr isNil ifTrue:[
	    round == 1 ifTrue:[
		'Color [info]: collect garbage to reclaim colors' infoPrintCR.
		ObjectMemory performLowSpaceCleanup.
		ObjectMemory garbageCollect; finalize.
		round := 2.
		devClr := clr exactOn:aDevice.
	   ].
	].
	devClr isNil ifTrue:[
	    ColorAllocationFailSignal raiseErrorString:'failed to allocate fix color'.
	    ^ self
	].
	aColorVector at:dstIndex put:devClr.
    ].
!

colorCubeWithRed:nRed green:nGreen blue:nBlue
    "{ Pragma: +optSpace }"

    |nR "{Class: SmallInteger }"
     nG "{Class: SmallInteger }"
     nB "{Class: SmallInteger }"
     dR dG dB red green blue dstIndex clr round
     colorCube|

    nR := nRed.
    nG := nGreen.
    nB := nBlue.

    dR := 100.0 / (nR - 1).
    dG := 100.0 / (nG - 1).
    dB := 100.0 / (nB - 1).

    colorCube := Array new:(nR * nG * nB).

    round := 0.

    dstIndex := 1.
    1 to:nR do:[:sR |
	red := dR * (sR - 1).
	1 to:nG do:[:sG |
	    green := dG * (sG - 1).
	    1 to:nB do:[:sB |
		blue := dB * (sB - 1).
		clr := self red:red green:green blue:blue.
		colorCube at:dstIndex put:clr.
		dstIndex := dstIndex + 1
	    ]
	]
    ].
    ^ colorCube

    "Created: 11.7.1996 / 17:55:32 / cg"
    "Modified: 10.1.1997 / 15:37:13 / cg"
!

flushDeviceColors
    "unassign all colors from their device"

    self allInstances do:[:aColor |
	aColor restored
    ].

    "Modified: 24.2.1997 / 18:27:06 / cg"
!

flushDeviceColorsFor:aDevice
    self allInstancesDo:[:aColor |
	aColor device == aDevice ifTrue:[
	    aColor restored
	]
    ]
!

getColors6x6x4
    "{ Pragma: +optSpace }"

    "preallocates a 6x6x4 (144) colorMap and later uses those colors only.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    self getColorsRed:6 green:6 blue:4

    "
     Color getColors6x6x4
    "
!

getColors6x6x5
    "{ Pragma: +optSpace }"

    "preallocates a 6x6x5 (180) colorMap and later uses those colors only.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    self getColorsRed:6 green:6 blue:5

    "
     Color getColors6x6x5
    "
!

getColors6x6x6
    "{ Pragma: +optSpace }"

    "preallocates a 6x6x6 (196) colorMap and later uses those colors only.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    self getColorsRed:6 green:6 blue:6

    "
     Color getColors6x6x6
    "
!

getColors6x7x4
    "{ Pragma: +optSpace }"

    "preallocates a 6x7x4 (168) colorMap and later uses those colors only.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    self getColorsRed:6 green:7 blue:4

    "
     Color getColors6x7x4
    "

    "Created: 12.6.1996 / 17:41:57 / cg"
!

getColors7x8x4
    "{ Pragma: +optSpace }"

    "preallocates a 7x8x4 (224) colorMap and later uses those colors only.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    self getColorsRed:7 green:8 blue:4

    "
     Color getColors7x8x4
    "
!

getColorsRed:nRed green:nGreen blue:nBlue
    "{ Pragma: +optSpace }"

    "preallocates a nR x nG x nB colorMap for later use in dithering.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    self getColorsRed:nRed green:nGreen blue:nBlue on:Screen current

    "
     Color getColorsRed:2 green:2 blue:2
    "

    "Modified: 11.7.1996 / 17:58:09 / cg"
!

getColorsRed:nRed green:nGreen blue:nBlue on:aDevice
    "{ Pragma: +optSpace }"

    "preallocates a nR x nG x nB colorMap for later use in dithering.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    |nR "{Class: SmallInteger }"
     nG "{Class: SmallInteger }"
     nB "{Class: SmallInteger }"
     dR dG dB fixColors|

    aDevice visualType == #TrueColor ifTrue:[^ self].

    nR := nRed.
    nG := nGreen.
    nB := nBlue.

    dR := 100.0 / (nR - 1).
    dG := 100.0 / (nG - 1).
    dB := 100.0 / (nB - 1).

    fixColors := self colorCubeWithRed:nRed green:nGreen blue:nBlue.
    self allocateColorsIn:fixColors on:aDevice.

    aDevice setFixColors:fixColors numRed:nR numGreen:nG numBlue:nB

    "
     Color getColorsRed:2 green:2 blue:2 on:Display
    "

    "Created: 11.7.1996 / 17:55:32 / cg"
    "Modified: 10.1.1997 / 15:37:13 / cg"
!

getGrayColors:nGray on:aDevice
    "{ Pragma: +optSpace }"

    "preallocates nGray gray colors for later use in dithering.
     Doing so has the advantage that the system will never run out of colors,
     however, colors may be either inexact or dithered."

    |nG "{Class: SmallInteger }"
     d fixGrayColors|

    aDevice visualType == #TrueColor ifTrue:[^ self].

    nG := nGray.
    d := 100.0 / (nG - 1).

    fixGrayColors := self grayColorVector:nGray.
    self allocateColorsIn:fixGrayColors on:aDevice.

    aDevice setFixGrayColors:fixGrayColors

    "
     Color getGrayColors:16 on:Display
    "

    "Created: 23.6.1997 / 15:29:50 / cg"
!

getPrimaryColorsOn:aDevice
    "{ Pragma: +optSpace }"

    "preallocate the primary colors.
     Doing so during early startup prevents us from running out
     of (at least those required) colors later.
     This guarantees, that at least some colors are available
     for dithering (although, with only black, white, red, green and blue,
     dithered images look very poor)."

    |colors white black red green blue clr dDepth
     lastPix "{ Class: SmallInteger }" |

    (aDevice notNil and:[aDevice ditherColors isNil]) ifTrue:[
	white := (self red:100 green:100 blue:100) exactOn:aDevice.
	white colorId isNil ifTrue:[
	    'Color [warning]: cannot allocate white color' errorPrintCR.
	].
	black := (self red:0 green:0 blue:0) exactOn:aDevice.
	black colorId isNil ifTrue:[
	    'Color [warning]: cannot allocate black color' errorPrintCR.
	].

	aDevice hasColors ifTrue:[
	    red := (self red:100 green:0 blue:0) exactOn:aDevice.
	    green := (self red:0 green:100 blue:0) exactOn:aDevice.
	    blue := (self red:0 green:0 blue:100) exactOn:aDevice.
	    (red isNil
	    or:[green isNil
	    or:[blue isNil
	    or:[red colorId isNil
	    or:[green colorId isNil
	    or:[blue colorId isNil]]]]]) ifTrue:[
		'Color [warning]: cannot allocate primary color(s)' errorPrintCR.
		dDepth := aDevice depth.
		((dDepth >= 4) and:[dDepth <= 8]) ifTrue:[
		    "/
		    "/ see what we have ...
		    "/
		    lastPix := (1 bitShift:dDepth) - 1.
		    0 to:lastPix do:[:pixel |
			colors := OrderedCollection new.
			aDevice getRGBFrom:pixel into:[:r :g :b |
			    colors add:((Color red:r green:g blue:b) exactOn:aDevice).
			]
		    ].
		    red := (self red:100 green:0 blue:0) nearestOn:aDevice.
		    green := (self red:0 green:100 blue:0) nearestOn:aDevice.
		    blue := (self red:0 green:0 blue:100) nearestOn:aDevice.
		] ifFalse:[
		    aDevice hasColors:false.
		    aDevice hasGrayscales:false.
		    red := green := blue := nil.
		]
	    ]
	].

	aDevice == Display ifTrue:[
	    "/ keep those around for the main display
	    White := white.
	    Black := black.
	    Red := red.
	    Green := green.
	    Blue := blue
	].

	aDevice visualType ~~ #TrueColor ifTrue:[
	    aDevice hasColors ifTrue:[

		"preallocate some colors for dithering
		 - otherwise, they may not be available when we need them ...
		 these are: black, white, grey50,
			    red, green, blue, yellow, cyan and magenta.
		"

		colors := OrderedCollection new.
		clr := (self gray:50) exactOn:aDevice.
		(clr notNil and:[clr colorId notNil]) ifTrue:[
		    colors add:clr
		].

		colors add:white; add:black; add:red; add:green; add:blue.

		colors add:((self red:100 green:100 blue:0) exactOn:aDevice).
		colors add:((self red:100 green:0 blue:100) exactOn:aDevice).
		colors add:((self red:0 green:100 blue:100) exactOn:aDevice).
	    ].

	    aDevice hasGrayscales ifTrue:[
		aDevice hasColors ifFalse:[
		    colors := OrderedCollection new.
		    colors add:((self gray:50) exactOn:aDevice).
		    colors add:white; add:black.

		].
		colors add:((self gray:25) exactOn:aDevice).
		colors add:((self gray:33) exactOn:aDevice).
		colors add:((self gray:67) exactOn:aDevice).
		colors add:((self gray:75) exactOn:aDevice).
	    ].

	    colors notNil ifTrue:[
		colors := colors select:[:clr | clr notNil and:[clr colorId notNil]].
		aDevice setDitherColors:(colors asArray).
	    ]
	]
    ]

    "Created: 11.7.1996 / 18:09:28 / cg"
    "Modified: 21.10.1997 / 02:42:28 / cg"
!

grayColorVector:nGray
    |nG "{Class: SmallInteger }"
     d gray dstIndex clr round
     grayColors|

    nG := nGray.
    d := 100.0 / (nG - 1).

    grayColors := Array new:nG.

    round := 0.

    dstIndex := 1.
    1 to:nG do:[:sG |
	gray := d * (sG - 1).
	clr := self red:gray green:gray blue:gray.
	grayColors at:dstIndex put:clr.
	dstIndex := dstIndex + 1
    ].
    ^ grayColors

    "
     Color getGrayColors:16 on:Display
    "

    "Created: 23.6.1997 / 15:29:50 / cg"
!

initialize
    "setup tracker of known colors and initialize classvars with
     heavily used colors"

    ColorErrorSignal isNil ifTrue:[
	ColorErrorSignal := Error newSignalMayProceed:true.
	ColorErrorSignal nameClass:self message:#colorErrorSignal.
	ColorErrorSignal notifierString:'color error'.

	ColorAllocationFailSignal := ColorErrorSignal newSignalMayProceed:true.
	ColorAllocationFailSignal nameClass:self message:#colorAllocationFailSignal.
	ColorAllocationFailSignal notifierString:'color allocation failed'.

	InvalidColorNameSignal := ColorErrorSignal newSignalMayProceed:true.
	InvalidColorNameSignal nameClass:self message:#invalidColorNameSignal.
	InvalidColorNameSignal notifierString:'invalid color name'.

	MaxValue := 16rFFFF.

	"want to be informed when returning from snapshot"
	ObjectMemory addDependent:self.

	RetryAllocation := true.

	DitherBits := self ditherBits.
	self initializeStandardColorNames.
    ].

    "
     Color initialize
    "

    "Modified: / 30.9.1998 / 21:56:50 / cg"
!

initializeStandardColorNames
    "{ Pragma: +optSpace }"

    "setup standard colors"

    StandardColorValues := Dictionary new.
    #(
		'red'     (16rFFFF 16r0000 16r0000)
		'green'   (16r0000 16rFFFF 16r0000)
		'blue'    (16r0000 16r0000 16rFFFF)
		'yellow'  (16rFFFF 16rFFFF 16r0000)
		'magenta' (16rFFFF 16r0000 16rFFFF)
		'cyan'    (16r0000 16rFFFF 16rFFFF)
		'white'   (16rFFFF 16rFFFF 16rFFFF)
		'black'   (16r0000 16r0000 16r0000)
		'olive'   (16r7FFF 16r7FFF 16r0000)
		'teal'    (16r0000 16r7FFF 16r7FFF)
		'silver'  (16r6666 16r6666 16r6666)
		'lime'    (16r3333 16rFFFF 16r0000)
		'fuchsia' (16r9999 16r07ae 16rFFFF)
		'aqua'    (16r199a 16rFFFF 16rFFFF)
    ) pairWiseDo:[:name :value |
	StandardColorValues at:name put:value
    ].

    "
     Color initializeStandardColorNames
    "

    "Modified: 6.3.1997 / 02:28:58 / cg"
!

standardDitherColorsForDepth8
    "return a set of colors useful for dithering (roughly 200 colors);
     This includes a color cube and the main grayScale colors."

    |ditherColors|

    ditherColors := self colorCubeWithRed:6 green:8 blue:4.
    ditherColors := ditherColors ,
		    (Array
			with:(Color gray:20)
			with:(Color gray:25)
			with:(Color gray:40)
			with:(Color gray:50)
			with:(Color gray:60)
			with:(Color gray:75)
			with:(Color gray:80)
			with:(Color rgbValue:16rBFBFBF)).
    ^ ditherColors

    "
     self standardDitherColorsForDepth8
    "
!

update:something with:aParameter from:changedObject
    "handle image restarts and flush any device resource handles"

    (something == #returnFromSnapshot) ifTrue:[
	Display notNil ifTrue:[
	    Display visualType == #TrueColor ifTrue:[
		Display releaseFixColors
	    ] ifFalse:[
		Display fixColors notNil ifTrue:[
		    ColorAllocationFailSignal handle:[:ex |
			ex return
		    ] do:[
			|nR nG nB|

			nR := Display numFixRed.
			nG := Display numFixGreen.
			nB := Display numFixBlue.
			Display releaseFixColors.
			self getColorsRed:nR
				    green:nG
				     blue:nB
				       on:Display
		    ]
		]
	    ]
	]
    ]

    "Created: 15.6.1996 / 15:14:03 / cg"
    "Modified: 24.2.1997 / 22:08:05 / cg"
!

vgaColors
    "{ Pragma: +optSpace }"

    |colors|

    colors := Array new:16.
    colors at:1 put:(Color rgbValue:16rFFFFFF).
    colors at:2 put:(Color rgbValue:16rC0C0C0).
    colors at:3 put:(Color rgbValue:16r808080).
    colors at:4 put:(Color rgbValue:16r000000).
    colors at:5 put:(Color rgbValue:16rFF0000).
    colors at:6 put:(Color rgbValue:16r800000).
    colors at:7 put:(Color rgbValue:16r008000).
    colors at:8 put:(Color rgbValue:16r00FF00).
    colors at:9 put:(Color rgbValue:16r0000FF).
    colors at:10 put:(Color rgbValue:16r000080).
    colors at:11 put:(Color rgbValue:16rFF00FF).
    colors at:12 put:(Color rgbValue:16r800080).
    colors at:13 put:(Color rgbValue:16rFFFF00).
    colors at:14 put:(Color rgbValue:16r808000).
    colors at:15 put:(Color rgbValue:16r00FFFF).
    colors at:16 put:(Color rgbValue:16r008080).
    ^ colors

    "Created: / 07-07-2006 / 13:36:15 / cg"
! !

!Color class methodsFor:'instance creation'!

allColor
    "return a special color which, when used for bit-blitting will
     behave like a all-1-color (i.e. have a device-pixel value of all-1s)"

    PseudoAll isNil ifTrue:[
	PseudoAll := self basicNew setColorId:-1
    ].
    ^ PseudoAll

    "Modified: 17.1.1997 / 00:05:36 / cg"
!

bgrValue:bgr
    "return a color from a 24bit BGR value (intentionally not RGB);
     The value is composed of b<<16 + g<<8 + r.
     (this byte-order is sometimes encountered with windows systems (progs)"

    |r g b|

    b := (bgr bitShift:-16) bitAnd:16rFF.
    g := (bgr bitShift:-8) bitAnd:16rFF.
    r := (bgr) bitAnd:16rFF.
    ^ self redByte:r greenByte:g blueByte:b

!

blue: blue
    "return a color from blue value;
     the argument green is interpreted as percent (0..100)"

    ^ here
	scaledRed:0 scaledGreen:0 scaledBlue:(blue * MaxValue // 100)

    "
     (Color blue:50) inspect
    "

!

brightness:brightness
    "create a gray color with given brightness (0..1).
     ST-80 compatibility."

    ^ self scaledGray:(brightness * MaxValue) rounded
!

colorId:id
    "return a color for a specific colorid without associating it to a
     specific device. Use this only for bitmaps which want 0- or 1-color,
     or for bitblits if you want to manipulate a specific colorplane."

    id == 0 ifTrue:[
	^ self noColor
    ].
    id == 1 ifTrue:[
	Pseudo1 isNil ifTrue:[
	    Pseudo1 := self basicNew setColorId:1
	].
	^ Pseudo1
    ].
    id == -1 ifTrue:[
	^ self allColor
    ].

    ^ self basicNew setColorId:id

    "Modified: 24.2.1997 / 18:16:30 / cg"
!

cyan:c magenta:m yellow:y
    "return a color from cyan, magenta and yellow values.
     all values are given in percent (0..100)"

    ^ self
	redPercent:(100 - c)
	greenPercent:(100 - m)
	bluePercent:(100 - y)

    "
     Color cyan:100 magenta:0 yellow:0      - cyan
     Color cyan:100 magenta:100 yellow:0    - blue
     Color cyan:100 magenta:0 yellow:100    - green
     Color cyan:100 magenta:100 yellow:100  - black
    "

    "Modified: 11.6.1996 / 18:29:15 / cg"
!

cyan:c magenta:m yellow:y black:k
    "return a color from cyan, magenta, yellow and black values.
     all values are given in percent (0..100).
     The value returned here is questionable.
     TODO: we loose information about one component here,
     and should actually return an instance of CMYK color, which keeps this
     information internally for later use (when saving)."

    |scale r g b|

    "/ mhmh - how should we scale black into the components ?

    r := (100 - c).
    g := (100 - m).
    b := (100 - y).
    k ~~ 0 ifTrue:[
	"/ more black - darker
	scale := (100-k) max:0.
	scale := scale / 100.
	r := r * scale.
	g := g * scale.
	b := b * scale.
    ].

    ^ self redPercent:r greenPercent:g bluePercent:b

    "
     Color cyan:100 magenta:0 yellow:0 black:0      - cyan
     Color cyan:100 magenta:0 yellow:0 black:50     - cyan darkened
     Color cyan:100 magenta:50 yellow:50 black:0    - cyan darkened
     Color cyan:0 magenta:0 yellow:0 black:100      - black
    "

    "Modified: 11.6.1996 / 18:29:15 / cg"
!

dither:fraction between:color1 and:color2 on:aDevice
    "create a dithered Color which dithers between color1 and color2.
     Fraction must be 0..1, color1 and color2 must be real (i.e. undithered)
     colors.
     Useful, if you explicitely want a dithered color
     (for example, to not use up too many colors, or for special effects)"

    |newColor form c1 c2|

    "/ both must be true device colors

    c1 := color1 exactOn:aDevice.
    c2 := color2 exactOn:aDevice.
    (c1 isNil or:[c2 isNil]) ifTrue:[
	'Color [warning]: monoDither failed - no real colors given' errorPrintCR.
	^ nil
    ].

    self
	monoDitherFor:fraction
	between:c1
	and:c2
	on:aDevice
	into:[:c :f | newColor := c. form := f].
    newColor notNil ifTrue:[^ newColor].

    form isNil ifTrue:[
	"/ cannot happen
	'Color [warning]: monoDither failed' errorPrintCR.
	^ nil
    ].

    newColor := self basicNew
			setScaledRed:nil
			scaledGreen:nil
			scaledBlue:nil
			device:aDevice.
    newColor setDitherForm:form.
    newColor setDevice:aDevice colorId:nil.
    ^ newColor

    "
     (Color dither:0.25 between:Color red and:Color yellow on:Display) inspect
     (Color dither:0.5 between:Color red and:Color yellow on:Display) inspect
     (Color dither:0.75 between:Color red and:Color yellow on:Display) inspect
    "

    "Created: 3.5.1997 / 10:54:32 / cg"
    "Modified: 3.5.1997 / 11:10:51 / cg"
!

dithered:fraction between:color1 and:color2 on:aDevice
    "create a dithered Color which dithers between color1 and color2.
     Fraction must be 0..1, color1 and color2 must be real (i.e. undithered)
     colors.
     Useful, if you explicitely want a dithered color
     (for example, to not use up too many colors, or for special effects)"

    |newColor form c1 c2|

    "/ both must be true device colors

    c1 := color1 exactOn:aDevice.
    c2 := color2 exactOn:aDevice.
    (c1 isNil or:[c2 isNil]) ifTrue:[
	'Color [warning]: monoDither failed - no real colors given' errorPrintCR.
	^ nil
    ].

    self
	monoDitherFor:fraction
	between:c1
	and:c2
	on:aDevice
	into:[:c :f | newColor := c. form := f].
    newColor notNil ifTrue:[^ newColor].

    form isNil ifTrue:[
	"/ cannot happen
	'Color [warning]: monoDither failed' errorPrintCR.
	^ nil
    ].

    newColor := self basicNew
			setScaledRed:nil
			scaledGreen:nil
			scaledBlue:nil
			device:aDevice.
    newColor setDitherForm:form.
    newColor setDevice:aDevice colorId:nil.
    ^ newColor

    "
     |c|

     c := Color dithered:0.5 between:Color red and:Color yellow on:Display.
     c inspect.
    "
    "
     |v c|

     v := StandardSystemView new.
     v extent:100@100.
     v openAndWait.

     c := Color dithered:0.5 between:Color red and:Color yellow on:Display.
     v paint:c.
     v fillRectangle:(10@10 corner:90@90).
    "

    "Created: 3.5.1997 / 10:54:32 / cg"
    "Modified: 3.5.1997 / 11:13:12 / cg"
!

fromUser
    "{ Pragma: +optSpace }"

    "let user point on a screen pixel.
     Return an instance for that pixels color"

    ^ self fromUserWithFeedBack:nil

    "
     Color fromUser
    "

    "Modified: / 31.8.1995 / 01:34:22 / claus"
    "Modified: / 9.1.1998 / 20:48:58 / stefan"
!

fromUserWithFeedBack:feedbackBlockOrNil
    "{ Pragma: +optSpace }"

    "let user point on a screen pixel.
     Return an instance for that pixels color"

    |p screen|

    screen := Screen current.
    p := screen
	    pointFromUserShowing:(Cursor crossHair)
	    positionFeedback:[:p |
				feedbackBlockOrNil notNil ifTrue:[
				    feedbackBlockOrNil value:(screen colorAt:p)
				]
			    ].
    ^ screen colorAt:p

    "
     Color fromUserWithFeedBack:nil
    "

    "Modified: / 31.8.1995 / 01:34:22 / claus"
    "Modified: / 9.1.1998 / 20:48:58 / stefan"
!

green:green
    "return a color from green value;
     the argument green is interpreted as percent (0..100)"

    ^ here
	scaledRed:0 scaledGreen:(green * MaxValue // 100) scaledBlue:0

    "
     (Color green:50) inspect
    "

!

hue:h light:l saturation:s
    "return a color from hue, light and saturation values.
     Hue is in degrees (0..360); light and saturation are
     in percent (0..100)"

    self withRGBFromHue:h light:l saturation:s do:[:r :g :b |
        ^ self
            redPercent:(r clampBetween:0 and:100)
            greenPercent:(g clampBetween:0 and:100)
            bluePercent:(b clampBetween:0 and:100)
    ]

    "
     Color hue:0 light:50 saturation:100     - red
     Color hue:60 light:50 saturation:100    - yellow
     Color hue:120 light:50 saturation:100   - green
     Color hue:120 light:75 saturation:100   - bright green
     Color hue:120 light:25 saturation:100   - dark green
     Color hue:120 light:50 saturation:50    - greyish dark green
     Color hue:120 light:50 saturation:0     - b&w television dark green
    "

    "Modified: 23.4.1996 / 13:22:22 / cg"
!

name:colorName
    "Return a named color (either exact or dithered).
     Report an error, if aString is not a valid color name.

     We hereby only guarantee that the 8 basic colors are supported
     on every device (X uses the Xcolor database, so it supports more
     names - other devices use a builtIn name table containing only the
     common names)
     - use with special names (such as 'mediumGoldenRod' is not recommended).
     Better use: #name:ifIllegal: and provide a fallBack."

    ^ self
	name:colorName
	ifIllegal:[
	    InvalidColorNameSignal
		raiseRequestWith:colorName errorString:' : ' , colorName
	]

    "
     Color name:'brown'
     Color name:'snow'
     Color name:'foo'
    "

    "Modified: 4.4.1997 / 15:32:33 / cg"
!

name:colorName ifIllegal:errorBlock
    "Return a named color (either exact or dithered).
     If aString is not a valid color name,
     return the result from evaluating errorBlock."

    |triple r g b currScreen|

    triple := StandardColorValues at:colorName asString ifAbsent:nil.
    triple notNil ifTrue:[
	r := triple at:1.
	g := triple at:2.
	b := triple at:3.
    ] ifFalse:[
	"/ ask display (if there is one) ...

	(Screen notNil
	and:[ (currScreen := Screen current) notNil])
	ifTrue:[
	    currScreen
		getScaledRGBFromName:colorName
		into:[:rr :gg :bb |
		    r := rr.
		    g := gg.
		    b := bb
		].
	]
    ].
    r notNil ifTrue:[
	^ here scaledRed:r scaledGreen:g scaledBlue:b
    ].
    ^ errorBlock value

    "
     Color name:'brown' ifIllegal:[Color black]
     Color name:'red' ifIllegal:[Color black]
     Color name:'fuchsia' ifIllegal:[Color black]
     Color name:'foo' ifIllegal:[Color black]
     Color name:'foo' ifIllegal:[nil]
    "

    "Modified: 6.3.1997 / 02:32:41 / cg"
!

noColor
    "return a special color which, when used for bit-blitting will
     behave like a 0-color (i.e. have a device-pixel value of all-0s)"

     Pseudo0 isNil ifTrue:[
	 Pseudo0 := self basicNew setColorId:0
     ].
     ^ Pseudo0

    "Modified: 17.1.1997 / 00:06:49 / cg"
!

red:red
    "return a color from red value;
     the argument r is interpreted as percent (0..100)"

    ^ here
	scaledRed:(red * MaxValue // 100) scaledGreen:0 scaledBlue:0

    "
     (Color red:50) inspect
    "
!

red:r green:g blue:b
    "return a color from red, green and blue values;
     the arguments, r, g and b are interpreted as percent (0..100)"

    ^ here scaledRed:(r * MaxValue // 100)
	   scaledGreen:(g * MaxValue // 100)
	   scaledBlue:(b * MaxValue // 100)
!

redByte:r greenByte:g blueByte:b
    "return a color from red, green and blue values;
     the arguments, r, g and b are interpreted as byte values (0..255)"

    ^ here scaledRed:(r * MaxValue // 255)
	   scaledGreen:(g * MaxValue // 255)
	   scaledBlue:(b * MaxValue // 255)

    "
     (Color redByte:255 greenByte:0 blueByte:0) inspect
     (Color redByte:255 greenByte:255 blueByte:255) inspect
     (Color redByte:0 greenByte:0 blueByte:0) inspect
    "

    "Modified: 16.1.1997 / 23:32:43 / cg"
!

redByte:r greenByte:g blueByte:b alphaByte:a
    "return a color from red, green, blue and alpha values;
     the arguments, r, g, b and a are interpreted as byte values (0..255)"

    ^ (here scaledRed:(r * MaxValue // 255)
	   scaledGreen:(g * MaxValue // 255)
	   scaledBlue:(b * MaxValue // 255))
	   alpha:(a / 255)

    "
     (Color redByte:255 greenByte:0 blueByte:0 alphaByte:127) inspect
    "

    "Created: / 06-06-2007 / 11:15:47 / cg"
!

redFraction:r greenFraction:g blueFraction:b
    "return a color from red, green and blue values;
     the arguments, r, g and b are interpreted as fraction (0..1)"

    ^ here scaledRed:(r * MaxValue) rounded
	   scaledGreen:(g * MaxValue) rounded
	   scaledBlue:(b * MaxValue) rounded
!

redPercent:r greenPercent:g bluePercent:b
    "return a color from red, green and blue values;
     the arguments, r, g and b are interpreted as percent (0..100)"

    ^ here scaledRed:(r * MaxValue // 100)
	   scaledGreen:(g * MaxValue // 100)
	   scaledBlue:(b * MaxValue // 100)
!

redPercent:r greenPercent:g bluePercent:b alphaPercent:a
    "return a color from red, green and blue values;
     the arguments, r, g and b are interpreted as percent (0..100)"

    ^ (here scaledRed:(r * MaxValue // 100)
	   scaledGreen:(g * MaxValue // 100)
	   scaledBlue:(b * MaxValue // 100))
	   alpha:(a * 255 // 100)
!

redShort:r greenShort:g blueShort:b
    "return a color from red, green and blue short values;
     the arguments, r, g and b are interpreted as unsigned short values (0..16rFFFF)"

    ^ here scaledRed:(r * MaxValue // 16rFFFF)
	   scaledGreen:(g * MaxValue // 16rFFFF)
	   scaledBlue:(b * MaxValue // 16rFFFF)

    "
     (Color redShort:16rFFFF greenShort:0 blueShort:0) inspect
    "
!

rgbValue:rgb
    "return a color from a 24bit RGB value;
     The value is composed of r<<16 + g<<8 + b."

    |r g b|

    r := (rgb bitShift:-16) bitAnd:16rFF.
    g := (rgb bitShift:-8) bitAnd:16rFF.
    b := (rgb) bitAnd:16rFF.
    ^ self redByte:r greenByte:g blueByte:b

    "
     (Color rgbValue:16rFF0000) inspect
     (Color rgbValue:16r00FF00) inspect
     (Color rgbValue:16r0000FF) inspect
     (Color rgbValue:16rFF00FF) inspect
    "

    "Modified: 13.8.1997 / 20:24:37 / cg"
!

scaledGray:aGrayValue
    "return a gray color with a scaled gray value (0..MaxValue)"

    ^ self scaledRed:aGrayValue scaledGreen:aGrayValue scaledBlue:aGrayValue

    "Modified: 11.6.1996 / 16:31:42 / cg"
!

scaledRed:r scaledGreen:g scaledBlue:b
    "return a color from red, green and blue values;
     the arguments, r, g and b are interpreted as (0..MaxValue)"

    |newColor|

"/    "look if already known"
"/
"/    aDevice deviceColors do:[:aColor |
"/        (r == aColor scaledRed) ifTrue:[
"/            (g == aColor scaledGreen) ifTrue:[
"/                (b == aColor scaledBlue) ifTrue:[
"/                    ^ aColor
"/                ]
"/            ]
"/        ]
"/    ].
    newColor := self basicNew setScaledRed:r scaledGreen:g scaledBlue:b device:nil.
    ^ newColor

    "
     (Color red:100 green:0 blue:0) inspect
     (Color red:100 green:50 blue:50) inspect
     (Color red:50 green:0 blue:0) inspect
    "

    "Modified: 2.5.1996 / 13:40:51 / stefan"
    "Modified: 24.2.1997 / 18:18:47 / cg"
!

variableColorOn:aDevice
    "return a variable color (i.e. allocate a writable colorcell) on
     aDevice. The returned color is not shared and its rgb components
     are initially undefined. The components can be set to any value
     using Color>>red:green:blue. Care should be taken, since this call
     fails on static color or b&w displays (i.e. it depends on the device
     being a pseudocolor device using colormaps).
     Returns nil, if no more colorCells are available, or the display
     uses a fix colormap (i.e. is a directColor or staticColor pr b&w device).
     Because of this, you should not write your application to depend on
     writable colors to be available (i.e. add fallBack code to redraw
     things in another color)"

    |c lutIndex|

    lutIndex := aDevice colorCell.
    lutIndex isNil ifTrue:[^ nil].

    c := self new.
    c setDevice:aDevice colorId:lutIndex writable:true.
    Cells isNil ifTrue:[
	Cells := Registry new.
    ].
    Cells register:c.
    ^ c

    "
     |l cell|

     l := Label new.
     l label:('hello' asText allBold).

     cell := Color variableColorOn:(Screen current).
     l foregroundColor:cell.
     [
	1 to:40 do:[:i|
	    i odd ifTrue:[
		cell red:100 green:0 blue:0
	    ] ifFalse:[
		cell red:0 green:0 blue:0
	    ].
	    Display flush.
	    (Delay forSeconds:0.4) wait
	].
	l destroy.
     ] fork.
     l open
    "

    "Modified: 13.5.1996 / 12:41:53 / cg"
! !

!Color class methodsFor:'Compatibility-Squeak'!

colorPaletteForDepth: depth extent: chartExtent
	"Squeak mimicri:
	 Display a palette of colors sorted horizontally by hue and vertically by lightness. Useful for eyeballing the color gamut of the display, or for choosing a color interactively."

	"Note: It is slow to build this palette, so it should be cached for quick access."
	"(Color colorPaletteForDepth: 16 extent: 190@60) display"

	| basicHue x y c startHue palette transHt vSteps transCaption grayWidth hSteps |

"/        Smalltalk isSmalltalkX ifTrue:[
	    palette := Image extent:chartExtent depth:24.
	    palette photometric:#rgb.
	    palette bits:(ByteArray new:chartExtent x * chartExtent y * 3).
"/        ] ifFalse:[
"/            palette := Form extent: chartExtent depth: depth.
"/        ].
	transCaption := "(DisplayText text: 'no color' asText textStyle: (TextConstants at: #ComicPlain)) form storeString"
		(Form extent: 34@9 depth: 1
			fromArray: #(0 0 256 0 256 0 3808663859 2147483648 2491688266 2147483648 2491688266 0 2491688266 0 2466486578 0 0 0)
			offset: 0@0).
	transHt := transCaption height.
	palette fillWhite: (0@0 extent: palette width@transHt).
	palette fillBlack: (0@transHt extent: palette width@1).
"/        transCaption displayOn: palette at: palette boundingBox topCenter - ((transCaption width // 2)@0).
	grayWidth := 10.
	startHue := 338.0.
	vSteps := palette height - transHt // 2.
	hSteps := palette width - grayWidth.
	x := 0.
	startHue to: startHue + 360.0 by: 360.0/hSteps do: [:h |
		basicHue := Color h: h asFloat s: 1.0 v: 1.0.
		y := transHt+1.
		0 to: vSteps do: [:n |
			c := basicHue mixed: (n asFloat / vSteps asFloat) with: Color white.
			palette fill: (x@y extent: 1@1) fillColor: c.
			y := y + 1].
		1 to: vSteps do: [:n |
			c := Color black mixed: (n asFloat / vSteps asFloat) with: basicHue.
			y < palette height ifTrue:[
			    palette fill: (x@y extent: 1@1) fillColor: c.
			].
			y := y + 1].
		x := x + 1].
	y := transHt + 1.
	1 to: vSteps * 2 do: [:n |
		c := Color black mixed: (n asFloat / (vSteps*2) asFloat) with: Color white.
		palette fill: (x@y corner:(((x@y) +(10@1))min:palette extent)) fillColor: c.
		y := y + 1].
	^ palette
!

fromRgbTriplet:aTriple
    ^ self r:(aTriple at:1)
	   g:(aTriple at:2)
	   b:(aTriple at:3)

!

h:hue s:saturation v:brightness
    "Squeak mimicri:
     Create a color with the given hue, saturation, and brightness.
     Hue is given as the angle in degrees of the color on the color circle,
     where red is zero degrees.
     Saturation and brightness are numbers in [0.0..1.0],
     where larger values are more saturated or brighter colors.
     For example, (Color h: 0 s: 1 v: 1) is pure red."

    "Note: By convention, brightness is abbreviated 'v' to avoid confusion with blue."

    ^ self hue:hue light:(brightness*50) saturation:(saturation*100)
!

indexedColors
    "Build an array of colors corresponding to the fixed colormap used
     for display depths of 1, 2, 4, or 8 bits."
    "Color indexedColors"

    | a index grayVal |

    a := Array new: 256.

    "1-bit colors (monochrome)"
    a at: 1 put: (Color r: 1.0 g: 1.0 b: 1.0).  "white or transparent"
    a at: 2 put: (Color r: 0.0 g: 0.0 b: 0.0).  "black"

    "additional colors for 2-bit color"
    a at: 3 put: (Color r: 1.0 g: 1.0 b: 1.0).  "opaque white"
    a at: 4 put: (Color r: 0.5 g: 0.5 b: 0.5).  "1/2 gray"

    "additional colors for 4-bit color"
    a at:  5 put: (Color r: 1.0 g: 0.0 b: 0.0). "red"
    a at:  6 put: (Color r: 0.0 g: 1.0 b: 0.0). "green"
    a at:  7 put: (Color r: 0.0 g: 0.0 b: 1.0). "blue"
    a at:  8 put: (Color r: 0.0 g: 1.0 b: 1.0). "cyan"
    a at:  9 put: (Color r: 1.0 g: 1.0 b: 0.0). "yellow"
    a at: 10 put: (Color r: 1.0 g: 0.0 b: 1.0). "magenta"

    a at: 11 put: (Color r: 0.125 g: 0.125 b: 0.125).       "1/8 gray"
    a at: 12 put: (Color r: 0.25 g: 0.25 b: 0.25).      "2/8 gray"
    a at: 13 put: (Color r: 0.375 g: 0.375 b: 0.375).       "3/8 gray"
    a at: 14 put: (Color r: 0.625 g: 0.625 b: 0.625).       "5/8 gray"
    a at: 15 put: (Color r: 0.75 g: 0.75 b: 0.75).      "6/8 gray"
    a at: 16 put: (Color r: 0.875 g: 0.875 b: 0.875).       "7/8 gray"

    "additional colors for 8-bit color"
    "24 more shades of gray (1/32 increments but not repeating 1/8 increments)"
    index := 17.
    1 to: 31 do: [:v |
	(v \\ 4) = 0 ifFalse: [
	    grayVal := v / 32.0.
	    a at: index put: (Color r: grayVal g: grayVal b: grayVal).
	    index := index + 1]].

    "The remainder of color table defines a color cube with six steps
     for each primary color. Note that the corners of this cube repeat
     previous colors, but this simplifies the mapping between RGB colors
     and color map indices. This color cube spans indices 40 through 255
     (indices 41-256 in this 1-based array)."
    0 to: 5 do: [:r |
	0 to: 5 do: [:g |
	    0 to: 5 do: [:b |
		index := 41 + ((36 * r) + (6 * b) + g).
		index > 256 ifTrue: [
		    self error: 'index out of range in color table compuation'].
		a at: index put: (Color r: r g: g b: b range: 5)]]].

    ^ a.
!

paleBlue
    ^ self r:0.75 g:0.75 b:1
!

pixelScreenForDepth: depth
    "Return a 50% stipple containing alternating pixels of all-zeros and all-ones to be used as a mask at the given depth."

    | mask bits |

    (Smalltalk isSmalltalkX) ifTrue:[
        depth == 1 ifTrue:[
            ^ Form mediumGreyFormOn:Screen current
        ].
        self shouldImplement.
    ].

    mask := (1 bitShift: depth) - 1.
    bits := 2 * depth.
    [bits >= 32] whileFalse: [
        mask := mask bitOr: (mask bitShift: bits).  "double the length of mask"
        bits := bits + bits
    ].
    ^ Bitmap with: mask with: mask bitInvert32

    "
     self pixelScreenForDepth: depth
    "
!

r:redFraction g:greenFraction b:blueFraction
    "Squeak mimicri:
     return a color from red, green and blue fractional values;
     the arguments, r, g and b must be in (0..1)"

    ^ here scaledRed:(redFraction * MaxValue) rounded
	   scaledGreen:(greenFraction * MaxValue) rounded
	   scaledBlue:(blueFraction * MaxValue) rounded

    "Modified: / 06-06-2007 / 11:19:53 / cg"
!

r:r g:g b:b alpha:alphaValue
    "return a color from red, green and blue values;
     the arguments, r, g, b and alpha must be in 0..1"

    ^ (self r:r g:g b:b) alpha:alphaValue

    "
     (Color r:1 g:0 b:0 alpha:0) inspect
     (Color r:0 g:1 b:0 alpha:0.5) inspect
     (Color r:0 g:0 b:1 alpha:1) inspect
    "

    "Created: / 06-06-2007 / 10:48:21 / cg"
!

r:r g:g b:b range:componentMax
    "return a color from red, green and blue values;
     the arguments, r, g and b are interpreted as values (0..componentMax)"

    ^ here scaledRed:(r * MaxValue // componentMax)
	   scaledGreen:(g * MaxValue // componentMax)
	   scaledBlue:(b * MaxValue // componentMax)

    "
     (Color r:1023 g:0 b:0 range:1023) inspect
     (Color r:1023 g:1023 b:1023 range:1023) inspect
     (Color r:0 g:0 b:0 range:1023) inspect
    "
!

showColors: colorList
	"Display the given collection of colors across the top of the Display."

	| w r |
	w := Screen current width // colorList size.
	r := 0@0 extent: w@((w min: 30) max: 10).
	colorList do: [:c |
		Screen current fill: r fillColor: c.
		r := r translateBy: w@0].
!

wheel: thisMany
    "Return a collection of thisMany colors evenly spaced around the color wheel."
    "Color showColors: (Color wheel: 12)"

    ^ Color wheel: thisMany saturation: 0.9 brightness: 0.7
!

wheel: thisMany saturation: s brightness: v
    "Return a collection of thisMany colors evenly spaced around the color wheel,
     all of the given saturation and brightness."
    "Color showColors: (Color wheel: 12 saturation: 0.4 brightness: 1.0)"
    "Color showColors: (Color wheel: 12 saturation: 0.8 brightness: 0.5)"

    ^ (Color h: 0.0 s: s v: v) wheel: thisMany

    "Modified: / 06-06-2007 / 11:20:59 / cg"
! !

!Color class methodsFor:'Signal constants'!

colorAllocationFailSignal
    "return the signal raised when a color allocation failed."

    ^ ColorAllocationFailSignal

    "Created: 12.6.1996 / 17:44:49 / cg"
!

colorErrorSignal
    "return the parent signal of all color error signals."

    ^ ColorErrorSignal

    "Created: / 30.9.1998 / 21:56:04 / cg"
!

invalidColorNameSignal
    "return the signal raised when an invalid color name is encountered"

    ^ InvalidColorNameSignal

    "Created: 24.1.1997 / 13:36:25 / cg"
! !

!Color class methodsFor:'accessing'!

allocatedColorsOn:aDevice
    "return a collection of colors which have already been allocated
     on aDevice."

    <resource: #obsolete>
    self obsoleteMethodWarning:'use #allocatedColorsOnDevice:'.

    ^ self allocatedColorsOnDevice:aDevice
!

allocatedColorsOnDevice:aDevice
    "return a collection of colors which have already been allocated
     on aDevice."

    |colors|

    colors := OrderedCollection new.
    aDevice deviceColors do:[:clr |
	clr colorId notNil ifTrue:[
	    colors add:clr
	] ifFalse:[
	    'Color [oops]: nil colorId in color' infoPrintCR.
	]
    ].
    ^ colors asArray

    "
     Color allocatedColorsOnDevice:Display
    "

    "Modified: 24.2.1997 / 18:16:14 / cg"
! !

!Color class methodsFor:'color space conversions'!

withHLSFromRed:r green:g blue:b do:aBlock
    "compute hls form rgb, evaluate aBlock with h,l and s as arguments.
     r,g,b in 0..100
     h in 0..360; l in 0..100; s in 0..100"

    |max min r1 g1 b1 delta h l s divisor|

    r1 := r / 100.   "scale to  0..1"
    g1 := g / 100.
    b1 := b / 100.

    max := (r1 max:g1) max:b1.
    min := (r1 min:g1) min:b1.
    l := (max + min) / 2.

    max = min ifTrue:[
	"achromatic, r=g=b"

	s := 0.
	h := nil
    ] ifFalse:[
	l < 0.5 ifTrue:[
	    divisor := (max + min)
	] ifFalse:[
	    divisor := (2 - max - min)
	].
	divisor = 0 ifTrue:[
	    s := 1.0
	] ifFalse:[
	    s := (max - min) / divisor
	].
	"calc hue"

	delta := max - min.
	r1 = max ifTrue:[
	    h := (g1 - b1) / delta
	] ifFalse:[
	    g1 = max ifTrue:[
		h := 2 + ((b1 - r1) / delta)
	    ] ifFalse:[
		h := 4 + ((r1 - g1) / delta)
	    ]
	].
	h := h * 60.
	h < 0 ifTrue:[
	    h := h + 360
	].
    ].
    aBlock value:h value:(l * 100) value:(s * 100)

    "Modified: / 27-07-2013 / 11:48:20 / cg"
!

withHLSFromScaledRed:r scaledGreen:g scaledBlue:b do:aBlock
    "compute hls form rgb, evaluate aBlock with h,l and s as arguments"

    ^ self withHLSFromRed:(r * 100.0 / MaxValue)
		    green:(g * 100.0 / MaxValue)
		     blue:(b * 100.0 / MaxValue)
		       do:aBlock

    "Created: 11.6.1996 / 17:23:47 / cg"
!

withRGBFromHue:h light:l saturation:s do:aBlock
    "compute rgb form hls, evaluate aBlock with r,g and b as arguments
     r,g,b in 0..100
     h in 0..360; l in 0..100; s in 0..100"

    |valueFunc s1 l1 r g b m1 m2|

    valueFunc := [:n1 :n2 :hIn |
	|hue|

	hue := hIn.
	hue > 360 ifTrue:[
	    hue := hue - 360
	] ifFalse:[
	    hue < 0 ifTrue:[
		hue := hue + 360
	    ].
	].
	hue < 60 ifTrue:[
	    n1 + ((n2 - n1) * hue / 60)
	] ifFalse:[
	    hue < 180 ifTrue:[
		n2
	    ] ifFalse:[
		hue < 240 ifTrue:[
		    n1 + ((n2 - n1) * (240 - hue) / 60)
		] ifFalse:[
		    n1
		]
	    ]
	]
    ].

    "compute hls; h in 0..360; l 0..100; s 0..100"

    s1 := s / 100.0.   "scale to  0..1"
    l1 := l / 100.0.

    l1 <= 0.5 ifTrue:[
	m2 := l1 * (1 + s1)
    ] ifFalse:[
	m2 := l1 + s1 - (l1 * s1)
    ].

    m1 := 2 * l1 - m2.

    s1 = 0 ifTrue:[
	"achromatic, ignore hue"
	r := g := b := l1
    ] ifFalse:[
	r := valueFunc value:m1 value:m2 value:h + 120.
	g := valueFunc value:m1 value:m2 value:h.
	b := valueFunc value:m1 value:m2 value:h - 120.
    ].
    aBlock value:r*100 value:g*100 value:b*100
! !

!Color class methodsFor:'constant colors'!

black
    "return the black color"

    Black isNil ifTrue:[
	Black := self red:0 green:0 blue:0
    ].
    ^ Black

    "
     Color black inspect
    "

    "Modified: 11.6.1996 / 15:55:31 / cg"
!

blue
    "return the blue color"

    Blue isNil ifTrue:[
	Blue := self redPercent:0 greenPercent:0 bluePercent:100
    ].
    ^ Blue

    "
     Color blue inspect
    "

    "Modified: 23.4.1996 / 13:15:51 / cg"
!

brown
    ^ self redPercent:60 greenPercent:20 bluePercent:0

    "
     Color brown
    "
!

cyan
    "return the cyan color - ST-80 compatibility"

    ^ self cyan:100

    "
     Color cyan inspect
    "

    "Modified: 23.4.1996 / 13:16:07 / cg"
!

cyan: cyan
    "return a cyan color;
     the argument cyan is interpreted as percent (0..100)"

     ^ self cyan:100 magenta:100-cyan yellow:100-cyan

!

darkGray
    "return the dark grey color (English version ;-)"

    DarkGrey isNil ifTrue:[
	DarkGrey := self grayPercent:33
    ].
    ^ DarkGrey

    "
     Color darkGray inspect
    "

    "Modified: 24.2.1997 / 21:33:11 / cg"
!

darkGrey
    "return the darkGrey color (US version ;-)"

    ^ self darkGray

    "
     Color darkGrey inspect
    "

    "Modified: 28.5.1996 / 20:47:14 / cg"
!

gray
    "return a medium grey color (US version ;-)"

    Grey isNil ifTrue:[
	Grey := self grayPercent:50
    ].
    ^ Grey

    "
     Color gray inspect
    "

    "Modified: 24.2.1997 / 21:33:19 / cg"
!

gray:gray
    "return a gray color (US version).
     The argument, gray is interpreted as percent (0..100)."

    ^ self redPercent:gray greenPercent:gray bluePercent:gray

    "
     Color gray:25
    "

    "Modified: 28.5.1996 / 20:49:51 / cg"
!

grayPercent:gray
    "return a gray color (US version).
     The argument, gray is interpreted as percent (0..100)."

    ^ self redPercent:gray greenPercent:gray bluePercent:gray

    "
     Color gray:25
    "

    "Modified: 28.5.1996 / 20:49:51 / cg"
!

green
    "return green"

    Green isNil ifTrue:[
	Green := self redPercent:0 greenPercent:100 bluePercent:0
    ].
    ^ Green

    "
     Color green inspect
    "

    "Modified: 23.4.1996 / 13:23:08 / cg"
!

grey
    "return the grey color (English version ;-)"

    ^ self gray

    "
     Color grey inspect
    "

    "Modified: 28.5.1996 / 20:48:26 / cg"
!

grey:grey
    "return a grey color (English version).
     The argument, grey is interpreted as percent (0..100)."

    ^ self grayPercent:grey

    "
     Color grey:25
     Color grey:12.5
    "

    "Modified: 24.2.1997 / 21:33:28 / cg"
!

greyByte:greyByte
    "return a grey color (English version).
     The argument, grey is interpreted as byte-value (0..255)."

    ^ self redByte:greyByte greenByte:greyByte blueByte:greyByte

    "
     Color greyByte:127
    "
!

lightBlue
    "return a light blue color"

    ^ self redPercent:50 greenPercent:50 bluePercent:100

    "
     Color lightBlue inspect
    "

    "Modified: 23.4.1996 / 13:23:08 / cg"
!

lightBrown
    ^ self brown lighter

    "
     Color lightBrown
    "
!

lightGray
    "return the lightGrey color (US version ;-)"

    LightGrey isNil ifTrue:[
	LightGrey := self grayPercent:67
    ].
    ^ LightGrey

    "
     Color lightGray inspect
    "

    "Modified: 24.2.1997 / 21:33:41 / cg"
!

lightGreen
    "return a light green color"

    ^ self redPercent:50 greenPercent:100 bluePercent:50

    "
     Color lightGreen inspect
    "

    "Modified: 23.4.1996 / 13:23:08 / cg"
!

lightGrey
    "return the lightGrey color (English version ;-)"

    ^ self lightGray

    "
     Color lightGrey inspect
    "

    "Modified: 28.5.1996 / 20:51:11 / cg"
!

lightRed
    "return a light red color"

    ^ self redPercent:100 greenPercent:50 bluePercent:50

    "
     Color lightRed inspect
    "

    "Modified: 23.4.1996 / 13:23:08 / cg"
!

lightYellow
    ^ self yellow lighter
!

magenta
    "return the magenta color - ST-80 compatibility"

    ^ self magenta:100

    "
     Color magenta inspect
    "

    "Modified: 23.4.1996 / 13:23:41 / cg"
!

magenta: magenta
    "return a magenta color;
     the argument magenta is interpreted as percent (0..100)"

     ^ self cyan:100-magenta magenta:100 yellow:100-magenta

!

mediumGray
    "return medium-grey color (US version ;-)"

    ^ self gray

    "
     Color mediumGray inspect
    "

    "Created: 23.4.1996 / 13:24:17 / cg"
    "Modified: 28.5.1996 / 20:51:21 / cg"
!

mediumGrey
    "return medium-grey color (English version ;-)"

    ^ self gray

    "
     Color mediumGrey inspect
    "

    "Modified: 28.5.1996 / 20:51:24 / cg"
!

orange
    "return the orange color - ST-80 compatibility"

    Orange isNil ifTrue:[
        Orange := self redPercent:100 greenPercent:50 bluePercent:0.
    ].
    ^ Orange

    "
     Color orange inspect
    "
!

orange: orange
    "return a orange color;
     the argument orange is interpreted as percent (0..100)"

     ^ self redPercent:orange greenPercent:orange/2 bluePercent:0

!

pink
    "return the pink color - ST-80 compatibility"

     ^ self redPercent:100 greenPercent:0 bluePercent:100

    "Modified: 23.4.1996 / 13:29:38 / cg"
!

red
    "return the red color"

    Red isNil ifTrue:[
        Red := self redPercent:100 greenPercent:0 bluePercent:0.
    ].
    ^ Red

    "
     Color red inspect
    "

    "Modified: 23.4.1996 / 13:29:44 / cg"
!

transparent
    "return the transparent-color"

    Transparent isNil ifTrue:[
	Transparent := TranslucentColor scaledRed:0 scaledGreen:0 scaledBlue:0.
	Transparent setAlphaByte:0.
    ].
    ^ Transparent

    "
     self transparent
    "
!

veryDarkGray
    "return a very dark-grey color (US version ;-)"

    ^ self grayPercent:13

    "Created: 23.4.1996 / 13:33:14 / cg"
    "Modified: 24.2.1997 / 21:33:52 / cg"
!

veryDarkGrey
    "return a very dark-grey color (English version ;-)"

    ^ self veryDarkGray

    "Modified: 28.5.1996 / 20:52:49 / cg"
!

veryLightGray
    "return a very light-grey color (US version ;-)"

    ^ self grayPercent:87

    "Created: 23.4.1996 / 13:33:46 / cg"
    "Modified: 24.2.1997 / 21:33:58 / cg"
!

veryLightGrey
    "return a very light-grey color (English version ;-)"

    ^ self veryLightGray

    "Modified: 28.5.1996 / 20:52:03 / cg"
!

veryVeryLightGray
    "return a very very light-grey color (US version ;-)"

    ^ self grayPercent:93

!

white
    "return the white-color"

    White isNil ifTrue:[
        White := self redPercent:100 greenPercent:100 bluePercent:100.
    ].
    ^ White

    "
     Color white inspect
    "
!

yellow
    "return the yellow color - ST-80 compatibility"

    Yellow isNil ifTrue:[
        Yellow := self redPercent:100 greenPercent:100 bluePercent:0.
    ].
    ^ Yellow

    "
     Color yellow inspect
    "

    "Modified: 23.4.1996 / 13:33:56 / cg"
!

yellow: yellow
    "return a yellow color;
     the argument yellow is interpreted as percent (0..100)"

     ^ self cyan:100-yellow magenta:100-yellow yellow:100

! !

!Color class methodsFor:'obsolete'!

nameOrDither:colorName
    "return a named color - if the exact color is not available,
     return a dithered color. Report an error, if the colorname is
     illegal."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #name:'.
    ^ self name:colorName

    "Modified: 16.1.1997 / 23:01:03 / cg"
!

nameOrDither:colorName ifIllegal:errorBlock
    "return a named color - if the exact color is not available,
     return a dithered color. If the colorname is illegal, return
     the value of evaluating errorBlock."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #name:ifIllegal:'.
    ^ self name:colorName ifIllegal:errorBlock

    "Modified: 16.1.1997 / 23:01:32 / cg"
!

nameOrNearest:colorName
    "return a named color - or its nearest match"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #name:'.
    ^ self name:colorName

    "Modified: 16.1.1997 / 23:02:18 / cg"
! !

!Color class methodsFor:'private'!

colorNearRed:r green:g blue:b on:aDevice
    "return a device color on aDevice with rgb values
     almost matching. If there is one, nil otherwise.
     This is tried as a last chance before dithering.
     The algorithm needs rework, the color components
     should be weighted according some theory :-)"

    |bestColor minDelta diff rr rg rb dRed|

"/    rr := (r * 3.0) rounded / 3.0.
"/    rg := (g * 3.0) rounded / 3.0.
"/    rb := (b * 3.0) rounded / 3.0.

    rr := r rounded.                "round to 1%"
    rg := (g * 2.0) rounded / 2.0.  "round to 0.5%"
    rb := (b / 2) rounded * 2.      "round to 2%"

    minDelta := 100*100*100.
    aDevice deviceColors do:[:aColor |
	dRed := rr - aColor red.
	dRed < 10 ifTrue:[
	    diff := dRed asInteger squared
		    + (rg - aColor green) asInteger squared
		    + (rb - aColor blue) asInteger squared.

	    diff < minDelta ifTrue:[
		diff = 0 ifTrue:[
		    "got it"
		    ^ aColor
		].
		bestColor := aColor.
		minDelta := diff
	    ]
	]
    ].

    "allow an error of 10% per component"
    minDelta < (100+100+100) ifTrue:[ ^ bestColor ].
    ^ nil

    "Modified: 24.2.1997 / 18:17:24 / cg"
!

existingColorRed:r green:g blue:b on:aDevice
    "return a device color on aDevice with rgb values
     if there is one, nil otherwise."

    ^ self existingColorScaledRed:(r * MaxValue // 100)
			scaledGreen:(g * MaxValue // 100)
			scaledBlue:(b * MaxValue // 100)
!

existingColorScaledRed:r scaledGreen:g scaledBlue:b on:aDevice
    "return a device color on aDevice with rgb values
     if there is one, nil otherwise."

    aDevice deviceColors do:[:aColor |
	(r == aColor scaledRed) ifTrue:[
	    (g == aColor scaledGreen) ifTrue:[
		(b == aColor scaledBlue) ifTrue:[
		    ^ aColor
		]
	    ]
	]
    ].
    ^ nil

    "Modified: 24.2.1997 / 18:17:35 / cg"
! !

!Color class methodsFor:'private-dithering'!

complexDitherRed:red green:green blue:blue on:aDevice into:aBlock
    "get a deep dither form for an rgb value.
     Use all available colors for error dithering into a form."

    |errR errG errB f wantR wantG wantB clr
     dir   "{ Class: SmallInteger }"
     start "{ Class: SmallInteger }"
     end   "{ Class: SmallInteger }"
     map
     w     "{ Class: SmallInteger }"
     h     "{ Class: SmallInteger }"|

"/    w := h := 32.
"/    w := h := 4.
    w := h := 2.

    errR := 0.
    errG := 0.
    errB := 0.

    "get a form and clear it"
    f := Form width:w height:h depth:(aDevice depth) onDevice:aDevice.
    f isNil ifTrue:[^ nil].
    map := IdentityDictionary new.

    0 to:(w-1) do:[:x |
        x even ifTrue:[
            dir := 1.
            start := 0.
            end := (h-1).
        ] ifFalse:[
            dir := -1.
            start := (h-1).
            end := 0.
        ].
        start to:end by:dir do:[:y |
            wantR := red + errR.
            wantR > MaxValue ifTrue:[
                wantR := MaxValue
            ] ifFalse:[ wantR < 0 ifTrue:[
                wantR := 0
            ]].

            wantG := green + errG.
            wantG > MaxValue ifTrue:[
                wantG := MaxValue
            ] ifFalse:[ wantG < 0 ifTrue:[
                wantG := 0
            ]].

            wantB := blue + errB.
            wantB > MaxValue ifTrue:[
                wantB := MaxValue
            ] ifFalse:[ wantB < 0 ifTrue:[
                wantB := 0
            ]].

            "find the nearest color"

            clr := Color quickNearestColorScaledRed:wantR scaledGreen:wantG scaledBlue:wantB on:aDevice.
"
            clr := Color nearestColorScaledRed:wantR green:wantG blue:wantB on:aDevice.
"
            clr isNil ifTrue:[
                clr := Color scaledRed:wantR scaledGreen:wantG scaledBlue:wantB.
                clr brightness > 0.5 ifTrue:[
                    clr := Color white
                ] ifFalse:[
                    clr := Color black
                ].
                clr := clr onDevice:aDevice
"
                ^ aBlock value:nil value:nil
"
            ].

            f paint:clr.
            f displayPointX:x y:y.
            map at:clr colorId + 1 put:clr.

            "compute the new error"
            errR := wantR - clr scaledRed.
            errG := wantG - clr scaledGreen.
            errB := wantB - clr scaledBlue.
        ].
    ].

    f colorMap:map.
"
'hard dither' printNewline.
"
    ^ aBlock value:nil value:f

    "Created: 3.5.1997 / 11:02:47 / cg"
    "Modified: 19.10.1997 / 23:28:59 / cg"
!

ditherBits
    "return a dither pattern for x/64; x in 1..63"

    ^ #(

	"/ 1in64

	  #[2r10000000
	    2r00000000
	    2r00000000
	    2r00000000
	    2r00000000
	    2r00000000
	    2r00000000
	    2r00000000]

	"/ 2in64

	  #[2r10000000
	    2r00000000
	    2r00000000
	    2r00000000
	    2r00001000
	    2r00000000
	    2r00000000
	    2r00000000]

	"/ 3in64

	  #[2r10000000
	    2r00000000
	    2r00000000
	    2r00000000
	    2r10001000
	    2r00000000
	    2r00000000
	    2r00000000]

	"/ 4in64

	  #[2r10001000
	    2r00000000
	    2r00000000
	    2r00000000
	    2r10001000
	    2r00000000
	    2r00000000
	    2r00000000]

	"/ 5in64

	  #[2r10001000
	    2r00000000
	    2r00000000
	    2r00000000
	    2r10001000
	    2r00000000
	    2r00000010
	    2r00000000]

	"/ 6in64

	  #[2r10001000
	    2r00000000
	    2r00100000
	    2r00000000
	    2r10001000
	    2r00000000
	    2r00000010
	    2r00000000]

	"/ 7in64

	  #[2r10001000
	    2r00000000
	    2r00100010
	    2r00000000
	    2r10001000
	    2r00000000
	    2r00000010
	    2r00000000]

	"/ 8in64

	  #[2r10001000
	    2r00000000
	    2r00100010
	    2r00000000
	    2r10001000
	    2r00000000
	    2r00100010
	    2r00000000]

	"/ 9in64

	  #[2r10001000
	    2r00000000
	    2r00100010
	    2r00000000
	    2r10001000
	    2r00000000
	    2r10100010
	    2r00000000]

	"/ 10in64

	  #[2r10001000
	    2r00000000
	    2r00101010
	    2r00000000
	    2r10001000
	    2r00000000
	    2r10100010
	    2r00000000]

	"/ 11in64

	  #[2r10001000
	    2r00000000
	    2r00101010
	    2r00000000
	    2r10001000
	    2r00000000
	    2r10101010
	    2r00000000]

	"/ 12in64

	  #[2r10001000
	    2r00000000
	    2r10101010
	    2r00000000
	    2r10001000
	    2r00000000
	    2r10101010
	    2r00000000]

	"/ 13in64

	  #[2r10001000
	    2r00000000
	    2r10101010
	    2r00000000
	    2r10101000
	    2r00000000
	    2r10101010
	    2r00000000]

	"/ 14in64

	  #[2r10001010
	    2r00000000
	    2r10101010
	    2r00000000
	    2r10101000
	    2r00000000
	    2r10101010
	    2r00000000]

	"/ 15in64

	  #[2r10001010
	    2r00000000
	    2r10101010
	    2r00000000
	    2r10101010
	    2r00000000
	    2r10101010
	    2r00000000]

	"/ 16in64

	  #[2r10101010
	    2r00000000
	    2r10101010
	    2r00000000
	    2r10101010
	    2r00000000
	    2r10101010
	    2r00000000]

	"/ 17in64

	  #[2r10101010
	    2r01000000
	    2r10101010
	    2r00000000
	    2r10101010
	    2r00000000
	    2r10101010
	    2r00000000]

	"/ 18in64

	  #[2r10101010
	    2r01000000
	    2r10101010
	    2r00000000
	    2r10101010
	    2r00000100
	    2r10101010
	    2r00000000]

	"/ 19in64

	  #[2r10101010
	    2r01000000
	    2r10101010
	    2r00000000
	    2r10101010
	    2r01000100
	    2r10101010
	    2r00000000]

	"/ 20in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r00000000
	    2r10101010
	    2r01000100
	    2r10101010
	    2r00000000]

	"/ 21in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r00000000
	    2r10101010
	    2r01000100
	    2r10101010
	    2r00000001]

	"/ 22in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r00010000
	    2r10101010
	    2r01000100
	    2r10101010
	    2r00000001]

	"/ 23in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r00010001
	    2r10101010
	    2r01000100
	    2r10101010
	    2r00000001]

	"/ 24in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r00010001
	    2r10101010
	    2r01000100
	    2r10101010
	    2r00010001]

	"/ 25in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r00010001
	    2r10101010
	    2r01000100
	    2r10101010
	    2r01010001]

	"/ 26in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r00010101
	    2r10101010
	    2r01000100
	    2r10101010
	    2r01010001]

	"/ 27in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r00010101
	    2r10101010
	    2r01000100
	    2r10101010
	    2r01010101]

	"/ 28in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01000100
	    2r10101010
	    2r01010101]

	"/ 29in64

	  #[2r10101010
	    2r01000100
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01010100
	    2r10101010
	    2r01010101]

	"/ 30in64

	  #[2r10101010
	    2r01000101
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01010100
	    2r10101010
	    2r01010101]

	"/ 31in64

	  #[2r10101010
	    2r01000101
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01010101]

	"/ 32in64

	  #[2r10101010
	    2r01010101
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01010101]

	"/ 33in64

	  #[2r11101010
	    2r01010101
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01010101
	    2r10101010
	    2r01010101]

	"/ 34in64

	  #[2r11101010
	    2r01010101
	    2r10101010
	    2r01010101
	    2r10101110
	    2r01010101
	    2r10101010
	    2r01010101]

	"/ 35in64

	  #[2r11101010
	    2r01010101
	    2r10101010
	    2r01010101
	    2r11101110
	    2r01010101
	    2r10101010
	    2r01010101]

	"/ 36in64

	  #[2r11101110
	    2r01010101
	    2r10101010
	    2r01010101
	    2r11101110
	    2r01010101
	    2r10101010
	    2r01010101]

	"/ 37in64

	  #[2r11101110
	    2r01010101
	    2r10101010
	    2r01010101
	    2r11101110
	    2r01010101
	    2r10101011
	    2r01010101]

	"/ 38in64

	  #[2r11101110
	    2r01010101
	    2r10111010
	    2r01010101
	    2r11101110
	    2r01010101
	    2r10101011
	    2r01010101]

	"/ 39in64

	  #[2r11101110
	    2r01010101
	    2r10111011
	    2r01010101
	    2r11101110
	    2r01010101
	    2r10101011
	    2r01010101]

	"/ 40in64

	  #[2r11101110
	    2r01010101
	    2r10111011
	    2r01010101
	    2r11101110
	    2r01010101
	    2r10111011
	    2r01010101]

	"/ 41in64

	  #[2r11101110
	    2r01010101
	    2r10111011
	    2r01010101
	    2r11101110
	    2r01010101
	    2r11111011
	    2r01010101]

	"/ 42in64

	  #[2r11101110
	    2r01010101
	    2r10111111
	    2r01010101
	    2r11101110
	    2r01010101
	    2r11111011
	    2r01010101]

	"/ 43in64

	  #[2r11101110
	    2r01010101
	    2r10111111
	    2r01010101
	    2r11101110
	    2r01010101
	    2r11111111
	    2r01010101]

	"/ 44in64

	  #[2r11101110
	    2r01010101
	    2r11111111
	    2r01010101
	    2r11101110
	    2r01010101
	    2r11111111
	    2r01010101]

	"/ 45in64

	  #[2r11101110
	    2r01010101
	    2r11111111
	    2r01010101
	    2r11111110
	    2r01010101
	    2r11111111
	    2r01010101]

	"/ 46in64

	  #[2r11101111
	    2r01010101
	    2r11111111
	    2r01010101
	    2r11111110
	    2r01010101
	    2r11111111
	    2r01010101]

	"/ 47in64

	  #[2r11101111
	    2r01010101
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01010101]

	"/ 48in64

	  #[2r11111111
	    2r01010101
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01010101]

	"/ 49in64

	  #[2r11111111
	    2r01110101
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01010101]

	"/ 50in64

	  #[2r11111111
	    2r01110101
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01010111
	    2r11111111
	    2r01010101]

	"/ 51in64

	  #[2r11111111
	    2r01110101
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01110111
	    2r11111111
	    2r01010101]

	"/ 52in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01110111
	    2r11111111
	    2r01010101]

	"/ 53in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r01010101
	    2r11111111
	    2r01110111
	    2r11111111
	    2r11010101]

	"/ 54in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r01011101
	    2r11111111
	    2r01110111
	    2r11111111
	    2r11010101]

	"/ 55in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r11011101
	    2r11111111
	    2r01110111
	    2r11111111
	    2r11010101]

	"/ 56in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r11011101
	    2r11111111
	    2r01110111
	    2r11111111
	    2r11011101]

	"/ 57in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r11011101
	    2r11111111
	    2r01110111
	    2r11111111
	    2r11111101]

	"/ 58in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r11011111
	    2r11111111
	    2r01110111
	    2r11111111
	    2r11111101]

	"/ 59in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r11011111
	    2r11111111
	    2r01110111
	    2r11111111
	    2r11111111]

	"/ 60in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r11111111
	    2r11111111
	    2r01110111
	    2r11111111
	    2r11111111]

	"/ 61in64

	  #[2r11111111
	    2r01110111
	    2r11111111
	    2r11111111
	    2r11111111
	    2r01111111
	    2r11111111
	    2r11111111]

	"/ 62in64

	  #[2r11111111
	    2r11110111
	    2r11111111
	    2r11111111
	    2r11111111
	    2r01111111
	    2r11111111
	    2r11111111]

	"/ 63in64

	  #[2r11111111
	    2r11110111
	    2r11111111
	    2r11111111
	    2r11111111
	    2r11111111
	    2r11111111
	    2r11111111]
     )

    "Modified: 23.4.1996 / 13:31:50 / cg"
    "Created: 11.6.1996 / 15:34:29 / cg"
!

ditherGrayFor:fraction on:aDevice into:aBlock
    "get a dither form or colorId for a brightness value.
     Fraction is 0..1.
     Returns 2 values (either color or ditherForm) through aBlock."

    |d nGray grayBelow scaledGrey scaledGray1 scaledGray2 clr1 clr2 newFraction step|

    d := aDevice depth.

    "/ special code for b&w displays

    d == 1 ifTrue:[
	aDevice blackpixel == 0 ifTrue:[
	    clr1 := Black.
	    clr2 := White.
	    newFraction := fraction.
	] ifFalse:[
	    clr1 := White.
	    clr2 := Black.
	    newFraction := 1 - fraction
	]
    ] ifFalse:[
	"/ special code for 2-plane displays (NeXT)

	d == 2 ifTrue:[
	    fraction <= 0.01 ifTrue:[
		clr1 := Black exactOn:aDevice
	    ] ifFalse:[
		(fraction between:0.32 and:0.34) ifTrue:[
		    clr1 := (Color gray:33) exactOn:aDevice
		] ifFalse:[
		    (fraction between:0.66 and:0.68) ifTrue:[
			clr1 := (Color gray:67) exactOn:aDevice
		    ] ifFalse:[
			fraction >= 0.99 ifTrue:[
			    clr1 := White exactOn:aDevice
			]
		    ]
		]
	    ].
	    clr1 notNil ifTrue:[
		^ aBlock value:clr1 value:nil
	    ].

	    (fraction between:0 and:0.33) ifTrue:[
		clr1 := Black.
		clr2 := Color gray:33.
	    ] ifFalse:[
		(fraction between:0.34 and:0.66) ifTrue:[
		    clr1 := Color gray:33.
		    clr2 := Color gray:67.
		] ifFalse:[
		    clr1 := Color gray:67.
		    clr2 := White.
		]
	    ].
	    scaledGray1 := clr1 scaledRed.
	    scaledGray2 := clr2 scaledRed.

	    scaledGrey := (MaxValue * fraction) rounded.
	] ifFalse:[
	    nGray := (1 bitShift:d) - 1.

	    "/ scale greyValue into grey levels

	    grayBelow := (fraction * nGray) truncated.

	    grayBelow < 0 ifTrue:[
		^ Color black exactOn:aDevice
	    ].
	    grayBelow >= nGray ifTrue:[
		^ Color white exactOn:aDevice
	    ].

	    scaledGrey := (MaxValue * fraction) rounded.

	    step := MaxValue // nGray.
	    scaledGray1 := grayBelow * step.
	    scaledGray2 := scaledGray1 + step.

	    clr1 := Color scaledGray:scaledGray1.
	    clr2 := Color scaledGray:scaledGray2.
	].

	"/ scale remainder in between low..high
	newFraction := (scaledGrey - scaledGray1) asFloat / (scaledGray2 - scaledGray1).
    ].

    clr1 := clr1 exactOn:aDevice.
    clr2 := clr2 exactOn:aDevice.

    (clr1 isNil or:[clr2 isNil]) ifTrue:[
	"/ fall back to b&w dither
	aDevice blackpixel == 0 ifTrue:[
	    clr1 := Black.
	    clr2 := White.
	    newFraction := fraction.
	] ifFalse:[
	    clr1 := White.
	    clr2 := Black.
	    newFraction := 1 - fraction
	]
    ].

    ^ self
	monoDitherFor:newFraction
	between:clr1 and:clr2
	on:aDevice
	into:aBlock

    "
     Color basicNew
	ditherGrayFor:0.5
	on:Display
	into:[:clr :form | clr notNil ifTrue:[clr inspect].
			   form notNil ifTrue:[(form magnifiedBy:16) inspect].]
    "
    "
     Color basicNew
	ditherGrayFor:0.25
	on:Display
	into:[:clr :form | clr notNil ifTrue:[clr inspect].
			   form notNil ifTrue:[(form magnifiedBy:16) inspect].]
    "

    "Created: / 03-05-1997 / 10:59:57 / cg"
    "Modified: / 24-07-2011 / 07:18:00 / cg"
!

ditherRed:rV green:gV blue:bV on:aDevice into:aBlock
    "get a dither form or colorId for an rgb value.
     Returns 2 values (either color or ditherForm) through
     aBlock.
     This code is just a minimum of what is really needed,
     and needs much more work. Currently only some special cases
     are handled"

    |rh rl rs
     lowL hiL lowValL hiValL lowS hiS lowValS hiValS lowH hiH lowValH hiValH d|

    "get hls (since we dither anyway, round them a bit"

    Color withHLSFromScaledRed:rV scaledGreen:gV scaledBlue:bV do:[:hue :light :saturation |
        hue notNil ifTrue:[
            rh := (hue * 3.0) rounded / 3.0.
        ].
        rl := (light * 3.0) rounded / 3.0.
        rs := (saturation * 3.0) rounded / 3.0.
    ].

    rh isNil ifTrue:[
        "achromatic,  dither between achromatic colors"

        lowL := nil.
        hiL := nil.

        "find the 2 bounding colors"
        aDevice deviceColors do:[:aColor |
            aColor colorId notNil ifTrue:[

                Color withHLSFromRed:aColor red green:aColor green blue:aColor blue do:[:hue :light :saturation |
                    | cl |

                    hue isNil ifTrue:[
                        cl := (light * 3.0) rounded / 3.0.

                        cl > rl ifTrue:[
                            hiL isNil ifTrue:[
                                hiL := aColor.
                                hiValL := cl.
                            ] ifFalse:[
                                cl < hiValL ifTrue:[
                                    hiL := aColor.
                                    hiValL := cl.
                                ]
                            ]
                        ] ifFalse:[
                            lowL isNil ifTrue:[
                                lowL := aColor.
                                lowValL := cl
                            ] ifFalse:[
                                cl > lowValL ifTrue:[
                                    lowL := aColor.
                                    lowValL := cl
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ].

        (lowL notNil and:[hiL notNil]) ifTrue:[
            ^ self
                monoDitherFor:1.0 / (hiValL - lowValL) * (rl - lowValL)
                between:lowL and:hiL
                on:aDevice
                into:aBlock
        ].
        "cannot happen, should always find at least black and white"
        'Color [info]: oops - color to dither is not bound by b&w' infoPrintCR.

        ^ aBlock value:nil value:nil
    ].

    "chromatic case"

    aDevice hasColors ifFalse:[
        "no chance, return nil values"
        ^ aBlock value:nil value:nil
    ].
    (Red isNil or:[Green isNil or:[Blue isNil]]) ifTrue:[
        "if we where not able to get primary colors: no chance"
        ^ aBlock value:nil value:nil
    ].

    "try to find two bounding colors with same hue and saturation;
     dither on light between those"

    lowL := nil.
    hiL := nil.
    lowS := nil.
    hiS := nil.
    lowH := nil.
    hiH := nil.

    aDevice deviceColors do:[:aColor |
        aColor colorId notNil ifTrue:[
            Color withHLSFromRed:aColor red green:aColor green blue:aColor blue do:[:hue :light :saturation |
                | cl ch cs|

                hue notNil ifTrue:[
                   ch := (hue * 3.0) rounded / 3.0.
                ] ifFalse:[
                   ch := nil
                ].
                cl := (light * 3.0) rounded / 3.0.
                cs := (saturation * 3.0) rounded / 3.0.

                ((ch = rh) and:[cs = rs]) ifTrue:[
                    "found a color with same saturation and same hue, keep for light"

                    cl > rl ifTrue:[
                        hiL isNil ifTrue:[
                            hiL := aColor.
                            hiValL := cl
                        ] ifFalse:[
                            cl < hiValL ifTrue:[
                                hiL := aColor.
                                hiValL := cl
                            ]
                        ].
                    ] ifFalse:[
                        lowL isNil ifTrue:[
                            lowL := aColor.
                            lowValL := cl
                        ] ifFalse:[
                            cl > lowValL ifTrue:[
                                lowL := aColor.
                                lowValL := cl
                            ]
                        ]
                    ]
                ].

                (((ch = rh) or:[ch isNil]) and:[cl = rl]) ifTrue:[
                    "found a color with same light and same hue, keep for saturation"

                    cs > rs ifTrue:[
                        hiS isNil ifTrue:[
                            hiS := aColor.
                            hiValS := cs
                        ] ifFalse:[
                            cs < hiValS ifTrue:[
                                hiS := aColor.
                                hiValS := cs
                            ]
                        ].
                    ] ifFalse:[
                        lowS isNil ifTrue:[
                            lowS := aColor.
                            lowValS := cs
                        ] ifFalse:[
                            cs > lowValS ifTrue:[
                                lowS := aColor.
                                lowValS := cs
                            ]
                        ]
                    ]
                ].

                rh notNil ifTrue:[
                    cl = rl ifTrue:[
                        cs = rs ifTrue:[
                            ch notNil ifTrue:[
                                d := (ch - rh) abs.
                                d > 300 ifTrue:[
                                    rh > 180 ifTrue:[
                                        ch := ch + 360
                                    ] ifFalse:[
                                        ch := ch - 360
                                    ].
                                ].
                                ch > rh ifTrue:[
                                    hiH isNil ifTrue:[
                                        hiH := aColor.
                                        hiValH := ch
                                    ] ifFalse:[
                                        ch < hiValH ifTrue:[
                                            hiH := aColor.
                                            hiValH := ch
                                        ]
                                    ]
                                ] ifFalse:[
                                    lowH isNil ifTrue:[
                                        lowH := aColor.
                                        lowValH := ch
                                    ] ifFalse:[
                                        ch > lowValH ifTrue:[
                                            lowH := aColor.
                                            lowValH := ch
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    "found bounds for light ?"

    lowL notNil ifTrue:[
        rl = lowValL ifTrue:[
            ^ aBlock value:lowL value:nil
        ].
        hiL notNil ifTrue:[
            ^ self
                monoDitherFor:1.0 / (hiValL - lowValL) / (rl - lowValL)
                between:lowL and:hiL
                on:aDevice
                into:aBlock
        ].
        "found bound for light - dither with white"
        ^ self
            monoDitherFor:1.0 / (100 - lowValL) / (rl - lowValL)
            between:lowL and:White
            on:aDevice
            into:aBlock
    ].

    "found bound for light - dither with black"
    hiL notNil ifTrue:[
        ^ self
            monoDitherFor:1.0 / (hiValL) / (rl)
            between:Black and:hiL
            on:aDevice
            into:aBlock
    ].


    "found bounds for saturation?"

    (lowS notNil and:[hiS notNil]) ifTrue:[
"
        'saturation dither' printNewline.
"
        ^ self
            monoDitherFor:1.0 / (hiValS - lowValS) / (rs - lowValS)
            between:lowS and:hiS
            on:aDevice
            into:aBlock
    ].

    "found bounds for hue ?"

    (lowH notNil and:[hiH notNil]) ifTrue:[
"
        'hue dither' printNewline.
"
        hiValH < lowValH ifTrue:[
            hiValH := hiValH + 360
        ].

        d := hiValH - lowValH.

        ^ self
            monoDitherFor:1.0 / (d / (rh - lowValH))
            between:lowH and:hiH
            on:aDevice
            into:aBlock
    ].

    ^ aBlock value:nil value:nil

    "Modified: 3.5.1997 / 10:58:54 / cg"
    "Created: 3.5.1997 / 11:02:03 / cg"
!

fixDitherRed:redVal green:greenVal blue:blueVal on:aDevice into:aBlock
    "get a dither form for an rgb value.
     Returns 2 values (either color or ditherForm) through aBlock.
     This code uses the table of preallocated fix-colors to find
     dither colors."

    |
     nR "{ Class: SmallInteger }"
     nG "{ Class: SmallInteger }"
     nB "{ Class: SmallInteger }"
     hR "{ Class: SmallInteger }"
     hG "{ Class: SmallInteger }"
     hB "{ Class: SmallInteger }"
     eR eG eB
     rI "{ Class: SmallInteger }"
     gI "{ Class: SmallInteger }"
     bI  "{ Class: SmallInteger }"
     idx "{ Class: SmallInteger }"
     f clr
     r    "{ Class: SmallInteger }"
     g    "{ Class: SmallInteger }"
     b    "{ Class: SmallInteger }"
     x1   "{ Class: SmallInteger }"
     x2   "{ Class: SmallInteger }"
     step "{ Class: SmallInteger }"
     lastIdx mx
     dS   "{ Class: SmallInteger }"
     cube|

    (cube := aDevice fixColors) notNil ifTrue:[
        dS := 4.

        f := Form width:dS height:dS depth:(aDevice depth) onDevice:aDevice.
        f isNil ifTrue:[^ nil].
        f initGC.

        mx := MaxValue asFloat.

        nR := aDevice numFixRed.
        nG := aDevice numFixGreen.
        nB := aDevice numFixBlue.

        hR := nR // 2.
        hG := nG // 2.
        hB := nB // 2.

        eR := eG := eB := 0.
        r := redVal.
        g := greenVal.
        b := blueVal.

        step := -1.

        0 to:dS-1 do:[:y |
            step == -1 ifTrue:[
                x1 := 0. x2 := dS-1. step := 1.
            ] ifFalse:[
                x1 := dS-1. x2 := 0. step := -1.
            ].

            x1 to:x2 by:step do:[:x |
                "/ the nearest along the grid

                r := redVal + eR.
                r > MaxValue ifTrue:[r := MaxValue]
                             ifFalse:[r < 0 ifTrue:[r := 0]].
                g := greenVal + eG.
                g > MaxValue ifTrue:[g := MaxValue]
                             ifFalse:[g < 0 ifTrue:[g := 0]].

                b := blueVal + eB.
                b > MaxValue ifTrue:[b := MaxValue]
                             ifFalse:[b < 0 ifTrue:[b := 0]].

                rI := (r * (nR-1) + hR / mx) rounded.
                gI := (g * (nG-1) + hG / mx) rounded .
                bI := (b * (nB-1) + hB / mx) rounded .

                idx := (((rI * nG) + gI) * nB + bI) + 1.
                clr := (cube at:idx) exactOn:aDevice.
                lastIdx isNil ifTrue:[lastIdx := idx]
                ifFalse:[lastIdx ~~ idx ifTrue:[lastIdx := -1]].

                f foreground:clr.
                f displayPointX:x y:y.

                eR := r  - clr scaledRed.
                eG := g  - clr scaledGreen.
                eB := b  - clr scaledBlue.
            ].
        ].
        f releaseGC.

        lastIdx ~~ -1 ifTrue:[
            ^ aBlock value:clr value:nil
        ].
        ^ aBlock value:nil value:f

    ].

    ^ aBlock value:nil value:nil

    "Modified: 11.7.1996 / 18:30:28 / cg"
    "Created: 3.5.1997 / 11:03:18 / cg"
!

monoDitherFor:fraction between:color1 and:color2 on:aDevice into:aBlock
    "get a dither form or colorId for dithering between 2 colors.
     Fraction is 0..1.
     Returns 2 values (either color or ditherForm) through aBlock."

    |form c1 c2
     index "{ Class:SmallInteger }"|

    "/
    "/ having forms with: [1 .. 63] of 64 pixels (see Form),
    "/ we get dithers for: 1/64, 2/64, ... 63/64
    "/

    index := (fraction * 64) rounded.

    c1 := color1 exactOn:aDevice.
    index < 1 ifTrue:[
	^ aBlock value:c1 value:nil
    ].

    c2 := color2 exactOn:aDevice.
    index >= 64 ifTrue:[
	^ aBlock value:c2 value:nil
    ].

    form := Form width:8 height:8 fromArray:(DitherBits at:index) onDevice:aDevice.
    form colorMap:(Array with:c1 with:c2).
    ^ aBlock value:nil value:form

    "
     Color basicNew
	monoDitherFor:(MaxValue // 2)
	between:Color black
	and:Color white
	on:Display
	into:[:clr :dither | clr inspect. dither inspect]
    "

    "Created: 3.5.1997 / 10:55:06 / cg"
    "Modified: 3.5.1997 / 11:05:20 / cg"
! !

!Color class methodsFor:'queries'!

constantNames
    "return names known as instance creation messages"

    ^ #(white black
        grey mediumGray veryLightGray lightGray darkGray veryDarkGray
        red green blue cyan yellow pink orange magenta)

    "Modified: 2.5.1996 / 11:34:05 / cg"
!

scalingValue
    "ST-80 compatibility"

    ^ MaxValue

    "Created: 2.5.1996 / 11:30:09 / cg"
    "Modified: 11.7.1996 / 21:42:26 / cg"
! !

!Color class methodsFor:'special instance creation'!

nearestColorRed:r green:g blue:b on:aDevice in:colors
    "return the nearest color on aDevice with RGB values
     same or near r/g/b in a collection of colors.
     If there is one, return it; nil otherwise.
     Near is defined as having an error less than the argument
     error (in percent). The error is computed by the color
     vector distance (which may not be the best possible solution)."

    ^ self
	nearestColorScaledRed:(r * MaxValue // 100)
		  scaledGreen:(g * MaxValue // 100)
		   scaledBlue:(b * MaxValue // 100)
			   on:aDevice
			   in:colors

    "Modified: 11.6.1996 / 18:04:55 / cg"
    "Created: 14.6.1996 / 20:05:13 / cg"
!

nearestColorScaledRed:r scaledGreen:g scaledBlue:b inCube:aColorCube numRed:nRed numGreen:nGreen numBlue:nBlue
    "return a color with rgb values same or near r/g/b in a given
     collection, containing colors from a colorCube.
     This is used with preallocated fixColors and is quite fast
     (no need to search)"

    |sR  "{ Class: SmallInteger }"
     sG  "{ Class: SmallInteger }"
     sB  "{ Class: SmallInteger }"
     idx "{ Class: SmallInteger }"
     nR  "{ Class: SmallInteger }"
     nG  "{ Class: SmallInteger }"
     nB  "{ Class: SmallInteger }"
     rI  "{ Class: SmallInteger }"
     gI  "{ Class: SmallInteger }"
     bI  "{ Class: SmallInteger }"|

    "
     round to the step given by FixColors
    "
    nR := nRed.
    nG := nGreen.
    nB := nBlue.

    sR := MaxValue // (nR - 1).
    sG := MaxValue // (nG - 1).
    sB := MaxValue // (nB - 1).

    rI := (r + (sR // 2)) // sR.
    gI := (g + (sG // 2)) // sG.
    bI := (b + (sB // 2)) // sB.
    idx := (((rI * nG) + gI) * nB + bI) + 1.
    ^ aColorCube at:idx

    "Modified: 11.7.1996 / 17:52:46 / cg"
    "Created: 11.7.1996 / 18:20:13 / cg"
!

nearestColorScaledRed:r scaledGreen:g scaledBlue:b on:aDevice
    "return a device color on aDevice with RGB values
     same or near r/g/b, if there is one, nil otherwise.
     Near is defined as having an error less than the argument
     error (in percent). The error is computed by the color
     vector distance (which may not be the best possible solution)."

    |cube|

    "
     if there are preallocated colors, things are much easier ...
    "
    (cube := aDevice fixColors) notNil ifTrue:[
	^ self
	    nearestColorScaledRed:r
	    scaledGreen:g
	    scaledBlue:b
	    inCube:cube
	    numRed:(aDevice numFixRed)
	    numGreen:(aDevice numFixGreen)
	    numBlue:(aDevice numFixBlue)
    ].

    "
     search in existing colors ...
    "
    ^ self
	nearestColorScaledRed:r
	scaledGreen:g
	scaledBlue:b
	on:aDevice
	in:aDevice deviceColors

    "Created: 14.6.1996 / 20:11:18 / cg"
    "Modified: 24.2.1997 / 18:17:51 / cg"
!

nearestColorScaledRed:r scaledGreen:g scaledBlue:b on:aDevice in:colors
    "return the nearest color on aDevice with RGB values
     same or near r/g/b in a collection of colors.
     If there is one, return it; nil otherwise."

    |delta minDelta bestSoFar|

    minDelta := 9999999.

    colors isNil ifTrue:[^ nil].

    colors do:[:aColor |
	|cr cg cb|

	(aDevice isNil
	or:[(aColor graphicsDevice == aDevice)
	    and:[aColor colorId notNil]]) ifTrue:[
		delta := aColor deltaFromScaledRed:r scaledGreen:g scaledBlue:b.
		delta < minDelta ifTrue:[
		    "
		     an exact fit - no need to continue search
		    "
		    delta == 0 ifTrue:[^ aColor].

		    bestSoFar := aColor.
		    minDelta := delta
		]
	    ]
    ].

    ^ bestSoFar

    "Created: / 11.6.1996 / 18:02:12 / cg"
    "Modified: / 28.7.1998 / 20:40:41 / cg"
!

quickNearestColorScaledRed:r scaledGreen:g scaledBlue:b on:aDevice
    "return a device color on aDevice with rgb values
     same or near r/g/b.
     This looks for primary colors only and is thus faster
     than the general nearestColor search (slightly uglier though)."

    |cube|

    "
     if there are preallocated colors, things are much easier ...
    "
    (cube := aDevice fixColors) notNil ifTrue:[
	^ self
	    nearestColorScaledRed:r
	    scaledGreen:g
	    scaledBlue:b
	    inCube:cube
	    numRed:(aDevice numFixRed)
	    numGreen:(aDevice numFixGreen)
	    numBlue:(aDevice numFixBlue)
    ].

    "
     search in existing colors ...
    "
    ^ self nearestColorScaledRed:r
		     scaledGreen:g
		      scaledBlue:b
			on:aDevice
			in:(aDevice availableDitherColors)

    "Created: 14.6.1996 / 20:13:22 / cg"
    "Modified: 11.7.1996 / 18:20:14 / cg"
! !

!Color methodsFor:'Compatibility-ST80'!

asDevicePaintOn:aDevice
    "ST-80 compatibility: an alias for on:.
     create a new Color representing the same color as
     myself on aDevice; if one already exists, return the one"

    ^ self onDevice:aDevice
!

asHiliteColor
    "same as lightened - for ST-80 compatibility"

    ^ self lightened
!

asShadowColor
    "same as darkened - for ST-80 compatibility"

    ^ self darkened
! !

!Color methodsFor:'Compatibility-Squeak'!

alphaMixed: proportion with: aColor
    "Answer this color mixed with the given color. The proportion, a number
     between 0.0 and 1.0, determines what what fraction of the receiver to
     use in the mix. For example, 0.9 would yield a color close to the
     receiver. This method uses RGB interpolation; HSV interpolation can lead
     to surprises.  Mixes the alphas (for transparency) also."

    | frac1 frac2 |

    frac1 := proportion asFloat min: 1.0 max: 0.0.
    frac2 := 1.0 - frac1.
    ^ self class
        r: ((red * frac1) + (aColor scaledRed * frac2)) / MaxValue
        g: ((green * frac1) + (aColor scaledGreen * frac2)) / MaxValue
        b: ((blue * frac1) + (aColor scaledBlue * frac2)) / MaxValue
        alpha: (self alpha * frac1) + (aColor alpha * frac2)

    "
     (Color r:1 g:0 b:0 alpha:1) alphaMixed:0.5 with:(Color r:1 g:0 b:0 alpha:1)
     (Color r:1 g:0 b:0 alpha:0.5) alphaMixed:0.5 with:(Color r:0 g:1 b:0 alpha:0.5)
    "

    "Created: / 06-06-2007 / 10:53:25 / cg"
!

bitPatternForDepth: depth
    "Return a Bitmap, possibly containing a stipple pattern,
     that best represents this color at the given depth.
     BitBlt calls this method to convert colors into Bitmaps.
     The resulting Bitmap may be multiple words to represent a stipple
     pattern of several lines.  "

    "See also:
	pixelValueAtDepth:      -- value for single pixel
	pixelWordAtDepth:       -- a 32-bit word filled with the pixel value"
    "Details: The pattern for the most recently requested depth is cached."

^ self.
"/    depth == cachedDepth ifTrue: [^ cachedBitPattern].
"/    cachedDepth _ depth.
"/
"/    depth > 2 ifTrue: [^ cachedBitPattern _ Bitmap with: (self pixelWordForDepth: depth)].
"/    depth = 1 ifTrue: [^ cachedBitPattern _ self halfTonePattern1].
"/    depth = 2 ifTrue: [^ cachedBitPattern _ self halfTonePattern2].

!

colorForInsets
    ^ self
!

darker
    "return a new color, which is darker than the receiver.
     Almost the same as darkened for Squeak compatibility."

    ^ self mixed:0.8333 with:Black

    "
     (Color red) darker
     (Color red) muchDarker
    "

    "Modified: 11.6.1996 / 18:10:37 / cg"

!

lighter
    "return a new color, which is slightly lighter than the receiver.
     Almost the same as lightened for Squeak compatibility."

    ^ self mixed:0.8333 with:White

    "
     (Color red)
     (Color red) lighter
     (Color red) muchLighter
     (Color red) veryMuchLighter
    "

    "Modified: 11.6.1996 / 18:10:49 / cg"
!

muchDarker
    "return a new color, which is much darker than the receiver.
     Added for Squeak compatibility."

    ^ self mixed:0.233 with:Black

    "
     (Color red) darker
     (Color red) muchDarker
    "

    "Modified: 11.6.1996 / 18:10:49 / cg"
!

muchLighter
    "return a new color, which is much lighter than the receiver.
     Added for Squeak compatibility."

    ^ self mixed:0.233 with:White

    "
     (Color red) lighter
     (Color red) mixed:0.833 with:Color white
     (Color red) muchLighter
     (Color red) veryMuchLighter
    "

    "Modified: 11.6.1996 / 18:10:49 / cg"
!

newTileMorphRepresentative
	^ ColorTileMorph new colorSwatchColor: self
!

privateBlue
    "Squeak compatibility:
     return the blue components value mapped to 0..MaxValue"

    ^ self scaledBlue
!

privateGreen
    "Squeak compatibility:
     return the green components value mapped to 0..MaxValue"

    ^ self scaledGreen
!

privateRed
    "Squeak compatibility:
     return the red components value mapped to 0..MaxValue"

    ^ self scaledRed
!

scaledPixelValue32
    ^ (self redByte bitShift:16)
      + (self greenByte bitShift:8)
      + (self blueByte)
      + (self alphaByte bitShift:24)
!

veryMuchLighter
    "return a new color, which is very much lighter than the receiver.
     Added for Squeak compatibility."

    ^ self mixed:0.1165 with:White

    "
     (Color red) lighter
     (Color red) muchLighter
     (Color red) veryMuchLighter
    "

    "Modified: 11.6.1996 / 18:10:49 / cg"
!

wheel:thisMany
    "An array of thisMany colors around the color wheel starting at self and ending all the way around the hue space just before self.  Array is of length thisMany.  Very useful for displaying color based on a variable in your program.  "

    | sat bri hue step c |

    thisMany = 1 ifTrue: [^ Array with: self].
    sat := self saturation / 100.
    bri := self brightness.
    hue := self hue.
    step := 360.0 / thisMany.
    ^ (1 to: thisMany) collect: [:num |
            c := self class h: hue s: sat v: bri.  "hue is taken mod 360"
            hue := hue + step.
            c].
! !

!Color methodsFor:'accessing'!

alpha
    "return the alpha value (0..1),
     where 0 is completely transparent and 1 is completely opaque"

    ^ 1.
!

alphaByte
    "return the alpha byte-value (0..255),
     where 0 is completely transparent and 255 is completely opaque"

    ^ 255.
!

blue
    "return the blue component in percent [0..100]"

    (blue isNil and:[colorId notNil]) ifTrue:[
	device isNil ifTrue:[^ 0].
	device getRGBFrom:colorId into:[:r :g :b | ^ b].
    ].
    ^ blue * 100.0 / MaxValue
!

blueByte
    "return the blue components value mapped to 0..255"

    blue isNil ifTrue:[^ nil].
    ^ blue * 255 // MaxValue

    "
     Color red blueByte
     Color blue blueByte
     Color green blueByte
     Color black blueByte
     Color grey blueByte
     Color white blueByte
    "

    "Created: / 7.6.1996 / 18:30:25 / cg"
    "Modified: / 26.7.1998 / 12:31:44 / cg"
!

colorId
    "return the device-dependent color-id"

    colorId notNil ifTrue:[^ colorId].
    replacementColor notNil ifTrue:[^ replacementColor colorId].
    ^ nil

    "Modified: 17.1.1997 / 00:03:18 / cg"
!

cyan
    "return the cyan component in percent [0..100] in cmy color space"

    ^ 100 - self red

    "Modified: 11.6.1996 / 17:20:07 / cg"
    "Created: 11.6.1996 / 18:30:00 / cg"
!

device
    "return the device I am associated to"

    ^ device

    "Modified: 23.4.1996 / 13:36:42 / cg"
!

deviceBlue
    "return the actual value of the blue component in percent."

    |v|

    device getRGBFrom:colorId into:[:r :g :b | v := b].
    ^ v
!

deviceGreen
    "return the actual value of the green component in percent.
     (usually 16bit in X; but could be different on other systems)"

    |v|

    device getRGBFrom:colorId into:[:r :g :b | v := g].
    ^ v
!

deviceRed
    "return the actual value of the red component in percent."

    |v|

    device getRGBFrom:colorId into:[:r :g :b | v := r].
    ^ v

    "
     (Color yellow on:Display) deviceRedValue
     (Color yellow on:aPrinterPage) deviceRedValue
    "
!

ditherForm
    "return the form to dither the color"

    ^ ditherForm
!

graphicsDevice
    "same as #device, for ST-80 compatibility naming.
     Return the device I am associated with."

    ^ device

    "Created: 28.5.1996 / 18:39:27 / cg"
!

green
    "return the green component in percent [0..100]"

    (green isNil and:[colorId notNil]) ifTrue:[
	device isNil ifTrue:[^ 0].
	device getRGBFrom:colorId into:[:r :g :b | ^ g].
    ].
    ^ green * 100.0 / MaxValue
!

greenByte
    "return the green components value mapped to 0..255"

    green isNil ifTrue:[^ nil].
    ^ green * 255 // MaxValue

    "
     Color red greenByte
     Color blue greenByte
     Color green greenByte
     Color black greenByte
     Color grey greenByte
     Color white greenByte
    "

    "Modified: / 26.7.1998 / 12:31:33 / cg"
!

hue
    "return the hue (in hue/light/saturation model) in degrees [0..360].
     The hue value is the position on the color wheel.
     0 is red, 120 green, 240 blue"

    |r g b h|

    (red isNil and:[colorId notNil]) ifTrue:[
        device getRGBFrom:colorId into:[:xr :xg :xb |
            r := xr.
            g := xg.
            b := xb.
        ]
    ] ifFalse:[
        r := self red.
        g := self green.
        b := self blue.
    ].

    self class withHLSFromRed:r green:g blue:b do:[:xh :xl :xs |
        h := xh
    ].
    ^ h

    "
     Color red hue
     Color yellow hue
    "

    "
     color wheel:

     |v|

     v := View new extent:200@200.
     v openAndWait.
     0 to:360 do:[:hue |
        100 downTo:0 do:[:sat |
            |p|
            v paint:(Color hue:hue light:50 saturation:sat).
            p := Point r:sat degrees:hue.
            v displayLineFrom:100@100 to:p+(100@100).
        ].
     ].
    "

    "Modified: 11.6.1996 / 17:14:51 / cg"
!

light
    "return the light (in hue/light/saturation model) in percent [0..100].
     This corresponds to the brightness of the color (if displayed on
     a b&w television screen).
     Old; please use #brightness (which is 0..1) for compatibility with other smalltalks"

    |r g b l|

    (red isNil and:[colorId notNil]) ifTrue:[
	device getRGBFrom:colorId into:[:xr :xg :xb |
	    r := xr.
	    g := xg.
	    b := xb.
	]
    ] ifFalse:[
	r := self red.
	g := self green.
	b := self blue.
    ].

    self class withHLSFromRed:r green:g blue:b do:[:xh :xl :xs |
	l := xl
    ].
    ^ l

    "
     Color yellow light
     Color yellow darkened light
    "

    "Modified: 11.6.1996 / 17:15:24 / cg"
!

magenta
    "return the magenta component in percent [0..100] in cmy color space"

    ^ 100 - self green

    "Modified: 11.6.1996 / 17:20:07 / cg"
    "Created: 11.6.1996 / 18:30:11 / cg"
!

privateAlpha
    "return the internal alpha value (0..255),
     where 0 is completely transparent and 255 is completely opaque"

    ^ 255

!

red
    "return the red component in percent [0..100]"

    (red isNil and:[colorId notNil]) ifTrue:[
	device isNil ifTrue:[^ 0].
	device getRGBFrom:colorId into:[:r :g :b | ^ r].
    ].
    red isNil ifTrue:[^ 0].
    ^ red * 100.0 / MaxValue

    "Modified: 11.6.1996 / 17:20:07 / cg"
!

red:r green:g blue:b
    "set r/g/b components in percent. This method will change the color lookup
     table in pseudocolor devices.
     This is only allowed for writable colors (i.e. those allocated with
     Color>>variableColorOn: on pseudoColor displays).
     Using this may make your code unportable, since it depends on a display
     using palettes (i.e. it will not work on greyScale or b&w displays)."

    ^ self scaledRed:(r * MaxValue // 100)
	   scaledGreen:(g * MaxValue // 100)
	   scaledBlue:(b * MaxValue // 100)

    "
     |c|

     c := Color variableColorOn:Display.
     c inspect.
     (Delay forSeconds:5) wait.
     c red:100 green:0 blue:0.
     (Delay forSeconds:5) wait.
     c red:0 green:100 blue:0.
     (Delay forSeconds:5) wait.
     c red:0 green:0 blue:100.
    "
!

redByte
    "return the red components value mapped to 0..255;
     nil if it has no red component."

    red isNil ifTrue:[^ nil].
    ^ red * 255 // MaxValue

    "
     Color red redByte
     Color blue redByte
     Color green redByte
     Color black redByte
     Color grey redByte
     Color white redByte
    "

    "Modified: / 26.7.1998 / 12:31:22 / cg"
!

rgbValue
    "return the rgb byteValues packed into a 24bit integer;
     The returned value is composed of r<<16 + g<<8 + b."

    |t "{ Class: SmallInteger }"
     v "{ Class: SmallInteger }"|

    v := red * 255 // MaxValue.
    t := green * 255 // MaxValue.
    v := (v bitShift:8) + t.
    t := blue * 255 // MaxValue.
    ^ (v bitShift:8) + t.

    "
     Color red rgbValue hexPrintString
     Color blue rgbValue hexPrintString
     Color green rgbValue hexPrintString
     Color black rgbValue hexPrintString
     Color grey rgbValue hexPrintString
     Color white rgbValue hexPrintString
    "

    "Modified: 17.10.1997 / 20:00:25 / cg"
!

saturation
    "return the saturation (in hue/light/saturation model) in percent [0..100].
     This corresponds to the saturation setting of a color TV"

    |r g b s|

    (red isNil and:[colorId notNil]) ifTrue:[
	device getRGBFrom:colorId into:[:xr :xg :xb |
	    r := xr.
	    g := xg.
	    b := xb.
	]
    ] ifFalse:[
	r := self red.
	g := self green.
	b := self blue.
    ].

    self class withHLSFromRed:r green:g blue:b do:[:xh :xl :xs |
	s := xs
    ].
    ^ s

    "
     Color yellow saturation
    "

    "Modified: 11.6.1996 / 17:15:47 / cg"
!

scaledAlpha
    "ST-80 compatibility:
     return the alpha components value mapped to 0..MaxValue"

    ^ MaxValue

    "
     Color blue scaledBlue
     Color black scaledBlue
     Color grey scaledBlue
    "

    "Modified: 7.6.1996 / 18:32:30 / cg"
!

scaledBlue
    "ST-80 compatibility:
     return the blue components value mapped to 0..MaxValue"

    ^ blue

    "
     Color blue scaledBlue
     Color black scaledBlue
     Color grey scaledBlue
    "

    "Modified: 7.6.1996 / 18:32:30 / cg"
!

scaledGray
    "return the grey intensity scaled to 0..MaxValue"

    ^ ((red * 3) + (green * 6) + blue) // 10

    "
     Color blue scaledGray
     Color black scaledGray
     Color white scaledGray
     Color grey scaledGray
    "

    "Modified: 11.6.1996 / 14:43:51 / cg"
!

scaledGreen
    "ST-80 compatibility:
     return the green components value mapped to 0..MaxValue"

    ^ green

    "
     Color green scaledRed
     Color black scaledRed
     Color grey scaledRed
    "

    "Modified: 7.6.1996 / 18:32:38 / cg"
!

scaledRed
    "ST-80 compatibility:
     return the red components value mapped to 0..MaxValue"

    ^ red

    "
     Color red scaledRed
     Color black scaledRed
     Color grey scaledRed
    "

    "Modified: 7.6.1996 / 18:32:43 / cg"
!

scaledRed:r scaledGreen:g scaledBlue:b
    "set r/g/b components in 0..MaxValue.
     This method will change the color lookup table in pseudocolor devices.
     This is only allowed for writable colors (i.e. those allocated with
     Color>>variableColorOn: on pseudoColor displays).
     Using this may make your code unportable, since it depends on a display
     using palettes (i.e. it will not work on greyScale or b&w displays)."

    (colorId isNil or:[red notNil]) ifTrue:[
	^ self error:'operation is not allowed for shared colors'
    ].
    device setColor:colorId scaledRed:r scaledGreen:g scaledBlue:b
!

writable
    "return true, if this is a writable colorcell"

    ^ writable == true
!

yellow
    "return the yellow component in percent [0..100] in cmy color space"

    ^ 100 - self blue

    "Modified: 11.6.1996 / 17:20:07 / cg"
    "Created: 11.6.1996 / 18:30:20 / cg"
! !


!Color methodsFor:'comparing'!

= aColor
    "two colors are considered equal, if the color components are;
     independent of the device, the color is on"

    aColor == self ifTrue:[^ true].
    aColor isColor ifTrue:[
	(red == aColor scaledRed) ifTrue:[
	    (green == aColor scaledGreen) ifTrue:[
		(blue == aColor scaledBlue) ifTrue:[
		    ^ true
		]
	    ]
	]
    ].
    ^ false

    "Modified: / 2.4.1998 / 10:04:39 / cg"
!

almostSameAs:aColor
    "return true, if aColor looks almost the same as the receiver
     (i.e. the components differ by a small, invisible amount).
     We assume, that the human eye can distinguish roughly 100 grey levels
     (which is optimistic ;-);
     therefore, allow a 1 percent difference in each component for the colors
     to compare as looking the same."

     (self red - aColor red) abs > 1 ifTrue:[^ false].
     (self green - aColor green) abs > 1 ifTrue:[^ false].
     (self blue - aColor blue) abs > 1 ifTrue:[^ false].
     ^ true

     "
      (Color red:10 green:10 blue:10) almostSameAs:(Color red:11 green:11 blue:11)
     "

    "Modified: 28.2.1997 / 12:00:01 / cg"
!

hash
    "return an integer useful as hash key for the receiver.
     Redefined since = is redefined"

    red isNil ifTrue:[
	^ colorId
    ].
    ^ red + green + blue
! !

!Color methodsFor:'converting'!

asByteArray
    ^ByteArray
            with: self redByte
            with: self greenByte
            with: self blueByte
!

fromLiteralArrayEncoding:encoding
    "read my values from an encoding.
     The encoding is supposed to be either of the form:
        (#Color redPart greenPart bluePart)
     or:
        (#Color constantColorSymbol)
     This is the reverse operation to #literalArrayEncoding."

    |clr nameOrRGB|

    encoding size == 2 ifTrue:[
        nameOrRGB := encoding at:2.
        nameOrRGB isSymbol ifTrue:[
            clr := self class perform:nameOrRGB
        ] ifFalse:[
            clr := self class rgbValue:nameOrRGB.
        ].
        red := clr scaledRed.
        green := clr scaledGreen.
        blue := clr scaledBlue
    ] ifFalse:[
        red := ((encoding at:2) / 100.0 * MaxValue) rounded asInteger.
        green := ((encoding at:3) / 100.0 * MaxValue) rounded asInteger.
        blue := ((encoding at:4) / 100.0 * MaxValue) rounded asInteger.
    ].

    "
      Color new fromLiteralArrayEncoding:#(#Color 50 25 25)
      Color new fromLiteralArrayEncoding:#(#Color 16rFF00FF)
      Color new fromLiteralArrayEncoding:#(#Color blue)
    "
!

literalArrayEncoding
    "encode myself as an array, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray.
     The encoding is:
        (#Color redPart greenPart bluePart)
    "

    ^ Array
        with:self class name
        with:((red * 100.0 / MaxValue) roundTo:0.25)
        with:((green * 100.0 / MaxValue) roundTo:0.25)
        with:((blue * 100.0 / MaxValue) roundTo:0.25)

    "
      Color new fromLiteralArrayEncoding:#(#Color 50 25 25)
      (Color red:25 green:30 blue:70) literalArrayEncoding
    "

    "Modified: 22.4.1996 / 13:00:11 / cg"
! !

!Color methodsFor:'copying'!

postCopy
    "redefined to clear out any device handles in the copy"

    device := colorId := ditherForm := replacementColor := nil

    "Modified: 17.1.1997 / 00:03:42 / cg"
!

skipInstvarIndexInDeepCopy:index
    index == 4 ifTrue:[
	^ true "/ skip device
    ].
    index == 5 ifTrue:[
	^ true "/ skip colorId
    ].
    index == 6 ifTrue:[
	^ true "/ skip ditherForm
    ].
    index == 7 ifTrue:[
	^ true "/ skip replacementColor
    ].
    ^ false

    "
     (Color black onDevice:Screen current) deepCopy
    "
! !

!Color methodsFor:'getting a device color'!

exactOn:aDevice
    "create a new Color representing the same color as
     myself on aDevice; if one already exists, return the one.
     Do not dither or otherwise approximate the color, but return
     nil, if the exact color is not available.
     Used to acquire primary colors for dithering, during startup."

    |newColor id r g b|

    "if Iam already assigned to that device ..."
    (device == aDevice and:[ditherForm isNil]) ifTrue:[^ self].

    r := red.
    g := green.
    b := blue.

    "first look if not already there"
    newColor := self class existingColorScaledRed:r scaledGreen:g scaledBlue:b on:aDevice.
    (newColor notNil and:[newColor ditherForm isNil]) ifTrue:[^ newColor].

    r := (r bitAnd:16rFF00) bitOr:(r bitShift:-8).
    g := (g bitAnd:16rFF00) bitOr:(g bitShift:-8).
    b := (b bitAnd:16rFF00) bitOr:(b bitShift:-8).

    "ask that device for the color"
    id := aDevice colorScaledRed:r scaledGreen:g scaledBlue:b.
    id isNil ifTrue:[
        "/ this is a kludge: scavenge to free unused colors
        "/  and try again ...
        ObjectMemory scavenge; finalize.
        id := aDevice colorScaledRed:r scaledGreen:g scaledBlue:b
    ].
    id isNil ifTrue:[
        "no such color - fail"

"/      'COLOR: no color for ' infoPrint. self displayString infoPrintCR.
        ^ nil
    ].

    "receiver was not associated - do it now"
    device isNil ifTrue:[
        device := aDevice.
        colorId := id.

        aDevice visualType ~~ #TrueColor ifTrue:[
            "/ Lobby register:self.
            aDevice registerColor:self.
        ].
        ^ self
    ].

    "receiver was already associated to another device - need a new color"
    newColor := (self class basicNew) setScaledRed:r scaledGreen:g scaledBlue:b device:aDevice.
    newColor setColorId:id.
    aDevice visualType ~~ #TrueColor ifTrue:[
        "/ Lobby register:newColor.
        aDevice registerColor:newColor.
    ].
    ^ newColor

    "Modified: 24.2.1997 / 18:23:20 / cg"
!

exactOrNearestOn:aDevice
    "get a device color for the receiver, which is either exact
     or the nearest, but never dithered.
     This can be used for viewBackgrounds, where the exact greyLevel
     does not matter, but a dithered color is not wanted."

    |deviceColor|

    deviceColor := self exactOn:aDevice.
    deviceColor isNil ifTrue:[
	deviceColor := self nearestOn:aDevice
    ].
    ^ deviceColor

    "Created: 13.8.1997 / 15:25:48 / cg"
!

nearestIn:aColorMap
    "return the nearest color in a colorMap"

    ^ self class
	nearestColorScaledRed:(self scaledRed)
		  scaledGreen:(self scaledGreen)
		   scaledBlue:(self scaledBlue)
			   on:nil
			   in:aColorMap

    "Created: / 28.7.1998 / 20:42:11 / cg"
!

nearestOn:aDevice
    "create a new Color representing the same color as myself on aDevice;
     if one already exists, return the one. If no exact match is found,
     search for the nearest match"

    |newColor id|

    "if I'am already assigned to that device ..."
    (device == aDevice) ifTrue:[^ self].

    "first look if not already there"
    newColor := self class nearestColorScaledRed:red scaledGreen:green scaledBlue:blue on:aDevice.
    newColor notNil ifTrue:[^ newColor].

    "ask that device for the color"
    id := aDevice colorScaledRed:red scaledGreen:green scaledBlue:blue.
    id isNil ifTrue:[
        "this is a kludge:
            scavenge to possuby free unused colors and try again ...
            this is a compromise: actually a full GC is required here,
            but that is too expensive.
        "
        ObjectMemory scavenge; finalize.
        id := aDevice colorScaledRed:red scaledGreen:green scaledBlue:blue
    ].
    id isNil ifTrue:[
        "no color - fail"

        ^ nil
    ].

    "receiver was not associated - do it now"
    device isNil ifTrue:[
        device := aDevice.
        colorId := id.

        aDevice visualType ~~ #TrueColor ifTrue:[
            "/ Lobby register:self.
            aDevice registerColor:self.
        ].
        ^ self
    ].

    "receiver was already associated to another device - need a new color"
    newColor := self class basicNew setScaledRed:red scaledGreen:green scaledBlue:blue device:aDevice.
    newColor setColorId:id.
    aDevice visualType ~~ #TrueColor ifTrue:[
        "/ Lobby register:newColor.
        aDevice registerColor:newColor.
    ].
    ^ newColor

    "Modified: 24.2.1997 / 18:23:26 / cg"
!

on:aDevice
    "create a new Color representing the same color as
     myself on aDevice; if one already exists, return the one"

    "/ send out a warning: #on: is typically used to create views
    "/ operating on a model.
    "/ Please use #onDevice: to avoid confusion.

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #onDevice:'.
    ^ self onDevice:aDevice

    "Created: / 16.11.1995 / 20:16:42 / cg"
    "Modified: / 8.9.1998 / 17:32:10 / cg"
!

onDevice:aDevice
    "create a new Color representing the same color as
     myself on aDevice; if one already exists, return the one"

    |newColor id form
     greyV "{ Class: SmallInteger }"
     rV    "{ Class: SmallInteger }"
     gV    "{ Class: SmallInteger }"
     bV    "{ Class: SmallInteger }"
     deviceVisual deviceFixColors deviceDepth|

    "/ the most common cases (already allocated) first

    colorId notNil ifTrue:[
        "/ is someone validating me before drawing on aDevice ?
        (aDevice notNil and:[aDevice == device]) ifTrue:[
            ^ self
        ].

        "/ a special case for pseudo-colors (0 and 1 in bitmaps)
        "/ those have nil r/g/b values, but a nonNil colorId

        red isNil ifTrue:[^ self].

        "/ want to release color ?

        (aDevice isNil and:[device notNil]) ifTrue:[
            "/ trueColor device-colors are not registered
            device visualType ~~ #TrueColor ifTrue:[
                device unregisterColor:newColor.
                device freeColor:colorId
            ].
            device := nil.
            colorId := nil.
            ^ self
        ].
    ].
    aDevice isNil ifTrue:[
        ^ self
    ].

    device == aDevice ifTrue:[
        ditherForm notNil ifTrue:[
            ^ self
        ]
    ].

    "/ on high-resolution true-color systems, don't care for dithering and
    "/ especially freeing colors
    "/ (no need to register)

    deviceDepth := aDevice depth.
    (deviceVisual := aDevice visualType) == #TrueColor ifTrue:[
        deviceDepth >= 15 ifTrue:[
            id := aDevice colorScaledRed:red scaledGreen:green scaledBlue:blue.
            id notNil ifTrue:[
                device isNil ifTrue:[
                    "/ receiver was not associated - do it now & return mySelf
                    colorId := id.
                    ditherForm := nil.
                    device := aDevice.
                    ^ self
                ].
                newColor := self class basicNew
                                    setScaledRed:red
                                    scaledGreen:green
                                    scaledBlue:blue
                                    device:aDevice.
                newColor setColorId:id.
                ^ newColor
            ]
        ]
    ].

    rV := red.
    gV := green.
    bV := blue.

"/    "/ round a bit within 1% in red & green, 2% in blue
"/    rV := (red / 100.0) rounded * 100.
"/    gV := (green / 100.0) rounded * 100.
"/    bV := (blue / 50.0) rounded * 50.
"/
"/    "/ if I am already assigned to that device ...
"/
"/    ((device == aDevice) and:[ditherForm notNil]) ifTrue:[
"/
"/        "/ mhmh - if I was dithered the last time (not enough colors then)
"/        "/ try again - maybe some colors were reclaimed in the meanwhile
"/
"/        deviceFixColors := aDevice fixColors.
"/
"/        (deviceFixColors isNil
"/         and:[RetryAllocation]) ifTrue:[
"/            "
"/             but there is no chance on b&w displays - so don't try
"/            "
"/            aDevice depth > 2 ifTrue:[
"/                id := aDevice colorScaledRed:rV scaledGreen:gV scaledBlue:bV.
"/                id notNil ifTrue:[
"/                    colorId := id.
"/                    ditherForm := nil.
"/                    device registerColor:self.
"/                ]
"/            ]
"/        ].
"/        ^ self
"/    ].

    newColor := self class existingColorScaledRed:rV scaledGreen:gV scaledBlue:bV on:aDevice.
    newColor notNil ifTrue:[
        (newColor scaledRed ~~ red
        or:[newColor scaledGreen ~~ green
        or:[newColor scaledBlue ~~ blue]]) ifTrue:[
            Transcript showCR:'Color>>#onDevice: got different color'.
        ].
        ^ newColor
    ].

    "/ ask that device for the exact color
    id := aDevice colorScaledRed:red scaledGreen:green scaledBlue:blue.
    id notNil ifTrue:[
        device isNil ifTrue:[
            "/ receiver was not associated - do it now & return mySelf
            colorId := id.
            ditherForm := nil.
            device := aDevice.
            newColor := self.
        ] ifFalse:[
            newColor := self class basicNew
                                setScaledRed:red
                                scaledGreen:green
                                scaledBlue:blue
                                device:aDevice.
            newColor setColorId:id.
        ].
        id notNil ifTrue:[
            deviceVisual ~~ #TrueColor ifTrue:[
                aDevice registerColor:newColor.
            ]
        ].
        ^ newColor
    ].

    "/
    "/ ok, we are either going to dither that color, or look for
    "/ the nearest.
    "/ if its 'almost' grey, make it grey and round it a bit (1%)
    "/
    greyV := (3 * red) + (6 * green) + (1 * blue).
    greyV := (greyV / 1000.0) rounded * 100.

    "/ allow an error of 1% in red & green, 2% in blue

    ((rV - greyV) abs <= 655                    "/ MaxValue // 100
    and:[(gV - greyV) abs <= 655                "/ MaxValue // 100
    and:[(bV - greyV) abs <= 1310]]) ifTrue:[   "/ MaxValue // 100 * 2
        rV := gV := bV := greyV.
    ] ifFalse:[
        rV := red. gV := green. bV := blue.
    ].

    aDevice hasColors ifTrue:[
        deviceFixColors := aDevice fixColors.
        deviceFixColors isNil ifTrue:[
            "/ ask that device for the exact color
            id := aDevice colorScaledRed:rV scaledGreen:gV scaledBlue:bV.
            id isNil ifTrue:[
                aDevice isOpen ifFalse:[
                    ^ nil
                ].

                "/ this is a kludge: scavenge to free unused colors
                "/ and try again ...
                ObjectMemory scavenge; finalize.
                id := aDevice colorScaledRed:rV scaledGreen:gV scaledBlue:bV
            ].

            id isNil ifTrue:[
                "/ no such color - try color dithers

                self class
                    ditherRed:rV green:gV blue:bV
                    on:aDevice
                    into:[:c :f | newColor := c. form := f].
                newColor notNil ifTrue:[^ newColor].
            ].
        ].

        "/ none found ? -> do a hard dither using fixColors

        (id isNil and:[form isNil]) ifTrue:[
            deviceFixColors notNil ifTrue:[
                self class
                    fixDitherRed:rV green:gV blue:bV
                    on:aDevice
                    into:[:c :f | newColor := c. form := f].
                newColor notNil ifTrue:[^ newColor].
            ]
        ].

        "/ still none found ? -> do a very hard dither using existing colors

        (id isNil and:[form isNil]) ifTrue:[
            self class
                complexDitherRed:rV green:gV blue:bV
                on:aDevice
                into:[:c :f | newColor := c. form := f].
            newColor notNil ifTrue:[^ newColor].
        ].
    ].

    (id isNil and:[form isNil]) ifTrue:[
        "still no result - try graying"

        greyV == 0 ifTrue:[
            id := aDevice blackpixel
        ] ifFalse:[
            greyV == MaxValue ifTrue:[
                id := aDevice whitepixel
            ] ifFalse:[
                aDevice hasGrayscales ifTrue:[
                    self class
                        ditherGrayFor:(greyV / MaxValue)
                        on:aDevice
                        into:[:c :f | newColor := c. form := f].
                    newColor notNil ifTrue:[^ newColor].
                ].
                form isNil ifTrue:[
                    "/ still none - dither b&w
                    self class
                        monoDitherFor:(greyV / MaxValue)
                        between:Black and:White
                        on:aDevice
                        into:[:c :f | newColor := c. form := f].
                    newColor notNil ifTrue:[^ newColor].
                    form isNil ifTrue:[
                        "/ cannot happen
                        'Color [warning]: monoDither failed' errorPrintCR.
                        ^ nil
                    ]
                ]
            ]
        ].
    ].

    device isNil ifTrue:[
        "/ receiver was not associated - do it now & return mySelf

        device := aDevice.
        id isNil ifTrue:[
            ditherForm := form
        ].
        colorId := id.

        "/ have to register - otherwise it keeps old info around

        id notNil ifTrue:[
            deviceVisual ~~ #TrueColor ifTrue:[
                aDevice registerColor:self.
            ]
        ].
        ^ self
    ].

    "/ receiver was already associated to another device
    "/ - need a new color and return it

    newColor := self class basicNew
                        setScaledRed:red
                        scaledGreen:green
                        scaledBlue:blue
                        device:aDevice.
    id isNil ifTrue:[
        newColor setDitherForm:form
    ] ifFalse:[
        newColor setColorId:id.

        "/ trueColor device-colors are not registered
        deviceVisual ~~ #TrueColor ifTrue:[
            aDevice registerColor:newColor.
        ]
    ].
    ^ newColor

    "Created: / 16.11.1995 / 20:16:42 / cg"
    "Modified: / 8.9.1998 / 17:32:10 / cg"
! !


!Color methodsFor:'instance creation'!

alpha:alphaValue
    "return a new color with the same color, but different alpha as the receiver.
     The alpha arguments range is 0..1 (0=completely transparent; 1=completely opaque)"

    alphaValue = 1 ifTrue:[ ^ self].
    ^ (TranslucentColor
	   scaledRed:red
	   scaledGreen:green
	   scaledBlue:blue) alpha:alphaValue

    "
     (Color red alpha:0.5) alpha
     Color red alpha
    "

    "Modified: / 06-06-2007 / 11:17:55 / cg"
!

blendWith:aColor
    "create a new color from equally mixing the receiver
     and the argument, aColor.
     Mixing is done by adding components
     (which is different from mixing colors on paper .. which is subtractive)."

    ^ self mixed:1 with:aColor

    "
     (Color red) blendWith:(Color yellow)
     (Color red) blendWith:(Color blue)
     (Color red) blendWith:(Color black)
     (Color red) blendWith:(Color white)
    "

    "Modified: 10.2.1997 / 22:08:14 / cg"
!

contrastingBlackOrWhite
    "answer either black or white, whichever gives a better contrast
     for drawing text on a background with my color.
     (i.e. if I am dark, return white; if I am bright, return black"

    ^ self brightness < 0.55 
        ifTrue:[self class white] 
        ifFalse:[self class black]

    "
     (Color blue) contrastingBlackOrWhite
     (Color red) contrastingBlackOrWhite
     (Color green) contrastingBlackOrWhite
     (Color yellow) contrastingBlackOrWhite
    "
!

contrastingColorFor:aBackgroundColor
    "answer a slightly brightened or darkened variant of myself,
     to ensure a good contrast when showing text on a background color.
     i.e. when drawing read on grey, it might be better to darken or brighten 
     the red, if its brightness is too near to the grey's brightness.
     Use this for alert strings shown on a color background."

    |colorUsed bgBrightness|

    colorUsed := self.
    bgBrightness := aBackgroundColor brightness.
    
    (bgBrightness dist:colorUsed brightness) < 0.5 ifTrue:[
        bgBrightness > 0.5 ifTrue:[
            colorUsed := self slightlyDarkened.
            (bgBrightness dist:colorUsed brightness) < 0.5 ifTrue:[
                colorUsed := self darkened.
            ].
        ] ifFalse:[
            colorUsed := self slightlyLightened.
            (bgBrightness dist:colorUsed brightness) < 0.5 ifTrue:[
                colorUsed := self lightened.
            ].
        ].    
    ].
    ^ colorUsed.

    "
     (Color blue) contrastingColorFor:Color white.
     (Color blue) contrastingColorFor:Color blue.
     (Color red) contrastingColorFor:Color grey
     (Color blue) contrastingColorFor:Color black
    "
!

darkened
    "return a new color, which is slightly darker than the receiver"

    ^ self blendWith:Black

    "
     (Color red) darkened
     (Color red) darkened darkened
    "

    "Modified: 11.6.1996 / 18:10:37 / cg"
!

lightened
    "return a new color, which is slightly lighter than the receiver"

    ^ self blendWith:White

    "
     (Color red) lightened
     (Color red) lightened lightened
    "

    "Modified: 11.6.1996 / 18:10:49 / cg"
!

mixed:amount with:aColor
    "create a new color from mixing amount of the receiver
     with the argument, aColor.
     Mixing is done by adding components (i.e. additive mixing)
     (which is different from mixing colors on paper .. which is subtractive).
     With an amount of 1, this is the same as blendWith."

    red isNil ifTrue:[
	^ aColor
    ].

    ^ (self class)
	scaledRed:((red * amount) + aColor scaledRed) // (1 + amount)
	scaledGreen:((green * amount) + aColor scaledGreen) // (1 + amount)
	scaledBlue:((blue * amount) + aColor scaledBlue) // (1 + amount)

    "
     (Color red) mixed:1 with:(Color yellow)
     (Color red) mixed:0.9 with:(Color yellow)
     (Color red) mixed:0.8 with:(Color yellow)
     (Color red) mixed:0.5 with:(Color yellow)
     (Color red) mixed:0.25 with:(Color yellow)
     (Color red) mixed:0 with:(Color yellow)

     (Color red) mixed:1 with:(Color white)
     (Color red) mixed:0.8 with:(Color white)
     (Color red) mixed:0.8 with:(Color black)
    "

    "Modified: 10.2.1997 / 22:08:14 / cg"
!

slightlyDarkened
    "return a new color, which is a bit darker than the receiver"

    ^ self blendWith:(self blendWith:Black)

    "
     (Color green) inspect
     (Color green) darkened inspect
     (Color green) slightlyDarkened inspect
    "
!

slightlyLightened
    "return a new color, which is a bit lighter than the receiver"

    ^ self blendWith:(self blendWith:White)

    "
     (Color red) inspect
     (Color red) lightened inspect
     (Color red) slightlyLightened inspect
    "
! !

!Color methodsFor:'instance release'!

executor
    "redefined, since for finalization only device and colorIndex
     are needed - thus a faster copy is possible here"

    ^ DeviceColorHandle basicNew setDevice:device colorId:colorId
!

releaseFromDevice
    "I am no longer available on the device"

    colorId := device := ditherForm := replacementColor := nil.

! !

!Color methodsFor:'misc'!

magnifiedTo: extent
    "do nothing here, for compatibility with Image/Form"
! !


!Color methodsFor:'object persistency'!

elementDescriptorFor:aspect
    "support for persistency:
     answer the elements to be made persistent with an ObjectCoder"

    red isNil ifTrue:[
	^ Array with:(#colorId->colorId)
    ].
    ^ Array with:(#red->self red) with:(#green->self green) with:(#blue->self blue)
! !

!Color methodsFor:'printing & storing'!

hex
    <resource: #obsolete>

    self obsoleteMethodWarning:'use #hexPrintString'.
    ^ self hexPrintString
!

hexPrintString
    "return a hex-printString as rrggbb"

    |s|

    s := WriteStream on:(String new:6).
    red isNil ifTrue:[
	colorId notNil ifTrue:[
	    colorId printOn:s base:16 size:6 fill:$0.
	]
    ] ifFalse:[
	self redByte   printOn:s base:16 size:2 fill:$0.
	self greenByte printOn:s base:16 size:2 fill:$0.
	self blueByte  printOn:s base:16 size:2 fill:$0.
    ].

    ^ s contents.

    "
     Color red hexPrintString
     Color green hexPrintString
     Color blue hexPrintString
     Color yellow hexPrintString
    "
!

htmlPrintString
    "return a hex-printString for html as #rrggbb;"

    ^ '#',(self hexPrintString)

    "
     Color red htmlPrintString
     Color green htmlPrintString
     Color blue htmlPrintString
     Color yellow htmlPrintString
    "
!

printOn:aStream
    "append a string representing of the receiver
     to the argument, aStream"

    self storeOn:aStream
!

storeOn:aStream
    "append a string representing an expression to reconstruct the receiver
     to the argument, aStream"

    |clsName|

    clsName := self class name.

    red isNil ifTrue:[
	colorId notNil ifTrue:[
	    aStream nextPutAll:'(' , clsName , ' colorId:'.
	    colorId storeOn:aStream.
	    aStream nextPut:$).
	    ^ self
	]
    ].
    (red == green and:[red == blue]) ifTrue:[
	red == 0 ifTrue:[
	    aStream nextPutAll:'(' , clsName , ' black)'.
	] ifFalse:[
	    red == MaxValue ifTrue:[
		aStream nextPutAll:'(' , clsName , ' white)'.
	    ] ifFalse:[
		aStream nextPutAll:'(' , clsName , ' grey:'.
		(self red) storeOn:aStream.
		aStream nextPut:$).
	    ]
	].
	^ self
    ].
    aStream nextPutAll:'(' , clsName , ' red:'.
    (self red) storeOn:aStream.
    aStream nextPutAll:' green:'.
    (self green) storeOn:aStream.
    aStream nextPutAll:' blue:'.
    (self blue) storeOn:aStream.
    aStream nextPut:$).
! !

!Color methodsFor:'private'!

restored
    "private: color has been restored (either from snapin or binary store);
     flush device stuff or reallocate a cell."

    ditherForm := replacementColor := nil.

    red notNil ifTrue:[
	device := nil.
	colorId := nil
    ] ifFalse:[
	"a variable color has been restored"
	(colorId notNil and:[writable == true and:[device notNil]]) ifTrue:[
	    colorId := device colorCell.
	    device setColor:colorId scaledRed:red scaledGreen:green scaledBlue:blue
	]
    ]

    "Modified: 17.1.1997 / 00:04:14 / cg"
!

setColorId:anId
    "private: set the deviceId"

    colorId := anId

    "Created: 17.1.1997 / 00:05:41 / cg"
!

setDevice:aDevice colorId:aNumber
    "private:set device and colorId"

    device := aDevice.
    colorId := aNumber.
    writable := false.
!

setDevice:aDevice colorId:aNumber writable:wBool
    "private:set device, colorId and writable flag"

    device := aDevice.
    colorId := aNumber.
    writable := wBool.
!

setDitherForm:aForm
    "private: set the ditherForm"

    ditherForm := aForm

    "Created: 17.1.1997 / 00:04:57 / cg"
!

setScaledRed:r scaledGreen:g scaledBlue:b device:aDevice
    "private: set the components"

    red notNil ifTrue:[
	"oops cannot change (you want to make red be green - or what)"

	self error:'Colors cannot change their components'.
	^ self
    ].
    red := r.
    green := g.
    blue := b.
    device := aDevice

    "Modified: 16.1.1997 / 22:39:26 / cg"
! !

!Color methodsFor:'queries'!

averageColor
    "return the average color - that's myself.
     This method has been added for compatibility with the image protocol."

    ^ self
!

averageColorIn:aRectangle
    "return the average color - that's myself.
     This method has been added for compatibility with the image protocol."

    ^ self
!

brightness
    "ST80 compatibility: return the grey intensity in [0..1]"

    red isNil ifTrue:[
        "/ a hack for colorId:0 and colorId:1 pseudo mask colors.
        colorId == 0 ifTrue:[^ 0].
        ^ 1
    ].
    ^ ((3 * red) + (6 * green) + (blue)) / 10.0 / MaxValue

    "Modified: 7.6.1996 / 19:42:21 / cg"
!

deltaFrom:aColor
    "return the distance of the receiver from some color specified
     by r/g/b values.
     A very questionable value;
     basing the distance on rgb values is very bad
     - better do a distance in a cie color cone"

    ^ aColor deltaFromRed:self red green:self green blue:self blue

    "
     Color red deltaFrom:(Color blue)
     Color red deltaFrom:(Color yellow)
     Color red deltaFrom:(Color red:50)
    "

    "Created: 14.6.1996 / 20:07:22 / cg"
    "Modified: 14.6.1996 / 20:49:32 / cg"
!

deltaFromRed:r green:g blue:b
    "return the distance of the receiver from some color specified
     by r/g/b values"

    "
     Q: how should component errors be weighted ?
    "
    ^ ((self red - r) abs
      + (self green - g) abs
      + (self blue - b) abs) rounded.

    "Created: 14.6.1996 / 20:03:58 / cg"
    "Modified: 14.6.1996 / 20:20:24 / cg"
!

deltaFromScaledRed:r scaledGreen:g scaledBlue:b
    "return the distance of the receiver from some color specified
     by r/g/b values"

    "
     Q: how should component errors be weighted ?
    "
    ^ (red - r) abs
      + (green - g) abs
      + (blue - b) abs.

    "Created: 11.6.1996 / 18:01:12 / cg"
    "Modified: 14.6.1996 / 20:36:14 / cg"
!

errorFrom:aColor
    "return some value which can be used to compare colors.
     The following simply returns the vector distance of the r/g/b vectors.
     This may not be a very good idea; probably, we should honor the
     fact that the hue difference should have more weight than saturation and/or light"

    ^ (red - aColor scaledRed) squared
       + (green - aColor scaledGreen) squared
       + (blue - aColor scaledBlue) squared.
!

grayIntensity
    "return the grey intensity in percent [0..100] (US version ;-)"

    red isNil ifTrue:[
        "/ a hack for colorId:0 and colorId:1 pseudo mask colors.
        colorId == 0 ifTrue:[^ 0].
        ^ 100
    ].
    ^ ((3 * red) + (6 * green) + (1 * blue)) * 10.0 / MaxValue

    "
     Color red brightness
     Color red grayIntensity
    "
    
    "Created: 2.5.1996 / 11:38:21 / cg"
!

greyIntensity
    "return the grey intensity in percent [0..100] (English version ;-)"

    ^ self grayIntensity

    "Modified: 28.5.1996 / 20:45:41 / cg"
!

isColor
    "return true if the receiver is a Color."

    ^ true
!

isColorObject
    ^ true
!

isDithered
    "return true, if this is a dithered Color.
     Only makes sense if the receiver is a device color."

    ^ ditherForm notNil
!

isGray
    "same as isGrayColor - for ST80 compatibility."

    ^ self isGrayColor

    "
     (Color grey:50) isGray
     (Color red) isGray
    "

    "Created: 10.2.1997 / 22:10:25 / cg"
!

isGrayColor
    "return true, if this color is a gray one (US version ;-) -
     i.e. red = green = blue"

    red ~~ green ifTrue:[^ false].
    ^ red == blue

    "
     (Color grey:50) isGrayColor
     (Color red) isGrayColor
    "

    "Created: 2.5.1996 / 11:38:48 / cg"
!

isGreyColor
    "return true, if this color is a grey one (English version ;-) -
     i.e. red = green = blue"

    ^ self isGrayColor

    "(Color grey:50) isGreyColor"
    "(Color red) isGreyColor"

    "Modified: 28.5.1996 / 20:44:36 / cg"
!

isOnDevice:aGraphicsDevice
    "return true if i am allocated on aGraphicsDevice"

    ^ device == aGraphicsDevice
      and:[colorId notNil or:[replacementColor notNil and:[replacementColor colorId notNil]]]
!

isOpaque
    "return true, if I represent an opaque color"

    ^ true

!

isTranslucent
    "return true, if I represent a translucent color;
     that is: not completely opaque"

    ^ false

!

isTranslucentColor
    "return true, if I represent a translucent color, but not transparent"

    ^ false

!

isTransparent
    "return true, if I represent a completely transparent color"

    ^ false

! !

!Color::DeviceColorHandle class methodsFor:'documentation'!

documentation
"
    This is an abstract class for device handles which are responsible
    for finalization i.e. to destroy underlying system resources, when the GC
    frees an object which has created some system object.
    These are used with colors.

    [see also:]
	Color

    [author:]
	Claus Gittinger

"
! !

!Color::DeviceColorHandle methodsFor:'accessing'!

setDevice:aDevice colorId:anId
    "set the handles contents"

    device := aDevice.
    colorId := anId.

    "Modified: 23.4.1996 / 22:10:26 / cg"
    "Created: 25.3.1997 / 14:29:10 / stefan"
! !

!Color::DeviceColorHandle methodsFor:'finalization'!

finalize
    "the color for which I am a handle was collected
     - release system resources"

    |id|

    (id := colorId) notNil ifTrue:[
	colorId := nil.
	device freeColor:id.
    ].

    "Created: 25.3.1997 / 14:29:10 / stefan"
! !

!Color class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Color initialize!
