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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomSimpleSetterMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomSimpleSetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomSimpleSetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomSimpleSetterMethodsCodeGenerator new
! !

!CustomSimpleSetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_simple_setter_method_generated_with_comments
    | expectedSource |

    userPreferences generateCommentsForSetters: true.

    expectedSource := 'instanceVariable:something
    "set the value of the instance variable ''instanceVariable'' (automatically generated)"

    instanceVariable := something'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable:

    "Created: / 05-07-2014 / 13:29:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-07-2014 / 19:38:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_simple_setter_method_generated_without_comments
    "test setter method"

    | expectedSource |

    userPreferences generateCommentsForSetters: false.

    expectedSource := 'instanceVariable:something
    instanceVariable := something'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable:

    "Created: / 05-07-2014 / 13:38:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-07-2014 / 19:38:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSimpleSetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

