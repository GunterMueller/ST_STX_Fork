"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXRow
	instanceVariableNames:'resultSet rawValues'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Structure'
!


!DBXRow class methodsFor:'instance creation'!

new
	self error: 'Use #onResultSet:'
!

on: aResultSet
	^(self basicNew)
		initializeResultSet: aResultSet;
		yourself.
		
! !

!DBXRow methodsFor:'accessing'!

rawValueAt: anIndex
	"It returns the value of the raw at the specified index. No conversion is here, so all values will be String"
	^rawValues at: anIndex
!

rawValueNamed: aString
	"It returns the value of the raw with the specified name. No conversion is here, so all values will be String"
	^self rawValueAt: (self columnIndex: aString) 
!

rawValues
	"It returns the values of all the raw. No conversion is here, so all values will be String"
	^rawValues
!

resultSet
	^ resultSet
!

valueAt: anIndex
	"It returns the value of the raw at the specified index. Each string returned from openDBX will be converted, if supported, to Squeak types"
	^self convertValueAt: anIndex 
!

valueNamed: aString
	"It returns the value of the raw with the specified name. Each string returned from openDBX will be converted, if supported, to Squeak types"
	^self convertValueAt: (self columnIndex: aString).
!

values
	"It returns the all the values of the raw. Each string returned from openDBX will be converted, if supported, to Squeak types"
	^self rawValues withIndexCollect: [ :each :index | 
		each ifNotNil: [
			(self columnDescriptionType: index) fromDbxString: each ] ]
! !

!DBXRow methodsFor:'enumerating'!

rawValuesDo: aBlock
	"It will execute the block on all the row values. No conversion is here, so all values will be String"
	^self rawValues do: aBlock
!

valuesDo: aBlock
	"It will execute the block on all the row values. Each string returned from openDBX will be converted, if supported, to Squeak types"
	^self values do: aBlock
! !

!DBXRow methodsFor:'initialization'!

initializeResultSet: aResultSet
	"It initialize a Row receiving a result set. We need the result set in order to ask the information about the column descriptions"
	super initialize.
	resultSet := aResultSet.
	self initializeRow.
	
!

initializeRow
	"Initialize the row. All the row values will be set."
	rawValues := Array new: self resultSet columnCount.
	self resultSet columnDescriptions withIndexDo: [ :each :i|
			rawValues at: i put: (self platform fieldRawValue: i  on: self resultSet) ]
! !

!DBXRow methodsFor:'private'!

columnDescriptionAt: anIndex
	^self resultSet columnDescriptionAt: anIndex
!

columnDescriptionType: anIndex
	^(self columnDescriptionAt: anIndex) type
!

columnDescriptionWithName: columnName
	^self resultSet columnDescriptionWithName: columnName


 
!

columnIndex: aString 
	self resultSet columnDescriptions
		withIndexDo: [:each :index | (each name sameAs: aString)
				ifTrue: [^ index]].
	OpenDBXDriverError signal: 'A column with that name was not found'.
!

convertValueAt: anIndex 
	^ (self rawValueAt: anIndex)
		ifNotNilDo: [:columnValue | (self columnDescriptionType: anIndex)
			fromDbxString: columnValue]
!

platform
	^self resultSet platform
! !

!DBXRow class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXRow.st,v 1.2 2013-04-15 13:10:07 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXRow.st,v 1.2 2013-04-15 13:10:07 cg Exp $'
! !

