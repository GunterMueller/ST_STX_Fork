"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSObjectSet
	instanceVariableNames:'name path indexes aspects myPersistence objectPersistence
		database cache persistenceCreationMethod hasChangedMethod
		afterStoringMethod beforeStoringMethod afterReadingMethod
		returnBlock andOr result recursion maximumLeavesPerBranch
		forceIndexUpdate unused2 unused3 unused4'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSObjectSet class methodsFor:'As yet unclassified'!

Comments

"

This class represents the interface for storing/retrieving an Object into/from

a set of like objects.  Like objects are distinguished by their class or their

class group.  Like objects must have the same index interface (IOW, have 

the same index value getter methods).

"
!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

XopenOn: pathName

	"Public - Load an instance of myself from pathName.

	This method to be deleted when I'm sure I won't need it."



	| fullFileName dbm path tempPersistence |

	path := (pathName last = FlavorCompatibility directoryDelimiter

		ifTrue: [pathName]

		ifFalse: [pathName , FlavorCompatibility directoryDelimiterString]).

	tempPersistence := (DOService openOn: path , self myPersistenceFileName).

	dbm := tempPersistence read.

	FlavorCompatibility needsWork. self error: 'needs work below'.

	dbm isNil

		ifTrue: [self error"FileError signal"].

	dbm myPersistence: tempPersistence.

	^dbm.
!

defaultMaximumLeavesPerBranch

	"Used by the indexes unless overridden.  Must be an even number.

	When branch file has this many leaves, it splits itself into two branches."



	^20.
!

fileName

    "Private - Answer a string with the file name where I am stored."



    ^'MSObjSet.obj'
!

myPersistenceFileName

	"Private - Answer the file name for my persistence 'manager' ."



	^'DOPrstnc.obj'
!

new

    "Do not use this method.  Use #newOn:  "



    self error: 'Do not use #new.  Use #newOn: pathName'
!

newOn: aString

	"Public - Instantiate myself and set path to aString."



	self initializePath: aString.

	^self basicNew

		path: aString;

		initialize;

		yourself.
!

newOn: aString for: aMinneStoreDB

	"Public - Instantiate myself and set path to aString."



	self initializePath: aString.

	^self basicNew

		database: aMinneStoreDB;

		path: aString;

		initialize;

		yourself.
! !

!MSObjectSet methodsFor:'As yet unclassified'!

afterReading: anObject

	"Private - If the afterReadingMethod selector is not nil, send it to anObject."

        

	afterReadingMethod == nil

		ifFalse: [anObject perform: afterReadingMethod].
!

afterReadingMethod: aSymbol

	"Public - This method selector (aSymbol) is sent to an object 

	after it has been read from the database."



	afterReadingMethod := aSymbol
!

afterStoring: anObject

	"Private - If the afterStoringMethod selector is not nil, send it to anObject."



	afterStoringMethod == nil

		ifFalse: [anObject perform: afterStoringMethod].
!

afterStoringMethod: aSymbol

	"Public - This method selector (aSymbol) is sent to an object

	after it has been stored to the database (but before the commit)."



	afterStoringMethod := aSymbol
!

and

    "Public - use this method between #where... methods"



    andOr := #and
!

and: indexName between: anObject1 and: anObject2

    "Public - Specifying a search criteria"



    ^self and;

	selectFor: indexName

	selector: #between:and:

	criteria: (Array with: anObject1 with: anObject2)
!

and: indexName eq: anObject

    "Public - Specifying a search criteria where index value is equal to anObject."



    ^self and;

	selectFor: indexName

	selector: #equals:

	criteria: anObject
!

and: indexName ge: anObject

    "Public - Specifying a search criteria where index value is greater than or equal to anObject."



    ^self and;

	selectFor: indexName

	selector: #greaterThanOrEqualTo:

	criteria: anObject
!

and: indexName gt: anObject

    "Public - Specifying a search criteria where index value is greater than anObject."



    ^self and;

	selectFor: indexName

	selector: #greaterThan:

	criteria: anObject
!

and: indexName gte: anObject

    "Public - Specifying a search criteria where index value is greater than or equal to anObject."



    ^self and;

	selectFor: indexName

	selector: #greaterThanOrEqualTo:

	criteria: anObject
!

and: indexName hasAllWords: aCollectionOfStrings

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self and;

	selectFor: indexName

	selector: #hasAllWords:

	criteria: aCollectionOfStrings
!

and: indexName hasSomeWords: aCollectionOfStrings

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self and;

	selectFor: indexName

	selector: #hasSomeWords:

	criteria: aCollectionOfStrings
!

and: indexName hasWord: aString

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self and;

	selectFor: indexName

	selector: #startsWith:

	criteria: aString asLowercase
!

and: indexName includes: aString

    "Public - Specifying a search criteria.  Use only when the key is a string."



    ^self and;

	selectFor: indexName

	selector: #includes:

	criteria: aString
!

and: indexName le: anObject

    "Public - Specifying a search criteria where index value is less than or equal to anObject."



    ^self and;

	selectFor: indexName

	selector: #lessThanOrEqualTo:

	criteria: anObject
!

and: indexName lt: anObject

    "Public - Specifying a search criteria where index value is less than anObject."



    ^self and;

	selectFor: indexName

	selector: #lessThan:

	criteria: anObject
!

and: indexName lte: anObject

    "Public - Specifying a search criteria where index value is less than or equal to anObject."



    ^self and;

	selectFor: indexName

	selector: #lessThanOrEqualTo:

	criteria: anObject
!

and: indexName ne: anObject

    "Public - Specifying a search criteria where index value is not equal to anObject."



    ^self and;

	selectFor: indexName

	selector: #doesNotEqual:

	criteria: anObject
!

aspect: aspectName

getter: getterName

setter: setterName

holdsMany: objectSetName



	aspects

		at: aspectName

		put:

			(MSMultiObjectAspect

				newName: aspectName

				getter: getterName

				setter: setterName

				objectSetName: objectSetName).
!

aspect: aspectName

getter: getterName

setter: setterName

holdsOne: objectSetName



	aspects

		at: aspectName

		put:

			(MSSingleObjectAspect

				newName: aspectName

				getter: getterName

				setter: setterName

				objectSetName: objectSetName).
!

aspect: aspectName

holdsMany: objectSetName



	self

		aspect: aspectName

		getter: aspectName

		setter: (aspectName, ':') asSymbol

		holdsMany: objectSetName
!

aspect: aspectName

holdsOne: objectSetName



	self

		aspect: aspectName

		getter: aspectName

		setter: (aspectName, ':') asSymbol

		holdsOne: objectSetName
!

aspectNamed: aSymbol



	^self 

		aspectNamed: aSymbol 

		ifAbsent:[self error: 'This aspect has not been defined: ', aSymbol].
!

aspectNamed: aSymbol ifAbsent: aBlock

	"Answer a MSAspect."



	^aspects 

		at: aSymbol

		ifAbsent: aBlock.
!

aspects



	^aspects
!

beforeStoring: anObject

	"Private - If the beforeStoringMethod selector is not nil, send it to anObject."

        

	beforeStoringMethod == nil

		ifFalse: [anObject perform: beforeStoringMethod].
!

beforeStoringMethod: aSymbol

	"Public - This method selector (aSymbol) is sent to an object before it has been stored."



	beforeStoringMethod := aSymbol
!

beginTransaction



	objectPersistence beginTransaction.

	indexes do: [:each | each beginTransaction].

	
!

cache

	"Answer the instance identity cache for this ObjectSet."



	cache == nil

		ifTrue: [cache := FlavorCompatibility aNewWeakDictionary].

	^cache
!

commitTransaction



	objectPersistence commitTransaction.

	indexes do: [:each | each commitTransaction].
!

database: aMinneStoreDB

	"Private"



	database := aMinneStoreDB
!

dbIdFor: anObject

	"Answer the database id for anObject.  Answer nil if it has none."



	^objectPersistence idFor: anObject.
!

delete: anObject

	"Private - Store anObject to disk, and update the indexes.

	If anObject is deemed unchanged, it won't be stored."



	| id deletedObject |

	(id := self dbIdFor: anObject) isNil

		ifTrue: [self error: 'Trying to delete an object without a db id'.].

	self validateObject: anObject.

	self removeIndexValuesFor: anObject.

	deletedObject := objectPersistence delete: anObject.

	^self cache

		at: (self dbIdFor: anObject)

		put: deletedObject.
!

execute

    "Public - Execute the query that started with get..."



	| answer |

	returnBlock == nil

		ifTrue: [self error: '#getAll: or #getOne: must be used before #execute.'].

	answer := returnBlock value.

	returnBlock := nil.

	^answer.
!

fileName

	"Private - Answer the file name where I am stored.  Get it from my class method."



	^self class fileName

	
!

forAllDo: aSingleArgumentBlock

    "Private - execute a block for each object I manage."



	| lastId lastFileId thisFileId collection |

	lastId := objectPersistence lastId.

	lastFileId := 0.

	1 to: lastId do:

		[:i |

		(thisFileId := objectPersistence fileNumberForId: i) > lastFileId

			ifTrue: 

				[lastFileId := thisFileId.

				collection := objectPersistence readFileNumber: thisFileId.

				collection do: 

					[:each | 

					each isDODeletedObject 

						ifFalse: [aSingleArgumentBlock value: each]]].

		].
!

forceIndexUpdate

	"Private - Used when adding a new index to already stored objects."



	forceIndexUpdate := true.

	
!

getAll

    "Private - set the returnBlock instance variable"



	returnBlock := [self returnAll].
!

getCount

    "Private - set the returnBlock instance variable"



	returnBlock := [self returnCount].
!

getIds

    "Private - set the returnBlock instance variable"



	returnBlock := [self returnIds].
!

getOne

    "Private - set the returnBlock instance variable"



	returnBlock := [self returnOne].
!

getValuesOf: indexName



	self indexNamed: indexName.  "Make sure it exists"

	returnBlock := [self returnValuesOf: indexName].
!

hasChanged: anObject

	"Private - Answer true or false.  True if anObject has changed since reading 

	or hasn't been saved to the database yet.  

	If no method selector was specified then assume true."



	hasChangedMethod == nil

		ifTrue: [^true].

	(self dbIdFor: anObject) == nil

		ifTrue: [^true]. "It has never been saved yet."

	^anObject perform: hasChangedMethod.
!

hasChangedMethod: aSymbol

	"Public - This method selector is used to find out if an object to be stored has changed or not.

	If it hasn't changed, we won't store it."



	hasChangedMethod := aSymbol
!

idFor: anObject

	"Private - Answer the database id for anObject."

self error: 'didnt know this was being used.'.

	^objectPersistence idFor: anObject.
!

indexNamed: aSymbol

	"Private - Answer the index with name of aSymbol"



	^indexes at: aSymbol ifAbsent: [self error: 'There is no index named ' , aSymbol]
!

indexOn: indexSymbol domain: aClass

	"Public - create an index named indexSymbol for domain of aClass.

	Assume the getter is the same as the index name."



	self 

		newIndexNamed: indexSymbol

		getter: indexSymbol

		domain: aClass
!

indexOn: indexSymbol domain: aClass getter: getterMethodSymbol

	"Public - create an index named indexSymbol for domain of aClass."



	self 

		newIndexNamed: indexSymbol

		getter: getterMethodSymbol

		domain: aClass
!

indexPathFor: aSymbol

	"Answer  aString."



	^path , (FlavorCompatibility fileNameLike: aSymbol)
!

initialize

    "Private"



	indexes := IdentityDictionary new.

	aspects := IdentityDictionary new.

	myPersistence := DOSingleObjectService perform: self persistenceCreationMethod with: path, self fileName.

	myPersistence storeYourselfOn: path, self myPersistenceFileName.

	objectPersistence := DOMultiObjectService perform: self persistenceCreationMethod with: path.

	objectPersistence objectsPerFile: 5.

	self maximumLeavesPerBranch: self class defaultMaximumLeavesPerBranch.
!

isMSObjectSet

	"Answer true"



	^true
!

maximumLeavesPerBranch



	^maximumLeavesPerBranch
!

maximumLeavesPerBranch: anInteger

	"Use this method before any indexes have been defined."



	maximumLeavesPerBranch := anInteger.

	indexes do: [:each | each maximumLeavesPerBranch: anInteger].

	
!

myPersistence

	"Answer an MSDiskObjectManager."



	^myPersistence

	
!

myPersistence: aDOManager

	"Set the myPersistence instance variable to a disk object manager."



	myPersistence := aDOManager

	
!

myPersistenceFileName

	"Private - Answer the file name for my persistence 'manager'.  Get it from my class method."



	^self class myPersistenceFileName

	
!

name



	^name
!

name: aSymbol



	name := aSymbol
!

newIndexNamed: indexName

getter: getterMethodName

domain: aClass

	"Private - Create a new index with name of indexName.

    Application -- Watch for the error MSInvalidDomainError.  This

    occurs when the domain class does not respond to #lowValue"



	| holder holderPathName |

	(FlavorCompatibility isSymbol: indexName)

		ifFalse: [self error: 'Index name must be a symbol'].

	(FlavorCompatibility isSymbol: getterMethodName)

		ifFalse: [self error: 'Getter method name must be a symbol'].

	holderPathName := self indexPathFor: indexName.

	indexes do: 

		[:each |

		each path = holderPathName

			ifTrue:[self error: 'Your index name is too similar to ', each name]

		].

	holder := MSTreeHolder newOn: holderPathName owner: self.

	holder name: indexName.

	holder getter: getterMethodName.

	holder domain: aClass.

	indexes at: indexName put: holder.

	self save.

	objectPersistence lastId isNil 

		ifFalse: [self updateIndexes].
!

newPath: aString

	"Used when a database has been opened in a new directory."



	self path: aString.

	objectPersistence pathName: path.

	indexes do: 

		[:each |

		each newPath: (self indexPathFor: each name)].

	
!

objectsPerFile: anInteger

	"Public - Set the number of objects to be stored in each file.

	This method may only be used during db initialization."



	objectPersistence objectsPerFile: anInteger.
!

or

    "Public - use this method between #where... methods"



    andOr := #or
!

or: indexName between: anObject1 and: anObject2

    "Public - Specifying a search criteria"



    ^self or;

	selectFor: indexName

	selector: #between:and:

	criteria: (Array with: anObject1 with: anObject2)
!

or: indexName eq: anObject

    "Public - Specifying a search criteria where index value is equal to anObject."



    ^self or;

	selectFor: indexName

	selector: #equals:

	criteria: anObject
!

or: indexName gt: anObject

    "Public - Specifying a search criteria where index value is greater than anObject."



    ^self or;

	selectFor: indexName

	selector: #greaterThan:

	criteria: anObject
!

or: indexName gte: anObject

    "Public - Specifying a search criteria where index value is greater than or equal to anObject."



    ^self or;

	selectFor: indexName

	selector: #greaterThanOrEqualTo:

	criteria: anObject
!

or: indexName hasAllWords: aCollectionOfStrings

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self or;

	selectFor: indexName

	selector: #hasAllWords:

	criteria: aCollectionOfStrings
!

or: indexName hasSomeWords: aCollectionOfStrings

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self or;

	selectFor: indexName

	selector: #hasSomeWords:

	criteria: aCollectionOfStrings
!

or: indexName hasWord: aString

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self or;

	selectFor: indexName

	selector: #startsWith:

	criteria: aString asLowercase
!

or: indexName includes: aString

    "Public - Specifying a search criteria.  Use only when the key is a string."



    ^self or;

	selectFor: indexName

	selector: #includes:

	criteria: aString
!

or: indexName le: anObject

    "Public - Specifying a search criteria where index value is less than or equal to anObject."



    ^self or;

	selectFor: indexName

	selector: #lessThanOrEqualTo:

	criteria: anObject
!

or: indexName lt: anObject

    "Public - Specifying a search criteria where index value is less than anObject."



    ^self or;

	selectFor: indexName

	selector: #lessThan:

	criteria: anObject
!

or: indexName lte: anObject

    "Public - Specifying a search criteria where index value is less than or equal to anObject."



    ^self or;

	selectFor: indexName

	selector: #lessThanOrEqualTo:

	criteria: anObject
!

or: indexName ne: anObject

    "Public - Specifying a search criteria where index value is not equal to anObject."



    ^self or;

	selectFor: indexName

	selector: #doesNotEqual:

	criteria: anObject
!

or: indexName startsWith: aString

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self or;

	selectFor: indexName

	selector: #startsWith:

	criteria: aString
!

path



	^path
!

path: aString

	"Set the path instance variable."



	path := (aString last = FlavorCompatibility directoryDelimiter)

		ifTrue: [aString]

		ifFalse: [aString , FlavorCompatibility directoryDelimiterString].

	
!

persistenceCreationMethod



	persistenceCreationMethod == nil

		ifTrue: [persistenceCreationMethod := database persistenceCreationMethod].

	^persistenceCreationMethod.
!

printOn: aStream



	super printOn: aStream.

	aStream 

		nextPut: $(;

		nextPutAll: name;

		nextPut: $).
!

privateStore: anObject

	"Private - Store anObject to disk, and update the indexes.

	If anObject is deemed unchanged, it won't be stored."



	| id |

	self validateObject: anObject.

	(self hasChanged: anObject)

		ifTrue: 

			[self beforeStoring: anObject.

			self updateIndexesFor: anObject.

			self setStorageProxiesFor: anObject.

			objectPersistence store: anObject.

			self setReadProxiesFor: anObject.

			self afterStoring: anObject.]

		ifFalse: [self setStorageProxiesFor: anObject].

	^self cache

		at: (self dbIdFor: anObject)

		put: anObject.
!

readAll

	"Public - Answer all of the object in this object set.

    Answer is nil if the object does not exist."



	| all |

	all := objectPersistence readAll.

	^all 

		collect:

			[:each |

			self cache

				at: (self dbIdFor: each)

				ifAbsentPut:

					[self setReadProxiesFor: each.

					self afterReading: each.                                        

					each].

			]
!

readForId: anInteger

	"Public - Answer the object in this object set with an id of anInteger.

    Answer is nil if the object does not exist."



	| object | 

	^self cache

		at: anInteger

		ifAbsent:

			[(object := objectPersistence readId: anInteger) == nil

				ifTrue: "don't save nil in the cache"

					[nil]

				ifFalse:

					[self setReadProxiesFor: object.

					self afterReading: object.                                      

					cache at: anInteger put: object].

			].
!

readForIds: aCollection

	"Public - Answer the object in this object set with an id of anInteger.

    Answer is nil if the object does not exist."



	^aCollection collect: [:each | self readForId: each].
!

removeFromCache: anObject

	"Public - Remove this object from the object identity cache."



	^self cache 

		removeKey: (self dbIdFor: anObject) 

		ifAbsent: [nil]
!

removeIndexValuesFor: anObject

	"Private - "



	| key oldKey oldObject id |

	oldObject := objectPersistence read: anObject.

	id := self dbIdFor: anObject.

	indexes do:

		[:each |

		ExceptionCompatibility

		on: #MessageNotUnderstood

		during: [oldKey := oldObject perform: each getter]

		do:     [ :exception |  "we are probably indexing with info from an aspect."

			"exception message receiver isMSStorageProxy    -- VSE"

			FlavorCompatibility issue. "The below code works in Dolphin only."

			exception receiver isMSStorageProxy "-- Dolphin"

				ifTrue: [self error: 'You have taken an index value from an aspect. ObjectSet: ', name, ' Index: ', each name]

			].

		each removeValue: oldKey id: id.

		].
!

returnAll

        "Private - Answer a collection of objects that match the criteria"



        | answer |

        ExceptionCompatibility

                during:

                        [result isNil ifTrue: [answer := self readAll.]
                                      ifFalse:[answer := result collect: [:each | self readForId: each]]]

                ensure:

                        [result := nil.

                        andOr := nil].

        ^answer.
!

returnCount

	"Private - Answer the number of stored objects whose indexes

	match the previously specified criteria."



	^self returnIds size
!

returnIds

    "Answer a collection of ids whose objects match the previously specified criteria."



    | answer |

    answer := result.

    result := nil.

    andOr := nil.

    ^answer.
!

returnOne

	"Private - Answer the first object that matches or nil."



	| answer |

	ExceptionCompatibility

		during:

			[result isNil ifTrue: [^nil].

			result isEmpty ifTrue: [^result := nil].

			answer := self readForId: result first]

		ensure:

			[result := nil.

			andOr := nil].

	^answer.
!

returnValuesOf: indexName

	"Private - Answer a collection of index values for the objects that match the criteria"



	| answer |

	ExceptionCompatibility

		during:

			[answer := 

				result isNil 

				   ifTrue: [(self indexNamed: indexName) allValues]

				   ifFalse: [(self indexNamed: indexName) allValuesFor: result].

			]

		ensure:

			[result := nil.

			andOr := nil].

	^answer.
!

rollbackTransaction



	objectPersistence rollbackTransaction.

	indexes

		do:

			[:each |

			each rollbackTransaction].

	
!

save

	"Private - Clean things up and Save myself to disk."



	| temp1 temp2 temp3 temp4 |

	indexes do: [:each | each beforeStoring].

	temp1 := myPersistence.

	temp2 := database.

	temp3 := cache.

	myPersistence := nil.

	database := nil.

	cache := nil.

	ExceptionCompatibility

		during: [temp1 store: self]

		ensure:

			[myPersistence := temp1.

			database := temp2.

			cache := temp3].
!

selectFor: indexName selector: aSelector criteria: anObject

	"Private - Send aSelector with anObject to index named indexName.

	Based on the andOr variable, union or intersect the results.

	This method is used by #where:equals , #where:startsWith:, etc...

	result variable will be nil the first time this is called."



	| anOC |

	(result notNil and: [andOr = nil])

		ifTrue:

			[result := nil.

			andOr := nil.

			self error: 'Use the #and or #or method between #where:.. methods'].

	(result isCollectionOtherThanString and: [result isEmpty and: [andOr = #and]])

		ifTrue:

			[ "This is for efficiency.  No reason to go on."

			andOr := nil.

			^result].

	ExceptionCompatibility

	on: #anyError

	during: [ " Start of the #on:do: block "

		(anObject isCollectionOtherThanString and: [#(equals: hasAllWords: hasSomeWords:) doesNotInclude: aSelector])

			ifTrue: [anOC := (self indexNamed: indexName) perform: aSelector withArguments: anObject]

			ifFalse: [anOC := (self indexNamed: indexName) perform: aSelector with: anObject].

		]

	do:     [:excp |

		result := nil.

		andOr := nil.

		ExceptionCompatibility pass: excp].

	result isNil

		ifTrue:

			[andOr := nil.

			^result := anOC].

	(andOr = #and)

		ifTrue:

			[andOr := nil.

			anOC isEmpty

				ifTrue: [^result := OrderedCollection new].

			^result := anOC intersectionOf: result.].

	(andOr = #or)

		ifTrue:

			[andOr := nil.

			anOC isEmpty

				ifTrue: [^result].

			^result := result uniqueUnionOf: anOC].

FlavorCompatibility testing. self error: 'Oops, I didn''t think it could get this far'.

"       result := nil.

	andOr := nil.

	self error: 'Use the #and or #or method between #where:.. methods'.

"

	
!

setReadProxiesFor: anObject

	"Private - Replace anObjects related objects (aspects) with proxy objects.

	If an aspect is 'dependent', then it should not be an aspect, but should be stored with the object."



	| temp |

	self aspects

		do: [:eachAspect |

			temp := database objectSetNamed: eachAspect objectSetName.

			eachAspect setReadProxyFor: anObject with: temp].
!

setStorageProxiesFor: anObject

	"Private - Replace anObjects related objects (aspects) with proxy objects.

	If an aspect is 'dependent', then it should not be an aspect, but should be stored with the object.

	In the process of setting the aspect proxies, the aspects get stored as well."



	| temp |

	self aspects

		do: [:eachAspect |

			temp := database objectSetNamed: eachAspect objectSetName. 

			eachAspect setStorageProxyFor: anObject with: temp].
!

store: anObject

	"Public - Check for recursive stores of the same object before storing it to disk"



	recursion == nil

		ifTrue:

			[recursion := Set new.

			recursion add: anObject.

			self privateStore: anObject.

			recursion := nil]

		ifFalse:

			[(recursion includes: anObject)

				ifTrue: [^anObject].

			recursion add: anObject.

			self privateStore: anObject]
!

storeAll: aCollection

	"Public - store a collection of object to disk."



	aCollection

		do: [:each | self store: each].

	
!

storesClass: aClass

	"Public - Definition protocol"



	database objectSetsAt: aClass put: self.
!

storesClasses: aCollection

	"Public - Definition protocol"



	aCollection do: [ :each |

		database objectSetsAt: each put: self].
!

unforceIndexUpdate

	"Private - Used when adding a new index to already stored objects."



	forceIndexUpdate := false.

	
!

updateIndexes

	"Private - used by #newIndexNamed:getter:domain: when an index has been 

	added when there is already data in the database."



	| tempHasChangedMethod |

	database beginTransaction.

	tempHasChangedMethod := hasChangedMethod.

	ExceptionCompatibility

		during:

			[hasChangedMethod := nil.

			self forceIndexUpdate.

			self forAllDo: [:each | database store: each]]

		ensure: 

			[hasChangedMethod := tempHasChangedMethod.

			self unforceIndexUpdate].

	"If any untrapped error occurs during the storing, the changes will be automatically rolled back."

	database commitTransaction.
!

updateIndexesFor: anObject

	"Private - "



	| key oldKey oldObject id |

	(id := self dbIdFor: anObject) isNil

		ifTrue: [id := objectPersistence assignIdTo: anObject]

		ifFalse: [oldObject := objectPersistence read: anObject].

	indexes do:

		[:each |

		key := anObject perform: each getter.

		oldObject isNil

			ifTrue: [each addValue: key id: id]

			ifFalse:

				[ExceptionCompatibility

					on: #MessageNotUnderstood

					during: [oldKey := oldObject perform: each getter]

					do:     [ :exception |  "we are probably indexing with info from an aspect."

						(FlavorCompatibility exceptionReceiver: exception) isMSStorageProxy

							ifTrue: [self error: 'You have taken an index value from an aspect. ObjectSet: ', name, ' Index: ', each name]

						].

				(oldKey ~= key or: [forceIndexUpdate == true]) ifTrue: 

					[each removeValue: oldKey id: id.

					each addValue: key id: id.].

				].

		].
!

validateObject: anObject

    "Private - Validate anObject for the proper index protocol before storing it."



    indexes do: [ :each |

	(anObject respondsTo: each getter)

	    ifFalse: [ self error: 'Object does not respond to: ', each getter ] ].    
!

where: indexName between: anObject1 and: anObject2

    "Public - Specifying a search criteria"



    ^self

	selectFor: indexName

	selector: #between:and:

	criteria: (Array with: anObject1 with: anObject2)
!

where: indexName eq: anObject

    "Public - Specifying a search criteria. Equivalent to #where:equals:"



    ^self

	selectFor: indexName

	selector: #equals:

	criteria: anObject
!

where: indexName ge: anObject

    "Public - Specifying a search criteria Equivalent to #where:isGreaterThanOrEqualTo:"



    ^self

	selectFor: indexName

	selector: #greaterThanOrEqualTo:

	criteria: anObject
!

where: indexName gt: anObject

    "Public - Specifying a search criteria. Equivalent to #where:isGreaterThan:"



    ^self

	selectFor: indexName

	selector: #greaterThan:

	criteria: anObject
!

where: indexName gte: anObject

    "Public - Specifying a search criteria Equivalent to #where:isGreaterThanOrEqualTo:"



    ^self

	selectFor: indexName

	selector: #greaterThanOrEqualTo:

	criteria: anObject
!

where: indexName hasAllWords: aCollectionOfStrings

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self

	selectFor: indexName

	selector: #hasAllWords:

	criteria: aCollectionOfStrings
!

where: indexName hasSomeWords: aCollectionOfStrings

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self

	selectFor: indexName

	selector: #hasSomeWords:

	criteria: aCollectionOfStrings
!

where: indexName hasWord: aString

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self

	selectFor: indexName

	selector: #startsWith:

	criteria: aString asLowercase
!

where: indexName includes: aString

    "Public - Specifying a search criteria.  Use only when the key is a string."



    ^self

	selectFor: indexName

	selector: #includes:

	criteria: aString
!

where: indexName le: anObject

    "Public - Specifying a search criteria. Equivalent to #where:isLessThanOrEqualTo:"



    ^self

	selectFor: indexName

	selector: #lessThanOrEqualTo:

	criteria: anObject
!

where: indexName lt: anObject

    "Public - Specifying a search criteria. Equivalent to #where:isLessThan:"



    ^self

	selectFor: indexName

	selector: #lessThan:

	criteria: anObject
!

where: indexName lte: anObject

    "Public - Specifying a search criteria. Equivalent to #where:isLessThanOrEqualTo:"



    ^self

	selectFor: indexName

	selector: #lessThanOrEqualTo:

	criteria: anObject
!

where: indexName ne: anObject

    "Public - Specifying a search criteria where index value is not equal to anObject."



    ^self

	selectFor: indexName

	selector: #doesNotEqual:

	criteria: anObject
!

where: indexName startsWith: aString

    "Public - pecifying a search criteria.  Use only when the key is a string."



    ^self

	selectFor: indexName

	selector: #startsWith:

	criteria: aString
! !

!MSObjectSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSObjectSet.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
