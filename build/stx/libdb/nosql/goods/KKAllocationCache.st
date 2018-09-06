"{ Package: 'stx:libdb/nosql/goods' }"

KKCache subclass:#KKAllocationCache
	instanceVariableNames:'oids sizes cpids batchSize'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache'
!

KKAllocationCache comment:'I keep a cache of pre-allocated object id''s.  Before an object can be stored in GOODS, it must be assigned an object id.  Individual object id''s can be obtained through the GOODS cmd_alloc command but this is slow.  Instead we pre-allocate batchSize id''s.  When we run out of id''s we double batchSize (up to max of 256?) and allocate more.
I don''t exactly know how GOODS uses the class and size information during this allocation process but when we reload our cache we supply a list of the class (and size estimate) for all objects allocated since the last time we reloaded.
Instance Variables
	batchSize:              Number of oid''s to request
	cpids:          Classes-ids of recently allocated objects
	sizes:          Size estimates for recently allocated objects
	oids:           Pre-allocated object ids
'
!


!KKAllocationCache methodsFor:'accessing'!

batchSize
	oids isEmpty ifTrue: [batchSize := batchSize * 2 min: 256].
	^ batchSize
! !

!KKAllocationCache methodsFor:'as yet unclassified'!

allocateObjectOfClass: aCPID size: aNumber
	oids isEmpty ifTrue: [self reloadCache].
	cpids add: aCPID.
	sizes add: aNumber.
	^ oids removeFirst
!

reloadCache
	oids := OrderedCollection withAll: (self connection bulkAllocateSizes: sizes classes: cpids reserve: self batchSize).
	sizes := OrderedCollection new.
	cpids := OrderedCollection new.
! !

!KKAllocationCache methodsFor:'initialization'!

initializeWithDatabase: aDatabase
	super initializeWithDatabase: aDatabase.
	oids := OrderedCollection new.
	cpids := OrderedCollection new.
	sizes := OrderedCollection new.
	batchSize := 50.
! !

!KKAllocationCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKAllocationCache.st,v 1.3 2013-03-31 12:18:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKAllocationCache.st,v 1.3 2013-03-31 12:18:27 cg Exp $'
! !

