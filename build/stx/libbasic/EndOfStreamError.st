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

StreamError subclass:#EndOfStreamError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!EndOfStreamError class methodsFor:'documentation'!

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
    This error exception is raised on attempt to read after the end of a stream
    has been reached.

    It is only raised, if Stream>>signalAtEnd:true has been set.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]

    [class variables:]

    [see also:]
        EndOfStreamNotification

"
! !

!EndOfStreamError class methodsFor:'initialization'!

initialize
    NotifierString := 'end of stream'.
! !

!EndOfStreamError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/EndOfStreamError.st,v 1.1 2005/11/16 08:45:55 stefan Exp $'
!

version_SVN
    ^ '$Id: EndOfStreamError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

EndOfStreamError initialize!



