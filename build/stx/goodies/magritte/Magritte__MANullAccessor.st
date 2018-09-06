"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAAccessor subclass:#MANullAccessor
	instanceVariableNames:'uuid'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MANullAccessor comment:'I am a null access strategy and I should be neither read nor written. I am still comparable to other strategies by holding onto a unique-identifier.'
!


!MANullAccessor class methodsFor:'instance-creation'!

new
	^ self uuid: MACompatibility uuid
!

uuid: anUUID
	^ self basicNew
		uuid: anUUID;
		yourself
! !

!MANullAccessor class methodsFor:'testing'!

isAbstract
	^ false
! !

!MANullAccessor methodsFor:'accessing'!

uuid
	^ uuid
!

uuid: anObject
	uuid := anObject
! !

!MANullAccessor methodsFor:'comparing'!

= anObject
	^ super = anObject
		and: [ self uuid = anObject uuid ]
!

hash
	^ super hash bitXor: self uuid hash
! !

!MANullAccessor methodsFor:'model'!

read: aModel 
	MAReadError signal: 'This message is not appropriate for this object'
!

write: anObject to: aModel 
	MAWriteError signal: 'This message is not appropriate for this object'
! !

!MANullAccessor methodsFor:'printing'!

storeOn: aStream
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' uuid: '; store: self uuid; nextPut: $)
! !

!MANullAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MANullAccessor.st,v 1.1 2009-07-29 14:51:11 cg Exp $'
! !
