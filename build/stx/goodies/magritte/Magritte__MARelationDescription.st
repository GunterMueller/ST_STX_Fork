"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAReferenceDescription subclass:#MARelationDescription
	instanceVariableNames:'classes'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MARelationDescription comment:'I am an abstract description for descriptions representing a relation. My instance variable ==classes== references a collection of possible classes that I can relate to. If required the reference description will be automatically built from this list of classes.'
!


!MARelationDescription class methodsFor:'accessing-defaults'!

defaultClasses
	^ Set new
!

defaultReference
	^ nil
! !

!MARelationDescription class methodsFor:'accessing-description'!

descriptionClasses
	^ MAMultipleOptionDescription new
		accessor: #classes;
		label: 'Classes';
		priority: 400;
		options: [ Smalltalk allClasses ] asDynamicObject;
		reference: MAClassDescription new;
		yourself
!

descriptionReference
	^ super descriptionReference
		classes: [ MAContainer withAllConcreteClasses ] asDynamicObject;
		beOptional;
		yourself
! !

!MARelationDescription methodsFor:'accessing'!

classes
	^ classes ifNil: [ classes := self class defaultClasses ]
!

classes: aCollection
	classes := aCollection
! !

!MARelationDescription methodsFor:'accessing-dynamic'!

allClasses
	^ (Array withAll: self classes)
		sort: [ :a :b | a label caseInsensitiveLessOrEqual: b label ];
		yourself
!

commonClass
	"Answer a common superclass of the classes of the receiver. The algorithm is implemented to be as efficient as possible. The inner loop will be only executed the first few iterations."

	| current |
	self classes isEmpty
		ifTrue: [ ^ self class descriptionContainer ].
	current := self classes anyOne.
	self classes do: [ :each |
		[ each includesBehavior: current ]
			whileFalse: [ current := current superclass ] ].
	^ current
!

reference
	"The reference within a ==*MARelationDescription*== is calculated automatically from all the classes of the receiver, if set to ==nil==. By setting the reference to a ==*MAContainer*== instance it is possible to customize the reference description."

	^ super reference ifNil: [ self commonClass description ]
! !

!MARelationDescription methodsFor:'copying'!

postCopy
	super postCopy.
	classes := classes copy
! !

!MARelationDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitRelationDescription: self
! !

!MARelationDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MARelationDescription.st,v 1.1 2009-07-29 14:50:34 cg Exp $'
! !
