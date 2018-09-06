"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"!

!AddClassChange methodsFor:'private'!

argumensBySelectorPartsFromMessage: aMessageNode
    "Returns message arguments as dictionary indexed by selector part name.
    For example: sel01:arg01 sel02:arg02 should be indexed 
    'sel01:' -> 'arg01',
    'sel02:' -> 'arg02' "
    | argumensBySelectorParts selectorParts |

    argumensBySelectorParts := Dictionary new.
    selectorParts := aMessageNode selectorParts ? #().
    aMessageNode arguments ? #() keysAndValuesDo: [ :key :argument |
        | part |

        part := selectorParts at: key ifAbsent: key.
        part == key ifFalse: [ 
            "We found appropriate selector part"
            part := part value asSymbol
        ].
        argumensBySelectorParts at: part put: argument.    
    ].

    ^ argumensBySelectorParts

    "Created: / 16-11-2014 / 14:47:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!AddClassChange methodsFor:'accessing'!

package

    ^ package

    "Created: / 09-10-2014 / 23:45:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!AddClassChange methodsFor:'accessing'!

package: aPackageName

    package := aPackageName

    "Created: / 08-10-2014 / 20:07:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!AddClassChange methodsFor:'accessing'!

privateInClassName
    "Returns privateIn class name (when this class is a private class of another class)"

    ^ self objectAttributeAt: #privateInClassName

    "Created: / 16-11-2014 / 14:18:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!AddClassChange methodsFor:'accessing'!

privateInClassName:aClassName
    "see privateInClassName"

    self objectAttributeAt: #privateInClassName put: aClassName

    "Created: / 16-11-2014 / 14:18:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!AddMethodChange methodsFor:'accessing'!

package: aPackageName    

    package := aPackageName

    "Created: / 08-10-2014 / 19:59:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

allClassVarNames
    | variableNames |

    variableNames := self allClassVariableNames.

    variableNames isNil ifTrue: [ 
        ^ #()
    ].

    ^ variableNames

    "Created: / 01-06-2014 / 23:40:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 20-09-2014 / 19:26:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'enumerating'!

allSuperclassesDo: aBlock
    | superclass |

    superclass := self superclass.

    superclass notNil ifTrue: [ 
        superclass withAllSuperclassesDo: aBlock
    ].

    "Created: / 21-04-2014 / 19:15:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 14:42:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'method accessing'!

compileMethod: anRBMethod
    "Creates new method for this class with RBClass"
    | change method newSource |

    newSource := anRBMethod newSource.

    change := model 
        compile: newSource
        in: self
        classified: anRBMethod category.

    change package: anRBMethod package.

    method := anRBMethod deepCopy 
        source: newSource;
        category: anRBMethod category;
        package: anRBMethod package;
        model: self model;
        modelClass: self;
        yourself.

    self addMethod: method.

    ^ change

    "Created: / 10-10-2014 / 11:37:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 13:08:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing - classes'!

compilerClass
    "Answer a class suitable for compiling a source code in 'my' language"

    ^ self realClass isNil ifTrue: [
        "Return Smalltalk compiler, because we do not have multiple programming
        support in this class (yet)"
        self class compilerClass
    ] ifFalse: [ 
        self realClass compilerClass
    ]

    "Created: / 15-11-2014 / 16:58:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'queries'!

inheritsFrom: aClass

    ^ self isSubclassOf: aClass.

    "Created: / 11-10-2014 / 00:25:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'enumerating'!

instAndClassMethodsDo:aOneArgBlock
    "see Behavior >> instAndClassMethodsDo:"

    self theNonMetaclass methodsDo:aOneArgBlock.
    self theMetaclass methodsDo:aOneArgBlock.

    "Created: / 01-11-2014 / 21:35:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

instVarNames
    "Returns instance variable names - STX compatibility"

    ^ self instanceVariableNames

    "Created: / 29-05-2014 / 23:46:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 24-09-2014 / 20:36:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 30-09-2014 / 19:30:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

instVarNames: aCollectionOfStrings 
    "Set instance variable names - STX compatibility"

    self instanceVariableNames: aCollectionOfStrings

    "Created: / 30-09-2014 / 19:30:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

isAbstract: aBoolean
    "see isAbstract"

    self theMetaclass isNil ifTrue: [ 
        self error: 'This class is not defined in the model.'
    ].

    self theMetaclass objectAttributeAt: #isAbstract put: aBoolean

    "Created: / 14-12-2014 / 16:39:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-12-2014 / 18:12:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'autoload check'!

isLoaded
    "Returns true when the class is auto-loaded.
    see Metaclass >> isLoaded"

    ^ self class isLoaded

    "Created: / 15-11-2014 / 17:11:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'queries'!

isSubclassOf: aClass
    "see Behavior >> isSubclassOf: ( same purpose, but for model class )"

    self allSuperclassesDo: [ :superclass |
        "we are testing name here, because the class 
        can be from another namespace"
        ((superclass name) = (aClass name)) ifTrue: [ 
            ^ true
        ]
    ].

    ^ false

    "Created: / 11-10-2014 / 00:16:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

methodDictionary
    "Stub method, returns real class MethodDictionary, although full MethodDictionary
    implementation would be better here."

    | methodDictionary |

    methodDictionary := MethodDictionary new.

    self realClass notNil ifTrue: [
        self realClass methodDictionary do: [ :method | 
            methodDictionary := methodDictionary 
                at: method selector asSymbol 
                putOrAppend: (RBMethod 
                    for: self 
                    fromMethod: method 
                    andSelector: method selector asSymbol)
        ].
    ].

    removedMethods notNil ifTrue: [
        removedMethods do: [ :removedMethod | 
            | method |

            method := methodDictionary at: removedMethod asSymbol ifAbsent: [ nil ].  
            method notNil ifTrue: [
                methodDictionary := methodDictionary removeKeyAndCompress: removedMethod asSymbol.
            ]
        ]
    ].

    newMethods notNil ifTrue: [
        newMethods do: [ :newMethod |
            methodDictionary := methodDictionary at: newMethod selector asSymbol putOrAppend: newMethod.
        ]
    ].

    ^ methodDictionary

    "Created: / 28-09-2014 / 22:57:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 14:42:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-05-2015 / 16:07:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'enumerating'!

methodsDo:aOneArgBlock
    "see Behavior >> methodsDo:"

    self methodDictionary do:aOneArgBlock

    "Created: / 02-11-2014 / 09:47:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

nameWithoutPrefix
    "see ClassDescription >> nameWithoutPrefix"

    ^ (Smalltalk at: #Class) nameWithoutPrefix: name

    "Created: / 03-08-2014 / 23:29:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 20-09-2014 / 19:21:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

owningClass
    "see Behavior >> owningClass"

    ^ self theMetaclass owningClass

    "Created: / 29-11-2014 / 13:17:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

owningClass: aClass
    "Sets the owning class which is actually stored in the metaclass"

    self theMetaclass owningClass: aClass

    "Created: / 29-11-2014 / 13:21:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'queries'!

owningClassOrYourself
    "see Behavior >> owningClassOrYourself"

    self owningClass notNil ifTrue:[^ self topOwningClass].
    ^ self

    "Created: / 29-11-2014 / 13:44:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

package
    "see Class >> package ( same purpose, but for model class )"
    | package |

    package := self objectAttributeAt: #package.

    (package isNil and: [ self realClass notNil ]) ifTrue: [ 
        package := self realClass package.
    ].

    ^ package

    "Created: / 09-10-2014 / 23:12:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

package: aPackage

    self objectAttributeAt: #package put: aPackage

    "Created: / 09-10-2014 / 23:12:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

privateClassesAt:aClassNameStringOrSymbol
    "see Class >> privateClassesAt:"

    | myName privateClassName |

    myName := self name.
    myName isNil ifTrue:[
        "/ no name - there cannot be a corresponding private class
        ^ nil
    ].

    privateClassName := (myName, '::' ,aClassNameStringOrSymbol) asSymbol.

    ^ model classNamed: privateClassName.

    "Created: / 15-11-2014 / 17:15:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 11:49:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

programmingLanguage
    "Answer a language instance in which is this class programmed"

    ^ self realClass isNil ifTrue: [
        "Return Smalltalk language, because we do not have multiple programming
        support in this class (yet)"
        self class programmingLanguage
    ] ifFalse: [ 
        self realClass programmingLanguage
    ]

    "Created: / 22-12-2014 / 20:43:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

realSharedPoolNames
    "see Behavior >> realSharedPoolNames"

    ^ #()

    "Created: / 15-11-2014 / 17:19:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 16:37:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'method accessing'!

sourceCodeAt: aSelector
    "see Behavior >> sourceCodeAt:"

    ^ self sourceCodeFor: aSelector

    "Created: / 31-01-2015 / 19:05:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

superclassName: aName
    "Assign superclass by its name"

    self superclass: (self model classNamed: aName asSymbol)

    "Created: / 28-09-2014 / 22:53:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

theMetaclass
    "alias for theMetaClass - STX compatibility"

    ^ self theMetaClass.

    "Created: / 26-09-2014 / 16:26:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'accessing'!

theNonMetaclass
    "alias for theNonMetaClass - STX compatibility"

    ^ self theNonMetaClass

    "Created: / 26-09-2014 / 16:36:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'queries'!

topNameSpace
    "see ClassDescription >> topNameSpace"

    ^ self model

    "Created: / 15-11-2014 / 17:26:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 16-11-2014 / 16:58:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'queries'!

topOwningClass
    "see Behavior >> topOwningClass"

    ^ self theMetaclass topOwningClass

    "Created: / 29-11-2014 / 13:48:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBAbstractClass methodsFor:'enumerating'!

withAllSuperclassesDo:aBlock
    "evaluate aBlock for the class and all of its superclasses"

    aBlock value:self.
    self allSuperclassesDo:aBlock

    "Created: / 29-09-2014 / 22:48:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBClass methodsFor:'compiling'!

compile
    "Updates class definition in the namespace along with code changes"
    | change newClass |

    change := model defineClass: self definitionString.
    change package: self package.

    (model respondsTo: #putModelClass:) ifTrue: [
        model putModelClass: self  
    ] ifFalse: [ 
        newClass := model classNamed: self name.
        newClass package: self package
    ].

    ^ change

    "Created: / 25-09-2014 / 22:31:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-11-2014 / 00:06:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBClass methodsFor:'accessing'!

theNonMetaClass
    "alias for theNonMetaclass - squeak compatibility"

    ^ self theNonMetaclass

    "Created: / 26-09-2014 / 16:50:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMetaclass methodsFor:'accessing'!

owningClass
    "see PrivateMetaclass >> owningClass"
    | owningClass |

    owningClass := self objectAttributeAt: #owningClass.
    owningClass isNil ifTrue: [ 
        self realClass notNil ifTrue: [ 
            ^ self model classFor: self realClass owningClass
        ]
    ].

    ^ owningClass.

    "Created: / 29-11-2014 / 02:20:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMetaclass methodsFor:'accessing'!

owningClass: aClass
    "see owningClass"

    self 
        objectAttributeAt: #owningClass 
        put: (self model classFor: aClass theNonMetaclass)

    "Created: / 29-11-2014 / 02:23:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-11-2014 / 13:38:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMetaclass methodsFor:'accessing'!

theMetaClass
    "alias for metaclass - sqeak compatibility"

    ^ self metaclass.

    "Created: / 26-09-2014 / 21:32:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMetaclass methodsFor:'accessing'!

theMetaclass
    "alias for metaclass - STX compatibility"

    ^ self metaclass.

    "Created: / 26-09-2014 / 21:28:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMetaclass methodsFor:'queries'!

topOwningClass
    "see PrivateMetaclass >> topOwningClass"

    self owningClass isNil ifTrue:[^ nil].

    self owningClass owningClass notNil ifTrue:[
        ^ self owningClass topOwningClass
    ].
    ^ self owningClass

    "Created: / 29-11-2014 / 13:52:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:24:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

category: aCategoryName
    "Sets in which category/protocol does the method belongs within a class"

    self objectAttributeAt: #category put: aCategoryName.

    "Created: / 06-10-2014 / 07:54:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

class: aClass
    "Helper for enabling usage of either real class or RBClass"

    self modelClass: (self model classFor: aClass)

    "Created: / 05-10-2014 / 21:04:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 08-11-2014 / 13:26:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'compiling'!

compile
    "Modifies/adds method in the model class."

    ^ self modelClass compileMethod: self

    "Created: / 06-10-2014 / 11:11:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 12:28:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

mclass
    "see Method >> mclass
    Returns instace of RBClass, RBMetaclass or nil when unknown"

    ^ self modelClass

    "Created: / 27-11-2014 / 23:20:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

methodArgNames
    "Returns collection of method argument names"

    | methodNode arguments |

    methodNode := RBParser 
        parseMethod: self source 
        onError: [ :str :pos | 
            self error: 'Cannot parse: ', str, ' at pos: ', pos asString 
        ].    

    "Transform arguments to what Method returns - keep compatibility"
    arguments := methodNode arguments.

    arguments isEmptyOrNil ifTrue: [ 
        ^ nil
    ].

    ^ Array streamContents: [ :s |
        arguments do: [ :argument |
            s nextPut: argument name
        ]  
    ]

    "Created: / 07-10-2014 / 20:18:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:35:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'queries'!

methodDefinitionTemplate
    "see Method >> methodDefinitionTemplate"

    ^ Method
        methodDefinitionTemplateForSelector:self selector
        andArgumentNames:self methodArgNames

    "Created: / 07-10-2014 / 20:18:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

model

    ^ self objectAttributeAt: #model

    "Created: / 05-10-2014 / 20:33:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

model: anRBSmalltalk

    self objectAttributeAt: #model put: anRBSmalltalk

    "Created: / 05-10-2014 / 20:32:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

newSource
    "Returns new source code with performed modifications by CodeGenerator
    ( replace: something with: anotherthing and custom formatting)."
    | newSource generator |

    newSource := self source.
    generator := self sourceCodeGenerator.
    generator notNil ifTrue: [ 
        generator source: newSource.
        newSource := generator newSource.
    ].

    "Fixes test CustomRBMethodTests >> test_compile_with_code_generator
    when none selector and method is given then parse the selector from new source code"
    (selector isNil and: [ compiledMethod isNil ] and: [ newSource notNil ]) ifTrue: [ 
        selector := (Parser parseMethodSpecification: newSource) selector
    ].

    ^ newSource

    "Created: / 10-10-2014 / 12:23:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 10-10-2014 / 15:31:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

package: aPackage

    self objectAttributeAt: #package put: aPackage

    "Created: / 10-10-2014 / 11:12:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'compiler interface'!

programmingLanguage
    "see CompiledCode >> programmingLanguage"

    self method notNil ifTrue: [ 
        ^ self method programmingLanguage
    ].

    self mclass notNil ifTrue: [ 
        ^ self mclass programmingLanguage
    ].

    "None programming language found, assume Smalltalk as default"
    ^ SmalltalkLanguage instance

    "Created: / 26-12-2014 / 11:59:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

protocol
    "Returns in which category/protocol does the method belongs within a class"

    ^ self category

    "Created: / 06-10-2014 / 07:46:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

protocol: aProtocolName
    "Sets in which category/protocol does the method belongs within a class"

    self category: aProtocolName.

    "Created: / 06-10-2014 / 07:56:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

replace: placeholder with: code

    self sourceCodeGenerator replace: placeholder with: code

    "Created: / 06-10-2014 / 08:58:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'queries'!

sends:selectorSymbol1 or:selectorSymbol2
    "Returns true, if this method contains a message-send
     to either selectorSymbol1 or selectorSymbol2.
     ( non-optimized version of Message>>sends:or: )"

    ^ (self sendsSelector: selectorSymbol1) or: [ self sendsSelector: selectorSymbol2 ]

    "Created: / 04-10-2014 / 00:01:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

sourceCodeGenerator
    "Returns helper tool for method source code manipulation like formatting and search & replace"

    ^ self objectAttributeAt: #sourceCodeGenerator

    "Created: / 06-10-2014 / 08:33:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RBMethod methodsFor:'accessing'!

sourceCodeGenerator: aSourceCodeGenerator
    "Set ... see method sourceCodeGenerator"

    ^ self objectAttributeAt: #sourceCodeGenerator put: aSourceCodeGenerator

    "Created: / 06-10-2014 / 08:37:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RefactoryChange methodsFor:'accessing'!

model
    "Returns reference to RBNamespace for retrieving model classes (RBClass, RBMetaclass)"

    ^ self objectAttributeAt: #model

    "Created: / 08-11-2014 / 14:00:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!RefactoryChange methodsFor:'accessing'!

model: aModel
    "see model"

    self objectAttributeAt: #model put: aModel

    "Created: / 08-11-2014 / 14:00:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus extensions-custom refactorings'!

classMenuExtensionCustomGenerators:aMenu 
    <menuextension: #classMenu>

    self customMenuBuilder
        perspective: SmallSense::CustomPerspective classPerspective;
        menu: aMenu;
        submenuLabel: 'Generate - Custom';
        afterMenuItemLabelled: 'Generate';
        generatorOrRefactoringFilter: [ :generatorOrRefactoring | generatorOrRefactoring isCustomCodeGenerator ];
        buildMenu.

    "Created: / 26-08-2014 / 10:21:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:08:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:07:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus extensions-custom refactorings'!

classMenuExtensionCustomRefactorings: aMenu 
    <menuextension: #classMenu>

    self customMenuBuilder
        perspective: SmallSense::CustomPerspective classPerspective;
        menu: aMenu;
        submenuLabel: 'Refactor - Custom';
        afterMenuItemLabelled: 'Generate';
        generatorOrRefactoringFilter: [ :generatorOrRefactoring | generatorOrRefactoring isCustomRefactoring ];
        buildMenu.

    "Created: / 08-11-2014 / 21:24:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:08:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:16:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus extensions-custom refactorings'!

classMenuExtensionNavigateToTestCase: aMenu
    "Adds menu item to class list window and tries to guess test case class
    name. If test case class exists then opens a new tab with this class selected."
    <menuextension: #classMenu>

    | item index |

    item := MenuItem label: (resources string: 'Open Test Case Class') 
        itemValue: [ 
            | className testClassName testClass |

            className := self theSingleSelectedClass theNonMetaclass name.

            "/ Try ClassNameTests...
            testClassName := (className, 'Tests') asSymbolIfInterned.
            testClassName notNil ifTrue:[
                testClass := environment at: testClassName ifAbsent: [ nil ].
            ].
            testClass isNil ifTrue: [ 
                "/ Try ClassNameTest...
                testClassName := (className, 'Test') asSymbolIfInterned.
                testClassName notNil ifTrue:[
                    testClass := environment at: testClassName ifAbsent: [ nil ].
                ].
                testClass isNil ifTrue:[ 
                    "Small hack for extension test cases"
                    testClassName := ('SmallSense::Custom', className, 'Tests') asSymbolIfInterned.
                    testClassName notNil ifTrue:[
                        testClass := environment at: testClassName ifAbsent: [ nil ].
                    ].
                ].
            ].

            testClass notNil ifTrue: [ 
                self createBuffer; 
                    switchToClass: testClass;
                    selectProtocol: #tests
            ] ifFalse: [
                | info |

                info := resources stringWithCRs: 'No testcase named %1 or %2 found. Generate?' with: (className, 'Tests') with: (className, 'Test.').
                (Dialog confirm: info) ifTrue:[ 
                    | context |

                    context := SmallSense::CustomBrowserContext 
                                    perspective: SmallSense::CustomPerspective classPerspective
                                    state: navigationState.         
                    SmallSense::CustomTestCaseCodeGenerator new executeInContext: context.  
                ].
            ].                                                         
        ].

    item enabled: [ self theSingleSelectedClass notNil ].

    index := aMenu indexOfMenuItemForWhich:[:each | each label = 'Generate' ].
    index ~~ 0 ifTrue:[
        aMenu addItem:item beforeIndex:index + 1.
    ] ifFalse:[
        aMenu addItem:item.
    ].

    "Created: / 26-12-2014 / 16:54:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 27-12-2014 / 19:01:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2015 / 22:35:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus extensions-custom refactorings'!

codeViewMenuExtensionCustomRefactorings:aMenu 
    <menuextension: #codeViewMenu>

    self customMenuBuilder
        perspective: SmallSense::CustomPerspective codeViewPerspective;
        menu: aMenu;
        submenuLabel: 'Refactor - Custom';
        afterMenuItemLabelled: 'Refactor';
        generatorOrRefactoringFilter: [ :generatorOrRefactoring | generatorOrRefactoring isCustomRefactoring ];
        buildMenu.

    "Created: / 26-08-2014 / 22:44:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:08:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:17:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus extensions-custom refactorings'!

customMenuBuilder
    "Returns initialized instance of CustomMenuBuilder"

    ^ SmallSense::CustomMenuBuilder new
        navigationState: self navigationState;
        resources: resources;
        yourself

    "Created: / 29-12-2014 / 00:04:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:06:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus extensions-custom refactorings'!

selectorMenuExtensionCustomGenerators:aMenu 
    <menuextension: #selectorMenuCompareGenerateDebugSlice>

    self customMenuBuilder
        perspective: SmallSense::CustomPerspective methodPerspective;
        menu: aMenu;
        submenuLabel: 'Generate - Custom';
        afterMenuItemLabelled: 'Generate';
        generatorOrRefactoringFilter: [ :generatorOrRefactoring | generatorOrRefactoring isCustomCodeGenerator ];
        buildMenu.

    "Created: / 26-08-2014 / 10:18:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:08:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:17:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus extensions-custom refactorings'!

selectorMenuExtensionCustomRefactorings:aMenu 
    <menuextension: #selectorMenuCompareGenerateDebugSlice>

    self customMenuBuilder
        perspective: SmallSense::CustomPerspective methodPerspective;
        menu: aMenu;
        submenuLabel: 'Refactor - Custom';
        afterMenuItemLabelled: 'Refactor';
        generatorOrRefactoringFilter: [ :generatorOrRefactoring | generatorOrRefactoring isCustomRefactoring ];
        buildMenu.

    "Created: / 24-08-2014 / 15:23:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:08:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:18:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Tools::NewSystemBrowser methodsFor:'menus extensions-custom refactorings'!

variablesMenuExtensionCustomGenerators:aMenu 
    <menuextension: #variablesMenu>

    self customMenuBuilder
        perspective: SmallSense::CustomPerspective instanceVariablePerspective;
        menu: aMenu;
        submenuLabel: 'Generate - Custom';
        afterMenuItemLabelled: 'Generate';
        buildMenu.

    "Created: / 26-08-2014 / 10:21:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:08:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:09:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_smallsense_refactoring_custom class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
