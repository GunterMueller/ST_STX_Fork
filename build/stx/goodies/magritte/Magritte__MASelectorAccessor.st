"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAAccessor subclass:#MASelectorAccessor
	instanceVariableNames:'readSelector writeSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Accessor'
!

MASelectorAccessor comment:'I am the most common access strategy defined by a read- and a write-selector. I am mostly used together with standard getters and setters as usually defined by the accessing protocol. If there is only a read-selector specified, the write selector will be deduced automatically by adding a colon to the read-selector.'
!


!MASelectorAccessor class methodsFor:'instance creation'!

read: aSelector
	^ self read: aSelector write: nil
!

read: aReadSelector write: aWriteSelector
	^ self new
		readSelector: aReadSelector;
		writeSelector: aWriteSelector;
		yourself
!

selector: aSelector
	^ self new
		selector: aSelector;
		yourself
!

write: aSelector
	^ self read: nil write: aSelector
! !

!MASelectorAccessor class methodsFor:'testing'!

isAbstract
	^ false
! !

!MASelectorAccessor methodsFor:'accessing'!

readSelector
	^ readSelector
!

readSelector: aSelector
	readSelector := aSelector
!

writeSelector
	^ writeSelector
!

writeSelector: aSelector
	writeSelector := aSelector
! !

!MASelectorAccessor methodsFor:'accessing-dynamic'!

selector
	^ self readSelector
!

selector: aSelector
	self readSelector: aSelector asSymbol.
	self writeSelector: (aSelector asString copyWith: $:) asSymbol
! !

!MASelectorAccessor methodsFor:'comparing'!

= anObject
	^ super = anObject
		and: [ self readSelector = anObject readSelector
		and: [ self writeSelector = anObject writeSelector ] ]
!

hash
	^  super hash bitXor: (self readSelector hash bitXor: self writeSelector hash)
! !

!MASelectorAccessor methodsFor:'model'!

read: aModel
	^ aModel perform: self readSelector
!

write: anObject to: aModel
	aModel perform: self writeSelector with: anObject
! !

!MASelectorAccessor methodsFor:'printing'!

storeOn: aStream
	aStream nextPut: $(; nextPutAll: self class name; nextPutAll: ' read: '; store: self readSelector; nextPutAll: ' write: '; store: self writeSelector; nextPut: $)
! !

!MASelectorAccessor methodsFor:'testing'!

canRead: aModel
	^ self readSelector notNil and: [ aModel respondsTo: self readSelector ]
!

canWrite: aModel
	^ self writeSelector notNil and: [ aModel respondsTo: self writeSelector ]
! !

!MASelectorAccessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MASelectorAccessor.st,v 1.1 2009-07-29 14:46:38 cg Exp $'
! !
