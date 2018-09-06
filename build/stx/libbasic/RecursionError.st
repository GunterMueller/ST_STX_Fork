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

Error subclass:#RecursionError
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Kernel-Exceptions-Errors'
!

!RecursionError class methodsFor:'documentation'!

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
    Raised when the recursion level is too high - i.e. the execution stack
    is about to overflow.
"
! !


!RecursionError class methodsFor:'initialization'!

initialize
    NotifierString := 'recursion limit reached'.

    "
     self initialize
    "
! !


!RecursionError class methodsFor:'queries'!

mayProceed
    "under win32, the stack cannot grow - so we may not proceed there (sigh)"

    ^ OperatingSystem isMSWINDOWSlike not

    "Created: / 10.11.2001 / 15:10:56 / cg"
! !


!RecursionError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/RecursionError.st,v 1.6 2013-04-27 10:09:34 cg Exp $'
!

version_SVN
    ^ '$Id: RecursionError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


RecursionError initialize!
