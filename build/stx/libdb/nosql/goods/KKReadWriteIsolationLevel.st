"{ Package: 'stx:libdb/nosql/goods' }"

KKIsolationLevel subclass:#KKReadWriteIsolationLevel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Isolation Level'
!

KKReadWriteIsolationLevel comment:'I am the strictist transaction isolation level supported by GOODS.  In addition to the isolation provided by my superclass, if an object which has been accessed (even for read) in this session has been modified by another session, committing this session will fail with a KKCommitFailure.'
!


!KKReadWriteIsolationLevel methodsFor:'public'!

commitKeyCache: aKeyCache

	^aKeyCache commitAndValidateRead
! !

!KKReadWriteIsolationLevel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKReadWriteIsolationLevel.st,v 1.3 2013-03-31 12:06:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKReadWriteIsolationLevel.st,v 1.3 2013-03-31 12:06:01 cg Exp $'
! !

