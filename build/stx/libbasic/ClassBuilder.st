"
 COPYRIGHT (c) 2001 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ClassBuilder
	instanceVariableNames:'metaclass classClass className environment superClass
		instanceVariableNames flags classVariableNames poolDictionaries
		category comment changed classInstanceVariableNames oldMetaClass
		oldClass oldPoolDictionaries oldSuperClass oldClassVars
		oldInstVars realNewName buildPrivateClass buildingPrivateClass
		nameKey newSuperClass superClassChange newClassVars newInstVars
		newPoolDictionaries classVarChange instVarChange poolChange
		recompileGlobalAccessTo oldClassToBecomeNew oldClassInstVars
		newClassInstVars'
	classVariableNames:'LastNamespaceName LastClassNamesInNameSpace'
	poolDictionaries:''
	category:'Kernel-Support'
!

!ClassBuilder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentaiton
"
    an old, ugly beast.
    instances are temporarily created to figure out,
    which methods and which subclasses need to be recompiled whenever a class's definition
    changes.
    For fast turn around times, it is good to recompile the smallest needed amount.
    (However, in the meantime, so many checks and small-lints and others are watching for
     such changes, that recompilation gets a little slow at times.
     Also, the more browsers you have open, which react and research on changes, 
     the slower you get)

    Code here is ugly and hard to maintain.
    Keep your fingers away...
    "
! !

!ClassBuilder class methodsFor:'change & update'!

initialize
    Smalltalk addDependent:self.

    "Created: / 18-08-2011 / 14:32:27 / cg"
!

update:something with:aParameter from:changedObject
    "keep track of the namespace->classnames cache"

    something == #projectOrganization ifTrue:[^ self].
    something == #classVariables ifTrue:[^ self].
    something == #methodInClass ifTrue:[^ self].

    something == #newClass ifTrue:[
        aParameter nameSpace name = LastNamespaceName ifTrue:[
            LastClassNamesInNameSpace add:aParameter name
        ].
        ^ self.
    ].
    something == #classRemove ifTrue:[
        aParameter nameSpace name = LastNamespaceName ifTrue:[
            LastClassNamesInNameSpace remove:aParameter name ifAbsent:[]
        ].
        ^ self.
    ].

    "/ Transcript show:something.
    "/ Transcript show:' -> '.
    "/ Transcript showCR:aParameter.

    "Created: / 18-08-2011 / 14:32:16 / cg"
! !

!ClassBuilder class methodsFor:'checks'!

checkForAliasesOf:oldClass with:newClass
    "oldClass changed its identity (now use newClass).
     check if there are any global aliases, which should also be changed"

    Smalltalk keysAndValuesDo:[:nm :o |
        o == oldClass ifTrue:[
            nm ~~ oldClass name ifTrue:[
                true "/ (self confirm:('The global/classVar `' , nm , ''' is an alias for ' , oldClass name , '.\\Change it to the new class ?') withCRs)
                ifTrue:[
                    Smalltalk at:nm put:newClass
                ]
            ]
        ]
    ].

    "Modified: / 20-12-2011 / 12:22:42 / cg"
!

differentInstanceVariableOffsetsIn:class1 and:class2
    "return a set of instance variable names which have different
     positions in class1 and class2.
     Also, variables which are only present in one class are returned.
     This is used to find methods which need recompilation after a
     change in the instance variable layout."

    |offsets1 offsets2 changeSet|

    changeSet := Set new.

    "
     collect the instvar-indices in the old and new class
    "
    offsets1 := class1 instanceVariableOffsets.
    offsets2 := class2 instanceVariableOffsets.

    "
     compute the changeset as a set of instance variables, 
     which have a different position
    "
    offsets1 keysAndValuesDo:[:varName :varIndex |
        (offsets2 includesKey:varName) ifFalse:[
            changeSet add:varName 
        ] ifTrue:[
            (varIndex ~~ (offsets2 at:varName)) ifTrue:[
                changeSet add:varName 
            ]
        ]
    ].
    offsets2 keysAndValuesDo:[:varName :varIndex |
        (offsets1 includesKey:varName) ifFalse:[
            changeSet add:varName
        ] ifTrue:[
            (varIndex ~~ (offsets1 at:varName)) ifTrue:[
                changeSet add:varName
            ]
        ]
    ].
    ^ changeSet

    "
     View class 
        differentInstanceVariableOffsetsIn:View
                                       and:StandardSystemView
     View class 
        differentInstanceVariableOffsetsIn:Object 
                                       and:Point 
    "
! !

!ClassBuilder class methodsFor:'recompiling'!

copyInvalidatedMethodsFrom:oldClass for:newClass
    "copy all methods from oldClass to newClass and change their code
     to a trap method reporting an error.
     This is done when a class has changed its layout or inheritance,
     before recompilation is attempted.
     This allows us to keep the source while trapping uncompilable (due to
     now undefined instvars) methods. Later compilation of these methods will show
     an error on the transcript and lead to the debugger once called."

    |trap trapCode trapByteCode oldMethod newMethod
     oldDict newDict|

    oldDict := oldClass methodDictionary.
    newDict := MethodDictionary new:oldDict size.

    oldDict keysAndValuesDo:[ :sel :mthd |
        trap := mthd trapMethodForNumArgs:(mthd numArgs).
        trapCode := trap code.
        trapByteCode := trap byteCode.

        oldMethod := mthd originalMethodIfWrapped.

        newMethod := oldMethod copy.
        newMethod makeInvalid.
        newDict at:sel put:newMethod
    ].

    newClass methodDictionary:newDict.

    "Modified: / 12-06-1996 / 10:44:27 / stefan"
    "Modified: / 22-10-2010 / 11:47:27 / cg"
!

copyInvalidatedMethodsFrom:oldClass for:newClass accessingAny:setOfNames
    "copy all methods from oldClass to newClass. Those methods accessing
     a variable in setOfNames will be copied as invalid method, leading to
     a trap when its executed. This is used when a class has changed its
     layout for all methods which are affected by the change."

    self 
        copyInvalidatedMethodsFrom:oldClass 
        for:newClass 
        accessingAny:setOfNames 
        orSuper:false

    "Modified: / 02-08-2010 / 16:40:30 / cg"
!

copyInvalidatedMethodsFrom:oldClass for:newClass accessingAny:setOfNames orSuper:superBoolean
    "copy all methods from oldClass to newClass. 
     Those methods accessing a variable in setOfNames will be copied as invalid method, 
     leading to a trap when executed. If superBoolean is true, this is also done
     for methods accessing super.  This is used when a class has changed its
     layout for all methods which are affected by the change."

    |p source mustInvalidate
     oldMethod newMethod methodDict newMethodDict nNames|

    methodDict := oldClass methodDictionary.
    newMethodDict := methodDict copy.
    nNames := setOfNames size.

    methodDict keysAndValuesDo:[:selector :method |
        oldMethod := method originalMethodIfWrapped.

        "before parsing (which may take some time),
         do a string search if its only one variable,
         we are looking for.
         Could look for more than one variable by string compare, but then
         parsing it right away may be faster ..."

        source := oldMethod source.
        ((nNames == 1) and:[superBoolean not]) ifTrue:[
            mustInvalidate := (source findString:(setOfNames first)) ~~ 0.
        ] ifFalse:[
            ((nNames == 0) and:[superBoolean]) ifTrue:[
                mustInvalidate := (source findString:'super') ~~ 0.
            ] ifFalse:[
                mustInvalidate := true
            ].
        ].

        mustInvalidate ifTrue:[
            "we have to parse it ..."
            p := newClass parserClass parseMethod:source in:newClass.
            (p isNil 
             or:[(p usedVars includesAny:setOfNames)
             or:[superBoolean and:[p usesSuper]]]) ifFalse:[
                mustInvalidate := false
            ]
        ].

        mustInvalidate ifTrue:[
            newMethod := oldMethod copy.
"/            Smalltalk silentLoading ifFalse:[
"/                Transcript showCR:'invalidating ' , selector , '...'.
"/            ].
            newMethod makeInvalid.
        ] ifFalse:[
            newMethod := oldMethod.
            newMethod mclass:nil.
        ].
        newMethodDict at:selector put:newMethod
    ].
    newClass methodDictionary:newMethodDict.

    "Modified: / 07-06-1996 / 08:33:52 / stefan"
    "Modified: / 21-08-2009 / 10:14:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2010 / 11:47:39 / cg"
!

copyMethodsFrom:oldClass for:newClass
    "copy all methods from oldClass to newClass.
     This is used for class-methods when a class has changed, but its metaclass is 
     unaffected (i.e. classVars/inheritance have not changed) so there is no need
     to recompile the class methods."

    newClass methodDictionary:(oldClass methodDictionary copy).
    newClass methodDictionary do:[:mthd | mthd mclass:nil.].

    "Modified: / 05-08-2004 / 19:52:28 / stefan"
!

recompileGlobalAccessorsTo:aGlobalKey in:aNamespace except:someClass
    "when a new class enters a namespace, all accessors to the same-named
     class in that namespace must be recompiled.
     This is required because if some global Foo is used inside a namespace, and that namespace
     does not contain a Foo, that Foo refers to Smalltalk::Foo.
     However when we finally load a Foo, all those refs should now refer to Namespace::Foo.
     Because that is used heavily during package loading (for the same namespace), cache it."

    |privateClassNames|

    aNamespace name = LastNamespaceName ifTrue:[
        privateClassNames := LastClassNamesInNameSpace
    ] ifFalse:[
        privateClassNames := aNamespace allPrivateClasses 
                                reject:[:cls | cls isJavaClass or:[cls isNameSpace] ]
                                thenCollect:[:each | each name].   
        LastNamespaceName := aNamespace name.
        LastClassNamesInNameSpace := privateClassNames asOrderedCollection.
    ].
    privateClassNames := privateClassNames reject:[:nm | nm isNil].

    privateClassNames do:[:eachClassName |
        "the classes inside the namespace"
        |cls|

        cls := Smalltalk classNamed:eachClassName.
        (cls notNil and:[cls ~~ someClass]) ifTrue:[
            cls isLoaded ifTrue:[

"/                Smalltalk silentLoading ifFalse:[
"/                    Transcript showCR:'recompiling methods in ''' , aClass name , ''' accessing ''' , aGlobalKey , ''''.
"/                    Transcript endEntry.
"/                ].

                cls recompileMethodsAccessingGlobal:aGlobalKey.
                cls class recompileMethodsAccessingGlobal:aGlobalKey.
                "/ actually - must eventually recompile USERS of this namespace too
            ]
        ]
    ].

    aNamespace isNameSpace ifFalse:[
        "the class itself, if those classes above were simply private classes"
        aNamespace recompileMethodsAccessingGlobal:aGlobalKey.
        aNamespace class recompileMethodsAccessingGlobal:aGlobalKey.
    ].

    "Modified: / 24-08-2011 / 13:32:22 / cg"
!

recompileMachineCodeMethodsIn:aClass
    "recompile all machine-code methods in aClass."

    aClass recompileMethodsWithMachineCode.
    aClass class recompileMethodsWithMachineCode.
! !

!ClassBuilder methodsFor:'Compatibility-Squeak'!

name:newName 
    inEnvironment:aSystemDictionaryOrClass 
    subclassOf:aClass
    type: type 
    instanceVariableNames: stringOfInstVarNames 
    classVariableNames: stringOfClassVarNames 
    poolDictionaries: stringOfPoolNames
    category: categoryString

    "this returns the created class; it is not a simple accessor"

    |variableBoolean wordsBoolean pointersBoolean|

    variableBoolean := wordsBoolean := pointersBoolean := false.
    type ~~ #normal ifTrue:[
        type == #bytes ifFalse:[
            type == #words ifTrue:[
                wordsBoolean := true
            ] ifFalse:[
                type == #variable ifTrue:[
                    pointersBoolean := true
                ] ifFalse:[
self halt:'todo'.
                ]
            ]
        ]
    ].

    self 
        name:newName 
        inEnvironment:aSystemDictionaryOrClass 
        subclassOf:aClass 
        instanceVariableNames:stringOfInstVarNames 
        variable:variableBoolean 
        words:wordsBoolean 
        pointers:pointersBoolean 
        classVariableNames:stringOfClassVarNames 
        poolDictionaries:stringOfPoolNames 
        category:categoryString 
        comment:''
        changed:false
        classInstanceVariableNames:''.

    ^ self buildClass

    "Modified: / 07-09-2011 / 15:21:09 / cg"
! !

!ClassBuilder methodsFor:'accessing'!

classClass
    ^ classClass ? Class
!

classClass:aClass
    classClass := aClass.
!

metaclass:metaclassOrASubclassOfIt
    metaclass := metaclassOrASubclassOfIt.
!

name:newName inEnvironment:aSystemDictionaryOrClass subclassOf:aClass 
        instanceVariableNames:stringOfInstVarNames 
        variable:variableBoolean 
        words:wordsBoolean pointers:pointersBoolean 
        classVariableNames:stringOfClassVarNames 
        poolDictionaries:stringOfPoolNames 
        category:categoryString 
        comment:commentString 
        changed:changedBoolean 
        classInstanceVariableNames:stringOfClassInstVarNamesOrNil 

    className := newName asSymbol.
    environment := aSystemDictionaryOrClass.
    superClass := aClass.
    instanceVariableNames := stringOfInstVarNames ? ''.

    "/ Allowing non-booleans as variableBoolean
    "/ is a hack for backward (ST-80) compatibility:
    "/ ST-80 code will pass true or false as variableBoolean,
    "/ while ST/X also calls it with symbols such as #float, #double etc.

    flags := self flagsForVariable:variableBoolean pointers:pointersBoolean words:wordsBoolean.

    classVariableNames := stringOfClassVarNames ? ''.
    poolDictionaries := stringOfPoolNames ? ''.
    category := categoryString.
    comment := commentString.
    changed := changedBoolean.
    classInstanceVariableNames := stringOfClassInstVarNamesOrNil

    "Modified: / 30-01-2011 / 10:07:36 / cg"
!

oldMetaclass:aMetaclass instanceVariableNames:stringOfInstVarNames
    |instrVarNames|

    oldMetaClass := aMetaclass.
    instrVarNames := oldMetaClass superclass allInstanceVariableNames asBag.
    instrVarNames addAll:(stringOfInstVarNames asStringCollection).
    (instrVarNames contents includesValue:2) ifTrue:[
        self error:'duplicate variable name'.
    ].
    
    instanceVariableNames := stringOfInstVarNames.
! !

!ClassBuilder methodsFor:'building'!

buildClass
    "this is the main workhorse for installing new classes - special care
     has to be taken, when changing an existing classes definition. In this
     case, some or all of the methods and subclasses methods have to be
     recompiled.
     Also, the old class(es) are still kept (but not accessible as a global),
     to allow existing instances some life. 
     This might change in the future."

    |newClass newMetaclass newComment|

    "NOTICE:
     this method is too complex and should be splitted into managable pieces ...
     I don't like it anymore :-) 
     (well, at least, its a good test for the compilers ability 
      to handle big, complex methods ;-)
     take it as an example of bad coding style ...

     ST-80 uses a ClassBuilder object to collect the work and perform all updates;
     this method may be changed to do something similar in the future ...
    "

    environment notNil ifTrue:[ self checkClassName ].
    self checkValidSubclassing.

    environment notNil ifTrue:[
        environment autoload   "/ owner must be loaded
    ].

    instanceVariableNames notNil ifTrue:[
        instanceVariableNames isString ifFalse:[
            instanceVariableNames := instanceVariableNames asStringWith:Character space
        ].
    ] ifFalse:[
        instanceVariableNames := ''
    ].
    classVariableNames notNil ifTrue:[
        classVariableNames isString ifFalse:[
            classVariableNames := classVariableNames asStringWith:Character space
        ].
    ] ifFalse:[
        classVariableNames := ''
    ].

    buildingPrivateClass := false.
    environment notNil ifTrue:[
        self determineNewName ifFalse:[
            ^ nil.
        ].
    ].

    (superClass notNil and:[realNewName = superClass name]) ifTrue:[
        ClassBuildError raiseErrorString:'trying to create circular class definition'.
        ^ nil
    ].

    "look, if it already exists as a class"
    environment notNil ifTrue:[
        environment isLoaded ifFalse:[ environment autoload ].
        buildingPrivateClass ifFalse:[
            oldClass := environment at:className ifAbsent:[nil].
        ] ifTrue:[
            oldClass := environment privateClassesAt:className.
        ]
    ].

    (instanceVariableNames size > 0
    or:[classVariableNames size > 0]) ifTrue:[
        (self 
            checkValidVarNamesFor:className
            subClassOf:superClass
            instVarNames:instanceVariableNames 
            classVarNames:classVariableNames) 
        ifFalse:[
            ^ nil
        ].
    ].

    oldClass notNil ifTrue:[
        (oldClass isRealNameSpace) ifTrue:[
            (superClass == NameSpace or:[superClass isNameSpace]) ifFalse:[
                ClassBuildError raiseErrorString:'class exists as namespace'.
                ^ nil.
            ].
            ^ oldClass
        ].

        (oldClass isBehavior and:[oldClass isLoaded not]) ifTrue:[
            oldClassToBecomeNew := oldClass
        ].
    ].

    (oldClass notNil and:[oldClass isBehavior and:[oldClass isLoaded]]) ifFalse:[
        oldClass := nil.

        (buildingPrivateClass and:[ParserFlags warnings and:[ParserFlags warnSTXSpecials]]) ifTrue:[
            (self confirm:('Support for private classes is an ST/X extension.\\continue ?') withCRs)
            ifFalse:[^ nil].
        ].
    ] ifTrue:[
        oldClass name ~= realNewName ifTrue:[
            (self confirm:(className , ' is an alias for ' , oldClass name , '\\continue ?') withCRs)
            ifFalse:[^ nil].
            oldClass := nil
        ] ifFalse:[
            (self checkForCircularDefinitionFrom:oldClass) ifTrue:[
                ClassBuildError raiseErrorString:'trying to create circular class definition'.
                ^ nil
            ].

            "
             warn, if it exists with different category and different instvars,
             and the existing is not an autoload class.
             Usually, this indicates that someone wants to create a new class with
             a name, which already exists (it happened a few times to myself, while 
             I wanted to create a new class called ReturnNode ...).
             This will be much less of a problem, once multiple name spaces are
             implemented and classes can be put into separate packages.
            "
            oldClass isLoaded ifTrue:[
                oldClass category ~= category ifTrue:[
                    oldClass instanceVariableString asCollectionOfWords ~= instanceVariableNames asCollectionOfWords ifTrue:[
                        (self confirm:('A class named %1 already exists in category "%2".\\Create (i.e. change) anyway?' withCRs
                                            bindWith:oldClass name allBold 
                                            with:oldClass category))
                        ifFalse:[
                            ^ nil
                        ]
                    ]
                ]
            ].

            "/
            "/ hints - warn, if creating a variableSubclass of a Set
            "/ (common error when porting code from Squeak:
            "/  containers in ST/X do not use variable-slots)
            "/

            (flags bitAnd:Behavior maskIndexType) == (Behavior flagForSymbolic:#objects)
            "((variable == true) and:[pointers])" ifTrue:[
                (oldClass isKindOf:Set class) ifTrue:[
                    (self confirm:('ST/X Set & Dictionary are not variable-classes.\Create %1 anyway ?' bindWith:className) withCRs)
                    ifFalse:[
                        ^ nil
                    ]
                ]
            ]
        ]
    ].

    "/ Check for some 'considered bad-style' things, like lower case names.
    "/ But only do these checks for new classes - 
    "/ - thus, once confirmed, the warnings will not come again and again.

    "/ NOTICE:
    "/ I don't like the confirmers there - we need a notifying: argument, to give
    "/ the outer codeview a chance to highlight the error.
    "/ (but that's how its defined in the book - maybe I will change anyway).
    "/ - or use upQueries in future versions.

    oldClass isNil ifTrue:[
        (instanceVariableNames size > 0 or:[classVariableNames size > 0]) ifTrue:[
            (self 
                checkConventionsFor:className
                subClassOf:superClass
                instVarNames:instanceVariableNames 
                classVarNames:classVariableNames) 
            ifFalse:[
                ^ nil
            ]
        ].
    ].

    (self
        checkInstvarRedefsWith:instanceVariableNames 
        subclassOf:superClass 
        old:oldClass 
        name:className) ifFalse:[^ nil].

    self checkValidPools.

    newMetaclass := self instantiateMetaclass.
    newClass := self instantiateNewClassFrom:newMetaclass.

    (environment notNil and:[environment ~~ Smalltalk]) ifTrue:[
        newClass setName:realNewName.
        "/
        "/ if that key exists in smalltalk,
        "/ must recompile everything in that nameSpace,
        "/ which refers to the unprefixed global.
        "/
        recompileGlobalAccessTo := className.
    ] ifFalse:[
        newClass setName:className.
        recompileGlobalAccessTo := nil.
    ].

    newComment := comment.
    newComment isNil ifTrue:[
        oldClass notNil ifTrue:[
            newComment := oldClass comment
        ].
    ].
    newClass setComment:newComment category:category.
    (oldClass notNil or:[ poolDictionaries notEmptyOrNil ]) ifTrue:[
        newClass sharedPoolNames:poolDictionaries
    ].

    "/ for new classes, we are almost done here
    "/ (also for autoloaded classes)

    (oldClass isNil or:[oldClass isLoaded not]) ifTrue:[
        "/ do not set the classFileName here, because we do not know here,
        "/ if this is a normal fileIn, or a fileIn from a temporary file.
        "/ it MUST be done by the fileInClass:lazy:... method in Smalltalk or whereever.
"/        |sourceContainer|
"/        sourceContainer := PeekableStream currentSourceContainer.
"/        sourceContainer isFileStream ifTrue:[
"/            newClass setClassFilename:sourceContainer pathName asFilename baseName.
"/        ].

        self handleNewlyCreatedClass:newClass.
        ^ newClass
    ].

    newClass setClassFilename:oldClass getClassFilename.

    "/ here comes the hard part - we are actually changing the
    "/ definition of an existing class ....
    "/ Try hard to get away WITHOUT recompiling, since it is both slow
    "/ and it makes all compiled code into interpreted (which is reJITed then)...
    oldInstVars := oldClass instanceVariableString asCollectionOfWords.
    newInstVars := newClass instanceVariableString asCollectionOfWords.
    oldClassInstVars := oldClass class instanceVariableString asCollectionOfWords.
    newClassInstVars := newClass class instanceVariableString asCollectionOfWords.
    oldClassVars := oldClass classVariableString asCollectionOfWords asSet.
    newClassVars := newClass classVariableString asCollectionOfWords asSet.
    oldPoolDictionaries := oldClass sharedPoolNames.
    newPoolDictionaries := newClass sharedPoolNames.
    poolChange := (oldPoolDictionaries ~= newPoolDictionaries).

    "/ We are on the bright side of life, if the instance layout and inheritance do not change.
    "/ In this case, we can go ahead and patch the class object.
    "/ (only comment and/or classVars have changed)
    oldSuperClass := oldClass superclass.
    newSuperClass := newClass superclass.
    superClassChange := (oldSuperClass ~~ newSuperClass).

    Class flushSubclassInfoFor:oldSuperClass.
    Class flushSubclassInfoFor:newSuperClass.

    superClassChange ifFalse:[
        (oldClass instSize == newClass instSize) ifTrue:[
            (oldClass flags == newClass flags) ifTrue:[
                (oldClass name = newClass name) ifTrue:[
                    (oldInstVars = newInstVars) ifTrue:[
                        (oldClassInstVars = newClassInstVars) ifTrue:[
                            poolChange ifFalse:[
                                self handleEasyNewClass:newClass.
                                ^ oldClass
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ].

    self handleHardNewClass:newClass.
    ^ newClass

    "Created: / 26-05-1996 / 11:55:26 / cg"
    "Modified: / 18-03-1999 / 18:23:31 / stefan"
    "Modified: / 15-09-2011 / 13:47:56 / cg"
!

newSubclassOf:baseClass type:typeOfClass instanceVariables:instanceVariables from:oldClassArg
    "anonymous classes can be built with this entry"

    superClass := baseClass.
    flags := Behavior flagForSymbolic:typeOfClass.
    instanceVariableNames := instanceVariables.
    oldClass := oldClassArg.
    ^ self buildClass.

    "Created: / 07-06-2007 / 12:04:47 / cg"
! !

!ClassBuilder methodsFor:'building-helpers'!

changeReferencesFrom:oldClass to:newClass
    |refs|

    refs := OrderedCollection new.
    ObjectMemory allObjectsDo:[:obj |
        Exception handle:[:ex |
        ] do:[
            ((obj class isSubclassOf:Object) and:[obj isLazyValue not]) ifTrue:[
                (obj referencesObject:oldClass) ifTrue:[
                    obj isContext ifFalse:[
                        refs add:obj
                    ].
                ].
            ]
        ].
    ].
    refs isEmpty ifTrue:[
        ^ self
    ].

"/    answer := OptionBox 
"/                  request:('Update References (from old class to new class) ?') withCRs
"/                  label:'Confirm'
"/                  buttonLabels:#('no' 'browse references' 'update')
"/                  values:#(false #browse true)
"/                  default:#true
"/                  onCancel:false.
"/
"/    answer == #browse ifTrue:[
"/        refs inspect.
"/        answer := self confirm:('Update References (from old class to new class) ?') withCRs.
"/    ].
"/    answer == false ifTrue:[^ self].

    refs do:[:obj |
        |skip|

        skip := false.
        obj isBehavior ifTrue:[
            skip := true.    
            obj isObsolete ifFalse:[
                obj isMeta ifTrue:[
                    "/ the owner-slot ?
                    obj owningClass == oldClass ifTrue:[
"/                        self halt.
                    ].
                    obj theNonMetaclass == oldClass ifTrue:[
"/                        self halt.
                    ]
                ]
            ]
        ].
        skip ifFalse:[
            obj replaceReferencesTo:oldClass with:newClass.
        ].
    ].

    "Modified: / 17-08-2006 / 12:48:22 / cg"
!

copyClassInstanceVariablesFrom:oldClass to:newClass
    |oldCIVNames newCIVNames|

    "/ copy over classInstanceVariables
    "/ but not those inherited from class

    oldClass notNil ifTrue:[
        oldCIVNames := oldClass class allInstVarNames asNewSet.
        newCIVNames := newClass class allInstVarNames asNewSet.
        Class class allInstVarNames do:[:n |
             oldCIVNames remove:n ifAbsent:nil.
             newCIVNames remove:n ifAbsent:nil.
        ].

        newCIVNames size > 0 ifTrue:[
            newCIVNames do:[:n |
                (oldCIVNames includes:n) ifTrue:[
                    newClass instVarNamed:n put:(oldClass instVarNamed:n)
                ]
            ]
        ].
    ].
!

determineNewName
    |doCreate namespace classSymbol idx nsName|

    classSymbol := className asSymbol.
    namespace := environment.

    (namespace notNil
    and:[namespace isNameSpace not]) ifTrue:[
        buildingPrivateClass := true.
        realNewName := (namespace name , '::' , classSymbol) asSymbol.
    ] ifFalse:[
        buildingPrivateClass := false.
        realNewName := classSymbol.

        "/ does the name imply a nameSpace ?
        idx := realNewName indexOf:$: .
        (idx > 1 and:[ (realNewName at:(idx+1)) == $: ]) ifTrue:[
            "/ check for this namespace to exist
            nsName := realNewName copyTo:(idx - 1).
            nsName := nsName asSymbol.
            (realNewName indexOf:$: startingAt:(idx+2)) ~~ 0 ifTrue:[
                (Smalltalk at:nsName) isNameSpace ifTrue:[
                    self warn:('Nested namespaces are not (yet) implemented.') withCRs.
                ] ifFalse:[
                    self warn:('Trying to define a private class with a non-private definition selector.') withCRs.
                ].
                ^ false
            ].

            namespace := Smalltalk at:nsName ifAbsent:nil.
            namespace isNameSpace ifFalse:[
                namespace isNil ifTrue:[
                    doCreate := Class createNameSpaceQuerySignal query.
                    doCreate ifFalse:[
                        doCreate := Dialog
                            confirmWithCancel:('Nonexistent Namespace: `' , nsName , '''.\\Create ?') withCRs.
                        doCreate isNil ifTrue:[
                            "/ cancelled
                            AbortSignal raise.
                            ^ false.
                        ]
                    ].
                    doCreate ifFalse:[^ false].
                    namespace := NameSpace name:nsName.
                ] ifFalse:[
                    (namespace isBehavior
                    and:[namespace isMeta not])
                    ifTrue:[
                        buildingPrivateClass := true.
                        realNewName := classSymbol asSymbol.
                    ] ifFalse:[
                        self warn:('A global named ' , nsName , ' exists, but is no namespace.') withCRs.
                        ^ false
                    ].
                ]
            ].
            namespace isNameSpace ifTrue:[
                nameKey := (classSymbol copyFrom:(nsName size + 3)) asSymbol.
            ]
        ] ifFalse:[
            (namespace notNil and:[namespace ~~ Smalltalk]) ifTrue:[
                realNewName := (namespace name , '::' , classSymbol) asSymbol.
            ]
        ]
    ].
    ^ true

    "Modified: / 11-08-2006 / 12:49:46 / cg"
!

environmentChanged:how with:argument
      environment changed:how with:argument.
      environment ~~ Smalltalk ifTrue:[
          Smalltalk changed:how with:argument.
      ]
!

environmentChangedOrganization
      environment changed:#organization.
      environment ~~ Smalltalk ifTrue:[
          Smalltalk changed:#organization.
      ]
!

fixMethodsIn:newClass
    |changeSet1 changeSet2 newMetaclass addedNames|

    newMetaclass := newClass class.

    "/ care for class methods ...

    changeSet1 := Set new.

    classVarChange := false.

    superClassChange ifTrue:[
        (oldSuperClass notNil
        and:[newSuperClass notNil
        and:[oldSuperClass allClassVarNames = newSuperClass allClassVarNames
        and:[oldSuperClass name = newSuperClass name
        and:[oldClassVars = newClassVars
        and:[poolChange not]]]]])
        ifTrue:[

"/            Transcript showCR:'keep class methods (same classvars)'.
"/            Transcript endEntry.

            "/ class methods still work

            self class copyMethodsFrom:(oldClass class) for:newMetaclass.

"/            Smalltalk silentLoading ifFalse:[
"/                Transcript showCR:'recompiling class methods accessing super ...'.
"/                Transcript endEntry.
"/            ].

            "/ however, those accessing super must be recompiled

            self class 
                copyInvalidatedMethodsFrom:(oldClass class) 
                for:newMetaclass 
                accessingAny:#()
                orSuper:true.
        ] ifFalse:[
            "/ superclass changed:
            "/  must recompile all class methods accessing ANY classvar
            "/  (actually, we could be less strict and handle the case where
            "/   both the old and the new superclass have a common ancestor,
            "/   and both have no new classvariables in between.
            "/   This would speedup the case when a class is inserted into
            "/   the inheritance chain.)

            oldClass allClassVarNames do:[:nm | changeSet1 add:nm].
            newClass allClassVarNames do:[:nm | changeSet1 add:nm].
            oldPoolDictionaries do:[:eachPoolName | changeSet1 addAll:(self namesInPoolNamed:eachPoolName ofClass:oldClass)].
            newPoolDictionaries do:[:eachPoolName | changeSet1 addAll:(self namesInPoolNamed:eachPoolName ofClass:newClass)].
            "/ oldPoolDictionaries do:[:eachPoolName | |eachPool| eachPool := Smalltalk at:eachPoolName asSymbol. eachPool allClassVarNames do:[:nm | changeSet1 add:nm]].
            "/ newPoolDictionaries do:[:eachPoolName | |eachPool| eachPool := Smalltalk at:eachPoolName asSymbol. eachPool allClassVarNames do:[:nm | changeSet1 add:nm]].

"/            Smalltalk silentLoading ifFalse:[
"/                Transcript showCR:'recompiling class methods accessing any classvar or super ...'.
"/                Transcript endEntry.
"/            ].

            self class 
                copyInvalidatedMethodsFrom:(oldClass class) 
                for:newMetaclass 
                accessingAny:changeSet1
                orSuper:true.
        ].
        newMetaclass recompileInvalidatedMethods.
    ] ifFalse:[
        "/ same superclass, find out which classvars have changed

        classVarChange := oldClassVars ~= newClassVars.
        (classVarChange or:[poolChange]) ifTrue:[
            oldClassVars do:[:nm |
                (newClassVars includes:nm) ifFalse:[
                    changeSet1 add:nm
                ]
            ].
            newClassVars do:[:nm |
                (oldClassVars includes:nm) ifFalse:[
                    changeSet1 add:nm
                ]
            ].
            oldPoolDictionaries do:[:eachPoolName | changeSet1 addAll:(self namesInPoolNamed:eachPoolName ofClass:oldClass)].
            newPoolDictionaries do:[:eachPoolName | changeSet1 addAll:(self namesInPoolNamed:eachPoolName ofClass:newClass)].
            "/ oldPoolDictionaries do:[:eachPoolName | |eachPool| eachPool := Smalltalk at:eachPoolName asSymbol. eachPool allClassVarNames do:[:nm | changeSet1 add:nm]].
            "/ newPoolDictionaries do:[:eachPoolName | |eachPool| eachPool := Smalltalk at:eachPoolName asSymbol. eachPool allClassVarNames do:[:nm | changeSet1 add:nm]].

            "/ must recompile some class-methods

"/            Smalltalk silentLoading ifFalse:[
"/                Transcript showCR:'recompiling class methods accessing ' , changeSet1 printString.
"/                Transcript endEntry.
"/            ].

            self class 
                copyInvalidatedMethodsFrom:(oldClass class) 
                for:newMetaclass 
                accessingAny:changeSet1.
            newMetaclass recompileInvalidatedMethods.
        ] ifFalse:[

            "/ class methods still work

            self class copyMethodsFrom:(oldClass class) for:newMetaclass
        ].
    ].


    "/ care for instance methods ...

    superClassChange ifTrue:[
        "/ superclass changed,
        "/  must recompile all methods accessing any class or instvar.
        "/  If number of instvars (i.e. the instances instSize) is the same,
        "/  we can limit the set of recompiled instance methods to those methods,
        "/  which refer to an instvar with a different inst-index

        "/ the changeset consists of instance variables, 
        "/ with a different position

        changeSet2 := self class differentInstanceVariableOffsetsIn:oldClass and:newClass.

        "/ merge in the changed class variables

        changeSet1 do:[:nm | changeSet2 add:nm].

"/        Smalltalk silentLoading ifFalse:[
"/             Transcript showCR:'recompiling instance methods accessing ' , changeSet2 printString , ' [superclass change]...'.
"/             Transcript endEntry.
"/        ].

        self class 
                copyInvalidatedMethodsFrom:oldClass 
                for:newClass 
                accessingAny:changeSet2
                orSuper:true.
        newClass recompileInvalidatedMethods.

    ] ifFalse:[

        "/ same inheritance ...

        instVarChange := oldInstVars ~= newInstVars.
        instVarChange ifFalse:[

            "/ same instance variables ...

            classVarChange ifTrue:[
                "recompile all inst methods accessing changed classvars"

"/                Smalltalk silentLoading ifFalse:[
"/                    Transcript showCR:'recompiling instance methods accessing classvars ' , changeSet1 printString , ' ...'.
"/                    Transcript endEntry.
"/                ].
                self class 
                    copyInvalidatedMethodsFrom:oldClass 
                    for:newClass 
                    accessingAny:changeSet1.
                newClass recompileInvalidatedMethods.
            ] ifFalse:[
                "/ instance methods still work

                self class copyMethodsFrom:oldClass for:newClass
            ]
        ] ifTrue:[
            "/ don't allow built-in classes to be modified

            (instVarChange and:[oldClass notNil and:[oldClass isBuiltInClass]]) ifTrue:[
                ClassBuildError raiseErrorString:'The layout of this class is fixed - you cannot change it.'.
                AbortOperationRequest raise
            ].

            ((oldInstVars size == 0) 
            or:[newInstVars startsWith:oldInstVars]) ifTrue:[
                "/ only new inst variable(s) has/have been added - 
                "/ old methods still work (the existing inst-indices are still valid)

"/                Transcript showCR:'copying methods ...'.
"/                Transcript endEntry.

                self class copyMethodsFrom:oldClass for:newClass.

                "/ but: we have to recompile all methods accessing new instars
                "/ (it might have been a classVar/global before ...)

                addedNames := newInstVars reject:[:nm | oldInstVars includes:nm].
                "merge in class variables"
                changeSet1 do:[:nm | addedNames add:nm].

                (addedNames contains:[:eachAddedName| (Smalltalk at:eachAddedName asSymbol) notNil 
                                                        or:[(oldClass whichClassDefinesClassVar:eachAddedName) notNil]]) ifTrue:[
"/                    Smalltalk silentLoading ifFalse:[
"/                        Transcript showCR:'recompiling instance methods accessing ' , addedNames printString ,  '... [added instvars]'.
"/                        Transcript endEntry.
"/                    ].
                    newClass recompileMethodsAccessingAny:addedNames.
                ].
            ] ifFalse:[

                "/ the changeset consists of instance variables, 
                "/ with a different position

                changeSet2 := self class differentInstanceVariableOffsetsIn:oldClass and:newClass.

                "merge in the class variables"
                changeSet1 do:[:nm | changeSet2 add:nm].

"/                Smalltalk silentLoading ifFalse:[
"/                    Transcript showCR:'recompiling instance methods accessing ' , changeSet2 printString , ' ... [changed instvars]'.
"/                    Transcript endEntry.
"/                ].

                self class 
                    copyInvalidatedMethodsFrom:oldClass 
                    for:newClass 
                    accessingAny:changeSet2.
                newClass recompileInvalidatedMethods.
            ].
        ].
    ].

    "Modified: / 26-07-2012 / 11:34:12 / cg"
!

flagsForVariable:variable pointers:pointers words:words
    "/ Allowing non-booleans as variable is a hack for STX / ST80 compatibility:
    "/    ST80 code will pass true or false as variableBoolean,
    "/    STX also calls it with symbols such as #float, #double, #longLong etc.

    variable isSymbol ifTrue:[
        ^ Behavior flagForSymbolic:variable.
    ].

    variable ifFalse:[
        ^ Behavior flagRegular
    ].

    pointers ifTrue:[
        ^ Behavior flagPointers
    ].
    words ifTrue:[
        ^ Behavior flagWords
    ].
    ^ Behavior flagBytes

    "Created: / 07-06-2007 / 12:08:47 / cg"
!

handleEasyNewClass:newClass
    "instance layout remains the same.
     We only have to recompile methods which access changed class variables
     and changed pool variables."

    |newComment anyChange setOfChangedVariables oldPoolVars newPoolVars|

    oldPoolVars := oldClass sharedPools collectAll:[:pool | pool keys].
    newPoolVars := newClass sharedPools collectAll:[:pool | pool keys].

    newComment := newClass comment.

    (newComment ~= oldClass comment) ifTrue:[
        oldClass setComment:newComment.        "writes a change-chunk"
        oldClass changed:#comment with:oldClass comment.
        changed ifTrue:[
            oldClass addChangeRecordForClassComment:oldClass.
        ]
    ]. 

    oldClass package ~= newClass package ifTrue:[
        "notify change of organization"
        oldClass setPackage:newClass package. 
    ].

    ((oldClassVars sameContentsAs: newClassVars)
    and:[oldPoolVars = newPoolVars]) ifTrue:[
        "/ really no change (just comment and/or category)

        anyChange := false.

        oldClass setInstanceVariableString:(newClass instanceVariableString).
        oldClass setClassVariableString:(newClass classVariableString).

        oldClass category ~= category ifTrue:[
            oldClass setCategory:category. 
            changed ifTrue:[
                newClass addChangeRecordForClass:newClass.
            ].    
            environment notNil ifTrue:[
                buildingPrivateClass ifFalse:[
                    self environmentChangedOrganization.
                ]
            ]
        ].
        ^ oldClass
    ].

    "/ when we arrive here, class variables have changed

    oldClass category ~= category ifTrue:[
        "notify change of organization"
        oldClass setCategory:category. 
        environment notNil ifTrue:[
            buildingPrivateClass ifFalse:[ 
                self environmentChangedOrganization.
            ]
        ].
    ].

    "/ set class variable string; 
    "/ this also updates the set of class variables
    "/ by creating new / deleting obsolete ones.

    oldClass classVariableString:classVariableNames.
    oldClass sharedPools:newClass sharedPools.

    "
     get the set of changed class variables
    "
    setOfChangedVariables := Set new.

    "
     add the set of changed class variables (those which are not in both)
    "
    setOfChangedVariables addAll:(oldClassVars xor:newClassVars).

    "
     add the set of changed pool variables (those which are not in both)
    "
    setOfChangedVariables addAll:(oldPoolVars xor:newPoolVars).

    "
     add the set of pool vars which are now classVars and vice versa
    "
    setOfChangedVariables addAll:(oldPoolVars intersect:newClassVars).
    setOfChangedVariables addAll:(oldClassVars intersect:newPoolVars).

    setOfChangedVariables notEmpty ifTrue:[

        "/ recompile all methods accessing set of changed classvars
        "/ here and also in all subclasses ...

        "/ don't update change file for the recompilation

        Class withoutUpdatingChangesDo:[

"/                      Smalltalk silentLoading ifFalse:[
"/                          Transcript showCR:'recompiling class & inst methods accessing ' , setOfChangedVariables printString.
"/                          Transcript endEntry.
"/                      ].
            oldClass withAllSubclasses do:[:aClass |
                aClass class recompileMethodsAccessingAnyClassvarOrGlobal:setOfChangedVariables.
                aClass recompileMethodsAccessingAnyClassvarOrGlobal:setOfChangedVariables.
            ].
        ].
    ].

    Class flushSubclassInfoFor:oldClass superclass.
    Class flushSubclassInfoFor:newClass superclass.
    Class flushSubclassInfoFor:oldClass.
    Class flushSubclassInfoFor:newClass.

    "notify change of class"
    changed ifTrue:[
        oldClass addChangeRecordForClass:oldClass.
    ].  
    oldClass changed:#definition.

    self environmentChanged:#classDefinition with:newClass.

    "Modified: / 18-01-2011 / 20:45:34 / cg"
!

handleHardNewClass:newClass
    |oldCategory|

    "/ don't allow built-in classes to be modified this way
    (superClassChange and:[oldClass notNil and:[oldClass isBuiltInClass]]) ifTrue:[
        ClassBuildError raiseErrorString:'the inheritance of this class is fixed - you cannot change it'.
        ^ oldClass
    ].

    "/ since we will change the inheritance of some class(es)
    Class 
        flushSubclassInfoFor:oldSuperClass;
        flushSubclassInfoFor:newSuperClass.

    "/ catch special case, where superclass changed its layout and thus
    "/ forced redefinition of this class; 
    "/ only log if this is not the case.
    changed ifTrue:[
        (superClassChange 
         and:[(oldSuperClass isNil or:[newSuperClass notNil and:[oldSuperClass name = newSuperClass name]])
         and:[(oldClassVars sameContentsAs: newClassVars) 
         and:[(oldInstVars = newInstVars)
         and:[poolChange not 
         and:[oldClass comment = newClass comment]]]]]) ifFalse:[
            newClass addChangeRecordForClass:newClass.
        ]
    ].
    self fixMethodsIn:newClass.

    "/ finally, if the oldClass came from a dynamically loaded
    "/ classLibrary, we must recompile the methods in the newClass.
    "/ otherwise, the methods code will vanish when the old (obsolete)
    "/ class eventually vanishes ...
    self class recompileMachineCodeMethodsIn:newClass.

"/    (oldPkg notNil and:[oldPkg ~= pkg]) ifTrue:[
"/        "/ we have to change all methods package info
"/        "/ to belong to the old package.
"/        newClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
"/            mthd setPackage:oldPkg
"/        ].
"/    ].

    "/ WOW, everything done for this class
    "/ what about subclasses ?

"/    "/ update superclass of immediate subclasses - 
"/    "/ this forces recompilation (recursively) if needed
"/    "/ (don't update change file for the subclass changes)
"/
"/    Class classRedefinitionNotification answer:#keep do:[
"/        Class withoutUpdatingChangesDo:[
"/            oldClass subclasses copy do:[:aClass |
"/                aClass superclass:newClass
"/            ]
"/        ]
"/    ].

    "/ change any private subclasses' owners

    oldClass privateClassesDo:[:aClass |
        aClass isLoaded ifTrue:[
            aClass class setOwningClass:newClass
        ]
    ].

    "/ change category in oldClass - so we see immediately what it is ...

    oldCategory := oldClass category.
    oldClass setCategory:#'* obsolete *'.
    oldClass wasAutoloaded ifTrue:[ Autoload removeClass:oldClass ].
    Smalltalk flushCachedClass:oldClass.

    "/ and make the new class globally known

    environment notNil ifTrue:[
        buildingPrivateClass ifTrue:[
            environment privateClassesAt:className put:newClass.
        ] ifFalse:[
            environment at:className put:newClass.

            oldCategory ~= category ifTrue:[
                self environmentChangedOrganization.
            ]
        ].
    ].

    "/ update superclass of immediate subclasses - 
    "/ this forces recompilation (recursively) if needed
    "/ (don't update change file for the subclass changes)

    Class classRedefinitionNotification answer:#keep do:[
        Class withoutUpdatingChangesDo:[
            oldClass subclasses copy do:[:aClass |
                aClass superclass:newClass
            ]
        ]
    ].

    "/ Not becoming the old class creates some update problems;
    "/ the browsers must check carefully - a simple identity compare is
    "/ not enough ...
    "/ QUESTION: is this a good idea ?
    newClass dependents:(oldClass dependents).
    newClass changed:#definition.

    "just to make certain ... - tell dependents of oldClass, that something changed
     (systemBrowsers will react on this, and update their views)"
    oldClass changed:#definition with:newClass.

    Class flushSubclassInfoFor:oldClass.
    Class flushSubclassInfoFor:newClass.
    self environmentChanged:#classDefinition with:newClass.

    ObjectMemory flushCaches.

    buildingPrivateClass ifFalse:[
        oldClass ~~ newClass ifTrue:[
            environment == Smalltalk ifTrue:[
                ClassBuilder checkForAliasesOf:oldClass with:newClass.
            ]
        ]
    ].
    (instVarChange or:[classVarChange]) ifTrue:[
        self changeReferencesFrom:oldClass to:newClass.
    ].
    oldClass subclasses do:[:cls | Class flushSubclassInfoFor:cls].
    Class flushSubclassInfoFor:oldClass.
    ^ newClass

    "Created: / 26-05-1996 / 11:55:26 / cg"
    "Modified: / 18-03-1999 / 18:23:31 / stefan"
    "Modified: / 15-09-2011 / 13:49:01 / cg"
!

handleNewlyCreatedClass:newClass
"/    comment notNil ifTrue:[
"/        newClass comment:comment
"/    ].
    environment notNil ifTrue:[
        buildingPrivateClass ifTrue:[
            environment privateClassesAt:className put:newClass.
        ] ifFalse:[
            environment at:className put:newClass.
        ].
        (oldClass isNil and:[changed and:[superClass ~~ Autoload]]) ifTrue:[
            newClass addChangeRecordForClass:newClass.
        ].
    ].

    oldClass notNil ifTrue:[ Class flushSubclassInfoFor:oldClass superclass].
    Class flushSubclassInfoFor:newClass superclass.

"/    oldClass notNil ifTrue:[
"/        "/ since we changed the classes inheritance (from Autoloaded)
"/
"/        "/ actually, could optimize to:
"/        "/  Class updateSuperclassInfoFor:oldClass superclass.
"/        "/  Class updateSuperclassInfoFor:newClass superclass.
"/
"/        Class flushSubclassInfo.
"/    ].

    oldClassToBecomeNew notNil ifTrue:[
        "/ old was an autoloaded class - make it the new one
        "/ and flush ...

"/        (ObjectMemory whoReferences:oldClassToBecomeNew class) notEmpty ifTrue:[
"/            self halt.
"/        ].
        oldClassToBecomeNew becomeSameAs:newClass.
"/        oldClassToBecomeNew class becomeSameAs:newClass class.

        ObjectMemory flushCaches.
    ].

    environment notNil ifTrue:[
        buildingPrivateClass ifTrue:[
            environment changed.
        ].
        self environmentChanged:#newClass with:newClass.
    ].

    "/ be very careful, when adding classes
    "/ to a namespace or adding a privateClass. 
    "/ When adding, all methods within that namespace/owning class
    "/ which access the unprefixed-global,
    "/ must be recompiled (so they access the new class)

    recompileGlobalAccessTo notNil ifTrue:[
        self class 
            recompileGlobalAccessorsTo:recompileGlobalAccessTo
            in:environment except:newClass.
    ].

    (buildingPrivateClass 
    and:[newClass owningClass nameSpace notNil]) ifTrue:[
        "/ namespace is a class; 
        "/ if this owner is itself in a namespace,
        "/ must recompile all from owners namespace
        "/ accessing the new class (without namespace prefix)
        self class 
            recompileGlobalAccessorsTo:(newClass nameWithoutNameSpacePrefix asSymbol)
            in:(newClass owningClass nameSpace) except:newClass.
    ].
    ^ newClass

    "Modified: / 27-04-2010 / 00:03:42 / cg"
!

instantiateMetaclass
    "create the metaclass proper"

    |metaclassClass newMetaclass classesSuperclass|

    classInstanceVariableNames isNil ifTrue:[
        oldClass isNil ifTrue:[
            classInstanceVariableNames := ''
        ] ifFalse:[
            classInstanceVariableNames := oldClass class instanceVariableString
        ]
    ].

    metaclassClass := metaclass ? Metaclass.
    buildingPrivateClass ifTrue:[
        metaclassClass := metaclassClass asPrivate
    ].
    newMetaclass := metaclassClass new.
    superClass isNil ifTrue:[
        classesSuperclass := self classClass.
    ] ifFalse:[
        classesSuperclass := superClass class.
    ].
    newMetaclass setSuperclass:classesSuperclass instSize:(classesSuperclass instSize + classInstanceVariableNames countWords).
    newMetaclass setInstanceVariableString:classInstanceVariableNames.
    buildingPrivateClass ifTrue:[
        newMetaclass setOwningClass:environment.
    ].
    ^ newMetaclass

    "Modified: / 07-06-2007 / 12:24:34 / cg"
!

instantiateNewClassFrom:newMetaclass
    "create the class proper"

    |newClass nInstVars newInstSize|

    "let the new meta create the class"

    instanceVariableNames size > 0 ifTrue:[
        nInstVars := instanceVariableNames countWords.
    ] ifFalse:[
        nInstVars := 0.
    ].

    newClass := newMetaclass new.
    superClass isNil ifTrue:[
        newInstSize := nInstVars.
    ] ifFalse:[
        newInstSize := superClass instSize + nInstVars.
    ].
    newClass setSuperclass:superClass instSize:newInstSize.
    newClass setName:realNewName.

    self copyClassInstanceVariablesFrom:oldClass to:newClass.
    self setPackageInNewClass:newClass fromOld:oldClass.
    self setupNewClass:newClass fromOld:oldClass.

    ^ newClass

    "Modified: / 10-11-2006 / 14:36:28 / cg"
!

namesInPoolNamed:poolName ofClass:aClass
    |pool ns|

    aClass notNil ifTrue:[
        ns := aClass nameSpace.
    ].
    "ns can be a owning class or a real nameSpace or Smalltalk"
    pool := ns classNamed:poolName.

    pool isNil ifTrue:[
        ns ~~ Smalltalk ifTrue:[
            pool := Smalltalk classNamed:poolName.
        ].
        "/ pool is not yet there
        pool isNil ifTrue:[^ #()].
    ].
    ^ pool allClassVarNames

    "Created: / 30-10-2011 / 12:04:56 / cg"
!

rebuildForChangedClassInstanceVariables
    "only called for metaclasses.
     changing / adding class-inst vars -
     this actually creates a new metaclass and class, leaving the original
     classes around as obsolete classes. This may also be true for all subclasses,
     if class instance variables are added/removed.

     Existing instances become an instance of the new class
     (which can be done without become, by changing their class only, because
     the instance-layout has not changed).

     However, if the old class is referenced somewhere (in a collection),
     that reference will still point to the old, now obsolete class.
     Time will show, if that is a problem and will be fixed."

    |newClass newMetaclass nClassInstVars oldClass 
     allSubclasses oldVars
     oldNames newNames addedNames
     oldOffsets newOffsets offset changeSet delta
     oldToNew newSubMeta newSub oldSubMeta 
     commonClassInstVars t superclass|

    "
     cleanup needed here: extract common things with name:inEnvironment:...
     and restructure things ... currently way too complex.
    "

    oldVars := oldMetaClass instanceVariableString.
    instanceVariableNames = oldVars ifTrue:[
"
        Transcript showCR:'no change (', oldVars , ') -> (', instanceVariableNames , ')'.
"
        ^ self
    ].

    oldNames := oldVars asCollectionOfWords.
    newNames := instanceVariableNames asCollectionOfWords.

    oldNames = newNames ifTrue:[
"
        Transcript showCR:'no real change'.
"
        "no real change (just formatting)"
        oldMetaClass setInstanceVariableString:instanceVariableNames.
        ^ self
    ]. 

"/    "
"/     let user confirm, if any name is no good (and was good before)
"/    "
"/    (oldNames inject:true
"/                into:[:okSoFar :word |
"/                         okSoFar and:[word first isUppercase]
"/                     ])
"/    ifTrue:[
"/        "was ok before"
"/        (newNames inject:true
"/                    into:[:okSoFar :word |
"/                             okSoFar and:[word first isUppercase]
"/                         ])
"/        ifFalse:[
"/            (self confirm:'class instance variable names should start with an uppercase letter
"/(by convention only)
"/
"/install anyway ?' withCRs)
"/            ifFalse:[
"/                ^ nil
"/            ]
"/        ]
"/    ].

    nClassInstVars := newNames size.

"
    Transcript showCR:'create new class/metaclass'.
"

    "
     create the new metaclass
    "
    oldMetaClass isPrivate ifTrue:[
        newMetaclass := oldMetaClass class "PrivateMetaclass" new.
        newMetaclass setOwningClass:(oldMetaClass owningClass).
    ] ifFalse:[
        newMetaclass := oldMetaClass class "Metaclass" new.
    ].
    superclass := oldMetaClass superclass.
    newMetaclass setSuperclass:superclass.
    newMetaclass instSize:(superclass instSize + nClassInstVars).
    (nClassInstVars ~~ 0) ifTrue:[
        newMetaclass setInstanceVariableString:instanceVariableNames
    ].
"/    newMetaclass flags:(Behavior flagBehavior "flagNotIndexed").
"/    newMetaclass setName:name.
"/    newMetaclass classVariableString:classvars.
"/    newMetaclass setComment:(self comment).

    "find the class which is my sole instance"

    oldClass := oldMetaClass theNonMetaclass.

    "
     create the new class
    "
    newClass := newMetaclass new.
    newClass setSuperclass:(oldClass superclass) instSize:(oldClass instSize).
    newClass flags:(oldClass flags).
    newClass setName:(oldClass name).
    newClass setInstanceVariableString:(oldClass instanceVariableString).
    newClass classVariableString:(oldClass classVariableString).
    newClass setComment:(oldClass comment).
    newClass setCategory:(oldClass category).
    (t := oldClass attributes) notNil ifTrue:[
        newClass classAttributes:t.
    ].        
    newClass setClassFilename:(oldClass getClassFilename).

    "/ set the new classes package
    "/ from the old package

    newClass setPackage:(oldClass getPackage).

    "/ and keep the binary revision
    newClass setBinaryRevision:(oldClass binaryRevisionString).

    changeSet := Set new.
    ((oldNames size == 0) 
    or:[newNames startsWith:oldNames]) ifTrue:[
        "new variable(s) has/have been added - old methods still work"

"/        Transcript showCR:'copying methods ...'.
"/        Transcript endEntry.

        ClassBuilder copyMethodsFrom:oldMetaClass for:newMetaclass.
        ClassBuilder copyMethodsFrom:oldClass for:newClass.

        "
         but have to recompile methods accessing stuff now defined
         (it might have been a global/undeclared before ...)
        "

        addedNames := newNames copyFrom:oldNames size + 1. "/ newNames reject:[:nm | oldNames includes:nm ].

"/        Smalltalk silentLoading ifFalse:[
"/            Transcript showCR:'recompiling class methods of ' , newMetaclass name ,
"/                              ' accessing any of ' , addedNames printString.
"/        ].

        "recompile class-methods"    
        newMetaclass recompileMethodsAccessingAny:addedNames.
    ] ifFalse:[
        "
         create the changeSet; that's the set of class instvar names
         which have changed their position or are new
        "
        offset := 0. oldOffsets := Dictionary new.
        oldNames do:[:nm | offset := offset + 1. oldOffsets at:nm put:offset].
        offset := 0. newOffsets := Dictionary new.
        newNames do:[:nm | offset := offset + 1. newOffsets at:nm put:offset].

        oldOffsets keysAndValuesDo:[:varName :oldOffset |
            ((newOffsets includesKey:varName) not
            or:[ oldOffset ~~ (newOffsets at:varName) ]) ifTrue:[
                changeSet add:varName
            ]
        ].
        newOffsets keysAndValuesDo:[:varName :newOffset |
            ((oldOffsets includesKey:varName) not
            or:[ newOffset ~~ (oldOffsets at:varName) ]) ifTrue:[
                changeSet add:varName
            ]
        ].

"/        Smalltalk silentLoading ifFalse:[
"/            Transcript showCR:'recompiling class methods of ' , newMetaclass name ,
"/                              ' accessing any of ' , changeSet printString.
"/        ].

        "
         recompile class-methods accessing any c-instvar with a changed position
        "
        ClassBuilder copyInvalidatedMethodsFrom:oldMetaClass for:newMetaclass accessingAny:changeSet.
        newMetaclass recompileInvalidatedMethods.

        ClassBuilder copyMethodsFrom:oldClass for:newClass.
    ].

    delta := newNames size - oldNames size.

    "/ preserve existing classInstVar values (but not those from Class)
    newMetaclass allInstVarNames do:[:nm |
        |v|

        (Class class allInstVarNames includes:nm) ifFalse:[
            v := oldClass instVarNamed:nm ifAbsent:nil.
            v notNil ifTrue:[
                newClass instVarNamed:nm put:v.    
            ].
        ].
    ].

    "
     get list of all subclasses - do before superclass is changed
    "
    allSubclasses := oldClass allSubclasses asOrderedCollection.
    "/ cg: wrong: allSubclasses := allSubclasses asSortedCollection:[:a :b | b isSubclassOf:a].
    allSubclasses := allSubclasses topologicalSort:[:a :b | b isSubclassOf:a]. 

    oldToNew := IdentityDictionary new.

    "
     create a new class tree, based on the new version
    "
    Smalltalk flushCachedClasses.
    Class flushSubclassInfoFor:oldClass.
    allSubclasses do:[:aSubclass |
        |oldSuper|

        Class flushSubclassInfoFor:aSubclass.
        oldSuper := aSubclass superclass.
        oldSubMeta := aSubclass class.

        newSubMeta := Metaclass new.
        oldSuper == oldClass ifTrue:[
            newSubMeta setSuperclass:newMetaclass.
        ] ifFalse:[
            newSubMeta setSuperclass:(oldToNew at:oldSuper) class.
        ].
        newSubMeta instSize:(oldSubMeta instSize + delta).
        newSubMeta flags:(oldSubMeta flags).
"/        newSubMeta setName:(oldSubMeta name).
        newSubMeta setInstanceVariableString:(oldSubMeta instanceVariableString).
"/        newSubMeta setComment:(oldSubMeta comment).

        newSub := newSubMeta new.
        oldSuper == oldClass ifTrue:[
            newSub setSuperclass:newClass.
        ] ifFalse:[
            newSub setSuperclass:(oldToNew at:oldSuper).
        ].

"/        newSub setMethodDictionary:(aSubclass methodDictionary copy).
"/        newSub class setMethodDictionary:(aSubclass class methodDictionary copy).
        newSub setName:(aSubclass name).
        newSub setClassVariableString:(aSubclass classVariableString).
        newSub setSharedPoolNames:(aSubclass sharedPoolNames).
        newSub setInstanceVariableString:(aSubclass instanceVariableString).
        (t := aSubclass attributes) notNil ifTrue:[
            newSub classAttributes:t.
        ].        
        newSub package:(aSubclass package).
        newSub setClassFilename:(aSubclass classFilename).
        newSub setComment:(aSubclass comment).
        newSub setCategory:(aSubclass category).
        newSub instSize:(aSubclass instSize).
        newSub setBinaryRevision:(aSubclass binaryRevisionString).

        oldToNew at:aSubclass put:newSub.

        aSubclass setCategory:#'* obsolete *'.

        "/ preserve existing classInstVar values (but not those from Class)

        newSubMeta allInstVarNames do:[:nm |
            |v|

            (Class class allInstVarNames includes:nm) ifFalse:[
                v := aSubclass instVarNamed:nm ifAbsent:nil.
                v notNil ifTrue:[
                    newSub instVarNamed:nm put:v.    
                ].
            ].
        ].

    ].

    "recompile what needs to be"

    delta == 0 ifTrue:[
        "only have to recompile class methods accessing 
         class instvars from changeset
        "

        allSubclasses do:[:oldSubclass |
            |newSubclass|

            newSubclass := oldToNew at:oldSubclass.

"/            Smalltalk silentLoading ifFalse:[
"/                Transcript showCR:'recompiling class methods of ' , newSubclass class name ,
"/                                  ' accessing any of ' , changeSet printString.
"/            ].

            ClassBuilder
                copyInvalidatedMethodsFrom:oldSubclass class for:newSubclass class 
                accessingAny:changeSet orSuper:true.

            ClassBuilder
                copyInvalidatedMethodsFrom:oldSubclass for:newSubclass 
                accessingAny:#() orSuper:true.

            newSubclass class recompileInvalidatedMethods.
            newSubclass recompileInvalidatedMethods.
        ]
    ] ifFalse:[
        "
         have to recompile all class methods accessing class instvars
        "
        commonClassInstVars := oldClass class allInstVarNames.
        changeSet do:[:v |
            commonClassInstVars remove:v ifAbsent:[]
        ].

        allSubclasses do:[:oldSubclass |
            |newSubclass classInstVars|

            newSubclass := oldToNew at:oldSubclass.

            classInstVars := newSubclass class allInstVarNames asNewSet.
            classInstVars removeAll:commonClassInstVars.
            classInstVars addAll:changeSet.

"/            Smalltalk silentLoading ifFalse:[
"/                Transcript showCR:'recompiling class methods of ' , newSubclass class name ,
"/                                  ' accessing any of ' , classInstVars printString.
"/            ].

            ClassBuilder
                copyInvalidatedMethodsFrom:oldSubclass class for:newSubclass class 
                accessingAny:classInstVars orSuper:true.

            ClassBuilder
                copyInvalidatedMethodsFrom:oldSubclass for:newSubclass 
                accessingAny:#() orSuper:true.

            newSubclass class recompileInvalidatedMethods.
            newSubclass recompileInvalidatedMethods.
        ]
    ].

    newClass addChangeRecordForClassInstvars:newClass.

    "install all new classes"

    (Smalltalk at:(oldClass name asSymbol) ifAbsent:nil) == oldClass ifTrue:[
        Smalltalk at:(oldClass name asSymbol) put:newClass.
        ClassBuilder checkForAliasesOf:oldClass with:newClass.

        "
         change any private subclasses' owners
        "
        oldClass privateClassesDo:[:aClass |
            aClass class setOwningClass:newClass
        ].
    ].
    "/ change the instances
    oldClass allInstancesDo:[:inst | inst changeClassTo: newClass].
    ObjectMemory flushCachesFor:oldClass.

    allSubclasses do:[:oldSubClass |
        |newSubClass|

        newSubClass := oldToNew at:oldSubClass.

"/        Transcript showCR:'install ' , newSubClass name , '(' , newSubClass category , ')' ,
"/                          ' as ' , newSubClass name.

        (Smalltalk at:(oldSubClass name asSymbol) ifAbsent:nil) == oldSubClass ifTrue:[
            Smalltalk at:oldSubClass name asSymbol put:newSubClass.
            ClassBuilder checkForAliasesOf:oldSubClass with:newSubClass.
        ].
        ObjectMemory flushCachesFor:oldSubClass.

        oldSubClass privateClassesDo:[:aClass |
            aClass class setOwningClass:newSubClass
        ].

        "/ change the instances
        oldSubClass allInstancesDo:[:inst | inst changeClassTo: newSubClass].
    ].

    "tell dependents ..."

    oldClass changed:#definition.
"/    oldClass nameSpace changed:#classDefinition with:oldClass.
"/    oldClass nameSpace ~~ Smalltalk ifTrue:[
"/        Smalltalk changed:#classDefinition with:oldClass.
"/    ].

    oldMetaClass changed:#definition.
    oldMetaClass nameSpace changed:#classDefinition with:oldMetaClass.
    oldMetaClass nameSpace ~~ Smalltalk ifTrue:[
        Smalltalk changed:#classDefinition with:oldMetaClass.
    ].
    oldClass setCategory:#'* obsolete *'.

    ^ newMetaclass

    "Created: / 29-10-1995 / 19:57:08 / cg"
    "Modified: / 01-04-1997 / 15:44:09 / stefan"
    "Modified: / 29-09-2011 / 16:02:51 / cg"
!

setPackageInNewClass:newClass fromOld:oldClass
    |pkg oldPkg answer|

    "/ set the new classes package
    "/ but be careful here ...

    oldClass isNil ifTrue:[
        "/ new classes get the current package ...
        pkg := Class packageQuerySignal query.
    ] ifFalse:[
        "/ cg: is this correct ?
        newClass setClassFilename:(oldClass getClassFilename).

        oldPkg := oldClass package.
        oldClass isLoaded ifFalse:[
            "/ autoloaded classes get the package of the autoload stub ...
            pkg := oldPkg
        ] ifTrue:[
            "/ not autoloading, check for packageRedef ...
            buildingPrivateClass ifTrue:[
                pkg := environment package.
            ] ifFalse:[
                pkg := Class packageQuerySignal query.
                oldPkg ~= pkg ifTrue:[
                    pkg == PackageId noProjectID ifTrue:[
                        pkg := oldPkg.
                    ] ifFalse:[ 
                        newClass setPackage:pkg.  "/ so the notification handler knows, what we are talking about
                        answer := Class classRedefinitionNotification
                                      raiseRequestWith:(oldClass -> newClass)
                                      errorString:('redefinition of class: ' , oldClass name).
                        answer == #keep ifTrue:[
                            pkg := oldPkg. "/ keep old package
                        ] ifFalse:[
                            answer ~~ #continue ifTrue:[
                                newClass package:pkg.
                                ^ nil "/ cancel
                            ].
                            "/ take new package
                        ].
                    ].
                ].
                newClass setBinaryRevision:(oldClass binaryRevisionString).
            ].
        ].
    ].
    pkg notNil ifTrue:[
"/ Transcript showCR:('set package of class: ' , newClass name , ' to ' , pkg printString).
        oldPkg = pkg ifTrue:[
            newClass setPackage:pkg "/ does not produce update requests...
        ] ifFalse:[
            newClass package:pkg.
        ]
    ].

    "Modified: / 29-09-2011 / 15:58:56 / cg"
!

setupNewClass:newClass fromOld:oldClass
    |newFlags superFlags nInstVars|

    (instanceVariableNames size > 0) ifTrue:[
        nInstVars := instanceVariableNames countWords.
    ] ifFalse:[
        nInstVars := 0.
    ].

    newFlags := flags. "/ self flagsForVariable:variable pointers:pointers words:words.
    superClass isNil ifTrue:[
        superFlags := 0
    ] ifFalse:[
        superFlags := superClass flags bitAnd:(Behavior maskIndexType bitInvert). "preserve other bits"
    ].

    oldClass notNil ifTrue:[
        oldClass isBuiltInClass ifTrue:[
            "
             special care when redefining Method, Block and other built-in classes,
             which might have other flag bits ...
            "
            newFlags := newFlags bitOr:(oldClass flags bitAnd:(Behavior maskIndexType bitInvert))
        ]
    ].
    newClass flags:(newFlags bitOr:superFlags). "preserve  inherited special bits"

    (nInstVars ~~ 0) ifTrue:[
        newClass setInstanceVariableString:instanceVariableNames
    ].
    oldClass notNil ifTrue:[
        "/ setting first will make new class clear obsolete classvars
        newClass setClassVariableString:(oldClass classVariableString).
        newClass setSharedPoolNames:(oldClass sharedPoolNames).
        newClass setClassFilename:(oldClass getClassFilename).
        newClass setPrimitiveDefinitions:(oldClass primitiveDefinitionsString).
        newClass setPrimitiveFunctions:(oldClass primitiveFunctionsString).
        newClass setPrimitiveVariables:(oldClass primitiveVariablesString).
    ].
    newClass setClassVariableString:classVariableNames.

    "Modified: / 18-01-2011 / 20:44:04 / cg"
! !

!ClassBuilder methodsFor:'checks'!

checkClassName
    |fullNameString idx environmentName|

    "/ check if the given name implies a (sub-) namespace
    "/ happens (currently) when installing autoloaded classes
    (className includes:$:) ifTrue:[
        environment notNil ifTrue:[
            fullNameString := environment name , '::' , className
        ] ifFalse:[
            fullNameString := className
        ].
        idx := fullNameString lastIndexOf:$:.
        (idx > 1 and:[(fullNameString at:idx-1) == $:]) ifTrue:[
            className := (fullNameString copyFrom:idx+1) asSymbol.
            environmentName := fullNameString copyTo:idx-2.
            environment := Smalltalk at:environmentName asSymbol.
            environment isNil ifTrue:[
                environment := NameSpace fullName:environmentName
            ].
        ].
    ].

    environment isNil ifTrue:[
        "/ no constraints
        ^ self
    ].

    (className isSymbol not
    or:[className size == 0]) ifTrue:[
        ClassBuildError raiseErrorString:'Invalid class name (must be a nonEmpty symbol)'.
    ].
    (className first isLetterOrUnderline) ifFalse:[
        ClassBuildError raiseErrorString:'Invalid class name (must start with a letter)'.
    ].
    (className conform:[:ch | ch isLetterOrDigit or:[ch == $_]]) ifFalse:[
        ClassBuildError raiseErrorString:'Invalid class name (must consist of letters, digits or underline)'.
    ].

    "Modified: / 11-08-2006 / 12:46:54 / cg"
!

checkConventionsFor:className subClassOf:aClass instVarNames:instVarNameString classVarNames:classVarNameString
    "Check for some 'considered bad-style' things, like lower case names.
     NOTICE:
     I don't like the confirmers below - we need a notifying: argument, to give
     the outer codeview a chance to highlight the error.
     (but that's how its defined in the book - maybe I will change it anyway).
    "

    |names idx what doChecks answ|

    doChecks := Metaclass confirmationQuerySignal query.
    doChecks == false ifTrue:[^ true].
    environment isNil ifTrue:[^ true].

    "let user confirm, if the classname is no good"
    className isUppercaseFirst ifFalse:[
        aClass == NameSpace ifTrue:[
            what := 'namespace'
        ] ifFalse:[
            what := 'class'
        ].

        answ := Class classConventionViolationConfirmationQuerySignal query.
        answ notNil ifTrue:[^ answ].

        ClassBuildWarning new
            className:className;
            messageText:('Class Name "%1"\should start with an uppercase letter (by convention only)'withCRs
                            bindWith:className allBold);
            raiseRequest.
"/        (self confirm:('%1 name "%2" should start with an uppercase letter\(by convention only)\\install anyway ?'
"/                         bindWith:what with:className) withCRs)
"/        ifFalse:[
"/            ^ false
"/        ]
    ].

    names := instVarNameString asCollectionOfWords.

    "let user confirm, if any instvarname is no good"
    (idx := names findFirst:[:word | word isUppercaseFirst]) ~~ 0 ifTrue:[
        answ := Class classConventionViolationConfirmationQuerySignal query.
        answ notNil ifTrue:[^ answ].

        ClassBuildWarning new
            className:className;
            messageText:('%1: instance variable named "%2"\should start with a lowercase letter (by convention only)'withCRs
                            bindWith:className 
                            with:(names at:idx) allBold);
            raiseRequest.
"/        (self confirm:className , ': instance variable named ''' , (names at:idx) allBold , ''' 
"/should start with a lowercase letter (by convention only).
"/
"/Install anyway ?' withCRs)
"/        ifFalse:[
"/            ^ false
"/        ]
    ].

    names := classVarNameString asCollectionOfWords. 

    "let user confirm, if any classvarname is no good"
    (idx := names findFirst:[:word | word first isLowercase]) ~~ 0 ifTrue:[
        answ := Class classConventionViolationConfirmationQuerySignal query.
        answ notNil ifTrue:[^ answ].

        ClassBuildWarning new
            className:className;
            messageText:('%1: class variable named "%2"\should start with an uppercase letter (by convention only)'withCRs
                            bindWith:className 
                            with:(names at:idx) allBold);
            raiseRequest.
"/        (self confirm:className , ': class variable named ''' , (names at:idx) allBold  , ''' 
"/should start with an uppercase letter (by convention only).
"/
"/Install anyway ?' withCRs)
"/        ifFalse:[
"/            ^ false
"/        ].
    ].

    ^ true

    "Created: / 15-10-1996 / 11:56:38 / cg"
    "Modified: / 18-03-1999 / 18:22:47 / stefan"
    "Modified: / 18-02-2007 / 12:46:10 / cg"
!

checkForCircularDefinitionFrom:oldClass
    oldClass allSuperclassesDo:[:cls |
        cls name = realNewName ifTrue:[
            ^ true
        ]
    ].

    superClass notNil ifTrue:[
        superClass allSuperclassesDo:[:cls |
            cls name = realNewName ifTrue:[
                ^ true
            ]
        ].
    ].
    ^ false
!

checkInstvarRedefsWith:stringOfInstVarNames subclassOf:aClass old:oldClass name:newName
    |superInstVars msg|

    aClass notNil ifTrue:[
        "
         check for instVar redef of superClass instVars
        "
        superInstVars := aClass allInstVarNames.
        stringOfInstVarNames asCollectionOfWords do:[:nm |
            (superInstVars includes:nm) ifTrue:[
                msg := 'instVar "%1" is already defined in a superclass of "%2"' bindWith:nm allBold with:newName allBold.
                Tools::ToDoListBrowser notNil ifTrue:[
                    "/ experimental
                    self
                        notifyTodo:msg position:nil
                        className:newName selector:nil
                        severity:#error priority:#high 
                        equalityParameter:nm
                        checkAction:[:e | 
                            |superClass class|

                            superClass := Smalltalk classNamed:aClass name.    
                            class := Smalltalk classNamed:newName.    

                            (superClass allInstVarNames includes:nm) and:[class instVarNames includes:nm]].
                ].

                ParserFlags warnings ifTrue:[
                    (oldClass notNil 
                    and:[stringOfInstVarNames = oldClass instanceVariableString])
                    ifTrue:[
                        msg := 'InstVar conflict in "%1" for "%2" due to superclass change.\You now have two different instVar slots with the same name.\\Don''t forget to fix this later.' bindWith:newName allBold with:nm allBold.
                        self warn:msg withCRs.
                    ] ifFalse:[
                        msg := 'instVar "%1" is already defined in a superclass.\Change the definition of "%2" anyway ?\\Don''t forget to fix this later.' bindWith:nm allBold with:newName allBold.
                        ^ self confirm:msg withCRs
                    ].
                ]
            ]
        ].
    ].

    oldClass notNil ifTrue:[
        "
         check for instVar redefs in subclass instVars
        "
        oldClass allSubclassesDo:[:sub |
            |vars|

            vars := sub instVarNames.
            stringOfInstVarNames asCollectionOfWords do:[:nm |
                |msg|

                (vars includes:nm) ifTrue:[
                    msg := 'subclass "%1" also defines an instVar named "%2"' bindWith:sub name allBold with:nm allBold.
                    Tools::ToDoListBrowser notNil ifTrue:[
                        "/ experimental
                        self
                            notifyTodo:msg position:nil
                            className:newName selector:nil
                            severity:#error priority:#high 
                            equalityParameter:nm
                            checkAction:[:e | 
                                |class|

                                Class flushSubclassInfo.
                                class := Smalltalk classNamed:newName.    

                                (class instVarNames includes:nm)
                                and:[ class allSubclasses contains:[:aSubclass | aSubclass instVarNames includes:nm]]].
                    ].
                    ParserFlags warnings ifTrue:[
                        msg := ('subclass "%1" also defines an instVar named "%2".\\Change the definition of "%3" anyway ?\Notice: you must fix this later.'
                                        bindWith:sub name allBold with:nm allBold with:newName allBold) withCRs.
                        ^ self confirm:msg 
                    ]
                ]
            ]
        ]
    ].
    ^ true

    "Created: / 29-01-1997 / 17:42:11 / cg"
    "Modified: / 10-02-2007 / 21:35:22 / cg"
!

checkValidPools
    "check for invalid subclassing of UndefinedObject and SmallInteger"

    poolDictionaries notNil ifTrue:[
        poolDictionaries asCollectionOfWords do:[:eachPoolName |
            |pool|

            environment notNil ifTrue:[    
                environment isNameSpace ifTrue:[
                    pool := environment classNamed:eachPoolName.
                ] ifFalse:[
                    pool := environment nameSpace classNamed:eachPoolName.
                ].
            ].
            pool isNil ifTrue:[
                pool := Smalltalk classNamed:eachPoolName.
            ].
            (pool notNil and:[pool isBehavior]) ifTrue:[
                pool autoload.
                pool isSharedPool ifFalse:[
                    self error:('Not a valid pool: ' , eachPoolName) mayProceed:true.
                ]
            ]
        ]
    ].
!

checkValidSubclassing
    "check for invalid subclassing of UndefinedObject and SmallInteger"
    superClass notNil ifTrue:[
        superClass canBeSubclassed ifFalse:[
            ClassBuildError raiseErrorString:('it is not possible to subclass ' , superClass name).
        ]
    ].
!

checkValidVarNamesFor:className subClassOf:aClass instVarNames:instVarNameString classVarNames:classVarNameString
    "Check for some 'considered bad-style' things, like lower case names.
     NOTICE:
     I don't like the confirmers below - we need a notifying: argument, or a
     notifierSignal to give the outer codeview a chance to highlight the error.
     (but that's how its defined in the book - maybe I will change it anyway).
    "

    |instVarNames classVarNames privateClassNames conflicts|

    instVarNames := instVarNameString asCollectionOfWords.

    "check for instvar redefs within local instvars"
    instVarNames keysAndValuesDo:[:index :aName |
        (instVarNames indexOf:aName startingAt:index+1) ~~ 0 ifTrue:[
            self warn:('instance variable "%1"\occurs multiple times in instVarString.\\Class %2 not installed.'
                        bindWith:aName 
                        with:className) withCRs.
            ^ false.
        ]
    ].

    classVarNames := classVarNameString asCollectionOfWords. 

    "check for classvar redefs within local instvars"
    classVarNames keysAndValuesDo:[:index :aName |
        (classVarNames indexOf:aName startingAt:index+1) ~~ 0 ifTrue:[
            self warn:'class variable ''' , aName , '''\occurs multiple times in classVarString.\\Class not installed.' withCRs.
            ^ false.
        ]
    ].

    oldClass notNil ifTrue:[
        "check against private classes"

        privateClassNames := oldClass theNonMetaclass privateClasses collect:[:cls | cls nameWithoutPrefix].
        conflicts := classVarNames intersect:privateClassNames.
        conflicts notEmpty ifTrue:[
            conflicts size == 1 ifTrue:[
                self warn:('Class variable "%1"\conflicts with corresponding private classes name.\The name will refer to the class variable.'
                            bindWith:conflicts first) withCRs.
            ] ifFalse:[
                self warn:('Some class variables conflict with corresponding private classes name.\Names will refer to the class variable.' withCRs).
            ].
            ^ true.
        ]
    ].

    ^ true

    "Created: / 08-01-1997 / 21:09:14 / cg"
    "Modified: / 11-05-2012 / 09:26:27 / cg"
! !

!ClassBuilder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


ClassBuilder initialize!
