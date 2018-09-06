"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXResultSetDescription
	instanceVariableNames:'columnDescriptions notSupportedDescriptions'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Description'
!


!DBXResultSetDescription methodsFor:'accessing'!

columnCount
"this allows you to know the number of columns for each row retrieved from the database"
	^ columnDescriptions size
!

columnDescriptionAt: anIndex
"returns the column description holded in 'anIndex' position"
	^ columnDescriptions at: anIndex
!

columnDescriptions
	^ columnDescriptions
! !

!DBXResultSetDescription methodsFor:'initialization'!

addColumnDescription: aColumnDescription
"it adds a new column description to the column descriptions collection"
	aColumnDescription addTo: self.
	
	
!

addDescription: aColumnDescription
"it adds a new column description to the column descriptions collection"
	columnDescriptions add: aColumnDescription
	
	
!

addNotSupportedDescription: aDBXColumnDescription
	notSupportedDescriptions at: self columnCount put: aDBXColumnDescription
!

detectNewTypes: aDBXResultSet
	notSupportedDescriptions keysAndValuesDo:[ :index :desc | | dbxType |
			dbxType := OpenDBX current apiQueryColumnType: aDBXResultSet handle index: (index - 1) .
			desc type: (aDBXResultSet dataTypeAt: dbxType);  dbxType: dbxType.
			desc type isBehavior ifTrue:[ 
				notSupportedDescriptions removeKey: index ] ]
!

initialize
"this DBXResultSetDescription will contain a collection of its own column descriptions, retrieved from the database"
	super initialize.
	columnDescriptions := OrderedCollection new.
	notSupportedDescriptions := Dictionary new
! !

!DBXResultSetDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXResultSetDescription.st,v 1.2 2013-04-15 13:11:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXResultSetDescription.st,v 1.2 2013-04-15 13:11:42 cg Exp $'
! !

