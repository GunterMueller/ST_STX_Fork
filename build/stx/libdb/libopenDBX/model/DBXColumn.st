"{ Package: 'stx:libdb/libopenDBX/model' }"

Object subclass:#DBXColumn
	instanceVariableNames:'name nullable type length table'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModel'
!


!DBXColumn methodsFor:'accessing'!

bePrimaryKey
	table addPrimaryKeyColumn: self.
!

constraintsForCreate
	^self nullable ifTrue: ['']  ifFalse: [ 'NOT NULL'].
!

generateSQLForCreateTable
	"should generate something like:   FOO INT NOT NULL"
	^   '{1} {2} {3}' format: {self name. self typeForCreate. self constraintsForCreate }
!

isPrimaryKey
	^table isPrimaryKeyComponent: self.
!

length
	^ length
!

length: anInteger
	self type length: anInteger.
!

name
	^ name
!

name: aString
	name := aString 
!

nullable
	^ nullable
!

nullable: aBoolean
	nullable := aBoolean 
!

table: aTable
	table := aTable
!

type
	type ifNil: [ type := DBXColumnType new].
	^ type.
!

type: aTypeName
	" type receives a database type name such as varchar char int etc"
	self type typeName: aTypeName.
!

typeForCreate
	^self type typeString
!

typeName
	^self type typeName
! !

!DBXColumn methodsFor:'printing'!

printOn: aStream
	aStream
		nextPutAll: 'A DBXColumn(';
		nextPutAll: self name;
		nextPutAll: ')'
! !

!DBXColumn methodsFor:'testing'!

isForeignKey
	^self table isForeignKey: self.
! !

!DBXColumn class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXColumn.st,v 1.2 2013-04-15 13:32:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXColumn.st,v 1.2 2013-04-15 13:32:32 cg Exp $'
! !

