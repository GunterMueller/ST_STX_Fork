"{ Package: 'stx:libdb/libopenDBX/tools/descriptions' }"

TestCase subclass:#DBXBuildClassTest
	instanceVariableNames:'entity'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-DBXTools-DescriptionsTests'
!


!DBXBuildClassTest methodsFor:'as yet unclassified'!

setUp
	entity := DBXEntity new
					name: #TestEntity;
					category: 'DBXTools-Discard';
					yourself.
!

tearDown
	Smalltalk globals at: entity entityClassName asSymbol ifPresent: [ :aClass | aClass removeFromSystem ]
!

testBuildAccessors
	| builder |
	entity add: ( MANumberDescription new
		name: 'priority';
		beRequired;
		yourself).
	builder := DBXMagritteClassBuilderVisitor new.
	builder mustBuildAccessors: true.
	builder visit: entity.
	self assert: ((Smalltalk globals at: entity entityClassName asSymbol) includesSelector: 'priority' asSymbol).
	self assert: ((Smalltalk globals at: entity entityClassName asSymbol) includesSelector: 'priority:' asSymbol)
!

testBuildClass
	self visitEntityDoing: [].
	self assert: (Smalltalk globals includesKey: entity entityClassName asSymbol)
!

testBuildClassHasInstVar
	self visitEntityDoing: [
	entity add: ( MANumberDescription new
		name: 'priority';
		beRequired;
		yourself).].
	self assert: (Smalltalk globals includesKey: entity entityClassName asSymbol).
	self assert: ((Smalltalk globals at: entity entityClassName asSymbol) hasInstVarNamed: 'priority')
!

visitEntityDoing: anAction
	anAction value.
	DBXMagritteClassBuilderVisitor new visit: entity.
! !

!DBXBuildClassTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/DBXBuildClassTest.st,v 1.2 2013-04-15 13:34:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/tools/descriptions/DBXBuildClassTest.st,v 1.2 2013-04-15 13:34:59 cg Exp $'
! !

