"{ Package: 'stx:libdb/nosql/goods' }"

KKIsolationLevel subclass:#KKWriteWriteIsolationLevel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Isolation Level'
!

KKWriteWriteIsolationLevel comment:'I detect write-write conflicts only (objects modified by two concurrent sessions).  If, on commit, a session is detected to have modified an old version of an object (an object which was concurrently modified by another session), fail with KKCommitFailure.'
!


!KKWriteWriteIsolationLevel methodsFor:'public'!

commitKeyCache: aKeyCache
	^aKeyCache commitNoValidation
! !

!KKWriteWriteIsolationLevel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKWriteWriteIsolationLevel.st,v 1.3 2013-03-31 12:14:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKWriteWriteIsolationLevel.st,v 1.3 2013-03-31 12:14:30 cg Exp $'
! !

