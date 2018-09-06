"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MSReadProxy subclass:#MSSingleObjectReadProxy
	instanceVariableNames:'id'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSSingleObjectReadProxy class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

! !

!MSSingleObjectReadProxy methodsFor:'As yet unclassified'!

asMSStorageProxy



	^MSSingleObjectStorageProxy new

		id: id;

		objectSetName: objectSet name;

		yourself.
!

getRealObject



	realObject := objectSet readForId: id.

	super getRealObject.
!

id



	^id
!

id: anInteger



	id := anInteger
! !

!MSSingleObjectReadProxy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSSingleObjectReadProxy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
