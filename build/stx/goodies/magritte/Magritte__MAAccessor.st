"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAObject subclass:#MAAccessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MAAccessor comment:'I am the abstract superclass to all accessor strategies. Accessors are used to implement different ways of accessing (reading and writing) data from instances using a common protocol: data can be uniformly read and written using ==#readFrom:== respectively ==#write:to:==.'
!


!MAAccessor methodsFor:'converting'!

asAccessor
	^ self
! !

!MAAccessor methodsFor:'model'!

read: aModel
	"Read from ==aModel== using the access-strategy of the receiver."

	^ nil
!

write: anObject to: aModel
	"Write ==anObject== to ==aModel== using the access-strategy of the receiver."
! !

!MAAccessor methodsFor:'printing'!

printOn: aStream
	self storeOn: aStream
!

storeOn: aStream
	aStream nextPutAll: self class name; nextPutAll: ' new'
! !

!MAAccessor methodsFor:'testing'!

canRead: aModel
	"Test if ==aModel== can be read."

	^ false
!

canWrite: aModel
	"Test if ==aModel== can be written."

	^ false
! !

!MAAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAAccessor.st,v 1.1 2009-07-29 14:47:47 cg Exp $'
! !
