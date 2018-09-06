"{ Package: 'stx:libdb/nosql/goods' }"

OrderedCollection subclass:#KKOrderedCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-TrackingCollections'
!

KKOrderedCollection comment:'I am an OrderedCollection that can be used in a GOODS database that is tracking changes with the manual write barrier.  See KKManualWriteBarrier.'
!


!KKOrderedCollection methodsFor:'accessing'!

at: anInteger put: anObject
	| result |
	result := super at: anInteger put: anObject.
	self goodsChanged.
	^result
! !

!KKOrderedCollection methodsFor:'adding'!

addFirst: newObject
	| result |
	result := super addFirst: newObject.
	self goodsChanged.
	^result
!

addLast: newObject
	| result |
	result := super addLast: newObject.
	self goodsChanged.
	^result
!

grow
	super grow.
	self goodsChanged
! !

!KKOrderedCollection methodsFor:'copying'!

postCopyFrom: startIndex to: endIndex
	super postCopyFrom: startIndex to:endIndex.
	self goodsChanged.

! !

!KKOrderedCollection methodsFor:'enumerating'!

sort: aBlock
	super sort: aBlock.
	self goodsChanged
! !

!KKOrderedCollection methodsFor:'private '!

goodsChanged
	super goodsChanged.
	"/ array goodsChanged
	contentsArray goodsChanged
!

insert: anObject before: spot
	| result |
	result := super insert: anObject before: spot.
	self goodsChanged.
	^result
!

makeRoomAtFirst
	super makeRoomAtFirst.
	self goodsChanged
!

makeRoomAtIndex:whereToMakeEmptySlots for:howMany
	super makeRoomAtIndex:whereToMakeEmptySlots for:howMany.
	self goodsChanged.
	^ self
!

makeRoomAtLast
	super makeRoomAtLast.
	self goodsChanged
!

makeRoomFor: anInteger
"/        | newArray |
"/
"/        (self capacity - firstIndex - 1 - self size) >= anInteger
"/                ifTrue: [^self].
"/
"/        newArray := Array new: self size + (self growSizeGuaranteeing: anInteger).
"/        newArray replaceFrom: 1 to: array size with: array startingAt: 1.
"/        array := newArray.
"/        self goodsChanged.
"/        ^ self
    self squeakOnly.
!

removeIndex: removedIndex
	super removeIndex: removedIndex.
	self goodsChanged
!

replaceFrom: start to: stop with: replacement startingAt: repStart
	"An ordered collection is growable, so a call to this can make the collection grow."
    super replaceFrom: start to: stop with: replacement startingAt: repStart.

"/        self makeRoomFor: (stop - self capacity).
"/        array
"/                replaceFrom: start + firstIndex - 1
"/                to: stop + firstIndex - 1
"/                with: replacement
"/                startingAt: repStart.
"/        lastIndex := lastIndex max: stop + firstIndex - 1.
	self goodsChanged
!

reset
	super reset.
	self goodsChanged
!

resetTo: index
	super resetTo: index.
	self goodsChanged
!

setCollection: anArray
	super setCollection: anArray.
	self goodsChanged
!

setContents: anArray
	super setContents: anArray.
	self goodsChanged
!

species
	^KKOrderedCollection
! !

!KKOrderedCollection methodsFor:'removing'!

removeAllSuchThat: aBlock
	super removeAllSuchThat: aBlock.
	self goodsChanged
!

removeFirst
	| result |
	result := super removeFirst.
	self goodsChanged.
	^result
!

removeLast
	| result |
	result := super removeLast.
	self goodsChanged.
	^result
! !

!KKOrderedCollection methodsFor:'testing'!

goodsHasChangeTracking
	^true
! !

!KKOrderedCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKOrderedCollection.st,v 1.3 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKOrderedCollection.st,v 1.3 2013-03-28 10:38:49 cg Exp $'
! !

