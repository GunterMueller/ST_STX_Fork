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

MappedPalette subclass:#MonoMappedPalette
	instanceVariableNames:''
	classVariableNames:'WhiteBlack BlackWhite'
	poolDictionaries:''
	category:'Graphics-Images-Support'
!

!MonoMappedPalette class methodsFor:'documentation'!

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

!MonoMappedPalette class methodsFor:'instance creation'!

blackWhite
    BlackWhite isNil ifTrue:[
        BlackWhite := super blackWhite
    ].
    ^ BlackWhite
!

whiteBlack
    WhiteBlack isNil ifTrue:[
        WhiteBlack := super whiteBlack
    ].
    ^ WhiteBlack
! !

!MonoMappedPalette methodsFor:'accessing'!

at:index put:aColor
    self error:'this palette cannot be changed'.
! !

!MonoMappedPalette class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/MonoMappedPalette.st,v 1.3 2003-05-06 18:26:28 cg Exp $'
! !
