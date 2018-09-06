"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCDependencySorter
	instanceVariableNames:'required provided orderedItems'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Loading'
!


!MCDependencySorter class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCDependencySorter class methodsFor:'as yet unclassified'!

items: aCollection
	^ self new addAll: aCollection
!

sortItems: aCollection
	| sorter |
	sorter := self items: aCollection.
	sorter externalRequirements do: [:req  | sorter addProvision: req].
	^ sorter orderedItems.
! !

!MCDependencySorter methodsFor:'accessing'!

externalRequirements
	| unloaded providedByUnloaded |
	unloaded := self itemsWithMissingRequirements.
	providedByUnloaded := (unloaded gather: [:e | e provisions]) asSet.
	^ required keys reject: [:ea | providedByUnloaded includes: ea ]
!

itemsWithMissingRequirements
	| items |
	items := Set new.
	required do: [:ea | items addAll: ea].
	^ items

! !

!MCDependencySorter methodsFor:'building'!

add: anItem
	| requirements |
	requirements := self unresolvedRequirementsFor: anItem.
	requirements isEmpty
		ifTrue: [self addToOrder: anItem]
		ifFalse: [self addRequirements: requirements for: anItem]
!

addAll: aCollection
	aCollection asArray sort do: [:ea | self add: ea]
!

addExternalProvisions: aCollection
	(aCollection intersection: self externalRequirements)
		do: [:ea | self addProvision: ea]
! !

!MCDependencySorter methodsFor:'initialization'!

initialize
	super initialize.
	provided := Set new.
	required := Dictionary new.
	orderedItems := OrderedCollection new.
! !

!MCDependencySorter methodsFor:'private'!

addProvision: anObject
	| newlySatisfied |
	provided add: anObject.
	newlySatisfied := required removeKey: anObject ifAbsent: [#()].
	self addAll: newlySatisfied.
!

addRequirement: reqObject for: itemObject
	(self itemsRequiring: reqObject) add: itemObject
!

addRequirements: aCollection for: anObject
	aCollection do: [:ea | self addRequirement: ea for: anObject]
!

addToOrder: anItem
	orderedItems add: anItem.
	anItem provisions do: [:ea | self addProvision: ea].
!

itemsRequiring: anObject
	^ required at: anObject ifAbsentPut: [Set new]
!

unresolvedRequirementsFor: anItem
	^ anItem requirements difference: provided
! !

!MCDependencySorter methodsFor:'sorting'!

orderedItems
	^ orderedItems
! !

!MCDependencySorter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDependencySorter.st,v 1.4 2012-09-11 21:21:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCDependencySorter.st,v 1.4 2012-09-11 21:21:20 cg Exp $'
!

version_SVN
    ^ '§Id: MCDependencySorter.st 7 2010-09-12 07:18:55Z vranyj1 §'
! !
