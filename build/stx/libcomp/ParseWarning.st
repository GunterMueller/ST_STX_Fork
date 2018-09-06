"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Notification subclass:#ParseWarning
	instanceVariableNames:'errorMessage startPosition endPosition lineNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!ParseWarning class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ParseWarning methodsFor:'accessing'!

endPosition
    ^ endPosition
!

endPosition:something
    endPosition := something.
!

errorMessage
    ^ errorMessage
!

errorMessage:something
    errorMessage := something.
!

lineNumber
    ^ lineNumber
!

lineNumber:something
    lineNumber := something.
!

startPosition
    ^ startPosition
!

startPosition:something
    startPosition := something.
! !

!ParseWarning methodsFor:'default action'!

defaultResumeValue
    Logger warning:('Parser Warning: ',(self errorMessage ? self description)).
    ^ super defaultResumeValue
! !

!ParseWarning class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

