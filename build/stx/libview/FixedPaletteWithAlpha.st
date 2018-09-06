"
 COPYRIGHT (c) 2016 by Claus Gittinger
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

FixedPalette subclass:#FixedPaletteWithAlpha
	instanceVariableNames:'alphaShift alphaMask'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Support'
!

!FixedPaletteWithAlpha class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!FixedPaletteWithAlpha methodsFor:'accessing'!

alphaShift:alphaShiftArg alphaMask:alphaMaskArg 
    alphaShift := alphaShiftArg.
    alphaMask := alphaMaskArg.
! !

!FixedPaletteWithAlpha methodsFor:'printing & storing'!

size
    "return the number of (simulated) colors in this colormap"

    ^ ((alphaMask bitShift:alphaShift)
        + (redMask bitShift:redShift)
        + (greenMask bitShift:greenShift)
        + (blueMask bitShift:blueShift)) + 1 
!

storeInstVarsOn:aStream
    super storeInstVarsOn:aStream.
    aStream nextPutAll:' alphaShift:'. alphaShift storeOn:aStream.
    aStream nextPutAll:' alphaMask:'. alphaMask storeOn:aStream.
! !

!FixedPaletteWithAlpha methodsFor:'queries'!

alphaByteAt:index
    "return the (simulated) alphaByte at index.
     Notice that index is 1.."

    |a aa|

    alphaMask == 0 ifTrue:[^ 0]. "/ no alpha component
    
    a := ((index-1 bitShift:alphaShift negated) bitAnd:alphaMask).
    aa := (a * 255.0 / (alphaMask)) rounded.
    ^ aa

    "
     (FixedPalette redShift:16 redMask:16rFF greenShift:8 greenMask:16rFF blueShift:0 blueMask:16rFF) blueByteAt:16rFFFFFF+1  
     (FixedPalette redShift:10 redMask:16r1F greenShift:5 greenMask:16r1F blueShift:0 blueMask:16r1F) blueByteAt:16r7FFF+1  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) blueByteAt:16rFFFF+1  

     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) blueByteAt:0+1  
     (FixedPalette redShift:11 redMask:16r1F greenShift:5 greenMask:16r3F blueShift:0 blueMask:16r1F) blueByteAt:16r7FFF+1  
    "
!

bitsAlpha
    ^ alphaMask highBit
! !

!FixedPaletteWithAlpha class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

