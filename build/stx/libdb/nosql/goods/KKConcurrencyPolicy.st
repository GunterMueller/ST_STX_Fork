"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKConcurrencyPolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Lock Policies'
!

KKConcurrencyPolicy comment:'A lock policy dictates how and when an object is locked implicitly by the client.  It is provided with opportunities to act on:
	object loaded from database
	object modified for the first time (if a write barrier is in use)
'
!


!KKConcurrencyPolicy methodsFor:'public'!

keysForgotten: aCollection
	"The keys in aCollection are no longer referenced anywhere in the application and have been removed from our client-side caches."

	self subclassResponsibility
!

objectAccessed: anObject
	"Sent the first time anObject is accessed.  Sent once for each object accessed between commits/rollbacks."
	self subclassResponsibility
!

objectChanged: anObject
	"Sent the first time anObject is changed (if a write barrier is in use).  Sent once for each object changed between commits/rollbacks."
	self subclassResponsibility
!

objectRolledBack: anObject
	"Sent after the state of anObject has been rolled-back to the version stored
	in the record cache (the version originally loaded by the session)"
	self subclassResponsibility
!

requiresWriteBarrier
	"Answer true if and only if this lock policy requires a write barrier."

	^self subclassResponsibility
!

setDatabase: aDatabase
	"Sent when the lock policy is installed.  Passed the KKDatabase."
	self subclassResponsibility
!

shouldDowngradeDirtyOnCommit
	"Should object locks be downgraded from exclusive to shared when they are being written during commit?"
	self subclassResponsibility
!

shouldDowngradeOnVerify
	"Should object locks be downgraded from exclusive to shared when they are being verified during commit?"
	self subclassResponsibility
!

shouldUnlockDirtyOnCommit
	"Should objects be unlocked when they are being written during commit?"
	self subclassResponsibility
!

shouldUnlockOnVerify
	"Should objects be unlocked when they are being verified during commit?"
	self subclassResponsibility
! !

!KKConcurrencyPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKConcurrencyPolicy.st,v 1.3 2013-03-31 12:16:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKConcurrencyPolicy.st,v 1.3 2013-03-31 12:16:41 cg Exp $'
! !

