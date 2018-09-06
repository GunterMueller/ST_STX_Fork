"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKClassDescriptor
	instanceVariableNames:'class className fields id classInstVarNames'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!


!KKClassDescriptor class methodsFor:'as yet unclassified'!

findClassForName: aClassName

	^KKClassMapper default findClassForName: aClassName
!

forClassNamed: aClassName
	"A (GOODS) class has been loaded from the GOODS server.  Create an instance of myself (or subtype) appropriate for that class.  Populate it with the smalltalk class that it corresponds to."

	|class|
	class := self findClassForName: aClassName.
	^ class goodsDescriptorClass new class: class; className: aClassName
! !

!KKClassDescriptor methodsFor:'accessing'!

class: aClass
	class := aClass.
	classInstVarNames := Dictionary new.
	class allInstVarNames doWithIndex: [:name :index |
		classInstVarNames at: name put: index]
!

className
	^ className
!

className: aName
	className := aName
!

fields
	^ fields ifNil: [fields := OrderedCollection new]
!

id
	^ id
!

id: anID
	id := anID
!

instanceClass
	^ class
! !

!KKClassDescriptor methodsFor:'actions'!

addField: aFieldContainer
	self fields add: aFieldContainer.
	aFieldContainer parent: self.
! !

!KKClassDescriptor methodsFor:'as yet unclassified'!

estimatedSize
	^ self fixedSize + (self varyingSize * 5)
!

fixedRefs
	^ (fields select: [:f | f isVariable not and: [f isReference]]) size
!

fixedSize
    Smalltalk isSmalltalkX ifTrue:[
	^ (self fields reject: [:f | f isVariable]) sum: [:f | f totalSize]
    ] ifFalse:[
	^ (self fields reject: [:f | f isVariable]) detectSum: [:f | f totalSize]
    ].
!

indexOfInstVarNamed: aName
	^classInstVarNames at: aName ifAbsent: [0]
!

newInstanceFromStream: aStream
	^ self instanceClass basicNew
!

objectFromStream: aStream forDatabase: aDatabase
	|obj|
	obj := self newInstanceFromStream: aStream.
	self referenceFieldsFirstDo: [:each | each refreshObject: obj fromStream: aStream forDatabase: aDatabase].
	^ obj
!

referenceFieldsFirst
	^ (self fields select: [:f | f isReference]), (self fields reject: [:f | f isReference])
!

referenceFieldsFirstDo: aBlock
	self fields do: [:ea | ea isReference ifTrue: [aBlock value: ea]].
	self fields do: [:ea | ea isReference ifFalse: [aBlock value: ea]]
!

streamForObject: anObject database: aDatabase
	|stream|
	stream := WriteStream on: (ByteArray new: 16).
	self writeObject: anObject onStream: stream forDatabase: aDatabase.
	^ stream
!

varyingRefs
	^ (fields select: [:f | f isVariable and: [f isReference]]) size
!

varyingSize
    Smalltalk isSmalltalkX ifTrue:[
	^ (fields select: [:f | f isVariable]) sum: [:f | f totalSize]
    ] ifFalse:[
	^ (fields select: [:f | f isVariable]) detectSum: [:f | f totalSize]
    ]
!

writeObject: anObject onStream: aStream forDatabase: aDatabase
	self referenceFieldsFirstDo: [:each | each writeObject: anObject onStream: aStream forDatabase: aDatabase]
! !

!KKClassDescriptor methodsFor:'comparing'!

= another
	^ className = another className and: [fields = another fields]
! !

!KKClassDescriptor methodsFor:'testing'!

hash
	^ className hash + fields hash
! !

!KKClassDescriptor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKClassDescriptor.st,v 1.3 2013-03-28 10:38:49 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKClassDescriptor.st,v 1.3 2013-03-28 10:38:49 cg Exp $'
! !

