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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomVisitorCodeGeneratorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Generators-Tests'
!

!CustomVisitorCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomVisitorCodeGeneratorTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomVisitorCodeGenerator new
! !

!CustomVisitorCodeGeneratorTests methodsFor:'tests'!

test_accept_visitor_method_generated_with_comment_and_with_parameter
    "check if methods for visitor pattern are correctly generated"
    | expectedSource class |

    userPreferences generateComments: true.

    expectedSource := 'acceptVisitor:visitor with:parameter 
    "Double dispatch back to the visitor, passing my type encoded in
the selector (visitor pattern)"
    "stub code automatically generated - please change if required"

    ^ visitor visitDummyTestClassForVisitorMethod:self with:parameter'.

    class := model createClassImmediate: 'DummyTestClassForVisitorMethod'.

    generatorOrRefactoring
        buildAcceptVisitorMethod: 'visitDummyTestClassForVisitorMethod:'
        withParameter: true 
        forClass: class.

    generatorOrRefactoring model execute.

    self assertMethodSource: expectedSource atSelector: #acceptVisitor:with: forClass: class

    "Created: / 27-07-2014 / 12:32:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 20:59:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_accept_visitor_method_generated_with_comment_and_without_parameter
    "check if methods for visitor pattern are correctly generated"
    | expectedSource class |

    userPreferences generateComments: true.

    expectedSource := 'acceptVisitor:visitor 
    "Double dispatch back to the visitor, passing my type encoded in
the selector (visitor pattern)"
    "stub code automatically generated - please change if required"

    ^ visitor visitDummyTestClassForVisitorMethod:self'.

    class := model createClassImmediate: 'DummyTestClassForVisitorMethod'.

    generatorOrRefactoring
        buildAcceptVisitorMethod: 'visitDummyTestClassForVisitorMethod:'
        withParameter: false 
        forClass: class.

    generatorOrRefactoring model execute.

    self assertMethodSource: expectedSource atSelector: #acceptVisitor: forClass: class

    "Created: / 03-08-2014 / 22:50:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 20:59:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_accept_visitor_method_generated_without_comment_and_with_parameter
    "check if methods for visitor pattern are correctly generated"
    | expectedSource class |

    userPreferences generateComments: false.

    expectedSource := 'acceptVisitor:visitor with:parameter 
    ^ visitor visitDummyTestClassForVisitorMethod:self with:parameter'.

    class := model createClassImmediate: 'DummyTestClassForVisitorMethod'.

    generatorOrRefactoring
        buildAcceptVisitorMethod: 'visitDummyTestClassForVisitorMethod:'
        withParameter: true 
        forClass: class.

    generatorOrRefactoring model execute.

    self assertMethodSource: expectedSource atSelector: #acceptVisitor:with: forClass: class

    "Created: / 03-08-2014 / 22:53:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 20:59:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_accept_visitor_method_generated_without_comment_and_without_parameter
    "check if methods for visitor pattern are correctly generated"
    | expectedSource class |

    userPreferences generateComments: false.  

    expectedSource := 'acceptVisitor:visitor
    ^ visitor visitDummyTestClassForVisitorMethod:self'.

    class := model createClassImmediate: 'DummyTestClassForVisitorMethod'.

    generatorOrRefactoring
        buildAcceptVisitorMethod: 'visitDummyTestClassForVisitorMethod:'
        withParameter: false 
        forClass: class.

    generatorOrRefactoring model execute.

    self assertMethodSource: expectedSource atSelector: #acceptVisitor: forClass: class

    "Created: / 03-08-2014 / 22:51:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-08-2014 / 21:00:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

