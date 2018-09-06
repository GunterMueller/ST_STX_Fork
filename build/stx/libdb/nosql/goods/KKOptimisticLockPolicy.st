"{ Package: 'stx:libdb/nosql/goods' }"

KKConcurrencyPolicy subclass:#KKOptimisticLockPolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Lock Policies'
!

KKOptimisticLockPolicy comment:'A lock policy that does not try to implicitly lock any objects.  With this lock policy it is possible that a commit will fail due to a conflict (two sessions modified the same object).'
!


!KKOptimisticLockPolicy methodsFor:'public'!

keysForgotten: aCollection
!

objectAccessed: anObject
!

objectChanged: anObject
	"With optimistic locking, we don't do anything in reaction to an object change."
!

objectRolledBack: anObject
!

requiresWriteBarrier

	^false
!

setDatabase: aDatabase
!

shouldDowngradeDirtyOnCommit
	^false
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

!KKOptimisticLockPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKOptimisticLockPolicy.st,v 1.3 2013-03-31 12:11:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKOptimisticLockPolicy.st,v 1.3 2013-03-31 12:11:40 cg Exp $'
! !

