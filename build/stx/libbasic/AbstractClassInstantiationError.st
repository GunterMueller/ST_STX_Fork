"
 COPYRIGHT (c) 2012 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

MethodNotAppropriateError subclass:#AbstractClassInstantiationError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-ExecutionErrors'
!

!AbstractClassInstantiationError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by eXept Software AG
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
        raised by abstractClassInstantiationError
"
! !

!AbstractClassInstantiationError class methodsFor:'initialization'!

initialize
    NotifierString := 'attempt to instantiate an abstract class'.

    "Modified: / 02-11-2012 / 09:56:20 / cg"
! !

!AbstractClassInstantiationError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/AbstractClassInstantiationError.st,v 1.2 2012-11-02 16:40:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/AbstractClassInstantiationError.st,v 1.2 2012-11-02 16:40:18 cg Exp $'
! !

AbstractClassInstantiationError initialize!
