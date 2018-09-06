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

ControlInterrupt subclass:#UserInterrupt
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Control'
!

!UserInterrupt class methodsFor:'documentation'!

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
    Raised when the user presses the Interrupt-Key,
    which is CTRL-c on unix and BREAK on win32 systems.
"
! !

!UserInterrupt class methodsFor:'initialization'!

initialize
    NotifierString := 'user Interrupt'.

    "
     self initialize
    "
! !

!UserInterrupt class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/UserInterrupt.st,v 1.5 2013-04-27 10:10:20 cg Exp $'
! !


UserInterrupt initialize!
