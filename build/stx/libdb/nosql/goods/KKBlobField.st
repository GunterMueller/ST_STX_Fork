"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldType subclass:#KKBlobField
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKBlobField comment:''
!


!KKBlobField methodsFor:'accessing'!

size
	^ 4
!

type
	^ 6
! !

!KKBlobField methodsFor:'testing'!

isReference
	^ false
! !

!KKBlobField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKBlobField.st,v 1.3 2013-03-31 12:16:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKBlobField.st,v 1.3 2013-03-31 12:16:09 cg Exp $'
! !

