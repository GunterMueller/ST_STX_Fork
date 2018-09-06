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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomAddClassChangeTests
	instanceVariableNames:'className change'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomAddClassChangeTests class methodsFor:'documentation'!

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

!CustomAddClassChangeTests methodsFor:'accessing'!

generatorOrRefactoring

    ^ nil

    "Created: / 16-10-2014 / 22:57:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAddClassChangeTests methodsFor:'initialize & release'!

setUp
    super setUp.

    className := 'DummyTestClass01'.
    self assert: (Smalltalk classNamed: className) isNil.    

    change := AddClassChange definition: '
    Object subclass:#', className, '
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        category:''''
    '.

    "Modified: / 16-10-2014 / 22:55:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown
    | realClass |
    
    realClass := Smalltalk classNamed: className.
    realClass notNil ifTrue: [
        realClass removeFromSystem
    ].

    super tearDown.

    "Modified: / 30-11-2014 / 17:04:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomAddClassChangeTests methodsFor:'tests'!

test_argumens_by_selector_parts_from_message_arguments_missing
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'Object subclass: SomeClass01 category: #SomeCategory01 '.
    messageNode arguments: #().

    expectedResult := Dictionary new.
    actualResult := change argumensBySelectorPartsFromMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:12:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_argumens_by_selector_parts_from_message_none_argument
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'Object name'.

    expectedResult := Dictionary new.
    actualResult := change argumensBySelectorPartsFromMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:03:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_argumens_by_selector_parts_from_message_one_argument
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'Object subclass: SomeClass01'.

    expectedResult := Dictionary new
        at: #subclass: put: (messageNode arguments first);
        yourself.

    actualResult := change argumensBySelectorPartsFromMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:05:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:55:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_argumens_by_selector_parts_from_message_selector_empty
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'Object subclass: SomeClass01 category: #SomeCategory01 '.
    messageNode selectorParts: #().

    expectedResult := Dictionary new
        at: 1 put: (messageNode arguments first);
        at: 2 put: (messageNode arguments second);
        yourself.

    actualResult := change argumensBySelectorPartsFromMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:10:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:55:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_argumens_by_selector_parts_from_message_selector_missing
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'Object subclass: SomeClass01 category: #SomeCategory01 '.
    messageNode selectorParts: nil.

    expectedResult := Dictionary new
        at: 1 put: (messageNode arguments first);
        at: 2 put: (messageNode arguments second);
        yourself.

    actualResult := change argumensBySelectorPartsFromMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:10:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:55:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_argumens_by_selector_parts_from_message_two_arguments
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'Object subclass: SomeClass01 category: #SomeCategory01 '.

    expectedResult := Dictionary new
        at: #subclass: put: (messageNode arguments first);
        at: #category: put: (messageNode arguments second);
        yourself.

    actualResult := change argumensBySelectorPartsFromMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:09:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:55:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_fill_out_definition_ordinary_class

    change definition: 'SomeObject01 subclass:#DummySubclass01
        instanceVariableNames:''inst01 inst02''
        classVariableNames:''Cls01 Cls02''
        poolDictionaries:''pool01''
        category:''Some-Category01'''.

    change fillOutDefinition. 

    self assert: #DummySubclass01 = (change changeClassName).
    self assert: change privateInClassName isNil.
    self assert: #SomeObject01 = (change superclassName).
    self assert: #'Some-Category01' = (change category).
    self assert: (#(inst01 inst02) asStringCollection) = (change instanceVariableNames).
    self assert: (#(Cls01 Cls02) asStringCollection) = (change classVariableNames).
    self assert: (#(pool01) asOrderedCollection) = (change poolDictionaryNames).

    "Created: / 16-11-2014 / 16:12:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 12:40:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_fill_out_definition_private_class_01

    change definition: 'Object subclass:#DummyPrivateClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        privateIn:Object'.

    change fillOutDefinition. 

    self assert: #'Object::DummyPrivateClass01' = (change changeClassName).
    self assert: #Object = (change privateInClassName).
    self assert: #Object = (change superclassName).
    self assert: #'' = (change category).
    self assert: (StringCollection new) = (change instanceVariableNames).
    self assert: (StringCollection new) = (change classVariableNames).
    self assert: (OrderedCollection new) = (change poolDictionaryNames).

    "Created: / 16-11-2014 / 15:56:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:08:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_fill_out_definition_private_class_02

    change definition: 'SomeObject01 subclass:#DummyPrivateClass01
        instanceVariableNames:''inst01 inst02''
        classVariableNames:''Cls01 Cls02''
        poolDictionaries:''pool01''
        privateIn:SomeObject02'.

    change fillOutDefinition. 

    self assert: #'SomeObject02::DummyPrivateClass01' = (change changeClassName).
    self assert: #SomeObject02 = (change privateInClassName).
    self assert: #SomeObject01 = (change superclassName).
    self assert: #'' = (change category).
    self assert: (#(inst01 inst02) asStringCollection) = (change instanceVariableNames).
    self assert: (#(Cls01 Cls02) asStringCollection) = (change classVariableNames).
    self assert: (#(pool01) asOrderedCollection) = (change poolDictionaryNames).

    "Created: / 16-11-2014 / 16:08:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 13:08:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_get_and_set_package

    self assert: change package isNil.

    change package: #some_package01.

    self assert: #some_package01 = (change package).

    "Created: / 17-10-2014 / 09:06:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_valid_message_name
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'Object subclass: SomeClass01 category: #SomeCategory01 '.

    expectedResult := false.
    actualResult := change isValidMessageName: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:15:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_valid_message_name_with_private_class
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'DummyObject01 subclass:#DummyPrivateClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        privateIn:DummyObject02'.

    expectedResult := true.
    actualResult := change isValidMessageName: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:16:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_valid_subclass_creation_message_for_private_class
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'DummyObject01 subclass:#DummyPrivateClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        privateIn:DummyObject02'.

    expectedResult := true.
    actualResult := change isValidSubclassCreationMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:23:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_valid_subclass_creation_message_for_private_class_wrong
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'DummyObject01 subclass:DummyPrivateClass01
        instanceVariableNames:''''
        classVariableNames:''''
        poolDictionaries:''''
        privateIn:DummyObject02'.

    expectedResult := false.
    actualResult := change isValidSubclassCreationMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:33:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_valid_subclass_creation_message_for_unkown_message
    | expectedResult actualResult messageNode |

    messageNode := RBParser parseExpression: 'DummyObject01 subclass:#DummyPrivateClass01'.

    expectedResult := false.
    actualResult := change isValidSubclassCreationMessage: messageNode.

    self assert: expectedResult = actualResult

    "Created: / 16-11-2014 / 15:34:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_primitive_execute_with_package

    | class |

    change package: #some_package01.
    change primitiveExecute.

    self assertClassExists: className.
    class := Smalltalk classNamed: className.
    self assert: #some_package01 = (class package).

    "Created: / 16-10-2014 / 22:49:48 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 17-10-2014 / 08:10:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_primitive_execute_without_package

    | class |

    change primitiveExecute.

    self assertClassExists: className.
    class := Smalltalk classNamed: className.
    self assert: (PackageId noProjectID) = (class package).

    "Created: / 17-10-2014 / 08:11:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

