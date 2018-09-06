"
 COPYRIGHT (c) 1999 by eXept Software AG
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

Color subclass:#TranslucentColor
	instanceVariableNames:'alpha'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Support'
!

!TranslucentColor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    TranslucentColor represents colors with an alpha (transparency) channel.
    This is experimental and not yet used by the system.

    [Instance variables:]

      alpha           <Integer>       the internal alpha value (0..255)
"
! !

!TranslucentColor class methodsFor:'instance creation'!

red:r green:g blue:b alpha:alpha
    alpha = 1 ifTrue:[
	^ super red:r green:g blue:b
    ].
    ^ (super
	   scaledRed:(r * MaxValue // 100)
	   scaledGreen:(g * MaxValue // 100)
	   scaledBlue:(b * MaxValue // 100)) alpha:alpha

! !

!TranslucentColor methodsFor:'accessing'!

alpha
    "return the alpha value (0..1),
     where 0 is completely transparent and 1 is completely opaque"

    ^ alpha asFloat / 255.0


!

alpha:alphaFraction
    "set the alpha value (0..1),
     where 0 is completely transparent and 1 is completely opaque"

    alpha := (alphaFraction * 255) rounded
!

alphaByte
    "return the alpha value as byte 0..255,
     where 0 is completely transparent and 255 is completely opaque"

    ^ alpha
!

privateAlpha
    "return the internal alpha value (0..255),
     where 0 is completely transparent and 255 is completely opaque"

    ^ alpha
!

scaledAlpha
    "return the alpha value (0..16rFFFF),
     where 0 is completely transparent and 16rFFFF is completely opaque"

    ^ alpha * 16rFFFF // 255
!

setAlphaByte:aByteValuedInteger
    "set the alpha value (0..255),
     where 0 is completely transparent and 255 is completely opaque"

    alpha := aByteValuedInteger


! !

!TranslucentColor methodsFor:'printing & storing'!

storeOn:aStream
    "append a string representing an expression to reconstruct the receiver
     to the argument, aStream"

    |clsName|

    clsName := self class name.

    aStream nextPutAll:'(' , clsName , ' red:'.
    (self red) storeOn:aStream.
    aStream nextPutAll:' green:'.
    (self green) storeOn:aStream.
    aStream nextPutAll:' blue:'.
    (self blue) storeOn:aStream.
    aStream nextPutAll:' alpha:'.
    (self alpha) storeOn:aStream.
    aStream nextPut:$).

    "
     (self red:100 green:100 blue:0 alpha:1) storeOn:Transcript
    "
! !

!TranslucentColor methodsFor:'queries'!

isOpaque
    "return true, if I represent an opaque color"

    ^ alpha == 255

!

isTranslucent
    "return true, if I represent a translucent color;
     that is: not completely opaque"

    ^ alpha < 255

!

isTranslucentColor
    "return true, if I represent a translucent color;
     This means: self isTranslucent, but isTransparent not"

    ^ alpha > 0
!

isTransparent
    "return true, if I represent a completely transparent color"

    ^ alpha == 0
! !

!TranslucentColor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

