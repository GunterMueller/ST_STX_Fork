"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAOneToOneComponent subclass:#MAInternalEditorComponent
	instanceVariableNames:'component'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAInternalEditorComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAInternalEditorComponent methodsFor:'accessing'!

children
	^ Array with: self component
!

component
	^ component ifNil: [ component := self buildComponent ]
! !

!MAInternalEditorComponent methodsFor:'actions'!

create
	self value: self selected new.
	component := nil
! !

!MAInternalEditorComponent methodsFor:'private'!

buildComponent
	^ self value isNil ifFalse: [ 
		(self description reference asComponentOn: self value)
			setParent: self;
			yourself ]
! !

!MAInternalEditorComponent methodsFor:'rendering'!

renderEditorOn: html
	super renderEditorOn: html.
	html hiddenInput callback: [ self component commit ]
!

renderViewerOn: html
	html render: (self component
		readonly: self isReadonly;
		yourself)
! !

!MAInternalEditorComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAInternalEditorComponent.st,v 1.2 2009-08-14 20:26:00 cg Exp $'
! !
