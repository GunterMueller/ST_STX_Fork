"{ Package: 'stx:goodies/ring/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RGClassDefinitionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Ring-Core-Kernel-Tests'
!

RGClassDefinitionTest comment:'SUnit tests for class definitions'
!

!RGClassDefinitionTest methodsFor:'testing'!

testAddingMethods
    | newMethod newClass |
    
    newClass:= RGClassDefinition named:  #OrderedCollection.
    newMethod:= (RGMethodDefinition named: #add:)
                     parent: newClass;
                    protocol: 'adding';
                    sourceCode: 'add: newObject
                                    ^self addLast: newObject'.
    
    self assert: (newMethod isMetaSide not).
    self assert: (newClass hasMethods not).

    newClass addMethod: newMethod.
    newClass addSelector: #size 
               classified: 'accessing' 
               sourced: 'fakeMethod
                            ^lastIndex - firstIndex + 1'.
    
    self assert: (newClass hasMethods).
    self assert: (newClass selectors size == 2).
    self assert: (newClass selectors includesAll: #(add: size)).
    self assert: (newClass includesSelector: #add:).
    self assert: ((newClass methodNamed: #add:) = newMethod).
    self assert: (newClass methods size = 2).
    self assert: (newClass selectors size = 2).
    self assert: (newClass allSelectors size = 2).  "no hierarchy"

    newMethod:= newClass methodNamed: #size.
    self assert: (newMethod parent = newClass).
    
    self assert: ((newClass compiledMethodNamed: #size) notNil).
    self assert: ((newClass compiledMethodNamed: #fakeMethod) isNil)

    "Modified: / 29-08-2015 / 08:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAsClassDefinition
    | newClass |

    newClass:= OrderedCollection asRingDefinition.
    
    self assert: (newClass isRingObject).
    self assert: (newClass isClass).  
    self assert: (newClass name == #OrderedCollection).  
    self assert: (newClass category notNil).
    self assert: (newClass superclassName notNil).
    
    self assert: (newClass theMetaClass isRingObject).
    self assert: (newClass theMetaClass isClass).
!

testAsClassDefinition2

    | newClass |
    newClass:= Class asRingDefinition.
    
    self assert: (newClass isRingObject).
    self assert: (newClass isClass).  
    self assert: (newClass name == #Class).  
    self assert: (newClass category notNil).
    self assert: (newClass superclassName notNil).
"/    self assert: (newClass  traitCompositionSource = 'TClass').
    
    self assert: (newClass theMetaClass isRingObject).
    self assert: (newClass theMetaClass isClass).
"/    self assert: (newClass theMetaClass traitCompositionSource = 'TClass classTrait').

    "Modified: / 29-08-2015 / 08:05:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAsClassDefinitionSourceDefinition

    | newClass |
    newClass:= Class asRingDefinition.
    self assert: (newClass definitionSource = '"{ Package: ''stx:libbasic'' }"

"{ NameSpace: Smalltalk }"

ClassDescription subclass:#Class
        instanceVariableNames:''name category classvars comment subclasses classFilename package
                revision environment signature attributes''
        classVariableNames:''DefaultCategoryForSTV DefaultCategoryForVAGE
                DefaultCategoryForDolphin ValidateSourceOnlyOnce ValidatedClasses
                SubclassCacheSequenceNumber
                DefaultCategoryForUncategorizedClasses
                DefaultCategoryForUndeclaredClasses''
        poolDictionaries:''''
        category:''Kernel-Classes''
').
    
    self assert: (newClass theMetaClass definitionSource= 'Class class instanceVariableNames:''''

"
 No other class instance variables are inherited by this class.
"
').

    "Modified (format): / 29-08-2015 / 08:07:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAsRingDefinition
    self assert: OrderedCollection asRingDefinition asRingDefinition isRingObject
!

testClassEquality
    | newClass |
    
    self assert: OrderedCollection asRingDefinition = OrderedCollection asRingDefinition.
    
    newClass := (OrderedCollection asRingDefinition)
        category: #Kernel.
    self assert: (OrderedCollection asRingDefinition = newClass) 
!

testExistingClass
    | newClass metaClass |
    
    newClass:= RGClassDefinition named:  #OrderedCollection.
    self assert: (newClass isClass).
    self assert: (newClass isDefined).
    self assert: (newClass realClass = OrderedCollection).
    self assert: (newClass isMeta not).
    
    newClass withMetaclass.
    self assert: (newClass hasMetaclass).
    metaClass:= newClass theMetaClass.
    self assert: (metaClass isMeta).
    self assert: (metaClass name = 'OrderedCollection class').
    self assert: (metaClass theNonMetaClass = newClass).
    self assert: (metaClass realClass = OrderedCollection class).
!

testNewClass
    | newClass |

    newClass:= RGClassDefinition newClass.

    self assert: (newClass isRingObject).
    self assert: (newClass isClass).  
    self assert: (newClass name isNil).
    self assert: (newClass theMetaClass notNil).
    self assert: (newClass theMetaClass isMetaclass).
    self assert: (newClass theMetaClass name isNil).

    newClass name: 'NewClass'.         
    self assert: (newClass name = 'NewClass').
    self assert: (newClass theMetaClass name = 'NewClass class').

    "Created: / 29-08-2015 / 12:02:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testNonExistingClass
    | newClass |
    
    newClass:= RGClassDefinition named:  #Connection.
    self assert: (newClass isClass).
    self assert: (newClass instanceVariables isEmpty).
    self assert: (newClass classVariables isEmpty).
    self assert: (newClass sharedPools isEmpty).
    self assert: (newClass hasMetaclass not).
    self assert: (newClass hasComment not).
    self assert: (newClass hasStamp not).
    self assert: (newClass parent = Smalltalk globals).
    self assert: (newClass package isNil).
    self assert: (newClass category isNil).
    self assert: (newClass hasMethods not).
    self assert: (newClass hasSuperclass not).
    self assert: (newClass hasTraitComposition not).
    self assert: (newClass isDefined not).
    self assert: (newClass hasProtocols not).
    
    
!

testReadFrom
    "self debug: #testReadFrom"
    
    
    | st rg |
    rg := Point asRingDefinition.
    st := String streamContents: [:s |
        rg storeOn: s.
        s contents].
    self assert: (Object readFrom: st) = rg. 
    
    rg := Point class asRingDefinition.
    st := String streamContents: [:s |
        rg storeOn: s.
        s contents].
    self assert: (Object readFrom: st) = rg 
!

testRemovingMethods
    | newMethod newClass |
    
    newClass:= RGClassDefinition named: #OrderedCollection.
    newMethod:= (RGMethodDefinition named: #add:)
                    parent: newClass;
                    protocol: 'adding';
                    sourceCode: 'add: newObject
                                    ^self addLast: newObject'.
    self assert: (newClass hasMethods not).

    newClass addMethod: newMethod.
    newClass addSelector: #size 
               classified: 'accessing' 
               sourced: 'size
                            ^ lastIndex - firstIndex + 1'.
    
    self assert: (newClass selectors = #(add: size)).
    newClass removeSelector: #join:.
    self assert: (newClass selectors = #(add: size)).
    newClass removeMethod: newMethod.
    self assert: ((newClass includesSelector: #add:) not).
    newClass removeSelector: #size.
    self assert: (newClass hasMethods not).
!

testStoreOn
    "self debug: #testStoreOn"
    
    
    | st |
    st := String streamContents: [:s |
        
        (Point) asRingDefinition storeOn: s.
        s contents].
    self assert: st = '(RGClassDefinition named: #Point)'.
    
    st := String streamContents: [:s |
        
        (Point class) asRingDefinition storeOn: s.
        s contents].
    self assert: st = '((RGMetaclassDefinition named: #''Point class'') baseClass:(RGClassDefinition named: #Point))'
!

testWithCategory
    | newClass |
    
    newClass:= (RGClassDefinition named:  #Object)
                        category: 'Kernel-Objects';
                        yourself.

    self assert: (newClass package isNil).
    self assert: (newClass category = 'Kernel-Objects').
!

testWithClassInstanceVariables
    | newClass metaClass classInstVar |
    
    newClass:= RGClassDefinition named:  #GenericException.
    newClass withMetaclass.
    metaClass:= newClass theMetaClass.
    metaClass addInstanceVariables: #(NotifierString).
    
    self assert: (metaClass instanceVariables size = 1).
    self assert: (metaClass instVarNames size = 1).
    self assert: (metaClass allInstVarNames size = 1).
    
    classInstVar:= metaClass instanceVariableNamed: #NotifierString.
    self assert: (classInstVar notNil).
    self assert: (classInstVar parent = metaClass).
    self assert: (classInstVar isClassInstanceVariable).
    self assert: (classInstVar isVariable).
    self assert: (classInstVar parentName = metaClass name).
    self assert: (classInstVar realClass = GenericException class).
    
    metaClass removeInstVarNamed: #NotifierString.
    self assert: (metaClass instanceVariables isEmpty).
    self assert: ((metaClass instanceVariableNamed: #NotifierString) isNil).

    "Modified: / 29-08-2015 / 10:28:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testWithClassVariables
    | newClass classVar |
    
    newClass:= (RGClassDefinition named: #Object)
                        addClassVariables: #(DependentsFields);
                        addClassVarNamed: #FakeVariable;
                        yourself.

    self assert: (newClass classVariables size = 2).
    self assert: (newClass classVarNames size = 2).
    self assert: (newClass allClassVarNames size = 2).  "no hierarchy"
    
    classVar:= newClass classVarNamed: #DependentsFields.
    self assert: (classVar notNil).
    self assert: (classVar isClassVariable).
    self assert: (classVar isVariable).
    self assert: (classVar parent = newClass).
    self assert: (classVar parentName == newClass name).
    self assert: (classVar realClass = Object).
    
    newClass withMetaclass.
    self assert: (newClass theMetaClass allClassVarNames size = 2).
    
    newClass removeClassVarNamed: #DependentsFields.
    self assert: (newClass classVariables size = 1).
!

testWithComment
    | newClass newComment |
    
    newClass:= RGClassDefinition named: #Object.
    newComment:= RGCommentDefinition new
                        parent: newClass;
                        content: 'This is a comment for test';
                        stamp: 'VeronicaUquillas 3/22/2011 14:51';
                        yourself.
    newClass comment: newComment.

    self assert: (newClass hasComment).
    self assert: (newClass hasStamp).
    self assert: (newClass = newComment parent).
    self assert: (newComment content = 'This is a comment for test').
    self assert: (newComment author = 'VeronicaUquillas').
    self assert: (newComment timeStamp = '3/22/2011 14:51' asDateAndTime).
    
    newClass comment: nil.
    self assert: (newClass hasComment not).
    
    newClass comment:  'This is a comment for test';
              stamp: 'VeronicaUquillas 3/22/2011 14:51'.
    
    self assert: (newClass comment isRingObject).
!

testWithDefaultNamespace
    | newClass |
    
    newClass:= RGClassDefinition named:  #Object.

    self assert: (newClass parent = Smalltalk globals).
    self assert: (newClass realClass = Object).
!

testWithInstanceVariables
    | newClass instVar |
    
    newClass:= RGClassDefinition named: #OrderedCollection.
    newClass addInstanceVariables: #(array firstIndex).
    newClass addInstVarNamed: #lastIndex.
    
    self assert: (newClass instanceVariables size = 3).
    self assert: (newClass instVarNames size = 3).
    self assert: (newClass allInstVarNames size = 3).
    
    instVar:= newClass instanceVariableNamed: #firstIndex.
    self assert: (instVar notNil).
    self assert: (instVar parent = newClass).
    self assert: (instVar isInstanceVariable).
    self assert: (instVar isVariable).
    self assert: (instVar parentName == newClass name).
    self assert: (instVar realClass = OrderedCollection).
    
    newClass removeInstVarNamed: #array.
    self assert: (newClass instanceVariables size = 2).
    self assert: ((newClass instanceVariableNamed: #array) isNil).
    
!

testWithPoolDictionaries
    | newClass poolVar |
    
    newClass:= (RGClassDefinition named:  #Text)
                        addSharedPoolNamed: #TextConstants;
                        yourself.

    self assert: (newClass sharedPools size = 1).
    self assert: (newClass sharedPoolNames size = 1).
    self assert: (newClass allSharedPools size = 1).  "no hierarchy"
    self assert: (newClass allSharedPoolNames size = 1).
    
    poolVar:= newClass sharedPoolNamed: #TextConstants.
    self assert: (poolVar notNil).
    self assert: (poolVar isPoolVariable).
    self assert: (poolVar isVariable).
    self assert: (poolVar parent = newClass).
    self assert: (poolVar parentName == newClass name).
    self assert: (poolVar realClass = Text).
    
    newClass withMetaclass.
    self assert: (newClass theMetaClass allSharedPoolNames size = 1).
    
    newClass removeSharedPoolNamed: #TextConstants.
    self assert: (newClass sharedPools isEmpty).
!

testWithProtocols
    | newMethod newClass |
    
    newClass:= RGClassDefinition named: #OrderedCollection.
    newMethod:= (RGMethodDefinition named: #add:)
                     parent: newClass;
                    protocol: 'adding'; 
                    sourceCode: 'add: newObject
                                    ^self addLast: newObject'.
    
    newClass addMethod: newMethod.
    newClass addProtocol: 'accessing'.
    
    self assert: (newClass hasProtocols).
    self assert: (newClass protocols size = 2).
    self assert: (newClass includesProtocol: 'accessing').
    self assert: ((newClass methodsInProtocol: 'adding') size = 1).
    self assert: ((newClass methodsInProtocol: 'accessing') isEmpty)
!

testWithSuperclass
    | newClass supClass  |
    
    supClass:= (RGClassDefinition named:  #Object)
                        superclassName: #ProtoObject;
                        yourself.

    self assert: (supClass hasSuperclass not).
    self assert: (supClass superclassName == #ProtoObject).   "kept as annotation"
    self assert: (supClass annotations size = 1).
    
    newClass := (RGClassDefinition named: #OrderedCollection) superclass: supClass.
    self assert: (newClass superclass = supClass).
    self assert: (newClass superclassName == #Object).
    self assert: (newClass withAllSuperclasses size = 2).
    self assert: (newClass allSuperclasses size = 1).
    
    self assert: (supClass subclasses size = 1).
    self assert: (supClass withAllSubclasses size = 2).
    self assert: (supClass allSubclasses size = 1).
! !

