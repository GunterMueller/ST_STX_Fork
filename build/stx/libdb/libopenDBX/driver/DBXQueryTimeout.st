"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXQueryTimeout
	instanceVariableNames:'seconds microseconds'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXQueryTimeout class methodsFor:'instance creation'!

seconds: seconds 
	^ self new
		seconds: seconds;
		microseconds: 0;
		yourself
!

seconds: seconds microseconds: microseconds 
	^ self new
		seconds: seconds;
		microseconds: microseconds;
		yourself
! !

!DBXQueryTimeout methodsFor:'accessing'!

asMiliseconds
	^ (self seconds * 1000) + (((self microseconds / 1000) asFloat) integerPart asInteger )
!

asTimeSpec
	^ DBXTimeSpec seconds: self seconds nseconds: self microseconds 
!

microseconds
	^ microseconds
!

microseconds: anObject
	microseconds := anObject
!

seconds
	^ seconds
!

seconds: anObject 
	seconds := anObject
! !

!DBXQueryTimeout class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXQueryTimeout.st,v 1.2 2013-04-15 13:11:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXQueryTimeout.st,v 1.2 2013-04-15 13:11:38 cg Exp $'
! !

