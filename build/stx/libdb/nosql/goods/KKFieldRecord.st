"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKFieldRecord
	instanceVariableNames:'type size components index nextIndex name nameOffset'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Protocol'
!


!KKFieldRecord class methodsFor:'as yet unclassified'!

fromDescriptor: aDescriptor atIndex: anIndex
	^ self new initializeFromDescriptor: aDescriptor atIndex: anIndex
!

fromStream: aStream atIndex: anIndex
	^ self new initializeFromStream: aStream atIndex: anIndex
! !

!KKFieldRecord methodsFor:'accessing'!

name
	^ name
!

name: aName
	name := aName
!

nameOffset: aNumber
	nameOffset := aNumber
!

nextIndex
	^ nextIndex
!

nextIndex: anIndex
	nextIndex := anIndex
! !

!KKFieldRecord methodsFor:'initialization'!

initializeFromDescriptor: aDescriptor atIndex: anIndex
	type := aDescriptor type.
	size := aDescriptor fieldSize.
	components := aDescriptor components.
	name := aDescriptor name.
	index := anIndex.
	nextIndex := anIndex + aDescriptor offsetToNextField
!

initializeFromStream: aStream atIndex: anIndex
	type := aStream uint16.
	nameOffset := aStream uint16.
	size := aStream uint32.
	components := aStream uint32.
	nextIndex := aStream uint32.
	index := anIndex.
! !

!KKFieldRecord methodsFor:'objects from disk'!

writeOn: aStream
	aStream
		uint16: type;
		uint16: nameOffset;
		uint32: size;
		uint32: components;
		uint32: nextIndex.
! !

!KKFieldRecord methodsFor:'printing'!

descriptor
	|fieldType container selectors |
	type = 0 ifTrue:
		[^ KKStructureContainer new
							name: name;
							fieldCount: (nextIndex - index) - 1;
							fieldSize: size].
	selectors := #(makeReferenceField makeSignedIntegerField makeBooleanOrUnsignedIntegerField makeFloatOrDoubleField makeStringField makeStringArrayField).

	type <= selectors size ifFalse: [self error: 'unknown field type'].
	fieldType := self perform: (selectors at: type).

	container :=
		components = 0
			ifTrue: [KKVariableFieldContainer new]
			ifFalse: [components = 1
						ifTrue: [KKSingleFieldContainer new]
						ifFalse: [KKFixedArrayContainer new arraySize: components]].
	container
		name: name;
		fieldType: fieldType.
	^ container
! !

!KKFieldRecord methodsFor:'private'!

makeBooleanOrUnsignedIntegerField
	^size = 1
		ifTrue: [KKBooleanField new]
		ifFalse: [KKUnsignedIntegerField new size: size]
!

makeFloatOrDoubleField
	^ size = 4
		ifTrue: [KKFloatField new]
		ifFalse: [KKDoubleField new]
!

makeReferenceField
	^KKReferenceField new
!

makeSignedIntegerField
	^KKSignedIntegerField new size: size
!

makeStringArrayField
	^KKStringArrayField new
!

makeStringField
	^KKStringField new
! !

!KKFieldRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFieldRecord.st,v 1.4 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFieldRecord.st,v 1.4 2013-03-28 10:38:49 cg Exp $'
! !

