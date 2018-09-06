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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomUpdateTestCaseCategoryRefactoringTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Refactorings-Tests'
!

!CustomUpdateTestCaseCategoryRefactoringTests class methodsFor:'documentation'!

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

!CustomUpdateTestCaseCategoryRefactoringTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomUpdateTestCaseCategoryRefactoring new
! !

!CustomUpdateTestCaseCategoryRefactoringTests methodsFor:'tests'!

test_available_for_class_fake_test

    |class|

    class := model createClassImmediate: #Dummy01Tests.  

    self deny: (generatorOrRefactoring class availableForClass: class).

    "Created: / 08-11-2014 / 23:40:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_class_object
    
    self deny: (generatorOrRefactoring class availableForClass: Object).

    "Created: / 08-11-2014 / 23:40:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_for_class_test_case
    
    self assert: (generatorOrRefactoring class availableForClass: self class).

    "Modified: / 08-11-2014 / 23:39:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_empty
    
    self deny: (generatorOrRefactoring class availableInContext: context).

    "Modified: / 08-11-2014 / 23:42:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_with_test_class

    context selectedClasses: (Array with: Object with: self class).  

    self assert: (generatorOrRefactoring class availableInContext: context).

    "Created: / 08-11-2014 / 23:43:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_without_test_class

    context selectedClasses: (Array with: Object).  

    self deny: (generatorOrRefactoring class availableInContext: context).

    "Created: / 08-11-2014 / 23:44:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective
    
    self assert: (generatorOrRefactoring class availableInPerspective: CustomPerspective classPerspective).

    "Modified: / 08-11-2014 / 23:45:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_category_updated_model_classes
    | expectedCategory actualCategory testClass |

    model createClass
        name: #DummyClass01;
        category: #Category01;
        compile.

    testClass := model createClass
        name: #DummyClass01Tests;
        superclassName: #TestCase;
        category: #Category02;
        compile;
        yourself.  

    expectedCategory := #'Category01-Tests'.

    context selectedClasses: (Array with: testClass).  

    generatorOrRefactoring executeInContext: context.

    actualCategory := testClass category.

    self assert: expectedCategory = actualCategory

    "Created: / 08-11-2014 / 23:57:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:16:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_category_updated_model_classes_category_ok
    | expectedCategory actualCategory testClass |

    model createClass
        name: #DummyClass01;
        category: #Category01;
        compile.

    testClass := model createClass
        name: #DummyClass01Tests;
        superclassName: #TestCase;
        category: #'Category01-Tests';
        compile;
        yourself.  

    expectedCategory := #'Category01-Tests'.

    context selectedClasses: (Array with: testClass).  

    generatorOrRefactoring executeInContext: context.

    actualCategory := testClass category.

    self assert: expectedCategory = actualCategory

    "Created: / 08-11-2014 / 23:58:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:16:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_category_updated_model_classes_wrong_suffix
    | expectedCategory actualCategory testClass |

    model createClass
        name: #DummyClass01;
        category: #Category01;
        compile.

    testClass := model createClass
        name: #DummyClass01Tested;
        superclassName: #TestCase;
        category: #Category01;
        compile;
        yourself.  

    expectedCategory := #Category01.

    context selectedClasses: (Array with: testClass).  

    generatorOrRefactoring executeInContext: context.

    actualCategory := testClass category.

    self assert: expectedCategory = actualCategory

    "Created: / 09-11-2014 / 00:01:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:16:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_category_updated_real_classes
    | expectedCategory actualCategory testClass |

    model createClassImmediate: #DummyClass01 category: #Category01.
    testClass := model createClassImmediate: #DummyClass01Tests superClassName: #TestCase.
    testClass category: #Category02.  

    expectedCategory := #'Category01-Tests'.

    context selectedClasses: (Array with: testClass).  

    generatorOrRefactoring executeInContext: context.

    actualCategory := testClass category.

    self assert: expectedCategory = actualCategory

    "Created: / 08-11-2014 / 23:53:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:54:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

