"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MADescriptionComponent subclass:#MAContainerComponent
	instanceVariableNames:'children readonly errors'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAContainerComponent class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAContainerComponent methodsFor:'accessing'!

childAt: aDescription
	^ children at: aDescription ifAbsent: [ nil ]
!

children
	^ children values
!

errors
	"Answer a collection of exceptions, the list of standing errors."

	^ errors
! !

!MAContainerComponent methodsFor:'accessing-properties'!

readonly
	^ readonly ifNil: [ readonly := false ]
!

readonly: aBoolean
	readonly := aBoolean
! !

!MAContainerComponent methodsFor:'actions'!

cancel
	self reset; answer: nil
!

commit
	self withContainersDo: [ :each | each memento commit ]
!

edit
	self readonly: false
!

reset
	self withContainersDo: [ :each | each memento reset ]
!

save
	self validate ifFalse: [ ^ self ].
	self commit; answer: self model
!

validate
	errors := OrderedCollection new.
	[ self withContainersDo: [ :each | each doValidate ] ]
		on: MAError
		do: [ :error |
			errors add: error.
			error isResumable
				ifTrue: [ error resume ] ].
	^ errors isEmpty
! !

!MAContainerComponent methodsFor:'decorating'!

addForm
	self addForm: #( save cancel )
!

addForm: aCollection
	self addDecoration: (MAFormDecoration buttons: aCollection)
!

addSwitch
	self addDecoration: MASwitchDecoration new.
	self readonly: true
!

addValidatedForm
	self addForm; addValidation
!

addValidatedForm: aCollection
	self addForm: aCollection; addValidation
!

addValidatedSwitch
	self addSwitch; addValidation
!

addValidation
	self addDecoration: MAValidationDecoration new
! !

!MAContainerComponent methodsFor:'initialization'!

initialize
	super initialize.
	errors := OrderedCollection new
!

setChildren: aDictionary
	children := aDictionary
!

setDescription: aDescription
	super setDescription: aDescription.
	self setChildren: self buildChildren
! !

!MAContainerComponent methodsFor:'private'!

buildChildren
	^ self description
		inject: Dictionary new
		into: [ :result :each |
			each isVisible ifTrue: [
				result at: each put: (each componentClass
					memento: self memento description: each parent: self) ].
			result ]
!

doValidate
	self memento validate.
	self children do: [ :each | each doValidate ]
!

withContainersDo: aBlock
	"This does a depth first search through all children and evaluates a block for all container components that have their own memento."
	
	self withContainersDo: aBlock in: self
!

withContainersDo: aBlock in: aComponent
	"This does a depth first search through all children and evaluates a block for all container components that have their own memento."
	
	aComponent childrenDo: [ :each |
		self withContainersDo: aBlock in: each ].
	aComponent isMagritteContainer
		ifTrue: [ aBlock value: aComponent ]
! !

!MAContainerComponent methodsFor:'rendering'!

renderContentOn: html
	self description componentRenderer
		component: self on: html
! !

!MAContainerComponent methodsFor:'testing'!

isMagritteContainer
	^ true
!

isReadonly
	^ super isReadonly or: [ self readonly ]
! !

!MAContainerComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAContainerComponent.st,v 1.2 2009-08-14 20:26:37 cg Exp $'
! !
