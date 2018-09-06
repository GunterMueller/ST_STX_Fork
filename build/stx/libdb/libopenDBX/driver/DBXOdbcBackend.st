"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBackend subclass:#DBXOdbcBackend
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* obsolete *'
!


!DBXOdbcBackend methodsFor:'accessing'!

backend
	^'odbc'
!

name
	^'ODBC'
! !

!DBXOdbcBackend methodsFor:'resultSet'!

queryDelimiter
	^';'
! !

!DBXOdbcBackend methodsFor:'transactional manage'!

startTransaction
	"It returns the start transaction statement most commonly used by the backends"
	^'BEGIN TRAN'
! !

!DBXOdbcBackend class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXOdbcBackend.st,v 1.2 2013-04-15 13:11:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXOdbcBackend.st,v 1.2 2013-04-15 13:11:37 cg Exp $'
! !

