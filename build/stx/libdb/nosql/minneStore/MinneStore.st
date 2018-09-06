"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

Object subclass:#MinneStore
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!MinneStore class methodsFor:'As yet unclassified'!

Copyright

	"Copyright (c) 1997,1998  Jonathan A. Carlson."

!

initializePath: aString

	"Create path.  If it already exists, remove all files in it."



	FlavorCompatibility removeDirectoryNamed: aString ifAbsent: [].

	FlavorCompatibility createDirectoryNamed: aString.
!

new

	"Answer a new initialized instance of myself."



	^super new initialize.
! !

!MinneStore methodsFor:'As yet unclassified'!

initialize

	"Default to nothing.  Subclasses should override if needed."
!

isMSTreeHolder



	^false
! !

!MinneStore class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/MinneStore.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
