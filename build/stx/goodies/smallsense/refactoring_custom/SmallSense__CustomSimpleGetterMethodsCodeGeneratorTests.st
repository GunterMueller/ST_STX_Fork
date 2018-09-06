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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomSimpleGetterMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomSimpleGetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomSimpleGetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomSimpleGetterMethodsCodeGenerator new

    "Modified: / 29-05-2014 / 00:07:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSimpleGetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_simple_getter_method_generated_with_comments
    | expectedSource |

    userPreferences generateCommentsForGetters: true.

    expectedSource := 'instanceVariable
    "return the instance variable ''instanceVariable'' (automatically generated)"

    ^ instanceVariable'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable

    "Created: / 31-05-2014 / 20:06:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-06-2014 / 10:41:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_simple_getter_method_generated_without_comments
    | expectedSource |

    userPreferences generateCommentsForGetters: false.

    expectedSource := 'instanceVariable
    ^ instanceVariable'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable

    "Created: / 31-05-2014 / 20:05:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-06-2014 / 10:41:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSimpleGetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

