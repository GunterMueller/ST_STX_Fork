"{ Package: 'stx:goodies/ring/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RGMethodDefinitionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel-Tests'
!

RGMethodDefinitionTest comment:'SUnit tests for method definitions'
!

!RGMethodDefinitionTest methodsFor:'* As yet uncategorized *'!

foo	^ 'second version'
! !

!RGMethodDefinitionTest methodsFor:'testing'!

testAsActive
    | newMethod |

    RGMethodDefinitionTest compile: 'foo        ^ ''first version'''.
    newMethod := (RGMethodDefinitionTest >> #foo) asActiveRingDefinition.
    self assert: newMethod isActive.    
    self assert: newMethod sourceCode = newMethod compiledMethod sourceCode.

    RGMethodDefinitionTest compile: 'foo        ^ ''second version'''.
    self assert: newMethod sourceCode = newMethod compiledMethod sourceCode.
    
    newMethod := (Class >> #asRingDefinition) asActiveRingDefinition.
    newMethod fromActiveToPassive.
    self assert: newMethod isPassive.
    self assert: newMethod sourceCode = (Class >> #asRingDefinition) sourceCode.
    newMethod sourceCode: 'asRingDefinition   ^true'.
    self assert: newMethod sourceCode ~= (Class >> #asRingDefinition) sourceCode.
    
    newMethod := (Class >> #asRingDefinition) asActiveRingDefinition.
    newMethod fromActiveToHistorical.
    self assert: newMethod isHistorical.
    self assert: newMethod sourceCode notNil.

    "Modified: / 29-08-2015 / 08:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAsHistorical
    | firstVersion secondVersion |

    RGMethodDefinitionTest compile: 'foo	^ ''first version'''.
    firstVersion := (RGMethodDefinitionTest >> #foo) asHistoricalRingDefinition.
    self assert: firstVersion isHistorical.
    self assert: firstVersion sourceCode = firstVersion compiledMethod sourceCode.
    self assert: firstVersion stamp = firstVersion compiledMethod timeStamp.

    RGMethodDefinitionTest compile: 'foo	^ ''second version'''.
    secondVersion := (RGMethodDefinitionTest >> #foo) asHistoricalRingDefinition.
    self assert: secondVersion isHistorical.
    self assert: secondVersion sourceCode = secondVersion compiledMethod sourceCode.
    self assert: secondVersion stamp = secondVersion compiledMethod timeStamp.

    self deny: firstVersion sourcePointer = secondVersion sourcePointer.
    self deny: firstVersion sourceCode = secondVersion sourceCode.
!

testAsMethodDefinition
    | newMethod |

    newMethod:= (OrderedCollection >> #size) asRingDefinition.
    
    self assert: (newMethod isRingObject).
    self assert: newMethod parent isNil.
    self assert: (newMethod isMethod).  
    self assert: (newMethod selector == #size).  
    self assert: (newMethod protocol notNil).
    self assert: (newMethod stamp notNil).
!

testAsMethodDefinition2
    "self debug: #testAsMethodDefinition2"
    
    | newMethod |
    newMethod := (Object >> #printOn:) asRingDefinition.
    self assert:  newMethod category = #'printing & storing'.

    "Modified: / 29-08-2015 / 10:26:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAsPassive
    | newMethod |

    RGMethodDefinitionTest compile: 'foo	^ ''first version'''.
    newMethod := (RGMethodDefinitionTest >> #foo) asPassiveRingDefinition.
    self assert: newMethod isPassive.
    self assert: newMethod sourceCode = newMethod compiledMethod sourceCode.

    RGMethodDefinitionTest compile: 'foo	^ ''second version'''.
    self assert: newMethod sourceCode = 'foo	^ ''first version'''.		
    self assert: newMethod compiledMethod sourceCode = 'foo	^ ''second version'''.
!

testClassNameSelectorIsMetaSide
    "self debug: #testClassNameSelectorIsMetaSide"
    
    | rg |
    rg := RGMethodDefinition className: 'Point' selector: #x  isMetaSide: false. 	
    self assert: (rg parentName = 'Point').
    self assert: (rg parent isKindOf:RGClassDefinition).
    self assert: (rg selector = #x).
    self assert: (rg isMetaSide not).
!

testCreatingMethodsWithoutFactory
    | newMethod newClass |

    newMethod := RGMethodDefinition realClass: OrderedCollection selector: 'size'.
    self assert: (newMethod isMethod).  
    self assert: (newMethod selector == #size).  
    self assert: (newMethod protocol notNil).
    self assert: (newMethod sourceCode notEmpty).
    self assert: (newMethod stamp notNil).
    
    newClass := RGClassDefinition named: #OrderedCollection.
    newMethod := RGMethodDefinition class: newClass selector: 'size'.
    self assert: (newMethod isMethod).  
    self assert: (newMethod selector == #size).  
    self assert: (newMethod protocol isNil).
    self assert: (newMethod sourceCode isNil).
    self assert: (newMethod stamp isNil).
    
    newMethod := RGMethodDefinition realClass: OrderedCollection theMetaClass selector: #newFrom:.
    self assert: (newMethod isMethod).  
    self assert: (newMethod selector == #newFrom:).  
    self assert: (newMethod protocol notNil).
    self assert: (newMethod sourceCode notEmpty).
    self assert: (newMethod stamp notNil).

    "Modified: / 29-08-2015 / 10:26:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testCreatingMethodsWithoutFactory2
    | newMethod |

    newMethod := RGMethodDefinition realClass: OrderedCollection.
    self assert: (newMethod selector isNil).
    newMethod source: 'foo: a bar: b ^ a + b'.
    self assert: (newMethod isMethod).

    "Created: / 29-08-2015 / 11:58:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testDifferentObjectButSameMethodInSet
    "self debug: #testDifferentObjectButSameMethodInSet"

    | s rgmethod rgmethod2 |
    s := Set new.
    rgmethod := (OrderedCollection >> #size) asRingDefinition.
    s add: rgmethod. 
    rgmethod2 := (OrderedCollection >> #size) asRingDefinition.
    s add: rgmethod2.
    
    self assert: (s size = 1).
    self assert: (s includes: rgmethod).
    self assert: (s includes: rgmethod2).

    "Modified (format): / 28-08-2015 / 12:18:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testExistingMethodWithClass
    | newMethod newClass |
    
    newClass:=RGClassDefinition named: #OrderedCollection.
    newMethod:= (RGMethodDefinition named: #add:)
                     parent: newClass;
                    protocol: 'adding';
                    sourceCode: 'add: newObject
                                    ^self addLast: newObject'.
                                    
    self assert: (newMethod isMethod).
    self assert: (newMethod selector == #add:).
    self assert: (newMethod isMetaSide not).
    
    self assert: (newMethod parent = newClass).
    self assert: (newMethod parentName == newClass name).
    
    self assert: (newMethod parent parent == Smalltalk globals).
    self assert: (newMethod realClass = OrderedCollection).
    self assert: (newMethod compiledMethod = (OrderedCollection compiledMethodAt: #add:)).
!

testExistingMethodWithPointer
    | newMethod |
    
    newMethod:= (OrderedCollection >> #size) asActiveRingDefinition.
                                    
    self assert: (newMethod parent isNil).
    self assert: (newMethod parentName == #OrderedCollection).
    self assert: (newMethod sourceCode notNil).
    self assert: (newMethod protocol notNil).
    self assert: (newMethod stamp notNil).
    self assert: (newMethod isExtension not)

    "Modified (format): / 28-08-2015 / 12:18:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testExistingMethodWithoutClass
    "its parent class is not assigned only its name"
    | newMethod |
    
    newMethod:= (RGMethodDefinition named: #add:)
                    parentName: #OrderedCollection;
                    selector: #add:; 
                    isMetaSide: false;
                    protocol: 'adding'; 
                    sourceCode: 'add: newObject
                                    ^self addLast: newObject'.
    
    self assert: (newMethod isMethod).
    self assert: (newMethod selector == #add:).
    self assert: (newMethod isMetaSide not).
    self assert: (newMethod protocol = #adding).
    self assert: (newMethod fullName = 'OrderedCollection>>add:').
    self assert: (newMethod sourceCode = 'add: newObject
                                    ^self addLast: newObject').
    self assert: (newMethod hasStamp not).
    self assert: (newMethod parent isNil).
    self assert: (newMethod parentName == #OrderedCollection).
    
    self assert: (newMethod environment == Smalltalk globals).
    self assert: (newMethod realClass = OrderedCollection).
    self assert: (newMethod compiledMethod = (OrderedCollection compiledMethodAt: #add:))
!

testExtensionMethod
    | newMethod newClass newPackage newPackageExt |

    newMethod:= (RGMethodDefinition named: #+)
                    isExtension: true.
    self assert: (newMethod protocol isNil).
    self assert: (newMethod isExtension).

    newMethod:= (Class >> #asRingDefinition) asRingDefinition.    
    self assert: (newMethod isMethod).  
    self assert: (newMethod protocol = '*Ring-Core-Kernel').
    self assert: (newMethod isExtension).
    
    newPackage := RGPackage named: #Package.
    newPackageExt := RGPackage named:  #PackageExtensions.
    newClass := RGClassDefinition named: #Class.
    newMethod := (RGMethodDefinition named: #foo) parent: newClass.
    newPackage addClass: newClass.
    newMethod package: newPackageExt.
    self assert: (newMethod isExtension).

    "Modified: / 29-08-2015 / 10:18:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testMethodEquality

    | newMethod newClass |
    self assert: (OrderedCollection >> #size) asRingDefinition = (OrderedCollection >> #size) asRingDefinition.
    
    newMethod := ((OrderedCollection >> #size) asRingDefinition)
                    sourceCode: 'size
                        ^0'.
    self assert: ((OrderedCollection >> #size) asRingDefinition = newMethod).
    
    newClass:= RGClassDefinition named: #OrderedCollection.
    newMethod:= (RGMethodDefinition named: #size) parent: newClass.
    self assert: ((OrderedCollection >> #size) asRingDefinition = newMethod).
    
    newMethod:= (RGMethodDefinition named: #size) parent: (SortedCollection asRingDefinition).
    self deny: ((OrderedCollection >> #size) asRingDefinition = newMethod).

    "Modified (format): / 28-08-2015 / 12:19:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testNonExistingMethodWithClass
    "method does not exist in OrderedCollection"
    | newMethod newClass |
    
    newClass:= RGClassDefinition named: #OrderedCollection.
    newClass withMetaclass.
    
    newMethod:= (RGMethodDefinition named: #foo) parent: newClass theMetaClass.
    newMethod sourceCode: 'foo
                                    ^true'.
                                    
    self assert: (newMethod isMethod).
    self assert: (newMethod selector == #foo).
    self assert: (newMethod isMetaSide).
    self assert: (newMethod protocol = nil).
    
    self assert: (newMethod parent = newClass theMetaClass).
    self assert: (newMethod parentName = newClass theMetaClass name).
    
    self assert: (newMethod environment == Smalltalk globals).
    self assert: (newMethod realClass = OrderedCollection class).
    self assert: (newMethod compiledMethod isNil).
!

testSameMethodInSet
    "self debug: #testSameMethodInSet"

    | s rgmethod |
    s := Set new.
    rgmethod := (OrderedCollection >> #size) asRingDefinition.
    s add: rgmethod. 
    self assert: (s includes: rgmethod).
    
    s add: rgmethod. 
    self assert: (s size = 1).
    self assert: (s includes: rgmethod).

    "Modified (format): / 28-08-2015 / 12:19:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSorting

    | rgMethod1 rgMethod2 |
    rgMethod1 := RGMethodDefinition realClass: RGInstanceVariableDefinition selector: #isInstanceVariable.
    rgMethod2 := RGMethodDefinition realClass: RGElementDefinition selector: #isMetaSide.
    self assert: rgMethod2 <= rgMethod1.
    
    rgMethod1 := RGMethodDefinition realClass: RGElementDefinition selector: #parentName.
    self assert: rgMethod2 <= rgMethod1. 
    
! !

