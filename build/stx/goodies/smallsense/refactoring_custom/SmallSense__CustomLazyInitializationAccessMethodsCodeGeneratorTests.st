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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomLazyInitializationAccessMethodsCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomLazyInitializationAccessMethodsCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomLazyInitializationAccessMethodsCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomLazyInitializationAccessMethodsCodeGenerator new
! !

!CustomLazyInitializationAccessMethodsCodeGeneratorTests methodsFor:'tests'!

test_lazy_initialization_access_methods_generated_with_comments
    | expectedGetterSource expectedSetterSource expectedDefaultSource |

    userPreferences
        generateCommentsForGetters: true;
        generateCommentsForSetters: true.

    expectedGetterSource := 'instanceVariable
    "return the instance instance variable ''instanceVariable'' with lazy instance creation (automatically generated)"

    instanceVariable isNil ifTrue:[
        instanceVariable := self class defaultInstanceVariable.
    ].
    ^ instanceVariable'.

    expectedSetterSource := 'instanceVariable:something 
    "set the value of the instance variable ''instanceVariable'' and send a change notification (automatically generated)"

    (instanceVariable ~~ something) ifTrue:[
        instanceVariable := something.
        self changed:#instanceVariable.
    ].'.

    expectedDefaultSource := 'defaultInstanceVariable
    "default value for the ''instanceVariable'' instance variable (automatically generated)"

    self shouldImplement.
    ^ nil'.


    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertMethodSource: expectedSetterSource atSelector: #instanceVariable:.
    self assertClassMethodSource: expectedDefaultSource atSelector: #defaultInstanceVariable

    "Created: / 08-07-2014 / 18:43:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-07-2014 / 20:11:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_lazy_initialization_access_methods_generated_without_comments
    | expectedGetterSource expectedSetterSource expectedDefaultSource |

    userPreferences
        generateCommentsForGetters: false;
        generateCommentsForSetters: false.

    expectedGetterSource := 'instanceVariable
    instanceVariable isNil ifTrue:[
        instanceVariable := self class defaultInstanceVariable.
    ].
    ^ instanceVariable'.

    expectedSetterSource := 'instanceVariable:something 
    (instanceVariable ~~ something) ifTrue:[
        instanceVariable := something.
        self changed:#instanceVariable.
    ].'.

    expectedDefaultSource := 'defaultInstanceVariable
    self shouldImplement.
    ^ nil'.


    self executeGeneratorInContext: #classWithInstanceVariable.
    self assertMethodSource: expectedGetterSource atSelector: #instanceVariable.
    self assertMethodSource: expectedSetterSource atSelector: #instanceVariable:.
    self assertClassMethodSource: expectedDefaultSource atSelector: #defaultInstanceVariable

    "Created: / 08-07-2014 / 19:37:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-07-2014 / 20:11:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

