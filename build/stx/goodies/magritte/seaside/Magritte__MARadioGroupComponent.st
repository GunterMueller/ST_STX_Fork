"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MASingleSelectionComponent subclass:#MARadioGroupComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MARadioGroupComponent comment:'I display a set of radio buttons to render MASingleSelectionDescription.'
!


!MARadioGroupComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MARadioGroupComponent methodsFor:'private'!

optionId: anInteger
	^self ajaxId: 'option', anInteger displayString
!

optionsWithIndexDo: elementAndIndexBlock separatedBy: separatorBlock
	| index |
	index := 1.
	self options
		do: [ :each |
			elementAndIndexBlock value: each value: index.
			index := index + 1 ]
		separatedBy: separatorBlock
! !

!MARadioGroupComponent methodsFor:'rendering'!

renderEditorOn: html
	| group |
	group := html radioGroup.
	html span
		id: self labelId;
		with: [
			self
				optionsWithIndexDo: [ :each :index |
					self
						renderOption: each
						index: index
						in: group
						on: html ]
				separatedBy: [ html break ] ]
!

renderOption: anObject index: anInteger in: aRadioGroup on: html
	| optionId |
	optionId := self optionId: anInteger.
	html radioButton
		id: optionId;
		group: aRadioGroup;
		selected: self value = anObject;
		callback: [ self value: anObject ].
	html space.
	html label
		for: optionId;
		with: (self labelForOption: anObject)
! !

!MARadioGroupComponent methodsFor:'testing'!

hasLabelId
	^ self isReadonly not
! !

!MARadioGroupComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MARadioGroupComponent.st,v 1.2 2009-08-14 20:25:21 cg Exp $'
! !
