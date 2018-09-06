"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

Controller subclass:#StandardSystemController
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!StandardSystemController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    Controller for StandardSystemViews i.e. top views. There is nothing done here
    since all action is done in window manager. 
    This class exists for ST-80 compatibility only 
    (to allow for subclasses to be filed in).

    [author:]
        Claus Gittinger
"
! !

!StandardSystemController methodsFor:'startup'!

open
    view open
! !

!StandardSystemController class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/StandardSystemController.st,v 1.11 1996-04-25 16:35:11 cg Exp $'
! !
