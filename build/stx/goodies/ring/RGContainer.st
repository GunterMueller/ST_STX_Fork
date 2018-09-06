"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGAbstractContainer subclass:#RGContainer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Containers'
!

RGContainer comment:'A concrete container already knows how to treat classes, methods and packages. '
!

!RGContainer class methodsFor:'image package loading'!

allManagers

    ^ Smalltalk globals at: #MCWorkingCopy 
        ifPresent: [:mcwc | mcwc allManagers ] 
        ifAbsent: [OrderedCollection new ]
!

category: categoryName matches: prefix

    | prefixSize catSize |
    categoryName ifNil: [ ^false ].
    catSize := categoryName size.
    prefixSize := prefix size.
    catSize < prefixSize ifTrue: [ ^false ].
    (categoryName findString: prefix startingAt: 1 caseSensitive: true) = 1
        ifFalse: [ ^false ].
    ^(categoryName at: prefix size + 1 ifAbsent: [ ^true ]) = $-
!

packageKeys

    ^ self allManagers collect: [ :pck | pck package name asSymbol -> ('*', pck package name asLowercase) ]
!

packageNames

    ^ self allManagers collect: [ :pck | pck package name asSymbol ]
!

packageOfClass: aRGBehaviorDefinition

    ^ self packageOfClass: aRGBehaviorDefinition using: self packageNames.
!

packageOfClass: aRGBehaviorDefinition using: packageNames

    "Looks for the package of aRGBehaviorDefinition from the image"
    | pName |
    aRGBehaviorDefinition ifNil:[ ^nil ].
    pName := (packageNames 
                detect: [ :each| each = aRGBehaviorDefinition category ]
                ifNone: [ packageNames detect:[ :each| self category: aRGBehaviorDefinition category matches: each ] ifNone:[ nil ] ]).
    ^ pName ifNotNil:[ RGPackage named: pName ]
!

packageOfMethod: aRGMethodDefinition

    ^ self packageOfMethod: aRGMethodDefinition using: self packageKeys
!

packageOfMethod: aRGMethodDefinition using: packageKeys

    "Looks for the package of aRGMethodDefinition from the image"
    | pName parentPackage |
    (aRGMethodDefinition protocol notNil and:[ aRGMethodDefinition protocol beginsWith: '*' ]) ifFalse:[
        parentPackage := (aRGMethodDefinition parent ifNotNil:[ aRGMethodDefinition parent package ]).	
        ^ parentPackage ifNil:[ self packageOfClass: aRGMethodDefinition parent ] ].

    aRGMethodDefinition protocol ifNil: [ ^ nil ].
    pName := (packageKeys 
                detect: [ :each| self category: aRGMethodDefinition protocol asLowercase matches: each value ] ifNone:[ nil ]).
    ^ pName ifNotNil:[ RGPackage named: pName key ]
! !

!RGContainer methodsFor:'accessing'!

definedClasses
    "Retrieves classes (traits are included)"

    ^self elements at: #definedClasses ifAbsentPut:[ Dictionary new ]

    "Modified: / 02-09-2015 / 12:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

definedClasses: aCollection
    "Set the classes collection"

    self elements at: #definedClasses put: aCollection
!

methods
    "Retrieves methods defined in the container"
    
    ^self elements at: #methods ifAbsentPut:[ Dictionary new ]

    "Modified: / 02-09-2015 / 12:02:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methods: aCollection
    "Set the methods collection"
    
    self elements at: #methods put: aCollection
!

packages
    "Retrieves the children packages defined in the receiver"

    ^self elements at: #packages ifAbsentPut:[ Dictionary new ]

    "Modified: / 02-09-2015 / 12:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packages: aCollection

    self elementsCategorized: #packages with: aCollection
! !

!RGContainer methodsFor:'adding/removing'!

addClass: aRGBehaviorDefinition
    "aRGBehaviorDefinition has to be a class, trait or metaclass"
    self flag: 'when i am adding a metaclass? check this?'.

    (aRGBehaviorDefinition isClass
        or:[ aRGBehaviorDefinition isTrait ]) ifFalse:[ ^self ].
    self addElement: aRGBehaviorDefinition in: self definedClasses
!

addClassNamed: className 
    "Creates a class with the given name"
    self addClass: (RGClassDefinition named: className)
!

addMethod: aRGMethodDefinition
    "aRGMethodDefinition needs to satisfy the status isMethod"

    aRGMethodDefinition isMethod ifFalse:[ ^self ].
    self addElement: aRGMethodDefinition in: self methods
!

addPackage: aRGPackage
    "adds a child package"

    aRGPackage isPackage ifFalse:[ ^self ].
    self addElement: aRGPackage in: self packages
!

addPackageNamed: packageName
    "adds a child package with the given name"

    (self includesPackageNamed: packageName) ifTrue: [ ^self ].
    self addPackage: (RGPackage named: packageName)
!

addTrait: aRGTraitDefinition
    "convenient method"

    self addClass: aRGTraitDefinition
!

addTraitNamed: traitName 
    "Creates a trait with the given name"
    self addClass:  (RGTraitDefinition named: traitName)
!

removeClass: aRGAbstractClassDefinition

    self removeElement: aRGAbstractClassDefinition from: self definedClasses
!

removeMethod: aRGMethodDefinition

    self removeElement: aRGMethodDefinition from: self methods
!

removePackage: aRGPackage
    "removes a child aRGPackage"

    aRGPackage isPackage ifFalse:[ ^self ].
    self removeElement: aRGPackage from: self packages
!

removeTrait: aRGTraitDefinition
    "convenient method"

    self removeClass: aRGTraitDefinition
!

withoutClasses

    self removeElementsCategorized: #definedClasses
!

withoutMethods
    
    self removeElementsCategorized: #methods
!

withoutPackages
    
    self removeElementsCategorized: #packages
! !

!RGContainer methodsFor:'convenient accesses'!

allClasses
    "convenient method"

    ^self classes
!

allMethods
    "convenient method"

    ^self methods
!

allTraits
    "convenient method"
    
    ^self allClasses select:[ :each | each isTrait ]
!

classNames
    "Retrieves class names (including traits)"
    
    ^ self definedClasses isDictionary
        ifTrue: [ self definedClasses keys ]
        ifFalse:[ self definedClasses collect:[ :class|  class name ] ]
!

classes
    "convenient method"

    ^self definedClasses
!

classes: aCollection
    "convenient method"

    self definedClasses: aCollection
!

extensionMethods
    "Retrieves a collection (by default a dictionary) with the extensions methods of the receiver"

    ^self methods values select:[ :mth| mth isExtension ]
!

traitNames
    "Retrieves the names of defined traits"

    ^ self traits isDictionary
        ifTrue: [ self traits keys ]
        ifFalse:[ self traits collect:[ :trait| trait name ] ]
!

traits
    "Retrieves a collection (by default a dictionary) containing only defined traits"

    ^self definedClasses select:[ :each| each isTrait ]
! !

!RGContainer methodsFor:'image class and method loading'!

loadClass: aRGBehaviorDefinition using: packageKeys

    self setPackageOfClass: aRGBehaviorDefinition using: packageKeys.
    self addClass: aRGBehaviorDefinition
!

loadMethod: aRGMethodDefinition inClass: aRGBehaviorDefinition using: packageKeys

    self addMethod: aRGMethodDefinition.
    aRGBehaviorDefinition addMethod: aRGMethodDefinition.
    self setPackageOfMethod: aRGMethodDefinition ofClass: aRGBehaviorDefinition using: packageKeys
!

loadTraitUsers
    "Set the users of a trait"
    | users |
    
    users := self classes select: [ :cls | cls hasTraitComposition ].
    users do:[ :each |  | rgTrait |
        each traitNames do:[ :tname|
            rgTrait := self traitNamed: tname.
            rgTrait notNil ifTrue: [
                rgTrait addUser: each.
                rgTrait theMetaClass addUser: each theMetaClass ] ] ]
! !

!RGContainer methodsFor:'image package loading'!

cleanEmptyPackages

    (self packages select:[ :pck| pck classes size isZero and:[ pck methods size isZero ] ])
        do:[ :pck| self removePackage: pck ]
!

findPackageOfClass: aRGBehaviorDefinition using: packageKeys

    "Look for the package of a class. It is nil when there is not a package created for a category in MC"
    | pair |
    self packages isEmpty ifTrue: [ ^ nil ].
    ^ self packages at: aRGBehaviorDefinition category ifAbsent:[
        pair := packageKeys detect:[ :each| self class category: aRGBehaviorDefinition category matches: each key ] ifNone:[ nil ].
        pair ifNotNil:[ self packages at: pair key ] ]
!

findPackageOfMethod: aRGMethodDefinition using: packageKeys

    "Look for the package of an extension method. nil otherwise"
    | pair lname |	
    self packages isEmpty ifTrue: [ ^nil ].
    (aRGMethodDefinition protocol beginsWith: '*') ifFalse:[ ^ nil ].
    lname := aRGMethodDefinition protocol asLowercase.
 	pair := packageKeys detect:[ :assoc| self class category: lname matches: assoc value ] ifNone:[ nil ].
    ^ pair ifNotNil:[ self packages at: pair key ]
!

loadPackagesFromImage

    | rgPackage rgPackageKeys |
    rgPackageKeys := OrderedCollection new.
    self class allManagers do: [ :pck | 
        rgPackage := RGPackage named: pck package name asSymbol.
        rgPackageKeys add: (rgPackage name -> ('*', rgPackage name asLowercase)).
        self addPackage: rgPackage ].
    ^ rgPackageKeys
!

setPackageOfClass: rgClass using: packageKeys
    "Set the package to aRGBehaviorDefinition"

    | pkg |

    (pkg := self findPackageOfClass: rgClass using: packageKeys) 
        ifNotNil:[ pkg addClass: rgClass ]
    
!

setPackageOfMethod: rgMethod ofClass: rgClass using: packageKeys
    "Set the package to aRGMethodDefinition and its value isExtension"

    | pkg |

    (pkg := self findPackageOfMethod: rgMethod using: packageKeys) 
        ifNil:[ rgClass package ifNotNil:[
                pkg addMethod: rgMethod.
                rgMethod isExtension: false ] ]
        ifNotNil:[ 
            pkg addMethod: rgMethod.
            rgMethod isExtension: (rgMethod package ~= rgClass package) ]
! !

!RGContainer methodsFor:'initialization'!

initialize

    super initialize.
    self definedClasses: Dictionary new.
    self methods: Dictionary new.
    self packages: Dictionary new.

    "Modified: / 02-09-2015 / 12:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RGContainer methodsFor:'iterating'!

allClassesDo: aBlock
    "Evaluate the argument, aBlock, for each class and its metaclass"

    self allClasses do: [ :each|
        aBlock value: each.
        each hasMetaclass
            ifTrue:[ aBlock value: each theMetaClass ] ]
!

allTraitsDo: aBlock
    "Evaluate the argument, aBlock, for each trait"

    self allTraits do: [ :each|
        aBlock value: each.
        each hasMetaclass
            ifTrue:[ aBlock value: each theMetaClass ] ]
!

classesDo: aBlock

    self classes do: [ :each|
        aBlock value: each.
        each hasMetaclass
            ifTrue:[ aBlock value: each theMetaClass ] ]
!

definedClassesDo: aBlock

    self definedClasses do: [ :each|
        aBlock value: each.
        each hasMetaclass
            ifTrue:[ aBlock value: each theMetaClass ] ]
!

methodsDo: aBlock

    self methods
        do:[ :each| aBlock value: each ]
!

traitsDo: aBlock

    self traits do: [ :each|
        aBlock value: each.
        each hasMetaclass
            ifTrue:[ aBlock value: each theMetaClass ] ]
! !

!RGContainer methodsFor:'lookup by name'!

classNamed: className
    "Retrieves an RGBehaviorDefinition object.
    className could be theMetaClass name"
    
    ^self classOrTraitNamed: className
!

classOrTraitNamed: className
    "A class or metaclass can be reached by its name"
    | theClass |

    className ifNil: [^nil ].
    theClass:= self elementNamed: (self theNonMetaClassNameOf: className) in: self definedClasses.
    theClass ifNil:[ ^nil ].
    
    ^(self isMetaclassName: className)
        ifTrue: [ theClass theMetaClass ]
        ifFalse:[ theClass ] 
!

metaclassNamed: metaclassName
    | theClass |
    
    theClass:= (self classOrTraitNamed: metaclassName).
    theClass notNil
    ifTrue:[ ^theClass isMeta 
              ifTrue: [ theClass ]
              ifFalse:[ theClass theMetaClass ] ].
    
    ^nil
!

methodNamed: fullSelectorName

    ^self elementNamed: fullSelectorName in: self methods
!

packageNamed: packageName
    "Look for a child package named packageName"
    
    ^self elementNamed: packageName in: self packages
!

traitNamed: traitName
    "Retrieves an RGTraitDefinition object.
    traitName could be theMetaClass name"
    | trait |
    
    ^(trait:= self classOrTraitNamed: traitName) isTrait
    ifTrue:[ trait ]
    ifFalse:[ nil ]
! !

!RGContainer methodsFor:'testing'!

hasClasses

    ^self definedClasses notEmpty
!

hasMethods

    ^self methods notEmpty
!

includesClass: aRGBehaviorDefinition
    "Returns true if the receiver includes aRGBehaviorDefinition in the defined classes"

    ^self definedClasses includes: aRGBehaviorDefinition
!

includesClassNamed: className
    "Returns true if the receiver includes the className in the defined classes"

    self flag: 'can a metaclass be stored without its nonMetaClass? Check this'.
    ^self includesElementNamed: (self theNonMetaClassNameOf: className) in: self definedClasses.
!

includesMethod: aRGMethodDefinition

    ^self methods includes: aRGMethodDefinition
!

includesMethodNamed: fullSelectorName
    
    ^self includesElementNamed: fullSelectorName in: self methods
!

includesPackage: aRGPackage
    "Verifies if a child package == aRGPackage exists"
    
    ^self packages includes: aRGPackage
!

includesPackageNamed: packageName
    "Verifies if a child package with name = packageName exists"
    
    ^self includesElementNamed: packageName in: self packages
! !

!RGContainer methodsFor:'utilities'!

isMetaclassName: aSymbol
    "Validates if the arguments corresponds to a nonMetaClass"
    
    ^(aSymbol
        indexOfSubCollection: ' class'
        startingAt: 1) > 0
!

theNonMetaClassNameOf: aSymbol
    "Rejects the prefix ' class' or ' classTrait' of the argument"
    | index |
    
    index := aSymbol
                indexOfSubCollection: ' class'
                startingAt: 1
                ifAbsent: [ ^aSymbol asSymbol ].

    ^(aSymbol 
        copyFrom: 1
        to: index - 1) asSymbol
! !

