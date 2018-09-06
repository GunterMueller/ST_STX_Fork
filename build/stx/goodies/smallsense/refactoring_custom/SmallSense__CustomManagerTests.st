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

Smalltalk::TestCase subclass:#CustomManagerTests
	instanceVariableNames:'mock provider manager generatorClassMock'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomManagerTests class methodsFor:'documentation'!

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

!CustomManagerTests methodsFor:'initialization & release'!

setUp
    super setUp.

    mock := CustomMock new.
    provider := mock mockOf: OrderedCollection.
    provider compileMockMethod: 'generatorsAndRefactoringsDo: aBlock
        self do: aBlock'.

    manager := CustomManager new.
    manager generatorsOrRefactoringsProvider: provider.

    generatorClassMock := mock mockClassOf: Object.
    mock createMockGetters: generatorClassMock forSelectors:
        {'label'. 'isAbstract'. 'availableInContext:'. 'availableInPerspective:'}.

    "Modified: / 28-12-2014 / 15:34:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    mock unmockAll.
    
    super tearDown.

    "Modified: / 28-12-2014 / 13:15:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomManagerTests methodsFor:'private'!

addGenerator: aLabel
    "Creates initialized code generator mock and adds it to managers generators"
    | generator |

    generator := generatorClassMock new
        objectAttributeAt: #isAbstract put: false;
        objectAttributeAt: #label put: aLabel;
        objectAttributeAt: #availableInContext: put: true;
        objectAttributeAt: #availableInPerspective: put: true;
        yourself.

    manager generatorsOrRefactoringsProvider add: generator.

    ^ generator

    "Created: / 28-12-2014 / 14:12:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 15:36:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

collectionOfLabels: aCollection
    "Returns collection of labels from given collection"

    ^ OrderedCollection streamContents: [ :stream |
        aCollection do: [ :each | 
            stream nextPut: each label
        ]
    ]

    "Created: / 28-12-2014 / 14:23:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomManagerTests methodsFor:'tests'!

test_current
    
    self assert: manager class current notNil

    "Modified: / 28-12-2014 / 13:17:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings
    | expectedGenerators actualGenerators |

    expectedGenerators := OrderedCollection with: 'Generator_01' with: 'Generator_02'.

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    actualGenerators := self collectionOfLabels: manager generatorsAndRefactorings.

    self assert: expectedGenerators = actualGenerators

    "Modified: / 28-12-2014 / 14:23:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_do
    | expectedGenerators actualGenerators |

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    expectedGenerators := OrderedCollection with: provider first 
                            with: provider last.

    actualGenerators := OrderedCollection streamContents: [ :stream |
        manager generatorsAndRefactoringsDo: [ :generator |  
            stream nextPut: generator
        ].
    ].                 

    self assert: expectedGenerators = actualGenerators

    "Modified: / 28-12-2014 / 18:04:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_for_context
    | expectedGenerators actualGenerators |

    expectedGenerators := OrderedCollection with: 'Generator_02'.

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    provider first objectAttributeAt: #availableInContext: put: false.    

    actualGenerators := self collectionOfLabels: (manager 
                            generatorsAndRefactoringsForContext: nil).

    self assert: expectedGenerators = actualGenerators

    "Modified: / 28-12-2014 / 15:38:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_for_context_do
    | expectedGenerators actualGenerators |

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    expectedGenerators := OrderedCollection with: provider first. 
    provider last objectAttributeAt: #availableInContext: put: false.

    actualGenerators := OrderedCollection streamContents: [ :stream |
        manager generatorsAndRefactoringsForContext: nil do: [ :generator |  
            stream nextPut: generator
        ].
    ].                 

    self assert: expectedGenerators = actualGenerators

    "Modified: / 28-12-2014 / 18:08:01 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_for_perspective    
    | expectedGenerators actualGenerators |

    expectedGenerators := OrderedCollection with: 'Generator_01'.

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    provider second objectAttributeAt: #availableInPerspective: put: false.    

    actualGenerators := self collectionOfLabels: (manager 
                            generatorsAndRefactoringsForPerspective: nil).

    self assert: expectedGenerators = actualGenerators

    "Modified: / 28-12-2014 / 17:07:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_for_perspective_do
    | expectedGenerators actualGenerators |

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    expectedGenerators := OrderedCollection with: provider first. 
    provider last objectAttributeAt: #availableInPerspective: put: false.

    actualGenerators := OrderedCollection streamContents: [ :stream |
        manager generatorsAndRefactoringsForPerspective: nil do: [ :generator |  
            stream nextPut: generator
        ].
    ].                 

    self assert: expectedGenerators = actualGenerators

    "Modified: / 28-12-2014 / 18:08:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_select_01    
    | expectedGenerators actualGenerators |

    expectedGenerators := OrderedCollection with: 'Generator_01'.

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    provider second objectAttributeAt: #availableInPerspective: put: false.    

    actualGenerators := self collectionOfLabels: (manager 
                            generatorsAndRefactoringsSelect: [ :generator | 
                                generator availableInPerspective: nil
                            ]).

    self assert: expectedGenerators = actualGenerators

    "Modified (comment): / 28-12-2014 / 17:54:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_select_02    
    | expectedGenerators actualGenerators |

    expectedGenerators := OrderedCollection new.

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    provider second objectAttributeAt: #availableInPerspective: put: false.    

    actualGenerators := self collectionOfLabels: (manager 
                            generatorsAndRefactoringsSelect: [ :generator | 
                                false
                            ]).

    self assert: expectedGenerators = actualGenerators

    "Created: / 28-12-2014 / 17:55:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_generators_and_refactorings_select_03    
    | expectedGenerators actualGenerators |

    expectedGenerators := OrderedCollection with: 'Generator_01' with: 'Generator_02'.

    self addGenerator: 'Generator_01';
        addGenerator: 'Generator_02'.

    provider second objectAttributeAt: #availableInPerspective: put: false.    

    actualGenerators := self collectionOfLabels: (manager 
                            generatorsAndRefactoringsSelect: [ :generator | 
                                true
                            ]).

    self assert: expectedGenerators = actualGenerators

    "Created: / 28-12-2014 / 17:55:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomManagerTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

