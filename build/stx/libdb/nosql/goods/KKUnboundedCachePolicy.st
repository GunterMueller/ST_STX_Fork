"{ Package: 'stx:libdb/nosql/goods' }"

KKCachePolicy subclass:#KKUnboundedCachePolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache Policies'
!

KKUnboundedCachePolicy comment:'I allow the caches to grow without limit.  I must be used in cases where no authoratative write barrier is available (like on Squeak/Pharo unless you''re using a KKManualWriteBarrier).'
!


!KKUnboundedCachePolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKUnboundedCachePolicy.st,v 1.3 2013-03-31 12:11:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKUnboundedCachePolicy.st,v 1.3 2013-03-31 12:11:17 cg Exp $'
! !

