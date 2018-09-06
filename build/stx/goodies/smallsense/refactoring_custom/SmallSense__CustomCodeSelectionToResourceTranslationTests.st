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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomCodeSelectionToResourceTranslationTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Refactorings-Tests'
!

!CustomCodeSelectionToResourceTranslationTests class methodsFor:'documentation'!

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

!CustomCodeSelectionToResourceTranslationTests methodsFor:'accessing'!

generatorOrRefactoring
    ^ CustomCodeSelectionToResourceTranslation new
! !

!CustomCodeSelectionToResourceTranslationTests methodsFor:'tests'!

test_available_in_code_view_perspective
    | perspective |

    perspective := CustomPerspective codeViewPerspective.

    self assert: (generatorOrRefactoring class availableInPerspective:perspective).

    "Created: / 15-10-2014 / 08:10:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_empty
    
    self deny: (generatorOrRefactoring class availableInContext: context).

    "Modified: / 15-10-2014 / 09:32:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_empty_selected_codes

    context selectedCodes: (Array
        with: CustomSourceCodeSelection new  
    ).

    self deny: (generatorOrRefactoring class availableInContext: context).

    "Created: / 15-10-2014 / 09:37:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 22:53:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_context_with_selected_codes

    context selectedCodes: (Array
        with: (CustomSourceCodeSelection new
            selectedInterval: (1 to: 5);
            currentSourceCode: 'selector_05 ^ 5';
            yourself)
    ).

    self assert: (generatorOrRefactoring class availableInContext: context).

    "Created: / 15-10-2014 / 09:41:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_code_selection_replaced_by_resource_translation_01
    | expectedSource originalSource codeSelection class |

    originalSource := 'selector
    self information: ''Translate this''.
    ^ self.'.

    class := model createClassImmediate: 'DummyClassForTestCase01' instanceVariableNames: 'resources'.
    model createMethodImmediate: class source: originalSource.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: originalSource;
        selectedClass: class;
        selectedInterval: (32 to: 48);
        selectedMethod: (class compiledMethodAt: #selector);
        selectedSelector: #selector.

    context selectedCodes: (Array with: codeSelection).  
    generatorOrRefactoring executeInContext: context.  

    expectedSource := 'selector
    self information: (resources string:''Translate this'').
    ^ self.'.

    self assertMethodSource:expectedSource atSelector:#selector forClass:class

    "Created: / 23-08-2014 / 20:09:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 20:14:32 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_code_selection_replaced_by_resource_translation_02
    | expectedSource originalSource codeSelection class |

    originalSource := 'selector
    self information: self theInformation.
    ^ self.'.

    class := model createClassImmediate: 'DummyClassForTestCase01' instanceVariableNames: 'resources'.
    model createMethodImmediate: class source: originalSource.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: originalSource;
        selectedClass: class;
        selectedInterval: (32 to: 51);
        selectedMethod: (class compiledMethodAt: #selector);
        selectedSelector: #selector.

    context selectedCodes: (Array with: codeSelection).  
    generatorOrRefactoring executeInContext: context.  

    expectedSource := 'selector
    self information: (resources string:self theInformation).
    ^ self.'.

    self assertMethodSource:expectedSource atSelector:#selector forClass:class

    "Created: / 15-10-2014 / 09:45:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 20:14:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_code_selection_replaced_by_resource_translation_with_keep_package
    | expectedSource originalSource codeSelection class method compiledMethod |

    originalSource := 'selector
    self information: self theInformation.
    ^ self.'.

    class := model createClassImmediate: 'DummyClassForTestCase01' instanceVariableNames: 'resources'.
    method := model createMethodImmediate: class source: originalSource.
    method package: #some_package.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: originalSource;
        selectedClass: class;
        selectedInterval: (32 to: 51);
        selectedMethod: (class compiledMethodAt: #selector);
        selectedSelector: #selector.

    context selectedCodes: (Array with: codeSelection).  
    generatorOrRefactoring executeInContext: context.  

    expectedSource := 'selector
    self information: (resources string:self theInformation).
    ^ self.'.

    self assertMethodSource:expectedSource atSelector:#selector forClass:class.

    compiledMethod := class compiledMethodAt: #selector.

    self assert: #some_package = (compiledMethod package).

    "Created: / 16-10-2014 / 21:46:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 20:14:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_code_selection_replaced_by_resource_translation_with_wrong_selection
    | expectedSource originalSource codeSelection class |

    originalSource := 'method: arg

    arg ifNil: [ 
        self warn: ''nil''.
    ]
    ifNotNil: [ self information: ''info'' ]'.

    class := model createClassImmediate: 'DummyClassForTestCase01' instanceVariableNames: 'resources'.
    model createMethodImmediate: class source: originalSource.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: originalSource;
        selectedClass: class;
        selectedInterval: (8 to: 10);
        selectedMethod: (class compiledMethodAt: #method:);
        selectedSelector: #selector.

    context selectedCodes: (Array with: codeSelection).  
    generatorOrRefactoring executeInContext: context.  

    expectedSource := 'method: arg

    arg ifNil: [ 
        self warn: ''nil''.
    ]
    ifNotNil: [ self information: ''info'' ]'.

    self assertMethodSource:expectedSource atSelector:#method: forClass:class

    "Created: / 17-10-2014 / 22:31:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_not_available_in_class_perspective
    | perspective |

    perspective := CustomPerspective classPerspective.

    self deny: (generatorOrRefactoring class availableInPerspective:perspective).

    "Created: / 15-10-2014 / 08:11:43 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomCodeSelectionToResourceTranslationTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

