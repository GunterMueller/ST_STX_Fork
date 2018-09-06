"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAObject subclass:#MACondition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!


!MACondition class methodsFor:'instance creation'!

receiver: anObject selector: aSelector arguments: anArray index: anInteger
	(aSelector numArgs = anArray size)
		ifFalse: [ self error: 'Invalid number of arguments.' ].
	(anInteger between: 0 and: anArray size)
		ifFalse: [ self error: 'Index out of bounds.' ].
	^ MAPluggableCondition new 
		initializeReceiver: anObject
		selector: aSelector
		arguments: anArray
		index: anInteger
! !

!MACondition class methodsFor:'convenience'!

receiver: anObject selector: aSelector
	^ self receiver: anObject selector: aSelector arguments: #(nil) index: 1
!

selector: aSelector
	^ self receiver: nil selector: aSelector arguments: #() index: 0
!

selector: aSelector argument: anObject
	^ self receiver: nil selector: aSelector arguments: (Array with: anObject) index: 0
! !

!MACondition class methodsFor:'testing'!

isAbstract
        ^ self name = #MACondition
        or:[ self name = #'Magritte::MACondition' ]
! !

!MACondition methodsFor:'accessing'!

numArgs
	^ 1
! !

!MACondition methodsFor:'evaluating'!

value: anObject
	self subclassResponsibility
! !

!MACondition methodsFor:'operators'!

& aCondition 
	^ MAConjunctiveCondition new & self & aCondition
!

not
	^ MANegationCondition with: self
!

| aCondition 
	^ (self not & aCondition not) not
! !

!MACondition class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MACondition.st,v 1.2 2009-07-30 08:00:41 cg Exp $'
! !
