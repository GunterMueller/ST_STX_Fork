"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAVisitor subclass:#MAComponentRenderer
	instanceVariableNames:'component html errors group'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Renderer'
!


!MAComponentRenderer class methodsFor:'instance creation'!

component: aComponent on: aRenderer
	^ self new component: aComponent on: aRenderer
! !

!MAComponentRenderer methodsFor:'initilization'!

setComponent: aComponent
	component := aComponent
!

setRenderer: aRenderer
	html := aRenderer
! !

!MAComponentRenderer methodsFor:'private'!

childAt: aDescription
	^ component childAt: aDescription
!

classFor: aDescription
	| classes |
	classes := OrderedCollection withAll: aDescription cssClasses.
	aDescription isReadonly
		ifTrue: [ classes add: 'readonly' ].
	aDescription isRequired
		ifTrue: [ classes add: 'required' ].
	(self hasError: aDescription)
		ifTrue: [ classes add: 'error' ].
	^ classes reduce: [ :a :b | a , ' ' , b ]
! !

!MAComponentRenderer methodsFor:'rendering'!

renderContainer: aDescription
	self visitAll: (aDescription select: [ :each |
		each isVisible
			and: [ each componentClass notNil ] ])
!

renderControl: aDescription
	html render: (self childAt: aDescription)
!

renderElement: aDescription
	aDescription group = group
		ifFalse: [ self renderGroup: aDescription ].
	self renderLabel: aDescription.
	self renderControl: aDescription
!

renderGroup: aDescription
	group := aDescription group
!

renderLabel: aDescription
	| label |
	aDescription hasLabel ifFalse: [ ^ self ].
	label := html label.
	(self childAt: aDescription) hasLabelId
		ifTrue: [ label for: (self childAt: aDescription) labelId ].
	label with: [ html render: aDescription label; text: ':' ]
! !

!MAComponentRenderer methodsFor:'testing'!

hasError: aDescription
	| current |
	errors ifNotNil: [ ^ errors includes: aDescription ].
	errors := IdentitySet new.
	current := component.
	[ current notNil ] whileTrue: [
		current isMagritteContainer ifTrue: [
			current errors do: [ :each |
				errors add: (each tag isDescription
					ifTrue: [ each tag ]
					ifFalse: [ current description ]) ] ].
		current := current parent ].
	^ self hasError: aDescription
! !

!MAComponentRenderer methodsFor:'visiting'!

component: aComponent on: aRenderer
	self setComponent: aComponent; setRenderer: aRenderer.
	self visit: aComponent description
! !

!MAComponentRenderer methodsFor:'visiting-description'!

visitContainer: aDescription
	self renderContainer: aDescription
!

visitElementDescription: aDescription
	self renderElement: aDescription
! !

!MAComponentRenderer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAComponentRenderer.st,v 1.2 2009-08-14 20:29:09 cg Exp $'
! !
