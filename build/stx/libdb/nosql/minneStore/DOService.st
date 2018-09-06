"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DiskObjectServices subclass:#DOService
	instanceVariableNames:'userPolicy pathName'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOService class methodsFor:'As yet unclassified'!

Comment

^'

The concrete subclasses of this abstract class are the interface

into the DiskObjectServices.



Many objects can be stored in a file, or just one.  If we have 

many to store, the DOMultiObjectService is used.  If only one, 

the DOSingleObjectService is used.



Note: In order to update or delete an object, it must be read first, then

used as a parameter into the store: or delete: method.



When reading a deleted object, an instance of DODeletedObject is returned.  

To replace a deleted object, you must read it then use #replace:with:



Objects cannot be deleted or updated without version checking.

In Other Words - You cannot store an old version of an object.



Global objects like Integers and Symbols may not be stored

by themselves because they are shared.  When you store one

of these classes, they must be wrapped in another object (an array

or any other object instance).

'
!

newMultiUser

    "Answer a new instance of myself with a multi user policy."



    ^self new

	userPolicy: (DOMultiUserPolicy new);

	yourself.
!

newSingleUser

    "Answer a new instance of myself with a single user policy."



    ^self new

	userPolicy: (DOSingleUserPolicy new);

	yourself.
!

openOn: fullFileName

    "Read myself in from fullFileName"



	FlavorCompatibility needsWork. "This method name is confusing given what it is really doing."

	^(DOSingleObjectService newSingleUserOn: fullFileName) read
! !

!DOService methodsFor:'As yet unclassified'!

beginTransaction

	"Use transactions carefully.  They should be very short periods of time for 

	multi-user because all read files will be locked until committed or rolled back.

	All read and stored objects will be saved in the cache until commit time."

        

	userPolicy beginTransaction.
!

commitTransaction

	"Abort any changes and unlock all files lock by this user."

        

	userPolicy commitTransaction.
!

duringTransaction

	"Answer true or false."



	^userPolicy duringTransaction
!

isDOService



	^true
!

isMultiUser



	^userPolicy isMultiUser
!

isSingleUser



	^userPolicy isSingleUser
!

pathName

	"Answer the path string to store objects in.  Default to the current path"



	pathName isNil

		ifTrue: [ pathName := '.', (FlavorCompatibility directoryDelimiterString) ].

	^pathName
!

pathName: aString

	"Set the pathName instance variable to aString."



	(pathName := aString) last = (FlavorCompatibility directoryDelimiter)

		ifFalse: [pathName := pathName, (FlavorCompatibility directoryDelimiterString)].
!

protect: aBlock

	"Private - Protect a block of code (probably a save command).  Rollback changes if an error occurs.

	If a transaction is already in progress, don't start a new one or commit the old one."

        

	| myTransaction result |

	myTransaction := false.

	userPolicy duringTransaction  "begin a transaction if not already begun."

	ifFalse: [

		myTransaction := true.

		userPolicy beginTransaction].

	ExceptionCompatibility

	on: #anyError

	during: [result := aBlock value]

	do: [ :error |

		userPolicy rollbackTransaction.

		ExceptionCompatibility pass: error].

	myTransaction

		ifTrue: [userPolicy commitTransaction].

	^result.
!

readAll

	"Answer all objects that I have stored."



	^self subclassResponsibility
!

replace: object1 with: object2

	"Public"



	FlavorCompatibility

		atPropertyNamed: #DOId

		for: object2

		put: (self idFor: object1).

	FlavorCompatibility

		atPropertyNamed: #DOVersion

		for: object2

		put: (self versionFor: object1).

	self store: object2.
!

rollbackTransaction

	"Abort any database changes and unlock all files lock by this user.

	The version of objects stored during this transaction also change back to their original version.

	Other changes to objects stored during the transaction are not rolled back."

        

	userPolicy rollbackTransaction.
!

specialStore: anObject

	"Public - Store anObject without making a clone.  

	Subsequent changes to the object will then be saved when committed."



	^self protect: [self privateStore: (DOWrapper noClone: anObject)].
!

store: anObject

	"Public - Store anObject.  If an error occurs, the changes will be rolled back."



	^self protect: [self privateStore: (DOWrapper on: anObject)].
!

storeYourselfOn: fullFileName

	"Store myself on fullFileName"



	(DOSingleObjectService newSingleUserOn: fullFileName) store: self.
!

userPolicy

	"Private - Getter"



	^userPolicy
!

userPolicy: aDOUserPolicy

	"Private - Set my userPolicy instance variable."



	userPolicy := aDOUserPolicy.
!

writeCacheType: aSymbol

	"aSymbol can be either #stream or #object.

	#stream means objects will be saved to a stream immediately during storing.

	#object means the objects themselves will be held in the write cache until commit time."



	userPolicy writeCacheType: aSymbol
! !

!DOService class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOService.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
