"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAElementDescription subclass:#MAReferenceDescription
	instanceVariableNames:'reference'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAReferenceDescription comment:'I am an abstract superclass for descriptions holding onto another description.
'
!


!MAReferenceDescription class methodsFor:'accessing-defaults'!

defaultReference
	^ MAStringDescription new
! !

!MAReferenceDescription class methodsFor:'accessing-description'!

descriptionReference
	^ MAToOneRelationDescription new
		accessor: #reference;
		classes: [ MADescription withAllConcreteClasses ] asDynamicObject;
		label: 'Description';
		priority: 400;
		beRequired;
		yourself
! !

!MAReferenceDescription methodsFor:'accessing'!

reference
	^ reference ifNil: [ reference := self class defaultReference ]
!

reference: aDescription
	reference := aDescription
! !

!MAReferenceDescription methodsFor:'copying'!

postCopy
	super postCopy.
	reference := reference copy
! !

!MAReferenceDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitReferenceDescription: self
! !

!MAReferenceDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAReferenceDescription.st,v 1.1 2009-07-29 14:54:00 cg Exp $'
! !
