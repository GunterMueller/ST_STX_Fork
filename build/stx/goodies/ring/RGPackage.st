"{ Package: 'stx:goodies/ring' }"

"{ NameSpace: Smalltalk }"

RGContainer subclass:#RGPackage
	instanceVariableNames:'package'
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Containers'
!

RGPackage comment:'RGPackage is the representation for packages.A package manages classes, methods and children packages as elements.A package can also know in which package is defined'
!

!RGPackage methodsFor:'accessing'!

categories
    "Retrieves class categories of the receiver"
    
    ^self elements at: #categories
!

categories: aCollection
    "Set the class categories collection"
    
    self elements at: #categories put: (aCollection asOrderedCollection)
!

classNames

    ^ self classes isDictionary
        ifTrue: [ self classes keys ]
        ifFalse:[ self classes collect:[ :class|  class name ] ]	
!

classes
    "Retrieves a collection (by default a dictionary) of classes defined in the receiver and classes holding extension methods"
    
    ^self definedClasses, self extendedClasses 
!

definedClassNames

    ^ super classNames
!

definedTraits
    "Retrieves the traits defined in the receiver"

    ^self traits
!

extendedClassNames

    ^ self extendedClasses isDictionary
        ifTrue: [ self extendedClasses keys ]
        ifFalse:[ self extendedClasses collect:[ :each| each name ]]
!

extendedClasses
    "Retrieves the classes holding the extension methods and returns a dictionary as well"
    |  classesOfExt |
    classesOfExt := Dictionary new.
    
    self extensionMethods
        do:[ :mth| (classesOfExt includesKey: mth parentName)
                    ifFalse:[ classesOfExt at: mth parentName put: mth parent ] ].
    
    ^classesOfExt
!

extendedSelectors
    "Retrieves the names of the methods"
    
    ^ self extensionMethods keys
!

extensionMethods
    "Retrieves extension methods"
    
    ^self elements at: #extensionMethods
!

extensionMethods: aCollection
    "Set the extension methods collection"
    
    self elements at: #extensionMethods put: aCollection
!

methods
    "Retrieves all the methods defined in the receiver. 
    #methods holds the methods of defined classes"
    
    ^super methods, self extensionMethods 
!

package
    "Retrieves the  package in which self is contained"

    ^package
!

package: aRGPackage
    "Sets the outer package of the receiver if exists"

    package:= aRGPackage
!

parent
    "Retrieves the environment linked to this package"
    
    ^self environment
! !

!RGPackage methodsFor:'adding/removing'!

addElement: aRGDefinition in: aCollection

    aRGDefinition package: self.
    super addElement: aRGDefinition in: aCollection.
!

addMethod: aRGMethodDefinition
    "aRGMethodDefinition needs to satisfy the status isMethod"

    aRGMethodDefinition isMethod ifFalse:[ ^self ].
    aRGMethodDefinition package: self.	"Needed to evaluate #isExtension if it was not set in advance"
    self 
        addElement: aRGMethodDefinition 
        in: (aRGMethodDefinition isExtension 
            ifTrue: [ self extensionMethods ]
            ifFalse:[ super methods ])
!

removeMethod: aRGMethodDefinition

    self 
        removeElement: aRGMethodDefinition 
        from: (aRGMethodDefinition isExtension 
                ifTrue: [ self extensionMethods ]
                ifFalse:[ super methods ])
!

withoutCategories

    self removeElementsCategorized: #categories
! !

!RGPackage methodsFor:'initialization'!

initialize

    super initialize.
    self withoutPackages.       "By default the receiver has no child packages"
    self extensionMethods: Dictionary new.              
    self categories: OrderedCollection new.

    "Modified: / 02-09-2015 / 12:02:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RGPackage methodsFor:'lookup'!

lookupClassNamed: className
    "Look for the class named className in the receiver's defined classes or in any of its package children"
    | class |
    
    class:= self classNamed: className.
    class ifNotNil:[ ^class ].
    
    self packages
        do:[ :each| class:= each lookupClassNamed: className.
                    class ifNotNil:[ ^class ] ].
    ^nil
! !

!RGPackage methodsFor:'managing container'!

addInContainer: anRGContainer

    anRGContainer addPackage: self
! !

!RGPackage methodsFor:'metrics'!

numberOfLinesOfCode
    
    ^ self 
        annotationNamed: #numberOfLinesOfCode
        ifAbsentPut: [
            | number |
            number := self classes inject: 0 into: [ :sum :each | sum + each numberOfLinesOfCode + each theMetaClass numberOfLinesOfCode ].
            number := self methods inject: number into: [ :sum :each | sum + each numberOfLinesOfCode ].
            number ]
! !

!RGPackage methodsFor:'printing'!

printOn: aStream
    aStream
        nextPutAll: self class name;
        nextPutAll: '(';
        nextPutAll: self name;
        nextPutAll: ')'
! !

!RGPackage methodsFor:'testing'!

definesClass: aRGBehaviorDefinition
    "Returns true if the receiver includes aRGBehaviorDefinition in the defined classes"

    ^ self includesClass: aRGBehaviorDefinition
!

definesOrExtendsClass: aRGBehaviorDefinition
    "Returns true whether the class, aRGBehaviorDefinition, is one locally defined classes of the receiver or 
    if the receiver extends such class (that is defined in another package)"
    
    ^ (self definesClass: aRGBehaviorDefinition) or:[ self extendsClass: aRGBehaviorDefinition ]
!

extendsClass: aRGBehaviorDefinition
    "Returns true if the receiver extends aRGBehaviorDefinition (that is defined in another package)"
    
    ^ self extendedClasses includes: aRGBehaviorDefinition
!

isPackage

    ^true
! !

