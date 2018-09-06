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

Smalltalk::TestCase subclass:#CustomMockTests
	instanceVariableNames:'model mock testCompleted'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomMockTests class methodsFor:'documentation'!

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

!CustomMockTests methodsFor:'initialization & release'!

setUp

    model := CustomNamespace new.
    mock := CustomMock new.
    testCompleted := false.

    "Modified: / 09-10-2014 / 09:34:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    model undoChanges.
    mock unmockAll

    "Modified: / 19-10-2014 / 14:56:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMockTests methodsFor:'private'!

performTest
    Class withoutUpdatingChangesDo:[
        self perform: testSelector sunitAsSymbol
    ]

    "Created: / 24-09-2014 / 21:30:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMockTests methodsFor:'tests'!

test_class_and_instance_methods_overriden_by_compiled_mock_method
    | class mockClass |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: (class theMetaclass) protocol: 'p' source: 'aSelector_01: aParam
        ^ 10'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_01: aParam
        ^ 15'.

        self assert: (class aSelector_01: nil) = 10.
        self assert: (class new aSelector_01: nil) = 15.

        mockClass := mock mockClassOf: class.
        mockClass compileMockMethod: 'aSelector_01: aParam ^ 20'.
        mockClass new compileMockMethod: 'aSelector_01: aParam ^ 25'.

        self assert: (mockClass aSelector_01: nil) = 20.
        self assert: (mockClass new aSelector_01: nil) = 25.

        testCompleted := true.

    ] ensure: [
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 23-09-2014 / 22:53:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_methods_overriden_by_compiled_mock_method
    | class mockClass |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: (class theMetaclass) protocol: 'p' source: 'aSelector_01: aParam
        ^ 10'.
        model createMethodImmediate: (class theMetaclass) protocol: 'p' source: 'aSelector_02: aParam

        (self aSelector_01: aParam) = 10 ifTrue: [ ^ true ].

        ^ false'.

        self assert: (class aSelector_02: nil).

        mockClass := mock mockClassOf: class.
        mockClass compileMockMethod: 'aSelector_01: aParam ^ 20'.

        self assert: (mockClass aSelector_01: nil) = 20.
        self assert: (mockClass aSelector_02: nil) not.

        testCompleted := true.

    ] ensure: [
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 23-09-2014 / 22:54:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_methods_overriden_by_mock
    | class mockClass |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: class theMetaclass protocol: 'p' source: 'aSelector_01: aParam
        ^ 10'.
        model createMethodImmediate: class theMetaclass protocol: 'p' source: 'aSelector_02: aParam

        (self aSelector_01: aParam) = 10 ifTrue: [ ^ true ].

        ^ false'.

        self assert: (class aSelector_02: nil).

        mockClass := mock mockClassOf: class.
        mockClass mockSelector: #aSelector_01: withReturnValue: 20.

        self assert: (mockClass aSelector_01: nil) = 20.
        self assert: (mockClass aSelector_02: nil) not. 

        testCompleted := true.

    ] ensure: [
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 10-07-2014 / 19:35:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 22-09-2014 / 23:14:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_create_mock_getters_for_selectors    
    | expectedSource01 actualSource01 expectedSource02 actualSource02 mockClass |

    mockClass := mock mockClassOf: Object.
    mock createMockGetters: mockClass forSelectors: {'selector'. 'selector:'}.

    expectedSource01 := 'selector ^ self objectAttributeAt: #selector'.
    expectedSource02 := 'selector:arg ^ self objectAttributeAt: #selector:'.

    actualSource01 := mockClass sourceCodeAt:#selector.
    actualSource02 := mockClass sourceCodeAt:#selector:.

    self assert: expectedSource01 = actualSource01.           
    self assert: expectedSource02 = actualSource02.

    "Modified: / 28-12-2014 / 15:29:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_methods_overriden_by_compiled_mock_method
    | class mockClassInstance |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_01: aParam
        ^ 10'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_02: aParam

        (self aSelector_01: aParam) = 10 ifTrue: [ ^ true ].

        ^ false'.

        self assert: (class new aSelector_02: nil).

        mockClassInstance := mock mockOf: class.
        mockClassInstance compileMockMethod: 'aSelector_01: aParam ^ 20'.

        self assert: (mockClassInstance aSelector_01: nil) = 20.
        self assert: (mockClassInstance aSelector_02: nil) not.


        testCompleted := true.

    ] ensure: [ 
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 23-09-2014 / 22:54:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_methods_overriden_by_compiled_mock_method_value_with_params
    | class mockClassInstance |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_01: aParam
        ^ 10'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_02: aParam

        (self aSelector_01: aParam) = 10 ifTrue: [ ^ true ].

        ^ false'.

        self assert: (class new aSelector_02: nil).

        mockClassInstance := mock mockOf: class.
        mockClassInstance compileMockMethod: 'aSelector_01: aParam
            aParam = 5 ifTrue: [
                ^ 10
            ].

            ^ 30'.

        self assert: (mockClassInstance aSelector_01: 5) = 10.
        self assert: (mockClassInstance aSelector_02: 3) not.

        testCompleted := true.

    ] ensure: [ 
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 23-09-2014 / 22:54:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_methods_overriden_by_compiled_mock_method_value_with_two_params
    | class mockClassInstance |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_01: arg_01 param_02: arg_02
        ^ 10'.

        self assert: ((class new aSelector_01: 1 param_02: 2) = 10).

        mockClassInstance := mock mockOf: class.
        mockClassInstance compileMockMethod: 'aSelector_01:arg_01 param_02:arg_02 ^ arg_01 + arg_02'.

        self assert: (mockClassInstance aSelector_01: 3 param_02: 3) = 6.

        testCompleted := true.

    ] ensure: [ 
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 23-09-2014 / 22:54:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_methods_overriden_by_compiled_mock_method_with_none_params
    | class mockClassInstance |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_01
        ^ 10'.

        self assert: (class new aSelector_01 = 10).

        mockClassInstance := mock mockOf: class.
        mockClassInstance compileMockMethod: 'aSelector_01 ^ 30'.

        self assert: (mockClassInstance aSelector_01) = 30.

        testCompleted := true.

    ] ensure: [
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 23-09-2014 / 22:54:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_methods_overriden_by_compiled_mock_method_with_three_params
    | class mockClassInstance |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_01: arg_01 param_02: arg_02 param_03: arg_03
        ^ 10'.

        self assert: ((class new aSelector_01: 1 param_02: 2 param_03: 3) = 10).

        mockClassInstance := mock mockOf: class.
        mockClassInstance compileMockMethod: 'aSelector_01:arg_01 param_02:arg_02 param_03:arg_03  
            ^ arg_01 + arg_02 + arg_03'.

        self assert: (mockClassInstance aSelector_01: 3 param_02: 3 param_03: 3) = 9.

        testCompleted := true.

    ] ensure: [ 
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 23-09-2014 / 22:55:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_methods_overriden_by_mock
    | class mockClassInstance |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_01: aParam
        ^ 10'.
        model createMethodImmediate: class protocol: 'p' source: 'aSelector_02: aParam

        (self aSelector_01: aParam) = 10 ifTrue: [ ^ true ].

        ^ false'.

        self assert: (class new aSelector_02: nil).

        mockClassInstance := mock mockOf: class.
        mockClassInstance mockSelector: #aSelector_01: withReturnValue: 20.

        self assert: (mockClassInstance aSelector_01: nil) = 20.
        self assert: (mockClassInstance aSelector_02: nil) not.


        testCompleted := true.

    ] ensure: [ 
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 15-06-2014 / 20:19:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (format): / 22-09-2014 / 23:14:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_mock_count_incremented_when_new_class_created
    | class mockCount |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.

        mockCount := mock mockCount.  

        mock mockOf: class.

        self assert: (mockCount + 1) = (mock mockCount).

        testCompleted := true.

    ] ensure: [ 
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 22-09-2014 / 23:05:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:19:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_namespace_not_created_for_class_with_namespace
    "If class name contains also namespace name then it is created along with the class.
    Assert that namespace is not created, because there is no use for it in temporary class
    - only leaves mess in the browser."
    | class expectedNameSpaceCount actualNameSpaceCount |

    [
        class := model createClassImmediate: 'DummyNameSpace01::DummyClass01'.

        expectedNameSpaceCount := NameSpace allNameSpaces size.
        self assert: expectedNameSpaceCount > 1.

        mock mockClassOf: class.

        actualNameSpaceCount := NameSpace allNameSpaces size.

        self assert: expectedNameSpaceCount = actualNameSpaceCount.

        testCompleted := true.

    ] ensure: [
        (Smalltalk at: #DummyNameSpace01) notNil ifTrue: [ 
            Class withoutUpdatingChangesDo: [  
                (Smalltalk at: #DummyNameSpace01) removeFromSystem
            ]
        ].

        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 24-01-2015 / 19:22:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:19:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_unmock_all
    | class mockClass mockClassName |

    [
        class := model createClassImmediate: 'TestClassForMockTestCase' superClassName: 'Object'.

        mockClass := mock mockClassOf: class.
        mockClassName := mockClass name.

        self assert: (Smalltalk at: mockClassName) isNil not.
        mock unmockAll.
        self assert: (Smalltalk at: mockClassName) isNil.

        testCompleted := true.

    ] ensure: [
        "Need to test if test is complete, because in this case
        sometimes happens that the test terminates and is marked as success."
        self assert: testCompleted
    ].

    "Created: / 23-09-2014 / 22:58:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMockTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

