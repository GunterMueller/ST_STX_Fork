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

ColorPalette subclass:#MappedPalette
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Support'
!

!MappedPalette class methodsFor:'documentation'!

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

!MappedPalette class methodsFor:'instance creation'!

blackWhite
    "ST-80 compatibility"

    ^ self withColors:(Array with:(Color black) with:(Color white))
!

monochromeDefault
    "ST-80 compatibility"

    ^ self whiteBlack

    "Modified: 25.2.1997 / 18:57:34 / cg"
!

whiteBlack
    "ST-80 compatibility"

    ^ self withColors:(Array with:(Color white) with:(Color black))

    "
     self whiteBlack
    "

    "Created: 7.10.1996 / 11:29:01 / cg"
    "Modified: 14.2.1997 / 17:43:31 / cg"
! !

!MappedPalette class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/MappedPalette.st,v 1.5 2003-05-06 18:26:22 cg Exp $'
! !
