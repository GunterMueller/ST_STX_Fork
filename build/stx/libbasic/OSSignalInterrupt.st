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

ProceedableError subclass:#OSSignalInterrupt
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Control'
!

!OSSignalInterrupt class methodsFor:'documentation'!

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
    OSSignalInterrupt is raised, when an operating system signal has been received.
    The signal number is stored as parameter.

    Since signals may be sent asynchronously, an OSSignalInterrupt is only raised, 
    when handled in the current process.

    You can also bind an exception to an os signal with 
    OperatingSystem>>#operatingSystemSignal:install:
"
! !

!OSSignalInterrupt class methodsFor:'initialization'!

initialize

    NotifierString := 'os signal interrupt'.

    "
     self initialize
    "
! !

!OSSignalInterrupt class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/OSSignalInterrupt.st,v 1.4 2005/04/11 08:53:28 stefan Exp $'
!

version_SVN
    ^ '$Id: OSSignalInterrupt.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

OSSignalInterrupt initialize!



