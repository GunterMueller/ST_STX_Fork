"
 COPYRIGHT (c) 2003 by eXept Software AG
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

Object subclass:#MultiImage
	instanceVariableNames:'images'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!MultiImage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    A multiImage is an image which is drawn by drawing multiple images on top of each other.

    [author:]
        Claus Gittinger
"
! !

!MultiImage class methodsFor:'instance creation'!

images:imageCollection
    ^ self new images:imageCollection
! !

!MultiImage methodsFor:'accessing'!

device
    images isNil ifTrue:[^ nil].
    ^ images first device
!

images
    "return the value of the instance variable 'images' (automatically generated)"

    ^ images
!

images:something
    "set the value of the instance variable 'images' (automatically generated)"

    images := something.
! !

!MultiImage methodsFor:'displaying'!

displayOn:aGC x:x y:y opaque:opaque
    |doOpaque|

    doOpaque := opaque.
    images do:[:eachImage |
        eachImage displayOn:aGC x:x y:y opaque:doOpaque.
        doOpaque := false.
    ].
! !

!MultiImage methodsFor:'misc'!

clearMaskedPixels
    images := images do:[:eachImage | eachImage clearMaskedPixels].
    ^ self
!

onDevice:device
    images := images collect:[:eachImage | (eachImage onDevice:device) ? eachImage].
    ^ self
! !


!MultiImage methodsFor:'queries'!

ascentOn:aGC
    "I will not draw myself above the baseline"

    ^ 0
!

depth
    ^ images inject:0 into:[:maxSoFar :eachImage | maxSoFar max:eachImage depth].
!

extent
    ^ self width @ self height
!

height  
    ^ images inject:0 into:[:maxSoFar :eachImage | maxSoFar max:eachImage height].
!

isImageOrForm
    ^ true
!

width
    ^ images inject:0 into:[:maxSoFar :eachImage | maxSoFar max:eachImage width].
! !

!MultiImage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/MultiImage.st,v 1.10 2015-03-26 10:07:18 cg Exp $'
! !

