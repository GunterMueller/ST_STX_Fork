"
 COPYRIGHT (c) 2011 by eXept Software AG
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

Change subclass:#FileInChange
	instanceVariableNames:'file'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!FileInChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    I represent a fileIn marker change (in a changeFile)
"
! !

!FileInChange class methodsFor:'instance creation'!

file: aStringOrFilename

    ^self new file: aStringOrFilename

    "Created: / 27-08-2009 / 10:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileInChange methodsFor:'accessing'!

file
    ^ file
!

file:aStringOrfFilename
    file := aStringOrfFilename.
! !

!FileInChange methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    aStream
        nextPutAll:'FileIn: ';
        nextPutAll: file asString storeString

    "Modified: / 27-08-2009 / 10:35:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FileInChange class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: FileInChange.st 1813 2009-10-26 21:58:45Z vranyj1  $'
! !

