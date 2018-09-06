"{ Package: 'stx:goodies/magritte/morph' }"

"{ NameSpace: Magritte }"

MAListMorph subclass:#MAMultiSelectListMorph
	instanceVariableNames:'selected'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Morph-Model'
!


!MAMultiSelectListMorph methodsFor:'accessing'!

selected
	^ selected ifNil: [ selected := 0 ]
!

selected: anInteger
	selected := anInteger.
	self changed: #selected
!

selectionAt: anInteger
	^ self value includes: (self options at: anInteger)
!

selectionAt: anInteger put: aBoolean
	| option |
	option := self options at: anInteger.
	self value: (aBoolean
		ifTrue: [ self value copyWith: option ]
		ifFalse: [ self value copyWithout: option ]).
	self changed: #selected
! !

!MAMultiSelectListMorph methodsFor:'private'!

buildMorphEditor
	^ (PluggableListMorphOfMany on: self list: #strings primarySelection: #selected changePrimarySelection: #selected: listSelection: #selectionAt: changeListSelection: #selectionAt:put: menu: nil)
		hResizing: #spaceFill;
		borderColor: #inset;
		borderWidth: 1;
		yourself
! !

!MAMultiSelectListMorph class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/morph/Magritte__MAMultiSelectListMorph.st,v 1.1 2009-07-29 17:55:51 cg Exp $'
! !
