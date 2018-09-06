"{ Package: 'stx:goodies/refactoryBrowser/helpers' }"

"{ NameSpace: Smalltalk }"

Object subclass:#RBAbstractClass
	instanceVariableNames:'name newMethods instanceVariableNames model superclass subclasses
		removedMethods realClass'
	classVariableNames:'LookupSuperclass'
	poolDictionaries:''
	category:'Refactory-Model'
!

RBAbstractClass comment:'RBAbstractClass is an abstract class. It represents classes in the system. Refactorings operate on these objects, producing change objects. These change objects are then performed on the real code.

Subclasses must implement the following messages:
        accessing
                allClassVariableNames
                allPoolDictionaryNames
        testing
                directlyDefinesClassVariable:
                directlyDefinesPoolDictionary:
                isAbstract
                isMeta

Instance Variables:
        instanceVariableNames   <SequenceableCollection of: String>     instance variables that the class defines
        model   <RBNamespace>   where the class is defined
        name    <ByteSymbol>    the class'' name for metaclasses it is the name of the nonMetaclass
        newMethods      <Dictionary of: RBMethod>       methods that have been added to the class
        realClass       <Behavior>      if the class already exists in the system, then this variable holds that class
        removedMethods  <Collection of: Symbol> method names that have been removed
        subclasses      <Collection of: RBAbstractClass>        my subclasses
        superclass      <RBAbstractClass>       the superclass (or LookupSuperclass if we haven''t assigned it yet).

Class Variables:
        LookupSuperclass        <Object>        a special object denoting that our superclass hasn''t been assigned yet

'
!


!RBAbstractClass class methodsFor:'instance creation'!

new
        ^(super new)
                initialize;
                yourself
! !

!RBAbstractClass class methodsFor:'class initialization'!

initialize
        LookupSuperclass := Object new
! !

!RBAbstractClass methodsFor:'accessing'!

allClassVariableNames
        ^self subclassResponsibility
!

allInstVarNames
    ^ self allInstanceVariableNames
!

allInstanceVariableNames
        | sprClass |
        sprClass := self superclass.
        ^sprClass isNil 
                ifTrue: [self instanceVariableNames]
                ifFalse: [sprClass allInstanceVariableNames , self instanceVariableNames]
!

allPoolDictionaryNames
        ^self subclassResponsibility
!

allSubclasses
        | allSubclasses index subclasses |
        index := 1.
        allSubclasses := self subclasses copyAsOrderedCollection.
        [index <= allSubclasses size] whileTrue: 
                        [
                            subclasses := (allSubclasses at: index) subclasses.
(subclasses includes:nil) ifTrue:[self halt:'oops - nil subclass?'].
                            allSubclasses addAll: subclasses.
                            index := index + 1
                        ].
        ^allSubclasses
!

allSuperclasses
        | supers sprClass |
        supers := OrderedCollection new.
        sprClass := self superclass.
        [sprClass notNil] whileTrue: 
                        [supers add: sprClass.
                        sprClass := sprClass superclass].
        ^supers
!

categories
    "Return a collection of the method-categories known in the receiver class.
     This does NOT include the metaclasses categories or the superclass categories.
     The returned collection is not sorted by any order."               

    | categories |

    categories := Set new.
    self selectors do:[:selector |
        categories add: (self methodFor: selector) category
    ].
    ^ categories

    "Created: / 14-11-2014 / 20:25:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-11-2014 / 18:46:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

classBinding
        ^Smalltalk associationAt: self name
!

instanceVariableNames
        ^self privateInstanceVariableNames copy
!

instanceVariableNames: aCollectionOfStrings 
        instanceVariableNames := aCollectionOfStrings asOrderedCollection
!

metaclass
        ^model metaclassNamed: self name
!

model
        ^model
!

name
        ^name
!

name: aName 
    "Sets the class name"

    name := aName asSymbol

    "Modified: / 19-11-2014 / 21:14:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

newMethods
    newMethods isNil ifTrue: [
        newMethods := IdentityDictionary new.
    ].
    ^ newMethods
!

nonMetaclass
        ^model classNamed: self name
!

primaryInstance
        ^self nonMetaclass
!

protocolsFor: aSelector 
        | change |
        change := self isMeta 
                                ifTrue: [model changes changeForMetaclass: name selector: aSelector]
                                ifFalse: [model changes changeForClass: name selector: aSelector].
        ^change isNil 
                ifTrue: 
                        [self isDefined 
                                ifTrue: 
                                        [BrowserEnvironment new whichProtocolIncludes: aSelector in: self realClass]
                                ifFalse: [#(#accessing)]]
                ifFalse: [change protocols]
!

realClass
        ^realClass
!

realClass: aClass 
        realClass := aClass.
        superclass isNil ifTrue: [superclass := LookupSuperclass]
!

removeSubclass: aRBClass 
        self subclasses remove: aRBClass ifAbsent: []
!

removedMethods
        removedMethods isNil ifTrue: [
            removedMethods := Set new
        ].
        ^removedMethods
!

soleInstance
        ^self nonMetaclass
!

subclasses
        subclasses isNil 
                ifTrue: 
                        [subclasses := self isDefined 
                                                ifTrue: 
                                                        [(self realClass subclasses collect: [:each | model classFor: each]) 
                                                                copyAsOrderedCollection]
                                                ifFalse: [OrderedCollection new].
                         subclasses := subclasses select:[:each | each notNil]].
        ^subclasses
!

superclass
        ^superclass == LookupSuperclass 
                ifTrue: [model classFor: self realClass superclass]
                ifFalse: [superclass]
!

theMetaClass
        ^model metaclassNamed: self name
!

theNonMetaClass
    <resource: #obsolete>

    "alias for theNonMetaclass (Squeak) - return the class.
     sigh; in ST/X, it is called theNonMetaclass; please use that."

    ^model classNamed: self name
!

withAllSubclasses
        ^(self allSubclasses)
                add: self;
                yourself
!

withAllSuperclasses
        ^(self allSuperclasses)
                add: self;
                yourself
! !



!RBAbstractClass methodsFor:'comparing'!

= aRBClass 
        ^self class = aRBClass class 
                and: [self name = aRBClass name and: [self model = aRBClass model]]
!

hash
        ^self name hash bitXor: self class hash
! !


!RBAbstractClass methodsFor:'initialize-release'!

initialize
        name := #'Unknown Class'
!

model: aRBSmalltalk
        model := aRBSmalltalk
! !

!RBAbstractClass methodsFor:'method accessing'!

addMethod: aRBMethod 
        self newMethods at: aRBMethod selector put: aRBMethod.
        removedMethods notNil 
                ifTrue: [removedMethods remove: aRBMethod selector ifAbsent: []]
!

allSelectors
        | class selectors |
        class := self.
        selectors := Set new.
        [class notNil] whileTrue: 
                        [selectors addAll: class selectors.
                        class := class superclass].
        ^selectors
!

bindingFor: aString 
        ^self realClass classPool associationAt: aString asSymbol
                ifAbsent: [self realClass classPool associationAt: aString asString ifAbsent: [nil]]
!

compile: aString 
        ^self compile: aString
                classified: (self protocolsFor: (RBParser parseMethodPattern: aString))
!

compile: aString classified: aSymbolCollection 
        | change method |
        change := model 
                                compile: aString
                                in: self
                                classified: aSymbolCollection.
        method := RBMethod 
                                for: self
                                source: aString
                                selector: change selector.
        method category: aSymbolCollection.
        self addMethod: method

    "Modified: / 06-10-2014 / 22:38:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

compileTree: aBRMethodNode 
        ^self compileTree: aBRMethodNode
                classified: (self protocolsFor: aBRMethodNode selector)
!

compileTree: aBRMethodNode classified: aSymbolCollection 
        | method source |
        source := aBRMethodNode formattedCode.
        model 
                compile: source
                in: self
                classified: aSymbolCollection.
        method := RBMethod 
                                for: self
                                source: source
                                selector: aBRMethodNode selector.
        method category: aSymbolCollection.
"       method parseTree: aBRMethodNode."
        self addMethod: method

    "Modified: / 06-10-2014 / 22:37:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

compileTree: aBRMethodNode usingSource:newSource
        ^self compileTree: aBRMethodNode
              usingSource:newSource
              classified: (self protocolsFor: aBRMethodNode selector)
!

compileTree: aBRMethodNode usingSource:newSource classified: aSymbolCollection 
        | method source |

        source := newSource.
        model 
                compile: source
                in: self
                classified: aSymbolCollection.
        method := RBMethod 
                                for: self
                                source: newSource
                                selector: aBRMethodNode selector.
        method category: aSymbolCollection.
"       method parseTree: aBRMethodNode."
        self addMethod: method

    "Modified: / 06-10-2014 / 22:38:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

compiledMethodAt:aSelector
    ^ self methodFor: aSelector 
!

existingMethodsThatReferTo: aSymbol 
        | existingMethods |
        existingMethods := self realClass whichSelectorsReferTo: aSymbol.
        (newMethods isNil and: [removedMethods isNil]) ifTrue: [^existingMethods].
        ^existingMethods 
                reject: [:each | (self hasRemoved: each) or: [self newMethods includesKey: each]]
!

existingMethodsThatWriteVariable:aVariableName 
        | existingMethods |
        existingMethods := self realClass whichSelectorsWrite:aVariableName.
        (newMethods isNil and: [removedMethods isNil]) ifTrue: [^existingMethods].
        ^existingMethods 
                reject: [:each | (self hasRemoved: each) or: [self newMethods includesKey: each]]
!

methodFor: aSelector 
        ^self newMethods at: aSelector
                ifAbsent: 
                        [| compiledMethod class |
                        (self hasRemoved: aSelector) ifTrue: [^nil].
                        class := self realClass.
                        class isNil ifTrue: [^nil].
                        compiledMethod := class compiledMethodAt: aSelector ifAbsent: [nil].
                        compiledMethod isNil 
                                ifTrue: [nil]
                                ifFalse: 
                                        [RBMethod 
                                                for: self
                                                fromMethod: compiledMethod
                                                andSelector: aSelector]]
!

parseTreeFor: aSelector 
        | class |
        class := self whoDefinesMethod: aSelector.
        class isNil ifTrue: [^nil].
        ^(class methodFor: aSelector) parseTree
!

removeMethod: aSelector 
        self newMethods removeKey: aSelector ifAbsent: [].
        model removeMethod: aSelector from: self.
        self removedMethods add: aSelector
!

selectors
        | selectors |
        selectors := Set new.
        selectors addAll: self newMethods keys.
        self isDefined 
                ifTrue: 
                        [selectors addAll: self realClass selectors.
                        removedMethods notNil 
                                ifTrue: [removedMethods do: [:each | selectors remove: each ifAbsent: []]]].
        ^selectors
!

sourceCodeFor: aSelector 
        | class |
        class := self whoDefinesMethod: aSelector.
        class isNil ifTrue: [^nil].
        ^(class methodFor: aSelector) source
!

whichSelectorsAccess:aVariableName 
        | selectors |

        selectors := Set new.
        self newMethods 
                do: [:each | (each refersToVariable:aVariableName) ifTrue: [selectors add: each selector]].
        self isDefined 
                ifTrue: [selectors addAll: (self existingMethodsThatReferTo:aVariableName)].
        ^selectors
!

whichSelectorsReferTo: aString 
        | selectors |
        selectors := Set new.
        self newMethods 
                do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
        self isDefined 
                ifTrue: 
                        [selectors addAll: ((self realClass whichSelectorsAccess: aString) 
                                                reject: [:each | self hasRemoved: each])].
        ^selectors
!

whichSelectorsReferToClass: aRBClass 
        | selectors |
        selectors := Set new.
        self newMethods do: 
                        [:each | 
                        (each refersToClassNamed: aRBClass name) 
                                ifTrue: [selectors add: each selector]].
        (self isDefined and: [aRBClass isDefined]) 
                ifTrue: 
                        [selectors addAll: (self existingMethodsThatReferTo: aRBClass classBinding).
                        selectors addAll: (self existingMethodsThatReferTo: aRBClass name)].
        ^selectors
!

whichSelectorsReferToClassVariable: aString 
        | selectors |
        selectors := Set new.
        self newMethods 
                do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
        self isDefined 
                ifTrue: 
                        [| binding |
                        Smalltalk isSmalltalkX ifTrue:[
                            selectors addAll:(self realClass
                                                 whichSelectorsReferToClassVariable:aString)
                        ] ifFalse:[
                            binding := self bindingFor: aString.
                            binding isNil ifTrue: [^selectors].
                            selectors addAll: ((self realClass whichSelectorsReferTo: binding) 
                                                    reject: [:each | self hasRemoved: each])
                        ]].
        ^selectors
!

whichSelectorsReferToInstanceVariable: aString 
        | selectors |
        selectors := Set new.
        self newMethods 
                do: [:each | (each refersToVariable: aString) ifTrue: [selectors add: each selector]].
        self isDefined 
                ifTrue: 
                        [selectors addAll: ((self realClass whichSelectorsAccess: aString) 
                                                reject: [:each | self hasRemoved: each])].
        ^selectors
!

whichSelectorsReferToSymbol: aSymbol 
        | selectors |

        selectors := Set new.
        self newMethods 
                do: [:each | (each refersToSymbol: aSymbol) ifTrue: [selectors add: each selector]].
        self isDefined 
                ifTrue: [selectors addAll: (self existingMethodsThatReferTo: aSymbol)].
        ^selectors
!

whichSelectorsWrite:aVariableName 
        | selectors |

        selectors := Set new.
        self newMethods 
                do: [:each | (each writesVariable:aVariableName) ifTrue: [selectors add: each selector]].
        self isDefined 
                ifTrue: [selectors addAll: (self existingMethodsThatWriteVariable:aVariableName)].
        ^selectors
!

whoDefinesMethod: aSelector 
        | sprClass |
        (self directlyDefinesMethod: aSelector) ifTrue: [^self].
        sprClass := self superclass.
        ^sprClass isNil 
                ifTrue: [nil]
                ifFalse: [sprClass whoDefinesMethod: aSelector]
! !

!RBAbstractClass methodsFor:'printing'!

printOn: aStream 
        aStream nextPutAll: self name
!

storeOn: aStream 
        aStream nextPutAll: self name
! !

!RBAbstractClass methodsFor:'private'!

addSubclass: aRBClass 
        self subclasses add: aRBClass
!

privateInstanceVariableNames
        instanceVariableNames isNil 
                ifTrue: 
                        [self isDefined 
                                ifTrue: [self instanceVariableNames: self realClass instVarNames]
                                ifFalse: [instanceVariableNames := OrderedCollection new]].
        ^instanceVariableNames
!

superclass: aRBClass 
        self superclass notNil ifTrue: [self superclass removeSubclass: self].
        superclass := aRBClass.
        superclass notNil ifTrue: [superclass addSubclass: self].
! !

!RBAbstractClass methodsFor:'queries'!

whichCategoryIncludesSelector:aSymbol

    |  realMethod |
    realClass isNil ifTrue:[ ^ #'as yet unlassified' ].
    realMethod := realClass compiledMethodAt: aSymbol.
    realMethod isNil ifTrue:[ ^ #'as yet unlassified' ].
    ^realMethod category

    "Created: / 16-02-2012 / 16:40:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

whichClassIncludesSelector:aSymbol
    ^realClass notNil 
        ifTrue:[realClass whichClassIncludesSelector:aSymbol]
        ifFalse:[nil].

    "Created: / 17-02-2012 / 00:05:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'testing'!

definesClassVariable: aSymbol 
        (self directlyDefinesClassVariable: aSymbol) ifTrue: [^true].
        ^self superclass notNil 
                and: [self superclass definesClassVariable: aSymbol]
!

definesInstanceVariable: aString 
        (self directlyDefinesInstanceVariable: aString) ifTrue: [^true].
        ^self superclass notNil 
                and: [self superclass definesInstanceVariable: aString]
!

definesMethod: aSelector 
        (self directlyDefinesMethod: aSelector) ifTrue: [^true].
        ^self superclass notNil and: [self superclass definesMethod: aSelector]
!

definesPoolDictionary: aSymbol 
        (self directlyDefinesPoolDictionary: aSymbol) ifTrue: [^true].
        ^self inheritsPoolDictionaries and: 
                        [self superclass notNil 
                                and: [self superclass definesPoolDictionary: aSymbol]]
!

definesVariable: aVariableName 
        ^(self definesClassVariable: aVariableName) 
                or: [self definesInstanceVariable: aVariableName]
!

directlyDefinesClassVariable: aString 
        self subclassResponsibility
!

directlyDefinesInstanceVariable: aString 
        ^self instanceVariableNames includes: aString
!

directlyDefinesMethod: aSelector 
        self isDefined 
                ifTrue: 
                        [(self hasRemoved: aSelector) ifTrue: [^false].
                        (self realClass includesSelector: aSelector) ifTrue: [^true]].
        ^newMethods notNil and: [newMethods includesKey: aSelector]
!

directlyDefinesPoolDictionary: aString 
        self subclassResponsibility
!

directlyDefinesVariable: aVariableName 
        ^(self directlyDefinesClassVariable: aVariableName) 
                or: [self directlyDefinesInstanceVariable: aVariableName]
!

hasRemoved: aSelector 
        ^removedMethods notNil and: [removedMethods includes: aSelector]
!

hierarchyDefinesClassVariable: aString 
        (self definesClassVariable: aString) ifTrue: [^true].
        ^(self allSubclasses 
                detect: [:each | each directlyDefinesClassVariable: aString]
                ifNone: [nil]) notNil
!

hierarchyDefinesInstanceVariable: aString 
        (self definesInstanceVariable: aString) ifTrue: [^true].
        ^(self allSubclasses 
                detect: [:each | each directlyDefinesInstanceVariable: aString]
                ifNone: [nil]) notNil
!

hierarchyDefinesMethod: aSelector 
        (self definesMethod: aSelector) ifTrue: [^true].
        ^self subclassRedefines: aSelector
!

hierarchyDefinesPoolDictionary: aString 
        (self definesPoolDictionary: aString) ifTrue: [^true].
        ^(self allSubclasses 
                detect: [:each | each directlyDefinesPoolDictionary: aString]
                ifNone: [nil]) notNil
!

hierarchyDefinesVariable: aString 
        (self definesVariable: aString) ifTrue: [^true].
        ^(self allSubclasses 
                detect: [:each | each directlyDefinesVariable: aString]
                ifNone: [nil]) notNil
!

includesClass: aRBClass 
        | currentClass |
        currentClass := self.
        [currentClass notNil and: [currentClass ~= aRBClass]] 
                whileTrue: [currentClass := currentClass superclass].
        ^currentClass = aRBClass
!

includesSelector: selector 
    ^self selectors includes: selector

    "Created: / 06-09-2012 / 16:34:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inheritsPoolDictionaries
        ^false
!

isAbstract
    "Returns true if this class is abstract otherwise returns false."
    | isAbstract |

    "Ability to set that this class is abstract or not insead of guessing.
    Also store the value just in the metaclass instance."
    isAbstract := self theMetaclass objectAttributeAt: #isAbstract.
    isAbstract notNil ifTrue: [ 
        ^ isAbstract
    ].

    (self whichSelectorsReferToSymbol: #subclassResponsibility) isEmpty 
        ifFalse: [^true].
    model allReferencesToClass: self do: [:each | ^false].
    "The guess that Im abstract if no ones references my class
    is probably wrong here, but I wont change it, because it can
    break some dependency"
    ^true

    "Modified (format): / 14-12-2014 / 17:41:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

isDefined
        ^self realClass notNil
!

isMeta
        self subclassResponsibility
!

subclassRedefines: aSelector 
        "Return true, if one of your subclasses redefines the method with name, aMethod"

        self allSubclasses 
                do: [:each | (each directlyDefinesMethod: aSelector) ifTrue: [^true]].
        ^false
! !

!RBAbstractClass methodsFor:'variable accessing'!

addInstanceVariable: aString 
        self privateInstanceVariableNames add: aString.
        model addInstanceVariable: aString to: self
!

removeInstanceVariable: aString 
        self privateInstanceVariableNames remove: aString.
        model removeInstanceVariable: aString from: self
!

renameInstanceVariable: oldName to: newName around: aBlock 
        self privateInstanceVariableNames 
                at: (self privateInstanceVariableNames indexOf: oldName asString)
                put: newName asString.
        model 
                renameInstanceVariable: oldName
                to: newName
                in: self
                around: aBlock
!

typeOfClassVariable: aSymbol 
        ^model classNamed: #Object
!

whoDefinesClassVariable: aString 
        | sprClass |
        (self directlyDefinesClassVariable: aString) ifTrue: [^self].
        sprClass := self superclass.
        ^sprClass isNil 
                ifTrue: [nil]
                ifFalse: [sprClass whoDefinesClassVariable: aString]
!

whoDefinesInstanceVariable: aString 
        | sprClass |
        (self directlyDefinesInstanceVariable: aString) ifTrue: [^self].
        sprClass := self superclass.
        ^sprClass isNil 
                ifTrue: [nil]
                ifFalse: [sprClass whoDefinesInstanceVariable: aString]
! !

!RBAbstractClass class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


RBAbstractClass initialize!
