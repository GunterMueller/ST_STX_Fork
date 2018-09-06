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

ControlRequest subclass:#TerminateProcessRequest
	instanceVariableNames:'catchInDebugger'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Control'
!

!TerminateProcessRequest class methodsFor:'documentation'!

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
    Request to terminate a process.
    (raised when #terminate is sent to a process)

    Can be caught for cleanup- or confirmation actions.
"
! !

!TerminateProcessRequest methodsFor:'accessing'!

catchInDebugger
    "if set, the debugger will handle this signal in its event loop and will close itself
     without asking for close-confirmation.
     This allows for debugged processes to be terminated without a user confirmation dialog
     (for now, this is used in expecco's hard-terminate function to shut down any open debuggers
      together with the test-process)"

    ^ catchInDebugger ? false
!

catchInDebugger:something
    "if set, the debugger will handle this signal in its event loop and will close itself
     without asking for close-confirmation.
     This allows for debugged processes to be terminated without a user confirmation dialog
     (for now, this is used in expecco's hard-terminate function to shut down any open debuggers
      together with the test-process)"

    catchInDebugger := something.
! !

!TerminateProcessRequest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/TerminateProcessRequest.st,v 1.4 2014-06-10 10:20:23 cg Exp $'
! !
