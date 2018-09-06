"{ Package: 'stx:libdb/nosql/goods' }"

KKStringDescriptor subclass:#KKSymbolDescriptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKSymbolDescriptor comment:''
!


!KKSymbolDescriptor methodsFor:'as yet unclassified'!

objectFromStream: aStream forDatabase: aDatabase
	^ (super objectFromStream: aStream forDatabase: aDatabase) asSymbol
! !

!KKSymbolDescriptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKSymbolDescriptor.st,v 1.3 2013-03-31 12:15:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKSymbolDescriptor.st,v 1.3 2013-03-31 12:15:43 cg Exp $'
! !

