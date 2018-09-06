"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DOService subclass:#DOSingleObjectService
	instanceVariableNames:'fileName'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOSingleObjectService class methodsFor:'As yet unclassified'!

newMultiUserOn: fullFileName

    "Answer a new instance of myself with a multi user policy."



    ^self newMultiUser

	fullFileName: fullFileName;

	yourself.
!

newSingleUserOn: fullFileName

    "Answer a new instance of myself with a single user policy."



    ^self newSingleUser

	fullFileName: fullFileName;

	yourself.
!

read: fullFileName



    ^(self newSingleUserOn: fullFileName) read
! !

!DOSingleObjectService methodsFor:'As yet unclassified'!

delete: anObject

	"Public - Answer an instance of DODeletedObject.

	An object must be read before it can be deleted."



	| oldObjectWrapper array wrapper |

	anObject isDODeletedObject ifTrue: [^anObject].

	self protect: 

		[oldObjectWrapper := self privateReadForUpdate.

		(wrapper := DOWrapper noClone: anObject) compareVersionWith: oldObjectWrapper.

		array := wrapper asDeletedObjectArray.

		self userPolicy store: array to: self fullFileName.].

	^DODeletedObject fromArray: array.
!

fileName

	"Answer the name of the file."



	^fileName
!

fileName: aString

	"Set the fileName instance variable to aString."



	fileName := aString.
!

fullFileName

	"Answer the path name and file name as one string."



	^self pathName, self fileName
!

fullFileName: aString

	"Set the fileName instance variable to aString."



	| i |

	( i := aString lastIndexOf: FlavorCompatibility directoryDelimiter) == 0

		ifTrue: [self error: 'Invalid file name.  You must include the full path and drive.'].

	pathName := aString copyFrom: 1 to: i.

	fileName := aString copyFrom: i+1 to: aString size.

	fileName isEmpty ifTrue: [self error: 'You must include a file name with the path'].
!

isLocked

	"Public - Answer a boolean.  Answer true if locked by this service.

	If using the singleUserPolicy, true will always be answered."



	^userPolicy isLocked: self fullFileName
!

lock: anObject

	"Public - My object must already have been read in before using this method.

	Use #readForUpdate if you want to do both at the same time.

	If it has changed since reading, DOInvalidVersionError will be signaled.

	This should be the same object that was read from disk earlier."



	| oldObject |

	self isLocked ifTrue: [^self].

	oldObject := self privateReadForUpdate.

	ExceptionCompatibility

		on: #DOInvalidVersionError

		during: [(DOWrapper noClone: anObject) compareVersionWith: oldObject]

		do: [:excp | self unlock: anObject.

			ExceptionCompatibility pass: excp].

	^self
!

printOn: aStream

        

	super printOn: aStream.

	aStream 

		nextPut: $(;

		print: self fullFileName;

		nextPut: $).

!

privateReadForUpdate

	"Answer a DOWrapper or nil."



	| result |

	result := self userPolicy readForUpdate: self fullFileName.

	^DOWrapper fromArray: result.
!

privateStore: aDOWrapper

	"Private"



	userPolicy update: aDOWrapper to: self fullFileName.
!

read

	"Public"



	| array |

	array := self userPolicy readFileNamed: self fullFileName.

	array isNil ifTrue: [^nil].

	^(DOWrapper fromArray: array) object.
!

read: anObject

	"Answer a copy of the disk version of anObject"



	^self read
!

readAll

	"Public - Ask my user policy to read the object from disk."



	^self read.
!

readForUpdate

	"Public"



	| wrapper |

	^(wrapper := self privateReadForUpdate) isNil

		ifTrue: [nil]

		ifFalse: [wrapper object].
!

readId: anInteger

	"Signal an error."



	self error: 'The #readId: method is used with DOMultiObjectService only.'
!

unlock: anObject

	"To be used after reading an object for update or just locking it."



	self duringTransaction

		ifFalse: [userPolicy unlockFileNamed: self fullFileName].
! !

!DOSingleObjectService class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOSingleObjectService.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
