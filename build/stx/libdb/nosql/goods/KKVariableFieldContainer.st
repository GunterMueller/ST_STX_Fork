"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldContainer subclass:#KKVariableFieldContainer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKVariableFieldContainer comment:''
!


!KKVariableFieldContainer methodsFor:'accessing'!

totalSize
	^ fieldType size
! !

!KKVariableFieldContainer methodsFor:'as yet unclassified'!

refreshObject: anObject fromStream: aStream forDatabase: aDatabase
	anObject class isVariable
		ifTrue: [self refreshVariablePartOfObject: anObject fromStream: aStream forDatabase: aDatabase]
		ifFalse: [self refreshVariableArrayInObject: anObject fromStream: aStream forDatabase: aDatabase].
!

refreshVariableArrayInObject: anObject fromStream: aStream forDatabase: aDatabase
	|size array |
	size := ((aStream size - parent fixedSize) / fieldType size).
	array := Array new: size.
	1 to: size do: [:i | array at: i put: (fieldType fieldFromStream: aStream forDatabase: aDatabase)].
	self storeField: array inObject: anObject.
!

refreshVariablePartOfObject: anObject fromStream: aStream forDatabase: aDatabase
	1 to: anObject basicSize do:
		[:i | anObject basicAt: i put: (fieldType fieldFromStream: aStream forDatabase: aDatabase)]
!

writeObject: anObject onStream: aStream forDatabase: aDatabase
	anObject class isVariable
		ifTrue: [self writeVariablePartOfObject: anObject onStream: aStream forDatabase: aDatabase]
		ifFalse: [self writeVariableArrayFrom: anObject onStream: aStream forDatabase: aDatabase]
!

writeVariableArrayFrom: anObject onStream: aStream forDatabase: aDatabase
	|array|
	array := self fieldInObject: anObject.
	array do: [:each | fieldType writeField: each onStream: aStream forDatabase: aDatabase].
!

writeVariablePartOfObject: anObject onStream: aStream forDatabase: aDatabase
	1 to: anObject basicSize do:
		[:i | fieldType writeField: (anObject basicAt: i) onStream: aStream forDatabase: aDatabase]
! !

!KKVariableFieldContainer methodsFor:'attributes'!

components
	^ 0
! !

!KKVariableFieldContainer methodsFor:'testing'!

isVariable
	^ true
! !

!KKVariableFieldContainer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKVariableFieldContainer.st,v 1.3 2013-03-31 12:05:57 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKVariableFieldContainer.st,v 1.3 2013-03-31 12:05:57 cg Exp $'
! !

