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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomNewClassGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomNewClassGeneratorTests class methodsFor:'documentation'!

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

!CustomNewClassGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    |generator|

    generator := mock mockOf: CustomNewClassGenerator.
    generator class compileMockMethod: 'description ^ ''some description''. '.
    ^ generator

    "Modified: / 09-11-2014 / 00:36:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNewClassGeneratorTests methodsFor:'tests'!

test_available_in_context
    
    self assert: (generatorOrRefactoring class availableInContext: context)

    "Modified: / 09-11-2014 / 00:17:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective
    
    self assert: (generatorOrRefactoring class availableInPerspective: CustomPerspective classPerspective)

    "Modified (comment): / 09-11-2014 / 00:18:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract
    
    self assert: CustomNewClassGenerator isAbstract

    "Modified (comment): / 09-11-2014 / 00:30:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_new_class_generated

    generatorOrRefactoring
        compileMockMethod: 'buildForClass: aClass ^ self';
        newClassName: #DummyClass01.

    generatorOrRefactoring executeInContext: context.  

    self assertClassExists: #DummyClass01.

    "Created: / 09-11-2014 / 00:32:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_new_class_generated_with_dialog

    dialog := mock mockOf: CustomDialog.
    dialog compileMockMethod: 'requestClassName: aLabel initialAnswer: anAnswer

        self assert: aLabel = ''some label''.
        self assert: anAnswer = ''DummyClass01''.

        ^ anAnswer. '.

    generatorOrRefactoring
        compileMockMethod: 'buildForClass: aClass ^ aClass superclassName: CustomCodeGenerator name';
        compileMockMethod: 'newClassNameLabel ^ ''some label''. ';
        compileMockMethod: 'defaultClassName ^ ''DummyClass01''. ';
        dialog: dialog.

    context := CustomBrowserContext new.

    generatorOrRefactoring executeInContext: context.  

    self assertClassExists: #DummyClass01.

    "Created: / 09-11-2014 / 00:48:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-11-2014 / 23:41:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 21:06:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_new_class_generated_with_subclass_responsibility
    | expectedSource |

    generatorOrRefactoring
        compileMockMethod: 'buildForClass: aClass ^ aClass superclassName: CustomCodeGenerator name';
        newClassName: #DummyClass01.

    generatorOrRefactoring executeInContext: context.  

    self assertClassExists: #DummyClass01.

    expectedSource := 'buildInContext:aCustomContext
    self shouldImplement'.

    self assertMethodSource: expectedSource atSelector: #buildInContext: forClass: (Smalltalk at: #DummyClass01).

    "Created: / 09-11-2014 / 00:41:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 21:06:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

