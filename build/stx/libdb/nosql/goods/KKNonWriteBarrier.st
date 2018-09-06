"{ Package: 'stx:libdb/nosql/goods' }"

KKAbstractWriteBarrier subclass:#KKNonWriteBarrier
	instanceVariableNames:'keyCache'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-WriteBarrier'
!

KKNonWriteBarrier comment:'I am a "write barrier" for database clients with no write barrier support.  I report everything (except objects which answer true to #goodsIsImmutable) as dirty.'
!


!KKNonWriteBarrier methodsFor:'api'!

dirtySet

	| result |
	result := Set new.
	keyCache keysAndObjects do: [:value |
		(value goodsIsImmutable not and: [value goodsIsImmediateValue not]) ifTrue: [result add: value]].
	^result
!

isAuthoritative
	"I'm not really a write barrier, so indicate that clients can't count on my answers."

	^false
!

keyCache: aKeyCache

	keyCache := aKeyCache
! !

!KKNonWriteBarrier class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKNonWriteBarrier.st,v 1.3 2013-03-31 12:03:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKNonWriteBarrier.st,v 1.3 2013-03-31 12:03:44 cg Exp $'
! !

