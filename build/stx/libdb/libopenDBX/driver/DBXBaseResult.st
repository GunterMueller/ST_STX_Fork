"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXBaseResult
	instanceVariableNames:'connection handle description querySettings'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXBaseResult class methodsFor:'instance creation'!

new
	self error: 'You must instanciate a subclass of DBXBaseResult'
! !

!DBXBaseResult methodsFor:'accessing'!

connection
	^ connection
!

connection: aConnection
	connection := aConnection
!

description
	^description
!

description: aDescription 
	description := aDescription
!

handle
	^handle
!

handle: aHandle 
	handle := aHandle
!

platform
	^self connection platform
!

querySettings
	^ querySettings
!

querySettings: anObject
	querySettings := anObject
! !

!DBXBaseResult methodsFor:'finalization'!

releaseResult
	"It will release all the resources associated with a query, if there is any"
	self subclassRisponsability
! !

!DBXBaseResult methodsFor:'initialization'!

initializeConnection: aConnection handle: aNumber description: aDescription querySettings: aQuerySettings 
	super initialize.
	connection := aConnection.
	handle := aNumber.
	description := aDescription.
	querySettings := aQuerySettings.
! !

!DBXBaseResult methodsFor:'testing'!

isDBXMultiStatementResultSetIterator
	^ false
!

isResult
	^ false
!

isResultSet
	^ false
! !

!DBXBaseResult class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXBaseResult.st,v 1.2 2013-04-15 13:11:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXBaseResult.st,v 1.2 2013-04-15 13:11:01 cg Exp $'
! !

