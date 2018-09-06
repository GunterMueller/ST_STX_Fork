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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomReplaceIfNilWithIfTrueRefactoringTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Refactorings-Tests'
!

!CustomReplaceIfNilWithIfTrueRefactoringTests class methodsFor:'documentation'!

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

!CustomReplaceIfNilWithIfTrueRefactoringTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomReplaceIfNilWithIfTrueRefactoring new
! !

!CustomReplaceIfNilWithIfTrueRefactoringTests methodsFor:'tests'!

test_available_in_context
    
    "Available for every context"
    self assert: (generatorOrRefactoring class availableInContext: context).

    "Modified: / 16-10-2014 / 21:36:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective

    "Available for every perspective"
    self assert: (generatorOrRefactoring class availableInContext: CustomPerspective instance).

    "Modified: / 16-10-2014 / 21:38:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_if_nil_replaced_with_is_nil_if_true
    | expectedSource class |

    class := model createClassImmediate: 'DummyClassForTestCase01'.
    model createMethod
        class: class;
        protocol: 'protocol';
        source: 'selector: arg
        arg ifNil: [ 
            self warn: ''nil''.
        ]
        ifNotNil: [ self information: ''info'' ].
        ';
        compile.

    context selectedClasses: (Array with: class).  
    model execute.

    generatorOrRefactoring executeInContext: context.

    expectedSource := 'selector:arg 
    arg isNil ifTrue:[
        self warn:''nil''.
    ] ifFalse:[
        self information:''info''
    ].'.

    self assertMethodSource: expectedSource atSelector: #selector: forClass: class.

    "Created: / 10-08-2014 / 09:42:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 19:02:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 25-01-2015 / 15:17:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

