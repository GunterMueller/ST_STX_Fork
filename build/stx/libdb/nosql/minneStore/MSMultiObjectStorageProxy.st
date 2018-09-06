"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MSStorageProxy subclass:#MSMultiObjectStorageProxy
	instanceVariableNames:'ids'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSMultiObjectStorageProxy class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

newFor: aCollection and: anMSObjectSet

	"Create a new instance of myself using aCollection and anMSObjectSet.

	This method is being called right before saving an object to disk."



	^self new

		ids: (aCollection collect: [ :each | anMSObjectSet dbIdFor: each ]);

		yourself.
! !

!MSMultiObjectStorageProxy methodsFor:'As yet unclassified'!

asMSReadProxy

	"See superimplementor comments"



	| proxy |

	proxy := MSMultiObjectReadProxy new.

	proxy ids: ids.

	^proxy
!

ids



	ids == nil

		ifTrue: [ids := OrderedCollection new].

	^ids
!

ids: aCollection



	ids := aCollection.
!

printOn: aStream



	super printOn: aStream.

	aStream 

		print: ids;

		nextPut: $).
! !

!MSMultiObjectStorageProxy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSMultiObjectStorageProxy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
