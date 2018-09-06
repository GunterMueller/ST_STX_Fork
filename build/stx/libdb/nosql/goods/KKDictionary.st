"{ Package: 'stx:libdb/nosql/goods' }"

Dictionary subclass:#KKDictionary
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-TrackingCollections'
!

KKDictionary comment:'I am a Dictionary that can be used in a GOODS database that is tracking changes with the manual write barrier.  See KKManualWriteBarrier.'
!


!KKDictionary methodsFor:'accessing'!

at: key put: anObject
	"Set the value at key to be anObject.  If key is not found, create a
	new entry for key and set is value to anObject. Answer anObject."

"/        | index assoc |
"/        index := self findElementOrNil: key.
"/        assoc := array at: index.
"/        assoc
"/                ifNil: [self atNewIndex: index put: (Association key: key value: anObject)]
"/                ifNotNil: [assoc goodsChanged. assoc value: anObject].
"/        ^ anObject

    super at:key put:anObject.
    self goodsChanged.
! !

!KKDictionary methodsFor:'adding'!

add: anAssociation
"/        | index element |
"/        index := self findElementOrNil: anAssociation key.
"/        element := array at: index.
"/        element == nil
"/                ifTrue: [self atNewIndex: index put: anAssociation]
"/                ifFalse: [element goodsChanged. element value: anAssociation value].
"/        ^ anAssociation

    super add:anAssociation.
    self goodsChanged.
    ^  anAssociation
! !

!KKDictionary methodsFor:'copying'!

postCopy
	super postCopy.
	self goodsChanged
! !

!KKDictionary methodsFor:'private'!

atNewIndex: index put: anObject
	super atNewIndex: index put: anObject.
	self goodsChanged
!

fixCollisionsFrom: start
	super fixCollisionsFrom: start.
	self goodsChanged
!

goodsChanged
	super goodsChanged.
	"/ array goodsChanged.
	keyArray goodsChanged.
	valueArray goodsChanged.
	tally goodsChanged
!

grow
	super grow.
	self goodsChanged
!

initialize: n
	super initialize: n.
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
	^KKDictionary
!

swap: oneIndex with: otherIndex
	super swap: oneIndex with: otherIndex.
	self goodsChanged
!

withArray: anArray
	super withArray: anArray.
	self goodsChanged
! !

!KKDictionary methodsFor:'removing'!

removeKey: key ifAbsent: aBlock
	| result |
	result := super removeKey: key ifAbsent: aBlock.
	self goodsChanged.
	^result
! !

!KKDictionary methodsFor:'testing'!

goodsHasChangeTracking
	^true
! !

!KKDictionary class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKDictionary.st,v 1.3 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKDictionary.st,v 1.3 2013-03-28 10:38:49 cg Exp $'
! !

