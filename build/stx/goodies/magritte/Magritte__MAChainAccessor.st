"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MADelegatorAccessor subclass:#MAChainAccessor
	instanceVariableNames:'accessor'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MAChainAccessor comment:'I am an access strategy used to chain two access strategies. To read and write a value the ==accessor== is performed on the given model and the result is passed into the ==next== accessor.'
!


!MAChainAccessor class methodsFor:'instance-creation'!

accessors: aSequenceableCollection
	aSequenceableCollection isEmpty
		ifTrue: [ self error: 'Unable to create accessor sequence from empty collection.' ].
	aSequenceableCollection size = 1
		ifTrue: [ ^ aSequenceableCollection first asAccessor ].
	^ self 
		on: aSequenceableCollection first asAccessor 
		accessor: (self accessors: aSequenceableCollection allButFirst)
!

on: anAccessor accessor: anotherAccessor
	^ (self on: anAccessor) accessor: anotherAccessor
! !

!MAChainAccessor methodsFor:'accessing'!

accessor
	^ accessor
!

accessor: anAccessor
	accessor := anAccessor
! !

!MAChainAccessor methodsFor:'comparing'!

= anObject
	^ super = anObject and: [ self accessor = anObject accessor ]
!

hash
	^ super hash bitXor: self accessor hash
! !

!MAChainAccessor methodsFor:'copying'!

postCopy
	super postCopy.
	accessor := accessor copy
! !

!MAChainAccessor methodsFor:'model'!

read: aModel
	^ self accessor read: (super read: aModel)
!

write: anObject to: aModel
	self accessor write: anObject to: (super read: aModel)
! !

!MAChainAccessor methodsFor:'printing'!

storeOn: aStream
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' on: '; store: self next; nextPutAll: ' accessor: '; store: self accessor; nextPut: $)
! !

!MAChainAccessor methodsFor:'testing'!

canRead: aModel
	^ (super canRead: aModel) and: [ self accessor canRead: (self next read: aModel) ]
!

canWrite: aModel
	^ (super canRead: aModel) and: [ self accessor canWrite: (self next read: aModel) ]
! !

!MAChainAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAChainAccessor.st,v 1.1 2009-07-29 14:46:19 cg Exp $'
! !
