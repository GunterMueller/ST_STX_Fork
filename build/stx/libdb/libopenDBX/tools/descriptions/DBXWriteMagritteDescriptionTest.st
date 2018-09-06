"{ Package: 'stx:libdb/libopenDBX/tools/descriptions' }"

TestCase subclass:#DBXWriteMagritteDescriptionTest
	instanceVariableNames:'entity'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests'
!


!DBXWriteMagritteDescriptionTest methodsFor:'as yet unclassified'!

assertDescription: description equals: anEntity
	description allSatisfy: [ :attribute |
		| theChild |
		theChild := anEntity children detect: [ :child | child name = attribute name ].
		attribute = theChild.
		 ]
!

entityClass
	^Smalltalk globals at: entity entityClassName asSymbol
!

entityMetaclass
	^self entityClass class
!

setUp
	entity := DBXEntity new
					name: #TestEntity;
					category: 'DBXTools-Discard';
					yourself.
!

tearDown
	Smalltalk globals at: entity entityClassName asSymbol ifPresent: [ :aClass | aClass removeFromSystem ]
!

testAttributeWritesAccessor
	| propertyName |
	propertyName := 'priority'.
	self visitEntityDoing: [
	entity add: ( MANumberDescription new
		name: propertyName;
		accessor: #none;
		yourself).].
	self 
		assert: (self entityClass description detect: [ :child | child name = propertyName ]) accessor
		equals: (entity children detect: [ :child | child name = propertyName ]) accessor.
!

testAttributeWritesAllProperties
	| propertyName |
	propertyName := 'priority'.
	self visitEntityDoing: [
	entity add: ( MANumberDescription new
		name: propertyName;
		accessor: #none;
		beRequired;
		yourself).].
	self assertDescription: self entityClass description equals: entity.
!

testAttributeWritesDescriptionMethod
	| propertyName |
	propertyName := 'priority'.
	self visitEntityDoing: [
	entity add: ( MANumberDescription new
		name: propertyName;
		accessor: #none;
		beRequired;
		yourself).].
	self assert: (self entityMetaclass includesSelector: ('description', propertyName capitalized) asSymbol)
!

testEmptyClassIsEmptyContainer
	self visitEntityDoing: [].
	self assert: self entityClass description isEmpty
!

testEntityIsDBXEntity
	| propertyName |
	self visitEntityDoing: [].
	self assert: self entityClass description class = DBXEntity.
!

testRelationIsWritten
	| propertyName |
	propertyName := 'priority'.
	self visitEntityDoing: [
	entity add: ( MAToOneRelationDescription new
		name: propertyName;
		accessor: #none;
		beRequired;
		foreignKeyName: 'somefk';
		columnName: 'someColumn';
		foreignEntity: #SomeTable;
		classes: [ { Smalltalk at: #SomeTable } ];
		yourself).].
	self assertDescription: self entityClass description equals: entity.
!

visitEntityDoing: anAction
	anAction value.
	DBXMagritteClassBuilderVisitor new visit: entity.
	DBXMagritteWriterVisitor new visit: entity.
! !

!DBXWriteMagritteDescriptionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/DBXWriteMagritteDescriptionTest.st,v 1.2 2013-04-15 13:35:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/DBXWriteMagritteDescriptionTest.st,v 1.2 2013-04-15 13:35:00 cg Exp $'
! !

