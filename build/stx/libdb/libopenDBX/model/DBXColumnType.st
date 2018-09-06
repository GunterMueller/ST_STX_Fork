"{ Package: 'stx:libdb/libopenDBX/model' }"

Object subclass:#DBXColumnType
	instanceVariableNames:'typeName length'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXDatabaseModel'
!


!DBXColumnType class methodsFor:'as yet unclassified'!

for: aTypeName
	^self new
		typeName: aTypeName; 
		yourself.
!

for: aTypeName and:aLength
	^(self for:aTypeName) 
	   length: aLength; 
	   yourself.
! !

!DBXColumnType methodsFor:'accessing'!

descriptionTuple
	^#( self typeName asSymbol self length asSymbol).
!

gotLength
	^ (self length isNil or: self length == 0) not
!

length
	^ length
!

length: aLength 
	length := aLength.
!

standarize: aTypeName
	"Ugly hack to manage custom database types"
	(aTypeName sameAs: 'character varying') ifTrue: [ ^'varchar' ].
	(aTypeName sameAs: 'character') ifTrue: [ ^'varchar' ].
	(aTypeName sameAs: 'timestamp without time zone') ifTrue: [ ^'timestamp' ].
	(aTypeName sameAs: 'TIMESTAMP(6)') ifTrue: [ ^'timestamp' ].
	aTypeName = 'time without time zone' ifTrue: [ ^'time' ].
	^aTypeName
!

typeName
	^typeName
!

typeName: aTypeName
	typeName := self standarize: aTypeName.
!

typeSelector
	^self gotLength ifTrue: [
		(self typeName,':') asSymbol.
	] ifFalse: [
		self typeName asSymbol.
	]
!

typeString
	| lenStr |
	lenStr := self gotLength ifTrue: [ '(', self length asString , ')' ] ifFalse: [ '' ].
	^self typeName, lenStr 
! !

!DBXColumnType class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXColumnType.st,v 1.2 2013-04-15 13:32:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/model/DBXColumnType.st,v 1.2 2013-04-15 13:32:43 cg Exp $'
! !

