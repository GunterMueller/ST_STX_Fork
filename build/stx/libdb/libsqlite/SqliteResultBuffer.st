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

ExternalStructure subclass:#SqliteResultBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQLite-Internals'
!

!SqliteResultBuffer class methodsFor:'documentation'!

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

!SqliteResultBuffer class methodsFor:'as yet unclassified'!

fields
    "self defineFields"
    ^ #((value 'void*'))
! !

!SqliteResultBuffer methodsFor:'accessing'!

value
    ^ self asExternalAddress
"/    "This method was automatically generated"
"/    ^ExternalData fromHandle: (handle pointerAt: 1) type: ExternalType void asPointerType
!

value: anObject
    self value:(anObject address)
"/    "This method was automatically generated"
"/    handle pointerAt: 1 put: anObject getHandle.
! !

!SqliteResultBuffer class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SqliteResultBuffer.st,v 1.6 2015-05-07 22:25:38 cg Exp $'
! !

