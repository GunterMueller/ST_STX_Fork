"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAAccessor subclass:#MADelegatorAccessor
	instanceVariableNames:'next'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MADelegatorAccessor comment:'My access strategy is to delegate to the next accessor. I am not that useful all by myself, but subclasses might override certain methods to intercept access.'
!


!MADelegatorAccessor class methodsFor:'instance-creation'!

on: anAccessor
	^ self new next: anAccessor
! !

!MADelegatorAccessor class methodsFor:'testing'!

isAbstract
	^ false
! !

!MADelegatorAccessor methodsFor:'accessing'!

next
	^ next
!

next: anAccessor 
	next := anAccessor asAccessor
! !

!MADelegatorAccessor methodsFor:'comparing'!

= anObject
	^ super = anObject and: [ self next = anObject next ]
!

hash
	^  super hash bitXor: self next hash
! !

!MADelegatorAccessor methodsFor:'copying'!

postCopy
	super postCopy.
	next := next copy
! !

!MADelegatorAccessor methodsFor:'model'!

read: aModel
	^ self next read: aModel
!

write: anObject to: aModel
	self next write: anObject to: aModel
! !

!MADelegatorAccessor methodsFor:'printing'!

storeOn: aStream
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' on: '; store: self next; nextPut: $)
! !

!MADelegatorAccessor methodsFor:'testing'!

canRead: aModel
	^ self next canRead: aModel
!

canWrite: aModel
	^ self next canWrite: aModel
! !

!MADelegatorAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MADelegatorAccessor.st,v 1.1 2009-07-29 14:55:00 cg Exp $'
! !
