"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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

ColorPalette subclass:#FixedPalette
	instanceVariableNames:'redShift redMask greenShift greenMask blueShift blueMask'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Support'
!

!FixedPalette class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
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
    This class will (sooner or later) take over and/or redefine some of the Colormap functionality.
    This migration will be done both to cleanup the code and for VW compatibility.

    Notice: For now, the whole functionality is still in Colormap

    [see also:]
	Color Image Form
"
! !

!FixedPalette class methodsFor:'instance creation'!

redShift:reds redMask:redm greenShift:grns greenMask:grnm blueShift:blus blueMask:blum
    ^ self new 
	redShift:reds redMask:redm 
	greenShift:grns greenMask:grnm 
	blueShift:blus blueMask:blum

    "Created: 20.6.1997 / 16:15:15 / cg"
! !

!FixedPalette methodsFor:'initialization'!

redShift:rs redMask:rm greenShift:gs greenMask:gm blueShift:bs blueMask:bm
    redShift := rs.
    redMask := rm.
    greenShift := gs.
    greenMask := gm.
    blueShift := bs.
    blueMask := bm

    "Created: 20.6.1997 / 16:16:49 / cg"
! !

!FixedPalette methodsFor:'printing & storing'!

displayString
    ^ self storeString
!

printOn:aStream
    self storeOn:aStream
!

storeInstVarsOn:aStream
    aStream nextPutAll:' redShift:'. redShift storeOn:aStream.
    aStream nextPutAll:' redMask:'. redMask storeOn:aStream.
    aStream nextPutAll:' greenShift:'. greenShift storeOn:aStream.
    aStream nextPutAll:' greenMask:'. greenMask storeOn:aStream.
    aStream nextPutAll:' blueShift:'. blueShift storeOn:aStream.
    aStream nextPutAll:' blueMask:'. blueMask storeOn:aStream.
!

storeOn:aStream
    aStream nextPutAll:'(' , self class name. 
    self storeInstVarsOn:aStream.
    aStream nextPutAll:')'.
! !

!FixedPalette methodsFor:'queries'!

alphaByteAt:index
    "return the (simulated) alphaByte at index.
     Notice that index is 1.."

    ^ 0
!

bitsAlpha
    ^ 0
!

bitsBlue
    ^ blueMask highBit
!

bitsGreen
    ^ greenMask highBit
!

bitsRed
    ^ redMask highBit
!

blueByteAt:index
    "return the (simulated) blueByte at index.
     Notice that index is 1.."

    |b bb|

    blueMask == 0 ifTrue:[^ 0]. "/ no blue component
    
    b := ((index-1 bitShift:blueShift negated) bitAnd:blueMask).
    bb := (b * 255.0 / (blueMask)) rounded.
    ^ bb

    "
     (FixedPalette redShift:16 redMask:16rFF greenShift:8 greenMask:16rFF blueShift:0 blueMask:16rFF) blueByteAt:16rFFFFFF+1  
     (FixedPalette redShift:10 redMask:16r1F greenShift:5 greenMask:16r1F blueShift:0 blueMask:16r1F) blueByteAt:16r7FFF+1  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) blueByteAt:16rFFFF+1  

     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) blueByteAt:0+1  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) blueByteAt:16r7FFF+1  
    "
!

greenByteAt:index
    "return the (simulated) greenByte at index.
     Notice that index is 1.."

    |g gb|

    greenMask == 0 ifTrue:[^ 0]. "/ no green component

    g := ((index-1 bitShift:greenShift negated) bitAnd:greenMask).
    gb := (g * 255.0 / (greenMask)) rounded.
    ^ gb

    "
     (FixedPalette redShift:16 redMask:16rFF greenShift:8 greenMask:16rFF blueShift:0 blueMask:16rFF) greenByteAt:16rFFFFFF+1  
     (FixedPalette redShift:10 redMask:16r1F greenShift:5 greenMask:16r1F blueShift:0 blueMask:16r1F) greenByteAt:16r7FFF+1  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) greenByteAt:16rFFFF+1  

     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) greenByteAt:0+1  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) greenByteAt:16r7FFF+1  
    "
!

isFixedPalette
    ^ true
!

redByteAt:index
    "return the (simulated) redByte at index.
     Notice that index is 1.."

    |r rb|

    redMask == 0 ifTrue:[^ 0]. "/ no red component

    r := ((index-1 bitShift:redShift negated) bitAnd:redMask).
    rb := (r * 255.0 / (redMask)) rounded.
    ^ rb

    "
     (FixedPalette redShift:16 redMask:16rFF greenShift:8 greenMask:16rFF blueShift:0 blueMask:16rFF) redByteAt:16rFFFFFF+1  
     (FixedPalette redShift:10 redMask:16r1F greenShift:5 greenMask:16r1F blueShift:0 blueMask:16r1F) redByteAt:16r7FFF+1  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) redByteAt:16rFFFF+1  

     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) redByteAt:0+1  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) redByteAt:16r7FFF+1  
    "
!

size
    "return the number of (simulated) colors in this colormap"

    ^ ((redMask bitShift:redShift)
        + (greenMask bitShift:greenShift)
        + (blueMask bitShift:blueShift)) + 1 

    "
     (FixedPalette redShift:16 redMask:16rFF greenShift:8 greenMask:16rFF blueShift:0 blueMask:16rFF) size  
     (FixedPalette redShift:10 redMask:16r1F greenShift:5 greenMask:16r1F blueShift:0 blueMask:16r1F) size  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) size  
    "
! !

!FixedPalette class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

