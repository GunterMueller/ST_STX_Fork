"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKClassRecord
	instanceVariableNames:'fixedSize varyingSize fixedRefs varyingRefs fields name nameSize'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Protocol'
!


!KKClassRecord class methodsFor:'as yet unclassified'!

fromDescriptor: aDescriptor
	^ self new initializeFromDescriptor: aDescriptor
! !

!KKClassRecord class methodsFor:'private'!

fromStream: aStream
	^ self new initializeFromStream: aStream
! !

!KKClassRecord methodsFor:'as yet unclassified'!

calculateNameOffsets
	|base i|
	base := fields size * 16.
	i := name size + 1.
	fields do:
		[:each |
		each nameOffset: base + i.
		i := i + each name size + 1].
	nameSize := i.

!

fixIndices
	|indicesSeen|
	indicesSeen := Set new.
	fields do:
		[:each | |index|
		index := each nextIndex.
		((indicesSeen includes: index) or: [index >= fields size])
			ifTrue: [each nextIndex: 0].
		indicesSeen add: index].
! !

!KKClassRecord methodsFor:'initialization'!

initializeFromDescriptor: aDescriptor
	fields := aDescriptor fields withIndexCollect:
		[:each :i | (KKFieldRecord fromDescriptor: each atIndex: i - 1)].

	fixedSize := aDescriptor fixedSize.
	varyingSize := aDescriptor varyingSize.
	fixedRefs := aDescriptor fixedRefs.
	varyingRefs := aDescriptor varyingRefs.
	name := aDescriptor className.

	self fixIndices.
	self calculateNameOffsets.
!

initializeFromStream: aStream
	| fieldCount |

	fixedSize := aStream uint32.
	varyingSize := aStream uint32.
	fixedRefs := aStream uint32.
	varyingRefs := aStream uint32.

	fieldCount := aStream uint32.
	nameSize :=  aStream uint32.

	fields := Array new: fieldCount.
	1 to: fieldCount do: [:i |
		fields at: i put: (KKFieldRecord fromStream: aStream atIndex: i - 1)].

	name := (aStream upTo: 0) asString.
	fields do: [:field | field name: (aStream upTo: 0) asString].
! !

!KKClassRecord methodsFor:'objects from disk'!

writeOn: aStream
	aStream uint32: fixedSize.
	aStream uint32: varyingSize.
	aStream uint32: fixedRefs.
	aStream uint32: varyingRefs.

	aStream uint32: fields size.
	aStream uint32: nameSize.
	fields do: [:each | each writeOn: aStream].
	aStream nextPutAll: name asByteArray; nextPut: 0.
	fields do: [:each | aStream nextPutAll: each name asByteArray; nextPut: 0].
! !

!KKClassRecord methodsFor:'printing'!

descriptor
	|descr|
	descr := KKClassDescriptor forClassNamed: name.
	fields do: [:each | descr addField: each descriptor].
	^ descr
! !

!KKClassRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKClassRecord.st,v 1.4 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKClassRecord.st,v 1.4 2013-03-28 10:38:49 cg Exp $'
! !

