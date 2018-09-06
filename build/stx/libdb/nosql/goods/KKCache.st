"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKCache
	instanceVariableNames:'database'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache'
!

KKCache comment:''
!


!KKCache class methodsFor:'as yet unclassified'!

database: aDatabase
	^ self basicNew initializeWithDatabase: aDatabase
! !

!KKCache methodsFor:'accessing'!

connection
	^database connection
! !

!KKCache methodsFor:'initializing'!

initializeWithDatabase: aDatabase
	database := aDatabase.
! !

!KKCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKCache.st,v 1.3 2013-03-31 12:03:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKCache.st,v 1.3 2013-03-31 12:03:14 cg Exp $'
! !

