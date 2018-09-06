"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MADescriptionComponent subclass:#MAElementComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!

MAElementComponent comment:'I provide a basic display for all subclasses of MAElementDescription (only for readonly descriptions). The object is just displayed as a string. For more complex behaviour, overried #renderViewerOn:. '
!


!MAElementComponent methodsFor:'accessing'!

reference
	^ self description reference
! !

!MAElementComponent methodsFor:'accessing-model'!

string
	^ self value isString
		ifTrue: [ self value ]
		ifFalse: [ self description toString: self value ]
!

string: aString
	| value |
	value := [ self description fromString: aString ]
		ifError: [ aString ].
	self value: value
!

value
	^ self memento readUsing: self description
!

value: anObject
	self memento write: anObject using: self description
! !

!MAElementComponent methodsFor:'calling'!

chooser: aComponent
	self chooser: aComponent titled: 'Edit ' , self description label
!

chooser: aComponent titled: aString
	| result |
	result := self root call: (aComponent
		addMessage: aString;
		yourself).
	result isNil
		ifFalse: [ self value: result ]
! !

!MAElementComponent methodsFor:'rendering'!

renderContentOn: html
	self isReadonly
		ifTrue: [ self renderViewerOn: html ]
		ifFalse: [ self renderEditorOn: html ]
!

renderEditorOn: html
	self renderViewerOn: html
!

renderViewerOn: html
	html render: self string
! !

!MAElementComponent methodsFor:'testing'!

hasLabelId
	"Return whether somewhere an element is rendered with the id ==labelId== that can be reference by a <label>-tag."

	^ false
! !

!MAElementComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAElementComponent.st,v 1.2 2009-08-14 20:26:29 cg Exp $'
! !
