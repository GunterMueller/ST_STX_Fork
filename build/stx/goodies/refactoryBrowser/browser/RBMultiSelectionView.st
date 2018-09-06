"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

MultiSelectionSequenceView subclass:#RBMultiSelectionView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!


!RBMultiSelectionView methodsFor:'private'!

retractSelectionIndex: anIndex 
	self selectionChannel removeDependent: self.
	super retractSelectionIndex: anIndex.
	self selectionChannel addDependent: self
!

useSweepSelectionIndex: anIndex 
	| save list newList |
	lastSelectionIndex = self zeroIndex ifTrue: 
			[self retractAllSelections.
			^self].
	save := lastSelectionIndex.
	list := self selections copy.
	newList := save to: anIndex by: (save < anIndex ifTrue: [1] ifFalse: [-1]).
	selectionIndex := self zeroIndex.
	list do: 
			[:i | 
			(newList includes: i) ifFalse: 
					[selections remove: i ifAbsent: [].
					self invalidateElementIndex: i]].
	newList do: 
			[:i | 
			(list includes: i) ifFalse: 
					[selections add: i.
					self invalidateElementIndex: i]].
	lastSelectionIndex := save.
	self selectionChannel value: selections
! !

!RBMultiSelectionView methodsFor:'updating'!

updateSelectionChannel
	| indx range |
	range := self visibleIntervalForBounds: self bounds.
	indx := self selectionChannel value detect: [:each | true] ifNone: [self zeroIndex].
	((self selectionChannel value
		contains: [:each | each between: range first and: range last])
			or: [indx = self zeroIndex]) ifFalse: [self makeVisible: indx].
	super updateSelectionChannel
! !

!RBMultiSelectionView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/RBMultiSelectionView.st,v 1.8 2003-10-02 17:39:55 cg Exp $'
! !
