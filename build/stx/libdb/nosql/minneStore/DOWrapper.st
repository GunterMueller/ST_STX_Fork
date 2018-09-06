"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DiskObjectServices subclass:#DOWrapper
	instanceVariableNames:'originalObject object version id'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOWrapper class methodsFor:'As yet unclassified'!

fromArray: anArray

	"This instance wraps an object on it's way out of the database"



	anArray isNil

		ifTrue: [^nil].

	anArray first == #deleted

		ifTrue: [^DODeletedObject fromArray: anArray].

	^self new 

		object: (anArray at: 1);

		id: (anArray at: 2);

		version: (anArray at: 3).
!

noClone: anObject

	"This method is just like #on: but doesn't create a deep copy (clone) of the object."



	^self new setObject: anObject original: anObject
!

on: anObject

	"This class wraps an object on it's way into the database.

	A very deep copy of the object is made so changes can occur before committing."



	^self new setObject: (FlavorCompatibility clone: anObject) original: anObject
! !

!DOWrapper methodsFor:'As yet unclassified'!

asArray

	"An array is really what wraps this object when it is stored"



	self incrementVersion.

	^Array with: object with: id with: self newVersion.

	
!

asDeletedObjectArray

	"An array is really what wraps this object when it is stored"



	^Array with: #deleted with: id with: self newVersion.

	
!

assignId



	FlavorCompatibility assert: (object isNil not). FlavorCompatibility testing.

	FlavorCompatibility atPropertyNamed: #DOId for: object put: id.
!

assignIdToOriginal



	FlavorCompatibility atPropertyNamed: #DOId for: originalObject put: id.
!

assignVersion



	FlavorCompatibility atPropertyNamed: #DOVersion for: object put: version
!

compareVersionWith: anObject

	"Compare my objects version to the disk version of anObject.

	If my object has never been in the database, don't compare versions.

	Assume the object ids are the same."

        

	self isNew

		ifTrue: [^self].

	version == anObject version

		ifFalse: [self signalInvalidVersionError: anObject].
!

decrementVersion

	"rollback the version of the original object"



	originalObject isNil ifTrue: [self error: 'is this really an error?'].  FlavorCompatibility testing.

	FlavorCompatibility atPropertyNamed: #DOVersion for: originalObject put: version.
!

id



	^id
!

id: anInteger



	id := anInteger
!

incrementVersion

	"Private - increment the version on the original object"



	originalObject isNil ifTrue: [self error: 'is this really an error?'].  FlavorCompatibility testing.

	FlavorCompatibility atPropertyNamed: #DOVersion for: originalObject put: self newVersion.
!

isNew



	^version == 0
!

newVersion



	^version + 1

!

object



	object isNil ifFalse: 

		[self assignId; 

			assignVersion].

	^object
!

object: anObject



	object := anObject.
!

originalObject: anObject



	originalObject := anObject.
!

rollbackBlock



	^[self decrementVersion.]
!

setObject: anObject original: original



	self

		object: anObject;

		originalObject: original;

		id: (self idFor: original);

		version: (self versionFor: original)
!

version



	^version
!

version: anInteger



	version := 

		anInteger isNil

			ifTrue: [0]

			ifFalse: [anInteger].

! !

!DOWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOWrapper.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
