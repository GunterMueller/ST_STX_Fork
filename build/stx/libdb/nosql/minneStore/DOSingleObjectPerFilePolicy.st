"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DOObjectsPerFilePolicy subclass:#DOSingleObjectPerFilePolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOSingleObjectPerFilePolicy methodsFor:'As yet unclassified'!

delete: aWrapper



	| wrapper array |

	wrapper := self readIdForUpdate: aWrapper id.

	aWrapper compareVersionWith: wrapper.

	array := wrapper asDeletedObjectArray.

	self userPolicy store: array to: (self fullFileNameForId: aWrapper id).

	^DODeletedObject fromArray: array.
!

fileNumberForId: anInteger



	^anInteger
!

fullFileNameForId: anInteger

	"Answer the full file name for anObject."



	| fileName |

	fileName := 

		FlavorCompatibility

			replaceAll: '9999' 

			in: manager fileNamePattern 

			with: (anInteger asZeroFilledString: 4).

	^manager pathName, fileName.
!

readAll

	"Answer a collection of wrappers."



	| result oc |

	oc := OrderedCollection new.

	1 to: manager lastId do:

		[ :id | 

		result := self readId: id.

		result isDODeletedObject ifFalse: [oc add: result].

		].

	^oc.
!

readFileNumber: anInteger

	"Answer a collection."



	| result wrapper |

	wrapper := self readId: anInteger.

	result := wrapper isNil

		ifTrue: [nil]

		ifFalse: [wrapper object].

	^Array with: result.
!

readForUpdate: fileName

	"Delegate to my userPolicy."



	^self userPolicy readForUpdate: fileName
!

readId: anInteger



	| result |

	result := self userPolicy readFileNamed: (self fullFileNameForId: anInteger).

	^DOWrapper fromArray: result.
!

readIdForUpdate: anInteger



	| result |

	result := self userPolicy readForUpdate: (self fullFileNameForId: anInteger).

	^DOWrapper fromArray: result.
!

store: aDOWrapper

	"Check object version before storing."



	| id |

	id := aDOWrapper id.

	aDOWrapper compareVersionWith: (self readIdForUpdate: id).

	self userPolicy addRollbackBlock: aDOWrapper rollbackBlock.

	self userPolicy store: aDOWrapper asArray to: (self fullFileNameForId: id).
! !

!DOSingleObjectPerFilePolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOSingleObjectPerFilePolicy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
