"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ProjectChecker
	instanceVariableNames:'packages currentPackage currentPackageDef classes methods
		problems phase checkExtensionsOnly rulesApplied'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Projects'
!

!ProjectChecker class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    A simple project checker that can search whole projects or individual
    classes or methods for various problems that may cause build problems,
    such as:
        - inconsistent/messed up project definition class
        - method code problems

    NOTE: this is not a lint. It only checks for inconsitent configuration
    (projectDefinition class data vs. real data) and compilability (stc limitations).

    NOTE: Not yet finished. This code is meant as a single central entry for all the
    source code management tools like SCM Utilities, NewSystemBrowser ets. That code
    will be refactored later once this tool prooves itself useful and mature enough.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        Tools::ProjectCheckerBrowser

"
!

examples

    "
        ProjectChecker check: 'stx:libbasic'
        ProjectChecker check: 'stx:libtool'
        ProjectChecker check: 'stx:libbasic3'
    "
! !

!ProjectChecker class methodsFor:'instance creation'!

forPackage: packageId
    ^self new
        package: packageId;
        yourself.

    "Created: / 25-07-2012 / 18:00:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ProjectChecker class methodsFor:'checking'!

check: package

    ^self new check: package

    "Created: / 11-01-2012 / 16:46:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectChecker methodsFor:'accessing'!

checkExtensionsOnly:aBoolean
    checkExtensionsOnly := aBoolean.
!

classes: aCollection
    classes := aCollection.

    "Created: / 13-02-2012 / 17:06:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methods
    ^ methods
!

methods:something
    methods := something.
!

package:packageId
    "Adds `packageId` to set of checked packages"

    (packages includes: packageId) ifFalse:[ 
        packages add: packageId 
    ].

    "Modified (comment): / 22-02-2014 / 22:03:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

problems
    ^ problems

    "Modified: / 23-02-2012 / 15:14:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectChecker methodsFor:'checking'!

check

    problems removeAll.
    packages do:[:each |
        currentPackage := each.
        currentPackageDef := ProjectDefinition definitionClassForPackage: currentPackage.
        currentPackageDef isNil ifTrue:[
            self addProblem: (ProjectProblem newProjectDefinitionDoesNotExist package: currentPackage).
            ^self    
        ].

        ActivityNotification raiseRequestWith:self errorString:'Checking package...'.
        self checkPackage.
        (checkExtensionsOnly ? false) ifFalse:[
            ActivityNotification raiseRequestWith:self errorString:'Checking classes...'.
            self checkClasses.
        ].
        ActivityNotification raiseRequestWith:self errorString:'Checking methods...'.
        self checkMethods.
    ].

    "Created: / 11-01-2012 / 16:47:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 21:59:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

check: package

    self package: package.
    self check.

    "Created: / 11-01-2012 / 16:47:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectChecker methodsFor:'checks-individual'!

checkClassListConsistency
    "Checks whether all classes listed in #classNamesAndAttributes are present
    and if all present classes are listed"

    |classesInImage classesInDescription classesInDescriptionChecked onlyInDescription onlyInImage|
    "WARNING: Copy/paste of ProjectDefinition>>validateDescription"

    classesInImage := Smalltalk allClasses select:[:cls | (cls package = currentPackage) and:[cls isPrivate not]].

    "/ classesInDescription := self classes asIdentitySet.
    classesInDescription := OrderedCollection new.
    ( (currentPackageDef compiled_classNames_common)
    , (currentPackageDef compiled_classNamesForPlatform:(OperatingSystem platformName))
    , (currentPackageDef autoloaded_classNames)) do:[:nm |
        |cls|

        cls := Smalltalk at:nm asSymbol.
        cls isNil ifTrue:[
            self addProblem: (ProjectProblem newClassListedButDoesNotExist className: nm)
        ] ifFalse:[
            cls package ~= currentPackage ifTrue:[
                self addProblem: (ProjectProblem newClassListedButInOtherPackage className: nm)
            ] ifFalse:[
                classesInDescription add:cls.
            ]
        ].
    ].

    classesInDescriptionChecked := Set new.
    classesInDescription do:[:eachClass |
        (classesInDescriptionChecked includes: eachClass) ifTrue:[
            self addProblem: (ProjectProblem newClassListedMultipleTimes className: eachClass name)
        ].

        eachClass sharedPoolNames do:[:eachPoolName |
            |pool|

            pool := eachClass nameSpace classNamed:eachPoolName.
            pool isNil ifTrue:[
                eachClass nameSpace ~~ Smalltalk ifTrue:[
                    pool := Smalltalk classNamed:eachPoolName.
                ]
            ].
            pool isNil ifTrue:[
                self addProblem: 
                    (ProjectProblem newClassUsesPoolButItDoesNotExist
                        className: eachClass name;
                        poolName: eachPoolName).
            ] ifFalse:[
                pool isSharedPool ifFalse:[
                    self addProblem: 
                        (ProjectProblem newClassUsesPoolButItIsNotASharedPool
                            className: eachClass name;
                            poolName: eachPoolName).                
                ].
            ].
        ].

        (eachClass superclass notNil "/Care about classes with nil superclass - Object & Autoload
            and:[eachClass superclass package == eachClass package]) ifTrue:[
            (classesInDescriptionChecked includes: eachClass superclass) ifFalse:[
                self addProblem:
                    (ProjectProblem newClassListedBeforeItsSuperclass
                        className: eachClass name;
                        superClassName: eachClass superclass name)
            ].
        ].
        eachClass sharedPools do:[:eachPool|
            eachPool package == eachClass package ifTrue:[
                (classesInDescriptionChecked includes: eachPool) ifFalse:[
                    self addProblem:
                        (ProjectProblem newClassListedBeforeItsPool
                            className: eachClass name;
                            poolName: eachPool name)
                ].
            ].
        ].

        classesInDescriptionChecked add: eachClass.
    ].

    classesInImage ~= classesInDescription ifTrue:[
        "This is done later in checkClassesListedInProjectDefinition:"
"/        onlyInImage := (classesInImage reject:[:cls | classesInDescription includes:cls]).
"/        onlyInImage do:[:cls|
"/            self addProblem: 
"/                (ProjectProblem newClassListedButInOtherPackage className: cls name).
"/        ].
        onlyInDescription := (classesInDescription reject:[:cls | classesInImage includes:cls]).
        onlyInDescription do:[:cls|
            self addProblem: 
                (ProjectProblem newClassListedButDoesNotExist className: cls name)
        ].
    ].

    "Created: / 11-01-2012 / 17:14:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 21:46:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkClassesAutoloadedSuperclasse: aCollection"of Class"
    currentPackageDef classNamesAndAttributesDo:[:clsnm :attributes|
        | cls superclass |

        cls := Smalltalk at: clsnm.
        (aCollection includes: cls) ifTrue:[
            (attributes includes: #autoload) ifFalse:[
                "/ Care for Object!!
                superclass := cls superclass.
                superclass notNil ifTrue:[
                    | superDef |

                    superDef := ProjectDefinition definitionClassForPackage: superclass package.
                    superDef isNil ifTrue:[
                        problems add:
                            (ProjectProblem newClassIsCompiledButSuperclassProjectDefinitionIsMissing
                                            package: currentPackage;
                                            className: clsnm;
                                            yourself)   
                    ] ifFalse:[
                        (superDef isAutoloaded:superclass) ifTrue:[
                            problems add:
                                (ProjectProblem newClassIsCompiledButSuperclassIsAutoloaded
                                    package: currentPackage;
                                    className: clsnm;
                                    yourself)
                        ].
                    ]
                ].
            ].
        ].
    ].

    "Created: / 20-09-2013 / 11:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-10-2013 / 12:45:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkClassesForMethodsInNoProject:classesToCheck 
    | checker |

    checker := [:cls | 
        cls 
            selectorsAndMethodsDo:[:sel :mth | 
                (mth package isNil or:[ mth package == PackageId noProjectID ]) ifTrue:[
                    "Sigh, special hack for Expecco"
                    ((cls name = 'Expecco::AbstractApplication class' and:[ sel = 'flags' ]) or:[
                     (cls name = 'Expecco::Browser class' and:[ sel = 'flags' ])]) ifFalse:[
                        self addProblem:(ProjectProblem newMethodInNoPackage className:cls name
                                    selector:sel).
                    ]
                ]
            ]
    ].
    classesToCheck do:[:class | 
        checker value:class theMetaclass.
        checker value:class theNonMetaclass.
    ]

    "Created: / 13-02-2012 / 18:18:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkClassesForNonQualifiedSharedPools: classesToCheck 

    classesToCheck do:[:cls|
        cls sharedPoolNames do:[:poolName|
            (Smalltalk at: poolName asSymbol) isNil ifTrue:[
                | ns |

                ns := cls nameSpace.
                (ns == Smalltalk or:[(ns at: poolName asSymbol) isNil]) ifTrue:[
                    self addProblem:
                        (ProjectProblem newClassUsesPoolButItIsNotASharedPool
                                className: cls name;
                                poolName: poolName)
                ]
            ]
        ]
    ].

    "Created: / 13-09-2012 / 16:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkClassesListedInProjectDefinition: classesToCheck

    | classNamesListed |

    classNamesListed := currentPackageDef classNames.

    classesToCheck do:[:class|
        (class isPrivate not and:[(classNamesListed includes: class name) not]) ifTrue:[
            self addProblem: 
                (ProjectProblem newClassNotListed className: class name).
        ]
    ].

    "Created: / 13-02-2012 / 18:18:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkExtensionsListConsistency
    "Checks whether all extensions listed in #extensionMethodNames are present
     and if all extension methods are listed.
     Also check if any regular or extension method is also listed in some other package
     (which may happen after a move, if the original package was not updated)"

    | extensionsListed extensionsPresent allOtherExtensions checkMethod|

    extensionsListed := OrderedCollection new.
    currentPackageDef extensionMethodNames pairWiseDo:[:cls :sel|
        extensionsListed add: (Array with: cls with: sel)
    ].
    extensionsPresent := OrderedCollection new.
    currentPackageDef searchForExtensions do:[:each|
        "JV@2012-09-07: Do not take Java methods into an account, they
         should not be listed in extensionMethodNames.
         They are loaded lazily by JavaClassReader and if listed here,
         they would cause an error if the package is loaded from source.
         Sort of a HACK, indeed"
        each mclass theNonMetaclass isJavaClass ifFalse:[
            extensionsPresent add: (Array with: each mclass name with: each selector)
        ].
    ].

    (extensionsListed \ extensionsPresent) do:[:clsAndSel|
        |cls clsName selector|

        clsName := clsAndSel first.
        selector := clsAndSel second.
        (cls := Smalltalk classNamed: clsName) isNil ifTrue:[
            self addProblem: 
                (ProjectProblem newExtensionMethodsClassDoesNotExist
                    className: clsName selector: selector).                            
        ] ifFalse:[
            (cls compiledMethodAt:selector) isNil ifTrue:[
                self addProblem: 
                    (ProjectProblem newExtensionMethodListedButDoesNotExist
                        className: clsName selector: selector). 
            ] ifFalse:[
                self addProblem: 
                    (ProjectProblem newExtensionMethodListedButInDifferentPackage
                        className: clsName selector: selector). 
            ]
        ]
    ].

    (extensionsPresent \ extensionsListed) do:[:clsAndSel|
         self addProblem: 
            (ProjectProblem newExtensionMethodNotListed
                className: clsAndSel first selector: clsAndSel second).                            
    ].

    allOtherExtensions := Set new.
    ProjectDefinition allSubclassesDo:[:eachOther |
        eachOther ~~ currentPackageDef ifTrue:[
            Error handle:[:ex |
                Transcript showCR:('ProjetChecker [warning]: ignored error while asking ',eachOther name,' for extensionMethods').
                ex return
            ] do:[
                allOtherExtensions addAll:(eachOther extensionMethods).
            ].
        ].
    ].

    checkMethod :=
        [:eachMethodHere |
            (allOtherExtensions includes:eachMethodHere) ifTrue:[
                |otherProjectDefinitions|

                otherProjectDefinitions := OrderedCollection new.
                "/ where is it?
                ProjectDefinition allSubclassesDo:[:someOtherPackage |
                    someOtherPackage ~~ currentPackageDef ifTrue:[
                        (someOtherPackage extensionMethods includes:eachMethodHere) ifTrue:[
                            otherProjectDefinitions add:someOtherPackage
                        ]
                    ]
                ].
                otherProjectDefinitions notEmptyOrNil ifTrue:[
                    otherProjectDefinitions sortBySelector:#package.
                    self addProblem: 
                       (ProjectProblem newMethodListedInOtherPackage
                           className: (eachMethodHere mclass name) selector: (eachMethodHere selector);
                           otherProjectDefinitionClasses:otherProjectDefinitions;
                           yourself).                            
                ].
            ].
        ].

    currentPackageDef compiled_classesForPlatform do:[:eachClass |
        eachClass instAndClassMethodsDo:[:m |
            (m package = currentPackage) ifTrue:[ checkMethod value:m].
        ].
    ].
    currentPackageDef extensions do:checkMethod.
!

checkExtensionsPrerequisites
    "Checks whether packages of all extensions method classes are listed
     in package prerequisites"

    |preRequisites|

    preRequisites := currentPackageDef effectivePreRequisites.
    currentPackageDef searchForExtensions do:[:mthd|
        (preRequisites includes: mthd mclass package) ifFalse:[
"/            self problem: ('%3 required by extension method but not in prerequisites' bindWith: mthd mclass package)
"/                 description: ('An extension method %1>>%2 extends class in package %3 but the package is not listed in package''s prerequisited. This leads into missing methods and strange bugs when application is compiled and run!!' bindWith: mthd class with: mthd selector with: mthd class package)
"/                 severity: #error data: mthd
         ].
    ]

    "Created: / 12-01-2012 / 12:41:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethodCodingStyle: method
    "Checks for various coding style violations such as 'self halt' or
     improper indentation :-)"

    "To be implemented"

    "Created: / 11-04-2012 / 12:38:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethodSTCCompilability1: method into: problemIssue
    "Checks is the method can be compiled by STC based on Parser error/warnings"

    | lang compiler |

    lang := method programmingLanguage.
    lang isSmalltalk ifFalse:[ ^ self ].

    compiler := lang compilerClass new.
    compiler
        compile:method source
        forClass:method mclass
        inCategory:'others'
        notifying:problemIssue
        install:false
        skipIfSame:false
        silent:false
        foldConstants:true
        ifFail:[ ].

    compiler usedGlobals do:[:nm | 
        (nm startsWith:Smalltalk undeclaredPrefix) ifTrue:[
            problemIssue 
                addWarning:'Contains unresolved reference to: ',(nm copyFrom:(Smalltalk undeclaredPrefix size + 1))
                from:0 to:0
        ]
    ].

    "Created: / 11-04-2012 / 15:31:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethodSTCCompilability2: method into: problemIssue
    | env rules violations |

    "/ Check if SmallLint is available...
    (Smalltalk at:#RBCompositeLintRule) isNil ifTrue:[ ^ self ].

    env := SelectorEnvironment new.
    env addClass: method mclass selector: method selector.

    rulesApplied isNil ifTrue:[
        rulesApplied := RBCompositeLintRule allRules 
                    selectRules:[:rule | (rule isTaggedAs: #stc) and:[ rule severity == #error ]].
    ].
    rules := rulesApplied.

    rules runOnEnvironment: env.

    violations := rules selectRules:[:each | each result includesSelector: method selector in: method mclass ]. 
    violations flatten do:[:each | 
        problemIssue addViolation: each
    ].

    "Created: / 11-04-2012 / 15:54:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-05-2014 / 16:59:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethodSTCCompilability: method
    "Checks is the method can be compiled by STC (since STC won't compile
     everything bytecode compiler/jit compiler does, sigh"

    | cls issue1 issue2 |

    "No need to check the method if the class is autoloaded"
    cls := method mclass theNonMetaclass.
    cls isPrivate ifTrue:[ 
        cls := cls topOwningClass.
    ].
    (currentPackageDef autoloaded_classNames includes: cls name) ifTrue:[
        ^ self
    ].

    "/ Speed optimization: do not check method if it was compiled by 
    "/ stc and hasn't been changed since then.
    method byteCode isNil ifTrue:[ ^ self ].

    issue1 := ProjectProblem newMethodCompilabilityIssue1.
    issue1 method: method.
    self checkMethodSTCCompilability1: method into: issue1.
    issue1 hasIssue ifTrue:[
        self addProblem: issue1
    ].

    issue2 := ProjectProblem newMethodCompilabilityIssue2.
    issue2 method: method.
    self checkMethodSTCCompilability2: method into: issue2.
    issue2 hasIssue ifTrue:[
        self addProblem: issue2
    ]

    "Created: / 11-04-2012 / 12:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 29-05-2014 / 16:54:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethodSourceCode: method
    "Checks, whether method's source code is both
     available and parseable. Return true if the code
     is syntactically correct, false otherwise"

    | source |

    [    
        source := method source.
    ] on: Error do:[
        self addProblem:
            (ProjectProblem newMethodSourceNotAvailable method: method).
        ^false
    ].
    method programmingLanguage isSmalltalk ifFalse:[ ^ false ].

    [
        (Parser parseMethod: method source) == #Error ifTrue:[
            self addProblem:
                (ProjectProblem newMethodSourceCorrupted method: method).
            ^false.
        ]
    ] on: Error do:[
        self addProblem:
            (ProjectProblem newMethodSourceCorrupted method: method).
        ^false.
    ].

    ^true

    "Created: / 11-04-2012 / 12:29:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkSubProjects
    "Checks whether all subprojects listed in #subprojects are present."

    |isValidName subProjectsListed invalidNames validNames subProjectsNotPresent|

    isValidName := 
        [:prj |
            (prj first isLetter
            and:[ ((prj occurrencesOf:$:) <= 1)
            and:[ ((prj copyReplaceAll:$: with:$/) 
                        conform:[:ch | ch isLetterOrDigit or:['/-_.' includes:ch]]) ]])
        ].

    subProjectsListed := currentPackageDef subProjects.
    invalidNames := subProjectsListed select:[:prj | (isValidName value:prj) not].
    validNames := subProjectsListed select:isValidName.

    subProjectsNotPresent := validNames select:[:prj | prj asPackageId projectDefinitionClass isNil].

    invalidNames do:[:eachBadName |                                
        self addProblem: (ProjectProblem newInvalidPackageName badName:eachBadName).
    ].
    subProjectsNotPresent do:[:eachMissing |                                
        self addProblem: (ProjectProblem newProjectDefinitionDoesNotExist missing: eachMissing).
    ].
! !

!ProjectChecker methodsFor:'checks-private'!

checkClasses
    | classesToCheck |

    classesToCheck := classes notNil ifTrue:[ classes ] ifFalse:[ Smalltalk allClasses ].
    classesToCheck := classesToCheck select:[:each | each programmingLanguage isSmalltalk and:[ each package = currentPackage ] ].

    (currentPackageDef notNil and:[currentPackageDef isFolderForProjectsDefinition]) ifTrue:[
        classesToCheck remove:currentPackageDef ifAbsent:[]
    ].

    self checkClasses: classesToCheck.

    (currentPackageDef notNil and:[currentPackageDef isFolderForProjectsDefinition]) ifTrue:[
        classesToCheck do:[:eachClass |
            self addProblem: 
                (ProjectProblem newClassShouldNotBeInPackage className: eachClass name).
        ].
    ].

    "Created: / 11-01-2012 / 16:55:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2014 / 09:47:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkClasses: classesToCheck

    self checkClassesListedInProjectDefinition: classesToCheck.
    self checkClassesForMethodsInNoProject:classesToCheck.
    self checkClassesForNonQualifiedSharedPools:classesToCheck.
    self checkClassesAutoloadedSuperclasse:classesToCheck.

    "Created: / 13-02-2012 / 18:18:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-09-2013 / 11:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethod: method
    method programmingLanguage isSmalltalk ifTrue:[
        (self checkMethodSourceCode: method) ifTrue:[
            "/OK, method's source code is fine, perform more checks on
            "/ it's source code.

            "/ ActivityNotification raiseRequestWith:self errorString:'Checking stc compilability...'.
            self checkMethodSTCCompilability: method.
            "/ ActivityNotification raiseRequestWith:self errorString:'Checking coding style...'.
            self checkMethodCodingStyle: method.
        ]
    ].

    "Created: / 11-04-2012 / 12:27:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-07-2014 / 09:48:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethods
    methods notEmptyOrNil ifTrue:[
        self checkMethods: methods.
        ^self.
    ].

    self checkMethods:
        (Iterator on:[:whatToDo|
            | classesToCheck |

            classes notNil ifTrue:[
                classesToCheck := classes
            ] ifFalse:[
                classesToCheck := (Smalltalk allClasses select:[:cls | (cls package = currentPackage)]).
            ].
            classesToCheck do:[:cls|
                cls theNonMetaclass withAllPrivateClassesDo:[:eachClass |
                    ActivityNotification raiseRequestWith:self errorString:('Checking %1...' bindWith:eachClass name).
                    eachClass instAndClassSelectorsAndMethodsDo:[:s :m | 
                        m package = currentPackage ifTrue:[
                            ((checkExtensionsOnly ? false) not
                            or:[ m package ~~ cls package "isExtension" ]) ifTrue:[
                                whatToDo value:m
                            ]
                        ]
                    ]
                ].
            ]
        ])

    "Created: / 11-01-2012 / 16:55:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 21:48:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethods: methodsToCheck

    methodsToCheck do:[:m|self checkMethod: m].

    "Created: / 11-04-2012 / 12:16:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkPackage
    currentPackageDef isNil ifTrue:[^ self].
    currentPackageDef isFolderForProjectsDefinition ifFalse:[
        (checkExtensionsOnly ? false) ifFalse:[
            self checkClassListConsistency.
        ].
        self checkExtensionsListConsistency.
        self checkExtensionsPrerequisites.
    ].
    self checkSubProjects.

    "add more here..."

    "Created: / 11-01-2012 / 16:55:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectChecker methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    packages := OrderedCollection new.
    "/ currentPackage := nil.
    "/ currentPackageDef := nil.
    "/ classes := nil.
    "/ methods := nil.
    problems := List new.
    "/ phase := nil.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 22-02-2014 / 21:41:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectChecker methodsFor:'reporting'!

addProblem: aProjectProblem
Transcript showCR:aProjectProblem.
    aProjectProblem package: currentPackage.
    problems isNil ifTrue:[problems := OrderedCollection new].
    problems add: aProjectProblem.
    aProjectProblem allProblems:problems.

    "Created: / 23-02-2012 / 13:10:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2014 / 21:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectChecker class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

