"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBackend subclass:#DBXMSSQLBackend
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* obsolete *'
!


!DBXMSSQLBackend methodsFor:'accessing'!

backend
	^'mssql'
!

name
	^'Microsoft SQL Server'
! !

!DBXMSSQLBackend methodsFor:'resultSet'!

queryDelimiter
	^';'
! !

!DBXMSSQLBackend methodsFor:'transactional manage'!

startTransaction
	"It returns the start transaction statement most commonly used by the backends"
	^'BEGIN TRANSACTION'
! !

!DBXMSSQLBackend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXMSSQLBackend.st,v 1.2 2013-04-15 13:11:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXMSSQLBackend.st,v 1.2 2013-04-15 13:11:33 cg Exp $'
! !

