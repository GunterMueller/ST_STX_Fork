"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Error subclass:#ProceedableError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!ProceedableError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
     This is a child of Error, which can proceed.
     Proceedable errors may be implemeneted as subclass of
     ProceedableError.
"



! !

!ProceedableError class methodsFor:'initialization'!

initialize
    NotifierString := 'proceedable error'.

    "
     self initialize
    "

    "Modified: / 17-11-2010 / 17:53:04 / cg"
! !

!ProceedableError class methodsFor:'queries'!

mayProceed
    ^ true

    "Modified: / 17-11-2010 / 17:53:37 / cg"
! !

!ProceedableError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/ProceedableError.st,v 1.6 2010-11-17 16:53:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/ProceedableError.st,v 1.6 2010-11-17 16:53:49 cg Exp $'
! !

ProceedableError initialize!
