"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKFieldType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKFieldType comment:''
!


!KKFieldType methodsFor:'accessing'!

type
	self subclassResponsibility
! !

!KKFieldType methodsFor:'as yet unclassified'!

fieldFromStream: aStream
	self subclassResponsibility
!

fieldFromStream: aStream forDatabase: aDatabase
	^self fieldFromStream: aStream
!

offsetToNextField
	^ 1
!

writeField: aField onStream: aStream
	self subclassResponsibility
!

writeField: aField onStream: aStream forDatabase: aDatabase
	self writeField: aField onStream: aStream
! !

!KKFieldType methodsFor:'testing'!

isReference
	^ false
! !

!KKFieldType class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFieldType.st,v 1.3 2013-03-31 12:05:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFieldType.st,v 1.3 2013-03-31 12:05:29 cg Exp $'
! !

