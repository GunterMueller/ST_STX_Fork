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

Smalltalk::TestCase subclass:#CustomSubContextTests
	instanceVariableNames:'model context'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomSubContextTests class methodsFor:'documentation'!

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

!CustomSubContextTests methodsFor:'initialization & release'!

setUp
    super setUp.

    model := CustomNamespace new.
    context := CustomSubContext new
        model: model;
        yourself

    "Modified: / 19-11-2014 / 19:59:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSubContextTests methodsFor:'tests'!

test_selected_classes_as_rb_class

    |expectedClasses actualClasses modelClass|

    modelClass := model classNamed: self class name.
    expectedClasses := Array with: modelClass.

    context selectedClasses: (Array with: self class).
    actualClasses := context selectedClasses.

    self assert: expectedClasses = actualClasses

    "Created: / 25-11-2014 / 20:31:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_classes_existing_rb_class

    |expectedClasses actualClasses modelClass|

    modelClass := model classNamed: self class name.
    expectedClasses := Array with: modelClass.

    context selectedClasses: (Array with: modelClass).
    actualClasses := context selectedClasses.

    self assert: expectedClasses = actualClasses

    "Created: / 25-11-2014 / 20:37:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_methods_as_rb_method

    |expectedMethods realMethod actualMethods modelClass modelMethod|

    modelClass := model classNamed: self class name.
    modelMethod := modelClass compiledMethodAt: #test_selected_methods_as_rb_method.
    expectedMethods := Array with: modelMethod.

    realMethod := self class compiledMethodAt: #test_selected_methods_as_rb_method.
    context selectedMethods: (Array with: realMethod).
    actualMethods := context selectedMethods.

    "Cannot test collection equality, because each contains different RBMethod instance
    self assert: expectedMethods = actualMethods"
    self assert: (expectedMethods size) = (actualMethods size).
    self assert: (expectedMethods first selector) = (actualMethods first selector).
    self assert: (expectedMethods first isKindOf: RBMethod).    
    self deny: expectedMethods first isMethod

    "Modified: / 19-11-2014 / 20:29:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 25-11-2014 / 20:30:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_methods_existing_rb_method

    |expectedMethods actualMethods modelClass modelMethod|

    modelClass := model classNamed: self class name.
    modelMethod := modelClass compiledMethodAt: #test_selected_methods_as_rb_method.
    expectedMethods := Array with: modelMethod.

    context selectedMethods: (Array with: modelMethod).
    actualMethods := context selectedMethods.

    self assert: expectedMethods = actualMethods

    "Created: / 19-11-2014 / 20:30:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

