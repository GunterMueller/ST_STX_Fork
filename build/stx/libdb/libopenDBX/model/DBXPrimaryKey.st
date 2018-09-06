"{ Package: 'stx:libdb/libopenDBX/model' }"

DBXColumnCluster subclass:#DBXPrimaryKey
	instanceVariableNames:'column table'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModel'
!


!DBXPrimaryKey class methodsFor:'as yet unclassified'!

baseDescription
	^ MAContainer new.
!

forColumn: aColumn
	^self new
		column: aColumn;
		yourself 
!

forColumn: aColumn table: aTable
	^self new
		column: aColumn;
		table: aTable;
		yourself 
! !

!DBXPrimaryKey methodsFor:'as yet unclassified'!

column: aColumn
	column := aColumn
!

columnName
	^column name
!

table: aTable
	table := aTable
! !

!DBXPrimaryKey class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXPrimaryKey.st,v 1.2 2013-04-15 13:32:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXPrimaryKey.st,v 1.2 2013-04-15 13:32:35 cg Exp $'
! !

