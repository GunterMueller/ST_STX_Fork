"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAOptionComponent subclass:#MAMultipleSelectionComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MAMultipleSelectionComponent comment:'I provide basic functionalities for MAListCompositionComponent and MACheckboxGroupComponent.'
!


!MAMultipleSelectionComponent methodsFor:'accessing'!

availableList
	^ self description allOptions
!

selectedList
	^ self value
!

value
	^ super value ifNil: [ self value: Array new. super value ]
! !

!MAMultipleSelectionComponent methodsFor:'actions'!

add: anObject
	(self isDistinct and: [ self value includes: anObject ])
		ifFalse: [ self value: (self value copyWith: anObject) ]
!

clear
	self value: self value copyEmpty
!

remove: anObject
	self value: (self isDistinct
		ifTrue: [ self value copyWithout: anObject ]
		ifFalse: [ self value copyWithoutFirst: anObject ])
! !

!MAMultipleSelectionComponent methodsFor:'rendering'!

renderViewerOn: html
	html unorderedList
		id: self labelId;
		list: self selectedList;
		labels: [ :each | self labelForOption: each ]
! !

!MAMultipleSelectionComponent methodsFor:'testing'!

hasLabelId
	^ true
!

isDistinct
	^ self description isDistinct
!

isOrdered
	^ self description isOrdered
		and: [ (self value respondsTo: #moveUp:)
		and: [ self value respondsTo: #moveDown: ] ]
! !

!MAMultipleSelectionComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAMultipleSelectionComponent.st,v 1.2 2009-08-14 20:27:08 cg Exp $'
! !
