"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAComponent subclass:#MADescriptionComponent
	instanceVariableNames:'memento description parent'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MADescriptionComponent comment:'I''m a seaside object which provides all the functions for my subclasses to display MADescription subclasses.'
!


!MADescriptionComponent class methodsFor:'instance creation'!

memento: aMemento
	^ self memento: aMemento description: aMemento description
!

memento: aMemento description: aDescription
	^ self memento: aMemento description: aDescription parent: nil
!

memento: aMemento description: aDescription parent: aComponent
	^ self new
		setMemento: aMemento;
		setDescription: aDescription;
		setParent: aComponent;
		yourself
! !

!MADescriptionComponent methodsFor:'accessing'!

attributes
	self deprecatedApi: '#attributes is not supported anymore.'.
	^ WAHtmlAttributes new
!

description
	^ description
!

labelId
	"Accessor that returns the an id that can be reference by a <label>-tag."

	^ self ajaxId: 'label'
!

memento
	^ memento
!

parent
	^ parent
! !

!MADescriptionComponent methodsFor:'accessing-dynamic'!

id
	^ self class name asLowercase , self hash asString
!

model
	^ self memento model
!

root
	^ self isRoot
		ifTrue: [ self ]
		ifFalse: [ self parent root ]
! !

!MADescriptionComponent methodsFor:'initialization'!

setDescription: aDescription
	description := aDescription
!

setMemento: aMemento
	memento := aMemento
!

setParent: aComponent
	parent := aComponent
! !

!MADescriptionComponent methodsFor:'private'!

doValidate
	"Enables components to raise errors when the model is validated."
! !

!MADescriptionComponent methodsFor:'testing'!

isReadonly
	^ self description isReadonly
		or: [ self isRoot not
		and: [ self parent isReadonly ] ]
!

isRoot
	^ self parent isNil
! !

!MADescriptionComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MADescriptionComponent.st,v 1.2 2009-08-14 20:25:49 cg Exp $'
! !
