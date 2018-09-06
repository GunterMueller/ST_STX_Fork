"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MSAspect subclass:#MSSingleObjectAspect
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSSingleObjectAspect class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

! !

!MSSingleObjectAspect methodsFor:'As yet unclassified'!

storageProxyClass



    ^MSSingleObjectStorageProxy
!

storeAspect: aspectValue using: anMSObjectSet

	"Private - store a single object."



	FlavorCompatibility issue. "This method not used now because I decided aspects should not be stored with main object."

	anMSObjectSet store: aspectValue.
!

validateAspect: aspectValue using: anMSObjectSet

	"Private - Store multiple objects."



	(anMSObjectSet dbIdFor: aspectValue) isNil

		ifTrue: [self error: 'You have attempted to store an object whose aspect (', 

					name printString, ') has a value that has not been stored'].

! !

!MSSingleObjectAspect class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSSingleObjectAspect.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
