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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomValueHolderWithChangeNotificationSetterMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomValueHolderWithChangeNotificationSetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomValueHolderWithChangeNotificationSetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomValueHolderWithChangeNotificationSetterMethodsCodeGenerator new
! !

!CustomValueHolderWithChangeNotificationSetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_value_holder_with_change_notification_setter_method_generated_with_comments
    | expectedSource |

    userPreferences generateCommentsForSetters: true.

    expectedSource := 'instanceVariable:something
    "set the ''instanceVariable'' value holder (automatically generated)"

    |oldValue newValue|

    instanceVariable notNil ifTrue:[
        oldValue := instanceVariable value.
        instanceVariable removeDependent:self.
    ].
    instanceVariable := something.
    instanceVariable notNil ifTrue:[
        instanceVariable addDependent:self.
    ].
    newValue := instanceVariable value.
    oldValue ~~ newValue ifTrue:[
        self
            update:#value
            with:newValue
            from:instanceVariable.
    ].'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable:

    "Created: / 07-07-2014 / 00:24:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_value_holder_with_change_notification_setter_method_generated_without_comments
    | expectedSource |

    userPreferences generateCommentsForSetters: false.

    expectedSource := 'instanceVariable:something
    |oldValue newValue|

    instanceVariable notNil ifTrue:[
        oldValue := instanceVariable value.
        instanceVariable removeDependent:self.
    ].
    instanceVariable := something.
    instanceVariable notNil ifTrue:[
        instanceVariable addDependent:self.
    ].
    newValue := instanceVariable value.
    oldValue ~~ newValue ifTrue:[
        self
            update:#value
            with:newValue
            from:instanceVariable.
    ].'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable:

    "Created: / 07-07-2014 / 00:23:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomValueHolderWithChangeNotificationSetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

