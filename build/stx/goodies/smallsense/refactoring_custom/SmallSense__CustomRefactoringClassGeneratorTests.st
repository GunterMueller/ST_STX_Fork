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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomRefactoringClassGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomRefactoringClassGeneratorTests class methodsFor:'documentation'!

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

!CustomRefactoringClassGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomRefactoringClassGenerator new
! !

!CustomRefactoringClassGeneratorTests methodsFor:'tests'!

test_refactoring_subclass_created
    | expectedSource class |

    expectedSource := 'buildInContext:aCustomContext
    self shouldImplement'.

    generatorOrRefactoring
        newClassName: #DummyClass01;  
        executeInContext: context.  

    self assertClassExists: #DummyClass01.  

    class := Smalltalk at: #DummyClass01.

    self assertMethodSource:expectedSource atSelector:#buildInContext: forClass: class.  
    self assert: (class superclass name) = #SmallSense::CustomRefactoring.

    "Created: / 09-11-2014 / 01:04:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 21:03:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

