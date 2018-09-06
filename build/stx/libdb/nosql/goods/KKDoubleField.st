"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldType subclass:#KKDoubleField
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!


!KKDoubleField methodsFor:'accessing'!

size
	^ 8
!

type
	^ 4
! !

!KKDoubleField methodsFor:'as yet unclassified'!

fieldFromStream: aStream
	|float|
	Smalltalk isSmalltalkX ifTrue:[
	    float := Float basicNew.
	    Float readBinaryIEEEDoubleFrom:aStream into:float MSB:true.
	] ifFalse:[
	    float := Float new: 2.
	    float at: 1 put: aStream uint32.
	    float at: 2 put: aStream uint32.
	].
	^ float
!

writeField: aField onStream: aStream
    Smalltalk isSmalltalkX ifTrue:[
	Float storeBinaryIEEEDouble:aField on:aStream MSB:true
    ] ifFalse:[
	aStream uint32: (aField at: 1).
	aStream uint32: (aField at: 2).
    ]
! !

!KKDoubleField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKDoubleField.st,v 1.4 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKDoubleField.st,v 1.4 2013-03-28 10:38:49 cg Exp $'
! !

