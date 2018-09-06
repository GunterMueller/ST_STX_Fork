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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomMultiSetterMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomMultiSetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomMultiSetterMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomMultiSetterMethodsCodeGenerator new
! !

!CustomMultiSetterMethodsCodeGeneratorTests methodsFor:'tests'!

test_available_in_context_for_none_variable_names

    context
        selectedClasses: (Array with: self class).

    self assert: (generatorOrRefactoring class availableInContext: context) not.

    "Created: / 13-07-2014 / 20:11:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_for_one_variable_name

    context
        selectedClasses: (Array with: self class);
        selectedVariables: (Array with: 'var_01').

    self assert: (generatorOrRefactoring class availableInContext: context) not.

    "Created: / 13-07-2014 / 20:08:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_for_three_variable_names

    context
        selectedClasses: (Array with: self class);
        selectedVariables: (Array with: 'var_01' with: 'var_02' with: 'var_03').

    self assert: (generatorOrRefactoring class availableInContext: context).

    "Created: / 13-07-2014 / 20:10:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_for_two_variable_names

    context
        selectedClasses: (Array with: self class);
        selectedVariables: (Array with: 'var_01' with: 'var_02').

    self assert: (generatorOrRefactoring class availableInContext: context).

    "Created: / 13-07-2014 / 20:09:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_multi_setter_method_generated_with_comments_for_three_variables
    | expectedSource |

    userPreferences generateCommentsForSetters: true.

    expectedSource := 'instanceVariable_01:instanceVariable_01Arg instanceVariable_02:instanceVariable_02Arg instanceVariable_03:instanceVariable_03Arg
    "set instance variables"

    instanceVariable_01 := instanceVariable_01Arg.
    instanceVariable_02 := instanceVariable_02Arg.
    instanceVariable_03 := instanceVariable_03Arg.'.

    self executeGeneratorInContext: #classWithThreeInstanceVariables.
    self assertMethodSource: expectedSource atSelector: #instanceVariable_01:instanceVariable_02:instanceVariable_03:

    "Created: / 13-07-2014 / 21:55:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 22:37:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_multi_setter_method_generated_with_comments_for_two_variables
    | expectedSource |

    userPreferences generateCommentsForSetters: true.

    expectedSource := 'instanceVariable_01:instanceVariable_01Arg instanceVariable_02:instanceVariable_02Arg 
    "set instance variables"

    instanceVariable_01 := instanceVariable_01Arg.
    instanceVariable_02 := instanceVariable_02Arg.'.

    self executeGeneratorInContext: #classWithTwoInstanceVariables.
    self assertMethodSource: expectedSource atSelector: #instanceVariable_01:instanceVariable_02:

    "Created: / 13-07-2014 / 21:53:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 22:37:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_multi_setter_method_generated_without_comments_for_two_variables
    | expectedSource |

    userPreferences generateCommentsForSetters: false.

    expectedSource := 'instanceVariable_01:instanceVariable_01Arg instanceVariable_02:instanceVariable_02Arg 
    instanceVariable_01 := instanceVariable_01Arg.
    instanceVariable_02 := instanceVariable_02Arg.'.

    self executeGeneratorInContext: #classWithTwoInstanceVariables.
    self assertMethodSource: expectedSource atSelector: #instanceVariable_01:instanceVariable_02:

    "Created: / 13-07-2014 / 21:57:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 22:37:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMultiSetterMethodsCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

