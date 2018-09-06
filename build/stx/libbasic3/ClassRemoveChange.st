"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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

ClassChange subclass:#ClassRemoveChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

Query subclass:#ClassBeingRemovedQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ClassRemoveChange
!

!ClassRemoveChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
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
    instances represent a class-has-been-removed change. 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!ClassRemoveChange methodsFor:'accessing'!

deltaDetail
    "Returns a delta to the current state as a ChangeDelta object"

    ^ self changeClass isNil ifTrue:[ 
        ChangeDeltaInformation identical.        
    ] ifFalse:[ 
        ChangeDeltaInformation removed.
    ].

    "Created: / 15-04-2015 / 11:16:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassRemoveChange methodsFor:'printing'!

printOn:aStream
    aStream nextPutAll:'Smalltalk removeClass: ';
            nextPutAll:className asString

    "Created: / 16-02-1998 / 14:19:48 / cg"
    "Modified: / 13-11-2006 / 10:40:17 / cg"
! !

!ClassRemoveChange methodsFor:'testing'!

isClassRemoveChange
    ^ true
! !

!ClassRemoveChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassRemoveChange.st,v 1.8 2014-02-19 13:05:21 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

