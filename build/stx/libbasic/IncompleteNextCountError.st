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

StreamError subclass:#IncompleteNextCountError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!IncompleteNextCountError class methodsFor:'documentation'!

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
    There are not enough elements to complete the requested operation.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [see also:]

    [instance variables:]
        parameter       number of available elements

"
! !

!IncompleteNextCountError class methodsFor:'initialization'!

initialize

    NotifierString := 'not enough elements available'.

    "
     self initialize
    "
! !

!IncompleteNextCountError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/IncompleteNextCountError.st,v 1.2 2003/08/29 19:14:43 cg Exp $'
!

version_SVN
    ^ '$Id: IncompleteNextCountError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

IncompleteNextCountError initialize!



