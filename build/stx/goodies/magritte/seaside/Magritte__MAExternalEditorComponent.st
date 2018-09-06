"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAOneToOneComponent subclass:#MAExternalEditorComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAExternalEditorComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAExternalEditorComponent methodsFor:'actions'!

create
	self chooser: (self editorFor: self selected new)
!

edit
	self chooser: (self editorFor: self value)
! !

!MAExternalEditorComponent methodsFor:'rendering'!

renderButtonsOn: html
	html submitButton on: #remove of: self.
	html submitButton on: #edit of: self
!

renderViewerOn: html
	html render: (self reference toString: self value)
! !

!MAExternalEditorComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAExternalEditorComponent.st,v 1.2 2009-08-14 20:26:33 cg Exp $'
! !
