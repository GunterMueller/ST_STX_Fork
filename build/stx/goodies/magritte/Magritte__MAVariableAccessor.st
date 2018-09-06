"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAAccessor subclass:#MAVariableAccessor
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MAVariableAccessor comment:'I am an access strategy that directly reads from and writes to instance variables. I strongly violate encapsulation and most of the time I should be replaced by an instance of *MASelectorAccessor*.'
!


!MAVariableAccessor class methodsFor:'instance creation'!

name: aString
	^ self new
		name: aString;
		yourself
! !

!MAVariableAccessor class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAVariableAccessor methodsFor:'accessing'!

name
	^ name
!

name: aString
	name := aString
! !

!MAVariableAccessor methodsFor:'comparing'!

= anObject
	^ super = anObject and: [ self name = anObject name ]
!

hash
	^ super hash bitXor: self name hash
! !

!MAVariableAccessor methodsFor:'model'!

read: aModel
	^ aModel instVarNamed: self name
!

write: anObject to: aModel
	aModel instVarNamed: self name put: anObject
! !

!MAVariableAccessor methodsFor:'printing'!

storeOn: aStream
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' name: '; store: self name; nextPut: $)
! !

!MAVariableAccessor methodsFor:'testing'!

canRead: aModel
	^ aModel class allInstVarNames includes: self name
!

canWrite: aModel
	^ self canRead: aModel
! !

!MAVariableAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAVariableAccessor.st,v 1.1 2009-07-29 14:50:47 cg Exp $'
! !
