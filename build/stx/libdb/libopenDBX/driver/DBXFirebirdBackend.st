"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBackend subclass:#DBXFirebirdBackend
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* obsolete *'
!


!DBXFirebirdBackend methodsFor:'accessing'!

backend
	^ 'firebird'
!

name
	^'Firebird'
! !

!DBXFirebirdBackend methodsFor:'resultSet'!

queryDelimiter
	^';'
! !

!DBXFirebirdBackend methodsFor:'transactional manage'!

startTransaction
	^'SET TRANSACTION READ WRITE'
! !

!DBXFirebirdBackend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXFirebirdBackend.st,v 1.2 2013-04-15 13:11:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXFirebirdBackend.st,v 1.2 2013-04-15 13:11:06 cg Exp $'
! !

