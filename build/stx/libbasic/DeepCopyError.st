"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

ProceedableError subclass:#DeepCopyError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!DeepCopyError class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    DeepCopyError is raised if an object can not be deep copied
"
! !

!DeepCopyError class methodsFor:'initialization'!

initialize
    NotifierString := 'deep copy error'.
! !

!DeepCopyError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/DeepCopyError.st,v 1.2 2013-12-24 10:39:41 cg Exp $'
!

version_SVN
    ^ '$Id: DeepCopyError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !


DeepCopyError initialize!
