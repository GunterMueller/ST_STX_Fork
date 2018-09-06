"{ Package: 'stx:libdb/libopenDBX/driver/pharo' }"

OpenDBXDriverSmalltalkDialect subclass:#OpenDBXDriverPharoDialect
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverPharo-Dialect'
!


!OpenDBXDriverPharoDialect class methodsFor:'accessing'!

addObjectToGarbageCollect: anObject

	WeakRegistry default add: anObject.
!

connectionsToGarbageCollect

	^ WeakRegistry default keys
				select: [:each | each class = DBXConnection]
! !

!OpenDBXDriverPharoDialect class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/pharo/OpenDBXDriverPharoDialect.st,v 1.2 2013-04-15 13:15:02 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/pharo/OpenDBXDriverPharoDialect.st,v 1.2 2013-04-15 13:15:02 cg Exp $'
! !

