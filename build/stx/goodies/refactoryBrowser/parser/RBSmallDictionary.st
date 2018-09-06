"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

KeyedCollection subclass:#RBSmallDictionary
	instanceVariableNames:'keys values size'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-ParseTree Matching'
!


!RBSmallDictionary class methodsFor:'instance creation'!

new
	^self basicNew initialize
!

new: aSize 
	"Ignore the size"

	^self basicNew initialize
! !

!RBSmallDictionary methodsFor:'accessing'!

at: key ifAbsent: aBlock 
	| index |
	index := self findIndexFor: key.
	^index == 0 ifTrue: [aBlock value] ifFalse: [values at: index]
!

at: key ifAbsentPut: aBlock 
	| index |
	index := self findIndexFor: key.
	^index == 0 
		ifTrue: [self privateAt: key put: aBlock value]
		ifFalse: [values at: index]
!

empty
	size := 0
!

size
	^size
! !

!RBSmallDictionary methodsFor:'adding'!

add: anAssociation 
	self at: anAssociation key put: anAssociation value.
	^anAssociation
!

at: key put: value 
	| index |
	index := self findIndexFor: key.
	^index == 0 
		ifTrue: [self privateAt: key put: value]
		ifFalse: [values at: index put: value]
! !

!RBSmallDictionary methodsFor:'copying'!

postCopy
	keys := keys copy.
	values := values copy
! !

!RBSmallDictionary methodsFor:'enumerating'!

associationsDo: aBlock 
	self keysAndValuesDo: [:key :value | aBlock value: key -> value]
!

do: aBlock 
	1 to: size do: [:i | aBlock value: (values at: i)]
!

keysAndValuesDo: aBlock 
	1 to: size do: [:i | aBlock value: (keys at: i) value: (values at: i)]
!

keysDo: aBlock 
	1 to: size do: [:i | aBlock value: (keys at: i)]
! !

!RBSmallDictionary methodsFor:'initialize-release'!

initialize
	keys := Array new: 2.
	values := Array new: 2.
	size := 0
! !

!RBSmallDictionary methodsFor:'private'!

findIndexFor: aKey 
	1 to: size do: [:i | (keys at: i) = aKey ifTrue: [^i]].
	^0
!

growKeysAndValues
	self growTo: size * 2
!

growTo: aSize 
	| newKeys newValues |
	newKeys := Array new: aSize.
	newValues := Array new: aSize.
	1 to: size
		do: 
			[:i | 
			newKeys at: i put: (keys at: i).
			newValues at: i put: (values at: i)].
	keys := newKeys.
	values := newValues
!

privateAt: key put: value 
	size == keys size ifTrue: [self growKeysAndValues].
	size := size + 1.
	keys at: size put: key.
	^values at: size put: value
! !

!RBSmallDictionary methodsFor:'removing'!

remove: oldObject ifAbsent: anExceptionBlock 
	self removeKey: oldObject key ifAbsent: anExceptionBlock.
	^oldObject
!

removeAll
     size := 0
!

removeKey: key ifAbsent: aBlock 
	| index value |
	index := self findIndexFor: key.
	index == 0 ifTrue: [^aBlock value].
	value := values at: index.
	index to: size - 1
		do: 
			[:i | 
			keys at: i put: (keys at: i + 1).
			values at: i put: (values at: i + 1)].
	keys at: size put: nil.
	values at: size put: nil.
	size := size - 1.
	^value
! !

!RBSmallDictionary methodsFor:'testing'!

includesKey: aKey 
	^(self findIndexFor: aKey) ~~ 0
! !

!RBSmallDictionary class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBSmallDictionary.st,v 1.8 2003-09-23 22:15:22 cg Exp $'
! !
