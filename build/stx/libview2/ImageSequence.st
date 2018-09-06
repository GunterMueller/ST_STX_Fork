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

OrderedCollection subclass:#ImageSequence
	instanceVariableNames:'loop iterationCount'
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images'
!

!ImageSequence class methodsFor:'documentation'!

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
    An ImageSequence represents a sequence of images as contained
    in an animated gif or in a movie file.
    ImageSequence itself is abstract and possibly redefined to hold
    additional attributes by specific movie representations.

    [author:]
        Claus Gittinger

    [see also:]
        ImageFrame
        Image
"
! !

!ImageSequence methodsFor:'accessing'!

iterationCount
    "return the iterationCount.
     The sequence is to be played that often."

    ^ iterationCount

    "Created: / 1.4.1998 / 14:53:43 / cg"
    "Modified: / 1.4.1998 / 14:54:46 / cg"
!

iterationCount:something
    "set the iterationCount.
     The sequence is to be played that often."

    iterationCount := something.

    "Created: / 1.4.1998 / 14:53:43 / cg"
    "Modified: / 1.4.1998 / 14:54:53 / cg"
!

loop
    "return the value of the loop flag;
     If true, this is considered an endless-loop sequence."

    ^ loop

    "Created: / 1.4.1998 / 14:53:47 / cg"
    "Modified: / 1.4.1998 / 14:54:23 / cg"
!

loop:aBoolean
    "set the value of the loop flag;
     If true, this is considered an endless-loop sequence."

    loop := aBoolean.

    "Created: / 1.4.1998 / 14:53:47 / cg"
    "Modified: / 1.4.1998 / 14:54:15 / cg"
! !

!ImageSequence class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ImageSequence.st,v 1.4 1998-04-01 12:54:59 cg Exp $'
! !
