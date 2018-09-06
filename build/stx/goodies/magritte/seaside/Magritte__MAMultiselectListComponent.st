"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAMultipleSelectionComponent subclass:#MAMultiselectListComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAMultiselectListComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAMultiselectListComponent methodsFor:'rendering'!

renderEditorOn: html
	html multiSelect
		size: 8;
		id: self labelId;
		list: self availableList;
		selected: self selectedList;
		labels: [ :value | self labelForOption: value ];
		callback: [ :value | self value: value ]
! !

!MAMultiselectListComponent methodsFor:'testing'!

isDistinct
	^ true
! !

!MAMultiselectListComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAMultiselectListComponent.st,v 1.2 2009-08-14 20:27:04 cg Exp $'
! !
