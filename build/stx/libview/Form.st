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

GraphicsMedium subclass:#Form
	instanceVariableNames:'depth localColorMap offset data maskedPixelsAre0'
	classVariableNames:'VeryLightGreyForm LightGreyForm GreyForm DarkGreyForm
		VeryDarkGreyForm AdditionalBitmapDirectoryNames
		BlackAndWhiteColorMap DitherPatternArray'
	poolDictionaries:''
	category:'Compatibility-ST80-Graphics-Display Objects'
!

Form subclass:#ImageForm
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Form
!

!Form class methodsFor:'documentation'!

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
    Instances of this class represent forms (i.e. bit- and pixmaps)
    which can be created on a drawing device.
    In X, these device resources are XPixmaps.
    Not all devices will support forms.

    NOTICE:
	the Form class is a historic leftover and now only used for real
	device forms (i.e. on devices which support downloading bitmaps).

	In your application, you should always use Image, both for compatibility
	with ST-80 and for device independence, since Form may not be supported
	by all devices.

    WARNING:
	Forms created on some device may not be recreatable, when an
	image is restarted on a display with different display capabilities.
	For example, a 24bit truecolor form will be lost when the image is
	saved and restarted in an 8bit or monochrome display.
	Worse: the information is completely lost.

	With images, the original information is always preserved, although
	the display may be with less resolution, dithered or otherwise
	approximated.

    [See also:]
	Image DeviceDrawable

    [author:]
	Claus Gittinger
"
! !

!Form class methodsFor:'initialization'!

initialize
    "initialize set of dictionaries to look for bitmaps"

    AdditionalBitmapDirectoryNames isNil ifTrue:[
	OperatingSystem isMSWINDOWSlike ifTrue:[
	    AdditionalBitmapDirectoryNames := #().
	] ifFalse:[
	    AdditionalBitmapDirectoryNames := #('/usr/lib/X11/bitmaps').
	].

	"want to be informed when returning from snapshot"
	ObjectMemory addDependent:self.
    ].
!

reinitializeAllOn:aDevice
    "recreate all forms on aDevice; called by Workstation after snapIn, to
     have all background bitmaps at hand, when views are restored"

    Form allSubInstancesDo:[:eachForm |
	eachForm graphicsDevice == aDevice ifTrue:[
            "now, try to recreate it"
	    eachForm recreate.
        ]
    ]

    "Modified: 5.7.1996 / 17:55:58 / cg"
!

update:something with:aParameter from:changedObject
    "sent just before snapOut and just after a snapIn"

    (something == #save) ifTrue:[
	"get all bits from the device into saveable arrays"
	Form allSubInstancesDo:[:eachForm |
            (PrimitiveFailureSignal , DeviceWorkstation drawingOnClosedDeviceSignal) handle:[:ex |
                'Form [warning]: cannot fetch form bits from device' errorPrintCR
            ] do:[
                |dev|

		((dev := eachForm graphicsDevice) notNil
		 and:[dev isPersistentInSnapshot]) ifTrue:[
		    eachForm getBits
		]
	    ]
	]
    ].
    (something == #restarted) ifTrue:[
	"remove all left-over device info"
	Form allSubInstancesDo:[:eachForm |
	    eachForm flushDeviceHandles.
	]
    ]

    "Modified: 15.6.1996 / 15:44:09 / cg"
    "Created: 15.6.1996 / 15:47:50 / cg"
! !

!Form class methodsFor:'instance creation'!

dotOfSize:size
    "create and return a form which contains a dot (filled circle)
     of the given size."

    |f|

    f := self extent:size asPoint onDevice:Screen current.
    f clear.
    f fillCircle:(f center) radius:(f width min:f height) // 2.
    ^ f

    "
     (Form dotOfSize:8) inspect
     (Form dotOfSize:20) inspect
    "
!

extent:ext
    "create a new, cleared form, take dimensions from ext.
     Smalltalk-80 compatibility"

    |newForm|

    newForm := self width:(ext x) height:(ext y).
    newForm fill:(Color colorId:0).
    newForm paint:(Color colorId:1).
    ^ newForm
!

extent:ext depth:d
    "create a new, cleared form.
     Smalltalk-80 compatibility"

    ^ self width:ext x height:ext y depth:d

    "Created: 27.1.1997 / 16:08:37 / cg"
    "Modified: 27.1.1997 / 16:08:50 / cg"
!

extent:ext depth:d onDevice:aDevice
    "create a new form on device, aDevice; depth is what device likes most"

    ^ self width:ext x height:ext y depth:d onDevice:aDevice

    "Created: 4.4.1997 / 20:23:32 / cg"
    "Modified: 4.4.1997 / 20:25:28 / cg"
!

extent:ext fromArray:data
    "create a new form, take dimensions from ext, bits from data.
     Smalltalk-80 compatibility."

    ^ self width:(ext x) height:(ext y) offset:0@0 fromArray:data
!

extent:ext fromArray:data offset:offs
    "create a new form, take dimensions from ext, bits from data.
     Smalltalk-80 compatibility."

    ^ self width:(ext x) height:(ext y) offset:offs fromArray:data
!

extent:ext fromArray:data offset:offs onDevice:aDevice
    "create a new form, take dimensions from ext, bits from data."

    ^ self width:(ext x) height:(ext y) offset:offs fromArray:data onDevice:aDevice

    "Created: 10.4.1997 / 15:36:31 / cg"
!

extent:ext fromArray:data onDevice:aDevice
    "create a new form, take dimensions from ext, bits from data."

    ^ self width:(ext x) height:(ext y) fromArray:data onDevice:aDevice

    "Created: 10.4.1997 / 15:34:34 / cg"
    "Modified: 10.4.1997 / 15:36:04 / cg"
!

extent:ext offset:anOffset
    "create a new, cleared form, take dimensions from ext.
     Smalltalk-80 compatibility"

    ^ (self extent:ext) offset:anOffset.
!

extent:ext onDevice:aDevice
    "create a new form on device, aDevice; depth is what device likes most"

    ^ self width:ext x height:ext y onDevice:aDevice

    "Modified: 4.4.1997 / 20:25:07 / cg"
!

width:w height:h
    "create a new form on the default device"

    |scr|

    Screen notNil ifTrue:[scr := Screen current].
    ^ self width:w height:h onDevice:scr

    "Modified: 4.6.1996 / 22:16:33 / cg"
!

width:w height:h depth:d
    "create a new form on the default device"

    |scr|

    Screen notNil ifTrue:[scr := Screen current].
    ^ self width:w height:h depth:d onDevice:scr

    "Modified: 4.6.1996 / 22:16:51 / cg"
!

width:w height:h depth:d onDevice:aDevice
    "create a new form with depth d on device, aDevice"

    ^ (self onDevice:aDevice) width:w height:h depth:d.

    "Modified: 18.1.1997 / 18:26:03 / cg"
!

width:w height:h fromArray:anArray
    "create a new form on the default device"

    |scr|

    Screen notNil ifTrue:[scr := Screen current].
    ^ self width:w height:h fromArray:anArray onDevice:scr

    "Modified: / 29-05-2007 / 19:31:14 / cg"
!

width:w height:h fromArray:anArray onDevice:aDevice
    "create a new form on device, aDevice and
     initialize the pixels from anArray"

    ^ (self onDevice:aDevice) width:w height:h fromArray:anArray

    "Modified: 18.1.1997 / 18:26:24 / cg"
!

width:w height:h offset:offs fromArray:anArray
    "create a new form on the default device"

    |scr|

    Screen notNil ifTrue:[scr := Screen current].
    ^ self width:w height:h offset:offs fromArray:anArray onDevice:scr
!

width:w height:h offset:offs fromArray:anArray onDevice:aDevice
    "create a new form on the default device"

    ^ (self onDevice:aDevice) width:w height:h offset:offs fromArray:anArray

    "Modified: 18.1.1997 / 18:26:28 / cg"
    "Created: 10.4.1997 / 15:35:07 / cg"
!

width:w height:h onDevice:aDevice
    "create a new form on device, aDevice; depth is what device likes most"

    ^ (self onDevice:aDevice) width:w height:h

    "Modified: 18.1.1997 / 18:26:31 / cg"
! !

!Form class methodsFor:'Compatibility-ST80'!

and
    "return a constant usable as bitblt-combinationrule.
     In ST-80rel2.x, these used to be numeric constants; in ST/X,
     these are symbolic."

    ^ #and

    "Modified: 2.5.1996 / 11:41:23 / cg"
!

black
    "ST80 compatibility;
     In old st80, you could use `Form black' for drawing
     - here we return the black color."

    ^ Color black

    "Modified: 2.5.1996 / 11:44:17 / cg"
!

darkGray
    "ST80 compatibility;
     In old st80, you could use `Form darkGray' for drawing
     - here we return the darkGray color."

    ^ Color darkGray

    "Modified: 2.5.1996 / 11:44:06 / cg"
!

darkGrey
    "ST80 compatibility;
     In old st80, you could use `Form darkGrey' for drawing
     - here we return the darkGrey color."

    ^ Color darkGray

    "Modified: 28.5.1996 / 20:47:54 / cg"
!

gray
    "ST80 compatibility;
     In old st80, you could use `Form gray' for drawing
     - here we return the grey color."

    ^ Color gray

    "Modified: 2.5.1996 / 11:43:44 / cg"
!

grey
    "ST80 compatibility;
     In old st80, you could use `Form grey' for drawing
     - here we return the grey color."

    ^ Color gray

    "Modified: 2.5.1996 / 11:43:17 / cg"
!

lightGray
    "ST80 compatibility;
     In old st80, you could use `Form lightGray' for drawing
     - here we return the lightGray color."

    ^ Color lightGray

    "Created: 2.5.1996 / 11:40:07 / cg"
    "Modified: 2.5.1996 / 11:43:21 / cg"
!

lightGrey
    "ST80 compatibility;
     In old st80, you could use `Form lightGray' for drawing
     - here we return the lightGray color."

    ^ Color lightGray

    "Modified: 28.5.1996 / 20:53:28 / cg"
!

over
    "return a constant usable as bitblt-combinationrule.
     In ST-80rel2.x, these used to be numeric constants; in ST/X,
     these are symbolic."

    ^ #copy

    "Modified: 2.5.1996 / 11:41:31 / cg"
!

paint
    "return a constant usable as bitblt-combinationrule.
     In ST-80rel2.x, these used to be numeric constants; in ST/X,
     these are symbolic."

    ^ #copy

    "Modified: 2.5.1996 / 11:41:40 / cg"
!

reverse
    "return a constant usable as bitblt-combinationrule.
     In ST-80rel2.x, these used to be numeric constants; in ST/X,
     these are symbolic."

    ^ #xor

    "Modified: 2.5.1996 / 11:41:45 / cg"
!

under
    "return a constant usable as bitblt-combinationrule.
     In ST-80rel2.x, these used to be numeric constants; in ST/X,
     these are symbolic."

    ^ #or

    "Modified: 2.5.1996 / 11:41:49 / cg"
!

white
    "ST80rel2.x compatibility;
     In old st80, you could use `Form white' for drawing
     - here we return the white color."

    ^ Color white

    "Modified: 2.5.1996 / 11:42:50 / cg"
! !

!Form class methodsFor:'Compatibility-Squeak'!

extent:ext depth:d bits:data
    ^ self width:(ext x) height:(ext y) offset:0 fromArray:data

    "Created: / 26-05-2007 / 22:35:12 / cg"
!

extent:ext depth:d fromArray:data offset:offs

    d ~~ 1 ifTrue:[self error:'unsupported depth' mayProceed:true].
    ^ self width:(ext x) height:(ext y) offset:offs fromArray:data
!

fromUser
    ^ Image fromUser asFormOn:(Screen current)

    "
     Delay waitForSeconds:1.
     Form fromUser inspect.
     Delay waitForSeconds:1.
    "

    "Created: / 07-06-2016 / 12:01:53 / cg"
! !

!Form class methodsFor:'accessing private classes'!

imageForm
    ^ ImageForm
! !

!Form class methodsFor:'cleanup'!

lowSpaceCleanup
    "cleanup in low-memory situations"

    DitherPatternArray := nil
! !

!Form class methodsFor:'file search'!

findBitmapFile:fileName
    <resource: #obsolete>
    "find the bitmap file in one of the standard places;
     return the pathName or nil"

    |path|

    ((fileName at:1) == $/) ifTrue:[^ fileName].
    (fileName startsWith:'../') ifTrue:[^ fileName].
    (fileName startsWith:'./') ifTrue:[^ fileName].
    fileName asFilename exists ifTrue:[^ fileName].

    path := Smalltalk getBitmapFileName:fileName.
    path notNil ifTrue:[
	^ path
    ].

    AdditionalBitmapDirectoryNames notNil ifTrue:[
	AdditionalBitmapDirectoryNames do:[:aPath |
	    path := aPath , '/' , fileName.
	    (OperatingSystem isReadable:path) ifTrue:[
		^ path
	    ]
	]
    ].
    ^ nil
! !

!Form class methodsFor:'obsolete instance creation'!

darkGreyFormOn:aDevice
    <resource: #obsolete>
    "return a darkGrey form"

    |f|

    ((aDevice == Display) and:[DarkGreyForm notNil]) ifTrue:[
	^ DarkGreyForm
    ].

    f := self width:8 height:4 fromArray:(self darkGreyFormBits) onDevice:aDevice.
    (aDevice == Display) ifTrue:[
	DarkGreyForm := f
    ].
    ^ f
!

extent:ext depth:d on:aDevice
    <resource: #obsolete>
    "create a new form on device, aDevice; depth is what device likes most"

    self obsoleteMethodWarning:'use #extent:depth:onDevice:'.
    ^ self width:ext x height:ext y depth:d onDevice:aDevice

    "Created: / 04-04-1997 / 20:23:32 / cg"
    "Modified: / 27-05-2007 / 12:39:51 / cg"
!

extent:ext fromArray:data offset:offs on:aDevice
    <resource: #obsolete>
    "create a new form, take dimensions from ext, bits from data."

    self obsoleteMethodWarning:'use #extent:fromArray:offset:onDevice:'.
    ^ self width:(ext x) height:(ext y) offset:offs fromArray:data onDevice:aDevice

    "Created: / 10-04-1997 / 15:36:31 / cg"
    "Modified: / 27-05-2007 / 12:42:26 / cg"
!

extent:ext fromArray:data on:aDevice
    <resource: #obsolete>
    "create a new form, take dimensions from ext, bits from data."

    self obsoleteMethodWarning:'use #extent:fromArray:onDevice:'.
    ^ self width:(ext x) height:(ext y) fromArray:data onDevice:aDevice

    "Created: / 10-04-1997 / 15:34:34 / cg"
    "Modified: / 27-05-2007 / 12:41:57 / cg"
!

extent:ext on:aDevice
    <resource: #obsolete>
    "create a new form on device, aDevice; depth is what device likes most"

    self obsoleteMethodWarning:'use #extent:onDevice:'.
    ^ self width:ext x height:ext y onDevice:aDevice

    "Modified: / 27-05-2007 / 12:41:42 / cg"
!

grey:percent on:aDevice
    <resource: #obsolete>
    "return a form for dithering"

    (percent < 20) ifTrue:[^ Color black onDevice:aDevice].
    (percent < 40) ifTrue:[^ self darkGreyFormOn:aDevice].
    (percent < 60) ifTrue:[^ self mediumGreyFormOn:aDevice].
    (percent < 80) ifTrue:[^ self lightGreyFormOn:aDevice].
    ^ Color white onDevice:aDevice
!

lightGreyFormOn:aDevice
    <resource: #obsolete>
    "return a lightGrey form"

    |f|

    ((aDevice == Display) and:[LightGreyForm notNil]) ifTrue:[
	^ LightGreyForm
    ].

    f := self width:8 height:4 fromArray:(self lightGreyFormBits) onDevice:aDevice.
    (aDevice == Display) ifTrue:[
	LightGreyForm := f
    ].
    ^ f
!

mediumGreyFormOn:aDevice
    <resource: #obsolete>
    "return a grey form"

    |f|

    ((aDevice == Display) and:[GreyForm notNil]) ifTrue:[
	^ GreyForm
    ].

    f := self width:8 height:4 fromArray:(self greyFormBits) onDevice:aDevice.
    (aDevice == Display) ifTrue:[
	GreyForm := f
    ].
    ^ f
!

veryDarkGreyFormOn:aDevice
    <resource: #obsolete>
    "return a veryDarkGrey form"

    |f|

    ((aDevice == Display) and:[VeryDarkGreyForm notNil]) ifTrue:[
	^ VeryDarkGreyForm
    ].

    f := self width:8 height:4 fromArray:(self veryDarkGreyFormBits) onDevice:aDevice.
    (aDevice == Display) ifTrue:[
	VeryDarkGreyForm := f
    ].
    ^ f
!

veryLightGreyFormOn:aDevice
    <resource: #obsolete>
    "return a veryLightGrey form"

    |f|

    ((aDevice == Display) and:[VeryLightGreyForm notNil]) ifTrue:[
	^ VeryLightGreyForm
    ].

    f := self width:8 height:4 fromArray:(self veryLightGreyFormBits) onDevice:aDevice.
    (aDevice == Display) ifTrue:[
	VeryLightGreyForm := f
    ].
    ^ f
!

width:w height:h depth:d on:aDevice
    <resource: #obsolete>
    "create a new form with depth d on device, aDevice"

    self obsoleteMethodWarning:'use #width:height:depth:onDevice:'.
    ^ (self onDevice:aDevice) width:w height:h depth:d

    "Modified: / 27-05-2007 / 12:40:25 / cg"
!

width:w height:h fromArray:anArray on:aDevice
    <resource: #obsolete>
    "create a new form on device, aDevice and
     initialize the pixels from anArray"

    self obsoleteMethodWarning:'use #width:height:fromArray:onDevice:'.
    ^ (self onDevice:aDevice) width:w height:h fromArray:anArray

    "Modified: / 27-05-2007 / 12:40:41 / cg"
!

width:w height:h offset:offs fromArray:anArray on:aDevice
    <resource: #obsolete>
    "create a new form on the default device"

    self obsoleteMethodWarning:'use #width:height:offset:fromArray:onDevice:'.
    ^ (self onDevice:aDevice) width:w height:h offset:offs fromArray:anArray

    "Created: / 10-04-1997 / 15:35:07 / cg"
    "Modified: / 27-05-2007 / 12:41:17 / cg"
!

width:w height:h on:aDevice
    <resource: #obsolete>
    "create a new form on device, aDevice; depth is what device likes most"

    self obsoleteMethodWarning:'use #width:height:onDevice:'.
    ^ (self onDevice:aDevice) width:w height:h

    "Modified: / 27-05-2007 / 12:40:57 / cg"
! !

!Form class methodsFor:'obsolete patterns'!

darkGreyFormBits
    <resource: #obsolete>
    "return a pattern usable to simulate darkGray on monochrome device"

    ^ #(2r10111011
	2r11101110
	2r10111011
	2r11101110)
!

grey12Bits
    <resource: #obsolete>
    "return a pattern with 12% grey, usable for dithering"

    ^ #(2r00010001
	2r00000000
	2r01000100
	2r00000000)
!

grey25Bits
    <resource: #obsolete>
    "return a pattern with 25% grey, usable for dithering"

    ^ #(2r00010001
	2r01000100
	2r00010001
	2r01000100)
!

grey37Bits
    <resource: #obsolete>
    "return a pattern with 37% grey, usable for dithering"

    ^ #(2r00010001
	2r10101010
	2r01000100
	2r10101010)
!

grey50Bits
    <resource: #obsolete>
    "return a pattern with 50% grey, usable for dithering"

    ^ #(2r01010101
	2r10101010
	2r01010101
	2r10101010)
!

grey6Bits
    <resource: #obsolete>
    "return a pattern with 6% grey, usable for dithering"

    ^ #(2r00000001
	2r00000000
	2r00010000
	2r00000000)
!

greyFormBits
    <resource: #obsolete>
    "return a pattern usable to simulate gray on monochrome device"

    ^ #(2r01010101
	2r10101010
	2r01010101
	2r10101010)
!

lightGreyFormBits
    <resource: #obsolete>
    "return a pattern usable to simulate lightGray on monochrome device"

    ^ #(2r01000100
	2r00010001
	2r01000100
	2r00010001
	2r01000100)
!

veryDarkGreyFormBits
    <resource: #obsolete>
    "return a pattern usable to simulate veryDarkGray on monochrome device"

    ^ #(2r01110111
	2r11111111
	2r11011101
	2r11111111)
!

veryLightGreyFormBits
    <resource: #obsolete>
    "return a pattern usable to simulate veryDarkGray on monochrome device"

    ^ #(2r10001000
	2r00000000
	2r00100010
	2r00000000)
! !

!Form methodsFor:'Compatibility-ST80'!

displayAt:aPoint
    "show the receiver on the current display screen"

    self displayOn:Screen current rootView at:aPoint

    "
     (Form dotOfSize:8) displayAt:10@10
    "


!

displayOn:aGC at:aPoint rule:rule
    "draw in aGC.
     Smalltalk-80 (2.x) compatibility"

    self displayOn:aGC x:aPoint x y:aPoint y rule:rule

    "Modified: 12.5.1996 / 20:16:02 / cg"
!

displayOn:aGC rule:rule
    "draw in aGC.
     Smalltalk-80 (2.x) compatibility"

    ^ self displayOn:aGC x:0 y:0 rule:rule

    "Modified: 12.5.1996 / 20:15:41 / cg"
!

displayOn:aGC x:x y:y
    "draw in aGC.
     Smalltalk-80 (2.x) compatibility"

    ^ self displayOn:aGC x:x y:y rule:#copy

    "Created: 12.5.1996 / 20:15:05 / cg"
!

displayOn:aGC x:x y:y rule:rule
    "draw in aGC.
     Smalltalk-80 (2.x) compatibility"

    |f|

    f := aGC function.
    aGC function:rule.
    aGC displayOpaqueForm:self x:x y:y.
    aGC function:f.

    "Created: 12.5.1996 / 20:15:26 / cg"
!

isOpen
    ^ true

    "Created: 10.2.1997 / 12:43:49 / cg"
!

offset
    "set the offset.
     Smalltalk-80 compatibility"

    ^ offset
!

offset:org
    "set the offset.
     Smalltalk-80 compatibility"

    offset := org
!

preferredBounds
    ^ self bounds

    "Created: 10.2.1997 / 12:43:00 / cg"
! !

!Form methodsFor:'Compatibility-Squeak'!

colormapIfNeededForDepth:destDepth

    ^nil
!

magnify:aRectangle by:scale smoothing:smooth
    ^ ((Image fromSubForm:aRectangle in:self) magnifiedBy:scale) asFormOn:device.
! !

!Form methodsFor:'accessing'!

bits
    "return a ByteArray filled with my bits -
     for depth 8 forms, 1 pixel/byte is filled;
     for depth 1 forms, 8 pixels/byte are filled
     for depth 4 forms, 2 pixels/byte are filled.
     Padding is done row-wise to the next BYTE-boundary
     If multiple pixels are contained in a single byte,
     left bits are in the most significant bit positions.
     (i.e. for width==13 and depth==1 it will return 2 bytes per scanline)"

    |bytesPerLine   "{ Class: SmallInteger }"
     bytesPerLineIn "{ Class: SmallInteger }"
     inData tmpData info
     srcIndex "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     buffer spaceBitsPerPixel|

    data notNil ifTrue:[
        ^ data
    ].
    self drawableId isNil ifTrue:[
        ^ nil
    ].

    spaceBitsPerPixel := depth.
    (depth > 8) ifTrue:[
        spaceBitsPerPixel := 16.
        (depth > 16) ifTrue:[
            spaceBitsPerPixel := 32.
            (depth > 32) ifTrue:[
                spaceBitsPerPixel := depth.
            ]
        ]
    ].

    bytesPerLine := (width * spaceBitsPerPixel + 31) // 32 * 4.
    inData := ByteArray uninitializedNew:(bytesPerLine * height).
    info := device getBitsFromPixmapId:self drawableId x:0 y:0 width:width height:height into:inData.
    bytesPerLineIn := (info at:#bytesPerLine).                    "what I got"
    bytesPerLine := (width * depth + 7) // 8.                     "what I want"
    (bytesPerLine ~~ bytesPerLineIn) ifTrue:[
        "
         different padding - have to copy over row-wise
        "
        tmpData := inData.
        inData := ByteArray uninitializedNew:(bytesPerLine * height).
        srcIndex := 1.
        dstIndex := 1.
        1 to:height do:[:hi |
            inData replaceFrom:dstIndex to:(dstIndex + bytesPerLine - 1)
                          with:tmpData startingAt:srcIndex.
            dstIndex := dstIndex + bytesPerLine.
            srcIndex := srcIndex + bytesPerLineIn
        ]
    ] ifFalse:[
        "
         same padding - copy over all in one chunk
        "
        (bytesPerLine * height) ~~ inData size ifTrue:[
            tmpData := inData.
            inData := ByteArray uninitializedNew:(bytesPerLine * height).
            inData replaceFrom:1 to:bytesPerLine * height with:tmpData startingAt:1
        ]
    ].

    "
     have to reverse bytes, if not msbFirst ?
    "

"/    (info at:#byteOrder) ~~ #msbFirst ifTrue:[
"/        buffer := ByteArray new:bytesPerLine.
"/        dstIndex := 1.
"/        1 to:height do:[:hi |
"/            buffer replaceFrom:1 to:bytesPerLine with:inData startingAt:dstIndex.
"/            buffer reverse.
"/            inData replaceFrom:dstIndex to:dstIndex+bytesPerLine-1 with:buffer startingAt:1.
"/            dstIndex := dstIndex + bytesPerLine
"/        ]
"/    ].

    "
     have to reverse bits, if not msbFirst ?
    "
    (info at:#bitOrder) ~~ #msbFirst ifTrue:[
        buffer := ByteArray new:bytesPerLine.
        dstIndex := 1.
        1 to:height do:[:hi |
            buffer replaceFrom:1 to:bytesPerLine with:inData startingAt:dstIndex.
            buffer expandPixels:8 width:bytesPerLine height:1 into:buffer
                                mapping:(ImageReader reverseBits).  "/ translate only
            inData replaceFrom:dstIndex to:dstIndex+bytesPerLine-1 with:buffer startingAt:1.
            dstIndex := dstIndex + bytesPerLine
        ]
    ].

    ^ inData.

    "Modified: / 19.2.1998 / 14:47:06 / cg"
!

bits:aByteArray
    "set the forms bits;
     for depth-8 forms, 1 pixel/byte is expected;
     for depth-1 forms, 8 pixels/byte are expected
     for depth-4 forms, 2 pixels/byte are expected.
     Padding is expected to the next byte-boundary
     (i.e. for width==13 and depth==1 2 bytes per scanline are expected)"

    data := aByteArray

    "Modified: 23.4.1996 / 10:06:01 / cg"
!

bitsPerSample
    "for compatibility with Image class ..."

    ^ Array with:depth
!

colorMap
    "return the receiver's colormap"

    ^ localColorMap
!

colorMap:anArrayOrColorMap
    "set the receiver's colormap"

    localColorMap := anArrayOrColorMap.
!

depth
    "return the receiver's depth"

    ^ depth
!

forgetBits
    "for image, which also keeps the bits - so there is
     no need to hold them again here"

    data := nil
!

mask
    "for compatibility with images; forms have no mask/alpha channel"

    ^ nil

    "Created: 21.6.1996 / 12:52:42 / cg"
!

maskedPixelsAre0
    ^ maskedPixelsAre0
!

maskedPixelsAre0:something
    maskedPixelsAre0 := something.
!

photometric
    "for compatibility with Image class ..."

    depth == 1 ifTrue:[
	localColorMap isNil ifTrue:[
	    ^ #whiteIs0
	].
	((localColorMap at:1) = Color white) ifTrue:[
	    ((localColorMap at:2) = Color black) ifTrue:[
		^ #whiteIs0
	    ].
	].
	((localColorMap at:1) = Color black) ifTrue:[
	    ((localColorMap at:2) = Color white) ifTrue:[
		^ #blackIs0
	    ].
	].
    ] ifFalse:[depth > 8 ifTrue:[
	^ #rgb
    ]].

    ^ #palette

    "Modified: 17.6.1996 / 11:45:16 / cg"
!

samplesPerPixel
    "for compatibility with Image class ..."

    ^ 1
!

valueAt:aPoint
    "return the pixel at aPoint; the coordinates start with 0@0
     in the upper left, increasing to the lower right"

    ^ self at:aPoint

    "Modified: 23.4.1996 / 10:06:55 / cg"
!

valueAt:aPoint put:value
    "set the pixel at aPoint; the coordinates start with 0@0
     in the upper left, increasing to the lower right."

    ^ self at:aPoint put:value

    "
     |f|

     f := Form width:10 height:10 depth:1.
     f clear.
     1 to:10 do:[:i |
	f valueAt:(i @ i) put:1
     ].
     f inspect
    "

    "Modified: 23.4.1996 / 10:12:48 / cg"
! !



!Form methodsFor:'converting'!

asForm
    "convert & return the receiver into a Form instance - nothing to be done here"

    ^ self

    "Modified: 23.4.1996 / 10:14:11 / cg"
!

asImage
    "convert & return the receiver into an Image instance"

    ^ Image fromForm:self

    "Modified: 23.4.1996 / 10:13:56 / cg"
!

asImageForm
    "convert & return the receiver into a ImageForm instance"

    |imageForm|

    imageForm := ImageForm cloneFrom:self.

    "kludge: have to unregister. Otherwise the form will be destroyed when
     we are garbage collected"

    gc finalizationLobby
	unregister:gc;
	registerChange:imageForm graphicsContext.

    ^ imageForm.
! !

!Form methodsFor:'copying'!

postCopy
    "redefined to copy the colorMap as well"

    super postCopy.
    localColorMap := localColorMap copy.
    data := data copy

    "Modified: 23.4.1996 / 10:14:46 / cg"
! !

!Form methodsFor:'editing'!

show
    "open an imageView on the receiver"

    ImageView openOnImage:self

    "
     (Form fromFile:'bitmaps/SBrowser.xbm') show
    "

    "Modified: 23.4.1996 / 10:16:12 / cg"
! !

!Form methodsFor:'getting a device form'!

asFormOn:aDevice
    "convert & return the receiver into a Form instance
     and associate it to a device (i.e. download its bits).
     Added for protocol compatibility with Image."

    aDevice == device ifTrue:[
        ^ self
    ].
    ^ self onDevice:aDevice

    "Modified: 23.4.1996 / 10:17:26 / cg"
    "Modified: 26.8.1997 / 10:29:14 / stefan"
!

asMonochromeFormOn:aDevice
    "added for protocol compatiblity with Image"

    depth == 1 ifTrue:[
        aDevice == device ifTrue:[
            ^ self
        ].
        ^ self onDevice:aDevice
    ].
    ^ nil

    "Modified: / 27.7.1998 / 20:04:37 / cg"
!

exactOn:aDevice
    "for compatibility with color protocol - here, the same as #onDevice."

    ^ self onDevice:aDevice

!

exactOrNearestOn:aDevice
    "for compatibility with color protocol - here, the same as #onDevice."

    ^ self onDevice:aDevice

!

nearestOn:aDevice
    "for compatibility with color protocol - here, the same as #onDevice."

    ^ self onDevice:aDevice

!

on:aDevice
    "associate the receiver to a device (i.e. download its bits);
     return a deviceForm (possibly different from the receiver)."

    "/ send out a warning: #on: is typically used to create views
    "/ operating on a model.
    "/ Please use #onDevice: to avoid confusion.

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #onDevice:'.
    ^ self onDevice:aDevice

    "Modified: 5.6.1997 / 21:05:34 / cg"
!

onDevice:aDevice
    "associate the receiver to a device (i.e. download its bits);
     return a deviceForm (possibly different from the receiver)."

    aDevice == device ifTrue:[
        ^ self
    ].
    aDevice isNil ifTrue:[^ self].

    "create a new form ..."

    data notNil ifTrue:[
        "/ 'Form [info]: create from data' printCR.
        ^ self class width:width height:height fromArray:data onDevice:aDevice
    ].
    Logger warning:'no bit data in #onDevice: - returning a black form'.
    ^ (self class width:width height:height onDevice:aDevice) clear

    "Modified: / 27.7.1998 / 20:05:20 / cg"
! !

!Form methodsFor:'image manipulations'!

clearMaskedPixels
    "Added for protocol compatibility with Image."

    ^ self
!

clearMaskedPixels:maskForm
    "clear any masked pixels.
     This will allow faster drawing in the future."

    "black is 0 in mask - masked bits are 0"
    gc
        foreground:Color allColor background:Color noColor;
        function:#and;
        copyPlaneFrom:maskForm graphicsContext x:0 y:0 toX:0 y:0 width:width height:height.

    maskedPixelsAre0 := true.
!

darkened
    "return a darkened version of the receiver.
     Added for protocol compatibility with Color and Image.
     Here, the receiver is returned as a kludge
     - actually should return a darkened image (or Color black ?) .."

    ^ self

    "Modified: 23.4.1996 / 10:19:52 / cg"
!

easyMagnifiedBy:extent into: newForm
    "return a new form magnified by extent, aPoint.
     If non-integral magnify is asked for, pass the work on to 'hardMagnifiedBy:'"

    |mX mY dstX dstY ext
     factor "{ Class: SmallInteger }"
     n      "{ Class: SmallInteger }" |

    ext := extent asPoint.
    mX := ext x.
    mY := ext y.
    ((mX = 1) and:[mY = 1]) ifTrue:[^ self].

    "expand rows"
    (mY > 1) ifTrue:[
	dstY := 0.
	n := height.
	factor := mY.
	0 to:(n - 1) do:[:srcY |
	    1 to:factor do:[:i |
		newForm copyFrom:self
			       x:0 y:srcY
			     toX:0 y:dstY
			   width:width height:1.
		dstY := dstY + 1
	    ]
	]
    ].

    "expand cols"
    (mX > 1) ifTrue:[
	n := width.
	factor := mX.
	dstX := (n * factor) - 1.
	(n - 1) to:0 by:-1 do:[:srcX |
	    1 to:factor do:[:i |
		newForm copyFrom:newForm
			       x:srcX y:0
			     toX:dstX y:0
			   width:1 height:(height * mY).
		dstX := dstX - 1
	    ]
	]
    ].
    ^ newForm

    "
     (ArrowButton upArrowButtonForm:#iris on:Display) magnifiedBy:(2 @ 2)
     (Form fromFile:'bitmaps/SBrowser.xbm') magnifiedBy:(2 @ 2)
     (Form fromFile:'bitmaps/SBrowser.xbm') magnifiedBy:(0.4 @ 0.4)
    "
!

flipHorizontal
    "return a new form flipped vertically"

    |dstX newForm |

    newForm := (self class onDevice:device)
                                width:width
                                height:height
                                depth:depth.
    dstX := width - 1.
    0 to:dstX do:[:srcX |
        newForm copyFrom:self
                       x:srcX y:0
                     toX:dstX y:0
                   width:1 height:height.
        dstX := dstX - 1
    ].
    newForm colorMap:localColorMap.
    ^ newForm

    "
     |testForm|

     testForm _ Form
                    extent: 8@8
                    depth: 1
                    fromArray:
                     #( 2r10000000
                        2r11000000
                        2r11100000
                        2r11110000
                        2r11111000
                        2r11111100
                        2r11111110
                        2r11111111)
                    offset: 0@0.
     testForm inspect.
     testForm flipVertical inspect.
     testForm flipHorizontal inspect.
    "
!

flipVertical
    "return a new form flipped horizontally"

    |dstY newForm |

    newForm := (self class onDevice:device)
                                width:width
                                height:height
                                depth:depth.
    dstY := height - 1.
    0 to:dstY do:[:srcY |
        newForm copyFrom:self
                       x:0 y:srcY
                     toX:0 y:dstY
                   width:width height:1.
        dstY := dstY - 1
    ].
    newForm colorMap:localColorMap.
    ^ newForm

    "
     |testForm|

     testForm _ Form 
                    extent: 8@8 
                    depth: 1 
                    fromArray:
                     #( 2r10000000
                        2r11000000 
                        2r11100000
                        2r11110000 
                        2r11111000
                        2r11111100 
                        2r11111110
                        2r11111111)
                    offset: 0@0.
     testForm inspect.
     testForm flipVertical inspect.
     testForm flipHorizontal inspect.
    "
!

hardMagnifiedBy:extent
    "return a new form magnified by extent, aPoint.
     This method handles non-integral factors."

    "
     since Form will be replaced by Image in the long run,
     and this operation is slow anyway, use the implementation
     in Image for this."

    ^ ((Image fromForm:self) magnifiedBy:extent) asFormOn:device.

    "
     (Form fromFile:'OutputOn.64') magnifiedBy:0.5@0.5
     (Form fromFile:'OutputOn.64') magnifiedBy:1.5@1.5
    "
!

lightened
    "return a lightened version of the receiver.
     Added for protocol compatibility with Color and Image.
     Here, the receiver is returned as a kludge
     - actually should return a lightened image (or Color white ?) .."

    ^ self

    "Modified: 23.4.1996 / 10:20:14 / cg"
!

magnifiedBy:extent
    "return a new form magnified by extent, aPoint.
     If non-integral magnify is asked for, pass the work on to 'hardMagnifiedBy:'"

    |mX mY newForm ext|

    ext := extent asPoint.
    mX := ext x.
    mY := ext y.
    ((mX = 1) and:[mY = 1]) ifTrue:[^ self].

    ((mX isMemberOf:SmallInteger) and:[mY isMemberOf:SmallInteger]) ifFalse:[
        ^ self hardMagnifiedBy:ext
    ].

    newForm := (self class onDevice:device)
                                width:(width * mX)
                                height:(height * mY)
                                depth:depth.
    self easyMagnifiedBy:extent into:newForm.
    newForm colorMap:localColorMap.
    ^ newForm

    "
     (ArrowButton upArrowButtonForm:#iris on:Screen current) magnifiedBy:(2 @ 2)
     (Form fromFile:'bitmaps/SBrowser.xbm') magnifiedBy:(2 @ 2)
     (Form fromFile:'bitmaps/SBrowser.xbm') magnifiedBy:(0.4 @ 0.4)
    "
!

magnifiedTo:anExtent
    "return a new form magnified to have the size specified by extent.
     This may distort the image if the arguments ratio is not the images ratio.
     See also #magnifiedPreservingRatioTo: and #magnifiedBy:"

    ^ self magnifiedBy:(anExtent / self extent)

    "Created: 18.4.1996 / 16:17:52 / cg"
!

magnifyBy:scale
    <resource: #obsolete>
    "obsolete: has been renamed to magnifiedBy: for ST-80 compatibility
     and name consistency ..."

    self obsoleteMethodWarning.
    ^ self magnifiedBy:scale
! !

!Form methodsFor:'initialization'!

initGC
    "stop server from sending exposure events for Forms -
     (will fill up stream-queue on some stupid (i.e. sco) systems"

    |gcId|

    "/ depth-1 forms draw differently ...
    depth == 1 ifTrue:[
        |fg bg|
        self foreground isNil ifTrue:[
            fg := Color colorId:1.
        ].
        self background isNil ifTrue:[
            bg := Color colorId:0
        ].
        "nil colors will not be set"
        self setPaint:fg on:bg.
    ].
    gcId := super initGC.
    self setGraphicsExposures:false.
    ^ gcId.

    "Modified: 17.7.1996 / 13:21:24 / cg"
!

initialize
    depth := 1.
    maskedPixelsAre0 := false.
    gc notNil ifTrue:[ 
        gc paint: (Color colorId:1).
        gc backgroundPaint:(Color colorId:0).      
    ].
    super initialize.

    "Modified: / 25-04-2016 / 20:19:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recreate
    "reconstruct the form after a snapin or a migration"

    device isNil ifTrue:[^ self].

    data notNil ifTrue:[
        "
         create one from data
        "
        (depth == 1 or:[depth == device depth]) ifTrue:[
            gc createBitmapFromArray:data width:width height:height.
            gc drawableId notNil ifTrue:[
                ^ self
            ]
        ].
        'FORM: cannot recreate form' errorPrintCR.
    ].

    ^ self.

"/    "
"/     create an empty one
"/    "
"/    depth == 1 ifTrue:[
"/        drawableId := device createBitmapWidth:width height:height
"/    ] ifFalse:[
"/        drawableId := device createPixmapWidth:width height:height depth:device depth
"/    ].

    "Modified: 15.6.1996 / 16:18:12 / cg"
!

releaseFromDevice
    "flush device data.
     The sender has to take care that the Form has been
     unregistered from (Finalization-)Lobby"

    self setDevice:nil id:nil gcId:nil
! !


!Form methodsFor:'printing & storing'!

displayOn:aStreamOrGC
    super displayOn:aStreamOrGC.
    aStreamOrGC isStream ifTrue:[
        aStreamOrGC nextPutAll:' (depth='.
        depth printOn:aStreamOrGC.
        aStreamOrGC nextPut:$).
    ].
!

storeOn:aStream
    "append an ascii representation of the receiver to aStream,
     from which a copy of the receiver can be reconstructed"

    aStream nextPutAll:'(Form width:'.
    width storeOn:aStream.
    aStream nextPutAll:' height:'.
    height storeOn:aStream.
    aStream nextPutAll:' fromArray:('.
    self bits storeOn:aStream.
    aStream nextPutAll:'))'

    "Modified: 23.4.1996 / 10:21:10 / cg"
! !

!Form methodsFor:'private'!

beImmediateForm
    "read the pixels from the device into a local data array.
     To make the image smaller (i.e. not keep all those bitmaps),
     this is NOT done by default."

    data isNil ifTrue:[
	data := self bits.
    ]

    "
     Form allInstances:[:f |
	f beImmediateForm
     ]
    "

    "Created: 7.2.1996 / 16:04:18 / cg"
!

flushDeviceHandles
    "flush device handles (sent after a restart)"

    self setDevice:device id:nil gcId:nil.
    gc notNil ifTrue:[
        gc registerChange.
    ].

    "Created: 15.6.1996 / 15:44:28 / cg"
!

getBits
    "if the receiver was not created from a file, or
     an array (i.e. it was drawn), read the pixels from the
     device into a local data array. This has to be done before
     an image is saved, or the receiver is storedBinary, since
     the information present in the device is lost after restart/reload"

    data isNil ifTrue:[
	data := self bits
    ]
!

restored
    "flush device data, when restored (sent after a binaryLoad)"

    self release

    "Modified: 16.9.1996 / 21:08:57 / cg"
!

width:w height:h
    "actual create of a monochrome form"

    ^ self width:w height:h depth:1.
!

width:w height:h depth:d
    "actual create of an arbitrary deep form (but, must be supported by device).
     Return nil (after raising a notification) if the allocation failed"

    ((w == 0) or:[h == 0]) ifTrue:[
        self error:'invalid form extent'.
    ].
    width := w.
    height := h.
    offset := 0@0.
    depth := d.
    depth == 1 ifTrue:[
        localColorMap isNil ifTrue:[
            BlackAndWhiteColorMap isNil ifTrue:[
                BlackAndWhiteColorMap := Array with:(Color white) with:(Color black)
            ].
            localColorMap := BlackAndWhiteColorMap.
        ].
    ].
    device notNil ifTrue:[
        (gc createPixmapWidth:w height:h depth:d) isNil ifTrue:[^nil].
        realized := self drawableId notNil.
    ].
!

width:wIn height:hIn fromArray:anArray
    "actual create of a monochrome form from array.
     This method is somewhat more complicated as it should be due to
     supporting both byte-wise (ST/X-type) and short-word-wise (ST-80-type)
     Arrays; in the later case, the shorts are first converted to bytes in
     a ByteArray, then passed to the device."

    |bytes bits
     srcPerRow "{ Class: SmallInteger }"
     dstPerRow "{ Class: SmallInteger }"
     srcStart  "{ Class: SmallInteger }"
     srcIndex  "{ Class: SmallInteger }"
     dstIndex  "{ Class: SmallInteger }"
     w         "{ Class: SmallInteger }"
     h         "{ Class: SmallInteger }"
     sz        "{ Class: SmallInteger }" |

    w := wIn.
    h := hIn.
    bytes := anArray.
    sz := anArray size.

    sz ~~ (((w + 7) // 8) * h) ifTrue:[
	"/ not bytes ...
	sz == (((w + 15) // 16) * h) ifTrue:[
	    "I want the bytes but got shorts (ST-80)"
	    bytes := ByteArray uninitializedNew:(((w + 7) // 8) * h).
	    srcPerRow := (w + 15) // 16.
	    dstPerRow := (w + 7) // 8.
	    srcStart := 1.
	    dstIndex := 1.

	    1 to:h do:[:hi |
		srcIndex := srcStart.
		bits := anArray at:srcIndex.
		1 to:dstPerRow do:[:di |
		    di odd ifTrue:[
			bits := anArray at:srcIndex.
			bytes at:dstIndex put:(bits bitShift:-8)
		    ] ifFalse:[
			bytes at:dstIndex put:(bits bitAnd:16rFF).
			srcIndex := srcIndex + 1
		    ].
		    dstIndex := dstIndex + 1
		].
		srcStart := srcStart + srcPerRow
	    ]
	] ifFalse:[
	    sz == (((w + 31) // 32) * h) ifTrue:[
		"I want the bytes but got longs (Squeak)"

		bytes := ByteArray uninitializedNew:(((w + 7) // 8) * h).
		srcPerRow := (w + 31) // 32.
		dstPerRow := (w + 7) // 8.
		srcStart := 1.
		dstIndex := 1.

		1 to:h do:[:hi |
		    |ss|

		    srcIndex := srcStart.
		    bits := anArray at:srcIndex.
		    ss := 0.
		    1 to:dstPerRow do:[:di |
			ss == 0 ifTrue:[
			    bits := anArray at:srcIndex.
			].
			bytes at:dstIndex put:((bits bitShift:-24) bitAnd:16rFF).
			bits := bits bitShift:8.
			ss := ss + 1.
			ss == 4 ifTrue:[
			    srcIndex := srcIndex + 1.
			    ss := 0.
			].
			dstIndex := dstIndex + 1
		    ].
		    srcStart := srcStart + srcPerRow
		]
	    ]
	]
    ].
    data := bytes.
    width := w.
    height := h.
    depth := 1.
    offset := 0@0.

    localColorMap isNil ifTrue:[
	BlackAndWhiteColorMap isNil ifTrue:[
	    BlackAndWhiteColorMap := Array with:(Color white) with:(Color black)
	].
	localColorMap := BlackAndWhiteColorMap.
    ].

    device notNil ifTrue:[
	gc createBitmapFromArray:bytes width:w height:h.
	realized := true.
    ].
!

width:w height:h offset:offs fromArray:anArray
    "actual create of a monochrome form from array"

    self width:w height:h fromArray:anArray.
    offset := offs
! !

!Form methodsFor:'queries'!

ascentOn:aGC
    "displayOn: does not draw above baseline"

    ^ 0
!

bounds
    "return my bounds (added to make forms usable as VisualComponents)"

    ^ Rectangle left:0 top:0 width:width height:height

    "Modified: 13.5.1996 / 10:26:13 / cg"
!

colorFromValue:pixel
    "given a pixelValue, return the corresponding color.
     For compatibility with Images"

    localColorMap notNil ifTrue:[
	^ localColorMap at:(pixel + 1)
    ].
    depth == 1 ifTrue:[
	pixel == 0 ifTrue:[^ self whiteColor].
    ].
    ^ self blackColor

    "Created: 28.6.1996 / 16:10:13 / cg"
    "Modified: 13.1.1997 / 23:06:25 / cg"
!

hasBits
    "return true, if the receiver has its pixel data available.
     For forms, which were created from data, this is always true.
     For forms, which were created as off-screen device forms on some
     device, this is always false."

    ^ data notNil

    "Created: 5.7.1996 / 16:21:20 / cg"
!

heightOn:aGC
    "return my height, if displayed on aGC;
     since my height is independent of the device (the number of pixels),
     return the pixel-height"

    ^ height

    "Created: 12.5.1996 / 21:35:33 / cg"
    "Modified: 13.5.1996 / 10:26:09 / cg"
!

isDithered
    "for compatibility with color protocol"

    ^ false
!

isForm
    "return true, if the receiver is some kind of form;
     true is returned here - the method is redefined from Object."

    ^ true
!

isImageOrForm
    "return true, if the receiver is some kind of image or form;
     true is returned here - the method is redefined from Object."

    ^ true
!

widthOn:aGC
    "return my width, if displayed on aGC;
     since my width is independent of the device (the number of pixels),
     return the pixel-width"

    ^ width

    "Created: 12.5.1996 / 21:35:29 / cg"
    "Modified: 13.5.1996 / 10:26:05 / cg"
! !

!Form::ImageForm class methodsFor:'documentation'!

documentation
"
    ImageForm is used for Forms, that have been created from an image and do not
    hold the image bits.

    It does not fetch the image bits when doing a snapshot.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Form::ImageForm methodsFor:'converting'!

asImageForm
    ^ self
! !

!Form::ImageForm methodsFor:'private'!

getBits
    "do nothing. The image, that created the ImageForm, has the bits"

    ^ self
!

recreate
    "nothing to do here. The image recreates the form if needed"

    ^ self
! !

!Form class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Form initialize!
