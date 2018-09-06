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
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Change subclass:#InvalidChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!InvalidChange class methodsFor:'documentation'!

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
    I represent unhandled change chunks (in a changeFile)
"
! !


!InvalidChange methodsFor:'applying'!

apply
    ^ self error:'Invalid change, cannot apply'

    "Modified: / 24-01-2012 / 16:50:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!InvalidChange methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    aStream nextPutAll: 'Invalid change'

    "Modified: / 24-01-2012 / 16:51:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!InvalidChange class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id: InvalidChange.st 1909 2012-03-31 00:14:49Z vranyj1 '
! !

