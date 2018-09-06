"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MinneStoreDB
	instanceVariableNames:'objectSets path duringTransaction persistenceCreationMethod
		uniqueObjectSets unused1 unused2 unused3 unused4'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MinneStoreDB class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

Version

	"This version adds the functionality of MinneStoreDB>>getValuesOf: indexName from: objectSetName"

        

	^'2.03' 
!

fileName



	^'MSdb.obj'
!

newOn: aString

	"Public - Instantiate myself and set path to aString.

	Beware, using this will erase whatever exists on path named aString"



	(FlavorCompatibility doesDirectoryExist: aString)

		ifTrue: [self error: 'This directory already exists: ', aString, '  Cannot create a new one here'].

	self initializePath: aString.

	^self basicNew

		path: aString;

		initialize;

		yourself.
!

openOn: pathName

	"Public - Load an instance of myself from pathName."



	| path service minneStoreDB |

	path := (pathName last = FlavorCompatibility directoryDelimiter

		ifTrue: [pathName]

		ifFalse: [pathName , FlavorCompatibility directoryDelimiterString]).

	minneStoreDB := DOSingleObjectService read: path, self fileName.

	minneStoreDB isNil ifTrue: [self error: 'This is not a valid MinneStore path: ', pathName].

	minneStoreDB path asLowercase = path asLowercase

		ifFalse: [minneStoreDB newPath: path].

	^minneStoreDB

	
! !

!MinneStoreDB methodsFor:'As yet unclassified'!

addObjectSetNamed: aSymbol

	"Public"



	| objectSet pathName |

	uniqueObjectSets isNil

		ifTrue: [uniqueObjectSets := OrderedCollection new].

	pathName := self objectSetPathFor: aSymbol.

	uniqueObjectSets do: [:each |

		each path = pathName

			ifTrue:[self error: 'This object set name is too close to ', each name]].

	objectSet := MSObjectSet newOn: pathName for: self.

	objectSet name: aSymbol.

	uniqueObjectSets add: objectSet.

	^objectSets

		at: aSymbol

		put: objectSet.

"****** Not using the save-immediately feature right now.

	self save.

	^self objectSetNamed: aSymbol.

*******"
!

beginTransaction

	"Public - Begin this transaction."



	self objectSetsDo: [:each | each beginTransaction].

	duringTransaction := true.

	
!

commitTransaction

	"Public - Begin this transaction."



	self objectSetsDo: [:each | each commitTransaction].

	duringTransaction := false.

	
!

delete: anObject

	"Public - delete one object.  This is dangerous since other objects may reference it."



	| objectSet result |

	objectSet := (self objectSetsAt: anObject class).

	^duringTransaction

		ifTrue: [objectSet delete: anObject]

		ifFalse:

			[self beginTransaction.

			ExceptionCompatibility

				on: #anyError

				during: [result := objectSet delete: anObject]

				do:     [:exception |

					self rollbackTransaction.

					ExceptionCompatibility pass: exception].

			self commitTransaction.

			result.].
!

fileName



	^self class fileName.
!

forAll: anObjectSetName do: aSingleArgumentBlock

	"Public - pass each object in the objectSet to aSingleArgumentBlock.

	For efficiency this does NOT read all objects before beginning the looping."



	^(self objectSetNamed: anObjectSetName) forAllDo: aSingleArgumentBlock
!

getAll: anObjectSetName

	"Public - Start an object read query."



	^(self objectSetNamed: anObjectSetName) getAll
!

getCount: anObjectSetName

	"Public - Start an object read query."



	^(self objectSetNamed: anObjectSetName) getCount
!

getOne: anObjectSetName

	"Public - Start an object read query."



	^(self objectSetNamed: anObjectSetName) getOne
!

getValuesOf: indexName from: objectSetName

	"Public - Start an index value read query."

        

	^(self objectSetNamed: objectSetName) getValuesOf: indexName
!

idFor: anObject

	"Public - Answer the database id for anObject or nil if it has none."



	^(self objectSetFor: anObject class) dbIdFor: anObject
!

initialize



	duringTransaction := false.

	objectSets := IdentityDictionary new.
!

newPath: aString

	"Private - Used when opening a MinneStoreDB after it has been moved.

	Assume the objectSets have not yet been read from disk.

	each value of the objectSets dictionary should still be a DOService."

        

	| osPath |

	self path: aString.

	objectSets associations do: 

		[ :each |

		(FlavorCompatibility isSymbol: each key) 

			ifTrue: 

				[each value pathName: (osPath := self objectSetPathFor: each key).

				(self objectSetNamed: each key) newPath: osPath.].

		].

	self save.
!

objectSetFor: aClass

	"Public - Answer the object set that stores and retrieves aClass."



	^self objectSetsAt: aClass
!

objectSetNamed: aSymbol

	"Public - Answer the object set that is named aSymbol."



	^self objectSetsAt: aSymbol
!

objectSetPathFor: aSymbol

	"Public - Answer a string."



	^path , (FlavorCompatibility fileNameLike: aSymbol), FlavorCompatibility directoryDelimiterString.
!

objectSetsAt: aClassOrSymbol

	"Private - If the object at aClassOrSymbol is a disk object manager then

	use it to read the object set and replace it with the object set."



	| temp objectSet |

	temp := (objectSets 

			at: aClassOrSymbol 

			ifAbsent: [self error: 'This objectSet has not been defined: ' , aClassOrSymbol printString]).

	^temp isDOService

		ifTrue: [self readObjectSetUsing: temp]

		ifFalse: [temp]  "Then it is an MSObjectSet"
!

objectSetsAt: aClassOrSymbol put: anMSObjectSet

	"Private"



	^objectSets 

		at: aClassOrSymbol

		put: anMSObjectSet

	
!

objectSetsDo: aBlock

	"Public - Begin this transaction."



	| objSet |

	uniqueObjectSets copy do: 

		[:each | 

		objSet := each isDOService

			ifTrue: [self readObjectSetUsing: each]

			ifFalse: [each].

		aBlock value: objSet].
!

path



	^path
!

path: aString

	"Private - Set the path instance variable."



	path := (aString last = FlavorCompatibility directoryDelimiter)

		ifTrue: [aString]

		ifFalse: [aString , FlavorCompatibility directoryDelimiterString].

	
!

persistence

	"Private - Answer an instance of DOSingleObjectService."



	^DOSingleObjectService

		perform: self persistenceCreationMethod

		with: path, self fileName
!

persistenceCreationMethod

	"Private - Answer the method used to create persistence managers."



	persistenceCreationMethod == nil

		ifTrue: [self supportSingleUser].

	^persistenceCreationMethod.
!

readObjectSetUsing: aDOService

	"Answer an MSObjectSet after reading it from the database.

	I use become here because aDOService is in the ObjectSets dictionary

	several times."



	| objectSet |

	objectSet := aDOService read.

	objectSet database: self.

	objectSet myPersistence: aDOService.

	self switchInObjectSets: aDOService with: objectSet.

	^objectSet.
!

removeFromCache: anObject

	"Public - Remove this object from the object identity cache."



	^(self objectSetsAt: anObject class)

		removeFromCache: anObject.
!

rollbackTransaction

	"Public - Begin this transaction."



	uniqueObjectSets

		do: [:each | each rollbackTransaction].

	duringTransaction := false.

	
!

save

	"Private - Save my changes to disk.  This method should be used only after the initial

	database definition or after any other definition changes have been made."



	FlavorCompatibility needsWork. "needs to have a unit of work here."

	uniqueObjectSets do: 

		[:each |

		each isDOService ifFalse: 

			[each save.

			self switchInObjectSets: each with: each myPersistence.

			"each become: each myPersistence."].

		].

	self persistence store: self.
!

store: anObject

	"Public - Store one object."



	| objectSet |

	objectSet := (self objectSetsAt: anObject class).

	duringTransaction

		ifTrue: [objectSet store: anObject]

		ifFalse:

			[self beginTransaction.

			ExceptionCompatibility

				on: #anyError

				during: [objectSet store: anObject]

				do:     [:exception |

					self rollbackTransaction.

					ExceptionCompatibility pass: exception].

			self commitTransaction].

	
!

storeAll: aCollection

	"Public - Store a collection of objects.  They need not be the same class."



	| commitAfterSaving |

	duringTransaction

		ifTrue:

			[commitAfterSaving := false]

		ifFalse:

			[commitAfterSaving := true.

			self beginTransaction].

	aCollection

		do: [:each | self store: each].

	commitAfterSaving

		ifTrue: [self commitTransaction].

	
!

supportMultipleUsers

	"Public - "



	persistenceCreationMethod := #newMultiUserOn:
!

supportSingleUser

	"Public - "



	persistenceCreationMethod := #newSingleUserOn:
!

switchInObjectSets: anObject with: anotherObject

	"This method replaces the #become: I used to use."



	objectSets associationsDo: 

		[:each | 

		each value == anObject

			ifTrue: [objectSets at: each key put: anotherObject]

		].

	uniqueObjectSets copy do: 

		[:each |

		each == anObject ifTrue: 

			[uniqueObjectSets remove: anObject.

			uniqueObjectSets add: anotherObject]

		].
! !

!MinneStoreDB class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MinneStoreDB.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
