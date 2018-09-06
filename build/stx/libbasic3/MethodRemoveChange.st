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

MethodChange subclass:#MethodRemoveChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!MethodRemoveChange class methodsFor:'documentation'!

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
    instances represent a method-has-been-removed change. 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!MethodRemoveChange class methodsFor:'instance creation'!

class:cls selector:selector 
    ^ self basicNew class:cls selector:selector

    "Created: / 17.4.1998 / 17:10:51 / cg"
!

className:clsName selector:sel
    ^ self basicNew className:clsName selector:sel

    "Created: / 10-11-2006 / 14:24:14 / cg"
! !

!MethodRemoveChange methodsFor:'accessing'!

class:cls selector:sel
    className := cls name.
    selector := sel

    "Modified: / 27.8.1995 / 22:56:03 / claus"
    "Created: / 16.2.1998 / 12:47:39 / cg"
!

className:clsName selector:sel
    className := clsName.
    selector := sel

    "Modified: / 27.8.1995 / 22:56:03 / claus"
    "Created: / 16.2.1998 / 12:51:57 / cg"
!

deltaDetail
    "Returns a delta to the current state as a ChangeDelta object"

    ^ self changeMethod isNil 
        ifTrue:[ ChangeDeltaInformation identical ]
        ifFalse:[ ChangeDeltaInformation removed ]

    "Created: / 31-08-2011 / 10:28:47 / cg"
!

package
    ^ nil
!

type:typeSymbol
    self assert:typeSymbol == #remove.
! !

!MethodRemoveChange methodsFor:'applying'!

apply

    ^self changeClass removeSelector: self changeSelector

    "Created: / 12-12-2007 / 08:55:26 / janfrog"
! !

!MethodRemoveChange methodsFor:'printing'!

printOn:aStream
    aStream     
        nextPutAll:className; 
        nextPutAll:' removeSelector:'; 
        nextPutAll:selector storeString

    "Created: / 16.2.1998 / 12:50:42 / cg"
! !

!MethodRemoveChange methodsFor:'testing'!

isMethodCodeChange
    "true if this is a method's code change (not package, category etc.)"

    ^ false
!

isMethodRemoveChange
    ^ true
! !

!MethodRemoveChange class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/MethodRemoveChange.st,v 1.16 2014-02-19 13:06:02 cg Exp $'
!

version_SVN
    ^ '$ Id: MethodRemoveChange.st 1867 2011-06-08 21:57:08Z vranyj1  $'
! !

