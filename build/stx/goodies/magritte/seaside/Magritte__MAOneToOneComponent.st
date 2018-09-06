"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MARelationComponent subclass:#MAOneToOneComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAOneToOneComponent methodsFor:'actions'!

create
	self subclassResponsibility
!

remove
	self value: nil
! !

!MAOneToOneComponent methodsFor:'rendering'!

renderButtonsOn: html
!

renderEditorOn: html
	self value isNil
		ifTrue: [ self renderSelectListOn: html ]
		ifFalse: [ self renderViewerOn: html; renderButtonsOn: html ]
! !

!MAOneToOneComponent methodsFor:'rendering-tools'!

renderSelectButtonOn: html
	html submitButton on: #create of: self
! !

!MAOneToOneComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAOneToOneComponent.st,v 1.2 2009-08-14 20:26:57 cg Exp $'
! !
