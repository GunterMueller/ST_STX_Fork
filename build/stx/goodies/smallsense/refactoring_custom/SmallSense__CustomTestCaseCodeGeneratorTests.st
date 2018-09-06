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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomTestCaseCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomTestCaseCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomTestCaseCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^CustomTestCaseCodeGenerator new
! !

!CustomTestCaseCodeGeneratorTests methodsFor:'tests'!

test_available_in_context_classes_all_test_case_subclass

    context selectedClasses: {self class}.  
    
    self deny: (generatorOrRefactoring class availableInContext: context)

    "Created: / 31-01-2015 / 22:05:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_classes_none_test_case_subclass

    context selectedClasses: {Object}.  
    
    self assert: (generatorOrRefactoring class availableInContext: context)

    "Created: / 31-01-2015 / 22:03:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_classes_one_test_case_subclass

    context selectedClasses: {Object. self class}.  
    
    self deny: (generatorOrRefactoring class availableInContext: context)

    "Created: / 31-01-2015 / 22:04:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_empty_classes

    context selectedClasses: #().  
    
    self assert: (generatorOrRefactoring class availableInContext: context)

    "Modified: / 31-01-2015 / 22:01:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_unknown_classes

    context selectedClasses: nil.  
    
    self assert: (generatorOrRefactoring class availableInContext: context)

    "Created: / 31-01-2015 / 22:01:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective
    
    self assert: (generatorOrRefactoring class availableInPerspective: CustomPerspective classPerspective)

    "Modified: / 31-01-2015 / 22:07:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_test_class_generated_all_checked
    | class testClass setUpSource tearDownSource |

    class := self classWithInstanceVariable
        category: 'Some-Category';
        package: #some_package_01;
        yourself.

    self assertClassNotExists: class name.

    context selectedClasses: {class}.

    generatorOrRefactoring
        configureInContext: context;
        samePackageAsTestedClass: true;
        generateSetUp: true;
        generateTearDown: true;
        testClassCategory: 'Some-Tests';
        testClassName: #DummyClassTests;
        testSuperName: #TestCase;
        executeInContext: context.

    testClass := Smalltalk at: #DummyClassTests.

    self assert: (testClass package) = #some_package_01.
    self assert: (testClass superclass name) = #TestCase.
    self assert: (testClass category) = 'Some-Tests'.

    setUpSource := 'setUp
    super setUp.

    "Add your own code here..."'.
    self assertMethodSource: setUpSource atSelector: #setUp forClass: testClass. 

    tearDownSource := 'tearDown
    "Add your own code here..."

    super tearDown.'
.
    self assertMethodSource: tearDownSource atSelector: #tearDown forClass: testClass

    "Created: / 31-01-2015 / 23:02:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_test_class_generated_for_metaclass
    | class |

    class := self classWithInstanceVariable
        category: 'Some-Category';
        yourself.

    self assertClassNotExists: class name.

    context selectedClasses: (Array with: class theMetaclass ).
    generatorOrRefactoring
        configureInContext: context;
        executeInContext: context.

    self assertClassExists: class name

    "Created: / 14-10-2014 / 10:42:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 22:37:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_test_class_generated_with_package
    | class testClass |

    class := self classWithInstanceVariable
        category: 'Some-Category';
        package: #some_package_01;
        yourself.

    self assertClassNotExists: class name.

    context selectedClasses: (Array with: class theMetaclass ).

    generatorOrRefactoring
        configureInContext: context;
        executeInContext: context.

    self assert: generatorOrRefactoring samePackageAsTestedClass.  

    testClass := Smalltalk at: generatorOrRefactoring testClassName asSymbol.

    self assertClassExists: class name.
    self assert: (testClass package) = #some_package_01.

    "Created: / 15-11-2014 / 15:21:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_test_class_generated_without_package
    | class testClass |

    class := self classWithInstanceVariable
        category: 'Some-Category';
        package: #some_package_01;
        yourself.

    self assertClassNotExists: class name.

    context selectedClasses: (Array with: class theMetaclass ).

    generatorOrRefactoring
        configureInContext: context;
        samePackageAsTestedClass: false;
        executeInContext: context.

    testClass := Smalltalk at: generatorOrRefactoring testClassName asSymbol.

    self assertClassExists: class name.
    self deny: (testClass package) = #some_package_01.

    "Created: / 15-11-2014 / 15:37:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomTestCaseCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

