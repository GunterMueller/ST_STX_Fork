"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DOUserPolicy subclass:#DOMultiUserPolicy
	instanceVariableNames:'lockedFiles'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOMultiUserPolicy class methodsFor:'As yet unclassified'!

testMultiObjectsPerFile
!

testSingleObjectPerFile
!

testTheConcept1

	"Test to see if my multi-user concurrency concept will even work.

	Start this method on machine one.  Then start testTheConcept2 on machine two."



	| me lockName |

	lockName := 'K:\TEST.LOK'.

	me := self new.

	[FlavorCompatibility doesFileExist: lockName] 

		whileFalse: [FlavorCompatibility wait].

	self testTheConcept2.
!

testTheConcept2

	"Start this method on machine two."



	| me lockName |

	lockName := 'K:\TEST.LOK'.

	me := self new.

	1 to: 10 do: 

		[ :x |

		me tryToLock: lockName times: 10.

		Transcript nextPutAll: 'Set lock: '; nextPutAll: Time current asString; cr.

		FlavorCompatibility wait; wait.

		FlavorCompatibility removeFileNamed: lockName.

		Transcript nextPutAll: 'Removed lock at: '; nextPutAll: Time current asString; cr.]
! !

!DOMultiUserPolicy methodsFor:'As yet unclassified'!

commitTransaction

	"Save my changes and remove all of the locks I have placed."



	super commitTransaction.

	self removeLocks.
!

delete: aDOWrapper using: objectsPerFilePolicy



	objectsPerFilePolicy deleteMultiUser: aDOWrapper
!

isLocked: fileNameString

	"Answer a boolean"



	^self lockedFiles includes: fileNameString
!

isMultiUser



	^true
!

lockFileNamed: aString

	"Set the lock on this file name string."



	| lockName |

	lockName := FlavorCompatibility lockNameForFile: aString.

	(self lockedFiles includes: aString)

		ifTrue: [^self].

	self tryToLock: lockName times: 20.

	self lockedFiles add: aString.
!

lockedFiles

	"Private - Answer the set of file names that have been locked by me."



	lockedFiles == nil

		ifTrue: [lockedFiles := Set new: 10].

	^lockedFiles
!

readFileNamed: aString

	"If a transaction is going on, I need to lock the file anyways since I'll depend on it not changing."



	self duringTransaction

		ifTrue: [self lockFileNamed: aString].

	^super readFileNamed: aString.
!

readForUpdate: aFullFileName

	"Read anObject from aFullFileName.  This will lock this file until you store or commit it."



	self lockFileNamed: aFullFileName.

	^super readFileNamed: aFullFileName.
!

removeLocks

	"Remove all locks that I have set.  I use a copy of the lockedFiles collection because

	the #unlockFileNamed: method removes items from the unlockedFiles collection."



	self lockedFiles copy 

		do: [ :each | self unlockFileNamed: each.]
!

rollbackTransaction

	"Remove all of the locks I have placed.  Since nothing is saved yet, I don't have to explicitly roll anything back.."



	self duringTransaction

		ifFalse: [self error: 'You must begin a transaction before rolling it back.'].

	self removeLocks.

	super rollbackTransaction.
!

store: fileContents

to: fileNameString

    "Save anObject to fileNameString.  This method does no version checking."



    self lockFileNamed: fileNameString.

    super store: fileContents to: fileNameString.

    self duringTransaction

	ifFalse: [self unlockFileNamed: fileNameString].
!

tryToLock: aLockFileName

times: anInteger

	"Private - Set the lock on this file name string. Signal LockStuckError if I can't get it."



	| i successful |

	i := anInteger.

	successful := true.

	[i > 0] whileTrue:      

		[successful := true.

		FlavorCompatibility

		createLockFile: aLockFileName

		ifExists: 

			[successful := false.

			FlavorCompatibility waitFor: 500].

		successful ifTrue: [^self].

		i := i + -1].

	self signalLockStuckError.
!

unlockFileNamed: aString

	"Remove the lock on this file name string."



	| lockName |

	lockName := FlavorCompatibility lockNameForFile: aString.

	FlavorCompatibility removeFileNamed: lockName.

	self lockedFiles remove: aString.
! !

!DOMultiUserPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOMultiUserPolicy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
