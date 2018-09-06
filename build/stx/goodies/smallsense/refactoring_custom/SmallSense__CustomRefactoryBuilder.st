"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

Object subclass:#CustomRefactoryBuilder
	instanceVariableNames:'changeManager formatter model rewritterClass searcherClass
		parserClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

CustomRefactoryBuilder subclass:#ClassCategorySearcher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRefactoryBuilder
!

CustomRefactoryBuilder subclass:#ClassSearcher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRefactoryBuilder
!

CustomRefactoryBuilder subclass:#CodeSelectionSearcher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRefactoryBuilder
!

CustomRefactoryBuilder subclass:#MethodSearcher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRefactoryBuilder
!

CustomRefactoryBuilder subclass:#PackageSearcher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRefactoryBuilder
!

CustomRefactoryBuilder subclass:#ProtocolSearcher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRefactoryBuilder
!

!CustomRefactoryBuilder class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    Encapsulates performing refactoring changes on the source code within single object. 
    Single refactorings are stored as change objects which represens changes in the source code.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz> 

"
! !

!CustomRefactoryBuilder class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!CustomRefactoryBuilder methodsFor:'accessing'!

changeManager
    ^ changeManager
!

changeManager:something
    changeManager := something.
!

formatter
    ^ formatter
!

formatter: aFormatter
    formatter := aFormatter.

    "Modified (format): / 31-08-2014 / 17:12:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

model
    ^ model
!

model:something
    model := something.
!

parser
    "Returns prepared source code parser"

    ^ parserClass

    "Created: / 24-08-2014 / 23:36:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 22:02:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

parserClass
    "Returns a class used to parse the source code (i.e. RBParser)"

    ^ parserClass

    "Modified (comment): / 10-12-2014 / 22:01:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

parserClass: aClass
    "see parserClass"

    parserClass := aClass

    "Modified (comment): / 10-12-2014 / 21:59:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

rewritterClass
    "Returns a class used for rewriting the source code.
    For example CustomParseTreeRewriter."

    ^ rewritterClass

    "Modified (comment): / 10-12-2014 / 21:16:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

rewritterClass: aClass
    "see rewritterClass"

    rewritterClass := aClass.

    "Modified (comment): / 10-12-2014 / 21:16:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

searcher
    "Returns prepared source code searcher"

    ^ searcherClass new

    "Created: / 16-08-2014 / 22:13:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 22:03:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

searcherClass
    "Returns a class used to search on the source code (i.e. ParseTreeSearcher)"

    ^ searcherClass

    "Modified (comment): / 10-12-2014 / 22:00:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

searcherClass:something
    searcherClass := something.
! !

!CustomRefactoryBuilder methodsFor:'compiling'!

execute
    "Performs code changes ( add method, add class, rename class... )
    so they take in effect ( method is added, class is renamed, ... )
    with respect to current change manager implementatin - see CustomChangeManager subclasses."

    model execute

    "Created: / 15-08-2014 / 00:45:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 17:42:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

undoChanges
    "redo all changes made by execute method"

    model undoChanges

    "Created: / 19-10-2014 / 14:57:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 17:42:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder methodsFor:'initialization'!

initialize

    super initialize.
    model := CustomNamespace new.
    rewritterClass := CustomParseTreeRewriter.
    searcherClass := ParseTreeSearcher.
    parserClass := RBParser.

    "Created: / 15-08-2014 / 00:42:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 22:04:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder methodsFor:'parsing'!

parse: aSourceCode codeSelection: aCodeSelection
    "Retuns a parse tree from given source code string
    depending on what is selected within a method."

    aCodeSelection isWholeMethodSelected ifTrue: [ 
        ^ self parseMethod: aSourceCode  
    ].

    ^ self parseExpression: aSourceCode

    "Created: / 10-12-2014 / 21:40:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

parseExpression: aSourceCode
    "Helper for retrieving parse tree from source code string.
    Assume thats expression and if parsing fails then try method parsing."

    ^ self parser parseExpression: aSourceCode onError: [ :string :pos |
        self parser parseRewriteMethod: aSourceCode onError: [ :string :pos |
            self error: 'Could not parse ', string, ' at pos ', pos asString
        ]
    ]

    "Created: / 25-08-2014 / 22:34:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-02-2015 / 21:55:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

parseMethod: aSourceCode
    "Helper for retrieving parse tree from source code string.
    Assume thats method and if parsing fails then try expression parsing."

    ^ self parser parseRewriteMethod: aSourceCode onError: [ :string :pos |
        self parser parseExpression: aSourceCode onError: [ :string :pos |
            self error: 'Could not parse ', string, ' at pos ', pos asString
        ]
    ]

    "Created: / 25-08-2014 / 22:35:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-02-2015 / 21:55:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder methodsFor:'refactory - changes'!

changeCategoryOf: aClass to: aCategory
    "Changes class category to the given one in given class"
    | change |

    (self model classFor: aClass) category: aCategory.

    change := (self initializeChange: RefactoryClassCategoryChange)
        changeClass: aClass;
        category: aCategory;
        yourself.

    model changes addChange: change

    "Created: / 08-11-2014 / 13:40:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 17:35:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

executeReplace: searchPattern with: rewritePattern inCodeSelection: aCodeSelection
    "Performs replacement on some code selection within method source code.
    Firstly the search and relace is limited just to some selection 
    (i.e. some expression, but whole method can be selected)
    and then is this new code inserted in the method source code."
    | parseTree foundMatch rewriter selectedCode |

    selectedCode := aCodeSelection selectedSourceCode.
    parseTree := self parse: selectedCode codeSelection: aCodeSelection.

    rewriter := rewritterClass new
        oldSource: aCodeSelection selectedSourceCode;  
        replace: searchPattern with: rewritePattern;
        yourself.

    foundMatch := rewriter executeTree: parseTree.

    foundMatch ifTrue: [
        | change newSource newParseTree |

        newSource := rewriter tree newSource.
        newParseTree := self parse: newSource codeSelection: aCodeSelection.
        newSource := formatter formatParseTree: newParseTree.

        aCodeSelection selectedInterval notNil ifTrue: [
            rewriter := rewritterClass new.
            foundMatch := rewriter
                replace: selectedCode with: newSource when: [ :aNode | 
                    aNode intersectsInterval: aCodeSelection selectedInterval 
                ];
                executeTree: (self parseMethod: aCodeSelection currentSourceCode).

            newSource := rewriter newSource.
        ].

        (foundMatch and: [ newSource notNil ]) ifTrue: [   
            change := model
                compile: newSource
                in: aCodeSelection selectedMethod mclass 
                classified: aCodeSelection selectedMethod category.

            change package: aCodeSelection selectedMethod package
        ]
    ].

    "Created: / 24-08-2014 / 10:24:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-02-2015 / 21:57:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

initializeChange: aChangeClass
    "Returns new initialized instance of a code change like AddClassChange"

    ^ aChangeClass new
        model: self model;
        yourself

    "Created: / 08-11-2014 / 16:10:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

replace: searchPattern with: rewritePattern inContext: aCustomContext
    "Searches for given pattern in methods source code or selected code fragments
    and if source code matches then executes replacement"

    self 
        search: searchPattern 
        inContext: aCustomContext 
        withResultDo: [ :sourceSelection |
            self executeReplace: searchPattern with: rewritePattern inCodeSelection: sourceSelection 
        ]

    "Created: / 16-08-2014 / 19:15:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 22:14:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder methodsFor:'searching - instance creation'!

classCategorySearcher

    ^ self initializeSearcher: ClassCategorySearcher

    "Created: / 04-11-2014 / 18:47:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

classSearcher

    ^ self initializeSearcher: ClassSearcher

    "Created: / 04-11-2014 / 21:43:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

codeSelectionSearcher

    ^ self initializeSearcher: CodeSelectionSearcher

    "Created: / 04-11-2014 / 22:36:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

initializeSearcher: searcherClass
    "Returns new searcher with prepared instance variables."

    ^ searcherClass new
        model: model;
        yourself

    "Created: / 03-11-2014 / 09:45:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

methodSearcher

    ^ self initializeSearcher: MethodSearcher

    "Created: / 04-11-2014 / 22:32:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

packageSearcher

    ^ self initializeSearcher: PackageSearcher

    "Created: / 01-11-2014 / 19:52:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 03-11-2014 / 09:46:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

protocolSearcher

    ^ self initializeSearcher: ProtocolSearcher

    "Created: / 01-11-2014 / 15:56:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 03-11-2014 / 09:46:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder methodsFor:'searching - methods'!

search: searchPattern inContext: aCustomContext withResultDo: aBlock
    "Searches for source code pattern in whole context which contains code, methods, classes...
    and when context is from browser then restrict search within its perspective (CustomPerspective)."
    | perspective |

    perspective := aCustomContext perspective.

    self class privateClassesDo: [ :class |
        (class includesSelector: #search:inContext:withResultDo:) ifTrue: [ 
            (perspective isNil or: [ class availableInPerspective: perspective ]) ifTrue: [ 
                | searcher |

                searcher := self initializeSearcher: class.
                searcher search: searchPattern inContext: aCustomContext withResultDo: aBlock    
            ]
        ]
    ]

    "Created: / 17-08-2014 / 16:21:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 05-11-2014 / 20:33:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 24-12-2014 / 22:41:52 / root"
! !

!CustomRefactoryBuilder::ClassCategorySearcher class methodsFor:'queries'!

availableInPerspective:aCustomPerspective
    "see CustomRefactoryBuilder::ProtocolSearcher >> availableInPerspective:"

    ^ aCustomPerspective isClassCategoryPerspective

    "Created: / 04-11-2014 / 18:44:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::ClassCategorySearcher methodsFor:'searching - methods'!

search: searchPattern inContext: aCustomContext withResultDo: aBlock
    "Iterates through all classes to find out which belongs to given categories and
    executes search on those classes for methods matching given searchPattern."
    | categories classSearcher |

    categories := aCustomContext selectedClassCategories.
    categories isEmptyOrNil ifTrue: [
        "Skip search when none categories are selected.
        The algorithm would iterate through all classes so this is an optimization."
        ^ self
    ].

    classSearcher := self classSearcher.

    model allClassesDo: [ :class |
        "Including only non metaclasses, because search in class
        searches both class and metaclass."
        (class isMeta not and: [categories includes: class category]) ifTrue: [ 
            classSearcher search: searchPattern inClass: class withResultDo: aBlock 
        ]
    ]

    "Created: / 04-11-2014 / 18:42:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 20:55:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::ClassSearcher class methodsFor:'queries'!

availableInPerspective:aCustomPerspective
    "see CustomRefactoryBuilder::ProtocolSearcher >> availableInPerspective:"

    ^ aCustomPerspective isClassPerspective

    "Created: / 04-11-2014 / 21:39:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::ClassSearcher methodsFor:'searching - methods'!

search: searchPattern inClass: aClass withResultDo: aBlock
    "Searches through all methods from given class and metaclass."
    | methodSearcher |

    methodSearcher := self methodSearcher.

    aClass instAndClassMethodsDo: [ :method |
        methodSearcher search: searchPattern inMethod: method withResultDo: aBlock
    ]

    "Created: / 17-08-2014 / 13:15:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 20:57:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

search: searchPattern inContext: aCustomContext withResultDo: aBlock
    "Executes search on each class in selected class collection.
    see search:inClass:withResultDo:"

    aCustomContext selectedClasses ? #() do:[ :class | 
        self search: searchPattern inClass: class withResultDo: aBlock
    ].

    "Created: / 04-11-2014 / 21:45:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::CodeSelectionSearcher class methodsFor:'queries'!

availableInPerspective:aCustomPerspective
    "see CustomRefactoryBuilder::ProtocolSearcher >> availableInPerspective:"

    ^ aCustomPerspective isCodeViewPerspective

    "Created: / 04-11-2014 / 22:28:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::CodeSelectionSearcher methodsFor:'searching - methods'!

search: searchPattern inContext: aCustomContext withResultDo: aBlock
    "Searches for each selected code fragment (see CustomSourceCodeSelection)
    which matches given search pattern.
    If match is found then code selection is passed in a block."

    aCustomContext selectedCodes ? #() do:[ :codeSelection | 
        | parseTree selectedCode |

        selectedCode := codeSelection selectedSourceCode.
        selectedCode notEmptyOrNil ifTrue: [   
            parseTree := self parseExpression: selectedCode.

            (self searcher)
                matches: searchPattern do: [ :aNode :answer |
                    aBlock value: codeSelection  
                ];
                executeTree: parseTree
        ]
    ].

    "Created: / 04-11-2014 / 22:26:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 16:15:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::MethodSearcher class methodsFor:'queries'!

availableInPerspective:aCustomPerspective
    "see CustomRefactoryBuilder::ProtocolSearcher >> availableInPerspective:"

    ^ aCustomPerspective isMethodPerspective

    "Created: / 04-11-2014 / 22:29:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::MethodSearcher methodsFor:'searching - methods'!

search: searchPattern inContext: aCustomContext withResultDo: aBlock
    "Searches all selected methods and executes given block when match is found."

    aCustomContext selectedMethods ? #() do: [ :method | 
        self search: searchPattern inMethod: method withResultDo: aBlock
    ].

    "Created: / 04-11-2014 / 22:24:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

search: searchPattern inMethod: aMethod withResultDo: aBlock
    | parseTree |

    parseTree := aMethod parseTree.    

    parseTree isNil ifTrue: [ 
        self error: 'Cannot retrieve parseTree for method: ', aMethod asString.
    ]
    ifFalse: [
        (self searcher)
            matches: searchPattern do: [ :aNode :answer |
                | selectedCodeResult |

                selectedCodeResult := CustomSourceCodeSelection new
                    selectedMethod: aMethod;  
                    yourself.

                aBlock value: selectedCodeResult  
            ];
            executeTree: parseTree
    ].

    "Created: / 16-08-2014 / 22:27:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 28-10-2014 / 09:45:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::PackageSearcher class methodsFor:'queries'!

availableInPerspective:aCustomPerspective
    "see CustomRefactoryBuilder::ProtocolSearcher >> availableInPerspective:"

    ^ aCustomPerspective isPackagePerspective

    "Created: / 01-11-2014 / 16:46:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::PackageSearcher methodsFor:'searching - methods'!

search: searchPattern inContext: aCustomContext withResultDo: aBlock
    "Executes search on each method which belongs to selected packages.
    see search:inMethod:withResultDo:"
    | packages methodSearcher |

    packages := aCustomContext selectedPackages.
    packages isEmptyOrNil ifTrue: [
        "Skip search when none packages are selected.
        The algorithm would iterate through all classes so this is an optimization."
        ^ self
    ].

    methodSearcher := self methodSearcher.

    model allClassesDo: [ :class |
        "Including only non metaclasses, because we use instAndClassMethodsDo:
        and allClassesDo: have different implementations."
        class isMeta ifFalse: [
            class instAndClassMethodsDo: [ :method |
                (packages includes: method package) ifTrue: [ 
                    methodSearcher search: searchPattern inMethod: method withResultDo: aBlock 
                ]
            ]
        ]
    ]

    "Created: / 01-11-2014 / 17:28:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 20:59:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::ProtocolSearcher class methodsFor:'queries'!

availableInPerspective:aCustomPerspective
    "Returns true when perspective is desired type.
    We need to limit the searching with respect to perspective,
    because we need to search for example only in classes when we are in the class perspective
    (the list of classes in the IDE - Tools::NewSystemBrowser)."

    ^ aCustomPerspective isProtocolPerspective

    "Created: / 29-10-2014 / 22:51:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder::ProtocolSearcher methodsFor:'searching - methods'!

search: searchPattern inContext: aCustomContext withResultDo: aBlock
    "Executes search on each method in selected protocols within selected classes.
    see search:inMethod:withResultDo:"
    | methodSearcher |

    methodSearcher := self methodSearcher.

    aCustomContext selectedClasses ? #() do:[ :class |
        aCustomContext selectedProtocols ? #() do:[ :protocol |
            class methodsDo:[ :method |
                (protocol = (method category)) ifTrue:[
                    methodSearcher search: searchPattern inMethod: method withResultDo: aBlock
                ]
            ]
        ]
    ]

    "Created: / 29-10-2014 / 19:16:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 20:59:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilder class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

