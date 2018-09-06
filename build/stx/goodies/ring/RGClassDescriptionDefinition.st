"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGBehaviorDefinition subclass:#RGClassDescriptionDefinition
	instanceVariableNames:'instanceVariables organization'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGClassDescriptionDefinition comment:'RGClassDescriptionDefinition is the common parent for classes and metaclasses defining instance variables'
!


!RGClassDescriptionDefinition methodsFor:'accessing'!

instanceVariables

    ^instanceVariables
!

instanceVariables: aCollection

    instanceVariables:= aCollection
!

organization: aClassOrg
    "Install an instance of ClassOrganizer that represents the organization of the messages of the receiver."

    aClassOrg ifNotNil: [aClassOrg setSubject: self].
    organization := aClassOrg
! !

!RGClassDescriptionDefinition methodsFor:'comparing'!

= aRGClassDefinition

    ^self class = aRGClassDefinition class 
        and: [ self name = aRGClassDefinition name 
            and: [ self environment = aRGClassDefinition environment ] ]
!

hash

    ^self name hash bitXor: self class hash
! !

!RGClassDescriptionDefinition methodsFor:'initialization'!

initialize

    super initialize.
    instanceVariables:= OrderedCollection new.
! !

!RGClassDescriptionDefinition methodsFor:'instance variables'!

addInstVarNamed: aString
    | var |
    var := ((self isMeta 
                ifTrue: [ RGClassInstanceVariableDefinition ]
                ifFalse:[  RGInstanceVariableDefinition ])
        named: aString) parent: self.
    self addVariable: var in: instanceVariables.
    ^var
!

addInstanceVariable: aRGVariableDefinition
    "aRGVariableDefinition is a instance variable or class instance variable"

    self addVariable: (aRGVariableDefinition parent: self)
        in: instanceVariables
!

addInstanceVariables: aCollection
    
    aCollection do: [:var | self addInstVarNamed: var ]
!

allInstVarNames

    ^self allInstanceVariables collect:[ :ivar| ivar name ]
!

allInstanceVariables
    "Answer a collection of the receiver's instanceVariables, including those defined in its superclass"

    ^self hasSuperclass 
        ifFalse:[ instanceVariables ]
        ifTrue:[ self superclass allInstanceVariables, instanceVariables ]
!

instVarNames
    "Answer a collection of the names of the instance variables defined in the receiver."
    
    ^instanceVariables collect:[ :ivar| ivar name ]
!

instanceVariableNamed: aString
    ^ instanceVariables 
        detect: [ :v | v name = aString asSymbol ] 
        ifNone: [ nil ]
!

instanceVariableNames: aStringOrCollection
    | instanceVariableNames |

    aStringOrCollection isString ifTrue:[  
        instanceVariableNames := ((aStringOrCollection tokensBasedOn: Character space) reject:[:e | e isEmpty])
    ] ifFalse:[ 
        instanceVariableNames := aStringOrCollection.
    ].
    instanceVariables := OrderedCollection new.
    self addInstanceVariables: instanceVariableNames

    "Created: / 31-08-2015 / 15:30:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeInstVarNamed: aString

    self removeVariable: (self instanceVariableNamed: aString) from: instanceVariables
!

removeInstanceVariable: aRGVariableDefinition
    "aRGVariableDefinition is a instance variable or class instance variable"

    self removeVariable: aRGVariableDefinition from: instanceVariables
! !

!RGClassDescriptionDefinition methodsFor:'organization'!

organization
    "Answer the instance of ClassOrganizer that represents the organization 
    of the messages of the receiver."

    organization ifNil: [
        self organization: (ClassOrganization forClass: self) ].
    "Making sure that subject is set correctly. It should not be necessary."
    organization ifNotNil: [ organization setSubject: self ].
    ^ organization
! !

!RGClassDescriptionDefinition methodsFor:'printing'!

storeOn: aStream
    aStream
        nextPutAll: '(';
        nextPutAll: self class name;
        nextPutAll: ' named: '.
    name storeOn: aStream.
    aStream nextPut: $)
! !

!RGClassDescriptionDefinition methodsFor:'private'!

addVariable: aRGVariableDefinition in: aCollection
    "Adds a RGVariableDefinition in the collection received" 

    aCollection add: aRGVariableDefinition
!

removeVariable: aRGVariableDefinition from: aCollection
    "Removes a variable from a particular collection.
    This behavior is the same for any kind of variable"
    aCollection remove: aRGVariableDefinition ifAbsent:[]
! !

!RGClassDescriptionDefinition methodsFor:'testing'!

isClass

    ^true
!

isSameRevisionAs: aRGClassDescriptionDefinition
    "This method look for equality of the properties of the receiver"
    "Instances variables are compared at the level of names but without any sorting"

    ^(super isSameRevisionAs: aRGClassDescriptionDefinition)
        and:[ self instVarNames sort = aRGClassDescriptionDefinition instVarNames sort ]
! !

!RGClassDescriptionDefinition class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

