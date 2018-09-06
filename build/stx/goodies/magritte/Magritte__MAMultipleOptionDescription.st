"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAOptionDescription subclass:#MAMultipleOptionDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAMultipleOptionDescription comment:'I am a description of multiple options, possible options are stored within the ==options== field, possible values are instances of ==Collection==. My visual representation could be a multi-select list or a group of check-boxes.'
!




!MAMultipleOptionDescription class methodsFor:'accessing'!

label
	^ 'Multiple-Option'
! !

!MAMultipleOptionDescription class methodsFor:'accessing-defaults'!

defaultDistinct
	^ false
!

defaultOrdered
	^ false
! !

!MAMultipleOptionDescription class methodsFor:'accessing-description'!

descriptionDistinct
	^ MABooleanDescription new
		accessor: #distinct;
		label: 'Distinct';
		priority: 250;
		default: self defaultDistinct;
		yourself
!

descriptionOrdered
	^ MABooleanDescription new
		accessor: #ordered;
		label: 'Ordered';
		priority: 260;
		default: self defaultOrdered;
		yourself
! !

!MAMultipleOptionDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MAMultipleOptionDescription methodsFor:'accessing'!

kind
	^ Collection
! !

!MAMultipleOptionDescription methodsFor:'accessing-properties'!

distinct
	^ self propertyAt: #distinct ifAbsent: [ self class defaultDistinct ]
!

distinct: aBoolean
	self propertyAt: #distinct put: aBoolean
!

ordered
	^ self propertyAt: #ordered ifAbsent: [ self class defaultOrdered ]
!

ordered: aBoolean
	self propertyAt: #ordered put: aBoolean
! !

!MAMultipleOptionDescription methodsFor:'actions'!

beDistinct
	self distinct: true
!

beIndefinite
	self distinct: false
!

beOrdered
	self ordered: true
!

beUnordered
	self ordered: false
! !

!MAMultipleOptionDescription methodsFor:'testing'!

isDistinct
	^ self distinct
!

isOrdered
	^ self ordered
! !

!MAMultipleOptionDescription methodsFor:'validating'!

validateKind: anObject
	super validateKind: anObject.
	(anObject allSatisfy: [ :each | self options includes: each ])
		ifFalse: [ MAKindError description: self signal: self kindErrorMessage ]
!

validateRequired: anObject
	super validateRequired: anObject.
	(self isRequired and: [ anObject isCollection and: [ anObject isEmpty ] ])
		ifTrue: [ MARequiredError description: self signal: self requiredErrorMessage ]
! !

!MAMultipleOptionDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitMultipleOptionDescription: self
! !

!MAMultipleOptionDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAMultipleOptionDescription.st,v 1.4 2009-08-14 20:08:42 cg Exp $'
! !
