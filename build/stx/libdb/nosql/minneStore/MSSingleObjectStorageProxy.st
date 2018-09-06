"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MSStorageProxy subclass:#MSSingleObjectStorageProxy
	instanceVariableNames:'id'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSSingleObjectStorageProxy class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

newFor: anObject and: anMSObjectSet

	"Create a new instance of myself using anObject and anMSObjectSet."



	^self new

		id: (anMSObjectSet dbIdFor: anObject);

		yourself.

	
! !

!MSSingleObjectStorageProxy methodsFor:'As yet unclassified'!

asMSReadProxy

	"See superimplementor comments"



	| proxy |

	proxy := MSSingleObjectReadProxy new.

	proxy id: id.

	^proxy
!

id



	^id
!

id: anInteger



	id := anInteger
!

printOn: aStream



	super printOn: aStream.

	aStream 

		print: id;

		nextPut: $).
! !

!MSSingleObjectStorageProxy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSSingleObjectStorageProxy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
