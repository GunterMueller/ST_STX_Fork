"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MACondition subclass:#MAPluggableCondition
	instanceVariableNames:'receiver selector arguments index'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!


!MAPluggableCondition methodsFor:'evaluating'!

value: anObject
	| actualReceiver actualArguments |
	actualReceiver := index = 0
		ifFalse: [ receiver ]
		ifTrue: [ anObject ].
	actualArguments := index > 0
		ifFalse: [ arguments ]
		ifTrue: [
			arguments copy 
				at: index put: anObject;
				yourself ].
	^ actualReceiver
		perform: selector
		withArguments: actualArguments
! !

!MAPluggableCondition methodsFor:'initialization'!

initializeReceiver: anObject selector: aSelector arguments: anArray index: anInteger
	receiver := anObject.
	selector := aSelector.
	arguments := anArray.
	index := anInteger
! !

!MAPluggableCondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAPluggableCondition.st,v 1.1 2009-07-29 14:55:21 cg Exp $'
! !
