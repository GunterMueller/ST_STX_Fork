"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGGlobalDefinition subclass:#RGBehaviorDefinition
	instanceVariableNames:'superclass methods protocols'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel'
!

RGBehaviorDefinition comment:'An RGBehaviorDefinition is an abstract definition for class-alike entities (e.g. classes, traits)Instance Variables	methods:		<Collection>	protocols:		<Collection>	superclass:		<Object>'
!

!RGBehaviorDefinition class methodsFor:'class-annotations'!

allSubclassesKey

    ^#allSubclasses
!

allSuperclassesKey

    ^#allSuperclasses
!

definitionSourceKey

    ^#definitionSource
!

isPoolKey

    ^#isPool
!

subclassesKey

    ^#subclasses
!

superclassNameKey
    
    ^#superclassName
!

superclassesKey

    ^#superclasses
!

traitCompositionSourceKey

    ^#traitCompositionSource
!

usersKey

    ^#users
! !

!RGBehaviorDefinition methodsFor:'accessing'!

methods

    ^methods
!

methods: aDictionary

    methods:= aDictionary
!

package
    
    self subclassResponsibility
!

protocols
    "retrieves the protocols of the class"

    ^protocols
!

protocols: aCollection
    "set the protocols of the class"

    protocols:= aCollection
!

realClass
    "Retrieves the current class existing in the runtime environment"

    ^self rootEnvironment classNamed: self name 
!

superclass

    ^superclass
!

superclass: aRGBehaviorDefinition
    "The superclass is assigned.
    If aRGBehaviorDefinition is not nil the receiver is added as a subclass and the superclass assignment also happens for theMetaClass"

    superclass := aRGBehaviorDefinition.
    superclass notNil
        ifFalse: [ ^ self ].
    self superclassName: aRGBehaviorDefinition name.
    aRGBehaviorDefinition addSubclass: self.
    self hasMetaclass
        ifTrue: [ self theMetaClass superclass: aRGBehaviorDefinition theMetaClass ]
!

theMetaClass

    self subclassResponsibility
!

theMetaclass
    ^ self theMetaClass

    "Created: / 29-08-2015 / 11:40:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theNonMetaClass

    self subclassResponsibility
!

theNonMetaclass
    ^ self theNonMetaClass

    "Created: / 29-08-2015 / 11:40:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

traitNames
    "Assuming that traits in a composition can be identified by
    testing for the first character being an uppercase character
    (and thus not a special character such as {, # etc.)"
    | tokens |
    
    tokens := self traitCompositionSource parseLiterals flattened.
    ^tokens select: [:each | each first isUppercase].
!

traits
    "Retrieves ring traits based on the names in the traitComposition and from the environment if it is a ring object"
    
    ^ self environment isRingObject 	
        ifTrue: [ self traitNames collect:[ :each| self environment traitNamed: each ] ]
        ifFalse:[ #() ]
! !

!RGBehaviorDefinition methodsFor:'accessing class hierarchy'!

allSubclasses
    "Retrieves all the subclasses of the receiver in the chan hiearchy - value is kept as an annotation"
    "is a good idea storing this?"
    
    ^self annotationNamed: self class allSubclassesKey
        ifAbsentPut:[ | collection index |
            index := 1.
            collection := OrderedCollection withAll: self subclasses.
            [index <= collection size] whileTrue: 
                [collection addAll: (collection at: index) subclasses.
                index := index + 1].
            collection ]
!

allSubclasses: aCollection
    "Stores all the subclasses (direct and indirect) as an annotation"
    
    self annotationNamed: self class allSubclassesKey
        ifAbsentPut:[ aCollection ]
!

allSuperclasses
    "Answer an OrderedCollection of the receiver's and the receiver's  
    ancestor's superclasses"
    "Is implementation of Behavior more efficient?"
    
    ^self annotationNamed: self class allSuperclassesKey
        ifAbsentPut:[ | supers sprClass |
            supers := OrderedCollection new.
            sprClass := self superclass.
            [sprClass notNil] whileTrue: 
                [supers add: sprClass.
                sprClass := sprClass superclass].
            supers ]
!

allSuperclasses: aCollection
    "Stores all the superclasses (direct and indirect) as an annotation"
    
    self annotationNamed: self class allSuperclassesKey
        ifAbsentPut:[ aCollection ]
!

allSuperclassesDo: aBlock
    "Evaluate the argument, aBlock, for each of the receiver's superclasses."

    self superclass isNil
        ifTrue: [ ^ self ].
    aBlock value: superclass.
    superclass allSuperclassesDo: aBlock
!

methodDict
    ^ methods
!

methodDictionary
    ^ methods

    "Created: / 29-08-2015 / 18:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

withAllSubclasses
    "if allSubclasses is stored should not affect the collection"

    ^self allSubclasses, {self}
!

withAllSuperclasses
    "if allSuperclasses is stored should not affect the collection"

    ^self allSuperclasses, {self}
! !

!RGBehaviorDefinition methodsFor:'accessing methods'!

allSelectors
    "Retrieves all the selectos of the receiver in the chain hierarchy"
    | class selectors |
    
    class:= self.
    selectors := Set new.
    [class notNil] whileTrue: 
            [selectors addAll: class selectors.
            class := class superclass ].
    ^selectors
!

compiledMethodNamed: selector
    "Retrieves the compiled method from aRGMethodDefinition"
    | method |

    ^(method:= self methodNamed: selector) notNil
    ifTrue: [ method compiledMethod ]
    ifFalse:[ nil ]
!

extensionMethods

    ^self methods select:[ :each | each isExtension ]
!

includesSelector: selector
    "Looks if selector is a key in the methods dictionary"
    
    ^methods includesKey: selector asSymbol
!

methodNamed: selector
    "Retrieves aRGMethodDefinition that matches the selector given as argument"
    "RB defines methodFor:"

    ^methods at: selector asSymbol ifAbsent:[ nil ]
!

methodsInProtocol: aString
    "Retrieves the methods classified in protocol named aString"

    ^methods select: [ :each | each protocol = aString ]
!

selectors
    "Retrieves the method selectors"

    ^methods keys
! !

!RGBehaviorDefinition methodsFor:'adding/removing methods'!

addMethod: aRGMethodDefinition
    "Adds aRGMethodDefinition in the methods dictionary.
     Adds the protocol of such method too"

    self addMethod: aRGMethodDefinition in: methods.
    self addProtocol: aRGMethodDefinition protocol
!

addSelector: selectorName classified: protocolName sourced: source

    self addMethod: ((RGMethodDefinition named: selectorName) 
                            parent: self;
                            protocol: protocolName;
                            sourceCode: source;
                            yourself)
!

removeMethod: aRGMethodDefinition
    "Removes aRGMethodDefinition from the methods dictionary"

    self removeMethod: aRGMethodDefinition from: methods
!

removeSelector: selector
    "Removes a method named as selector"

    methods removeKey: selector ifAbsent:[]
! !

!RGBehaviorDefinition methodsFor:'adding/removing protocols'!

addProtocol: anObject
    "Adds a protocol named anObject.
    Protocols are not repeated"
    
    anObject ifNil:[ ^self ].
    protocols add: anObject
!

removeProtocol: aString
    "Removes a protocol named aString (if exists)"

    protocols remove: aString ifAbsent:[]
! !

!RGBehaviorDefinition methodsFor:'annotations'!

definitionSource
    "Retrieves the definition template of the receiver -> aString.
    This value is kept as an annotation"
    
    ^self annotationNamed: self class definitionSourceKey
!

definitionSource: aString
    "Sets the definition template of the receiver -> aString.
    It's stored as an annotation"
    
    self annotationNamed: self class definitionSourceKey
        put: aString
!

hasDefinitionSource
    "Tests whether the receiver has a source definition."
    
    ^ self definitionSource notNil
!

subclasses
    "Retrieves the direct subclasses of the receiver.
    This value is kept as an annotation"

    ^self annotationNamed: self class subclassesKey
        ifAbsentPut:[ OrderedCollection new ]
!

subclasses: aCollection
    "Stores direct subclasses of the receiver as an annotation"

    self annotationNamed: self class subclassesKey
        ifAbsentPut:[ aCollection ]
!

superclassName
    "Retrieves the name of the superclass if exists"

    ^self annotationNamed: self class superclassNameKey
!

superclassName: aSymbol

    self annotationNamed: self class superclassNameKey 
        put: aSymbol
!

traitCompositionSource
    "Retrieves aString representing the used traits"

    ^self annotationNamed: self class traitCompositionSourceKey
        ifAbsentPut:[  '{}'  ]
!

traitCompositionSource: anString
    "Stores aString representing the traits used by the receiver "

    self annotationNamed: self class traitCompositionSourceKey
        put: anString 
! !

!RGBehaviorDefinition methodsFor:'compatibility'!

soleInstance
    "to be depracated in the future"
    
    ^self theNonMetaClass
! !

!RGBehaviorDefinition methodsFor:'initialization'!

initialize

    super initialize.
    methods:= IdentityDictionary new.
    protocols:= Set new.
! !

!RGBehaviorDefinition methodsFor:'managing container'!

addInContainer: aRGContainer

    aRGContainer addClass: self
!

isIncludedInContainer: aRGContainer

    ^aRGContainer includesClass: self
!

removeFromContainer: aRGContainer

    aRGContainer removeClass: self
! !

!RGBehaviorDefinition methodsFor:'printing'!

printOn: aStream 
    aStream nextPutAll: self name
!

storeOn: aStream 
    self name storeOn: aStream
! !

!RGBehaviorDefinition methodsFor:'private'!

addMethod: aRGMethodDefinition in: aCollection
    "Adds aRGMethodDefinition in the collection received"

    aRGMethodDefinition parent ifNil:[ aRGMethodDefinition parent: self ].
    aCollection at: aRGMethodDefinition selector
        put: aRGMethodDefinition
!

removeMethod: aRGMethodDefinition from: aCollection
    "Removes aRGMethodDefinition from the collection received"

    aCollection removeKey: aRGMethodDefinition selector ifAbsent:[]
! !

!RGBehaviorDefinition methodsFor:'subclassing'!

addSubclass: aRGBehaviorDefinition
    "Adds a direct subclass of the receiver"

    (self subclasses includes: aRGBehaviorDefinition)
        ifFalse:[ self subclasses add: aRGBehaviorDefinition ]
!

removeSubclass: aRGBehaviorDefinition 
    "Removes aRGAbstractClassDefinition from the direct subclasses - without failing if does not exist"
    
    self subclasses remove: aRGBehaviorDefinition ifAbsent: []
! !

!RGBehaviorDefinition methodsFor:'testing'!

hasMetaclass

    ^ false
!

hasMethods
    "validates the existance of methods"

    ^methods notEmpty
!

hasProtocols
    "Validates the existance of protocols"

    ^protocols notEmpty
!

hasSuperclass

    ^superclass notNil
!

hasTraitComposition

    ^self traitCompositionSource ~= '{}'
!

includesProtocol: aString
        "Looks for a protocols named = aString"
    
        ^protocols includes: aString
!

isDefined
    "If the class exists in the environment"
    
    ^self realClass notNil
    
!

isMeta
    "By default is considered a non-meta class"

    ^false
!

isSameRevisionAs: aRGBehaviorDefinition
    "This method look for equality of the properties of the receiver"

    ^self class = aRGBehaviorDefinition class
        and:[ self name == aRGBehaviorDefinition name ]
! !

!RGBehaviorDefinition methodsFor:'testing class hierarchy'!

includesBehavior: aClass
    ^self == aClass or: [self inheritsFrom: aClass]
! !

