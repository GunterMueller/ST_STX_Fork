"{ Package: 'stx:libdb/nosql/goods' }"

KKCachePolicy subclass:#KKLRUCachePolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache Policies'
!

KKLRUCachePolicy comment:'I try to keep the cache size below my high water mark.  I do this by removing clean (not in dirty set) objects that have not been accessed recently.  I do this until the cache object count gets down to my low water mark or there are no objects left that meet my criteria.
Determining when an object was last accessed is tricky....how do I do this?'
!


!KKLRUCachePolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKLRUCachePolicy.st,v 1.3 2013-03-31 12:17:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKLRUCachePolicy.st,v 1.3 2013-03-31 12:17:54 cg Exp $'
! !

