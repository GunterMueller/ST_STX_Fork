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

Depth1Image subclass:#ImageMask
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!ImageMask class methodsFor:'documentation'!

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
    instances of this class represent image masks;
    if added to an image (via #mask:), only pixels for which the 
    corresponding mask pixel is 1 are drawn.

    ImageMask does not add anything new - basically, its a depth1-image.

    [See also:]
        Image ImageReader

    [author:]
        Claus Gittinger
"

! !

!ImageMask methodsFor:'initialization'!

initialize
    super initialize.
    bitsPerSample := samplesPerPixel := 1.
! !

!ImageMask methodsFor:'private'!

colormapFromImage:anImage
    "I have no colormap"

    photometric := #blackIs0.
    ^ self

    "Created: / 18.5.1999 / 20:09:25 / cg"
! !

!ImageMask methodsFor:'queries'!

isMask
    ^ true

    "Created: 22.4.1997 / 14:12:20 / cg"
! !

!ImageMask class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview/ImageMask.st,v 1.4 2014-05-23 08:17:29 stefan Exp $'
! !

