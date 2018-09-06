"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Smalltalk }"

DeviceGraphicsContext subclass:#CairoGraphicsContext
	instanceVariableNames:'cr'
	classVariableNames:''
	poolDictionaries:'Cairo::FontSlant Cairo::FontWeight Cairo::Format Cairo::Status
		Cairo::Antialias Cairo::Extend'
	category:'Cairo-Compatibility'
!


!CairoGraphicsContext class methodsFor:'instance creation'!

onDeviceGraphicsContext: dGC
    | cGC |

    cGC := self basicNew.
    1 to: DeviceGraphicsContext instSize do:[:i |
        cGC instVarAt: i put: (dGC instVarAt: i).
    ].
    ^ cGC

    "Created: / 15-02-2016 / 21:20:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-07-2018 / 22:52:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext class methodsFor:'accessing'!

dllPath

    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ #( 'C:\Windows' 'C:\Windows\System32' "Wild guess, should not harm" )
    ].

    OperatingSystem isUNIXlike ifTrue:[
        OperatingSystem getSystemType == #linux ifTrue:[
            | path |

            path := #( '/lib' '/usr/lib' '/usr/local/lib' ).
            (OperatingSystem getSystemInfo at:#machine) = 'x86_64' ifTrue:[
                "If the machine is 64bit, prepend standard path for 32bit libs.
                 Leave standard paths at the end, as the system might be completely
                 32bit but running on 64bit-capable CPU.

                CAVEAT: This is bit dangerous, as on 64bit OS, if ia32 libs are
                not installed byt 64bit sqlite libs are, then 64bit libs are found
                and when a function is called, segfault will occur!!

                Q: Is there a way how to figure out if the OS itself is 32bit,
                regardles on CPU?"
                path := #( '/lib32' '/usr/lib32' '/usr/local/lib32' ) , path.
            ].
            ^path

        ].
    ].

    self error:'Unsupported operating system'

    "
        SqliteLibrary dllPath
    "

    "Created: / 31-08-2011 / 18:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libcairo.so.2'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'cairo.dll'].

    self error:'Library name for host OS is not known'
!

sizeof
    "Returns size of undelaying structure in bytes"

    ^0
! !

!CairoGraphicsContext class methodsFor:'examples'!

rectangleOnTranscript

    "
        Cairo::GraphicsContext rectangleOnTranscript
    "


    | gc |
    gc := Transcript cairo.
    gc paint: Color black.
    gc moveToX: 30 y: 50.
    gc paint: (Color red alpha: 0.5).
    gc rectangleX: 10 y: 15 width: 150 height: 60.
    gc fill.
    gc paint: (Color red alpha: 0.75).
    gc rectangleX: 10 y: 15 width: 150 height: 60.
    gc stroke.

    "Created: / 23-04-2009 / 17:33:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'accessing'!

atX:x y:y
    "return the pixel at the coordinate given by x/y"
    cr notNil ifTrue:[ 
        cr surface flush.
    ].
    ^ device getPixelX:x y:y from:drawableId with:gcId

    "Created: / 16-03-2016 / 18:27:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicFont:aFont
    (aFont ~~ font) ifTrue:[     
        super basicFont: aFont.
        font notNil ifTrue:[ 
            font := CairoScaledFont fromFontDescription: font onDevice: device.
            cr notNil ifTrue:[ 
                cr font: font scaledFont.
            ].
        ].
    ].

    "Created: / 16-02-2016 / 15:37:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2016 / 14:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:38:52 / jv"
!

cairo
    "Return a Cairo context for drawing onto this GC" 
    | ncr |

    ncr := Cairo::GraphicsContext onSurface: super cairoSurface.
    ^ ncr.

    "Created: / 31-03-2016 / 00:13:07 / jv"
!

cairoSurface
    cr isNil ifTrue:[ 
        self initCR.
    ].
    cr isNil ifTrue:[ 
        ^ super cairoSurface
    ].
    ^ cr surface

    "Created: / 25-02-2016 / 10:46:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

clippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in logical coordinates);
     a nil argument turn off clipping (i.e. whole view is drawable)"    

    super clippingBounds:aRectangleOrNil.
    cr notNil ifTrue:[ 
        cr clipReset.
        aRectangleOrNil notNil ifTrue:[ 
            cr rectangleX: aRectangleOrNil left
                        y: aRectangleOrNil top
                    width: aRectangleOrNil width
                   height: aRectangleOrNil height.
            cr clip.
        ].
    ].

    "Created: / 15-02-2016 / 21:38:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2016 / 06:58:26 / jv"
    "Modified: / 04-04-2016 / 21:01:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deviceClippingBounds:aRectangleOrNil
    "set the clipping rectangle for drawing (in device coordinates);
     a nil argument turns off clipping (i.e. whole view is drawable - incl. margins)"

    super deviceClippingBounds: aRectangleOrNil.
    self deviceCoordinatesDo:[
        cr notNil ifTrue:[ 
            cr clipReset.
            aRectangleOrNil notNil ifTrue:[
                cr rectangleX: aRectangleOrNil left
                            y: aRectangleOrNil top
                        width: aRectangleOrNil width
                       height: aRectangleOrNil height.
                cr clip.
            ].
        ].
    ].

    "Created: / 27-03-2016 / 00:09:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-04-2016 / 16:42:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

function:aFunctionSymbol
    "set the drawing function"

    #todo.
    ^ super function:aFunctionSymbol

    "Modified: / 27-02-2016 / 15:21:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineWidth: w
    super lineWidth: w. 
    cr notNil ifTrue:[
        cr lineWidth: (w == 0 ifTrue:[ 1 ] ifFalse:[ w ]).
    ].

    "Created: / 17-06-2012 / 21:55:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-02-2016 / 11:29:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mask:aForm
    "set the drawing mask"

    super mask: aForm.
    cr notNil ifTrue:[ 
        self maskSet.
    ].

    "Modified (format): / 08-03-2016 / 21:22:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maskOrigin:aPoint
    "set the origin of the mask-pattern"

    super maskOrigin: aPoint.
    gcId notNil ifTrue:[
        mask notNil ifTrue:[   
            self maskSet.
        ].
    ].

    "Created: / 08-03-2016 / 21:23:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

paint: aColor
    super paint: aColor.
    cr notNil ifTrue:[
        cr source: paint.
    ].

    "Created: / 10-07-2008 / 11:18:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 23-04-2009 / 17:31:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-02-2016 / 22:56:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

paint:fgColor on:bgColor
    "Set the paint and background-paint color.
     The bg-paint is used in opaque-draw operations"

    super paint: fgColor on: bgColor.
    cr notNil ifTrue:[ 
        cr source: paint.        
    ].

    "Created: / 05-03-2016 / 16:35:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

width: width height: height
    cr notNil ifTrue:[
        device isX11Platform ifTrue:[ 
            cr surface width: width height: height 
        ] ifFalse:[ 
            self destroyCR.
        ].
    ].

    "Created: / 02-04-2016 / 15:37:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-04-2016 / 15:55:29 / jv"
! !

!CairoGraphicsContext methodsFor:'accessing-internals'!

foreground:aColor
    <resource: #obsolete>
    "set the internal foreground color for drawing - aColor must be a real color.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    (aColor ~~ foreground) ifTrue:[
        aColor notNil ifTrue:[
            super foreground:aColor.
            cr notNil ifTrue:[ 
                cr source: paint.
            ].
        ]
    ]

    "Created: / 05-04-2016 / 16:59:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foreground:fgColor background:bgColor
    <resource: #obsolete>
    "set both internal foreground and internal background colors
     - these must be real colors.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    ((fgColor ~~ foreground) or:[bgColor ~~ background]) ifTrue:[
        super foreground:fgColor background:bgColor.
        cr notNil ifTrue:[ 
            cr source: paint.
        ].  
    ]

    "Created: / 05-04-2016 / 17:00:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foreground:aColor function:fun
    <resource: #obsolete>
    "set the foreground color and function for drawing.
     OBSOLETE: this method will vanish; use #paint: / #paint:on:"

    ((aColor ~~ foreground) or:[fun ~~ function]) ifTrue:[
        super foreground:aColor function:fun.
        cr notNil ifTrue:[ 
            cr source: paint.
        ].
    ]

    "Created: / 05-04-2016 / 17:01:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'accessing-transformation'!

transformation:aTransformation 
    "set the transformation"

    super transformation: aTransformation.
    cr notNil ifTrue:[
        cr matrixReset.
        transformation notNil ifTrue:[ 
            cr
                scale: transformation scale;
                translate: transformation translation.
        ]
    ]

    "Created: / 01-01-2015 / 12:07:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2016 / 22:26:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'basic drawing'!

displayArcX:x y:y width:w height:h from:start angle:angle
    | angle1 angle2 |

    cr isNil ifTrue:[ 
        self initCR.
    ]. 
    cr save.  
    [
        w ~~ h ifTrue:[
            self notYetImplemented
        ].

        angle1 := (360 - start) .
        angle2 := (360 - (start + angle)) \\ 360.

        (angle2 < angle1) ifTrue:[
            cr arcNegativeX: (x + (w / 2)) y: (y + (h / 2)) radius: w / 2 from: angle1 * (Float pi / 180) to: angle2 * (Float pi / 180).
        ] ifFalse:[ 
            cr arcNegativeX: (x + (w / 2)) y: (y + (h / 2)) radius: w / 2 from: angle2 * (Float pi / 180) to: angle1 * (Float pi / 180).
        ].
        cr stroke.

        w ~~ h ifTrue:[
            self notYetImplemented
        ].
    ] ensure:[ 
        cr restore.
    ]

    "Modified: / 13-02-2016 / 20:05:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:34:08 / jv"
!

displayLineFromX:x0 y:y0 toX:x1 y:y1
    "draw a line from x0/y0 to x1/y1"
    cr isNil ifTrue:[ 
        self initCR.
    ].
    x0 = x1 ifTrue:[
        cr moveToX: x0 + 0.5 y: y0.
        cr lineToX: x1 + 0.5 y: y1.
    ] ifFalse:[ 
        y0 = y1 ifTrue:[ 
            cr moveToX: x0 y: y0 + 0.5.
            cr lineToX: x1 y: y1 + 0.5.
        ] ifFalse:[ 
            cr moveToX: x0 y: y0.
            cr lineToX: x1 y: y1.

        ].
    ].
    cr stroke.

    "Modified: / 21-02-2016 / 15:24:52 / jv"
    "Modified: / 16-03-2016 / 22:40:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayPolygon:points
    "draw a polygon
     - this could be recoded to draw using displayLine"

    cr isNil ifTrue:[ 
        self initCR.
    ]. 
    cr moveToX: points first x asFloat y: points first y asFloat.
    2 to: points size do:[:i |  
        cr lineToX: (points at: i) x asFloat  y: (points at: i) y asFloat
    ].
    cr closePath.
    cr stroke.

    "Modified: / 13-02-2016 / 20:04:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:34:19 / jv"
!

displayRectangleX:x y:y width:w height:h
    "draw a rectangle
     - this could be recoded to draw using displayLine"

    cr isNil ifTrue:[ 
        self initCR.
    ]. 
    (w > 0 and:[h > 0]) ifTrue:[
        cr rectangleX: x + 0.5 y: y + 0.5 width: w - 0.5 height: h - 0.5.
        cr stroke.
    ]

    "Modified: / 21-02-2016 / 15:34:34 / jv"
    "Modified: / 16-03-2016 / 22:42:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayString:string from:index1 to:index2 x:x y:y opaque:opaqueArg maxWidth:maxWidth
    "draw a substring at the coordinate x/y - draw foreground pixels in
     paint-color and (if opaque is true), background pixels in bgPaint-color.
     If the transformation involves scaling, the font's point-size is scaled as appropriate.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors.
     maxWidth is the maximum width of the string in pixels or nil if unknown."    

    | opaque |
    "
     if backgroundPaint color is nil, we assume
     this is a non-opaque draw
    "
    opaque := opaqueArg ? false.
    bgPaint isNil ifTrue:[
        opaque := false.
    ].

    cr isNil ifTrue:[
        self initGC
    ]. 

    (string isString not or:[string isText]) ifTrue:[
        "
         hook for non-strings (i.e. attributed text)
         that 'thing' should know how to display itself ...
        "
        string displayOn:self x:x y:y from:index1 to:index2 opaque:opaque.
        ^ self
    ].   

    font class == CairoScaledFont ifTrue:[ 
        font displayString:string from:index1 to:index2 x:x y:y cr:cr fg: paint bg: bgPaint opaque:opaque
    ] ifFalse:[ 
        Logger warning:'Drawing text using non-Cairo font (%1 )on CairoGraphicsContext' with: font class name.
        cr surface flush.
        super displayString:string from:index1 to:index2 x:x y:y opaque:opaqueArg maxWidth:maxWidth.
        cr surface markDirty.
    ].

    "Created: / 16-02-2016 / 10:51:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-02-2016 / 21:04:49 / jv"
    "Modified: / 24-02-2016 / 17:14:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'basic filling'!

fillArcX:x y:y width:w height:h from:start angle:angle
    | angle1 angle2 |

    cr isNil ifTrue:[ 
        self initCR.
    ].
    cr save. 
    [
        w ~~ h ifTrue:[
            self notYetImplemented
        ].


        angle1 := (360 - start) .
        angle2 := (360 - (start + angle)) \\ 360.

        cr moveToX: (x + (w / 2)) y: (y + (h / 2)).

        (angle2 < angle1) ifTrue:[
            cr arcNegativeX: (x + (w / 2)) y: (y + (h / 2)) radius: w / 2 from: angle1 * (Float pi / 180) to: angle2 * (Float pi / 180).
        ] ifFalse:[ 
            cr arcNegativeX: (x + (w / 2)) y: (y + (h / 2)) radius: w / 2 from: angle2 * (Float pi / 180) to: angle1 * (Float pi / 180).
        ].
        cr closePath.

        cr strokeAndPreserve.
        cr fill.

        w ~~ h ifTrue:[
            self notYetImplemented        
        ].
    ] ensure:[ 
        cr restore.
    ]

    "Modified: / 13-02-2016 / 20:03:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:34:47 / jv"
!

fillPolygon:points
    "fill a polygon with current paint color"

    cr isNil ifTrue:[ 
        self initCR.
    ].
    cr moveToX: points first x asFloat y: points first y asFloat.
    2 to: points size do:[:i |  
        cr lineToX: (points at: i) x asFloat  y: (points at: i) y asFloat
    ].
    cr closePath.
    cr strokeAndPreserve.
    cr fill.

    "Modified: / 13-02-2016 / 20:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:34:52 / jv"
!

fillRectangleX:x y:y width:w height:h
    "fill a rectangle with current paint color"

    cr isNil ifTrue:[ 
        self initCR.
    ].
    (w > 0 and:[h > 0]) ifTrue:[
        | savedWidth |

        savedWidth := cr lineWidth.
        cr lineWidth: 1.  
        cr rectangleX: x + 0.5 y: y + 0.5 width: w - 0.5 height: h - 0.5.
        cr strokeAndPreserve.
        cr lineWidth: savedWidth.  
        cr fill.
    ].

"/    cr save.
"/    cr rectangleX: x y: y width: w height: h. 
"/    cr sourceR: 1 G: 0 B: 0.
"/    cr lineWidth: 1.  
"/    cr stroke.
"/    cr restore.

    "Modified: / 21-02-2016 / 15:34:56 / jv"
    "Modified: / 05-04-2016 / 21:55:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'bit blitting'!

copyBitsFrom:aByteArray bitsPerPixel:bpp depth:depth padding:pad width:srcW height:srcH x:srcX y:srcY toX:dstX y:dstY
    "copy bits from a smalltalk byteArray.
     The bits found there are supposed to be in the devices native format (i.e.
     translated to allocated color indices on pseudoColor devices and padded as required.
     The byteOrder is MSB and will be converted as appropriate by the underlying devices
     method to whatever the device needs."

    cr notNil ifTrue:[ 
        cr surface flush
    ].
    super copyBitsFrom:aByteArray bitsPerPixel:bpp depth:depth padding:pad width:srcW height:srcH x:srcX y:srcY toX:dstX y:dstY.
    cr notNil ifTrue:[ 
        cr surface markDirty
    ].

    "Created: / 18-02-2016 / 20:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2016 / 18:19:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

copyFrom:aDrawable x:srcX y:srcY toX:dstX y:dstY width:w height:h async:async
    "copy from aDrawable into the receiver;
     the source may be the receiver as well - in this case its a scroll.
     All coordinates are in device coordinates.
     If the receiver is a view AND async is true, the call returns immediately
     - otherwise, it returns when the scroll operation is finished.
     (not all devices care for this).
     If the receiver is a pixmap, the call always returns immediately."

    cr notNil ifTrue:[ 
        cr surface flush
    ].
    super copyFrom:aDrawable x:srcX y:srcY toX:dstX y:dstY width:w height:h async:async.
    cr notNil ifTrue:[ 
        cr surface markDirty
    ].

    "Created: / 18-02-2016 / 20:17:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2016 / 18:19:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

copyPlaneFrom:aDrawable x:srcX y:srcY toX:dstX y:dstY width:w height:h
    "copy one plane from aDrawable into the receiver. 0's are drawn in
     background, while 1's are drawn with foreground color.
     The depth of aDrawable must (should) be 1.
     The drawable must have been allocated on the same device.
     All coordinates are in device coordinates."

    cr notNil ifTrue:[ 
        cr surface flush
    ].
    super copyPlaneFrom:aDrawable x:srcX y:srcY toX:dstX y:dstY width:w height:h.
    cr notNil ifTrue:[ 
        cr surface markDirty
    ].

    "Created: / 18-02-2016 / 20:17:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 21-02-2016 / 15:35:11 / jv"
    "Modified: / 24-02-2016 / 18:19:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'change & update'!

update: aspect with: param from: sender
    aspect == #sizeOfView  ifTrue:[
        self updateCR.
        ^ self.
    ].
    super update: aspect with: param from: sender

    "Created: / 29-03-2016 / 23:00:56 / jv"
!

updateCR
    "Called when view associated with given context
     changes its size"

    cr notNil ifTrue:[        
        device isWindowsPlatform ifTrue:[ 
            | surface blocked |

            blocked := OperatingSystem blockInterrupts.

            surface := cr surface.
            cr release.
            surface release.
            device dcUnlockForGC: gcId.
            cr := nil.
            blocked ifFalse:[
                OperatingSystem unblockInterrupts.
            ]
        ]].

    "Created: / 29-03-2016 / 22:58:49 / jv"
    "Modified: / 31-03-2016 / 00:39:48 / jv"
    "Modified: / 02-04-2016 / 15:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'drawing'!

displayForm:aFormOrImage x:x y:y
    "draw a form (or image) at x/y; 
     if the form has depth 1, 1's in the form are
     drawn in current paint color, 0's are ignored.
     If the form has depth ~~ 1, the current fg color setting is ignored."

    | image width height imageSurface |

    image := aFormOrImage asImage.
    (image mask isNil or:[ image mask depth == 1 ]) ifTrue:[ 
        cr notNil ifTrue:[ 
            cr surface flush.
        ].
        super displayForm:aFormOrImage x:x y:y.
        cr notNil ifTrue:[ 
            cr surface markDirty.
        ].
        ^ self.
    ].
    width := image width.
    height := image height.
    imageSurface := Cairo::Surface newImageWithFormat: CAIRO_FORMAT_ARGB32  width: width height: height similarTo: cr surface.
    [
        image bitsARGB32Into: imageSurface data startingAt: 1 stride: imageSurface stride.
        imageSurface markDirty.
        cr isNil ifTrue:[ 
            self initCR.
        ].

        cr sourceSurface: imageSurface x: x y: y.
        cr paint.
    ] ensure:[ 
        imageSurface release.
    ].

    "Created: / 31-12-2014 / 12:08:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2016 / 19:16:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayLineFrom:p0 to:p1
    "draw a line (with current paint-color); apply transformation if nonNil"

    ^ self displayLineFromX: p0 x y: p0 y toX: p1 x y: p1 y

    "Created: / 18-02-2016 / 20:27:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayLineFromX:xStart y:yStart toX:xEnd y:yEnd brush:aForm
    "draw a line using a brush.
     Here, a slow fallback is used, drawing into a 
     temporary bitmap first, which is then displayed"

    cr notNil ifTrue:[ 
        cr surface flush
    ].
    super displayLineFromX:xStart y:yStart toX:xEnd y:yEnd brush:aForm.
    cr notNil ifTrue:[ 
        cr surface markDirty
    ].

    "Created: / 18-02-2016 / 20:28:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2016 / 18:19:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayRoundRectangleX:x y:y width:w height:h wCorner:wCorn hCorner:hCorn
    | r pi |

    cr isNil ifTrue:[ 
        self initCR.
    ].
    wCorn ~~ hCorn ifTrue:[ 
        self notYetImplemented.
    ].
    r := wCorn / 2.
    pi := Float pi.

    "/ top-left arc
    cr arcX: x + r     y: y + r     radius: r from:         pi to: (3/2) * pi.
    "/ top-right atc
    cr arcX: x + w - r y: y + r     radius: r from: (3/2) * pi to: 0.0.
    "/ bottom-right atc
    cr arcX: x + w - r y: y + h - r radius: r from: 0.0        to: (1/2) * pi.
    "/ bottom-left atc
    cr arcX: x + r     y: y + h - r radius: r from: (1/2) * pi to:         pi.
    cr closePath.
    cr stroke.
    
    "
     |v|

     (v := View new) extent:200@200; openAndWait.
     v cairo 
            lineWidth: 5;
            displayRoundRectangleX:10 y:10 width:100 height:100 wCorner:20 hCorner:20;
            release
    "

    "Created: / 07-01-2015 / 20:41:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2016 / 20:00:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-02-2016 / 15:35:35 / jv"
! !

!CairoGraphicsContext methodsFor:'drawing in device coordinates'!

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

    cr notNil ifTrue:[ 
        cr surface flush.
    ].
    super displayDeviceForm:aForm x:x y:y.
    cr notNil ifTrue:[ 
        cr surface markDirty.
    ].

    "Created: / 26-02-2016 / 10:47:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayDeviceLineFromX:x0 y:y0 toX:x1 y:y1
    "draw a line (with current paint-color) in device coordinate space.
     This ignores any transformations. The coordinates must be integers."

    self deviceCoordinatesDo:[ 
        self displayLineFromX:x0 y:y0 toX:x1 y:y1
    ].

    "Created: / 26-02-2016 / 10:32:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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

    cr notNil ifTrue:[ 
        cr surface flush.
    ].
    super displayDeviceOpaqueForm:aForm x:x y:y.
    cr notNil ifTrue:[ 
        cr surface markDirty.
    ].

    "Created: / 26-02-2016 / 10:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayDeviceOpaqueString:aString from:index1 to:index2 in:fontToUse x:x y:y
    "draw a substring at the coordinate x/y - draw foreground pixels in
     paint-color and background pixels in bgPaint-color.
     Assuming that device can only draw in device colors, we have to handle
     the case where paint and/or bgPaint are dithered colors.
     No translation or scaling is done."

    | savedFont |

    "
     if backgroundPaint color is nil, we assume
     this is a non-opaque draw
    "
    bgPaint isNil ifTrue:[
        self displayDeviceString:aString from:index1 to:index2 x:x y:y.
        ^ self
    ].

    aString isPlainString ifFalse:[
        "
         hook for non-strings (i.e. attributed text)
         that 'thing' should know how to display itself ...
        "
        aString displayOpaqueOn:self x:x y:y from:index1 to:index2.
        ^ self
    ].

    self deviceCoordinatesDo:[
        savedFont := self font.
        [  
            self font:fontToUse.
            self displayOpaqueString:aString from:index1 to:index2 x:x y:y
        ] ensure:[ 
            self font: savedFont
        ].
    ]

    "Created: / 26-02-2016 / 10:44:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayDeviceString:aString from:index1 to:index2 in:fontToUse x:x y:y
    "draw a substring at the coordinate x/y -
     draw foreground-pixels only (in current paint-color), leaving background as-is.
     No translation or scaling is done"

    | savedFont |

    "
     hook for non-strings (i.e. attributed text)
    "
    aString isPlainString ifFalse:[
        ^ aString displayOn:self x:x y:y from:index1 to:index2
    ].

    self deviceCoordinatesDo:[
        savedFont := self font.
        [  
            self font:fontToUse.
            self displayString:aString from:index1 to:index2 x:x y:y
        ] ensure:[ 
            self font: savedFont
        ].
    ]

    "Created: / 26-02-2016 / 10:45:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fillDeviceRectangleX:x y:y width:w height:h
    "draw a filled rectangle in device coordinate space.
     This ignores any transformations. The coordinates must be integers."

    self deviceCoordinatesDo:[ 
        self fillRectangleX:x y:y width:w height:h
    ].

    "Created: / 26-02-2016 / 10:29:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'filling'!

fillRoundRectangleX:x y:y width:w height:h wCorner:wCorn hCorner:hCorn
    | r pi |

    cr isNil ifTrue:[ 
        self initCR.
    ].
    wCorn ~~ hCorn ifTrue:[ 
        self notYetImplemented.
    ].
    r := wCorn / 2.
    pi := Float pi.

    "/ top-left arc
    cr arcX: x + r     y: y + r     radius: r from:         pi to: (3/2) * pi.
    "/ top-right atc
    cr arcX: x + w - r y: y + r     radius: r from: (3/2) * pi to: 0.0.
    "/ bottom-right atc
    cr arcX: x + w - r y: y + h - r radius: r from: 0.0        to: (1/2) * pi.
    "/ bottom-left atc
    cr arcX: x + r     y: y + h - r radius: r from: (1/2) * pi to:         pi.
    cr closePath.
    cr fill.
    
    "
     |v|

     (v := View new) extent:200@200; openAndWait.
     v cairoify 
            lineWidth: 5;
            displayRoundRectangleX:10 y:10 width:100 height:100 wCorner:20 hCorner:20.
    "

    "Created: / 07-01-2015 / 21:33:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2016 / 20:00:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 21-02-2016 / 15:58:59 / jv"
! !

!CairoGraphicsContext methodsFor:'finalization'!

executor
    ^ CairoGraphicsContextHandle basicNew setDeviceHandle: super executor cairo: cr

    "Created: / 12-02-2016 / 17:04:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 19:44:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'initialization & release'!

createCR
    "Physically create a Cairo graphics context"

    cr := self cairo.

    "Created: / 12-02-2016 / 16:59:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 22:53:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createGC
    "physically create a device GC.
     Since we do not need a gc-object for the drawable until something is
     really drawn, none is created up to the first draw.
     This method is sent, when the first drawing happens"      

    "/ Here, we cannot simply do
    "/ 
    "/   super createGC.
    "/   self createCR.
    "/ 
    "/ As we need to tell the finalization lobby to register change
    "/ after we create Cairo context. Of course, we could just call
    "/ 
    "/   device registerGraphicsContext: self
    "/ 
    "/ in createCR, but then we'd call it twice which is not what we want.
    "/ Therefore this ugly code duplication...sigh.

    drawableType == #window ifTrue:[
        gcId := device gcFor:drawableId.
    ] ifFalse:[
        gcId := device gcForBitmap:drawableId.
    ].
    self createCR.
    device registerGraphicsContext: self

    "Created: / 12-02-2016 / 16:58:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-07-2018 / 22:46:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

destroyCR
    "Tell Cairo library to destroy the corresponding C object.
     Remember that object is physically destroyed only if internal
     refcounter goes to zero. However, after calling destroy,
     this instance should be treated as invalid."

    cr notNil ifTrue:[
        | wasBlocked surfaceToDestroy crToDestroy |

        wasBlocked := OperatingSystem unblockInterrupts.

        crToDestroy := cr.
        surfaceToDestroy := cr surface.
        cr := nil.
        crToDestroy release.
        surfaceToDestroy release.
        device isWindowsPlatform ifTrue:[
            device dcUnlockForGC: gcId.
        ].
        wasBlocked ifFalse:[
            OperatingSystem unblockInterrupts.
        ]    
    ].

    "Created: / 12-02-2016 / 16:59:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 02-04-2016 / 16:07:22 / jv"
    "Modified: / 04-04-2016 / 18:45:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

destroyGC
    drawableId notNil ifTrue:[
        Logger debug: 'Destroying GC/CR for drawable %1' with: drawableId.
    ].
    self destroyCR.
    super destroyGC

    "Created: / 12-02-2016 / 17:01:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2016 / 23:52:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initCR
    | view f |

    gcId isNil ifTrue:[ 
        self initGC.
    ].
    cr isNil ifTrue:[ 
        self createCR.
        "/ Need to re-register for we need a new executor
        "/ with Cairo graphics context.
        device graphicsContexts registerChange:self.  
    ].
    device isWindowsPlatform ifTrue:[
        view := cr surface view.
        view notNil ifTrue:[ 
            view addDependent: self.
            view container notNil ifTrue:[ 
                view container addDependent: self.
            ].
        ].
    ].

    cr antialias: CAIRO_ANTIALIAS_NONE.
    cr lineWidth: (lineWidth == 0 ifTrue:[ 1 ] ifFalse:[ lineWidth ]).
    cr source: paint.
    cr matrixReset.
    self transformation: transformation.
    self clippingBounds: clipRect.
    f := font.
    font := nil.
    self basicFont: f.

    "Created: / 18-02-2016 / 22:48:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-03-2016 / 23:57:30 / jv"
    "Modified: / 17-07-2018 / 19:48:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releaseCR
    self destroyCR

    "Created: / 12-02-2016 / 17:02:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

releaseGC
    "destroy the associated device GC resource - can be done to be nice to the
     display if you know that you are done with a drawable."

    [
        self releaseCR.
        super releaseGC.
    ] valueUninterruptably

    "Created: / 12-02-2016 / 17:03:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 22:29:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CairoGraphicsContext methodsFor:'private'!

deviceCoordinatesDo: aBlock
    "Evaluate a block using device coordinates (device 
     space using Cairo terminology)"

    | savedTransformation |

    savedTransformation := transformation.
    self transformation: nil.
    aBlock ensure:[ self transformation: savedTransformation ].

    "Created: / 26-02-2016 / 09:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

maskSet
    "Either mask or markOrigin changed. Update Cairo's source pattern"

    | maskImage w h maskSurface maskPattern sourceSurface sourceContext sourcePattern |

    mask isNil ifTrue:[ 
        cr source: paint.
        ^ self.
    ].

    maskImage := mask asImage.
    w := maskImage width.
    h := maskImage height.
    [
        sourceSurface := Cairo::Surface newImageWithFormat: CAIRO_FORMAT_ARGB32 width: w height: h similarTo: cr surface.
        maskImage depth == 1 ifTrue:[
            maskSurface := maskImage asSurfaceWithFormat: CAIRO_FORMAT_A1 similarTo: sourceSurface.
            maskPattern := Cairo::Pattern surface: maskSurface.
            maskPattern extend: CAIRO_EXTEND_REPEAT.
        ] ifFalse:[ 
            self error: 'Not yet supported'
        ].
        sourceContext := sourceSurface cairo.
        maskOrigin notNil ifTrue:[ 
            maskPattern matrix: (Cairo::Matrix translate: maskOrigin negated).
        ].
        sourceContext source: cr source.               
        sourceContext mask: maskPattern.
    ] ensure:[
        sourceContext notNil ifTrue:[sourceContext release].
        maskPattern notNil ifTrue:[maskPattern release].
        maskSurface notNil ifTrue:[maskSurface release].
    ].
    sourcePattern := Cairo::Pattern surface: sourceSurface.
    sourcePattern extend: CAIRO_EXTEND_REPEAT.
    cr source: sourcePattern.

    "Created: / 08-03-2016 / 21:21:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subViewChangedSizeOrOrigin
    "Internal. Called whenever one of the owner's
     subview changes size or origin (i.e., when moved)    
     See SimpleView>>pixelOrigin:extent:.
     Can be used to adjust internal state."

    device isX11Platform ifFalse:[ 
        self destroyGC.
    ].
    "/ Nothing by default

    "Created: / 02-04-2016 / 16:04:55 / jv"
! !

!CairoGraphicsContext class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

