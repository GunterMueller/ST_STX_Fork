"{ Package: 'stx:libdb/nosql/goods' }"

KKDatabase subclass:#KKThreadSafeDatabase
	instanceVariableNames:'monitor'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Database'
!

KKThreadSafeDatabase comment:''
!


!KKThreadSafeDatabase methodsFor:'accessing'!

at: aKey
	^self critical: [super at: aKey]
!

root
	^self critical: [super root]
!

root: anObject
	^self critical: [super root: anObject]
! !

!KKThreadSafeDatabase methodsFor:'caching'!

flush
	self critical: [super flush]
!

flushAll
	self critical: [super flushAll]
! !

!KKThreadSafeDatabase methodsFor:'initialization'!

initializeWithConnection: aConnection
	super initializeWithConnection: aConnection.
	monitor := Monitor new
! !

!KKThreadSafeDatabase methodsFor:'locking'!

downgradeLock: anObject
	^self critical: [super downgradeLock: anObject]
!

readLock: anObject
	self critical: [super readLock: anObject]
!

readLock: anObject do: aBlock
	^self critical: [super readLock: anObject do: aBlock]
!

tryReadLock: anObject
	^self critical: [super tryReadLock: anObject]
!

tryWriteLock: anObject
	^self critical: [super tryWriteLock: anObject]
!

unlock: anObject
	self critical: [super unlock: anObject]
!

writeLock: anObject
	self critical: [super writeLock: anObject]
!

writeLock: anObject do: aBlock
	^self critical: [super writeLock: anObject do: aBlock]
! !

!KKThreadSafeDatabase methodsFor:'mutual exclusion'!

critical: aBlock
	^monitor critical: aBlock
! !

!KKThreadSafeDatabase methodsFor:'private'!

forgetKeys: aCollection
	self critical: [super forgetKeys: aCollection]
! !

!KKThreadSafeDatabase methodsFor:'private-change notification'!

objectAccessed: anObject
	self critical: [super objectAccessed: anObject]
!

objectChanged: anObject
	self critical: [super objectChanged: anObject]
! !

!KKThreadSafeDatabase methodsFor:'public'!

logout
	self critical: [super logout]
! !

!KKThreadSafeDatabase methodsFor:'testing'!

isConnected
	^self critical:  [super isConnected]
! !

!KKThreadSafeDatabase methodsFor:'transactions'!

commitOnFailure: aBlock
	^self critical: [super commitOnFailure: aBlock]
!

refresh
	self critical: [super refresh]
!

rollback
	self critical: [super rollback]
! !

!KKThreadSafeDatabase class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKThreadSafeDatabase.st,v 1.3 2013-03-31 12:17:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKThreadSafeDatabase.st,v 1.3 2013-03-31 12:17:43 cg Exp $'
! !

