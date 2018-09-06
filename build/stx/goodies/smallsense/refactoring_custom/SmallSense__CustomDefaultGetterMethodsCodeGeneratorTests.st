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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomDefaultGetterMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomDefaultGetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomDefaultGetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomDefaultGetterMethodsCodeGenerator new
! !

!CustomDefaultGetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_default_getter_method_generated_with_comments
    | expectedSource |

    userPreferences generateCommentsForGetters: true.

    expectedSource := 'defaultInstanceVariable
    "default value for the ''instanceVariable'' instance variable (automatically generated)"

    self shouldImplement.
    ^ nil'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertClassMethodSource: expectedSource atSelector: #defaultInstanceVariable

    "Created: / 30-06-2014 / 13:31:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-07-2014 / 20:11:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_default_getter_method_generated_without_comments
    | expectedSource |

    userPreferences generateCommentsForGetters: false.

    expectedSource := 'defaultInstanceVariable
    self shouldImplement.
    ^ nil'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertClassMethodSource: expectedSource atSelector: #defaultInstanceVariable

    "Created: / 30-06-2014 / 11:31:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-07-2014 / 20:11:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

