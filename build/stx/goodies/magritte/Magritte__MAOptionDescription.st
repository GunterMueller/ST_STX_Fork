"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAReferenceDescription subclass:#MAOptionDescription
	instanceVariableNames:'options'
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MAOptionDescription comment:'I am an abstract description of different options the user can choose from. My instance variable ==options== references the options I am representing. The options can be sorted or unsorted.'
!


!MAOptionDescription class methodsFor:'accessing-defaults'!

defaultOptions
	^ OrderedCollection new
!

defaultSorted
	^ false
! !

!MAOptionDescription class methodsFor:'accessing-description'!

descriptionDefault
	^ nil
!

descriptionOptions
	^ MAMemoDescription new
		accessor: #optionsTextual;
		label: 'Options';
		priority: 410;
		default: self defaultOptions;
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

!MAOptionDescription methodsFor:'accessing'!

options
	^ options ifNil: [ options := self class defaultOptions ]
!

options: anArray
	options := anArray
!

optionsAndLabels: aCollection
	"Set the options to be the keys of aCollection and the labels to be the values of aCollection."

	self options: (aCollection collect: [ :assoc | assoc key ]).
	self propertyAt: #labels put: (aCollection
		inject: IdentityDictionary new
		into: [ :result :assoc | result add: assoc; yourself ])
! !

!MAOptionDescription methodsFor:'accessing-dynamic'!

allOptions
	^ self prepareOptions: self options copy
!

allOptionsWith: anObject
	^ self prepareOptions: ((self shouldNotInclude: anObject)
		ifFalse: [ self options copyWith: anObject ]
		ifTrue: [ self options copy ])
!

shouldNotInclude: anObject
	^ anObject isNil or: [ self options includes: anObject ]
! !

!MAOptionDescription methodsFor:'accessing-properties'!

sorted
	^ self propertyAt: #sorted ifAbsent: [ self class defaultSorted ]
!

sorted: aBoolean
	self propertyAt: #sorted put: aBoolean
!

undefined: aString
	super undefined: aString.
	self reference isNil
		ifFalse: [ self reference undefined: aString ]
! !

!MAOptionDescription methodsFor:'accessing-textual'!

optionsTextual
	^ (self reference toStringCollection: self options)
		asMultilineString
!

optionsTextual: aString
	| lines |
	lines := (aString ifNil: [ String new ]) lines.
	^ self options: (self reference fromStringCollection: lines)
! !

!MAOptionDescription methodsFor:'actions'!

beSorted
	self sorted: true
!

beUnsorted
	self sorted: false
! !

!MAOptionDescription methodsFor:'copying'!

postCopy
	super postCopy.
	options := options copy
! !

!MAOptionDescription methodsFor:'private'!

labelForOption: anObject
	self propertyAt: #labels ifPresent: [ :labels |
		labels at: anObject ifPresent: [ :value |
			^ value ] ].
	^ self reference toString: anObject
!

prepareOptions: aCollection
        self isSorted
                ifFalse: [ ^ aCollection asArray ]
                ifTrue: [ 
                        ^ aCollection asArray
                                sort: self sortBlock;
                                yourself ]
!

sortBlock
	^ [ :a :b | (self reference toString: a) caseInsensitiveLessOrEqual: (self reference toString: b) ]
! !

!MAOptionDescription methodsFor:'testing'!

isSorted
	^ self sorted
! !

!MAOptionDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitOptionDescription: self
! !

!MAOptionDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MAOptionDescription.st,v 1.2 2009-07-29 15:05:50 cg Exp $'
! !
