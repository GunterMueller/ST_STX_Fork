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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomValueHolderWithChangeNotificationAccessMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomValueHolderWithChangeNotificationAccessMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomValueHolderWithChangeNotificationAccessMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomValueHolderWithChangeNotificationAccessMethodsCodeGenerator new
! !

!CustomValueHolderWithChangeNotificationAccessMethodsCodeGeneratorTests methodsFor:'tests'!

test_value_holder_access_methods_generated_with_comments
    | expectedGetterSource expectedSetterSource |

    userPreferences
        generateCommentsForGetters: true;
        generateCommentsForSetters: true.

    expectedGetterSource := 'instanceVariable
    "return/create the ''instanceVariable'' value holder with change notification (automatically generated)"

    instanceVariable isNil ifTrue:[
        instanceVariable := ValueHolder new.
        instanceVariable addDependent:self.
    ].
    ^ instanceVariable'. 

    expectedSetterSource := 'instanceVariable:something
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
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertMethodSource: expectedSetterSource atSelector: #instanceVariable:

    "Created: / 13-07-2014 / 17:16:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_value_holder_access_methods_generated_without_comments
    | expectedGetterSource expectedSetterSource |

    userPreferences
        generateCommentsForGetters: false;
        generateCommentsForSetters: false.

    expectedGetterSource := 'instanceVariable
    instanceVariable isNil ifTrue:[
        instanceVariable := ValueHolder new.
        instanceVariable addDependent:self.
    ].
    ^ instanceVariable'. 

    expectedSetterSource := 'instanceVariable:something
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
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertMethodSource: expectedSetterSource atSelector: #instanceVariable:

    "Created: / 13-07-2014 / 17:23:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomValueHolderWithChangeNotificationAccessMethodsCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

