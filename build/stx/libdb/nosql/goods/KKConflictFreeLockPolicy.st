"{ Package: 'stx:libdb/nosql/goods' }"

KKPessimisticLockPolicy subclass:#KKConflictFreeLockPolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Lock Policies'
!

KKConflictFreeLockPolicy comment:'The strictist locking policy.  "Shared" lock an object as soon as it is accessed in this session and upgrade that lock to an exclusive lock if/when the object is changed.  Avoids commit conflicts but can cause deadlocks.  See superclass for notes on deadlock avoidance.'
!


!KKConflictFreeLockPolicy methodsFor:'private'!

readLock: anObject
	self lock: anObject shared: true
! !

!KKConflictFreeLockPolicy methodsFor:'public'!

keysForgotten: aCollection
	aCollection do: [:key | database unlock: key]
!

objectAccessed: anObject
	self readLock: anObject
!

objectChanged: anObject
	self lock: anObject
!

objectRolledBack: anObject
	self downgradeLock: anObject
!

setDatabase: aDatabase

	super setDatabase: aDatabase.
!

shouldDowngradeDirtyOnCommit
	^true
!

shouldDowngradeOnVerify
	^false
!

shouldUnlockDirtyOnCommit
	^false
!

shouldUnlockOnVerify
	^false
! !

!KKConflictFreeLockPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKConflictFreeLockPolicy.st,v 1.3 2013-03-31 12:15:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKConflictFreeLockPolicy.st,v 1.3 2013-03-31 12:15:31 cg Exp $'
! !

