"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

MinneStore subclass:#MSStorageProxy
	instanceVariableNames:'objectSetName unused1 unused2'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MSStorageProxy class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

! !

!MSStorageProxy methodsFor:'As yet unclassified'!

asMSReadProxy

	"Answer an instance of MSReadProxy with my pertinent info in it.

	Implemented by my subclasses."
!

isMSProxy

	"Answer true."



	^true
!

isMSStorageProxy

	"Answer true."



	^true
!

objectSetName



	^objectSetName
!

objectSetName: aSymbol



	objectSetName := aSymbol
!

printOn: aStream



	super printOn: aStream.

	aStream

		nextPut: $(;

		print: objectSetName;

		nextPutAll: ' - ';

		yourself.
! !

!MSStorageProxy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MSStorageProxy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
