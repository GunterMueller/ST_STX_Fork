"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DOService subclass:#DOMultiObjectService
	instanceVariableNames:'nextIdDOManager fileNamePattern objectsPerFilePolicy'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOMultiObjectService class methodsFor:'As yet unclassified'!

Comment

"

The strength of the DOMultiObjectService class is to store

multiple business objects.  As each object is stored it is

given a database id and a version number.

"
!

newMultiUserOn: pathName

    "Answer a new instance of myself with a multi user policy."



    ^self newMultiUser

	pathName: pathName;

	yourself.
!

newSingleUserOn: pathName

    "Answer a new instance of myself with a single user policy."



    ^self newSingleUser

	pathName: pathName;

	yourself.
! !

!DOMultiObjectService methodsFor:'As yet unclassified'!

assignIdTo: anObject

	"Answer the internal database id for this object or give it one if it has none."



	| id |

	FlavorCompatibility

		atPropertyNamed: #DOId

		for: anObject

		put: (id := self nextId).

	^id
!

delete: anObject

	"Public - Answer an instance of DODeletedObject"



	| id |

	(id := self idFor: anObject) isNil

		ifTrue: [self error: 'anObject must have a db id.'].

	anObject isDODeletedObject

		ifTrue: [^anObject].

	self protect: [^objectsPerFilePolicy delete: (DOWrapper noClone: anObject)].
!

fileNamePattern

	"Private - Get the pattern for the file names.  Default is 'File9999.obj'."



	fileNamePattern == nil

		ifTrue: [ fileNamePattern := 'File9999.obj' ].

	^fileNamePattern
!

fileNamePattern: aString

	"Set the pattern for the file names.  Default is 'File9999.obj'."



	fileNamePattern := aString.
!

fileNumberForId: anInteger



	^objectsPerFilePolicy fileNumberForId: anInteger
!

initialize

	"Default the objectsPerFile policy to 1."



	self objectsPerFile: 1
!

isLocked: anObject

	"Answer a boolean.  Answer true if locked by this service.

	If using the singleUserPolicy, true will always be answered."



	^objectsPerFilePolicy isLocked: anObject
!

lastId

	"Public - Answer the last id assigned or nil."



	| result |

	result := self nextIdDOManager read.

	^result isNil

		ifTrue: [nil]

		ifFalse: [result first].
!

lock: anObject

	"Lock this object.  If it has been changed since it was read, 

	signal DOInvalidVersionError."



	(objectsPerFilePolicy isLocked: anObject)

		ifTrue: [^self].

	objectsPerFilePolicy lock: anObject.
!

nextId

    "Private - Answer the next available id."



	| lastId nextId array |

	array := self nextIdDOManager readForUpdate.

	lastId := array isNil

		ifTrue: [lastId := 0]

		ifFalse: [lastId := array first].

	nextId := lastId + 1.

	nextIdDOManager store: (Array with: nextId).

	^nextId.
!

nextIdDOManager

	"Private - Get the next available id."



	nextIdDOManager isNil

		ifTrue:

			[nextIdDOManager := DOSingleObjectService new

				userPolicy: self userPolicy class new;

				fileName: 'nextId.obj';

				pathName: self pathName;

				yourself].

	^nextIdDOManager.
!

objectsPerFile: anInteger

	"Set the objects-per-file policy based on the value of anInteger."



	| policy |

	anInteger > 1

		ifTrue: [policy := DOMultiObjectsPerFilePolicy new: anInteger]

		ifFalse: [policy := DOSingleObjectPerFilePolicy new].

	objectsPerFilePolicy := policy.

	objectsPerFilePolicy manager: self.

	objectsPerFilePolicy userPolicy: userPolicy.
!

printOn: aStream

        

	super printOn: aStream.

	aStream 

		nextPut: $(;

		print: self pathName, self fileNamePattern;

		nextPut: $).
!

privateStore: aDOWrapper

	"Private - to be used only by my own methods."



	aDOWrapper id isNil 

		ifTrue: [aDOWrapper id: self nextId.

			aDOWrapper assignIdToOriginal.].

	objectsPerFilePolicy store: aDOWrapper.
!

read: anObject

	"Answer a copy of the disk version of anObject"



	| id result |

	(id := self idFor: anObject) isNil

		ifTrue: [self error: 'object must have a database id to read it'.].

	^self readId: id.
!

readAll

	"Answer all objects that I have stored."



	^objectsPerFilePolicy readAll collect: [:each | each object]
!

readFileNumber: anInteger

	"Answer the contents of file number anInteger"



	^objectsPerFilePolicy readFileNumber: anInteger.
!

readForUpdate: anObject

	"Answer the disk version of an object from the database"



	| id result |

	(id := self idFor: anObject) == nil

		ifTrue: [self error: 'object must have a database id to read it'.].

	^self readIdForUpdate: id.
!

readId: anInteger

	"Answer one object read from disk or nil if none was found."



	| wrapper |

	wrapper := objectsPerFilePolicy readId: anInteger.

	^wrapper isNil 

		ifTrue: [nil]

		ifFalse: [wrapper object].
!

readIdForUpdate: anInteger

	"Answer one object read from disk or nil if none was found."



	| wrapper |

	self protect: 

		[wrapper := objectsPerFilePolicy readIdForUpdate: anInteger.

		^wrapper isNil 

			ifTrue: [nil]

			ifFalse: [wrapper object].

		].
!

storeAll: aCollection

	"Store a collection of objects.  If an error occurs, the changes will be rolled back."



	self protect: [aCollection do: [:each | self privateStore: each]].
!

unlock: anObject



	self duringTransaction

		ifFalse: [objectsPerFilePolicy unlock: anObject].
! !

!DOMultiObjectService class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOMultiObjectService.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
