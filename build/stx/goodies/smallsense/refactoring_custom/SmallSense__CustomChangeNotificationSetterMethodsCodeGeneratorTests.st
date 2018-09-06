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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomChangeNotificationSetterMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomChangeNotificationSetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomChangeNotificationSetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomChangeNotificationSetterMethodsCodeGenerator new
! !

!CustomChangeNotificationSetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_change_notification_setter_method_generated_with_comments
    | expectedSource |

    userPreferences generateCommentsForSetters: true.

    expectedSource := 'instanceVariable:something 
    "set the value of the instance variable ''instanceVariable'' and send a change notification (automatically generated)"

    (instanceVariable ~~ something) ifTrue:[
        instanceVariable := something.
        self changed:#instanceVariable.
    ].'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable:

    "Created: / 06-07-2014 / 13:55:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_notification_setter_method_generated_without_comments
    | expectedSource |

    userPreferences generateCommentsForSetters: false.

    expectedSource := 'instanceVariable:something 
    (instanceVariable ~~ something) ifTrue:[
        instanceVariable := something.
        self changed:#instanceVariable.
    ].'.

    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedSource atSelector: #instanceVariable:

    "Created: / 06-07-2014 / 14:05:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_instance_variable_present
    | expectedVariables actualVariables |

    self executeGeneratorInContext: #classWithInstanceVariable.

    expectedVariables := #('instanceVariable').
    actualVariables := (Smalltalk at: #DummyClassForGeneratorTestCase) instanceVariableNames.

    self assert: expectedVariables = actualVariables

    "Created: / 30-11-2014 / 19:16:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

