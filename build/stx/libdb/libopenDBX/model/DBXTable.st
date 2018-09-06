"{ Package: 'stx:libdb/libopenDBX/model' }"

Object subclass:#DBXTable
	instanceVariableNames:'name columns foreignKeys primaryKeyColumns platform
		uniqueConstraints'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModel'
!


!DBXTable class methodsFor:'as yet unclassified'!

named: aTableName
	^self new
		name: aTableName;
		yourself
! !

!DBXTable methodsFor:'accessing'!

columns
	^ columns
!

foreignKeys
	^foreignKeys
!

foreignKeysDo: anAction
	foreignKeys do: anAction
!

platform
	^ platform
!

platform: aPlatform
	platform := aPlatform
!

uniqueConstraints
	^uniqueConstraints
! !

!DBXTable methodsFor:'as yet unclassified'!

columnsDo: aBlock
	columns do: aBlock.
!

foreignKeyForColumn: aColumn
	^foreignKeys detect: [ :fk | fk isForColumn: aColumn ]
!

foreignKeyNamed: fkName
	^foreignKeys detect: [ :fk | fk name = fkName ] 
		ifNone: [ 
			| fk |
			fk := DBXForeignKey named: fkName. 
			foreignKeys add: fk.
			fk "return created foreign key"
			]
!

generateCreateTable
	| columnsSql template |
	template := 'CREATE TABLE {1} ( {2} )'.
	columnsSql := ', ' join: ((columns asOrderedCollection , foreignKeys asOrderedCollection) collect: #generateSQLForCreateTable ).
	primaryKeyColumns ifNotEmpty: [ columnsSql := columnsSql ,  ', ' , self primaryKeySQLForCreateTable ].
	^template format: {self name . columnsSql }
!

generateDropTable
	^  ' DROP TABLE {1} ' format: { self name }.
!

initialize 
	columns := Set new.
	foreignKeys := Set new.
	primaryKeyColumns := Set new.
	uniqueConstraints := Set new
!

isForeignKey: aColumn 
	^foreignKeys anySatisfy: [ :fk | fk isForColumn: aColumn ].
!

isPrimaryKeyComponent: aColumn
	^primaryKeyColumns anySatisfy: [ :c | c columnName = aColumn name ].
!

name
	^name
!

name:aName
	name := aName .
!

primaryKeySQLForCreateTable
	| template |
	template := 'CONSTRAINT {1} PRIMARY KEY ({2})'.
	columns := ',' join: (primaryKeyColumns collect: #columnName).
	^template format:{ 'pk_', self name . columns }
! !

!DBXTable methodsFor:'building'!

addColumn: columnName ofType: typeName
	^self addColumn: columnName ofType: typeName withLength: nil
!

addColumn: anAttributeName ofType: aType withLength: aLen
	^self addColumn: anAttributeName
		ofType: aType
		withLength: aLen
		nullable: false
!

addColumn: anAttributeName ofType: aType withLength: aLen nullable: aBool
	| attribute |
	attribute := DBXColumn new.
	attribute 
		name: anAttributeName; 
		type: aType;
		length: aLen;
		nullable: aBool.    
	columns add: attribute.
	attribute table: self.
	^attribute
!

addComponentToForeignKey: fkName foreignTable: foreignTableName foreignColumn: foreignColumnName column: columnName
	(self foreignKeyNamed: fkName)
		toTable: foreignTableName;
		addComponentFromColumn: columnName
		toColumn: foreignColumnName
!

addPrimaryKeyColumn: aColumn
	primaryKeyColumns add: (DBXPrimaryKey forColumn: aColumn table: self)
!

addUniqueConstraint: constraintName onColumnNamed: columnName
	self uniqueConstraints add: (DBXUnique named: constraintName column: columnName)
!

buildColumnForRow: aRow
	self
		addColumn: (aRow rawValueNamed: 'column_name')  
		ofType: (aRow rawValueNamed: 'type') 
		withLength: (self platform columnLengthForRow: aRow)
		nullable: (self platform stringToBool: (aRow rawValueNamed: self platform columnNullableColumnName ))
!

buildConstraintForRow: aRow
	(aRow rawValueNamed: 'constraint_type') = 'FOREIGN KEY'
		ifTrue: [
			^self addComponentToForeignKey: (aRow rawValueNamed: 'constraint_name')
				foreignTable: (aRow rawValueNamed: 'foreign_table_name')
				foreignColumn: (aRow rawValueNamed: 'foreign_column_name')
				column: (aRow rawValueNamed: 'own_column_name')
		].
	(aRow rawValueNamed: 'constraint_type') = 'UNIQUE'
		ifTrue: [
			^self
				addUniqueConstraint: (aRow rawValueNamed: 'constraint_name')
				onColumnNamed: (aRow rawValueNamed: 'own_column_name')
		].
	(aRow rawValueNamed: 'constraint_type') = 'PRIMARY KEY'
		ifTrue: [
			^(self columnNamed: (aRow rawValueNamed: 'own_column_name') 
				ifNone: [ ^self ]) bePrimaryKey.
		].
	(aRow rawValueNamed: 'constraint_type') = 'CHECK'
		ifTrue: [
			^self flag: #check.
		].
! !

!DBXTable methodsFor:'printing'!

printOn: aStream
	aStream
		nextPutAll: 'A DBXTable(';
		nextPutAll: self name;
		nextPutAll: ')'
! !

!DBXTable methodsFor:'testing'!

columnNamed: aColumnName
	^self columns detect: [ :c | c name sameAs: aColumnName ]
!

columnNamed: aColumnName ifNone: aBlock
	^self columns detect: [ :c | c name sameAs: aColumnName ] ifNone: aBlock
! !

!DBXTable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXTable.st,v 1.2 2013-04-15 13:32:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXTable.st,v 1.2 2013-04-15 13:32:33 cg Exp $'
! !

