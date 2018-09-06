"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#OpenDBXDriverSmalltalkDialect
	instanceVariableNames:''
	classVariableNames:'Current'
	poolDictionaries:''
	category:'DataBase-OpenDBXDriverSmalltalk-Dialect'
!


!OpenDBXDriverSmalltalkDialect class methodsFor:'accessing'!

current
	^ Current ifNil: [ Current := OpenDBXDriverPharoDialect ] 
	
!

current: anObject
	Current := anObject
! !

!OpenDBXDriverSmalltalkDialect class methodsFor:'garbage-collect'!

addObjectToGarbageCollect: anObject
"Tells someway the garbage collect that anObject should "	
	^ self subclassResponsibility 
!

connectionsToGarbageCollect

	^ self subclassResponsibility 
! !

!OpenDBXDriverSmalltalkDialect class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/OpenDBXDriverSmalltalkDialect.st,v 1.2 2013-04-15 13:10:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/OpenDBXDriverSmalltalkDialect.st,v 1.2 2013-04-15 13:10:05 cg Exp $'
! !

