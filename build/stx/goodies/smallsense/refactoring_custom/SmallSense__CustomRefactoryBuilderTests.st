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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomRefactoryBuilderTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomRefactoryBuilderTests class methodsFor:'documentation'!

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

!CustomRefactoryBuilderTests methodsFor:'accessing'!

generatorOrRefactoring

    ^ nil

    "Created: / 24-08-2014 / 21:35:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilderTests methodsFor:'tests'!

test_available_in_perspective_class_category
    | perspective |

    perspective := CustomPerspective classCategoryPerspective.

    self assert: (refactoryBuilder classCategorySearcher class availableInPerspective:perspective)

    "Modified: / 05-11-2014 / 20:20:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective_class_searcher
    | perspective |

    perspective := CustomPerspective classPerspective.

    self assert: (refactoryBuilder classSearcher class availableInPerspective:perspective)

    "Modified: / 05-11-2014 / 20:21:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective_code_selection_searcher
    | perspective |

    perspective := CustomPerspective codeViewPerspective.

    self assert: (refactoryBuilder codeSelectionSearcher class availableInPerspective:perspective)

    "Modified: / 05-11-2014 / 20:21:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective_method_searcher
    | perspective |

    perspective := CustomPerspective methodPerspective.

    self assert: (refactoryBuilder methodSearcher class availableInPerspective:perspective)

    "Modified: / 05-11-2014 / 20:21:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective_package_searcher    
    | perspective |

    perspective := CustomPerspective packagePerspective.

    self assert: (refactoryBuilder packageSearcher class availableInPerspective:perspective)

    "Modified: / 05-11-2014 / 20:21:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_available_in_perspective_protocols
    | perspective |

    perspective := CustomPerspective protocolPerspective.
    
    self assert: (refactoryBuilder protocolSearcher class availableInPerspective:perspective)

    "Modified: / 05-11-2014 / 20:21:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_category_of_to_model_class
    | expectedCategory actualCategory class |

    class := model createClass
        name: #DummyClassForTestCase01; 
        category: 'Category01';
        compile;
        yourself.

    expectedCategory := 'Category02'.

    refactoryBuilder changeCategoryOf: class to: 'Category02'.    

    actualCategory := class category.
    
    self assert: expectedCategory = actualCategory

    "Created: / 08-11-2014 / 13:46:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_category_of_to_model_class_execute
    | expectedCategory actualCategory class |

    class := model createClass
        name: #DummyClassForTestCase01; 
        category: 'Category01';
        compile;
        yourself.

    expectedCategory := 'Category02'.

    refactoryBuilder changeCategoryOf: class to: 'Category02'; execute.    

    actualCategory := (Smalltalk at: #DummyClassForTestCase01) category.
    
    self assert: expectedCategory = actualCategory

    "Created: / 08-11-2014 / 14:10:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 17:43:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_change_category_of_to_real_class
    | expectedCategory actualCategory class |

    class := model createClassImmediate: #DummyClassForTestCase01 category: 'Category01'.

    expectedCategory := 'Category02'.

    refactoryBuilder changeCategoryOf: class to: 'Category02'; execute.    

    actualCategory := class category.
    
    self assert: expectedCategory = actualCategory

    "Modified: / 08-11-2014 / 13:45:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_replace_with_in_code_selection_01
    
    |originalSource expectedSource actualSource codeSelection|

    originalSource := 'selector
    self information: ''Translate this''.
    ^ self.'.

    expectedSource := 'selector
    self information: (resources string:''Translate this'').
    ^ self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: originalSource;
        selectedInterval: (32 to: 47);
        selectedMethod: (self class compiledMethodAt: #generatorOrRefactoring). "/ just some method

    refactoryBuilder executeReplace: '`@code' 
        with: '(resources string: `@code)'
        inCodeSelection: codeSelection.

    refactoryBuilder model changes do: [ :change |
        actualSource := change source
    ].

    self assertSource: expectedSource sameAs: actualSource.

    "Created: / 25-08-2014 / 21:53:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 09-12-2014 / 22:22:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_replace_with_in_code_selection_02
    
    |originalSource expectedSource actualSource codeSelection|

    originalSource := 'selector
    self information: ''Translate this''.
    ^ self.'.

    expectedSource := 'selector
    resources string:(self information:''Translate this'').
    ^ self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: originalSource;
        selectedInterval: (14 to: 47);
        selectedMethod: (self class compiledMethodAt: #generatorOrRefactoring). "/ just some method

    refactoryBuilder executeReplace: '`@code' 
        with: '(resources string: `@code)'
        inCodeSelection: codeSelection.

    refactoryBuilder model changes do: [ :change |
        actualSource := change source
    ].

    self assertSource: expectedSource sameAs: actualSource.

    "Created: / 26-08-2014 / 22:37:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 16-11-2014 / 17:52:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_replace_with_in_code_selection_03

    |originalSource expectedSource actualSource codeSelection|

    originalSource := 'selector
    self information: ''Translate this''.
    ^ self.'.

    expectedSource := 'selector
    self information: ''Translate this''.
    ^ resources string:self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: originalSource;
        selectedInterval: (55 to: 59);
        selectedMethod: (self class compiledMethodAt: #generatorOrRefactoring). "/ just some method

    refactoryBuilder executeReplace: '`@code' 
        with: '(resources string: `@code)'
        inCodeSelection: codeSelection.

    refactoryBuilder model changes do: [ :change |
        actualSource := change source
    ].

    self assertSource: expectedSource sameAs: actualSource.

    "Created: / 26-08-2014 / 22:41:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 20:07:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_replace_with_in_code_selection_04

    |originalSource expectedSource actualSource codeSelection|

    originalSource := 'selector
    | temp |

    temp := ''Translate this''.

    self information: temp.
    ^ self.'.

    expectedSource := 'selector
    | temp |

    temp := ''Translate this''.

    self information: (resources string:temp).
    ^ self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: originalSource;
        selectedInterval: (77 to: 81);
        selectedMethod: (self class compiledMethodAt: #generatorOrRefactoring). "/ just some method

    refactoryBuilder executeReplace: '`@code' 
        with: '(resources string: `@code)'
        inCodeSelection: codeSelection.

    refactoryBuilder model changes do: [ :change |
        actualSource := change source
    ].

    self assertSource: expectedSource sameAs: actualSource.

    "Created: / 26-08-2014 / 22:52:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 10-12-2014 / 20:08:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_initialize_change_for_add_class
    "/ something initializeChange:aChangeClass.    
    | change |

    change := refactoryBuilder initializeChange: AddClassChange.

    self assert: (change class) == AddClassChange.
    self assert: (change model) == (refactoryBuilder model)

    "Modified: / 08-11-2014 / 16:12:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_class_with_result_do_class_with_methods
    | class expectedResult actualResult |

    class := model createClassImmediate: 'DummyClassForTestCase'.
    model createMethodImmediate: class source: 'selector_01 ^ 1'.
    model createMethodImmediate: class class source: 'selector_02 ^ 2'.

    expectedResult := OrderedCollection new
        add: (class compiledMethodAt: #selector_01);
        add: (class class compiledMethodAt: #selector_02);
        yourself.

    actualResult := OrderedCollection new.

    refactoryBuilder classSearcher search: '`@something' inClass: class withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection selectedMethod
    ].

    self assert: expectedResult = actualResult.

    "Created: / 19-10-2014 / 16:56:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-11-2014 / 22:15:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_class_with_result_do_empty_class
    | class expectedResult actualResult |

    class := model createClassImmediate: 'DummyClassForTestCase'.  

    expectedResult := OrderedCollection new.
    actualResult := OrderedCollection new.

    refactoryBuilder classSearcher search: '`@something' inClass: class withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection
    ].

    self assert: expectedResult = actualResult.

    "Modified: / 04-11-2014 / 22:19:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_class_with_result_do_model_class_with_methods
    | class expectedResult actualResult |

    class := model createClass
        name: #DummyClassForTestCase;
        compile;
        yourself.
    class compile: 'selector_01 ^ 1' classified: 'some protocol'.
    class theMetaclass compile: 'selector_02 ^ 2' classified: 'some protocol'.

    expectedResult := OrderedCollection new
        add: (class compiledMethodAt: #selector_01);
        add: (class theMetaclass compiledMethodAt: #selector_02);
        yourself.

    actualResult := OrderedCollection new.

    refactoryBuilder classSearcher search: '`@something' inClass: class withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection selectedMethod
    ].

    self assert: expectedResult = actualResult.

    "Created: / 19-10-2014 / 17:24:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-11-2014 / 22:19:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_categories_different_with_class
    | category01 class01 category02 class02 modelClass expectedResult actualResult |

    category01 := 'Some-Non-Existing-Category01'.
    category02 := 'Some-Non-Existing-Category02'.

    class01 := model createClassImmediate: 'DummyClassForTestCase01' category: category01.
    model createMethodImmediate: class01 source: 'selector_01 ^ 1'.
    model createMethodImmediate: class01 class source: 'selector_02 ^ 2'.

    class02 := model createClassImmediate: 'DummyClassForTestCase02' category: category02.
    model createMethodImmediate: class02 source: 'selector_01X ^ 101'.
    model createMethodImmediate: class02 class source: 'selector_02X ^ 202'. 

    modelClass := model classFor: class01.

    expectedResult := OrderedCollection new
        add: (modelClass compiledMethodAt: #selector_01) selector;
        add: (modelClass theMetaclass compiledMethodAt: #selector_02) selector;
        yourself.

    actualResult := OrderedCollection new.

    context selectedClassCategories: (Array with: category01).  

    refactoryBuilder classCategorySearcher search: '`@something' inContext: context withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection selectedSelector
    ].

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 21:27:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_categories_empty_context
    | expectedResult actualResult |

    expectedResult := OrderedCollection new.
    actualResult := OrderedCollection new.

    refactoryBuilder classCategorySearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    self assert: expectedResult = actualResult.

    "Modified (comment): / 04-11-2014 / 20:50:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_categories_empty_with_model_classes
    | expectedResult actualResult class01 |

    class01 := model createClass
        name: #DummyClass01;
        category: 'Some-Category01';
        compile;
        compile: 'selector_01 ^ 1';
        compile: 'selector_02 ^ 2';
        yourself.

    model createClass
        name: #DummyClass02;
        category: 'Some-Category02';
        compile;
        compile: 'selector_03 ^ 3'.

    model createClass
        name: #DummyClass03;
        compile;
        compile: 'selector_04 ^ 4'.

    context selectedClassCategories: (Array with:'Some-Category01').    

    expectedResult := OrderedCollection new
        add: (class01 compiledMethodAt:#selector_01);
        add: (class01 compiledMethodAt:#selector_02);
        yourself.

    actualResult := OrderedCollection new.

    refactoryBuilder classCategorySearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedMethod    
    ].    

    self assert: expectedResult = actualResult.

    "Created: / 05-11-2014 / 21:21:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:19:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_categories_model_classes
    | expectedResult actualResult class01 class03 |

    class01 := model createClass
        name: #DummyClass01;
        category: 'Some-Category01';
        compile;
        compile: 'selector_01 ^ 1';
        compile: 'selector_02 ^ 2';
        yourself.

    model createClass
        name: #DummyClass02;
        category: 'Some-Category02';
        compile;
        compile: 'selector_03 ^ 3'.

    class03 := model createClass
        name: #DummyClass03;
        category: 'Some-Category03';
        compile;
        compile: 'selector_04 ^ 4';
        yourself.

    context selectedClassCategories: (Array with:'Some-Category01' with:'Some-Category03').    

    expectedResult := OrderedCollection new
        add: (class03 compiledMethodAt:#selector_04);
        add: (class01 compiledMethodAt:#selector_01);
        add: (class01 compiledMethodAt:#selector_02);
        yourself.

    actualResult := OrderedCollection new.

    refactoryBuilder classCategorySearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedMethod    
    ].    

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 21:03:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:15:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_categories_real_category
    | actualResult |

    actualResult := OrderedCollection new.

    context selectedClassCategories: (Array with: self class category).  

    refactoryBuilder classCategorySearcher search: '`@something' inContext: context withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection selectedSelector
    ].

    self assert: actualResult size notEmptyOrNil

    "Created: / 04-11-2014 / 21:18:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:03:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_categories_with_class
    | category class modelClass expectedResult actualResult |

    category := 'Some-Non-Existing-Category01'.
    class := model createClassImmediate: 'DummyClassForTestCase' category: category.
    model createMethodImmediate: class source: 'selector_01 ^ 1'.
    model createMethodImmediate: class class source: 'selector_02 ^ 2'.

    modelClass := model classFor: class.
    self assert: modelClass == (model classFor: class).  

    expectedResult := OrderedCollection new
        add: (modelClass compiledMethodAt: #selector_01) selector;
        add: (modelClass theMetaclass compiledMethodAt: #selector_02) selector;
        yourself.

    actualResult := OrderedCollection new.

    context selectedClassCategories: (Array with: category).  

    refactoryBuilder classCategorySearcher search: '`@something' inContext: context withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection selectedSelector
    ].

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 21:32:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_classes    
    | class01 class02 modelClass01 modelClass02 expectedResult actualResult |

    class01 := model createClassImmediate: 'DummyClassForTestCase01'.
    model createMethodImmediate: class01 source: 'selector_01 ^ 1'.
    model createMethodImmediate: class01 class source: 'selector_02 ^ 2'.

    class02 := model createClassImmediate: 'DummyClassForTestCase02'.
    model createMethodImmediate: class02 source: 'selector_01X ^ 101'.
    model createMethodImmediate: class02 class source: 'selector_02X ^ 202'. 

    modelClass01 := model classFor: class01.
    modelClass02 := model classFor: class02.

    expectedResult := OrderedCollection new
        add: (modelClass01 compiledMethodAt: #selector_01) selector;
        add: (modelClass01 theMetaclass compiledMethodAt: #selector_02) selector;
        add: (modelClass02 compiledMethodAt: #selector_01X) selector;
        add: (modelClass02 theMetaclass compiledMethodAt: #selector_02X) selector;
        yourself.

    actualResult := OrderedCollection new.

    context selectedClasses:(Array with: class01 with: class02).   

    refactoryBuilder classSearcher search:'`@something' inContext:context withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection selectedSelector
    ].

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 21:59:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_classes_empty_context    
    | expectedResult actualResult |

    actualResult := OrderedCollection new.
    expectedResult := OrderedCollection new.

    refactoryBuilder classSearcher search:'`@something' inContext:context withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection selectedSelector
    ].

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 22:06:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_empty_browser_context
    | browserContext expectedResult actualResult |

    browserContext := CustomBrowserContext
        perspective: CustomPerspective new 
        state: Tools::NavigationState new.

    expectedResult := OrderedCollection new.
    actualResult := OrderedCollection new.

    refactoryBuilder search:'`@something' inContext:browserContext withResultDo:[ :method |
        actualResult add: method selector    
    ].    
    
    self assert: expectedResult = actualResult.

    "Modified (format): / 25-10-2014 / 21:00:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_empty_code_selection
    | expectedResult actualResult |

    context selectedCodes: {CustomSourceCodeSelection new}.  

    expectedResult := OrderedCollection new.
    actualResult := OrderedCollection new.

    refactoryBuilder codeSelectionSearcher search:'`@something' inContext:context withResultDo:[ :method |
        actualResult add: method selector    
    ].    

    self assert: expectedResult = actualResult.

    "Modified: / 04-01-2015 / 16:13:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_empty_sub_context
    | expectedResult actualResult |

    expectedResult := OrderedCollection new.
    actualResult := OrderedCollection new.

    refactoryBuilder search:'`@something' inContext:context withResultDo:[ :method |
        actualResult add: method selector    
    ].    
    
    self assert: expectedResult = actualResult.

    "Created: / 25-10-2014 / 21:01:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 19:08:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_filled_browser_context_with_class_category_perspective
    | expectedResult actualResult class02 class03 method03 
    codeSelection class04 class05 method05 class06 |

    model createClass 
        name: #DummyClassForTestCase01; 
        category: 'Some-Test-Category01';
        compile;
        compile: 'selector_01 ^ 1'.

    class02 := model createClass
        name: #DummyClassForTestCase02;
        compile;
        compile: 'selector_02 ^ 2';
        yourself.

    class03 := model createClass
        name: #DummyClassForTestCase03;
        compile;
        yourself.

    method03 := model createMethod
        class: class03; 
        source: 'selector_03 ^ self';
        compile;
        yourself.

    self assert: #selector_03 = (method03 selector).

    codeSelection := CustomSourceCodeSelection new
        selectedMethod: method03;
        selectedInterval: (15 to: 18);
        yourself.

    self assert: 'self' = (codeSelection selectedSourceCode).  

    class04 := model createClass
        name: #DummyClassForTestCase04;
        compile;
        compile: 'selector_04 ^ 4' classified: 'method protocol 01';
        yourself.

    class05 := model createClass
        name: #DummyClassForTestCase05;
        compile;
        yourself.

    method05 := model createMethod
        class: class05; 
        source: 'selector_05 ^ 5';
        compile;
        yourself. 

    class06 := model createClass
        name: #DummyClassForTestCase06;
        compile;
        yourself.

    model createMethod
        class: class06; 
        source: 'selector_06 ^ 6';
        package: #some_package01;
        compile. 

    context := mock mockOf: CustomSubContext.
    context
        compileMockMethod: 'perspective ^ CustomPerspective classCategoryPerspective';
        selectedClassCategories: (Array with: 'Some-Test-Category01');
        selectedClasses: (Array with: class02 with: class04);
        selectedCodes: (Array with: codeSelection);
        selectedProtocols: (Array with: 'method protocol 01');
        selectedMethods: (Array with: method05);
        selectedPackages: (Array with: #some_package01).

    expectedResult := OrderedCollection new
        add: #selector_01;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        | selector |

        selector := sourceSelection selectedSelector.
        self assert: selector notNil.

        actualResult add: selector    
    ].    

    actualResult := actualResult asSortedCollection.
    
    self assert: expectedResult = actualResult.

    "Created: / 05-11-2014 / 22:04:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:15:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_filled_browser_context_with_class_perspective
    | expectedResult actualResult class02 class03 method03 
    codeSelection class04 class05 method05 class06 |

    model createClass 
        name: #DummyClassForTestCase01; 
        category: 'Some-Test-Category01';
        compile;
        compile: 'selector_01 ^ 1'.

    class02 := model createClass
        name: #DummyClassForTestCase02;
        compile;
        compile: 'selector_02 ^ 2';
        yourself.

    class03 := model createClass
        name: #DummyClassForTestCase03;
        compile;
        yourself.

    method03 := model createMethod
        class: class03; 
        source: 'selector_03 ^ self';
        compile;
        yourself.

    self assert: #selector_03 = (method03 selector).

    codeSelection := CustomSourceCodeSelection new
        selectedMethod: method03;
        selectedInterval: (15 to: 18);
        yourself.

    self assert: 'self' = (codeSelection selectedSourceCode).  

    class04 := model createClass
        name: #DummyClassForTestCase04;
        compile;
        compile: 'selector_04 ^ 4' classified: 'method protocol 01';
        yourself.

    class05 := model createClass
        name: #DummyClassForTestCase05;
        compile;
        yourself.

    method05 := model createMethod
        class: class05; 
        source: 'selector_05 ^ 5';
        compile;
        yourself. 

    class06 := model createClass
        name: #DummyClassForTestCase06;
        compile;
        yourself.

    model createMethod
        class: class06; 
        source: 'selector_06 ^ 6';
        package: #some_package01;
        compile. 

    context := mock mockOf: CustomSubContext.
    context
        compileMockMethod: 'perspective ^ CustomPerspective classPerspective';
        selectedClassCategories: (Array with: 'Some-Test-Category01');
        selectedClasses: (Array with: class02 with: class04);
        selectedCodes: (Array with: codeSelection);
        selectedProtocols: (Array with: 'method protocol 01');
        selectedMethods: (Array with: method05);
        selectedPackages: (Array with: #some_package01).

    expectedResult := OrderedCollection new
        add: #selector_02;
        add: #selector_04;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        | selector |

        selector := sourceSelection selectedSelector.
        self assert: selector notNil.

        actualResult add: selector    
    ].    

    actualResult := actualResult asSortedCollection.
    
    self assert: expectedResult = actualResult.

    "Created: / 05-11-2014 / 22:02:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:15:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_filled_browser_context_with_package_perspective
    | expectedResult actualResult class02 class03 method03 
    codeSelection class04 class05 method05 class06 |

    model createClass 
        name: #DummyClassForTestCase01; 
        category: 'Some-Test-Category01';
        compile;
        compile: 'selector_01 ^ 1'.

    class02 := model createClass
        name: #DummyClassForTestCase02;
        compile;
        compile: 'selector_02 ^ 2';
        yourself.

    class03 := model createClass
        name: #DummyClassForTestCase03;
        compile;
        yourself.

    method03 := model createMethod
        class: class03; 
        source: 'selector_03 ^ self';
        compile;
        yourself.

    self assert: #selector_03 = (method03 selector).

    codeSelection := CustomSourceCodeSelection new
        selectedMethod: method03;
        selectedInterval: (15 to: 18);
        yourself.

    self assert: 'self' = (codeSelection selectedSourceCode).  

    class04 := model createClass
        name: #DummyClassForTestCase04;
        compile;
        compile: 'selector_04 ^ 4' classified: 'method protocol 01';
        yourself.

    class05 := model createClass
        name: #DummyClassForTestCase05;
        compile;
        yourself.

    method05 := model createMethod
        class: class05; 
        source: 'selector_05 ^ 5';
        compile;
        yourself. 

    class06 := model createClass
        name: #DummyClassForTestCase06;
        compile;
        yourself.

    model createMethod
        class: class06; 
        source: 'selector_06 ^ 6';
        package: #some_package01;
        compile. 

    context := mock mockOf: CustomSubContext.
    context
        compileMockMethod: 'perspective ^ CustomPerspective packagePerspective';
        selectedClassCategories: (Array with: 'Some-Test-Category01');
        selectedClasses: (Array with: class02 with: class04);
        selectedCodes: (Array with: codeSelection);
        selectedProtocols: (Array with: 'method protocol 01');
        selectedMethods: (Array with: method05);
        selectedPackages: (Array with: #some_package01).

    expectedResult := OrderedCollection new
        add: #selector_06;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        | selector |

        selector := sourceSelection selectedSelector.
        self assert: selector notNil.

        actualResult add: selector    
    ].    

    actualResult := actualResult asSortedCollection.
    
    self assert: expectedResult = actualResult.

    "Created: / 05-11-2014 / 22:06:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:15:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_filled_browser_context_with_protocol_perspective
    | expectedResult actualResult class02 class03 method03 
    codeSelection class04 class05 method05 class06 |

    model createClass 
        name: #DummyClassForTestCase01; 
        category: 'Some-Test-Category01';
        compile;
        compile: 'selector_01 ^ 1'.

    class02 := model createClass
        name: #DummyClassForTestCase02;
        compile;
        compile: 'selector_02 ^ 2';
        yourself.

    class03 := model createClass
        name: #DummyClassForTestCase03;
        compile;
        yourself.

    method03 := model createMethod
        class: class03; 
        source: 'selector_03 ^ self';
        compile;
        yourself.

    self assert: #selector_03 = (method03 selector).

    codeSelection := CustomSourceCodeSelection new
        selectedMethod: method03;
        selectedInterval: (15 to: 18);
        yourself.

    self assert: 'self' = (codeSelection selectedSourceCode).  

    class04 := model createClass
        name: #DummyClassForTestCase04;
        compile;
        compile: 'selector_04 ^ 4' classified: 'method protocol 01';
        yourself.

    class05 := model createClass
        name: #DummyClassForTestCase05;
        compile;
        yourself.

    method05 := model createMethod
        class: class05; 
        source: 'selector_05 ^ 5';
        compile;
        yourself. 

    class06 := model createClass
        name: #DummyClassForTestCase06;
        compile;
        yourself.

    model createMethod
        class: class06; 
        source: 'selector_06 ^ 6';
        package: #some_package01;
        compile. 

    context := mock mockOf: CustomSubContext.
    context
        compileMockMethod: 'perspective ^ CustomPerspective protocolPerspective';
        selectedClassCategories: (Array with: 'Some-Test-Category01');
        selectedClasses: (Array with: class02 with: class04);
        selectedCodes: (Array with: codeSelection);
        selectedProtocols: (Array with: 'method protocol 01');
        selectedMethods: (Array with: method05);
        selectedPackages: (Array with: #some_package01).

    expectedResult := OrderedCollection new
        add: #selector_04;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        | selector |

        selector := sourceSelection selectedSelector.
        self assert: selector notNil.

        actualResult add: selector    
    ].    

    actualResult := actualResult asSortedCollection.
    
    self assert: expectedResult = actualResult.

    "Created: / 05-11-2014 / 22:05:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:15:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_filled_sub_context
    | expectedResult actualResult class01 class02 class03 method03 
    codeSelection class04 class05 method05 class06 |

    class01 := model createClassImmediate: #DummyClassForTestCase01 category: 'Some-Test-Category01'.
    model createMethodImmediate: class01 source: 'selector_01 ^ 1'.

    class02 := model createClassImmediate: #DummyClassForTestCase02.
    model createMethodImmediate: class02 source: 'selector_02 ^ 2'. 

    class03 := model createClassImmediate: #DummyClassForTestCase03.
    method03 := model createMethodImmediate: class03 source: 'selector_03 ^ self'.
    self assert: #selector_03 = (method03 selector).

    codeSelection := CustomSourceCodeSelection new
        selectedMethod: method03;
        selectedInterval: (15 to: 18);
        yourself.

    self assert: 'self' = (codeSelection selectedSourceCode).  

    class04 := model createClassImmediate: #DummyClassForTestCase04.
    model createMethodImmediate: class04 protocol: 'method protocol 01' source: 'selector_04 ^ 4'.

    class05 := model createClassImmediate: #DummyClassForTestCase05.
    method05 := model createMethodImmediate: class05 source: 'selector_05 ^ 5'. 

    class06 := model createClassImmediate: #DummyClassForTestCase06.
    (model createMethodImmediate: class06 source: 'selector_06 ^ 6')
        package: #some_package01. 

    context 
        selectedClassCategories: (Array with: 'Some-Test-Category01');
        selectedClasses: (Array with: class02 with: class04);
        selectedCodes: (Array with: codeSelection);
        selectedProtocols: (Array with: 'method protocol 01');
        selectedMethods: (Array with: method05);
        selectedPackages: (Array with: #some_package01).

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #selector_02;
        add: #selector_03;
        add: #selector_04;
        add: #selector_04;
        add: #selector_05;
        add: #selector_06;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        | selector |

        selector := sourceSelection selectedSelector.
        self assert: selector notNil.

        actualResult add: selector    
    ].    

    actualResult := actualResult asSortedCollection.
    
    self assert: expectedResult = actualResult.

    "Created: / 25-10-2014 / 21:05:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 21:02:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_filled_sub_context_model_classes
    | expectedResult actualResult class02 class03 method03 
    codeSelection class04 class05 method05 class06 |

    model createClass 
        name: #DummyClassForTestCase01; 
        category: 'Some-Test-Category01';
        compile;
        compile: 'selector_01 ^ 1'.

    class02 := model createClass
        name: #DummyClassForTestCase02;
        compile;
        compile: 'selector_02 ^ 2';
        yourself.

    class03 := model createClass
        name: #DummyClassForTestCase03;
        compile;
        yourself.

    method03 := model createMethod
        class: class03; 
        source: 'selector_03 ^ self';
        compile;
        yourself.

    self assert: #selector_03 = (method03 selector).

    codeSelection := CustomSourceCodeSelection new
        selectedMethod: method03;
        selectedInterval: (15 to: 18);
        yourself.

    self assert: 'self' = (codeSelection selectedSourceCode).  

    class04 := model createClass
        name: #DummyClassForTestCase04;
        compile;
        compile: 'selector_04 ^ 4' classified: 'method protocol 01';
        yourself.

    class05 := model createClass
        name: #DummyClassForTestCase05;
        compile;
        yourself.

    method05 := model createMethod
        class: class05; 
        source: 'selector_05 ^ 5';
        compile;
        yourself. 

    class06 := model createClass
        name: #DummyClassForTestCase06;
        compile;
        yourself.

    model createMethod
        class: class06; 
        source: 'selector_06 ^ 6';
        package: #some_package01;
        compile. 

    context 
        selectedClassCategories: (Array with: 'Some-Test-Category01');
        selectedClasses: (Array with: class02 with: class04);
        selectedCodes: (Array with: codeSelection);
        selectedProtocols: (Array with: 'method protocol 01');
        selectedMethods: (Array with: method05);
        selectedPackages: (Array with: #some_package01).

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #selector_02;
        add: #selector_03;
        add: #selector_04;
        add: #selector_04;
        add: #selector_05;
        add: #selector_06;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        | selector |

        selector := sourceSelection selectedSelector.
        self assert: selector notNil.

        actualResult add: selector    
    ].    

    actualResult := actualResult asSortedCollection.
    
    self assert: expectedResult = actualResult.

    "Created: / 05-11-2014 / 21:11:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 16:16:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_methods_01
    | expectedResult actualResult class01 method |
    
    class01 := model createClassImmediate: #DummyClassForTestCase01.
    method := model createMethodImmediate: class01 source: 'selector_01 ^ 1'.

    context selectedMethods:(Array with:method).

    expectedResult := OrderedCollection new
        add: #selector_01;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder methodSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 22:55:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_methods_02
    | expectedResult actualResult class01 method01 method02 |
    
    class01 := model createClassImmediate: #DummyClassForTestCase01.
    method01 := model createMethodImmediate: class01 source: 'selector_01 ^ 1'.
    method02 := self class compiledMethodAt:#test_search_in_context_with_result_do_methods_02.

    context selectedMethods:(Array with:method01 with:method02).

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #test_search_in_context_with_result_do_methods_02;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder methodSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 22:59:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_methods_03
    | expectedResult actualResult class01 method01 method02 |
    
    class01 := model createClass
        name: #DummyClassForTestCase01;
        compile;
        compile: 'selector_01 ^ 1';
        yourself.

    method01 := class01 compiledMethodAt:#selector_01.  
    method02 := model createMethod
        class: class01;
        source: 'selector_02 ^ 2';
        compile;
        yourself.

    context selectedMethods:(Array with:method01 with:method02).

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #selector_02;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder methodSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 23:05:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_methods_empty_context
    | expectedResult actualResult |

    actualResult := OrderedCollection new.
    expectedResult := OrderedCollection new.

    refactoryBuilder methodSearcher search: '`@something' inContext: context withResultDo: [ :sourceSelection |
        actualResult add: sourceSelection selectedSelector
    ].

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 22:52:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_packages_01
    | expectedResult actualResult class01 method |
    
    class01 := (model createClassImmediate: #DummyClassForTestCase01)
        package: #some_package01;
        yourself.

    method := model createMethodImmediate: class01 source: 'selector_01 ^ 1'.
    method package: #some_package01.

    context
        selectedPackages:(Array with:#some_package01).

    expectedResult := OrderedCollection new
        add: #selector_01;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder packageSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 01-11-2014 / 20:14:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 02-11-2014 / 13:31:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_packages_02
    |expectedResult actualResult class01 method01 method03 method04 method05 class02 method07 method08|
    
    class01 := model createClassImmediate: #DummyClassForTestCase01.
    method01 := model createMethodImmediate: class01 source: 'selector_01 ^ 1'.
    method01 package: #some_package01.
    model createMethodImmediate: class01 source: 'selector_02 ^ 2'.
    method03 := model createMethodImmediate: class01 source: 'selector_03 ^ 3'.
    method03 package: #some_package03.
    method04 := model createMethodImmediate: class01 class source: 'selector_04 ^ 4'.
    method04 package: #some_package02.
    method05 := model createMethodImmediate: class01 source: 'selector_05 ^ 5'.
    method05 package: #some_package01.

    class02 := model createClassImmediate: #DummyClassForTestCase02.
    model createMethodImmediate: class02 class source: 'selector_06 ^ 6'.
    method07 := model createMethodImmediate: class02 class source: 'selector_07 ^ 7'.
    method07 package: #some_package02.                              
    method08 := model createMethodImmediate: class02 class source: 'selector_08 ^ 8'.
    method08 package: #some_package03.                              

    context
        selectedPackages:(Array with:#some_package01 with:#some_package02).

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #selector_04;
        add: #selector_05;
        add: #selector_07;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder packageSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 02-11-2014 / 11:58:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:53:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_packages_03
    |expectedResult actualResult class01 class02|
    
    class01 := model createClass
        name: #DummyClassForTestCase01;
        compile;
        yourself.

    model createMethod class: class01; source: 'selector_01 ^ 1'; package: #some_package01; compile.
    model createMethod class: class01; source: 'selector_02 ^ 2'; compile.
    model createMethod class: class01; source: 'selector_03 ^ 3'; package: #some_package03; compile.
    model createMethod class: class01 theMetaclass; source: 'selector_04 ^ 4'; package: #some_package02; compile.
    model createMethod class: class01; source: 'selector_05 ^ 5'; package: #some_package01; compile.

    class02 := model createClass
        name: #DummyClassForTestCase02;
        compile;
        yourself.

    model createMethod class: class02 theMetaclass; source: 'selector_06 ^ 6'; compile.
    model createMethod class: class02 theMetaclass; source: 'selector_07 ^ 7'; package: #some_package02; compile.                              
    model createMethod class: class02 theMetaclass; source: 'selector_08 ^ 8'; package: #some_package03; compile.                              
    model createMethod class: class02; source: 'selector_09 ^ 9'; package: #some_package01; compile.                              

    context
        selectedPackages:(Array with:#some_package01 with:#some_package02).

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #selector_04;
        add: #selector_05;
        add: #selector_07;        
        add: #selector_09;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder packageSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 02-11-2014 / 16:52:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-11-2014 / 01:12:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_packages_empty_context
    | expectedResult actualResult |

    expectedResult := OrderedCollection new.
    actualResult := OrderedCollection new.

    refactoryBuilder packageSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    self assert: expectedResult = actualResult.

    "Created: / 02-11-2014 / 11:57:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_protocols_01
    | expectedResult actualResult class01 |
    
    class01 := model createClassImmediate: #DummyClassForTestCase01.
    model createMethodImmediate: class01 protocol: 'method protocol 01' source: 'selector_01 ^ 1' .

    context
        selectedClasses:(Array with:class01);  
        selectedProtocols:(Array with:'method protocol 01').

    expectedResult := OrderedCollection new
        add: #selector_01;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder protocolSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Modified: / 01-11-2014 / 16:28:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_protocols_02
    | expectedResult actualResult class01 |
    
    class01 := model createClassImmediate: #DummyClassForTestCase01.
    model createMethodImmediate: class01 protocol: 'method protocol 01' source: 'selector_01 ^ 1' .
    model createMethodImmediate: class01 protocol: 'method protocol 02' source: 'selector_02 ^ 2' .
    model createMethodImmediate: class01 protocol: 'method protocol 01' source: 'selector_03 ^ 3' .

    context
        selectedClasses:(Array with:class01);  
        selectedProtocols:(Array with:'method protocol 01').

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #selector_03;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder protocolSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 01-11-2014 / 16:29:12 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_protocols_03
    | expectedResult actualResult class01 class02 |
    
    class01 := model createClassImmediate: #DummyClassForTestCase01.
    model createMethodImmediate: class01 protocol: 'method protocol 01' source: 'selector_01 ^ 1' .
    model createMethodImmediate: class01 protocol: 'method protocol 02' source: 'selector_02 ^ 2' .
    model createMethodImmediate: class01 protocol: 'method protocol 01' source: 'selector_03 ^ 3' .

    class02 := model createClassImmediate: #DummyClassForTestCase02.
    model createMethodImmediate: class02 protocol: 'method protocol 02' source: 'selector_04 ^ 4' .

    context
        selectedClasses:(Array with:class01 with:class02);  
        selectedProtocols:(Array with:'method protocol 01').

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #selector_03;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder protocolSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 01-11-2014 / 16:34:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_protocols_04
    | expectedResult actualResult class01 class02 |
    
    class01 := model createClassImmediate: #DummyClassForTestCase01.
    model createMethodImmediate: class01 protocol: 'method protocol 01' source: 'selector_01 ^ 1' .
    model createMethodImmediate: class01 protocol: 'method protocol 02' source: 'selector_02 ^ 2' .
    model createMethodImmediate: class01 protocol: 'method protocol 01' source: 'selector_03 ^ 3' .

    class02 := model createClassImmediate: #DummyClassForTestCase02.
    model createMethodImmediate: class02 protocol: 'method protocol 02' source: 'selector_04 ^ 4' .
    model createMethodImmediate: class02 protocol: 'method protocol 01' source: 'selector_05 ^ 5' .

    context
        selectedClasses:(Array with:class01 with:class02);  
        selectedProtocols:(Array with:'method protocol 01').

    expectedResult := OrderedCollection new
        add: #selector_01;
        add: #selector_03;        
        add: #selector_05;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder protocolSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 01-11-2014 / 16:36:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_protocols_empty_classes
    | expectedResult actualResult class01 |
    
    class01 := model createClassImmediate: #DummyClassForTestCase01.
    model createMethodImmediate: class01 protocol: 'method protocol 01' source: 'selector_01 ^ 1' .

    context
        selectedProtocols:(Array with:'method protocol 01').

    expectedResult := OrderedCollection new
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder protocolSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 01-11-2014 / 17:07:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_protocols_empty_context
    | expectedResult actualResult |

    expectedResult := OrderedCollection new
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder protocolSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 01-11-2014 / 17:08:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_protocols_model_classes
    | expectedResult actualResult class01 |
    
    class01 := model createClass
        name: #DummyClassForTestCase01;
        compile;
        compile: 'selector_01 ^ 1' classified: 'method protocol 01';
        yourself.

    context
        selectedClasses:(Array with:class01);  
        selectedProtocols:(Array with:'method protocol 01').

    expectedResult := OrderedCollection new
        add: #selector_01;
        asSortedCollection.

    actualResult := OrderedCollection new.

    refactoryBuilder protocolSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    actualResult := actualResult asSortedCollection.

    self assert: expectedResult = actualResult.

    "Created: / 01-11-2014 / 16:41:38 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_selected_codes_01
    |source codeSelection resultsFoundCount |

    source := 'selector
    self information: ''Translate this''.
    ^ self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: source;
        selectedInterval: (32 to: 47).

    resultsFoundCount := 0.

    context selectedCodes: (Array with: codeSelection).  

    refactoryBuilder codeSelectionSearcher search: '`@code' 
        inContext: context 
        withResultDo: [ :codeSelection |
            resultsFoundCount := resultsFoundCount + 1
        ].

    self assert: resultsFoundCount = 1.

    "Created: / 04-11-2014 / 23:27:42 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 18:40:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_selected_codes_02
    |source codeSelection resultsFoundCount |

    source := 'selector
    self information: ''Translate this''.
    ^ self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: source;
        selectedInterval: (32 to: 47).

    resultsFoundCount := 0.

    context selectedCodes: (Array with: codeSelection).  

    refactoryBuilder codeSelectionSearcher search: '`#literal' 
        inContext: context 
        withResultDo: [ :codeSelection |
            resultsFoundCount := resultsFoundCount + 1
        ].

    self assert: resultsFoundCount = 1.

    "Created: / 04-11-2014 / 23:28:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 18:41:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_selected_codes_03
    |source codeSelection resultsFoundCount |

    source := 'selector
    self information: ''Translate this''.
    ^ self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: source;
        selectedInterval: (1 to: source size).

    resultsFoundCount := 0.

    context selectedCodes: (Array with: codeSelection).    

    refactoryBuilder codeSelectionSearcher search: '`#literal' 
        inContext: context
        withResultDo: [ :codeSelection |
            resultsFoundCount := resultsFoundCount + 1
        ].

    self assert: resultsFoundCount = 1.

    "Created: / 04-11-2014 / 23:28:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-11-2014 / 18:37:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_selected_codes_04
    |source codeSelection resultsFoundCount |

    source := 'selector
    self information: ''Translate this''.
    ^ self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: source;
        selectedInterval: (14 to: 51).

    resultsFoundCount := 0.

    context selectedCodes: (Array with: codeSelection).  

    refactoryBuilder codeSelectionSearcher search: '`@code' 
        inContext: context 
        withResultDo: [ :codeSelection |
            resultsFoundCount := resultsFoundCount + 1
        ].

    self assert: resultsFoundCount = 1.

    "Created: / 04-11-2014 / 23:28:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_selected_codes_05
    |source codeSelection resultsFoundCount |

    source := 'selector
    self information: ''Translate this''.
    ^ self.'.

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        currentSourceCode: source;
        selectedInterval: (30 to: 38).

    resultsFoundCount := 0.

    context selectedCodes: (Array with: codeSelection).  

    self should: [ 
        refactoryBuilder codeSelectionSearcher search: '`@code' 
            inContext: context 
            withResultDo: [ :codeSelection |
                resultsFoundCount := resultsFoundCount + 1
            ].
    ] raise: Error.

    "Created: / 04-11-2014 / 23:29:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_context_with_result_do_selected_codes_empty_context
    | expectedResult actualResult |

    expectedResult := OrderedCollection new.
    actualResult := OrderedCollection new.

    refactoryBuilder codeSelectionSearcher search:'`@something' inContext:context withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedSelector    
    ].    

    self assert: expectedResult = actualResult.

    "Modified: / 04-11-2014 / 23:26:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_method_with_result_do_model_method_01
    |expectedResult actualResult method|

    method := model createMethod
        source:'selector_01 ^ 1';
        yourself.

    expectedResult := OrderedCollection new
        add:method;
        yourself.

    actualResult := OrderedCollection new.

    refactoryBuilder methodSearcher search:'`@something' inMethod:method withResultDo:[ :sourceSelection | 
        actualResult add:sourceSelection selectedMethod 
    ].

    self assert:expectedResult = actualResult.

    "Created: / 04-11-2014 / 23:15:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_method_with_result_do_model_method_02
    | expectedResult actualResult method |

    method := model createMethod
        source: 'selector_01 ^ 1';
        yourself. 

    expectedResult := OrderedCollection new
        add: method;
        yourself.

    actualResult := OrderedCollection new.

    refactoryBuilder methodSearcher search:'`#literal' inMethod:method withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedMethod    
    ].    

    self assert: expectedResult = actualResult.

    "Created: / 04-11-2014 / 23:16:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_method_with_result_do_model_method_03
    |expectedResult actualResult method|

    method := model createMethod
        source:'selector_01 ^ self';
        yourself.

    expectedResult := OrderedCollection new.
    actualResult := OrderedCollection new.

    refactoryBuilder methodSearcher search:'`#literal' inMethod:method withResultDo:[ :sourceSelection | 
        actualResult add:sourceSelection selectedMethod 
    ].

    self assert:expectedResult = actualResult.

    "Created: / 04-11-2014 / 23:19:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_search_in_method_with_result_do_real_method
    | expectedResult actualResult class method |

    class := model createClassImmediate: #DummyClass01.
    method := model createMethodImmediate: class source: 'selector_01 ^ 1'. 

    expectedResult := OrderedCollection new
        add: method;
        yourself.

    actualResult := OrderedCollection new.

    refactoryBuilder methodSearcher search:'`@something' inMethod:method withResultDo:[ :sourceSelection |
        actualResult add: sourceSelection selectedMethod    
    ].    

    self assert: expectedResult = actualResult.

    "Modified: / 04-11-2014 / 23:14:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRefactoryBuilderTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

