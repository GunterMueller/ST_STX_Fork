"{ Package: 'stx:libdb/nosql/goods' }"

KKCache subclass:#KKRecordCache
	instanceVariableNames:'cache newObjects classCache allocationCache cluster'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache'
!

KKRecordCache comment:'The record cache holds memento (records) of objects that have been read from the database.  These objects may or may not have been accessed by the client since, in many cases, GOODS will send "related" objects speculatively whenever an object is requested.
I also track new objects (not mementos) that this client will add to the repository during the next commit.  New objects are added via my allocateObject: method.
I am responsible for commiting changes to the database server and for loading records and converting them to objects.'
!


!KKRecordCache methodsFor:'initializing'!

initializeWithDatabase: aDatabase
	super initializeWithDatabase: aDatabase.
	classCache := KKClassCache database: database.
	allocationCache := KKAllocationCache database: database.
	cache := Dictionary new.
	newObjects := IdentitySet new
! !

!KKRecordCache methodsFor:'private'!

addDirtyObjects: aDictionary toRecords: dirtyCollection hasBarrier: hasWriteBarrier
	| newRec oldRec |
	aDictionary copy keysAndValuesDo:
			[:key :object |
			object goodsIsImmutable
				ifFalse:
					[newRec := self updateRecordForObject: object unlock:
									database shouldUnlockDirtyOnCommit
									downgrade: database shouldDowngradeDirtyOnCommit.
					oldRec := cache at: key ifAbsent: [].
					"We only do the record comparison if there is no authoritative write barrier."
					(oldRec isNil or: [hasWriteBarrier or: [(newRec = oldRec) not]])
						ifTrue: [dirtyCollection at: key put: newRec]]]
!

addNewObjectsToRecords: aCollection
	| added key |
	added := false.
	newObjects do:
		[:ea |
		key := self keyForObject: ea.
		aCollection at: key ifAbsentPut: [added := true. self updateRecordForObject: ea unlock: false downgrade: false]].
	^ added
!

addObject: anObject
	newObjects add: anObject
!

canCluster
	"Can we ask the database for clusters of objects?  Answering false will mean we receive objects one at a time.  Answering false can impose a significant performance penalty since the backend database may end up sending small objects one at a time across the network, rather than trying to speculate on what object will be requested next."

	^cluster ifNil: [true]
!

createObjectFromRecord: aRecord
	^ (classCache at: aRecord classKey)
		objectFromStream: (ReadStream on: aRecord data)
		forDatabase: database
!

keyForObject: anObject
	^ database keyForObject: anObject
!

updateCacheFromRecords: aCollection
	aCollection do: [:ea | cache at: ea key put: ea]
!

updateRecordForObject: anObject unlock: unlock downgrade: downgrade
	| descriptor stream|
	descriptor := classCache classForObject: anObject.
	stream := descriptor streamForObject: anObject database: database.

	^ KKObjectRecord
			updateObjectAt: (self keyForObject: anObject)
			classKey: descriptor id
			data: stream contents
			unlock: unlock
			downgrade: downgrade
!

validateRecordForKey: aKey object: anObject unlock: unlock downgrade: downgrade
	| descriptor |
	descriptor := classCache classForObject: anObject.
	^KKObjectRecord
		validateObjectAt: aKey
		classKey: descriptor id
		unlock: unlock
		downgrade: downgrade
!

validationRecordsFor: objectList
	| result |
	result := OrderedCollection new.
	objectList keysAndValuesDo: [:key :object |
		result add: (self validateRecordForKey: key object: object unlock: database shouldUnlockOnVerify downgrade: database shouldDowngradeOnVerify)].
	^result
! !

!KKRecordCache methodsFor:'public'!

allocateObject: anObject
	| descriptor |
	self addObject: anObject.
	descriptor := classCache classForObject: anObject.
	^ allocationCache allocateObjectOfClass: descriptor id size: descriptor estimatedSize
!

commitObjects: aDictionary andValidate: objectsForValidation hasBarrier: hasWriteBarrier
	"Commit objects in aDictionary and validate (make sure no other session changed) any objects in objectsForValidation.  objectsForValidation should either be nil or a Dictionary of key->object mappings."
	| dirtyRecords cleanRecords validationDict |
	classCache cacheClassesDuring:
			[dirtyRecords := Dictionary new.
			self
				addDirtyObjects: aDictionary
				toRecords: dirtyRecords
				hasBarrier: hasWriteBarrier.
			[self addNewObjectsToRecords: dirtyRecords] whileTrue.
			allocationCache reloadCache.
			cleanRecords :=
				objectsForValidation ifNotNil:
					[validationDict := objectsForValidation copy.
					dirtyRecords keysDo: [:key | validationDict removeKey: key].
					self validationRecordsFor: validationDict].
			(self connection commitRecords: dirtyRecords andValidate: cleanRecords)
				ifFalse: [^false]
				ifTrue:
					[newObjects := IdentitySet new.
					self updateCacheFromRecords: dirtyRecords.
					^true]]
!

doCluster
	"Cluster reads (try to read multiple objects at a time speculatively)"
	cluster := true
!

dontCluster
	"Don't cluster reads (don't try to read multiple objects at a time speculatively)"
	cluster := false
!

forgetAll: keys
	keys do: [:key | cache removeKey: key ifAbsent: []]
!

forgetRecords: aKeyList
	aKeyList do: [:each | cache removeKey: each]
!

loadObjectAt: aKey ifAbsent: absentBlock
	"Load the record specified by aKey.  We may get a cluster of objects in return so we'll store all of their records but we only answer the object corresponding to aKey"
	| records |
	records := self refreshAll: (Array with: aKey).
	records isEmpty ifTrue: [ ^ absentBlock value ].
	records first classKey < 2 ifTrue: [^absentBlock value].
	^ self createObjectFromRecord: records first
!

objectForRecordAt: key ifPresent: aBlock
	cache
		at: key
		ifPresent: [ :record | aBlock value: (self createObjectFromRecord: record) ]
!

queryOrLoadObjectAt: aKey ifAbsent: aBlock
	"If we have a record in our cache, answer an object created from that record.  Otherwise load the record from GOODS and answer an object corresponding to the loaded object."
	| record result |
	record := cache
		at: aKey
		ifAbsent:
			[ ^ self
				loadObjectAt: aKey
				ifAbsent: aBlock ].
	result := self createObjectFromRecord: record.
	^ result
!

refreshAll: keyList
	"Refresh our cached versions of all records in keyList"
	| records |
	records := self connection
		loadObjectsWithKeys: keyList
		copy: false
		cluster: self canCluster.
	self updateCacheFromRecords: records.
	^records
!

size

	^cache size
! !

!KKRecordCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKRecordCache.st,v 1.3 2013-03-31 12:03:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKRecordCache.st,v 1.3 2013-03-31 12:03:09 cg Exp $'
! !

