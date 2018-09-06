"{ Package: 'stx:libdb/nosql/goods' }"

Collection subclass:#KKIdentityBTree
	instanceVariableNames:'database tree'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Collections'
!

KKIdentityBTree comment:''
!


!KKIdentityBTree class methodsFor:'as yet unclassified'!

database: aDatabase
	^ self basicNew initializeWithDatabase: aDatabase
! !

!KKIdentityBTree methodsFor:'accessing'!

at: anObject
	^ tree at: (database keyForObject: anObject)
!

at: anObject ifAbsent: errorBlock
	^ tree at: (database keyForObject: anObject) ifAbsent: errorBlock
!

at: anObject ifAbsentPut: errorBlock
	^ tree at: (database keyForObject: anObject) ifAbsentPut: errorBlock
!

at: anObject put: valueObject
	^ tree at: (database keyForObject: anObject) put: valueObject
!

values
	^ tree values
! !

!KKIdentityBTree methodsFor:'enumerating'!

do: aBlock
	tree do: aBlock
!

keysAndValuesDo: aBlock
	tree keysAndValuesDo:
		[:k :v |
		aBlock value: (database at: k) value: v]
!

keysDo: aBlock
	self keysAndValuesDo: [:k :v | aBlock value: k]
! !

!KKIdentityBTree methodsFor:'initialization'!

initializeWithDatabase: aDatabase
	database := aDatabase.
	tree := BTree order: 64.
! !

!KKIdentityBTree class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKIdentityBTree.st,v 1.2 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKIdentityBTree.st,v 1.2 2013-03-28 10:38:49 cg Exp $'
! !

