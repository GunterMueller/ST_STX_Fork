"{ Package: 'stx:goodies/magritte/seaside' }"

"{ NameSpace: Magritte }"

MAOneToManyComponent subclass:#MAOneToManyScalarComponent
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Seaside-Components'
!


!MAOneToManyScalarComponent methodsFor:'actions'!

add
	| holder holderDescription |
	holder := MAValueHolder new.
	holderDescription := self reference copy
		accessor: (MASelectorAccessor selector: #contents);
		yourself.
	holder := self root call: ((holderDescription asContainer asComponentOn: holder)
		addMessage: 'Add ' , self selected label;
		addValidatedForm;
		yourself).
	holder isNil
		ifFalse: [ self value: (self value copyWith: holder contents); refresh ]
!

edit: anObject index: anInteger 
	"sorry, but a collection might include duplicates like #(1 2 1) and you only want to edit the one with the correct index"
	| holder holderDescription |
	holder := MAValueHolder on: anObject.
	holderDescription := self reference copy
		accessor: (MASelectorAccessor selector: #contents);
		yourself.
	holder := self root call: ((holderDescription asContainer asComponentOn: holder)
			addMessage: 'Edit ' , self selected label;
			addValidatedForm;
			yourself).
	holder isNil ifTrue: [ ^ self ].
	self value: (self value isSequenceable 
			ifTrue: 
				[ self copy value
					at: anInteger
						put: holder contents;
					yourself ]
			ifFalse: 
				[ self value copy
					remove: anObject;
					add: holder contents;
					yourself ]).
	self refresh
!

remove: anObject index: anInteger
	"sorry, but a collection might include duplicates like #(1 2 1) and you only want to remove the one with the correct index"
	self value: (self value isSequenceable
		ifTrue: [ self value copyWithoutIndex: anInteger ]
		ifFalse: [ self value copyWithout: anObject ]).
	self refresh
! !

!MAOneToManyScalarComponent methodsFor:'private'!

buildCommands
	commands := MAIndexedCommandColumn new
				setReport: self report.

	self description isDefinitive
		ifFalse: [ commands
					addCommandOn: self selector: #edit:index: text: 'Edit';
					addCommandOn: self selector: #remove:index: text: 'Remove'].
	"not yet implemented
	self description isOrdered
		ifTrue: [ commands
					addCommandOn: self selector: #up:index:;
					addCommandOn: self selector: #down:index: ]. "

	^ commands
!

buildReport
	^ MAReport rows: self value description: self description
! !

!MAOneToManyScalarComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/seaside/Magritte__MAOneToManyScalarComponent.st,v 1.2 2009-08-14 20:25:29 cg Exp $'
! !
