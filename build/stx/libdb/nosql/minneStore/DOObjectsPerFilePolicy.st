"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DiskObjectServices subclass:#DOObjectsPerFilePolicy
	instanceVariableNames:'userPolicy manager'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOObjectsPerFilePolicy class methodsFor:'As yet unclassified'!

Comment

"

	These classes handle the number of objects stored in each file.

	The manager and user policy logic is thereby insulated from any of this knowledge.

"
! !

!DOObjectsPerFilePolicy methodsFor:'As yet unclassified'!

fullFileNameFor: anObject

	"Answer the full file name for anObject."



	^self fullFileNameForId: (self idFor: anObject)
!

isLocked: anObject

	"Answer a boolean"



	^userPolicy isLocked: (self fullFileNameFor: anObject)
!

lock: anObject



	self error: 'Not yet implemented.'.

	FlavorCompatibility issue.

	"Because there are multiple objects in each file, and to lock an object

	means locking its file, unlocking will take some thought.

	Lock/Unlock capability is not needed by MinneStore, so I'm leaving this for now."

	
!

manager: aDOManager

	"Setter"



	manager := aDOManager
!

readAll

	"Answer all the stored objects."



	^self subclassResponsibility.
!

store: anObject

	"Store an object to disk."



	^self subclassResponsibility
!

userPolicy

	"Getter - If the userPolicy is nil, get it from the objectPolicy."



	userPolicy == nil

		ifTrue: [userPolicy := manager userPolicy].

	^userPolicy.
!

userPolicy: aPolicy

	"Setter"



	userPolicy := aPolicy
! !

!DOObjectsPerFilePolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOObjectsPerFilePolicy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
