"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MSAspect subclass:#MSMultiObjectAspect
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSMultiObjectAspect class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

! !

!MSMultiObjectAspect methodsFor:'As yet unclassified'!

storageProxyClass



    ^MSMultiObjectStorageProxy
!

storeAspect: aspectValue using: anMSObjectSet

	"Private - Store multiple objects."



	FlavorCompatibility issue. "This method not used now because I decided aspects should not be stored with main object."

	anMSObjectSet storeAll: aspectValue.
!

validateAspect: collection using: anMSObjectSet

	"Private - Store multiple objects."



	collection isEmpty

		ifTrue: [^self]

		ifFalse:

			[collection do: 

				[:each |

				(anMSObjectSet dbIdFor: each) isNil

					ifTrue: [self error: 'You have attempted to store an object whose aspect (', 

							name printString, ') has a value that has not been stored'].

				]

			].
! !

!MSMultiObjectAspect class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSMultiObjectAspect.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
