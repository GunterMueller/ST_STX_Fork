"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKCachePolicy
	instanceVariableNames:'keyCache'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache Policies'
!

KKCachePolicy comment:'I am an abstract cache policy.  A cache policy determines which objects stay (or should be removed from) the key and record caches and certain cache optimization points.  These optimization points correspond to events like commit, rollback, flush, flushAll but also they occur each time an object is added to either of these caches.'
!


!KKCachePolicy class methodsFor:'instance creation'!

database: aDatabase

	^self keyCache: aDatabase keyCache
!

keyCache: aKeyCache

	^self basicNew initializeKeyCache: aKeyCache
! !

!KKCachePolicy methodsFor:'accessing'!

recordCache

	^keyCache recordCache
! !

!KKCachePolicy methodsFor:'initialize-release'!

initializeKeyCache: aKeyCache

	keyCache := aKeyCache.
	^self
! !

!KKCachePolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKCachePolicy.st,v 1.3 2013-03-31 12:18:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKCachePolicy.st,v 1.3 2013-03-31 12:18:11 cg Exp $'
! !

