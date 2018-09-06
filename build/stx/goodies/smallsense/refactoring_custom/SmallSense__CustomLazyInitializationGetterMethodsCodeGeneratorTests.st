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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomLazyInitializationGetterMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomLazyInitializationGetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomLazyInitializationGetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomLazyInitializationGetterMethodsCodeGenerator new
! !

!CustomLazyInitializationGetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_lazy_initialization_getter_method_generated_with_comments
    | expectedSource |

    userPreferences generateCommentsForGetters: true.

    expectedSource := 'instanceVariable
    "return the instance instance variable ''instanceVariable'' with lazy instance creation (automatically generated)"

    instanceVariable isNil ifTrue:[
        instanceVariable := self class defaultInstanceVariable.
    ].
    ^ instanceVariable'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable

    "Created: / 30-06-2014 / 18:03:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_lazy_initialization_getter_method_generated_with_default_method
    | expectedGetterSource expectedDefaultSource |

    userPreferences generateCommentsForGetters: false.

    expectedGetterSource := 'instanceVariable
    instanceVariable isNil ifTrue:[
        instanceVariable := self class defaultInstanceVariable.
    ].
    ^ instanceVariable'.

    expectedDefaultSource := 'defaultInstanceVariable
    self shouldImplement.
    ^ nil'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertClassMethodSource: expectedDefaultSource atSelector: #defaultInstanceVariable

    "Created: / 30-06-2014 / 18:06:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-07-2014 / 20:11:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_lazy_initialization_getter_method_generated_without_comments
    | expectedSource |

    userPreferences generateCommentsForGetters: false.

    expectedSource := 'instanceVariable
    instanceVariable isNil ifTrue:[
        instanceVariable := self class defaultInstanceVariable.
    ].
    ^ instanceVariable'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable

    "Created: / 30-06-2014 / 10:37:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

