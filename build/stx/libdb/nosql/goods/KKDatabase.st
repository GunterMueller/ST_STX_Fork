"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKDatabase
	instanceVariableNames:'connection keyCache specialObjects isolationLevel lockPolicy'
	classVariableNames:'DefaultTransportClass WriteBarrierClass'
	poolDictionaries:''
	category:'DataBase-GOODS-Database'
!

!KKDatabase class methodsFor:'documentation'!

examples
"
    |db|

    db := KKDatabase onHost: 'localhost' port: 2006.
    db root:(Dictionary new).
    db commit.
    db
"
! !

!KKDatabase class methodsFor:'instance creation'!

connection: aConnection
	^ self basicNew initializeWithConnection: aConnection
!

onHost: hostname port: aNumber
	^ self connection: (KKConnection hostname: hostname port: aNumber)
!

onHost: hostname port: aNumber loginName: aString
	^ self connection: (KKConnection
				hostname: hostname
				port: aNumber
				sessionName: aString)
! !

!KKDatabase class methodsFor:'global configuration'!

defaultTransportClass
	^DefaultTransportClass ifNil: [self error: 'Default transport class must be configured to a platform-appropriate value.  Normally this is done during package loading but for some reason didn''t happen here.  You need to send KKDatabase>>defaultTransportClass: with a concrete subclass of KKTransport.']
!

defaultTransportClass: aTransportClass
	DefaultTransportClass := aTransportClass
!

writeBarrierClass

	^WriteBarrierClass
!

writeBarrierClass: aClass
	WriteBarrierClass := aClass
! !

!KKDatabase class methodsFor:'private-write barrier'!

createWriteBarrierOrNil
	^WriteBarrierClass notNil
		ifTrue: [WriteBarrierClass new]
		ifFalse: [nil]
! !

!KKDatabase methodsFor:'accessing'!

root

	^ keyCache root
!

root: anObject
	"Set the root object of the database to anObject."

	"For an existing OID, GOODS requires that we have loaded the corresponding object before we are permitted to write it.  If we haven't loaded the root object, do it now (just in case the database already has one)."
	self root.
	^ keyCache root: anObject
!

sessionName

	^ connection sessionName
! !

!KKDatabase methodsFor:'caching'!

flush
        "Remove any objects, that aren't referenced elsewhere, from my caches.  
         This process involves a garbage collection which, in this method, 
         is just a scavange so not all unreferenced objects will be removed.  See #flushAll.

         If a write barrier is not in use then flush could potentially remove modified objects from the cache 
         and should only be called after a commit or rollback."

        keyCache flushWithFullGC: false
!

flushAll
        "Remove any objects, that aren't referenced elsewhere, from my caches.  
         This process involves a full garbage collection so all unreferenced objects should be removed 
         at the expense of a potentially significant delay.  See #flush.

         If a write barrier is not in use then flushAll could potentially remove modified objects 
         from the cache and should only be called after a commit or rollback."

        keyCache flushWithFullGC: true
! !

!KKDatabase methodsFor:'connection'!

isConnected
	^ connection isConnected
!

logout

	connection logout.
! !

!KKDatabase methodsFor:'initializing'!

initializeSpecialObjects
	specialObjects := IdentityDictionary new.
	specialObjects
		at: self
		put: -1.
	KKPlatform default
		addPlatformSpecialObjectsTo: specialObjects
!

initializeWithConnection: aConnection
	connection := aConnection.
	self initializeSpecialObjects.
	self installWriteBarrier: self class createWriteBarrierOrNil.
	self useOptimisticLocking
! !

!KKDatabase methodsFor:'isolation level'!

detectReadWriteConflicts
	"On commit signal KKCommitFailure in the event of write-write and read-write conflicts.

	Read write conflicts occur when a session has read an object that was written by an overlapping session.  At commit time, objects that were modified by this session are sent (as usual) but we also request that the GOODS server verify that objects that were simply read by this session were not modified by others.  This is a very strict isolation level and is expected to be useful in only very specialized applications.  Most applications will use #detectWriteWriteConflicts instead."

	isolationLevel := KKReadWriteIsolationLevel new
!

detectWriteWriteConflicts
	"On commit signal KKCommitFailure in the event of write-write conflicts between sessions.

	This is the default isolation level.  When a transaction is committed, only objects modified by that transaction are checked against objects modified by other transactions.  If there is an overlap in the modified objects, KKCommitFailure will result."

	isolationLevel := KKWriteWriteIsolationLevel new
!

useConflictFreeLocking
	"With conflict-free locking, objects are implicitly shared-locked by the client whenever they are accessed  (you may, of course, lock objects yourself).  When a persistent object is modified, an attempt is made to upgrade this lock to an exclusive lock.  A commit of a transaction should not receive KKCommitFailure in this mode.  Note:

	- if a lock timeout is not set, your application may deadlock
	- if a lock timeout is used you may receive KKLockFailed errors on load or mutation of objects

	Use of this lock policy requires that a write barrier is in place!!"

	self installLockPolicy: KKConflictFreeLockPolicy new.
	^ lockPolicy
!

useOptimisticLocking
	"With optimistic locking, objects are not implicitly locked by the client (you may, of course, lock objects yourself).  A commit of a transaction may fail with a KKCommitFailure if some other session has modified a subset of the objects modified by this session.

	Answers the lock policy which has no configuration parameters so ignore it."

	self installLockPolicy: KKOptimisticLockPolicy new.
	^ lockPolicy
!

usePessimisticLocking
	"With pessimistic locking, objects are implicitly locked by the client whenever they are changed (you may, of course, lock objects yourself).  A commit of a transaction is less likely to fail with a KKCommitFailure although it may still do so depending on your transaction isolation level.  Note:

	- if a lock timeout is not set, your application may deadlock
	- if a lock timeout is used you may receive KKLockFailed errors on mutation of objects

	Answers the lock policy which you can configure with a timeout if you like (default is infinite).

	Use of this lock policy requires that a write barrier is in place!!"

	self installLockPolicy: KKPessimisticLockPolicy new.
	^ lockPolicy
! !

!KKDatabase methodsFor:'locking'!

downgradeLock: anObject

	connection unlockObject: (self keyForObject: anObject) completely: false
!

readLock: anObject

	connection lockObject: (self keyForObject: anObject) shared: true wait: true
!

readLock: anObject do: aBlock

	self readLock: anObject.
	^ aBlock ensure: [self unlock: anObject]
!

tryReadLock: anObject

	^ connection lockObject: (self keyForObject: anObject) shared: true wait: false
!

tryWriteLock: anObject

	^ connection lockObject: (self keyForObject: anObject) shared: false wait: false
!

unlock: anObject

	connection unlockObject: (self keyForObject: anObject) completely: true
!

writeLock: anObject

	connection lockObject: (self keyForObject: anObject) shared: false wait: true
!

writeLock: anObject do: aBlock

	self writeLock: anObject.
	^ aBlock ensure: [self unlock: anObject]
! !

!KKDatabase methodsFor:'private'!

at: oid
	"Answer the object with the specified oid."

	^ keyCache at: oid
!

connection
	^connection
!

createKeyCacheWithWriteBarrier: aWriteBarrierOrNil
	^ KKKeyCache
		database: self
		writeBarrier: (aWriteBarrierOrNil ifNil: [KKNonWriteBarrier new])
!

doCluster
	"Cluster reads (try to read multiple objects at a time speculatively)"
	keyCache doCluster
!

dontCluster
	"Don't cluster reads (don't try to read multiple objects at a time speculatively)"
	keyCache dontCluster
!

forgetKeys: aCollection
	"These keys have been removed from our keyCache as they are not (strongly) referenced anywhere."

	lockPolicy keysForgotten: aCollection
!

installLockPolicy: aLockPolicy
	(aLockPolicy requiresWriteBarrier and: [ keyCache writeBarrier isNil ]) ifTrue:
		[ self error: 'A write barrier must be in use for a lock policy to be installed.  See #installWriteBarrier or on my class side #writeBarrierClass:' ].
	lockPolicy := aLockPolicy.
	lockPolicy setDatabase: self
!

installWriteBarrier: aWriteBarrierOrNil
	"Enable a write barrier.  Must be sent before any object is stored or retrieved on this connection!!"
	(keyCache notNil and: [ keyCache keysAndObjects notEmpty ]) ifTrue:
		[ self error: 'Write barrier must be installed before any objects are loaded or written to the DB' ].
	keyCache := self createKeyCacheWithWriteBarrier: aWriteBarrierOrNil.
	aWriteBarrierOrNil ifNotNil:
		[aWriteBarrierOrNil database: self.
		self useOptimisticLocking]
!

isolationLevel
	^ isolationLevel ifNil: [self detectWriteWriteConflicts. ^isolationLevel]
!

keyCache

	^keyCache
!

keyForObject: anObject
	^ anObject class == KKObjectProxy
		ifTrue: [anObject xxxKey]
		ifFalse: [specialObjects at: anObject ifAbsent: [keyCache keyForObject: anObject]]
!

objectForKey: key
	^ key > 0
		ifTrue: [keyCache at: key ifAbsent: [KKObjectProxy database: self key: key]]
		ifFalse: [specialObjects keyAtValue: key]
!

objectRolledBack: anObject
	"Sent from the keyCache to tell us that the specified object was rolled back to its original state"

	lockPolicy objectRolledBack: anObject
!

shouldDowngradeDirtyOnCommit

	^lockPolicy shouldDowngradeDirtyOnCommit
!

shouldDowngradeOnVerify

	^lockPolicy shouldDowngradeOnVerify
!

shouldUnlockDirtyOnCommit

	^lockPolicy shouldUnlockDirtyOnCommit
!

shouldUnlockOnVerify

	^lockPolicy shouldUnlockOnVerify
! !

!KKDatabase methodsFor:'private-change notification'!

objectAccessed: anObject
	"Sent by the key cache when an object is accessed for the first time (once for each object that is accessed)"

	lockPolicy objectAccessed: anObject
!

objectChanged: anObject
	"Sent by the write barrier when an object is changed for the first time (once for each object that is modified)"

	lockPolicy objectChanged: anObject
! !

!KKDatabase methodsFor:'statistics'!

allCachesObjectCount
	"Answer the number of objects in my caches."

	^ self keyCacheObjectCount + self recordCacheObjectCount
!

keyCacheObjectCount
	"Answer the number of objects in my key cache."

	^ keyCache size
!

recordCacheObjectCount

	^keyCache recordCache size
! !

!KKDatabase methodsFor:'transactions'!

commit
	"Commit any modified persistent objects.   Signals KKCommitFailure if the commit fails.  If the commit succeeds, our view of the database is refreshed."

	^ self commitOnFailure: [KKCommitFailure signal]
!

commitOnFailure: aBlock
        "Commit.  If the commit fails, evaluate aBlock.  If it succeeds, refresh us (see #refresh)."

        (self isolationLevel commitKeyCache: keyCache)
                ifTrue: [^ self refresh]
                ifFalse: [ ^ aBlock value ]
!

commitWithRetry: aBlock
	"Start with a refreshed database (see #refresh).  Evaluate aBlock.  Commit and if the commit fails, rollback and repeat."

	| val |
	self refresh.
	val := aBlock value.
	self commitOnFailure: [self rollback. ^self commitWithRetry: aBlock].
	^ val.
!

emptyWriteBarrier
	keyCache emptyWriteBarrier
!

refresh
	"Fold changes made by other sessions since our last commit/rollback/start of this session into objects I have loaded.  This may overwrite changes made by this session unless pessimistic locking is being employed."

	keyCache refresh
!

rollback
	"Return in-image objects that we have modified to the state they were in when we loaded them from the database and then load any changes (to any persistent objects we have in-image) made to the database since the time we last committed/rollbacked/started this session."

	keyCache rollback.
	self refresh.
! !

!KKDatabase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKDatabase.st,v 1.6 2013-03-31 23:09:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKDatabase.st,v 1.6 2013-03-31 23:09:06 cg Exp $'
! !

