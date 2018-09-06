"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAMultipleSelectionComponent subclass:#MACheckboxGroupComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MACheckboxGroupComponent comment:'Use for MAMultipleSelectionComponent. I display as many checkboxes as my description has options. Another representation for the same description is MAListCompositionComponent.'
!


!MACheckboxGroupComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MACheckboxGroupComponent methodsFor:'private'!

optionId: anInteger
	^self ajaxId: 'option', anInteger displayString
!

optionsWithIndexDo: elementAndIndexBlock separatedBy: separatorBlock
	| index |
	index := 1.
	self description allOptions
		do: [ :each |
			elementAndIndexBlock value: each value: index.
			index := index + 1 ]
		separatedBy: separatorBlock
! !

!MACheckboxGroupComponent methodsFor:'rendering'!

renderEditorOn: html
	html hiddenInput 
		callback: [ :value | self clear ].
	self
		optionsWithIndexDo: [ :each :index |
			| optionId |
			optionId := self optionId: index.
			html checkbox
				id: optionId;
				value: (self selectedList includes: each);
				onTrue: [ self add: each ] 
				onFalse: [ self remove: each ].
			html space.
			html label
				for: optionId;
				with: (self labelForOption: each) ]
		separatedBy: [ html break ]
! !

!MACheckboxGroupComponent methodsFor:'testing'!

hasLabelId
	^ self isReadonly
!

isDistinct
	^ true
! !

!MACheckboxGroupComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MACheckboxGroupComponent.st,v 1.2 2009-08-14 20:25:24 cg Exp $'
! !
