"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Notification subclass:#EndOfStreamNotification
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!EndOfStreamNotification class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    This notification is raised on attempt to read after the end of a stream
    has been reached. As a notification, it will be ignored if no handler exists.

    It is raised, if Stream>>signalAtEnd:nil has been set (this is the default).

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]
        EndOfStreamError

"
! !

!EndOfStreamNotification class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/EndOfStreamNotification.st,v 1.3 2005/11/16 08:44:41 stefan Exp $'
!

version_SVN
    ^ '$Id: EndOfStreamNotification.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !



