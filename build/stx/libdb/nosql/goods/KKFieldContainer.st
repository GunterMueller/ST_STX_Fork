"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKFieldContainer
	instanceVariableNames:'fieldType name parent'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKFieldContainer comment:''
!


!KKFieldContainer class methodsFor:'as yet unclassified'!

booleanField
	^ self new fieldType: KKBooleanField new
!

byteField
	^ self new fieldType: (KKSignedIntegerField new size: 1)
!

charField
	^ self new fieldType: (KKUnsignedIntegerField new size: 2)
!

doubleField
	^ self new fieldType: KKDoubleField new
!

floatField
	^ self new fieldType: KKFloatField new
!

intField
	^ self new fieldType: (KKSignedIntegerField new size: 4)
!

longField
	^ self new fieldType: (KKSignedIntegerField new size: 8)
!

referenceField
	^ self new fieldType: KKReferenceField new
!

shortField
	^ self new fieldType: (KKSignedIntegerField new size: 2)
! !

!KKFieldContainer methodsFor:'accessing'!

fieldType
	^ fieldType
!

fieldType: aType
	fieldType := aType
!

name
	^ name
!

name: aName
	name := aName
!

parent: aClassDescriptor
	parent := aClassDescriptor
!

totalSize
	self subclassResponsibility
!

type
	^ fieldType type
! !

!KKFieldContainer methodsFor:'as yet unclassified'!

fieldInObject: anObject
	|i|
	i := parent indexOfInstVarNamed: name.
	^ i > 0 ifTrue: [anObject instVarAt: i]
!

fieldSize
	^ fieldType size
!

offsetToNextField
	^ 1
!

refreshObject: anObject fromStream: aStream forDatabase: aDatabase
	self subclassResponsibility
!

storeField: aField inObject: anObject
	|i|
	i :=  parent indexOfInstVarNamed: name.
	i > 0 ifTrue: [anObject instVarAt: i put: aField]
!

writeObject: anObject onStream: aStream forDatabase: aDatabase
	self subclassResponsibility
! !

!KKFieldContainer methodsFor:'attributes'!

components
	self subclassResponsibility
! !

!KKFieldContainer methodsFor:'comparing'!

= other
	^ (((name = other name
		and: [self fieldSize = other fieldSize])
		and: [self components = other components])
		and: [self type = other type])
! !

!KKFieldContainer methodsFor:'testing'!

hash
	^ name hash + self fieldSize + self components + self type
!

isReference
	^ fieldType isReference
!

isVariable
	^ false
! !

!KKFieldContainer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFieldContainer.st,v 1.3 2013-03-31 12:14:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFieldContainer.st,v 1.3 2013-03-31 12:14:10 cg Exp $'
! !

