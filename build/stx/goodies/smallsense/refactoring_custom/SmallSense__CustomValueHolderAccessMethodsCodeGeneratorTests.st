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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomValueHolderAccessMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomValueHolderAccessMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomValueHolderAccessMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomValueHolderAccessMethodsCodeGenerator new
! !

!CustomValueHolderAccessMethodsCodeGeneratorTests methodsFor:'tests'!

test_value_holder_access_methods_generated_with_comments
    | expectedGetterSource expectedSetterSource |

    userPreferences
        generateCommentsForGetters: true;
        generateCommentsForSetters: true.

    expectedGetterSource := 'instanceVariable
    "return/create the ''instanceVariable'' value holder (automatically generated)"

    instanceVariable isNil ifTrue:[
        instanceVariable := ValueHolder new.
    ].
    ^ instanceVariable'. 

    expectedSetterSource := 'instanceVariable:something
    "set the value of the instance variable ''instanceVariable'' (automatically generated)"

    instanceVariable := something'.


    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertMethodSource: expectedSetterSource atSelector: #instanceVariable:

    "Created: / 13-07-2014 / 17:02:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_value_holder_access_methods_generated_without_comments
    | expectedGetterSource expectedSetterSource |

    userPreferences
        generateCommentsForGetters: false;
        generateCommentsForSetters: false.

    expectedGetterSource := 'instanceVariable
    instanceVariable isNil ifTrue:[
        instanceVariable := ValueHolder new.
    ].
    ^ instanceVariable'. 

    expectedSetterSource := 'instanceVariable:something
    instanceVariable := something'.


    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertMethodSource: expectedSetterSource atSelector: #instanceVariable:

    "Created: / 13-07-2014 / 17:03:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

