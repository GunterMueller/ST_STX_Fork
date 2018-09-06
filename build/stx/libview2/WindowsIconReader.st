"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ImageReader subclass:#WindowsIconReader
	instanceVariableNames:'compression inDepth topDown redMask greenMask blueMask alphaMask
		pngOrJPGImage'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Readers'
!

!WindowsIconReader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    this class provides methods for loading Windows and OS2 icon and bmp files.
    The name is misleading, but due to historic reasons.
    The reader should support allmost all formats: Win2, Win3, Win4, Win5, WINCE and OS2.
    (incl. PNG and JPG compression, and WINCE depth2 images)
    
    Image writing is only supported for BMP format with depth 1,4,8 and 24 bit images.
    
    The reader tries to figure out which version of BMP/ICO is used.
    It seems to be able to load most formats, but who knows ...

    The class name *IconReader is a bad, historic choice - it ws originally
    written to read icons only, but evolved over time and is now also
    capable of reading/writing bmp and cursor files.

    [See also:]
        Image Form Icon
        BlitImageReader FaceReader GIFReader JPEGReader PBMReader PCXReader
        ST80FormReader SunRasterReader TargaReader TIFFReader
        XBMReader XPMReader XWDReader
"
!

fileFormatDescription
"
    Information from http://www.daubnet.com/formats/BMP.html - no Warranty.

          Name           Size      Offset   Description

      Header            14 bytes            Windows Structure: BITMAPFILEHEADER
          Signature      2 bytes      0      'BM'
          FileSize       4 bytes      2      File size in bytes
          reserved       4 bytes      6      unused (=0)
          DataOffset     4 bytes     10      File offset to Raster Data

      InfoHeader        40 bytes            Windows Structure: BITMAPINFOHEADER
        different sizes, depending on Windows-version:
                        12 - Win2.x or OS/2 1.x
                        40 - WinNT, Win3.x or later
                        52 - adds undocumented; adds r/g/b masks
                        56 - adds undocumented; adds r/g/b/a masks
                        64 - OS/2 2.x
                        108 - WinNT4.0, 95 or later
                        124 - WinNT5.0, 98 or later
      
          Size           4 bytes     14      Size of InfoHeader =40
          Width          4 bytes     18      Bitmap Width
          Height         4 bytes     22      Bitmap Height
          Planes         2 bytes     26      Number of Planes (=1)
          BitCount       2 bytes     28      Bits per Pixel
                                             1 = monochrome palette. NumColors = 1
                                             4 = 4bit palletized. NumColors = 16
                                             8 = 8bit palletized. NumColors = 256
                                             16 = 16bit RGB. NumColors = 65536 (?)
                                             24 = 24bit RGB. NumColors = 16M
          Compression    4 bytes     30      Type of Compression
                                             0 = RGB            no compression
                                             1 = RLE8           8bit RLE encoding
                                             2 = RLE4           4bit RLE encoding
                                             3 = BITFIELDS      Windows V3+ only
                                             4 = JPEG           Windows V3+ only
                                             5 = PNG            Windows V3+ only
                                             6 = ALPHA_BITFIELDS Windows CE only
        
                                             3 = HUFFMAN1D      OS/2 2.x-only
                                             4 = RLE24          OS/2 2.x-only


          ImageSize      4 bytes     34      (compressed) Size of Image
                                             It is valid to set this =0 if Compression = 0
          XpixelsPerM    4 bytes     38      horizontal resolution: Pixels/meter
          YpixelsPerM    4 bytes     42      vertical resolution: Pixels/meter
          ColorsUsed     4 bytes     46      Number of actually used colors
          ColorsImportant
                         4 bytes     50      Number of important colors
                                             0 = all

       ColorTable        4 * NumColors bytes (3 on Win2)
                                             present only if Info.BitsPerPixel <= 8
                                             colors should be ordered by importance

            Red           1 byte              Red intensity
            Green         1 byte              Green intensity
            Blue          1 byte              Blue intensity
            reserved      1 byte             unused (=0)
          repeated NumColors times

       Raster Data      Info.ImageSize bytes     The pixel data


Raster Data encoding:
       Depending on the image's BitCount and on the Compression flag there are 6 different encoding schemes.
       All of them share the following:

       Pixels are stored bottom-up, left-to-right. Pixel lines are padded with zeros to end on a 32bit (4byte) boundary. For
       uncompressed formats every line will have the same number of bytes. Color indices are zero based, meaning a pixel
       color of 0 represents the first color table entry, a pixel color of 255 (if there are that many) represents the 256th entry.
       For images with more than 256 colors there is no color table.

Raster Data encoding for 1bit / black & white images:
       BitCount = 1 Compression = 0
       Every byte holds 8 pixels, its highest order bit representing the leftmost pixel of those. There are 2 color table entries.
       Some readers will ignore them though, and assume that 0 is black and 1 is white. If you are storing black and white
       pictures you should stick to this, with any other 2 colors this is not an issue. Remember padding with zeros up to a
       32bit boundary (This can be up to 31 zeros/pixels!!)

Raster Data encoding for 4bit / 16 color images:
       BitCount = 4 Compression = 0
       Every byte holds 2 pixels, its high order 4 bits representing the left of those. There are 16 color table entries. These
       colors do not have to be the 16 MS-Windows standard colors. Padding each line with zeros up to a 32bit boundary
       will result in up to 28 zeros = 7 'wasted pixels'.

Raster Data encoding for 8bit / 256 color images:
       BitCount = 8 Compression = 0
       Every byte holds 1 pixel. There are 256 color table entries. Padding each line with zeros up to a 32bit boundary will
       result in up to 3 bytes of zeros = 3 'wasted pixels'.

Raster Data encoding for 16bit / hicolor images:
       BitCount = 16 Compression = 0
       Every 2bytes / 16bit holds 1 pixel.
       <information missing: the 16 bit was introduced together with Video For Windows? Is it a memory-only-format?>
       The pixels are no color table pointers. There are no color table entries. Padding each line with zeros up to a 16bit
       boundary will result in up to 2 zero bytes.

Raster Data encoding for 24bit / truecolor images:
       BitCount = 24 Compression = 0
       Every 4bytes / 32bit holds 1 pixel. The first holds its red, the second its green, and the third its blue intensity. The
       fourth byte is reserved and should be zero. There are no color table entries. The pixels are no color table pointers. No
       zero padding necessary.


Raster Data compression for 4bit / 16 color images:
       BitCount = 4 Compression = 2
       The pixel data is stored in 2bytes / 16bit chunks.  The first of these specifies the number of consecutive pixels with the
       same pair of color. The second byte defines two color indices. The resulting pixel pattern will be interleaved
       high-order 4bits and low order 4 bits (ABABA...). If the first byte is zero, the second defines an escape code. The
       End-of-Bitmap is zero padded to end on a 32bit boundary. Due to the 16bit-ness of this structure this will always be
       either two zero bytes or none.

        n (byte 1) c (Byte 2)                                       Description
        >0        any      n pixels are to be drawn. The 1st, 3rd, 5th, ... pixels' color is in c's high-order 4 bits, the even
                            pixels' color is in c's low-order 4 bits. If both color indices are the same, it results in just n
                            pixels of color c
        0         0        End-of-line
        0         1        End-of-Bitmap
        0         2        Delta. The following 2 bytes define an unsigned offset in x and y direction (y being up) The
                            skipped pixels should get a color zero.
        0         >=3      The following c bytes will be read as single pixel colors just as in uncompressed files. up to 12
                            bits of zeros follow, to put the file/memory pointer on a 16bit boundary again.


                                      Example for 4bit RLE
        Compressed Data                           Expanded data
        03 04              0 4 0
        05 06              0 6 0 6 0
        00 06 45 56 67 00  4 5 5 6 6 7
        04 78              7 8 7 8
        00 02 05 01        Move 5 right and 1 up. (Windows docs say down, which is wrong)
        00 00              End-of-line
        09 1E              1 E 1 E 1 E 1 E 1
        00 01              EndofBitmap
        00 00              Zero padding for 32bit boundary


Raster Data compression for 8bit / 256 color images:

       BitCount = 8 Compression = 1
       The pixel data is stored in 2bytes / 16bit chunks.  The first of these specifies the number of consecutive pixels with the
       same color. The second byte defines their color index. If the first byte is zero, the second defines an escape code. The
       End-of-Bitmap is zero padded to end on a 32bit boundary. Due to the 16bit-ness of this structure this will always be
       either two zero bytes or none.

        n (byte 1)   c (Byte 2)                                    Description
        >0       any        n pixels of color number c
        0        0          End-of-line
        0        1          End Of Bitmap
        0        2          Delta. The following 2 bytes define an unsigned offset in x and y direction (y being up) The
                            skipped pixels should get a color zero.
        0        >=3        The following c bytes will be read as single pixel colors just as in uncompressed files. A zero
                            follows, if c is odd, putting the file/memory pointer on a 16bit boundary again.


                                      Example for 8bit RLE
        Compressed Data                           Expanded data
        03 04              04 04 04
        05 06              06 06 06 06 06
        00 03 45 56 67 00  45 56 67
        02 78              78 78
        00 02 05 01        Move 5 right and 1 up. (Windows docs say down, which is wrong)
        00 00              End-of-line
        09 1E              1E 1E 1E 1E 1E 1E 1E 1E 1E
        00 01              End-of-bitmap
        00 00              Zero padding for 32bit boundary

Portability:

       Although BMPs were invented by Microsoft for its Windows platform, a lot of programs on other platforms are capable
       of reading and writing them. Notice the Intel order in 2byte and 4-byte integer values (Least significant byte first). The
       16bit BMPs have been introduced to Windows after the others, still puzzling many applications.


Trademarks, Patents and Royalties
       To my knowledge: None.
"
! !

!WindowsIconReader class methodsFor:'initialization'!

initialize
    "tell Image-class, that a new fileReader is present
     for the '.bmp' and '.ico' extensions."

    MIMETypes defineImageType:'image/x-MS-bitmap' suffix:'bmp' reader:self.
    MIMETypes defineImageType:'image/x-ms-bitmap' suffix:'bmp' reader:self.
    MIMETypes defineImageType:'image/bmp'         suffix:'bmp' reader:self.
    MIMETypes defineImageType:nil                 suffix:'ico' reader:self.

    "Modified: 1.2.1997 / 15:03:59 / cg"
! !

!WindowsIconReader class methodsFor:'testing'!

canRepresent:anImage
    "return true, if anImage can be represented in my file format.
     BMP supports depth 1,4,8 and 24."

    (#(1 4 8 24 32) includes:anImage depth) ifTrue:[^true].
    ('WindwsIconReader [info]: image depth is not 1,4,8 or 24.') infoPrintCR.
    ^ false

    "Created: 17.10.1997 / 20:18:23 / cg"
!

isValidImageFile:aFileName
    "return true, if aFileName contains a valid windows bitmap-file image"

    |inStream header ok|

    inStream := self streamReadingFile:aFileName.
    inStream isNil ifTrue:[^ false].

    inStream binary.
    ok := false.
    inStream fileSize > 16 ifTrue:[
	header := ByteArray uninitializedNew:4.
	inStream nextBytes:4 into:header.

	(header startsWith:#(66 77)) ifTrue:[     "BM"
	    ok := true.
"/            'WINREADER: Win3.x or OS/2 vsn 2 BM format' infoPrintNL.
	].
	(header startsWith:#(66 65)) ifTrue:[     "BA"
	    ok := true.
"/            'WINREADER: OS/2 vsn 2 BA format' infoPrintNL.
	].
	(header startsWith:#(73 67)) ifTrue:[     "IC"
	    ok := true.
"/            'WINREADER: OS/2 IC format' infoPrintNL.
	].
	(header startsWith:#(80 84)) ifTrue:[     "PT"
	    ok := true.
"/            'WINREADER: OS/2 PT format' infoPrintNL.
	].
	(header startsWith:#(0 0 1 0)) ifTrue:[
	    ok := true.
"/            'WINREADER: Win3.x ICO format' infoPrintNL.
	].
    ].
    inStream close.
    ^ ok

    "
     WindowsIconReader isValidImageFile:'/phys/clam2/LocalLibrary/Images/OS2_icons/dos.ico'
    "

    "Created: 17.9.1995 / 17:14:20 / claus"
! !

!WindowsIconReader methodsFor:'accessing'!

image
    pngOrJPGImage notNil ifTrue:[^ pngOrJPGImage].
    ^ super image
! !

!WindowsIconReader methodsFor:'private'!

bitsPerPixel
    ^ inDepth
!

convertPixels
    "/ figure out, how pixels should be processed,
    "/ according to the order of r/g/b components and masks
    "/ bring the pixels to a standard format:
    "/  rgb888/rgba8888 if possible and useful
    "/ 
    |swapAction redShift greenShift blueShift alphaShift pixelAction
     numRedBits numGreenBits numBlueBits numAlphaBits needPixelProcessing|

    inDepth == 1 ifTrue:[
        colorMap isNil ifTrue:[
            photometric := #blackIs0
        ] ifFalse:[
            photometric := #palette.
            colorMap size == 2 ifTrue:[
                ((colorMap at:1) = (Color white)
                and:[(colorMap at:2) = (Color black)]) ifTrue:[
                    photometric := #whiteIs0.
                    colorMap := nil.
                ] ifFalse:[
                    ((colorMap at:1) = (Color black)
                    and:[(colorMap at:2) = (Color white)]) ifTrue:[
                        photometric := #blackIs0.
                        colorMap := nil.
                    ]
                ].                    
            ].
        ].
        samplesPerPixel := 1.
        bitsPerSample := Array with:inDepth.
        ^ self.
    ].

    ((inDepth > 8) and:[redMask notNil]) ifTrue:[
        numRedBits   := redMask bitCount.
        numGreenBits := greenMask bitCount.
        numBlueBits  := blueMask bitCount.
        numAlphaBits := alphaMask bitCount.
        redShift := redMask lowBit - 1.
        greenShift  := greenMask lowBit - 1.
        blueShift  := blueMask lowBit - 1.
        alphaShift := alphaMask lowBit - 1.

        alphaMask == 0 ifTrue:[
            photometric := #rgb.
            samplesPerPixel := 3
        ] ifFalse:[    
            photometric := #rgba.
            samplesPerPixel := 4
        ].
        needPixelProcessing := false.
        
        inDepth == 16 ifTrue:[
            alphaMask == 0 ifTrue:[
                bitsPerSample := {numRedBits. numGreenBits. numBlueBits}.
                colorMap := FixedPalette
                                redShift:redShift redMask:(redMask >> redShift)
                                greenShift:greenShift greenMask:(greenMask >> greenShift)
                                blueShift:blueShift blueMask:(blueMask >> blueShift).
                photometric := #palette.
            ] ifFalse:[
                bitsPerSample := {numRedBits. numGreenBits. numBlueBits. numAlphaBits }.
                colorMap := FixedPaletteWithAlpha
                                redShift:redShift redMask:(redMask >> redShift)
                                greenShift:greenShift greenMask:(greenMask >> greenShift)
                                blueShift:blueShift blueMask:(blueMask >> blueShift).
                colorMap alphaShift:alphaShift alphaMask:(alphaMask >> alphaShift).                
                photometric := #palette.
            ].
            swapAction := [:bytes | data swapBytes].                
        ].    
        inDepth == 24 ifTrue:[
            (redShift ~~ 0
                or:[ greenShift ~~ 8
                or:[ blueShift ~~ 16
                or:[ numRedBits ~~ 8
                or:[ numGreenBits ~~ 8
                or:[ numBlueBits ~~ 8
                or:[ alphaMask ~~ 0]]]]]]
            ) ifTrue:[ 
                (redShift == 16 
                    and:[greenShift == 8
                    and:[blueShift == 0
                    and:[numRedBits == 8
                    and:[numGreenBits == 8
                    and:[numBlueBits == 8
                    and:[alphaMask == 0]]]]]]
                ) ifTrue:[
                    "/ common case: swap r and b
                    swapAction := [:data | self swapBytesFromRGB_to_BGR].
                ] ifFalse:[    
                    needPixelProcessing := true
                ].    
            ].    
            bitsPerSample := #(8 8 8).
            photometric := #rgb.
        ].    
        inDepth == 32 ifTrue:[
            (redShift ~~ 0
                or:[ greenShift ~~ 8
                or:[ redShift ~~ 16
                or:[ numRedBits ~~ 8
                or:[ numGreenBits ~~ 8
                or:[ numBlueBits ~~ 8
                or:[ alphaMask ~~ 0 and:[ alphaShift ~~ 24]]]]]]]
            ) ifTrue:[ 
                (redShift == 16 
                    and:[greenShift == 8
                    and:[blueShift == 0
                    and:[alphaShift == 24
                    and:[numRedBits == 8
                    and:[numGreenBits == 8
                    and:[numBlueBits == 8
                    and:[numAlphaBits == 8]]]]]]]
                ) ifTrue:[
                    "/ common case: swap r and b
                    swapAction := [:data | self swapBytesFromRGBA_to_BGRA].
                ] ifFalse:[    
                    needPixelProcessing := true
                ].    
            ].    
            bitsPerSample := #(8 8 8 8).
            photometric := #rgba.
        ].
        
        needPixelProcessing ifTrue:[ 
            alphaMask == 0 ifTrue:[
                pixelAction := [:v |
                                |r g b|
                                r := (v bitAnd:redMask) >> redShift.
                                g := (v bitAnd:greenMask) >> greenShift.
                                b := (v bitAnd:blueMask) >> blueShift.
                                (((b bitShift:8) bitOr:g) bitShift:8) bitOr:r
                               ].
            ] ifFalse:[    
                pixelAction := [:v |
                                |r g b a|
                                r := (v bitAnd:redMask) >> redShift.
                                g := (v bitAnd:greenMask) >> greenShift.
                                b := (v bitAnd:blueMask) >> blueShift.
                                a := (v bitAnd:alphaMask) >> alphaShift.
                                (((((a bitShift:8) bitOr:b) bitShift:8) bitOr:g) bitShift:8) bitOr:r
                               ].
            ].
        ].    
    ] ifFalse:[
        inDepth <= 8 ifTrue:[
            photometric := #palette.
        ] ifFalse:[    
            inDepth == 16 ifTrue:[
                bitsPerSample := #(5 5 5).
                colorMap := FixedPalette
                                redShift:10 redMask:16r1f
                                greenShift:5 greenMask:16r1f
                                blueShift:0 blueMask:16r1F.
                photometric := #palette.
                swapAction := [:bytes | data swapBytes].                
            ].    
            inDepth == 24 ifTrue:[
                bitsPerSample := #(8 8 8).
                photometric := #rgb.
                swapAction := [:data | self swapBytesFromRGB_to_BGR].
            ].    
            inDepth == 32 ifTrue:[
                bitsPerSample := #(8 8 8 8).
                photometric := #rgba.
                swapAction := [:data | self swapBytesFromRGBA_to_BGRA].
            ].    
        ].    
    ].    

    "/ Depth32Image keeps its data r/g/b/a; BMP has it b/g/r/a (sigh)
    pixelAction notNil ifTrue:[
        inDepth == 16 ifTrue:[
            swapAction := 
                [:byteArray | 
                    |idx rowIdx oldValue newValue bpr|
                    rowIdx := 1.
                    bpr := self bytesPerRow.

                    1 to:height do:[:y |
                        idx := rowIdx.
                        1 to:width do:[:x |
                            oldValue := data unsignedInt16At:idx MSB:false.
                            newValue := pixelAction value:oldValue.
                            data unsignedInt16At:idx put:newValue MSB:true.
                            idx := idx + 2.
                        ].    
                        rowIdx := rowIdx + bpr.
                    ]
               ].                 
        ].    
        inDepth == 24 ifTrue:[
            swapAction := 
                [:byteArray | 
                    |idx rowIdx oldValue newValue bpr|
                    rowIdx := 1.
                    bpr := self bytesPerRow.

                    1 to:height do:[:y |
                        idx := rowIdx.
                        1 to:width do:[:x |
                            oldValue := data unsignedIntegerAt:idx length:3 bigEndian:false.
                            newValue := pixelAction value:oldValue.
                            data unsignedIntegerAt:idx put:newValue length:3 bigEndian:true.
                            idx := idx + 3.
                        ].    
                        rowIdx := rowIdx + bpr.
                    ]
               ].                 
        ].    
        inDepth == 32 ifTrue:[
            swapAction := 
                [:byteArray | 
                    |idx rowIdx oldValue newValue bpr|
                    rowIdx := 1.
                    bpr := self bytesPerRow.
                    
                    1 to:height do:[:y |
                        idx := rowIdx.
                        1 to:width do:[:x |
                            oldValue := data unsignedInt32At:idx MSB:false.
                            newValue := pixelAction value:oldValue.
                            data unsignedInt32At:idx put:newValue MSB:false.
                            idx := idx + 4.
                        ].    
                        rowIdx := rowIdx + bpr.
                    ]
               ].                 
        ].
    ].
    swapAction notNil ifTrue:[
        swapAction value:data
    ].
!

loadBMP1From:aStream into:aByteArray
    "load bmp-1 bit per pixel imagedata."

    compression == 0 ifFalse:[
	^ false
    ].

    ^ self loadUncompressedFrom:aStream into:aByteArray
!

loadBMP2From:aStream into:aByteArray
    "load bmp-2 bit per pixel imagedata."

    compression == 0 ifFalse:[
	^ false
    ].

    ^ self loadUncompressedFrom:aStream into:aByteArray
!

loadBMP4From:aStream into:aByteArray
    "load bmp-4 bit per pixel imagedata."

    compression == 0 ifTrue:[
	^ self loadUncompressedFrom:aStream into:aByteArray
    ].
    compression == 2 ifTrue:[
	^ self loadRLECompressedBMP4From:aStream into:aByteArray
    ].

    ^ false
!

loadBMPWidth:w height:h bytesPerPixel:bpp from:aStream into:aByteArray
    "load bmp-16/24/32 bit per pixel imagedata."

    |dstIdx fileBytesPerRow imgBytesPerRow skip align lineDelta|

    align := 4.

    ((compression == 0) or:[compression == 3]) ifFalse:[
        "/ 'BMPReader: unsupported compression: ' infoPrint. compression infoPrintCR. 
        self fileFormatError:('unsupported compression:', compression printString).
        ^ false.
    ].

    imgBytesPerRow := w * bpp.
    fileBytesPerRow := imgBytesPerRow.
    (fileBytesPerRow bitAnd:(align-1)) ~~ 0 ifTrue:[
        fileBytesPerRow := (fileBytesPerRow bitAnd:((align-1) bitInvert)) + align.
    ].
    
    topDown ifTrue:[
        dstIdx := 1.
        lineDelta := imgBytesPerRow
    ] ifFalse:[
        dstIdx := imgBytesPerRow * (h - 1) + 1.
        lineDelta := imgBytesPerRow negated
    ].
    
    (lineDelta == fileBytesPerRow) ifTrue:[
        (aStream nextBytes:(fileBytesPerRow*h) into:aByteArray startingAt:dstIdx) == (fileBytesPerRow*h) ifFalse:[
            ^ false
        ].
    ] ifFalse:[    
        skip := fileBytesPerRow - imgBytesPerRow.
        1 to:h do:[:row |
            (aStream nextBytes:imgBytesPerRow into:aByteArray startingAt:dstIdx) == imgBytesPerRow ifFalse:[
                ^ false
            ].
            skip ~~ 0 ifTrue:[ aStream skip:skip ].
            dstIdx := dstIdx + lineDelta.
        ].
    ].
    ^ true
!

loadBMPWidth:w height:h depth:d from:aStream into:aByteArray
    "helper: load a BMP image"

    d == 8 ifTrue:[
        compression == 0 ifTrue:[
            ^ self loadUncompressedFrom:aStream into:aByteArray.
        ].
        compression == 1 ifTrue:[
            ^ self loadRLECompressedBMP8From:aStream into:aByteArray.
        ].
        "/ self breakPoint:#cg info:'unhandled compression'.
        self fileFormatError:('unsupported compression:', compression printString).
        ^ false
    ].
    d == 4 ifTrue:[
        ^ self loadBMP4From:aStream into:aByteArray
    ].
    d == 2 ifTrue:[
        ^ self loadBMP2From:aStream into:aByteArray
    ].
    d == 1 ifTrue:[
        ^ self loadBMP1From:aStream into:aByteArray
    ].
    ((d == 16)
    or:[ (d == 24)
    or:[ (d == 32) ]]) ifTrue:[
        (self loadBMPWidth:w height:h bytesPerPixel:(d // 8) from:aStream into:aByteArray) ifFalse:[
            ^ false
        ].
        ^ true
    ].
    self fileFormatError:('unsupported depth:', d printString).
    ^ false

    "Created: / 17.9.1995 / 18:48:11 / claus"
    "Modified: / 3.2.1998 / 20:21:16 / cg"
!

loadRLECompressedBMP4From:aStream into:aByteArray
    "load bmp-rle-4 pixel imagedata"

    |bytesPerRow x y dstIndex lineStartIndex cnt pair clr1 clr2 code nbyte byte bytes byteIdx rev|

    bytesPerRow := self bytesPerRow.
    x := 0.
    
    topDown ifTrue:[
        y := 0.
        lineStartIndex := 1.
    ] ifFalse:[
        y := height - 1.
        lineStartIndex := (y * bytesPerRow) + 1.
    ].
    dstIndex := lineStartIndex.
    "/ data atAllPut:16rBB.

    [ y between:0 and:height-1 ] whileTrue:[
        cnt := aStream nextByte.
        pair := aStream nextByte.
        cnt ~~ 0 ifTrue:[
            ((x between:0 and:width-1) and:[y between:0 and:height-1]) ifFalse:[
                self breakPoint:#cg.
                self fileFormatError:('invalid delta').
            ].    
            "/ Transcript printf:'RUN y: %d x: %d cnt: %d pair: %02x\n' with:y with:x with:cnt with:pair.
            x even ifTrue:[
                (cnt >= 2) ifTrue:[
                    nbyte := cnt // 2.
                    aByteArray from:dstIndex to:(dstIndex+nbyte-1) put:pair.
                    dstIndex := dstIndex + nbyte.
                ].
                cnt odd ifTrue:[
                    "/ got odd count
                    byte := aByteArray at:dstIndex.
                    aByteArray at:dstIndex put:((byte bitAnd:16r0F) bitOr:(pair bitAnd:16rF0)).
                    "/ self halt.
                ].    
            ] ifFalse:[
                clr1 := pair bitShift:-4. "/ left bit
                clr2 := pair bitAnd:16rF. "/ right bit

                "/ the first odd-x halfbyte
                byte := aByteArray at:dstIndex.
                aByteArray at:dstIndex put:((byte bitAnd:16rF0) bitOr:clr1).
                dstIndex := dstIndex + 1.

                nbyte := (cnt-1) // 2.
                nbyte > 0 ifTrue:[
                    rev := (clr2 << 4) bitOr:clr1.
                    aByteArray from:dstIndex to:(dstIndex+nbyte-1) put:rev.
                    dstIndex := dstIndex + nbyte.
                ].
                cnt even ifTrue:[
                    "/ the final odd-x halfbyte
                    byte := aByteArray at:dstIndex.
                    aByteArray at:dstIndex put:((byte bitAnd:16r0F) bitOr:(clr2 bitShift:4)).
                ].    
            ].
            x := x + cnt.
        ] ifFalse:[
            "/ cnt == 0: escape codes */
            code := pair.
            code == 0 ifTrue:[
                "/ end of line
                "/ Transcript printf:'EOL\n'.
                x := 0.
                topDown ifTrue:[
                    y := y + 1.
                    lineStartIndex := lineStartIndex + bytesPerRow.
                ] ifFalse:[    
                    y := y - 1.
                    lineStartIndex := lineStartIndex - bytesPerRow.
                ].    
                dstIndex := lineStartIndex.
            ] ifFalse:[
                code == 1 ifTrue:[
                    "/ Transcript printf:'END\n'.
                    "/ end of pic
                    ^ true
                ].
                code == 2 ifTrue:[
                    "/ delta
                    x := x + aStream nextSignedByte.
                    y := y - aStream nextSignedByte.
                    "/ Transcript printf:'MOVE y: %d x: %d\n' with:y with:x with:code.
                    lineStartIndex := (y * bytesPerRow) + 1.
                    dstIndex := lineStartIndex + (x//2).
                ] ifFalse:[
                    "/ absolute; cnt pixels coming
                    ((x between:0 and:width-1) and:[y between:0 and:height-1]) ifFalse:[
                        self breakPoint:#cg.
                        self fileFormatError:('invalid delta').
                    ].    
                    cnt := code.
                    nbyte := (cnt+1) // 2.
                    bytes := aStream nextBytes:nbyte.
                    "/ odd byte count - padd
                    nbyte odd ifTrue:[
                        aStream skip:1.
                    ].
                    x + cnt > width ifTrue:[self halt].
                    byteIdx := 1.
                    "/ Transcript printf:'PIXELS: %d x: %d count: %d nbyte: %d\n' with:y with:x with:cnt with:nbyte.
                    x even ifTrue:[
                        nbyte := cnt // 2.
                        aByteArray replaceFrom:dstIndex to:(dstIndex+nbyte-1) with:bytes startingAt:byteIdx.
                        byteIdx := byteIdx + nbyte.
                        dstIndex := dstIndex + nbyte.
                        cnt odd ifTrue:[
                            "/ the last half-byte
                            pair := bytes at:byteIdx.
                            byte := aByteArray at:dstIndex.
                            aByteArray at:dstIndex put:((byte bitAnd:16r0F) bitOr:(pair bitAnd:16rF0)).
                            "/ self halt.
                        ].
                    ] ifFalse:[
                        nbyte := (cnt // 2).
                        [nbyte > 0] whileTrue:[
                            pair := bytes at:byteIdx. byteIdx := byteIdx + 1.
                            byte := aByteArray at:dstIndex.
                            aByteArray at:dstIndex put:((byte bitAnd:16rF0) bitOr:((pair bitShift:-4) bitAnd:16r0F)).
                            dstIndex := dstIndex + 1.
                            byte := aByteArray at:dstIndex.
                            aByteArray at:dstIndex put:((byte bitAnd:16r0F) bitOr:((pair bitShift:4) bitAnd:16rF0)).
                            nbyte := nbyte - 1.
                        ].
                        cnt odd ifTrue:[
                            pair := bytes at:byteIdx. byteIdx := byteIdx + 1.
                            byte := aByteArray at:dstIndex.
                            aByteArray at:dstIndex put:((byte bitAnd:16rF0) bitOr:((pair bitShift:-4) bitAnd:16r0F)).
                            dstIndex := dstIndex + 1.
                        ].    
                    ].    
                    x := x + cnt. 
                ].
            ].
        ].
    ].
    ^ true.
!

loadRLECompressedBMP8From:aStream into:aByteArray
    "load bmp-8 bit per pixel imagedata"

    |bytesPerRowInData x y dstIndex lineStartIndex cnt clr code n|

    bytesPerRowInData := self bytesPerRow.
    x := 0.

    topDown ifTrue:[
        y := 0.
        lineStartIndex := 1.
    ] ifFalse:[
        y := height - 1.
        lineStartIndex := (y * bytesPerRowInData) + 1.
    ].    
    dstIndex := lineStartIndex.
    
    [ y between:0 and:height-1 ] whileTrue:[
        cnt := aStream nextByte.
        clr := aStream nextByte.
        cnt ~~ 0 ifTrue:[
            aByteArray from:dstIndex to:dstIndex+cnt-1 put:clr.
            x := x + cnt.
            dstIndex := dstIndex + cnt.
        ] ifFalse:[
            "/ cnt == 0: escape codes */
            code := clr.
            code == 0 ifTrue:[
                "/ end of line
                x := 0.
                topDown ifTrue:[
                    y := y + 1.
                    lineStartIndex := lineStartIndex + bytesPerRowInData.
                ] ifFalse:[    
                    y := y - 1.
                    lineStartIndex := lineStartIndex - bytesPerRowInData.
                ].
                dstIndex := lineStartIndex.
            ] ifFalse:[
                code == 1 ifTrue:[
                    "/ end of pic
                    ^ true
                ].
                code == 2 ifTrue:[
                    "/ delta
                    x := x + aStream nextSignedByte.
                    y := y - aStream nextSignedByte.
                    lineStartIndex := (y * bytesPerRowInData) + 1.
                    dstIndex := lineStartIndex + x.
                ] ifFalse:[
                    "/ absolute; cnt pixels coming
                    cnt := code.
                    n := aStream nextBytes:cnt into:aByteArray startingAt:dstIndex.
                    n ~~ cnt ifTrue:[^ false].
                    x := x + cnt.
                    dstIndex := dstIndex + cnt.
                    "/ odd count - padd
                    cnt odd ifTrue:[
                        aStream skip:1.
                    ].
                ].
            ].
        ].
    ].
    ^ true.
!

loadUncompressedFrom:aStream into:aByteArray
    "load bmp-1,2,4 and 8 bit per pixel imagedata."

    |bytesPerRowInStream bytesPerRowInData skip n
     dstIndex  "{ Class: SmallInteger }" 
     lineDelta "{ Class: SmallInteger }" 
     nRows     "{ Class: SmallInteger }" |

    compression == 0 ifFalse:[
        ^ false
    ].

    bytesPerRowInStream := Image bytesPerRowForWidth:width depth:inDepth padding:32.
    bytesPerRowInData := self bytesPerRow.
    skip := bytesPerRowInStream - bytesPerRowInData.

    topDown ifTrue:[
        dstIndex := 1.
        lineDelta := bytesPerRowInData.
    ] ifFalse:[    
        "/ bottom row first...
        dstIndex := (height - 1) * bytesPerRowInData + 1.
        lineDelta := bytesPerRowInData negated.
    ].
    nRows := height.
    
    1 to:nRows do:[:row |
        n := aStream nextBytes:bytesPerRowInData into:aByteArray startingAt:dstIndex.
        n ~~ bytesPerRowInData ifTrue:[^ false].
        skip ~~ 0 ifTrue:[aStream skip:skip].
        dstIndex := dstIndex + lineDelta.
    ].
    ^ true.
!

readColorMap:nColors numBytesPerColor:nRawBytesPerColor from:aStream
    "read the colormap; notice: its in BGR order (sigh)."

    |rawMap rMap gMap bMap
     srcIndex  "{ Class: SmallInteger }"|

    rawMap := ByteArray uninitializedNew:(nColors*nRawBytesPerColor).
    aStream nextBytes:(nColors*nRawBytesPerColor) into:rawMap.

    rMap := ByteArray new:nColors.
    gMap := ByteArray new:nColors.
    bMap := ByteArray new:nColors.
    srcIndex := 1.

    "/ stupid: this is a BGR-ordered map (otherwise, could use #rgbBytesVector:-message)
    "/ also, there might be a fourth byte (alpha ?) which is (currently) skipped.
    1 to:nColors do:[:i |
        bMap at:i put:(rawMap at:srcIndex).
        gMap at:i put:(rawMap at:srcIndex+1).
        rMap at:i put:(rawMap at:srcIndex+2).
        srcIndex := srcIndex + nRawBytesPerColor.
    ].

    ^ MappedPalette
        redVector:rMap
        greenVector:gMap
        blueVector:bMap.
!

swapBytesFromRGBA_to_BGRA
    |idx bytesPerRow|

    "/ Depth32Image keeps its data r/g/b/a; BMP has it b/g/r/a (sigh)
    idx := 1.
    bytesPerRow := self bytesPerRow.
    1 to:height do:[:y |
        self class swap:width pixelsFromRGB_to_BGR_in:data startingAt:idx bytesPerPixel:4.
        idx := idx + bytesPerRow.
    ].
!

swapBytesFromRGB_to_BGR
    |idx bytesPerRow|

    "/ Depth24Image keeps its data r/g/b; BMP has it b/g/r (sigh)
    idx := 1.
    bytesPerRow := self bytesPerRow.
    1 to:height do:[:y |
        self class swap:width pixelsFromRGB_to_BGR_in:data startingAt:idx bytesPerPixel:3.
        idx := idx + bytesPerRow.
    ].
! !

!WindowsIconReader methodsFor:'reading'!

fromOS2File:aFilename
    "read an image from an OS/2 BMP file"

    |reader stream|

    stream := self class streamReadingFile:aFilename.
    stream isNil ifTrue:[^ nil].
    reader := self class new.
    reader fromOS2Stream:stream.
    stream close.
    ^ reader image

    "Modified: / 30-05-2007 / 16:52:50 / cg"
!

fromOS2Stream:aStream
    "read an image from an OS/2 BMP stream"

    ^ self fromOS2Stream:aStream alreadyRead:nil
!

fromOS2Stream:aStream alreadyRead:bytesAlreadyRead
    "read an image from an OS/2 BMP stream"

    |header inBytesPerRow mask bytesPerRow nColors nByte|

    inStream := aStream.
    aStream binary.
    byteOrder := #lsb.

    "read the header"

    header := ByteArray uninitializedNew:8r110.
    bytesAlreadyRead size > 0 ifTrue:[
        header replaceFrom:1 with:bytesAlreadyRead
    ].
    aStream nextBytes:(16-bytesAlreadyRead size) into:header startingAt:(1+bytesAlreadyRead size).

    (header startsWith:#(73 67)) ifTrue:[         "IC"
        "IC format"
        aStream nextBytes:10 into:header startingAt:17.
        width := header at:7.
        height := header at:9.
        inDepth := 2 "header at:11". "where is it"
    ] ifFalse:[
        (header startsWith:#(67 73)) ifTrue:[     "CI"
            ^ self fileFormatError:'unsupported format: CI'.
        ] ifFalse:[
            aStream nextBytes:(8r110-16) into:header startingAt:17.
            width := header at:8r101.
            height := header at:8r103.
            inDepth := header at:8r107.
        ]
    ].

    self reportDimension.

    "read the colormap; notice: its in BGR order (sigh)"

    nColors := 1 bitShift:inDepth.
    colorMap := self readColorMap:nColors numBytesPerColor:3 from:aStream.

    "read the mask"

    nByte := ((width * height) + 7) // 8.
    mask := ByteArray uninitializedNew:nByte.
    aStream nextBytes:nByte into:mask.

    "what is this ?"

    aStream nextBytes:nByte into:mask.

"/    "read the data bits"
"/
"/    bytesPerRow := width * inDepth + 7 // 8.
"/    data4 := ByteArray uninitializedNew:(height * bytesPerRow).
"/    inDepth == 8 ifTrue:[
"/    ].
"/    aStream nextBytes:(height * bytesPerRow) into:data4.
"/
"/    "stupid: last row first"
"/
"/    tmp := ByteArray new:(height * bytesPerRow).
"/    srcIndex := 1.
"/    dstIndex := (height - 1) * bytesPerRow + 1.
"/    1 to:height do:[:row |
"/        tmp replaceFrom:dstIndex to:(dstIndex + bytesPerRow - 1)
"/                   with:data4 startingAt:srcIndex.
"/        srcIndex := srcIndex + bytesPerRow.
"/        dstIndex := dstIndex - bytesPerRow.
"/    ].
"/    data4 := tmp.
"/
"/    "expand into bytes"
"/
"/    data := ByteArray new:(width * height).
"/    data4 expandPixels:inDepth width:width height:height
"/                  into:data mapping:nil.
"/

    bytesPerRow := ((width * inDepth) + 7) // 8.
    "/ bmp data is always 32bit aligned; if required,
    inBytesPerRow := ((bytesPerRow + 3) // 4) * 4.

    data := ByteArray uninitializedNew:(height * width "bytesPerRow").
    compression := 0.
    (self loadBMPWidth:width height:height depth:inDepth from:aStream into:data) ifFalse:[
        ^ nil
    ].
    photometric := #palette.
    samplesPerPixel := 1.
    bitsPerSample := #(8).
    ^ self image

    "
     |i f|
     i := Image fromFile:'/LocalLibrary/Images/OS2/dos3.ico'.
     f := i asFormOn:Display.
     v displayOpaqueForm:(f magnifiedBy:2@2) x:5 y:5
    "

    "Modified: / 17-09-1995 / 18:49:24 / claus"
    "Modified: / 30-05-2007 / 16:53:24 / cg"
!

fromStream:aStream
    "figure out which format the stream contains
     (there are various different bmp/ico formats around)
     and read the image."

    |fileSize header|

    inStream := aStream.
    byteOrder := #lsb.

    aStream binary.
    aStream signalAtEnd:true.
    aStream isFileStream ifTrue:[
        fileSize := aStream fileSize.
        fileSize < 16 ifTrue:[
            ^ self fileFormatError:'short/corrupted file'.
        ].
    ].

    EndOfStreamError handle:[:ex |
        ^ self fileFormatError:'unexpected EOF while reading (short/corrupted file)'.
    ] do:[    
        header := ByteArray uninitializedNew:4.
        aStream nextBytes:4 into:header.

        (header startsWith:#(66 77)) ifTrue:[     "BM"
            "/ 'WinIconReader [info]: Win3.x or OS/2 vsn 2 BM format' infoPrintNL.
            ^ self fromWindowsBMPStream:aStream alreadyRead:header
        ].
        (header startsWith:#(66 65)) ifTrue:[     "BA"
            "/ 'WinIconReader [info]: OS/2 vsn 2 BA format' infoPrintNL.
            ^ self fromOS2Stream:aStream alreadyRead:header
        ].
        (header startsWith:#(67 73)) ifTrue:[     "CI"
            "/ 'WinIconReader [info]: OS/2 vsn 2 BA format' infoPrintNL.
            "/ ^ self fromOS2Stream:aStream
            ^ self fileFormatError:'OS/2 CI format not supported'.
        ].
        (header startsWith:#(73 67)) ifTrue:[     "IC"
            "/ 'WinIconReader [info]: OS/2 IC format' infoPrintNL.
            ^ self fromOS2Stream:aStream alreadyRead:header
        ].
        (header startsWith:#(80 84)) ifTrue:[     "PT"
            "/ 'WinIconReader [info]: OS/2 PT format' infoPrintNL.
            ^ self fromOS2Stream:aStream alreadyRead:header
        ].
        (header startsWith:#(16r53 16r5A)) ifTrue:[     "SZ"
            "/ 'WinIconReader [info]: OS/2 SZ format' infoPrintNL.
            "/ ^ self fromOS2Stream:aStream
            ^ self fileFormatError:'OS/2 SZ format not supported'.
        ].
        (header startsWith:#(0 0 1 0)) ifTrue:[
            "/ 'WinIconReader [info]: Win3.x ICO format' infoPrintNL.
            ^ self fromWindowsICOStream:aStream alreadyRead:header
        ].
    ].
    
    ^ self fileFormatError:('format not supported: %02x %02x' printfWith:(header at:1) with:(header at:2))

    "
     Image fromFile:'/phys/clam//LocalLibrary/Images/OS2_icons/dos.ico'
    "

    "Modified: / 17.9.1995 / 18:59:07 / claus"
    "Modified: / 3.2.1998 / 20:18:14 / cg"
!

fromWindowsBMPFile: aFilename
    "read an image from a windows BMP file"

    |reader stream|

    stream := self class streamReadingFile:aFilename.
    stream isNil ifTrue:[^ nil].
    reader := self class new.
    reader fromWindowsBMPStream:stream.
    stream close.
    ^ reader image.

    "Modified: / 30-05-2007 / 16:53:48 / cg"
!

fromWindowsBMPStream:aStream
    "read an image from a windows BMP stream"

    ^ self fromWindowsBMPStream:aStream alreadyRead:nil
!

fromWindowsBMPStream:aStream alreadyRead:bytesAlreadyRead
    "read an image from a windows BMP stream"

    | fileHeader bitmapHeader iSize inPlanes
      imgSize resH resV numColor numImportantColor
      dataStart 
      bytesPerRow numBytesPerColorInColormap|

    inStream := aStream.
    aStream binary.
    byteOrder := #lsb.
    topDown := false.

    "read the header"

    fileHeader := ByteArray new:14.
    bytesAlreadyRead size > 0 ifTrue:[
        fileHeader replaceFrom:1 with:bytesAlreadyRead
    ].
    aStream nextBytes:(14-bytesAlreadyRead size) into:fileHeader startingAt:(1+bytesAlreadyRead size).

    iSize := aStream nextUnsignedInt32MSB:false.
    iSize > 124 ifTrue:[
        ^ self fileFormatError:'unknown format'.
    ].

    bitmapHeader := ByteArray new:iSize+16. "/ reserve to allow masks to be read with iSize=40 
    aStream nextBytes:(iSize-4) into:bitmapHeader startingAt:(1+4).

    dataStart := fileHeader unsignedInt32At:(10 + 1) MSB:false.

    alphaMask := 0.

    ((iSize == 40) or:[iSize == 52 or:[iSize == 56 or:[iSize == 108 or:[iSize == 124]]]]) ifTrue:[    "header-size"
        "/
        "/ a Windows3.x BMP file (40)
        "/ a Windows4.x BMP file (108)
        "/ a Windows5.x BMP file (124)
        "/
        "/ 'WinIconReader [info]: Win3.x/Win4.x/Win5.x format' infoPrintCR.

        width := bitmapHeader unsignedInt32At:(4 + 1) MSB:false.
        height := bitmapHeader signedInt32At:(8 + 1) MSB:false.
        inPlanes := bitmapHeader unsignedInt16At:(12 + 1) MSB:false.
        inDepth := bitmapHeader unsignedInt16At:(14 + 1) MSB:false.
        compression := bitmapHeader unsignedInt32At:(16 + 1) MSB:false.
        imgSize := bitmapHeader unsignedInt32At:(20 + 1) MSB:false.
        resH := bitmapHeader unsignedInt32At:(24 + 1) MSB:false.
        resV := bitmapHeader unsignedInt32At:(28 + 1) MSB:false.
        numColor := bitmapHeader unsignedInt32At:(32 + 1) MSB:false.
        numImportantColor := bitmapHeader unsignedInt32At:(36 + 1) MSB:false.
        
        (compression > 3) ifTrue:[
            compression == 4 ifTrue:[
                "/ JPG in data
                aStream position:dataStart.
                pngOrJPGImage := JPEGReader fromStream:aStream.
                ^ pngOrJPGImage
            ].    
            compression == 5 ifTrue:[
                "/ PNG in data
                aStream position:dataStart.
                pngOrJPGImage := PNGReader fromStream:aStream.
                ^ pngOrJPGImage
            ].    
            compression == 6 ifTrue:[
                "/ very seldom - alphamask compression
            ] ifFalse:[    
                ^ self fileFormatError:'unhandled compression'.
            ].    
        ].
        
        (iSize == 40 and:[(compression == 3) or:[compression == 6]]) ifTrue:[
            "/ masks are not counted in header (sigh)
            compression == 6 ifTrue:[
                aStream next:4*4 into:bitmapHeader startingAt:iSize+1.
                alphaMask := bitmapHeader unsignedInt32At:(52 + 1) MSB:false.
                compression := 3.
            ] ifFalse:[        
                aStream next:4*3 into:bitmapHeader startingAt:iSize+1.
            ].    
            redMask := bitmapHeader unsignedInt32At:(40 + 1) MSB:false.
            greenMask := bitmapHeader unsignedInt32At:(44 + 1) MSB:false.
            blueMask := bitmapHeader unsignedInt32At:(48 + 1) MSB:false.
        ] ifFalse:[        
            iSize > 40 ifTrue:[
                "/ masks are counted in header (sigh)
                ((compression == 3) or:[iSize == 108]) ifTrue:[
                    iSize >= 52 ifTrue:[
                        redMask := bitmapHeader unsignedInt32At:(40 + 1) MSB:false.
                        greenMask := bitmapHeader unsignedInt32At:(44 + 1) MSB:false.
                        blueMask := bitmapHeader unsignedInt32At:(48 + 1) MSB:false.
                        iSize >= 56 ifTrue:[
                            alphaMask := bitmapHeader unsignedInt32At:(52 + 1) MSB:false.
                        ].
                    ].
                ].
            ].
        ].
        
        numColor == 0 ifTrue:[
            "if 0 and depth is 8 or smaller, then the colormap has the size for the depth"
            inDepth <= 8 ifTrue:[
                numColor := 1 bitShift:inDepth.
            ]
        ].

        numBytesPerColorInColormap := 4.
    ] ifFalse:[
        ((iSize == 12) or:[ (iSize == 16) or:[iSize == 64]]) ifTrue:[
            "/
            "/ its a Win2.x or OS/2 BMP file
            "/
            "/ 'WinIconReader [info]: Win2.x or OS/2 format' infoPrintCR.

            numBytesPerColorInColormap := 3.

            iSize == 64 ifTrue:[
                "/
                "/ its an OS/2 (vsn2) BMP file
                "/
                width := bitmapHeader unsignedInt32At:(4 + 1) MSB:false.
                height := bitmapHeader signedInt32At:(8 + 1) MSB:false.
                inPlanes := bitmapHeader unsignedInt16At:(12 + 1) MSB:false.
                inDepth := bitmapHeader unsignedInt16At:(14 + 1) MSB:false.
                compression := bitmapHeader unsignedInt32At:(16 + 1) MSB:false.
                numColor := bitmapHeader unsignedInt32At:(32 + 1) MSB:false.
                numImportantColor := bitmapHeader unsignedInt32At:(36 + 1) MSB:false.
                (compression > 2) ifTrue:[
                    "/ 3 = HUFFMAN; 4 = RLE24
                    ^ self fileFormatError:'unhandled OS2 compression'.
                ].
                numColor == 0 ifTrue:[
                    self halt.
                    "if 0 and depth is 8 or smaller, then the colormap has the size for the depth"
                    inDepth <= 8 ifTrue:[
                        numColor := 1 bitShift:inDepth.
                    ].    
                ].    
                numBytesPerColorInColormap := 4.
            ] ifFalse:[    
                iSize == 16 ifTrue:[
                    "/ an OS2 bitmap with large dimensions
                    width := bitmapHeader unsignedInt32At:(4 + 1) MSB:false.
                    height := bitmapHeader signedInt32At:(8 + 1) MSB:false.
                    inPlanes := bitmapHeader unsignedInt16At:(12 + 1) MSB:false.
                    inDepth := bitmapHeader unsignedInt16At:(14 + 1) MSB:false.
                    numBytesPerColorInColormap := 4.
                ] ifFalse:[
                    "/ size == 12:
                    "/ a Win2.x bitmap
                    width := bitmapHeader unsignedInt16At:(4 + 1) MSB:false.
                    height := bitmapHeader signedInt16At:(6 + 1) MSB:false.
                    inPlanes := bitmapHeader unsignedInt16At:(8 + 1) MSB:false.
                    inDepth := bitmapHeader unsignedInt16At:(10 + 1) MSB:false.
                ].
                compression := 0.
                inDepth <= 8 ifTrue:[
                    numColor := 1 bitShift:inDepth.
                ].    
            ].
        ] ifFalse:[
            ^ self fileFormatError:'unknown format'.
        ].
    ].

    topDown := false.
    height < 0 ifTrue:[
        height := height negated.
        topDown := true.
    ].    
    ((width > 10000) or:[height > 10000]) ifTrue:[
        ^ self fileFormatError:'unreasonable width or height'.
    ].
    
    self reportDimension.

    numColor ~~ 0 ifTrue:[
        "read the colormap - notice: its in BGR order (sigh)"

        numColor > 4096 ifTrue:[
            "/ colormap only allowed up to 12bit
            ^ self fileFormatError:'unreasonable colormap size'.
        ]. 
"/        (dataStart - inStream position) ~= (numBytesPerColorInColormap*numColor) ifTrue:[
"/            self halt
"/        ].    
        
        colorMap := self
                        readColorMap:numColor
                        numBytesPerColor:numBytesPerColorInColormap
                        from:aStream.

        numColor > (1 bitShift:inDepth) ifTrue:[
            'funny number of colors in image' infoPrintCR.
            numColor := 1 bitShift:inDepth.
            colorMap := colorMap copyTo:numColor.
        ].
    ].

    "/ check for valid compression
    compression ~~ 0 ifTrue:[
        "/ some compression
        compression == 1 ifTrue:[
            "/ RLE8 - must be depth-8
            inDepth ~~ 8 ifTrue:[
                ^ self fileFormatError:'RLE8 compression only supported with depth8 images'.
            ].
        ].
        compression == 2 ifTrue:[
            "/ RLE4 - must be depth-4
            inDepth ~~ 4 ifTrue:[
                ^ self fileFormatError:'RLE4 compression only supported with depth4 images'.
            ].
        ].
        compression == 3 ifTrue:[
            "/ BITFIELDS - must be depth-16 or 32
            (inDepth < 16) ifTrue:[
                ^ self fileFormatError:'BITFIELDS compression only supported with depth16/32 images'.
            ].
        ].
        compression >= 4 ifTrue:[
             ^ self fileFormatError:'unsupported compression'.
        ].
    ].

    inPlanes ~~ 1 ifTrue:[
        ^ self fileFormatError:'only 1 plane images supported'.
    ].

    dataStart notNil ifTrue:[
        "/ (dataStart - inStream position) ~~ 0 ifTrue:[self halt].
        
        aStream position:dataStart.
    ].
    
    inDepth == 24 ifTrue:[
        bytesPerRow := width * 3
    ] ifFalse:[
        inDepth == 16 ifTrue:[
            bytesPerRow := width * 2
        ] ifFalse:[
            inDepth == 32 ifTrue:[
                bytesPerRow := width * 4
            ] ifFalse:[
                bitsPerSample := Array with:inDepth.
                bytesPerRow := self bytesPerRow
            ].
        ].
    ].

    data := ByteArray uninitializedNew:(height * bytesPerRow).
    "/ when compressed, there may be holes, which need to be filled with zeros
    ((compression ~~ 0) and:[compression ~~ 3]) ifTrue:[
        data atAllPut:0
    ].
    
    "/ read & possibly decompress

    (self loadBMPWidth:width height:height depth:inDepth from:aStream into:data) ifFalse:[
        self fileFormatError:('read/decompression error').
        ^ nil
    ].

    self convertPixels.
    
    ^ self image

    "Modified: / 17-09-1995 / 18:48:46 / claus"
    "Modified: / 30-05-2007 / 16:57:39 / cg"
!

fromWindowsICOFile:aFilename
    "read an image from a windows ICO file"

    |reader stream|

    stream := self class streamReadingFile:aFilename.
    stream isNil ifTrue:[^ nil].
    reader := self class new.
    reader fromWindowsICOStream:stream.
    stream close.
    ^ reader image.

    "
     Image fromFile:'/phys/clam2//LocalLibrary/Images/WIN_icons/ibm.ico'.
    "

    "Modified: / 30-05-2007 / 16:57:52 / cg"
!

fromWindowsICOStream:aStream
    "read an image from a windows ICO stream"

    ^ self fromWindowsICOStream:aStream alreadyRead:nil
!

fromWindowsICOStream:aStream alreadyRead:bytesAlreadyRead
    "read an image from a windows ICO stream"

    |header
     srcIndex dstIndex
     rawData tmp bytesPerRow nColor cmapSize|

    inStream := aStream.
    aStream binary.

    "read the header"

    header := ByteArray uninitializedNew:(6 + 16 + 40).
    bytesAlreadyRead notEmptyOrNil ifTrue:[
        header replaceFrom:1 with:bytesAlreadyRead
    ].
    aStream nextBytes:((6 + 16 + 40)-bytesAlreadyRead size) into:header startingAt:(1+bytesAlreadyRead size).

    width := header at:(6+1).
    height := header at:(7+1).
    nColor := header at:(8+1).
    "/ reserved := header at:(9+1).
    "/ nPlanes := header wordAt:(10+1).
    "/ nBitsPerPel := header wordAt:(12+1).
    "/ nBytesInResource := header doubleWordAt:(14+1).
    "/ ordinal := header wordAt:(18+1).
    "21, 22               ?"
    "23, ... , 62         ?"

    inDepth := header at:16r25.
    "/ mhmh - some depth4 icons seem to have a 0 in the depth field ...
    inDepth == 0 ifTrue:[
        inDepth := 4
    ].
    (#(4 8 32) includes:inDepth) ifFalse:[
        "/ only tested for depth 4/8 images.
        ^ self fileFormatError:'only depth 4/8/32 ico-images supported (depth is ' , inDepth printString , ')'.
"/        self halt:'only depth 4 ico-images supported (depth is ' , inDepth printString , ')'.
    ].
    self reportDimension.

    nColor > 0 ifTrue:[
        "read the colormap"
        cmapSize := (1 bitShift:inDepth).

        colorMap := self readColorMap:cmapSize numBytesPerColor:4 from:aStream.
    ].

    "read the data bits"

    bytesPerRow := ((width * inDepth) + 7) // 8.
    rawData := ByteArray uninitializedNew:(height * bytesPerRow).
    aStream nextBytes:(height * bytesPerRow) into:rawData.

    "read mask"

"
    mask := ByteArray new:(width * height / 8).
    aStream nextBytes:(width * height / 8) into:mask.
"

    "stupid: last row first"

    tmp := ByteArray uninitializedNew:(height * bytesPerRow).
    srcIndex := 1.
    dstIndex := (height - 1) * bytesPerRow + 1.
    1 to:height do:[:row |
        tmp replaceFrom:dstIndex to:(dstIndex + bytesPerRow - 1)
                   with:rawData startingAt:srcIndex.
        srcIndex := srcIndex + bytesPerRow.
        dstIndex := dstIndex - bytesPerRow.
    ].

    inDepth == 32 ifTrue:[
        srcIndex := 1.
        1 to:height do:[:row |
            1 to:width do:[:row |
                |b1 b2 b3 b4|
                b1 := tmp at:srcIndex.
                b2 := tmp at:srcIndex+1.
                b3 := tmp at:srcIndex+2.
                b4 := tmp at:srcIndex+3.
                tmp at:srcIndex put:b3.
                tmp at:srcIndex+2 put:b1.
                
                srcIndex := srcIndex + 4.
            ].
        ].
    ].

    rawData := tmp.

    nColor > 0 ifTrue:[
        photometric := #palette.
        samplesPerPixel := 1.
        bitsPerSample := (Array with:inDepth).
    ] ifFalse:[
        inDepth == 32 ifTrue:[
            photometric := #rgba.
            samplesPerPixel := 4.
            bitsPerSample := #(8 8 8 8).
        ] ifFalse:[
            ^ self fileFormatError:'unsupported image depth: ' , inDepth printString.
        ]
    ].

    data := rawData.
    ^ self image

    "
     WindowsIconReader new fromWindowsICOFile:'/phys/clam2//LocalLibrary/Images/WIN_icons/ibm.ico'.
    "

    "Modified: / 30-05-2007 / 16:58:11 / cg"
! !

!WindowsIconReader methodsFor:'writing'!

save:image onFile:aFileName
    "save image as BMP file on aFileName.
     Only depth 1,4,8 and 24 images can be represented in this format."

    aFileName asFilename suffix asLowercase = 'ico' ifTrue:[
"/        (image depth == 4
"/        and:[image width == 32
"/        and:[image height == 32]]) ifTrue:[
	    ^ self saveICO:image onFile:aFileName.
"/        ]
    ].
    self saveBMP:image onFile:aFileName.

    "Modified: 17.10.1997 / 20:16:53 / cg"
!

saveBMP:image onFile:fileName
    "save image as BMP file on aFileName.
     Only depth 1,4,8 and 24 images can be represented in this format."

    |depth bhSize biSize biClrUsed biSizeImage bfOffBits rowBytes imgBytesPerRow 
     bits srcIndex row|

    depth := image depth.
    width := image width.
    height := image height.

    (#(1 4 8 24 32) includes:depth) ifFalse:[
        ^ Image cannotRepresentImageSignal
            raiseWith:image
            errorString:('BMP format only supports depths 1,4,8 and 24').
    ].
    image mask notNil ifTrue:[
        Image informationLostQuerySignal
            raiseWith:image
            errorString:('BMP format does not support an imageMask').
    ].

    bhSize := 14.  "# bytes in file header"
    biSize := 40.  "info header size in bytes"
    biClrUsed := (depth >= 24) ifTrue:[0] ifFalse:[1 bitShift: depth].  "No. color table entries"
    bfOffBits := biSize + bhSize + (4*biClrUsed).
    "/ bmp aligns rows on a longword boundary
    rowBytes := (((depth min:32) * width + 31) // 32) * 4.
    biSizeImage := height * rowBytes.

    outStream := fileName asFilename writeStream.
    outStream binary.
    byteOrder := #lsb.

    "Write the file header"
    self writeShort:19778.  "bfType = BM"
    self writeLong:(bfOffBits + biSizeImage).  "Entire file size in bytes"
    self writeLong:0.  "bfReserved"
    self writeLong:bfOffBits.  "Offset of bitmap data from start of hdr (and file)"

    "Write the bitmap info header"
    outStream position: bhSize.
    self writeLong:biSize.  "info header size in bytes"
    self writeLong:width.  "biWidth"
    self writeLong:height.  "biHeight"
    self writeShort:1.  "biPlanes"
    self writeShort:(depth min:32).  "biBitCount"
    self writeLong:0.  "biCompression"
    self writeLong:biSizeImage.  "size of image section in bytes"
    self writeLong:2800.  "biXPelsPerMeter"
    self writeLong:2800.  "biYPelsPerMeter"
    self writeLong:biClrUsed.
    self writeLong:0.  "biClrImportant"
    1 to:biClrUsed do:[:i |  "Color map"
        |clr r g b|

        clr := image colorFromValue:i-1.
        clr isNil ifTrue:[
            r := g := b := 0.
        ] ifFalse:[
            r := clr redByte.
            g := clr greenByte.
            b := clr blueByte.
        ].

        "/ put B,G,R
        outStream nextPut:b.
        outStream nextPut:g.
        outStream nextPut:r.
        outStream nextPut:0.
    ].

    imgBytesPerRow := image bytesPerRow.
    bits := image bits.


    "/ sorry, must extract rows individually
    "/ (even if alignment is correct),
    "/ since BMP saves rows bottom-to-top

    row := ByteArray new:rowBytes.

    srcIndex := 1 + (height * imgBytesPerRow).
    1 to:height do:[:i |
        srcIndex := srcIndex - imgBytesPerRow.
        row replaceFrom:1 to:imgBytesPerRow with:bits startingAt:srcIndex.
        depth >= 24 ifTrue:[
            "/ stupid must swap red & blue bytes
            depth >= 32 ifTrue:[
                self class swap:row size bytesFromRGBA_to_BGRA_in:row startingAt:1.
            ] ifFalse:[
                self class swap:row size bytesFromRGB_to_BGR_in:row startingAt:1.
            ]
        ].
        outStream nextPutAll:row.
    ].

    outStream close.

    "
     |i|

     i := Image fromFile:'bitmaps/SBrowser.xbm'.
     WindowsIconReader save:i onFile:'test.bmp'.
    "

    "
     |i i2|

     i := Image fromFile:'../../goodies/bitmaps/gifImages/garfield.gif'.
     i inspect.
     WindowsIconReader save:i onFile:'garfield.bmp'.
     i2 := Image fromFile:'garfield.bmp'.
     i2 inspect.
    "

    "Modified: 21.10.1997 / 05:02:02 / cg"
!

saveICO:image onFile:fileName
    "save image as ICO file on aFileName.
     Only depth 4 images of size 32x32 can be represented in this format."

    |depth biSizeImage rowBytes imgBytesPerRow data srcIndex row|

    depth := image depth.
    width := image width.
    height := image height.

    depth ~~ 4 ifTrue:[
        ^ Image cannotRepresentImageSignal
            raiseWith:image
            errorString:('ICO format only supports depths 4').
    ].
    (width ~~ 32 or:[height ~~ 32]) ifTrue:[
        ^ Image cannotRepresentImageSignal
            raiseWith:image
            errorString:('ICO format (currently) only supports 32x32 bitmaps').
    ].

    "/ align rows on a longword boundary
    rowBytes := ((depth * width + 31) // 32) * 4.
    biSizeImage := height * rowBytes.

    outStream := fileName asFilename writeStream.
    outStream binary.
    byteOrder := #lsb.

    "Write the file header"
    outStream nextPutAll:#[0 0 1 0].    "/ ICO magic
    self writeShort:1.             "/ # of images in file
    outStream nextPut:image width.      "/
    outStream nextPut:image height.     "/
    outStream nextPut:(1 bitShift:image depth). "/ # of colors
    outStream nextPutAll:#[0 0 0 0 0 ]. "/ reserved
    self writeLong:16rE802.              "/ size pixels
    self writeLong:16r26.                "/ offset in file

    "/ 40 bytes - unknown format
    outStream nextPutAll:(ByteArray new:40).

    "/ 16-entry RGB map

    1 to:16 do:[:i |  "Color map"
        |clr r g b|

        clr := image colorFromValue:i-1.
        clr isNil ifTrue:[
            r := g := b := 0.
        ] ifFalse:[
            r := clr redByte.
            g := clr greenByte.
            b := clr blueByte.
        ].

        "/ put B,G,R
        outStream nextPut:b.
        outStream nextPut:g.
        outStream nextPut:r.
        outStream nextPut:0.
    ].

    imgBytesPerRow := image bytesPerRow.
    data := image bits.


    "/ sorry, must extract rows individually
    "/ (even if alignment is correct),
    "/ since ICO saves rows bottom-to-top

    row := ByteArray new:rowBytes.

    srcIndex := 1 + (height * imgBytesPerRow).
    1 to:height do:[:i |
        srcIndex := srcIndex - imgBytesPerRow.
        row replaceFrom:1 to:imgBytesPerRow with:data startingAt:srcIndex.
        outStream nextPutAll:row.
    ].

    "/ the mask ...
    image mask isNil ifTrue:[
        outStream next:128 put:16rFF
    ] ifFalse:[
        imgBytesPerRow := image mask bytesPerRow.
        data := image mask data.
        row := ByteArray new:4.

        srcIndex := 1 + (height * imgBytesPerRow).
        1 to:height do:[:i |
            srcIndex := srcIndex - imgBytesPerRow.
            row replaceFrom:1 to:imgBytesPerRow with:data startingAt:srcIndex.
            outStream nextPutAll:row.
        ].
    ].

    outStream close.

    "
     |i|

     i := Image fromFile:'bitmaps/xpmBitmaps/SmalltalkX_clr.xpm'.
     i := Depth4Image fromImage:i.
     i := i magnifiedTo:32@32.
     WindowsIconReader new saveICO:i onFile:'test.ico'.
    "

    "Modified: 21.10.1997 / 05:02:02 / cg"
! !

!WindowsIconReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


WindowsIconReader initialize!
