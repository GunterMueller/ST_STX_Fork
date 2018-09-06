"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAMultipleSelectionComponent subclass:#MAListCompositonComponent
	instanceVariableNames:'availableSelected selectedSelected'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MAListCompositonComponent comment:'I''m, like MACheckboxComponent, a seaside component for MAMultipleSelectionDescription. I display two lists. In the first, all available options, in the other, what the user selected. 2 buttons in between to add and remove elements to/from the selected list. If the everything property is set, I display two more buttons to allow the user to add or remove all options in one click.'
!


!MAListCompositonComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAListCompositonComponent methodsFor:'accessing'!

availableList
	^ self description isDistinct
		ifFalse: [ super availableList ]
		ifTrue: [ super availableList copyWithoutAll: self selectedList ]
! !

!MAListCompositonComponent methodsFor:'accessing-properties'!

availableSelected
	^ availableSelected
!

availableSelected: anObject
	availableSelected := anObject
!

selectedSelected
	^ selectedSelected
!

selectedSelected: anObject
	selectedSelected := anObject
! !

!MAListCompositonComponent methodsFor:'actions'!

add
	| added |
	self availableSelected isNil
		ifTrue: [ ^ self ].
	added := (self availableSelected copy).
	self add: added.
	self selectedSelected: added.
	self description isDistinct
		ifTrue: [ self availableSelected: nil ]
!

moveDown
	self selectedSelected isNil
		ifFalse: [ self selectedList moveDown: self selectedSelected ]
!

moveUp
	self selectedSelected isNil
		ifFalse: [ self selectedList moveUp: self selectedSelected ]
!

remove
	self selectedSelected isNil
		ifTrue: [ ^ self ].
	self remove: self selectedSelected.
	self availableSelected: self selectedSelected.
	self selectedSelected: nil
! !

!MAListCompositonComponent methodsFor:'rendering'!

renderEditorOn: html 
	html table id: self labelId; with: [
		html tableRow: [
			html tableData: [ self renderEditorAvailableOn: html ].
			html tableData 
				style: 'vertical-align: center';
				with: [ self renderEditorButtonAddOn: html ].
			html tableData: [ self renderEditorSelectedOn: html ].
			self isOrdered ifTrue: [
				html tableData 
					style: 'vertical-align: center';
					with: [ self renderEditorButtonOrderOn: html ] ] ] ]
! !

!MAListCompositonComponent methodsFor:'rendering-buttons'!

renderEditorButtonAddOn: html
	html submitButton
		callback: [ self add ];
		text: '>>'.
	html break.
	html submitButton
		callback: [ self remove ];
		text: '<<'
!

renderEditorButtonOrderOn: html
	html submitButton
		callback: [ self moveUp ];
		text: 'up'.
	html break.
	html submitButton
		callback: [ self moveDown ];
		text: 'down'
! !

!MAListCompositonComponent methodsFor:'rendering-parts'!

renderEditorAvailableOn: html
	html select
		size: 6; 
		style: 'width: 150px';
		list: self availableList;
		selected: self availableSelected;
		callback: [ :value | self availableSelected: value ];
		labels: [ :value | self labelForOption: value ]
!

renderEditorSelectedOn: html
	html select
		size: 6; 
		style: 'width: 150px';
		list: self selectedList;
		selected: self selectedSelected;
		callback: [ :value | self selectedSelected: value ];
		labels: [ :value | self labelForOption: value ]
! !

!MAListCompositonComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAListCompositonComponent.st,v 1.2 2009-08-14 20:25:33 cg Exp $'
! !
