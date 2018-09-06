"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

OtherChange subclass:#TimestampChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!TimestampChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

"
! !


!TimestampChange methodsFor:'applying'!

apply
    "apply the change"

    "Nothing to do"

    "Created: / 06-11-2008 / 08:57:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !


!TimestampChange methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:'Timestamp: '.
    source notNil ifTrue:[
        aStream nextPutAll:source.
    ].
! !


!TimestampChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/TimestampChange.st,v 1.3 2013-03-06 17:13:40 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: TimestampChange.st 1909 2012-03-31 00:14:49Z vranyj1 §'
! !

