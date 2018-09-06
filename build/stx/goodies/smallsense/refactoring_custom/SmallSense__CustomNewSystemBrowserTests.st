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

Smalltalk::TestCase subclass:#CustomNewSystemBrowserTests
	instanceVariableNames:'browser mock menu manager generatorClassMock'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-UI-Tests'
!

!CustomNewSystemBrowserTests class methodsFor:'documentation'!

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

!CustomNewSystemBrowserTests methodsFor:'initialization & release'!

setUp
    super setUp.

    mock := CustomMock new.
    menu := Menu labels: 'label' values: nil.
    browser := (mock mockOf: Tools::NewSystemBrowser).
    mock createMockGetters: browser class forSelectors: {
        'information'. 'theSingleSelectedClass'. 'switchToClass'. 'selectProtocol'
    }.
    browser
        compileMockMethod: 'information: aString
            self objectAttributeAt: #information put: aString';
        compileMockMethod: 'theSingleSelectedClass: aClass
            self objectAttributeAt: #theSingleSelectedClass put: aClass';
        compileMockMethod: 'createBuffer ^ true';
        compileMockMethod: 'switchToClass: aClass
            self objectAttributeAt: #switchToClass put: aClass';
        compileMockMethod: 'selectProtocol: aProtocol
            self objectAttributeAt: #selectProtocol put: aProtocol';
        compileMockMethod: 'customMenuBuilder
            | builder |

            builder := super customMenuBuilder.
            builder manager: (self objectAttributeAt: #manager).
            ^ builder'.

    manager := mock mockOf: Object.
    manager compileMockMethod: 'generatorsAndRefactoringsSelect: aBlock
        ^ self objectAttributeAt: #codeGenerators';
        objectAttributeAt: #codeGenerators put: OrderedCollection new.  

    browser objectAttributeAt: #manager put: manager.

    generatorClassMock := mock mockClassOf: Object.
    mock createMockGetters: generatorClassMock forSelectors: {'label'. 'group'}.

    "Modified: / 24-01-2015 / 20:08:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    mock unmockAll.
    
    super tearDown.

    "Modified: / 26-12-2014 / 19:17:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNewSystemBrowserTests methodsFor:'private'!

addGenerator: aLabel group: aGroup
    "Creates initialized code generator mock and adds it to managers generators"
    | generator |

    generator := generatorClassMock new
        objectAttributeAt: #label put: aLabel;
        objectAttributeAt: #group put: aGroup;
        yourself.

    (manager objectAttributeAt: #codeGenerators) add: generator.

    ^ generator

    "Created: / 29-12-2014 / 08:51:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

menuItemLabels
    "Helper which returns labels from menu item as collection as string.
    We are comparing labels, because menu items are not comparable - 
    MenuItem label: 'Label' not equals MenuItem label: 'Label'"

    ^ (OrderedCollection streamContents: [ :stream |
        menu itemsDo: [ :item |
            stream nextPut: item label.
            item submenuChannel notNil ifTrue: [ 
                stream nextPut: (OrderedCollection streamContents: [ :innerStream |
                    item submenuChannel value itemsDo: [ :innerItem |
                        innerStream nextPut: innerItem label
                    ]
                ]) asArray
            ]
        ]
    ]) asArray

    "Created: / 29-12-2014 / 08:52:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNewSystemBrowserTests methodsFor:'tests'!

test_class_menu_extension_custom_generators
    | expectedMenu actualMenu |

    menu := Menu labels: 'Generate
label' values: nil.

    expectedMenu := {'Generate'. 'Generate - Custom'. {'Generator_01'. '-'. 'Generator_02'}. 'label'}.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #(Group).

    browser classMenuExtensionCustomGenerators: menu.
    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Created: / 29-12-2014 / 08:56:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_menu_extension_custom_refactorings
    | expectedMenu actualMenu |

    menu := Menu labels: 'Generate
label' values: nil.

    expectedMenu := {'Generate'. 'Refactor - Custom'. {'Generator_01'. '-'. 'Generator_02'}. 'label'}.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #(Group).

    browser classMenuExtensionCustomRefactorings: menu.
    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Created: / 29-12-2014 / 09:10:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_menu_extension_navigate_to_test_case_custom_extensions
    | expectedClass actualClass |

    expectedClass := CustomRBMethodTests.
    browser theSingleSelectedClass: RBMethod.
    browser classMenuExtensionNavigateToTestCase: menu.
    menu lastItem itemValue value. "Call menu item action block"
    actualClass := browser switchToClass.   

    self assert: expectedClass = actualClass.
    self assert: (browser selectProtocol) == #tests

    "Created: / 26-12-2014 / 18:58:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 24-01-2015 / 19:53:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_menu_extension_navigate_to_test_case_found
    | expectedClass actualClass |

    expectedClass := CustomContextTests.
    browser theSingleSelectedClass: CustomContext.
    browser classMenuExtensionNavigateToTestCase: menu.
    menu lastItem itemValue value. "Call menu item action block"
    actualClass := browser switchToClass.

    self assert: expectedClass = actualClass.
    self assert: (browser selectProtocol) == #tests

    "Created: / 26-12-2014 / 18:53:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_class_menu_extension_navigate_to_test_case_not_found
    | expectedInformation actualInformation |

    expectedInformation := 'Test Case named SmallSense::CustomNewSystemBrowserTestsTests not found'.
    browser theSingleSelectedClass: CustomNewSystemBrowserTests.
    browser classMenuExtensionNavigateToTestCase: menu.
    menu lastItem itemValue value. "Call menu item action block"
    actualInformation := browser information.

    self assert: expectedInformation = actualInformation

    "Created: / 26-12-2014 / 18:32:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 21:00:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_class_menu_extension_navigate_to_test_case_placed_after_generate
    | expectedPosition actualPosition foundItem |

    expectedPosition := 3.

    menu := Menu labels: 'Label_01
Generate
Label_02' values: nil.

    browser classMenuExtensionNavigateToTestCase: menu.
    actualPosition := 0.
    foundItem := false.
    menu itemsDo: [ :item |  
        foundItem ifFalse: [
            actualPosition := actualPosition + 1.
            foundItem := (item label = 'Open Test Case Class').
        ]
    ].

    self assert: expectedPosition = actualPosition

    "Created: / 26-12-2014 / 19:01:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_code_view_menu_extension_custom_refactorings
    | expectedMenu actualMenu |

    menu := Menu labels: 'Refactor
label' values: nil.

    expectedMenu := {'Refactor'. 'Refactor - Custom'. {'Generator_01'. '-'. 'Generator_02'}. 'label'}.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #(Group).

    browser codeViewMenuExtensionCustomRefactorings: menu.
    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Created: / 29-12-2014 / 09:16:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selector_menu_extension_custom_generators
    | expectedMenu actualMenu |

    menu := Menu labels: 'Generate
label' values: nil.

    expectedMenu := {'Generate'. 'Generate - Custom'. {'Generator_01'. '-'. 'Generator_02'}. 'label'}.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #(Group).

    browser selectorMenuExtensionCustomGenerators: menu.
    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Created: / 29-12-2014 / 09:18:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selector_menu_extension_custom_refactorings
    | expectedMenu actualMenu |

    menu := Menu labels: 'Refactor
label' values: nil.

    expectedMenu := {'Refactor'. 'Refactor - Custom'. {'Generator_01'. '-'. 'Generator_02'}. 'label'}.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #(Group).

    browser selectorMenuExtensionCustomRefactorings: menu.
    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Created: / 29-12-2014 / 09:26:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_variables_menu_extension_custom_generators
    | expectedMenu actualMenu |

    menu := Menu labels: 'Generate
label' values: nil.

    expectedMenu := {'Generate'. 'Generate - Custom'. {'Generator_01'. '-'. 'Generator_02'}. 'label'}.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #(Group).

    browser variablesMenuExtensionCustomGenerators: menu.
    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Created: / 29-12-2014 / 09:31:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNewSystemBrowserTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

