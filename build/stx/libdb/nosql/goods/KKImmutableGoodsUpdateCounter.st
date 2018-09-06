"{ Package: 'stx:libdb/nosql/goods' }"

KKGoodsUpdateCounter subclass:#KKImmutableGoodsUpdateCounter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!

KKImmutableGoodsUpdateCounter comment:'I am an immutable version of my superclass.'
!


!KKImmutableGoodsUpdateCounter methodsFor:'accessing'!

anIvar: aValue
	"Ignore"
!

goodsIsImmutable

	^true
! !

!KKImmutableGoodsUpdateCounter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKImmutableGoodsUpdateCounter.st,v 1.3 2013-03-31 12:11:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKImmutableGoodsUpdateCounter.st,v 1.3 2013-03-31 12:11:52 cg Exp $'
! !

