"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libdb/libsqlite' }"

"{ NameSpace: Smalltalk }"

ExternalLong subclass:#SqliteReference
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQLite-Internals'
!

!SqliteReference class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

"
! !

!SqliteReference class methodsFor:'as yet unclassified'!

fields
    "self defineFields"
    ^ #((value 'void*'))
! !

!SqliteReference methodsFor:'accessing'!

value
    ^ self asExternalAddress
    "/ ^ExternalData fromHandle: (handle pointerAt: 1) type: ExternalType void asPointerType
!

value: anObject
    self value:(anObject address)
    "/ handle pointerAt: 1 put: anObject getHandle.
! !

!SqliteReference class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SqliteReference.st,v 1.6 2015-05-07 22:25:21 cg Exp $'
! !

