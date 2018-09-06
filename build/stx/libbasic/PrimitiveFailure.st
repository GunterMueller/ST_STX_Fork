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

ExecutionError subclass:#PrimitiveFailure
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''
    category: 'Kernel-Exceptions-ExecutionErrors'
!

!PrimitiveFailure class methodsFor:'documentation'!

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
    Raised when a primitive C-code method failed to perform its operation
    Typically, raised with bad arguments.

    The parameter is the message that triggered the error.
"
! !


!PrimitiveFailure class methodsFor:'initialization'!

initialize
    NotifierString := 'primitive failed'.

    "
     self initialize
    "
! !


!PrimitiveFailure methodsFor:'printing & storing'!

description

    |desc|

    desc := super description, ': ', originator printString.
    parameter notNil ifTrue:[
        desc := desc, '>>', parameter selector printString
    ].
    ^ desc
! !


!PrimitiveFailure class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/PrimitiveFailure.st,v 1.8 2013-04-27 10:11:13 cg Exp $'
!

version_SVN
    ^ '$Id: PrimitiveFailure.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


PrimitiveFailure initialize!
