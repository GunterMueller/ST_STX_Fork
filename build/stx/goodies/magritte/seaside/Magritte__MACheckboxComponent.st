"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MACheckboxComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MACheckboxComponent comment:'I''m a seaside component used to display MABooleanDescription. If I''m writeable (readonly property of my description to false) I display a checkbox otherwise, I display a string: ''yes'' if true, ''no'' if false'', '''' if nil.'
!


!MACheckboxComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MACheckboxComponent methodsFor:'rendering'!

renderEditorOn: html
	html label: [
		html checkbox
			id: self labelId;
			disabled: self isReadonly;
			on: #value of: self.
		html space; render: self description checkboxLabel ]
! !

!MACheckboxComponent methodsFor:'testing'!

hasLabelId
	^ true
! !

!MACheckboxComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MACheckboxComponent.st,v 1.2 2009-08-14 20:26:05 cg Exp $'
! !
