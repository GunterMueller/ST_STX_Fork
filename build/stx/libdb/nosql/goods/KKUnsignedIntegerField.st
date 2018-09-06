"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldType subclass:#KKUnsignedIntegerField
	instanceVariableNames:'size'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKUnsignedIntegerField comment:''
!


!KKUnsignedIntegerField methodsFor:'accessing'!

size
	^ size
!

size: aNumber
	size := aNumber
!

type
	^ 3
! !

!KKUnsignedIntegerField methodsFor:'as yet unclassified'!

fieldFromStream: aStream
	^ aStream nextNumber: size
!

writeField: aField onStream: aStream
	aStream nextNumber: size put: aField
! !

!KKUnsignedIntegerField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKUnsignedIntegerField.st,v 1.3 2013-03-31 12:02:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKUnsignedIntegerField.st,v 1.3 2013-03-31 12:02:34 cg Exp $'
! !

