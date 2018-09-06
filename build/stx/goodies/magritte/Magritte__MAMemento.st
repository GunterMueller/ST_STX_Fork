"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAObject subclass:#MAMemento
	instanceVariableNames:'model description'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Memento'
!

MAMemento comment:'I am an abstract memento. I reference a model I am working on and the description currently used to describe this model.'
!


!MAMemento class methodsFor:'instance creation'!

model: aModel
	^ self model: aModel description: aModel description
!

model: aModel description: aDescription
	^ self new
		setModel: aModel;
		setDescription: aDescription;
		reset; yourself
! !

!MAMemento methodsFor:'accessing'!

description
	^ description
!

model
	^ model
! !

!MAMemento methodsFor:'actions'!

commit
	"Commit the receiver into the model."
!

reset
	"Reset the memento from the model."
!

validate
	"Check if the data in the receiver would be valid if committed. In case of problems an exception is raised."

	self description validate: self
! !

!MAMemento methodsFor:'initialization'!

setDescription: aDescription
	description := aDescription
!

setModel: aModel
	model := aModel
! !

!MAMemento methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream nextPutAll: ' model: '; print: self model
! !

!MAMemento methodsFor:'private'!

isDifferent: firstDictionary to: secondDictionary
	| firstValue secondValue |
	self description do: [ :each |
		(each isVisible and: [ each isReadonly not ]) ifTrue: [
			firstValue := firstDictionary at: each ifAbsent: [ nil ].
			secondValue := secondDictionary at: each ifAbsent: [ nil ].
			firstValue = secondValue ifFalse: [ ^ true ] ] ].
	^ false
!

pull
	"Utility method to pull the model into a dictionary mapping descriptions to values. nil values are replaced with the default ones of the model."

	| result |
	result := self pullRaw.
	result keysAndValuesDo: [ :key :value |
		value isNil
			ifTrue: [ result at: key put: key default yourself ] ].
	^ result
!

pullRaw
	| result |
	result := Dictionary new.
	self description do: [ :each |
		result at: each put: (self model
			readUsing: each) ].
	^ result
!

push: aDictionary
	"Utility method to push a dictionary mapping descriptions to values into the model."

	aDictionary keysAndValuesDo: [ :key :value |
		(key isVisible and: [ key isReadonly not ]) 
			ifTrue: [ self model write: value using: key ] ]
! !

!MAMemento class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAMemento.st,v 1.1 2009-07-29 14:52:06 cg Exp $'
! !
