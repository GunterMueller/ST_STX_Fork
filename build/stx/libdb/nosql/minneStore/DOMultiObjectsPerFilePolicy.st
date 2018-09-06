"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DOObjectsPerFilePolicy subclass:#DOMultiObjectsPerFilePolicy
	instanceVariableNames:'objectsPerFile'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOMultiObjectsPerFilePolicy class methodsFor:'As yet unclassified'!

Comment

"

	The benefits with using this policy object are:



	1) Reduced disk space.

	2) Fewer files.

	3) Better throughput when reading objects in sequence.  



	The disadvantages of using this policy are:

	1) File level locking is used in a multi-user environment.

	This means more contention and chance for deadlock.

	2) It may be a little slower, but I haven't tested this.

"

!

new: anInteger

	"Create a new instance and set the objectsPerFile instance variable."



	^self new 

		objectsPerFile: anInteger;

		yourself.
! !

!DOMultiObjectsPerFilePolicy methodsFor:'As yet unclassified'!

delete: aWrapper



	| fileName fileContents wrapper array ix |

	fileName := self fullFileNameForId: aWrapper id.

	fileContents := self readForUpdate: fileName.

	ix := self indexForId: aWrapper id.



	wrapper := DOWrapper fromArray: (fileContents at: ix).

	aWrapper compareVersionWith: wrapper.

	array := wrapper asDeletedObjectArray.

	fileContents at: ix put: array.

	self userPolicy store: fileContents to: fileName.

	^DODeletedObject fromArray: array.
!

fileNumberForId: anInteger



	^((anInteger - 1) // objectsPerFile) + 1.
!

fullFileNameForId: anInteger

	"Answer the full file name for id of anInteger."



	| fileNumber |

	fileNumber := self fileNumberForId: anInteger.

	^self fullFileNameNumbered: fileNumber.
!

fullFileNameNumbered: anInteger

	"Answer the full file name for id of anInteger."



	| fileName |

	fileName := 

		FlavorCompatibility 

		replaceAll: '9999' 

		in: manager fileNamePattern 

		with: (anInteger asZeroFilledString: 4).

	^manager pathName, fileName.
!

indexForId: anInteger

	"Answer the remainder of the id divided by the number of objects per file."



	^((anInteger + -1) \\ objectsPerFile) + 1.
!

objectsPerFile: anInteger

	"Setter"



	objectsPerFile := anInteger.
!

readAll

	"Answer all the stored objects."



	| result anOC fileContents |

	anOC := OrderedCollection new.

	1 to: manager lastId

		do:

			[:id |

			(self indexForId: id) == 1

				ifTrue: [fileContents := self readFileNamed: (self fullFileNameForId: id)].

			result := fileContents at: (self indexForId: id).

			(result := DOWrapper fromArray: result) isDODeletedObject

				ifFalse: [anOC add: result].

			].

	^anOC
!

readFileNamed: fileName

	"Private - delegate to my userPolicy.  If nil is returned to me, answer an empty array."



	| fileContents |

	^(fileContents := self userPolicy readFileNamed: fileName) isNil

		ifTrue: [Array new: objectsPerFile]

		ifFalse: [fileContents].
!

readFileNumber: anInteger

	"Answer a collection of the objects in file number anInteger"



	| fileContents oc result |

	oc := OrderedCollection new.

	fileContents := self readFileNamed: (self fullFileNameNumbered: anInteger).

	^fileContents collect: [:each | (DOWrapper fromArray: each) object].
!

readForUpdate: fileName

	"Private - delegate to my userPolicy.  If nil is returned to me, answer an empty array."



	| fileContents |

	^(fileContents := self userPolicy readForUpdate: fileName) isNil

		ifTrue: [Array new: objectsPerFile]

		ifFalse: [fileContents].
!

readId: anInteger



	| result |

	result := (self readFileNamed: (self fullFileNameForId: anInteger))

						at: (self indexForId: anInteger).

	^DOWrapper fromArray: result.
!

readIdForUpdate: anInteger

	"Answer a DOWrapper"



	| result |

	result := (self readForUpdate: (self fullFileNameForId: anInteger))

				at: (self indexForId: anInteger).

	^DOWrapper fromArray: result.
!

store: aDOWrapper

	"Used by a MultiUserPolicy. Check the object version before storing"



	| id fileName fileContents |

	id := aDOWrapper id.

	aDOWrapper compareVersionWith: (self readIdForUpdate: id).

	fileName := self fullFileNameForId: id.

	fileContents := self readForUpdate: fileName.

	fileContents 

		at: (self indexForId: id) 

		put: aDOWrapper asArray.

	self userPolicy addRollbackBlock: aDOWrapper rollbackBlock.

	self userPolicy store: fileContents to: fileName.
! !

!DOMultiObjectsPerFilePolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOMultiObjectsPerFilePolicy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
