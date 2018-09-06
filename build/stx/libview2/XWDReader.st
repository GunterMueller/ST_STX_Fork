"
     COPYRIGHT (c) 1995 by Claus Gittinger
              All Rights Reserved

     This software is furnished under a license and may be used
     only in accordance with the terms of that license and with the
     inclusion of the above copyright notice.   This software may not
     be provided or otherwise made available to, or used by, any
     other person.  No title to or ownership of the software is
     hereby transferred.


     The above copyright does not apply to:
        XWDReader>>save:onFile:
     which was written by Brad Schoening <brad@boole.com> 
     who placed it into the public domain.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ImageReader subclass:#XWDReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!XWDReader class methodsFor:'documentation'!

copyright
"
     COPYRIGHT (c) 1995 by Claus Gittinger
              All Rights Reserved

     This software is furnished under a license and may be used
     only in accordance with the terms of that license and with the
     inclusion of the above copyright notice.   This software may not
     be provided or otherwise made available to, or used by, any
     other person.  No title to or ownership of the software is
     hereby transferred.


     The above copyright does not apply to:
        XWDReader>>save:onFile:
     which was written by Brad Schoening <brad@boole.com> 
     who placed it into the public domain.
"
!

documentation
"
    this class provides methods for loading/saving of x-window dump (xwd) images.
    Both reading and writing of images is supported.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PBMReader PCXReader 
        ST80FormReader SunRasterReader TargaReader TIFFReader WindowsIconReader 
        XBMReader XPMReader 
"
! !

!XWDReader class methodsFor:'initialization'!

initialize
    "tell Image-class, that a new fileReader is present
     for the '.xwd' extension."

    MIMETypes defineImageType:'image/x-xwindowdump' suffix:'xwd' reader:self

    "Created: 1.2.1997 / 15:04:46 / cg"
! !

!XWDReader class methodsFor:'queries'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     Only depth8 palette images are supported."

    anImage depth ~~ 8 ifTrue:[^ false].
    anImage photometric ~~ #palette ifTrue:[^ false].
    ^ true
! !

!XWDReader methodsFor:'reading'!

readImage
    "read an image in XWD (X Window Dump) format from my inStream."

    |header nColors pad 
     srcRowByteSize bytesPerRow bitsPerPixel colormapSize depth 
     dstIndex|

    inStream binary.

    header := (1 to: 25) collect: [:i | inStream nextLong].

    "skip ..."
    101 to:(header at: 1) do: [:i | inStream next].

    depth := header at: 4.
    width := header at: 5.
    height := header at: 6.
    pad := header at: 11.

    self reportDimension.

    bitsPerPixel := header at: 12.
    bitsPerPixel == 24 ifTrue:[
        bitsPerSample := #(8 8 8).
        samplesPerPixel := 3.
        photometric := #rgb
    ] ifFalse:[
        bitsPerSample := Array with:bitsPerPixel.
        samplesPerPixel := 1.
        photometric := #palette
    ].
"/  depth ~~ bitsPerPixel ifTrue:[self halt].

    colormapSize := header at: 19.
    nColors := header at: 20.

    colorMap := Array new:colormapSize.

    1 to:nColors do:[:i |
        |clr r g b|

        inStream nextLong.
        r := inStream nextUnsignedShortMSB:true.
        g := inStream nextUnsignedShortMSB:true.
        b := inStream nextUnsignedShortMSB:true.
        clr := ColorValue scaledRed: (r bitShift: -3)
                        scaledGreen: (g bitShift: -3)
                         scaledBlue: (b bitShift: -3).
        colorMap at:i put:clr.
        inStream nextWord.
    ].

    nColors+1 to:colormapSize do: [:i | colorMap at:i put:Color black].

    bytesPerRow := width * bitsPerPixel // 8.
    ((width * bitsPerPixel \\ 8) ~~ 0) ifTrue:[
        bytesPerRow := bytesPerRow + 1
    ].
    srcRowByteSize := width * bitsPerPixel + pad - 1 // pad * (pad / 8).

    data := ByteArray uninitializedNew: srcRowByteSize * height.
    srcRowByteSize == bytesPerRow ifTrue:[
        inStream nextBytes:srcRowByteSize * height into:data.
    ] ifFalse:[
        dstIndex := 1.
        1 to:height do:[:y |
            inStream nextBytes:bytesPerRow into:data startingAt:dstIndex.
            inStream next:(srcRowByteSize - bytesPerRow).
            dstIndex := dstIndex + bytesPerRow.
        ].
    ]

    "
     XWDReader fromFile:'testfile.xwd'
    "
    "
     XWDReader save:(Image fromUser) onFile: '/tmp/st.xwd' 
     (Image fromFile: '/tmp/st.xwd') inspect 
    "
! !

!XWDReader methodsFor:'writing'!

save:image onStream:aStream
    "Save as a version 7 color X11 window dump file (xwd) to the file fileName.
     This produces a mapped color table with 16 bit color.  The xwd file can be 
     viewed by the xwud program and printed with xpr.  
     No compression is performed.

     See the file ...include/X11/XWDFile.h for a definition of the format."

    "
     Notice:
        this method was adapted from a goody in the uiuc archive 
        (Prime time freeware).
        The original files header is:
            NAME            imageToXWD
            AUTHOR          Brad Schoening <brad@boole.com>
            FUNCTION        Writes a Smalltalk image to an X11 xwd file
            ST-VERSION      PPST 4.0 or 4.1
            DISTRIBUTION    world
            VERSION         1.0
            DATE            July 1993

        thanks to Brad for giving us the base for this mehtod.
    "

    |rgbColor paletteColors ncolors dumpName headerSize|

    (self class canRepresent:image) ifFalse:[
        ^ Image cannotRepresentImageSignal 
            raiseWith:image
            errorString:('XWD format cannot represent this image').
    ].

    image mask notNil ifTrue:[
        Image informationLostQuerySignal
            raiseWith:image
            errorString:('XWD format does not support an imageMask').
    ].

    dumpName := 'stdin'.
    headerSize := 4 * (25 + (dumpName size / 4) ceiling).
    paletteColors := image palette "colors".
    ncolors := paletteColors size.

    "create the header (each item is 32 bits long)"

    aStream binary.
    aStream nextLongPut: headerSize.                                "total header size in bytes"
    aStream nextLongPut: 7.                                         "XWD file version"
    aStream nextLongPut: 2.                                         "pixmap format : ZPixmap"
    aStream nextLongPut: 8.                                         "pixmap depth"
    aStream nextLongPut: image width.                               "pixmap cols"
    aStream nextLongPut: image height.                              "pixmap rows"
    aStream nextLongPut: 0.                                         "bitmap x offset"
    aStream nextLongPut: 1.                                         "byte order: MSBFirst"
    aStream nextLongPut: 8.                                         "bitmap unit"
    aStream nextLongPut: 1.                                         "bitmap bit order: MSBFirst"
    aStream nextLongPut: 8.                                         "bitmap scanline pad"
    aStream nextLongPut: 8.                                         "bits per pixel"
    aStream nextLongPut: image width.                               "bytes per scanline"
    aStream nextLongPut: 3.                                         "colormap class : PseudoColor"
    aStream nextLongPut: 0.                                         "Z red mask"
    aStream nextLongPut: 0.                                         "Z green mask"
    aStream nextLongPut: 0.                                         "Z blue mask"
    aStream nextLongPut: 8.                                         "bits per rgb"
    aStream nextLongPut: 256.                                       "number of color map entries"
    aStream nextLongPut: ncolors.                                   "number of color structures"
    aStream nextLongPut: image width.                               "window width"
    aStream nextLongPut: image height.                              "window height"
    aStream nextLongPut: 0.                                         "window upper left x coordinate"
    aStream nextLongPut: 0.                                         "window upper left y coordinate"
    aStream nextLongPut: 0.                                         "window border width"
    aStream nextPutAll: dumpName asByteArray.       "name of dump"
    "Pad the string to the next 32-bit boundary"
    aStream nextPut: 0. "/ 6
    aStream nextPut: 0. "/ 7
    aStream nextPut: 0. "/ 8

"/    [(aStream position1Based rem: 4) == 0] whileFalse: [ aStream nextPut: 0 ].

    "Write out the color table.  Each color table entry is 12 bytes long composed of:
                    an index                (4 bytes)
                    red color value         (2 bytes)
                    green color value       (2 bytes)
                    blue color value        (2 bytes)
                    flag values             (1 byte)
                    pad                     (1 byte)
    "
    0 to: ncolors-1 do: [ :index |
        |r g b|

        aStream nextLongPut: index.
        rgbColor := paletteColors at: (1+index).
        (rgbColor isNil) ifTrue: [ rgbColor := ColorValue white ].
        r := (rgbColor red / 100.0 * 65535) rounded.
        g := (rgbColor green / 100.0 * 65535) rounded.
        b := (rgbColor blue / 100.0 * 65535) rounded.

        aStream nextWordPut:r.
        aStream nextWordPut:g.
        aStream nextWordPut:b.
        aStream nextPut: 7.                     "flags"
        aStream nextPut: 0.                     "pad"
    ].

    "Write out the pixels as index color values"
"/    Cursor write showWhile: [ 
"/            |cindex|
"/
"/            1 to: (image height) do: [ :row |
"/                    1 to: (image width) do: [ :col |
"/                            cindex := image atPoint: (col-1)@(row-1).
"/                            aStream nextPut: cindex.]]
"/    ].
    aStream nextPutAll:image bits.

    "
     XWDReader save:(Image fromUser) onFile: '/tmp/st.xwd' 
     (Image fromFile: '/tmp/st.xwd') inspect 
    "

    "Modified: 27.2.1997 / 12:45:15 / cg"
! !

!XWDReader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/XWDReader.st,v 1.27 2003-11-19 15:24:16 cg Exp $'
! !


XWDReader initialize!
