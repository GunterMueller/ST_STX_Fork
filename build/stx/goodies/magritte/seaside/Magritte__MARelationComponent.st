"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAElementComponent subclass:#MARelationComponent
	instanceVariableNames:'selected'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MARelationComponent methodsFor:'accessing'!

selected
	^ selected ifNil: [ selected := self classes first ]
!

selected: aClass
	selected := aClass
! !

!MARelationComponent methodsFor:'accessing-dynamic'!

classes
	^ self description classes
! !

!MARelationComponent methodsFor:'private'!

editorFor: anObject
	^ (self description reference asComponentOn: anObject)
		addValidatedForm;
		yourself
! !

!MARelationComponent methodsFor:'rendering-tools'!

renderSelectButtonOn: html
	self subclassResponsibility
!

renderSelectListOn: html
	self classes size > 1 ifTrue: [
		html select
			list: self classes;
			selected: self selected;
			callback: [ :value | self selected: value ];
			labels: [ :value | value label ] ].
	self classes notEmpty
		ifTrue: [ self renderSelectButtonOn: html ]
! !

!MARelationComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MARelationComponent.st,v 1.2 2009-08-14 20:25:53 cg Exp $'
! !
