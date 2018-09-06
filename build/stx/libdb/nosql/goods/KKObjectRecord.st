"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKObjectRecord
	instanceVariableNames:'txnFlags oid cpid storage data'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Protocol'
!


!KKObjectRecord class methodsFor:'as yet unclassified'!

updateObjectAt: aKey classKey: aClassKey data: aByteArray unlock: unlock downgrade: downgrade
	|flags|
	flags := unlock ifTrue: [7] ifFalse: [3].
	downgrade ifTrue: [flags := flags + 8].
	^ self new initializeWithKey: aKey classKey: aClassKey data: aByteArray txnFlags: flags
!

validateObjectAt: aKey classKey: aClassKey unlock: unlock downgrade: downgrade
	|flags|
	flags := unlock ifTrue: [6] ifFalse: [2].
	downgrade ifTrue: [flags := flags + 8].
	^ self new initializeWithKey: aKey classKey: aClassKey data: #() txnFlags: flags
! !

!KKObjectRecord class methodsFor:'private'!

fromStream: aStream
	^ self new initializeFromStream: aStream
! !

!KKObjectRecord methodsFor:'accessing'!

classKey
	^ cpid
!

data
	^ data
!

key
	^ oid
! !

!KKObjectRecord methodsFor:'comparing'!

= other
	^ other key = oid
		and: [other classKey = cpid
			and: [other data = data]]
! !

!KKObjectRecord methodsFor:'initialization'!

initializeFromStream: aStream
	|size|

	txnFlags := aStream uint32.
	oid := aStream uint32.
	cpid := aStream uint16.         self assert:(cpid notNil).
	storage := aStream uint16.
	size := aStream uint32.
	data := aStream next: size
!

initializeWithKey: aKey classKey: aClassKey data: aByteArray txnFlags: aNumber
	oid := aKey.
	cpid := aClassKey.        self assert:(cpid notNil).
	data := aByteArray.
	txnFlags := aNumber.
	storage := 0.
! !

!KKObjectRecord methodsFor:'objects from disk'!

writeOn: aStream
	aStream uint32: txnFlags.
	aStream uint32: oid.
	aStream uint16: cpid.
	aStream uint16: storage.
	aStream uint32: data size.
	aStream nextPutAll: data.
! !

!KKObjectRecord class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKObjectRecord.st,v 1.5 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKObjectRecord.st,v 1.5 2013-03-28 10:38:49 cg Exp $'
! !

