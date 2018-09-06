"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXQuerySettings
	instanceVariableNames:'pageSize timeout'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXQuerySettings class methodsFor:'instance creation'!

pageSize: aPageSize
	^(super new)
		pageSize: aPageSize;
		timeout: self defaultTimeout;
		yourself.
!

pageSize: aPageSize timeout: aQueryTimeout 
	^(super new)
		pageSize: aPageSize;
		timeout: aQueryTimeout;
		yourself.
!

timeout: aQueryTimeout 
	^(super new)
		pageSize: self defaultPageSize;
		timeout: aQueryTimeout;
		yourself.
! !

!DBXQuerySettings class methodsFor:'default'!

default
	"returns the default querySettings. This is used when you call DBXConnection>>execute:"
	^ self pageSize: self defaultPageSize timeout: self defaultTimeout 
!

defaultPageSize
	^ 0
!

defaultTimeout
	"10 miliseconds"
	^DBXQueryTimeout seconds: 0 microseconds: 10.
! !

!DBXQuerySettings methodsFor:'accessing'!

pageSize
	^ pageSize
!

pageSize: anObject
	pageSize := anObject
!

timeout
	^ timeout
!

timeout: anObject
	timeout := anObject
!

timeoutAsDBXTimeSpec
	^self timeout ifNotNil: [self timeout asTimeSpec].
! !

!DBXQuerySettings class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXQuerySettings.st,v 1.2 2013-04-15 13:10:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXQuerySettings.st,v 1.2 2013-04-15 13:10:59 cg Exp $'
! !

