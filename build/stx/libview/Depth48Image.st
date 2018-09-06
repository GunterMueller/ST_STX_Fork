"
 COPYRIGHT (c) 2009 by eXept Software AG
 COPYRIGHT (c) 2018 Patrik Svestka
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

Image subclass:#Depth48Image
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!Depth48Image class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    this class represents 48 bit images as possibly provided by png 3x16bit rgb images.
    Such images are normally not used in real world applications, as humans cannot differentiate 
    more than roughly 200 distinct color tone values. However, in image processing (false-color) applications,
    such a fine grain image makes sense and is sometimes used.

    [author:]
        Claus Gittinger

    [see also:]
        Depth1Image Depth2Image Depth4Image Depth8Image Depth16Image Depth24Image Depth32Image
        ImageReader
"
! !

!Depth48Image class methodsFor:'queries'!

defaultPhotometric
    "return the default photometric pixel interpretation"

    ^ #rgb
!

imageDepth
    "return the depth of images represented by instances of
     this class - here we return 48"

    ^ 48
! !

!Depth48Image methodsFor:'accessing-pixels'!

pixelAtX:x y:y
    "retrieve a pixel at x/y; return a pixelValue.
     The interpretation of the returned value depends on the photometric
     and the colormap. See also Image>>atX:y:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel.
     The pixel value contains r/g/b in msb order (i.e. r at high, a at low bits)"

    |pixelIndex "{ Class: SmallInteger }"|

    pixelFunction notNil ifTrue:[^ pixelFunction value:x value:y].

    pixelIndex := (width * 6 * y) + 1 + (x * 6).

    ^ ((bytes unsignedInt16At:pixelIndex MSB:true) bitShift:32)
    + ((bytes unsignedInt16At:pixelIndex+2 MSB:true) bitShift:16)
    + (bytes unsignedInt16At:pixelIndex+4 MSB:true).
!

pixelAtX:x y:y put:aPixelValue
    "set the pixel at x/y to aPixelValue.
     The interpretation of the pixelValue depends on the photometric
     and the colormap. (see also: Image>>atX:y:put:)
     Pixels start at x=0 , y=0 for upper left pixel, end at
     x = width-1, y=height-1 for lower right pixel"

    |pixelIndex "{ Class: SmallInteger }"|

    pixelIndex := (width * 6 * y) + 1 + (x * 6).
    bytes isNil ifTrue:[
        self createPixelStore
    ].
    bytes unsignedInt16At:pixelIndex put:((aPixelValue bitShift:-32) bitAnd:16rFFFF) MSB:true.
    bytes unsignedInt16At:pixelIndex+2 put:((aPixelValue bitShift:-16) bitAnd:16rFFFF) MSB:true.
    bytes unsignedInt16At:pixelIndex+4 put:(aPixelValue bitAnd:16rFFFF) MSB:true.
! !

!Depth48Image methodsFor:'initialization'!

initialize
    super initialize.
    samplesPerPixel := 3. 
    bitsPerSample := #[16 16 16].

    "Modified: / 30-01-2017 / 19:32:29 / stefan"
! !

!Depth48Image methodsFor:'queries'!

bitsPerPixel
    "return the number of bits per pixel"

    ^ 48
!

bitsPerRow
    "return the number of bits in one scanline of the image"

    ^ width * 48
!

bytesPerRow
    "return the number of bytes in one scanline of the image"

    ^ width * 6.
!

isDepth48Image
    "return true if the image is instance of Depth48Image"
   (self bitsPerPixel == 48) ifTrue:[^ true].  
    ^ false

    "Created: / 16-04-2018 / 17:02:03 / svestkap"
! !

!Depth48Image class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

