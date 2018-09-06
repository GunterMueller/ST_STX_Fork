"
 COPYRIGHT (c) 1997 by eXept Software AG 
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.


"

"{ Package: 'stx:libview2' }"

Object subclass:#ImageFrame
	instanceVariableNames:'imageHolder delay offset'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!ImageFrame class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG 
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
    an ImageFrame represents a single image in a sequence
    (such as an animated GIF or a movie).
    This class only defines a delayTime (in ms) to the next
    image; specialized subclasses may add additional attributes.

    [author:]
        Claus Gittinger

    [see also:]
        ImageSequence
        Image
"
! !

!ImageFrame methodsFor:'accessing'!

delay
    "return the value of the instance variable 'delay' (automatically generated)"

    ^ delay

    "Created: 21.6.1997 / 13:05:47 / cg"
!

delay:something
    "set the value of the instance variable 'delay' (automatically generated)"

    delay := something.

    "Created: 21.6.1997 / 13:05:47 / cg"
!

image
    "return the image as represented by the imageFrame.
     Here, the imageHolders value is returned"

    ^ imageHolder value

    "Created: 21.6.1997 / 13:05:30 / cg"
!

image:anImage
    "set the image as represented by the imageFrame."

    imageHolder := anImage

    "Created: / 21.6.1997 / 13:05:30 / cg"
    "Modified: / 1.4.1998 / 14:25:33 / cg"
!

imageHolder
    "return the value of the instance variable 'imageHolder' (automatically generated)"

    ^ imageHolder

    "Created: 21.6.1997 / 13:05:53 / cg"
!

imageHolder:something
    "set the value of the instance variable 'imageHolder' (automatically generated)"

    imageHolder := something.

    "Created: 21.6.1997 / 13:05:53 / cg"
!

offset
    "return the value of the instance variable 'offset' (automatically generated)"

    ^ offset
!

offset:something
    "set the value of the instance variable 'offset' (automatically generated)"

    offset := something.
! !

!ImageFrame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ImageFrame.st,v 1.3 2000-11-15 15:05:02 martin Exp $'
! !
