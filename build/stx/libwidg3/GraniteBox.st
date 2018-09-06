"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'private' }"

WoodenBox subclass:#GraniteBox
	instanceVariableNames:''
	classVariableNames:'Texture'
	poolDictionaries:''
	category:'Views-Fun'
!

!GraniteBox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    see examples in WoodenBox

    [see also:]
        WoodenBox WoodenMenu PullDownMenu

"
! !

!GraniteBox class methodsFor:'cleanup'!

lowSpaceCleanup
    "cleanup in low-memory situations"

    Texture := nil

    "
     Smalltalk allClassesDo:[:aClass |
	aClass lowSpaceCleanup
     ]
    "
    "
     GraniteBox lowSpaceCleanup
    "


! !

!GraniteBox methodsFor:'initialization'!

initColors
    mediumColor := Color grey:30.
    lightColor := Color grey:50.
    veryLightColor := Color grey:80.
!

textureH
    "redefined to return another texture"

    |t|

    Texture isNil ifTrue:[
        t := Smalltalk imageFromFileNamed:'granite.tiff' inPackage:'stx:libwidg3'.
        t notNil ifTrue:[
            Texture := t on:device.
        ]
    ].
    ^ Texture

    "
     Texture := nil
    "
!

textureV
    "redefined to return another texture"

    ^ self textureH
! !

!GraniteBox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/GraniteBox.st,v 1.7 2000-08-16 15:44:09 cg Exp $'
! !
