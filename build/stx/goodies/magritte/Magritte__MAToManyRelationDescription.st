"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MARelationDescription subclass:#MAToManyRelationDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAToManyRelationDescription comment:'I am a description of an one-to-many relationship, possible values are instances of ==Collection==.'
!



!MAToManyRelationDescription class methodsFor:'accessing'!

label
	^ '1:m Relation'
! !

!MAToManyRelationDescription class methodsFor:'accessing-defaults'!

defaultDefinitive
	^ false
!

defaultOrdered
	^ false
!

defaultSorted
	^ false
! !

!MAToManyRelationDescription class methodsFor:'accessing-description'!

descriptionDefinitive
	^ MABooleanDescription new
		accessor: #definitive;
		label: 'Definitive';
		priority: 265;
		default: self defaultDefinitive;
		yourself
!

descriptionOrdered
	^ MABooleanDescription new
		accessor: #ordered;
		label: 'Ordered';
		priority: 260;
		default: self defaultOrdered;
		yourself
!

descriptionSorted
	^ MABooleanDescription new
		accessor: #sorted;
		label: 'Sorted';
		priority: 240;
		default: self defaultSorted;
		yourself
! !

!MAToManyRelationDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAToManyRelationDescription methodsFor:'accessing'!

kind
	^ Collection
! !

!MAToManyRelationDescription methodsFor:'accessing-properties'!

definitive
	^ self propertyAt: #definitive ifAbsent: [ self class defaultDefinitive ]
!

definitive: aBoolean
	self propertyAt: #definitive put: aBoolean
!

ordered
	^ self propertyAt: #ordered ifAbsent: [ self class defaultOrdered ]
!

ordered: aBoolean
	self propertyAt: #ordered put: aBoolean
!

sorted
	^ self propertyAt: #sorted ifAbsent: [ self class defaultSorted ]
!

sorted: aBoolean
	self propertyAt: #sorted put: aBoolean
! !

!MAToManyRelationDescription methodsFor:'actions'!

beDefinitive
	self definitive: true
!

beModifiable
	self definitive: false
!

beOrdered
	self ordered: true
!

beSorted
	self sorted: true
!

beUnordered
	self ordered: false
!

beUnsorted
	self sorted: false
! !

!MAToManyRelationDescription methodsFor:'testing'!

isDefinitive
	^ self definitive
!

isOrdered
	^ self ordered
!

isSorted
	^ self sorted
! !

!MAToManyRelationDescription methodsFor:'validating'!

validateKind: anObject
	super validateKind: anObject.
	anObject do: [ :object |
		(self classes anySatisfy: [ :class | object species includesBehavior: class ])
			ifFalse: [ MAKindError description: self signal: self kindErrorMessage ] ]
!

validateRequired: anObject
	super validateRequired: anObject.
	(self isRequired and: [ anObject isCollection and: [ anObject isEmpty ] ])
		ifTrue: [ MARequiredError description: self signal: self requiredErrorMessage ]
! !

!MAToManyRelationDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitToManyRelationDescription: self
! !

!MAToManyRelationDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAToManyRelationDescription.st,v 1.2 2009-08-14 20:05:55 cg Exp $'
! !
