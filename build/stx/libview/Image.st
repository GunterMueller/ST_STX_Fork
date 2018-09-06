"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2015-2018 Jan Vrany
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

Object subclass:#Image
	instanceVariableNames:'pixelFunction bytes width height bitsPerPixel depth colorMap
		maxPixelValue rowByteSize bitsPerSample samplesPerPixel
		photometric device deviceForm monoDeviceForm fullColorDeviceForm
		mask maskedPixelsAre0 fileName imageSequence metaData'
	classVariableNames:'Lobby DitherAlgorithm NumberOfDitherColors
		CollectGarbageWhenRunningOutOfColors ImageErrorSignal
		ImageNotFoundQuerySignal BadImageFormatQuerySignal
		ImageSaveErrorSignal ImageLoadErrorSignal FileCreationErrorSignal
		CannotRepresentImageSignal InformationLostQuerySignal
		UnrepresentableColorSignal ARGB_A_OFFSET_MACHINE
		ARGB_R_OFFSET_MACHINE ARGB_G_OFFSET_MACHINE ARGB_B_OFFSET_MACHINE'
	poolDictionaries:''
	category:'Graphics-Images'
!

!Image class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
 COPYRIGHT (c) 2015-2018 Jan Vrany
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
    this class provides representation for all kinds of images
    (monochrome, greyscale and color) and may finally replace Form.
    Depths of 1, 2, 4, 8, 16, 24 and 32 are supported.

    An Image keeps all of its information in a device independent way,
    but may be associated to a device (i.e. getting a device-specific version of it).
    The data held keeps all information which was originally present,
    even if the display-device has lower resolution.
    Therefore, it is possible to process and manipulate images without loosing
    color information.

    Images may be created manually (by providing a pixel array),
    by screen capture, by reading a file (using an ImageReader) or
    dynamically computed by a pixelFunction (functional image).

    This gives you a device independent image.
    For display, a device representation is required, which can be
    acquired by sending the 'onDevice:aDevice' message to the image.
    This creates a (possibly dithered) device-form,
    representing the image using the currently available colors.

    In rare cases, an explicit monochrome representation of the image is needed
    (some older X servers take monochrome icons only), this can be created by sending
    it the message
        'monochromeOn:aDevice'.

    As this class is very old and originated at times when typical graphic diplays only
    supported a limited number of colors (16 or 256), you will find a lot of code which deals
    with color allocation optimizations and dithering. Nowadays, these are hardly ever needed,
    and most of the time, images will be converted to 24bit truecolor (8x8x8) when converted
    to a device representation.

    An images pixel interpretation is controlled by the photometric instance variable
    and (if that is #palette) a colorMap.
    This is in contrast to the ST-80 way, where all of this info is in the colorMap
    (and using specialized colorMaps for b&w / greyScale images).
    This may change in future versions for more application compatibility.

    To convert pictures from/to external file-formats, image readers are used
    which have the file-format knowledge built in.
    There are readers for most common formats available
    (see ImageReader and especially subclasses such as TIFFReader, GIFReader etc.).

    File formats are handled by subclasses of ImageReader, which understand
    a specific format. You can add more readers, by adding an association
    to the mapping maintained in the MIMETypes class.
    (see the MIMETypes>>initialize and possibly the display.rc file, where this is done).

    Some algorithms used here (especially dithering & color allocation) are
    experimental and far from being perfect (some are very slow).
    For now, the most common cases have been optimized and perform reasonably
    fast - however, with uncommon depth/visualType combinations, you may
    run into very slow fallback methods. If this leads to problems, you may have to
    write a specially tuned (inline-C) version for that case.

    The pixelFunction enables dynamically computed functional images: instead of
    providing a byteArray containing pixel data, a function is used which maps
    x/y coordinates to a pixel value (see examples).
    For display, the bits array is used internally and filled by the function.

    Much more work is needed if you plan to do heavy image processing and will
    (may) be done in the future if there is a demand for it ...

    Dithering can be controlled by the DitherAlgorithm classVariable:

       DitherAlgorithm:

       nil                  a simple threshold algorithm
                            (i.e. for mono, p<0.5 -> black, p>=0.5 -> white)

       #pattern             patterned dither
                            (for p, take dithered color to fill pixel;
                             uses dithering in color-class)

       #error               error diffusion dither (Floyd-Steinberg)
                            planned - not yet implemented.


    Notice:
        the set of attributes and the way they are stored originated initially
        from the need to represent tiff images. These turned out to use a relatively
        large set of atributes, of which many are unused in other image formats.
        (so it was sufficient).
        Later, some VisualWorks compatibility protocol was added (mapped palettes, for
        example), and some stuff could well be redefined in simpler ways.
        We may do that, if we are bored and there is nothing else to improve... ;-)


    [instance variables:]

        width               <Integer>       the width in pixels
        height              <Integer>       the height in pixels
        bytes               <ByteArray>     the full image information
        photometric         <Symbol>        #rgb, #palette, #blackIs0 or #whiteIs0
        samplesPerPixel     <Integer>       the number of planes
        bitsPerSample       <Array>         the number of bits per plane

        colorMap            <Array>         only if photometric is #palette;
                                            maps pixel values to r/g/b values.

        device              <Workstation>   the device on which deviceForm,
                                            monoDeviceForm and lowResDeviceForm are

        deviceForm          <Form>          the device form which gives the best
                                            possible approximation of the image on
                                            device using standard colors.

        monoDeviceForm      <Form>          the device form which gives a monochrome
                                            aproximation of the image on device.

        fullColorDeviceForm <Form>          the device form which gives the best
                                            possible aproximation of the image on
                                            device using private colors.
                                            (not yet implemented)

        mask                <ImageMask>     an optional mask;
                                            if non-nil, only pixels for which the
                                            corresponding mask bit is non-zero
                                            are drawn.

        maskedPixelsAre0    <Boolean>       a hint for image processors and drawers
                                            if true, masked pixels are known to be
                                            zero in the pixel bytes.

        fileName            <String>        the name of the file from which the
                                            image was loaded - nil otherwise.
                                            Useful for image save functions
                                            and for the UIPainter utility.

        imageSequence                       the imageSequence, of which the
                                            instance is a frame or nil,
                                            if its not part of a sequence.

        bitsPerPixel                        obsolete - not used in ST/X (kept for a while for subclasses)
        depth                               - these have been added in instVar-slots
        maxPixelValue                       - according to the ST-80's image class.
        rowByteSize                         - to allow loading of st-80 images
                                            - (which are stored as instVarAt:put: expressions)

    [class variables:]

        Lobby               <Registry>      keeps track of known images
                                            (for resource freeing with garbage collector)

        DitherAlgorithm     <Symbol>        defines how to dither

        NumberOfDitherColors <Integer>      defines, how many dither colors to use

        FileFormats         <Dictionary>    associates filename extensions to
                                            image reader classes (now set-up in startup-file)

        CollectGarbageWhenRunningOutOfColors
                            <Boolean>       if true, and we run out of available
                                            device colors during creation of a
                                            device image, collect garbage for
                                            possible image reclamation.
                                            If false, proceed immediately.
                                            Default is true.

        ImageNotFoundQuerySignal
                            <QuerySignal>   raised, if an image could not be loaded
                                            from a file. The parameter is the images
                                            fileName.
                                            A handler may return a replacement
                                            image or proceed with nil.
                                            If unhandled, a nil is returned from the
                                            image creation.

        BadImageFormatQuerySignal
                            <QuerySignal>   raised, if an image could not be loaded
                                            from a file due to a file error or
                                            unsupported format.
                                            A handler may return a replacement
                                            image or proceed with nil.
                                            If unhandled, a nil is returned from the
                                            image creation.

        ImageSaveErrorSignal
                            <Signal>        parent of errors below.

        FileCreationErrorSignal
                            <Signal>        file could not be created when saving an
                                            image.

        CannotRepresentImageSignal
                            <Signal>        the specified ImageReader cannot represent
                                            the given image.

        InformationLostQuerySignal
                            <Signal>        the specified ImageReader can represent
                                            the given image, but some information
                                            (typically color resolution) is lost.
                                            If unhandled, the save proceeds as usual.


    caveat:
        the information in
            photometric, bitsPerPixel, bitsPerSample, samplesPerPixel, depth , colorMap and maxPixelValue
        is partially redundant and its handling stupid (not to say: braindamaged ;-).
        The only excuse is that it grew over time, had to incorporate various alien/older schemes for
        compatibility reasons (mostly coming from tiff format, which was the very first supported format).
        All of the above belongs into the single colorMap which must migrate from
        a stupid seqColl to a color-aware real colorMap.
        (we are in the process of doing so...)

    todo:
        support alpha masks
        cleanup the dithering & conversion code
        cleanup the color/photometric mess

    [See also:]
        Form Icon ImageReader

    [author:]
        Claus Gittinger
"
!

examples
"
    reading from a file (many formats are supported):
    (notice that the bitmaps directory is searched for along
     the system path - therefore, you may add your own bitmap
     directory to the beginning of the path and thus override
     any default bitmaps, or make certain that your application
     finds its bitmaps - even if they are in a separate directory)

                                                                                        [exBegin]
        (Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif') inspect
                                                                                        [exEnd]
    Boy, was I young, when writing ST/X... ;-)                                                                                                 
                                                                                        [exBegin]
        (Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif') inspect
        ((Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif') rotated:90) inspect
        ((Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif') rotated:45) inspect
        ((Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif') rotated:25) inspect
                                                                                        [exEnd]

                                                                                        
    better use package relative file names:
                                                                                        [exBegin]
        (Image fromFile:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies') inspect
                                                                                        [exEnd]
    various file formats are supported:
                                                                                        [exBegin]
        (Image fromFile:'bitmaps/xpmBitmaps/misc_icons/SmalltalkX_clr.xpm' inPackage:'stx:goodies') inspect
                                                                                        [exEnd]
                                                                                        [exBegin]
        (Image fromFile:'bitmaps/winBitmaps/okSmily_up.bmp' inPackage:'stx:goodies') inspect
                                                                                        [exEnd]

    drawing
                                                                                        [exBegin]
        |imageClass image|

        imageClass := Image implementorForDepth:24.
        image      := imageClass width: 100 height: 50.
        image bits:(ByteArray new:(image bytesPerRow*50)).
        image fillRectangle:(0@0 extent:100@50) withColor:Color yellow.
        image drawRectangle:(10@10 extent:20@20) withColor:Color red.
        image fillRectangle:(40@20 extent:20@20) withColor:Color green.
                                                                                        [exEnd]

    The following examples demonstrate various depth and colorMap variations ...

    inline image:
      default: depth=1 & #blackIs0
                                                                        [exBegin]
        (Image
            width:8 height:8
            fromArray:#( 2r11111111
                         2r10000001
                         2r10000001
                         2r10000001
                         2r10000001
                         2r10000001
                         2r10000001
                         2r11111111 )
        ) edit
                                                                        [exEnd]

      with #whiteIs0 photometric
                                                                        [exBegin]
        ((Image width:8 height:8
               fromArray:#( 2r11111111
                            2r10000001
                            2r10000001
                            2r10000001
                            2r10000001
                            2r10000001
                            2r10000001
                            2r11111111 ))
            photometric:#whiteIs0
        ) edit
                                                                        [exEnd]

      with a colorMap
                                                                        [exBegin]
        ((Image width:8 height:8
               fromArray:#( 2r11111111
                            2r10000001
                            2r10000001
                            2r10000001
                            2r10000001
                            2r10000001
                            2r10000001
                            2r11111111 ))
            colorMap:(Array with:(Color red)
                            with:(Color yellow))
        ) edit
                                                                        [exEnd]

      a depth4 greyScale image:
      (default photometric is #blackIs0)
                                                                        [exBegin]
        (Depth4Image
             width:8
             height:4
             fromArray:#[
                            16r00 16r11 16r22 16r33
                            16r44 16r55 16r66 16r77
                            16r88 16r99 16raa 16rbb
                            16rcc 16rdd 16ree 16rff
                        ]
        ) edit
                                                                        [exEnd]
      the same, magnified:
                                                                        [exBegin]
        ((Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ])
            magnifiedBy:30
        ) edit
                                                                        [exEnd]
      the following has the same effect:
                                                                        [exBegin]
        ((Image
             width:4
             height:4
             depth:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ])
            magnifiedBy:30
        ) edit
                                                                        [exEnd]
      with reverse grey-interpretation:
                                                                        [exBegin]
        ((Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ])
            photometric:#whiteIs0;
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

      with 1-bit-per-pixel rgb interpretation:
                                                                        [exBegin]
        ((Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ])
            photometric:#rgb;
            samplesPerPixel:3;
            bitsPerSample:#(1 1 1);
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

      with 1/2/1 rgb interpretation:
                                                                        [exBegin]
        ((Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ])
            photometric:#rgb;
            samplesPerPixel:3;
            bitsPerSample:#(1 2 1);
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

      a 2/2/0 rgb image (i.e. no blue):
                                                                        [exBegin]
         |i|

         i := Depth4Image
                    width:4
                    height:4
                    fromArray:#[ 16r01 16r23
                                 16r45 16r67
                                 16r89 16rab
                                 16rcd 16ref ].
         i photometric:#rgb.
         i samplesPerPixel:3.
         i bitsPerSample:#(2 2 0).

         i := i magnifiedBy:30.
         i edit.
                                                                        [exEnd]


      a 0/0/4 rgb image (i.e. no red or green):
                                                                        [exBegin]
         |i|

         i := Depth4Image
                    width:4
                    height:4
                    fromArray:#[ 16r01 16r23
                                 16r45 16r67
                                 16r89 16rab
                                 16rcd 16ref ].
         i photometric:#rgb.
         i samplesPerPixel:3.
         i bitsPerSample:#(0 0 4).

         i := i magnifiedBy:30.
         i edit.
                                                                        [exEnd]


      a 2plane greyscale image:
                                                                        [exBegin]
        ((Depth2Image
             width:4
             height:4
             fromArray:#[
                            4r0123
                            4r1230
                            4r2301
                            4r3012
                        ])
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

      with colors:
                                                                        [exBegin]
        ((Depth2Image
             width:4
             height:4
             fromArray:#[
                            4r0123
                            4r1230
                            4r2301
                            4r3012
                        ])
            colorMap:(Array with:(Color black)
                            with:(Color red)
                            with:(Color green)
                            with:(Color blue));
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

      depth8 image with 3/3/2 rgb interpretation:
                                                                        [exBegin]
        ((Depth8Image
             width:16
             height:16
             fromArray:(ByteArray withAll:(0 to:16rFF)))
            photometric:#rgb;
            samplesPerPixel:3;
            bitsPerSample:#(3 3 2);
            magnifiedBy:10
        ) edit
                                                                        [exEnd]

      depth8 image with 2/2/2 rgb interpretation:
                                                                        [exBegin]
        ((Depth8Image
             width:8
             height:8
             fromArray:(ByteArray withAll:(0 to:16r3F)))
            photometric:#rgb;
            samplesPerPixel:3;
            bitsPerSample:#(2 2 2);
            magnifiedBy:10
        ) edit
                                                                        [exEnd]

                                                                        [exBegin]
        ((Depth8Image
             width:4
             height:4
             fromArray:#[
                    16r30 16r0C  16r03 16r3F
                    16r20 16r08  16r02 16r2A
                    16r10 16r04  16r01 16r15
                    16r00 16r00  16r00 16r00
                        ])
            photometric:#rgb;
            samplesPerPixel:3;
            bitsPerSample:#(2 2 2);
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

      trueColor image: remember: bytes are MSB
                                                                        [exBegin]
        ((Depth16Image
             width:4
             height:5
             fromArray:#[
                    2r01111100 2r00000000  2r00000011 2r11100000  2r00000000 2r00011111  2r01111111 2r11111111
                    2r00111100 2r00000000  2r00000001 2r11100000  2r00000000 2r00001111  2r00111101 2r11101111
                    2r00011100 2r00000000  2r00000000 2r11100000  2r00000000 2r00000111  2r00011100 2r11100111
                    2r00001100 2r00000000  2r00000000 2r01100000  2r00000000 2r00000001  2r00001100 2r01100011
                    2r00000100 2r00000000  2r00000000 2r00100000  2r00000000 2r00000001  2r00000100 2r00100001
                        ])
            photometric:#rgb;
            samplesPerPixel:3;
            bitsPerSample:#(5 5 5);
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

                                                                        [exBegin]
        ((Depth24Image
             width:4
             height:4
             fromArray:#[
                    16rFF 16r00 16r00  16rFF 16r00 16r00  16rFF 16r00 16r00  16rFF 16r00 16r00
                    16r00 16rFF 16r00  16r00 16rFF 16r00  16r00 16rFF 16r00  16r00 16rFF 16r00
                    16r00 16r00 16rFF  16r00 16r00 16rFF  16r00 16r00 16rFF  16r00 16r00 16rFF
                    16rFF 16rFF 16rFF  16rFF 16rFF 16rFF  16rFF 16rFF 16rFF  16rFF 16rFF 16rFF
                        ])
            photometric:#rgb;
            samplesPerPixel:3;
            bitsPerSample:#(8 8 8);
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

      32bit trueColor image:
                                                                        [exBegin]
        ((Depth32Image
             width:4
             height:4
             fromArray:#[
                    16rFF 16r00 16r00 16r00  16rFF 16r00 16r00 16r00  16rFF 16r00 16r00 16r00  16rFF 16r00 16r00 16r00
                    16r00 16rFF 16r00 16r00  16r00 16rFF 16r00 16r00  16r00 16rFF 16r00 16r00  16r00 16rFF 16r00 16r00
                    16r00 16r00 16rFF 16r00  16r00 16r00 16rFF 16r00  16r00 16r00 16rFF 16r00  16r00 16r00 16rFF 16r00
                    16rFF 16rFF 16rFF 16r00  16rFF 16rFF 16rFF 16r00  16rFF 16rFF 16rFF 16r00  16rFF 16rFF 16rFF 16r00
                        ])
            photometric:#rgb;
            samplesPerPixel:4;
            bitsPerSample:#(8 8 8 8);
            magnifiedBy:30
        ) edit
                                                                        [exEnd]

    storing - only a subset of formats (TIFF, XBM, XPM) currently support storing:
                                                                        [exBegin]
        |img|

        img := Image fromFile:'bitmaps/winBitmaps/okSmily_up.bmp' inPackage:'stx:goodies'.
        img saveOn:'myImage.tiff'.
        (Image fromFile:'myImage.tiff') inspect.
        img saveOn:'myImage.gif'.
        (Image fromFile:'myImage.gif') inspect.
                                                                        [exEnd]

    magnifying (any factor):
                                                                        [exBegin]
        ((Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies')
            magnifiedTo:(48@48))
                inspect
                                                                        [exEnd]
                                                                        [exBegin]
        ((Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies')
            magnifiedBy:0.7)
                inspect
                                                                        [exEnd]

    rotating (any angle in degrees clockwise):
                                                                        [exBegin]
        ((Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies')
            rotated:90)
                inspect
                                                                        [exEnd]
                                                                        [exBegin]
        (((Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies')
            magnifiedBy:0.3@0.7) rotated:270)
                inspect
                                                                        [exEnd]
                                                                        [exBegin]
        (((Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies')
            ) rotated:30)
                inspect
                                                                        [exEnd]
    negative:
                                                                        [exBegin]
        ((Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies')
            negative)
                inspect
                                                                        [exEnd]

      depth32 image with 8+8+8+8 argb interpretation:
                                                                        [exBegin]
        ((Depth32Image
             width:4 height:4
             fromArray:#[
                255 255 0 0       255 255 0 0       255 255 0 0       255 255 0 0
                255 0 255 0       255 0 255 0       255 0 255 0       255 0 255 0
                255 0 0 255       255 0 0 255       255 0 0 255       255 0 0 255
                255 255 255 255   255 255 255 255   255 255 255 255   255 255 255 255 ])
            photometric:#argb;
            samplesPerPixel:4;
            bitsPerSample:#(8 8 8 8);
            magnifiedBy:10
        ) edit
                                                                        [exEnd]

      depth32 image with 8+8+8+8 rgba interpretation:
                                                                        [exBegin]
        ((Depth32Image
             width:4 height:4
             fromArray:#[
                255 0 0 255       255 0 0 255       255 0 0 255       255 0 0 255
                0 255 0 255       0 255 0 255       0 255 0 255       0 255 0 255
                0 0 255 255       0 0 255 255       0 0 255 255       0 0 255 255
                255 255 255 255   255 255 255 255   255 255 255 255   255 255 255 255 ])
            photometric:#rgba;
            samplesPerPixel:4;
            bitsPerSample:#(8 8 8 8);
            magnifiedBy:10
        ) edit
                                                                        [exEnd]
"
!

examples_functionalImages
"
    Functional images (please read 'Functional Images' by Conal Elliot, Microsoft Research).
    These have no underyling pixelstorage, but instead compute the pixel-value via a block.

    Plain x/y mapping:
                                                                        [exBegin]
        |i|
        i := Depth1Image extent:256@256.
        i pixelFunction:[:x :y | ((x // 16) bitXor:(y // 16)) odd ifTrue:1 ifFalse:[0]].
        i inspect.
                                                                        [exEnd]
    Transformed x/y mapping:
                                                                        [exBegin]
        |i f|
        f := [:x :y | (x between:0.4 and:0.6) asInteger].
        i := Depth1Image extent:256@256.
        i pixelFunction:f inX:(0.0 to:1.0) y:(0.0 to:1.0).
        i inspect.
                                                                        [exEnd]
                                                                        [exBegin]
        |i f|
        f := [:x :y | ((x between:0.4 and:0.6) or:[(y between:0.4 and:0.6)]) asInteger].
        i := Depth1Image extent:256@256.
        i pixelFunction:f inX:(0.0 to:1.0) y:(0.0 to:1.0).
        i inspect.
                                                                        [exEnd]
    Image based on polar coordinate:
                                                                        [exBegin]
        |i f|
        f := [:x :y | ((x@y) r * 10) asInteger bitAnd:1].
        i := Depth1Image extent:256@256.
        i pixelFunction:f inX:(-1.0 to:1.0) y:(-1.0 to:1.0).
        i inspect.
                                                                        [exEnd]
    Grayscale image based on polar coordinate:
                                                                        [exBegin]
        |i|
        i := Depth8Image extent:256@256.
        i photometric:#blackIs0.
        i pixelFunction:[:x :y | ((x@y) r * 255) truncated min:255] inX:(-1 to:1) y:(-1 to:1).
        i inspect.
                                                                        [exEnd]

    Taking another image as ''input''
                                                                        [exBegin]
        |garfield f i h|

        garfield := Image fromFile:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'.
        h := garfield height.
        f := [:x :y | (garfield colorAtX:x y:h-y) rgbValue].

        i := Depth24Image extent:garfield extent.
        i pixelFunction:f.
        i inspect.
                                                                        [exEnd]
"
! !

!Image class methodsFor:'initialization'!

addReader:aReaderClass suffix:aSuffix
    <resource: #obsolete>
    "register an additional image reader.
     This is provided for subclasses, to regster themself when
     loaded (or from the startup scripts)"

    self obsoleteMethodWarning.
    self addReader:aReaderClass suffix:aSuffix mimeType:nil
!

addReader:aReaderClass suffix:aSuffix mimeType:mimeType
    <resource: #obsolete>
    "register an additional image reader.
     This interface is kept for backward compatibility.
     The knowledge has been concentrated in MIMETypes"

    self obsoleteMethodWarning.
    MIMETypes
        defineImageType:mimeType suffix:aSuffix reader:aReaderClass

    "
     Image addReader:GIFReader suffix:'gif'
     Image addReader:GIFReader suffix:'gif' mimeType:'image/gif'
    "

    "Modified: 30.6.1997 / 21:59:59 / cg"
!

fileFormats
    "return the collection of supported file formats.
     The returned dictionary maps file-extensions to image reader classes."

    ^ MIMETypes fileSuffixToImageReaderMapping

    "
     Image fileFormats
    "

    "Modified: 30.6.1997 / 22:05:58 / cg"
!

flushDeviceImages
    "simply release all deviceForms"

    Lobby do:[:anImage |
        anImage release
    ]

    "Modified: 15.6.1996 / 15:45:02 / cg"
!

initialize
    "initialize class constants"

    "setup tracker of known pictures"
    Lobby isNil ifTrue:[
        Lobby := Registry new.
        ObjectMemory addDependent:self.

        "/ define the algorithm to use for dithering -
        "/ supported values are:
        "/      #threshold
        "/      #ordered
        "/      #floydSteinberg
        "/      #burkes

        DitherAlgorithm := #floydSteinberg.

        (Display notNil and:[Display hasGrayscales]) ifFalse:[
            NumberOfDitherColors := 64
        ] ifTrue:[
            "as far as I remember, this is about the number of grey values, the eye can distinguish"
            NumberOfDitherColors := 100
        ].

        "define reader classes"
        self initializeFileFormatTable.
        self initializeMIMETable.

        CollectGarbageWhenRunningOutOfColors := false.

        ImageErrorSignal := Error newSignalMayProceed:true.
        ImageErrorSignal nameClass:self message:#imageErrorSignal.

        ImageSaveErrorSignal := ImageErrorSignal newSignalMayProceed:true.
        ImageSaveErrorSignal nameClass:self message:#imageSaveErrorSignal.

        FileCreationErrorSignal := ImageSaveErrorSignal newSignalMayProceed:true.
        FileCreationErrorSignal nameClass:self message:#fileCreationErrorSignal.

        CannotRepresentImageSignal := ImageSaveErrorSignal newSignalMayProceed:true.
        CannotRepresentImageSignal nameClass:self message:#cannotRepresentImageSignal.

        ImageLoadErrorSignal := QuerySignal new.
        ImageLoadErrorSignal nameClass:self message:#imageLoadErrorSignal.

        ImageNotFoundQuerySignal := QuerySignal new.
        ImageNotFoundQuerySignal nameClass:self message:#imageNotFoundQuerySignal.
        ImageNotFoundQuerySignal parent:ImageLoadErrorSignal.

        InformationLostQuerySignal := QuerySignal new.
        InformationLostQuerySignal nameClass:self message:#informationLostQuerySignal.
        InformationLostQuerySignal parent:ImageLoadErrorSignal.

        BadImageFormatQuerySignal := QuerySignal new.
        BadImageFormatQuerySignal nameClass:self message:#badImageFormatQuerySignal.
        BadImageFormatQuerySignal parent:ImageLoadErrorSignal.

        UnrepresentableColorSignal := ImageErrorSignal newSignalMayProceed:true.
        UnrepresentableColorSignal nameClass:self message:#unrepresentableColorSignal.
    ].
    UninterpretedBytes isBigEndian ifTrue:[
        ARGB_A_OFFSET_MACHINE := 1.
        ARGB_R_OFFSET_MACHINE := 2.
        ARGB_G_OFFSET_MACHINE := 3.
        ARGB_B_OFFSET_MACHINE := 4.
    ] ifFalse:[ 
        ARGB_A_OFFSET_MACHINE := 4.
        ARGB_R_OFFSET_MACHINE := 3.
        ARGB_G_OFFSET_MACHINE := 2.
        ARGB_B_OFFSET_MACHINE := 1.
    ].

    "Modified: / 18-05-1999 / 15:50:03 / cg"
    "Modified: / 28-02-2016 / 14:36:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeFileFormatTable
    "initialize a default table to map from file extension to reader class.
     The mapping here is a default needed for proper operation of ST/X;
     see the 'smalltalk.rc'/'display.rc' startup files for a real (full) map."

    MIMETypes notNil ifTrue:[
        MIMETypes imageReaderForSuffix:'xbm'  put:XBMReader.
        MIMETypes imageReaderForSuffix:'tiff' put:TIFFReader.
        MIMETypes imageReaderForSuffix:'gif'  put:GIFReader.
    ].

    "
     Image initializeFileFormatTable
    "

    "Modified: 30.6.1997 / 22:07:28 / cg"
!

initializeMIMETable
    "initialize a default table to map from mime type to reader class.
     The mapping here is a default needed for proper operation of ST/X;
     see the 'smalltalk.rc'/'display.rc' startup files for a real (full) map."

    MIMETypes notNil ifTrue:[
        MIMETypes mimeTypeForSuffix:'gif'       put:'image/gif'.
        MIMETypes mimeTypeForSuffix:'tiff'      put:'image/tiff'.
        MIMETypes mimeTypeForSuffix:'tif'       put:'image/tiff'.
        MIMETypes mimeTypeForSuffix:'xbm'       put:'image/x-xbitmap'.
        MIMETypes mimeTypeForSuffix:'xpm'       put:'image/x-xpixmap'.
    ].

    "
     Image initializeMIMETable
    "

    "Created: 27.6.1997 / 16:43:48 / cg"
    "Modified: 21.7.1997 / 17:33:59 / cg"
!

update:something with:aParameter from:changedObject
    "flush all device specific stuff when restarted from a snapshot"

    (something == #restarted) ifTrue:[
        self flushDeviceImages
    ]

    "Created: 21.6.1996 / 19:47:43 / cg"
! !

!Image class methodsFor:'instance creation'!

extent:ext
    "create a new image, given extent.
     Assume a depth of 1, unless an explicit imageClass is the receiver."

    ^ self width:(ext x) height:(ext y)

    "Created: / 30.9.1998 / 22:31:26 / cg"
    "Modified: / 30.9.1998 / 22:32:48 / cg"
!

extent:ext depth:d
    "ST-80 compatibility"

    ^ self width:ext x height:ext y depth:d
!

extent:ext depth:d antiAliasedPalette:aBasicColorArray bgColor:bgColor
    ^ self extent:ext depth:d antiAliasedPalette:aBasicColorArray bgColor:bgColor mixedArray:#(1.0 0.8 0.6 0.4 0.2)

    "
        |colorMap aaImgArray|

        colorMap := Array with:Color white with:Color blue.

        aaImgArray := Depth8Image extent:300@400 depth:8 antiAliasedPalette:colorMap bgColor:Color white.
        aaImgArray last
            fillAntiAliasedArc:200@200
            radius:80
            from:0
            angle:360
            withColor:Color blue
            antiAliasedPalette:aaImgArray first
            startWith:aaImgArray second.

        aaImgArray last inspect.


        |colorMap aaImgArray|

        colorMap := Array with:Color white with:Color black with:Color red with:Color blue.

        aaImgArray := Depth8Image extent:300@400 depth:8 antiAliasedPalette:colorMap bgColor:Color white.
        aaImgArray last fillAntiAliasedArc:205@195 radius:80 from:0 angle:90 withColor:Color red
            colorDictionary:aaImgArray first
            blendStart:aaImgArray second.
        aaImgArray last fillAntiAliasedArc:200@200 radius:80 from:90 angle:270 withColor:Color blue
            colorDictionary:aaImgArray first
            blendStart:aaImgArray second.

        aaImgArray last inspect.

    "
!

extent:ext depth:d antiAliasedPalette:aBasicColorArray bgColor:bgColor mixedArray:mixedArray
    |colorMap colorIndex colorDictionary tmpDic newImage|

    colorMap := OrderedCollection new.
    colorIndex := 0.
    colorDictionary := Dictionary new.

    aBasicColorArray do:[:aColor |
        colorMap add:aColor.
        colorIndex := colorIndex + 1.

        tmpDic := Dictionary new.

        mixedArray do:[:aFloat |
            tmpDic at:aFloat put:colorIndex.
            colorMap add:(aColor mixed:aFloat with:bgColor).
            colorIndex := colorIndex + 1.
        ].

        colorDictionary at:aColor put:tmpDic.
    ].

    newImage := (self implementorForDepth:d) new.
    newImage width:ext x height:ext y depth:d palette:colorMap.
    newImage createPixelStore.
"/    emptyBits := ByteArray new:(newImage bytesPerRow * ext y).
"/    newImage bits:emptyBits.

    ^ Array with:colorDictionary with:mixedArray first with:newImage

    "
        |colorMap aaImgArray|

        colorMap := Array with:Color white with:Color black with:Color red with:Color blue.

        aaImgArray := Depth8Image extent:300@400 depth:8 antiAliasedPalette:colorMap bgColor:Color white.
        aaImgArray last fillAntiAliasedArc:205@195 radius:80 from:0 angle:90 withColor:Color red
            colorDictionary:aaImgArray first
            blendStart:aaImgArray second.
        aaImgArray last fillAntiAliasedArc:200@200 radius:80 from:90 angle:270 withColor:Color blue
            colorDictionary:aaImgArray first
            blendStart:aaImgArray second.

        aaImgArray last inspect.

 ###################

        |colorMap aaImgArray|

        colorMap := Array with:Color white with:Color blue.

        aaImgArray := Depth8Image extent:300@400 depth:8 antiAliasedPalette:colorMap bgColor:Color white.
        aaImgArray last
            fillAntiAliasedArc:200@200
            radius:80
            from:0
            angle:360
            withColor:Color blue
            colorDictionary:aaImgArray first
            blendStart:aaImgArray second.

        aaImgArray last inspect.
    "

    "Modified: / 02-11-2010 / 20:57:41 / cg"
    "Modified: / 31-01-2017 / 14:30:22 / stefan"
    "Modified (comment): / 31-01-2017 / 15:47:39 / stefan"
!

extent:ext depth:d bits:bits
    "ST-80 compatibility; assume 32-bit padding"

    ^ self extent:ext depth:d bits:bits pad:32
!

extent:ext depth:d bits:bits pad:padding
    "ST-80 compatibility"

    ^ self width:ext x height:ext y depth:d fromArray:bits pad:padding
!

extent:ext depth:d bitsPerPixel:bpp palette:aColormap usingBits:bits
    "ST-80 compatibility"

    |img|

    img := self width:ext x height:ext y depth:bpp fromArray:bits pad:32.
    img colorMap:aColormap.
    ^ img

    "Created: 25.1.1997 / 03:50:22 / cg"
    "Modified: 25.1.1997 / 12:27:35 / cg"
!

extent:ext depth:d palette:aColormap
    "create & return a blank image of the given size.
     ST-80 compatibility"

    |newImage|

    newImage := (self implementorForDepth:d) new.
    newImage width:ext x height:ext y depth:d palette:aColormap.
    newImage createPixelStore.
"/    emptyBits := ByteArray new:(newImage bytesPerRow * ext y).
"/    newImage bits:emptyBits.
    ^ newImage

    "
     Image extent:16@16 depth:8 palette:nil
     Image extent:16@16 depth:4 palette:nil
     Image extent:16@16 depth:2 palette:nil
    "

    "Created: / 06-03-1997 / 15:24:01 / cg"
    "Modified: / 02-11-2010 / 20:56:53 / cg"
    "Modified (format): / 31-01-2017 / 14:51:03 / stefan"
!

extent:ext depth:d palette:aColormap bits:bits
    "ST-80 compatibility"

    ^ self extent:ext depth:d palette:aColormap bits:bits pad:16

    "Modified: 7.10.1996 / 11:32:16 / cg"
!

extent:ext depth:d palette:aColormap bits:bits pad:padding
    "ST-80 compatibility"

    |img|

    img := self width:ext x height:ext y depth:d fromArray:bits pad:padding.
    img colorMap:aColormap.
    ^ img

    "Modified: 7.10.1996 / 11:32:00 / cg"
!

extent:ext fromArray:bits offset:offset
    "ST-80 compatibility"

    ^ self width:ext x height:ext y fromArray:bits
!

fromDeviceForm:aForm maskForm:aMaskFormOrNil
    "create & return an image form aForm that is already on a device"

    |img|

    img := self newForDepth:aForm depth.
    img fromDeviceForm:aForm maskForm:aMaskFormOrNil.

    ^ img 
!

fromForm:aForm
    "create & return an Image given a aForm"

    ^ self fromSubForm:(0@0 extent:aForm extent) in:aForm

    "
     |f|

     f := Form width:16 height:16.
     f clear.
     f displayLineFromX:0 y:0 toX:15 y:15.
     f inspect.
     (Image fromForm:f) inspect
    "

    "
     |f|

     f := Form width:16 height:16 depth:(Display depth) on:Display.
     f clear.
     f paint:(Color red).
     f displayLineFromX:0 y:0 toX:15 y:15.
     f paint:(Color green).
     f displayLineFromX:15 y:0 toX:0 y:15.
     f inspect.
     (Image fromForm:f) inspect
    "

    "Modified: 11.7.1996 / 11:21:42 / cg"
!

fromImage:anImage
    "create & return an Image given another image. This can be used to
     convert an image to another depth."

    ^ self fromImage:anImage photometric:nil

    "
     |i i2 idx|

     i := Image fromFile:'/home/cg/work/stx/goodies/bitmaps/xpmBitmaps/QUESTION.xpm'.
     i2 := i deepCopy.

     idx := i2 colorMap indexOfPaintNearest:(Color green).
     i2 colorMap at:idx put:Color red.
     i2 inspect.
     i inspect.
    "
!

fromImage:anImage photometric:photometricOrNil
    "create & return an Image given another image. This can be used to
     convert an image to another depth."

    (self == Image
    or:[anImage class == self
        and:[photometricOrNil isNil or:[photometricOrNil == anImage photometric]]]) ifTrue:[^ anImage].
    ^ self new fromImage:anImage photometric:photometricOrNil.

    "
     |i1 i8|

     i1 := Image fromFile:'goodies/bitmaps/SBrowser.xbm'.
     i8 := Depth8Image fromImage:i1.
     i8 inspect
    "
!

fromSubForm:aRectangle in:aForm
    "create & return an subImage given a aForm"

    |depth formsDevice vis img photometric|

    depth := aForm depth.
    formsDevice := aForm device.

    photometric := (depth > 8) ifTrue:[#rgb] ifFalse:[#palette].

    (formsDevice notNil and:[depth == formsDevice depth]) ifTrue:[
        "/
        "/ for truecolor displays, return a Depth24Image
        "/ (must do this for depth15 & depth16 displays, since
        "/  Depth16Image has no way to specify r/g/b masks ...)
        "/
        vis := formsDevice visualType.
        (vis == #TrueColor or:[vis == #DirectColor]) ifTrue:[
            depth > 8 ifTrue:[
                depth := 24.
            ]
        ].
    ].
    img := self newForDepth:depth.
    img photometric:photometric.

    formsDevice isNil ifTrue:[
        ^ img from:aForm in:aRectangle.
    ].
    ^ img from:aForm in:aRectangle

    "
     |f|

     f := Form width:16 height:16.
     f clear.
     f displayLineFromX:0 y:0 toX:15 y:15.
     f inspect.
     (Image fromForm:f) inspect.
     (Image fromSubForm:(5@5 corner:10@10) in:f) inspect
    "

    "
     |f|

     f := Form width:16 height:16 depth:(Display depth) on:Display.
     f clear.
     f paint:(Color red).
     f displayLineFromX:0 y:0 toX:15 y:15.
     f paint:(Color green).
     f displayLineFromX:15 y:0 toX:0 y:15.
     f inspect.
     (Image fromForm:f) inspect.
     (Image fromSubForm:(5@5 corner:10@10) in:f) inspect
    "

    "Modified: / 31-01-2017 / 15:03:17 / stefan"
!

fromSubImage:anImage in:aRectangle
    "create & return an Image from a rectangular area in another image.
     This can also be used to get a subimage in another depth.
     As with layouts, the rectangle may contain integers (= nr of pixels) or float numbers (= relative size).
     Color precision may be lost, if conversion is from a higher depth image.
     For palette & rgb images, this may fail if a color cannot be represented."

    |cls|

    self == Image ifTrue:[
        cls := self implementorForDepth:anImage depth.
    ] ifFalse:[
        cls := self.
    ].
    ^ cls new fromSubImage:anImage in:aRectangle.

    "
     |i1 i8|

     i1 := Image fromFile:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'.
     i8 := Depth8Image fromSubImage:i1 in:(250@90 extent:50@50).
     i8 inspect
    "
    "
     |i1 i8|

     i1 := Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies'.
     i8 := Image fromSubImage:i1 in:(70@50 extent:50@50).
     i8 inspect
    "
    "
     |i1 i24|

     i1 := Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies'.
     i24 := Depth24Image fromSubImage:i1 in:(70@50 extent:50@50).
     i24 inspect
    "
    "
     |i1 i24|

     i1 := Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies'.
     i1 inspect.
     i24 := Depth24Image fromSubImage:i1 in:(0.25@0.25 extent:0.5@0.5).
     i24 inspect
    "

    "Created: / 20-09-1995 / 01:05:43 / claus"
    "Modified: / 24-04-1997 / 23:13:02 / cg"
    "Modified (format): / 30-01-2017 / 19:45:54 / stefan"
!

new
    "create a new image. Redefined to set the photometric to
     greyScale with black being 0 as default."

    ^ self basicNew initialize

    "Modified: 10.6.1996 / 18:08:37 / cg"
!

newForDepth:depth
    "create a new image. Redefined to set the photometric to
     greyScale with black being 0 as default."

    |cls|

    cls := self implementorForDepth:depth.
    ^ cls new

    "
     Image newForDepth:8
    "

    "Modified: / 27-05-2007 / 16:57:09 / cg"
!

width:w height:h
    "create a new image, given width, height.
     Assume a depth of 1, unless an explicit imageClass is the receiver."

    |cls|

    cls := self.
    cls == Image ifTrue:[
        cls := self implementorForDepth:1
    ].
    ^ cls new width:w height:h

    "Modified: / 06-06-2007 / 11:10:55 / cg"
!

width:w height:h depth:d
    "create a new image, given width, height and depth"

    ^ (self newForDepth:d)
        width:w height:h depth:d
!

width:w height:h depth:d fromArray:pixelData
    "create a new image, given width, height, depth and data.
     Data must be a ByteArray containing correctly aligned bits for the specified
     depth (8-bit padded)."

    ^ (self newForDepth:d)
        width:w height:h depth:d fromArray:pixelData

    "
     Image width:8
           height:8
           depth:1
           fromArray:#[2r11001100
                       2r00110011
                       2r11001100
                       2r00110011
                       2r11001100
                       2r00110011
                       2r11001100
                       2r00110011].
    "

    "
     Image width:8
           height:8
           depth:2
           fromArray:#[4r1100 4r1100
                       4r0011 4r0011
                       4r1100 4r1100
                       4r0011 4r0011
                       4r1100 4r1100
                       4r0011 4r0011
                       4r1100 4r1100
                       4r0011 4r0011].
    "

    "
     Image width:8
           height:8
           depth:4
           fromArray:#[16r00 16r01 16rf0 16rf1
                       16r02 16r03 16rf2 16rf3
                       16r04 16r05 16rf4 16rf5
                       16r06 16r07 16rf6 16rf7
                       16r08 16r09 16rf8 16rf9
                       16r0a 16r0b 16rfa 16rfb
                       16r0c 16r0d 16rfc 16rfd
                       16r0e 16r0f 16rfe 16rff].
    "

    "
     Image width:8
           height:8
           depth:16
           fromArray:#(1 1 1 1 1 1 1 1
                       2 2 2 2 2 2 2 2
                       3 3 3 3 3 3 3 3
                       4 4 4 4 4 4 4 4
                       5 5 5 5 5 5 5 5
                       6 6 6 6 6 6 6 6
                       7 7 7 7 7 7 7 7
                       8 8 8 8 8 8 8 8
                      ) asWordArray.
    "

    "Modified: 10.6.1996 / 18:18:10 / cg"
!

width:w height:h depth:d fromArray:pixelData pad:padding
    "create a new image, given width, height, depth and data.
     Data must be a ByteArray containing correctly aligned bits for the specified
     depth."

    |img newBits
     srcRowBytes "{ Class: SmallInteger }"
     dstRowBytes "{ Class: SmallInteger }"
     nextDstIndex "{ Class: SmallInteger }"
     srcIndex "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }" |

    img := (self newForDepth:d) width:w height:h depth:d .

    srcRowBytes := ((w * d + padding - 1) bitShift:-5) bitShift:2.
    dstRowBytes := img bytesPerRow.

    (padding ~~ 8 and:[(srcRowBytes \\ 4 ~~ 0) or:[srcRowBytes ~= dstRowBytes]]) ifTrue:[
        "must repad; ST/X uses byte padding, while ST-80 uses longword
         padding. This is stupid, and may be changed in ST/X with future versions.
        "
        dstRowBytes := img bytesPerRow.

        newBits := ByteArray uninitializedNew:(dstRowBytes * h).
        srcIndex := 1.
        dstIndex := 1.

        1 to:h do:[:row |
            nextDstIndex := dstIndex + dstRowBytes.
            newBits replaceFrom:dstIndex
                             to:(nextDstIndex - 1)
                           with:pixelData
                     startingAt:srcIndex.
            srcIndex := srcIndex + srcRowBytes.
            dstIndex := nextDstIndex.
        ].
    ] ifFalse:[
        pixelData class isBytes ifFalse:[
            newBits := ByteArray withAll:pixelData
        ] ifTrue:[
            newBits := pixelData
        ]
    ].
    img bits:newBits.
    ^ img

    "Modified: / 27-05-2007 / 14:01:32 / cg"
!

width:w height:h fromArray:anArray
    "create a new image, given width, height. Assume a depth of 1 of the
     receiving class is Image.
     Data must be a ByteArray containing correctly aligned bits for depth 1
     (i.e. 8 bits per byte)."

    |cls d pixels|

    cls := self.
    cls == Image ifTrue:[
        cls := self implementorForDepth:1.
        d := 1.
    ] ifFalse:[
        d := cls imageDepth
    ].
    anArray class isBytes ifFalse:[
        pixels := ByteArray withAll:anArray
    ] ifTrue:[
        pixels := anArray
    ].
    ^ cls new width:w height:h depth:d fromArray:pixels

    "
     Image width:8
           height:8
           fromArray:#[2r11001100
                       2r00110011
                       2r11001100
                       2r00110011
                       2r11001100
                       2r00110011
                       2r11001100
                       2r00110011].
    "

    "Modified: 8.6.1996 / 10:07:26 / cg"
!

width:w height:h photometric:photometric
    "create a new image, given width, height.
     Assume a depth of 1, unless an explicit imageClass is the receiver."

    |cls|

    cls := self.
    cls == Image ifTrue:[
        cls := self implementorForDepth:1
    ].
    ^ cls new width:w height:h; photometric:photometric; yourself

    "Modified: / 06-06-2007 / 11:10:55 / cg"
!

width:w height:h photometric:photometric bitsPerSample:bitsPerSample
    "create a new image, given width, height.
     Assume a depth of 1, unless an explicit imageClass is the receiver."

    |cls|

    cls := self.
    cls == Image ifTrue:[
        cls := self implementorForDepth:1
    ].
    ^ cls new width:w height:h; photometric:photometric; bitsPerSample:bitsPerSample; yourself

    "Modified: / 06-06-2007 / 11:10:55 / cg"
! !

!Image class methodsFor:'Signal constants'!

badImageFormatQuerySignal
    "return the (query-) signal, which is raised if some
     bitmap-image could not be loaded due to an unrecognized format.
     If unhandled, the image-load returns nil.
     Otherwise, it returns whatever the handler proceeds with.
     The exception gets either the images fileName or an input stream
     as parameter"

    ^ BadImageFormatQuerySignal

    "Created: 1.2.1997 / 14:40:29 / cg"
!

cannotRepresentImageSignal
    "return the signal, which is raised if some
     bitmap-image could not be saved in the requested format.
     This happens for example, if a true color image is saved in
     xpm format or a color image saved in xbm format.
     Applications should either ask the class before saving
     (via #canRepresent:) or handle the error and use an alternative
     format then."

    ^ CannotRepresentImageSignal

    "Created: 27.2.1997 / 12:24:43 / cg"
!

fileCreationErrorSignal
    "return the signal which is raised if a file could not be
     created in an image-save operation."

    ^ FileCreationErrorSignal

    "Created: 27.2.1997 / 12:32:59 / cg"
!

imageErrorSignal
    "return the parent of all image signals"

    ^ ImageErrorSignal

    "Created: / 30.9.1998 / 21:59:08 / cg"
!

imageLoadErrorSignal
    "return the parent of all image load error signals"

    ^ ImageLoadErrorSignal

    "Created: / 18.5.1999 / 15:42:05 / cg"
!

imageNotFoundQuerySignal
    "return the (query-) signal, which is raised if some
     bitmap-image could not be loaded from a file.
     If unhandled, the image-load returns nil.
     Otherwise, it returns whatever the handler proceeds with.
     The exception gets the images fileName as parameter"

    ^ ImageNotFoundQuerySignal

    "Created: 7.1.1997 / 16:04:49 / cg"
!

imageSaveErrorSignal
    "return the parent signal of all image-save errors."

    ^ ImageSaveErrorSignal

    "Created: 27.2.1997 / 12:32:23 / cg"
!

informationLostQuerySignal
    "return the (query-) signal, which is raised if some
     bitmap-image is saved in a format which cannot represent
     the full image (for example: the images mask).
     If unhandled, the image-save proceeds.
     Otherwise, the handler may show a warn box or whatever and decide
     to proceed or abort the saving."

    ^ InformationLostQuerySignal

    "Created: 27.2.1997 / 12:43:50 / cg"
!

unrepresentableColorSignal
    "return the signal, which is raised if some color is not
     representable in the image (when storing a pixel)."

    ^ UnrepresentableColorSignal

    "Created: 1.2.1997 / 14:40:29 / cg"
! !

!Image class methodsFor:'cleanup'!

releaseResourcesOnDevice:aDevice
    "this is sent when a display connection is closed,
     to release all cached Images from that device"

    Lobby
        unregisterAllForWhichHandle:[:eachImage |
            |ok|

            ok := eachImage graphicsDevice == aDevice.
            ok ifTrue:[
                eachImage releaseFromDevice
            ].
            ok
        ].

    Icon notNil ifTrue:[
        Icon releaseCachedIconsFromDevice:aDevice.
    ].
    MenuPanel notNil ifTrue:[
        MenuPanel releaseCachedImagesFromDevice:aDevice.
    ].


    "
      self releaseResourcesOnDevice:Screen current
    "

    "Created: 16.1.1997 / 19:30:44 / cg"
    "Modified: 16.1.1997 / 19:33:49 / cg"
! !

!Image class methodsFor:'file reading'!

fromFile:aFileName
    "read an image from a file - this methods tries to find
     out the file format itself (by the extension and by contents)
     and lets the appropriate reader read the file.
     Also, unless the path is absolute,
     all bitmap directories along the searchPath are checked
     for the file; thus, you can place your private images into a
     separate directory, thereby overriding system bitmaps easily.
     If the file is unreadable or does not contain an appropriate image,
     the ImageNotFoundQuerySignal is raised, which may be handled to
     proceed with some replacement image. If unhandled, nil is returned."

    |image fn nm inStream suffix readerClass
     mustDecompress readersErrorMsg|

    "before trying each reader, check if the file is readable"

    fn := aFileName asFilename.
    fn isAbsolute ifFalse:[
        inStream := Smalltalk systemFileStreamFor:fn.
        inStream isNil ifTrue:[
            inStream := Smalltalk bitmapFileStreamFor:fn.
            inStream isNil ifTrue:[
                "this signal is a query - if noone seems to care, return nil.
                 However, a handler may provide a replacement image."
                ^ ImageNotFoundQuerySignal
                            raiseRequestWith:fn
                            errorString:('Image: ''' , fn pathName, ''' does not exist or is not readable').
            ].
        ].
        fn := inStream pathName asFilename.
        inStream close.
    ].

    nm := fn name.
    suffix := fn suffix.

    "handle compressed-suffix"
    (#('gz') includes:suffix) ifTrue:[
        |baseFn|

        baseFn := fn withoutSuffix.
        nm := baseFn name.
        suffix := baseFn suffix.
        mustDecompress := true.
    ].
    suffix isEmpty ifTrue:[
        suffix := nm.
    ].

    "get the imageReader class from the file's extension and ask it first"
    readerClass := MIMETypes imageReaderForSuffix:suffix.
    readerClass notNil ifTrue:[
        mustDecompress == true ifTrue:[
            |zipStream|
            inStream := fn readStream.
            zipStream := ZipStream readOpenOn:inStream suppressHeaderAndChecksum:true.
            zipStream notNil ifTrue:[
                image := [
                    readerClass fromStream:zipStream.
                ] ensure:[
                    zipStream close.
                    inStream close.
                ].
            ]
        ] ifFalse:[
            BadImageFormatQuerySignal handle:[:ex |
                BadImageFormatQuerySignal isHandled ifTrue:[
                    ex reject
                ].
                readersErrorMsg := ex description.
                Logger warning:readersErrorMsg.
                image := nil.
                ex return.
            ] do:[
                image := readerClass fromFile:fn.
            ].
        ].
        image notNil ifTrue:[^ image].
    ].

    (readerClass isNil or:[readersErrorMsg notNil]) ifTrue:[
        "no known extension (or wrong extension)
         - ask all readers if they know this format ...
         ... these look into the file, and investigate the header.
         therefore, it takes a bit longer."

        MIMETypes imageReaderClasses do:[:mimeReaderClass |
            (mimeReaderClass notNil
            and:[mimeReaderClass ~~ readerClass]) ifTrue:[
               (mimeReaderClass isValidImageFile:fn) ifTrue:[
                    image := mimeReaderClass fromFile:fn.
                    image notNil ifTrue:[
                        ^ image
                    ]
                ]
            ]
        ].
    ].

    (fn exists and:[fn isReadable]) ifFalse:[
        ^ ImageNotFoundQuerySignal
                    raiseRequestWith:fn
                    errorString:('Image: ''' , fn pathName, ''' does not exist or is not readable').
    ].

    "nope - unknown format
     this signal is a query - if noone seems to care, return nil.
     However, a handler may provide a replacement image."

    ^ BadImageFormatQuerySignal
        raiseRequestWith:fn
        errorString:(readersErrorMsg ? ('Image: unknown image file format: ''' , fn pathName , '''')).

    "
     Image fromFile:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies'
     Image fromFile:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'

     Image fromFile:'bitmaps/winBitmaps/a11.ico' inPackage:'stx:goodies'
     Image fromFile:'bitmaps/xpmBitmaps/countries/czech.xpm' inPackage:'stx:goodies'
     Image fromFile:'bitmaps/xpmBitmaps/countries/czech.xpm.gz' inPackage:'stx:goodies'
     Image fromFile:'Demos/bitmaps/hello_world.icon' inPackage:'stx:clients'
    "

    "
     Image fromFile:'fooBar'
    "

    "giving a message for non-existing images:

     Image imageNotFoundQuerySignal
     handle:[:ex |
        Transcript showCR:ex description.
        ex proceedWith:nil
     ] do:[
         Image fromFile:'fooBar'
     ]
    "

    "giving a replacement for non-existing images:

     Image imageNotFoundQuerySignal
     answer:(Image fromFile:'libtool/bitmaps/SmalltalkX.xbm')
     do:[
         Image fromFile:'fooBar'
     ]
    "

    "Modified: / 19-11-2007 / 15:50:52 / cg"
    "Modified: / 31-01-2017 / 15:56:14 / stefan"
!

fromFile:aFileName inPackage:aPackage
    "read an image for a package from a file.
     The filename is assumed to be package-relative (i.e. bitmaps/filename).
     This methods tries to find out the file format itself (by the extension and by contents)
     and lets the appropriate reader read the file.
     Also, all bitmap directories along the searchPath are checked
     for the file; thus, you can place your private images into a
     separate directory, thereby overriding system bitmaps easily.
     If the file is unreadable or does not contain an appropriate image,
     the ImageNotFoundQuerySignal is raised, which may be handled to
     proceed with some replacement image. If unhandled, nil is returned."

    ^ Smalltalk imageFromFileNamed:aFileName inPackage:aPackage

    "
     Image fromFile:'libtool/bitmaps/SBrowser.xbm'
     Image fromFile:'bitmaps/SBrowser.xbm' inPackage:'stx:libtool'
     Image fromFile:'garfield.gif' inPackage:'stx:goodies/bitmaps/gifImages'
    "
!

fromFile:aFileName on:aDevice
    "read an image from a file and prepare a device representation.
     Return nil (or whatever a handler returned),
     if the file is unreadable or does not contain an appropriate image."

    |img|

    img := self fromFile:aFileName.
    img notNil ifTrue:[
        ^ img onDevice:aDevice
    ].
    ^ nil

    "Modified: 1.2.1997 / 14:48:07 / cg"
!

fromFile:aFileName resolution:res
    "read an image from a file and (if required) scale the image
     as appropriate (only req'd for very high resolution displays).
     Return nil (or whatever a handler returned),
     if the file is unreadable or does not contain an appropriate image."

    ^ self fromFile:aFileName resolution:res on:nil

    "Created: 19.12.1996 / 14:02:13 / cg"
    "Modified: 1.2.1997 / 14:48:16 / cg"
!

fromFile:aFileName resolution:dpi on:aDevice
    "read an image from a file and (if required) scale the image
     as appropriate (only req'd with very high resolution displays).
     Prepare a device representation.
     Return nil (or whatever a handler returned),
     if the file is unreadable or does not contain an appropriate image."

    |img dev dpiH mag|

    img := self fromFile:aFileName.
    img isNil ifTrue:[^ nil].

    "if the devices resolution is within +- 50% of dpi, no magnify is needed"
    dev := aDevice.
    dev isNil ifTrue:[
        "should not happen ..."
        dev := Screen current
    ].

    dev notNil ifTrue:[
        dpiH := dev horizontalPixelPerInch.
    ] ifFalse:[
        dpiH := 90
    ].
    (dpi between:(dpiH * 0.75) and:(dpiH * 1.5)) ifTrue:[
        ^ img
    ].
    mag := (dpiH / dpi) rounded.
    mag = 0 ifTrue:[^ img].
    mag = 1 ifTrue:[^ img].

    img := img magnifiedBy:(mag @ mag).
    aDevice notNil ifTrue:[
        ^ img onDevice:aDevice
    ].
    ^ img

    "Modified: / 01-02-1997 / 14:48:20 / cg"
    "Modified (format): / 31-01-2017 / 15:06:23 / stefan"
!

fromStream:aStream
    "read an image from a stream - this methods tries to find
     out the file format itself (by contents)
     and lets the appropriate reader read the file.
     To do this, the stream must be positionable.
     Return nil (or whatever a handler returned),
     if the stream does not contain an appropriate image."

    |image|

    "
     ask all readers if they know
     this format ...
    "
    MIMETypes imageReaderClasses do:[:readerClass |
        readerClass notNil ifTrue:[
            image := readerClass fromStream:aStream.
            image notNil ifTrue:[^ image].
        ]
    ].

    "
     nope - unknown format
    "
"/    'Image [info]: unknown image file format in stream: ' infoPrintCR.

    ^ ImageNotFoundQuerySignal
                raiseRequestWith:aStream
                errorString:('Image [warning]: unknown image file format in stream').

    "
     Image fromFile:'goodies/bitmaps/gifImages/claus.gif'
     Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'

     Image fromFile:'clients/Animation/bitmaps/globe1.xbm'
     Image fromFile:'clients/Animation/bitmaps/globe1.xbm.Z'
     Image fromFile:'clients/Demos/bitmaps/hello_world.icon'

     Image fromFile:'librun/stx.ico'
     Image fromFile:'libwidg3/bitmaps/wall.tiff'

     Image fromFile:'goodies/bitmaps/test.fax'
     Image fromFile:'fileIn/bitmaps/founders.im8'
     Image fromFile:'goodies/faces/next.com/steve.face'
    "

    "Created: 13.9.1996 / 18:06:00 / cg"
    "Modified: 30.6.1997 / 22:03:59 / cg"
!

fromStream:aStream using:aReaderClass
    "read an image from a stream, given an imageReaderClass.
     Use this, if you know the file's format, but it has an invalid
     extension (or non-definite header), so #fromStream: could not
     find out the images format.
     Return nil (or whatever a handler returned),
     if the stream does not contain an appropriate image."

    |image|

    image := aReaderClass fromStream:aStream.
    image notNil ifTrue:[^ image].

    "
     nope - unknown format
    "
"/    'Image [info]: unknown image file format in stream: ' infoPrintCR.

    ^ ImageNotFoundQuerySignal
                raiseRequestWith:aStream
                errorString:('Image: unknown image file format in stream').

    "Created: 1.2.1997 / 14:46:20 / cg"
    "Modified: 1.2.1997 / 14:48:53 / cg"
! !

!Image class methodsFor:'misc'!

ditherAlgorithm
    "return the way we dither -
        #threshold, or nil        -> no dither
        #pattern, or #ordered     -> orderedDither (ugly, but fast)
        #error or #floydSteinberg -> errorDiffusion; much better
        #burkes                   -> errorDiffusion; even better."

    ^ DitherAlgorithm

    "Created: 17.6.1996 / 18:57:47 / cg"
!

ditherAlgorithm:aSymbol
    "define how to dither -
        #threshold, or nil        -> no dither
        #pattern, or #ordered     -> orderedDither (ugly, but fast)
        #error or #floydSteinberg -> errorDiffusion; much better
        #burkes                   -> errorDiffusion; even better."

    DitherAlgorithm := aSymbol

    "
     Image dither:#pattern
     Image dither:#floydSteinberg
     Image dither:#burkes
     Image dither:nil
    "

    "Modified: 10.6.1996 / 12:27:09 / cg"
    "Created: 17.6.1996 / 18:57:19 / cg"
!

numberOfDitherColors:n
    "define how many colors (i.e. patterns) to use when
     doing a pattern dither"

    NumberOfDitherColors := n
!

orderedDitherMatrixOfSize:sz
    sz == 2 ifTrue:[
        ^ #[
                0 2
                3 1
           ].
    ].

    sz == 4 ifTrue:[
        ^ #[
                 0  8  2 10
                12  4 14  6
                 3 11  1  9
                15  7 13  5
           ].
    ].

    sz == 8 ifTrue:[
        ^  #[
                0 32  8 40    2 34 10 42
               48 16 56 24   50 18 58 26
               12 44  4 36   14 46  6 38
               60 28 52 20   62 30 54 22

                3 35 11 43    1 33  9 41
               51 19 59 27   49 17 57 25
               15 47  7 39   13 45  5 37
               63 31 55 23   61 29 53 21
            ].
    ].

    ^ nil

    "Created: 7.6.1996 / 14:15:05 / cg"
! !

!Image class methodsFor:'queries'!

bytesPerRowForWidth:width depth:bitsPerPixel padding:padding
    "helper - return the number of bytes in one scanline of an image,
     if scanlines are to be padded to padding-bits and the depth of the image is d."

    |bitsPerRow paddedUnitsPerRow|

    bitsPerRow := width * bitsPerPixel.
    paddedUnitsPerRow := bitsPerRow // padding.
    ((bitsPerRow \\ padding) ~~ 0) ifTrue:[
        paddedUnitsPerRow := paddedUnitsPerRow + 1
    ].
    ^ paddedUnitsPerRow * (padding // 8)

    "
     self bytesPerRowForWidth:7 depth:1 padding:8
     self bytesPerRowForWidth:7 depth:1 padding:16
     self bytesPerRowForWidth:7 depth:1 padding:32

     self bytesPerRowForWidth:15 depth:1 padding:8
     self bytesPerRowForWidth:15 depth:1 padding:16
     self bytesPerRowForWidth:15 depth:1 padding:32
    "
!

defaultImageFileWriter
    "only used, if a file is saved with no particular extension
     or explicit writer given.
     For now, default to tiff format.
     Will change to png, as soon as all mask formats are fully supported by it"

    ^ TIFFReader
!

defaultPhotometric
    "return the default photometric pixel interpretation.
     This may be a somewhat old leftover from times, when tiff was the first image file type to be read.
     Much better would be to always have some (possibly fake and virtual) colormap around, and ask that one.
     However, in the meantime, many other classes depend on that, so that it should be kept as an API
     - even when the internal representation will be replaced by something better in the future."

    ^ #blackIs0

    "Modified: 20.4.1996 / 23:40:41 / cg"
    "Created: 10.6.1996 / 18:08:12 / cg"
!

imageDepth
    "return the depth of images represented by instances of
     this class.
     Must be redefined in concrete subclasses"

    ^ self subclassResponsibility

    "Modified: 20.4.1996 / 23:40:41 / cg"
!

imageFileSuffixes
    "return a collection of suffixes which are recognized as image-file suffix"

    ^ MIMETypes imageFileSuffixes

    "
     Image imageFileSuffixes
    "

    "Modified: 30.6.1997 / 22:04:39 / cg"
!

imageReaderClassForMIME:mimeType
    "return an appropriate imageReader class for a given mime type;
     nil if there is none (or it did not install itself)"

    ^ MIMETypes imageReaderForType:mimeType

    "
     Image imageReaderClassForMIME:'image/tiff'
     Image imageReaderClassForMIME:'image/x-portable-pixmap'
    "

    "Created: 24.6.1997 / 22:32:27 / cg"
    "Modified: 30.6.1997 / 21:54:10 / cg"
!

imageReaderClassForSuffix:aSuffix
    "return an appropriate imageReader class for a given file-suffix;
     nil if there is none (or it did not install itself)"

    ^ MIMETypes imageReaderForSuffix:aSuffix

    "
     Image imageReaderClassForSuffix:'tiff'
     Image imageReaderClassForSuffix:'foo'
    "

    "Modified: 30.6.1997 / 22:05:14 / cg"
!

implementorForDepth:depth
    "return the class, which best implements images of depth"

    depth == 1 ifTrue:[^ Depth1Image].
    depth == 2 ifTrue:[^ Depth2Image].
    depth <= 4 ifTrue:[^ Depth4Image].
    depth <= 8 ifTrue:[^ Depth8Image].
    depth <= 16 ifTrue:[^ Depth16Image].
    depth <= 24 ifTrue:[^ Depth24Image].
    depth <= 32 ifTrue:[^ Depth32Image].
    depth <= 48 ifTrue:[^ Depth48Image].
    depth <= 64 ifTrue:[^ Depth64Image].
    ^ self

    "Modified: 24.4.1997 / 19:04:52 / cg"
!

isAbstract
    ^ self == Image
!

isImageFileSuffix:aSuffix
    "return true, if the given suffix is known to be an image files suffix"

     ^ self imageFileSuffixes includes:(aSuffix asLowercase)

    "
     Image isImageFileSuffix:'gif'
     Image isImageFileSuffix:'xbm'
     Image isImageFileSuffix:'foo'
    "

    "Created: 18.4.1997 / 14:55:28 / cg"
!

mimeTypeFromSuffix:suffix
    "search my suffix information for a mime type and
     return it; return nil if unknown"

    ^ MIMETypes mimeTypeForSuffix:suffix

    "
     Image mimeTypeFromSuffix:'gif'
     Image mimeTypeFromSuffix:'tiff'
     Image mimeTypeFromSuffix:'foobar'
    "

    "Modified: 1.7.1997 / 00:17:27 / cg"
! !

!Image class methodsFor:'screen capture'!

fromScreen
    "return an image of the full screen.
     WARNING: this temporarily grabs the display
              it may not work from within a buttonMotion
              (use #fromScreen:on:grab: with a false grabArg then)."

    |display|

    display := Screen current.
    ^ self
        fromScreen:(0@0 corner:(display width @ display height))
        on:display
        grab:true

    "
     Image fromScreen
     Image fromScreen inspect
    "

    "Modified: 26.3.1997 / 10:44:55 / cg"
!

fromScreen:aRectangle
    "return an image of a part of the screen.
     WARNING: this temporarily grabs the display
              it may not work from within a buttonMotion
              (use #fromScreen:on:grab: with a false grabArg then)."

    ^ self
        fromScreen:aRectangle
        on:Screen current
        grab:true

    "
     Image fromScreen:(0@0 corner:100@100)
     (Image fromScreen:(0@0 corner:100@100)) inspect
    "

    "Modified: 26.3.1997 / 10:45:02 / cg"
!

fromScreen:aRectangle on:aDevice
    "return an image of a part of a screen, which may be on
     another display device.
     WARNING: this temporarily grabs the display
              it may not work from within a buttonMotion
              (use #fromScreen:on:grab: with a false grabArg then)."

    ^ self
        fromScreen:aRectangle
        on:aDevice
        grab:true

    "
     Image fromScreen:(0@0 corner:100@100)
    "

    "get a snapshot of your friends screen ...

     |dpy2|

     dpy2 := XWorkstation new initializeFor:'idefix:0'.
     (Image fromScreen:(dpy2 bounds) on:dpy2) inspect
    "

    "Modified: 26.3.1997 / 10:45:08 / cg"
!

fromScreen:aRectangle on:aDisplay grab:doGrab
    "return an image of a part of the screen, which may be on
     another Display. If the doGrab argument is true, the display
     is grabbed (i.e. blocked for others) and a camera cursor is
     shown while the readout is done.
     WARNING: with doGrab true, this temporarily grabs the display
              and it may not work from within a buttonMotion
              (use with a false grabArg then)."

    |depth vis img tmpFile util|

    aDisplay supportsScreenReading ifFalse:[
        tmpFile := Filename newTemporary withSuffix:'png'.

        "/ Workaround for issue #190: Since XWayland does not seem to support
        "/ XGetImage() at all, we have to use some other way how to get a screenshot.
        "/ To make it even more complicated, this depends on a compositor used. Sigh.
        "/ 
        "/ The code below works only under a GNOME shell. For other compositors or
        "/ desktop environments we'd have to add another hack.
        "/ 
        "/ See https://swing.fit.cvut.cz/projects/stx-jv/ticket/190
        "/ 
        (OperatingSystem isUNIXlike and:[OperatingSystem isOSXlike not]) ifTrue:[
            "/ Note that here we don't have to check whether we're running under
            "/ Wayland, this is checked in XWorkstation >> supportsScreenReading.
            ((OperatingSystem getEnvironment: 'XDG_SESSION_DESKTOP') = 'gnome') ifTrue:[ 
                (OperatingSystem canExecuteCommand:'dbus-send') ifTrue:[ 
                    OperatingSystem executeCommand: ('dbus-send --session --type=method_call --dest="org.gnome.Shell.Screenshot" "/org/gnome/Shell/Screenshot" org.gnome.Shell.Screenshot.ScreenshotArea  int32:%1 int32:%2 int32:%3 int32:%4 boolean:false string:"%5"'
                                                    bindWith:aRectangle left
                                                        with:aRectangle top
                                                        with:aRectangle width
                                                        with:aRectangle height
                                                        with:tmpFile pathName).
                    tmpFile exists ifFalse:[ 
                        Delay waitForMilliseconds: 100.
                        tmpFile exists ifFalse:[
                            Delay waitForMilliseconds: 100.
                            tmpFile exists ifFalse:[
                                Delay waitForMilliseconds: 100.
                                tmpFile exists ifFalse:[
                                    ^ nil
                                ]
                            ]
                        ]
                    ].
                    ^ [
                        (Image fromFile:tmpFile)
                            mask: nil;
                            yourself
                    ] ensure:[
                        tmpFile remove.
                    ].
                ] ifFalse:[ 
                    Logger warn: 'Cannot execute `dbus-send`'.
                ].
            ] ifFalse:[ 
                Logger warn: 'Unsupported UNIX desktop, cannot grab screen.'.
            ].
        ].

        "/ workaround: look for a helper utility in support/<os>/screenshot
        "/ currently there is one for osx.
        util := Smalltalk packageDirectory asFilename / ('../support/',OperatingSystem getSystemType,'/screenshot').
        util exists ifTrue:[
            OperatingSystem executeCommand:('%1 %2 png %3 %4 %5 %6'
                                                bindWith:util pathName
                                                with:tmpFile pathName
                                                with:aRectangle left
                                                with:aRectangle top
                                                with:aRectangle width
                                                with:aRectangle height).
            ^ [
                Image fromFile:tmpFile.
            ] ensure:[
                tmpFile remove.
            ].
        ].
    ].

    depth := aDisplay depth.

    "/
    "/ for truecolor displays, return a Depth24Image
    "/ (must do this for depth15 & depth16 displays, since
    "/  Depth16Image has no way to specify r/g/b masks ...)
    "/
    vis := aDisplay visualType.
    (vis == #TrueColor or:[vis == #DirectColor]) ifTrue:[
        depth > 8 ifTrue:[
            depth := 24.
        ]
    ].

    img := self newForDepth:depth.
    ^ img fromScreen:aRectangle on:aDisplay grab:doGrab

    "
    Image fromScreen: ((100 @ 100) extent: (300 @ 200)) on: Screen current grab: false
    "

    "Modified: / 26-01-1998 / 22:23:08 / cg"
    "Modified: / 30-01-2017 / 19:49:01 / stefan"
    "Modified: / 06-01-2018 / 23:22:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 08-01-2018 / 09:00:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromScreenArea
    "return an image of a part of the screen;
     let user specify screen area.
     This is the same as #fromUser - kept for backward compatibility.
     Use #fromUser for ST-80 compatibility.
     WARNING: this temporarily grabs the display
              it may not work from within a buttonMotion
              (use #fromScreen:on:grab: with a false grabArg then)."

    |r|

    [Screen current leftButtonPressed] whileTrue:[Delay waitForSeconds:0.05].
    r := Rectangle fromUser.
    r width == 0 ifTrue:[^ nil].
    r height == 0 ifTrue:[^ nil].
    ^ self fromScreen:r

    "
     Image fromScreenArea
     Image fromScreenArea inspect
    "

    "Modified: / 10.9.1998 / 15:59:58 / cg"
!

fromUser
    "return an image of a part of the screen; let user specify screen area.
     Same as fromScreenArea, for ST-80 compatibility.
     WARNING: this temporarily grabs the display
              it may not work from within a buttonMotion
              (use #fromScreen:on:grab: with a false grabArg then)."

    ^ self fromScreenArea

    "
     Image fromUser
     Image fromUser inspect
    "

    "Modified: 26.3.1997 / 10:45:25 / cg"
!

fromView:aView
    "return an image taken from a views contents as currently
     on the screen. The returned image has the same depth and photometric
     as the Display.
     Notice that for invisible or partial covered views,
     the returned Image is NOT correct.
     You may want to raise the view before using this method.
     WARNING: this temporarily grabs the display
              it may not work from within a buttonMotion
              (use #fromView:grab: with a false grabArg then)."

    ^ self
        fromView:aView
        grab:true

    "
     Image fromView:(Launcher allInstances first window topView)
     Image fromView:(BrowserView allInstances first topView)
    "

    "get a snapshot from whichever view is active:

     |active|

     active := WindowGroup activeGroup topViews first.
     (Image fromView:active) inspect
    "

    "Modified: 9.9.1996 / 22:41:01 / stefan"
    "Modified: 26.3.1997 / 10:45:40 / cg"
!

fromView:aView grab:doGrab
    "return an image taken from a views contents as currently
     on the screen. If the doGrab argument is true, the display
     is grabbed (i.e. blocked for others) and a camera cursor is
     shown while the readout is done.
     The returned image has the same depth and photometric
     as the Display.
     Notice that for invisible or partial covered views,
     the returned Image is NOT correct.
     You may want to raise the view before using this method.
     WARNING: with doGrab true, this temporarily grabs the display
              and it may not work from within a buttonMotion
              (use with a false grabArg then)."

    ^ self fromView:aView grab:doGrab withDecoration:false

    "Created: / 26.3.1997 / 10:34:20 / cg"
    "Modified: / 10.10.2001 / 14:13:29 / cg"
!

fromView:aView grab:doGrab withDecoration:withDecoration
    "return an image taken from a views contents as currently
     on the screen, optionally with decoration included.
     If the doGrab argument is true, the display
     is grabbed (i.e. blocked for others) and a camera cursor is
     shown while the readout is done.
     The returned image has the same depth and photometric
     as the Display.
     Notice that for invisible or partial covered views,
     the returned Image is NOT correct.
     You may want to raise the view before using this method.
     WARNING: with doGrab true, this temporarily grabs the display
              and it may not work from within a buttonMotion
              (use with a false grabArg then)."

    |org ext viewsDevice cH bW bH|

    viewsDevice := aView graphicsDevice.
    org := viewsDevice translatePoint:(0@0) fromView:aView toView:nil.
    ext := aView extent.
    withDecoration ifTrue:[
        viewsDevice isWindowsPlatform ifTrue:[
            cH := viewsDevice captionHeight.
            bW := (viewsDevice getSystemMetrics: #SM_CXFRAME )
                  "+ ( device getSystemMetrics: #borderFrameWidth )".
            bH := (viewsDevice getSystemMetrics: #SM_CYFRAME )
                  " + ( device getSystemMetrics: #borderFrameHeight )".
            org := org - (bW @ (bH + cH)).
            ext := ext + ((bW + bW) @ (bH+bH+cH)).
        ].
    ].
    ^ self fromScreen:(org extent:ext) on:viewsDevice grab:doGrab

    "
     Transcript topView raise. (Image fromView:Transcript topView grab:false withDecoration:false) inspect
     Transcript topView raise. (Image fromView:Transcript topView grab:false withDecoration:true) inspect
    "

    "Created: / 26-03-1997 / 10:34:20 / cg"
    "Modified: / 08-09-2006 / 15:41:41 / cg"
! !

!Image methodsFor:'Compatibility-Squeak'!

boundingBox

    ^ self bounds
!

colormapIfNeededForDepth:d
    ^ nil


!

colorsFromArray:anArrayOfRGBTriples
    "for squeak compatibility with ColorForm:
     set the colorMap from an array of rgb triples, each value being in 0..1."

    |newMap|

    newMap := Colormap new:anArrayOfRGBTriples size.
    anArrayOfRGBTriples doWithIndex:[:rgb :i |
        newMap at:i putRGBTriple:rgb
    ].
    self colorMap:newMap.

    "
     Depth8Image new
        colorsFromArray:#( (0.5 0.5 0.5) (0.25 0.0 0.0) (0.0 0.25 0.5))
    "
!

fill:aRectangle fillColor:aColor
    "fill the rectangular area specified by aRectangle with the given color"

    self fillRectangle:aRectangle withColor:aColor
!

fillBlack:aRectangle
    "fill the rectangular area specified by aRectangle with the black color"

    self fillRectangle:aRectangle withColor:Color black

    "
     |img|
     img := Image extent:100@100 depth:24.
     img photometric:#rgb.
     img data:(ByteArray new:100*100*3).
     img fillWhite:(0@0 corner:100@100).
     img fillBlack:(10@10 corner:90@90).
     img inspect.
    "
!

fillWhite:aRectangle
    "fill the rectangular area specified by aRectangle with the white color"

    self fillRectangle:aRectangle withColor:Color white
!

isTransparentAt:aPoint
    mask isNil ifTrue:[ ^ false].
    ^ (mask pixelAt:aPoint) == 0
! !

!Image methodsFor:'Compatibility-VW'!

asCachedImage
    "return the receiver associated to the current screens device.
     For ST-80 compatibility
     (ST/X uses Image for both device- and nonDevice-images)"

    ^ self onDevice:Screen current

    "Modified: 23.4.1996 / 11:10:32 / cg"
!

asRetainedMedium
    "return the receiver associated to the current screens device.
     For ST-80 compatibility
     (ST/X uses Image for both device- and nonDevice-images)"

    ^ self onDevice:Screen current

    "Modified: 23.4.1996 / 11:10:32 / cg"
    "Created: 27.1.1997 / 15:49:08 / cg"
!

bounds:newBounds
    ^ self

    "Created: 10.2.1997 / 12:44:46 / cg"
!

containsPoint:aPoint
    "in st-80, images are visualComponents ..."

    ^ self bounds containsPoint:aPoint

    "Created: 6.3.1997 / 15:24:12 / cg"
!

convertToPalette:aColormap renderedBy:anImageRenderer
    "this does not really mimicri the corresponding ST-80 functionality"

    |monoBits convertedImage|

    aColormap size == 2 ifTrue:[
        anImageRenderer class == OrderedDither ifTrue:[
            monoBits := self orderedDitheredMonochromeBits.
        ] ifFalse:[
            monoBits := self floydSteinbergDitheredMonochromeBits.
        ].
        (((aColormap at:1) = Color black)
        and:[(aColormap at:2) = Color white]) ifTrue:[
            "/ ok
        ] ifFalse:[
            (((aColormap at:1) = Color white)
            and:[(aColormap at:2) = Color black]) ifTrue:[
                monoBits invert
            ]
        ].
        convertedImage := Depth1Image width:width height:height fromArray:monoBits.
        convertedImage palette:aColormap.
        ^ convertedImage
    ].

    self error:'unimplemented operation'.
    ^ self

    "Modified: 1.3.1997 / 17:25:50 / cg"
!

paintBasis
    "huh - whats that;
     I guess, I have to return Color for images without a mask,
     and CoverageValue for those with a mask; for now, always return Color"

    ^ ColorValue

    "Created: 6.3.1997 / 15:24:19 / cg"
!

preferredBounds
    ^ self bounds

    "Created: 10.2.1997 / 12:42:36 / cg"
!

tile:bounds from:origin in:tile rule:rule
    |orgX orgY tW tH|

    origin ~= (0@0) ifTrue:[
        self shouldImplement.
    ].
    bounds ~= self bounds ifTrue:[
        self shouldImplement.
    ].
    rule ~= #over ifTrue:[
        self shouldImplement.
    ].

    orgX := origin x.
    orgY := origin y.
    tW := tile width.
    tH := tile height.
    (bounds top) to:(bounds bottom) by:tH do:[:dstY |
        (bounds left) to:(bounds right) by:(tile width) do:[:dstX |
            self
                copyFrom:tile
                x:orgX y:orgY
                toX:dstX y:dstY
                width:tW height:tH.
        ].
    ].
!

valueAtPoint:aPoint put:aColorValue
    aColorValue isInteger ifFalse:[
        self colorAtX:aPoint x y:aPoint y put:aColorValue
    ] ifTrue:[
        self pixelAtX:aPoint x y:aPoint y put:aColorValue
    ]
! !

!Image methodsFor:'accessing'!

bitsARGB32
    | bitsARGB32 |

    bitsARGB32 := ByteArray new: width * height * 4.
    self bitsARGB32Into: bitsARGB32.
    ^ bitsARGB32

    "Created: / 01-09-2015 / 18:02:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bitsARGB32Into: buffer
    self bitsARGB32Into: buffer startingAt: 1

    "Created: / 01-09-2015 / 17:18:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bitsARGB32Into: buffer startingAt: first
    self bitsARGB32Into: buffer startingAt: first stride: width

    "Created: / 01-09-2015 / 17:18:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bitsARGB32Into: buffer startingAt: first stride: stride
    "Store each pixel is a 32-bit quantity, with alpha in the upper 
     8 bits, then red, then green, then blue. The 32-bit quantities are 
     stored native-endian. Pre-multiplied alpha is used. (That is, 50% 
     transparent red is 0x80800000, not 0x80ff0000.)"

    mask isNil ifTrue:[ 
        0 to: height - 1 do:[:y |  
            | base |
            base := (first - 1) + (y * stride).
            0 to: width - 1 do:[:x |  
                | pixel color offset |

                offset := base + (x * 4).    
                pixel := self pixelAtX: x y: y.
                color := self colorFromValue: pixel.
                buffer at: (offset + ARGB_R_OFFSET_MACHINE) put: color redByte.  
                buffer at: (offset + ARGB_G_OFFSET_MACHINE) put: color greenByte.  
                buffer at: (offset + ARGB_B_OFFSET_MACHINE) put: color blueByte.  
                buffer at: (offset + ARGB_A_OFFSET_MACHINE) put: 16rFF.   
            ]
        ]
    ] ifFalse:[ 
    mask depth == 1 ifTrue:[ 
        0 to: height - 1 do:[:y |  
            | base |

            base := (first - 1) + (y * stride).
            0 to: width - 1 do:[:x |  
                | pixel color offset |

                offset := base + (x * 4).
                (mask pixelAtX: x y:y) ifTrue:[ 
                    pixel := self pixelAtX: x y: y.
                    color := self colorFromValue: pixel.
                    buffer at: (offset + ARGB_R_OFFSET_MACHINE) put: color redByte.  
                    buffer at: (offset + ARGB_G_OFFSET_MACHINE) put: color greenByte.  
                    buffer at: (offset + ARGB_B_OFFSET_MACHINE) put: color blueByte.  
                    buffer at: (offset + ARGB_A_OFFSET_MACHINE) put: 16rFF.
                ] ifFalse:[ 
                    buffer at: (offset + ARGB_R_OFFSET_MACHINE) put: 0.  
                    buffer at: (offset + ARGB_G_OFFSET_MACHINE) put: 0.  
                    buffer at: (offset + ARGB_B_OFFSET_MACHINE) put: 0.  
                    buffer at: (offset + ARGB_A_OFFSET_MACHINE) put: 0.
                ].
            ]
        ]
    ] ifFalse:[ 
    mask depth == 8 ifTrue:[ 
        0 to: height - 1 do:[:y |  
            | base |

            base := (first - 1) + (y * stride).
            0 to: width - 1 do:[:x |  
                | pixel color offset alpha |

                offset := base + (x * 4).
                pixel := self pixelAtX: x y: y.
                color := self colorFromValue: pixel.
                alpha := mask pixelAtX: x y:y.
                buffer at: (offset + ARGB_R_OFFSET_MACHINE) put: (color redByte * alpha) // 16rFF.  
                buffer at: (offset + ARGB_G_OFFSET_MACHINE) put: (color greenByte * alpha) // 16rFF.  
                buffer at: (offset + ARGB_B_OFFSET_MACHINE) put: (color blueByte * alpha) // 16rFF.  
                buffer at: (offset + ARGB_A_OFFSET_MACHINE) put: alpha
            ]
        ]
    ]]].

    "Created: / 01-09-2015 / 17:16:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2016 / 14:38:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bitsPerSample
    "return the number of bits per sample.
     The return value is an array of bits-per-plane."

    bitsPerSample notNil ifTrue:[^ bitsPerSample].
    ^ Array with:self depth

    "Modified: 10.6.1996 / 18:04:21 / cg"
!

colorMap
    "return the colormap"

    ^ colorMap
!

colorMap:aColorMap
    "set the colorMap; this also sets the photometric to a useful default."

    |oldSize "{ Class: SmallInteger }"
     sameColors|

    (aColorMap isNil and:[colorMap isNil]) ifTrue:[^ self].

    sameColors := false.

    photometric == #palette ifTrue:[
        "/ any change at all ?
        oldSize := colorMap size.
        aColorMap size >= oldSize ifTrue:[
            sameColors := true.

            1 to:oldSize do:[:idx |
                (aColorMap at:idx) = (colorMap at:idx) ifFalse:[
                    sameColors := false.
                ]
            ].
        ].
    ].

    self setColorMap:aColorMap.
    sameColors ifTrue:[
        ^ self
    ].

    colorMap notNil ifTrue:[
        photometric := #palette.
    ] ifFalse:[
        (photometric == #palette) ifTrue:[
            photometric := #blackIs0
        ]
    ].
    deviceForm notNil ifTrue:[
        self release
    ]

    "Modified: / 31-08-1995 / 03:05:59 / claus"
    "Modified: / 22-08-1998 / 12:29:58 / cg"
    "Modified: / 31-01-2017 / 14:48:56 / stefan"
!

colorMapFromArray: anArray
    "set the colorMap by reading colors from an array with rgb-byte values.
     The (byte-)Array argument should be of the form:
        #( red0 green0 blue0  red1 green1 blue1 ... redN greenN blueN)
     where each component must be a byteValue in 0..255."

    self colorMap:(MappedPalette rgbBytesVector:anArray)
!

colorMapFromRGBValueArray:anArray
    "set the colorMap by reading colors from an array with rgb-integer values.
     The (integer-)Array argument should be of the form:
        #( rgb0 rgb1  ... rgbN)
     where each element must be an rgbValue in 0..FFFFFF."

    self colorMap:(MappedPalette rgbValueVector:anArray)
!

container:aVisualContainer
    "ignored here - added to allow images to be used like
     VisualComponents (later, Image should inherit from it)"

    "Created: 28.5.1996 / 23:43:49 / cg"
    "Modified: 29.5.1996 / 10:22:23 / cg"
!

depth
    "return the depth of the image"

    ^ self bitsPerPixel
!

device
    "return the device, the receiver is associated with.
     Return nil, if the image is unassigned."

    ^ device
!

drawableId
    "return the id of the image on the device.
     Return nil, if the image is unassigned."

    deviceForm isNil ifTrue:[^ nil].
    ^ deviceForm drawableId
!

extent
    "return the images extent"

    ^ width@height
!

fileName
    "return the value of the instance variable 'fileName' (automatically generated)"

    ^ fileName

    "Created: / 3.11.1997 / 14:54:46 / cg"
!

fileName:something
    "set the value of the instance variable 'fileName' (automatically generated)"

    fileName := something.

    "Created: / 3.11.1997 / 14:54:46 / cg"
!

fullColorId
    "return the id of the full color image on the device.
     Return nil, if the image is unassigned."

    fullColorDeviceForm isNil ifTrue:[^ nil].
    ^ fullColorDeviceForm id
!

graphicsDevice
    "same as #device - for ST-80 compatibility"

    ^ device
!

height
    "return the height of the image"

    ^ height
!

id
    ^ self drawableId  
!

imageSequence
    "return the frameSequence of which this image is a part of;
     nil if it is not part of a sequence."

    ^ imageSequence

    "Created: / 1.4.1998 / 14:43:00 / cg"
!

imageSequence:aCollection
    "private entry for imageReaders - set the frameSequence of which
     this image is a part of"

    imageSequence := aCollection

    "Created: / 1.4.1998 / 14:42:36 / cg"
!

mask
    ^ mask

    "Created: 21.6.1996 / 12:57:44 / cg"
!

mask:anotherImage
    "set the images mask - currently, this may be nil or a Depth1Image.
     (it is planned to support alpha information in a Depth8 maskImage in
      the near future).
     For depth1 masks: each pixel of the image where a corresponding
                       1-bit is present in the mask will be drawn;
                       0-bit mask pixels lead to transparent pixels.

     For depth8 masks: (future):
                       each pixel specifies the alpha value (0..255),
                       which specifies the transparency of that pixel.
                       0 means completely transparent, 255 means completely
                       opaque. The 1-plane mask is a special case of this,
                       interpreting a 0 as a 0 alpha value and 1's as an
                       alpha value of 255."

    mask := anotherImage.
    maskedPixelsAre0 := false.

    "Created: 27.6.1996 / 17:45:22 / cg"
    "Modified: 12.4.1997 / 12:04:39 / cg"
!

maskedPixelsAre0
    "return true if masked pixels have been cleared to zero"

    ^ maskedPixelsAre0 == true

    "Modified: / 22.8.1998 / 11:27:22 / cg"
!

maskedPixelsAre0:aBoolean
    "set/clear the flag which states if masked pixels
     have been set to zero. Knowing this to be true allows
     faster drawing of the image later; (however, not setting
     it will still produce correct output).
     This flag is typically set by image readers."

    maskedPixelsAre0 := aBoolean

    "Modified: 12.4.1997 / 12:08:42 / cg"
!

metaData
    ^ metaData
!

metaData:something
    metaData := something.
!

monochromeId
    "return the id of the monochrome image on the device.
     Return nil, if the image is unassigned."

    monoDeviceForm isNil ifTrue:[^ nil].
    ^ monoDeviceForm id
!

palette
    "return the colormap; ST-80 compatibility"

    ^ colorMap
!

palette:aColormap
    "set the colormap; ST-80 compatibility"

    self colorMap:aColormap

    "Created: 1.2.1996 / 15:09:25 / cg"
    "Modified: 8.6.1996 / 09:54:02 / cg"
!

photometric
    "return the photometric, a symbol such as #palette, #rgb etc.
     This may be a somewhat old leftover from times, when tiff was the first image file type to be read.
     Much better would be to always have some (possibly fake and virtual) colormap around, and ask that one.
     However, in the meantime, many other classes depend on that, so that it should be kept as an API
     - even when the internal representation will be replaced by something better in the future."


    ^ photometric
!

samplesPerPixel
    "return the number of samples per pixel in the image."

    samplesPerPixel notNil ifTrue:[^ samplesPerPixel].
    ^ 1

    "Modified: 10.6.1996 / 18:03:30 / cg"
!

setColorMap:aColorMap
    colorMap isColormap ifTrue:[
        colorMap := aColorMap.
    ] ifFalse:[
        colorMap := MappedPalette withColors:aColorMap.
    ].

    "Modified: / 30-01-2017 / 19:15:34 / stefan"
!

width
    "return the width of the image"

    ^ width
! !

!Image methodsFor:'accessing-pixels'!

at:aPoint
    "WARNING: for now, this returns a pixels color
     (backward compatibility with ST/X)
     In the future, this will return a pixel value (ST-80 compatibility)
     Use #colorAt: - for future compatibility.

     retrieve the pixel at aPoint; return a color.
     Pixels start at 0@0 for upper left pixel, end at
     (width-1)@(height-1) for lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    <resource:#obsolete>

    self obsoleteFeatureWarning:'Image [warning]: the Image>>at: will change semantics soon; use #colorAt:'.
    ^ self colorAtX:(aPoint x) y:(aPoint y)

    "Modified: / 21.6.1997 / 13:10:17 / cg"
    "Modified: / 9.1.1998 / 20:33:52 / stefan"
!

at:aPoint put:aColor
    "WARNING: for now, this expects a pixels color
     (backward compatibility with ST/X)
     In the future, this will expect a pixel value (ST-80 compatibility)
     Use #colorAt:put: - for future compatibility.

     set the pixel at aPoint to aColor.
     Pixels start at 0@0 for the upper left pixel, end at
     (width-1)@(height-1) for lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    aColor isInteger ifTrue:[
        ^ self pixelAtX:aPoint x y:aPoint y put:aColor.
    ].
    self obsoleteFeatureWarning:'Image [warning]: the Image>>at:put: will change semantics soon; use #colorAt:put:'.
    ^ self colorAtX:aPoint x y:aPoint y put:aColor.

    "Modified: / 21.6.1997 / 13:16:02 / cg"
    "Modified: / 9.1.1998 / 20:34:15 / stefan"
!

atImageAndMask:aPoint put:aColorOrPixelOrNil
    "set the pixel at x/y to aColor.
     If aColor is a mask color (i.e. Color noColor) the mask pixel will be set to 0 (transparent),
     otherwise to 1. Nil is treated like noColor.
     (used by the bitmap editor)"

    |maskVal|

    (aColorOrPixelOrNil notNil and:[aColorOrPixelOrNil ~= Color noColor]) ifTrue:[
        maskVal := 1.
        aColorOrPixelOrNil isInteger ifTrue:[
            self pixelAt:aPoint put:aColorOrPixelOrNil.
        ] ifFalse:[
            self colorAt:aPoint put:aColorOrPixelOrNil
        ]
    ] ifFalse:[
        maskVal := 0.
        self pixelAt:aPoint put:0.
    ].
    mask notNil ifTrue:[
        mask pixelAt:aPoint put:maskVal
    ].

    "Modified: / 30.9.1998 / 22:42:44 / cg"
!

atImageAndMask:aPoint putValue:aPixelValueOrNil
    "set the pixel at x/y to aColor.
     If aPixelValueOrNil is nil, the mask pixel will be set to 0 (transparent),
     otherwise to 1. (used by the bitmap editor)"

    |pixVal maskVal|

    aPixelValueOrNil notNil ifTrue:[
        pixVal := aPixelValueOrNil.
        maskVal := 1.
    ] ifFalse:[
        pixVal := 0.
        maskVal := 0.
    ].
    mask notNil ifTrue:[
        mask pixelAt:aPoint put:maskVal
    ].
    self pixelAt:aPoint put:pixVal

    "Modified: / 30.9.1998 / 22:42:44 / cg"
!

atPoint:aPoint
    "ST-80 compatibility: return the pixelValue at:aPoint."

    ^ self pixelAtX:aPoint x y:aPoint y

    "Modified: 24.4.1997 / 16:18:44 / cg"
!

atPoint:aPoint put:aPixelValue
    "ST-80 compatibility: set the pixelValue at:aPoint."

    ^ self pixelAtX:aPoint x y:aPoint y put:aPixelValue

    "Modified: 24.4.1997 / 17:17:59 / cg"
!

atX:x y:y
    <resource: #obsolete>
    "WARNING: for now, this returns a pixels color
     (backward compatibility with ST/X)
     In the future, this will return a pixel value (ST-80 compatibility)
     Use #colorAt: - for future compatibility.

     Retrieve a pixel at x/y; return a color.
     Pixels start at 0@0 for upper left pixel, end at
     (width-1)@(height-1) for lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    self obsoleteFeatureWarning:'Image [warning]: the Image>>atX:y: will change semantics soon; use #colorAtX:y:'.
    ^ self colorAtX:x y:y

    "Modified: 21.6.1997 / 13:10:32 / cg"
!

atX:x y:y put:aColor
    "WARNING: for now, this expects a pixels color
     (backward compatibility with ST/X)
     In the future, this will expect a pixel value (ST-80 compatibility)
     Use #colorAt:put: - for future compatibility.

     set the pixel at x/y to aColor.
     Pixels start at 0@0 for the upper left pixel, end at
     (width-1)@(height-1) for the lower right pixel.
     This method checks if the color can be stored in the image.
     (i.e. if the receiver is a palette image, the color must be present in there).
     You should not use this method for image-processing, it is very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    aColor isInteger ifTrue:[
        ^ self pixelAtX:x y:y put:aColor
    ].
    self obsoleteFeatureWarning:'Image [warning]: the Image>>atX:y:put: will change semantics soon; use #colorAtX:y:put:'.
    ^ self colorAtX:x y:y put:aColor

    "Modified: 21.6.1997 / 13:10:44 / cg"
!

atX:x y:y putValue:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at 0@0 for the upper left pixel, end at
     (width-1) @ (height-1) for the lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #pixelAtX:y:put:'.
    ^ self pixelAtX:x y:y put:aPixelValue.

    "Modified: 24.4.1997 / 17:15:45 / cg"
!

bits
    "return the raw image data (pixel data);
     depending on the photometric, this has to be interpreted as monochrome,
     greyscale, palette or rgb data.
     It is also packed to be dense, so a 4 bitPerSample palette image
     will store 2 pixels per byte, whereas a 2-bitPerPixel image will store
     4 pixels per byte."

    bytes isNil ifTrue:[
        pixelFunction notNil ifTrue:[
            self createPixelStore.
            0 to:height-1 do:[:y |
                0 to:width-1 do:[:x |
                    self pixelAtX:x y:y put:(pixelFunction value:x value:y)
                ].
            ].
        ].
    ].
    ^ bytes
!

colAt:x into:aPixelBuffer
    "fill aBuffer with pixel values retrieved from a single column.
     (eg. a vertical span)    
     Notice: row/column coordinates start at 0."

    ^ self colAt:x into:aPixelBuffer startingAt:1
!

colAt:x into:aPixelBuffer startingAt:startIndex
    "fill aBuffer with pixel values retrieved from a single column.
     (eg. a vertical span)    
     Notice: row/column coordinates start at 0.
     This is a slow fallBack method, which works with any depth;
     concrete image subclasses should redefine this for more performance."

    |h "{ Class: SmallInteger }"|

    h := height-1.    
    0 to:h do:[:row |
        aPixelBuffer at:(row + startIndex) put:(self pixelAtX:x y:row)
    ].
!

colAt:x putAll:pixelArray
    "store a single column's pixels from bits in the argument;
     (eg. a vertical span)    
     Notice: row/column coordinates start at 0.
     This is a slow fallBack method, which works with any depth;
     concrete image subclasses should redefine this for more performance."

    ^ self colAt:x putAll:pixelArray startingAt:1
!

colAt:x putAll:pixelArray startingAt:startIndex
    "store a single row's pixels from bits in the pixelArray argument.
     (eg. a vertical span)    
     Notice: row/column coordinates start at 0.
     This is a slow fallBack method, which works with any depth;
     concrete image subclasses should redefine this for more performance."

    |h "{ Class: SmallInteger }"|

    h := height-1.
    0 to:h do:[:row |
        self pixelAtX:x y:row put:(pixelArray at:(row + startIndex))
    ].
    ^ pixelArray
!

colorAt:aPoint
    "retrieve a pixel at x/y; return a color.
     Pixels start at 0@0 for upper left pixel, end at
     (width-1)@(height-1) for lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    ^ self colorAtX:(aPoint x) y:(aPoint y)

    "Created: 24.4.1997 / 17:02:31 / cg"
!

colorAt: aPoint put:aColor

    self colorAtX: aPoint x y: aPoint y put:aColor
!

colorAtX:x y:y
    "retrieve a pixel at x/y; return a color.
     Pixels start at 0@0 for upper left pixel, end at
     (width-1)@(height-1) for lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    |pixel|

    pixel := self pixelAtX:x y:y.
    ^ self colorFromValue:pixel

    "Modified: 24.4.1997 / 16:18:53 / cg"
    "Created: 24.4.1997 / 17:00:52 / cg"
!

colorAtX:x y:y put:aColor
    "set the pixel at x/y to aColor.
     Pixels start at 0@0 for the upper left pixel, end at
     (width-1)@(height-1) for the lower right pixel.
     This method checks if the color can be stored in the image.
     (i.e. if the receiver is a palette image, the color must be present in there).
     You should not use this method for image-processing, it is very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    |pixel|

    pixel := self valueFromColor:aColor.
    pixel isNil ifTrue:[
        ^ UnrepresentableColorSignal raiseErrorString:'cannot store color - not in colormap'.
    ].
    self pixelAtX:x y:y put:pixel.

    "Modified: 24.4.1997 / 17:36:20 / cg"
!

data
    "for backward compatibility - will vanish"

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #bits'.
    ^ self bits

    "Modified: 24.4.1997 / 17:37:57 / cg"
!

data:aByteArray
    "for backward compatibility - will vanish"

    <resource:#obsolete>
    self obsoleteMethodWarning:'use #bits:'.
    self bits:aByteArray

    "Modified: 24.4.1997 / 17:38:18 / cg"
!

maskAt:aPoint
    "retrieve the maskValue at aPoint - an integer number which is
     0 for masked pixels (invisible), 1 for unmasked (visible).
     For images without mask, 1 is returned for all pixels."

    ^ self maskAtX:aPoint x y:aPoint y
!

maskAt:aPoint put:maskValue
    "set the maskValue at aPoint - an integer number which is
     0 for masked pixels (invisible), 1 for unmasked (visible)."

    ^ self maskAtX:aPoint x y:aPoint y put:maskValue
!

maskAtX:x y:y
    "retrieve the maskValue at aPoint - an integer number which is
     0 for masked pixels (invisible), 1 for unmasked (visible).
     For images without mask, 1 is returned for all pixels."

    mask isNil ifTrue:[^ 1].
    ^ mask pixelAtX:x y:y
!

maskAtX:x y:y put:maskValue
    "set the maskValue at aPoint - an integer number which is
     0 for masked pixels (invisible), 1 for unmasked (visible)."

    mask isNil ifTrue:[
        maskValue == 1 ifTrue:[^ self].
        self error:'image has no mask'.
    ].

    ^ mask pixelAtX:x y:y put:maskValue
!

pixelAt:aPoint
    "retrieve a pixel at x/y; return a pixel value.
     Pixels start at 0@0 for upper left pixel, end at
     (width-1)@(height-1) for lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    ^ self pixelAtX:(aPoint x) y:(aPoint y)

    "Created: / 29.7.1998 / 02:48:52 / cg"
!

pixelAt:aPoint put:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at 0@0 for the upper left pixel, end at
     (width-1) @ (height-1) for the lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    ^ self pixelAtX:aPoint x y:aPoint y put:aPixelValue

    "Created: / 30.9.1998 / 22:40:43 / cg"
!

pixelAtX:x y:y
    "retrieve the pixelValue at aPoint; return a pixel (an integer number).
     Pixels start at 0/0 for upper left pixel, and end at
     width-1@height-1 for lower right pixel.
     The returned number's interpretation depends on the photometric
     and the colormap. (see also Image>>at: and Image>>atX:y:)
     You should not use this method for image-processing of
     big images, it's very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    ^ self subclassResponsibility

    "Created: 24.4.1997 / 16:06:56 / cg"
!

pixelAtX:x y:y put:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at 0@0 for the upper left pixel, end at
     (width-1) @ (height-1) for the lower right pixel.
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    ^ self subclassResponsibility

    "Created: 24.4.1997 / 17:05:11 / cg"
!

rgbValueAt:aPoint
    "retrieve a pixels rgb value at x/y; return a 24bit rgbValue (rrggbb, red is MSB).
     Pixels start at 0@0 for upper left pixel, end at (width-1)@(height-1) for lower right pixel."

    ^ self rgbValueAtX:(aPoint x) y:(aPoint y)
!

rgbValueAtX:x y:y
    "retrieve a pixels rgb value at x/y; return a 24bit rgbValue (rrggbb, red is MSB).
     Pixels start at 0@0 for upper left pixel, end at (width-1)@(height-1) for lower right pixel."

    |pixel|

    pixel := self pixelAtX:x y:y.
    ^ self rgbFromValue:pixel
!

rgbValueAtX:x y:y put:newRGBValue
    |value|

    value := self valueFromRGB:newRGBValue.
    self pixelAtX:x y:y put:value.

    "Created: / 15-01-2008 / 15:56:10 / cg"
!

rowAt:y
    "retrieve an array filled with pixel values from a single row.
     (eg. a horizontal span)    
     Notice: row/column coordinates start at 0.
     This is a slow fallBack method, which works with any depth;
     concrete image subclasses should redefine this for more performance."

    |pixelArray|

    pixelArray := self pixelArraySpecies new:width.
    self rowAt:y into:pixelArray startingAt:1.
    ^ pixelArray

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     (i rowAt:0) inspect
    "
    "
     |i|

     i := Image fromFile:'libtool/bitmaps/SBrowser.xbm'.
     (i rowAt:0) inspect
    "

    "Modified: 24.4.1997 / 15:51:24 / cg"
!

rowAt:y into:aPixelBuffer
    "fill aBuffer with pixel values retrieved from a single row.
     (eg. a horizontal span)    
     Notice: row/column coordinates start at 0."

    ^ self rowAt:y into:aPixelBuffer startingAt:1

    "Created: 24.4.1997 / 15:44:46 / cg"
    "Modified: 24.4.1997 / 15:51:35 / cg"
!

rowAt:y into:aPixelBuffer startingAt:startIndex
    "fill aBuffer with pixel values retrieved from a single row.
     (eg. a horizontal span)    
     Notice: row/column coordinates start at 0.
     This is a slow fallBack method, which works with any depth;
     concrete image subclasses should redefine this for more performance."

    |w "{ Class: SmallInteger }"|

    w := width-1.
    0 to:w do:[:col |
        aPixelBuffer at:(col + startIndex) put:(self pixelAtX:col y:y)
    ].

    "Created: 24.4.1997 / 15:05:21 / cg"
    "Modified: 24.4.1997 / 16:52:43 / cg"
!

rowAt:y putAll:pixelArray
    "store a single row's pixels from bits in the argument;
     (eg. a horizontal span)    
     Notice: row/column coordinates start at 0.
     This is a slow fallBack method, which works with any depth;
     concrete image subclasses should redefine this for more performance."

    ^ self rowAt:y putAll:pixelArray startingAt:1

    "Modified: 24.4.1997 / 15:51:58 / cg"
!

rowAt:y putAll:pixelArray startingAt:startIndex
    "store a single row's pixels from bits in the pixelArray argument;
     (eg. a horizontal span)    
     Notice: row/column coordinates start at 0.
     This is a slow fallBack method, which works with any depth;
     concrete image subclasses should redefine this for more performance."

    |w "{ Class: SmallInteger }"|

    w := width-1.
    0 to:w do:[:col |
        self pixelAtX:col y:y put:(pixelArray at:(col + startIndex))
    ].
    ^ pixelArray

    "Modified: 24.4.1997 / 17:05:57 / cg"
!

valueAt:aPoint
    "WARNING: for now, this returns a pixels value
     (backward compatibility with ST/X)
     In the future, this will return a color (ST-80 compatibility)
     Use #pixelAt: - for future compatibility.

     Retrieve the pixelValue at aPoint; return an integer number.
     Pixels start at 0@0 for upper left pixel, end at
     width-1@height-1 for lower right pixel.
     The returned numbers interpretation depends on the photometric
     and the colormap. (see also Image>>at: and Image>>atX:y:)
     You should not use this method for image-processing, its
     very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    'Image [warning]: the Image>>valueAt: will change semantics soon; use #pixelAt:' infoPrintCR.
    ^ self pixelAtX:aPoint x y:aPoint y

    "Modified: 21.6.1997 / 13:11:19 / cg"
!

valueAtX:x y:y
    "WARNING: for now, this returns a pixels value
     (backward compatibility with ST/X)
     In the future, this will return a color (ST-80 compatibility)
     Use #pixelAt: - for future compatibility.

     Retrieve the pixelValue at aPoint; return an integer number.
     Pixels start at 0/0 for upper left pixel, and end at
     width-1@height-1 for lower right pixel.
     The returned numbers interpretation depends on the photometric
     and the colormap. (see also Image>>at: and Image>>atX:y:)
     You should not use this method for image-processing of
     big images, its very slow ...
     (it is meant to access individual pixels - for example, in a bitmap editor)"

    'Image [warning]: the Image>>valueAtX:y: will change semantics soon; use #pixelAtX:y' infoPrintCR.
    ^ self pixelAtX:x y:y

    "Modified: 21.6.1997 / 13:11:29 / cg"
! !

!Image methodsFor:'accessing-private'!

bits:aByteArray
    "set the raw data.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation
     (it does not care for colormaps and/or cached device image flushing)."

    |expectedSize d|

    bytes := aByteArray.

    "/ sanity check:
    "/ there seem to be images in some image-resource methods,
    "/ which were written with an invalid packed pixel string.
    "/ leave this in for a while and watch out for the halt below.
    "/ If you encounter this halt,
    "/ please edit the image in the image editor and save it back.

    (width notNil and:[height notNil and:[(d := self depth) notNil]]) ifTrue:[
        (d <= 8) ifTrue:[
            expectedSize := (self bytesPerRow * height).
            bytes size < expectedSize ifTrue:[
                Smalltalk isSmalltalkDevelopmentSystem ifTrue:[
                    self breakPoint:#cg info:'invalid bytearray size'.
                ].
                bytes := (ByteArray new:expectedSize) replaceFrom:1 with:bytes; yourself.
            ].
        ].
    ].

    "Modified: 23.4.1996 / 11:08:28 / cg"
!

bits:aByteArrayArg colorMap:clrMapArg
    "set the raw data.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation
     (it does not care for colormaps and/or cached device image flushing)."

    self bits:aByteArrayArg.
    self colorMap:clrMapArg.
!

bits:aByteArrayArg colorMap:clrMapArg mask:maskArg
    "set the raw data.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation
     (it does not care for colormaps and/or cached device image flushing)."

    self bits:aByteArrayArg.
    self colorMap:clrMapArg.
    self mask:maskArg
!

bits:aByteArrayArg colorMapFromArray:clrMapArg
    "set the raw data.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation
     (it does not care for colormaps and/or cached device image flushing)."

    self bits:aByteArrayArg.
    self colorMapFromArray:clrMapArg.
!

bits:aByteArrayArg colorMapFromArray:clrMapArg mask:maskArg
    "set the raw data.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation
     (it does not care for colormaps and/or cached device image flushing)."

    self bits:aByteArrayArg.
    self colorMapFromArray:clrMapArg.
    self mask:maskArg
!

bits:aByteArrayArg mask:maskArg
    "set the raw data.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation
     (it does not care for colormaps and/or cached device image flushing)."

    self bits:aByteArrayArg.
    self mask:maskArg
!

bitsPerSample:aCollection
    "set the number of bits per sample.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    "/ the following is a trick to get both shared and immutable instances,
    "/ at least for the most common cases.
    "/ Prevents writers to do what is described above.
    "/ Do not remove, as you might not understand it!!
    bitsPerSample :=
        #(
            #[ 8 8 8 ]
            #[ 4 4 4 ]
            #[ 8 ]
            #[ 4 ]
            #[ 2 ]
            #[ 1 ]
        ) detect:[:bps | bps sameContentsAs:aCollection] ifNone:[aCollection asByteArray].

    samplesPerPixel isNil ifTrue:[
        samplesPerPixel := bitsPerSample size.
    ].

    "Modified: 23.4.1996 / 11:08:31 / cg"
!

depth:d
    "set the depth of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    depth := self depth.
    "/ bitsPerPixel := d.
    d == 24 ifTrue:[
        samplesPerPixel := 3.
        bitsPerSample := #[8 8 8]
    ] ifFalse:[
        d == 32 ifTrue:[
            samplesPerPixel := 4.
            bitsPerSample := #[8 8 8 8]
        ] ifFalse:[
            d == 16 ifTrue:[
                samplesPerPixel := 3.
                bitsPerSample := #[5 5 5].
                "/ bitsPerPixel := 15.
            ] ifFalse:[
                samplesPerPixel := 1.
                bitsPerSample := ByteArray with:d
            ]
        ]
    ]

    "Modified: / 27-05-2007 / 16:59:47 / cg"
    "Modified: / 30-01-2017 / 19:36:00 / stefan"
!

extent:anExtent
    "set the images extent.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    width := anExtent x.
    height := anExtent y

    "Modified: 23.4.1996 / 11:08:38 / cg"
!

hasAlphaChannel
    ^ false
!

height:aNumber
    "set the height of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    height := aNumber

    "Modified: 23.4.1996 / 11:08:40 / cg"
!

photometric:aSymbol
    "set the photometric interpretation of the pixel values.
     The argument, aSymbol is one of:
        #blackIs0, #whiteIs0, #palette, #rgb
     See TIFF documentation, from which the photometric concept is borrowed.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    |b|

    photometric := aSymbol.
    bitsPerSample isNil ifTrue:[
        photometric == #rgb ifTrue:[
            b := self class imageDepth // 3.
            bitsPerSample := ByteArray with:b with:b with:b
        ] ifFalse:[
            bitsPerSample := ByteArray with:(self class imageDepth)
        ].
    ].
    samplesPerPixel isNil ifTrue:[
        photometric == #rgb ifTrue:[
            samplesPerPixel := 3
        ] ifFalse:[
            samplesPerPixel := 1
        ]
    ].

    "Modified: 10.6.1996 / 18:21:29 / cg"
!

samplesPerPixel:aNumber
    "set the array of samples per pixel.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    samplesPerPixel := aNumber

    "Modified: 23.4.1996 / 11:08:45 / cg"
!

width:aNumber
    "set the width of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    width := aNumber

    "Modified: 23.4.1996 / 11:08:48 / cg"
!

width:w height:h
    "set the width and height of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    width := w.
    height := h

    "Modified: 23.4.1996 / 11:08:53 / cg"
!

width:w height:h depth:d
    "set the width, height and depth of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    width := w.
    height := h.
    self depth:d.

    "Modified: 23.4.1996 / 11:08:56 / cg"
!

width:w height:h depth:d fromArray:bits
    "set the width, height, depth and pixels of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    width := w.
    height := h.
    self depth:d.
    self bits:bits

    "Modified: 23.4.1996 / 11:08:59 / cg"
!

width:w height:h depth:d palette:aColormap
    "set the width, height and depth of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    width := w.
    height := h.
    self depth:d.
    self setColorMap:aColormap.
    aColormap notNil ifTrue:[
        photometric := #palette
    ] ifFalse:[
        photometric := #blackIs0
    ].

    "Modified: 23.4.1996 / 11:08:56 / cg"
    "Created: 6.3.1997 / 15:23:57 / cg"
!

width:w height:h photometric:p
    "set the width, height and photometric of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    width := w.
    height := h.
    self photometric:p.

    "Modified: 23.4.1996 / 11:08:56 / cg"
!

width:w height:h photometric:p samplesPerPixel:spp bitsPerSample:bps colorMap:cm bits:pixels
    "set all relevant internal state of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    ^ self
        width:w
        height:h
        photometric:p
        samplesPerPixel:spp
        bitsPerSample:bps
        colorMap:cm
        bits:pixels
        mask:nil

    "Modified: 20.6.1996 / 17:10:24 / cg"
!

width:w height:h photometric:p samplesPerPixel:spp bitsPerSample:bps colorMap:cm bits:pixels mask:m
    "set all relevant internal state of the image.

     This interface is only to be used when initializing
     instances or by image readers. Calling for a change of an
     existing image may confuse later pixel interpretation."

    width := w.
    height := h.
    photometric := p.
    samplesPerPixel := spp.
    bitsPerSample := bps.
    self setColorMap:cm.
    self bits:pixels.
    mask := m.

    "Modified: 23.4.1996 / 11:09:02 / cg"
    "Created: 20.6.1996 / 17:09:53 / cg"
! !


!Image methodsFor:'conversion helpers'!

rgbColormapFor:aDevice
    "helper for conversion to rgb format"

    |nColors    "{ Class: SmallInteger }"
     scaleRed scaleGreen scaleBlue
     redShift   "{ Class: SmallInteger }"
     greenShift "{ Class: SmallInteger }"
     blueShift  "{ Class: SmallInteger }"
     colorValues|

    "/ gather r/g/b values for all colors in the map ...

    nColors := 1 bitShift:(self depth).

    "/ precompute scales to map from 0..100 into devices range
    "/ (this may be different for the individual components)

    scaleRed := ((1 bitShift:aDevice bitsRed) - 1) / 100.
    scaleGreen := ((1 bitShift:aDevice bitsGreen) - 1) / 100.
    scaleBlue := ((1 bitShift:aDevice bitsBlue) - 1) / 100.
    redShift := aDevice shiftRed.
    greenShift := aDevice shiftGreen.
    blueShift := aDevice shiftBlue.

    colorValues := Array uninitializedNew:nColors.

    0 to:nColors-1 do:[:pixel |
        |clr rv gv bv v "{ Class: SmallInteger }" |

        clr := self colorFromValue:pixel.

        rv := (clr red * scaleRed) rounded.
        gv := (clr green * scaleGreen) rounded.
        bv := (clr blue * scaleBlue) rounded.

        v := rv bitShift:redShift.
        v := v bitOr:(gv bitShift:greenShift).
        v := v bitOr:(bv bitShift:blueShift).

        colorValues at:(pixel+1) put:v.
"/ clr print. ' ' print.
"/ rv print. ' ' print. gv print. ' ' print. bv print. ' ' print.
"/ ' -> ' print. v printNL.
    ].

    ^ colorValues

    "Modified: / 29.7.1998 / 00:34:56 / cg"
! !

!Image methodsFor:'converting'!

asBurkesDitheredMonochromeImage
    "return a burkes dithered monochrome image from the receiver image.
     Depending on the images contents, this may or may not look better than
     a floyd-steinberg dithered image.
     Notice that floyd-steinberg dithering is faster; both because less
     error diffusion is done and due to being specially tuned."

    |monoBits|

    monoBits := self burkesDitheredMonochromeBits.
    ^ Depth1Image width:width height:height fromArray:monoBits

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     i asFloydSteinbergDitheredMonochromeImage inspect.
     i asBurkesDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     i asFloydSteinbergDitheredMonochromeImage inspect.
     i asBurkesDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "
     |i|

     i := Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ].
     i := i magnifiedBy:30.
     i inspect.
     i asFloydSteinbergDitheredMonochromeImage inspect.
     i asBurkesDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "Created: 10.6.1996 / 12:34:44 / cg"
    "Modified: 12.6.1996 / 13:58:16 / cg"
!

asDitheredImageUsing:colors
    "return a dithered image from the picture,
     using colors in colors for dithering."

    ^ self asDitheredImageUsing:colors depth:self depth
!

asDitheredImageUsing:colors depth:d
    "return a dithered image from the picture,
     using colors in colors for dithering."

    |newBits|

    newBits := self floydSteinbergDitheredDepth8BitsColors:colors map:(0 to:colors size - 1).
    newBits isNil ifTrue:[
        self error:'dithering failed'
    ].
    ^ (self class newForDepth:d) extent:(self extent); depth:d; palette:colors; bits:newBits; yourself

    "Modified: / 30-01-2017 / 19:40:19 / stefan"
!

asErrorDitheredMonochromeImage
    "return an error-diffusion dithered monochrome image from the receiver image."

    DitherAlgorithm == #burkes ifTrue:[
        ^ self asBurkesDitheredMonochromeImage
    ].
    DitherAlgorithm == #stevensonArce ifTrue:[
        ^ self asStevensonArceDitheredMonochromeImage
    ].
    ^ self asFloydSteinbergDitheredMonochromeImage

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     i asErrorDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     i asErrorDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "
     |i|

     i := Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ].
     i := i magnifiedBy:30.
     i inspect.
     i asErrorDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "Modified: 10.6.1996 / 14:22:30 / cg"
!

asFloydSteinbergDitheredDepth8FormOn:aDevice colors:fixColors
    "return a floyd-steinberg dithered pseudoForm from the picture.
     Use the colors in the fixColors array.
     By passing the ditherColors as extra array, this method can
     also be used to dither an 8bit image into a smaller number of colors,
     for example to create dithered Depth4Images from Depth8Images."

    |pseudoBits f deviceDepth map|

    deviceDepth := aDevice depth.
    deviceDepth == 8 ifFalse:[
        (aDevice supportedImageFormatForDepth:8) isNil ifTrue:[
            ^ nil.
        ]
    ].

    pseudoBits := self floydSteinbergDitheredDepth8BitsColors:fixColors.
    pseudoBits isNil ifTrue:[^ nil].

    f := Form width:width height:height depth:deviceDepth onDevice:aDevice.
    f isNil ifTrue:[^ nil].

    "/
    "/ have to create a funny colorMap, where
    "/ color at:index == color colorId:index
    "/
    map := Array new:256.
    fixColors do:[:clr |
        map at:clr colorId + 1 put:clr
    ].
    f colorMap:map.
    f bits:pseudoBits.
    aDevice
        drawBits:pseudoBits
        bitsPerPixel:8
        depth:deviceDepth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id) x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f

    "
     example:
        color reduction from Depth8 to Depth4 (dithering) can be done by:

     |img8 reducedImg8 img4 map form|

     map := #(
                  (0     0   0)
                  (0     0 100)
                  (0    50   0)
                  (0    50 100)
                  (0   100   0)
                  (0   100 100)
                  (100   0   0)
                  (100   0 100)
                  (100  50   0)
                  (100  50 100)
                  (100 100   0)
                  (100 100 100)) collect:[:rgb | (Color red:(rgb at:1)
                                                      green:(rgb at:2)
                                                       blue:(rgb at:3)) onDevice:Display].

     img8 := Image fromFile:'goodies/bitmaps/bf.im8'.
     form := img8 paletteImageAsDitheredPseudoFormOn:Display
                      colors:map
                        nRed:2
                      nGreen:3
                       nBlue:2.
     img8 := Depth8Image fromForm:form.    'dithered version of original image'.
     img4 := Depth4Image fromImage:img8.
    "

    "Modified: 14.6.1996 / 16:52:34 / cg"
    "Created: 23.6.1997 / 15:25:37 / cg"
!

asFloydSteinbergDitheredDepth8FormOn:aDevice colors:fixColors nRed:nRed nGreen:nGreen nBlue:nBlue
    "return a floyd-steinberg dithered pseudoForm from the palette picture.
     Use the colors in the fixColors array, which must be fixR x fixG x fixB
     colors assigned to aDevice, such as the preallocated colors of the
     Color class.
     By passing the ditherColors as extra array, this method can
     also be used to dither an 8bit image into a smaller number of colors,
     for example to create dithered Depth4Images from Depth8Images."

    |pseudoBits f deviceDepth map|

    deviceDepth := aDevice depth.
    deviceDepth == 8 ifFalse:[
        (aDevice supportedImageFormatForDepth:8) isNil ifTrue:[
            ^ nil
        ]
    ].

    pseudoBits := self floydSteinbergDitheredDepth8BitsColors:fixColors nRed:nRed nGreen:nGreen nBlue:nBlue.
    pseudoBits isNil ifTrue:[^ nil].

    f := Form width:width height:height depth:deviceDepth onDevice:aDevice.
    f isNil ifTrue:[^ nil].

    "/
    "/ have to create a funny colorMap, where
    "/ color at:index == color colorId:index
    "/
    map := Array new:256.
    fixColors do:[:clr |
        map at:clr colorId + 1 put:clr
    ].
    f colorMap:map.
    f bits:pseudoBits.
    aDevice
        drawBits:pseudoBits
        bitsPerPixel:8
        depth:deviceDepth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id) x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f

    "
     example:
        color reduction from Depth8 to Depth4 (dithering) can be done by:

     |img8 reducedImg8 img4 map form|

     map := #(
                  (0     0   0)
                  (0     0 100)
                  (0    50   0)
                  (0    50 100)
                  (0   100   0)
                  (0   100 100)
                  (100   0   0)
                  (100   0 100)
                  (100  50   0)
                  (100  50 100)
                  (100 100   0)
                  (100 100 100)) collect:[:rgb | (Color red:(rgb at:1)
                                                      green:(rgb at:2)
                                                       blue:(rgb at:3)) onDevice:Display].

     img8 := Image fromFile:'goodies/bitmaps/bf.im8'.
     form := img8 paletteImageAsDitheredPseudoFormOn:Display
                      colors:map
                        nRed:2
                      nGreen:3
                       nBlue:2.
     img8 := Depth8Image fromForm:form.    'dithered version of original image'.
     img4 := Depth4Image fromImage:img8.
    "

    "Modified: 14.6.1996 / 16:52:34 / cg"
!

asFloydSteinbergDitheredGrayFormOn:aDevice
    "return a dithered depth-x grey form from the receiver image."

    |depth bits|

    depth := aDevice depth.
    (depth == 1
    or:[aDevice hasGrayscales not]) ifTrue:[
        "/ for monochrome, there is specialized
        "/ monochrome dither code available

        bits := self floydSteinbergDitheredMonochromeBits.
    ] ifFalse:[
        bits := self floydSteinbergDitheredGrayBitsDepth:depth.
    ].

    ^ self makeDeviceGrayPixmapOn:aDevice depth:depth fromArray:bits

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     (i asFloydSteinbergDitheredGrayFormOn:Display) inspect
    "

    "
     |i|

     i := Image fromFile:'bitmaps/granite.tiff'.
     (i asFloydSteinbergDitheredGrayFormOn:Display) inspect
    "

    "Created: 10.6.1996 / 14:11:39 / cg"
    "Modified: 17.4.1997 / 01:11:54 / cg"
!

asFloydSteinbergDitheredGrayImageDepth:depth
    "return a floyd-steinberg dithered image from the receiver image."

    |ditheredBits|

    (depth == 1) ifTrue:[
        ^ self asFloydSteinbergDitheredMonochromeImage
    ].

    ditheredBits := self floydSteinbergDitheredGrayBitsDepth:depth.
    ^ (self class implementorForDepth:depth)
        width:width height:height fromArray:ditheredBits

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:1) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:2) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:4) inspect.
    "

    "
     |i|

     i := Depth24Image width:4 height:1
          fromArray:#[
            16rFF 16r00 16r00   16rFF 16r00 16r00  16rFF 16r00 16r00  16rFF 16r00 16r00
            16rFF 16r00 16r00   16rFF 16r00 16r00  16rFF 16r00 16r00  16rFF 16r00 16r00
            16rFF 16r00 16r00   16rFF 16r00 16r00  16rFF 16r00 16r00  16rFF 16r00 16r00
            16rFF 16r00 16r00   16rFF 16r00 16r00  16rFF 16r00 16r00  16rFF 16r00 16r00].
     i := i magnifiedBy:4@1.
     i inspect.

     (i asFloydSteinbergDitheredGrayImageDepth:1) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:2) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:4) inspect.
    "

    "
     |i|

     i := Depth24Image width:4 height:6
          fromArray:#[
            16r00 16r00 16r00   16r00 16r00 16r80  16r00 16r00 16rff  16r00 16r80 16r00
            16r00 16r80 16r80   16r00 16rFF 16r00  16r00 16rFF 16r80  16r00 16rFF 16rFF
            16r80 16r00 16r00   16r80 16r00 16r80  16r80 16r00 16rff  16r80 16r80 16r00
            16r80 16r80 16r80   16r80 16rFF 16r00  16r80 16rFF 16r80  16r80 16rFF 16rFF
            16rFF 16r00 16r00   16rFF 16r00 16r80  16rFF 16r00 16rff  16rFF 16r80 16r00
            16rFF 16r80 16r80   16rFF 16rFF 16r00  16rFF 16rFF 16r80  16rFF 16rFF 16rFF].
     i := i magnifiedBy:30.
     i inspect.

     (i asFloydSteinbergDitheredGrayImageDepth:1) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:2) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:4) inspect.
    "
    "
     |i|

     i := Image fromFile:'granite.tiff'.
     i inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:1) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:2) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:4) inspect.
    "

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:1) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:2) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:4) inspect.
    "

    "
     |i|

     i := Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ].
     i := i magnifiedBy:30.
     i inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:1) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:2) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:4) inspect.
    "

    "Created: 10.6.1996 / 12:33:47 / cg"
    "Modified: 19.10.1997 / 04:09:04 / cg"
!

asFloydSteinbergDitheredMonochromeFormOn:aDevice
    "return a dithered moncohrome form from the receiver image."

    |monoBits|

    monoBits := self floydSteinbergDitheredMonochromeBits.
    ^ self makeDeviceMonochromeBitmapOn:aDevice fromArray:monoBits

    "
     |i f|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     (i asFloydSteinbergDitheredMonochromeFormOn:Display) inspect.
    "

    "
     |i f|

     i := Depth2Image width:8 height:8
          fromArray:#[
                        4r0000 4r0000
                        4r0000 4r0000
                        4r1111 4r1111
                        4r1111 4r1111
                        4r2222 4r2222
                        4r2222 4r2222
                        4r3333 4r3333
                        4r3333 4r3333
                     ].
     (i asFloydSteinbergDitheredMonochromeFormOn:Display) inspect.
    "

    "Created: 10.6.1996 / 14:11:39 / cg"
    "Modified: 17.4.1997 / 01:14:02 / cg"
!

asFloydSteinbergDitheredMonochromeImage
    "return a floyd-steinberg dithered monochrome image from the receiver image."

    |monoBits|

    monoBits := self floydSteinbergDitheredMonochromeBits.
    ^ Depth1Image width:width height:height fromArray:monoBits

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     i asFloydSteinbergDitheredMonochromeImage inspect.
     i asBurkesDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     i asFloydSteinbergDitheredMonochromeImage inspect.
     i asBurkesDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "
     |i|

     i := Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ].
     i := i magnifiedBy:30.
     i inspect.
     i asFloydSteinbergDitheredMonochromeImage inspect.
     i asBurkesDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "Created: 10.6.1996 / 12:33:47 / cg"
    "Modified: 17.4.1997 / 01:15:28 / cg"
!

asFloydSteinbergDitheredPseudoFormUsing:colors on:aDevice
    "return a floyd-steinberg dithered pseudoForm from the picture,
     using colors in colors for dithering."

    |pseudoBits pseudoBits8 f has8BitImage deviceDepth map d|

    deviceDepth := aDevice depth.
    has8BitImage := (deviceDepth == 8)
                    or:[ (aDevice supportedImageFormatForDepth:8) notNil ].

    has8BitImage ifFalse:[
        deviceDepth == 4 ifFalse:[^ nil].

        pseudoBits8 := self nfloydSteinbergDitheredDepth8BitsColors:colors.
        pseudoBits8 isNil ifTrue:[^ nil].
        "/ convert to devices depth

        pseudoBits := ByteArray new:(width*4+7//8 * height).
        pseudoBits8 compressPixels:4 width:width height:height into:pseudoBits mapping:nil.
        d := 4.
    ] ifTrue:[
        pseudoBits := self nfloydSteinbergDitheredDepth8BitsColors:colors.
        pseudoBits isNil ifTrue:[^ nil].
        d := 8.
    ].

    f := Form width:width height:height depth:deviceDepth onDevice:aDevice.
    f isNil ifTrue:[^ nil].

    "/
    "/ have to create a funny colorMap, where
    "/ color at:index == color colorId:index
    "/
    map := Array new:256 withAll:0.
    colors do:[:clr |
        clr notNil ifTrue:[
            map at:clr colorId + 1 put:clr
        ]
    ].
    f colorMap:map.
    f bits:pseudoBits.
    aDevice
        drawBits:pseudoBits
        bitsPerPixel:d
        depth:deviceDepth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id) x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     (i asFloydSteinbergDitheredPseudoFormUsing:(Smalltalk at:#'Color:DitherColors') on:Display) inspect


     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     (i asFloydSteinbergDitheredPseudoFormUsing:(Smalltalk at:#'Color:DitherColors') on:Display) inspect
    "

    "Created: 17.6.1996 / 12:13:35 / cg"
    "Modified: 5.9.1996 / 19:42:57 / cg"
!

asFormOn:aDevice
    "get a device form, with best possible approximation.
     remember it in case someone asks again."

    |form visual|

    ((aDevice == device) and:[deviceForm notNil]) ifTrue:[^ deviceForm].

    mask notNil ifTrue:[
        mask := mask onDevice:aDevice
    ].
    bytes isNil ifTrue:[
        pixelFunction notNil ifTrue:[
            self computeBitsFromPixelFunction.
        ]
    ].

    (aDevice depth == 1
    or:[aDevice hasGrayscales not]) ifTrue:[
        form := self asMonochromeFormOn:aDevice.
    ] ifFalse:[
        ((visual := aDevice visualType) == #StaticGray) ifTrue:[
            form := self asGrayFormOn:aDevice.
        ] ifFalse:[
            (visual == #PseudoColor
             or:[visual == #StaticColor]) ifTrue:[
                form := self asPseudoFormQuickOn:aDevice.
            ].
        ]
    ].

    form isNil ifTrue:[
        "/ kludge: repair a 'should not happen' situation...
        photometric isNil ifTrue:[ self repairPhotometric ].

        (photometric == #palette) ifTrue:[
            form := self paletteImageAsFormOn:aDevice
        ] ifFalse:[
            (photometric == #rgb or:[photometric == #rgba or:[photometric == #argb]]) ifTrue:[
                form := self rgbImageAsFormOn:aDevice
            ] ifFalse:[
                (photometric == #cmy or:[photometric == #cmyk]) ifTrue:[
                    form := self rgbImageAsFormOn:aDevice
                ] ifFalse:[
                    form := self greyImageAsFormOn:aDevice
                ]
            ]
        ].
    ].

    (device isNil or:[aDevice == device]) ifTrue:[
        "remember this form in the receiver ..."

        form notNil ifTrue:[
            form := form asImageForm.
            deviceForm := form.
            maskedPixelsAre0 := nil.
            device isNil ifTrue:[
                device := aDevice.
                Lobby register:self
            ] ifFalse:[
                Lobby registerChange:self
            ].
            mask notNil ifTrue:[
                self clearMaskedPixels.
            ].

            "
             can save space, by not keeping the images data-bits
             twice (here and in the device form)
            "
            form forgetBits
        ]
    ].

    ^ form

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     (i asFormOn:Display) inspect.
    "

    "Modified: / 06-06-2007 / 12:18:43 / cg"
!

asGrayFormOn:aDevice
    "get a gray device form"

    ^ self asGrayFormOn:aDevice dither:DitherAlgorithm.

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/claus.gif'.
     (i asGrayFormOn:Display) inspect.
    "

    "Modified: 10.6.1996 / 17:39:30 / cg"
    "Created: 10.6.1996 / 18:44:42 / cg"
!

asGrayFormOn:aDevice dither:aDitherAlgorithm
    "get a greyscale device form, using aDitherAlgorithm."

    |depth|

    depth := aDevice depth.
    (depth == 1
    or:[aDevice hasGrayscales not]) ifTrue:[
        ^ self asMonochromeFormOn:aDevice
    ].

    (aDitherAlgorithm isNil
    or:[aDitherAlgorithm == #threshold]) ifTrue:[
        ^ self asThresholdGrayFormOn:aDevice
    ].

    (aDitherAlgorithm == #pattern
    or:[aDitherAlgorithm == #ordered]) ifTrue:[
        ^ self asOrderedDitheredGrayFormOn:aDevice
    ].

    ^ self asFloydSteinbergDitheredGrayFormOn:aDevice.

    "Created: 10.6.1996 / 18:42:01 / cg"
    "Modified: 14.6.1996 / 15:17:28 / cg"
!

asGrayImageDepth:depthArg
    "get a gray image from the receiver"

    ((self colorMap notNil and:[depthArg between:self depth and:8])
     or:[self depth >= 8 "do need for dither" ]) ifTrue:[
        ^ self copyWithColorMapProcessing:[:clr | Color brightness:(clr brightness)].
    ].
    ^ self asGrayImageDepth:depthArg dither:DitherAlgorithm.

    "
     |i|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif'.
     (i asGrayImageDepth:16).
     (i asGrayImageDepth:4).
    "

    "Modified: / 10-06-1996 / 17:39:30 / cg"
    "Created: / 10-06-1996 / 19:07:08 / cg"
    "Modified: / 30-01-2017 / 20:13:06 / stefan"
    "Modified (comment): / 31-01-2017 / 13:25:29 / stefan"
!

asGrayImageDepth:depth dither:aDitherAlgorithm
    "get a greyscale image, using aDitherAlgorithm."

    (aDitherAlgorithm isNil
    or:[aDitherAlgorithm == #threshold]) ifTrue:[
        ^ self asThresholdGrayImageDepth:depth
    ].

    (aDitherAlgorithm == #pattern
    or:[aDitherAlgorithm == #ordered]) ifTrue:[
        ^ self asOrderedDitheredGrayImageDepth:depth
    ].

    ^ self asFloydSteinbergDitheredGrayImageDepth:depth

    "Created: 10.6.1996 / 19:08:21 / cg"
!

asImageWithDepth:depth
    "return a new image with another depth. Notice that this
     may raise an error, if the depth is smaller than the receiver's depths
     and the number of colors is greater than the number of possible colors
     for the new depth - i.e. you should use this only to convert to a higher depth.
     In the other case, use one of the dithering converters"

    |imageClass|

    imageClass := Image implementorForDepth:depth.
    ^ imageClass fromImage:self

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     (i asImageWithDepth:24) inspect.
    "
    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     (i asImageWithDepth:4) inspect.
    "
!

asMonochromeFormOn:aDevice
    "get a monochrome device form"

    |form|

    ((aDevice == device) and:[monoDeviceForm notNil]) ifTrue:[^ monoDeviceForm].
    self depth == 1 ifTrue:[
        ((aDevice == device) and:[deviceForm notNil]) ifTrue:[^ deviceForm].
        ^ self asFormOn:aDevice
    ].

    form := self asMonochromeFormOn:aDevice dither:DitherAlgorithm.

    (device isNil or:[aDevice == device]) ifTrue:[
        "remember this form in the receiver ..."

        form notNil ifTrue:[
            form := form asImageForm.
            monoDeviceForm := form.
            device isNil ifTrue:[
                device := aDevice.
                Lobby register:self
            ] ifFalse:[
                Lobby registerChange:self
            ].
            "
             can save space, by not keeping the images data-bits
             twice (here and in the device form)
            "
            form forgetBits
        ]
    ].

    ^ form

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     (i asMonochromeFormOn:Display) inspect.
    "

    "Modified: 23.10.1997 / 00:44:59 / cg"
!

asMonochromeFormOn:aDevice dither:aDitherAlgorithm
    "get a monochrome device form, using aDitherAlgorithm."

    |monoBits|

    (aDitherAlgorithm isNil
    or:[aDitherAlgorithm == #threshold]) ifTrue:[
        ^ self asThresholdMonochromeFormOn:aDevice
    ].

    aDitherAlgorithm == #burkes ifTrue:[
        monoBits := self burkesDitheredMonochromeBits.
    ] ifFalse:[
        aDitherAlgorithm == #stevensonArce ifTrue:[
            monoBits := self stevensonArceDitheredMonochromeBits.
        ] ifFalse:[
            (aDitherAlgorithm == #pattern
            or:[aDitherAlgorithm == #ordered]) ifTrue:[
                ^ self asOrderedDitheredGrayFormOn:aDevice.
            ] ifFalse:[
                ^ self asFloydSteinbergDitheredMonochromeFormOn:aDevice.
            ]
        ]
    ].

    "/
    "/ make its pixel interpretation correct for the device
    "/
    ^ self makeDeviceMonochromeBitmapOn:aDevice fromArray:monoBits

    "Modified: 10.6.1996 / 20:18:05 / cg"
!

asNearestPaintDepth8FormOn:aDevice colors:fixColors
    "return a nearest paint pseudoForm from the palette picture.
     Use the colors in the fixColors array.
     By passing the ditherColors as extra array, this method can
     also be used to dither an 8bit image into a smaller number of colors,
     for example to create dithered Depth4Images from Depth8Images."

    ^ self asNearestPaintDepth8FormOn:aDevice colors:fixColors nRed:nil nGreen:nil nBlue:nil.

    "
     example:
        color reduction from Depth8 to Depth4 can be done by:

     |img8 reducedImg8 img4 map form|

     map := #(
                  (0     0   0)
                  (0     0 100)
                  (0    50   0)
                  (0    50 100)
                  (0   100   0)
                  (0   100 100)
                  (100   0   0)
                  (100   0 100)
                  (100  50   0)
                  (100  50 100)
                  (100 100   0)
                  (100 100 100)) collect:[:rgb | (Color red:(rgb at:1)
                                                      green:(rgb at:2)
                                                       blue:(rgb at:3)) onDevice:Display].

     img8 := Image fromFile:'goodies/bitmaps/claus.gif'.
     form := img8 asNearestPaintDepth8FormOn:Display
                      colors:map
                        nRed:2
                      nGreen:3
                       nBlue:2.
     img8 := Depth8Image fromForm:form.    'dithered version of original image'.
     img4 := Depth4Image fromImage:img8.
    "

    "Modified: 17.6.1996 / 18:52:47 / cg"
    "Created: 23.6.1997 / 15:26:09 / cg"
!

asNearestPaintDepth8FormOn:aDevice colors:fixColors nRed:nRed nGreen:nGreen nBlue:nBlue
    "return a nearest paint pseudoForm from the palette picture.
     Use the colors in the fixColors array, which must be fixR x fixG x fixB
     colors assigned to aDevice, such as the preallocated colors of the
     Color class.
     By passing the ditherColors as extra array, this method can
     also be used to dither an 8bit image into a smaller number of colors,
     for example to create dithered Depth4Images from Depth8Images."

    |pseudoBits f deviceDepth map|

    deviceDepth := aDevice depth.
    deviceDepth == 8 ifFalse:[
        (aDevice supportedImageFormatForDepth:8) isNil ifTrue:[
            ^ nil
        ]
    ].

    pseudoBits := self nearestPaintDepth8BitsColors:fixColors nRed:nRed nGreen:nGreen nBlue:nBlue.
    pseudoBits isNil ifTrue:[^ nil].

    f := Form width:width height:height depth:deviceDepth onDevice:aDevice.
    f isNil ifTrue:[^ nil].

    "/
    "/ have to create a funny colorMap, where
    "/ color at:index == color colorId:index
    "/
    map := Array new:256.
    fixColors do:[:clr |
        map at:clr colorId + 1 put:clr
    ].
    f colorMap:map.
    f bits:pseudoBits.
    aDevice
        drawBits:pseudoBits
        bitsPerPixel:8
        depth:deviceDepth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id) x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f

    "
     example:
        color reduction from Depth8 to Depth4 (dithering) can be done by:

     |img8 reducedImg8 img4 map form|

     map := #(
                  (0     0   0)
                  (0     0 100)
                  (0    50   0)
                  (0    50 100)
                  (0   100   0)
                  (0   100 100)
                  (100   0   0)
                  (100   0 100)
                  (100  50   0)
                  (100  50 100)
                  (100 100   0)
                  (100 100 100)) collect:[:rgb | (Color red:(rgb at:1)
                                                      green:(rgb at:2)
                                                       blue:(rgb at:3)) onDevice:Display].

     img8 := Image fromFile:'goodies/bitmaps/claus.gif'.
     form := img8 asNearestPaintDepth8FormOn:Display
                      colors:map
                        nRed:2
                      nGreen:3
                       nBlue:2.
     img8 := Depth8Image fromForm:form.    'dithered version of original image'.
     img4 := Depth4Image fromImage:img8.
    "

    "Created: 17.6.1996 / 18:47:46 / cg"
    "Modified: 17.6.1996 / 18:52:47 / cg"
!

asNearestPaintImageDepth:d colors:colors
    "return a threshold image from the receiver picture, using colors in colors."

    |newBits|

    d ~~ 8 ifTrue:[
        self error:'unsupported depth'
    ].
    newBits := self nearestPaintDepth8BitsColors:colors nRed:nil nGreen:nil nBlue:nil.
    newBits isNil ifTrue:[
        self error:'conversion failed'
    ].
    ^ (self class newForDepth:d) extent:(self extent); depth:d; palette:colors; bits:newBits; yourself

    "Modified: / 30-01-2017 / 19:40:28 / stefan"
!

asOrderedDitheredGrayFormOn:aDevice
    "return a dithered depth-x grey form from the receiver image.
     Uses an 8x8 dithermatrix."

    |depth bits|

    depth := aDevice depth.
    (depth == 1
    or:[aDevice hasGrayscales not]) ifTrue:[
        "/ for monochrome, there is highly specialized
        "/ monochrome dither code available

        ^ self asOrderedDitheredMonochromeFormOn:aDevice
    ].

    bits := self
                orderedDitheredGrayBitsWithDitherMatrix:(self class orderedDitherMatrixOfSize:8)
                ditherWidth:8
                depth:depth.

    ^ self makeDeviceGrayPixmapOn:aDevice depth:depth fromArray:bits

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/claus.gif'.
     (i asOrderedDitheredGrayFormOn:Display) inspect
    "

    "Modified: 24.6.1997 / 22:19:30 / cg"
!

asOrderedDitheredGrayImageDepth:depth
    "return a dithered depth-x grey image from the receiver image.
     Uses an 8x8 dithermatrix."

    |dither|

    dither := self class orderedDitherMatrixOfSize:8.

    (depth == 1) ifTrue:[
        "/ for monochrome, there is highly specialized
        "/ monochrome dither code available

        ^ Depth1Image
            width:width
            height:height
            fromArray:(
                self
                    orderedDitheredMonochromeBitsWithDitherMatrix:dither
                    ditherWidth:8)
    ].

    ^ (self class implementorForDepth:depth)
        width:width
        height:height
        fromArray:(
            self
                orderedDitheredGrayBitsWithDitherMatrix:dither
                ditherWidth:8
                depth:depth)

    "
     |i i1 i2 i4 i8|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i1 := i asOrderedDitheredGrayImageDepth:1.
     i1 inspect.

     i2 := i asOrderedDitheredGrayImageDepth:2.
     i2 inspect.

     i4 := i asOrderedDitheredGrayImageDepth:4.
     i4 inspect.

     i8 := i asOrderedDitheredGrayImageDepth:8.
     i8 inspect.
    "

    "
     |i i1 i2 i4 i8|
     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i1 := i asOrderedDitheredGrayImageDepth:1.
     i1 inspect.

     i2 := i asOrderedDitheredGrayImageDepth:2.
     i2 inspect.

     i4 := i asOrderedDitheredGrayImageDepth:4.
     i4 inspect.

     i8 := i asOrderedDitheredGrayImageDepth:8.
     i8 inspect.

     i2 := i8 asOrderedDitheredGrayImageDepth:2.
     i2 inspect.
    "

    "Created: 7.6.1996 / 18:03:54 / cg"
    "Modified: 24.6.1997 / 22:19:36 / cg"
!

asOrderedDitheredMonochromeFormOn:aDevice
    "return a dithered monochrome form from the grey image.
     Uses a 4x4 dithermatrix."

    "/ 4x4 seems a good comprimize between:
    "/    number of grey levels (8x8 is better)
    "/    artifacts             (4x4 is better)
    "/
    "/ could look at the image and decide upon the number of
    "/ distinct colors present. Use 8x8 for high-number,
    "/ 4x4 for small number of colors ...

    ^ self
        asOrderedDitheredMonochromeFormOn:aDevice
        ditherMatrix:(self class orderedDitherMatrixOfSize:4)
        ditherWidth:4

"/    ^ self
"/        asOrderedDitheredMonochromeFormOn:aDevice
"/        ditherMatrix:(self class orderedDitherMatrixOfSize:8)
"/        ditherWidth:8

    "
     |i f|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     f := i asOrderedDitheredMonochromeFormOn:Display.


     |i f|

     i := (Image fromFile:'goodies/bitmaps/winBitmaps/a11.ico') magnifiedBy:10.
     f := i asOrderedDitheredMonochromeFormOn:Display.


     |i f|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     f := i asOrderedDitheredMonochromeFormOn:Display.


     |i f|

     i := (Image fromFile:'doc/online/pictures/PasteButton.gif') magnifiedBy:10.
     f := i asOrderedDitheredMonochromeFormOn:Display.


     |i f|

     i := (Image fromFile:'goodies/bitmaps/gifImages/blue-ball.gif') magnifiedBy:1.
     f := i asOrderedDitheredMonochromeFormOn:Display.
    "

    "Created: 7.6.1996 / 14:52:32 / cg"
    "Modified: 17.4.1997 / 01:10:10 / cg"
!

asOrderedDitheredMonochromeFormOn:aDevice ditherMatrix:ditherMatrix ditherWidth:dW
    "return a dithered monochrome form from the image.
     Uses the passed ditherMatrix and ditherWidth."

    |monoBits|

    monoBits := self orderedDitheredMonochromeBitsWithDitherMatrix:ditherMatrix ditherWidth:dW.
    ^ self makeDeviceMonochromeBitmapOn:aDevice fromArray:monoBits


    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     (i asOrderedDitheredMonochromeFormOn:Display) inspect


     |i|

     i := Image fromFile:'goodies/bitmaps/granite.tiff'.
     (i asOrderedDitheredMonochromeFormOn:Display) inspect


     |i|

     i := (Image fromFile:'goodies/bitmaps/PasteButton.tiff') magnifiedBy:10.
     (i asOrderedDitheredMonochromeFormOn:Display) inspect
    "

    "Created: 7.6.1996 / 14:51:42 / cg"
    "Modified: 17.4.1997 / 01:08:24 / cg"
!

asOrderedDitheredMonochromeImage
    "return a dithered monochrome image from the receiver image.
     Uses a 4x4 dithermatrix."

    "/ 4x4 seems a good comprimize between:
    "/    number of grey levels (8x8 is better)
    "/    artifacts             (4x4 is better)
    "/
    "/ could look at the image and decide upon the number of
    "/ distinct colors present. Use 8x8 for high-number,
    "/ 4x4 for small number of colors ...

    ^ self
        asOrderedDitheredMonochromeImageWithDitherMatrix:(self class orderedDitherMatrixOfSize:4)
        ditherWidth:4

"/    ^ self
"/        asOrderedDitheredMonochromeImageWithDitherMatrix:(self class orderedDitherMatrixOfSize:8)
"/        ditherWidth:8

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i asOrderedDitheredMonochromeImage inspect


     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i asOrderedDitheredMonochromeImage inspect


     |i|

     i := (Image fromFile:'doc/online/pictures/PasteButton.gif') magnifiedBy:10.
     i asOrderedDitheredMonochromeImage inspect


     |i|

     i := (Image fromFile:'goodies/bitmaps/gifImages/blue-ball.gif') magnifiedBy:1.
     i asOrderedDitheredMonochromeImage inspect


     |i|

     i := Image fromFile:'libwidg3/bitmaps/granite.tiff'.
     i asOrderedDitheredMonochromeImage inspect
    "

    "Created: 7.6.1996 / 15:02:07 / cg"
    "Modified: 10.6.1996 / 11:15:09 / cg"
!

asOrderedDitheredMonochromeImageWithDitherMatrix:ditherMatrix ditherWidth:dW
    "return a dithered monochrome image from the receiver image.
     Uses the passed ditherMatrix and ditherWidth."

    |monoBits|

    monoBits := self orderedDitheredMonochromeBitsWithDitherMatrix:ditherMatrix ditherWidth:dW.
    ^ (Depth1Image width:width height:height fromArray:monoBits) photometric:#blackIs0

    "order-4 dither:

     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i
        asOrderedDitheredMonochromeImageWithDitherMatrix:(Image orderedDitherMatrixOfSize:4)
        ditherWidth:4
    "

    "order-6 dither:

     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i
        asOrderedDitheredMonochromeImageWithDitherMatrix:(Image orderedDitherMatrixOfSize:8)
        ditherWidth:8
    "


    "thresholding at:0.5 (all above 0.5 becomes white):

     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i
        asOrderedDitheredMonochromeImageWithDitherMatrix:(ByteArray new:16 withAll:8)
        ditherWidth:4
    "

    "thresholding at: 0.25 (all above 0.25 becomes white):

     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i
        asOrderedDitheredMonochromeImageWithDitherMatrix:(ByteArray new:16 withAll:3)
        ditherWidth:4
    "

    "thresholding at: 0.75 (all above 0.75 becomes white):

     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i
        asOrderedDitheredMonochromeImageWithDitherMatrix:(ByteArray new:16 withAll:11)
        ditherWidth:4
    "

    "Modified: 7.6.1996 / 17:23:47 / cg"
!

asPseudoFormQuickOn:aDevice
    "return a pseudo-deviceForm from the image.
     Fail if any color is not available (i.e. do not dither)."

    |f d
     temp temp8 bits clr cMap idMap
     w            "{ Class: SmallInteger }"
     h            "{ Class: SmallInteger }"
     dDev         "{ Class: SmallInteger }"
     nClr         "{ Class: SmallInteger }"
     bytesPerLine "{ Class: SmallInteger }"
     usedColors pix fmt bytes|

    d := self depth.
    (d == 1
    or:[d == 2
    or:[d == 4
    or:[d == 8]]]) ifFalse:[^ nil].

    bytes := self bits.
    w := width.
    h := height.

    "/ for now (since the code below does not care for padding;
    "/ if the padding is not supported: fail

    dDev := aDevice depth.
    (bytesPerLine := dDev) == 8 ifFalse:[
        bytesPerLine := (w * dDev + 7) // 8.
    ].

    fmt := aDevice supportedImageFormatForDepth:dDev.
    fmt isNil ifTrue:[
        "/ cannot draw directly
        ^ nil
    ].
    (bytesPerLine * 8) \\ (fmt at:#padding) == 0 ifFalse:[
        "/ mhmh - ought to repad here;
        "/ however, the nonQuick converter does it.
        ^ nil
    ].

    "/ see if all of the images colors are representable
    "/ on the device

    bits := self bitsPerPixel.
    nClr := (1 bitShift:bits).
    cMap := Array new:nClr.
    idMap := ByteArray new:nClr.

    photometric == #palette ifTrue:[
        nClr := nClr min:(colorMap size)
    ].

    d == 8 ifTrue:[
        usedColors := bytes usedValues.    "gets us an array filled with used values"
        1 to:nClr do:[:pixel |
            (usedColors includes:(pixel - 1)) ifFalse:[
                clr := Color black
            ] ifTrue:[
                clr := self colorFromValue:pixel-1.
                clr := clr exactOn:aDevice.
                clr isNil ifTrue:[^ nil].
            ].
            (pix := clr colorId) isNil ifTrue:[^ nil].

            cMap at:(pixel) put:clr.
            idMap at:(pixel) put:pix.
        ].
    ] ifFalse:[
        1 to:nClr do:[:pixel |
            clr := self colorFromValue:pixel-1.
            clr := clr exactOn:aDevice.
            clr isNil ifTrue:[^ nil].
            (pix := clr colorId) isNil ifTrue:[^ nil].

            cMap at:(pixel) put:clr.
            idMap at:(pixel) put:pix.
        ].
    ].

    "/ got all colors; good - simply change depth & translate pixels

    (d == 8 and:[dDev == 8]) ifTrue:[
        "/ only translate
        temp := ByteArray uninitializedNew:(w * h).
        bytes expandPixels:8         "xlate only"
                    width:w
                   height:h
                     into:temp
                  mapping:idMap.
    ] ifFalse:[
        "/ stupid: expandPixels can only handle any-to-8
        "/ compressPixels can only handle 8-to-any
        "/ However, those methods are faster
        "/ - even if we convert twice.
        "/ Therefore, convert first from myDepth to 8,
        "/ then from 8 to the device depth.

        d ~~ 8 ifTrue:[
            temp8 := ByteArray uninitializedNew:(w * h).

            bytes expandPixels:d
                         width:w
                        height:h
                          into:temp8
                       mapping:idMap.
            idMap := nil.
        ] ifFalse:[
            temp8 := bytes.
        ].

        dDev ~~ 8 ifTrue:[
            temp := ByteArray uninitializedNew:(bytesPerLine * h).

            temp8 compressPixels:dDev
                         width:w
                        height:h
                          into:temp
                       mapping:idMap.
        ] ifFalse:[
            temp := temp8
        ].
    ].

    f := Form width:w height:h depth:dDev onDevice:aDevice.
    f isNil ifTrue:[^ nil].

    f colorMap:cMap.

    aDevice
        drawBits:temp
        depth:dDev
        padding:8
        width:w
        height:h
        x:0 y:0
        into:(f id) x:0 y:0
        width:w
        height:h
        with:(f initGC).

    ^ f

    "
     (
        (((Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ]))
               magnifiedBy:30
         )
          asPseudoFormQuickOn:Display
      ) inspect
     "

    "Modified: / 7.5.1998 / 19:40:47 / cg"
!

asStevensonArceDitheredMonochromeImage
    "return a stevenson-arce dithered monochrome image from the receiver image.
     Depending on the images contents, this may or may not look better than
     a floyd-steinberg dithered image.
     Notice that floyd-steinberg dithering is faster; both because less
     error diffusion is done and due to being specially tuned."

    |monoBits|

    monoBits := self stevensonArceDitheredMonochromeBits.
    ^ (Depth1Image width:width height:height fromArray:monoBits) photometric:#blackIs0

    "
     |i|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     i asFloydSteinbergDitheredMonochromeImage inspect.
     i asBurkesDitheredMonochromeImage inspect.
     i asStevensonArceDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
     (i asThresholdMonochromeImage:0.5) inspect
    "

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     i asFloydSteinbergDitheredMonochromeImage inspect.
     i asBurkesDitheredMonochromeImage inspect.
     i asStevensonArceDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "
     |i|

     i := Depth4Image
             width:4
             height:4
             fromArray:#[
                            16r01 16r23
                            16r45 16r67
                            16r89 16rab
                            16rcd 16ref
                        ].
     i := i magnifiedBy:30.
     i inspect.
     i asStevensonArceDitheredMonochromeImage inspect.
     i asOrderedDitheredMonochromeImage inspect.
    "

    "Created: 10.6.1996 / 12:38:29 / cg"
    "Modified: 12.6.1996 / 13:58:24 / cg"
!

asThresholdGrayFormOn:aDevice
    "return a thresholded grey form from the receiver image."

    |depth|

    (depth := aDevice depth) == 1 ifTrue:[
        ^ self asThresholdMonochromeFormOn:aDevice
    ].

    ^ self
        makeDeviceGrayPixmapOn:aDevice
        depth:depth
        fromArray:(self
                        orderedDitheredGrayBitsWithDitherMatrix:#[8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8]
                        ditherWidth:4
                        depth:depth)

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/claus.gif'.
     (i asThresholdGrayFormOn:Display) inspect.
    "

    "Created: 10.6.1996 / 18:38:31 / cg"
    "Modified: 24.6.1997 / 22:19:46 / cg"
!

asThresholdGrayImageDepth:depth
    "return a thresholded depth-x grey image from the receiver image."

    (depth == 1) ifTrue:[
        "/ for monochrome, there is highly specialized
        "/ monochrome dither code available

        ^ Depth1Image
            width:width
            height:height
            fromArray:(
                self
                    orderedDitheredMonochromeBitsWithDitherMatrix:#[8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8]
                    ditherWidth:4)
    ].

    ^ (self class implementorForDepth:depth)
        width:width
        height:height
        fromArray:(
            self
                orderedDitheredGrayBitsWithDitherMatrix:#[8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8]
                ditherWidth:4
                depth:depth)

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/claus.gif'.
     (i asThresholdGrayImageDepth:1) inspect.
     (i asThresholdGrayImageDepth:2) inspect.
     (i asThresholdGrayImageDepth:4) inspect.
     (i asThresholdGrayImageDepth:8) inspect.

     (i asOrderedDitheredGrayImageDepth:1) inspect.
     (i asOrderedDitheredGrayImageDepth:2) inspect.
     (i asOrderedDitheredGrayImageDepth:4) inspect.
     (i asOrderedDitheredGrayImageDepth:8) inspect.

     (i asFloydSteinbergDitheredGrayImageDepth:1) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:2) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:4) inspect.
     (i asFloydSteinbergDitheredGrayImageDepth:8) inspect.
    "

    "Created: 7.6.1996 / 18:13:33 / cg"
    "Modified: 24.6.1997 / 22:19:52 / cg"
!

asThresholdMonochromeFormOn:aDevice
    "return a threshold monochrome form from the image."

    ^ self
        asOrderedDitheredMonochromeFormOn:aDevice
        ditherMatrix:#[8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8]
        ditherWidth:4

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/claus.gif'.
     i inspect.
     (i asThresholdMonochromeFormOn:Display) inspect


     |i|

     i := (Image fromFile:'goodies/bitmaps/a11.ico') magnifiedBy:10.
     i inspect.
     (i asThresholdMonochromeFormOn:Display) inspect


     |i|

     i := Image fromFile:'goodies/bitmaps/granite.tiff'.
     i inspect.
     (i asThresholdMonochromeFormOn:Display) inspect


     |i|

     i := (Image fromFile:'goodies/bitmaps/PasteButton.tiff') magnifiedBy:10.
     i inspect.
     (i asThresholdMonochromeFormOn:Display) inspect
    "

    "Created: 7.6.1996 / 16:15:17 / cg"
    "Modified: 10.6.1996 / 17:44:29 / cg"
!

asThresholdMonochromeImage
    "return a threshold monochrome image from the image.
     Threshold means: brightness < 0.5 -> black / otherwise white"

    ^ self
        asOrderedDitheredMonochromeImageWithDitherMatrix:#[8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8]
        ditherWidth:4

    "
     |i i2|

     i := Image fromFile:'goodies/bitmaps/claus.gif'.
     i2 := i asThresholdMonochromeImage


     |i i2|

     i := (Image fromFile:'/cdrom/icons/a/a11.ico') magnifiedBy:10.
     i2 := i asThresholdMonochromeImage


     |i i2|

     i := Image fromFile:'goodies/bitmaps/granite.tiff'.
     i2 := i asThresholdMonochromeImage


     |i i2|

     i := (Image fromFile:'goodies/bitmaps/PasteButton.tiff') magnifiedBy:10.
     i2 := i asThresholdMonochromeImage
    "

    "Created: 7.6.1996 / 16:15:17 / cg"
    "Modified: 7.6.1996 / 17:16:10 / cg"
!

asThresholdMonochromeImage:thresholdBrighness
    "return a threshold monochrome image from the image.
     The argument (0..1) gives the threshold value;
     Threshold means: brightness < threshold -> black / otherwise white"

    |value ditherMatrix|

    value := thresholdBrighness * 255.
    ditherMatrix := ByteArray new:256 withAll:(value truncated).

    ^ self
        asOrderedDitheredMonochromeImageWithDitherMatrix:ditherMatrix
        ditherWidth:16

    "
     |i|

     i := Image width:4 height:4 depth:4
                fromArray:#[ 16r01 16r23
                             16r45 16r67
                             16r89 16rab
                             16rcd 16ref ].
     i := i magnifiedBy:30.
     i inspect.
     (i asThresholdMonochromeImage:0.125) inspect.
     (i asThresholdMonochromeImage:0.25) inspect.
     (i asThresholdMonochromeImage:0.5) inspect.
     (i asThresholdMonochromeImage:0.75) inspect.
     (i asThresholdMonochromeImage:1) inspect.
    "

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/claus.gif'.
     i inspect.
     (i asThresholdMonochromeImage:0.125) inspect.
     (i asThresholdMonochromeImage:0.25) inspect.
     (i asThresholdMonochromeImage:0.5) inspect.
     (i asThresholdMonochromeImage:0.625) inspect.
     (i asThresholdMonochromeImage:0.75) inspect.
    "

    "Created: 7.6.1996 / 16:15:17 / cg"
    "Modified: 8.6.1996 / 14:51:57 / cg"
!

clearMaskedPixels
    "assuming that I already have a device representation
     in deviceForm, clear any masked pixels.
     This will allow faster drawing in the future."

    maskedPixelsAre0 == true ifTrue:[^ self].   "/ already cleared
    mask isNil ifTrue:[^ self].         "/ no mask
    deviceForm isNil ifTrue:[^ self].   "/ no device rep.
    mask depth ~~ 1 ifTrue:[^ self].    "/ not done with alpha masks

    deviceForm clearMaskedPixels:(mask asFormOn:device).
    maskedPixelsAre0 := true.


    "Created: 12.4.1997 / 12:18:05 / cg"
    "Modified: 12.4.1997 / 12:20:19 / cg"
!

exactOn:aDevice
    "for compatibility with color protocol - here, the same as #onDevice."

    ^ self onDevice:aDevice
!

exactOrNearestOn:aDevice
    "for compatibility with color protocol - here, the same as #onDevice."

    ^ self onDevice:aDevice
!

fromForm:aForm
    "setup the receiver from a form"

    |map c0 c1|

    width := aForm width.
    height := aForm height.
    bitsPerSample := self bitsPerSample.
    samplesPerPixel := self samplesPerPixel.

    aForm hasBits ifFalse:[
        "/ must read the data from the device
        self from:aForm in:(0@0 extent:aForm extent).
        ^ self
    ].

    "/ the form has all data available

    self bits:(aForm bits).
    map := aForm colorMap.

    aForm depth == 1 ifTrue:[
        map isNil ifTrue:[
            photometric := #whiteIs0
        ] ifFalse:[
            c0 := map at:1.
            c1 := map at:2.
            ((c0 = Color white)
            and:[c1 = Color black]) ifTrue:[
                photometric := #whiteIs0
            ] ifFalse:[
                ((c0 = Color black)
                and:[c1 = Color white]) ifTrue:[
                    photometric := #blackIs0
                ] ifFalse:[
                    photometric := #palette.
                    self setColorMap:(Array with:c0 with:c1).
                ]
            ]
        ]
    ] ifFalse:[
        map notNil ifTrue:[
            photometric := #palette.
            self setColorMap:(map copy).
        ] ifFalse:[
            "
             photometric stays at default
             (which is rgb for d24, greyscale for others)
            "
        ]
    ].

    "Modified: 5.7.1996 / 16:24:31 / cg"
!

fromImage:anImage
    "setup the receiver from another image.
     Color precision may be lost, if conversion is from a higher depth image.
     WARNING:
     This implementation is a slow fallback (the loop over the
     source pixels is very slow). If this method is used heavily, you
     may want to redefine it in concrete subclasses for common source images."

    ^ self fromImage:anImage photometric:nil
!

fromImage:anImage photometric:photometricOrNil
    "setup the receiver from another image and optionally set the photometric.
     Color precision may be lost, if conversion is from a higher depth image.
     WARNING:
     This implementation is a slow fallback (the loop over the
     source pixels is very slow). If this method is used heavily, you
     may want to redefine it in concrete subclasses for common source images."

    |map clr mappedRowPixels samePhotometric
     h "{ Class: SmallInteger }"
     w "{ Class: SmallInteger }" myDepth otherDepth|

    width := anImage width.
    height := anImage height.
    bitsPerSample := self bitsPerSample.
    samplesPerPixel := self samplesPerPixel.

    photometricOrNil isNil ifTrue:[
        photometric := self class defaultPhotometric
        "/ photometric := anImage photometric
    ] ifFalse:[
        photometricOrNil == #rgba ifTrue:[
            samplesPerPixel == 3 ifTrue:[ photometric := #rgb ]
        ] ifFalse:[
            photometric := photometricOrNil
        ].
    ].

    photometric == #palette ifTrue:[
        self colormapFromImage:anImage photometric:photometric.
    ].
    self mask:anImage mask.

    samePhotometric := photometric == anImage photometric.
    myDepth := self depth.
    otherDepth := anImage depth.

    ((myDepth = otherDepth) and:[samePhotometric]) ifTrue:[
        self bits:(anImage bits copy).
        ^ self.
    ].

    self bits:(ByteArray new: "uninitializedNew:"(self bytesPerRow * height)).

    myDepth >= otherDepth ifTrue:[
        otherDepth <= 12 ifTrue:[

            "/ if my depth is greater, all colors can be represented,
            "/ and the loop can be done over pixel values ...

            (colorMap isNil or:[samePhotometric not]) ifTrue:[
                map := Array new:(1 bitShift:otherDepth).
                1 to:map size do:[:i |
                    clr := anImage colorFromValue:(i - 1).
                    map at:i put:(self valueFromColor:clr).
                ].
            ].
            mappedRowPixels := self pixelArraySpecies new:width.
            h := height-1.
            w := width.
            0 to:h do:[:row |
                anImage rowAt:row into:mappedRowPixels startingAt:1.
                map notNil ifTrue:[
                    1 to:w do:[:i |
                        mappedRowPixels at:i put:(map at:(mappedRowPixels at:i)+1)
                    ].
                ].
                self rowAt:row putAll:mappedRowPixels
            ].
            ^ self
        ].
    ].

    "/ a hack, for now - alpha is in the low-byte !!!!!!
    (myDepth == 24 and:[otherDepth == 32]) ifTrue:[
        (samePhotometric and:[photometric == #rgb]) ifTrue:[
            "/ can do the bits by simple stripping off the alpha channel
            self copyPixels32AlphaLowTo24From:anImage.
"/    anImage valuesFromX:0 y:0 toX:(width-1) y:(height-1) do:[:x :y :pixel |
"/        |a r g b rgbPixel|
"/
"/        "/ bgra-pixel
"/        "/ a := pixel bitAnd:16rFF.
"/        r := (pixel bitShift:-8) bitAnd:16rFF.
"/        g := (pixel bitShift:-16) bitAnd:16rFF.
"/        b := (pixel bitShift:-24) bitAnd:16rFF.
"/        rgbPixel := r + (g bitShift:8) + (b bitShift:16).
"/        self pixelAtX:x y:y put:rgbPixel
"/    ].
            ^ self
        ].
    ].

    anImage colorsFromX:0 y:0 toX:(width-1) y:(height-1) do:[:x :y :clr |
        self colorAtX:x y:y put:clr
    ].

    "
     |i i2 i4 i8 i16 i24|

     i := GenericToolbarIconLibrary desktop32x32Icon2.
     i inspect.
     i2 := Depth2Image fromImage:i.
     i2 inspect.
     i4 := Depth4Image fromImage:i.
     i4 inspect.
     i8 := Depth8Image fromImage:i.
     i8 inspect.
     i16 := Depth16Image fromImage:i.
     i16 inspect.
     i24 := Depth24Image fromImage:i.
     i24 inspect.
    "

    "
     |i i24|

     i := Image fromFile:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'.
     Transcript showCR:(
        Time millisecondsToRun:[
            i24 := Depth24Image fromImage:i.
        ]
     ).
     i24 inspect.
    "
    "
     |i i24|

     i := Image fromFile:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'.
     MessageTally spyOn:[
        i24 := Depth24Image fromImage:i.
     ]
    "

    "Modified: / 22-11-2016 / 03:34:08 / cg"
    "Modified (format): / 30-01-2017 / 20:46:22 / stefan"
!

fromSubImage:anImage in:aRectangle
    "setup the receiver from another image, extracting a rectangular area.
     As with layouts, the rectangle may contain integers (= nr of pixels) or float numbers (= relative size).
     Color precision may be lost, if conversion is from a higher depth image.
     For palette & rgb images, this may fail if a color cannot be represented."

    |w h xL yT imgWidth imgHeight|

    w := aRectangle width.
    h := aRectangle height.
    xL := aRectangle left.
    yT := aRectangle top.
    imgWidth := anImage width.
    imgHeight := anImage height.

    xL isFloat ifTrue:[
        xL := (imgWidth * xL) rounded min: imgWidth.
    ].
    yT isFloat ifTrue:[
        yT := (imgHeight * yT) rounded min:imgHeight.
    ].
    w isFloat ifTrue:[
        w := (imgWidth * w) rounded.
    ].
    w := w min:(imgWidth - xL).
    h isFloat ifTrue:[
        h := (imgHeight * h) rounded.
    ].
    h := h min:(imgHeight - yT).
    self fromSubImage:anImage inX:xL y:yT width:w height:h

    "
     |i i2 i4 i8 i16 i24|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     i4 := Depth4Image fromSubImage:i in:(300@160 corner:340@200).
     i4 inspect.
     i8 := Depth8Image fromSubImage:i in:(300@160 corner:340@200).
     i8 inspect.
     i24 := Depth24Image fromSubImage:i in:(300@160 corner:340@200).
     i24 inspect.
    "

    "Created: / 20.9.1995 / 01:06:02 / claus"
    "Modified: / 20.9.1995 / 10:15:37 / claus"
    "Modified: / 18.5.1999 / 20:06:55 / cg"
!

fromSubImage:anImage inX:xL y:yT width:w height:h
    "setup the receiver from another image, extracting a rectangular area.
     Color precision may be lost, if conversion is from a higher depth image.
     For palette & rgb images, this may fail if a color cannot be represented.

     WARNING:
       This implementation is a slow fallback (the loop over the
       source pixels is very slow). If this method is used heavily, you
       may want to redefine it in concrete subclasses for the common case of
       of creating a subImage with the same depth & palette."

    |xR yB imagesMask maskClass|

    width := w.
    height := h.

    self createPixelStore.
    depth := self depth.
    bitsPerSample := self bitsPerSample.
    "/ bitsPerPixel := self bitsPerPixel.
    samplesPerPixel := self samplesPerPixel.
    self colormapFromImage:anImage.

    xR := xL + w - 1.
    yB := yT + h - 1.

    ((photometric == anImage photometric)
    and:[self bitsPerPixel = anImage bitsPerPixel
    and:[colorMap = anImage colorMap]]) ifTrue:[
        "/ can do it by value
        anImage
            valuesFromX:xL y:yT toX:xR y:yB
            do:[:x :y :pixelValue | self pixelAtX:x-xL y:y-yT put:pixelValue ]
    ] ifFalse:[
        "/ must do it by colors
        anImage
            colorsFromX:xL y:yT toX:xR y:yB
            do:[:x :y :clr | self colorAtX:x-xL y:y-yT put:clr ]
    ].

    (imagesMask := anImage mask) notNil ifTrue:[
        imagesMask depth == 1 ifTrue:[
            maskClass := ImageMask
        ] ifFalse:[
            maskClass := imagesMask class.
        ].
        mask := maskClass new fromSubImage:imagesMask inX:xL y:yT width:w height:h
    ].

    "
     |i i2 i4 i8 i16 i24|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     i4 := Depth4Image fromSubImage:i in:(300@160 corner:340@200).
     i4 inspect.
     i8 := Depth8Image fromSubImage:i in:(300@160 corner:340@200).
     i8 inspect.
     i24 := Depth24Image fromSubImage:i in:(300@160 corner:340@200).
     i24 inspect.
    "

    "Created: / 20.9.1995 / 01:06:02 / claus"
    "Modified: / 20.9.1995 / 10:15:37 / claus"
    "Modified: / 18.5.1999 / 20:06:55 / cg"
!

monochromeOn:aDevice
    "return a monochrome device image of the receiver for aDevice.
     (monochrome, even if device supports colors)"

    ((aDevice == device) and:[monoDeviceForm notNil]) ifTrue:[^ self].
    (device notNil and:[aDevice ~~ device]) ifTrue:[
        "oops, I am already accociated to another device
         - need a copy ...
        "
        ^ self copy monochromeOn:aDevice
    ].
    monoDeviceForm := self asMonochromeFormOn:aDevice.
!

nearestOn:aDevice
    "for compatibility with color protocol - here, the same as #onDevice."

    ^ self onDevice:aDevice
!

on:aDevice
    "return an image with the same pixels as the receiver, but
     associated to aDevice. If the receiver is not yet bound to
     a device, this will be the receiver. Otherwise, a new image
     is returned."

    "/ send out a warning: #on: is typically used to create views
    "/ operating on a model.
    "/ Please use #onDevice: to avoid confusion.

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #onDevice:'.
    ^ self onDevice:aDevice
!

onDevice:aDevice
    "return an image with the same pixels as the receiver, but
     associated to aDevice. If the receiver is not yet bound to
     a device, this will be the receiver. Otherwise, a new image
     is returned."

    aDevice isNil ifTrue:[^ self].
    ((aDevice == device) and:[deviceForm notNil]) ifTrue:[^ self].

    (device notNil and:[aDevice ~~ device]) ifTrue:[
        "oops, I am already associated to another device
         - need a copy ...
        "
        ^ self copy onDevice:aDevice
    ].
    device := aDevice.
    deviceForm := self asFormOn:aDevice.
    maskedPixelsAre0 := nil.
    mask notNil ifTrue:[
        mask := mask onDevice:aDevice.
        self clearMaskedPixels.
    ].
    Lobby register:self

    "Modified: / 22.8.1998 / 13:34:24 / cg"
! !

!Image methodsFor:'converting greyscale images'!

greyImageAsFormOn:aDevice
    "return a grey-deviceForm from the grey image."

    |pictureDepth nPlanes|


    nPlanes := samplesPerPixel.
    (nPlanes == 2) ifTrue:[
        'Image [info]: alpha plane ignored' infoPrintCR.
    ].
    "/ first plane only
    pictureDepth := bitsPerSample at:1.

    "monochrome is very easy ..."

    (pictureDepth == 1) ifTrue:[
        ^ Form width:width height:height fromArray:self bits onDevice:aDevice
    ].

    (aDevice visualType == #TrueColor) ifTrue:[
        ^ self greyImageAsTrueColorFormOn:aDevice
    ].

    "/ PseudoColor conversion also works for StaticColor,
    "/ GrayScale and DirectColor; although possibly with suboptimal results

    ^ self greyImageAsPseudoFormOn:aDevice

    "Modified: 19.10.1997 / 05:17:25 / cg"
!

greyImageAsPseudoFormOn:aDevice
    "return an 8-bit pseudo Form from the grey image"

    |wideBits pictureDepth f map
     colorMap usedColors nUsed aColor
     nColors "{ Class: SmallInteger }"
     range id
     cube nR nG nB grayColors
     fit|

    pictureDepth := bitsPerSample at:1.

    (#[2 4 8] includes:pictureDepth) ifFalse:[
        self error:'currently only depth-2, 4 or 8 supported'.
        ^ nil
    ].

    wideBits := ByteArray uninitializedNew:(width * height).

    (pictureDepth == 8) ifTrue:[
        "for 8bits, we scan for used colors first;
         to avoid allocating too many colors"

        (grayColors := aDevice fixGrayColors) notNil ifTrue:[
            DitherAlgorithm == #floydSteinberg ifTrue:[
                f := self
                       asFloydSteinbergDitheredDepth8FormOn:aDevice
                       colors:grayColors
            ].
            f notNil ifTrue:[^ f].
        ].

        (cube := aDevice fixColors) notNil ifTrue:[
            nR := aDevice numFixRed.
            nG := aDevice numFixGreen.
            nB := aDevice numFixBlue.

            DitherAlgorithm == #floydSteinberg ifTrue:[
                f := self
                       asFloydSteinbergDitheredDepth8FormOn:aDevice
                       colors:cube
                       nRed:nR
                       nGreen:nG
                       nBlue:nB.
            ] ifFalse:[
                f := self
                       asNearestPaintDepth8FormOn:aDevice
                       colors:cube
                       nRed:nR
                       nGreen:nG
                       nBlue:nB.
            ].
            f notNil ifTrue:[^ f].
        ].

        usedColors := self bits usedValues.
        nUsed := usedColors max + 1.

        colorMap := Array new:nUsed.
        range := 100 / 255.0.
        usedColors do:[:grey |
            colorMap at:(grey + 1) put:(Color gray:(range * grey))
        ].
    ] ifFalse:[
        nColors := (1 bitShift:pictureDepth).
        colorMap := Array new:nColors.
        range := 100 / (nColors - 1) asFloat.
        1 to:nColors do:[:i |
            colorMap at:i put:(Color gray:(i - 1) * range).
        ].
    ].
    photometric ~~ #blackIs0 ifTrue:[
        colorMap reverse
    ].

    "allocate those colors & setup the translation map"

    fit := true.
    map := ByteArray uninitializedNew:256.
    nColors := colorMap size.
    1 to:nColors do:[:i |
        aColor := colorMap at:i.
        aColor notNil ifTrue:[
            aColor := aColor onDevice:aDevice.
            colorMap at:i put:aColor.
            id := aColor colorId.
            id isNil ifTrue:[
                id := 0.
                fit := false.
            ].
            map at:i put:id
        ]
    ].

    fit ifFalse:[
        "/ here comes the hard part - some grey value
        "/ could not be allocated.
        "/ Must dither.

    ].

    "expand & translate"
    self bits
        expandPixels:pictureDepth
        width:width height:height
        into:wideBits
        mapping:map.

    f := Form width:width height:height depth:8 onDevice:aDevice.
    f isNil ifTrue:[^ nil].
    f colorMap:colorMap.
    aDevice
        drawBits:wideBits
        depth:8
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id)
        x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f

    "Modified: / 19-10-1997 / 05:19:44 / cg"
    "Modified: / 30-01-2017 / 19:37:01 / stefan"
!

greyImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the grey-image receiver.
     TODO: the pixel loops ought to be implemented as inline primitive code ..."

    |myDepth    "{ Class: SmallInteger }"
     nColors    "{ Class: SmallInteger }"
     colorValues
     scaleDown
     scaleRed   "{ Class: SmallInteger }"
     scaleGreen "{ Class: SmallInteger }"
     scaleBlue  "{ Class: SmallInteger }"
     redShift   "{ Class: SmallInteger }"
     blueShift  "{ Class: SmallInteger }"
     greenShift "{ Class: SmallInteger }"
     form bestFormat usedDeviceDepth usedDeviceBitsPerPixel imageBits
     greyValue  "{ Class: SmallInteger }"
     h          "{ Class: SmallInteger }"
     w          "{ Class: SmallInteger }"
     pixelArray newPixelArray i|

    "/ this is a slow fallback method; this ought to be
    "/ redefined in DepthxImage for more performance.

    myDepth := self depth.
    myDepth > 16 ifTrue:[
        self error:'unsupported depth' mayProceed:true.
        ^ nil
    ].

    "/ compute scale to map from my pixels into devices range

    scaleDown := 1 bitShift:myDepth.
    scaleRed := (1 bitShift:aDevice bitsRed).
    scaleGreen := (1 bitShift:aDevice bitsGreen).
    scaleBlue := (1 bitShift:aDevice bitsBlue).
    redShift := aDevice shiftRed.
    greenShift := aDevice shiftGreen.
    blueShift := aDevice shiftBlue.

    "/ prepare the map

    nColors := (1 bitShift:myDepth).
    colorValues := Array new:nColors.
    1 to:nColors do:[:colorIdx |
        |v gv bv rv nv|

        "/ scale down to 0..1
        v := (colorIdx-1) / scaleDown.
        rv := (v * scaleRed) truncated.
        gv := (v * scaleGreen) truncated.
        bv := (v * scaleBlue) truncated.
        nv := rv bitShift:redShift.
        nv := nv bitOr:(gv bitShift:greenShift).
        nv := nv bitOr:(bv bitShift:blueShift).
        colorValues at:colorIdx put:nv
    ].
    photometric == #whiteIs0 ifTrue:[
        "/ reverse the order; 0 is brightest
        colorValues reverse
    ].

    bestFormat := self bestSupportedImageFormatFor:aDevice.
    usedDeviceDepth := bestFormat at:#depth.
    usedDeviceBitsPerPixel := bestFormat at:#bitsPerPixel.

    "/ the temporary helper image is only needed to allow
    "/ the rowAt:putAll: calls below.

    i := (Image implementorForDepth:usedDeviceBitsPerPixel) new.
    i width:width height:height.
    i createPixelStore.
    imageBits := i bits.

    "/ now, walk over the image and replace
    "/ colorMap indices by color values in the bits array

    h := height - 1.
    w := width - 1.
    pixelArray := self pixelArraySpecies new:width.
    newPixelArray := i pixelArraySpecies new:width.

    0 to:h do:[:y |
        self rowAt:y into:pixelArray.
        0 to:w do:[:x |
            greyValue := pixelArray at:(x+1).
            newPixelArray at:(x+1) put:(colorValues at:greyValue + 1).
        ].
        i rowAt:y putAll:newPixelArray.
    ].

    form := Form width:width height:height depth:usedDeviceDepth onDevice:aDevice.
    form isNil ifTrue:[^ nil].
    form initGC.

    form
        copyBitsFrom:imageBits
        bitsPerPixel:usedDeviceBitsPerPixel
        depth:usedDeviceDepth
        padding:8
        width:width height:height
        x:0 y:0
        toX:0 y:0.

    ^ form

    "Created: / 20-10-1995 / 22:05:10 / cg"
    "Modified: / 05-02-2011 / 10:40:13 / cg"
    "Modified (format): / 31-01-2017 / 14:42:05 / stefan"
! !

!Image methodsFor:'converting palette images'!

paletteImageAsFormOn:aDevice
    "return a device-form for the palette-image receiver"

    |type ddepth|

    ddepth := aDevice depth.

    aDevice hasGrayscales ifFalse:[
        ^ self asMonochromeFormOn:aDevice
    ].

    type := aDevice visualType.
    (type == #StaticGray) ifTrue:[
        ddepth == 8 ifTrue:[
            ^ self paletteImageAsGray8FormOn:aDevice
        ].
        ^ self asGrayFormOn:aDevice
    ].

    (type == #TrueColor) ifTrue:[
        DitherAlgorithm == #floydSteinberg ifTrue:[
            ddepth == 8 ifTrue:[
                self depth == 8 ifTrue:[
                    "/ use fixColor dither algorithm
                    ^ self asDitheredTrueColor8FormOn:aDevice
                ]
            ]
        ].

        ^ self paletteImageAsTrueColorFormOn:aDevice
    ].

    "/ the PseudoColor conversion also works for
    "/ StaticColor, GrayScale & DirectColor; although possibly with suboptimal results

    ^ self paletteImageAsPseudoFormOn:aDevice

    "Modified: / 14-06-1996 / 19:31:01 / cg"
    "Modified: / 30-01-2017 / 20:55:32 / stefan"
!

paletteImageAsPseudoFormOn:aDevice
    "return a pseudo-deviceForm from the palette image."

    |tempImage d temp8|

    d := self depth.
    (#[1 2 4 8] includes:d) ifTrue:[
        "
         fallback code for some depth's:
         create a temporary Depth8Image and use its conversion method
        "
        temp8 := ByteArray uninitializedNew:(width * height).

        self bits
            expandPixels:d
            width:width height:height
            into:temp8
            mapping:nil.

        tempImage := Image width:width height:height depth:8 fromArray:temp8.
        tempImage colorMap:colorMap.
        ^ tempImage paletteImageAsPseudoFormOn:aDevice
    ].
    ^ self subclassResponsibility

    "Modified: / 30-01-2017 / 19:37:57 / stefan"
!

paletteImageAsTrueColorFormOn:aDevice
    "return a true-color device-form for the palette-image receiver."

    |nColors "{ Class: SmallInteger }"
     h       "{ Class: SmallInteger }"
     pixel   "{ Class: SmallInteger }"
     colorValues
     scaleRed scaleGreen scaleBlue redShift greenShift blueShift
     form imageBits bestFormat usedDeviceDepth usedDeviceBitsPerPixel
     i pixelArray newPixelArray
     clr r g b rv gv bv v "{ Class: SmallInteger }" |

    "/ this is a slow fallback method; this ought to be
    "/ redefined in DepthxImage for more performance.

    bestFormat := self bestSupportedImageFormatFor:aDevice.
    usedDeviceDepth := bestFormat at:#depth.
    usedDeviceDepth == 1 ifTrue:[
        ^ self asMonochromeFormOn:aDevice.
    ].
    usedDeviceBitsPerPixel := bestFormat at:#bitsPerPixel.


    scaleRed := ((1 bitShift:aDevice bitsRed) - 1) / 255.
    scaleGreen := ((1 bitShift:aDevice bitsGreen) - 1) / 255.
    scaleBlue := ((1 bitShift:aDevice bitsBlue) - 1) / 255.
    redShift := aDevice shiftRed.
    greenShift := aDevice shiftGreen.
    blueShift := aDevice shiftBlue.

    nColors := colorMap size.
    nColors <= 4096 ifTrue:[
        "/ precompute scales to map from 0..100 into devices range
        "/ (this may be different for the individual components)
        colorValues := Array uninitializedNew:nColors.

        1 to:nColors do:[:index |
            r := colorMap redByteAt:index.
            g := colorMap greenByteAt:index.
            b := colorMap blueByteAt:index.
"/        clr := colorMap at:index.
            true "clr notNil" ifTrue:[
"/            r := clr red.
"/            g := clr green.
"/            b := clr blue.
                rv := (r * scaleRed) rounded.
                gv := (g * scaleGreen) rounded.
                bv := (b * scaleBlue) rounded.

                v := rv bitShift:redShift.
                v := v bitOr:(gv bitShift:greenShift).
                v := v bitOr:(bv bitShift:blueShift).
                colorValues at:index put:v.
"/ clr print. ' ' print.
"/ rv print. ' ' print. gv print. ' ' print. bv print. ' ' print.
"/ ' -> ' print. v printNL.

            ]
        ].
    ].

    "/ the temporary helper image is only needed to allow
    "/ the rowAt:putAll: calls below.

    i := (Image implementorForDepth:usedDeviceBitsPerPixel) new.
    i width:width height:height.
    i createPixelStore.
    imageBits := i bits.

    "/ now, walk over the image and replace
    "/ colorMap indices by color values in the bits array

    h := height - 1.
    pixelArray := self pixelArraySpecies new:width.
    newPixelArray := i pixelArraySpecies new:width.

    colorValues notNil ifTrue:[
        0 to:h do:[:y |
            self rowAt:y into:pixelArray.
            1 to:width do:[:x |
                pixel := pixelArray at:x.
                newPixelArray at:x put:(colorValues at:pixel + 1 ifAbsent:[0]).
            ].
            i rowAt:y putAll:newPixelArray.
        ].
    ] ifFalse:[
        0 to:h do:[:y |
            self rowAt:y into:pixelArray.
            1 to:width do:[:x |

                pixel := pixelArray at:x.
                clr := self colorFromValue:pixel.
                r := clr redByte.
                g := clr greenByte.
                b := clr blueByte.

                rv := (r * scaleRed) rounded.
                gv := (g * scaleGreen) rounded.
                bv := (b * scaleBlue) rounded.

                v := rv bitShift:redShift.
                v := v bitOr:(gv bitShift:greenShift).
                v := v bitOr:(bv bitShift:blueShift).

                newPixelArray at:x put:v.
            ].
            i rowAt:y putAll:newPixelArray.
        ].
    ].

    form := Form width:width height:height depth:usedDeviceDepth onDevice:aDevice.
    form isNil ifTrue:[^ nil].
    form initGC.

    form
        copyBitsFrom:imageBits
        bitsPerPixel:usedDeviceBitsPerPixel
        depth:usedDeviceDepth
        padding:8
        width:width height:height
        x:0 y:0
        toX:0 y:0.

    ^ form

    "Modified: / 24-07-1998 / 00:56:14 / cg"
    "Modified: / 31-01-2017 / 15:01:05 / stefan"
! !

!Image methodsFor:'converting rgb images'!

asDitheredTrueColor8FormOn:aDevice
    "convert an rgb image to a dithered depth8-form on aDevice.
     Return the device-form.
     This method is only valid for trueColor displays."

    |fixColors pixel
     dstIdx     "{ Class: SmallInteger }"
     shiftRed   "{ Class: SmallInteger }"
     shiftGreen "{ Class: SmallInteger }"
     shiftBlue  "{ Class: SmallInteger }"
     nRed    "{ Class: SmallInteger }"
     nGreen  "{ Class: SmallInteger }"
     nBlue   "{ Class: SmallInteger }"|

    shiftRed := aDevice shiftRed.
    shiftGreen := aDevice shiftGreen.
    shiftBlue := aDevice shiftBlue.

    nRed := 1 bitShift:aDevice bitsRed.
    nGreen := 1 bitShift:aDevice bitsGreen.
    nBlue := 1 bitShift:aDevice bitsBlue.

    fixColors := Array new:(nRed * nGreen * nBlue).

    dstIdx := 1.
    0 to:nRed - 1 do:[:sR |
        0 to:nGreen - 1 do:[:sG |
            0 to:nBlue - 1 do:[:sB |
                pixel := (sR bitShift:shiftRed)
                         + (sG bitShift:shiftGreen)
                         + (sB bitShift:shiftBlue).
                fixColors at:dstIdx put:(Color colorId:pixel).
                dstIdx := dstIdx + 1
            ]
        ]
    ].

    ^ self
        asFloydSteinbergDitheredDepth8FormOn:aDevice
        colors:fixColors
        nRed:nRed nGreen:nGreen nBlue:nBlue

    "Created: / 14-06-1996 / 17:23:52 / cg"
    "Modified: / 23-06-1997 / 15:22:36 / cg"
    "Modified (format): / 30-01-2017 / 19:06:08 / stefan"
!

compressColorMap
    "calculates a new color map for the image, using only used colors"

    |depth newColorMap usedColors oldToNew oldBits newBits tmpBits sortBlockForColors|

    depth := self depth.
    usedColors := self realUsedColors.
    sortBlockForColors := [:a :b |
            a redByte == b redByte ifTrue:[
                a greenByte == b greenByte ifTrue:[
                    a blueByte < b blueByte
                ] ifFalse:[
                    a greenByte < b greenByte
                ]
            ] ifFalse:[
                a redByte < b redByte
            ]
      ].

    "/ translation table
    oldToNew := ByteArray new:(1 bitShift:depth).
    newColorMap := usedColors asArray.
    newColorMap sort:sortBlockForColors.
    self colorMap notNil ifTrue:[
        self colorMap asArray keysAndValuesDo:[:oldIdx :clr |
            |newPixel|

            (usedColors includes:clr) ifTrue:[
                newPixel := newColorMap indexOf:clr.
                oldToNew at:oldIdx put:newPixel-1.
            ]
        ].
    ].

    oldBits := self bits.
    newBits := ByteArray new:(oldBits size).
    depth ~~ 8 ifTrue:[
        "/ expand/compress can only handle 8bits
        tmpBits := ByteArray uninitializedNew:(self width*self height).
        oldBits
            expandPixels:depth
            width:self width
            height:self height
            into:tmpBits
            mapping:oldToNew.
        tmpBits
            compressPixels:depth
            width:self width
            height:self height
            into:newBits
            mapping:nil
    ] ifFalse:[
        oldBits
            expandPixels:depth
            width:self width
            height:self height
            into:newBits
            mapping:oldToNew.
    ].

    self bits:newBits.
    self colorMap:newColorMap.

    "Created: / 17-07-2012 / 12:13:18 / anwild"
!

copyPixels32AlphaLowTo24From:anImage
    "tuned helper to copy pixels from a 32bit argb (alpha in low byte)
     to me as a 24bit non-alpha rgb image"

    |imageBits|

    imageBits := anImage bits.
%{
    OBJ _myBits = __INST(bytes);
    OBJ w = __INST(width);
    OBJ h = __INST(height);

    if (__isByteArrayLike(_myBits)
     && __isByteArrayLike(imageBits)
     && __bothSmallInteger(w, h)) {
        int _idx;
        int _w = __intVal(w);
        int _h = __intVal(h);
        int _mySize = __byteArraySize(_myBits);
        int _imgSize = __byteArraySize(imageBits);
        char *_myBitsPtr = __ByteArrayInstPtr(_myBits)->ba_element;
        char *_imgBitsPtr = __ByteArrayInstPtr(imageBits)->ba_element;
        char *_myBitsEndPtr = _myBitsPtr + (_w * _h * 3);
        char *_imgBitsEndPtr = _imgBitsPtr + (_w * _h * 4);

        if ((_w * _h * 3) > _mySize) goto error;
        if ((_w * _h * 4) > _imgSize) goto error;

        while (_myBitsPtr < _myBitsEndPtr) {
            // fetch r,g,b skip a
            unsigned char _r = _imgBitsPtr[0];
            unsigned char _g = _imgBitsPtr[1];
            unsigned char _b = _imgBitsPtr[2];
            _myBitsPtr[0] = _r;
            _myBitsPtr[1] = _g;
            _myBitsPtr[2] = _b;
            _myBitsPtr += 3;
            _imgBitsPtr += 4;
        }
        RETURN( self );
    }
error: ;
    console_printf("Image: oops - bits-size in copyPixels32\n");
%}.

    anImage valuesFromX:0 y:0 toX:(self width-1) y:(self height-1) do:[:x :y :pixel |
        |a r g b rgbPixel|

        "/ bgra-pixel
        "/ a := pixel bitAnd:16rFF.
        r := (pixel bitShift:-8) bitAnd:16rFF.
        g := (pixel bitShift:-16) bitAnd:16rFF.
        b := (pixel bitShift:-24) bitAnd:16rFF.
        rgbPixel := r + (g bitShift:8) + (b bitShift:16).
        self pixelAtX:x y:y put:rgbPixel
    ].
!

rgbImageAsFormOn:aDevice
    "convert am rgb image to a device-form on aDevice.
     Return the device-form."

    |visual|

    visual := aDevice visualType.
    (visual == #StaticGray) ifTrue:[
        ^ self asGrayFormOn:aDevice
    ].
    (visual == #TrueColor) ifTrue:[
        ^ self rgbImageAsTrueColorFormOn:aDevice
    ].

    "/ PseudoColor conversion also works for StaticColor, GrayScale
    "/ and DirectColor displays; although possibly with suboptimal results

    ^ self rgbImageAsPseudoFormOn:aDevice

    "Modified: 14.6.1996 / 19:30:06 / cg"
!

rgbImageAsPseudoFormOn:aDevice
    "return a pseudocolor form from the rgb-picture"

    |n     "{ Class: SmallInteger }"
     depth "{ Class: SmallInteger }"
     palette f|

    (depth := self depth) <= 8 ifTrue:[
        "/ simulate it via a temporary palette image

        palette := Array new:(1 bitShift:depth).

        n := (1 bitShift:depth)-1.
        0 to:n do:[:pixelValue |
            palette at:(pixelValue+1) put:(self colorFromValue:pixelValue)
        ].

        self setColorMap:palette.
        photometric := #palette.
        f := self paletteImageAsPseudoFormOn:aDevice.
        self setColorMap:nil.
        photometric := #rgb.
        ^ f
    ].

    ^ self subclassResponsibility

    "Modified: 8.6.1996 / 10:58:25 / cg"
!

rgbImageAsTrueColorFormOn:aDevice
    "return a truecolor form from the rgb-picture."

    |bestFormat usedDeviceDepth usedDeviceBitsPerPixel
     form|

    bestFormat := self bestSupportedImageFormatFor:aDevice.
    usedDeviceDepth := bestFormat at:#depth.
    usedDeviceBitsPerPixel := bestFormat at:#bitsPerPixel.

    "/ kludge for some 15bit XFree servers (should return 16 here - does not)
    usedDeviceBitsPerPixel == 15 ifTrue:[
        usedDeviceBitsPerPixel := 16
    ].

    "/
    "/ only the trivial case, where the depths match
    "/ is handled here; conversions are supposed to
    "/ be done in concrete subclasses (see D24Image)
    "/
    self bitsPerPixel == usedDeviceBitsPerPixel ifFalse:[
        "/ kludge - convert to a deep image first, then to a form.
        ^ ((Image implementorForDepth:usedDeviceBitsPerPixel) fromImage:self) asFormOn:aDevice
"/        'Image [warning]: unimplemented trueColor depth in rgbImageAsTrueColorFormOn: ' errorPrint. self bitsPerPixel errorPrintCR.
"/        ^ self asMonochromeFormOn:aDevice
    ].

    form := Form width:width height:height depth:usedDeviceDepth onDevice:aDevice.
    form isNil ifTrue:[
        'Image [warning]: display bitmap creation failed' errorPrintCR.
        ^ nil
    ].
    form initGC.

    form
        copyBitsFrom:self bits
        bitsPerPixel:usedDeviceBitsPerPixel
        depth:usedDeviceDepth
        padding:8
        width:width height:height
        x:0 y:0
        toX:0 y:0.

    ^ form

    "Modified: / 27-05-2007 / 13:44:26 / cg"
! !

!Image methodsFor:'copying'!

postCopy
    "redefined to also copy the pixels and the colorMap
     and clear out any device handles in the copy."

    bytes := bytes copy.
    colorMap isColormap ifTrue:[
        colorMap := colorMap copy.
    ] ifFalse:[
        colorMap := MappedPalette withColors:colorMap.
    ].
    device := deviceForm := monoDeviceForm := fullColorDeviceForm := nil.
    mask := mask copy.
    maskedPixelsAre0 := false.

    "Modified: / 22-08-1998 / 11:27:09 / cg"
    "Modified: / 30-01-2017 / 19:16:02 / stefan"
!

skipInstvarIndexInDeepCopy:index
    "a helper for deepCopy; only indices for which this method returns
     false are copied in a deep copy."

    "
        self allInstanceVariableNames indexOf:#device
        self allInstanceVariableNames indexOf:#deviceForm
        self allInstanceVariableNames indexOf:#monoDeviceForm
        self allInstanceVariableNames indexOf:#fullColorDeviceForm
    "

    index == 13 ifTrue:[
        ^ true "/ skip device
    ].
    index == 14 ifTrue:[
        ^ true "/ skip deviceForm
    ].
    index == 15 ifTrue:[
        ^ true "/ skip monoDeviceForm
    ].
    index == 16 ifTrue:[
        ^ true "/ skip fullColorDeviceForm
    ].
    ^ false

    "Modified (comment): / 31-01-2017 / 15:41:40 / stefan"
! !

!Image methodsFor:'displaying'!

asImage
    "ST-80 compatibility
    "
    ^ self
!

displayFilledOn:aGC
    "display the receiver as an opaque image.
     This allows Images to be wrapped by a FillingWrapper"

    aGC displayOpaqueForm:self x:0 y:0.

    "Created: 29.5.1996 / 10:34:18 / cg"
    "Modified: 29.5.1996 / 10:52:36 / cg"
!

displayOn:aGC x:x y:y
    "draw the receiver in the graphicsContext, aGC.
     Smalltalk-80 compatibility"

    aGC displayForm:self x:x y:y.

    "Modified: 23.4.1996 / 11:12:31 / cg"
    "Created: 12.5.1996 / 20:14:31 / cg"
!

displayOn:aGC x:x y:y opaque:opaque
    "draw the receiver in the graphicsContext, aGC.
     Smalltalk-80 compatibility"

    opaque ifTrue:[
        self displayOpaqueOn:aGC x:x y:y .
    ] ifFalse:[
        self displayOn:aGC x:x y:y .
    ].
!

displayOpaqueOn:aGC at:aPoint
    "draw the receiver in the graphicsContext, aGC.
     Smalltalk-80 compatibility"

    self displayOpaqueOn:aGC x:aPoint x y:aPoint y.

    "Modified: 12.5.1996 / 20:16:38 / cg"
!

displayOpaqueOn:aGC x:x y:y
    "draw the receiver in the graphicsContext, aGC.
     Smalltalk-80 compatibility"

    aGC displayOpaqueForm:self x:x y:y.

    "Modified: 23.4.1996 / 11:12:31 / cg"
    "Created: 22.10.1996 / 16:35:49 / cg"
!

displayStrokedOn:aGC
    "display the receiver as an non opaque image.
     This allows Images to be wrapped by a StrokingWrapper"

    aGC displayForm:self x:0 y:0.

    "Created: 29.5.1996 / 10:34:18 / cg"
    "Modified: 29.5.1996 / 10:52:30 / cg"
! !

!Image methodsFor:'dither helpers'!

burkesDitheredMonochromeBits
    "return the bitmap for a dithered monochrome bitmap from the image.
     Works for any source depths / photometric.
     TODO: move to separate dither helper class"

    |dstIndex        "{Class: SmallInteger }"
     nextDst         "{Class: SmallInteger }"
     bytesPerMonoRow "{Class: SmallInteger }"
     monoBits greyValues
     errorArray
     errorArray1
     e t
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"
     bitCnt          "{Class: SmallInteger }"
     byte            "{Class: SmallInteger }"
     grey|

    self depth > 12 ifTrue:[
        ^ self floydSteinbergDitheredMonochromeBits
    ].

    w := width.
    h := height.

    bytesPerMonoRow := (w + 7) // 8.
    monoBits := ByteArray uninitializedNew:(bytesPerMonoRow * h).

    errorArray := Array new:(w+4).
    errorArray1 := Array new:(w+4) withAll:0.

    dstIndex := 1.

    "/ fetch scaled brightness values outside of loop into a table;
    "/ use table-value in loop

    greyValues := self greyMapForRange:(255*1024).

    0 to:(h-1) do:[:y |
        nextDst := dstIndex + bytesPerMonoRow.
        byte := 0.
        bitCnt := 8.

        t := errorArray.
        errorArray := errorArray1.
        errorArray1 := t.

        errorArray1 atAllPut:0.

        self valuesAtY:y from:0 to:(w-1) do:[:x :pixel |
            |eP "{Class: SmallInteger }"
             eD
             eI "{Class: SmallInteger }"
             xE "{Class: SmallInteger }"
             xN "{Class: SmallInteger }" |

            "/ get the colors grey value [0 .. 1]
            grey := greyValues at:(pixel + 1).

            "/ adjust error
            xE := x + 2 + 1.
            grey := (grey + (errorArray at:xE)).

            byte := byte bitShift:1.
            grey > (127*1024) ifTrue:[
                byte := byte bitOr:1.      "/ white
                e := grey - (255*1024)
            ] ifFalse:[
                e := grey                  "/ black
            ].

            e ~= 0 ifTrue:[
                "/ distribute the error:
                "/                  XX  8  4
                "/             2  4  8  4  2

                eD := e.
                eI := e // 32.

                eP := eI * 8. eD := eD - eP.

                xN := xE + 1.
                errorArray at:xN put:(errorArray at:xN) + eP.

                eD := eD - eP.
                errorArray1 at:xE put:(errorArray1 at:xE) + eP.

                eP := eI * 4. eD := eD - eP.
                xN := xE + 2.
                errorArray at:xN put:(errorArray at:xN) + eP.

                eD := eD - eP.
                xN := xE - 1.
                errorArray1 at:xN put:(errorArray1 at:xN) + eP.

                eD := eD - eP.
                xN := xE + 1.
                errorArray1 at:xN put:(errorArray1 at:xN) + eP.

                eP := eI * 2. eD := eD - eP.
                xN := xE - 2.
                errorArray1 at:xN put:(errorArray1 at:xN) + eP.

                "/ eD := eD.
                xN := xE + 2.
                errorArray1 at:xN put:(errorArray1 at:xN) + eP.
            ].

            bitCnt := bitCnt - 1.
            bitCnt == 0 ifTrue:[
                monoBits at:dstIndex put:byte.
                dstIndex := dstIndex + 1.
                byte := 0.
                bitCnt := 8.
            ].

        ].
        bitCnt ~~ 8 ifTrue:[
            byte := byte bitShift:bitCnt.
            monoBits at:dstIndex put:byte.
        ].

        dstIndex := nextDst.
    ].

    ^ monoBits

    "Created: 10.6.1996 / 12:18:20 / cg"
    "Modified: 10.6.1996 / 13:16:33 / cg"
!

floydSteinbergDitheredDepth8BitsColors:colors
    "return a floyd-steinberg dithered bitmap from the receiver picture,
     which must be a depth-8 image.
     This method expects an array of colors to be used for dithering
     (which need not be a colorCubes colors)."

    ^ self floydSteinbergDitheredDepth8BitsColors:colors map:nil

!

floydSteinbergDitheredDepth8BitsColors:colors map:aMapOrNil
    "return a floyd-steinberg dithered bitmap from the receiver picture,
     which must be a depth-24 image.
     This method expects an array of colors to be used for dithering
     (which need not be a colorCubes colors)."

    |pseudoBits
     ditherRGBBytes ditherColors
     w       "{Class: SmallInteger }"
     h       "{Class: SmallInteger }"
     index   "{Class: SmallInteger }"
     lookupPos "{Class: SmallInteger }"
     ditherIds failed lastColor qScramble
     clrLookup error clr|

    self depth ~~ 24 ifTrue:[^ nil].

    "/ collect valid ditherColors ...
    aMapOrNil isNil ifTrue:[
        ditherColors := colors select:[:clr | clr notNil].
    ] ifFalse:[
        ditherColors := colors
    ].

    "/ ... and sort by manhatten distance from black

    qScramble := #(
                "/  2rX00X00X00X00

                    2r000000000000    "/ 0
                    2r000000000100    "/ 1
                    2r000000100000    "/ 2
                    2r000000100100    "/ 3
                    2r000100000000    "/ 4
                    2r000100000100    "/ 5
                    2r000100100000    "/ 6
                    2r000100100100    "/ 7
                    2r100000000000    "/ 8
                    2r100000000100    "/ 9
                    2r100000100000    "/ a
                    2r100000100100    "/ b
                    2r100100000000    "/ c
                    2r100100000100    "/ d
                    2r100100100000    "/ e
                    2r100100100100    "/ f
                  ).

    ditherColors := ditherColors sort:[:a :b |
                                |cr "{Class: SmallInteger }"
                                 cg "{Class: SmallInteger }"
                                 cb "{Class: SmallInteger }"
                                 i1 "{Class: SmallInteger }"
                                 i2 "{Class: SmallInteger }"|

                                cr := a redByte.
                                cg := a greenByte.
                                cb := a blueByte.
                                i1 := qScramble at:((cr bitShift:-4) bitAnd:16r0F) + 1.
                                i1 := i1 + ((qScramble at:((cg bitShift:-4) bitAnd:16r0F) + 1) bitShift:-1).
                                i1 := i1 + ((qScramble at:((cb bitShift:-4) bitAnd:16r0F) + 1) bitShift:-2).

                                cr := b redByte.
                                cg := b greenByte.
                                cb := b blueByte.
                                i2 := qScramble at:((cr bitShift:-4) bitAnd:16r0F) + 1.
                                i2 := i2 + ((qScramble at:((cg bitShift:-4) bitAnd:16r0F) + 1) bitShift:-1).
                                i2 := i2 + ((qScramble at:((cb bitShift:-4) bitAnd:16r0F) + 1) bitShift:-2).

                                i1 < i2
                    ].
    aMapOrNil isNil ifTrue:[
        ditherIds := (ditherColors asArray collect:[:clr | clr colorId]) asByteArray.
    ] ifFalse:[
        ditherIds := aMapOrNil asByteArray
    ].

    "/ build an index table, for fast lookup from manhatten-r-g-b distance
    "/ to the position in the colorList

    clrLookup := ByteArray new:(4096).
    index := 0.
    ditherColors keysAndValuesDo:[:clrPosition :clr |
        |r g b i|

        r := clr redByte.
        g := clr greenByte.
        b := clr blueByte.
        i := qScramble at:((r bitShift:-4) bitAnd:16r0F) + 1.
        i := i + ((qScramble at:((g bitShift:-4) bitAnd:16r0F) + 1) bitShift:-1).
        i := i + ((qScramble at:((b bitShift:-4) bitAnd:16r0F) + 1) bitShift:-2).
        lookupPos := i.

        index+1 to:lookupPos do:[:idx|
            clrLookup at:idx put:(clrPosition-1-1).
        ].
        index := lookupPos.
    ].
    clrLookup from:index+1 to:4096 put:(ditherColors size - 1).

"/    [index <= (4095)] whileTrue:[
"/        clrLookup at:(index+1) put:(ditherColors size - 1).
"/        index := index + 1.
"/    ].

    "/ collect ditherColor components

    lastColor := ditherColors size.
    ditherIds := ByteArray uninitializedNew:lastColor.
    ditherRGBBytes := ByteArray uninitializedNew:(lastColor * 3).
    index := 1.
    1 to:lastColor do:[:pix |
        clr := ditherColors at:pix.
        ditherRGBBytes at:index put:(clr redByte).
        ditherRGBBytes at:index+1 put:(clr greenByte).
        ditherRGBBytes at:index+2 put:(clr blueByte).
        aMapOrNil isNil ifTrue:[
            ditherIds at:pix put:clr colorId.
        ] ifFalse:[
            ditherIds at:pix put:(aMapOrNil at:pix).
        ].
        index := index + 3.
    ].

    pseudoBits := ByteArray uninitializedNew:(width * height).

    w := width + 2.
    error := ByteArray uninitializedNew:w*(3*2).

    w := width.
    h := height.

    failed := true.

%{
    int __x, __y;
    int __eR, __eG, __eB;
    unsigned char *srcP, *dstP;
    unsigned char *idP;
    unsigned char *dp;
    unsigned char *__clrLookup;
    short *errP, *eP;
    int __fR, __fG, __fB;
    int iR, iG, iB;
    int idx;
    int __w = __intVal(w);
    int __h = __intVal(h);
    int __nColors = __intVal(lastColor);
    int __wR = -1, __wG, __wB;
    static int __qScramble[16] = {
                    0x000 /* 2r000000000000    0 */,
                    0x004 /* 2r000000000100    1 */,
                    0x020 /* 2r000000100000    2 */,
                    0x024 /* 2r000000100100    3 */,
                    0x100 /* 2r000100000000    4 */,
                    0x104 /* 2r000100000100    5 */,
                    0x120 /* 2r000100100000    6 */,
                    0x124 /* 2r000100100100    7 */,
                    0x800 /* 2r100000000000    8 */,
                    0x804 /* 2r100000000100    9 */,
                    0x820 /* 2r100000100000    a */,
                    0x824 /* 2r100000100100    b */,
                    0x900 /* 2r100100000000    c */,
                    0x904 /* 2r100100000100    d */,
                    0x920 /* 2r100100100000    e */,
                    0x924 /* 2r100100100100    f */,
                  };

    if (__isByteArrayLike(__INST(bytes))
     && __isByteArray(pseudoBits)
     && __isByteArray(ditherRGBBytes)
     && __isByteArray(ditherIds)
     && __isByteArray(clrLookup)
     && __isByteArray(error)) {
        failed = false;

        srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
        dstP = __ByteArrayInstPtr(pseudoBits)->ba_element;
        idP = __ByteArrayInstPtr(ditherIds)->ba_element;
        __clrLookup = __ByteArrayInstPtr(clrLookup)->ba_element;
        errP = (short *) __ByteArrayInstPtr(error)->ba_element;

        /*
         * clear error accumulator
         */
        eP = errP;
        bzero(eP, (__w+2) * 2 * 3);

        for (__y=__h; __y>0; __y--) {
            __eR = __eG = __eB = 0;

            eP = &(errP[3]);
            __eR = eP[0];
            __eG = eP[1];
            __eB = eP[2];

            for (__x=__w; __x>0; __x--) {
                int __want;
                int pix;
                int __wantR, __wantG, __wantB;
                int idx;
                int tR, tG, tB;
                int nR, nG, nB;
                int dR, dG, dB;
                int minDelta, bestIdx;
                int cnt;

                __wantR = *srcP++;
                __wantG = *srcP++;
                __wantB = *srcP++;

                /*
                 * wR, wG and wB is the wanted r/g/b value;
                 */
                __wantR = __wantR + __eR;
                __wantG = __wantG + __eG;
                __wantB = __wantB + __eB;

#define RED_SCALE 30
#define GREEN_SCALE 59
#define BLUE_SCALE 11
#define GOOD_DELTA 30

#define xRED_SCALE 1
#define xGREEN_SCALE 1
#define xBLUE_SCALE 1
#define xGOOD_DELTA 3

#define FAST_LOOKUP
/* #define ONE_SHOT */
#define NPROBE 8

#ifndef FAST_LOOKUP
                if ((__wantR == __wR)
                 && (__wantG == __wG)
                 && (__wantB == __wB)) {
                    /*
                     * same color again - reuse last bestMatch
                     */
                } else
#endif
                {
                    __wR = __wantR;
                    __wG = __wantG;
                    __wB = __wantB;

#ifdef FAST_LOOKUP
                    if(__wR > 255) __wR = 255;
                    else if (__wR < 0) __wR = 0;
                    if(__wG > 255) __wG = 255;
                    else if (__wG < 0) __wG = 0;
                    if(__wB > 255) __wB = 255;
                    else if (__wB < 0) __wB = 0;

                    {
                        int lookupIndex;
                        int idx, idx0;
                        int d, delta;
                        unsigned char *dp0;

                        dp = __ByteArrayInstPtr(ditherRGBBytes)->ba_element;
                        lookupIndex =    __qScramble[((__wR & 0xF0)>>4)];
                        lookupIndex |=   __qScramble[((__wG & 0xF0)>>4)] >> 1;
                        lookupIndex |=   __qScramble[((__wB & 0xF0)>>4)] >> 2;
                        idx = bestIdx =__clrLookup[lookupIndex];
                        dp += (idx+idx+idx);

                        /* try color at lookupIndex */

                        d = dp[0];
                        delta = (__wR - d) * RED_SCALE;
                        if (delta < 0) delta = -delta;

                        d = dp[1];
                        if (__wG > d)
                            delta += (__wG - d) * GREEN_SCALE;
                        else
                            delta += (d - __wG) * GREEN_SCALE;
                        d = dp[2];
                        if (__wB > d)
                            delta += (__wB - d) * BLUE_SCALE;
                        else
                            delta += (d - __wB) * BLUE_SCALE;

                        if (delta <= GOOD_DELTA) {
                            goto foundBest;
                        }
                        minDelta = delta;
# ifndef ONE_SHOT
                        idx0 = idx; dp0 = dp;
                        cnt = 0;
                        while ((++cnt <= NPROBE) && (idx > 0)) {
                            /* try previous color(s) */

                            idx--; dp -= 3;
                            d = dp[0];
                            delta = (__wR - d) * RED_SCALE;
                            if (delta < 0) delta = -delta;
                            d = dp[1];
                            if (__wG > d)
                                delta += (__wG - d) * GREEN_SCALE;
                            else
                                delta += (d - __wG) * GREEN_SCALE;
                            d = dp[2];
                            if (__wB > d)
                                delta += (__wB - d) * BLUE_SCALE;
                            else
                                delta += (d - __wB) * BLUE_SCALE;

                            if (delta < minDelta) {
                                bestIdx = idx;
                                if (delta <= GOOD_DELTA) {
                                    goto foundBest;
                                }
                                minDelta = delta;
                            }
                        }

                        idx = idx0; dp = dp0;
                        cnt = 0;
                        while ((++cnt <= NPROBE) && (++idx < __nColors)) {
                            /* try next color */

                            dp += 3;
                            d = dp[0];
                            delta = (__wR - d) * RED_SCALE;
                            if (delta < 0) delta = -delta;
                            d = dp[1];
                            if (__wG > d)
                                delta += (__wG - d) * GREEN_SCALE;
                            else
                                delta += (d - __wG) * GREEN_SCALE;
                            d = dp[2];
                            if (__wB > d)
                                delta += (__wB - d) * BLUE_SCALE;
                            else
                                delta += (d - __wB) * BLUE_SCALE;

                            if (delta < minDelta) {
                                bestIdx = idx;
                                if (delta <= GOOD_DELTA) {
                                    goto foundBest;
                                }
                                minDelta = delta;
                            }
                        }
# endif
                    }
        foundBest: ;
#else
/*
                    if(__wR > 255) __wR = 255;
                    else if (__wR < 0) __wR = 0;
                    if(__wG > 255) __wG = 255;
                    else if (__wG < 0) __wG = 0;
                    if(__wB > 255) __wB = 255;
                    else if (__wB < 0) __wB = 0;
*/

                    /* find the best matching color */

                    minDelta = 99999;
                    bestIdx = -1;
                    dp = __ByteArrayInstPtr(ditherRGBBytes)->ba_element;
                    for (idx = 0; idx<__nColors; idx++) {
                        int d, delta;

                        d = dp[0];
                        delta = (__wR - d) * RED_SCALE;
                        if (delta < 0) delta = -delta;
                        if (delta < minDelta) {
                            d = dp[1];
                            if (__wG > d)
                                delta += (__wG - d) * GREEN_SCALE;
                            else
                                delta += (d - __wG) * GREEN_SCALE;
                            if (delta < minDelta) {
                                d = dp[2];
                                if (__wB > d)
                                    delta += (__wB - d) * BLUE_SCALE;
                                else
                                    delta += (d - __wB) * BLUE_SCALE;

                                if (delta < minDelta) {
                                    bestIdx = idx;
                                    if (delta <= GOOD_DELTA) {
                                        break;
                                    }
                                    minDelta = delta;
                                }
                            }
                        }
                        dp += 3;
                    }
#endif
                }
                dp = __ByteArrayInstPtr(ditherRGBBytes)->ba_element;
                dp += bestIdx * 3;
                dR = dp[0];
                dG = dp[1];
                dB = dp[2];

/*
console_fprintf(stderr, "want: %d/%d/%d (%d/%d/%d) got: %d/%d/%d\n",
                __wantR, __wantG, __wantB,
                __wR, __wG, __wB,
                dR, dG, dB);
*/
                /*
                 * store the corresponding dither colors colorId
                 */
                *dstP++ = idP[bestIdx];

                /*
                 * the new error & distribute the error
                 */
                __eR = __wantR - dR;
                if (__eR) {
                    tR = __eR >> 4;  /* 16th of error */
                    nR = eP[3] + (tR * 7);/* from accu: error for (x+1 / y) */
                    eP[0] = tR*5;         /* 5/16th for (x / y+1) */
                    eP[-3] = tR*3;        /* 3/16th for (x-1 / y+1) */
                    eP[3] = __eR - (tR*15);  /* 1/16th for (x+1 / y+1) */
                    __eR = nR;
                } else {
                    __eR = eP[3];
                    eP[0] = eP[-3] = eP[3] = 0;
                }

                __eG = __wantG - dG;
                if (__eG) {
                    tG = __eG >> 4;
                    nG = eP[4] + (tG * 7);/* plus 7/16'th of this error */
                    eP[1] = tG*5;
                    eP[-2] = tG*3;
                    eP[4] = __eG - (tG*15);
                    __eG = nG;
                } else {
                    __eG = eP[4];
                    eP[1] = eP[-2] = eP[4] = 0;
                }

                __eB = __wantB - dB;
                if (__eB) {
                    tB = __eB >> 4;
                    nB = eP[5] + (tB * 7);
                    eP[2] = tB*5;
                    eP[-1] = tB*3;
                    eP[5] = __eB - (tB*15);
                    __eB = nB;
                } else {
                    __eB = eP[5];
                    eP[2] = eP[-1] = eP[5] = 0;
                }

                eP += 3;
            }
        }
    }
%}.
    failed ifTrue:[
        self primitiveFailed.
        ^ nil
    ].

    ^ pseudoBits

    "Modified: / 30-01-2017 / 19:58:45 / stefan"
!

floydSteinbergDitheredDepth8BitsColors:fixColors nRed:nRed nGreen:nGreen nBlue:nBlue
    "return a floyd-steinberg dithered bitmap from the receiver picture,
     which must be a depth-8 image.
     This is a special-cased dither method for 8-bit palette images being displayed on
     an 8-bit pseudoColor display, AND fixColor dithering is used.
     Use the colors in the fixColors array, which must be fixR x fixG x fixB
     colors assigned to aDevice, such as the preallocated colors of the
     Color class.
     By passing the ditherColors as extra array, this method can
     also be used to dither an 8bit image into a smaller number of colors,
     for example to create dithered Depth4Images from Depth8Images."

    |pseudoBits
     rgbBytes
     w       "{Class: SmallInteger }"
     h       "{Class: SmallInteger }"
     index   "{Class: SmallInteger }"
     fixR    "{Class: SmallInteger }"
     fixG    "{Class: SmallInteger }"
     fixB    "{Class: SmallInteger }"
     fixGfixB
     fixIds failed map lastColor
     rgbIDX  "{Class: SmallInteger }"
     idxAndErrRBytes idxAndErrGBytes idxAndErrBBytes
     error clr|

    self depth ~~ 8 ifTrue:[^ nil].

    fixR := nRed.
    fixR == 0 ifTrue:[ ^ nil].
    fixG := nGreen.
    fixG == 0 ifTrue:[ ^ nil].
    fixB := nBlue.
    fixB == 0 ifTrue:[ ^ nil].

    "/ simple check
    (fixR * fixG * fixB) ~~ fixColors size ifTrue:[
        self error:'invalid color array passed'.
        ^ nil
    ].
    fixIds := (fixColors asArray collect:[:clr | clr colorId]) asByteArray.

    "/
    "/ collect color components as integer values (for integer arithmetic)
    "/
    rgbBytes := ByteArray uninitializedNew:256 * 3.

    index := 1.

    photometric == #palette ifTrue:[
        lastColor := colorMap size - 1
    ] ifFalse:[
        lastColor := 255.
    ].
    0 to:lastColor do:[:pix |
        clr := self colorFromValue:pix.
        rgbBytes at:index put:(clr redByte).
        rgbBytes at:index+1 put:(clr greenByte).
        rgbBytes at:index+2 put:(clr blueByte).

        index := index + 3.
    ].

    pseudoBits := ByteArray uninitializedNew:(width * height).

    w := width + 2.
    error := ByteArray new:w*(3*2).

    w := width.
    h := height.

    idxAndErrRBytes := ByteArray uninitializedNew:256*2.
    idxAndErrGBytes := ByteArray uninitializedNew:256*2.
    idxAndErrBBytes := ByteArray uninitializedNew:256*2.

    fixGfixB := fixG * fixB.
    index := 1.
    0 to:255 do:[:i |
        rgbIDX := (i * (fixR-1) + 128) // 255. "red index rounded"
        idxAndErrRBytes at:index put:(rgbIDX * fixGfixB).
        idxAndErrRBytes at:index+1 put:i - (rgbIDX * 255 // (fixR-1)) + 128.

        rgbIDX := (i * (fixG-1) + 128) // 255. "green index rounded"
        idxAndErrGBytes at:index put:(rgbIDX * fixB).
        idxAndErrGBytes at:index+1 put:i - (rgbIDX * 255 // (fixG-1)) + 128.

        rgbIDX := (i * (fixB-1) + 128) // 255. "blue index rounded"
        idxAndErrBBytes at:index put:(rgbIDX ).
        idxAndErrBBytes at:index+1 put:i - (rgbIDX * 255 // (fixB-1)) + 128.
        index := index + 2.
    ].

    failed := true.

%{
    int __x, __y;
    int __eR, __eG, __eB;
    unsigned char *srcP, *dstP;
    unsigned char *rgbP;
    unsigned char *idP;
    unsigned char *__idxAndErrRBytes, *__idxAndErrGBytes, *__idxAndErrBBytes;
    short *errP, *eP;
    int idx;
    int __w = __intVal(w);

    if (__isByteArrayLike(__INST(bytes))
     && __isByteArray(pseudoBits)
     && __isByteArray(rgbBytes)
     && __isByteArray(fixIds)
     && __isByteArray(error)
     && __bothSmallInteger(fixR, fixG)
     && __isSmallInteger(fixB)) {
        failed = false;

        srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
        dstP = __ByteArrayInstPtr(pseudoBits)->ba_element;
        rgbP = __ByteArrayInstPtr(rgbBytes)->ba_element;
        idP = __ByteArrayInstPtr(fixIds)->ba_element;
        __idxAndErrRBytes = __ByteArrayInstPtr(idxAndErrRBytes)->ba_element;
        __idxAndErrGBytes = __ByteArrayInstPtr(idxAndErrGBytes)->ba_element;
        __idxAndErrBBytes = __ByteArrayInstPtr(idxAndErrBBytes)->ba_element;
        errP = (short *) __ByteArrayInstPtr(error)->ba_element;

        eP = errP;

        for (__y=__intVal(h); __y>0; __y--) {
            __eR = __eG = __eB = 0;

            eP = &(errP[3]);
            __eR = eP[0];
            __eG = eP[1];
            __eB = eP[2];

            for (__x=__w; __x>0; __x--) {
                int __want;
                int pix;
                int idx;
                int tR, tG, tB;
                int nR, nG, nB;
                int iRGB;

                pix = *srcP++;

                /*
                 * wR, wG and wB is the wanted r/g/b value;
                 */
                pix = pix+pix+pix;  /* pix * 3 */

                /*
                 * compute indexR/G/B and the new error:
                 */
                __want = rgbP[pix]   + __eR;
                if (__want > 255) __want = 255;
                else if (__want < 0) __want = 0;
                __want += __want;
                idx = __idxAndErrRBytes[__want];
                __eR = __idxAndErrRBytes[__want+1];
                __eR -= 128;

                __want = rgbP[pix+1] + __eG;
                if (__want > 255) __want = 255;
                else if (__want < 0) __want = 0;
                __want += __want;
                idx += __idxAndErrGBytes[__want];
                __eG = __idxAndErrGBytes[__want+1];
                __eG -= 128;

                __want = rgbP[pix+2] + __eB;
                if (__want > 255) __want = 255;
                else if (__want < 0) __want = 0;
                __want += __want;
                idx += __idxAndErrBBytes[__want];
                __eB = __idxAndErrBBytes[__want+1];
                __eB -= 128;

                /*
                 * store the corresponding dither colors colorId
                 */
                *dstP++ = idP[idx];

                /*
                 * distribute the error
                 */
                if (__eR) {
                    tR = __eR >> 4;  /* 16th of error */
                    nR = eP[3] + (tR * 7);/* from accu: error for (x+1 / y) */
                    eP[0] = tR*5;         /* 5/16th for (x / y+1) */
                    eP[-3] = tR*3;        /* 3/16th for (x-1 / y+1) */
                    eP[3] = __eR - (tR*15);  /* 1/16th for (x+1 / y+1) */
                    __eR = nR;
                } else {
                    __eR = eP[3];
                    eP[0] = eP[-3] = eP[3] = 0;
                }

                if (__eG) {
                    tG = __eG >> 4;  /* 16th of error */
                    nG = eP[4] + (tG * 7);/* plus 7/16'th of this error */
                    eP[1] = tG*5;
                    eP[-2] = tG*3;
                    eP[4] = __eG - (tG*15);
                    __eG = nG;
                } else {
                    __eG = eP[4];
                    eP[1] = eP[-2] = eP[4] = 0;
                }

                if (__eB) {
                    tB = __eB >> 4;  /* 16th of error */
                    nB = eP[5] + (tB * 7);
                    eP[2] = tB*5;
                    eP[-1] = tB*3;
                    eP[5] = __eB - (tB*15);
                    __eB = nB;
                } else {
                    __eB = eP[5];
                    eP[2] = eP[-1] = eP[5] = 0;
                }

                eP += 3;
            }
        }
    }
%}.
    failed ifTrue:[
        self primitiveFailed.
        ^ nil
    ].

    ^ pseudoBits
!

floydSteinbergDitheredGrayBitsDepth:depth
    "return the bits for dithering a gray image from the image.
     Works for any source depths / photometric,
     but possibly slow since each pixel is processed individually.
     Redefined by some subclasses for more performance (D8Image/D24Image)"

    |dstIndex        "{Class: SmallInteger }"
     nextDst         "{Class: SmallInteger }"
     bytesPerOutRow  "{Class: SmallInteger }"
     outBits greyValues greyErrors greyPixels greyLevels
     errorArray
     nextErrorArray
     t
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"
     bitCnt          "{Class: SmallInteger }"
     byte            "{Class: SmallInteger }"
     grey
     eR eRB eB eLB |

    depth > 8 ifTrue:[
        self error:'unimplemented conversion'.
        ^ nil
    ].

    w := width.
    h := height.

    bytesPerOutRow := ((w * depth) + 7) // 8.
    outBits := ByteArray uninitializedNew:(bytesPerOutRow * h).

    greyLevels := (1 bitShift:depth) - 1.

    errorArray := Array new:w+2.
    nextErrorArray := Array new:w+2.

    nextErrorArray atAllPut:0.

    dstIndex := 1.
    bitCnt := 8.

    self depth <= 12 ifTrue:[
        "/ fetch scaled brightness values outside of loop into a table;
        "/ use table-value in loop

        greyValues := self greyMapForRange:(greyLevels).

        greyPixels := greyValues collect:[:v | v isNil ifTrue:[
                                                   0
                                               ] ifFalse:[
                                                   v truncated]].

        greyPixels := ByteArray withAll:greyPixels.

        greyErrors := greyValues collect:[:v | v isNil ifTrue:[
                                                   0
                                               ] ifFalse:[
                                                   ((v - v truncated) * 1024) truncated
                                               ]].

        0 to:(h-1) do:[:y |
            nextDst := dstIndex + bytesPerOutRow.
            byte := 0.

            t := errorArray.
            errorArray := nextErrorArray.
            nextErrorArray := t.

            nextErrorArray atAllPut:0.

            self valuesAtY:y from:0 to:(w-1) do:[:x :value |
                |e     "{ Class: SmallInteger }"
                 pixel "{ Class: SmallInteger }"
                 error "{ Class: SmallInteger }"
                 e16   "{ Class: SmallInteger }"
                 xE    "{ Class: SmallInteger }"
                 xN    "{ Class: SmallInteger }" |

                pixel := greyPixels at:(value + 1).

                "/ adjust error
                xE := x + 2.
                error := (greyErrors at:(value + 1)) + (errorArray at:xE).

                byte := byte bitShift:depth.
                error > 512 "0.5" ifTrue:[
                    pixel := pixel + 1.
                    e := error - 1024 "1.0"
                ] ifFalse:[
                    e := error
                ].
                byte := byte bitOr:pixel.

                e ~= 0 ifTrue:[
                    e16 := e // 16.

                    eR  := e16 * 7.              "/ 7/16 to right
                    eRB := e16 "* 1".            "/ 1/16 to right below
                    eB  := e16 * 5.              "/ 5/16 to below
                    eLB := e - eR - eRB - eB.  "/ 3/16 to left below

                    xN := xE + 1.
                    eR ~= 0 ifTrue:[
                        errorArray     at:xN put:(errorArray at:xN) + eR.
                    ].
                    eRB ~= 0 ifTrue:[
                        nextErrorArray at:xN put:(nextErrorArray at:xN) + eRB.
                    ].
                    eB ~= 0 ifTrue:[
                        nextErrorArray at:xE put:(nextErrorArray at:xE) + eB.
                    ].
                    eLB ~= 0 ifTrue:[
                        xN := xE - 1.
                        nextErrorArray at:xN put:(nextErrorArray at:xN) + eLB.
                    ].
                ].

                bitCnt := bitCnt - depth.
                bitCnt == 0 ifTrue:[
                    outBits at:dstIndex put:byte.
                    dstIndex := dstIndex + 1.
                    byte := 0.
                    bitCnt := 8.
                ].

            ].
            bitCnt ~~ 8 ifTrue:[
                byte := byte bitShift:bitCnt.
                outBits at:dstIndex put:byte.
                bitCnt := 8.
            ].

            dstIndex := nextDst.
        ].
    ] ifFalse:[
        0 to:(h-1) do:[:y |
            nextDst := dstIndex + bytesPerOutRow.
            byte := 0.

            t := errorArray.
            errorArray := nextErrorArray.
            nextErrorArray := t.

            nextErrorArray atAllPut:0.

            self colorsAtY:y from:0 to:(w-1) do:[:x :clr |
                |e     "{ Class: SmallInteger }"
                 pixel "{ Class: SmallInteger }"
                 error "{ Class: SmallInteger }"
                 e16   "{ Class: SmallInteger }"
                 xE    "{ Class: SmallInteger }"
                 xN    "{ Class: SmallInteger }" |

                grey := (clr brightness * greyLevels).
                pixel := grey truncated.
                error := ((grey - pixel) * 1024) truncated.

                "/ adjust error
                xE := x + 2.
                error := error + (errorArray at:xE).

                byte := byte bitShift:depth.
                error > 512 "0.5" ifTrue:[
                    pixel := pixel + 1.
                    e := error - 1024 "1.0"
                ] ifFalse:[
                    e := error
                ].

                byte := byte bitOr:pixel.

                e ~= 0 ifTrue:[
                    e16 := e // 16.

                    eR  := e16 * 7.              "/ 7/16 to right
                    eRB := e16 "* 1".            "/ 1/16 to right below
                    eB  := e16 * 5.              "/ 5/16 to below
                    eLB := e - eR - eRB - eB.  "/ 3/16 to left below

                    xN := xE + 1.
                    eR ~= 0 ifTrue:[
                        errorArray     at:xN put:(errorArray at:xN) + eR.
                    ].
                    eRB ~= 0 ifTrue:[
                        nextErrorArray at:xN put:(nextErrorArray at:xN) + eRB.
                    ].
                    eB ~= 0 ifTrue:[
                        nextErrorArray at:xE put:(nextErrorArray at:xE) + eB.
                    ].
                    eLB ~= 0 ifTrue:[
                        xN := xE - 1.
                        nextErrorArray at:xN put:(nextErrorArray at:xN) + eLB.
                    ].
                ].

                bitCnt := bitCnt - depth.
                bitCnt == 0 ifTrue:[
                    outBits at:dstIndex put:byte.
                    dstIndex := dstIndex + 1.
                    byte := 0.
                    bitCnt := 8.
                ].

            ].
            bitCnt ~~ 8 ifTrue:[
                byte := byte bitShift:bitCnt.
                outBits at:dstIndex put:byte.
                bitCnt := 8.
            ].

            dstIndex := nextDst.
        ].
    ].

    ^ outBits

    "Created: 10.6.1996 / 13:28:22 / cg"
    "Modified: 11.6.1996 / 00:13:38 / cg"
!

floydSteinbergDitheredMonochromeBits
    "return the bitmap for a dithered monochrome bitmap from the image.
     Works for any source depths / photometric,
     but very very slow since each pixel is processed individually.
     Redefined by some subclasses for more performance (D8Image)"

    |dstIndex        "{Class: SmallInteger }"
     nextDst         "{Class: SmallInteger }"
     bytesPerMonoRow "{Class: SmallInteger }"
     monoBits greyValues
     errorArray
     nextErrorArray
     e eD t
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"
     bitCnt          "{Class: SmallInteger }"
     byte            "{Class: SmallInteger }"
     grey
     eR eRB eB eLB |

    w := width.
    h := height.

    bytesPerMonoRow := (w + 7) // 8.
    monoBits := ByteArray uninitializedNew:(bytesPerMonoRow * h).

    errorArray := Array new:w+2.
    nextErrorArray := Array new:w+2.

    nextErrorArray atAllPut:0.

    dstIndex := 1.
    bitCnt := 8.
    byte := 0.

    self depth <= 12 ifTrue:[
        "/ fetch scaled brightness values outside of loop into a table;
        "/ use table-value in loop

        greyValues := self greyMapForRange:(255 * 1024).
        greyValues := greyValues collect:[:v | v rounded].

        0 to:(h-1) do:[:y |
            nextDst := dstIndex + bytesPerMonoRow.

            t := errorArray.
            errorArray := nextErrorArray.
            nextErrorArray := t.

            nextErrorArray atAllPut:0.

            self valuesAtY:y from:0 to:(w-1) do:[:x :pixel |
%{
                int __grey, __e;
                int __byte = __intVal(byte);
                OBJ *__errorArray = __ArrayInstPtr(errorArray)->a_element;
                OBJ *__nextErrorArray = __ArrayInstPtr(nextErrorArray)->a_element;
                int __x = __intVal(x);
                int __eR, __eB, __eRB, __eLB, __eI;
                int __bitCnt = __intVal(bitCnt);

                __grey = __intVal(__ArrayInstPtr(greyValues)->a_element[__intVal(pixel)]);
                __grey += __intVal(__errorArray[__x+1]);

                __byte <<= 1;
                if (__grey > 127*1024) {
                    __e = __grey - (255*1024);
                    __byte |= 1;
                } else {
                    __e = __grey;
                }
                if (__e) {
                    __eI = __e >> 4;
                    __eR  = __eI * 7;
                    __eRB = __eI * 1;
                    __eB  = __eI * 5;
                    __eLB = __e - __eR - __eRB - __eB;
                    __errorArray[__x+2] = __MKSMALLINT(__intVal(__errorArray[__x+2]) + __eR);
                    __nextErrorArray[__x+2] = __MKSMALLINT(__intVal(__nextErrorArray[__x+2]) + __eRB);
                    __nextErrorArray[__x+1] = __MKSMALLINT(__intVal(__nextErrorArray[__x+1]) + __eB);
                    __nextErrorArray[__x  ] = __MKSMALLINT(__intVal(__nextErrorArray[__x  ]) + __eLB);

                }
                __bitCnt--;
                if (__bitCnt == 0) {
                    int __dstIndex = __intVal(dstIndex);

                    __ByteArrayInstPtr(monoBits)->ba_element[__dstIndex-1] = __byte;
                    dstIndex = __MKSMALLINT(__dstIndex + 1);
                    __byte = 0;
                    __bitCnt = 8;
                }
                byte = __MKSMALLINT(__byte);
                bitCnt = __MKSMALLINT(__bitCnt);
%}.

"/                |eI "{ Class: SmallInteger }"
"/                 xE "{ Class: SmallInteger }"
"/                 xN "{ Class: SmallInteger }" |
"/
"/                "/ get the colors grey value [0 .. 1]
"/                grey := greyValues at:(pixel + 1).
"/
"/                "/ adjust error
"/                xE := x + 2.
"/                grey := (grey + (errorArray at:xE)).
"/
"/                byte := byte bitShift:1.
"/                grey > (127*1024) ifTrue:[
"/                    byte := byte bitOr:1.      "/ white
"/                    e := grey - (255*1024)
"/                ] ifFalse:[
"/                    e := grey                  "/ black
"/                ].
"/                e ~= 0 ifTrue:[
"/                    eD := e.
"/                    eI := e // 16.
"/
"/                    eR  := eI * 7.              "/ 7/16 to right
"/                    eRB := eI * 1.              "/ 1/16 to right below
"/                    eB  := eI * 5.              "/ 5/16 to below
"/                    eLB := eD - eR - eRB - eB.  "/ 3/16 to left below
"/
"/                    xN := xE + 1.
"/                    eR ~= 0 ifTrue:[
"/                        errorArray     at:xN put:(errorArray at:xN) + eR.
"/                    ].
"/                    eRB ~= 0 ifTrue:[
"/                        nextErrorArray at:xN put:(nextErrorArray at:xN) + eRB.
"/                    ].
"/                    eB ~= 0 ifTrue:[
"/                        nextErrorArray at:xE put:(nextErrorArray at:xE) + eB.
"/                    ].
"/                    eLB ~= 0 ifTrue:[
"/                        xN := xE - 1.
"/                        nextErrorArray at:xN put:(nextErrorArray at:xN) + eLB.
"/                    ].
"/                ].
"/
"/                bitCnt := bitCnt - 1.
"/                bitCnt == 0 ifTrue:[
"/                    monoBits at:dstIndex put:byte.
"/                    dstIndex := dstIndex + 1.
"/                    byte := 0.
"/                    bitCnt := 8.
"/                ].
                  0
            ].
            bitCnt ~~ 8 ifTrue:[
                byte := byte bitShift:bitCnt.
                monoBits at:dstIndex put:byte.
                bitCnt := 8.
                byte := 0.
            ].

            dstIndex := nextDst.
        ].
    ] ifFalse:[
        'Image [info]: slow floydSteinberg dither ..' infoPrintCR.

        0 to:(h-1) do:[:y |
            nextDst := dstIndex + bytesPerMonoRow.

            t := errorArray.
            errorArray := nextErrorArray.
            nextErrorArray := t.

            nextErrorArray atAllPut:0.

            self colorsAtY:y from:0 to:(w-1) do:[:x :clr |
                |eI "{ Class: SmallInteger }"
                 xE "{ Class: SmallInteger }"
                 xN "{ Class: SmallInteger }" |

                "/ get the colors grey value [0 .. 1]
                grey := (clr brightness * 255).

                "/ adjust error
                xE := x + 2.
                grey := (grey + (errorArray at:xE)) rounded.

                byte := byte bitShift:1.
                grey > 127 ifTrue:[
                    byte := byte bitOr:1.      "/ white
                    e := grey - 255
                ] ifFalse:[
                    e := grey                  "/ black
                ].

                e ~= 0 ifTrue:[
                    eD := e.
                    eI := e // 16.
                    eR  := eI * 7.              "/ 7/16 to right
                    eRB := eI "* 1".            "/ 1/16 to right below
                    eB  := eI * 5.              "/ 5/16 to below
                    eLB := eD - eR - eRB - eB.  "/ 3/16 to left below

                    xN := xE + 1.
                    eR ~= 0 ifTrue:[
                        errorArray     at:xN put:(errorArray at:xN) + eR.
                    ].
                    eRB ~= 0 ifTrue:[
                        nextErrorArray at:xN put:(nextErrorArray at:xN) + eRB.
                    ].
                    eB ~= 0 ifTrue:[
                        nextErrorArray at:xE put:(nextErrorArray at:xE) + eB.
                    ].
                    eLB ~= 0 ifTrue:[
                        xN := xE - 1.
                        nextErrorArray at:xN put:(nextErrorArray at:xN) + eLB.
                    ].
                ].

                bitCnt := bitCnt - 1.
                bitCnt == 0 ifTrue:[
                    monoBits at:dstIndex put:byte.
                    dstIndex := dstIndex + 1.
                    byte := 0.
                    bitCnt := 8.
                ].

            ].
            bitCnt ~~ 8 ifTrue:[
                byte := byte bitShift:bitCnt.
                monoBits at:dstIndex put:byte.
                bitCnt := 8.
                byte := 0.
            ].

            dstIndex := nextDst.
        ].
    ].

    ^ monoBits

    "Created: 8.6.1996 / 16:39:46 / cg"
    "Modified: 10.6.1996 / 15:12:11 / cg"
!

nearestPaintDepth8BitsColors:fixColors nRed:nRed nGreen:nGreen nBlue:nBlue
    "return a nearest paint bitmap from the receiver picture,
     which must be a depth-8 image.
     This is a special-cased dither method for 8-bit palette images being displayed on
     an 8-bit pseudoColor display, AND fixColor dithering is used.
     Use the colors in the fixColors array, which must be fixR x fixG x fixB
     colors assigned to aDevice, such as the preallocated colors of the
     Color class."

    |pseudoBits
     fixR    "{Class: SmallInteger }"
     fixG    "{Class: SmallInteger }"
     fixB    "{Class: SmallInteger }"
     fixGfixB
     r       "{Class: SmallInteger }"
     g       "{Class: SmallInteger }"
     b       "{Class: SmallInteger }"
     idx     "{Class: SmallInteger }"
     idMap lastColor
     clr|

    self depth ~~ 8 ifTrue:[^ nil].

    photometric == #palette ifTrue:[
        lastColor := colorMap size - 1
    ] ifFalse:[
        lastColor := 255.
    ].
    idMap := ByteArray uninitializedNew:256.

    (nRed isNil or:[nGreen isNil or:[nBlue isNil]]) ifTrue:[
        0 to:lastColor do:[:pix |
            |clr repClr|

            clr := self colorFromValue:pix.
            repClr := clr nearestIn:fixColors.
            idMap at:(pix+1) put:(fixColors identityIndexOf:repClr)-1.
        ].
    ] ifFalse:[
        fixR := nRed.
        fixR == 0 ifTrue:[ ^ nil].
        fixG := nGreen.
        fixG == 0 ifTrue:[ ^ nil].
        fixB := nBlue.
        fixB == 0 ifTrue:[ ^ nil].

        "/ simple check
        (fixR * fixG * fixB) ~~ fixColors size ifTrue:[
            self error:'invalid color array passed'.
            ^ nil
        ].

        "/
        "/ collect colorIds
        "/
        fixGfixB := fixG * fixB.

        0 to:lastColor do:[:pix |
            clr := self colorFromValue:pix.
            r := clr redByte.
            g := clr greenByte.
            b := clr blueByte.
            idx := ((r * (fixR-1) + 128) // 255) * fixGfixB.
            idx := idx + (((g * (fixG-1) + 128) // 255) * fixB).
            idx := idx + ((b * (fixB-1) + 128) // 255).
            idMap at:(pix+1) put:(fixColors at:(idx+1)) colorId.
        ].
    ].

    pseudoBits := ByteArray uninitializedNew:(width * height).

    "/ translate

    self bits
        expandPixels:8         "xlate only"
        width:width height:height
        into:pseudoBits
        mapping:idMap.

    ^ pseudoBits

    "Modified: 18.6.1996 / 09:18:09 / cg"
!

nfloydSteinbergDitheredDepth8BitsColors:colors
    "return a floyd-steinberg dithered bitmap from the receiver picture,
     which must be a depth-8 image.
     This method expects an array of colors to be used for dithering
     (which need not be a colorCubes colors)."

    |pseudoBits
     rgbBytes
     ditherRGBBytes ditherColors
     w       "{Class: SmallInteger }"
     h       "{Class: SmallInteger }"
     index   "{Class: SmallInteger }"
     numR    "{Class: SmallInteger }"
     numG    "{Class: SmallInteger }"
     numB    "{Class: SmallInteger }"
     bitsR    "{Class: SmallInteger }"
     bitsG    "{Class: SmallInteger }"
     bitsB    "{Class: SmallInteger }"
     maxBits  "{Class: SmallInteger }"
     maskR    "{Class: SmallInteger }"
     maskG    "{Class: SmallInteger }"
     maskB    "{Class: SmallInteger }"
     shR      "{Class: SmallInteger }"
     shG      "{Class: SmallInteger }"
     shB      "{Class: SmallInteger }"
     ditherIds failed map lastColor colorsByDistance qScramble
     clrLookup lookupPos cube nCube
     dR  "{Class: SmallInteger }"
     dG  "{Class: SmallInteger }"
     dB  "{Class: SmallInteger }"
     iR    "{Class: SmallInteger }"
     iRG   "{Class: SmallInteger }"
     iRGB  "{Class: SmallInteger }"
     clr
     rI  "{Class: SmallInteger }"
     gI  "{Class: SmallInteger }"
     bI  "{Class: SmallInteger }"
     maxIDX  "{Class: SmallInteger }"
     subCubeColorCollection
     error
     dl "{Class: SmallInteger }"|

    self depth ~~ 8 ifTrue:[^ nil].

    "/
    "/ collect color components as integer values (for integer arithmetic)
    "/
    rgbBytes := ByteArray uninitializedNew:256 * 3.

    photometric == #palette ifTrue:[
        lastColor := colorMap size - 1
    ] ifFalse:[
        lastColor := 255.
    ].
    index := 1.
    0 to:lastColor do:[:pix |
        clr := self colorFromValue:pix.
        rgbBytes at:index put:(clr redByte).
        rgbBytes at:index+1 put:(clr greenByte).
        rgbBytes at:index+2 put:(clr blueByte).

        index := index + 3.
    ].

    "/ collect valid ditherColors ...

    ditherColors := colors select:[:clr | clr notNil].
    ditherColors := ditherColors select:[:clr | clr colorId notNil].

    "/ collect ditherColor components

    lastColor := ditherColors size.
    ditherIds := ByteArray uninitializedNew:lastColor.
    ditherRGBBytes := ByteArray uninitializedNew:(lastColor * 3).
    index := 1.
    1 to:lastColor do:[:pix |
        clr := ditherColors at:pix.
        ditherRGBBytes at:index put:(clr redByte).
        ditherRGBBytes at:index+1 put:(clr greenByte).
        ditherRGBBytes at:index+2 put:(clr blueByte).
        ditherIds at:pix put:clr colorId.

        index := index + 3.
    ].

    "/ place the ditherColor positions into a color cube
    bitsR := 5.
    bitsG := 6.
    bitsB := 4.
    maxBits := 6.

"/    bitsR := 4.
"/    bitsG := 4.
"/    bitsB := 3.

    numR := 1 bitShift:bitsR.
    numG := 1 bitShift:bitsG.
    numB := 1 bitShift:bitsB.

    maskR := (numR-1) bitShift:(bitsG + bitsB).
    maskG := (numG-1) bitShift:bitsB.
    maskB := numB-1.

    shR := -16+bitsR+bitsG+bitsB.
    shG := -16+bitsG+bitsB.
    shB := -16+bitsB.

    maxIDX := numR*numG*numB.
    cube := Array new:maxIDX.
    1 to:lastColor do:[:clrIdx |
        clr := ditherColors at:clrIdx.
        rI := clr scaledRed. rI := (rI bitShift:shR) bitAnd:maskR.
        gI := clr scaledGreen. gI := (gI bitShift:shG) bitAnd:maskG.
        bI := clr scaledBlue. bI := (bI bitShift:shB) bitAnd:maskB.
        index := rI + gI + bI + 1.
        subCubeColorCollection := cube at:index.
        subCubeColorCollection isNil ifTrue:[
            subCubeColorCollection := OrderedCollection new.
            cube at:index put:subCubeColorCollection.
        ].
        subCubeColorCollection add:(clrIdx - 1).
    ].

    shR := 1 bitShift:(bitsG+bitsB).
    shG := 1 bitShift:(bitsB).
    shB := 1.

    1 to:maxIDX do:[:i |
        subCubeColorCollection := cube at:i.
        subCubeColorCollection notNil ifTrue:[
            cube at:i put:(subCubeColorCollection asByteArray)
        ]
    ].

"/    nCube := cube copy.
"/
"/    cube keysAndValuesDo:[:i :indices |
"/        indices notNil ifTrue:[
"/            nCube at:i put:(indices asByteArray)
"/        ] ifFalse:[
"/            "/ find nearest color
"/
"/            dl := 1.
"/            [dl < maxBits] whileTrue:[
"/                dR := dl negated.
"/                [dR <= dl] whileTrue:[
"/                    iR := i + (dR * shR).
"/                    (iR > 0 and:[iR < maxIDX]) ifTrue:[
"/                        dG := dl negated.
"/                        [dG < dl] whileTrue:[
"/                            iRG := iR + (dG * shG).
"/                            (iRG > 0 and:[iRG < maxIDX]) ifTrue:[
"/                                dB := dl negated.
"/                                [dB < dl] whileTrue:[
"/                                    iRGB := iRG + dB.
"/                                    (iRG > 0 and:[iRG < maxIDX]) ifTrue:[
"/                                        (cube at:iRGB) notNil ifTrue:[
"/                                            nCube at:i put:(cube at:iRGB).
"/                                            dB := dG := dR := dl := 999.
"/                                        ]
"/                                    ].
"/                                    dB := dB + 1.
"/                                ]
"/                            ].
"/                            dG := dG + 1.
"/                        ]
"/                    ].
"/                    dR := dR + 1.
"/                ].
"/                dl := dl + 1.
"/            ]
"/        ]
"/    ].
"/self halt.

    "/ now, cube contains collections of colors which are
    "/ positioned in a subCube; quickly accessed by a lookup

    pseudoBits := ByteArray uninitializedNew:(width * height).

    w := width.
    h := height.
    error := ByteArray new:(w+2)*3*2.

%{
#define BITSR   5
#define BITSG   6
#define BITSB   4
#define MAXBITS 6

#define xBITSR   4
#define xBITSG   4
#define xBITSB   3
#define xMAXBITS 4

#define NR      32 /* (1<<BITSR) */
#define NG      64 /* (1<<BITSG) */
#define NB      16 /* (1<<BITSB) */
#define MAXRGB  64 /* (1<<MAXBITS) */

#define SHR     (BITSG+BITSB)
#define SHG     BITSB

#define REMEMBER_SEARCH
#define xNO_FLOYD_STEINBERG

    int __x, __y;
    int __eR, __eG, __eB;
    unsigned char *srcP, *dstP;
    unsigned char *rgbP;
    unsigned char *idP;
    short *errP, *eP;
    int __fR, __fG, __fB;
    int idx;
    int __w = __intVal(w);
    int __h = __intVal(h);
    int __nColors = __intVal(lastColor);
    int __wR = -1, __wG, __wB;
    OBJ *__cube;
    int cubeIndex, cubeIndex2;

    if (__isByteArrayLike(__INST(bytes))
     && __isByteArray(pseudoBits)
     && __isByteArray(rgbBytes)
     && __isByteArray(ditherRGBBytes)
     && __isByteArray(ditherIds)
     && __isByteArray(error)) {
        failed = false;

        srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element;
        dstP = __ByteArrayInstPtr(pseudoBits)->ba_element;
        rgbP = __ByteArrayInstPtr(rgbBytes)->ba_element;
        idP = __ByteArrayInstPtr(ditherIds)->ba_element;
        errP = (short *) __ByteArrayInstPtr(error)->ba_element;
        __cube = __ArrayInstPtr(cube)->a_element;

        eP = errP;

        for (__y=__h; __y>0; __y--) {
            eP = &(errP[3]);
            __eR = eP[0];
            __eG = eP[1];
            __eB = eP[2];

            for (__x=__w; __x>0; __x--) {
                int __want;
                int pix;
                int __wantR, __wantG, __wantB;
                int idx;
                int tR, tG, tB;
                int nR, nG, nB;
                int __dR, __dG, __dB;
                int minDelta, bestIdx;
                int __iR, __iG, __iB;
                int cR, cG, cB;
                int delta;
                OBJ subCubeColors;

                pix = *srcP++;

                /*
                 * wR, wG and wB is the wanted r/g/b value;
                 */
                idx = pix+pix+pix;  /* pix * 3 */

                __wR = __wantR = rgbP[idx] + __eR;
                __wG = __wantG = rgbP[idx+1] + __eG;
                __wB = __wantB = rgbP[idx+2] + __eB;
                if(__wR > 255) __wR = 255;
                else if (__wR < 0) __wR = 0;
                if(__wG > 255) __wG = 255;
                else if (__wG < 0) __wG = 0;
                if(__wB > 255) __wB = 255;
                else if (__wB < 0) __wB = 0;

                __iR = __wR >> (8-BITSR);
                __iG = __wG >> (8-BITSG);
                __iB = __wB >> (8-BITSB);

                cubeIndex = (__iR<<SHR) + (__iG<<SHG) + __iB;
                subCubeColors = __cube[cubeIndex];

                if (subCubeColors == nil) {
                    /* search around in spirals, for the first match */

                    delta = 1;
                    while (delta < MAXRGB) {
                        /* check plane above */
                        cR = __iR + delta;
                        if ((unsigned)cR < NR) {
                            for (cG=__iG-delta; cG<=__iG+delta; cG++) {
                                if ((unsigned)cG < NG) {
                                    for (cB=__iB-delta; cB<=__iB+delta; cB++) {
                                        if ((unsigned)cB < NB) {
                                            cubeIndex2 = (cR<<SHR) + (cG<<SHG) + cB;
                                            subCubeColors = __cube[cubeIndex2];
                                            if (__isNonNilObject(subCubeColors)) {
                                                goto found;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        /* check plane below */
                        cR = __iR - delta;
                        if ((unsigned)cR < NR) {
                            for (cG=__iG-delta; cG<=__iG+delta; cG++) {
                                if ((unsigned)cG < NG) {
                                    for (cB=__iB-delta; cB<=__iB+delta; cB++) {
                                        if ((unsigned)cB < NB) {
                                            cubeIndex2 = (cR<<SHR) + (cG<<SHG) + cB;
                                            subCubeColors = __cube[cubeIndex2];
                                            if (__isNonNilObject(subCubeColors)) {
                                                goto found;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        /* check plane to the right */
                        cG = __iG + delta;
                        if ((unsigned)cG < NG) {
                            for (cR=__iR-delta+1; cR<=__iR+delta-1; cR++) {
                                if ((unsigned)cR < NR) {
                                    for (cB=__iB-delta; cB<=__iB+delta; cB++) {
                                        if ((unsigned)cB < NB) {
                                            cubeIndex2 = (cR<<SHR) + (cG<<SHG) + cB;
                                            subCubeColors = __cube[cubeIndex2];
                                            if (__isNonNilObject(subCubeColors)) {
                                                goto found;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        /* check plane to the left */
                        cG = __iG - delta;
                        if ((unsigned)cG < NG) {
                            for (cR=__iR-delta+1; cR<=__iR+delta-1; cR++) {
                                if ((unsigned)cR < NR) {
                                    for (cB=__iB-delta; cB<=__iB+delta; cB++) {
                                        if ((unsigned)cB < NB) {
                                            cubeIndex2 = (cR<<SHR) + (cG<<SHG) + cB;
                                            subCubeColors = __cube[cubeIndex2];
                                            if (__isNonNilObject(subCubeColors)) {
                                                goto found;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        /* check plane at back */
                        cB = __iB + delta;
                        if ((unsigned)cB < NB) {
                            for (cR=__iR-delta+1; cR<=(__iR+delta-1); cR++) {
                                if ((unsigned)cR < NR) {
                                    for (cG=__iG-delta+1; cG<=(__iG+delta-1); cG++) {
                                        if ((unsigned)cG < NG) {
                                            cubeIndex2 = (cR<<SHR) + (cG<<SHG) + cB;
                                            subCubeColors = __cube[cubeIndex2];
                                            if (__isNonNilObject(subCubeColors)) {
                                                goto found;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        /* check plane at front */
                        cB = __iB - delta;
                        if ((unsigned)cB < NB) {
                            for (cR=__iR-delta+1; cR<=(__iR+delta-1); cR++) {
                                if ((unsigned)cR < NR) {
                                    for (cG=__iG-delta+1; cG<=(__iG+delta-1); cG++) {
                                        if ((unsigned)cG < NG) {
                                            cubeIndex2 = (cR<<SHR) + (cG<<SHG) + cB;
                                            subCubeColors = __cube[cubeIndex2];
                                            if (__isNonNilObject(subCubeColors)) {
                                                goto found;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        delta = delta + 1;

                    }
                    /* cannot happen - will lead to a segmentation violation ... */
                    subCubeColors = nil;

    found:
                    __iR = cR;
                    __iG = cG;
                    __iB = cB;
                    bestIdx = __ByteArrayInstPtr(subCubeColors)->ba_element[0];
#ifdef REMEMBER_SEARCH
                    __cube[cubeIndex] = __MKSMALLINT(bestIdx);
#endif
                } else {
#ifdef REMEMBER_SEARCH
                    if (__isSmallInteger(subCubeColors)) {
                        bestIdx = __intVal(subCubeColors);
                    } else
#endif
                    {
                        bestIdx = __ByteArrayInstPtr(subCubeColors)->ba_element[0];
                    }
                }

                /*
                 * ok, now, we have found a collection of nearby
                 * colors in subCubeColors.
                 *
                 * since the error is at most 1/16 (i.e. roughly 6%),
                 * don't care for searching the best - simply take the
                 * first color found there.
                 * (statistic reduces the error to even a smaller value).
                 * There is no real problem due to that error, since
                 * it will be diffused anyway ...
                 */

#ifndef NO_FLOYD_STEINBERG
                {
                    unsigned char *dp;

                    /*
                     * fetch that colors r/g/b components
                     */
                    dp = __ByteArrayInstPtr(ditherRGBBytes)->ba_element;
                    dp += bestIdx * 3;
                    __dR = dp[0];
                    __dG = dp[1];
                    __dB = dp[2];
                }
#endif

/*
console_fprintf(stderr, "want: %d/%d/%d (%d/%d/%d) got: %d/%d/%d\n",
                __wantR, __wantG, __wantB,
                __wR, __wG, __wB,
                __dR, __dG, __dB);
*/
                /*
                 * store the corresponding dither colors colorId
                 */
                *dstP++ = idP[bestIdx];

#ifndef NO_FLOYD_STEINBERG
                /*
                 * the new error & distribute the error
                 */
                __eR = __wantR - __dR;
                if (__eR) {
                    tR = __eR >> 4;  /* 16th of error */
                    nR = eP[3] + (tR * 7);/* from accu: error for (x+1 / y) */
                    eP[0] = tR*5;         /* 5/16th for (x / y+1) */
                    eP[-3] = tR*3;        /* 3/16th for (x-1 / y+1) */
                    eP[3] = __eR - (tR*15);  /* 1/16th for (x+1 / y+1) */
                    __eR = nR;
                } else {
                    __eR = eP[3];
                    eP[0] = eP[-3] = eP[3] = 0;
                }

                __eG = __wantG - __dG;
                if (__eG) {
                    tG = __eG >> 4;
                    nG = eP[4] + (tG * 7);/* plus 7/16'th of this error */
                    eP[1] = tG*5;
                    eP[-2] = tG*3;
                    eP[4] = __eG - (tG*15);
                    __eG = nG;
                } else {
                    __eG = eP[4];
                    eP[1] = eP[-2] = eP[4] = 0;
                }

                __eB = __wantB - __dB;
                if (__eB) {
                    tB = __eB >> 4;
                    nB = eP[5] + (tB * 7);
                    eP[2] = tB*5;
                    eP[-1] = tB*3;
                    eP[5] = __eB - (tB*15);
                    __eB = nB;
                } else {
                    __eB = eP[5];
                    eP[2] = eP[-1] = eP[5] = 0;
                }

                eP += 3;
#endif
            }

            /*
             * allow for an interrupt after every row.
             * but care to refetch C variables
             */
            if (InterruptPending) {
                int d_srcP = srcP - __ByteArrayInstPtr(__INST(bytes))->ba_element;
                int d_dstP = dstP - __ByteArrayInstPtr(pseudoBits)->ba_element;
                int d_errP = errP - (short *) __ByteArrayInstPtr(error)->ba_element;

                __interrupt__();

                srcP = __ByteArrayInstPtr(__INST(bytes))->ba_element + d_srcP;
                dstP = __ByteArrayInstPtr(pseudoBits)->ba_element + d_dstP;
                rgbP = __ByteArrayInstPtr(rgbBytes)->ba_element;
                idP = __ByteArrayInstPtr(ditherIds)->ba_element;
                errP = (short *) __ByteArrayInstPtr(error)->ba_element + d_errP;
                __cube = __ArrayInstPtr(cube)->a_element;
            }
        }
    }
%}.
    failed ifTrue:[
        self primitiveFailed.
        ^ nil
    ].

    ^ pseudoBits
!

orderedDitheredGrayBitsDepth:depth
    "return the bitmap for a dithered depth-bitmap from the image"

    ^ self
        orderedDitheredGrayBitsWithDitherMatrix:(self class orderedDitherMatrixOfSize:8)
        ditherWidth:8
        depth:depth.

    "Created: 24.6.1997 / 22:20:12 / cg"
!

orderedDitheredGrayBitsWithDitherMatrix:ditherMatrix ditherWidth:dW depth:depth
    "return the bitmap for a dithered depth-bitmap from the image;
     with a constant ditherMatrix, this can be used for thresholding.
     Works for any source depths / photometric,
     but very very slow since each pixel is processed individually.
     Redefined by some subclasses for more performance (D8Image)"

    |dH nDither
     greyLevels greyValues greyPixels greyErrors
     dstIndex        "{Class: SmallInteger }"
     nextDst
     bytesPerOutRow  "{Class: SmallInteger }"
     pixelsPerByte   "{Class: SmallInteger }"
     outBits
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"
     bitCnt          "{Class: SmallInteger }"
     byte            "{Class: SmallInteger }" |

    depth > 8 ifTrue:[
        'IMAGE: unimplemented orderedDither conversion' errorPrintCR.
        ^ nil
    ].

    nDither := ditherMatrix size.
    dH := nDither / dW.

    w := width.
    h := height.

    greyLevels := 1 bitShift:depth.
    pixelsPerByte := 8 / depth.

    bytesPerOutRow := (w * depth + 7) // 8.
    outBits := ByteArray uninitializedNew:(bytesPerOutRow * h).

    dstIndex := 1.

    self bitsPerPixel <= 12 ifTrue:[
        "/ fetch scaled brightness values outside of loop into a table;
        "/ use table-value in loop

        greyValues := self greyMapForRange:(greyLevels-1).
        greyPixels := greyValues collect:[:v | v isNil ifTrue:[
                                                   0
                                               ] ifFalse:[
                                                   v truncated]].
        greyPixels := ByteArray withAll:greyPixels.

        greyErrors := greyValues collect:[:v | v isNil ifTrue:[
                                                   0
                                               ] ifFalse:[
                                                   ((v - v truncated) * nDither) rounded
                                               ]].
        greyErrors := ByteArray withAll:greyErrors.

        0 to:(h-1) do:[:y |
            nextDst := dstIndex + bytesPerOutRow.
            byte := 0.
            bitCnt := 8.

            self valuesAtY:y from:0 to:(w-1) do:[:x :value |
%{
                int __dW = __intVal(dW);
                int __byte = __intVal(byte);
                /* Note: __value is reserved in Visual C++ 8 (2005) */
                int __val = __intVal(value);
                int __dT;
                int __dstIdx;
                int __pixel, __grey;
                int __bitCnt = __intVal(bitCnt);
                unsigned char *__greyPixels = __ByteArrayInstPtr(greyPixels)->ba_element;
                unsigned char *__greyErrors = __ByteArrayInstPtr(greyErrors)->ba_element;

                __pixel = __greyPixels[__val];
                __grey = __greyErrors[__val];

                __dT = __ByteArrayInstPtr(ditherMatrix)
                            ->ba_element[__intVal(x) % __dW
                                         + (__intVal(y) % __intVal(dH)) * __dW];

                if (__grey > __dT) {
                    __pixel++;
                }
                __byte = (__byte << __intVal(depth)) | __pixel;

                __bitCnt = __bitCnt - __intVal(depth);
                if (__bitCnt == 0) {
                    __dstIdx = __intVal(dstIndex);
                    __ByteArrayInstPtr(outBits)->ba_element[__dstIdx-1] = __byte;
                    __dstIdx = __dstIdx + 1;
                    dstIndex = __MKSMALLINT(__dstIdx);
                    __byte = 0;
                    __bitCnt = 8;
                }
                byte = __MKSMALLINT(__byte);
                bitCnt = __MKSMALLINT(__bitCnt);
%}.
                0

            ].
            bitCnt ~~ 8 ifTrue:[
                byte := byte bitShift:bitCnt.
                outBits at:dstIndex put:byte.
            ].
            dstIndex := nextDst.
        ].
    ] ifFalse:[
        'Image [info]: slow ordered dither ..' infoPrintCR.

        0 to:(h-1) do:[:y |
            nextDst := dstIndex + bytesPerOutRow.
            byte := 0.
            bitCnt := 8.

            "/ this is the representaion independent (but slow)
            "/ inner loop - it extracts colors from the receiver

            self colorsAtY:y from:0 to:(w-1) do:[:x :clr |
                |dstClr grey dT pixel|

                "/ get the colors grey value [0 .. 1]
                grey := clr brightness.

                "/ remap into [0 .. greyLevels-1]
                grey := grey * (greyLevels-1).

                "/ get threshold pixel [0 .. greyLevels-1]

                pixel := grey truncated.

                "/ compute the error [0..1]
                grey := grey - pixel.

                "/ map into dither space [0 .. nDither]
                grey := (grey * (nDither)) rounded.

%{
                int __dW = __intVal(dW);
                int __byte = __intVal(byte);
                int __dT;
                int __dstIdx;
                int __pixel;
                int __bitCnt = __intVal(bitCnt);

                __dT = __ByteArrayInstPtr(ditherMatrix)
                            ->ba_element[__intVal(x) % __dW
                                         + (__intVal(y) % __intVal(dH)) * __dW];

                __pixel = __intVal(pixel);

                if (__intVal(grey) > __dT) {
                    __pixel++;
                }
                __byte = (__byte << __intVal(depth)) | __pixel;

                __bitCnt = __bitCnt - __intVal(depth);
                if (__bitCnt == 0) {
                    __dstIdx = __intVal(dstIndex);
                    __ByteArrayInstPtr(outBits)->ba_element[__dstIdx-1] = __byte;
                    __dstIdx = __dstIdx + 1;
                    dstIndex = __MKSMALLINT(__dstIdx);
                    __byte = 0;
                    __bitCnt = 8;
                }
                byte = __MKSMALLINT(__byte);
                bitCnt = __MKSMALLINT(__bitCnt);
%}.
                0

            ].
            bitCnt ~~ 8 ifTrue:[
                byte := byte bitShift:bitCnt.
                outBits at:dstIndex put:byte.
            ].
            dstIndex := nextDst.
        ].
    ].
    ^ outBits
!

orderedDitheredMonochromeBits
    "return the bitmap for a dithered monochrome bitmap from the image;
     using a default ditherMatrix."

    ^ self
        orderedDitheredMonochromeBitsWithDitherMatrix:(self class orderedDitherMatrixOfSize:8)
        ditherWidth:8

    "Created: 11.6.1996 / 16:48:57 / cg"
!

orderedDitheredMonochromeBitsWithDitherMatrix:ditherMatrix ditherWidth:dW
    "return the bitmap for a dithered monochrome bitmap from the image;
     with a constant ditherMatrix, this can be used for thresholding.
     Works for any source depths / photometric,
     but very very slow since each pixel is processed individually.
     Redefined by some subclasses for more performance (D8Image)"

    |dH nDither
     greyValues
     dstIndex        "{Class: SmallInteger }"
     nextDst         "{Class: SmallInteger }"
     bytesPerMonoRow "{Class: SmallInteger }"
     monoBits
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"
     bitCnt          "{Class: SmallInteger }"
     byte            "{Class: SmallInteger }" |

    nDither := ditherMatrix size.
    dH := nDither / dW.

    w := width.
    h := height.

    bytesPerMonoRow := (w + 7) // 8.
    monoBits := ByteArray uninitializedNew:(bytesPerMonoRow * h).

    dstIndex := 1.

    self bitsPerPixel <= 12 ifTrue:[
        "/ fetch scaled brightness values outside of loop into a table;
        "/ use table-value in loop

        greyValues := self greyByteMapForRange:nDither.

        0 to:(h-1) do:[:y |
            nextDst := dstIndex + bytesPerMonoRow.
            byte := 0.
            bitCnt := 8.
            self valuesAtY:y from:0 to:(w-1) do:[:x :value |
%{
                int __dW = __intVal(dW);
                int __byte = __intVal(byte);
                int __dT;
                int __dstIdx;
                int __bitCnt = __intVal(bitCnt);
                int __grey;
                unsigned char *__greyValues = __ByteArrayInstPtr(greyValues)->ba_element;

                __grey = __greyValues[__intVal(value)];

                __dT = __ByteArrayInstPtr(ditherMatrix)
                            ->ba_element[__intVal(x) % __dW
                                         + (__intVal(y) % __intVal(dH)) * __dW];

                __byte = __byte << 1;
                if (__grey > __dT) {
                    __byte = __byte | 1;            /* white */
                }
                __bitCnt = __bitCnt - 1;
                if (__bitCnt == 0) {
                    __dstIdx = __intVal(dstIndex);
                    __ByteArrayInstPtr(monoBits)->ba_element[__dstIdx-1] = __byte;
                    __dstIdx = __dstIdx + 1;
                    dstIndex = __MKSMALLINT(__dstIdx);
                    __byte = 0;
                    __bitCnt = 8;
                }
                byte = __MKSMALLINT(__byte);
                bitCnt = __MKSMALLINT(__bitCnt);
%}.
                0
            ].
            bitCnt ~~ 8 ifTrue:[
                byte := byte bitShift:bitCnt.
                monoBits at:dstIndex put:byte.
            ].
            dstIndex := nextDst.
        ].
    ] ifFalse:[
        'Image [info]: slow ordered dither ..' infoPrintCR.

        0 to:(h-1) do:[:y |
            nextDst := dstIndex + bytesPerMonoRow.
            byte := 0.
            bitCnt := 8.
            self colorsAtY:y from:0 to:(w-1) do:[:x :clr |
                |dstClr grey dT|

                "/ get the colors grey value [0 .. 1]
                grey := clr brightness.

                "/ map into dither space [0 .. nDither]
                grey := (grey * (nDither)) rounded.

%{
                int __dW = __intVal(dW);
                int __byte = __intVal(byte);
                int __dT;
                int __dstIdx;
                int __bitCnt = __intVal(bitCnt);

                __dT = __ByteArrayInstPtr(ditherMatrix)
                            ->ba_element[__intVal(x) % __dW
                                         + (__intVal(y) % __intVal(dH)) * __dW];

                __byte = __byte << 1;
                if (__intVal(grey) > __dT) {
                    __byte = __byte | 1;            /* white */
                }
                __bitCnt = __bitCnt - 1;
                if (__bitCnt == 0) {
                    __dstIdx = __intVal(dstIndex);
                    __ByteArrayInstPtr(monoBits)->ba_element[__dstIdx-1] = __byte;
                    __dstIdx = __dstIdx + 1;
                    dstIndex = __MKSMALLINT(__dstIdx);
                    __byte = 0;
                    __bitCnt = 8;
                }
                byte = __MKSMALLINT(__byte);
                bitCnt = __MKSMALLINT(__bitCnt);
%}.
                0

"/                dT := ditherMatrix at:(x \\ dW) + (y \\ dH * dW) + 1.
"/
"/                byte := byte bitShift:1.
"/                grey < dT ifTrue:[
"/                    byte := byte bitOr:1.
"/                ].
"/                bitCnt := bitCnt - 1.
"/                bitCnt == 0 ifTrue:[
"/                    monoBits at:dstIndex put:byte.
"/                    dstIndex := dstIndex + 1.
"/                    byte := 0.
"/                    bitCnt := 8.
"/                ].

            ].
            bitCnt ~~ 8 ifTrue:[
                byte := byte bitShift:bitCnt.
                monoBits at:dstIndex put:byte.
            ].
            dstIndex := nextDst.
        ].
    ].
    ^ monoBits
!

stevensonArceDitheredMonochromeBits
    "return the bitmap for a dithered monochrome bitmap from the image.
     Works for any source depths / photometric.
     TODO: move to separate dither helper class"

    |dstIndex        "{Class: SmallInteger }"
     nextDst         "{Class: SmallInteger }"
     bytesPerMonoRow "{Class: SmallInteger }"
     monoBits greyValues
     errorArray
     errorArray1 errorArray2 errorArray3
     e t
     w               "{Class: SmallInteger }"
     h               "{Class: SmallInteger }"
     bitCnt          "{Class: SmallInteger }"
     byte            "{Class: SmallInteger }"
     grey
     xE              "{Class: SmallInteger }" |

    self depth > 12 ifTrue:[
        ^ self floydSteinbergDitheredMonochromeBits
    ].

    w := width.
    h := height.

    bytesPerMonoRow := (w + 7) // 8.
    monoBits := ByteArray uninitializedNew:(bytesPerMonoRow * h).

    errorArray := Array new:(w+6).
    errorArray1 := Array new:(w+6) withAll:0.
    errorArray2 := Array new:(w+6) withAll:0.
    errorArray3 := Array new:(w+6) withAll:0.

    dstIndex := 1.

    "/ fetch scaled brightness values outside of loop into a table;
    "/ use table-value in loop

    greyValues := self greyMapForRange:(255 * 1024).

    0 to:(h-1) do:[:y |
        nextDst := dstIndex + bytesPerMonoRow.
        byte := 0.
        bitCnt := 8.

        t := errorArray.
        errorArray := errorArray1.
        errorArray1 := errorArray2.
        errorArray2 := errorArray3.
        errorArray3 := t.

        errorArray3 atAllPut:0.

        self valuesAtY:y from:0 to:(w-1) do:[:x :pixel |
            |eP eD|

            "/ get the colors grey value [0 .. 1]
            grey := greyValues at:(pixel + 1).

            "/ adjust error
            xE := x + 3 + 1.
            grey := (grey + (errorArray at:xE)).

            byte := byte bitShift:1.
            grey > (127 * 1024) ifTrue:[
                byte := byte bitOr:1.      "/ white
                e := grey - (255 * 1024)
            ] ifFalse:[
                e := grey                  "/ black
            ].

            e ~= 0 ifTrue:[
                "/ distribute the error:
                "/                  XX    32
                "/         12    26    30    16
                "/            12    26    12
                "/          5    12    12     5

                eD := e.
                e := e // 200.

                eP := e * 32. eD := eD - eP.
                errorArray at:xE+2 put:(errorArray at:xE+2) + eP.

                eP := e * 30. eD := eD - eP.
                errorArray1 at:xE+1 put:(errorArray1 at:xE+1) + eP.

                eP := e * 16. eD := eD - eP.
                errorArray1 at:xE+3 put:(errorArray1 at:xE+3) + eP.

                eP := e * 26. eD := eD - eP.
                errorArray1 at:xE-1 put:(errorArray1 at:xE-1) + eP.

                eD := eD - eP.
                errorArray2 at:xE put:(errorArray2 at:xE) + eP.

                eP := e * 12. eD := eD - eP.
                errorArray1 at:xE-3 put:(errorArray1 at:xE-3) + eP.

                eD := eD - eP.
                errorArray2 at:xE-2 put:(errorArray2 at:xE-2) + eP.

                eD := eD - eP.
                errorArray2 at:xE+2 put:(errorArray2 at:xE+2) + eP.

                eD := eD - eP.
                errorArray3 at:xE-1 put:(errorArray3 at:xE-1) + eP.

                eD := eD - eP.
                errorArray3 at:xE+1 put:(errorArray3 at:xE+1) + eP.

                eP := e * 5. eD := eD - eP.
                errorArray3 at:xE-3 put:(errorArray3 at:xE-3) + eP.

                eP := eD.
                errorArray3 at:xE+3 put:(errorArray3 at:xE+3) + eP.
            ].

            bitCnt := bitCnt - 1.
            bitCnt == 0 ifTrue:[
                monoBits at:dstIndex put:byte.
                dstIndex := dstIndex + 1.
                byte := 0.
                bitCnt := 8.
            ].

        ].
        bitCnt ~~ 8 ifTrue:[
            byte := byte bitShift:bitCnt.
            monoBits at:dstIndex put:byte.
        ].

        dstIndex := nextDst.
    ].

    ^ monoBits

    "Created: 10.6.1996 / 12:38:35 / cg"
    "Modified: 10.6.1996 / 12:52:20 / cg"
! !

!Image methodsFor:'drawing'!

displayArcOrigin:origin corner:corner from:startAngle angle:angle withColor:aColor
    "draw a circle with some pixel value.
     By using a tempForm, we assure that the same pixel algorithm is used as in a window"

    self displayArcOrigin:origin corner:corner from:startAngle angle:angle withValue:(self valueFromColor:aColor)

    "
     |cm i|

     cm :=  Array with:Color white with:Color black with:Color red.

     i := Depth8Image extent:300@400 depth:8 palette:cm.
     i displayArcOrigin:100@100 corner:200@200 from:0 angle:90 withColor:Color red.
     i inspect.
    "
!

displayArcOrigin:origin corner:corner from:startAngle angle:angle withValue:aPixelValueOrNil
    "draw a circle with some pixel value.
     By using a tempForm, we assure that the same pixel algorithm is used as in a window.
     If aPixelValueOrNil is nil, the mask pixel will be set to 0 (transparent),
     otherwise to 1. (used by the bitmap editor)"

    |tempForm wI "{ Class: SmallInteger }"
     hI "{ Class: SmallInteger }" tempImage|

    wI := self width.
    hI := self height.

    tempForm := Form width:wI height:hI depth:1 onDevice:Screen current.
    tempForm
        paint:(Color colorId:1) on:(Color colorId:0);
        clear.
    tempForm displayArcOrigin:origin corner:corner from:startAngle angle:angle.

    tempImage := tempForm asImage.
    0 to:hI-1 do:[:yRun|
        0 to:wI-1 do:[:xRun|
            (tempImage pixelAtX:xRun y:yRun) == 1 ifTrue:[
                self atImageAndMask:xRun@yRun putValue:aPixelValueOrNil.
            ].
        ].
    ].
    tempForm destroy.
    tempImage close.
    self release. "/ device-image is no longer valid

    "
     |cm i|

     cm :=  Array with:Color white with:Color black with:Color red.

     i := Depth8Image extent:300@400 depth:8 palette:cm.
     i displayArcOrigin:100@100 corner:200@200 from:0 angle:90 withColor:Color red.
     i inspect.
    "
!

drawEllipse:aRectangle withColor:aColor
    "draw a circle with some pixel value.
     By using a tempForm, we assure that the same pixel algorithm is used as in a window"

    self drawEllipse:aRectangle withValue:(self valueFromColor:aColor)

    "
     |cm i|

     cm :=  Array with:Color white with:Color black with:Color red.

     i := Depth8Image extent:300@400 depth:8 palette:cm.
     i drawEllipse:(0@0 corner:80@100) withColor:Color red.
     i inspect.
    "
!

drawEllipse:aRectangle withValue:aPixelValueOrNil
    "draw a circle with some pixel value.
     By using a tempForm, we assure that the same pixel algorithm is used as in a window.
     If aPixelValueOrNil is nil, the mask pixel will be set to 0 (transparent),
     otherwise to 1. (used by the bitmap editor)"

    |tempForm xI "{ Class: SmallInteger }"
     yI "{ Class: SmallInteger }"
     wI "{ Class: SmallInteger }"
     hI "{ Class: SmallInteger }" tempImage|

    wI := aRectangle width.
    hI := aRectangle height.

    tempForm := Form width:wI height:hI depth:1 onDevice:Screen current.
    tempForm
        paint:(Color colorId:1) on:(Color colorId:0);
        clear.
    tempForm displayArcIn:(0@0 extent:wI@hI) from:0 angle:360.

    xI := aRectangle left.
    yI := aRectangle top.

    tempImage := tempForm asImage.
    0 to:hI-1 do:[:yRun|
        0 to:wI-1 do:[:xRun|
            (tempImage pixelAtX:xRun y:yRun) == 1 ifTrue:[
                self atImageAndMask: (xI+xRun)@(yI+yRun) putValue:aPixelValueOrNil.
            ].
        ].
    ].
    tempForm destroy.
    tempImage close.
    self release. "/ device-image is no longer valid

    "
     |cm i|

     cm :=  Array with:Color white with:Color black with:Color red.

     i := Depth8Image extent:300@400 depth:8 palette:cm.
     i drawEllipse:(0@0 corner:80@100) withColor:Color red.
     i inspect.
    "
!

drawLineFrom:startPoint to:endPoint withColor:aColorOrPixelValue
    "draw a line with some pixel value.
     This is in no way tuned, as normally, display-forms are used to draw.
     The only use for this is when we have to generate images in a headless webService
     (such as the HumanReadableImageGenerator)"

    |pixelValue|

    pixelValue := aColorOrPixelValue.
    pixelValue isInteger ifFalse:[
        pixelValue := self valueFromColor:aColorOrPixelValue
    ].
    self drawLineFrom:startPoint to:endPoint withValue:pixelValue

    "
     |i|

     i := Depth1Image extent:100@100 depth:1 palette:nil.
     i photometric:#blackIs0.
     i drawLineFrom:5@5 to:94@5 withColor:1.
     i drawLineFrom:94@5 to:94@94 withColor:1.
     i drawLineFrom:94@94 to:5@94 withColor:1.
     i drawLineFrom:5@94 to:5@5 withColor:1.
     i drawLineFrom:10@10 to:90@90 withColor:1.
     i drawLineFrom:90@10 to:10@90 withColor:1.
     i inspect.
    "
!

drawLineFrom:startPoint to:endPoint withValue:aPixelValueOrNil
    "draw a line with some pixel value.
     This is in no way tuned, as normally, display-forms are used to draw.
     The only use for this is when we have to generate images in a headless webService
     (such as the HumanReadableImageGenerator).
     If aPixelValueOrNil is nil, the mask pixel will be set to 0 (transparent),
     otherwise to 1. (used by the bitmap editor)"

    |x0 x1 y0 y1 t steep deltax deltay error deltaerr ystep y|

    x0 := startPoint x.
    y0 := startPoint y.
    x1 := endPoint x.
    y1 := endPoint y.

    steep := (y1 - y0) abs > (x1 - x0) abs.
    steep ifTrue:[
        t := x0. x0 := y0. y0 := t.
        t := x1. x1 := y1. y1 := t.
    ].
    x0 > x1 ifTrue:[
        t := x0. x0 := x1. x1 := t.
        t := y0. y0 := y1. y1 := t.
    ].

    deltax := x1 - x0.
    deltay := (y1 - y0) abs.

    deltax == 0 ifTrue:[
        y0 to: y1 do:[:y |
            self atImageAndMask:x0@y putValue:aPixelValueOrNil.
        ].
        ^ self.
    ].
    deltay == 0 ifTrue:[
        x0 to: x1 do:[:x |
            self atImageAndMask:x@y0 putValue:aPixelValueOrNil.
        ].
        ^ self.
    ].

    error := 0.
    deltaerr := deltay / deltax.
    y := y0.
    y0 < y1 ifTrue:[ ystep := 1 ] ifFalse:[ ystep := -1 ].

    x0 to: x1 do:[:x |
        steep ifTrue:[
            self atImageAndMask:y@x putValue:aPixelValueOrNil.
        ] ifFalse:[
            self atImageAndMask:x@y putValue:aPixelValueOrNil.
        ].
        error := error + deltaerr.
        error >= 0.5 ifTrue:[
            y := y + ystep.
            error := error - 1.
        ]
    ].
    self release. "/ device-image is no longer valid

    "
     |i|

     i := Depth1Image extent:100@100 depth:1 palette:nil.
     i photometric:#blackIs0.
     i drawLineFrom:5@5 to:94@5 withColor:1.
     i drawLineFrom:94@5 to:94@94 withColor:1.
     i drawLineFrom:94@94 to:5@94 withColor:1.
     i drawLineFrom:5@94 to:5@5 withColor:1.
     i drawLineFrom:10@10 to:90@90 withColor:1.
     i drawLineFrom:90@10 to:10@90 withColor:1.
     i inspect.
    "
!

drawRectangle: aRectangle withColor:aColor
    "draw a rectangle with some pixel value.
     By using #atImageAndMask:put: it also works on images with mono masks."

    self drawRectangle:aRectangle withValue:(self valueFromColor:aColor)

    "
     |i|

     i := Depth1Image extent:100@100 depth:1 palette:nil.
     i photometric:#blackIs0.
     i drawRectangle:(10@10 corner:90@90) withColor:1.
     i inspect.
    "
!

drawRectangle: aRectangle withValue:aPixelValueOrNil
    "draw a rectangle with some pixel value.
     By using #atImageAndMask:put: it also works on images with mono masks.
     If aPixelValueOrNil is nil, the mask pixel will be set to 0 (transparent),
     otherwise to 1. (used by the bitmap editor)"

    |xI "{ Class: SmallInteger }"
     yI "{ Class: SmallInteger }"
     wI "{ Class: SmallInteger }"
     hI "{ Class: SmallInteger }"|

    xI := aRectangle left.
    yI := aRectangle top.
    wI := aRectangle width.
    hI := aRectangle height.

    xI to:xI+wI-1 do:[:xRun|
        self atImageAndMask: xRun@yI put:aPixelValueOrNil.
        self atImageAndMask: xRun@(yI+hI-1) put:aPixelValueOrNil
    ].
    yI+1 to:yI+hI-2 do:[:yRun|
        self atImageAndMask: xI@yRun put:aPixelValueOrNil.
        self atImageAndMask: xI+wI-1@yRun put:aPixelValueOrNil
    ].
    self release. "/ device-image is no longer valid

    "
     |i|

     i := Depth1Image extent:100@100 depth:1 palette:nil.
     i photometric:#blackIs0.
     i drawRectangle:(10@10 corner:90@90) withColor:1.
     i inspect.
    "
!

fillAntiAliasedArc:origin radius:r from:startAngle angle:angle withColor:aColor colorDictionary:colorDictionary blendStart:blendStart
    "draw a circle with some pixel value.
     By using a tempForm, we assure that the same pixel algorithm is used as in a window"

    |tempForm wI "{ Class: SmallInteger }"
     hI "{ Class: SmallInteger }"
     colorValue tempImage|

    wI := self width.
    hI := self height.

    tempForm := Form width:wI height:hI depth:1 onDevice:Screen current.
    tempForm
        paint:(Color colorId:1) on:(Color colorId:0);
        clear.
    tempForm fillArc:origin radius:r from:startAngle angle:angle.

    colorValue := self valueFromColor:aColor.
    tempImage := tempForm asImage.

    0 to:hI-1 do:[:yRun|
        0 to:wI-1 do:[:xRun|
            (tempImage pixelAtX:xRun y:yRun) == 1 ifTrue:[
                self atImageAndMask:xRun@yRun putValue:colorValue.

                #(left right) do:[:aHorizontal |
                    #(top bottom) do:[:aVertical |
                        self vitualAntiAliasedAlongXvertical:aVertical horizontal:aHorizontal form:tempImage color:aColor xRun:xRun yRun:yRun colorDictionary:colorDictionary blendStart:blendStart.
                        self vitualAntiAliasedAlongYhorizontal:aHorizontal vertical:aVertical form:tempImage color:aColor xRun:xRun yRun:yRun colorDictionary:colorDictionary blendStart:blendStart.
                    ].
                ].
            ].
        ].
    ].
    tempForm destroy.
    tempImage close.
    self release. "/ device-image is no longer valid


    "
        |colorMap aaImgArray|

        colorMap := Array with:Color white with:Color black with:Color red with:Color blue.

        aaImgArray := Depth8Image extent:200@200 depth:8 antiAliasedPalette:colorMap bgColor:Color white.
        aaImgArray last fillAntiAliasedArc:105@95 radius:80 from:0 angle:90 withColor:Color red
            colorDictionary:aaImgArray first
            blendStart:aaImgArray second.
        aaImgArray last fillAntiAliasedArc:100@100 radius:80 from:90 angle:270 withColor:Color blue
            colorDictionary:aaImgArray first
            blendStart:aaImgArray second.

        aaImgArray last inspect.
    "
!

fillArc:origin radius:r from:startAngle angle:angle withColor:aColorOrIndex
    "draw a circle with some pixel value.
     By using a tempForm, we assure that the same pixel algorithm is used as in a window"

    |tempForm tempImage
     wI "{ Class: SmallInteger }"
     hI "{ Class: SmallInteger }"
     colorValue|

    wI := self width.
    hI := self height.

    tempForm := Form width:wI height:hI depth:1 onDevice:Screen current.
    tempForm
        paint:(Color colorId:1) on:(Color colorId:0);
        clear.
    tempForm fillArc:origin radius:r from:startAngle angle:angle.

    aColorOrIndex isInteger ifTrue:[
        colorValue := aColorOrIndex.
    ] ifFalse:[
        colorValue := self valueFromColor:aColorOrIndex.
    ].

    tempImage := tempForm asImage.
    0 to:hI-1 do:[:yRun|
        0 to:wI-1 do:[:xRun|
            (tempImage pixelAtX:xRun y:yRun) == 1 ifTrue:[
                self atImageAndMask:xRun@yRun putValue:colorValue.
            ].
        ].
    ].
    tempForm destroy.
    tempImage close.
    self release. "/ device-image is no longer valid

    "
     |cm i|

     cm :=  Array with:Color white with:Color black with:Color red with:Color blue.

     i := Depth8Image extent:200@200 depth:8 palette:cm.
     i fillArc:105@95 radius:80 from:0 angle:90 withColor:Color red.
     i fillArc:100@100 radius:80 from:90 angle:270 withColor:Color blue.
     i inspect.
    "
!

fillEllipse:aRectangle withColor:aColor
    "draw a circle with some pixel value.
     By using a tempForm, we assure that the same pixel algorithm is used as in a window"

    self fillEllipse:aRectangle withValue:(self valueFromColor:aColor)

    "
     |cm i|

     cm :=  Array with:Color white with:Color black with:Color red.

     i := Depth8Image extent:100@100 depth:8 palette:cm.
     i fillEllipse:(0@0 corner:80@100) withColor:Color red.
     i inspect.
    "
!

fillEllipse:aRectangle withValue:aPixelValueOrNil
    "draw a circle with some pixel value.
     By using a tempForm, we assure that the same pixel algorithm is used as in a window.
     If aPixelValueOrNil is nil, the mask pixel will be set to 0 (transparent),
     otherwise to 1. (used by the bitmap editor)"

    |tempForm xI "{ Class: SmallInteger }"
     yI "{ Class: SmallInteger }"
     wI "{ Class: SmallInteger }"
     hI "{ Class: SmallInteger }" tempImage|

    wI := aRectangle width.
    hI := aRectangle height.

    tempForm := Form width:wI height:hI depth:1 onDevice:Screen current.
    tempForm
        paint:(Color colorId:1) on:(Color colorId:0);
        clear.
    tempForm fillArcIn:(0@0 extent:wI@hI) from:0 angle:360.

    xI := aRectangle left.
    yI := aRectangle top.

    tempImage := tempForm asImage.
    0 to:hI-1 do:[:yRun|
        0 to:wI-1 do:[:xRun|
            (tempImage pixelAtX:xRun y:yRun) == 1 ifTrue:[
                self atImageAndMask:(xI+xRun)@(yI+yRun) putValue:aPixelValueOrNil.
            ].
        ].
    ].
    tempForm destroy.
    tempImage close.
    self release. "/ device-image is no longer valid

    "
     |cm i|

     cm :=  Array with:Color white with:Color black with:Color red.

     i := Depth8Image extent:300@400 depth:8 palette:cm.
     i fillEllipse:(0@0 corner:80@100) withColor:Color red.
     i inspect.
    "
!

fillRectangle:aRectangle withColor:aColor
    self
        fillRectangle:aRectangle
        withValue:(self valueFromColor:aColor)
!

fillRectangle:aRectangle withValue:aPixelValueOrNil
    "fill a rectangular area with some pixel value.
     May be redefined in concrete subclasses for more performance, if req'd.
     If aPixelValueOrNil is nil, the mask pixel will be set to 0 (transparent),
     otherwise to 1. (used by the bitmap editor)"

    self
        fillRectangleX:aRectangle left y:aRectangle top
        width:aRectangle width height:aRectangle height
        withValue:aPixelValueOrNil
!

fillRectangleX:x y:y width:w height:h with:aColor
    "fill a rectangular area with a aColor"

    self fillRectangleX:x y:y width:w height:h withValue:(self valueFromColor:aColor)
!

fillRectangleX:x y:y width:w height:h withValue:aPixelValueOrNil
    "fill a rectangular area with some pixel value.
     May be redefined in concrete subclasses for more performance, if req'd.
     If aPixelValueOrNil is nil, the mask pixel will be set to 0 (transparent),
     otherwise to 1. (used by the bitmap editor)"

    |xI "{ Class: SmallInteger }"
     yI "{ Class: SmallInteger }"
     wI "{ Class: SmallInteger }"
     hI "{ Class: SmallInteger }"
     p|

    xI := x.
    yI := y.
    wI := w.
    hI := h.
    p := Point new.

    yI to:yI+hI-1 do:[:yRun |
        xI to:xI+wI-1 do:[:xRun |
            p x:xRun y:yRun.
            self atImageAndMask:p putValue:aPixelValueOrNil.
        ]
    ].
    self release. "/ device-image is no longer valid

    "Created: 22.4.1997 / 14:02:14 / cg"
    "Modified: 24.4.1997 / 17:24:58 / cg"
!

floodFillAt: aPoint withColor: aColor
    "fill a area with aColor like a flood up to surrounded pixels having different colors.
     By using #atImageAndMask:put: it also works on images with mono masks."

    self floodFillAt:aPoint withValue:(self valueFromColor:aColor)

"/    |surroundingPixelsOfDo detectedPixel processPixelToFill
"/     allDetectedPixelCoordinates enumerateDetectedPixelsAndDo
"/     toDo idx pixel w h|
"/
"/    w := self width.
"/    h := self height.
"/
"/    surroundingPixelsOfDo :=
"/        [:pX :pY :fn |
"/            |nX nY|
"/
"/            nX := pX + 1.
"/            nY := pY + 1.
"/            (nY < h) ifTrue: [fn value:pX value:nY].
"/            (pY > 0) ifTrue: [fn value:pX value:(pY - 1)].
"/            (nX < w) ifTrue: [fn value:nX value:pY].
"/            (pX > 0) ifTrue: [fn value:(pX - 1) value:pY].
"/        ].
"/
"/    enumerateDetectedPixelsAndDo :=
"/        [:detectedPixels :action |
"/            |idx|
"/
"/            idx := 1.
"/            0 to:h-1 do:[:y |
"/                0 to:w-1 do:[:x |
"/                    (detectedPixels at:idx) ifTrue:[
"/                        action value:x value:y
"/                    ].
"/                    idx := idx + 1.
"/                ].
"/            ].
"/        ].
"/
"/    processPixelToFill := [:spX :spY |
"/            |sp idx|
"/
"/            ((self pixelAtX:spX y:spY) == detectedPixel and: [mask isNil or:[(mask pixelAtX:spX y:spY) == 1]])
"/            ifTrue: [
"/                idx := 1 + spX + (spY * w).
"/                (allDetectedPixelCoordinates at:idx) ifFalse:[
"/                    allDetectedPixelCoordinates at:idx put:true.
"/                    toDo add:spX @ spY.
"/                ].
"/            ]
"/        ].
"/
"/    (mask notNil and: [(mask pixelAt:aPoint) == 0]) ifTrue:[
"/        allDetectedPixelCoordinates := mask floodFillAt: aPoint withColor: Color white.
"/        enumerateDetectedPixelsAndDo
"/                value:allDetectedPixelCoordinates
"/                value:[:x :y | self atImageAndMask:(x@y) put: aColor].
"/        ^ allDetectedPixelCoordinates
"/    ].
"/
"/    detectedPixel := self pixelAt: aPoint.
"/
"/    allDetectedPixelCoordinates := BooleanArray new:(w * h).
"/    toDo := OrderedCollection new:1000.
"/    allDetectedPixelCoordinates at:(1 + aPoint x + (aPoint y * w)) put:true.
"/    toDo add:aPoint.
"/
"/    [toDo notEmpty] whileTrue:[
"/        |p|
"/
"/        p := toDo removeFirst.
"/        surroundingPixelsOfDo value:p x value:p y value:processPixelToFill.
"/    ].
"/
"/    idx := 1.
"/    aColor redByte notNil ifTrue:[
"/        pixel := self valueFromColor:aColor.
"/    ].
"/
"/    pixel isNil ifTrue:[
"/        enumerateDetectedPixelsAndDo
"/                value:allDetectedPixelCoordinates
"/                value:[:x :y | mask pixelAtX:x y:y put:0].
"/    ] ifFalse:[
"/        enumerateDetectedPixelsAndDo
"/                value:allDetectedPixelCoordinates
"/                value:[:x :y | self pixelAtX:x y:y put:pixel].
"/    ].
"/    ^ allDetectedPixelCoordinates

    "Modified: / 29.7.1998 / 03:09:16 / cg"
!

floodFillAt:aPoint withValue:aPixelValueOrNil
    "fill a area with aColor like a flood up to surrounded pixels having different colors.
     By using #atImageAndMask:put: it also works on images with mono masks."

    |surroundingPixelsOfDo detectedPixel detectedMask processPixelToFill
     allDetectedPixelCoordinates enumerateDetectedPixelsAndDo
     toDo w h drawAction|

    w := self width.
    h := self height.

    surroundingPixelsOfDo :=
        [:pX :pY :fn |
            |nX nY|

            nX := pX + 1.
            nY := pY + 1.
            (nY < h) ifTrue: [fn value:pX value:nY].
            (pY > 0) ifTrue: [fn value:pX value:(pY - 1)].
            (nX < w) ifTrue: [fn value:nX value:pY].
            (pX > 0) ifTrue: [fn value:(pX - 1) value:pY].
        ].

    enumerateDetectedPixelsAndDo :=
        [:detectedPixels :action |
            |idx|

            idx := 1.
            0 to:h-1 do:[:y |
                0 to:w-1 do:[:x |
                    (detectedPixels at:idx) ifTrue:[
                        action value:x value:y
                    ].
                    idx := idx + 1.
                ].
            ].
        ].

    processPixelToFill :=
        [:spX :spY |
            |samePixel idx|

            mask isNil ifTrue:[
                samePixel := (self pixelAtX:spX y:spY) == detectedPixel
            ] ifFalse:[
                detectedMask == 0 ifTrue:[
                    samePixel := (mask pixelAtX:spX y:spY) == 0
                ] ifFalse:[
                    samePixel := ((self pixelAtX:spX y:spY) == detectedPixel)
                                 and:[ (mask pixelAtX:spX y:spY) == detectedMask ]
                ].
            ].
            samePixel ifTrue: [
                idx := 1 + spX + (spY * w).
                (allDetectedPixelCoordinates at:idx) ifFalse:[
                    allDetectedPixelCoordinates at:idx put:true.
                    toDo add:spX @ spY.
                ].
            ]
        ].

"/    (mask notNil and: [(mask pixelAt:aPoint) == 0]) ifTrue:[
"/        allDetectedPixelCoordinates := mask floodFillAt: aPoint withColor: Color white.
"/        enumerateDetectedPixelsAndDo
"/                value:allDetectedPixelCoordinates
"/                value:[:x :y | self atImageAndMask:(x@y) putValue:aPixelValueOrNil].
"/        ^ allDetectedPixelCoordinates
"/    ].

    detectedPixel := self pixelAt: aPoint.
    mask isNil ifTrue:[
        detectedMask := 1
    ] ifFalse:[
        detectedMask := mask pixelAt: aPoint.
    ].

    allDetectedPixelCoordinates := BooleanArray new:(w * h).
    toDo := OrderedCollection new:1000.
    allDetectedPixelCoordinates at:((aPoint y * w) + aPoint x + 1) put:true.
    toDo add:aPoint.

    [toDo notEmpty] whileTrue:[
        |p|

        p := toDo removeLast.
        surroundingPixelsOfDo value:p x value:p y value:processPixelToFill.
    ].

    aPixelValueOrNil isNil ifTrue:[
        drawAction := [:x :y |
                               mask pixelAtX:x y:y put:0.
                               self pixelAtX:x y:y put:0.
                      ].
    ] ifFalse:[
        drawAction := [:x :y |
                                mask notNil ifTrue:[
                                    mask pixelAtX:x y:y put:1.
                                ].
                                self pixelAtX:x y:y put:aPixelValueOrNil].
    ].

    enumerateDetectedPixelsAndDo
        value:allDetectedPixelCoordinates
        value:drawAction.

    self release. "/ device-image is no longer valid
    ^ allDetectedPixelCoordinates

    "Modified: / 29-07-1998 / 03:09:16 / cg"
    "Modified (format): / 30-01-2017 / 20:57:36 / stefan"
!

rectangle: aRectangle withColor:aColor
    <resource: #obsolete>
    "draw a rectangle with some pixel value.
    By using #atImageAndMask:put: it also works on images with mono masks."

    self obsoleteMethodWarning.
    self drawRectangle: aRectangle withColor:aColor


! !

!Image methodsFor:'enumerating'!

atY:y from:x1 to:x2 do:aBlock
    "perform aBlock for each pixel from x1 to x2 in row y.
     The block is passed the color at each pixel.
     The code here provides a generic and slow implementation, and
     should be redefined in concrete subclasses, to avoid some processing
     when going from pixel to pixel (i.e. the byte-index and mask computations
     and also the color allocation)."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #colorsAtY:from:to:do:'.
    self colorsAtY:y from:x1 to:x2 do:aBlock

    "Modified: 7.6.1996 / 19:13:30 / cg"
!

colorsAtX:x from:y1 to:y2 do:aBlock
    "perform aBlock for each pixel from y1 to y2 in col x.
     The block is passed the color at each pixel.
     The code here provides a generic and slow implementation, and
     should be redefined in concrete subclasses, to avoid some processing
     when going from pixel to pixel (i.e. the byte-index and mask computations
     and also the color allocation)."

    |yStart "{Class: SmallInteger }"
     yEnd   "{Class: SmallInteger }"|

    yStart := y1.
    yEnd := y2.
    yStart to:yEnd do:[:yRun |
        aBlock value:yRun value:(self colorAtX:x y:yRun)
    ]
!

colorsAtY:y from:x1 to:x2 do:aBlock
    "perform aBlock for each pixel from x1 to x2 in row y.
     The block is passed the color at each pixel.
     The code here provides a generic and slow implementation, and
     should be redefined in concrete subclasses, to avoid some processing
     when going from pixel to pixel (i.e. the byte-index and mask computations
     and also the color allocation)."

    |xStart "{Class: SmallInteger }"
     xEnd   "{Class: SmallInteger }"|

    xStart := x1.
    xEnd := x2.
    xStart to:xEnd do:[:xRun |
        aBlock value:xRun value:(self colorAtX:xRun y:y)
    ]

    "Created: / 7.6.1996 / 19:12:51 / cg"
    "Modified: / 30.9.1998 / 22:14:16 / cg"
!

colorsFromX:xStart y:yStart toX:xEnd y:yEnd do:aBlock
    "perform aBlock for each color in a rectangular area of the image.
     Notice that x and y coordinates start at 0@0 for the upper left corner.
     The block is passed the x and y coordinates and pixelValue at each pixel.
     The code here provides a generic and slow implementation, and
     should be redefined in concrete subclasses, to avoid some processing
     when going from pixel to pixel (i.e. the byte-index and mask computations,
     and especially, the color allocations)."

    |yS "{Class: SmallInteger }"
     yE "{Class: SmallInteger }"|

    yS := yStart.
    yE := yEnd.

    yS to:yE do:[:yRun |
        self colorsAtY:yRun from:xStart to:xEnd do:[:xRun :color |
            aBlock value:xRun value:yRun value:color
        ]
    ]

    "Modified: 11.7.1996 / 19:50:47 / cg"
!

valueAtY:y from:x1 to:x2 do:aBlock
    "perform aBlock for each pixelValue from x1 to x2 in row y.
     Obsolete - remains for backward compatibility."

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #valuesAtY:from:to:do:'.
    self valuesAtY:y from:x1 to:x2 do:aBlock

    "Modified: 7.6.1996 / 19:11:06 / cg"
!

valuesAtY:y from:x1 to:x2 do:aBlock
    "WARNING: for now, this enumerates pixel values
     (backward compatibility with ST/X)
     In the future, this will enumerate colors
     Use #pixelAtT:from:to:do: - for future compatibility.

     perform aBlock for each pixelValue from x1 to x2 in row y.
     Notice that x and y coordinates start at 0@0 for the upper left corner.
     The block is passed the x coordinate and the pixelValue at each pixel.
     (see also Image>>atY:from:to:do:).
     The code here provides a generic and slow implementation, and
     should be redefined in concrete subclasses, to avoid some processing
     when going from pixel to pixel (i.e. the byte-index and mask computations)."

    |xStart "{Class: SmallInteger }"
     xEnd   "{Class: SmallInteger }"|

    xStart := x1.
    xEnd := x2.
    xStart to:xEnd do:[:xRun |
        aBlock value:xRun value:(self pixelAtX:xRun y:y)
    ]

    "Created: 7.6.1996 / 19:09:51 / cg"
    "Modified: 24.4.1997 / 16:55:38 / cg"
!

valuesFromX:xStart y:yStart toX:xEnd y:yEnd do:aBlock
    "perform aBlock for each pixelValue in a rectangular area of the image.
     Notice that x and y coordinates start at 0@0 for the upper left corner.
     The block is passed the x and y coordinates and pixelValue at each pixel.
     The code here provides a generic and slow implementation, and
     should be redefined in concrete subclasses, to avoid some processing
     when going from pixel to pixel (i.e. the byte-index and mask computations)."

    |yS "{Class: SmallInteger }"
     yE "{Class: SmallInteger }"|

    yS := yStart.
    yE := yEnd.
    yS to:yE do:[:yRun |
        self valuesAtY:yRun from:xStart to:xEnd do:[:xRun :pixel |
            aBlock value:xRun value:yRun value:pixel
        ]
    ]

    "Modified: / 07-06-1996 / 19:09:29 / cg"
    "Modified: / 31-01-2017 / 14:46:26 / stefan"
! !

!Image methodsFor:'finalization'!

finalizationLobby
    "answer the registry used for finalization.
     Images have their own Registry"

    ^ Lobby
!

finalize
    "some Image has been collected - nothing to do.

     The only reason we register Images is, that we can release
     their device resources when a GraphicsDevice is closed.

     (#releaseResourcesOnDevice: at class side)."
! !

!Image methodsFor:'image manipulations'!

applyPixelValuesTo:pixelFunctionBlock in:aRectangle into:newImage
    "helper for withPixelFunctionAppliedToValues:
     enumerate pixelValues and evaluate the block for each.
     Could be redefined by subclasses for better performance."

    |w   "{Class: SmallInteger }"
     h   "{Class: SmallInteger }"
     x0  "{Class: SmallInteger }"
     y0  "{Class: SmallInteger }"
     y   "{Class: SmallInteger }"
     newPixel newPixelRow pixelRow|

    x0 := aRectangle left.
    y0 := aRectangle top.
    w := aRectangle width.
    h := aRectangle height.

    newPixelRow := Array new:w.
    pixelRow := self pixelArraySpecies new:width.

    (x0 = 0 and:[w = self width]) ifTrue:[
        "/ slightly faster
        y := y0.
        h timesRepeat:[
            self rowAt:y into:pixelRow.
            1 to:w do:[:runCol |
                newPixel := pixelFunctionBlock
                                value:self
                                value:(pixelRow at:runCol)
                                value:(runCol-1)
                                value:y.
                newPixelRow at:runCol put:newPixel.
            ].
            newImage rowAt:y putAll:newPixelRow.
            y := y + 1.
        ].
        ^ self.
    ].

    y := y0.
    h timesRepeat:[
        self rowAt:y into:pixelRow.
        1 to:w do:[:runCol |
            newPixel := pixelFunctionBlock
                            value:self
                            value:(pixelRow at:runCol+x0)
                            value:(runCol+x0-1)
                            value:y.
            newPixelRow at:runCol put:newPixel.
        ].
        pixelRow replaceFrom:x0+1 to:x0+1+w-1 with:newPixelRow startingAt:1.
        newImage rowAt:y putAll:pixelRow.
        y := y + 1.
    ].

    "Modified: 24.4.1997 / 16:18:31 / cg"
!

applyPixelValuesTo:pixelFunctionBlock into:newImage
    "helper for withPixelFunctionAppliedToValues:
     enumerate pixelValues and evaluate the block for each."

    ^ self
        applyPixelValuesTo:pixelFunctionBlock
        in:(0@0 corner:width@height)
        into:newImage
!

blendWith:aColor
    "return a new image which is blended with some color.
     The receiver must be a palette image (currently).
     CAVEAT: this only works with palette images (i.e. not for rgb or greyScale).
     CAVEAT: Need an argument, which specifies by how much it should be lighter."

     ^ self
        copyWithColorMapProcessing:[:clr | clr blendWith:aColor]

    "
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') blendWith:Color red) inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') blendWith:Color white) inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') blendWith:Color black) inspect
    "

    "Modified: 24.4.1997 / 18:31:23 / cg"
!

colorMapProcessing:aBlock
    "a helper for all kinds of colormap manipulations.
     The argument, aBlock is called for every colormap entry,
     and the returned value will replace the original entry in the map.
     This will fail for non-palette images.
     See examples in Image>>copyWithColorMapProcessing:"

    |nColors "{ Class: SmallInteger }"|

    colorMap isNil ifTrue:[
        self colorsFromX:0 y:0 toX:(self width-1) y:(self height-1) do:[:x :y :clr |
            self colorAtX:x y:y put:(aBlock value:clr)
        ].
        ^ self
    ].

    nColors := colorMap size.
    1 to:nColors do:[:index |
        |clr|

        clr := colorMap at:index.
        clr notNil ifTrue:[
            colorMap at:index put:(aBlock value:clr)
        ]
    ]

    "Modified: 23.4.1996 / 11:13:55 / cg"
!

copyWithColorMapProcessing:aBlock
    "a helper to create & return new images based on the receiver with
     some colorMap processing. The receiver is copied, and the copied images
     colormap is modified by replacing entries with the result of the processing block,
     which is called with the original color values. The block is supposed to return
     a color.
     CAVEAT: this only works with palette images (i.e. not for rgb or greyScale)"

    |newImage|

    self colorMap isNil ifTrue:[
        ^ self withPixelFunctionApplied:[:orig :clr :x :y | aBlock  value:clr]
"/        self error:'no colormap in image'.
"/        ^ nil
    ].

    "
     the code below manipulates the colormap.
     For non-palette images, special code is required
    "
    newImage := self copy.
    newImage colorMapProcessing:aBlock.
    ^ newImage

    "
     leave red component only:

     (Image fromFile:'goodies/bitmaps/gifImages/claus.gif')
        copyWithColorMapProcessing:[:clr | Color red:(clr red) green:0 blue:0]
    "

    "
     make it reddish:

     |img imgYellow imgGreen imgBlue|
     img := (Image fromFile:'../../../expeccoNET/server/data/images/styles/eXept/defects.gif').
     imgYellow := img copyWithColorMapProcessing:[:clr | Color hue:(clr hue ? 0 + 60) light:clr light saturation:clr saturation].
     imgGreen := img copyWithColorMapProcessing:[:clr | Color hue:(clr hue ? 0 + 120) light:clr light saturation:clr saturation].
     imgBlue := img copyWithColorMapProcessing:[:clr | Color hue:(clr hue ? 0 + 240) light:clr light saturation:clr saturation].
     imgBlue
    "

    "
     make it reddish:

     (Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif')
        copyWithColorMapProcessing:[:clr | Color red:((clr red * 2) min:100) green:clr green blue:clr blue]
    "

    "
     invert:

     (Image fromFile:'bitmaps/gifImages/claus.gif')
        copyWithColorMapProcessing:[:clr | Color red:(100 - clr red) green:(100 - clr green) blue:(100 - clr green)]
    "

    "
     lighter:

     (Image fromFile:'bitmaps/gifImages/claus.gif')
        copyWithColorMapProcessing:[:clr | |r g b|
                                                r := clr red.  g := clr green.  b := clr blue.
                                                Color red:(r + (100-r//2))
                                                      green:(g + (100-g//2))
                                                      blue:(b + (100-b//2))]
    "

    "
     darker:

     (Image fromFile:'bitmaps/gifImages/claus.gif')
        copyWithColorMapProcessing:[:clr | Color red:(clr red//2) green:(clr green // 2) blue:(clr blue // 2)]
    "

    "Modified: 24.4.1997 / 18:28:05 / cg"
!

createMask
    |maskArray bytesPerMaskRow|

    bytesPerMaskRow := (width+7) // 8.

    maskArray := ByteArray new:(bytesPerMaskRow * height) withAll:2r11111111.
    mask := ImageMask width:width height:height fromArray:maskArray.
    ^ mask
!

darkened
    "return a new image which is slightly darker than the receiver.
     The receiver must be a palette image (currently).
     CAVEAT: this only works with palette images (i.e. not for rgb or greyScale).
     CAVEAT: Need an argument, which specifies by how much it should be darker."

     ^ self copyWithColorMapProcessing:[:clr | clr darkened]

    "
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') darkened inspect
    "

    "Modified: / 24-11-2010 / 11:06:58 / cg"
!

easyRotateBitsInto:destinationImage angle:degrees
    "helper for rotation - does the actual pixel shuffling.
     by degrees clockwise. Here, only 90, 180 and 270 degrees
     are implemented. Hard angles are done in #hardRotate:.
     The code here is depth-independent (but not too fast);
     can be redefined in subclasses for more performance"

    |w  "{Class: SmallInteger }"
     h  "{Class: SmallInteger }" 
     pixelMover|

    w := width - 1.
    h := height - 1.

    degrees = 90 ifTrue:[
        pixelMover := [:col :row :pixel | destinationImage pixelAtX:(h-row) y:col put:pixel].    
    ] ifFalse:[
        degrees = 180 ifTrue:[
            pixelMover := [:col :row :pixel | destinationImage pixelAtX:(w-col) y:(h-row) put:pixel].    
        ] ifFalse:[
            degrees = 270 ifTrue:[
                pixelMover := [:col :row :pixel | destinationImage pixelAtX:row y:(w-col) put:pixel].    
            ] ifFalse:[
                ^ self
            ].
        ].
    ].    
    self valuesFromX:0 y:0 toX:w y:h do:pixelMover.
    ^ self.

    "
     |i|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     (i rotated:45) inspect.
     (i rotated:90) inspect.
     (i rotated:180) inspect.
     (i rotated:270) inspect.
    "
    "
     |i|
     i := Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif'.
     i := Depth24Image fromImage:i.
     Time millisecondsToRun:[ 100 timesRepeat:[ i rotated:90 ] ]
    "
    "
     |i|
     i := Image fromScreen.
     Time millisecondsToRun:[ 20 timesRepeat:[ i rotated:90 ] ]
    "
    
    "Created: 23.4.1997 / 14:36:45 / cg"
    "Modified: 24.4.1997 / 17:26:26 / cg"
!

flipHorizontal
    "destructively inplace horizontal flip"

    |h  "{Class: SmallInteger }"
     pixelArray|

    h := height - 1.

    pixelArray := self pixelArraySpecies new:width.

    0 to:h do:[:row |
        self rowAt:row into:pixelArray.
        pixelArray reverse.
        self rowAt:row putAll:pixelArray.
    ].

    mask notNil ifTrue:[
        mask flipHorizontal
    ].

    "/ flush device info
    self release

    "
     (Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') flipHorizontal inspect
    "

    "Modified: 24.4.1997 / 18:29:13 / cg"
!

flipVertical
    "inplace vertical flip"

    |h           "{Class: SmallInteger }"
     bytesPerRow "{Class: SmallInteger }"
     buffer
     indexLow    "{Class: SmallInteger }"
     indexHi     "{Class: SmallInteger }"
     bytes|

    bytes := self bits.
    bytesPerRow := self bytesPerRow.
    buffer := ByteArray new:bytesPerRow.

    h := height - 1.

    indexLow := 1.
    indexHi := bytesPerRow * h + 1.

    0 to:(h // 2) do:[:row |
        buffer replaceFrom:1 to:bytesPerRow with:bytes startingAt:indexLow.
        bytes replaceFrom:indexLow to:(indexLow + bytesPerRow - 1) with:bytes startingAt:indexHi.
        bytes replaceFrom:indexHi to:(indexHi + bytesPerRow - 1) with:buffer startingAt:1.
        indexLow := indexLow + bytesPerRow.
        indexHi := indexHi - bytesPerRow.
    ].
    mask notNil ifTrue:[
        mask flipVertical
    ].
    "flush device info"
    self release

    "
     (Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') flipVertical inspect
    "

    "Modified: 24.4.1997 / 18:29:36 / cg"
!

hardAntiAliasedMagnifiedBy:scalePoint
    "return a new image magnified and antiAliased by scalePoint, aPoint.
     This converts into a depth24Image before doing the antiAlias-magnify.
     It is definitely slower than the non antiAliasing/integral magnification methods."

    ^ (Depth24Image fromImage:self)
        hardAntiAliasedMagnifiedBy:scalePoint

    "Modified: 2.6.1997 / 13:19:57 / cg"
    "Created: 2.6.1997 / 15:53:34 / cg"
!

hardMagnifiedBy:scalePoint
    "return a new image magnified by scalePoint, aPoint.
     This is the general magnification method, handling non-integral values.
     It is slower than the integral magnification method."

    |mX
     mY
     newWidth  "{ Class: SmallInteger }"
     newHeight "{ Class: SmallInteger }"
     w         "{ Class: SmallInteger }"
     h         "{ Class: SmallInteger }"
     newImage newBits bitsPerPixel newBytesPerRow newMask
     value
     srcRow pixelArray|

    mX := scalePoint x.
    mY := scalePoint y.
    ((mX < 0) or:[mY < 0]) ifTrue:[^ nil].
    ((mX = 1) and:[mY = 1]) ifTrue:[^ self].

    newWidth := (width * mX) truncated.
    newHeight := (height * mY) truncated.

    bitsPerPixel := self depth.
    newBytesPerRow := ((newWidth * bitsPerPixel) + 7) // 8.
    newBits := ByteArray uninitializedNew:(newBytesPerRow * newHeight).

    mask notNil ifTrue:[
        newMask := (mask magnifiedBy:scalePoint)
    ].

    newImage := self species new.
    newImage
        width:newWidth
        height:newHeight
        photometric:photometric
        samplesPerPixel:samplesPerPixel
        bitsPerSample:bitsPerSample
        colorMap:colorMap copy
        bits:newBits
        mask:newMask.

    "walk over destination image fetching pixels from source image"

    w := newWidth - 1.
    h := newHeight - 1.
    pixelArray := newImage pixelArraySpecies new:newWidth.

    0 to:h do:[:row |
        srcRow := (row // mY).
        0 to:w do:[:col |
            value := self pixelAtX:(col // mX) y:srcRow.
            pixelArray at:(col+1) put:value.
        ].
        newImage rowAt:row putAll:pixelArray.
    ].

    ^ newImage

    "
     |i|
     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     Time millisecondsToRun:[
         i := i hardMagnifiedBy:0.5@0.5
     ].
     i
    "

    "Modified: 24.4.1997 / 18:30:24 / cg"
!

hardRotated:degrees
    "return a new image from the old one, by rotating the image
     degrees clockwise (around its center).
     Warning: the returned image will be larger than the original image."

    |p r a aN p1 p2 p3 p4 maxX minX maxY minY
     newImage
     newWidth  "{ Class: SmallInteger }"
     newHeight "{ Class: SmallInteger }"
     newBytesPerRow newBits
     blackPixel halfW halfH radians m t bad
     bytesPerRow myDepth maskBits
     pX pY srcX srcY pix nX nY
     sinRot cosRot sinPY cosPY|

    radians := degrees degreesToRadians.

    "/ placing the image at the origin,
    "/ compute the diagonal and angle.

    p := (width - 1 / 2) @ (height - 1 / 2).
    r := p r.
    a := p theta.

    "/ add the rotation
    "/ (sight - subtract, we defined things clockwise ...
    "/  ... in contrast to point which thinks counter-clockwise)

    aN := a - radians.

    "/ compute new corner points
    p1 := Point r:r theta:aN.         "/ rotated topRight
    p2 := Point r:r theta:aN-a-a.     "/ rotated bottomRight
    p3 := p1 * -1.                    "/ rotated bottomLeft
    p4 := p2 * -1.                    "/ rotated topLeft

    "/ compute the boundary of the new image

    maxX := minX := p1 x.
    (t := p2 x) > maxX ifTrue:[
        maxX := t
    ] ifFalse:[
        t < minX ifTrue:[minX := t].
    ].
    (t := p3 x) > maxX ifTrue:[
        maxX := t
    ] ifFalse:[
        t < minX ifTrue:[minX := t].
    ].
    (t := p4 x) > maxX ifTrue:[
        maxX := t
    ] ifFalse:[
        t < minX ifTrue:[minX := t].
    ].

    maxY := minY := p1 y.
    (t := p2 y) > maxY ifTrue:[
        maxY := t
    ] ifFalse:[
        t < minY ifTrue:[minY := t].
    ].
    (t := p3 y) > maxY ifTrue:[
        maxY := t
    ] ifFalse:[
        t < minY ifTrue:[minY := t].
    ].
    (t := p4 y) > maxY ifTrue:[
        maxY := t
    ] ifFalse:[
        t < minY ifTrue:[minY := t].
    ].


    newWidth := (maxX - minX) rounded + 1.
    newHeight := (maxY - minY) rounded + 1.

    newImage := self species new.
    newImage width:newWidth.
    newImage height:newHeight.
    newBytesPerRow := newImage bytesPerRow.
    newImage createPixelStore.
    newBits := newImage bits.
    newImage photometric:photometric.
    newImage samplesPerPixel:samplesPerPixel.
    newImage bitsPerSample:bitsPerSample.
    newImage colorMap:colorMap copy.
    newImage maskedPixelsAre0:maskedPixelsAre0.
    mask notNil ifTrue:[
        newImage mask:(mask rotated:degrees)
    ] ifFalse:[
        self isMask ifFalse:[
            self depth ~~ 1 ifTrue:[
                m := ImageMask width:width height:height.
                m bits:(maskBits := ByteArray new:(m bytesPerRow * height)).
                maskBits atAllPut:16rFF.
                newImage mask:(m rotated:degrees)
            ]
        ]
    ].

    myDepth := self depth.
    myDepth == 1 ifTrue:[
        blackPixel := 0.
    ] ifFalse:[
        maskedPixelsAre0 ifTrue:[
            blackPixel := 0.
        ] ifFalse:[
            blackPixel := self valueFromColor:Color black.
            blackPixel isNil ifTrue:[
                blackPixel := self valueFromColor:Color white.
                blackPixel isNil ifTrue:[
                    blackPixel := 0.
                ]
            ]
        ].
        self isMask ifTrue:[
            blackPixel := 0.
        ].
    ].

    newBits atAllPut:0.

    "/ now, walk over destination pixels,
    "/ fetching from source.
    "/ (if we walked over the source, we could get holes
    "/  in the destination image ...)

    halfW := (width - 1) / 2.0.
    halfH := (height - 1) / 2.0.

    bytesPerRow := self bytesPerRow.

%{
    int __newHeight = __intVal(newHeight);
    int __newWidth = __intVal(newWidth);
    int __height = __intVal(__INST(height));
    int __width = __intVal(__INST(width));
    double __minX, __minY, __radians;
    double __halfW, __halfH;
    int __dstX, __dstY;
    int __depth = __intVal(myDepth);
    unsigned char *__srcBytes, *__dstBytes;
    unsigned char *__dstPtr, *__dstRowPtr, *__dstEndPtr;
    int __nSrcBytes, __nDstBytes;
    int __srcBytesPerRow = __intVal(bytesPerRow);
    int __dstBytesPerRow = __intVal(newBytesPerRow);
    int __dstMask, __blackPixel;
    double __sin, __cos;
    double sin(), cos();
#   define Float_PI 3.14159

    bad = true;
    if (1
     && __isFloat(minX)
     && __isFloat(minY)
     && __isFloat(radians)
     && __isFloat(halfW)
     && __isFloat(halfH)
     && __isByteArray(newBits)
     && __isByteArrayLike(__INST(bytes))) {
        __srcBytes = __ByteArrayInstPtr(__INST(bytes))->ba_element;
        __dstBytes = __ByteArrayInstPtr(newBits)->ba_element;
        __nSrcBytes = __byteArraySize(__INST(bytes));
        __nDstBytes = __byteArraySize(newBits);
        __blackPixel = __intVal(blackPixel);

        __radians = __floatVal(radians);
        __radians = -__radians; /* sigh: clock-wise */
        __sin = sin(__radians);
        __cos = cos(__radians);
        __minX = __floatVal(minX);
        __minY = __floatVal(minY);
        __halfW = __floatVal(halfW);
        __halfH = __floatVal(halfH);

        __dstRowPtr = __dstBytes;
        __dstEndPtr = __dstBytes + __nDstBytes;

#       define EARLY_OUT
#       define FAST_ADVANCE 5
#       define FAST_ADVANCE2

        switch (__depth) {
            case 8:
                for (__dstY = 0; __dstY < __newHeight; __dstY++) {
                    double __pY, __sinPY, __cosPY;
#ifdef EARLY_OUT
                    int didFetchInRow = 0;
#endif
                    __pY = (double)(__dstY + __minY);

                    __sinPY = __sin * __pY;
                    __cosPY = __cos * __pY;

                    __dstPtr = __dstRowPtr;
                    __dstRowPtr += __dstBytesPerRow;

                    for (__dstX = 0; __dstX < __newWidth; __dstX++) {
                        double __pX, __nX;
                        unsigned __pix;

                        /* translate X in destination (center to 0/0) */
                        __pX = (double)(__dstX + __minX);
                        /* rotate X */
                        __nX = (__cos * __pX) - __sinPY;

                        /* translate X in source (origin to 0/0) */
                        __nX = __nX + __halfW + 0.5;

                        /* inside ? */
                        if (__nX < 0) {
#ifdef EARLY_OUT
                            if (didFetchInRow) {
                                break;
                            }
#endif
#ifdef FAST_ADVANCE
                            if (__blackPixel == 0) {
                                do {
                                    /* try advance by FAST_ADVANCE pixels ... */
                                    __dstX += FAST_ADVANCE; __dstPtr += FAST_ADVANCE;
                                    if (__dstX >= __newWidth) {
                                        break;
                                    }
                                    __pX = (double)(__dstX + __minX);
                                    __nX = (__cos * __pX) - __sinPY;
                                    __nX = __nX + __halfW + 0.5;
                                } while (__nX < 0);
                                __dstX -= FAST_ADVANCE; __dstPtr -= FAST_ADVANCE;
                            }
#endif
                            __pix = __blackPixel;
                        } else {
                            int __srcX;

                            __srcX = (int)__nX;
                            /* inside ? */
                            if (__srcX >= __width) {
#ifdef EARLY_OUT
                                if (didFetchInRow) {
                                    break;
                                }
#endif
#ifdef FAST_ADVANCE2
                                if (__blackPixel == 0) {
                                    do {
                                        /* try advance by FAST_ADVANCE pixels ... */
                                        __dstX += FAST_ADVANCE; __dstPtr += FAST_ADVANCE;
                                        if (__dstX >= __newWidth) {
                                            break;
                                        }
                                        __pX = (double)(__dstX + __minX);
                                        __nX = (__cos * __pX) - __sinPY;
                                        __nX = __nX + __halfW + 0.5;
                                        __srcX = (int)__nX;
                                    } while (__srcX >= __width);
                                    __dstX -= FAST_ADVANCE; __dstPtr -= FAST_ADVANCE;
                                }
#endif
                                __pix = __blackPixel;
                            } else {
                                double __nY;

                                /* rotate Y */
                                __nY = (__sin * __pX) + __cosPY;
                                /* translate Y in source (origin to 0/0) */
                                __nY = __nY + __halfH + 0.5;

                                /* inside ? */
                                if (__nY < 0) {
#ifdef EARLY_OUT
                                    if (didFetchInRow) {
                                        break;
                                    }
#endif
#ifdef FAST_ADVANCE2
                                    if (__blackPixel == 0) {
                                        do {
                                            /* try advance by FAST_ADVANCE pixels ... */
                                            __dstX += FAST_ADVANCE; __dstPtr += FAST_ADVANCE;
                                            if (__dstX >= __newWidth) {
                                                break;
                                            }
                                            __pX = (double)(__dstX + __minX);
                                            __nY = (__sin * __pX) + __cosPY;
                                            __nY = __nY + __halfH + 0.5;
                                        } while (__nY < 0);
                                        __dstX -= FAST_ADVANCE; __dstPtr -= FAST_ADVANCE;
                                    }
#endif
                                    __pix = __blackPixel;
                                } else {
                                    int __srcY;

                                    __srcY = (int)__nY;
                                    /* inside ? */
                                    if (__srcY >= __height) {
#ifdef EARLY_OUT
                                        if (didFetchInRow) {
                                            break;
                                        }
#endif
#ifdef FAST_ADVANCE
                                        if (__blackPixel == 0) {
                                            do {
                                                /* try advance by FAST_ADVANCE pixels ... */
                                                __dstX += FAST_ADVANCE; __dstPtr += FAST_ADVANCE;
                                                if (__dstX >= __newWidth) {
                                                    break;
                                                }
                                                __pX = (double)(__dstX + __minX);
                                                __nY = (__sin * __pX) + __cosPY;
                                                __nY = __nY + __halfH + 0.5;
                                                __srcY = (int)__nY;
                                            } while (__srcY >= __height);
                                            __dstX -= FAST_ADVANCE; __dstPtr -= FAST_ADVANCE;
                                        }
#endif
                                        __pix = __blackPixel;
                                    } else {
                                        /* fetch source pixel */

                                        int idx;
#ifdef EARLY_OUT
                                        didFetchInRow = 1;
#endif
                                        idx = __srcY * __srcBytesPerRow + __srcX;
                                        if ((unsigned)idx < __nSrcBytes) {
                                            __pix = __srcBytes[idx];
                                        } else {
                                            __pix = __blackPixel;
                                        }
                                    }
                                }
                            }
                        }

                        if (__pix != 0) {
                            *__dstPtr = __pix;
                        }
                        __dstPtr++;
                    }
                }
                break;

            case 1:
                for (__dstY = 0; __dstY < __newHeight; __dstY++) {
                    double __pY, __sinPY, __cosPY;
#ifdef EARLY_OUT
                    int didFetchInRow = 0;
#endif
                    __pY = (double)(__dstY + __minY);

                    __sinPY = __sin * __pY;
                    __cosPY = __cos * __pY;

                    __dstPtr = __dstRowPtr;
                    __dstMask = 0x80;
                    __dstRowPtr += __dstBytesPerRow;

                    for (__dstX = 0; __dstX < __newWidth; __dstX++) {
                        double __pX, __nX;
                        int __pix;

                        /* translate X in destination (center to 0/0) */
                        __pX = (double)(__dstX + __minX);
                        /* rotate X */
                        __nX = (__cos * __pX) - __sinPY;

                        /* translate X in source (origin to 0/0) */
                        __nX = __nX + __halfW + 0.5;

                        /* inside ? */
                        if (__nX < 0) {
#ifdef EARLY_OUT
                            if (didFetchInRow) {
                                break;
                            }
#endif
#ifdef FAST_ADVANCE
                            if (__blackPixel == 0) {
                                do {
                                    /* try advance by 8 pixels ... */
                                    __dstX += 8; __dstPtr ++;
                                    if (__dstX >= __newWidth) {
                                        break;
                                    }
                                    __pX = (double)(__dstX + __minX);
                                    __nX = (__cos * __pX) - __sinPY;
                                    __nX = __nX + __halfW + 0.5;
                                } while (__nX < 0);
                                __dstX -= 8; __dstPtr--;
                            }
#endif
                            __pix = __blackPixel;
                        } else {
                            int __srcX;

                            __srcX = (int)__nX;
                            /* inside ? */
                            if (__srcX >= __width) {
#ifdef EARLY_OUT
                                if (didFetchInRow) {
                                    break;
                                }
#endif
#ifdef FAST_ADVANCE2
                                if (__blackPixel == 0) {
                                    do {
                                        /* try advance by 8 pixels ... */
                                        __dstX += 8; __dstPtr++;
                                        if (__dstX >= __newWidth) {
                                            break;
                                        }
                                        __pX = (double)(__dstX + __minX);
                                        __nX = (__cos * __pX) - __sinPY;
                                        __nX = __nX + __halfW + 0.5;
                                        __srcX = (int)__nX;
                                    } while (__srcX >= __width);
                                    __dstX -= 8; __dstPtr--;
                                }
#endif
                                __pix = __blackPixel;
                            } else {
                                double __nY;

                                /* rotate Y */
                                __nY = (__sin * __pX) + __cosPY;
                                /* translate Y in source (origin to 0/0) */
                                __nY = __nY + __halfH + 0.5;

                                /* inside ? */
                                if (__nY < 0) {
#ifdef EARLY_OUT
                                    if (didFetchInRow) {
                                        break;
                                    }
#endif
#ifdef FAST_ADVANCE2
                                    if (__blackPixel == 0) {
                                        do {
                                            /* try advance by 8 pixels ... */
                                            __dstX += 8; __dstPtr++;
                                            if (__dstX >= __newWidth) {
                                                break;
                                            }
                                            __pX = (double)(__dstX + __minX);
                                            __nY = (__sin * __pX) + __cosPY;
                                            __nY = __nY + __halfH + 0.5;
                                        } while (__nY < 0);
                                        __dstX -= 8; __dstPtr--;
                                    }
#endif
                                    __pix = __blackPixel;
                                } else {
                                    int __srcY;

                                    __srcY = (int)__nY;
                                    /* inside ? */
                                    if (__srcY >= __height) {
#ifdef EARLY_OUT
                                        if (didFetchInRow) {
                                            break;
                                        }
#endif
#ifdef FAST_ADVANCE
                                        if (__blackPixel == 0) {
                                            do {
                                                /* try advance by 8 pixels ... */
                                                __dstX += 8; __dstPtr++;
                                                if (__dstX >= __newWidth) {
                                                    break;
                                                }
                                                __pX = (double)(__dstX + __minX);
                                                __nY = (__sin * __pX) + __cosPY;
                                                __nY = __nY + __halfH + 0.5;
                                                __srcY = (int)__nY;
                                            } while (__srcY >= __height);
                                            __dstX -= 8; __dstPtr--;
                                        }
#endif
                                        __pix = __blackPixel;
                                    } else {
                                        /* fetch source pixel */

                                        int idx, pV;
#ifdef EARLY_OUT
                                        didFetchInRow = 1;
#endif
                                        idx = __srcY * __srcBytesPerRow + (__srcX >> 3);
                                        if ((unsigned)idx < __nSrcBytes) {
                                            pV = __srcBytes[idx];
                                            __pix = (pV & (0x80 >> (__srcX & 7))) ? 1 : 0;
                                        } else {
                                            __pix = __blackPixel;
                                        }
                                    }
                                }
                            }
                        }

                        /* store pixel */
                        if (__pix != 0) {
                            *__dstPtr |= __dstMask;
                        }
                        __dstMask >>= 1;
                        if (__dstMask == 0) {
                            __dstMask = 0x80;
                            __dstPtr++;
                        }
                    }
                }
                break;

            case 24:
                for (__dstY = 0; __dstY < __newHeight; __dstY++) {
                    double __pY, __sinPY, __cosPY;
#ifdef EARLY_OUT
                    int didFetchInRow = 0;
#endif
                    __pY = (double)(__dstY + __minY);

                    __sinPY = __sin * __pY;
                    __cosPY = __cos * __pY;

                    __dstPtr = __dstRowPtr;
                    __dstRowPtr += __dstBytesPerRow;

                    for (__dstX = 0; __dstX < __newWidth; __dstX++) {
                        double __pX, __nX;
                        unsigned __pix;

                        /* translate X in destination (center to 0/0) */
                        __pX = (double)(__dstX + __minX);
                        /* rotate X */
                        __nX = (__cos * __pX) - __sinPY;

                        /* translate X in source (origin to 0/0) */
                        __nX = __nX + __halfW + 0.5;

                        /* inside ? */
                        if (__nX < 0) {
#ifdef EARLY_OUT
                            if (didFetchInRow) {
                                break;
                            }
#endif
                            __pix = __blackPixel;
                        } else {
                            int __srcX;

                            __srcX = (int)__nX;
                            /* inside ? */
                            if (__srcX >= __width) {
#ifdef EARLY_OUT
                                if (didFetchInRow) {
                                    break;
                                }
#endif
                                __pix = __blackPixel;
                            } else {
                                double __nY;

                                /* rotate Y */
                                __nY = (__sin * __pX) + __cosPY;
                                /* translate Y in source (origin to 0/0) */
                                __nY = __nY + __halfH + 0.5;

                                /* inside ? */
                                if (__nY < 0) {
#ifdef EARLY_OUT
                                    if (didFetchInRow) {
                                        break;
                                    }
#endif
                                    __pix = __blackPixel;
                                } else {
                                    int __srcY;

                                    __srcY = (int)__nY;
                                    /* inside ? */
                                    if (__srcY >= __height) {
#ifdef EARLY_OUT
                                        if (didFetchInRow) {
                                            break;
                                        }
#endif
                                        __pix = __blackPixel;
                                    } else {
                                        /* fetch source pixel */

                                        int idx;
#ifdef EARLY_OUT
                                        didFetchInRow = 1;
#endif
                                        idx = __srcY * __srcBytesPerRow + __srcX + __srcX + __srcX;
                                        if ((unsigned)idx < __nSrcBytes) {
                                            __pix = __srcBytes[idx];
                                            __pix = (__pix<<8) | __srcBytes[idx+1];
                                            __pix = (__pix<<8) | __srcBytes[idx+2];
                                        } else {
                                            __pix = __blackPixel;
                                        }
                                    }
                                }
                            }
                        }

                        /* store pixel */
                        if (__pix != 0) {
                            __dstPtr[0] = (__pix >> 16 & 0xFF);
                            __dstPtr[1] = (__pix >> 8) & 0xFF;
                            __dstPtr[2] = __pix & 0xFF;
                        }
                        __dstPtr += 3;
                    }
                }
                break;

            default:
                for (__dstY = 0; __dstY < __newHeight; __dstY++) {
                    double __pY, __sinPY, __cosPY;
#ifdef EARLY_OUT
                    int didFetchInRow = 0;
#endif
                    __pY = (double)(__dstY + __minY);

                    __sinPY = __sin * __pY;
                    __cosPY = __cos * __pY;

                    __dstPtr = __dstRowPtr;
                    __dstMask = 0x80;
                    __dstRowPtr += __dstBytesPerRow;

                    for (__dstX = 0; __dstX < __newWidth; __dstX++) {
                        double __pX, __nX;
                        OBJ __pix;

                        /* translate X in destination (center to 0/0) */
                        __pX = (double)(__dstX + __minX);
                        /* rotate X */
                        __nX = (__cos * __pX) - __sinPY;

                        /* translate X in source (origin to 0/0) */
                        __nX = __nX + __halfW + 0.5;

                        /* inside ? */
                        if (__nX < 0) {
#ifdef EARLY_OUT
                            if (didFetchInRow) {
                                break;
                            }
#endif
                            __pix = blackPixel;
                        } else {
                            int __srcX;

                            __srcX = (int)__nX;
                            /* inside ? */
                            if (__srcX >= __width) {
#ifdef EARLY_OUT
                                if (didFetchInRow) {
                                    break;
                                }
#endif
                                __pix = blackPixel;
                            } else {
                                double __nY;

                                /* rotate Y */
                                __nY = (__sin * __pX) + __cosPY;
                                /* translate Y in source (origin to 0/0) */
                                __nY = __nY + __halfH + 0.5;

                                /* inside ? */
                                if (__nY < 0) {
#ifdef EARLY_OUT
                                    if (didFetchInRow) {
                                        break;
                                    }
#endif
                                    __pix = blackPixel;
                                } else {
                                    int __srcY;

                                    __srcY = (int)__nY;
                                    /* inside ? */
                                    if (__srcY >= __height) {
#ifdef EARLY_OUT
                                        if (didFetchInRow) {
                                            break;
                                        }
#endif
                                        __pix = blackPixel;
                                    } else {
                                        /* fetch source pixel */

                                        static struct inlineCache valAt = _ILC2;
#ifdef EARLY_OUT
                                        didFetchInRow = 1;
#endif
                                        __pix = (*valAt.ilc_func)(self,
                                                              @symbol(pixelAtX:y:),
                                                              nil, &valAt,
                                                              __MKSMALLINT(__srcX),
                                                              __MKSMALLINT(__srcY));
                                    }
                                }
                            }
                        }

                        /* store pixel */
                        {
                            static struct inlineCache atPutVal = _ILC3;

                            if (__pix != __MKSMALLINT(0)) {
                                (*atPutVal.ilc_func)(newImage,
                                                      @symbol(pixelAtX:y:put:),
                                                      nil, &atPutVal,
                                                      __MKSMALLINT(__dstX),
                                                      __MKSMALLINT(__dstY),
                                                      __pix
                                                     );
                            }
                        }
                    }
                }
                break;
        }

        bad = false;
    }
%}.

    bad ifTrue:[
        "/ should not happen
        self primitiveFailed

"/        sinRot := radians negated sin.
"/        cosRot := radians negated cos.
"/
"/        0 to:newHeight-1 do:[:dstY |
"/            pY := (dstY + minY).
"/            sinPY := (sinRot * pY).
"/            cosPY := (cosRot * pY).
"/
"/            0 to:newWidth-1 do:[:dstX |
"/
"/                "/ translate center to origin
"/                pX := (dstX + minX).
"/
"/                nX := (cosRot * pX) - sinPY.
"/
"/                "/ translate in source
"/                srcX := nX + halfW.
"/                srcX := srcX rounded.
"/                "/ inside ?
"/
"/                (srcX >= 0 and:[srcX < width]) ifTrue:[
"/                    nY := (sinRot * pX) + cosPY.
"/                    srcY := nY + halfH.
"/                    srcY := srcY rounded.
"/
"/                    "/ inside ?
"/                    (srcY >= 0 and:[srcY < height]) ifTrue:[
"/                        pix := self pixelAtX:srcX y:srcY
"/                    ] ifFalse:[
"/                        pix := blackPixel.
"/                    ].
"/                ] ifFalse:[
"/                    pix := blackPixel.
"/                ].
"/                pix ~~ blackPixel ifTrue:[
"/                    newImage pixelAtX:dstX y:dstY put:pix.
"/                ]
"/            ].
"/        ].
    ].

    ^ newImage

    "
     |i|

     i := Smalltalk imageFromFileNamed:'bitmaps/xpmBitmaps/misc_icons/BOOK.xpm' inPackage:'stx:goodies'.
     i inspect.
     (i rotated:45) inspect.
     (i rotated:90) inspect.
     (i rotated:91) inspect.
     (i rotated:95) inspect.
    "
    "
     |i|

     i := Smalltalk imageFromFileNamed:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'.
     i := Depth24Image fromImage:i.
     (i rotated:200) inspect
    "
    "
     |i|

     i := Smalltalk imageFromFileNamed:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'.
     Transcript showCR:(
        Time millisecondsToRun:[
           i rotated:45.
        ]
     ).
    "
    "
     |v i rI rot|

     i := Smalltalk imageFromFileNamed:'bitmaps/xpmBitmaps/misc_icons/BOOK.xpm' inPackage:'stx:goodies'.
     v := View new extent:(i width max:100)@(i height max:100).
     v openAndWait.
     rot := 0.
     [true] whileTrue:[
        rI := i rotated:rot.
        rI := rI onDevice:v device.
        v clear.
        v displayForm:rI x:(v width-rI width)//2 y:(v height-rI height)//2.
        rot := rot + 5.
        rI close.
     ]
    "
    "
     |v i rI rot|

     i := Smalltalk imageFromFileNamed:'bitmaps/gifImages/claus.gif' inPackage:'stx:goodies'.
     v := View new extent:400@400.
     v openAndWait.
     rot := 0.
     [true] whileTrue:[
        rI := i rotated:rot.
        rI := rI onDevice:v device.
        v clear.
        v displayForm:rI x:(v width-rI width)//2 y:(v height-rI height)//2.
        rot := rot + 5.
        rI close.
     ]
    "
    "
     |v i rI rot|

     i := Form width:200 height:100 onDevice:Screen current.
     i clear.
     i displayLineFrom:(0@0) to:(199@0).
     i displayLineFrom:(199@0) to:(199@99).
     i displayLineFrom:(199@99) to:(0@99).
     i displayLineFrom:(0@99) to:(0@0).
     i displayLineFrom:(0@0) to:(199@100).
     i displayLineFrom:(199@0) to:(0@100).
     i := Image fromForm:i.

     v := View new extent:400@400.
     v openAndWait.
     rot := 0.
     [true] whileTrue:[
        rI := i rotated:rot.
        rI := rI onDevice:v device.
        v clear.
        v displayForm:rI x:(v width-rI width)//2 y:(v height-rI height)//2.
        rot := rot + 5.
        rI close.
        Delay waitForSeconds:0.1.
     ]
    "
    "
     |v i rI rot|

     i := Form width:200 height:100 onDevice:Screen current.
     i clear.
     i displayLineFrom:(0@0) to:(199@0).
     i displayLineFrom:(199@0) to:(199@99).
     i displayLineFrom:(199@99) to:(0@99).
     i displayLineFrom:(0@99) to:(0@0).
     i displayLineFrom:(0@0) to:(199@100).
     i displayLineFrom:(199@0) to:(0@100).
     i := Image fromForm:i.

     v := View new extent:400@400.
     v openAndWait.
     rot := 0.
     [true] whileTrue:[
        rI := i rotated:rot.
        rI := rI onDevice:v device.
        v clear.
        v displayForm:rI x:(v width-rI width)//2 y:(v height-rI height)//2.
        rot := rot + 30.
        rI close.
        Delay waitForSeconds:0.3.
     ]
    "

    "Modified: 22.4.1997 / 17:36:37 / cg"
!

lightened
    "return a new image which is slightly brighter than the receiver.
     The receiver must be a palette image (currently).
     CAVEAT: this only works with palette images (i.e. not for rgb or greyScale).
     CAVEAT: Need an argument, which specifies by how much it should be lighter."

    ^ self copyWithColorMapProcessing:[:clr | clr lightened]

    "
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') lightened inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') darkened inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') darkened darkened inspect
    "

    "Modified: / 24-11-2010 / 11:17:55 / cg"
!

magnifiedBy:scale
    "return a new image magnified by scalePoint, aPoint.
     If non-integral magnify is asked for, pass the work on to 'hardMagnifyBy:'
     while simple (integral) magnifications are handled here."

    |scalePoint mX mY
     magX      "{ Class: SmallInteger }"   "new version of stc can find this out itself..."
     magY      "{ Class: SmallInteger }"
     srcOffset "{ Class: SmallInteger }"
     dstOffset "{ Class: SmallInteger }"
     w         "{ Class: SmallInteger }"
     h         "{ Class: SmallInteger }"
     first
     newWidth newHeight newImage newBits newMask
     bitsPerPixel newBytesPerRow oldBytesPerRow
     bytes|

    scalePoint := scale asPoint.
    mX := scalePoint x.
    mY := scalePoint y.
    ((mX <= 0) or:[mY <= 0]) ifTrue:[^ nil].
    ((mX = 1) and:[mY = 1]) ifTrue:[^ self].

    ((mX isMemberOf:SmallInteger) and:[mY isMemberOf:SmallInteger]) ifFalse:[
        ^ self hardMagnifiedBy:scalePoint
    ].

    bytes := self bits.
    bitsPerPixel := self depth.
    oldBytesPerRow := ((width * bitsPerPixel) + 7) // 8.

    w := width.
    h := height.
    magX := mX.
    magY := mY.

    newWidth := w * magX.
    newHeight := h * magY.
    newBytesPerRow := ((newWidth * bitsPerPixel) + 7) // 8.
    newBits := ByteArray uninitializedNew:(newBytesPerRow * newHeight).

    mask notNil ifTrue:[
        newMask := (mask magnifiedBy:scalePoint)
    ].

    newImage := self species new.
    newImage
        width:newWidth
        height:newHeight
        photometric:photometric
        samplesPerPixel:samplesPerPixel
        bitsPerSample:bitsPerSample
        colorMap:colorMap copy
        bits:newBits
        mask:newMask.

    mX = 1 ifTrue:[
        "expand rows only"
        srcOffset := 1.
        dstOffset := 1.

        1 to:h do:[:row |
            1 to:magY do:[:i |
                newBits replaceFrom:dstOffset
                        to:(dstOffset + oldBytesPerRow - 1)
                        with:bytes
                        startingAt:srcOffset.
                dstOffset := dstOffset + newBytesPerRow
            ].
            srcOffset := srcOffset + oldBytesPerRow.
        ].
    ] ifFalse:[
        "expand cols"
        (mX > 1) ifTrue:[
            dstOffset := 1.
            srcOffset := 1.
            1 to:h do:[:row |
                self magnifyRowFrom:bytes
                     offset:srcOffset
                     into:newBits
                     offset:dstOffset
                     factor:mX.

                first := dstOffset.
                dstOffset := dstOffset + newBytesPerRow.
                " and copy for row expansion "
                2 to:magY do:[:i |
                    newBits replaceFrom:dstOffset
                            to:(dstOffset + newBytesPerRow - 1)
                            with:newBits
                            startingAt:first.
                    dstOffset := dstOffset + newBytesPerRow
                ].
                srcOffset := srcOffset + oldBytesPerRow.
            ].
        ]
    ].
    ^ newImage

    "
     ((Image fromFile:'goodies/bitmaps/gifImages/claus.gif') magnifiedBy:1@2)
    "

    "Modified: 24.4.1997 / 18:32:04 / cg"
!

magnifiedPreservingRatioTo:anExtent
    "return a new image magnified to fit into anExtent,
     preserving the receiver's width/height ratio.
     (i.e. not distorting the image).
     See also #magnifiedTo: and #magnifiedBy:"

    |rX rY|

    rX := anExtent x / self width.
    rY := anExtent y / self height.
    ^ self magnifiedBy:(rX min:rY)

    "
     ((Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') magnifiedPreservingRatioTo:100@100)

    in contrast to:

     ((Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') magnifiedTo:100@100)
    "

    "Modified: 22.4.1997 / 12:33:46 / cg"
!

magnifiedTo:anExtent
    "return a new image magnified to have the size specified by extent.
     This may distort the image if the arguments ratio is not the images ratio.
     See also #magnifiedPreservingRatioTo: and #magnifiedBy:"

    ^ self magnifiedBy:(anExtent / self extent)

    "
     ((Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') magnifiedTo:100@100)

    in contrast to:

     ((Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') magnifiedPreservingRatioTo:100@100)
    "
!

mixed:amount with:aColor
    "return a new image which is blended with some color;
     amount determines how much of the blending color is applied (0..)
     where 0 means: blending color pure.
     The receiver must be a palette image (currently).
     CAVEAT: this only works with palette images (i.e. not for rgb or greyScale).
     CAVEAT: Need an argument, which specifies by how much it should be lighter."

     ^ self
        copyWithColorMapProcessing:[:clr | clr mixed:amount with:aColor]

    "
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') mixed:0.0 with:Color red) inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') mixed:0.1 with:Color red) inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') mixed:0.25 with:Color red) inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') mixed:0.5 with:Color red) inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') mixed:1 with:Color red) inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') mixed:2 with:Color red) inspect
     ((Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') mixed:10 with:Color red) inspect
    "

    "Modified: 24.4.1997 / 18:31:23 / cg"
!

negative
    "return a new image which is a negative of the receiver.
     The receiver must be a palette image (currently)."

    |newImage|

    colorMap isNil ifTrue:[
        photometric == #blackIs0 ifTrue:[
            newImage := self copy.
            newImage photometric:#whiteIs0.
            ^ newImage
        ].
        photometric == #whiteIs0 ifTrue:[
            newImage := self copy.
            newImage photometric:#blackIs0.
            ^ newImage
        ].
        ^ nil
    ].

     ^ self
        copyWithColorMapProcessing:[:clr |
                Color
                    redByte:(255 - clr redByte)
                    greenByte:(255 - clr greenByte)
                    blueByte:(255 - clr blueByte)
            ]

    "
     (Image fromFile:'goodies/bitmaps/gifImages/claus.gif') inspect
     (Image fromFile:'goodies/bitmaps/gifImages/claus.gif') negative inspect
    "

    "Created: / 20-06-1997 / 13:13:41 / cg"
    "Modified: / 31-01-2017 / 14:43:19 / stefan"
!

rotated:degrees
    "return a new image from the old one, by rotating the image
     degrees clockwise.
     Notice that the resulting image has a different extent.
     If rotation is heavily used, the workHorse methods
     (#easyRotateBitsInto:angle: and #hardRotateBitsInto:angle) may
     be redefined in concrete image subclasses."

    |nW nH newImage d|

    d := degrees.
    [d < 0] whileTrue:[d := d + 360].
    d >= 360 ifTrue:[d := d \\ 360].
    d := d truncated.
    d = 0 ifTrue:[^ self].
    ((d ~= 90) and:[(d ~= 270) and:[d ~= 180]]) ifTrue:[
        ^ self hardRotated:d
    ].

    d = 180 ifTrue:[
        nW := width.
        nH := height.
    ] ifFalse:[
        nW := height.
        nH := width.
    ].

    newImage := self species new.
    newImage width:nW.
    newImage height:nH.
    newImage createPixelStore.
    newImage photometric:photometric.
    newImage samplesPerPixel:samplesPerPixel.
    newImage bitsPerSample:bitsPerSample.
    newImage colorMap:colorMap copy.
    mask notNil ifTrue:[
        newImage mask:(mask rotated:degrees)
    ].

    self easyRotateBitsInto:newImage angle:d.

    ^ newImage

    "
     |i|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     (i rotated:45) inspect.
     (i rotated:90) inspect.
     (i rotated:180) inspect.
     (i rotated:270) inspect.
    "
    "
     |i|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/claus.gif'.
     i := Depth24Image fromImage:i.
     i inspect.
     (i rotated:45) inspect.
     (i rotated:90) inspect.
     (i rotated:180) inspect.
     (i rotated:270) inspect.
    "
    "
     |i|

     i := Image fromFile:'goodies/bitmaps/xpmBitmaps/misc_icons/BOOK.xpm'.
     i inspect.
     (i rotated:90) inspect.
     (i rotated:180) inspect.
     (i rotated:270) inspect.
    "

    "Modified: 24.4.1997 / 18:33:42 / cg"
!

slightlyDarkened
    "return a new image which is slightly darker than the receiver.
     The receiver must be a palette image (currently).
     CAVEAT: this only works with palette images (i.e. not for rgb or greyScale).
     CAVEAT: Need an argument, which specifies by how much it should be lighter."

    ^ self copyWithColorMapProcessing:[:clr | clr slightlyDarkened]

    "
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') lightened inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') darkened inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') darkened darkened inspect
    "
!

slightlyLightened
    "return a new image which is slightly brighter than the receiver.
     The receiver must be a palette image (currently).
     CAVEAT: this only works with palette images (i.e. not for rgb or greyScale).
     CAVEAT: Need an argument, which specifies by how much it should be lighter."

    ^ self copyWithColorMapProcessing:[:clr | clr slightlyLightened]

    "
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') lightened inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') darkened inspect
     (Smalltalk bitmapFromFileNamed:'gifImages/claus.gif' inPackage:'stx:goodies') darkened darkened inspect
    "

    "Modified: / 24-11-2010 / 11:17:55 / cg"
!

threeDProjected:fraction1 and:fraction2
    "return a 3D-projected version"

    |dx1 dx2 newImage newBits
     blackPixel halfH m myDepth maskBits pix fr fl ml mr dm fractX my fy dstY o1 df|

    newImage := self species new.
    newImage width:width.
    newImage height:height.
    newImage createPixelStore.
    newBits := newImage bits.
    newImage photometric:photometric.
    newImage samplesPerPixel:samplesPerPixel.
    newImage bitsPerSample:bitsPerSample.
    newImage colorMap:colorMap copy.
    newImage maskedPixelsAre0:maskedPixelsAre0.
    mask notNil ifTrue:[
        newImage mask:(mask threeDProjected:fraction1 and:fraction2)
    ] ifFalse:[
        self isMask ifFalse:[
            self depth ~~ 1 ifTrue:[
                m := ImageMask width:width height:height.
                m bits:(maskBits := ByteArray new:(m bytesPerRow * height)).
                maskBits atAllPut:16rFF.
                newImage mask:(m threeDProjected:fraction1 and:fraction2)
            ]
        ]
    ].

    myDepth := self depth.
    myDepth == 1 ifTrue:[
        blackPixel := 0.
    ] ifFalse:[
        maskedPixelsAre0 ifTrue:[
            blackPixel := 0.
        ] ifFalse:[
            blackPixel := self valueFromColor:Color black.
            blackPixel isNil ifTrue:[
                blackPixel := self valueFromColor:Color white.
                blackPixel isNil ifTrue:[
                    blackPixel := 0.
                ]
            ]
        ].
        self isMask ifTrue:[
            blackPixel := 0.
        ].
    ].

    newBits atAllPut:0.

    "/ now, walk over destination pixels,
    "/ fetching from source.

    halfH := (height - 1) / 2.0.

    "/  --------------------------------------------------------------
    "/  |**************                                              |
    "/  |              ************                                  | dx1
    "/  |                          *************                     |
    "/  |                                       **********           |
    "/  |fl                          fy                   ***********|
    "/  |                                                            | fr
    "/  |                                                            | Mr  (!!= Ml)      |
    "/  |Ml                          my                              | fr               | dm (=Mr-Ml)
    "/  |                                                     *******|                  |
    "/  |                            fy              *********       |
    "/  |fl                                 *********                |
    "/  |                          *********                         | dx2
    "/  |                 *********                                  |
    "/  |        *********                                           |
    "/  |********                                                    |
    "/  --------------------------------------------------------------
    dx1 := height * fraction1.
    dx2 := height * fraction2.

    fr := (height - dx1 - dx2) / 2.0.
    fl := (height) / 2.0.

    ml := height / 2.0.
    mr := dx1+fr.

    dm := mr-ml.
    df := fr-fl.

    0 to:width-1 do:[:srcX |
        fractX := srcX / width.
        my := ml + (dm * fractX).
        fy := fl + (df * fractX).
        o1 := dx1 * fractX.

        0 to:height-1 do:[:srcY |
            srcY < halfH ifTrue:[
                dstY := o1 + (fy * (srcY / halfH)).
            ] ifFalse:[
                dstY := my + (fy * ((srcY-halfH) / halfH)).
            ].
            pix := self pixelAtX:srcX y:srcY.
            dstY < 0
                ifTrue:[dstY := 0]
                ifFalse:[ dstY >= height ifTrue:[dstY := height-1]].
            newImage pixelAtX:srcX y:dstY truncated put:pix.
        ].
    ].

    ^ newImage

    "
     |i|

     i := Smalltalk imageFromFileNamed:'bitmaps/gifImages/garfield.gif' inPackage:'stx:goodies'.
     i := Depth24Image fromImage:i.
     (i threeDProjected:0.1 and:0.3) inspect
     (i threeDProjected:0.1 and:0.1) inspect
    "

    "Modified: / 31-01-2017 / 15:04:22 / stefan"
!

withColorResolutionReducedBy:numBits
    "return a new image with the same picture as the receiver, but reduced colorResolution;
     that is, the lower numBits are cleared in the r/g/b color components.
     If anything fails, return nil."

    |xMax yMax r g b nR nG nB clr pix map revMap n_clr n_pix mask anyChange
     newColors newColorArray newImage extMask extBits newPixelValue|

    numBits > 7 ifTrue:[
        ^ nil
    ].
    mask := (16rFF bitShift:numBits) bitAnd:16rFF.
    extMask := (1 bitShift:numBits).
    extBits := extMask - 1.

    anyChange := false.

    newColors := Set new.
    newColorArray := OrderedCollection new.
    map := Array new:256.
    revMap := OrderedCollection new.

    newImage := self class width:width height:height depth:self depth.
    newImage photometric:photometric.
    newImage colorMap:(self colorMap copy).
    newImage bits:(self bits copy).
    newImage mask:(self mask copy).

    xMax := width - 1.
    yMax := height - 1.

    newPixelValue :=
        [:image :pixelValue |
            |r g b nR nG nB|

            r := image redBitsOf:pixelValue.
            g := image greenBitsOf:pixelValue.
            b := image blueBitsOf:pixelValue.
            nR := r bitAnd:mask. (nR bitAnd:extMask)~~0 ifTrue:[nR := nR bitOr:extBits].
            nG := g bitAnd:mask. (nG bitAnd:extMask)~~0 ifTrue:[nG := nG bitOr:extBits].
            nB := b bitAnd:mask. (nB bitAnd:extMask)~~0 ifTrue:[nB := nB bitOr:extBits].
            image valueFromRedBits:nR greenBits:nG blueBits:nB.
        ].


    photometric ~~ #palette ifTrue:[
        "/ direct manipulation of the pixels
        0 to:yMax do:[:y |
            0 to:xMax do:[:x |
                pix := self pixelAtX:x y:y.
                n_pix := newPixelValue value:self value:pix.
                n_pix ~= pix ifTrue:[
                    newImage pixelAtX:x y:y put:n_pix.
                    anyChange := true.
                ]
            ]
        ].
        anyChange ifFalse:[
            ^ nil
        ].
    ] ifFalse:[
        "/ manipulate the colormap
        0 to:yMax do:[:y |
            0 to:xMax do:[:x |
                pix := self pixelAtX:x y:y.
                (n_pix := map at:pix+1) isNil ifTrue:[
                    clr := self colorAtX:x y:y.

                    r := clr redByte.
                    g := clr greenByte.
                    b := clr blueByte.
                    nR := r bitAnd:mask. (nR bitAnd:extMask)~~0 ifTrue:[nR := nR bitOr:extBits].
                    nG := g bitAnd:mask. (nR bitAnd:extMask)~~0 ifTrue:[nR := nR bitOr:extBits].
                    nB := b bitAnd:mask. (nR bitAnd:extMask)~~0 ifTrue:[nR := nR bitOr:extBits].
                    n_clr := Color redByte:nR greenByte:nG blueByte:nB.
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
            ]
        ].
        revMap size == self colorMap size ifTrue:[
            revMap = (0 to:revMap size-1) ifTrue:[
                ^ nil
            ]
        ].

        newImage colorMap:(MappedPalette withColors:newColorArray).
    ].

    ^ newImage

    "Modified: / 30-01-2017 / 20:15:02 / stefan"
!

withPixelFunctionApplied:pixelFunctionBlock
    "return a new image from the old one, by applying a pixel processor
     on the pixel colors.
     Notice: this method is very slow - either apply pixel values
     (#withPixelFunctionAppliedToPixels:) or redefine this method in
     a concrete subclass.
     (read `Beyond photography, by Gerard J. Holzmann;
           ISBM 0-13-074410-7)
     See blurred / oilPointed as examples ...)"

    |w  "{Class: SmallInteger }"
     h  "{Class: SmallInteger }"
     newImage "newBits newBytesPerRow"|

    newImage := self species new.
    newImage depth:self depth.
    newImage width:width.
    newImage height:height.
"/    newBytesPerRow := ((width * self depth) + 7) // 8.
"/    newBits := ByteArray uninitializedNew:(newBytesPerRow * height).
    newImage createPixelStore. "/ bits:newBits.
    newImage photometric:photometric.
    newImage samplesPerPixel:samplesPerPixel.
    newImage bitsPerSample:bitsPerSample.
    newImage colorMap:colorMap copy.

    w := width - 1.
    h := height - 1.

    0 to:h do:[:y |
        0 to:w do:[:x |
            newImage colorAtX:x y:y put:(pixelFunctionBlock
                                                value:self
                                                value:(self colorAtX:x y:y)
                                                value:x
                                                value:y)
        ]
    ].
    ^ newImage

    "black out everything except for some rectangle:

     |i black|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.

     black := Color black.
     (i withPixelFunctionApplied:[:oldImage :oldColor :x :y |
                        ((x between:100 and:200)
                        and:[y between:100 and:200]) ifTrue:[
                            oldColor
                        ] ifFalse:[
                            black.
                        ]
                     ]) inspect.
    "
    "brighten a frame:

     |i black w h|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.

     w := i width.
     h := i height.
     (i withPixelFunctionApplied:[:oldImage :oldColor :x :y |
                        ((x between:0 and:10)
                        or:[(y between:0 and:10)
                        or:[(x between:w-10 and:w)
                        or:[y between:h-10 and:h]]]) ifTrue:[
                            oldColor lightened nearestIn:i colorMap
                        ] ifFalse:[
                            oldColor.
                        ]
                     ]) inspect.
    "

    "Modified: 24.4.1997 / 18:36:59 / cg"
!

withPixelFunctionAppliedToPixels:pixelFunctionBlock
    "return a new image from the old one, by applying a pixel processor
     on the pixel values.
     (read `Beyond photography, by Gerard J. Holzmann;
           ISBM 0-13-074410-7)
     See blurred / oilPointed as examples ...)"

    ^ self
        withPixelFunctionAppliedToPixels:pixelFunctionBlock
        in:(0@0 corner:width@height)

    "oil painting effect:

     |i w h|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     w := i width - 1.
     h := i height - 1.
     (i withPixelFunctionAppliedToPixels:[:oldImage :oldPixel :x :y |
                        |b p max xMin xMax yMin yMax|

                        b := Bag identityNew:10.
                        xMin := x-3 max:0.
                        xMax := x+3 min:w.
                        yMin := y-3 max:0.
                        yMax := y+3 min:h.
                        xMin to:xMax do:[:tx|
                          yMin to:yMax do:[:ty|
                            b add:(oldImage pixelAtX:tx y:ty)
                          ]
                        ].
                        max := 0.
                        b contents keysAndValuesDo:[:pixel :n |
                            n > max ifTrue:[
                                p := pixel.
                                max := n
                            ]
                        ].
                        p
                     ]) inspect.
    "

    "fisheye effect:

     |i w h w2 h2 R white|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     w := i width - 1.
     h := i height - 1.
     w2 := w // 2.
     h2 := h // 2.
     R := w2.
     white := i valueFromColor:Color white.
     (i withPixelFunctionAppliedToPixels:[:oldImage :oldPixel :x :y |
                        |p r a nR nP nX nY|

                        p := (x-w2)@(y-h2).
                        r := p r.
                        a := p theta.
                        nR := r * r / R.
                        nP := Point r:nR theta:a.
                        nX := ((nP x+w2) rounded max:0) min:w.
                        nY := ((nP y+h2) rounded max:0) min:h.
                        (nX > w or:[nX < 0]) ifTrue:[
                            white
                        ] ifFalse:[
                            (nY > h or:[nY < 0]) ifTrue:[
                                white
                            ] ifFalse:[
                                oldImage pixelAtX:nX y:nY
                            ]
                        ]
                     ]) inspect.
    "
    "fisheye effect:

     |i w h w2 h2 R white|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     w := i width - 1.
     h := i height - 1.
     w2 := w // 2.
     h2 := h // 2.
     R := w2.
     white := i valueFromColor:Color white.
     (i withPixelFunctionAppliedToPixels:[:oldImage :oldPixel :x :y |
                        |p r a nR nP nX nY|

                        p := (x-w2)@(y-h2).
                        r := p r.
                        a := p theta.
                        nR := r * r / R.
                        nP := Point r:nR theta:a.
                        nX := (nP x+w2) rounded.
                        nY := (nP y+h2) rounded.
                        (nX > w or:[nX < 0]) ifTrue:[
                            white
                        ] ifFalse:[
                            (nY > h or:[nY < 0]) ifTrue:[
                                white
                            ] ifFalse:[
                                oldImage pixelAtX:nX y:nY
                            ]
                        ]
                     ]) inspect.
    "

    "Created: 24.4.1997 / 18:37:17 / cg"
    "Modified: 24.4.1997 / 18:40:02 / cg"
!

withPixelFunctionAppliedToPixels:pixelFunctionBlock in:aRectangle
    "return a new image from the old one, by applying a pixel processor
     on the pixel values.
     (read `Beyond photography, by Gerard J. Holzmann;
           ISBM 0-13-074410-7)
     See blurred / oilPointed as examples ...)"

    |newImage "newBits newBytesPerRow"|

    newImage := self species new.
    newImage depth:self depth.
    newImage width:width.
    newImage height:height.
"/    newBytesPerRow := ((width * self depth) + 7) // 8.
"/    newBits := ByteArray uninitializedNew:(newBytesPerRow * height).
    newImage createPixelStore. "/ bits:newBits
    newImage photometric:photometric.
    newImage samplesPerPixel:samplesPerPixel.
    newImage bitsPerSample:bitsPerSample.
    newImage colorMap:colorMap copy.

    self applyPixelValuesTo:pixelFunctionBlock in:aRectangle into:newImage.
    ^ newImage

    "oil painting effect:

     |i w h|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     w := i width - 1.
     h := i height - 1.
     (i withPixelFunctionAppliedToPixels:[:oldImage :oldPixel :x :y |
                        |b p max xMin xMax yMin yMax|

                        b := Bag identityNew:10.
                        xMin := x-3 max:0.
                        xMax := x+3 min:w.
                        yMin := y-3 max:0.
                        yMax := y+3 min:h.
                        xMin to:xMax do:[:tx|
                          yMin to:yMax do:[:ty|
                            b add:(oldImage pixelAtX:tx y:ty)
                          ]
                        ].
                        max := 0.
                        b contents keysAndValuesDo:[:pixel :n |
                            n > max ifTrue:[
                                p := pixel.
                                max := n
                            ]
                        ].
                        p
                     ]) inspect.
    "

    "fisheye effect:

     |i w h w2 h2 R white|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     w := i width - 1.
     h := i height - 1.
     w2 := w // 2.
     h2 := h // 2.
     R := w2.
     white := i valueFromColor:Color white.
     (i withPixelFunctionAppliedToPixels:[:oldImage :oldPixel :x :y |
                        |p r a nR nP nX nY|

                        p := (x-w2)@(y-h2).
                        r := p r.
                        a := p theta.
                        nR := r * r / R.
                        nP := Point r:nR theta:a.
                        nX := ((nP x+w2) rounded max:0) min:w.
                        nY := ((nP y+h2) rounded max:0) min:h.
                        (nX > w or:[nX < 0]) ifTrue:[
                            white
                        ] ifFalse:[
                            (nY > h or:[nY < 0]) ifTrue:[
                                white
                            ] ifFalse:[
                                oldImage pixelAtX:nX y:nY
                            ]
                        ]
                     ]) inspect.
    "
    "fisheye effect:

     |i w h w2 h2 R white|

     i := Image fromFile:'goodies/bitmaps/gifImages/claus.gif'.
     i inspect.
     w := i width - 1.
     h := i height - 1.
     w2 := w // 2.
     h2 := h // 2.
     R := w2.
     white := i valueFromColor:Color white.
     (i withPixelFunctionAppliedToPixels:[:oldImage :oldPixel :x :y |
                        |p r a nR nP nX nY|

                        p := (x-w2)@(y-h2).
                        r := p r.
                        a := p theta.
                        nR := r * r / R.
                        nP := Point r:nR theta:a.
                        nX := (nP x+w2) rounded.
                        nY := (nP y+h2) rounded.
                        (nX > w or:[nX < 0]) ifTrue:[
                            white
                        ] ifFalse:[
                            (nY > h or:[nY < 0]) ifTrue:[
                                white
                            ] ifFalse:[
                                oldImage pixelAtX:nX y:nY
                            ]
                        ]
                     ]) inspect.
    "

    "Created: 24.4.1997 / 18:37:17 / cg"
    "Modified: 24.4.1997 / 18:40:02 / cg"
! !

!Image methodsFor:'initialization'!

createPixelStore
    |bytesPerRow|

    bytesPerRow := self bytesPerRow.
    self bits:(ByteArray new:(bytesPerRow * self height)).

    "Modified: / 02-11-2010 / 20:57:11 / cg"
!

initialize
    self photometric:(self class defaultPhotometric)
! !

!Image methodsFor:'inspecting'!

inspector2TabImageGraySacel
    <inspector2Tab>

    ^ self newInspector2Tab
        label: 'Grayscale';
        priority: 45;
        view: ((HVScrollableView for:ImageView) image: (self asGrayImageDepth: self depth); 
        yourself)

    "Created: / 08-06-2017 / 14:32:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Image methodsFor:'instance release'!

close
    "release device resources; destroy any device-resources"

    deviceForm notNil ifTrue:[
        deviceForm destroy.
        deviceForm := nil.
    ].
    monoDeviceForm notNil ifTrue:[
        monoDeviceForm destroy.
        monoDeviceForm := nil.
    ].
    fullColorDeviceForm notNil ifTrue:[
        fullColorDeviceForm destroy.
        fullColorDeviceForm := nil.
    ].

    device := nil.
    mask notNil ifTrue:[
        mask close.
    ].
    Lobby unregister:self.

    "Modified: 21.6.1996 / 19:08:19 / cg"
    "Created: 24.4.1997 / 11:55:20 / cg"
!

release
    "release device resources"

    device := nil.
    deviceForm := nil.
    monoDeviceForm := nil.
    fullColorDeviceForm := nil.
    mask notNil ifTrue:[
        mask release.
    ].
    Lobby unregister:self.
    super release.

    "Modified: 11.6.1997 / 13:20:04 / cg"
!

releaseFromDevice
    "release device resources"

    device := nil.
    deviceForm := nil.
    monoDeviceForm := nil.
    fullColorDeviceForm := nil.


    "Modified: 16.1.1997 / 19:33:01 / cg"
!

restored
    "flush device specifics after a snapin or binary restore"

    self release
! !


!Image methodsFor:'obsolete'!

applyPixelValuesTo:pixelFunctionBlock into:newImage in:aRectangle
    "helper for withPixelFunctionAppliedToValues:
     enumerate pixelValues and evaluate the block for each.
     To be redefined by subclasses for better performance."

    ^ self applyPixelValuesTo:pixelFunctionBlock in:aRectangle into:newImage
!

magnifyBy:scale
    <resource: #obsolete>
    "obsolete: has been renamed to magnifiedBy: for ST-80 compatibility
     and name consistency ..."

    self obsoleteMethodWarning.
    ^ self magnifiedBy:scale
! !

!Image methodsFor:'pixel copying'!

copyFrom:anImage x:srcX y:srcY toX:dstX y:dstY width:w height:h
    "replace a rectangular area by pixels from another image.
     The source's colors must be present in the destination's
     colorMap - otherwise, an error will be reported.
     Any mask is copied from the source.

     WARNING:
       This implementation is a very slow fallback general algorithm
       (the loop over the source pixels is very slow).
       If this method is used heavily, you may want to redefine it in
       concrete subclasses for the common case of of copying from an Image
       with the same depth & palette.
       If you do heavy image processing, specialized versions are even req'd
       for other cases, rewriting the inner loops as inline C-code."

    |dX dY|

    dX := srcX-dstX.
    dY := srcY-dstY.

    ((photometric == anImage photometric)
     and:[self bitsPerPixel == anImage bitsPerPixel
     and:[colorMap = anImage colorMap]]) ifTrue:[
        "/ can loop over values
        anImage valuesFromX:srcX  y:srcY
                        toX:srcX+w-1 y:srcY+h-1
                         do:[:x :y :pixelValue |
            self pixelAtX:x-dX y:y-dY put:pixelValue.
        ]
    ] ifFalse:[
        "/ must loop over colors - horribly slow
        anImage colorsFromX:srcX  y:srcY
                        toX:srcX+w-1 y:srcY+h-1
                         do:[:x :y :clr |
            self colorAtX:x-dX y:y-dY put:clr.
        ]
    ].

    (mask isNil and:[anImage mask notNil]) ifTrue:[
        "/ I have no mask; copied image has
        self createMask.
    ].

    mask notNil ifTrue:[
        anImage mask notNil ifTrue:[
            "/ both have a mask
            mask copyFrom:anImage mask x:srcX y:srcY toX:dstX y:dstY width:w height:h
        ] ifFalse:[
            "/ I have a mask - copied image has not
            mask fillRectangleX:dstX y:dstY width:w height:h withValue:1
        ]
"/    ] ifFalse:[
"/        anImage mask notNil ifTrue:[
"/            "/ I have no mask; copied image has (already handled)
"/        ] ifFalse:[
"/            "/ none has a mask - nothing to do.
"/        ]
    ].

    "
     |i1 i8 i4|

     i8 := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i8 inspect.
     i1 := Image fromFile:'../../libtool/bitmaps/SBrowser.xbm'.
     i1 inspect.

     i4 := Depth4Image fromImage:i8.
     i4 copyFrom:i1 x:0 y:0 toX:20 y:20 width:20 height:20.
     i4 inspect.
    "

    "Created: 20.9.1995 / 10:14:01 / claus"
    "Modified: 20.9.1995 / 10:25:31 / claus"
    "Modified: 21.6.1997 / 13:15:31 / cg"
!

copyFrom:anImage x:srcX y:srcY toX:dstX y:dstY width:w height:h masked:maskedCopy
    "replace a rectangular area by pixels from another image.
     The sources colors must be present in the destinations
     colorMap - otherwise, an error will be reported.

     WARNING:
       This implementation is a very slow fallback general algorithm
       (the loop over the source pixels is very slow).
       If this method is used heavily, you may want to redefine it in
       concrete subclasses for the common case of of copying from an Image
       with the same depth & palette.
       If you do heavy image processing, specialized versions are even req'd
       for other cases, rewriting the inner loops as inline C-code."

    maskedCopy ifTrue:[
        self
            copyMaskedFrom:anImage x:srcX y:srcY toX:dstX y:dstY width:w height:h
    ] ifFalse:[
        self
            copyFrom:anImage x:srcX y:srcY toX:dstX y:dstY width:w height:h
    ].

    "
     |i1 i8 i4|

     i8 := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i8 inspect.
     i1 := Image fromFile:'../../goodies/bitmaps/xbmBitmaps/TicTacToe.xbm'.
     i1 inspect.

     i4 := Depth4Image fromImage:i8.
     i4 copyFrom:i1 x:0 y:0 toX:20 y:20 width:20 height:20.
     i4 inspect.
    "
!

copyMaskedFrom:anImage x:srcX y:srcY toX:dstX y:dstY width:w height:h
    "replace a rectangular area by pixels from another image.
     The sources colors must be present in the destinations
     colorMap - otherwise, an error will be reported.
     Only unmasked pixels are copied from the source.

     WARNING:
       This implementation is a very slow fallback general algorithm
       (the loop over the source pixels is very slow).
       If this method is used heavily, you may want to redefine it in
       concrete subclasses for the common case of of copying from an Image
       with the same depth & palette.
       If you do heavy image processing, specialized versions are even req'd
       for other cases, rewriting the inner loops as inline C-code."

    |dX dY|

    dX := srcX-dstX.
    dY := srcY-dstY.

    ((photometric == anImage photometric)
     and:[self bitsPerPixel == anImage bitsPerPixel
     and:[colorMap = anImage colorMap]]) ifTrue:[
        "/ can loop over values
        anImage valuesFromX:srcX  y:srcY
                        toX:srcX+w-1 y:srcY+h-1
                         do:[:x :y :pixelValue |
            (anImage maskAtX:x y:y) ~~ 0 ifTrue:[
                self pixelAtX:x-dX y:y-dY put:pixelValue.
            ]
        ]
    ] ifFalse:[
        "/ must loop over colors - horribly slow
        anImage colorsFromX:srcX  y:srcY
                        toX:srcX+w-1 y:srcY+h-1
                         do:[:x :y :clr |
            (anImage maskAtX:x y:y) ~~ 0 ifTrue:[
                self colorAtX:x-dX y:y-dY put:clr.
            ]
        ]
    ].
!

subImageIn:aRectangle
    "create and return a new image consisting of a subArea of myself"

    ^ self class fromSubImage:self in:aRectangle

    "
     |i|

     i := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     (i subImageIn:(300@160 corner:340@200)) inspect
    "
    "
     |i|

     i := Image fromFile:'/Volumes/tmp/fillimage.ok.png'.
     i inspect.
     (i subImageIn:(0@0 corner:i width@i height)) inspect
    "

    "Created: 20.9.1995 / 01:24:20 / claus"
! !

!Image methodsFor:'pixel functions'!

computeBitsFromPixelFunction
    "compute the bits from the pixelfunction"

    |bpr|

    bpr := self bytesPerRow.
    bytes := ByteArray new:(bpr * height).
    0 to:height-1 do:[:y |
        0 to:width-1 do:[:x |
            self pixelAtX:x y:y put:(pixelFunction value:x value:y).
        ]
    ].

    "Modified: / 31-01-2017 / 14:39:26 / stefan"
!

pixelFunction
    ^ pixelFunction
!

pixelFunction:aTwoArgFunction
    "set the pixel function. This is used to define a functional image,
     where pixel values are computed via a function instead of coming
     from a bits array (although a pixel array could also be seen as
     a pixel function).
     The pixelFunction will map (x E [0 .. width]) x (y E [0 .. height]) -> pixel"

    pixelFunction := aTwoArgFunction.

    "
     |i|
     i := Depth1Image extent:256@256.
     i pixelFunction:[:x :y | ((x // 16) bitXor:(y // 16)) odd asInteger].
     i inspect.
    "

    "
     |i|
     i := Depth8Image extent:256@256.
     i photometric:#blackIs0.
     i pixelFunction:[:x :y | x  ].
     i inspect.
    "
!

pixelFunction:aTwoArgFunction inX:xInterval y:yInterval
    "set the pixel function and a viewport.
     This is used to define a functional image,
     where pixel values are computed via a function instead of coming
     from a bits array.
     The pixelFunction will map (x E xInterval) x (y E yInterval) -> pixel"

    |sX sY tX tY|

    "/ intervals are typically 0..1
    sX := (xInterval stop - xInterval start) asFloat / width.
    sY := (yInterval stop - yInterval start) asFloat / height.
    tX := xInterval start.
    tY := yInterval start.

    pixelFunction :=
        [:x :y |
            aTwoArgFunction value:(x * sX + tX) value:(y * sY + tY)
        ]

    "
     |i|
     i := Depth8Image extent:256@256.
     i photometric:#blackIs0.
     i pixelFunction:[:x :y | ((x@y) r * 255) truncated min:255] inX:(-1 to:1) y:(-1 to:1).
     i inspect.
    "
! !

!Image methodsFor:'printing & storing'!

storeOn:aStream
    "append a printed representation of the receiver to aStream,
     from which a copy of it can be reconstructed."

    |colors usedValues colorMapArray needBPS needSemi|

    needSemi := false.
    aStream nextPutAll:('(%1 width:%2 height:%3'
                            bindWith:self class name
                            with:width
                            with:height).

    "/ avoiding some unneeded stuff here makes object files with many images a bit smaller.
    "/ no need for the photometric, if it's the default anyway
    photometric ~= self class defaultPhotometric ifTrue:[
        (colorMap isNil or:[photometric ~~ #palette]) ifTrue:[
            aStream nextPutAll:' photometric:('. photometric storeOn:aStream. aStream nextPut:$).
            needSemi := false.
        ].
    ].
    aStream nextPut:$).

    "/ no need to store bitPerSample/samplesPerPixel in all situations
    needBPS := true.

    self depth == 1
        ifTrue:[ needBPS := false ]
        ifFalse:[
            ((photometric == #palette)
                and:[ (bitsPerSample size == 1)
                and:[ ((bitsPerSample at:1) == self depth)
                and:[ samplesPerPixel == 1 ]]])
            ifTrue:[
                needBPS := false.
            ].
        ].

    needBPS ifTrue:[
        needSemi ifTrue:[aStream nextPutAll:';'].
        aStream nextPutAll:' bitsPerSample:('. bitsPerSample storeOn:aStream. aStream nextPutAll:')'.
        samplesPerPixel ~= bitsPerSample size ifTrue:[
            aStream nextPutAll:'; samplesPerPixel:('. samplesPerPixel storeOn:aStream. aStream nextPutAll:')'.
        ].
        needSemi := true.
    ].

    "/ assert that all bits are there...
    "/ self assert:(self bits size) >= (self bytesPerRow * height).
    "/ self bits:((ByteArray new:self bytesPerRow * height) replaceFrom:1 with:self bits).

    needSemi ifTrue:[aStream nextPutAll:';'].
    aStream nextPutAll:' bits:(ByteArray fromPackedString:'. self bits asPackedString storeOn:aStream.
    aStream nextPutAll:')'.

    colorMap notNil ifTrue:[
        self depth <= 8 ifTrue:[
            "/ cut off unused colors ...
            usedValues := self usedValues.
            colors := colorMap copyFrom:1 to:((usedValues max+1) min:colorMap size).

            colorMapArray := OrderedCollection new.
            colors do:[:clr| colorMapArray add:(clr redByte); add:(clr greenByte); add:(clr blueByte)].
            aStream cr; spaces:12; nextPutAll:'colorMapFromArray:'.
            colorMapArray asByteArray storeOn:aStream.
        ] ifFalse:[
            aStream ct; spaces:12; nextPutAll:'colorMap:('.
            colorMap storeOn:aStream.
            aStream nextPutAll:')'
        ]
    ].
    mask notNil ifTrue:[
        aStream cr; spaces:12; nextPutAll:'mask:('.
        mask storeOn:aStream.
        aStream nextPutAll:')'.
    ].
    aStream nextPutAll:'; yourself'

    "Modified: / 22-08-1998 / 12:55:21 / cg"
    "Modified: / 01-09-2015 / 17:24:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Image methodsFor:'private'!

bestSupportedImageFormatFor:aDevice
    "scan through the image formats as supported by aDevice,
     and return the best to use when the receiver is to be represented
     on it. The best format is the one with the same number or more bits per
     pixel. Here, the smallest format found which can represent enough pixels is taken."

    |bestDeviceDepth
     bestDeviceBitsPerPixel "{ Class: SmallInteger }"
     "maxDepth"
     bestInfo maxInfo
     myDepth                "{ Class: SmallInteger }"
     maxBitsPerPixel        "{ Class: SmallInteger }"|

    myDepth := self bitsPerPixel.
    maxBitsPerPixel := 0.

    aDevice supportedImageFormats do:[:entry |
        |deviceImageDepth        "{ Class: SmallInteger }"
         deviceImageBitsPerPixel "{ Class: SmallInteger }" |

        deviceImageDepth := entry at:#depth.
        deviceImageBitsPerPixel := entry at:#bitsPerPixel.

        "/ for now, ignore all depth's which are neither 1 nor the
        "/ devices depth.
        "/ (actually, many devices can handle other pixMap formats,
        "/ but I don't know (yet) how to pass the correct color info

        ((deviceImageDepth == 1) or:[deviceImageDepth == aDevice depth]) ifTrue:[

            deviceImageBitsPerPixel > maxBitsPerPixel ifTrue:[
                maxInfo := entry.
    "/            maxBitsPerPixel := deviceImageBitsPerPixel.
    "/            maxDepth := deviceImageDepth.
            ].

            deviceImageDepth >= myDepth ifTrue:[
                deviceImageDepth == myDepth ifTrue:[
                    "/ take the better one ...
                    (bestDeviceDepth isNil
                     or:[(bestDeviceBitsPerPixel ~~ bestDeviceDepth)
                        and:[deviceImageDepth == deviceImageBitsPerPixel]]) ifTrue:[
                        bestInfo := entry.
                        bestDeviceDepth := deviceImageDepth.
                        bestDeviceBitsPerPixel := deviceImageBitsPerPixel.
                    ]
                ] ifFalse:[
                    "/ take the next-larger depth
                    (bestDeviceDepth isNil
                     or:[deviceImageBitsPerPixel < bestDeviceBitsPerPixel]) ifTrue:[
                        bestInfo := entry.
                        bestDeviceDepth := deviceImageDepth.
                        bestDeviceBitsPerPixel := deviceImageBitsPerPixel.
                    ]
                ]
            ].
        ].
    ].

    bestDeviceDepth isNil ifTrue:[
        maxBitsPerPixel == 0 ifTrue:[
            "/
            "/ oops - nothing appropriate
            "/
            maxInfo notNil ifTrue:[
                ^ maxInfo
            ].
            bestDeviceDepth := bestDeviceBitsPerPixel := aDevice depth.
            bestInfo := IdentityDictionary new.
            bestInfo at:#depth put:bestDeviceDepth.
            bestInfo at:#bitsPerPixel put:bestDeviceBitsPerPixel.
            bestInfo at:#padding put:32.
        ] ifFalse:[
            bestInfo := maxInfo.
        ]
    ].
    ^ bestInfo

    "Modified: / 7.2.1998 / 11:23:24 / cg"
!

colormapFromImage:anImage
    "setup the receiver's colormap from another image.
     Color precision may be lost, if conversion is from a higher depth
     image. This does not convert any pixel values; it is  non-public helper
     for fromImage:/fromSubImake:"

    self colormapFromImage:anImage photometric:nil
!

colormapFromImage:anImage photometric:photometricOrNil
    "setup the receiver's colormap from another image.
     Color precision may be lost, if conversion is from a higher depth
     image. This does not convert any pixel values; it is  non-public helper
     for fromImage:/fromSubImake:"

    |usedColors|

    samplesPerPixel == 3 ifTrue:[
        photometric := photometricOrNil ? #rgb
    ] ifFalse:[
        photometricOrNil isNil ifTrue:[
            photometric := anImage photometric.
        ] ifFalse:[
            photometric := photometricOrNil.
        ].
        photometric == #palette ifTrue:[
            self setColorMap:(anImage colorMap copy).
            "
             must generate/compress the colormap, if source image has higher depth
             than myself.
            "
            (colorMap isNil
            or:[anImage bitsPerPixel > self bitsPerPixel]) ifTrue:[
                "
                 get used colors are extracted into our colorMap
                 (the at-put below will set the pixelValue according the
                 new colorIndex
                "
                self setColorMap:(anImage usedColors asArray).
                colorMap size > (1 bitShift:self bitsPerPixel) ifTrue:[
                    'Image [warning]: possibly too many colors in image' errorPrintCR
                ]
            ]
        ] ifFalse:[
            (photometric == #blackIs0
            or:[ photometric == #whiteIs0 ]) ifTrue:[
            ] ifFalse:[
                usedColors := anImage usedColors asArray.
                usedColors size > (1 bitShift:self bitsPerPixel) ifTrue:[
                    'Image [warning]: possibly too many colors in image' errorPrintCR.
                    usedColors := usedColors copyTo:(1 bitShift:self bitsPerPixel).
                ].
                self setColorMap:usedColors.
                photometric := #palette
            ]
        ]
    ].

    "Created: 20.9.1995 / 00:58:42 / claus"
    "Modified: 10.1.1997 / 17:52:21 / cg"
!

fromDeviceForm:aForm maskForm:aMaskFormOrNil
    device := aForm device.
    self assert:device notNil.
    photometric := aForm photometric.
    deviceForm := aForm.
    width := aForm width.
    height := aForm height.

    aMaskFormOrNil notNil ifTrue:[
        mask := Image fromDeviceForm:aMaskFormOrNil maskForm:nil.
    ].
!

greyByteMapForRange:range
    "return a collection to map from pixelValues to greyLevels
     in the range 0..range.
     Range must be < 256 (for elements to fit into a ByteArray).
     The values are rounded towards the nearest pixel."

    |d clr val greyMap r
     n "{ Class: SmallInteger }"|

    r := range.
    r == 256 ifTrue:[
        r := 255
    ].

    photometric == #palette ifTrue:[
        n := colorMap size.
        greyMap := ByteArray new:n.

        1 to:n do:[:i |
            (clr := colorMap at:i) isNil ifTrue:[
                "/ an unused color
                val := 0.
            ] ifFalse:[
                val := (r * clr brightness) rounded
            ].
            greyMap at:i put:val
        ].
    ] ifFalse:[
        d := self bitsPerPixel.
        n := 1 bitShift:d.
        n >= 4096 ifTrue:[
            self error:'size not supported - too large'.
            ^ nil
        ].
        greyMap := ByteArray new:n.


        photometric == #rgb ifTrue:[
            1 to:n do:[:i |
                greyMap at:i put:(r * (self colorFromValue:i-1) brightness) rounded
            ].
        ] ifFalse:[
            1 to:n do:[:i |
                greyMap at:i put:(r / (n-1) * (i-1)) rounded
            ].
            photometric == #blackIs0 ifTrue:[
                "/ we are done
            ] ifFalse:[
                photometric == #whiteIs0 ifTrue:[
                    greyMap reverse
                ] ifFalse:[
                    self error:'invalid format'.
                    ^ nil
                ]
            ]
        ].
    ].

    ^ greyMap

    "
     Depth8Image new greyByteMapForRange:256

     Depth8Image new greyByteMapForRange:64
     Depth4Image new greyByteMapForRange:64

     Depth4Image new greyByteMapForRange:1
    "

    "Created: 8.6.1996 / 08:34:14 / cg"
    "Modified: 1.3.1997 / 17:24:45 / cg"
!

greyMapForRange:range
    "return a collection to map from pixelValues to greyLevels
     in the range 0..range. The brightness values are not rounded."

    |d r clr val
     n "{Class: SmallInteger }"
     n2 "{Class: SmallInteger }"
     greyArray|

    d := self bitsPerPixel.
    n := 1 bitShift:d.
    n >= 4096 ifTrue:[
        self error:'size not supported - too large'.
        ^ nil
    ].

    greyArray := Array new:n.

    photometric == #palette ifTrue:[
        n2 := colorMap size.
        1 to:n2 do:[:i |
            (clr := colorMap at:i) isNil ifTrue:[
                "/ an unused color
                val := 0.
            ] ifFalse:[
                val := range * clr brightness
            ].
            greyArray at:i put:val
        ].
        n2 < n ifTrue:[
            greyArray from:n2+1 to:n put:0
        ]
    ] ifFalse:[
        photometric == #rgb ifTrue:[
            1 to:n do:[:i |
                greyArray at:i put:(range * (self colorFromValue:(i-1)) brightness)
            ]
        ] ifFalse:[
            r := range asFloat.
            1 to:n do:[:i |
                greyArray at:i put:(r / (n-1) * (i-1))
            ].
            photometric == #blackIs0 ifTrue:[
                "/ we are done
            ] ifFalse:[
                photometric == #whiteIs0 ifTrue:[
                    greyArray reverse
                ] ifFalse:[
                    self error:'invalid format'.
                    ^ nil
                ]
            ]
        ]
    ].
    ^ greyArray

    "
     Depth8Image new greyMapForRange:64
     Depth4Image new greyMapForRange:64

     Depth16Image new greyMapForRange:1
     Depth4Image new greyMapForRange:1
     Depth2Image new greyMapForRange:1
    "

    "Modified: 1.3.1997 / 15:48:49 / cg"
!

magnifyRowFrom:srcBytes offset:srcStart
          into:dstBytes offset:dstStart factor:mX

    "magnify a single pixel row - can only magnify by integer factors,
     can only magnify 1,2,4,8 and 24 bit-per-pixel images. But this is done fast."

    ^ self subclassResponsibility
!

makeDeviceGrayPixmapOn:aDevice depth:depth fromArray:bits
    "given the bits of a grey/color bitmap, 8-bit padded and
     pixels interpreted as greyValues, 0 is black,
     create a device form for it"

    |f gcId|

    f := Form width:width height:height depth:depth onDevice:aDevice.
    f isNil ifTrue:[^ nil].

    f bits:bits.
    gcId := f initGC.

    (aDevice blackpixel ~~ 0) ifTrue:[
        "/ have to invert bits
        f function:#copyInverted
    ].
    aDevice
        drawBits:bits
        depth:depth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id)
        x:0 y:0
        width:width height:height
        with:gcId.
    ^ f

    "Created: 10.6.1996 / 20:10:31 / cg"
!

makeDeviceMonochromeBitmapOn:aDevice fromArray:monoBits
    "given the bits of a monochrome bitmap, 8-bit padded and
     0-bits as black, create a device form for it"

"/    monoBits invert.
    ^ (Form width:width height:height fromArray:monoBits onDevice:aDevice)
        colorMap:(Array with:Color black with:Color white).

    "Created: 10.6.1996 / 20:18:09 / cg"
    "Modified: 17.4.1997 / 01:07:38 / cg"
!

makeDevicePixmapOn:aDevice depth:depth fromArray:bits
    "given the bits of a grey/color bitmap, 8-bit padded and
     pixels interpreted as in the devices colormap,
     create a device form for it"

    |f|

    f := Form width:width height:height depth:depth onDevice:aDevice.
    f isNil ifTrue:[^ nil].
    f bits:bits.

    aDevice
        drawBits:bits
        depth:depth
        padding:8
        width:width height:height
        x:0 y:0
        into:(f id)
        x:0 y:0
        width:width height:height
        with:(f initGC).
    ^ f

    "Created: 10.6.1996 / 17:56:08 / cg"
    "Modified: 10.6.1996 / 20:11:27 / cg"
!

repairPhotometric
    "/ kludge: repair a 'should not happen' situation...
    photometric isNil ifTrue:[
        (self depth == 24 and:[ bitsPerSample size == 3 ]) ifTrue:[
            photometric := #rgb
        ].
    ].
! !

!Image methodsFor:'queries'!

alphaBitsOf:pixel
    "if the receiver is an rgb-image:
     return the alpha component of a pixelValue as integer 0..maxAlphaValue.
     MaxAlphaValue is of course the largest integer representable by the number
     of alpha bits i.e. (1 bitShift:bitsAlpha)-1.
     This has to be redefined by subclasses."

    |redBits greenBits blueBits alphaBits|

    samplesPerPixel >= 4 ifTrue:[
        redBits := bitsPerSample at:1.
        greenBits := bitsPerSample at:2.
        blueBits := bitsPerSample at:3.
        alphaBits := bitsPerSample at:4.

        ^ (pixel bitShift:(redBits + greenBits + blueBits) negated)
           bitAnd:(1 bitShift:alphaBits)-1
    ].

    self subclassResponsibility

    "Created: 8.6.1996 / 09:44:51 / cg"
    "Modified: 10.6.1996 / 14:59:05 / cg"
!

alphaMaskForPixelValue
    "return the mask used with translation from pixelValues to alphaBits"

    |alphaBits|

    samplesPerPixel >= 4 ifTrue:[
        alphaBits := bitsPerSample at:4.
        ^ (1 bitShift:alphaBits)-1
    ].

    self subclassResponsibility
!

alphaShiftForPixelValue
    "return the shift amount used with translation from pixelValues to alphaBits"

    |redBits greenBits blueBits|

    samplesPerPixel >= 3 ifTrue:[
        redBits := bitsPerSample at:1.
        greenBits := bitsPerSample at:2.
        blueBits := bitsPerSample at:3.

        ^ (greenBits + blueBits + redBits) negated
    ].

    self subclassResponsibility
!

ascentOn:aGC
    "I will not draw myself above the baseline"

    ^ 0
!

averageColor
    "return the average color of the image.
     This usually only makes sense for textures and patterns
     (i.e. to compute shadow & light colors for viewBackgrounds).
     Notice that for the above purpose, it is usually ok to process
     a subImage - i.e. use Image>>averageColorIn: on a smaller rectangle"

    ^ self averageColorIn:(0@0 corner:(width-1)@(height-1))
!

averageColorIn:aRectangle
    "return the images average color in an area.
     The implementation below is slow - so you may want to
     create tuned versions for DepthXImage if you plan to do
     heavy image processing ...
     (also, creating tuned versions of the enumeration messages helps a lot)"

    |x0 "{ Class:SmallInteger }"
     y0 "{ Class:SmallInteger }"
     x1 "{ Class:SmallInteger }"
     y1 "{ Class:SmallInteger }"
     sumRed sumGreen sumBlue n|

    sumRed := sumGreen := sumBlue := 0.
    y0 := aRectangle top.
    y1 := aRectangle bottom.
    x0 := aRectangle left.
    x1 := aRectangle right.

    n := (x1 - x0 + 1) * (y1 - y0 + 1).
    mask isNil ifTrue:[
        self colorsFromX:x0 y:y0 toX:x1 y:y1 do:[:x :y :colorAtXY |
            sumRed := sumRed + colorAtXY red.
            sumGreen := sumGreen + colorAtXY green.
            sumBlue := sumBlue + colorAtXY blue.
        ].
    ] ifFalse:[
        "/ masked pixels are not counted.
        self colorsFromX:x0 y:y0 toX:x1 y:y1 do:[:x :y :colorAtXY |
            (mask pixelAtX:x y:y) == 0 ifTrue:[
                n := n - 1.
            ] ifFalse:[
                sumRed := sumRed + colorAtXY red.
                sumGreen := sumGreen + colorAtXY green.
                sumBlue := sumBlue + colorAtXY blue.
            ].
        ].
    ].
    n == 0 ifTrue:[
        "/ all masked
        ^ Color black
    ].
    ^ Color red:(sumRed / n) green:(sumGreen / n) blue:(sumBlue / n)
!

bitsPerPixel
    "return the number of bits per pixel"

    ^ bitsPerSample sum
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * (self bitsPerPixel).
!

blackComponentOfCMYK:pixel
    "if the receiver is a cmyk-image:
     return the black component scaled to a percentage (0 .. 100) of a pixelValue."

    samplesPerPixel == 4 ifTrue:[
        "/ assume that the cyan bits are the leftMost bits (cmyk)

        (#[8 8 8 8] isSameSequenceAs:bitsPerSample) ifTrue:[
            ^ 100.0 / 255 * (pixel bitAnd:16rFF)
        ]
    ].

    self subclassResponsibility

    "Modified (format): / 31-01-2017 / 13:15:23 / stefan"
!

blueBitsOf:pixel
    "if the receiver is an rgb-image:
     return the blue bits of a pixelValue as integer 0..maxBlueValue.
     MaxGreenValue is of course the largest integer representable by the number
     of blue bits i.e. (1 bitShift:bitsBlue)-1.
     This has to be redefined by subclasses."

    |blueBits|

    samplesPerPixel >= 3 ifTrue:[
        blueBits := bitsPerSample at:3.
        ^ pixel bitAnd:(1 bitShift:blueBits)-1
    ].

    self subclassResponsibility

    "Created: 8.6.1996 / 09:44:21 / cg"
    "Modified: 10.6.1996 / 14:59:44 / cg"
!

blueComponentOf:pixel
    "if the receiver is an rgb-image:
     return the blue component scaled to a percentage (0 .. 100) of a pixelValue.
     This has to be redefined by subclasses."

    |blueBits  "{ Class: SmallInteger }"
     s         "{ Class: SmallInteger }"|

    samplesPerPixel >= 3 ifTrue:[
        "/ assume that the red bits are the leftMost bits

        blueBits := bitsPerSample at:3.
        blueBits == 0 ifTrue:[^ 0].

        s := (1 bitShift:blueBits) - 1.

        ^ 100.0 / s * (pixel bitAnd:(1 bitShift:blueBits)-1)
    ].

    self subclassResponsibility

    "Created: 8.6.1996 / 08:45:22 / cg"
    "Modified: 10.6.1996 / 14:55:39 / cg"
!

blueMaskForPixelValue
    "return the mask used with translation from pixelValues to blueBits"

    |blueBits|

    samplesPerPixel >= 3 ifTrue:[
        blueBits := bitsPerSample at:3.
        ^ (1 bitShift:blueBits)-1
    ].

    self subclassResponsibility
!

blueShiftForPixelValue
    "return the shift amount used with translation from pixelValues to blueBits"

    samplesPerPixel >= 3 ifTrue:[
        ^ 0
    ].

    self subclassResponsibility
!

bounds
    "return my bounds (added to make images usable as VisualComponents)"

    ^ Rectangle left:0 top:0 width:width height:height

    "Created: 13.5.1996 / 10:27:06 / cg"
!

brightness
    "return the (average) brightness of the image as number in 0..1.
     This usually only makes sense for textures and patterns
     (i.e. to compute shadow & light colors for viewBackgrounds).
     Notice that for the above purpose, only a subimage is inspected here"

    ^ (self averageColorIn:(0@0 corner:7@7)) brightness

    "Modified: 8.6.1996 / 08:46:46 / cg"
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    |bitsPerRow bytesPerRow|

    bitsPerRow := width * (self bitsPerPixel).
    bytesPerRow := bitsPerRow // 8.
    ((bitsPerRow \\ 8) ~~ 0) ifTrue:[
        bytesPerRow := bytesPerRow + 1
    ].
    ^ bytesPerRow
!

bytesPerRowPaddedTo:padding
    "return the number of bytes in one scanline of the image,
     if scanlines are to be padded to padding-bits."

    ^ self class
        bytesPerRowForWidth:width depth:(self bitsPerPixel) padding:padding
!

center
    "for compatibility with GC protocol - return the centerPoint"

    ^ (width // 2) @ (height // 2)

    "Created: 22.10.1997 / 23:52:40 / cg"
!

colorFromValue:pixelValue
    "given a pixel value, return the corresponding color.
     Pixel values start with 0.
     The implementation below is generic and slow
     - this method is typically redefined in subclasses."

    |p maxPixel clr r g b c m y k a
     numRedBits numGreenBits numBlueBits numAlphaBits|

    p := photometric.
    p isNil ifTrue:[
        colorMap notNil ifTrue:[
            p := #palette
        ] ifFalse:[
            "/ 'Image [warning]: no photometric - assume greyscale' infoPrintCR
            p := #blackIs0
        ]
    ].

    p == #blackIs0 ifTrue:[
        maxPixel := (1 bitShift:self bitsPerPixel) - 1.
        ^ Color gray:(pixelValue * (100 / maxPixel)).
    ].

    p == #whiteIs0 ifTrue:[
        maxPixel := (1 bitShift:self bitsPerPixel) - 1.
        ^ Color gray:100 - (pixelValue * (100 / maxPixel)).
    ].

    p == #palette ifTrue:[
        pixelValue >= colorMap size ifTrue:[
            ^ Color black
        ].
        clr := colorMap at:(pixelValue + 1).
        clr isNil ifTrue:[
            ^ Color black.
        ].
        ^ clr.
    ].

    p == #rgb ifTrue:[
        r := self redBitsOf:pixelValue.
        g := self greenBitsOf:pixelValue.
        b := self blueBitsOf:pixelValue.
        "/ scale...
        numRedBits := bitsPerSample at:1.
        numGreenBits := bitsPerSample at:2.
        numBlueBits := bitsPerSample at:3.
        (r ~~ 0) ifTrue:[ r := 100 / ((1 bitShift:numRedBits) - 1) * r].
        (g ~~ 0) ifTrue:[ g := 100 / ((1 bitShift:numGreenBits) - 1) * g].
        (b ~~ 0) ifTrue:[ b := 100 / ((1 bitShift:numBlueBits) - 1) * b].
        ^ Color redPercent:r greenPercent:g bluePercent:b
    ].

    ((p == #rgba) or:[p == #argb]) ifTrue:[
        r := self redBitsOf:pixelValue.
        g := self greenBitsOf:pixelValue.
        b := self blueBitsOf:pixelValue.
        a := self alphaBitsOf:pixelValue.
        "/ scale...
        numRedBits := bitsPerSample at:1.
        numGreenBits := bitsPerSample at:2.
        numBlueBits := bitsPerSample at:3.
        numAlphaBits := bitsPerSample at:4.
        (r == 0) ifFalse:[ r := (100 / ((1 bitShift:numRedBits)-1) * r)].
        (g == 0) ifFalse:[ g := (100 / ((1 bitShift:numGreenBits)-1) * g)].
        (b == 0) ifFalse:[ b := (100 / ((1 bitShift:numBlueBits)-1) * b)].
        (a == 0) ifFalse:[ a := (100 / ((1 bitShift:numAlphaBits)-1) * a)].
        ^ Color redPercent:r greenPercent:g bluePercent:b alphaPercent:a
    ].

    p == #cmyk ifTrue:[
        c := self cyanComponentOfCMYK:pixelValue.
        m := self magentaComponentOfCMYK:pixelValue.
        y := self yellowComponentOfCMYK:pixelValue.
        k := self blackComponentOfCMYK:pixelValue.
        ^ Color cyan:c magenta:m yellow:y black:k.
    ].

    p == #cmy ifTrue:[
        c := self cyanComponentOfCMY:pixelValue.
        m := self magentaComponentOfCMY:pixelValue.
        y := self yellowComponentOfCMY:pixelValue.
        ^ Color cyan:c magenta:m yellow:y.
    ].

    self error:'invalid (unsupported) photometric'

    "Created: / 08-06-1996 / 08:46:18 / cg"
    "Modified: / 06-06-2007 / 11:21:57 / cg"
!

cyanComponentOfCMY:pixel
    "if the receiver is a cmy-image:
     return the cyan component scaled to a percentage (0 .. 100) of a pixelValue."

    samplesPerPixel == 3 ifTrue:[
        "/ assume that the cyan bits are the leftMost bits (cmy)
        (#[8 8 8] isSameSequenceAs:bitsPerSample)ifTrue:[
            ^ 100.0 / 255 * ((pixel bitShift:-16) bitAnd:16rFF)
        ]
    ].

    self subclassResponsibility

    "Modified (format): / 31-01-2017 / 13:15:56 / stefan"
!

cyanComponentOfCMYK:pixel
    "if the receiver is a cmyk-image:
     return the cyan component scaled to a percentage (0 .. 100) of a pixelValue."

    samplesPerPixel == 4 ifTrue:[
        "/ assume that the cyan bits are the leftMost bits (cmyk)
        (#[8 8 8 8] isSameSequenceAs:bitsPerSample)ifTrue:[
            ^ 100.0 / 255 * ((pixel bitShift:-24) bitAnd:16rFF)
        ]
    ].

    self subclassResponsibility

    "Modified: / 31-01-2017 / 13:16:14 / stefan"
!

greenBitsOf:pixel
    "if the receiver is an rgb-image:
     return the green bits of a pixelValue as integer 0..maxGreenValue.
     MaxGreenValue is of course the largest integer representable by the number
     of green bits i.e. (1 bitShift:bitsGreen)-1.
     This has to be redefined by subclasses."

    |blueBits greenBits|

    samplesPerPixel >= 3 ifTrue:[
        greenBits := bitsPerSample at:2.
        blueBits := bitsPerSample at:3.

        ^ (pixel bitShift:blueBits negated) bitAnd:(1 bitShift:greenBits)-1
    ].

    self subclassResponsibility

    "Created: 8.6.1996 / 09:44:37 / cg"
    "Modified: 10.6.1996 / 14:59:35 / cg"
!

greenComponentOf:pixel
    "if the receiver is an rgb-image:
     return the green component scaled to a percentage (0..100) of a pixelValue.
     This has to be redefined by subclasses."

    |greenBits "{ Class: SmallInteger }"
     blueBits  "{ Class: SmallInteger }"
     s         "{ Class: SmallInteger }"|

    samplesPerPixel >= 3 ifTrue:[
        "/ assume that the red bits are the leftMost bits

        greenBits := bitsPerSample at:2.
        greenBits == 0 ifTrue:[^ 0].
        blueBits := bitsPerSample at:3.

        s := (1 bitShift:greenBits) - 1.

        ^ 100.0 / s * ((pixel bitShift:blueBits negated) bitAnd:(1 bitShift:greenBits)-1)
    ].

    self subclassResponsibility

    "Created: 8.6.1996 / 08:45:34 / cg"
    "Modified: 10.6.1996 / 14:55:24 / cg"
!

greenMaskForPixelValue
    "return the mask used with translation from pixelValues to greenBits"

    |greenBits|

    samplesPerPixel >= 3 ifTrue:[
        greenBits := bitsPerSample at:2.
        ^ (1 bitShift:greenBits)-1
    ].

    self subclassResponsibility
!

greenShiftForPixelValue
    "return the shift amount used with translation from pixelValues to greenBits"

    |greenBits|

    samplesPerPixel >= 3 ifTrue:[
        greenBits := bitsPerSample at:3.
        ^ greenBits negated
    ].

    self subclassResponsibility
!

heightOn:aGC
    "return my height, if displayed on aGC;
     since my height is independent of the device (the number of pixels),
     return the pixel-height"

    ^ height

    "Created: 12.5.1996 / 21:35:06 / cg"
    "Modified: 13.5.1996 / 10:26:36 / cg"
!

isDithered
    "for compatibility with color protocol"

    ^ false
!

isGrayscaleImage
    ^ (photometric ~= #palette)
      and:[photometric ~= #rgb]


    "Created: 22.4.1997 / 14:12:02 / cg"
!

isImage
    "return true, if the receiver is some kind of image;
     true is returned here - the method is redefined from Object."

    ^ true
!

isImageOrForm
    "return true, if the receiver is some kind of image or form;
     true is returned here - the method is redefined from Object."

    ^ true
!

isMask
    ^ false

    "Created: 22.4.1997 / 14:12:02 / cg"
!

magentaComponentOfCMY:pixel
    "if the receiver is a cmy-image:
     return the magenta component scaled to a percentage (0 .. 100) of a pixelValue."

    samplesPerPixel == 3 ifTrue:[
        (#[8 8 8] isSameSequenceAs:bitsPerSample)ifTrue:[
            ^ 100.0 / 255 * ((pixel bitShift:-8) bitAnd:16rFF)
        ]
    ].

    self subclassResponsibility

    "Modified (format): / 31-01-2017 / 13:19:06 / stefan"
!

magentaComponentOfCMYK:pixel
    "if the receiver is a cmyk-image:
     return the magenta component scaled to a percentage (0 .. 100) of a pixelValue."

    samplesPerPixel == 4 ifTrue:[
        (#[8 8 8 8] isSameSequenceAs:bitsPerSample)ifTrue:[
            ^ 100.0 / 255 * ((pixel bitShift:-16) bitAnd:16rFF)
        ]
    ].

    self subclassResponsibility

    "Modified (format): / 31-01-2017 / 13:19:11 / stefan"
!

nColorsUsed
    ^ self realUsedValues size
!

pixelArraySpecies
    "return the kind of pixel-value container in rowAt:/rowAt:put: methods"

    self depth <= 8 ifTrue:[^ ByteArray].
    "/ (d := self depth) <= 8 ifTrue:[^ ByteArray].
    "/ d <= 16 ifTrue:[^ WordArray].
    "/ ^ IntegerArray
    ^ Array

    "Modified: / 31-01-2017 / 14:52:42 / stefan"
!

realColorMap
    "return a collection usable as a real colormap of the image.
     For palette images, this is the internal colormap;
     for other photometrics (which do not have a real colormap), synthesize one.
     This is different from #colorMap, which returns nil for non palette images."

    |d nEntries "{ Class: SmallInteger }"
     colorArray|

    photometric == #palette ifTrue:[
        ^ colorMap asArray
    ].

    d := self depth.
    d > 12 ifTrue:[
        self error:'deep palette images not supported'.
        ^ nil.
    ].

    nEntries := 1 bitShift:d.

    colorArray := Array new:nEntries.
    1 to:nEntries do:[:idx |
        colorArray at:idx put:(self colorFromValue:(idx-1)).
    ].

    ^ colorArray

    "Created: 11.7.1996 / 20:20:35 / cg"
    "Modified: 11.7.1996 / 20:49:21 / cg"
!

realUsedColors
    "return a collection of colors which are really used in the receiver.
     This goes through the pixels and adds up colors as present in the image
     (as opposed to #usedColors, which looks at the colorMap if present)"

    ^ self realUsedValues collect:[:pixel | self colorFromValue:pixel] as:Set
!

realUsedValues
    "return a collection of color values used in the receiver.
     Notice that the interpretation of the pixels depends on the photometric
     of the image.
     This is a general and therefore slow implementation; subclasses
     may want to redefine this method for more performance.
     This goes through the pixels and adds up colors as present in the image
     (as opposed to #usedColors, which looks at the colorMap if present)"

    |set last|

    set := IdentitySet new.
    self valuesFromX:0 y:0 toX:(self width-1) y:(self height-1) do:[:x :y :pixel |
        pixel ~~ last ifTrue:[
            set add:pixel.
            last := pixel.
        ]
    ].
    ^ set

    "
     (Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') usedValues
     (Image fromFile:'libtool/bitmaps/SBrowser.xbm') usedValues
    "

    "Modified: / 29.7.1998 / 21:29:44 / cg"
!

redBitsOf:pixel
    "if the receiver is an rgb-image:
     return the red component of a pixelValue as integer 0..maxRedValue.
     MaxRedValue is the largest integer representable by the number
     of red bits i.e. (1 bitShift:bitsRed)-1.
     This has to be redefined by subclasses."

    |redBits greenBits blueBits|

    samplesPerPixel >= 3 ifTrue:[
        redBits := bitsPerSample at:1.
        greenBits := bitsPerSample at:2.
        blueBits := bitsPerSample at:3.

        ^ (pixel bitShift:(greenBits + blueBits) negated)
           bitAnd:(1 bitShift:redBits)-1
    ].

    self subclassResponsibility

    "Created: 8.6.1996 / 09:44:51 / cg"
    "Modified: 10.6.1996 / 14:59:05 / cg"
!

redComponentOf:pixel
    "if the receiver is an rgb-image:
     return the red component scaled to a percentage (0..100) of a pixelValue.
     This has to be redefined by subclasses."

    |redBits   "{ Class: SmallInteger }"
     greenBits "{ Class: SmallInteger }"
     blueBits  "{ Class: SmallInteger }"
     s         "{ Class: SmallInteger }"|

    samplesPerPixel >= 3 ifTrue:[
        "/ assume that the red bits are the leftMost bits

        redBits := bitsPerSample at:1.
        redBits == 0 ifTrue:[^ 0].

        greenBits := bitsPerSample at:2.
        blueBits := bitsPerSample at:3.

        s := (1 bitShift:redBits) - 1.

        ^ 100.0 / s *
          ((pixel bitShift:(greenBits + blueBits) negated)
           bitAnd:(1 bitShift:redBits)-1)
    ].

    self subclassResponsibility

    "Created: 8.6.1996 / 08:45:30 / cg"
    "Modified: 14.6.1996 / 17:34:00 / cg"
!

redMaskForPixelValue
    "return the mask used with translation from pixelValues to redBits"

    |redBits|

    samplesPerPixel >= 3 ifTrue:[
        redBits := bitsPerSample at:1.
        ^ (1 bitShift:redBits)-1
    ].

    self subclassResponsibility

    "Created: 8.6.1996 / 09:44:51 / cg"
    "Modified: 10.6.1996 / 14:59:05 / cg"
!

redShiftForPixelValue
    "return the shift amount used with translation from pixelValues to redBits"

    |greenBits blueBits|

    samplesPerPixel >= 3 ifTrue:[
        greenBits := bitsPerSample at:2.
        blueBits := bitsPerSample at:3.

        ^ (greenBits + blueBits) negated
    ].

    self subclassResponsibility
!

rgbFromValue:pixelValue
    "given a pixel value, return the corresponding 24bit rgbValue (rrggbb, red is MSB).
     Pixel value is in 0..2^depth - 1.
     The implementation below is generic and slow
     - this method is typically redefined in subclasses."

    |p maxPixel clr r g b c m y k|

    p := photometric.
    p isNil ifTrue:[
        colorMap notNil ifTrue:[
            p := #palette
        ] ifFalse:[
"/            'Image [warning]: no photometric - assume greyscale' infoPrintCR
            p := #blackIs0
        ]
    ].

    p == #blackIs0 ifTrue:[
        maxPixel := (1 bitShift:self bitsPerPixel) - 1.
        b := pixelValue * 255 // maxPixel.
        ^ (((b bitShift:8) bitOr:b) bitShift:8) bitOr:b
    ].

    p == #whiteIs0 ifTrue:[
        maxPixel := (1 bitShift:self bitsPerPixel) - 1.
        b := 255 - (pixelValue * 255 // maxPixel).
        ^ (((b bitShift:8) bitOr:b) bitShift:8) bitOr:b
    ].

    p == #palette ifTrue:[
        pixelValue >= colorMap size ifTrue:[
            ^ 0 "/ black
        ].
        clr := colorMap at:(pixelValue + 1).
        clr isNil ifTrue:[
            ^ 0 "/ black
        ].
        ^ clr rgbValue.
    ].

    p == #rgb ifTrue:[
        r := self redBitsOf:pixelValue.
        g := self greenBitsOf:pixelValue.
        b := self blueBitsOf:pixelValue.
        "/ must scale to byte value...
        r := r bitShift:(8 - (bitsPerSample at:1)).
        g := g bitShift:(8 - (bitsPerSample at:2)).
        b := b bitShift:(8 - (bitsPerSample at:3)).
        ^ (((r bitShift:8) bitOr:g) bitShift:8) bitOr:b
    ].

    p == #cmyk ifTrue:[
        c := self cyanComponentOfCMYK:pixelValue.
        m := self magentaComponentOfCMYK:pixelValue.
        y := self yellowComponentOfCMYK:pixelValue.
        k := self blackComponentOfCMYK:pixelValue.
        ^ (Color cyan:c magenta:m yellow:y black:k) rgbValue.
    ].

    p == #cmy ifTrue:[
        c := self cyanComponentOfCMY:pixelValue.
        m := self magentaComponentOfCMY:pixelValue.
        y := self yellowComponentOfCMY:pixelValue.
        ^ (Color cyan:c magenta:m yellow:y) rgbValue.
    ].

    self error:'invalid (unsupported) photometric'
!

usedColors
    "return a collection of colors used in the receiver.
     This looks at the colorMap only if present.
     (as opposed to #realUsedColors, which goes through the pixels of the bitmap)"

    |colors|

    colors := self usedColorsMax:4096.
    colors isNil ifTrue:[
        self error:'too many colors in image'.
    ].
    ^ colors

    "
     (Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') usedColors
     (Image fromFile:'libtool/bitmaps/SBrowser.xbm') usedColors
    "

    "Modified: / 7.9.1998 / 17:56:12 / cg"
!

usedColorsMax:nMax
    "return a collection of colors used in the receiver;
     This looks at the colorMap only if present
     (as opposed to #realUsedColors, which goes through the pixels of the bitmap).
     However, stop looking for more, if more than nMax colors have been found
     (useful when searching rgb images)."

    |usedValues max colors|

    photometric == #rgb ifTrue:[
        usedValues := IdentitySet new.
        self valuesFromX:0 y:0 toX:(width-1) y:(height-1)
          do:[:x :y :pixel |
            usedValues add:pixel.
            usedValues size > nMax ifTrue:[
                "/ too many to be returned here (think of the mass of
                "/ data to be returned by a 24bit image ... ;-)
                ^ nil
            ]
        ].
"/        colors := usedValues collect:[:pixel | self colorFromValue:pixel].
        "/ this code is slightly faster (but wrong for 16-bit images)...
        colors := usedValues collect:[:pixel | 
                    |r g b|
                    r := self redBitsOf:pixel.
                    g := self greenBitsOf:pixel.
                    b := self blueBitsOf:pixel.
                    "/ must scale to byte value...
                    r := r bitShift:(8 - (bitsPerSample at:1)).
                    g := g bitShift:(8 - (bitsPerSample at:2)).
                    b := b bitShift:(8 - (bitsPerSample at:3)).
                    Color redByte:r greenByte:g blueByte:b
                 ].
        ^ colors.
    ].

    usedValues := self usedValues asArray.
    photometric == #palette ifTrue:[
        colors := usedValues collect:[:val | (colorMap at:val+1 ifAbsent:[Color black])] as:Set.
    ] ifFalse:[
        "/ (photometric == #blackIs0 or:[photometric == #whiteIs0])

        max := (1 bitShift:self depth) - 1.
        colors :=  usedValues collect:[:val | (Color gray:(100 * val / max ))] as:Set.
    ].
    ^ colors

    "
     (Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') usedColors
     (Image fromFile:'libtool/bitmaps/SBrowser.xbm') usedColors
    "

    "Created: / 7.9.1998 / 17:54:17 / cg"
    "Modified: / 7.9.1998 / 17:56:21 / cg"
!

usedValues
    "return a collection of color values used in the receiver.
     Notice that the interpretation of the pixels depends on the photometric
     of the image.
     This is a general and therefore slow implementation; subclasses
     may want to redefine this method for more performance."

    ^ self realUsedValues

    "
     (Image fromFile:'goodies/bitmaps/gifImages/garfield.gif') usedValues
     (Image fromFile:'lib tool/bitmaps/SBrowser.xbm') usedValues
    "

    "Modified: / 29.7.1998 / 21:29:44 / cg"
!

valueFromColor:color
    "given a color, return the corresponding pixel value.
     Non-representable colors return nil."

    |pixel maxPixel redBits greenBits blueBits alphaBits r g b a|

    color colorId notNil ifTrue:[
        color == Color noColor ifTrue:[
            ^ nil "/ mask
        ].
        color device isNil ifTrue:[
            ^ color colorId
        ]
    ].

    photometric == #whiteIs0 ifTrue:[
        maxPixel := (1 bitShift:self bitsPerPixel) - 1.
        ^ maxPixel - (color brightness * maxPixel) rounded.
    ].

    photometric == #blackIs0 ifTrue:[
        maxPixel := (1 bitShift:self bitsPerPixel) - 1.
        ^ (color brightness * maxPixel) rounded.
    ].

    photometric == #palette ifTrue:[
        colorMap isNil ifTrue:[
            "/ same as blackIs0
            maxPixel := (1 bitShift:self bitsPerPixel) - 1.
            ^ (color brightness * maxPixel) rounded.
        ].

        pixel := colorMap indexOf:color.
        pixel == 0 ifTrue:[
            "
             the color is not in the images colormap
            "
            ^ nil
        ].
        ^ pixel - 1
    ].

    photometric == #rgb ifTrue:[
        samplesPerPixel >= 3 ifTrue:[
            redBits := bitsPerSample at:1.
            greenBits := bitsPerSample at:2.
            blueBits := bitsPerSample at:3.

            "/ map r/g/b to 0..255
            r := (color red / 100.0 * ((1 bitShift:redBits)-1)) rounded.
            g := (color green / 100.0 * ((1 bitShift:greenBits)-1)) rounded.
            b := (color blue / 100.0 * ((1 bitShift:blueBits)-1)) rounded.
            pixel := (((r bitShift:greenBits) + g) bitShift:blueBits) + b.
            ^ pixel
        ]
    ].

    photometric == #rgba ifTrue:[
        samplesPerPixel >= 4 ifTrue:[
            redBits := bitsPerSample at:1.
            greenBits := bitsPerSample at:2.
            blueBits := bitsPerSample at:3.
            alphaBits := bitsPerSample at:4.

            "/ map r/g/b/a to 0..255
            r := (color red / 100.0 * ((1 bitShift:redBits)-1)) rounded.
            g := (color green / 100.0 * ((1 bitShift:greenBits)-1)) rounded.
            b := (color blue / 100.0 * ((1 bitShift:blueBits)-1)) rounded.
            a := (color alpha * ((1 bitShift:alphaBits)-1)) rounded.
            pixel := (((((a bitShift:redBits) + r) bitShift:greenBits) + g) bitShift:blueBits) + b.
            ^ pixel
        ]
    ].
    ImageErrorSignal raiseErrorString:'format not supported'.
    ^ nil

    "Modified: / 06-06-2007 / 11:26:15 / cg"
!

valueFromRGB:rgb
    "given a color, return the corresponding pixel value.
     Non-representable colors return nil."

    |pixel redBits greenBits blueBits r g b a|

    r := rgb bitAnd:16rFF.
    g := (rgb bitShift:-8) bitAnd:16rFF.
    b := (rgb bitShift:-16) bitAnd:16rFF.
    a := 255.

"/    photometric == #whiteIs0 ifTrue:[
"/        maxPixel := (1 bitShift:self bitsPerPixel) - 1.
"/        ^ maxPixel - (color brightness * maxPixel) rounded.
"/    ].

"/    photometric == #blackIs0 ifTrue:[
"/        maxPixel := (1 bitShift:self bitsPerPixel) - 1.
"/        ^ (color brightness * maxPixel) rounded.
"/    ].
"/
"/    photometric == #palette ifTrue:[
"/        colorMap isNil ifTrue:[
"/            "/ same as blackIs0
"/            maxPixel := (1 bitShift:self bitsPerPixel) - 1.
"/            ^ (color brightness * maxPixel) rounded.
"/        ].
"/
"/        pixel := colorMap indexOf:color.
"/        pixel == 0 ifTrue:[
"/            "
"/             the color is not in the images colormap
"/            "
"/            ^ nil
"/        ].
"/        ^ pixel - 1
"/    ].

    photometric == #rgb ifTrue:[
        samplesPerPixel >= 3 ifTrue:[
            "/ r,g,b  b at low end
            redBits := bitsPerSample at:1.
            greenBits := bitsPerSample at:2.
            blueBits := bitsPerSample at:3.
            pixel := (((r bitShift:greenBits) + g) bitShift:blueBits) + b.
            ^ pixel
        ]
    ].

    photometric == #rgba ifTrue:[
        samplesPerPixel >= 4 ifTrue:[
            "/ a,r,g,b  b at low end
            redBits := bitsPerSample at:1.
            greenBits := bitsPerSample at:2.
            blueBits := bitsPerSample at:3.
"/            alphaBits := bitsPerSample at:4.
            pixel := (((((a bitShift:redBits) + r) bitShift:greenBits) + g) bitShift:blueBits) + b.
            ^ pixel
        ]
    ].
    ImageErrorSignal raiseErrorString:'format not supported'.
    ^ nil

    "Created: / 15-01-2008 / 15:55:08 / cg"
    "Modified: / 31-01-2017 / 14:45:00 / stefan"
!

valueFromRedBits:redBits greenBits:greenBits blueBits:blueBits
    "given a rgb bits, each in 0..maxXXXValue (i.e. according to
     r/g/b channels number of bits, return the corresponding pixel value.
     For now, only useful with RGB images"

    |pixel numGreenBits numBlueBits|

    photometric == #rgb ifTrue:[
        samplesPerPixel >= 3 ifTrue:[
            numGreenBits := bitsPerSample at:2.
            numBlueBits := bitsPerSample at:3.

            pixel := (((redBits bitShift:numGreenBits) + greenBits) bitShift:numBlueBits) + blueBits.
            ^ pixel
        ]
    ].

    ImageErrorSignal raiseErrorString:'format not supported'.
    ^ nil

    "Modified: / 30.9.1998 / 22:03:50 / cg"
!

widthOn:aGC
    "return my width, if displayed on aGC;
     since my width is independent of the device (the number of pixels),
     return the pixel-width"

    ^ width

    "Created: 12.5.1996 / 21:34:59 / cg"
    "Modified: 13.5.1996 / 10:26:42 / cg"
!

yellowComponentOfCMY:pixel
    "if the receiver is a cmy-image:
     return the yellow component scaled to a percentage (0 .. 100) of a pixelValue."

    samplesPerPixel == 3 ifTrue:[
        (#[8 8 8] isSameSequenceAs:bitsPerSample)ifTrue:[
            ^ 100.0 / 255 * (pixel bitAnd:16rFF)
        ]
    ].


    self subclassResponsibility

    "Modified (format): / 31-01-2017 / 13:18:47 / stefan"
!

yellowComponentOfCMYK:pixel
    "if the receiver is a cmyk-image:
     return the yellow component scaled to a percentage (0 .. 100) of a pixelValue."

    samplesPerPixel == 4 ifTrue:[
        (#[8 8 8 8] isSameSequenceAs:bitsPerSample)ifTrue:[
            ^ 100.0 / 255 * ((pixel bitShift:-8) bitAnd:16rFF)
        ]
    ].

    self subclassResponsibility

    "Modified: / 31-01-2017 / 13:19:00 / stefan"
! !

!Image methodsFor:'saving on file'!

saveOn:aFileName
    "save the image in aFileName. The suffix of the filename controls the format.
     Currently, not all formats may be supported
     (see ImageReader subclasses implementing save:onFile:).
     May raise a signal, if the image cannot be written by the reader."

    ^ self saveOn:aFileName quality:nil

    "
     |image|

     image := Image fromFile:'goodies/bitmaps/RCube.tiff'.
     image saveOn:'myImage.tiff'.
     image saveOn:'myImage.xbm'.
     image saveOn:'myImage.xpm'.
     image saveOn:'myImage.xwd'.
    "

    "Modified: 30.6.1997 / 22:06:34 / cg"
!

saveOn:aFileName quality:qualityPercentOrNil
    "save the image in aFileName. The suffix of the filename controls the format.
     Currently, not all formats may be supported
     (see ImageReader subclasses implementing save:onFile:).
     May raise a signal, if the image cannot be written by the reader."

    |suffix readerClass|

    "/
    "/ from the extension, get the imageReader class
    "/ (which should know how to write images as well)
    "/
    suffix := aFileName asFilename suffix.
    readerClass := MIMETypes imageReaderForSuffix:suffix.
    readerClass isNil ifTrue:[
        "/
        "/ no known extension - could ask user for the format here.
        "/ currently default to tiff format.
        "/
        readerClass := self class defaultImageFileWriter.
        'Image [warning]: unknown extension - cannot figure out format - using default (',readerClass name,')' errorPrintCR.
    ].
    ^ self saveOn:aFileName quality:qualityPercentOrNil using:readerClass


    "
     |image|

     image := Image fromFile:'goodies/bitmaps/RCube.tiff'.
     image saveOn:'myImage.tiff'.
     image saveOn:'myImage.xbm'.
     image saveOn:'myImage.xpm'.
     image saveOn:'myImage.xwd'.
    "

    "Modified: 30.6.1997 / 22:06:34 / cg"
!

saveOn:aFileName quality:qualityPercentOrNil using:readerClass
    "save the receiver using the representation class
     (which is usually a concrete subclasses of ImageReader).
     May raise a signal, if the image cannot be written by the reader."

    ^ readerClass save:self onFile:aFileName quality:qualityPercentOrNil

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     anImage saveOn:'myImage.tiff' using:TIFFReader.
    "

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     anImage saveOn:'myImage.xbm' using:XBMReader.
    "

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     Image cannotRepresentImageSignal handle:[:ex |
        self warn:'cannot save the image in this format'
     ] do:[
        anImage saveOn:'myImage.xbm' using:XBMReader.
     ]
    "

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     anImage saveOn:'myImage.xpm' using:XPMReader.
    "

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     anImage saveOn:'myImage.gif' using:GIFReader.
    "

    "Modified: 10.4.1997 / 17:49:26 / cg"
!

saveOn:aFileName using:readerClass
    "save the receiver using the representation class
     (which is usually a concrete subclasses of ImageReader).
     May raise a signal, if the image cannot be written by the reader."

    ^ readerClass save:self onFile:aFileName quality:nil

    "
     |anImage|

     anImage := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     anImage saveOn:'myImage.tiff' using:TIFFReader.
     (Depth24Image fromImage:anImage) saveOn:'myImage.jpg' using:JPEGReader.
     anImage saveOn:'myImage50.tiff' quality:50 using:TIFFReader.
     (Depth24Image fromImage:anImage) saveOn:'myImage50.jpg' quality:50 using:JPEGReader.
    "

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     anImage saveOn:'myImage.xbm' using:XBMReader.
    "

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     Image cannotRepresentImageSignal handle:[:ex |
        self warn:'cannot save the image in this format'
     ] do:[
        anImage saveOn:'myImage.xbm' using:XBMReader.
     ]
    "

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     anImage saveOn:'myImage.xpm' using:XPMReader.
    "

    "
     |anImage|

     anImage := Image fromFile:'goodies/bitmaps/gifImages/garfield.gif'.
     anImage saveOn:'myImage.gif' using:GIFReader.
    "

    "Modified: 10.4.1997 / 17:49:26 / cg"
! !

!Image methodsFor:'screen capture'!

from:aDrawable in:aRectangle
    "read an image from aDrawable.
     This may be a device Form, a view or the rootView.
     If it's a view or rootView, it must be completely visible (or have
     the backingStore option turned on). Otherwise, only the clipped contents
     is returned. This is a common helper for form-to-image conversion,
     and to read hardcopy images from the screen."

    | visType
     x        "{ Class: SmallInteger }"
     y        "{ Class: SmallInteger }"
     w        "{ Class: SmallInteger }"
     h        "{ Class: SmallInteger }"
     dstIndex "{ Class: SmallInteger }"
     srcIndex "{ Class: SmallInteger }"
     srcRow   "{ Class: SmallInteger }"
     dstRow   "{ Class: SmallInteger }"
     inData tmpData usedPixels mapSize
     map bytesPerLine
     bitOrder spaceBitsPerPixel
     info bitsPerPixelIn bytesPerLineIn
     bitsR "{ Class: SmallInteger }"
     bitsG "{ Class: SmallInteger }"
     bitsB "{ Class: SmallInteger }"
     maskR "{ Class: SmallInteger }"
     maskG "{ Class: SmallInteger }"
     maskB "{ Class: SmallInteger }"
     shR "{ Class: SmallInteger }"
     shG "{ Class: SmallInteger }"
     shB "{ Class: SmallInteger }"
     shR2 "{ Class: SmallInteger }"
     shG2 "{ Class: SmallInteger }"
     shB2 "{ Class: SmallInteger }"
     r "{ Class: SmallInteger }"
     g "{ Class: SmallInteger }"
     b "{ Class: SmallInteger }"
     word "{ Class: SmallInteger }"
     lword
     device ddepth isMSB bpp|

    depth := self depth.
    bpp := "bitsPerPixel :=" self bitsPerPixel.

    device := aDrawable graphicsDevice.

    aDrawable isForm ifTrue:[
        aDrawable depth == 1 ifTrue:[
            "/ a monochrome bitmap ?
            visType := #StaticGray.
            ddepth := 1.
        ] ifFalse:[
            visType := aDrawable photometric.
            ddepth := aDrawable depth.
        ]. 
        photometric := aDrawable photometric.
        samplesPerPixel := ddepth == 24 ifTrue:[3] ifFalse:[1].
        bitsPerSample := ddepth == 24 ifTrue:[#[8 8 8]] ifFalse:[ByteArray with:bpp].
    ] ifFalse:[
        "get some attributes of the display device"
        visType := device visualType.
        ddepth := device depth.
        "/ kludge for 15bit XFree server
        ddepth == 15 ifTrue:[
            ddepth := 16
        ].
        (visType == #StaticGray) ifTrue:[
            (device blackpixel == 0) ifTrue:[
                photometric := #blackIs0
            ] ifFalse:[
                photometric := #whiteIs0
            ].
            samplesPerPixel := 1.
            bpp := "bitsPerPixel :=" ddepth.
            bitsPerSample := ByteArray with:bpp.
        ] ifFalse:[
            ((visType == #PseudoColor) or:[(visType == #StaticColor) or:[visType == #GrayScale]]) ifTrue:[
                photometric := #palette.
                samplesPerPixel := 1.
                bpp := "bitsPerPixel :=" ddepth.
                bitsPerSample := ByteArray with:bpp.
            ] ifFalse:[
                ((visType == #TrueColor) or:[visType == #DirectColor]) ifTrue:[
                    photometric := #rgb.
                    samplesPerPixel := 3.
    "/                bpp := "bitsPerPixel :=" depth.
    "/                bitsPerSample := ByteArray with:device bitsRed
    "/                                       with:device bitsGreen
    "/                                       with:device bitsBlue
                    bpp := "bitsPerPixel :=" 24.
                    bitsPerSample := #[8 8 8].
                ] ifFalse:[
                    self error:'screen visual not supported'.
                    ^ nil
                ]
            ]
        ].
    ].

    "
     don't know yet, how the display pads; assume worst case,
     offering enough space for 32 bit padding
    "
    w := width := aRectangle width.
    h := height := aRectangle height.
    x := aRectangle left.
    y := aRectangle top.

    "
     a kludge: we don't know in advance how much we are going to need
     (its too late when info is present ...)
    "
    spaceBitsPerPixel := bpp.
    (bpp > 8) ifTrue:[
        spaceBitsPerPixel := 16.
        (bpp > 16) ifTrue:[
            spaceBitsPerPixel := 32.
            (bpp > 32) ifTrue:[
                spaceBitsPerPixel := bpp.
            ]
        ]
    ].

    bytesPerLine := (w * spaceBitsPerPixel + 31) // 32 * 4.

    "
     get the pixels
    "
    aDrawable isForm ifTrue:[
        (aDrawable id isNil and:[aDrawable bits notNil]) ifTrue:[
            info := Dictionary new
                        at:#bitsPerPixel put:(aDrawable depth);
                        at:#byteOrder put:#msbFirst;
                        at:#bitOrder put:#msbFirst;
                        at:#bytesPerLine put:(aDrawable width * aDrawable depth + 7)//8;
                        yourself.
            inData := aDrawable bits.
        ] ifFalse:[
            inData := ByteArray new:(bytesPerLine * height).
            info := device getBitsFromPixmapId:aDrawable id x:x y:y width:w height:h into:inData.
        ]
    ] ifFalse:[
        inData := ByteArray new:(bytesPerLine * height).
        info := device getBitsFromViewId:aDrawable id x:x y:y width:w height:h into:inData.
    ].

    bitsPerPixelIn := info at:#bitsPerPixel.

    isMSB := (info at:#byteOrder) == #msbFirst.

    "/
    "/ check if bitorder is what I like (msbFirst)
    "/
    "/ mhmh - that's not needed

    bitsPerPixelIn < 8 ifTrue:[
        bitOrder := info at:#bitOrder.
        bitOrder ~~ #msbFirst ifTrue:[
            inData
                expandPixels:8
                width:(inData size)
                height:1
                into:inData
                mapping:(ImageReader reverseBits "TODO: reverseBitsForDepth:bitsPerPixelIn").
        ].
    ].

    "
     check, if the devices padding is different ..
     or if the bitsPerPixels are different
    "
    bytesPerLineIn := (info at:#bytesPerLine).           "what I got"
    bytesPerLine := (w * bpp + 7) // 8.                  "what I want"

    maskR := info at:#redMask ifAbsent:[0].
    maskG := info at:#greenMask ifAbsent:[0].
    maskB := info at:#blueMask ifAbsent:[0].

    ((bytesPerLine ~~ bytesPerLineIn)
     or:[bitsPerPixelIn ~~ bpp]) ifTrue:[
        tmpData := inData.
        inData := ByteArray uninitializedNew:(bytesPerLine * height).

        srcRow := 1.
        dstRow := 1.

        bitsPerPixelIn ~~ bpp ifTrue:[
            "/ for now, only 32 -> 24 is supported

            maskR == 0 ifTrue:[
                bitsR := device bitsRed.
                bitsG := device bitsGreen.
                bitsB := device bitsBlue.
                maskR := (1 bitShift:bitsR) - 1.
                maskG := (1 bitShift:bitsG) - 1.
                maskB := (1 bitShift:bitsB) - 1.
                shR := device shiftRed negated.
                shG := device shiftGreen negated.
                shB := device shiftBlue negated.
            ] ifFalse:[
                shR := (maskR lowBit - 1) negated.
                bitsR := maskR highBit - maskR lowBit + 1.
                maskR := maskR bitShift:shR.
                shG := (maskG lowBit - 1) negated.
                bitsG := maskG highBit - maskG lowBit + 1.
                maskG := maskG bitShift:shG.
                shB := (maskB lowBit - 1) negated.
                bitsB := maskB highBit - maskB lowBit + 1.
                maskB := maskB bitShift:shB.
            ].
            shR2 := (8 - bitsR).
            shG2 := (8 - bitsG).
            shB2 := (8 - bitsB).

            ((bitsPerPixelIn == 32) and:[bpp == 24]) ifTrue:[
                "/ 'reformatting 32->24...' printNL.
                1 to:h do:[:hi |
                    srcIndex := srcRow.
                    dstIndex := dstRow.

                    1 to:w do:[:wi |
                        lword := tmpData unsignedInt32At:srcIndex MSB:isMSB.
                        r := (lword bitShift:shR) bitAnd:maskR.
                        g := (lword bitShift:shG) bitAnd:maskG.
                        b := (lword bitShift:shB) bitAnd:maskB.

                        inData at:dstIndex   put:r.
                        inData at:dstIndex+1 put:g.
                        inData at:dstIndex+2 put:b.
                        srcIndex := srcIndex + 4.
                        dstIndex := dstIndex + 3.
                    ].
                    dstRow := dstRow + bytesPerLine.
                    srcRow := srcRow + bytesPerLineIn
                ]
            ] ifFalse:[
                ((bitsPerPixelIn == 16) and:[bpp == 24]) ifTrue:[
                    "/ 'reformatting 16->24...' printNL.
                    1 to:h do:[:hi |
                        srcIndex := srcRow.
                        dstIndex := dstRow.

                        1 to:w do:[:wi |
                            word := tmpData unsignedInt16At:srcIndex MSB:isMSB.
                            r := (word bitShift:shR) bitAnd:maskR.
                            g := (word bitShift:shG) bitAnd:maskG.
                            b := (word bitShift:shB) bitAnd:maskB.

                            inData at:dstIndex   put:(r bitShift:shR2).
                            inData at:dstIndex+1 put:(g bitShift:shG2).
                            inData at:dstIndex+2 put:(b bitShift:shB2).

                            srcIndex := srcIndex + 2.
                            dstIndex := dstIndex + 3.
                        ].
                        dstRow := dstRow + bytesPerLine.
                        srcRow := srcRow + bytesPerLineIn
                    ]
                ] ifFalse:[
                    ('Image [warning]: unsupported depth combination: ' , bitsPerPixelIn printString , ' -> ' ,
                                                        bpp printString) errorPrintCR.
                    self shouldImplement.
                    ^ nil
                ]
            ].
        ] ifFalse:[
            "/
            "/ repad in the buffer
            "/
            1 to:h do:[:hi |
                inData replaceFrom:dstRow to:(dstRow + bytesPerLine - 1)
                              with:tmpData startingAt:srcRow.
                dstRow := dstRow + bytesPerLine.
                srcRow := srcRow + bytesPerLineIn
            ]
        ]
    ] ifFalse:[
        (bytesPerLine * height) ~~ inData size ifTrue:[
            tmpData := inData.
            inData := ByteArray uninitializedNew:(bytesPerLine * height).
            inData replaceFrom:1 to:bytesPerLine * height with:tmpData startingAt:1
        ]
    ].
    self bits:inData.

    "/
    "/  if not #palette we are done, the pixel values are the rgb/grey values
    "/
    photometric == #palette ifTrue:[
        "/
        "/ what we now have are the color numbers - still need the r/g/b values.
        "/ find out, which colors are in the picture
        "/
        usedPixels := inData usedValues.
        mapSize := usedPixels max + 1.

        "get the palette"
        map := Array new:mapSize.
        usedPixels do:[:colorIndex |
            |i|

            i := colorIndex + 1.
            device
                getRGBFrom:colorIndex
                into:[:r :g :b |
                    map at:i put:(Color red:r green:g blue:b)
                ]
        ].
        self setColorMap:map.
    ].

    "Modified: / 07-02-1998 / 18:23:07 / cg"
    "Modified: / 31-01-2017 / 15:02:52 / stefan"
!

fromScreen:aRectangle
    "read an image from the display screen.
     WARNING: this temporarily grabs the display
              it may not work from within a buttonMotion
              (use #fromScreen:on:grab: with a false grabArg then)."

    ^ self
        fromScreen:aRectangle
        on:Screen current
        grab:true

    "Modified: 26.3.1997 / 10:43:34 / cg"
!

fromScreen:aRectangle on:aDevice
    "read an image from aDevices display screen.
     Since I have no other displays, only the MonoChrome, StaticGrey
     and PseudoColor cases have been tested ...
     (especially True- and DirectColor may be wrong).
     Late note: 24bit rgb now also works.
     WARNING: this temporarily grabs the display
              it may not work from within a buttonMotion
              (use #fromScreen:on:grab: with a false grabArg then)."

    ^ self
        fromScreen:aRectangle
        on:aDevice
        grab:true

    "
     Image fromScreen:((0 @ 0) corner:(100 @ 100)) on:Display
     Image fromScreen:((0 @ 0) corner:(500 @ 500)) on:Display
    "

    "Modified: 24.4.1997 / 18:25:13 / cg"
!

fromScreen:aRectangle on:aDevice grab:doGrab
    "read an image from aDevice's display screen.
     If the doGrab argument is true, the display
     is grabbed (i.e. blocked for others) and a camera cursor is
     shown while the readout is done.
     Since I have no other displays, only the MonoChrome, StaticGrey
     and PseudoColor cases have been tested ...
     (especially True- and DirectColor may be wrong).
     Late note: 24bit rgb now also works.
     WARNING: with doGrab true, this temporarily grabs the display
              and it may not work from within a buttonMotion
              (use with a false grabArg then)."

    |curs rootView prevGrab|

    curs := nil.
"/    doGrab ifTrue:[ |cid|
"/        curs := Cursor sourceForm:(Image fromFile:'bitmaps/Camera.xbm')
"/                         maskForm:(Image fromFile:'bitmaps/Camera_m.xbm')
"/                          hotSpot:16@16.
"/        curs notNil ifTrue:[
"/            cid := (curs onDevice:aDevice) id
"/        ].
"/    ].

    "
     actually have to grabServer ... but that's not yet available
    "
    rootView := aDevice rootView.
    doGrab ifTrue:[
        prevGrab := aDevice activePointerGrab.
        aDevice grabPointerInView:rootView withCursor:curs.
    ].

    "
     get the pixels
    "
    [
        self from:rootView in:aRectangle.
    ] ensure:[
        doGrab ifTrue:[
            aDevice ungrabPointer.
            prevGrab notNil ifTrue:[
                 aDevice grabPointerInView:prevGrab.
            ]
        ]
    ]

    "
     Image fromScreen:((100@100) corner:(200@200)) on:Display grab:false
     Image fromScreen:((100@100) corner:(200@200)) on:Display grab:true
    "
!

photometricFromScreen:aDevice
    "read aDevices display photometric and set my colormap for it.
     This must be used after an images bits have been read from the screen
     or from an offScreen bitmap, for correct pixel interpretation."

    |depth visType bitsPerPixel|

    "
     get some attributes of the display device
    "
    visType := aDevice visualType.
    depth := aDevice depth.

    "/ kludge for 15bit XFree server
    depth == 15 ifTrue:[
        depth := 16
    ].

    (visType == #StaticGray) ifTrue:[
        (aDevice blackpixel == 0) ifTrue:[
            photometric := #blackIs0
        ] ifFalse:[
            photometric := #whiteIs0
        ].
        samplesPerPixel := 1.
        bitsPerPixel := depth.
        bitsPerSample := ByteArray with:bitsPerPixel.
        "
         were done, the pixel values are the grey values
        "
        ^ self
    ].

    ((visType == #TrueColor) or:[visType == #DirectColor]) ifTrue:[
        photometric := #rgb.
        samplesPerPixel := 3.

        "/ for now - only support 24bit TrueColor
        depth ~~ 24 ifTrue:[
            'IMAGE: unsupported display depth' errorPrintCR.
        ].
"/                bitsPerPixel := depth.
"/                bitsPerSample := ByteArray with:aDevice bitsRed
"/                                       with:aDevice bitsGreen
"/                                       with:aDevice bitsBlue
        bitsPerPixel := 24.
        bitsPerSample := #[8 8 8].
        "
         were done, the pixel values are the rgb values
        "
        ^ self
    ].

    ((visType ~~ #PseudoColor)
    and:[(visType ~~ #StaticColor)
    and:[visType ~~ #GrayScale]]) ifTrue:[
        self error:'screen visual not supported'.
        ^ nil
    ].

    photometric := #palette.
    samplesPerPixel := 1.
    bitsPerPixel := depth.
    bitsPerSample := ByteArray with:bitsPerPixel.

    "
     still need the pixels r/g/b values ...
    "
    self setColorMap:aDevice colorMap

    "Modified: 11.7.1996 / 11:11:34 / cg"
! !

!Image methodsFor:'virtual anti-aliased'!

vitualAntiAliasedAlongXvertical:bottomOrTop horizontal:leftOrRight form:tempForm color:aColor xRun:xRun yRun:yRun colorDictionary:colorDictionary blendStart:blendStart
    |isBottom isLeft additionalY workPoint startX endX pixels pixelPos percent distance nearestKey tmp|

    isBottom := bottomOrTop sameAs:#bottom.
    isBottom ifTrue:[
        additionalY := -1.
    ] ifFalse:[
        additionalY := 1.
    ].

    isLeft := leftOrRight sameAs:#left.
    isLeft ifTrue:[
        workPoint := (xRun - 1)@yRun.
        [
            ((tempForm pixelAtX:workPoint x y:workPoint y) == 0)
            and:[ ((tempForm pixelAtX:workPoint x y:workPoint y + additionalY) == 1) 
            and:[ ((tempForm pixelAtX:workPoint x - 1 y:workPoint y + additionalY) == 1) ]]
        ] whileTrue:[
            startX := workPoint x.
            endX isNil ifTrue:[endX := workPoint x].
            workPoint := (workPoint x - 1)@yRun.
        ].
    ] ifFalse:[
        workPoint := (xRun + 1)@yRun.
        [
            ((tempForm pixelAtX:workPoint x y:workPoint y) == 0)
            and:[ ((tempForm pixelAtX:workPoint x y:workPoint y + additionalY) == 1) 
            and:[ ((tempForm pixelAtX:workPoint x + 1 y:workPoint y + additionalY) == 1) ]]
        ] whileTrue:[
            endX := workPoint x.
            startX isNil ifTrue:[startX := workPoint x].
            workPoint := (workPoint x + 1)@yRun.
        ].
    ].

    (startX notNil and:[endX notNil]) ifTrue:[
        startX = endX ifTrue:[
            self atImageAndMask:startX@yRun putValue:((colorDictionary at:aColor) at:blendStart).
        ] ifFalse:[
            pixels := (endX - startX) + 1.
            startX to:endX do:[:x |
                isLeft ifTrue:[
                    pixelPos := (x - startX) + 1.
                ] ifFalse:[
                    pixelPos := (endX - x) + 1.
                ].

                percent := (100 / (pixels / pixelPos)) asFloat / 100.

                (colorDictionary at:aColor) keys do:[:aKey |
                    nearestKey isNil ifTrue:[
                        distance := percent dist:aKey.
                        nearestKey := aKey.
                    ] ifFalse:[
                        tmp := percent dist:aKey.
                        distance > tmp ifTrue:[
                            distance := tmp.
                            nearestKey := aKey.
                        ].
                    ].
                ].

                self atImageAndMask:x@yRun putValue:((colorDictionary at:aColor) at:nearestKey).

                distance := nil.
                nearestKey := nil.
            ].
        ].
    ].
!

vitualAntiAliasedAlongYhorizontal:leftOrRight vertical:bottomOrTop form:tempForm color:aColor xRun:xRun yRun:yRun colorDictionary:colorDictionary blendStart:blendStart
    |isLeft isBottom additionalX workPoint startY endY pixels pixelPos percent distance nearestKey tmp|

    isLeft := leftOrRight sameAs:#left.
    isLeft ifTrue:[
        additionalX := 1.
    ] ifFalse:[
        additionalX := -1.
    ].

    isBottom := bottomOrTop sameAs:#bottom.
    isBottom ifTrue:[
        workPoint := xRun@(yRun + 1).
        [
            ((tempForm pixelAtX:workPoint x y:workPoint y) == 0) 
            and:[ ((tempForm pixelAtX:workPoint x + additionalX y:workPoint y) == 1) 
            and:[ ((tempForm pixelAtX:workPoint x + additionalX y:workPoint y + 1) == 1) ]]
        ] whileTrue:[
            endY := workPoint y.
            startY isNil ifTrue:[startY := workPoint y].
            workPoint := xRun@(workPoint y + 1).
        ].
    ] ifFalse:[
        workPoint := xRun@(yRun - 1).
        [
            ((tempForm pixelAtX:workPoint x y:workPoint y) == 0) 
            and:[ ((tempForm pixelAtX:workPoint x + additionalX y:workPoint y) == 1) 
            and:[ ((tempForm pixelAtX:workPoint x + additionalX y:workPoint y - 1) == 1) ]]
        ] whileTrue:[
            startY := workPoint y.
            endY isNil ifTrue:[endY := workPoint y].
            workPoint := xRun@(workPoint y - 1).
        ].
    ].

    (startY notNil and:[endY notNil]) ifTrue:[
        startY = endY ifTrue:[
            self atImageAndMask:xRun@startY putValue:((colorDictionary at:aColor) at:blendStart).
        ] ifFalse:[
            pixels := (endY - startY) + 1.
            startY to:endY do:[:y |
                isBottom ifTrue:[
                    pixelPos := (endY - y) + 1.
                ] ifFalse:[
                    pixelPos := (y - startY) + 1.
                ].

                percent := (100 / (pixels / pixelPos)) asFloat / 100.

                (colorDictionary at:aColor) keys do:[:aKey |
                    nearestKey isNil ifTrue:[
                        distance := percent dist:aKey.
                        nearestKey := aKey.
                    ] ifFalse:[
                        tmp := percent dist:aKey.
                        distance > tmp ifTrue:[
                            distance := tmp.
                            nearestKey := aKey.
                        ].
                    ].
                ].

                self atImageAndMask:xRun@y putValue:((colorDictionary at:aColor) at:nearestKey).

                distance := nil.
                nearestKey := nil.
            ].
        ].
    ].
! !

!Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Image initialize!
