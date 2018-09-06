"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldType subclass:#KKStringField
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKStringField comment:''
!


!KKStringField methodsFor:'accessing'!

size
	^ 2
!

type
	^ 5
! !

!KKStringField methodsFor:'as yet unclassified'!

fieldFromStream: aStream
	|length string|
	length := aStream uint16.
	string := String new: length.

	1 to: length do: [:i | string at: i put: (Character value: aStream uint16)].
	^ string
!

writeField: anObject onStream: aStream
	aStream uint16: anObject size.
	anObject do: [:char | aStream uint16: char asInteger].
! !

!KKStringField methodsFor:'testing'!

isReference
	^ false
! !

!KKStringField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKStringField.st,v 1.3 2013-03-31 12:04:58 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKStringField.st,v 1.3 2013-03-31 12:04:58 cg Exp $'
! !

