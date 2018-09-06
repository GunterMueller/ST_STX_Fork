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

Smalltalk::TestCase subclass:#CustomMenuBuilderTests
	instanceVariableNames:'builder menu provider manager mock generatorClassMock resources'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-UI-Tests'
!

!CustomMenuBuilderTests class methodsFor:'documentation'!

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

!CustomMenuBuilderTests methodsFor:'initialization & release'!

setUp
    super setUp.

    menu := Menu labels: 'Label_01
Label_02
Label_03' values: nil.

    mock := CustomMock new.

    provider := mock mockOf: OrderedCollection.
    provider compileMockMethod: 'generatorsAndRefactoringsDo: aBlock
        self do: aBlock'.  

    manager := CustomManager new.
    manager generatorsOrRefactoringsProvider: provider.

    builder := CustomMenuBuilder new.
    builder manager: manager.

    generatorClassMock := mock mockClassOf: Object.
    mock createMockGetters: generatorClassMock forSelectors: {
        'label'. 'group'. 'name'. 'isAbstract'. 'availableInContext:'. 
        'availableInPerspective:'. 'availableForProgrammingLanguagesInContext:'
    }.

    resources := mock mockOf: Object.
    resources compileMockMethod: 'string:aString ^ ''Translated '', aString'.

    "Modified: / 01-02-2015 / 20:00:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    mock unmockAll.
    
    super tearDown.

    "Modified: / 28-12-2014 / 22:02:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMenuBuilderTests methodsFor:'private'!

addGenerator: aLabel group: aGroup
    "Creates initialized code generator mock and adds it to managers generators"
    | generator |

    generator := generatorClassMock new
        objectAttributeAt: #isAbstract put: false;
        objectAttributeAt: #label put: aLabel;
        objectAttributeAt: #name put: 'Unknown class name';
        objectAttributeAt: #group put: aGroup;
        objectAttributeAt: #availableInContext: put: true;
        objectAttributeAt: #availableInPerspective: put: true;
        objectAttributeAt: #availableForProgrammingLanguagesInContext: put: true;
        yourself.

    manager generatorsOrRefactoringsProvider add: generator.

    ^ generator

    "Created: / 28-12-2014 / 22:10:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 01-02-2015 / 20:01:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
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

    "Created: / 28-12-2014 / 10:41:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 23:17:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMenuBuilderTests methodsFor:'tests'!

test_build_menu_empty
    | expectedMenu actualMenu |

    expectedMenu := {'Label_01'. 'Label_02'. 'Label_03'}.

    builder
        perspective: CustomPerspective classPerspective;
        menu: menu;
        submenuLabel: 'SomeLabel';
        buildMenu.    

    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Modified: / 28-12-2014 / 22:41:37 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_menu_for_context_filter
    | expectedMenu actualMenu |

    (self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #(Group_02);
        addGenerator: 'Generator_03' group: #();
        addGenerator: 'Generator_04' group: #(Group_01);
        addGenerator: 'Generator_05' group: #(Group_01 Subgroup_01);
        addGenerator: 'Generator_06' group: #(Group_01);
        addGenerator: 'Generator_07' group: #(Group_01 Subgroup_01))
            objectAttributeAt: #availableInContext: put: false. "To have at least one generator not avilable for context"

    "Not present generators"
    (self addGenerator: 'Generator_08' group: #())
        objectAttributeAt: #availableForProgrammingLanguagesInContext: put: false.
    (self addGenerator: 'Generator_09' group: #())
        objectAttributeAt: #availableInPerspective: put: false.
    self addGenerator: 'Generator_10' group: #().

    menu := builder buildMenuForContext: CustomSubContext new filter: [ :generator |
        generator label ~= 'Generator_10'
    ].

    expectedMenu := {
        'Generator_01'.
        'Generator_03'.
        '-'.
        'Generator_04'.
        'Generator_06'.
        '-'.
        'Generator_02'.
        '-'.
        'Generator_05'.
        'Generator_07'.
    }.

    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Modified (comment): / 28-12-2014 / 22:35:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_menu_two_generators
    | expectedMenu actualMenu navigationState |

    expectedMenu := {
        'Label_01'.
        'Label_02'. 
        'Translated BunchOfGenerators'. 
        {'Translated Generator_01'. 'Translated Generator_03'}.
        'Label_03'.
    }.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #();
        addGenerator: 'Generator_03' group: #().

    "Create some methods which actually uses context and perspective to be sure that they are correctly created"
    provider last
        compileMockMethod: 'availableInPerspective: perspective ^ perspective isClassPerspective';
        compileMockMethod: 'availableInContext: context ^ context selectedClasses first name == CustomMenuBuilderTests name'.

    navigationState := Tools::NavigationState new.
    navigationState selectedClasses value: {CustomMenuBuilderTests}.

    builder
        perspective: CustomPerspective classPerspective;
        menu: menu;
        submenuLabel: 'BunchOfGenerators';
        afterMenuItemLabelled: 'Label_02';
        generatorOrRefactoringFilter: [ :generatorOrRefactoring | generatorOrRefactoring label ~= 'Generator_02' ];
        navigationState: navigationState;
        resources: resources;
        buildMenu.    

    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu.

    (menu menuItemAt: 3) submenuChannel value itemsDo: [ :item | 
        self assert: item enabled value
    ].

    "Created: / 28-12-2014 / 22:48:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:08:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 21:09:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_build_menu_two_generators_empty_builder

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #();
        addGenerator: 'Generator_03' group: #().

    "Create some methods which actually uses context and perspective to be sure that they are correctly created"
    provider last
        compileMockMethod: 'availableInPerspective: perspective ^ perspective isClassPerspective';
        compileMockMethod: 'availableInContext: context ^ context selectedClasses first name == #CustomMenuBuilderTests'.

    self should: [
        builder buildMenu
    ] raise: Error suchThat: [ :error |
        (error description) = 'Attributes named menu and perspective are required.'
    ].

    "Created: / 04-01-2015 / 15:31:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_menu_two_generators_empty_label
    | expectedMenu actualMenu navigationState |

    expectedMenu := {
        'Label_01'.
        'Label_02'. 
        'Label_03'.
        'Unknown menu label'.
        {'Generator_01'. 'Generator_02'. 'Generator_03'}
    }.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #();
        addGenerator: 'Generator_03' group: #().

    "Create some methods which actually uses context and perspective to be sure that they are correctly created"
    provider last
        compileMockMethod: 'availableInPerspective: perspective ^ perspective isClassPerspective';
        compileMockMethod: 'availableInContext: context ^ context selectedClasses first name == #CustomMenuBuilderTests'.

    navigationState := Tools::NavigationState new.
    navigationState selectedClasses value: {CustomMenuBuilderTests}.

    builder
        perspective: CustomPerspective classPerspective;
        menu: menu;
        buildMenu.    

    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu

    "Created: / 04-01-2015 / 15:44:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_menu_two_generators_with_nil_label
    | expectedMenu actualMenu printer expectedError actualError |

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #().

    provider last objectAttributeAt: #label put: nil.  

    printer := mock mockOf: Object.
    printer compileMockMethod: 'showCR: message 
        (self objectAttributeAt: #showCR:) add: message';
        objectAttributeAt: #showCR: put: OrderedCollection new.

    builder
        perspective: CustomPerspective classPerspective;
        menu: menu;
        submenuLabel: 'BunchOfGenerators';
        errorPrinter: printer;
        buildMenu.

    expectedError := OrderedCollection new.

    actualError := printer objectAttributeAt: #showCR:.
    self assert: expectedError = actualError.

    expectedMenu := {
        'Label_01'.
        'Label_02'.
        'Label_03'.
        'BunchOfGenerators'. 
        {'Generator_01'}.
    }.

    actualMenu := self menuItemLabels.
    self assert: expectedMenu = actualMenu.

    "Created: / 01-02-2015 / 20:25:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_menu_two_generators_with_should_implement_error
    | expectedMenu actualMenu printer expectedError actualError |

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #().

    provider last compileMockMethod: 'availableInPerspective: perspective 
        self label = ''Generator_02'' ifTrue: [
            self shouldImplement
        ].
        ^ true'.  

    printer := mock mockOf: Object.
    printer compileMockMethod: 'showCR: message 
        (self objectAttributeAt: #showCR:) add: message';
        objectAttributeAt: #showCR: put: OrderedCollection new.

    builder
        perspective: CustomPerspective classPerspective;
        menu: menu;
        submenuLabel: 'BunchOfGenerators';
        errorPrinter: printer;
        buildMenu.

    expectedError := OrderedCollection 
        with: 'An error occured when selecting code generators/refactorings.'
        with: 'Class: Unknown class name Error: functionality has to be implemented: a ', provider last className, '>>availableInPerspective:'.

    actualError := printer objectAttributeAt: #showCR:.
    self assert: expectedError = actualError.

    expectedMenu := {
        'Label_01'.
        'Label_02'.
        'Label_03'.
        'BunchOfGenerators'. 
        {'Generator_01'}.
    }.

    actualMenu := self menuItemLabels.
    self assert: expectedMenu = actualMenu.

    "Created: / 01-02-2015 / 20:19:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_menu_two_generators_with_subclass_responsibility_error
    | expectedMenu actualMenu printer expectedError actualError |

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #().

    provider last compileMockMethod: 'availableInPerspective: perspective 
        self label = ''Generator_02'' ifTrue: [
            self subclassResponsibility
        ].
        ^ true'.  

    printer := mock mockOf: Object.
    printer compileMockMethod: 'showCR: message 
        (self objectAttributeAt: #showCR:) add: message';
        objectAttributeAt: #showCR: put: OrderedCollection new.

    builder
        perspective: CustomPerspective classPerspective;
        menu: menu;
        submenuLabel: 'BunchOfGenerators';
        errorPrinter: printer;
        buildMenu.

    expectedError := OrderedCollection 
        with: 'An error occured when selecting code generators/refactorings.'
        with: 'Class: Unknown class name Error: "availableInPerspective:" method must be reimplemented in subclass'.

    actualError := printer objectAttributeAt: #showCR:.
    self assert: expectedError = actualError.

    expectedMenu := {
        'Label_01'.
        'Label_02'.
        'Label_03'.
        'BunchOfGenerators'. 
        {'Generator_01'}.
    }.

    actualMenu := self menuItemLabels.
    self assert: expectedMenu = actualMenu.

    "Created: / 01-02-2015 / 19:17:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 01-02-2015 / 20:17:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_build_menu_two_generators_without_filter
    | expectedMenu actualMenu navigationState |

    expectedMenu := {
        'Label_01'.
        'Label_02'. 
        'Translated BunchOfGenerators'. 
        {'Translated Generator_01'. 'Translated Generator_02'. 'Translated Generator_03'}.
        'Label_03'.
    }.

    self
        addGenerator: 'Generator_01' group: #();
        addGenerator: 'Generator_02' group: #();
        addGenerator: 'Generator_03' group: #().

    "Create some methods which actually uses context and perspective to be sure that they are correctly created"
    provider last
        compileMockMethod: 'availableInPerspective: perspective ^ perspective isClassPerspective';
        compileMockMethod: 'availableInContext: context ^ context selectedClasses first name == CustomMenuBuilderTests name'.

    navigationState := Tools::NavigationState new.
    navigationState selectedClasses value: {CustomMenuBuilderTests}.

    builder
        perspective: CustomPerspective classPerspective;
        menu: menu;
        submenuLabel: 'BunchOfGenerators';
        afterMenuItemLabelled: 'Label_02';
        navigationState: navigationState;
        resources: resources;
        buildMenu.    

    actualMenu := self menuItemLabels.

    self assert: expectedMenu = actualMenu.

    (menu menuItemAt: 3) submenuChannel value itemsDo: [ :item | 
        self assert: item enabled value
    ].

    "Created: / 29-12-2014 / 09:33:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-01-2015 / 15:08:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 21:09:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_groups_sort_block
    | expectedGroups actualGroups |

    actualGroups := {
        #(Group_09 Subgroup_02 Subsubgroup_02).
        #(Group_09 Subgroup_01 Subsubgroup_02).
        #(Group_09 Subgroup_01 Subsubgroup_01).
        #(Group_01).
        #(Group_09 Subgroup_01).
        #(Group_01 Subgroup_01).
        #(Group_03).
        #(Group_02 Subgroup_02).
        #(Group_02 Subgroup_01).
        #(Group_10).
        #(Group_09 Subgroup_01 Subsubgroup_02 Subsubsubgroup_01).
        #().
    }.

    "Maybe better order?"
    "
    expectedGroups := {
        #().
        #(Group_01).
        #(Group_01 Subgroup_01).
        #(Group_02 Subgroup_01).
        #(Group_02 Subgroup_02).
        #(Group_03).
        #(Group_09 Subgroup_01).
        #(Group_09 Subgroup_01 Subsubgroup_01).
        #(Group_09 Subgroup_01 Subsubgroup_02).
        #(Group_09 Subgroup_01 Subsubgroup_02 Subsubsubgroup_01).
        #(Group_09 Subgroup_02 Subsubgroup_02).
        #(Group_10)
    }. "

    expectedGroups := {
        #().
        #(Group_01).
        #(Group_03).
        #(Group_10).
        #(Group_01 Subgroup_01).
        #(Group_02 Subgroup_01).
        #(Group_02 Subgroup_02).
        #(Group_09 Subgroup_01).
        #(Group_09 Subgroup_01 Subsubgroup_01).
        #(Group_09 Subgroup_01 Subsubgroup_02).
        #(Group_09 Subgroup_02 Subsubgroup_02).
        #(Group_09 Subgroup_01 Subsubgroup_02 Subsubsubgroup_01).
    }.

    actualGroups sort: builder groupsSortBlock.    
    
    self assert: expectedGroups = actualGroups

    "Modified (format): / 28-12-2014 / 21:54:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_place_menu_item_after_menu_item_labeled_for_menu_item_empty
    | menuItem expectedMenuItemLabels actualMenuItemLabels |

    menuItem := MenuItem label: 'SomeLabel'.

    expectedMenuItemLabels := {'Label_01'. 'Label_02'. 'Label_03'. 'SomeLabel'}.

    builder placeMenuItem: menuItem afterMenuItemLabeled: nil forMenu: menu.

    actualMenuItemLabels := self menuItemLabels.

    self assert: expectedMenuItemLabels = actualMenuItemLabels

    "Created: / 04-01-2015 / 15:41:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_place_menu_item_after_menu_item_labeled_for_menu_item_found
    | menuItem expectedMenuItemLabels actualMenuItemLabels |

    menuItem := MenuItem label: 'SomeLabel'.

    expectedMenuItemLabels := {'Label_01'. 'Label_02'. 'SomeLabel'. 'Label_03'}.

    builder placeMenuItem: menuItem afterMenuItemLabeled: 'Label_02' forMenu: menu.

    actualMenuItemLabels := self menuItemLabels.

    self assert: expectedMenuItemLabels = actualMenuItemLabels

    "Modified: / 28-12-2014 / 10:41:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_place_menu_item_after_menu_item_labeled_for_menu_item_not_found
    | menuItem expectedMenuItemLabels actualMenuItemLabels |

    menuItem := MenuItem label: 'SomeLabel'.

    expectedMenuItemLabels := {'Label_01'. 'Label_02'. 'Label_03'. 'SomeLabel'}.

    builder placeMenuItem: menuItem afterMenuItemLabeled: 'NotExistingLabel' forMenu: menu.

    actualMenuItemLabels := self menuItemLabels.

    self assert: expectedMenuItemLabels = actualMenuItemLabels

    "Created: / 28-12-2014 / 10:45:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomMenuBuilderTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

