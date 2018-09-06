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

Smalltalk::TestCase subclass:#CustomRBMetaclassTests
	instanceVariableNames:'rbClass mock model'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

CustomRBMetaclassTests subclass:#MockPrivateClass01
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRBMetaclassTests
!

CustomRBMetaclassTests::MockPrivateClass01 subclass:#MockPrivateClass03
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRBMetaclassTests::MockPrivateClass01
!

Object subclass:#MockPrivateClass02
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:CustomRBMetaclassTests
!

!CustomRBMetaclassTests class methodsFor:'documentation'!

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
!

documentation
"
    Test extensions in RBMetaclass.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz> 

"
! !

!CustomRBMetaclassTests methodsFor:'initialization & release'!

setUp

    mock := CustomMock new.
    model := RBNamespace new.
    rbClass := mock mockOf: RBMetaclass.
    rbClass model: model.

    "Created: / 29-11-2014 / 02:28:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    mock unmockAll

    "Created: / 29-11-2014 / 02:28:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBMetaclassTests methodsFor:'tests'!

test_owning_class_empty
    | expectedClass actualClass |

    expectedClass := nil.
    actualClass := rbClass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 12:37:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class_set_model_class
    | expectedClass actualClass |

    expectedClass := RBClass new.
    rbClass owningClass: expectedClass.
    actualClass := rbClass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 12:43:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class_set_model_metaclass
    | expectedClass actualClass |

    expectedClass := model classNamed: self class name.
    rbClass owningClass: expectedClass theMetaclass.
    actualClass := rbClass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 13:39:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class_set_real_class
    | expectedClass actualClass |

    expectedClass := model classNamed: self class name.
    rbClass owningClass: self class.
    actualClass := rbClass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 12:42:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class_set_real_metaclass
    | expectedClass actualClass |

    expectedClass := model classNamed: self class name.
    rbClass owningClass: self class theMetaclass.
    actualClass := rbClass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 13:37:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_owning_class_with_real_class
    | expectedClass actualClass |

    expectedClass := model classNamed: #'SmallSense::CustomRBMetaclassTests'.

    rbClass realClass: SmallSense::CustomRBMetaclassTests::MockPrivateClass01.
    actualClass := rbClass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 02:31:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 29-11-2014 / 12:19:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:28:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_owning_class_with_real_class_with_different_superclass
    | expectedClass actualClass |

    expectedClass := model classNamed: #'SmallSense::CustomRBMetaclassTests'.

    rbClass realClass: CustomRBMetaclassTests::MockPrivateClass02.
    actualClass := rbClass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 12:20:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:28:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_owning_class_with_real_class_without_owner
    | expectedClass actualClass |

    expectedClass := nil.

    rbClass realClass: CustomRBMetaclassTests.
    actualClass := rbClass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 12:21:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_private_class_01
    | expectedClass actualClass |

    "Cannot use self class, because TestRunner eats also private classes
    and when running in private class the class is different"
    expectedClass := CustomRBMetaclassTests.
    actualClass := CustomRBMetaclassTests::MockPrivateClass01 owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 13:34:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 30-11-2014 / 17:18:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_private_class_02
    | expectedClass actualClass |

    "Cannot use self class, because TestRunner eats also private classes
    and when running in private class the class is different"
    expectedClass := CustomRBMetaclassTests.
    actualClass := CustomRBMetaclassTests::MockPrivateClass01 class owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 13:35:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 30-11-2014 / 17:18:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_private_class_03
    | expectedClass actualClass |

    "Cannot use self class, because TestRunner eats also private classes
    and when running in private class the class is different"
    expectedClass := CustomRBMetaclassTests.
    actualClass := CustomRBMetaclassTests::MockPrivateClass01 theMetaclass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 13:35:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 30-11-2014 / 17:18:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_private_class_04
    | expectedClass actualClass |

    "Cannot use self class, because TestRunner eats also private classes
    and when running in private class the class is different"
    expectedClass := CustomRBMetaclassTests.
    actualClass := CustomRBMetaclassTests::MockPrivateClass01 theNonMetaclass owningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 13:35:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 30-11-2014 / 17:18:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_top_owning_class_empty
    | expectedClass actualClass |

    expectedClass := nil.
    actualClass := rbClass topOwningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 13:53:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_top_owning_class_with_real_class
    | expectedClass actualClass |

    expectedClass := model classNamed: #'SmallSense::CustomRBMetaclassTests'.

    rbClass realClass: CustomRBMetaclassTests::MockPrivateClass01.
    actualClass := rbClass topOwningClass.

    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 14:04:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:28:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_top_owning_class_with_real_class_two_level
    | expectedClass actualClass |

    expectedClass := model classNamed: #'SmallSense::CustomRBMetaclassTests'.

    rbClass realClass: CustomRBMetaclassTests::MockPrivateClass01 myMockPrivateClass03.
    actualClass := rbClass topOwningClass.

    self assert: (rbClass realClass name) = #'SmallSense::CustomRBMetaclassTests::MockPrivateClass01::MockPrivateClass03'.
    self assert: expectedClass = actualClass

    "Created: / 29-11-2014 / 14:05:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:13:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:29:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomRBMetaclassTests::MockPrivateClass01 class methodsFor:'accessing'!

myMockPrivateClass03
    "Returns my private class (for testing purposes)"

    ^ MockPrivateClass03

    "Created: / 29-11-2014 / 14:08:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

