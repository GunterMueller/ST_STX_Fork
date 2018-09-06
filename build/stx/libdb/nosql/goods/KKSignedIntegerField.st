"{ Package: 'stx:libdb/nosql/goods' }"

KKUnsignedIntegerField subclass:#KKSignedIntegerField
	instanceVariableNames:'bitMask'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKSignedIntegerField comment:''
!


!KKSignedIntegerField methodsFor:'accessing'!

type
	^ 2
! !

!KKSignedIntegerField methodsFor:'as yet unclassified'!

decodeSignedInteger: aNumber
	^ aNumber highBit = (size * 8)
		ifTrue: [((aNumber bitXor: bitMask) + 1) negated]
		ifFalse: [aNumber]
!

encodeSignedInteger: aNumber
	^ aNumber < 0
		ifTrue: [(aNumber bitXor: bitMask) + 1]
		ifFalse: [aNumber]
!

fieldFromStream: aStream
	^ self decodeSignedInteger: (super fieldFromStream: aStream)
!

writeField: aField onStream: aStream forDatabase: aDatabase
	super writeField: (self encodeSignedInteger: aField) onStream: aStream forDatabase: aDatabase
! !

!KKSignedIntegerField methodsFor:'attributes'!

size: aNumber
	size := aNumber.
	bitMask := (2 raisedTo: size * 8) - 1.
! !

!KKSignedIntegerField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKSignedIntegerField.st,v 1.3 2013-03-31 12:02:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKSignedIntegerField.st,v 1.3 2013-03-31 12:02:41 cg Exp $'
! !

