"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKGoodsUpdateCounter
	instanceVariableNames:'anIvar goodsUpdateCount'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!

KKGoodsUpdateCounter comment:'I count the number of times #goodsUpdate is sent to me.'
!


!KKGoodsUpdateCounter methodsFor:'accessing'!

anIvar

	^anIvar
!

anIvar: someValue

	anIvar := someValue.
	self goodsChanged: #someValue
!

goodsHasChangeTracking

	^true
!

goodsUpdateCount
	^ goodsUpdateCount ifNil: [ 0 ]
! !

!KKGoodsUpdateCounter methodsFor:'copying'!

goodsUpdate
	goodsUpdateCount := self goodsUpdateCount + 1
! !

!KKGoodsUpdateCounter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKGoodsUpdateCounter.st,v 1.3 2013-03-31 12:07:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKGoodsUpdateCounter.st,v 1.3 2013-03-31 12:07:56 cg Exp $'
! !

