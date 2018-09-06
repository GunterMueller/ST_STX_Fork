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

"{ NameSpace: Smalltalk }"

ControlInterrupt subclass:#HaltInterrupt
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Kernel-Exceptions-Control'
!

!HaltInterrupt class methodsFor:'documentation'!

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
    Raised by the #halt methods.
    A programmed debug-breakpoint.

    [author:]
        Claus Gittinger
"
! !


!HaltInterrupt class methodsFor:'initialization'!

initialize
    NotifierString := 'halt encountered'.

    "
     self initialize
    "
! !


!HaltInterrupt class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: HaltInterrupt.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


HaltInterrupt initialize!
