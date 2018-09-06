"{ Package: 'stx:libdb/nosql/goods' }"

Set subclass:#KKSet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-TrackingCollections'
!

KKSet comment:'I am a Set that can be used in a GOODS database that is tracking changes with the manual write barrier.  See KKManualWriteBarrier.'
!


!KKSet methodsFor:'copy'!

postCopy
	super postCopy.
	self goodsChanged
! !

!KKSet methodsFor:'private'!

atNewIndex: index put: anObject
	super atNewIndex: index put: anObject.
	self goodsChanged
!

fixCollisionsFrom: start
	super fixCollisionsFrom: start.
	self goodsChanged
!

goodsChanged
	"/ array goodsChanged.
	keyArray goodsChanged.
	tally goodsChanged.
	super goodsChanged
!

grow
	super grow.
	self goodsChanged
!

initialize: n
	super initialize:n.
	self goodsChanged
!

noCheckAdd: anObject
	super noCheckAdd: anObject.
	self goodsChanged
!

rehash
	super rehash.
	self goodsChanged
!

species
	^KKSet
!

swap: oneIndex with: otherIndex
	super swap: oneIndex with: otherIndex.
	self goodsChanged
!

withArray: anArray
	super withArray: anArray.
	self goodsChanged
! !

!KKSet methodsFor:'removing'!

remove: oldObject ifAbsent: aBlock
	| result |
	result := super remove: oldObject ifAbsent: aBlock.
	self goodsChanged.
	^result
! !

!KKSet methodsFor:'testing'!

goodsHasChangeTracking
	^true
! !

!KKSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKSet.st,v 1.3 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKSet.st,v 1.3 2013-03-28 10:38:50 cg Exp $'
! !

