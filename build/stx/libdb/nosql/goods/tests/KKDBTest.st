"{ Package: 'stx:libdb/nosql/goods/tests' }"

KKAbstractDBTest subclass:#KKDBTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!


!KKDBTest methodsFor:'cache policy tests'!

testCacheRelease
	"This is a subtle integration test.  We populate the database with manual write barrier supporting objects.  Then we create a new session, install an LRR cache policy in that session and set its cache size very small.  As objects are loaded, older ones should be expired from the cache.  We check this by monitoring the cache size (pinned + volatile)."
! !

!KKDBTest methodsFor:'isolation tests'!

testReadWriteConflictMode
	"Arrange for a transaction to have modified an object that another one has /read/.  This should be a commit conflict in read-write detection mode."
	dbTwo detectReadWriteConflicts.
	dbOne root
		at: 'point'
		put: (Array
				with: 1
				with: 2
				with: 3).
	dbOne root
		at: 'other'
		put: (Array
				with: 5
				with: 6
				with: 7).
	dbOne commit.
	dbTwo refresh.
	(dbTwo root at: 'point') printString.   "force it to load"
	(dbTwo root at: 'other')
		at: 1
		put: 101.
	(dbOne root at: 'point')
		at: 2
		put: 99.
	dbOne commit.
	self
		should: [ dbTwo commit ]
		raise: KKCommitFailure
!

testReadWriteConflicts


	| theObject twosVersion |
	dbTwo detectReadWriteConflicts.
	dbOne detectReadWriteConflicts.

	dbOne root at: 'x' put: Association new.
	dbOne commit.

	"Cause dbTwo to load this object"
	twosVersion := dbTwo root at: 'x'.
	twosVersion key.

	"dbOne now modifies this object."
	theObject := dbOne root at: 'x'.
	theObject key: 'foo'.
	dbOne commit.

	"dbTwo hasn't modified twosVersion but can't commit because it accessed this Association."
	self should: [dbTwo commit] raise: KKCommitFailure
!

testSerializable
	"Arrange for a transaction to have modified an object that another one has /read/.  This should be a commit conflict in serializable mode."
	dbTwo detectReadWriteConflicts.
	dbOne root
		at: 'point'
		put: (Array
				with: 1
				with: 2
				with: 3).
	dbOne root
		at: 'other'
		put: (Array
				with: 5
				with: 6
				with: 7).
	dbOne commit.
	dbTwo refresh.
	(dbTwo root at: 'point') printString.   "force it to load"
	(dbTwo root at: 'other')
		at: 1
		put: 101.
	(dbOne root at: 'point')
		at: 2
		put: 99.
	dbOne commit.
	self
		should: [ dbTwo commit ]
		raise: KKCommitFailure
!

testWriteWriteConflictMode
	"Arrange for a transaction to have modified an object that another one has /read/.  This should not be a commit conflict in write-write detection mode."
	dbOne root at: 'point' put: (Array with: 1 with: 2 with: 3).
	dbOne root at: 'other' put: (Array with: 5 with: 6 with: 7).
	dbOne commit.
	dbTwo refresh.
	(dbTwo root at: 'point') printString. "force it to load"
	(dbTwo root at: 'other') at: 1 put: 101.
	(dbOne root at: 'point') at: 2 put: 99.
	dbOne commit.
	dbTwo commit
! !

!KKDBTest methodsFor:'locking tests'!

prepareConflictFreeLocking
	dbOne root: KKHolderForWBTest new.
	dbOne commit.
	dbOne := KKDatabase connection: self newConnection.
	dbOne installWriteBarrier: KKManualWriteBarrier new.
	dbTwo installWriteBarrier: KKManualWriteBarrier new.
	dbOne useConflictFreeLocking timeoutMilliseconds: 0.
	dbTwo useConflictFreeLocking timeoutMilliseconds: 0
!

preparePessimisticLocking
	dbOne root: KKHolderForWBTest new.
	dbOne commit.
	dbOne := KKDatabase connection: self newConnection.
	dbOne installWriteBarrier: KKManualWriteBarrier new.
	dbTwo installWriteBarrier: KKManualWriteBarrier new.
	dbOne usePessimisticLocking timeoutMilliseconds: 0.
	dbTwo usePessimisticLocking timeoutMilliseconds: 0
!

testConflictFreeLocking
	"Conflict-free locking should lock-on-read or write"

	self prepareConflictFreeLocking.

	"Exclusive locks the root object"
	dbOne root value1: KKObjectForWBTest new.

	"Other session shouldn't be able to /read/"
	self
		should: [ dbTwo root ]
		raise: KKLockFailed
!

testConflictFreeLockingCommitDowngrades
	"Conflict-free locking should downgrade exclusive locks to shared locks on commit"
	self prepareConflictFreeLocking.

	dbOne root value1: KKObjectForWBTest new.       "locks"
	dbOne commit.   "downgrades"

	"We should be able to read..."
	self assert: (dbTwo root value1 yourself isKindOf: KKObjectForWBTest).

	"...but not write"
	self should: [dbTwo root value1: KKObjectForWBTest new] raise: KKLockFailed.
!

testConflictFreeLockingNoConflict
	"Conflict-free locking should lock-on-write"
	self prepareConflictFreeLocking.

	dbOne root value1: KKObjectForWBTest new.       "locks"
	dbOne root value2: KKObjectForWBTest new.       "locks"
	dbOne commit.   "unlocks"


	"The following two statements lock different objects"
	dbOne root value1 name: 'blah'.

	dbTwo root value2 name: 'foo'.

	dbOne commit.
	dbTwo commit.
!

testConflictFreeLockingRollback
	"Conflict-free locking should downgrade write locks to shared locks on rollback"

	self prepareConflictFreeLocking.

	"Locks the root object"
	dbOne root value1: KKObjectForWBTest new.
	dbOne rollback. "downgrades to shared lock"

	self waitAsyncUnlock.

	"We should be able to read it now"
	dbTwo root.
	"...but not write it since dbOne has it loaded"
	self should: [dbTwo root value1: KKObjectForWBTest new] raise: KKLockFailed
!

testPessimisticLocking
	"Pessimistic locking should lock-on-write"

	self preparePessimisticLocking.

	"Locks the root object"
	dbOne root value1: KKObjectForWBTest new.
	self
		should: [ dbTwo root value1: KKObjectForWBTest new ]
		raise: KKLockFailed
!

testPessimisticLockingCommitUnlocks
	"Pessimistic locking should unlock on commit"
	self preparePessimisticLocking.

	dbOne root value1: KKObjectForWBTest new.       "locks"
	dbOne commit.   "unlocks"
	dbTwo root value1: KKObjectForWBTest new.
	dbTwo commit
!

testPessimisticLockingNoConflict
	"Pessimistic locking should only lock written objects"
	self preparePessimisticLocking.

	dbOne root value1: KKObjectForWBTest new.       "locks"
	dbOne root value2: KKObjectForWBTest new.       "locks"
	dbOne commit.   "unlocks"

	"The following two statements lock different objects -- no conflict"
	dbOne root value1 name: 'blah'.
	dbTwo root value2 name: 'foo'.

	dbOne commit.
	dbTwo commit.
!

testPessimisticLockingRollback
	"Pessimistic locking should unlock on rollback"

	self preparePessimisticLocking.

	"Locks the root object"
	dbOne root value1: KKObjectForWBTest new.
	dbOne rollback. "unlocks"

	self waitAsyncUnlock.
	dbTwo root value1: KKObjectForWBTest new
!

waitAsyncUnlock
	"The unlock request is asynchronous (no reply expected) so we wait a little to let it go through"
	(Delay forMilliseconds: 50) wait
! !

!KKDBTest methodsFor:'tests'!

benchmark
    "time to do 1000 updates of a sequence number;
     from: http://www.visoracle.com/squeak/faq/performance.html "

    |time db base nextCustomerNo|

    time := Time 
            millisecondsToRun:[
                Transcript cr.
                db := KKDatabase 
                        onHost:(KKConnection defaultHost)
                        port:(KKConnection defaultPort).
                db root at:'Sequences' put:(Dictionary new).
                db commit.
                base := db root at:'Sequences'.
                nextCustomerNo := base at:'CustomerNo' ifAbsent:[ 0 ].
                [
                    0 to:999 do:[:i | 
                        (i \\ 100) = 0 ifTrue:[
                            Transcript show:'.'
                        ].
                        nextCustomerNo := nextCustomerNo + 1.
                        base at:'CustomerNo' put:nextCustomerNo.
                        db commit
                    ]
                ] ensure:[ db logout ]
            ].

    Transcript
        show:(time / 1000) asFloat;
        showCR:' seconds'.

    db := KKDatabase 
            onHost:(KKConnection defaultHost)
            port:(KKConnection defaultPort).
    base := db root at:'Sequences'.
    Transcript
        show:'Last Customer No: ';
        showCR:(base at:'CustomerNo').
    db logout.
!

testBoolean
	dbOne root at: 'true' put: true.
	dbOne root at: 'false' put: false.
	dbOne commit.
	dbTwo refresh.
	self assert: (dbTwo root at: 'true').
	self deny: (dbTwo root at: 'false').
!

testCharacters
	dbOne root at: 'c' put: $c.
	dbOne root at: 'd' put: $d.
	dbOne commit.
	dbTwo refresh.
	self assert: (dbTwo root at: 'c') = $c.
	self assert: (dbTwo root at: 'd') = $d.
	self assert: (String streamContents: [:s | s nextPut: (dbTwo root at: 'c'); nextPut: (dbTwo root at: 'd')]) = 'cd'.
!

testClasses
	dbOne root at: 'dict' put: Dictionary.
	dbOne root at: 'oc' put: OrderedCollection.
	dbOne commit.
	self assert: (dbTwo root at: 'dict') = Dictionary.
	self assert: (dbTwo root at: 'oc') = OrderedCollection
!

testCommitWithRetry
	| count result |
	dbOne root at: 'x' put: 23.
	dbOne root at: 'y' put: 42.
	dbOne commit.
	dbTwo refresh.
	dbTwo root at: 'x'.
	count := 0.
	result := dbTwo commitWithRetry:
		[count := count + 1.

		"Cause a conflict the first time around."
		count = 1 ifTrue:
			[dbOne root at: 'r' put: 25.
			dbOne commit].

		"Do this both times.  The second time these are the only changes."
		dbTwo root at: 's' put: 26.
		dbTwo root at: 'y' put: 43.
		count].
	dbOne refresh.
	self assert: (dbOne root at: 's') = 26.
	self assert: (dbOne root at: 'y') = 43.
	self assert: count = 2.
	self assert: result = 2
!

testConflict
	| |
	dbOne root at: 'x' put: 23.
	dbOne root at: 'y' put: 42.
	dbOne commit.
	dbTwo refresh.
	dbTwo root at: 'x'.

	dbOne root at: 'x' put: 25.
	dbOne commit.
	dbTwo root at: 'x' put: 26.
	self should: [dbTwo commit] raise: KKCommitFailure
!

testConnection
	self assert: connOne isConnected.
	self assert: connTwo isConnected
!

testFlushAllRemovesAllUnreferenced

        self assert: dbTwo allCachesObjectCount  = 0.

        "Notice that we copy all of these string literals otherwise, since the compiled method contains references to them, they will not be released from weak dictionary during flush."
        dbTwo root at: 'foo' copy put: 'bar' copy.
        dbTwo root at: 'x' copy put: 'y' copy.

        "/ workaround a 'bug' in ST/X, where temporary values are left in the contexts stack until
        "/ the context returns (or is migrated to the heap).
        "/ thus, 'x' and 'y' would still be referenced at the time of the flushAll, making the
        "/ test fail with allCachesObjectCount being 2.
        "/ To fix, simply force the two temp slots to be overwritten, by calling any method with 2 arguments.
        (Array new:2) at:1 put:1; at:2 put:2; yourself.

        dbTwo commit.

        self assert: dbTwo allCachesObjectCount > 0.

        dbTwo flushAll.

        self assert: dbTwo allCachesObjectCount = 0.
!

testFlushRemovesSomething

	| preFlushCount |
	self assert: dbTwo allCachesObjectCount  = 0.

	"Notice that we copy all of these string literals otherwise, since the compiled method contains references to them, they will not be released from weak dictionary during flush."
	dbTwo root at: 'foo' copy put: 'bar' copy.
	dbTwo root at: 'x' copy put: 'y' copy.
	dbTwo commit.

	self assert: dbTwo allCachesObjectCount > 0.

	preFlushCount := dbTwo allCachesObjectCount.

	dbTwo flushAll.

	self assert: dbTwo allCachesObjectCount < preFlushCount
!

testGoodsUpdateNotSentOnRollbackOfImmutable
	"If we rollback a session, unmodified objects should not be sent #goodsUpdate even if there is NO write barrier."
	| counter |
	dbOne := KKDatabase connection: connOne.
	dbOne root
		at: 'counter'
		put: KKImmutableGoodsUpdateCounter new.
	dbOne commit.
	counter := dbTwo root at: 'counter'.
	self assert: counter goodsUpdateCount = 0.
	dbTwo rollback.
	self assert: counter goodsUpdateCount = 0
!

testGoodsUpdateNotSentOnRollbackOfUnchanged
	"If we refresh a session, unmodified objects should not be sent #goodsUpdate."
	| counter |
	dbOne
		root: KKGoodsUpdateCounter new;
		commit.
	dbOne := KKDatabase connection: connOne.
	dbTwo installWriteBarrier: KKManualWriteBarrier new.
	counter := dbTwo root.
	self assert: counter goodsUpdateCount = 0.
	dbTwo rollback.
	self assert: counter goodsUpdateCount = 0
!

testGoodsUpdateSentOnRollback
	"If we refresh a session, all modified objects should be sent #goodsUpdate."
	| counter |
	dbOne root
		at: 'counter'
		put: (counter := KKGoodsUpdateCounter new).
	dbOne commit.
	self assert: counter goodsUpdateCount = 0.
	counter anIvar: 'some value'.
	dbOne rollback.
	self assert: counter goodsUpdateCount = 1
!

testGoodsUpdateSentOnRollbackEvenWithWriteBarrier
	"If we refresh a session, all modified objects should be sent #goodsUpdate.  This should happen even if a write barrier is installed."
	| counter |
	dbOne
		root: KKGoodsUpdateCounter new;
		commit.
	dbOne := KKDatabase connection: connOne.
	dbTwo installWriteBarrier: KKManualWriteBarrier new.
	counter := dbTwo root.
	counter anIvar: 'something'.
	self assert: counter goodsUpdateCount = 0.
	dbTwo rollback.
	self assert: counter goodsUpdateCount = 1
!

testGrowingOrderedCollection
	"Indexed collections may need to grow or shrink when being refreshed"

	| oc |
	oc := OrderedCollection with: 1 with: 2.
	dbOne root at: 'oc' put: oc.
	dbOne commit.

	self assert: (dbTwo root at: 'oc') first = 1.
	self assert: (dbTwo root at: 'oc') second = 2.

	100 timesRepeat: [oc add: oc size + 1].
	dbOne commit.

	dbTwo refresh.
	self assert: ((dbTwo root at: 'oc') at: 100) = 100.
!

testIdentitySet
	| set x y y2 |
	set := KKIdentitySet database: dbOne.
	x := 1@1.
	y := 2@2.
	set add: x.
	set add: y.
	self assert: (set includes: x).
	self assert: (set includes: y).
	self deny: (set includes: 1@1).
	set remove: x.
	self assert: (set includes: y).
	self deny: (set includes: x).
	dbOne root at: 'set' put: set.
	dbOne commit.
	dbTwo refresh.
	set := dbTwo root at: 'set'.
	y2  := set anyOne.
	self assert: y2 = y.
	self deny: y2 == y.
	self assert: (set includes: y2).
	self deny: (set includes: y).

!

testNumbers
	dbOne root at: 'fortytwo' put: 42.
	dbOne root at: 'neg3' put: -3.
	dbOne root at: 'zeropointfivefloat' put: 0.5 asFloat.
	dbOne commit.
	dbTwo refresh.
	self assert: (dbTwo root at: 'fortytwo') = 42.
	self assert: (dbTwo root at: 'neg3') = -3.
	self assert: (dbTwo root at: 'zeropointfivefloat') = 0.5 asFloat
!

testRefreshAfterMultipleChanges
	dbOne root: (Array new: 3).
	dbOne commit.

	dbOne root at: 1 put: 'a'->'b'.
	dbOne root at: 2 put: 'c'->'d'.
	dbOne root at: 3 put: 'e'->'f'.
	dbOne commit.

	"Force db 2 to load + check sanity"
	self assert: (dbTwo root at: 1) value = 'b'.
	self assert: (dbTwo root at: 2) value = 'd'.
	self assert: (dbTwo root at: 3) value = 'f'.

	(dbOne root at: 1) value: 'q'.
	dbOne commit.

	(dbOne root at: 2) value: 'r'.
	dbOne commit.

	(dbOne root at: 3) value: 's'.
	dbOne commit.

	dbTwo refresh.
	self assert: (dbTwo root at: 1) value = 'q'.
	self assert: (dbTwo root at: 2) value = 'r'.
	self assert: (dbTwo root at: 3) value = 's'.
!

testRefreshDoesntMakeDirty
	"Make sure that refreshing an object doesn't cause it to be 'dirty'"

	dbOne root at: 'x' put: Array new.
	dbTwo root size.  "force dbTwo to fetch dictionary"
	dbOne commit.
	dbTwo refresh.
	dbOne root at: 'y' put: Array new.
	dbOne commit.
	dbTwo commit. "dbTwo has nothing to commit...should not raise an error"
!

testRefreshRoot
	dbOne root at: 'x' put: 1.
	dbOne commit.
	dbTwo refresh.
	self assert: (dbTwo root at: 'x') = 1.
	dbTwo root at: 'y' put: 3.
	dbTwo commit.
	self assert: dbOne root size = 1.
	dbOne refresh.
	self assert: dbOne root size = 2.
!

testRollbackExistingObject
	dbOne root: #(1 2 3) copy.
	dbOne commit.
	dbTwo root at: 1 put: 0.
	dbTwo commit.
	dbOne refresh.
	dbOne rollback.
	self assert: dbOne root = dbTwo root
!

testRootNode
	self assert: (dbOne root isKindOf: Dictionary).
	dbOne root: #(23).
	dbOne commit.
	dbTwo refresh.
	self assert: dbTwo root = #(23).
!

testSpecialObjects
	dbOne root at: 'test' put: dbOne.
	dbOne commit.
	dbTwo refresh.
	self assert: (dbTwo root at: 'test') == dbTwo
!

testTransactions
	" testNode1 should be an OrderedCollection"
	| dbOneNode1 dbTwoNode1 |
	dbOneNode1 := dbOne root at: 'TestNode1' ifAbsentPut: [OrderedCollection new].
	dbOne commit.
	dbTwo refresh.
	dbTwoNode1 := dbTwo root at: 'TestNode1'.

	dbOneNode1 reset.
	self assert: dbOneNode1 isEmpty.
	(1 to: 10) do: [:i | dbOneNode1 add: i].
	dbOne commit.
	dbTwo refresh.
	self assert: dbTwoNode1 asArray = #(1 2 3 4 5 6 7 8 9 10).

	dbOneNode1 reset.
	(11 to: 20) do: [:i | dbOneNode1 add: i].
	dbOne rollback.
	dbTwo refresh.
	self deny: dbTwoNode1 asArray =  #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20).

! !

!KKDBTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKDBTest.st,v 1.4 2013-04-01 18:19:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/tests/KKDBTest.st,v 1.4 2013-04-01 18:19:01 cg Exp $'
! !

