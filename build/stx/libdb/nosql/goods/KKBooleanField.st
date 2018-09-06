"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldType subclass:#KKBooleanField
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKBooleanField comment:''
!


!KKBooleanField methodsFor:'accessing'!

size
	^ 1
!

type
	^ 3
! !

!KKBooleanField methodsFor:'as yet unclassified'!

fieldFromStream: aStream
	^ aStream boolean
!

writeField: aField onStream: aStream
	aStream boolean: aField
! !

!KKBooleanField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKBooleanField.st,v 1.3 2013-03-31 12:12:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKBooleanField.st,v 1.3 2013-03-31 12:12:18 cg Exp $'
! !

