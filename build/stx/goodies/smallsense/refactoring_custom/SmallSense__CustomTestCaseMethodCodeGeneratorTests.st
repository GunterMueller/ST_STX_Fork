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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomTestCaseMethodCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomTestCaseMethodCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomTestCaseMethodCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomTestCaseMethodCodeGenerator new
! !

!CustomTestCaseMethodCodeGeneratorTests methodsFor:'tests'!

test_generate_test_method_for_class
    | expectedSource method class testClass |

    class := model createClassImmediate: #MockClassForTestCase01 superClassName: #Object.
    testClass := model createClassImmediate: #MockClassForTestCase01Tests.
    method := model createMethodImmediate: class source: 'selector_01 ^ 1'.

    context selectedMethods: (Array with: method).  

    expectedSource := 'test_selector_01
    "/ something selector_01.    

    self assert:1 = 2.'.

    generatorOrRefactoring executeInContext: context.  

    self assertMethodSource:expectedSource atSelector:#test_selector_01 forClass:testClass

    "Created: / 29-11-2014 / 15:04:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generate_test_method_for_private_class
    | expectedSource privateClass method testClass |

    model createClassImmediate: #MockClassForTestCase01 superClassName: #Object.
    privateClass := model createClassImmediate: #PrivateClass01 superClassName: #MockClassForTestCase01 privateIn: #MockClassForTestCase01.
    testClass := model createClassImmediate: #MockClassForTestCase01Tests.
    method := model createMethodImmediate: privateClass source: 'selector_01 ^ 1'.

    context selectedMethods: (Array with: method).  

    expectedSource := 'test_selector_01
    "/ something selector_01.    

    self assert:1 = 2.'.

    generatorOrRefactoring executeInContext: context.  

    self assertMethodSource:expectedSource atSelector:#test_selector_01 forClass:testClass

    "Created: / 31-10-2014 / 00:30:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:54:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

