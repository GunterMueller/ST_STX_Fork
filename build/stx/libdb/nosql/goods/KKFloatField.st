"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldType subclass:#KKFloatField
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!


!KKFloatField methodsFor:'accessing'!

size
	^ 4
!

type
	^ 4
! !

!KKFloatField methodsFor:'as yet unclassified'!

fieldFromStream: aStream
        Smalltalk isSmalltalkX ifTrue:[
            ^ ShortFloat readBinaryIEEESingleFrom:aStream MSB:true.
        ] ifFalse:[
            ^ Float fromIEEE32Bit: aStream uint32
        ].
!

writeField: aField onStream: aStream
    Smalltalk isSmalltalkX ifTrue:[
        ShortFloat storeBinaryIEEESingle:(aField asShortFloat) on:aStream MSB:true
    ] ifFalse:[
        aStream uint32: aField asIEEE32BitWord
    ]
! !

!KKFloatField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFloatField.st,v 1.5 2013-03-31 20:10:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKFloatField.st,v 1.5 2013-03-31 20:10:55 cg Exp $'
! !

