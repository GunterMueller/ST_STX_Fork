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

Depth8Image subclass:#AlphaMask
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!AlphaMask class methodsFor:'documentation'!

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
    instances of this class will eventually be used to represent an
    images alpha channel information;
    if added to an image (via #mask:), pixels will be merged with underlying
    destination pixels according to the alpha value.
    However, alpha-image drawing is not yet implemented in the current version.

    AlphaMask does not add anything new - basically, its a depth8-image.

    [See also:]
        Image ImageReader

    [author:]
        Claus Gittinger
"


!

examples
"
    examples to be added.
"
!

history
    "Created: 22.4.1997 / 14:12:53 / cg"
! !

!AlphaMask methodsFor:'queries'!

isMask
    ^ true

    "Created: 22.4.1997 / 14:12:13 / cg"
! !

!AlphaMask class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/AlphaMask.st,v 1.1 1997-04-22 12:17:09 cg Exp $'
! !

