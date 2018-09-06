"{ Package: 'stx:libdb/libopenDBX/model' }"

Object subclass:#DBXForeignKey
	instanceVariableNames:'foreignTableName foreignColumnName tableName columnName name
		components'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModel'
!


!DBXForeignKey class methodsFor:'as yet unclassified'!

baseDescription
	^ MARelationDescription new.
!

named: aName
	^self new
		name: aName;
		yourself
! !

!DBXForeignKey methodsFor:'accessing'!

components
	^ components
!

foreignTableName
	^foreignTableName
! !

!DBXForeignKey methodsFor:'as yet unclassified'!

addComponentFromColumn: aColumnName toColumn: aForeignColumnName
	components at: aColumnName put: aForeignColumnName
!

destinyColumns
	^components values
!

foreignColumnForColumn: aColumn
	^components at: aColumn name
!

foreignTable: tableName 
	foreignTableName := tableName .
!

generateSQLForCreateTable
	^'CONSTRAINT {1} FOREIGN KEY ({2}) REFERENCES {3} ({4})' format: {
		name.
		',' join: self sourceColumns.
		foreignTableName.
		',' join: self destinyColumns.
	}
!

initialize
	components := Dictionary new
!

isForColumn: aColumn
	^components includesKey: aColumn name
!

name
	^name
!

name: fkName 
	name := fkName 
!

sourceColumns
	^components keys
!

toTable:  aForeignTableName
	self foreignTable: aForeignTableName.
! !

!DBXForeignKey class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXForeignKey.st,v 1.2 2013-04-15 13:32:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXForeignKey.st,v 1.2 2013-04-15 13:32:31 cg Exp $'
! !

