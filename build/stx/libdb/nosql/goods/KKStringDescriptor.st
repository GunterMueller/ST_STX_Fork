"{ Package: 'stx:libdb/nosql/goods' }"

KKVariableClassDescriptor subclass:#KKStringDescriptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKStringDescriptor comment:''
!


!KKStringDescriptor methodsFor:'accessing'!

instanceClass
	^ ByteArray
! !

!KKStringDescriptor methodsFor:'as yet unclassified'!

objectFromStream: aStream forDatabase: aDatabase
	^ (super objectFromStream: aStream  forDatabase: aDatabase) asString
!

writeObject: anObject onStream: aStream forDatabase: aDatabase
	super writeObject: anObject asByteArray onStream: aStream forDatabase: aDatabase
! !

!KKStringDescriptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKStringDescriptor.st,v 1.3 2013-03-31 12:07:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKStringDescriptor.st,v 1.3 2013-03-31 12:07:32 cg Exp $'
! !

