"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldContainer subclass:#KKFixedArrayContainer
	instanceVariableNames:'arraySize'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKFixedArrayContainer comment:''
!


!KKFixedArrayContainer methodsFor:'accessing'!

arraySize: aNumber
	arraySize := aNumber
!

components
	^ arraySize
!

totalSize
	^ arraySize * fieldType size
! !

!KKFixedArrayContainer methodsFor:'as yet unclassified'!

refreshObject: anObject fromStream: aStream forDatabase: aDatabase
	|array|
	array := Array new: arraySize.
	1 to: arraySize do:
		[:i | array at: i put:
			(fieldType fieldFromStream: aStream forDatabase: aDatabase)].
	anObject instVarNamed: name put: array.
!

writeObject: anObject onStream: aStream forDatabase: aDatabase
	|array|
	array := anObject instVarNamed: name.
	1 to: (array size min: arraySize) do:
		[:i | fieldType writeField: (array at: i) onStream: aStream forDatabase: aDatabase].
	array size < arraySize
		ifTrue: [aStream next: (arraySize - array size) * fieldType size put: 0]
! !

!KKFixedArrayContainer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFixedArrayContainer.st,v 1.3 2013-03-31 12:08:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFixedArrayContainer.st,v 1.3 2013-03-31 12:08:23 cg Exp $'
! !

