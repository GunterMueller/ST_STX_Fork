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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomValueHolderWithChangeNotificationGetterMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomValueHolderWithChangeNotificationGetterMethodsCodeGenerator new
! !

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_value_holder_getter_with_change_notification_method_generated_with_comments
    | expectedSource |

    userPreferences generateCommentsForGetters: true.

    expectedSource := 'instanceVariable
    "return/create the ''instanceVariable'' value holder with change notification (automatically generated)"

    instanceVariable isNil ifTrue:[
        instanceVariable := ValueHolder new.
        instanceVariable addDependent:self.
    ].
    ^ instanceVariable'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable

    "Created: / 30-06-2014 / 19:54:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_value_holder_getter_with_change_notification_method_generated_without_comments
    | expectedSource |

    userPreferences generateCommentsForGetters: false.

    expectedSource := 'instanceVariable
    instanceVariable isNil ifTrue:[
        instanceVariable := ValueHolder new.
        instanceVariable addDependent:self.
    ].
    ^ instanceVariable'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable

    "Created: / 30-06-2014 / 19:56:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomValueHolderWithChangeNotificationGetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

