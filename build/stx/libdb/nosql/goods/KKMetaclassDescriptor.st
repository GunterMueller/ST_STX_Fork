"{ Package: 'stx:libdb/nosql/goods' }"

KKStringDescriptor subclass:#KKMetaclassDescriptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKMetaclassDescriptor comment:''
!


!KKMetaclassDescriptor methodsFor:'*goodsplatformsqueak'!

objectFromStream: aStream forDatabase: aDatabase
	^ Smalltalk classNamed: (super objectFromStream: aStream forDatabase: aDatabase)
!

writeObject: aClass onStream: aStream forDatabase: aDatabase
	super writeObject: aClass name onStream: aStream forDatabase: aDatabase
! !

!KKMetaclassDescriptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKMetaclassDescriptor.st,v 1.3 2013-03-31 12:06:37 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKMetaclassDescriptor.st,v 1.3 2013-03-31 12:06:37 cg Exp $'
! !

