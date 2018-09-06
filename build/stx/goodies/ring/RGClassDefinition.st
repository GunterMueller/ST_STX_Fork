"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGClassDescriptionDefinition subclass:#RGClassDefinition
	instanceVariableNames:'metaClass comment classVariables category package sharedPools'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGClassDefinition comment:'RGClassDefinition is the concrete representation of a class (no trait)'
!

!RGClassDefinition class methodsFor:'instance creation'!

newClass
    "Creates new class definition (along with it's metaclass)"

    ^ self new withMetaclass

    "Created: / 29-08-2015 / 12:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2015 / 11:54:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newSharedPool
    "A shared pool is a class inheriting from #SharedPool"
    
    ^ RGClassDefinition newClass
        superclassName:#SharedPool;
        isPool:true;
        yourself

    "Created: / 29-08-2015 / 11:54:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newSharedPoolNamed:aSymbol 
    "A shared pool is a class inheriting from #SharedPool"

    ^ self newSharedPool
        name: aSymbol;
        yourself

    "Modified: / 29-08-2015 / 11:54:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RGClassDefinition methodsFor:'accessing'!

category
    "retrieves a tag for its package"
    
    ^category
!

category: aSymbol
    "stores a tag for its package"

    category := aSymbol
!

classVariables

    ^classVariables
!

classVariables: aCollection

    classVariables:= aCollection
!

comment
    "Retrieves the comment definition object"

    ^comment
!

comment: anObject
    "Sets a RGCommentDefinition object based on the argument"
    
    comment := anObject isRingObject 
        ifFalse: [ 
            RGCommentDefinition new
                parent: self;
                content: anObject; 
                yourself ]
        ifTrue: [anObject ]
    
     
!

name: aString
    super name: aString.
    (metaClass notNil and:[metaClass name isNil]) ifTrue:[ 
        metaClass name: aString, ' class'.
    ].

    "Created: / 29-08-2015 / 12:05:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    "Retrieves the package in which this class is contained, if exists"
    
    ^package
!

package: aRGPackage
    "Sets the package in which this class is contained"
    
    package:= aRGPackage
!

sharedPools
    "Keeps the pool variable relationship of the receiver"

    ^ sharedPools
!

sharedPools: aCollection
    sharedPools := aCollection
!

stamp

    ^self hasComment ifTrue:[ self comment stamp ] ifFalse:[ nil ]
!

stamp: aString

    self hasComment
    ifTrue: [ self comment stamp: aString ]
    ifFalse:[ RGCommentDefinition new
                         parent: self; 
                         stamp: aString ]
!

theMetaClass
    
    ^metaClass
!

theNonMetaClass

    ^self
! !

!RGClassDefinition methodsFor:'behavior'!

withMetaclass
    "Registers explicitly the metaclass of a class"

    metaClass:= RGMetaclassDefinition class: self
!

withMetaclass: aRGMetaclassDefinition
    "Registers explicitly the metaclass of a class"

    metaClass:= aRGMetaclassDefinition.
    metaClass baseClass: self.  
! !

!RGClassDefinition methodsFor:'class variables'!

addClassVarNamed: aString
    | var |
    var := (RGClassVariableDefinition named: aString) parent: self.
    self addVariable: var in: classVariables.
    ^var
!

addClassVariable: aRCClassVariable

    self addVariable: (aRCClassVariable parent: self) 
        in: classVariables
!

addClassVariables: aCollection
    
    aCollection do: [:var | self addClassVarNamed: var ]
!

allClassVarNames

    ^self allClassVariables collect:[ :cvar| cvar name ]
!

allClassVariables
    "Answer a collection of the receiver's classVariables, including those defined its superclasses"

    ^self hasSuperclass 
        ifFalse:[ classVariables ]
        ifTrue:[ self superclass allClassVariables, classVariables ]
!

classVarNamed: aString

    ^classVariables detect:[ :v| v name = aString asSymbol ] ifNone:[ nil ]
!

classVarNames
    "Answer a collection of the names of the class variables defined in the receiver."
    
    ^classVariables collect:[ :cvar| cvar name ]
!

classVariableNames: aStringOrCollection
    | classVariableNames |

    aStringOrCollection isString ifTrue:[  
        classVariableNames := ((aStringOrCollection tokensBasedOn: Character space) reject:[:e | e isEmpty])
    ] ifFalse:[ 
        classVariableNames := aStringOrCollection.
    ].
    classVariables := OrderedCollection new.
    self addClassVariables: classVariableNames

    "Created: / 31-08-2015 / 15:34:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeClassVarNamed: aString

    self removeVariable: (self classVarNamed: aString) from: classVariables
!

removeClassVariable: aRGClassVariableDefinition

    self removeVariable: aRGClassVariableDefinition from: classVariables
! !

!RGClassDefinition methodsFor:'initialization'!

initialize

    super initialize.
    classVariables:= OrderedCollection new.
    sharedPools:= OrderedCollection new.
! !

!RGClassDefinition methodsFor:'managing pool users'!

addUser: aRGClassDefinition
    "The receiver registers the aRGClassDefinition as an user.  An reinforces its status as a shared pool."
    
    aRGClassDefinition isClass ifFalse:[ ^self ].
    (aRGClassDefinition theNonMetaClass sharedPoolNamed: self name) isNil
        ifTrue: [ aRGClassDefinition theNonMetaClass addSharedPoolNamed: self name ].
    self isPool: true.
    self users add: aRGClassDefinition theNonMetaClass
!

includesUser: aRGBehaviorDefinition

    ^self users includes: aRGBehaviorDefinition
!

isPool
    "The receiver is a shared pool if it inherits from SharedPool"
    
    ^self annotationNamed: self class isPoolKey 
        ifAbsent: [ self superclassName == #SharedPool ]
!

isPool: aBoolean
    
    ^self annotationNamed: self class isPoolKey put: aBoolean
!

removeUser: aRGClassDefinition
    "Removes this RGClassDefinition from the users of the receiver"
    
    aRGClassDefinition isClass ifFalse:[ ^self ].
    aRGClassDefinition theNonMetaClass removeSharedPoolNamed: self name.
    self users remove: aRGClassDefinition theNonMetaClass ifAbsent:[ ]
!

users
    "If the reciever is a SharedPool then retrieves its users"
    
    ^self isPool
        ifTrue: [ self annotationNamed: self class usersKey ifAbsentPut: [ OrderedCollection new ] ]
        ifFalse:[ #() ]
! !

!RGClassDefinition methodsFor:'shared pools'!

addSharedPool: aRGPoolVariableDefinition
    self 
        addVariable: (aRGPoolVariableDefinition parent: self) 
        in: sharedPools
!

addSharedPoolNamed: poolName
    | pool |
    pool:= (RGPoolVariableDefinition named:  poolName) parent: self.
    self addVariable: pool in: sharedPools.
    ^pool
!

addSharedPools: aCollection
    aCollection do: [ :pool | self addSharedPoolNamed: pool ]
!

allSharedPoolNames
    ^ self allSharedPools collect: [ :pool | pool name ]
!

allSharedPools
    "Answer a collection of the pools the receiver shares, including those defined  
    in the superclasses of the receiver."

    ^ self hasSuperclass
        ifFalse: [ sharedPools ]
        ifTrue: [ self superclass allSharedPools , sharedPools ]
!

poolDictionaryNames
    ^ self sharedPoolNames

    "Created: / 31-08-2015 / 15:43:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

poolDictionaryNames: aStringOrCollection

    | poolDictionaryNames |

    aStringOrCollection isString ifTrue:[  
        poolDictionaryNames := ((aStringOrCollection tokensBasedOn: Character space) reject:[:e | e isEmpty])
    ] ifFalse:[ 
        poolDictionaryNames := aStringOrCollection.
    ].
    sharedPools := OrderedCollection new.
    self addSharedPools: poolDictionaryNames

    "Created: / 31-08-2015 / 15:43:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeSharedPool: aRGPoolVariableDefinition

    self removeVariable: aRGPoolVariableDefinition from: sharedPools
!

removeSharedPoolNamed: poolName

    self removeVariable: (self sharedPoolNamed: poolName) from: sharedPools
!

sharedPoolNamed: poolName

    ^sharedPools detect:[ :v| v name = poolName asSymbol ] ifNone:[ nil ]
!

sharedPoolNames
    
    ^sharedPools collect:[ :pool| pool name ]
! !

!RGClassDefinition methodsFor:'testing'!

hasComment

    ^comment isEmptyOrNil not
!

hasMetaclass

    ^metaClass notNil
!

hasStamp

    ^self stamp isEmptyOrNil not
!

isSameRevisionAs: aRGClassDefinition
    "This method look for equality of the properties of the receiver"

    ^(super isSameRevisionAs: aRGClassDefinition)
        and:[ self superclassName == aRGClassDefinition superclassName
        and:[ self category = aRGClassDefinition category 
        and:[ self classVarNames sorted = aRGClassDefinition classVarNames sorted 
        and:[ self sharedPoolNames sorted = aRGClassDefinition sharedPoolNames sorted  
        and:[ self traitCompositionSource = aRGClassDefinition traitCompositionSource 
        and:[ ((self hasComment and:[ self comment isSameRevisionAs: aRGClassDefinition comment ]) or:[ self hasComment not ])
        and:[ (self theMetaClass isSameRevisionAs: aRGClassDefinition theMetaClass) ] ] ] ] ] ] ]
! !


