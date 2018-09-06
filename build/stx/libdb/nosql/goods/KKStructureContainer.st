"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldContainer subclass:#KKStructureContainer
	instanceVariableNames:'fieldCount size'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!


!KKStructureContainer methodsFor:'accessing'!

fieldCount: aNumber
	fieldCount := aNumber
!

totalSize
	^ 0
!

type
	^ 0
! !

!KKStructureContainer methodsFor:'as yet unclassified'!

calculateSize
	|startIndex|
	startIndex := parent fields identityIndexOf: self.
	Smalltalk isSmalltalkX ifTrue:[
	    ^(parent fields copyFrom: startIndex to: startIndex + fieldCount)
		    sum: [:each | each totalSize]
	] ifFalse:[
	    ^(parent fields copyFrom: startIndex to: startIndex + fieldCount)
		    detectSum: [:each | each totalSize]
	]
!

fieldSize
	^ size ifNil: [size := self calculateSize]

!

fieldSize: aNumber
	size := aNumber
!

offsetToNextField
	^ fieldCount + 1
!

refreshObject: anObject fromStream: aStream forDatabase: aDatabase
!

writeObject: anObject onStream: aStream forDatabase: aDatabase
! !

!KKStructureContainer methodsFor:'attributes'!

components
	^ 1
! !

!KKStructureContainer methodsFor:'testing'!

isReference
	^ false
! !

!KKStructureContainer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKStructureContainer.st,v 1.3 2013-03-28 10:38:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKStructureContainer.st,v 1.3 2013-03-28 10:38:50 cg Exp $'
! !

