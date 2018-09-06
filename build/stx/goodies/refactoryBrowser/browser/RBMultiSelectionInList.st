"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

MultiSelectionInList subclass:#RBMultiSelectionInList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!


!RBMultiSelectionInList methodsFor:'accessing'!

zeroIndex
	^self newSelections
! !

!RBMultiSelectionInList methodsFor:'initialize-release'!

initialize
	super initialize.
	self selectionIndexHolder: self newSelections asValue
! !

!RBMultiSelectionInList methodsFor:'private'!

newSelections
	^self selectionClass new
!

selectionClass
	^OrderedCollection
! !

!RBMultiSelectionInList methodsFor:'selections in list'!

selections
	| list oc |
	oc := OrderedCollection new.
	list := listHolder value.
	selectionIndexHolder value
		do: [:i | (i between: 1 and: list size) ifTrue: [oc add: (list at: i)]].
	^oc
!

selections: aCollection 
	| s l index |
	s := self newSelections.
	l := listHolder value.
	aCollection do: 
			[:val | 
			((index := l indexOf: val ifAbsent: []) notNil and: [(s includes: index) not])
				ifTrue: [s add: index]].
	self selectionIndexes: s
! !

!RBMultiSelectionInList methodsFor:'updating'!

update: anAspectd with: aParameter from: anObject 
	anObject == selectionIndexHolder ifTrue: [^self changed: #selectionIndex].
	anObject == listHolder ifFalse: [^self].
	selectionIndexHolder setValue: self newSelections.
	self changed: #list.
	selectionIndexHolder changed: #value
! !

!RBMultiSelectionInList methodsFor:'utility'!

clearAll
	selectionIndexHolder value: self newSelections
!

selectAll
	selectionIndexHolder
		value: (self selectionClass withAll: (1 to: listHolder value size))
! !

!RBMultiSelectionInList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/RBMultiSelectionInList.st,v 1.6 2003-10-02 17:39:55 cg Exp $'
! !
