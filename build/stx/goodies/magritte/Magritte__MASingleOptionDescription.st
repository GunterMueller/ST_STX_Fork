"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAOptionDescription subclass:#MASingleOptionDescription
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Description'
!

MASingleOptionDescription comment:'I am a description of a single option, possible values are stored within the ==options== field, but I might also be extensible so that the user can add its own option. My visual representation could be a drop-down list or a group of option-buttons.'
!




!MASingleOptionDescription class methodsFor:'accessing'!

label
	^ 'Single-Option'
! !

!MASingleOptionDescription class methodsFor:'accessing-defaults'!

defaultExtensible
	^ false
! !

!MASingleOptionDescription class methodsFor:'accessing-descriptions'!

descriptionExtensible
	^ MABooleanDescription new
		accessor: #extensible;
		label: 'Extensible';
		priority: 250;
		default: self defaultExtensible;
		yourself
!

descriptionGroupBy
	^ MASymbolDescription new
		selectorAccessor: #groupBy;
		label: 'Grouped by';
		priority: 260;
		default: nil;
		yourself
! !

!MASingleOptionDescription class methodsFor:'testing'!

isAbstract
	^ false
! !

!MASingleOptionDescription methodsFor:'accessing-dynamic'!

shouldNotInclude: anObject
	^ self isExtensible not
		or: [ super shouldNotInclude: anObject ]
! !

!MASingleOptionDescription methodsFor:'accessing-properties'!

extensible
	^ self propertyAt: #extensible ifAbsent: [ self class defaultExtensible ]
!

extensible: aBoolean
	self propertyAt: #extensible put: aBoolean
!

groupBy
	^ self propertyAt: #groupBy ifAbsent: [ nil ]
!

groupBy: anAccessor
	"anAccessor to be sent to the options objects for getting their group."
	
	self propertyAt: #groupBy put: anAccessor asAccessor
! !

!MASingleOptionDescription methodsFor:'actions'!

beExtensible
	self extensible: true
!

beLimited
	self extensible: false
! !

!MASingleOptionDescription methodsFor:'private'!

prepareOptions: aCollection
	^ self isRequired
		ifTrue: [ super prepareOptions: aCollection ]
		ifFalse: [
			(super prepareOptions: aCollection)
				copyWithFirst: nil ]
! !

!MASingleOptionDescription methodsFor:'testing'!

isExtensible
	^ self extensible
!

isGrouped
	^ self groupBy notNil
! !

!MASingleOptionDescription methodsFor:'validating'!

validateKind: anObject
	super validateKind: anObject.
	(self isExtensible or: [ self options includes: anObject ])
		ifFalse: [ MAKindError description: self signal: self kindErrorMessage ]
! !

!MASingleOptionDescription methodsFor:'visiting'!

acceptMagritte: aVisitor
	aVisitor visitSingleOptionDescription: self
! !

!MASingleOptionDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MASingleOptionDescription.st,v 1.4 2009-08-14 20:09:12 cg Exp $'
! !
