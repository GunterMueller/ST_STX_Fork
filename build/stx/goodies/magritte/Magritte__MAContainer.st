"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MADescription subclass:#MAContainer
	instanceVariableNames:'children'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAContainer comment:'I am a container holding a collection of descriptions, all instances of subclasses of *MAElementDescription*. I keep my children within an ==OrderedCollection==, but I don''t sort them according to their priority.
I fully support the collection protocol: descriptions can be added and removed. Moreover I implement most enumeration methods, so that users are able to iterate (==do:==), filter (==select:==, ==reject:==), transform (==collect:==), extract (==detect:==, ==detect:ifNone:==), and test (==allSatisfy:==, ==anySatisfy:==, ==noneSatisfy:==) my elements.'
!


!MAContainer class methodsFor:'instance creation'!

with: aDescription
	^ self new
		add: aDescription;
		yourself
!

withAll: aCollection
	^ self new
		addAll: aCollection;
		yourself
! !


!MAContainer class methodsFor:'*magritte-seaside-defaults'!

defaultComponentRenderer
	^ MATableRenderer
! !

!MAContainer class methodsFor:'accessing-defaults'!

defaultAccessor
	^ MAIdentityAccessor new
!

defaultCollection
	^ OrderedCollection new
! !

!MAContainer class methodsFor:'accessing-description'!

descriptionChildren
	^ MAToManyRelationDescription new
		accessor: (MASelectorAccessor read: #children write: #setChildren:);
		classes: [ MAElementDescription withAllConcreteClasses ] asDynamicObject;
		default: self defaultCollection;
		label: 'Elements';
		priority: 400;
		beOrdered;
		yourself
!

descriptionDefault
	^ nil
! !

!MAContainer class methodsFor:'testing'!

isAbstract
	^ false
! !


!MAContainer methodsFor:'*magritte-seaside-accessing'!

componentRenderer
	^ self propertyAt: #componentRenderer ifAbsent: [ self class defaultComponentRenderer ]
!

componentRenderer: aClass
	self propertyAt: #componentRenderer put: aClass
! !

!MAContainer methodsFor:'*magritte-seaside-converting'!

asComponentOn: anObject
	^ self componentClass
		memento: (anObject mementoClass
			model: anObject
			description: self)
! !

!MAContainer methodsFor:'accessing'!

at: anIndex
	^ self children at: anIndex
!

at: anIndex ifAbsent: aBlock
	^ self children at: anIndex ifAbsent: aBlock
!

children
	^ children
!

size
	^ self children size
! !

!MAContainer methodsFor:'adding'!

add: aDescription
	self children add: aDescription
!

addAll: aCollection
	self children addAll: aCollection
! !

!MAContainer methodsFor:'comparing'!

= anObject
	^ super = anObject
		and: [ self children = anObject children ]
!

hash
	^ super hash bitXor: self children hash
! !

!MAContainer methodsFor:'converting'!

asContainer
	^ self
! !

!MAContainer methodsFor:'copying'!

copyEmpty
	^ self copy
		setChildren: self class defaultCollection;
		yourself
!

copyFrom: aStartIndex to: anEndIndex
	^ self copy
		setChildren: (self children
			copyFrom: aStartIndex
			to: anEndIndex);
		yourself
!

copyWithout: anObject
	^self reject: [:each | each = anObject]
!

copyWithoutAll: aCollection
	^self reject: [:each | aCollection includes: each]
!

postCopy
	super postCopy.
	self setChildren: self children copy
! !

!MAContainer methodsFor:'enumerating'!

allSatisfy: aBlock
	^ self children allSatisfy: aBlock
!

anySatisfy: aBlock
	^ self children anySatisfy: aBlock
!

collect: aBlock
	^ self copy
		setChildren: (self children collect: aBlock);
		yourself
!

detect: aBlock
	^ self children detect: aBlock
!

detect: aBlock ifNone: anExceptionBlock
	^ self children detect: aBlock ifNone: anExceptionBlock
!

do: aBlock
	self children do: aBlock
!

do: aBlock separatedBy: aSeparatorBlock
	self children do: aBlock separatedBy: aSeparatorBlock
!

inject: anObject into: aBlock
	^ self children inject: anObject into: aBlock
!

intersection: aCollection
	^ self copy
		setChildren: (self children intersection: aCollection);
		yourself
!

keysAndValuesDo: aBlock
	self children keysAndValuesDo: aBlock
!

noneSatisfy: aBlock
	^ self children noneSatisfy: aBlock
!

reject: aBlock
	^ self copy
		setChildren: (self children reject: aBlock);
		yourself
!

select: aBlock
	^ self copy
		setChildren: (self children select: aBlock);
		yourself
!

union: aContainer
	^ self copy
		addAll: (aContainer reject: [ :each | self includes: each ]);
		yourself
!

with: aCollection do: aBlock
	self children with: aCollection do: aBlock
! !

!MAContainer methodsFor:'initialization'!

initialize
	super initialize.
	self setChildren: self class defaultCollection
!

setChildren: aCollection
	children := aCollection
! !

!MAContainer methodsFor:'moving'!

moveDown: aDescription
	self children moveDown: aDescription
!

moveUp: aDescription
	self children moveUp: aDescription
! !

!MAContainer methodsFor:'private'!

errorNotFound: aDescription
	self error: aDescription class label , ' not found.'
! !

!MAContainer methodsFor:'removing'!

remove: aDescription
	self children remove: aDescription ifAbsent: [ self errorNotFound: aDescription ]
!

removeAll
	self setChildren: self class defaultCollection
! !

!MAContainer methodsFor:'testing'!

hasChildren
	^ self notEmpty
!

includes: aDescription
	^ self children includes: aDescription
!

isContainer
	^ true
!

isEmpty
	^ self children isEmpty
!

notEmpty
	^ self children notEmpty
! !

!MAContainer methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitContainer: self
! !

!MAContainer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAContainer.st,v 1.5 2009-08-14 20:08:44 cg Exp $'
! !
