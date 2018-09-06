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

Smalltalk::TestCase subclass:#CustomContextTests
	instanceVariableNames:'context model'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomContextTests class methodsFor:'documentation'!

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

!CustomContextTests methodsFor:'initialization & release'!

setUp
    super setUp.

    model := CustomNamespace new.
    context := CustomContext new
        model: model;
        yourself

    "Modified: / 19-11-2014 / 10:01:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomContextTests methodsFor:'tests'!

test_as_rb_class_class
    | expectedClass actualClass |

    expectedClass := model classNamed: self class name.
    actualClass := context asRBClass: self class.  

    self deny: expectedClass isMeta.
    self assert: expectedClass == actualClass.
    self assert: (actualClass realClass) == (self class).

    "Created: / 19-11-2014 / 10:12:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_as_rb_class_metaclass
    | expectedMetaclass actualMetaclass class |

    expectedMetaclass := model metaclassNamed: self class name.
    actualMetaclass := context asRBClass: self class class.  
    class := context asRBClass: self class.  

    self assert: expectedMetaclass isMeta.
    self deny: class isMeta.  

    self deny: expectedMetaclass == class.
    self assert: expectedMetaclass == actualMetaclass.
    self assert: (expectedMetaclass realClass) == (self class class).

    "Modified: / 19-11-2014 / 10:13:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_copy_with_model
    | contextCopy newModel |

    newModel := CustomNamespace new.
    contextCopy := context copyWithModel: newModel.
    
    self deny: context == contextCopy.
    self deny: (context model) == newModel.
    self assert: (context model) == model.
    self assert: (contextCopy model) == newModel.

    "Modified: / 25-11-2014 / 19:53:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

