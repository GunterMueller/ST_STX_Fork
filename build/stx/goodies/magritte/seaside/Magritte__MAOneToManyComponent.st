"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MARelationComponent subclass:#MAOneToManyComponent
	instanceVariableNames:'report commands'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAOneToManyComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAOneToManyComponent methodsFor:'accessing'!

children
	^ Array with: self report
!

commands
	^ commands ifNil: [ commands := self buildCommands ]
!

report
	^ report ifNil: [ report := self buildReport ]
! !

!MAOneToManyComponent methodsFor:'actions'!

add
	| result |
	result := self selected new.
	result := self root call: (result asComponent
		addMessage: 'Add ' , self selected label;
		addValidatedForm;
		yourself).
	result isNil
		ifFalse: [ self value: (self value copyWith: result); refresh ]
!

down: anElement
	self value moveDown: anElement
!

edit: anObject
	self root call: (anObject asComponent
		addMessage: 'Edit ' , self selected label;
		addValidatedForm;
		yourself).
	self refresh
!

refresh
	self report rows: self value
!

remove: anObject
	self value: (self value copyWithout: anObject).
	self refresh
!

up: anElement
	self value moveUp: anElement
! !

!MAOneToManyComponent methodsFor:'private'!

buildCommands
	commands := MACommandColumn new setReport: self report.
	self description isDefinitive ifFalse: [
		commands
			addCommandOn: self selector: #edit: text: 'edit';
			addCommandOn: self selector: #remove: text: 'remove' ].
	self description isOrdered ifTrue: [
		commands
			addCommandOn: self selector: #up: text: 'up';
			addCommandOn: self selector: #down: text: 'down' ].
	^ commands
!

buildReport
	^ (MAReport rows: self value description: self reference)
		sortEnabled: self description isOrdered not;
		yourself
! !

!MAOneToManyComponent methodsFor:'rendering'!

renderEditorOn: html
	self renderViewerOn: html.
	self description isDefinitive
		ifFalse: [ self renderSelectListOn: html ]
!

renderViewerOn: html
	| columns |
	columns := self report columns
		copyWithout: self commands.
	self report columns: (self isReadonly
		ifFalse: [ columns copyWith: self commands ]
		ifTrue: [ columns ]).
	html render: self report
! !

!MAOneToManyComponent methodsFor:'rendering-buttons'!

renderSelectButtonOn: html
	html submitButton on: #add of: self
! !

!MAOneToManyComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAOneToManyComponent.st,v 1.2 2009-08-14 20:25:40 cg Exp $'
! !
