"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAAccessor subclass:#MAPluggableAccessor
	instanceVariableNames:'readBlock writeBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MAPluggableAccessor comment:'I am an access strategy defined by two block-closures. The read-block expects the model as its first argument and is used to retrieve a value. The write-block expects the model as its first and the value as its second argument and is used to write a value to the model.'
!


!MAPluggableAccessor class methodsFor:'instance creation'!

read: aReadBlock write: aWriteBlock
	^ self new
		readBlock: aReadBlock;
		writeBlock: aWriteBlock;
		yourself
! !

!MAPluggableAccessor class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAPluggableAccessor methodsFor:'accessing'!

readBlock
	^ readBlock
!

readBlock: aBlock
	readBlock := aBlock
!

writeBlock
	^ writeBlock
!

writeBlock: aBlock
	writeBlock := aBlock
! !

!MAPluggableAccessor methodsFor:'comparing'!

= anObject
	^ super = anObject
		and: [ self readBlock = anObject readBlock
		and: [ self writeBlock = anObject writeBlock ] ]
!

hash
	^ super hash bitXor: (self readBlock hash bitXor: self writeBlock hash)
! !

!MAPluggableAccessor methodsFor:'model'!

read: aModel
	^ self readBlock value: aModel
!

write: anObject to: aModel
	self writeBlock value: aModel value: anObject
! !

!MAPluggableAccessor methodsFor:'printing'!

storeBlock: aBlock on: aStream
	aStream nextPutAll: aBlock decompile asString allButFirst allButLast
!

storeOn: aStream
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' read: '.
	self storeBlock: self readBlock on: aStream.
	aStream nextPutAll: ' write: '.
	self storeBlock: self writeBlock on: aStream.
	aStream nextPut: $)
! !

!MAPluggableAccessor methodsFor:'testing'!

canRead: aModel
	^ self readBlock notNil
!

canWrite: aModel
	^ self writeBlock notNil
! !

!MAPluggableAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAPluggableAccessor.st,v 1.1 2009-07-29 14:51:59 cg Exp $'
! !
