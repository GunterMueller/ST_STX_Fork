"{ Package: 'stx:goodies/libcairo' }"!

!Depth1Image methodsFor:'accessing'!

bitsA1
    | bitsA1 |

    bitsA1 := ByteArray new: ((width + 31) // 32) * 4 * height.
    self bitsA1Into: bitsA1.
    ^ bitsA1

    "Created: / 07-03-2016 / 17:57:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Depth1Image methodsFor:'accessing'!

bitsA1Into: buffer
    self bitsA1Into: buffer startingAt: 1

    "Created: / 07-03-2016 / 17:57:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Depth1Image methodsFor:'accessing'!

bitsA1Into: buffer startingAt: first
    self bitsA1Into: buffer startingAt: first stride: ((width + 31) // 32) * 4

    "Created: / 07-03-2016 / 18:02:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2016 / 20:08:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Depth1Image methodsFor:'accessing'!

bitsA1Into: buffer startingAt: first stride: stride
    "Store each pixel is a 1-bit quantity holding an alpha value. Pixels are 
     packed together into 32-bit quantities. The ordering of the bits matches 
     the endianess of the platform. On a big-endian machine, the first pixel 
     is in the uppermost bit, on a little-endian machine the first pixel is 
     in the least-significant bit.
    "
    | widthInBytes baseInBuffer baseInPixelStore reverseBits  |

    widthInBytes := (width + 7) // 8.
    ExternalBytes isBigEndian ifTrue:[
        self breakPoint: #jv. "/ Untested code
        0 to: height - 1 do:[:y | 
            baseInBuffer := (stride * y) + first.
            baseInPixelStore  := (widthInBytes * y) + 1.
            buffer replaceBytesFrom: baseInBuffer to: baseInBuffer + widthInBytes - 1 with: bytes startingAt: baseInPixelStore.
        ].
    ] ifFalse:[ 
        reverseBits := ImageReader reverseBits.    
        "/reverseBits := (0 to: 255) asArray.

        0 to: height - 1 do:[:y |  
            | x4 |

            baseInBuffer := (stride * y) + first.
            baseInPixelStore  := (widthInBytes * y) + 1.

            x4 := 0.
            [ x4 < widthInBytes ] whileTrue:[ 
                                               buffer at: baseInBuffer + x4 + "3"0 put: (reverseBits at: (bytes at: baseInPixelStore + x4 + 0) + 1).
                x4 + 1 < widthInBytes ifTrue:[ buffer at: baseInBuffer + x4 + "2"1 put: (reverseBits at: (bytes at: baseInPixelStore + x4 + 1) + 1) ].
                x4 + 2 < widthInBytes ifTrue:[ buffer at: baseInBuffer + x4 + "1"2 put: (reverseBits at: (bytes at: baseInPixelStore + x4 + 2) + 1) ].
                x4 + 3 < widthInBytes ifTrue:[ buffer at: baseInBuffer + x4 + "0"3 put: (reverseBits at: (bytes at: baseInPixelStore + x4 + 3) + 1) ].
                x4 := x4 + 4.
            ].
        ]
    ]
.
    "
    (ImageMask width: 3 height: 3)
        createPixelStore;
        pixelAtX: 0 y:0 put: 1;
        pixelAtX: 2 y:0 put: 1;
        bitsA1.

    "

    "Created: / 07-03-2016 / 18:03:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 08-03-2016 / 14:13:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DeviceGraphicsContext methodsFor:'accessing'!

cairo
    "Return a Cairo context for drawing onto this GC" 
    | cr |

    cr := Cairo::GraphicsContext onSurface: self cairoSurface.
    ^ cr.

    "Created: / 26-12-2014 / 23:28:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2016 / 11:05:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DeviceGraphicsContext methodsFor:'accessing'!

cairoSurface
    | surface |

    device isX11Platform ifTrue:[ 
        | view width height |

        drawableType == #window ifTrue:[
            view := device viewFromId:drawableId.
            width := view width.
            height := view height.
        ] ifFalse:[ 
            | extent |

            extent := (device getGeometryOf: drawableId) at: #extent.
            width := extent x.
            height := extent y.
        ].

        surface := Cairo::Surface newXlibWithDisplay: device displayId
                                            drawable: drawableId address
                                              visual: device queryDefaultVisual
                                               width: width
                                              height: height.  
        surface setView: view.
        ^ surface
    ].
    device isWindowsPlatform ifTrue:[ 
        | view |

        drawableType == #window ifTrue:[
            view := device viewFromId:drawableId.
        ].
        gcId isNil ifTrue:[ 
            self initGC
        ].
        surface := Cairo::Surface newWin32WithDC: (device dcLockForGC: gcId).
        surface setView: view.
        ^ surface
    ].
    self error: '(Yet) unsupported device type'

    "Modified: / 25-02-2016 / 11:13:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 29-03-2016 / 23:56:46 / jv"
! !

!GraphicsContext methodsFor:'drawing in device coordinates'!

displayDeviceLineFromX:x1 y:y1 toX:x2 y:y2
    "draw a line in device coordinates"

    |sav|

    sav := transformation.
    self transformation: nil.
    self displayLineFromX:x1 y:y1 toX:x2 y:y2.
    self transformation: sav

    "Created: / 01-01-2015 / 22:50:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContext methodsFor:'drawing in device coordinates'!

displayDeviceRectangleX:x y:y width:w height:h
    "draw a rectangle in device coordinates"

    |sav|

    sav := transformation.
    self transformation: nil.
    self displayRectangleX:x y:y width:w height:h.
    self transformation: sav

    "Created: / 01-01-2015 / 22:51:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContext methodsFor:'drawing in device coordinates'!

fillDeviceRectangleX:x y:y width:w height:h
    "fill a rectangle with current paint color (device coordinates)"

    |sav|

    sav := transformation.
    self transformation: nil.
    self fillRectangleX:x y:y width:w height:h.
    self transformation: sav

    "Created: / 01-01-2015 / 22:51:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsDevice methodsFor:'cairo support'!

cairoSurfaceFor: view

    self error:'Graphics device not supported'

    "Created: / 10-07-2008 / 10:16:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!GraphicsDevice methodsFor:'accessing'!

displayId
    ^ displayId

    "Created: / 04-07-2008 / 12:58:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!GraphicsMedium methodsFor:'misc'!

cairoify
    "Change to use Cairo for rendering"
    gc class == CairoGraphicsContext ifFalse:[
        gc device unregisterGraphicsContext: gc.  
        gc := CairoGraphicsContext onDeviceGraphicsContext:gc.
        gc device registerGraphicsContext: gc.
    ].

    "Created: / 15-02-2016 / 21:24:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 22:55:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Image methodsFor:'converting'!

asSurfaceWithFormat: format similarTo: surface
    "Returns the receiver as Cairo::Surface (image) with given `format`. If `surface` is not
     nil, then the new surface is made as compatible as possible for uploading to 
     and the use in conjunction with an `surface`.

     CAVEAT: For now, only ARB32 and A1 formats are supported
    "

    | image |

    surface notNil ifTrue:[
        image := Cairo::Surface newImageWithFormat: format  width: width height: height similarTo: surface.   
    ] ifFalse:[ 
        image := Cairo::Surface newImageWithFormat: format  width: width height: height.
    ].
    format == Cairo::Format CAIRO_FORMAT_ARGB32 ifTrue:[ 
        self bitsARGB32Into: image data startingAt: 1 stride: image stride 
    ] ifFalse:[ 
        format == Cairo::Format CAIRO_FORMAT_A1 ifTrue:[ 
            self bitsA1Into: image data startingAt: 1 stride: image stride.
        ] ifFalse:[ 
            self error: 'Unsupported format'.
            ^ nil.    
        ].
    ].
    " 
    image data asByteArray
    "  
    image markDirty.         
    ^ image

    "Created: / 07-03-2016 / 21:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 08-03-2016 / 14:13:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Image methodsFor:'inspecting'!

inspector2TabImageCairo
    <inspector2Tab>

    | view |

    view := PluggableView new.
    view cairoify.
    view redrawAction:[ self displayOn: view ].
    ^self newInspector2Tab
        label: 'Image (Cairo)';
        priority: 49;
        view: (HVScrollableView forView: view);
        yourself

    "Created: / 31-12-2014 / 12:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2016 / 22:25:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'accessing - cairo'!

cairo
    "Return a Cairo context for drawing onto this view"           
    ^ gc cairo

    "Created: / 10-09-2008 / 18:23:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (comment): / 26-12-2014 / 23:29:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'accessing - cairo'!

cairoSurface
    "Return a Cairo Surface representing the receiver."
    ^ gc cairoSurface

    "Created: / 26-02-2016 / 22:24:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'misc'!

cairoify
    super cairoify.
    self subViews do:[:each | each cairoify ].
    self invalidate.

    "Created: / 18-02-2016 / 22:43:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2016 / 11:12:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'redrawing - cairo'!

redrawWithCairo
    | cr |

    cr := self cairo.
    [  
        self redrawWithCairo: cr
    ] ensure:[
        cr ~~ gc ifTrue:[ cr release ].
    ].

    "Created: / 27-12-2014 / 00:30:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2016 / 16:38:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'redrawing - cairo'!

redrawWithCairo: cr x: x y: y width: w height: h
    cr rectangleX: x  y: y width: w height: h. 
    cr clip.
    self redrawWithCairo: cr

    "Created: / 27-12-2014 / 00:29:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'redrawing - cairo'!

redrawWithCairoBuffered
    | cr |

    cr := self cairo.
    [  
        self redrawWithCairoBuffered: cr
    ] ensure:[ 
        cr ~~ gc ifTrue:[ cr release ].
    ].

    "Created: / 27-12-2014 / 00:30:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2016 / 16:38:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'redrawing - cairo'!

redrawWithCairoBuffered: view_cr

    | image_surface image_cr |

    [     
        image_surface := Cairo::Surface newImageWithFormat: Cairo::Format CAIRO_FORMAT_ARGB32 width:self width
                               height:self height.
        image_cr := Cairo::GraphicsContext onSurface: image_surface. 
        self redrawWithCairo: image_cr.  
        view_cr sourceSurface: image_surface x: 0 y: 0.
        view_cr draw.
    ] ensure:[ 
        image_surface notNil ifTrue:[ image_surface release ].
        image_cr notNil ifTrue:[ image_cr release ]
    ].

    "Created: / 27-12-2014 / 00:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2016 / 16:01:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'redrawing - cairo'!

redrawWithCairoBuffered: view_cr x: x y: y width: w height: h

    | image_surface image_cr |

    [     
        image_surface := Cairo::Surface newImageWithFormat: Cairo::Format CAIRO_FORMAT_ARGB32 width:self width
                               height:self height.
        image_cr := Cairo::GraphicsContext onSurface: image_surface. 
        image_cr rectangleX: x  y: y width: w height: h. 
        image_cr clip.
        self redrawWithCairo: image_cr x: x y: y width: w height: h.
        view_cr rectangleX: x  y: y width: w height: h. 
        view_cr clip.
        view_cr setSourceSurface: image_surface. 
        view_cr paint.
    ] ensure:[ 
        image_surface notNil ifTrue:[ image_surface release ].
        image_cr notNil ifTrue:[ image_cr release ]
    ].

    "Created: / 27-12-2014 / 00:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2016 / 16:01:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'redrawing - cairo'!

redrawWithCairoBufferedX: x y: y width: w height: h     
    | cr |

    cr := self cairo.
    [  
        self redrawWithCairoBuffered: cr x: x y: y width: w height: h     
    ] ensure:[ 
        cr ~~ gc ifTrue:[ cr release ].
    ].

    "Created: / 27-12-2014 / 00:31:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2016 / 16:38:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'redrawing - cairo'!

redrawWithCairoX: x y: y width: w height: h     
    | cr |

    cr := self cairo.
    [  
        self redrawWithCairo: cr x: x y: y width: w height: h     
    ] ensure:[ 
        cr ~~ gc ifTrue:[ cr release ].
    ].

    "Created: / 27-12-2014 / 00:31:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2016 / 16:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_libcairo class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
