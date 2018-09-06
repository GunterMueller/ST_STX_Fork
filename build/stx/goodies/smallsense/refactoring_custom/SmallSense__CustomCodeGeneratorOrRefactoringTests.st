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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomCodeGeneratorOrRefactoringTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomCodeGeneratorOrRefactoringTests class methodsFor:'documentation'!

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
! !

!CustomCodeGeneratorOrRefactoringTests methodsFor:'accessing'!

generatorOrRefactoring
    | generatorMock |

    generatorMock := mock mockOf: CustomCodeGeneratorOrRefactoring.
    generatorMock class compileMockMethod: 'description ^ ''''. '.
    ^ generatorMock

    "Created: / 10-11-2014 / 22:04:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 24-11-2014 / 23:46:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTests methodsFor:'tests'!

test_all_my_non_abstract_implementors_have_filled_label_and_description

    CustomCodeGeneratorOrRefactoring allSubclassesDo:[ :subclass |
        "Include only non abstract and non mock classes"
        (subclass isAbstract or: [ (subclass includesSelector: #compileMockMethod:) ]) ifFalse:[
            self assert: subclass label notEmptyOrNil.
            self assert: subclass description notEmptyOrNil
        ]
    ]

    "Created: / 18-10-2014 / 13:38:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:02:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages
    | expectedLanguages actualLanguages |

    expectedLanguages := {SmalltalkLanguage instance}.
    actualLanguages := generatorOrRefactoring class availableForProgrammingLanguages.    
    
    self assert: expectedLanguages = actualLanguages

    "Modified: / 22-12-2014 / 13:38:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_class_perspective

    context
        perspective: CustomPerspective classPerspective;
        selectedClasses: (Array with: self class).

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 13:43:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_class_perspective_empty

    context perspective: CustomPerspective classPerspective.

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 13:40:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_class_perspective_empty_class

    context
        perspective: CustomPerspective classPerspective;
        selectedClasses: (Array with: nil).

    self deny: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 24-01-2015 / 18:27:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_class_perspective_java
    | class |

    "Prepare model class otherwise we would need real existing java class to test functionality"
    class := RBClass new
        realClass: JavaClass new;
        yourself.

    context
        perspective: CustomPerspective classPerspective;
        selectedClasses: (Array with: class).

    self deny: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 13:44:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_class_perspective_java_and_smalltalk
    | class |

    "Prepare model class otherwise we would need real existing java class to test functionality"
    class := RBClass new
        realClass: JavaClass new;
        yourself.

    context
        perspective: CustomPerspective classPerspective;
        selectedClasses: (Array with: class with: self class).

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 13:53:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_code_view_perspective

    context
        perspective: CustomPerspective codeViewPerspective;
        selectedCodes: (Array with:
            (CustomSourceCodeSelection new
                selectedMethod: (self class compiledMethodAt: #generatorOrRefactoring);
                yourself)).

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 12:08:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_code_view_perspective_empty_method

    context
        perspective: CustomPerspective codeViewPerspective;
        selectedCodes: (Array with: CustomSourceCodeSelection new).

    self deny: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 12:14:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_method_perspective

    context
        perspective: CustomPerspective methodPerspective;
        selectedMethods: (Array with: (self class compiledMethodAt: #generatorOrRefactoring)).

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 12:37:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_method_perspective_and_empty_method

    context
        perspective: CustomPerspective methodPerspective;
        selectedMethods: (Array with: nil).

    self deny: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 24-01-2015 / 18:29:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_method_perspective_empty

    context perspective: CustomPerspective methodPerspective.

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 12:38:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_filled_with_protocol_perspective_empty

    context perspective: CustomPerspective protocolPerspective.

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 13:41:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_with_class_category_perspective

    context perspective: CustomPerspective classCategoryPerspective.

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 13:42:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_with_code_view_perspective

    context perspective: CustomPerspective codeViewPerspective.

    self deny: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 26-12-2014 / 23:09:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 27-12-2014 / 12:04:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_context_with_package_perspective

    context perspective: CustomPerspective packagePerspective.

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Created: / 27-12-2014 / 13:42:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_programming_languages_in_sub_context

    self assert: (generatorOrRefactoring class availableForProgrammingLanguagesInContext: context)

    "Modified: / 26-12-2014 / 23:05:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_for_class_in_category_skip_if_same_change_reflected_in_model
    | expectedSource class realClass |

    class := model createClass
        name: #DummyClass01;
        compile;
        yourself.

    expectedSource := 'selector01 ^ 456'.

    generatorOrRefactoring compile: expectedSource 
        forClass: class 
        inCategory: nil
        skipIfSame: true.    
    
    self assertMethodSource: expectedSource atSelector: #selector01 forClass: class.
    self assertClassNotExists: #DummyClass01.  

    generatorOrRefactoring compileMockMethod: 'buildInContext:context'; 
        executeInContext: context.

    realClass := Smalltalk at: #DummyClass01.

    self assertMethodSource: expectedSource atSelector: #selector01 forClass: realClass.

    "Modified: / 08-02-2015 / 19:49:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_for_class_in_category_skip_if_same_not_skipped
    | expectedChangeSize actualChangeSize class |

    class := model createClass
        name: #DummyClass01;
        compile;
        yourself.

    class compile: 'selector01 ^ 456'.  

    generatorOrRefactoring compile: 'selector01 ^ 4567' 
        forClass: class 
        inCategory: nil
        skipIfSame: true.    

    expectedChangeSize := 3.
    actualChangeSize := model changes changesSize.

    self assert: expectedChangeSize = actualChangeSize

    "Created: / 08-02-2015 / 20:03:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_for_class_in_category_skip_if_same_real_class
    | expectedSource class |

    class := model createClassImmediate: #DummyClass01.

    expectedSource := 'selector01 ^ 456'.

    generatorOrRefactoring compile: expectedSource 
        forClass: class 
        inCategory: nil
        skipIfSame: true.    
    
    self assertMethodSource: expectedSource atSelector: #selector01 forClass: class.
    self assertClassExists: #DummyClass01.

    "Created: / 08-02-2015 / 19:51:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_compile_for_class_in_category_skip_if_same_skipped
    | expectedChangeSize actualChangeSize class source |

    class := model createClass
        name: #DummyClass01;
        compile;
        yourself.

    source := 'selector01 ^ 456'.
    class compile: source.  

    generatorOrRefactoring compile: source 
        forClass: class 
        inCategory: nil
        skipIfSame: true.    

    expectedChangeSize := 2.
    actualChangeSize := model changes changesSize.

    self assert: expectedChangeSize = actualChangeSize

    "Created: / 08-02-2015 / 19:59:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_in_context_aborted
    | dialogBox |

    dialogBox := mock mockOf: DialogBox.
    dialogBox
        compileMockMethod: 'open ^ nil';
        compileMockMethod: 'accepted ^ false'.

    dialog := (mock mockOf: CustomUserDialog)
        compileMockMethod: 'information:arg ^ nil';        
        dialog: dialogBox;
        yourself.  

    context := CustomBrowserContext new.
    generatorOrRefactoring
        dialog: dialog;  
        compileMockMethod: 'buildInContext:aContext ^ dialog open'.

    self should: [ 
        generatorOrRefactoring executeInContext: context.
    ] raise: AbortOperationRequest.

    "/ self assert: generatorOrRefactoring == (generatorOrRefactoring executeInContext: context).

    "Modified: / 25-11-2014 / 21:32:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_in_context_not_aborted
    | dialogBox |

    dialogBox := mock mockOf: DialogBox.
    dialogBox
        compileMockMethod: 'open ^ nil';
        compileMockMethod: 'accepted ^ true'.

    dialog := (mock mockOf: CustomUserDialog)
        compileMockMethod: 'information:arg ^ nil';        
        dialog: dialogBox;
        yourself.  

    context := CustomBrowserContext new.
    generatorOrRefactoring
        dialog: dialog;  
        compileMockMethod: 'buildInContext:aContext ^ dialog open'.

    self shouldnt: [ 
        generatorOrRefactoring executeInContext: context.
    ] raise: AbortOperationRequest.

    "/ self assert: generatorOrRefactoring == (generatorOrRefactoring executeInContext: context).

    "Created: / 10-11-2014 / 23:35:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 21:33:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_in_context_shared_change_collector_with_correct_change_order
    "We need to check whether each part of generator/refactoring
    API writes to the same change collector. If we dont preserve correct
    change order then wrong result may be produced."
    | class expectedSource |

    generatorOrRefactoring compileMockMethod: 'buildInContext: aContext
    | class context |

    class := model createClass
        name: #DummyClass01;
        category: ''Some-Category-01'';
        compile;
        yourself.

    self compile:''selector_01 ^ 1'' forClass:class inCategory:''protocol01''.
    class removeMethod:#selector_01.
    class compile:''selector_02 ^ ''''literal02''''. ''.

    context := CustomSubContext new selectedClasses: (Array with: class); yourself.
    refactoryBuilder replace:''`#literal'' with:''''''literal525'''''' inContext:context.
    refactoryBuilder changeCategoryOf:class to:''Some-Category-02''.
    '.

    generatorOrRefactoring executeInContext: context.

    class := Smalltalk at: #DummyClass01.

    self assert: (class category) = #'Some-Category-02'.
    self assert: (class sourceCodeAt: #selector_01) isNil.

    expectedSource := 'selector_02
    ^ ''literal525''.'.

    self assertMethodSource: expectedSource atSelector: #selector_02 forClass: class.

    "Created: / 04-12-2014 / 23:24:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_in_context_with_real_class_and_compile_on_model_class
    | class modelClass |

    generatorOrRefactoring compileMockMethod: 'buildInContext: aContext
    aContext selectedClasses do: [ :class |
        class compile: ''selector_01 ^ 1''.
    ]'.

    class := model createClassImmediate: #DummyClass01.
    self assert: class isBehavior.  

    context selectedClasses: (Array with: class).

    generatorOrRefactoring executeInContext: context.

    modelClass := generatorOrRefactoring model classNamed: #DummyClass01.

    self assert: (class includesSelector: #selector_01).
    self assert: (modelClass includesSelector: #selector_01)

    "Created: / 24-11-2014 / 23:43:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-11-2014 / 20:41:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_do
    | expectedGenerators actualGenerators |

    expectedGenerators := CustomCodeGeneratorOrRefactoring allSubclasses.
    actualGenerators := OrderedCollection streamContents: [ :stream |
        CustomCodeGeneratorOrRefactoring generatorsAndRefactoringsDo: [ :class |
            stream nextPut: class  
        ].
    ].
    
    self assert: expectedGenerators = actualGenerators

    "Modified: / 24-01-2015 / 18:26:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeGeneratorOrRefactoringTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

