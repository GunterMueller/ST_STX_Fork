"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MATextInputComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MATextInputComponent comment:'I''m a simple input box for MAStringDescription.'
!


!MATextInputComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MATextInputComponent methodsFor:'rendering'!

renderButtonOn: html
!

renderEditorOn: html
	self renderInputOn: html.
	self renderButtonOn: html
!

renderInputOn: html
	html textInput
		id: self labelId;
		on: #string of: self
! !

!MATextInputComponent methodsFor:'testing'!

hasLabelId
	^ self isReadonly not
! !

!MATextInputComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MATextInputComponent.st,v 1.2 2009-08-14 20:25:06 cg Exp $'
! !
