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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomVisitorCodeGeneratorAcceptVisitorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomVisitorCodeGeneratorAcceptVisitorTests class methodsFor:'documentation'!

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

!CustomVisitorCodeGeneratorAcceptVisitorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomVisitorCodeGeneratorAcceptVisitor new
! !

!CustomVisitorCodeGeneratorAcceptVisitorTests methodsFor:'tests'!

test_accept_visitor_method_generated_with_comments
    |expectedSource|

    userPreferences generateComments: true.  

    expectedSource := 'acceptVisitor:visitor
    "Double dispatch back to the visitor, passing my type encoded in
the selector (visitor pattern)"
    "stub code automatically generated - please change if required"

    ^ visitor visitDummyClassForGeneratorTestCase:self'.

    self executeGeneratorInContext:#classWithInstanceVariable.
    self assertMethodSource:expectedSource atSelector:#acceptVisitor:

    "Created: / 03-08-2014 / 23:06:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 21:00:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_accept_visitor_method_generated_without_comments
    |expectedSource|

    userPreferences generateComments: false.  

    expectedSource := 'acceptVisitor:visitor
    ^ visitor visitDummyClassForGeneratorTestCase:self'.

    self executeGeneratorInContext:#classWithInstanceVariable.
    self assertMethodSource:expectedSource atSelector:#acceptVisitor:

    "Created: / 03-08-2014 / 23:33:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 21:13:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

