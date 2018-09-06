"{ Package: 'stx:libdb/nosql/goods' }"

KKConcurrencyPolicy subclass:#KKPessimisticLockPolicy
	instanceVariableNames:'database timeoutMilliseconds'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Lock Policies'
!

KKPessimisticLockPolicy comment:'Lock an object as soon as it is modified in this session.  Avoids most commit conflicts but can cause deadlocks.  Conflicts can still occur if this session accesses an object written by another session and we are using a Read-Write isolation policy.
To avoid deadlocks you may specify a lock timeout (or zero to simply "try" the lock without waiting).  The longer the timeout, the more "deadlocked"-like your application may appear if there is a lock cycle. A nil timeout indicates an infinite timeout.  Any timeout (besides nil) means that a lock operation, and therefore an object mutation, may fail with a KKLockFailed error.  Applications should be prepared to handle this error by retrying their operation.'
!


!KKPessimisticLockPolicy methodsFor:'accessing'!

timeoutMilliseconds
	^ timeoutMilliseconds
!

timeoutMilliseconds: anObject
	timeoutMilliseconds := anObject
! !

!KKPessimisticLockPolicy methodsFor:'private'!

downgradeLock: anObject
	database downgradeLock: anObject
!

lock: anObject
	self lock: anObject shared: false
!

lock: anObject shared: shared
	timeoutMilliseconds ifNotNil:
		[self lockUsingTimeout: anObject shared: shared].
	shared ifTrue: [database readLock: anObject] ifFalse: [database writeLock: anObject]
!

lockUsingTimeout: anObject shared: shared
	| deadline lockObtained method |
	method := shared ifTrue: [#tryReadLock:] ifFalse: [#tryWriteLock:].
	deadline := Time millisecondClockValue + timeoutMilliseconds.
	[(lockObtained := database perform: method with: anObject)
		or: [Time millisecondClockValue >= deadline]] whileFalse:
			["Pick an decent delay"
			|delay|
			delay := (deadline - Time millisecondClockValue) // 10.
			delay > 0 ifTrue: [(Delay forMilliseconds: delay) wait]].
	lockObtained ifFalse: [KKLockFailed raiseSignal: 'Failed to obtain lock']
!

unlock: anObject
	database unlock: anObject
! !

!KKPessimisticLockPolicy methodsFor:'public'!

keysForgotten: aCollection
!

objectAccessed: anObject
!

objectChanged: anObject
	self lock: anObject
!

objectRolledBack: anObject
	self unlock: anObject
!

requiresWriteBarrier

	^true
!

setDatabase: aDatabase
	database := aDatabase
!

shouldDowngradeDirtyOnCommit
	^false
!

shouldDowngradeOnVerify
	^false
!

shouldUnlockDirtyOnCommit
	^true
!

shouldUnlockOnVerify
	^false
! !

!KKPessimisticLockPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKPessimisticLockPolicy.st,v 1.3 2013-03-31 12:02:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKPessimisticLockPolicy.st,v 1.3 2013-03-31 12:02:38 cg Exp $'
! !

