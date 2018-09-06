"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKIsolationLevel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Isolation Level'
!

KKIsolationLevel comment:'A transaction isolation level.  I permit GOODS clients to ensure different levels of isolation from other transactions.'
!


!KKIsolationLevel methodsFor:'public'!

commitKeyCache: aKeyCache
	"Sent at commit time.  The isolation level must tell aKeyCache to commit using one of its commit* methods.  Only two choices are to validate /accessed/ objects or not."

	self subclassResponsibility
! !

!KKIsolationLevel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKIsolationLevel.st,v 1.3 2013-03-31 12:08:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKIsolationLevel.st,v 1.3 2013-03-31 12:08:45 cg Exp $'
! !

