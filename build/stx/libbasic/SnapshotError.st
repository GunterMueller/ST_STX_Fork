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

Error subclass:#SnapshotError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!SnapshotError class methodsFor:'documentation'!

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
! !

!SnapshotError class methodsFor:'initialization'!

initialize
    NotifierString := 'Failed to save snapshot image (disk full or not writable)'.
! !

!SnapshotError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/SnapshotError.st,v 1.3 2005/03/29 22:25:15 stefan Exp $'
!

version_SVN
    ^ '$Id: SnapshotError.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

SnapshotError initialize!



