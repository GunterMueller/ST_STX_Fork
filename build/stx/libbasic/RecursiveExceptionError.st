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

Error subclass:#RecursiveExceptionError
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Kernel-Exceptions-Errors'
!

!RecursiveExceptionError class methodsFor:'documentation'!

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
    RecursiveExceptionError is raised, if the same exception is raised
    again in an exception handler.

    The parameter is the recursive exception.
"


! !


!RecursiveExceptionError class methodsFor:'initialization'!

initialize

    NotifierString := 'recursive exception raise in handler'.

    "
     self initialize
    "


! !


!RecursiveExceptionError class methodsFor:'queries'!

mayProceed

    ^ false


! !


!RecursiveExceptionError methodsFor:'accessing'!

exception
    "the original exception, which was responsible for this.
     ANSI compatibility"

    ^ parameter
! !


!RecursiveExceptionError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/RecursiveExceptionError.st,v 1.6 2013-04-19 08:40:19 cg Exp $'
!

version_SVN
    ^ '$Id: RecursiveExceptionError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


RecursiveExceptionError initialize!
