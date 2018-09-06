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

ExecutionError subclass:#UnimplementedFunctionalityError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!UnimplementedFunctionalityError class methodsFor:'documentation'!

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
    Raised when some functionality is requested that has not been implemented
    (e.g. when a method is invoked that has been marked as #shouldImplement).
"
! !

!UnimplementedFunctionalityError class methodsFor:'initialization'!

initialize
   NotifierString := 'functionality has to be implemented'
! !

!UnimplementedFunctionalityError methodsFor:'printing'!

description
    |desc|

    desc := super description, ': ', originator printString.
    parameter notNil ifTrue:[
        desc := desc, '>>', parameter selector printString
    ].
    ^ desc
! !

!UnimplementedFunctionalityError class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: UnimplementedFunctionalityError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


UnimplementedFunctionalityError initialize!



