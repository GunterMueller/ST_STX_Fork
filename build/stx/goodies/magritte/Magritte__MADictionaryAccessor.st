"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAAccessor subclass:#MADictionaryAccessor
	instanceVariableNames:'key'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MADictionaryAccessor comment:'I am an access strategy to be used on dictionaries. I use my ==key== to read from and write to indexed collections.'
!


!MADictionaryAccessor class methodsFor:'instance-creation'!

key: aSymbol
	^ self new
		key: aSymbol;
		yourself
! !

!MADictionaryAccessor class methodsFor:'testing'!

isAbstract
	^ false
! !

!MADictionaryAccessor methodsFor:'accessing'!

key
	^ key
!

key: aKey
	key := aKey
! !

!MADictionaryAccessor methodsFor:'comparing'!

= anObject
	^ super = anObject
		and: [ self key = anObject key ]
!

hash
	^ super hash bitXor: self key hash
! !

!MADictionaryAccessor methodsFor:'model'!

read: aModel
	^ aModel at: self key ifAbsent: [ nil ]
!

write: anObject to: aModel
	aModel at: self key put: anObject
! !

!MADictionaryAccessor methodsFor:'printing'!

storeOn: aStream
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' key: '; store: self key; nextPut: $)
! !

!MADictionaryAccessor methodsFor:'testing'!

canRead: aModel
	^ true
!

canWrite: aModel
	^ true
! !

!MADictionaryAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MADictionaryAccessor.st,v 1.1 2009-07-29 14:50:15 cg Exp $'
! !
