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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomSimpleAccessMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomSimpleAccessMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomSimpleAccessMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomSimpleAccessMethodsCodeGenerator new
! !

!CustomSimpleAccessMethodsCodeGeneratorTests methodsFor:'tests'!

test_access_methods_generated_with_comments
    | expectedGetterSource expectedSetterSource |

    userPreferences
        generateCommentsForGetters: true;
        generateCommentsForSetters: true.

    expectedGetterSource := 'instanceVariable
    "return the instance variable ''instanceVariable'' (automatically generated)"

    ^ instanceVariable'.

    expectedSetterSource := 'instanceVariable:something
    "set the value of the instance variable ''instanceVariable'' (automatically generated)"

    instanceVariable := something'.


    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertMethodSource: expectedSetterSource atSelector: #instanceVariable:

    "Created: / 08-07-2014 / 13:28:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-07-2014 / 16:02:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_access_methods_generated_without_comments
    | expectedGetterSource expectedSetterSource |

    userPreferences
        generateCommentsForGetters: false;
        generateCommentsForSetters: false.

    expectedGetterSource := 'instanceVariable
    ^ instanceVariable'.

    expectedSetterSource := 'instanceVariable:something
    instanceVariable := something'.


    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertMethodSource: expectedSetterSource atSelector: #instanceVariable:

    "Created: / 08-07-2014 / 16:59:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

