"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldContainer subclass:#KKSingleFieldContainer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKSingleFieldContainer comment:''
!


!KKSingleFieldContainer class methodsFor:'as yet unclassified'!

stringField
	^ self new fieldType: KKStringField new
! !

!KKSingleFieldContainer methodsFor:'accessing'!

totalSize
	^ fieldType size
! !

!KKSingleFieldContainer methodsFor:'as yet unclassified'!

refreshObject: anObject fromStream: aStream forDatabase: aDatabase
	self storeField: (fieldType fieldFromStream: aStream forDatabase: aDatabase) inObject: anObject
!

writeObject: anObject onStream: aStream forDatabase: aDatabase
	fieldType writeField: (self fieldInObject: anObject) onStream: aStream forDatabase: aDatabase

! !

!KKSingleFieldContainer methodsFor:'attributes'!

components
	^ 1
! !

!KKSingleFieldContainer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKSingleFieldContainer.st,v 1.3 2013-03-31 12:13:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKSingleFieldContainer.st,v 1.3 2013-03-31 12:13:05 cg Exp $'
! !

