"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DiskObjectServices subclass:#DOUserPolicy
	instanceVariableNames:'changedFiles transactionReadCache transactionWriteCache
		rollbackBlocks'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOUserPolicy class methodsFor:'As yet unclassified'!

Comment

	"       Instance of this class store and retrieve objects at the file level. Dealing with the

	individual objects is is left up to the objects-per-file policy.



		A certain amount of transaction processing is supported.        Use beginTransaction

	and commitTransaction (or rollbackTransaction) to use it.

        

		During a transaction all read and store commands will be saved in the cache

	until committed or rolled back. If multi-user, all read files will be locked until 

	commit or rollback.  This is to help avoid extra disk reads and writes for 

	multi-object processing"
! !

!DOUserPolicy methodsFor:'As yet unclassified'!

addRollbackBlock: aBlock



	rollbackBlocks isNil

		ifTrue: [rollbackBlocks := OrderedCollection new].

	rollbackBlocks add: aBlock.
!

beginTransaction

	"Set the transactionCache instance variables to a new Dictionary.

	All read and store commands will be saved in the cache until commit time.

	If multi-user, all read files will be locked until commit or rollback."



	(FlavorCompatibility isDictionary: transactionWriteCache)

		ifTrue:

			[transactionWriteCache isEmpty

				ifTrue: [^self]

				ifFalse: [self error: 'Transaction must be committed or rolled back before beginning a new one.']].

	transactionWriteCache := Dictionary new.

	transactionReadCache := Dictionary new.

	changedFiles := Set new.
!

commitTransaction

	"Save all changed files to disk and wipe out the transactionCaches."

        

	"If I want to get fancy I could backup each file before writing them, and then 

	delete the backup after all are saved okay (I'm afraid this would be too inefficient).

	For now we'll just live with the possibility of a power failure during the commit."

	self duringTransaction

		ifFalse: [self error: 'You must begin a transaction before committing it.'].

	transactionWriteCache

		associationsDo:

			[:each | FlavorCompatibility dumpObject: each value toNewFile: each key].

	transactionWriteCache := nil.

	transactionReadCache := nil.

	changedFiles := nil.

	rollbackBlocks := OrderedCollection new.
!

duringTransaction

	"Answer true or false."



	^transactionWriteCache ~= nil.
!

initialize



	rollbackBlocks := OrderedCollection new.

!

isMultiUser



	^false
!

isSingleUser



	^false
!

readFileNamed: aString

	"Check the write cache.  If nothing found, check the read cache.  

	If nothing found there either, read the file named aString."



	^self duringTransaction

		ifTrue:

			[self

				transactionWriteCacheAt: aString 

				ifAbsent:

					[self

						transactionReadCacheAt: aString

						ifAbsentPutValueOf: [FlavorCompatibility loadObjectFromFileNamed: aString].

					].

			]

		ifFalse:

			[FlavorCompatibility loadObjectFromFileNamed: aString].
!

rollbackTransaction

	"Wipe out the transactionCache instance variable."



	transactionWriteCache := nil.

	transactionReadCache := nil.

	changedFiles := nil.

	rollbackBlocks reverseDo: [:each | each value].

	rollbackBlocks := OrderedCollection new.

!

store: fileContents

to: fileNameString

	"Save anObject to fileNameString."



	self duringTransaction

		ifTrue:

			[ "Save these changes in the transactionWriteCache to write at commit time."

			self transactionWriteCacheAt: fileNameString put: fileContents.

			changedFiles add: fileNameString]

		ifFalse:

			[FlavorCompatibility dumpObject: fileContents toNewFile: fileNameString].
!

transactionReadCacheAt: aString ifAbsentPutValueOf: aBlock



	^transactionReadCache

		at: aString

		ifAbsentPut: aBlock
!

transactionWriteCacheAt: aString ifAbsent: aBlock



	^transactionWriteCache 

		at: aString 

		ifAbsent: aBlock.
!

transactionWriteCacheAt: aString put: anObject



	^transactionWriteCache 

		at: aString 

		put: anObject
!

update: aDOWrapper to: fileNameString

    "Do object version checking.  This method to be used only by a SingleObjectService."



	| wrapper contents |

	contents := self readForUpdate: fileNameString.

	wrapper := DOWrapper fromArray: contents.

	aDOWrapper compareVersionWith: wrapper.

	self addRollbackBlock: aDOWrapper rollbackBlock.

	self store: aDOWrapper asArray to: fileNameString.
! !

!DOUserPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOUserPolicy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
