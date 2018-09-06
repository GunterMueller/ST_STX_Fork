"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MSReadProxy subclass:#MSMultiObjectReadProxy
	instanceVariableNames:'ids'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSMultiObjectReadProxy class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

! !

!MSMultiObjectReadProxy methodsFor:'As yet unclassified'!

asMSStorageProxy



	^MSMultiObjectStorageProxy new

		ids: ids;

		objectSetName: objectSet name;

		yourself.
!

getRealObject



	realObject := objectSet readForIds: ids.

	super getRealObject.
!

ids



	^ids
!

ids: aCollection



	ids := aCollection
! !

!MSMultiObjectReadProxy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSMultiObjectReadProxy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
