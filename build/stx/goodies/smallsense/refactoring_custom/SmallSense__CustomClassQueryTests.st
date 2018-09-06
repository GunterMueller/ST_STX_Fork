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

Smalltalk::TestCase subclass:#CustomClassQueryTests
	instanceVariableNames:'classQuery model mockSuperClass mockClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Helpers-Tests'
!

!CustomClassQueryTests class methodsFor:'documentation'!

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

!CustomClassQueryTests methodsFor:'initialization & release'!

setUp

    classQuery := CustomClassQuery new.
    model := CustomNamespace new.
    mockSuperClass := model createClassImmediate: 'MockSuperClassForTestCase' superClassName: 'Object'.
    mockClass := model createClassImmediate: 'MockClassForTestCase' superClassName: (mockSuperClass new className).

    "Modified: / 09-10-2014 / 09:33:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    model undoChanges

    "Modified: / 19-10-2014 / 14:56:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomClassQueryTests methodsFor:'tests'!

test_method_from_superclass_not_found_01
    | method |                                                                              

    method := classQuery methodForSuperclassSelector: 'someNonExistingMethod:withParam:' class: Object.
    self assert: method isNil.

    "Created: / 07-10-2014 / 19:54:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_from_superclass_not_found_02
    | method |                                                                              

    method := classQuery methodForSuperclassSelector: 'someNonExistingMethod:withParam:' class: self class.
    self assert: method isNil.

    "Created: / 07-10-2014 / 19:54:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_method_from_superclass_retrieved
    | method |

    self assert: (classQuery methodForSuperclassSelector: 'initialize' class: Object) isNil.

    "/ Instance method
    model createMethodImmediate: mockSuperClass protocol: 'instance-protocol' source: 'instanceMethod: aParam
    self shouldImplement'.

    method := classQuery methodForSuperclassSelector: #instanceMethod: class: mockClass.
    self assert: 'instance-protocol' = method category.

    self assert: 'instanceMethod:aParam' = method methodDefinitionTemplate.

    "/ Class method
    model createMethodImmediate: mockSuperClass class protocol: 'class-protocol' source: 'classMethod: aParam
    self shouldImplement'.

    method := classQuery methodForSuperclassSelector: 'classMethod:' class: mockClass class.
    self assert: 'class-protocol' = method category.
    self assert: 'classMethod:aParam' = method methodDefinitionTemplate.

    "Created: / 14-04-2014 / 18:12:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 15-06-2014 / 16:17:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

