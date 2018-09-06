"{ Package: 'stx:libdb/libopenDBX/driver' }"

DBXBaseResult subclass:#DBXResult
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXResult class methodsFor:'instance creation'!

new
	self error: 'Use #on:handle:description:'
!

on: aConnection handle: aNumber description: aDescription querySettings: aQuerySettings
	^(self basicNew)
		initializeConnection: aConnection 
			handle: aNumber
			description: aDescription
			querySettings: aQuerySettings;
		yourself.
! !

!DBXResult methodsFor:'accessing'!

rowsAffected
	"Returns the number of rows that have been changed by the current statement. Affected rows are only returned for DELETE, INSERT or UPDATE statements and their concrete number depends on the database implementation. 
	
	This value depends on the type of query:

    * DDL query: It will always be zero.
    * Insert query: It will always be one.
    * Delete and update: Returns the number of rows that have been changed by the current statement. However, their concrete number depends on the database implementation. Instead returning the number of rows which are matched by the WHERE clause, MySQL for example does only count the rows whose values have really been changed. "
	
	^self description rowsAffected
! !

!DBXResult methodsFor:'release'!

releaseResult
	"Maybe in a future this method could do something"
! !

!DBXResult methodsFor:'testing'!

isResult
	^ true
! !

!DBXResult class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXResult.st,v 1.2 2013-04-15 13:11:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXResult.st,v 1.2 2013-04-15 13:11:07 cg Exp $'
! !

