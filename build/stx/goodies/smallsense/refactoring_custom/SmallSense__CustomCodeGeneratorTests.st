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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomCodeGenerator new
! !

!CustomCodeGeneratorTests methodsFor:'tests'!

test_execute_sub_generator_classes
    | subGeneratorClass_01 subGeneratorClass_02 expectedSource_01 expectedSource_02 |

    "/ setup context
    self classWithInstanceVariable.

    subGeneratorClass_01 := mock mockClassOf: CustomCodeGenerator.
    subGeneratorClass_02 := mock mockClassOf: CustomCodeGenerator.

    subGeneratorClass_01 compileMockMethod: 'description ''01'' '.
    subGeneratorClass_01 new compileMockMethod: 'buildInContext: aCustomContext

        aCustomContext selectedClasses do: [ :class | 
            model createMethod
                class: class;
                source: ''selector_01 ^ 1'';
                compile.
        ]'.

    subGeneratorClass_02 compileMockMethod: 'description ''02'' '.
    subGeneratorClass_02 new compileMockMethod: 'buildInContext: aCustomContext

        aCustomContext selectedClasses do: [ :class | 
            model createMethod
                class: class;
                source: ''selector_02 ^ 2'';
                compile.
        ]'.

    generatorOrRefactoring 
          executeSubGeneratorOrRefactoringClasses:(Array with:subGeneratorClass_01
                  with:subGeneratorClass_02)
          inContext:context. 

    expectedSource_01 := 'selector_01
    ^ 1'.

    expectedSource_02 := 'selector_02
    ^ 2'.

    self assertMethodSource: expectedSource_01 atSelector: #selector_01.
    self assertMethodSource: expectedSource_02 atSelector: #selector_02.

    "Created: / 10-07-2014 / 12:11:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-10-2014 / 16:06:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

