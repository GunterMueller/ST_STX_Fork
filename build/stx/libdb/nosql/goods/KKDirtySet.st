"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKDirtySet
	instanceVariableNames:'keyCache writeBarrier'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache'
!

KKDirtySet comment:''
!


!KKDirtySet class methodsFor:'as yet unclassified'!

keyCache: aKeyCache writeBarrier: aWriteBarrier
	^ self basicNew initializeWithKeyCache: aKeyCache writeBarrier: aWriteBarrier
! !

!KKDirtySet methodsFor:'initialization'!

initializeWithKeyCache: aKeyCache writeBarrier: aWriteBarrier
	keyCache := aKeyCache.
	writeBarrier := aWriteBarrier
! !

!KKDirtySet methodsFor:'public'!

dirtyKeysAndObjects
	| dict |
	dict := Dictionary new.
	writeBarrier dirtySet do:
		[:ea |
		dict at: (keyCache keyForObject: ea) put: ea].
	^dict
!

dirtyKeysAndObjectsDo: aBlock

	self dirtyKeysAndObjects keysAndValuesDo: aBlock
!

hasAuthoritativeWriteBarrier
	^ writeBarrier isAuthoritative
!

markClean: anObject
	writeBarrier markClean: anObject
!

markDirty: anObject
	writeBarrier modified: anObject
!

registerObject: anObject
	writeBarrier add: anObject
!

reset
	writeBarrier clearDirtySet
!

writeBarrier
	^writeBarrier
! !

!KKDirtySet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKDirtySet.st,v 1.3 2013-03-31 12:18:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKDirtySet.st,v 1.3 2013-03-31 12:18:32 cg Exp $'
! !

