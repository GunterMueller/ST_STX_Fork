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

Object subclass:#CustomMock
	instanceVariableNames:'mockedClasses'
	classVariableNames:'MockCount'
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomMock class methodsFor:'documentation'!

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
    Helper for creating mocked classes.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomMock class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    MockCount := 0.

    "Modified: / 11-05-2015 / 09:25:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomMock class methodsFor:'instance creation'!

new
    "return an initialized instance"

    MockCount isNil ifTrue: [ 
        MockCount := 0
    ].

    ^ self basicNew initialize.

    "Created: / 15-06-2014 / 19:20:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMock methodsFor:'accessing'!

mockCount
    "Returns how many mock has been created ever since"

    ^ MockCount

    "Created: / 22-09-2014 / 23:05:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

variableNameForClassMockedSelectors

    ^ 'MockedClassSelectors'

    "Created: / 11-07-2014 / 10:16:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

variableNameForInstanceMockedSelectors

    ^ 'MockedSelectors'

    "Created: / 11-07-2014 / 10:15:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMock methodsFor:'code generation'!

createMockClassOf: aClass mockNumber: aNumber
    "Returns generated mock subclass of given class 
    to support custom return values of overriden methods"

    | mockClass className mockClassName |

    className := aClass theNonMetaclass name.
    mockClassName := ('CustomMock', aNumber asString, 'Of', className copyReplaceAll: $: with: $_).

    Class withoutUpdatingChangesDo:[
        | definition |

        definition := className, ' subclass:#''SmallSense::', mockClassName, '''
            instanceVariableNames:''''
            classVariableNames:''MockedSelectors MockedClassSelectors''
            poolDictionaries:''''
            category:''Interface-Refactoring-Custom-Mocks'''.

        (InteractiveAddClassChange definition: definition) execute.

        mockClass := Smalltalk classNamed: ('SmallSense::', mockClassName) asSymbol.

        self createMockMethodWithSingleValue: mockClass.
        self createMockMethodWithCompileMethod: mockClass.
    ].

    ^ mockClass

    "Created: / 15-06-2014 / 19:15:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-02-2015 / 22:46:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 14-05-2015 / 19:39:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

createMockGetters: aMockClass forSelectors: aSelectors
    "Generates mock getter method for each name"

    aSelectors do: [ :selector | 
        | getterSource template |

        template := Method methodDefinitionTemplateForSelector: selector asSymbol.

        getterSource := template, ' ^ self objectAttributeAt: #', selector.

        aMockClass compile: getterSource classified: 'mocking' logged: false.
    ]

    "Created: / 28-12-2014 / 14:58:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createMockMethod: aMockClass methodSource: aSource mockedSelectorsVariableName: aMockedSelectorsVariableName
    "Generates mock method for given mock class 
    to support custom method value/implementation by some value/block
    (depends on given source)"

    | newSource |

    newSource := aSource copyReplaceAll: '`mockedSelectorsVariableName' with: aMockedSelectorsVariableName.
    aMockClass compile: newSource classified: 'mocking' logged:false.

    "Created: / 21-09-2014 / 21:51:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 24-09-2014 / 21:26:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createMockMethodWithCompileMethod: aMockClass
    "Generates mock method for given mock class 
    to support custom method implementation by given method source"

    self
        createMockMethod: aMockClass theMetaclass
        methodSource: self compileMockMethodSource
        mockedSelectorsVariableName: ''.

    self
        createMockMethod: aMockClass theNonMetaclass
        methodSource: self compileMockMethodSource
        mockedSelectorsVariableName: ''.

    "Created: / 23-09-2014 / 22:44:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createMockMethodWithSingleValue: aMockClass
    "Generates mock method for given mock class 
    to support custom return values of overriden methods"

    | instVarName classVarName |

    classVarName := self variableNameForClassMockedSelectors.

    self
        createMockMethod: aMockClass theMetaclass
        methodSource: (self singleValueMethodSource: classVarName)
        mockedSelectorsVariableName: classVarName.

    instVarName := self variableNameForInstanceMockedSelectors.

    self
        createMockMethod: aMockClass theNonMetaclass
        methodSource: (self singleValueMethodSource: instVarName)
        mockedSelectorsVariableName: instVarName.

    "Created: / 21-09-2014 / 21:45:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMock methodsFor:'code generation - sources'!

compileMockMethodSource
    "Returns mock method source code which will compile method source."

    ^ 'compileMockMethod: aSourceCode

    self class compile:aSourceCode classified:''mocks'' logged:false'.

    "Created: / 23-09-2014 / 22:31:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

singleValueMethodSource: aMockedSelectorsVariableName
    "Returns mock method source code for given variable name
    which holds mocked selectors and its values. 
    These values are constants (within method) like numbers, classes, objects..."

    ^ 'mockSelector: aSelector withReturnValue: aValue

    | classQuery superclassMethod methodDefinitionTemplate |

    `mockedSelectorsVariableName isNil ifTrue: [ 
        `mockedSelectorsVariableName := Dictionary new
    ].

    `mockedSelectorsVariableName at: aSelector asSymbol put: aValue.

    classQuery := CustomClassQuery new.
    superclassMethod := classQuery methodForSuperclassSelector: aSelector class: self class.
    methodDefinitionTemplate := superclassMethod methodDefinitionTemplate asString.

    self compileMockMethod: (methodDefinitionTemplate, ''
        ^ `mockedSelectorsVariableName at: #'', aSelector)'.

    "Created: / 10-07-2014 / 22:23:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 24-09-2014 / 21:00:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMock methodsFor:'initialization'!

initialize

    mockedClasses := OrderedCollection new

    "Created: / 15-06-2014 / 19:19:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMock methodsFor:'mock creation'!

mockClassOf: aClass
    "Creates a mock class of given class"
    | mockClass |

    mockClass := self createMockClassOf: aClass mockNumber: MockCount.

    MockCount := MockCount + 1.
    mockedClasses add: mockClass.

    ^ mockClass

    "Created: / 15-06-2014 / 23:41:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 22-09-2014 / 23:11:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

mockOf: aClass
    "Creates a mock class instance of given class"

    ^ (self mockClassOf: aClass) new

    "Created: / 15-06-2014 / 23:44:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMock methodsFor:'mock release'!

unmockAll

    Class withoutUpdatingChangesDo:[
        mockedClasses do: [ :class |
            class removeFromSystem
        ].

        mockedClasses removeAll
    ]

    "Created: / 15-06-2014 / 19:30:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 24-09-2014 / 21:47:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMock class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


CustomMock initialize!
