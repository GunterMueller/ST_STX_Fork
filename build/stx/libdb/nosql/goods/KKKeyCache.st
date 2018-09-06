"{ Package: 'stx:libdb/nosql/goods' }"

KKCache subclass:#KKKeyCache
	instanceVariableNames:'cache keys recordCache dirtySet'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Cache'
!

KKKeyCache comment:''
!


!KKKeyCache class methodsFor:'instance creation'!

database: aDatabase writeBarrier: aWriteBarrier
	^self basicNew initializeWithDatabase: aDatabase writeBarrier: aWriteBarrier
! !

!KKKeyCache methodsFor:'initializing'!

initializeWithDatabase: aDatabase writeBarrier: writeBarrier
	super initializeWithDatabase: aDatabase.
	recordCache := KKRecordCache database: database.
	cache := KKPlatform default integerDictionary.
	keys := KKPlatform default weakIdentityKeyDictionary.
	dirtySet := KKDirtySet keyCache: self writeBarrier: writeBarrier.
	writeBarrier keyCache: self
! !

!KKKeyCache methodsFor:'private'!

at: key put: anObject
	cache at: key put: anObject.
	keys at: anObject put: key.
	anObject goodsIsImmutable ifFalse: [dirtySet registerObject: anObject]
!

checkForNewInvalids
	self connection checkForNewInvalids.
!

emptyWriteBarrier
	dirtySet reset
!

loadObjectAt: key
	"The record cache /must/ load the latest version of this object, it cannot consult its cached record list."
	| object |
	object := recordCache
		loadObjectAt: key
		ifAbsent: [^nil].
	self objectAccessed: object.
	self refreshObjectAt: key from: object.
!

markClean: anObject
	"Tell our dirtSet that anObject is not dirty"

	dirtySet markClean: anObject
!

objectAccessed: anObject
	database objectAccessed: anObject
!

queryOrLoadObjectAt: key
	"It is OK for the record cache to use a previously loaded version of the record at the specified key."
	| object |
	object := recordCache queryOrLoadObjectAt: key ifAbsent: [^nil].
	object ifNil: [^nil].
	self refreshObjectAt: key from: object.
	self objectAccessed: object.
	^cache at: key
!

recordCache

	^recordCache
!

refreshObjectAt: key from: anObject
	(cache includesKey: key)
		ifFalse: [self at: key put: anObject]
		ifTrue: [(cache at: key) become: anObject.
				self markClean: (cache at: key).    "#become: may have caused object to be marked dirty"
				(cache at: key) goodsUpdate]
!

rootKey
	^ 16r10000
!

writeBarrier
	^dirtySet writeBarrier
! !

!KKKeyCache methodsFor:'public'!

at: key
	^ self at: key ifAbsent: [self queryOrLoadObjectAt: key]
!

at: key ifAbsent: aBlock
	^ cache at: key ifAbsent: aBlock
!

commitAndValidateRead
	| success |
	success := recordCache
		commitObjects: dirtySet dirtyKeysAndObjects
		andValidate: cache
		hasBarrier: dirtySet hasAuthoritativeWriteBarrier.
	success ifTrue: [ dirtySet reset ].
	^ success
!

commitNoValidation
	"Commit any dirty records.  Don't try to validate objects read."
	| success |
	success := recordCache
		commitObjects: dirtySet dirtyKeysAndObjects
		andValidate: nil
		hasBarrier: dirtySet hasAuthoritativeWriteBarrier.
	success ifTrue: [ dirtySet reset ].
	^ success
!

doCluster
	"Cluster reads (try to read multiple objects at a time speculatively)"
	recordCache doCluster
!

dontCluster
	"Don't cluster reads (don't try to read multiple objects at a time speculatively)"
	recordCache dontCluster
!

flushWithFullGC: aBoolean

        | finalized |
        "No longer refer to loaded objects strongly."

        cache := KKPlatform default integerDictionary.

        aBoolean
                ifTrue: [Smalltalk garbageCollect]
                ifFalse: [Smalltalk garbageCollectMost].
        ObjectMemory finalize.

        finalized := IdentitySet new.

        "Anyone whose object is nil has been garbage collected, othewise put them back in our cache."
        keys keysAndValuesDo:
                [:object :key |
                object
                        ifNil: [finalized add: key]
                        ifNotNil: [cache at: key put: object]].
        keys clearDeadSlots "finalizeValues" .
        recordCache forgetRecords: finalized.
        database forgetKeys: finalized.
        self connection forgetObjects: finalized asArray.
!

invalids
	^ self connection invalids
!

keyForObject: anObject
	| key |
	^ keys
		at: anObject
		ifAbsent:
			[key := recordCache allocateObject: anObject.
			self at: key put: anObject.
			key]
!

keysAndObjects
	^ cache
!

keysAndValuesDo: aBlock
	^ cache keysAndValuesDo: aBlock
!

refresh
	| invalids |
	self checkForNewInvalids.
	invalids := self invalids.
	invalids ifNotNil:
		["We don't need to load records for objects that we haven't accessed (ie exist in the recordCache but not in the keyCache).  We do need to remove them from our recordCache though, so that it doesn't think that it has an up-to-date version of these objects."
		recordCache forgetAll: (invalids asSet difference: cache keys).
		"Load all the ones that we've accessed"
		(invalids select: [:each | cache keys includes: each]) do: [ :key | self loadObjectAt: key ] ]
!

rollback
	dirtySet dirtyKeysAndObjectsDo:
		[:key :object |
		recordCache objectForRecordAt: key ifPresent:
			[:state |
			object become: state.
			object goodsUpdate.
			database objectRolledBack: object]].
	dirtySet reset
!

root
	^ self at: self rootKey
!

root: anObject
	self at: self rootKey put: anObject.
	dirtySet markDirty: anObject.
!

size
	^ cache size
! !

!KKKeyCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKKeyCache.st,v 1.4 2013-03-31 23:34:16 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKKeyCache.st,v 1.4 2013-03-31 23:34:16 cg Exp $'
! !

