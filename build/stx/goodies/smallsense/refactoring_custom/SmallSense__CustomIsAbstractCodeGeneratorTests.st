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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomIsAbstractCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomIsAbstractCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomIsAbstractCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomIsAbstractCodeGenerator new
! !

!CustomIsAbstractCodeGeneratorTests methodsFor:'tests'!

test_available_in_context

    self deny: (generatorOrRefactoring class availableInContext:context).

    context selectedClasses: (Array with: self class).

    self assert: (generatorOrRefactoring class availableInContext:context).

    "Modified (format): / 15-11-2014 / 15:51:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective_class
    
    self assert: (generatorOrRefactoring class availableInPerspective: CustomPerspective classPerspective)

    "Modified: / 15-11-2014 / 15:52:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_method_exists
    | expectedSource metaclass class |

    metaclass := model createClass
        name: #DummyClass01;
        compile;
        theMetaclass.

    metaclass compile: 'isAbstract ^ false'.

    expectedSource := 'isAbstract ^ false'.

    context selectedClasses: (Array with: metaclass).
    generatorOrRefactoring executeInContext: context.  

    class := Smalltalk at: #DummyClass01.
    self assertClassMethodSource:expectedSource atSelector:#isAbstract forClass:class

    "Created: / 16-11-2014 / 17:25:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_method_generated
    |expectedSource|

    expectedSource := 'isAbstract
    ^ self == DummyClassForGeneratorTestCase'.

    self executeGeneratorInContext:#classWithInstanceVariable. 

    self assertClassMethodSource:expectedSource atSelector:#isAbstract

    "Created: / 15-11-2014 / 15:53:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 15-11-2014 / 19:32:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_abstract_method_generated_for_metaclass
    | expectedSource metaclass class |

    metaclass := model createClass
        name: #DummyClass01;
        compile;
        theMetaclass.

    expectedSource := 'isAbstract
    ^ self == DummyClass01'.

    context selectedClasses: (Array with: metaclass).
    generatorOrRefactoring executeInContext: context.  

    class := Smalltalk at: #DummyClass01.
    self assertClassMethodSource:expectedSource atSelector:#isAbstract forClass:class

    "Created: / 16-11-2014 / 17:17:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

