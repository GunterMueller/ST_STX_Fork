"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

AbortAllOperationRequest subclass:#AbortOperationRequest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Control'
!

!AbortOperationRequest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    Raised when the CTRL-y (abort operation) Key is pressed,
    or when the 'Abort'-button is pressed in the Debugger,
    or by many dialogs 'Cancel' key.

    If unhandled, this is a no-op,
    however, all windows catch this signal in their main event handling
    loop to allow for whatever operation is ongoing to be cancelled.

    Pressing CTRL-y has the same behavior as interrupting followed by pressing
    the debuggers 'Abort'-button.
"
! !

!AbortOperationRequest class methodsFor:'initialization'!

initialize

    NotifierString := 'abort operation requested'.

    "
     self initialize
    "
! !

!AbortOperationRequest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/AbortOperationRequest.st,v 1.5 2005/01/11 17:04:57 stefan Exp $'
!

version_SVN
    ^ '$Id: AbortOperationRequest.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

AbortOperationRequest initialize!



