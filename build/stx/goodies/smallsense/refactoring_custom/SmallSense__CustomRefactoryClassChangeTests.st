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

Smalltalk::TestCase subclass:#CustomRefactoryClassChangeTests
	instanceVariableNames:'change model'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomRefactoryClassChangeTests class methodsFor:'documentation'!

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

!CustomRefactoryClassChangeTests methodsFor:'initialization & release'!

setUp
    super setUp.

    model := RBNamespace new.
    change := RefactoryClassChange new
        model: model;
        yourself.

    "Modified: / 08-11-2014 / 14:29:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryClassChangeTests methodsFor:'tests'!

test_change_class_with_existing_class
    | expectedClass actualClass |

    change changeClass: self class.

    expectedClass := self class.
    actualClass := change changeClass.

    self assert: expectedClass == actualClass

    "Created: / 08-11-2014 / 14:35:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_class_with_existing_class_with_rb_class
    | expectedClass actualClass rbClass |

    rbClass := model classFor: self class.  

    change changeClass: rbClass.

    expectedClass := self class.
    actualClass := change changeClass.

    self assert: expectedClass == actualClass

    "Created: / 08-11-2014 / 14:36:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_class_with_existing_metaclass
    | expectedClass actualClass |

    change changeClass: self class class.

    expectedClass := self class class.
    actualClass := change changeClass.

    self assert: expectedClass == actualClass

    "Created: / 08-11-2014 / 14:35:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_class_with_non_existing_class
    | expectedClass actualClass |

    change model: nil.

    change changeClass: (RBClass new
        name: #DummyClass01;
        yourself).

    self assert: (Smalltalk at: #DummyClass01) isNil.

    expectedClass := nil.
    actualClass := change changeClass.

    self assert: expectedClass == actualClass

    "Created: / 08-11-2014 / 14:38:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_class_with_non_existing_class_but_model_class
    | expectedClass actualClass class |

    model defineClass: 'Object subclass:#DummyClassForTestCase01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:'''''.

    self assert: (Smalltalk at: #DummyClassForTestCase01) isNil.

    class := model classNamed: #DummyClassForTestCase01.

    change changeClass: class.

    expectedClass := class.
    actualClass := change changeClass.

    self assert: expectedClass == actualClass

    "Created: / 08-11-2014 / 14:27:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_class_with_non_existing_metaclass_but_model_metaclass
    | expectedClass actualClass class |

    model defineClass: 'Object subclass:#DummyClassForTestCase01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:'''''.

    self assert: (Smalltalk at: #DummyClassForTestCase01) isNil.

    class := model metaclassNamed: #DummyClassForTestCase01.

    change changeClass: class.

    expectedClass := class.
    actualClass := change changeClass.

    self assert: expectedClass == actualClass

    "Created: / 08-11-2014 / 14:33:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

