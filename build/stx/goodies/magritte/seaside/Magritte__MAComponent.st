"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

WAComponent subclass:#MAComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Core'
!


!MAComponent class methodsFor:'accessing'!

description
	^ MADescriptionBuilder for: self
! !

!MAComponent class methodsFor:'instance-creation'!

new
	"Create a new instance of the receiving component class and checks if it is not abstract."

	self isAbstract
		ifTrue: [ self error: self name , ' is abstract.' ].
	^ super new
! !

!MAComponent class methodsFor:'reflection'!

withAllConcreteClasses
	^ Array streamContents: [ :stream |
		self withAllConcreteClassesDo: [ :each |
			stream nextPut: each ] ]
!

withAllConcreteClassesDo: aBlock
	self withAllSubclassesDo: [ :each |
		each isAbstract ifFalse: [
			aBlock value: each ] ]
! !

!MAComponent class methodsFor:'testing'!

isAbstract
	^ true
! !

!MAComponent methodsFor:'accessing'!

ajaxId
	^ self ajaxId: String new
!

ajaxId: aSymbol
	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'ajax';
			nextPutAll: self class name;
			print: self hash;
			nextPutAll: aSymbol ]
! !

!MAComponent methodsFor:'private'!

readObject: anObject using: aDescription
	| obj retry |
	retry := false.
	obj := [ anObject readUsing: aDescription ]
			on: ErrCantBecomeSelfOnStack
			do: [:ex |
				retry := true.
				ex return ].
	retry ifTrue: [
		obj := aDescription accessor read: anObject ].
	^obj
! !

!MAComponent methodsFor:'testing'!

isMultipart
	^ self children anySatisfy: [ :each | each isMultipart ]
! !

!MAComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAComponent.st,v 1.2 2009-08-14 20:28:01 cg Exp $'
! !
